# Do not show all folders in the navigation pane
# Не отображать все папки в области навигации
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -PropertyType DWord -Value 0 -Force