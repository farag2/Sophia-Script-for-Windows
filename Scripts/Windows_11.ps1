# https://github.com/farag2/Sophia-Script-for-Windows/blob/master/sophia_script_versions.json
$Parameters = @{
	Uri = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json"
}
$Latest_Release_Windows_11_PowerShell_5_1 = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_11_PowerShell_5_1

Write-Verbose -Message "Sophia.Script.for.Windows.11.v$Latest_Release_Windows_11_PowerShell_5_1.zip" -Verbose

New-Item -Path "Sophia_Script_for_Windows_11_v$Latest_Release_Windows_11_PowerShell_5_1\Binaries" -ItemType Directory -Force

$Parameters = @{
	Path        = @("Scripts\LGPO.exe")
	Destination = "Sophia_Script_for_Windows_11_v$Latest_Release_Windows_11_PowerShell_5_1\Binaries"
	Recurse     = $true
	Force       = $true
}
Copy-Item @Parameters

Get-ChildItem -Path "src\Sophia_Script_for_Windows_11" -Force | Copy-Item -Destination "Sophia_Script_for_Windows_11_v$Latest_Release_Windows_11_PowerShell_5_1" -Recurse -Force

$Parameters = @{
	Path             = "Sophia_Script_for_Windows_11_v$Latest_Release_Windows_11_PowerShell_5_1"
	DestinationPath  = "Sophia.Script.for.Windows.11.v$Latest_Release_Windows_11_PowerShell_5_1.zip"
	CompressionLevel = "Fastest"
	Force            = $true
}
Compress-Archive @Parameters
