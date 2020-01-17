# Remove "Edit" from images context menu
# Удалить пункт "Изменить" из контекстного меню изображений
IF (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\edit\command))
{
	New-Item -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\edit\command -Force
}
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\edit -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\edit\command -Name "(default)" -PropertyType ExpandString -Value "`"%systemroot%\system32\mspaint.exe`" `"%1`"" -Force