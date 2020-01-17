# Turn off Game Bar tips
# Отключить подсказки игровой панели
New-ItemProperty -Path HKCU:\Software\Microsoft\GameBar -Name ShowStartupPanel -PropertyType DWord -Value 0 -Force