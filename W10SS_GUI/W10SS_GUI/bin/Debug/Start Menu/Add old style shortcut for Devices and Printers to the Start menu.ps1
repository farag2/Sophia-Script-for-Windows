# Add old style shortcut for "Devices and Printers" to the Start menu
# Добавить ярлык старого формата для "Устройства и принтеры" в меню Пуск
$target = "control"
$linkname = (Get-ControlPanelItem | Where-Object -FilterScript {$_.CanonicalName -eq "Microsoft.DevicesAndPrinters"}).Name
$link = "$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\$linkname.lnk"
$shell = New-Object -ComObject Wscript.Shell
$shortcut = $shell.CreateShortcut($link)
$shortcut.TargetPath = $target
$shortcut.Arguments = "printers"
$shortCut.IconLocation = "$env:SystemRoot\system32\DeviceCenter.dll"
$shortcut.Save()