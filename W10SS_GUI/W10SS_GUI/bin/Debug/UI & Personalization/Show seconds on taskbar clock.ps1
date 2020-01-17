# Show seconds on taskbar clock
# Отображать секунды в системных часах на панели задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSecondsInSystemClock -PropertyType DWord -Value 1 -Force