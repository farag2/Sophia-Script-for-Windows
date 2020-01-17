# Turn off diagnostics tracking scheduled tasks
# Отключить задачи диагностического отслеживания
$tasks = @(
	"ProgramDataUpdater"
	"Microsoft Compatibility Appraiser"
	"Microsoft-Windows-DiskDiagnosticDataCollector"
	"TempSignedLicenseExchange"
	"MapsToastTask"
	"DmClient"
	"FODCleanupTask"
	"DmClientOnScenarioDownload"
	"BgTaskRegistrationMaintenanceTask"
	"File History (maintenance mode)"
	"WinSAT"
	"UsbCeip"
	"Consolidator"
	"Proxy"
	"MNO Metadata Parser"
	"NetworkStateChangeTask"
	"GatherNetworkInfo"
	"XblGameSaveTask"
	"EnableLicenseAcquisition"
	"QueueReporting"
	"FamilySafetyMonitor"
	"FamilySafetyRefreshTask"
)
Get-ScheduledTask -TaskName $tasks | Disable-ScheduledTask