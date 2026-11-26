<#
	.SYNOPSIS
	Default preset file for "Sophia Script for Windows 11 (Arm | PowerShell 7)"

	.VERSION
	8.1.0

	.DATE
	31.10.2026

	.COPYRIGHT
	(c) 2014—2026 Team Sophia

	.DESCRIPTION
	Place the "#" character before a function if you don't want to run it
	Remove the "#" character before a function if you want to run it
	Every tweak in the preset file has its corresponding function to restore the default settings

	.EXAMPLE Run the whole script
	.\Sophia.ps1

	.EXAMPLE Download and expand the latest Sophia Script archive (without running it) for the Windows and PowerShell versions it is run on
	iwr script.sophia.team -useb | iex

	.EXAMPLE Download and expand the latest Sophia Script archive (without running it) from the latest commit for the Windows and PowerShell versions it is run on
	iwr sl.sophia.team -useb | iex

	.NOTES
	Supports Windows 11 26H2+ for Arm Home/Pro/Enterprise

	.NOTES
	You can dot-source Import-TabCompletion.ps1 to call functions if you do not know their names:
		. .\Import-TabCompletion.ps1 (with a dot at the beginning)
	Read more at https://github.com/farag2/Sophia-Script-for-Windows?tab=readme-ov-file#how-to-run-the-specific-functions

	.LINK GitHub
	https://github.com/farag2/Sophia-Script-for-Windows

	.LINK Telegram
	https://t.me/sophianews
	https://t.me/sophia_chat

	.LINK Discord
	https://discord.gg/sSryhaEv79

	.DONATE
	https://ko-fi.com/farag

	.NOTES
	https://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15
	https://habr.com/companies/skillfactory/articles/553800/
	https://forums.mydigitallife.net/threads/powershell-sophia-script-for-windows-6-0-4-7-0-4-2026.81675/page-21
	https://www.reddit.com/r/PowerShell/comments/go2n5v/powershell_script_setup_windows_10/

	.LINK
	https://github.com/farag2
	https://github.com/Inestic
	https://github.com/lowl1f3
#>

#Requires -RunAsAdministrator
#Requires -Version 7.7

# Import the module and private functions, and run initial checks
. $PSScriptRoot\Module\Private\InitialActions.ps1
InitialActions

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Preset configuration starts here                                    #
# Настройка пресет-файла начинается здесь                             #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

#region Protection
# Enable script logging. The log will be saved to the script folder. To stop logging, just close the console or type "Stop-Transcript"
# Включить логирование работы скрипта. Лог будет записываться в папку скрипта. Чтобы остановить логирование, закройте консоль или наберите "Stop-Transcript"
# Logging

# Create restore point
# Создать точку восстановления
CreateRestorePoint
#endregion Protection

#region Privacy & Telemetry
<#
	Disable the "Connected User Experiences and Telemetry" service (DiagTrack), and block the connection for the Unified Telemetry Client Outbound Traffic
	Disabling the "Connected User Experiences and Telemetry" service (DiagTrack) may prevent you from getting XBOX achievements and affect Feedback Hub

	Отключить службу "Функциональные возможности для подключенных пользователей и телеметрия" (DiagTrack) и блокировать соединение для исходящего трафика клиента единой телеметрии
	Отключение службы "Функциональные возможности для подключенных пользователей и телеметрия" (DiagTrack) может привести к тому, что вы больше не сможете получать достижения XBOX, а также влияет на работу Feedback Hub
#>
DiagTrackService -Disable

# Enable the "Connected User Experiences and Telemetry" service (DiagTrack), and allow the connection for the Unified Telemetry Client Outbound Traffic (default value)
# Включить службу "Функциональные возможности для подключенных пользователей и телеметрия" (DiagTrack) и разрешить подключение для исходящего трафика клиента единой телеметрии (значение по умолчанию)
# DiagTrackService -Enable

# Set the diagnostic data collection to minimum
# Установить уровень сбора диагностических данных ОС на минимальный
DiagnosticDataLevel -Minimal

# Set the diagnostic data collection to default (default value)
# Установить уровень сбора диагностических данных ОС по умолчанию (значение по умолчанию)
# DiagnosticDataLevel -Default

# Turn off the Windows Error Reporting
# Отключить запись отчетов об ошибках Windows
ErrorReporting -Disable

# Turn on the Windows Error Reporting (default value)
# Включить отчеты об ошибках Windows (значение по умолчанию)
# ErrorReporting -Enable

<#
	Run troubleshooters automatically, then notify me
	For this feature to work, the diagnostic data level will be set to "Optional diagnostic data", and Windows Error Reporting will be turned on

	Автоматически запускать средства устранения неполадок, а затем уведомлять
	Чтобы заработала данная функция, уровень сбора диагностических данных ОС будет установлен на "Необязательные диагностические данные" и включится создание отчетов об ошибках Windows
#>
RecommendedTroubleshooting -Automatically

<#
	Ask me before running troubleshooters (default value)
	For this feature to work, the diagnostic data level will be set to "Optional diagnostic data", and Windows Error Reporting will be turned on

	Спрашивать перед запуском средств устранения неполадок (значение по умолчанию)
	Чтобы заработала данная функция, уровень сбора диагностических данных ОС будет установлен на "Необязательные диагностические данные" и включится создание отчетов об ошибках Windows
#>
# RecommendedTroubleshooting -Default

# Change the feedback frequency to "Never"
# Изменить частоту формирования отзывов на "Никогда"
FeedbackFrequency -Never

# Change the feedback frequency to "Automatically" (default value)
# Изменить частоту формирования отзывов на "Автоматически" (значение по умолчанию)
# FeedbackFrequency -Automatically

# Turn off the diagnostics tracking scheduled tasks
# Отключить задания диагностического отслеживания
ScheduledTasks -Disable

# Turn on the diagnostics tracking scheduled tasks (default value)
# Включить задания диагностического отслеживания (значение по умолчанию)
# ScheduledTasks -Enable

# Do not use sign-in info to automatically finish setting up device after an update
# Не использовать данные для входа для автоматического завершения настройки устройства после обновления
SigninInfo -Disable

