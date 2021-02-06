<#
	.SYNOPSIS
	"Windows 10 Sophia Script" is a PowerShell module for Windows 10 fine-tuning and automating the routine tasks

	Version: v5.4
	Date: 04.02.2021
	Copyright (c) 2015–2021 farag & oZ-Zo

	Thanks to all https://forum.ru-board.com members involved

	.DESCRIPTION
	Supported Windows 10 versions: 2004 (20H1)/20H2 (2009), 19041/19042, Home/Pro/Enterprise, x64

	Running the script is best done on a fresh install because running it on wrong tweaked system may result in errors occurring

	PowerShell must be run with elevated privileges
	Set execution policy to be able to run scripts only in the current PowerShell session:
		Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

	.EXAMPLE
	PS C:\> .\Sophia.ps1

	.NOTES
	https://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15
	https://habr.com/post/521202/
	https://forums.mydigitallife.net/threads/powershell-windows-10-sophia-script.81675/
	https://www.reddit.com/r/PowerShell/comments/go2n5v/powershell_script_setup_windows_10/

	.LINK
	https://github.com/farag2/Windows-10-Sophia-Script
#>

#region Checkings
function Checkings
{
	Set-StrictMode -Version Latest

	# Сlear the $Error variable
	# Очистка переменной $Error
	$Global:Error.Clear()

	# Detect the OS bitness
	# Определить разрядность ОС
	switch ([System.Environment]::Is64BitOperatingSystem)
	{
		$false
		{
			Write-Warning -Message $Localization.UnsupportedOSBitness
			exit
		}
	}

	# Detect the OS build version
	# Определить номер билда ОС
	switch ((Get-CimInstance -ClassName Win32_OperatingSystem).BuildNumber -ge 19041)
	{
		$false
		{
			Write-Warning -Message $Localization.UnsupportedOSBuild
			exit
		}
	}

	# Checking whether the current module version is the latest
	# Проверка: используется ли последняя версия модуля
	try
	{
		$LatestRelease = ((Invoke-RestMethod -Uri "https://api.github.com/repos/farag2/Windows-10-Sophia-Script/releases") | Where-Object -FilterScript {$_.prerelease -eq $false}).tag_name.Replace("v","")[0]
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
	# Разблокировать все файлы в папке, удалив альтернативный потоки данных Zone.Identifier со значением "3"
	Get-ChildItem -Path $PSScriptRoot -Recurse -Force | Unblock-File -Confirm:$false

	# Turn off Controlled folder access to let the script proceed
	# Отключить контролируемый доступ к папкам
	switch ((Get-MpPreference).EnableControlledFolderAccess)
	{
		"1"
		{
			Write-Warning -Message $Localization.ControlledFolderAccessDisabled
			$Script:ControlledFolderAccess = $true
			Set-MpPreference -EnableControlledFolderAccess Disabled

			# Open "Ransomware protection" page
			# Открыть раздел "Защита от программ-шантажистов"
			Start-Process -FilePath windowsdefender://RansomwareProtection
		}
		"0"
		{
			$Script:ControlledFolderAccess = $false
		}
	}
}
#endregion Checkings

<#
	Enable script logging. The log will be being recorded into the script folder
	To stop logging just close the console or type "Stop-Transcript"

	Включить логирование работы скрипта. Лог будет записываться в папку скрипта
	Чтобы остановить логгирование, закройте консоль или наберите "Stop-Transcript"
#>
function Logging
{
	$TrascriptFilename = "Log-$((Get-Date).ToString("dd.MM.yyyy-HH-mm"))"
	Start-Transcript -Path $PSScriptRoot\$TrascriptFilename.txt -Force
}

# Create a restore point for the system drive
# Создать точку восстановления для системного диска
function CreateRestorePoint
{
	$SystemDriveUniqueID = (Get-Volume | Where-Object {$_.DriveLetter -eq "$($env:SystemDrive[0])"}).UniqueID
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
	# Никогда не пропускать создание точек восстановления
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name SystemRestorePointCreationFrequency -PropertyType DWord -Value 0 -Force

	Checkpoint-Computer -Description "Windows 10 Sophia Script" -RestorePointType MODIFY_SETTINGS

	# Revert the System Restore checkpoint creation frequency to 1440 minutes
	# Вернуть частоту создания точек восстановления на 1440 минут
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name SystemRestorePointCreationFrequency -PropertyType DWord -Value 1440 -Force

	# Turn off System Protection for the system drive if it was turned off without deleting existing restore points
	# Отключить защиту системы для диска C:\, если был отключен, не удаляя точки восстановления
	if ($ComputerRestorePoint)
	{
		Disable-ComputerRestore -Drive $env:SystemDrive
	}
}

#region Privacy & Telemetry
<#
	.SYNOPSIS
	Disable/enable the DiagTrack service, firewall rule for Unified Telemetry Client Outbound Traffic and block connection
	Отключить/включить службу DiagTrack, правила брандмауэра для исходящего трафик клиента единой телеметрии и заблокировать соединение

	.PARAMETER Disable
	Disable the DiagTrack service, firewall rule for Unified Telemetry Client Outbound Traffic and block connection
	Отключить службу DiagTrack, правила брандмауэра для исходящего трафик клиента единой телеметрии и заблокировать соединение

	.PARAMETER Enable
	Enable the DiagTrack service, firewall rule for Unified Telemetry Client Outbound Traffic and allow connection
	Включить службу DiagTrack, правила брандмауэра для исходящего трафик клиента единой телеметрии и разрешить соединение

	.EXAMPLE
	DiagTrackService -Disable

	.EXAMPLE
	DiagTrackService -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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

			# Enable firewall rule for Unified Telemetry Client Outbound Traffic and allow connection
			# Включить правила брандмауэра для исходящего трафика клиента единой телеметрии и разрешить соединение
			Get-NetFirewallRule -Group DiagTrack | Set-NetFirewallRule -Enabled True -Action Allow
		}
		"Disable"
		{
			Get-Service -Name DiagTrack | Stop-Service -Force
			Get-Service -Name DiagTrack | Set-Service -StartupType Disabled

			# Disable firewall rule for Unified Telemetry Client Outbound Traffic and block connection
			# Отключить правила брандмауэра для исходящего трафик клиента единой телеметрии и заблокировать соединение
			Get-NetFirewallRule -Group DiagTrack | Set-NetFirewallRule -Enabled False -Action Block
		}
	}
}

<#
	.SYNOPSIS
	Set the OS level of diagnostic data gathering to minimum/default
	Установить уровень сбора диагностических сведений ОС на минимальный/по умолчанию

	.PARAMETER Minimal
	Set the OS level of diagnostic data gathering to minimum
	Установить уровень сбора диагностических сведений ОС на минимальный

	.PARAMETER Default
	Set the OS level of diagnostic data gathering to minimum
	Установить уровень сбора диагностических сведений ОС на минимальный

	.EXAMPLE
	DiagnosticDataLevel -Minimal

	.EXAMPLE
	DiagnosticDataLevel -Default
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
				# Optional diagnostic data
				# Необязательные диагностические данные
				New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 0 -Force
			}
			else
			{
				# Required diagnostic data
				# Обязательные диагностические данные
				New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 1 -Force
			}
		}
		"Default"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 3 -Force
		}
	}
}

<#
	.SYNOPSIS
	Turn off/turn on Windows Error Reporting for the current user
	Отключить/включить отчеты об ошибках Windows для текущего пользователя

	.PARAMETER Disable
	Turn off Windows Error Reporting for the current user
	Отключить отчеты об ошибках Windows для текущего пользователя

	.PARAMETER Enable
	Turn on Windows Error Reporting for the current user
	Включить отчеты об ошибках Windows для текущего пользователя

	.EXAMPLE
	ErrorReporting -Disable

	.EXAMPLE
	ErrorReporting -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
			if ((Get-WindowsEdition -Online).Edition -notmatch "Core*")
			{
				Get-ScheduledTask -TaskName QueueReporting | Disable-ScheduledTask
				New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name Disabled -PropertyType DWord -Value 1 -Force
			}
		}
		"Enable"
		{
			Get-ScheduledTask -TaskName QueueReporting | Enable-ScheduledTask
			Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name Disabled -Force -ErrorAction SilentlyContinue
		}
	}
}

