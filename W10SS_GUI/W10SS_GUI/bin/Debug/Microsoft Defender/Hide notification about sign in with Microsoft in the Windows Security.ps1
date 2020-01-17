# Hide notification about sign in with Microsoft in the Windows Security
# Скрыть уведомление Защитника Windows об использовании аккаунта Microsoft
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows Security Health\State" -Name AccountProtection_MicrosoftAccount_Disconnected -PropertyType DWord -Value 1 -Force