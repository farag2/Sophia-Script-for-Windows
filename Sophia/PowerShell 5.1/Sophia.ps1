<#
	.SYNOPSIS
	Default preset file for "Windows 10 Sophia Script"

	Version: v5.10.3
	Date: 27.04.2021

	Copyright (c) 2014–2021 farag
	Copyright (c) 2019–2021 farag & oZ-Zo

	Thanks to all https://forum.ru-board.com members involved

	.DESCRIPTION
	Place the "#" char before function if you don't want it to be run
	Remove the "#" char before function if you want it to be run
	Every tweak in the preset file has its' corresponding function to restore the default settings

	.EXAMPLE Run the whole script
	.\Sophia.ps1

	.EXAMPLE Run the script by specifying the module functions as an argument
	.\Sophia.ps1 -Functions "DiagTrackService -Disable", "DiagnosticDataLevel -Minimal", UninstallUWPApps

	.NOTES
	Supported Windows 10 versions
	Versions: 2004/20H2/21H1
	Builds: 19041/19042/19043
	Editions: Home/Pro/Enterprise
	Architecture: x64

	.NOTES
	Set execution policy to be able to run scripts only in the current PowerShell session:
		Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

	.NOTES
	Running the script is best done on a fresh install because running it on wrong tweaked system may result in errors occurring

	.NOTES
	To use the TAB completion for functions and their arguments dot source the Function.ps1 script first:
		. .\Function.ps1 (with a dot at the beginning)
	Read more in the Functions.ps1 file

	.NOTES
	https://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15
	https://habr.com/post/521202/
	https://forums.mydigitallife.net/threads/powershell-windows-10-sophia-script.81675/
	https://www.reddit.com/r/PowerShell/comments/go2n5v/powershell_script_setup_windows_10/

	.LINK Telegram channel & group
	https://t.me/sophianews
	https://t.me/sophia_chat

	.LINK
	https://github.com/farag2
	https://github.com/Inestic

	.LINK
	https://github.com/farag2/Windows-10-Sophia-Script
#>

#Requires -RunAsAdministrator
#Requires -Version 5.1

[CmdletBinding()]
param
(
	[Parameter(Mandatory = $false)]
	[string[]]
	$Functions
)

Clear-Host

$Host.UI.RawUI.WindowTitle = "Windows 10 Sophia Script v5.10.3 | Made with $([char]::ConvertFromUtf32(0x1F497)) of Windows 10 | $([char]0x00A9) farag & oz-zo, 2014–2021"

Remove-Module -Name Sophia -Force -ErrorAction Ignore
Import-Module -Name $PSScriptRoot\Sophia.psd1 -PassThru -Force

Import-LocalizedData -BindingVariable Global:Localization -FileName Sophia

<#
	.SYNOPSIS
	Run the script by specifying the module functions as an argument
	Запустить скрипт, указав в качестве аргумента функции модуля

	.EXAMPLE
	.\Sophia.ps1 -Functions "DiagTrackService -Disable", "DiagnosticDataLevel -Minimal", UninstallUWPApps

	.NOTES
	Separate functions with a comma
#>
if ($Functions)
{
	# Regardless of the functions entered as an argument, the "Checkings" function will be executed first,
	# and the "Refresh" and "Errors" functions will be executed at the end
	Invoke-Command -ScriptBlock {Checkings}

	foreach ($Function in $Functions)
	{
		Invoke-Expression -Command $Function
	}

	Invoke-Command -ScriptBlock {Refresh; Errors}

	exit
}

#region Protection
<#
	Checkings
	Please, do not touch this function

	Проверки
	Пожалуйста, не комментируйте данную функцию
#>
Checkings

<#
	Enable script logging. The log will be being recorded into the script folder
	To stop logging just close the console or type "Stop-Transcript"

	Включить логирование работы скрипта. Лог будет записываться в папку скрипта
	Чтобы остановить логгирование, закройте консоль или наберите "Stop-Transcript"
#>
# Logging

# Create a restore point
# Создать точку восстановления
CreateRestorePoint
#endregion Protection

#region Privacy & Telemetry
# Disable the DiagTrack service, and block connection for the Unified Telemetry Client Outbound Traffic
# Отключить службу DiagTrack и заблокировать соединение для исходящего трафик клиента единой телеметрии
DiagTrackService -Disable

# Enable the DiagTrack service, and allow connection for the Unified Telemetry Client Outbound Traffic
# Включить службу DiagTrack и разрешить соединение для исходящего трафик клиента единой телеметрии
# DiagTrackService -Enable

# Set the OS level of diagnostic data gathering to minimum
# Установить уровень сбора диагностических сведений ОС на минимальный
DiagnosticDataLevel -Minimal

# Set the default OS level of diagnostic data gathering
# Установить уровень сбора диагностических сведений ОС по умолчанию
# DiagnosticDataLevel -Default

# Turn off the Windows Error Reporting
# Отключить запись отчетов об ошибках Windows
ErrorReporting -Disable

# Turn on the Windows Error Reporting (default value)
# Включить отчеты об ошибках Windows (значение по умолчанию)
# ErrorReporting -Enable

# Change the Windows feedback frequency to "Never"
# Изменить частоту формирования отзывов на "Никогда"
WindowsFeedback -Disable

# Change the Windows Feedback frequency to "Automatically" (default value)
# Изменить частоту формирования отзывов на "Автоматически" (значение по умолчанию)
# WindowsFeedback -Enable

# Turn off the diagnostics tracking scheduled tasks
# Отключить задачи диагностического отслеживания
ScheduledTasks -Disable

# Turn on the diagnostics tracking scheduled tasks (default value)
# Включить задачи диагностического отслеживания (значение по умолчанию)
# ScheduledTasks -Enable

# Do not use sign-in info to automatically finish setting up device and reopen apps after an update or restart
# Не использовать данные для входа для автоматического завершения настройки устройства и открытия приложений после перезапуска или обновления
SigninInfo -Disable

# Use sign-in info to automatically finish setting up device and reopen apps after an update or restart (default value)
# Использовать данные для входа для автоматического завершения настройки устройства и открытия приложений после перезапуска или обновления (значение по умолчанию)
# SigninInfo -Enable

# Do not let websites provide locally relevant content by accessing language list
# Не позволять веб-сайтам предоставлять местную информацию за счет доступа к списку языков
LanguageListAccess -Disable

# Let websites provide locally relevant content by accessing language list (default value)
# Позволять веб-сайтам предоставлять местную информацию за счет доступа к списку языков (значение по умолчанию)
# LanguageListAccess -Enable

# Do not allow apps to use advertising ID
# Не разрешать приложениям использовать идентификатор рекламы
AdvertisingID -Disable

# Allow apps to use advertising ID (default value)
# Разрешать приложениям использовать идентификатор рекламы (значение по умолчанию)
# AdvertisingID -Enable

# Do not let apps on other devices open and message apps on this device, and vice versa
# Не разрешать приложениям на других устройствах запускать приложения и отправлять сообщения на этом устройстве и наоборот
ShareAcrossDevices -Disable

# Let apps on other devices open and message apps on this device, and vice versa (default value)
# Разрешать приложениям на других устройствах запускать приложения и отправлять сообщения на этом устройстве и наоборот (значение по умолчанию)
# ShareAcrossDevices -Enable

