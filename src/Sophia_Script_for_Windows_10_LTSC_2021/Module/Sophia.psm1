<#
	.SYNOPSIS
	Sophia Script is a PowerShell module for Windows 10 & Windows 11 fine-tuning and automating the routine tasks

	Version: v5.16.4
	Date: 01.04.2023

	Copyright (c) 2014—2023 farag
	Copyright (c) 2019—2023 farag & Inestic

	Thanks to all https://forum.ru-board.com members involved

	.NOTES
	Supported Windows 10 version
	Version: 21H2
	Build: 19044.2728+
	Edition: Enterprise LTSC 2021
	Architecture: x64

	.LINK GitHub
	https://github.com/farag2/Sophia-Script-for-Windows

	.LINK Telegram
	https://t.me/sophianews
	https://t.me/sophia_chat

	.LINK Discord
	https://discord.gg/sSryhaEv79

	.NOTES
	https://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15
	https://habr.com/company/skillfactory/blog/553800/
	https://forums.mydigitallife.net/threads/powershell-windows-10-sophia-script.81675/
	https://www.reddit.com/r/PowerShell/comments/go2n5v/powershell_script_setup_windows_10/

	.LINK Authors
	https://github.com/farag2
	https://github.com/Inestic
#>

#region Checks
function Checks
{
	param
	(
		[Parameter(Mandatory = $false)]
		[switch]
		$Warning
	)

	Set-StrictMode -Version Latest

	# Сlear the $Error variable
	$Global:Error.Clear()

	# Unblock all files in the script folder by removing the Zone.Identifier alternate data stream with a value of "3"
	Get-ChildItem -Path $PSScriptRoot\..\ -File -Recurse -Force | Unblock-File

	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

	# Extract strings from %SystemRoot%\System32\shell32.dll using its' number
	$Signature = @{
		Namespace        = "WinAPI"
		Name             = "GetStr"
		Language         = "CSharp"
		UsingNamespace   = "System.Text"
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
		Add-Type @Signature
	}

	# Detect the OS bitness
	if (-not [System.Environment]::Is64BitOperatingSystem)
	{
		Write-Warning -Message $Localization.UnsupportedOSBitness

		Start-Process -FilePath "https://t.me/sophia_chat"
		Start-Process -FilePath "https://discord.gg/sSryhaEv79"

		exit
	}

	# Detect the OS build version
	switch (((Get-CimInstance -ClassName CIM_OperatingSystem).BuildNumber -eq 19044) -and ((Get-WindowsEdition -Online).Edition -match "EnterpriseS"))
	{
		$true
		{
			if ((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows nt\CurrentVersion" -Name UBR) -lt 2728)
			{
				# Check whether the OS minor build version is 2728 minimum
				# https://docs.microsoft.com/en-us/windows/release-health/release-information
				$Version = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows nt\CurrentVersion" -Name UBR
				Write-Warning -Message ($Localization.UpdateWarning -f $Version)

				Start-Process -FilePath "https://t.me/sophia_chat"
				Start-Process -FilePath "https://discord.gg/sSryhaEv79"
				Start-Process -FilePath "https://github.com/farag2/Sophia-Script-for-Windows#system-requirements"

				# Enable receiving updates for other Microsoft products when you update Windows
				(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "")

				Start-Sleep -Seconds 1

				# Open the "Windows Update" page
				Start-Process -FilePath "ms-settings:windowsupdate-action"

				Start-Sleep -Seconds 1

				# Trigger Windows Update for detecting new updates
				(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()

				exit
			}
		}
		$false
		{
			Write-Warning -Message $Localization.UnsupportedOSBuild

			Start-Process -FilePath "https://t.me/sophia_chat"
			Start-Process -FilePath "https://discord.gg/sSryhaEv79"
			Start-Process -FilePath "https://github.com/farag2/Sophia-Script-for-Windows#system-requirements"

			exit
		}
	}

	# Check the language mode
	if ($ExecutionContext.SessionState.LanguageMode -ne "FullLanguage")
	{
		Write-Warning -Message $Localization.UnsupportedLanguageMode

		Start-Process -FilePath "https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_language_modes"
		Start-Process -FilePath "https://t.me/sophia_chat"
		Start-Process -FilePath "https://discord.gg/sSryhaEv79"

		exit
	}

	# Check whether the logged-in user is an admin
	$CurrentUserName = (Get-Process -Id $PID -IncludeUserName).UserName | Split-Path -Leaf
	$CurrentSessionId = (Get-Process -Id $PID -IncludeUserName).SessionId
	$LoginUserName = (Get-Process -IncludeUserName | Where-Object -FilterScript {($_.ProcessName -eq "explorer") -and ($_.SessionId -eq $CurrentSessionId)}).UserName | Select-Object -First 1 | Split-Path -Leaf

	if ($CurrentUserName -ne $LoginUserName)
	{
		Write-Warning -Message $Localization.LoggedInUserNotAdmin

		Start-Process -FilePath "https://t.me/sophia_chat"
		Start-Process -FilePath "https://discord.gg/sSryhaEv79"

		exit
	}

	# Check whether the script was run via PowerShell 5.1
	if ($PSVersionTable.PSVersion.Major -ne 5)
	{
		Write-Warning -Message ($Localization.UnsupportedPowerShell -f $PSVersionTable.PSVersion.Major, $PSVersionTable.PSVersion.Minor)

		Start-Process -FilePath "https://t.me/sophia_chat"
		Start-Process -FilePath "https://discord.gg/sSryhaEv79"

		exit
	}

	# Check whether the script was run in PowerShell ISE or VS Code
	if (($Host.Name -match "ISE") -or ($env:TERM_PROGRAM -eq "vscode"))
	{
		Write-Warning -Message ($Localization.UnsupportedHost -f $Host.Name.replace("Host", ""))

		Start-Process -FilePath "https://t.me/sophia_chat"
		Start-Process -FilePath "https://discord.gg/sSryhaEv79"

		exit
	}

	# Check whether Windows was broken by 3rd party harmful tweakers and trojans
	$Tweakers = @{
		# https://github.com/Sycnex/Windows10Debloater
		Windows10Debloater  = "$env:SystemDrive\Temp\Windows10Debloater"
		# https://github.com/Fs00/Win10BloatRemover
		Win10BloatRemover   = "$env:TEMP\.net\Win10BloatRemover"
		# https://github.com/arcadesdude/BRU
		"Bloatware Removal" = "$env:SystemDrive\BRU\Bloatware-Removal*.log"
		# https://www.youtube.com/GHOSTSPECTRE
		"Ghost Toolbox"     = "$env:SystemRoot\System32\migwiz\dlmanifests\run.ghost.cmd"
		# https://github.com/hellzerg/optimizer
		Optimizer           = "$(Get-ItemPropertyValue -Path `"HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders`" -Name `"{374DE290-123F-4565-9164-39C4925E467B}`")\OptimizerDownloads"
		# https://win10tweaker.ru
		"Win 10 Tweaker"    = "HKCU:\Software\Win 10 Tweaker"
		# https://forum.ru-board.com/topic.cgi?forum=5&topic=50519
		"Modern Tweaker"    = "Registry::HKEY_CLASSES_ROOT\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\shell\Modern Cleaner"
		# https://boosterx.ru
		BoosterX            = "$env:ProgramFiles\GameModeX\GameModeX.exe"
		# https://forum.ru-board.com/topic.cgi?forum=5&topic=14285&start=400#11
		"Defender Control"  = "$env:APPDATA\Defender Control"
		# https://forum.ru-board.com/topic.cgi?forum=5&topic=14285&start=260#12
		"Defender Switch"   = "$env:ProgramData\DSW"
		# https://revi.cc/revios/download
		"Revision Tool"     = "${env:ProgramFiles(x86)}\Revision Tool"
		# https://www.youtube.com/watch?v=L0cj_I6OF2o
		"WinterOS Tweaker"  = "$env:SystemRoot\WinterOS*"
		# https://github.com/ThePCDuke/WinCry
		WinCry              = "$env:SystemRoot\TempCleaner.exe"
	}
	foreach ($Tweaker in $Tweakers.Keys)
	{
		if (Test-Path -Path $Tweakers[$Tweaker])
		{
			if ($Tweakers[$Tweaker] -eq "HKCU:\Software\Win 10 Tweaker")
			{
				Write-Warning -Message $Localization.Win10TweakerWarning

				Start-Process -FilePath "https://youtu.be/na93MS-1EkM"
				Start-Process -FilePath "https://pikabu.ru/story/byekdor_v_win_10_tweaker_ili_sovremennyie_metodyi_borbyi_s_piratstvom_8227558"
				Start-Process -FilePath "https://t.me/sophia_chat"
				Start-Process -FilePath "https://discord.gg/sSryhaEv79"

				exit
			}

			Write-Warning -Message ($Localization.TweakerWarning -f $Tweaker)

			Start-Process -FilePath "https://t.me/sophia_chat"
			Start-Process -FilePath "https://discord.gg/sSryhaEv79"

			exit
		}
	}

	# Flibustier custom Windows image
	if (Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\.NETFramework\Performance -Name *flibustier)
	{
		Write-Warning -Message ($Localization.TweakerWarning -f "flblauncher")

		Start-Process -FilePath "https://t.me/sophia_chat"
		Start-Process -FilePath "https://discord.gg/sSryhaEv79"

		exit
	}

	# Check whether LGPO.exe exists in the bin folder
	if (-not (Test-Path -Path "$PSScriptRoot\..\bin\LGPO.exe"))
	{
		Write-Warning -Message $Localization.Bin

		Start-Process -FilePath "https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"
		Start-Process -FilePath "https://t.me/sophia_chat"
		Start-Process -FilePath "https://discord.gg/sSryhaEv79"

		exit
	}

	# Check for a pending reboot
	$PendingActions = @(
		# CBS pending
		"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending",
		"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootInProgress",
		"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\PackagesPending",
		# Windows Update pending
		"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\PostRebootReporting",
		"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
	)
	if (($PendingActions | Test-Path) -contains $true)
	{
		Write-Warning -Message $Localization.RebootPending

		Start-Process -FilePath "https://t.me/sophia_chat"
		Start-Process -FilePath "https://discord.gg/sSryhaEv79"

		exit
	}

	# Check if the current module version is the latest one
	try
	{
		# Check the internet connection
		$Parameters = @{
			Uri              = "https://www.google.com"
			Method           = "Head"
			DisableKeepAlive = $true
			UseBasicParsing  = $true
		}
		if (-not (Invoke-WebRequest @Parameters).StatusDescription)
		{
			return
		}

		try
		{
			# https://github.com/farag2/Sophia-Script-for-Windows/blob/master/sophia_script_versions.json
			$Parameters = @{
				Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json"
				Verbose         = $true
				UseBasicParsing = $true
			}
			$LatestRelease = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_10_LTSC2021
			$CurrentRelease = (Get-Module -Name Sophia).Version.ToString()
			if ([System.Version]$LatestRelease -gt [System.Version]$CurrentRelease)
			{
				Write-Warning -Message $Localization.UnsupportedRelease

				Start-Process -FilePath "https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"
				Start-Process -FilePath "https://t.me/sophia_chat"
				Start-Process -FilePath "https://discord.gg/sSryhaEv79"

				exit
			}
		}
		catch [System.Net.WebException]
		{
			Write-Warning -Message ($Localization.NoResponse -f "https://github.com")
			Write-Error -Message ($Localization.NoResponse -f "https://github.com") -ErrorAction SilentlyContinue
		}
	}
	catch [System.Net.WebException]
	{
		Write-Warning -Message $Localization.NoInternetConnection
		Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue
	}

	#region Defender checks
	# Checking whether WMI is corrupted
	try
	{
		Get-CimInstance -ClassName MSFT_MpComputerStatus -Namespace root/Microsoft/Windows/Defender -ErrorAction Stop | Out-Null
	}
	catch [Microsoft.Management.Infrastructure.CimException]
	{
		# Provider Load Failure exception
		Write-Warning -Message $Global:Error.Exception.Message | Select-Object -First 1
		Write-Warning -Message $Localization.DefenderBroken -f "Microsoft Defender" ###

		Start-Process -FilePath "https://t.me/sophia_chat"
		Start-Process -FilePath "https://discord.gg/sSryhaEv79"

		exit
	}

	# Check Microsoft Defender state
	if ($null -eq (Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiVirusProduct -ErrorAction Ignore))
	{
		Write-Warning -Message $Localization.DefenderBroken -f "Microsoft Defender" ###

		Start-Process -FilePath "https://t.me/sophia_chat"
		Start-Process -FilePath "https://discord.gg/sSryhaEv79"

		exit
	}

	# Check Microsoft Defender state
	$productState = (Get-CimInstance -Namespace root/SecurityCenter2 -ClassName Antivirusproduct | Where-Object -FilterScript {$_.instanceGuid -eq "{D68DDC3A-831F-4fae-9E44-DA132C1ACF46}"}).productState
	$DefenderState = ('0x{0:x}' -f $productState).Substring(3, 2)
	if ($DefenderState -notmatch "00|01")
	{
		$Script:DefenderproductState = $true
	}
	else
	{
		$Script:DefenderproductState = $false
	}

	# Checking services ###
	try
	{
		$Services = Get-Service -Name Windefend, SecurityHealthService, wscsvc -ErrorAction Stop
	}
	catch [Microsoft.PowerShell.Commands.ServiceCommandException]
	{
		Write-Warning -Message $Localization.DefenderBroken -f "Microsoft Defender"

		Start-Process -FilePath "https://t.me/sophia_chat"
		Start-Process -FilePath "https://discord.gg/sSryhaEv79"

		exit
	}
	$Script:DefenderServices = ($Services | Where-Object -FilterScript {$_.Status -ne "running"} | Measure-Object).Count -lt $Services.Count

	# Specify whether Antispyware protection is enabled
	if ((Get-CimInstance -ClassName MSFT_MpComputerStatus -Namespace root/Microsoft/Windows/Defender).AntispywareEnabled)
	{
		$Script:DefenderAntispywareEnabled = $true
	}
	else
	{
		$Script:DefenderAntispywareEnabled = $false
	}

	# https://docs.microsoft.com/en-us/graph/api/resources/intune-devices-windowsdefenderproductstatus?view=graph-rest-beta
	try
	{
		if ($Script:DefenderproductState)
		{
			if ((Get-CimInstance -ClassName MSFT_MpComputerStatus -Namespace root/Microsoft/Windows/Defender).ProductStatus -eq 1)
			{
				$Script:DefenderProductStatus = $false
			}
			else
			{
				$Script:DefenderProductStatus = $true
			}
		}
		else
		{
			$Script:DefenderProductStatus = $false
		}
	}
	catch [System.Management.Automation.PropertyNotFoundException]
	{
		Write-Warning -Message $Localization.UpdateDefender

		Start-Process -FilePath "https://t.me/sophia_chat"
		Start-Process -FilePath "https://discord.gg/sSryhaEv79"

		# Enable receiving updates for other Microsoft products when you update Windows
		(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "")

		Start-Sleep -Seconds 1

		# Open the "Windows Update" page
		Start-Process -FilePath "ms-settings:windowsupdate"

		# Check for updates
		Start-Process -FilePath "ms-settings:windowsupdate-action"

		Start-Sleep -Seconds 1

		# Trigger Windows Update for detecting new updates
		(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()

		exit
	}

	# https://docs.microsoft.com/en-us/graph/api/resources/intune-devices-windowsdefenderproductstatus?view=graph-rest-beta
	if ((Get-CimInstance -ClassName MSFT_MpComputerStatus -Namespace root/Microsoft/Windows/Defender).AMEngineVersion -eq "0.0.0.0")
	{
		$Script:DefenderAMEngineVersion = $false
	}
	else
	{
		$Script:DefenderAMEngineVersion = $true
	}

	# Check whether Microsoft Defender was turned off
	# Due to "Set-StrictMode -Version Latest" we have to use try/catch & GetValue()
	try
	{
		if ([Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender", "DisableAntiSpyware", $false) -eq 1)
		{
			$Script:DisableAntiSpyware = $true
		}
		else
		{
			$Script:DisableAntiSpyware = $false
		}
	}
	catch {}

	# Check whether real-time protection prompts for known malware detection
	# Due to "Set-StrictMode -Version Latest" we have to use try/catch & GetValue()
	try
	{
		if ([Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection", "DisableRealtimeMonitoring", $false) -eq 1)
		{
			$Script:DisableRealtimeMonitoring = $true
		}
		else
		{
			$Script:DisableRealtimeMonitoring = $false
		}
	}
	catch {}

	# Check whether behavior monitoring was disabled
	# Due to "Set-StrictMode -Version Latest" we have to use try/catch & GetValue()
	try
	{
		if ([Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection", "DisableBehaviorMonitoring", $false) -eq 1)
		{
			$Script:DisableBehaviorMonitoring = $true
		}
		else
		{
			$Script:DisableBehaviorMonitoring = $false
		}
	}
	catch {}

	if ($Script:DefenderproductState -and $Script:DefenderServices -and $Script:DefenderAntispywareEnabled -and $Script:DefenderAMEngineVersion -and
	(-not $Script:DisableAntiSpyware) -and (-not $Script:DisableRealtimeMonitoring) -and (-not $Script:DisableBehaviorMonitoring))
	{
		# Defender is enabled
		$Script:DefenderEnabled = $true

		switch ((Get-MpPreference).EnableControlledFolderAccess)
		{
			"1"
			{
				Write-Warning -Message $Localization.ControlledFolderAccessDisabled

				# Turn off Controlled folder access to let the script proceed
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
	#endregion Defender checks

	# Enable back the SysMain service if it was disabled by harmful tweakers
	if ((Get-Service -Name SysMain).Status -eq "Stopped")
	{
		Get-Service -Name SysMain | Set-Service -StartupType Automatic
		Get-Service -Name SysMain | Start-Service

		Start-Process -FilePath "https://www.outsidethebox.ms/19318/"
	}

	# Automatically manage paging file size for all drives
	if (-not (Get-CimInstance -ClassName CIM_ComputerSystem).AutomaticManagedPageFile)
	{
		Get-CimInstance -ClassName CIM_ComputerSystem | Set-CimInstance -Property @{AutomaticManagedPageFile = $true}
	}

	# Remove firewalled IP addresses that block Microsoft recourses added by harmful tweakers
	# https://wpd.app
	Get-NetFirewallRule | Where-Object -FilterScript {($_.DisplayName -match "Blocker MicrosoftTelemetry") -or ($_.DisplayName -match "Blocker MicrosoftExtra") -or ($_.DisplayName -match "windowsSpyBlocker")} | Remove-NetFirewallRule

	Write-Information -MessageData "" -InformationAction Continue
	# Extract the localized "Please wait..." string from shell32.dll
	Write-Verbose -Message ([WinAPI.GetStr]::GetString(12612)) -Verbose

	# Remove IP addresses from hosts file that block Microsoft recourses added by WindowsSpyBlocker
	# https://github.com/crazy-max/WindowsSpyBlocker
	try
	{
		# Check the internet connection
		$Parameters = @{
			Uri              = "https://www.google.com"
			Method           = "Head"
			DisableKeepAlive = $true
			UseBasicParsing  = $true
		}
		if (-not (Invoke-WebRequest @Parameters).StatusDescription)
		{
			return
		}

		try
		{
			# Check whether https://github.com is alive
			$Parameters = @{
				Uri              = "https://github.com"
				Method           = "Head"
				DisableKeepAlive = $true
				UseBasicParsing  = $true
			}
			if (-not (Invoke-WebRequest @Parameters).StatusDescription)
			{
				return
			}

			Clear-Variable -Name Array -ErrorAction Ignore

			# https://github.com/crazy-max/WindowsSpyBlocker/tree/master/data/hosts
			$Parameters = @{
				Uri              = "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/extra.txt"
				UseBasicParsing  = $true
				Verbose          = $true
			}
			$extra = (Invoke-WebRequest @Parameters).Content

			$Parameters = @{
				Uri              = "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/extra_v6.txt"
				UseBasicParsing  = $true
				Verbose          = $true
			}
			$extra_v6 = (Invoke-WebRequest @Parameters).Content

			$Parameters = @{
				Uri              = "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
				UseBasicParsing  = $true
				Verbose          = $true
			}
			$spy = (Invoke-WebRequest @Parameters).Content

			$Parameters = @{
				Uri              = "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy_v6.txt"
				UseBasicParsing  = $true
				Verbose          = $true
			}
			$spy_v6 = (Invoke-WebRequest @Parameters).Content

			$Parameters = @{
				Uri              = "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/update.txt"
				UseBasicParsing  = $true
				Verbose          = $true
			}
			$update =(Invoke-WebRequest @Parameters).Content

			$Parameters = @{
				Uri              = "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/update_v6.txt"
				UseBasicParsing  = $true
				Verbose          = $true
			}
			$update_v6 = (Invoke-WebRequest @Parameters).Content

			$IPArray += $extra, $extra_v6, $spy, $spy_v6, $update, $update_v6
			# Split the Array variable content
			$IPArray = $IPArray -split "`r?`n" | Where-Object -FilterScript {$_ -notmatch "#"}

			# Clear hosts file
			$hosts = Get-Content -Path "$env:SystemRoot\System32\drivers\etc\hosts" -Encoding Default -Force
			$hosts | ForEach-Object -Process {
				if (($_ -ne "") -and (-not $_.StartsWith("#")) -and ($IPArray -split "`r?`n" | Select-String -Pattern $_))
				{
					$UiData = $_
					$hosts = $hosts | Where-Object -FilterScript {$_ -notmatch $UiData}
				}
			}
			$hosts | Set-Content -Path "$env:SystemRoot\System32\drivers\etc\hosts" -Encoding Default -Force
		}
		catch [System.Net.WebException]
		{
			Write-Warning -Message ($Localization.NoResponse -f "https://github.com")
			Write-Error -Message ($Localization.NoResponse -f "https://github.com") -ErrorAction SilentlyContinue

			Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue
		}
	}
	catch [System.Net.WebException]
	{
		Write-Warning -Message $Localization.NoInternetConnection
		Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue

		Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue
	}


	# PowerShell 5.1 (7.3 too) interprets 8.3 file name literally, if an environment variable contains a non-latin word
	Get-ChildItem -Path "$env:TEMP\Computer.txt", "$env:TEMP\User.txt" -Force -ErrorAction Ignore | Remove-Item -Recurse -Force -ErrorAction Ignore

	# Save all opened folders in order to restore them after File Explorer restart
	$Script:OpenedFolders = {(New-Object -ComObject Shell.Application).Windows() | ForEach-Object -Process {$_.Document.Folder.Self.Path}}.Invoke()

	# Display a warning message about whether a user has customized the preset file
	if ($Warning)
	{
		# Get the name of a preset (e.g Sophia.ps1) regardless it was named
		$PresetName = Split-Path -Path ((Get-PSCallStack).Position | Where-Object -FilterScript {$_.File -match ".ps1"}).File -Leaf

		$Title = ""
		$Message       = $Localization.CustomizationWarning -f $PresetName
		# Extract the localized "&Yes" string from shell32.dll
		$Yes           = [WinAPI.GetStr]::GetString(33224)
		# Extract the localized "&No" string from shell32.dll
		$No            = [WinAPI.GetStr]::GetString(33232)
		$Options       = $No, $Yes
		$DefaultChoice = 0
		$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

		switch ($Result)
		{
			"0"
			{
				Invoke-Item -Path $PSScriptRoot\..\$PresetName

				Start-Sleep -Seconds 5

				Start-Process -FilePath "https://github.com/farag2/Sophia-Script-for-Windows#how-to-use"
				Start-Process -FilePath "https://t.me/sophia_chat"
				Start-Process -FilePath "https://discord.gg/sSryhaEv79"

				exit
			}
			"1"
			{
				continue
			}
		}
	}
}
#endregion Checks

#region Protection
# Enable script logging. The log will be being recorded into the script root folder
# To stop logging just close the console or type "Stop-Transcript"
function Logging
{
	$TranscriptFilename = "Log-$((Get-Date).ToString("dd.MM.yyyy-HH-mm"))"
	Start-Transcript -Path $PSScriptRoot\..\$TranscriptFilename.txt -Force
}

# Create a restore point for the system drive
function CreateRestorePoint
{
	$SystemDriveUniqueID = (Get-Volume | Where-Object -FilterScript {$_.DriveLetter -eq "$($env:SystemDrive[0])"}).UniqueID
	$SystemProtection = ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SPP\Clients" -ErrorAction Ignore)."{09F7EDC5-294E-4180-AF6A-FB0E6A0E9513}") | Where-Object -FilterScript {$_ -match [regex]::Escape($SystemDriveUniqueID)}

	$Script:ComputerRestorePoint = $false

	if ($null -eq $SystemProtection)
	{
		$ComputerRestorePoint = $true
		Enable-ComputerRestore -Drive $env:SystemDrive
	}

	# Never skip creating a restore point
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name SystemRestorePointCreationFrequency -PropertyType DWord -Value 0 -Force

	Checkpoint-Computer -Description "Sophia Script for Windows 10" -RestorePointType MODIFY_SETTINGS

	# Revert the System Restore checkpoint creation frequency to 1440 minutes
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name SystemRestorePointCreationFrequency -PropertyType DWord -Value 1440 -Force

	# Turn off System Protection for the system drive if it was turned off before without deleting the existing restore points
	if ($Script:ComputerRestorePoint)
	{
		Disable-ComputerRestore -Drive $env:SystemDrive
	}
}
#endregion Protection

#region Set GPO
<#
	.SYNOPSIS
	Create pre-configured text files for LGPO.exe tool

	.EXAMPLE
	Set-Policy -Scope Computer -Path SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name AllowTelemetry -Type DWORD -Value 0

	.NOTES
	https://techcommunity.microsoft.com/t5/microsoft-security-baselines/lgpo-exe-local-group-policy-object-utility-v1-0/ba-p/701045

	.NOTES
	Machine-wide user
#>
function script:Set-Policy
{
	[CmdletBinding()]
	param
	(
		[Parameter(
			Mandatory = $true,
			Position = 1
		)]
		[string]
		[ValidateSet("Computer", "User")]
		$Scope,

		[Parameter(
			Mandatory = $true,
			Position = 2
		)]
		[string]
		$Path,

		[Parameter(
			Mandatory = $true,
			Position = 3
		)]
		[string]
		$Name,

		[Parameter(
			Mandatory = $true,
			Position = 4
		)]
		[ValidateSet("DWORD", "SZ", "EXSZ", "CLEAR")]
		[string]
		$Type,

		[Parameter(
			Mandatory = $false,
			Position = 5
		)]
		$Value
	)

	if (-not (Test-Path -Path "$env:SystemRoot\System32\gpedit.msc"))
	{
		return
	}

	switch ($Type)
	{
		"CLEAR"
		{
			$Policy = @"
$Scope
$($Path)
$($Name)
$($Type)`n
"@
		}
		default
		{
			$Policy = @"
$Scope
$($Path)
$($Name)
$($Type):$($Value)`n
"@
		}
	}

	if ($Scope -eq "Computer")
	{
		$Path = "$env:TEMP\Computer.txt"
	}
	else
	{
		$Path = "$env:TEMP\User.txt"
	}

	Add-Content -Path $Path -Value $Policy -Encoding Default -Force
}
#endregion Set GPO

#region Privacy & Telemetry
<#
	.SYNOPSIS
	The Connected User Experiences and Telemetry (DiagTrack) service

	.PARAMETER Disable
	Disable the Connected User Experiences and Telemetry (DiagTrack) service, and block connection for the Unified Telemetry Client Outbound Traffic

	.PARAMETER Enable
	Enable the Connected User Experiences and Telemetry (DiagTrack) service, and allow connection for the Unified Telemetry Client Outbound Traffic

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

	# Revert back removed or commented out "Checks" functions
	# Get the name of a preset (e.g Sophia.ps1) regardless it was named
	$PresetName = ((Get-PSCallStack).Position | Where-Object -FilterScript {$_.File -match ".ps1"}).File
	if (Select-String -Path $PresetName -Pattern Checks | Select-String -Pattern "{Checks}", "The mandatory checks" -NotMatch)
	{
		# The string exists and is commented
		if ((Select-String -Path $PresetName -Pattern Checks | Select-String -Pattern "{Checks}", "The mandatory checks" -NotMatch).Line.StartsWith("#") -eq $true)
		{
			$Host.UI.RawUI.WindowTitle = "Checks | $($PresetName)"

			$ReadFile = Get-Content -Path $PresetName -Encoding UTF8
			# Calculate the string number to uncomment "Checks -Warning"
			$LineNumber = (Select-String -Path $PresetName -Pattern Checks | Select-String -Pattern "{Checks}", "The mandatory checks" -NotMatch).LineNumber
			# Get date from the required line to replace it with "Checks -Warning"
			$RequiredLine = (Get-Content -Path $PresetName -Encoding UTF8) | Where-Object -FilterScript {$_.ReadCount -eq $LineNumber}
			(Get-Content -Path $PresetName -Encoding UTF8).Replace($RequiredLine, "Checks -Warning") | Set-Content -Path $PresetName -Encoding UTF8 -Force

			Start-Process -FilePath "https://t.me/sophia_chat"
			Start-Process -FilePath "https://discord.gg/sSryhaEv79"

			exit
		}
	}
	else
	{
		$Host.UI.RawUI.WindowTitle = "Checks | $($PresetName)"

		$ReadFile = Get-Content -Path $PresetName -Encoding UTF8
		# Calculate the string number to add after "Checks -Warning"
		$LineNumber = (Select-String -Path $PresetName -Pattern Import-LocalizedData).LineNumber
		# Array of a new file: content before $LineNumber (including $LineNumber), new added string, the rest data of file
		$UpdatedFile = @($ReadFile[0..($LineNumber - 1)], "`nChecks -Warning", $ReadFile[$LineNumber..($ReadFile.Length + 1)])
		Set-Content -Path $PresetName -Value $UpdatedFile -Encoding UTF8 -Force

		Start-Process -FilePath "https://t.me/sophia_chat"
		Start-Process -FilePath "https://discord.gg/sSryhaEv79"

		exit
	}

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			# Connected User Experiences and Telemetry
			Get-Service -Name DiagTrack | Stop-Service -Force
			Get-Service -Name DiagTrack | Set-Service -StartupType Disabled

			# Block connection for the Unified Telemetry Client Outbound Traffic
			Get-NetFirewallRule -Group DiagTrack | Set-NetFirewallRule -Enabled False -Action Block
		}
		"Enable"
		{
			# Connected User Experiences and Telemetry
			Get-Service -Name DiagTrack | Set-Service -StartupType Automatic
			Get-Service -Name DiagTrack | Start-Service

			# Allow connection for the Unified Telemetry Client Outbound Traffic
			Get-NetFirewallRule -Group DiagTrack | Set-NetFirewallRule -Enabled True -Action Allow
		}
	}
}

<#
	.SYNOPSIS
	Diagnostic data

	.PARAMETER Minimal
	Set the diagnostic data collection to minimum

	.PARAMETER Default
	Set the diagnostic data collection to default

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
			# Security level
			if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection))
			{
				New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Force
			}
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack -Force
			}
			New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 0 -Force
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name MaxTelemetryAllowed -PropertyType DWord -Value 1 -Force
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack -Name ShowedToastAtLevel -PropertyType DWord -Value 1 -Force
		}
		"Default"
		{
			# Optional diagnostic data
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name AllowTelemetry -Force -ErrorAction Ignore
			Set-Policy -Scope Computer -Path SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name AllowTelemetry -Type CLEAR

			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack -Force
			}
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name MaxTelemetryAllowed -PropertyType DWord -Value 3 -Force
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack -Name ShowedToastAtLevel -PropertyType DWord -Value 3 -Force
		}
	}
}

<#
	.SYNOPSIS
	Windows Error Reporting

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
				New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Windows Error Reporting" -Name Disabled -PropertyType DWord -Value 1 -Force
			}

			Get-Service -Name WerSvc | Stop-Service -Force
			Get-Service -Name WerSvc | Set-Service -StartupType Disabled
		}
		"Enable"
		{
			Get-ScheduledTask -TaskName QueueReporting | Enable-ScheduledTask
			Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Windows Error Reporting" -Name Disabled -Force -ErrorAction Ignore

			Get-Service -Name WerSvc | Set-Service -StartupType Manual
			Get-Service -Name WerSvc | Start-Service
		}
	}
}

