# Uninstall all UWP apps from all accounts, except the followings...
# Удалить все UWP-приложения из всех учетных записей, кроме следующих...
$ExcludedApps = @(
	# iTunes
	"AppleInc.iTunes"
	# Intel UWP-panel
	# UWP-панель Intel
	"AppUp.IntelGraphicsControlPanel"
	"AppUp.IntelGraphicsExperience"
	# Microsoft Desktop App Installer
	"Microsoft.DesktopAppInstaller"
	# Sticky Notes
	# Записки
	"Microsoft.MicrosoftStickyNotes"
	# Screen Sketch
	# Набросок на фрагменте экрана
	"Microsoft.ScreenSketch"
	# Microsoft Store
	"Microsoft.StorePurchaseApp"
	"Microsoft.WindowsStore"
	# Web Media Extensions
	# Расширения для интернет-мультимедиа
	"Microsoft.WebMediaExtensions"
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
Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object {$_.Name -cnotmatch $ExcludedApps} | Remove-AppxPackage -AllUsers
$OFS = " 