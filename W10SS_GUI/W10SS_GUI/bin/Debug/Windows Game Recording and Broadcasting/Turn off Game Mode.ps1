# Turn off Game Mode
# Отключить игровой режим
New-ItemProperty -Path HKCU:\Software\Microsoft\GameBar -Name AllowAutoGameMode -PropertyType DWord -Value 0 -Force