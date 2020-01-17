# Remove Windows capabilities
# Удалить компоненты
$IncludedApps = @(
	# Microsoft Quick Assist
	# Быстрая поддержка (Майкрософт)
	"App.Support.QuickAssist*"
	# Windows Hello Face
	# Распознавание лиц Windows Hello
	"Hello.Face*"
	# Windows Media Player
	# Проигрыватель Windows Media
	"Media.WindowsMediaPlayer*"
	# Paint ###
	"Microsoft.Windows.MSPaint"
	# WordPad ###
	"Microsoft.Windows.WordPad"
)
$OFS = "|"
Get-WindowsCapability -Online | Where-Object -FilterScript {$_.Name -cmatch $IncludedApps} | Remove-WindowsCapability -Online
$OFS = " "