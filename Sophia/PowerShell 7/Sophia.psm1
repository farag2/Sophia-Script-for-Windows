<#
	.SYNOPSIS
	"Windows 10 Sophia Script" is a PowerShell module for Windows 10 fine-tuning and automating the routine tasks

	Version: v5.10.3
	Date: 27.04.2021

	Copyright (c) 2014–2021 farag
	Copyright (c) 2019–2021 farag & oZ-Zo

	Thanks to all https://forum.ru-board.com members involved

	.NOTES
	Running the script is best done on a fresh install because running it on wrong tweaked system may result in errors occurring

	.NOTES
	Supported Windows 10 versions
	Versions: 2004/20H2/21H1
	Builds: 19041/19042/19043
	Editions: Home/Pro/Enterprise
	Architecture: x64

	.NOTES
	Set execution policy to be able to run scripts only in the current PowerShell session:
		Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

	.NOTES
	https://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15
	https://habr.com/post/521202/
	https://forums.mydigitallife.net/threads/powershell-windows-10-sophia-script.81675/
	https://www.reddit.com/r/PowerShell/comments/go2n5v/powershell_script_setup_windows_10/

	.LINK Telegram channel & group
	https://t.me/sophianews
	https://t.me/sophia_chat

	.LINK
	https://github.com/farag2
	https://github.com/Inestic

	.LINK
	https://github.com/farag2/Windows-10-Sophia-Script
#>

#region Checkings
function Checkings
{
	Set-StrictMode -Version Latest

	# Сlear the $Error variable
	$Global:Error.Clear()

	# Detect the OS bitness
	switch ([System.Environment]::Is64BitOperatingSystem)
	{
		$false
		{
			Write-Warning -Message $Localization.UnsupportedOSBitness
			exit
		}
	}

	# Detect the OS build version
	switch ((Get-CimInstance -ClassName Win32_OperatingSystem).BuildNumber -ge 19041)
	{
		$false
		{
			Write-Warning -Message $Localization.UnsupportedOSBuild
			exit
		}
	}

	# Checking if the current module version is the latest one
	try
	{
		$LatestRelease = (Invoke-RestMethod -Uri "https://api.github.com/repos/farag2/Windows-10-Sophia-Script/releases").tag_name | Select-Object -First 1
		$CurrentRelease = (Get-Module -Name Sophia).Version.ToString()
		switch ([System.Version]$LatestRelease -gt [System.Version]$CurrentRelease)
		{
			$true
			{
				Write-Warning -Message $Localization.UnsupportedRelease

				Start-Sleep -Seconds 5

				Start-Process -FilePath "https://github.com/farag2/Windows-10-Sophia-Script/releases/latest"
				exit
			}
		}
	}
	catch [System.Net.WebException]
	{
		Write-Warning -Message $Localization.NoInternetConnection
		Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue
	}

	# Unblock all files in the folder by removing the Zone.Identifier alternate data stream with a value of "3"
	Get-ChildItem -Path $PSScriptRoot -Recurse -Force | Unblock-File

	# Import PowerShell 5.1 modules
	Import-Module -Name Microsoft.PowerShell.Management, PackageManagement, Appx -UseWindowsPowerShell

	# Turn off Controlled folder access to let the script proceed
	switch ((Get-MpPreference).EnableControlledFolderAccess)
	{
		"1"
		{
			Write-Warning -Message $Localization.ControlledFolderAccessDisabled

			$Script:ControlledFolderAccess = $true
			Set-MpPreference -EnableControlledFolderAccess Disabled

			# Open "Ransomware protection" page
			Start-Process -FilePath windowsdefender://RansomwareProtection
		}
		"0"
		{
			$Script:ControlledFolderAccess = $false
		}
	}
}
#endregion Checkings

#region Protection
# Enable script logging. The log will be being recorded into the script folder
# To stop logging just close the console or type "Stop-Transcript"
function Logging
{
	$TrascriptFilename = "Log-$((Get-Date).ToString("dd.MM.yyyy-HH-mm"))"
	Start-Transcript -Path $PSScriptRoot\$TrascriptFilename.txt -Force
}

# Create a restore point for the system drive
function CreateRestorePoint
{
	$SystemDriveUniqueID = (Get-Volume | Where-Object -FilterScript {$_.DriveLetter -eq "$($env:SystemDrive[0])"}).UniqueID
	$SystemProtection = ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SPP\Clients")."{09F7EDC5-294E-4180-AF6A-FB0E6A0E9513}") | Where-Object -FilterScript {$_ -match [regex]::Escape($SystemDriveUniqueID)}

	$ComputerRestorePoint = $false

	switch ($null -eq $SystemProtection)
	{
		$true
		{
			$ComputerRestorePoint = $true
			Enable-ComputerRestore -Drive $env:SystemDrive
		}
	}

	# Never skip creating a restore point
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name SystemRestorePointCreationFrequency -PropertyType DWord -Value 0 -Force

	Checkpoint-Computer -Description "Windows 10 Sophia Script" -RestorePointType MODIFY_SETTINGS

	# Revert the System Restore checkpoint creation frequency to 1440 minutes
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name SystemRestorePointCreationFrequency -PropertyType DWord -Value 1440 -Force

	# Turn off System Protection for the system drive if it was turned off before without deleting the existing restore points
	if ($ComputerRestorePoint)
	{
		Disable-ComputerRestore -Drive $env:SystemDrive
	}
}
#endregion Protection

#region Privacy & Telemetry
<#
	.SYNOPSIS
	Configure the DiagTrack service, and connection for the Unified Telemetry Client Outbound Traffic

	.PARAMETER Disable
	Disable the DiagTrack service, and block connection for the Unified Telemetry Client Outbound Traffic

	.PARAMETER Enable
	Enable the DiagTrack service, and allow connection for the Unified Telemetry Client Outbound Traffic

	.EXAMPLE
	DiagTrackService -Disable

	.EXAMPLE
	DiagTrackService -Enable

	.NOTES
	Current user
#>
function DiagTrackService
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			Get-Service -Name DiagTrack | Set-Service -StartupType Automatic
			Get-Service -Name DiagTrack | Start-Service

			# Allow connection for the Unified Telemetry Client Outbound Traffic
			Get-NetFirewallRule -Group DiagTrack | Set-NetFirewallRule -Enabled True -Action Allow
		}
		"Disable"
		{
			Get-Service -Name DiagTrack | Stop-Service -Force
			Get-Service -Name DiagTrack | Set-Service -StartupType Disabled

			# Block connection for the Unified Telemetry Client Outbound Traffic
			Get-NetFirewallRule -Group DiagTrack | Set-NetFirewallRule -Enabled False -Action Block
		}
	}
}

<#
	.SYNOPSIS
	Configure the OS level of diagnostic data gathering

	.PARAMETER Minimal
	Set the OS level of diagnostic data gathering to minimum

	.PARAMETER Default
	Set the OS level of diagnostic data gathering to default

	.EXAMPLE
	DiagnosticDataLevel -Minimal

	.EXAMPLE
	DiagnosticDataLevel -Default

	.NOTES
	Machine-wide
#>
function DiagnosticDataLevel
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Minimal"
		)]
		[switch]
		$Minimal,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Default"
		)]
		[switch]
		$Default
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Minimal"
		{
			if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -like "Enterprise*" -or $_.Edition -eq "Education"})
			{
				# Security level
				New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 0 -Force
			}
			else
			{
				# Required diagnostic data
				New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 1 -Force
			}
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name MaxTelemetryAllowed -PropertyType DWord -Value 1 -Force

			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack -Name ShowedToastAtLevel -PropertyType DWord -Value 1 -Force
		}
		"Default"
		{
			# Optional diagnostic data
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 3 -Force
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name MaxTelemetryAllowed -PropertyType DWord -Value 3 -Force

			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack -Name ShowedToastAtLevel -PropertyType DWord -Value 3 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the Windows Error Reporting

	.PARAMETER Disable
	Turn off Windows Error Reporting

	.PARAMETER Enable
	Turn on Windows Error Reporting

	.EXAMPLE
	ErrorReporting -Disable

	.EXAMPLE
	ErrorReporting -Enable

	.NOTES
	Current user
#>
function ErrorReporting
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			if ((Get-WindowsEdition -Online).Edition -notmatch "Core")
			{
				Get-ScheduledTask -TaskName QueueReporting | Disable-ScheduledTask
				New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name Disabled -PropertyType DWord -Value 1 -Force
			}

			Get-Service -Name WerSvc | Stop-Service -Force
			Get-Service -Name WerSvc | Set-Service -StartupType Disabled
		}
		"Enable"
		{
			Get-ScheduledTask -TaskName QueueReporting | Enable-ScheduledTask
			Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name Disabled -Force -ErrorAction SilentlyContinue

			Get-Service -Name WerSvc | Set-Service -StartupType Manual
			Get-Service -Name WerSvc | Start-Service
		}
	}
}

<#
	.SYNOPSIS
	Configure the Windows feedback frequency

	.PARAMETER Disable
	Change Windows feedback frequency to "Never"

	.PARAMETER Enable
	Change Windows feedback frequency to "Automatically"

	.EXAMPLE
	WindowsFeedback -Disable

	.EXAMPLE
	WindowsFeedback -Enable

	.NOTES
	Current user
#>
function WindowsFeedback
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Siuf\Rules))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Siuf\Rules -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Siuf\Rules -Name NumberOfSIUFInPeriod -PropertyType DWord -Value 0 -Force
		}
		"Enable"
		{
			Remove-Item -Path HKCU:\SOFTWARE\Microsoft\Siuf\Rules -Force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.SYNOPSIS
	Configure the diagnostics tracking scheduled tasks

	.PARAMETER Disable
	Turn off the diagnostics tracking scheduled tasks

	.PARAMETER Enable
	Turn on the diagnostics tracking scheduled tasks

	.EXAMPLE
	ScheduledTasks -Disable

	.EXAMPLE
	ScheduledTasks -Enable

	.NOTES
	A pop-up dialog box enables the user to select tasks
	Current user
#>
function ScheduledTasks
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	Add-Type -AssemblyName PresentationCore, PresentationFramework

	#region Variables
	# Initialize an array list to store the selected scheduled tasks
	$SelectedTasks = New-Object -TypeName System.Collections.ArrayList($null)

	# The following tasks will have their checkboxes checked
	[string[]]$CheckedScheduledTasks = @(
		# Collects program telemetry information if opted-in to the Microsoft Customer Experience Improvement Program
		# Сбор телеметрических данных программы при участии в программе улучшения качества ПО
		"ProgramDataUpdater",

		# This task collects and uploads autochk SQM data if opted-in to the Microsoft Customer Experience Improvement Program
		# Эта задача собирает и загружает данные SQM при участии в программе улучшения качества программного обеспечения
		"Proxy",

		# If the user has consented to participate in the Windows Customer Experience Improvement Program, this job collects and sends usage data to Microsoft
		# Если пользователь изъявил желание участвовать в программе по улучшению качества программного обеспечения Windows, эта задача будет собирать и отправлять сведения о работе программного обеспечения в Майкрософт
		"Consolidator",

		# The USB CEIP (Customer Experience Improvement Program) task collects Universal Serial Bus related statistics and information about your machine and sends it to the Windows Device Connectivity engineering group at Microsoft
		# При выполнении задачи программы улучшения качества ПО шины USB (USB CEIP) осуществляется сбор статистических данных об использовании универсальной последовательной шины USB и с ведений о компьютере, которые направляются инженерной группе Майкрософт по вопросам подключения устройств в Windows
		"UsbCeip",

		# The Windows Disk Diagnostic reports general disk and system information to Microsoft for users participating in the Customer Experience Program
		# Для пользователей, участвующих в программе контроля качества программного обеспечения, служба диагностики дисков Windows предоставляет общие сведения о дисках и системе в корпорацию Майкрософт
		"Microsoft-Windows-DiskDiagnosticDataCollector",

		# This task shows various Map related toasts
		# Эта задача показывает различные тосты (всплывающие уведомления) приложения "Карты"
		"MapsToastTask",

		# This task checks for updates to maps which you have downloaded for offline use
		# Эта задача проверяет наличие обновлений для карт, загруженных для автономного использования
		"MapsUpdateTask",

		# Initializes Family Safety monitoring and enforcement
		# Инициализация контроля и применения правил семейной безопасности
		"FamilySafetyMonitor",

		# Synchronizes the latest settings with the Microsoft family features service
		# Синхронизирует последние параметры со службой функций семьи учетных записей Майкрософт
		"FamilySafetyRefreshTask",

		# XblGameSave Standby Task
		"XblGameSaveTask"
	)

	# Check if device has a camera
	$DeviceHasCamera = Get-CimInstance -ClassName Win32_PnPEntity | Where-Object -FilterScript {($_.PNPClass -eq "Camera") -or ($_.PNPClass -eq "Image")}
	if (-not $DeviceHasCamera)
	{
		# Windows Hello
		$CheckedScheduledTasks += "FODCleanupTask"
	}
	#endregion Variables

	#region XAML Markup
	# The section defines the design of the upcoming dialog box
	[xml]$XAML = '
	<Window
		xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Name="Window"
		MinHeight="450" MinWidth="400"
		SizeToContent="Width" WindowStartupLocation="CenterScreen"
		TextOptions.TextFormattingMode="Display" SnapsToDevicePixels="True"
		FontFamily="Segoe UI" FontSize="12" ShowInTaskbar="False">
		<Window.Resources>
			<Style TargetType="StackPanel">
				<Setter Property="Orientation" Value="Horizontal"/>
			</Style>
			<Style TargetType="CheckBox">
				<Setter Property="Margin" Value="10, 10, 5, 10"/>
				<Setter Property="IsChecked" Value="True"/>
			</Style>
			<Style TargetType="TextBlock">
				<Setter Property="Margin" Value="5, 10, 10, 10"/>
			</Style>
			<Style TargetType="Button">
				<Setter Property="Margin" Value="20"/>
				<Setter Property="Padding" Value="10"/>
			</Style>
		</Window.Resources>
		<Grid>
			<Grid.RowDefinitions>
				<RowDefinition Height="*"/>
				<RowDefinition Height="Auto"/>
			</Grid.RowDefinitions>
			<ScrollViewer Name="Scroll" Grid.Row="0"
				HorizontalScrollBarVisibility="Disabled"
				VerticalScrollBarVisibility="Auto">
				<StackPanel Name="PanelContainer" Orientation="Vertical"/>
			</ScrollViewer>
			<Button Name="Button" Grid.Row="1"/>
		</Grid>
	</Window>
	'
	#endregion XAML Markup

	$Reader = (New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $XAML)
	$Form = [Windows.Markup.XamlReader]::Load($Reader)
	$XAML.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object -Process {
		Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)
	}

	#region Functions
	function Get-CheckboxClicked
	{
		[CmdletBinding()]
		param
		(
			[Parameter(
				Mandatory = $true,
				ValueFromPipeline = $true
			)]
			[ValidateNotNull()]
			$CheckBox
		)

		$Task = $Tasks | Where-Object -FilterScript {$_.TaskName -eq $CheckBox.Parent.Children[1].Text}

		if ($CheckBox.IsChecked)
		{
			[void]$SelectedTasks.Add($Task)
		}
		else
		{
			[void]$SelectedTasks.Remove($Task)
		}

		if ($SelectedTasks.Count -gt 0)
		{
			$Button.IsEnabled = $true
		}
		else
		{
			$Button.IsEnabled = $false
		}
	}

	function DisableButton
	{
		Write-Verbose -Message $Localization.Patient -Verbose

		[void]$Window.Close()

		$SelectedTasks | ForEach-Object -Process {Write-Verbose $_.TaskName -Verbose}
		$SelectedTasks | Disable-ScheduledTask
	}

	function EnableButton
	{
		Write-Verbose -Message $Localization.Patient -Verbose

		[void]$Window.Close()

		$SelectedTasks | ForEach-Object -Process {Write-Verbose $_.TaskName -Verbose}
		$SelectedTasks | Enable-ScheduledTask
	}

	function Add-TaskControl
	{
		[CmdletBinding()]
		param
		(
			[Parameter(
				Mandatory = $true,
				ValueFromPipeline = $true
			)]
			[ValidateNotNull()]
			$Task
		)

		process
		{
			$CheckBox = New-Object -TypeName System.Windows.Controls.CheckBox
			$CheckBox.Add_Click({Get-CheckboxClicked -CheckBox $_.Source})

			$TextBlock = New-Object -TypeName System.Windows.Controls.TextBlock
			$TextBlock.Text = $Task.TaskName

			$StackPanel = New-Object -TypeName System.Windows.Controls.StackPanel
			[void]$StackPanel.Children.Add($CheckBox)
			[void]$StackPanel.Children.Add($TextBlock)
			[void]$PanelContainer.Children.Add($StackPanel)

			# If task checked add to the array list
			if ($CheckedScheduledTasks | Where-Object -FilterScript {$Task.TaskName -match $_})
			{
				[void]$SelectedTasks.Add($Task)
			}
			else
			{
				$CheckBox.IsChecked = $false
			}
		}
	}
	#endregion Functions

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{

			$State = "Disabled"
			$ButtonContent = $Localization.Enable
			$ButtonAdd_Click = {EnableButton}
		}
		"Disable"
		{
			$State = "Ready"
			$ButtonContent = $Localization.Disable
			$ButtonAdd_Click = {DisableButton}
		}
	}

	Write-Verbose -Message $Localization.Patient -Verbose

	# Getting list of all scheduled tasks according to the conditions
	$Tasks = Get-ScheduledTask | Where-Object -FilterScript {($_.State -eq $State) -and ($_.TaskName -in $CheckedScheduledTasks)}

	if (-not ($Tasks))
	{
		Write-Verbose -Message $Localization.NoData -Verbose
		return
	}

	Write-Verbose -Message $Localization.DialogBoxOpening -Verbose

	$Window.Add_Loaded({$Tasks | Add-TaskControl})
	$Button.Content = $ButtonContent
	$Button.Add_Click({& $ButtonAdd_Click})

	$Window.Title = $Localization.ScheduledTasks
	$Form.ShowDialog() | Out-Null
}

<#
	.SYNOPSIS
	Configure the sign-in info to automatically finish setting up device and reopen apps after an update or restart

	.PARAMETER Disable
	Do not use sign-in info to automatically finish setting up device and reopen apps after an update or restart

	.PARAMETER Enable
	Use sign-in info to automatically finish setting up device and reopen apps after an update or restart

	.EXAMPLE
	SigninInfo -Disable

	.EXAMPLE
	SigninInfo -Enable

	.NOTES
	Current user
#>
function SigninInfo
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			$SID = (Get-CimInstance -ClassName Win32_UserAccount | Where-Object -FilterScript {$_.Name -eq $env:USERNAME}).SID
			if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$SID"))
			{
				New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$SID" -Force
			}
			New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$SID" -Name OptOut -PropertyType DWord -Value 1 -Force
		}
		"Enable"
		{
			$SID = (Get-CimInstance -ClassName Win32_UserAccount | Where-Object -FilterScript {$_.Name -eq $env:USERNAME}).SID
			Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$SID" -Name OptOut -Force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.SYNOPSIS
	Configure the provision to websites of locally relevant content by accessing language list

	.PARAMETER Disable
	Do not let websites provide locally relevant content by accessing language list

	.PARAMETER Enable
	Let websites provide locally relevant content by accessing language list

	.EXAMPLE
	LanguageListAccess -Disable

	.EXAMPLE
	LanguageListAccess -Enable

	.NOTES
	Current user
#>
function LanguageListAccess
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			New-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name HttpAcceptLanguageOptOut -PropertyType DWord -Value 1 -Force
		}
		"Enable"
		{
			Remove-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name HttpAcceptLanguageOptOut -Force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.SYNOPSIS
	Configure the permission for apps to use advertising ID

	.PARAMETER Disable
	Do not allow apps to use advertising ID

	.PARAMETER Enable
	Do not allow apps to use advertising ID

	.EXAMPLE
	AdvertisingID -Disable

	.EXAMPLE
	AdvertisingID -Enable

	.NOTES
	Current user
#>
function AdvertisingID
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -PropertyType DWord -Value 0 -Force
		}
		"Enable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the permission for apps on other devices open and message apps on this device, and vice versa

	.PARAMETER Disable
	Do not let apps on other devices open and message apps on this device, and vice versa

	.PARAMETER Enable
	Let apps on other devices open and message apps on this device, and vice versa

	.EXAMPLE
	ShareAcrossDevices -Disable

	.EXAMPLE
	ShareAcrossDevices -Enable

	.NOTES
	Current user
#>
function ShareAcrossDevices
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP -Name RomeSdkChannelUserAuthzPolicy -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP -Name RomeSdkChannelUserAuthzPolicy -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the Windows welcome experiences after updates and occasionally when I sign in to highlight what's new and suggested

	.PARAMETER Hide
	Hide the Windows welcome experiences after updates and occasionally when I sign in to highlight what's new and suggested

	.PARAMETER Show
	Show the Windows welcome experiences after updates and occasionally when I sign in to highlight what's new and suggested

	.EXAMPLE
	WindowsWelcomeExperience -Hide

	.EXAMPLE
	WindowsWelcomeExperience -Show

	.NOTES
	Current user
#>
function WindowsWelcomeExperience
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Show"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-310093Enabled -PropertyType DWord -Value 1 -Force
		}
		"Hide"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-310093Enabled -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure getting tip, trick, and suggestions as you use Windows

	.PARAMETER Disable
	Do not get tip, trick, and suggestions as you use Windows

	.PARAMETER Enable
	Get tip, trick, and suggestions as you use Windows

	.EXAMPLE
	WindowsTips -Disable

	.EXAMPLE
	WindowsTips -Enable

	.NOTES
	Current user
#>
function WindowsTips
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338389Enabled -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338389Enabled -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure suggested content in the Settings app

	.PARAMETER Hide
	Hide suggested content in the Settings app

	.PARAMETER Show
	Show suggested content in the Settings app

	.EXAMPLE
	SettingsSuggestedContent -Hide

	.EXAMPLE
	SettingsSuggestedContent -Show

	.NOTES
	Current user
#>
function SettingsSuggestedContent
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Show"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338393Enabled -PropertyType DWord -Value 1 -Force
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-353694Enabled -PropertyType DWord -Value 1 -Force
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-353696Enabled -PropertyType DWord -Value 1 -Force
		}
		"Hide"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338393Enabled -PropertyType DWord -Value 0 -Force
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-353694Enabled -PropertyType DWord -Value 0 -Force
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-353696Enabled -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure automatic installing suggested apps

	.PARAMETER Disable
	Turn off automatic installing suggested apps

	.PARAMETER Enable
	Turn on automatic installing suggested apps

	.EXAMPLE
	AppsSilentInstalling -Disable

	.EXAMPLE
	AppsSilentInstalling -Enable

	.NOTES
	Current user
#>
function AppsSilentInstalling
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SilentInstalledAppsEnabled -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SilentInstalledAppsEnabled -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure ways I can finish setting up my device to get the most out of Windows

	.PARAMETER Disable
	Do not suggest ways I can finish setting up my device to get the most out of Windows

	.PARAMETER Enable
	Suggest ways I can finish setting up my device to get the most out of Windows

	.EXAMPLE
	WhatsNewInWindows -Disable

	.EXAMPLE
	WhatsNewInWindows -Enable

	.NOTES
	Current user
#>
function WhatsNewInWindows
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Name ScoobeSystemSettingEnabled -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Name ScoobeSystemSettingEnabled -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure tailored experiences based on the diagnostic data setting

	.PARAMETER Disable
	Do not offer tailored experiences based on the diagnostic data setting

	.PARAMETER Enable
	Offer tailored experiences based on the diagnostic data setting

	.EXAMPLE
	TailoredExperiences -Disable

	.EXAMPLE
	TailoredExperiences -Enable

	.NOTES
	Current user
#>
function TailoredExperiences
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy -Name TailoredExperiencesWithDiagnosticDataEnabled -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy -Name TailoredExperiencesWithDiagnosticDataEnabled -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure Bing search in the Start Menu (for the USA only)

	.PARAMETER Disable
	Disable Bing search in the Start Menu (for the USA only)

	.PARAMETER Enable
	Enable Bing search in the Start Menu (for the USA only)

	.EXAMPLE
	BingSearch -Disable

	.EXAMPLE
	BingSearch -Enable

	.NOTES
	Current user
#>
function BingSearch
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			if ((Get-WinHomeLocation).GeoId -eq 244)
			{
				Remove-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name DisableSearchBoxSuggestions -Force -ErrorAction SilentlyContinue
			}
		}
		"Disable"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer))
			{
				New-Item -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name DisableSearchBoxSuggestions -PropertyType DWord -Value 1 -Force
		}
	}
}
#endregion Privacy & Telemetry

#region UI & Personalization
<#
	.SYNOPSIS
	Configure the "This PC" icon on Desktop

	.PARAMETER Hide
	Show the "This PC" icon on Desktop

	.PARAMETER Show
	Hide the "This PC" icon on Desktop

	.EXAMPLE
	ThisPC -Hide

	.EXAMPLE
	ThisPC -Show

	.NOTES
	Current user
#>
function ThisPC
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Show"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -PropertyType DWord -Value 0 -Force
		}
		"Hide"
		{
			Remove-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.SYNOPSIS
	Configure check boxes to select items

	.PARAMETER Disable
	Do not use check boxes to select items

	.PARAMETER Enable
	Use check boxes to select items

	.EXAMPLE
	CheckBoxes -Disable

	.EXAMPLE
	CheckBoxes -Enable

	.NOTES
	Current user
#>
function CheckBoxes
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name AutoCheckSelect -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name AutoCheckSelect -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the display of hidden files, folders, and drives

	.PARAMETER Enable
	Show hidden files, folders, and drives

	.PARAMETER Disable
	Do not show hidden files, folders, and drives

	.EXAMPLE
	HiddenItems -Enable

	.EXAMPLE
	HiddenItems -Disable

	.NOTES
	Current user
#>
function HiddenItems
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -PropertyType DWord -Value 2 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the display of file name extensions

	.PARAMETER Show
	Show file name extensions

	.PARAMETER Hide
	Hide file name extensions

	.EXAMPLE
	FileExtensions -Show

	.EXAMPLE
	FileExtensions -Hide

	.NOTES
	Current user
#>
function FileExtensions
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Show"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -PropertyType DWord -Value 0 -Force
		}
		"Hide"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure folder merge conflicts

	.PARAMETER Show
	Show folder merge conflicts

	.PARAMETER Hide
	Hide folder merge conflicts

	.EXAMPLE
	MergeConflicts -Show

	.EXAMPLE
	MergeConflicts -Hide

	.NOTES
	Current user
#>
function MergeConflicts
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Show"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideMergeConflicts -PropertyType DWord -Value 1 -Force
		}
		"Hide"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideMergeConflicts -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure how to open File Explorer

	.PARAMETER ThisPC
	Open File Explorer to "This PC"

	.PARAMETER QuickAccess
	Open File Explorer to Quick access

	.EXAMPLE
	OpenFileExplorerTo -ThisPC

	.EXAMPLE
	OpenFileExplorerTo -QuickAccess

	.NOTES
	Current user
#>
function OpenFileExplorerTo
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "ThisPC"
		)]
		[switch]
		$ThisPC,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "QuickAccess"
		)]
		[switch]
		$QuickAccess
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"ThisPC"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -PropertyType DWord -Value 1 -Force
		}
		"QuickAccess"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -PropertyType DWord -Value 2 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure Cortana button on the taskbar

	.PARAMETER Hide
	Show Cortana button on the taskbar

	.PARAMETER Show
	Hide Cortana button on the taskbar

	.EXAMPLE
	CortanaButton -Hide

	.EXAMPLE
	CortanaButton -Show

	.NOTES
	Current user
#>
function CortanaButton
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCortanaButton -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowCortanaButton -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure sync provider notification within File Explorer

	.PARAMETER Hide
	Do not show sync provider notification within File Explorer

	.PARAMETER Show
	Show sync provider notification within File Explorer

	.EXAMPLE
	OneDriveFileExplorerAd -Hide

	.EXAMPLE
	OneDriveFileExplorerAd -Show

	.NOTES
	Current user
#>
function OneDriveFileExplorerAd
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSyncProviderNotifications -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSyncProviderNotifications -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure Task View button on the taskbar

	.PARAMETER Hide
	Show Task View button on the taskbar

	.PARAMETER Show
	Do not show Task View button on the taskbar

	.EXAMPLE
	TaskViewButton -Hide

	.EXAMPLE
	TaskViewButton -Show

	.NOTES
	Current user
#>
function TaskViewButton
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure People button on the taskbar

	.PARAMETER Hide
	Hide People button on the taskbar

	.PARAMETER Show
	Show People button on the taskbar

	.EXAMPLE
	PeopleTaskbar -Hide

	.EXAMPLE
	PeopleTaskbar -Show

	.NOTES
	Current user
#>
function PeopleTaskbar
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Name PeopleBand -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Name PeopleBand -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure seconds on the taskbar clock

	.PARAMETER Hide
	Hide seconds on the taskbar clock

	.PARAMETER Show
	Show seconds on the taskbar clock

	.EXAMPLE
	SecondsInSystemClock -Hide

	.EXAMPLE
	SecondsInSystemClock -Show

	.NOTES
	Current user
#>
function SecondsInSystemClock
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSecondsInSystemClock -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSecondsInSystemClock -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure windows snapping

	.PARAMETER Disable
	When I snap a window, do not show what I can snap next to it

	.PARAMETER Enable
	When I snap a window, show what I can snap next to it

	.EXAMPLE
	SnapAssist -Disable

	.EXAMPLE
	SnapAssist -Enable

	.NOTES
	Current user
#>
function SnapAssist
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SnapAssist -PropertyType DWord -Value 0 -Force
		}
		"Enable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SnapAssist -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the file transfer dialog box mode

	.PARAMETER Detailed
	Show the file transfer dialog box in the detailed mode

	.PARAMETER Compact
	Show the file transfer dialog box in the compact mode

	.EXAMPLE
	FileTransferDialog -Detailed

	.EXAMPLE
	FileTransferDialog -Compact

	.NOTES
	Current user
#>
function FileTransferDialog
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Detailed"
		)]
		[switch]
		$Detailed,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Compact"
		)]
		[switch]
		$Compact
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Detailed"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Name EnthusiastMode -PropertyType DWord -Value 1 -Force
		}
		"Compact"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Name EnthusiastMode -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the File Explorer ribbon

	.PARAMETER Expanded
	Expand the File Explorer ribbon

	.PARAMETER Minimized
	Minimize the File Explorer ribbon

	.EXAMPLE
	FileExplorerRibbon -Expanded

	.EXAMPLE
	FileExplorerRibbon -Minimized

	.NOTES
	Current user
#>
function FileExplorerRibbon
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Expanded"
		)]
		[switch]
		$Expanded,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Minimized"
		)]
		[switch]
		$Minimized
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Expanded"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Name MinimizedStateTabletModeOff -PropertyType DWord -Value 0 -Force
		}
		"Minimized"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Name MinimizedStateTabletModeOff -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the recycle bin files delete confirmation dialog

	.PARAMETER Disable
	Display/do not display the recycle bin files delete confirmation dialog

	.PARAMETER Enable
	Display/do not display the recycle bin files delete confirmation dialog

	.EXAMPLE
	RecycleBinDeleteConfirmation -Disable

	.EXAMPLE
	RecycleBinDeleteConfirmation -Enable

	.NOTES
	Current user
