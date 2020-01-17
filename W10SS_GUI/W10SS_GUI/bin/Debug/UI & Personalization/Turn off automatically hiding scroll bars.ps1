# Turn off automatically hiding scroll bars
# Отключить автоматическое скрытие полос прокрутки в Windows
New-ItemProperty -Path "HKCU:\Control Panel\Accessibility" -Name DynamicScrollbars -PropertyType DWord -Value 0 -Force