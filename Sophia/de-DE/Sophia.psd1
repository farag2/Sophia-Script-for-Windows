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
OneDriveNoInternetConnection = Keine Internetverbindung

# TempPath
LOCALAPPDATAFilesBlocked = "The following files are being blocked by third-party party apps `nRemove them manually and continue"
LOCALAPPDATANotEmpty = "Der Ordner $env:LOCALAPPDATA\\Temp ist nicht leer. Löschen Sie ihn manuell und versuchen Sie es erneut"

# DisableWindowsCapabilities
FODWindowTitle = Optionale Funktionen (FODv2) zum Entfernen
FODWindowButton = Deinstallieren
DialogBoxOpening = Dialogfeld anzeigen...
NoData = Nichts zum Anzeigen

# WindowsSandbox
EnableHardwareVT = Virtualisierung in UEFI aktivieren

# ChangeUserShellFolderLocation
UserShellFolderNotEmpty = "Der Ordner $UserShellFolderRegValue ist nicht leer. Verschieben Sie sie manuell an einen neuen Speicherort"
RetrievingDrivesList = Laufwerksliste abrufen...
# Desktop
DesktopDriveSelect = Wählen Sie das Laufwerk aus, in dessen Stammverzeichnis der Desktop Ordner erstellt werden soll
DesktopFilesWontBeMoved = Dateien werden nicht verschoben
DesktopFolderRequest = Möchten Sie den Speicherort des Desktop Ordners ändern?
DesktopFolderChange = Ändern
DesktopFolderSkip = Überspringen
DesktopSkipped = Übersprungen
# Documents
DocumentsDriveSelect = Wählen Sie das Laufwerk aus, in dessen Stammverzeichnis der Ordner Dokumente erstellt werden soll
DocumentsFilesWontBeMoved = Dateien werden nicht verschoben
DocumentsFolderRequest = Möchten Sie den Speicherort des Ordners Dokumente ändern?
DocumentsFolderChange = Ändern
DocumentsFolderSkip = Überspringen
DocumentsSkipped = Übersprungen
# Downloads
DownloadsDriveSelect = Wählen Sie das Laufwerk aus, in dessen Stammverzeichnis der Ordner Downloads erstellt werden soll
DownloadsFilesWontBeMoved = Dateien werden nicht verschoben
DownloadsFolderRequest = Möchten Sie den Speicherort des Download Ordners ändern?
DownloadsFolderChange = Ändern
DownloadsFolderSkip = Überspringen
DownloadsSkipped = Übersprungen
# Music
MusicDriveSelect = Wählen Sie das Laufwerk aus, in dessen Stammverzeichnis der Musikordner erstellt werden soll
MusicFilesWontBeMoved = Dateien werden nicht verschoben
MusicFolderRequest = Möchten Sie den Speicherort des Musikordners ändern?
MusicFolderChange = Ändern
MusicFolderSkip = Überspringen
MusicSkipped = Übersprungen
# Pictures
PicturesDriveSelect = Wählen Sie das Laufwerk aus, in dessen Stammverzeichnis der Ordner Bilder erstellt werden soll
PicturesFilesWontBeMoved = Dateien werden nicht verschoben
PicturesFolderRequest = Möchten Sie den Speicherort des Ordner Bilder ändern?
PicturesFolderChange = Ändern
PicturesFolderSkip = Überspringen
PicturesSkipped = Übersprungen
# Videos
VideosDriveSelect = Wählen Sie das Laufwerk aus, in dessen Stammverzeichnis der Ordner Videos erstellt werden soll
VideosFilesWontBeMoved = Dateien werden nicht verschoben
VideosFolderRequest = Möchten Sie den Speicherort des Video Ordners ändern?
VideosFolderChange = Ändern
VideosFolderSkip = Überspringen
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

# ReservedStorage
ReservedStorageIsInUse = Dieser Vorgang wird nicht unterstützt, wenn reservierter Speicher verwendet wird. Bitte warten Sie, bis alle Wartungsvorgänge abgeschlossen sind, und versuchen Sie es später erneut

# syspin
syspinNoInternetConnection = Keine Internetverbindung
syspinDownloading = Syspin herunterladen... ~20 KB

# PinControlPanel/PinDevicesPrinters/PinCommandPrompt
ControlPanelPinning = "Die Verknüpfung $ControlPanelLocalizedName wird an Start angeheftet"
DevicesPrintersPinning = "Die Verknüpfung $DevicesAndPrintersLocalizedName wird an Start angeheftet"
CMDPinning = Die Verknüpfung zur Eingabeaufforderung wird an Start angeheftet

# UninstallUWPApps
UninstallUWPForAll = Deinstallieren für alle Benutzer
UninstallUWPTitle = Zu deinstallierende UWP-Pakete
UninstallUWPUninstallButton = Deinstallieren

# WSL
WSLUpdateDownloading = Herunterladen des Linux-Kernel-Update-Pakets... ~14 MB
WSLUpdateInstalling = Installieren des Linux-Kernel-Update-Pakets...

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
