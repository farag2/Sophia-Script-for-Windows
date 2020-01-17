# Let Windows try to fix apps so they're not blurry
# Разрешить Windows исправлять размытость в приложениях
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name EnablePerProcessSystemDPI -PropertyType DWord -Value 1 -Force