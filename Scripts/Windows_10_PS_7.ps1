# https://github.com/farag2/Sophia-Script-for-Windows/blob/master/sophia_script_versions.json
$Parameters = @{
	Uri = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json"
}
$Latest_Release_Windows_10_PowerShell_7 = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_10_PowerShell_7

Write-Verbose -Message "Sophia.Script.for.Windows.10.PowerShell.7.v$Latest_Release_Windows_10_PowerShell_7.zip" -Verbose

New-Item -Path "Sophia_Script_for_Windows_10_PowerShell_7_v$Latest_Release_Windows_10_PowerShell_7\Binaries" -ItemType Directory -Force

$Parameters = @{
	Path        = @("Scripts\LGPO.exe", "Scripts\WinRT.Runtime.dll", "Scripts\Microsoft.Windows.SDK.NET.dll")
	Destination = "Sophia_Script_for_Windows_10_PowerShell_7_v$Latest_Release_Windows_10_PowerShell_7\Binaries"
	Recurse     = $true
	Force       = $true
}
Copy-Item @Parameters

Get-ChildItem -Path "src\Sophia_Script_for_Windows_10_PowerShell_7" -Force | Copy-Item -Destination "Sophia_Script_for_Windows_10_PowerShell_7_v$Latest_Release_Windows_10_PowerShell_7" -Recurse -Force

$Parameters = @{
	Path             = "Sophia_Script_for_Windows_10_PowerShell_7_v$Latest_Release_Windows_10_PowerShell_7"
	DestinationPath  = "Sophia.Script.for.Windows.10.PowerShell.7.v$Latest_Release_Windows_10_PowerShell_7.zip"
	CompressionLevel = "Fastest"
	Force            = $true
}
Compress-Archive @Parameters