# Hide the Windows welcome experiences after updates and occasionally when I sign in to highlight what's new and suggested
# Скрывать экран приветствия Windows после обновлений и иногда при входе, чтобы сообщить о новых функциях и предложениях
WindowsWelcomeExperience -Hide

# Show the Windows welcome experiences after updates and occasionally when I sign in to highlight what's new and suggested (default value)
# Показывать экран приветствия Windows после обновлений и иногда при входе, чтобы сообщить о новых функциях и предложениях (значение по умолчанию)
# WindowsWelcomeExperience -Show

# Get tip, trick, and suggestions as you use Windows (default value)
# Получать советы, подсказки и рекомендации при использованию Windows (значение по умолчанию)
WindowsTips -Enable

# Do not get tip, trick, and suggestions as you use Windows
# Не получать советы, подсказки и рекомендации при использованию Windows
# WindowsTips -Disable

# Hide the suggested content in the Settings app
# Скрывать рекомендуемое содержимое в приложении "Параметры"
SettingsSuggestedContent -Hide

# Show the suggested content in the Settings app (default value)
# Показывать рекомендуемое содержимое в приложении "Параметры" (значение по умолчанию)
# SettingsSuggestedContent -Show

# Turn off the automatic installing suggested apps
# Отключить автоматическую установку рекомендованных приложений
AppsSilentInstalling -Disable

# Turn on automatic installing suggested apps (default value)
# Включить автоматическую установку рекомендованных приложений (значение по умолчанию)
# AppsSilentInstalling -Enable

# Do not suggest ways I can finish setting up my device to get the most out of Windows
# Не предлагать способы завершения настройки устройства для максимально эффективного использования Windows
WhatsNewInWindows -Disable

# Suggest ways I can finish setting up my device to get the most out of Windows (default value)
# Предлагать способы завершения настройки устройства для максимально эффективного использования Windows (значение по умолчанию)
# WhatsNewInWindows -Enable

# Do not offer tailored experiences based on the diagnostic data setting
# Не предлагать персонализированные возможности, основанные на выбранном параметре диагностических данных
TailoredExperiences -Disable

# Offer tailored experiences based on the diagnostic data setting (default value)
# Предлагать персонализированные возможности, основанные на выбранном параметре диагностических данных (значение по умолчанию)
# TailoredExperiences -Enable

# Disable Bing search in the Start Menu (for the USA only)
# Отключить в меню "Пуск" поиск через Bing (только для США)
BingSearch -Disable

# Enable Bing search in the Start Menu (default value)
# Включить поиск через Bing в меню "Пуск" (значение по умолчанию)
# BingSearch -Enable
#endregion Privacy & Telemetry

#region UI & Personalization
# Show the "This PC" icon on Desktop
# Отобразить значок "Этот компьютер" на рабочем столе
ThisPC -Show

# Hide the "This PC" icon on Desktop (default value)
# Скрывать "Этот компьютер" на рабочем столе (значение по умолчанию)
# ThisPC -Hide

# Do not use check boxes to select items
# Не использовать флажки для выбора элементов
CheckBoxes -Disable

# Use check boxes to select items (default value)
# Использовать флажки для выбора элементов (значение по умолчанию)
# CheckBoxes -Enable

# Show hidden files, folders, and drives
# Отображать скрытые файлы, папки и диски
HiddenItems -Enable

# Do not show hidden files, folders, and drives (default value)
# Не отображать скрытые файлы, папки и диски (значение по умолчанию)
# HiddenItems -Disable

# Show file name extensions
# Отображать расширения имён файлов
FileExtensions -Show

# Hide file name extensions (default value)
# Скрывать расширения имён файлов файлов (значение по умолчанию)
# FileExtensions -Hide

# Do not hide folder merge conflicts
# Не скрывать конфликт слияния папок
MergeConflicts -Show

# Hide folder merge conflicts (default value)
# Скрывать конфликт слияния папок (значение по умолчанию)
# MergeConflicts -Hide

# Open File Explorer to: "This PC"
# Открывать проводник для: "Этот компьютер"
OpenFileExplorerTo -ThisPC

# Open File Explorer to: Quick access (default value)
# Открывать проводник для: "Быстрый доступ" (значение по умолчанию)
# OpenFileExplorerTo -QuickAccess

# Hide Cortana button on the taskbar
# Скрывать кнопку Кортаны на панели задач
CortanaButton -Hide

# Show Cortana button on the taskbar (default value)
# Показать кнопку Кортаны на панели задач (значение по умолчанию)
# CortanaButton -Show

# Do not show sync provider notification within File Explorer
# Не показывать уведомления поставщика синхронизации в проводнике
OneDriveFileExplorerAd -Hide

# Show sync provider notification within File Explorer (default value)
# Показывать уведомления поставщика синхронизации в проводнике (значение по умолчанию)
# OneDriveFileExplorerAd -Show

# Hide Task View button on the taskbar
# Скрывать кнопку Просмотра задач
TaskViewButton -Hide

# Show Task View button on the taskbar (default value)
# Показывать кнопку Просмотра задач (значение по умолчанию)
# TaskViewButton -Show

# Hide People button on the taskbar
# Скрывать панель "Люди" на панели задач
PeopleTaskbar -Hide

# Show People button on the taskbar (default value)
# Показывать панель "Люди" на панели задач (значение по умолчанию)
# PeopleTaskbar -Show

# Show seconds on the taskbar clock
# Отображать секунды в системных часах на панели задач
SecondsInSystemClock -Show

# Hide seconds on the taskbar clock (default value)
# Скрывать секунды в системных часах на панели задач (значение по умолчанию)
# SecondsInSystemClock -Hide

# When I snap a window, do not show what I can snap next to it
# При прикреплении окна не показывать, что можно прикрепить рядом с ним
SnapAssist -Disable

# When I snap a window, show what I can snap next to it (default value)
# При прикреплении окна показывать, что можно прикрепить рядом с ним (значение по умолчанию)
# SnapAssist -Enable

# Show the file transfer dialog box in the detailed mode
# Отображать диалоговое окно передачи файлов в развернутом виде
FileTransferDialog -Detailed

# Show the file transfer dialog box in the compact mode (default value)
# Отображать диалоговое окно передачи файлов в свернутом виде (значение по умолчанию)
# FileTransferDialog -Compact

# Expand the File Explorer ribbon
# Развернуть ленту проводника
FileExplorerRibbon -Expanded

# Minimize the File Explorer ribbon (default value)
# Свернуть ленту проводника (значение по умолчанию)
# FileExplorerRibbon -Minimized

# Display the recycle bin files delete confirmation dialog
# Запрашивать подтверждение на удаление файлов в корзину
RecycleBinDeleteConfirmation -Enable

# Do not display the recycle bin files delete confirmation dialog (default value)
# Не запрашивать подтверждение на удаление файлов в корзину (значение по умолчанию)
# RecycleBinDeleteConfirmation -Disable

# Hide the "3D Objects" folder in "This PC" and Quick access
# Скрыть папку "Объемные объекты" в "Этот компьютер" и панели быстрого доступа
3DObjects -Hide

