# Automatically adjust active hours for me based on daily usage
# Автоматически изменять период активности для этого устройства на основе действий
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name SmartActiveHoursState -PropertyType DWord -Value 1 -Force