<#
	.SYNOPSIS
	Change Windows feedback frequency to "Never"/"Automatically" for the current user
	Изменить частоту формирования отзывов на "Никогда"/"Автоматически" для текущего пользователя

	.PARAMETER Disable
	Change Windows feedback frequency to "Never" for the current user
	Изменить частоту формирования отзывов на "Никогда" для текущего пользователя

	.PARAMETER Enable
	Change Windows feedback frequency to "Automatically" for the current user
	Изменить частоту формирования отзывов на "Автоматически" для текущего пользователя

	.EXAMPLE
	WindowsFeedback -Disable

	.EXAMPLE
	WindowsFeedback -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Turn off/turn on diagnostics tracking scheduled tasks
	Отключить/включить задачи диагностического отслеживания

	.PARAMETER Disable
	Turn off on diagnostics tracking scheduled tasks
	Отключить задачи диагностического отслеживания

	.PARAMETER Enable
	Turn on diagnostics tracking scheduled tasks
	Включить задачи диагностического отслеживания

	.EXAMPLE
	ScheduledTasks -Disable

	.EXAMPLE
	ScheduledTasks -Enable

	.NOTES
	A pop-up dialog box enables the user to select tasks
	Current user only

	Используется всплывающее диалоговое окно, позволяющее пользователю отмечать задачи
	Только для текущего пользователя

	Made by https://github.com/oz-zo
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
	# Создать массив для выбранных задач
	$SelectedTasks = New-Object -TypeName System.Collections.ArrayList($null)

	# The following tasks will have their checkboxes checked
	# Следующие задачи будут иметь чекбоксы отмеченными
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

	# If device is not a laptop disable FODCleanupTask too
	# Если устройство не является ноутбуком, отключить также и FODCleanupTask
	if ((Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType -ne 2)
	{
		# Windows Hello
		$CheckedScheduledTasks += "FODCleanupTask"
	}
	#endregion Variables

	#region XAML Markup
	# The section defines the design of the upcoming dialog box
	# Раздел, определяющий форму диалогового окна
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

		$SelectedTasks  | ForEach-Object -Process {Write-Verbose $_.TaskName -Verbose}
		$SelectedTasks | Disable-ScheduledTask
	}

	function EnableButton
	{
		Write-Verbose -Message $Localization.Patient -Verbose

		[void]$Window.Close()

		$SelectedTasks  | ForEach-Object -Process {Write-Verbose $_.TaskName -Verbose}
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
			# Если задача выделена, то добавить в массив
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

	# Получаем общий список задач, согласно условиям
	# Getting a list of tasks according to the conditions
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
	Do not use/use sign-in info to automatically finish setting up device and reopen apps after an update or restart
	Не использовать/использовать данные для входа для автоматического завершения настройки устройства и открытия приложений после перезапуска или обновления

	.PARAMETER Disable
	Do not use sign-in info to automatically finish setting up device and reopen apps after an update or restart
	Не использовать данные для входа для автоматического завершения настройки устройства и открытия приложений после перезапуска или обновления

	.PARAMETER Enable
	Use sign-in info to automatically finish setting up device and reopen apps after an update or restart
	Использовать данные для входа для автоматического завершения настройки устройства и открытия приложений после перезапуска или обновления

	.EXAMPLE
	SigninInfo -Disable

	.EXAMPLE
	SigninInfo -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Do not let/let websites provide locally relevant content by accessing language list
	Не позволять/позволять веб-сайтам предоставлять местную информацию за счет доступа к списку языков

	.PARAMETER Disable
	Do not let websites provide locally relevant content by accessing language list
	Не позволять веб-сайтам предоставлять местную информацию за счет доступа к списку языков

	.PARAMETER Enable
	Let websites provide locally relevant content by accessing language list
	Позволять веб-сайтам предоставлять местную информацию за счет доступа к списку языков

	.EXAMPLE
	LanguageListAccess -Disable

	.EXAMPLE
	LanguageListAccess -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Do not allow/allow apps to use advertising ID
	Не разрешать/разрешать приложениям использовать идентификатор рекламы

	.PARAMETER Disable
	Do not allow apps to use advertising ID
	Не разрешать приложениям использовать идентификатор рекламы

	.PARAMETER Enable
	Do not allow apps to use advertising ID
	Не разрешать приложениям использовать идентификатор рекламы

	.EXAMPLE
	AdvertisingID -Disable

	.EXAMPLE
	AdvertisingID -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
			if (-not (Test-Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo))
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
	Do not let/let apps on other devices open and message apps on this device, and vice versa
	Не разрешать/разрешать приложениям на других устройствах запускать приложения и отправлять сообщения на этом устройстве и наоборот

	.PARAMETER Disable
	Do not let apps on other devices open and message apps on this device, and vice versa
	Не разрешать/разрешать приложениям на других устройствах запускать приложения и отправлять сообщения на этом устройстве и наоборот

	.PARAMETER Enable
	Let apps on other devices open and message apps on this device, and vice versa
	разрешать приложениям на других устройствах запускать приложения и отправлять сообщения на этом устройстве и наоборот

	.EXAMPLE
	ShareAcrossDevices -Disable

	.EXAMPLE
	ShareAcrossDevices -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Hide/show the Windows welcome experiences after updates and occasionally when I sign in to highlight what's new and suggested
	Не показывать/показывать экран приветствия Windows после обновлений и иногда при входе, чтобы сообщить о новых функциях и предложениях

	.PARAMETER Hide
	Hide the Windows welcome experiences after updates and occasionally when I sign in to highlight what's new and suggested
	Не показывать экран приветствия Windows после обновлений и иногда при входе, чтобы сообщить о новых функциях и предложениях

	.PARAMETER Show
	Show the Windows welcome experiences after updates and occasionally when I sign in to highlight what's new and suggested
	Показывать экран приветствия Windows после обновлений и иногда при входе, чтобы сообщить о новых функциях и предложениях

	.EXAMPLE
	WindowsWelcomeExperience -Hide

	.EXAMPLE
	WindowsWelcomeExperience -Show

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Get/do not get tip, trick, and suggestions as you use Windows
	Получать/не получать советы, подсказки и рекомендации при использованию Windows

	.PARAMETER Disable
	Do not get tip, trick, and suggestions as you use Windows
	Не получать советы, подсказки и рекомендации при использованию Windows

	.PARAMETER Enable
	Get tip, trick, and suggestions as you use Windows
	Получать советы, подсказки и рекомендации при использованию Windows

	.EXAMPLE
	WindowsTips -Disable

	.EXAMPLE
	WindowsTips -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Hide/show suggested content in the Settings app
	Скрывать/показывать рекомендуемое содержимое в приложении "Параметры"

	.PARAMETER Hide
	Hide suggested content in the Settings app
	Скрывать рекомендуемое содержимое в приложении "Параметры"

	.PARAMETER Show
	Show suggested content in the Settings app
	Показывать рекомендуемое содержимое в приложении "Параметры"

	.EXAMPLE
	SettingsSuggestedContent -Hide

	.EXAMPLE
	SettingsSuggestedContent -Show

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Turn off/turn on automatic installing suggested apps
	Отключить/включить автоматическую установку рекомендованных приложений

	.PARAMETER Disable
	Turn off automatic installing suggested apps
	Отключить автоматическую установку рекомендованных приложений

	.PARAMETER Enable
	Turn on automatic installing suggested apps
	Включить автоматическую установку рекомендованных приложений

	.EXAMPLE
	AppsSilentInstalling -Disable

	.EXAMPLE
	AppsSilentInstalling -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Do not suggest/suggest ways I can finish setting up my device to get the most out of Windows
	Не предлагать/предлагать способы завершения настройки устройства для максимально эффективного использования Windows

	.PARAMETER Disable
	Do not suggest ways I can finish setting up my device to get the most out of Windows
	Не предлагать способы завершения настройки устройства для максимально эффективного использования Windows

	.PARAMETER Enable
	Suggest ways I can finish setting up my device to get the most out of Windows
	Предлагать способы завершения настройки устройства для максимально эффективного использования Windows

	.EXAMPLE
	WhatsNewInWindows -Disable

	.EXAMPLE
	WhatsNewInWindows -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
			if (-not (Test-Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Name ScoobeSystemSettingEnabled -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			if (-not (Test-Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Name ScoobeSystemSettingEnabled -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Do not offer/offer tailored experiences based on the diagnostic data setting
	Не предлагать/предлагать персонализированные возможности, основанные на выбранном параметре диагностических данных

	.PARAMETER Disable
	Do not offer tailored experiences based on the diagnostic data setting
	Не предлагать персонализированные возможности, основанные на выбранном параметре диагностических данных

	.PARAMETER Enable
	Offer tailored experiences based on the diagnostic data setting
	Предлагать персонализированные возможности, основанные на выбранном параметре диагностических данных

	.EXAMPLE
	TailoredExperiences -Disable

	.EXAMPLE
	TailoredExperiences -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Disable/enable Bing search in the Start Menu (for the USA only)
	Отключить/включить поиск через Bing в меню "Пуск" (только для США)

	.PARAMETER Disable
	Disable Bing search in the Start Menu (for the USA only)
	Отключить поиск через Bing в меню "Пуск" (только для США)

	.PARAMETER Enable
	Enable Bing search in the Start Menu (for the USA only)
	Включить поиск через Bing в меню "Пуск" (только для США)

	.EXAMPLE
	BingSearch -Disable

	.EXAMPLE
	BingSearch -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
			if (-not (Test-Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer))
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
	Show/hide "This PC" on Desktop
	Отображать/скрывать "Этот компьютер" на рабочем столе

	.PARAMETER Hide
	Show "This PC" on Desktop
	Отображать "Этот компьютер" на рабочем столе

	.PARAMETER Show
	Hide "This PC" on Desktop
	Скрывать "Этот компьютер" на рабочем столе

	.EXAMPLE
	ThisPC -Hide

	.EXAMPLE
	ThisPC -Show

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Do not use/use check boxes to select items
	Не использовать/использовать флажки для выбора элементов

	.PARAMETER Disable
	Do not use check boxes to select items
	Не использовать флажки для выбора элементов

	.PARAMETER Enable
	Use check boxes to select items
	Использовать флажки для выбора элементов

	.EXAMPLE
	CheckBoxes -Disable

	.EXAMPLE
	CheckBoxes -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Show/do not show hidden files, folders, and drives
	Отображать/не отображать скрытые файлы, папки и диски

	.PARAMETER Enable
	Show hidden files, folders, and drives
	Отображать скрытые файлы, папки и диски

	.PARAMETER Disable
	Do not show hidden files, folders, and drives
	Не отображать скрытые файлы, папки и диски

	.EXAMPLE
	HiddenItems -Enable

	.EXAMPLE
	HiddenItems -Disable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Show/hide file name extensions
	Отображать/скрывать расширения имён файлов

	.PARAMETER Show
	Show file name extensions
	Отображать расширения имён файлов

	.PARAMETER Hide
	Hide file name extensions
	Скрывать расширения имён файлов

	.EXAMPLE
	FileExtensions -Show

	.EXAMPLE
	FileExtensions -Hide

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Show/hide folder merge conflicts
	Отображать/скрывать конфликт слияния папок

	.PARAMETER Show
	Show folder merge conflicts
	Отображать конфликт слияния папок

	.PARAMETER Hide
	Hide folder merge conflicts
	Скрывать конфликт слияния папок

	.EXAMPLE
	MergeConflicts -Show

	.EXAMPLE
	MergeConflicts -Hide

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Open File Explorer to "This PC" or "Quick access"
	Открывать проводник для "Этот компьютер" или "Быстрый доступ"

	.PARAMETER ThisPC
	Open File Explorer to "This PC"
	Открывать проводник для "Этот компьютер"

	.PARAMETER QuickAccess
	Open File Explorer to "Quick access"
	Открывать проводник для "Быстрый доступ"

	.EXAMPLE
	OpenFileExplorerTo -ThisPC

	.EXAMPLE
	OpenFileExplorerTo -QuickAccess

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Hide/show Cortana button on the taskbar
	Скрывать/показать кнопку Кортаны на панели задач

	.PARAMETER Hide
	Show Cortana button on the taskbar
	Показать кнопку Кортаны на панели задач

	.PARAMETER Show
	Hide Cortana button on the taskbar
	Скрывать кнопку Кортаны на панели задач

	.EXAMPLE
	CortanaButton -Hide

	.EXAMPLE
	CortanaButton -Show

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Do not show/show sync provider notification within File Explorer
	Не показывать/показывать уведомления поставщика синхронизации в проводнике

	.PARAMETER Hide
	Do not show sync provider notification within File Explorer
	Не показывать уведомления поставщика синхронизации в проводнике

	.PARAMETER Show
	Show sync provider notification within File Explorer
	Показывать уведомления поставщика синхронизации в проводнике

	.EXAMPLE
	OneDriveFileExplorerAd -Hide

	.EXAMPLE
	OneDriveFileExplorerAd -Show

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Hide Task View button on the taskbar
	Скрыть кнопку Просмотра задач

	.PARAMETER Hide
	Show Task View button on the taskbar
	Не показывать кнопку Просмотра задач

	.PARAMETER Show
	Do not show Task View button on the taskbar
	Не показывать кнопку Просмотра задач

	.EXAMPLE
	TaskViewButton -Hide

	.EXAMPLE
	TaskViewButton -Show

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Hide/show People button on the taskbar
	Скрывать/показывать панель "Люди" на панели задач

	.PARAMETER Hide
	Hide People button on the taskbar
	Скрывать панель "Люди" на панели задач

	.PARAMETER Show
	Show People button on the taskbar
	Показывать панель "Люди" на панели задач

	.EXAMPLE
	PeopleTaskbar -Hide

	.EXAMPLE
	PeopleTaskbar -Show

	.NOTES
	Current user only
	Только для текущего пользователя
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
			if (-not (Test-Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Name PeopleBand -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			if (-not (Test-Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Name PeopleBand -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Show/hide seconds on the taskbar clock
	Отображать/скрывать секунды в системных часах на панели задач

	.PARAMETER Hide
	Hide seconds on the taskbar clock
	Скрывать секунды в системных часах на панели задач

	.PARAMETER Show
	Show seconds on the taskbar clock
	Отображать секунды в системных часах на панели задач

	.EXAMPLE
	SecondsInSystemClock -Hide

	.EXAMPLE
	SecondsInSystemClock -Show

	.NOTES
	Current user only
	Только для текущего пользователя
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
	When I snap a window, do not show/show what I can snap next to it
	При прикреплении окна не показывать/показывать, что можно прикрепить рядом с ним

	.PARAMETER Disable
	When I snap a window, do not show what I can snap next to it
	При прикреплении окна не показывать, что можно прикрепить рядом с ним

	.PARAMETER Enable
	When I snap a window, show what I can snap next to it
	При прикреплении окна не показывать/показывать, что можно прикрепить рядом с ним

	.EXAMPLE
	SnapAssist -Disable

	.EXAMPLE
	SnapAssist -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Always open the file transfer dialog box in the detailed/compact mode
	Всегда открывать диалоговое окно передачи файлов в развернутом/свернутом виде

	.PARAMETER Detailed
	Always open the file transfer dialog box in the detailed mode
	Всегда открывать диалоговое окно передачи файлов в развернутом виде

	.PARAMETER Compact
	Always open the file transfer dialog box in the compact mode
	Всегда открывать диалоговое окно передачи файлов в развернутом виде

	.EXAMPLE
	FileTransferDialog -Detailed

	.EXAMPLE
	FileTransferDialog -Compact

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Always expand/minimize the ribbon in the File Explorer
	Всегда разворачивать/сворачивать ленту в проводнике

	.PARAMETER Expanded
	Always expand the ribbon in the File Explorer
	Всегда разворачивать ленту в проводнике

	.PARAMETER Minimized
	Always minimize the ribbon in the File Explorer
	Всегда разворачивать ленту в проводнике

	.EXAMPLE
	FileExplorerRibbon -Expanded

	.EXAMPLE
	FileExplorerRibbon -Minimized

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Display/do not display recycle bin files delete confirmation
	Запрашивать/не запрашивать подтверждение на удаление файлов в корзину

	.PARAMETER Disable
	Display/do not display recycle bin files delete confirmation
	Запрашивать/не запрашивать подтверждение на удаление файлов в корзину

	.PARAMETER Enable
	Display/do not display recycle bin files delete confirmation
	Запрашивать/не запрашивать подтверждение на удаление файлов в корзину

	.EXAMPLE
	RecycleBinDeleteConfirmation -Disable

	.EXAMPLE
	RecycleBinDeleteConfirmation -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
// Виртуальный код клавиши F5 в проводнике
private static readonly UIntPtr UIntPtr = new UIntPtr(41504);

[DllImport("user32.dll", SetLastError=true)]
public static extern int PostMessageW(IntPtr hWnd, uint Msg, UIntPtr wParam, IntPtr lParam);
public static void PostMessage()
{
	// F5 pressing simulation to refresh the desktop
	// Симуляция нажатия F5 для обновления рабочего стола
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
	# Симулировать нажатие F5 для обновления рабочего стола
	[WinAPI.UpdateDesktop]::PostMessage()
}

<#
	.SYNOPSIS
	Hide/show the "3D Objects" folder in "This PC" and "Quick access"
	Скрыть/отобразить папку "Объемные объекты" в "Этот компьютер" и панели быстрого доступа

	.PARAMETER Show
	Show the "3D Objects" folder in "This PC" and "Quick access"
	Отобразить папку "Объемные объекты" в "Этот компьютер" и панели быстрого доступа

	.PARAMETER Hide
	Hide the "3D Objects" folder in "This PC" and "Quick access"
	Скрыть папку "Объемные объекты" в "Этот компьютер" и панели быстрого доступа

	.EXAMPLE
	3DObjects -Show

	.EXAMPLE
	3DObjects -Hide

	.NOTES
	Current user only
	Только для текущего пользователя
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
	# Сохранить все открытые папки, чтобы восстановить их после перезапуска проводника
	Clear-Variable -Name OpenedFolders -Force -ErrorAction Ignore
	$OpenedFolders = {(New-Object -ComObject Shell.Application).Windows() | ForEach-Object -Process {$_.Document.Folder.Self.Path}}.Invoke()

	# In order for the changes to take effect the File Explorer process has to be restarted
	# Чтобы изменения вступили в силу, необходимо перезапустить процесс проводника
	Stop-Process -Name explorer -Force

	# Restoring closed folders
	# Восстановить закрытые папки
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
	Hide/show frequently used folders in "Quick access"
	Скрывать/показывать недавно используемые папки на панели быстрого доступа

	.PARAMETER Show
	Show frequently used folders in "Quick access"
	Показывать недавно используемые папки на панели быстрого доступа

	.PARAMETER Hide
	Hide frequently used folders in "Quick access"
	Скрывать недавно используемые папки на панели быстрого доступа

	.EXAMPLE
	QuickAccessFrequentFolders -Show

	.EXAMPLE
	QuickAccessFrequentFolders -Hide

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Hide/show recently used files in Quick access
	Скрывать/показывать недавно использовавшиеся файлы на панели быстрого доступа

	.PARAMETER Show
	Show recently used files in Quick access
	Показывать недавно использовавшиеся файлы на панели быстрого доступа

	.PARAMETER Hide
	Hide recently used files in Quick access
	Скрывать недавно использовавшиеся файлы на панели быстрого доступа

	.EXAMPLE
	QuickAccessRecentFiles -Show

	.EXAMPLE
	QuickAccessRecentFiles -Hide

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Hide/show the search box or search icon on the taskbar
	Скрыть/показать поле или значок поиска на панели задач

	.PARAMETER SearchBox
	Show the search box on the taskbar
	Показать поле поиска на панели задач

	.PARAMETER SearchIcon
	Show the search icon on the taskbar
	Показать значок поиска на панели задач

	.PARAMETER Hide
	Hide the search box on the taskbar
	Скрывать поле поиска на панели задач

	.EXAMPLE
	TaskbarSearch -SearchBox

	.EXAMPLE
	TaskbarSearch -SearchIcon

	.EXAMPLE
	TaskbarSearch -Hide

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Hide/show the "Windows Ink Workspace" button on the taskbar
	Скрывать/показать кнопку Windows Ink Workspace на панели задач

	.PARAMETER Show
	Show recently used files in Quick access
	Показывать недавно использовавшиеся файлы на панели быстрого доступа

	.PARAMETER Hide
	Hide recently used files in Quick access
	Скрывать недавно использовавшиеся файлы на панели быстрого доступа

	.EXAMPLE
	WindowsInkWorkspace -Show

	.EXAMPLE
	WindowsInkWorkspace -Hide

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Always show/hide all icons in the notification area
	Всегда отображать/скрывать все значки в области уведомлений

	.PARAMETER Show
	Always show all icons in the notification area
	Всегда отображать все значки в области уведомлений

	.PARAMETER Hide
	Hide all icons in the notification area
	Скрывать все значки в области уведомлений

	.EXAMPLE
	TrayIcons -Show

	.EXAMPLE
	TrayIcons -Hide

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Unpin "Microsoft Edge" and "Microsoft Store" from the taskbar
	Открепить Microsoft Edge и Microsoft Store от панели задач

	.NOTES
	Current user only
	Только для текущего пользователя
#>
function UnpinTaskbarEdgeStore
{
	$Signature = @{
		Namespace = "WinAPI"
		Name = "GetStr"
		Language = "CSharp"
		MemberDefinition = @"
	// https://github.com/Disassembler0/Win10-Initial-Setup-Script/issues/8#issue-227159084
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

	# Extract the "Unpin from taskbar" string from shell32.dll
	# Извлечь строку "Открепить от панели задач" из shell32.dll
	$LocalizedString = [WinAPI.GetStr]::GetString(5387)

	$Apps = (New-Object -ComObject Shell.Application).NameSpace("shell:::{4234d49b-0245-4df3-b780-3893943456e1}").Items()
	[void]{$Apps | Where-Object -FilterScript {$_.Path -eq "MSEdge"} | ForEach-Object -Process {$_.Verbs() | Where-Object -FilterScript {$_.Name -eq $LocalizedString} | ForEach-Object -Process {$_.DoIt()}}}
	[void]{$Apps | Where-Object -FilterScript {$_.Name -eq "Microsoft Store"} | ForEach-Object -Process {$_.Verbs() | Where-Object -FilterScript {$_.Name -eq $LocalizedString} | ForEach-Object -Process {$_.DoIt()}}}
}

<#
	.SYNOPSIS
	View the Control Panel icons by: large icons/category
	Просмотр иконок Панели управления как: крупные значки/категория

	.PARAMETER LargeIcons
	View the Control Panel icons by: large icons
	Просмотр иконок Панели управления как: крупные значки

	.PARAMETER Category
	View the Control Panel icons by: category
	Просмотр иконок Панели управления как: категория

	.EXAMPLE
	ControlPanelView -LargeIcons

	.EXAMPLE
	ControlPanelView -Category

	.NOTES
	Current user only
	Только для текущего пользователя
#>
function ControlPanelView
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "LargeIcons"
		)]
		[switch]
		$LargeIcons,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Category"
		)]
		[switch]
		$Category
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"LargeIcons"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name AllItemsIconView -PropertyType DWord -Value 0 -Force
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name StartupPage -PropertyType DWord -Value 1 -Force
		}
		"Category"
		{
			if (-not (Test-Path -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel))
			{
				New-Item -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Force
			}
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name AllItemsIconView -PropertyType DWord -Value 0 -Force
			New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name StartupPage -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Set the Windows mode color scheme to the light/dark
	Установить режим цвета для Windows на светлый/темный

	.PARAMETER Light
	Set the Windows mode color scheme to the light
	Установить режим цвета для Windows на светлый

	.PARAMETER Dark
	Set the Windows mode color scheme to the dark
	Установить режим цвета для Windows на темный

	.EXAMPLE
	WindowsColorScheme -Light

	.EXAMPLE
	WindowsColorScheme -Dark

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Set the default app mode color scheme to the light/dark
	Установить цвет режима приложений по умолчанию на светлый/темный

	.PARAMETER Light
	Set the default app mode color scheme to the light
	Установить цвет режима приложений по умолчанию на светлый

	.PARAMETER Dark
	Set the default app mode color scheme to the dark
	Установить цвет режима приложений по умолчанию на темный

	.EXAMPLE
	AppMode -Light

	.EXAMPLE
	AppMode -Dark

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Hide/show the "New App Installed" indicator
	Скрывать/показывать уведомление "Установлено новое приложение"

	.PARAMETER Hide
	Hide the "New App Installed" indicator
	Скрывать уведомление "Установлено новое приложение"

	.PARAMETER Show
	Show the "New App Installed" indicator
	Показывать уведомление "Установлено новое приложение"

	.EXAMPLE
	NewAppInstalledNotification -Hide

	.EXAMPLE
	NewAppInstalledNotification -Show

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Hide user/show first sign-in animation after the upgrade
	Скрывать/показывать анимацию при первом входе в систему после обновления

	.PARAMETER Hide
	Hide user/show first sign-in animation after the upgrade
	Скрывать/показывать анимацию при первом входе в систему после обновления

	.PARAMETER Show
	Hide user/show first sign-in animation after the upgrade
	Скрывать/показывать анимацию при первом входе в систему после обновления

	.EXAMPLE
	FirstLogonAnimation -Disable

	.EXAMPLE
	FirstLogonAnimation -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Set the quality factor of the JPEG desktop wallpapers to maximum/default
	Установить коэффициент качества обоев рабочего стола в формате JPEG на максимальный/по умолчанию

	.PARAMETER Max
	Set the quality factor of the JPEG desktop wallpapers to maximum
	Установить коэффициент качества обоев рабочего стола в формате JPEG на максимальный

	.PARAMETER Default
	Set the quality factor of the JPEG desktop wallpapers to default
	Установить коэффициент качества обоев рабочего стола в формате JPEG на значение по умолчанию

	.EXAMPLE
	JPEGWallpapersQuality -Max

	.EXAMPLE
	JPEGWallpapersQuality -Default

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Start Task Manager in the expanded/compact mode
	Запускать Диспетчера задач в развернутом/свернутом виде

	.PARAMETER Expanded
	Start Task Manager in the expanded mode
	Запускать Диспетчера задач в развернутом виде

	.PARAMETER Compact
	Start Task Manager in the compact mode
	Запускать Диспетчера задач в свернутом виде

	.EXAMPLE
	TaskManagerWindow -Expanded

	.EXAMPLE
	TaskManagerWindow -Compact

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Show/hide a notification when your PC requires a restart to finish updating
	Показывать/скрывать уведомление, когда компьютеру требуется перезагрузка для завершения обновления

	.PARAMETER Hide
	Hide a notification when your PC requires a restart to finish updating
	Скрывать уведомление, когда компьютеру требуется перезагрузка для завершения обновления

	.PARAMETER Show
	Show a notification when your PC requires a restart to finish updating
	Показывать уведомление, когда компьютеру требуется перезагрузка для завершения обновления

	.EXAMPLE
	RestartNotification -Hide

	.EXAMPLE
	RestartNotification -Show

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Do not add/add the "- Shortcut" suffix to the file name of created shortcuts
	Нe дoбaвлять/добавлять "- яpлык" к имени coздaвaeмых яpлыков

	.PARAMETER Disable
	Do not add the "- Shortcut" suffix to the file name of created shortcuts
	Нe дoбaвлять "- яpлык" к имени coздaвaeмых яpлыков

	.PARAMETER Enable
	Add the "- Shortcut" suffix to the file name of created shortcuts
	Добавлять "- яpлык" к имени coздaвaeмых яpлыков

	.EXAMPLE
	ShortcutsSuffix -Disable

	.EXAMPLE
	ShortcutsSuffix -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Use/do not use the PrtScn button to open screen snipping
	Использовать/не использовать кнопку PRINT SCREEN, чтобы запустить функцию создания фрагмента экрана

	.PARAMETER Disable
	Use the PrtScn button to open screen snipping
	Использовать кнопку PRINT SCREEN, чтобы запустить функцию создания фрагмента экрана

	.PARAMETER Enable
	Do not use the PrtScn button to open screen snipping
	Не использовать кнопку PRINT SCREEN, чтобы запустить функцию создания фрагмента экрана

	.EXAMPLE
	PrtScnSnippingTool -Disable

	.EXAMPLE
	PrtScnSnippingTool -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Let/do not let use a different input method for each app window
	Позволить/не позволять выбирать метод ввода для каждого окна

	.PARAMETER Enable
	Let use a different input method for each app window
	Позволить выбирать метод ввода для каждого окна

	.PARAMETER Disable
	Do not let use a different input method for each app window
	Не позволять выбирать метод ввода для каждого окна

	.EXAMPLE
	AppsLanguageSwitch -Disable

	.EXAMPLE
	AppsLanguageSwitch -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Удалить/установить OneDrive

	.PARAMETER Uninstall
	Uninstall OneDrive
	Удалить OneDrive

	.PARAMETER Install
	Install OneDrive
	Установить OneDrive

	.EXAMPLE
	OneDrive -Uninstall

	.EXAMPLE
	OneDrive -Install
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
			[string]$UninstallString = Get-Package -Name "Microsoft OneDrive" -ProviderName Programs -ErrorAction Ignore | ForEach-Object -Process {$_.Meta.Attributes["UninstallString"]}
			if ($UninstallString)
			{
				Write-Verbose -Message $Localization.OneDriveUninstalling -Verbose
				Stop-Process -Name OneDrive -Force -ErrorAction Ignore
				Stop-Process -Name OneDriveSetup -Force -ErrorAction Ignore
				Stop-Process -Name FileCoAuth -Force -ErrorAction Ignore

				# Getting link to the OneDriveSetup.exe and its' argument(s)
				# Получаем ссылку на OneDriveSetup.exe и его аргумент(ы)
				[string[]]$OneDriveSetup = ($UninstallString -Replace("\s*/",",/")).Split(",").Trim()
				if ($OneDriveSetup.Count -eq 2)
				{
					Start-Process -FilePath $OneDriveSetup[0] -ArgumentList $OneDriveSetup[1..1] -Wait
				}
				else
				{
					Start-Process -FilePath $OneDriveSetup[0] -ArgumentList $OneDriveSetup[1..2] -Wait
				}

				# Getting the OneDrive user folder path
				# Получаем путь до папки пользователя OneDrive
				$OneDriveUserFolder = Get-ItemPropertyValue -Path HKCU:\Environment -Name OneDrive
				if ((Get-ChildItem -Path $OneDriveUserFolder | Measure-Object).Count -eq 0)
				{
					Remove-Item -Path $OneDriveUserFolder -Recurse -Force
				}
				else
				{
					Write-Error -Message ($Localization.OneDriveNotEmptyFolder -f $OneDriveUserFolder) -ErrorAction SilentlyContinue

					Invoke-Item -Path $OneDriveUserFolder
				}

				Remove-ItemProperty -Path HKCU:\Environment -Name OneDrive, OneDriveConsumer -Force -ErrorAction Ignore
				Remove-Item -Path HKCU:\SOFTWARE\Microsoft\OneDrive -Recurse -Force -ErrorAction Ignore
				Remove-Item -Path HKLM:\SOFTWARE\WOW6432Node\Microsoft\OneDrive -Recurse -Force -ErrorAction Ignore
				Remove-Item -Path "$env:ProgramData\Microsoft OneDrive" -Recurse -Force -ErrorAction Ignore
				Remove-Item -Path $env:SystemDrive\OneDriveTemp -Recurse -Force -ErrorAction Ignore
				Unregister-ScheduledTask -TaskName *OneDrive* -Confirm:$false

				# Getting the OneDrive folder path
				# Получаем путь до папки OneDrive
				$OneDriveFolder = Split-Path -Path (Split-Path -Path $OneDriveSetup[0] -Parent)

				# Save all opened folders in order to restore them after File Explorer restarting
				# Сохранить все открытые папки, чтобы восстановить их после перезапуска проводника
				Clear-Variable -Name OpenedFolders -Force -ErrorAction Ignore
				$OpenedFolders = {(New-Object -ComObject Shell.Application).Windows() | ForEach-Object -Process {$_.Document.Folder.Self.Path}}.Invoke()

				# Terminate File Explorer process
				# Завершить процесс проводника
				TASKKILL /F /IM explorer.exe

				# Attempt to unregister FileSyncShell64.dll and remove
				# Попытка разрегистрировать FileSyncShell64.dll и удалить
				$FileSyncShell64dlls = Get-ChildItem -Path "$OneDriveFolder\*\amd64\FileSyncShell64.dll" -Force
				foreach ($FileSyncShell64dll in $FileSyncShell64dlls.FullName)
				{
					Start-Process -FilePath regsvr32.exe -ArgumentList "/u /s $FileSyncShell64dll" -Wait
					Remove-Item -Path $FileSyncShell64dll -Force -ErrorAction Ignore

					if (Test-Path -Path $FileSyncShell64dll)
					{
						Write-Error -Message ($Localization.OneDriveFileSyncShell64dllBlocked -f $FileSyncShell64dll) -ErrorAction SilentlyContinue
					}
				}

				# Restoring closed folders
				# Восстановляем закрытые папки
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
					# Скачивание последней версии OneDrive
					try
					{
						if ((Invoke-WebRequest -Uri https://www.google.com -UseBasicParsing -DisableKeepAlive -Method Head).StatusDescription)
						{
							Write-Verbose -Message $Localization.OneDriveDownloading -Verbose

							[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
							$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
							$Parameters = @{
								Uri = "https://go.microsoft.com/fwlink/p/?LinkID=2121808"
								OutFile = "$DownloadsFolder\OneDriveSetup.exe"
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
	Turn on/turn off Storage Sense
	Включить/отключить Контроль памяти

	.PARAMETER Disable
	Turn off Storage Sense
	Отключить Контроль памяти

	.PARAMETER Enable
	Turn on off Storage Sense
	Включить Контроль памяти

	.EXAMPLE
	StorageSense -Disable

	.EXAMPLE
	StorageSense -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Run Storage Sense every month/during low free disk space
	Запускать Контроль памяти каждый месяц/когда остается мало место на диске

	.PARAMETER Disable
	Run Storage Sense every month/during low free disk space
	Запускать Контроль памяти каждый месяц/когда остается мало место на диске

	.PARAMETER Enable
	Run Storage Sense every month/during low free disk space
	Запускать Контроль памяти каждый месяц/когда остается мало место на диске

	.EXAMPLE
	StorageSenseFrequency -Month

	.EXAMPLE
	StorageSenseFrequency -Default

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Delete/do not delete temporary files that apps aren't using
	Удалять/не удалять временные файлы, не используемые в приложениях

	.PARAMETER Enable
	Delete temporary files that apps aren't using
	Удалять временные файлы, не используемые в приложениях

	.PARAMETER Disable
	Do not delete temporary files that apps aren't using
	Не удалять временные файлы, не используемые в приложениях

	.EXAMPLE
	StorageSenseTempFiles -Enable

	.EXAMPLE
	StorageSenseTempFiles -Disable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Delete/do not delete files in recycle bin if they have been there for over 30 days
	Удалять/не удалять файлы из корзины, если они находятся в корзине более 30 дней

	.PARAMETER Disable
	Delete files in recycle bin if they have been there for over 30 days
	Удалять файлы из корзины, если они находятся в корзине более 30 дней

	.PARAMETER Enable
	Do not delete files in recycle bin if they have been there for over 30 days
	Не удалять файлы из корзины, если они находятся в корзине более 30 дней

	.EXAMPLE
	StorageSenseRecycleBin -Enable

	.EXAMPLE
	StorageSenseRecycleBin -Disable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Disable (if the device is not a laptop)/enable hibernation
	Отключить (если устройство не является ноутбуком)/включить режим гибернации

	.PARAMETER Disable
	Disable hibernation if the device is not a laptop
	Отключить режим гибернации, если устройство не является ноутбуком

	.PARAMETER Enable
	Enable hibernation
	Включить режим гибернации

	.EXAMPLE
	Hibernate -Enable

	.EXAMPLE
	Hibernate -Disable
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
			if ((Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType -ne 2)
			{
				POWERCFG /HIBERNATE OFF
			}
		}
	}
}

<#
	.SYNOPSIS
	Change the %TEMP% environment variable path to the "%SystemDrive%\Temp"/default value
	Изменить путь переменной среды для %TEMP% на "%SystemDrive%\Temp"/по умолчанию

	.PARAMETER SystemDrive
	Change the %TEMP% environment variable path to "%SystemDrive%\Temp"
	Изменить путь переменной среды для %TEMP% на "%SystemDrive%\Temp"

	.PARAMETER Default
	Change the %TEMP% environment variable path to "%LOCALAPPDATA%\Temp"
	Изменить путь переменной среды для %TEMP% на "%LOCALAPPDATA%\Temp"

	.EXAMPLE
	TempFolder -SystemDrive

	.EXAMPLE
	TempFolder -Default

	.NOTES
	Machine-wide
	Для всех пользователей
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
			# Restart the Printer Spooler service (Spooler)
			# Перезапустить службу "Диспетчер печати" (Spooler)
			Restart-Service -Name Spooler -Force

			Stop-Process -Name OneDrive -Force -ErrorAction Ignore
			Stop-Process -Name FileCoAuth -Force -ErrorAction Ignore

			if (-not (Test-Path -Path $env:SystemDrive\Temp))
			{
				New-Item -Path $env:SystemDrive\Temp -ItemType Directory -Force
			}

			Remove-Item -Path $env:SystemRoot\Temp -Recurse -Force -ErrorAction Ignore
			Get-Item -Path $env:LOCALAPPDATA\Temp -Force -ErrorAction Ignore | Where-Object -FilterScript {$_.LinkType -ne "SymbolicLink"} | Remove-Item -Recurse -Force -ErrorAction Ignore

			if (Test-Path -Path $env:LOCALAPPDATA\Temp -ErrorAction Ignore)
			{
				if ((Get-ChildItem -Path $env:LOCALAPPDATA\Temp -Force -ErrorAction Ignore | Measure-Object).Count -ne 0)
				{
					Invoke-Item -Path $env:LOCALAPPDATA\Temp

					do
					{
						$Title = ""
						$Message = $Localization.ClearFolder -f "$env:LOCALAPPDATA\Temp"
						$Continue = $Localization.Continue
						$Skip = $Localization.Skip
						$Options = "&$Continue", "&$Skip"
						$DefaultChoice = 0

						$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)
						switch ($Result)
						{
							"0"
							{
								# Create a symbolic link to the %SystemDrive%\Temp folder
								# Создать символическую ссылку к папке %SystemDrive%\Temp
								try
								{
									Get-Item -Path $env:LOCALAPPDATA\Temp -Force | Where-Object -FilterScript {$_.LinkType -ne "SymbolicLink"} | Remove-Item -Recurse -Force -ErrorAction Ignore
									New-Item -Path $env:LOCALAPPDATA\Temp -ItemType SymbolicLink -Value $env:SystemDrive\Temp -Force -ErrorAction SilentlyContinue
								}
								catch [System.Exception]
								{
									Write-Verbose -Message $Localization.FilesBlocked -Verbose
									Write-Verbose -Message ((Get-ChildItem -Path $env:LOCALAPPDATA\Temp -Force).FullName | Out-String) -Verbose
								}
							}
							"1"
							{
								Write-Verbose -Message $Localization.SymbolicSkipped -Verbose
							}
						}
					}
					until (((Get-ChildItem -Path $env:LOCALAPPDATA\Temp -Force -ErrorAction Ignore | Measure-Object).Count -eq 0) -or ($Result -eq 1))
				}
			}
			else
			{
				# Create a symbolic link to the %SystemDrive%\Temp folder
				# Создать символическую ссылку к папке %SystemDrive%\Temp
				New-Item -Path $env:LOCALAPPDATA\Temp -ItemType SymbolicLink -Value $env:SystemDrive\Temp -Force
			}

			if (Get-Item -Path $env:LOCALAPPDATA\Temp -ErrorAction Ignore | Where-Object -FilterScript {$_.LinkType -eq "SymbolicLink"})
			{
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
			}
		}
		"Default"
		{
			# Remove a symbolic link to the %SystemDrive%\Temp folder
			# Удалить символическую ссылку к папке %SystemDrive%\Temp
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

			# Restart the Printer Spooler service (Spooler)
			# Перезапустить службу "Диспетчер печати" (Spooler)
			Restart-Service -Name Spooler -Force

			Stop-Process -Name OneDrive -Force -ErrorAction Ignore
			Stop-Process -Name FileCoAuth -Force -ErrorAction Ignore

			if ((Get-ChildItem -Path $env:SystemDrive\Temp -Force -ErrorAction Ignore | Measure-Object).Count -eq 0)
			{
				Remove-Item -Path $env:SystemDrive\Temp -Recurse -Force
			}
			else
			{
				Write-Verbose -Message ($Localization.TempNotEmpty -f $env:TEMP) -Verbose
			}

			[Environment]::SetEnvironmentVariable("TMP", "$env:LOCALAPPDATA\Temp", "User")
			[Environment]::SetEnvironmentVariable("TMP", "$env:SystemRoot\TEMP", "Machine")
			[Environment]::SetEnvironmentVariable("TMP", "$env:LOCALAPPDATA\Temp", "Process")
			New-ItemProperty -Path HKCU:\Environment -Name TMP -PropertyType ExpandString -Value $env:LOCALAPPDATA\Temp -Force

			[Environment]::SetEnvironmentVariable("TEMP", "$env:LOCALAPPDATA\Temp", "User")
			[Environment]::SetEnvironmentVariable("TEMP", "$env:SystemRoot\TEMP", "Machine")
			[Environment]::SetEnvironmentVariable("TEMP", "$env:LOCALAPPDATA\Temp", "Process")
			New-ItemProperty -Path HKCU:\Environment -Name TEMP -PropertyType ExpandString -Value $env:LOCALAPPDATA\Temp -Force

			New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name TMP -PropertyType ExpandString -Value $env:SystemRoot\TEMP -Force
			New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name TEMP -PropertyType ExpandString -Value $env:SystemRoot\TEMP -Force
		}
	}
}

<#
	.SYNOPSIS
	Disable/enable Windows 260 character path limit
	Отключить/включить ограничение Windows на 260 символов в пути

	.PARAMETER Disable
	Disable Windows 260 character path limit
	Включить ограничение Windows на 260 символов в пути

	.PARAMETER Enable
	Enable Windows 260 character path limit
	Включить ограничение Windows на 260 символов в пути

	.EXAMPLE
	Win32LongPathLimit -Disable

	.EXAMPLE
	Win32LongPathLimit -Enable
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
	Display/do not dispaly the Stop error information on the BSoD
	Отображать/не отображать Stop-ошибку при появлении BSoD

	.PARAMETER Disable
	Disable Windows 260 characters path limit
	Включить ограничение Windows на 260 символов в пути

	.PARAMETER Enable
	Enable Windows 260 characters path limit
	Включить ограничение Windows на 260 символов в пути

	.EXAMPLE
	BSoDStopError -Disable

	.EXAMPLE
	BSoDStopError -Enable
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
	Change "Behavior of the elevation prompt for administrators in Admin Approval Mode" to "Elevate without prompting"/"Prompt for consent for non-Windows binaries"
	Изменить "Поведение запроса на повышение прав для администраторов в режиме одобрения администратором" на "Повышение прав без запроса"/"Запрос согласия для исполняемых файлов, отличных от Windows"

	.PARAMETER Disable
	Change "Behavior of the elevation prompt for administrators in Admin Approval Mode" to "Elevate without prompting"
	Изменить "Поведение запроса на повышение прав для администраторов в режиме одобрения администратором" на "Повышение прав без запроса"

	.PARAMETER Enable
	Change "Behavior of the elevation prompt for administrators in Admin Approval Mode" to "Prompt for consent for non-Windows binaries"
	Изменить "Поведение запроса на повышение прав для администраторов в режиме одобрения администратором" на "Запрос согласия для исполняемых файлов, отличных от Windows"

	.EXAMPLE
	AdminApprovalMode -Disable

	.EXAMPLE
	AdminApprovalMode -Enable
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
	Turn on/turn off access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled
	Включить/отключить доступ к сетевым дискам при включенном режиме одобрения администратором при доступе из программ, запущенных с повышенными правами

	.PARAMETER Disable
	Turn off access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled
	Отключить доступ к сетевым дискам при включенном режиме одобрения администратором при доступе из программ, запущенных с повышенными правами

	.PARAMETER Enable
	Turn on access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled
	Включить доступ к сетевым дискам при включенном режиме одобрения администратором при доступе из программ, запущенных с повышенными правами

	.EXAMPLE
	MappedDrivesAppElevatedAccess -Disable

	.EXAMPLE
	MappedDrivesAppElevatedAccess -Enable
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
	Opt-out of/opt-in to the Delivery Optimization-assisted updates downloading
	Отключить/включить загрузку обновлений с помощью оптимизации доставки

	.PARAMETER Disable
	Opt-out of to the Delivery Optimization-assisted updates downloading
	Отказаться от загрузки обновлений с помощью оптимизации доставки

	.PARAMETER Enable
	Opt-in to the Delivery Optimization-assisted updates downloading
	Включить загрузку обновлений с помощью оптимизации доставки

	.EXAMPLE
	DeliveryOptimization -Disable

	.EXAMPLE
	DeliveryOptimization -Enable
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
	Always/never wait for the network at computer startup and logon for workgroup networks
	Всегда/никогда не ждать сеть при запуске и входе в систему для рабочих групп

	.PARAMETER Disable
	Never wait for the network at computer startup and logon for workgroup networks
	Никогда не ждать сеть при запуске и входе в систему для рабочих групп

	.PARAMETER Enable
	Always wait for the network at computer startup and logon for workgroup networks
	Всегда ждать сеть при запуске и входе в систему для рабочих групп

	.EXAMPLE
	WaitNetworkStartup -Disable

	.EXAMPLE
	WaitNetworkStartup -Enable
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
	Do not let/let Windows decide which printer should be the default one
	Не разрешать/разрешать Windows решать, какой принтер должен использоваться по умолчанию

	.PARAMETER Disable
	Do not let Windows decide which printer should be the default one
	Не разрешать Windows решать, какой принтер должен использоваться по умолчанию

	.PARAMETER Enable
	Let Windows decide which printer should be the default one
	Разрешать Windows решать, какой принтер должен использоваться по умолчанию

	.EXAMPLE
	WindowsManageDefaultPrinter -Disable

	.EXAMPLE
	WindowsManageDefaultPrinter -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Disable/enable Windows features
	Отключить/включить компоненты Windows

	.PARAMETER Disable
	Disable Windows features
	Отключить компоненты Windows

	.PARAMETER Enable
	Enable Windows features
	Включить компоненты Windows

	.EXAMPLE
	WindowsFeatures -Disable

	.EXAMPLE
	WindowsFeatures -Enable

	.NOTES
	A pop-up dialog box enables the user to select features
	Current user only

	Используется всплывающее диалоговое окно, позволяющее пользователю отмечать компоненты
	Только для текущего пользователя

	Made by https://github.com/oz-zo, iNNOKENTIY21
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
	# Создать массив для выбранных компонентов Windows
	$SelectedFeatures = New-Object -TypeName System.Collections.ArrayList($null)

	# The following FODv2 items will have their checkboxes checked
	# Следующие дополнительные компоненты будут иметь чекбоксы отмеченными
	[string[]]$CheckedFeatures = @(
		# Legacy Components
		# Компоненты прежних версий
		"LegacyComponents",

		<#
			Media Features
			Компоненты работы с мультимедиа

			If you want to leave "Multimedia settings" in the advanced settings of Power Options do not uninstall this feature
			Если вы хотите оставить параметр "Параметры мультимедиа" в дополнительных параметрах электропитания, не удаляйте этот компонент
		#>
		"MediaPlayback",

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
	#endregion Variables

	#region XAML Markup
	# The section defines the design of the upcoming dialog box
	# Раздел, определяющий форму диалогового окна
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
			# Если компонент выделен, то добавить в массив
			if ($CheckBox.IsChecked)
			{
				[void]$SelectedFeatures.Add($Feature)
			}
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

	# Получаем общий список дополнительных компонентов, согласно условиям
	# Getting a list of features according to the conditions
	$OFS = "|"
	$Features = Get-WindowsOptionalFeature -Online | Where-Object -FilterScript {
		($_.State -in $State) -and ($_.FeatureName -cmatch $CheckedFeatures)
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

	$Window.Title = $Localization.WindowsFeaturesWindowTitle
	$Form.ShowDialog() | Out-Null
}

<#
	.SYNOPSIS
	Uninstall/install Features On Demand v2 (FODv2) capabilities
	Удалить/установить компоненты "Функции по требованию" (FODv2)

	.PARAMETER Uninstall
	Uninstall Features On Demand v2 (FODv2) capabilities
	Удалить компоненты "Функции по требованию" (FODv2)

	.PARAMETER Install
	Install Features On Demand v2 (FODv2) capabilities
	Установить компоненты "Функции по требованию" (FODv2)

	.EXAMPLE
	WindowsCapabilities -Uninstall

	.EXAMPLE
	WindowsCapabilities -Install

	.NOTES
	A pop-up dialog box enables the user to select features
	Current user only

	Используется всплывающее диалоговое окно, позволяющее пользователю отмечать компоненты
	Только для текущего пользователя

	Made by https://github.com/oz-zo, iNNOKENTIY21
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
	# Initialize an array list to store the selected FODv2 items
	# Создать массив дополнительных компонентов для выбранных элементов
	$SelectedCapabilities = New-Object -TypeName System.Collections.ArrayList($null)

	# The following FODv2 items will have their checkboxes checked
	# Следующие дополнительные компоненты будут иметь чекбоксы отмеченными
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

	# The following FODv2 items will have their checkboxes unchecked
	# Следующие дополнительные компоненты будут иметь чекбоксы неотмеченными
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

	# The following FODv2 items will be excluded from the display
	# Следующие дополнительные компоненты будут исключены из отображения
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
	# Раздел, определяющий форму диалогового окна
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

		if ([string]$SelectedCapabilities.Name -cmatch "Browser.InternetExplorer*")
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

		if ([string]$SelectedCapabilities.Name -cmatch "Browser.InternetExplorer*")
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
			# Если компонент выделен, то добавить в массив
			if ($UnCheckedCapabilities | Where-Object -FilterScript {$Capability.Name -like $_})
			{
				$CheckBox.IsChecked = $false
				# Exit function if item is not checked
				# Выход из функции, если элемент не выделен
				return
			}

			# If capability checked add to the array list
			# Если компонент выделен, то добавить в массив
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

	# Получаем общий список дополнительных компонентов, согласно условиям
	# Getting a list of capabilities according to the conditions
	$OFS = "|"
	$Capabilities = Get-WindowsCapability -Online | Where-Object -FilterScript {
		($_.State -eq $State) -and (($_.Name -cmatch $UncheckedCapabilities) -or ($_.Name -cmatch $CheckedCapabilities) -and ($_.Name -cnotmatch $ExcludedCapabilities))
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

	$Window.Title = $Localization.FODWindowTitle
	$Form.ShowDialog() | Out-Null
}

<#
	.SYNOPSIS
	Opt-in to/opt-out of Microsoft Update service, so to receive updates for other Microsoft products
	Подключаться/не подключаться к службе Microsoft Update так, чтобы при обновлении Windows получать обновления для других продуктов Майкрософт

	.PARAMETER Disable
	Opt-out of Microsoft Update service, so to receive updates for other Microsoft products
	Не подключаться к службе Microsoft Update так, чтобы при обновлении Windows получать обновления для других продуктов Майкрософт

	.PARAMETER Enable
	Opt-in to Microsoft Update service, so to receive updates for other Microsoft products
	Подключаться к службе Microsoft Update так, чтобы при обновлении Windows получать обновления для других продуктов Майкрософт

	.EXAMPLE
	UpdateMicrosoftProducts -Disable

	.EXAMPLE
	UpdateMicrosoftProducts -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
			if ((New-Object -ComObject Microsoft.Update.ServiceManager).Services | Where-Object {$_.ServiceID -eq "7971f918-a847-4430-9279-4a52d1efe18d"} )
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
	Do not let/let UWP apps run in the background
	Не разрешать/разрешать UWP-приложениям работать в фоновом режиме

	.PARAMETER Disable
	Do not let UWP apps run in the background, except those are saved in $ExcludedBackgroundApps variable
	Не разрешать UWP-приложениям работать в фоновом режиме, кроме тех, что сохранены в переменной $ExcludedBackgroundApps

	.PARAMETER Enable
	Let all UWP apps run in the background
	Разрешать всем UWP-приложениям работать в фоновом режиме

	.EXAMPLE
	BackgroundUWPApps -Disable

	.EXAMPLE
	BackgroundUWPApps -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
			# Открыть раздел "Фоновые приложения"
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

<#
	.SYNOPSIS
	Set the power management scheme on "High performance" (if device is a desktop)/"Balanced"
	Установить схему управления питанием на "Высокая производительность" (если устройство является стационарным ПК)/"Сбалансированная"

	.PARAMETER High
	Set the power management scheme on "High performance" if device is a desktop
	Установить схему управления питанием на "Высокая производительность"

	.PARAMETER Balanced
	Set the power management scheme on "Balanced"
	Установить схему управления питанием на Сбалансированная"

	.EXAMPLE
	PowerManagementScheme -High

	.EXAMPLE
	PowerManagementScheme -Balanced
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
			if ((Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType -eq 1)
			{
				POWERCFG /SETACTIVE SCHEME_MIN
			}
		}
		"Balanced"
		{
			POWERCFG /SETACTIVE SCHEME_BALANCED
		}
	}
}

<#
	.SYNOPSIS
	Use/do not use latest installed .NET runtime for all apps
	Использовать/не использовать последнюю установленную среду выполнения .NET для всех приложений

	.PARAMETER Disable
	Do not use latest installed .NET runtime for all apps
	Не использовать последнюю установленную среду выполнения .NET для всех приложений

	.PARAMETER Enable
	Use use latest installed .NET runtime for all apps
	Использовать последнюю установленную среду выполнения .NET для всех приложений

	.EXAMPLE
	LatestInstalled.NET -Disable

	.EXAMPLE
	LatestInstalled.NET -Enable
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
	Do not allow/allow the computer (if device is not a laptop) to turn off the network adapters to save power
	Запретить/разрешить отключение всех сетевых адаптеров для экономии энергии (если устройство не является ноутбуком)

	.PARAMETER Disable
	Do not allow the computer (if device is not a laptop) to turn off the network adapters to save power
	Запретить отключение всех сетевых адаптеров для экономии энергии (если устройство не является ноутбуком)

	.PARAMETER Enable
	Allow the computer (if device is not a laptop) to turn off the network adapters to save power
	Разрешить отключение всех сетевых адаптеров для экономии энергии (если устройство не является ноутбуком)

	.EXAMPLE
	PCTurnOffDevice -Disable

	.EXAMPLE
	PCTurnOffDevice -Enable
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
			if ((Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType -ne 2)
			{
				foreach ($Adapter in $Adapters)
				{
					$Adapter.AllowComputerToTurnOffDevice = "Disabled"
					$Adapter | Set-NetAdapterPowerManagement
				}
			}
		}
		"Enable"
		{
			if ((Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType -ne 2)
			{
				foreach ($Adapter in $Adapters)
				{
					$Adapter.AllowComputerToTurnOffDevice = "Enabled"
					$Adapter | Set-NetAdapterPowerManagement
				}
			}
		}
	}
}

<#
	.SYNOPSIS
	Set/reset the default input method to the English language
	Установить/сбросить метод ввода по умолчанию на английский язык

	.PARAMETER English
	Set the default input method to the English language
	Установить метод ввода по умолчанию на английский язык

	.PARAMETER Default
	Reset the default input method to the English language
	Сбросить метод ввода по умолчанию на английский язык

	.EXAMPLE
	SetInputMethod -English

	.EXAMPLE
	SetInputMethod -Default
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
	Change the location of the user folders to any disks root of your choice using the interactive menu
	Изменить расположение пользовательских папок в корень любого диска на выбор с помощью интерактивного меню

	.PARAMETER Root
	Change the location of the user folders to any disks root of your choice using the interactive menu
	Изменить расположение пользовательских папок в корень любого диска на выбор с помощью интерактивного меню

	.PARAMETER Custom
	Select a folder for the location of the user folders manually using a folder browser dialog
	Выбрать папку для расположения пользовательских папок вручную, используя диалог "Обзор папок"

	.PARAMETER Default
	Change the location of the user folders to the default values
	Изменить расположение пользовательских папок на значения по умолчанию

	.EXAMPLE
	SetUserShellFolderLocation -Root

	.EXAMPLE
	SetUserShellFolderLocation -Custom

	.EXAMPLE
	SetUserShellFolderLocation -Default

	.NOTES
	User files or folders won't me moved to a new location
	Current user only

	Пользовательские файлы и папки не будут перемещены в новое расположение
	Только для текущего пользователя
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
		Изменить расположение каждой пользовательской папки, используя функцию "SHSetKnownFolderPath"

		.PARAMETER RemoveDesktopINI
		The RemoveDesktopINI argument removes desktop.ini in the old user shell folder
		Аргумент "RemoveDesktopINI" удаляет файл desktop.ini из старой пользовательской папки

		.EXAMPLE
		UserShellFolder -UserFolder Desktop -FolderPath "$env:SystemDrive:\Desktop" -RemoveDesktopINI

		.NOTES
		User files or folders won't me moved to a new location
		Пользовательские файлы не будут перенесены в новое расположение

		https://docs.microsoft.com/en-us/windows/win32/api/shlobj_core/nf-shlobj_core-shgetknownfolderpath
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

		function KnownFolderPath
		{
		<#
			.SYNOPSIS
			Redirect user folders to a new location

			.EXAMPLE
			KnownFolderPath -KnownFolder Desktop -Path "$env:SystemDrive:\Desktop"
		#>
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
		# Содержимое скрытого файла desktop.ini для каждого типа пользовательских папок
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
		# Определяем текущее значение пути пользовательской папки
		$UserShellFolderRegValue = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name $UserShellFoldersRegName[$UserFolder]
		if ($UserShellFolderRegValue -ne $FolderPath)
		{
			if ((Get-ChildItem -Path $UserShellFolderRegValue | Measure-Object).Count -ne 0)
			{
				Write-Error -Message ($Localization.UserShellFolderNotEmpty -f $UserShellFolderRegValue) -ErrorAction SilentlyContinue
			}

			# Creating a new folder if there is no one
			# Создаем новую папку, если таковая отсутствует
			if (-not (Test-Path -Path $FolderPath))
			{
				New-Item -Path $FolderPath -ItemType Directory -Force
			}

			# Removing old desktop.ini
			# Удаляем старый desktop.ini
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
		The "Show menu" function using PowerShell with the up/down arrow keys and enter key to make a selection
		Функция "Show menu" для перемещения с помощью стрелочек между объектами и Enter для выбора

		.EXAMPLE
		ShowMenu -Menu $ListOfItems -Default $DefaultChoice

		.NOTES
		Doesn't work in PowerShell ISE
		Не работает в PowerShell ISE

		https://qna.habr.com/user/MaxKozlov
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

	switch ($PSCmdlet.ParameterSetName)
	{
		"Root"
		{
			# Store all drives letters to use them within ShowMenu function
			# Сохранить все буквы диска, чтобы использовать их в функции ShowMenu
			Write-Verbose -Message $Localization.RetrievingDrivesList -Verbose
			$DriveLetters = @((Get-Disk | Where-Object -FilterScript {$_.BusType -ne "USB"} | Get-Partition | Get-Volume | Where-Object -FilterScript {$null -ne $_.DriveLetter}).DriveLetter | Sort-Object)

			# If the number of disks is more than one, set the second drive in the list as default drive
			# Если количество дисков больше одного, сделать второй диск в списке диском по умолчанию
			if ($DriveLetters.Count -gt 1)
			{
				$Script:Default = 1
			}
			else
			{
				$Script:Default = 0
			}

			# Desktop
			# Рабочий стол
			Write-Verbose -Message $Localization.DesktopDriveSelect -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.DesktopRequest
			$Change = $Localization.Change
			$Skip = $Localization.Skip
			$Options = "&$Change", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					$SelectedDrive = ShowMenu -Title $Localization.DesktopDriveSelect -Menu $DriveLetters -Default $Script:Default
					UserShellFolder -UserFolder Desktop -FolderPath "${SelectedDrive}:\Desktop" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Documents
			# Документы
			Write-Verbose -Message $Localization.DocumentsDriveSelect -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.DocumentsRequest
			$Change = $Localization.Change
			$Skip = $Localization.Skip
			$Options = "&$Change", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					$SelectedDrive = ShowMenu -Title $Localization.DocumentsDriveSelect -Menu $DriveLetters -Default $Script:Default
					UserShellFolder -UserFolder Documents -FolderPath "${SelectedDrive}:\Documents" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Downloads
			# Загрузки
			Write-Verbose -Message $Localization.DownloadsDriveSelect -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.DownloadsRequest
			$Change = $Localization.Change
			$Skip = $Localization.Skip
			$Options = "&$Change", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					$SelectedDrive = ShowMenu -Title $Localization.DownloadsDriveSelect -Menu $DriveLetters -Default $Script:Default
					UserShellFolder -UserFolder Downloads -FolderPath "${SelectedDrive}:\Downloads" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Music
			# Музыка
			Write-Verbose -Message $Localization.MusicDriveSelect -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.MusicRequest
			$Change = $Localization.Change
			$Skip = $Localization.Skip
			$Options = "&$Change", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					$SelectedDrive = ShowMenu -Title $Localization.MusicDriveSelect -Menu $DriveLetters -Default $Script:Default
					UserShellFolder -UserFolder Music -FolderPath "${SelectedDrive}:\Music" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Pictures
			# Изображения
			Write-Verbose -Message $Localization.PicturesDriveSelect -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.PicturesRequest
			$Change = $Localization.Change
			$Skip = $Localization.Skip
			$Options = "&$Change", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					$SelectedDrive = ShowMenu -Title $Localization.PicturesDriveSelect -Menu $DriveLetters -Default $Script:Default
					UserShellFolder -UserFolder Pictures -FolderPath "${SelectedDrive}:\Pictures" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Videos
			# Видео
			Write-Verbose -Message $Localization.VideosDriveSelect -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.VideosRequest
			$Change = $Localization.Change
			$Skip = $Localization.Skip
			$Options = "&$Change", "&$Skip"
			$DefaultChoice = 1
			$Result = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					$SelectedDrive = ShowMenu -Title $Localization.VideosDriveSelect -Menu $DriveLetters -Default $Script:Default
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
			# Рабочий стол
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.DesktopFolderSelect
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
					# Перевести фокус на диалог открытия файла
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
			# Документы
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.DocumentsFolderSelect
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
					# Перевести фокус на диалог открытия файла
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
			# Загрузки
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.DownloadsFolderSelect
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
					# Перевести фокус на диалог открытия файла
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
			# Музыка
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.MusicFolderSelect
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
					# Перевести фокус на диалог открытия файла
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
			# Изображения
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.PicturesFolderSelect
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
					# Перевести фокус на диалог открытия файла
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
			# Видео
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.VideosFolderSelect
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
					# Перевести фокус на диалог открытия файла
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
			# Рабочий стол
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.DesktopDefaultFolder
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
			# Документы
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.DocumentsDefaultFolder
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
			# Загрузки
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.DownloadsDefaultFolder
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
			# Музыка
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.MusicDefaultFolder
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
			# Изображения
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.PicturesDefaultFolder
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
			# Видео
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message = $Localization.VideosDefaultFolder
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
	Save screenshots by pressing Win+PrtScr to the Desktop/Pictures folder
	Сохранять скриншоты по нажатию Win+PrtScr в папку "Рабочий стол"/"Изображения"

	.PARAMETER Desktop
	Save screenshots by pressing Win+PrtScr to the Desktop folder
	Сохранять скриншоты по нажатию Win+PrtScr в папку "Рабочий стол"

	.PARAMETER Default
	Save screenshots by pressing Win+PrtScr to the Pictures folder
	Сохранять скриншоты по нажатию Win+PrtScr в папку "Изображения"

	.EXAMPLE
	WinPrtScrFolder -Desktop

	.EXAMPLE
	WinPrtScrFolder -Default

	.NOTES
	Current user only
	Только для текущего пользователя
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
	# Сохранить все открытые папки, чтобы восстановить их после перезапуска проводника
	Clear-Variable -Name OpenedFolders -Force -ErrorAction Ignore
	$OpenedFolders = {(New-Object -ComObject Shell.Application).Windows() | ForEach-Object -Process {$_.Document.Folder.Self.Path}}.Invoke()

	# In order for the changes to take effect the File Explorer process has to be restarted
	# Чтобы изменения вступили в силу, необходимо перезапустить процесс проводника
	Stop-Process -Name explorer -Force

	# Restoring closed folders
	# Восстановить закрытые папки
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
	Run troubleshooters automatically, then notify
	Автоматически запускать средства устранения неполадок, а затем уведомлять

	Ask me before running troubleshooters
	Спрашивать перед запуском средств устранения неполадок

	.PARAMETER Automatic
	Run troubleshooters automatically, then notify
	Автоматически запускать средства устранения неполадок, а затем уведомлять

	.PARAMETER Default
	Ask me before running troubleshooters
	Спрашивать перед запуском средств устранения неполадок

	.EXAMPLE
	RecommendedTroubleshooting -Automatic

	.EXAMPLE
	RecommendedTroubleshooting -Default

	.NOTES
	In order this feature to work the OS level of diagnostic data gathering must be set to "Optional diagnostic data"
	Необходимо установить уровень сбора диагностических сведений ОС на "Необязательные диагностические данные", чтобы работала данная функция
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
	# Установить уровень сбора диагностических сведений ОС на "Необязательные диагностические данные"
	New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 3 -Force
}

<#
	.SYNOPSIS
	Launch/do not launch folder windows in a separate process
	Запускать/не запускать окна с папками в отдельном процессе

	.PARAMETER Enable
	Launch launch folder windows in a separate process
	Запускать окна с папками в отдельном процессе

	.PARAMETER Disable
	Do not launch folder windows in a separate process
	Не запускать окна с папками в отдельном процессе

	.EXAMPLE
	FoldersLaunchSeparateProcess -Enable

	.EXAMPLE
	FoldersLaunchSeparateProcess -Disable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Disable and delete/enable reserved storage after the next update installation
	Отключить и удалить/включить зарезервированное хранилище после следующей установки обновлений

	.PARAMETER Enable
	Enable reserved storage after the next update installation
	Включить зарезервированное хранилище после следующей установки обновлений

	.PARAMETER Disable
	Disable and delete reserved storage after the next update installation
	Отключить и удалить зарезервированное хранилище после следующей установки обновлений

	.EXAMPLE
	ReservedStorage -Enable

	.EXAMPLE
	ReservedStorage -Disable
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
	Disable/enable help lookup via F1
	Отключить/включить открытие справки по нажатию F1

	.PARAMETER Enable
	Enable help lookup via F1
	Включить открытие справки по нажатию F1

	.PARAMETER Disable
	Disable help lookup via F1
	Отключить открытие справки по нажатию F1

	.EXAMPLE
	F1HelpPage -Enable

	.EXAMPLE
	F1HelpPage -Disable

	.NOTES
	Current user only
	Только для текущего пользователя
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
			New-ItemProperty -Path "HKCU:\SOFTWARE\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64" -Name "(Default)" -PropertyType String -Value "" -Force
		}
	}
}

<#
	.SYNOPSIS
	Enable/disable Num Lock at startup
	Включить/отключить Num Lock при загрузке

	.PARAMETER Enable
	Enable Num Lock at startup
	Включить Num Lock при загрузке

	.PARAMETER Disable
	Disable Num Lock at startup
	Отключить Num Lock при загрузке

	.EXAMPLE
	NumLock -Enable

	.EXAMPLE
	NumLock -Disable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Enable/disable Caps Lock
	Включить/отключить Num Lock

	.PARAMETER Enable
	Enable Capsm Lock
	Включить Caps Lock

	.PARAMETER Disable
	Disable Caps Lock
	Отключить Caps Lock

	.EXAMPLE
	CapsLock -Enable

	.EXAMPLE
	CapsLock -Disable
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
	Disable/enable StickyKey after tapping the Shift key 5 times
	Отключить/включить залипание клавиши Shift после 5 нажатий

	.PARAMETER Enable
	Enable StickyKey after tapping the Shift key 5 times
	Включить залипание клавиши Shift после 5 нажатий

	.PARAMETER Disable
	Disable StickyKey after tapping the Shift key 5 times
	Отключить залипание клавиши Shift после 5 нажатий

	.EXAMPLE
	StickyShift -Enable

	.EXAMPLE
	StickyShift -Disable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Disable/enable AutoPlay for all media and devices
	Отключить/включить автозапуск для всех носителей и устройств

	.PARAMETER Enable
	Disable/enable AutoPlay for all media and devices
	Отключить/включить автозапуск для всех носителей и устройств

	.PARAMETER Disable
	Disable/enable AutoPlay for all media and devices
	Отключить/включить автозапуск для всех носителей и устройств

	.EXAMPLE
	Autoplay -Enable

	.EXAMPLE
	Autoplay -Disable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Disable/enable thumbnail cache removal
	Отключить/включить удаление кэша миниатюр

	.PARAMETER Enable
	Enable thumbnail cache removal
	Включить удаление кэша миниатюр

	.PARAMETER Disable
	Disable thumbnail cache removal
	Отключить удаление кэша миниатюр

	.EXAMPLE
	ThumbnailCacheRemoval -Enable

	.EXAMPLE
	ThumbnailCacheRemoval -Disable
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
	Enable/disable automatically saving my restartable apps when signing out and restart them after signing in
	Включить/отключить автоматическое сохранение моих перезапускаемых приложений при выходе из системы и перезапускать их после выхода

	.PARAMETER Enable
	Enable automatically saving my restartable apps when signing out and restart them after signing in
	Включить автоматическое сохранение моих перезапускаемых приложений при выходе из системы и перезапускать их после выхода

	.PARAMETER Disable
	Disable automatically saving my restartable apps when signing out and restart them after signing in
	Отключить автоматическое сохранение моих перезапускаемых приложений при выходе из системы и перезапускать их после выхода

	.EXAMPLE
	SaveRestartableApps -Enable

	.EXAMPLE
	SaveRestartableApps -Disable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Enable/disable "Network Discovery" and "File and Printers Sharing" for workgroup networks
	Включить/отключить сетевое обнаружение и общий доступ к файлам и принтерам для рабочих групп

	.PARAMETER Enable
	Enable "Network Discovery" and "File and Printers Sharing" for workgroup networks
	Включить сетевое обнаружение и общий доступ к файлам и принтерам для рабочих групп

	.PARAMETER Disable
	Disable "Network Discovery" and "File and Printers Sharing" for workgroup networks
	Отключить сетевое обнаружение и общий доступ к файлам и принтерам для рабочих групп

	.EXAMPLE
	NetworkDiscovery -Enable

	.EXAMPLE
	NetworkDiscovery -Disable
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
	Enable/disable automatically adjusting active hours for me based on daily usage
	Включить/отключить автоматическое изменение периода активности для этого устройства на основе действий

	.PARAMETER Enable
	Enable automatically adjusting active hours for me based on daily usage
	Включить автоматическое изменение периода активности для этого устройства на основе действий

	.PARAMETER Disable
	Disable automatically adjusting active hours for me based on daily usage
	Отключить автоматическое изменение периода активности для этого устройства на основе действий

	.EXAMPLE
	SmartActiveHours -Enable

	.EXAMPLE
	SmartActiveHours -Disable
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
	Enable/disable restarting this device as soon as possible when a restart is required to install an update
	Включить/отключить перезапуск этого устройства как можно быстрее, если для установки обновления требуется перезагрузка

	.PARAMETER Enable
	Enable restarting this device as soon as possible when a restart is required to install an update
	Включить перезапуск этого устройства как можно быстрее, если для установки обновления требуется перезагрузка

	.PARAMETER Disable
	Disable restarting this device as soon as possible when a restart is required to install an update
	Отключить перезапуск этого устройства как можно быстрее, если для установки обновления требуется перезагрузка

	.EXAMPLE
	DeviceRestartAfterUpdate -Enable

	.EXAMPLE
	DeviceRestartAfterUpdate -Disable
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
#endregion System

#region WSL
<#
	.SYNOPSIS
	Install/uninstall the Windows Subsystem for Linux (WSL)
	Установить/удалить подсистему Windows для Linux (WSL)

	.PARAMETER Enable
	Install the Windows Subsystem for Linux (WSL)
	Установить подсистему Windows для Linux (WSL)

	.PARAMETER Disable
	Uninstall the Windows Subsystem for Linux (WSL)
	Удалить подсистему Windows для Linux (WSL)

	.EXAMPLE
	WSL -Enable

	.EXAMPLE
	WSL -Disable
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
		# Подсистема Windows для Linux
		"Microsoft-Windows-Subsystem-Linux",

		# Virtual Machine Platform
		# Поддержка платформы для виртуальных машин
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
	Скачать, установить пакет обновления ядра Linux и установить WSL 2 как версию по умолчанию при установке нового дистрибутива Linux

	.NOTES
	To receive kernel updates, enable the Windows Update setting: "Receive updates for other Microsoft products when you update Windows"
	Чтобы получать обновления ядра, включите параметр Центра обновления Windows: "Получение обновлений для других продуктов Майкрософт при обновлении Windows"
#>
function EnableWSL2
{
	$WSLFeatures = @(
		# Windows Subsystem for Linux
		# Подсистема Windows для Linux
		"Microsoft-Windows-Subsystem-Linux",

		# Virtual Machine Platform
		# Поддержка платформы для виртуальных машин
		"VirtualMachinePlatform"
	)
	$WSLFeaturesDisabled = Get-WindowsOptionalFeature -Online | Where-Object {($_.FeatureName -in $WSLFeatures) -and ($_.State -eq "Disabled")}

	if ($null -eq $WSLFeaturesDisabled)
	{
		if ((Get-Package -Name "Windows Subsystem for Linux Update" -ProviderName msi -Force -ErrorAction Ignore).Status -ne "Installed")
		{
			# Downloading and installing the Linux kernel update package
			# Скачивание и установка пакета обновления ядра Linux
			try
			{
				if ((Invoke-WebRequest -Uri https://www.google.com -UseBasicParsing -DisableKeepAlive -Method Head).StatusDescription)
				{
					Write-Verbose -Message $Localization.WSLUpdateDownloading -Verbose

					[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
					$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
					$Parameters = @{
						Uri = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
						OutFile = "$DownloadsFolder\wsl_update_x64.msi"
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
			# Установить WSL 2 как архитектуру по умолчанию при установке нового дистрибутива Linux
			wsl --set-default-version 2
		}
	}
}
#endregion WSL

#region Start menu
<#
	.SYNOPSIS
	Hide/show recently added apps in the Start menu
	Скрывать/показывать недавно добавленные приложения в меню "Пуск"

	.PARAMETER Hide
	Hide recently added apps in the Start menu
	Скрывать недавно добавленные приложения в меню "Пуск"

	.PARAMETER Show
	Show recently added apps in the Start menu
	Показывать недавно добавленные приложения в меню "Пуск"

	.EXAMPLE
	RecentlyAddedApps -Hide

	.EXAMPLE
	RecentlyAddedApps -Show
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
	Hide/show app suggestions in the Start menu
	Скрывать/показывать рекомендации в меню "Пуск"

	.PARAMETER Hide
	Hide app suggestions in the Start menu
	Скрывать рекомендации в меню "Пуск"

	.PARAMETER Show
	Show app suggestions in the Start menu
	Показывать рекомендации в меню "Пуск"

	.EXAMPLE
	AppSuggestions -Hide

	.EXAMPLE
	AppSuggestions -Show
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
	Run the Command Prompt shortcut from the Start menu as Administrator/user
	Запускать ярлык командной строки в меню "Пуск" от имени Администратора/пользователя

	.PARAMETER Elevated
	Run the Command Prompt shortcut from the Start menu as Administrator
	Запускать ярлык командной строки в меню "Пуск" от имени Администратора

	.PARAMETER NonElevated
	Run the Command Prompt shortcut from the Start menu as user
	Запускать ярлык командной строки в меню "Пуск" от имени пользователя

	.EXAMPLE
	RunCMDShortcut -Elevated

	.EXAMPLE
	RunCMDShortcut -NonElevated
#>
function RunCMDShortcut
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
			[byte[]]$bytes = Get-Content -Path "$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\Command Prompt.lnk" -Encoding Byte -Raw
			$bytes[0x15] = $bytes[0x15] -bor 0x20
			Set-Content -Path "$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\Command Prompt.lnk" -Value $bytes -Encoding Byte -Force
		}
		"NonElevated"
		{
			[byte[]]$bytes = Get-Content -Path "$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\Command Prompt.lnk" -Encoding Byte -Raw
			$bytes[0x15] = $bytes[0x15] -bxor 0x20
			Set-Content -Path "$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\Command Prompt.lnk" -Value $bytes -Encoding Byte -Force
		}
	}
}

# Unpin all the Start tiles
# Открепить все ярлыки от начального экрана
function UnpinAllStartTiles
{
	$StartMenuLayout = @"
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
<LayoutOptions StartTileGroupCellWidth="6" />
	<DefaultLayoutOverride>
		<StartLayoutCollection>
			<defaultlayout:StartLayout GroupCellWidth="6" />
		</StartLayoutCollection>
	</DefaultLayoutOverride>
</LayoutModificationTemplate>
"@
	$StartMenuLayoutPath = "$env:TEMP\StartMenuLayout.xml"
	# Saving StartMenuLayout.xml in UTF-8 encoding
	# Сохраняем StartMenuLayout.xml в кодировке UTF-8
	Set-Content -Path $StartMenuLayoutPath -Value $StartMenuLayout -Force

	# Temporarily disable changing the Start menu layout
	# Временно выключаем возможность редактировать начальный экран меню "Пуск"
	if (-not (Test-Path -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer))
	{
		New-Item -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Force
	}
	New-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name LockedStartLayout -Value 1 -Force
	New-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name StartLayoutFile -Value $StartMenuLayoutPath -Force

	# Restart the Start menu
	# Перезапустить меню "Пуск"
	Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction Ignore
	Start-Sleep -Seconds 3

	Remove-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name LockedStartLayout -Force -ErrorAction Ignore
	Remove-ItemProperty -Path HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name StartLayoutFile -Force -ErrorAction Ignore

	Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction Ignore
	Get-Item -Path $StartMenuLayoutPath | Remove-Item -Force -ErrorAction Ignore
}

<#
	.SYNOPSIS
	Extract string from shell32.dll using its' number
	Извлечь строку из shell32.dll, зная ее номер

	.EXAMPLE
	[WinAPI.GetStr]::GetString(12712)
#>
function GetLocalizedString
{
	$Signature = @{
		Namespace = "WinAPI"
		Name = "GetStr"
		Language = "CSharp"
		MemberDefinition = @"
// https://github.com/Disassembler0/Win10-Initial-Setup-Script/issues/8#issue-227159084
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
}

<#
	.SYNOPSIS
	Pin the "Control Panel" shortcut to Start within syspin
	Закрепить ярлык "Панели управления" на начальном экране с помощью syspin

	.EXAMPLE
	PinControlPanel
#>
function PinControlPanel
{
	# Extract the "Control Panel" string from shell32.dll
	# Извлечь строку "Панель управления" из shell32.dll
	GetLocalizedString
	$ControlPanel = [WinAPI.GetStr]::GetString(12712)

	Write-Verbose -Message ($Localization.ShortcutPinning -f $ControlPanel) -Verbose

	# Check whether the Control Panel shortcut was ever pinned
	# Проверка: закреплялся ли когда-нибудь ярлык панели управления
	if (Test-Path -Path "$env:APPDATA\Microsoft\Windows\Start menu\Programs\$ControlPanel.lnk")
	{
		$Arguments = @"
	"$env:APPDATA\Microsoft\Windows\Start menu\Programs\$ControlPanel.lnk" "51201"
"@
		Start-Process -FilePath $PSScriptRoot\syspin.exe -WindowStyle Hidden -ArgumentList $Arguments -Wait
	}
	else
	{
		# The "Pin" verb is not available on the control.exe file so the shortcut has to be created
		# Глагол "Закрепить на начальном экране" недоступен для control.exe, поэтому необходимо создать ярлык
		$Shell = New-Object -ComObject Wscript.Shell
		$Shortcut = $Shell.CreateShortcut("$env:SystemRoot\System32\$ControlPanel.lnk")
		$Shortcut.TargetPath = "control"
		$Shortcut.Save()

		$Arguments = @"
	"$env:SystemRoot\System32\$ControlPanel.lnk" "51201"
"@
		Start-Process -FilePath $PSScriptRoot\syspin.exe -WindowStyle Hidden -ArgumentList $Arguments -Wait

		Remove-Item -Path "$env:SystemRoot\System32\$ControlPanel.lnk" -Force -ErrorAction Ignore
	}
}

<#
	.SYNOPSIS
	Pin the old-style "Devices and Printers" shortcut to Start within syspin
	Закрепить ярлык старого формата "Устройства и принтеры" на начальном экране с помощью syspin

	.EXAMPLE
	PinDevicesPrinters
#>
function PinDevicesPrinters
{
	# Extract the "Devices and Printers" string from shell32.dll
	# Извлечь строку "Устройства и принтеры" из shell32.dll
	GetLocalizedString
	$DevicesPrinters = [WinAPI.GetStr]::GetString(30493)

	Write-Verbose -Message ($Localization.ShortcutPinning -f $DevicesPrinters) -Verbose

	$Shell = New-Object -ComObject Wscript.Shell
	$Shortcut = $Shell.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\$DevicesPrinters.lnk")
	$Shortcut.TargetPath = "control"
	$Shortcut.Arguments = "printers"
	$Shortcut.IconLocation = "$env:SystemRoot\system32\DeviceCenter.dll"
	$Shortcut.Save()

	# Pause for 3 sec, unless the "Devices and Printers" shortcut won't displayed in the Start menu
	# Пауза на 3 с, иначе ярлык "Устройства и принтеры" не будет отображаться в меню "Пуск"
	Start-Sleep -Seconds 3

	$Arguments = @"
	"$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\$DevicesPrinters.lnk" "51201"
"@
	Start-Process -FilePath $PSScriptRoot\syspin.exe -WindowStyle Hidden -ArgumentList $Arguments -Wait
}

<#
	.SYNOPSIS
	Pin the "Command Prompt" shortcut to Start within syspin
	Закрепить ярлык "Командная строка" на начальном экране с помощью syspin

	.EXAMPLE
	PinCommandPrompt
#>
function PinCommandPrompt
{
	# Extract the "Command Prompt" string from shell32.dll
	# Извлечь строку "Командная строка" из shell32.dll
	GetLocalizedString
	$CommandPrompt = [WinAPI.GetStr]::GetString(22022)

	Write-Verbose -Message ($Localization.ShortcutPinning -f $CommandPrompt) -Verbose

	$Arguments = @"
	"$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\Command Prompt.lnk" "51201"
"@
	Start-Process -FilePath $PSScriptRoot\syspin.exe -WindowStyle Hidden -ArgumentList $Arguments -Wait
}
#endregion Start menu

#region UWP apps
<#
	.SYNOPSIS
	Uninstall UWP apps
	Удалить UWP-приложения

	.DESCRIPTION
	Add UWP apps packages names to the $UncheckedAppXPackages array list by retrieving their packages names using the following command:
		(Get-AppxPackage -PackageTypeFilter Bundle -AllUsers).Name

	Добавьте имена пакетов UWP-приложений в массив $UncheckedAppXPackages, получив названия их пакетов с помощью команды:
		(Get-AppxPackage -PackageTypeFilter Bundle -AllUsers).Name

	App packages will not be installed for new users if the "Uninstall for All Users" box is checked
	Приложения не будут установлены для новых пользователе, если отмечено "Удалять для всех пользователей"

	.NOTES
	A pop-up dialog box enables the user to select packages
	Используется всплывающее диалоговое окно, позволяющее пользователю отмечать пакеты

	Current user only
	Только для текущего пользователя

	Made by https://github.com/oz-zo
#>
function UninstallUWPApps
{
	Add-Type -AssemblyName PresentationCore, PresentationFramework

	#region Variables
	# List of UWP apps that won't be recommended for removal
	# UWP-приложения, которые не будут отмечены на удаление по умолчанию
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

		# Calculator
		# Калькулятор
		"Microsoft.WindowsCalculator",

		# Xbox Identity Provider
		# Поставщик удостоверений Xbox
		"Microsoft.XboxIdentityProvider",

		# Xbox
		# Компаньон консоли Xbox
		"Microsoft.XboxApp",

		# Xbox (beta version)
		# Xbox (бета-версия)
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
	# Следующие UWP-приложения будут исключены из отображения
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
	#endregion Variables

	#region XAML Markup
	[xml]$XAML = '
	<Window
		xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Name="Window"
		MinHeight="450" MinWidth="400"
		SizeToContent="Width" WindowStartupLocation="CenterScreen"
		TextOptions.TextFormattingMode="Display" SnapsToDevicePixels="True"
		FontFamily="Candara" FontSize="16" ShowInTaskbar="False">
		<Window.Resources>
			<Style TargetType="StackPanel">
				<Setter Property="Orientation" Value="Horizontal"/>
				<Setter Property="Grid.Column" Value="1"/>
			</Style>
			<Style TargetType="CheckBox">
				<Setter Property="Margin" Value="10, 13, 10, 10"/>
				<Setter Property="IsChecked" Value="True"/>
			</Style>
			<Style TargetType="TextBlock">
				<Setter Property="Margin" Value="0, 10, 10, 10"/>
				<Setter Property="Margin" Value="0, 10, 10, 10"/>
			</Style>
			<Style TargetType="Button">
				<Setter Property="Margin" Value="20"/>
				<Setter Property="Padding" Value="10"/>
				<Setter Property="IsEnabled" Value="True"/>
			</Style>
			<Style TargetType="ScrollViewer">
			<Setter Property="Grid.Row" Value="1"/>
			<Setter Property="HorizontalScrollBarVisibility" Value="Disabled"/>
			<Setter Property="VerticalScrollBarVisibility" Value="Auto"/>
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
					<ColumnDefinition Width="Auto"/>
				</Grid.ColumnDefinitions>
				<StackPanel Name="PanelRemoveForAll">
					<TextBlock Name="TextBlockRemoveForAll" Margin="0, 10, 0, 10"/>
					<CheckBox Name="CheckBoxRemoveForAll" IsChecked="False"/>
				</StackPanel>
			</Grid>
			<ScrollViewer>
				<StackPanel Name="PanelContainer" Orientation="Vertical"/>
			</ScrollViewer>
			<Button Name="ButtonUninstall" Grid.Row="2"/>
		</Grid>
	</Window>
	'
	#endregion XAML Markup

	#region Functions
	function Get-AppxBundle
	{
		[CmdletBinding()]
		param
		(
			[Parameter(
				Mandatory = $false,
				ParameterSetName = "AllUsers",
				Position = 0
			)]
			[bool]
			$AllUsers = $false
		)

		Write-Verbose -Message $Localization.Patient -Verbose

		[Windows.Management.Deployment.PackageManager, Windows.Web, ContentType = WindowsRuntime]::new().FindPackages() | Select-Object -ExpandProperty Id -Property DisplayName | Where-Object -FilterScript {
			($_.Name -in (Get-AppxPackage -PackageTypeFilter Bundle -AllUsers:$AllUsers).Name) -and ($_.Name -notin $ExcludedAppxPackages) -and ($null -ne $_.DisplayName)} | ForEach-Object -Process {
				$Properties = @{
					[string]"DisplayName" = $_.DisplayName
					[string]"FullName"    = $_.FullName
					[string]"Name"        = $_.Name
				}
				return New-Object -TypeName PSObject -Property $Properties
			}
	}

	function CheckBoxRemoveForAllClick
	{
		$PanelContainer.Children.RemoveRange(0, $PanelContainer.Children.Count)
		Get-AppxBundle -AllUsers $CheckBoxRemoveForAll.IsChecked | Add-FormControls
	}

	function ButtonUninstallClick
	{
		$AppxPackages = New-Object -TypeName System.Collections.ArrayList($null)

		for
		(
			$i = 0
			$i -lt [System.Windows.Media.VisualTreeHelper]::GetChildrenCount($PanelContainer)
			$i++
		)
		{
			$CheckBox = [System.Windows.Media.VisualTreeHelper]::GetChild($PanelContainer, $i)

			if ($CheckBox.Children[0].IsChecked)
			{
				[void]$AppxPackages.Add($CheckBox.Children[0].Tag)
			}
		}

		[void]$Window.Close()

		$OFS = "|"

		if ($CheckboxRemoveForAll.IsChecked)
		{
			Get-AppxPackage -PackageTypeFilter Bundle -AllUsers | Where-Object -FilterScript {$_.Name -cmatch $AppxPackages} | Remove-AppxPackage -AllUsers -Verbose
		}
		else
		{
			Get-AppxPackage -PackageTypeFilter Bundle | Where-Object -FilterScript {$_.Name -cmatch $AppxPackages} | Remove-AppxPackage -Verbose
		}

		$OFS = " "
	}

	function Add-FormControls
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
			$Controls
		)

		process
		{
			foreach ($control in $Controls)
			{
				$CheckBox = New-Object -TypeName System.Windows.Controls.CheckBox
				$CheckBox.Tag = $control.Name

				$TextBlock = New-Object -TypeName System.Windows.Controls.TextBlock
				$TextBlock.Text = $control.DisplayName

				$StackPanel = New-Object -TypeName System.Windows.Controls.StackPanel
				[void]$StackPanel.Children.Add($CheckBox)
				[void]$StackPanel.Children.Add($TextBlock)
				[void]$PanelContainer.Children.Add($StackPanel)

				if ($UncheckedAppxPackages.Contains($control.Name))
				{
					$CheckBox.IsChecked = $false
				}
				else
				{
					$CheckBox.IsChecked = $true
				}
			}
		}
	}
	#endregion Functions

	Write-Verbose -Message $Localization.DialogBoxOpening -Verbose

	$Reader = (New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $XAML)
	$Form = [Windows.Markup.XamlReader]::Load($Reader)
	$XAML.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object -Process {
		Set-Variable -Name ($_.Name)-Value $Form.FindName($_.Name)
	}

	Get-AppxBundle | Add-FormControls
	$Window.Title = $Localization.UninstallUWPTitle
	$ButtonUninstall.Content = $Localization.Uninstall
	$ButtonUninstall.Add_Click({ButtonUninstallClick})
	$CheckBoxRemoveForAll.Add_Click({CheckBoxRemoveForAllClick})
	$TextBlockRemoveForAll.Text = $Localization.UninstallUWPForAll

	if ($PanelContainer.Children.Count -eq 0)
	{
		[void]$Form.Close()
		Write-Verbose -Message $Localization.NoData -Verbose
	}
	else
	{
		[void]$Form.ShowDialog()
	}
}

<#
	Open Microsoft Store "HEVC Video Extensions from Device Manufacturer" page to install this extension manually to be able to open .heic and .heif image formats
	The extension can be installed without Microsoft account

	Открыть страницу "Расширения для видео HEVC от производителя устройства" в Microsoft Store, чтобы вручную установить расширение и открывать изображения в форматах .heic и .heif
	Расширение может быть установлено бесплатно без учетной записи Microsoft
#>
function InstallHEIF
{
	Start-Process -FilePath ms-windows-store://pdp/?ProductId=9n4wgh0z6vhq
}

<#
	.SYNOPSIS
	Disable/enable Cortana autostarting
	Отключить/включить автозагрузку Кортана

	.PARAMETER Disable
	Enable Cortana autostarting
	Включить автозагрузку Кортана

	.PARAMETER Enable
	Disable Cortana autostarting
	Отключить автозагрузку Кортана

	.EXAMPLE
	CortanaAutostart -Disable

	.EXAMPLE
	CortanaAutostart -Enable
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

# Check for UWP apps updates
# Проверить обновления UWP-приложений
function CheckUWPAppsUpdates
{
	Write-Verbose -Message $Localization.Patient -Verbose
	Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod
}
#endregion UWP apps

#region Gaming
<#
	.SYNOPSIS
	Disable/enable Xbox Game Bar
	Отключить/включить Xbox Game Bar

	.PARAMETER Disable
	Disable Xbox Game Bar
	Отключить Xbox Game Bar

	.PARAMETER Enable
	Enable Xbox Game Bar
	Включить Xbox Game Bar

	.EXAMPLE
	XboxGameBar -Disable

	.EXAMPLE
	XboxGameBar -Enable
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
	Disable/enable Xbox Game Bar tips
	Отключить/включить советы Xbox Game Bar

	.PARAMETER Disable
	Disable Xbox Game Bar tips
	Отключить советы Xbox Game Bar

	.PARAMETER Enable
	Enable Xbox Game Bar tips
	Включить советы Xbox Game Bar

	.EXAMPLE
	XboxGameTips -Disable

	.EXAMPLE
	XboxGameTips -Enable
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
	Set "High performance" in graphics performance preference for an app
	Only with a dedicated GPU

	Установить параметры производительности графики для отдельных приложений на "Высокая производительность"
	Только при наличии внешней видеокарты
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
					$OpenFileDialog.InitialDirectory = "${env:ProgramFiles(x86)}"
					$OpenFileDialog.Multiselect = $false

					# Focus on open file dialog
					# Перевести фокус на диалог открытия файла
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
	Enable/disable hardware-accelerated GPU scheduling
	Включить/отключить планирование графического процессора с аппаратным ускорением

	.PARAMETER Disable
	Disable hardware-accelerated GPU scheduling
	Отключить планирование графического процессора с аппаратным ускорением

	.PARAMETER Enable
	Enable hardware-accelerated GPU scheduling
	Включить планирование графического процессора с аппаратным ускорением

	.EXAMPLE
	GPUScheduling -Disable

	.EXAMPLE
	GPUScheduling -Enable

	.NOTES
	Only with a dedicated GPU and WDDM verion is 2.7 or higher
	Restart needed

	Только при наличии внешней видеокарты и WDDM версии 2.7 и выше
	Необходима перезагрузка
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
				# Проверяем, не установлена ли ОС на виртуальной машине
				if ((Get-CimInstance -ClassName CIM_ComputerSystem).Model -notmatch "Virtual")
				{
					# Checking whether a WDDM verion is 2.7 or higher
					# Проверка: имеет ли WDDM версию 2.7 или выше
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
	Create/delete the "Windows Cleanup" task to clean up unused files and Windows updates in the Task Scheduler
	Создать/удалить задачу "Windows Cleanup" в Планировщике задач по очистке неиспользуемых файлов и обновлений Windows

	.PARAMETER Register
	Create the "Windows Cleanup" task to clean up unused files and Windows updates in the Task Scheduler
	Создать задачу "Windows Cleanup" в Планировщике задач по очистке неиспользуемых файлов и обновлений Windows

	.PARAMETER Delete
	Delete the "Windows Cleanup" task to clean up unused files and Windows updates from the Task Scheduler
	Удалить задачу "Windows Cleanup" из Планировщика задач по очистке неиспользуемых файлов и обновлений Windows

	.EXAMPLE
	CleanUpTask -Register

	.EXAMPLE
	CleanUpTask -Delete

	.NOTES
	A minute before the task starts, a warning in the Windows action center will appear
	The task runs every 90 days

	За минуту до выполнения задачи в Центре уведомлений Windows появится предупреждение
	Задача выполняется каждые 90 дней
#>
function CleanUpTask
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

			$TaskScript = @"
`$cleanmgr = """{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\cleanmgr.exe"""

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
`$Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText01)

`$ToastXML = [xml]`$Template.GetXml()
`$ToastXML.GetElementsByTagName("""text""").AppendChild(`$ToastXML.CreateTextNode("""$($Localization.CleanUpTaskToast)"""))

`$XML = New-Object -TypeName Windows.Data.Xml.Dom.XmlDocument
`$XML.LoadXml(`$ToastXML.OuterXml)
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier(`$cleanmgr).Show(`$XML)

Get-Process -Name cleanmgr | Stop-Process -Force

Start-Sleep -Seconds 60

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

			$Action = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Hidden -Command $TaskScript"
			$Trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 90 -At 9am
			$Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
			$Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
			$Description = $Localization.CleanUpTaskDescription
			$Parameters = @{
				"TaskName"		= "Windows Cleanup"
				"TaskPath"		= "Sophia Script"
				"Principal"		= $Principal
				"Action"		= $Action
				"Description"	= $Description
				"Settings"		= $Settings
				"Trigger"		= $Trigger
			}
			Register-ScheduledTask @Parameters -Force
		}
		"Delete"
		{
			Unregister-ScheduledTask -TaskName "Windows Cleanup" -Confirm:$false
		}
	}
}

<#
	.SYNOPSIS
	Create/delete the "SoftwareDistribution" task to clear the %SystemRoot%\SoftwareDistribution\Download folder in the Task Scheduler
	Создать/удалить задачу "SoftwareDistribution" в Планировщике задач по очистке папки %SystemRoot%\SoftwareDistribution\Download

	.PARAMETER Register
	Create the "SoftwareDistribution" task to clear the %SystemRoot%\SoftwareDistribution\Download folder in the Task Scheduler
	Создать задачу "SoftwareDistribution" в Планировщике задач по очистке папки %SystemRoot%\SoftwareDistribution\Download

	.PARAMETER Delete
	Delete the "SoftwareDistribution" task to clear the %SystemRoot%\SoftwareDistribution\Download folder from the Task Scheduler
	Удалить задачу "SoftwareDistribution" из Планировщика задач по очистке папки %SystemRoot%\SoftwareDistribution\Download

	.EXAMPLE
	SoftwareDistributionTask -Register

	.EXAMPLE
	SoftwareDistributionTask -Delete

	.NOTES
	The task runs on Thursdays every 4 weeks
	Задача выполняется по четвергам каждую 4 неделю
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
			$Argument = @"
(Get-Service -Name wuauserv).WaitForStatus('Stopped', '01:00:00')
Get-ChildItem -Path $env:SystemRoot\SoftwareDistribution\Download -Recurse -Force | Remove-Item -Recurse -Force
"@
			$Action = New-ScheduledTaskAction -Execute powershell.exe -Argument $Argument
			$Trigger = New-JobTrigger -Weekly -WeeksInterval 4 -DaysOfWeek Thursday -At 9am
			$Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
			$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -RunLevel Highest
			$Description = $Localization.FolderTaskDescription -f "$env:SystemRoot\SoftwareDistribution\Download"
			$Parameters = @{
				"TaskName"		= "SoftwareDistribution"
				"TaskPath"		= "Sophia Script"
				"Principal"		= $Principal
				"Action"		= $Action
				"Description"	= $Description
				"Settings"		= $Settings
				"Trigger"		= $Trigger
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
	Create the "Temp" task to clear the %TEMP% folder in the Task Scheduler
	Создать задачу "Temp" в Планировщике задач по очистке папки %TEMP%

	.PARAMETER Register
	Create the "Temp" to clear the %TEMP% folder in the Task Scheduler
	Создать задачу "Temp" в Планировщике задач по очистке папки %TEMP%

	.PARAMETER Delete
	Delete the "Temp" task to clear the %TEMP% folder from the Task Scheduler
	Удалить задачу "Temp" из Планировщика задач по очистке папки %TEMP%

	.EXAMPLE
	TempTask -Register

	.EXAMPLE
	TempTask -Delete

	.NOTES
	The task runs every 62 days
	Задача выполняется каждые 62 дня
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
			$Argument = "Get-ChildItem -Path $env:TEMP -Force -Recurse | Remove-Item -Recurse -Force"
			$Action = New-ScheduledTaskAction -Execute powershell.exe -Argument $Argument
			$Trigger = New-ScheduledTaskTrigger -Daily -DaysInterval 62 -At 9am
			$Settings = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
			$Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -RunLevel Highest
			$Description = $Localization.FolderTaskDescription
			$Parameters = @{
				"TaskName"		= "Temp"
				"TaskPath"		= "Sophia Script"
				"Principal"		= $Principal
				"Action"		= $Action
				"Description"	= $Description
				"Settings"		= $Settings
				"Trigger"		= $Trigger
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
# Включить контролируемый доступ к папкам и добавить защищенные папки
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
				# Перевести фокус на диалог открытия файла
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
# Удалить все добавленные защищенные папки
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
# Разрешить работу приложения через контролируемый доступ к папкам
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
				# Перевести фокус на диалог открытия файла
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
# Удалить все добавленные разрешенные приложение через контролируемый доступ к папкам
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
# Добавить папку в список исключений сканирования Microsoft Defender
function AddDefenderExclusionFolder
{
	$Title = $Localization.DefenderTitle
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
				# Перевести фокус на диалог открытия файла
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
# Удалить все папки из списка исключений сканирования Microsoft Defender
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
# Добавить файл в список исключений сканирования Microsoft Defender
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
				# Перевести фокус на диалог открытия файла
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
# Удалить все файлы из списка исключений сканирования Microsoft Defender
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
	Enable/disable Microsoft Defender Exploit Guard network protection
	Включить/отключить защиту сети в Microsoft Defender Exploit Guard

	.PARAMETER Disable
	Disable Microsoft Defender Exploit Guard network protection
	Отключить защиту сети в Microsoft Defender Exploit Guard

	.PARAMETER Enable
	Enable Microsoft Defender Exploit Guard network protection
	Включить защиту сети в Microsoft Defender Exploit Guard

	.EXAMPLE
	NetworkProtection -Disable

	.EXAMPLE
	NetworkProtection -Enable
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
	Enable/disable detection for potentially unwanted applications and block them
	Включить/отключить обнаружение потенциально нежелательных приложений и блокировать их

	.PARAMETER Disable
	Enable/disable detection for potentially unwanted applications and block them
	Включить/отключить обнаружение потенциально нежелательных приложений и блокировать их

	.PARAMETER Enable
	Enable/disable detection for potentially unwanted applications and block them
	Включить/отключить обнаружение потенциально нежелательных приложений и блокировать их

	.EXAMPLE
	PUAppsDetection -Disable

	.EXAMPLE
	PUAppsDetection -Enable
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
	Enable/disable sandboxing for Microsoft Defender
	Включить/отключить песочницу для Microsoft Defender

	.PARAMETER Disable
	Disable sandboxing for Microsoft Defender
	Отключить песочницу для Microsoft Defender

	.PARAMETER Enable
	Enable sandboxing for Microsoft Defender
	Включить песочницу для Microsoft Defender

	.EXAMPLE
	DefenderSandbox -Disable

	.EXAMPLE
	DefenderSandbox -Enable

	.NOTES
	There is a bug in KVM with QEMU: enabling this function causes VM to freeze up during the loading phase of Windows
	В KVM с QEMU присутсвует баг: включение этой функции приводит ВМ к зависанию во время загрузки Windows
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
# Отклонить предложение Microsoft Defender в "Безопасность Windows" о входе в аккаунт Microsoft
function DismissMSAccount
{
	New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows Security Health\State" -Name AccountProtection_MicrosoftAccount_Disconnected -PropertyType DWord -Value 1 -Force
}

# Dismiss Microsoft Defender offer in the Windows Security about turning on the SmartScreen filter for Microsoft Edge
# Отклонить предложение Microsoft Defender в "Безопасность Windows" включить фильтр SmartScreen для Microsoft Edge
function DismissSmartScreenFilter
{
	New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows Security Health\State" -Name AppAndBrowser_EdgeSmartScreenOff -PropertyType DWord -Value 0 -Force
}

<#
	.SYNOPSIS
	Enable/disable events auditing generated when a process is created or starts
	Включить/отключить аудит событий, возникающих при создании или запуске процесса

	.PARAMETER Disable
	Disable events auditing generated when a process is created or starts
	Отключить аудит событий, возникающих при создании или запуске процесса

	.PARAMETER Enable
	Enable events auditing generated when a process is created or starts
	Включить аудит событий, возникающих при создании или запуске процесса

	.EXAMPLE
	AuditProcess -Disable

	.EXAMPLE
	AuditProcess -Enable
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
	Include/do not include command line in process creation events
	Включать/не включать командную строку в событиях создания процесса

	.PARAMETER Disable
	Do not include command line in process creation events
	Не включать командную строку в событиях создания процесса

	.PARAMETER Enable
	Include command line in process creation events
	Включать командную строку в событиях создания процесса

	.EXAMPLE
	AuditCommandLineProcess -Disable

	.EXAMPLE
	AuditCommandLineProcess -Enable

	.NOTES
	In order this feature to work events auditing ("AuditProcess -Enable" function) will be enabled
	Для того, чтобы работал данный функционал, будет включен аудит событий (функция "AuditProcess -Enable")
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
			# Включить аудит событий, возникающих при создании или запуске процесса
			auditpol /set /subcategory:"{0CCE922B-69AE-11D9-BED3-505054503030}" /success:enable /failure:enable

			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit -Name ProcessCreationIncludeCmdLine_Enabled -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Create/remove "Process Creation" Event Viewer Custom View
	Создать/удалить настаиваемое представление "Создание процесса" в Просмотре событий

	.PARAMETER Disable
	Remove "Process Creation" Event Viewer Custom View
	Удалить настаиваемое представление "Создание процесса" в Просмотре событий

	.PARAMETER Enable
	Create "Process Creation" Event Viewer Custom View
	Создать настаиваемое представление "Создание процесса" в Просмотре событий

	.EXAMPLE
	EventViewerCustomView -Disable

	.EXAMPLE
	EventViewerCustomView -Enable

	.NOTES
	In order this feature to work events auditing ("AuditProcess -Enable" function) and command line in process creation events will be enabled
	Для того, чтобы работал данный функционал, буден включен аудит событий (функция "AuditProcess -Enable") и командной строки в событиях создания процесса
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
			# Включить аудит событий, возникающих при создании или запуске процесса
			auditpol /set /subcategory:"{0CCE922B-69AE-11D9-BED3-505054503030}" /success:enable /failure:enable

			# Include command line in process creation events
			# Включать командную строку в событиях создания процесса
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
			# Сохраняем ProcessCreation.xml в кодировке UTF-8
			Set-Content -Path "$env:ProgramData\Microsoft\Event Viewer\Views\ProcessCreation.xml" -Value $XML -Force
		}
	}
}

<#
	.SYNOPSIS
	Enable/disable logging for all Windows PowerShell modules
	Включить/отключить ведение журнала для всех модулей Windows PowerShell

	.PARAMETER Disable
	Disable logging for all Windows PowerShell modules
	Отключить ведение журнала для всех модулей Windows PowerShell

	.PARAMETER Enable
	Enable logging for all Windows PowerShell modules
	Включить ведение журнала для всех модулей Windows PowerShell

	.EXAMPLE
	PowerShellModulesLogging -Disable

	.EXAMPLE
	PowerShellModulesLogging -Enable
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
	Enable/disable logging for all PowerShell scripts input to the Windows PowerShell event log
	Включить/отключить ведение журнала для всех вводимых сценариев PowerShell в журнале событий Windows PowerShell

	.PARAMETER Disable
	Disable logging for all PowerShell scripts input to the Windows PowerShell event log
	Отключить ведение журнала для всех вводимых сценариев PowerShell в журнале событий Windows PowerShell

	.PARAMETER Enable
	Enable logging for all PowerShell scripts input to the Windows PowerShell event log
	Включить ведение журнала для всех вводимых сценариев PowerShell в журнале событий Windows PowerShell

	.EXAMPLE
	PowerShellScriptsLogging -Disable

	.EXAMPLE
	PowerShellScriptsLogging -Enable
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
	Disable/enable apps and files checking within Microsofot Defender SmartScreen
	Отключить/включить проверку приложений и файлов фильтром SmartScreen в Microsoft Defender

	.PARAMETER Disable
	Disable apps and files checking within Microsofot Defender SmartScreen
	Отключить проверку приложений и файлов фильтром SmartScreen в Microsoft Defender

	.PARAMETER Enable
	Enable apps and files checking within Microsofot Defender SmartScreen
	Включить проверку приложений и файлов фильтром SmartScreen в Microsoft Defender

	.EXAMPLE
	AppsSmartScreen -Disable

	.EXAMPLE
	AppsSmartScreen -Enable
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
	Disable/enable the Attachment Manager marking files that have been downloaded from the Internet as unsafe
	Отключить/включить проверку Диспетчером вложений файлов, скачанных из интернета как небезопасные

	.PARAMETER Disable
	Disable the Attachment Manager marking files that have been downloaded from the Internet as unsafe
	Отключить проверку Диспетчером вложений файлов, скачанных из интернета как небезопасные

	.PARAMETER Enable
	Enable the Attachment Manager marking files that have been downloaded from the Internet as unsafe
	Включить проверку Диспетчером вложений файлов, скачанных из интернета как небезопасные

	.EXAMPLE
	SaveZoneInformation -Disable

	.EXAMPLE
	SaveZoneInformation -Enable

	.NOTES
	Current user only
	Только для текущего пользователя
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
	Disable/enable Windows Script Host
	Отключить/включить Windows Script Host

	.PARAMETER Disable
	Disable Windows Script Host
	Отключить Windows Script Host

	.PARAMETER Enable
	Enable Windows Script Host
	Включить Windows Script Host

	.EXAMPLE
	WindowsScriptHost -Disable

	.EXAMPLE
	WindowsScriptHost -Enable

	.NOTES
	Current user only
	Blocks WSH from executing .js and .vbs files

	Только для текущего пользователя
	Блокирует запуск файлов .js и .vbs
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
	Disable/enable Windows Sandbox
	Отключить/включить Windows Sandbox

	.PARAMETER Disable
	Disable Windows Sandbox
	Отключить Windows Sandbox

	.PARAMETER Enable
	Enable Windows Sandbox
	Включить Windows Sandbox

	.EXAMPLE
	WindowsSandbox -Disable

	.EXAMPLE
	WindowsSandbox -Enable
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
				# Проверка: включена ли в настройках UEFI аппаратная виртуализация x86
				if ((Get-CimInstance -ClassName CIM_Processor).VirtualizationFirmwareEnabled -eq $true)
				{
					Disable-WindowsOptionalFeature -FeatureName Containers-DisposableClientVM -Online -NoRestart
				}
				else
				{
					try
					{
						# Determining whether Hyper-V is enabled
						# Проверка: включен ли Hyper-V
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
				# Проверка: включена ли в настройках UEFI аппаратная виртуализация x86
				if ((Get-CimInstance -ClassName CIM_Processor).VirtualizationFirmwareEnabled -eq $true)
				{
					Enable-WindowsOptionalFeature -FeatureName Containers-DisposableClientVM -All -Online -NoRestart
				}
				else
				{
					try
					{
						# Determining whether Hyper-V is enabled
						# Проверка: включен ли Hyper-V
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
	Add/remove the "Extract all" item to Windows Installer (.msi) context menu
	Добавить/удалить пункт "Извлечь все" в контекстное меню Windows Installer (.msi)

	.PARAMETER Remove
	Remove the "Extract all" item to Windows Installer (.msi) context menu
	Удалить пункт "Извлечь все" в контекстное меню Windows Installer (.msi)

	.PARAMETER Add
	Add the "Extract all" item to Windows Installer (.msi) context menu
	Добавить пункт "Извлечь все" в контекстное меню Windows Installer (.msi)

	.EXAMPLE
	MSIExtractContext -Remove

	.EXAMPLE
	MSIExtractContext -Add
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
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command -Name "(Default)" -PropertyType String -Value $Value -Force
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Name MUIVerb -PropertyType String -Value "@shell32.dll,-37514" -Force
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Name Icon -PropertyType String -Value "shell32.dll,-16817" -Force
		}
	}
}

<#
	.SYNOPSIS
	Add/remove the "Install" item to the .cab archives context menu
	Добавить/удалить пункт "Установить" в контекстное меню .cab архивов

	.PARAMETER Remove
	Remove the "Install" item to the .cab archives context menu
	Удалить пункт "Установить" в контекстное меню .cab архивов

	.PARAMETER Add
	Add the "Install" item to the .cab archives context menu
	Добавить пункт "Установить" в контекстное меню .cab архивов

	.EXAMPLE
	CABInstallContext -Remove

	.EXAMPLE
	CABInstallContext -Add
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
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs\Command -Name "(Default)" -PropertyType String -Value $Value -Force
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs -Name MUIVerb -PropertyType String -Value "@shell32.dll,-10210" -Force
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\RunAs -Name HasLUAShield -PropertyType String -Value "" -Force
		}
	}
}

<#
	.SYNOPSIS
	Add/remove the "Run as different user" item to the .exe files types context menu
	Добавить/удалить пункт "Запуск от имени другого пользователя" в контекстное меню .exe файлов

	.PARAMETER Remove
	Remove the "Run as different user" item to the .exe files types context menu
	Удалить пункт "Запуск от имени другого пользователя" в контекстное меню .exe файлов

	.PARAMETER Add
	Add the "Run as different user" item to the .exe files types context menu
	Добавить пункт "Запуск от имени другого пользователя" в контекстное меню .exe файлов

	.EXAMPLE
	RunAsDifferentUserContext -Remove

	.EXAMPLE
	RunAsDifferentUserContext -Add
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
	Hide/show the "Cast to Device" item from the context menu
	Отобразить/скрыть пункт "Передать на устройство" из контекстного меню

	.PARAMETER Hide
	Hide the "Cast to Device" item from the context menu
	Скрыть пункт "Передать на устройство" из контекстного меню

	.PARAMETER Show
	Show the "Cast to Device" item from the context menu
	Отобразить пункт "Передать на устройство" из контекстного меню

	.EXAMPLE
	CastToDeviceContext -Hide

	.EXAMPLE
	CastToDeviceContext -Show
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
	Hide/show the "Share" item from the context menu
	Отобразить/скрыть пункт "Отправить" (поделиться) из контекстного меню

	.PARAMETER Hide
	Hide the "Share" item from the context menu
	Скрыть пункт "Отправить" (поделиться) из контекстного меню

	.PARAMETER Show
	Show the "Share" item from the context menu
	Отобразить пункт "Отправить" (поделиться) из контекстного меню

	.EXAMPLE
	ShareContext -Hide

	.EXAMPLE
	ShareContext -Show
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
	Hide/show the "Edit with Paint 3D" item from the context menu
	Отобразить/скрыть пункт "Изменить с помощью Paint 3D" из контекстного меню

	.PARAMETER Hide
	Hide the "Edit with Paint 3D" item from the context menu
	Скрыть пункт "Изменить с помощью Paint 3D" из контекстного меню

	.PARAMETER Show
	Show the "Edit with Paint 3D" item from the context menu
	Отобразить пункт "Изменить с помощью Paint 3D" из контекстного меню

	.EXAMPLE
	EditWithPaint3DContext -Hide

	.EXAMPLE
	EditWithPaint3DContext -Show
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
	Hide/show the "Edit with Photos" item from the context menu
	Отобразить/скрыть пункт "Изменить с помощью приложения "Фотографии"" из контекстного меню

	.PARAMETER Hide
	Hide the "Edit with Photos" item from the context menu
	Скрыть пункт "Изменить с помощью приложения "Фотографии"" из контекстного меню

	.PARAMETER Show
	Show the "Edit with Photos" item from the context menu
	Отобразить пункт "Изменить с помощью приложения "Фотографии"" из контекстного меню

	.EXAMPLE
	EditWithPhotosContext -Hide

	.EXAMPLE
	EditWithPhotosContext -Show
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
	Hide/show the "Create a new video" item from the context menu
	Отобразить/скрыть пункт "Создать новое видео" из контекстного меню

	.PARAMETER Hide
	Hide the "Create a new video" item from the context menu
	Скрыть пункт "Создать новое видео" из контекстного меню

	.PARAMETER Show
	Show the "Create a new video" item from the context menu
	Отобразить пункт "Создать новое видео" из контекстного меню

	.EXAMPLE
	CreateANewVideoContext -Hide

	.EXAMPLE
	CreateANewVideoContext -Show
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
	Hide/show the "Edit" item from the images context menu
	Отобразить/скрыть пункт "Изменить" из контекстного меню изображений

	.PARAMETER Hide
	Hide the "Edit" item from the images context menu
	Скрыть пункт "Изменить" из контекстного меню изображений

	.PARAMETER Show
	Show the "Edit" item from the images context menu
	Отобразить пункт "Изменить" из контекстного меню изображений

	.EXAMPLE
	ImagesEditContext -Hide

	.EXAMPLE
	ImagesEditContext -Show
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
	Hide/show the "Print" item from the .bat and .cmd context menu
	Отобразить/скрыть пункт "Печать" из контекстного меню .bat и .cmd файлов

	.PARAMETER Hide
	Hide the "Print" item from the .bat and .cmd context menu
	Скрыть пункт "Печать" из контекстного меню .bat и .cmd файлов

	.PARAMETER Show
	Show the "Print" item from the .bat and .cmd context menu
	Отобразить пункт "Печать" из контекстного меню .bat и .cmd файлов

	.EXAMPLE
	PrintCMDContext -Hide

	.EXAMPLE
	PrintCMDContext -Show
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
	Hide/show the "Include in Library" item from the context menu
	Отобразить/скрыть пункт "Добавить в библиотеку" из контекстного меню

	.PARAMETER Hide
	Hide the "Include in Library" item from the context menu
	Скрыть пункт "Добавить в библиотеку" из контекстного меню

	.PARAMETER Show
	Show the "Include in Library" item from the context menu
	Отобразить пункт "Добавить в библиотеку" из контекстного меню

	.EXAMPLE
	IncludeInLibraryContext -Hide

	.EXAMPLE
	IncludeInLibraryContext -Show
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
			New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Folder\shellex\ContextMenuHandlers\Library Location" -Name "(Default)" -PropertyType String -Value "-{3dad6c5d-2167-4cae-9914-f99e41c12cfa}" -Force
		}
		"Show"
		{
			New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Folder\shellex\ContextMenuHandlers\Library Location" -Name "(Default)" -PropertyType String -Value "{3dad6c5d-2167-4cae-9914-f99e41c12cfa}" -Force
		}
	}
}

<#
	.SYNOPSIS
	Hide/show the "Send to" item from the folders context menu
	Отобразить/скрыть пункт "Отправить" из контекстного меню папок

	.PARAMETER Hide
	Hide the "Send to" item from the folders context menu
	Скрыть пункт "Отправить" из контекстного меню папок

	.PARAMETER Show
	Show the "Send to" item from the folders context menu
	Отобразить пункт "Отправить" из контекстного меню папок

	.EXAMPLE
	SendToContext -Hide

	.EXAMPLE
	SendToContext -Show
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
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo -Name "(Default)" -PropertyType String -Value "-{7BA4C740-9E81-11CF-99D3-00AA004AE837}" -Force
		}
		"Show"
		{
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AllFilesystemObjects\shellex\ContextMenuHandlers\SendTo -Name "(Default)" -PropertyType String -Value "{7BA4C740-9E81-11CF-99D3-00AA004AE837}" -Force
		}
	}
}

<#
	.SYNOPSIS
	Hide/show the "Turn on BitLocker" item from the context menu
	Отобразить/скрыть пункт "Включить BitLocker" из контекстного меню

	.PARAMETER Hide
	Hide the "Turn on BitLocker" item from the context menu
	Скрыть пункт "Включить BitLocker" из контекстного меню

	.PARAMETER Show
	Show the "Turn on BitLocker" item from the context menu
	Отобразить пункт "Включить BitLocker" из контекстного меню

	.EXAMPLE
	BitLockerContext -Hide

	.EXAMPLE
	BitLockerContext -Show
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
	Add/remove the "Bitmap image" item from the "New" context menu
	Добавить/удалить пункт "Точечный рисунок" из контекстного меню "Создать"

	.PARAMETER Remove
	Remove the "Bitmap image" item from the "New" context menu
	Удалить пункт "Точечный рисунок" из контекстного меню "Создать"

	.PARAMETER Add
	Add the "Bitmap image" item from the "New" context menu
	Добавить пункт "Точечный рисунок" из контекстного меню "Создать"

	.EXAMPLE
	BitmapImageNewContext -Remove

	.EXAMPLE
	BitmapImageNewContext -Add
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
	Add/remove the "Rich Text Document" item from the "New" context menu
	Добавить/удалить пункт "Документ в формате RTF" из контекстного меню "Создать"

	.PARAMETER Remove
	Remove the "Rich Text Document" item from the "New" context menu
	Удалить пункт "Документ в формате RTF" из контекстного меню "Создать"

	.PARAMETER Add
	Add the "Rich Text Document" item from the "New" context menu
	Добавить пункт "Документ в формате RTF" из контекстного меню "Создать"

	.EXAMPLE
	RichTextDocumentNewContext -Remove

	.EXAMPLE
	RichTextDocumentNewContext -Add
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
	Add/remove the "Compressed (zipped) Folder" item from the "New" context menu
	Добавить/удалить пункт "Сжатая ZIP-папка" из контекстного меню "Создать"

	.PARAMETER Remove
	Remove the "Compressed (zipped) Folder" item from the "New" context menu
	Удалить пункт "Сжатая ZIP-папка" из контекстного меню "Создать"

	.PARAMETER Add
	Add the "Compressed (zipped) Folder" item from the "New" context menu
	Добавить пункт "Сжатая ZIP-папка" из контекстного меню "Создать"

	.EXAMPLE
	CompressedFolderNewContext -Remove

	.EXAMPLE
	CompressedFolderNewContext -Add
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
	Enable/disable the "Open", "Print", and "Edit" context menu items for more than 15 items selected
	Включить/отключить элементы контекстного меню "Открыть", "Изменить" и "Печать" при выделении более 15 элементов

	.PARAMETER Enable
	Enable the "Open", "Print", and "Edit" context menu items for more than 15 items selected
	Включить элементы контекстного меню "Открыть", "Изменить" и "Печать" при выделении более 15 элементов

	.PARAMETER Disable
	Disable the "Open", "Print", and "Edit" context menu items for more than 15 items selected
	Отключить элементы контекстного меню "Открыть", "Изменить" и "Печать" при выделении более 15 элементов

	.EXAMPLE
	MultipleInvokeContext -Enable

	.EXAMPLE
	MultipleInvokeContext -Disable
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
	Hide/show the "Look for an app in the Microsoft Store" item in the "Open with" dialog
	Отобразить/скрыть пункт "Поиск приложения в Microsoft Store" в диалоге "Открыть с помощью"

	.PARAMETER Hide
	Hide the "Look for an app in the Microsoft Store" item in the "Open with" dialog
	Скрыть пункт "Поиск приложения в Microsoft Store" в диалоге "Открыть с помощью"

	.PARAMETER Show
	Show the "Look for an app in the Microsoft Store" item in the "Open with" dialog
	Отобразить пункт "Поиск приложения в Microsoft Store" в диалоге "Открыть с помощью"

	.EXAMPLE
	UseStoreOpenWith -Hide

	.EXAMPLE
	UseStoreOpenWith -Show
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
	Hide/show the "Previous Versions" tab from files and folders context menu and also the "Restore previous versions" context menu item
	Отобразить/скрыть вкладку "Предыдущие версии" в свойствах файлов и папок, а также пункт контекстного меню "Восстановить прежнюю версию"

	.PARAMETER Hide
	Hide the "Previous Versions" tab from files and folders context menu and also the "Restore previous versions" context menu item
	Скрыть вкладку "Предыдущие версии" в свойствах файлов и папок, а также пункт контекстного меню "Восстановить прежнюю версию"

	.PARAMETER Show
	Show the "Previous Versions" tab from files and folders context menu and also the "Restore previous versions" context menu item
	Отобразить вкладку "Предыдущие версии" в свойствах файлов и папок, а также пункт контекстного меню "Восстановить прежнюю версию"

	.EXAMPLE
	PreviousVersionsPage -Hide

	.EXAMPLE
	PreviousVersionsPage -Show
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
	// Обновить иконки рабочего стола
	SHChangeNotify(0x8000000, 0x1000, IntPtr.Zero, IntPtr.Zero);

	// Update environment variables
	// Обновить переменные среды
	SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, IntPtr.Zero, null, SMTO_ABORTIFHUNG, 100, IntPtr.Zero);

	// Update taskbar
	// Обновить панель задач
	SendNotifyMessage(HWND_BROADCAST, WM_SETTINGCHANGE, IntPtr.Zero, "TraySettings");
}

private static readonly IntPtr hWnd = new IntPtr(65535);
private const int Msg = 273;
// Virtual key ID of the F5 in File Explorer
// Виртуальный код клавиши F5 в проводнике
private static readonly UIntPtr UIntPtr = new UIntPtr(41504);

[DllImport("user32.dll", SetLastError=true)]
public static extern int PostMessageW(IntPtr hWnd, uint Msg, UIntPtr wParam, IntPtr lParam);
public static void PostMessage()
{
	// Simulate pressing F5 to refresh the desktop
	// Симулировать нажатие F5 для обновления рабочего стола
	PostMessageW(hWnd, Msg, UIntPtr, IntPtr.Zero);
}
"@
	}
	if (-not ("WinAPI.UpdateExplorer" -as [type]))
	{
		Add-Type @UpdateExplorer
	}

	# Simulate pressing F5 to refresh the desktop
	# Симулировать нажатие F5 для обновления рабочего стола
	[WinAPI.UpdateExplorer]::PostMessage()

	# Refresh desktop icons, environment variables, taskbar
	# Обновить иконки рабочего стола, переменные среды, панель задач
	[WinAPI.UpdateExplorer]::Refresh()

	# Restart the Start menu
	# Перезапустить меню "Пуск"
	Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction Ignore

	# Turn on Controlled folder access if it was turned on
	# Включить контролируемый доступ к папкам, если был включен
	if ($Script:ControlledFolderAccess)
	{
		Set-MpPreference -EnableControlledFolderAccess Enabled
	}

	Write-Warning -Message $Localization.RestartWarning
}
#endregion Refresh

# Errors output
# Вывод ошибок
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
