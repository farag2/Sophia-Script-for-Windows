# Turn off AutoPlay for all media and devices
# Отключить автозапуск с внешних носителей
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers -Name DisableAutoplay -PropertyType DWord -Value 1 -Force