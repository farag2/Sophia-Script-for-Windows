# Do not show suggested content in the Settings
# Не показывать рекомендуемое содержание в "Параметрах"
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338393Enabled -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-353694Enabled -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-353696Enabled -PropertyType DWord -Value 0 -Force