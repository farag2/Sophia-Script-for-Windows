Write-Verbose -Message "Signed WinGet launcher" -Verbose

# Check the WinGet launcher signed by SignPath and put it back instead of the unsigned one
# https://github.com/farag2/Sophia-Script-for-Windows/blob/main/Scripts/Building/WinGet_Launcher.ps1

# https://github.com/farag2/Sophia-Script-for-Windows/blob/main/Sophia_Script_Releases.json
$Latest_Release_Windows_11 = (Get-Content -Path "Sophia_Script_Releases.json" -Raw | ConvertFrom-Json).Sophia_Script_Windows_11
$FileName = "Sophia.Script.for.Windows.11.v$($Latest_Release_Windows_11)_WinGet.exe"

# The folder where signpath/github-action-submit-signing-request saved the signed artifact
$SignedFile = Join-Path -Path $env:SIGNED_ARTIFACT_DIRECTORY -ChildPath $FileName
if (-not (Test-Path -Path $SignedFile))
{
	Write-Error -Message "$($FileName) wasn't found in $($env:SIGNED_ARTIFACT_DIRECTORY)" -ErrorAction Stop
}

# Check the Authenticode signature
$Signature = Get-AuthenticodeSignature -FilePath $SignedFile
Write-Verbose -Message "Signature status: $($Signature.Status)" -Verbose
Write-Verbose -Message "Signer: $($Signature.SignerCertificate.Subject)" -Verbose
Write-Verbose -Message "Timestamp: $($Signature.TimeStamperCertificate.Subject)" -Verbose

if ($null -eq $Signature.SignerCertificate)
{
	Write-Error -Message "$($FileName) is not signed" -ErrorAction Stop
}

# A certificate from the test-signing policy is not trusted on the runner, so only the release-signing policy requires the "Valid" status
if (($env:SIGNPATH_SIGNING_POLICY_SLUG -eq "release-signing") -and ($Signature.Status -ne "Valid"))
{
	Write-Error -Message "$($FileName) signature status is $($Signature.Status)" -ErrorAction Stop
}

# Make sure that the file metadata is the same as in the SignPath artifact configuration (product-name, product-version)
$VersionInfo = (Get-Item -Path $SignedFile).VersionInfo
Write-Verbose -Message "ProductName: $($VersionInfo.ProductName), ProductVersion: $($VersionInfo.ProductVersion)" -Verbose

if (($VersionInfo.ProductName -ne "Sophia Script for Windows") -or ($VersionInfo.ProductVersion -ne $Latest_Release_Windows_11))
{
	Write-Error -Message "$($FileName) has wrong metadata" -ErrorAction Stop
}

# Replace the unsigned file. VirusTotal.ps1, ReleaseNotesTemplate.ps1 and the release use files from the Sophia_Script folder
$Parameters = @{
	Path        = $SignedFile
	Destination = "Sophia_Script\$($FileName)"
	Force       = $true
}
Copy-Item @Parameters

Write-Verbose -Message "SHA256: $((Get-FileHash -Path "Sophia_Script\$($FileName)" -Algorithm SHA256).Hash)" -Verbose
