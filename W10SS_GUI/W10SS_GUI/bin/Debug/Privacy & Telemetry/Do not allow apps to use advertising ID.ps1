# Do not allow apps to use advertising ID
# Не разрешать приложениям использовать идентификатор рекламы
New-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -PropertyType DWord -Value 0 -Force