# Use sign-in info to automatically finish setting up device after an update (default value)
# Использовать данные для входа, чтобы автоматически завершить настройку после обновления (значение по умолчанию)
# SigninInfo -Enable

# Do not let websites show me locally relevant content by accessing my language list
# Не позволять веб-сайтам предоставлять местную информацию за счет доступа к списку языков
LanguageListAccess -Disable

# Let websites show me locally relevant content by accessing my language list (default value)
# Позволить веб-сайтам предоставлять местную информацию за счет доступа к списку языков (значение по умолчанию)
# LanguageListAccess -Enable

# Do not let apps show me personalized ads by using my advertising ID
# Не разрешать приложениям показывать персонализированную рекламу с помощью моего идентификатора рекламы
AdvertisingID -Disable

# Let apps show me personalized ads by using my advertising ID (default value)
# Разрешить приложениям показывать персонализированную рекламу с помощью моего идентификатора рекламы (значение по умолчанию)
# AdvertisingID -Enable

# Hide the Windows welcome experiences after updates and occasionally when I sign in to highlight what's new and suggested
# Скрывать экран приветствия Windows после обновлений и иногда при входе, чтобы сообщить о новых функциях и предложениях
WindowsWelcomeExperience -Hide

# Show the Windows welcome experiences after updates and occasionally when I sign in to highlight what's new and suggested (default value)
# Показывать экран приветствия Windows после обновлений и иногда при входе, чтобы сообщить о новых функциях и предложениях (значение по умолчанию)
# WindowsWelcomeExperience -Show

# Get tips and suggestions when I use Windows (default value)
# Получать советы и предложения при использовании Windows (значение по умолчанию)
WindowsTips -Enable

# Do not get tips and suggestions when I use Windows
# Не получать советы и предложения при использовании Windows
# WindowsTips -Disable

# Do not show me suggested content in the Settings app
# Скрывать рекомендуемое содержимое в приложении "Параметры"
SettingsSuggestedContent -Hide

# Show me suggested content in the Settings app (default value)
# Показывать рекомендуемое содержимое в приложении "Параметры" (значение по умолчанию)
# SettingsSuggestedContent -Show

# Turn off automatic installation of suggested apps
# Отключить автоматическую установку рекомендованных приложений
AppsSilentInstalling -Disable

# Turn on automatic installation of suggested apps (default value)
# Включить автоматическую установку рекомендованных приложений (значение по умолчанию)
# AppsSilentInstalling -Enable

# Do not suggest ways to get the most out of Windows and finish setting up this device
# Не предлагать способы завершения настройки этого устройства для наиболее эффективного использования Windows
WhatsNewInWindows -Disable

# Suggest ways to get the most out of Windows and finish setting up this device (default value)
# Предложить способы завершения настройки этого устройства для наиболее эффективного использования Windows (значение по умолчанию)
# WhatsNewInWindows -Enable

# Don't let Microsoft use your diagnostic data for personalized tips, ads, and recommendations
# Не разрешать корпорации Майкрософт использовать диагностические данные для персонализированных советов, рекламы и рекомендаций
TailoredExperiences -Disable

# Let Microsoft use your diagnostic data for personalized tips, ads, and recommendations (default value)
# Разрешить корпорации Майкрософт использовать диагностические данные для персонализированных советов, рекламы и рекомендаций (значение по умолчанию)
# TailoredExperiences -Enable

# Disable Bing search in the Start menu
# Отключить в меню "Пуск" поиск через Bing
BingSearch -Disable

# Enable Bing search in the Start menu (default value)
# Включить поиск через Bing в меню "Пуск" (значение по умолчанию)
# BingSearch -Enable
#endregion Privacy & Telemetry

#region UI & Personalization
# Show the "This PC" icon on the desktop
# Отобразить значок "Этот компьютер" на рабочем столе
ThisPC -Show

# Hide the "This PC" icon on the desktop (default value)
# Скрыть значок "Этот компьютер" на рабочем столе (значение по умолчанию)
# ThisPC -Hide

# Do not use item check boxes
# Не использовать флажки для выбора элементов
CheckBoxes -Disable

# Use item check boxes (default value)
# Использовать флажки для выбора элементов (значение по умолчанию)
# CheckBoxes -Enable

# Show hidden files, folders, and drives
# Отобразить скрытые файлы, папки и диски
HiddenItems -Enable

# Do not show hidden files, folders, and drives (default value)
# Не показывать скрытые файлы, папки и диски (значение по умолчанию)
# HiddenItems -Disable

# Show file name extensions
# Отобразить расширения имён файлов
FileExtensions -Show

# Hide file name extensions (default value)
# Скрывать расширения имён файлов (значение по умолчанию)
# FileExtensions -Hide

# Show folder merge conflicts
# Не скрывать конфликт слияния папок
MergeConflicts -Show

# Hide folder merge conflicts (default value)
# Скрывать конфликт слияния папок (значение по умолчанию)
# MergeConflicts -Hide

# Open File Explorer to "This PC"
# Открывать проводник для "Этот компьютер"
OpenFileExplorerTo -ThisPC

# Open File Explorer to "Home" (default value)
# Открывать проводник для "Главная" (значение по умолчанию)
# OpenFileExplorerTo -QuickAccess

# Disable File Explorer compact mode (default value)
# Отключить компактный вид проводника (значение по умолчанию)
FileExplorerCompactMode -Disable

# Enable File Explorer compact mode
# Включить компактный вид проводника
# FileExplorerCompactMode -Enable

# Hide sync provider notifications in File Explorer
# Не показывать уведомления поставщика синхронизации в проводнике
OneDriveFileExplorerAd -Hide

# Show sync provider notifications in File Explorer (default value)
# Показывать уведомления поставщика синхронизации в проводнике (значение по умолчанию)
# OneDriveFileExplorerAd -Show

# Show the file transfer dialog box in the detailed mode
# Отображать диалоговое окно передачи файлов в развернутом виде
FileTransferDialog -Detailed

# Show the file transfer dialog box in the compact mode (default value)
# Отображать диалоговое окно передачи файлов в свернутом виде (значение по умолчанию)
# FileTransferDialog -Compact

