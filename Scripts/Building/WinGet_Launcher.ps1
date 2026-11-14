Write-Verbose -Message "WinGet launcher" -Verbose

# Build Sophia.Script.for.Windows.11.v*_WinGet.exe for WinGet: a self-extracting EXE without WinRAR or 7-Zip
# The EXE is compiled from Scripts\Launcher\SophiaLauncher.cs and contains the release ZIP archive as an embedded resource
# It extracts the archive to the Downloads folder and opens the extracted folder

# https://github.com/farag2/Sophia-Script-for-Windows/blob/main/Sophia_Script_Releases.json
$Latest_Release_Windows_11 = (Get-Content -Path "Sophia_Script_Releases.json" -Raw | ConvertFrom-Json).Sophia_Script_Windows_11

$Folder   = "Sophia_Script\Sophia_Script_for_Windows_11_v$($Latest_Release_Windows_11)"
$Archive  = "Sophia_Script\Sophia.Script.for.Windows.11.v$($Latest_Release_Windows_11).zip"
$Launcher = "Sophia_Script\Sophia.Script.for.Windows.11.v$($Latest_Release_Windows_11)_WinGet.exe"

# Sophia.yml: the archive was already built by Build.ps1, so the launcher contains exactly the released archive
# SignPath_Test.yml: Build.ps1 isn't run, so pack the Windows 11 edition the same way Build.ps1 does
# The archive contains the Sophia_Script_for_Windows_11_v* folder
if (-not (Test-Path -Path $Archive))
{
	if (Test-Path -Path $Folder)
	{
		Remove-Item -Path $Folder -Recurse -Force
	}
	New-Item -Path $Folder -ItemType Directory -Force | Out-Null
	Get-ChildItem -Path "src\Sophia_Script_for_Windows_11" -Force | Copy-Item -Destination $Folder -Recurse -Force

	$Parameters = @{
		Path             = $Folder
		DestinationPath  = $Archive
		CompressionLevel = "Fastest"
		Force            = $true
	}
	Compress-Archive @Parameters
}

$CSC = "$env:SystemRoot\Microsoft.NET\Framework64\v4.0.30319\csc.exe"

# AssemblyVersion and AssemblyFileVersion require 4 numbers: 8.1.0 -> 8.1.0.0
$Version = [System.Version]$Latest_Release_Windows_11
$FileVersion = (New-Object -TypeName System.Version -ArgumentList $Version.Major, $Version.Minor, $Version.Build, 0).ToString()

$AssemblyInfo = @"
using System.Reflection;

[assembly: AssemblyTitle("Sophia Script for Windows")]
[assembly: AssemblyDescription("Sophia Script for Windows 11")]
[assembly: AssemblyProduct("Sophia Script for Windows")]
[assembly: AssemblyCompany("Team Sophia")]
[assembly: AssemblyCopyright("Copyright (c) 2014-$((Get-Date).Year) Team Sophia")]
[assembly: AssemblyVersion("$FileVersion")]
[assembly: AssemblyFileVersion("$FileVersion")]
[assembly: AssemblyInformationalVersion("$Latest_Release_Windows_11")]
"@

$AssemblyInfoPath = "$env:TEMP\SophiaLauncher_AssemblyInfo.cs"
Set-Content -Path $AssemblyInfoPath -Value $AssemblyInfo -Encoding UTF8 -Force

$Arguments = @(
	"/nologo",
	"/target:winexe",
	"/platform:anycpu",
	"/optimize+",
	"/out:$Launcher",
	# Icon
	"/win32icon:Scripts\Launcher\WinGet.ico",
	# Archive is embedded under the "Sophia.zip" name. SophiaLauncher.cs reads it by this name
	"/resource:$Archive,Sophia.zip",
	"/reference:System.IO.Compression.dll",
	"/reference:System.IO.Compression.FileSystem.dll",
	"/reference:System.Windows.Forms.dll",
	"Scripts\Launcher\SophiaLauncher.cs",
	$AssemblyInfoPath
)
& $CSC @Arguments

Remove-Item -Path $AssemblyInfoPath -Force

# Pass the version to the next workflow steps: file name for upload-artifact and the "version" parameter for SignPath
if ($env:GITHUB_OUTPUT)
{
	Add-Content -Path $env:GITHUB_OUTPUT -Value "version=$Latest_Release_Windows_11"
}

(Get-Item -Path $Launcher).VersionInfo | Format-List -Property ProductName, ProductVersion, FileVersion, CompanyName, OriginalFilename
