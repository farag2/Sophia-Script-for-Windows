# Turn on Windows Sandbox
# Включить Windows Sandbox
IF (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -eq "Professional" -or $_.Edition -eq "Enterprise"})
{
	IF ((Get-CimInstance -ClassName CIM_Processor).VirtualizationFirmwareEnabled -eq $true)
	{
		Enable-WindowsOptionalFeature –FeatureName Containers-DisposableClientVM -All -Online -NoRestart
	}
	else
	{
		try
		{
			IF ((Get-CimInstance –ClassName CIM_ComputerSystem).HypervisorPresent -eq $true)
			{
				Enable-WindowsOptionalFeature –FeatureName Containers-DisposableClientVM -All -Online -NoRestart
			}
		}
		catch
		{
			Write-Error "Enable Virtualization in BIOS"
		}
	}
}