# Show the "3D Objects" folder in "This PC" and Quick access (default value)
# Отобразить папку "Объемные объекты" в "Этот компьютер" и панели быстрого доступа (значение по умолчанию)
# 3DObjects -Show

# Hide frequently used folders in Quick access
# Скрыть недавно используемые папки на панели быстрого доступа
QuickAccessFrequentFolders -Hide

# Show frequently used folders in Quick access (default value)
# Показать часто используемые папки на панели быстрого доступа (значение по умолчанию)
# QuickAccessFrequentFolders -Show

# Do not show recently used files in Quick access
# Не показывать недавно использовавшиеся файлы на панели быстрого доступа
QuickAccessRecentFiles -Hide

# Show recently used files in Quick access (default value)
# Показать недавно использовавшиеся файлы на панели быстрого доступа (значение по умолчанию)
# QuickAccessRecentFiles -Show

# Hide the search on the taskbar
# Скрыть поле или значок поиска на панели задач
TaskbarSearch -Hide

# Show the search icon on the taskbar
# Показать значок поиска на панели задач
# TaskbarSearch -SearchIcon

# Show the search box on the taskbar (default value)
# Показать поле поиска на панели задач (значение по умолчанию)
# TaskbarSearch -SearchBox

# Do not show the Windows Ink Workspace button on the taskbar
# Не показывать кнопку Windows Ink Workspace на панели задач
WindowsInkWorkspace -Hide

# Show Windows Ink Workspace button on the taskbar (default value)
# Показать кнопку Windows Ink Workspace на панели задач (значение по умолчанию)
# WindowsInkWorkspace -Show

# Always show all icons in the notification area
# Всегда отображать все значки в области уведомлений
TrayIcons -Show

# Do not show all icons in the notification area (default value)
# Не отображать все значки в области уведомлений (значение по умолчанию)
# TrayIcons -Hide

# Hide the Meet Now icon in the notification area
# Скрыть иконку "Провести собрание" в трее
MeetNow -Hide

# Show the Meet Now icon in the notification area
# Отобразить иконку "Провести собрание" в трее
# MeetNow -Show

# Unpin Microsoft Edge and Microsoft Store from the taskbar
# Открепить Microsoft Edge и Microsoft Store от панели задач
UnpinTaskbarEdgeStore

# View the Control Panel icons by: large icons
# Просмотр иконок Панели управления как: крупные значки
ControlPanelView -LargeIcons

# View the Control Panel icons by: small icons
# Просмотр иконок Панели управления как: маленькие значки
# ControlPanelView -SmallIcons

# View the Control Panel icons by: category (default value)
# Просмотр иконок Панели управления как: категория (значение по умолчанию)
# ControlPanelView -Category

# Set the Windows mode color scheme to the dark
# Установить цвет режима Windows по умолчанию на темный
WindowsColorScheme -Dark

# Set the Windows mode color scheme to the light
# Установить режим цвета для Windows на светлый
# WindowsColorScheme -Light

# Set the app mode color scheme to the dark
# Установить цвет режима приложений на темный
AppMode -Dark

# Set the app mode color scheme to the light
# Установить цвет режима приложений на светлый
# AppMode -Light

# Do not show the "New App Installed" indicator
# Не показывать уведомление "Установлено новое приложение"
NewAppInstalledNotification -Hide

# Show the "New App Installed" indicator (default value)
# Показывать уведомление "Установлено новое приложение" (значение по умолчанию)
# NewAppInstalledNotification -Show

# Hide first sign-in animation after the upgrade
# Скрывать анимацию при первом входе в систему после обновления
FirstLogonAnimation -Disable

# Show first sign-in animation after the upgrade (default value)
# Показывать анимацию при первом входе в систему после обновления (значение по умолчанию)
# FirstLogonAnimation -Enable

# Set the quality factor of the JPEG desktop wallpapers to maximum
# Установить коэффициент качества обоев рабочего стола в формате JPEG на максимальный
JPEGWallpapersQuality -Max

# Set the quality factor of the JPEG desktop wallpapers to default
# Установить коэффициент качества обоев рабочего стола в формате JPEG по умолчанию
# JPEGWallpapersQuality -Default

# Start Task Manager in expanded mode
# Запускать Диспетчера задач в развернутом виде
TaskManagerWindow -Expanded

# Start Task Manager in compact mode (default value)
# Запускать Диспетчера задач в свернутом виде (значение по умолчанию)
# TaskManagerWindow -Compact

# Show a notification when your PC requires a restart to finish updating
# Показывать уведомление, когда компьютеру требуется перезагрузка для завершения обновления
RestartNotification -Show

# Do not show a notification when your PC requires a restart to finish updating (default value)
# Не показывать уведомление, когда компьютеру требуется перезагрузка для завершения обновления (значение по умолчанию)
# RestartNotification -Hide

# Do not add the "- Shortcut" suffix to the file name of created shortcuts
# Нe дoбaвлять "- яpлык" к имени coздaвaeмых яpлыков
ShortcutsSuffix -Disable

# Add the "- Shortcut" suffix to the file name of created shortcuts (default value)
# Дoбaвлять "- яpлык" к имени coздaвaeмых яpлыков (значение по умолчанию)
# ShortcutsSuffix -Enable

# Use the PrtScn button to open screen snipping
# Использовать кнопку PRINT SCREEN, чтобы запустить функцию создания фрагмента экрана
PrtScnSnippingTool -Enable

# Do not use the PrtScn button to open screen snipping (default value)
# Не использовать кнопку PRINT SCREEN, чтобы запустить функцию создания фрагмента экрана (значение по умолчанию)
# PrtScnSnippingTool -Disable

# Let me use a different input method for each app window
# Позволить выбирать метод ввода для каждого окна
AppsLanguageSwitch -Enable

# Do not let use a different input method for each app window (default value)
# Не позволять выбирать метод ввода для каждого окна (значение по умолчанию)
# AppsLanguageSwitch -Disable
#endregion UI & Personalization

#region OneDrive
# Uninstall OneDrive
# Удалить OneDrive
OneDrive -Uninstall

# Install OneDrive (default value)
# Установить OneDrive (значение по умолчанию)
# OneDrive -Install
#endregion OneDrive

#region System
#region StorageSense
# Turn on Storage Sense
# Включить Контроль памяти
StorageSense -Enable

# Turn off Storage Sense (default value)
# Выключить Контроль памяти (значение по умолчанию)
# StorageSense -Disable

# Run Storage Sense every month
# Запускать Контроль памяти каждый месяц
StorageSenseFrequency -Month

# Run Storage Sense during low free disk space (default value)
# Запускать Контроль памяти, когда остается мало место на диске (значение по умолчанию)
# StorageSenseFrequency -Default

# Delete temporary files that apps aren't using
# Удалять временные файлы, не используемые в приложениях
StorageSenseTempFiles -Enable

# Do not delete temporary files that apps aren't using
# Не удалять временные файлы, не используемые в приложениях
# StorageSenseTempFiles -Disable

# Delete files in recycle bin if they have been there for over 30 days
# Удалять файлы из корзины, если они находятся в корзине более 30 дней
StorageSenseRecycleBin -Enable

