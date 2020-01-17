# Turn off Windows Error Reporting
# Отключить отчеты об ошибках Windows
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Windows Error Reporting" -Name Disabled -PropertyType DWord -Value 1 -Force