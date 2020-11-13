# No elimines las comillas dobles en las cadenas de texto con comillas dobles donde estas estén presentes

ConvertFrom-StringData -StringData @'
UnsupportedOSBitness = Este script solo soporta Windows 10 x64
ControlledFolderAccessDisabled = Control de acceso a carpeta deshabilitado

# OneDrive
OneDriveUninstalling = Desinstalando OneDrive...
OneDriveNotEmptyFolder = "La carpeta $OneDriveUserFolder no está vacía `nElimínela manualmente"
OneDriveFileSyncShell64dllBlocked = "$FileSyncShell64dll está bloqueado `nElimínelo manualmente"
OneDriveInstalling = OneDriveSetup.exe se está iniciando...
OneDriveDownloading = Descargando OneDrive... ~33 MB
OneDriveNoInternetConnection = No hay conexión a internet

# TempPath
LOCALAPPDATAFilesBlocked = "Los siguientes archivos están siendo bloqueados por aplicaciones de terceros `nEliménelos manualmente y continúe"
LOCALAPPDATANotEmpty = "La carpeta $env:LOCALAPPDATA\\Temp no está vacía `nLímpiela manualmente e inténtelo de nuevo"

# DisableWindowsCapabilities
FODWindowTitle = Características opcionales (FODv2) a eliminar
FODWindowButton = Desinstalar
DialogBoxOpening = Mostrando la caja de diálogo...
NoData = Nada que mostrar

# WindowsSandbox
EnableHardwareVT = Activar virtualización en UEFI

# ChangeUserShellFolderLocation
UserShellFolderNotEmpty = "Quedan algunos archivos en la carpeta $UserShellFolderRegValue `nMuévalos manualmente a la nueva ubicación"
RetrievingDrivesList = Recuperando lista de discos...
# Desktop
DesktopDriveSelect = Selecciona la raíz del disco en la cual se creará la carpeta del Escritorio
DesktopFilesWontBeMoved = Los archivos no se moverán
DesktopFolderRequest = Quieres cambiar la ubicación de la carpeta del Escritorio?
DesktopFolderChange = Cambiar
DesktopFolderSkip = Omitir
DesktopSkipped = Omitido
# Documents
DocumentsDriveSelect = Selecciona la raíz del disco en la cual se creará la carpeta de Documentos
DocumentsFilesWontBeMoved = Los archivos no se moverán
DocumentsFolderRequest = Quieres cambiar la ubicación de la carpeta de Documentos?
DocumentsFolderChange = Cambiar
DocumentsFolderSkip = Omitir
DocumentsSkipped = Omitido
# Downloads
DownloadsDriveSelect = Selecciona la raíz del disco en la cual se creará la carpeta de Descargas
DownloadsFilesWontBeMoved = Los archivos no se moverán
DownloadsFolderRequest = Quieres cambiar la ubicación de la carpeta de Descargas?
DownloadsFolderChange = Cambiar
DownloadsFolderSkip = Omitir
DownloadsSkipped = Omitido
# Music
MusicDriveSelect = Selecciona la raíz del disco en la cual se creará la carpeta de Música
MusicFilesWontBeMoved = Los archivos no se moverán
MusicFolderRequest = Quieres cambiar la ubicación de la carpeta de Música?
MusicFolderChange = Cambiar
MusicFolderSkip = Omitir
MusicSkipped = Omitido
# Pictures
PicturesDriveSelect = Selecciona la raíz del disco en la cual se creará la carpeta de Imágenes
PicturesFilesWontBeMoved = Los archivos no se moverán
PicturesFolderRequest = Quieres cambiar la ubicación de la carpeta de Imágenes?
PicturesFolderChange = Cambiar
PicturesFolderSkip = Omitir
PicturesSkipped = Omitido
# Videos
VideosDriveSelect = Selecciona la raíz del disco en la cual se creará la carpeta de Vídeos
VideosFilesWontBeMoved = Los archivos no se moverán
VideosFolderRequest = Quieres cambiar la ubicación de la carpeta de Vídeos?
VideosFolderChange = Cambiar
VideosFolderSkip = Omitir
VideosSkipped = Omitido

# SetDefaultUserShellFolderLocation
# Desktop
DesktopDefaultFolder = Quieres cambiar la ubicación de la carpeta de Escritorio por su ubicación por defecto?
# Documents
DocumentsDefaultFolder = Quieres cambiar la ubicación de la carpeta de Documentos por su ubicación por defecto?
# Downloads
DownloadsDefaultFolder = Quieres cambiar la ubicación de la carpeta de Descargas por su ubicación por defecto?
# Music
MusicDefaultFolder = Quieres cambiar la ubicación de la carpeta de Música por su ubicación por defecto?
# Pictures
PicturesDefaultFolder = Quieres cambiar la ubicación de la carpeta de Imágenes por su ubicación por defecto?
# Videos
VideosDefaultFolder = Quieres cambiar la ubicación de la carpeta de Vídeos por su ubicación por defecto?

