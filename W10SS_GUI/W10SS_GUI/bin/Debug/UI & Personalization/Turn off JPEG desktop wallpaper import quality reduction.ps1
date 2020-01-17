# Turn off JPEG desktop wallpaper import quality reduction
# Отключить снижение качества фона рабочего стола в формате JPEG
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name JPEGImportQuality -PropertyType DWord -Value 100 -Force