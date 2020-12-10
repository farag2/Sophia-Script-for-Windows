# Не видаляйте подвійні лапки в рядках з подвійними лапками, якщо вони присутні

ConvertFrom-StringData -StringData @'
UnsupportedOSBitness = Скрипт підтримує тільки Windows 10 x64
ControlledFolderAccessDisabled = Контрольований доступ до папок вимкнений

# OneDrive
OneDriveUninstalling = Видалення OneDrive...
OneDriveNotEmptyFolder = "Папка $OneDriveUserFolder не порожня. Видаліть її вручну"
OneDriveFileSyncShell64dllBlocked = "$FileSyncShell64dll заблокований. Видаліть його вручну"
OneDriveInstalling = Очікуємо вигрузку файла FileSyncShell64.dll
OneDriveDownloading = Завантажується OneDrive... ~33 МБ
OneDriveNoInternetConnection = Відсутнє інтернет-з'єднання

# TempPath
LOCALAPPDATAFilesBlocked = "The following files are being blocked by third-party party apps `nRemove them manually and continue"
LOCALAPPDATANotEmpty = "Папка $env:LOCALAPPDATA\\Temp не порожня. Очистіть її вручну і спробуйте ще раз"

# DisableWindowsCapabilities
FODWindowTitle = Видалити додаткові компоненти
FODWindowButton = Видалити
DialogBoxOpening = Діалогове вікно відкривається...
NoData = Відсутні дані

# WindowsSandbox
EnableHardwareVT = Увімкніть віртуалізацію в UEFI

# ChangeUserShellFolderLocation
UserShellFolderNotEmpty = "У папці $UserShellFolderRegValue залишились файли. Перемістіть їх вручну в нове розташування"
RetrievingDrivesList = Отримання списку дисків...
# Робочий стіл
DesktopDriveSelect = Виберіть диск, в корені якого буде створена папка для "Робочий стіл"
DesktopFilesWontBeMoved = Файли не будуть перенесені
DesktopFolderRequest = Бажаєте змінити місце розташування папки "Робочий стіл"?
DesktopFolderChange = Змінити
DesktopFolderSkip = Пропустити
DesktopSkipped = Пропущено
# Документи
DocumentsDriveSelect = Виберіть диск, в корені якого буде створена папка для "Документи"
DocumentsFilesWontBeMoved = Файли не будуть перенесені
DocumentsFolderRequest = Бажаєте змінити місце розташування папки "Документи"?
DocumentsFolderChange = Змінити
DocumentsFolderSkip = Пропустити
DocumentsSkipped = Пропущено
# Завантаження
DownloadsDriveSelect = Виберіть диск, в корені якого буде створена папка для "Завантаження"
DownloadsFilesWontBeMoved = Файли не будуть перенесені
DownloadsFolderRequest = Бажаєте змінити місце розташування папки "Завантаження"?
DownloadsFolderChange = Змінити
DownloadsFolderSkip = Пропустити
DownloadsSkipped = Пропущено
# Музика
MusicDriveSelect = Виберіть диск, в корені якого буде створена папка для "Музика"
MusicFilesWontBeMoved = Файли не будуть перенесені
MusicFolderRequest = Бажаєте змінити місце розташування папки "Музика"?
MusicFolderChange = Змінити
MusicFolderSkip = Пропустити
MusicSkipped = Пропущено
# Зображення
PicturesDriveSelect = Виберіть диск, в корені якого буде створена папка для "Зображення"
PicturesFilesWontBeMoved = Файли не будуть перенесені
PicturesFolderRequest = Бажаєте змінити місце розташування папки "Зображення"?
PicturesFolderChange = Змінити
PicturesFolderSkip = Пропустити
PicturesSkipped = Пропущено
# Відео
VideosDriveSelect = Виберіть диск, в корені якого буде створена папка для "Відео"
VideosFilesWontBeMoved = Файли не будуть перенесені
VideosFolderRequest = Бажаєте змінити місце розташування папки "Відео"?
VideosFolderChange = Змінити
VideosFolderSkip = Пропустити
VideosSkipped = Пропущено

# SetDefaultUserShellFolderLocation
# Робочий стіл
DesktopDefaultFolder = Бажаєте змінити місце розташування папки "Робочий стіл" на значення за замовчуванням?
# Документи
DocumentsDefaultFolder = Бажаєте змінити місце розташування папки "Документи" на значення за замовчуванням?
# Завантаження
DownloadsDefaultFolder = Бажаєте змінити місце розташування папки "Завантаження" на значення за замовчуванням?
# Музика
MusicDefaultFolder = Бажаєте змінити місце розташування папки "Музика" на значення за замовчуванням?
# Зображення
PicturesDefaultFolder = Бажаєте змінити місце розташування папки "Зображення" на значення за замовчуванням?
# Відео
VideosDefaultFolder = Бажаєте змінити місце розташування папки "Відео" на значення за замовчуванням?

