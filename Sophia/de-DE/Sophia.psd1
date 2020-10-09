# Entfernen Sie keine doppelten Anführungszeichen, wenn diese vorhanden sind

ConvertFrom-StringData -StringData @'
UnsupportedOSBitness = Das Skript unterstützt nur Windows 10 x64
ControlledFolderAccessDisabled = Kontrollierter Ordnerzugriff deaktiviert

# OneDrive
OneDriveUninstalling = Deinstalliere OneDrive...
OneDriveNotEmptyFolder = "Der Ordner $OneDriveUserFolder ist nicht leer.Löschen Sie ihn manuell. "
OneDriveFileSyncShell64dllBlocked = "$FileSyncShell64dll ist blockiert. Löschen Sie es manuell"
OneDriveInstalling = OneDriveSetup.exe wird gestartet...
OneDriveDownloading = OneDrive herunterladen... ~33 MB
NoInternetConnection = Keine Internetverbindung

# SetTempPath
LOCALAPPDATANotEmptyFolder = "Der Ordner $env:LOCALAPPDATA\\Temp ist nicht leer. Löschen Sie ihn manuell und versuchen Sie es erneut"

# WSL
WSLUpdateDownloading = Herunterladen des Linux-Kernel-Update-Pakets... ~14 MB
WSLUpdateInstalling = Installieren des Linux-Kernel-Update-Pakets...

# DisableWindowsCapabilities
FODWindowTitle = Optionale Funktionen (FODv2) zum Entfernen
FODWindowButton = Deinstallieren
DialogBoxOpening = Dialogfeld anzeigen...
NoData = Nichts zum Anzeigen

# EnableWindowsSandbox/DisableWindowsSandbox
EnableHardwareVT = Virtualisierung in UEFI aktivieren

# ChangeUserShellFolderLocation
UserShellFolderNotEmpty = "Der Ordner $UserShellFolderRegValue ist nicht leer. Verschieben Sie sie manuell an einen neuen Speicherort"
RetrievingDrivesList = Laufwerksliste abrufen...
# Desktop
DesktopChangeFolderRequest = Möchten Sie den Speicherort des Desktop Ordners ändern?
DesktopFilesWontBeMoved = Dateien werden nicht verschoben
DesktopFolderChange = Ändern
DesktopFolderSkip = Überspringen
DesktopDriveSelect = Wählen Sie das Laufwerk aus, in dessen Stammverzeichnis der Desktop Ordner erstellt werden soll
DesktopSkipped = Übersprungen
# Documents
DocumentsChangeFolderRequest = Möchten Sie den Speicherort des Ordners Dokumente ändern?
DocumentsFilesWontBeMoved = Dateien werden nicht verschoben
DocumentsFolderChange = Ändern
DocumentsFolderSkip = Überspringen
DocumentsDriveSelect = Wählen Sie das Laufwerk aus, in dessen Stammverzeichnis der Ordner Dokumente erstellt werden soll
DocumentsSkipped = Übersprungen
# Downloads
DownloadsChangeFolderRequest = Möchten Sie den Speicherort des Download Ordners ändern?
DownloadsFilesWontBeMoved = Dateien werden nicht verschoben
DownloadsFolderChange = Ändern
DownloadsFolderSkip = Überspringen
DownloadsDriveSelect = Wählen Sie das Laufwerk aus, in dessen Stammverzeichnis der Ordner Downloads erstellt werden soll
DownloadsSkipped = Übersprungen
# Music
MusicChangeFolderRequest = Möchten Sie den Speicherort des Musikordners ändern?
MusicFilesWontBeMoved = Dateien werden nicht verschoben
MusicFolderChange = Ändern
MusicFolderSkip = Überspringen
MusicDriveSelect = Wählen Sie das Laufwerk aus, in dessen Stammverzeichnis der Musikordner erstellt werden soll
MusicSkipped = Übersprungen
# Pictures
PicturesChangeFolderRequest = Möchten Sie den Speicherort des Ordner Bilder ändern?
PicturesFilesWontBeMoved = Dateien werden nicht verschoben
PicturesFolderChange = Ändern
PicturesFolderSkip = Überspringen
PicturesDriveSelect = Wählen Sie das Laufwerk aus, in dessen Stammverzeichnis der Ordner Bilder erstellt werden soll
PicturesSkipped = Übersprungen
# Videos
VideosChangeFolderRequest = Möchten Sie den Speicherort des Video Ordners ändern?
VideosFilesWontBeMoved = Dateien werden nicht verschoben
VideosFolderChange = Ändern
VideosFolderSkip = Überspringen
VideosDriveSelect = Wählen Sie das Laufwerk aus, in dessen Stammverzeichnis der Ordner Videos erstellt werden soll
VideosSkipped = Übersprungen

# SetDefaultUserShellFolderLocation
# Desktop
DesktopDefaultFolder = Möchten Sie den Speicherort des Desktop Ordners auf den Standardwert ändern?
# Documents
DocumentsDefaultFolder = Möchten Sie den Speicherort des Ordners Dokumente auf den Standardwert ändern?
# Downloads
DownloadsDefaultFolder = Möchten Sie den Speicherort des Download Ordners auf den Standardwert ändern?
# Music
MusicDefaultFolder = Möchten Sie den Speicherort des Musikordners auf den Standardwert ändern?
# Pictures
PicturesDefaultFolder = Möchten Sie den Speicherort des Ordners Bilder auf den Standardwert ändern?
# Videos
VideosDefaultFolder = Möchten Sie den Speicherort des Video Ordners auf den Standardwert ändern?

