# Do not remove double quotes in double-quoted strings where they are present

ConvertFrom-StringData -StringData @'
UnsupportedOSBitness = Bu betik sadece Windows 10 x64 için geçerlidir
ControlledFolderAccessDisabled = Kontrollü klasör erişimi devre dışı bırakıldı

# OneDrive
OneDriveUninstalling = OneDrive kaldırılıyor...
OneDriveNotEmptyFolder = "$OneDriveUserFolder klasörü boş değil. `nKendiniz silin"
OneDriveFileSyncShell64dllBlocked = "$FileSyncShell64dll engellendi. `nKendiniz silin"
OneDriveInstalling = OneDriveSetup.exe başlatılıyor...
OneDriveDownloading = OneDrive indiriliyor... ~33 MB
NoInternetConnection = İnternet bağlantısı yok

# TempPath
LOCALAPPDATAFilesBlocked = "The following files are being blocked by third-party party apps `nRemove them manually and continue"
LOCALAPPDATANotEmpty = "$env:LOCALAPPDATA\\Temp klasörü boş değil. `nKendiniz temizleyip tekrar deneyin"

# DisableWindowsCapabilities
FODWindowTitle = İsteğe bağlı kaldırılabilecek özellikler (FODv2)
FODWindowButton = Kaldır
DialogBoxOpening = Diyalog penceresi gösteriliyor...
NoData = Gösterilecek bir şey yok

# WindowsSandbox
EnableHardwareVT = UEFI için Sanallaştırmayı etkinleştir

# ChangeUserShellFolderLocation
UserShellFolderNotEmpty = "$UserShellFolderRegValue klasöründe birkaç dosya kaldı. `nKendiniz yeni konuma taşıyın"
RetrievingDrivesList = Sürücü listesi alınıyor...
# Desktop
DesktopDriveSelect = Masaüstü klasörünün oluşturulacağı ana sürücüyü seçin
DesktopFilesWontBeMoved = Dosyalar taşınmayacak
DesktopFolderRequest = Masaüstü klasörünün konumunu değiştirmek ister misiniz?
DesktopFolderChange = Değiştir
DesktopFolderSkip = Atla
DesktopSkipped = Atlandı
# Documents
DocumentsDriveSelect = Dökümanlar klasörünün oluşturulacağı ana sürücüyü seçin
DocumentsFilesWontBeMoved = Dosyalar taşınmayacak
DocumentsFolderRequest = Dökümanlar klasörünün konumunu değiştirmek ister misiniz?
DocumentsFolderChange = Değiştir
DocumentsFolderSkip = Atla
DocumentsSkipped = Atlandı
# Downloads
DownloadsDriveSelect = İndirilenler klasörünün oluşturulacağı ana sürücüyü seçin
DownloadsFilesWontBeMoved = Dosyalar taşınmayacak
DownloadsFolderRequest = İndirilenler klasörünün konumunu değiştirmek ister misiniz?
DownloadsFolderChange = Değiştir
DownloadsFolderSkip = Atla
DownloadsSkipped = Atlandı
# Music
MusicDriveSelect = Müzikler klasörünün oluşturulacağı ana sürücüyü seçin
MusicFilesWontBeMoved = Dosyalar taşınmayacak
MusicFolderRequest = Müzikler klasörünün konumunu değiştirmek ister misiniz?
MusicFolderChange = Değiştir
MusicFolderSkip = Atla
MusicSkipped = Atlandı
# Pictures
PicturesDriveSelect = Resimler klasörünün oluşturulacağı ana sürücüyü seçin
PicturesFilesWontBeMoved = Dosyalar taşınmayacak
PicturesFolderRequest = Resimler klasörünün konumunu değiştirmek ister misiniz?
PicturesFolderChange = Değiştir
PicturesFolderSkip = Atla
PicturesSkipped = Atlandı
# Videos
VideosDriveSelect = Videolar klasörünün oluşturulacağı ana sürücüyü seçin
VideosFilesWontBeMoved = Dosyalar taşınmayacak
VideosFolderRequest = Videolar klasörünün konumunu değiştirmek ister misiniz?
VideosFolderChange = Değiştir
VideosFolderSkip = Atla
VideosSkipped = Atlandı

# SetDefaultUserShellFolderLocation
# Desktop
DesktopDefaultFolder = Masaüstü klasörünün konumunu varsayılan değerle değiştirmek ister misiniz?
# Documents
DocumentsDefaultFolder = Dökümanlar klasörünün konumunu varsayılan değerle değiştirmek ister misiniz?
# Downloads
DownloadsDefaultFolder = İndirilenler klasörünün konumunu varsayılan değerle değiştirmek ister misiniz?
# Music
MusicDefaultFolder = Müzikler klasörünün konumunu varsayılan değerle değiştirmek ister misiniz?
# Pictures
PicturesDefaultFolder = Resimler klasörünün konumunu varsayılan değerle değiştirmek ister misiniz?
# Videos
VideosDefaultFolder = Videolar klasörünün konumunu varsayılan değerle değiştirmek ister misiniz?

