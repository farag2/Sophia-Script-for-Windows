# Turn off and delete reserved storage after the next update installation
# Отключить и удалить зарезервированное хранилище после следующей установки обновлений
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager -Name BaseHardReserveSize -PropertyType QWord -Value 0 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager -Name BaseSoftReserveSize -PropertyType QWord -Value 0 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager -Name HardReserveAdjustment -PropertyType QWord -Value 0 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager -Name MinDiskSize -PropertyType QWord -Value 0 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager -Name ShippedWithReserves -PropertyType DWord -Value 0 -Force