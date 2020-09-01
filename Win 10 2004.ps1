<#
.SYNOPSIS
	"Windows 10 Setup Script" is a set of tweaks for OS fine-tuning and automating the routine tasks

	Version: v4.5.7
	Date: 17.08.2020
	Copyright (c) 2020 farag & oZ-Zo

	Thanks to all http://forum.ru-board.com members involved

.DESCRIPTION
	Supported Windows 10 version: 2004 (20H1), 19041 build, x64
	Most of functions can be run also on LTSB/LTSC

	Tested on Home/Pro/Enterprise editions

	Due to the fact that the script includes about 150 functions,
	you must read the entire script and comment out those sections that you do not want to be executed,
	otherwise likely you will enable features that you do not want to be enabled

	Running the script is best done on a fresh install because running it on tweaked system may result in errors occurring

	Some third-party antiviruses flag this script or its' part as malicious one. This is a false positive due to $EncodedScript variable
	You can read more on section "Create a Windows cleaning up task in the Task Scheduler"
	You might need to disable tamper protection from your antivirus settings,re-enable it after running the script, and reboot

	Check whether the .ps1 file is encoded in UTF-8 with BOM
	The script can not be executed via PowerShell ISE
	PowerShell must be run with elevated privileges

	Set execution policy to be able to run scripts only in the current PowerShell session:
		Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

.EXAMPLE
	PS C:\> & '.\Win 10 2004.ps1'

.NOTES
	Ask a question on
	http://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15
	https://habr.com/en/post/465365/
	https://4pda.ru/forum/index.php?showtopic=523489&st=42860#entry95909388
	https://forums.mydigitallife.net/threads/powershell-script-setup-windows-10.81675/
	https://www.reddit.com/r/PowerShell/comments/go2n5v/powershell_script_setup_windows_10/

.LINK
	https://github.com/farag2/Windows-10-Setup-Script
#>

#Requires -RunAsAdministrator
#Requires -Version 5.1

#region Check
Clear-Host

# Get information about the current culture settings
# Получить сведения о параметрах текущей культуры
if ($PSUICulture -eq "ru-RU")
{
	$RU = $true
}
else
{
	$RU = $false
}

# Detect the OS bitness
# Определить разрядность ОС
switch ([Environment]::Is64BitOperatingSystem)
{
	$false
	{
		if ($RU)
		{
			Write-Warning -Message "Скрипт поддерживает только Windows 10 x64"
		}
		else
		{
			Write-Warning -Message "The script supports Windows 10 x64 only"
		}
		break
	}
	Default {}
}

# Detect the PowerShell bitness
# Определить разрядность PowerShell
switch ([IntPtr]::Size -eq 8)
{
	$false
	{
		if ($RU)
		{
			Write-Warning -Message "Скрипт поддерживает только PowerShell x64"
		}
		else
		{
			Write-Warning -Message "The script supports PowerShell x64 only"
		}
		break
	}
	Default {}
}

# Detect whether the script is running via PowerShell ISE
# Определить, запущен ли скрипт в PowerShell ISE
if ($psISE)
{
	if ($RU)
	{
		Write-Warning -Message "Скрипт не может быть запущен в PowerShell ISE"
	}
	else
	{
		Write-Warning -Message "The script can not be run via PowerShell ISE"
	}
	break
}
#endregion Check

#region Begin
Set-StrictMode -Version Latest

# Сlear $Error variable
# Очистка переменной $Error
$Error.Clear()

# Create a restore point
# Создать точку восстановления
if ($RU)
{
	$Title = "Точка восстановления"
	$Message = "Чтобы создайте точку восстановления, введите необходимую букву"
	$Options = "&Создать", "&Не создавать", "&Пропустить"
}
else
{
	$Title = "Restore point"
	$Message = "To create a restore point enter the required letter"
	$Options = "&Create", "&Do not create", "&Skip"
}
$DefaultChoice = 2
$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

switch ($Result)
{
	"0"
	{
		if (-not (Get-ComputerRestorePoint))
		{
			Enable-ComputerRestore -Drive $env:SystemDrive
		}
		# Set system restore point creation frequency to 5 minutes
		# Установить частоту создания точек восстановления на 5 минут
		New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name SystemRestorePointCreationFrequency -PropertyType DWord -Value 5 -Force
		# Descriptive name format for the restore point: <Month>.<date>.<year> <time>
		# Формат описания точки восстановления: <дата>.<месяц>.<год> <время>
		$CheckpointDescription = Get-Date -Format "dd.MM.yyyy HH:mm"
		Checkpoint-Computer -Description $CheckpointDescription -RestorePointType MODIFY_SETTINGS
		New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name SystemRestorePointCreationFrequency -PropertyType DWord -Value 1440 -Force
	}
	"1"
	{
		if ($RU)
		{
			$Title = "Точки восстановления"
			$Message = "Чтобы удалить все точки восстановления, введите необходимую букву"
			$Options = "&Удалить", "&Пропустить"
		}
		else
		{
			$Title = "Restore point"
			$Message = "To remove all restore points enter the required letter"
			$Options = "&Delete", "&Skip"
		}
		$DefaultChoice = 1
		$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

		switch ($Result)
		{
			"0"
			{
				# Delete all restore points
				# Удалить все точки восстановения
				Get-CimInstance -ClassName Win32_ShadowCopy | Remove-CimInstance
			}
			"1"
			{
				if ($RU)
				{
					Write-Verbose -Message "Пропущено" -Verbose
				}
				else
				{
					Write-Verbose -Message "Skipped" -Verbose
				}
			}
		}
	}
	"2"
	{
		if ($RU)
		{
			Write-Verbose -Message "Пропущено" -Verbose
		}
		else
		{
			Write-Verbose -Message "Skipped" -Verbose
		}
	}
}
#endregion Begin

#region Privacy & Telemetry
# Turn off "Connected User Experiences and Telemetry" service
# Отключить службу "Функциональные возможности для подключенных пользователей и телеметрия"
Get-Service -Name DiagTrack | Stop-Service -Force
Get-Service -Name DiagTrack | Set-Service -StartupType Disabled

# Set the minimal operating system diagnostic data level
# Установить минимальный уровень отправляемых диагностических сведений
if ((Get-WindowsEdition -Online).Edition -eq "Enterprise" -or (Get-WindowsEdition -Online).Edition -eq "Education")
{
	# "Security"
	# "Безопасность"
	New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 0 -Force
}
else
{
	# "Basic"
	# "Базовый"
	New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 1 -Force
}

# Turn off Windows Error Reporting
# Отключить отчеты об ошибках Windows
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Windows Error Reporting" -Name Disabled -PropertyType DWord -Value 1 -Force