# Do not delete files in recycle bin if they have been there for over 30 days
# Не удалять файлы из корзины, если они находятся в корзине более 30 дней
# StorageSenseRecycleBin -Disable
#endregion StorageSense

# Disable hibernation
# Отключить режим гибернации
Hibernate -Disable

# Enable hibernate (default value)
# Включить режим гибернации (значение по умолчанию)
# Hibernate -Enable

# Change the %TEMP% environment variable path to "%SystemDrive%\Temp"
# Изменить путь переменной среды для %TEMP% на "%SystemDrive%\Temp"
# TempFolder -SystemDrive

# Change %TEMP% environment variable path to "%LOCALAPPDATA%\Temp" (default value)
# Изменить путь переменной среды для %TEMP% на "LOCALAPPDATA%\Temp" (значение по умолчанию)
# TempFolder -Default

# Disable the Windows 260 characters path limit
# Отключить ограничение Windows на 260 символов в пути
Win32LongPathLimit -Disable

# Enable the Windows 260 character path limit (default value)
# Включить ограничение Windows на 260 символов в пути (значение по умолчанию)
# Win32LongPathLimit -Enable

# Display the Stop error information on the BSoD
# Отображать Stop-ошибку при появлении BSoD
BSoDStopError -Enable

# Do not display the Stop error information on the BSoD (default value)
# Не отображать Stop-ошибку при появлении BSoD (значение по умолчанию)
# BSoDStopError -Disable

# Choose when to be notified about changes to your computer: never notify
# Настройка уведомления об изменении параметров компьютера: никогда не уведомлять
AdminApprovalMode -Disable

# Choose when to be notified about changes to your computer: notify me only when apps try to make changes to my computer (default value)
# Настройка уведомления об изменении параметров компьютера: уведомлять меня только при попытках приложений внести изменения в компьютер (значение по умолчанию)
# AdminApprovalMode -Enable

# Turn on access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled
# Включить доступ к сетевым дискам при включенном режиме одобрения администратором при доступе из программ, запущенных с повышенными правами
MappedDrivesAppElevatedAccess -Enable

# Turn off access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled (default value)
# Выключить доступ к сетевым дискам при включенном режиме одобрения администратором при доступе из программ, запущенных с повышенными правами (значение по умолчанию)
# MappedDrivesAppElevatedAccess -Disable

# Turn off Delivery Optimization
# Выключить оптимизацию доставки
DeliveryOptimization -Disable

# Turn on Delivery Optimization (default value)
# Включить оптимизацию доставки (значение по умолчанию)
# DeliveryOptimization -Enable

# Always wait for the network at computer startup and logon for workgroup networks
# Всегда ждать сеть при запуске и входе в систему для рабочих групп
WaitNetworkStartup -Enable

# Never wait for the network at computer startup and logon for workgroup networks (default value)
# Никогда не ждать сеть при запуске и входе в систему для рабочих групп (значение по умолчанию)
# WaitNetworkStartup -Disable

# Do not let Windows decide which printer should be the default one
# Не разрешать Windows решать, какой принтер должен использоваться по умолчанию
WindowsManageDefaultPrinter -Disable

# Let Windows decide which printer should be the default one (default value)
# Разрешать Windows решать, какой принтер должен использоваться по умолчанию (значение по умолчанию)
# WindowsManageDefaultPrinter -Enable

<#
	Disable the Windows features using the pop-up dialog box
	Отключить компоненты Windows, используя всплывающее диалоговое окно

	If you want to leave "Multimedia settings" element in the advanced settings of Power Options do not disable the "MediaPlayback" feature
	Если вы хотите оставить параметр "Параметры мультимедиа" в дополнительных параметрах электропитания, не удаляйте отключайте "MediaPlayback"
#>
WindowsFeatures -Disable

# Enable the Windows features using the pop-up dialog box
# Включить компоненты Windows, используя всплывающее диалоговое окно
# WindowsFeatures -Enable

<#
	Uninstall optional features using the pop-up dialog box
	Удалить дополнительные компоненты, используя всплывающее диалоговое окно

	If you want to leave "Multimedia settings" element in the advanced settings of Power Options do not uninstall the "MediaPlayback" feature
	Если вы хотите оставить параметр "Параметры мультимедиа" в дополнительных параметрах электропитания, не удаляйте компонент "MediaPlayback"
#>
WindowsCapabilities -Uninstall

# Install optional features using the pop-up dialog box
# Установить дополнительные компоненты, используя всплывающее диалоговое окно
# WindowsCapabilities -Install

# Receive updates for other Microsoft products when you update Windows
# При обновлении Windows получать обновления для других продуктов Майкрософт
UpdateMicrosoftProducts -Enable

# Do not receive updates for other Microsoft products when you update Windows (default value)
# При обновлении Windows не получать обновления для других продуктов Майкрософт (значение по умолчанию)
# UpdateMicrosoftProducts -Disable

# Set the power management scheme on "High performance" if device is a desktop
# Установить схему управления питанием на "Высокая производительность", если устройство является стационарным ПК
PowerManagementScheme -High

# Set the power management scheme on "Balanced" (default value)
# Установить схему управления питанием на "Сбалансированная" (значение по умолчанию)
# PowerManagementScheme -Balanced

# Use latest installed .NET runtime for all apps
# Использовать последнюю установленную среду выполнения .NET для всех приложений
LatestInstalled.NET -Enable

# Do not use latest installed .NET runtime for all apps (default value)
# Не использовать последнюю установленную версию .NET для всех приложений (значение по умолчанию)
# LatestInstalled.NET -Disable

# Do not allow the computer to turn off the network adapters to save power
# Запретить отключение всех сетевых адаптеров для экономии энергии
PCTurnOffDevice -Disable

# Allow the computer to turn off the network adapters to save power (default value)
# Разрешить отключение всех сетевых адаптеров для экономии энергии (значение по умолчанию)
# PCTurnOffDevice -Enable

# Override for default input method: English
# Переопределить метод ввода по умолчанию: английский
SetInputMethod -English

# Override for default input method: use language list (default value)
# Переопределить метод ввода по умолчанию: использовать список языков (значение по умолчанию)
# SetInputMethod -Default

<#
	Move user folders location to the root of any drive using the interactive menu
	User files or folders won't me moved to a new location

	Переместить пользовательские папки в корень любого диска на выбор с помощью интерактивного меню
	Пользовательские файлы и папки не будут перемещены в новое расположение
#>
SetUserShellFolderLocation -Root

<#
	Select folders for user folders location manually using a folder browser dialog
	User files or folders won't me moved to a new location

	Выбрать папки для расположения пользовательских папок вручную, используя диалог "Обзор папок"
	Пользовательские файлы и папки не будут перемещены в новое расположение
#>
# SetUserShellFolderLocation -Custom

<#
	Change user folders location to the default values
	User files or folders won't me moved to the new location

	Изменить расположение пользовательских папок на значения по умолчанию
	Пользовательские файлы и папки не будут перемещены в новое расположение
#>
# SetUserShellFolderLocation -Default

# Save screenshots by pressing Win+PrtScr on the Desktop
# Сохранять скриншоты по нажатию Win+PrtScr на рабочий столе
WinPrtScrFolder -Desktop

