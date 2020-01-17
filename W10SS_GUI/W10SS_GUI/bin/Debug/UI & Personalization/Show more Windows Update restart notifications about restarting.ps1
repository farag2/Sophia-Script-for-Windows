# Show more Windows Update restart notifications about restarting
# Показывать уведомление, когда компьютеру требуется перезагрузка для завершения обновления
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name RestartNotificationsAllowed2 -PropertyType DWord -Value 1 -Force