<#
	.SYNOPSIS
	The feedback frequency

	.PARAMETER Never
	Change the feedback frequency to "Never"

	.PARAMETER Automatically
	Change feedback frequency to "Automatically"

	.EXAMPLE
	FeedbackFrequency -Never

	.EXAMPLE
	FeedbackFrequency -Automatically

	.NOTES
	Current user
#>
function FeedbackFrequency
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Never"
		)]
		[switch]
		$Never,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Automatically"
		)]
		[switch]
		$Automatically
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Never"
		{
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Siuf\Rules))
			{
				New-Item -Path HKCU:\Software\Microsoft\Siuf\Rules -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Siuf\Rules -Name NumberOfSIUFInPeriod -PropertyType DWord -Value 0 -Force
		}
		"Automatically"
		{
			Remove-Item -Path HKCU:\Software\Microsoft\Siuf\Rules -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	The diagnostics tracking scheduled tasks

	.PARAMETER Disable
	Turn off the diagnostics tracking scheduled tasks

	.PARAMETER Enable
	Turn on the diagnostics tracking scheduled tasks

	.EXAMPLE
	ScheduledTasks -Disable

	.EXAMPLE
	ScheduledTasks -Enable

	.NOTES
	A pop-up dialog box lets a user select tasks

	.NOTES
	Current user
#>
function ScheduledTasks
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

	Add-Type -AssemblyName PresentationCore, PresentationFramework

	#region Variables
	# Initialize an array list to store the selected scheduled tasks
	$SelectedTasks = New-Object -TypeName System.Collections.ArrayList($null)

	# The following tasks will have their checkboxes checked
	[string[]]$CheckedScheduledTasks = @(
		# Collects program telemetry information if opted-in to the Microsoft Customer Experience Improvement Program
		"ProgramDataUpdater",

		# This task collects and uploads autochk SQM data if opted-in to the Microsoft Customer Experience Improvement Program
		"Proxy",

		# If the user has consented to participate in the Windows Customer Experience Improvement Program, this job collects and sends usage data to Microsoft
		"Consolidator",

		# The USB CEIP (Customer Experience Improvement Program) task collects Universal Serial Bus related statistics and information about your machine and sends it to the Windows Device Connectivity engineering group at Microsoft
		"UsbCeip",

		# The Windows Disk Diagnostic reports general disk and system information to Microsoft for users participating in the Customer Experience Program
		"Microsoft-Windows-DiskDiagnosticDataCollector",

		# This task shows various Map related toasts
		"MapsToastTask",

		# This task checks for updates to maps which you have downloaded for offline use
		"MapsUpdateTask",

		# Initializes Family Safety monitoring and enforcement
		"FamilySafetyMonitor",

		# Synchronizes the latest settings with the Microsoft family features service
		"FamilySafetyRefreshTask",

		# XblGameSave Standby Task
		"XblGameSaveTask"
	)

	# Check if device has a camera
	$DeviceHasCamera = Get-CimInstance -ClassName Win32_PnPEntity | Where-Object -FilterScript {(($_.PNPClass -eq "Camera") -or ($_.PNPClass -eq "Image")) -and ($_.Service -ne "StillCam")}
	if (-not $DeviceHasCamera)
	{
		# Windows Hello
		$CheckedScheduledTasks += "FODCleanupTask"
	}
	#endregion Variables

	#region XAML Markup
	# The section defines the design of the upcoming dialog box
	[xml]$XAML = @"
	<Window
		xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Name="Window"
		MinHeight="450" MinWidth="400"
		SizeToContent="WidthAndHeight" WindowStartupLocation="CenterScreen"
		TextOptions.TextFormattingMode="Display" SnapsToDevicePixels="True"
		FontFamily="Candara" FontSize="16" ShowInTaskbar="True"
		Background="#F1F1F1" Foreground="#262626">
		<Window.Resources>
			<Style TargetType="StackPanel">
				<Setter Property="Orientation" Value="Horizontal"/>
				<Setter Property="VerticalAlignment" Value="Top"/>
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
			<ScrollViewer Name="Scroll" Grid.Row="0"
				HorizontalScrollBarVisibility="Disabled"
				VerticalScrollBarVisibility="Auto">
				<StackPanel Name="PanelContainer" Orientation="Vertical"/>
			</ScrollViewer>
			<Button Name="Button" Grid.Row="2"/>
		</Grid>
	</Window>
"@
	#endregion XAML Markup

	$Form = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $XAML))
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
		Write-Information -MessageData "" -InformationAction Continue
		# Extract the localized "Please wait..." string from shell32.dll
		Write-Verbose -Message ([WinAPI.GetStr]::GetString(12612)) -Verbose

		[void]$Window.Close()

		$SelectedTasks | ForEach-Object -Process {Write-Verbose $_.TaskName -Verbose}
		$SelectedTasks | Disable-ScheduledTask
	}

	function EnableButton
	{
		Write-Information -MessageData "" -InformationAction Continue
		# Extract the localized "Please wait..." string from shell32.dll
		Write-Verbose -Message ([WinAPI.GetStr]::GetString(12612)) -Verbose

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
			$State           = "Disabled"
			# Extract the localized "Enable" string from shell32.dll
			$ButtonContent   = [WinAPI.GetStr]::GetString(51472)
			$ButtonAdd_Click = {EnableButton}
		}
		"Disable"
		{
			$State           = "Ready"
			$ButtonContent   = $Localization.Disable
			$ButtonAdd_Click = {DisableButton}
		}
	}

	Write-Information -MessageData "" -InformationAction Continue
	# Extract the localized "Please wait..." string from shell32.dll
	Write-Verbose -Message ([WinAPI.GetStr]::GetString(12612)) -Verbose

	# Getting list of all scheduled tasks according to the conditions
	$Tasks = Get-ScheduledTask | Where-Object -FilterScript {($_.State -eq $State) -and ($_.TaskName -in $CheckedScheduledTasks)}

	if (-not ($Tasks))
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Verbose -Message $Localization.NoData -Verbose

		return
	}

	Write-Information -MessageData "" -InformationAction Continue
	Write-Verbose -Message $Localization.DialogBoxOpening -Verbose

	#region Sendkey function
	# Emulate the Backspace key sending to prevent the console window to freeze
	Start-Sleep -Milliseconds 500

	Add-Type -AssemblyName System.Windows.Forms

	$Signature = @{
		Namespace        = "WinAPI"
		Name             = "ForegroundWindow"
		Language         = "CSharp"
		MemberDefinition = @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

[DllImport("user32.dll")]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool SetForegroundWindow(IntPtr hWnd);
"@
	}

	if (-not ("WinAPI.ForegroundWindow" -as [type]))
	{
		Add-Type @Signature
	}

	Get-Process | Where-Object -FilterScript {($_.ProcessName -eq "powershell") -and ($_.MainWindowTitle -match "Sophia Script for Windows 10 LTSC")} | ForEach-Object -Process {
		# Show window, if minimized
		[WinAPI.ForegroundWindow]::ShowWindowAsync($_.MainWindowHandle, 10)

		Start-Sleep -Seconds 1

		# Force move the console window to the foreground
		[WinAPI.ForegroundWindow]::SetForegroundWindow($_.MainWindowHandle)

		Start-Sleep -Seconds 1

		# Emulate the Backspace key sending
		[System.Windows.Forms.SendKeys]::SendWait("{BACKSPACE 1}")
	}
	#endregion Sendkey function

	$Window.Add_Loaded({$Tasks | Add-TaskControl})
	$Button.Content = $ButtonContent
	$Button.Add_Click({& $ButtonAdd_Click})

	$Window.Title = $Localization.ScheduledTasks

	# Force move the WPF form to the foreground
	$Window.Add_Loaded({$Window.Activate()})
	$Form.ShowDialog() | Out-Null
}

<#
	.SYNOPSIS
	The sign-in info to automatically finish setting up device and reopen apps after an update or restart

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
			Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$SID" -Name OptOut -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	The provision to websites a locally relevant content by accessing my language list

	.PARAMETER Disable
	Do not let websites provide locally relevant content by accessing my language list

	.PARAMETER Enable
	Let websites provide locally relevant content by accessing language my list

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
			Remove-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name HttpAcceptLanguageOptOut -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	The permission for apps to use advertising ID

	.PARAMETER Disable
	Do not allow apps to use advertising ID to make ads more interresting to you based on your app usage

	.PARAMETER Enable
	Let apps use advertising ID to make ads more interresting to you based on your app usage

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
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -PropertyType DWord -Value 0 -Force
		}
		"Enable"
		{
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Ways I can finish setting up my device to get the most out of Windows

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
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Name ScoobeSystemSettingEnabled -PropertyType DWord -Value 0 -Force
		}
		"Enable"
		{
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\UserProfileEngagement -Name ScoobeSystemSettingEnabled -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Tailored experiences

	.PARAMETER Disable
	Do not let Microsoft offer you tailored experiences based on the diagnostic data setting you have chosen

	.PARAMETER Enable
	Let Microsoft offer you tailored experiences based on the diagnostic data setting you have chosen

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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy -Name TailoredExperiencesWithDiagnosticDataEnabled -PropertyType DWord -Value 0 -Force
		}
		"Enable"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy -Name TailoredExperiencesWithDiagnosticDataEnabled -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Bing search in the Start Menu

	.PARAMETER Disable
	Disable Bing search in the Start Menu

	.PARAMETER Enable
	Enable Bing search in the Start Menu

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
			if (-not (Test-Path -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer))
			{
				New-Item -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Force
			}
			New-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Name DisableSearchBoxSuggestions -PropertyType DWord -Value 1 -Force
			Set-Policy -Scope User -Path Software\Policies\Microsoft\Windows\Explorer -Name DisableSearchBoxSuggestions -Type DWORD -Value 1
		}
		"Enable"
		{
			Remove-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Name DisableSearchBoxSuggestions -Force -ErrorAction Ignore
			Set-Policy -Scope User -Path Software\Policies\Microsoft\Windows\Explorer -Name DisableSearchBoxSuggestions -Type CLEAR
		}
	}
}
#endregion Privacy & Telemetry

#region UI & Personalization
<#
	.SYNOPSIS
	The "This PC" icon on Desktop

	.PARAMETER Show
	Show the "This PC" icon on Desktop

	.PARAMETER Hide
	Hide the "This PC" icon on Desktop

	.EXAMPLE
	ThisPC -Show

	.EXAMPLE
	ThisPC -Hide

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
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -PropertyType DWord -Value 0 -Force
		}
		"Hide"
		{
			Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	Item check boxes

	.PARAMETER Disable
	Do not use item check boxes

	.PARAMETER Enable
	Use check item check boxes

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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name AutoCheckSelect -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name AutoCheckSelect -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Hidden files, folders, and drives

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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -PropertyType DWord -Value 2 -Force
		}
	}
}

<#
	.SYNOPSIS
	File name extensions

	.PARAMETER Show
	Show the file name extensions

	.PARAMETER Hide
	Hide the file name extensions

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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -PropertyType DWord -Value 0 -Force
		}
		"Hide"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Folder merge conflicts

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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideMergeConflicts -PropertyType DWord -Value 0 -Force
		}
		"Hide"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideMergeConflicts -PropertyType DWord -Value 1 -Force
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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -PropertyType DWord -Value 1 -Force
		}
		"QuickAccess"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -PropertyType DWord -Value 2 -Force
		}
	}
}

<#
	.SYNOPSIS
	Sync provider notification in File Explorer

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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSyncProviderNotifications -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSyncProviderNotifications -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Windows snapping

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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SnapAssist -PropertyType DWord -Value 0 -Force
		}
		"Enable"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SnapAssist -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	The file transfer dialog box mode

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
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Name EnthusiastMode -PropertyType DWord -Value 1 -Force
		}
		"Compact"
		{
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager -Name EnthusiastMode -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	The File Explorer ribbon

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
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Name MinimizedStateTabletModeOff -PropertyType DWord -Value 0 -Force
		}
		"Minimized"
		{
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Name MinimizedStateTabletModeOff -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	The recycle bin files delete confirmation dialog

	.PARAMETER Enable
	Display the recycle bin files delete confirmation dialog

	.PARAMETER Disable
	Do not display the recycle bin files delete confirmation dialog

	.EXAMPLE
	RecycleBinDeleteConfirmation -Enable

	.EXAMPLE
	RecycleBinDeleteConfirmation -Disable

	.NOTES
	Current user
#>
function RecycleBinDeleteConfirmation
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

	$ShellState = Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShellState

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			$ShellState[4] = 51
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShellState -PropertyType Binary -Value $ShellState -Force
		}
		"Disable"
		{
			$ShellState[4] = 55
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShellState -PropertyType Binary -Value $ShellState -Force
		}
	}
}

<#
	.SYNOPSIS
	The "3D Objects" folder in "This PC" and Quick access

	.PARAMETER Hide
	Hide the "3D Objects" folder in "This PC" and Quick access

	.PARAMETER Show
	Show the "3D Objects" folder in "This PC" and Quick access

	.EXAMPLE
	3DObjects -Hide

	.EXAMPLE
	3DObjects -Show

	.NOTES
	Current user
#>
function 3DObjects
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
			if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag"))
			{
				New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Force
			}
			New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name ThisPCPolicy -PropertyType String -Value Hide -Force
		}
		"Show"
		{
			Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name ThisPCPolicy -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	Recently used files in Quick access

	.PARAMETER Hide
	Hide recently used files in Quick access

	.PARAMETER Show
	Show recently used files in Quick access

	.EXAMPLE
	QuickAccessRecentFiles -Hide

	.EXAMPLE
	QuickAccessRecentFiles -Show

	.NOTES
	Current user
#>
function QuickAccessRecentFiles
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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Frequently used folders in Quick access

	.PARAMETER Hide
	Hide frequently used folders in Quick access

	.PARAMETER Show
	Show frequently used folders in Quick access

	.EXAMPLE
	QuickAccessFrequentFolders -Hide

	.EXAMPLE
	QuickAccessFrequentFolders -Show

	.NOTES
	Current user
#>
function QuickAccessFrequentFolders
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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Task view button on the taskbar

	.PARAMETER Hide
	Hide the Task View button on the taskbar

	.PARAMETER Show
	Show the Task View button on the taskbar

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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowTaskViewButton -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	People on the taskbar

	.PARAMETER Hide
	Hide People on the taskbar

	.PARAMETER Show
	Show People on the taskbar

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
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Name PeopleBand -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People -Name PeopleBand -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Seconds on the taskbar clock

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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSecondsInSystemClock -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name ShowSecondsInSystemClock -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Search on the taskbar

	.PARAMETER Hide
	Hide the search on the taskbar

	.PARAMETER SearchIcon
	Show the search icon on the taskbar

	.PARAMETER SearchBox
	Show the search box on the taskbar

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
			ParameterSetName = "SearchIcon"
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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -PropertyType DWord -Value 0 -Force
		}
		"SearchIcon"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -PropertyType DWord -Value 1 -Force
		}
		"SearchBox"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Search -Name SearchboxTaskbarMode -PropertyType DWord -Value 2 -Force
		}
	}
}

<#
	.SYNOPSIS
	The Windows Ink Workspace button on the taskbar

	.PARAMETER Hide
	Hide the Windows Ink Workspace button on the taskbar

	.PARAMETER Show
	Show the Windows Ink Workspace button on the taskbar

	.EXAMPLE
	WindowsInkWorkspace -Hide

	.EXAMPLE
	WindowsInkWorkspace -Show

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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\PenWorkspace -Name PenWorkspaceButtonDesiredVisibility -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\PenWorkspace -Name PenWorkspaceButtonDesiredVisibility -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Icons in the notification area

	.PARAMETER Show
	Always show all icons in the notification area

	.PARAMETER Hide
	Hide all icons in the notification area

	.EXAMPLE
	NotificationAreaIcons -Show

	.EXAMPLE
	NotificationAreaIcons -Hide

	.NOTES
	Current user
#>
function NotificationAreaIcons
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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray -PropertyType DWord -Value 0 -Force
		}
		"Hide"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	The Control Panel icons view

	.PARAMETER Category
	View the Control Panel icons by category

	.PARAMETER LargeIcons
	View the Control Panel icons by large icons

	.PARAMETER SmallIcons
	View the Control Panel icons by Small icons

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
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name AllItemsIconView -PropertyType DWord -Value 0 -Force
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name StartupPage -PropertyType DWord -Value 0 -Force
		}
		"LargeIcons"
		{
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name AllItemsIconView -PropertyType DWord -Value 0 -Force
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name StartupPage -PropertyType DWord -Value 1 -Force
		}
		"SmallIcons"
		{
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name AllItemsIconView -PropertyType DWord -Value 1 -Force
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel -Name StartupPage -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	The default Windows mode

	.PARAMETER Dark
	Set the default Windows mode to dark

	.PARAMETER Light
	Set the default Windows mode to light

	.EXAMPLE
	WindowsColorScheme -Dark

	.EXAMPLE
	WindowsColorScheme -Light

	.NOTES
	Current user
#>
function WindowsColorMode
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Dark"
		)]
		[switch]
		$Dark,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Light"
		)]
		[switch]
		$Light
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Dark"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -PropertyType DWord -Value 0 -Force
		}
		"Light"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	The default app mode

	.PARAMETER Dark
	Set the default app mode to dark

	.PARAMETER Light
	Set the default app mode to light

	.EXAMPLE
	AppColorMode -Dark

	.EXAMPLE
	AppColorMode -Light

	.NOTES
	Current user
#>
function AppColorMode
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Dark"
		)]
		[switch]
		$Dark,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Light"
		)]
		[switch]
		$Light
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Dark"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -PropertyType DWord -Value 0 -Force
		}
		"Light"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	The "New App Installed" indicator

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
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name NoNewAppAlert -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	First sign-in animation after the upgrade

	.PARAMETER Disable
	Disable first sign-in animation after the upgrade

	.PARAMETER Enable
	Enable first sign-in animation after the upgrade

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
			New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name EnableFirstLogonAnimation -PropertyType DWord -Value 0 -Force
		}
		"Enable"
		{
			New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name EnableFirstLogonAnimation -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	The quality factor of the JPEG desktop wallpapers

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
			Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name JPEGImportQuality -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	The Task Manager mode

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
		$Preferences = Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences
	}
	until ($Preferences)

	Stop-Process -Name Taskmgr -ErrorAction Ignore

	switch ($PSCmdlet.ParameterSetName)
	{
		"Expanded"
		{
			$Preferences[28] = 0
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences -PropertyType Binary -Value $Preferences -Force
		}
		"Compact"
		{
			$Preferences[28] = 1
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\TaskManager -Name Preferences -PropertyType Binary -Value $Preferences -Force
		}
	}
}

<#
	.SYNOPSIS
	Notification when your PC requires a restart to finish updating

	.PARAMETER Show
	Show a notification when your PC requires a restart to finish updating

	.PARAMETER Hide
	Hide a notification when your PC requires a restart to finish updating

	.EXAMPLE
	RestartNotification -Show

	.EXAMPLE
	RestartNotification -Hide

	.NOTES
	Machine-wide
#>
function RestartNotification
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
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name RestartNotificationsAllowed2 -PropertyType DWord -Value 1 -Force
		}
		"Hide"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name RestartNotificationsAllowed2 -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	The "- Shortcut" suffix adding to the name of the created shortcuts

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
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates -Name ShortcutNameTemplate -PropertyType String -Value "%s.lnk" -Force
		}
		"Enable"
		{
			Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates -Name ShortcutNameTemplate -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	The Print screen button usage

	.PARAMETER Enable
	Use the Print screen button to open screen snipping

	.PARAMETER Disable
	Do not use the Print screen button to open screen snipping

	.EXAMPLE
	PrtScnSnippingTool -Enable

	.EXAMPLE
	PrtScnSnippingTool -Disable

	.NOTES
	Current user
#>
function PrtScnSnippingTool
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
			New-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name PrintScreenKeyForSnippingEnabled -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path "HKCU:\Control Panel\Keyboard" -Name PrintScreenKeyForSnippingEnabled -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	A different input method for each app window

	.PARAMETER Enable
	Let me use a different input method for each app window

	.PARAMETER Disable
	Do not use a different input method for each app window

	.EXAMPLE
	AppsLanguageSwitch -Enable

	.EXAMPLE
	AppsLanguageSwitch -Disable

	.NOTES
	Current user
#>
function AppsLanguageSwitch
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
			Set-WinLanguageBarOption -UseLegacySwitchMode
		}
		"Disable"
		{
			Set-WinLanguageBarOption
		}
	}
}

<#
	.SYNOPSIS
	Title bar window shake

	.PARAMETER Enable
	When I grab a windows's title bar and shake it, minimize all other windows

	.PARAMETER Disable
	When I grab a windows's title bar and shake it, don't minimize all other windows

	.EXAMPLE
	AeroShaking -Enable

	.EXAMPLE
	AeroShaking -Disable

	.NOTES
	Current user
#>
function AeroShaking
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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name DisallowShaking -PropertyType DWord -Value 0 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name DisallowShaking -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Free "Windows 11 Cursors Concept v2" cursors from Jepri Creations

	.PARAMETER Dark
	Download and install free dark "Windows 11 Cursors Concept v2" cursors from Jepri Creations

	.PARAMETER Light
	Download and install free light "Windows 11 Cursors Concept v2" cursors from Jepri Creations

	.PARAMETER Default
	Set default cursors

	.EXAMPLE
	Cursors -Dark

	.EXAMPLE
	Cursors -Light

	.EXAMPLE
	Cursors -Default

	.LINK
	https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356

	.NOTES
	The 09/09/22 version

	.NOTES
	Current user
#>
function Cursors
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Dark"
		)]
		[switch]
		$Dark,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Light"
		)]
		[switch]
		$Light,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Default"
		)]
		[switch]
		$Default
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Dark"
		{
			try
			{
				# Check the internet connection
				$Parameters = @{
					Uri              = "https://www.google.com"
					Method           = "Head"
					DisableKeepAlive = $true
					UseBasicParsing  = $true
				}
				if (-not (Invoke-WebRequest @Parameters).StatusDescription)
				{
					return
				}

				try
				{
					# Check whether https://github.com is alive
					$Parameters = @{
						Uri              = "https://github.com"
						Method           = "Head"
						DisableKeepAlive = $true
						UseBasicParsing  = $true
					}
					if (-not (Invoke-WebRequest @Parameters).StatusDescription)
					{
						return
					}

					$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
					$Parameters = @{
						Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/raw/master/Misc/Cursors.zip"
						OutFile         = "$DownloadsFolder\Cursors.zip"
						UseBasicParsing = $true
						Verbose         = $true
					}
					Invoke-WebRequest @Parameters

					if (-not (Test-Path -Path "$env:SystemRoot\Cursors\W11_dark_v2.2"))
					{
						New-Item -Path "$env:SystemRoot\Cursors\W11_dark_v2.2" -ItemType Directory -Force
					}

					Add-Type -Assembly System.IO.Compression.FileSystem
					$ZIP = [IO.Compression.ZipFile]::OpenRead("$DownloadsFolder\Cursors.zip")
					$ZIP.Entries | Where-Object -FilterScript {$_.FullName -like "dark/*.*"} | ForEach-Object -Process {
						[IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$env:SystemRoot\Cursors\W11_dark_v2.2\$($_.Name)", $true)
					}
					$ZIP.Dispose()

					Remove-Item -Path "$DownloadsFolder\Cursors.zip" -Force

					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name "(default)" -PropertyType String -Value "W11 Cursors Dark HD v2.2 by Jepri Creations" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name AppStarting -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\working.ani" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Arrow -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\pointer.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name ContactVisualization -PropertyType DWord -Value 1 -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Crosshair -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\precision.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name CursorBaseSize -PropertyType DWord -Value 32 -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name GestureVisualization -PropertyType DWord -Value 31 -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Hand -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\link.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Help -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\help.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name IBeam -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\beam.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name No -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\unavailable.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name NWPen -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\handwriting.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Person -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\person.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Pin -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\pin.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name precisionhair -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\precision.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name "Scheme Source" -PropertyType DWord -Value 1 -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeAll -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\move.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeNESW -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\dgn2.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeNS -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\vert.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeNWSE -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\dgn1.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeWE -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\horz.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name UpArrow -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\alternate.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Wait -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\busy.ani" -Force
					if (-not (Test-Path -Path "HKCU:\Control Panel\Cursors\Schemes"))
					{
						New-Item -Path "HKCU:\Control Panel\Cursors\Schemes" -Force
					}
					[string[]]$Schemes = (
						"%SystemRoot%\Cursors\W11_dark_v2.2\working.ani",
						"%SystemRoot%\Cursors\W11_dark_v2.2\pointer.cur",
						"%SystemRoot%\Cursors\W11_dark_v2.2\precision.cur",
						"%SystemRoot%\Cursors\W11_dark_v2.2\link.cur",
						"%SystemRoot%\Cursors\W11_dark_v2.2\help.cur",
						"%SystemRoot%\Cursors\W11_dark_v2.2\beam.cur",
						"%SystemRoot%\Cursors\W11_dark_v2.2\unavailable.cur",
						"%SystemRoot%\Cursors\W11_dark_v2.2\handwriting.cur",
						"%SystemRoot%\Cursors\W11_dark_v2.2\pin.cur",
						"%SystemRoot%\Cursors\W11_dark_v2.2\person.cur",
						"%SystemRoot%\Cursors\W11_dark_v2.2\move.cur",
						"%SystemRoot%\Cursors\W11_dark_v2.2\dgn2.cur",
						"%SystemRoot%\Cursors\W11_dark_v2.2\vert.cur",
						"%SystemRoot%\Cursors\W11_dark_v2.2\dgn1.cur",
						"%SystemRoot%\Cursors\W11_dark_v2.2\horz.cur",
						"%SystemRoot%\Cursors\W11_dark_v2.2\alternate.cur",
						"%SystemRoot%\Cursors\W11_dark_v2.2\busy.ani"
					) -join ","
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors\Schemes" -Name "W11 Cursors Dark HD v2.2 by Jepri Creations" -PropertyType String -Value $Schemes -Force
				}
				catch [System.Net.WebException]
				{
					Write-Warning -Message ($Localization.NoResponse -f "https://github.com")
					Write-Error -Message ($Localization.NoResponse -f "https://github.com") -ErrorAction SilentlyContinue

					Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue
				}
			}
			catch [System.Net.WebException]
			{
				Write-Warning -Message $Localization.NoInternetConnection
				Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue

				Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue
			}
		}
		"Light"
		{
			try
			{
				# Check the internet connection
				$Parameters = @{
					Uri              = "https://www.google.com"
					Method           = "Head"
					DisableKeepAlive = $true
					UseBasicParsing  = $true
				}
				if (-not (Invoke-WebRequest @Parameters).StatusDescription)
				{
					return
				}

				try
				{
					# Check whether https://github.com is alive
					$Parameters = @{
						Uri              = "https://github.com"
						Method           = "Head"
						DisableKeepAlive = $true
						UseBasicParsing  = $true
					}
					if (-not (Invoke-WebRequest @Parameters).StatusDescription)
					{
						return
					}

					$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
					$Parameters = @{
						Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/raw/master/Misc/Cursors.zip"
						OutFile         = "$DownloadsFolder\Cursors.zip"
						UseBasicParsing = $true
						Verbose         = $true
					}
					Invoke-WebRequest @Parameters

					if (-not (Test-Path -Path "$env:SystemRoot\Cursors\W11_light_v2.2"))
					{
						New-Item -Path "$env:SystemRoot\Cursors\W11_light_v2.2" -ItemType Directory -Force
					}

					Add-Type -Assembly System.IO.Compression.FileSystem
					$ZIP = [IO.Compression.ZipFile]::OpenRead("$DownloadsFolder\Cursors.zip")
					$ZIP.Entries | Where-Object -FilterScript {$_.FullName -like "light/*.*"} | ForEach-Object -Process {
						[IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$env:SystemRoot\Cursors\W11_light_v2.2\$($_.Name)", $true)
					}
					$ZIP.Dispose()

					Remove-Item -Path "$DownloadsFolder\Cursors.zip" -Force

					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name "(default)" -PropertyType String -Value "W11 Cursor Light HD v2.2 by Jepri Creations" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name AppStarting -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_light_v2.2\working.ani" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Arrow -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_light_v2.2\pointer.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name ContactVisualization -PropertyType DWord -Value 1 -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Crosshair -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_light_v2.2\precision.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name CursorBaseSize -PropertyType DWord -Value 32 -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name GestureVisualization -PropertyType DWord -Value 31 -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Hand -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_light_v2.2\link.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Help -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_light_v2.2\help.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name IBeam -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_light_v2.2\beam.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name No -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_light_v2.2\unavailable.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name NWPen -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_light_v2.2\handwriting.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Person -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_light_v2.2\person.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Pin -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_light_v2.2\pin.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name precisionhair -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_light_v2.2\precision.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name "Scheme Source" -PropertyType DWord -Value 1 -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeAll -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_light_v2.2\move.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeNESW -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_light_v2.2\dgn2.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeNS -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_light_v2.2\vert.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeNWSE -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_light_v2.2\dgn1.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeWE -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_light_v2.2\horz.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name UpArrow -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_light_v2.2\alternate.cur" -Force
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Wait -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_light_v2.2\busy.ani" -Force
					if (-not (Test-Path -Path "HKCU:\Control Panel\Cursors\Schemes"))
					{
						New-Item -Path "HKCU:\Control Panel\Cursors\Schemes" -Force
					}
					[string[]]$Schemes = (
						"%SystemRoot%\Cursors\W11_light_v2.2\working.ani",
						"%SystemRoot%\Cursors\W11_light_v2.2\pointer.cur",
						"%SystemRoot%\Cursors\W11_light_v2.2\precision.cur",
						"%SystemRoot%\Cursors\W11_light_v2.2\link.cur",
						"%SystemRoot%\Cursors\W11_light_v2.2\help.cur",
						"%SystemRoot%\Cursors\W11_light_v2.2\beam.cur",
						"%SystemRoot%\Cursors\W11_light_v2.2\unavailable.cur",
						"%SystemRoot%\Cursors\W11_light_v2.2\handwriting.cur",
						"%SystemRoot%\Cursors\W11_light_v2.2\pin.cur",
						"%SystemRoot%\Cursors\W11_light_v2.2\person.cur",
						"%SystemRoot%\Cursors\W11_light_v2.2\move.cur",
						"%SystemRoot%\Cursors\W11_light_v2.2\dgn2.cur",
						"%SystemRoot%\Cursors\W11_light_v2.2\vert.cur",
						"%SystemRoot%\Cursors\W11_light_v2.2\dgn1.cur",
						"%SystemRoot%\Cursors\W11_light_v2.2\horz.cur",
						"%SystemRoot%\Cursors\W11_light_v2.2\alternate.cur",
						"%SystemRoot%\Cursors\W11_light_v2.2\busy.ani"
					) -join ","
					New-ItemProperty -Path "HKCU:\Control Panel\Cursors\Schemes" -Name "W11 Cursor Light HD v2.2 by Jepri Creations" -PropertyType String -Value $Schemes -Force
				}
				catch [System.Net.WebException]
				{
					Write-Warning -Message ($Localization.NoResponse -f "https://github.com")
					Write-Error -Message ($Localization.NoResponse -f "https://github.com") -ErrorAction SilentlyContinue

					Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue
				}
			}
			catch [System.Net.WebException]
			{
				Write-Warning -Message $Localization.NoInternetConnection
				Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue

				Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue
			}
		}
		"Default"
		{
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name "(default)" -PropertyType String -Value "W11 Cursors Dark HD v2.2 by Jepri Creations" -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name AppStarting -PropertyType ExpandString -Value "%SystemRoot%\cursors\aero_working.ani" -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Arrow -PropertyType ExpandString -Value "%SystemRoot%\cursors\aero_arrow.cur" -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name ContactVisualization -PropertyType DWord -Value 1 -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Crosshair -PropertyType ExpandString -Value "" -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name CursorBaseSize -PropertyType DWord -Value 32 -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name GestureVisualization -PropertyType DWord -Value 31 -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Hand -PropertyType ExpandString -Value "%SystemRoot%\cursors\aero_link.cur" -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Help -PropertyType ExpandString -Value "%SystemRoot%\cursors\aero_helpsel.cur" -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name IBeam -PropertyType ExpandString -Value "" -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name No -PropertyType ExpandString -Value "%SystemRoot%\cursors\aero_unavail.cur" -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name NWPen -PropertyType ExpandString -Value "%SystemRoot%\cursors\aero_pen.cur" -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Person -PropertyType ExpandString -Value "%SystemRoot%\cursors\aero_person.cur" -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Pin -PropertyType ExpandString -Value "%SystemRoot%\cursors\aero_pin.cur" -Force
			Remove-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name precisionhair -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name "Scheme Source" -PropertyType DWord -Value 2 -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeAll -PropertyType ExpandString -Value "%SystemRoot%\cursors\aero_move.cur" -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeNESW -PropertyType ExpandString -Value "%SystemRoot%\cursors\aero_nesw.cur" -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeNS -PropertyType ExpandString -Value "%SystemRoot%\cursors\aero_ns.cur" -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeNWSE -PropertyType ExpandString -Value "%SystemRoot%\cursors\aero_nwse.cur" -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name SizeWE -PropertyType ExpandString -Value "%SystemRoot%\cursors\aero_ew.cur" -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name UpArrow -PropertyType ExpandString -Value "%SystemRoot%\Cursors\W11_dark_v2.2\alternate.cur" -Force
			New-ItemProperty -Path "HKCU:\Control Panel\Cursors" -Name Wait -PropertyType ExpandString -Value "%SystemRoot%\cursors\aero_up.cur" -Force
		}
	}

	# Reload cursor on-the-fly
	$Signature = @{
		Namespace        = "WinAPI"
		Name             = "Cursor"
		Language         = "CSharp"
		MemberDefinition = @"
[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, uint pvParam, uint fWinIni);
"@
	}
	if (-not ("WinAPI.Cursor" -as [type]))
	{
		Add-Type @Signature
	}
	[WinAPI.Cursor]::SystemParametersInfo(0x0057, 0, $null, 0)
}

