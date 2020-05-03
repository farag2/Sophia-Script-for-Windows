<#
.SYNOPSIS
	"Windows 10 Setup Script" is a set of tweaks for OS fine-tuning and automating the routine tasks.
.DESCRIPTION
	Supported Windows versions:
	Windows 10 1903/1909 (19H1/19H2), 18362/18363 build, x64 only. Tested on Pro/Enterprise editions.

	Check whether file is encoded in UTF-8 with BOM.
	PowerShell must be run with elevated privileges;
	Set PowerShell execution policy: Set-ExecutionPolicy -ExecutionPolicy Bypass -Force to be able to run .ps1 files.

	Read the code you run carefully.
	Some functions are presented as an example only.
	You must be aware of the meaning of the functions in the code.
	If you're not sure what the script does, do not run it.
	Strongly recommended to run the script after fresh installation.
	Some of functions can be run also on LTSB/LTSC and on older versions of Windows and PowerShell (not recommended to run on the x86 systems).
.EXAMPLE
	PS C:\> & '.\Win 10.ps1'
.NOTES
	Version: v4.1
	Date: 03.05.2020
	Written by: farag
	Thanks to all http://forum.ru-board.com members involved
	Ask a question on
	- http://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15
	- https://habr.com/en/post/465365/
	- https://4pda.ru/forum/index.php?s=&showtopic=523489&view=findpost&p=95909388
	- https://forums.mydigitallife.net/threads/powershell-script-setup-windows-10.80139/
	- https://www.reddit.com/r/Windows10/comments/ctg8jw/powershell_script_setup_windows_10/
	Copyright (c) 2020 farag
.LINK
	https://github.com/farag2/Windows-10-Setup-Script
#>

#Requires -RunAsAdministrator
#Requires -Version 5

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
if (-not ([Environment]::Is64BitOperatingSystem))
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

# Detect the PowerShell bitness
# Определить разрядность PowerShell
if (-not ([IntPtr]::Size -eq 8))
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
#endregion Check

#region Begin
Set-StrictMode -Version Latest

# Сlear $Error variable
# Очистка переменной $Error
$Error.Clear()

# Set the encoding to UTF-8 without BOM for the PowerShell session
# Установить кодировку UTF-8 без BOM для текущей сессии PowerShell
if ($RU)
{
	ping.exe | Out-Null
	$OutputEncoding = [System.Console]::OutputEncoding = [System.Console]::InputEncoding = [System.Text.Encoding]::UTF8
}

# Create a restore point
# Создать точку восстановления
if ($RU)
{
	Write-Host "`nЧтобы создать точку восстановления, введите букву: " -NoNewline
	Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
	Write-Host " или " -NoNewline
	Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
	Write-Host ", чтобы пропустить" -NoNewline
	Write-Host "`nТакже, чтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nTo сreate a restore point type: " -NoNewline
	Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
	Write-Host " or " -NoNewline
	Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
	Write-Host " to skip" -NoNewline
	Write-Host "`nAlso press Enter to skip" -NoNewline
}
do
{
	$Prompt = Read-Host -Prompt " "
	if ([string]::IsNullOrEmpty($Prompt))
	{
		break
	}
	else
	{
		switch ($Prompt)
		{
			"Y"
			{
				if (-not (Get-ComputerRestorePoint))
				{
					Enable-ComputerRestore -Drive $env:SystemDrive
				}
				# Set system restore point creation frequency to 5 minutes
				# Установить частоту создания точек восстановления на 5 минут
				New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name SystemRestorePointCreationFrequency -PropertyType DWord -Value 5 -Force
				# Descriptive name format for the restore point: <day of weekend>, <Month> <date>, <year> <time>
				# Формат описания точки восстановления: <день недели>, <дата> <месяц> <год> <время>
				$CheckpointDescription = (Get-Date).GetDateTimeFormats()[13]
				Checkpoint-Computer -Description $CheckpointDescription -RestorePointType MODIFY_SETTINGS
				New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name SystemRestorePointCreationFrequency -PropertyType DWord -Value 1440 -Force
			}
			"N"
			{
				if ($RU)
				{
					Write-Host "`nЧтобы удалить все точки восстановления, введите букву: " -NoNewline
					Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
					Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
				}
				else
				{
					Write-Host "`nTo remove all restore points type: " -NoNewline
					Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
					Write-Host "`nPress Enter to skip" -NoNewline
				}
				do
				{
					$Prompt = Read-Host -Prompt " "
					if ([string]::IsNullOrEmpty($Prompt))
					{
						break
					}
					else
					{
						switch ($Prompt)
						{
							"Y"
							{
								# Delete all restore points
								# Удалить все точки восстановения
								Get-CimInstance -ClassName Win32_ShadowCopy | Remove-CimInstance
							}
							Default
							{
								if ($RU)
								{
									Write-Host "`nНеправильная буква." -ForegroundColor Yellow
									Write-Host "`nЧтобы удалить все точки восстановления, введите букву: " -NoNewline
									Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
									Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
								}
								else
								{
									Write-Host "`nInvalid letter." -ForegroundColor Yellow
									Write-Host "`nTo remove all restore points type: " -NoNewline
									Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
									Write-Host "`nPress Enter to skip" -NoNewline
								}
							}
						}
					}
				}
				until ($Prompt -eq "Y")
			}
			Default
			{
				if ($RU)
				{
					Write-Host "`nНеправильная буква." -ForegroundColor Yellow
					Write-Host "`nЧтобы создать точку восстановления, введите букву: " -NoNewline
					Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
					Write-Host " или " -NoNewline
					Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
					Write-Host ", чтобы пропустить" -NoNewline
					Write-Host "`nТакже, чтобы пропустить, нажмите Enter" -NoNewline
				}
				else
				{
					Write-Host "`nInvalid letter." -ForegroundColor Yellow
					Write-Host "`nTo сreate a restore point type: " -NoNewline
					Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
					Write-Host " or " -NoNewline
					Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
					Write-Host " to skip" -NoNewline
					Write-Host "`nAlso press Enter to skip" -NoNewline
				}
			}
		}
	}
}
until ($Prompt -eq "Y")
#endregion Begin

#region Privacy & Telemetry
# Turn off "Connected User Experiences and Telemetry" service
# Отключить службу "Функциональные возможности для подключенных пользователей и телеметрия"
Get-Service -Name DiagTrack | Stop-Service -Force
Get-Service -Name DiagTrack | Set-Service -StartupType Disabled

# Turn off per-user services
# Отключить cлужбы для отдельных пользователей
$services = @(
	# Contact Data
	# Служба контактных данных
	"PimIndexMaintenanceSvc_*"
	# User Data Storage
	# Служба хранения данных пользователя
	"UnistoreSvc_*"
	# User Data Access
	# Служба доступа к данным пользователя
	"UserDataSvc_*"
)
Get-Service -Name $services | Stop-Service -Force
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\PimIndexMaintenanceSvc -Name Start -PropertyType DWord -Value 4 -Force
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\PimIndexMaintenanceSvc -Name UserServiceFlags -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\UnistoreSvc -Name Start -PropertyType DWord -Value 4 -Force
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\UnistoreSvc -Name UserServiceFlags -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\UserDataSvc -Name Start -PropertyType DWord -Value 4 -Force
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\UserDataSvc -Name UserServiceFlags -PropertyType DWord -Value 0 -Force

# Stop event trace sessions
# Остановить сеансы отслеживания событий
Get-EtwTraceSession -Name DiagLog -ErrorAction Ignore | Remove-EtwTraceSession

# Turn off the data collectors at the next computer restart
# Отключить сборщики данных при следующем запуске ПК
Update-AutologgerConfig -Name DiagLog, Diagtrack-Listener -Start 0 -ErrorAction Ignore

