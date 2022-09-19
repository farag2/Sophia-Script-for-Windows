Write-Verbose -Message Dependencies -Verbose

# Download PolicyFileEditor
# https://github.com/dlwyatt/PolicyFileEditor
$Parameters = @{
    Uri             = "https://api.github.com/repos/dlwyatt/PolicyFileEditor/releases/latest"
    UseBasicParsing = $true
}
$LatestPolicyFileEditorVersion = (Invoke-RestMethod @Parameters).tag_name
$Parameters = @{
    Uri             = "https://github.com/dlwyatt/PolicyFileEditor/archive/refs/tags/$LatestPolicyFileEditorVersion.zip"
    OutFile         = "Scripts\$LatestPolicyFileEditorVersion.zip"
    UseBasicParsing = $true
    Verbose         = $true
}
Invoke-WebRequest @Parameters
# Expand zip archive
$Parameters = @{
    Path            = "Scripts\$LatestPolicyFileEditorVersion.zip"
    DestinationPath = "Scripts"
    Force           = $true
    Verbose         = $true
}
Expand-Archive @Parameters
$Path = @(
    "Scripts\PolicyFileEditor-$LatestPolicyFileEditorVersion\DscResources",
    "Scripts\PolicyFileEditor-$LatestPolicyFileEditorVersion\en-US",
    "Scripts\PolicyFileEditor-$LatestPolicyFileEditorVersion\build.psake.ps1",
    "Scripts\PolicyFileEditor-$LatestPolicyFileEditorVersion\LICENSE",
    "Scripts\PolicyFileEditor-$LatestPolicyFileEditorVersion\PolicyFileEditor.Tests.ps1",
    "Scripts\PolicyFileEditor-$LatestPolicyFileEditorVersion\README.md"
)
Remove-Item -Path $Path -Recurse -Force
Rename-Item -Path "Scripts\PolicyFileEditor-$LatestPolicyFileEditorVersion" -NewName "PolicyFileEditor" -Force
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
$Entries = $ZIP.Entries | Where-Object -FilterScript {($_.FullName -eq "lib/net6.0/Microsoft.Windows.SDK.NET.dll") -or ($_.FullName -eq "lib/net6.0/WinRT.Runtime.dll")}
$Entries | ForEach-Object -Process {[IO.Compression.ZipFileExtensions]::ExtractToFile($_, "Scripts\$($_.Name)", $true)}
$ZIP.Dispose()
