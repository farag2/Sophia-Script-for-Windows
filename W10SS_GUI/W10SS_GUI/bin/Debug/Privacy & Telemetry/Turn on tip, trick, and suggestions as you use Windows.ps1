# Turn on tip, trick, and suggestions as you use Windows
# Показывать советы, подсказки и рекомендации при использованию Windows
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338389Enabled -PropertyType DWord -Value 1 -Force