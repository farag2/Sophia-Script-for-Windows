<#
	.SYNOPSIS
	Initial checks before proceeding to module execution

	.VERSION
	7.1.1

	.DATE
	13.02.2026

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

	$Host.UI.RawUI.WindowTitle = "Sophia Script for Windows 11 v7.1.1 | Made with $([System.Char]::ConvertFromUtf32(0x1F497)) of Windows | $([System.Char]0x00A9) Team Sophia, 2014$([System.Char]0x2013)2026"

	# Unblock all files in the script folder by removing the Zone.Identifier alternate data stream with a value of "3"
	Get-ChildItem -Path $PSScriptRoot\..\..\ -File -Recurse -Force | Unblock-File

	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

	# Progress bar can significantly impact cmdlet performance
	# https://github.com/PowerShell/PowerShell/issues/2138
	$Global:ProgressPreference = "SilentlyContinue"

	# Checking whether all files were expanded before running
	$ScriptFiles = [Array]::TrueForAll(@(
		"$PSScriptRoot\..\..\Localizations\de-DE\Sophia.psd1",
		"$PSScriptRoot\..\..\Localizations\en-US\Sophia.psd1",
		"$PSScriptRoot\..\..\Localizations\es-ES\Sophia.psd1",
		"$PSScriptRoot\..\..\Localizations\fr-FR\Sophia.psd1",
		"$PSScriptRoot\..\..\Localizations\hu-HU\Sophia.psd1",
		"$PSScriptRoot\..\..\Localizations\it-IT\Sophia.psd1",
		"$PSScriptRoot\..\..\Localizations\pl-PL\Sophia.psd1",
		"$PSScriptRoot\..\..\Localizations\pt-BR\Sophia.psd1",
		"$PSScriptRoot\..\..\Localizations\ru-RU\Sophia.psd1",
		"$PSScriptRoot\..\..\Localizations\tr-TR\Sophia.psd1",
		"$PSScriptRoot\..\..\Localizations\uk-UA\Sophia.psd1",
		"$PSScriptRoot\..\..\Localizations\zh-CN\Sophia.psd1",

		"$PSScriptRoot\..\..\Module\Private\Get-Hash.ps1",
		"$PSScriptRoot\..\..\Module\Private\InitialActions.ps1",
		"$PSScriptRoot\..\..\Module\Private\PostActions.ps1",
		"$PSScriptRoot\..\..\Module\Private\Set-KnownFolderPath.ps1",
		"$PSScriptRoot\..\..\Module\Private\Set-Policy.ps1",
		"$PSScriptRoot\..\..\Module\Private\Set-UserShellFolder.ps1",
		"$PSScriptRoot\..\..\Module\Private\Show-Menu.ps1",
		"$PSScriptRoot\..\..\Module\Private\Write-AdditionalKeys.ps1",
		"$PSScriptRoot\..\..\Module\Private\Write-ExtensionKeys.ps1",

		"$PSScriptRoot\..\..\Module\Sophia.psm1",
		"$PSScriptRoot\..\..\Manifest\SophiaScript.psd1",
		"$PSScriptRoot\..\..\Import-TabCompletion.ps1",

		"$PSScriptRoot\..\..\Binaries\LGPO.exe"
	),
	[Predicate[string]]{
		param($File)

		Test-Path -Path $File
	})
	if (-not $ScriptFiles)
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message "Required files are missing. Please, do not download the whole code from the repository, but download archive from release page for you system."
		Write-Information -MessageData "" -InformationAction Continue

		Start-Process -FilePath "https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"

		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Try to import localizations
	try
	{
		Import-LocalizedData -BindingVariable Global:Localization -UICulture $PSUICulture -BaseDirectory $PSScriptRoot\..\..\Localizations -FileName Sophia -ErrorAction Stop
	}
	catch
	{
		# If there's no folder with current localization ID ($PSUICulture), then import en-US localization
		Import-LocalizedData -BindingVariable Global:Localization -UICulture en-US -BaseDirectory $PSScriptRoot\..\..\Localizations -FileName Sophia
	}

	# Check CPU architecture
	$Caption = (Get-CimInstance -ClassName CIM_Processor).Caption
	if (($Caption -notmatch "AMD64") -and ($Caption -notmatch "Intel64"))
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.UnsupportedArchitecture -f $Caption)
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Checking whether the current module version is the latest one
	try
	{
		# https://github.com/farag2/Sophia-Script-for-Windows/blob/master/sophia_script_versions.json
		$Parameters = @{
			Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json"
			Verbose         = $true
			UseBasicParsing = $true
		}
		$LatestRelease = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_11_PowerShell_5_1
		$CurrentRelease = (Get-Module -Name SophiaScript).Version.ToString()

		if ([System.Version]$LatestRelease -gt [System.Version]$CurrentRelease)
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message ($Localization.UnsupportedRelease -f $LatestRelease)
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/releases/latest" -Verbose
			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			$Global:Failed = $true

			exit
		}
	}
	catch [System.Net.WebException]
	{
		Write-Warning -Message ($Localization.NoResponse -f "https://github.com")
		Write-Error -Message ($Localization.NoResponse -f "https://github.com") -ErrorAction SilentlyContinue
	}

	# Checking whether the script was run via PowerShell 5.1
	if ($PSVersionTable.PSVersion.Major -ne 5)
	{
		Write-Information -MessageData "" -InformationAction Continue
		$MandatoryPSVersion = (Import-PowershellDataFile -Path "$PSScriptRoot\..\..\Manifest\SophiaScript.psd1").PowerShellVersion
		Write-Warning -Message ($Localization.UnsupportedPowerShell -f $PSVersionTable.PSVersion.Major, $PSVersionTable.PSVersion.Minor, $MandatoryPSVersion)
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# https://github.com/PowerShell/PowerShell/issues/21070
	$Global:CompilerParameters                  = [System.CodeDom.Compiler.CompilerParameters]::new("System.dll")
	$Global:CompilerParameters.TempFiles        = [System.CodeDom.Compiler.TempFileCollection]::new($env:TEMP, $false)
	$Global:CompilerParameters.GenerateInMemory = $true

	$Signature = @{
		Namespace          = "WinAPI"
		Name               = "GetStrings"
		Language           = "CSharp"
		UsingNamespace     = "System.Text"
		CompilerParameters = $CompilerParameters
		MemberDefinition   = @"
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

// Get string from other DLLs
[DllImport("shlwapi.dll", CharSet=CharSet.Unicode)]
private static extern int SHLoadIndirectString(string pszSource, StringBuilder pszOutBuf, int cchOutBuf, string ppvReserved);

public static string GetIndirectString(string indirectString)
{
	try
	{
		int returnValue;
		StringBuilder lptStr = new StringBuilder(1024);
		returnValue = SHLoadIndirectString(indirectString, lptStr, 1024, null);

		if (returnValue == 0)
		{
			return lptStr.ToString();
		}
		else
		{
			return null;
			// return "SHLoadIndirectString Failure: " + returnValue;
		}
	}
	catch // (Exception ex)
	{
		return null;
		// return "Exception Message: " + ex.Message;
	}
}
"@
	}
	if (-not ("WinAPI.GetStrings" -as [type]))
	{
		try
		{
			Add-Type @Signature -ErrorAction Stop
		}
		catch
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message $Localization.CodeCompilationFailedWarning
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			$Global:Failed = $true

			exit
		}
	}

	$Signature = @{
		Namespace          = "WinAPI"
		Name               = "ForegroundWindow"
		Language           = "CSharp"
		CompilerParameters = $CompilerParameters
		MemberDefinition   = @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

[DllImport("user32.dll")]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool SetForegroundWindow(IntPtr hWnd);
"@
	}

	if (-not ("WinAPI.ForegroundWindow" -as [type]))
	{
		try
		{
			Add-Type @Signature -ErrorAction Stop
		}
		catch
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message $Localization.CodeCompilationFailedWarning
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			$Global:Failed = $true

			exit
		}
	}

	# Extract the localized "Browse" string from %SystemRoot%\System32\shell32.dll
	$Global:Browse = [WinAPI.GetStrings]::GetString(9015)
	# Extract the localized "&No" string from %SystemRoot%\System32\shell32.dll
	$Global:No = [WinAPI.GetStrings]::GetString(33232).Replace("&", "")
	# Extract the localized "&Yes" string from %SystemRoot%\System32\shell32.dll
	$Global:Yes = [WinAPI.GetStrings]::GetString(33224).Replace("&", "")
	$Global:KeyboardArrows = $Localization.KeyboardArrows -f [System.Char]::ConvertFromUtf32(0x2191), [System.Char]::ConvertFromUtf32(0x2193)
	# Extract the localized "Skip" string from %SystemRoot%\System32\shell32.dll
	$Global:Skip = [WinAPI.GetStrings]::GetString(16956)

	# Check the language mode
	if ($ExecutionContext.SessionState.LanguageMode -ne "FullLanguage")
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message $Localization.UnsupportedLanguageMode
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_language_modes" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Checking whether the logged-in user is an admin
	$CurrentUserName = (Get-Process -Id $PID -IncludeUserName).UserName | Split-Path -Leaf
	$LoginUserName = (Get-CimInstance -ClassName Win32_Process -Filter "name='explorer.exe'" | Invoke-CimMethod -MethodName GetOwner | Select-Object -First 1).User
	if ($CurrentUserName -ne $LoginUserName)
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.LoggedInUserNotAdmin -f $CurrentUserName, $LoginUserName)
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Checking whether the script was run in PowerShell ISE or VS Code
	if (($Host.Name -match "ISE") -or ($env:TERM_PROGRAM -eq "vscode"))
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.UnsupportedHost -f $Host.Name.Replace("Host", ""))
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Checking whether Windows was broken by 3rd party harmful tweakers, trojans, or custom Windows images
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
			if ($Tweakers[$Tweaker] -eq "HKCU:\Software\Win 10 Tweaker")
			{
				Write-Information -MessageData "" -InformationAction Continue
				Write-Warning -Message $Localization.Win10TweakerWarning
				Write-Information -MessageData "" -InformationAction Continue

				Write-Verbose -Message "https://youtu.be/na93MS-1EkM" -Verbose
				Write-Verbose -Message "https://pikabu.ru/story/byekdor_v_win_10_tweaker_ili_sovremennyie_metodyi_borbyi_s_piratstvom_8227558" -Verbose
				Write-Verbose -Message "https://massgrave.dev/genuine-installation-media" -Verbose
				Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
				Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

				$Global:Failed = $true

				exit
			}

			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message ($Localization.TweakerWarning -f $Tweaker)
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message "https://massgrave.dev/genuine-installation-media" -Verbose
			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			$Global:Failed = $true

			exit
		}
	}

	# Checking whether Windows was broken by 3rd party harmful tweakers, trojans, or custom Windows images
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
			Write-Warning -Message ($Localization.TweakerWarning -f $Tweaker)
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message "https://massgrave.dev/genuine-installation-media" -Verbose
			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			$Global:Failed = $true

			exit
		}
	}

	Write-Information -MessageData "" -InformationAction Continue
	# Extract the localized "Please wait..." string from %SystemRoot%\System32\shell32.dll
	Write-Verbose -Message ([WinAPI.GetStrings]::GetString(12612)) -Verbose
	Write-Information -MessageData "" -InformationAction Continue

	# Check whether third-party enries added to hosts file
	foreach ($Item in @(Get-Content -Path "$env:SystemRoot\System32\drivers\etc\hosts" -Force))
	{
		if (-not ([string]::IsNullOrEmpty($Item) -or $Item.StartsWith("#")))
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message $Localization.HostsWarning -Verbose

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

						Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows" -Verbose
						Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
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

	# Checking whether EventLog service is running in order to be sire that Event Logger is enabled
	if ((Get-Service -Name EventLog).Status -eq "Stopped")
	{
		Write-Information -MessageData "" -InformationAction Continue
		# Extract the localized "Event Viewer" string from %SystemRoot%\System32\shell32.dll
		Write-Warning -Message ($Localization.WindowsComponentBroken -f $([WinAPI.GetStrings]::GetString(22029)))
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://massgrave.dev/genuine-installation-media" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Checking whether the Microsoft Store and Windows Feature Experience Pack was removed
	$UWPComponents = [Array]::TrueForAll(@(
		"Microsoft.WindowsStore",
		"MicrosoftWindows.Client.CBS"
	),
	[Predicate[string]]{
		param($UWPComponent)

		(Get-AppxPackage -Name $UWPComponent).Status -eq "OK"
	})
	if (-not $UWPComponents)
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.WindowsComponentBroken -f "UWP")
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://massgrave.dev/genuine-installation-media" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	#region Defender checks
	# Checking whether necessary Microsoft Defender components exists
	$Files = [Array]::TrueForAll(@(
		"$env:SystemRoot\System32\smartscreen.exe",
		"$env:SystemRoot\System32\SecurityHealthSystray.exe",
		"$env:SystemRoot\System32\CompatTelRunner.exe"
	),
	[Predicate[string]]{
		param($File)

		Test-Path -Path $File
	})
	if (-not $Files)
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.WindowsComponentBroken -f "Microsoft Defender")
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://massgrave.dev/genuine-installation-media" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Checking whether Windows Security Settings page was hidden from UI
	if ((Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name SettingsPageVisibility -ErrorAction Ignore) -match "hide:windowsdefender")
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.WindowsComponentBroken -f "Microsoft Defender")
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://massgrave.dev/genuine-installation-media" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Checking Microsoft Defender properties
	try
	{
		$AntiVirusProduct = @(
			Get-Service -Name Windefend, SecurityHealthService, wscsvc, wdFilter -ErrorAction Stop
			Get-CimInstance -ClassName MSFT_MpComputerStatus -Namespace root/Microsoft/Windows/Defender -ErrorAction Stop
			Get-CimInstance -ClassName AntiVirusProduct -Namespace root/SecurityCenter2 -ErrorAction Stop
			Get-MpPreference -ErrorAction Stop
		)
	}
	catch
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.WindowsComponentBroken -f "Microsoft Defender")
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://massgrave.dev/genuine-installation-media" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Check SecurityHealthService service
	try
	{
		Get-Service -Name SecurityHealthService -ErrorAction Stop | Start-Service -ErrorAction Stop
	}
	catch
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.WindowsComponentBroken -f "Microsoft Defender")
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://massgrave.dev/genuine-installation-media" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Check whether Microsoft Defender is a default AV
	$Global:DefenderDefaultAV = $false
	$productState = (Get-CimInstance -ClassName AntiVirusProduct -Namespace root/SecurityCenter2 -ErrorAction Stop | Where-Object -FilterScript {$_.instanceGuid -eq "{D68DDC3A-831F-4fae-9E44-DA132C1ACF46}"}).productState
	$DefenderState = ('0x{0:x}' -f $productState).Substring(3, 2)
	if ($DefenderState -notmatch "00|01")
	{
		# Defender is a default AV
		$Global:DefenderDefaultAV = $true
	}

	# Check whether Controlled Folder Access is enabled
	if ((Get-MpPreference).EnableControlledFolderAccess -eq 1)
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message $Localization.ControlledFolderAccessEnabledWarning
		Write-Information -MessageData "" -InformationAction Continue

		Start-Process -FilePath "windowsdefender://RansomwareProtection"

		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

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

		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Checking whether BitLocker encryption or decryption in process
	$BitLocker = Get-BitLockerVolume -MountPoint $env:SystemDrive | Where-Object -FilterScript {$_.VolumeStatus -notin @("FullyEncrypted", "FullyDecrypted")}
	if ($BitLocker)
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.BitLockerInOperation -f $BitLocker.EncryptionPercentage)
		Write-Verbose -Message "https://www.neowin.net/guides/how-to-remove-bitlocker-drive-encryption-in-windows-11/" -Verbose

		$BitLocker

		# Open if Windows edition is not Home
		if ((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").EditionID -ne "Core")
		{
			# Open BitLocker settings
			& "$env:SystemRoot\System32\control.exe" /name Microsoft.BitLockerDriveEncryption
		}

		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Checking whether BitLocker drive encryption is off, despite drive is encrypted
	if (Get-BitLockerVolume -MountPoint $env:SystemDrive | Where-Object -FilterScript {($_.ProtectionStatus -eq "Off") -and ($_.VolumeStatus -eq "FullyEncrypted")})
	{
		Write-Warning -Message $Localization.BitLockerAutomaticEncryption
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
					}
					catch
					{
						Write-Warning -Message $Localization.RebootPending

						Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
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

	# Get the real Windows version like %SystemRoot%\system32\winver.exe relies on
	$Signature = @{
		Namespace          = "WinAPI"
		Name               = "Winbrand"
		Language           = "CSharp"
		CompilerParameters = $CompilerParameters
		MemberDefinition   = @"
[DllImport("Winbrand.dll", CharSet = CharSet.Unicode)]
public extern static string BrandingFormatString(string sFormat);
"@
	}
	if (-not ("WinAPI.Winbrand" -as [type]))
	{
		try
		{
			Add-Type @Signature -ErrorAction Stop
		}
		catch
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message $Localization.CodeCompilationFailedWarning
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			$Global:Failed = $true

			exit
		}
	}

	if ([WinAPI.Winbrand]::BrandingFormatString("%WINDOWS_LONG%") -notmatch "Windows 11")
	{
		Write-Information -MessageData "" -InformationAction Continue

		# Windows 11 Pro
		$Windows_Long = [WinAPI.Winbrand]::BrandingFormatString("%WINDOWS_LONG%")
		# e.g. 25H2
		$DisplayVersion = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows nt\CurrentVersion" -Name DisplayVersion

		Write-Warning -Message ($Localization.UnsupportedOSBuild -f $Windows_Long, $DisplayVersion)
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose
		Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows#system-requirements" -Verbose

		# Receive updates for other Microsoft products when you update Windows
		New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name AllowMUUpdateService -PropertyType DWord -Value 1 -Force

		# Check for updates
		& "$env:SystemRoot\System32\UsoClient.exe" StartInteractiveScan

		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Checking whether current terminal is Windows Terminal
	if ($env:WT_SESSION)
	{
		# Checking whether Windows Terminal version is higher than 1.23
		# Get Windows Terminal process PID
		$ParentProcessID = (Get-CimInstance -ClassName Win32_Process -Filter ProcessID=$PID).ParentProcessID
		$WindowsTerminalVersion = (Get-Process -Id $ParentProcessID).FileVersion
		# FileVersion has four properties while $WindowsTerminalVersion has only three, unless the [System.Version] accelerator fails
		$WindowsTerminalVersion = "{0}.{1}.{2}" -f $WindowsTerminalVersion.Split(".")

		if ([System.Version]$WindowsTerminalVersion -lt [System.Version]"1.23.0")
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message $Localization.UnsupportedWindowsTerminal
			Write-Information -MessageData "" -InformationAction Continue

			Start-Process -FilePath "ms-windows-store://pdp/?productid=9N0DX20HK701"

			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose
			Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows#system-requirements" -Verbose

			# Check for UWP apps updates
			Get-CimInstance -ClassName MDM_EnterpriseModernAppManagement_AppManagement01 -Namespace root/CIMV2/mdm/dmmap | Invoke-CimMethod -MethodName UpdateScanMethod

			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			$Global:Failed = $true

			exit
		}
	}

	# Detect Windows build version
	switch ((Get-CimInstance -ClassName CIM_OperatingSystem).BuildNumber)
	{
		{$_ -lt 26100}
		{
			Write-Information -MessageData "" -InformationAction Continue

			# Windows 11 Pro
			$Windows_Long = [WinAPI.Winbrand]::BrandingFormatString("%WINDOWS_LONG%")
			# e.g. 24H2
			$DisplayVersion = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows nt\CurrentVersion" -Name DisplayVersion

			Write-Warning -Message ($Localization.UnsupportedOSBuild -f $Windows_Long, $DisplayVersion)
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose
			Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows#system-requirements" -Verbose

			# Receive updates for other Microsoft products when you update Windows
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name AllowMUUpdateService -PropertyType DWord -Value 1 -Force

			# Check for UWP apps updates
			Get-CimInstance -ClassName MDM_EnterpriseModernAppManagement_AppManagement01 -Namespace root/CIMV2/mdm/dmmap | Invoke-CimMethod -MethodName UpdateScanMethod

			# Check for updates
			& "$env:SystemRoot\System32\UsoClient.exe" StartInteractiveScan

			# Open the "Windows Update" page
			Start-Process -FilePath "ms-settings:windowsupdate"

			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			$Global:Failed = $true

			exit
		}
		"26100"
		{
			# Checking whether the current module version is the latest one
			try
			{
				# https://github.com/farag2/Sophia-Script-for-Windows/blob/master/supported_windows_builds.json
				$Parameters = @{
					Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/supported_windows_builds.json"
					Verbose         = $true
					UseBasicParsing = $true
				}
				$LatestSupportedBuild = (Invoke-RestMethod @Parameters).Windows_11
			}
			catch [System.Net.WebException]
			{
				$LatestSupportedBuild = 0

				Write-Warning -Message ($Localization.NoResponse -f "https://raw.githubusercontent.com")
				Write-Error -Message ($Localization.NoResponse -f "https://raw.githubusercontent.com") -ErrorAction SilentlyContinue
			}

			# We may use Test-Path -Path variable:LatestSupportedBuild
			if ((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows nt\CurrentVersion" -Name UBR) -lt $LatestSupportedBuild)
			{
				# Check Windows minor build version
				# https://support.microsoft.com/en-us/topic/windows-11-version-24h2-update-history-0929c747-1815-4543-8461-0160d16f15e5
				$CurrentBuild = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows nt\CurrentVersion" -Name CurrentBuild
				$UBR = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows nt\CurrentVersion" -Name UBR

				Write-Information -MessageData "" -InformationAction Continue
				Write-Warning -Message ($Localization.UpdateWarning -f $CurrentBuild, $UBR, $LatestSupportedBuild)
				Write-Information -MessageData "" -InformationAction Continue

				Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
				Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose
				Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows#system-requirements" -Verbose

				# Receive updates for other Microsoft products when you update Windows
				New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings -Name AllowMUUpdateService -PropertyType DWord -Value 1 -Force

				# Check for UWP apps updates
				Get-CimInstance -ClassName MDM_EnterpriseModernAppManagement_AppManagement01 -Namespace root/CIMV2/mdm/dmmap | Invoke-CimMethod -MethodName UpdateScanMethod

				# Check for updates
				& "$env:SystemRoot\System32\UsoClient.exe" StartInteractiveScan

				# Open the "Windows Update" page
				Start-Process -FilePath "ms-settings:windowsupdate"

				Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
				Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

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
	Get-ChildItem -Path "$env:TEMP\LGPO.txt" -Force -ErrorAction Ignore | Remove-Item -Force -ErrorAction Ignore

	# Save all opened folders in order to restore them after File Explorer restart
	$Global:OpenedFolders = {(New-Object -ComObject Shell.Application).Windows() | ForEach-Object -Process {$_.Document.Folder.Self.Path}}.Invoke()

	Clear-Host

	Write-Information -MessageData "┏┓    ┓ •    ┏┓   •     ┏      ┓ ┏•   ┓ " -InformationAction Continue
	Write-Information -MessageData "┗┓┏┓┏┓┣┓┓┏┓  ┗┓┏┏┓┓┏┓╋  ╋┏┓┏┓  ┃┃┃┓┏┓┏┫┏┓┓┏┏┏" -InformationAction Continue
	Write-Information -MessageData "┗┛┗┛┣┛┛┗┗┗┻  ┗┛┗┛ ┗┣┛┗  ┛┗┛┛   ┗┻┛┗┛┗┗┻┗┛┗┻┛┛" -InformationAction Continue
	Write-Information -MessageData "    ┛              ┛                   " -InformationAction Continue

	Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
	Write-Verbose -Message "https://t.me/sophianews" -Verbose
	Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose
	Write-Information -MessageData "" -InformationAction Continue
	Write-Verbose -Message "https://ko-fi.com/farag" -Verbose
	Write-Verbose -Message "https://boosty.to/teamsophia" -Verbose
	Write-Information -MessageData "" -InformationAction Continue

	# Display a warning message about whether a user has customized the preset file
	if ($Warning)
	{
		# Get the name of a preset (e.g Sophia.ps1) regardless it was named
		[string]$PresetName = ((Get-PSCallStack).Position | Where-Object -FilterScript {($_.Text -match "InitialActions") -and ($_.Text -notmatch "Get-PSCallStack")}).File
		Write-Verbose -Message ($Localization.CustomizationWarning -f $PresetName) -Verbose

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
					Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
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
