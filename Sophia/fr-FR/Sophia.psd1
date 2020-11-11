# Ne supprimez pas les guillemets doubles dans les chaînes entre guillemets lorsqu'ils sont présents

ConvertFrom-StringData -StringData @'
UnsupportedOSBitness = Le script ne fonctionne uniquement avec Windows 10 x64
ControlledFolderAccessDisabled = Accès contrôlé aux dossiers désactivé

# OneDrive
OneDriveUninstalling = Désinstaller OneDrive...
OneDriveNotEmptyFolder = "Le dossier $OneDriveUserFolder n'est pas vide le supprimer manuellement"
OneDriveFileSyncShell64dllBlocked = "$FileSyncShell64dll est bloqué le supprimer manuellement"
OneDriveInstalling = OneDriveSetup.exe est en cours de démarrage...
OneDriveDownloading = Téléchargement de OneDrive... ~33 MB
OneDriveNoInternetConnection = Pas de connexion Internet

# TempPath
LOCALAPPDATAFilesBlocked = "The following files are being blocked by third-party party apps `nRemove them manually and continue"
LOCALAPPDATANotEmpty = "Le dossier $env:LOCALAPPDATA\\Temp n'est pas vide le supprimer manuellement"

# DisableWindowsCapabilities
FODWindowTitle = Fonctionnalités optionnelles (FODv2) à supprimer
FODWindowButton = Désinstaller
DialogBoxOpening = Afficher la boite de dialogue...
NoData = Rien à afficher

# WindowsSandbox
EnableHardwareVT = Activer la Virtualisation dans UEFI

# ChangeUserShellFolderLocation
UserShellFolderNotEmpty = "Des fichiers sont situés dans $UserShellFolderRegValue les déplacer vers une nouvelle destination"
RetrievingDrivesList = Récupération de la liste des lecteurs...
# Desktop
DesktopDriveSelect = Sélectionnez le lecteur à la racine duquel le dossier Bureau sera créé
DesktopFilesWontBeMoved = Les fichiers ne seront pas déplacés
DesktopFolderRequest = Souhaitez vous changer l'emplacement du dossier Bureau?
DesktopFolderChange = Modifier
DesktopFolderSkip = Passer
DesktopSkipped = Passé
# Documents
DocumentsDriveSelect = Sélectionnez le lecteur à la racine duquel le dossier Documents sera créé
DocumentsFilesWontBeMoved = Les fichiers ne seront pas déplacés
DocumentsFolderRequest = Souhaitez vous changer l'emplacement du dossier Documents?
DocumentsFolderChange = Modifier
DocumentsFolderSkip = Passer
DocumentsSkipped = Passé
# Downloads
DownloadsDriveSelect = Sélectionnez le lecteur à la racine duquel le dossier Téléchargements sera créé
DownloadsFilesWontBeMoved = Les fichiers ne seront pas déplacés
DownloadsFolderRequest = Souhaitez vous changer l'emplacement du dossier Téléchargements?
DownloadsFolderChange = Modifier
DownloadsFolderSkip = Passer
DownloadsSkipped = Passé
# Music
MusicDriveSelect = Sélectionnez le lecteur à la racine duquel le dossier Musique sera créé
MusicFilesWontBeMoved = Les fichiers ne seront pas déplacés
MusicFolderRequest = Souhaitez vous changer l'emplacement du dossier Musique?
MusicFolderChange = Modifier
MusicFolderSkip = Passer
MusicSkipped = Passé
# Pictures
PicturesDriveSelect = Sélectionnez le lecteur à la racine duquel le dossier Images sera créé
PicturesFilesWontBeMoved = Les fichiers ne seront pas déplacés
PicturesFolderRequest = Souhaitez vous changer l'emplacement du dossier Images ?
PicturesFolderChange = Modifier
PicturesFolderSkip = Passer
PicturesSkipped = Passé
# Videos
VideosDriveSelect = Sélectionnez le lecteur à la racine duquel le dossier Vidéos sera créé
VideosFilesWontBeMoved = Les fichiers ne seront pas déplacés
VideosFolderRequest = Souhaitez vous changer l'emplacement du dossier Vidéos ?
VideosFolderChange = Modifier
VideosFolderSkip = Passer
VideosSkipped = Passé

# SetDefaultUserShellFolderLocation
# Desktop
DesktopDefaultFolder = Souhaitez-vous modifier l'emplacement du dossier Bureau par la valeur par défaut ?
# Documents
DocumentsDefaultFolder = Souhaitez-vous modifier l'emplacement du dossier Documents par la valeur par défaut ?
# Downloads
DownloadsDefaultFolder = Souhaitez-vous modifier l'emplacement du dossier Téléchargements par la valeur par défaut ?
# Music
MusicDefaultFolder = Souhaitez-vous modifier l'emplacement du dossier Musique par la valeur par défaut ?
# Pictures
PicturesDefaultFolder = Souhaitez-vous modifier l'emplacement du dossier Images par la valeur par défaut ?
# Videos
VideosDefaultFolder = Souhaitez-vous modifier l'emplacement du dossier Vidéos par la valeur par défaut ?

