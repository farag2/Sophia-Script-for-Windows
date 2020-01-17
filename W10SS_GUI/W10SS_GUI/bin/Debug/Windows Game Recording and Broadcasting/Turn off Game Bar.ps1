# Turn off Game Bar
# Отключить игровую панель
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR -Name AppCaptureEnabled -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKCU:\System\GameConfigStore -Name GameDVR_Enabled -PropertyType DWord -Value 0 -Force