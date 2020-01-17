# Do not show Cortana button on taskbar
# Не показывать кнопку Кортаны на панели задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCortanaButton -PropertyType DWord -Value 0 -Force