# Display the Recycle Bin delete confirmation dialog
# Запрашивать подтверждение на удаление файлов в корзину
RecycleBinDeleteConfirmation -Enable

# Do not display the Recycle Bin delete confirmation dialog (default value)
# Не запрашивать подтверждение на удаление файлов в корзину (значение по умолчанию)
# RecycleBinDeleteConfirmation -Disable

# Hide recently used files in File Explorer Home
# Скрыть недавно использовавшиеся файлы в разделе "Главная" проводника
QuickAccessRecentFiles -Hide

# Show recently used files in File Explorer Home (default value)
# Показать недавно использовавшиеся файлы в разделе "Главная" проводника (значение по умолчанию)
# QuickAccessRecentFiles -Show

# Hide frequently used folders in Quick access
# Скрыть часто используемые папки на панели быстрого доступа
QuickAccessFrequentFolders -Hide

# Show frequently used folders in Quick access (default value)
# Показать часто используемые папки на панели быстрого доступа (значение по умолчанию)
# QuickAccessFrequentFolders -Show

# Do not group files and folders in the Downloads folder
# Не группировать файлы и папки в папке Загрузки
FolderGroupBy -None

# Group files and folders by date modified in the Downloads folder (default value)
# Группировать файлы и папки по дате изменения в папке Загрузки (значение по умолчанию)
# FolderGroupBy -Default

# Do not expand to open folder on navigation pane (default value)
# Не разворачивать до открытой папки область навигации (значение по умолчанию)
NavigationPaneExpand -Disable

# Expand to open folder on navigation pane
# Развернуть до открытой папки область навигации
# NavigationPaneExpand -Enable

# Set taskbar position to the bottom (default value)
# Расположить панель задач внизу экрана (значение по умолчанию)
TaskbarPosition -Bottom

# Set taskbar position to the top
# Расположить панель задач вверху экрана
# TaskbarPosition -Top

# Set taskbar position to the left
# Расположить панель задач слева
# TaskbarPosition -Left

# Set taskbar position to the right
# Расположить панель задач справа
# TaskbarPosition -Right

# Set taskbar alignment to the center (default value)
# Установить выравнивание панели задач по центру (значение по умолчанию)
TaskbarAlignment -Center

# Set taskbar alignment to the left
# Установить выравнивание панели задач по левому краю
# TaskbarAlignment -Left

# Hide the Widgets icon on the taskbar
# Скрыть кнопку "Мини-приложения" с панели задач
TaskbarWidgets -Hide

# Show the Widgets icon on the taskbar (default value)
# Отобразить кнопку "Мини-приложения" на панели задач (значение по умолчанию)
# TaskbarWidgets -Show

# Hide the search on the taskbar
# Скрыть поле или значок поиска на панели задач
TaskbarSearch -Hide

# Show the search icon on the taskbar
# Показать значок поиска на панели задач
# TaskbarSearch -SearchIcon

# Show the search icon and label on the taskbar
# Показать значок и метку поиска на панели задач
# TaskbarSearch -SearchIconLabel

# Show the search box on the taskbar (default value)
# Показать поле поиска на панели задач (значение по умолчанию)
# TaskbarSearch -SearchBox

# Hide search highlights
# Скрыть главное в поиске
SearchHighlights -Hide

# Show search highlights (default value)
# Показать главное в поиске (значение по умолчанию)
# SearchHighlights -Show

# Hide the Task view button from the taskbar
# Скрыть кнопку "Представление задач" с панели задач
TaskViewButton -Hide

# Show the Task view button on the taskbar (default value)
# Отобразить кнопку "Представление задач" на панели задач (значение по умолчанию)
# TaskViewButton -Show

# Show seconds on the taskbar clock
# Показывать секунды на часах на панели задач
SecondsInSystemClock -Show

# Hide seconds on the taskbar clock (default value)
# Скрыть секунды на часах на панели задач (значение по умолчанию)
# SecondsInSystemClock -Hide

# Show time in Notification Center
# Показывать время в центре уведомлений
ClockInNotificationCenter -Show

# Hide time in Notification Center (default value)
# Скрыть время в центре уведомлений (значение по умолчанию)
# ClockInNotificationCenter -Hide

# Combine taskbar buttons and always hide labels (default value)
# Объединить кнопки панели задач и всегда скрывать метки (значение по умолчанию)
TaskbarCombine -Always

# Combine taskbar buttons and hide labels when taskbar is full
# Объединить кнопки панели задач и скрывать метки при переполнении панели задач
# TaskbarCombine -Full

# Combine taskbar buttons and never hide labels
# Объединить кнопки панели задач и никогда не скрывать метки
# TaskbarCombine -Never

# Enable "End task" in the taskbar by right-click
# Включить завершение задачи на панели задач правой кнопкой мыши
TaskbarEndTask -Enable

# Disable "End task" in the taskbar by right-click (default value)
# Выключить завершение задачи на панели задач правой кнопкой мыши (значение по умолчанию)
# TaskbarEndTask -Disable

# View the Control Panel icons by large icons
# Просмотр иконок Панели управления как: крупные значки
ControlPanelView -LargeIcons

# View the Control Panel icons by small icons
# Просмотр иконок Панели управления как: маленькие значки
# ControlPanelView -SmallIcons

# View the Control Panel icons by category (default value)
# Просмотр иконок Панели управления как: категория (значение по умолчанию)
# ControlPanelView -Category

# Set the default Windows mode to dark
# Установить режим Windows по умолчанию на темный
WindowsColorMode -Dark

# Set the default Windows mode to light (default value)
# Установить режим Windows по умолчанию на светлый (значение по умолчанию)
# WindowsColorMode -Light

# Set the default app mode to dark
# Установить цвет режима приложения на темный
AppColorMode -Dark

# Set the default app mode to light (default value)
# Установить цвет режима приложения на светлый (значение по умолчанию)
# AppColorMode -Light

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

# Do not add the "- Shortcut" suffix to the file name of created shortcuts
# Не добавлять "- ярлык" к имени создаваемых ярлыков
ShortcutsSuffix -Disable

