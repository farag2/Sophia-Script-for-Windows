# Turn off location for this device
# Отключить местоположение для этого устройства
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location -Name Value -PropertyType String -Value Deny -Force