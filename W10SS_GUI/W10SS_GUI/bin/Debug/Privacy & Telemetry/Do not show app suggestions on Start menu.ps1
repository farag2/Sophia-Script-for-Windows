# Do not show app suggestions on Start menu
# Не показывать рекомендации в меню "Пуск"
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338388Enabled -PropertyType DWord -Value 0 -Force