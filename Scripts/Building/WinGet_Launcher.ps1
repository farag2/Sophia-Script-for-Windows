# Build Sophia.Script.for.Windows.11.v*_WinGet.exe for WinGet
# The EXE is compiled from Scripts\Building\Launcher\SophiaLauncher.cs and contains the src\Sophia_Script_for_Windows_11 folder as an embedded ZIP archive
# It extracts the archive to the Downloads folder and opens the extracted folder

# Sophia.yml calls the script twice, and SignPath signs the launcher between the calls
# . "Scripts\Building\WinGet_Launcher.ps1"         builds the unsigned launcher
# . "Scripts\Building\WinGet_Launcher.ps1" -Signed checks the launcher signed by SignPath and puts it back instead of the unsigned one
[CmdletBinding()]
param
(
	[Parameter(Mandatory = $false)]
	[switch]
	$Signed
)

# https://github.com/farag2/Sophia-Script-for-Windows/blob/main/Sophia_Script_Releases.json
$Latest_Release_Windows_11 = (Get-Content -Path "Sophia_Script_Releases.json" -Raw | ConvertFrom-Json).Sophia_Script_Windows_11

$FileName = "Sophia.Script.for.Windows.11.v$($Latest_Release_Windows_11)_WinGet.exe"
$Launcher = "Sophia_Script\$FileName"

if ($Signed)
{
	Write-Verbose -Message "Signed WinGet launcher" -Verbose

	# The folder where signpath/github-action-submit-signing-request saved the signed artifact
	# ${{ runner.temp }}/SignPath
	$SignedFile = Join-Path -Path $env:SIGNED_ARTIFACT_DIRECTORY -ChildPath $FileName

	$Signature = Get-AuthenticodeSignature -FilePath $SignedFile
	Write-Verbose -Message "Signature status: $($Signature.Status)" -Verbose
	Write-Verbose -Message "Signer: $($Signature.SignerCertificate.Subject)" -Verbose
	Write-Verbose -Message "Timestamp: $($Signature.TimeStamperCertificate.Subject)" -Verbose

	# The release certificate is trusted, so the signature must be valid
	if ($Signature.Status -ne "Valid")
	{
		Write-Warning -Message "The signature of $FileName isn't valid: $($Signature.StatusMessage)"

		# Exit with a non-zero status to fail the job
		exit 1
	}

	$VersionInfo = (Get-Item -Path $SignedFile).VersionInfo
	Write-Verbose -Message "ProductName: $($VersionInfo.ProductName), ProductVersion: $($VersionInfo.ProductVersion)" -Verbose

	# Replace the unsigned file. VirusTotal.ps1, ReleaseNotesTemplate.ps1 and the release use files from the Sophia_Script folder
	$Parameters = @{
		Path        = $SignedFile
		Destination = $Launcher
		Force       = $true
	}
	Copy-Item @Parameters

	Write-Verbose -Message "SHA256: $((Get-FileHash -Path $Launcher -Algorithm SHA256).Hash)" -Verbose

	# The launcher is already built
	return
}

Write-Verbose -Message "Building WinGet launcher (SFX like)" -Verbose

$Archive  = "$env:TEMP\SophiaLauncher.zip"
# Sophia_Script_for_Windows_11_v8.x.x
$Folder   = "$env:TEMP\Sophia_Script_for_Windows_11_v$($Latest_Release_Windows_11)"

New-Item -Path "Sophia_Script" -ItemType Directory -Force

# Copy folder to compress it with name containing script version
Copy-Item -Path "src\Sophia_Script_for_Windows_11" -Destination $Folder -Recurse -Force

$Parameters = @{
	Path             = $Folder
	DestinationPath  = $Archive
	CompressionLevel = "Fastest"
	Force            = $true
}
Compress-Archive @Parameters

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
Set-Content -Path "$env:TEMP\SophiaLauncher_AssemblyInfo.cs" -Value $AssemblyInfo -Encoding UTF8 -Force

$Arguments = @(
	"/nologo",
	"/target:winexe",
	"/platform:anycpu",
	"/optimize+",
	"/out:$Launcher",
	# Icon
	"/win32icon:Scripts\Building\Launcher\WinGet.ico",
	# Archive is embedded under the "Sophia.zip" name
	"/resource:$Archive,Sophia.zip",
	"/reference:System.IO.Compression.dll",
	"/reference:System.IO.Compression.FileSystem.dll",
	"/reference:System.Windows.Forms.dll",
	"Scripts\Building\Launcher\SophiaLauncher.cs",
	"$env:TEMP\SophiaLauncher_AssemblyInfo.cs"
)
& "$env:SystemRoot\Microsoft.NET\Framework64\v4.0.30319\csc.exe" @Arguments

Remove-Item -Path "$env:TEMP\SophiaLauncher_AssemblyInfo.cs", $Archive, $Folder -Recurse -Force

# Pass the version to the next workflow steps: file name for upload-artifact and the "version" parameter for SignPath
Add-Content -Path $env:GITHUB_OUTPUT -Value "version=$Latest_Release_Windows_11"

(Get-Item -Path $Launcher).VersionInfo | Format-List -Property ProductName, ProductVersion, FileVersion, CompanyName, OriginalFilename
