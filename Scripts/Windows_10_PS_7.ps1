# https://github.com/farag2/Sophia-Script-for-Windows/blob/master/sophia_script_versions.json
$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json"
	UseBasicParsing = $true
	Verbose         = $true
}
$Latest_Release_Windows_10_PowerShell_7 = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_10_PowerShell_7

Write-Verbose -Message "Sophia.Script.for.Windows.10.PowerShell.7.v$Latest_Release_Windows_10_PowerShell_7.zip" -Verbose

New-Item -Path "Sophia_Script\Sophia_Script_for_Windows_10_PowerShell_7_v$Latest_Release_Windows_10_PowerShell_7\Binaries" -ItemType Directory -Force

# Copy Windows 10 PS 7 version to new folder
Get-ChildItem -Path "src\Sophia_Script_for_Windows_10_PowerShell_7" -Force | Copy-Item -Destination "Sophia_Script\Sophia_Script_for_Windows_10_PowerShell_7_v$Latest_Release_Windows_10_PowerShell_7" -Recurse -Force

# Add LGPO.exe, WinRT.Runtime.dll, and Microsoft.Windows.SDK.NET.dll
$Parameters = @{
	Path        = @("Sophia_Script\LGPO.exe", "Sophia_Script\WinRT.Runtime.dll", "Sophia_Script\Microsoft.Windows.SDK.NET.dll")
	Destination = "Sophia_Script\Sophia_Script_for_Windows_10_PowerShell_7_v$Latest_Release_Windows_10_PowerShell_7\Binaries"
	Recurse     = $true
	Force       = $true
}
Copy-Item @Parameters

$Parameters = @{
	Path             = "Sophia_Script\Sophia_Script_for_Windows_10_PowerShell_7_v$Latest_Release_Windows_10_PowerShell_7"
	DestinationPath  = "Sophia_Script\Sophia.Script.for.Windows.10.PowerShell.7.v$Latest_Release_Windows_10_PowerShell_7.zip"
	CompressionLevel = "Fastest"
	Force            = $true
}
Compress-Archive @Parameters
