# Do not preserve zone information
# Не хранить сведения о зоне происхождения вложенных файлов
IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -Name SaveZoneInformation -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments -Name SaveZoneInformation -PropertyType DWord -Value 1 -Force