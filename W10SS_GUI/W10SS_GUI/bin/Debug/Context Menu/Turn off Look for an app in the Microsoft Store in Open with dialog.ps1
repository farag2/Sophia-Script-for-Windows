# Turn off "Look for an app in the Microsoft Store" in "Open with" dialog
# Отключить поиск программ в Microsoft Store при открытии диалога "Открыть с помощью"
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name NoUseStoreOpenWith -PropertyType DWord -Value 1 -Force