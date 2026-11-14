Write-Verbose -Message "Signed WinGet launcher" -Verbose

# Check the WinGet launcher signed by SignPath and put it back instead of the unsigned one
# https://github.com/farag2/Sophia-Script-for-Windows/blob/main/Scripts/Building/WinGet_Launcher.ps1

# https://github.com/farag2/Sophia-Script-for-Windows/blob/main/Sophia_Script_Releases.json
$Latest_Release_Windows_11 = (Get-Content -Path "Sophia_Script_Releases.json" -Raw | ConvertFrom-Json).Sophia_Script_Windows_11
$FileName = "Sophia.Script.for.Windows.11.v$($Latest_Release_Windows_11)_WinGet.exe"

# The folder where signpath/github-action-submit-signing-request saved the signed artifact
# ${{ runner.temp }}/SignPath
$SignedFile = Join-Path -Path $env:SIGNED_ARTIFACT_DIRECTORY -ChildPath $FileName

$Signature = Get-AuthenticodeSignature -FilePath $SignedFile
Write-Verbose -Message "Signature status: $($Signature.Status)" -Verbose
Write-Verbose -Message "Signer: $($Signature.SignerCertificate.Subject)" -Verbose
Write-Verbose -Message "Timestamp: $($Signature.TimeStamperCertificate.Subject)" -Verbose

$VersionInfo = (Get-Item -Path $SignedFile).VersionInfo
Write-Verbose -Message "ProductName: $($VersionInfo.ProductName), ProductVersion: $($VersionInfo.ProductVersion)" -Verbose

# Replace the unsigned file. VirusTotal.ps1, ReleaseNotesTemplate.ps1 and the release use files from the Sophia_Script folder
$Parameters = @{
	Path        = $SignedFile
	Destination = "Sophia_Script\$($FileName)"
	Force       = $true
}
Copy-Item @Parameters

Write-Verbose -Message "SHA256: $((Get-FileHash -Path "Sophia_Script\$($FileName)" -Algorithm SHA256).Hash)" -Verbose
