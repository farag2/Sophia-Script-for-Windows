# Check module

Write-Verbose -Message "Run Lint" -Verbose

$Results = @(Get-ChildItem -Path src -File -Recurse -Include *.ps1, *.psm1 | Invoke-ScriptAnalyzer)
if ($Results | Where-Object -FilterScript {($_.Severity -eq "Error") -or ($_.Severity -eq "ParseError")})
{
	Write-Verbose -Message "Found script issue" -Verbose

	$Results | Where-Object -FilterScript {($_.Severity -eq "Error") -or ($_.Severity -eq "ParseError")} | ForEach-Object -Process {
	[PSCustomObject]@{
		Line	= $_.Line
		Message = $_.Message
		Path	= $_.ScriptPath
	}
	} | Format-Table -AutoSize -Wrap

	# Exit with a non-zero status to fail the job
	exit 1
}


Write-Verbose -Message "Check JSONs validity" -Verbose

# Check JSONs
$JSONs = [Array]::TrueForAll((@(Get-ChildItem -Path Wrapper -File -Recurse -Filter *.json).FullName),
[Predicate[string]]{
	param($JSON)

	Test-Json -Path $JSON -ErrorAction Ignore
})
if (-not $JSONs)
{
	Write-Verbose -Message "Found JSON issue" -Verbose
	# Exit with a non-zero status to fail the job
	exit 1
}

Write-Verbose -Message "Check psd1 files" -Verbose

# Check psd1 files
function Parse-PSD1
{
	[CmdletBinding()]
	param
	(
		[Microsoft.PowerShell.DesiredStateConfiguration.ArgumentToConfigurationDataTransformation()]
		[hashtable]
		$Path
	)

	return $Path
}

Get-ChildItem -Path src -File -Filter *.psd1 -Recurse | ForEach-Object -Process {
	$File = $_.FullName

	try
	{
		Parse-PSD1 -Path $_.FullName -ErrorAction Stop | Out-Null
	}
	catch
	{
		Write-Verbose -Message $File -Verbose
		# Exit with a non-zero status to fail the job
		exit 1
	}
}
