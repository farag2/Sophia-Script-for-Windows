# Turn off Delivery Optimization
# Отключить оптимизацию доставки
Get-Service -Name DoSvc | Stop-Service -Force
IF (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization -Name DODownloadMode -PropertyType DWord -Value 0 -Force