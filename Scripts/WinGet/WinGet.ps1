# Get local uploaded manifest version of the package
$String = Get-Content -Path "Scripts\WinGet\WinGet_Manifests\TeamSophia.SophiaScript.yaml" | Where-Object -FilterScript {$_ -match "ManifestVersion"}
$LocalManifest = $String -split " " | Select-Object -Last 1

# Get latest supported manifest version provided
# https://github.com/microsoft/winget-cli/tree/master/schemas/JSON/manifests
# https://github.com/microsoft/winget-pkgs/tree/master/doc/manifest/schema
$Token = $env:GITHUB_TOKEN
$Headers = @{
	Accept        = "application/vnd.github+json"
	Authorization = "Bearer $Token"
}

<#
$Parameters = @{
	Uri             = "https://api.github.com/repos/microsoft/winget-pkgs/contents/doc/manifest/schema"
	Headers         = $Headers
	UseBasicParsing = $true
	Verbose         = $true
}
$LatestManifest = (Invoke-RestMethod @Parameters).name | Sort-Object -Property {[System.Version]$_} | Select-Object -Last 1
#>

$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/microsoft/winget-pkgs/refs/heads/master/Tools/YamlCreate.ps1"
	UseBasicParsing = $true
	Verbose         = $true
}
$Content = (Invoke-WebRequest @Parameters).Content

$AST = [System.Management.Automation.Language.Parser]::ParseInput($Content, [ref]$null, [ref]$null)
$LatestManifest = $AST.Find(
	{
		param
		(
			$Node
		)

		($Node -is [System.Management.Automation.Language.AssignmentStatementAst]) -and
		($Node.Left -is [System.Management.Automation.Language.VariableExpressionAst]) -and
		($Node.Left.VariablePath.UserPath -eq "ManifestVersion")
	},
	$true
).Right.Expression.Value

if ([System.Version]$LocalManifest -lt [System.Version]$LatestManifest)
{
	Write-Warning -Message "A new manifest $($LatestManifest) available. Edit manifests in Scripts\WinGet\WinGet_Manifests."

	# Exit with a non-zero status to fail the job
	exit 1
}

# Get latest version tag for Windows 11
$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/refs/heads/main/sophia_script_versions.json"
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
Get-ChildItem -Path Scripts\WinGet\WinGet_Manifests | ForEach-Object -Process {
	(Get-Content -Path $_.FullName -Encoding UTF8 -Raw) | Foreach-Object -Process {
		$_ -replace "SophiaScriptVersion", $Version `
		-replace "SophiaScriptHash", $Hash `
		-replace "SophiaScriptDate", $(Get-Date -Format "yyyy-MM-dd")
	} | Set-Content -Path $_.FullName -Encoding utf8 -Force
}
