# Download WinRAR
# https://www.rarlab.com
$Parameters = @{
	Uri             = "https://www.rarlab.com/rar/winrar-x64-713.exe"
	OutFile         = "winrar-x64-713.exe"
	UseBasicParsing = $true
}
Invoke-WebRequest @Parameters

# Install WinRAR
& winrar-x64-713.exe -s

# Get latest version tag for Windows 11
$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/refs/heads/master/sophia_script_versions.json"
	UseBasicParsing = $true
}
$Latest_Release_Windows_11_PowerShell_5_1 = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_11_PowerShell_5_1

# Create config
@"
; Expand SFX archive
Path=$env:TEMP\Sophia_Script_for_Windows_11_v$($Latest_Release_Windows_11_PowerShell_5_1)
; Copy folder recursively to user's Desktop folder
Setup=C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle Hidden -Command & {Copy-Item -Path "$env:TEMP\Sophia_Script_for_Windows_11_v$($Latest_Release_Windows_11_PowerShell_5_1)" -Destination "$(Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}")\1" -Recurse -Force}
; No GUI while expanding SFX archive
Silent=1
"@ | Set-Content -Path config.txt -Encoding Default -Force

# Create SFX archive
& "C:\Program Files\WinRAR\Rar.exe" a -sfx -z"config.txt" -ep1 -r "SophiaScriptWinGet_SophiaScriptVersion.exe" "Sophia_Script_for_Windows_11_v$($Latest_Release_Windows_11_PowerShell_5_1)\*"
