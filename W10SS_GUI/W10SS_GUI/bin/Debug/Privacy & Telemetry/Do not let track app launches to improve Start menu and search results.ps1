# Do not let track app launches to improve Start menu and search results
# Не разрешать Windows отслеживать запуски приложений для улучшения меню "Пуск" и результатов поиска ###
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Start_TrackProgs -PropertyType DWord -Value 0 -Force