# Set the operating system diagnostic data level
# Установить уровень отправляемых диагностических сведений
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
if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$sid"))
{
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$SID" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$sid" -Name OptOut -PropertyType DWord -Value 1 -Force

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
# Не предлагать способыe завершения настройки устройства для максимально эффективного использования Windows
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

# Show folder merge conflicts
# Не скрывать конфликт слияния папок
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideMergeConflicts -PropertyType DWord -Value 0 -Force

# Open File Explorer to: "This PC"
# Открывать проводник для: "Этот компьютер"
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -PropertyType DWord -Value 1 -Force

# Do not show all folders in the navigation pane
# Не отображать все папки в области навигации
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -PropertyType DWord -Value 0 -Force

# Do not show Cortana button on taskbar
# Не показывать кнопку Кортаны на панели задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCortanaButton -PropertyType DWord -Value 0 -Force

# Do not show sync provider notification within File Explorer
# Не показывать уведомления поставщика синхронизации в проводнике
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSyncProviderNotifications -PropertyType DWord -Value 0 -Force

# Do not show Task View button on taskbar
# Не показывать кнопку Просмотра задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -PropertyType DWord -Value 0 -Force

# Do not show People on the taskbar
# Не показывать панель "Люди" на панели задач
if (-not (Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Name PeopleBand -PropertyType DWord -Value 0 -Force

# Show seconds on taskbar clock
# Отображать секунды в системных часах на панели задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSecondsInSystemClock -PropertyType DWord -Value 1 -Force

# Increase taskbar transparency
# Увеличить прозрачность панели задач
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name UseOLEDTaskbarTransparency -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\Dwm -Name ForceEffectMode -PropertyType DWord -Value 1 -Force

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

# Display recycle bin files delete confirmation
# Запрашивать подтверждение на удаление файлов в корзину
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
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -PropertyType DWord -Value 0 -Force

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

# Set the "Control Panel" view on "Large icons"
# Установить крупные значки в Панели управления
if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name AllItemsIconView -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name StartupPage -PropertyType DWord -Value 1 -Force

# Choose theme color for default Windows mode
# Выбрать режим Windows по умолчанию
if ($RU)
{
	Write-Host "`nВыберите режим Windows по умолчанию, введя букву: "
	Write-Host "[L]ight " -ForegroundColor Yellow -NoNewline
	Write-Host "для светлого режима или " -NoNewline
	Write-Host "[D]ark " -ForegroundColor Yellow -NoNewline
	Write-Host "для тёмного."
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nChoose theme color for default Windows mode by typing"
	Write-Host "[L]ight " -ForegroundColor Yellow -NoNewline
	Write-Host "for the light mode or " -NoNewline
	Write-Host "[D]ark " -ForegroundColor Yellow -NoNewline
	Write-Host "for the dark"
	Write-Host "`nPress Enter to skip" -NoNewline
}
do
{
	$theme = Read-Host -Prompt " "
	if ([string]::IsNullOrEmpty($theme))
	{
		break
	}
	else
	{
		switch ($theme)
		{
			"L"
			{
				# Light theme color for default Windows mode
				# Режим Windows по умолчанию светлый
				New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -PropertyType DWord -Value 1 -Force
			}
			"D"
			{
				# Dark theme color for default Windows mode
				# Режим Windows по умолчанию темный
				New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -PropertyType DWord -Value 0 -Force
			}
			Default
			{
				if ($RU)
				{
					Write-Host "`nНеправильная буква." -ForegroundColor Yellow
					Write-Host "Введите правильную букву: " -NoNewline
					Write-Host "[L]ight " -ForegroundColor Yellow -NoNewline
					Write-Host "для светлого режима или " -NoNewline
					Write-Host "[D]ark " -ForegroundColor Yellow -NoNewline
					Write-Host "для тёмного."
					Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
				}
				else
				{
					Write-Host "`nInvalid letter." -ForegroundColor Yellow
					Write-Host "Type the correct letter: " -NoNewline
					Write-Host "[L]ight " -ForegroundColor Yellow -NoNewline
					Write-Host "for the light mode or " -NoNewline
					Write-Host "[D]ark " -ForegroundColor Yellow -NoNewline
					Write-Host "for the dark."
					Write-Host "`nPress Enter to skip" -NoNewline
				}
			}
		}
	}
}
until ($theme -eq "L" -or $theme -eq "D")

# Choose theme color for default app mode
# Выбрать режим приложения по умолчанию
if ($RU)
{
	Write-Host "`nВыберите режим приложения по умолчанию, введя букву: "
	Write-Host "[L]ight " -ForegroundColor Yellow -NoNewline
	Write-Host "для светлого режима или " -NoNewline
	Write-Host "[D]ark " -ForegroundColor Yellow -NoNewline
	Write-Host "для тёмного."
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nChoose theme color for default app mode by typing"
	Write-Host "[L]ight " -ForegroundColor Yellow -NoNewline
	Write-Host "for the light mode or " -NoNewline
	Write-Host "[D]ark " -ForegroundColor Yellow -NoNewline
	Write-Host "for the dark"
	Write-Host "`nPress Enter to skip" -NoNewline
}
do
{
	$theme = Read-Host -Prompt " "
	if ([string]::IsNullOrEmpty($theme))
	{
		break
	}
	else
	{
		switch ($theme)
		{
			"L"
			{
				# Light theme color for default app mode
				# Режим приложений по умолчанию светлый
				New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -PropertyType DWord -Value 1 -Force
			}
			"D"
			{
				# Dark theme color for default app mode
				# Режим приложений по умолчанию темный
				New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -PropertyType DWord -Value 0 -Force
			}
			Default
			{
				if ($RU)
				{
					Write-Host "`nНеправильная буква." -ForegroundColor Yellow
					Write-Host "Введите правильную букву: " -NoNewline
					Write-Host "[L]ight " -ForegroundColor Yellow -NoNewline
					Write-Host "для светлого режима или " -NoNewline
					Write-Host "[D]ark " -ForegroundColor Yellow -NoNewline
					Write-Host "для тёмного."
					Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
				}
				else
				{
					Write-Host "`nInvalid letter." -ForegroundColor Yellow
					Write-Host "Type the correct letter: " -NoNewline
					Write-Host "[L]ight " -ForegroundColor Yellow -NoNewline
					Write-Host "for the light mode or " -NoNewline
					Write-Host "[D]ark " -ForegroundColor Yellow -NoNewline
					Write-Host "for the dark."
					Write-Host "`nPress Enter to skip" -NoNewline
				}
			}
		}
	}
}
until ($theme -eq "L" -or $theme -eq "D")

# Show accent color on Start, taskbar, and action center
# Отображать цвет элементов в меню "Пуск", на панели задач и в центре уведовлений
if ((Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme) -ne 0)
{
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name ColorPrevalence -PropertyType DWord -Value 0 -Force
}

# Show accent color on the title bars and window borders
# Отображать цвет элементов в заголовках окон и границ окон
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\DWM -Name ColorPrevalence -PropertyType DWord -Value 1 -Force

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

# Remove Microsoft Edge shortcut from the Desktop
# Удалить ярлык Microsoft Edge с рабочего стола
$DesktopFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Desktop
Remove-Item -Path "$DesktopFolder\Microsoft Edge.lnk" -Force -ErrorAction Ignore

# Show a notification when your PC requires a restart to finish updating
# Показывать уведомление, когда компьютеру требуется перезагрузка для завершения обновления
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name RestartNotificationsAllowed2 -PropertyType DWord -Value 1 -Force
# Do not add the "- Shortcut" for created shortcuts
# Нe дoбaвлять "- яpлык" для coздaвaeмыx яpлыкoв
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name link -PropertyType Binary -Value ([byte[]](00, 00, 00, 00)) -Force

# Use the PrtScn button to open screen snipping
# Использовать кнопку PRINT SCREEN, чтобы запустить функцию создания фрагмента экрана
New-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name PrintScreenKeyForSnippingEnabled -PropertyType DWord -Value 1 -Force

# Automatically adjust active hours for me based on daily usage
# Автоматически изменять период активности для этого устройства на основе действий
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name SmartActiveHoursState -PropertyType DWord -Value 1 -Force
#endregion UI & Personalization

#region OneDrive
# Uninstall OneDrive
# Удалить OneDrive
[string] $UninstallString = Get-Package -Name "Microsoft OneDrive" -ErrorAction Ignore | ForEach-Object -Process {$_.Meta.Attributes["UninstallString"]}
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
	Stop-Process -Name OneDrive -Force
	Stop-Process -Name FileCoAuth -ErrorAction Ignore -Force
	# Save all opened folders in order to restore them after File Explorer restarting
	# Сохранить все открытые папки, чтобы восстановить их после перезапуска проводника
	Clear-Variable -Name OpenedFolders -Force -ErrorAction Ignore
	$OpenedFolders = {(New-Object -ComObject Shell.Application).Windows() | ForEach-Object -Process {$_.Document.Folder.Self.Path}}.Invoke()
	# Getting link to the OneDriveSetup.exe and its' argument(s)
	# Получаем ссылку на OneDriveSetup.exe и его аргумент(ы)
	[string[]] $OneDriveSetup = ($UninstallString -Replace("\s*/",",/")).Trim().Split(",")
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
	Remove-Item -Path $OneDriveFolder -Recurse -Force
	Remove-Item -Path $env:LOCALAPPDATA\OneDrive -Recurse -Force -ErrorAction Ignore
	Remove-Item -Path $env:LOCALAPPDATA\Microsoft\OneDrive -Recurse -Force -ErrorAction Ignore
}
#endregion OneDrive

#region System
# Turn on Storage Sense
# Включить контроль памяти
if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -ItemType Directory -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01 -PropertyType DWord -Value 1 -Force
if ((Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01) -eq "1")
{
	# Run Storage Sense every month
	# Запускать контроль памяти каждый месяц
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 2048 -PropertyType DWord -Value 30 -Force
	# Delete temporary files that apps aren't using
	# Удалять временные файлы, не используемые в приложениях
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 04 -PropertyType DWord -Value 1 -Force
	# Delete files in recycle bin if they have been there for over 30 days
	# Удалять файлы из корзины, если они находятся в корзине более 30 дней
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 256 -PropertyType DWord -Value 30 -Force
	# Never delete files in "Downloads" folder
	# Никогда не удалять файлы из папки "Загрузки"
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 512 -PropertyType DWord -Value 0 -Force
}

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
# Change %TEMP% environment variable path to %SystemDrive%\Temp
# Изменить путь переменной среды для %TEMP% на %SystemDrive%\Temp
if (-not (Test-Path -Path $env:SystemDrive\Temp))
{
	New-Item -Path $env:SystemDrive\Temp -ItemType Directory -Force
}
[Environment]::SetEnvironmentVariable("TMP", "$env:SystemDrive\Temp", "User")
New-ItemProperty -Path HKCU:\Environment -Name TMP -PropertyType ExpandString -Value %SystemDrive%\Temp -Force
[Environment]::SetEnvironmentVariable("TEMP", "$env:SystemDrive\Temp", "User")
New-ItemProperty -Path HKCU:\Environment -Name TEMP -PropertyType ExpandString -Value %SystemDrive%\Temp -Force
[Environment]::SetEnvironmentVariable("TMP", "$env:SystemDrive\Temp", "Machine")
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name TMP -PropertyType ExpandString -Value %SystemDrive%\Temp -Force
[Environment]::SetEnvironmentVariable("TEMP", "$env:SystemDrive\Temp", "Machine")
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name TEMP -PropertyType ExpandString -Value %SystemDrive%\Temp -Force
[Environment]::SetEnvironmentVariable("TMP", "$env:SystemDrive\Temp", "Process")
[Environment]::SetEnvironmentVariable("TEMP", "$env:SystemDrive\Temp", "Process")
Remove-Item $env:LOCALAPPDATA\Temp -Recurse -Force -ErrorAction Ignore
Restart-Service -Name Spooler -Force
Remove-Item -Path $env:SystemRoot\Temp -Recurse -Force -ErrorAction Ignore

# Turn on Win32 long paths
# Включить длинные пути Win32
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem -Name LongPathsEnabled -PropertyType DWord -Value 1 -Force

# Group svchost.exe processes
# Группировать процессы svchost.exe
$RAMCapacity = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum/1kb
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
	# Windows Fax and Scan
	# Факсы и сканирование
	"FaxServicesClientPackage"
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
 
# Remove Windows capabilities
# Удалить дополнительные компоненты Windows
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName PresentationFramework

# Windows capabilities array list to remove
# Массив имен дополнительных компонентов Windows для удаления
$Capabilities = New-Object System.Collections.ArrayList($null)

# Windows capabilities that will be checked to remove by default
# Дополнительные компоненты Windows, которые будут отмечены на удаление по умолчанию
$CheckedCapabilities = @(
	# Microsoft Quick Assist
	# Быстрая поддержка (Майкрософт)
	"App.Support.QuickAssist*"
	# Windows Media Player
	# Проигрыватель Windows Media
	"Media.WindowsMediaPlayer*"

)
# If device is not a laptop
# Если устройство не является ноутбуком
if ((Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType -ne 2)
{
	# Windows Hello Face
	# Распознавание лиц Windows Hello
	$CheckedCapabilities += "Hello.Face*"
}
#endregion Variables

#region XAML Markup
[xml]$XAML = '
<Window
	xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
	xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
	Name="Window" Title="Packages to uninstall"
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
		<Button Name="Button" Grid.Row="1" Content="Uninstall"/>
	</Grid>
</Window>
'
#endregion XAML Markup

$Reader = (New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $XAML)
$GUI = [Windows.Markup.XamlReader]::Load($Reader)
$XAML.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object -Process {
	Set-Variable -Name ($_.Name) -Value $GUI.FindName($_.Name) -Scope Global
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
		[string]$Capability
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
		# If package checked, add to the array list to remove
		# Если пакет выделен, то добавить в массив для удаления
		[void]$Capabilities.Add($Capability)
	}
}
#endregion Functions

#region Events Handlers
# Window Loaded Event
$Window.Add_Loaded({
	# Windows capabilities that will be shown in the GUI
	# Дополнительные компоненты Windows, которые будут выводиться в GUI
	$ExcludedCapabilities = @(
		# Language components
		# Языковые компоненты
		"Language\."
		# Mail, contacts, and calendar sync component
		# Компонент синхронизации почты, контактов и календаря.
		"OneCoreUAP\.OneSync"
	)
	$OFS = "|"
	(Get-WindowsCapability -Online | Where-Object -FilterScript {($_.State -eq "Installed") -and ($_.Name -cnotmatch $ExcludedCapabilities)}).Name | ForEach-Object -Process {
		Add-CapabilityControl -Capability $_
	}
	$OFS = " "
})

# Button Click Event
$Button.Add_Click({DeleteButton})
#endregion Events Handlers

if ($RU)
{
	Write-Verbose -Message "GUI открывается..." -Verbose
}
else
{
	Write-Verbose "GUI opening..." -Verbose
}
$GUI.ShowDialog() | Out-Null

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
	powercfg /setactive SCHEME_BALANCED
}
else
{
	# High performance for desktop
	# Высокая производительность для стационарного ПК
	powercfg /setactive SCHEME_MIN
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
Set-WinDefaultInputMethodOverride "0409:00000409"

# Turn on Windows Sandbox
# Включить Windows Sandbox
if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -eq "Professional" -or $_.Edition -eq "Enterprise"})
{
	# Checking whether x86 virtualization is enabled in BIOS
	# Проверка: включена ли в BIOS аппаратная виртуализация x86
	if ((Get-CimInstance -ClassName CIM_Processor).VirtualizationFirmwareEnabled -eq $true)
	{
		Enable-WindowsOptionalFeature -FeatureName Containers-DisposableClientVM -All -Online -NoRestart
	}
	else
	{
		try
		{
			# Checking whether Hyper-V is enabled
			# Проверка: включен ли Hyper-V
			if ((Get-CimInstance -ClassName CIM_ComputerSystem).HypervisorPresent -eq $true)
			{
				Enable-WindowsOptionalFeature -FeatureName Containers-DisposableClientVM -All -Online -NoRestart
			}
		}
		catch [Exception]
		{
			if ($RU)
			{
				Write-Error -Message "Включите в BIOS виртуализацию" -ErrorAction SilentlyContinue
			}
			else
			{
				Write-Error -Message "Enable Virtualization in BIOS" -ErrorAction SilentlyContinue
			}
		}
	}
}

