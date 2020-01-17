# Hide notification about disabled SmartScreen for Microsoft Edge ###
# Скрыть уведомление Защитника Windows об отключенном фильтре SmartScreen для Microsoft Edge
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows Security Health\State" -Name AppAndBrowser_EdgeSmartScreenOff -PropertyType DWord -Value 0 -Force