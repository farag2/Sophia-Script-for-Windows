Write-Verbose -Message Dependencies -Verbose

New-Item -Path "Sophia_Script" -ItemType Directory -Force

# Download Microsoft.Windows.SDK.NET.dll & WinRT.Runtime.dll
# https://www.nuget.org/packages/Microsoft.Windows.SDK.NET.Ref
$Parameters = @{
	Uri             = "https://www.nuget.org/api/v2/package/Microsoft.Windows.SDK.NET.Ref"
	OutFile         = "Sophia_Script\microsoft.windows.sdk.net.ref.zip"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

# Extract Microsoft.Windows.SDK.NET.dll & WinRT.Runtime.dll only
& "$env:SystemRoot\System32\tar.exe" -xvf "Sophia_Script\microsoft.windows.sdk.net.ref.zip" -C "Sophia_Script" --strip-components 2 "lib/net9.0/WinRT.Runtime.dll" "lib/net9.0/Microsoft.Windows.SDK.NET.dll"

Remove-Item -Path "Sophia_Script\microsoft.windows.sdk.net.ref.zip" -Force

Write-Verbose -Message Archives -Verbose

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

	# Sophia_Script_for_Windows_11_v8.x.x
	$Folder  = "Sophia_Script\$($Edition)_v$Version"
	# Sophia.Script.for.Windows.11.v8.x.x.zip
	$Archive = "$($Edition.Replace('_', '.')).v$Version.zip"

	Write-Verbose -Message $Archive -Verbose

	New-Item -Path $Folder -ItemType Directory -Force

	# Copy edition to new folder
	Get-ChildItem -Path "src\$Edition" -Force | Copy-Item -Destination $Folder -Recurse -Force

	# PowerShell 7 uses WinRT.Runtime.dll and Microsoft.Windows.SDK.NET.dll for to build UWP packages list
	if ($Edition.Contains("PowerShell_7"))
	{
		New-Item -Path "$Folder\Module\Binaries" -ItemType Directory -Force

		$Parameters = @{
			Path        = "Sophia_Script\WinRT.Runtime.dll", "Sophia_Script\Microsoft.Windows.SDK.NET.dll"
			Destination = "$Folder\Module\Binaries"
			Force       = $true
		}
		Copy-Item @Parameters
	}

	$Parameters = @{
		Path             = $Folder
		DestinationPath  = "Sophia_Script\$Archive"
		CompressionLevel = "Fastest"
		Force            = $true
	}
	Compress-Archive @Parameters
}
