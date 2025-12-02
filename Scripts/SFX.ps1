Write-Verbose -Message SFX -Verbose

# Download WinRAR
# https://www.rarlab.com
New-Item -Path WinRAR -ItemType Directory -Force

$Parameters = @{
	Uri             = "https://www.rarlab.com/rar/winrar-x64-713.exe"
	OutFile         = "WinRAR\winrar-x64-713.exe"
	UseBasicParsing = $true
}
Invoke-WebRequest @Parameters

# Install WinRAR silently
& "WinRAR\winrar-x64-713.exe" -s

# Get latest version tag for Windows 11
$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/refs/heads/master/sophia_script_versions.json"
	UseBasicParsing = $true
}
$Latest_Release_Windows_11_PowerShell_5_1 = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_11_PowerShell_5_1

(Get-Content -Path Scripts\SFX_config.txt -Encoding utf8NoBOM -Raw) | Foreach-Object -Process {$_ -replace "SophiaScriptVersion", $Latest_Release_Windows_11_PowerShell_5_1} | Set-Content -Path Scripts\SFX_config.txt -Encoding utf8NoBOM -Force

Import-Module -Name PackageManagement -UseWindowsPowerShell
get-package -Name *rar* | fl *

# Create SFX archive
& "C:\Program Files\WinRAR\Rar.exe" a -sfx -z"Scripts\SFX_config.txt" -ep1 -r "SophiaScriptWinGet_SophiaScriptVersion.exe" "Sophia_Script_for_Windows_11_v$($Latest_Release_Windows_11_PowerShell_5_1)\*"