# DisableReservedStorage
ReservedStorageIsInUse = Ця операція не підтримується, коли використовується зарезервоване сховище. Дочекайтеся завершення будь-яких операцій з обслуговування і спробуйте ще раз.

# syspin
syspinNoInternetConnection = Відсутнє інтернет-з'єднання
syspinDownloading = Завантажується syspin... ~20 КБ

# PinControlPanel/PinDevicesPrinters/PinCommandPrompt
ControlPanelPinning = "Ярлик `"$ControlPanelLocalizedName`" закріплюється на початковому екрані"
DevicesPrintersPinning = "Ярлик `"$DevicesAndPrintersLocalizedName`" закріплюється на початковому екрані"
CMDPinning = Ярлик "Командний рядок" закріплюється на початковому екрані

# UninstallUWPApps
UninstallUWPForAll = Видалити для всіх користувачів
UninstallUWPTitle = Видалити UWP-додатки
UninstallUWPUninstallButton = Видалити

# WSL
WSLUpdateDownloading = Завантажується пакет оновлення ядра Linux... ~14 МБ
WSLUpdateInstalling = Встановлення пакета оновлення ядра Linux...

# SetAppGraphicsPerformance
GraphicsPerformanceTitle = Налаштування продуктивності графіки
GraphicsPerformanceRequest = Встановити для будь-якої програми за вашим вибором налаштування продуктивності графіки на "Висока продуктивність"?
GraphicsPerformanceAdd = Додати
GraphicsPerformanceSkip = Пропустити
GraphicsPerformanceFilter = *.exe|*.exe|Всі файли (*.*)|*.*
GraphicsPerformanceSkipped = Пропущено

# CreateCleanUpTask
CleanUpTaskToast = Очищення зайвих файлів і оновлень Windows почнеться через хвилину
CleanUpTaskDescription = Очищення зайвих файлів і оновлень Windows, використовуючи вбудовану програму очищення диска. Щоб розшифрувати закодований рядок використовуйте [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("рядок"))

# CreateSoftwareDistributionTask
SoftwareDistributionTaskDescription = Очищення папки %SystemRoot%\\SoftwareDistribution\\Download

# CreateTempTask
TempTaskDescription = Очищення папки %TEMP%

# AddProtectedFolders
AddProtectedFoldersTitle = Контрольований доступ до папок
AddProtectedFoldersRequest = Бажаєте увімкнути контрольований доступ до папок і вказати папку, яку Захисник Microsoft буде захищати від шкідливих додатків і загроз?
AddProtectedFoldersAdd = Додати
AddProtectedFoldersSkip = Пропустити
AddProtectedFoldersDescription = Виберіть папку
AddProtectedFoldersSkipped = Пропущено

# RemoveProtectedFolders
RemoveProtectedFoldersList = Видалені папки

# AddAppControlledFolder
AddAppControlledFolderTitle = Контрольований доступ до папок
AddAppControlledFolderRequest = Указать приложение, которому разрешена работа через контролируемый доступ к папкам
AddAppControlledFolderAdd = Додати
AddAppControlledFolderSkip = Пропустити
AddAppControlledFolderFilter = *.exe|*.exe|Всі файли (*.*)|*.*
AddAppControlledFolderSkipped = Пропущено

# RemoveAllowedAppsControlledFolder
RemoveAllowedAppsControlledFolderList = Видалені дозволені додатки

# AddDefenderExclusionFolder
AddDefenderExclusionFolderTitle = Microsoft Defender
AddDefenderExclusionFolderRequest = Вказати папку, щоб виключити її зі списку сканування Microsoft Defender?
AddDefenderExclusionFolderAdd = Додати
AddDefenderExclusionFolderSkip = Пропустити
AddDefenderExclusionFolderDescription = Виберіть папку
AddDefenderExclusionFolderSkipped = Пропущено

# RemoveDefenderExclusionFolders
RemoveDefenderExclusionFoldersList = Виключені папки видалено

# AddDefenderExclusionFile
AddDefenderExclusionFileTitle = Microsoft Defender
AddDefenderExclusionFileRequest = Вказати файл, щоб виключити його зі списку сканування Microsoft Defender?
AddDefenderExclusionFileAdd = Додати
AddDefenderExclusionFileSkip = Пропустити
AddDefenderExclusionFileFilter = Всі файли (*.*)|*.*
AddDefenderExclusionFileSkipped = Пропущено

# RemoveDefenderExclusionFiles
RemoveDefenderExclusionFilesList = Виключені файли видалено

# CreateEventViewerCustomView
EventViewerCustomViewName = Створення процесу
EventViewerCustomViewDescription = Події створення нового процесу і аудит командного рядка

# Refresh
RestartWarning = Перезавантажте ваш ПК

# Errors
ErrorsLine = Рядок
ErrorsFile = Файл
ErrorsMessage = Помилки/попередження
'@