<#
	.SYNOPSIS
	Files and folders grouping in the Downloads folder

	.PARAMETER None
	Do not group files and folder in the Downloads folder

	.PARAMETER Default
	Group files and folder by date modified in the Downloads folder (default value)

	.EXAMPLE
	FolderGroupBy -None

	.EXAMPLE
	FolderGroupBy -Default

	.NOTES
	Current user
#>
function FolderGroupBy
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "None"
		)]
		[switch]
		$None,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Default"
		)]
		[switch]
		$Default
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"None"
		{
			# Clear any Common Dialog views
			Get-ChildItem -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\*\Shell" -Recurse | Where-Object -FilterScript {$_.PSChildName -eq "{885A186E-A440-4ADA-812B-DB871B942259}"} | Remove-Item -Force

			# https://learn.microsoft.com/en-us/windows/win32/properties/props-system-null
			if (-not (Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}"))
			{
				New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}" -Force
			}
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}" -Name ColumnList -PropertyType String -Value "System.Null" -Force
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}" -Name GroupBy -PropertyType String -Value "System.Null" -Force
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}" -Name LogicalViewMode -PropertyType DWord -Value 1 -Force
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}" -Name Name -PropertyType String -Value NoName -Force
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}" -Name Order -PropertyType DWord -Value 0 -Force
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}" -Name PrimaryProperty -PropertyType String -Value "System.ItemNameDisplay" -Force
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}\TopViews\{00000000-0000-0000-0000-000000000000}" -Name SortByList -PropertyType String -Value "prop:System.ItemNameDisplay" -Force
		}
		"Default"
		{
			Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes\{885a186e-a440-4ada-812b-db871b942259}" -Recurse -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	Expand to current folder in navigation pane

	.PARAMETER Disable
	Do not expand to open folder on navigation pane (default value)

	.PARAMETER Enable
	Expand to open folder on navigation pane

	.EXAMPLE
	NavigationPaneExpand -Disable

	.EXAMPLE
	NavigationPaneExpand -Enable

	.NOTES
	Current user
#>
function NavigationPaneExpand
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
			Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -Force -ErrorAction Ignore
		}
		"Enable"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name NavPaneExpandToCurrentFolder -PropertyType DWord -Value 1 -Force
		}
	}
}
#endregion UI & Personalization

#region System
#region StorageSense
<#
	.SYNOPSIS
	Storage Sense

	.PARAMETER Enable
	Turn on Storage Sense

	.PARAMETER Disable
	Turn off Storage Sense

	.EXAMPLE
	StorageSense -Enable

	.EXAMPLE
	StorageSense -Disable

	.NOTES
	Current user
#>
function StorageSense
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
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -ItemType Directory -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01 -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -ItemType Directory -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01 -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Clean up of temporary files

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
			if ((Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01) -eq "1")
			{
				New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 04 -PropertyType DWord -Value 1 -Force
			}
		}
		"Disable"
		{
			if ((Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01) -eq "1")
			{
				New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 04 -PropertyType DWord -Value 0 -Force
			}
		}
	}
}

<#
	.SYNOPSIS
	Storage Sense running frequency

	.PARAMETER Month
	Run Storage Sense every month

	.PARAMETER Default
	Run Storage Sense during low free disk space

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
			if ((Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01) -eq "1")
			{
				New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 2048 -PropertyType DWord -Value 30 -Force
			}
		}
		"Default"
		{
			if ((Get-ItemPropertyValue -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 01) -eq "1")
			{
				New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy -Name 2048 -PropertyType DWord -Value 0 -Force
			}
		}
	}
}

#endregion StorageSense

<#
	.SYNOPSIS
	Hibernation

	.PARAMETER Disable
	Disable hibernation

	.PARAMETER Enable
	Enable hibernation

	.EXAMPLE
	Hibernation -Enable

	.EXAMPLE
	Hibernation -Disable

	.NOTES
	Do not recommend turning it off on laptops

	.NOTES
	Current user
#>
function Hibernation
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
			POWERCFG /HIBERNATE OFF
		}
		"Enable"
		{
			POWERCFG /HIBERNATE ON
		}
	}
}