# Add the "- Shortcut" suffix to the file name of created shortcuts (default value)
# Добавлять "- ярлык" к имени создаваемых ярлыков (значение по умолчанию)
# ShortcutsSuffix -Enable

# When I snap a window, do not show what I can snap next to it
# При прикреплении окна не показывать, что можно прикрепить рядом с ним
SnapAssist -Disable

# When I snap a window, show what I can snap next to it (default value)
# При прикреплении окна показывать, что можно прикрепить рядом с ним (значение по умолчанию)
# SnapAssist -Enable

# When I grab a window's title bar and shake it, minimize all other windows
# При захвате заголовка окна и встряхивании сворачиваются все остальные окна
AeroShaking -Enable

# When I grab a window's title bar and shake it, don't minimize all other windows (default value)
# При захвате заголовка окна и встряхивании не сворачиваются все остальные окна (значение по умолчанию)
# AeroShaking -Disable

# Download and install free dark "Windows 11 Cursors Concept" cursors from Jepri Creations. An Internet connection is required
# Скачать и установить бесплатные темные курсоры "Windows 11 Cursors Concept" от Jepri Creations. Требуется соединение с интернетом
# https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-886489356
Install-Cursors -Dark

# Download and install free light "Windows 11 Cursors Concept" cursors from Jepri Creations. An Internet connection is required
# Скачать и установить бесплатные светлые курсоры "Windows 11 Cursors Concept" от Jepri Creations. Требуется соединение с интернетом
# https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-886489356
# Install-Cursors -Light

# Set default cursors
# Установить курсоры по умолчанию
# Install-Cursors -Default

# Hide recently added apps on Start
# Не показывать недавно добавленные приложения на начальном экране
RecentlyAddedStartApps -Hide

# Show recently added apps on Start (default value)
# Показывать недавно добавленные приложения на начальном экране (значение по умолчанию)
# RecentlyAddedStartApps -Show

# Unpin all apps from Start
# Открепить все ярлыки от начального экрана
# UnpinAllStartTiles

# Use Category View for All Apps on Start (default value)
# Использовать просмотр по категориям для всех приложений на начальном экране (значение по умолчанию)
# StartAppsView -Category

# Use Grid View for All Apps on Start
# Использовать просмотр в виде сетки для всех приложений на начальном экране
# StartAppsView -Grid

# Use List View for All Apps on Start
# Использовать просмотр в виде списка для всех приложений на начальном экране
StartAppsView -List

# Hide most used apps on Start (default value)
# Не показывать наиболее часто используемые приложения на начальном экране (значение по умолчанию)
MostUsedStartApps -Hide

# Show most used apps on Start
# Показывать наиболее часто используемые приложения на начальном экране
# MostUsedStartApps -Show

# Hide the Recommended section on Start
# Скрыть раздел "Рекомендуем" на начальном экране
StartRecommendedSection -Hide

# Show the Recommended section on Start (default value)
# Показывать раздел "Рекомендуем" на начальном экране (значение по умолчанию)
# StartRecommendedSection -Show

# Hide recommendations for tips, shortcuts, new apps, and more on Start
# Не показывать рекомендации с советами, сочетаниями клавиш, новыми приложениями и т. д. на начальном экране
StartRecommendationsTips -Hide

# Show recommendations for tips, shortcuts, new apps, and more on Start (default value)
# Показывать рекомендации с советами, сочетаниями клавиш, новыми приложениями и т. д. на начальном экране (значение по умолчанию)
# StartRecommendationsTips -Show

# Hide Microsoft account-related notifications on Start
# Не отображать на начальном экране уведомления, касающиеся учетной записи Microsoft
StartAccountNotifications -Hide

# Show Microsoft account-related notifications on Start (default value)
# Отображать на начальном экране уведомления, касающиеся учетной записи Microsoft (значение по умолчанию)
# StartAccountNotifications -Show
#endregion UI & Personalization

#region OneDrive
# Uninstall OneDrive. The OneDrive user folder won't be removed if any files are found there
# Удалить OneDrive. Папка пользователя OneDrive не будет удалена при обнаружении в ней файлов
# OneDrive -Uninstall

# Install OneDrive (default value)
# Установить OneDrive (значение по умолчанию)
# OneDrive -Install

# Install OneDrive for all users to %ProgramFiles% depending on which installer is triggered
# Установить OneDrive для всех пользователей в %ProgramFiles% в зависимости от того, как запускается инсталлятор
# OneDrive -Install -AllUsers
#endregion OneDrive

#region WSL
# Enable Windows Subsystem for Linux (WSL), install the latest WSL Linux kernel version, and a Linux distribution using a pop-up form. An Internet connection is required
# Установить подсистему Windows для Linux (WSL), последний пакет обновления ядра Linux и дистрибутив Linux, используя всплывающую форму. Требуется соединение с интернетом
# Install-WSL
#endregion WSL

#region System
# Install the latest Microsoft Visual C++ Redistributable Packages 2017–2026 (x86/x64). An Internet connection is required
# Установить последнюю версию распространяемых пакетов Microsoft Visual C++ 2017–2026 (x86/x64). Требуется соединение с интернетом
Install-VCRedist

# Install the latest .NET Desktop Runtime 10, 11 Arm64. An Internet connection is required
# Установить последнюю версию .NET Desktop Runtime 10, 11 Arm64. Требуется соединение с интернетом
Install-DotNetRuntimes -Runtimes NET10, NET11

# Enable Windows Sandbox. Restart needed
# Включить Windows Sandbox. Необходима перезагрузка
# WindowsSandbox -Enable

# Disable Windows Sandbox (default value). Restart needed
# Выключить Windows Sandbox (значение по умолчанию). Необходима перезагрузка
# WindowsSandbox -Disable

# Turn on Storage Sense
# Включить Контроль памяти
StorageSense -Enable

# Turn off Storage Sense (default value)
# Выключить Контроль памяти (значение по умолчанию)
# StorageSense -Disable

# Enable Windows long path support to lift the 260-character path limit
# Включить поддержку длинных путей, ограниченных по умолчанию 260 символами
Win32LongPathsSupport -Enable

