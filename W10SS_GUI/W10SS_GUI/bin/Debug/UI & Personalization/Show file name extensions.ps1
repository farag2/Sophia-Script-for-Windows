# Show file name extensions
# Показывать расширения для зарегистрированных типов файлов
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -PropertyType DWord -Value 0 -Force