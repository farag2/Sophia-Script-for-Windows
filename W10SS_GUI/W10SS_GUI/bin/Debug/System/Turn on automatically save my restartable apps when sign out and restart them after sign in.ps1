# Turn on automatically save my restartable apps when sign out and restart them after sign in
# Автоматически сохранять мои перезапускаемые приложения при выходе из системы и перезапустить их после выхода
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name RestartApps -Value 1 -Force