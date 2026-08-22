# Get a penultimate build tag
$Headers = @{
	Accept        = "application/vnd.github+json"
	Authorization = "Bearer $env:GITHUB_TOKEN"
}
$Parameters = @{
	Uri             = "https://api.github.com/repos/farag2/Sophia-Script-for-Windows/releases"
	Headers         = $Headers
	UseBasicParsing = $true
	Verbose         = $true
}
$OldTag = (Invoke-RestMethod @Parameters).tag_name | Select-Object -First 1

# Parse json for the latest script versions
$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/main/sophia_script_versions.json"
	UseBasicParsing = $true
	Verbose         = $true
}
$JSON = Invoke-RestMethod @Parameters

# Replace variables with script latest versions
(Get-Content -Path ReleaseNotesTemplate.md -Encoding utf8 -Raw) | Foreach-Object -Process {
	# ${{ github.ref_name }}
	$_ -replace "NewVersion", $env:INPUT_TAG `
	-replace "OldVersion", $OldTag `
	-replace "Sophia_Script_Windows_10_PowerShell_5_1", $JSON.Sophia_Script_Windows_10_PowerShell_5_1 `
	-replace "Sophia_Script_Windows_10_PowerShell_7", $JSON.Sophia_Script_Windows_10_PowerShell_7 `
	-replace "Sophia_Script_Windows_10_LTSC2019", $JSON.Sophia_Script_Windows_10_LTSC2019 `
	-replace "Sophia_Script_Windows_10_LTSC2021", $JSON.Sophia_Script_Windows_10_LTSC2021 `
	-replace "Sophia_Script_Windows_11_PowerShell_5_1", $JSON.Sophia_Script_Windows_11_PowerShell_5_1 `
	-replace "Sophia_Script_Windows_11_PowerShell_7", $JSON.Sophia_Script_Windows_11_PowerShell_7 `
	-replace "Sophia_Script_Windows_11_Arm_PowerShell_5_1", $JSON.Sophia_Script_Windows_11_Arm_PowerShell_5_1 `
	-replace "Sophia_Script_Windows_11_Arm_PowerShell_7", $JSON.Sophia_Script_Windows_11_Arm_PowerShell_7 `
	-replace "Sophia_Script_Windows_11_LTSC2024_PowerShell_5_1", $JSON.Sophia_Script_Windows_11_LTSC2024_PowerShell_5_1 `
	-replace "Sophia_Script_Windows_11_LTSC2024_PowerShell_7", $JSON.Sophia_Script_Windows_11_LTSC2024_PowerShell_7 `
	-replace "Sophia_Script_Wrapper", $JSON.Sophia_Script_Wrapper
} | Set-Content -Path ReleaseNotesTemplate.md -Encoding utf8 -Force

# https://trstringer.com/github-actions-multiline-strings/
Add-Content -Path $env:GITHUB_OUTPUT -Value "ReleaseBody=ReleaseNotesTemplate.md"

$ReleaseName = Get-Date -f "dd.MM.yyyy"
echo "RELEASE_NAME=$ReleaseName" >> $env:GITHUB_ENV
