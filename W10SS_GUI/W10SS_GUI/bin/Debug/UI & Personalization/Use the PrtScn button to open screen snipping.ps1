# Use the PrtScn button to open screen snipping
# Использовать кнопку PRINT SCREEN, чтобы запустить функцию создания фрагмента экрана
New-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name PrintScreenKeyForSnippingEnabled -PropertyType DWord -Value 1 -Force