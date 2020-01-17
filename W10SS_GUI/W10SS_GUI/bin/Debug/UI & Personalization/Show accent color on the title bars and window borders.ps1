# Show accent color on the title bars and window borders
# Отображать цвет элементов в заголовках окон и границ окон
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\DWM -Name ColorPrevalence -PropertyType DWord -Value 1 -Force