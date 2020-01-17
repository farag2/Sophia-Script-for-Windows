# Remove "Send to" from folder context menu
# Удалить пункт "Отправить" из контекстного меню папки
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo -Name "(default)" -PropertyType String -Value "" -Force