#Requires -RunAsAdministrator

#region Begin
# Remove all text from the current display
# Очистить экран
Clear-Host
# Сlear $Error variable
# Очистка переменной $Error
$Error.Clear()
# Get information about the current culture settings
# Получить сведения о параметрах текущей культуры
IF ($PSUICulture -eq "ru-RU")
{
	$RU = $true
}
# Set the encoding to UTF-8 without BOM for the PowerShell session
# Установить кодировку UTF-8 без BOM для текущей сессии PowerShell
IF ($RU)
{
	ping.exe | Out-Null
	$OutputEncoding = [System.Console]::OutputEncoding = [System.Console]::InputEncoding = [System.Text.Encoding]::UTF8
}
#endregion Begin

#region Privacy & Telemetry
# Turn off "Connected User Experiences and Telemetry" service
# Отключить службу "Функциональные возможности для подключенных пользователей и телеметрия"
Get-Service -Name DiagTrack | Stop-Service -Force
Get-Service -Name DiagTrack | Set-Service -StartupType Disabled
# Turn off per-user services
# Отключить пользовательские службы
$services = @(
	# Contact Data
	# Служба контактных данных
	"PimIndexMaintenanceSvc_*",
	# User Data Storage
	# Служба хранения данных пользователя
	"UnistoreSvc_*",
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
# Turn off the Autologger session at the next computer restart
# Отключить сборщик AutoLogger при следующем запуске ПК
Update-AutologgerConfig -Name AutoLogger-Diagtrack-Listener -Start 0
# Turn off the SQMLogger session at the next computer restart
# Отключить сборщик SQMLogger при следующем запуске ПК
Update-AutologgerConfig -Name SQMLogger -Start 0
# Set the operating system diagnostic data level to "Basic"
# Установить уровень отправляемых диагностических сведений на "Базовый"
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 1 -Force
# Turn off Windows Error Reporting
# Отключить отчеты об ошибках Windows для всех пользователей
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\Windows Error Reporting" -Name Disabled -PropertyType DWord -Value 1 -Force
# Change Windows Feedback frequency to "Never"
# Изменить частоту формирования отзывов на "Никогда"
IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Siuf\Rules))
{
	New-Item -Path HKCU:\Software\Microsoft\Siuf\Rules -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Siuf\Rules -Name NumberOfSIUFInPeriod -PropertyType DWord -Value 0 -Force
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
# Do not offer tailored experiences based on the diagnostic data setting
# Не предлагать персонализированныее возможности, основанные на выбранном параметре диагностических данных
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy -Name TailoredExperiencesWithDiagnosticDataEnabled -PropertyType DWord -Value 0 -Force
# Do not let apps on other devices open and message apps on this device, and vice versa
# Не разрешать приложениям на других устройствах запускать приложения и отправлять сообщения на этом устройстве и наоборот
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\CDP -Name RomeSdkChannelUserAuthzPolicy -PropertyType DWord -Value 0 -Force
# Do not allow apps to use advertising ID
# Не разрешать приложениям использовать идентификатор рекламы
New-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -PropertyType DWord -Value 0 -Force
# Do not use sign-in info to automatically finish setting up device after an update or restart
# Не использовать данные для входа для автоматического завершения настройки устройства после перезапуска или обновления
$sid = (Get-CimInstance -ClassName Win32_UserAccount | Where-Object -FilterScript {$_.Name -eq "$env:USERNAME"}).SID
IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$sid"))
{
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$sid" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$sid" -Name OptOut -PropertyType DWord -Value 1 -Force
# Do not let websites provide locally relevant content by accessing language list
# Не позволять веб-сайтам предоставлять местную информацию за счет доступа к списку языков
New-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name HttpAcceptLanguageOptOut -PropertyType DWord -Value 1 -Force
# Turn on tip, trick, and suggestions as you use Windows
# Показывать советы, подсказки и рекомендации при использованию Windows
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338389Enabled -PropertyType DWord -Value 1 -Force
# Do not show app suggestions on Start menu
# Не показывать рекомендации в меню "Пуск"
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338388Enabled -PropertyType DWord -Value 0 -Force
# Do not show suggested content in the Settings
# Не показывать рекомендуемое содержание в приложении "Параметры"
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338393Enabled -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-353694Enabled -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-353696Enabled -PropertyType DWord -Value 0 -Force
# Turn off automatic installing suggested apps
# Отключить автоматическую установку рекомендованных приложений
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SilentInstalledAppsEnabled -PropertyType DWord -Value 0 -Force
# Do not let track app launches to improve Start menu and search results
# Не разрешать Windows отслеживать запуски приложений для улучшения меню "Пуск" и результатов поиска и не показывать недавно добавленные приложения
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Start_TrackProgs -PropertyType DWord -Value 0 -Force
#endregion Privacy & Telemetry

#region UI & Personalization
# Show "This PC" on Desktop
# Отобразить "Этот компьютер" на рабочем столе
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -PropertyType DWord -Value 0 -Force
# Set File Explorer to open to This PC by default
# Открывать "Этот компьютер" в Проводнике
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -PropertyType DWord -Value 1 -Force
# Show Hidden Files, Folders, and Drives
# Показывать скрытые файлы, папки и диски
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -PropertyType DWord -Value 1 -Force
# Turn off check boxes to select items
# Отключить флажки для выбора элементов
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name AutoCheckSelect -PropertyType DWord -Value 0 -Force
# Show File Name Extensions
# Показывать расширения для зарегистрированных типов файлов
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -PropertyType DWord -Value 0 -Force
# Show folder merge conflicts
# Не скрывать конфликт слияния папок
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideMergeConflicts -PropertyType DWord -Value 0 -Force
# Show more details in file transfer dialog
# Развернуть диалог переноса файлов
IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Name EnthusiastMode -PropertyType DWord -Value 1 -Force
# Turn on ribbon in File Explorer
# Включить отображение ленты проводника в развернутом виде
IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Name MinimizedStateTabletModeOff -PropertyType DWord -Value 0 -Force
# Turn on recycle bin files delete confirmation
# Запрашивать подтверждение на удалении файлов из корзины
IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name ConfirmFileDelete -PropertyType DWord -Value 1 -Force
# Do not show all folders in the navigation pane
# Не отображать все папки в области навигации
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -PropertyType DWord -Value 0 -Force
# Remove 3D Objects folder in "This PC" and in the navigation pane
# Скрыть папку "Объемные объекты" из "Этот компьютер" и на панели быстрого доступа
IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"))
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
# Remove the "Previous Versions" tab from properties context menu
# Отключить отображение вкладки "Предыдущие версии" в свойствах файлов и папок
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name NoPreviousVersionsPage -PropertyType DWord -Value 1 -Force
# Hide search box or search icon on taskbar
# Скрыть поле или значок поиска на Панели задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -PropertyType DWord -Value 0 -Force
# Do not show Cortana button on taskbar
# Не показывать кнопку Cortana на панели задач
IF (-not $RU)
{
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCortanaButton -PropertyType DWord -Value 0 -Force
}
# Do not show Task View button on taskbar
# Не показывать кнопку Просмотра задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -PropertyType DWord -Value 0 -Force
# Do not show People button on the taskbar
# Не показывать панель "Люди" на панели задач
IF (-not (Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Name PeopleBand -PropertyType DWord -Value 0 -Force
# Do not show "Windows Ink Workspace" button in taskbar
# Не показывать кнопку Windows Ink Workspace на панели задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\PenWorkspace -Name PenWorkspaceButtonDesiredVisibility -PropertyType DWord -Value 0 -Force
# Show seconds on taskbar clock
# Отображать секунды в системных часах на панели задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSecondsInSystemClock -PropertyType DWord -Value 1 -Force
# Always show all icons in the notification area
# Всегда отображать все значки в области уведомлений
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray -PropertyType DWord -Value 0 -Force
# Turn on acrylic taskbar transparency
# Включить прозрачную панель задач
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name UseOLEDTaskbarTransparency -PropertyType DWord -Value 1 -Force
# Unpin Microsoft Edge and Microsoft Store from taskbar
# Открепить Microsoft Edge и Microsoft Store от панели задач
$Signature = @{
	Namespace = "WinAPI"
	Name = "GetStr"
	Language = "CSharp"
	MemberDefinition = @"
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
IF (-not ("WinAPI.GetStr" -as [type]))
{
	Add-Type @Signature -Using System.Text
}
$unpin = [WinAPI.GetStr]::GetString(5387)
$apps = (New-Object -ComObject Shell.Application).NameSpace("shell:::{4234d49b-0245-4df3-b780-3893943456e1}").Items()
$apps | Where-Object -FilterScript {$_.Path -like "Microsoft.MicrosoftEdge*"} | ForEach-Object -Process {$_.Verbs() | Where-Object -FilterScript {$_.Name -eq $unpin} | ForEach-Object -Process {$_.DoIt()}}
$apps | Where-Object -FilterScript {$_.Path -like "Microsoft.WindowsStore*"} | ForEach-Object -Process {$_.Verbs() | Where-Object -FilterScript {$_.Name -eq $unpin} | ForEach-Object -Process {$_.DoIt()}}
# Do not show when snapping a window, what can be attached next to it
# Не показывать при прикреплении окна, что можно прикрепить рядом с ним
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SnapAssist -PropertyType DWord -Value 0 -Force
# Set the Control Panel view by large icons
# Установить крупные значки в панели управления
IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name AllItemsIconView -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name StartupPage -PropertyType DWord -Value 1 -Force
# Choose theme color for default Windows mode
# Выбрать режим Windows по умолчанию
IF ($RU)
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
Do
{
	$theme = Read-Host -Prompt " "
	IF ($theme -eq "L")
	{
		# Show color only on taskbar
		# Отображать цвет элементов только на панели задач
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name ColorPrevalence -PropertyType DWord -Value 0 -Force
		# Light Theme Color for Default Windows Mode
		# Режим Windows по умолчанию светлый
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -PropertyType DWord -Value 1 -Force
	}
	elseif ($theme -eq "D")
	{
		# Turn on the display of color on Start menu, taskbar, and action center
		# Отображать цвет элементов в меню "Пуск", на панели задач и в центре уведомлений
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name ColorPrevalence -PropertyType DWord -Value 1 -Force
		# Dark Theme Color for Default Windows Mode
		# Режим Windows по умолчанию темный
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -PropertyType DWord -Value 0 -Force
	}
	elseif ([string]::IsNullOrEmpty($theme))
	{
		break
	}
	else
	{
		IF ($RU)
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
Until ($theme -eq "L" -or $theme -eq "D")
# Choose theme color for default app mode
# Выбрать режим приложения по умолчанию
IF ($RU)
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
Do
{
	$theme = Read-Host -Prompt " "
	IF ($theme -eq "L")
	{
		# Light theme color for default app mode
		# Режим приложений по умолчанию светлый
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -PropertyType DWord -Value 1 -Force
	}
	IF ($theme -eq "D")
	{
		# Dark theme color for default app mode
		# Режим приложений по умолчанию темный
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -PropertyType DWord -Value 0 -Force
	}
	elseif ([string]::IsNullOrEmpty($theme))
	{
		break
	}
	else
	{
		IF ($RU)
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
Until ($theme -eq "L" -or $theme -eq "D")
# Do not show "New App Installed" notification
# Не показывать уведомление "Установлено новое приложение"
IF (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name NoNewAppAlert -PropertyType DWord -Value 1 -Force
# Do not show user first sign-in animation
# Не показывать анимацию при первом входе в систему
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableFirstLogonAnimation -PropertyType DWord -Value 0 -Force
# Turn off JPEG desktop wallpaper import quality reduction
# Установка качества фона рабочего стола на 100 %
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name JPEGImportQuality -PropertyType DWord -Value 100 -Force
# Show Task Manager details
# Раскрыть окно Диспетчера задач
$taskmgr = Get-Process -Name Taskmgr -ErrorAction SilentlyContinue
IF ($taskmgr)
{
	$taskmgr.CloseMainWindow()
}
Start-Process -FilePath .\Taskmgr.exe -WindowStyle Hidden -PassThru
Do
{
	Start-Sleep -Milliseconds 100
	$preferences = Get-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences -ErrorAction SilentlyContinue
}
Until ($preferences)
Stop-Process -Name Taskmgr
$preferences.Preferences[28] = 0
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences -PropertyType Binary -Value $preferences.Preferences -Force
$Error.RemoveRange(0, $Error.Count)
# Remove Microsoft Edge shortcut from the Desktop
# Удалить ярлык Microsoft Edge с рабочего стола
$value = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Desktop
Remove-Item -Path "$value\Microsoft Edge.lnk" -Force -ErrorAction SilentlyContinue
# Show accent color on the title bars and window borders
# Отображать цвет элементов в заголовках окон и границ окон
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\DWM -Name ColorPrevalence -PropertyType DWord -Value 1 -Force
# Turn off automatically hiding scroll bars
# Отключить автоматическое скрытие полос прокрутки в Windows
New-ItemProperty -Path "HKCU:\Control Panel\Accessibility" -Name DynamicScrollbars -PropertyType DWord -Value 0 -Force
# Show more Windows Update restart notifications about restarting
# Показывать уведомление, когда компьютеру требуется перезагрузка для завершения обновления
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name RestartNotificationsAllowed2 -PropertyType DWord -Value 1 -Force
# Turn off the "- Shortcut" name extension for new shortcuts
# He дoбaвлять "- яpлык" для coздaвaeмыx яpлыкoв
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name link -PropertyType Binary -Value ([byte[]](00, 00, 00, 00)) -Force
# Use the PrtScn button to open screen snipping
# Использовать клавишу Print Screen, чтобы запустить функцию создания фрагмента экрана
New-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name PrintScreenKeyForSnippingEnabled -PropertyType DWord -Value 1 -Force
# Automatically adjust active hours for me based on daily usage
# Автоматически изменять период активности для этого устройства на основе действий
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name SmartActiveHoursState -PropertyType DWord -Value 1 -Force
#endregion UI & Personalization

#region OneDrive
# Uninstall OneDrive
# Удалить OneDrive
Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue
Start-Process -FilePath "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" -ArgumentList "/uninstall" -Wait
Stop-Process -Name explorer
Remove-ItemProperty -Path HKCU:\Environment -Name OneDrive -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:ProgramData\Microsoft OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
Unregister-ScheduledTask -TaskName *OneDrive* -Confirm:$false
IF ((Get-ChildItem -Path $env:USERPROFILE\OneDrive -ErrorAction SilentlyContinue | Measure-Object).Count -eq 0)
{
	Remove-Item -Path $env:USERPROFILE\OneDrive -Recurse -Force -ErrorAction SilentlyContinue
}
else
{
	Write-Error "$env:USERPROFILE\OneDrive folder is not empty"
}
Wait-Process -Name OneDriveSetup -ErrorAction SilentlyContinue
Remove-Item -Path $env:LOCALAPPDATA\Microsoft\OneDrive -Recurse -Force -ErrorAction SilentlyContinue
$Error.RemoveAt(0)
#endregion OneDrive

#region System
# Turn on Storage Sense to automatically free up space
# Включить Память устройства для автоматического освобождения места
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01 -PropertyType DWord -Value 1 -Force
# Run Storage Sense every month
# Запускать контроль памяти каждый месяц
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 2048 -PropertyType DWord -Value 30 -Force
# Delete temporary files that apps aren't using
# Удалять временные файлы, не используемые в приложениях
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 04 -PropertyType DWord -Value 1 -Force
# Delete files in recycle bin if they have been there for over 30 days
# Удалять файлы, которые находятся в корзине более 30 дней
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 256 -PropertyType DWord -Value 30 -Force
# Never delete files in "Downloads" folder
# Никогда не удалять файлы из папки "Загрузки"
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 512 -PropertyType DWord -Value 0 -Force
# Let Windows try to fix apps so they're not blurry
# Разрешить Windows исправлять размытость в приложениях
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name EnablePerProcessSystemDPI -PropertyType DWord -Value 1 -Force
# Turn off hibernate
# Отключить гибридный спящий режим
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Power -Name HibernateEnabled -PropertyType DWord -Value 0 -Force
# Turn off location for this device
# Отключить местоположение для этого устройства
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location -Name Value -PropertyType String -Value Deny -Force
# Change environment variable for $env:TEMP to $env:SystemDrive\Temp
# Изменить путь переменной среды для временных файлов на $env:SystemDrive\Temp
IF (-not (Test-Path -Path $env:SystemDrive\Temp))
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
# Remove "$env:LOCALAPPDATA\Temp"
# Удалить "$env:LOCALAPPDATA\Temp"
Remove-Item $env:LOCALAPPDATA\Temp -Recurse -Force -ErrorAction SilentlyContinue
# Remove "$env:SYSTEMROOT\Temp"
# Удалить "$env:SYSTEMROOT\Temp"
Restart-Service -Name Spooler -Force
Remove-Item -Path "$env:SystemRoot\Temp" -Recurse -Force -ErrorAction SilentlyContinue
# Turn on Win32 long paths
# Включить длинные пути Win32
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem -Name LongPathsEnabled -PropertyType DWord -Value 1 -Force
# Group svchost.exe processes
# Группировать одинаковые службы в один процесс svhost.exe
$ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control -Name SvcHostSplitThresholdInKB -PropertyType DWord -Value $ram -Force
# Turn on Retpoline patch against Spectre v2
# Включить патч Retpoline против Spectre v2
IF ((Get-CimInstance -ClassName CIM_OperatingSystem).ProductType -eq 1)
{
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name FeatureSettingsOverride -PropertyType DWord -Value 1024 -Force
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name FeatureSettingsOverrideMask -PropertyType DWord -Value 1024 -Force
}
# Turn on the display of stop error information on the BSoD
# Включить дополнительную информацию при выводе BSoD
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Control\CrashControl -Name DisplayParameters -PropertyType DWord -Value 1 -Force
# Do not preserve zone information
# Не хранить сведения о зоне происхождения вложенных файлов
IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -Name SaveZoneInformation -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments -Name SaveZoneInformation -PropertyType DWord -Value 1 -Force
# Turn off Admin Approval Mode for administrators
# Отключить использование режима одобрения администратором для встроенной учетной записи администратора
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -PropertyType DWord -Value 0 -Force
# Turn on access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled
# Включить доступ к сетевым дискам при включенном режиме одобрения администратором при доступе из программ, запущенных с повышенными правами
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLinkedConnections -PropertyType DWord -Value 1 -Force
# Set download mode for delivery optization on "HTTP only"
# Отключить оптимизацию доставки для обновлений с других ПК
Get-Service -Name DoSvc | Stop-Service -Force
IF (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization -Name DODownloadMode -PropertyType DWord -Value 0 -Force
# Always wait for the network at computer startup and logon
# Всегда ждать сеть при запуске и входе в систему
IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon"))
{
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name SyncForegroundPolicy -PropertyType DWord -Value 1 -Force
# Turn off Cortana
# Отключить Cortana
IF (-not $RU)
{
	IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"))
	{
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force
	}
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name AllowCortana -PropertyType DWord -Value 0 -Force
}
# Do not allow Windows 10 to manage default printer
# Отключить управление принтером, используемым по умолчанию, со стороны Windows 10
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows" -Name LegacyDefaultPrinterMode -PropertyType DWord -Value 1 -Force
# Turn off Windows features
# Отключить компоненты
$features = @(
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
Disable-WindowsOptionalFeature -Online -FeatureName $features -NoRestart
# Remove Windows capabilities
# Удалить компоненты
$IncludedApps = @(
	# Microsoft Quick Assist
	# Быстрая поддержка (Майкрософт)
	"App.Support.QuickAssist*"
	# Windows Hello Face
	# Распознавание лиц Windows Hello
	"Hello.Face*"
	# Windows Media Player
	# Проигрыватель Windows Media
	"Media.WindowsMediaPlayer*"
)
$OFS = "|"
Get-WindowsCapability -Online | Where-Object -FilterScript {$_.Name -cmatch $IncludedApps} | Remove-WindowsCapability -Online
$OFS = " "
# Turn on updates for other Microsoft products
# Включить автоматическое обновление для других продуктов Microsoft
(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "")
# Enable System Restore
# Включить восстановление системы
Enable-ComputerRestore -Drive $env:SystemDrive
Get-ScheduledTask -TaskName SR | Enable-ScheduledTask
Get-Service -Name swprv, vss | Set-Service -StartupType Manual
Get-Service -Name swprv, vss | Start-Service
Get-CimInstance -ClassName Win32_ShadowCopy | Remove-CimInstance
# Turn off Windows Script Host
# Отключить Windows Script Host
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Name Enabled -PropertyType DWord -Value 0 -Force
# Turn off default background apps, except the followings...
# Запретить стандартным приложениям работать в фоновом режиме, кроме следующих...
$ExcludedApps = @(
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
)
$OFS = "|"
Get-ChildItem -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | Where-Object -FilterScript {$_.PSChildName -cnotmatch $ExcludedApps} |
ForEach-Object -Process {
	New-ItemProperty -Path $_.PsPath -Name Disabled -PropertyType DWord -Value 1 -Force
	New-ItemProperty -Path $_.PsPath -Name DisabledByUser -PropertyType DWord -Value 1 -Force
}
$OFS = " "
# Set power management scheme for desktop and laptop
# Установить схему управления питания для стационарного ПК и ноутбука
IF ((Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType -eq 1)
{
	# High performance for desktop
	# Высокая производительность для стационарного ПК
	powercfg /setactive SCHEME_MIN
}
IF ((Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType -eq 2)
{
	# Balanced for laptop
	# Сбалансированная для ноутбука
	powercfg /setactive SCHEME_BALANCED
}
# Turn on .NET 4 runtime for all apps
# Использовать последнюю установленную версию .NET Framework для всех приложений
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\.NETFramework -Name OnlyUseLatestCLR -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework -Name OnlyUseLatestCLR -PropertyType DWord -Value 1 -Force
# Turn on firewall & network protection
# Включить брандмауэр
Set-NetFirewallProfile -Enabled True
# Do not allow the computer to turn off the device to save power for desktop
# Запретить отключение Ethernet-адаптера для экономии энергии для стационарного ПК
IF ((Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType -eq 1)
{
	$adapter = Get-NetAdapter -Physical | Get-NetAdapterPowerManagement
	$adapter.AllowComputerToTurnOffDevice = "Disabled"
	$adapter | Set-NetAdapterPowerManagement
}
# Set the default input method to the English language
# Установить метод ввода по умолчанию на английский язык
Set-WinDefaultInputMethodOverride "0409:00000409"
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
# Set location of the "Desktop", "Documents" "Downloads" "Music", "Pictures", and "Videos"
# Переопределить расположение папок "Рабочий стол", "Документы", "Загрузки", "Музыка", "Изображения", "Видео"
Function KnownFolderPath
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
	IF (-not ("WinAPI.KnownFolders" -as [type]))
	{
		Add-Type @Signature
	}
	foreach ($guid in $KnownFolders[$KnownFolder])
	{
		[WinAPI.KnownFolders]::SHSetKnownFolderPath([ref]$guid, 0, 0, $Path)
	}
	(Get-Item -Path $Path -Force).Attributes = "ReadOnly"
}
[hashtable] $DesktopINI = @{
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
IF ($RU)
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
IF ($RU)
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
Do
{
	$drive = Read-Host -Prompt " "
	IF ($drives -eq $drive)
	{
		$drive = $(${drive}.ToUpper())
		$DesktopFolder = "${drive}:\Desktop"
		$DesktopReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Desktop
		IF ($DesktopReg -ne $DesktopFolder)
		{
			IF (-not (Test-Path -Path $DesktopFolder))
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
		# Сохранить скриншот по Win+PrtScr на рабочем столе
		New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{b7bede81-df94-4682-a7d8-57a52620b86f}" -Name RelativePath -PropertyType String -Value $DesktopFolder -Force
	}
	elseif ([string]::IsNullOrEmpty($drive))
	{
		break
	}
	else
	{
		IF ($RU)
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
Until ($drives -eq $drive)
# Documents
# Документы
IF ($RU)
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
Do
{
	$drive = Read-Host -Prompt " "
	IF ($drives -eq $drive)
	{
		$drive = $(${drive}.ToUpper())
		$DocumentsFolder = "${drive}:\Documents"
		$DocumentsReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Personal
		IF ($DocumentsReg -ne $DocumentsFolder)
		{
			IF (-not (Test-Path -Path $DocumentsFolder))
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
		IF ($RU)
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
Until ($drives -eq $drive)
# Downloads
# Загрузки
IF ($RU)
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
Do
{
	$drive = Read-Host -Prompt " "
	IF ($drives -eq $drive)
	{
		$drive = $(${drive}.ToUpper())
		$DownloadsFolder = "${drive}:\Downloads"
		$DownloadsReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
		IF ($DownloadsReg -ne $DownloadsFolder)
		{
			IF (-not (Test-Path -Path $DownloadsFolder))
			{
				New-Item -Path $DownloadsFolder -ItemType Directory -Force
			}
			KnownFolderPath -KnownFolder Downloads -Path $DownloadsFolder
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}" -PropertyType ExpandString -Value $DownloadsFolder -Force
			Set-Content -Path "$DownloadsFolder\desktop.ini" -Value $DesktopINI["Downloads"] -Encoding Unicode -Force
			(Get-Item -Path "$DownloadsFolder\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$DownloadsFolder\desktop.ini" -Force).Refresh()
			# Microsoft Edge download folder
			$edge = (Get-AppxPackage "Microsoft.MicrosoftEdge").PackageFamilyName
			New-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\Main" -Name "Default Download Directory" -PropertyType String -Value $DownloadsFolder -Force
		}
	}
	elseif ([string]::IsNullOrEmpty($drive))
	{
		break
	}
	else
	{
		IF ($RU)
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
Until ($drives -eq $drive)
# Music
# Музыка
IF ($RU)
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
Do
{
	$drive = Read-Host -Prompt " "
	IF ($drives -eq $drive)
	{
		$drive = $(${drive}.ToUpper())
		$MusicFolder = "${drive}:\Music"
		$MusicReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Music"
		IF ($MusicReg -ne $MusicFolder)
		{
			IF (-not (Test-Path -Path $MusicFolder))
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
		IF ($RU)
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
Until ($drives -eq $drive)
# Pictures
# Изображения
IF ($RU)
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
Do
{
	$drive = Read-Host -Prompt " "
	IF ($drives -eq $drive)
	{
		$drive = $(${drive}.ToUpper())
		$PicturesFolder = "${drive}:\Pictures"
		$PicturesReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Pictures"
		IF ($PicturesReg -ne $PicturesFolder)
		{
			IF (-not (Test-Path -Path $PicturesFolder))
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
		IF ($RU)
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
Until ($drives -eq $drive)
# Videos
# Видео
IF ($RU)
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
Do
{
	$drive = Read-Host -Prompt " "
	IF ($drives -eq $drive)
	{
		$drive = $(${drive}.ToUpper())
		$VideosFolder = "${drive}:\Videos"
		$VideosReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Video"
		IF ($VideosReg -ne $VideosFolder)
		{
			IF (-not (Test-Path -Path $VideosFolder))
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
		IF ($RU)
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
Until ($drives -eq $drive)
# Turn on automatic recommended troubleshooting and tell when problems get fixed
# Автоматически запускать средства устранения неполадок, а затем сообщать об устранении проблем
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 3 -Force
IF (-not (Test-Path -Path HKLM:\SOFTWARE\Microsoft\WindowsMitigation))
{
	New-Item -Path HKLM:\SOFTWARE\Microsoft\WindowsMitigation -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsMitigation -Name UserPreference -PropertyType DWord -Value 3 -Force
# Set "High performance" in graphics performance preference for apps
# Установить параметры производительности графики для отдельных приложений на "Высокая производительность"
IF ((Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType -ne 2 -and (Get-CimInstance -ClassName Win32_VideoController | Where-Object -FilterScript {$_.AdapterDACType -ne "Internal" -and $null -ne $_.AdapterDACType}))
{
	IF ($RU)
	{
		Write-Host "`nВведите полные пути до .exe файлов, " -NoNewline
		Write-Host "для которого следует установить"
		Write-Host "параметры производительности графики на `"Высокая производительность`"."
		Write-Host "Пути должны быть разделены запятыми и взяты в кавычки." -ForegroundColor Yellow
		Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
	}
	else
	{
		Write-Host "`nType the full paths to .exe files for which to set"
		Write-Host "graphics performance preference to `"High performance GPU`"."
		Write-Host "The paths must be separated by commas and taken in quotes." -ForegroundColor Yellow
		Write-Host "`nPress Enter to skip" -NoNewline
	}
	IF (Test-Path -Path "${env:ProgramFiles(x86)}\Steam")
	{
		Start-Process -FilePath "${env:ProgramFiles(x86)}\Steam\steamapps\common"
	}
	function GpuPreference
	{
		[CmdletBinding()]
		Param
		(
			[Parameter(Mandatory = $True)]
			[string[]]$apps
		)
		$apps = $apps.Replace("`"", "").Split(",").Trim()
		foreach ($app in $apps)
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\DirectX\UserGpuPreferences -Name $app -PropertyType String -Value "GpuPreference=2;" -Force
		}
	}
	Do
	{
		$apps = Read-Host -Prompt " "
		IF ($apps -match ".exe" -and $apps -match "`"")
		{
			GpuPreference $apps
		}
		elseif ([string]::IsNullOrEmpty($apps))
		{
			break
		}
		else
		{
			IF ($RU)
			{
				Write-Host "`nПути не взяты в кавычки или не содержат ссылки на .exe файлы." -ForegroundColor Yellow
				Write-Host "Введите полные пути до .exe файлов, взяв в кавычки и разделив запятыми."
				Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
			}
			else
			{
				Write-Host "`nThe paths hasn't been taken in quotes or do not contain links to .exe files" -ForegroundColor Yellow
				Write-Host "Type the full paths to .exe files by quoting and separating by commas."
				Write-Host "`nPress Enter to skip" -NoNewline
			}
		}
	}
	Until ($apps -match ".exe" -and $apps -match "`"")
}
# Launch folder in a separate process
# Запускать окна с папками в отдельном процессе
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SeparateProcess -PropertyType DWord -Value 1 -Force
# Turn off and delete reserved storage after the next update installation
# Отключить и удалить зарезервированное хранилище после следующей установки обновлений
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager -Name BaseHardReserveSize -PropertyType QWord -Value 0 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager -Name BaseSoftReserveSize -PropertyType QWord -Value 0 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager -Name HardReserveAdjustment -PropertyType QWord -Value 0 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager -Name MinDiskSize -PropertyType QWord -Value 0 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager -Name ShippedWithReserves -PropertyType DWord -Value 0 -Force
# Turn on automatic backup the system registry to the "$env:SystemRoot\System32\config\RegBack" folder
# Включить автоматическое создание копии реестра в папку "$env:SystemRoot\System32\config\RegBack"
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager" -Name EnablePeriodicBackup -PropertyType DWord -Value 1 -Force
# Turn off "The Windows Filtering Platform has blocked a connection" message
# Отключить в "Журналах Windows/Безопасность" сообщение "Платформа фильтрации IP-пакетов Windows разрешила подключение"
auditpol /set /subcategory:"{0CCE9226-69AE-11D9-BED3-505054503030}" /success:disable /failure:disable
# Turn off SmartScreen for apps and files
# Отключить SmartScreen для приложений и файлов
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name SmartScreenEnabled -PropertyType String -Value Off -Force
# Turn off F1 Help key
# Отключить справку по нажатию F1
IF (-not (Test-Path -Path "HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64"))
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
# Отключить автозапуск с внешних носителей
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers -Name DisableAutoplay -PropertyType DWord -Value 1 -Force
# Turn off creation of an Edge shortcut on the desktop for each user profile
# Отключить создание ярлыка Edge на рабочем столе для каждого профиля пользователя пользователя
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name DisableEdgeDesktopShortcutCreation -PropertyType DWord -Value 1 -Force
# Turn off thumbnail cache removal
# Отключить удаление кэша миниатюр
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" -Name Autorun -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" -Name Autorun -PropertyType DWord -Value 0 -Force
# Turn On automatically save my restartable apps when sign out and restart them after sign in ###
# Автоматически сохранять мои перезапускаемые приложения при выходе из системы и перезапустить их после выхода
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name RestartApps -Value 1 -Force
#endregion System

#region Start menu
# Do not show recently added apps on Start menu
# Не показывать недавно добавленные приложения в меню "Пуск"
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name HideRecentlyAddedApps -PropertyType DWord -Value 1 -Force
# Open shortcut to the Command Prompt from Start menu as Administrator
# Запускать ярлык к командной строке в меню "Пуск" от имени Администратора
[byte[]]$bytes = Get-Content -Path "$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\Command Prompt.lnk" -Encoding Byte -Raw
$bytes[0x15] = $bytes[0x15] -bor 0x20
Set-Content -Path "$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\Command Prompt.lnk" -Value $bytes -Encoding Byte -Force
# Create old style shortcut for "Devices and Printers" in "$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools"
# Создать ярлык старого формата для "Устройства и принтеры" в "$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools"
$target = "control"
$linkname = (Get-ControlPanelItem | Where-Object -FilterScript {$_.CanonicalName -eq "Microsoft.DevicesAndPrinters"}).Name
$link = "$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\$linkname.lnk"
$shell = New-Object -ComObject Wscript.Shell
$shortcut = $shell.CreateShortcut($link)
$shortcut.TargetPath = $target
$shortcut.Arguments = "printers"
$shortCut.IconLocation = "$env:SystemRoot\system32\DeviceCenter.dll"
$shortcut.Save()
# Import Start menu layout from pre-saved reg file
# Импорт настроенного макета меню "Пуск" из заготовленного reg-файла
Add-Type -AssemblyName System.Windows.Forms
$OpenFileDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
$OpenFileDialog.Multiselect = $false
$openfiledialog.ShowHelp = $true
# Initial directory "Downloads"
# Начальная папка "Загрузки"
$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
$OpenFileDialog.InitialDirectory = $DownloadsFolder
$OpenFileDialog.Multiselect = $false
$OpenFileDialog.ShowHelp = $false
IF ($RU)
{
	$OpenFileDialog.Filter = "Файлы реестра (*.reg)|*.reg|Все файлы (*.*)|*.*"
}
else
{
	$OpenFileDialog.Filter = "Registration Files (*.reg)|*.reg|All Files (*.*)|*.*"
}
# Focus on open file dialog
# Перевести фокус на диалог открытия файла
$tmp = New-Object -TypeName System.Windows.Forms.Form
$tmp.add_Shown(
{
	$tmp.Visible = $false
	$tmp.Activate()
	$tmp.TopMost = $true
	$OpenFileDialog.ShowDialog($tmp)
	$tmp.Close()
})
$tmp.ShowDialog()
IF ($OpenFileDialog.FileName)
{
	Remove-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount -Recurse -Force
	regedit.exe /s $OpenFileDialog.FileName
}
Else
{
	# Unpin all Start menu tiles
	# Открепить все ярлыки от начального экрана
	$tilecollection = Get-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*start.tilegrid`$windows.data.curatedtilecollection.tilecollection\Current
	$unpin = $tilecollection.Data[0..25] + ([byte[]](202,50,0,226,44,1,1,0,0))
	New-ItemProperty -Path $tilecollection.PSPath -Name Data -PropertyType Binary -Value $unpin -Force
	# Show "Explorer" and "Settings" folders on Start menu
	# Отобразить папки "Проводник" и "Параметры" в меню "Пуск"
	$items = @("File Explorer", "Settings")
	$startmenu = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*windows.data.unifiedtile.startglobalproperties\Current"
	$data = $startmenu.Data[0..19] -join ","
	$data += ",203,50,10,$($items.Length)"
	# Explorer
	# Проводник
	$data += ",5,188,201,168,164,1,36,140,172,3,68,137,133,1,102,160,129,186,203,189,215,168,164,130,1,0"
	# Settings
	# Параметры
	$data += ",5,134,145,204,147,5,36,170,163,1,68,195,132,1,102,159,247,157,177,135,203,209,172,212,1,0"
	$data += ",194,60,1,194,70,1,197,90,1,0"
	New-ItemProperty -Path $startmenu.PSPath -Name Data -PropertyType Binary -Value $data.Split(",") -Force
}
#endregion Start menu

#region Edge
# Turn off Windows Defender SmartScreen for Microsoft Edge
# Отключить Windows Defender SmartScreen в Microsoft Edge
$edge = (Get-AppxPackage "Microsoft.MicrosoftEdge").PackageFamilyName
IF (-not (Test-Path -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\PhishingFilter"))
{
	New-Item -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\PhishingFilter" -Force
}
New-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\PhishingFilter" -Name EnabledV9 -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\PhishingFilter" -Name PreventOverride -PropertyType DWord -Value 0 -Force
# Do not allow Microsoft Edge to start and load the Start and New Tab page at Windows startup and each time Microsoft Edge is closed
# Не разрешать Edge запускать и загружать страницу при загрузке Windows и каждый раз при закрытии Edge
IF (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader -Name AllowTabPreloading -PropertyType DWord -Value 0 -Force
# Do not allow Microsoft Edge to pre-launch at Windows startup, when the system is idle, and each time Microsoft Edge is closed
# Не разрешать предварительный запуск Edge при загрузке Windows, когда система простаивает, и каждый раз при закрытии Edge
IF (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main -Name AllowPrelaunch -PropertyType DWord -Value 0 -Force
#endregion Edge

#region UWP apps
# Uninstall all UWP apps from all accounts, except the followings...
# Удалить все UWP-приложения из всех учетных записей, кроме следующих...
$ExcludedApps = @(
	# iTunes
	"AppleInc.iTunes"
	# Intel UWP-panel
	# UWP-панель Intel
	"AppUp.IntelGraphicsControlPanel"
	"AppUp.IntelGraphicsExperience"
	# Microsoft Desktop App Installer
	"Microsoft.DesktopAppInstaller"
	# Sticky Notes
	# Записки
	"Microsoft.MicrosoftStickyNotes"
	# Screen Sketch
	# Набросок на фрагменте экрана
	"Microsoft.ScreenSketch"
	# Microsoft Store
	"Microsoft.StorePurchaseApp"
	"Microsoft.WindowsStore"
	# Web Media Extensions
	# Расширения для интернет-мультимедиа
	"Microsoft.WebMediaExtensions"
	# Photos and Video Editor
	# Фотографии и Видеоредактор
	"Microsoft.Windows.Photos"
	# Calculator
	# Калькулятор
	"Microsoft.WindowsCalculator"
	# NVIDIA Control Panel
	# Панель управления NVidia
	"NVIDIACorp.NVIDIAControlPanel"
)
$OFS = "|"
Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object {$_.Name -cnotmatch $ExcludedApps} | Remove-AppxPackage -AllUsers
$OFS = " "
# Uninstall all provisioned UWP apps from System account, except the followings...
# App packages will not be installed when new user accounts are created
# Удалить все UWP-приложения из системной учетной записи, кроме следующих...
# Приложения не будут установлены при создании новых учетных записей
$ExcludedApps = @(
	# Intel UWP-panel
	# UWP-панель Intel
	"AppUp.IntelGraphicsControlPanel"
	"AppUp.IntelGraphicsExperience"
	# Microsoft Desktop App Installer
	"Microsoft.DesktopAppInstaller"
	# HEIF Image Extensions
	# Расширения для изображений HEIF
	"Microsoft.HEIFImageExtension"
	# Sticky Notes
	# Записки
	"Microsoft.MicrosoftStickyNotes"
	# Screen Sketch
	# Набросок на фрагменте экрана
	"Microsoft.ScreenSketch"
	# Microsoft Store
	"Microsoft.StorePurchaseApp"
	"Microsoft.WindowsStore"
	# VP9 Video Extensions
	# Расширения для VP9-видео
	"Microsoft.VP9VideoExtensions"
	# Web Media Extensions
	# Расширения для интернет-мультимедиа
	"Microsoft.WebMediaExtensions"
	# WebP Image Extension
	# Расширения для изображений WebP
	"Microsoft.WebpImageExtension"
	# Photos and Video Editor
	# Фотографии и Видеоредактор
	"Microsoft.Windows.Photos"
	# Calculator
	# Калькулятор
	"Microsoft.WindowsCalculator"
	# NVIDIA Control Panel
	# Панель управления NVidia
	"NVIDIACorp.NVIDIAControlPanel"
)
$OFS = "|"
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript {$_.DisplayName -cnotmatch $ExcludedApps} | Remove-AppxProvisionedPackage -Online
$OFS = " "
#endregion UWP apps

#region Windows Game Recording
# Turn off Windows Game Recording and Broadcasting
# Отключить Запись и трансляции игр Windows
IF (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR -Name AllowgameDVR -PropertyType DWord -Value 0 -Force
# Turn off Game Bar
# Отключить игровую панель
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR -Name AppCaptureEnabled -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path HKCU:\System\GameConfigStore -Name GameDVR_Enabled -PropertyType DWord -Value 0 -Force
# Turn off Game Mode
# Отключить игровой режим
New-ItemProperty -Path HKCU:\Software\Microsoft\GameBar -Name AllowAutoGameMode -PropertyType DWord -Value 0 -Force
# Turn off Game Bar tips
# Отключить подсказки игровой панели
New-ItemProperty -Path HKCU:\Software\Microsoft\GameBar -Name ShowStartupPanel -PropertyType DWord -Value 0 -Force
#endregion Windows Game Recording

#region Scheduled tasks
# Create a task in the Task Scheduler to start Windows cleaning up. The task runs every 90 days
# Создать задачу в Планировщике задач по очистке обновлений Windows. Задача выполняется каждые 90 дней
$keys = @(
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
	"Windows Upgrade Log Files")
foreach ($key in $keys)
{
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$key" -Name StateFlags1337 -PropertyType DWord -Value 2 -Force
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
# Create a task in the Task Scheduler to clear the "$env:SystemRoot\SoftwareDistribution\Download" folder.
# The task runs on Thursdays every 4 weeks
# Создать задачу в Планировщике задач по очистке папки "$env:SystemRoot\SoftwareDistribution\Download"
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
# Create a task in the Task Scheduler to clear the $env:TEMP folder. The task runs every 62 days
# Создать задачу в Планировщике задач по очистке папки $env:TEMP. Задача выполняется каждые 62 дня
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

#region Microsoft Defender
# Add folder to exclude from Windows Defender Antivirus scan
# Добавить папку в список исключений сканирования Защитника Windows
IF ($RU)
{
	Write-Host "`nВведите полные пути до файлов или папок, которые следует "
	Write-Host "исключить из списка сканирования Windows Defender."
	Write-Host "Пути должны быть разделены запятыми и взяты в кавычки." -ForegroundColor Yellow
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nType the full paths to files or folders, which to exclude "
	Write-Host "from Windows Defender Antivirus Scan."
	Write-Host "The paths must be separated by commas and taken in quotes." -ForegroundColor Yellow
	Write-Host "`nPress Enter to skip" -NoNewline
}
function ExclusionPath
{
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory = $True)]
		[string[]]$paths
	)
	$paths = $paths.Replace("`"", "").Split(",").Trim()
	Add-MpPreference -ExclusionPath $paths -Force
}
Do
{
	$paths = Read-Host -Prompt " "
	IF ($paths -match "`"")
	{
		ExclusionPath $paths
	}
	elseif ([string]::IsNullOrEmpty($paths))
	{
		break
	}
	else
	{
		IF ($RU)
		{
			Write-Host "`nПути не взяты в кавычки." -ForegroundColor Yellow
			Write-Host "Введите пути, взяв в кавычки и разделив запятыми."
			Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
		}
		else
		{
			Write-Host "`nThe paths hasn't been taken in quotes." -ForegroundColor Yellow
			Write-Host "Type the paths by quoting and separating by commas."
			Write-Host "`nPress Enter to skip" -NoNewline
		}
	}
}
Until ($paths -match "`"")
# Turn on Controlled folder access and add protected folders
# Включить контролируемый доступ к папкам и добавить защищенные папки
IF ($RU)
{
	Write-Host "`nВведите путь до папки, чтобы добавить в список защищенных папок."
	Write-Host "Пути должны быть разделены запятыми и взяты в кавычки." -ForegroundColor Yellow
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nType folder path to add to protected folders list."
	Write-Host "The paths must be separated by commas and taken in quotes." -ForegroundColor Yellow
	Write-Host "`nPress Enter to skip" -NoNewline
}
function ControlledFolderAccess
{
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory = $True)]
		[string[]]$paths
	)
	Set-MpPreference -EnableControlledFolderAccess Enabled
	$paths = $paths.Replace("`"", "").Split(",").Trim()
	Add-MpPreference -ControlledFolderAccessProtectedFolders $paths
}
Do
{
	$paths = Read-Host -Prompt " "
	IF ($paths -match "`"")
	{
		ControlledFolderAccess $paths
	}
	elseif ([string]::IsNullOrEmpty($paths))
	{
		break
	}
	else
	{
		IF ($RU)
		{
			Write-Host "`nПути не взяты в кавычки." -ForegroundColor Yellow
			Write-Host "Введите пути, взяв в кавычки и разделив запятыми."
			Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
		}
		else
		{
			Write-Host "`nThe paths hasn't been taken in quotes." -ForegroundColor Yellow
			Write-Host "Type the paths by quoting and separating by commas."
			Write-Host "`nPress Enter to skip" -NoNewline
		}
	}
}
Until ($paths -match "`"")
# Allow an app through Controlled folder access
# Разрешить работу приложения через контролируемый доступ к папкам
IF ((Get-MpPreference).EnableControlledFolderAccess -eq 1)
{
	IF ($RU)
	{
		Write-Host "`nВведите путь до приложения, чтобы добавить в список разрешенных приложений."
		Write-Host "Пути должны быть разделены запятыми и взяты в кавычки." -ForegroundColor Yellow
		Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
	}
	else
	{
		Write-Host "`nType app path to add to an allowed app list."
		Write-Host "The paths must be separated by commas and taken in quotes." -ForegroundColor Yellow
		Write-Host "`nPress Enter to skip" -NoNewline
	}
	function ControlledFolderAllowedApplications
	{
		[CmdletBinding()]
		Param
		(
			[Parameter(Mandatory = $True)]
			[string[]]$paths
		)
		$paths = $paths.Replace("`"", "").Split(",").Trim()
		Add-MpPreference -ControlledFolderAccessAllowedApplications $paths
	}
	Do
	{
		$paths = Read-Host -Prompt " "
		IF ($paths -match "`"")
		{
			ControlledFolderAllowedApplications $paths
		}
		elseif ([string]::IsNullOrEmpty($paths))
		{
			break
		}
		else
		{
			IF ($RU)
			{
				Write-Host "`nПути не взяты в кавычки." -ForegroundColor Yellow
				Write-Host "Введите пути, взяв в кавычки и разделив запятыми."
				Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
			}
			else
			{
				Write-Host "`nThe paths hasn't been taken in quotes." -ForegroundColor Yellow
				Write-Host "Type the paths by quoting and separating by commas."
				Write-Host "`nPress Enter to skip" -NoNewline
			}
		}
	}
	Until ($paths -match "`"")
}
# Turn on Windows Defender Exploit Guard Network Protection
# Включить Защиту сети в Защитнике Windows
Set-MpPreference -EnableNetworkProtection Enabled
# Turn on Windows Defender PUA Protection
# Включить блокировки потенциально нежелательных приложений
Set-MpPreference -PUAProtection Enabled
# Turn on Windows Defender Sandbox
# Запускать Защитник Windows в песочнице
setx /M MP_FORCE_USE_SANDBOX 1
# Hide notification about sign in with Microsoft in the Windows Security
# Скрыть уведомление Защитника Windows об использовании аккаунта Microsoft
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows Security Health\State" -Name AccountProtection_MicrosoftAccount_Disconnected -PropertyType DWord -Value 1 -Force
# Hide notification about disabled Smartscreen for Microsoft Edge
# Скрыть уведомление Защитника Windows об отключенном фильтре SmartScreen для Microsoft Edge
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows Security Health\State" -Name AppAndBrowser_EdgeSmartScreenOff -PropertyType DWord -Value 0 -Force
#endregion Microsoft Defender

#region Context menu
# Add "Extract" to MSI file type context menu
# Добавить пункт "Extract" для MSI в контекстное меню
IF (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command))
{
	New-Item -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command -Force
}
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command -Name "(default)" -PropertyType String -Value "msiexec.exe /a `"%1`" /qb TARGETDIR=`"%1 extracted`"" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Name MUIVerb -PropertyType String -Value "@shell32.dll,-31382" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Name Icon -PropertyType String -Value "shell32.dll,-16817" -Force
# Add "Run as different user" from context menu for .exe file type
# Добавить "Запуск от имени друго пользователя" в контекстное меню для .exe файлов
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\exefile\shell\runasuser -Name "(default)" -PropertyType String -Value "@shell32.dll,-50944" -Force
Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\exefile\shell\runasuser -Name Extended -Force -ErrorAction SilentlyContinue
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\exefile\shell\runasuser -Name SuppressionPolicyEx -PropertyType String -Value "{F211AA05-D4DF-4370-A2A0-9F19C09756A7}" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\exefile\shell\runasuser\command -Name DelegateExecute -PropertyType String -Value "{ea72d00e-4960-42fa-ba92-7792a7944c1d}" -Force
# Add "Install" to CAB file type context menu
# Добавить пункт "Установить" для CAB-файлов в контекстном меню
IF (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command))
{
	New-Item -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command -Force
}
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command -Name "(default)" -PropertyType String -Value "cmd /c DISM /Online /Add-Package /PackagePath:`"%1`" /NoRestart & pause" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs -Name MUIVerb -PropertyType String -Value "@shell32.dll,-10210" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs -Name HasLUAShield -PropertyType String -Value "" -Force
# Remove "Cast to Device" from context menu
# Удалить пункт "Передать на устройство" из контекстного меню
IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"))
{
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" -PropertyType String -Value "Play to menu" -Force
# Remove "Share" from context menu
# Удалить пункт "Отправить" (поделиться) из контекстного меню
IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"))
{
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{E2BF9676-5F8F-435C-97EB-11607A5BEDF7}" -PropertyType String -Value "" -Force
# Remove "Previous Versions" from file context menu
# Удалить пункт "Восстановить прежнюю версию" из контекстного меню
IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"))
{
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{596AB062-B4D2-4215-9F74-E9109B0A8153}" -PropertyType String -Value "" -Force
# Remove "Edit with Paint 3D" from context menu
# Удалить пункт "Изменить с помощью Paint 3D" из контекстного меню
$exts = @(".bmp", ".gif", ".jpe", ".jpeg", ".jpg", ".png", ".tif", ".tiff")
foreach ($ext in $exts)
{
	New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\$ext\Shell\3D Edit" -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
}
# Remove "Include in Library" from context menu
# Удалить пункт "Добавить в библиотеку" из контекстного меню
New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Folder\shellex\ContextMenuHandlers\Library Location" -Name "(default)" -PropertyType String -Value "-{3dad6c5d-2167-4cae-9914-f99e41c12cfa}" -Force
# Remove "Turn on BitLocker" from context menu
# Удалить пункт "Включить Bitlocker" из контекстного меню
IF (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -eq "Professional" -or $_.Edition -eq "Enterprise"})
{
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\encrypt-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\encrypt-bde-elev -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\manage-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\resume-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\resume-bde-elev -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\unlock-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
}
# Remove "Edit with Photos" from context menu
# Удалить пункт "Изменить с помощью приложения "Фотографии"" из контекстного меню
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellEdit -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
# Remove "Create a new video" from Context Menu
# Удалить пункт "Создать новое видео" из контекстного меню
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellCreateVideo -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
# Remove "Edit" from Context Menu
# Удалить пункт "Изменить" из контекстного меню
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\edit -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
# Remove "Print" from batch and cmd files context menu
# Удалить пункт "Печать" из контекстного меню для bat- и cmd-файлов
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\batfile\shell\print -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\cmdfile\shell\print -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
# Remove "Compressed (zipped) Folder" from context menu
# Удалить пункт "Сжатая ZIP-папка" из контекстного меню
Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew -Force -ErrorAction SilentlyContinue
# Remove "Rich Text Document" from context menu
# Удалить пункт "Создать Документ в формате RTF" из контекстного меню
Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.rtf\ShellNew -Force -ErrorAction SilentlyContinue
# Remove "Bitmap image" from context menu
# Удалить пункт "Создать Точечный рисунок" из контекстного меню
Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.bmp\ShellNew -Force -ErrorAction SilentlyContinue
# Remove "Send to" from folder context menu
# Удалить пункт "Отправить" из контекстного меню папки
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo -Name "(default)" -PropertyType String -Value "" -Force
# Make the "Open", "Print", "Edit" context menu items available, when more than 15 selected
# Сделать доступными элементы контекстного меню "Открыть", "Изменить" и "Печать" при выделении более 15 элементов
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name MultipleInvokePromptMinimum -PropertyType DWord -Value 300 -Force
# Turn off "Look for an app in the Microsoft Store" in "Open with" dialog
# Отключить поиск программ в Microsoft Store при открытии диалога "Открыть с помощью"
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name NoUseStoreOpenWith -PropertyType DWord -Value 1 -Force
#endregion Context menu

#region End
# Restart Start menu
# Перезапустить меню "Пуск"
Stop-Process -Name StartMenuExperienceHost -Force
# Refresh desktop icons, environment variables and taskbar without restarting File Explorer
# Обновить иконки рабочего стола, переменные среды и панель задач без перезапуска "Проводника"
$UpdateEnvExplorerAPI = @{
	Namespace = "WinAPI"
	Name = "UpdateEnvExplorer"
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
			SHChangeNotify(0x8000000, 0x1000, IntPtr.Zero, IntPtr.Zero);
			// Update environment variables
			SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, IntPtr.Zero, null, SMTO_ABORTIFHUNG, 100, IntPtr.Zero);
			// Update taskbar
			SendNotifyMessage(HWND_BROADCAST, WM_SETTINGCHANGE, IntPtr.Zero, "TraySettings");
		}
"@
}
IF (-not ("WinAPI.UpdateEnvExplorer" -as [type]))
{
	Add-Type @UpdateEnvExplorerAPI
}
[WinAPI.UpdateEnvExplorer]::Refresh()

# Errors output
# Вывод ошибок
Write-Host "`nErrors" -BackgroundColor Red
($Error | ForEach-Object -Process {
	[PSCustomObject] @{
		Line = $_.InvocationInfo.ScriptLineNumber
		Error = $_.Exception.Message
	}
} | Sort-Object -Property Line | Format-Table -AutoSize -Wrap | Out-String).Trim()
#endregion End
