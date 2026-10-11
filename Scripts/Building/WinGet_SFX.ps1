Write-Verbose -Message SFX -Verbose

# Install WinRAR
winget install --id RARLab.WinRAR --accept-source-agreements --force

# https://github.com/farag2/Sophia-Script-for-Windows/blob/main/Sophia_Script_Releases.json
$Latest_Release_Windows_11 = (Get-Content -Path "Sophia_Script_Releases.json" -Raw | ConvertFrom-Json).Sophia_Script_Windows_11

# Download latest Windows 11 based release archive
$Parameters = @{
	Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$($Latest_Release_Windows_11)/Sophia.Script.for.Windows.11.v$($Latest_Release_Windows_11).zip"
	OutFile         = "$env:RUNNER_TEMP\Sophia.Script.for.Windows.11.v$($Latest_Release_Windows_11).zip"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

# Archive contains the Sophia_Script_for_Windows_11_v$($Latest_Release_Windows_11) folder
& "$env:SystemRoot\System32\tar.exe" -xf "$env:RUNNER_TEMP\Sophia.Script.for.Windows.11.v$($Latest_Release_Windows_11).zip" -C $env:RUNNER_TEMP

# Save config with the actual version to a temp folder so as not to change the file in the repo
(Get-Content -Path "Scripts\WinGet\WinGet_SFX_config.txt" -Encoding utf8NoBOM -Raw).Replace("SophiaScriptVersion", $Latest_Release_Windows_11) | Set-Content -Path "$env:RUNNER_TEMP\WinGet_SFX_config.txt" -Encoding utf8NoBOM -Force

New-Item -Path "WinGet" -ItemType Directory -Force
Get-ChildItem -Path "WinGet" -Filter "*_WinGet.exe" -File -Force | Remove-Item -Force

# Create SFX archive
& "$env:ProgramFiles\WinRAR\RAR.exe" a -sfx "-z$env:RUNNER_TEMP\WinGet_SFX_config.txt" -ep1 -r "WinGet\Sophia.Script.for.Windows.11.v$($Latest_Release_Windows_11)_WinGet.exe" "$env:RUNNER_TEMP\Sophia_Script_for_Windows_11_v$($Latest_Release_Windows_11)\*"
