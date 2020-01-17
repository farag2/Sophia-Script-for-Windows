# Open shortcut to the Command Prompt from Start menu as Administrator
# Запускать ярлык к командной строке в меню "Пуск" от имени Администратора
[byte[]]$bytes = Get-Content -Path "$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\Command Prompt.lnk" -Encoding Byte -Raw
$bytes[0x15] = $bytes[0x15] -bor 0x20
Set-Content -Path "$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\Command Prompt.lnk" -Value $bytes -Encoding Byte -Force