<#
	.SYNOPSIS
	The %TEMP% environment variable path

	.PARAMETER SystemDrive
	Change the %TEMP% environment variable path to %SystemDrive%\Temp

	.PARAMETER Default
	Change the %TEMP% environment variable path to %LOCALAPPDATA%\Temp

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
			if ((Get-LocalUser | Where-Object -FilterScript {$_.Enabled}).Count -gt 1)
			{
				return
			}

			# PowerShell 5.1 (7.3 too) interprets 8.3 file name literally, if an environment variable contains a non-latin word
			if ((Get-Item -Path $env:TEMP).FullName -eq "$env:SystemDrive\Temp")
			{
				return
			}

			# Restart the Printer Spooler service (Spooler)
			Restart-Service -Name Spooler -Force

			if (-not (Test-Path -Path $env:SystemDrive\Temp))
			{
				New-Item -Path $env:SystemDrive\Temp -ItemType Directory -Force
			}

			# Cleaning up folders
			Remove-Item -Path $env:SystemRoot\Temp -Recurse -Force -ErrorAction Ignore
			Get-Item -Path $env:TEMP -Force | Where-Object -FilterScript {$_.LinkType -ne "SymbolicLink"} | Remove-Item -Recurse -Force -ErrorAction Ignore

			if (-not (Test-Path -Path $env:LOCALAPPDATA\Temp))
			{
				New-Item -Path $env:LOCALAPPDATA\Temp -ItemType Directory -Force
			}

			# If there are some files or folders left in %LOCALAPPDATA\Temp%
			if ((Get-ChildItem -Path $env:TEMP -Force -ErrorAction Ignore | Measure-Object).Count -ne 0)
			{
				# https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-movefileexa
				# The system does not move the file until the operating system is restarted
				# The system moves the file immediately after AUTOCHK is executed, but before creating any paging files
				$Signature = @{
					Namespace        = "WinAPI"
					Name             = "DeleteFiles"
					Language         = "CSharp"
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
					Get-ChildItem -Path $env:TEMP -Recurse -Force -ErrorAction Ignore | Remove-Item -Recurse -Force -ErrorAction Stop
				}
				catch
				{
					# If files are in use remove them at the next boot
					Get-ChildItem -Path $env:TEMP -Recurse -Force -ErrorAction Ignore | ForEach-Object -Process {[WinAPI.DeleteFiles]::MarkFileDelete($_.FullName)}
				}

				$SymbolicLinkTask = @"
Get-ChildItem -Path `$env:LOCALAPPDATA\Temp -Recurse -Force | Remove-Item -Recurse -Force

Get-Item -Path `$env:LOCALAPPDATA\Temp -Force | Where-Object -FilterScript {`$_.LinkType -ne """SymbolicLink"""} | Remove-Item -Recurse -Force
New-Item -Path `$env:LOCALAPPDATA\Temp -ItemType SymbolicLink -Value `$env:SystemDrive\Temp -Force

Unregister-ScheduledTask -TaskName SymbolicLink -Confirm:`$false
"@

				# Create a temporary scheduled task to create a symbolic link to the %SystemDrive%\Temp folder
				$Action     = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Hidden -Command $SymbolicLinkTask"
				$Trigger    = New-ScheduledTaskTrigger -AtLogon -User $env:USERNAME
				$Settings   = New-ScheduledTaskSettingsSet -Compatibility Win8
				$Principal  = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
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

			# Change the %TEMP% environment variable path to %LOCALAPPDATA%\Temp
			# The additional registry key creating are needed to fix the property type of the keys: SetEnvironmentVariable creates them with the "String" type instead of "ExpandString" as by default
			[Environment]::SetEnvironmentVariable("TMP", "$env:SystemDrive\Temp", "User")
			[Environment]::SetEnvironmentVariable("TMP", "$env:SystemDrive\Temp", "Machine")
			[Environment]::SetEnvironmentVariable("TMP", "$env:SystemDrive\Temp", "Process")
			New-ItemProperty -Path HKCU:\Environment -Name TMP -PropertyType ExpandString -Value $env:SystemDrive\Temp -Force

			[Environment]::SetEnvironmentVariable("TEMP", "$env:SystemDrive\Temp", "User")
			[Environment]::SetEnvironmentVariable("TEMP", "$env:SystemDrive\Temp", "Machine")
			[Environment]::SetEnvironmentVariable("TEMP", "$env:SystemDrive\Temp", "Process")
			New-ItemProperty -Path HKCU:\Environment -Name TEMP -PropertyType ExpandString -Value $env:SystemDrive\Temp -Force

			New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name TMP -PropertyType ExpandString -Value $env:SystemDrive\Temp -Force
		}
		"Default"
		{
			# PowerShell 5.1 (7.3 too) interprets 8.3 file name literally, if an environment variable contains a non-latin word
			if ((Get-Item -Path $env:TEMP).FullName -eq "$env:LOCALAPPDATA\Temp")
			{
				return
			}

			# Restart the Printer Spooler service (Spooler)
			Restart-Service -Name Spooler -Force

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

			# Removing folders
			# PowerShell 5.1 (7.3 too) interprets 8.3 file name literally, if an environment variable contains a non-latin word
			Remove-Item -Path $((Get-Item -Path $env:TEMP).FullName) -Recurse -Force -ErrorAction Ignore

			if ((Get-ChildItem -Path $env:TEMP -Force -ErrorAction Ignore | Measure-Object).Count -ne 0)
			{
				# https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-movefileexa
				# The system does not move the file until the operating system is restarted
				# The system moves the file immediately after AUTOCHK is executed, but before creating any paging files
				$Signature = @{
					Namespace        = "WinAPI"
					Name             = "DeleteFiles"
					Language         = "CSharp"
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
					# PowerShell 5.1 (7.3 too) interprets 8.3 file name literally, if an environment variable contains a non-latin word
					Remove-Item -Path $((Get-Item -Path $env:TEMP).FullName) -Recurse -Force -ErrorAction Stop
				}
				catch
				{
					# If files are in use remove them at the next boot
					Get-ChildItem -Path $env:TEMP -Recurse -Force | ForEach-Object -Process {[WinAPI.DeleteFiles]::MarkFileDelete($_.FullName)}
				}

				# PowerShell 5.1 (7.3 too) interprets 8.3 file name literally, if an environment variable contains a non-latin word
				$TempFolder = (Get-Item -Path $env:TEMP).FullName
				$TempFolderCleanupTask = @"
Remove-Item -Path "$TempFolder" -Recurse -Force
Unregister-ScheduledTask -TaskName TemporaryTask -Confirm:`$false
"@

				# Create a temporary scheduled task to clean up the temporary folder
				$Action     = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Hidden -Command $TempFolderCleanupTask"
				$Trigger    = New-ScheduledTaskTrigger -AtLogon -User $env:USERNAME
				$Settings   = New-ScheduledTaskSettingsSet -Compatibility Win8
				$Principal  = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
				$Parameters = @{
					TaskName  = "TemporaryTask"
					Principal = $Principal
					Action    = $Action
					Settings  = $Settings
					Trigger   = $Trigger
				}
				Register-ScheduledTask @Parameters -Force
			}

			# Change the %TEMP% environment variable path to %LOCALAPPDATA%\Temp
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
		}
	}
}

<#
	.SYNOPSIS
	The Windows 260 character path limit

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
	Stop error code when BSoD occurs

	.PARAMETER Enable
	Display Stop error code when BSoD occurs

	.PARAMETER Disable
	Do not Stop error code when BSoD occurs

	.EXAMPLE
	BSoDStopError -Enable

	.EXAMPLE
	BSoDStopError -Disable

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
		"Enable"
		{
			New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl -Name DisplayParameters -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\CrashControl -Name DisplayParameters -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	The User Account Control (UAC) behavior

	.PARAMETER Never
	Never notify

	.PARAMETER Default
	Notify me only when apps try to make changes to my computer

	.EXAMPLE
	AdminApprovalMode -Never

	.EXAMPLE
	AdminApprovalMode -Default

	.NOTES
	Machine-wide
#>
function AdminApprovalMode
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Never"
		)]
		[switch]
		$Never,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Default"
		)]
		[switch]
		$Default
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Never"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -PropertyType DWord -Value 0 -Force
		}
		"Default"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -PropertyType DWord -Value 5 -Force
		}
	}
}

<#
	.SYNOPSIS
	Access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled

	.PARAMETER Enable
	Turn on access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled

	.PARAMETER Disable
	Turn off access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled

	.EXAMPLE
	MappedDrivesAppElevatedAccess -Enable

	.EXAMPLE
	MappedDrivesAppElevatedAccess -Disable

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
		"Enable"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLinkedConnections -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name EnableLinkedConnections -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	Delivery Optimization

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
	The Group Policy processing

	.PARAMETER Enable
	Always wait for the network at computer startup and logon for workgroup networks

	.PARAMETER Disable
	Never wait for the network at computer startup and logon for workgroup networks

	.EXAMPLE
	WaitNetworkStartup -Enable

	.EXAMPLE
	WaitNetworkStartup -Disable

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
		"Enable"
		{
			if ((Get-CimInstance -ClassName CIM_ComputerSystem).PartOfDomain)
			{
				if (-not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon"))
				{
					New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Force
				}
				New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name SyncForegroundPolicy -PropertyType DWord -Value 1 -Force
				Set-Policy -Scope Computer -Path "SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name SyncForegroundPolicy -Type DWORD -Value 1
			}
		}
		"Disable"
		{
			if ((Get-CimInstance -ClassName CIM_ComputerSystem).PartOfDomain)
			{
				Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name SyncForegroundPolicy -Force -ErrorAction Ignore
				Set-Policy -Scope Computer -Path "SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name SyncForegroundPolicy -Type CLEAR
			}
		}
	}
}

<#
	.SYNOPSIS
	Windows manages my default printer

	.PARAMETER Disable
	Do not let Windows manage my default printer

	.PARAMETER Enable
	Let Windows manage my default printer

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
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows" -Name LegacyDefaultPrinterMode -PropertyType DWord -Value 1 -Force
		}
		"Enable"
		{
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows" -Name LegacyDefaultPrinterMode -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Windows features

	.PARAMETER Disable
	Disable Windows features

	.PARAMETER Enable
	Enable Windows features

	.EXAMPLE
	WindowsFeatures -Disable

	.EXAMPLE
	WindowsFeatures -Enable

	.NOTES
	A pop-up dialog box lets a user select features

	.NOTES
	Current user
#>
function WindowsFeatures
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

	Add-Type -AssemblyName PresentationCore, PresentationFramework

	#region Variables
	# Initialize an array list to store the selected Windows features
	$SelectedFeatures = New-Object -TypeName System.Collections.ArrayList($null)

	# The following Windows features will have their checkboxes checked
	[string[]]$CheckedFeatures = @(
		# Legacy Components
		"LegacyComponents",

		# PowerShell 2.0
		"MicrosoftWindowsPowerShellV2",
		"MicrosoftWindowsPowershellV2Root",

		# Microsoft XPS Document Writer
		"Printing-XPSServices-Features",

		# Work Folders Client
		"WorkFolders-Client"
	)

	# The following Windows features will have their checkboxes unchecked
	[string[]]$UncheckedFeatures = @(
		# Media Features
		# If you want to leave "Multimedia settings" in the advanced settings of Power Options do not disable this feature
		"MediaPlayback"
	)
	#endregion Variables

	#region XAML Markup
	# The section defines the design of the upcoming dialog box
	[xml]$XAML = @"
	<Window
		xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Name="Window"
		MinHeight="450" MinWidth="400"
		SizeToContent="WidthAndHeight" WindowStartupLocation="CenterScreen"
		TextOptions.TextFormattingMode="Display" SnapsToDevicePixels="True"
		FontFamily="Candara" FontSize="16" ShowInTaskbar="True"
		Background="#F1F1F1" Foreground="#262626">
		<Window.Resources>
			<Style TargetType="StackPanel">
				<Setter Property="Orientation" Value="Horizontal"/>
				<Setter Property="VerticalAlignment" Value="Top"/>
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
			<ScrollViewer Name="Scroll" Grid.Row="0"
				HorizontalScrollBarVisibility="Disabled"
				VerticalScrollBarVisibility="Auto">
				<StackPanel Name="PanelContainer" Orientation="Vertical"/>
			</ScrollViewer>
			<Button Name="Button" Grid.Row="2"/>
		</Grid>
	</Window>
"@
	#endregion XAML Markup

	$Form = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $XAML))
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
		Write-Information -MessageData "" -InformationAction Continue
		# Extract the localized "Please wait..." string from shell32.dll
		Write-Verbose -Message ([WinAPI.GetStr]::GetString(12612)) -Verbose

		[void]$Window.Close()

		$SelectedFeatures | ForEach-Object -Process {Write-Verbose $_.DisplayName -Verbose}
		$SelectedFeatures | Disable-WindowsOptionalFeature -Online -NoRestart
	}

	function EnableButton
	{
		Write-Information -MessageData "" -InformationAction Continue
		# Extract the localized "Please wait..." string from shell32.dll
		Write-Verbose -Message ([WinAPI.GetStr]::GetString(12612)) -Verbose

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

	Write-Information -MessageData "" -InformationAction Continue
	# Extract the localized "Please wait..." string from shell32.dll
	Write-Verbose -Message ([WinAPI.GetStr]::GetString(12612)) -Verbose

	# Getting list of all optional features according to the conditions
	$OFS = "|"
	$Features = Get-WindowsOptionalFeature -Online | Where-Object -FilterScript {
		($_.State -in $State) -and (($_.FeatureName -match $UncheckedFeatures) -or ($_.FeatureName -match $CheckedFeatures))
	} | ForEach-Object -Process {Get-WindowsOptionalFeature -FeatureName $_.FeatureName -Online}
	$OFS = " "

	if (-not ($Features))
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Verbose -Message $Localization.NoData -Verbose

		return
	}

	Write-Information -MessageData "" -InformationAction Continue
	Write-Verbose -Message $Localization.DialogBoxOpening -Verbose

	#region Sendkey function
	# Emulate the Backspace key sending to prevent the console window to freeze
	Start-Sleep -Milliseconds 500

	Add-Type -AssemblyName System.Windows.Forms

	$Signature = @{
		Namespace        = "WinAPI"
		Name             = "ForegroundWindow"
		Language         = "CSharp"
		MemberDefinition = @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

[DllImport("user32.dll")]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool SetForegroundWindow(IntPtr hWnd);
"@
	}

	if (-not ("WinAPI.ForegroundWindow" -as [type]))
	{
		Add-Type @Signature
	}

	Get-Process | Where-Object -FilterScript {($_.ProcessName -eq "powershell") -and ($_.MainWindowTitle -match "Sophia Script for Windows 10 LTSC")} | ForEach-Object -Process {
		# Show window, if minimized
		[WinAPI.ForegroundWindow]::ShowWindowAsync($_.MainWindowHandle, 10)

		Start-Sleep -Seconds 1

		# Force move the console window to the foreground
		[WinAPI.ForegroundWindow]::SetForegroundWindow($_.MainWindowHandle)

		Start-Sleep -Seconds 1

		# Emulate the Backspace key sending
		[System.Windows.Forms.SendKeys]::SendWait("{BACKSPACE 1}")
	}
	#endregion Sendkey function

	$Window.Add_Loaded({$Features | Add-FeatureControl})
	$Button.Content = $ButtonContent
	$Button.Add_Click({& $ButtonAdd_Click})

	$Window.Title = $Localization.WindowsFeaturesTitle

	# Force move the WPF form to the foreground
	$Window.Add_Loaded({$Window.Activate()})
	$Form.ShowDialog() | Out-Null
}

<#
	.SYNOPSIS
	Optional features

	.PARAMETER Uninstall
	Uninstall optional features

	.PARAMETER Install
	Install optional features

	.EXAMPLE
	WindowsCapabilities -Uninstall

	.EXAMPLE
	WindowsCapabilities -Install

	.NOTES
	A pop-up dialog box lets a user select features

	.NOTES
	Current user
#>
function WindowsCapabilities
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

	Add-Type -AssemblyName PresentationCore, PresentationFramework

	#region Variables
	# Initialize an array list to store the selected optional features
	$SelectedCapabilities = New-Object -TypeName System.Collections.ArrayList($null)

	# The following optional features will have their checkboxes checked
	[string[]]$CheckedCapabilities = @(
		# Steps Recorder
		"App.StepsRecorder*",

		# Microsoft Quick Assist
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
		"MathRecognizer*",

		# Windows Media Player
		# If you want to leave "Multimedia settings" element in the advanced settings of Power Options do not uninstall this feature
		"Media.WindowsMediaPlayer*",

		# OpenSSH Client
		"OpenSSH.Client*"
	)

	# The following optional features will be excluded from the display
	[string[]]$ExcludedCapabilities = @(
		# The DirectX Database to configure and optimize apps when multiple Graphics Adapters are present
		"DirectX.Configuration.Database*",

		# Language components
		"Language.*",

		# Notepad
		"Microsoft.Windows.Notepad*",

		# Mail, contacts, and calendar sync component
		"OneCoreUAP.OneSync*",

		# Windows PowerShell Intergrated Scripting Enviroment
		"Microsoft.Windows.PowerShell.ISE*",

		# Management of printers, printer drivers, and printer servers
		"Print.Management.Console*",

		# Features critical to Windows functionality
		"Windows.Client.ShellComponents*"
	)
	#endregion Variables

	#region XAML Markup
	# The section defines the design of the upcoming dialog box
	[xml]$XAML = @"
	<Window
		xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Name="Window"
		MinHeight="450" MinWidth="400"
		SizeToContent="WidthAndHeight" WindowStartupLocation="CenterScreen"
		TextOptions.TextFormattingMode="Display" SnapsToDevicePixels="True"
		FontFamily="Candara" FontSize="16" ShowInTaskbar="True"
		Background="#F1F1F1" Foreground="#262626">
		<Window.Resources>
			<Style TargetType="StackPanel">
				<Setter Property="Orientation" Value="Horizontal"/>
				<Setter Property="VerticalAlignment" Value="Top"/>
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
			<ScrollViewer Name="Scroll" Grid.Row="0"
				HorizontalScrollBarVisibility="Disabled"
				VerticalScrollBarVisibility="Auto">
				<StackPanel Name="PanelContainer" Orientation="Vertical"/>
			</ScrollViewer>
			<Button Name="Button" Grid.Row="2"/>
		</Grid>
	</Window>
"@
	#endregion XAML Markup

	$Form = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $XAML))
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
		Write-Information -MessageData "" -InformationAction Continue
		# Extract the localized "Please wait..." string from shell32.dll
		Write-Verbose -Message ([WinAPI.GetStr]::GetString(12612)) -Verbose

		[void]$Window.Close()

		$SelectedCapabilities | ForEach-Object -Process {Write-Verbose -Message $_.DisplayName -Verbose}
		$SelectedCapabilities | Where-Object -FilterScript {$_.Name -in (Get-WindowsCapability -Online).Name} | Remove-WindowsCapability -Online

		if ([string]$SelectedCapabilities.Name -match "Browser.InternetExplorer")
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message $Localization.RestartWarning
		}
	}

	function InstallButton
	{
		Write-Information -MessageData "" -InformationAction Continue
		# Extract the localized "Please wait..." string from shell32.dll
		Write-Verbose -Message ([WinAPI.GetStr]::GetString(12612)) -Verbose

		[void]$Window.Close()

		$SelectedCapabilities | ForEach-Object -Process {Write-Verbose -Message $_.DisplayName -Verbose}
		$SelectedCapabilities | Where-Object -FilterScript {$_.Name -in ((Get-WindowsCapability -Online).Name)} | Add-WindowsCapability -Online

		if ([string]$SelectedCapabilities.Name -match "Browser.InternetExplorer")
		{
			Write-Information -MessageData "" -InformationAction Continue
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
			try
			{
				# Check the internet connection
				$Parameters = @{
					Uri              = "https://www.google.com"
					Method           = "Head"
					DisableKeepAlive = $true
					UseBasicParsing  = $true
				}
				if (-not (Invoke-WebRequest @Parameters).StatusDescription)
				{
					return
				}

				$State = "NotPresent"
				$ButtonContent = $Localization.Install
				$ButtonAdd_Click = {InstallButton}
			}
			catch [System.Net.WebException]
			{
				Write-Warning -Message $Localization.NoInternetConnection
				Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue

				Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue
			}
		}
		"Uninstall"
		{
			$State = "Installed"
			$ButtonContent = $Localization.Uninstall
			$ButtonAdd_Click = {UninstallButton}
		}
	}

	Write-Information -MessageData "" -InformationAction Continue
	# Extract the localized "Please wait..." string from shell32.dll
	Write-Verbose -Message ([WinAPI.GetStr]::GetString(12612)) -Verbose

	# Getting list of all capabilities according to the conditions
	$OFS = "|"
	$Capabilities = Get-WindowsCapability -Online | Where-Object -FilterScript {
		($_.State -eq $State) -and (($_.Name -match $UncheckedCapabilities) -or ($_.Name -match $CheckedCapabilities) -and ($_.Name -notmatch $ExcludedCapabilities))
	} | ForEach-Object -Process {Get-WindowsCapability -Name $_.Name -Online}
	$OFS = " "

	if (-not ($Capabilities))
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Verbose -Message $Localization.NoData -Verbose

		return
	}

	Write-Information -MessageData "" -InformationAction Continue
	Write-Verbose -Message $Localization.DialogBoxOpening -Verbose

	#region Sendkey function
	# Emulate the Backspace key sending to prevent the console window to freeze
	Start-Sleep -Milliseconds 500

	Add-Type -AssemblyName System.Windows.Forms

	$Signature = @{
		Namespace        = "WinAPI"
		Name             = "ForegroundWindow"
		Language         = "CSharp"
		MemberDefinition = @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

[DllImport("user32.dll")]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool SetForegroundWindow(IntPtr hWnd);
"@
	}

	if (-not ("WinAPI.ForegroundWindow" -as [type]))
	{
		Add-Type @Signature
	}

	Get-Process | Where-Object -FilterScript {(($_.ProcessName -eq "powershell") -or ($_.ProcessName -eq "WindowsTerminal")) -and ($_.MainWindowTitle -match "Sophia Script for Windows 10")} | ForEach-Object -Process {
		# Show window, if minimized
		[WinAPI.ForegroundWindow]::ShowWindowAsync($_.MainWindowHandle, 10)

		Start-Sleep -Seconds 1

		# Force move the console window to the foreground
		[WinAPI.ForegroundWindow]::SetForegroundWindow($_.MainWindowHandle)

		Start-Sleep -Seconds 1

		# Emulate the Backspace key sending
		[System.Windows.Forms.SendKeys]::SendWait("{BACKSPACE 1}")
	}
	#endregion Sendkey function

	$Window.Add_Loaded({$Capabilities | Add-CapabilityControl})
	$Button.Content = $ButtonContent
	$Button.Add_Click({& $ButtonAdd_Click})

	$Window.Title = $Localization.OptionalFeaturesTitle

	# Force move the WPF form to the foreground
	$Window.Add_Loaded({$Window.Activate()})
	$Form.ShowDialog() | Out-Null
}

<#
	.SYNOPSIS
	Receive updates for other Microsoft products when you update Windows

	.PARAMETER Enable
	Receive updates for other Microsoft products when you update Windows

	.PARAMETER Disable
	Do not receive updates for other Microsoft products when you update Windows

	.EXAMPLE
	UpdateMicrosoftProducts -Enable

	.EXAMPLE
	UpdateMicrosoftProducts -Disable

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
		"Enable"
		{
			(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "")
		}
		"Disable"
		{
			if (((New-Object -ComObject Microsoft.Update.ServiceManager).Services | Where-Object -FilterScript {$_.ServiceID -eq "7971f918-a847-4430-9279-4a52d1efe18d"}).IsDefaultAUService)
			{
				(New-Object -ComObject Microsoft.Update.ServiceManager).RemoveService("7971f918-a847-4430-9279-4a52d1efe18d")
			}
		}
	}
}

<#
	.SYNOPSIS
	Power plan

	.PARAMETER High
	Set power plan on "High performance"

	.PARAMETER Balanced
	Set power plan on "Balanced"

	.EXAMPLE
	PowerPlan -High

	.EXAMPLE
	PowerPlan -Balanced

	.NOTES
	It isn't recommended to turn on the "High performance" power plan on laptops

	.NOTES
	Current user
#>
function PowerPlan
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
	Network adapters power management

	.PARAMETER Disable
	Do not allow the computer to turn off the network adapters to save power

	.PARAMETER Enable
	Allow the computer to turn off the network adapters to save power

	.EXAMPLE
	NetworkAdaptersSavePower -Disable

	.EXAMPLE
	NetworkAdaptersSavePower -Enable

	.NOTES
	Do not recommend turning it on on laptops

	.NOTES
	Current user
#>
function NetworkAdaptersSavePower
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

	Write-Information -MessageData "" -InformationAction Continue
	# Extract the localized "Please wait..." string from shell32.dll
	Write-Verbose -Message ([WinAPI.GetStr]::GetString(12612)) -Verbose

	if (Get-NetAdapter -Physical | Where-Object -FilterScript {($_.Status -eq "Up") -and $_.MacAddress})
	{
		$PhysicalAdaptersStatusUp = @((Get-NetAdapter -Physical | Where-Object -FilterScript {($_.Status -eq "Up") -and $_.MacAddress}).Name)
	}

	$Adapters = Get-NetAdapter -Physical | Where-Object -FilterScript {$_.MacAddress} | Get-NetAdapterPowerManagement | Where-Object -FilterScript {$_.AllowComputerToTurnOffDevice -ne "Unsupported"}

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

	# All network adapters are turned into "Disconnected" for few seconds, so we need to wait a bit to let them up
	# Otherwise functions below will indicate that there is no the Internet connection
	if ($PhysicalAdaptersStatusUp)
	{
		while
		(
			Get-NetAdapter -Physical -Name $PhysicalAdaptersStatusUp | Where-Object -FilterScript {($_.Status -eq "Disconnected") -and $_.MacAddress}
		)
		{
			Write-Information -MessageData "" -InformationAction Continue
			# Extract the localized "Please wait..." string from shell32.dll
			Write-Verbose -Message ([WinAPI.GetStr]::GetString(12612)) -Verbose
			Start-Sleep -Seconds 2
		}
	}
}

<#
	.SYNOPSIS
	Internet Protocol Version 6 (TCP/IPv6) component

	.PARAMETER Disable
	Disable the Internet Protocol Version 6 (TCP/IPv6) component for all network connections if your ISP doesn't support it

	.PARAMETER Enable
	Enable the Internet Protocol Version 6 (TCP/IPv6) component for all network connections if your ISP supports it

	.PARAMETER PreferIPv4overIPv6
	Enable the Internet Protocol Version 6 (TCP/IPv6) component for all network connections if your ISP supports it. Prefer IPv4 over IPv6

	.EXAMPLE
	IPv6Component -Disable

	.EXAMPLE
	IPv6Component -Enable

	.EXAMPLE
	IPv6Component -PreferIPv4overIPv6

	.NOTES
	Before invoking the function, a check will be run whether your ISP supports the IPv6 protocol using https://ipify.org

	.NOTES
	Current user
#>
function IPv6Component
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
		$Enable,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "PreferIPv4overIPv6"
		)]
		[switch]
		$PreferIPv4overIPv6
	)

	try
	{
		# Check the internet connection
		$Parameters = @{
			Uri              = "https://www.google.com"
			Method           = "Head"
			DisableKeepAlive = $true
			UseBasicParsing  = $true
		}
		if (-not (Invoke-WebRequest @Parameters).StatusDescription)
		{
			return
		}

		try
		{
			# Check whether the https://ipify.org site is alive
			$Parameters = @{
				Uri              = "https://ipify.org"
				Method           = "Head"
				DisableKeepAlive = $true
				UseBasicParsing  = $true
			}
			if (-not (Invoke-WebRequest @Parameters).StatusDescription)
			{
				return
			}

			# Check whether the ISP supports IPv6 protocol using https://ipify.org
			$Parameters = @{
				Uri             = "https://api64.ipify.org?format=json"
				UseBasicParsing = $true
				Verbose         = $true
			}
			$IPAddress = (Invoke-RestMethod @Parameters).ip
		}
		catch [System.Net.WebException]
		{
			Write-Warning -Message ($Localization.NoResponse -f "https://ipify.org")
			Write-Error -Message ($Localization.NoResponse -f "https://ipify.org") -ErrorAction SilentlyContinue

			Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue
		}
	}
	catch [System.Net.WebException]
	{
		Write-Warning -Message $Localization.NoInternetConnection
		Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue

		Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue
	}

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			if ($IPAddress -notmatch ":")
			{
				Disable-NetAdapterBinding -Name * -ComponentID ms_tcpip6
			}
		}
		"Enable"
		{
			if ($IPAddress -match ":")
			{
				Enable-NetAdapterBinding -Name * -ComponentID ms_tcpip6
			}
		}
		"PreferIPv4overIPv6"
		{
			if ($IPVersion -match ":")
			{
				Enable-NetAdapterBinding -Name * -ComponentID ms_tcpip6
				New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters -Name DisabledComponents -PropertyType DWord -Value 32 -Force
			}
		}
	}
}

<#
	.SYNOPSIS
	Override for default input method

	.PARAMETER English
	Override for default input method: English

	.PARAMETER Default
	Override for default input method: use language list

	.EXAMPLE
	InputMethod -English

	.EXAMPLE
	InputMethod -Default

	.NOTES
	Current user
#>
function InputMethod
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
			Remove-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name InputMethodOverride -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	Change User folders location

	.PARAMETER Root
	Change user folders location to the root of any drive using the interactive menu

	.PARAMETER Custom
	Select folders for user folders location manually using a folder browser dialog

	.PARAMETER Default
	Change user folders location to the default values

	.EXAMPLE
	Set-UserShellFolderLocation -Root

	.EXAMPLE
	Set-UserShellFolderLocation -Custom

	.EXAMPLE
	Set-UserShellFolderLocation -Default

	.NOTES
	User files or folders won't me moved to a new location

	.NOTES
	Current user
#>
function Set-UserShellFolderLocation
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
		Set-UserShellFolder -UserFolder Desktop -FolderPath "$env:SystemDrive:\Desktop" -RemoveDesktopINI

		.LINK
		https://docs.microsoft.com/en-us/windows/win32/api/shlobj_core/nf-shlobj_core-shgetknownfolderpath

		.NOTES
		User files or folders won't me moved to a new location
	#>
	function Set-UserShellFolder
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
			Set-KnownFolderPath -KnownFolder Desktop -Path "$env:SystemDrive:\Desktop"
		#>
		function Set-KnownFolderPath
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
				"Desktop"   = @("B4BFCC3A-DB2C-424C-B029-7FE99A87C641");
				"Documents" = @("FDD39AD0-238F-46AF-ADB4-6C85480369C7", "f42ee2d3-909f-4907-8871-4c22fc0bf756");
				"Downloads" = @("374DE290-123F-4565-9164-39C4925E467B", "7d83ee9b-2244-4e70-b1f5-5393042af1e4");
				"Music"     = @("4BD8D571-6D19-48D3-BE97-422220080E43", "a0c69a99-21c8-4671-8703-7934162fcf1d");
				"Pictures"  = @("33E28130-4E1E-4676-835A-98395C3BC3BB", "0ddd015d-b06c-45d5-8c4c-f59713854639");
				"Videos"    = @("18989B1D-99B5-455B-841C-AB7C74E4DDFC", "35286a68-3c57-41a1-bbb1-0eae73d76c95");
			}

			$Signature = @{
				Namespace        = "WinAPI"
				Name             = "KnownFolders"
				Language         = "CSharp"
				MemberDefinition = @"
[DllImport("shell32.dll")]
public extern static int SHSetKnownFolderPath(ref Guid folderId, uint flags, IntPtr token, [MarshalAs(UnmanagedType.LPWStr)] string path);
"@
			}
			if (-not ("WinAPI.KnownFolders" -as [type]))
			{
				Add-Type @Signature
			}

			foreach ($GUID in $KnownFolders[$KnownFolder])
			{
				[WinAPI.KnownFolders]::SHSetKnownFolderPath([ref]$GUID, 0, 0, $Path)
			}
			(Get-Item -Path $Path -Force).Attributes = "ReadOnly"
		}

		$UserShellFoldersRegistryNames = @{
			"Desktop"   = "Desktop"
			"Documents" = "Personal"
			"Downloads" = "{374DE290-123F-4565-9164-39C4925E467B}"
			"Music"     = "My Music"
			"Pictures"  = "My Pictures"
			"Videos"    = "My Video"
		}

		$UserShellFoldersGUIDs = @{
			"Desktop"   = "{754AC886-DF64-4CBA-86B5-F7FBF4FBCEF5}"
			"Documents" = "{F42EE2D3-909F-4907-8871-4C22FC0BF756}"
			"Downloads" = "{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}"
			"Music"     = "{A0C69A99-21C8-4671-8703-7934162FCF1D}"
			"Pictures"  = "{0DDD015D-B06C-45D5-8C4C-F59713854639}"
			"Videos"    = "{35286A68-3C57-41A1-BBB1-0EAE73D76C95}"
		}

		# Contents of the hidden desktop.ini file for each type of user folders
		$DesktopINI = @{
			"Desktop"   = "",
                          "[.ShellClassInfo]",
                          "LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21769",
                          "IconResource=%SystemRoot%\system32\imageres.dll,-183"
			"Documents" = "",
                          "[.ShellClassInfo]",
                          "LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21770",
                          "IconResource=%SystemRoot%\system32\imageres.dll,-112",
                          "IconFile=%SystemRoot%\system32\shell32.dll",
                          "IconIndex=-235"
			"Downloads" = "",
                          "[.ShellClassInfo]","LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21798",
                          "IconResource=%SystemRoot%\system32\imageres.dll,-184"
			"Music"     = "",
                          "[.ShellClassInfo]","LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21790",
                          "InfoTip=@%SystemRoot%\system32\shell32.dll,-12689",
                          "IconResource=%SystemRoot%\system32\imageres.dll,-108",
                          "IconFile=%SystemRoot%\system32\shell32.dll","IconIndex=-237"
			"Pictures" = "",
                          "[.ShellClassInfo]",
                          "LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21779",
                          "InfoTip=@%SystemRoot%\system32\shell32.dll,-12688",
                          "IconResource=%SystemRoot%\system32\imageres.dll,-113",
                          "IconFile=%SystemRoot%\system32\shell32.dll",
                          "IconIndex=-236"
			"Videos"   = "",
                          "[.ShellClassInfo]",
                          "LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21791",
                          "InfoTip=@%SystemRoot%\system32\shell32.dll,-12690",
                          "IconResource=%SystemRoot%\system32\imageres.dll,-189",
                          "IconFile=%SystemRoot%\system32\shell32.dll","IconIndex=-238"
		}

		# Determining the current user folder path
		$CurrentUserFolderPath = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name $UserShellFoldersRegistryNames[$UserFolder]
		if ($CurrentUserFolder -ne $FolderPath)
		{
			# Creating a new folder if there is no one
			if (-not (Test-Path -Path $FolderPath))
			{
				New-Item -Path $FolderPath -ItemType Directory -Force
			}

			# Removing old desktop.ini
			if ($RemoveDesktopINI)
			{
				Remove-Item -Path "$CurrentUserFolderPath\desktop.ini" -Force -ErrorAction Ignore
			}

			Set-KnownFolderPath -KnownFolder $UserFolder -Path $FolderPath
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name $UserShellFoldersGUIDs[$UserFolder] -PropertyType ExpandString -Value $FolderPath -Force

			# Save desktop.ini in the UTF-16 LE encoding
			Set-Content -Path "$FolderPath\desktop.ini" -Value $DesktopINI[$UserFolder] -Encoding Unicode -Force
			(Get-Item -Path "$FolderPath\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$FolderPath\desktop.ini" -Force).Refresh()

			if ((Get-ChildItem -Path $CurrentUserFolderPath | Measure-Object).Count -ne 0)
			{
				Write-Error -Message ($Localization.UserShellFolderNotEmpty -f $CurrentUserFolderPath) -ErrorAction SilentlyContinue
			}
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

		Write-Information -MessageData "" -InformationAction Continue
		Write-Information -MessageData $Title -InformationAction Continue

		# Extract the localized "Skip" string from shell32.dll
		$Menu += [WinAPI.GetStr]::GetString(16956)
		# https://github.com/microsoft/terminal/issues/14992
		[System.Console]::BufferHeight += $Menu.Count
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
					Write-Information -MessageData ('  {1}  ' -f ($i+1), $item) -InformationAction Continue
				}
				else
				{
					Write-Information -MessageData ('[ {1} ]' -f ($i+1), $item) -InformationAction Continue
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
					# Extract the localized "Skip" string from shell32.dll
					if ($Menu[$y] -eq [WinAPI.GetStr]::GetString(16956))
					{
						Write-Verbose -Message $Localization.Skipped -Verbose
						return
					}

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
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message $Localization.RetrievingDrivesList -Verbose

			# Store all fixed disks' letters to use them within ShowMenu function
			# https://learn.microsoft.com/en-us/dotnet/api/system.io.drivetype?view=net-7.0#fields
			$DriveLetters = @((Get-CimInstance -ClassName CIM_LogicalDisk | Where-Object -FilterScript {$_.DriveType -eq 3}).DeviceID | Sort-Object)

			# If the number of disks is more than one, set the second drive in the list as default drive
			if ($DriveLetters.Count -gt 1)
			{
				$Script:Default = 1
			}

			# Desktop
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message ($Localization.DriveSelect -f [WinAPI.GetStr]::GetString(21769)) -Verbose

			$CurrentUserFolderLocation = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Desktop
			Write-Verbose -Message ($Localization.CurrentUserFolderLocation -f [WinAPI.GetStr]::GetString(21769), $CurrentUserFolderLocation) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title = ""
			$Message       = $Localization.UserFolderRequest -f [WinAPI.GetStr]::GetString(21769)
			# Extract the localized "&No" string from shell32.dll
			$No            = [WinAPI.GetStr]::GetString(33232)
			# Extract the localized "&Yes" string from shell32.dll
			$Yes           = [WinAPI.GetStr]::GetString(33224)
			$Options       = $Yes, $No
			$DefaultChoice = 1
			$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					if ($DriveLetters.Count -gt 1)
					{
						$SelectedDrive = ShowMenu -Title ($Localization.DriveSelect -f [WinAPI.GetStr]::GetString(21769)) -Menu $DriveLetters -Default $Script:Default
					}
					else
					{
						$SelectedDrive = $env:SystemDrive
					}

					if ($SelectedDrive)
					{
						Set-UserShellFolder -UserFolder Desktop -FolderPath "${SelectedDrive}\Desktop" -RemoveDesktopINI
					}
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Documents
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message ($Localization.DriveSelect -f [WinAPI.GetStr]::GetString(21770)) -Verbose

			$CurrentUserFolderLocation = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Personal
			Write-Verbose -Message ($Localization.CurrentUserFolderLocation -f [WinAPI.GetStr]::GetString(21770), $CurrentUserFolderLocation) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title         = ""
			$Message       = $Localization.UserFolderRequest -f [WinAPI.GetStr]::GetString(21770)
			# Extract the localized "&No" string from shell32.dll
			$No            = [WinAPI.GetStr]::GetString(33232)
			# Extract the localized "&Yes" string from shell32.dll
			$Yes           = [WinAPI.GetStr]::GetString(33224)
			$Options       = $Yes, $No
			$DefaultChoice = 1
			$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					if ($DriveLetters.Count -gt 1)
					{
						$SelectedDrive = ShowMenu -Title ($Localization.DriveSelect -f [WinAPI.GetStr]::GetString(21770)) -Menu $DriveLetters -Default $Script:Default
					}
					else
					{
						$SelectedDrive = $env:SystemDrive
					}

					if ($SelectedDrive)
					{
						Set-UserShellFolder -UserFolder Documents -FolderPath "${SelectedDrive}\Documents" -RemoveDesktopINI
					}
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Downloads
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message ($Localization.DriveSelect -f [WinAPI.GetStr]::GetString(21798)) -Verbose

			$CurrentUserFolderLocation = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
			Write-Verbose -Message ($Localization.CurrentUserFolderLocation -f [WinAPI.GetStr]::GetString(21798), $CurrentUserFolderLocation) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title         = ""
			$Message       = $Localization.UserFolderRequest -f [WinAPI.GetStr]::GetString(21798)
			# Extract the localized "&No" string from shell32.dll
			$No            = [WinAPI.GetStr]::GetString(33232)
			# Extract the localized "&Yes" string from shell32.dll
			$Yes           = [WinAPI.GetStr]::GetString(33224)
			$Options       = $Yes, $No
			$DefaultChoice = 1
			$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					if ($DriveLetters.Count -gt 1)
					{
						$SelectedDrive = ShowMenu -Title ($Localization.DriveSelect -f [WinAPI.GetStr]::GetString(21798)) -Menu $DriveLetters -Default $Script:Default
					}
					else
					{
						$SelectedDrive = $env:SystemDrive
					}

					if ($SelectedDrive)
					{
						Set-UserShellFolder -UserFolder Downloads -FolderPath "${SelectedDrive}\Downloads" -RemoveDesktopINI
					}
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Music
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message ($Localization.DriveSelect -f [WinAPI.GetStr]::GetString(21790)) -Verbose

			$CurrentUserFolderLocation = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Music"
			Write-Verbose -Message ($Localization.CurrentUserFolderLocation -f [WinAPI.GetStr]::GetString(21790), $CurrentUserFolderLocation) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title         = ""
			$Message       = $Localization.UserFolderRequest -f [WinAPI.GetStr]::GetString(21790)
			# Extract the localized "&No" string from shell32.dll
			$No            = [WinAPI.GetStr]::GetString(33232)
			# Extract the localized "&Yes" string from shell32.dll
			$Yes           = [WinAPI.GetStr]::GetString(33224)
			$Options       = $Yes, $No
			$DefaultChoice = 1
			$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					if ($DriveLetters.Count -gt 1)
					{
						$SelectedDrive = ShowMenu -Title ($Localization.DriveSelect -f [WinAPI.GetStr]::GetString(21790)) -Menu $DriveLetters -Default $Script:Default
					}
					else
					{
						$SelectedDrive = $env:SystemDrive
					}

					if ($SelectedDrive)
					{
						Set-UserShellFolder -UserFolder Music -FolderPath "${SelectedDrive}\Music" -RemoveDesktopINI
					}
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Pictures
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message ($Localization.DriveSelect -f [WinAPI.GetStr]::GetString(21779)) -Verbose

			$CurrentUserFolderLocation = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Pictures"
			Write-Verbose -Message ($Localization.CurrentUserFolderLocation -f [WinAPI.GetStr]::GetString(21779), $CurrentUserFolderLocation) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title         = ""
			$Message       = $Localization.UserFolderRequest -f [WinAPI.GetStr]::GetString(21779)
			# Extract the localized "&No" string from shell32.dll
			$No            = [WinAPI.GetStr]::GetString(33232)
			# Extract the localized "&Yes" string from shell32.dll
			$Yes           = [WinAPI.GetStr]::GetString(33224)
			$Options       = $Yes, $No
			$DefaultChoice = 1
			$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					if ($DriveLetters.Count -gt 1)
					{
						$SelectedDrive = ShowMenu -Title ($Localization.DriveSelect -f [WinAPI.GetStr]::GetString(21779)) -Menu $DriveLetters -Default $Script:Default
					}
					else
					{
						$SelectedDrive = $env:SystemDrive
					}

					if ($SelectedDrive)
					{
						Set-UserShellFolder -UserFolder Pictures -FolderPath "${SelectedDrive}\Pictures" -RemoveDesktopINI
					}
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Videos
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message ($Localization.DriveSelect -f [WinAPI.GetStr]::GetString(21791)) -Verbose

			$CurrentUserFolderLocation = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Video"
			Write-Verbose -Message ($Localization.CurrentUserFolderLocation -f [WinAPI.GetStr]::GetString(21791), $CurrentUserFolderLocation) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title         = ""
			$Message       = $Localization.UserFolderRequest -f [WinAPI.GetStr]::GetString(21791)
			# Extract the localized "&No" string from shell32.dll
			$No            = [WinAPI.GetStr]::GetString(33232)
			# Extract the localized "&Yes" string from shell32.dll
			$Yes           = [WinAPI.GetStr]::GetString(33224)
			$Options       = $Yes, $No
			$DefaultChoice = 1
			$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					if ($DriveLetters.Count -gt 1)
					{
						$SelectedDrive = ShowMenu -Title ($Localization.DriveSelect -f [WinAPI.GetStr]::GetString(21791)) -Menu $DriveLetters -Default $Script:Default
					}
					else
					{
						$SelectedDrive = $env:SystemDrive
					}

					if ($SelectedDrive)
					{
						Set-UserShellFolder -UserFolder Videos -FolderPath "${SelectedDrive}\Videos" -RemoveDesktopINI
					}
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
			Write-Information -MessageData "" -InformationAction Continue
			$CurrentUserFolderLocation = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Desktop

			Write-Verbose -Message ($Localization.CurrentUserFolderLocation -f [WinAPI.GetStr]::GetString(21769), $CurrentUserFolderLocation) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title         = ""
			$Message       = $Localization.UserFolderSelect -f [WinAPI.GetStr]::GetString(21769)
			# Extract the localized "Browse" string from shell32.dll
			$Browse        = [WinAPI.GetStr]::GetString(9015)
			# Extract the localized "&No" string from shell32.dll
			$No            = [WinAPI.GetStr]::GetString(33232)
			$Options       = "&$Browse", $No
			$DefaultChoice = 1
			$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					Add-Type -AssemblyName System.Windows.Forms
					$FolderBrowserDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
					$FolderBrowserDialog.Description = $Localization.FolderSelect
					$FolderBrowserDialog.RootFolder = "MyComputer"

					# Force move the open file dialog to the foreground
					$Focus = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
					$FolderBrowserDialog.ShowDialog($Focus)

					if ($FolderBrowserDialog.SelectedPath)
					{
						Set-UserShellFolder -UserFolder Desktop -FolderPath $FolderBrowserDialog.SelectedPath -RemoveDesktopINI
					}
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Documents
			Write-Information -MessageData "" -InformationAction Continue
			$CurrentUserFolderLocation = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Personal

			Write-Verbose -Message ($Localization.CurrentUserFolderLocation -f [WinAPI.GetStr]::GetString(21770), $CurrentUserFolderLocation) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title         = ""
			$Message       = $Localization.UserFolderSelect -f [WinAPI.GetStr]::GetString(21770)
			# Extract the localized "Browse" string from shell32.dll
			$Browse        = [WinAPI.GetStr]::GetString(9015)
			# Extract the localized "&No" string from shell32.dll
			$No            = [WinAPI.GetStr]::GetString(33232)
			$Options       = "&$Browse", $No
			$DefaultChoice = 1
			$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					Add-Type -AssemblyName System.Windows.Forms
					$FolderBrowserDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
					$FolderBrowserDialog.Description = $Localization.FolderSelect
					$FolderBrowserDialog.RootFolder = "MyComputer"

					# Force move the open file dialog to the foreground
					$Focus = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
					$FolderBrowserDialog.ShowDialog($Focus)

					if ($FolderBrowserDialog.SelectedPath)
					{
						Set-UserShellFolder -UserFolder Documents -FolderPath $FolderBrowserDialog.SelectedPath -RemoveDesktopINI
					}
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Downloads
			Write-Information -MessageData "" -InformationAction Continue
			$CurrentUserFolderLocation = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"

			Write-Verbose -Message ($Localization.CurrentUserFolderLocation -f [WinAPI.GetStr]::GetString(21798), $CurrentUserFolderLocation) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title         = ""
			$Message       = $Localization.UserFolderSelect -f [WinAPI.GetStr]::GetString(21798)
			# Extract the localized "Browse" string from shell32.dll
			$Browse        = [WinAPI.GetStr]::GetString(9015)
			# Extract the localized "&No" string from shell32.dll
			$No            = [WinAPI.GetStr]::GetString(33232)
			$Options       = "&$Browse", $No
			$DefaultChoice = 1
			$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					Add-Type -AssemblyName System.Windows.Forms
					$FolderBrowserDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
					$FolderBrowserDialog.Description = $Localization.FolderSelect
					$FolderBrowserDialog.RootFolder = "MyComputer"

					# Force move the open file dialog to the foreground
					$Focus = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
					$FolderBrowserDialog.ShowDialog($Focus)

					if ($FolderBrowserDialog.SelectedPath)
					{
						Set-UserShellFolder -UserFolder Downloads -FolderPath $FolderBrowserDialog.SelectedPath -RemoveDesktopINI
					}
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Music
			Write-Information -MessageData "" -InformationAction Continue
			$CurrentUserFolderLocation = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Music"

			Write-Verbose -Message ($Localization.CurrentUserFolderLocation -f [WinAPI.GetStr]::GetString(21790), $CurrentUserFolderLocation) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title         = ""
			$Message       = $Localization.UserFolderSelect -f [WinAPI.GetStr]::GetString(21790)
			# Extract the localized "Browse" string from shell32.dll
			$Browse        = [WinAPI.GetStr]::GetString(9015)
			# Extract the localized "&No" string from shell32.dll
			$No            = [WinAPI.GetStr]::GetString(33232)
			$Options       = "&$Browse", $No
			$DefaultChoice = 1
			$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					Add-Type -AssemblyName System.Windows.Forms
					$FolderBrowserDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
					$FolderBrowserDialog.Description = $Localization.FolderSelect
					$FolderBrowserDialog.RootFolder = "MyComputer"

					# Force move the open file dialog to the foreground
					$Focus = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
					$FolderBrowserDialog.ShowDialog($Focus)

					if ($FolderBrowserDialog.SelectedPath)
					{
						Set-UserShellFolder -UserFolder Music -FolderPath $FolderBrowserDialog.SelectedPath -RemoveDesktopINI
					}
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Pictures
			Write-Information -MessageData "" -InformationAction Continue
			$CurrentUserFolderLocation = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Pictures"

			Write-Verbose -Message ($Localization.CurrentUserFolderLocation -f [WinAPI.GetStr]::GetString(21779), $CurrentUserFolderLocation) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title         = ""
			$Message       = $Localization.UserFolderSelect -f [WinAPI.GetStr]::GetString(21779)
			# Extract the localized "Browse" string from shell32.dll
			$Browse        = [WinAPI.GetStr]::GetString(9015)
			# Extract the localized "&No" string from shell32.dll
			$No            = [WinAPI.GetStr]::GetString(33232)
			$Options       = "&$Browse", $No
			$DefaultChoice = 1
			$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					Add-Type -AssemblyName System.Windows.Forms
					$FolderBrowserDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
					$FolderBrowserDialog.Description = $Localization.FolderSelect
					$FolderBrowserDialog.RootFolder = "MyComputer"

					# Force move the open file dialog to the foreground
					$Focus = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
					$FolderBrowserDialog.ShowDialog($Focus)

					if ($FolderBrowserDialog.SelectedPath)
					{
						Set-UserShellFolder -UserFolder Pictures -FolderPath $FolderBrowserDialog.SelectedPath -RemoveDesktopINI
					}
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Videos
			Write-Information -MessageData "" -InformationAction Continue
			$CurrentUserFolderLocation = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Video"

			Write-Verbose -Message ($Localization.CurrentUserFolderLocation -f [WinAPI.GetStr]::GetString(21791), $CurrentUserFolderLocation) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title         = ""
			$Message       = $Localization.UserFolderSelect -f [WinAPI.GetStr]::GetString(21791)
			# Extract the localized "Browse" string from shell32.dll
			$Browse        = [WinAPI.GetStr]::GetString(9015)
			# Extract the localized "&No" string from shell32.dll
			$No            = [WinAPI.GetStr]::GetString(33232)
			$Options       = "&$Browse", $No
			$DefaultChoice = 1
			$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					Add-Type -AssemblyName System.Windows.Forms
					$FolderBrowserDialog = New-Object -TypeName System.Windows.Forms.FolderBrowserDialog
					$FolderBrowserDialog.Description = $Localization.FolderSelect
					$FolderBrowserDialog.RootFolder = "MyComputer"

					# Force move the open file dialog to the foreground
					$Focus = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
					$FolderBrowserDialog.ShowDialog($Focus)

					if ($FolderBrowserDialog.SelectedPath)
					{
						Set-UserShellFolder -UserFolder Videos -FolderPath $FolderBrowserDialog.SelectedPath -RemoveDesktopINI
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
			Write-Information -MessageData "" -InformationAction Continue
			$CurrentUserFolderLocation = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Desktop

			Write-Verbose -Message ($Localization.CurrentUserFolderLocation -f [WinAPI.GetStr]::GetString(21769), $CurrentUserFolderLocation) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title         = ""
			$Message       = $Localization.UserDefaultFolder -f [WinAPI.GetStr]::GetString(21769)
			# Extract the localized "&Yes" string from shell32.dll
			$Yes           = [WinAPI.GetStr]::GetString(33224)
			# Extract the localized "&No" string from shell32.dll
			$No            = [WinAPI.GetStr]::GetString(33232)
			$Options       = $Yes, $No
			$DefaultChoice = 1
			$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					Set-UserShellFolder -UserFolder Desktop -FolderPath "$env:USERPROFILE\Desktop" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Documents
			Write-Information -MessageData "" -InformationAction Continue
			$CurrentUserFolderLocation = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Personal

			Write-Verbose -Message ($Localization.CurrentUserFolderLocation -f [WinAPI.GetStr]::GetString(21770), $CurrentUserFolderLocation) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title         = ""
			$Message       = $Localization.UserDefaultFolder -f [WinAPI.GetStr]::GetString(21770)
			# Extract the localized "&Yes" string from shell32.dll
			$Yes           = [WinAPI.GetStr]::GetString(33224)
			# Extract the localized "&No" string from shell32.dll
			$No            = [WinAPI.GetStr]::GetString(33232)
			$Options       = $Yes, $No
			$DefaultChoice = 1
			$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					Set-UserShellFolder -UserFolder Documents -FolderPath "$env:USERPROFILE\Documents" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Downloads
			Write-Information -MessageData "" -InformationAction Continue
			$CurrentUserFolderLocation = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"

			Write-Verbose -Message ($Localization.CurrentUserFolderLocation -f [WinAPI.GetStr]::GetString(21798), $CurrentUserFolderLocation) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title         = ""
			$Message       = $Localization.UserDefaultFolder -f [WinAPI.GetStr]::GetString(21798)
			# Extract the localized "&Yes" string from shell32.dll
			$Yes           = [WinAPI.GetStr]::GetString(33224)
			# Extract the localized "&No" string from shell32.dll
			$No            = [WinAPI.GetStr]::GetString(33232)
			$Options       = $Yes, $No
			$DefaultChoice = 1
			$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					Set-UserShellFolder -UserFolder Downloads -FolderPath "$env:USERPROFILE\Downloads" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Music
			Write-Information -MessageData "" -InformationAction Continue
			$CurrentUserFolderLocation = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Music"

			Write-Verbose -Message ($Localization.CurrentUserFolderLocation -f [WinAPI.GetStr]::GetString(21790), $CurrentUserFolderLocation) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title         = ""
			$Message       = $Localization.UserDefaultFolder -f [WinAPI.GetStr]::GetString(21790)
			# Extract the localized "&Yes" string from shell32.dll
			$Yes           = [WinAPI.GetStr]::GetString(33224)
			# Extract the localized "&No" string from shell32.dll
			$No            = [WinAPI.GetStr]::GetString(33232)
			$Options       = $Yes, $No
			$DefaultChoice = 1
			$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					Set-UserShellFolder -UserFolder Music -FolderPath "$env:USERPROFILE\Music" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Pictures
			Write-Information -MessageData "" -InformationAction Continue
			$CurrentUserFolderLocation = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Pictures"

			Write-Verbose -Message ($Localization.CurrentUserFolderLocation -f [WinAPI.GetStr]::GetString(21779), $CurrentUserFolderLocation) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title         = ""
			$Message       = $Localization.UserDefaultFolder -f [WinAPI.GetStr]::GetString(21779)
			# Extract the localized "&Yes" string from shell32.dll
			$Yes           = [WinAPI.GetStr]::GetString(33224)
			# Extract the localized "&No" string from shell32.dll
			$No            = [WinAPI.GetStr]::GetString(33232)
			$Options       = $Yes, $No
			$DefaultChoice = 1
			$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					Set-UserShellFolder -UserFolder Pictures -FolderPath "$env:USERPROFILE\Pictures" -RemoveDesktopINI
				}
				"1"
				{
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}

			# Videos
			Write-Information -MessageData "" -InformationAction Continue
			$CurrentUserFolderLocation = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Video"

			Write-Verbose -Message ($Localization.CurrentUserFolderLocation -f [WinAPI.GetStr]::GetString(21791), $CurrentUserFolderLocation) -Verbose
			Write-Warning -Message $Localization.FilesWontBeMoved

			$Title         = ""
			$Message       = $Localization.UserDefaultFolder -f [WinAPI.GetStr]::GetString(21791)
			# Extract the localized "&Yes" string from shell32.dll
			$Yes           = [WinAPI.GetStr]::GetString(33224)
			# Extract the localized "&No" string from shell32.dll
			$No            = [WinAPI.GetStr]::GetString(33232)
			$Options       = $Yes, $No
			$DefaultChoice = 1
			$Result        = $Host.UI.PromptForChoice($Title, $Message, $Options, $DefaultChoice)

			switch ($Result)
			{
				"0"
				{
					Set-UserShellFolder -UserFolder Videos -FolderPath "$env:USERPROFILE\Videos" -RemoveDesktopINI
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
	The the latest installed .NET runtime for all apps usage

	.PARAMETER Enable
	Use the latest installed .NET runtime for all apps

	.PARAMETER Disable
	Do not use the latest installed .NET runtime for all apps

	.EXAMPLE
	LatestInstalled.NET -Enable

	.EXAMPLE
	LatestInstalled.NET -Disable

	.NOTES
	Machine-wide
#>
function LatestInstalled.NET
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
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\.NETFramework -Name OnlyUseLatestCLR -PropertyType DWord -Value 1 -Force
			New-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework -Name OnlyUseLatestCLR -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\.NETFramework -Name OnlyUseLatestCLR -Force -ErrorAction Ignore
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework -Name OnlyUseLatestCLR -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	The location to save screenshots by pressing Win+PrtScr

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
			$DesktopFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Desktop
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{B7BEDE81-DF94-4682-A7D8-57A52620B86F}" -PropertyType ExpandString -Value $DesktopFolder -Force
		}
		"Default"
		{
			Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{B7BEDE81-DF94-4682-A7D8-57A52620B86F}" -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	Recommended troubleshooter preferences

	.PARAMETER Automatically
	Run troubleshooter automatically, then notify me

	.PARAMETER Default
	Ask me before running troubleshooter

	.EXAMPLE
	RecommendedTroubleshooting -Automatically

	.EXAMPLE
	RecommendedTroubleshooting -Default

	.NOTES
	In order this feature to work the OS level of diagnostic data gathering will be set to "Optional diagnostic data" and the error reporting feature will be turned on

	.NOTES
	Machine-wide
#>
function RecommendedTroubleshooting
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Automatically"
		)]
		[switch]
		$Automatically,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Default"
		)]
		[switch]
		$Default
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Automatically"
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
	if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack))
	{
		New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack -Force
	}
	New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 3 -Force
	New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name MaxTelemetryAllowed -PropertyType DWord -Value 3 -Force
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack -Name ShowedToastAtLevel -PropertyType DWord -Value 3 -Force
	Set-Policy -Scope Computer -Path SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name AllowTelemetry -Type DWORD -Value 1

	# Turn on Windows Error Reporting
	Get-ScheduledTask -TaskName QueueReporting | Enable-ScheduledTask
	Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\Windows Error Reporting" -Name Disabled -Force -ErrorAction Ignore

	Get-Service -Name WerSvc | Set-Service -StartupType Manual
	Get-Service -Name WerSvc | Start-Service
}

<#
	.SYNOPSIS
	Folder windows launching in a separate process

	.PARAMETER Enable
	Launch folder windows in a separate process

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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SeparateProcess -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SeparateProcess -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Reserved storage

	.PARAMETER Disable
	Disable and delete reserved storage after the next update installation

	.PARAMETER Enable
	Enable reserved storage after the next update installation

	.EXAMPLE
	ReservedStorage -Disable

	.EXAMPLE
	ReservedStorage -Enable

	.NOTES
	Current user
#>
function ReservedStorage
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
			try
			{
				Set-WindowsReservedStorageState -State Disabled
			}
			catch [System.Runtime.InteropServices.COMException]
			{
				Write-Error -Message ($Localization.ReservedStorageIsInUse -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue
			}
		}
		"Enable"
		{
			Set-WindowsReservedStorageState -State Enabled
		}
	}
}

<#
	.SYNOPSIS
	Help look up via F1

	.PARAMETER Disable
	Disable help lookup via F1

	.PARAMETER Enable
	Enable help lookup via F1

	.EXAMPLE
	F1HelpPage -Disable

	.EXAMPLE
	F1HelpPage -Enable

	.NOTES
	Current user
#>
function F1HelpPage
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
			if (-not (Test-Path -Path "HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64"))
			{
				New-Item -Path "HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64" -Force
			}
			New-ItemProperty -Path "HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\1.0\0\win64" -Name "(default)" -PropertyType String -Value "" -Force
		}
		"Enable"
		{
			Remove-Item -Path "HKCU:\Software\Classes\Typelib\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}" -Recurse -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	Num Lock at startup

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
	Caps Lock

	.PARAMETER Disable
	Disable Caps Lock

	.PARAMETER Enable
	Enable Caps Lock

	.EXAMPLE
	CapsLock -Disable

	.EXAMPLE
	CapsLock -Enable

	.NOTES
	Machine-wide
#>
function CapsLock
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
			New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout" -Name "Scancode Map" -PropertyType Binary -Value ([byte[]](0,0,0,0,0,0,0,0,2,0,0,0,0,0,58,0,0,0,0,0)) -Force
		}
		"Enable"
		{
			Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout" -Name "Scancode Map" -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	The shortcut to start Sticky Keys

	.PARAMETER Disable
	Do not allow the shortcut key to Start Sticky Keys by pressing the the Shift key 5 times

	.PARAMETER Enable
	Allow the shortcut key to Start Sticky Keys by pressing the the Shift key 5 times

	.EXAMPLE
	StickyShift -Disable

	.EXAMPLE
	StickyShift -Enable

	.NOTES
	Current user
#>
function StickyShift
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
			New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name Flags -PropertyType String -Value 506 -Force
		}
		"Enable"
		{
			New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name Flags -PropertyType String -Value 510 -Force
		}
	}
}

<#
	.SYNOPSIS
	AutoPlay for all media and devices

	.PARAMETER Disable
	Don't use AutoPlay for all media and devices

	.PARAMETER Enable
	Use AutoPlay for all media and devices

	.EXAMPLE
	Autoplay -Disable

	.EXAMPLE
	Autoplay -Enable

	.NOTES
	Current user
#>
function Autoplay
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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers -Name DisableAutoplay -PropertyType DWord -Value 1 -Force
		}
		"Enable"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers -Name DisableAutoplay -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Thumbnail cache removal

	.PARAMETER Disable
	Disable thumbnail cache removal

	.PARAMETER Enable
	Enable thumbnail cache removal

	.EXAMPLE
	ThumbnailCacheRemoval -Disable

	.EXAMPLE
	ThumbnailCacheRemoval -Enable

	.NOTES
	Machine-wide
#>
function ThumbnailCacheRemoval
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
			New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" -Name Autorun -PropertyType DWord -Value 0 -Force
			New-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" -Name Autorun -PropertyType DWord -Value 0 -Force
		}
		"Enable"
		{
			New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" -Name Autorun -PropertyType DWord -Value 3 -Force
			New-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" -Name Autorun -PropertyType DWord -Value 3 -Force
		}
	}
}

<#
	.SYNOPSIS
	Restart apps after signing in

	.PARAMETER Enable
	Automatically saving my restartable apps when signing out and restart them after signing in

	.PARAMETER Disable
	Turn off automatically saving my restartable apps when signing out and restart them after signing in

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
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name RestartApps -PropertyType DWord -Value 1 -Force
		}
		"Disable"
		{
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name RestartApps -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Network Discovery File and Printers Sharing

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
		"@FirewallAPI.dll,-32752",

		# Network discovery
		"@FirewallAPI.dll,-28502"
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Enable"
		{
			if (-not (Get-CimInstance -ClassName CIM_ComputerSystem).PartOfDomain)
			{
				Set-NetFirewallRule -Group $FirewallRules -Profile Private -Enabled True

				Set-NetFirewallRule -Profile Public, Private -Name FPS-SMB-In-TCP -Enabled True
				Set-NetConnectionProfile -NetworkCategory Private
			}
		}
		"Disable"
		{
			if (-not (Get-CimInstance -ClassName CIM_ComputerSystem).PartOfDomain)
			{
				Set-NetFirewallRule -Group $FirewallRules -Profile Private -Enabled False
			}
		}
	}
}

<#
	.SYNOPSIS
	Active hours

	.PARAMETER Automatically
	Automatically adjust active hours for me based on daily usage

	.PARAMETER Manually
	Manually adjust active hours for me based on daily usage

	.EXAMPLE
	ActiveHours -Automatically

	.EXAMPLE
	ActiveHours -Manually

	.NOTES
	Machine-wide
#>
function ActiveHours
{
	param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Automatically"
		)]
		[switch]
		$Automatically,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Manually"
		)]
		[switch]
		$Manually
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Automatically"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name SmartActiveHoursState -PropertyType DWord -Value 1 -Force
		}
		"Manually"
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name SmartActiveHoursState -PropertyType DWord -Value 0 -Force
		}
	}
}

<#
	.SYNOPSIS
	Restart this device as soon as possible when a restart is required to install an update

	.PARAMETER Enable
	Restart this device as soon as possible when a restart is required to install an update

	.PARAMETER Disable
	Don't restart this device as soon as possible when a restart is required to install an update

	.EXAMPLE
	DeviceRestartAfterUpdate -Enable

	.EXAMPLE
	DeviceRestartAfterUpdate -Disable

	.NOTES
	Machine-wide
#>
function RestartDeviceAfterUpdate
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
	Register app, calculate hash, and associate with an extension with the "How do you want to open this" pop-up hidden

	.PARAMETER ProgramPath
	Set a path to a program to associate an extension with

	.PARAMETER Extension
	Set the extension type

	.PARAMETER Icon
	Set a path to an icon

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
		[string]
		$ProgramPath,

		[Parameter(
			Mandatory = $true,
			Position = 1
		)]
		[string]
		$Extension,

		[Parameter(Mandatory = $false)]
		[string]
		$Icon
	)

	$ProgramPath = [System.Environment]::ExpandEnvironmentVariables($ProgramPath)

	if (-not (Test-Path -Path $ProgramPath))
	{
		Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue

		return
	}

	if ($Icon)
	{
		$Icon = [System.Environment]::ExpandEnvironmentVariables($Icon)
	}

	if (Test-Path -Path $ProgramPath)
	{
		# Generate ProgId
		$ProgId = (Get-Item -Path $ProgramPath).BaseName + $Extension.ToUpper()
	}
	else
	{
		$ProgId = $ProgramPath
	}

	#region functions
	$Signature = @{
		Namespace        = "WinAPI"
		Name             = "Action"
		Language         = "CSharp"
		UsingNamespace   = "System.Text", "System.Security.AccessControl", "Microsoft.Win32"
		MemberDefinition = @"
[DllImport("advapi32.dll", CharSet = CharSet.Auto)]
private static extern int RegOpenKeyEx(UIntPtr hKey, string subKey, int ulOptions, int samDesired, out UIntPtr hkResult);

[DllImport("advapi32.dll", SetLastError = true)]
private static extern int RegCloseKey(UIntPtr hKey);

[DllImport("advapi32.dll", SetLastError=true, CharSet = CharSet.Unicode)]
private static extern uint RegDeleteKey(UIntPtr hKey, string subKey);

[DllImport("advapi32.dll", EntryPoint = "RegQueryInfoKey", CallingConvention = CallingConvention.Winapi, SetLastError = true)]
private static extern int RegQueryInfoKey(UIntPtr hkey, out StringBuilder lpClass, ref uint lpcbClass, IntPtr lpReserved,
	out uint lpcSubKeys, out uint lpcbMaxSubKeyLen, out uint lpcbMaxClassLen, out uint lpcValues, out uint lpcbMaxValueNameLen,
	out uint lpcbMaxValueLen, out uint lpcbSecurityDescriptor, ref System.Runtime.InteropServices.ComTypes.FILETIME lpftLastWriteTime);

[DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
internal static extern bool OpenProcessToken(IntPtr h, int acc, ref IntPtr phtok);

[DllImport("kernel32.dll", ExactSpelling = true)]
internal static extern IntPtr GetCurrentProcess();

[DllImport("advapi32.dll", SetLastError = true)]
internal static extern bool LookupPrivilegeValue(string host, string name, ref long pluid);

[DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
internal static extern bool AdjustTokenPrivileges(IntPtr htok, bool disall, ref TokPriv1Luid newst, int len, IntPtr prev, IntPtr relen);

[DllImport("advapi32.dll", CharSet = CharSet.Auto, SetLastError = true)]
private static extern int RegLoadKey(uint hKey, string lpSubKey, string lpFile);

[DllImport("advapi32.dll", CharSet = CharSet.Auto, SetLastError = true)]
private static extern int RegUnLoadKey(uint hKey, string lpSubKey);

[StructLayout(LayoutKind.Sequential, Pack = 1)]
internal struct TokPriv1Luid
{
	public int Count;
	public long Luid;
	public int Attr;
}

public static void DeleteKey(RegistryHive registryHive, string subkey)
{
	UIntPtr hKey = UIntPtr.Zero;

	try
	{
		var hive = new UIntPtr(unchecked((uint)registryHive));
		RegOpenKeyEx(hive, subkey, 0, 0x20019, out hKey);
		RegDeleteKey(hive, subkey);
	}
	finally
	{
		if (hKey != UIntPtr.Zero)
		{
			RegCloseKey(hKey);
		}
	}
}

private static DateTime ToDateTime(System.Runtime.InteropServices.ComTypes.FILETIME ft)
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
	var lastModified = new System.Runtime.InteropServices.ComTypes.FILETIME();
	var lpcbClass = new uint();
	var lpReserved = new IntPtr();
	UIntPtr hKey = UIntPtr.Zero;

	try
	{
		try
		{
			var hive = new UIntPtr(unchecked((uint)registryHive));
			if (RegOpenKeyEx(hive, subKey, 0, (int)RegistryRights.ReadKey, out hKey) != 0)
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

			if (RegQueryInfoKey(hKey, out sb, ref lpcbClass, lpReserved, out lpcbSubKeys, out lpcbMaxKeyLen, out lpcbMaxClassLen,
			out lpcValues, out maxValueName, out maxValueLen, out securityDescriptor, ref lastModified) != 0)
			{
				return null;
			}

			var result = ToDateTime(lastModified);
			return result;
		}
		finally
		{
			if (hKey != UIntPtr.Zero)
			{
				RegCloseKey(hKey);
			}
		}
	}
	catch (Exception)
	{
		return null;
	}
}

internal const int SE_PRIVILEGE_DISABLED = 0x00000000;
internal const int SE_PRIVILEGE_ENABLED = 0x00000002;
internal const int TOKEN_QUERY = 0x00000008;
internal const int TOKEN_ADJUST_PRIVILEGES = 0x00000020;

public enum RegistryHives : uint
{
	HKEY_USERS = 0x80000003,
	HKEY_LOCAL_MACHINE = 0x80000002
}

public static void AddPrivilege(string privilege)
{
	bool retVal;
	TokPriv1Luid tp;
	IntPtr hproc = GetCurrentProcess();
	IntPtr htok = IntPtr.Zero;
	retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, ref htok);
	tp.Count = 1;
	tp.Luid = 0;
	tp.Attr = SE_PRIVILEGE_ENABLED;
	retVal = LookupPrivilegeValue(null, privilege, ref tp.Luid);
	retVal = AdjustTokenPrivileges(htok, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
	///return retVal;
}

public static int LoadHive(RegistryHives hive, string subKey, string filePath)
{
	AddPrivilege("SeRestorePrivilege");
	AddPrivilege("SeBackupPrivilege");

	uint regHive = (uint)hive;
	int result = RegLoadKey(regHive, subKey, filePath);

	return result;
}

public static int UnloadHive(RegistryHives hive, string subKey)
{
	AddPrivilege("SeRestorePrivilege");
	AddPrivilege("SeBackupPrivilege");

	uint regHive = (uint)hive;
	int result = RegUnLoadKey(regHive, subKey);

	return result;
}
"@
	}

	if (-not ("WinAPI.Action" -as [type]))
	{
		Add-Type @Signature
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
			[string]
			$Extension
		)

		# Due to "Set-StrictMode -Version Latest" we have to check everything
		if ((Test-Path -Path "HKLM:\SOFTWARE\Classes\$Extension") -and (Get-ItemProperty -Path "HKLM:\SOFTWARE\Classes\$Extension" -Name "(default)" -ErrorAction Ignore))
		{
			if ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Classes\$Extension" -Name "(default)" -ErrorAction Ignore)."(default)")
			{
				# Save possible ProgIds history with extension
				New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts -Name "$($ProgID)_$($Extension)" -PropertyType DWord -Value 0 -Force
			}
		}

		$Name = "{0}_$($Extension)" -f (Split-Path -Path $ProgId -Leaf)
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts -Name $Name -PropertyType DWord -Value 0 -Force

		if ("$($ProgID)_$($Extension)" -ne $Name)
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts -Name "$($ProgID)_$($Extension)" -PropertyType DWord -Value 0 -Force
		}

		# If ProgId doesn't exist set the specified ProgId for the extensions
		# Due to "Set-StrictMode -Version Latest" we have to check everything
		if (-not (Get-Variable -Name ProgId -ErrorAction Ignore))
		{
			if (-not (Test-Path -Path "HKCU:\Software\Classes\$Extension"))
			{
				New-Item -Path "HKCU:\Software\Classes\$Extension" -Force
			}
			New-ItemProperty -Path "HKCU:\Software\Classes\$Extension" -Name "(default)" -PropertyType String -Value $ProgId -Force
		}

		# Set the specified ProgId in the possible options for the assignment
		if (-not (Test-Path -Path "HKCU:\Software\Classes\$Extension\OpenWithProgids"))
		{
			New-Item -Path "HKCU:\Software\Classes\$Extension\OpenWithProgids" -Force
		}
		New-ItemProperty -Path "HKCU:\Software\Classes\$Extension\OpenWithProgids" -Name $ProgId -PropertyType None -Value ([byte[]]@()) -Force

		# Set the system ProgId to the extension parameters for the File Explorer to the possible options for the assignment, and if absent set the specified ProgId
		# Due to "Set-StrictMode -Version Latest" we have to check everything
		if (Get-Variable -Name OrigProgID -ErrorAction Ignore)
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
		[WinAPI.Action]::DeleteKey([Microsoft.Win32.RegistryHive]::CurrentUser, "Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice")

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

		# Setting a block on changing the UserChoice section
		$OpenSubKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey("Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice", "ReadWriteSubTree", "TakeOwnership")
		if ($OpenSubKey)
		{
			$Acl = [System.Security.AccessControl.RegistrySecurity]::new()
			# Get current user SID
			$UserSID = (Get-CimInstance -ClassName Win32_UserAccount | Where-Object -FilterScript {$_.Name -eq $env:USERNAME}).SID
			$Acl.SetSecurityDescriptorSddlForm("O:$UserSID`G:$UserSID`D:AI(D;;DC;;;$UserSID)")
			$OpenSubKey.SetAccessControl($Acl)
			$OpenSubKey.Close()
		}
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
		# Due to "Set-StrictMode -Version Latest" we have to check everything
		if ((Test-Path -Path "HKLM:\SOFTWARE\Classes\$Extension") -and (Get-ItemProperty -Path "HKLM:\SOFTWARE\Classes\$Extension" -Name "(default)" -ErrorAction Ignore))
		{
			if ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Classes\$Extension" -Name "(default)" -ErrorAction Ignore)."(default)")
			{
				if (-not (Test-Path -Path Registry::HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\FileAssociations\ProgIds))
				{
					New-Item -Path Registry::HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\FileAssociations\ProgIds -Force
				}
				New-ItemProperty -Path Registry::HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\FileAssociations\ProgIds -Name "_$($Extension)" -PropertyType DWord -Value 1 -Force
			}
		}

		# Setting 'NoOpenWith' for all registered the extension ProgIDs
		[psobject]$OpenSubkey = Get-Item -Path "Registry::HKEY_CLASSES_ROOT\$Extension\OpenWithProgids" -ErrorAction Ignore | Select-Object -ExpandProperty Property

		if ($OpenSubkey)
		{
			foreach ($AppxProgID in ($OpenSubkey | Where-Object -FilterScript {$_ -match "AppX"}))
			{
				# If an app is installed
				if (Get-ItemPropertyValue -Path "HKCU:\Software\Classes\$AppxProgID\Shell\open" -Name PackageId)
				{
					# If the specified ProgId is equal to UWP installed ProgId
					if ($ProgId -eq $AppxProgID)
					{
						# Remove association limitations for this UWP apps
						Remove-ItemProperty -Path "HKCU:\Software\Classes\$AppxProgID" -Name NoOpenWith -Force -ErrorAction Ignore
						Remove-ItemProperty -Path "HKCU:\Software\Classes\$AppxProgID" -Name NoStaticDefaultVerb -Force -ErrorAction Ignore
					}
					else
					{
						New-ItemProperty -Path "HKCU:\Software\Classes\$AppxProgID" -Name NoOpenWith -PropertyType String -Value "" -Force
					}
				}
			}
		}

		# Due to "Set-StrictMode -Version Latest" we have to check everything
		if (Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\KindMap -Name $Extension -ErrorAction Ignore)
		{
			$picture = (Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\KindMap -Name $Extension -ErrorAction Ignore).$Extension
		}
		# Due to "Set-StrictMode -Version Latest" we have to check everything
		if ((Test-Path -Path HKLM:\SOFTWARE\Classes\PBrush\CLSID) -and (Get-ItemProperty -Path HKLM:\SOFTWARE\Classes\PBrush\CLSID -Name "(default)" -ErrorAction Ignore))
		{
			$PBrush = (Get-ItemProperty -Path HKLM:\SOFTWARE\Classes\PBrush\CLSID -Name "(default)" -ErrorAction Ignore)."(default)"
		}

		# Due to "Set-StrictMode -Version Latest" we have to check everything
		if (Get-Variable -Name picture -ErrorAction Ignore)
		{
			if (($picture -eq "picture") -and $PBrush)
			{
				New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts -Name "PBrush_$($Extension)" -PropertyType DWord -Value 0 -Force
			}
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
			[string]
			$Extension,

			[Parameter(
				Mandatory = $true,
				Position = 2
			)]
			[string]
			$SubKey
		)

		$Signature = @{
			Namespace        = "WinAPI"
			Name             = "PatentHash"
			Language         = "CSharp"
			MemberDefinition = @"
public static uint[] WordSwap(byte[] a, int sz, byte[] md5)
{
	if (sz < 2 || (sz & 1) == 1)
	{
		throw new ArgumentException(String.Format("Invalid input size: {0}", sz), "sz");
	}

	unchecked
	{
		uint o1 = 0;
		uint o2 = 0;
		int ta = 0;
		int ts = sz;
		int ti = ((sz - 2) >> 1) + 1;

		uint c0 = (BitConverter.ToUInt32(md5, 0) | 1) + 0x69FB0000;
		uint c1 = (BitConverter.ToUInt32(md5, 4) | 1) + 0x13DB0000;

		for (uint i = (uint)ti; i > 0; i--)
		{
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

		if (ts == 1)
		{
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
	if (sz < 2 || (sz & 1) == 1)
	{
		throw new ArgumentException(String.Format("Invalid input size: {0}", sz), "sz");
	}

	unchecked
	{
		uint o1 = 0;
		uint o2 = 0;
		int ta = 0;
		int ts = sz;
		int ti = ((sz - 2) >> 1) + 1;

		uint c0 = BitConverter.ToUInt32(md5, 0) | 1;
		uint c1 = BitConverter.ToUInt32(md5, 4) | 1;

		for (uint i = (uint)ti; i > 0; i--)
		{
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

		if (ts == 1)
		{
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

public static long MakeLong(uint left, uint right)
{
	return (long)left << 32 | (long)right;
}
"@
		}

		if ( -not ("WinAPI.PatentHash" -as [type]))
		{
			Add-Type @Signature
		}

		function Get-KeyLastWriteTime ($SubKey)
		{
			$LastModified = [WinAPI.Action]::GetLastModified([Microsoft.Win32.RegistryHive]::CurrentUser,$SubKey)
			$FileTime = ([DateTime]::New($LastModified.Year, $LastModified.Month, $LastModified.Day, $LastModified.Hour, $LastModified.Minute, 0, $LastModified.Kind)).ToFileTime()

			return [string]::Format("{0:x8}{1:x8}", $FileTime -shr 32, $FileTime -band [uint32]::MaxValue)
		}

		function Get-DataArray
		{
			[OutputType([array])]

			# Secret static string stored in %SystemRoot%\SysWOW64\shell32.dll
			$userExperience        = "User Choice set via Windows User Experience {D18B6DD5-6124-4341-9318-804003BAFA0B}"
			# Get user SID
			$userSID               = (Get-CimInstance -ClassName Win32_UserAccount | Where-Object -FilterScript {$_.Name -eq $env:USERNAME}).SID
			$KeyLastWriteTime      = Get-KeyLastWriteTime -SubKey $SubKey
			$baseInfo              = ("{0}{1}{2}{3}{4}" -f $Extension, $userSID, $ProgId, $KeyLastWriteTime, $userExperience).ToLowerInvariant()
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

			[uint32[]]$A1 = [WinAPI.PatentHash]::WordSwap($A, [int]$ShiftedSize, $MD5)
			[uint32[]]$A2 = [WinAPI.PatentHash]::Reversible($A, [int]$ShiftedSize, $MD5)

			$Ret = [WinAPI.PatentHash]::MakeLong($A1[1] -bxor $A2[1], $A1[0] -bxor $A2[0])

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
		if (-not (Test-Path -Path "HKCU:\Software\Classes\$ProgId\shell\open\command"))
		{
			New-Item -Path "HKCU:\Software\Classes\$ProgId\shell\open\command" -Force
		}
		New-ItemProperty -Path "HKCU:\Software\Classes\$ProgId\shell\open\command" -Name "(Default)" -PropertyType String -Value "`"$ProgramPath`" `"%1`"" -Force

		$FileNameEXE = Split-Path -Path $ProgramPath -Leaf
		if (-not (Test-Path -Path "HKCU:\Software\Classes\Applications\$FileNameEXE\shell\open\command"))
		{
			New-Item -Path "HKCU:\Software\Classes\Applications\$FileNameEXE\shell\open\command" -Force
		}
		New-ItemProperty -Path "HKCU:\Software\Classes\Applications\$FileNameEXE\shell\open\command" -Name "(Default)" -PropertyType String -Value "`"$ProgramPath`" `"%1`"" -Force
	}

	if ($Icon)
	{
		if (-not (Test-Path -Path "HKCU:\Software\Classes\$ProgId\DefaultIcon"))
		{
			New-Item -Path "HKCU:\Software\Classes\$ProgId\DefaultIcon" -Force
		}
		New-ItemProperty -Path "HKCU:\Software\Classes\$ProgId\DefaultIcon" -Name "(default)" -PropertyType String -Value $Icon -Force
	}

	Write-Information -MessageData "" -InformationAction Continue
	# Extract the localized "Please wait..." string from shell32.dll
	Write-Verbose -Message ([WinAPI.GetStr]::GetString(12612)) -Verbose

	# If the file extension specified configure the extension
	Write-ExtensionKeys -ProgId $ProgId -Extension $Extension

	# Setting additional parameters to comply with the requirements before configuring the extension
	Write-AdditionalKeys -ProgId $ProgId -Extension $Extension

	# Refresh the desktop icons
	$Signature = @{
		Namespace        = "WinAPI"
		Name             = "Signature"
		Language         = "CSharp"
		MemberDefinition = @"
[DllImport("shell32.dll", CharSet = CharSet.Auto, SetLastError = false)]
private static extern int SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2);

public static void Refresh()
{
	// Update desktop icons
	SHChangeNotify(0x8000000, 0x1000, IntPtr.Zero, IntPtr.Zero);
}
"@
	}
	if (-not ("WinAPI.Signature" -as [type]))
	{
		Add-Type @Signature
	}

	[WinAPI.Signature]::Refresh()
}

