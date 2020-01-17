# Turn off "Connected User Experiences and Telemetry" service
# Отключить службу "Функциональные возможности для подключенных пользователей и телеметрия"
Get-Service -Name DiagTrack | Stop-Service -Force
Get-Service -Name DiagTrack | Set-Service -StartupType Disabled