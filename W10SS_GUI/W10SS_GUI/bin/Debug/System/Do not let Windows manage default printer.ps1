# Do not let Windows manage default printer
# Не разрешать Windows управлять принтером, используемым по умолчанию
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows" -Name LegacyDefaultPrinterMode -PropertyType DWord -Value 1 -Force