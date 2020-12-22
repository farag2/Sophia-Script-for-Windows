<#
	.SYNOPSIS
	Default preset file for "Windows 10 Sophia Script"

	Version: v5.3.1
	Date: 21.12.2020
	Copyright (c) 2020 farag & oZ-Zo

	Thanks to all https://forum.ru-board.com members involved

	.DESCRIPTION
	Supported Windows 10 versions: 2004 (20H1)/2009 (20H2), 19041/19042, Home/Pro/Enterprise, x64

	Due to the fact that the script includes more than 150 functions with different arguments, you must read the entire Sophia.ps1 carefully and
	comment out/uncomment those functions that you do/do not want to be executed
	Every tweak in the preset file has its' corresponding function to restore the default settings

	Running the script is best done on a fresh install because running it on wrong tweaked system may result in errors occurring

	PowerShell must be run with elevated privileges
	Set execution policy to be able to run scripts only in the current PowerShell session:
		Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

	.EXAMPLE
	PS C:\> .\Sophia.ps1

	.NOTES
	https://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15
	https://habr.com/en/post/521202/
	https://forums.mydigitallife.net/threads/powershell-script-setup-windows-10.81675/
	https://www.reddit.com/r/PowerShell/comments/go2n5v/powershell_script_setup_windows_10/

	.LINK
	https://github.com/farag2/Windows-10-Sophia-Script
#>

#Requires -RunAsAdministrator
#Requires -Version 7.1

Clear-Host

$Host.UI.RawUI.WindowTitle = "Windows 10 Sophia Script v5.3.1 | ©️ farag & oz-zo, 2015–2020 | $((Invoke-WebRequest -Uri https://wttr.in/?format=3 -UseBasicParsing).Content) | Happy New Year!"

Remove-Module -Name Sophia -Force -ErrorAction Ignore
Import-Module -Name $PSScriptRoot\Sophia.psd1 -PassThru -Force

Import-LocalizedData -BindingVariable Global:Localization -FileName Sophia

# Checkings
# Проверки
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

#region Privacy & Telemetry
# Disable the "Connected User Experiences and Telemetry" service
# Отключить службу "Функциональные возможности для подключенных пользователей и телеметрия"
TelemetryService -Disable

# Enable the "Connected User Experiences and Telemetry" service (default value)
# Включить службу "Функциональные возможности для подключенных пользователей и телеметрия" (значение по умолчанию)
# TelemetryService -Enable

# Set the OS level of diagnostic data gathering to minimum
# Установить уровень сбора диагностических сведений ОС на минимальный
DiagnosticDataLevel -Minimal

# Set the default OS level of diagnostic data gathering
# Установить уровень сбора диагностических сведений ОС по умолчанию
# DiagnosticDataLevel -Default

# Turn off Windows Error Reporting for the current user
# Отключить отчеты об ошибках Windows для текущего пользователя
ErrorReporting -Disable

# Turn on Windows Error Reporting for the current user (default value)
# Включить отчеты об ошибках Windows для текущего пользователя (значение по умолчанию)
# ErrorReporting -Enable

# Change Windows feedback frequency to "Never" for the current user
# Изменить частоту формирования отзывов на "Никогда" для текущего пользователя
WindowsFeedback -Disable

# Change Windows Feedback frequency to "Automatically" for the current user (default value)
# Изменить частоту формирования отзывов на "Автоматически" для текущего пользователя (значение по умолчанию)
# WindowsFeedback -Enable

# Turn off diagnostics tracking scheduled tasks
# Отключить задачи диагностического отслеживания
ScheduledTasks -Disable

# Turn on diagnostics tracking scheduled tasks (default value)
# Включить задачи диагностического отслеживания (значение по умолчанию)
# ScheduledTasks -Enable

# Do not use sign-in info to automatically finish setting up device and reopen apps after an update or restart (current user only)
# Не использовать данные для входа для автоматического завершения настройки устройства и открытия приложений после перезапуска или обновления (только для текущего пользователя)
SigninInfo -Disable

# Use sign-in info to automatically finish setting up device and reopen apps after an update or restart (current user only) (default value)
# Использовать данные для входа для автоматического завершения настройки устройства и открытия приложений после перезапуска или обновления (только для текущего пользователя) (значение по умолчанию)
# SigninInfo -Enable

# Do not let websites provide locally relevant content by accessing language list (current user only)
# Не позволять веб-сайтам предоставлять местную информацию за счет доступа к списку языков (только для текущего пользователя)
LanguageListAccess -Disable

# Let websites provide locally relevant content by accessing language list (current user only) (default value)
# Позволять веб-сайтам предоставлять местную информацию за счет доступа к списку языков (только для текущего пользователя) (значение по умолчанию)
# LanguageListAccess -Enable

# Do not allow apps to use advertising ID (current user only)
# Не разрешать приложениям использовать идентификатор рекламы (только для текущего пользователя)
AdvertisingID -Disable

# Allow apps to use advertising ID (current user only) (default value)
# Разрешать приложениям использовать идентификатор рекламы (только для текущего пользователя) (значение по умолчанию)
# AdvertisingID -Enable

# Do not let apps on other devices open and message apps on this device, and vice versa (current user only)
# Не разрешать приложениям на других устройствах запускать приложения и отправлять сообщения на этом устройстве и наоборот (только для текущего пользователя)
ShareAcrossDevices -Disable

