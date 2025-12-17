Write-Verbose -Message SFX -Verbose

# Install WinRAR
winget install --id RARLab.WinRAR --accept-source-agreements --force

# Get latest version tag for Windows 11
$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/refs/heads/master/sophia_script_versions.json"
	UseBasicParsing = $true
	Verbose         = $true
}
$Latest_Release_Windows_11_PowerShell_5_1 = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_11_PowerShell_5_1

(Get-Content -Path Scripts\SFX_config.txt -Encoding utf8NoBOM -Raw) | Foreach-Object -Process {$_ -replace "SophiaScriptVersion", $Latest_Release_Windows_11_PowerShell_5_1} | Set-Content -Path Scripts\SFX_config.txt -Encoding utf8NoBOM -Force

# Create SFX archive
& "$env:ProgramFiles\WinRAR\RAR.exe" a -sfx -z"Scripts\SFX_config.txt" -ep1 -r "Sophia_Script\Sophia.Script.for.Windows.11.v$($Latest_Release_Windows_11_PowerShell_5_1)_WinGet.exe" "Sophia_Script\Sophia_Script_for_Windows_11_v$($Latest_Release_Windows_11_PowerShell_5_1)\*"
