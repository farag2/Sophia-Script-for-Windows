# Add "Extract" to MSI file type context menu
# Добавить пункт "Extract" для MSI в контекстное меню
IF (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command))
{
	New-Item -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command -Force
}
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command -Name "(default)" -PropertyType String -Value "msiexec.exe /a `"%1`" /qb TARGETDIR=`"%1 extracted`"" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Name MUIVerb -PropertyType String -Value "@shell32.dll,-31382" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Name Icon -PropertyType String -Value "shell32.dll,-16817" -Force