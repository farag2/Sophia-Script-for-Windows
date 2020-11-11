# Do not remove double quotes in double-quoted strings where they are present

ConvertFrom-StringData -StringData @'
UnsupportedOSBitness = Questo script supporta solo Windows 10 x64
ControlledFolderAccessDisabled = Accesso controllato alle cartelle disabilitato

# OneDrive
OneDriveUninstalling = Disinstalla OneDrive...
OneDriveNotEmptyFolder = "La cartella $OneDriveUserFolder non è vuota `nEliminarla manualmente"
OneDriveFileSyncShell64dllBlocked = "$FileSyncShell64dll è bloccato `nEliminarla manualmente"
OneDriveInstalling = OneDriveSetup.exe è in esecuzione...
OneDriveDownloading = Scaricamento di OneDrive... ~33 MB
OneDriveNoInternetConnection = Nessuna connessione Internet

# TempPath
LOCALAPPDATAFilesBlocked = "The following files are being blocked by third-party party apps `nRemove them manually and continue"
LOCALAPPDATANotEmpty = "La cartella $env:LOCALAPPDATA\\Temp non è vuota `nEliminarla manualmente e riprovare"

# DisableWindowsCapabilities
FODWindowTitle = Funzionalità facoltative (FODv2) da rimuovere
FODWindowButton = Disinstalla
DialogBoxOpening = Visualizzazione della finestra di dialogo...
NoData = Nulla da visualizzare

# WindowsSandbox
EnableHardwareVT = Attiva Virtualizzazione in UEFI

# ChangeUserShellFolderLocation
UserShellFolderNotEmpty = "Sono rimasti alcuni file nella cartella $UserShellFolderRegValue `nSpostarli manualmente in una nuova posizione"
RetrievingDrivesList = Recupero lista delle unità...
# Desktop
DesktopDriveSelect = Seleziona l'unità dove verrà creta la cartella Dekstop
DesktopFilesWontBeMoved = I file non verranno spostati
DesktopFolderRequest = Vuoi veramente cambiare la posizione della cartella Desktop?
DesktopFolderChange = Cambia
DesktopFolderSkip = Salta
DesktopSkipped = Saltato
# Documents
DocumentsDriveSelect = Seleziona l'unità dove verrà creta la cartella Documenti
DocumentsFilesWontBeMoved = I file non verranno spostati
DocumentsFolderRequest = Vuoi veramente cambiare la posizione della cartella Documenti?
DocumentsFolderChange = Cambia
DocumentsFolderSkip = Salta
DocumentsSkipped = Saltato
# Downloads
DownloadsDriveSelect = Seleziona l'unità dove verrà creta la cartella Download
DownloadsFilesWontBeMoved = I file non verranno spostati
DownloadsFolderRequest = Vuoi veramente cambiare la posizione della cartella Download?
DownloadsFolderChange = Cambia
DownloadsFolderSkip = Salta
DownloadsSkipped = Saltato
# Music
MusicDriveSelect = Seleziona l'unità dove verrà creta la cartella Musica
MusicFilesWontBeMoved = I file non verranno spostati
MusicFolderRequest = Vuoi veramente cambiare la posizione della cartella Musica?
MusicFolderChange = Cambia
MusicFolderSkip = Salta
MusicSkipped = Saltato
# Pictures
PicturesDriveSelect = Seleziona l'unità dove verrà creta la cartella Immagini
PicturesFilesWontBeMoved = I file non verranno spostati
PicturesFolderRequest = Vuoi veramente cambiare la posizione della cartella Immagini?
PicturesFolderChange = Cambia
PicturesFolderSkip = Salta
PicturesSkipped = Saltato
# Videos
VideosDriveSelect = Seleziona l'unità dove verrà creta la cartella Video
VideosFilesWontBeMoved = I file non verranno spostati
VideosFolderRequest = Vuoi veramente cambiare la posizione della cartella Video?
VideosFolderChange = Cambia
VideosFolderSkip = Salta
VideosSkipped = Saltato

# SetDefaultUserShellFolderLocation
# Desktop
DesktopDefaultFolder = Desideri modificare cambiare la posizione della cartella Desktop sul valore predefinito?
# Documents
DocumentsDefaultFolder = Desideri modificare cambiare la posizione della cartella Documenti sul valore predefinito?
# Downloads
DownloadsDefaultFolder = Desideri modificare cambiare la posizione della cartella Download sul valore predefinito?
# Music
MusicDefaultFolder = Desideri modificare la posizione della cartella Musica sul valore predefinito?
# Pictures
PicturesDefaultFolder = Desideri modificare la posizione della cartella Immagini sul valore predefinito?
# Videos
VideosDefaultFolder = Desideri modificare la posizione della cartella Video sul valore predefinito?