# Set location of the user folders to %SystemDrive%
# Установить расположение пользовательских папок на %SystemDrive%
function KnownFolderPath
{
	Param (
		[Parameter(Mandatory = $true)]
		[ValidateSet("Desktop", "Documents", "Downloads", "Music", "Pictures", "Videos")]
		[string]$KnownFolder,

		[Parameter(Mandatory = $true)]
		[string]$Path
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
$drives = (Get-Disk | Where-Object -FilterScript {$_.BusType -ne "USB"} | Get-Partition | Get-Volume).DriveLetter
if ($RU)
{
	$OFS = ", "
	Write-Host "`nВаши диски: " -NoNewline
	Write-Host "$($drives | Sort-Object -Unique)" -ForegroundColor Yellow
	$OFS = " "
}
else
{
	$OFS = ", "
	Write-Host "`nYour drives: " -NoNewline
	Write-Host "$($drives | Sort-Object -Unique)" -ForegroundColor Yellow
	$OFS = " "
}
# Desktop
# Рабочий стол
if ($RU)
{
	Write-Host "`nВведите букву диска, в корне которого будет создана папка для " -NoNewline
	Write-Host "`"Рабочий стол`"" -ForegroundColor Yellow
	Write-Host "Файлы не будут перенесены: сделайте это вручную"
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nType the drive letter in the root of which the " -NoNewline
	Write-Host "`"Desktop`" " -ForegroundColor Yellow -NoNewline
	Write-Host "folder will be created."
	Write-Host "Files will not be moved. Do it manually"
	Write-Host "`nPress Enter to skip" -NoNewline
}
do
{
	$drive = Read-Host -Prompt " "
	if ($drives -eq $drive)
	{
		$drive = $(${drive}.ToUpper())
		$DesktopFolder = "${drive}:\Desktop"
		$DesktopReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Desktop
		if ($DesktopReg -ne $DesktopFolder)
		{
			if ((Get-ChildItem -Path $DesktopReg | Measure-Object).Count -ne 0)
			{
				if ($RU)
				{
					Write-Error -Message "В папке $DesktopReg осталась информация" -ErrorAction SilentlyContinue
				}
				else
				{
					Write-Error -Message "The $DesktopReg folder is not empty" -ErrorAction SilentlyContinue
				}
			}
			if (-not (Test-Path -Path $DesktopFolder))
			{
				New-Item -Path $DesktopFolder -ItemType Directory -Force
			}
			KnownFolderPath -KnownFolder Desktop -Path $DesktopFolder
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{754AC886-DF64-4CBA-86B5-F7FBF4FBCEF5}" -PropertyType ExpandString -Value $DesktopFolder -Force
			Set-Content -Path "$DesktopFolder\desktop.ini" -Value $DesktopINI["Desktop"] -Encoding Unicode -Force
			(Get-Item -Path "$DesktopFolder\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$DesktopFolder\desktop.ini" -Force).Refresh()
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

	}
	elseif ([string]::IsNullOrEmpty($drive))
	{
		break
	}
	else
	{
		if ($RU)
		{
			Write-Host "`nДиск $(${drive}.ToUpper()): не существует. " -ForegroundColor Yellow -NoNewline
			Write-Host "Введите букву диска."
			Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
		}
		else
		{
			Write-Host "The disk $(${drive}.ToUpper()): does not exist. " -ForegroundColor Yellow -NoNewline
			Write-Host "Type the drive letter."
			Write-Host "`nPress Enter to skip" -NoNewline
		}
	}
}
until ($drives -eq $drive)
# Documents
# Документы
if ($RU)
{
	Write-Host "`nВведите букву диска, в корне которого будет создана папка для " -NoNewline
	Write-Host "`"Документы`"" -ForegroundColor Yellow
	Write-Host "Файлы не будут перенесены: сделайте это вручную"
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nType the drive letter in the root of which the " -NoNewline
	Write-Host "`"Documents`" " -ForegroundColor Yellow -NoNewline
	Write-Host "folder will be created."
	Write-Host "Files will not be moved. Do it manually"
	Write-Host "`nPress Enter to skip" -NoNewline
}
do
{
	$drive = Read-Host -Prompt " "
	if ($drives -eq $drive)
	{
		$drive = $(${drive}.ToUpper())
		$DocumentsFolder = "${drive}:\Documents"
		$DocumentsReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Personal
		if ($DocumentsReg -ne $DocumentsFolder)
		{
			if ((Get-ChildItem -Path $DocumentsReg | Measure-Object).Count -ne 0)
			{
				if ($RU)
				{
					Write-Error -Message "В папке $DocumentsReg осталась информация" -ErrorAction SilentlyContinue
				}
				else
				{
					Write-Error -Message "The $DocumentsReg folder is not empty" -ErrorAction SilentlyContinue
				}
			}
			if (-not (Test-Path -Path $DocumentsFolder))
			{
				New-Item -Path $DocumentsFolder -ItemType Directory -Force
			}
			KnownFolderPath -KnownFolder Documents -Path $DocumentsFolder
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{F42EE2D3-909F-4907-8871-4C22FC0BF756}" -PropertyType ExpandString -Value $DocumentsFolder -Force
			Set-Content -Path "$DocumentsFolder\desktop.ini" -Value $DesktopINI["Documents"] -Encoding Unicode -Force
			(Get-Item -Path "$DocumentsFolder\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$DocumentsFolder\desktop.ini" -Force).Refresh()
		}
	}
	elseif ([string]::IsNullOrEmpty($drive))
	{
		break
	}
	else
	{
		if ($RU)
		{
			Write-Host "`nДиск $(${drive}.ToUpper()): не существует. " -ForegroundColor Yellow -NoNewline
			Write-Host "Введите букву диска."
			Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
		}
		else
		{
			Write-Host "The disk $(${drive}.ToUpper()): does not exist. " -ForegroundColor Yellow -NoNewline
			Write-Host "Type the drive letter."
			Write-Host "`nPress Enter to skip" -NoNewline
		}
	}
}
until ($drives -eq $drive)
# Downloads
# Загрузки
if ($RU)
{
	Write-Host "`nВведите букву диска, в корне которого будет создана папка для " -NoNewline
	Write-Host "`"Загрузки`"" -ForegroundColor Yellow
	Write-Host "Файлы не будут перенесены: сделайте это вручную"
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nType the drive letter in the root of which the " -NoNewline
	Write-Host "`"Downloads`" " -ForegroundColor Yellow -NoNewline
	Write-Host "folder will be created."
	Write-Host "Files will not be moved. Do it manually"
	Write-Host "`nPress Enter to skip" -NoNewline
}
do
{
	$drive = Read-Host -Prompt " "
	if ($drives -eq $drive)
	{
		$drive = $(${drive}.ToUpper())
		$DownloadsFolder = "${drive}:\Downloads"
		$DownloadsReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
		if ($DownloadsReg -ne $DownloadsFolder)
		{
			if ((Get-ChildItem -Path $DownloadsReg | Measure-Object).Count -ne 0)
			{
				if ($RU)
				{
					Write-Error -Message "В папке $DownloadsReg осталась информация" -ErrorAction SilentlyContinue
				}
				else
				{
					Write-Error -Message "The $DownloadsReg folder is not empty" -ErrorAction SilentlyContinue
				}
			}
			if (-not (Test-Path -Path $DownloadsFolder))
			{
				New-Item -Path $DownloadsFolder -ItemType Directory -Force
			}
			KnownFolderPath -KnownFolder Downloads -Path $DownloadsFolder
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}" -PropertyType ExpandString -Value $DownloadsFolder -Force
			Set-Content -Path "$DownloadsFolder\desktop.ini" -Value $DesktopINI["Downloads"] -Encoding Unicode -Force
			(Get-Item -Path "$DownloadsFolder\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$DownloadsFolder\desktop.ini" -Force).Refresh()

			# Microsoft Edge downloads folder
			# Папка загрузок Microsoft Edge
			$edge = (Get-AppxPackage -Name Microsoft.MicrosoftEdge).PackageFamilyName
			New-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\Main" -Name "Default Download Directory" -PropertyType String -Value $DownloadsFolder -Force
		}
	}
	elseif ([string]::IsNullOrEmpty($drive))
	{
		break
	}
	else
	{
		if ($RU)
		{
			Write-Host "`nДиск $(${drive}.ToUpper()): не существует. " -ForegroundColor Yellow -NoNewline
			Write-Host "Введите букву диска."
			Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
		}
		else
		{
			Write-Host "The disk $(${drive}.ToUpper()): does not exist. " -ForegroundColor Yellow -NoNewline
			Write-Host "Type the drive letter."
			Write-Host "`nPress Enter to skip" -NoNewline
		}
	}
}
until ($drives -eq $drive)
# Music
# Музыка
if ($RU)
{
	Write-Host "`nВведите букву диска, в корне которого будет создана папка для " -NoNewline
	Write-Host "`"Музыка`"" -ForegroundColor Yellow
	Write-Host "Файлы не будут перенесены: сделайте это вручную"
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nType the drive letter in the root of which the " -NoNewline
	Write-Host "`"Music`" " -ForegroundColor Yellow -NoNewline
	Write-Host "folder will be created."
	Write-Host "Files will not be moved. Do it manually"
	Write-Host "`nPress Enter to skip" -NoNewline
}
do
{
	$drive = Read-Host -Prompt " "
	if ($drives -eq $drive)
	{
		$drive = $(${drive}.ToUpper())
		$MusicFolder = "${drive}:\Music"
		$MusicReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Music"
		if ($MusicReg -ne $MusicFolder)
		{
			if ((Get-ChildItem -Path $MusicReg | Measure-Object).Count -ne 0)
			{
				if ($RU)
				{
					Write-Error -Message "В папке $MusicReg осталась информация" -ErrorAction SilentlyContinue
				}
				else
				{
					Write-Error -Message "The $MusicReg folder is not empty" -ErrorAction SilentlyContinue
				}
			}
			if (-not (Test-Path -Path $MusicFolder))
			{
				New-Item -Path $MusicFolder -ItemType Directory -Force
			}
			KnownFolderPath -KnownFolder Music -Path $MusicFolder
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{A0C69A99-21C8-4671-8703-7934162FCF1D}" -PropertyType ExpandString -Value $MusicFolder -Force
			Set-Content -Path "$MusicFolder\desktop.ini" -Value $DesktopINI["Music"] -Encoding Unicode -Force
			(Get-Item -Path "$MusicFolder\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$MusicFolder\desktop.ini" -Force).Refresh()
		}
	}
	elseif ([string]::IsNullOrEmpty($drive))
	{
		break
	}
	else
	{
		if ($RU)
		{
			Write-Host "`nДиск $(${drive}.ToUpper()): не существует. " -ForegroundColor Yellow -NoNewline
			Write-Host "Введите букву диска."
			Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
		}
		else
		{
			Write-Host "The disk $(${drive}.ToUpper()): does not exist. " -ForegroundColor Yellow -NoNewline
			Write-Host "Type the drive letter."
			Write-Host "`nPress Enter to skip" -NoNewline
		}
	}
}
until ($drives -eq $drive)
# Pictures
# Изображения
if ($RU)
{
	Write-Host "`nВведите букву диска, в корне которого будет создана папка для " -NoNewline
	Write-Host "`"Изображения`"" -ForegroundColor Yellow
	Write-Host "Файлы не будут перенесены: сделайте это вручную"
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nType the drive letter in the root of which the " -NoNewline
	Write-Host "`"Pictures`" " -ForegroundColor Yellow -NoNewline
	Write-Host "folder will be created."
	Write-Host "Files will not be moved. Do it manually"
	Write-Host "`nPress Enter to skip" -NoNewline
}
do
{
	$drive = Read-Host -Prompt " "
	if ($drives -eq $drive)
	{
		$drive = $(${drive}.ToUpper())
		$PicturesFolder = "${drive}:\Pictures"
		$PicturesReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Pictures"
		if ($PicturesReg -ne $PicturesFolder)
		{
			if ((Get-ChildItem -Path $PicturesReg | Measure-Object).Count -ne 0)
			{
				if ($RU)
				{
					Write-Error -Message "В папке $PicturesReg осталась информация" -ErrorAction SilentlyContinue
				}
				else
				{
					Write-Error -Message "The $PicturesReg folder is not empty" -ErrorAction SilentlyContinue
				}
			}
			if (-not (Test-Path -Path $PicturesFolder))
			{
				New-Item -Path $PicturesFolder -ItemType Directory -Force
			}
			KnownFolderPath -KnownFolder Pictures -Path $PicturesFolder
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{0DDD015D-B06C-45D5-8C4C-F59713854639}" -PropertyType ExpandString -Value $PicturesFolder -Force
			Set-Content -Path "$PicturesFolder\desktop.ini" -Value $DesktopINI["Pictures"] -Encoding Unicode -Force
			(Get-Item -Path "$PicturesFolder\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$PicturesFolder\desktop.ini" -Force).Refresh()
		}
	}
	elseif ([string]::IsNullOrEmpty($drive))
	{
		break
	}
	else
	{
		if ($RU)
		{
			Write-Host "`nДиск $(${drive}.ToUpper()): не существует. " -ForegroundColor Yellow -NoNewline
			Write-Host "Введите букву диска."
			Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
		}
		else
		{
			Write-Host "`nThe disk $(${drive}.ToUpper()): does not exist. " -ForegroundColor Yellow -NoNewline
			Write-Host "Type the drive letter."
			Write-Host "`nPress Enter to skip" -NoNewline
		}
	}
}
until ($drives -eq $drive)
# Videos
# Видео
if ($RU)
{
	Write-Host "`nВведите букву диска, в корне которого будет создана папка для " -NoNewline
	Write-Host "`"Видео`"" -ForegroundColor Yellow
	Write-Host "Файлы не будут перенесены: сделайте это вручную"
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nType the drive letter in the root of which the " -NoNewline
	Write-Host "`"Videos`" " -ForegroundColor Yellow -NoNewline
	Write-Host "folder will be created."
	Write-Host "Files will not be moved. Do it manually"
	Write-Host "`nPress Enter to skip" -NoNewline
}
do
{
	$drive = Read-Host -Prompt " "
	if ($drives -eq $drive)
	{
		$drive = $(${drive}.ToUpper())
		$VideosFolder = "${drive}:\Videos"
		$VideosReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Video"
		if ($VideosReg -ne $VideosFolder)
		{
			if ((Get-ChildItem -Path $VideosReg | Measure-Object).Count -ne 0)
			{
				if ($RU)
				{
					Write-Error -Message "В папке $VideosReg осталась информация" -ErrorAction SilentlyContinue
				}
				else
				{
					Write-Error -Message "The $PicturesReg folder is not empty" -ErrorAction SilentlyContinue
				}
			}
			if (-not (Test-Path -Path $VideosFolder))
			{
				New-Item -Path $VideosFolder -ItemType Directory -Force
			}
			KnownFolderPath -KnownFolder Videos -Path $VideosFolder
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{35286A68-3C57-41A1-BBB1-0EAE73D76C95}" -PropertyType ExpandString -Value $VideosFolder -Force
			Set-Content -Path "$VideosFolder\desktop.ini" -Value $DesktopINI["Videos"] -Encoding Unicode -Force
			(Get-Item -Path "$VideosFolder\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$VideosFolder\desktop.ini" -Force).Refresh()
		}
	}
	elseif ([string]::IsNullOrEmpty($drive))
	{
		break
	}
	else
	{
		if ($RU)
		{
			Write-Host "`nДиск $(${drive}.ToUpper()): не существует. " -ForegroundColor Yellow -NoNewline
			Write-Host "Введите букву диска."
			Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
		}
		else
		{
			Write-Host "`nThe disk $(${drive}.ToUpper()): does not exist. " -ForegroundColor Yellow -NoNewline
			Write-Host "Type the drive letter."
			Write-Host "`nPress Enter to skip" -NoNewline
		}
	}
}
until ($drives -eq $drive)

# Turn on automatic recommended troubleshooting and tell when problems get fixed
# Автоматически запускать средства устранения неполадок, а затем сообщать об устранении проблем
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
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager -Name PassedPolicy -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager -Name ShippedWithReserves -PropertyType DWord -Value 0 -Force
# Turn on automatic backup the system registry to the %SystemRoot%\System32\config\RegBack folder
# Включить автоматическое создание копии реестра в папку %SystemRoot%\System32\config\RegBack
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager" -Name EnablePeriodicBackup -PropertyType DWord -Value 1 -Force

# Turn off Help page opening by F1 key
# Отключить открытие справки по нажатию F1
if (-not (Test-Path -Path "HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64"))
{
	New-Item -Path "HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64" -Force
}
New-ItemProperty -Path "HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64" -Name "(default)" -PropertyType String -Value "" -Force

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


# Turn on network discovery and file and printers sharing if device is not domain-joined
# Включить сетевое обнаружение и общий доступ к файлам и принтерам, если устройство не присоединенно к домену
if ((Get-NetConnectionProfile).NetworkCategory -ne "DomainAuthenticated")
{
	Get-NetFirewallRule -Group "@FirewallAPI.dll,-32752", "@FirewallAPI.dll,-28502" | Set-NetFirewallRule -Profile Private -Enabled True
	Set-NetConnectionProfile -NetworkCategory Private
}
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

# Unpin all the Start menu tiles
# Открепить все ярлыки от начального экрана
if ($RU)
{
	Write-Host "`nЧтобы открепить все ярлыки от начального экрана, введите букву: " -NoNewline
	Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nTo unpin all the Start menu tiles type: " -NoNewline
	Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
	Write-Host "`nPress Enter to skip" -NoNewline
}
do
{
	$Unpin = Read-Host -Prompt " "
	if ([string]::IsNullOrEmpty($Unpin))
	{
		break
	}
	else
	{
		switch ($Unpin)
		{
			"Y"
			{
				$TileCollection = Get-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*start.tilegrid`$windows.data.curatedtilecollection.tilecollection\Current
				$Value = $TileCollection.Data[0..25] + ([byte[]](202,50,0,226,44,1,1,0,0))
				New-ItemProperty -Path $TileCollection.PSPath -Name Data -PropertyType Binary -Value $Value -Force
			}
			Default
			{
				if ($RU)
				{
					Write-Host "`nНеправильная буква." -ForegroundColor Yellow
					Write-Host "`nЧтобы открепить все ярлыки от начального экрана, введите букву: " -NoNewline
					Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
					Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
				}
				else
				{
					Write-Host "`nInvalid letter." -ForegroundColor Yellow
					Write-Host "`nTo unpin all the Start menu tiles type: " -NoNewline
					Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
					Write-Host "`nPress Enter to skip" -NoNewline
				}
			}
		}
	}
}
until ($Unpin -eq "Y")
# Restart Start menu
# Перезапустить меню "Пуск"
Stop-Process -Name StartMenuExperienceHost -Force

# Pin the shortcuts to Start
# Закрепить ярлыки на начальном экране
# Download syspin.exe to the "Downloads" folder
# Скачать syspin.exe в папку "Загрузки"
# http://www.technosys.net/products/utils/pintotaskbar
# SHA256: 6967E7A3C2251812DD6B3FA0265FB7B61AADC568F562A98C50C345908C6E827
if (Test-Connection -ComputerName google.com -Quiet)
{
	$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	$param = @{
		Uri = "https://github.com/farag2/Windows-10-Setup-Script/raw/master/Start%20menu%20pinning/syspin.exe"
		OutFile = "$DownloadsFolder\syspin.exe"
		Verbose = [switch]::Present
	}
	Invoke-WebRequest @param
}
else
{
	if ($RU)
	{
		Write-Warning "Отсутствует интернет-соединение" -ErrorAction SilentlyContinue
	}
	else
	{
		Write-Warning "No Internet connection" -ErrorAction SilentlyContinue
	}
}
Add-Type -AssemblyName System.Windows.Forms
$OpenFileDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
$OpenFileDialog.InitialDirectory = $DownloadsFolder
$OpenFileDialog.Multiselect = $false
if ($RU)
{
	$OpenFileDialog.Filter = "*.exe|*.exe|Все файлы (*.*)|*.*"
}
else
{
	$OpenFileDialog.Filter = "*.exe|*.exe|All Files (*.*)|*.*"
}
# Focus on open file dialog
# Перевести фокус на диалог открытия файла
$tmp = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
$OpenFileDialog.ShowDialog($tmp)
if ($OpenFileDialog.FileName)
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
		Start-Process -FilePath $OpenFileDialog.FileName -WindowStyle Hidden -ArgumentList $Arguments -Wait
	}
	else
	{
		# The "Pin" verb is not available on the control.exe file so the shortcut has to be created
		# Глагол "Закрепить на начальном экране" недоступен для control.exe, поэтому необходимо создать ярлык
		$shell = New-Object -ComObject Wscript.Shell
		$shortcut = $shell.CreateShortcut("$env:SystemRoot\System32\$ControlPanelLocalizedName.lnk")
		$Shortcut.TargetPath = "$env:SystemRoot\System32\control.exe"
		$Shortcut.Save()
		$Arguments = @"
			"$env:SystemRoot\System32\$ControlPanelLocalizedName.lnk" "51201"
"@
		Start-Process -FilePath $OpenFileDialog.FileName -WindowStyle Hidden -ArgumentList $Arguments -Wait
		Remove-Item -Path "$env:SystemRoot\System32\$ControlPanelLocalizedName.lnk" -Force
	}
	# Pin "Devices and Printers" to Start
	# Create old style shortcut for the "Devices and Printers" in the Start menu
	# Закрепить "Устройства и принтеры" на начальном экране
	# Создать ярлык старого формата для "Устройства и принтеры" в меню "Пуск"
	$DevicesAndPrintersLocalizedName = (Get-ControlPanelItem | Where-Object -FilterScript {$_.CanonicalName -eq "Microsoft.DevicesAndPrinters"}).Name
	if ($RU)
	{
		Write-Verbose -Message "Ярлык `"$DevicesAndPrintersLocalizedName`" закрепляется на начальном экране" -Verbose
	}
	else
	{
		Write-Verbose -Message "`"$DevicesAndPrintersLocalizedName`" shortcut is being pinned to Start" -Verbose
	}
	$shell = New-Object -ComObject Wscript.Shell
	$shortcut = $shell.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\$DevicesAndPrintersLocalizedName.lnk")
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
	Start-Process -FilePath $OpenFileDialog.FileName -WindowStyle Hidden -ArgumentList $Arguments -Wait
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
	Start-Process -FilePath $OpenFileDialog.FileName -WindowStyle Hidden -ArgumentList $Arguments -Wait
}
# Delete downloaded syspin.exe
# Удалить скачанный syspin.exe
Remove-Item -Path "$DownloadsFolder\syspin.exe" -Force
# Restart the Start menu
# Перезапустить меню "Пуск"
Stop-Process -Name StartMenuExperienceHost -Force
#endregion Start menu

