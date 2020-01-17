# Remove "Print" from batch and cmd files context menu
# Удалить пункт "Печать" из контекстного меню для bat- и cmd-файлов
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\batfile\shell\print -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\cmdfile\shell\print -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force