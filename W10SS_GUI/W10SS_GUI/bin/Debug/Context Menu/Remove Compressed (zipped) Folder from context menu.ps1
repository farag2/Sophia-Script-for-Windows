# Remove "Compressed (zipped) Folder" from context menu
# Удалить пункт "Сжатая ZIP-папка" из контекстного меню
Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew -Force -ErrorAction SilentlyContinue