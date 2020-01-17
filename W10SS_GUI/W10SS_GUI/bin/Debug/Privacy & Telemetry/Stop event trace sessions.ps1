# Stop event trace sessions ###
# Остановить сеансы отслеживания событий
Get-EtwTraceSession -Name DiagLog, Diagtrack-Listener | Remove-EtwTraceSession