# ReservedStorage
ReservedStorageIsInUse = Ayrılmış Depolama özelliği kullanımdayken bu işlem desteklenmez `nLütfen servis işlemlerinin tamamlanmasını bekleyin ve daha sonra tekrar deneyin

# syspin
syspinNoInternetConnection = İnternet bağlantısı yok
syspinDownloading = Syspin indiriliyor... ~20 KB

# PinControlPanel/PinDevicesPrinters/PinCommandPrompt
ControlPanelPinning = "$ControlPanelLocalizedName kısayolu başlangıca sabitleniyor"
DevicesPrintersPinning = "$DevicesAndPrintersLocalizedName kısayolu başlangıca sabitleniyor"
CMDPinning = Komut İstemi kısayolu Başlat'a sabitleniyor

# UninstallUWPApps
UninstallUWPForAll = Tüm kullanıcılar için kaldır
UninstallUWPTitle = Kaldırılacak UWP Paketleri
UninstallUWPUninstallButton = Kaldır

# WSL
WSLUpdateDownloading = Linux Kernel yükseltme paketi indiriliyor... ~14 MB
WSLUpdateInstalling = Linux Kernel yükseltme paketi yükleniyor...

# SetAppGraphicsPerformance
GraphicsPerformanceTitle = Grafik performans tercihi
GraphicsPerformanceRequest = Seçtiğiniz bir uygulamanın grafik performansı ayarını "Yüksek performans" olarak belirlemek ister misiniz?
GraphicsPerformanceAdd = Ekle
GraphicsPerformanceSkip = Atla
GraphicsPerformanceFilter = *.exe|*.exe|Tüm Dosyalar (*.*)|*.*
GraphicsPerformanceSkipped = Atlandı

# CreateCleanUpTask
CleanUpTaskToast = Kullanılmayan Windows dosyalarının ve güncellemelerin temizlenmesi bir dakika içinde başlıyor
CleanUpTaskDescription = Kullanılmayan Windows dosyaları ve güncellemeleri yerleşik Disk Temizleme uygulaması kullanarak temizleniyor. Şifrelenmiş komutun şifrelemesini kaldırma için şu komutu kullanın [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("string"))

# CreateSoftwareDistributionTask
SoftwareDistributionTaskDescription = %SystemRoot%\\SoftwareDistribution\\Download

# CreateTempTask
TempTaskDescription = %TEMP% klasörü temizleniyor

# AddProtectedFolders
AddProtectedFoldersTitle = Kontrollü klasör erişimi
AddProtectedFoldersRequest = Kontrollü klasör erişimini etkinleştirmek ve Microsoft Defender'ın kötü amaçlı uygulamalardan ve tehditlerden koruyacağı klasörü belirtmek ister misiniz?
AddProtectedFoldersAdd = Ekle
AddProtectedFoldersSkip = Atla
AddProtectedFoldersDescription = Klasör seç
AddProtectedFoldersSkipped = Atlandı

# RemoveProtectedFolders
RemoveProtectedFoldersList = Kaldırılan klasörler

# AddAppControlledFolder
AddAppControlledFolderTitle = Kontrollü klasör erişimi
AddAppControlledFolderRequest = Kontrollü Klasör erişimine izin verilen bir uygulama belirtmek ister misiniz?
AddAppControlledFolderAdd = Ekle
AddAppControlledFolderSkip = Atla
AddAppControlledFolderFilter = *.exe|*.exe|Tüm Dosyalar (*.*)|*.*
AddAppControlledFolderSkipped = Atlandı

# RemoveAllowedAppsControlledFolder
RemoveAllowedAppsControlledFolderList = İzin verilen uygulamalar kaldırıldı

# AddDefenderExclusionFolder
AddDefenderExclusionFolderTitle = Microsoft Defender
AddDefenderExclusionFolderRequest = Microsoft Defender kötü amaçlı yazılım taramalarının dışında tutulacak bir klasör belirtmek ister misiniz?
AddDefenderExclusionFolderAdd = Ekle
AddDefenderExclusionFolderSkip = Atla
AddDefenderExclusionFolderDescription = Klasör seç
AddDefenderExclusionFolderSkipped = Atlandı

# RemoveDefenderExclusionFolders
RemoveDefenderExclusionFoldersList = Hariç tutulan klasörler kaldırıldı

# AddDefenderExclusionFile
AddDefenderExclusionFileTitle = Microsoft Defender
AddDefenderExclusionFileRequest = Microsoft Defender kötü amaçlı yazılım taramalarının dışında bırakılacak bir dosya belirtmek ister misiniz?
AddDefenderExclusionFileAdd = Ekle
AddDefenderExclusionFileSkip = Atla
AddDefenderExclusionFileFilter = Tüm Dosyalar (*.*)|*.*
AddDefenderExclusionFileSkipped = Atlandı

# RemoveDefenderExclusionFiles
RemoveDefenderExclusionFilesList = Hariç tutulan dosyalar kaldırıldı

# CreateEventViewerCustomView
EventViewerCustomViewName = Süreç Oluşturma
EventViewerCustomViewDescription = Süreç Oluşturma ve Komut Satırı Denetleme Olayları

# Refresh
RestartWarning = Bilgisayarını yeniden başlat

# Errors
ErrorsLine = Satır
ErrorsFile = Dosya
ErrorsMessage = Hatalar/Uyarılar
'@
