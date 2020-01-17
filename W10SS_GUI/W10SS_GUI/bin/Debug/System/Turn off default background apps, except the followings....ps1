# Turn off default background apps, except the followings...
# Запретить стандартным приложениям работать в фоновом режиме, кроме следующих...
$ExcludedApps = @(
	# Lock App
	"Microsoft.LockApp*"
	# Content Delivery Manager
	"Microsoft.Windows.ContentDeliveryManager*"
	# Cortana
	"Microsoft.Windows.Cortana*"
	# Windows Security
	# Безопасность Windows
	"Microsoft.Windows.SecHealthUI*"
	# ShellExperienceHost
	"Microsoft.Windows.ShellExperienceHost*"
	# StartMenuExperienceHost
	"Microsoft.Windows.StartMenuExperienceHost*"
)
$OFS = "|"
Get-ChildItem -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | Where-Object -FilterScript {$_.PSChildName -cnotmatch $ExcludedApps} |
ForEach-Object -Process {
	New-ItemProperty -Path $_.PsPath -Name Disabled -PropertyType DWord -Value 1 -Force
	New-ItemProperty -Path $_.PsPath -Name DisabledByUser -PropertyType DWord -Value 1 -Force
}
$OFS = " "