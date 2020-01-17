# Turn on Storage Sense
# Включить Память устройства
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01 -PropertyType DWord -Value 1 -Force