#region Edge
# Do not allow Microsoft Edge to start and load the Start and New Tab page at Windows startup and each time Microsoft Edge is closed
# Не разрешать Edge запускать и загружать страницу при загрузке Windows и каждый раз при закрытии Edge
if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader -Name AllowTabPreloading -PropertyType DWord -Value 0 -Force

# Do not allow Microsoft Edge to pre-launch at Windows startup, when the system is idle, and each time Microsoft Edge is closed
# Не разрешать предварительный запуск Edge при загрузке Windows, когда система простаивает, и каждый раз при закрытии Edge
if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main -Name AllowPrelaunch -PropertyType DWord -Value 0 -Force

# Turn off creation of an Edge shortcut on the desktop for each user profile
# Отключить создание ярлыка Edge на рабочем столе для каждого профиля пользователя пользователя
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name DisableEdgeDesktopShortcutCreation -PropertyType DWord -Value 1 -Force
#endregion Edge

#region UWP apps
<#
Uninstall all UWP apps from all accounts
GUI with the ability to select the package to remove
App packages will not be installed when new user accounts are created
Add UWP apps packages names to the $UnchekedAppXPackages array list by retrieving their packages names with (Get-AppxPackage -PackageTypeFilter Bundle -AllUsers).Name command

Удалить все UWP-приложения из всех учетных записей
GUI с возможностью выбрать пакет для удаления
Приложения не будут установлены при создании новых учетных записей
Добавьте имена пакетов UWP-приложений в массив $UnchekedAppXPackages, получив их имена пакетов с помощью команды (Get-AppxPackage -PackageTypeFilter Bundle -AllUsers).Name
#>
Add-Type -AssemblyName PresentationCore, PresentationFramework

