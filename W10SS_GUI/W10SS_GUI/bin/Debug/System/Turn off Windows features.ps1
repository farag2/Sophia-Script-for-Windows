# Turn off Windows features
# Отключить компоненты
$features = @(
	# Legacy Components
	# Компоненты прежних версий
	"LegacyComponents"
	# Media Features
	# Компоненты работы с мультимедиа
	"MediaPlayback"
	# PowerShell 2.0
	"MicrosoftWindowsPowerShellV2"
	"MicrosoftWindowsPowershellV2Root"
	# Microsoft XPS Document Writer
	# Средство записи XPS-документов (Microsoft)
	"Printing-XPSServices-Features"
	# Microsoft Print to PDF
	# Печать в PDF (Майкрософт)
	"Printing-PrintToPDFServices-Features"
	# Work Folders Client
	# Клиент рабочих папок
	"WorkFolders-Client"
)
Disable-WindowsOptionalFeature -Online -FeatureName $features -NoRestart