Write-Verbose -Message Dependencies -Verbose

New-Item -Path "Sophia_Script" -ItemType Directory -Force

# Download LGPO
# https://techcommunity.microsoft.com/t5/microsoft-security-baselines/lgpo-exe-local-group-policy-object-utility-v1-0/ba-p/701045
$Parameters = @{
	Uri             = "https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip"
	OutFile         = "Sophia_Script\LGPO.zip"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

# Expand zip archive
$Parameters = @{
	Path            = "Sophia_Script\LGPO.zip"
	DestinationPath = "Sophia_Script"
	Force           = $true
	Verbose         = $true
}
Expand-Archive @Parameters

$Parameters = @{
	Path        = "Sophia_Script\LGPO_30\LGPO.exe"
	Destination = "Sophia_Script"
	Force       = $true
}
Move-Item @Parameters

# Download Microsoft.Windows.SDK.NET.dll & WinRT.Runtime.dll
# https://www.nuget.org/packages/Microsoft.Windows.SDK.NET.Ref
$Parameters = @{
	Uri             = "https://www.nuget.org/api/v2/package/Microsoft.Windows.SDK.NET.Ref"
	OutFile         = "Sophia_Script\microsoft.windows.sdk.net.ref.zip"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-RestMethod @Parameters

# Extract Microsoft.Windows.SDK.NET.dll & WinRT.Runtime.dll from archive
Add-Type -Assembly System.IO.Compression.FileSystem
$ZIP = [IO.Compression.ZipFile]::OpenRead("Sophia_Script\microsoft.windows.sdk.net.ref.zip")
$Entries = $ZIP.Entries | Where-Object -FilterScript {($_.FullName -eq "lib/net8.0/Microsoft.Windows.SDK.NET.dll") -or ($_.FullName -eq "lib/net8.0/WinRT.Runtime.dll")}
$Entries | ForEach-Object -Process {[IO.Compression.ZipFileExtensions]::ExtractToFile($_, "Sophia_Script\$($_.Name)", $true)}
$ZIP.Dispose()

Remove-Item -Path "Sophia_Script\LGPO_30", "Sophia_Script\LGPO.zip", "Sophia_Script\microsoft.windows.sdk.net.ref.zip" -Recurse -Force