# Let apps on other devices open and message apps on this device, and vice versa (current user only) (default value)
# Разрешать приложениям на других устройствах запускать приложения и отправлять сообщения на этом устройстве и наоборот (только для текущего пользователя) (значение по умолчанию)
# ShareAcrossDevices -Enable

# Hide the Windows welcome experiences after updates and occasionally when I sign in to highlight what's new and suggested (current user only)
# Скрывать экран приветствия Windows после обновлений и иногда при входе, чтобы сообщить о новых функциях и предложениях (только для текущего пользователя)
WindowsWelcomeExperience -Hide

# Show the Windows welcome experiences after updates and occasionally when I sign in to highlight what's new and suggested (current user only) (default value)
# Показывать экран приветствия Windows после обновлений и иногда при входе, чтобы сообщить о новых функциях и предложениях (только для текущего пользователя) (значение по умолчанию)
# WindowsWelcomeExperience -Show

# Get tip, trick, and suggestions as you use Windows (current user only) (default value)
# Получать советы, подсказки и рекомендации при использованию Windows (только для текущего пользователя) (значение по умолчанию)
WindowsTips -Enable

# Do not get tip, trick, and suggestions as you use Windows (current user only)
# Не получать советы, подсказки и рекомендации при использованию Windows (только для текущего пользователя)
# WindowsTips -Disable

# Hide suggested content in the Settings app (current user only)
# Скрывать рекомендуемое содержимое в приложении "Параметры" (только для текущего пользователя)
SettingsSuggestedContent -Hide

# Show suggested content in the Settings app (current user only) (default value)
# Показывать рекомендуемое содержимое в приложении "Параметры" (только для текущего пользователя) (значение по умолчанию)
# SettingsSuggestedContent -Show

# Turn off automatic installing suggested apps (current user only)
# Отключить автоматическую установку рекомендованных приложений (только для текущего пользователя)
AppsSilentInstalling -Disable

# Turn on automatic installing suggested apps (current user only) (default value)
# Включить автоматическую установку рекомендованных приложений (только для текущего пользователя) (значение по умолчанию)
# AppsSilentInstalling -Enable

# Do not suggest ways I can finish setting up my device to get the most out of Windows (current user only)
# Не предлагать способы завершения настройки устройства для максимально эффективного использования Windows (только для текущего пользователя)
WhatsNewInWindows -Disable

# Suggest ways I can finish setting up my device to get the most out of Windows (default value)
# Предлагать способы завершения настройки устройства для максимально эффективного использования Windows (значение по умолчанию)
# WhatsNewInWindows -Enable

# Do not offer tailored experiences based on the diagnostic data setting (current user only)
# Не предлагать персонализированные возможности, основанные на выбранном параметре диагностических данных (только для текущего пользователя)
TailoredExperiences -Disable

# Offer tailored experiences based on the diagnostic data setting (default value)
# Предлагать персонализированные возможности, основанные на выбранном параметре диагностических данных (значение по умолчанию)
# TailoredExperiences -Enable

# Disable Bing search in the Start Menu (for the USA only)
# Отключить в меню "Пуск" поиск через Bing (только для США)
BingSearch -Disable

# Enable Bing search in the Start Menu (current user only) (default value)
# Включить поиск через Bing в меню "Пуск" (только для текущего пользователя) (значение по умолчанию)
# BingSearch -Enable
#endregion Privacy & Telemetry

#region UI & Personalization
# Show "This PC" on Desktop (current user only)
# Отобразить "Этот компьютер" на рабочем столе (только для текущего пользователя)
ThisPC -Show

# Hide "This PC" on Desktop (current user only) (default value)
# Скрывать "Этот компьютер" на рабочем столе (только для текущего пользователя) (значение по умолчанию)
# ThisPC -Hide

# Do not use check boxes to select items (current user only)
# Не использовать флажки для выбора элементов (только для текущего пользователя)
CheckBoxes -Disable

# Use check boxes to select items (current user only) (default value)
# Использовать флажки для выбора элементов (только для текущего пользователя) (значение по умолчанию)
# CheckBoxes -Enable

# Show hidden files, folders, and drives (current user only)
# Отображать скрытые файлы, папки и диски (только для текущего пользователя)
HiddenItems -Enable

# Do not show hidden files, folders, and drives (current user only) (default value)
# Не отображать скрытые файлы, папки и диски (только для текущего пользователя) (значение по умолчанию)
# HiddenItems -Disable

# Show file name extensions (current user only)
# Отображать расширения имён файлов (только для текущего пользователя)
FileExtensions -Show

# Hide file name extensions (current user only) (default value)
# Скрывать расширения имён файлов файлов (только для текущего пользователя) (значение по умолчанию)
# FileExtensions -Hide

# Do not hide folder merge conflicts (current user only)
# Не скрывать конфликт слияния папок (только для текущего пользователя)
MergeConflicts -Show

# Hide folder merge conflicts (current user only) (default value)
# Скрывать конфликт слияния папок (только для текущего пользователя) (значение по умолчанию)
# MergeConflicts -Hide

# Open File Explorer to: "This PC" (current user only)
# Открывать проводник для: "Этот компьютер" (только для текущего пользователя)
OpenFileExplorerTo -ThisPC

