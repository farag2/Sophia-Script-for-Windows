<#
	.SYNOPSIS
	Initial checks before proceeding to module execution

	.VERSION
	7.3.0

	.DATE
	31.08.2026

	.COPYRIGHT
	(c) 2014—2026 Team Sophia

	.LINK
	https://github.com/farag2/Sophia-Script-for-Windows
#>
function InitialActions
{
	param
	(
		[Parameter(Mandatory = $false)]
		[switch]
		$Warning
	)

	Clear-Host
	$Global:Error.Clear()

	Set-StrictMode -Version Latest

	$Host.UI.RawUI.WindowTitle = "Sophia Script for Windows 11 v7.3.0 (Arm | PowerShell 7) | Made with $([System.Char]::ConvertFromUtf32(0x1F497)) of Windows | $([System.Char]0x00A9) Team Sophia, 2014$([System.Char]0x2013)2026"

	# Unblock all files in the script folder by removing the Zone.Identifier alternate data stream with a value of "3"
	Get-ChildItem -Path $PSScriptRoot\..\..\ -File -Recurse -Force | Unblock-File

	# Check whether all files were expanded before running
	$ScriptFiles = [Array]::TrueForAll(@(
		"$PSScriptRoot\..\Localizations\de-DE\Sophia.psd1",
		"$PSScriptRoot\..\Localizations\en-US\Sophia.psd1",
		"$PSScriptRoot\..\Localizations\es-ES\Sophia.psd1",
		"$PSScriptRoot\..\Localizations\fr-FR\Sophia.psd1",
		"$PSScriptRoot\..\Localizations\hu-HU\Sophia.psd1",
		"$PSScriptRoot\..\Localizations\it-IT\Sophia.psd1",
		"$PSScriptRoot\..\Localizations\pl-PL\Sophia.psd1",
		"$PSScriptRoot\..\Localizations\pt-BR\Sophia.psd1",
		"$PSScriptRoot\..\Localizations\ru-RU\Sophia.psd1",
		"$PSScriptRoot\..\Localizations\tr-TR\Sophia.psd1",
		"$PSScriptRoot\..\Localizations\uk-UA\Sophia.psd1",
		"$PSScriptRoot\..\Localizations\zh-CN\Sophia.psd1",

		"$PSScriptRoot\..\..\Module\Private\Get-Hash.ps1",
		"$PSScriptRoot\..\..\Module\Private\InitialActions.ps1",
		"$PSScriptRoot\..\..\Module\Private\PostActions.ps1",
		"$PSScriptRoot\..\..\Module\Private\Set-KnownFolderPath.ps1",
		"$PSScriptRoot\..\..\Module\Private\Set-Policy.ps1",
		"$PSScriptRoot\..\..\Module\Private\Set-UserShellFolder.ps1",
		"$PSScriptRoot\..\..\Module\Private\Show-Menu.ps1",
		"$PSScriptRoot\..\..\Module\Private\WinAPI.ps1",
		"$PSScriptRoot\..\..\Module\Private\Write-AdditionalKeys.ps1",
		"$PSScriptRoot\..\..\Module\Private\Write-ExtensionKeys.ps1",

		"$PSScriptRoot\..\..\Module\Sophia.psm1",
		"$PSScriptRoot\..\Manifest\SophiaScript.psd1",
		"$PSScriptRoot\..\..\Import-TabCompletion.ps1",

		"$PSScriptRoot\..\Binaries\LGPO.exe",
		"$PSScriptRoot\..\Binaries\Microsoft.Windows.SDK.NET.dll",
		"$PSScriptRoot\..\Binaries\WinRT.Runtime.dll"
	),
	[Predicate[string]]{
		param($File)

		Test-Path -Path $File
	})
	if (-not $ScriptFiles)
	{
		Write-Warning -Message "Required files are missing. Please, do not download the whole code from the repository, but download archive from release page for you system."
		Write-Information -MessageData "" -InformationAction Continue
		Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/releases/latest" -Verbose
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "In case you have a question, raise issue on GitHub or ask the community." -Verbose
		Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Try to import localizations
	try
	{
		Import-LocalizedData -BindingVariable Global:Localization -UICulture $PSUICulture -BaseDirectory $PSScriptRoot\..\Localizations -FileName Sophia -ErrorAction Stop
	}
	catch
	{
		# If there's no folder with current localization ID ($PSUICulture), then import en-US localization
		Import-LocalizedData -BindingVariable Global:Localization -UICulture en-US -BaseDirectory $PSScriptRoot\..\Localizations -FileName Sophia
	}

	# Check CPU architecture
	try
	{
		$Caption = (Get-CimInstance -ClassName CIM_Processor).Caption
		if (($Caption -notmatch "AMD64") -and ($Caption -notmatch "Intel64"))
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message ($Localization.UnsupportedArchitecture -f $Caption)
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message $Localization.AskQuestion -Verbose
			Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://t.me/sophianews" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			$Global:Failed = $true

			exit
		}
	}
	catch
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message (($Localization.WindowsComponentStabilityDisrupted -f "Get-CimInstance -ClassName CIM_Processor"), $Localization.ReinstallWindows -join " ")
		Write-Information -MessageData "" -InformationAction Continue
		Write-Verbose -Message "https://massgrave.dev/genuine-installation-media" -Verbose
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message $Localization.AskQuestion -Verbose
		Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://t.me/sophianews" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Check whether the current module version is the latest one
	try
	{
		# https://github.com/farag2/Sophia-Script-for-Windows/blob/main/sophia_script_versions.json
		$Parameters = @{
			Uri                      = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/main/sophia_script_versions.json"
			UseBasicParsing          = $true
			ConnectionTimeoutSeconds = 5
			Verbose                  = $true
		}
		$LatestRelease = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_11_Arm_PowerShell_7
		$CurrentRelease = (Get-Module -Name SophiaScript).Version.ToString()

		if ([System.Version]$LatestRelease -gt [System.Version]$CurrentRelease)
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message ($Localization.NewSophiaScriptFound -f $LatestRelease)
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/releases/latest" -Verbose
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message $Localization.AskQuestion -Verbose
			Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://t.me/sophianews" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			$Global:Failed = $true

			exit
		}
	}
	catch [System.Net.Http.HttpRequestException]
	{
		Write-Warning -Message ($Localization.NoConnectionEstablished -f "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/main/sophia_script_versions.json")
		Write-Error -Message ($Localization.NoConnectionEstablished -f "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/main/sophia_script_versions.json") -ErrorAction SilentlyContinue
	}

	# Check whether the script was run via PowerShell 7
	if ($PSVersionTable.PSVersion.Major -ne 7)
	{
		Write-Information -MessageData "" -InformationAction Continue
		$MandatoryPSVersion = (Import-PowershellDataFile -Path "$PSScriptRoot\..\..\Manifest\SophiaScript.psd1").PowerShellVersion
		Write-Warning -Message ($Localization.UnsupportedPowerShell -f $PSVersionTable.PSVersion.Major, $PSVersionTable.PSVersion.Minor, $MandatoryPSVersion)
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message $Localization.AskQuestion -Verbose
		Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Check whether PowerShell 7 was installed from the Microsoft Store
	# https://github.com/PowerShell/PowerShell/issues/21295
	if ((Get-Process -Id $PID).Path -match "C:\\Program Files\\WindowsApps")
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message $Localization.MicrosoftStorePowerShellWarning
		Write-Information -MessageData "" -InformationAction Continue
		Write-Verbose -Message "https://github.com/powershell/powershell/releases/latest" -Verbose
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message $Localization.AskQuestion -Verbose
		Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://t.me/sophianews" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Import PowerShell 5.1 modules
	try
	{
		Import-Module -Name Microsoft.PowerShell.Management, PackageManagement, Appx, DISM -UseWindowsPowerShell -Force -ErrorAction Stop
	}
	catch
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message $Localization.PowerShellImportFailed
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message $Localization.AskQuestion -Verbose
		Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://t.me/sophianews" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Extract localized "Browse" string from %SystemRoot%\System32\shell32.dll
	$Global:Browse = [WinAPI.GetStrings]::GetString(9015)
	# Extract localized "&No" string from %SystemRoot%\System32\shell32.dll
	$Global:No = [WinAPI.GetStrings]::GetString(33232).Replace("&", "")
	# Extract localized "&Yes" string from %SystemRoot%\System32\shell32.dll
	$Global:Yes = [WinAPI.GetStrings]::GetString(33224).Replace("&", "")
	$Global:KeyboardArrows = $Localization.KeyboardArrows -f [System.Char]::ConvertFromUtf32(0x2191), [System.Char]::ConvertFromUtf32(0x2193)
	# Extract localized "Skip" string from %SystemRoot%\System32\shell32.dll
	$Global:Skip = [WinAPI.GetStrings]::GetString(16956)

	# Check the language mode
	if ($ExecutionContext.SessionState.LanguageMode -ne "FullLanguage")
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message $Localization.UnsupportedLanguageMode
		Write-Information -MessageData "" -InformationAction Continue
		Write-Verbose -Message "https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_language_modes" -Verbose
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message $Localization.AskQuestion -Verbose
		Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://t.me/sophianews" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Check whether the logged-in user is an admin
	$CurrentUserName = (Get-Process -Id $PID -IncludeUserName).UserName | Split-Path -Leaf
	$LoginUserName = (Get-CimInstance -ClassName Win32_Process -Filter "name='explorer.exe'" | Invoke-CimMethod -MethodName GetOwner | Select-Object -First 1).User
	if ($CurrentUserName -ne $LoginUserName)
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.LoggedInUserNotAdmin -f $CurrentUserName, $LoginUserName)
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message $Localization.AskQuestion -Verbose
		Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://t.me/sophianews" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Check whether the script was run in PowerShell ISE or VS Code
	if (($Host.Name -match "ISE") -or ($env:TERM_PROGRAM -eq "vscode"))
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.UnsupportedHost -f $Host.Name.Replace("Host", ""))
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message $Localization.AskQuestion -Verbose
		Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://t.me/sophianews" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Check whether Windows was broken by 3rd party harmful tweakers, trojans, or custom Windows images
	$Tweakers = @{
		# https://www.youtube.com/GHOSTSPECTRE
		"Ghost Toolbox"     = "$env:SystemRoot\System32\migwiz\dlmanifests\run.ghost.cmd"
		# https://win10tweaker.ru
		"Win 10 Tweaker"    = "HKCU:\Software\Win 10 Tweaker"
		# https://revi.cc
		"Revision Tool"     = "${env:ProgramFiles(x86)}\Revision Tool"
		# https://github.com/Atlas-OS/Atlas
		AtlasOS              = "$env:SystemRoot\AtlasModules"
		# https://boosterx.ru
		BoosterX            = "$env:ProgramFiles\GameModeX\GameModeX.exe"
		# https://www.youtube.com/watch?v=5NBqbUUB1Pk
		WinClean             = "$env:ProgramFiles\WinClean Plus Apps"
		# https://pc-np.com
		PCNP                 = "HKCU:\Software\PCNP"
		# https://www.reddit.com/r/TronScript/
		Tron                 = "$env:SystemDrive\logs\tron"
		# https://crystalcry.ru
		CrystalCry           = "HKLM:\SOFTWARE\CrystalCry"
		# https://github.com/es3n1n/defendnot
		defendnot            = "$env:SystemRoot\System32\Tasks\defendnot"
		# https://github.com/zoicware/RemoveWindowsAI
		RemoveWindowsAI      = "$env:SystemRoot\System32\CatRoot\*\ZoicwareRemoveWindowsAI*"
	}
	foreach ($Tweaker in $Tweakers.Keys)
	{
		if (Test-Path -Path $Tweakers[$Tweaker])
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message (($Localization.HarmfulTweakerFound -f $Tweaker), $Localization.ReinstallWindows -join " ")
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message "https://massgrave.dev/genuine-installation-media" -Verbose
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message $Localization.AskQuestion -Verbose
			Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://t.me/sophianews" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			$Global:Failed = $true

			exit
		}
	}

	# Check whether Windows was broken by 3rd party harmful tweakers, trojans, or custom Windows images
	$Tweakers = @{
		# https://forum.ru-board.com/topic.cgi?forum=62&topic=30617&start=1600#14
		AutoSettingsPS                   = "$(Get-ItemProperty -Path `"HKLM:\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths`" -Name *AutoSettingsPS*)"
		# https://forum.ru-board.com/topic.cgi?forum=5&topic=50519
		"Modern Tweaker"                 = "$(Get-ItemProperty -Path `"HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache`" -Name *ModernTweaker*)"
	}
	foreach ($Tweaker in $Tweakers.Keys)
	{
		if ($Tweakers[$Tweaker])
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message (($Localization.HarmfulTweakerFound -f $Tweaker), $Localization.ReinstallWindows -join " ")
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message "https://massgrave.dev/genuine-installation-media" -Verbose
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message $Localization.AskQuestion -Verbose
			Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://t.me/sophianews" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			$Global:Failed = $true

			exit
		}
	}

	Write-Information -MessageData "" -InformationAction Continue
	# Extract localized "Please wait..." string from %SystemRoot%\System32\shell32.dll
	Write-Verbose -Message ([WinAPI.GetStrings]::GetString(12612)) -Verbose
	Write-Information -MessageData "" -InformationAction Continue

	# Check whether third-party enries added to hosts file
	foreach ($Item in @(Get-Content -Path "$env:SystemRoot\System32\drivers\etc\hosts" -Force))
	{
		if (-not ([string]::IsNullOrEmpty($Item) -or $Item.StartsWith("#")))
		{
			Write-Verbose -Message $Localization.HostsEntriesFound -Verbose

			do
			{
				$Choice = Show-Menu -Menu @($Yes, $No) -Default 2

				switch ($Choice)
				{
					$Yes
					{
						continue
					}
					$No
					{
						Invoke-Item -Path "$env:SystemRoot\System32\drivers\etc"

						Write-Verbose -Message $Localization.AskQuestion -Verbose
						Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
						Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
						Write-Verbose -Message "https://t.me/sophianews" -Verbose
						Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

						$Global:Failed = $true

						exit
					}
					$KeyboardArrows {}
				}
			}
			until ($Choice -ne $KeyboardArrows)

			break
		}
	}

	# Check whether the Microsoft Store or Windows Feature Experience Pack was removed
	@("Microsoft.WindowsStore", "MicrosoftWindows.Client.CBS") | ForEach-Object -Process {
		if (-not (Get-AppxPackage -Name $_))
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message (($Localization.UWPComponentsMissing -f $_), $Localization.ReinstallWindows -join " ")
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message "https://massgrave.dev/genuine-installation-media" -Verbose
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message $Localization.AskQuestion -Verbose
			Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://t.me/sophianews" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			$Global:Failed = $true

			exit
		}
	}

	#region Defender checks
	# Check whether necessary Microsoft Defender components exist
	$DefenderFiles = @(
		"$env:SystemRoot\System32\smartscreen.exe",
		"$env:SystemRoot\System32\SecurityHealthSystray.exe",
		"$env:SystemRoot\System32\CompatTelRunner.exe"
	)
	$DefenderFiles| ForEach-Object -Process {
		if (-not (Test-Path -Path $_))
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message (($Localization.DefenderComponentsMissing -f $_), $Localization.ReinstallWindows -join " ")
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message "https://massgrave.dev/genuine-installation-media" -Verbose
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message $Localization.AskQuestion -Verbose
			Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://t.me/sophianews" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			$Global:Failed = $true

			exit
		}
	}

	# Checking Microsoft Defender properties
	try
	{
		$AntiVirusProduct = @(
			Get-Service -Name Windefend, SecurityHealthService, wscsvc, wdFilter -ErrorAction Stop
			Get-Service -Name SecurityHealthService -ErrorAction Stop | Start-Service -ErrorAction Stop
			Get-CimInstance -ClassName MSFT_MpComputerStatus -Namespace root/Microsoft/Windows/Defender -ErrorAction Stop
			Get-CimInstance -ClassName AntiVirusProduct -Namespace root/SecurityCenter2 -ErrorAction Stop
			Get-MpPreference -ErrorAction Stop
		)
	}
	catch
	{
		# Get the exact string where script failed
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message (($Localization.WindowsComponentStabilityDisrupted -f $_.InvocationInfo.Line.Replace(" -ErrorAction Stop", "").Trim()), $Localization.ReinstallWindows -join " ")
		Write-Information -MessageData "" -InformationAction Continue
		Write-Verbose -Message "https://massgrave.dev/genuine-installation-media" -Verbosed
		Write-Information -MessageData "" -InformationAction Continue

		# Try to display available AVs
		try
		{
			Get-CimInstance -ClassName AntiVirusProduct -Namespace root/SecurityCenter2 -ErrorAction Stop
		}
		catch {}

		Write-Verbose -Message $Localization.AskQuestion -Verbose
		Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://t.me/sophianews" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Check whether Microsoft Defender is a default AV
	$InstalledAVs = Get-CimInstance -ClassName AntiVirusProduct -Namespace root/SecurityCenter2
	if (($InstalledAVs.displayName | Measure-Object).Count -gt 1)
	{
		$Global:DefenderDefaultAV = $false
		$productState = ($InstalledAVs | Where-Object -FilterScript {$_.instanceGuid -eq "{D68DDC3A-831F-4fae-9E44-DA132C1ACF46}"}).productState
		$DefenderState = ('0x{0:x}' -f $productState).Substring(3, 2)
		if ($DefenderState -notmatch "00|01")
		{
			# Defender is a default AV
			$Global:DefenderDefaultAV = $true
		}
	}
	else
	{
		# Defender is a default AV
		$Global:DefenderDefaultAV = $true
	}

	# Check whether Controlled Folder Access is enabled
	if ((Get-MpPreference).EnableControlledFolderAccess -eq 1)
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message $Localization.DisableControlledFolderAccess
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message $Localization.AskQuestion -Verbose
		Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://t.me/sophianews" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		Start-Process -FilePath "windowsdefender://RansomwareProtection"

		$Global:Failed = $true

		exit
	}
	#endregion Defender checks

	# Check for a pending reboot
	$PendingActions = [Array]::TrueForAll(@(
		# CBS pending
		"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending",
		"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootInProgress",
		"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\PackagesPending",
		# Windows Update pending
		"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\PostRebootReporting",
		"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
	),
	[Predicate[string]]{
		param($PendingAction)

		Test-Path -Path $PendingAction
	})
	if ($PendingActions)
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message $Localization.RebootPending
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message $Localization.AskQuestion -Verbose
		Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://t.me/sophianews" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Check whether BitLocker drive encryption is off, despite drive is encrypted
	if (Get-BitLockerVolume -MountPoint $env:SystemDrive | Where-Object -FilterScript {($_.ProtectionStatus -eq "Off") -and ($_.VolumeStatus -eq "FullyEncrypted")})
	{
		Write-Warning -Message $Localization.SystemDriveEncryptedBitLockerDisabled
		Write-Verbose -Message "https://www.neowin.net/guides/how-to-remove-bitlocker-drive-encryption-in-windows-11/" -Verbose

		do
		{
			$Choice = Show-Menu -Menu @($Yes, $No) -Default 2

			switch ($Choice)
			{
				$Yes
				{
					try
					{
						Disable-BitLocker -MountPoint $env:SystemDrive -ErrorAction Stop
						Write-Error -Message "https://www.neowin.net/guides/how-to-remove-bitlocker-drive-encryption-in-windows-11/" -ErrorAction SilentlyContinue
					}
					catch
					{
						Write-Information -MessageData "" -InformationAction Continue
						Write-Warning -Message (($Localization.WindowsComponentStabilityDisrupted -f $_.InvocationInfo.Line.Replace(" -ErrorAction Stop", "").Trim()), $Localization.ReinstallWindows -join " ")
						Write-Warning -Message $Error.Exception
						Write-Information -MessageData "" -InformationAction Continue
						Write-Verbose -Message "https://massgrave.dev/genuine-installation-media" -Verbose
						Write-Information -MessageData "" -InformationAction Continue

						Write-Verbose -Message $Localization.AskQuestion -Verbose
						Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
						Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
						Write-Verbose -Message "https://t.me/sophianews" -Verbose
						Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

						$Global:Failed = $true

						exit
					}
				}
				$No
				{
					continue
				}
				$KeyboardArrows {}
			}
		}
		until ($Choice -ne $KeyboardArrows)
	}

	# Check whether UEFI has latest certificates installed
	try
	{
		if (Confirm-SecureBootUEFI)
		{
			if ([System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI -Name db).Bytes) -notmatch "Windows UEFI CA 2023")
			{
				Write-Information -MessageData "" -InformationAction Continue
				Write-Verbose -Message $Localization.UpdateUEFICertificates -Verbose
				Write-Error -Message $Localization.UpdateUEFICertificates -ErrorAction SilentlyContinue

				Write-Information -MessageData "" -InformationAction Continue
				Write-Warning -Message "https://techcommunity.microsoft.com/blog/windows-itpro-blog/updating-microsoft-secure-boot-keys/4055324"
				Write-Warning -Message "https://techcommunity.microsoft.com/blog/hardware-dev-center/signing-with-the-new-2023-microsoft-uefi-certificates-what-submitters-need-to-kn/4455787"

				do
				{
					$Choice = Show-Menu -Menu @($Yes, $No) -Default 2

					switch ($Choice)
					{
						$Yes
						{
							Write-Information -MessageData "" -InformationAction Continue
							Write-Error -Message "https://techcommunity.microsoft.com/blog/windows-itpro-blog/updating-microsoft-secure-boot-keys/4055324" -ErrorAction SilentlyContinue
							Write-Error -Message "https://techcommunity.microsoft.com/blog/hardware-dev-center/signing-with-the-new-2023-microsoft-uefi-certificates-what-submitters-need-to-kn/4455787" -ErrorAction SilentlyContinue

							Start-Process -FilePath "https://techcommunity.microsoft.com/blog/windows-itpro-blog/updating-microsoft-secure-boot-keys/4055324"
							Start-Process -FilePath "https://techcommunity.microsoft.com/blog/hardware-dev-center/signing-with-the-new-2023-microsoft-uefi-certificates-what-submitters-need-to-kn/4455787"
						}
						$No
						{
							continue
						}
						$KeyboardArrows {}
					}
				}
				until ($Choice -ne $KeyboardArrows)
			}
		}
		else
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message $Localization.EnableSecureBoot -Verbose
			Write-Error -Message $Localization.EnableSecureBoot -ErrorAction SilentlyContinue
			Write-Verbose -Message "https://support.microsoft.com/en-US/Windows/Security/DeviceSecurity/windows-11-and-secure-boot" -Verbose
			Write-Error -Message "https://support.microsoft.com/en-US/Windows/Security/DeviceSecurity/windows-11-and-secure-boot" -ErrorAction SilentlyContinue
		}
	}
	catch
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message (($Localization.WindowsComponentStabilityDisrupted -f "Confirm-SecureBootUEFI"), $Localization.ReinstallWindows -join " ")
		Write-Information -MessageData "" -InformationAction Continue
		Write-Verbose -Message "https://massgrave.dev/genuine-installation-media" -Verbose
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message $Localization.AskQuestion -Verbose
		Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://t.me/sophianews" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	$WINDOWS_LONG = [WinAPI.Winbrand]::BrandingFormatString("%WINDOWS_LONG%")
	if (($WINDOWS_LONG -notmatch "Windows 11") -or ($WINDOWS_LONG -match "LTSC"))
	{
		Write-Information -MessageData "" -InformationAction Continue

		# Windows 11 Pro
		$Windows_Long = [WinAPI.Winbrand]::BrandingFormatString("%WINDOWS_LONG%")
		# e.g. 25H2
		$DisplayVersion = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows nt\CurrentVersion" -Name DisplayVersion

		Write-Warning -Message ($Localization.WrongSophiaScriptVersion -f $Windows_Long, $DisplayVersion)
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message $Localization.AskQuestion -Verbose
		Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://t.me/sophianews" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		# Receive updates for other Microsoft products when you update Windows
		New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name AllowMUUpdateService -PropertyType DWord -Value 1 -Force

		# Check for updates
		& "$env:SystemRoot\System32\UsoClient.exe" StartInteractiveScan

		$Global:Failed = $true

		exit
	}

	# Check whether current terminal is Windows Terminal
	if ($env:WT_SESSION)
	{
		# Check whether Windows Terminal version is higher than 1.24
		# Get Windows Terminal process PID
		$ParentProcessID = (Get-CimInstance -ClassName Win32_Process -Filter ProcessID=$PID).ParentProcessID
		$WindowsTerminalVersion = (Get-Process -Id $ParentProcessID).FileVersion
		# FileVersion has four properties while $WindowsTerminalVersion has only three, unless the [System.Version] accelerator fails
		$WindowsTerminalVersion = "{0}.{1}.{2}" -f $WindowsTerminalVersion.Split(".")

		if ([System.Version]$WindowsTerminalVersion -lt [System.Version]"1.24.0")
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message $Localization.UpdateWindowsTerminal
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message $Localization.AskQuestion -Verbose
			Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://t.me/sophianews" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			Start-Process -FilePath "ms-windows-store://pdp/?productid=9N0DX20HK701"

			# Check for UWP apps updates
			Get-CimInstance -ClassName MDM_EnterpriseModernAppManagement_AppManagement01 -Namespace root/CIMV2/mdm/dmmap | Invoke-CimMethod -MethodName UpdateScanMethod

			$Global:Failed = $true

			exit
		}
	}

	# Check whether Windows build is the latest one
	try
	{
		# https://github.com/farag2/Sophia-Script-for-Windows/blob/main/supported_windows_builds.json
		$Parameters = @{
			Uri                      = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/main/supported_windows_builds.json"
			UseBasicParsing          = $true
			ConnectionTimeoutSeconds = 5
			Verbose                  = $true
		}
		$Response = Invoke-RestMethod @Parameters

		$LatestSupportedMinorBuild = $Response.Windows_11
		$LatestSupportedMajorBuild = $Response.Windows_11_Major
	}
	catch [System.Net.Http.HttpRequestException]
	{
		$LatestSupportedMinorBuild = 9168
		$LatestSupportedMajorBuild = 26200

		Write-Warning -Message ($Localization.NoConnectionEstablished -f "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/main/supported_windows_builds.json")
		Write-Error -Message ($Localization.NoConnectionEstablished -f "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/main/supported_windows_builds.json") -ErrorAction SilentlyContinue
	}

	# Detect Windows build version
	switch ((Get-CimInstance -ClassName CIM_OperatingSystem).BuildNumber)
	{
		{$_ -lt 26200}
		{
			# Check Windows minor build version
			$CurrentBuild = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows nt\CurrentVersion" -Name CurrentBuild
			$UBR = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows nt\CurrentVersion" -Name UBR
			# Windows 11 Pro
			$Windows_Long = [WinAPI.Winbrand]::BrandingFormatString("%WINDOWS_LONG%")
			# e.g. 25H2
			$DisplayVersion = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows nt\CurrentVersion" -Name DisplayVersion

			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message ($Localization.UpdateWindowsBuild -f $LatestSupportedMajorBuild, $LatestSupportedMinorBuild, $Windows_Long, $DisplayVersion, $CurrentBuild, $UBR)
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message $Localization.AskQuestion -Verbose
			Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://t.me/sophianews" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			# Receive updates for other Microsoft products when you update Windows
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name AllowMUUpdateService -PropertyType DWord -Value 1 -Force

			# Check for UWP apps updates
			Get-CimInstance -ClassName MDM_EnterpriseModernAppManagement_AppManagement01 -Namespace root/CIMV2/mdm/dmmap | Invoke-CimMethod -MethodName UpdateScanMethod

			# Check for updates
			& "$env:SystemRoot\System32\UsoClient.exe" StartInteractiveScan

			# Open the "Windows Update" page
			Start-Process -FilePath "ms-settings:windowsupdate"

			$Global:Failed = $true

			exit
		}
		"26200"
		{
			# We may use Test-Path -Path variable:LatestSupportedBuild
			if ((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows nt\CurrentVersion" -Name UBR) -lt $LatestSupportedMinorBuild)
			{
				# Check Windows minor build version
				$CurrentBuild = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows nt\CurrentVersion" -Name CurrentBuild
				$UBR = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows nt\CurrentVersion" -Name UBR
				# Windows 11 Pro
				$Windows_Long = [WinAPI.Winbrand]::BrandingFormatString("%WINDOWS_LONG%")
				# e.g. 25H2
				$DisplayVersion = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows nt\CurrentVersion" -Name DisplayVersion

				Write-Information -MessageData "" -InformationAction Continue
				Write-Warning -Message ($Localization.UpdateWindowsBuild -f $LatestSupportedMajorBuild, $LatestSupportedMinorBuild, $Windows_Long, $DisplayVersion, $CurrentBuild, $UBR)
				Write-Information -MessageData "" -InformationAction Continue

				Write-Verbose -Message $Localization.AskQuestion -Verbose
				Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
				Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
				Write-Verbose -Message "https://t.me/sophianews" -Verbose
				Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

				# Receive updates for other Microsoft products when you update Windows
				New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name AllowMUUpdateService -PropertyType DWord -Value 1 -Force

				# Check for UWP apps updates
				Get-CimInstance -ClassName MDM_EnterpriseModernAppManagement_AppManagement01 -Namespace root/CIMV2/mdm/dmmap | Invoke-CimMethod -MethodName UpdateScanMethod

				# Check for updates
				& "$env:SystemRoot\System32\UsoClient.exe" StartInteractiveScan

				# Open the "Windows Update" page
				Start-Process -FilePath "ms-settings:windowsupdate"

				$Global:Failed = $true

				exit
			}
		}
	}

	# Enable back the SysMain service if it was disabled by harmful tweakers
	if ((Get-Service -Name SysMain).Status -eq "Stopped")
	{
		Get-Service -Name SysMain | Set-Service -StartupType Automatic
		Get-Service -Name SysMain | Start-Service

		Start-Process -FilePath "https://www.outsidethebox.ms/19318"
	}

	# Automatically manage paging file size for all drives
	if (-not (Get-CimInstance -ClassName CIM_ComputerSystem).AutomaticManagedPageFile)
	{
		Get-CimInstance -ClassName CIM_ComputerSystem | Set-CimInstance -Property @{AutomaticManagedPageFile = $true}
	}

	# If you do not use old applications, there's no need to force old applications based on legacy .NET Framework 2.0, 3.0, or 3.5 to use .NET Framework 4.8.1
	Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\.NETFramework, HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework -Name OnlyUseLatestCLR -Force -ErrorAction Ignore

	# PowerShell 5.1 (7.5 too) interprets 8.3 file name literally, if an environment variable contains a non-Latin word
	# https://github.com/PowerShell/PowerShell/issues/21070
	Get-Item -Path "$env:TEMP\LGPO.txt" -Force -ErrorAction Ignore | Remove-Item -Force -ErrorAction Ignore

	# Save all opened folders in order to restore them after File Explorer restart
	$Global:OpenedFolders = {(New-Object -ComObject Shell.Application).Windows() | ForEach-Object -Process {$_.Document.Folder.Self.Path}}.Invoke()

	Clear-Host

	# https://patorjk.com/software/taag/#p=display&f=Tmplr
	Write-Information -MessageData "┏┓    ┓ •    ┏┓   •     ┏      ┓ ┏•   ┓ " -InformationAction Continue
	Write-Information -MessageData "┗┓┏┓┏┓┣┓┓┏┓  ┗┓┏┏┓┓┏┓╋  ╋┏┓┏┓  ┃┃┃┓┏┓┏┫┏┓┓┏┏┏" -InformationAction Continue
	Write-Information -MessageData "┗┛┗┛┣┛┛┗┗┗┻  ┗┛┗┛ ┗┣┛┗  ┛┗┛┛   ┗┻┛┗┛┗┗┻┗┛┗┻┛┛" -InformationAction Continue
	Write-Information -MessageData "    ┛              ┛                   " -InformationAction Continue

	Write-Verbose -Message $Localization.AskQuestion -Verbose
	Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
	Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
	Write-Verbose -Message "https://t.me/sophianews" -Verbose
	Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

	Write-Information -MessageData "" -InformationAction Continue
	Write-Verbose -Message $Localization.DonateToastTitle -Verbose
	Write-Verbose -Message "https://ko-fi.com/farag" -Verbose
	Write-Information -MessageData "" -InformationAction Continue

	# Display a warning message about whether a user has customized the preset file
	if ($Warning)
	{
		# Get the name of a preset (e.g Sophia.ps1) regardless it was named
		[string]$PresetName = ((Get-PSCallStack).Position | Where-Object -FilterScript {($_.Text -match "InitialActions") -and ($_.Text -notmatch "Get-PSCallStack")}).File
		Write-Verbose -Message ($Localization.CheckSophiaScriptPreset -f $PresetName) -Verbose

		do
		{
			$Choice = Show-Menu -Menu @($Yes, $No) -Default 2

			switch ($Choice)
			{
				$Yes
				{
					continue
				}
				$No
				{
					Invoke-Item -Path $PresetName

					Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows#how-to-use" -Verbose

					Write-Verbose -Message $Localization.AskQuestion -Verbose
					Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
					Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
					Write-Verbose -Message "https://t.me/sophianews" -Verbose
					Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

					$Global:Failed = $true

					exit
				}
				$KeyboardArrows {}
			}
		}
		until ($Choice -ne $KeyboardArrows)
	}
}
