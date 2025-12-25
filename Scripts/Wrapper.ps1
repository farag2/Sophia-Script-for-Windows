# https://github.com/farag2/Sophia-Script-for-Windows/blob/master/sophia_script_versions.json
$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json"
	UseBasicParsing = $true
	Verbose         = $true
}
$Latest_Release_Sophia_Script_Wrapper = (Invoke-RestMethod @Parameters).Sophia_Script_Wrapper

Write-Verbose -Message "Sophia.Script.Wrapper.v$Latest_Release_Sophia_Script_Wrapper.zip" -Verbose

New-Item -Path "Sophia_Script\Sophia_Script_Wrapper_v$Latest_Release_Sophia_Script_Wrapper" -ItemType Directory -Force

# Copy Wrapper to new folder
Get-ChildItem -Path Wrapper -Exclude README.md -Force | Copy-Item -Destination "Sophia_Script\Sophia_Script_Wrapper_v$Latest_Release_Sophia_Script_Wrapper" -Recurse -Force

$Parameters = @{
	Path             = "Sophia_Script\Sophia_Script_Wrapper_v$Latest_Release_Sophia_Script_Wrapper"
	DestinationPath  = "Sophia_Script\Sophia.Script.Wrapper.v$Latest_Release_Sophia_Script_Wrapper.zip"
	CompressionLevel = "Fastest"
	Force            = $true
}
Compress-Archive @Parameters
