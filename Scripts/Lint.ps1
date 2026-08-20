# Check module

Write-Verbose -Message "PowerShell ScriptAnalyzer" -Verbose

$Results = @(Get-ChildItem -Path src -File -Recurse -Include *.ps1, *.psm1 | Invoke-ScriptAnalyzer)
if ($Results | Where-Object -FilterScript {($_.Severity -eq "Error") -or ($_.Severity -eq "ParseError")})
{
	Write-Verbose -Message "Found script issue" -Verbose

	$Results | Where-Object -FilterScript {($_.Severity -eq "Error") -or ($_.Severity -eq "ParseError")} | ForEach-Object -Process {
	[PSCustomObject]@{
		Line    = $_.Line
		Message = $_.Message
		Path    = $_.ScriptPath
	}
	} | Format-Table -AutoSize -Wrap

	# Exit with a non-zero status to fail the job
	exit 1
}

Write-Verbose -Message "JSONs validity" -Verbose

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
	# try/catch expects for $Error variable
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

Write-Verbose -Message "Localizations integrity" -Verbose
foreach ($Folder in @(Get-ChildItem -Path src -Directory))
{
	Import-LocalizedData -BindingVariable Localization -UICulture $PSUICulture -BaseDirectory "$($Folder.FullName)\Module\Localizations" -FileName Sophia

	foreach ($Key in $Localization.Keys)
	{
		$Paths = @(
			"$($Folder.FullName)\Module\Sophia.psm1",
			"$($Folder.FullName)\Module\Private\InitialActions.ps1",
			"$($Folder.FullName)\Module\Private\PostActions.ps1",
			"$($Folder.FullName)\Module\Private\Set-UserShellFolder.ps1",
			"$($Folder.FullName)\Module\Private\Show-Menu.ps1",
			"$($Folder.FullName)\Import-TabCompletion.ps1"
		)

		if (-not ((Get-Content -Path $Paths -Raw) -match $Key))
		{
			Write-Verbose -Message "$Key was not found in $Folder.FullName folder" -Verbose
			# Exit with a non-zero status to fail the job
			exit 1
		}
	}
}

Write-Verbose -Message "Localizations language contamination" -Verbose

# Distinctive fragments that mean a string was copied from the wrong culture.
$ContaminationMarkers = [ordered]@{
	"en-US" = @("Your're", "archicture", "was ran on behalf", "has no a built-in")
	"fr-FR" = @("Los comandos de shell")
	"hu-HU" = @("Vous utilisez Windows", "Ponovno instalirajte", "Ponovo pokrenite")
	"it-IT" = @("rendszert használ")
	"pl-PL" = @("rendszert használ", "Nincs letiltandó", "Nincs letiltható", "Lo spazio di archiviazione riservato")
	"pt-BR" = @("rendszert használ")
	"tr-TR" = @("rendszert használ", "está faltando")
}

$CyrillicEs = [char]0x0421
$ContaminationFound = $false

Get-ChildItem -Path src -File -Filter Sophia.psd1 -Recurse | ForEach-Object -Process {
	$Culture = $_.Directory.Name
	$Content = Get-Content -Path $_.FullName -Raw

	if ($Culture -eq "en-US")
	{
		if ($Content.Contains("$($CyrillicEs)ontrolled"))
		{
			Write-Verbose -Message "Cyrillic Es in 'Controlled' in $($_.FullName)" -Verbose
			$script:ContaminationFound = $true
		}
	}

	if ($Culture -eq "zh-CN")
	{
		if ($Content -match '(?m)^OneDriveNotInstalled\s*=\s*已安装第三方开始菜单')
		{
			Write-Verbose -Message "OneDriveNotInstalled copied from CustomStartMenuFound in $($_.FullName)" -Verbose
			$script:ContaminationFound = $true
		}

		return
	}

	if ($Culture -eq "hu-HU")
	{
		if ($Content -match '(?m)^UWPAppsTitle\s*=\s*Nincs eltávolítandó UWP-alkalmazás')
		{
			Write-Verbose -Message "UWPAppsTitle copied from NoUWPAppsFound in $($_.FullName)" -Verbose
			$script:ContaminationFound = $true
		}
	}

	if (-not $ContaminationMarkers.Contains($Culture))
	{
		return
	}

	foreach ($Marker in $ContaminationMarkers[$Culture])
	{
		if ($Content.Contains($Marker))
		{
			Write-Verbose -Message "Wrong-language fragment '$Marker' in $($_.FullName)" -Verbose
			$script:ContaminationFound = $true
		}
	}
}

if ($ContaminationFound)
{
	Write-Verbose -Message "Found localization language contamination" -Verbose
	exit 1
}
