# Do not show Task View button on taskbar
# Не показывать кнопку Просмотра задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -PropertyType DWord -Value 0 -Force