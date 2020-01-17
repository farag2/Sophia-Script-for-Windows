# Show "Explorer" and "Settings" folders on Start menu
# Отобразить папки "Проводник" и "Параметры" в меню "Пуск"
$items = @("File Explorer", "Settings")
$startmenu = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*windows.data.unifiedtile.startglobalproperties\Current"
$data = $startmenu.Data[0..19] -join ","
$data += ",203,50,10,$($items.Length)"
# Explorer
# Проводник
$data += ",5,188,201,168,164,1,36,140,172,3,68,137,133,1,102,160,129,186,203,189,215,168,164,130,1,0"
# Settings
# Параметры
$data += ",5,134,145,204,147,5,36,170,163,1,68,195,132,1,102,159,247,157,177,135,203,209,172,212,1,0"
$data += ",194,60,1,194,70,1,197,90,1,0"
New-ItemProperty -Path $startmenu.PSPath -Name Data -PropertyType Binary -Value $data.Split(",") -Force