# Disable Windows long path support, so paths are limited to 260 characters (default value)
# Отключить поддержку длинных путей, ограниченных по умолчанию 260 символами (значение по умолчанию)
# Win32LongPathsSupport -Disable

# Display the Stop error parameters when a BSoD occurs
# Отображать параметры Stop-ошибки при появлении BSoD
BSoDStopError -Enable

# Do not display the Stop error parameters when a BSoD occurs (default value)
# Не отображать параметры Stop-ошибки при появлении BSoD (значение по умолчанию)
# BSoDStopError -Disable

# Turn off Delivery Optimization
# Выключить оптимизацию доставки
DeliveryOptimization -Disable

# Turn on Delivery Optimization (default value)
# Включить оптимизацию доставки (значение по умолчанию)
# DeliveryOptimization -Enable

# Do not let Windows manage my default printer
# Не разрешать Windows управлять принтером, используемым по умолчанию
WindowsManageDefaultPrinter -Disable

# Let Windows manage my default printer (default value)
# Разрешать Windows управлять принтером, используемым по умолчанию (значение по умолчанию)
# WindowsManageDefaultPrinter -Enable

<#
	Uninstall optional features and Windows features using a pop-up dialog box. The missing ones can be installed in the same window
	If you want to keep the "Multimedia settings" element in the advanced settings of Power Options, do not uninstall "Media Features" and "Windows Media Player"

	Удалить дополнительные компоненты и компоненты Windows, используя всплывающее диалоговое окно. В этом же окне можно установить отсутствующие
	Если вы хотите оставить параметр "Параметры мультимедиа" в дополнительных параметрах схемы управления питанием, не удаляйте "Компоненты для работы с мультимедиа" и "Проигрыватель Windows Media"
#>
OptionalFeatures -Uninstall

<#
	Install optional features and Windows features using a pop-up dialog box. The installed ones can be uninstalled in the same window
	An Internet connection is required to install optional features

	Установить дополнительные компоненты и компоненты Windows, используя всплывающее диалоговое окно. В этом же окне можно удалить установленные
	Для установки дополнительных компонентов требуется соединение с интернетом
#>
# OptionalFeatures -Install

# Get updates for other apps and services together with Windows updates
# Получать обновления для других приложений и служб с обновлениями Windows
UpdateMicrosoftProducts -Enable

# Do not get updates for other apps and services together with Windows updates (default value)
# Не получать обновления для других приложений и служб с обновлениями Windows (значение по умолчанию)
# UpdateMicrosoftProducts -Disable

# Notify me when a restart is required to finish updating
# Уведомлять меня о необходимости перезагрузки для завершения обновления
RestartNotification -Show

# Do not notify me when a restart is required to finish updating (default value)
# Не уведомлять меня о необходимости перезагрузки для завершения обновления (значение по умолчанию)
# RestartNotification -Hide

# Restart as soon as possible to finish updating
# Перезапустить устройство как можно быстрее, чтобы завершить обновление
RestartDeviceAfterUpdate -Enable

# Don't restart as soon as possible to finish updating (default value)
# Не перезапускать устройство как можно быстрее, чтобы завершить обновление (значение по умолчанию)
# RestartDeviceAfterUpdate -Disable

# Automatically adjust active hours for me based on daily usage
# Автоматически изменять период активности для этого устройства на основе действий
ActiveHours -Automatically

# Manually adjust active hours (default value)
# Вручную изменять период активности для этого устройства (значение по умолчанию)
# ActiveHours -Manually

# Do not get the latest updates as soon as they're available (default value)
# Не получать последние обновления, как только они будут доступны (значение по умолчанию)
WindowsLatestUpdate -Disable

# Get the latest updates as soon as they're available
# Получать последние обновления, как только они будут доступны
# WindowsLatestUpdate -Enable

# Disable hibernation. Not recommended for laptops
# Отключить режим гибернации. Не рекомендуется для ноутбуков
Hibernation -Disable

# Enable hibernation (default value)
# Включить режим гибернации (значение по умолчанию)
# Hibernation -Enable

# Set power plan to "High performance". Not recommended for laptops
# Установить схему управления питанием на "Высокая производительность". Не рекомендуется для ноутбуков
PowerPlan -High

# Set power plan to "Balanced" (default value)
# Установить схему управления питанием на "Сбалансированная" (значение по умолчанию)
# PowerPlan -Balanced

# Do not allow the computer to turn off the active network adapters to save power. Not recommended for laptops
# Запретить отключение активных сетевых адаптеров для экономии энергии. Не рекомендуется для ноутбуков
NetworkAdaptersSavePower -Disable

# Allow the computer to turn off the active network adapters to save power (default value)
# Разрешить отключение активных сетевых адаптеров для экономии энергии (значение по умолчанию)
# NetworkAdaptersSavePower -Enable

# Override for default input method: English (United States)
# Переопределить метод ввода по умолчанию: английский (США)
InputMethod -English

# Override for default input method: use language list (default value)
# Переопределить метод ввода по умолчанию: использовать список языков (значение по умолчанию)
# InputMethod -Default

# Let me use a different input method for each app window
# Позволить выбирать метод ввода для каждого окна
AppsLanguageSwitch -Enable

# Do not use a different input method for each app window (default value)
# Не использовать метод ввода для каждого окна (значение по умолчанию)
# AppsLanguageSwitch -Disable

# Change the location of user folders to the root of any drive using an interactive menu. User files and folders won't be moved to the new location
# Изменить расположение пользовательских папок в корень любого диска на выбор с помощью интерактивного меню. Пользовательские файлы и папки не будут перемещены в новое расположение
Set-UserShellFolderLocation -Root

# Select the location of user folders manually using a folder browser dialog. User files and folders won't be moved to the new location
# Выбрать папки для расположения пользовательских папок вручную, используя диалог "Обзор папок". Пользовательские файлы и папки не будут перемещены в новое расположение
# Set-UserShellFolderLocation -Custom

