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

# ###
$Archives = [ordered]@{
	"Sophia_Script_Windows_10_PowerShell_5_1"          = "Sophia.Script.for.Windows.10.v$($JSON.Sophia_Script_Windows_10_PowerShell_5_1).zip"
	"Sophia_Script_Windows_10_PowerShell_7"            = "Sophia.Script.for.Windows.10.PowerShell.7.v$($JSON.Sophia_Script_Windows_10_PowerShell_7).zip"
	"Sophia_Script_Windows_10_LTSC2019"                = "Sophia.Script.for.Windows.10.LTSC.2019.v$($JSON.Sophia_Script_Windows_10_LTSC2019).zip"
	"Sophia_Script_Windows_10_LTSC2021"                = "Sophia.Script.for.Windows.10.LTSC.2021.v$($JSON.Sophia_Script_Windows_10_LTSC2021).zip"
	"Sophia_Script_Windows_11_PowerShell_5_1"          = "Sophia.Script.for.Windows.11.v$($JSON.Sophia_Script_Windows_11_PowerShell_5_1).zip"
	"Sophia_Script_Windows_11_PowerShell_7"            = "Sophia.Script.for.Windows.11.PowerShell.7.v$($JSON.Sophia_Script_Windows_11_PowerShell_7).zip"
	"Sophia_Script_Windows_11_LTSC2024_PowerShell_5_1" = "Sophia.Script.for.Windows.11.LTSC.2024.v$($JSON.Sophia_Script_Windows_11_LTSC2024_PowerShell_5_1).zip"
	"Sophia_Script_Windows_11_LTSC2024_PowerShell_7"   = "Sophia.Script.for.Windows.11.LTSC.2024.PowerShell.7.v$($JSON.Sophia_Script_Windows_11_LTSC2024_PowerShell_7).zip"
	"Sophia_Script_Windows_11_Arm_PowerShell_5_1"      = "Sophia.Script.for.Windows.11.Arm.v$($JSON.Sophia_Script_Windows_11_Arm_PowerShell_5_1).zip"
	"Sophia_Script_Windows_11_Arm_PowerShell_7"        = "Sophia.Script.for.Windows.11.Arm.PowerShell.7.v$($JSON.Sophia_Script_Windows_11_Arm_PowerShell_7).zip"
	"Sophia_Script_Wrapper"                            = "Sophia.Script.Wrapper.v$($JSON.Sophia_Script_Wrapper).zip"
}

$Hashes = [ordered]@{}

foreach ($Token in $Archives.Keys)
{
	$Hashes[$Token] = (Get-FileHash -Path "Sophia_Script\$($Archives[$Token])" -Algorithm SHA256).Hash.ToLower()
	Write-Verbose -Message "$($Archive.Name): $($Hashes[$Token])" -Verbose
}

# Replace variables with script latest versions
(Get-Content -Path ReleaseNotesTemplate.md -Encoding utf8 -Raw) | Foreach-Object -Process {
	# ${{ github.ref_name }}
	# Hashes go first: SHA256_Sophia_Script_* contains the version token as a substring
	$_ -replace "SHA256_Sophia_Script_Windows_10_PowerShell_5_1", $Hashes.Sophia_Script_Windows_10_PowerShell_5_1 `
	-replace "SHA256_Sophia_Script_Windows_10_PowerShell_7", $Hashes.Sophia_Script_Windows_10_PowerShell_7 `
	-replace "SHA256_Sophia_Script_Windows_10_LTSC2019", $Hashes.Sophia_Script_Windows_10_LTSC2019 `
	-replace "SHA256_Sophia_Script_Windows_10_LTSC2021", $Hashes.Sophia_Script_Windows_10_LTSC2021 `
	-replace "SHA256_Sophia_Script_Windows_11_PowerShell_5_1", $Hashes.Sophia_Script_Windows_11_PowerShell_5_1 `
	-replace "SHA256_Sophia_Script_Windows_11_PowerShell_7", $Hashes.Sophia_Script_Windows_11_PowerShell_7 `
	-replace "SHA256_Sophia_Script_Windows_11_Arm_PowerShell_5_1", $Hashes.Sophia_Script_Windows_11_Arm_PowerShell_5_1 `
	-replace "SHA256_Sophia_Script_Windows_11_Arm_PowerShell_7", $Hashes.Sophia_Script_Windows_11_Arm_PowerShell_7 `
	-replace "SHA256_Sophia_Script_Windows_11_LTSC2024_PowerShell_5_1", $Hashes.Sophia_Script_Windows_11_LTSC2024_PowerShell_5_1 `
	-replace "SHA256_Sophia_Script_Windows_11_LTSC2024_PowerShell_7", $Hashes.Sophia_Script_Windows_11_LTSC2024_PowerShell_7 `
	-replace "SHA256_Sophia_Script_Wrapper", $Hashes.Sophia_Script_Wrapper `

	-replace "NewVersion", $env:INPUT_TAG `
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