# DisableReservedStorage
ReservedStorageIsInUse = Dieser Vorgang wird nicht unterstützt, wenn reservierter Speicher verwendet wird. Bitte warten Sie, bis alle Wartungsvorgänge abgeschlossen sind, und versuchen Sie es später erneut

# PinControlPanel/PinDevicesPrinters/PinCommandPrompt
syspinDownloading = Syspin herunterladen... ~20 KB
ControlPanelPinning = "Die Verknüpfung $ControlPanelLocalizedName wird an Start angeheftet"
DevicesPrintersPinning = "Die Verknüpfung $DevicesAndPrintersLocalizedName wird an Start angeheftet"
CMDPinning = Die Verknüpfung zur Eingabeaufforderung wird an Start angeheftet

# UninstallUWPApps
UninstallUWPForAll = Deinstallieren für alle Benutzer
UninstallUWPTitle = Zu deinstallierende UWP-Pakete
UninstallUWPUninstallButton = Deinstallieren

# SetAppGraphicsPerformance
GraphicsPerformanceTitle = Grafik-Leistungspräferenz
GraphicsPerformanceRequest = Möchten Sie die Grafikleistungseinstellung einer App Ihrer Wahl auf "Hohe Leistung" setzen?"?
GraphicsPerformanceAdd = Hinzufügen
GraphicsPerformanceSkip = Überspringen
GraphicsPerformanceFilter = *.exe|*.exe|Alle Dateien (*.*)|*.*
GraphicsPerformanceSkipped = Übersprungen

# CreateCleanUpTask
CleanUpTaskToast = Die Bereinigung nicht verwendeter Windows-Dateien und -Updates beginnt in einer Minute
CleanUpTaskDescription = Bereinigen nicht verwendeter Windows-Dateien und -Updates mithilfe der integrierten App zur Datenträgerbereinigung. Verwenden Sie zum Dekodieren des codierten Befehls [System.Text.Encoding] :: UTF8.GetString ([System.Convert] :: FromBase64String ("string")).

# CreateSoftwareDistributionTask
SoftwareDistributionTaskDescription = Der %SystemRoot%\\SoftwareDistribution\\Download

# CreateTempTask
TempTaskDescription = Bereinigen des %TEMP% Ordners

# AddProtectedFolders
AddProtectedFoldersTitle = Kontrollierter Ordnerzugriff
AddProtectedFoldersRequest = Möchten Sie den kontrollierten Ordnerzugriff aktivieren und den Ordner angeben, den Microsoft Defender vor schädlichen Apps und Bedrohungen schützt??
AddProtectedFoldersAdd = Hinzufügen
AddProtectedFoldersSkip = Überspringen
AddProtectedFoldersDescription = Wählen Sie einen Ordner
AddProtectedFoldersSkipped = Übersprungen

# RemoveProtectedFolders
RemoveProtectedFoldersList = Ordner entfernt

# AddAppControlledFolder
AddAppControlledFolderTitle = Kontrollierter Ordnerzugriff
AddAppControlledFolderRequest = Möchten Sie eine App angeben, die über den Zugriff auf kontrollierte Ordner zulässig ist?
AddAppControlledFolderAdd = Hinzufügen
AddAppControlledFolderSkip = Überspringen
AddAppControlledFolderFilter = *.exe|*.exe|Alle Dateien (*.*)|*.*
AddAppControlledFolderSkipped = Übersprungen

# RemoveAllowedAppsControlledFolder
RemoveAllowedAppsControlledFolderList = Zulässige Apps entfernt

# AddDefenderExclusionFolder
AddDefenderExclusionFolderTitle = Microsoft Defender
AddDefenderExclusionFolderRequest = Möchten Sie einen Ordner angeben, der von Microsoft Defender-Malware-Scans ausgeschlossen werden soll?
AddDefenderExclusionFolderAdd = Hinzufügen
AddDefenderExclusionFolderSkip = Überspringen
AddDefenderExclusionFolderDescription = Wählen Sie einen Ordner
AddDefenderExclusionFolderSkipped = Übersprungen

# RemoveDefenderExclusionFolders
RemoveDefenderExclusionFoldersList = Ausgeschlossene Ordner entfernt

# AddDefenderExclusionFile
AddDefenderExclusionFileTitle = Microsoft Defender
AddDefenderExclusionFileRequest = Möchten Sie eine Datei angeben, die von Microsoft Defender-Malware-Scans ausgeschlossen werden soll?
AddDefenderExclusionFileAdd = Hinzufügen
AddDefenderExclusionFileSkip = Überspringen
AddDefenderExclusionFileFilter = Alle Dateien (*.*)|*.*
AddDefenderExclusionFileSkipped = Übersprungen

# RemoveDefenderExclusionFiles
RemoveDefenderExclusionFilesList = Ausgeschlossene Dateien entfernt

# CreateEventViewerCustomView
EventViewerCustomViewName = Prozesserstellung
EventViewerCustomViewDescription = Neue Prozessereignisse und Befehlszeilenüberwachung

# Refresh
RestartWarning = Starten Sie Ihren PC neu

# Errors
ErrorsLine = Zeile
ErrorsFile = Datei
ErrorsMessage = Fehler/Warnungen
'@
