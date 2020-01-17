# Turn off the data collectors at the next computer restart ###
# Отключить сборщики данных при следующем запуске ПК
Update-AutologgerConfig -Name DiagLog, SQMLogger -Start 0