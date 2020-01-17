# Run troubleshooters automatically, then notify ###
# Автоматически запускать средства устранения неполадок, а затем уведомлять
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 3 -Force
IF (-not (Test-Path -Path HKLM:\SOFTWARE\Microsoft\WindowsMitigation))
{
	New-Item -Path HKLM:\SOFTWARE\Microsoft\WindowsMitigation -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsMitigation -Name UserPreference -PropertyType DWord -Value 3 -Force