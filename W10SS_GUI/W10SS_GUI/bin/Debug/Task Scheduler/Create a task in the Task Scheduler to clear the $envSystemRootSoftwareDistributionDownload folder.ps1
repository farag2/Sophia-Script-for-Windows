# Create a task in the Task Scheduler to clear the $env:SystemRoot\SoftwareDistribution\Download folder
# The task runs on Thursdays every 4 weeks
# Создать задачу в Планировщике задач по очистке папки $env:SystemRoot\SoftwareDistribution\Download
# Задача выполняется по четвергам каждую 4 неделю
$action = New-ScheduledTaskAction -Execute powershell.exe -Argument @"
	`$getservice = Get-Service -Name wuauserv
	`$getservice.WaitForStatus("Stopped", "01:00:00")
	Get-ChildItem -Path `$env:SystemRoot\SoftwareDistribution\Download -Recurse -Force | Remove-Item -Recurse -Force
"@
$trigger = New-JobTrigger -Weekly -WeeksInterval 4 -DaysOfWeek Thursday -At 9am
$settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
$principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -RunLevel Highest
$params = @{
	"TaskName"	=	"SoftwareDistribution"
	"Action"	=	$action
	"Trigger"	=	$trigger
	"Settings"	=	$settings
	"Principal"	=	$principal
}
Register-ScheduledTask @params -Force