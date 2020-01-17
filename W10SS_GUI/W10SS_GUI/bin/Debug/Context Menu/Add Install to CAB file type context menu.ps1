# Add "Install" to CAB file type context menu
# Добавить пункт "Установить" для CAB-файлов в контекстном меню
IF (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command))
{
	New-Item -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command -Force
}
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command -Name "(default)" -PropertyType String -Value "cmd /c DISM /Online /Add-Package /PackagePath:`"%1`" /NoRestart & pause" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs -Name MUIVerb -PropertyType String -Value "@shell32.dll,-10210" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs -Name HasLUAShield -PropertyType String -Value "" -Force