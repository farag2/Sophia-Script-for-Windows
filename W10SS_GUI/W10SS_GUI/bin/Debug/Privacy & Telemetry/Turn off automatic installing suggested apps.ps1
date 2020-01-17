# Turn off automatic installing suggested apps
# Отключить автоматическую установку рекомендованных приложений
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SilentInstalledAppsEnabled -PropertyType DWord -Value 0 -Force