<#
	.SYNOPSIS
	Install the latest Microsoft Visual C++ Redistributable Packages 2015–2022 (x86/x64)

	.EXAMPLE
	InstallVCRedist

	.LINK
	https://docs.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist

	.NOTES
	Machine-wide
#>
function InstallVCRedist
{
	try
	{
		# Check the internet connection
		$Parameters = @{
			Uri              = "https://www.google.com"
			Method           = "Head"
			DisableKeepAlive = $true
			UseBasicParsing  = $true
		}
		if (-not (Invoke-WebRequest @Parameters).StatusDescription)
		{
			return
		}

		if ([System.Version](Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction Ignore).Version -ge [System.Version]"1.17")
		{
			# https://github.com/microsoft/winget-pkgs/tree/master/manifests/m/Microsoft/VCRedist/2015%2B
			winget install --id=Microsoft.VCRedist.2015+.x86 --exact --accept-source-agreements
			winget install --id=Microsoft.VCRedist.2015+.x64 --exact --accept-source-agreements

			# PowerShell 5.1 (7.3 too) interprets 8.3 file name literally, if an environment variable contains a non-latin word
			Get-ChildItem -Path "$env:TEMP\WinGet" -Force -ErrorAction Ignore | Remove-Item -Recurse -Force -ErrorAction Ignore
		}
		else
		{
			$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
			$Parameters = @{
				Uri             = "https://aka.ms/vs/17/release/VC_redist.x86.exe"
				OutFile         = "$DownloadsFolder\VC_redist.x86.exe"
				UseBasicParsing = $true
				Verbose         = $true
			}
			Invoke-WebRequest @Parameters

			Start-Process -FilePath "$DownloadsFolder\VC_redist.x86.exe" -ArgumentList "/install /passive /norestart" -Wait

			$Parameters = @{
				Uri             = "https://aka.ms/vs/17/release/VC_redist.x64.exe"
				OutFile         = "$DownloadsFolder\VC_redist.x64.exe"
				UseBasicParsing = $true
				Verbose         = $true
			}
			Invoke-WebRequest @Parameters

			Start-Process -FilePath "$DownloadsFolder\VC_redist.x64.exe" -ArgumentList "/install /passive /norestart" -Wait

			# PowerShell 5.1 (7.3 too) interprets 8.3 file name literally, if an environment variable contains a non-latin word
			$Paths = @(
				"$DownloadsFolder\VC_redist.x86.exe",
				"$DownloadsFolder\VC_redist.x64.exe",
				"$env:TEMP\dd_vcredist_x86_*.log",
				"$env:TEMP\dd_vcredist_amd64_*.log"
			)
			Get-ChildItem -Path $Paths -Recurse -Force | Remove-Item -Recurse -Force -ErrorAction Ignore
		}
	}
	catch [System.Net.WebException]
	{
		Write-Warning -Message $Localization.NoInternetConnection
		Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue

		Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue
	}
}

<#
	.SYNOPSIS
	Install the latest .NET Desktop Runtime 6, 7 (x86/x64)

	.EXAMPLE
	InstallDotNetRuntimes

	.LINK
	https://dotnet.microsoft.com/en-us/download/dotnet

	.NOTES
	Machine-wide