# ReservedStorage
ReservedStorageIsInUse = Questa oprazione non è supportata quando reserved storage è in uso `nAttendere il completamento delle operazioni di manutenzione e riprovare più tardi

# syspin
syspinNoInternetConnection = essuna connessione Internet
syspinDownloading = Scaricamento disyspin... ~20 KB

# PinControlPanel/PinDevicesPrinters/PinCommandPrompt
ControlPanelPinning = "Il collegamento a $ControlPanelLocalizedName è stato bloccato nel menu Start"
DevicesPrintersPinning = "Il collegamento a $DevicesAndPrintersLocalizedName è stato bloccato nel menu Start"
CMDPinning = Il collegamento al Prompt dei Comandi è stato bloccato nel menu Start

# UninstallUWPApps
UninstallUWPForAll = Rimuovi per Tutti gli utenti
UninstallUWPTitle = Pacchetti UWP Packages da Rimuovere
UninstallUWPUninstallButton = Rimuovi

# WSL
WSLUpdateDownloading = Scaricamento del paccheto aggiornato di Linux kernel... ~14 MB
WSLUpdateInstalling = Installazione del paccheto aggiornato di Linux kernel...

# SetAppGraphicsPerformance
GraphicsPerformanceTitle = Preferenze prestazioni della Grafica
GraphicsPerformanceRequest = Desideri impostare le prestazioni grafiche di un'app di tua scelta su "Prestazioni elevate"?
GraphicsPerformanceAdd = Aggiungi
GraphicsPerformanceSkip = Salta
GraphicsPerformanceFilter = *.exe|*.exe|Tutti i file (*.*)|*.*
GraphicsPerformanceSkipped = Saltato

# CreateCleanUpTask
CleanUpTaskToast = La pulizia dei file e degli aggiornamenti di Windows inutilizzati inizia in un minuto
CleanUpTaskDescription = Pulizia di file e aggiornamenti di Windows inutilizzati utilizzando l'app di pulizia del disco incorporata. Per decodificare il comando codificato utilizzare [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("string"))

# CreateSoftwareDistributionTask
SoftwareDistributionTaskDescription = Pulizia della cartella %SystemRoot%\\SoftwareDistribution\\Download

# CreateTempTask
TempTaskDescription = Pulizia della cartella %TEMP%

# AddProtectedFolders
AddProtectedFoldersTitle = Accesso controllato alle cartelle
AddProtectedFoldersRequest = Desideri abilitare l'accesso controllato alle cartelle e specificare la cartella che Microsoft Defender proteggerà dalle app dannose e dalle minacce?
AddProtectedFoldersAdd = Aggiungi
AddProtectedFoldersSkip = Salta
AddProtectedFoldersDescription = Seleziona una cartella
AddProtectedFoldersSkipped = Saltato

# RemoveProtectedFolders
RemoveProtectedFoldersList = Cartelle rimosse

# AddAppControlledFolder
AddAppControlledFolderTitle = Accesso controllato alle cartelle
AddAppControlledFolderRequest = Desideri specificare un'app consentita tramite l'accesso alle cartelle controllate?
AddAppControlledFolderAdd = Aggiungi
AddAppControlledFolderSkip = Salta
AddAppControlledFolderFilter = *.exe|*.exe|Tutti i file (*.*)|*.*
AddAppControlledFolderSkipped = Saltato

# RemoveAllowedAppsControlledFolder
RemoveAllowedAppsControlledFolderList = App consentite rimosse

# AddDefenderExclusionFolder
AddDefenderExclusionFolderTitle = Microsoft Defender
AddDefenderExclusionFolderRequest = Desideri specificare una cartella da escludere dalle scansioni del malware di Microsoft Defender?
AddDefenderExclusionFolderAdd = Aggiungi
AddDefenderExclusionFolderSkip = Salta
AddDefenderExclusionFolderDescription = Seleziona una cartella
AddDefenderExclusionFolderSkipped = Saltato

# RemoveDefenderExclusionFolders
RemoveDefenderExclusionFoldersList = Cartelle escluse rimosse

# AddDefenderExclusionFile
AddDefenderExclusionFileTitle = Microsoft Defender
AddDefenderExclusionFileRequest = Desideri specificare un file da escludere dalle scansioni del malware di Microsoft Defender?
AddDefenderExclusionFileAdd = Aggiungi
AddDefenderExclusionFileSkip = Salta
AddDefenderExclusionFileFilter = Tutti i file (*.*)|*.*
AddDefenderExclusionFileSkipped = Saltato

# RemoveDefenderExclusionFiles
RemoveDefenderExclusionFilesList = File esclusi rimossi

# CreateEventViewerCustomView
EventViewerCustomViewName = Creazione del Processo
EventViewerCustomViewDescription = Creazione di Processi ed Eventi di Controllo dalla riga di comando

# Refresh
RestartWarning = Riavvia il Computer

# Errors
ErrorsLine = Linea
ErrorsFile = File
ErrorsMessage = Errori/Avvisi
'@
