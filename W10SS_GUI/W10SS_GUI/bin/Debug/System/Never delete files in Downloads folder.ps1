 Never delete files in "Downloads" folder
# Никогда не удалять файлы из папки "Загрузки"
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 512 -PropertyType DWord -Value 0 -Force