#>
function InstallDotNetRuntimes
{
	try
	{
		# Check the internet connection
		$Parameters = @{
			Uri              = "https://www.google.com"
			Method           = "Head"
			DisableKeepAlive = $true
			UseBasicParsing  = $true
		}
		if (-not (Invoke-WebRequest @Parameters).StatusDescription)
		{
			return
		}

		if ([System.Version](Get-AppxPackage -Name Microsoft.DesktopAppInstaller -ErrorAction Ignore).Version -ge [System.Version]"1.17")
		{
			# https://github.com/microsoft/winget-pkgs/tree/master/manifests/m/Microsoft/DotNet/DesktopRuntime/6
			# .NET Desktop Runtime 6 x86
			winget install --id=Microsoft.DotNet.DesktopRuntime.6 --architecture x86 --exact --accept-source-agreements
			# .NET Desktop Runtime 6 x64
			winget install --id=Microsoft.DotNet.DesktopRuntime.6 --architecture x64 --exact --accept-source-agreements

			# https://github.com/microsoft/winget-pkgs/tree/master/manifests/m/Microsoft/DotNet/DesktopRuntime/7
			# .NET Desktop Runtime 7 x86
			winget install --id=Microsoft.DotNet.DesktopRuntime.7 --architecture x86 --exact --accept-source-agreements
			# .NET Desktop Runtime 7 x64
			winget install --id=Microsoft.DotNet.DesktopRuntime.7 --architecture x64 --exact --accept-source-agreements

			# PowerShell 5.1 (7.3 too) interprets 8.3 file name literally, if an environment variable contains a non-latin word
			Get-ChildItem -Path "$env:TEMP\WinGet" -Force -ErrorAction Ignore | Remove-Item -Recurse -Force -ErrorAction Ignore
		}
		else
		{
			# Install .NET Desktop Runtime 6
			# https://github.com/dotnet/core/blob/main/release-notes/releases-index.json
			$Parameters = @{
				Uri             = "https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/6.0/releases.json"
				Verbose         = $true
				UseBasicParsing = $true
			}
			$LatestRelease = (Invoke-RestMethod @Parameters)."latest-release"
			$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"

			# .NET Desktop Runtime 6 x86
			$Parameters = @{
				Uri             = "https://dotnetcli.azureedge.net/dotnet/Runtime/$LatestRelease/dotnet-runtime-$LatestRelease-win-x86.exe"
				OutFile         = "$DownloadsFolder\dotnet-runtime-$LatestRelease-win-x86.exe"
				UseBasicParsing = $true
				Verbose         = $true
			}
			Invoke-WebRequest @Parameters

			Start-Process -FilePath "$DownloadsFolder\dotnet-runtime-$LatestRelease-win-x86.exe" -ArgumentList "/install /passive /norestart" -Wait

			# .NET Desktop Runtime 6 x64
			$Parameters = @{
				Uri             = "https://dotnetcli.azureedge.net/dotnet/Runtime/$LatestRelease/dotnet-runtime-$LatestRelease-win-x64.exe"
				OutFile         = "$DownloadsFolder\dotnet-runtime-$LatestRelease-win-x64.exe"
				UseBasicParsing = $true
				Verbose         = $true
			}
			Invoke-WebRequest @Parameters

			Start-Process -FilePath "$DownloadsFolder\dotnet-runtime-$LatestRelease-win-x64.exe" -ArgumentList "/install /passive /norestart" -Wait

			# PowerShell 5.1 (7.3 too) interprets 8.3 file name literally, if an environment variable contains a non-latin word
			$Paths = @(
				"$DownloadsFolder\dotnet-runtime-$LatestRelease-win-x86.exe",
				"$DownloadsFolder\dotnet-runtime-$LatestRelease-win-x64.exe",
				"$env:TEMP\Microsoft_.NET_Runtime*.log"
			)
			Get-ChildItem -Path $Paths -Force -ErrorAction Ignore | Remove-Item -Recurse -Force -ErrorAction Ignore

			# .NET Desktop Runtime 7
			# https://github.com/dotnet/core/blob/main/release-notes/releases-index.json
			$Parameters = @{
				Uri             = "https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/7.0/releases.json"
				Verbose         = $true
				UseBasicParsing = $true
			}
			$LatestRelease = (Invoke-RestMethod @Parameters)."latest-release"
			$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"

			# .NET Desktop Runtime 7 x86
			$Parameters = @{
				Uri             = "https://dotnetcli.azureedge.net/dotnet/Runtime/$LatestRelease/dotnet-runtime-$LatestRelease-win-x86.exe"
				OutFile         = "$DownloadsFolder\dotnet-runtime-$LatestRelease-win-x86.exe"
				UseBasicParsing = $true
				Verbose         = $true
			}
			Invoke-WebRequest @Parameters

			Start-Process -FilePath "$DownloadsFolder\dotnet-runtime-$LatestRelease-win-x86.exe" -ArgumentList "/install /passive /norestart" -Wait

			# .NET Desktop Runtime 7 x64
			$Parameters = @{
				Uri             = "https://dotnetcli.azureedge.net/dotnet/Runtime/$LatestRelease/dotnet-runtime-$LatestRelease-win-x64.exe"
				OutFile         = "$DownloadsFolder\dotnet-runtime-$LatestRelease-win-x64.exe"
				UseBasicParsing = $true
				Verbose         = $true
			}
			Invoke-WebRequest @Parameters

			Start-Process -FilePath "$DownloadsFolder\dotnet-runtime-$LatestRelease-win-x64.exe" -ArgumentList "/install /passive /norestart" -Wait

			# PowerShell 5.1 (7.3 too) interprets 8.3 file name literally, if an environment variable contains a non-latin word
			$Paths = @(
				"$DownloadsFolder\dotnet-runtime-$LatestRelease-win-x86.exe",
				"$DownloadsFolder\dotnet-runtime-$LatestRelease-win-x64.exe",
				"$env:TEMP\Microsoft_.NET_Runtime*.log"
			)
			Get-ChildItem -Path $Paths -Force -ErrorAction Ignore | Remove-Item -Recurse -Force -ErrorAction Ignore
		}
	}
	catch [System.Net.WebException]
	{
		Write-Warning -Message $Localization.NoInternetConnection
		Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue

		Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue
	}
}

<#
	.SYNOPSIS
	Bypass RKN restrictins using antizapret.prostovpn.org proxies

	.PARAMETER Enable
	Enable proxying only blocked sites from the unified registry of Roskomnadzor using antizapret.prostovpn.org servers

	.PARAMETER Disable
	Disable proxying only blocked sites from the unified registry of Roskomnadzor using antizapret.prostovpn.org servers

	.EXAMPLE
	RKNBypass -Enable

	.EXAMPLE
	RKNBypass -Disable

	.LINK
	https://antizapret.prostovpn.org

	.NOTES
	Current user
#>
function RKNBypass
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
			# If current region is Russia
			if (((Get-WinHomeLocation).GeoId -eq "203"))
			{
				New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name AutoConfigURL -PropertyType String -Value "https://antizapret.prostovpn.org/proxy.pac" -Force
			}
		}
		"Disable"
		{
			Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name AutoConfigURL -Force
		}
	}
}

<#
	.SYNOPSIS
	Desktop shortcut creation upon Microsoft Edge update

	.PARAMETER Channels
	List Microsoft Edge channels to prevent desktop shortcut creation upon its' update

	.PARAMETER Disable
	Do not prevent desktop shortcut creation upon Microsoft Edge update

	.EXAMPLE
	PreventEdgeShortcutCreation -Channels Stable, Beta, Dev, Canary

	.EXAMPLE
	PreventEdgeShortcutCreation -Disable

	.NOTES
	Machine-wide
#>
function PreventEdgeShortcutCreation
{
	[CmdletBinding()]
	param
	(
		[Parameter(
			Mandatory = $false,
			ParameterSetName = "Channels"
		)]
		[ValidateSet("Stable", "Beta", "Dev", "Canary")]
		[string[]]
		$Channels,

		[Parameter(
			Mandatory = $false,
			ParameterSetName = "Disable"
		)]
		[switch]
		$Disable
	)

	if (($null -eq (Get-Package -Name "Microsoft Edge Update" -ProviderName Programs -ErrorAction Ignore)) -or ([System.Version](Get-Package -Name "Microsoft Edge Update" -ProviderName Programs -ErrorAction Ignore).Version -lt [System.Version]"1.3.128.0"))
	{
		return
	}

	foreach ($Channel in $Channels)
	{
		switch ($Channel)
		{
			Stable
			{
				if (Get-Package -Name "Microsoft Edge" -ProviderName Programs -ErrorAction Ignore)
				{
					if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate))
					{
						New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Force
					}
					New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Name "CreateDesktopShortcut{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}" -PropertyType DWord -Value 0 -Force
				}
			}
			Beta
			{
				if (Get-Package -Name "Microsoft Edge Beta" -ProviderName Programs -ErrorAction Ignore)
				{
					if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate))
					{
						New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Force
					}
					New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Name "CreateDesktopShortcut{2CD8A007-E189-409D-A2C8-9AF4EF3C72AA}" -PropertyType DWord -Value 0 -Force
				}
			}
			Dev
			{
				if (Get-Package -Name "Microsoft Edge Dev" -ProviderName Programs -ErrorAction Ignore)
				{
					if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate))
					{
						New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Force
					}
					New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Name "CreateDesktopShortcut{0D50BFEC-CD6A-4F9A-964C-C7416E3ACB10}" -PropertyType DWord -Value 0 -Force
				}
			}
			Canary
			{
				if (Get-Package -Name "Microsoft Edge Canary" -ProviderName Programs -ErrorAction Ignore)
				{
					if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate))
					{
						New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Force
					}
					New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Name "CreateDesktopShortcut{65C35B14-6C1D-4122-AC46-7148CC9D6497}" -PropertyType DWord -Value 0 -Force
				}
			}
		}
	}

	if ($Disable)
	{
		$Names = @(
			"CreateDesktopShortcut{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}",
			"CreateDesktopShortcut{2CD8A007-E189-409D-A2C8-9AF4EF3C72AA}",
			"CreateDesktopShortcut{0D50BFEC-CD6A-4F9A-964C-C7416E3ACB10}",
			"CreateDesktopShortcut{65C35B14-6C1D-4122-AC46-7148CC9D6497}"
		)
		Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate -Name $Names -Force -ErrorAction Ignore
	}
}

<#
	.SYNOPSIS
	Internal SATA drives up as removeable media in the taskbar notification area

	.PARAMETER Disable
	Prevent all internal SATA drives from showing up as removable media in the taskbar notification area

	.PARAMETER Default
	Show up all internal SATA drives as removeable media in the taskbar notification area

	.PARAMETER Show
	Show more recommendations on Start

	.EXAMPLE
	SATADrivesRemovableMedia -Disable

	.EXAMPLE
	SATADrivesRemovableMedia -Default

	.NOTES
	Machine-wide
#>
function SATADrivesRemovableMedia
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
			ParameterSetName = "Default"
		)]
		[switch]
		$Default
	)

	switch ($PSCmdlet.ParameterSetName)
	{
		"Disable"
		{
			New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\storahci\Parameters\Device -Name TreatAsInternalPort -Value @(0, 1, 2, 3, 4, 5) -Type MultiString -Force
		}
		"Default"
		{
			Remove-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\storahci\Parameters\Device -Name TreatAsInternalPort -Force -ErrorAction Ignore
		}
	}
}
#endregion System

#region WSL
<#
	.SYNOPSIS
	Windows Subsystem for Linux (WSL)

	.PARAMETER
	Enable Windows Subsystem for Linux (WSL), install the latest WSL Linux kernel version, and a Linux distribution using a pop-up form

	.EXAMPLE
	Install-WSL

	.NOTES
	The "Receive updates for other Microsoft products" setting will be enabled automatically to receive kernel updates

	.NOTES
	Machine-wide
#>
function Install-WSL
{
	[System.Console]::OutputEncoding = [System.Text.Encoding]::Unicode

	$wsl = wsl --list --online
	# Calculate the string number where the "FRIENDLY NAME" header begins to truncate all other unnecessary strings in the beginning
	$LineNumber = ($wsl | Select-String -Pattern "FRIENDLY NAME" -CaseSensitive).LineNumber
	# Remove first strings in output from the first to the $LineNumber
	$Distros = ($wsl).Replace("  ", "").Replace("* ", "")[($LineNumber)..(($wsl).Count)] | ForEach-Object -Process {
		[PSCustomObject]@{
			"Distro" = ($_ -split " ", 2 | Select-Object -Last 1).Trim()
			"Alias"  = ($_ -split " ", 2 | Select-Object -First 1).Trim()
		}
	}

	Add-Type -AssemblyName PresentationCore, PresentationFramework

	#region Variables
	$CommandTag = $null

	#region XAML Markup
	# The section defines the design of the upcoming dialog box
	[xml]$XAML = @"
	<Window
		xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
		xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
		Name="Window"
		Title="WSL"
		MinHeight="460" MinWidth="350"
		SizeToContent="WidthAndHeight" WindowStartupLocation="CenterScreen"
		TextOptions.TextFormattingMode="Display" SnapsToDevicePixels="True"
		FontFamily="Candara" FontSize="16" ShowInTaskbar="True"
		Background="#F1F1F1" Foreground="#262626">
		<Window.Resources>
			<Style TargetType="RadioButton">
				<Setter Property="VerticalAlignment" Value="Center"/>
				<Setter Property="Margin" Value="10"/>
			</Style>
			<Style TargetType="TextBlock">
				<Setter Property="VerticalAlignment" Value="Center"/>
				<Setter Property="Margin" Value="0, 0, 0, 2"/>
			</Style>
			<Style TargetType="Button">
				<Setter Property="Margin" Value="20"/>
				<Setter Property="Padding" Value="10"/>
				<Setter Property="IsEnabled" Value="False"/>
			</Style>
		</Window.Resources>
		<Grid>
			<Grid.RowDefinitions>
				<RowDefinition Height="*"/>
				<RowDefinition Height="Auto"/>
			</Grid.RowDefinitions>
			<StackPanel Name="PanelContainer" Grid.Row="0"/>
			<Button Name="ButtonInstall" Content="Install" Grid.Row="2"/>
		</Grid>
	</Window>
"@
	#endregion XAML Markup

	$Form = [Windows.Markup.XamlReader]::Load((New-Object -TypeName System.Xml.XmlNodeReader -ArgumentList $XAML))
	$XAML.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach-Object -Process {
		Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)
	}

	$ButtonInstall.Content = $Localization.Install
	#endregion Variables

	#region Functions
	function RadioButtonChecked
	{
		$Script:CommandTag = $_.OriginalSource.Tag
		if (-not $ButtonInstall.IsEnabled)
		{
			$ButtonInstall.IsEnabled = $true
		}
	}

	function ButtonInstallClicked
	{
		Write-Warning -Message $Script:CommandTag

		Start-Process -FilePath wsl.exe -ArgumentList "--install --distribution $Script:CommandTag" -Wait

		$Form.Close()

		# Receive updates for other Microsoft products when you update Windows
		(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "")

		# Trigger Windows Update for detecting new updates
		(New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()
	}
	#endregion

	foreach ($Distro in $Distros)
	{
		$Panel = New-Object -TypeName System.Windows.Controls.StackPanel
		$RadioButton = New-Object -TypeName System.Windows.Controls.RadioButton
		$TextBlock = New-Object -TypeName System.Windows.Controls.TextBlock
		$Panel.Orientation = "Horizontal"
		$RadioButton.GroupName = "WslDistro"
		$RadioButton.Tag = $Distro.Alias
		$RadioButton.Add_Checked({RadioButtonChecked})
		$TextBlock.Text = $Distro.Distro
		$Panel.Children.Add($RadioButton) | Out-Null
		$Panel.Children.Add($TextBlock) | Out-Null
		$PanelContainer.Children.Add($Panel) | Out-Null
	}

	$ButtonInstall.Add_Click({ButtonInstallClicked})

	#region Sendkey function
	# Emulate the Backspace key sending to prevent the console window to freeze
	Start-Sleep -Milliseconds 500

	Add-Type -AssemblyName System.Windows.Forms

	$Signature = @{
		Namespace        = "WinAPI"
		Name             = "ForegroundWindow"
		Language         = "CSharp"
		MemberDefinition = @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

[DllImport("user32.dll")]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool SetForegroundWindow(IntPtr hWnd);
"@
	}

	if (-not ("WinAPI.ForegroundWindow" -as [type]))
	{
		Add-Type @Signature
	}

	Get-Process | Where-Object -FilterScript {(($_.ProcessName -eq "powershell") -or ($_.ProcessName -eq "WindowsTerminal")) -and ($_.MainWindowTitle -match "Sophia Script for Windows 11")} | ForEach-Object -Process {
		# Show window, if minimized
		[WinAPI.ForegroundWindow]::ShowWindowAsync($_.MainWindowHandle, 10)

		Start-Sleep -Seconds 1

		# Force move the console window to the foreground
		[WinAPI.ForegroundWindow]::SetForegroundWindow($_.MainWindowHandle)

		Start-Sleep -Seconds 1

		# Emulate the Backspace key sending
		[System.Windows.Forms.SendKeys]::SendWait("{BACKSPACE 1}")
	}
	#endregion Sendkey function

	# Force move the WPF form to the foreground
	$Window.Add_Loaded({$Window.Activate()})
	$Form.ShowDialog() | Out-Null
}
#endregion WSL

#region Start menu
<#
	.SYNOPSIS
	Recently added apps in the Start menu

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
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name HideRecentlyAddedApps -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	App suggestions in the Start menu

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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338388Enabled -PropertyType DWord -Value 0 -Force
		}
		"Show"
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager -Name SubscribedContent-338388Enabled -PropertyType DWord -Value 1 -Force
		}
	}
}

<#
	.SYNOPSIS
	Pin to Start "Control Panel" & "Devices & Printers"

	.PARAMETER ControlPanel
	Pin the "Control Panel" shortcut to Start

	.PARAMETER DevicesPrinters
	Pin the "Devices & Printers" shortcut to Start

	.PARAMETER UnpinAll
	Unpin all the Start tiles

	.EXAMPLE
	PinToStart -Tiles ControlPanel, DevicesPrinters

	.EXAMPLE
	PinToStart -UnpinAll

	.EXAMPLE
	PinToStart -UnpinAll -Tiles ControlPanel, DevicesPrinters

	.EXAMPLE
	PinToStart -UnpinAll -Tiles ControlPanel

	.EXAMPLE
	PinToStart -Tiles ControlPanel -UnpinAll

	.NOTES
	Use commas to separate arguments

	.NOTES
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
		[ValidateSet("ControlPanel", "DevicesPrinters")]
		[string[]]
		$Tiles
	)

	begin
	{
		$Script:StartLayout = "$PSScriptRoot\..\StartLayout.xml"

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
		# Extract the localized "Devices and Printers" string from shell32.dll
		$DevicesPrinters = [WinAPI.GetStr]::GetString(30493)

		# Check if an argument is "DevicesPrinters". The Devices and Printers's AppID attribute can be retrieved only if the shortcut was created
		if (((Get-Command -Name PinToStart).Parametersets.Parameters | Where-Object -FilterScript {$null -eq $_.Attributes.AliasNames}).Attributes.ValidValues | Where-Object -FilterScript {$_ -match "DevicesPrinters"})
		{
			# Create the old-style "Devices and Printers" shortcut in the Start menu
			$Shell                 = New-Object -ComObject Wscript.Shell
			$Shortcut              = $Shell.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start menu\Programs\System Tools\$DevicesPrinters.lnk")
			$Shortcut.TargetPath   = "control"
			$Shortcut.Arguments    = "printers"
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
				Name   = "ControlPanel"
				Size   = "2x2"
				Column = 0
				Row    = 0
				AppID  = "Microsoft.Windows.ControlPanel"
			},
			# "Devices & Printers" hash table
			@{
				# Special name for "Devices & Printers"
				Name   = "DevicesPrinters"
				Size   = "2x2"
				Column = 2
				Row    = 0
				AppID  = $DevicesPrintersAppID
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
		if (-not (Test-Path -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer))
		{
			New-Item -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Force
		}
		New-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Name LockedStartLayout -PropertyType DWord -Value 1 -Force
		New-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Name StartLayoutFile -PropertyType ExpandString -Value $Script:StartLayout -Force

		Start-Sleep -Seconds 3

		# Restart the Start menu
		Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction Ignore

		Start-Sleep -Seconds 3

		# Open the Start menu to load the new layout
		$wshell = New-Object -ComObject WScript.Shell
		$wshell.SendKeys("^{ESC}")

		Start-Sleep -Seconds 3

		# Enable changing the Start menu layout
		Remove-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Name LockedStartLayout -Force -ErrorAction Ignore
		Remove-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Name StartLayoutFile -Force -ErrorAction Ignore

		Remove-Item -Path $Script:StartLayout -Force

		Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction Ignore

		Start-Sleep -Seconds 3

		# Open the Start menu to load the new layout
		$wshell = New-Object -ComObject WScript.Shell
		$wshell.SendKeys("^{ESC}")
	}
}
#endregion Start menu

#region Gaming
<#
	.SYNOPSIS
	Choose an app and set the "High performance" graphics performance for it

	.EXAMPLE
	Set-AppGraphicsPerformance

	.NOTES
	Works only with a dedicated GPU

	.NOTES
	Current user
#>
function Set-AppGraphicsPerformance
{
	if (Get-CimInstance -ClassName Win32_VideoController | Where-Object -FilterScript {($_.AdapterDACType -ne "Internal") -and ($null -ne $_.AdapterDACType)})
	{
		$Title         = $Localization.GraphicsPerformanceTitle
		$Message       = $Localization.GraphicsPerformanceRequest
		# Extract the localized "&Yes" string from shell32.dll
		$Yes           = [WinAPI.GetStr]::GetString(33224)
		# Extract the localized "&No" string from shell32.dll
		$No            = [WinAPI.GetStr]::GetString(33232)
		$Options       = $Yes, $No
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

					# Force move the open file dialog to the foreground
					$Focus = New-Object -TypeName System.Windows.Forms.Form -Property @{TopMost = $true}
					$OpenFileDialog.ShowDialog($Focus)

					if ($OpenFileDialog.FileName)
					{
						if (-not (Test-Path -Path HKCU:\Software\Microsoft\DirectX\UserGpuPreferences))
						{
							New-Item -Path HKCU:\Software\Microsoft\DirectX\UserGpuPreferences -Force
						}
						New-ItemProperty -Path HKCU:\Software\Microsoft\DirectX\UserGpuPreferences -Name $OpenFileDialog.FileName -PropertyType String -Value "GpuPreference=2;" -Force
						Write-Verbose -Message $OpenFileDialog.FileName -Verbose
					}
				}
				"1"
				{
					Write-Information -MessageData "" -InformationAction Continue
					Write-Verbose -Message $Localization.Skipped -Verbose
				}
			}
		}
		until ($Result -eq 1)
	}
}

<#
	.SYNOPSIS
	Hardware-accelerated GPU scheduling

	.PARAMETER Enable
	Enable hardware-accelerated GPU scheduling

	.PARAMETER Disable
	Disable hardware-accelerated GPU scheduling

	.EXAMPLE
	GPUScheduling -Enable

	.EXAMPLE
	GPUScheduling -Disable

	.NOTES
	Only with a dedicated GPU and WDDM verion is 2.7 or higher. Restart needed

	.NOTES
	Current user
#>
function GPUScheduling
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
			if (Get-CimInstance -ClassName CIM_VideoController | Where-Object -FilterScript {($_.AdapterDACType -ne "Internal") -and ($null -ne $_.AdapterDACType)})
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
		"Disable"
		{
			New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name HwSchMode -PropertyType DWord -Value 1 -Force
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

	.NOTES
	Windows Script Host has to be enabled

	.NOTES
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
			# Checking if notifications and Action Center are disabled
			if
			(
				((Get-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer -Name DisableNotificationCenter -ErrorAction Ignore).DisableNotificationCenter -eq 1) -or
				((Get-ItemProperty -Path HKLM:\Software\Policies\Microsoft\Windows\Explorer -Name DisableNotificationCenter -ErrorAction Ignore).DisableNotificationCenter -eq 1)
			)
			{
				return
			}

			# Checking if we're trying to create the task when it was already created as another user
			if (Get-ScheduledTask -TaskPath "\Sophia\" -TaskName "Windows Cleanup" -ErrorAction Ignore)
			{
				# Also we can parse "$env:SystemRoot\System32\Tasks\Sophia\Windows Cleanup" to check if the task was created
				$ScheduleService = New-Object -ComObject Schedule.Service
				$ScheduleService.Connect()
				$ScheduleService.GetFolder("\Sophia").GetTasks(0) | Where-Object -FilterScript {$_.Name -eq "Windows Cleanup"} | Foreach-Object {
					# Get user's SID the task was created as
					$Script:SID = ([xml]$_.xml).Task.Principals.Principal.UserID
				}

				# Convert SID to username
				$TaskUserAccount = (New-Object System.Security.Principal.SecurityIdentifier($SID)).Translate([System.Security.Principal.NTAccount]).Value -split "\\" | Select-Object -Last 1

				if ($TaskUserAccount -ne $env:USERNAME)
				{
					Write-Verbose -Message ($Localization.ScheduledTaskPresented -f $MyInvocation.Line, $TaskUserAccount) -Verbose
					Write-Error -Message ($Localization.ScheduledTaskPresented -f $MyInvocation.Line, $TaskUserAccount) -ErrorAction SilentlyContinue
					Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue

					return
				}
			}

			# Remove all old tasks
			# We have to use -ErrorAction Ignore in both cases, unless we get an error
			Get-ScheduledTask -TaskPath "\Sophia Script\", "\SophiApp\" -ErrorAction Ignore | ForEach-Object -Process {
				Unregister-ScheduledTask -TaskName $_.TaskName -Confirm:$false -ErrorAction Ignore
			}

			# Remove folders in Task Scheduler. We cannot remove all old folders explicitly and not get errors if any of folders do not exist
			$ScheduleService = New-Object -ComObject Schedule.Service
			$ScheduleService.Connect()
			if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Sophia Script")
			{
				$ScheduleService.GetFolder("\").DeleteFolder("Sophia Script", $null)
			}
			if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\SophiApp")
			{
				$ScheduleService.GetFolder("\").DeleteFolder("SophiApp", $null)
			}

			Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches | ForEach-Object -Process {
				Remove-ItemProperty -Path $_.PsPath -Name StateFlags1337 -Force -ErrorAction Ignore
			}

			$VolumeCaches = @(
				"Delivery Optimization Files",
				"BranchCache",
				"Device Driver Packages",
				"Language Pack",
				"Previous Installations",
				"Setup Log Files",
				"System error memory dump files",
				"System error minidump files",
				"Temporary Setup Files",
				"Update Cleanup",
				"Windows Defender",
				"Windows ESD installation files",
				"Windows Upgrade Log Files"
			)
			foreach ($VolumeCache in $VolumeCaches)
			{
				if (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$VolumeCache"))
				{
					New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$VolumeCache" -Force
				}
				New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\$VolumeCache" -Name StateFlags1337 -PropertyType DWord -Value 2 -Force
			}

			# Persist Sophia notifications to prevent to immediately disappear from Action Center
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Sophia))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Sophia -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Sophia -Name ShowInActionCenter -PropertyType DWord -Value 1 -Force

			if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia))
			{
				New-Item -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia -Force
			}
			# Register app
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia -Name DisplayName -Value Sophia -PropertyType String -Force
			# Determines whether the app can be seen in Settings where the user can turn notifications on or off
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia -Name ShowInSettings -Value 0 -PropertyType DWord -Force

			# Register the "WindowsCleanup" protocol to be able to run the scheduled task by clicking the "Run" button in a toast
			if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\WindowsCleanup\shell\open\command))
			{
				New-Item -Path Registry::HKEY_CLASSES_ROOT\WindowsCleanup\shell\open\command -Force
			}
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\WindowsCleanup -Name "(default)" -PropertyType String -Value "URL:WindowsCleanup" -Force
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\WindowsCleanup -Name "URL Protocol" -PropertyType String -Value "" -Force
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\WindowsCleanup -Name EditFlags -PropertyType DWord -Value 2162688 -Force

			# Start the "Windows Cleanup" task if the "Run" button clicked
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\WindowsCleanup\shell\open\command -Name "(default)" -PropertyType String -Value 'powershell.exe -Command "& {Start-ScheduledTask -TaskPath ''\Sophia\'' -TaskName ''Windows Cleanup''}"' -Force

			$CleanupTask = @"
Get-Process -Name cleanmgr, Dism, DismHost | Stop-Process -Force

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

