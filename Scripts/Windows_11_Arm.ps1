# https://github.com/farag2/Sophia-Script-for-Windows/blob/master/sophia_script_versions.json
$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json"
	UseBasicParsing = $true
	Verbose         = $true
}
$Latest_Release_Windows_11_Arm_PowerShell_5_1 = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_11_PowerShell_5_1

Write-Verbose -Message "Sophia.Script.for.Windows.11.Arm.v$Latest_Release_Windows_11_Arm_PowerShell_5_1.zip" -Verbose

New-Item -Path "Sophia_Script\Sophia_Script_for_Windows_11_Arm_v$Latest_Release_Windows_11_Arm_PowerShell_5_1\Binaries" -ItemType Directory -Force

# Copy Windows 11 PS 5.1 (ARM) version to new folder
Get-ChildItem -Path "src\Sophia_Script_for_Windows_11_Arm" -Force | Copy-Item -Destination "Sophia_Script\Sophia_Script_for_Windows_11_Arm_v$Latest_Release_Windows_11_Arm_PowerShell_5_1" -Recurse -Force

# Add LGPO.exe
$Parameters = @{
	Path        = "Sophia_Script\LGPO.exe"
	Destination = "Sophia_Script\Sophia_Script_for_Windows_11_Arm_v$Latest_Release_Windows_11_Arm_PowerShell_5_1\Binaries"
	Recurse     = $true
	Force       = $true
}
Copy-Item @Parameters

$Parameters = @{
	Path             = "Sophia_Script\Sophia_Script_for_Windows_11_Arm_v$Latest_Release_Windows_11_Arm_PowerShell_5_1"
	DestinationPath  = "Sophia_Script\Sophia.Script.for.Windows.11.Arm.v$Latest_Release_Windows_11_Arm_PowerShell_5_1.zip"
	CompressionLevel = "Fastest"
	Force            = $true
}
Compress-Archive @Parameters