# Save screenshots by pressing Win+PrtScr on the Pictures folder (default value)
# Cохранять скриншоты по нажатию Win+PrtScr в папку "Изображения" (значение по умолчанию)
# WinPrtScrFolder -Default

<#
	Run troubleshooters automatically, then notify
	In order this feature to work the OS level of diagnostic data gathering will be set to "Optional diagnostic data", and the error reporting feature will be turned on

	Автоматически запускать средства устранения неполадок, а затем уведомлять
	Чтобы заработала данная функция, уровень сбора диагностических сведений ОС будет установлен на "Необязательные диагностические данные" и включится создание отчетов об ошибках Windows
#>
RecommendedTroubleshooting -Automatic

<#
	Ask me before running troubleshooters (default value)
	In order this feature to work the OS level of diagnostic data gathering will be set to "Optional diagnostic data"

	Спрашивать перед запуском средств устранения неполадок (значение по умолчанию)
	Чтобы заработала данная функция, уровень сбора диагностических сведений ОС будет установлен на "Необязательные диагностические данные" и включится создание отчетов об ошибках Windows
#>
# RecommendedTroubleshooting -Default

# Launch folder windows in a separate process
# Запускать окна с папками в отдельном процессе
FoldersLaunchSeparateProcess -Enable

# Do not launch folder windows in a separate process (default value)
# Не запускать окна с папками в отдельном процессе (значение по умолчанию)
# FoldersLaunchSeparateProcess -Disable

# Disable and delete reserved storage after the next update installation
# Отключить и удалить зарезервированное хранилище после следующей установки обновлений
ReservedStorage -Disable

# Enable reserved storage (default value)
# Включить зарезервированное хранилище (значение по умолчанию)
# ReservedStorage -Enable

# Disable help look up via F1
# Отключить открытие справки по нажатию F1
F1HelpPage -Disable

# Enable help look up via F1 (default value)
# Включить открытие справки по нажатию F1 (значение по умолчанию)
# F1HelpPage -Enable

# Enable Num Lock at startup
# Включить Num Lock при загрузке
NumLock -Enable

# Disable Num Lock at startup (default value)
# Выключить Num Lock при загрузке (значение по умолчанию)
# NumLock -Disable

# Enable Caps Lock
# Включить Caps Lock
# CapsLock -Enable

# Disable Caps Lock (default value)
# Выключить Caps Lock (значение по умолчанию)
# CapsLock -Disable

# Disable StickyKey after tapping the Shift key 5 times
# Выключить залипание клавиши Shift после 5 нажатий
StickyShift -Disable

# Enable StickyKey after tapping the Shift key 5 times (default value)
# Включить залипание клавиши Shift после 5 нажатий (значение по умолчанию)
# StickyShift -Enable

# Disable AutoPlay for all media and devices
# Выключать автозапуск для всех носителей и устройств
Autoplay -Disable

# Enable AutoPlay for all media and devices (default value)
# Включить автозапуск для всех носителей и устройств (значение по умолчанию)
# Autoplay -Enable

# Disable thumbnail cache removal
# Отключить удаление кэша миниатюр
ThumbnailCacheRemoval -Disable

# Enable thumbnail cache removal (default value)
# Включить удаление кэша миниатюр (значение по умолчанию)
# ThumbnailCacheRemoval -Enable

# Enable automatically saving my restartable apps when signing out and restart them after signing in
# Включить автоматическое сохранение моих перезапускаемых приложений при выходе из системы и перезапускать их после выхода
SaveRestartableApps -Enable

# Disable automatically saving my restartable apps when signing out and restart them after signing in (default value)
# Выключить автоматическое сохранение моих перезапускаемых приложений при выходе из системы и перезапускать их после выхода (значение по умолчанию)
# SaveRestartableApps -Disable

# Enable "Network Discovery" and "File and Printers Sharing" for workgroup networks
# Включить сетевое обнаружение и общий доступ к файлам и принтерам для рабочих групп
NetworkDiscovery -Enable

# Disable "Network Discovery" and "File and Printers Sharing" for workgroup networks (default value)
# Выключить сетевое обнаружение и общий доступ к файлам и принтерам для рабочих групп (значение по умолчанию)
# NetworkDiscovery -Disable

# Automatically adjust active hours for me based on daily usage
# Автоматически изменять период активности для этого устройства на основе действий
SmartActiveHours -Enable

# Do not automatically adjust active hours for me based on daily usage (default value)
# Не изменять автоматически период активности для этого устройства на основе действий (значение по умолчанию)
# SmartActiveHours -Disable

# Restart this device as soon as possible when a restart is required to install an update
# Перезапускать это устройство как можно быстрее, если для установки обновления требуется перезагрузка
DeviceRestartAfterUpdate -Enable

# Do not restart this device as soon as possible when a restart is required to install an update (default value)
# Не перезапускать это устройство как можно быстрее, если для установки обновления требуется перезагрузка (значение по умолчанию)
# DeviceRestartAfterUpdate -Disable

<#
	Register app, calculate hash, and set as default for specific extension without the "How do you want to open this?" pop-up
	Зарегистрировать приложение, вычислить хэш и установить как приложение по умолчанию для конкретного расширения без всплывающего окна "Каким образом вы хотите открыть этот файл?"

	Examples:
	Примеры:
	Set-Association -ProgramPath "C:\SumatraPDF.exe" -Extension .pdf -Icon "shell32.dll,100"
	Set-Association -ProgramPath "%ProgramFiles%\Notepad++\notepad++.exe" -Extension .txt -Icon "%ProgramFiles%\Notepad++\notepad++.exe,0"
#>
# Set-Association -ProgramPath "%ProgramFiles%\Notepad++\notepad++.exe" -Extension .txt -Icon "%ProgramFiles%\Notepad++\notepad++.exe,0"
#endregion System

#region WSL
# Install the Windows Subsystem for Linux (WSL)
# Установить подсистему Windows для Linux (WSL)
# WSL -Enable

# Uninstall the Windows Subsystem for Linux (WSL)
# Удалить подсистему Windows для Linux (WSL)
# WSL -Disable

<#
	Download and install the Linux kernel update package
	Set WSL 2 as the default version when installing a new Linux distribution
	Run the function only after WSL installed and PC restart

	Скачать и установить пакет обновления ядра Linux
	Установить WSL 2 как версию по умолчанию при установке нового дистрибутива Linux
	Выполните функцию только после установки WSL и перезагрузка ПК
#>
# EnableWSL2
#endregion WSL

#region Start menu
# Hide recently added apps in the Start menu
# Скрывать недавно добавленные приложения в меню "Пуск"
RecentlyAddedApps -Hide

# Show recently added apps in the Start menu (default value)
# Показывать недавно добавленные приложения в меню "Пуск" (значение по умолчанию)
# RecentlyAddedApps -Show

# Hide app suggestions in the Start menu
# Скрывать рекомендации в меню "Пуск"
AppSuggestions -Hide

# Show app suggestions in the Start menu (default value)
# Показывать рекомендации в меню "Пуск" (значение по умолчанию)
# AppSuggestions -Show

# Run the Windows PowerShell shortcut from the Start menu as Administrator
# Запускать ярлык Windows PowerShell в меню "Пуск" от имени Администратора
RunPowerShellShortcut -Elevated