# ReservedStorage
ReservedStorageIsInUse = Cette opération n'est pas prise en charge lorsque le stockage réservé est utilisé veuillez attendre la fin des opérations de maintenance, puis réessayer plus tard

# syspin
syspinNoInternetConnection = Pas de connexion Internet
syspinDownloading = Téléchargement de syspin... ~20 KB

# PinControlPanel/PinDevicesPrinters/PinCommandPrompt
ControlPanelPinning = "Le raccourci $ControlPanelLocalizedName a été épinglé au menu de démarrage"
DevicesPrintersPinning = "Le raccourci $DevicesAndPrintersLocalizedName a été épinglé au menu de démarrage"
CMDPinning = Le raccourci Invites de commandes a été épinglé au menu de démarrage

# UninstallUWPApps
UninstallUWPForAll = Désinstaller pour tous les utilisateurs
UninstallUWPTitle = Paquetages UWP à désinstaller
UninstallUWPUninstallButton = Désinstaller

# WSL
WSLUpdateDownloading = Télécharger le paquetage de mise à jour du kernel Linux... ~14 MB
WSLUpdateInstalling = Installation du paquetage de mise à jour du kernel Linux...

# SetAppGraphicsPerformance
GraphicsPerformanceTitle = Préférence de performances graphiques
GraphicsPerformanceRequest = Souhaitez-vous définir le paramètre de performances graphiques d'une application de votre choix sur "Haute performance" ?
GraphicsPerformanceAdd = Ajouter
GraphicsPerformanceSkip = Passer
GraphicsPerformanceFilter = *.exe|*.exe|Tous les fichiers (*.*)|*.*
GraphicsPerformanceSkipped = Passer

# CreateCleanUpTask
CleanUpTaskToast = Le nettoyage des fichiers Windows inutilisés et des mises à jour commence dans une minute
CleanUpTaskDescription = Nettoyer les fichiers Windows inutilisés et les mises à jour à l'aide de l'application de nettoyage de disque intégrée. Pour décoder une commande codée, utilisez [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("string"))

# CreateSoftwareDistributionTask
SoftwareDistributionTaskDescription = Le %SystemRoot%\\SoftwareDistribution\\Download

# CreateTempTask
TempTaskDescription = Nettoyage du dossier %TEMP%

# AddProtectedFolders
AddProtectedFoldersTitle = Accès contrôlé aux dossiers
AddProtectedFoldersRequest = Souhaitez-vous activer l'accès contrôlé aux dossiers et spécifier le dossier que Microsoft Defender protégera contre les applications malveillantes et les menaces?
AddProtectedFoldersAdd = Ajouter
AddProtectedFoldersSkip = Passer
AddProtectedFoldersDescription = Sélectionner un dossier
AddProtectedFoldersSkipped = Passé

# RemoveProtectedFolders
RemoveProtectedFoldersList = Dossier supprimé

# AddAppControlledFolder
AddAppControlledFolderTitle = Accès contrôlé aux dossiers
AddAppControlledFolderRequest = Souhaitez-vous spécifier une application autorisée via l'accès contrôlé aux dossiers ?
AddAppControlledFolderAdd = Ajouter
AddAppControlledFolderSkip = Passer
AddAppControlledFolderFilter = *.exe|*.exe|Tous les fichiers (*.*)|*.*
AddAppControlledFolderSkipped = Passé

# RemoveAllowedAppsControlledFolder
RemoveAllowedAppsControlledFolderList = Applications approuvées supprimées

# AddDefenderExclusionFolder
AddDefenderExclusionFolderTitle = Microsoft Defender
AddDefenderExclusionFolderRequest = Souhaitez-vous spécifier un dossier à exclure des analyses de logiciels malveillants de Microsoft Defender?
AddDefenderExclusionFolderAdd = Ajouter
AddDefenderExclusionFolderSkip = Passer
AddDefenderExclusionFolderDescription = Séléctionner un dossier
AddDefenderExclusionFolderSkipped = Passé

# RemoveDefenderExclusionFolders
RemoveDefenderExclusionFoldersList = Fichiers exclus supprimés

# AddDefenderExclusionFile
AddDefenderExclusionFileTitle = Microsoft Defender
AddDefenderExclusionFileRequest = Souhaitez-vous spécifier un fichier à exclure des analyses de logiciels malveillants de Microsoft Defender ?
AddDefenderExclusionFileAdd = Ajouter
AddDefenderExclusionFileSkip = Passer
AddDefenderExclusionFileFilter = Tous les fichiers (*.*)|*.*
AddDefenderExclusionFileSkipped = Passé

# RemoveDefenderExclusionFiles
RemoveDefenderExclusionFilesList = Fichiers exclus supprimés

# CreateEventViewerCustomView
EventViewerCustomViewName = Création du processus
EventViewerCustomViewDescription = Création du processus et audit d'évènements en ligne de commande

# Refresh
RestartWarning = Redémarrer votre PC

# Erreurs
ErrorsLine = Ligne
ErrorsFile = Fichier
ErrorsMessage = Erreurs/Avertissements
'@
