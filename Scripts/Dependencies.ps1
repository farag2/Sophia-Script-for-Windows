Write-Verbose -Message Dependencies -Verbose

# Download LGPO
# https://techcommunity.microsoft.com/t5/microsoft-security-baselines/lgpo-exe-local-group-policy-object-utility-v1-0/ba-p/701045
$Parameters = @{
	Uri             = "https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip"
	OutFile         = "Scripts\LGPO.zip"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

# Expand zip archive
$Parameters = @{
	Path            = "Scripts\LGPO.zip"
	DestinationPath = "Scripts"
	Force           = $true
	Verbose         = $true
}
Expand-Archive @Parameters

$Parameters = @{
	Path        = "Scripts\LGPO_30\LGPO.exe"
	Destination = "Scripts"
	Force       = $true
}
Move-Item @Parameters

Remove-Item -Path "Scripts\LGPO_30", "Scripts\LGPO.zip"  -Recurse -Force

# Download Microsoft.Windows.SDK.NET.dll & WinRT.Runtime.dll
$Parameters = @{
	Uri             = "https://www.nuget.org/api/v2/package/Microsoft.Windows.SDK.NET.Ref"
	OutFile         = "Scripts\microsoft.windows.sdk.net.ref.zip"
	UseBasicParsing = $true
}
Invoke-RestMethod @Parameters

# Extract Microsoft.Windows.SDK.NET.dll & WinRT.Runtime.dll from archive
Add-Type -Assembly System.IO.Compression.FileSystem
$ZIP = [IO.Compression.ZipFile]::OpenRead("Scripts\microsoft.windows.sdk.net.ref.zip")
$Entries = $ZIP.Entries | Where-Object -FilterScript {($_.FullName -eq "lib/net8.0/Microsoft.Windows.SDK.NET.dll") -or ($_.FullName -eq "lib/net8.0/WinRT.Runtime.dll")}
$Entries | ForEach-Object -Process {[IO.Compression.ZipFileExtensions]::ExtractToFile($_, "Scripts\$($_.Name)", $true)}
$ZIP.Dispose()