# Change Windows Feedback frequency to "Never"
# Изменить частоту формирования отзывов на "Никогда"
if (-not (Test-Path -Path HKCU:\Software\Microsoft\Siuf\Rules))
{
	New-Item -Path HKCU:\Software\Microsoft\Siuf\Rules -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Siuf\Rules -Name NumberOfSIUFInPeriod -PropertyType DWord -Value 0 -Force

# Turn off diagnostics tracking scheduled tasks
# Отключить задачи диагностического отслеживания
$tasks = @(
	# Collects program telemetry information if opted-in to the Microsoft Customer Experience Improvement Program.
	# Собирает телеметрические данные программы при участии в Программе улучшения качества программного обеспечения Майкрософт
	"Microsoft Compatibility Appraiser"
	# Collects program telemetry information if opted-in to the Microsoft Customer Experience Improvement Program
	# Сбор телеметрических данных программы при участии в программе улучшения качества ПО
	"ProgramDataUpdater"
	# This task collects and uploads autochk SQM data if opted-in to the Microsoft Customer Experience Improvement Program
	# Эта задача собирает и загружает данные SQM при участии в программе улучшения качества программного обеспечения
	"Proxy"
	# If the user has consented to participate in the Windows Customer Experience Improvement Program, this job collects and sends usage data to Microsoft
	# Если пользователь изъявил желание участвовать в программе по улучшению качества программного обеспечения Windows, эта задача будет собирать и отправлять сведения о работе программного обеспечения в Майкрософт
	"Consolidator"
	# The USB CEIP (Customer Experience Improvement Program) task collects Universal Serial Bus related statistics and information about your machine
	# При выполнении задачи программы улучшения качества ПО шины USB (USB CEIP) осуществляется сбор статистических данных об использовании универсальной последовательной шины USB и сведений о компьютере
	"UsbCeip"
	# The Windows Disk Diagnostic reports general disk and system information to Microsoft for users participating in the Customer Experience Program
	# Для пользователей, участвующих в программе контроля качества программного обеспечения, служба диагностики дисков Windows предоставляет общие сведения о дисках и системе в корпорацию Майкрософт
	"Microsoft-Windows-DiskDiagnosticDataCollector"
	# Protects user files from accidental loss by copying them to a backup location when the system is unattended
	# Защищает файлы пользователя от случайной потери за счет их копирования в резервное расположение, когда система находится в автоматическом режиме
	"File History (maintenance mode)"
	# Measures a system's performance and capabilities
	# Измеряет быстродействие и возможности системы
	"WinSAT"
	# This task shows various Map related toasts
	# Эта задача показывает различные тосты (всплывающие уведомления) приложения "Карты"
	"MapsToastTask"
	# This task checks for updates to maps which you have downloaded for offline use
	# Эта задача проверяет наличие обновлений для карт, загруженных для автономного использования
	"MapsUpdateTask"
	# Initializes Family Safety monitoring and enforcement
	# Инициализация контроля и применения правил семейной безопасности
	"FamilySafetyMonitor"
	# Synchronizes the latest settings with the Microsoft family features service
	# Синхронизирует последние параметры со службой функций семьи учетных записей Майкрософт
	"FamilySafetyRefreshTask"
	# Windows Error Reporting task to process queued reports
	# Задача отчетов об ошибках обрабатывает очередь отчетов
	"QueueReporting"
	# XblGameSave Standby Task
	"XblGameSaveTask"
)
# If device is not a laptop
# Если устройство не является ноутбуком
if ((Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType -ne 2)
{
	# HelloFace
	$tasks += "FODCleanupTask"
}
Get-ScheduledTask -TaskName $tasks | Disable-ScheduledTask

# Do not use sign-in info to automatically finish setting up device and reopen apps after an update or restart
# Не использовать данные для входа для автоматического завершения настройки устройства и открытия приложений после перезапуска или обновления
$SID = (Get-CimInstance -ClassName Win32_UserAccount | Where-Object -FilterScript {$_.Name -eq $env:USERNAME}).SID
if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$SID"))
{
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$SID" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$SID" -Name OptOut -PropertyType DWord -Value 1 -Force

# Do not let websites provide locally relevant content by accessing language list
# Не позволять веб-сайтам предоставлять местную информацию за счет доступа к списку языков
New-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name HttpAcceptLanguageOptOut -PropertyType DWord -Value 1 -Force

# Do not allow apps to use advertising ID
# Не разрешать приложениям использовать идентификатор рекламы
if (-not (Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -PropertyType DWord -Value 0 -Force

# Do not let apps on other devices open and message apps on this device, and vice versa
# Не разрешать приложениям на других устройствах запускать приложения и отправлять сообщения на этом устройстве и наоборот
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\CDP -Name RomeSdkChannelUserAuthzPolicy -PropertyType DWord -Value 0 -Force

# Do not show the Windows welcome experiences after updates and occasionally when I sign in to highlight what's new and suggested
# Не показывать экран приветствия Windows после обновлений и иногда при входе, чтобы сообщить о новых функциях и предложениях
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-310093Enabled -PropertyType DWord -Value 0 -Force

# Get tip, trick, and suggestions as you use Windows
# Получать советы, подсказки и рекомендации при использованию Windows
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338389Enabled -PropertyType DWord -Value 1 -Force

# Do not show suggested content in the Settings app
# Не показывать рекомендуемое содержимое в приложении "Параметры"
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338393Enabled -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-353694Enabled -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-353696Enabled -PropertyType DWord -Value 0 -Force

# Turn off automatic installing suggested apps
# Отключить автоматическую установку рекомендованных приложений
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SilentInstalledAppsEnabled -PropertyType DWord -Value 0 -Force

# Do not suggest ways I can finish setting up my device to get the most out of Windows
# Не предлагать способы завершения настройки устройства для максимально эффективного использования Windows
if (-not (Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Name ScoobeSystemSettingEnabled -PropertyType DWord -Value 0 -Force

# Do not offer tailored experiences based on the diagnostic data setting
# Не предлагать персонализированные возможности, основанные на выбранном параметре диагностических данных
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy -Name TailoredExperiencesWithDiagnosticDataEnabled -PropertyType DWord -Value 0 -Force
#endregion Privacy & Telemetry

#region UI & Personalization
# Show "This PC" on Desktop
# Отобразить "Этот компьютер" на рабочем столе
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -PropertyType DWord -Value 0 -Force

# Do not use check boxes to select items
# Не использовать флажки для выбора элементов
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name AutoCheckSelect -PropertyType DWord -Value 0 -Force

# Show hidden files, folders, and drives
# Показывать скрытые файлы, папки и диски
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -PropertyType DWord -Value 1 -Force

# Show file name extensions
# Показывать расширения для зарегистрированных типов файлов
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -PropertyType DWord -Value 0 -Force

# Do not hide folder merge conflicts
# Не скрывать конфликт слияния папок
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideMergeConflicts -PropertyType DWord -Value 0 -Force

# Open File Explorer to: "This PC"
# Открывать проводник для: "Этот компьютер"
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -PropertyType DWord -Value 1 -Force

# Do not show all folders in the navigation pane
# Не отображать все папки в области навигации
# New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -PropertyType DWord -Value 0 -Force

# Do not show Cortana button on taskbar
# Не показывать кнопку Кортаны на панели задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCortanaButton -PropertyType DWord -Value 0 -Force

# Do not show sync provider notification within File Explorer
# Не показывать уведомления поставщика синхронизации в проводнике
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSyncProviderNotifications -PropertyType DWord -Value 0 -Force

# Do not show Task View button on taskbar
# Не показывать кнопку Просмотра задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -PropertyType DWord -Value 0 -Force

# Do not show People button on the taskbar
# Не показывать панель "Люди" на панели задач
if (-not (Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Name PeopleBand -PropertyType DWord -Value 0 -Force

# Show seconds on taskbar clock
# Отображать секунды в системных часах на панели задач
# New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSecondsInSystemClock -PropertyType DWord -Value 1 -Force

# Do not show when snapping a window, what can be attached next to it
# Не показывать при прикреплении окна, что можно прикрепить рядом с ним
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SnapAssist -PropertyType DWord -Value 0 -Force

# Show more details in file transfer dialog
# Развернуть диалог переноса файлов
if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Name EnthusiastMode -PropertyType DWord -Value 1 -Force

# Show the Ribbon expanded in File Explorer
# Отображать ленту проводника в развернутом виде
if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Name MinimizedStateTabletModeOff -PropertyType DWord -Value 0 -Force

<#
Display recycle bin files delete confirmation
Function [WinAPI.UpdateExplorer]::PostMessage() call required at the end

Запрашивать подтверждение на удаление файлов в корзину
В конце необходим вызов функции [WinAPI.UpdateExplorer]::PostMessage()
#>
$ShellState = Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShellState
$ShellState[4] = 51
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShellState -PropertyType Binary -Value $ShellState -Force

# Hide 3D Objects folder from "This PC" and from Quick access
# Скрыть папку "Объемные объекты" из "Этот компьютер" и из панели быстрого доступа
if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"))
{
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name ThisPCPolicy -PropertyType String -Value Hide -Force

# Do not show "Frequent folders" in Quick access
# Не показывать недавно используемые папки на панели быстрого доступа
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -PropertyType DWord -Value 0 -Force

# Do not show "Recent files" in Quick access
# Не показывать недавно использовавшиеся файлы на панели быстрого доступа
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -PropertyType DWord -Value 0 -Force

# Hide search box or search icon on taskbar
# Скрыть поле или значок поиска на панели задач
# New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -PropertyType DWord -Value 0 -Force

# Do not show "Windows Ink Workspace" button in taskbar
# Не показывать кнопку Windows Ink Workspace на панели задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\PenWorkspace -Name PenWorkspaceButtonDesiredVisibility -PropertyType DWord -Value 0 -Force

# Always show all icons in the notification area
# Всегда отображать все значки в области уведомлений
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray -PropertyType DWord -Value 0 -Force

# Unpin Microsoft Edge and Microsoft Store from taskbar
# Открепить Microsoft Edge и Microsoft Store от панели задач
$Signature = @{
	Namespace = "WinAPI"
	Name = "GetStr"
	Language = "CSharp"
	MemberDefinition = @"
// https://github.com/Disassembler0/Win10-Initial-Setup-Script/issues/8#issue-227159084
[DllImport("kernel32.dll", CharSet = CharSet.Auto)]
public static extern IntPtr GetModuleHandle(string lpModuleName);
[DllImport("user32.dll", CharSet = CharSet.Auto)]
internal static extern int LoadString(IntPtr hInstance, uint uID, StringBuilder lpBuffer, int nBufferMax);
public static string GetString(uint strId)
	{
	IntPtr intPtr = GetModuleHandle("shell32.dll");
	StringBuilder sb = new StringBuilder(255);
	LoadString(intPtr, strId, sb, sb.Capacity);
	return sb.ToString();
}
"@
}
if (-not ("WinAPI.GetStr" -as [type]))
{
	Add-Type @Signature -Using System.Text
}

# Extract the "Unpin from taskbar" string from shell32.dll
# Извлечь строку "Открепить от панели задач" из shell32.dll
$unpin = [WinAPI.GetStr]::GetString(5387)
$apps = (New-Object -ComObject Shell.Application).NameSpace("shell:::{4234d49b-0245-4df3-b780-3893943456e1}").Items()
$apps | Where-Object -FilterScript {$_.Path -like "Microsoft.MicrosoftEdge*"} | ForEach-Object -Process {$_.Verbs() | Where-Object -FilterScript {$_.Name -eq $unpin} | ForEach-Object -Process {$_.DoIt()}}
$apps | Where-Object -FilterScript {$_.Path -like "Microsoft.WindowsStore*"} | ForEach-Object -Process {$_.Verbs() | Where-Object -FilterScript {$_.Name -eq $unpin} | ForEach-Object -Process {$_.DoIt()}}

# Set the large icons in the Control Panel
# Установить крупные значки в Панели управления
# if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel))
# {
# 	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Force
# }
# New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name AllItemsIconView -PropertyType DWord -Value 0 -Force
# New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name StartupPage -PropertyType DWord -Value 1 -Force

# Choose theme color for default Windows mode
# Выбрать режим Windows по умолчанию
if ($RU)
{
	$Title = "Режим Windows по умолчанию"
	$Message = "Чтобы выбрать режим Windows по умолчанию, введите необходимую букву"
	$Options = "&Светлый", "&Темный", "&Пропустить"
}
else
{
	$Title = "Default Windows mode"
	$Message = "To choose theme color for default Windows mode enter the required letter"
	$Options = "&Light", "&Dark", "&Skip"
}
$DefaultChoice = 1
$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

switch ($Result)
{
	"0"
	{
		# Light theme color for default Windows mode
		# Режим Windows по умолчанию светлый
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -PropertyType DWord -Value 1 -Force
	}
	"1"
	{
		# Dark theme color for default Windows mode
		# Режим Windows по умолчанию темный
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -PropertyType DWord -Value 0 -Force
	}
	"2"
	{
		if ($RU)
		{
			Write-Verbose -Message "Пропущено" -Verbose
		}
		else
		{
			Write-Verbose -Message "Skipped" -Verbose
		}
	}
}

# Choose theme color for default app mode
# Выбрать режим приложения по умолчанию
if ($RU)
{
	$Title = "Режим приложения по умолчанию"
	$Message = "Чтобы выбрать режим приложения по умолчанию, введите необходимую букву"
	$Options = "&Светлый", "&Темный", "&Пропустить"
}
else
{
	$Title = "Default app mode"
	$Message = "To choose theme color for default app mode enter the required letter"
	$Options = "&Light", "&Dark", "&Skip"
}
$DefaultChoice = 1
$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

switch ($Result)
{
	"0"
	{
		# Light theme color for default app mode
		# Режим приложений по умолчанию светлый
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -PropertyType DWord -Value 1 -Force
	}
	"1"
	{
		# Dark theme color for default app mode
		# Режим приложений по умолчанию темный
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -PropertyType DWord -Value 0 -Force
	}
	"2"
	{
		if ($RU)
		{
			Write-Verbose -Message "Пропущено" -Verbose
		}
		else
		{
			Write-Verbose -Message "Skipped" -Verbose
		}
	}
}

# Do not show "New App Installed" notification
# Не показывать уведомление "Установлено новое приложение"
if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name NoNewAppAlert -PropertyType DWord -Value 1 -Force

# Do not show user first sign-in animation
# Не показывать анимацию при первом входе в систему
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableFirstLogonAnimation -PropertyType DWord -Value 0 -Force

# Turn off JPEG desktop wallpaper import quality reduction
# Отключить снижение качества при импорте фонового изображение рабочего стола в формате JPEG
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name JPEGImportQuality -PropertyType DWord -Value 100 -Force

# Expand Task manager window
# Раскрыть окно Диспетчера задач
$taskmgr = Get-Process -Name Taskmgr -ErrorAction Ignore
if ($taskmgr)
{
	$taskmgr.CloseMainWindow()
}
Start-Process -FilePath Taskmgr.exe -WindowStyle Hidden -PassThru
do
{
	Start-Sleep -Milliseconds 100
	$preferences = Get-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences -ErrorAction Ignore
}
until ($preferences)
Stop-Process -Name Taskmgr
$preferences.Preferences[28] = 0
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences -PropertyType Binary -Value $preferences.Preferences -Force

# Show a notification when your PC requires a restart to finish updating
# Показывать уведомление, когда компьютеру требуется перезагрузка для завершения обновления
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name RestartNotificationsAllowed2 -PropertyType DWord -Value 1 -Force

# Do not add the "- Shortcut" for created shortcuts
# Нe дoбaвлять "- яpлык" для coздaвaeмыx яpлыкoв
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name link -PropertyType Binary -Value ([byte[]](00, 00, 00, 00)) -Force

# Use the PrtScn button to open screen snipping
# Использовать кнопку PRINT SCREEN, чтобы запустить функцию создания фрагмента экрана
New-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name PrintScreenKeyForSnippingEnabled -PropertyType DWord -Value 1 -Force

# Turn on Windows 10 20H2 new Start style if minimum build version is 19041.423
# Включить новый стиль Пуска как в Windows 10 20H2, если номер билда минимум 19041.423
# if ((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name UBR) -ge 423)
# {
# 	if (-not (Test-Path -Path HKLM:\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\0\2093230218s))
# 	{
# 		New-Item -Path HKLM:\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\0\2093230218 -Force
# 	}
# 	New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\0\2093230218 -Name EnabledState -PropertyType DWORD -Value 2 -Force
# 	New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\0\2093230218 -Name EnabledStateOptions -PropertyType DWORD -Value 0 -Force
#}
#endregion UI & Personalization

#region OneDrive
# Uninstall OneDrive
# Удалить OneDrive
<#
[string]$UninstallString = Get-Package -Name "Microsoft OneDrive" -ErrorAction Ignore | ForEach-Object -Process {$_.Meta.Attributes["UninstallString"]}
if ($UninstallString)
{
	if ($RU)
	{
		Write-Verbose -Message "Удаление OneDrive" -Verbose
	}
	else
	{
		Write-Verbose -Message "Uninstalling OneDrive" -Verbose
	}
	Stop-Process -Name OneDrive -Force -ErrorAction Ignore
	Stop-Process -Name FileCoAuth -Force -ErrorAction Ignore

	# Save all opened folders in order to restore them after File Explorer restarting
	# Сохранить все открытые папки, чтобы восстановить их после перезапуска проводника
	Clear-Variable -Name OpenedFolders -Force -ErrorAction Ignore
	$OpenedFolders = {(New-Object -ComObject Shell.Application).Windows() | ForEach-Object -Process {$_.Document.Folder.Self.Path}}.Invoke()

	# Getting link to the OneDriveSetup.exe and its' argument(s)
	# Получаем ссылку на OneDriveSetup.exe и его аргумент(ы)
	[string[]]$OneDriveSetup = ($UninstallString -Replace("\s*/",",/")).Split(",").Trim()
	if ($OneDriveSetup.Count -eq 2)
	{
		Start-Process -FilePath $OneDriveSetup[0] -ArgumentList $OneDriveSetup[1..1] -Wait
	}
	else
	{
		Start-Process -FilePath $OneDriveSetup[0] -ArgumentList $OneDriveSetup[1..2] -Wait
	}
	Stop-Process -Name explorer -Force

	# Restoring closed folders
	# Восстановляем закрытые папки
	foreach ($OpenedFolder in $OpenedFolders)
	{
		if (Test-Path -Path $OpenedFolder)
		{
			Invoke-Item -Path $OpenedFolder
		}
	}

	# Getting the OneDrive user folder path
	# Получаем путь до папки пользователя OneDrive
	$OneDriveUserFolder = Get-ItemPropertyValue -Path HKCU:\Environment -Name OneDrive
	if ((Get-ChildItem -Path $OneDriveUserFolder | Measure-Object).Count -eq 0)
	{
		Remove-Item -Path $OneDriveUserFolder -Recurse -Force
	}
	else
	{
		if ($RU)
		{
			Write-Error -Message "Папка $OneDriveUserFolder не пуста. Удалите ее вручную" -ErrorAction SilentlyContinue
		}
		else
		{
			Write-Error -Message "The $OneDriveUserFolder folder is not empty. Delete it manually" -ErrorAction SilentlyContinue
		}
		Invoke-Item -Path $OneDriveUserFolder
	}

	Remove-ItemProperty -Path HKCU:\Environment -Name OneDrive, OneDriveConsumer -Force -ErrorAction Ignore
	Remove-Item -Path HKCU:\Software\Microsoft\OneDrive -Recurse -Force -ErrorAction Ignore
	Remove-Item -Path HKLM:\SOFTWARE\WOW6432Node\Microsoft\OneDrive -Recurse -Force -ErrorAction Ignore
	Remove-Item -Path "$env:ProgramData\Microsoft OneDrive" -Recurse -Force -ErrorAction Ignore
	Remove-Item -Path $env:SystemDrive\OneDriveTemp -Recurse -Force -ErrorAction Ignore
	Unregister-ScheduledTask -TaskName *OneDrive* -Confirm:$false

	# Getting the OneDrive folder path
	# Получаем путь до папки OneDrive
	$OneDriveFolder = Split-Path -Path (Split-Path -Path $OneDriveSetup[0] -Parent)
	# Waiting for the FileSyncShell64.dll to be unloaded, using System.IO.File class
	# Ожидаем, пока FileSyncShell64.dll выгрузится, используя класс System.IO.File
	$FileSyncShell64dllFolder = Get-ChildItem -Path "$OneDriveFolder\*\amd64\FileSyncShell64.dll" -Force
	foreach ($FileSyncShell64dll in $FileSyncShell64dllFolder)
	{
		do
		{
			try
			{
				$FileStream = [System.IO.File]::Open($FileSyncShell64dll.FullName,"Open","Write")
				$FileStream.Close()
				$FileStream.Dispose()
				$Locked = $false
			}
			catch [System.UnauthorizedAccessException]
			{
				$Locked = $true
			}
			catch [Exception]
			{
				Start-Sleep -Milliseconds 500
				if ($RU)
				{
					Write-Verbose -Message "Ожидаем, пока $FileSyncShell64dll будет разблокирована" -Verbose
				}
				else
				{
					Write-Verbose -Message "Waiting for the $FileSyncShell64dll to be unlocked" -Verbose
				}
			}
		}
		while ($Locked)
	}

	Remove-Item -Path $OneDriveFolder -Recurse -Force -ErrorAction Ignore
	Remove-Item -Path $env:LOCALAPPDATA\OneDrive -Recurse -Force -ErrorAction Ignore
	Remove-Item -Path $env:LOCALAPPDATA\Microsoft\OneDrive -Recurse -Force -ErrorAction Ignore
	Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" -Force -ErrorAction Ignore
}
#endregion OneDrive
#>

#region System
# Turn on Storage Sense
# Включить контроль памяти
#if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy))
#{
#	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -ItemType Directory -Force
#}
#New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01 -PropertyType DWord -Value 1 -Force
#if ((Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01) -eq "1")
#{
	# Run Storage Sense every month
	# Запускать контроль памяти каждый месяц
	# New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 2048 -PropertyType DWord -Value 30 -Force
	# Delete temporary files that apps aren't using
	# Удалять временные файлы, не используемые в приложениях
	# New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 04 -PropertyType DWord -Value 1 -Force
	# Delete files in recycle bin if they have been there for over 30 days
	# Удалять файлы из корзины, если они находятся в корзине более 30 дней
	# New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 256 -PropertyType DWord -Value 30 -Force
	# Never delete files in "Downloads" folder
	# Никогда не удалять файлы из папки "Загрузки"
	# New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 512 -PropertyType DWord -Value 0 -Force
#}

# Let Windows try to fix apps so they're not blurry
# Разрешить Windows исправлять размытость в приложениях
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name EnablePerProcessSystemDPI -PropertyType DWord -Value 1 -Force

# Turn off hibernate if device is not a laptop
# Отключить режим гибернации, если устройство не является ноутбуком
if ((Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType -ne 2)
{
	POWERCFG /HIBERNATE OFF
}

# Turn off location access for this device
# Отключить доступ к сведениям о расположении для этого устройства
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location -Name Value -PropertyType String -Value Deny -Force

# Change %TEMP% environment variable path to the %SystemDrive%\Temp
# Изменить путь переменной среды для %TEMP% на %SystemDrive%\Temp
# See pinned issues: https://github.com/farag2/Windows-10-Setup-Script/issues
$Title = ""
if ($RU)
{
	$Message = "Чтобы изменить путь переменной среды для %TEMP% на %SystemDrive%\Temp, введите необходимую букву"
	Write-Warning -Message "`nПеред выполнением закройте все работающие программы"
	$Options = "&Изменить", "&Пропустить"
}
else
{
	$Message = "To change %TEMP% environment variable path to the %SystemDrive%\Temp enter the required letter"
	Write-Warning -Message "`nClose all running programs before proceeding"
	$Options = "&Change", "&Skip"
}
$DefaultChoice = 1
$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

switch ($Result)
{
	"0"
	{
		if (-not (Test-Path -Path $env:SystemDrive\Temp))
		{
			New-Item -Path $env:SystemDrive\Temp -ItemType Directory -Force
		}

		[Environment]::SetEnvironmentVariable("TMP", "$env:SystemDrive\Temp", "User")
		[Environment]::SetEnvironmentVariable("TMP", "$env:SystemDrive\Temp", "Machine")
		[Environment]::SetEnvironmentVariable("TMP", "$env:SystemDrive\Temp", "Process")
		New-ItemProperty -Path HKCU:\Environment -Name TMP -PropertyType ExpandString -Value %SystemDrive%\Temp -Force

		[Environment]::SetEnvironmentVariable("TEMP", "$env:SystemDrive\Temp", "User")
		[Environment]::SetEnvironmentVariable("TEMP", "$env:SystemDrive\Temp", "Machine")
		[Environment]::SetEnvironmentVariable("TEMP", "$env:SystemDrive\Temp", "Process")
		New-ItemProperty -Path HKCU:\Environment -Name TEMP -PropertyType ExpandString -Value %SystemDrive%\Temp -Force

		New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name TMP -PropertyType ExpandString -Value %SystemDrive%\Temp -Force
		New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name TEMP -PropertyType ExpandString -Value %SystemDrive%\Temp -Force

		# Spooler restart
		# Перезапуск Диспетчер печати
		Restart-Service -Name Spooler -Force

		Stop-Process -Name OneDrive -Force -ErrorAction Ignore
		Stop-Process -Name FileCoAuth -Force -ErrorAction Ignore

		Remove-Item -Path $env:SystemRoot\Temp -Recurse -Force -ErrorAction Ignore
		Remove-Item -Path $env:LOCALAPPDATA\Temp -Recurse -Force -ErrorAction Ignore

		# Create a symbolic link to the %SystemDrive%\Temp folder
		# Создать символическую ссылку к папке %SystemDrive%\Temp
		New-Item -Path $env:LOCALAPPDATA\Temp -ItemType SymbolicLink -Value $env:SystemDrive\Temp -Force
	}
	"1"
	{
		if ($RU)
		{
			Write-Verbose -Message "Пропущено" -Verbose
		}
		else
		{
			Write-Verbose -Message "Skipped" -Verbose
		}
	}
}

# Turn on Win32 long paths
# Включить длинные пути Win32
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem -Name LongPathsEnabled -PropertyType DWord -Value 1 -Force

# Group svchost.exe processes
# Группировать процессы svchost.exe
$RAMCapacity = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1KB
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control -Name SvcHostSplitThresholdInKB -PropertyType DWord -Value $RAMCapacity -Force

# Display the Stop error information on the BSoD
# Отображать Stop-ошибку при появлении BSoD
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Control\CrashControl -Name DisplayParameters -PropertyType DWord -Value 1 -Force

# Do not preserve zone information in file attachments
# Не хранить сведения о зоне происхождения вложенных файлов
if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -Name SaveZoneInformation -PropertyType DWord -Value 1 -Force

# Turn off Admin Approval Mode for administrators
# Отключить использование режима одобрения администратором для встроенной учетной записи администратора
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -PropertyType DWord -Value 0 -Force

# Turn on access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled
# Включить доступ к сетевым дискам при включенном режиме одобрения администратором при доступе из программ, запущенных с повышенными правами
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLinkedConnections -PropertyType DWord -Value 1 -Force

# Turn off Delivery Optimization
# Отключить оптимизацию доставки
Get-Service -Name DoSvc | Stop-Service -Force
Set-DODownloadMode -DownloadMode 0
Delete-DeliveryOptimizationCache -Force

# Always wait for the network at computer startup and logon
# Всегда ждать сеть при запуске и входе в систему
if (-not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon"))
{
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name SyncForegroundPolicy -PropertyType DWord -Value 1 -Force

# Do not let Windows manage default printer
# Не разрешать Windows управлять принтером, используемым по умолчанию
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows" -Name LegacyDefaultPrinterMode -PropertyType DWord -Value 1 -Force

# Turn off Windows features
# Отключить компоненты Windows
$WindowsOptionalFeatures = @(
	# Legacy Components
	# Компоненты прежних версий
	"LegacyComponents"
	# Media Features
	# Компоненты работы с мультимедиа
	"MediaPlayback"
	# PowerShell 2.0
	"MicrosoftWindowsPowerShellV2"
	"MicrosoftWindowsPowershellV2Root"
	# Microsoft XPS Document Writer
	# Средство записи XPS-документов (Microsoft)
	"Printing-XPSServices-Features"
	# Microsoft Print to PDF
	# Печать в PDF (Майкрософт)
	"Printing-PrintToPDFServices-Features"
	# Work Folders Client
	# Клиент рабочих папок
	"WorkFolders-Client"
)
Disable-WindowsOptionalFeature -Online -FeatureName $WindowsOptionalFeatures -NoRestart

# Install the Windows Subsystem for Linux (WSL)
# Установить подсистему Windows для Linux (WSL)
# https://github.com/farag2/Windows-10-Setup-Script/issues/43
if ($RU)
{
	$Title = "Windows Subsystem for Linux"
	$Message = "Чтобы установить Windows Subsystem for Linux, введите необходимую букву"
	$Options = "&Установить", "&Пропустить"
}
else
{
	$Title = "Windows Subsystem for Linux"
	$Message = "To install the Windows Subsystem for Linux enter the required letter"
	$Options = "&Install", "&Skip"
}
$DefaultChoice = 1
$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

switch ($Result)
{
	"0"
	{
		# Enable the Windows Subsystem for Linux
		# Включить подсистему Windows для Linux
		Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
		# Enable Virtual Machine Platform
		# Включить поддержку платформы для виртуальных машин
		Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart

		# Downloading the Linux kernel update package
		# Скачиваем пакет обновления ядра Linux
		try
		{
			[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
			if ((Invoke-WebRequest -Uri https://www.google.com -UseBasicParsing -DisableKeepAlive -Method Head).StatusDescription)
			{
				$Parameters = @{
					Uri = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
					OutFile = "$PSScriptRoot\wsl_update_x64.msi"
					Verbose = [switch]::Present
				}
				Invoke-WebRequest @Parameters

				Start-Process -FilePath $PSScriptRoot\wsl_update_x64.msi -ArgumentList "/passive" -Wait
				Remove-Item -Path $PSScriptRoot\wsl_update_x64.msi -Force
			}
		}
		catch
		{
			if ($Error.Exception.Status -eq "NameResolutionFailure")
			{
				if ($RU)
				{
					Write-Warning -Message "Отсутствует интернет-соединение" -ErrorAction SilentlyContinue
				}
				else
				{
					Write-Warning -Message "No Internet connection" -ErrorAction SilentlyContinue
				}
			}
		}

		<#
		# Comment out only after installing the Windows Subsystem for Linux
		# Раскомментируйте только после установки подсистемы Windows для Linux

		# Set WSL 2 as your default version. Run the command only after restart
		# Установить WSL 2 как версию по умолчанию. Выполните команду только после перезагрузки
		wsl --set-default-version 2

		# Configuring .wslconfig
		# Настраиваем .wslconfig
		# https://github.com/microsoft/WSL/issues/5437
		if (-not (Test-Path -Path "$env:HOMEPATH\.wslconfig"))
		{
			$wslconfig = @"
[wsl2]
swap=0
"@
			# Saving .wslconfig in UTF-8 encoding
			# Сохраняем .wslconfig в кодировке UTF-8
			Set-Content -Path "$env:HOMEPATH\.wslconfig" -Value (New-Object System.Text.UTF8Encoding).GetBytes($wslconfig) -Encoding Byte -Force
		}
		else
		{
			$String = Get-Content -Path "$env:HOMEPATH\.wslconfig" | Select-String -Pattern "swap=" -SimpleMatch
			if ($String)
			{
				(Get-Content -Path "$env:HOMEPATH\.wslconfig").Replace("swap=1", "swap=0") | Set-Content -Path "$env:HOMEPATH\.wslconfig" -Force
			}
			else
			{
				Add-Content -Path "$env:HOMEPATH\.wslconfig" -Value "`r`nswap=0" -Force
			}
		}
		#>
	}
	"1"
	{
		if ($RU)
		{
			Write-Verbose -Message "Пропущено" -Verbose
		}
		else
		{
			Write-Verbose -Message "Skipped" -Verbose
		}
	}
}

# Remove Windows capabilities
# Удалить дополнительные компоненты Windows
Add-Type -AssemblyName PresentationCore, PresentationFramework

#region Variables
# Windows capabilities array list to remove
# Массив имен дополнительных компонентов Windows для удаления
$Capabilities = New-Object -TypeName System.Collections.ArrayList($null)

# Windows capabilities that will be checked to remove by default
# Дополнительные компоненты Windows, которые будут отмечены на удаление по умолчанию
$CheckedCapabilities = @(
	# Steps Recorder
	# Средство записи действий
	"App.StepsRecorder*"
	# Microsoft Quick Assist
	# Быстрая поддержка (Майкрософт)
	"App.Support.QuickAssist*"
	# Windows Media Player
	# Проигрыватель Windows Media
	"Media.WindowsMediaPlayer*"
	# Microsoft Paint
	"Microsoft.Windows.MSPaint*"
	# WordPad
	"Microsoft.Windows.WordPad*"
	# Integrated faxing and scanning application for Windows
	# Факсы и сканирование Windows
	"Print.Fax.Scan*"
)
# If device is not a laptop
# Если устройство не является ноутбуком
if ((Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType -ne 2)
{
	# Windows Hello Face
	# Распознавание лиц Windows Hello
	$CheckedCapabilities += "Hello.Face*"
}
# Windows capabilities that will be shown in the form
# Дополнительные компоненты Windows, которые будут выводиться в форме
$ExcludedCapabilities = @(
	# The DirectX Database to configure and optimize apps when multiple Graphics Adapters are present
	# База данных DirectX для настройки и оптимизации приложений при наличии нескольких графических адаптеров
	"DirectX\.Configuration\.Database"
	# Language components
	# Языковые компоненты
	"Language\."
	# Notepad
	# Блокнот
	"Microsoft.Windows.Notepad*"
	# Mail, contacts, and calendar sync component
	# Компонент синхронизации почты, контактов и календаря
	"OneCoreUAP\.OneSync"
	# Management of printers, printer drivers, and printer servers
	# Управление принтерами, драйверами принтеров и принт-серверами
	"Print\.Management\.Console"
	# Features critical to Windows functionality
	# Компоненты, критичные для работоспособности Windows
	"Windows\.Client\.ShellComponents"
)
#endregion Variables

#region XAML Markup
[xml]$XAML = '
<Window
	xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
	xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
	Name="Window"
	MinHeight="450" MinWidth="400"
	SizeToContent="Width" WindowStartupLocation="CenterScreen"
	TextOptions.TextFormattingMode="Display" SnapsToDevicePixels="True"
	FontFamily="Segoe UI" FontSize="12" ShowInTaskbar="False">
	<Window.Resources>
		<Style TargetType="StackPanel">
			<Setter Property="Orientation" Value="Horizontal"/>
		</Style>
		<Style TargetType="CheckBox">
			<Setter Property="Margin" Value="10, 10, 5, 10"/>
			<Setter Property="IsChecked" Value="True"/>
		</Style>
		<Style TargetType="TextBlock">
			<Setter Property="Margin" Value="5, 10, 10, 10"/>
		</Style>
		<Style TargetType="Button">
			<Setter Property="Margin" Value="20"/>
			<Setter Property="Padding" Value="10"/>
		</Style>
	</Window.Resources>
	<Grid>
		<Grid.RowDefinitions>
			<RowDefinition Height="*"/>
			<RowDefinition Height="Auto"/>
		</Grid.RowDefinitions>
		<ScrollViewer Name="Scroll" Grid.Row="0"
			HorizontalScrollBarVisibility="Disabled"
			VerticalScrollBarVisibility="Auto">
			<StackPanel Name="PanelContainer" Orientation="Vertical"/>
		</ScrollViewer>
		<Button Name="Button" Grid.Row="1"/>
	</Grid>
</Window>
'
#endregion XAML Markup

$Reader = (New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $XAML)
$Form = [Windows.Markup.XamlReader]::Load($Reader)
$XAML.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object -Process {
	Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name) -Scope Global
}

#region Functions
function Get-CheckboxClicked
{
	[CmdletBinding()]
	param
	(
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true
		)]
		[ValidateNotNull()]
		$CheckBox
	)

	$Capability = $CheckBox.Parent.Children[1].Text
	if ($CheckBox.IsChecked)
	{
		[void]$Capabilities.Add($Capability)
	}
	else
	{
		[void]$Capabilities.Remove($Capability)
	}
	if ($Capabilities.Count -gt 0)
	{
		$Button.IsEnabled = $true
	}
	else
	{
		$Button.IsEnabled = $false
	}
}

function DeleteButton
{
	[void]$Window.Close()
	$OFS = "|"
	Get-WindowsCapability -Online | Where-Object -FilterScript {$_.Name -cmatch $Capabilities} | Remove-WindowsCapability -Online
	$OFS = " "
}

function Add-CapabilityControl
{
	[CmdletBinding()]
	param
	(
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true
		)]
		[ValidateNotNull()]
		[string]
		$Capability
	)

	$CheckBox = New-Object -TypeName System.Windows.Controls.CheckBox
	$CheckBox.Add_Click({Get-CheckboxClicked -CheckBox $_.Source})

	$TextBlock = New-Object -TypeName System.Windows.Controls.TextBlock
	$TextBlock.Text = $Capability

	$StackPanel = New-Object -TypeName System.Windows.Controls.StackPanel
	[void]$StackPanel.Children.Add($CheckBox)
	[void]$StackPanel.Children.Add($TextBlock)

	[void]$PanelContainer.Children.Add($StackPanel)

	$CheckBox.IsChecked = $false

	if ($CheckedCapabilities | Where-Object -FilterScript {$Capability -like $_})
	{
		$CheckBox.IsChecked = $true
		# If capability checked, add to the array list to remove
		# Если пакет выделен, то добавить в массив для удаления
		[void]$Capabilities.Add($Capability)
	}
}
#endregion Functions

#region Events Handlers
# Window Loaded Event
$Window.Add_Loaded({
	$OFS = "|"
	(Get-WindowsCapability -Online | Where-Object -FilterScript {($_.State -eq "Installed") -and ($_.Name -cnotmatch $ExcludedCapabilities)}).Name | ForEach-Object -Process {
		Add-CapabilityControl -Capability $_
	}
	$OFS = " "

	if ($RU)
	{
		$Window.Title = "Удалить дополнительные компоненты"
		$Button.Content = "Удалить"
	}
	else
	{
		$Window.Title = "Capabilities to Uninstall"
		$Button.Content = "Uninstall"
	}
})

# Button Click Event
$Button.Add_Click({DeleteButton})
#endregion Events Handlers

if (Get-WindowsCapability -Online | Where-Object -FilterScript {($_.State -eq "Installed") -and ($_.Name -cnotmatch ($ExcludedCapabilities -join "|"))})
{
	if ($RU)
	{
		Write-Verbose -Message "Форма открывается..." -Verbose
	}
	else
	{
		Write-Verbose -Message "Form opening..." -Verbose
	}
	# Display form
	# Отобразить форму
	$Form.ShowDialog() | Out-Null
}
else
{
	if ($RU)
	{
		Write-Verbose -Message "No capabilities to display" -Verbose
	}
	else
	{
		Write-Verbose -Message "Отсутствуют дополнительные компоненты для отображения" -Verbose
	}
}

# Turn on updates for other Microsoft products
# Включить автоматическое обновление для других продуктов Microsoft
(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "")

# Turn off background apps, except the followings...
# Запретить приложениям работать в фоновом режиме, кроме следующих...
Get-ChildItem -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | ForEach-Object -Process {
	Remove-ItemProperty -Path $_.PsPath -Name * -Force
}
$ExcludedBackgroundApps = @(
	# Lock App
	"Microsoft.LockApp*"
	# Content Delivery Manager
	"Microsoft.Windows.ContentDeliveryManager*"
	# Cortana
	"Microsoft.Windows.Cortana*"
	# Windows Search
	"Microsoft.Windows.Search*"
	# Windows Security
	# Безопасность Windows
	"Microsoft.Windows.SecHealthUI*"
	# ShellExperienceHost
	"Microsoft.Windows.ShellExperienceHost*"
	# StartMenuExperienceHost
	"Microsoft.Windows.StartMenuExperienceHost*"
	# Microsoft Store
	"Microsoft.WindowsStore*"
)
$OFS = "|"
Get-ChildItem -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | Where-Object -FilterScript {$_.PSChildName -cnotmatch $ExcludedBackgroundApps} | ForEach-Object -Process {
	New-ItemProperty -Path $_.PsPath -Name Disabled -PropertyType DWord -Value 1 -Force
	New-ItemProperty -Path $_.PsPath -Name DisabledByUser -PropertyType DWord -Value 1 -Force
}
$OFS = " "
# Open "Background apps" page
# Открыть раздел "Фоновые приложения"
Start-Process -FilePath ms-settings:privacy-backgroundapps

# Set power management scheme
# Установить схему управления питания
if ((Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType -eq 2)
{
	# Balanced for laptop
	# Сбалансированная для ноутбука
	POWERCFG /SETACTIVE SCHEME_BALANCED
}
else
{
	# High performance for desktop
	# Высокая производительность для стационарного ПК
	POWERCFG /SETACTIVE SCHEME_MIN
}

# Use latest installed .NET runtime for all apps
# Использовать последнюю установленную версию .NET для всех приложений
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\.NETFramework -Name OnlyUseLatestCLR -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework -Name OnlyUseLatestCLR -PropertyType DWord -Value 1 -Force

# Do not allow the computer (if device is not a laptop) to turn off the network adapters to save power
# Запретить отключение сетевых адаптеров для экономии энергии (если устройство не является ноутбуком)
if ((Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType -ne 2)
{
	$adapters = Get-NetAdapter -Physical | Get-NetAdapterPowerManagement | Where-Object -FilterScript {$_.AllowComputerToTurnOffDevice -ne "Unsupported"}
	foreach ($adapter in $adapters)
	{
		$adapter.AllowComputerToTurnOffDevice = "Disabled"
		$adapter | Set-NetAdapterPowerManagement
	}
}

# Set the default input method to the English language
# Установить метод ввода по умолчанию на английский язык
# Set-WinDefaultInputMethodOverride "0409:00000409"

# Turn on Windows Sandbox
# Включить Windows Sandbox
#if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -eq "Professional" -or $_.Edition -like "Enterprise*"})
#{
#	# Checking whether a x86 virtualization is enabled in BIOS

#	# Проверка: включена ли в BIOS аппаратная виртуализация x86
#	if ((Get-CimInstance -ClassName CIM_Processor).VirtualizationFirmwareEnabled -eq $true)
#	{
#		Enable-WindowsOptionalFeature -FeatureName Containers-DisposableClientVM -All -Online -NoRestart
#	}
#	else
#	{
#		try
#		{
#			# Determining whether a Hyper-V is enabled
#			# Проверка: включен ли Hyper-V
#			if ((Get-CimInstance -ClassName CIM_ComputerSystem).HypervisorPresent -eq $true)
#			{
#				Enable-WindowsOptionalFeature -FeatureName Containers-DisposableClientVM -All -Online -NoRestart
#			}
#		}
#		catch [Exception]
#		{
#			if ($RU)
#			{
#				Write-Error -Message "Включите в BIOS виртуализацию" -ErrorAction SilentlyContinue
#			}
#			else
#			{
#				Write-Error -Message "Enable Virtualization in BIOS" -ErrorAction SilentlyContinue
#			}
#		}
#	}
#}

# Change location of the user folders
# Изменить расположение пользовательских папок

function UserShellFolder
{
<#
.SYNOPSIS
	Change location of the each user folders using SHSetKnownFolderPath function
.EXAMPLE
	UserShellFolder -UserFolder Desktop -FolderPath "C:\Desktop"
.NOTES
	User files or folders won't me moved to the new location
#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateSet("Desktop", "Documents", "Downloads", "Music", "Pictures", "Videos")]
		[string]
		$UserFolder,

		[Parameter(Mandatory = $true)]
		[string]
		$FolderPath
	)

	function KnownFolderPath
	{
	<#
	.SYNOPSIS
		Redirect user folders to a new location
	.EXAMPLE
		KnownFolderPath -KnownFolder Desktop -Path "C:\Desktop"
	.NOTES
		User files or folders won't me moved to the new location
	#>
		[CmdletBinding()]
		param
		(
			[Parameter(Mandatory = $true)]
			[ValidateSet("Desktop", "Documents", "Downloads", "Music", "Pictures", "Videos")]
			[string]
			$KnownFolder,

			[Parameter(Mandatory = $true)]
			[string]
			$Path
		)

		$KnownFolders = @{
			"Desktop"	= @("B4BFCC3A-DB2C-424C-B029-7FE99A87C641");
			"Documents"	= @("FDD39AD0-238F-46AF-ADB4-6C85480369C7", "f42ee2d3-909f-4907-8871-4c22fc0bf756");
			"Downloads"	= @("374DE290-123F-4565-9164-39C4925E467B", "7d83ee9b-2244-4e70-b1f5-5393042af1e4");
			"Music"		= @("4BD8D571-6D19-48D3-BE97-422220080E43", "a0c69a99-21c8-4671-8703-7934162fcf1d");
			"Pictures"	= @("33E28130-4E1E-4676-835A-98395C3BC3BB", "0ddd015d-b06c-45d5-8c4c-f59713854639");
			"Videos"	= @("18989B1D-99B5-455B-841C-AB7C74E4DDFC", "35286a68-3c57-41a1-bbb1-0eae73d76c95");
		}

		$Signature = @{
			Namespace = "WinAPI"
			Name = "KnownFolders"
			Language = "CSharp"
			MemberDefinition = @"
[DllImport("shell32.dll")]
public extern static int SHSetKnownFolderPath(ref Guid folderId, uint flags, IntPtr token, [MarshalAs(UnmanagedType.LPWStr)] string path);
"@
		}
		if (-not ("WinAPI.KnownFolders" -as [type]))
		{
			Add-Type @Signature
		}

		foreach ($guid in $KnownFolders[$KnownFolder])
		{
			[WinAPI.KnownFolders]::SHSetKnownFolderPath([ref]$guid, 0, 0, $Path)
		}
		(Get-Item -Path $Path -Force).Attributes = "ReadOnly"
	}

	$UserShellFoldersRegName = @{
		"Desktop"	=	"Desktop"
		"Documents"	=	"Personal"
		"Downloads"	=	"{374DE290-123F-4565-9164-39C4925E467B}"
		"Music"		=	"My Music"
		"Pictures"	=	"My Pictures"
		"Videos"	=	"My Video"
	}

	$UserShellFoldersGUID = @{
		"Desktop"	=	"{754AC886-DF64-4CBA-86B5-F7FBF4FBCEF5}"
		"Documents"	=	"{F42EE2D3-909F-4907-8871-4C22FC0BF756}"
		"Downloads"	=	"{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}"
		"Music"		=	"{A0C69A99-21C8-4671-8703-7934162FCF1D}"
		"Pictures"	=	"{0DDD015D-B06C-45D5-8C4C-F59713854639}"
		"Videos"	=	"{35286A68-3C57-41A1-BBB1-0EAE73D76C95}"
	}

	# Hidden desktop.ini for each type of user folders
	# Скрытый desktop.ini для каждого типа пользовательских папок
	$DesktopINI = @{
		"Desktop"	=	"",
						"[.ShellClassInfo]",
						"LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21769",
						"IconResource=%SystemRoot%\system32\imageres.dll,-183"
		"Documents"	=	"",
						"[.ShellClassInfo]",
						"LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21770",
						"IconResource=%SystemRoot%\system32\imageres.dll,-112",
						"IconFile=%SystemRoot%\system32\shell32.dll",
						"IconIndex=-235"
		"Downloads"	=	"",
						"[.ShellClassInfo]","LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21798",
						"IconResource=%SystemRoot%\system32\imageres.dll,-184"
		"Music"		=	"",
						"[.ShellClassInfo]","LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21790",
						"InfoTip=@%SystemRoot%\system32\shell32.dll,-12689",
						"IconResource=%SystemRoot%\system32\imageres.dll,-108",
						"IconFile=%SystemRoot%\system32\shell32.dll","IconIndex=-237"
		"Pictures"	=	"",
						"[.ShellClassInfo]",
						"LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21779",
						"InfoTip=@%SystemRoot%\system32\shell32.dll,-12688",
						"IconResource=%SystemRoot%\system32\imageres.dll,-113",
						"IconFile=%SystemRoot%\system32\shell32.dll",
						"IconIndex=-236"
		"Videos"	=	"",
						"[.ShellClassInfo]",
						"LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21791",
						"InfoTip=@%SystemRoot%\system32\shell32.dll,-12690",
						"IconResource=%SystemRoot%\system32\imageres.dll,-189",
						"IconFile=%SystemRoot%\system32\shell32.dll","IconIndex=-238"
	}

	# Determining the current user folder path
	# Определяем текущее значение пути пользовательской папки
	$UserShellFolderRegValue = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name $UserShellFoldersRegName[$UserFolder]
	if ($UserShellFolderRegValue -ne $FolderPath)
	{
		if ((Get-ChildItem -Path $UserShellFolderRegValue | Measure-Object).Count -ne 0)
		{
			if ($RU)
			{
				Write-Error -Message "В папке $UserShellFolderRegValue осталась файлы. Переместите их вручную в новое расположение" -ErrorAction SilentlyContinue
			}
			else
			{
				Write-Error -Message "Some files left in the $UserShellFolderRegValue folder. Move them manually to a new location" -ErrorAction SilentlyContinue
			}
		}

		# Creating a new folder if there is no one
		# Создаем новую папку, если таковая отсутствует
		if (-not (Test-Path -Path $FolderPath))
		{
			New-Item -Path $FolderPath -ItemType Directory -Force
		}

		KnownFolderPath -KnownFolder $UserFolder -Path $FolderPath
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name $UserShellFoldersGUID[$UserFolder] -PropertyType ExpandString -Value $FolderPath -Force

		Set-Content -Path "$FolderPath\desktop.ini" -Value $DesktopINI[$UserFolder] -Encoding Unicode -Force
		(Get-Item -Path "$FolderPath\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
		(Get-Item -Path "$FolderPath\desktop.ini" -Force).Refresh()
	}
}

<#
.SYNOPSIS
	The "Show menu" function using PowerShell with the up/down arrow keys and enter key to make a selection
.EXAMPLE
	ShowMenu -Menu $ListOfItems -Default $DefaultChoice
.NOTES
	Doesn't work in PowerShell ISE
#>
function ShowMenu
{
	[CmdletBinding()]
	param
	(
		[Parameter()]
		[string]
		$Title,

		[Parameter(Mandatory = $true)]
		[array]
		$Menu,

		[Parameter(Mandatory = $true)]
		[int]
		$Default
	)

	Write-Information -MessageData $Title -InformationAction Continue

	$minY = [Console]::CursorTop
	$y = [Math]::Max([Math]::Min($Default, $Menu.Count), 0)
	do
	{
		[Console]::CursorTop = $minY
		[Console]::CursorLeft = 0
		$i = 0
		foreach ($item in $Menu)
		{
			if ($i -ne $y)
			{
				Write-Information -MessageData ('  {0}. {1}  ' -f ($i+1), $item) -InformationAction Continue
			}
			else
			{
				Write-Information -MessageData ('[ {0}. {1} ]' -f ($i+1), $item) -InformationAction Continue
			}
			$i++
		}

		$k = [Console]::ReadKey()
		switch ($k.Key)
		{
			"UpArrow"
			{
				if ($y -gt 0)
				{
					$y--
				}
			}
			"DownArrow"
			{
				if ($y -lt ($Menu.Count - 1))
				{
					$y++
				}
			}
			"Enter"
			{
				return $Menu[$y]
			}
		}
	}
	while ($k.Key -notin ([ConsoleKey]::Escape, [ConsoleKey]::Enter))
}

# Store all drives letters to use them within ShowMenu function
# Сохранить все буквы диска, чтобы использовать их в функции ShowMenu
if ($RU)
{
	Write-Verbose "Получение дисков..." -Verbose
}
else
{
	Write-Verbose "Retrieving drives..." -Verbose
}
$DriveLetters = @((Get-Disk | Where-Object -FilterScript {$_.BusType -ne "USB"} | Get-Partition | Get-Volume | Where-Object -FilterScript {$null -ne $_.DriveLetter}).DriveLetter | Sort-Object)

if ($DriveLetters.Count -gt 1)
{
	# If the number of disks is more than one, set the second drive in the list as default drive
	# Если количество дисков больше одного, сделать второй диск в списке диском по умолчанию
	$Default = 1
}
else
{
	$Default = 0
}

# Desktop
# Рабочий стол
$Title = ""
if ($RU)
{
	$Message = "Чтобы изменить местоположение папки `"Рабочий стол`", введите необходимую букву"
	Write-Warning -Message "`nФайлы не будут перенесены"
	$Options = "&Изменить", "&Пропустить"
}
else
{
	$Message = "To change the location of the Desktop folder enter the required letter"
	Write-Warning -Message "`nFiles will not be moved"
	$Options = "&Change", "&Skip"
}
$DefaultChoice = 1
$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

switch ($Result)
{
	"0"
	{
		if ($RU)
		{
			$Title = "`nВыберите диск, в корне которого будет создана папка для `"Рабочий стол`""
		}
		else
		{
			$Title = "`nSelect the drive within the root of which the `"Desktop`" folder will be created"
		}
		$SelectedDrive = ShowMenu -Title $Title -Menu $DriveLetters -Default $Default
		UserShellFolder -UserFolder Desktop -FolderPath "${SelectedDrive}:\Desktop"
	}
	"1"
	{
		if ($RU)
		{
			Write-Verbose -Message "Пропущено" -Verbose
		}
		else
		{
			Write-Verbose -Message "Skipped" -Verbose
		}
	}
}

# Documents
# Документы
$Title = ""
if ($RU)
{
	$Message = "Чтобы изменить местоположение папки `"Документы`", введите необходимую букву"
	Write-Warning -Message "`nФайлы не будут перенесены"
	$Options = "&Изменить", "&Пропустить"
}
else
{
	$Message = "To change the location of the Documents folder enter the required letter"
	Write-Warning -Message "`nFiles will not be moved"
	$Options = "&Change", "&Skip"
}
$DefaultChoice = 1
$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

switch ($Result)
{
	"0"
	{
		if ($RU)
		{
			$Title = "`nВыберите диск, в корне которого будет создана папка для `"Документы`""
		}
		else
		{
			$Title = "`nSelect the drive within the root of which the `"Documents`" folder will be created"
		}
		$SelectedDrive = ShowMenu -Title $Title -Menu $DriveLetters -Default $Default
		UserShellFolder -UserFolder Documents -FolderPath "${SelectedDrive}:\Documents"
	}
	"1"
	{
		if ($RU)
		{
			Write-Verbose -Message "Пропущено" -Verbose
		}
		else
		{
			Write-Verbose -Message "Skipped" -Verbose
		}
	}
}

# Downloads
# Загрузки
$Title = ""
if ($RU)
{
	$Message = "Чтобы изменить местоположение папки `"Загрузки`", введите необходимую букву"
	Write-Warning -Message "`nФайлы не будут перенесены"
	$Options = "&Изменить", "&Пропустить"
}
else
{
	$Message = "To change the location of the Downloads folder enter the required letter"
	Write-Warning -Message "`nFiles will not be moved"
	$Options = "&Change", "&Skip"
}
$DefaultChoice = 1
$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

switch ($Result)
{
	"0"
	{
		if ($RU)
		{
			$Title = "`nВыберите диск, в корне которого будет создана папка для `"Загрузки`""
		}
		else
		{
			$Title = "`nSelect the drive within the root of which the `"Downloads`" folder will be created"
		}
		$SelectedDrive = ShowMenu -Title $Title -Menu $DriveLetters -Default $Default
		UserShellFolder -UserFolder Downloads -FolderPath "${SelectedDrive}:\Downloads"
	}
	"1"
	{
		if ($RU)
		{
			Write-Verbose -Message "Пропущено" -Verbose
		}
		else
		{
			Write-Verbose -Message "Skipped" -Verbose
		}
	}
}

# Music
# Музыка
$Title = ""
if ($RU)
{
	$Message = "Чтобы изменить местоположение папки `"Музыка`", введите необходимую букву"
	Write-Warning -Message "`nФайлы не будут перенесены"
	$Options = "&Изменить", "&Пропустить"
}
else
{
	$Message = "To change the location of the Music folder enter the required letter"
	Write-Warning -Message "`nFiles will not be moved"
	$Options = "&Change", "&Skip"
}
$DefaultChoice = 1
$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

switch ($Result)
{
	"0"
	{
		if ($RU)
		{
			$Title = "`nВыберите диск, в корне которого будет создана папка для `"Музыка`""
		}
		else
		{
			$Title = "`nSelect the drive within the root of which the `"Music`" folder will be created"
		}
		$SelectedDrive = ShowMenu -Title $Title -Menu $DriveLetters -Default $Default
		UserShellFolder -UserFolder Music -FolderPath "${SelectedDrive}:\Music"
	}
	"1"
	{
		if ($RU)
		{
			Write-Verbose -Message "Пропущено" -Verbose
		}
		else
		{
			Write-Verbose -Message "Skipped" -Verbose
		}
	}
}


# Pictures
# Изображения
$Title = ""
if ($RU)
{
	$Message = "Чтобы изменить местоположение папки `"Изображения`", введите необходимую букву"
	Write-Warning -Message "`nФайлы не будут перенесены"
	$Options = "&Изменить", "&Пропустить"
}
else
{
	$Message = "To change the location of the Pictures folder enter the required letter"
	Write-Warning -Message "`nFiles will not be moved"
	$Options = "&Change", "&Skip"
}
$DefaultChoice = 1
$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

switch ($Result)
{
	"0"
	{
		if ($RU)
		{
			$Title = "`nВыберите диск, в корне которого будет создана папка для `"Изображения`""
		}
		else
		{
			$Title = "`nSelect the drive within the root of which the `"Pictures`" folder will be created"
		}
		$SelectedDrive = ShowMenu -Title $Title -Menu $DriveLetters -Default $Default
		UserShellFolder -UserFolder Pictures -FolderPath "${SelectedDrive}:\Pictures"
	}
	"1"
	{
		if ($RU)
		{
			Write-Verbose -Message "Пропущено" -Verbose
		}
		else
		{
			Write-Verbose -Message "Skipped" -Verbose
		}
	}
}

# Videos
# Видео
$Title = ""
if ($RU)
{
	$Message = "Чтобы изменить местоположение папки `"Видео`", введите необходимую букву"
	Write-Warning -Message "`nФайлы не будут перенесены"
	$Options = "&Изменить", "&Пропустить"
}
else
{
	$Message = "To change the location of the Videos folder enter the required letter"
	Write-Warning -Message "`nFiles will not be moved"
	$Options = "&Change", "&Skip"
}
$DefaultChoice = 1
$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

switch ($Result)
{
	"0"
	{
		if ($RU)
		{
			$Title = "`nВыберите диск, в корне которого будет создана папка для `"Видео`""
		}
		else
		{
			$Title = "`nSelect the drive within the root of which the `"Videos`" folder will be created"
		}
		$SelectedDrive = ShowMenu -Title $Title -Menu $DriveLetters -Default $Default
		UserShellFolder -UserFolder Videos -FolderPath "${SelectedDrive}:\Videos"
	}
	"1"
	{
		if ($RU)
		{
			Write-Verbose -Message "Пропущено" -Verbose
		}
		else
		{
			Write-Verbose -Message "Skipped" -Verbose
		}
	}
}

# Save screenshots by pressing Win+PrtScr to the Desktop
# Сохранять скриншоты по нажатию Win+PrtScr на рабочем столе
$DesktopFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Desktop
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{B7BEDE81-DF94-4682-A7D8-57A52620B86F}" -Type ExpandString -Value $DesktopFolder -Force
# Save all opened folders in order to restore them after File Explorer restart
# Сохранить все открытые папки, чтобы восстановить их после перезапуска проводника
Clear-Variable -Name OpenedFolders -Force -ErrorAction Ignore
$OpenedFolders = {(New-Object -ComObject Shell.Application).Windows() | ForEach-Object -Process {$_.Document.Folder.Self.Path}}.Invoke()
# In order for the changes to take effect the File Explorer process has to be restarted
# Чтобы изменения вступили в силу, необходимо перезапустить процесс проводника
Stop-Process -Name explorer -Force
# Restore closed folders
# Восстановить закрытые папки
foreach ($OpenedFolder in $OpenedFolders)
{
	if (Test-Path -Path $OpenedFolder)
	{
		Invoke-Item -Path $OpenedFolder
	}
}

# Run troubleshooters automatically, then notify
# Автоматически запускать средства устранения неполадок, а затем уведомлять
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 3 -Force
if (-not (Test-Path -Path HKLM:\SOFTWARE\Microsoft\WindowsMitigation))
{
	New-Item -Path HKLM:\SOFTWARE\Microsoft\WindowsMitigation -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsMitigation -Name UserPreference -PropertyType DWord -Value 3 -Force

# Launch folder in a separate process
# Запускать окна с папками в отдельном процессе
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SeparateProcess -PropertyType DWord -Value 1 -Force

# Turn off and delete reserved storage after the next update installation
# Отключить и удалить зарезервированное хранилище после следующей установки обновлений
Set-WindowsReservedStorageState -State Disabled

# Turn on automatic backup the system registry to the %SystemRoot%\System32\config\RegBack folder
# Включить автоматическое создание копии реестра в папку %SystemRoot%\System32\config\RegBack
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager" -Name EnablePeriodicBackup -PropertyType DWord -Value 1 -Force

# Turn off Help page opening by F1 key
# Отключить открытие справки по нажатию F1
if (-not (Test-Path -Path "HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64"))
{
	New-Item -Path "HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64" -Force
}
New-ItemProperty -Path "HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64" -Name "(Default)" -PropertyType String -Value "" -Force

# Turn on Num Lock at startup
# Включить Num Lock при загрузке
New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483650 -Force

# Turn off sticky Shift key after pressing 5 times
# Отключить залипание клавиши Shift после 5 нажатий
New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name Flags -PropertyType String -Value 506 -Force

# Turn off AutoPlay for all media and devices
# Отключить автозапуск для всех носителей и устройств
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers -Name DisableAutoplay -PropertyType DWord -Value 1 -Force

# Turn off thumbnail cache removal
# Отключить удаление кэша миниатюр
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" -Name Autorun -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" -Name Autorun -PropertyType DWord -Value 0 -Force

# Turn on automatically save my restartable apps when sign out and restart them after sign in
# Автоматически сохранять мои перезапускаемые приложения при выходе из системы и перезапустить их после выхода
New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name RestartApps -Value 1 -Force

# Turn on network discovery and file and printers sharing if device is not domain-joined
# Включить сетевое обнаружение и общий доступ к файлам и принтерам, если устройство не присоединенно к домену
if ((Get-CimInstance -ClassName CIM_ComputerSystem).PartOfDomain -eq $false)
{
	Get-NetFirewallRule -Group "@FirewallAPI.dll,-32752", "@FirewallAPI.dll,-28502" | Set-NetFirewallRule -Profile Private -Enabled True
	Set-NetConnectionProfile -NetworkCategory Private
}

# Automatically adjust active hours for me based on daily usage
# Автоматически изменять период активности для этого устройства на основе действий
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name SmartActiveHoursState -PropertyType DWord -Value 1 -Force
#endregion System

#region Start menu
# Do not show recently added apps in Start menu
# Не показывать недавно добавленные приложения в меню "Пуск"
if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name HideRecentlyAddedApps -PropertyType DWord -Value 1 -Force

# Do not show app suggestions in Start menu
# Не показывать рекомендации в меню "Пуск"
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338388Enabled -PropertyType DWord -Value 0 -Force

# Run the Command Prompt shortcut from the Start menu as Administrator
# Запускать ярлык командной строки в меню "Пуск" от имени Администратора
[byte[]]$bytes = Get-Content -Path "$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\Command Prompt.lnk" -Encoding Byte -Raw
$bytes[0x15] = $bytes[0x15] -bor 0x20
Set-Content -Path "$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\Command Prompt.lnk" -Value $bytes -Encoding Byte -Force

# Show the "File Explorer" and "Settings" folders on Start
# Отобразить папки "Проводник" и "Параметры" в меню "Пуск"
# https://github.com/Disassembler0/Win10-Initial-Setup-Script/issues/199
$Folders = @("File Explorer", "Settings")
$StartMenu = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*windows.data.unifiedtile.startglobalproperties\Current"
$Data = $StartMenu.Data[0..19] -join ","
$Data += ",203,50,10,$($Folders.Length)"

# File Explorer
# Проводник
$Data += ",5,188,201,168,164,1,36,140,172,3,68,137,133,1,102,160,129,186,203,189,215,168,164,130,1,0"
# Settings
# Параметры
$Data += ",5,134,145,204,147,5,36,170,163,1,68,195,132,1,102,159,247,157,177,135,203,209,172,212,1,0"
$Data += ",194,60,1,194,70,1,197,90,1,0"
New-ItemProperty -Path $StartMenu.PSPath -Name Data -PropertyType Binary -Value $Data.Split(",") -Force

# Restart the Start menu
# Перезапустить меню "Пуск"
Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction Ignore

# Unpin all the Start tiles
# Открепить все ярлыки от начального экрана
if ($RU)
{
	$Title = "Ярлыки начального экрана"
	$Message = "Чтобы открепить все ярлыки от начального экрана, введите необходимую букву"
	$Options = "&Открепить", "&Пропустить"
}
else
{
	$Title = "Start menu tiles"
	$Message = "To unpin all the Start menu tiles enter the required letter"
	$Options = "&Unpin", "&Skip"
}
$DefaultChoice = 1
$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

switch ($Result)
{
	"0"
	{
		$StartMenuLayout = @"
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
<LayoutOptions StartTileGroupCellWidth="6" />
	<DefaultLayoutOverride>
		<StartLayoutCollection>
			<defaultlayout:StartLayout GroupCellWidth="6" />
		</StartLayoutCollection>
	</DefaultLayoutOverride>
</LayoutModificationTemplate>
"@
		$StartMenuLayoutPath = "$env:TEMP\StartMenuLayout.xml"
		# Saving StartMenuLayout.xml in UTF-8 encoding
		# Сохраняем StartMenuLayout.xml в кодировке UTF-8
		Set-Content -Path $StartMenuLayoutPath -Value (New-Object System.Text.UTF8Encoding).GetBytes($StartMenuLayout) -Encoding Byte -Force

		# Temporarily disable changing Start layout
		# Временно выключаем возможность редактировать начальный экран
		if (-not (Test-Path -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer))
		{
			New-Item -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
		}
		New-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name LockedStartLayout -Value 1 -Force
		New-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name StartLayoutFile -Value $StartMenuLayoutPath -Force

		# Restart the Start menu
		# Перезапустить меню "Пуск"
		Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction Ignore
		Start-Sleep -Seconds 3

		Remove-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name LockedStartLayout -Force
		Remove-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name StartLayoutFile -Force

		Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction Ignore
		Remove-Item -LiteralPath $StartMenuLayoutPath -Force
	}
	"1"
	{
		if ($RU)
		{
			Write-Verbose -Message "Пропущено" -Verbose
		}
		else
		{
			Write-Verbose -Message "Skipped" -Verbose
		}
	}
}

# Pin the shortcuts to Start
# Закрепить ярлыки на начальном экране
if (Test-Path -Path $PSScriptRoot\syspin.exe)
{
	$syspin = $true
}
else
{
	try
	{
		# Downloading syspin.exe
		# Скачиваем syspin.exe
		# http://www.technosys.net/products/utils/pintotaskbar
		# SHA256: 6967E7A3C2251812DD6B3FA0265FB7B61AADC568F562A98C50C345908C6E827
		[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
		if ((Invoke-WebRequest -Uri https://www.google.com -UseBasicParsing -DisableKeepAlive -Method Head).StatusDescription)
		{
			$Parameters = @{
				Uri = "https://github.com/farag2/Windows-10-Setup-Script/raw/master/Start%20menu%20pinning/syspin.exe"
				OutFile = "$PSScriptRoot\syspin.exe"
				Verbose = [switch]::Present
			}
			Invoke-WebRequest @Parameters
			$syspin = $true
		}
	}
	catch
	{
		if ($Error.Exception.Status -eq "NameResolutionFailure")
		{
			if ($RU)
			{
				Write-Warning -Message "Отсутствует интернет-соединение" -ErrorAction SilentlyContinue
			}
			else
			{
				Write-Warning -Message "No Internet connection" -ErrorAction SilentlyContinue
			}
		}
	}
}

if ($syspin -eq $true)
{
	# Pin "Control Panel" to Start
	# Закрепить "Панель управления" на начальном экране
	$Items = (New-Object -ComObject Shell.Application).NameSpace("shell:::{4234d49b-0245-4df3-b780-3893943456e1}").Items()
	$ControlPanelLocalizedName = ($Items | Where-Object -FilterScript {$_.Path -eq "Microsoft.Windows.ControlPanel"}).Name
	if ($RU)
	{
		Write-Verbose -Message "Ярлык `"$ControlPanelLocalizedName`" закрепляется на начальном экране" -Verbose
	}
	else
	{
		Write-Verbose -Message "`"$ControlPanelLocalizedName`" shortcut is being pinned to Start" -Verbose
	}
	# Check whether the Control Panel shortcut was ever pinned
	# Проверка: закреплялся ли когда-нибудь ярлык панели управления
	if (Test-Path -Path "$env:APPDATA\Microsoft\Windows\Start menu\Programs\$ControlPanelLocalizedName.lnk")
	{
		$Arguments = @"
"$env:APPDATA\Microsoft\Windows\Start menu\Programs\$ControlPanelLocalizedName.lnk" "51201"
"@
		Start-Process -FilePath $PSScriptRoot\syspin.exe -WindowStyle Hidden -ArgumentList $Arguments -Wait
	}
	else
	{
		# The "Pin" verb is not available on the control.exe file so the shortcut has to be created
		# Глагол "Закрепить на начальном экране" недоступен для control.exe, поэтому необходимо создать ярлык
		$Shell = New-Object -ComObject Wscript.Shell
		$Shortcut = $Shell.CreateShortcut("$env:SystemRoot\System32\$ControlPanelLocalizedName.lnk")
		$Shortcut.TargetPath = "$env:SystemRoot\System32\control.exe"
		$Shortcut.Save()

		$Arguments = @"
"$env:SystemRoot\System32\$ControlPanelLocalizedName.lnk" "51201"
"@
		Start-Process -FilePath $PSScriptRoot\syspin.exe -WindowStyle Hidden -ArgumentList $Arguments -Wait
		Remove-Item -Path "$env:SystemRoot\System32\$ControlPanelLocalizedName.lnk" -Force
	}

	# Pin "Devices and Printers" to Start
	# Create old style shortcut for the "Devices and Printers" in the Start menu
	# Закрепить "Устройства и принтеры" на начальном экране
	# Создать ярлык старого формата для "Устройства и принтеры" в меню "Пуск"
	$DevicesAndPrintersLocalizedName = (Get-ControlPanelItem -CanonicalName "Microsoft.DevicesAndPrinters").Name
	if ($RU)
	{
		Write-Verbose -Message "Ярлык `"$DevicesAndPrintersLocalizedName`" закрепляется на начальном экране" -Verbose
	}
	else
	{
		Write-Verbose -Message "`"$DevicesAndPrintersLocalizedName`" shortcut is being pinned to Start" -Verbose
	}
	$Shell = New-Object -ComObject Wscript.Shell
	$Shortcut = $Shell.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\$DevicesAndPrintersLocalizedName.lnk")
	$Shortcut.TargetPath = "control"
	$Shortcut.Arguments = "printers"
	$Shortcut.IconLocation = "$env:SystemRoot\system32\DeviceCenter.dll"
	$Shortcut.Save()

	# Pause for 3 sec, unless the "Devices and Printers" shortcut won't displayed in the Start menu
	# Пауза на 3 с, иначе ярлык "Устройства и принтеры" не будет отображаться в меню "Пуск"
	Start-Sleep -Seconds 3
	$Arguments = @"
"$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\$DevicesAndPrintersLocalizedName.lnk" "51201"
"@
	Start-Process -FilePath $PSScriptRoot\syspin.exe -WindowStyle Hidden -ArgumentList $Arguments -Wait

	# Pin "Command Prompt" to Start
	# Закрепить "Командную строку" на начальном экране
	if ($RU)
	{
		Write-Verbose -Message "Ярлык `"Командная строка`" закрепляется на начальном экране" -Verbose
	}
	else
	{
		Write-Verbose -Message "`"Command Prompt`" shortcut is being pinned to Start" -Verbose
	}
	$Arguments = @"
"$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\Command Prompt.lnk" "51201"
"@
	Start-Process -FilePath $PSScriptRoot\syspin.exe -WindowStyle Hidden -ArgumentList $Arguments -Wait

	# Restart the Start menu
	# Перезапустить меню "Пуск"
	Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction Ignore
}
#endregion Start menu

#region UWP apps
<#
Uninstall UWP apps
A form with the ability to select the package to remove
App packages will not be installed when new user accounts are created, if "Uninstall for All Users" checked
Add UWP apps packages names to the $UncheckedAppXPackages array list by retrieving their packages names within (Get-AppxPackage -PackageTypeFilter Bundle -AllUsers).Name command

Удалить UWP-приложения
Форма с возможностью выбрать пакет для удаления
Приложения не будут установлены при создании новых учетных записей, если отмечено "Удалять для всех пользователей"
Добавьте имена пакетов UWP-приложений в массив $UncheckedAppXPackages, получив названия их пакетов с помощью команды (Get-AppxPackage -PackageTypeFilter Bundle -AllUsers).Name
#>
Add-Type -AssemblyName PresentationCore, PresentationFramework

#region Variables
# UWP-apps array list to remove
# Массив имен UWP-приложений для удаления
$AppxPackages = New-Object -TypeName System.Collections.ArrayList($null)

# UWP-apps that won't be checked to remove by default
# UWP-приложения, которые не будут отмечены на удаление по умолчанию
$UncheckedAppxPackages = @(
	# AMD Radeon UWP panel
	# UWP-панель AMD Radeon
	"AdvancedMicroDevicesInc*"
	# iTunes
	"AppleInc.iTunes"
	# Intel UWP panel
	# UWP-панель Intel
	"AppUp.IntelGraphicsControlPanel"
	"AppUp.IntelGraphicsExperience"
	# Sticky Notes
	# Записки
	"Microsoft.MicrosoftStickyNotes"
	# Screen Sketch
	# Набросок на фрагменте экрана
	"Microsoft.ScreenSketch"
	# Photos and Video Editor
	# Фотографии и Видеоредактор
	"Microsoft.Windows.Photos"
	"Microsoft.Photos.MediaEngineDLC"
	# Calculator
	# Калькулятор
	"Microsoft.WindowsCalculator"
	# Xbox Identity Provider
	# Поставщик удостоверений Xbox
	"Microsoft.XboxIdentityProvider"
	# Xbox
	# Компаньон консоли Xbox
	"Microsoft.XboxApp"
	# Xbox TCUI
	"Microsoft.Xbox.TCUI"
	# Xbox Speech To Text Overlay
	"Microsoft.XboxSpeechToTextOverlay"
	# Xbox Game Bar
	"Microsoft.XboxGamingOverlay"
	# Xbox Game Bar Plugin
	"Microsoft.XboxGameOverlay"
	# NVIDIA Control Panel
	# Панель управления NVidia
	"NVIDIACorp.NVIDIAControlPanel"
	# Realtek Audio Console
	"RealtekSemiconductorCorp.RealtekAudioControl"
)

# UWP-apps that won't be shown in the form
# UWP-приложения, которые не будут выводиться в форме
$ExcludedAppxPackages = @(
	# Microsoft Desktop App Installer
	"Microsoft.DesktopAppInstaller"
	# Microsoft Store
	"Microsoft.StorePurchaseApp"
	"Microsoft.WindowsStore"
	# Web Media Extensions
	# Расширения для интернет-мультимедиа
	"Microsoft.WebMediaExtensions"
)
#endregion Variables

#region XAML Markup
[xml]$XAML = '
<Window
	xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
	xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
	Name="Window"
	MinHeight="450" MinWidth="400"
	SizeToContent="Width" WindowStartupLocation="CenterScreen"
	TextOptions.TextFormattingMode="Display" SnapsToDevicePixels="True"
	FontFamily="Segoe UI" FontSize="12" ShowInTaskbar="False">
	<Window.Resources>
		<Style TargetType="StackPanel">
			<Setter Property="Orientation" Value="Horizontal"/>
		</Style>
		<Style TargetType="CheckBox">
			<Setter Property="Margin" Value="10, 10, 5, 10"/>
			<Setter Property="IsChecked" Value="True"/>
		</Style>
		<Style TargetType="TextBlock">
			<Setter Property="Margin" Value="5, 10, 10, 10"/>
		</Style>
		<Style TargetType="Button">
			<Setter Property="Margin" Value="20"/>
			<Setter Property="Padding" Value="10"/>
		</Style>
	</Window.Resources>
	<Grid>
		<Grid.RowDefinitions>
			<RowDefinition Height="Auto"/>
			<RowDefinition Height="*"/>
			<RowDefinition Height="Auto"/>
		</Grid.RowDefinitions>
		<Grid Grid.Row="0">
			<Grid.ColumnDefinitions>
				<ColumnDefinition Width="*"/>
				<ColumnDefinition Width="Auto"/>
			</Grid.ColumnDefinitions>
			<StackPanel Grid.Column="1" Orientation="Horizontal">
				<CheckBox Name="CheckboxRemoveAll" IsChecked="False"/>
				<TextBlock Name="TextblockRemoveAll"/>
			</StackPanel>
		</Grid>
		<ScrollViewer Name="Scroll" Grid.Row="1"
			HorizontalScrollBarVisibility="Disabled"
			VerticalScrollBarVisibility="Auto">
			<StackPanel Name="PanelContainer" Orientation="Vertical"/>
		</ScrollViewer>
		<Button Name="Button" Grid.Row="2"/>
	</Grid>
</Window>
'
#endregion XAML Markup

$Reader = (New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $XAML)
$Form = [Windows.Markup.XamlReader]::Load($Reader)
$XAML.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object -Process {
	Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name) -Scope Global
}

#region Functions
function Get-CheckboxClicked
{
	[CmdletBinding()]
	param
	(
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true
		)]
		[ValidateNotNull()]
		$CheckBox
	)

	$AppxName = $CheckBox.Parent.Children[1].Text
	if ($CheckBox.IsChecked)
	{
		[void]$AppxPackages.Add($AppxName)
	}
	else
	{
		[void]$AppxPackages.Remove($AppxName)
	}
	if ($AppxPackages.Count -gt 0)
	{
		$Button.IsEnabled = $true
	}
	else
	{
		$Button.IsEnabled = $false
	}
}

function DeleteButton
{
	[void]$Window.Close()
	$OFS = "|"
	if ($CheckboxRemoveAll.IsChecked)
	{
		Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object -FilterScript {$_.Name -cmatch $AppxPackages} | Remove-AppxPackage -AllUsers -Verbose
	}
	else
	{
		Get-AppxPackage -PackageTypeFilter Bundle | Where-Object -FilterScript {$_.Name -cmatch $AppxPackages} | Remove-AppxPackage -Verbose
	}
	$OFS = " "
}

function Add-AppxControl
{
	[CmdletBinding()]
	param
	(
		[Parameter(
			Mandatory = $true,
			ValueFromPipeline = $true
		)]
		[ValidateNotNull()]
		[string]
		$AppxName
	)

	$CheckBox = New-Object -TypeName System.Windows.Controls.CheckBox
	$CheckBox.Add_Click({Get-CheckboxClicked -CheckBox $_.Source})

	$TextBlock = New-Object -TypeName System.Windows.Controls.TextBlock
	$TextBlock.Text = $AppxName

	$StackPanel = New-Object -TypeName System.Windows.Controls.StackPanel
	[void]$StackPanel.Children.Add($CheckBox)
	[void]$StackPanel.Children.Add($TextBlock)

	[void]$PanelContainer.Children.Add($StackPanel)

	if ($UncheckedAppxPackages.Contains($AppxName))
	{
		$CheckBox.IsChecked = $false
		# Exit function, item is not checked
		# Выход из функции, если элемент не выделен
		return
	}

	# If package checked, add to the array list to uninstall
	# Если пакет выделен, то добавить в массив для удаления
	[void]$AppxPackages.Add($AppxName)
}
#endregion Functions

#region Events Handlers
# Window Loaded Event
$Window.Add_Loaded({
	$OFS = "|"
	(Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object -FilterScript {$_.Name -cnotmatch $ExcludedAppxPackages}).Name | ForEach-Object -Process {
		Add-AppxControl -AppxName $_
	}
	$OFS = " "

	if ($RU)
	{
		$TextblockRemoveAll.Text = "Удалять для всех пользователей"
		$Window.Title = "Удалить UWP-приложения"
		$Button.Content = "Удалить"
	}
	else
	{
		$TextblockRemoveAll.Text = "Uninstall for All Users"
		$Window.Title = "UWP Packages to Uninstall"
		$Button.Content = "Uninstall"
	}
})

# Button Click Event
$Button.Add_Click({DeleteButton})
#endregion Events Handlers

if (Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object -FilterScript {$_.Name -cnotmatch ($ExcludedAppxPackages -join "|")})
{
	if ($RU)
	{
		Write-Verbose -Message "Форма открывается..." -Verbose
	}
	else
	{
		Write-Verbose -Message "Form opening..." -Verbose
	}
	# Display form
	# Отобразить форму
	$Form.ShowDialog() | Out-Null
}
else
{
	if ($RU)
	{
		Write-Verbose -Message "No UWP apps to display" -Verbose
	}
	else
	{
		Write-Verbose -Message "Отсутствуют UWP-приложения для отображения" -Verbose
	}
}

<#
Open Microsoft Store "HEVC Video Extensions from Device Manufacturer" page
The extension can be installed without Microsoft account
"Movies & TV" app required

Открыть страницу "Расширения для видео HEVC от производителя устройства" в Microsoft Store
Расширение может быть установлено без учетной записи Microsoft
Для работы необходимо приложение "Кино и ТВ"
#>
if (Get-AppxPackage -Name Microsoft.ZuneVideo)
{
	Start-Process -FilePath ms-windows-store://pdp/?ProductId=9n4wgh0z6vhq
}

# Turn off Cortana autostarting
# Удалить Кортана из автозагрузки
if (Get-AppxPackage -Name Microsoft.549981C3F5F10)
{
	if (-not (Test-Path -Path "Registry::HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\Microsoft.549981C3F5F10_8wekyb3d8bbwe\CortanaStartupId"))
	{
		New-Item -Path "Registry::HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\Microsoft.549981C3F5F10_8wekyb3d8bbwe\CortanaStartupId" -Force
	}
	New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\Microsoft.549981C3F5F10_8wekyb3d8bbwe\CortanaStartupId" -Name State -PropertyType DWord -Value 1 -Force
}

# Check for UWP apps updates
# Проверить обновления UWP-приложений
Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod
#endregion UWP apps

#region Gaming
# Turn off Xbox Game Bar
# Отключить Xbox Game Bar
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR -Name AppCaptureEnabled -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKCU:\System\GameConfigStore -Name GameDVR_Enabled -PropertyType DWord -Value 0 -Force

# Turn off Xbox Game Bar tips
# Отключить советы Xbox Game Bar
New-ItemProperty -Path HKCU:\Software\Microsoft\GameBar -Name ShowStartupPanel -PropertyType DWord -Value 0 -Force

# Set "High performance" in graphics performance preference for apps
# Установить параметры производительности графики для отдельных приложений на "Высокая производительность"
if (Get-CimInstance -ClassName Win32_VideoController | Where-Object -FilterScript {$_.AdapterDACType -ne "Internal" -and $null -ne $_.AdapterDACType})
{
	if ($RU)
	{
		$Title = "Настройка производительности графики"
		$Message = "Чтобы добавить приложение, для которого будет установлена настройка производительности графики на `"Высокая производительность`", введите необходимую букву"
		$Options = "&Создать", "&Пропустить"
	}
	else
	{
		$Title = "Graphics performance preference"
		$Message = "To add an app for which the graphics performance preference will be set to `"High performance`" enter the required letter"
		$Options = "&Add", "&Skip"
	}
	$DefaultChoice = 1

	do
	{
		$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		switch ($Result)
		{
			"0"
			{
				Add-Type -AssemblyName System.Windows.Forms
				$OpenFileDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
				if ($RU)
				{
					$OpenFileDialog.Filter = "*.exe|*.exe|Все файлы (*.*)|*.*"
				}
				else
				{
					$OpenFileDialog.Filter = "*.exe|*.exe|All Files (*.*)|*.*"
				}
				$OpenFileDialog.InitialDirectory = "${env:ProgramFiles(x86)}"
				$OpenFileDialog.Multiselect = $false
				# Focus on open file dialog
				# Перевести фокус на диалог открытия файла
				$tmp = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
				$OpenFileDialog.ShowDialog($tmp)
				if ($OpenFileDialog.FileName)
				{
					if (-not (Test-Path -Path HKCU:\Software\Microsoft\DirectX\UserGpuPreferences))
					{
						New-Item -Path HKCU:\Software\Microsoft\DirectX\UserGpuPreferences -Force
					}
					New-ItemProperty -Path HKCU:\Software\Microsoft\DirectX\UserGpuPreferences -Name $OpenFileDialog.FileName -PropertyType String -Value "GpuPreference=2;" -Force
				}
			}
			"1"
			{
				if ($RU)
				{
					Write-Verbose -Message "Пропущено" -Verbose
				}
				else
				{
					Write-Verbose -Message "Skipped" -Verbose
				}
			}
		}
	}
	until ($Result -eq 1)
}

<#
Turn on hardware-accelerated GPU scheduling. Restart needed
Determining whether the PC has a dedicated GPU to use this feature

Включить планирование графического процессора с аппаратным ускорением. Необходима перезагрузка
Определяем, имеется ли у ПК внешняя видеокарта для использования данной функции
#>
if ((Get-CimInstance -ClassName CIM_VideoController | Where-Object -FilterScript {$_.AdapterDACType -ne "Internal"}))
{
	# Determining whether an OS is not installed on a virtual machine
	# Проверяем, не установлена ли ОС на виртуальной машине
	if ((Get-CimInstance -ClassName CIM_ComputerSystem).Model -notmatch "Virtual")
	{
		# Checking whether a WDDM verion is 2.7 or higher
		# Проверка: имеет ли WDDM версию 2.7 или выше
		$WddmVersion_Min = Get-ItemPropertyValue -Path HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\FeatureSetUsage -Name WddmVersion_Min
		if ($WddmVersion_Min -ge 2700)
		{
			New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name HwSchMode -PropertyType DWord -Value 2 -Force
		}
	}
}
#endregion Gaming

#region Scheduled tasks
<#
Create a Windows cleaning up task in the Task Scheduler
The task runs every 90 days

Создать задачу в Планировщике задач по очистке Windows
Задача выполняется каждые 90 дней
#>
Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches | ForEach-Object -Process {
	Remove-ItemProperty -Path $_.PsPath -Name StateFlags1337 -Force -ErrorAction Ignore
}

$VolumeCaches = @(
	# Delivery Optimization Files
	# Файлы оптимизации доставки
	"Delivery Optimization Files",
	# Device driver packages
	# Пакеты драйверов устройств
	"Device Driver Packages",
	# Previous Windows Installation(s)
	# Предыдущие установки Windows
	"Previous Installations",
	# Файлы журнала установки
	"Setup Log Files",
	# Temporary Setup Files
	"Temporary Setup Files",
	# Microsoft Defender Antivirus
	"Windows Defender",
	# Windows upgrade log files
	# Файлы журнала обновления Windows
	"Windows Upgrade Log Files"
)
foreach ($VolumeCache in $VolumeCaches)
{
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$VolumeCache" -Name StateFlags1337 -PropertyType DWord -Value 2 -Force
}

$PS1Script = '
$app = "{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\cleanmgr.exe"

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
$Template = [Windows.UI.Notifications.ToastTemplateType]::ToastImageAndText01
[xml]$ToastTemplate = ([Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent($Template).GetXml())

if ($PSUICulture -eq "ru-RU")
{
	[xml]$ToastTemplate = @"
<toast launch="app-defined-string">
	<visual>
		<binding template="ToastGeneric">
			<text>Очистка неиспользуемых файлов и обновлений Windows начнется через минуту</text>
		</binding>
	</visual>
	<actions>
	<action activationType="background" content="Хорошо" arguments="later"/>
	</actions>
</toast>
"@
}
else
{
	[xml]$ToastTemplate = @"
<toast launch="app-defined-string">
	<visual>
		<binding template="ToastGeneric">
			<text>Cleaning up unused Windows files and updates start in a minute</text>
		</binding>
	</visual>
	<actions>
		<action activationType="background" content="OK" arguments="later"/>
	</actions>
</toast>
"@
}

$ToastXml = New-Object -TypeName Windows.Data.Xml.Dom.XmlDocument
$ToastXml.LoadXml($ToastTemplate.OuterXml)

[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($app).Show($ToastXml)

Start-Sleep -Seconds 60

# Process startup info
# Параметры запуска процесса
$ProcessInfo = New-Object -TypeName System.Diagnostics.ProcessStartInfo
$ProcessInfo.FileName = "$env:SystemRoot\system32\cleanmgr.exe"
$ProcessInfo.Arguments = "/sagerun:1337"
$ProcessInfo.UseShellExecute = $true
$ProcessInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Minimized

# Process object using the startup info
# Объект процесса, используя заданные параметры
$Process = New-Object System.Diagnostics.Process
$Process.StartInfo = $ProcessInfo

# Start the process
# Запуск процесса
$Process.Start() | Out-Null

Start-Sleep -Seconds 3
$SourceMainWindowHandle = (Get-Process -Name cleanmgr).MainWindowHandle

function MinimizeWindow
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		$Process
	)

	$ShowWindowAsync = @{
	Namespace = "WinAPI"
	Name = "Win32ShowWindowAsync"
	Language = "CSharp"
	MemberDefinition = @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
"@
	}
	if (-not ("WinAPI.Win32ShowWindowAsync" -as [type]))
	{
		Add-Type @ShowWindowAsync
	}

	$MainWindowHandle = (Get-Process -Name $Process).MainWindowHandle
	[WinAPI.Win32ShowWindowAsync]::ShowWindowAsync($MainWindowHandle, 2)
}

while ($true)
{
	$CurrentMainWindowHandle = (Get-Process -Name cleanmgr).MainWindowHandle
	if ([int]$SourceMainWindowHandle -ne [int]$CurrentMainWindowHandle)
	{
		MinimizeWindow -Process cleanmgr
		break
	}
	Start-Sleep -Milliseconds 5
}

$ProcessInfo = New-Object -TypeName System.Diagnostics.ProcessStartInfo
# Cleaning up unused updates
# Очистка неиспользованных обновлений
$ProcessInfo.FileName = "$env:SystemRoot\system32\dism.exe"
$ProcessInfo.Arguments = "/Online /English /Cleanup-Image /StartComponentCleanup /NoRestart"
$ProcessInfo.UseShellExecute = $true
$ProcessInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Minimized

# Process object using the startup info
# Объект процесса, используя заданные параметры
$Process = New-Object System.Diagnostics.Process
$Process.StartInfo = $ProcessInfo

# Start the process
# Запуск процесса
$Process.Start() | Out-Null
'
$EncodedScript = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($PS1Script))

$Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Hidden -EncodedCommand $EncodedScript"
$Trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 90 -At 9am
$Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
$Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
if ($RU)
{
	$Description =
	"Очистка неиспользуемых файлов и обновлений Windows, используя встроенную программу Очистка диска. Чтобы расшифровать закодированную строку используйте [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(`"строка`"))"
}
else
{
	$Description =
	"Cleaning up unused Windows files and updates using built-in Disk cleanup app. To decode encoded command use [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(`"string`"))"
}
$Parameters = @{
	"TaskName"		= "Windows Cleanup"
	"TaskPath"		= "Setup Script"
	"Principal"		= $Principal
	"Action"		= $Action
	"Description"	= $Description
	"Settings"		= $Settings
	"Trigger"		= $Trigger
}
Register-ScheduledTask @Parameters -Force

<#
Create a task in the Task Scheduler to clear the %SystemRoot%\SoftwareDistribution\Download folder
The task runs on Thursdays every 4 weeks

Создать задачу в Планировщике задач по очистке папки %SystemRoot%\SoftwareDistribution\Download
Задача выполняется по четвергам каждую 4 неделю
#>
$Argument = "
	(Get-Service -Name wuauserv).WaitForStatus('Stopped', '01:00:00')
	Get-ChildItem -Path $env:SystemRoot\SoftwareDistribution\Download -Recurse -Force | Remove-Item -Recurse -Force
"
$Action = New-ScheduledTaskAction -Execute powershell.exe -Argument $Argument
$Trigger = New-JobTrigger -Weekly -WeeksInterval 4 -DaysOfWeek Thursday -At 9am
$Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -RunLevel Highest
if ($RU)
{
	$Description = "Очистка папки %SystemRoot%\SoftwareDistribution\Download"
}
else
{
	$Description = "The %SystemRoot%\SoftwareDistribution\Download folder cleaning"
}
$Parameters = @{
	"TaskName"		= "SoftwareDistribution"
	"TaskPath"		= "Setup Script"
	"Principal"		= $Principal
	"Action"		= $Action
	"Description"	= $Description
	"Settings"		= $Settings
	"Trigger"		= $Trigger
}
Register-ScheduledTask @Parameters -Force

<#
Create a task in the Task Scheduler to clear the %TEMP% folder
The task runs every 62 days

Создать задачу в Планировщике задач по очистке папки %TEMP%
Задача выполняется каждые 62 дня
#>
$Argument = "Get-ChildItem -Path $env:TEMP -Force -Recurse | Remove-Item -Force -Recurse"
$Action = New-ScheduledTaskAction -Execute powershell.exe -Argument $Argument
$Trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 62 -At 9am
$Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -RunLevel Highest
if ($RU)
{
	$Description = "Очистка папки %TEMP%"
}
else
{
	$Description = "The %TEMP% folder cleaning"
}
$Parameters = @{
	"TaskName"		= "Temp"
	"TaskPath"		= "Setup Script"
	"Principal"		= $Principal
	"Action"		= $Action
	"Description"	= $Description
	"Settings"		= $Settings
	"Trigger"		= $Trigger
}
Register-ScheduledTask @Parameters -Force
#endregion Scheduled tasks

#region Microsoft Defender & Security
# Turn on Controlled folder access and add protected folders
# Включить контролируемый доступ к папкам и добавить защищенные папки
if ($RU)
{
	$Title = "Контролируемый доступ к папкам"
	$Message = "Чтобы включить контролируемый доступ к папкам и добавить папку в список защищенных, введите необходимую букву"
	$Options = "&Добавить защищенную папку", "&Пропустить"
}
else
{
	$Title = "Controlled folder access"
	$Message = "To turn on Controlled folder access and add protected folder enter the required letter"
	$Options = "&Add a protected folder", "&Skip"
}
$DefaultChoice = 1

do
{
	$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
	switch ($Result)
	{
		"0"
		{
			Add-Type -AssemblyName System.Windows.Forms
			$FolderBrowserDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
			if ($RU)
			{
				$FolderBrowserDialog.Description = "Выберите папку"
			}
			else
			{
				$FolderBrowserDialog.Description = "Select a folder"
			}
			$FolderBrowserDialog.RootFolder = "MyComputer"
			# Focus on open file dialog
			# Перевести фокус на диалог открытия файла
			$tmp = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
			$FolderBrowserDialog.ShowDialog($tmp)
			if ($FolderBrowserDialog.SelectedPath)
			{
				Set-MpPreference -EnableControlledFolderAccess Enabled
				Add-MpPreference -ControlledFolderAccessProtectedFolders $FolderBrowserDialog.SelectedPath -Force
			}
		}
		"1"
		{
			if ($RU)
			{
				Write-Verbose -Message "Пропущено" -Verbose
			}
			else
			{
				Write-Verbose -Message "Skipped" -Verbose
			}
		}
	}
}
until ($Result -eq 1)

# Allow an app through Controlled folder access
# Разрешить работу приложения через контролируемый доступ к папкам
if ((Get-MpPreference).EnableControlledFolderAccess -eq 1)
{
	if ($RU)
	{
		$Title = "Контролируемый доступ к папкам"
		$Message = "Чтобы разрешить работу приложения через контролируемый доступ к папкам, введите необходимую букву"
		$Options = "&Добавить разрешенное приложение", "&Пропустить"
	}
	else
	{
		$Title = "Controlled folder access"
		$Message = "To allow an app through Controlled folder access enter the required letter"
		$Options = "&Add a protected folder", "&Skip"
	}
	$DefaultChoice = 1

	do
	{
		$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		switch ($Result)
		{
			"0"
			{
				Add-Type -AssemblyName System.Windows.Forms
				$OpenFileDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
				if ($RU)
				{
					$OpenFileDialog.Filter = "*.exe|*.exe|Все файлы (*.*)|*.*"
				}
				else
				{
					$OpenFileDialog.Filter = "*.exe|*.exe|All Files (*.*)|*.*"
				}
				$OpenFileDialog.InitialDirectory = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
				$OpenFileDialog.Multiselect = $false
				# Focus on open file dialog
				# Перевести фокус на диалог открытия файла
				$tmp = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
				$OpenFileDialog.ShowDialog($tmp)
				if ($OpenFileDialog.FileName)
				{
					Add-MpPreference -ControlledFolderAccessAllowedApplications $OpenFileDialog.FileName -Force
				}
			}
			"1"
			{
				if ($RU)
				{
					Write-Verbose -Message "Пропущено" -Verbose
				}
				else
				{
					Write-Verbose -Message "Skipped" -Verbose
				}
			}
		}
	}
	until ($Result -eq 1)
}

# Add exclusion folder from Microsoft Defender Antivirus scanning
# Добавить папку в список исключений сканирования Microsoft Defender
if ($RU)
{
	$Title = "Microsoft Defender"
	$Message = "Чтобы исключить папку из списка сканирования антивредоносной программы Microsoft Defender, введите необходимую букву"
	$Options = "&Исключить папку", "&Пропустить"
}
else
{
	$Title = "Microsoft Defender"
	$Message = "To exclude folder from Microsoft Defender Antivirus Scan enter the required letter"
	$Options = "&Exclude folder", "&Skip"
}
$DefaultChoice = 1

do
{
	$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
	switch ($Result)
	{
		"0"
		{
			Add-Type -AssemblyName System.Windows.Forms
			$FolderBrowserDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
			if ($RU)
			{
				$FolderBrowserDialog.Description = "Выберите папку"
			}
			else
			{
				$FolderBrowserDialog.Description = "Select a folder"
			}
			$FolderBrowserDialog.RootFolder = "MyComputer"
			# Focus on open file dialog
			# Перевести фокус на диалог открытия файла
			$tmp = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
			$FolderBrowserDialog.ShowDialog($tmp)
			if ($FolderBrowserDialog.SelectedPath)
			{
				Add-MpPreference -ExclusionPath $FolderBrowserDialog.SelectedPath -Force
			}
		}
		"1"
		{
			if ($RU)
			{
				Write-Verbose -Message "Пропущено" -Verbose
			}
			else
			{
				Write-Verbose -Message "Skipped" -Verbose
			}
		}
	}
}
until ($Result -eq 1)

# Add exclusion file from Microsoft Defender Antivirus scanning
# Добавить файл в список исключений сканирования Microsoft Defender
if ($RU)
{
	$Title = "Microsoft Defender"
	$Message = "Чтобы исключить файл из списка сканирования антивредоносной программы Microsoft Defender, введите необходимую букву"
	$Options = "&Исключить файл", "&Пропустить"
}
else
{
	$Title = "Microsoft Defender"
	$Message = "To exclude file from Microsoft Defender Antivirus Scan enter the required letter"
	$Options = "&Exclude file", "&Skip"
}
$DefaultChoice = 1

do
{
	$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
	switch ($Result)
	{
		"0"
		{
			Add-Type -AssemblyName System.Windows.Forms
			$OpenFileDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
			if ($RU)
			{
				$OpenFileDialog.Filter = "Все файлы (*.*)|*.*"
			}
			else
			{
				$OpenFileDialog.Filter = "All Files (*.*)|*.*"
			}
			$OpenFileDialog.InitialDirectory = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
			$OpenFileDialog.Multiselect = $false
			# Focus on open file dialog
			# Перевести фокус на диалог открытия файла
			$tmp = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
			$OpenFileDialog.ShowDialog($tmp)
			if ($OpenFileDialog.FileName)
			{
				Add-MpPreference -ExclusionPath $OpenFileDialog.FileName -Force
			}
		}
		"1"
		{
			if ($RU)
			{
				Write-Verbose -Message "Пропущено" -Verbose
			}
			else
			{
				Write-Verbose -Message "Skipped" -Verbose
			}
		}
	}
}
until ($Result -eq 1)

# Turn on Microsoft Defender Exploit Guard network protection
# Включить защиту сети в Microsoft Defender Exploit Guard
Set-MpPreference -EnableNetworkProtection Enabled

# Turn on detection for potentially unwanted applications and block them
# Включить обнаружение потенциально нежелательных приложений и блокировать их
Set-MpPreference -PUAProtection Enabled

# Run Microsoft Defender within a sandbox
# Запускать Microsoft Defender в песочнице
setx /M MP_FORCE_USE_SANDBOX 1

# Dismiss Microsoft Defender offer in the Windows Security about signing in Microsoft account
# Отклонить предложение Microsoft Defender в "Безопасность Windows" о входе в аккаунт Microsoft
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows Security Health\State" -Name AccountProtection_MicrosoftAccount_Disconnected -PropertyType DWord -Value 1 -Force

# Dismiss Microsoft Defender offer in the Windows Security about to turn on the SmartScreen filter for Microsoft Edge
# Отклонить предложение Windows Defender в "Безопасность Windows" включить фильтр SmartScreen для Microsoft Edge
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows Security Health\State" -Name AppAndBrowser_EdgeSmartScreenOff -PropertyType DWord -Value 0 -Force

# Turn on events auditing generated when a process is created or starts
# Включить аудит событий, возникающих при создании или запуске процесса
auditpol /set /subcategory:"{0CCE922B-69AE-11D9-BED3-505054503030}" /success:enable /failure:enable

<#
Include command line in process creation events
In order this feature to work events auditing must be enabled

Включать командную строку в событиях создания процесса
Необходимо включить аудит событий, чтобы работала данная опция
#>
if ($RU)
{
	$OutputEncoding = [System.Console]::OutputEncoding = [System.Console]::InputEncoding = [System.Text.Encoding]::UTF8
}
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit -Name ProcessCreationIncludeCmdLine_Enabled -PropertyType DWord -Value 1 -Force

<#
Create "Process Creation" Event Viewer Custom View
In order this feature to work events auditing and command line in process creation events must be enabled

Создать настаиваемое представление "Создание процесса" в Просмотре событий
Необходимо включить аудит событий и командную строку в событиях создания процесса, чтобы работала данная опция
#>
$XML = @"
<ViewerConfig>
	<QueryConfig>
		<QueryParams>
			<UserQuery />
		</QueryParams>
		<QueryNode>
			<Name>Process Creation</Name>
			<Description>Process Creation and Command-line Auditing Events</Description>
			<QueryList>
				<Query Id="0" Path="Security">
					<Select Path="Security">*[System[(EventID=4688)]]</Select>
				</Query>
			</QueryList>
		</QueryNode>
	</QueryConfig>
</ViewerConfig>
"@
if (-not (Test-Path -Path "$env:ProgramData\Microsoft\Event Viewer\Views"))
{
	New-Item -Path "$env:ProgramData\Microsoft\Event Viewer\Views" -ItemType Directory -Force
}
$ProcessCreationFilePath = "$env:ProgramData\Microsoft\Event Viewer\Views\ProcessCreation.xml"
# Saving ProcessCreation.xml in UTF-8 encoding
# Сохраняем ProcessCreation.xml в кодировке UTF-8
Set-Content -Value (New-Object System.Text.UTF8Encoding).GetBytes($XML) -Encoding Byte -Path $ProcessCreationFilePath -Force

if ($RU)
{
	[xml]$XML = Get-Content -Path $ProcessCreationFilePath
	$XML.ViewerConfig.QueryConfig.QueryNode.Name = "Создание процесса"
	$XML.ViewerConfig.QueryConfig.QueryNode.Description = "События содания нового процесса и аудит командной строки"
	$xml.Save("$env:ProgramData\Microsoft\Event Viewer\Views\ProcessCreation.xml")
}

# Turn on logging for all Windows PowerShell modules
# Включить ведение журнала для всех модулей Windows PowerShell
if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging -Name EnableModuleLogging -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames -Name * -PropertyType String -Value * -Force

# Turn on logging of all PowerShell script input to the Windows PowerShell event log
# Включить регистрацию всех вводимых сценариев PowerShell в журнале событий Windows PowerShell
if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Name EnableScriptBlockLogging -PropertyType DWord -Value 1 -Force

# Turn off SmartScreen for apps and files
# Отключить SmartScreen для приложений и файлов
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name SmartScreenEnabled -PropertyType String -Value Off -Force

# Turn off Windows Script Host
# Отключить Windows Script Host
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Name Enabled -PropertyType DWord -Value 0 -Force
#endregion Microsoft Defender & Security

#region Context menu
# Add the "Extract" item to Windows Installer (.msi) context menu
# Добавить пункт "Извлечь" в контекстное меню Windows Installer (.msi)
if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command))
{
	New-Item -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command -Force
}
$Value = "{0}" -f 'msiexec.exe /a "%1" /qb TARGETDIR="%1 extracted"'
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command -Name "(Default)" -PropertyType String -Value $Value -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Name MUIVerb -PropertyType String -Value "@shell32.dll,-31382" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Name Icon -PropertyType String -Value "shell32.dll,-16817" -Force

# Add the "Install" item to the .cab archives context menu
# Добавить пункт "Установить" в контекстное меню .cab архивов
if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command))
{
	New-Item -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command -Force
}
$Value = "{0}" -f "cmd /c DISM.exe /Online /Add-Package /PackagePath:`"%1`" /NoRestart & pause"
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command -Name "(Default)" -PropertyType String -Value $Value -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs -Name MUIVerb -PropertyType String -Value "@shell32.dll,-10210" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs -Name HasLUAShield -PropertyType String -Value "" -Force

# Add the "Run as different user" item to the .exe files types context menu
# Добавить "Запуск от имени другого пользователя" в контекстное меню .exe файлов
Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\exefile\shell\runasuser -Name Extended -Force -ErrorAction Ignore

# Hide the "Cast to Device" item from the context menu
# Скрыть пункт "Передать на устройство" из контекстного меню
if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"))
{
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" -PropertyType String -Value "Play to menu" -Force

# Hide the "Share" item from the context menu
# Скрыть пункт "Отправить" (поделиться) из контекстного меню
if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"))
{
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{E2BF9676-5F8F-435C-97EB-11607A5BEDF7}" -PropertyType String -Value "" -Force

# Hide the "Edit with Paint 3D" item from the context menu
# Скрыть пункт "Изменить с помощью Paint 3D" из контекстного меню
$extensions = @(".bmp", ".gif", ".jpe", ".jpeg", ".jpg", ".png", ".tif", ".tiff")
foreach ($extension in $extensions)
{
	New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\$extension\Shell\3D Edit" -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
}

# Hide the "Edit with Photos" item from the context menu
# Скрыть пункт "Изменить с помощью приложения "Фотографии"" из контекстного меню
if (Get-AppxPackage -Name Microsoft.Windows.Photos)
{
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellEdit -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
}

# Hide the "Create a new video" item from the context menu
# Скрыть пункт "Создать новое видео" из контекстного меню
if (Get-AppxPackage -Name Microsoft.Windows.Photos)
{
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellCreateVideo -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
}

# Hide the "Edit" item from the images context menu
# Скрыть пункт "Изменить" из контекстного меню изображений
if ((Get-WindowsCapability -Online -Name "Microsoft.Windows.MSPaint*").State -eq "Installed")
{
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\edit -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
}

# Hide the "Print" item from the .bat and .cmd context menu
# Скрыть пункт "Печать" из контекстного меню .bat и .cmd файлов
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\batfile\shell\print -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\cmdfile\shell\print -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force

# Hide the "Include in Library" item from the context menu
# Скрыть пункт "Добавить в библиотеку" из контекстного меню
New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Folder\shellex\ContextMenuHandlers\Library Location" -Name "(Default)" -PropertyType String -Value "-{3dad6c5d-2167-4cae-9914-f99e41c12cfa}" -Force

# Hide the "Send to" item from the folders context menu
# Скрыть пункт "Отправить" из контекстного меню папок
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo -Name "(Default)" -PropertyType String -Value "-{7BA4C740-9E81-11CF-99D3-00AA004AE837}" -Force

# Hide the "Turn on BitLocker" item from the context menu
# Скрыть пункт "Включить BitLocker" из контекстного меню
if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -eq "Professional" -or $_.Edition -like "Enterprise*"})
{
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\encrypt-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\encrypt-bde-elev -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\manage-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\resume-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\resume-bde-elev -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\unlock-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
}

# Remove the "Bitmap image" item from the "New" context menu
# Удалить пункт "Точечный рисунок" из контекстного меню "Создать"
if ((Get-WindowsCapability -Online -Name "Microsoft.Windows.MSPaint*").State -eq "Installed")
{
	Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.bmp\ShellNew -Force -ErrorAction Ignore
}

# Remove the "Rich Text Document" item from the "New" context menu
# Удалить пункт "Документ в формате RTF" из контекстного меню "Создать"
if ((Get-WindowsCapability -Online -Name "Microsoft.Windows.WordPad*").State -eq "Installed")
{
	Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.rtf\ShellNew -Force -ErrorAction Ignore
}

# Remove the "Compressed (zipped) Folder" item from the "New" context menu
# Удалить пункт "Сжатая ZIP-папка" из контекстного меню "Создать"
Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew -Force -ErrorAction Ignore

# Make the "Open", "Print", "Edit" context menu items available, when more than 15 items selected
# Сделать доступными элементы контекстного меню "Открыть", "Изменить" и "Печать" при выделении более 15 элементов
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name MultipleInvokePromptMinimum -PropertyType DWord -Value 300 -Force

# Hide the "Look for an app in the Microsoft Store" item in "Open with" dialog
# Скрыть пункт "Поиск приложения в Microsoft Store" в диалоге "Открыть с помощью"
if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name NoUseStoreOpenWith -PropertyType DWord -Value 1 -Force

# Hide the "Previous Versions" tab from files and folders context menu and the "Restore previous versions" context menu item
# Скрыть вкладку "Предыдущие версии" в свойствах файлов и папок и пункт контекстного меню "Восстановить прежнюю версию"
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name NoPreviousVersionsPage -PropertyType DWord -Value 1 -Force
#endregion Context menu

#region Refresh
$UpdateExplorer = @{
	Namespace = "WinAPI"
	Name = "UpdateExplorer"
	Language = "CSharp"
	MemberDefinition = @"
private static readonly IntPtr HWND_BROADCAST = new IntPtr(0xffff);
private const int WM_SETTINGCHANGE = 0x1a;
private const int SMTO_ABORTIFHUNG = 0x0002;

[DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = false)]
static extern bool SendNotifyMessage(IntPtr hWnd, uint Msg, IntPtr wParam, string lParam);
[DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = false)]
private static extern IntPtr SendMessageTimeout(IntPtr hWnd, int Msg, IntPtr wParam, string lParam, int fuFlags, int uTimeout, IntPtr lpdwResult);
[DllImport("shell32.dll", CharSet = CharSet.Auto, SetLastError = false)]
private static extern int SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2);
public static void Refresh()
{
	// Update desktop icons
	// Обновить иконки рабочего стола
	SHChangeNotify(0x8000000, 0x1000, IntPtr.Zero, IntPtr.Zero);
	// Update environment variables
	// Обновить переменные среды
	SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, IntPtr.Zero, null, SMTO_ABORTIFHUNG, 100, IntPtr.Zero);
	// Update taskbar
	// Обновить панель задач
	SendNotifyMessage(HWND_BROADCAST, WM_SETTINGCHANGE, IntPtr.Zero, "TraySettings");
}

private static readonly IntPtr hWnd = new IntPtr(65535);
private const int Msg = 273;
// Virtual key ID of the F5 in File Explorer
// Виртуальный код клавиши F5 в проводнике
private static readonly UIntPtr UIntPtr = new UIntPtr(41504);

[DllImport("user32.dll", SetLastError=true)]
public static extern int PostMessageW(IntPtr hWnd, uint Msg, UIntPtr wParam, IntPtr lParam);
public static void PostMessage()
{
	// F5 pressing simulation to refresh the desktop
	// Симуляция нажатия F5 для обновления рабочего стола
	PostMessageW(hWnd, Msg, UIntPtr, IntPtr.Zero);
}
"@
}
if (-not ("WinAPI.UpdateExplorer" -as [type]))
{
	Add-Type @UpdateExplorer
}

# Send F5 pressing simulation to refresh the desktop
# Симулировать нажатие F5 для обновления рабочего стола
[WinAPI.UpdateExplorer]::PostMessage()
# Refresh desktop icons, environment variables, taskbar
# Обновить иконки рабочего стола, переменные среды, панель задач
[WinAPI.UpdateExplorer]::Refresh()

# Restart the Start menu
# Перезапустить меню "Пуск"
Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction Ignore
#endregion Refresh

# Errors output
# Вывод ошибок
if ($Error)
{
	($Error | ForEach-Object -Process {
		if ($RU)
		{
			[PSCustomObject] @{
				Строка = $_.InvocationInfo.ScriptLineNumber
				"Ошибки/предупреждения" = $_.Exception.Message
			}
		}
		else
		{
			[PSCustomObject] @{
				Line = $_.InvocationInfo.ScriptLineNumber
				"Errors/Warnings" = $_.Exception.Message
			}
		}
	} | Sort-Object -Property Line | Format-Table -AutoSize -Wrap | Out-String).Trim()
}