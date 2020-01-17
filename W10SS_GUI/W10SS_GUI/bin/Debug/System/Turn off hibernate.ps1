# Turn off hibernate
# Отключить гибридный спящий режим
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Power -Name HibernateEnabled -PropertyType DWord -Value 0 -Force