#region Variables
# UWP-apps array list to remove
# Массив имен UWP-приложений для удаления
$AppxPackages = New-Object System.Collections.ArrayList($null)

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
#endregion Variables

#region XAML Markup
[xml]$XAML = '
<Window
	xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
	xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
	Name="Window" Title="Packages to uninstall"
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
		<Button Name="Button" Grid.Row="1" Content="Uninstall"/>
	</Grid>
</Window>
'
#endregion XAML Markup

$Reader = (New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $XAML)
$GUI = [Windows.Markup.XamlReader]::Load($Reader)
$XAML.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object -Process {
	Set-Variable -Name ($_.Name) -Value $GUI.FindName($_.Name) -Scope Global
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
	Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object -FilterScript {$_.Name -cmatch $AppxPackages} | Remove-AppxPackage -AllUsers -Verbose
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
		[string]$AppxName
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
	$OFS = "|"
	(Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object -FilterScript {$_.Name -cnotmatch $ExcludedAppxPackages}).Name | ForEach-Object -Process {
		Add-AppxControl -AppxName $_
	}
	$OFS = " "
})

# Button Click Event
$Button.Add_Click({DeleteButton})
#endregion Events Handlers

if ($RU)
{
	Write-Verbose -Message "GUI открывается..." -Verbose
}
else
{
	Write-Verbose "GUI opening..." -Verbose
}
$GUI.ShowDialog() | Out-Null

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

