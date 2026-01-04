$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json"
	UseBasicParsing = $true
	Verbose         = $true
}
$Latest_Release = Invoke-RestMethod @Parameters

$Parameters = @{
	Uri             = "https://api.github.com/repos/farag2/Sophia-Script-for-Windows/releases/latest"
	UseBasicParsing = $true
	Verbose         = $true
}
$assets = (Invoke-RestMethod @Parameters).assets

# Get SHA256 hash sum of each asset
$Sophia_Script_Windows_10_PowerShell_5_1     = ($assets | Where-Object -FilterScript {$_.name -eq "Sophia.Script.for.Windows.10.v$($Latest_Release.Sophia_Script_Windows_10_PowerShell_5_1).zip"}).digest.Replace("sha256:", "")
$Sophia_Script_Windows_10_PowerShell_7       = ($assets | Where-Object -FilterScript {$_.name -eq "Sophia.Script.for.Windows.10.PowerShell.7.v$($Latest_Release.Sophia_Script_Windows_10_PowerShell_7).zip"}).digest.Replace("sha256:", "")
$Sophia_Script_Windows_10_LTSC2019           = ($assets | Where-Object -FilterScript {$_.name -eq "Sophia.Script.for.Windows.10.LTSC.2019.v$($Latest_Release.Sophia_Script_Windows_10_LTSC2019).zip"}).digest.Replace("sha256:", "")
$Sophia_Script_Windows_10_LTSC2021           = ($assets | Where-Object -FilterScript {$_.name -eq "Sophia.Script.for.Windows.10.LTSC.2021.v$($Latest_Release.Sophia_Script_Windows_10_LTSC2021).zip"}).digest.Replace("sha256:", "")
$Sophia_Script_Windows_11_PowerShell_5_1     = ($assets | Where-Object -FilterScript {$_.name -eq "Sophia.Script.for.Windows.11.v$($Latest_Release.Sophia_Script_Windows_11_PowerShell_5_1).zip"}).digest.Replace("sha256:", "")
$Sophia_Script_Windows_11_Arm_PowerShell_5_1 = ($assets | Where-Object -FilterScript {$_.name -eq "Sophia.Script.for.Windows.11.v$($Latest_Release.Sophia_Script_Windows_11_Arm_PowerShell_5_1).zip"}).digest.Replace("sha256:", "")
$Sophia_Script_Windows_11_Arm_PowerShell_7   = ($assets | Where-Object -FilterScript {$_.name -eq "Sophia.Script.for.Windows.11.v$($Latest_Release.Sophia_Script_Windows_11_Arm_PowerShell_7).zip"}).digest.Replace("sha256:", "")
$Sophia_Script_Windows_11_PowerShell_7       = ($assets | Where-Object -FilterScript {$_.name -eq "Sophia.Script.for.Windows.11.PowerShell.7.v$($Latest_Release.Sophia_Script_Windows_11_PowerShell_7).zip"}).digest.Replace("sha256:", "")
$Sophia_Script_Windows_11_LTSC2024           = ($assets | Where-Object -FilterScript {$_.name -eq "Sophia.Script.for.Windows.11.LTSC.2024.v$($Latest_Release.Sophia_Script_Windows_11_LTSC2024).zip"}).digest.Replace("sha256:", "")

# Replace variables with script latest versions
(Get-Content -Path "chocolatey\tools\chocolateyinstall.ps1" -Encoding utf8 -Raw) | Foreach-Object -Process {
  $_ -replace "Hash_Sophia_Script_Windows_10_PowerShell_5_1", $Sophia_Script_Windows_10_PowerShell_5_1 `
  -replace "Hash_Sophia_Script_Windows_10_PowerShell_7", $Sophia_Script_Windows_10_PowerShell_7 `
  -replace "Hash_Sophia_Script_Windows_10_LTSC2019", $Sophia_Script_Windows_10_LTSC2019 `
  -replace "Hash_Sophia_Script_Windows_10_LTSC2021", $Sophia_Script_Windows_10_LTSC2021 `
  -replace "Hash_Sophia_Script_Windows_11_PowerShell_5_1", $Sophia_Script_Windows_11_PowerShell_5_1 `
  -replace "Hash_Sophia_Script_Windows_11_Arm_PowerShell_5_1", $Sophia_Script_Windows_11_Arm_PowerShell_5_1 `
  -replace "Hash_Sophia_Script_Windows_11_Arm_PowerShell_7", $Sophia_Script_Windows_11_Arm_PowerShell_7 `
  -replace "Hash_Sophia_Script_Windows_11_PowerShell_7", $Sophia_Script_Windows_11_PowerShell_7 `
  -replace "Hash_Sophia_Script_Windows_11_LTSC2024", $Sophia_Script_Windows_11_LTSC2024
} | Set-Content -Path "chocolatey\tools\chocolateyinstall.ps1" -Encoding utf8 -Force

# Save latest release tag for sophia.nuspec
$LatestRelease = $Latest_Release.Sophia_Script_Windows_11_PowerShell_5_1
"LatestRelease=$LatestRelease" >> $env:GITHUB_ENV