# Run the Windows PowerShell shortcut from the Start menu as user (default value)
# Запускать ярлык Windows PowerShell в меню "Пуск" от имени пользователя (значение по умолчанию)
# RunPowerShellShortcut -NonElevated

<#
	Pin to Start the following links: Control Panel, Devices and Printers, PowerShell
	Valid shortcuts values: ControlPanel, DevicesPrinters and PowerShell

	Закрепить на начальном экране следующие ярлыки: Панель управдения, Устройства и принтеры, PowerShell
	Валидные значения ярлыков: ControlPanel, DevicesPrinters, PowerShell
#>
PinToStart -Tiles ControlPanel, DevicesPrinters, PowerShell

<#
	Unpin all tiles first and pin necessary ones
	Открепить все ярлыки сначала и закрепить необходимые
#>
# PinToStart -UnpinAll -Tiles ControlPanel, DevicesPrinters, PowerShell

# Unpin all the Start tiles
# Открепить все ярлыки от начального экрана
# PinToStart -UnpinAll
#endregion Start menu

#region UWP apps
<#
	Uninstall UWP apps using the pop-up dialog box
	If the "For All Users" is checked apps packages will not be installed for new users

	Удалить UWP-приложения, используя всплывающее диалоговое окно
	Пакеты приложений не будут установлены для новых пользователей, если отмечена галочка "Для всех пользователей"
#>
UninstallUWPApps

<#
	Uninstall UWP apps using the pop-up dialog box
	If the "For All Users" is checked apps packages will not be installed for new users
	The "For All Users" checkbox checked by default

	Удалить UWP-приложения, используя всплывающее диалоговое окно
	Пакеты приложений не будут установлены для новых пользователей, если отмечена галочка "Для всех пользователей"
	Галочка "Для всех пользователей" отмечена по умолчанию
#>
# UninstallUWPApps -ForAllUsers

<#
	Restore the default UWP apps using the pop-up dialog box
	UWP apps can be restored only if they were uninstalled only for the current user

	Восстановить стандартные UWP-приложения, используя всплывающее диалоговое окно
	UWP-приложения могут быть восстановлены, только если они были удалены для текущего пользователя
#>
# RestoreUWPApps

<#
	Open Microsoft Store "HEVC Video Extensions from Device Manufacturer" page to install this extension manually to be able to open .heic and .heif formats
	The extension can be installed without Microsoft account

	Открыть страницу "Расширения для видео HEVC от производителя устройства" в Microsoft Store, чтобы вручную установить расширение для открытия форматов .heic и .heif
	Расширение может быть установлено бесплатно без учетной записи Microsoft
#>
# HEIF -Manual

# Download and install "HEVC Video Extensions from Device Manufacturer" to be able to open .heic and .heif formats
# Скачать и установить "Расширения для видео HEVC от производителя устройства", чтобы иметь возможность открывать форматы .heic и .heif
HEIF -Install

# Disable Cortana autostarting
# Выключить автозагрузку Кортана
CortanaAutostart -Disable

# Enable Cortana autostarting (default value)
# Включить автозагрузку Кортана (значение по умолчанию)
# CortanaAutostart -Enable

# Do not let UWP apps run in the background
# Не разрешать UWP-приложениям работать в фоновом режиме
BackgroundUWPApps -Disable

# Let all UWP apps run in the background (default value)
# Разрешить всем UWP-приложениям работать в фоновом режиме (значение по умолчанию)
# BackgroundUWPApps -Enable

# Check for UWP apps updates
# Проверить обновления UWP-приложений
CheckUWPAppsUpdates
#endregion UWP apps

#region Gaming
# Disable Xbox Game Bar
# Отключить Xbox Game Bar
XboxGameBar -Disable

# Enable Xbox Game Bar (default value)
# Включить Xbox Game Bar (значение по умолчанию)
# XboxGameBar -Enable

# Disable Xbox Game Bar tips
# Отключить советы Xbox Game Bar
XboxGameTips -Disable

# Enable Xbox Game Bar tips (default value)
# Включить советы Xbox Game Bar (значение по умолчанию)
# XboxGameTips -Enable

<#
	Set "High performance" in graphics performance preference for an app
	Only with a dedicated GPU

	Установить параметры производительности графики для отдельных приложений на "Высокая производительность"
	Только при наличии внешней видеокарты
#>
SetAppGraphicsPerformance

<#
	Turn on hardware-accelerated GPU scheduling. Restart needed
	Only with a dedicated GPU and WDDM verion is 2.7 or higher

	Включить планирование графического процессора с аппаратным ускорением. Необходима перезагрузка
	Только при наличии внешней видеокарты и WDDM версии 2.7 и выше
#>
GPUScheduling -Enable

# Turn off hardware-accelerated GPU scheduling (default value). Restart needed
# Выключить планирование графического процессора с аппаратным ускорением (значение по умолчанию). Необходима перезагрузка
# GPUScheduling -Disable
#endregion Gaming

#region Scheduled tasks
<#
	Create the "Windows Cleanup" scheduled task for cleaning up Windows unused files and updates
	A native interactive toast notification pops up every 30 days
	The task runs every 30 days

	Создать задачу "Windows Cleanup" по очистке неиспользуемых файлов и обновлений Windows в Планировщике заданий
	Нативный интерактивный тост всплывает каждые 30 дней
	Задача выполняется каждые 30 дней
#>
CleanupTask -Register

# Delete the "Windows Cleanup" and "Windows Cleanup Notification" scheduled tasks for cleaning up Windows unused files and updates
# Удалить задачи "Windows Cleanup" и "Windows Cleanup Notification" по очистке неиспользуемых файлов и обновлений Windows из Планировщика заданий
# CleanupTask -Delete

<#
	Create the "SoftwareDistribution" scheduled task for cleaning up the %SystemRoot%\SoftwareDistribution\Download folder
	The task will wait until the Windows Updates service finishes running
	The task runs every 90 days

	Создать задачу "SoftwareDistribution" по очистке папки %SystemRoot%\SoftwareDistribution\Download в Планировщике заданий
	Задача будет ждать, пока служба обновлений Windows не закончит работу
	Задача выполняется каждые 90 дней
#>
SoftwareDistributionTask -Register

# Delete the "SoftwareDistribution" scheduled task for cleaning up the %SystemRoot%\SoftwareDistribution\Download folder
# Удалить задачу "SoftwareDistribution" по очистке папки %SystemRoot%\SoftwareDistribution\Download из Планировщика заданий
# SoftwareDistributionTask -Delete

<#
	Create the "Temp" scheduled task for cleaning up the %TEMP% folder
	The task runs every 60 days

	Создать задачу "Temp" в Планировщике заданий по очистке папки %TEMP%
	Задача выполняется каждые 60 дней
#>
TempTask -Register

# Delete the "Temp" scheduled task for cleaning up the %TEMP% folder
# Удалить задачу "Temp" по очистке папки %TEMP% из Планировщика заданий
# TempTask -Delete
#endregion Scheduled tasks

#region Microsoft Defender & Security
# Enable Controlled folder access and add protected folders
# Включить контролируемый доступ к папкам и добавить защищенные папки
AddProtectedFolders

