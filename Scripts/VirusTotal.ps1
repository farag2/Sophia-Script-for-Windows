#Requires -Version 7.4

# Get Defender path
$DefenderPath = (Get-ChildItem -Path "$env:ProgramData\Microsoft\Windows Defender\Platform" -Directory | Sort-Object Name -Descending | Select-Object -First 1).FullName

# Update Defender definitions
& "$DefenderPath\MpCmdRun.exe" -SignatureUpdate

# Start scan
# We need to use absolute path
& "$DefenderPath\MpCmdRun.exe" -Scan -ScanType 3 -DisableRemediation -File $((Get-Item -Path Sophia_Script).FullName) | ForEach-Object {Write-Verbose -Message $_ -Verbose}

Get-Content -Path $env:TEMP\MpCmdRun.log

$Headers = @{
	"x-apikey" = $env:VirusTotal_API_Key
}

# Public API allows 4 requests per minute, so we make one request every 15 seconds. Set to 0 for a premium API key
$RequestInterval = 15
# How long to wait for the verdict on each file
$TimeoutMinutes = 15

$Script:LastRequest = [datetime]::MinValue

function Invoke-VirusTotal
{
	param
	(
		[Parameter(Mandatory = $true)]
		[string]
		$Uri,

		[string]
		$Method = "Get",

		[hashtable]
		$Form
	)

	$Parameters = @{
		Uri                = $Uri
		Method             = $Method
		Headers            = $Headers
		StatusCodeVariable = "StatusCode"
		# Suspend HTTP error to leave a raw HTTP code
		SkipHttpErrorCheck = $true
		UseBasicParsing    = $true
		Verbose            = $true
	}
	if ($Form)
	{
		$Parameters.Form = $Form
	}

	# Retry if quota exceeded (HTTP 429)
	for ($Try = 1; $Try -le 5; $Try++)
	{
		# Keep the interval between requests
		$Wait = $RequestInterval - ((Get-Date) - $Script:LastRequest).TotalSeconds
		if ($Wait -gt 0)
		{
			Start-Sleep -Milliseconds ([int]($Wait * 1000))
		}

		$Body = Invoke-RestMethod @Parameters
		$Script:LastRequest = Get-Date

		if ($StatusCode -ne 429)
		{
			break
		}

		Write-Verbose -Message "Quota exceeded. Waiting 60 seconds..." -Verbose
		Start-Sleep -Seconds 60
	}

	# Some responses come as a raw JSON (e.g. keys differ only by case), so we need to convert them manually
	if ($Body -is [string])
	{
		$Body = $Body | ConvertFrom-Json -AsHashtable
	}

	[PSCustomObject]@{
		StatusCode = $StatusCode
		Body       = $Body
	}
}

$Files = @(Get-ChildItem -Path Sophia_Script -File)

# Check sizes before any request to fail early
foreach ($File in $Files)
{
	if ($File.Length -gt 32MB)
	{
		Write-Verbose -Message "$($File.Name) is larger than 32 MB. Use upload_url endpoint" -Verbose

		# Exit with a non-zero status to fail the job
		exit 1
	}
}

$Reports = [System.Collections.Generic.List[PSCustomObject]]::new()

foreach ($File in $Files)
{
	Write-Information -MessageData "" -InformationAction Continue
	Write-Verbose -Message "Uploading $($File.Name)..." -Verbose

	# Archives are always new, so we do not check if VirusTotal has seen them before
	$Upload = Invoke-VirusTotal -Uri "https://www.virustotal.com/api/v3/files" -Method Post -Form @{file = $File}

	# E.g. 401 (wrong API key)
	if ($Upload.StatusCode -ne 200)
	{
		Write-Verbose -Message "VirusTotal returned HTTP $($Upload.StatusCode) while uploading $($File.Name)" -Verbose

		# Exit with a non-zero status to fail the job
		exit 1
	}

	# Hash is calculated locally and needed for the report URL and verdict
	$SHA256 = (Get-FileHash -Path $File.FullName -Algorithm SHA256).Hash.ToLower()

	# We do not use /analyses/{id}: it may return 404 for a long time even after a successful upload
	# The file report is requested by the locally calculated hash instead
	$Stats = $null
	$Deadline = (Get-Date).AddMinutes($TimeoutMinutes)

	do
	{
		if ((Get-Date) -gt $Deadline)
		{
			Write-Verbose -Message "Verdict on $($File.Name) is not available after $TimeoutMinutes minutes" -Verbose

			# Exit with a non-zero status to fail the job
			exit 1
		}

		Start-Sleep -Seconds 20

		$Report = Invoke-VirusTotal -Uri "https://www.virustotal.com/api/v3/files/$SHA256"

		switch ($Report.StatusCode)
		{
			200
			{
				# The file object may already exist while the analysis is still in progress
				if ($null -ne $Report.Body.data.attributes.last_analysis_date)
				{
					Write-Verbose -Message "Verdict on $($File.Name) received" -Verbose

					$Stats = $Report.Body.data.attributes.last_analysis_stats
				}
				else
				{
					Write-Verbose -Message "$($File.Name) is still being analyzed" -Verbose
				}
			}
			# File is not processed yet
			404
			{
				Write-Verbose -Message "Waiting for the verdict on $($File.Name)..." -Verbose
			}
			default
			{
				Write-Verbose -Message "VirusTotal returned HTTP $($Report.StatusCode) for report of $($File.Name)" -Verbose

				# Exit with a non-zero status to fail the job
				exit 1
			}
		}
	}
	until ($null -ne $Stats)

	$Reports.Add([PSCustomObject]@{
		Name       = $File.Name
		Hash       = $SHA256
		URL        = "https://www.virustotal.com/gui/file/$($SHA256)"
		Malicious  = $Stats.malicious
		Suspicious = $Stats.suspicious
		Undetected = $Stats.undetected
	})
}

$Reports | Format-List