#>
function RecycleBinDeleteConfirmation
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	$UpdateDesktop = @{
		Namespace = "WinAPI"
		Name = "UpdateDesktop"
		Language = "CSharp"
		MemberDefinition = @"
private static readonly IntPtr hWnd = new IntPtr(65535);
private const int Msg = 273;
// Virtual key ID of the F5 in File Explorer
private static readonly UIntPtr UIntPtr = new UIntPtr(41504);

[DllImport("user32.dll", SetLastError=true)]
public static extern int PostMessageW(IntPtr hWnd, uint Msg, UIntPtr wParam, IntPtr lParam);
public static void PostMessage()
{
	// F5 pressing simulation to refresh the desktop
	PostMessageW(hWnd, Msg, UIntPtr, IntPtr.Zero);
}
"@
	}
	if (-not ("WinAPI.UpdateDesktop" -as [type]))
	{
		Add-Type @UpdateDesktop
	}

	$ShellState = Get-ItemPropertyValue -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShellState

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			$ShellState[4] = 55
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShellState -PropertyType Binary -Value $ShellState -Force
		}
		"Enable"
		{
			$ShellState[4] = 51
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShellState -PropertyType Binary -Value $ShellState -Force
		}
	}

	# Send F5 pressing simulation to refresh the desktop
	[WinAPI.UpdateDesktop]::PostMessage()
}

<#
	.SYNOPSIS
	Configure the "3D Objects" folder in "This PC" and Quick access

	.PARAMETER Show
	Show the "3D Objects" folder in "This PC" and Quick access

	.PARAMETER Hide
	Hide the "3D Objects" folder in "This PC" and Quick access

	.EXAMPLE
	3DObjects -Show

	.EXAMPLE
	3DObjects -Hide

	.NOTES
	Current user
#>
function 3DObjects
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"))
			{
				New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Force
			}
			New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name ThisPCPolicy -PropertyType String -Value Hide -Force
		}
		"Show"
		{
			Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name ThisPCPolicy -Force -ErrorAction SilentlyContinue
		}
	}

	# Save all opened folders in order to restore them after File Explorer restart
	Clear-Variable -Name OpenedFolders -Force -ErrorAction Ignore
	$OpenedFolders = {(New-Object -ComObject Shell.Application).Windows() | ForEach-Object -Process {$_.Document.Folder.Self.Path}}.Invoke()

	# In order for the changes to take effect the File Explorer process has to be restarted
	Stop-Process -Name explorer -Force

	Start-Sleep -Seconds 3

	# Restoring closed folders
	foreach ($OpenedFolder in $OpenedFolders)
	{
		if (Test-Path -Path $OpenedFolder)
		{
			Invoke-Item -Path $OpenedFolder
		}
	}
}

<#
	.SYNOPSIS
	Configure frequently used folders in Quick access

	.PARAMETER Show
	Show frequently used folders in Quick access

	.PARAMETER Hide
	Hide frequently used folders in Quick access

	.EXAMPLE
	QuickAccessFrequentFolders -Show

	.EXAMPLE
	QuickAccessFrequentFolders -Hide

	.NOTES
	Current user
#>
function QuickAccessFrequentFolders
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure recently used files in Quick access

	.PARAMETER Show
	Show recently used files in Quick access

	.PARAMETER Hide
	Hide recently used files in Quick access

	.EXAMPLE
	QuickAccessRecentFiles -Show

	.EXAMPLE
	QuickAccessRecentFiles -Hide

	.NOTES
	Current user
#>
function QuickAccessRecentFiles
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure search on the taskbar

	.PARAMETER SearchBox
	Show the search box on the taskbar

	.PARAMETER SearchIcon
	Show the search icon on the taskbar

	.PARAMETER Hide
	Hide the search on the taskbar

	.EXAMPLE
	TaskbarSearch -SearchBox

	.EXAMPLE
	TaskbarSearch -SearchIcon

	.EXAMPLE
	TaskbarSearch -Hide

	.NOTES
	Current user
#>
function TaskbarSearch
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "ShowIcon"
		)]
		[switch]
		$SearchIcon,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "SearchBox"
		)]
		[switch]
		$SearchBox
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -PropertyType DWord -Value 0 -Force
		}
		"SearchIcon"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -PropertyType DWord -Value 1 -Force
		}
		"SearchBox"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -PropertyType DWord -Value 2 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the Windows Ink Workspace button on the taskbar

	.PARAMETER Show
	Show the Windows Ink Workspace button on the taskbar

	.PARAMETER Hide
	Hide the Windows Ink Workspace button on the taskbar

	.EXAMPLE
	WindowsInkWorkspace -Show

	.EXAMPLE
	WindowsInkWorkspace -Hide

	.NOTES
	Current user
#>
function WindowsInkWorkspace
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace -Name PenWorkspaceButtonDesiredVisibility -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace -Name PenWorkspaceButtonDesiredVisibility -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure icons in the notification area

	.PARAMETER Show
	Always show all icons in the notification area

	.PARAMETER Hide
	Hide all icons in the notification area

	.EXAMPLE
	TrayIcons -Show

	.EXAMPLE
	TrayIcons -Hide

	.NOTES
	Current user
#>
function TrayIcons
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray -PropertyType DWord -Value 1 -Force
		}
		"Show"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the Meet Now icon in the notification area

	.PARAMETER Hide
	Hide the Meet Now icon in the notification area

	.PARAMETER Show
	Show the Meet Now icon in the notification area

	.EXAMPLE
	MeetNow -Hide

	.EXAMPLE
	MeetNow -Show

	.NOTES
	Current user only
#>
function MeetNow
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Show"
		{
			$Settings = Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3 -Name Settings -ErrorAction Ignore
			$Settings[9] = 0
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3 -Name Settings -PropertyType Binary -Value $Settings -Force
		}
		"Hide"
		{
			$Settings = Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3 -Name Settings -ErrorAction Ignore
			$Settings[9] = 128
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3 -Name Settings -PropertyType Binary -Value $Settings -Force
		}
	}

	# Save all opened folders in order to restore them after File Explorer restart
	Clear-Variable -Name OpenedFolders -Force -ErrorAction Ignore
	$OpenedFolders = {(New-Object -ComObject Shell.Application).Windows() | ForEach-Object -Process {$_.Document.Folder.Self.Path}}.Invoke()

	# In order for the changes to take effect the File Explorer process has to be restarted
	Stop-Process -Name explorer -Force

	Start-Sleep -Seconds 3

	# Restoring closed folders
	foreach ($OpenedFolder in $OpenedFolders)
	{
		if (Test-Path -Path $OpenedFolder)
		{
			Invoke-Item -Path $OpenedFolder
		}
	}
}

<#
	.SYNOPSIS
	Unpin "Microsoft Edge" and "Microsoft Store" from the taskbar

	.NOTES
	Current user
#>
function UnpinTaskbarEdgeStore
{
	# Extract strings from shell32.dll using its' number
	# https://github.com/Disassembler0/Win10-Initial-Setup-Script/issues/8#issue-227159084
	$Signature = @{
		Namespace = "WinAPI"
		Name = "GetStr"
		Language = "CSharp"
		MemberDefinition = @"
[DllImport("kernel32.dll", CharSet = CharSet.Auto)]
public static extern IntPtr GetModuleHandle(string lpModuleName);
[DllImport("user32.dll", CharSet = CharSet.Auto)]
internal static extern int LoadString(IntPtr hInstance, uint uID, StringBuilder lpBuffer, int nBufferMax);
public static string GetString(uint strId)
{
	IntPtr intPtr = GetModuleHandle("shell32.dll");
	StringBuilder sb = new StringBuilder(255);
	LoadString(intPtr, strId, sb, sb.Capacity);
	return sb.ToString();
}
"@
	}
	if (-not ("WinAPI.GetStr" -as [type]))
	{
		Add-Type @Signature -Using System.Text
	}

	# Extract the localized "Unpin from taskbar" string from shell32.dll
	$LocalizedString = [WinAPI.GetStr]::GetString(5387)

	# Call the shortcut context menu item to unpin Microsoft Edge
	if (Test-Path -Path "$env:AppData\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Microsoft Edge.lnk")
	{
		$Shell = New-Object -ComObject Shell.Application
		$Folder = $Shell.NameSpace("$env:AppData\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar")
		$Shortcut = $Folder.ParseName("Microsoft Edge.lnk")
		$Shortcut.Verbs() | Where-Object -FilterScript {$_.Name -eq $LocalizedString} | ForEach-Object -Process {$_.DoIt()}
	}

	# Start-Job is used due to that the calling this function before UninstallUWPApps breaks the retrieval of the localized UWP apps packages names
	Start-Job -ScriptBlock {
		$Apps = (New-Object -ComObject Shell.Application).NameSpace("shell:::{4234d49b-0245-4df3-b780-3893943456e1}").Items()
		($Apps | Where-Object -FilterScript {$_.Name -eq "Microsoft Store"}).Verbs() | Where-Object -FilterScript {$_.Name -eq $Using:LocalizedString} | ForEach-Object -Process {$_.DoIt()}
	} | Receive-Job -Wait -AutoRemoveJob
}

<#
	.SYNOPSIS
	Configure the Control Panel icons view

	.PARAMETER Category
	View the Control Panel icons by: category

	.PARAMETER LargeIcons
	View the Control Panel icons by: large icons

	.PARAMETER SmallIcons
	View the Control Panel icons by: Small icons

	.EXAMPLE
	ControlPanelView -Category

	.EXAMPLE
	ControlPanelView -LargeIcons

	.EXAMPLE
	ControlPanelView -SmallIcons

	.NOTES
	Current user
#>
function ControlPanelView
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Category"
		)]
		[switch]
		$Category,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "LargeIcons"
		)]
		[switch]
		$LargeIcons,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "SmallIcons"
		)]
		[switch]
		$SmallIcons
	)

	switch ($PSCmdlet.ParameterSetName)
	{
			"Category"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name AllItemsIconView -PropertyType DWord -Value 0 -Force
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name StartupPage -PropertyType DWord -Value 0 -Force
		}
		"LargeIcons"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name AllItemsIconView -PropertyType DWord -Value 0 -Force
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name StartupPage -PropertyType DWord -Value 1 -Force
		}
		"SmallIcons"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name AllItemsIconView -PropertyType DWord -Value 1 -Force
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name StartupPage -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the Windows mode color scheme

	.PARAMETER Light
	Set the Windows mode color scheme to the light

	.PARAMETER Dark
	Set the Windows mode color scheme to the dark

	.EXAMPLE
	WindowsColorScheme -Light

	.EXAMPLE
	WindowsColorScheme -Dark

	.NOTES
	Current user
#>
function WindowsColorScheme
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Light"
		)]
		[switch]
		$Light,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Dark"
		)]
		[switch]
		$Dark
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Light"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -PropertyType DWord -Value 1 -Force
		}
		"Dark"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the default app mode color scheme

	.PARAMETER Light
	Set the app mode color scheme to the light

	.PARAMETER Dark
	Set the app mode color scheme to the dark

	.EXAMPLE
	AppMode -Light

	.EXAMPLE
	AppMode -Dark

	.NOTES
	Current user
#>
function AppMode
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Light"
		)]
		[switch]
		$Light,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Dark"
		)]
		[switch]
		$Dark
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Light"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -PropertyType DWord -Value 1 -Force
		}
		"Dark"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the "New App Installed" indicator

	.PARAMETER Hide
	Hide the "New App Installed" indicator

	.PARAMETER Show
	Show the "New App Installed" indicator

	.EXAMPLE
	NewAppInstalledNotification -Hide

	.EXAMPLE
	NewAppInstalledNotification -Show

	.NOTES
	Current user
#>
function NewAppInstalledNotification
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer))
			{
				New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
			}
			New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name NoNewAppAlert -PropertyType DWord -Value 1 -Force
		}
		"Show"
		{
			if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer))
			{
				New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
			}
			New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name NoNewAppAlert -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure first sign-in animation after the upgrade

	.PARAMETER Hide
	Hide first sign-in animation after the upgrade

	.PARAMETER Show
	Show first sign-in animation after the upgrade

	.EXAMPLE
	FirstLogonAnimation -Disable

	.EXAMPLE
	FirstLogonAnimation -Enable

	.NOTES
	Current user
#>
function FirstLogonAnimation
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableFirstLogonAnimation -PropertyType DWord -Value 0 -Force
		}
		"Enable"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableFirstLogonAnimation -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the quality factor of the JPEG desktop wallpapers

	.PARAMETER Max
	Set the quality factor of the JPEG desktop wallpapers to maximum

	.PARAMETER Default
	Set the quality factor of the JPEG desktop wallpapers to default

	.EXAMPLE
	JPEGWallpapersQuality -Max

	.EXAMPLE
	JPEGWallpapersQuality -Default

	.NOTES
	Current user
#>
function JPEGWallpapersQuality
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Max"
		)]
		[switch]
		$Max,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Default"
		)]
		[switch]
		$Default
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Max"
		{
			New-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name JPEGImportQuality -PropertyType DWord -Value 100 -Force
		}
		"Default"
		{
			Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name JPEGImportQuality -Force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.SYNOPSIS
	Configure the Task Manager mode

	.PARAMETER Expanded
	Start Task Manager in the expanded mode

	.PARAMETER Compact
	Start Task Manager in the compact mode

	.EXAMPLE
	TaskManagerWindow -Expanded

	.EXAMPLE
	TaskManagerWindow -Compact

	.NOTES
	Current user
#>
function TaskManagerWindow
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Expanded"
		)]
		[switch]
		$Expanded,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Compact"
		)]
		[switch]
		$Compact
	)

	$Taskmgr = Get-Process -Name Taskmgr -ErrorAction Ignore

	Start-Sleep -Seconds 1

	if ($Taskmgr)
	{
		$Taskmgr.CloseMainWindow()
	}
	Start-Process -FilePath Taskmgr.exe -PassThru

	Start-Sleep -Seconds 3

	do
	{
		Start-Sleep -Milliseconds 100
		$Preferences = Get-ItemPropertyValue -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences
	}
	until ($Preferences)

	Stop-Process -Name Taskmgr -ErrorAction Ignore

	switch ($PSCmdlet.ParameterSetName)
	{
		"Expanded"
		{
			$Preferences[28] = 0
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences -PropertyType Binary -Value $Preferences -Force
		}
		"Compact"
		{
			$Preferences[28] = 1
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences -PropertyType Binary -Value $Preferences -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure a notification when your PC requires a restart to finish updating

	.PARAMETER Hide
	Hide a notification when your PC requires a restart to finish updating

	.PARAMETER Show
	Show a notification when your PC requires a restart to finish updating

	.EXAMPLE
	RestartNotification -Hide

	.EXAMPLE
	RestartNotification -Show

	.NOTES
	Current user
#>
function RestartNotification
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name RestartNotificationsAllowed2 -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name RestartNotificationsAllowed2 -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the "- Shortcut" suffix adding to the name of the created shortcuts

	.PARAMETER Disable
	Do not add the "- Shortcut" suffix to the file name of created shortcuts

	.PARAMETER Enable
	Add the "- Shortcut" suffix to the file name of created shortcuts

	.EXAMPLE
	ShortcutsSuffix -Disable

	.EXAMPLE
	ShortcutsSuffix -Enable

	.NOTES
	Current user
#>
function ShortcutsSuffix
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates -Name ShortcutNameTemplate -PropertyType String -Value "%s.lnk" -Force
		}
		"Enable"
		{
			Remove-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates -Name ShortcutNameTemplate -Force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.SYNOPSIS
	Configure the PrtScn button usage

	.PARAMETER Disable
	Use the PrtScn button to open screen snipping

	.PARAMETER Enable
	Do not use the PrtScn button to open screen snipping

	.EXAMPLE
	PrtScnSnippingTool -Disable

	.EXAMPLE
	PrtScnSnippingTool -Enable

	.NOTES
	Current user
#>
function PrtScnSnippingTool
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			New-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name PrintScreenKeyForSnippingEnabled -PropertyType DWord -Value 0 -Force
		}
		"Enable"
		{
			New-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name PrintScreenKeyForSnippingEnabled -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure an input method for each app window

	.PARAMETER Enable
	Let use a different input method for each app window

	.PARAMETER Disable
	Do not let use a different input method for each app window

	.EXAMPLE
	AppsLanguageSwitch -Disable

	.EXAMPLE
	AppsLanguageSwitch -Enable

	.NOTES
	Current user
#>
function AppsLanguageSwitch
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			Set-WinLanguageBarOption -UseLegacySwitchMode
		}
		"Disable"
		{
			Set-WinLanguageBarOption
		}
	}
}
#endregion UI & Personalization

#region OneDrive
<#
	.SYNOPSIS
	Uninstall/install OneDrive

	.PARAMETER Uninstall
	Uninstall OneDrive

	.PARAMETER Install
	Install OneDrive

	.EXAMPLE
	OneDrive -Uninstall

	.EXAMPLE
	OneDrive -Install

	.NOTES
	Machine-wide
#>
function OneDrive
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Uninstall"
		)]
		[switch]
		$Uninstall,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Install"
		)]
		[switch]
		$Install
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Uninstall"
		{
			[xml]$Uninstall = Get-Package -Name "Microsoft OneDrive" -ProviderName Programs -ErrorAction Ignore | ForEach-Object -Process {$_.SwidTagText}
			[xml]$Uninstall = $Uninstall.SoftwareIdentity.InnerXml
			[string]$UninstallString = $Uninstall.Meta.UninstallString
			if ($UninstallString)
			{
				Write-Verbose -Message $Localization.OneDriveUninstalling -Verbose

				Stop-Process -Name OneDrive -Force -ErrorAction Ignore
				Stop-Process -Name OneDriveSetup -Force -ErrorAction Ignore
				Stop-Process -Name FileCoAuth -Force -ErrorAction Ignore

				# Getting link to the OneDriveSetup.exe and its' argument(s)
				[string[]]$OneDriveSetup = ($UninstallString -Replace("\s*/",",/")).Split(",").Trim()
				if ($OneDriveSetup.Count -eq 2)
				{
					Start-Process -FilePath $OneDriveSetup[0] -ArgumentList $OneDriveSetup[1..1] -Wait
				}
				else
				{
					Start-Process -FilePath $OneDriveSetup[0] -ArgumentList $OneDriveSetup[1..2] -Wait
				}

				# Getting the OneDrive user folder path and removing it
				$OneDriveUserFolder = Get-ItemPropertyValue -Path HKCU:\Environment -Name OneDrive
				Remove-Item -Path $OneDriveUserFolder -Recurse -Force -ErrorAction Ignore

				# https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-movefileexa
				# The system does not move the file until the operating system is restarted
				# The system moves the file immediately after AUTOCHK is executed, but before creating any paging files
				$Signature = @{
					Namespace = "WinAPI"
					Name = "DeleteFiles"
					Language = "CSharp"
					MemberDefinition = @"
public enum MoveFileFlags
{
	MOVEFILE_DELAY_UNTIL_REBOOT = 0x00000004
}

[DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
static extern bool MoveFileEx(string lpExistingFileName, string lpNewFileName, MoveFileFlags dwFlags);

public static bool MarkFileDelete (string sourcefile)
{
	return MoveFileEx(sourcefile, null, MoveFileFlags.MOVEFILE_DELAY_UNTIL_REBOOT);
}
"@
				}

				# If there are some files or folders left in $env:LOCALAPPDATA\Temp
				if ((Get-ChildItem -Path $OneDriveUserFolder -Force -ErrorAction Ignore | Measure-Object).Count -ne 0)
				{
					if (-not ("WinAPI.DeleteFiles" -as [type]))
					{
						Add-Type @Signature
					}

					try
					{
						Remove-Item -Path $OneDriveUserFolder -Recurse -Force -ErrorAction Stop
					}
					catch
					{
						# If files are in use remove them at the next boot
						Get-ChildItem -Path $OneDriveUserFolder -Recurse -Force | ForEach-Object -Process {[WinAPI.DeleteFiles]::MarkFileDelete($_.FullName)}
					}
				}

				Remove-ItemProperty -Path HKCU:\Environment -Name OneDrive, OneDriveConsumer -Force -ErrorAction Ignore
				Remove-Item -Path HKCU:\SOFTWARE\Microsoft\OneDrive -Recurse -Force -ErrorAction Ignore
				Remove-Item -Path HKLM:\SOFTWARE\WOW6432Node\Microsoft\OneDrive -Recurse -Force -ErrorAction Ignore
				Remove-Item -Path "$env:ProgramData\Microsoft OneDrive" -Recurse -Force -ErrorAction Ignore
				Remove-Item -Path $env:SystemDrive\OneDriveTemp -Recurse -Force -ErrorAction Ignore
				Unregister-ScheduledTask -TaskName *OneDrive* -Confirm:$false

				# Getting the OneDrive folder path
				$OneDriveFolder = Split-Path -Path (Split-Path -Path $OneDriveSetup[0] -Parent)

				# Save all opened folders in order to restore them after File Explorer restarting
				Clear-Variable -Name OpenedFolders -Force -ErrorAction Ignore
				$OpenedFolders = {(New-Object -ComObject Shell.Application).Windows() | ForEach-Object -Process {$_.Document.Folder.Self.Path}}.Invoke()

				# Terminate File Explorer process
				TASKKILL /F /IM explorer.exe

				# Attempt to unregister FileSyncShell64.dll and remove
				$FileSyncShell64dlls = Get-ChildItem -Path "$OneDriveFolder\*\amd64\FileSyncShell64.dll" -Force
				foreach ($FileSyncShell64dll in $FileSyncShell64dlls.FullName)
				{
					Start-Process -FilePath regsvr32.exe -ArgumentList "/u /s $FileSyncShell64dll" -Wait
					Remove-Item -Path $FileSyncShell64dll -Force -ErrorAction Ignore

					if (Test-Path -Path $FileSyncShell64dll)
					{
						if (-not ("WinAPI.DeleteFiles" -as [type]))
						{
							Add-Type @Signature
						}

						# If files are in use remove them at the next boot
						Get-ChildItem -Path $FileSyncShell64dll -Recurse -Force | ForEach-Object -Process {[WinAPI.DeleteFiles]::MarkFileDelete($_.FullName)}
					}
				}

				Start-Sleep -Seconds 1

				# Restoring closed folders
				Start-Process -FilePath explorer

				foreach ($OpenedFolder in $OpenedFolders)
				{
					if (Test-Path -Path $OpenedFolder)
					{
						Invoke-Item -Path $OpenedFolder
					}
				}

				Remove-Item -Path $OneDriveFolder -Recurse -Force -ErrorAction Ignore
				Remove-Item -Path $env:LOCALAPPDATA\OneDrive -Recurse -Force -ErrorAction Ignore
				Remove-Item -Path $env:LOCALAPPDATA\Microsoft\OneDrive -Recurse -Force -ErrorAction Ignore
				Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" -Force -ErrorAction Ignore
			}
		}
		"Install"
		{
			$OneDrive = Get-Package -Name "Microsoft OneDrive" -ProviderName Programs -Force -ErrorAction Ignore
			if (-not $OneDrive)
			{
				if (Test-Path -Path $env:SystemRoot\SysWOW64\OneDriveSetup.exe)
				{
					Write-Verbose -Message $Localization.OneDriveInstalling -Verbose
					Start-Process -FilePath $env:SystemRoot\SysWOW64\OneDriveSetup.exe
				}
				else
				{
					# Downloading the latest OneDrive
					try
					{
						if ((Invoke-WebRequest -Uri https://www.google.com -UseBasicParsing -DisableKeepAlive -Method Head).StatusDescription)
						{
							Write-Verbose -Message $Localization.OneDriveDownloading -Verbose

							$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
							$Parameters = @{
								Uri = "https://go.microsoft.com/fwlink/p/?LinkID=2121808"
								OutFile = "$DownloadsFolder\OneDriveSetup.exe"
								SslProtocol = "Tls12"
								Verbose = [switch]::Present
							}
							Invoke-WebRequest @Parameters

							Start-Process -FilePath "$DownloadsFolder\OneDriveSetup.exe"
						}
					}
					catch [System.Net.WebException]
					{
						Write-Warning -Message $Localization.NoInternetConnection
						Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue
						return
					}
				}

				Get-ScheduledTask -TaskName "Onedrive* Update*" | Enable-ScheduledTask
			}
		}
	}
}
#endregion OneDrive

#region System
#region StorageSense
<#
	.SYNOPSIS
	Configure Storage Sense

	.PARAMETER Disable
	Turn off Storage Sense

	.PARAMETER Enable
	Turn on off Storage Sense

	.EXAMPLE
	StorageSense -Disable

	.EXAMPLE
	StorageSense -Enable

	.NOTES
	Current user
#>
function StorageSense
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -ItemType Directory -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01 -PropertyType DWord -Value 0 -Force
		}
		"Enable"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -ItemType Directory -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01 -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure Storage Sense running

	.PARAMETER Disable
	Run Storage Sense every month/during low free disk space

	.PARAMETER Enable
	Run Storage Sense every month/during low free disk space

	.EXAMPLE
	StorageSenseFrequency -Month

	.EXAMPLE
	StorageSenseFrequency -Default

	.NOTES
	Current user
#>
function StorageSenseFrequency
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Month"
		)]
		[switch]
		$Month,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Default"
		)]
		[switch]
		$Default
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Month"
		{
			if ((Get-ItemPropertyValue -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01) -eq "1")
			{
				New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 2048 -PropertyType DWord -Value 30 -Force
			}
		}
		"Default"
		{
			if ((Get-ItemPropertyValue -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01) -eq "1")
			{
				New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 2048 -PropertyType DWord -Value 0 -Force
			}
		}
	}
}

<#
	.SYNOPSIS
	Configure temporary files deletion

	.PARAMETER Enable
	Delete temporary files that apps aren't using

	.PARAMETER Disable
	Do not delete temporary files that apps aren't using

	.EXAMPLE
	StorageSenseTempFiles -Enable

	.EXAMPLE
	StorageSenseTempFiles -Disable

	.NOTES
	Current user
#>
function StorageSenseTempFiles
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			if ((Get-ItemPropertyValue -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01) -eq "1")
			{
				New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 04 -PropertyType DWord -Value 1 -Force
			}
		}
		"Disable"
		{
			if ((Get-ItemPropertyValue -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01) -eq "1")
			{
				New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 04 -PropertyType DWord -Value 0 -Force
			}
		}
	}
}

<#
	.SYNOPSIS
	Configure files in recycle bin deletion

	.PARAMETER Disable
	Delete files in recycle bin if they have been there for over 30 days

	.PARAMETER Enable
	Do not delete files in recycle bin if they have been there for over 30 days

	.EXAMPLE
	StorageSenseRecycleBin -Enable

	.EXAMPLE
	StorageSenseRecycleBin -Disable

	.NOTES
	Current user
#>
function StorageSenseRecycleBin
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			if ((Get-ItemPropertyValue -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01) -eq "1")
			{
				New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 08 -PropertyType DWord -Value 1 -Force
				New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 256 -PropertyType DWord -Value 30 -Force
			}
		}
		"Disable"
		{
			if ((Get-ItemPropertyValue -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01) -eq "1")
			{
				New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 08 -PropertyType DWord -Value 0 -Force
				New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 256 -PropertyType DWord -Value 0 -Force
			}
		}
	}
}
#endregion StorageSense

<#
	.SYNOPSIS
	Configure hibernation

	.PARAMETER Disable
	Disable hibernation

	.PARAMETER Enable
	Enable hibernation

	.EXAMPLE
	Hibernate -Enable

	.EXAMPLE
	Hibernate -Disable

	.NOTES
	Do not recommend turning it off on laptops
	Current user
#>
function Hibernate
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			POWERCFG /HIBERNATE ON
		}
		"Disable"
		{
			POWERCFG /HIBERNATE OFF
		}
	}
}

<#
	.SYNOPSIS
	Configure the %TEMP% environment variable path

	.PARAMETER SystemDrive
	Change the %TEMP% environment variable path to "%SystemDrive%\Temp"

	.PARAMETER Default
	Change the %TEMP% environment variable path to "%LOCALAPPDATA%\Temp"

	.EXAMPLE
	TempFolder -SystemDrive

	.EXAMPLE
	TempFolder -Default

	.NOTES
	Machine-wide
