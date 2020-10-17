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

# SetTempPath
LOCALAPPDATANotEmptyFolder = "$env:LOCALAPPDATA\\Temp klasörü boş değil. `nKendiniz temizleyip tekrar deneyin"

# WSL
WSLUpdateDownloading = Linux Kernel yükseltme paketi indiriliyor... ~14 MB
WSLUpdateInstalling = Linux Kernel yükseltme paketi yükleniyor...

# DisableWindowsCapabilities
FODWindowTitle = İsteğe bağlı kaldırılabilecek özellikler (FODv2)
FODWindowButton = Kaldır
DialogBoxOpening = Diyalog penceresi gösteriliyor...
NoData = Gösterilecek bir şey yok

# EnableWindowsSandbox/DisableWindowsSandbox
EnableHardwareVT = UEFI için Sanallaştırmayı etkinleştir

# ChangeUserShellFolderLocation
UserShellFolderNotEmpty = "$UserShellFolderRegValue klasöründe birkaç dosya kaldı. `nKendiniz yeni konuma taşıyın"
RetrievingDrivesList = Sürücü listesi alınıyor...
# Desktop
DesktopChangeFolderRequest = Masaüstü klasörünün konumunu değiştirmek ister misiniz?
DesktopFilesWontBeMoved = Dosyalar taşınmayacak
DesktopFolderChange = Değiştir
DesktopFolderSkip = Atla
DesktopDriveSelect = Masaüstü klasörünün oluşturulacağı ana sürücüyü seçin
DesktopSkipped = Atlandı
# Documents
DocumentsChangeFolderRequest = Dökümanlar klasörünün konumunu değiştirmek ister misiniz?
DocumentsFilesWontBeMoved = Dosyalar taşınmayacak
DocumentsFolderChange = Değiştir
DocumentsFolderSkip = Atla
DocumentsDriveSelect = Dökümanlar klasörünün oluşturulacağı ana sürücüyü seçin
DocumentsSkipped = Atlandı
# Downloads
DownloadsChangeFolderRequest = İndirilenler klasörünün konumunu değiştirmek ister misiniz?
DownloadsFilesWontBeMoved = Dosyalar taşınmayacak
DownloadsFolderChange = Değiştir
DownloadsFolderSkip = Atla
DownloadsDriveSelect = İndirilenler klasörünün oluşturulacağı ana sürücüyü seçin
DownloadsSkipped = Atlandı
# Music
MusicChangeFolderRequest = Müzikler klasörünün konumunu değiştirmek ister misiniz?
MusicFilesWontBeMoved = Dosyalar taşınmayacak
MusicFolderChange = Değiştir
MusicFolderSkip = Atla
MusicDriveSelect = Müzikler klasörünün oluşturulacağı ana sürücüyü seçin
MusicSkipped = Atlandı
# Pictures
PicturesChangeFolderRequest = Resimler klasörünün konumunu değiştirmek ister misiniz?
PicturesFilesWontBeMoved = Dosyalar taşınmayacak
PicturesFolderChange = Değiştir
PicturesFolderSkip = Atla
PicturesDriveSelect = Resimler klasörünün oluşturulacağı ana sürücüyü seçin
PicturesSkipped = Atlandı
# Videos
VideosChangeFolderRequest = Videolar klasörünün konumunu değiştirmek ister misiniz?
VideosFilesWontBeMoved = Dosyalar taşınmayacak
VideosFolderChange = Değiştir
VideosFolderSkip = Atla
VideosDriveSelect = Videolar klasörünün oluşturulacağı ana sürücüyü seçin
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

# DisableReservedStorage
ReservedStorageIsInUse = Ayrılmış Depolama özelliği kullanımdayken bu işlem desteklenmez `nLütfen servis işlemlerinin tamamlanmasını bekleyin ve daha sonra tekrar deneyin

# PinControlPanel/PinDevicesPrinters/PinCommandPrompt
syspinDownloading = Syspin indiriliyor... ~20 KB
ControlPanelPinning = "$ControlPanelLocalizedName kısayolu başlangıca sabitleniyor"
DevicesPrintersPinning = "$DevicesAndPrintersLocalizedName kısayolu başlangıca sabitleniyor"
CMDPinning = Komut İstemi kısayolu Başlat'a sabitleniyor

# UninstallUWPApps
UninstallUWPForAll = Tüm kullanıcılar için kaldır
UninstallUWPTitle = Kaldırılacak UWP Paketleri
UninstallUWPUninstallButton = Kaldır

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
