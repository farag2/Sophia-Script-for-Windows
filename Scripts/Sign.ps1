# Sign all scripts in folder recursively by a self-signed certificate
$CertName             = "Team Sophia"
$FolderPath           = "src"
$ExtensionsToSearchIn = @(".ps1", ".psm1", ".psd1")
# Get-ChildItem -Path Cert:\LocalMachine\My, Cert:\CurrentUser\My | Where-Object -FilterScript {$_.Subject -eq "CN=$CertName"} | Remove-Item

# Generate a self-signed Authenticode certificate in the local computer's personal certificate store
$Parameters = @{
	Subject           = $CertName
	NotAfter          = (Get-Date).AddMonths(24)
	CertStoreLocation = "Cert:\LocalMachine\My"
	Type              = "CodeSigningCert"
}
$authenticode = New-SelfSignedCertificate @Parameters

# Add the self-signed Authenticode certificate to the computer's root certificate store
# Create an object to represent the LocalMachine\Root certificate store
$rootStore = [System.Security.Cryptography.X509Certificates.X509Store]::new("Root","LocalMachine")
# Open the root certificate store for reading and writing
$rootStore.Open("ReadWrite")
# Add the certificate stored in the $authenticode variable
$rootStore.Add($authenticode)
# Close the root certificate store
$rootStore.Close()

# Add the self-signed Authenticode certificate to the computer's trusted publishers certificate store
# Create an object to represent the LocalMachine\TrustedPublisher certificate store
$publisherStore = [System.Security.Cryptography.X509Certificates.X509Store]::new("TrustedPublisher","LocalMachine")
# Open the TrustedPublisher certificate store for reading and writing
$publisherStore.Open("ReadWrite")
# Add the certificate stored in the $authenticode variable
$publisherStore.Add($authenticode)
# Close the TrustedPublisher certificate store
$publisherStore.Close()

# Get the code-signing certificate from the local computer's certificate store with the name "Sophia Authenticode" and store it to the $codeCertificate variable
$codeCertificate = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object -FilterScript {$_.Subject -eq "CN=$CertName"}

# TimeStampServer specifies the trusted timestamp server that adds a timestamp to script's digital signature
# Adding a timestamp ensures that your code will not expire when the signing certificate expires
# -Include *.ps1, *.psm1, *.psd1 is obvious, but it's slow
# There is no need to user $PSScriptRoot\$FolderPath
Get-ChildItem -Path $FolderPath -Recurse -File | Where-Object -FilterScript {$_.Extension -in $ExtensionsToSearchIn} | ForEach-Object -Process {
	$Parameters = @{
		FilePath        = $_.FullName
		Certificate     = $codeCertificate
		TimeStampServer = "http://timestamp.digicert.com"
	}
	Set-AuthenticodeSignature @Parameters
}
