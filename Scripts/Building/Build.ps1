# https://github.com/farag2/Sophia-Script-for-Windows/blob/main/Sophia_Script_Releases.json
$Releases = Get-Content -Path "Sophia_Script_Releases.json" -Raw | ConvertFrom-Json

# Folder name in src = key in Sophia_Script_Releases.json
$Editions = [ordered]@{
	Sophia_Script_for_Windows_10                        = "Sophia_Script_Windows_10"
	Sophia_Script_for_Windows_10_PowerShell_7           = "Sophia_Script_Windows_10"
	Sophia_Script_for_Windows_10_LTSC_2019              = "Sophia_Script_Windows_10_LTSC_2019"
	Sophia_Script_for_Windows_10_LTSC_2021              = "Sophia_Script_Windows_10_LTSC_2021"
	Sophia_Script_for_Windows_11                        = "Sophia_Script_Windows_11"
	Sophia_Script_for_Windows_11_PowerShell_7           = "Sophia_Script_Windows_11"
	Sophia_Script_for_Windows_11_Arm                    = "Sophia_Script_Windows_11"
	Sophia_Script_for_Windows_11_Arm_PowerShell_7       = "Sophia_Script_Windows_11"
	Sophia_Script_for_Windows_11_LTSC_2024              = "Sophia_Script_Windows_11_LTSC_2024"
	Sophia_Script_for_Windows_11_LTSC_2024_PowerShell_7 = "Sophia_Script_Windows_11_LTSC_2024"
}

foreach ($Edition in $Editions.Keys)
{
	$Version = $Releases.($Editions[$Edition])

	# Sophia_Script_for_Windows_11_v7.0.0
	$Folder  = "Sophia_Script\$($Edition)_v$Version"
	# Sophia.Script.for.Windows.11.v7.0.0.zip
	$Archive = "$($Edition.Replace('_', '.')).v$Version.zip"

	Write-Verbose -Message $Archive -Verbose

	New-Item -Path "$Folder\Module\Binaries" -ItemType Directory -Force

	# Copy edition to new folder
	Get-ChildItem -Path "src\$Edition" -Force | Copy-Item -Destination $Folder -Recurse -Force

	# Add LGPO.exe. PowerShell 7 editions also need WinRT.Runtime.dll and Microsoft.Windows.SDK.NET.dll
	$Binaries = @("Sophia_Script\LGPO.exe")
	if ($Edition.Contains("PowerShell_7"))
	{
		$Binaries += "Sophia_Script\WinRT.Runtime.dll", "Sophia_Script\Microsoft.Windows.SDK.NET.dll"
	}

	$Parameters = @{
		Path        = $Binaries
		Destination = "$Folder\Module\Binaries"
		Force       = $true
	}
	Copy-Item @Parameters

	$Parameters = @{
		Path             = $Folder
		DestinationPath  = "Sophia_Script\$Archive"
		CompressionLevel = "Fastest"
		Force            = $true
	}
	Compress-Archive @Parameters
}