# Open File Explorer to: "Quick access" (current user only) (default value)
# Открывать проводник для: "Быстрый доступ" (только для текущего пользователя) (значение по умолчанию)
# OpenFileExplorerTo -QuickAccess

# Hide Cortana button on the taskbar (current user only)
# Скрывать кнопку Кортаны на панели задач (только для текущего пользователя)
CortanaButton -Hide

# Show Cortana button on the taskbar (current user only) (default value)
# Показать кнопку Кортаны на панели задач (только для текущего пользователя) (значение по умолчанию)
# CortanaButton -Show

# Do not show sync provider notification within File Explorer (current user only)
# Не показывать уведомления поставщика синхронизации в проводнике (только для текущего пользователя)
OneDriveFileExplorerAd -Hide

# Show sync provider notification within File Explorer (current user only) (default value)
# Показывать уведомления поставщика синхронизации в проводнике (только для текущего пользователя) (значение по умолчанию)
# OneDriveFileExplorerAd -Show

# Hide Task View button on the taskbar (current user only)
# Скрывать кнопку Просмотра задач (только для текущего пользователя)
TaskViewButton -Hide

# Show Task View button on the taskbar (current user only) (default value)
# Показывать кнопку Просмотра задач (только для текущего пользователя) (значение по умолчанию)
# TaskViewButton -Show

# Hide People button on the taskbar (current user only)
# Скрывать панель "Люди" на панели задач (только для текущего пользователя)
PeopleTaskbar -Hide

# Show People button on the taskbar (current user only) (default value)
# Показывать панель "Люди" на панели задач (только для текущего пользователя) (значение по умолчанию)
# PeopleTaskbar -Show

# Show seconds on the taskbar clock (current user only)
# Отображать секунды в системных часах на панели задач (только для текущего пользователя)
SecondsInSystemClock -Show

# Hide seconds on the taskbar clock (current user only) (default value)
# Скрывать секунды в системных часах на панели задач (только для текущего пользователя) (значение по умолчанию)
# SecondsInSystemClock -Hide

# When I snap a window, do not show what I can snap next to it (current user only)
# При прикреплении окна не показывать, что можно прикрепить рядом с ним (только для текущего пользователя)
SnapAssist -Disable

# When I snap a window, show what I can snap next to it (current user only) (default value)
# При прикреплении окна не показывать/показывать, что можно прикрепить рядом с ним (только для текущего пользователя) (значение по умолчанию)
# SnapAssist -Enable

# Always open the file transfer dialog box in the detailed mode (current user only)
# Всегда открывать диалоговое окно передачи файлов в развернутом виде (только для текущего пользователя)
FileTransferDialog -Detailed

# Always open the file transfer dialog box in the compact mode (current user only) (default value)
# Всегда открывать диалоговое окно передачи файлов в свернутом виде (только для текущего пользователя) (значение по умолчанию)
# FileTransferDialog -Compact

# Always expand the ribbon in the File Explorer (current user only)
# Всегда разворачивать ленту в проводнике (только для текущего пользователя)
FileExplorerRibbon -Expanded

# Always minimize the ribbon in the File Explorer (current user only) (default value)
# Не отображать ленту проводника в развернутом виде (только для текущего пользователя) (значение по умолчанию)
# FileExplorerRibbon -Minimized

# Display recycle bin files delete confirmation
# Запрашивать подтверждение на удаление файлов в корзину
RecycleBinDeleteConfirmation -Enable

# Do not display recycle bin files delete confirmation (default value)
# Не запрашивать подтверждение на удаление файлов в корзину (значение по умолчанию)
# RecycleBinDeleteConfirmation -Disable

# Hide the "3D Objects" folder in "This PC" and "Quick access" (current user only)
# Скрыть папку "Объемные объекты" в "Этот компьютер" и панели быстрого доступа (только для текущего пользователя)
3DObjects -Hide

# Show the "3D Objects" folder in "This PC" and "Quick access" (current user only) (default value)
# Отобразить папку "Объемные объекты" в "Этот компьютер" и панели быстрого доступа (только для текущего пользователя) (значение по умолчанию)
# 3DObjects -Show

# Hide frequently used folders in "Quick access" (current user only)
# Скрыть недавно используемые папки на панели быстрого доступа (только для текущего пользователя)
QuickAccessFrequentFolders -Hide

# Show frequently used folders in "Quick access" (current user only) (default value)
# Показывать недавно используемые папки на панели быстрого доступа (только для текущего пользователя) (значение по умолчанию)
# QuickAccessFrequentFolders -Show

# Do not show recently used files in Quick access (current user only)
# Не показывать недавно использовавшиеся файлы на панели быстрого доступа (только для текущего пользователя)
QuickAccessRecentFiles -Hide

# Show recently used files in Quick access (current user only) (default value)
# Показывать недавно использовавшиеся файлы на панели быстрого доступа (только для текущего пользователя) (значение по умолчанию)
# QuickAccessRecentFiles -Show

# Hide the search box or the search icon from the taskbar (current user only)
# Скрыть поле или значок поиска на панели задач (только для текущего пользователя)
TaskbarSearch -Hide

# Show the search box on the taskbar (current user only)
# Показать поле поиска на панели задач (только для текущего пользователя)
# TaskbarSearch -SearchIcon