# Remove all added protected folders
# Удалить все добавленные защищенные папки
# RemoveProtectedFolders

# Allow an app through Controlled folder access
# Разрешить работу приложения через контролируемый доступ к папкам
AddAppControlledFolder

# Remove all allowed apps through Controlled folder access
# Удалить все добавленные разрешенные приложение через контролируемый доступ к папкам
# RemoveAllowedAppsControlledFolder

# Add a folder to the exclusion from Microsoft Defender scanning
# Добавить папку в список исключений сканирования Microsoft Defender
AddDefenderExclusionFolder

# Remove all excluded folders from Microsoft Defender scanning
# Удалить все папки из списка исключений сканирования Microsoft Defender
# RemoveDefenderExclusionFolders

# Add a file to the exclusion from Microsoft Defender scanning
# Добавить файл в список исключений сканирования Microsoft Defender
AddDefenderExclusionFile

# Remove all excluded files from Microsoft Defender scanning
# Удалить все файлы из списка исключений сканирования Microsoft Defender
# RemoveDefenderExclusionFiles

# Enable Microsoft Defender Exploit Guard network protection
# Включить защиту сети в Microsoft Defender Exploit Guard
NetworkProtection -Enable

# Disable Microsoft Defender Exploit Guard network protection (default value)
# Выключить защиту сети в Microsoft Defender Exploit Guard
# NetworkProtection -Disable

# Enable detection for potentially unwanted applications and block them
# Включить обнаружение потенциально нежелательных приложений и блокировать их
PUAppsDetection -Enable

# Disable detection for potentially unwanted applications and block them (default value)
# Выключить обнаружение потенциально нежелательных приложений и блокировать их (значение по умолчанию)
# PUAppsDetection -Disable

<#
	Enable sandboxing for Microsoft Defender
	There is a bug in KVM with QEMU: enabling this function causes VM to freeze up during the loading phase of Windows

	Включить песочницу для Microsoft Defender
	В KVM с QEMU присутствует баг: включение этой функции приводит ВМ к зависанию во время загрузки Windows
#>
DefenderSandbox -Enable

# Disable sandboxing for Microsoft Defender (default value)
# Выключить песочницу для Microsoft Defender (значение по умолчанию)
# DefenderSandbox -Disable

# Dismiss Microsoft Defender offer in the Windows Security about signing in Microsoft account
# Отклонить предложение Microsoft Defender в "Безопасность Windows" о входе в аккаунт Microsoft
DismissMSAccount

# Dismiss Microsoft Defender offer in the Windows Security about turning on the SmartScreen filter for Microsoft Edge
# Отклонить предложение Microsoft Defender в "Безопасность Windows" включить фильтр SmartScreen для Microsoft Edge
DismissSmartScreenFilter

# Enable events auditing generated when a process is created or starts
# Включить аудит событий, возникающих при создании или запуске процесса
AuditProcess -Enable

# Disable events auditing generated when a process is created or starts (default value)
# Выключить аудит событий, возникающих при создании или запуске процесса (значение по умолчанию)
# AuditProcess -Disable

<#
	Include command line in process creation events
	In order this feature to work events auditing will be enabled ("AuditProcess -Enable" function)

	Включать командную строку в событиях создания процесса
	Для того, чтобы работал данный функционал, будет включен аудит событий (функция "AuditProcess -Enable")
#>
AuditCommandLineProcess -Enable

# Do not include command line in process creation events (default value)
# Не включать командную строку в событиях создания процесса (значение по умолчанию)
# AuditCommandLineProcess -Disable

<#
	Create "Process Creation" Event Viewer Custom View
	In order this feature to work events auditing ("AuditProcess -Enable" function) and command line in process creation events will be enabled

	Создать настаиваемое представление "Создание процесса" в Просмотре событий
	Для того, чтобы работал данный функционал, буден включен аудит событий (функция "AuditProcess -Enable") и командной строки в событиях создания процесса
#>
EventViewerCustomView -Enable

# Remove "Process Creation" Event Viewer Custom View (default value)
# Удалить настаиваемое представление "Создание процесса" в Просмотре событий (значение по умолчанию)
# EventViewerCustomView -Disable

# Enable logging for all Windows PowerShell modules
# Включить ведение журнала для всех модулей Windows PowerShell
PowerShellModulesLogging -Enable

# Disable logging for all Windows PowerShell modules (default value)
# Выключить ведение журнала для всех модулей Windows PowerShell (значение по умолчанию)
# PowerShellModulesLogging -Disable

# Enable logging for all PowerShell scripts input to the Windows PowerShell event log
# Включить ведение журнала для всех вводимых сценариев PowerShell в журнале событий Windows PowerShell
PowerShellScriptsLogging -Enable

# Disable logging for all PowerShell scripts input to the Windows PowerShell event log (default value)
# Выключить ведение журнала для всех вводимых сценариев PowerShell в журнале событий Windows PowerShell (значение по умолчанию)
# PowerShellScriptsLogging -Disable

# Disable apps and files checking within Microsofot Defender SmartScreen
# Выключить проверку приложений и файлов фильтром SmartScreen в Microsoft Defender
AppsSmartScreen -Disable

# Enable apps and files checking within Microsofot Defender SmartScree (default value)
# Включить проверку приложений и файлов фильтром SmartScreen в Microsoft Defender (значение по умолчанию)
# AppsSmartScreen -Enable

# Disable the Attachment Manager marking files that have been downloaded from the Internet as unsafe
# Выключить проверку Диспетчером вложений файлов, скачанных из интернета, как небезопасные
SaveZoneInformation -Disable

# Enable the Attachment Manager marking files that have been downloaded from the Internet as unsafe (default value)
# Включить проверку Диспетчера вложений файлов, скачанных из интернета как небезопасные (значение по умолчанию)
# SaveZoneInformation -Enable

<#
	Disable Windows Script Host
	Blocks WSH from executing .js and .vbs files

	Отключить Windows Script Host
	Блокирует запуск файлов .js и .vbs
#>
# WindowsScriptHost -Disable

# Enable Windows Script Host (default value)
# Включить Windows Script Host (значение по умолчанию)
# WindowsScriptHost -Enable

# Enable Windows Sandbox
# Включить Windows Sandbox
# WindowsSandbox -Enable

# Disable Windows Sandbox (default value)
# Выключить Windows Sandbox (значение по умолчанию)
# WindowsSandbox -Disable
#endregion Microsoft Defender & Security

#region Context menu
# Add the "Extract all" item to Windows Installer (.msi) context menu
# Добавить пункт "Извлечь все" в контекстное меню Windows Installer (.msi)
MSIExtractContext -Add

# Remove the "Extract all" item from Windows Installer (.msi) context menu (default value)
# Удалить пункт "Извлечь все" из контекстного меню Windows Installer (.msi) (значение по умолчанию)
# MSIExtractContext -Remove

# Add the "Install" item to the .cab archives context menu
# Добавить пункт "Установить" в контекстное меню .cab архивов
CABInstallContext -Add

# Remove the "Install" item from the .cab archives context menu (default value)
# Удалить пункт "Установить" из контекстного меню .cab архивов (значение по умолчанию)
# CABInstallContext -Remove

