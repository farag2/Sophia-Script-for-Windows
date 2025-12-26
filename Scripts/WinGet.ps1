# Get local uploaded manifest version of the package
$String = Get-Content -Path "Scripts\WinGet_Manifests\TeamSophia.SophiaScript.yaml" | Where-Object -FilterScript {$_ -match "ManifestVersion"}
$LocalManifest = $String -split " " | Select-Object -Last 1

# Get latest supported manifest version provided
# https://github.com/microsoft/winget-cli/tree/master/schemas/JSON/manifests
$Token = $env:GITHUB_TOKEN
$Headers = @{
	Accept        = "application/vnd.github+json"
	Authorization = "Bearer $Token"
}
$Parameters = @{
	Uri             = "https://api.github.com/repos/microsoft/winget-cli/contents/schemas/JSON/manifests"
	Headers         = $Headers
	UseBasicParsing = $true
	Verbose         = $true
}
$LatestManifest = ((Invoke-RestMethod @Parameters).name | Where-Object {($_ -ne "preview") -and ($_ -ne "latest")}) -replace ("v", "") | Sort-Object -Property {[System.Version]$_} | Select-Object -Last 1

if ([System.Version]$LocalManifest -lt [System.Version]$LatestManifest)
{
	Write-Warning -Message "A new manifest $($LatestManifest) available. Edit manifests in Scripts\WinGet_Manifests."
}

# Get latest version tag for Windows 11
$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/refs/heads/master/sophia_script_versions.json"
	Headers         = $Headers
	UseBasicParsing = $true
	Verbose         = $true
}
$Version = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_11_PowerShell_5_1

# Get archive hash
$Parameters = @{
	Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$($Version)/Sophia.Script.for.Windows.11.v$($Version)_WinGet.exe"
	Headers         = $Headers
	UseBasicParsing = $true
	Verbose         = $true
}
$Request = (Invoke-WebRequest @Parameters).RawContentStream
$Hash = (Get-FileHash -InputStream $Request).Hash

# Update the metadata for the files
Get-ChildItem -Path Scripts\WinGet_Manifests | ForEach-Object -Process {
	(Get-Content -Path $_.FullName -Encoding UTF8 -Raw) | Foreach-Object -Process {
		$_ -replace "SophiaScriptVersion", $Version `
		-replace "SophiaScriptHash", $Hash `
		-replace "SophiaScriptDate", $(Get-Date -Format "yyyy-MM-dd")
	} | Set-Content -Path $_.FullName -Encoding utf8 -Force
}