# Show the search icon on the taskbar (current user only) (default value)
# Показать поле поиска на панели задач (только для текущего пользователя) (значение по умолчанию)
# TaskbarSearch -SearchBox

# Do not show the "Windows Ink Workspace" button on the taskbar (current user only)
# Не показывать кнопку Windows Ink Workspace на панели задач (current user only)
WindowsInkWorkspace -Hide

# Show the "Windows Ink Workspace" button in taskbar (current user only) (default value)
# Показывать кнопку Windows Ink Workspace на панели задач (current user only) (значение по умолчанию)
# WindowsInkWorkspace -Show

# Always show all icons in the notification area (current user only)
# Всегда отображать все значки в области уведомлений (только для текущего пользователя)
TrayIcons -Show

# Do not show all icons in the notification area (current user only) (default value)
# Не отображать все значки в области уведомлений (только для текущего пользователя) (значение по умолчанию)
# TrayIcons -Hide

# Unpin "Microsoft Edge" and "Microsoft Store" from the taskbar (current user only)
# Открепить Microsoft Edge и Microsoft Store от панели задач (только для текущего пользователя)
UnpinTaskbarEdgeStore

# View the Control Panel icons by: large icons (current user only)
# Просмотр иконок Панели управления как: крупные значки (только для текущего пользователя)
ControlPanelView -LargeIcons

# View the Control Panel icons by: category (current user only) (default value)
# Просмотр значки Панели управления как "категория" (только для текущего пользователя) (значение по умолчанию)
# ControlPanelView -Category

# Set the Windows mode color scheme to the dark (current user only)
# Установить цвет режима Windows по умолчанию на темный (только для текущего пользователя)
WindowsColorScheme -Dark

# Set the Windows mode color scheme to the light (current user only)
# Установить режим цвета для Windows на светлый (только для текущего пользователя)
# WindowsColorScheme -Light

# Set the default app mode color scheme to the dark (current user only)
# Установить цвет режима приложений по умолчанию на темный (только для текущего пользователя)
AppMode -Dark

# Set the default app mode color scheme to the light (current user only)
# Установить цвет режима приложений по умолчанию на светлый (только для текущего пользователя)
# AppMode -Light

# Do not show the "New App Installed" indicator
# Не показывать уведомление "Установлено новое приложение"
NewAppInstalledNotification -Hide

# Show the "New App Installed" indicator (default value)
# Показывать уведомление "Установлено новое приложение" (значение по умолчанию)
# NewAppInstalledNotification -Show

# Hide user first sign-in animation after the upgrade
# Скрывать анимацию при первом входе в систему после обновления
FirstLogonAnimation -Disable

# Show user first sign-in animation after the upgrade (default value)
# Показывать анимацию при первом входе в систему после обновления (значение по умолчанию)
# FirstLogonAnimation -Enable

# Set the quality factor of the JPEG desktop wallpapers to maximum (current user only)
# Установить коэффициент качества обоев рабочего стола в формате JPEG на максимальный (только для текущего пользователя)
JPEGWallpapersQuality -Max

# Set the quality factor of the JPEG desktop wallpapers to default (current user only)
# Установить коэффициент качества обоев рабочего стола в формате JPEG по умолчанию (только для текущего пользователя)
# JPEGWallpapersQuality -Default

# Start Task Manager in expanded mode (current user only)
# Запускать Диспетчера задач в развернутом виде (только для текущего пользователя)
TaskManagerWindow -Expanded

# Start Task Manager in compact mode (current user only) (default value)
# Запускать Диспетчера задач в свернутом виде (только для текущего пользователя) (значение по умолчанию)
# TaskManagerWindow -Compact

# Show a notification when your PC requires a restart to finish updating
# Показывать уведомление, когда компьютеру требуется перезагрузка для завершения обновления
RestartNotification -Show

# Do not show a notification when your PC requires a restart to finish updating (default value)
# Не показывать уведомление, когда компьютеру требуется перезагрузка для завершения обновления (значение по умолчанию)
# RestartNotification -Hide

# Do not add the "- Shortcut" suffix to the file name of created shortcuts (current user only)
# Нe дoбaвлять "- яpлык" к имени coздaвaeмых яpлыков (только для текущего пользователя)
ShortcutsSuffix -Disable

# Add the "- Shortcut" suffix to the file name of created shortcuts (current user only) (default value)
# Дoбaвлять "- яpлык" к имени coздaвaeмых яpлыков (только для текущего пользователя) (значение по умолчанию)
# ShortcutsSuffix -Enable

# Use the PrtScn button to open screen snipping (current user only)
# Использовать кнопку PRINT SCREEN, чтобы запустить функцию создания фрагмента экрана (только для текущего пользователя)
PrtScnSnippingTool -Enable

# Do not use the PrtScn button to open screen snipping (current user only) (default value)
# Не использовать кнопку PRINT SCREEN, чтобы запустить функцию создания фрагмента экрана (только для текущего пользователя) (значение по умолчанию)
# PrtScnSnippingTool -Disable

# Let me use a different input method for each app window (current user only)
# Позволить выбирать метод ввода для каждого окна (только для текущего пользователя)
AppsLanguageSwitch -Disable

