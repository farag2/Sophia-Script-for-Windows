# Сlear $Error
# Очистка $Error
$Error.Clear()
# Turn off diagnostics tracking services
# Отключить службы диагностического отслеживания
$services = @(
	# Connected Devices Platform service
	# Служба платформы подключенных устройств
	"CDPSvc",
	# Connected User Experiences and Telemetry
	# Функциональные возможности для подключенных пользователей и телеметрия
	"DiagTrack",
	# Data Usage
	# Использование данных
	"DusmSvc",
	# SSDP Discovery
	# Обнаружение SSDP
	"SSDPSRV")
Foreach ($service in $services)
{
	Get-Service -ServiceName $service | Stop-Service -Force
	Get-Service -ServiceName $service | Set-Service -StartupType Disabled
}
# Turn off the Autologger session at the next computer restart
# Отключить сборщик AutoLogger при следующем запуске ПК
Update-AutologgerConfig -Name AutoLogger-Diagtrack-Listener -Start 0
# Turn off the SQMLogger session at the next computer restart
# Отключить сборщик SQMLogger при следующем запуске ПК
Update-AutologgerConfig -Name SQMLogger -Start 0
# Set the operating system diagnostic data level to "Basic"
# Установить уровень отправляемых диагностических сведений на "Базовый"
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -Value 1 -Force
# Turn off Windows Error Reporting
# Отключить отчеты об ошибках Windows для всех пользователей
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\Windows Error Reporting" -Name Disabled -Value 1 -Force
# Change Windows Feedback frequency to "Never"
# Изменить частоту формирования отзывов на "Никогда"
IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Siuf\Rules))
{
	New-Item -Path HKCU:\Software\Microsoft\Siuf\Rules -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Siuf\Rules -Name NumberOfSIUFInPeriod -Value 0 -Force
# Turn off diagnostics tracking scheduled tasks
# Отключить задачи диагностического отслеживания
$tasks = @(
	"BgTaskRegistrationMaintenanceTask",
	"Consolidator",
	"DmClient",
	"DmClientOnScenarioDownload",
	"EnableLicenseAcquisition",
	"FamilySafetyMonitor",
	"FamilySafetyRefreshTask",
	"File History (maintenance mode)",
	"FODCleanupTask",
	"GatherNetworkInfo",
	"MapsToastTask",
	"Microsoft Compatibility Appraiser",
	"Microsoft-Windows-DiskDiagnosticDataCollector",
	"MNO Metadata Parser",
	"NetworkStateChangeTask",
	"ProgramDataUpdater",
	"Proxy",
	"QueueReporting",
	"TempSignedLicenseExchange",
	"UsbCeip",
	"WinSAT",
	"XblGameSaveTask")
Foreach ($task in $tasks)
{
	Get-ScheduledTask -TaskName $task | Disable-ScheduledTask
}
# Turn off "The Windows Filtering Platform has blocked a connection" message
# Отключить в "Журналах Windows/Безопасность" сообщение "Платформа фильтрации IP-пакетов Windows разрешила подключение"
auditpol /set /subcategory:"{0CCE9226-69AE-11D9-BED3-505054503030}" /success:disable /failure:disable
# Set File Explorer to open to This PC by default
# Открывать "Этот компьютер" в Проводнике
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Value 1 -Force
# Show Hidden Files, Folders, and Drives
# Показывать скрытые файлы, папки и диски
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -Value 1 -Force
# Show File Name Extensions
# Показывать расширения для зарегистрированных типов файлов
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -Value 0 -Force
# Hide Task View button on taskbar
# Не показывать кнопку Просмотра задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -Value 0 -Force
# Show folder merge conflicts
# Не скрывать конфликт слияния папок
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideMergeConflicts -Value 0 -Force
# Turn off Snap Assist
# Не показывать при прикреплении окна, что можно прикрепить рядом с ним
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SnapAssist -Value 0 -Force
# Turn off check boxes to select items
# Отключить флажки для выбора элементов
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name AutoCheckSelect -Value 0 -Force
# Show seconds on taskbar clock
# Включить отображение секунд в системных часах на панели задач
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSecondsInSystemClock -Value 1 -Force
# Hide People button on the taskbar
# Не показывать панель "Люди" на панели задач
IF (-not (Test-Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Name PeopleBand -Value 0 -Force
# Hide all folders in the navigation pane
# Не отображать все папки в области навигации
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneShowAllFolders -Value 0 -Force
# Turn on acrylic taskbar transparency
# Включить прозрачную панель задач
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name UseOLEDTaskbarTransparency -Value 1 -Force
# Turn off app launch tracking to improve Start menu and search results
# Не разрешать Windows отслеживать запуски приложений для улучшения меню "Пуск" и результатов поиска и не показывать недавно добавленные приложения
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Start_TrackProgs -Value 0 -Force
# Отобразить "Этот компьютер" на рабочем столе
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 0 -Force
# Show more details in file transfer dialog
# Развернуть диалог переноса файлов
IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Name EnthusiastMode -Value 1 -Force
# Turn off AutoPlay for all media and devices
# Отключить автозапуск с внешних носителей
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers -Name DisableAutoplay -Value 1 -Force
# Turn off the "- Shortcut" name extension for new shortcuts
# He дoбaвлять "- яpлык" для coздaвaeмыx яpлыкoв
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name link -PropertyType Binary -Value ([byte[]](00, 00, 00, 00)) -Force
# Turn off SmartScreen for apps and files
# Отключить SmartScreen для приложений и файлов
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name SmartScreenEnabled -PropertyType String -Value Off -Force
# Remove the "Previous Versions" tab from properties context menu
# Отключить отображение вкладки "Предыдущие версии" в свойствах файлов и папок
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name NoPreviousVersionsPage -Value 1 -Force
# Always show all icons in the notification area
# Всегда отображать все значки в области уведомлений
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray -Value 0 -Force
# Set the Control Panel view by large icons
# Установить крупные значки в панели управления
IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name AllItemsIconView -Value 0 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name StartupPage -Value 1 -Force
# Remove 3D Objects folder in "This PC" and in the navigation pane
# Скрыть папку "Объемные объекты" из "Этот компьютер" и на панели быстрого доступа
IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"))
{
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name ThisPCPolicy -PropertyType String -Value Hide -Force
# Make the "Open", "Print", "Edit" context menu items available, when more than 15 selected
# Сделать доступными элементы контекстного меню "Открыть", "Изменить" и "Печать" при выделении более 15 элементов
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name MultipleInvokePromptMinimum -Value 300 -Force
# Hide "Frequent folders" in Quick access
# Не показывать недавно используемые папки на панели быстрого доступа
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -Value 0 -Force
# Hide "Recent files" in Quick access
# Не показывать недавно использовавшиеся файлы на панели быстрого доступа
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -Value 0 -Force
# Turn off creation of an Edge shortcut on the desktop for each user profile
# Отключить создание ярлыка Edge на рабочем столе для каждого профиля пользователя пользователя
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name DisableEdgeDesktopShortcutCreation -Value 1 -Force
# Turn on tip, trick, and suggestions as you use Windows
# Показывать советы, подсказки и рекомендации при использованию Windows
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338389Enabled -Value 1 -Force
# Turn on Storage Sense to automatically free up space
# Включить Память устройства для автоматического освобождения места
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01 -Value 1 -Force
# Run Storage Sense every month
# Запускать контроль памяти каждый месяц
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 2048 -Value 30 -Force
# Delete temporary files that apps aren't using
# Удалять временные файлы, не используемые в приложениях
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 04 -Value 1 -Force
# Delete files in recycle bin if they have been there for over 30 days
# Удалять файлы, которые находятся в корзине более 30 дней
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 256 -Value 30 -Force
# Never delete files in "Downloads" folder
# Никогда не удалять файлы из папки "Загрузки"
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 512 -Value 0 -Force
# Turn off app suggestions on Start menu
# Не показывать рекомендации в меню "Пуск"
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338388Enabled -Value 0 -Force
# Turn off suggested content in the Settings
# Не показывать рекомендуемое содержание в приложении "Параметры"
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338393Enabled -Value 0 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-353694Enabled -Value 0 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-353696Enabled -Value 0 -Force
# Turn off automatic installing suggested apps
# Отключить автоматическую установку рекомендованных приложений
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SilentInstalledAppsEnabled -Value 0 -Force
# Hide "Windows Ink Workspace" button in taskbar
# Скрыть кнопку Windows Ink Workspace
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\PenWorkspace -Name PenWorkspaceButtonDesiredVisibility -Value 0 -Force
# Do not offer tailored experiences based on the diagnostic data setting
# Не предлагать персонализированныее возможности, основанные на выбранном параметре диагностических данных
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy -Name TailoredExperiencesWithDiagnosticDataEnabled -Value 0 -Force
# Do not let apps on other devices open and message apps on this device, and vice versa
# Не разрешать приложениям на других устройствах запускать приложения и отправлять сообщения на этом устройстве и наоборот
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\CDP -Name RomeSdkChannelUserAuthzPolicy -Value 0 -Force
# Choose light or dark theme color for default Windows mode
# Выбрать режим Windows по умолчанию и режим приложения по умолчанию
$theme = Read-Host -Prompt "Choose light or dark theme color for default Windows mode (type light or dark).
Press Enter to skip
`nВыберите режим Windows по умолчанию (введите light или dark).
Чтобы пропустить, нажмите Enter"
IF ($theme -eq "Light")
{
	# Show color only on taskbar
	# Отображать цвет элементов только на панели задач
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name ColorPrevalence -Value 0 -Force
	# Light Theme Color for Default Windows Mode
	# Режим Windows по умолчанию светлый
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 1 -Force
}
IF ($theme -eq "Dark")
{
	# Turn on the display of color on Start menu, taskbar, and action center
	# Отображать цвет элементов в меню "Пуск", на панели задач и в центре уведомлений
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name ColorPrevalence -Value 1 -Force
	# Режим Windows по умолчанию темный
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -Value 0 -Force
}
# Choose light or dark theme color for default app mode
# Выбрать режим приложения по умолчанию
$apps = Read-Host -Prompt "Choose light or dark theme color for default app mode (type light or dark).
Press Enter to skip
`nВыберите режим приложения по умолчанию (введите light или dark).
Чтобы пропустить, нажмите Enter"
IF ($apps -eq "Light")
{
	# Light theme color for default app mode
	# Режим приложений по умолчанию светлый
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 1 -Force
}
IF ($apps -eq "Dark")
{
	# Dark theme color for default app mode
	# Режим приложений по умолчанию темный
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0 -Force
}
# Turn off location for this device
# Отключить местоположение для этого устройства
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location -Name Value -PropertyType String -Value Deny -Force
# Turn off thumbnail cache removal
# Отключить удаление кэша миниатюр
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" -Name Autorun -Value 0 -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" -Name Autorun -Value 0 -Force
# Turn off hibernate
# Отключить гибридный спящий режим
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\Power -Name HibernateEnabled -Value 0 -Force
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
# Turn on Win32 long paths
# Включить длинные пути Win32
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem -Name LongPathsEnabled -Value 1 -Force
# Group svchost.exe processes
# Группировать одинаковые службы в один процесс svhost.exe
$ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control -Name SvcHostSplitThresholdInKB -Value $ram -Force
# Turn on Retpoline patch against Spectre v2
# Включить патч Retpoline против Spectre v2
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name FeatureSettingsOverride -Value 1024 -Force
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name FeatureSettingsOverrideMask -Value 1024 -Force
# Turn on the display of stop error information on the BSoD
# Включить дополнительную информацию при выводе BSoD
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Control\CrashControl -Name DisplayParameters -Value 1 -Force
# Hide search box or search icon on taskbar
# Не показывать кнопку поиска
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -Value 0 -Force
# Turn on recycle bin files delete confirmation
# Запрашивать подтверждение на удалении файлов из корзины
IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name ConfirmFileDelete -Value 1 -Force
# Do not preserve zone information
# Не хранить сведения о зоне происхождения вложенных файлов
IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -Name SaveZoneInformation -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments -Name SaveZoneInformation -Value 1 -Force
# Turn off Admin Approval Mode for administrators
# Отключить использование режима одобрения администратором для встроенной учетной записи администратора
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0 -Force
# Turn off user first sign-in animation
# Не показывать анимацию при первом входе в систему
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableFirstLogonAnimation -Value 0 -Force
# Turn on access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled
# Включить доступ к сетевым дискам при включенном режиме одобрения администратором при доступе из программ, запущенных с повышенными правами
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLinkedConnections -Value 1 -Force
# Turn off "Look for an app in the Microsoft Store" in "Open with" dialog
# Отключить поиск программ в Microsoft Store при открытии диалога "Открыть с помощью"
IF (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name NoUseStoreOpenWith -Value 1 -Force
# Turn on ribbon in File Explorer
# Включить отображение ленты проводника в развернутом виде
IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Name MinimizedStateTabletModeOff -Value 0 -Force
# Turn off "New App Installed" notification
# Не показывать уведомление "Установлено новое приложение"
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name NoNewAppAlert -Value 1 -Force
# Turn off recently added apps on Start Menu
# Не показывать недавно добавленные приложения в меню "Пуск"
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name HideRecentlyAddedApps -Value 1 -Force
# Turn off Windows Game Recording and Broadcasting
# Отключить Запись и трансляции игр Windows
IF (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR -Name AllowgameDVR -Value 0 -Force
# Set download mode for delivery optization on "HTTP only"
# Отключить оптимизацию доставки для обновлений с других ПК
Get-Service -ServiceName DoSvc | Stop-Service -Force
IF (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization -Name DODownloadMode -Value 0 -Force
# Always wait for the network at computer startup and logon
# Всегда ждать сеть при запуске и входе в систему
IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon"))
{
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name SyncForegroundPolicy -Value 1 -Force
# Do not allow apps to use advertising ID
# Не разрешать приложениям использовать идентификатор рекламы
New-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -Value 0 -Force
# Turn off Cortana
# Отключить Cortana
IF ((Get-WinSystemLocale).Name -ne "ru-RU")
{
	IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"))
	{
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force
	}
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name AllowCortana -Value 0 -Force
}
# Turn off Windows Defender SmartScreen for Microsoft Edge
# Отключить Windows Defender SmartScreen в Microsoft Edge
$edge = (Get-AppxPackage "Microsoft.MicrosoftEdge").PackageFamilyName
IF (-not (Test-Path -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\PhishingFilter"))
{
	New-Item -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\PhishingFilter" -Force
}
New-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\PhishingFilter" -Name EnabledV9 -Value 0 -Force
New-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\PhishingFilter" -Name PreventOverride -Value 0 -Force
# Do not allow Microsoft Edge to start and load the Start and New Tab page at Windows startup and each time Microsoft Edge is closed
# Не разрешать Edge запускать и загружать страницу при загрузке Windows и каждый раз при закрытии Edge
IF (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader -Name AllowTabPreloading -Value 0 -Force
# Do not allow Microsoft Edge to pre-launch at Windows startup, when the system is idle, and each time Microsoft Edge is closed
# Не разрешать предварительный запуск Edge при загрузке Windows, когда система простаивает, и каждый раз при закрытии Edge
IF (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main -Name AllowPrelaunch -Value 0 -Force
# Do not allow Windows 10 to manage default printer
# Отключить управление принтером, используемым по умолчанию, со стороны Windows 10
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows" -Name LegacyDefaultPrinterMode -Value 1 -Force
# Turn off JPEG desktop wallpaper import quality reduction
# Установка качества фона рабочего стола на 100 %
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name JPEGImportQuality -Value 100 -Force
# Turn off sticky Shift key after pressing 5 times
# Отключить залипание клавиши Shift после 5 нажатий
New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name Flags -PropertyType String -Value 506 -Force
# Uninstall UWP apps from current account except
# Удалить UWP-приложения из текущей учетной записи, кроме
$apps = @(
	# iTunes
	"AppleInc.iTunes"
	# Intel UWP-panel
	# UWP-панель Intel
	"AppUp.IntelGraphicsControlPanel"
	"AppUp.IntelGraphicsExperience"
	# Language pack
	# Языковой пакет
	"Microsoft.LanguageExperiencePack*"
	# NVIDIA Control Panel
	# Панель управления NVidia
	"NVIDIACorp.NVIDIAControlPanel"
	# File Picker
	# Средство выбора файлов
	"1527c705-839a-4832-9118-54d4Bd6a0c89"
	# File Explorer
	# Проводник
	"c5e2524a-ea46-4f67-841f-6a9465d9d515"
	# App Resolver UX
	# UI распознавателя приложений
	"E2A4F912-2574-4A75-9BB0-0D023378592B"
	# Add Suggested Folders To Library
	# Добавление предложенных папок в библиотеку
	"F46D4000-FD22-4DB4-AC8E-4E1DDDE828FE"
	"InputApp"
	"Microsoft.AAD.BrokerPlugin"
	"Microsoft.AccountsControl"
	"Microsoft.AsyncTextService"
	# Hello setup UI
	# Пользовательский интерфейс настройки Hello
	"Microsoft.BioEnrollment"
	"Microsoft.CredDialogHost"
	"Microsoft.ECApp"
	"Microsoft.LockApp"
	"Microsoft.EdgeDevtoolsPlugin"
	"Microsoft.MicrosoftEdgeDevToolsClient"
	# Microsoft Edge
	"Microsoft.MicrosoftEdge"
	"Microsoft.PPIProjection"
	"Microsoft.Win32WebViewHost"
	"Microsoft.Windows.Apprep.ChxApp"
	"Microsoft.Windows.AssignedAccessLockApp"
	"Microsoft.Windows.CallingShellApp"
	"Microsoft.Windows.CapturePicker"
	"Microsoft.Windows.CloudExperienceHost"
	"Microsoft.Windows.ContentDeliveryManager"
	# Cortana
	"Microsoft.Windows.Cortana"
	"Microsoft.Windows.NarratorQuickStart"
	"Microsoft.Windows.OOBENetworkCaptivePortal"
	"Microsoft.Windows.OOBENetworkConnectionFlow"
	"Microsoft.Windows.ParentalControls"
	# People Hub
	# Раздел "Люди"
	"Microsoft.Windows.PeopleExperienceHost"
	"Microsoft.Windows.PinningConfirmationDialog"
	"Microsoft.Windows.SecHealthUI"
	"Microsoft.Windows.SecureAssessmentBrowser"
	"Microsoft.Windows.ShellExperienceHost"
	# Start
	# Меню "Пуск"
	"Microsoft.Windows.StartMenuExperienceHost"
	"Microsoft.Windows.XGpuEjectDialog"
	"Microsoft.XboxGameCallableUI"
	"Windows.CBSPreview"
	# Settings
	# Параметры
	"windows.immersivecontrolpanel"
	# Print UI
	# Пользовательский интерфейс печати
	"Windows.PrintDialog"
	"Microsoft.NET.Native*"
	"Microsoft.UI.Xaml*"
	"Microsoft.VCLibs*"
	"Microsoft.Advertising.Xaml"
	# Microsoft Desktop App Installer
	"Microsoft.DesktopAppInstaller"
	# Screen Sketch
	# Набросок на фрагменте экрана
	# Microsoft Store
	".*Store.*"
	# Extensions
	# Расширения
	"Microsoft.*Extension*"
	# Photos
	# Фотографии
	"Microsoft.Windows.Photos"
)
Get-AppxPackage -AllUsers | Where-Object -FilterScript {$_.Name -cnotmatch ($apps -join "|")} | Remove-AppxPackage
# Uninstall UWP apps from all accounts except
# Удалить UWP-приложения из системной учетной записи, кроме
$apps = @(
	# Intel UWP-panel
	# UWP-панель Intel
	"AppUp.IntelGraphicsControlPanel"
	"AppUp.IntelGraphicsExperience"
	# Microsoft Desktop App Installer
	"Microsoft.DesktopAppInstaller"
	# Extensions
	# Расширения
	"Microsoft.*Extension*"
	# NVIDIA Control Panel
	# Панель управления NVidia
	"NVIDIACorp.NVIDIAControlPanel"
	# Microsoft Store
	".*Store.*")
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript {$_.DisplayName -cnotmatch ($apps -join "|")} | Remove-AppxProvisionedPackage -Online
# Turn off Windows features
# Отключить компоненты
$features = @(
	# Windows Fax and Scan
	# Факсы и сканирование
	"FaxServicesClientPackage",
	# Legacy Components
	# Компоненты прежних версий
	"LegacyComponents",
	# Media Features
	# Компоненты работы с мультимедиа
	"MediaPlayback",
	# PowerShell 2.0
	"MicrosoftWindowsPowerShellV2",
	"MicrosoftWindowsPowershellV2Root",
	# Microsoft XPS Document Writer
	# Средство записи XPS-документов (Microsoft)
	"Printing-XPSServices-Features",
	# Microsoft Print to PDF
	# Печать в PDF (Майкрософт)
	"Printing-PrintToPDFServices-Features",
	# Work Folders Client
	# Клиент рабочих папок
	"WorkFolders-Client")
Foreach ($feature in $features)
{
	Disable-WindowsOptionalFeature -Online -FeatureName $feature -NoRestart
}
# Uninstall Onedrive
# Удалить OneDrive
Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 3
Start-Process -FilePath "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" /uninstall -Wait
Start-Sleep -Seconds 3
Stop-Process -Name explorer
IF (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive))
{
	New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive -Name DisableFileSyncNGSC -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive -Name DisableFileSync -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive -Name DisableMeteredNetworkFileSync -Value 0 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive -Name DisableLibrariesDefaultSaveToOneDrive -Value 1 -Force
New-ItemProperty -Path HKCU:\Software\Microsoft\OneDrive -Name DisablePersonalSync -Value 1 -Force
Remove-ItemProperty -Path HKCU:\Environment -Name OneDrive -Force -ErrorAction SilentlyContinue
Remove-Item -Path $env:USERPROFILE\OneDrive -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path $env:LOCALAPPDATA\Microsoft\OneDrive -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:ProgramData\Microsoft OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
Unregister-ScheduledTask -TaskName *OneDrive* -Confirm:$false
# Turn on updates for other Microsoft products
# Включить автоматическое обновление для других продуктов Microsoft
(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "")
# Turn off Game Bar
# Отключить игровую панель
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR -Name AppCaptureEnabled -Value 0 -Force
New-ItemProperty -Path HKCU:\System\GameConfigStore -Name GameDVR_Enabled -Value 0 -Force
# Turn off Game Mode
# Отключить игровой режим
New-ItemProperty -Path HKCU:\Software\Microsoft\GameBar -Name AllowAutoGameMode -Value 0 -Force
# Turn off Game Bar tips
# Отключить подсказки игровой панели
New-ItemProperty -Path HKCU:\Software\Microsoft\GameBar -Name ShowStartupPanel -Value 0 -Force
# Enable System Restore
# Включить восстановление системы
Enable-ComputerRestore -Drive $env:SystemDrive
Get-ScheduledTask -TaskName SR | Enable-ScheduledTask
Get-Service -ServiceName swprv, vss | Set-Service -StartupType Manual
Get-Service -ServiceName swprv, vss | Start-Service
Get-CimInstance -ClassName Win32_ShadowCopy | Remove-CimInstance
# Turn off Windows Script Host
# Отключить Windows Script Host
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Name Enabled -Value 0 -Force
# Create scheduled task with the disk cleanup tool in Task Scheduler
# Создать в Планировщике задач задачу по запуску очистки диска
$keys = @(
	# Файлы оптимизации доставки
	"Delivery Optimization Files",
	# Пакеты драйверов устройств
	"Device Driver Packages",
	# Предыдущие установки Windows
	"Previous Installations",
	# Файлы журнала установки
	"Setup Log Files",
	# Temporary Setup Files
	"Temporary Setup Files",
	# Очистка обновлений Windows
	"Update Cleanup",
	# Windows Defender Antivirus
	"Windows Defender",
	# Файлы журнала обновления Windows
	"Windows Upgrade Log Files")
Foreach ($key in $keys)
{
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$key" -Name StateFlags1337 -Value 2 -Force
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
# Create scheduled task with the "$env:SystemRoot\SoftwareDistribution\Download" folder cleanup in Task Scheduler. Edit $xml variable first
# The function to find the drive letter when the file is located in a fixed folder. Suitable when the file is located on a USB-drive and the drive letter is unknown.
# Создать в Планировщике задач задачу по очистки папки "$env:SystemRoot\SoftwareDistribution\Download". Сначала отредактируйте переменную $xml
# Функция для нахождения буквы диска, когда файл находится в известной папке, но не известна буква диска. Подходит, когда файл располагается на USB-носителе
# https://gist.github.com/farag2/17d2d4ec5f1e94663be6998775ad65c0
$xml = "Программы\Прочее\xml\SoftwareDistribution.xml"
function Get-ResolvedPath
{
	param (
		[Parameter(ValueFromPipeline = 1)]
		$Path
	)
	(Get-Disk | Where-Object -FilterScript {$_.BusType -eq "USB"} | Get-Partition | Get-Volume | Where-Object -FilterScript {$null -ne $_.DriveLetter}).DriveLetter | ForEach-Object -Process {Join-Path ($_ + ":") $Path -Resolve -ErrorAction SilentlyContinue}
}
$xml | Get-ResolvedPath | Get-Item | Get-Content -Raw | Register-ScheduledTask -TaskName "SoftwareDistribution" -Force
# Create scheduled task with the $env:TEMP folder cleanup in Task Scheduler
# Включить в Планировщике задач очистки папки $env:TEMP
$action = New-ScheduledTaskAction -Execute powershell.exe -Argument @"
	Get-ChildItem -Path `$env:TEMP -Force -Recurse | Remove-Item -Force -Recurse
"@
$trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 62 -At 9am
$settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
$principal = New-ScheduledTaskPrincipal -UserId System -RunLevel Highest
$params = @{
	"TaskName"	=	"Temp"
	"Action"	=	$action
	"Trigger"	=	$trigger
	"Settings"	=	$settings
	"Principal"	=	$principal
}
Register-ScheduledTask @params -Force
# Turn off default background apps except
# Запретить стандартным приложениям работать в фоновом режиме, кроме
$apps = @(
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
	"Microsoft.Windows.StartMenuExperienceHost*")
Foreach ($app in $apps)
{
	Get-ChildItem -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications -Exclude $apps |
	ForEach-Object -Process {
		New-ItemProperty -Path $_.PsPath -Name Disabled -Value 1 -Force
		New-ItemProperty -Path $_.PsPath -Name DisabledByUser -Value 1 -Force
	}
}
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
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\.NETFramework -Name OnlyUseLatestCLR -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework -Name OnlyUseLatestCLR -Value 1 -Force
# Turn on Num Lock at startup
# Включить Num Lock при загрузке
New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483650 -Force
# Add folder to exclude from Windows Defender Antivirus scan. Edit $folder variable first
# The function to find the drive letter when the full path to the folder is known and drive letter is unknown. Suitable when a folder is located on a USB-drive
# Добавить папку в список исключений сканирования Защитника Windows. Сначала отредактируйте переменную $folder
# Функция для нахождения буквы диска, когда известен полный путь до папки, но не известна буква диска. Подходит, когда папка располагается на USB-носителе
function Get-ResolvedPath
{
	param (
		[Parameter(ValueFromPipeline = 1)]
		$Path
	)
	(Get-Disk | Where-Object -FilterScript {$_.IsBoot -eq $false} | Get-Partition | Get-Volume | Where-Object -FilterScript {$null -ne $_.DriveLetter}).DriveLetter | ForEach-Object -Process {Join-Path ($_ + ":") $Path -Resolve -ErrorAction SilentlyContinue}
}
$folder = "Программы\Прочее" | Get-ResolvedPath
IF ($folder)
{
	Add-MpPreference -ExclusionPath $folder -Force
}
# Turn on Windows Defender Exploit Guard Network Protection
# Включить Защиту сети в Защитнике Windows
Set-MpPreference -EnableNetworkProtection Enabled
# Turn on Controlled folder access and add protected folder
# Включить контролируемый доступ к папкам и добавить контролируемую папку
$folder = Read-Host -Prompt "Type folder path to add to protected folders list.
Press Enter to skip
`nВведите путь до папки, чтобы добавить в список защищенных папок.
Чтобы пропустить, нажмите Enter"
IF ($folder)
{
	Set-MpPreference -EnableControlledFolderAccess Enabled
	Add-MpPreference -ControlledFolderAccessProtectedFolders $folder
}
# Turn on Windows Defender PUA Protection
# Включить блокировки потенциально нежелательных приложений
Set-MpPreference -PUAProtection Enabled
# Turn on firewall & network protection
# Включить брандмауэр
Set-NetFirewallProfile -Enabled True
# Turn off F1 Help key
# Отключить справку по нажатию F1
IF (-not (Test-Path -Path "HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64"))
{
	New-Item -Path "HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64" -Force
}
New-ItemProperty -Path "HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64" -Name "(default)" -PropertyType String -Value "" -Force
# Show Task Manager details
# Раскрыть окно Диспетчера задач
$taskmgr = Get-Process -Name Taskmgr -ErrorAction SilentlyContinue
IF ($taskmgr)
{
	$taskmgr.CloseMainWindow()
}
$taskmgr = Start-Process -WindowStyle Hidden -FilePath taskmgr.exe -PassThru
Do
{
	Start-Sleep -Milliseconds 100
	$preferences = Get-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences -ErrorAction SilentlyContinue
}
Until ($preferences)
Stop-Process $taskmgr
$preferences.Preferences[28] = 0
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences -PropertyType Binary -Value $preferences.Preferences -Force
# Do not allow the computer to turn off the device to save power for desktop
# Запретить отключение Ethernet-адаптера для экономии энергии для стационарного ПК
IF ((Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType -eq 1)
{
	$adapter = Get-NetAdapter -Physical | Get-NetAdapterPowerManagement
	$adapter.AllowComputerToTurnOffDevice = "Disabled"
	$adapter | Set-NetAdapterPowerManagement
}
# Add "Extract" to MSI file type context menu
# Добавить пункт "Извлечь" для MSI в контекстное меню
IF (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Извлечь\Command))
{
	New-Item -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Извлечь\Command -Force
}
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Извлечь\Command -Name "(default)" -PropertyType String -Value 'msiexec.exe /a "%1" /qb TARGETDIR="%1 extracted"' -Force
# Add "Run as different user" from context menu for exe file type
# Добавить "Запуск от имени друго пользователя" в контекстное меню для exe-файлов
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
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs -Name "(default)" -PropertyType String -Value "Установить" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs -Name HasLUAShield -PropertyType String -Value "" -Force
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command -Name "(default)" -PropertyType String -Value 'DISM /Online /Add-Package /PackagePath:"%1"' -Force
# Remove "Cast to Device" from context menu
# Удалить пункт "Передать на устройство" из контекстного меню
IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"))
{
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" -PropertyType String -Value "Play to menu" -Force
# Remove "Share" from context menu
# Удалить пункт "Отправить" (поделиться) из контекстного меню
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{E2BF9676-5F8F-435C-97EB-11607A5BEDF7}" -PropertyType String -Value "" -Force
# Remove "Previous Versions" from file context menu
# Удалить пункт "Восстановить прежнюю версию" из контекстного меню
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{596AB062-B4D2-4215-9F74-E9109B0A8153}" -PropertyType String -Value "" -Force
# Remove "Edit with Paint 3D" from context menu
# Удалить пункт "Изменить с помощью Paint 3D" из контекстного меню
$exts = @(".bmp", ".gif", ".jpe", ".jpeg", ".jpg", ".png", ".tif", ".tiff")
Foreach ($ext in $exts)
{
	Remove-Item -Path "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\$ext\Shell\3D Edit" -Recurse -Force -ErrorAction SilentlyContinue
}
# Remove "Include in Library" from context menu
# Удалить пункт "Добавить в библиотеку" из контекстного меню
Clear-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Folder\shellex\ContextMenuHandlers\Library Location" -Name "(default)" -Force
Clear-ItemProperty -Path "HKLM:\SOFTWARE\Classes\Folder\shellex\ContextMenuHandlers\Library Location" -Name "(default)" -Force
# Remove "Turn on BitLocker" from context menu
# Удалить пункт "Включить Bitlocker" из контекстного меню
IF (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -eq "Professional" -or $_.Edition -eq "Enterprise"})
{
	$keys = @(
		"encrypt-bde",
		"encrypt-bde-elev",
		"manage-bde",
		"resume-bde",
		"resume-bde-elev",
		"unlock-bde"
	)
	Foreach ($key in $keys)
	{
		New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\$key -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	}
}
# Remove "Print" from batch and cmd files context menu
# Удалить пункт "Печать" из контекстного меню для bat- и cmd-файлов
Remove-Item -Path Registry::HKEY_CLASSES_ROOT\batfile\shell\print -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path Registry::HKEY_CLASSES_ROOT\cmdfile\shell\print -Recurse -Force -ErrorAction SilentlyContinue
# Remove "Compressed (zipped) Folder" from context menu
# Удалить пункт "Создать архив ZIP" из контекстного меню
Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew -Name Data -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew -Name ItemName -Force -ErrorAction SilentlyContinue
# Remove "Rich Text Document" from context menu
# Удалить пункт "Создать Документ в формате RTF" из контекстного меню
Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\.rtf\ShellNew -Name Data -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\.rtf\ShellNew -Name ItemName -Force -ErrorAction SilentlyContinue
# Remove "Bitmap image" from context menu
# Удалить пункт "Создать Точечный рисунок" из контекстного меню
Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\.bmp\ShellNew -Name ItemName -Force -ErrorAction SilentlyContinue
Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\.bmp\ShellNew -Name NullFile -Force -ErrorAction SilentlyContinue
# Remove "Send to" from folder context menu
# Удалить пункт "Отправить" из контекстного меню папки
New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo -Name "(default)" -PropertyType String -Value "" -Force
# Override custom input method for login screen
# Переопределить пользовательский метод ввода на английский язык на экране входа
IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Control Panel\International"))
{
	New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Control Panel\International" -Force
}
# Disallow copying of user input methods to the system account for sign-in
# Запретить копирование пользовательских методов ввода в системную учетную запись для входа
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Control Panel\International" -Name BlockUserInputMethodsForSignIn -Value 1 -Force
# The English language
New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Keyboard Layout\Preload" -Name 1 -PropertyType String -Value 00000409 -Force
# The Russian language
New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Keyboard Layout\Preload" -Name 2 -PropertyType String -Value 00000419 -Force
# Unpin Microsoft Edge and Microsoft Store from taskbar
# Открепить Microsoft Edge и Microsoft Store от панели задач
$getstring = @"
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
$getstring = Add-Type $getstring -PassThru -Name GetStr -Using System.Text
$unpin = $getstring[0]::GetString(5387)
$apps = (New-Object -Com Shell.Application).NameSpace("shell:::{4234d49b-0245-4df3-b780-3893943456e1}").Items()
$apps | Where-Object -FilterScript {$_.Path -like "Microsoft.MicrosoftEdge*"} | ForEach-Object -Process {$_.Verbs() | Where-Object -FilterScript {$_.Name -eq $unpin} | ForEach-Object -Process {$_.DoIt()}}
$apps | Where-Object -FilterScript {$_.Path -like "Microsoft.WindowsStore*"} | ForEach-Object -Process {$_.Verbs() | Where-Object -FilterScript {$_.Name -eq $unpin} | ForEach-Object -Process {$_.DoIt()}}
# Do not use sign-in info to automatically finish setting up device after an update or restart
# Не использовать данные для входа для автоматического завершения настройки устройства после перезапуска или обновления
$sid = (Get-CimInstance -ClassName Win32_UserAccount | Where-Object -FilterScript {$_.Name -eq "$env:USERNAME"}).SID
IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$sid"))
{
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$sid" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$sid" -Name OptOut -Value 1 -Force
# Remove Microsoft Edge shortcut from the Desktop
# Удалить ярлык Microsoft Edge с рабочего стола
Remove-Item -Path "$env:USERPROFILE\Desktop\Microsoft Edge.lnk" -Force -ErrorAction SilentlyContinue
# Turn off per-user services
# Отключить пользовательские службы
$services = @(
	# Clipboard User Service
	# Пользовательская служба буфера обмена
	"cbdhsvc_*",
	# Contact Data
	# Служба контактных данных
	"PimIndexMaintenanceSvc_*",
	# User Data Storage
	# Служба хранения данных пользователя
	"UnistoreSvc_*",
	# User Data Access
	# Служба доступа к данным пользователя
	"UserDataSvc_*")
Foreach ($service in $services)
{
	Get-Service -ServiceName $service | Stop-Service -Force
}
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\cbdhsvc -Name Start -Value 4 -Force
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\cbdhsvc -Name UserServiceFlags -Value 0 -Force
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\PimIndexMaintenanceSvc -Name Start -Value 4 -Force
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\PimIndexMaintenanceSvc -Name UserServiceFlags -Value 0 -Force
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\UnistoreSvc -Name Start -Value 4 -Force
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\UnistoreSvc -Name UserServiceFlags -Value 0 -Force
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\UserDataSvc -Name Start -Value 4 -Force
New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\UserDataSvc -Name UserServiceFlags -Value 0 -Force
# Let Windows try to fix apps so they're not blurry
# Разрешить Windows исправлять размытость в приложениях
New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name EnablePerProcessSystemDPI -Value 1 -Force
# Remove printers
# Удалить принтеры
Remove-Printer -Name Fax, "Microsoft XPS Document Writer", "Microsoft Print to PDF" -ErrorAction SilentlyContinue
# Hide notification about sign in with Microsoft in the Windows Security
# Скрыть уведомление Защитника Windows об использовании аккаунта Microsoft
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows Security Health\State" -Name AccountProtection_MicrosoftAccount_Disconnected -Value 1 -Force
# Hide notification about disabled Smartscreen for Microsoft Edge
# Скрыть уведомление Защитника Windows об отключенном фильтре SmartScreen для Microsoft Edge
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows Security Health\State" -Name AppAndBrowser_EdgeSmartScreenOff -Value 0 -Force
# Remove Windows capabilities
# Удалить компоненты
$apps = @(
	# Microsoft Quick Assist
	# Быстрая поддержка (Майкрософт)
	"App.Support.QuickAssist*",
	# Windows Hello Face
	# Распознавание лиц Windows Hello
	"Hello.Face*",
	# Windows Media Player
	# Проигрыватель Windows Media
	"Media.WindowsMediaPlayer*")
Foreach ($app in $apps)
{
	Get-WindowsCapability -Online | Where-Object -FilterScript {$_.Name -like $app} | Remove-WindowsCapability -Online
}
# Open shortcut to the Command Prompt from Start menu as Administrator
# Запускать ярлык к командной строке в меню "Пуск" от имени Администратора
$bytes = [System.IO.File]::ReadAllBytes("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\System Tools\Command Prompt.lnk")
$bytes[0x15] = $bytes[0x15] -bor 0x20
[System.IO.File]::WriteAllBytes("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\System Tools\Command Prompt.lnk", $bytes)
# Create shortcut for "Devices and Printers" in "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\System Tools". Edit $lnk variable first
# Создать ярлык для "Устройства и принтеры" в "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\System Tools". Сначала отредактируйте переменную $lnk
$target = "control"
$lnk = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\System Tools\Устройства и принтеры.lnk"
$shell = New-Object -ComObject Wscript.Shell
$shortcut = $shell.CreateShortcut($lnk)
$shortcut.TargetPath = $target
$shortcut.Arguments = "printers"
$shortCut.IconLocation = "$env:SystemRoot\system32\DeviceCenter.dll"
$shortcut.Save()
# Import Start menu layout from pre-saved reg file. Edit $reg variable first
# The function to find the drive letter when the full path to the folder is known and drive letter is unknown. Suitable when the file is located on a USB-drive
# Импорт настроенного меню "Пуск" из заготовленного reg-файла. Сначала отредактируйте переменную $reg
# Функция для нахождения буквы диска, когда файл находится в известной папке, но не известна буква диска. Подходит, когда файл располагается на USB-носителе
function Get-ResolvedPath
{
	param (
		[Parameter(ValueFromPipeline = 1)]
		$Path
	)
	(Get-Disk | Where-Object -FilterScript {$_.BusType -eq "USB"} | Get-Partition | Get-Volume | Where-Object -FilterScript {$null -ne $_.DriveLetter}).DriveLetter | ForEach-Object -Process {Join-Path ($_ + ":") $Path -Resolve -ErrorAction SilentlyContinue}
}
$reg = "Программы\Прочее\reg\Start.reg" | Get-ResolvedPath
IF ($reg)
{
	Remove-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount -Recurse -Force
	Start-Process -FilePath reg.exe -ArgumentList "import $reg"
}
Else
{
	# Unpin all Start Menu tiles
	# Открепить все ярлыки от начального экрана
	$key = Get-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*start.tilegrid`$windows.data.curatedtilecollection.tilecollection\Current
	$data = $key.Data[0..25] + ([byte[]](202,50,0,226,44,1,1,0,0))
	New-ItemProperty -Path $key.PSPath -Name Data -PropertyType Binary -Value $data -Force
	# Show "Explorer" and "Settings" folders on Start menu
	# Отобразить папки "Проводник" и "Параметры" в меню "Пуск"
	$items = @("Проводник", "Параметры")
	$key2 = Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*windows.data.unifiedtile.startglobalproperties\Current"
	$data = $key2.Data[0..19] -join ","
	$data += ",203,50,10,$($items.Length)"
	# Explorer
	# Проводник
	$data += ",5,188,201,168,164,1,36,140,172,3,68,137,133,1,102,160,129,186,203,189,215,168,164,130,1,0"
	# Settings
	# Параметры
	$data += ",5,134,145,204,147,5,36,170,163,1,68,195,132,1,102,159,247,157,177,135,203,209,172,212,1,0"
	$data += ",194,60,1,194,70,1,197,90,1,0"
	New-ItemProperty -Path $key2.PSPath -Name Data -PropertyType Binary -Value $data.Split(",") -Force
}
# Show accent color on the title bars and window borders
# Отображать цвет элементов в заголовках окон и границ окон
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\DWM -Name ColorPrevalence -Value 1 -Force
# Use the PrtScn button to open screen snipping
# Использовать клавишу Print Screen, чтобы запустить функцию создания фрагмента экрана
New-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name PrintScreenKeyForSnippingEnabled -Value 1 -Force
# Do not allow automatic hiding if scroll bars in Windows
# Отключить автоматическое скрытие полос прокрутки в Windows
New-ItemProperty -Path "HKCU:\Control Panel\Accessibility" -Name DynamicScrollbars -Value 0 -Force
# Do not let websites provide locally relevant content by accessing language list
# Не позволять веб-сайтам предоставлять местную информацию за счет доступа к списку языков
New-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name HttpAcceptLanguageOptOut -Value 1 -Force
# Turn on Windows Defender Sandbox
# Запускать Защитник Windows в песочнице
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
setx /M MP_FORCE_USE_SANDBOX 1
# Set location of the "Desktop", "Documents" "Downloads" "Music", "Pictures" and "Videos"
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
	$Type = ([System.Management.Automation.PSTypeName]"KnownFolders").Type
	$Signature = @"
	[DllImport("shell32.dll")]
	public extern static int SHSetKnownFolderPath(ref Guid folderId, uint flags, IntPtr token, [MarshalAs(UnmanagedType.LPWStr)] string path);
"@
	$Type = Add-Type -MemberDefinition $Signature -Name "KnownFolders" -Namespace "SHSetKnownFolderPath" -PassThru
	# return $Type::SHSetKnownFolderPath([ref]$KnownFolders[$KnownFolder], 0, 0, $Path)
	ForEach ($guid in $KnownFolders[$KnownFolder])
	{
		$Type::SHSetKnownFolderPath([ref]$guid, 0, 0, $Path)
	}
	Attrib +r $Path
}
$drives = (Get-Disk | Where-Object -FilterScript {$_.BusType -ne "USB"} | Get-Partition | Get-Volume).DriveLetter
# Desktop. Edit $folder variable first
# Рабочий стол. Сначала отредактируйте переменную $folder
$drive = Read-Host -Prompt "Type the drive letter in the root of which the `"Desktop`" folder will be created.
Press Enter to skip
`nВведите букву диска, в корне которого будет создана папка `"Рабочий стол`".
Чтобы пропустить, нажмите Enter"
IF ($drives -eq $drive)
{
	$drive = $(${drive}.ToUpper())
	$folder = "Рабочий стол"
	$root = "${drive}:\$folder"
	$reg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Desktop
	IF ($reg -ne $root)
	{
		IF (-not (Test-Path -Path $root))
		{
			New-Item -Path $root -ItemType Directory -Force
		}
		IF (-not (Test-Path -Path "$root\desktop.ini"))
		{
			Copy-Item -Path "$reg\desktop.ini" -Destination $root -Force
		}
		KnownFolderPath -KnownFolder Desktop -Path $root
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{754AC886-DF64-4CBA-86B5-F7FBF4FBCEF5}" -PropertyType ExpandString -Value $root -Force
	}
}
# Documents. Edit $folder variable first
# Документы. Сначала отредактируйте переменную $folder
$drive = Read-Host -Prompt "Type the drive letter in the root of which the `"Documents`" folder will be created.
Press Enter to skip
`nВведите букву диска, в корне которого будет создана папка `"Документы`".
Чтобы пропустить, нажмите Enter"
IF ($drives -eq $drive)
{
	$drive = $(${drive}.ToUpper())
	$folder = "Документы"
	$root = "${drive}:\$folder"
	$reg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Personal
	IF ($reg -ne $root)
	{
		IF (-not (Test-Path -Path $root))
		{
			New-Item -Path "${drive}:\$folder" -ItemType Directory -Force
		}
		IF (-not (Test-Path -Path "$root\desktop.ini"))
		{
			Copy-Item -Path "$reg\desktop.ini" -Destination $root -Force
		}
		KnownFolderPath -KnownFolder Documents -Path $root
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{F42EE2D3-909F-4907-8871-4C22FC0BF756}" -PropertyType ExpandString -Value $root -Force
	}
}
# Downloads. Edit $folder variable first
# Загрузки. Сначала отредактируйте переменную $folder
$drive = Read-Host -Prompt "Type the drive letter in the root of which the `"Downloads`" folder will be created.
Press Enter to skip
`nВведите букву диска, в корне которого будет создана папка `"Загрузки`".
Чтобы пропустить, нажмите Enter"
IF ($drives -eq $drive)
{
	$drive = $(${drive}.ToUpper())
	$folder = "Загрузки"
	$root = "${drive}:\$folder"
	$reg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
	IF ($reg -ne $root)
	{
		IF (-not (Test-Path -Path $root))
		{
			New-Item -Path $root -ItemType Directory -Force
		}
		IF (-not (Test-Path -Path "$root\desktop.ini"))
		{
			Copy-Item -Path "$reg\desktop.ini" -Destination $root -Force
		}
		KnownFolderPath -KnownFolder Downloads -Path $root
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}" -PropertyType ExpandString -Value $root -Force
		# Edge
		$edge = (Get-AppxPackage "Microsoft.MicrosoftEdge").PackageFamilyName
		New-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\Main" -Name "Default Download Directory" -PropertyType String -Value $root -Force
	}
}
# Music. Edit $folder variable first
# Музыка. Сначала отредактируйте переменную $folder
$drive = Read-Host -Prompt "Type the drive letter in the root of which the `"Music`" folder will be created.
Press Enter to skip
`nВведите букву диска, в корне которого будет создана папка `"Музыка`".
Чтобы пропустить, нажмите Enter"
IF ($drives -eq $drive)
{
	$drive = $(${drive}.ToUpper())
	$folder = "Музыка"
	$root = "${drive}:\$folder"
	$reg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Music"
	IF ($reg -ne $root)
	{
		IF (-not (Test-Path -Path $root))
		{
			New-Item -Path $root -ItemType Directory -Force
		}
		IF (-not (Test-Path -Path "$root\desktop.ini"))
		{
			Copy-Item -Path "$reg\desktop.ini" -Destination $root -Force
		}
		KnownFolderPath -KnownFolder Music -Path $root
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{A0C69A99-21C8-4671-8703-7934162FCF1D}" -PropertyType ExpandString -Value $root -Force
	}
}
# Pictures. Edit $folder variable first
# Изображения. Сначала отредактируйте переменную $folder
$drive = Read-Host -Prompt "Type the drive letter in the root of which the `"Pictures`" folder will be created.
Press Enter to skip
`nВведите букву диска, в корне которого будет создана папка `"Изображения`".
Чтобы пропустить, нажмите Enter"
IF ($drives -eq $drive)
{
	$drive = $(${drive}.ToUpper())
	$folder = "Изображения"
	$root = "${drive}:\$folder"
	$reg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Pictures"
	IF ($reg -ne $root)
	{
		IF (-not (Test-Path -Path $root))
		{
			New-Item -Path $root -ItemType Directory -Force
		}
		IF (-not (Test-Path -Path "$root\desktop.ini"))
		{
			Copy-Item -Path "$reg\desktop.ini" -Destination $root -Force
		}
		KnownFolderPath -KnownFolder Pictures -Path $root
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{0DDD015D-B06C-45D5-8C4C-F59713854639}" -PropertyType ExpandString -Value $root -Force
	}
}
# Videos. Edit $folder variable first
# Видео. Сначала отредактируйте переменную $folder
$drive = Read-Host -Prompt "Type the drive letter in the root of which the `"Videos`" folder will be created.
Press Enter to skip
`nВведите букву диска, в корне которого будет создана папка `"Видео`".
Чтобы пропустить, нажмите Enter"
IF ($drives -eq $drive)
{
	$drive = $(${drive}.ToUpper())
	$folder = "Видео"
	$root = "${drive}:\$folder"
	$reg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Video"
	IF ($reg -ne $root)
	{
		IF (-not (Test-Path -Path $root))
		{
			New-Item -Path $root -ItemType Directory -Force
		}
		IF (-not (Test-Path -Path "$root\desktop.ini"))
		{
			Copy-Item -Path "$reg\desktop.ini" -Destination $root -Force
		}
		KnownFolderPath -KnownFolder Videos -Path $root
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{35286A68-3C57-41A1-BBB1-0EAE73D76C95}" -PropertyType ExpandString -Value $root -Force
	}
}
# Save screenshots by pressing Win+PrtScr to the Desktop
# Сохранить скриншот по Win+PrtScr на рабочем столе
$value = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Desktop
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{b7bede81-df94-4682-a7d8-57a52620b86f}" -Name RelativePath -PropertyType String -Value $value -Force
# Remove "$env:SystemDrive\PerfLogs"
# Удалить "$env:SystemDrive\PerfLogs"
Remove-Item $env:SystemDrive\PerfLogs -Recurse -Force -ErrorAction SilentlyContinue
# Remove "$env:LOCALAPPDATA\Temp"
# Удалить "$env:LOCALAPPDATA\Temp"
Remove-Item $env:LOCALAPPDATA\Temp -Recurse -Force -ErrorAction SilentlyContinue
# Remove "$env:SYSTEMROOT\Temp"
# Удалить "$env:SYSTEMROOT\Temp"
Restart-Service -ServiceName Spooler -Force
Remove-Item -Path "$env:SystemRoot\Temp" -Recurse -Force -ErrorAction SilentlyContinue
# Show more Windows Update restart notifications about restarting
# Показывать уведомление, когда компьютеру требуется перезагрузка для завершения обновления
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name RestartNotificationsAllowed2 -Value 1 -Force
# Set "High performance" in graphics performance preference for app
# Установить параметры производительности графики для отдельных приложений на "Высокая производительность"
IF ((Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType -ne 2 -and (Get-CimInstance -ClassName Win32_VideoController | Where-Object -FilterScript {$_.AdapterDACType -ne "Internal" -and $null -ne $_.AdapterDACType}))
{
	IF (Test-Path -Path "${env:ProgramFiles(x86)}\Steam")
	{
		Start-Process -FilePath "${env:ProgramFiles(x86)}\Steam\steamapps\common"
	}
	$exe = Read-Host -Prompt "Type full path to the app executable file for which you want to set graphics performance preference to `"High performance GPU`".
	Press Enter to skip
	`nВведите полный путь до исполняемого файла приложения, для которого следует установить`nпараметры производительности графики на `"Высокая производительность`".
	Чтобы пропустить, нажмите Enter"
	IF ($exe)
	{
		$exe = $exe.Replace('"', "")
		New-ItemProperty -Path HKCU:\Software\Microsoft\DirectX\UserGpuPreferences -Name $exe -PropertyType String -Value "GpuPreference=2;" -Force
	}
}
# Automatically adjust active hours for me based on daily usage
# Автоматически изменять период активности для этого устройства на основе действий
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name SmartActiveHoursState -Value 1 -Force
# Turn on automatic recommended troubleshooting
# Устранять проблемы без запроса
IF (-not (Test-Path -Path HKLM:\SOFTWARE\Microsoft\WindowsMitigation))
{
	New-Item -Path HKLM:\SOFTWARE\Microsoft\WindowsMitigation -Force
}
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsMitigation -Name UserPreference -Value 4 -Force
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
		IF ((Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online).State -eq "Enabled")
		{
			Enable-WindowsOptionalFeature –FeatureName Containers-DisposableClientVM -All -Online -NoRestart
		}
		else
		{
			Write-Output "Enable Virtualization in BIOS"
		}
	}
}
# Turn off reserved storage
# Отключить зарезервированное хранилище
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager -Name BaseHardReserveSize -PropertyType QWord -Value 0 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager -Name BaseSoftReserveSize -PropertyType QWord -Value 0 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager -Name HardReserveAdjustment -PropertyType QWord -Value 0 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager -Name MinDiskSize -PropertyType QWord -Value 0 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager -Name ShippedWithReserves -Value 0 -Force
# Launch folder in a separate process
# Запускать окна с папками в отдельном процессе
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SeparateProcess -Value 1 -Force
# Restart Start menu
# Перезапустить меню "Пуск"
Stop-Process -Name StartMenuExperienceHost -Force
# Restart File Explorer
# Перезапустить "File Explorer"
Stop-Process -Name explorer -Force
# Errors output
# Вывод ошибок
Write-Output ""
Write-Host Errors -BackgroundColor Red
($Error | Where-Object -FilterScript {$_ -notmatch "Taskmgr" -and $_ -notmatch "TaskManager"} | ForEach-Object {
	[PSCustomObject] @{
		Line = $_.InvocationInfo.ScriptLineNumber
		Error = $_.Exception.Message
	}
} | Format-Table -AutoSize -Wrap | Out-String).Trim()
