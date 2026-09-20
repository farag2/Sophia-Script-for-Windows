# https://github.com/farag2/Sophia-Script-for-Windows/blob/main/Sophia_Script_Releases.json
$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/main/Sophia_Script_Releases.json"
	UseBasicParsing = $true
	Verbose         = $true
}
$Latest_Release_Windows_11 = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_11

Write-Verbose -Message "Sophia.Script.for.Windows.11.v$Latest_Release_Windows_11.zip" -Verbose

New-Item -Path "Sophia_Script\Sophia_Script_for_Windows_11_v$Latest_Release_Windows_11\Module\Binaries" -ItemType Directory -Force

# Copy Windows 11 PS 5.1 version to new folder
Get-ChildItem -Path "src\Sophia_Script_for_Windows_11" -Force | Copy-Item -Destination "Sophia_Script\Sophia_Script_for_Windows_11_v$Latest_Release_Windows_11" -Recurse -Force

# Add LGPO.exe
$Parameters = @{
	Path        = "Sophia_Script\LGPO.exe"
	Destination = "Sophia_Script\Sophia_Script_for_Windows_11_v$Latest_Release_Windows_11\Module\Binaries"
	Recurse     = $true
	Force       = $true
}
Copy-Item @Parameters

$Parameters = @{
	Path             = "Sophia_Script\Sophia_Script_for_Windows_11_v$Latest_Release_Windows_11"
	DestinationPath  = "Sophia_Script\Sophia.Script.for.Windows.11.v$Latest_Release_Windows_11.zip"
	CompressionLevel = "Fastest"
	Force            = $true
}
Compress-Archive @Parameters
