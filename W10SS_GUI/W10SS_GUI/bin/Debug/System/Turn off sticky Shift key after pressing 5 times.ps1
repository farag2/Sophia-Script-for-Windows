# Turn off sticky Shift key after pressing 5 times
# Отключить залипание клавиши Shift после 5 нажатий
New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name Flags -PropertyType String -Value 506 -Force