# Remove the "Previous Versions" tab from properties context menu
# Отключить отображение вкладки "Предыдущие версии" в свойствах файлов и папок
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name NoPreviousVersionsPage -PropertyType DWord -Value 1 -Force