#>
function TempFolder
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "SystemDrive"
		)]
		[switch]
		$SystemDrive,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Default"
		)]
		[switch]
		$Default
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"SystemDrive"
		{
			if ($env:TEMP -ne "$env:SystemDrive\Temp")
			{
				# Restart the Printer Spooler service (Spooler)
				Restart-Service -Name Spooler -Force

				# Stop OneDrive processes
				Stop-Process -Name OneDrive -Force -ErrorAction Ignore
				Stop-Process -Name FileCoAuth -Force -ErrorAction Ignore

				if (-not (Test-Path -Path $env:SystemDrive\Temp))
				{
					New-Item -Path $env:SystemDrive\Temp -ItemType Directory -Force
				}

				# Copy all imported module folders to the new %TEMP% folder
				Get-ChildItem -Path $env:TEMP -Force | Where-Object -FilterScript {$_.Name -like "*remoteIpMoProxy*"} | ForEach-Object -Process {
					Copy-Item $_.FullName -Destination $env:SystemDrive\Temp -Recurse -Force
				}

				# Cleaning up folders
				Remove-Item -Path $env:SystemRoot\Temp -Recurse -Force -ErrorAction Ignore
				Get-Item -Path $env:TEMP -Force -ErrorAction Ignore | Where-Object -FilterScript {$_.LinkType -ne "SymbolicLink"} | Remove-Item -Recurse -Force -ErrorAction Ignore

				if (-not (Test-Path -Path $env:LOCALAPPDATA\Temp))
				{
					New-Item -Path $env:LOCALAPPDATA\Temp -ItemType Directory -Force
				}

				# If there are some files or folders left in $env:LOCALAPPDATA\Temp
				if ((Get-ChildItem -Path $env:TEMP -Force -ErrorAction Ignore | Measure-Object).Count -ne 0)
				{
					# https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-movefileexa
					# The system does not move the file until the operating system is restarted
					# The system moves the file immediately after AUTOCHK is executed, but before creating any paging files
					$Signature = @{
						Namespace = "WinAPI"
						Name = "DeleteFiles"
						Language = "CSharp"
						MemberDefinition = @"
public enum MoveFileFlags
{
	MOVEFILE_DELAY_UNTIL_REBOOT = 0x00000004
}

[DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
static extern bool MoveFileEx(string lpExistingFileName, string lpNewFileName, MoveFileFlags dwFlags);

public static bool MarkFileDelete (string sourcefile)
{
	return MoveFileEx(sourcefile, null, MoveFileFlags.MOVEFILE_DELAY_UNTIL_REBOOT);
}
"@
					}

					if (-not ("WinAPI.DeleteFiles" -as [type]))
					{
						Add-Type @Signature
					}

					try
					{
						Get-ChildItem -Path $env:TEMP -Recurse -Force | Remove-Item -Recurse -Force -ErrorAction Stop
					}
					catch
					{
						# If files are in use remove them at the next boot
						Get-ChildItem -Path $env:TEMP -Recurse -Force | ForEach-Object -Process {[WinAPI.DeleteFiles]::MarkFileDelete($_.FullName)}
					}

					$SymbolicLinkTask = @"
Get-ChildItem -Path `$env:LOCALAPPDATA\Temp -Recurse -Force | Remove-Item -Recurse -Force

Get-Item -Path `$env:LOCALAPPDATA\Temp -Force | Where-Object -FilterScript {`$_.LinkType -ne """SymbolicLink"""} | Remove-Item -Recurse -Force
New-Item -Path `$env:LOCALAPPDATA\Temp -ItemType SymbolicLink -Value `$env:SystemDrive\Temp -Force

Unregister-ScheduledTask -TaskName SymbolicLink -Confirm:`$false
"@

					# Create a temporary scheduled task to create a symbolic link to the %SystemDrive%\Temp folder
					$Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Hidden -Command $SymbolicLinkTask"
					$Trigger = New-ScheduledTaskTrigger -AtLogon -User $env:USERNAME
					$Settings = New-ScheduledTaskSettingsSet -Compatibility Win8
					$Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
					$Parameters = @{
						TaskName  = "SymbolicLink"
						Principal = $Principal
						Action    = $Action
						Settings  = $Settings
						Trigger   = $Trigger
					}
					Register-ScheduledTask @Parameters -Force
				}
				else
				{
					# Create a symbolic link to the %SystemDrive%\Temp folder
					New-Item -Path $env:LOCALAPPDATA\Temp -ItemType SymbolicLink -Value $env:SystemDrive\Temp -Force
				}

				#region main
				# Change the %TEMP% environment variable path to "%LOCALAPPDATA%\Temp"
				[Environment]::SetEnvironmentVariable("TMP", "$env:SystemDrive\Temp", "User")
				[Environment]::SetEnvironmentVariable("TMP", "$env:SystemDrive\Temp", "Machine")
				[Environment]::SetEnvironmentVariable("TMP", "$env:SystemDrive\Temp", "Process")
				New-ItemProperty -Path HKCU:\Environment -Name TMP -PropertyType ExpandString -Value $env:SystemDrive\Temp -Force

				[Environment]::SetEnvironmentVariable("TEMP", "$env:SystemDrive\Temp", "User")
				[Environment]::SetEnvironmentVariable("TEMP", "$env:SystemDrive\Temp", "Machine")
				[Environment]::SetEnvironmentVariable("TEMP", "$env:SystemDrive\Temp", "Process")
				New-ItemProperty -Path HKCU:\Environment -Name TEMP -PropertyType ExpandString -Value $env:SystemDrive\Temp -Force

				New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name TMP -PropertyType ExpandString -Value $env:SystemDrive\Temp -Force
				New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name TEMP -PropertyType ExpandString -Value $env:SystemDrive\Temp -Force
				# endregion main
			}
		}
		"Default"
		{
			if ($env:TEMP -ne "$env:LOCALAPPDATA\Temp")
			{
				# Restart the Printer Spooler service (Spooler)
				Restart-Service -Name Spooler -Force

				# Stop OneDrive processes
				Stop-Process -Name OneDrive -Force -ErrorAction Ignore
				Stop-Process -Name FileCoAuth -Force -ErrorAction Ignore

				# Remove a symbolic link to the %SystemDrive%\Temp folder
				if (Get-Item -Path $env:LOCALAPPDATA\Temp -Force -ErrorAction Ignore | Where-Object -FilterScript {$_.LinkType -eq "SymbolicLink"})
				{
					(Get-Item -Path $env:LOCALAPPDATA\Temp -Force).Delete()
				}

				if (-not (Test-Path -Path $env:SystemRoot\Temp))
				{
					New-Item -Path $env:SystemRoot\Temp -ItemType Directory -Force
				}
				if (-not (Test-Path -Path $env:LOCALAPPDATA\Temp))
				{
					New-Item -Path $env:LOCALAPPDATA\Temp -ItemType Directory -Force
				}

				# Copy all imported module folders to the new %TEMP% folder
				Get-ChildItem -Path $env:TEMP -Force | Where-Object -FilterScript {$_.Name -like "*remoteIpMoProxy*"} | ForEach-Object -Process {
					Copy-Item $_.FullName -Destination $env:LOCALAPPDATA\Temp -Recurse -Force
				}

				# Removing folders
				Remove-Item -Path $env:TEMP -Recurse -Force -ErrorAction Ignore

				if ((Get-ChildItem -Path $env:TEMP -Force -ErrorAction Ignore | Measure-Object).Count -ne 0)
				{
					# https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-movefileexa
					# The system does not move the file until the operating system is restarted
					# The system moves the file immediately after AUTOCHK is executed, but before creating any paging files
					$Signature = @{
						Namespace = "WinAPI"
						Name = "DeleteFiles"
						Language = "CSharp"
						MemberDefinition = @"
public enum MoveFileFlags
{
	MOVEFILE_DELAY_UNTIL_REBOOT = 0x00000004
}

[DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
static extern bool MoveFileEx(string lpExistingFileName, string lpNewFileName, MoveFileFlags dwFlags);

public static bool MarkFileDelete (string sourcefile)
{
	return MoveFileEx(sourcefile, null, MoveFileFlags.MOVEFILE_DELAY_UNTIL_REBOOT);
}
"@
					}

					if (-not ("WinAPI.DeleteFiles" -as [type]))
					{
						Add-Type @Signature
					}

					try
					{
						Remove-Item -Path $env:TEMP -Recurse -Force -ErrorAction Stop
					}
					catch
					{
						# If files are in use remove them at the next boot
						Get-ChildItem -Path $env:TEMP -Recurse -Force -ErrorAction Ignore | ForEach-Object -Process {[WinAPI.DeleteFiles]::MarkFileDelete($_.FullName)}
					}

					$TempFolder = [System.Environment]::ExpandEnvironmentVariables($env:TEMP)
					$TempFolderCleanupTask = @"
Remove-Item -Path "$TempFolder" -Recurse -Force

Unregister-ScheduledTask -TaskName TemporaryTask -Confirm:`$false
"@

					# Create a temporary scheduled task to clean up the temporary folder
					$Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Hidden -Command $TempFolderCleanupTask"
					$Trigger = New-ScheduledTaskTrigger -AtLogon -User $env:USERNAME
					$Settings = New-ScheduledTaskSettingsSet -Compatibility Win8
					$Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
					$Parameters = @{
						TaskName  = "TemporaryTask"
						Principal = $Principal
						Action    = $Action
						Settings  = $Settings
						Trigger   = $Trigger
					}
					Register-ScheduledTask @Parameters -Force
				}

				#region main
				# Change the %TEMP% environment variable path to "%LOCALAPPDATA%\Temp"
				[Environment]::SetEnvironmentVariable("TMP", "$env:LOCALAPPDATA\Temp", "User")
				[Environment]::SetEnvironmentVariable("TMP", "$env:SystemRoot\TEMP", "Machine")
				[Environment]::SetEnvironmentVariable("TMP", "$env:LOCALAPPDATA\Temp", "Process")
				New-ItemProperty -Path HKCU:\Environment -Name TMP -PropertyType ExpandString -Value "%USERPROFILE%\AppData\Local\Temp" -Force

				[Environment]::SetEnvironmentVariable("TEMP", "$env:LOCALAPPDATA\Temp", "User")
				[Environment]::SetEnvironmentVariable("TEMP", "$env:SystemRoot\TEMP", "Machine")
				[Environment]::SetEnvironmentVariable("TEMP", "$env:LOCALAPPDATA\Temp", "Process")
				New-ItemProperty -Path HKCU:\Environment -Name TEMP -PropertyType ExpandString -Value "%USERPROFILE%\AppData\Local\Temp" -Force

				New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name TMP -PropertyType ExpandString -Value "%SystemRoot%\TEMP" -Force
				New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name TEMP -PropertyType ExpandString -Value "%SystemRoot%\TEMP" -Force
				# endregion main
			}
		}
	}
}

<#
	.SYNOPSIS
	Configure the Windows 260 character path limit

	.PARAMETER Disable
	Disable the Windows 260 character path limit

	.PARAMETER Enable
	Enable the Windows 260 character path limit

	.EXAMPLE
	Win32LongPathLimit -Disable

	.EXAMPLE
	Win32LongPathLimit -Enable

	.NOTES
	Machine-wide
#>
function Win32LongPathLimit
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem -Name LongPathsEnabled -PropertyType DWord -Value 1 -Force
		}
		"Enable"
		{
			New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem -Name LongPathsEnabled -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the Stop error information display on the BSoD

	.PARAMETER Disable
	Do not display the Stop error information on the BSoD

	.PARAMETER Enable
	Display the Stop error information on the BSoD

	.EXAMPLE
	BSoDStopError -Disable

	.EXAMPLE
	BSoDStopError -Enable

	.NOTES
	Machine-wide
#>
function BSoDStopError
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl -Name DisplayParameters -PropertyType DWord -Value 0 -Force
		}
		"Enable"
		{
			New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl -Name DisplayParameters -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Confgure UAC

	.PARAMETER Disable
	Choose when to be notified about changes to your computer: never notify

	.PARAMETER Enable
	Choose when to be notified about changes to your computer: notify me only when apps try to make changes to my computer

	.EXAMPLE
	AdminApprovalMode -Disable

	.EXAMPLE
	AdminApprovalMode -Enable

	.NOTES
	Machine-wide
#>
function AdminApprovalMode
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -PropertyType DWord -Value 0 -Force
		}
		"Enable"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -PropertyType DWord -Value 5 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled

	.PARAMETER Disable
	Turn off access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled

	.PARAMETER Enable
	Turn on access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled

	.EXAMPLE
	MappedDrivesAppElevatedAccess -Disable

	.EXAMPLE
	MappedDrivesAppElevatedAccess -Enable

	.NOTES
	Machine-wide
#>
function MappedDrivesAppElevatedAccess
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLinkedConnections -PropertyType DWord -Value 0 -Force
		}
		"Enable"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLinkedConnections -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure Delivery Optimization

	.PARAMETER Disable
	Turn off Delivery Optimization

	.PARAMETER Enable
	Turn on Delivery Optimization

	.EXAMPLE
	DeliveryOptimization -Disable

	.EXAMPLE
	DeliveryOptimization -Enable

	.NOTES
	Current user
#>
function DeliveryOptimization
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			New-ItemProperty -Path Registry::HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings -Name DownloadMode -PropertyType DWord -Value 0 -Force
			Delete-DeliveryOptimizationCache -Force
		}
		"Enable"
		{
			New-ItemProperty -Path Registry::HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings -Name DownloadMode -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the Group Policy processing

	.PARAMETER Disable
	Never wait for the network at computer startup and logon for workgroup networks

	.PARAMETER Enable
	Always wait for the network at computer startup and logon for workgroup networks

	.EXAMPLE
	WaitNetworkStartup -Disable

	.EXAMPLE
	WaitNetworkStartup -Enable

	.NOTES
	Machine-wide
#>
function WaitNetworkStartup
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			if ((Get-CimInstance -ClassName CIM_ComputerSystem).PartOfDomain -eq $true)
			{
				Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name SyncForegroundPolicy -Force -ErrorAction SilentlyContinue
			}
		}
		"Enable"
		{
			if ((Get-CimInstance -ClassName CIM_ComputerSystem).PartOfDomain -eq $true)
			{
				if (-not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon"))
				{
					New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Force
				}
				New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name SyncForegroundPolicy -PropertyType DWord -Value 1 -Force
			}
		}
	}
}

<#
	.SYNOPSIS
	Configure whether Windows decide which printer should be the default one

	.PARAMETER Disable
	Do not let Windows decide which printer should be the default one

	.PARAMETER Enable
	Let Windows decide which printer should be the default one

	.EXAMPLE
	WindowsManageDefaultPrinter -Disable

	.EXAMPLE
	WindowsManageDefaultPrinter -Enable

	.NOTES
	Current user
#>
function WindowsManageDefaultPrinter
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" -Name LegacyDefaultPrinterMode -PropertyType DWord -Value 1 -Force
		}
		"Enable"
		{
			New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows" -Name LegacyDefaultPrinterMode -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure Windows features

	.PARAMETER Disable
	Disable Windows features

	.PARAMETER Enable
	Enable Windows features

	.EXAMPLE
	WindowsFeatures -Disable

	.EXAMPLE
	WindowsFeatures -Enable

	.NOTES
	A pop-up dialog box enables the user to select features
	Current user
#>
function WindowsFeatures
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	Add-Type -AssemblyName PresentationCore, PresentationFramework

	#region Variables
	# Initialize an array list to store the selected Windows features
	$SelectedFeatures = New-Object -TypeName System.Collections.ArrayList($null)

	# The following Windows features will have their checkboxes checked
	[string[]]$CheckedFeatures = @(
		# Legacy Components
		# Компоненты прежних версий
		"LegacyComponents",

		# PowerShell 2.0
		"MicrosoftWindowsPowerShellV2",
		"MicrosoftWindowsPowershellV2Root",

		# Microsoft XPS Document Writer
		# Средство записи XPS-документов (Microsoft)
		"Printing-XPSServices-Features",

		# Work Folders Client
		# Клиент рабочих папок
		"WorkFolders-Client"
	)

	# The following Windows features will have their checkboxes unchecked
	[string[]]$UncheckedFeatures = @(
		<#
			Media Features
			Компоненты работы с мультимедиа

			If you want to leave "Multimedia settings" in the advanced settings of Power Options do not disable this feature
			Если вы хотите оставить параметр "Параметры мультимедиа" в дополнительных параметрах электропитания, не отключайте этот компонент
		#>
		"MediaPlayback"
	)
	#endregion Variables

	#region XAML Markup
	# The section defines the design of the upcoming dialog box
	[xml]$XAML = '
	<Window
		xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Name="Window"
		MinHeight="450" MinWidth="400"
		SizeToContent="Width" WindowStartupLocation="CenterScreen"
		TextOptions.TextFormattingMode="Display" SnapsToDevicePixels="True"
		FontFamily="Segoe UI" FontSize="12" ShowInTaskbar="False">
		<Window.Resources>
			<Style TargetType="StackPanel">
				<Setter Property="Orientation" Value="Horizontal"/>
			</Style>
			<Style TargetType="CheckBox">
				<Setter Property="Margin" Value="10, 10, 5, 10"/>
				<Setter Property="IsChecked" Value="True"/>
			</Style>
			<Style TargetType="TextBlock">
				<Setter Property="Margin" Value="5, 10, 10, 10"/>
			</Style>
			<Style TargetType="Button">
				<Setter Property="Margin" Value="20"/>
				<Setter Property="Padding" Value="10"/>
			</Style>
		</Window.Resources>
		<Grid>
			<Grid.RowDefinitions>
				<RowDefinition Height="*"/>
				<RowDefinition Height="Auto"/>
			</Grid.RowDefinitions>
			<ScrollViewer Name="Scroll" Grid.Row="0"
				HorizontalScrollBarVisibility="Disabled"
				VerticalScrollBarVisibility="Auto">
				<StackPanel Name="PanelContainer" Orientation="Vertical"/>
			</ScrollViewer>
			<Button Name="Button" Grid.Row="1"/>
		</Grid>
	</Window>
	'
	#endregion XAML Markup

	$Reader = (New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $XAML)
	$Form = [Windows.Markup.XamlReader]::Load($Reader)
	$XAML.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object -Process {
		Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)
	}

	#region Functions
	function Get-CheckboxClicked
	{
		[CmdletBinding()]
		param
		(
			[Parameter(
				Mandatory = $true,
				ValueFromPipeline = $true
			)]
			[ValidateNotNull()]
			$CheckBox
		)

		$Feature = $Features | Where-Object -FilterScript {$_.DisplayName -eq $CheckBox.Parent.Children[1].Text}

		if ($CheckBox.IsChecked)
		{
			[void]$SelectedFeatures.Add($Feature)
		}
		else
		{
			[void]$SelectedFeatures.Remove($Feature)
		}
		if ($SelectedFeatures.Count -gt 0)
		{
			$Button.IsEnabled = $true
		}
		else
		{
			$Button.IsEnabled = $false
		}
	}

	function DisableButton
	{
		Write-Verbose -Message $Localization.Patient -Verbose

		[void]$Window.Close()

		$SelectedFeatures | ForEach-Object -Process {Write-Verbose $_.DisplayName -Verbose}
		$SelectedFeatures | Disable-WindowsOptionalFeature -Online -NoRestart
	}

	function EnableButton
	{
		Write-Verbose -Message $Localization.Patient -Verbose

		[void]$Window.Close()

		$SelectedFeatures | ForEach-Object -Process {Write-Verbose -Message $_.DisplayName -Verbose}
		$SelectedFeatures | Enable-WindowsOptionalFeature -Online -NoRestart
	}

	function Add-FeatureControl
	{
		[CmdletBinding()]
		param
		(
			[Parameter(
				Mandatory = $true,
				ValueFromPipeline = $true
			)]
			[ValidateNotNull()]
			$Feature
		)

		process
		{
			$CheckBox = New-Object -TypeName System.Windows.Controls.CheckBox
			$CheckBox.Add_Click({Get-CheckboxClicked -CheckBox $_.Source})
			$CheckBox.ToolTip = $Feature.Description

			$TextBlock = New-Object -TypeName System.Windows.Controls.TextBlock
			$TextBlock.Text = $Feature.DisplayName
			$TextBlock.ToolTip = $Feature.Description

			$StackPanel = New-Object -TypeName System.Windows.Controls.StackPanel
			[void]$StackPanel.Children.Add($CheckBox)
			[void]$StackPanel.Children.Add($TextBlock)
			[void]$PanelContainer.Children.Add($StackPanel)

			$CheckBox.IsChecked = $true

			# If feature checked add to the array list
			if ($UnCheckedFeatures | Where-Object -FilterScript {$Feature.FeatureName -like $_})
			{
				$CheckBox.IsChecked = $false
				# Exit function if item is not checked
				return
			}

			# If feature checked add to the array list
			[void]$SelectedFeatures.Add($Feature)
		}
	}
	#endregion Functions

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{

			$State = @("Disabled", "DisablePending")
			$ButtonContent = $Localization.Enable
			$ButtonAdd_Click = {EnableButton}
		}
		"Disable"
		{
			$State = @("Enabled", "EnablePending")
			$ButtonContent = $Localization.Disable
			$ButtonAdd_Click = {DisableButton}
		}
	}

	Write-Verbose -Message $Localization.Patient -Verbose

	# Getting list of all optional features according to the conditions
	$OFS = "|"
	$Features = Get-WindowsOptionalFeature -Online | Where-Object -FilterScript {
		($_.State -in $State) -and (($_.FeatureName -match $UncheckedFeatures) -or ($_.FeatureName -match $CheckedFeatures))
	} | ForEach-Object -Process {Get-WindowsOptionalFeature -FeatureName $_.FeatureName -Online}
	$OFS = " "

	if (-not ($Features))
	{
		Write-Verbose -Message $Localization.NoData -Verbose
		return
	}

	Write-Verbose -Message $Localization.DialogBoxOpening -Verbose

	$Window.Add_Loaded({$Features | Add-FeatureControl})
	$Button.Content = $ButtonContent
	$Button.Add_Click({& $ButtonAdd_Click})

	$Window.Title = $Localization.WindowsFeaturesTitle
	$Form.ShowDialog() | Out-Null
}

<#
	.SYNOPSIS
	Configure optional features

	.PARAMETER Uninstall
	Uninstall optional features

	.PARAMETER Install
	Install optional features

	.EXAMPLE
	WindowsCapabilities -Uninstall

	.EXAMPLE
	WindowsCapabilities -Install

	.NOTES
	A pop-up dialog box enables the user to select features
	Current user
#>
function WindowsCapabilities
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Install"
		)]
		[switch]
		$Install,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Uninstall"
		)]
		[switch]
		$Uninstall
	)

	Add-Type -AssemblyName PresentationCore, PresentationFramework

	#region Variables
	# Initialize an array list to store the selected optional features
	$SelectedCapabilities = New-Object -TypeName System.Collections.ArrayList($null)

	# The following optional features will have their checkboxes checked
	[string[]]$CheckedCapabilities = @(
		# Steps Recorder
		# Средство записи действий
		"App.StepsRecorder*",

		# Microsoft Quick Assist
		# Быстрая поддержка (Майкрософт)
		"App.Support.QuickAssist*",

		# Microsoft Paint
		"Microsoft.Windows.MSPaint*",

		# WordPad
		"Microsoft.Windows.WordPad*"
	)

	# The following optional features will have their checkboxes unchecked
	[string[]]$UncheckedCapabilities = @(
		# Internet Explorer 11
		"Browser.InternetExplorer*",

		# Math Recognizer
		# Распознаватель математических знаков
		"MathRecognizer*",

		<#
			Windows Media Player
			Проигрыватель Windows Media

			If you want to leave "Multimedia settings" element in the advanced settings of Power Options do not uninstall this feature
			Если вы хотите оставить параметр "Параметры мультимедиа" в дополнительных параметрах электропитания, не удаляйте этот компонент
		#>
		"Media.WindowsMediaPlayer*",

		# OpenSSH Client
		# Клиент OpenSSH
		"OpenSSH.Client*"
	)

	# The following optional features will be excluded from the display
	[string[]]$ExcludedCapabilities = @(
		# The DirectX Database to configure and optimize apps when multiple Graphics Adapters are present
		# База данных DirectX для настройки и оптимизации приложений при наличии нескольких графических адаптеров
		"DirectX.Configuration.Database*",

		# Language components
		# Языковые компоненты
		"Language.*",

		# Notepad
		# Блокнот
		"Microsoft.Windows.Notepad*",

		# Mail, contacts, and calendar sync component
		# Компонент синхронизации почты, контактов и календаря
		"OneCoreUAP.OneSync*",

		# Windows PowerShell Intergrated Scripting Enviroment
		# Интегрированная среда сценариев Windows PowerShell
		"Microsoft.Windows.PowerShell.ISE*",

		# Management of printers, printer drivers, and printer servers
		# Управление принтерами, драйверами принтеров и принт-серверами
		"Print.Management.Console*",

		# Features critical to Windows functionality
		# Компоненты, критичные для работоспособности Windows
		"Windows.Client.ShellComponents*"
	)
	#endregion Variables

	#region XAML Markup
	# The section defines the design of the upcoming dialog box
	[xml]$XAML = '
	<Window
		xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Name="Window"
		MinHeight="450" MinWidth="400"
		SizeToContent="Width" WindowStartupLocation="CenterScreen"
		TextOptions.TextFormattingMode="Display" SnapsToDevicePixels="True"
		FontFamily="Segoe UI" FontSize="12" ShowInTaskbar="False">
		<Window.Resources>
			<Style TargetType="StackPanel">
				<Setter Property="Orientation" Value="Horizontal"/>
			</Style>
			<Style TargetType="CheckBox">
				<Setter Property="Margin" Value="10, 10, 5, 10"/>
				<Setter Property="IsChecked" Value="True"/>
			</Style>
			<Style TargetType="TextBlock">
				<Setter Property="Margin" Value="5, 10, 10, 10"/>
			</Style>
			<Style TargetType="Button">
				<Setter Property="Margin" Value="20"/>
				<Setter Property="Padding" Value="10"/>
			</Style>
		</Window.Resources>
		<Grid>
			<Grid.RowDefinitions>
				<RowDefinition Height="*"/>
				<RowDefinition Height="Auto"/>
			</Grid.RowDefinitions>
			<ScrollViewer Name="Scroll" Grid.Row="0"
				HorizontalScrollBarVisibility="Disabled"
				VerticalScrollBarVisibility="Auto">
				<StackPanel Name="PanelContainer" Orientation="Vertical"/>
			</ScrollViewer>
			<Button Name="Button" Grid.Row="1"/>
		</Grid>
	</Window>
	'
	#endregion XAML Markup

	$Reader = (New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $XAML)
	$Form = [Windows.Markup.XamlReader]::Load($Reader)
	$XAML.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object -Process {
		Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)
	}

	#region Functions
	function InternetConnectionStatus
	{
		try
		{
			(Invoke-WebRequest -Uri https://www.google.com -UseBasicParsing -DisableKeepAlive -Method Head).StatusDescription
		}
		catch [System.Net.WebException]
		{
			Write-Warning -Message $Localization.NoInternetConnection
			Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue
			return
		}
	}

	function Get-CheckboxClicked
	{
		[CmdletBinding()]
		param
		(
			[Parameter(
				Mandatory = $true,
				ValueFromPipeline = $true
			)]
			[ValidateNotNull()]
			$CheckBox
		)

		$Capability = $Capabilities | Where-Object -FilterScript {$_.DisplayName -eq $CheckBox.Parent.Children[1].Text}

		if ($CheckBox.IsChecked)
		{
			[void]$SelectedCapabilities.Add($Capability)
		}
		else
		{
			[void]$SelectedCapabilities.Remove($Capability)
		}

		if ($SelectedCapabilities.Count -gt 0)
		{
			$Button.IsEnabled = $true
		}
		else
		{
			$Button.IsEnabled = $false
		}
	}

	function UninstallButton
	{
		Write-Verbose -Message $Localization.Patient -Verbose

		[void]$Window.Close()

		$SelectedCapabilities | ForEach-Object -Process {Write-Verbose -Message $_.DisplayName -Verbose}
		$SelectedCapabilities | Where-Object -FilterScript {$_.Name -in (Get-WindowsCapability -Online).Name} | Remove-WindowsCapability -Online

		if ([string]$SelectedCapabilities.Name -match "Browser.InternetExplorer")
		{
			Write-Warning -Message $Localization.RestartWarning
		}
	}

	function InstallButton
	{
		Write-Verbose -Message $Localization.Patient -Verbose

		[void]$Window.Close()

		$SelectedCapabilities | ForEach-Object -Process {Write-Verbose -Message $_.DisplayName -Verbose}
		$SelectedCapabilities | Where-Object -FilterScript {$_.Name -in ((Get-WindowsCapability -Online).Name)} | Add-WindowsCapability -Online

		if ([string]$SelectedCapabilities.Name -match "Browser.InternetExplorer")
		{
			Write-Warning -Message $Localization.RestartWarning
		}
	}

	function Add-CapabilityControl
	{
		[CmdletBinding()]
		param
		(
			[Parameter(
				Mandatory = $true,
				ValueFromPipeline = $true
			)]
			[ValidateNotNull()]
			$Capability
		)

		process
		{
			$CheckBox = New-Object -TypeName System.Windows.Controls.CheckBox
			$CheckBox.Add_Click({Get-CheckboxClicked -CheckBox $_.Source})
			$CheckBox.ToolTip = $Capability.Description

			$TextBlock = New-Object -TypeName System.Windows.Controls.TextBlock
			$TextBlock.Text = $Capability.DisplayName
			$TextBlock.ToolTip = $Capability.Description

			$StackPanel = New-Object -TypeName System.Windows.Controls.StackPanel
			[void]$StackPanel.Children.Add($CheckBox)
			[void]$StackPanel.Children.Add($TextBlock)
			[void]$PanelContainer.Children.Add($StackPanel)

			# If capability checked add to the array list
			if ($UnCheckedCapabilities | Where-Object -FilterScript {$Capability.Name -like $_})
			{
				$CheckBox.IsChecked = $false
				# Exit function if item is not checked
				return
			}

			# If capability checked add to the array list
			[void]$SelectedCapabilities.Add($Capability)
		}
	}
	#endregion Functions

	switch ($PSCmdlet.ParameterSetName)
	{
		"Install"
		{
			InternetConnectionStatus

			$State = "NotPresent"
			$ButtonContent = $Localization.Install
			$ButtonAdd_Click = {InstallButton}
		}
		"Uninstall"
		{
			$State = "Installed"
			$ButtonContent = $Localization.Uninstall
			$ButtonAdd_Click = {UninstallButton}
		}
	}

	Write-Verbose -Message $Localization.Patient -Verbose

	# Getting list of all capabilities according to the conditions
	$OFS = "|"
	$Capabilities = Get-WindowsCapability -Online | Where-Object -FilterScript {
		($_.State -eq $State) -and (($_.Name -match $UncheckedCapabilities) -or ($_.Name -match $CheckedCapabilities) -and ($_.Name -notmatch $ExcludedCapabilities))
	} | ForEach-Object -Process {Get-WindowsCapability -Name $_.Name -Online}
	$OFS = " "

	if (-not ($Capabilities))
	{
		Write-Verbose -Message $Localization.NoData -Verbose
		return
	}

	Write-Verbose -Message $Localization.DialogBoxOpening -Verbose

	$Window.Add_Loaded({$Capabilities | Add-CapabilityControl})
	$Button.Content = $ButtonContent
	$Button.Add_Click({& $ButtonAdd_Click})

	$Window.Title = $Localization.OptionalFeaturesTitle
	$Form.ShowDialog() | Out-Null
}

<#
	.SYNOPSIS
	Configure receiving updates for other Microsoft products when you update Windows

	.PARAMETER Disable
	Do not receive updates for other Microsoft products when you update Windows

	.PARAMETER Enable
	Receive updates for other Microsoft products when you update Windows

	.EXAMPLE
	UpdateMicrosoftProducts -Disable

	.EXAMPLE
	UpdateMicrosoftProducts -Enable

	.NOTES
	Current user
#>
function UpdateMicrosoftProducts
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			if ((New-Object -ComObject Microsoft.Update.ServiceManager).Services | Where-Object -FilterScript {$_.ServiceID -eq "7971f918-a847-4430-9279-4a52d1efe18d"})
			{
				(New-Object -ComObject Microsoft.Update.ServiceManager).RemoveService("7971f918-a847-4430-9279-4a52d1efe18d")
			}
		}
		"Enable"
		{
			(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "")
		}
	}
}

<#
	.SYNOPSIS
	Configure the power management scheme

	.PARAMETER High
	Set the power management scheme on "High performance"

	.PARAMETER Balanced
	Set the power management scheme on "Balanced"

	.EXAMPLE
	PowerManagementScheme -High

	.EXAMPLE
	PowerManagementScheme -Balanced

	.NOTES
	Do not recommend turning "High performance" scheme on on laptops
	Current user
#>
function PowerManagementScheme
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "High"
		)]
		[switch]
		$High,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Balanced"
		)]
		[switch]
		$Balanced
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"High"
		{
			POWERCFG /SETACTIVE SCHEME_MIN
		}
		"Balanced"
		{
			POWERCFG /SETACTIVE SCHEME_BALANCED
		}
	}
}

<#
	.SYNOPSIS
	Configure the latest installed .NET runtime for all apps usage

	.PARAMETER Disable
	Do not use latest installed .NET runtime for all apps

	.PARAMETER Enable
	Use use latest installed .NET runtime for all apps

	.EXAMPLE
	LatestInstalled.NET -Disable

	.EXAMPLE
	LatestInstalled.NET -Enable

	.NOTES
	Machine-wide
#>
function LatestInstalled.NET
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\.NETFramework -Name OnlyUseLatestCLR -Force -ErrorAction SilentlyContinue
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework -Name OnlyUseLatestCLR -Force -ErrorAction SilentlyContinue
		}
		"Enable"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\.NETFramework -Name OnlyUseLatestCLR -PropertyType DWord -Value 1 -Force
			New-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework -Name OnlyUseLatestCLR -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure network adapters to save power

	.PARAMETER Disable
	Do not allow the computer to turn off the network adapters to save power

	.PARAMETER Enable
	Allow the computer to turn off the network adapters to save power

	.EXAMPLE
	PCTurnOffDevice -Disable

	.EXAMPLE
	PCTurnOffDevice -Enable

	.NOTES
	Do not recommend turning it on on laptops

	.NOTES
	Current user
#>
function PCTurnOffDevice
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	$Adapters = Get-NetAdapter -Physical | Get-NetAdapterPowerManagement | Where-Object -FilterScript {$_.AllowComputerToTurnOffDevice -ne "Unsupported"}

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			foreach ($Adapter in $Adapters)
			{
				$Adapter.AllowComputerToTurnOffDevice = "Disabled"
				$Adapter | Set-NetAdapterPowerManagement
			}
		}
		"Enable"
		{
			foreach ($Adapter in $Adapters)
			{
				$Adapter.AllowComputerToTurnOffDevice = "Enabled"
				$Adapter | Set-NetAdapterPowerManagement
			}
		}
	}
}

<#
	.SYNOPSIS
	Configure override for default input method

	.PARAMETER English
	Override for default input method: English

	.PARAMETER Default
	Override for default input method: use langiage list

	.EXAMPLE
	SetInputMethod -English

	.EXAMPLE
	SetInputMethod -Default

	.NOTES
	Current user
#>
function SetInputMethod
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "English"
		)]
		[switch]
		$English,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Default"
		)]
		[switch]
		$Default
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"English"
		{
			Set-WinDefaultInputMethodOverride -InputTip "0409:00000409"
		}
		"Default"
		{
			Remove-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name InputMethodOverride -Force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.SYNOPSIS
	Configure user folders location

	.PARAMETER Root
	Move user folders location to the root of any drive using the interactive menu

	.PARAMETER Custom
	Select folders for user folders location manually using a folder browser dialog

	.PARAMETER Default
	Change user folders location to the default values

	.EXAMPLE
	SetUserShellFolderLocation -Root

	.EXAMPLE
	SetUserShellFolderLocation -Custom

	.EXAMPLE
	SetUserShellFolderLocation -Default

	.NOTES
	User files or folders won't me moved to a new location
	Current user
#>
function SetUserShellFolderLocation
{

	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Root"
		)]
		[switch]
		$Root,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Custom"
		)]
		[switch]
		$Custom,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Default"
		)]
		[switch]
		$Default
	)

	<#
		.SYNOPSIS
		Change the location of the each user folder using SHSetKnownFolderPath function

		.PARAMETER RemoveDesktopINI
		The RemoveDesktopINI argument removes desktop.ini in the old user shell folder

		.EXAMPLE
		UserShellFolder -UserFolder Desktop -FolderPath "$env:SystemDrive:\Desktop" -RemoveDesktopINI

		.LINK
		https://docs.microsoft.com/en-us/windows/win32/api/shlobj_core/nf-shlobj_core-shgetknownfolderpath

		.NOTES
		User files or folders won't me moved to a new location
	#>
	function UserShellFolder
	{
		[CmdletBinding()]
		param
		(
			[Parameter(Mandatory = $true)]
			[ValidateSet("Desktop", "Documents", "Downloads", "Music", "Pictures", "Videos")]
			[string]
			$UserFolder,

			[Parameter(Mandatory = $true)]
			[string]
			$FolderPath,

			[Parameter(Mandatory = $false)]
			[switch]
			$RemoveDesktopINI
		)

		<#
			.SYNOPSIS
			Redirect user folders to a new location

			.EXAMPLE
			KnownFolderPath -KnownFolder Desktop -Path "$env:SystemDrive:\Desktop"
		#>
		function KnownFolderPath
		{
			[CmdletBinding()]
			param
			(
				[Parameter(Mandatory = $true)]
				[ValidateSet("Desktop", "Documents", "Downloads", "Music", "Pictures", "Videos")]
				[string]
				$KnownFolder,

				[Parameter(Mandatory = $true)]
				[string]
				$Path
			)

			$KnownFolders = @{
				"Desktop"	= @("B4BFCC3A-DB2C-424C-B029-7FE99A87C641");
				"Documents"	= @("FDD39AD0-238F-46AF-ADB4-6C85480369C7", "f42ee2d3-909f-4907-8871-4c22fc0bf756");
				"Downloads"	= @("374DE290-123F-4565-9164-39C4925E467B", "7d83ee9b-2244-4e70-b1f5-5393042af1e4");
				"Music"		= @("4BD8D571-6D19-48D3-BE97-422220080E43", "a0c69a99-21c8-4671-8703-7934162fcf1d");
				"Pictures"	= @("33E28130-4E1E-4676-835A-98395C3BC3BB", "0ddd015d-b06c-45d5-8c4c-f59713854639");
				"Videos"	= @("18989B1D-99B5-455B-841C-AB7C74E4DDFC", "35286a68-3c57-41a1-bbb1-0eae73d76c95");
			}

			$Signature = @{
				Namespace = "WinAPI"
				Name = "KnownFolders"
				Language = "CSharp"
				MemberDefinition = @"
[DllImport("shell32.dll")]
public extern static int SHSetKnownFolderPath(ref Guid folderId, uint flags, IntPtr token, [MarshalAs(UnmanagedType.LPWStr)] string path);
"@
			}
			if (-not ("WinAPI.KnownFolders" -as [type]))
			{
				Add-Type @Signature
			}

			foreach ($guid in $KnownFolders[$KnownFolder])
			{
				[WinAPI.KnownFolders]::SHSetKnownFolderPath([ref]$guid, 0, 0, $Path)
			}
			(Get-Item -Path $Path -Force).Attributes = "ReadOnly"
		}

		$UserShellFoldersRegName = @{
			"Desktop"	=	"Desktop"
			"Documents"	=	"Personal"
			"Downloads"	=	"{374DE290-123F-4565-9164-39C4925E467B}"
			"Music"		=	"My Music"
			"Pictures"	=	"My Pictures"
			"Videos"	=	"My Video"
		}

		$UserShellFoldersGUID = @{
			"Desktop"	=	"{754AC886-DF64-4CBA-86B5-F7FBF4FBCEF5}"
			"Documents"	=	"{F42EE2D3-909F-4907-8871-4C22FC0BF756}"
			"Downloads"	=	"{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}"
			"Music"		=	"{A0C69A99-21C8-4671-8703-7934162FCF1D}"
			"Pictures"	=	"{0DDD015D-B06C-45D5-8C4C-F59713854639}"
			"Videos"	=	"{35286A68-3C57-41A1-BBB1-0EAE73D76C95}"
		}

		# Contents of the hidden desktop.ini file for each type of user folders
		$DesktopINI = @{
			"Desktop"	=	"",
							"[.ShellClassInfo]",
							"LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21769",
							"IconResource=%SystemRoot%\system32\imageres.dll,-183"
			"Documents"	=	"",
							"[.ShellClassInfo]",
							"LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21770",
							"IconResource=%SystemRoot%\system32\imageres.dll,-112",
							"IconFile=%SystemRoot%\system32\shell32.dll",
							"IconIndex=-235"
			"Downloads"	=	"",
							"[.ShellClassInfo]","LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21798",
							"IconResource=%SystemRoot%\system32\imageres.dll,-184"
			"Music"		=	"",
							"[.ShellClassInfo]","LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21790",
							"InfoTip=@%SystemRoot%\system32\shell32.dll,-12689",
							"IconResource=%SystemRoot%\system32\imageres.dll,-108",
							"IconFile=%SystemRoot%\system32\shell32.dll","IconIndex=-237"
			"Pictures"	=	"",
							"[.ShellClassInfo]",
							"LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21779",
							"InfoTip=@%SystemRoot%\system32\shell32.dll,-12688",
							"IconResource=%SystemRoot%\system32\imageres.dll,-113",
							"IconFile=%SystemRoot%\system32\shell32.dll",
							"IconIndex=-236"
			"Videos"	=	"",
							"[.ShellClassInfo]",
							"LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21791",
							"InfoTip=@%SystemRoot%\system32\shell32.dll,-12690",
							"IconResource=%SystemRoot%\system32\imageres.dll,-189",
							"IconFile=%SystemRoot%\system32\shell32.dll","IconIndex=-238"
		}

		# Determining the current user folder path
		$UserShellFolderRegValue = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name $UserShellFoldersRegName[$UserFolder]
		if ($UserShellFolderRegValue -ne $FolderPath)
		{
			if ((Get-ChildItem -Path $UserShellFolderRegValue | Measure-Object).Count -ne 0)
			{
				Write-Error -Message ($Localization.UserShellFolderNotEmpty -f $UserShellFolderRegValue) -ErrorAction SilentlyContinue
			}

			# Creating a new folder if there is no one
			if (-not (Test-Path -Path $FolderPath))
			{
				New-Item -Path $FolderPath -ItemType Directory -Force
			}

			# Removing old desktop.ini
			if ($RemoveDesktopINI.IsPresent)
			{
				Remove-Item -Path "$UserShellFolderRegValue\desktop.ini" -Force
			}

			KnownFolderPath -KnownFolder $UserFolder -Path $FolderPath
			New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name $UserShellFoldersGUID[$UserFolder] -PropertyType ExpandString -Value $FolderPath -Force

			Set-Content -Path "$FolderPath\desktop.ini" -Value $DesktopINI[$UserFolder] -Encoding Unicode -Force
			(Get-Item -Path "$FolderPath\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$FolderPath\desktop.ini" -Force).Refresh()
		}
	}

	<#
		.SYNOPSIS
		The "Show menu" function with the up/down arrow keys and enter key to make a selection

		.EXAMPLE
		ShowMenu -Menu $ListOfItems -Default $DefaultChoice

		.LINK
		https://qna.habr.com/answer?answer_id=1522379
	#>
	function ShowMenu
	{
		[CmdletBinding()]
		param
		(
			[Parameter()]
			[string]
			$Title,

			[Parameter(Mandatory = $true)]
			[array]
			$Menu,

			[Parameter(Mandatory = $true)]
			[int]
			$Default
		)

		Write-Information -MessageData $Title -InformationAction Continue

		$minY = [Console]::CursorTop
		$y = [Math]::Max([Math]::Min($Default, $Menu.Count), 0)
		do
		{
			[Console]::CursorTop = $minY
			[Console]::CursorLeft = 0
			$i = 0
			foreach ($item in $Menu)
			{
				if ($i -ne $y)
				{
					Write-Information -MessageData ('  {0}. {1}  ' -f ($i+1), $item) -InformationAction Continue
				}
				else
				{
					Write-Information -MessageData ('[ {0}. {1} ]' -f ($i+1), $item) -InformationAction Continue
				}
				$i++
			}

			$k = [Console]::ReadKey()
			switch ($k.Key)
			{
				"UpArrow"
				{
					if ($y -gt 0)
					{
						$y--
					}
				}
				"DownArrow"
				{
					if ($y -lt ($Menu.Count - 1))
					{
						$y++
					}
				}
				"Enter"
				{
					return $Menu[$y]
				}
			}
		}
		while ($k.Key -notin ([ConsoleKey]::Escape, [ConsoleKey]::Enter))
	}

	$Signature = @{
	Namespace = "WinAPI"
	Name = "GetStr"
	Language = "CSharp"
	MemberDefinition = @"
[DllImport("kernel32.dll", CharSet = CharSet.Auto)]
public static extern IntPtr GetModuleHandle(string lpModuleName);
[DllImport("user32.dll", CharSet = CharSet.Auto)]
internal static extern int LoadString(IntPtr hInstance, uint uID, StringBuilder lpBuffer, int nBufferMax);
public static string GetString(uint strId)
{
	IntPtr intPtr = GetModuleHandle("shell32.dll");
	StringBuilder sb = new StringBuilder(255);
	LoadString(intPtr, strId, sb, sb.Capacity);
	return sb.ToString();
}
"@
	}
	if (-not ("WinAPI.GetStr" -as [type]))
	{
		Add-Type @Signature -Using System.Text
	}

	$DesktopLocalizedString = [WinAPI.GetStr]::GetString(21769)
	$DocumentsLocalizedString = [WinAPI.GetStr]::GetString(21770)
	$DownloadsLocalizedString = [WinAPI.GetStr]::GetString(21798)
	$MusicLocalizedString = [WinAPI.GetStr]::GetString(21790)
	$PicturesLocalizedString = [WinAPI.GetStr]::GetString(21779)
	$VideosLocalizedString = [WinAPI.GetStr]::GetString(21791)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Root"
		{
			Write-Verbose -Message $Localization.RetrievingDrivesList -Verbose

			# Store all drives letters to use them within ShowMenu function
			$DriveLetters = @((Get-Disk | Where-Object -FilterScript {$_.BusType -ne "USB"} | Get-Partition | Get-Volume | Where-Object -FilterScript {$null -ne $_.DriveLetter}).DriveLetter | Sort-Object)

			# If the number of disks is more than one, set the second drive in the list as default drive
			if ($DriveLetters.Count -gt 1)
			{
				$Script:Default = 1
			}
			else
			{
				$Script:Default = 0
			}

			# Desktop
			Write-Verbose -Message ($Localization.DriveSelect -f $DesktopLocalizedString) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.UserFolderRequest -f $DesktopLocalizedString
			$Change = $Localization.Change
			$Skip = $Localization.Skip
			$Options = "&$Change", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					$SelectedDrive = ShowMenu -Title ($Localization.DriveSelect -f $DesktopLocalizedString) -Menu $DriveLetters -Default $Script:Default
					UserShellFolder -UserFolder Desktop -FolderPath "${SelectedDrive}:\Desktop" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Documents
			Write-Verbose -Message ($Localization.DriveSelect -f $DocumentsLocalizedString) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.UserFolderRequest -f $DocumentsLocalizedString
			$Change = $Localization.Change
			$Skip = $Localization.Skip
			$Options = "&$Change", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					$SelectedDrive = ShowMenu -Title ($Localization.DriveSelect -f $DocumentsLocalizedString) -Menu $DriveLetters -Default $Script:Default
					UserShellFolder -UserFolder Documents -FolderPath "${SelectedDrive}:\Documents" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Downloads
			Write-Verbose -Message ($Localization.DriveSelect -f $DownloadsLocalizedString) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.UserFolderRequest -f $DownloadsLocalizedString
			$Change = $Localization.Change
			$Skip = $Localization.Skip
			$Options = "&$Change", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					$SelectedDrive = ShowMenu -Title ($Localization.DriveSelect -f $DownloadsLocalizedString) -Menu $DriveLetters -Default $Script:Default
					UserShellFolder -UserFolder Downloads -FolderPath "${SelectedDrive}:\Downloads" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Music
			Write-Verbose -Message ($Localization.DriveSelect -f $MusicLocalizedString) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.UserFolderRequest -f $MusicLocalizedString
			$Change = $Localization.Change
			$Skip = $Localization.Skip
			$Options = "&$Change", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					$SelectedDrive = ShowMenu -Title ($Localization.DriveSelect -f $MusicLocalizedString) -Menu $DriveLetters -Default $Script:Default
					UserShellFolder -UserFolder Music -FolderPath "${SelectedDrive}:\Music" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Pictures
			Write-Verbose -Message ($Localization.DriveSelect -f $PicturesLocalizedString) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.UserFolderRequest -f $PicturesLocalizedString
			$Change = $Localization.Change
			$Skip = $Localization.Skip
			$Options = "&$Change", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					$SelectedDrive = ShowMenu -Title ($Localization.DriveSelect -f $PicturesLocalizedString) -Menu $DriveLetters -Default $Script:Default
					UserShellFolder -UserFolder Pictures -FolderPath "${SelectedDrive}:\Pictures" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Videos
			Write-Verbose -Message ($Localization.DriveSelect -f $VideosLocalizedString) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.UserFolderRequest -f $VideosLocalizedString
			$Change = $Localization.Change
			$Skip = $Localization.Skip
			$Options = "&$Change", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					$SelectedDrive = ShowMenu -Title ($Localization.DriveSelect -f $VideosLocalizedString) -Menu $DriveLetters -Default $Script:Default
					UserShellFolder -UserFolder Videos -FolderPath "${SelectedDrive}:\Videos" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}
		}
		"Custom"
		{
			# Desktop
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.UserFolderSelect -f $DesktopLocalizedString
			$Select = $Localization.Select
			$Skip = $Localization.Skip
			$Options = "&$Select", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					Add-Type -AssemblyName System.Windows.Forms
					$FolderBrowserDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
					$FolderBrowserDialog.Description = $Localization.FolderSelect
					$FolderBrowserDialog.RootFolder = "MyComputer"

					# Focus on open file dialog
					$Focus = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
					$FolderBrowserDialog.ShowDialog($Focus)

					if ($FolderBrowserDialog.SelectedPath)
					{
						UserShellFolder -UserFolder Desktop -FolderPath $FolderBrowserDialog.SelectedPath -RemoveDesktopINI
						Write-Verbose -Message ($Localization.NewUserFolderLocation -f $FolderBrowserDialog.SelectedPath) -Verbose
					}
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Documents
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.UserFolderSelect -f $DocumentsLocalizedString
			$Select = $Localization.Select
			$Skip = $Localization.Skip
			$Options = "&$Select", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					Add-Type -AssemblyName System.Windows.Forms
					$FolderBrowserDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
					$FolderBrowserDialog.Description = $Localization.FolderSelect
					$FolderBrowserDialog.RootFolder = "MyComputer"

					# Focus on open file dialog
					$Focus = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
					$FolderBrowserDialog.ShowDialog($Focus)

					if ($FolderBrowserDialog.SelectedPath)
					{
						UserShellFolder -UserFolder Documents -FolderPath $FolderBrowserDialog.SelectedPath -RemoveDesktopINI
						Write-Verbose -Message ($Localization.NewUserFolderLocation -f $FolderBrowserDialog.SelectedPath) -Verbose
					}
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Downloads
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.UserFolderSelect -f $DownloadsLocalizedString
			$Select = $Localization.Select
			$Skip = $Localization.Skip
			$Options = "&$Select", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					Add-Type -AssemblyName System.Windows.Forms
					$FolderBrowserDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
					$FolderBrowserDialog.Description = $Localization.FolderSelect
					$FolderBrowserDialog.RootFolder = "MyComputer"

					# Focus on open file dialog
					$Focus = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
					$FolderBrowserDialog.ShowDialog($Focus)

					if ($FolderBrowserDialog.SelectedPath)
					{
						UserShellFolder -UserFolder Downloads -FolderPath $FolderBrowserDialog.SelectedPath -RemoveDesktopINI
						Write-Verbose -Message ($Localization.NewUserFolderLocation -f $FolderBrowserDialog.SelectedPath) -Verbose
					}
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Music
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.UserFolderSelect -f $MusicLocalizedString
			$Select = $Localization.Select
			$Skip = $Localization.Skip
			$Options = "&$Select", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					Add-Type -AssemblyName System.Windows.Forms
					$FolderBrowserDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
					$FolderBrowserDialog.Description = $Localization.FolderSelect
					$FolderBrowserDialog.RootFolder = "MyComputer"

					# Focus on open file dialog
					$Focus = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
					$FolderBrowserDialog.ShowDialog($Focus)

					if ($FolderBrowserDialog.SelectedPath)
					{
						UserShellFolder -UserFolder Music -FolderPath $FolderBrowserDialog.SelectedPath -RemoveDesktopINI
						Write-Verbose -Message ($Localization.NewUserFolderLocation -f $FolderBrowserDialog.SelectedPath) -Verbose
					}
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Pictures
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.UserFolderSelect -f $PicturesLocalizedString
			$Select = $Localization.Select
			$Skip = $Localization.Skip
			$Options = "&$Select", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					Add-Type -AssemblyName System.Windows.Forms
					$FolderBrowserDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
					$FolderBrowserDialog.Description = $Localization.FolderSelect
					$FolderBrowserDialog.RootFolder = "MyComputer"

					# Focus on open file dialog
					$Focus = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
					$FolderBrowserDialog.ShowDialog($Focus)

					if ($FolderBrowserDialog.SelectedPath)
					{
						UserShellFolder -UserFolder Pictures -FolderPath $FolderBrowserDialog.SelectedPath -RemoveDesktopINI
						Write-Verbose -Message ($Localization.NewUserFolderLocation -f $FolderBrowserDialog.SelectedPath) -Verbose
					}
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Videos
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.UserFolderSelect -f $VideosLocalizedString
			$Select = $Localization.Select
			$Skip = $Localization.Skip
			$Options = "&$Select", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					Add-Type -AssemblyName System.Windows.Forms
					$FolderBrowserDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
					$FolderBrowserDialog.Description = $Localization.FolderSelect
					$FolderBrowserDialog.RootFolder = "MyComputer"

					# Focus on open file dialog
					$Focus = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
					$FolderBrowserDialog.ShowDialog($Focus)

					if ($FolderBrowserDialog.SelectedPath)
					{
						UserShellFolder -UserFolder Videos -FolderPath $FolderBrowserDialog.SelectedPath -RemoveDesktopINI
						Write-Verbose -Message ($Localization.NewUserFolderLocation -f $FolderBrowserDialog.SelectedPath) -Verbose
					}
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}
		}
		"Default"
		{
			# Desktop
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.UserDefaultFolder -f $DesktopLocalizedString
			$Change = $Localization.Change
			$Skip = $Localization.Skip
			$Options = "&$Change", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					UserShellFolder -UserFolder Desktop -FolderPath "$env:USERPROFILE\Desktop" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Documents
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.UserDefaultFolder -f $DocumentsLocalizedString
			$Change = $Localization.Change
			$Skip = $Localization.Skip
			$Options = "&$Change", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					UserShellFolder -UserFolder Documents -FolderPath "$env:USERPROFILE\Documents" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Downloads
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.UserDefaultFolder -f $DownloadsLocalizedString
			$Change = $Localization.Change
			$Skip = $Localization.Skip
			$Options = "&$Change", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					UserShellFolder -UserFolder Downloads -FolderPath "$env:USERPROFILE\Downloads" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Music
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.UserDefaultFolder -f $MusicLocalizedString
			$Change = $Localization.Change
			$Skip = $Localization.Skip
			$Options = "&$Change", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					UserShellFolder -UserFolder Music -FolderPath "$env:USERPROFILE\Music" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Pictures
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.UserDefaultFolder -f $PicturesLocalizedString
			$Change = $Localization.Change
			$Skip = $Localization.Skip
			$Options = "&$Change", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					UserShellFolder -UserFolder Pictures -FolderPath "$env:USERPROFILE\Pictures" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Videos
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.UserDefaultFolder -f $VideosLocalizedString
			$Change = $Localization.Change
			$Skip = $Localization.Skip
			$Options = "&$Change", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					UserShellFolder -UserFolder Videos -FolderPath "$env:USERPROFILE\Videos" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}
		}
	}
}

<#
	.SYNOPSIS
	Choose where to save screenshots by pressing Win+PrtScr

	.PARAMETER Desktop
	Save screenshots by pressing Win+PrtScr on the Desktop

	.PARAMETER Default
	Save screenshots by pressing Win+PrtScr in the Pictures folder

	.EXAMPLE
	WinPrtScrFolder -Desktop

	.EXAMPLE
	WinPrtScrFolder -Default

	.NOTES
	Current user
#>
function WinPrtScrFolder
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Desktop"
		)]
		[switch]
		$Desktop,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Default"
		)]
		[switch]
		$Default
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Desktop"
		{
			$DesktopFolder = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Desktop
			Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{B7BEDE81-DF94-4682-A7D8-57A52620B86F}" -Type ExpandString -Value $DesktopFolder -Force
		}
		"Default"
		{
			Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{B7BEDE81-DF94-4682-A7D8-57A52620B86F}" -Force -ErrorAction SilentlyContinue
		}
	}

	# Save all opened folders in order to restore them after File Explorer restart
	Clear-Variable -Name OpenedFolders -Force -ErrorAction Ignore
	$OpenedFolders = {(New-Object -ComObject Shell.Application).Windows() | ForEach-Object -Process {$_.Document.Folder.Self.Path}}.Invoke()

	# In order for the changes to take effect the File Explorer process has to be restarted
	Stop-Process -Name explorer -Force

	Start-Sleep -Seconds 3

	# Restoring closed folders
	foreach ($OpenedFolder in $OpenedFolders)
	{
		if (Test-Path -Path $OpenedFolder)
		{
			Invoke-Item -Path $OpenedFolder
		}
	}
}

<#
	.SYNOPSIS
	Configure recommended troubleshooting

	.PARAMETER Automatic
	Run troubleshooters automatically, then notify

	.PARAMETER Default
	Ask me before running troubleshooters

	.EXAMPLE
	RecommendedTroubleshooting -Automatic

	.EXAMPLE
	RecommendedTroubleshooting -Default

	.NOTES
	Machine-wide
	In order this feature to work the OS level of diagnostic data gathering will be set to "Optional diagnostic data" and the error reporting feature will be turned on
#>
function RecommendedTroubleshooting
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Automatic"
		)]
		[switch]
		$Automatic,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Default"
		)]
		[switch]
		$Default
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Automatic"
		{
			if (-not (Test-Path -Path HKLM:\SOFTWARE\Microsoft\WindowsMitigation))
			{
				New-Item -Path HKLM:\SOFTWARE\Microsoft\WindowsMitigation -Force
			}
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsMitigation -Name UserPreference -PropertyType DWord -Value 3 -Force
		}
		"Default"
		{
			if (-not (Test-Path -Path HKLM:\SOFTWARE\Microsoft\WindowsMitigation))
			{
				New-Item -Path HKLM:\SOFTWARE\Microsoft\WindowsMitigation -Force
			}
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsMitigation -Name UserPreference -PropertyType DWord -Value 2 -Force
		}
	}

	# Set the OS level of diagnostic data gathering to "Optional diagnostic data"
	New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 3 -Force
	New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name MaxTelemetryAllowed -PropertyType DWord -Value 3 -Force

	New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack -Name ShowedToastAtLevel -PropertyType DWord -Value 3 -Force

	# Turn on Windows Error Reporting
	Get-ScheduledTask -TaskName QueueReporting | Enable-ScheduledTask
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name Disabled -Force -ErrorAction SilentlyContinue

	Get-Service -Name WerSvc | Set-Service -StartupType Manual
	Get-Service -Name WerSvc | Start-Service
}

<#
	.SYNOPSIS
	Configure folder windows launching in a separate process

	.PARAMETER Enable
	Launch launch folder windows in a separate process

	.PARAMETER Disable
	Do not launch folder windows in a separate process

	.EXAMPLE
	FoldersLaunchSeparateProcess -Enable

	.EXAMPLE
	FoldersLaunchSeparateProcess -Disable

	.NOTES
	Current user
#>
function FoldersLaunchSeparateProcess
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SeparateProcess -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SeparateProcess -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure reserved storage after the next update installation

	.PARAMETER Enable
	Enable reserved storage after the next update installation

	.PARAMETER Disable
	Disable and delete reserved storage after the next update installation

	.EXAMPLE
	ReservedStorage -Enable

	.EXAMPLE
	ReservedStorage -Disable

	.NOTES
	Current user
#>
function ReservedStorage
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			Set-WindowsReservedStorageState -State Enabled
		}
		"Disable"
		{
			try
			{
				Set-WindowsReservedStorageState -State Disabled
			}
			catch [System.Runtime.InteropServices.COMException]
			{
				Write-Error -Message $Localization.ReservedStorageIsInUse -ErrorAction SilentlyContinue
			}
		}
	}
}

<#
	.SYNOPSIS
	Configure help look up via F1

	.PARAMETER Enable
	Enable help lookup via F1

	.PARAMETER Disable
	Disable help lookup via F1

	.EXAMPLE
	F1HelpPage -Enable

	.EXAMPLE
	F1HelpPage -Disable

	.NOTES
	Current user
#>
function F1HelpPage
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			Remove-Item -Path "HKCU:\SOFTWARE\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}" -Recurse -Force -ErrorAction SilentlyContinue
		}
		"Disable"
		{
			if (-not (Test-Path -Path "HKCU:\SOFTWARE\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64"))
			{
				New-Item -Path "HKCU:\SOFTWARE\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64" -Force
			}
			New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64" -Name "(default)" -PropertyType String -Value "" -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure Num Lock at startup

	.PARAMETER Enable
	Enable Num Lock at startup

	.PARAMETER Disable
	Disable Num Lock at startup

	.EXAMPLE
	NumLock -Enable

	.EXAMPLE
	NumLock -Disable

	.NOTES
	Current user
#>
function NumLock
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483650 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path "Registry::HKEY_USERS\.DEFAULT\Control Panel\Keyboard" -Name InitialKeyboardIndicators -PropertyType String -Value 2147483648 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure Caps Lock

	.PARAMETER Enable
	Enable Capsm Lock

	.PARAMETER Disable
	Disable Caps Lock

	.EXAMPLE
	CapsLock -Enable

	.EXAMPLE
	CapsLock -Disable

	.NOTES
	Machine-wide
#>
function CapsLock
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout" -Name "Scancode Map" -Force
		}
		"Disable"
		{
			New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout" -Name "Scancode Map" -PropertyType Binary -Value ([byte[]](0,0,0,0,0,0,0,0,2,0,0,0,0,0,58,0,0,0,0,0)) -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure Sticky Keys

	.PARAMETER Enable
	Enable Sticky Keys after tapping the Shift key 5 times

	.PARAMETER Disable
	Disable Sticky Keys after tapping the Shift key 5 times

	.EXAMPLE
	StickyShift -Enable

	.EXAMPLE
	StickyShift -Disable

	.NOTES
	Current user
#>
function StickyShift
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name Flags -PropertyType String -Value 510 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name Flags -PropertyType String -Value 506 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure AutoPlay for all media and devices

	.PARAMETER Enable
	Disable/enable AutoPlay for all media and devices

	.PARAMETER Disable
	Disable/enable AutoPlay for all media and devices

	.EXAMPLE
	Autoplay -Enable

	.EXAMPLE
	Autoplay -Disable

	.NOTES
	Current user
#>
function Autoplay
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers -Name DisableAutoplay -PropertyType DWord -Value 0 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers -Name DisableAutoplay -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure thumbnail cache removal

	.PARAMETER Enable
	Enable thumbnail cache removal

	.PARAMETER Disable
	Disable thumbnail cache removal

	.EXAMPLE
	ThumbnailCacheRemoval -Enable

	.EXAMPLE
	ThumbnailCacheRemoval -Disable

	.NOTES
	Machine-wide
#>
function ThumbnailCacheRemoval
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			New-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" -Name Autorun -PropertyType DWord -Value 3 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" -Name Autorun -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure restartable apps when signing out and restart them after signing in

	.PARAMETER Enable
	Enable automatically saving my restartable apps when signing out and restart them after signing in

	.PARAMETER Disable
	Disable automatically saving my restartable apps when signing out and restart them after signing in

	.EXAMPLE
	SaveRestartableApps -Enable

	.EXAMPLE
	SaveRestartableApps -Disable

	.NOTES
	Current user
#>
function SaveRestartableApps
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name RestartApps -Value 1 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name RestartApps -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure "Network Discovery" and "File and Printers Sharing" for workgroup networks

	.PARAMETER Enable
	Enable "Network Discovery" and "File and Printers Sharing" for workgroup networks

	.PARAMETER Disable
	Disable "Network Discovery" and "File and Printers Sharing" for workgroup networks

	.EXAMPLE
	NetworkDiscovery -Enable

	.EXAMPLE
	NetworkDiscovery -Disable

	.NOTES
	Current user
#>
function NetworkDiscovery
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	$FirewallRules = @(
		# File and printer sharing
		# Общий доступ к файлам и принтерам
		"@FirewallAPI.dll,-32752",

		# Network discovery
		# Сетевое обнаружение
		"@FirewallAPI.dll,-28502"
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			if ((Get-CimInstance -ClassName CIM_ComputerSystem).PartOfDomain -eq $false)
			{
				Set-NetFirewallRule -Group $FirewallRules -Profile Private -Enabled True

				Set-NetFirewallRule -Profile Public, Private -Name FPS-SMB-In-TCP -Enabled True
				Set-NetConnectionProfile -NetworkCategory Private
			}
		}
		"Disable"
		{
			if ((Get-CimInstance -ClassName CIM_ComputerSystem).PartOfDomain -eq $false)
			{
				Set-NetFirewallRule -Group $FirewallRules -Profile Private -Enabled False
			}
		}
	}
}

<#
	.SYNOPSIS
	Configure automatically adjusting active hours for me based on daily usage

	.PARAMETER Enable
	Enable automatically adjusting active hours for me based on daily usage

	.PARAMETER Disable
	Disable automatically adjusting active hours for me based on daily usage

	.EXAMPLE
	SmartActiveHours -Enable

	.EXAMPLE
	SmartActiveHours -Disable

	.NOTES
	Machine-wide
#>
function SmartActiveHours
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name SmartActiveHoursState -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name SmartActiveHoursState -PropertyType DWord -Value 2 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure restarting this device as soon as possible when a restart is required to install an update

	.PARAMETER Enable
	Enable restarting this device as soon as possible when a restart is required to install an update

	.PARAMETER Disable
	Disable restarting this device as soon as possible when a restart is required to install an update

	.EXAMPLE
	DeviceRestartAfterUpdate -Enable

	.EXAMPLE
	DeviceRestartAfterUpdate -Disable

	.NOTES
	Machine-wide
#>
function DeviceRestartAfterUpdate
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name IsExpedited -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name IsExpedited -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Register app, calculate hash, and set as default for specific extension without the "How do you want to open this" pop-up

	.PARAMETER ProgramPath
	Set path to the program to be associate with

	.PARAMETER Extension
	Set the extension type

	.PARAMETER Icon
	Set the path to the icon

	.EXAMPLE
	Set-Association -ProgramPath "C:\SumatraPDF.exe" -Extension .pdf -Icon "shell32.dll,100"

	.EXAMPLE
	Set-Association -ProgramPath "%ProgramFiles%\Notepad++\notepad++.exe" -Extension .txt -Icon "%ProgramFiles%\Notepad++\notepad++.exe,0"

	.LINK
	https://github.com/DanysysTeam/PS-SFTA
	https://github.com/default-username-was-already-taken/set-fileassoc
	https://forum.ru-board.com/profile.cgi?action=show&member=westlife

	.NOTES
	Machine-wide
#>
function Set-Association
{
	[CmdletBinding()]
	Param
	(
		[Parameter(
			Mandatory = $true,
			Position = 0
		)]
		[String]
		$ProgramPath,

		[Parameter(
			Mandatory = $true,
			Position = 1
		)]
		[String]
		$Extension,

		[Parameter(Mandatory = $false)]
		[String]
		$Icon
	)

	$ProgramPath = [System.Environment]::ExpandEnvironmentVariables($ProgramPath)
	$Icon = [System.Environment]::ExpandEnvironmentVariables($Icon)

	if (Test-Path -Path $ProgramPath)
	{
		# Generate ProgId
		$ProgId = (Get-Item -Path $ProgramPath).BaseName + $Extension.ToUpper()
	}

	#region functions
	$RegistryUtils = @'
using System;
using System.Runtime.InteropServices;
using System.Security.AccessControl;
using System.Text;
using Microsoft.Win32;
using FILETIME = System.Runtime.InteropServices.ComTypes.FILETIME;

namespace RegistryUtils
{
	public static class Action
	{
		[DllImport("advapi32.dll", CharSet = CharSet.Auto)]
		private static extern int RegOpenKeyEx(UIntPtr hKey, string subKey, int ulOptions, int samDesired, out UIntPtr hkResult);

		[DllImport("advapi32.dll", EntryPoint = "RegQueryInfoKey", CallingConvention = CallingConvention.Winapi, SetLastError = true)]
		private static extern int RegQueryInfoKey(UIntPtr hkey, out StringBuilder lpClass, ref uint lpcbClass, IntPtr lpReserved,
			out uint lpcSubKeys, out uint lpcbMaxSubKeyLen, out uint lpcbMaxClassLen, out uint lpcValues, out uint lpcbMaxValueNameLen,
			out uint lpcbMaxValueLen, out uint lpcbSecurityDescriptor, ref FILETIME lpftLastWriteTime);

		[DllImport("advapi32.dll", SetLastError = true)]
		private static extern int RegCloseKey(UIntPtr hKey);

		[DllImport("advapi32.dll", SetLastError=true, CharSet = CharSet.Unicode)]
		private static extern uint RegDeleteKey(UIntPtr hKey, string subKey);

		public static void DeleteKey(RegistryHive registryHive, string subkey) {
			UIntPtr hKey = UIntPtr.Zero;
			var hive = new UIntPtr(unchecked((uint)registryHive));
			RegOpenKeyEx(hive, subkey, 0, 0x20019, out hKey);
			RegDeleteKey(hive, subkey);
		}

		private static DateTime ToDateTime(FILETIME ft)
		{
			IntPtr buf = IntPtr.Zero;
			try
			{
				long[] longArray = new long[1];
				int cb = Marshal.SizeOf(ft);
				buf = Marshal.AllocHGlobal(cb);
				Marshal.StructureToPtr(ft, buf, false);
				Marshal.Copy(buf, longArray, 0, 1);
				return DateTime.FromFileTime(longArray[0]);
			}
			finally
			{
				if (buf != IntPtr.Zero) Marshal.FreeHGlobal(buf);
			}
		}

		public static DateTime? GetLastModified(RegistryHive registryHive, string subKey)
		{
			var lastModified = new FILETIME();
			var lpcbClass = new uint();
			var lpReserved = new IntPtr();
			UIntPtr key = UIntPtr.Zero;

			try
			{
				try
				{
					var hive = new UIntPtr(unchecked((uint)registryHive));
					if (RegOpenKeyEx(hive, subKey, 0, (int)RegistryRights.ReadKey, out key) != 0)
					{
						return null;
					}

					uint lpcbSubKeys;
					uint lpcbMaxKeyLen;
					uint lpcbMaxClassLen;
					uint lpcValues;
					uint maxValueName;
					uint maxValueLen;
					uint securityDescriptor;
					StringBuilder sb;

					if (RegQueryInfoKey(key, out sb, ref lpcbClass, lpReserved, out lpcbSubKeys, out lpcbMaxKeyLen, out lpcbMaxClassLen, out lpcValues, out maxValueName, out maxValueLen, out securityDescriptor, ref lastModified) != 0)
					{
						return null;
					}

					var result = ToDateTime(lastModified);
					return result;
				}
				finally
				{
					if (key != UIntPtr.Zero)
					{
						RegCloseKey(key);
					}
				}
			}
			catch (Exception)
			{
				return null;
			}
		}
	}
}
'@

	if (-not('RegistryUtils.Action' -as [type]))
	{
		Add-Type -TypeDefinition $RegistryUtils
	}

	function Set-Icon
	{
		Param
		(
			[Parameter(
				Mandatory = $true,
				Position = 0

			)]
			[String]
			$ProgId,

			[Parameter(
				Mandatory = $true,
				Position = 1
			)]
			[String]
			$Icon
		)

		if (-not (Test-Path -Path "HKCU:\SOFTWARE\Classes\$ProgId\DefaultIcon"))
		{
			New-Item -Path "HKCU:\SOFTWARE\Classes\$ProgId\DefaultIcon" -Force
		}
		New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\$ProgId\DefaultIcon" -Name "(default)" -PropertyType String -Value $Icon -Force
	}

	function Remove-UserChoiceKey
	{
		Param
		(
			[Parameter(
				Mandatory = $true,
				Position = 0
			)]
			[string]
			$SubKey
		)

		[RegistryUtils.Action]::DeleteKey([Microsoft.Win32.RegistryHive]::CurrentUser,$SubKey)
	}

	function Set-UserAccessKey
	{
		Param
		(
			[Parameter(
				Mandatory = $true,
				Position = 0
			)]
			[string]
			$SubKey
		)

		$OpenSubKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey($SubKey,'ReadWriteSubTree','TakeOwnership')

		$Acl = [System.Security.AccessControl.RegistrySecurity]::new()
		# Get current user SID
		$UserSID = (Get-CimInstance -ClassName Win32_UserAccount | Where-Object -FilterScript {$_.Name -eq $env:USERNAME}).SID
		$Acl.SetSecurityDescriptorSddlForm("O:$UserSID`G:$UserSID`D:AI(D;;DC;;;$UserSID)")
		$OpenSubKey.SetAccessControl($Acl)
		$OpenSubKey.Close()
	}

	function Write-ExtensionKeys
	{
		Param
		(
			[Parameter(
				Mandatory = $true,
				Position = 0
			)]
			[string]
			$ProgId,

			[Parameter(
				Mandatory = $true,
				Position = 1
			)]
			[String]
			$Extension
		)

		$OrigProgID = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Classes\$Extension" -Name "(default)" -ErrorAction Ignore)."(default)"

		if ($OrigProgID)
		{
			# Save possible ProgIds history with extension
			New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" -Name "$ProgID`_$Extension" -PropertyType String -Value 0 -Force
		}

		$Name = (Get-Item -Path $ProgramPath).Name + $Extension
		New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" -Name $Name -PropertyType String -Value 0 -Force

		if ("$ProgId`_$Extension" -ne $Name)
		{
			New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" -Name "$ProgId`_$Extension" -PropertyType String -Value 0 -Force
		}

		# If ProgId doesn't exist set the specified ProgId for the extansions
		if (-not $OrigProgID)
		{
			if (-not (Test-Path -Path "HKCU:\SOFTWARE\Classes\$Extension"))
			{
				New-Item -Path "HKCU:\SOFTWARE\Classes\$Extension" -Force
			}
			New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\$Extension" -Name "(default)" -PropertyType String -Value $ProgId -Force
		}

		# Set the specified ProgId in the possible options for the assignment
		if (-not (Test-Path -Path "HKCU:\SOFTWARE\Classes\$Extension\OpenWithProgids"))
		{
			New-Item -Path "HKCU:\SOFTWARE\Classes\$Extension\OpenWithProgids" -Force
		}
		New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\$Extension\OpenWithProgids" -Name $ProgId -PropertyType None -Value ([byte[]]@()) -Force

		# Set the system ProgId to the extension parameters for the File Explorer to the possible options for the assignment, and if absent set the specified ProgId
		if ($OrigProgID)
		{
			if (-not (Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\OpenWithProgids"))
			{
				New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\OpenWithProgids" -Force
			}
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\OpenWithProgids" -Name $OrigProgID -PropertyType None -Value ([byte[]]@()) -Force
		}

		if (-not (Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\OpenWithProgids"))
		{
			New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\OpenWithProgids" -Force
		}
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\OpenWithProgids" -Name $ProgID -PropertyType None -Value ([byte[]]@()) -Force

		# Removing the UserChoice key
		Remove-UserChoiceKey -SubKey "Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice"

		# Setting parameters in UserChoice. The key is being autocreated
		if (-not (Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice"))
		{
			New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice" -Force
		}
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice" -Name ProgId -PropertyType String -Value $ProgID -Force

		# Getting a hash based on the time of the section's last modification. After creating and setting the first parameter
		$ProgHash = Get-Hash -ProgId $ProgId -Extension $Extension -SubKey "Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice"

		if (-not (Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice"))
		{
			New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice" -Force
		}
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice" -Name Hash -PropertyType String -Value $ProgHash -Force

		# Setting a ban on changing the UserChoice section
		Set-UserAccessKey -SubKey "Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice"
	}

	function Write-AdditionalKeys
	{
		Param
		(
			[Parameter(
				Mandatory = $true,
				Position = 0
			)]
			[string]
			$ProgId,

			[Parameter(
				Mandatory = $true,
				Position = 1
			)]
			[string]
			$Extension
		)

		# If there is the system extension ProgId, write it to the already configured by default
		if ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Classes\$Extension" -Name "(default)" -ErrorAction Ignore)."(default)")
		{
			if (-not (Test-Path -Path Registry::HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\FileAssociations\ProgIds))
			{
				New-Item -Path Registry::HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\FileAssociations\ProgIds -Force
			}
			New-ItemProperty -Path Registry::HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\FileAssociations\ProgIds -Name "_$Extension" -PropertyType DWord -Value 1 -Force
		}

		# Setting 'NoOpenWith' for all registered the extension ProgIDs
		[psobject]$OpenSubkey = Get-Item -Path "Registry::HKEY_CLASSES_ROOT\$Extension\OpenWithProgids" -ErrorAction Ignore | Select-Object -ExpandProperty Property

		if ($OpenSubkey)
		{
			foreach ($AppxProgID in ($OpenSubkey | Where-Object -FilterScript {$_ -match "AppX"}))
			{
				# If an app is installed
				if ((Get-ItemProperty -Path "HKCU:\SOFTWARE\Classes\$AppxProgID\Shell\open" -Name PackageId).PackageId)
				{
					New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\$AppxProgID" -Name NoOpenWith -PropertyType String -Value "" -Force
				}
			}
		}

		$picture = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\KindMap" -Name $Extension -ErrorAction Ignore).$Extension
		$PBrush = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Classes\PBrush\CLSID" -Name "(default)"

		if (($picture -eq "picture") -and $PBrush)
		{
			New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" -Name "PBrush_$Extension" -PropertyType DWord -Value 0 -Force
		}
	}

	function Get-Hash
	{
		[CmdletBinding()]
		[OutputType([string])]
		Param
		(
			[Parameter(
				Mandatory = $true,
				Position = 0
			)]
			[string]
			$ProgId,

			[Parameter(
				Mandatory = $true,
				Position = 1
			)]
			[string] $Extension,

			[Parameter(
				Mandatory = $true,
				Position = 2
			)]
			[string]
			$SubKey
		)

		$PatentHash = @'
using System;

namespace FileAssoc
{
	public static class PatentHash
	{
		public static uint[] WordSwap(byte[] a, int sz, byte[] md5)
		{
			if (sz < 2 || (sz & 1) == 1) {
				throw new ArgumentException(String.Format("Invalid input size: {0}", sz), "sz");
			}

			unchecked {
				uint o1 = 0;
				uint o2 = 0;
				int ta = 0;
				int ts = sz;
				int ti = ((sz - 2) >> 1) + 1;

				uint c0 = (BitConverter.ToUInt32(md5, 0) | 1) + 0x69FB0000;
				uint c1 = (BitConverter.ToUInt32(md5, 4) | 1) + 0x13DB0000;

				for (uint i = (uint)ti; i > 0; i--) {
					uint n = BitConverter.ToUInt32(a, ta) + o1;
					ta += 8;
					ts -= 2;

					uint v1 = 0x79F8A395 * (n * c0 - 0x10FA9605 * (n >> 16)) + 0x689B6B9F * ((n * c0 - 0x10FA9605 * (n >> 16)) >> 16);
					uint v2 = 0xEA970001 * v1 - 0x3C101569 * (v1 >> 16);
					uint v3 = BitConverter.ToUInt32(a, ta - 4) + v2;
					uint v4 = v3 * c1 - 0x3CE8EC25 * (v3 >> 16);
					uint v5 = 0x59C3AF2D * v4 - 0x2232E0F1 * (v4 >> 16);

					o1 = 0x1EC90001 * v5 + 0x35BD1EC9 * (v5 >> 16);
					o2 += o1 + v2;
				}

				if (ts == 1) {
					uint n = BitConverter.ToUInt32(a, ta) + o1;

					uint v1 = n * c0 - 0x10FA9605 * (n >> 16);
					uint v2 = 0xEA970001 * (0x79F8A395 * v1 + 0x689B6B9F * (v1 >> 16)) - 0x3C101569 * ((0x79F8A395 * v1 + 0x689B6B9F * (v1 >> 16)) >> 16);
					uint v3 = v2 * c1 - 0x3CE8EC25 * (v2 >> 16);

					o1 = 0x1EC90001 * (0x59C3AF2D * v3 - 0x2232E0F1 * (v3 >> 16)) + 0x35BD1EC9 * ((0x59C3AF2D * v3 - 0x2232E0F1 * (v3 >> 16)) >> 16);
					o2 += o1 + v2;
				}

				uint[] ret = new uint[2];
				ret[0] = o1;
				ret[1] = o2;
				return ret;
			}
		}

		public static uint[] Reversible(byte[] a, int sz, byte[] md5)
		{
			if (sz < 2 || (sz & 1) == 1) {
				throw new ArgumentException(String.Format("Invalid input size: {0}", sz), "sz");
			}

			unchecked {
				uint o1 = 0;
				uint o2 = 0;
				int ta = 0;
				int ts = sz;
				int ti = ((sz - 2) >> 1) + 1;

				uint c0 = BitConverter.ToUInt32(md5, 0) | 1;
				uint c1 = BitConverter.ToUInt32(md5, 4) | 1;

				for (uint i = (uint)ti; i > 0; i--) {
					uint n = (BitConverter.ToUInt32(a, ta) + o1) * c0;
					n = 0xB1110000 * n - 0x30674EEF * (n >> 16);
					ta += 8;
					ts -= 2;

					uint v1 = 0x5B9F0000 * n - 0x78F7A461 * (n >> 16);
					uint v2 = 0x1D830000 * (0x12CEB96D * (v1 >> 16) - 0x46930000 * v1) + 0x257E1D83 * ((0x12CEB96D * (v1 >> 16) - 0x46930000 * v1) >> 16);
					uint v3 = BitConverter.ToUInt32(a, ta - 4) + v2;

					uint v4 = 0x16F50000 * c1 * v3 - 0x5D8BE90B * (c1 * v3 >> 16);
					uint v5 = 0x2B890000 * (0x96FF0000 * v4 - 0x2C7C6901 * (v4 >> 16)) + 0x7C932B89 * ((0x96FF0000 * v4 - 0x2C7C6901 * (v4 >> 16)) >> 16);

					o1 = 0x9F690000 * v5 - 0x405B6097 * (v5 >> 16);
					o2 += o1 + v2;
				}

				if (ts == 1) {
					uint n = BitConverter.ToUInt32(a, ta) + o1;

					uint v1 = 0xB1110000 * c0 * n - 0x30674EEF * ((c0 * n) >> 16);
					uint v2 = 0x5B9F0000 * v1 - 0x78F7A461 * (v1 >> 16);
					uint v3 = 0x1D830000 * (0x12CEB96D * (v2 >> 16) - 0x46930000 * v2) + 0x257E1D83 * ((0x12CEB96D * (v2 >> 16) - 0x46930000 * v2) >> 16);
					uint v4 = 0x16F50000 * c1 * v3 - 0x5D8BE90B * ((c1 * v3) >> 16);
					uint v5 = 0x96FF0000 * v4 - 0x2C7C6901 * (v4 >> 16);

					o1 = 0x9F690000 * (0x2B890000 * v5 + 0x7C932B89 * (v5 >> 16)) - 0x405B6097 * ((0x2B890000 * v5 + 0x7C932B89 * (v5 >> 16)) >> 16);
					o2 += o1 + v2;
				}

				uint[] ret = new uint[2];
				ret[0] = o1;
				ret[1] = o2;
				return ret;
			}
		}

		public static long MakeLong(uint left, uint right) {
			return (long)left << 32 | (long)right;
		}
	}
}
'@

		if ( -not ('FileAssoc.PatentHash' -as [type]))
		{
			Add-Type -TypeDefinition $PatentHash
		}

		function Get-KeyLastWriteTime ($SubKey)
		{
			$LM = [RegistryUtils.Action]::GetLastModified([Microsoft.Win32.RegistryHive]::CurrentUser,$SubKey)
			$FT = ([DateTime]::New($LM.Year, $LM.Month, $LM.Day, $LM.Hour, $LM.Minute, 0, $LM.Kind)).ToFileTime()

			return [string]::Format("{0:x8}{1:x8}", $FT -shr 32, $FT -band [uint32]::MaxValue)
		}

		function Get-DataArray
		{
			[OutputType([array])]

	    		# Secret static string stored in %SystemRoot%\SysWOW64\shell32.dll
			$userExperience        = "User Choice set via Windows User Experience {D18B6DD5-6124-4341-9318-804003BAFA0B}"
			# Get user SID
			$userSid               = (Get-CimInstance -ClassName Win32_UserAccount | Where-Object -FilterScript {$_.Name -eq $env:USERNAME}).SID
			$KeyLastWriteTime      = Get-KeyLastWriteTime -SubKey $SubKey
			$baseInfo              = ("{0}{1}{2}{3}{4}" -f $Extension, $userSid, $ProgId, $KeyLastWriteTime, $userExperience).ToLowerInvariant()
			$StringToUTF16LEArray  = [System.Collections.ArrayList]@([System.Text.Encoding]::Unicode.GetBytes($baseInfo))
			$StringToUTF16LEArray += (0,0)

			return $StringToUTF16LEArray
		}

		function Get-PatentHash
		{
			[OutputType([string])]
			param
			(
				[Parameter(Mandatory = $true)]
				[byte[]]
				$A,

				[Parameter(Mandatory = $true)]
				[byte[]]
				$MD5
			)

			$Size = $A.Count
			$ShiftedSize = ($Size -shr 2) - ($Size -shr 2 -band 1) * 1

			[uint32[]]$A1 = [FileAssoc.PatentHash]::WordSwap($A, [int]$ShiftedSize, $MD5)
			[uint32[]]$A2 = [FileAssoc.PatentHash]::Reversible($A, [int]$ShiftedSize, $MD5)

			$Ret = [FileAssoc.PatentHash]::MakeLong($A1[1] -bxor $A2[1], $A1[0] -bxor $A2[0])

			return [System.Convert]::ToBase64String([System.BitConverter]::GetBytes([Int64]$Ret))
		}

		$DataArray = Get-DataArray
		$DataMD5   = [System.Security.Cryptography.HashAlgorithm]::Create("MD5").ComputeHash($DataArray)
		$Hash      = Get-PatentHash -A $DataArray -MD5 $DataMD5

		return $Hash
	}
	#endregion functions

	if ($ProgramPath)
	{
		if (-not (Test-Path -Path "HKCU:\SOFTWARE\Classes\$ProgId\shell\open\command"))
		{
			New-Item -Path "HKCU:\SOFTWARE\Classes\$ProgId\shell\open\command" -Force
		}
		New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\$ProgId\shell\open\command" -Name "(Default)" -PropertyType String -Value "`"$ProgramPath`" `"%1`"" -Force

		$FileNameEXE = (Get-Item -Path $ProgramPath).Name
		if (-not (Test-Path -Path "HKCU:\SOFTWARE\Classes\Applications\$FileNameEXE\shell\open\command"))
		{
			New-Item -Path "HKCU:\SOFTWARE\Classes\Applications\$FileNameEXE\shell\open\command" -Force
		}
		New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Applications\$FileNameEXE\shell\open\command" -Name "(Default)" -PropertyType String -Value "`"$ProgramPath`" `"%1`"" -Force
	}

	if ($Icon)
	{
		Set-Icon -ProgId $ProgId -Icon $Icon
	}

	Write-Verbose -Message $Localization.Patient -Verbose

	# Setting additional parameters to comply with the requirements before configuring the extension
	Write-AdditionalKeys -ProgId $ProgId -Extension $Extension

	# If the file extension specified configure the extension
	Write-ExtensionKeys -ProgId $ProgId -Extension $Extension
}
#endregion System

#region WSL
<#
	.SYNOPSIS
	Configure Windows Subsystem for Linux (WSL)

	.PARAMETER Enable
	Install the Windows Subsystem for Linux (WSL)

	.PARAMETER Disable
	Uninstall the Windows Subsystem for Linux (WSL)

	.EXAMPLE
	WSL -Enable

	.EXAMPLE
	WSL -Disable

	.NOTES
	Machine-wide
#>
function WSL
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	$WSLFeatures = @(
		# Windows Subsystem for Linux
		"Microsoft-Windows-Subsystem-Linux",

		# Virtual Machine Platform
		"VirtualMachinePlatform"
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			Enable-WindowsOptionalFeature -Online -FeatureName $WSLFeatures -NoRestart

			Write-Warning -Message $Localization.RestartWarning
		}
		"Disable"
		{
			Disable-WindowsOptionalFeature -Online -FeatureName $WSLFeatures -NoRestart

			Uninstall-Package -Name "Windows Subsystem for Linux Update" -Force -ErrorAction SilentlyContinue
			Remove-Item -Path "$env:USERPROFILE\.wslconfig" -Force -ErrorAction Ignore

			Write-Warning -Message $Localization.RestartWarning
		}
	}
}

<#
	.SYNOPSIS
	Download, install the Linux kernel update package and set WSL 2 as the default version when installing a new Linux distribution

	.NOTES
	Machine-wide
	To receive kernel updates, enable the Windows Update setting: "Receive updates for other Microsoft products when you update Windows"
#>
function EnableWSL2
{
	$WSLFeatures = @(
		# Windows Subsystem for Linux
		"Microsoft-Windows-Subsystem-Linux",

		# Virtual Machine Platform
		"VirtualMachinePlatform"
	)
	$WSLFeaturesDisabled = Get-WindowsOptionalFeature -Online | Where-Object -FilterScript {($_.FeatureName -in $WSLFeatures) -and ($_.State -eq "Disabled")}

	if ($null -eq $WSLFeaturesDisabled)
	{
		if ((Get-Package -Name "Windows Subsystem for Linux Update" -ProviderName msi -Force -ErrorAction Ignore).Status -ne "Installed")
		{
			# Downloading and installing the Linux kernel update package
			try
			{
				if ((Invoke-WebRequest -Uri https://www.google.com -UseBasicParsing -DisableKeepAlive -Method Head).StatusDescription)
				{
					Write-Verbose -Message $Localization.WSLUpdateDownloading -Verbose

					$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
					$Parameters = @{
						Uri = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
						OutFile = "$DownloadsFolder\wsl_update_x64.msi"
						SslProtocol = "Tls12"
						Verbose = [switch]::Present
					}
					Invoke-WebRequest @Parameters

					Write-Verbose -Message $Localization.WSLUpdateInstalling -Verbose

					Start-Process -FilePath "$DownloadsFolder\wsl_update_x64.msi" -ArgumentList "/passive" -Wait

					Remove-Item -Path "$DownloadsFolder\wsl_update_x64.msi" -Force

					Write-Warning -Message $Localization.RestartWarning
				}
			}
			catch [System.Net.WebException]
			{
				Write-Warning -Message $Localization.NoInternetConnection
				Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue
				return
			}
		}
		else
		{
			# Set WSL 2 as the default architecture when installing a new Linux distribution
			wsl --set-default-version 2
		}
	}
}
#endregion WSL

#region Start menu
<#
	.SYNOPSIS
	Configure recently added apps in the Start menu

	.PARAMETER Hide
	Hide recently added apps in the Start menu

	.PARAMETER Show
	Show recently added apps in the Start menu

	.EXAMPLE
	RecentlyAddedApps -Hide

	.EXAMPLE
	RecentlyAddedApps -Show

	.NOTES
	Machine-wide
#>
function RecentlyAddedApps
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer))
			{
				New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
			}
			New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name HideRecentlyAddedApps -PropertyType DWord -Value 1 -Force
		}
		"Show"
		{
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name HideRecentlyAddedApps -Force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.SYNOPSIS
	Configure app suggestions in the Start menu

	.PARAMETER Hide
	Hide app suggestions in the Start menu

	.PARAMETER Show
	Show app suggestions in the Start menu

	.EXAMPLE
	AppSuggestions -Hide

	.EXAMPLE
	AppSuggestions -Show

	.NOTES
	Current user
#>
function AppSuggestions
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338388Enabled -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338388Enabled -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure how to run the Windows PowerShell shortcut

	.PARAMETER Elevated
	Run the Windows PowerShell shortcut from the Start menu as Administrator

	.PARAMETER NonElevated
	Run the Windows PowerShell shortcut from the Start menu as user

	.EXAMPLE
	RunPowerShellShortcut -Elevated

	.EXAMPLE
	RunPowerShellShortcut -NonElevated

	.NOTES
	Current user
#>
function RunPowerShellShortcut
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Elevated"
		)]
		[switch]
		$Elevated,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "NonElevated"
		)]
		[switch]
		$NonElevated
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Elevated"
		{
			[byte[]]$bytes = Get-Content -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk" -AsByteStream -Raw
			$bytes[0x15] = $bytes[0x15] -bor 0x20
			Set-Content -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk" -Value $bytes -AsByteStream -Force
		}
		"NonElevated"
		{
			[byte[]]$bytes = Get-Content -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk" -AsByteStream -Raw
			$bytes[0x15] = $bytes[0x15] -bxor 0x20
			Set-Content -Path "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk" -Value $bytes -AsByteStream -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the Start tiles

	.PARAMETER ControlPanel
	Pin the "Control Panel" shortcut to Start

	.PARAMETER DevicesPrinters
	Pin the "Devices & Printers" shortcut to Start

	.PARAMETER PowerShell
	Pin the "Windows PowerShell" shortcut to Start

	.PARAMETER UnpinAll
	Unpin all the Start tiles

	.EXAMPLE
	PinToStart -Tiles ControlPanel, DevicesPrinters, PowerShell

	.EXAMPLE
	PinToStart -UnpinAll

	.EXAMPLE
	PinToStart -UnpinAll -Tiles ControlPanel, DevicesPrinters, PowerShell

	.EXAMPLE
	PinToStart -UnpinAll -Tiles ControlPanel

	.EXAMPLE
	PinToStart -Tiles ControlPanel -UnpinAll

	.NOTES
	Separate arguments with comma
	Current user
#>
function PinToStart
{
	[CmdletBinding()]
	param
	(
		[Parameter(
			Mandatory = $false,
			Position = 0
		)]
		[switch]
		$UnpinAll,

		[Parameter(
			Mandatory = $false,
			Position = 1
		)]
		[ValidateSet("ControlPanel", "DevicesPrinters", "PowerShell")]
		[string[]]
		$Tiles
	)

	begin
	{
		$Script:StartLayout = "$PSScriptRoot\StartLayout.xml"

		# Unpin all the Start tiles
		if ($UnpinAll)
		{
			# Export the current Start layout
			Export-StartLayout -Path $Script:StartLayout -UseDesktopApplicationID

			[xml]$XML = Get-Content -Path $Script:StartLayout -Encoding UTF8 -Force
			$Groups = $XML.LayoutModificationTemplate.DefaultLayoutOverride.StartLayoutCollection.StartLayout.Group

			foreach ($Group in $Groups)
			{
				# Removing all groups inside XML
				$Group.ParentNode.RemoveChild($Group) | Out-Null
			}

			$XML.Save($Script:StartLayout)
		}
	}

	process
	{
		# Extract strings from shell32.dll using its' number
		# https://github.com/Disassembler0/Win10-Initial-Setup-Script/issues/8#issue-227159084
		$Signature = @{
			Namespace = "WinAPI"
			Name = "GetStr"
			Language = "CSharp"
			MemberDefinition = @"
[DllImport("kernel32.dll", CharSet = CharSet.Auto)]
public static extern IntPtr GetModuleHandle(string lpModuleName);
[DllImport("user32.dll", CharSet = CharSet.Auto)]
internal static extern int LoadString(IntPtr hInstance, uint uID, StringBuilder lpBuffer, int nBufferMax);
public static string GetString(uint strId)
{
	IntPtr intPtr = GetModuleHandle("shell32.dll");
	StringBuilder sb = new StringBuilder(255);
	LoadString(intPtr, strId, sb, sb.Capacity);
	return sb.ToString();
}
"@
		}

		if (-not ("WinAPI.GetStr" -as [type]))
		{
			Add-Type @Signature -Using System.Text
		}

		# Extract the localized "Devices and Printers" string from shell32.dll
		$DevicesPrinters = [WinAPI.GetStr]::GetString(30493)

		# Check if an argument is "DevicesPrinters". The Devices and Printers's AppID attribute can be retrieved only if the shortcut was created
		if (((Get-Command -Name PinToStart).Parametersets.Parameters | Where-Object -FilterScript {$null -eq $_.Attributes.AliasNames}).Attributes.ValidValues | Where-Object -FilterScript {$_ -match "DevicesPrinters"})
		{
			# Create the old-style "Devices and Printers" shortcut in the Start menu
			$Shell = New-Object -ComObject Wscript.Shell
			$Shortcut = $Shell.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\$DevicesPrinters.lnk")
			$Shortcut.TargetPath = "control"
			$Shortcut.Arguments = "printers"
			$Shortcut.IconLocation = "$env:SystemRoot\system32\DeviceCenter.dll"
			$Shortcut.Save()

			Start-Sleep -Seconds 3
		}

		# Get the AppID because it's auto generated AppID for the "Devices and Printers" shortcut
		$DevicesPrintersAppID = (Get-StartApps | Where-Object -FilterScript {$_.Name -eq $DevicesPrinters}).AppID

		$Parameters = @(
			# Control Panel hash table
			@{
				# Special name for Control Panel
				Name = "ControlPanel"
				Size = "2x2"
				Column = 0
				Row = 0
				AppID = "Microsoft.Windows.ControlPanel"
			},
			# "Devices & Printers" hash table
			@{
				# Special name for "Devices & Printers"
				Name = "DevicesPrinters"
				Size   = "2x2"
				Column = 2
				Row    = 0
				AppID  = $DevicesPrintersAppID
			},
			# Windows PowerShell hash table
			@{
				# Special name for Windows PowerShell
				Name = "PowerShell"
				Size = "2x2"
				Column = 4
				Row = 0
				AppID = "{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe"
			}
		)

		# Valid columns to place tiles in
		$ValidColumns = @(0, 2, 4)
		[string]$StartLayoutNS = "http://schemas.microsoft.com/Start/2014/StartLayout"

		# Add pre-configured hastable to XML
		function Add-Tile
		{
			param
			(
				[string]
				$Size,

				[int]
				$Column,

				[int]
				$Row,

				[string]
				$AppID
			)

			[string]$elementName = "start:DesktopApplicationTile"
			[Xml.XmlElement]$Table = $xml.CreateElement($elementName, $StartLayoutNS)
			$Table.SetAttribute("Size", $Size)
			$Table.SetAttribute("Column", $Column)
			$Table.SetAttribute("Row", $Row)
			$Table.SetAttribute("DesktopApplicationID", $AppID)

			$Table
		}

		if (-not (Test-Path -Path $Script:StartLayout))
		{
			# Export the current Start layout
			Export-StartLayout -Path $Script:StartLayout -UseDesktopApplicationID
		}

		[xml]$XML = Get-Content -Path $Script:StartLayout -Encoding UTF8 -Force

		foreach ($Tile in $Tiles)
		{
			switch ($Tile)
			{
				ControlPanel
				{
					$ControlPanel = [WinAPI.GetStr]::GetString(12712)
					Write-Verbose -Message ($Localization.ShortcutPinning -f $ControlPanel) -Verbose
				}
				DevicesPrinters
				{
					Write-Verbose -Message ($Localization.ShortcutPinning -f $DevicesPrinters) -Verbose
				}
				PowerShell
				{
					Write-Verbose -Message ($Localization.ShortcutPinning -f "Windows PowerShell") -Verbose
				}
			}

			$Parameter = $Parameters | Where-Object -FilterScript {$_.Name -eq $Tile}
			$Group = $XML.LayoutModificationTemplate.DefaultLayoutOverride.StartLayoutCollection.StartLayout.Group | Where-Object -FilterScript {$_.Name -eq "Sophia Script"}

			# If the "Sophia Script" group exists in Start
			if ($Group)
			{
				$DesktopApplicationID = ($Parameters | Where-Object -FilterScript {$_.Name -eq $Tile}).AppID

				if (-not ($Group.DesktopApplicationTile | Where-Object -FilterScript {$_.DesktopApplicationID -eq $DesktopApplicationID}))
				{
					# Calculate current filled columns
					$CurrentColumns = @($Group.DesktopApplicationTile.Column)
					# Calculate current free columns and take the first one
					$Column = (Compare-Object -ReferenceObject $ValidColumns -DifferenceObject $CurrentColumns).InputObject | Select-Object -First 1
					# If filled cells contain desired ones assign the first free column
					if ($CurrentColumns -contains $Parameter.Column)
					{
						$Parameter.Column = $Column
					}
					$Group.AppendChild((Add-Tile @Parameter)) | Out-Null
				}
			}
			else
			{
				# Create the "Sophia Script" group
				[Xml.XmlElement]$Group = $XML.CreateElement("start:Group", $StartLayoutNS)
				$Group.SetAttribute("Name","Sophia Script")
				$Group.AppendChild((Add-Tile @Parameter)) | Out-Null
				$XML.LayoutModificationTemplate.DefaultLayoutOverride.StartLayoutCollection.StartLayout.AppendChild($Group) | Out-Null
			}
		}

		$XML.Save($Script:StartLayout)
	}

	end
	{
		# Temporarily disable changing the Start menu layout
		if (-not (Test-Path -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer))
		{
			New-Item -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
		}
		New-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name LockedStartLayout -Value 1 -Force
		New-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name StartLayoutFile -Value $Script:StartLayout -Force

		Start-Sleep -Seconds 3

		# Restart the Start menu
		Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction Ignore

		Start-Sleep -Seconds 3

		# Open the Start menu to load the new layout
		$wshell = New-Object -ComObject WScript.Shell
		$wshell.SendKeys("^{ESC}")

		Start-Sleep -Seconds 3

		# Enable changing the Start menu layout
		Remove-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name LockedStartLayout -Force -ErrorAction Ignore
		Remove-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name StartLayoutFile -Force -ErrorAction Ignore

		Remove-Item -Path $Script:StartLayout -Force

		Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction Ignore

		Start-Sleep -Seconds 3

		# Open the Start menu to load the new layout
		$wshell = New-Object -ComObject WScript.Shell
		$wshell.SendKeys("^{ESC}")
	}
}
#endregion Start menu

#region UWP apps
<#
	.SYNOPSIS
	Uninstall UWP apps

	.PARAMETER ForAllUsers
	Set the "For All Users" checkbox to unistall packages for all users

	.EXAMPLE
	UninstallUWPApps

	.EXAMPLE
	UninstallUWPApps -ForAllUsers

	.NOTES
	Load The WinRT.Runtime.dll and Microsoft.Windows.SDK.NET.dll assemblies to the current session in order to get localized UWP apps names
	CsWinRT v1.2.5
	Microsoft.Windows.SDK.NET 10.0.19041.16

	.LINK
	https://github.com/microsoft/CsWinRT
	https://www.nuget.org/packages/Microsoft.Windows.SDK.NET.Ref

	.NOTES
	A pop-up dialog box enables the user to select packages
	Current user
#>
function UninstallUWPApps
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $false)]
		[switch]
		$ForAllUsers
	)

	Add-Type -AssemblyName "$PSScriptRoot\Libraries\WinRT.Runtime.dll"
	Add-Type -AssemblyName "$PSScriptRoot\Libraries\Microsoft.Windows.SDK.NET.dll"

	Add-Type -AssemblyName PresentationCore, PresentationFramework

	#region Variables
	# The following UWP apps will have their checkboxes unchecked
	$UncheckedAppxPackages = @(
		# AMD Radeon UWP panel
		# UWP-панель AMD Radeon
		"AdvancedMicroDevicesInc*",

		# Intel Graphics Control Center
		# UWP-панель Intel
		"AppUp.IntelGraphicsControlPanel",
		"AppUp.IntelGraphicsExperience",

		# Sticky Notes
		# Записки
		"Microsoft.MicrosoftStickyNotes",

		# Screen Sketch
		# Набросок на фрагменте экрана
		"Microsoft.ScreenSketch",

		# Photos (and Video Editor)
		# Фотографии и Видеоредактор
		"Microsoft.Windows.Photos",
		"Microsoft.Photos.MediaEngineDLC",

		# HEVC Video Extensions from Device Manufacturer
		# Расширения для видео HEVC от производителя устройства
		"Microsoft.HEVCVideoExtension",

		# Calculator
		# Калькулятор
		"Microsoft.WindowsCalculator",

		# Windows Camera
		# Камера Windows
		"Microsoft.WindowsCamera",

		# Xbox Identity Provider
		# Поставщик удостоверений Xbox
		"Microsoft.XboxIdentityProvider",

		# Xbox Console Companion
		# Компаньон консоли Xbox
		"Microsoft.XboxApp",

		# Xbox
		"Microsoft.GamingApp",
		"Microsoft.GamingServices",

		# Xbox TCUI
		"Microsoft.Xbox.TCUI",

		# Xbox Speech To Text Overlay
		"Microsoft.XboxSpeechToTextOverlay",

		# Xbox Game Bar
		"Microsoft.XboxGamingOverlay",

		# Xbox Game Bar Plugin
		"Microsoft.XboxGameOverlay",

		# NVIDIA Control Panel
		# Панель управления NVidia
		"NVIDIACorp.NVIDIAControlPanel",

		# Realtek Audio Console
		"RealtekSemiconductorCorp.RealtekAudioControl"
	)

	# The following UWP apps will be excluded from the display
	$ExcludedAppxPackages = @(
		# Microsoft Desktop App Installer
		"Microsoft.DesktopAppInstaller",

		# Store Experience Host
		# Узел для покупок Microsoft Store
		"Microsoft.StorePurchaseApp",

		# Microsoft Store
		"Microsoft.WindowsStore",

		# Web Media Extensions
		# Расширения для интернет-мультимедиа
		"Microsoft.WebMediaExtensions"
	)

	#region Variables
	#region XAML Markup
	# The section defines the design of the upcoming dialog box
	[xml]$XAML = '
	<Window
		xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Name="Window"
		MinHeight="400" MinWidth="415"
		SizeToContent="Width" WindowStartupLocation="CenterScreen"
		TextOptions.TextFormattingMode="Display" SnapsToDevicePixels="True"
		FontFamily="Candara" FontSize="16" ShowInTaskbar="True">
		<Window.Resources>
			<Style TargetType="StackPanel">
				<Setter Property="Orientation" Value="Horizontal"/>
				<Setter Property="VerticalAlignment" Value="Top"/>
			</Style>
			<Style TargetType="CheckBox">
				<Setter Property="Margin" Value="10, 13, 10, 10"/>
				<Setter Property="IsChecked" Value="True"/>
			</Style>
			<Style TargetType="TextBlock">
				<Setter Property="Margin" Value="0, 10, 10, 10"/>
			</Style>
			<Style TargetType="Button">
				<Setter Property="Margin" Value="20"/>
				<Setter Property="Padding" Value="10"/>
				<Setter Property="IsEnabled" Value="False"/>
			</Style>
			<Style TargetType="Border">
				<Setter Property="Grid.Row" Value="1"/>
				<Setter Property="CornerRadius" Value="0"/>
				<Setter Property="BorderThickness" Value="0, 1, 0, 1"/>
				<Setter Property="BorderBrush" Value="#000000"/>
			</Style>
			<Style TargetType="ScrollViewer">
				<Setter Property="HorizontalScrollBarVisibility" Value="Disabled"/>
				<Setter Property="BorderBrush" Value="#000000"/>
				<Setter Property="BorderThickness" Value="0, 1, 0, 1"/>
			</Style>
		</Window.Resources>
		<Grid>
			<Grid.RowDefinitions>
				<RowDefinition Height="Auto"/>
				<RowDefinition Height="*"/>
				<RowDefinition Height="Auto"/>
			</Grid.RowDefinitions>
			<Grid Grid.Row="0">
				<Grid.ColumnDefinitions>
					<ColumnDefinition Width="*"/>
					<ColumnDefinition Width="*"/>
				</Grid.ColumnDefinitions>
				<StackPanel Name="PanelSelectAll" Grid.Column="0" HorizontalAlignment="Left">
					<CheckBox Name="CheckBoxSelectAll" IsChecked="False"/>
					<TextBlock Name="TextBlockSelectAll" Margin="10,10, 0, 10"/>
				</StackPanel>
				<StackPanel Name="PanelRemoveForAll" Grid.Column="1" HorizontalAlignment="Right">
					<TextBlock Name="TextBlockRemoveForAll" Margin="10,10, 0, 10"/>
					<CheckBox Name="CheckBoxForAllUsers" IsChecked="False"/>
				</StackPanel>
			</Grid>
			<Border>
				<ScrollViewer>
					<StackPanel Name="PanelContainer" Orientation="Vertical"/>
				</ScrollViewer>
			</Border>
			<Button Name="ButtonUninstall" Grid.Row="2"/>
		</Grid>
	</Window>
	'
	#endregion XAML Markup

	$Reader = (New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $XAML)
	$Form = [Windows.Markup.XamlReader]::Load($Reader)
	$XAML.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object -Process {
		Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)
	}

	$Window.Title               = $Localization.UWPAppsTitle
	$ButtonUninstall.Content    = $Localization.Uninstall
	$TextBlockRemoveForAll.Text = $Localization.UninstallUWPForAll
	$TextBlockSelectAll.Text    = $Localization.SelectAll

	$ButtonUninstall.Add_Click({ButtonUninstallClick})
	$CheckBoxForAllUsers.Add_Click({CheckBoxForAllUsersClick})
	$CheckBoxSelectAll.Add_Click({CheckBoxSelectAllClick})
	#endregion Variables

	#region Functions
	function Get-AppxBundle
	{
		[CmdletBinding()]
		param
		(
			[string[]]
			$Exclude,

			[switch]
			$AllUsers
		)

		Write-Verbose -Message $Localization.Patient -Verbose

		$AppxPackages = Get-AppxPackage -PackageTypeFilter Bundle -AllUsers:$AllUsers | Where-Object -FilterScript {$_.Name -notin $ExcludedAppxPackages}
		$PackagesIds = [Windows.Management.Deployment.PackageManager]::new().FindPackages().AdditionalTypeData[[Collections.IEnumerable].TypeHandle] | Select-Object -Property DisplayName -ExpandProperty Id | Select-Object -Property Name, DisplayName

		foreach ($AppxPackage in $AppxPackages)
		{
			$PackageId = $PackagesIds | Where-Object -FilterScript {$_.Name -eq $AppxPackage.Name}

			if (-not $PackageId)
			{
				continue
			}

			[PSCustomObject]@{
				Name = $AppxPackage.Name
				PackageFullName = $AppxPackage.PackageFullName
				DisplayName = $PackageId.DisplayName
			}
		}
	}

	function Add-Control
	{
		[CmdletBinding()]
		param
		(
			[Parameter(
				Mandatory = $true,
				ValueFromPipeline = $true
			)]
			[ValidateNotNull()]
			[PSCustomObject[]]
			$Packages
		)

		process
		{
			foreach ($Package in $Packages)
			{
				$CheckBox = New-Object -TypeName System.Windows.Controls.CheckBox
				$CheckBox.Tag = $Package.PackageFullName

				$TextBlock = New-Object -TypeName System.Windows.Controls.TextBlock

				if ($Package.DisplayName)
				{
					$TextBlock.Text = $Package.DisplayName
				}
				else
				{
					$TextBlock.Text = $Package.Name
				}

				$StackPanel = New-Object -TypeName System.Windows.Controls.StackPanel
				$StackPanel.Children.Add($CheckBox) | Out-Null
				$StackPanel.Children.Add($TextBlock) | Out-Null

				$PanelContainer.Children.Add($StackPanel) | Out-Null

				if ($UncheckedAppxPackages.Contains($Package.Name))
				{
					$CheckBox.IsChecked = $false
				}
				else
				{
					$CheckBox.IsChecked = $true
					$PackagesToRemove.Add($Package.PackageFullName)
				}

				$CheckBox.Add_Click({CheckBoxClick})
			}
		}
	}

	function CheckBoxForAllUsersClick
	{
		$PanelContainer.Children.RemoveRange(0, $PanelContainer.Children.Count)
		$PackagesToRemove.Clear()
		$AppXPackages = Get-AppxBundle -Exclude $ExcludedAppxPackages -AllUsers:$CheckBoxForAllUsers.IsChecked
		$AppXPackages | Add-Control

		ButtonUninstallSetIsEnabled
	}

	function ButtonUninstallClick
	{
		Write-Verbose -Message $Localization.Patient -Verbose

		$Window.Close() | Out-Null

		# If Xbox Game Bar is selected to uninstall stop its' processes
		if ($PackagesToRemove -match "Microsoft.XboxGamingOverlay")
		{
			Get-Process -Name GameBar, GameBarFTServer -ErrorAction Ignore | Stop-Process -Force
		}

		$PackagesToRemove | Remove-AppxPackage -AllUsers:$CheckBoxForAllUsers.IsChecked -Verbose
	}

	function CheckBoxClick
	{
		$CheckBox = $_.Source

		if ($CheckBox.IsChecked)
		{
			$PackagesToRemove.Add($CheckBox.Tag) | Out-Null
		}
		else
		{
			$PackagesToRemove.Remove($CheckBox.Tag)
		}

		ButtonUninstallSetIsEnabled
	}

	function CheckBoxSelectAllClick
	{
		$CheckBox = $_.Source

		if ($CheckBox.IsChecked)
		{
			$PackagesToRemove.Clear()

			foreach ($Item in $PanelContainer.Children.Children)
			{
				if ($Item -is [System.Windows.Controls.CheckBox])
				{
					$Item.IsChecked = $true
					$PackagesToRemove.Add($Item.Tag)
				}
			}
		}
		else
		{
			$PackagesToRemove.Clear()

			foreach ($Item in $PanelContainer.Children.Children)
			{
				if ($Item -is [System.Windows.Controls.CheckBox])
				{
					$Item.IsChecked = $false
				}
			}
		}

		ButtonUninstallSetIsEnabled
	}

	function ButtonUninstallSetIsEnabled
	{
		if ($PackagesToRemove.Count -gt 0)
		{
			$ButtonUninstall.IsEnabled = $true
		}
		else
		{
			$ButtonUninstall.IsEnabled = $false
		}
	}
	#endregion Functions

	# Check "For All Users" checkbox to uninstall packages from all accounts
	if ($ForAllUsers)
	{
		$CheckBoxForAllUsers.IsChecked = $true
	}

	$PackagesToRemove = [Collections.Generic.List[string]]::new()
	$AppXPackages = Get-AppxBundle -Exclude $ExcludedAppxPackages -AllUsers:$ForAllUsers
	$AppXPackages | Add-Control

	if ($AppxPackages.Count -eq 0)
	{
		Write-Verbose -Message $Localization.NoData -Verbose
	}
	else
	{
		Write-Verbose -Message $Localization.DialogBoxOpening -Verbose

		if ($PackagesToRemove.Count -gt 0)
		{
			$ButtonUninstall.IsEnabled = $true
		}
		$Form.ShowDialog() | Out-Null
	}
}

<#
	.SYNOPSIS
	Restore the default UWP apps

	.EXAMPLE
	RestoreUWPAppsUWPApps

	.NOTES
	UWP apps can be restored only if they were uninstalled for the current user

	.NOTES
	Load The WinRT.Runtime.dll and Microsoft.Windows.SDK.NET.dll assemblies to the current session in order to get localized UWP apps names
	CsWinRT v1.2.5
	Microsoft.Windows.SDK.NET 10.0.19041.16

	.LINK
	https://github.com/microsoft/CsWinRT
	https://www.nuget.org/packages/Microsoft.Windows.SDK.NET.Ref

	.NOTES
	A pop-up dialog box enables the user to select packages
	Current user
#>
function RestoreUWPApps
{
	Add-Type -AssemblyName "$PSScriptRoot\Libraries\WinRT.Runtime.dll"
	Add-Type -AssemblyName "$PSScriptRoot\Libraries\Microsoft.Windows.SDK.NET.dll"

	Add-Type -AssemblyName PresentationCore, PresentationFramework

	#region Variables
	#region XAML Markup
	# The section defines the design of the upcoming dialog box
	[xml]$XAML = '
	<Window
		xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Name="Window"
		MinHeight="400" MinWidth="410"
		SizeToContent="Width" WindowStartupLocation="CenterScreen"
		TextOptions.TextFormattingMode="Display" SnapsToDevicePixels="True"
		FontFamily="Candara" FontSize="16" ShowInTaskbar="True">
		<Window.Resources>
			<Style TargetType="StackPanel">
				<Setter Property="Orientation" Value="Horizontal"/>
				<Setter Property="VerticalAlignment" Value="Top"/>
			</Style>
			<Style TargetType="CheckBox">
				<Setter Property="Margin" Value="10, 13, 10, 10"/>
				<Setter Property="IsChecked" Value="True"/>
			</Style>
			<Style TargetType="TextBlock">
				<Setter Property="Margin" Value="0, 10, 10, 10"/>
			</Style>
			<Style TargetType="Button">
				<Setter Property="Margin" Value="20"/>
				<Setter Property="Padding" Value="10"/>
				<Setter Property="IsEnabled" Value="False"/>
			</Style>
			<Style TargetType="Border">
				<Setter Property="Grid.Row" Value="1"/>
				<Setter Property="CornerRadius" Value="0"/>
				<Setter Property="BorderThickness" Value="0, 1, 0, 1"/>
				<Setter Property="BorderBrush" Value="#000000"/>
			</Style>
			<Style TargetType="ScrollViewer">
				<Setter Property="HorizontalScrollBarVisibility" Value="Disabled"/>
				<Setter Property="BorderBrush" Value="#000000"/>
				<Setter Property="BorderThickness" Value="0, 1, 0, 1"/>
			</Style>
		</Window.Resources>
		<Grid>
			<Grid.RowDefinitions>
				<RowDefinition Height="Auto"/>
				<RowDefinition Height="*"/>
				<RowDefinition Height="Auto"/>
			</Grid.RowDefinitions>
			<Grid Grid.Row="0">
				<Grid.ColumnDefinitions>
					<ColumnDefinition Width="*"/>
					<ColumnDefinition Width="*"/>
				</Grid.ColumnDefinitions>
				<StackPanel Name="PanelSelectAll" Grid.Column="0" HorizontalAlignment="Left">
					<CheckBox Name="CheckBoxSelectAll" IsChecked="False"/>
					<TextBlock Name="TextBlockSelectAll" Margin="10,10, 0, 10"/>
				</StackPanel>
			</Grid>
			<Border>
				<ScrollViewer>
					<StackPanel Name="PanelContainer" Orientation="Vertical"/>
				</ScrollViewer>
			</Border>
			<Button Name="ButtonRestore" Grid.Row="2"/>
		</Grid>
	</Window>
	'
	#endregion XAML Markup

	$Reader = (New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $XAML)
	$Form = [Windows.Markup.XamlReader]::Load($Reader)
	$XAML.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object -Process {
		Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)
	}

	$Window.Title            = $Localization.UWPAppsTitle
	$ButtonRestore.Content   = $Localization.Restore
	$TextBlockSelectAll.Text = $Localization.SelectAll

	$ButtonRestore.Add_Click({ButtonRestoreClick})
	$CheckBoxSelectAll.Add_Click({CheckBoxSelectAllClick})
	#endregion Variables

	#region Functions
	function Get-AppxManifest
	{
		Write-Verbose -Message $Localization.Patient -Verbose

		# Тут нельзя напрямую вписать -PackageTypeFilter Bundle, так как иначе не выдается нужное свойство InstallLocation. Только сравнивать с $Bundles
		$Bundles = (Get-AppXPackage -PackageTypeFilter Bundle -AllUsers).Name
		$AppxPackages = Get-AppxPackage -AllUsers | Where-Object -FilterScript {$_.PackageUserInformation -match "Staged"} | Where-Object -FilterScript {$_.Name -in $Bundles}
		$PackagesIds = [Windows.Management.Deployment.PackageManager]::new().FindPackages().AdditionalTypeData[[Collections.IEnumerable].TypeHandle] | Select-Object -Property DisplayName -ExpandProperty Id | Select-Object -Property Name, DisplayName

		foreach ($AppxPackage in $AppxPackages)
		{
			$PackageId = $PackagesIds | Where-Object -FilterScript {$_.Name -eq $AppxPackage.Name}

			if (-not $PackageId)
			{
				continue
			}

			[PSCustomObject]@{
				Name            = $AppxPackage.Name
				PackageFullName = $AppxPackage.PackageFullName
				DisplayName     = $PackageId.DisplayName
				AppxManifest    = "$($AppxPackage.InstallLocation)\AppxManifest.xml"
			}
		}
	}

	function Add-Control
	{
		[CmdletBinding()]
		param
		(
			[Parameter(
				Mandatory = $true,
				ValueFromPipeline = $true
			)]
			[ValidateNotNull()]
			[PSCustomObject[]]
			$Packages
		)

		process
		{
			foreach ($Package in $Packages)
			{
				$CheckBox = New-Object -TypeName System.Windows.Controls.CheckBox
				$CheckBox.Tag = $Package.AppxManifest

				$TextBlock = New-Object -TypeName System.Windows.Controls.TextBlock

				if ($Package.DisplayName)
				{
					$TextBlock.Text = $Package.DisplayName
				}
				else
				{
					$TextBlock.Text = $Package.Name
				}

				$StackPanel = New-Object -TypeName System.Windows.Controls.StackPanel
				$StackPanel.Children.Add($CheckBox) | Out-Null
				$StackPanel.Children.Add($TextBlock) | Out-Null

				$PanelContainer.Children.Add($StackPanel) | Out-Null

				$CheckBox.IsChecked = $true
				$PackagesToRestore.Add($Package.AppxManifest)

				$CheckBox.Add_Click({CheckBoxClick})
			}
		}
	}

	function ButtonRestoreClick
	{
		Write-Verbose -Message $Localization.Patient -Verbose

		$Window.Close() | Out-Null

		$Parameters = @{
			Register                  = $true
			ForceApplicationShutdown  = $true
			ForceUpdateFromAnyVersion = $true
			DisableDevelopmentMod     = $true
			Verbose                   = [switch]::Present
		}
		$PackagesToRestore | Add-AppxPackage @Parameters
	}

	function CheckBoxClick
	{
		$CheckBox = $_.Source

		if ($CheckBox.IsChecked)
		{
			$PackagesToRestore.Add($CheckBox.Tag) | Out-Null
		}
		else
		{
			$PackagesToRestore.Remove($CheckBox.Tag)
		}

		ButtonRestoreSetIsEnabled
	}

	function CheckBoxSelectAllClick
	{
		$CheckBox = $_.Source

		if ($CheckBox.IsChecked)
		{
			$PackagesToRestore.Clear()

			foreach ($Item in $PanelContainer.Children.Children)
			{
				if ($Item -is [System.Windows.Controls.CheckBox])
				{
					$Item.IsChecked = $true
					$PackagesToRestore.Add($Item.Tag)
				}
			}
		}
		else
		{
			$PackagesToRestore.Clear()

			foreach ($Item in $PanelContainer.Children.Children)
			{
				if ($Item -is [System.Windows.Controls.CheckBox])
				{
					$Item.IsChecked = $false
				}
			}
		}

		ButtonRestoreSetIsEnabled
	}

	function ButtonRestoreSetIsEnabled
	{
		if ($PackagesToRestore.Count -gt 0)
		{
			$ButtonRestore.IsEnabled = $true
		}
		else
		{
			$ButtonRestore.IsEnabled = $false
		}
	}
	#endregion Functions

	$PackagesToRestore = [Collections.Generic.List[string]]::new()
	$AppXPackages = Get-AppxManifest
	$AppXPackages | Add-Control

	if ($AppxPackages.Count -eq 0)
	{
		Write-Verbose -Message $Localization.NoData -Verbose
	}
	else
	{
		Write-Verbose -Message $Localization.DialogBoxOpening -Verbose

		if ($PackagesToRestore.Count -gt 0)
		{
			$ButtonRestore.IsEnabled = $true
		}
		$Form.ShowDialog() | Out-Null
	}
}

<#
	.SYNOPSIS
	Install "HEVC Video Extensions from Device Manufacturer" to be able to open .heic and .heif formats

	.PARAMETER Manual
	Open Microsoft Store "HEVC Video Extensions from Device Manufacturer" page to install the extension manually

	.PARAMETER Install
	Download and install the "HEVC Video Extensions from Device Manufacturer" extension using the https://store.rg-adguard.net parser

	.EXAMPLE
	HEIF -Manual

	.EXAMPLE
	HEIF -Install

	.LINK
	https://www.microsoft.com/store/productId/9n4wgh0z6vhq
	https://dev.to/kaiwalter/download-windows-store-apps-with-powershell-from-https-store-rg-adguard-net-155m

	.NOTES
	The extension can be installed without Microsoft account
	Current user
#>
function HEIF
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Manual"
		)]
		[switch]
		$Manual,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Install"
		)]
		[switch]
		$Install
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Manual"
		{
			if (-not (Get-AppxPackage -Name Microsoft.HEVCVideoExtension) -and (Get-AppxPackage -Name Microsoft.Windows.Photos))
			{
				try
				{
					if ((Invoke-WebRequest -Uri https://www.google.com -UseBasicParsing -DisableKeepAlive -Method Head).StatusDescription)
					{
						Start-Process -FilePath ms-windows-store://pdp/?ProductId=9n4wgh0z6vhq
					}
				}
				catch [System.Net.WebException]
				{
					Write-Warning -Message $Localization.NoInternetConnection
					Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue
					return
				}
			}
		}
		"Install"
		{
			# Check whether the extension is already installed
			if (-not (Get-AppxPackage -Name Microsoft.HEVCVideoExtension) -and (Get-AppxPackage -Name Microsoft.Windows.Photos))
			{
				try
				{
					# Check the internet connection
					if ((Invoke-WebRequest -Uri https://www.google.com -UseBasicParsing -DisableKeepAlive -Method Head).StatusDescription)
					{
						try
						{
							# Check whether the https://store.rg-adguard.net site is alive
							if ((Invoke-WebRequest -Uri https://store.rg-adguard.net/api/GetFiles -UseBasicParsing -DisableKeepAlive -Method Head).StatusDescription)
							{
								$API = "https://store.rg-adguard.net/api/GetFiles"
								# HEVC Video Extensions from Device Manufacturer
								$ProductURL = "https://www.microsoft.com/store/productId/9n4wgh0z6vhq"

								$Body = @{
									"type" = "url"
									"url"  = $ProductURL
									"ring" = "Retail"
									"lang" = "en-US"
								}
								$Raw = Invoke-RestMethod -Method Post -Uri $API -ContentType 'application/x-www-form-urlencoded' -Body $Body

								# Parsing the page
								$Raw | Select-String -Pattern '<tr style.*<a href=\"(?<url>.*)"\s.*>(?<text>.*)<\/a>' -AllMatches | ForEach-Object -Process {$_.Matches} | ForEach-Object -Process {
									$TempURL = $_.Groups[1].Value
									$Package = $_.Groups[2].Value

									if ($Package -like "Microsoft.HEVCVideoExtension_*_x64__8wekyb3d8bbwe.appx")
									{
										Write-Verbose -Message $Localization.HEVCDownloading -Verbose

										$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
										$Parameters = @{
											Uri = $TempURL
											OutFile = "$DownloadsFolder\$Package"
											SslProtocol = "Tls12"
											Verbose = [switch]::Present
										}
										Invoke-WebRequest @Parameters

										# Installing "HEVC Video Extensions from Device Manufacturer"
										Add-AppxPackage -Path "$DownloadsFolder\$Package" -Verbose

										Remove-Item -Path "$DownloadsFolder\$Package" -Force
									}
								}
							}
						}
						catch [System.Net.WebException]
						{
							Write-Warning -Message $Localization.NoResponse
							Write-Error -Message $Localization.NoResponse -ErrorAction SilentlyContinue
							return
						}
					}
				}
				catch [System.Net.WebException]
				{
					Write-Warning -Message $Localization.NoInternetConnection
					Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue
					return
				}
			}
		}
	}
}

<#
	.SYNOPSIS
	Configure Cortana autostarting

	.PARAMETER Disable
	Enable Cortana autostarting

	.PARAMETER Enable
	Disable Cortana autostarting

	.EXAMPLE
	CortanaAutostart -Disable

	.EXAMPLE
	CortanaAutostart -Enable

	.NOTES
	Current user
#>
function CortanaAutostart
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			if (Get-AppxPackage -Name Microsoft.549981C3F5F10)
			{
				if (-not (Test-Path -Path "Registry::HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\Microsoft.549981C3F5F10_8wekyb3d8bbwe\CortanaStartupId"))
				{
					New-Item -Path "Registry::HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\Microsoft.549981C3F5F10_8wekyb3d8bbwe\CortanaStartupId" -Force
				}
				New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\Microsoft.549981C3F5F10_8wekyb3d8bbwe\CortanaStartupId" -Name State -PropertyType DWord -Value 1 -Force
			}
		}
		"Enable"
		{
			if (Get-AppxPackage -Name Microsoft.549981C3F5F10)
			{
				Remove-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\Microsoft.549981C3F5F10_8wekyb3d8bbwe\CortanaStartupId" -Name State -Force -ErrorAction SilentlyContinue
			}
		}
	}
}

<#
	.SYNOPSIS
	Configure UWP apps running in the background

	.PARAMETER Disable
	Do not let UWP apps run in the background

	.PARAMETER Enable
	Let all UWP apps run in the background

	.EXAMPLE
	BackgroundUWPApps -Disable

	.EXAMPLE
	BackgroundUWPApps -Enable

	.NOTES
	Current user
#>
function BackgroundUWPApps
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | ForEach-Object -Process {
				Remove-ItemProperty -Path $_.PsPath -Name * -Force
			}

			$ExcludedBackgroundApps = @(
				# Lock screen app
				# Экран блокировки
				"Microsoft.LockApp",

				# Content Delivery Manager (delivers Windows Spotlight wallpapers to the lock screen)
				# Content Delivery Manager (доставляет обои для Windows Spotlight на экран блокировки)
				"Microsoft.Windows.ContentDeliveryManager",

				# Cortana
				"Microsoft.Windows.Cortana",

				# Windows Search
				"Microsoft.Windows.Search",

				# Windows Security
				# Безопасность Windows
				"Microsoft.Windows.SecHealthUI",

				# Windows Shell Experience (Action center, snipping support, toast notification, touch screen keyboard)
				# Windows Shell Experience (Центр уведомлений, приложение "Ножницы", тостовые уведомления, сенсорная клавиатура)
				"Microsoft.Windows.ShellExperienceHost",

				# The Start menu
				# Меню "Пуск"
				"Microsoft.Windows.StartMenuExperienceHost",

				# Microsoft Store
				"Microsoft.WindowsStore"
			)
			$OFS = "|"
			Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | Where-Object -FilterScript {$_.PSChildName -notmatch "^$($ExcludedBackgroundApps.ForEach({[regex]::Escape($_)}))"} | ForEach-Object -Process {
				New-ItemProperty -Path $_.PsPath -Name Disabled -PropertyType DWord -Value 1 -Force
				New-ItemProperty -Path $_.PsPath -Name DisabledByUser -PropertyType DWord -Value 1 -Force
			}
			$OFS = " "

			# Open "Background apps" page
			Start-Process -FilePath ms-settings:privacy-backgroundapps
		}
		"Enable"
		{
			Get-ChildItem -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications | ForEach-Object -Process {
				Remove-ItemProperty -Path $_.PsPath -Name * -Force
			}
		}
	}
}

# Check for UWP apps updates
function CheckUWPAppsUpdates
{
	Write-Verbose -Message $Localization.Patient -Verbose
	Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod
}
#endregion UWP apps

#region Gaming
<#
	.SYNOPSIS
	Configure Xbox Game Bar

	.PARAMETER Disable
	Disable Xbox Game Bar

	.PARAMETER Enable
	Enable Xbox Game Bar

	.EXAMPLE
	XboxGameBar -Disable

	.EXAMPLE
	XboxGameBar -Enable

	.NOTES
	Current user
#>
function XboxGameBar
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			if ((Get-AppxPackage -Name Microsoft.XboxGamingOverlay) -or (Get-AppxPackage -Name Microsoft.GamingApp))
			{
				New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR -Name AppCaptureEnabled -PropertyType DWord -Value 0 -Force
				New-ItemProperty -Path HKCU:\System\GameConfigStore -Name GameDVR_Enabled -PropertyType DWord -Value 0 -Force
			}
		}
		"Enable"
		{
			if ((Get-AppxPackage -Name Microsoft.XboxGamingOverlay) -or (Get-AppxPackage -Name Microsoft.GamingApp))
			{
				New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR -Name AppCaptureEnabled -PropertyType DWord -Value 1 -Force
				New-ItemProperty -Path HKCU:\System\GameConfigStore -Name GameDVR_Enabled -PropertyType DWord -Value 1 -Force
			}
		}
	}
}

<#
	.SYNOPSIS
	Configure Xbox Game Bar tips

	.PARAMETER Disable
	Disable Xbox Game Bar tips

	.PARAMETER Enable
	Enable Xbox Game Bar tips

	.EXAMPLE
	XboxGameTips -Disable

	.EXAMPLE
	XboxGameTips -Enable

	.NOTES
	Current user
#>
function XboxGameTips
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			if ((Get-AppxPackage -Name Microsoft.XboxGamingOverlay) -or (Get-AppxPackage -Name Microsoft.GamingApp))
			{
				New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\GameBar -Name ShowStartupPanel -PropertyType DWord -Value 0 -Force
			}
		}
		"Enable"
		{
			if ((Get-AppxPackage -Name Microsoft.XboxGamingOverlay) -or (Get-AppxPackage -Name Microsoft.GamingApp))
			{
				New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\GameBar -Name ShowStartupPanel -PropertyType DWord -Value 1 -Force
			}
		}
	}
}

<#
	.SYNOPSIS
	Choose an app to set "High performance" graphics preference

	.NOTES
	Only with a dedicated GPU
	Current user
#>
function SetAppGraphicsPerformance
{
	if (Get-CimInstance -ClassName Win32_VideoController | Where-Object -FilterScript {$_.AdapterDACType -ne "Internal" -and $null -ne $_.AdapterDACType})
	{
		$Title = $Localization.GraphicsPerformanceTitle
		$Message = $Localization.GraphicsPerformanceRequest
		$Add = $Localization.Add
		$Skip = $Localization.Skip
		$Options = "&$Add", "&$Skip"
		$DefaultChoice = 1

		do
		{
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
			switch ($Result)
			{
				"0"
				{
					Add-Type -AssemblyName System.Windows.Forms
					$OpenFileDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
					$OpenFileDialog.Filter = $Localization.EXEFilesFilter
					$OpenFileDialog.InitialDirectory = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
					$OpenFileDialog.Multiselect = $false

					# Focus on open file dialog
					$Focus = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
					$OpenFileDialog.ShowDialog($Focus)

					if ($OpenFileDialog.FileName)
					{
						if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences))
						{
							New-Item -Path HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences -Force
						}
						New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\DirectX\UserGpuPreferences -Name $OpenFileDialog.FileName -PropertyType String -Value "GpuPreference=2;" -Force
						Write-Verbose -Message ("{0}" -f $OpenFileDialog.FileName) -Verbose
					}
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}
		}
		until ($Result -eq 1)
	}
}

<#
	.SYNOPSIS
	Configure hardware-accelerated GPU scheduling

	.PARAMETER Disable
	Disable hardware-accelerated GPU scheduling

	.PARAMETER Enable
	Enable hardware-accelerated GPU scheduling

	.EXAMPLE
	GPUScheduling -Disable

	.EXAMPLE
	GPUScheduling -Enable

	.NOTES
	Only with a dedicated GPU and WDDM verion is 2.7 or higher
	Current user
	Restart needed
#>
function GPUScheduling
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name HwSchMode -PropertyType DWord -Value 1 -Force
		}
		"Enable"
		{
			if ((Get-CimInstance -ClassName CIM_VideoController | Where-Object -FilterScript {$_.AdapterDACType -ne "Internal"}))
			{
				# Determining whether an OS is not installed on a virtual machine
				if ((Get-CimInstance -ClassName CIM_ComputerSystem).Model -notmatch "Virtual")
				{
					# Checking whether a WDDM verion is 2.7 or higher
					$WddmVersion_Min = Get-ItemPropertyValue -Path HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\FeatureSetUsage -Name WddmVersion_Min
					if ($WddmVersion_Min -ge 2700)
					{
						New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name HwSchMode -PropertyType DWord -Value 2 -Force
					}
				}
			}
		}
	}
}
#endregion Gaming

#region Scheduled tasks
<#
	.SYNOPSIS
	The "Windows Cleanup" scheduled task for cleaning up Windows unused files and updates

	.PARAMETER Register
	Create the "Windows Cleanup" scheduled task for cleaning up Windows unused files and updates

	.PARAMETER Delete
	Delete the "Windows Cleanup" and "Windows Cleanup Notification" scheduled tasks for cleaning up Windows unused files and updates

	.EXAMPLE
	CleanupTask -Register

	.EXAMPLE
	CleanupTask -Delete

	.NOTES
	A native interactive toast notification pops up every 30 days
	The task runs every 30 days
	Current user
#>
function CleanupTask
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Register"
		)]
		[switch]
		$Register,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Delete"
		)]
		[switch]
		$Delete
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Register"
		{
			Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches | ForEach-Object -Process {
				Remove-ItemProperty -Path $_.PsPath -Name StateFlags1337 -Force -ErrorAction Ignore
			}

			$VolumeCaches = @(
				# Delivery Optimization Files
				# Файлы оптимизации доставки
				"Delivery Optimization Files",

				# Device driver packages
				# Пакеты драйверов устройств
				"Device Driver Packages",

				# Previous Windows Installation(s)
				# Предыдущие установки Windows
				"Previous Installations",

				# Setup log files
				# Файлы журнала установки
				"Setup Log Files",

				# Temporary Setup Files
				# Временные файлы установки
				"Temporary Setup Files",

				# Windows Update Cleanup
				# Очистка обновлений Windows
				"Update Cleanup",

				# Microsoft Defender
				"Windows Defender",

				# Windows upgrade log files
				# Файлы журнала обновления Windows
				"Windows Upgrade Log Files"
			)
			foreach ($VolumeCache in $VolumeCaches)
			{
				New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$VolumeCache" -Name StateFlags1337 -PropertyType DWord -Value 2 -Force
			}

			$CleanupTask = @"
Get-Process -Name cleanmgr | Stop-Process -Force
Get-Process -Name Dism | Stop-Process -Force
Get-Process -Name DismHost | Stop-Process -Force

`$ProcessInfo = New-Object -TypeName System.Diagnostics.ProcessStartInfo
`$ProcessInfo.FileName = """$env:SystemRoot\system32\cleanmgr.exe"""
`$ProcessInfo.Arguments = """/sagerun:1337"""
`$ProcessInfo.UseShellExecute = `$true
`$ProcessInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Minimized

`$Process = New-Object -TypeName System.Diagnostics.Process
`$Process.StartInfo = `$ProcessInfo
`$Process.Start() | Out-Null

Start-Sleep -Seconds 3

[int]`$SourceMainWindowHandle = (Get-Process -Name cleanmgr | Where-Object -FilterScript {`$_.PriorityClass -eq """BelowNormal"""}).MainWindowHandle

function MinimizeWindow
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = `$true)]
		`$Process
	)

	`$ShowWindowAsync = @{
		Namespace = """WinAPI"""
		Name = """Win32ShowWindowAsync"""
		Language = """CSharp"""
		MemberDefinition = @'
[DllImport("""user32.dll""")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
'@
	}

	if (-not ("""WinAPI.Win32ShowWindowAsync""" -as [type]))
	{
		Add-Type @ShowWindowAsync
	}
	`$MainWindowHandle = (Get-Process -Name `$Process | Where-Object -FilterScript {`$_.PriorityClass -eq """BelowNormal"""}).MainWindowHandle
	[WinAPI.Win32ShowWindowAsync]::ShowWindowAsync(`$MainWindowHandle, 2)
}

while (`$true)
{
	[int]`$CurrentMainWindowHandle = (Get-Process -Name cleanmgr | Where-Object -FilterScript {`$_.PriorityClass -eq """BelowNormal"""}).MainWindowHandle
	if (`$SourceMainWindowHandle -ne `$CurrentMainWindowHandle)
	{
		MinimizeWindow -Process cleanmgr
		break
	}
	Start-Sleep -Milliseconds 5
}

`$ProcessInfo = New-Object -TypeName System.Diagnostics.ProcessStartInfo
`$ProcessInfo.FileName = """`$env:SystemRoot\system32\dism.exe"""
`$ProcessInfo.Arguments = """/Online /English /Cleanup-Image /StartComponentCleanup /NoRestart"""
`$ProcessInfo.UseShellExecute = `$true
`$ProcessInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Minimized

`$Process = New-Object -TypeName System.Diagnostics.Process
`$Process.StartInfo = `$ProcessInfo
`$Process.Start() | Out-Null
"@

			# Create the "Windows Cleanup" task
			$Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Hidden -Command $CleanupTask"
			$Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
			$Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
			$Parameters = @{
				TaskName    = "Windows Cleanup"
				TaskPath    = "Sophia Script"
				Principal   = $Principal
				Action      = $Action
				Description = $Localization.CleanupTaskDescription
				Settings    = $Settings
			}
			Register-ScheduledTask @Parameters -Force

			# Persist the Settings notifications to prevent to immediately disappear from Action Center
			if (-not (Test-Path -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel"))
			{
				New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel" -Force
			}
			New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel" -Name ShowInActionCenter -PropertyType DWord -Value 1 -Force

			# Register the "WindowsCleanup" protocol to be able to run the scheduled task upon clicking on the "Run" button
			if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\WindowsCleanup))
			{
				New-Item -Path Registry::HKEY_CLASSES_ROOT\WindowsCleanup -Force
			}
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\WindowsCleanup -Name "(default)" -PropertyType String -Value "URL:WindowsCleanup" -Force
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\WindowsCleanup -Name "URL Protocol" -Value "" -Force
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\WindowsCleanup -Name EditFlags -PropertyType DWord -Value 2162688 -Force
			if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\shell\open\command))
			{
				New-item -Path Registry::HKEY_CLASSES_ROOT\WindowsCleanup\shell\open\command -Force
			}
			# If "Run" clicked run the "Windows Cleanup" task
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\WindowsCleanup\shell\open\command -Name "(default)" -PropertyType String -Value 'powershell.exe -Command "& {Start-ScheduledTask -TaskPath ''\Sophia Script\'' -TaskName ''Windows Cleanup''}"' -Force

			$ToastNotification = @"
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

[xml]`$ToastTemplate = @"""
<toast duration="""Long""" scenario="""reminder""">
	<visual>
		<binding template="""ToastGeneric""">
			<text>$($Localization.CleanupTaskNotificationTitle)</text>
			<group>
				<subgroup>
					<text hint-style="""title""" hint-wrap="""true""">$($Localization.CleanupTaskNotificationEventTitle)</text>
				</subgroup>
			</group>
			<group>
				<subgroup>
					<text hint-style="""body""" hint-wrap="""true""">$($Localization.CleanupTaskNotificationEvent)</text>
				</subgroup>
			</group>
		</binding>
	</visual>
	<audio src="""ms-winsoundevent:notification.default""" />
	<actions>
		<input id="""SnoozeTimer""" type="""selection""" title="""$($Localization.CleanupTaskNotificationSnoozeInterval)""" defaultInput="""1""">
			<selection id="""1""" content="""$($Localization.Minute)""" />
			<selection id="""30""" content="""$($Localization.HalfHour)""" />
			<selection id="""240""" content="""$($Localization.FourHours)""" />
		</input>
		<action activationType="""system""" arguments="""snooze""" hint-inputId="""SnoozeTimer""" content="""""" id="""test-snooze"""/>
		<action arguments="""WindowsCleanup:""" content="""$($Localization.Run)""" activationType="""protocol"""/>
		<action arguments="""dismiss""" content="""""" activationType="""system"""/>
	</actions>
</toast>
"""@

`$ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::New()
`$ToastXml.LoadXml(`$ToastTemplate.OuterXml)

`$ToastMessage = [Windows.UI.Notifications.ToastNotification]::New(`$ToastXML)
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("""windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel""").Show(`$ToastMessage)
"@

			# Create the "Windows Cleanup Notification" task
			$Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Hidden -Command $ToastNotification"
			$Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
			$Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
			$Trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 30 -At 9pm
			$Parameters = @{
				TaskName    = "Windows Cleanup Notification"
				TaskPath    = "Sophia Script"
				Principal   = $Principal
				Action      = $Action
				Description = $Localization.CleanupNotificationTaskDescription
				Settings    = $Settings
				Trigger     = $Trigger
			}
			Register-ScheduledTask @Parameters -Force
		}
		"Delete"
		{
			Unregister-ScheduledTask -TaskName "Windows Cleanup" -Confirm:$false
			Unregister-ScheduledTask -TaskName "Windows Cleanup Notification" -Confirm:$false

			Remove-Item -Path Registry::HKEY_CLASSES_ROOT\WindowsCleanup -Recurse -Force
		}
	}
}

<#
	.SYNOPSIS
	The "SoftwareDistribution" scheduled task for cleaning up the %SystemRoot%\SoftwareDistribution\Download folder

	.PARAMETER Register
	Create the "SoftwareDistribution" scheduled task for cleaning up the %SystemRoot%\SoftwareDistribution\Download folder

	.PARAMETER Delete
	Delete the "SoftwareDistribution" scheduled task for cleaning up the %SystemRoot%\SoftwareDistribution\Download folder

	.EXAMPLE
	SoftwareDistributionTask -Register

	.EXAMPLE
	SoftwareDistributionTask -Delete

	.NOTES
	The task will wait until the Windows Updates service finishes running
	The task runs every 90 days
	Current user
#>
function SoftwareDistributionTask
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Register"
		)]
		[switch]
		$Register,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Delete"
		)]
		[switch]
		$Delete
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Register"
		{
			# Persist the Settings notifications to prevent to immediately disappear from Action Center
			if (-not (Test-Path -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel"))
			{
				New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel" -Force
			}
			New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel" -Name ShowInActionCenter -PropertyType DWord -Value 1 -Force

			$SoftwareDistributionTask = @"
(Get-Service -Name wuauserv).WaitForStatus('Stopped', '01:00:00')
Get-ChildItem -Path `$env:SystemRoot\SoftwareDistribution\Download -Recurse -Force | Remove-Item -Recurse -Force

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

[xml]`$ToastTemplate = @"""
<toast duration="""Long""">
	<visual>
		<binding template="""ToastGeneric""">
			<text>$($Localization.TaskNotificationTitle)</text>
			<group>
				<subgroup>
					<text hint-style="""body""" hint-wrap="""true""">$($Localization.SoftwareDistributionTaskNotificationEvent)</text>
				</subgroup>
			</group>
		</binding>
	</visual>
	<audio src="""ms-winsoundevent:notification.default""" />
</toast>
"""@

`$ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::New()
`$ToastXml.LoadXml(`$ToastTemplate.OuterXml)

`$ToastMessage = [Windows.UI.Notifications.ToastNotification]::New(`$ToastXML)
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("""windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel""").Show(`$ToastMessage)
"@

			# Create the "SoftwareDistribution" task
			$Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Hidden -Command $SoftwareDistributionTask"
			$Trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 90 -At 9pm
			$Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
			$Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
			$Parameters = @{
				TaskName    = "SoftwareDistribution"
				TaskPath    = "Sophia Script"
				Principa    = $Principal
				Action      = $Action
				Description = $Localization.FolderTaskDescription -f "%SystemRoot%\SoftwareDistribution\Download"
				Settings    = $Settings
				Trigger     = $Trigger
			}
			Register-ScheduledTask @Parameters -Force
		}
		"Delete"
		{
			Unregister-ScheduledTask -TaskName SoftwareDistribution -Confirm:$false
		}
	}
}

<#
	.SYNOPSIS
	The "Temp" scheduled task for cleaning up the %TEMP% folder

	.PARAMETER Register
	Create the "Temp" scheduled task for cleaning up the %TEMP% folder

	.PARAMETER Delete
	Delete the "Temp" scheduled task for cleaning up the %TEMP% folder

	.EXAMPLE
	TempTask -Register

	.EXAMPLE
	TempTask -Delete

	.NOTES
	The task runs every 60 days
	Current user
#>
function TempTask
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Register"
		)]
		[switch]
		$Register,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Delete"
		)]
		[switch]
		$Delete
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Register"
		{
			$TempTask = @"
Get-ChildItem -Path `$env:TEMP -Recurse -Force | Where-Object {`$_.CreationTime -lt (Get-Date).AddDays(-1)} | Remove-Item -Recurse -Force

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

[xml]`$ToastTemplate = @"""
<toast duration="""Long""">
	<visual>
		<binding template="""ToastGeneric""">
			<text>$($Localization.TaskNotificationTitle)</text>
			<group>
				<subgroup>
					<text hint-style="""body""" hint-wrap="""true""">$($Localization.TempTaskNotificationEvent)</text>
				</subgroup>
			</group>
		</binding>
	</visual>
	<audio src="""ms-winsoundevent:notification.default""" />
</toast>
"""@

`$ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::New()
`$ToastXml.LoadXml(`$ToastTemplate.OuterXml)

`$ToastMessage = [Windows.UI.Notifications.ToastNotification]::New(`$ToastXML)
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("""windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel""").Show(`$ToastMessage)
"@

			# Create the "Temp" task
			$Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Hidden -Command $TempTask"
			$Trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 60 -At 9pm
			$Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
			$Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
			$Parameters = @{
				TaskName    = "Temp"
				TaskPath    = "Sophia Script"
				Principal   = $Principal
				Action      = $Action
				Description = $Localization.FolderTaskDescription -f "%TEMP%"
				Settings    = $Settings
				Trigger     = $Trigger
			}
			Register-ScheduledTask @Parameters -Force
		}
		"Delete"
		{
			Unregister-ScheduledTask -TaskName Temp -Confirm:$false
		}
	}
}
#endregion Scheduled tasks

#region Microsoft Defender & Security
# Enable Controlled folder access and add protected folders
function AddProtectedFolders
{
	$Title = $Localization.ControlledFolderAccess
	$Message = $Localization.ProtectedFoldersRequest
	$Add = $Localization.Add
	$Skip = $Localization.Skip
	$Options = "&$Add", "&$Skip"
	$DefaultChoice = 1

	do
	{
		$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		switch ($Result)
		{
			"0"
			{
				Add-Type -AssemblyName System.Windows.Forms
				$FolderBrowserDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
				$FolderBrowserDialog.Description = $Localization.FolderSelect
				$FolderBrowserDialog.RootFolder = "MyComputer"

				# Focus on open file dialog
				$Focus = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
				$FolderBrowserDialog.ShowDialog($Focus)

				if ($FolderBrowserDialog.SelectedPath)
				{
					Set-MpPreference -EnableControlledFolderAccess Enabled
					Add-MpPreference -ControlledFolderAccessProtectedFolders $FolderBrowserDialog.SelectedPath -Force
					Write-Verbose -Message ("{0}" -f $FolderBrowserDialog.SelectedPath) -Verbose
				}
			}
			"1"
			{
				Write-Verbose -Message $Localization.Skipped -Verbose
			}
		}
	}
	until ($Result -eq 1)
}

# Remove all added protected folders
function RemoveProtectedFolders
{
	if ($null -ne (Get-MpPreference).ControlledFolderAccessProtectedFolders)
	{
		(Get-MpPreference).ControlledFolderAccessProtectedFolders | Format-Table -AutoSize -Wrap
		Remove-MpPreference -ControlledFolderAccessProtectedFolders (Get-MpPreference).ControlledFolderAccessProtectedFolders -Force
		Write-Verbose -Message $Localization.ProtectedFoldersListRemoved -Verbose
	}
}

# Allow an app through Controlled folder access
function AddAppControlledFolder
{
	$Title = $Localization.ControlledFolderAccess
	$Message = $Localization.AppControlledFolderRequest
	$Add = $Localization.Add
	$Skip = $Localization.Skip
	$Options = "&$Add", "&$Skip"
	$DefaultChoice = 1

	do
	{
		$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		switch ($Result)
		{
			"0"
			{
				Add-Type -AssemblyName System.Windows.Forms
				$OpenFileDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
				$OpenFileDialog.Filter = $Localization.EXEFilesFilter
				$OpenFileDialog.InitialDirectory = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
				$OpenFileDialog.Multiselect = $false

				# Focus on open file dialog
				$Focus = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
				$OpenFileDialog.ShowDialog($Focus)

				if ($OpenFileDialog.FileName)
				{
					Add-MpPreference -ControlledFolderAccessAllowedApplications $OpenFileDialog.FileName -Force
					Write-Verbose -Message ("{0}" -f $OpenFileDialog.FileName) -Verbose
				}
			}
			"1"
			{
				Write-Verbose -Message $Localization.Skipped -Verbose
			}
		}
	}
	until ($Result -eq 1)
}

# Remove all allowed apps through Controlled folder access
function RemoveAllowedAppsControlledFolder
{
	if ($null -ne (Get-MpPreference).ControlledFolderAccessAllowedApplications)
	{
		(Get-MpPreference).ControlledFolderAccessAllowedApplications | Format-Table -AutoSize -Wrap
		Remove-MpPreference -ControlledFolderAccessAllowedApplications (Get-MpPreference).ControlledFolderAccessAllowedApplications -Force
		Write-Verbose -Message $Localization.AllowedControlledFolderAppsRemoved -Verbose
	}
}

# Add a folder to the exclusion from Microsoft Defender scanning
function AddDefenderExclusionFolder
{
	$Title = "Microsoft Defender"
	$Message = $Localization.DefenderExclusionFolderRequest
	$Add = $Localization.Add
	$Skip = $Localization.Skip
	$Options = "&$Add", "&$Skip"
	$DefaultChoice = 1

	do
	{
		$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		switch ($Result)
		{
			"0"
			{
				Add-Type -AssemblyName System.Windows.Forms
				$FolderBrowserDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
				$FolderBrowserDialog.Description = $Localization.FolderSelect
				$FolderBrowserDialog.RootFolder = "MyComputer"

				# Focus on open file dialog
				$Focus = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
				$FolderBrowserDialog.ShowDialog($Focus)

				if ($FolderBrowserDialog.SelectedPath)
				{
					Add-MpPreference -ExclusionPath $FolderBrowserDialog.SelectedPath -Force
					Write-Verbose -Message ("{0}" -f $FolderBrowserDialog.SelectedPath) -Verbose
				}
			}
			"1"
			{
				Write-Verbose -Message $Localization.Skipped -Verbose
			}
		}
	}
	until ($Result -eq 1)
}

# Remove all excluded folders from Microsoft Defender scanning
function RemoveDefenderExclusionFolders
{
	if ($null -ne (Get-MpPreference).ExclusionPath)
	{
		$ExcludedFolders = (Get-Item -Path (Get-MpPreference).ExclusionPath -Force -ErrorAction Ignore | Where-Object -FilterScript {$_.Attributes -match "Directory"}).FullName
		$ExcludedFolders | Format-Table -AutoSize -Wrap
		Remove-MpPreference -ExclusionPath $ExcludedFolders -Force
		Write-Verbose -Message $Localization.DefenderExclusionFoldersListRemoved -Verbose
	}
}

# Add a file to the exclusion from Microsoft Defender scanning
function AddDefenderExclusionFile
{
	$Title = "Microsoft Defender"
	$Message = $Localization.AddDefenderExclusionFileRequest
	$Add = $Localization.Add
	$Skip = $Localization.Skip
	$Options = "&$Add", "&$Skip"
	$DefaultChoice = 1

	do
	{
		$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
		switch ($Result)
		{
			"0"
			{
				Add-Type -AssemblyName System.Windows.Forms
				$OpenFileDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
				$OpenFileDialog.Filter = $Localization.AllFilesFilter
				$OpenFileDialog.InitialDirectory = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
				$OpenFileDialog.Multiselect = $false

				# Focus on open file dialog
				$Focus = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
				$OpenFileDialog.ShowDialog($Focus)

				if ($OpenFileDialog.FileName)
				{
					Add-MpPreference -ExclusionPath $OpenFileDialog.FileName -Force
					Write-Verbose -Message ("{0}" -f $OpenFileDialog.FileName) -Verbose
				}
			}
			"1"
			{
				Write-Verbose -Message $Localization.Skipped -Verbose
			}
		}
	}
	until ($Result -eq 1)
}

# Remove all excluded files from Microsoft Defender scanning
function RemoveDefenderExclusionFiles
{
	if ($null -ne (Get-MpPreference).ExclusionPath)
	{
		$ExcludedFiles = (Get-Item -Path (Get-MpPreference).ExclusionPath -Force -ErrorAction Ignore | Where-Object -FilterScript {$_.Attributes -notmatch "Directory"}).FullName
		$ExcludedFiles | Format-Table -AutoSize -Wrap
		Remove-MpPreference -ExclusionPath $ExcludedFiles -Force
		Write-Verbose -Message $Localization.DefenderExclusionFilesRemoved -Verbose
	}
}

<#
	.SYNOPSIS
	Configure Microsoft Defender Exploit Guard network protection

	.PARAMETER Disable
	Disable Microsoft Defender Exploit Guard network protection

	.PARAMETER Enable
	Enable Microsoft Defender Exploit Guard network protection

	.EXAMPLE
	NetworkProtection -Disable

	.EXAMPLE
	NetworkProtection -Enable
	Current user
#>
function NetworkProtection
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			Set-MpPreference -EnableNetworkProtection Disabled
		}
		"Enable"
		{
			Set-MpPreference -EnableNetworkProtection Enabled
		}
	}
}

<#
	.SYNOPSIS
	Configure detection for potentially unwanted applications and block them

	.PARAMETER Disable
	Enable/disable detection for potentially unwanted applications and block them

	.PARAMETER Enable
	Enable/disable detection for potentially unwanted applications and block them

	.EXAMPLE
	PUAppsDetection -Disable

	.EXAMPLE
	PUAppsDetection -Enable
	Current user
#>
function PUAppsDetection
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			Set-MpPreference -PUAProtection Disabled
		}
		"Enable"
		{
			Set-MpPreference -PUAProtection Enabled
		}
	}
}

<#
	.SYNOPSIS
	Configure sandboxing for Microsoft Defender

	.PARAMETER Disable
	Disable sandboxing for Microsoft Defender

	.PARAMETER Enable
	Enable sandboxing for Microsoft Defender

	.EXAMPLE
	DefenderSandbox -Disable

	.EXAMPLE
	DefenderSandbox -Enable

	.NOTES
	There is a bug in KVM with QEMU: enabling this function causes VM to freeze up during the loading phase of Windows
	Current user
#>
function DefenderSandbox
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			setx /M MP_FORCE_USE_SANDBOX 0
		}
		"Enable"
		{
			setx /M MP_FORCE_USE_SANDBOX 1
		}
	}
}

# Dismiss Microsoft Defender offer in the Windows Security about signing in Microsoft account
function DismissMSAccount
{
	New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows Security Health\State" -Name AccountProtection_MicrosoftAccount_Disconnected -PropertyType DWord -Value 1 -Force
}

# Dismiss Microsoft Defender offer in the Windows Security about turning on the SmartScreen filter for Microsoft Edge
function DismissSmartScreenFilter
{
	New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows Security Health\State" -Name AppAndBrowser_EdgeSmartScreenOff -PropertyType DWord -Value 0 -Force
}

<#
	.SYNOPSIS
	Configure events auditing generated when a process is created or starts

	.PARAMETER Disable
	Disable events auditing generated when a process is created or starts

	.PARAMETER Enable
	Enable events auditing generated when a process is created or starts

	.EXAMPLE
	AuditProcess -Disable

	.EXAMPLE
	AuditProcess -Enable

	.NOTES
	Machine-wide
#>
function AuditProcess
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			auditpol /set /subcategory:"{0CCE922B-69AE-11D9-BED3-505054503030}" /success:disable /failure:disable
		}
		"Enable"
		{
			auditpol /set /subcategory:"{0CCE922B-69AE-11D9-BED3-505054503030}" /success:enable /failure:enable
		}
	}
}

<#
	.SYNOPSIS
	Configure command line in process creation events

	.PARAMETER Disable
	Do not include command line in process creation events

	.PARAMETER Enable
	Include command line in process creation events

	.EXAMPLE
	AuditCommandLineProcess -Disable

	.EXAMPLE
	AuditCommandLineProcess -Enable

	.NOTES
	In order this feature to work events auditing ("AuditProcess -Enable" function) will be enabled

	.NOTES
	Machine-wide
#>
function AuditCommandLineProcess
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit -Name ProcessCreationIncludeCmdLine_Enabled -Force -ErrorAction SilentlyContinue
		}
		"Enable"
		{
			# Enable events auditing generated when a process is created or starts
			auditpol /set /subcategory:"{0CCE922B-69AE-11D9-BED3-505054503030}" /success:enable /failure:enable

			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit -Name ProcessCreationIncludeCmdLine_Enabled -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure "Process Creation" Event Viewer Custom View

	.PARAMETER Disable
	Remove "Process Creation" Event Viewer Custom View

	.PARAMETER Enable
	Create "Process Creation" Event Viewer Custom View

	.EXAMPLE
	EventViewerCustomView -Disable

	.EXAMPLE
	EventViewerCustomView -Enable

	.NOTES
	In order this feature to work events auditing ("AuditProcess -Enable" function) and command line in process creation events will be enabled

	.NOTES
	Machine-wide
#>
function EventViewerCustomView
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			Remove-Item -Path "$env:ProgramData\Microsoft\Event Viewer\Views\ProcessCreation.xml" -Force -ErrorAction SilentlyContinue
		}
		"Enable"
		{
			# Enable events auditing generated when a process is created or starts
			auditpol /set /subcategory:"{0CCE922B-69AE-11D9-BED3-505054503030}" /success:enable /failure:enable

			# Include command line in process creation events
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit -Name ProcessCreationIncludeCmdLine_Enabled -PropertyType DWord -Value 1 -Force

			$XML = @"
<ViewerConfig>
	<QueryConfig>
		<QueryParams>
			<UserQuery />
		</QueryParams>
		<QueryNode>
			<Name>$($Localization.EventViewerCustomViewName)</Name>
			<Description>$($Localization.EventViewerCustomViewDescription)</Description>
			<QueryList>
				<Query Id="0" Path="Security">
					<Select Path="Security">*[System[(EventID=4688)]]</Select>
				</Query>
			</QueryList>
		</QueryNode>
	</QueryConfig>
</ViewerConfig>
"@
			if (-not (Test-Path -Path "$env:ProgramData\Microsoft\Event Viewer\Views"))
			{
				New-Item -Path "$env:ProgramData\Microsoft\Event Viewer\Views" -ItemType Directory -Force
			}

			# Saving ProcessCreation.xml in UTF-8 encoding
			Set-Content -Path "$env:ProgramData\Microsoft\Event Viewer\Views\ProcessCreation.xml" -Value $XML -Encoding Default -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure logging for all Windows PowerShell modules

	.PARAMETER Disable
	Disable logging for all Windows PowerShell modules

	.PARAMETER Enable
	Enable logging for all Windows PowerShell modules

	.EXAMPLE
	PowerShellModulesLogging -Disable

	.EXAMPLE
	PowerShellModulesLogging -Enable

	.NOTES
	Machine-wide
#>
function PowerShellModulesLogging
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging -Name EnableModuleLogging -Force -ErrorAction SilentlyContinue
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames -Name * -Force -ErrorAction SilentlyContinue
		}
		"Enable"
		{
			if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames))
			{
				New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames -Force
			}
			New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging -Name EnableModuleLogging -PropertyType DWord -Value 1 -Force
			New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames -Name * -PropertyType String -Value * -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure logging for all PowerShell scripts input to the Windows PowerShell event log

	.PARAMETER Disable
	Disable logging for all PowerShell scripts input to the Windows PowerShell event log

	.PARAMETER Enable
	Enable logging for all PowerShell scripts input to the Windows PowerShell event log

	.EXAMPLE
	PowerShellScriptsLogging -Disable

	.EXAMPLE
	PowerShellScriptsLogging -Enable

	.NOTES
	Machine-wide
#>
function PowerShellScriptsLogging
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Name EnableScriptBlockLogging -Force -ErrorAction SilentlyContinue
		}
		"Enable"
		{
			if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging))
			{
				New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Force
			}
			New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Name EnableScriptBlockLogging -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure apps and files checking within Microsofot Defender SmartScreen

	.PARAMETER Disable
	Disable apps and files checking within Microsofot Defender SmartScreen

	.PARAMETER Enable
	Enable apps and files checking within Microsofot Defender SmartScreen

	.EXAMPLE
	AppsSmartScreen -Disable

	.EXAMPLE
	AppsSmartScreen -Enable

	.NOTES
	Machine-wide
#>
function AppsSmartScreen
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name SmartScreenEnabled -PropertyType String -Value Off -Force
		}
		"Enable"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name SmartScreenEnabled -PropertyType String -Value Warn -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the Attachment Manager marking files that have been downloaded from the Internet as unsafe

	.PARAMETER Disable
	Disable the Attachment Manager marking files that have been downloaded from the Internet as unsafe

	.PARAMETER Enable
	Enable the Attachment Manager marking files that have been downloaded from the Internet as unsafe

	.EXAMPLE
	SaveZoneInformation -Disable

	.EXAMPLE
	SaveZoneInformation -Enable

	.NOTES
	Current user
#>
function SaveZoneInformation
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments -Name SaveZoneInformation -PropertyType DWord -Value 1 -Force
		}
		"Enable"
		{
			Remove-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Attachments -Name SaveZoneInformation -Force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.SYNOPSIS
	Configure Windows Script Host

	.PARAMETER Disable
	Disable Windows Script Host

	.PARAMETER Enable
	Enable Windows Script Host

	.EXAMPLE
	WindowsScriptHost -Disable

	.EXAMPLE
	WindowsScriptHost -Enable

	.NOTES
	Blocks WSH from executing .js and .vbs files

	.NOTES
	Current user
#>
function WindowsScriptHost
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			if (-not (Test-Path -Path "HKCU:\SOFTWARE\Microsoft\Windows Script Host\Settings"))
			{
				New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Force
			}
			New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Name Enabled -PropertyType DWord -Value 0 -Force
		}
		"Enable"
		{
			Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Name Enabled -Force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.SYNOPSIS
	Configure Windows Sandbox

	.PARAMETER Disable
	Disable Windows Sandbox

	.PARAMETER Enable
	Enable Windows Sandbox

	.EXAMPLE
	WindowsSandbox -Disable

	.EXAMPLE
	WindowsSandbox -Enable

	.NOTES
	Current user
#>
function WindowsSandbox
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -eq "Professional" -or $_.Edition -like "Enterprise*"})
			{
				# Checking whether x86 virtualization is enabled in the firmware
				if ((Get-CimInstance -ClassName CIM_Processor).VirtualizationFirmwareEnabled -eq $true)
				{
					Disable-WindowsOptionalFeature -FeatureName Containers-DisposableClientVM -Online -NoRestart
				}
				else
				{
					try
					{
						# Determining whether Hyper-V is enabled
						if ((Get-CimInstance -ClassName CIM_ComputerSystem).HypervisorPresent -eq $true)
						{
							Disable-WindowsOptionalFeature -FeatureName Containers-DisposableClientVM -Online -NoRestart
						}
					}
					catch [System.Exception]
					{
						Write-Error -Message $Localization.EnableHardwareVT -ErrorAction SilentlyContinue
					}
				}
			}
		}
		"Enable"
		{
			if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -eq "Professional" -or $_.Edition -like "Enterprise*"})
			{
				# Checking whether x86 virtualization is enabled in the firmware
				if ((Get-CimInstance -ClassName CIM_Processor).VirtualizationFirmwareEnabled -eq $true)
				{
					Enable-WindowsOptionalFeature -FeatureName Containers-DisposableClientVM -All -Online -NoRestart
				}
				else
				{
					try
					{
						# Determining whether Hyper-V is enabled
						if ((Get-CimInstance -ClassName CIM_ComputerSystem).HypervisorPresent -eq $true)
						{
							Enable-WindowsOptionalFeature -FeatureName Containers-DisposableClientVM -All -Online -NoRestart
						}
					}
					catch [System.Exception]
					{
						Write-Error -Message $Localization.EnableHardwareVT -ErrorAction SilentlyContinue
					}
				}
			}
		}
	}
}
#endregion Microsoft Defender & Security

#region Context menu
<#
	.SYNOPSIS
	Configure the "Extract all" item in Windows Installer (.msi) context menu

	.PARAMETER Remove
	Remove the "Extract all" item to Windows Installer (.msi) context menu

	.PARAMETER Add
	Add the "Extract all" item to Windows Installer (.msi) context menu

	.EXAMPLE
	MSIExtractContext -Remove

	.EXAMPLE
	MSIExtractContext -Add

	.NOTES
	Current user
#>
function MSIExtractContext
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Remove"
		)]
		[switch]
		$Remove,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Add"
		)]
		[switch]
		$Add
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Remove"
		{
			Remove-Item -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Recurse -Force -ErrorAction SilentlyContinue
		}
		"Add"
		{
			if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command))
			{
				New-Item -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command -Force
			}
			$Value = "{0}" -f 'msiexec.exe /a "%1" /qb TARGETDIR="%1 extracted"'
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command -Name "(default)" -PropertyType String -Value $Value -Force
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Name MUIVerb -PropertyType String -Value "@shell32.dll,-37514" -Force
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Name Icon -PropertyType String -Value "shell32.dll,-16817" -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the "Install" item in the .cab archives context menu

	.PARAMETER Remove
	Remove the "Install" item to the .cab archives context menu

	.PARAMETER Add
	Add the "Install" item to the .cab archives context menu

	.EXAMPLE
	CABInstallContext -Remove

	.EXAMPLE
	CABInstallContext -Add

	.NOTES
	Current user
#>
function CABInstallContext
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Remove"
		)]
		[switch]
		$Remove,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Add"
		)]
		[switch]
		$Add
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Remove"
		{
			Remove-Item -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command -Recurse -Force -ErrorAction SilentlyContinue
		}
		"Add"
		{
			if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command))
			{
				New-Item -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command -Force
			}
			$Value = "{0}" -f "cmd /c DISM.exe /Online /Add-Package /PackagePath:`"%1`" /NoRestart & pause"
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command -Name "(default)" -PropertyType String -Value $Value -Force
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs -Name MUIVerb -PropertyType String -Value "@shell32.dll,-10210" -Force
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs -Name HasLUAShield -PropertyType String -Value "" -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the "Run as different user" item in the .exe files types context menu

	.PARAMETER Remove
	Remove the "Run as different user" item to the .exe files types context menu

	.PARAMETER Add
	Add the "Run as different user" item to the .exe files types context menu

	.EXAMPLE
	RunAsDifferentUserContext -Remove

	.EXAMPLE
	RunAsDifferentUserContext -Add

	.NOTES
	Current user
#>
function RunAsDifferentUserContext
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Remove"
		)]
		[switch]
		$Remove,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Add"
		)]
		[switch]
		$Add
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Remove"
		{
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\exefile\shell\runasuser -Name Extended -PropertyType String -Value "" -Force
		}
		"Add"
		{
			Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\exefile\shell\runasuser -Name Extended -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	Configure the "Cast to Device" item in the context menu

	.PARAMETER Hide
	Hide the "Cast to Device" item from the context menu

	.PARAMETER Show
	Show the "Cast to Device" item from the context menu

	.EXAMPLE
	CastToDeviceContext -Hide

	.EXAMPLE
	CastToDeviceContext -Show

	.NOTES
	Current user
#>
function CastToDeviceContext
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"))
			{
				New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Force
			}
			New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" -PropertyType String -Value "Play to menu" -Force
		}
		"Show"
		{
			Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" -Force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.SYNOPSIS
	Configure the "Share" item in the context menu

	.PARAMETER Hide
	Hide the "Share" item from the context menu

	.PARAMETER Show
	Show the "Share" item in the context menu

	.EXAMPLE
	ShareContext -Hide

	.EXAMPLE
	ShareContext -Show

	.NOTES
	Current user
#>
function ShareContext
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"))
			{
				New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Force
			}
			New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{E2BF9676-5F8F-435C-97EB-11607A5BEDF7}" -PropertyType String -Value "" -Force
		}
		"Show"
		{
			Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{E2BF9676-5F8F-435C-97EB-11607A5BEDF7}" -Force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.SYNOPSIS
	Configure the "Edit with Paint 3D" item in the context menu

	.PARAMETER Hide
	Hide the "Edit with Paint 3D" item from the context menu

	.PARAMETER Show
	Show the "Edit with Paint 3D" item in the context menu

	.EXAMPLE
	EditWithPaint3DContext -Hide

	.EXAMPLE
	EditWithPaint3DContext -Show

	.NOTES
	Current user
#>
function EditWithPaint3DContext
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			$Extensions = @(".bmp", ".gif", ".jpe", ".jpeg", ".jpg", ".png", ".tif", ".tiff")
			foreach ($extension in $extensions)
			{
				New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\$Extension\Shell\3D Edit" -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
			}
		}
		"Show"
		{
			$Extensions = @(".bmp", ".gif", ".jpe", ".jpeg", ".jpg", ".png", ".tif", ".tiff")
			foreach ($Extension in $Extensions)
			{
				Remove-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\$Extension\Shell\3D Edit" -Name ProgrammaticAccessOnly -Force -ErrorAction SilentlyContinue
			}
		}
	}
}

<#
	.SYNOPSIS
	Configure the "Edit with Photos" item in the context menu

	.PARAMETER Hide
	Hide the "Edit with Photos" item from the context menu

	.PARAMETER Show
	Show the "Edit with Photos" item in the context menu

	.EXAMPLE
	EditWithPhotosContext -Hide

	.EXAMPLE
	EditWithPhotosContext -Show

	.NOTES
	Current user
#>
function EditWithPhotosContext
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			if (Get-AppxPackage -Name Microsoft.Windows.Photos)
			{
				New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellEdit -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
			}
		}
		"Show"
		{
			if (Get-AppxPackage -Name Microsoft.Windows.Photos)
			{
				Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellEdit -Name ProgrammaticAccessOnly -Force -ErrorAction SilentlyContinue
			}
		}
	}
}

<#
	.SYNOPSIS
	Configure the "Create a new video" item in the context menu

	.PARAMETER Hide
	Hide the "Create a new video" item from the context menu

	.PARAMETER Show
	Show the "Create a new video" item in the context menu

	.EXAMPLE
	CreateANewVideoContext -Hide

	.EXAMPLE
	CreateANewVideoContext -Show

	.NOTES
	Current user
#>
function CreateANewVideoContext
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			if (Get-AppxPackage -Name Microsoft.Windows.Photos)
			{
				New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellCreateVideo -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
			}
		}
		"Show"
		{
			if (Get-AppxPackage -Name Microsoft.Windows.Photos)
			{
				Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellCreateVideo -Name ProgrammaticAccessOnly -Force -ErrorAction SilentlyContinue
			}
		}
	}
}

<#
	.SYNOPSIS
	Configure the "Edit" item in the images context menu

	.PARAMETER Hide
	Hide the "Edit" item from the images context menu

	.PARAMETER Show
	Show the "Edit" item from the images context menu

	.EXAMPLE
	ImagesEditContext -Hide

	.EXAMPLE
	ImagesEditContext -Show

	.NOTES
	Current user
#>
function ImagesEditContext
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			if ((Get-WindowsCapability -Online -Name "Microsoft.Windows.MSPaint*").State -eq "Installed")
			{
				New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\edit -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
			}
		}
		"Show"
		{
			if ((Get-WindowsCapability -Online -Name "Microsoft.Windows.MSPaint*").State -eq "Installed")
			{
				Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\edit -Name ProgrammaticAccessOnly -Force -ErrorAction SilentlyContinue
			}
		}
	}
}

<#
	.SYNOPSIS
	Configure the "Print" item in the .bat and .cmd context menu

	.PARAMETER Hide
	Hide the "Print" item from the .bat and .cmd context menu

	.PARAMETER Show
	Show the "Print" item in the .bat and .cmd context menu

	.EXAMPLE
	PrintCMDContext -Hide

	.EXAMPLE
	PrintCMDContext -Show

	.NOTES
	Current user
#>
function PrintCMDContext
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\batfile\shell\print -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\cmdfile\shell\print -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
		}
		"Show"
		{
			Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\batfile\shell\print -Name ProgrammaticAccessOnly -Force -ErrorAction SilentlyContinue
			Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\cmdfile\shell\print -Name ProgrammaticAccessOnly -Force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.SYNOPSIS
	Configure the "Include in Library" item in the context menu

	.PARAMETER Hide
	Hide the "Include in Library" item from the context menu

	.PARAMETER Show
	Show the "Include in Library" item in the context menu

	.EXAMPLE
	IncludeInLibraryContext -Hide

	.EXAMPLE
	IncludeInLibraryContext -Show

	.NOTES
	Current user
#>
function IncludeInLibraryContext
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Folder\shellex\ContextMenuHandlers\Library Location" -Name "(default)" -PropertyType String -Value "-{3dad6c5d-2167-4cae-9914-f99e41c12cfa}" -Force
		}
		"Show"
		{
			New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Folder\shellex\ContextMenuHandlers\Library Location" -Name "(default)" -PropertyType String -Value "{3dad6c5d-2167-4cae-9914-f99e41c12cfa}" -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the "Send to" item in the folders context menu

	.PARAMETER Hide
	Hide the "Send to" item from the folders context menu

	.PARAMETER Show
	Show the "Send to" item in the folders context menu

	.EXAMPLE
	SendToContext -Hide

	.EXAMPLE
	SendToContext -Show

	.NOTES
	Current user
#>
function SendToContext
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo -Name "(default)" -PropertyType String -Value "-{7BA4C740-9E81-11CF-99D3-00AA004AE837}" -Force
		}
		"Show"
		{
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo -Name "(default)" -PropertyType String -Value "{7BA4C740-9E81-11CF-99D3-00AA004AE837}" -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the "Turn on BitLocker" item in the context menu

	.PARAMETER Hide
	Hide the "Turn on BitLocker" item from the context menu

	.PARAMETER Show
	Show the "Turn on BitLocker" item in the context menu

	.EXAMPLE
	BitLockerContext -Hide

	.EXAMPLE
	BitLockerContext -Show

	.NOTES
	Current user
#>
function BitLockerContext
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -eq "Professional" -or $_.Edition -like "Enterprise*"})
			{
				New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\encrypt-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
				New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\encrypt-bde-elev -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
				New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\manage-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
				New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\resume-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
				New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\resume-bde-elev -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
				New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\unlock-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
			}
		}
		"Show"
		{
			if (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -eq "Professional" -or $_.Edition -like "Enterprise*"})
			{
				Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\encrypt-bde -Name ProgrammaticAccessOnly -Force -ErrorAction SilentlyContinue
				Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\encrypt-bde-elev -Name ProgrammaticAccessOnly -Force -ErrorAction SilentlyContinue
				Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\manage-bde -Name ProgrammaticAccessOnly -Force -ErrorAction SilentlyContinue
				Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\resume-bde -Name ProgrammaticAccessOnly -Force -ErrorAction SilentlyContinue
				Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\resume-bde-elev -Name ProgrammaticAccessOnly -Force -ErrorAction SilentlyContinue
				Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\unlock-bde -Name ProgrammaticAccessOnly -Force -ErrorAction SilentlyContinue
			}
		}
	}
}

<#
	.SYNOPSIS
	Configure the "Bitmap image" item in the "New" context menu

	.PARAMETER Remove
	Remove the "Bitmap image" item from the "New" context menu

	.PARAMETER Add
	Add the "Bitmap image" item to the "New" context menu

	.EXAMPLE
	BitmapImageNewContext -Remove

	.EXAMPLE
	BitmapImageNewContext -Add

	.NOTES
	Current user
#>
function BitmapImageNewContext
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Remove"
		)]
		[switch]
		$Remove,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Add"
		)]
		[switch]
		$Add
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Remove"
		{
			if ((Get-WindowsCapability -Online -Name "Microsoft.Windows.MSPaint*").State -eq "Installed")
			{
				Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.bmp\ShellNew -Force -ErrorAction SilentlyContinue
			}
		}
		"Add"
		{
			if ((Get-WindowsCapability -Online -Name "Microsoft.Windows.MSPaint*").State -eq "Installed")
			{
				if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\.bmp\ShellNew))
				{
					New-Item -Path Registry::HKEY_CLASSES_ROOT\.bmp\ShellNew -Force
				}
				New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\.bmp\ShellNew -Name ItemName -PropertyType ExpandString -Value "@%systemroot%\system32\mspaint.exe,-59414" -Force
				New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\.bmp\ShellNew -Name NullFile -PropertyType String -Value "" -Force
			}
			else
			{
				try
				{
					if ((Invoke-WebRequest -Uri https://www.google.com -UseBasicParsing -DisableKeepAlive -Method Head).StatusDescription)
					{
						Get-WindowsCapability -Online -Name "Microsoft.Windows.MSPaint*" | Add-WindowsCapability -Online
					}
				}
				catch [System.Net.WebException]
				{
					Write-Warning -Message $Localization.NoInternetConnection
					Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue
					return
				}
			}
		}
	}
}

<#
	.SYNOPSIS
	Configure the "Rich Text Document" item in the "New" context menu

	.PARAMETER Remove
	Remove the "Rich Text Document" item from the "New" context menu

	.PARAMETER Add
	Add the "Rich Text Document" item to the "New" context menu

	.EXAMPLE
	RichTextDocumentNewContext -Remove

	.EXAMPLE
	RichTextDocumentNewContext -Add

	.NOTES
	Current user
#>
function RichTextDocumentNewContext
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Remove"
		)]
		[switch]
		$Remove,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Add"
		)]
		[switch]
		$Add
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Remove"
		{
			if ((Get-WindowsCapability -Online -Name "Microsoft.Windows.WordPad*").State -eq "Installed")
			{
				Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.rtf\ShellNew -Force -ErrorAction Ignore
			}
		}
		"Add"
		{
			if ((Get-WindowsCapability -Online -Name "Microsoft.Windows.WordPad*").State -eq "Installed")
			{
				if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\.rtf\ShellNew))
				{
					New-Item -Path Registry::HKEY_CLASSES_ROOT\.rtf\ShellNew -Force
				}
				New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\.rtf\ShellNew -Name Data -PropertyType String -Value "{\rtf1}" -Force
				New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\.rtf\ShellNew -Name ItemName -PropertyType ExpandString -Value "@%ProgramFiles%\Windows NT\Accessories\WORDPAD.EXE,-213" -Force
			}
			else
			{
				try
				{
					if ((Invoke-WebRequest -Uri https://www.google.com -UseBasicParsing -DisableKeepAlive -Method Head).StatusDescription)
					{
						Get-WindowsCapability -Online -Name "Microsoft.Windows.WordPad*" | Add-WindowsCapability -Online
					}
				}
				catch [System.Net.WebException]
				{
					Write-Warning -Message $Localization.NoInternetConnection
					Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue
					return
				}
			}
		}
	}
}

<#
	.SYNOPSIS
	Configure the "Compressed (zipped) Folder" item in the "New" context menu

	.PARAMETER Remove
	Remove the "Compressed (zipped) Folder" item from the "New" context menu

	.PARAMETER Add
	Add the "Compressed (zipped) Folder" item to the "New" context menu

	.EXAMPLE
	CompressedFolderNewContext -Remove

	.EXAMPLE
	CompressedFolderNewContext -Add

	.NOTES
	Current user
#>
function CompressedFolderNewContext
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Remove"
		)]
		[switch]
		$Remove,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Add"
		)]
		[switch]
		$Add
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Remove"
		{
			Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew -Force -ErrorAction Ignore
		}
		"Add"
		{
			if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew))
			{
				New-Item -Path Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew -Force
			}
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew -Name Data -PropertyType Binary -Value ([byte[]](80,75,5,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)) -Force
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew -Name ItemName -PropertyType ExpandString -Value "@%SystemRoot%\system32\zipfldr.dll,-10194" -Force
		}
	}
}

<#
	.SYNOPSIS
	Configure the "Open", "Print", and "Edit" context menu items for more than 15 items selected

	.PARAMETER Enable
	Enable the "Open", "Print", and "Edit" context menu items for more than 15 items selected

	.PARAMETER Disable
	Disable the "Open", "Print", and "Edit" context menu items for more than 15 items selected

	.EXAMPLE
	MultipleInvokeContext -Enable

	.EXAMPLE
	MultipleInvokeContext -Disable

	.NOTES
	Current user
#>
function MultipleInvokeContext
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Enable"
		)]
		[switch]
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name MultipleInvokePromptMinimum -PropertyType DWord -Value 300 -Force
		}
		"Disable"
		{
			Remove-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name MultipleInvokePromptMinimum -Force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.SYNOPSIS
	Configure the "Look for an app in the Microsoft Store" item in the "Open with" dialog

	.PARAMETER Hide
	Hide the "Look for an app in the Microsoft Store" item in the "Open with" dialog

	.PARAMETER Show
	Show the "Look for an app in the Microsoft Store" item in the "Open with" dialog

	.EXAMPLE
	UseStoreOpenWith -Hide

	.EXAMPLE
	UseStoreOpenWith -Show

	.NOTES
	Current user
#>
function UseStoreOpenWith
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer))
			{
				New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
			}
			New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name NoUseStoreOpenWith -PropertyType DWord -Value 1 -Force
		}
		"Show"
		{
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name NoUseStoreOpenWith -Force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.SYNOPSIS
	Configure the "Previous Versions" tab in the files and folders context menu and the "Restore previous versions" context menu item

	.PARAMETER Hide
	Hide the "Previous Versions" tab from the files and folders context menu and the "Restore previous versions" context menu item

	.PARAMETER Show
	Show the "Previous Versions" tab from the files and folders context menu and the "Restore previous versions" context menu item

	.EXAMPLE
	PreviousVersionsPage -Hide

	.EXAMPLE
	PreviousVersionsPage -Show

	.NOTES
	Current user
#>
function PreviousVersionsPage
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Hide"
		)]
		[switch]
		$Hide,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Show"
		)]
		[switch]
		$Show
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Hide"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name NoPreviousVersionsPage -PropertyType DWord -Value 1 -Force
		}
		"Show"
		{
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name NoPreviousVersionsPage -Force -ErrorAction SilentlyContinue
		}
	}
}
#endregion Context menu

#region Refresh
function Refresh
{
	$UpdateExplorer = @{
		Namespace = "WinAPI"
		Name = "UpdateExplorer"
		Language = "CSharp"
		MemberDefinition = @"
private static readonly IntPtr HWND_BROADCAST = new IntPtr(0xffff);
private const int WM_SETTINGCHANGE = 0x1a;
private const int SMTO_ABORTIFHUNG = 0x0002;

[DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = false)]
static extern bool SendNotifyMessage(IntPtr hWnd, uint Msg, IntPtr wParam, string lParam);
[DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = false)]
private static extern IntPtr SendMessageTimeout(IntPtr hWnd, int Msg, IntPtr wParam, string lParam, int fuFlags, int uTimeout, IntPtr lpdwResult);
[DllImport("shell32.dll", CharSet = CharSet.Auto, SetLastError = false)]
private static extern int SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2);
public static void Refresh()
{
	// Update desktop icons
	SHChangeNotify(0x8000000, 0x1000, IntPtr.Zero, IntPtr.Zero);

	// Update environment variables
	SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, IntPtr.Zero, null, SMTO_ABORTIFHUNG, 100, IntPtr.Zero);

	// Update taskbar
	SendNotifyMessage(HWND_BROADCAST, WM_SETTINGCHANGE, IntPtr.Zero, "TraySettings");
}

private static readonly IntPtr hWnd = new IntPtr(65535);
private const int Msg = 273;
// Virtual key ID of the F5 in File Explorer
private static readonly UIntPtr UIntPtr = new UIntPtr(41504);

[DllImport("user32.dll", SetLastError=true)]
public static extern int PostMessageW(IntPtr hWnd, uint Msg, UIntPtr wParam, IntPtr lParam);
public static void PostMessage()
{
	// Simulate pressing F5 to refresh the desktop
	PostMessageW(hWnd, Msg, UIntPtr, IntPtr.Zero);
}
"@
	}
	if (-not ("WinAPI.UpdateExplorer" -as [type]))
	{
		Add-Type @UpdateExplorer
	}

	# Simulate pressing F5 to refresh the desktop
	[WinAPI.UpdateExplorer]::PostMessage()

	# Refresh desktop icons, environment variables, taskbar
	[WinAPI.UpdateExplorer]::Refresh()

	# Restart the Start menu
	Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction Ignore

	# Turn on Controlled folder access if it was turned off
	if ($Script:ControlledFolderAccess)
	{
		Set-MpPreference -EnableControlledFolderAccess Enabled
	}

	Write-Warning -Message $Localization.RestartWarning

	.NOTES
	Load The WinRT.Runtime.dll and Microsoft.Windows.SDK.NET.dll assemblies to the current session in order to get localized UWP apps names
	CsWinRT v1.2.5
	Microsoft.Windows.SDK.NET 10.0.19041.16

	.LINK
	https://github.com/microsoft/CsWinRT
	https://www.nuget.org/packages/Microsoft.Windows.SDK.NET.Ref

	Add-Type -AssemblyName "$PSScriptRoot\Libraries\WinRT.Runtime.dll"
	Add-Type -AssemblyName "$PSScriptRoot\Libraries\Microsoft.Windows.SDK.NET.dll"

	[xml]$ToastTemplate = @"
<toast duration="Long" scenario="reminder">
	<visual>
		<binding template="ToastGeneric">
			<text>$($Localization.TelegramTitle)</text>
			<group>
				<subgroup>
					<text hint-style="body" hint-wrap="true">https://t.me/sophia_chat</text>
				</subgroup>
			</group>
		</binding>
	</visual>
	<audio src="ms-winsoundevent:notification.default" />
	<actions>
		<action arguments="https://t.me/sophia_chat" content="$($Localization.Open)" activationType="protocol"/>
		<action arguments="dismiss" content="" activationType="system"/>
	</actions>
</toast>
"@

	$ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::New()
	$ToastXml.LoadXml($ToastTemplate.OuterXml)

	$ToastMessage = [Windows.UI.Notifications.ToastNotification]::New($ToastXML)
	[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel").Show($ToastMessage)
}
#endregion Refresh

# Errors output
function Errors
{
	if ($Global:Error)
	{
		($Global:Error | ForEach-Object -Process {
			[PSCustomObject]@{
				$Localization.ErrorsLine = $_.InvocationInfo.ScriptLineNumber
				$Localization.ErrorsFile = Split-Path -Path $PSCommandPath -Leaf
				$Localization.ErrorsMessage = $_.Exception.Message
			}
		} | Sort-Object -Property Line | Format-Table -AutoSize -Wrap | Out-String).Trim()
	}
}
