# Always show all icons in the notification area
# Всегда отображать все значки в области уведомлений
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray -PropertyType DWord -Value 0 -Force