# Check for UWP apps updates
# Проверить обновления UWP-приложений
Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod
#endregion UWP apps

#region Gaming
# Turn off Game bar
# Отключить Меню игры
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR -Name AppCaptureEnabled -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKCU:\System\GameConfigStore -Name GameDVR_Enabled -PropertyType DWord -Value 0 -Force

# Turn off Xbox Game Bar tips
# Отключить советы Xbox Game Bar
New-ItemProperty -Path HKCU:\Software\Microsoft\GameBar -Name ShowStartupPanel -PropertyType DWord -Value 0 -Force

<#
Uninstall all Xbox related UWP apps from all accounts
App packages will not be installed when new user accounts are created

Удалить все UWP-приложения, связанные с Xbox, из всех учетных записей
Приложения не будут установлены при создании новых учетных записей
#>
$XboxAppxPackages = @(
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
)
$OFS = "|"
Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object -FilterScript {$_.Name -cmatch $XboxAppxPackages} | Remove-AppxPackage -AllUsers -Verbose
$OFS = " "

# Set "High performance" in graphics performance preference for apps
# Установить параметры производительности графики для отдельных приложений на "Высокая производительность"
if (Get-CimInstance -ClassName Win32_VideoController | Where-Object -FilterScript {$_.AdapterDACType -ne "Internal" -and $null -ne $_.AdapterDACType})
{
	do
	{
		if ($RU)
		{
			Write-Host "`nЧтобы добавить приложение, для которого будет установлена настройка производительности графики"
			Write-Host "на `"Высокая производительность`", введите букву: "
			Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
			Write-Host " или " -NoNewline
			Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
			Write-Host ", чтобы пропустить" -NoNewline
			Write-Host "`nТакже, чтобы пропустить, нажмите Enter" -NoNewline
		}
		else
		{
			Write-Host "`nTo add an app for which the graphics performance preference"
			Write-Host "will be set to `"High performance`" type: "
			Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
			Write-Host " or " -NoNewline
			Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
			Write-Host " to skip" -NoNewline
			Write-Host "`nAlso press Enter to skip" -NoNewline
		}
		$Prompt = Read-Host -Prompt " "
		if ([string]::IsNullOrEmpty($Prompt))
		{
			break
		}
		else
		{
			switch ($Prompt)
			{
				"Y"
				{
					if (-not (Test-Path -Path HKCU:\Software\Microsoft\DirectX\UserGpuPreferences))
					{
						New-Item -Path HKCU:\Software\Microsoft\DirectX\UserGpuPreferences -Force
					}
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
					$OpenFileDialog.InitialDirectory = "$env:ProgramFiles}"
					$OpenFileDialog.Multiselect = $false
					# Focus on open file dialog
					# Перевести фокус на диалог открытия файла
					$tmp = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
					$OpenFileDialog.ShowDialog($tmp)
					if ($OpenFileDialog.FileName)
					{
						New-ItemProperty -Path HKCU:\Software\Microsoft\DirectX\UserGpuPreferences -Name $OpenFileDialog.FileName -PropertyType String -Value "GpuPreference=2;" -Force
					}
				}
				"N" {}
				Default
				{
					if ($RU)
					{
						Write-Host "`nНеправильная буква." -ForegroundColor Yellow
						Write-Host "`nЧтобы добавить приложение, для которого будет установлена настройка производительности графики"
						Write-Host "на `"Высокая производительность`", введите букву: "
						Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
						Write-Host " или " -NoNewline
						Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
						Write-Host ", чтобы пропустить" -NoNewline
						Write-Host "`nТакже, чтобы пропустить, нажмите Enter" -NoNewline
					}
					else
					{
						Write-Host "`nInvalid letter." -ForegroundColor Yellow
						Write-Host "`nTo add an app for which the graphics performance preference"
						Write-Host "will be set to `"High performance`" type: "
						Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
						Write-Host " or " -NoNewline
						Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
						Write-Host " to skip" -NoNewline
						Write-Host "`nAlso press Enter to skip" -NoNewline
					}
				}
			}
		}
	}
	while ($Prompt -ne "N")
}
#endregion Gaming

#region Scheduled tasks
# Create a task in the Task Scheduler to start Windows cleaning up
# The task runs every 90 days
# Создать задачу в Планировщике задач по очистке обновлений Windows
# Задача выполняется каждые 90 дней
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
	# Windows Update Cleanup
	# Очистка обновлений Windows
	"Update Cleanup",
	# Windows Defender Antivirus
	"Windows Defender",
	# Windows upgrade log files
	# Файлы журнала обновления Windows
	"Windows Upgrade Log Files"
)
foreach ($VolumeCache in $VolumeCaches)
{
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$VolumeCache" -Name StateFlags1337 -PropertyType DWord -Value 2 -Force
}
$action = New-ScheduledTaskAction -Execute "cleanmgr.exe" -Argument "/sagerun:1337"
$trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 90 -At 9am
$settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
$params = @{
	"TaskName"	=	"Update Cleanup"
	"Action"	=	$action
	"Trigger"	=	$trigger
	"Settings"	=	$settings
	"Principal"	=	$principal
}
Register-ScheduledTask @params -Force

# Create a task in the Task Scheduler to clear the %SystemRoot%\SoftwareDistribution\Download folder
# The task runs on Thursdays every 4 weeks
# Создать задачу в Планировщике задач по очистке папки %SystemRoot%\SoftwareDistribution\Download
# Задача выполняется по четвергам каждую 4 неделю
$action = New-ScheduledTaskAction -Execute powershell.exe -Argument @"
	`$getservice = Get-Service -Name wuauserv
	`$getservice.WaitForStatus('Stopped', '01:00:00')
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

# Create a task in the Task Scheduler to clear the %TEMP% folder
# The task runs every 62 days
# Создать задачу в Планировщике задач по очистке папки %TEMP%
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
#endregion Scheduled tasks