# Do not let use a different input method for each app window (current user only) (default value)
# Не позволять выбирать метод ввода для каждого окна (только для текущего пользователя) (значение по умолчанию)
# AppsLanguageSwitch -Enable
#endregion UI & Personalization

#region OneDrive
# Uninstall OneDrive
# Удалить OneDrive
UninstallOneDrive

# Install OneDrive (current user only) (default value)
# Установить OneDrive (только для текущего пользователя) (значение по умолчанию)
# InstallOneDrive
#endregion OneDrive

#region System
#region StorageSense
# Turn on Storage Sense (current user only)
# Включить Контроль памяти (только для текущего пользователя)
StorageSense -Enable

# Turn off Storage Sense (current user only) (default value)
# Выключить Контроль памяти (только для текущего пользователя) (значение по умолчанию)
# StorageSense -Disable

# Run Storage Sense every month (current user only)
# Запускать Контроль памяти каждый месяц (только для текущего пользователя)
StorageSenseFrequency -Month

# Run Storage Sense during low free disk space (default value) (current user only)
# Запускать Контроль памяти, когда остается мало место на диске (значение по умолчанию) (только для текущего пользователя)
# StorageSenseFrequency -Default

# Delete temporary files that apps aren't using (current user only)
# Удалять временные файлы, не используемые в приложениях (только для текущего пользователя)
StorageSenseTempFiles -Enable

# Do not delete temporary files that apps aren't using (current user only)
# Не удалять временные файлы, не используемые в приложениях (только для текущего пользователя)
# StorageSenseTempFiles -Disable

# Delete files in recycle bin if they have been there for over 30 days (current user only)
# Удалять файлы из корзины, если они находятся в корзине более 30 дней (только для текущего пользователя)
StorageSenseRecycleBin -Enable

# Do not delete files in recycle bin if they have been there for over 30 days (current user only)
# Не удалять файлы из корзины, если они находятся в корзине более 30 дней (только для текущего пользователя)
# StorageSenseRecycleBin -Disable
#endregion StorageSense

# Disable hibernation if the device is not a laptop
# Отключить режим гибернации, если устройство не является ноутбуком
Hibernate -Disable

# Enable hibernate (default value)
# Включить режим гибернации (значение по умолчанию)
# Hibernate -Enable

# Change the %TEMP% environment variable path to "%SystemDrive%\Temp" (both machine-wide, and for the current user)
# Изменить путь переменной среды для %TEMP% на "%SystemDrive%\Temp" (для всех пользователей)
# TempFolder -SystemDrive

# Change %TEMP% environment variable path to "%LOCALAPPDATA%\Temp" (both machine-wide, and for the current user) (default value)
# Изменить путь переменной среды для %TEMP% на "LOCALAPPDATA%\Temp" (для всех пользователей) (значение по умолчанию)
# TempFolder -Default

# Disable Windows 260 characters path limit
# Отключить ограничение Windows на 260 символов в пути
Win32LongPathLimit -Disable

# Enable Windows 260 character path limit (default value)
# Включить ограничение Windows на 260 символов в пути (значение по умолчанию)
# Win32LongPathLimit -Enable

# Display the Stop error information on the BSoD
# Отображать Stop-ошибку при появлении BSoD
BSoDStopError -Enable

# Do not display the Stop error information on the BSoD (default value)
# Не отображать Stop-ошибку при появлении BSoD (значение по умолчанию)
# BSoDStopError -Disable

# Change "Behavior of the elevation prompt for administrators in Admin Approval Mode" to "Elevate without prompting"
# Изменить "Поведение запроса на повышение прав для администраторов в режиме одобрения администратором" на "Повышение прав без запроса"
AdminApprovalMode -Disable

# Change "Behavior of the elevation prompt for administrators in Admin Approval Mode" to "Prompt for consent for non-Windows binaries" (default value)
# Изменить "Поведение запроса на повышение прав для администраторов в режиме одобрения администратором" на "Запрос согласия для исполняемых файлов, отличных от Windows" (значение по умолчанию)
# AdminApprovalMode -Enable

# Turn on access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled
# Включить доступ к сетевым дискам при включенном режиме одобрения администратором при доступе из программ, запущенных с повышенными правами
MappedDrivesAppElevatedAccess -Enable

# Turn off access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled (default value)
# Выключить доступ к сетевым дискам при включенном режиме одобрения администратором при доступе из программ, запущенных с повышенными правами (значение по умолчанию)
# MappedDrivesAppElevatedAccess -Disable

# Opt out of the Delivery Optimization-assisted updates downloading
# Отказаться от загрузки обновлений с помощью оптимизации доставки
DeliveryOptimization -Disable

# Opt-in to the Delivery Optimization-assisted updates downloading (default value)
# Включить загрузку обновлений с помощью оптимизации доставки (значение по умолчанию)
# DeliveryOptimization -Enable

# Always wait for the network at computer startup and logon for workgroup networks
# Всегда ждать сеть при запуске и входе в систему для рабочих групп
WaitNetworkStartup -Enable

# Never wait for the network at computer startup and logon for workgroup networks (default value)
# Никогда не ждать сеть при запуске и входе в систему для рабочих групп (значение по умолчанию)
# WaitNetworkStartup -Disable

# Do not let Windows decide which printer should be the default one (current user only)
# Не разрешать Windows решать, какой принтер должен использоваться по умолчанию (только для текущего пользователя)
WindowsManageDefaultPrinter -Disable

