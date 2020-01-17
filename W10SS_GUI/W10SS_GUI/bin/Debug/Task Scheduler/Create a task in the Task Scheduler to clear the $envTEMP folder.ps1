# Create a task in the Task Scheduler to clear the $env:TEMP folder
# The task runs every 62 days
# Создать задачу в Планировщике задач по очистке папки $env:TEMP
# Задача выполняется каждые 62 дня
$action = New-ScheduledTaskAction -Execute powershell.exe -Argument @"
	Get-ChildItem -Path `$env:TEMP -Force -Recurse | Remove-Item -Force -Recurse
"@
$trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 62 -At 9am
$settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
$principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -RunLevel Highest
$params = @{
	"TaskName"	=	"Temp"
	"Action"	=	$action
	"Trigger"	=	$trigger
	"Settings"	=	$settings
	"Principal"	=	$principal
}
Register-ScheduledTask @params -Force