#region Windows Defender & Security
# Turn on Controlled folder access and add protected folders
# Включить контролируемый доступ к папкам и добавить защищенные папки
do
{
	if ($RU)
	{
		Write-Host "`nЧтобы включить контролируемый доступ к папкам"
		Write-Host "и добавить папки в список защищенных, введите букву: "
		Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
		Write-Host " или " -NoNewline
		Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
		Write-Host ", чтобы пропустить" -NoNewline
		Write-Host "`nТакже, чтобы пропустить, нажмите Enter" -NoNewline
	}
	else
	{
		Write-Host "`nTo turn on Controlled folder access and add protected folders type:"
		Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
		Write-Host " or " -NoNewline
		Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
		Write-Host " to skip" -NoNewline
		Write-Host "`nAlso press Enter to skip" -NoNewline
	}
	$Prompt = Read-Host -Prompt " "
	if ([string]::IsNullOrEmpty($Prompt))
	{
		break
	}
	else
	{
		switch ($Prompt)
		{
			"Y"
			{
				Add-Type -AssemblyName System.Windows.Forms
				$OpenFileDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
				if ($RU)
				{
					$OpenFileDialog.Description = "Выберите папку"
				}
				else
				{
					$OpenFileDialog.Description = "Select a folder"
				}
				$OpenFileDialog.RootFolder = "MyComputer"
				# Focus on open file dialog
				# Перевести фокус на диалог открытия файла
				$tmp = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
				$OpenFileDialog.ShowDialog($tmp)
				if ($OpenFileDialog.SelectedPath)
				{
					Set-MpPreference -EnableControlledFolderAccess Enabled
					Add-MpPreference -ControlledFolderAccessProtectedFolders $OpenFileDialog.SelectedPath -Force
				}
			}
			"N" {}
			Default
			{
				if ($RU)
				{
					Write-Host "`nНеправильная буква." -ForegroundColor Yellow
					Write-Host "Чтобы включить контролируемый доступ к папкам"
					Write-Host "и добавить папки в список защищенных, введите букву: "
					Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
					Write-Host " или " -NoNewline
					Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
					Write-Host ", чтобы пропустить" -NoNewline
					Write-Host "`nТакже, чтобы пропустить, нажмите Enter" -NoNewline
				}
				else
				{
					Write-Host "`nInvalid letter." -ForegroundColor Yellow
					Write-Host "To turn on Controlled folder access and add protected folders type:"
					Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
					Write-Host " or " -NoNewline
					Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
					Write-Host " to skip" -NoNewline
					Write-Host "`nAlso press Enter to skip" -NoNewline
				}
			}
		}
	}
}
while ($Prompt -ne "N")

# Allow an app through Controlled folder access
# Разрешить работу приложения через контролируемый доступ к папкам
if ((Get-MpPreference).EnableControlledFolderAccess -eq 1)
{
	do
	{
		if ($RU)
		{
			Write-Host "`nЧтобы разрешить работу приложения"
			Write-Host "через контролируемый доступ к папкам, введите букву: "
			Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
			Write-Host " или " -NoNewline
			Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
			Write-Host ", чтобы пропустить" -NoNewline
			Write-Host "`nТакже, чтобы пропустить, нажмите Enter" -NoNewline
		}
		else
		{
			Write-Host "`nTo allow an app through Controlled folder access type:"
			Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
			Write-Host " or " -NoNewline
			Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
			Write-Host " to skip" -NoNewline
			Write-Host "`nAlso press Enter to skip" -NoNewline
		}
		$Prompt = Read-Host -Prompt " "
		if ([string]::IsNullOrEmpty($Prompt))
		{
			break
		}
		else
		{
			switch ($Prompt)
			{
				"Y"
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
				"N" {}
				Default
				{
					if ($RU)
					{
						Write-Host "`nНеправильная буква." -ForegroundColor Yellow
						Write-Host "`nЧтобы разрешить работу приложения"
						Write-Host "через контролируемый доступ к папкам, введите букву: "
						Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
						Write-Host " или " -NoNewline
						Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
						Write-Host ", чтобы пропустить" -NoNewline
						Write-Host "`nТакже, чтобы пропустить, нажмите Enter" -NoNewline
					}
					else
					{
						Write-Host "`nTo allow an app through Controlled folder access type:"
						Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
						Write-Host " or " -NoNewline
						Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
						Write-Host " to skip" -NoNewline
						Write-Host "`nAlso press Enter to skip" -NoNewline
					}
				}
			}
		}
	}
	while ($Prompt -ne "N")
}

# Add exclusion folder from Windows Defender Antivirus scanning
# Добавить папку в список исключений сканирования Windows Defender
do
{
	if ($RU)
	{
		Write-Host "`nЧтобы исключить папку из списка сканирования"
		Write-Host "антивредоносной программы Windows Defender, введите букву: "
		Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
		Write-Host " или " -NoNewline
		Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
		Write-Host ", чтобы пропустить" -NoNewline
		Write-Host "`nТакже, чтобы пропустить, нажмите Enter" -NoNewline
	}
	else
	{
		Write-Host "`nTo exclude folders from Windows Defender Antivirus Scan type: "
		Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
		Write-Host " or " -NoNewline
		Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
		Write-Host " to skip" -NoNewline
		Write-Host "`nAlso press Enter to skip" -NoNewline
	}
	$Prompt = Read-Host -Prompt " "
	if ([string]::IsNullOrEmpty($Prompt))
	{
		break
	}
	else
	{
		switch ($Prompt)
		{
			"Y"
			{
				Add-Type -AssemblyName System.Windows.Forms
				$OpenFileDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
				if ($RU)
				{
					$OpenFileDialog.Description = "Выберите папку"
				}
				else
				{
					$OpenFileDialog.Description = "Select a folder"
				}
				$OpenFileDialog.RootFolder = "MyComputer"
				# Focus on open file dialog
				# Перевести фокус на диалог открытия файла
				$tmp = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
				$OpenFileDialog.ShowDialog($tmp)
				if ($OpenFileDialog.SelectedPath)
				{
					Add-MpPreference -ExclusionPath $OpenFileDialog.SelectedPath -Force
				}
			}
			"N" {}
			Default
			{
				if ($RU)
				{
					Write-Host "`nНеправильная буква." -ForegroundColor Yellow
					Write-Host "`nЧтобы исключить папку из списка сканирования"
					Write-Host "антивредоносной программы Windows Defender, введите букву: "
					Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
					Write-Host " или " -NoNewline
					Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
					Write-Host ", чтобы пропустить" -NoNewline
					Write-Host "`nТакже, чтобы пропустить, нажмите Enter" -NoNewline
				}
				else
				{
					Write-Host "`nInvalid letter." -ForegroundColor Yellow
					Write-Host "`nTo exclude folders from Windows Defender Antivirus Scan type: "
					Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
					Write-Host " or " -NoNewline
					Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
					Write-Host " to skip" -NoNewline
					Write-Host "`nAlso press Enter to skip" -NoNewline
				}
			}
		}
	}
}
while ($Prompt -ne "N")

# Add exclusion file from Windows Defender Antivirus scanning
# Добавить файл в список исключений сканирования Windows Defender
do
{
	if ($RU)
	{
		Write-Host "`nЧтобы исключить файл из списка сканирования"
		Write-Host "антивредоносной программы Windows Defender, введите букву: "
		Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
		Write-Host " или " -NoNewline
		Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
		Write-Host ", чтобы пропустить" -NoNewline
		Write-Host "`nТакже, чтобы пропустить, нажмите Enter" -NoNewline
	}
	else
	{
		Write-Host "`nTo exclude file from Windows Defender Antivirus Scan type: "
		Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
		Write-Host " or " -NoNewline
		Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
		Write-Host " to skip" -NoNewline
		Write-Host "`nAlso press Enter to skip" -NoNewline
	}
	$Prompt = Read-Host -Prompt " "
	if ([string]::IsNullOrEmpty($Prompt))
	{
		break
	}
	else
	{
		switch ($Prompt)
		{
			"Y"
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
					Add-MpPreference -ExclusionPath $OpenFileDialog.FileName -Force
				}
			}
			"N" {}
			Default
			{
				if ($RU)
				{
					Write-Host "`nНеправильная буква." -ForegroundColor Yellow
					Write-Host "`nЧтобы исключить файл из списка сканирования"
					Write-Host "антивредоносной программы Windows Defender, введите букву: "
					Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
					Write-Host " или " -NoNewline
					Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
					Write-Host ", чтобы пропустить" -NoNewline
					Write-Host "`nТакже, чтобы пропустить, нажмите Enter" -NoNewline
				}
				else
				{
					Write-Host "`nInvalid letter." -ForegroundColor Yellow
					Write-Host "`nTo exclude file from Windows Defender Antivirus Scan type: "
					Write-Host "[Y]es" -ForegroundColor Yellow -NoNewline
					Write-Host " or " -NoNewline
					Write-Host "[N]o" -ForegroundColor Yellow -NoNewline
					Write-Host " to skip" -NoNewline
					Write-Host "`nAlso press Enter to skip" -NoNewline
				}
			}
		}
	}
}
while ($Prompt -ne "N")

# Turn on Windows Defender Exploit Guard network protection
# Включить защиту сети в Windows Defender
Set-MpPreference -EnableNetworkProtection Enabled

# Turn on detection for potentially unwanted applications
# Включить обнаружение потенциально нежелательных приложений
Set-MpPreference -PUAProtection Enabled

# Run Windows Defender within a sandbox
# Запускать Windows Defender в песочнице
setx /M MP_FORCE_USE_SANDBOX 1