# Add the "Run as different user" item to the .exe files types context menu
# Добавить пункт "Запуск от имени другого пользователя" в контекстного меню .exe файлов
RunAsDifferentUserContext -Add

# Remove the "Run as different user" item from the .exe files types context menu (default value)
# Удалить пункт "Запуск от имени другого пользователя" из контекстное меню .exe файлов (значение по умолчанию)
# RunAsDifferentUserContext -Remove

# Hide the "Cast to Device" item from the context menu
# Скрыть пункт "Передать на устройство" из контекстного меню
CastToDeviceContext -Hide

# Show the "Cast to Device" item in the context menu (default value)
# Показывать пункт "Передать на устройство" в контекстном меню (значение по умолчанию)
# CastToDeviceContext -Show

# Hide the "Share" item from the context menu
# Скрыть пункт "Отправить" (поделиться) из контекстного меню
ShareContext -Hide

# Show the "Share" item in the context menu (default value)
# Показывать пункт "Отправить" (поделиться) в контекстном меню (значение по умолчанию)
# ShareContext -Show

# Hide the "Edit with Paint 3D" item from the context menu
# Скрыть пункт "Изменить с помощью Paint 3D" из контекстного меню
EditWithPaint3DContext -Hide

# Show the "Edit with Paint 3D" item in the context menu (default value)
# Показывать пункт "Изменить с помощью Paint 3D" в контекстном меню (значение по умолчанию)
# EditWithPaint3DContext -Show

# Hide the "Edit with Photos" item from the context menu
# Скрыть пункт "Изменить с помощью приложения "Фотографии"" из контекстного меню
EditWithPhotosContext -Hide

# Show the "Edit with Photos" item in the context menu (default value)
# Показывать пункт "Изменить с помощью приложения "Фотографии"" в контекстном меню (значение по умолчанию)
# EditWithPhotosContext -Show

# Hide the "Create a new video" item from the context menu
# Скрыть пункт "Создать новое видео" из контекстного меню
CreateANewVideoContext -Hide

# Show the "Create a new video" item in the context menu (default value)
# Показывать пункт "Создать новое видео" в контекстном меню (значение по умолчанию)
# CreateANewVideoContext -Show

# Hide the "Edit" item from the images context menu
# Скрыть пункт "Изменить" из контекстного меню изображений
ImagesEditContext -Hide

# Show the "Edit" item from in images context menu (default value)
# Показывать пункт "Изменить" в контекстном меню изображений (значение по умолчанию)
# ImagesEditContext -Show

# Hide the "Print" item from the .bat and .cmd context menu
# Скрыть пункт "Печать" из контекстного меню .bat и .cmd файлов
PrintCMDContext -Hide

# Show the "Print" item in the .bat and .cmd context menu (default value)
# Показывать пункт "Печать" в контекстном меню .bat и .cmd файлов (значение по умолчанию)
# PrintCMDContext -Show

# Hide the "Include in Library" item from the context menu
# Скрыть пункт "Добавить в библиотеку" из контекстного меню
IncludeInLibraryContext -Hide

# Show the "Include in Library" item in the context menu (default value)
# Показывать пункт "Добавить в библиотеку" в контекстном меню (значение по умолчанию)
# IncludeInLibraryContext -Show

# Hide the "Send to" item from the folders context menu
# Скрыть пункт "Отправить" из контекстного меню папок
SendToContext -Hide

# Show the "Send to" item in the folders context menu (default value)
# Показывать пункт "Отправить" в контекстном меню папок (значение по умолчанию)
# SendToContext -Show

# Hide the "Turn on BitLocker" item from the context menu
# Скрыть пункт "Включить BitLocker" из контекстного меню
BitLockerContext -Hide

# Show the "Turn on BitLocker" item in the context menu (default value)
# Показывать пункт "Включить BitLocker" в контекстном меню (значение по умолчанию)
# BitLockerContext -Show

# Remove the "Bitmap image" item from the "New" context menu
# Удалить пункт "Точечный рисунок" из контекстного меню "Создать"
BitmapImageNewContext -Remove

# Add the "Bitmap image" item to the "New" context menu (default value)
# Восстановить пункт "Точечный рисунок" в контекстного меню "Создать" (значение по умолчанию)
# BitmapImageNewContext -Add

# Remove the "Rich Text Document" item from the "New" context menu
# Удалить пункт "Документ в формате RTF" из контекстного меню "Создать"
RichTextDocumentNewContext -Remove

# Add the "Rich Text Document" item to the "New" context menu (default value)
# Восстановить пункт "Документ в формате RTF" в контекстного меню "Создать" (значение по умолчанию)
# RichTextDocumentNewContext -Add

# Remove the "Compressed (zipped) Folder" item from the "New" context menu
# Удалить пункт "Сжатая ZIP-папка" из контекстного меню "Создать"
CompressedFolderNewContext -Remove

# Add the "Compressed (zipped) Folder" item to the "New" context menu (default value)
# Восстановить пункт "Сжатая ZIP-папка" в контекстном меню "Создать" (значение по умолчанию)
# CompressedFolderNewContext -Add

# Enable the "Open", "Print", and "Edit" context menu items for more than 15 items selected
# Включить элементы контекстного меню "Открыть", "Изменить" и "Печать" при выделении более 15 элементов
MultipleInvokeContext -Enable

# Disable the "Open", "Print", and "Edit" context menu items for more than 15 items selected (default value)
# Отключить элементы контекстного меню "Открыть", "Изменить" и "Печать" при выделении более 15 элементов (значение по умолчанию)
# MultipleInvokeContext -Disable

# Hide the "Look for an app in the Microsoft Store" item in the "Open with" dialog
# Скрыть пункт "Поиск приложения в Microsoft Store" в диалоге "Открыть с помощью"
UseStoreOpenWith -Hide

# Show the "Look for an app in the Microsoft Store" item in the "Open with" dialog (default value)
# Отображать пункт "Поиск приложения в Microsoft Store" в диалоге "Открыть с помощью" (значение по умолчанию)
# UseStoreOpenWith -Show

# Hide the "Previous Versions" tab from the files and folders context menu and the "Restore previous versions" context menu item
# Скрыть вкладку "Предыдущие версии" в свойствах файлов и папок, а также пункт контекстного меню "Восстановить прежнюю версию"
PreviousVersionsPage -Hide

# Show the "Previous Versions" tab from files and folders context menu and also the "Restore previous versions" context menu item (default value)
# Отображать вкладку "Предыдущие версии" в свойствах файлов и папок, а также пункт контекстного меню "Восстановить прежнюю версию" (значение по умолчанию)
# PreviousVersionsPage -Show
#endregion Context menu

<#
	Simulate pressing F5 to refresh the desktop
	Refresh desktop icons, environment variables, taskbar
	Restart the Start menu
	Please, do not touch this function

	Симулировать нажатие F5 для обновления рабочего стола
	Обновить иконки рабочего стола, переменные среды, панель задач
	Перезапустить меню "Пуск"
	Пожалуйста, не комментируйте данную функцию
#>
Refresh

<#
	Errors output
	Please, do not touch this function

	Вывод ошибок
	Пожалуйста, не комментируйте данную функцию
#>
Errors