while (`$true)
{
	[int]`$CurrentMainWindowHandle = (Get-Process -Name cleanmgr | Where-Object -FilterScript {`$_.PriorityClass -eq """BelowNormal"""}).MainWindowHandle
	if (`$SourceMainWindowHandle -ne `$CurrentMainWindowHandle)
	{
		`$ShowWindowAsync = @{
			Namespace = """WinAPI"""
			Name = """Win32ShowWindowAsync"""
			Language = """CSharp"""
			MemberDefinition = @"""
[DllImport("""user32.dll""")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
"""@
		}

		if (-not ("""WinAPI.Win32ShowWindowAsync""" -as [type]))
		{
			Add-Type @ShowWindowAsync
		}
		`$MainWindowHandle = (Get-Process -Name cleanmgr | Where-Object -FilterScript {`$_.PriorityClass -eq """BelowNormal"""}).MainWindowHandle
		[WinAPI.Win32ShowWindowAsync]::ShowWindowAsync(`$MainWindowHandle, 2)

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
			$Action     = New-ScheduledTaskAction -Execute powershell.exe -Argument "-WindowStyle Hidden -Command $CleanupTask"
			$Settings   = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
			$Principal  = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
			$Parameters = @{
				TaskName    = "Windows Cleanup"
				TaskPath    = "Sophia"
				Principal   = $Principal
				Action      = $Action
				Description = $Localization.CleanupTaskDescription
				Settings    = $Settings
			}
			Register-ScheduledTask @Parameters -Force

			# We have to call PowerShell script via another VBS script silently because VBS has appropriate feature to suppress console appearing (none of other workarounds work)
			# powershell.exe process wakes up system anyway even from turned on Focus Assist mode (not a notification toast)
			# https://github.com/DCourtel/Windows_10_Focus_Assist/blob/master/FocusAssistLibrary/FocusAssistLib.cs
			# https://redplait.blogspot.com/2018/07/wnf-ids-from-perfntcdll-adk-version.html
			$ToastNotification = @"
# https://github.com/farag2/Sophia-Script-for-Windows
# https://t.me/sophia_chat

# Get Focus Assist status
# https://github.com/DCourtel/Windows_10_Focus_Assist/blob/master/FocusAssistLibrary/FocusAssistLib.cs
# https://redplait.blogspot.com/2018/07/wnf-ids-from-perfntcdll-adk-version.html

`$Focus = @{
	Namespace        = "WinAPI"
	Name             = "Focus"
	Language         = "CSharp"
	MemberDefinition = @""
[DllImport("NtDll.dll", SetLastError = true)]
private static extern uint NtQueryWnfStateData(IntPtr pStateName, IntPtr pTypeId, IntPtr pExplicitScope, out uint nChangeStamp, out IntPtr pBuffer, ref uint nBufferSize);

[StructLayout(LayoutKind.Sequential)]
public struct WNF_TYPE_ID
{
	public Guid TypeId;
}

[StructLayout(LayoutKind.Sequential)]
public struct WNF_STATE_NAME
{
	[MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
	public uint[] Data;

	public WNF_STATE_NAME(uint Data1, uint Data2) : this()
	{
		uint[] newData = new uint[2];
		newData[0] = Data1;
		newData[1] = Data2;
		Data = newData;
	}
}

public enum FocusAssistState
{
	NOT_SUPPORTED = -2,
	FAILED = -1,
	OFF = 0,
	PRIORITY_ONLY = 1,
	ALARMS_ONLY = 2
};

// Returns the state of Focus Assist if available on this computer
public static FocusAssistState GetFocusAssistState()
{
	try
	{
		WNF_STATE_NAME WNF_SHEL_QUIETHOURS_ACTIVE_PROFILE_CHANGED = new WNF_STATE_NAME(0xA3BF1C75, 0xD83063E);
		uint nBufferSize = (uint)Marshal.SizeOf(typeof(IntPtr));
		IntPtr pStateName = Marshal.AllocHGlobal(Marshal.SizeOf(typeof(WNF_STATE_NAME)));
		Marshal.StructureToPtr(WNF_SHEL_QUIETHOURS_ACTIVE_PROFILE_CHANGED, pStateName, false);

		uint nChangeStamp = 0;
		IntPtr pBuffer = IntPtr.Zero;
		bool success = NtQueryWnfStateData(pStateName, IntPtr.Zero, IntPtr.Zero, out nChangeStamp, out pBuffer, ref nBufferSize) == 0;
		Marshal.FreeHGlobal(pStateName);

		if (success)
		{
			return (FocusAssistState)pBuffer;
		}
	}
	catch {}

	return FocusAssistState.FAILED;
}
""@
}

if (-not ("WinAPI.Focus" -as [type]))
{
	Add-Type @Focus
}

while ([WinAPI.Focus]::GetFocusAssistState() -ne "OFF")
{
	Start-Sleep -Seconds 600
}

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

[xml]`$ToastTemplate = @""
<toast duration="Long">
	<visual>
		<binding template="ToastGeneric">
			<text>$($Localization.CleanupTaskNotificationTitle)</text>
			<group>
				<subgroup>
					<text hint-style="body" hint-wrap="true">$($Localization.CleanupTaskNotificationEvent)</text>
				</subgroup>
			</group>
		</binding>
	</visual>
	<audio src="ms-winsoundevent:notification.default" />
	<actions>
		<action content="$([WinAPI.GetStr]::GetString(12850))" arguments="WindowsCleanup:" activationType="protocol"/>
		<action content="" arguments="dismiss" activationType="system"/>
	</actions>
</toast>
""@

`$ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::New()
`$ToastXml.LoadXml(`$ToastTemplate.OuterXml)

`$ToastMessage = [Windows.UI.Notifications.ToastNotification]::New(`$ToastXML)
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Sophia").Show(`$ToastMessage)
"@

			# Save script to be able to call them from VBS file
			if (-not (Test-Path -Path $env:SystemRoot\System32\Tasks\Sophia))
			{
				New-Item -Path $env:SystemRoot\System32\Tasks\Sophia -ItemType Directory -Force
			}
			Set-Content -Path "$env:SystemRoot\System32\Tasks\Sophia\Windows_Cleanup_Notification.ps1" -Value $ToastNotification -Encoding Default -Force
			# Replace here-string double quotes with single ones
			(Get-Content -Path "$env:SystemRoot\System32\Tasks\Sophia\Windows_Cleanup_Notification.ps1" -Encoding Default).Replace('@""', '@"').Replace('""@', '"@') | Set-Content -Path "$env:SystemRoot\System32\Tasks\Sophia\Windows_Cleanup_Notification.ps1" -Encoding Default -Force

			# Create vbs script that will help us calling PS1 script silently, without interrupting system from Focus Assist mode turned on, when a powershell.exe console pops up
			$ToastNotification = @"
' https://github.com/farag2/Sophia-Script-for-Windows
' https://t.me/sophia_chat

CreateObject("Wscript.Shell").Run "powershell.exe -ExecutionPolicy Bypass -NoProfile -NoLogo -WindowStyle Hidden -File %SystemRoot%\System32\Tasks\Sophia\Windows_Cleanup_Notification.ps1", 0
"@
			Set-Content -Path "$env:SystemRoot\System32\Tasks\Sophia\Windows_Cleanup_Notification.vbs" -Value $ToastNotification -Encoding Default -Force

			# Create the "Windows Cleanup Notification" task
			$Action    = New-ScheduledTaskAction -Execute wscript.exe -Argument "$env:SystemRoot\System32\Tasks\Sophia\Windows_Cleanup_Notification.vbs"
			$Settings  = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
			$Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
			$Trigger   = New-ScheduledTaskTrigger -Daily -DaysInterval 30 -At 9pm
			$Parameters = @{
				TaskName    = "Windows Cleanup Notification"
				TaskPath    = "Sophia"
				Action      = $Action
				Settings    = $Settings
				Principal   = $Principal
				Trigger     = $Trigger
				Description = $Localization.CleanupNotificationTaskDescription
			}
			Register-ScheduledTask @Parameters -Force

			$Script:ScheduledTasks = $true
		}
		"Delete"
		{
			# Remove files first unless we cannot remove folder if there's no more tasks there
			Remove-Item -Path "$env:SystemRoot\System32\Tasks\Sophia\Windows_Cleanup_Notification.vbs", "$env:SystemRoot\System32\Tasks\Sophia\Windows_Cleanup_Notification.ps1" -Force -ErrorAction Ignore

			# Remove all old tasks
			# We have to use -ErrorAction Ignore in both cases, unless we get an error
			Get-ScheduledTask -TaskPath "\Sophia Script\", "\SophiApp\" -ErrorAction Ignore | ForEach-Object -Process {
				Unregister-ScheduledTask -TaskName $_.TaskName -Confirm:$false -ErrorAction Ignore
			}

			# Remove folder in Task Scheduler if there is no tasks left there. We cannot remove all old folders explicitly and not get errors if any of folders do not exist
			$ScheduleService = New-Object -ComObject Schedule.Service
			$ScheduleService.Connect()
			if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Sophia Script")
			{
				$ScheduleService.GetFolder("\").DeleteFolder("Sophia Script", $null)
			}
			if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\SophiApp")
			{
				$ScheduleService.GetFolder("\").DeleteFolder("SophiApp", $null)
			}

			# Removing current task
			Unregister-ScheduledTask -TaskPath "\Sophia\" -TaskName "Windows Cleanup", "Windows Cleanup Notification" -Confirm:$false -ErrorAction Ignore

			Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches | ForEach-Object -Process {
				Remove-ItemProperty -Path $_.PsPath -Name StateFlags1337 -Force -ErrorAction Ignore
			}
			Remove-Item -Path Registry::HKEY_CLASSES_ROOT\WindowsCleanup -Recurse -Force -ErrorAction Ignore

			# Remove folder in Task Scheduler if there is no tasks left there
			if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Sophia")
			{
				if (($ScheduleService.GetFolder("Sophia").GetTasks(0) | Select-Object -Property Name).Name.Count -eq 0)
				{
					$ScheduleService.GetFolder("\").DeleteFolder("Sophia", $null)
				}
			}
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
	The task will wait until the Windows Updates service finishes running. The task runs every 90 days

	.NOTES
	Windows Script Host has to be enabled

	.NOTES
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
			# Checking if we're trying to create the task when it was already created as another user
			if (Get-ScheduledTask -TaskPath "\Sophia\" -TaskName SoftwareDistribution -ErrorAction Ignore)
			{
				# Also we can parse $env:SystemRoot\System32\Tasks\Sophia\SoftwareDistribution to check if the task was created
				$ScheduleService = New-Object -ComObject Schedule.Service
				$ScheduleService.Connect()
				$ScheduleService.GetFolder("\Sophia").GetTasks(0) | Where-Object -FilterScript {$_.Name -eq "SoftwareDistribution"} | Foreach-Object {
					# Get user's SID the task was created as
					$Script:SID = ([xml]$_.xml).Task.Principals.Principal.UserID
				}
				# Convert SID to username
				$TaskUserAccount = (New-Object System.Security.Principal.SecurityIdentifier($SID)).Translate([System.Security.Principal.NTAccount]).Value -split "\\" | Select-Object -Last 1

				if ($TaskUserAccount -ne $env:USERNAME)
				{
					Write-Verbose -Message ($Localization.ScheduledTaskPresented -f $MyInvocation.Line, $TaskUserAccount) -Verbose
					Write-Error -Message ($Localization.ScheduledTaskPresented -f $MyInvocation.Line, $TaskUserAccount) -ErrorAction SilentlyContinue
					Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue

					return
				}
			}

			# Remove all old tasks
			# We have to use -ErrorAction Ignore in both cases, unless we get an error
			Get-ScheduledTask -TaskPath "\Sophia Script\", "\SophiApp\" -ErrorAction Ignore | ForEach-Object -Process {
				Unregister-ScheduledTask -TaskName $_.TaskName -Confirm:$false -ErrorAction Ignore
			}

			# Remove folders in Task Scheduler. We cannot remove all old folders explicitly and not get errors if any of folders do not exist
			$ScheduleService = New-Object -ComObject Schedule.Service
			$ScheduleService.Connect()
			if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Sophia Script")
			{
				$ScheduleService.GetFolder("\").DeleteFolder("Sophia Script", $null)
			}
			if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\SophiApp")
			{
				$ScheduleService.GetFolder("\").DeleteFolder("SophiApp", $null)
			}

			# Persist Sophia notifications to prevent to immediately disappear from Action Center
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Sophia))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Sophia -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Sophia -Name ShowInActionCenter -PropertyType DWord -Value 1 -Force

			if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia))
			{
				New-Item -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia -Force
			}
			# Register app
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia -Name DisplayName -Value Sophia -PropertyType String -Force
			# Determines whether the app can be seen in Settings where the user can turn notifications on or off
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia -Name ShowInSettings -Value 0 -PropertyType DWord -Force

			# We have to call PowerShell script via another VBS script silently because VBS has appropriate feature to suppress console appearing (none of other workarounds work)
			# powershell.exe process wakes up system anyway even from turned on Focus Assist mode (not a notification toast)
			# https://github.com/DCourtel/Windows_10_Focus_Assist/blob/master/FocusAssistLibrary/FocusAssistLib.cs
			# https://redplait.blogspot.com/2018/07/wnf-ids-from-perfntcdll-adk-version.html
			$SoftwareDistributionTask = @"
# https://github.com/farag2/Sophia-Script-for-Windows
# https://t.me/sophia_chat

# Get Focus Assist status
# https://github.com/DCourtel/Windows_10_Focus_Assist/blob/master/FocusAssistLibrary/FocusAssistLib.cs
# https://redplait.blogspot.com/2018/07/wnf-ids-from-perfntcdll-adk-version.html

`$Focus = @{
	Namespace        = "WinAPI"
	Name             = "Focus"
	Language         = "CSharp"
	MemberDefinition = @""
[DllImport("NtDll.dll", SetLastError = true)]
private static extern uint NtQueryWnfStateData(IntPtr pStateName, IntPtr pTypeId, IntPtr pExplicitScope, out uint nChangeStamp, out IntPtr pBuffer, ref uint nBufferSize);

[StructLayout(LayoutKind.Sequential)]
public struct WNF_TYPE_ID
{
	public Guid TypeId;
}

[StructLayout(LayoutKind.Sequential)]
public struct WNF_STATE_NAME
{
	[MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
	public uint[] Data;

	public WNF_STATE_NAME(uint Data1, uint Data2) : this()
	{
		uint[] newData = new uint[2];
		newData[0] = Data1;
		newData[1] = Data2;
		Data = newData;
	}
}

public enum FocusAssistState
{
	NOT_SUPPORTED = -2,
	FAILED = -1,
	OFF = 0,
	PRIORITY_ONLY = 1,
	ALARMS_ONLY = 2
};

// Returns the state of Focus Assist if available on this computer
public static FocusAssistState GetFocusAssistState()
{
	try
	{
		WNF_STATE_NAME WNF_SHEL_QUIETHOURS_ACTIVE_PROFILE_CHANGED = new WNF_STATE_NAME(0xA3BF1C75, 0xD83063E);
		uint nBufferSize = (uint)Marshal.SizeOf(typeof(IntPtr));
		IntPtr pStateName = Marshal.AllocHGlobal(Marshal.SizeOf(typeof(WNF_STATE_NAME)));
		Marshal.StructureToPtr(WNF_SHEL_QUIETHOURS_ACTIVE_PROFILE_CHANGED, pStateName, false);

		uint nChangeStamp = 0;
		IntPtr pBuffer = IntPtr.Zero;
		bool success = NtQueryWnfStateData(pStateName, IntPtr.Zero, IntPtr.Zero, out nChangeStamp, out pBuffer, ref nBufferSize) == 0;
		Marshal.FreeHGlobal(pStateName);

		if (success)
		{
			return (FocusAssistState)pBuffer;
		}
	}
	catch {}

	return FocusAssistState.FAILED;
}
""@
}

if (-not ("WinAPI.Focus" -as [type]))
{
	Add-Type @Focus
}

# Wait until it will be "OFF" (0)
while ([WinAPI.Focus]::GetFocusAssistState() -ne "OFF")
{
	Start-Sleep -Seconds 600
}

# Run the task
(Get-Service -Name wuauserv).WaitForStatus('Stopped', '01:00:00')
Get-ChildItem -Path `$env:SystemRoot\SoftwareDistribution\Download -Recurse -Force | Remove-Item -Recurse -Force

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

[xml]`$ToastTemplate = @""
<toast duration="Long">
	<visual>
		<binding template="ToastGeneric">
			<text>$($Localization.SoftwareDistributionTaskNotificationEvent)</text>
		</binding>
	</visual>
	<audio src="ms-winsoundevent:notification.default" />
</toast>
""@

`$ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::New()
`$ToastXml.LoadXml(`$ToastTemplate.OuterXml)

`$ToastMessage = [Windows.UI.Notifications.ToastNotification]::New(`$ToastXML)
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Sophia").Show(`$ToastMessage)
"@
			# Save script to be able to call them from VBS file
			if (-not (Test-Path -Path $env:SystemRoot\System32\Tasks\Sophia))
			{
				New-Item -Path $env:SystemRoot\System32\Tasks\Sophia -ItemType Directory -Force
			}
			Set-Content -Path "$env:SystemRoot\System32\Tasks\Sophia\SoftwareDistributionTask.ps1" -Value $SoftwareDistributionTask -Encoding Default -Force
			# Replace here-string double quotes with single ones
			(Get-Content -Path "$env:SystemRoot\System32\Tasks\Sophia\SoftwareDistributionTask.ps1" -Encoding Default).Replace('@""', '@"').Replace('""@', '"@') | Set-Content -Path "$env:SystemRoot\System32\Tasks\Sophia\SoftwareDistributionTask.ps1" -Encoding Default -Force

			# Create vbs script that will help us calling PS1 script silently, without interrupting system from Focus Assist mode turned on, when a powershell.exe console pops up
			$SoftwareDistributionTask = @"
' https://github.com/farag2/Sophia-Script-for-Windows
' https://t.me/sophia_chat

CreateObject("Wscript.Shell").Run "powershell.exe -ExecutionPolicy Bypass -NoProfile -NoLogo -WindowStyle Hidden -File %SystemRoot%\System32\Tasks\Sophia\SoftwareDistributionTask.ps1", 0
"@
			Set-Content -Path "$env:SystemRoot\System32\Tasks\Sophia\SoftwareDistributionTask.vbs" -Value $SoftwareDistributionTask -Encoding Default -Force

			# Create the "SoftwareDistribution" task
			$Action    = New-ScheduledTaskAction -Execute wscript.exe -Argument "$env:SystemRoot\System32\Tasks\Sophia\SoftwareDistributionTask.vbs"
			$Settings  = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
			$Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
			$Trigger   = New-ScheduledTaskTrigger -Daily -DaysInterval 90 -At 9pm
			$Parameters = @{
				TaskName    = "SoftwareDistribution"
				TaskPath    = "Sophia"
				Action      = $Action
				Settings    = $Settings
				Principal   = $Principal
				Trigger     = $Trigger
				Description = $Localization.FolderTaskDescription -f "%SystemRoot%\SoftwareDistribution\Download"
			}
			Register-ScheduledTask @Parameters -Force

			$Script:ScheduledTasks = $true
		}
		"Delete"
		{
			# Remove files first unless we cannot remove folder if there's no more tasks there
			Remove-Item -Path "$env:SystemRoot\System32\Tasks\Sophia\SoftwareDistributionTask.vbs", "$env:SystemRoot\System32\Tasks\Sophia\SoftwareDistributionTask.ps1" -Force -ErrorAction Ignore

			# Remove all old tasks
			# We have to use -ErrorAction Ignore in both cases, unless we get an error
			Get-ScheduledTask -TaskPath "\Sophia Script\", "\SophiApp\" -ErrorAction Ignore | ForEach-Object -Process {
				Unregister-ScheduledTask -TaskName $_.TaskName -Confirm:$false -ErrorAction Ignore
			}

			# Remove folder in Task Scheduler if there is no tasks left there. We cannot remove all old folders explicitly and not get errors if any of folders do not exist
			$ScheduleService = New-Object -ComObject Schedule.Service
			$ScheduleService.Connect()
			if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Sophia Script")
			{
				$ScheduleService.GetFolder("\").DeleteFolder("Sophia Script", $null)
			}
			if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\SophiApp")
			{
				$ScheduleService.GetFolder("\").DeleteFolder("SophiApp", $null)
			}

			# Removing current task
			Unregister-ScheduledTask -TaskPath "\Sophia\" -TaskName SoftwareDistribution -Confirm:$false -ErrorAction Ignore

			# Remove folder in Task Scheduler if there is no tasks left there
			if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Sophia")
			{
				if (($ScheduleService.GetFolder("Sophia").GetTasks(0) | Select-Object -Property Name).Name.Count -eq 0)
				{
					$ScheduleService.GetFolder("\").DeleteFolder("Sophia", $null)
				}
			}
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
	Only files older than one day will be deleted. The task runs every 60 days

	.NOTES
	Windows Script Host has to be enabled

	.NOTES
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
			# Checking if we're trying to create the task when it was already created as another user
			if (Get-ScheduledTask -TaskPath "\Sophia\" -TaskName Temp -ErrorAction Ignore)
			{
				# Also we can parse $env:SystemRoot\System32\Tasks\Sophia\Temp to check if the task was created
				$ScheduleService = New-Object -ComObject Schedule.Service
				$ScheduleService.Connect()
				$ScheduleService.GetFolder("\Sophia").GetTasks(0) | Where-Object -FilterScript {$_.Name -eq "Temp"} | Foreach-Object {
					# Get user's SID the task was created as
					$Script:SID = ([xml]$_.xml).Task.Principals.Principal.UserID
				}

				# Convert SID to username
				$TaskUserAccount = (New-Object System.Security.Principal.SecurityIdentifier($SID)).Translate([System.Security.Principal.NTAccount]).Value -split "\\" | Select-Object -Last 1

				if ($TaskUserAccount -ne $env:USERNAME)
				{
					Write-Verbose -Message ($Localization.ScheduledTaskPresented -f $MyInvocation.Line, $TaskUserAccount) -Verbose
					Write-Error -Message ($Localization.ScheduledTaskPresented -f $MyInvocation.Line, $TaskUserAccount) -ErrorAction SilentlyContinue
					Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue

					return
				}
			}

			# Remove all old tasks
			# We have to use -ErrorAction Ignore in both cases, unless we get an error
			Get-ScheduledTask -TaskPath "\Sophia Script\", "\SophiApp\" -ErrorAction Ignore | ForEach-Object -Process {
				Unregister-ScheduledTask -TaskName $_.TaskName -Confirm:$false -ErrorAction Ignore
			}

			# Remove folders in Task Scheduler. We cannot remove all old folders explicitly and not get errors if any of folders do not exist
			$ScheduleService = New-Object -ComObject Schedule.Service
			$ScheduleService.Connect()
			if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Sophia Script")
			{
				$ScheduleService.GetFolder("\").DeleteFolder("Sophia Script", $null)
			}
			if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\SophiApp")
			{
				$ScheduleService.GetFolder("\").DeleteFolder("SophiApp", $null)
			}

			# Persist Sophia notifications to prevent to immediately disappear from Action Center
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Sophia))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Sophia -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Sophia -Name ShowInActionCenter -PropertyType DWord -Value 1 -Force

			if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia))
			{
				New-Item -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia -Force
			}
			# Register app
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia -Name DisplayName -Value Sophia -PropertyType String -Force
			# Determines whether the app can be seen in Settings where the user can turn notifications on or off
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia -Name ShowInSettings -Value 0 -PropertyType DWord -Force

			# We have to call PowerShell script via another VBS script silently because VBS has appropriate feature to suppress console appearing (none of other workarounds work)
			# powershell.exe process wakes up system anyway even from turned on Focus Assist mode (not a notification toast)
			$TempTask = @"
# https://github.com/farag2/Sophia-Script-for-Windows
# https://t.me/sophia_chat

# Get Focus Assist status
# https://github.com/DCourtel/Windows_10_Focus_Assist/blob/master/FocusAssistLibrary/FocusAssistLib.cs
# https://redplait.blogspot.com/2018/07/wnf-ids-from-perfntcdll-adk-version.html

`$Focus = @{
	Namespace        = "WinAPI"
	Name             = "Focus"
	Language         = "CSharp"
	MemberDefinition = @""
[DllImport("NtDll.dll", SetLastError = true)]
private static extern uint NtQueryWnfStateData(IntPtr pStateName, IntPtr pTypeId, IntPtr pExplicitScope, out uint nChangeStamp, out IntPtr pBuffer, ref uint nBufferSize);

[StructLayout(LayoutKind.Sequential)]
public struct WNF_TYPE_ID
{
	public Guid TypeId;
}

[StructLayout(LayoutKind.Sequential)]
public struct WNF_STATE_NAME
{
	[MarshalAs(UnmanagedType.ByValArray, SizeConst = 2)]
	public uint[] Data;

	public WNF_STATE_NAME(uint Data1, uint Data2) : this()
	{
		uint[] newData = new uint[2];
		newData[0] = Data1;
		newData[1] = Data2;
		Data = newData;
	}
}

public enum FocusAssistState
{
	NOT_SUPPORTED = -2,
	FAILED = -1,
	OFF = 0,
	PRIORITY_ONLY = 1,
	ALARMS_ONLY = 2
};

// Returns the state of Focus Assist if available on this computer
public static FocusAssistState GetFocusAssistState()
{
	try
	{
		WNF_STATE_NAME WNF_SHEL_QUIETHOURS_ACTIVE_PROFILE_CHANGED = new WNF_STATE_NAME(0xA3BF1C75, 0xD83063E);
		uint nBufferSize = (uint)Marshal.SizeOf(typeof(IntPtr));
		IntPtr pStateName = Marshal.AllocHGlobal(Marshal.SizeOf(typeof(WNF_STATE_NAME)));
		Marshal.StructureToPtr(WNF_SHEL_QUIETHOURS_ACTIVE_PROFILE_CHANGED, pStateName, false);

		uint nChangeStamp = 0;
		IntPtr pBuffer = IntPtr.Zero;
		bool success = NtQueryWnfStateData(pStateName, IntPtr.Zero, IntPtr.Zero, out nChangeStamp, out pBuffer, ref nBufferSize) == 0;
		Marshal.FreeHGlobal(pStateName);

		if (success)
		{
			return (FocusAssistState)pBuffer;
		}
	}
	catch {}

	return FocusAssistState.FAILED;
}
""@
}

if (-not ("WinAPI.Focus" -as [type]))
{
	Add-Type @Focus
}

# Wait until it will be "OFF" (0)
while ([WinAPI.Focus]::GetFocusAssistState() -ne "OFF")
{
	Start-Sleep -Seconds 600
}

# Run the task
Get-ChildItem -Path `$env:TEMP -Recurse -Force | Where-Object -FilterScript {`$_.CreationTime -lt (Get-Date).AddDays(-1)} | Remove-Item -Recurse -Force

[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

[xml]`$ToastTemplate = @""
<toast duration="Long">
	<visual>
		<binding template="ToastGeneric">
			<text>$($Localization.TempTaskNotificationEvent)</text>
		</binding>
	</visual>
	<audio src="ms-winsoundevent:notification.default" />
</toast>
""@

`$ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::New()
`$ToastXml.LoadXml(`$ToastTemplate.OuterXml)

`$ToastMessage = [Windows.UI.Notifications.ToastNotification]::New(`$ToastXML)
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Sophia").Show(`$ToastMessage)
"@
			# Save script to be able to call them from VBS file
			if (-not (Test-Path -Path $env:SystemRoot\System32\Tasks\Sophia))
			{
				New-Item -Path $env:SystemRoot\System32\Tasks\Sophia -ItemType Directory -Force
			}
			Set-Content -Path "$env:SystemRoot\System32\Tasks\Sophia\TempTask.ps1" -Value $TempTask -Encoding Default -Force
			# Replace here-string double quotes with single ones
			(Get-Content -Path "$env:SystemRoot\System32\Tasks\Sophia\TempTask.ps1" -Encoding Default).Replace('@""', '@"').Replace('""@', '"@') | Set-Content -Path "$env:SystemRoot\System32\Tasks\Sophia\TempTask.ps1" -Encoding Default -Force

			# Create vbs script that will help us calling PS1 script silently, without interrupting system from Focus Assist mode turned on, when a powershell.exe console pops up
			$TempTask = @"
' https://github.com/farag2/Sophia-Script-for-Windows
' https://t.me/sophia_chat

CreateObject("Wscript.Shell").Run "powershell.exe -ExecutionPolicy Bypass -NoProfile -NoLogo -WindowStyle Hidden -File %SystemRoot%\System32\Tasks\Sophia\TempTask.ps1", 0
"@
			Set-Content -Path "$env:SystemRoot\System32\Tasks\Sophia\TempTask.vbs" -Value $TempTask -Encoding Default -Force

			# Create the "Temp" task
			$Action    = New-ScheduledTaskAction -Execute wscript.exe -Argument "$env:SystemRoot\System32\Tasks\Sophia\TempTask.vbs"
			$Settings  = New-ScheduledTaskSettingsSet -Compatibility Win8 -StartWhenAvailable
			$Principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Highest
			$Trigger   = New-ScheduledTaskTrigger -Daily -DaysInterval 60 -At 9pm
			$Parameters = @{
				TaskName    = "Temp"
				TaskPath    = "Sophia"
				Action      = $Action
				Settings    = $Settings
				Principal   = $Principal
				Trigger     = $Trigger
				Description = $Localization.FolderTaskDescription -f "%TEMP%"
			}
			Register-ScheduledTask @Parameters -Force

			$Script:ScheduledTasks = $true
		}
		"Delete"
		{
			# Remove files first unless we cannot remove folder if there's no more tasks there
			Remove-Item -Path "$env:SystemRoot\System32\Tasks\Sophia\TempTask.vbs", "$env:SystemRoot\System32\Tasks\Sophia\TempTask.ps1" -Force -ErrorAction Ignore

			# Remove all old tasks
			# We have to use -ErrorAction Ignore in both cases, unless we get an error
			Get-ScheduledTask -TaskPath "\Sophia Script\", "\SophiApp\" -ErrorAction Ignore | ForEach-Object -Process {
				Unregister-ScheduledTask -TaskName $_.TaskName -Confirm:$false -ErrorAction Ignore
			}

			# Remove folder in Task Scheduler if there is no tasks left there. We cannot remove all old folders explicitly and not get errors if any of folders do not exist
			$ScheduleService = New-Object -ComObject Schedule.Service
			$ScheduleService.Connect()
			if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Sophia Script")
			{
				$ScheduleService.GetFolder("\").DeleteFolder("Sophia Script", $null)
			}
			if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\SophiApp")
			{
				$ScheduleService.GetFolder("\").DeleteFolder("SophiApp", $null)
			}

			# Removing current task
			Unregister-ScheduledTask -TaskPath "\Sophia\" -TaskName Temp -Confirm:$false -ErrorAction Ignore

			# Remove folder in Task Scheduler if there is no tasks left there
			if (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\Sophia")
			{
				if (($ScheduleService.GetFolder("Sophia").GetTasks(0) | Select-Object -Property Name).Name.Count -eq 0)
				{
					$ScheduleService.GetFolder("\").DeleteFolder("Sophia", $null)
				}
			}
		}
	}
}
#endregion Scheduled tasks

#region Microsoft Defender & Security
<#
	.SYNOPSIS
	Microsoft Defender Exploit Guard network protection

	.PARAMETER Enable
	Enable Microsoft Defender Exploit Guard network protection

	.PARAMETER Disable
	Disable Microsoft Defender Exploit Guard network protection

	.EXAMPLE
	NetworkProtection -Enable

	.EXAMPLE
	NetworkProtection -Disable

	.NOTES
	Current user
#>
function NetworkProtection
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

	if ($Script:DefenderEnabled)
	{
		switch ($PSCmdlet.ParameterSetName)
		{
			"Enable"
			{
				Set-MpPreference -EnableNetworkProtection Enabled
			}
			"Disable"
			{
				Set-MpPreference -EnableNetworkProtection Disabled
			}
		}
	}
}

<#
	.SYNOPSIS
	Detection for potentially unwanted applications

	.PARAMETER Enable
	Enable detection for potentially unwanted applications and block them

	.PARAMETER Disable
	Disable detection for potentially unwanted applications and block them

	.EXAMPLE
	PUAppsDetection -Enable

	.EXAMPLE
	PUAppsDetection -Disable

	.NOTES
	Current user
#>
function PUAppsDetection
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

	if ($Script:DefenderEnabled)
	{
		switch ($PSCmdlet.ParameterSetName)
		{
			"Enable"
			{
				Set-MpPreference -PUAProtection Enabled
			}
			"Disable"
			{
				Set-MpPreference -PUAProtection Disabled
			}
		}
	}
}

<#
	.SYNOPSIS
	Sandboxing for Microsoft Defender

	.PARAMETER Enable
	Enable sandboxing for Microsoft Defender

	.PARAMETER Disable
	Disable sandboxing for Microsoft Defender

	.EXAMPLE
	DefenderSandbox -Enable

	.EXAMPLE
	DefenderSandbox -Disable

	.NOTES
	There is a bug in KVM with QEMU: enabling this function causes VM to freeze up during the loading phase of Windows

	.NOTES
	Machine-wide
#>
function DefenderSandbox
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

	if ($Script:DefenderEnabled)
	{
		switch ($PSCmdlet.ParameterSetName)
		{
			"Enable"
			{
				setx /M MP_FORCE_USE_SANDBOX 1
			}
			"Disable"
			{
				setx /M MP_FORCE_USE_SANDBOX 0
			}
		}
	}
}

# Dismiss Microsoft Defender offer in the Windows Security about signing in Microsoft account
function DismissMSAccount
{
	if ($Script:DefenderEnabled)
	{
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows Security Health\State" -Name AccountProtection_MicrosoftAccount_Disconnected -PropertyType DWord -Value 1 -Force
	}
}

# Dismiss Microsoft Defender offer in the Windows Security about turning on the SmartScreen filter for Microsoft Edge
function DismissSmartScreenFilter
{
	if ($Script:DefenderEnabled)
	{
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows Security Health\State" -Name AppAndBrowser_EdgeSmartScreenOff -PropertyType DWord -Value 0 -Force
	}
}

<#
	.SYNOPSIS
	Audit process creation

	.PARAMETER Enable
	Enable events auditing generated when a process is created (starts)

	.PARAMETER Disable
	Disable events auditing generated when a process is created (starts)

	.EXAMPLE
	AuditProcess -Enable

	.EXAMPLE
	AuditProcess -Disable

	.NOTES
	Machine-wide