# ReservedStorage
ReservedStorageIsInUse = Esta operación no está disponible cuando el almacenamiento reservado está en uso`nPorfavor, espere a que se complete alguna operación de servicio y inténtelo de nuevo más tarde

# syspin
syspinNoInternetConnection = No hay conexión a internet
syspinDownloading = Descargando syspin... ~20 KB

# PinControlPanel/PinDevicesPrinters/PinCommandPrompt
ControlPanelPinning = "Acceso directo $ControlPanelLocalizedName se está anclando al Inicio"
DevicesPrintersPinning = "Acceso directo $DevicesAndPrintersLocalizedName se está anclando al Inicio"
CMDPinning = Acceso directo CMD se está anclando al Inicio

# UninstallUWPApps
UninstallUWPForAll = Desinstalar para todos los usuarios
UninstallUWPTitle = Paquetes UWP a desinstalar
UninstallUWPUninstallButton = Desinstalar

# WSL
WSLUpdateDownloading = Descargando el paquete de actualización del kernel de Linux... ~14 MB
WSLUpdateInstalling = Instalando el paquete de actualización del kernel de Linux...

# SetAppGraphicsPerformance
GraphicsPerformanceTitle = Preferencia de rendimiento de gráficos
GraphicsPerformanceRequest = Quieres establecer el nivel de rendimiento de gráficos a "Alto rendimiento" en alguna aplicación?
GraphicsPerformanceAdd = Añadir
GraphicsPerformanceSkip = Omitir
GraphicsPerformanceFilter = *.exe|*.exe|Todos los Archivos (*.*)|*.*
GraphicsPerformanceSkipped = Omitido

# CreateCleanUpTask
CleanUpTaskToast = Limpiando archivos no usados y actualizaciones de windows comienza en un minuto
CleanUpTaskDescription = Limpiando archivos de windows no usados y actualizaciones usando la aplicación de limpieza de disco incorporada. Para descofificar el comando codificado usa [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("string"))

# CreateSoftwareDistributionTask
SoftwareDistributionTaskDescription = El %SystemRoot%\\SoftwareDistribution\\Download

# CreateTempTask
TempTaskDescription = Limpieza de la carpeta %TEMP%

# AddProtectedFolders
AddProtectedFoldersTitle = Acceso controlado a carpetas
AddProtectedFoldersRequest = Quieres añadir control de acceso a carpeta y especificar que carpeta Microsoft Defender protegerá de aplicaciones maliciosas y amenazas?
AddProtectedFoldersAdd = Añadir
AddProtectedFoldersSkip = Omitir
AddProtectedFoldersDescription = Selecciona una carpeta
AddProtectedFoldersSkipped = Omitido

# RemoveProtectedFolders
RemoveProtectedFoldersList = Carpetas eliminadas

# AddAppControlledFolder
AddAppControlledFolderTitle = Acceso controlado a carpetas
AddAppControlledFolderRequest = Quieres especificar una aplicación para que sea permitida a través del acceso controlado de carpetas?
AddAppControlledFolderAdd = Añadir
AddAppControlledFolderSkip = Omitir
AddAppControlledFolderFilter = *.exe|*.exe|Todos los Archivos (*.*)|*.*
AddAppControlledFolderSkipped = Omitido

# RemoveAllowedAppsControlledFolder
RemoveAllowedAppsControlledFolderList = Eliminar aplicaciones permitidas

# AddDefenderExclusionFolder
AddDefenderExclusionFolderTitle = Microsoft Defender
AddDefenderExclusionFolderRequest = Quieres especificar una carpeta para ser excluida por Microsoft Defender?
AddDefenderExclusionFolderAdd = Añadir
AddDefenderExclusionFolderSkip = Omitir
AddDefenderExclusionFolderDescription = Seleccione una carpeta
AddDefenderExclusionFolderSkipped = Omitido

# RemoveDefenderExclusionFolders
RemoveDefenderExclusionFoldersList = Carpetas excluidas eliminadas

# AddDefenderExclusionFile
AddDefenderExclusionFileTitle = Microsoft Defender
AddDefenderExclusionFileRequest = Quieres especificar un archivo para ser excluido por Microsoft Defender?
AddDefenderExclusionFileAdd = Añadir
AddDefenderExclusionFileSkip = Omitir
AddDefenderExclusionFileFilter = Todos los Archivos (*.*)|*.*
AddDefenderExclusionFileSkipped = Omitido

# RemoveDefenderExclusionFiles
RemoveDefenderExclusionFilesList = Archivos excluidos eliminados

# CreateEventViewerCustomView
EventViewerCustomViewName = Creación de procesos
EventViewerCustomViewDescription = Creación de procesos y eventos de auditoria de línea de comandos

# Refresh
RestartWarning = Reinicia tu PC

# Errors
ErrorsLine = Línea
ErrorsFile = Archivo
ErrorsMessage = Errores/Advertencias
'@
