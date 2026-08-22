#Requires -Version 7.4

# Get Defender path
$DefenderPath = (Get-ChildItem -Path "$env:ProgramData\Microsoft\Windows Defender\Platform" -Directory | Sort-Object Name -Descending | Select-Object -First 1).FullName

# Update Defender definitions
& "$DefenderPath\MpCmdRun.exe" -SignatureUpdate -Verbose

# Start scan
# We need to use absolute path
& "$DefenderPath\MpCmdRun.exe" -Scan -ScanType 3 -DisableRemediation -File $((Get-Item -Path Sophia_Script).FullName) | ForEach-Object {Write-Verbose -Message $_ -Verbose}

Get-Content -Path $env:TEMP\MpCmdRun.log

$Reports = [System.Collections.Generic.List[PSCustomObject]]::new()

$Headers = @{
	"x-apikey" = $env:VirusTotal_API_Key
}

foreach ($File in @(Get-ChildItem -Path Sophia_Script -File))
{
	if ($File.Length -gt 32MB)
	{
		Write-Verbose -Message "$($File.Name) is large than 32MB. Use upload_url endpoint endpoint" -Verbose

		# Exit with a non-zero status to fail the job
		exit 1
	}

	$Stats = $null

	$SHA256 = (Get-FileHash -Path $File.FullName -Algorithm SHA256).Hash.ToLower()
	$Parameters = @{
		Uri                = "https://www.virustotal.com/api/v3/files/$SHA256"
		Headers            = $Headers
		StatusCodeVariable = "StatusCode"
		# Suspend HTTP error to leave a raw HTTP code
		SkipHttpErrorCheck = $true
		UseBasicParsing    = $true
		Verbose            = $true
	}
	$Response = Invoke-RestMethod @Parameters

	# If a file was already checked it outputs a raw JSON, so we need to check this first
	if ($Response -is [string])
	{
		$Response = $Response | ConvertFrom-Json -AsHashtable
	}

	switch ($StatusCode)
	{
		# File was already scanned
		200
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message "$($File.Name) already scanned before" -Verbose

			$Stats = $Response.data.attributes.last_analysis_stats
		}
		# File was not scanned before
		404
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message "Uploading $($File.Name)..." -Verbose

			$Parameters = @{
				Uri             = "https://www.virustotal.com/api/v3/files"
				Method          = "Post"
				Headers         = $Headers
				Form            = @{file = $File}
				UseBasicParsing = $true
				Verbose         = $true
			}
			$Response = Invoke-RestMethod @Parameters

			do
			{
				Start-Sleep -Seconds 20

				$Parameters = @{
					Uri             = "https://www.virustotal.com/api/v3/analyses/$($Response.data.id)"
					Headers         = $Headers
					UseBasicParsing = $true
					Verbose         = $true
				}
				$Analysis = Invoke-RestMethod @Parameters

				Write-Verbose -Message "Status of $($File.Name): $($Analysis.data.attributes.status)" -Verbose
			}
			until ($Analysis.data.attributes.status -eq "completed")

			# Read the verdict from the same endpoint the 200 branch uses
			$Parameters = @{
				Uri                = "https://www.virustotal.com/api/v3/files/$SHA256"
				Headers            = $Headers
				StatusCodeVariable = "ReportCode"
				SkipHttpErrorCheck = $true
				Verbose            = $true
			}

			do
			{
				Start-Sleep -Seconds 20

				$Response = Invoke-RestMethod @Parameters

				if ($Response -is [string])
				{
					$Response = $Response | ConvertFrom-Json -AsHashtable
				}

				if ($ReportCode -ne 200)
				{
					Write-Verbose -Message "Waiting for the verdict on $($File.Name)..." -Verbose
				}
			}
			until ($ReportCode -eq 200)

			$Stats = $Response.data.attributes.last_analysis_stats
		}
	}

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