# Change the location of user folders to the default values. User files and folders won't be moved to the new location
# Изменить расположение пользовательских папок на значения по умолчанию. Пользовательские файлы и папки не будут перемещены в новое расположение
# Set-UserShellFolderLocation -Default

# Save screenshots on the Desktop when pressing Windows+PrtScr or using Windows+Shift+S
# Сохранять скриншоты по нажатию Windows+PrtScr или Windows+Shift+S на рабочий стол
WinPrtScrFolder -Desktop

# Save screenshots in the Pictures folder when pressing Windows+PrtScr or using Windows+Shift+S (default value)
# Сохранять скриншоты по нажатию Windows+PrtScr или Windows+Shift+S в папку "Изображения" (значение по умолчанию)
# WinPrtScrFolder -Default

# Use the Print screen key to open screen snipping
# Использовать кнопку PRINT SCREEN, чтобы запустить функцию создания фрагмента экрана
PrtScnSnippingTool -Enable

# Do not use the Print screen key to open screen snipping (default value)
# Не использовать кнопку PRINT SCREEN, чтобы запустить функцию создания фрагмента экрана (значение по умолчанию)
# PrtScnSnippingTool -Disable

# Disable and delete reserved storage after the next update installation
# Отключить и удалить зарезервированное хранилище после следующей установки обновлений
ReservedStorage -Disable

# Enable reserved storage (default value)
# Включить зарезервированное хранилище (значение по умолчанию)
# ReservedStorage -Enable

# Disable help lookup via F1
# Отключить открытие справки по нажатию F1
F1HelpPage -Disable

# Enable help lookup via F1 (default value)
# Включить открытие справки по нажатию F1 (значение по умолчанию)
# F1HelpPage -Enable

# Enable Num Lock at startup
# Включить Num Lock при загрузке
NumLock -Enable

# Disable Num Lock at startup (default value)
# Выключить Num Lock при загрузке (значение по умолчанию)
# NumLock -Disable

# Disable Caps Lock. Restart needed
# Выключить Caps Lock. Необходима перезагрузка
# CapsLock -Disable

# Enable Caps Lock (default value). Restart needed
# Включить Caps Lock (значение по умолчанию). Необходима перезагрузка
# CapsLock -Enable

# Turn off pressing the Shift key 5 times to turn on Sticky keys
# Выключить залипание клавиши Shift после 5 нажатий
StickyShift -Disable

# Turn on pressing the Shift key 5 times to turn on Sticky keys (default value)
# Включить залипание клавиши Shift после 5 нажатий (значение по умолчанию)
# StickyShift -Enable

# Turn off mouse acceleration ("Enhance pointer precision"): the pointer moves the same distance however fast the mouse is moved
# Отключить ускорение мыши ("Повышенная точность установки указателя"): указатель проходит одно и то же расстояние при любой скорости движения мыши
# MouseAcceleration -Disable

# Turn on mouse acceleration ("Enhance pointer precision") (default value)
# Включить ускорение мыши ("Повышенная точность установки указателя") (значение по умолчанию)
# MouseAcceleration -Enable
# Don't use AutoPlay for all media and devices
# Не использовать автозапуск для всех носителей и устройств
Autoplay -Disable

# Use AutoPlay for all media and devices (default value)
# Использовать автозапуск для всех носителей и устройств (значение по умолчанию)
# Autoplay -Enable

# Disable thumbnail cache removal
# Отключить удаление кэша миниатюр
ThumbnailCacheRemoval -Disable

# Enable thumbnail cache removal (default value)
# Включить удаление кэша миниатюр (значение по умолчанию)
# ThumbnailCacheRemoval -Enable

# Automatically save my restartable apps and restart them when I sign back in
# Автоматически сохранять мои перезапускаемые приложения и перезапускать их при повторном входе
SaveRestartableApps -Enable

# Turn off automatically saving my restartable apps and restarting them when I sign back in (default value)
# Выключить автоматическое сохранение моих перезапускаемых приложений и их перезапуск при повторном входе (значение по умолчанию)
# SaveRestartableApps -Disable

# Do not restore previous folder windows at logon (default value)
# Не восстанавливать прежние окна папок при входе в систему (значение по умолчанию)
RestorePreviousFolders -Disable

# Restore previous folder windows at logon
# Восстанавливать прежние окна папок при входе в систему
# RestorePreviousFolders -Enable

<#
	Register an app, calculate the hash, and associate it with an extension with the "How do you want to open this" pop-up hidden
	Зарегистрировать приложение, вычислить хэш и ассоциировать его с расширением без всплывающего окна "Каким образом вы хотите открыть этот файл?"

	Set-Association -ProgramPath 'C:\SumatraPDF.exe' -Extension .pdf -Icon '%SystemRoot%\System32\shell32.dll,100'
	Set-Association -ProgramPath '%ProgramFiles%\Notepad++\notepad++.exe' -Extension .txt -Icon '%ProgramFiles%\Notepad++\notepad++.exe,0'
	Set-Association -ProgramPath MSEdgeHTM -Extension .html
#>
# Set-Association -ProgramPath '%ProgramFiles%\Notepad++\notepad++.exe' -Extension .txt -Icon '%ProgramFiles%\Notepad++\notepad++.exe,0'

# Export all Windows associations to the Application_Associations.json file in the script root folder
# Экспортировать все ассоциации в Windows в корень папки в виде файла Application_Associations.json
# Export-Associations

<#
	Import all Windows associations from the Application_Associations.json file
	You need to install all the apps listed in the exported Application_Associations.json file to restore all associations

	Импортировать все ассоциации в Windows из файла Application_Associations.json
	Вам необходимо установить все приложения согласно экспортированному файлу Application_Associations.json, чтобы восстановить все ассоциации
#>
# Import-Associations

# Set Windows Terminal as the default terminal app to host the user interface for command-line applications
# Установить Windows Terminal как приложение терминала по умолчанию для размещения пользовательского интерфейса для приложений командной строки
DefaultTerminalApp -WindowsTerminal

# Set Windows Console Host as the default terminal app to host the user interface for command-line applications (default value)
# Установить Windows Console Host как приложение терминала по умолчанию для размещения пользовательского интерфейса для приложений командной строки (значение по умолчанию)
# DefaultTerminalApp -ConsoleHost