# Dismiss Windows Defender offer in the Windows Security about signing in Microsoft account
# Отклонить предложение Windows Defender в "Безопасность Windows" о входе в аккаунт Microsoft
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows Security Health\State" -Name AccountProtection_MicrosoftAccount_Disconnected -PropertyType DWord -Value 1 -Force

# Dismiss Windows Defender offer in the Windows Security about to turn on the SmartScreen filter for Microsoft Edge
# Отклонить предложение Microsoft Defender в "Безопасность Windows" включить фильтр SmartScreen для Microsoft Edge
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows Security Health\State" -Name AppAndBrowser_EdgeSmartScreenOff -PropertyType DWord -Value 0 -Force

# Turn on events auditing generated when a process is created or starts
# Включить аудит событий, возникающих при создании или запуске процесса
auditpol /set /subcategory:"{0CCE922B-69AE-11D9-BED3-505054503030}" /success:enable /failure:enable

# Include command line in process creation events
# Включать командную строку в событиях создания процесса
$ProcessCreation = auditpol /get /subcategory:"{0CCE922B-69AE-11D9-BED3-505054503030}" /r | ConvertFrom-Csv | Select-Object "Inclusion Setting"
if ($ProcessCreation."Inclusion Setting" -ne "No Auditing")
{
	New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit -Name ProcessCreationIncludeCmdLine_Enabled -PropertyType DWord -Value 1 -Force
}

# Turn on logging for all Windows PowerShell modules
# Включить ведение журнала для всех модулей Windows PowerShell
if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames -Name * -PropertyType String -Value * -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames -Name EnableModuleLogging -PropertyType DWord -Value 1 -Force

# Turn on logging of all PowerShell script input to the Microsoft-Windows-PowerShell/Operational event log
# Включить регистрацию всех вводимых сценариев PowerShell в журнале событий Microsoft-Windows-PowerShell/Operational
if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Name EnableScriptBlockLogging -PropertyType DWord -Value 1 -Force

# Turn off SmartScreen for apps and files
# Отключить SmartScreen для приложений и файлов
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name SmartScreenEnabled -PropertyType String -Value Off -Force

# Turn off Windows Defender SmartScreen for Microsoft Edge
# Отключить Windows Defender SmartScreen в Microsoft Edge
$edge = (Get-AppxPackage -Name Microsoft.MicrosoftEdge).PackageFamilyName
if (-not (Test-Path -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\PhishingFilter"))
{
	New-Item -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\PhishingFilter" -Force
}
New-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\PhishingFilter" -Name EnabledV9 -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\PhishingFilter" -Name PreventOverride -PropertyType DWord -Value 0 -Force

# Turn off Windows Script Host
# Отключить Windows Script Host
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Name Enabled -PropertyType DWord -Value 0 -Force
#endregion Windows Defender & Security

#region Context menu
# Add "Extract" item to Windows Installer (.msi) context menu
# Добавить пункт "Извлечь" в контекстное меню Windows Installer (.msi)
if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command))
{
	New-Item -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command -Force
}
$Value = "{0}" -f 'msiexec.exe /a "%1" /qb TARGETDIR="%1 extracted"'
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command -Name "(default)" -PropertyType String -Value $Value -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Name MUIVerb -PropertyType String -Value "@shell32.dll,-31382" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Name Icon -PropertyType String -Value "shell32.dll,-16817" -Force

# Add "Run as different user" item to the .exe files types context menu
# Добавить "Запуск от имени другого пользователя" в контекстное меню .exe файлов
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\exefile\shell\runasuser -Name "(default)" -PropertyType String -Value "@shell32.dll,-50944" -Force
Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\exefile\shell\runasuser -Name Extended -Force -ErrorAction Ignore
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\exefile\shell\runasuser -Name SuppressionPolicyEx -PropertyType String -Value "{F211AA05-D4DF-4370-A2A0-9F19C09756A7}" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\exefile\shell\runasuser\command -Name DelegateExecute -PropertyType String -Value "{ea72d00e-4960-42fa-ba92-7792a7944c1d}" -Force

# Add the "Install" item to the .cab archives context menu
# Добавить пункт "Установить" в контекстное меню .cab архивов
if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command))
{
	New-Item -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command -Force
}
$Value = "{0}" -f 'cmd /c DISM /Online /Add-Package /PackagePath:"%1" /NoRestart & pause'
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command -Name "(default)" -PropertyType String -Value $Value -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs -Name MUIVerb -PropertyType String -Value "@shell32.dll,-10210" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs -Name HasLUAShield -PropertyType String -Value "" -Force

# Hide "Cast to Device" item from the context menu
# Скрыть пункт "Передать на устройство" из контекстного меню
if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"))
{
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" -PropertyType String -Value "Play to menu" -Force

# Hide "Share" item from the context menu
# Скрыть пункт "Отправить" (поделиться) из контекстного меню
if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"))
{
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{E2BF9676-5F8F-435C-97EB-11607A5BEDF7}" -PropertyType String -Value "" -Force

# Hide "Edit with Paint 3D" item from the context menu
# Скрыть пункт "Изменить с помощью Paint 3D" из контекстного меню
$extensions = @(".bmp", ".gif", ".jpe", ".jpeg", ".jpg", ".png", ".tif", ".tiff")
foreach ($extension in $extensions)
{
	New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\$extension\Shell\3D Edit" -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
}

# Hide "Include in Library" item from the context menu
# Скрыть пункт "Добавить в библиотеку" из контекстного меню
New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Folder\shellex\ContextMenuHandlers\Library Location" -Name "(default)" -PropertyType String -Value "-{3dad6c5d-2167-4cae-9914-f99e41c12cfa}" -Force

# Remove "Turn on BitLocker" item from the context menu
# Удалить пункт "Включить BitLocker" из контекстного меню
if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -eq "Professional" -or $_.Edition -eq "Enterprise"})
{
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\encrypt-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\encrypt-bde-elev -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\manage-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\resume-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\resume-bde-elev -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\unlock-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
}

# Remove "Edit with Photos" item from the context menu
# Удалить пункт "Изменить с помощью приложения "Фотографии"" из контекстного меню
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellEdit -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force

# Remove "Create a new video" item from the context menu
# Удалить пункт "Создать новое видео" из контекстного меню
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellCreateVideo -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force

# Remove "Bitmap image" item from the "New" context menu
# Удалить пункт "Точечный рисунок" из контекстного меню "Создать"
Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.bmp\ShellNew -Force -ErrorAction Ignore

# Hide "Edit" item from the images context menu
# Скрыть пункт "Изменить" из контекстного меню изображений
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\edit -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force

# Remove "Print" item from the .bat and .cmd context menu
# Удалить пункт "Печать" из контекстного меню .bat и .cmd файлов
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\batfile\shell\print -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\cmdfile\shell\print -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force

# Remove "Compressed (zipped) Folder" from the "New" context menu
# Удалить пункт "Сжатая ZIP-папка" из контекстного меню "Создать"
Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew -Force -ErrorAction Ignore

# Remove "Rich Text Document" from the "New" context menu
# Удалить пункт "Документ в формате RTF" из контекстного меню "Создать"
Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.rtf\ShellNew -Force -ErrorAction Ignore

# Hide "Send to" item from the folders context menu
# Скрыть пункт "Отправить" из контекстного меню папок
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo -Name "(default)" -PropertyType String -Value "" -Force

# Make the "Open", "Print", "Edit" context menu items available, when more than 15 items selected
# Сделать доступными элементы контекстного меню "Открыть", "Изменить" и "Печать" при выделении более 15 элементов
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name MultipleInvokePromptMinimum -PropertyType DWord -Value 300 -Force

# Hide "Look for an app in the Microsoft Store" item in "Open with" dialog
# Скрыть пункт "Поиск приложения в Microsoft Store" в диалоге "Открыть с помощью"
if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name NoUseStoreOpenWith -PropertyType DWord -Value 1 -Force

# Hide "Previous Versions" tab from files and folders context menu and "Restore previous versions" context menu item
# Скрыть вкладку "Предыдущие версии" в свойствах файлов и папок и пункт контекстного меню "Восстановить прежнюю версию"
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name NoPreviousVersionsPage -PropertyType DWord -Value 1 -Force
#endregion Context menu

#region End
# Refresh desktop icons, environment variables, taskbar and send F5 pressing simulation to refresh the desktop
# Обновить иконки рабочего стола, переменные среды, панель задач и симулировать нажатие F5 для обновления рабочего стола
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
[WinAPI.UpdateExplorer]::Refresh()
[WinAPI.UpdateExplorer]::PostMessage()
# Restart the Start menu
# Перезапустить меню "Пуск"
Stop-Process -Name StartMenuExperienceHost -Force

# Errors output
# Вывод ошибок
if ($Error)
{
	if ($RU)
	{
		Write-Host "`nПредупреждения/ошибки" -ForegroundColor Red
	}
	else
	{
		Write-Host "`nWarnings/errors" -ForegroundColor Red
	}
	($Error | ForEach-Object -Process {
		[PSCustomObject] @{
			Line = $_.InvocationInfo.ScriptLineNumber
			"Errors/Warnings" = $_.Exception.Message
		}
	} | Sort-Object -Property Line | Format-Table -AutoSize -Wrap | Out-String).Trim()
}
else
{
	if ($RU)
	{
		Write-Host "`nНет предупреждений/ошибок" -ForegroundColor Green
	}
	else
	{
		Write-Host "`nNo warnings/errors" -ForegroundColor Green
	}
}
#endregion End