# Hide search box or search icon on taskbar
# Скрыть поле или значок поиска на панели задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -PropertyType DWord -Value 0 -Force