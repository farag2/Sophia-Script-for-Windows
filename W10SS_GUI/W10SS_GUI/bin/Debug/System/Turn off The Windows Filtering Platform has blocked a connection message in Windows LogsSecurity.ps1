# Turn off "The Windows Filtering Platform has blocked a connection" message in "Windows Logs/Security"
# Отключить в "Журналах Windows/Безопасность" сообщение "Платформа фильтрации IP-пакетов Windows разрешила подключение"
auditpol /set /subcategory:"{0CCE9226-69AE-11D9-BED3-505054503030}" /success:disable /failure:enable