# https://github.com/farag2/Sophia-Script-for-Windows/blob/master/sophia_script_versions.json
$Parameters = @{
    Uri = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json"
}

$LatestRelease = (Invoke-RestMethod @Parameters).Sophia_Script_Wrapper

Write-Verbose -Message "Sophia.Script.Wrapper.v$LatestRelease.zip" -Verbose

New-Item -Path "Sophia Script Wrapper v$LatestRelease" -ItemType Directory -Force

Get-ChildItem -Path Wrapper -Exclude README.md -Force | Copy-Item -Destination "Sophia Script Wrapper v$LatestRelease" -Recurse -Force
$Parameters = @{
    Path             = "Sophia Script Wrapper v$LatestRelease"
    DestinationPath  = "Sophia.Script.Wrapper.v$LatestRelease.zip"
    CompressionLevel = "Fastest"
    Force            = $true
}
Compress-Archive @Parameters

# Calculate hash
Get-Item -Path "Sophia.Script.Wrapper.v$LatestRelease.zip" -Force | ForEach-Object -Process {
    "$($_.Name)  $((Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash)"
} | Add-Content -Path SHA256SUM -Encoding utf8 -Force