#>
function AuditProcess
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
			auditpol /set /subcategory:"{0CCE922B-69AE-11D9-BED3-505054503030}" /success:enable /failure:enable
		}
		"Disable"
		{
			auditpol /set /subcategory:"{0CCE922B-69AE-11D9-BED3-505054503030}" /success:disable /failure:disable
		}
	}
}

<#
	.SYNOPSIS
	Сommand line auditing

	.PARAMETER Enable
	Include command line in process creation events

	.PARAMETER Disable
	Do not include command line in process creation events

	.EXAMPLE
	CommandLineProcessAudit -Enable

	.EXAMPLE
	CommandLineProcessAudit -Disable

	.NOTES
	In order this feature to work events auditing (ProcessAudit -Enable) will be enabled

	.NOTES
	Machine-wide
#>
function CommandLineProcessAudit
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
			# Enable events auditing generated when a process is created (starts)
			auditpol /set /subcategory:"{0CCE922B-69AE-11D9-BED3-505054503030}" /success:enable /failure:enable

			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit -Name ProcessCreationIncludeCmdLine_Enabled -PropertyType DWord -Value 1 -Force
			Set-Policy -Scope Computer -Path SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit -Name ProcessCreationIncludeCmdLine_Enabled -Type DWORD -Value 1
		}
		"Disable"
		{
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit -Name ProcessCreationIncludeCmdLine_Enabled -Force -ErrorAction Ignore
			Set-Policy -Scope Computer -Path SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit -Name ProcessCreationIncludeCmdLine_Enabled -Type CLEAR
		}
	}
}

<#
	.SYNOPSIS
	The "Process Creation" Event Viewer custom view

	.PARAMETER Enable
	Create the "Process Creation" сustom view in the Event Viewer to log executed processes and their arguments

	.PARAMETER Disable
	Remove the "Process Creation" custom view in the Event Viewer

	.EXAMPLE
	EventViewerCustomView -Enable

	.EXAMPLE
	EventViewerCustomView -Disable

	.NOTES
	In order this feature to work events auditing (ProcessAudit -Enable) and command line (CommandLineProcessAudit -Enable) in process creation events will be enabled

	.NOTES
	Machine-wide
#>
function EventViewerCustomView
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
			# Enable events auditing generated when a process is created (starts)
			auditpol /set /subcategory:"{0CCE922B-69AE-11D9-BED3-505054503030}" /success:enable /failure:enable

			# Include command line in process creation events
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit -Name ProcessCreationIncludeCmdLine_Enabled -PropertyType DWord -Value 1 -Force
			Set-Policy -Scope Computer -Path SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit -Name ProcessCreationIncludeCmdLine_Enabled -Type DWORD -Value 1

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

			# Save ProcessCreation.xml in the UTF-8 with BOM encoding
			Set-Content -Path "$env:ProgramData\Microsoft\Event Viewer\Views\ProcessCreation.xml" -Value $XML -Encoding UTF8 -Force
		}
		"Disable"
		{
			Remove-Item -Path "$env:ProgramData\Microsoft\Event Viewer\Views\ProcessCreation.xml" -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	Logging for all Windows PowerShell modules

	.PARAMETER Enable
	Enable logging for all Windows PowerShell modules

	.PARAMETER Disable
	Disable logging for all Windows PowerShell modules

	.EXAMPLE
	PowerShellModulesLogging -Enable

	.EXAMPLE
	PowerShellModulesLogging -Disable

	.NOTES
	Machine-wide
#>
function PowerShellModulesLogging
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
			if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames))
			{
				New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames -Force
			}
			New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging -Name EnableModuleLogging -PropertyType DWord -Value 1 -Force
			New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames -Name * -PropertyType String -Value * -Force
			Set-Policy -Scope Computer -Path SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging -Name EnableModuleLogging -Type DWORD -Value 1
			Set-Policy -Scope Computer -Path SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames -Name * -Type SZ -Value *
		}
		"Disable"
		{
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging -Name EnableModuleLogging -Force -ErrorAction Ignore
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames -Name * -Force -ErrorAction Ignore
			Set-Policy -Scope Computer -Path SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging -Name EnableModuleLogging -Type CLEAR
		}
	}
}

<#
	.SYNOPSIS
	Logging for all PowerShell scripts input to the Windows PowerShell event log

	.PARAMETER Enable
	Enable logging for all PowerShell scripts input to the Windows PowerShell event log

	.PARAMETER Disable
	Disable logging for all PowerShell scripts input to the Windows PowerShell event log

	.EXAMPLE
	PowerShellScriptsLogging -Enable

	.EXAMPLE
	PowerShellScriptsLogging -Disable

	.NOTES
	Machine-wide
#>
function PowerShellScriptsLogging
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
			if (-not (Test-Path -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging))
			{
				New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Force
			}
			New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Name EnableScriptBlockLogging -PropertyType DWord -Value 1 -Force
			Set-Policy -Scope Computer -Path SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Name EnableScriptBlockLogging -Type DWORD -Value 1
		}
		"Disable"
		{
			Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Name EnableScriptBlockLogging -Force -ErrorAction Ignore
			Set-Policy -Scope Computer -Path SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging -Name EnableScriptBlockLogging -Type CLEAR
		}
	}
}

<#
	.SYNOPSIS
	Microsoft Defender SmartScreen

	.PARAMETER Disable
	Disable apps and files checking within Microsoft Defender SmartScreen

	.PARAMETER Enable
	Enable apps and files checking within Microsoft Defender SmartScreen

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

	if ($Script:DefenderEnabled)
	{
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
}

<#
	.SYNOPSIS
	The Attachment Manager

	.PARAMETER Disable
	Microsoft Defender SmartScreen doesn't marks downloaded files from the Internet as unsafe

	.PARAMETER Enable
	Microsoft Defender SmartScreen marks downloaded files from the Internet as unsafe

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
			if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments))
			{
				New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -Force
			}
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -Name SaveZoneInformation -PropertyType DWord -Value 1 -Force
			Set-Policy -Scope User -Path Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -Name SaveZoneInformation -Type DWORD -Value 1
		}
		"Enable"
		{
			Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -Name SaveZoneInformation -Force -ErrorAction Ignore
			Set-Policy -Scope User -Path Software\Microsoft\Windows\CurrentVersion\Policies\Attachments -Name SaveZoneInformation -Type CLEAR
		}
	}
}

<#
	.SYNOPSIS
	Windows Script Host

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
			if (-not (Test-Path -Path "HKCU:\Software\Microsoft\Windows Script Host\Settings"))
			{
				New-Item -Path "HKCU:\Software\Microsoft\Windows Script Host\Settings" -Force
			}
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows Script Host\Settings" -Name Enabled -PropertyType DWord -Value 0 -Force
		}
		"Enable"
		{
			Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows Script Host\Settings" -Name Enabled -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	Windows Sandbox

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
			if (Get-WindowsEdition -Online | Where-Object -FilterScript {($_.Edition -eq "Professional") -or ($_.Edition -like "Enterprise*")})
			{
				# Checking whether x86 virtualization is enabled in the firmware
				if ((Get-CimInstance -ClassName CIM_Processor).VirtualizationFirmwareEnabled)
				{
					Disable-WindowsOptionalFeature -FeatureName Containers-DisposableClientVM -Online -NoRestart
				}
				else
				{
					try
					{
						# Determining whether Hyper-V is enabled
						if ((Get-CimInstance -ClassName CIM_ComputerSystem).HypervisorPresent)
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
			if (Get-WindowsEdition -Online | Where-Object -FilterScript {($_.Edition -eq "Professional") -or ($_.Edition -like "Enterprise*")})
			{
				# Checking whether x86 virtualization is enabled in the firmware
				if ((Get-CimInstance -ClassName CIM_Processor).VirtualizationFirmwareEnabled)
				{
					Enable-WindowsOptionalFeature -FeatureName Containers-DisposableClientVM -All -Online -NoRestart
				}
				else
				{
					try
					{
						# Determining whether Hyper-V is enabled
						if ((Get-CimInstance -ClassName CIM_ComputerSystem).HypervisorPresent)
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
	The "Extract all" item in the Windows Installer (.msi) context menu

	.PARAMETER Show
	Show the "Extract all" item in the Windows Installer (.msi) context menu

	.PARAMETER Remove
	Hide the "Extract all" item from the Windows Installer (.msi) context menu

	.EXAMPLE
	MSIExtractContext -Show

	.EXAMPLE
	MSIExtractContext -Hide

	.NOTES
	Current user
#>
function MSIExtractContext
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
			if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command))
			{
				New-Item -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command -Force
			}
			$Value = "{0}" -f "msiexec.exe /a `"%1`" /qb TARGETDIR=`"%1 extracted`""
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract\Command -Name "(default)" -PropertyType String -Value $Value -Force
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Name MUIVerb -PropertyType String -Value "@shell32.dll,-37514" -Force
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Name Icon -PropertyType String -Value "shell32.dll,-16817" -Force
		}
		"Hide"
		{
			Remove-Item -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Recurse -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	The "Install" item for the Cabinet (.cab) filenames extensions context menu

	.PARAMETER Show
	Show the "Install" item in the Cabinet (.cab) filenames extensions context menu

	.PARAMETER Hide
	Hide the "Install" item from the Cabinet (.cab) filenames extensions context menu

	.EXAMPLE
	CABInstallContext -Show

	.EXAMPLE
	CABInstallContext -Hide

	.NOTES
	Current user
#>
function CABInstallContext
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
			if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\runas\Command))
			{
				New-Item -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\runas\Command -Force
			}
			$Value = "{0}" -f "cmd /c DISM.exe /Online /Add-Package /PackagePath:`"%1`" /NoRestart & pause"
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\runas\Command -Name "(default)" -PropertyType String -Value $Value -Force
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\runas -Name MUIVerb -PropertyType String -Value "@shell32.dll,-10210" -Force
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\runas -Name HasLUAShield -PropertyType String -Value "" -Force
		}
		"Hide"
		{
			Remove-Item -Path Registry::HKEY_CLASSES_ROOT\CABFolder\Shell\runas -Recurse -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	The "Run as different user" item for the .exe filename extensions context menu

	.PARAMETER Show
	Show the "Run as different user" item in the .exe filename extensions context menu

	.PARAMETER Hide
	Hide the "Run as different user" item from the .exe filename extensions context menu

	.EXAMPLE
	RunAsDifferentUserContext -Show

	.EXAMPLE
	RunAsDifferentUserContext -Hide

	.NOTES
	Current user
#>
function RunAsDifferentUserContext
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
			Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\exefile\shell\runasuser -Name Extended -Force -ErrorAction Ignore
		}
		"Hide"
		{
			New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\exefile\shell\runasuser -Name Extended -PropertyType String -Value "" -Force
		}
	}
}

<#
	.SYNOPSIS
	The "Cast to Device" item in the media files and folders context menu

	.PARAMETER Hide
	Hide the "Cast to Device" item from the media files and folders context menu

	.PARAMETER Show
	Show the "Cast to Device" item in the media files and folders context menu

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
			Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	The "Share" item in the context menu

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
			Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{E2BF9676-5F8F-435C-97EB-11607A5BEDF7}" -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	The "Edit with Paint 3D" item in the media files context menu

	.PARAMETER Hide
	Hide the "Edit with Paint 3D" item from the media files context menu

	.PARAMETER Show
	Show the "Edit with Paint 3D" item in the media files context menu

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
			foreach ($Extension in $Extensions)
			{
				New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\$Extension\Shell\3D Edit" -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
			}
		}
		"Show"
		{
			$Extensions = @(".bmp", ".gif", ".jpe", ".jpeg", ".jpg", ".png", ".tif", ".tiff")
			foreach ($Extension in $Extensions)
			{
				Remove-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\$Extension\Shell\3D Edit" -Name ProgrammaticAccessOnly -Force -ErrorAction Ignore
			}
		}
	}
}

<#
	.SYNOPSIS
	The "Edit" item in the images context menu

	.PARAMETER Hide
	Hide the "Edit" item from the images context menu

	.PARAMETER Show
	Show the "Edit" item in the images context menu

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

	if ((Get-WindowsCapability -Online -Name "Microsoft.Windows.MSPaint*").State -eq "Installed")
	{
		switch ($PSCmdlet.ParameterSetName)
		{
			"Hide"
			{
				New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\edit -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
			}
			"Show"
			{
				Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\SystemFileAssociations\image\shell\edit -Name ProgrammaticAccessOnly -Force -ErrorAction Ignore
			}
		}
	}
}

<#
	.SYNOPSIS
	The "Print" item in the .bat and .cmd context menu

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
			Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\batfile\shell\print -Name ProgrammaticAccessOnly -Force -ErrorAction Ignore
			Remove-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\cmdfile\shell\print -Name ProgrammaticAccessOnly -Force -ErrorAction Ignore
		}
	}
}

<#
	.SYNOPSIS
	The "Include in Library" item in the folders and drives context menu

	.PARAMETER Hide
	Hide the "Include in Library" item from the folders and drives context menu

	.PARAMETER Show
	Show the "Include in Library" item in the folders and drives context menu

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
			New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Folder\ShellEx\ContextMenuHandlers\Library Location" -Name "(default)" -PropertyType String -Value "-{3dad6c5d-2167-4cae-9914-f99e41c12cfa}" -Force
		}
		"Show"
		{
			New-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\Folder\ShellEx\ContextMenuHandlers\Library Location" -Name "(default)" -PropertyType String -Value "{3dad6c5d-2167-4cae-9914-f99e41c12cfa}" -Force
		}
	}
}

<#
	.SYNOPSIS
	The "Send to" item in the folders context menu

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
	The "Bitmap image" item in the "New" context menu

	.PARAMETER Hide
	Hide the "Bitmap image" item from the "New" context menu

	.PARAMETER Show
	Show the "Bitmap image" item to the "New" context menu

	.EXAMPLE
	BitmapImageNewContext -Hide

	.EXAMPLE
	BitmapImageNewContext -Show

	.NOTES
	Current user
#>
function BitmapImageNewContext
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
				Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.bmp\ShellNew -Force -ErrorAction Ignore
			}
		}
		"Show"
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
					# Check the internet connection
					$Parameters = @{
						Uri              = "https://www.google.com"
						Method           = "Head"
						DisableKeepAlive = $true
						UseBasicParsing  = $true
					}
					if (-not (Invoke-WebRequest @Parameters).StatusDescription)
					{
						return
					}

					Write-Information -MessageData "" -InformationAction Continue
					Write-Verbose -Message $Localization.Patient -Verbose

					Get-WindowsCapability -Online -Name "Microsoft.Windows.MSPaint*" | Add-WindowsCapability -Online
				}
				catch [System.Net.WebException]
				{
					Write-Warning -Message $Localization.NoInternetConnection
					Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue

					Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue
				}
			}
		}
	}
}

<#
	.SYNOPSIS
	The "Rich Text Document" item in the "New" context menu

	.PARAMETER Hide
	Hide the "Rich Text Document" item from the "New" context menu

	.PARAMETER Show
	Show the "Rich Text Document" item to the "New" context menu

	.EXAMPLE
	RichTextDocumentNewContext -Hide

	.EXAMPLE
	RichTextDocumentNewContext -Show

	.NOTES
	Current user
#>
function RichTextDocumentNewContext
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
			if ((Get-WindowsCapability -Online -Name "Microsoft.Windows.WordPad*").State -eq "Installed")
			{
				Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.rtf\ShellNew -Force -ErrorAction Ignore
			}
		}
		"Show"
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
					# Check the internet connection
					$Parameters = @{
						Uri              = "https://www.google.com"
						Method           = "Head"
						DisableKeepAlive = $true
						UseBasicParsing  = $true
					}
					if (-not (Invoke-WebRequest @Parameters).StatusDescription)
					{
						return
					}

					Write-Information -MessageData "" -InformationAction Continue
					Write-Verbose -Message $Localization.Patient -Verbose

					Get-WindowsCapability -Online -Name "Microsoft.Windows.WordPad*" | Add-WindowsCapability -Online
				}
				catch [System.Net.WebException]
				{
					Write-Warning -Message $Localization.NoInternetConnection
					Write-Error -Message $Localization.NoInternetConnection -ErrorAction SilentlyContinue

					Write-Error -Message ($Localization.RestartFunction -f $MyInvocation.Line.Trim()) -ErrorAction SilentlyContinue
				}
			}
		}
	}
}

<#
	.SYNOPSIS
	The "Compressed (zipped) Folder" item in the "New" context menu

	.PARAMETER Hide
	Hide the "Compressed (zipped) Folder" item from the "New" context menu

	.PARAMETER Show
	Show the "Compressed (zipped) Folder" item to the "New" context menu

	.EXAMPLE
	CompressedFolderNewContext -Hide

	.EXAMPLE
	CompressedFolderNewContext -Show

	.NOTES
	Current user
#>
function CompressedFolderNewContext
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
			Remove-Item -Path Registry::HKEY_CLASSES_ROOT\.zip\CompressedFolder\ShellNew -Force -ErrorAction Ignore
		}
		"Show"
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
	The "Open", "Print", and "Edit" items if more than 15 files selected

	.PARAMETER Enable
	Enable the "Open", "Print", and "Edit" items if more than 15 files selected

	.PARAMETER Disable
	Disable the "Open", "Print", and "Edit" items if more than 15 files selected

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
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name MultipleInvokePromptMinimum -PropertyType DWord -Value 300 -Force
		}
		"Disable"
		{
			Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name MultipleInvokePromptMinimum -Force -ErrorAction Ignore
		}
	}
}
#endregion Context menu

#region Update Policies
<#
	.SYNOPSIS
	Display all policy registry keys (even manually created ones) in the Local Group Policy Editor snap-in (gpedit.msc)
	This can take up to 30 minutes, depending on on the number of policies created in the registry and your system resources

	.EXAMPLE
	UpdateLGPEPolicies

	.NOTES
	https://techcommunity.microsoft.com/t5/microsoft-security-baselines/lgpo-exe-local-group-policy-object-utility-v1-0/ba-p/701045

	.NOTES
	Machine-wide user
	Current user
#>
function UpdateLGPEPolicies
{
	if (-not (Test-Path -Path "$env:SystemRoot\System32\gpedit.msc"))
	{
		return
	}

	Get-Partition | Where-Object -FilterScript {$_.DriveLetter -eq $([System.Environment]::ExpandEnvironmentVariables($env:SystemDrive).Replace(":", ""))} | Get-Disk | Get-PhysicalDisk | ForEach-Object -Process {
		Write-Verbose -Message ([string]($_.FriendlyName, '|', $_.MediaType, '|', $_.BusType)) -Verbose
	}

	Write-Information -MessageData "" -InformationAction Continue
	# Extract the localized "Please wait..." string from shell32.dll
	Write-Verbose -Message ([WinAPI.GetStr]::GetString(12612)) -Verbose
	Write-Verbose -Message $Localization.GPOUpdate -Verbose
	Write-Verbose -Message HKLM -Verbose
	Write-Information -MessageData "" -InformationAction Continue

	# Local Machine policies paths to scan recursively
	$LM_Paths = @(
		"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies",
		"HKLM:\SOFTWARE\Policies\Microsoft"
	)
	foreach ($Path in (@(Get-ChildItem -Path $LM_Paths -Recurse -Force)))
	{
		foreach ($Item in $Path.Property)
		{
			# Check if property isn't equal to "(default)" and exists
			if (($null -ne $Item) -and ($Item -ne "(default)"))
			{
				# Where all ADMX templates are located to compare with
				foreach ($admx in @(Get-ChildItem -Path "$env:SystemRoot\PolicyDefinitions" -File -Force))
				{
					# Parse every ADMX template searching if it contains full path and registry key simultaneously
					[xml]$config = Get-Content -Path $admx.FullName -Encoding UTF8
					$config.SelectNodes("//@*") | ForEach-Object -Process {$_.value = $_.value.ToLower()}
					$SplitPath = $Path.Name.Replace("HKEY_LOCAL_MACHINE\", "")

					if ($config.SelectSingleNode("//*[local-name()='policy' and @key='$($SplitPath.ToLower())' and (@valueName='$($Item.ToLower())' or @Name='$($Item.ToLower())' or .//*[local-name()='enum' and @valueName='$($Item.ToLower())'])]"))
					{
						Write-Verbose -Message ([string]($SplitPath, "|", $Item.Replace("{}", ""), "|", $(Get-ItemPropertyValue -Path $Path.PSPath -Name $Item))) -Verbose

						$Type = switch ((Get-Item -Path $Path.PSPath).GetValueKind($Item))
						{
							"DWord"
							{
								(Get-Item -Path $Path.PSPath).GetValueKind($Item).ToString().ToUpper()
							}
							"ExpandString"
							{
								"EXSZ"
							}
							"String"
							{
								"SZ"
							}
						}

						$Parameters = @{
							Scope = "Computer"
							# e.g. SOFTWARE\Microsoft\Windows\CurrentVersion\Policies
							Path  = $Path.Name.Replace("HKEY_LOCAL_MACHINE\", "")
							Name  = $Item.Replace("{}", "")
							Type  = $Type
							Value = Get-ItemPropertyValue -Path $Path.PSPath -Name $Item
						}
						Set-Policy @Parameters
					}
				}
			}
		}
	}

	Write-Information -MessageData "" -InformationAction Continue
	Write-Verbose -Message HKCU -Verbose

	# Current User policies paths to scan recursively
	$CU_Paths = @(
		"HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies",
		"HKCU:\Software\Policies\Microsoft"
	)
	foreach ($Path in (@(Get-ChildItem -Path $CU_Paths -Recurse -Force)))
	{
		foreach ($Item in $Path.Property)
		{
			# Check if property isn't equal to "(default)" and exists
			if (($null -ne $Item) -and ($Item -ne "(default)"))
			{
				# Where all ADMX templates are located to compare with
				foreach ($admx in @(Get-ChildItem -Path "$env:SystemRoot\PolicyDefinitions" -File -Force))
				{
					# Parse every ADMX template searching if it contains full path and registry key simultaneously
					[xml]$config = Get-Content -Path $admx.FullName -Encoding UTF8
					$config.SelectNodes("//@*") | ForEach-Object -Process {$_.value = $_.value.ToLower()}
					$SplitPath = $Path.Name.Replace("HKEY_CURRENT_USER\", "")

					if ($config.SelectSingleNode("//*[local-name()='policy' and @key='$($SplitPath.ToLower())' and (@valueName='$($Item.ToLower())' or @Name='$($Item.ToLower())' or .//*[local-name()='enum' and @valueName='$($Item.ToLower())'])]"))
					{
						Write-Verbose -Message ([string]($SplitPath, "|", $Item.Replace("{}", ""), "|", $(Get-ItemPropertyValue -Path $Path.PSPath -Name $Item))) -Verbose

						$Type = switch ((Get-Item -Path $Path.PSPath).GetValueKind($Item))
						{
							"DWord"
							{
								(Get-Item -Path $Path.PSPath).GetValueKind($Item).ToString().ToUpper()
							}
							"ExpandString"
							{
								"EXSZ"
							}
							"String"
							{
								"SZ"
							}
						}

						$Parameters = @{
							Scope = "User"
							# e.g. SOFTWARE\Microsoft\Windows\CurrentVersion\Policies
							Path  = $Path.Name.Replace("HKEY_CURRENT_USER\", "")
							Name  = $Item.Replace("{}", "")
							Type  = $Type
							Value = Get-ItemPropertyValue -Path $Path.PSPath -Name $Item
						}
						Set-Policy @Parameters
					}
				}
			}
		}
	}

	gpupdate.exe /force
}
#endregion Update Policies

#region Post Actions
function PostActions
{
	#region Refresh Environment
	$UpdateEnvironment = @{
		Namespace        = "WinAPI"
		Name             = "UpdateEnvironment"
		Language         = "CSharp"
		MemberDefinition = @"
private static readonly IntPtr HWND_BROADCAST = new IntPtr(0xffff);
private const int WM_SETTINGCHANGE = 0x1a;
private const int SMTO_ABORTIFHUNG = 0x0002;

[DllImport("shell32.dll", CharSet = CharSet.Auto, SetLastError = false)]
private static extern int SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2);

[DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = false)]
private static extern IntPtr SendMessageTimeout(IntPtr hWnd, int Msg, IntPtr wParam, string lParam, int fuFlags, int uTimeout, IntPtr lpdwResult);

[DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = false)]
static extern bool SendNotifyMessage(IntPtr hWnd, uint Msg, IntPtr wParam, string lParam);

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
	if (-not ("WinAPI.UpdateEnvironment" -as [type]))
	{
		Add-Type @UpdateEnvironment
	}

	# Simulate pressing F5 to refresh the desktop
	[WinAPI.UpdateEnvironment]::PostMessage()

	# Refresh desktop icons, environment variables, taskbar
	[WinAPI.UpdateEnvironment]::Refresh()

	# Restart the Start menu
	Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction Ignore
	#endregion Refresh Environment

	#region Other actions
	# Turn on Controlled folder access if it was turned off
	if ($Script:DefenderEnabled)
	{
		if ($Script:ControlledFolderAccess)
		{
			Set-MpPreference -EnableControlledFolderAccess Enabled
		}
	}

	if ($Script:RegionChanged)
	{
		# Set the original region ID
		Set-WinHomeLocation -GeoId $Script:Region
	}

	# Apply policies found in registry to re-build database database due to gpedit.msc relies in its' own database
	if ((Test-Path -Path "$env:TEMP\Computer.txt") -or (Test-Path -Path "$env:TEMP\User.txt"))
	{
		if (Test-Path -Path "$env:TEMP\Computer.txt")
		{
			& "$PSScriptRoot\..\bin\LGPO.exe" /t "$env:TEMP\Computer.txt"
		}
		if (Test-Path -Path "$env:TEMP\User.txt")
		{
			& "$PSScriptRoot\..\bin\LGPO.exe" /t "$env:TEMP\User.txt"
		}

		gpupdate /force
	}

	# PowerShell 5.1 (7.3 too) interprets 8.3 file name literally, if an environment variable contains a non-latin word
	Get-ChildItem -Path "$env:TEMP\Computer.txt", "$env:TEMP\User.txt" -Force -ErrorAction Ignore | Remove-Item -Recurse -Force -ErrorAction Ignore

	Stop-Process -Name explorer -Force
	Start-Sleep -Seconds 3

	# Restoring closed folders
	foreach ($Script:OpenedFolder in $Script:OpenedFolders)
	{
		if (Test-Path -Path $Script:OpenedFolder)
		{
			Start-Process -FilePath explorer -ArgumentList $Script:OpenedFolder
		}
	}

	# Check if any of scheduled tasks were created. Unless open Task Scheduler
	if ($Script:ScheduledTasks)
	{
		# Find and close taskschd.msc by its' argument
		$taskschd_Process_ID = (Get-CimInstance -ClassName CIM_Process | Where-Object -FilterScript {$_.Name -eq "mmc.exe"} | Where-Object -FilterScript {
			$_.CommandLine -match "taskschd.msc"
		}).Handle
		# Due to "Set-StrictMode -Version Latest" we have to check before executing
		if ($taskschd_Process_ID)
		{
			Get-Process -Id $taskschd_Process_ID | Stop-Process -Force
		}

		# Open Task Scheduler
		Start-Process -FilePath taskschd.msc
	}
	#endregion Other actions

	#region Toast notifications
	# Persist Sophia notifications to prevent to immediately disappear from Action Center
	if (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Sophia))
	{
		New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Sophia -Force
	}
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Sophia -Name ShowInActionCenter -PropertyType DWord -Value 1 -Force

	if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia))
	{
		New-Item -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia -Force
	}
	# Register app
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia -Name DisplayName -Value Sophia -PropertyType String -Force
	# Determines whether the app can be seen in Settings where the user can turn notifications on or off
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia -Name ShowInSettings -Value 0 -PropertyType DWord -Force

	[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
	[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

	# Telegram group
	# Extract the localized "Open" string from shell32.dll
	[xml]$ToastTemplate = @"
<toast duration="Long" scenario="reminder">
	<visual>
		<binding template="ToastGeneric">
			<text>$($Localization.TelegramGroupTitle)</text>
			<group>
				<subgroup>
					<text hint-style="body" hint-wrap="true">https://t.me/sophia_chat</text>
				</subgroup>
			</group>
		</binding>
	</visual>
	<audio src="ms-winsoundevent:notification.default" />
	<actions>
		<action arguments="https://t.me/sophia_chat" content="$([WinAPI.GetStr]::GetString(12850))" activationType="protocol"/>
		<action arguments="dismiss" content="" activationType="system"/>
	</actions>
</toast>
"@

	$ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::New()
	$ToastXml.LoadXml($ToastTemplate.OuterXml)

	$ToastMessage = [Windows.UI.Notifications.ToastNotification]::New($ToastXML)
	[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Sophia").Show($ToastMessage)

	# Telegram channel
	# Extract the localized "Open" string from shell32.dll
	[xml]$ToastTemplate = @"
<toast duration="Long" scenario="reminder">
	<visual>
		<binding template="ToastGeneric">
			<text>$($Localization.TelegramChannelTitle)</text>
			<group>
				<subgroup>
					<text hint-style="body" hint-wrap="true">https://t.me/sophianews</text>
				</subgroup>
			</group>
		</binding>
	</visual>
	<audio src="ms-winsoundevent:notification.default" />
	<actions>
		<action arguments="https://t.me/sophianews" content="$([WinAPI.GetStr]::GetString(12850))" activationType="protocol"/>
		<action arguments="dismiss" content="" activationType="system"/>
	</actions>
</toast>
"@

	$ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::New()
	$ToastXml.LoadXml($ToastTemplate.OuterXml)

	$ToastMessage = [Windows.UI.Notifications.ToastNotification]::New($ToastXML)
	[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Sophia").Show($ToastMessage)

	# Discord group
	# Extract the localized "Open" string from shell32.dll
	[xml]$ToastTemplate = @"
<toast duration="Long" scenario="reminder">
	<visual>
		<binding template="ToastGeneric">
			<text>$($Localization.DiscordChannelTitle)</text>
			<group>
				<subgroup>
					<text hint-style="body" hint-wrap="true">https://discord.gg/sSryhaEv79</text>
				</subgroup>
			</group>
		</binding>
	</visual>
	<audio src="ms-winsoundevent:notification.default" />
	<actions>
		<action arguments="https://discord.gg/sSryhaEv79" content="$([WinAPI.GetStr]::GetString(12850))" activationType="protocol"/>
		<action arguments="dismiss" content="" activationType="system"/>
	</actions>
</toast>
"@

	$ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::New()
	$ToastXml.LoadXml($ToastTemplate.OuterXml)

	$ToastMessage = [Windows.UI.Notifications.ToastNotification]::New($ToastXML)
	[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Sophia").Show($ToastMessage)
	#endregion Toast notifications
}
#endregion Post Actions

#region Errors
function Errors
{
	if ($Global:Error)
	{
		($Global:Error | ForEach-Object -Process {
			# Some errors may have the Windows nature and don't have a path to any of the module's files
			$ErrorInFile = if ($_.InvocationInfo.PSCommandPath)
			{
				Split-Path -Path $_.InvocationInfo.PSCommandPath -Leaf
			}

			[PSCustomObject]@{
				$Localization.ErrorsLine              = $_.InvocationInfo.ScriptLineNumber
				# Extract the localized "File" string from shell32.dll
				"$([WinAPI.GetStr]::GetString(4130))" = $ErrorInFile
				$Localization.ErrorsMessage           = $_.Exception.Message
			}
		} | Sort-Object -Property Line | Format-Table -AutoSize -Wrap | Out-String).Trim()
	}

	Write-Information -MessageData "" -InformationAction Continue
	Write-Warning -Message $Localization.RestartWarning
}
#endregion Errors