# Let Windows decide which printer should be the default one (current user only) (default value)
# Разрешать Windows решать, какой принтер должен использоваться по умолчанию (только для текущего пользователя) (значение по умолчанию)
# WindowsManageDefaultPrinter -Enable

# Disable the Windows features using the pop-up dialog box that enables the user to select features to remove
# Отключить компоненты Windows, используя всплывающее диалоговое окно, позволяющее пользователю отметить компоненты на удаление
WindowsFeatures -Disable

# Enable the Windows features using the pop-up dialog box that enables the user to select features to remove
# Включить компоненты Windows, используя всплывающее диалоговое окно, позволяющее пользователю отметить компоненты на удаление
# WindowsFeatures -Enable

# Disable Features On Demand v2 (FODv2) capabilities using the pop-up dialog box
# Отключить компоненты "Функции по требованию" (FODv2), используя всплывающее диалоговое окно
WindowsCapabilities -Disable

# Enable Feature On Demand v2 (FODv2) capabilities using the pop-up dialog box
# Включить компоненты "Функции по требованию" (FODv2), используя всплывающее диалоговое окно
# WindowsCapabilities -Enable

# Opt-in to Microsoft Update service, so to receive updates for other Microsoft products
# Подключаться к службе Microsoft Update так, чтобы при обновлении Windows получать обновления для других продуктов Майкрософт
UpdateMicrosoftProducts -Enable

# Opt-out of Microsoft Update service, so not to receive updates for other Microsoft products (default value)
# Не подключаться к службе Microsoft Update так, чтобы при обновлении Windows не получать обновления для других продуктов Майкрософт (значение по умолчанию)
# UpdateMicrosoftProducts -Disable

# Do not let all UWP apps run in the background (current user only)
# Не разрешать всем UWP-приложениям работать в фоновом режиме (только для текущего пользователя)
BackgroundUWPApps -Disable

# Let all UWP apps run in the background (current user only) (default value)
# Разрешить всем UWP-приложениям работать в фоновом режиме (только для текущего пользователя) (значение по умолчанию)
# BackgroundUWPApps -Enable

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

# Do not allow the computer (if device is not a laptop) to turn off the network adapters to save power
# Запретить отключение всех сетевых адаптеров для экономии энергии (если устройство не является ноутбуком)
PCTurnOffDevice -Disable

# Allow the computer to turn off the network adapters to save power (default value)
# Разрешить отключение всех сетевых адаптеров для экономии энергии (значение по умолчанию)
# PCTurnOffDevice -Enable

# Set the default input method to the English language
# Установить метод ввода по умолчанию на английский язык
SetInputMethod -English

# Reset the default input method
# Сбросить метод ввода по умолчанию
# SetInputMethod -Default

<#
	Change the location of the user folders to any disks root of your choice using the interactive menu (current user only)
	User files or folders won't me moved to a new location

	Изменить расположение пользовательских папок в корень любого диска на выбор с помощью интерактивного меню (только для текущего пользователя)
	Пользовательские файлы и папки не будут перемещены в новое расположение
#>
SetUserShellFolderLocation -Root

<#
	Select a folder for the location of the user folders manually using a folder browser dialog (current user only)
	User files or folders won't me moved to a new location

	Выбрать папку для расположения пользовательских папок вручную, используя диалог "Обзор папок" (только для текущего пользователя)
	Пользовательские файлы и папки не будут перемещены в новое расположение
#>
# SetUserShellFolderLocation -Custom

<#
	Change the location of the user folders to the default values (current user only)
	User files or folders won't me moved to the new location

	Изменить расположение пользовательских папок на значения по умолчанию (только для текущего пользователя)
	Пользовательские файлы и папки не будут перемещены в новое расположение
#>
# SetUserShellFolderLocation -Default

# Save screenshots by pressing Win+PrtScr to the Desktop folder (current user only)
# Сохранять скриншоты по нажатию Win+PrtScr в папку "рабочий стол" (только для текущего пользователя)
WinPrtScrFolder -Desktop

# Save screenshots by pressing Win+PrtScr to the Pictures folder (current user only) (default value)
# Cохранять скриншоты по нажатию Win+PrtScr в папку "Изображения" (только для текущего пользователя) (значение по умолчанию)
# WinPrtScrFolder -Default

<#
	Run troubleshooters automatically, then notify
	In order this feature to work the OS level of diagnostic data gathering must be set to "Optional diagnostic data"

	Автоматически запускать средства устранения неполадок, а затем уведомлять
	Необходимо установить уровень сбора диагностических сведений ОС на "Необязательные диагностические данные", чтобы работала данная функция
#>
RecommendedTroubleshooting -Automatic

<#
	Ask me before running troubleshooters (default value)
	In order this feature to work the OS level of diagnostic data gathering must be set to "Optional diagnostic data"

	Спрашивать перед запуском средств устранения неполадок (значение по умолчанию)
	Необходимо установить уровень сбора диагностических сведений ОС на "Необязательные диагностические данные", чтобы работала данная функция
#>
# RecommendedTroubleshooting -Default

# Launch folder windows in a separate process (current user only)
# Запускать окна с папками в отдельном процессе (только для текущего пользователя)
FoldersLaunchSeparateProcess -Enable

