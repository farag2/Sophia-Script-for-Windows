<#
	.SYNOPSIS
	Initial checks before proceeding to module execution

	.VERSION
	7.0.4

	.DATE
	05.01.2026

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

	$Host.UI.RawUI.WindowTitle = "Sophia Script for Windows 11 v7.0.4 | Made with $([System.Char]::ConvertFromUtf32(0x1F497)) of Windows | $([System.Char]0x00A9) Team Sophia, 2014$([System.Char]0x2013)2026"

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
		"$PSScriptRoot\..\..\Module\Sophia.psm1",
		"$PSScriptRoot\..\..\Module\Private\InitialActions.ps1",
		"$PSScriptRoot\..\..\Module\Private\Set-Policy.ps1",
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
		Write-Warning -Message "Required files are missing. Please, do not download the whole code from the repository, but download archive for you system."
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

	# Extract the localized "Browse" string from shell32.dll
	$Global:Browse = [WinAPI.GetStrings]::GetString(9015)
	# Extract the localized "&No" string from shell32.dll
	$Global:No = [WinAPI.GetStrings]::GetString(33232).Replace("&", "")
	# Extract the localized "&Yes" string from shell32.dll
	$Global:Yes = [WinAPI.GetStrings]::GetString(33224).Replace("&", "")
	$Global:KeyboardArrows = $Localization.KeyboardArrows -f [System.Char]::ConvertFromUtf32(0x2191), [System.Char]::ConvertFromUtf32(0x2193)
	# Extract the localized "Skip" string from shell32.dll
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
		# https://github.com/Sycnex/Windows10Debloater
		Windows10Debloater  = "$env:SystemDrive\Temp\Windows10Debloater"
		# https://github.com/Fs00/Win10BloatRemover
		Win10BloatRemover   = "$env:TEMP\.net\Win10BloatRemover"
		# https://github.com/arcadesdude/BRU
		"Bloatware Removal" = "$env:SystemDrive\BRU\Bloatware-Removal*.log"
		# https://www.youtube.com/GHOSTSPECTRE
		"Ghost Toolbox"     = "$env:SystemRoot\System32\migwiz\dlmanifests\run.ghost.cmd"
		# https://win10tweaker.ru
		"Win 10 Tweaker"    = "HKCU:\Software\Win 10 Tweaker"
		# https://boosterx.ru
		BoosterX            = "$env:ProgramFiles\GameModeX\GameModeX.exe"
		# https://forum.ru-board.com/topic.cgi?forum=5&topic=14285&start=400#11
		"Defender Control"  = "$env:APPDATA\Defender Control"
		# https://forum.ru-board.com/topic.cgi?forum=5&topic=14285&start=260#12
		"Defender Switch"   = "$env:ProgramData\DSW"
		# https://revi.cc
		"Revision Tool"     = "${env:ProgramFiles(x86)}\Revision Tool"
		# https://www.youtube.com/watch?v=L0cj_I6OF2o
		"WinterOS Tweaker"  = "$env:SystemRoot\WinterOS*"
		# https://github.com/ThePCDuke/WinCry
		WinCry              = "$env:SystemRoot\TempCleaner.exe"
		# https://www.youtube.com/watch?v=5NBqbUUB1Pk
		WinClean             = "$env:ProgramFiles\WinClean Plus Apps"
		# https://github.com/Atlas-OS/Atlas
		AtlasOS              = "$env:SystemRoot\AtlasModules"
		# https://x.com/NPKirbyy
		KirbyOS              = "$env:ProgramData\KirbyOS"
		# https://pc-np.com
		PCNP                 = "HKCU:\Software\PCNP"
		# https://www.reddit.com/r/TronScript/
		Tron                 = "$env:SystemDrive\logs\tron"
		# https://github.com/es3n1n/defendnot
		defendnot            = "$env:SystemRoot\System32\Tasks\defendnot"
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
				Write-Verbose -Message "https://www.microsoft.com/software-download/windows11" -Verbose
				Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
				Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

				$Global:Failed = $true

				exit
			}

			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message ($Localization.TweakerWarning -f $Tweaker)
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message "https://www.microsoft.com/software-download/windows11" -Verbose
			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			$Global:Failed = $true

			exit
		}
	}

	# Checking whether Windows was broken by 3rd party harmful tweakers, trojans, or custom Windows images
	$Tweakers = @{
		# https://forum.ru-board.com/topic.cgi?forum=62&topic=30617&start=1600#14
		AutoSettingsPS   = "$(Get-Item -Path `"HKLM:\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths`" | Where-Object -FilterScript {$_.Property -match `"AutoSettingsPS`"})"
		# Flibustier custom Windows image
		Flibustier       = "$(Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\.NETFramework\Performance -Name *flibustier)"
		# https://github.com/builtbybel/Winpilot
		Winpilot         = "$((Get-ItemProperty -Path `"HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache`").PSObject.Properties | Where-Object -FilterScript {$_.Value -eq `"Winpilot`"})"
		# https://github.com/builtbybel/Bloatynosy
		Bloatynosy       = "$((Get-ItemProperty -Path `"HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache`").PSObject.Properties | Where-Object -FilterScript {$_.Value -eq `"BloatynosyNue`"})"
		# https://github.com/builtbybel/xd-AntiSpy
		"xd-AntiSpy"     = "$((Get-ItemProperty -Path `"HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache`").PSObject.Properties | Where-Object -FilterScript {$_.Value -eq `"xd-AntiSpy`"})"
		# https://forum.ru-board.com/topic.cgi?forum=5&topic=50519
		"Modern Tweaker" = "$((Get-ItemProperty -Path `"HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache`").PSObject.Properties | Where-Object -FilterScript {$_.Value -eq `"Modern Tweaker`"})"
		# https://github.com/ChrisTitusTech/winutil
		winutil          = "$(Get-CimInstance -Namespace root/CIMV2/power -ClassName Win32_PowerPlan | Where-Object -FilterScript {$_.ElementName -match `"ChrisTitus`"})"
		# https://discord.com/invite/kernelos
		KernelOS         = "$(Get-CimInstance -Namespace root/CIMV2/power -ClassName Win32_PowerPlan | Where-Object -FilterScript {$_.ElementName -match `"KernelOS`"})"
		# https://discord.com/invite/9ZCgxhaYV6
		ChlorideOS       = "$(Get-Volume | Where-Object -FilterScript {$_.FileSystemLabel -eq `"ChlorideOS`"})"
		# https://crystalcry.ru
		CrystalCry       = "$(Get-Item -Path HKLM:\SOFTWARE\CrystalCry -ErrorAction Ignore)"
	}
	foreach ($Tweaker in $Tweakers.Keys)
	{
		if ($Tweakers[$Tweaker])
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message ($Localization.TweakerWarning -f $Tweaker)
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message "https://www.microsoft.com/software-download/windows11" -Verbose
			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			$Global:Failed = $true

			exit
		}
	}

	# Remove harmful blocked DNS domains list from https://github.com/schrebra/Windows.10.DNS.Block.List
	Get-NetFirewallRule -DisplayName Block.MSFT* -ErrorAction Ignore | Remove-NetFirewallRule

	# Remove firewalled IP addresses that block Microsoft recourses added by harmful tweakers
	# https://wpd.app
	Get-NetFirewallRule -DisplayName "Blocker MicrosoftTelemetry*", "Blocker MicrosoftExtra*", "windowsSpyBlocker*" -ErrorAction Ignore | Remove-NetFirewallRule

	Write-Information -MessageData "" -InformationAction Continue
	# Extract the localized "Please wait..." string from shell32.dll
	Write-Verbose -Message ([WinAPI.GetStrings]::GetString(12612)) -Verbose
	Write-Information -MessageData "" -InformationAction Continue

	# Check if third-party enries added to hosts file
	foreach ($Item in @(Get-Content -Path "$env:SystemRoot\System32\drivers\etc\hosts" -Force))
	{
		if (-not ([string]::IsNullOrEmpty($Item) -or $Item.StartsWith("#")))
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Verbose -Message ($Localization.HostsWarning -f "$env:SystemRoot\System32\drivers\etc\hosts") -Verbose

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

	# Remove IP addresses from hosts file that block Microsoft recourses added by WindowsSpyBlocker
	# https://github.com/crazy-max/WindowsSpyBlocker
	try
	{
		# Checking whether https://github.com is alive
		$Parameters = @{
			Uri              = "https://github.com"
			Method           = "Head"
			DisableKeepAlive = $true
			UseBasicParsing  = $true
		}
		(Invoke-WebRequest @Parameters).StatusCode

		Clear-Variable -Name IPArray -ErrorAction Ignore

		# https://github.com/crazy-max/WindowsSpyBlocker/tree/master/data/hosts
		$Parameters = @{
			Uri             = "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/extra.txt"
			UseBasicParsing = $true
			Verbose         = $true
		}
		$extra = (Invoke-WebRequest @Parameters).Content

		$Parameters = @{
			Uri             = "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/extra_v6.txt"
			UseBasicParsing = $true
			Verbose         = $true
		}
		$extra_v6 = (Invoke-WebRequest @Parameters).Content

		$Parameters = @{
			Uri             = "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
			UseBasicParsing = $true
			Verbose         = $true
		}
		$spy = (Invoke-WebRequest @Parameters).Content

		$Parameters = @{
			Uri             = "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy_v6.txt"
			UseBasicParsing = $true
			Verbose         = $true
		}
		$spy_v6 = (Invoke-WebRequest @Parameters).Content

		$Parameters = @{
			Uri             = "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/update.txt"
			UseBasicParsing = $true
			Verbose         = $true
		}
		$update = (Invoke-WebRequest @Parameters).Content

		$Parameters = @{
			Uri             = "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/update_v6.txt"
			UseBasicParsing = $true
			Verbose         = $true
		}
		$update_v6 = (Invoke-WebRequest @Parameters).Content

		$IPArray += $extra, $extra_v6, $spy, $spy_v6, $update, $update_v6
		# Split the Array variable content
		$IPArray = $IPArray -split "`r?`n" | Where-Object -FilterScript {$_ -notmatch "#"}

		Write-Information -MessageData "" -InformationAction Continue
		# Extract the localized "Please wait..." string from shell32.dll
		Write-Verbose -Message ([WinAPI.GetStrings]::GetString(12612)) -Verbose
		Write-Information -MessageData "" -InformationAction Continue

		# Checking whether hosts contains any of string from $IPArray array
		if ((Get-Content -Path "$env:SystemRoot\System32\drivers\etc\hosts" -Encoding Default -Force | ForEach-Object -Process {$_.Trim()} | ForEach-Object -Process {
			($_ -ne "") -and ($_ -ne " ") -and (-not $_.StartsWith("#")) -and ($IPArray -split "`r?`n" | Select-String -Pattern $_)
		}) -contains $true)
		{
			Write-Warning -Message ($Localization.TweakerWarning -f "WindowsSpyBlocker")

			# Clear hosts file
			$hosts = Get-Content -Path "$env:SystemRoot\System32\drivers\etc\hosts" -Encoding Default -Force
			$hosts | ForEach-Object -Process {
				if (($_ -ne "") -and (-not $_.StartsWith("#")) -and ($IPArray -split "`r?`n" | Select-String -Pattern $_.Trim()))
				{
					$hostsData = $_
					$hosts = $hosts | Where-Object -FilterScript {$_ -notmatch $hostsData}
				}
			}
			# Save in UTF8 without BOM
			$hosts | Set-Content -Path "$env:SystemRoot\System32\drivers\etc\hosts" -Encoding Default -Force

			Start-Process -FilePath notepad.exe -ArgumentList "$env:SystemRoot\System32\drivers\etc\hosts"
		}
	}
	catch [System.Net.WebException]
	{
		Write-Warning -Message ($Localization.NoResponse -f "https://github.com")
		Write-Error -Message ($Localization.NoResponse -f "https://github.com") -ErrorAction SilentlyContinue
	}

	# Checking whether Windows Feature Experience Pack was removed by harmful tweakers
	if (-not (Get-AppxPackage -Name MicrosoftWindows.Client.CBS))
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.WindowsComponentBroken -f "Windows Feature Experience Pack")
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://www.microsoft.com/software-download/windows11" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Checking whether EventLog service is running in order to be sire that Event Logger is enabled
	if ((Get-Service -Name EventLog).Status -eq "Stopped")
	{
		Write-Information -MessageData "" -InformationAction Continue
		# Extract the localized "Event Viewer" string from shell32.dll
		Write-Warning -Message ($Localization.WindowsComponentBroken -f $([WinAPI.GetStrings]::GetString(22029)))
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://www.microsoft.com/software-download/windows11" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Checking whether the Microsoft Store being an important system component was removed
	if (-not (Get-AppxPackage -Name Microsoft.WindowsStore))
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.WindowsComponentBroken -f "Microsoft Store")
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://www.microsoft.com/software-download/windows11" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	#region Defender checks
	# Checking whether necessary Microsoft Defender components exists
	$Files = @(
		"$env:SystemRoot\System32\smartscreen.exe",
		"$env:SystemRoot\System32\SecurityHealthSystray.exe",
		"$env:SystemRoot\System32\CompatTelRunner.exe"
	)
	foreach ($File in $Files)
	{
		if (-not (Test-Path -Path $File))
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message ($Localization.WindowsComponentBroken -f $File)
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message "https://www.microsoft.com/software-download/windows11" -Verbose
			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			$Global:Failed = $true

			exit
		}
	}

	# Checking whether Windows Security Settings page was hidden from UI
	if ([Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer", "SettingsPageVisibility", $null) -match "hide:windowsdefender")
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.WindowsComponentBroken -f "Microsoft Defender")
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://www.microsoft.com/software-download/windows11" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Check Microsoft Defender state
	if ($null -eq (Get-CimInstance -ClassName AntiVirusProduct -Namespace root/SecurityCenter2 -ErrorAction Ignore))
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.WindowsComponentBroken -f "Microsoft Defender")
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://www.microsoft.com/software-download/windows11" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Check Windows default antivirus
	try
	{
		$Global:DefenderDefaultAV = $false

		$productState = (Get-CimInstance -ClassName AntiVirusProduct -Namespace root/SecurityCenter2 | Where-Object -FilterScript {$_.instanceGuid -eq "{D68DDC3A-831F-4fae-9E44-DA132C1ACF46}"}).productState
		$DefenderState = ('0x{0:x}' -f $productState).Substring(3, 2)
		# Defender is a currently used AV. Continue...
		if ($DefenderState -notmatch "00|01")
		{
			Get-CimInstance -ClassName MSFT_MpComputerStatus -Namespace root/Microsoft/Windows/Defender -ErrorAction Stop | Out-Null
			$Global:DefenderDefaultAV = $true
		}
	}
	catch [Microsoft.Management.Infrastructure.CimException]
	{
		# Provider Load Failure exception
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Global:Error.Exception.Message | Select-Object -First 1)
		Write-Warning -Message ($Localization.WindowsComponentBroken -f "Microsoft Defender")
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://www.microsoft.com/software-download/windows11" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Checking services
	try
	{
		$Services = Get-Service -Name Windefend, SecurityHealthService, wscsvc -ErrorAction Stop
		Get-Service -Name SecurityHealthService -ErrorAction Stop | Start-Service
	}
	catch [Microsoft.PowerShell.Commands.ServiceCommandException]
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.WindowsComponentBroken -f "Microsoft Defender")
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://www.microsoft.com/software-download/windows11" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}
	$Global:DefenderServices = ($Services | Where-Object -FilterScript {$_.Status -ne "running"} | Measure-Object).Count -lt $Services.Count

	# Checking wdFilter service
	try
	{
		if (-not (Get-Service -Name wdFilter -ErrorAction Stop))
		{
			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message ($Localization.WindowsComponentBroken -f "Microsoft Defender")
			Write-Information -MessageData "" -InformationAction Continue

			Write-Verbose -Message "https://www.microsoft.com/software-download/windows11" -Verbose
			Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
			Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

			$Global:Failed = $true

			exit
		}
	}
	catch [System.ComponentModel.Win32Exception]
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.WindowsComponentBroken -f "Microsoft Defender")
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message "https://www.microsoft.com/software-download/windows11" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}

	# Checking Get-MpPreference cmdlet
	try
	{
		$Global:DefenderMpPreferenceBroken = $false
		(Get-MpPreference -ErrorAction Stop).EnableControlledFolderAccess
	}
	catch [Microsoft.Management.Infrastructure.CimException]
	{
		$Global:DefenderMpPreferenceBroken = $true
	}

	# Check Microsoft Defender configuration
	if ($Global:DefenderDefaultAV)
	{
		# Defender is a currently used AV. Continue...
		$Global:DefenderProductState = $true

		# Checking whether Microsoft Defender was turned off via GPO
		# We have to use GetValue() due to "Set-StrictMode -Version Latest"
		if ([Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender", "DisableAntiSpyware", $null) -eq 1)
		{
			$Global:AntiSpywareEnabled = $false
		}
		else
		{
			$Global:AntiSpywareEnabled = $true
		}

		# Checking whether Microsoft Defender was turned off via GPO
		# We have to use GetValue() due to "Set-StrictMode -Version Latest"
		if ([Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection", "DisableRealtimeMonitoring", $null) -eq 1)
		{
			$Global:RealtimeMonitoringEnabled = $false
		}
		else
		{
			$Global:RealtimeMonitoringEnabled = $true
		}

		# Checking whether Microsoft Defender was turned off via GPO
		# We have to use GetValue() due to "Set-StrictMode -Version Latest"
		if ([Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection", "DisableBehaviorMonitoring", $null) -eq 1)
		{
			$Global:BehaviorMonitoringEnabled = $false
		}
		else
		{
			$Global:BehaviorMonitoringEnabled = $true
		}
	}
	else
	{
		$Global:DefenderProductState = $false
	}

	if ($Global:DefenderServices -and $Global:DefenderproductState -and $Global:AntiSpywareEnabled -and $Global:RealtimeMonitoringEnabled -and $Global:BehaviorMonitoringEnabled)
	{
		# Defender is enabled
		$Global:DefenderEnabled = $true

		if (-not $Global:DefenderMpPreferenceBroken)
		{
			switch ((Get-MpPreference).EnableControlledFolderAccess)
			{
				"1"
				{
					Write-Warning -Message $Localization.ControlledFolderAccessDisabled

					# Turn off Controlled folder access to let the script proceed
					$Global:ControlledFolderAccess = $true
					Set-MpPreference -EnableControlledFolderAccess Disabled

					# Open "Ransomware protection" page
					Start-Process -FilePath "windowsdefender://RansomwareProtection"
				}
				"0"
				{
					$Global:ControlledFolderAccess = $false
				}
			}
		}
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

	# Checking whether BitLocker encryption in process
	if (Get-BitLockerVolume | Where-Object -FilterScript {$_.VolumeStatus -eq "DecryptionInProgress"})
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message $Localization.BitLockerWarning
		Write-Information -MessageData "" -InformationAction Continue

		Get-BitLockerVolume

		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
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

				Write-Warning -Message ($Localization.NoResponse -f "https://github.com")
				Write-Error -Message ($Localization.NoResponse -f "https://github.com") -ErrorAction SilentlyContinue
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

	# PowerShell 5.1 (7.5 too) interprets 8.3 file name literally, if an environment variable contains a non-Latin word
	# https://github.com/PowerShell/PowerShell/issues/21070
	Get-ChildItem -Path "$env:TEMP\LGPO.txt" -Force -ErrorAction Ignore | Remove-Item -Force -ErrorAction Ignore

	# Save all opened folders in order to restore them after File Explorer restart
	try
	{
		$Global:OpenedFolders = {(New-Object -ComObject Shell.Application).Windows() | ForEach-Object -Process {$_.Document.Folder.Self.Path}}.Invoke()
	}
	catch [System.Management.Automation.PropertyNotFoundException]
	{}

	Write-Information -MessageData "" -InformationAction Continue
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
		Write-Information -MessageData "" -InformationAction Continue
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
