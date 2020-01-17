# Do not show recently added apps on Start menu
# Не показывать недавно добавленные приложения в меню "Пуск"
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name HideRecentlyAddedApps -PropertyType DWord -Value 1 -Force