# Do not launch folder windows in a separate process (current user only) (default value)
# Не запускать окна с папками в отдельном процессе (только для текущего пользователя) (значение по умолчанию)
# FoldersLaunchSeparateProcess -Disable

# Disable and delete reserved storage after the next update installation
# Отключить и удалить зарезервированное хранилище после следующей установки обновлений
ReservedStorage -Disable

# Enable reserved storage (default value)
# Включить зарезервированное хранилище (значение по умолчанию)
# ReservedStorage -Enable

# Disable help lookup via F1 (current user only)
# Отключить открытие справки по нажатию F1 (только для текущего пользователя)
F1HelpPage -Disable

# Enable help lookup via F1 (current user only) (default value)
# Включить открытие справки по нажатию F1 (только для текущего пользователя) (значение по умолчанию)
# F1HelpPage -Enable

# Enable Num Lock at startup
# Включить Num Lock при загрузке
NumLock -Enable

# Disable Num Lock at startup (default value)
# Выключить Num Lock при загрузке (значение по умолчанию)
# NumLock -Disable

# Disable StickyKey after tapping the Shift key 5 times (current user only)
# Выключить залипание клавиши Shift после 5 нажатий (только для текущего пользователя)
StickyShift -Disable

# Enable StickyKey after tapping the Shift key 5 times (current user only) (default value)
# Включить залипание клавиши Shift после 5 нажатий (только для текущего пользователя) (значение по умолчанию)
# StickyShift -Enable

# Disable AutoPlay for all media and devices (current user only)
# Выключать автозапуск для всех носителей и устройств (только для текущего пользователя)
Autoplay -Disable

# Enable AutoPlay for all media and devices (current user only) (default value)
# Включить автозапуск для всех носителей и устройств (только для текущего пользователя) (значение по умолчанию)
# Autoplay -Enable

# Disable thumbnail cache removal
# Отключить удаление кэша миниатюр
ThumbnailCacheRemoval -Disable

# Enable thumbnail cache removal (default value)
# Включить удаление кэша миниатюр (значение по умолчанию)
# ThumbnailCacheRemoval -Enable

# Enable automatically saving my restartable apps when signing out and restart them after signing in (current user only)
# Включить автоматическое сохранение моих перезапускаемых приложений при выходе из системы и перезапускать их после выхода (только для текущего пользователя)
SaveRestartableApps -Enable

# Disable automatically saving my restartable apps when signing out and restart them after signing in (current user only) (default value)
# Выключить автоматическое сохранение моих перезапускаемых приложений при выходе из системы и перезапускать их после выхода (только для текущего пользователя) (значение по умолчанию)
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
# Не перезапуск этого устройства как можно быстрее, если для установки обновления требуется перезагрузка (значение по умолчанию)
# DeviceRestartAfterUpdate -Disable
#endregion System

#region WSL
<#
	Install the Windows Subsystem for Linux (WSL)
	Установить подсистему Windows для Linux (WSL)

	https://github.com/farag2/Windows-10-Sophia-Script/issues/43
	https://github.com/microsoft/WSL/issues/5437
#>
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

	https://github.com/microsoft/WSL/issues/5437
	https://github.com/farag2/Windows-10-Sophia-Script/issues/43
#>
# EnableWSL2

<#
	Disable swap file in WSL
	Use only if the %TEMP% environment variable path changed

	Отключить файл подкачки в WSL
	Используйте только в случае, если изменился путь переменной среды для %TEMP%

	https://github.com/microsoft/WSL/issues/5437
#>
# WSLSwap -Disable

<#
	Enable swap file in WSL
	Включить файл подкачки в WSL

	https://github.com/microsoft/WSL/issues/5437
#>
# WSLSwap -Enable
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

# Run the Command Prompt shortcut from the Start menu as Administrator
# Запускать ярлык командной строки в меню "Пуск" от имени Администратора
RunCMDShortcut -Elevated

# Run the Command Prompt shortcut from the Start menu as user (default value)
# Запускать ярлык командной строки в меню "Пуск" от имени пользователя (значение по умолчанию)
# RunCMDShortcut -NonElevated

# Unpin all the Start tiles
# Открепить все ярлыки от начального экрана
UnpinAllStartTiles

<#
	Test if syspin.exe is in a folder. Unless download it
	Проверить, находится ли файл syspin.exe в папке. Иначе скачать его

	http://www.technosys.net/products/utils/pintotaskbar
	SHA256: 07D6C3A19A8E3E243E9545A41DD30A9EE1E9AD79CDD6D446C229D689E5AB574A
#>
syspin

# Pin the "Control Panel" shortcut to Start within syspin
# Закрепить ярлык "Панели управления" на начальном экране с помощью syspin
PinControlPanel

# Pin the old-style "Devices and Printers" shortcut to Start within syspin
# Закрепить ярлык старого формата "Устройства и принтеры" на начальном экране с помощью syspin
PinDevicesPrinters

# Pin the Command Prompt" shortcut to Start within syspin
# Закрепить ярлык "Командная строка" на начальном экране с помощью syspin
PinCommandPrompt
#endregion Start menu

