# Uninstall all provisioned UWP apps from System account, except the followings...
# App packages will not be installed when new user accounts are created
# Удалить все UWP-приложения из системной учетной записи, кроме следующих...
# Приложения не будут установлены при создании новых учетных записей
$ExcludedApps = @(
	# Intel UWP-panel
	# UWP-панель Intel
	"AppUp.IntelGraphicsControlPanel"
	"AppUp.IntelGraphicsExperience"
	# Microsoft Desktop App Installer
	"Microsoft.DesktopAppInstaller"
	# HEIF Image Extensions
	# Расширения для изображений HEIF
	"Microsoft.HEIFImageExtension"
	# Sticky Notes
	# Записки
	"Microsoft.MicrosoftStickyNotes"
	# Screen Sketch
	# Набросок на фрагменте экрана
	"Microsoft.ScreenSketch"
	# Microsoft Store
	"Microsoft.StorePurchaseApp"
	"Microsoft.WindowsStore"
	# VCLibs
	"Microsoft.VCLibs*" ###
	# VP9 Video Extensions
	# Расширения для VP9-видео
	"Microsoft.VP9VideoExtensions"
	# Web Media Extensions
	# Расширения для интернет-мультимедиа
	"Microsoft.WebMediaExtensions"
	# WebP Image Extension
	# Расширения для изображений WebP
	"Microsoft.WebpImageExtension"
	# Notepad ###
	# Блокнот
	"Microsoft.WindowsNotepad"
	# Photos and Video Editor
	# Фотографии и Видеоредактор
	"Microsoft.Windows.Photos"
	# Calculator
	# Калькулятор
	"Microsoft.WindowsCalculator"
	# NVIDIA Control Panel
	# Панель управления NVidia
	"NVIDIACorp.NVIDIAControlPanel"
)
$OFS = "|"
Get-AppxProvisionedPackage -Online | Where-Object -FilterScript {$_.DisplayName -cnotmatch $ExcludedApps} | Remove-AppxProvisionedPackage -Online
$OFS = " "