# List Microsoft Edge channels to prevent desktop shortcut creation upon its update
# Перечислите каналы Microsoft Edge для предотвращения создания ярлыков на рабочем столе после его обновления
PreventEdgeShortcutCreation -Channels Stable, Beta, Dev, Canary

# Do not prevent desktop shortcut creation upon Microsoft Edge update (default value)
# Не предотвращать создание ярлыков на рабочем столе при обновлении Microsoft Edge (значение по умолчанию)
# PreventEdgeShortcutCreation -Disable

# Back up the system registry to the %SystemRoot%\System32\config\RegBack folder when the PC restarts and create the RegIdleBackup task in Task Scheduler to manage subsequent backups
# Создавать копии реестра при перезагрузке ПК и задание RegIdleBackup в Планировщике для управления последующими резервными копиями
RegistryBackup -Enable

# Do not back up the system registry to the %SystemRoot%\System32\config\RegBack folder (default value)
# Не создавать копии реестра при перезагрузке ПК (значение по умолчанию)
# RegistryBackup -Disable

# Disable Windows AI functions
# Выключить функции, связанные с ИИ Windows
WindowsAI -Disable

# Enable Windows AI functions (default value)
# Включить функции, связанные с ИИ Windows (значение по умолчанию)
# WindowsAI -Enable
#endregion System

#region UWP apps
# Uninstall UWP apps using a pop-up dialog box
# Удалить UWP-приложения, используя всплывающее диалоговое окно
Uninstall-UWPApps

<#
	Uninstall UWP apps for all users using a pop-up dialog box
	If "For All Users" is checked, app packages will not be installed for new users

	Удалить UWP-приложения для всех пользователей, используя всплывающее диалоговое окно
	Пакеты приложений не будут установлены для новых пользователей, если отмечена галочка "Для всех пользователей"
#>
# Uninstall-UWPApps -AllUsers
#endregion UWP apps

#region Gaming
<#
	Disable XBOX Game Bar
	To prevent the "You'll need a new app to open this ms-gamingoverlay" warning from popping up, you need to disable the XBOX Game Bar app, even if you uninstalled it before

	Отключить XBOX Game Bar
	Чтобы предотвратить появление предупреждения "Вам понадобится новое приложение, чтобы открыть этот ms-gamingoverlay", вам необходимо отключить приложение XBOX Game Bar, даже если вы удалили его раньше
#>
XBOXGameBar -Disable

# Enable XBOX Game Bar (default value)
# Включить XBOX Game Bar (значение по умолчанию)
# XBOXGameBar -Enable

# Disable XBOX Game Bar tips
# Отключить советы XBOX Game Bar
XBOXGameTips -Disable

# Enable XBOX Game Bar tips (default value)
# Включить советы XBOX Game Bar (значение по умолчанию)
# XBOXGameTips -Enable

<#
	Turn on hardware-accelerated GPU scheduling. Restart needed
	Only if you have a dedicated GPU and the WDDM version is 2.7 or higher

	Включить планирование графического процессора с аппаратным ускорением. Необходима перезагрузка
	Только при наличии дискретной видеокарты и WDDM версии 2.7 и выше
#>
GPUScheduling -Enable

# Turn off hardware-accelerated GPU scheduling (default value). Restart needed
# Выключить планирование графического процессора с аппаратным ускорением (значение по умолчанию). Необходима перезагрузка
# GPUScheduling -Disable
#endregion Gaming

#region Scheduled tasks
<#
	Create the "Windows Cleanup" scheduled task for cleaning up unused Windows files and updates.
	A native interactive toast notification pops up every 30 days

	Создать задание "Windows Cleanup" по очистке неиспользуемых файлов и обновлений Windows в Планировщике заданий.
	Каждые 30 дней появляется интерактивное всплывающее уведомление
#>
CleanupTask -Register

# Delete the "Windows Cleanup" and "Windows Cleanup Notification" scheduled tasks for cleaning up unused Windows files and updates
# Удалить задания "Windows Cleanup" и "Windows Cleanup Notification" по очистке неиспользуемых файлов и обновлений Windows из Планировщика заданий
# CleanupTask -Delete

<#
	Create the "SoftwareDistribution" scheduled task for cleaning up the %SystemRoot%\SoftwareDistribution\Download folder
	The task will wait until the Windows Update service finishes running. The task runs every 90 days

	Создать задание "SoftwareDistribution" по очистке папки %SystemRoot%\SoftwareDistribution\Download в Планировщике заданий
	Задание будет ждать, пока служба обновлений Windows не закончит работу. Задание выполняется каждые 90 дней
#>
SoftwareDistributionTask -Register

# Delete the "SoftwareDistribution" scheduled task for cleaning up the %SystemRoot%\SoftwareDistribution\Download folder
# Удалить задание "SoftwareDistribution" по очистке папки %SystemRoot%\SoftwareDistribution\Download из Планировщика заданий
# SoftwareDistributionTask -Delete

<#
	Create the "Temp" scheduled task for cleaning up the %TEMP% folder
	Only files older than one day will be deleted. The task runs every 60 days

	Создать задание "Temp" в Планировщике заданий по очистке папки %TEMP%
	Удаляться будут только файлы старше одного дня. Задание выполняется каждые 60 дней
#>
TempTask -Register

# Delete the "Temp" scheduled task for cleaning up the %TEMP% folder
# Удалить задание "Temp" по очистке папки %TEMP% из Планировщика заданий
# TempTask -Delete
#endregion Scheduled tasks

#region Microsoft Defender & Security
# Enable Microsoft Defender Exploit Guard network protection
# Включить защиту сети в Microsoft Defender Exploit Guard
NetworkProtection -Enable

# Disable Microsoft Defender Exploit Guard network protection (default value)
# Выключить защиту сети в Microsoft Defender Exploit Guard (значение по умолчанию)
# NetworkProtection -Disable

# Enable detection of potentially unwanted applications and block them
# Включить обнаружение потенциально нежелательных приложений и блокировать их
PUAppsDetection -Enable