#region UWP apps
<#
	Uninstall UWP apps using the pop-up dialog box that enables the user to select packages to remove
	App packages will not be installed for new users if "Uninstall for All Users" is checked

	Удалить UWP-приложения, используя всплывающее диалоговое окно, позволяющее пользователю отметить пакеты на удаление
	Приложения не будут установлены для новых пользователе, если отмечено "Удалять для всех пользователей"
#>
UninstallUWPApps

<#
	Open Microsoft Store "HEVC Video Extensions from Device Manufacturer" page
	The extension can be installed without Microsoft account for free instead of $0.99
	"Movies & TV" app required

	Открыть страницу "Расширения для видео HEVC от производителя устройства" в Microsoft Store
	Расширение может быть установлено бесплатно без учетной записи Microsoft вместо 0,99 $
	Для работы необходимо приложение "Кино и ТВ"
#>
InstallHEVC

# Disable Cortana autostarting
# Выключить автозагрузку Кортана
CortanaAutostart -Disable

# Enable Cortana autostarting (default value)
# Включить автозагрузку Кортана (значение по умолчанию)
# CortanaAutostart -Enable

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
	Create the "Windows Cleanup" task to clean up unused files and Windows updates in the Task Scheduler
	A minute before the task starts, a warning in the Windows action center will appear
	The task runs every 90 days

	Создать задачу "Windows Cleanup" в Планировщике задач по очистке неиспользуемых файлов и обновлений Windows
	За минуту до выполнения задачи в Центре уведомлений Windows появится предупреждение
	Задача выполняется каждые 90 дней
#>
CleanUpTask -Register

# Delete the "Windows Cleanup" task to clean up unused files and Windows updates in the Task Scheduler
# Удалить задачу "Windows Cleanup" в Планировщике задач по очистке неиспользуемых файлов и обновлений Windows
# CleanUpTask -Delete

<#
	Create the "SoftwareDistribution" task to clear the %SystemRoot%\SoftwareDistribution\Download folder in the Task Scheduler
	The task runs on Thursdays every 4 weeks

	Создать задачу "SoftwareDistribution" в Планировщике задач по очистке папки %SystemRoot%\SoftwareDistribution\Download
	Задача выполняется по четвергам каждую 4 неделю
#>
SoftwareDistributionTask -Register

# Delete the "SoftwareDistribution" task to clear the %SystemRoot%\SoftwareDistribution\Download folder in the Task Scheduler
# Удалить задачу "SoftwareDistributionp" в Планировщике задач по очистке папки %SystemRoot%\SoftwareDistribution\Download
# SoftwareDistributionTask -Delete

<#
	Create the "Temp" task to clear the %TEMP% folder in the Task Scheduler
	The task runs every 62 days

	Создать задачу "Temp" в Планировщике задач по очистке папки %TEMP%
	Задача выполняется каждые 62 дня
#>
TempTask -Register

# Delete a task to clear the %TEMP% folder in the Task Scheduler
# Удалить задачу в Планировщике задач по очистке папки %TEMP%
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

# Enable sandboxing for Microsoft Defender
# Включить песочницу для Microsoft Defender
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

# Disable the Attachment Manager marking files that have been downloaded from the Internet as unsafe (current user only)
# Выключить проверку Диспетчером вложений файлов, скачанных из интернета, как небезопасные (только для текущего пользователя)
SaveZoneInformation -Disable

# Enable the Attachment Manager marking files that have been downloaded from the Internet as unsafe (current user only) (default value)
# Включить проверку Диспетчера вложений файлов, скачанных из интернета как небезопасные (только для текущего пользователя) (значение по умолчанию)
# SaveZoneInformation -Enable

<#
	Disable Windows Script Host (current user only)
	It becomes impossible to run .js and .vbs files

	Отключить Windows Script Host (только для текущего пользователя)
	Становится невозможным запустить файлы .js и .vbs
#>
WindowsScriptHost -Disable

# Emable Windows Script Host (current user only) (default value)
# Включить Windows Script Host (только для текущего пользователя) (значение по умолчанию)
# WindowsScriptHost -Enable

# Enable Windows Sandbox
# Включить Windows Sandbox
WindowsSandbox -Enable

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

# Add the "Bitmap image" item in the "New" context menu (default value)
# Восстановить пункт "Точечный рисунок" в контекстного меню "Создать" (значение по умолчанию)
# BitmapImageNewContext -Add

# Remove the "Rich Text Document" item from the "New" context menu
# Удалить пункт "Документ в формате RTF" из контекстного меню "Создать"
RichTextDocumentNewContext -Remove

# Add the "Rich Text Document" item in the "New" context menu (default value)
# Восстановить пункт "Документ в формате RTF" в контекстного меню "Создать" (значение по умолчанию)
# RichTextDocumentNewContext -Add

# Remove the "Compressed (zipped) Folder" item from the "New" context menu
# Удалить пункт "Сжатая ZIP-папка" из контекстного меню "Создать"
CompressedFolderNewContext -Remove

# Add the "Compressed (zipped) Folder" item from the "New" context menu (default value)
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

# Hide the "Previous Versions" tab from files and folders context menu and also the "Restore previous versions" context menu item
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

	Симулировать нажатие F5 для обновления рабочего стола
	Обновить иконки рабочего стола, переменные среды, панель задач
	Перезапустить меню "Пуск"
#>
Refresh

# Errors output
# Вывод ошибок
Errors
