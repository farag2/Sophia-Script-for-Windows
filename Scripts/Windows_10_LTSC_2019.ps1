# https://github.com/farag2/Sophia-Script-for-Windows/blob/master/sophia_script_versions.json
$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json"
	UseBasicParsing = $true
	Verbose         = $true
}
$Latest_Release_Windows_10_LTSC2019 = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_10_LTSC2019

Write-Verbose -Message "Sophia.Script.for.Windows.10.LTSC.2019.v$Latest_Release_Windows_10_LTSC2019.zip" -Verbose

New-Item -Path "Sophia_Script\Sophia_Script_for_Windows_10_LTSC_2019_v$Latest_Release_Windows_10_LTSC2019\Binaries" -ItemType Directory -Force

# Copy Windows 10 LTSC 2019 PS 5.1 version to new folder
Get-ChildItem -Path "src\Sophia_Script_for_Windows_10_LTSC_2019" -Force | Copy-Item -Destination "Sophia_Script\Sophia_Script_for_Windows_10_LTSC_2019_v$Latest_Release_Windows_10_LTSC2019" -Recurse -Force

# Add LGPO.exe
$Parameters = @{
	Path        = "Sophia_Script\LGPO.exe"
	Destination = "Sophia_Script\Sophia_Script_for_Windows_10_LTSC_2019_v$Latest_Release_Windows_10_LTSC2019\Binaries"
	Recurse     = $true
	Force       = $true
}
Copy-Item @Parameters

$Parameters = @{
	Path             = "Sophia_Script\Sophia_Script_for_Windows_10_LTSC_2019_v$Latest_Release_Windows_10_LTSC2019"
	DestinationPath  = "Sophia_Script\Sophia.Script.for.Windows.10.LTSC.2019.v$Latest_Release_Windows_10_LTSC2019.zip"
	CompressionLevel = "Fastest"
	Force            = $true
}
Compress-Archive @Parameters