# Disable detection of potentially unwanted applications (default value)
# Выключить обнаружение потенциально нежелательных приложений (значение по умолчанию)
# PUAppsDetection -Disable

# Enable sandboxing for Microsoft Defender. Restart needed
# Включить песочницу для Microsoft Defender. Необходима перезагрузка
DefenderSandbox -Enable

# Disable sandboxing for Microsoft Defender (default value). Restart needed
# Выключить песочницу для Microsoft Defender (значение по умолчанию). Необходима перезагрузка
# DefenderSandbox -Disable

# Enable logging of running processes, including their arguments, and PowerShell scripts, and create the custom "Process Creation" view in Event Viewer
# Включить журналирование запущенных процессов, включая их аргументы, и скриптов PowerShell, а также создать настраиваемое представление "Создание процесса" в Просмотре событий
EventViewerCustomView -Enable

# Disable logging of running processes, including their arguments, and PowerShell scripts, and remove the custom "Process Creation" view from Event Viewer (default value)
# Выключить журналирование запущенных процессов, включая их аргументы, и скриптов PowerShell, а также удалить настраиваемое представление "Создание процесса" из Просмотра событий (значение по умолчанию)
# EventViewerCustomView -Disable

# Enable checking of apps and files with Microsoft Defender SmartScreen (default value)
# Включить проверку приложений и файлов фильтром SmartScreen в Microsoft Defender (значение по умолчанию)
AppsSmartScreen -Enable

# Disable checking of apps and files with Microsoft Defender SmartScreen
# Выключить проверку приложений и файлов фильтром SmartScreen в Microsoft Defender
# AppsSmartScreen -Disable

# Disable the Attachment Manager marking files that have been downloaded from the Internet as unsafe
# Выключить отметку Диспетчером вложений файлов, скачанных из интернета, как небезопасных
SaveZoneInformation -Disable

# Enable the Attachment Manager marking files that have been downloaded from the Internet as unsafe (default value)
# Включить отметку Диспетчером вложений файлов, скачанных из интернета, как небезопасных (значение по умолчанию)
# SaveZoneInformation -Enable

# Enable DNS-over-HTTPS using Cloudflare DNS
# Включить DNS-over-HTTPS, используя DNS от Cloudflare
DNSoverHTTPS -Cloudflare

# Enable DNS-over-HTTPS using Google Public DNS
# Включить DNS-over-HTTPS, используя DNS от Google Public DNS
# DNSoverHTTPS -Google

# Enable DNS-over-HTTPS using Quad9 DNS
# Включить DNS-over-HTTPS, используя DNS от Quad9
# DNSoverHTTPS -Quad9

# Enable DNS-over-HTTPS using AdGuard DNS
# Включить DNS-over-HTTPS, используя DNS от AdGuard
# DNSoverHTTPS -AdGuard

# Enable DNS-over-HTTPS using OpenDNS
# Включить DNS-over-HTTPS, используя DNS от OpenDNS
# DNSoverHTTPS -OpenDNS

# Set default ISP's DNS servers (default value)
# Установить DNS-серверы вашего провайдера (значение по умолчанию)
# DNSoverHTTPS -Reset

# Enable Local Security Authority protection to prevent code injection. Restart needed
# Включить защиту локальной системы безопасности, чтобы предотвратить внедрение кода. Необходима перезагрузка
# LocalSecurityAuthority -Enable

# Disable Local Security Authority protection (default value). Restart needed
# Выключить защиту локальной системы безопасности (значение по умолчанию). Необходима перезагрузка
# LocalSecurityAuthority -Disable

# Choose when to be notified about changes to your computer: never notify
# Настройка уведомления об изменении параметров компьютера: никогда не уведомлять
AdminApprovalMode -Never

# Choose when to be notified about changes to your computer: notify me only when apps try to make changes to my computer (default value)
# Настройка уведомления об изменении параметров компьютера: уведомлять меня только при попытках приложений внести изменения в компьютер (значение по умолчанию)
# AdminApprovalMode -Default
#endregion Microsoft Defender & Security

#region Context menu
# Show the "Extract all" item in the Windows Installer (.msi) context menu
# Отобразить пункт "Извлечь все" в контекстном меню Windows Installer (.msi)
MSIExtractContext -Show

# Hide the "Extract all" item from the Windows Installer (.msi) context menu (default value)
# Скрыть пункт "Извлечь все" из контекстного меню Windows Installer (.msi) (значение по умолчанию)
# MSIExtractContext -Hide

# Show the "Install" item in the Cabinet (.cab) file context menu
# Отобразить пункт "Установить" в контекстном меню .cab архивов
CABInstallContext -Show

# Hide the "Install" item from the Cabinet (.cab) file context menu (default value)
# Скрыть пункт "Установить" из контекстного меню .cab архивов (значение по умолчанию)
# CABInstallContext -Hide

# Hide the "Look for an app in the Microsoft Store" item in the "Open with" dialog
# Скрыть пункт "Поиск приложения в Microsoft Store" в диалоге "Открыть с помощью"
UseStoreOpenWith -Hide

# Show the "Look for an app in the Microsoft Store" item in the "Open with" dialog (default value)
# Отобразить пункт "Поиск приложения в Microsoft Store" в диалоге "Открыть с помощью" (значение по умолчанию)
# UseStoreOpenWith -Show

# Open Windows Terminal from the context menu as administrator by default
# Открывать Windows Terminal из контекстного меню от имени администратора по умолчанию
OpenWindowsTerminalAdminContext -Enable

# Do not open Windows Terminal from the context menu as administrator by default (default value)
# Не открывать Windows Terminal из контекстного меню от имени администратора по умолчанию (значение по умолчанию)
# OpenWindowsTerminalAdminContext -Disable
#endregion Context menu

#region Update Policies
# Scan the Windows registry and display applied registry policies in the Local Group Policy Editor snap-in (gpedit.msc)
# Просканировать реестр и отобразить примененные политики реестра в оснастке редактирования групповых политик (gpedit.msc)
# ScanRegistryPolicies
#endregion Update Policies

# Post actions
# Завершающие действия
PostActions
