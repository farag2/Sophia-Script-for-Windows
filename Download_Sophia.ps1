<#
	.SYNOPSIS
	Download the latest Sophia Script version, depending on which Windows or PowerShell versions are used to

	.DESCRIPTION
	For example, if you start script on Windows 11 via PowerShell 5.1 you will start downloading Sophia Script for Windows 11 PowerShell 5.1

	.EXAMPLE
	iwr script.sophia.team -useb | iex
#>

Clear-Host
$Error.Clear()

if ($PSVersionTable.PSVersion.Major -eq 5)
{
	# Progress bar can significantly impact cmdlet performance
	# https://github.com/PowerShell/PowerShell/issues/2138
	$Script:ProgressPreference = "SilentlyContinue"

	[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

	# https://github.com/PowerShell/PowerShell/issues/21070
	$Script:CompilerParameters                  = [System.CodeDom.Compiler.CompilerParameters]::new("System.dll")
	$Script:CompilerParameters.TempFiles        = [System.CodeDom.Compiler.TempFileCollection]::new($env:TEMP, $false)
	$Script:CompilerParameters.GenerateInMemory = $true
}

$ProductName = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName
$Version     = $null

switch ([int](Get-CimInstance -Namespace root/CIMV2 -ClassName Win32_OperatingSystem).BuildNumber)
{
	17763
	{
		# Windows 10 LTSC 2019
		if ($ProductName -match "LTSC 2019")
		{
			$JSONKey = "Sophia_Script_Windows_10_LTSC_2019"
			$Version = "Sophia_Script_for_Windows_10_LTSC_2019"
			$Archive = "Sophia.Script.for.Windows.10.LTSC.2019"
		}
	}
	19044
	{
		# Windows 10 LTSC 2021
		if ($ProductName -match "LTSC 2021")
		{
			$JSONKey = "Sophia_Script_Windows_10_LTSC_2021"
			$Version = "Sophia_Script_for_Windows_10_LTSC_2021"
			$Archive = "Sophia.Script.for.Windows.10.LTSC.2021"
		}
	}
	19045
	{
		# Windows 10
		$JSONKey = "Sophia_Script_Windows_10"

		if ($PSVersionTable.PSVersion.Major -eq 5)
		{
			$Version = "Sophia_Script_for_Windows_10"
			$Archive = "Sophia.Script.for.Windows.10"
		}
		else
		{
			$Version = "Sophia_Script_for_Windows_10_PowerShell_7"
			$Archive = "Sophia.Script.for.Windows.10.PowerShell.7"
		}
	}
	{$_ -gt 19045}
	{
		if ($ProductName -match "LTSC 2024")
		{
			# Windows 11 LTSC 2024
			$JSONKey = "Sophia_Script_Windows_11_LTSC_2024"

			if ($PSVersionTable.PSVersion.Major -eq 5)
			{
				$Version = "Sophia_Script_for_Windows_11_LTSC_2024"
				$Archive = "Sophia.Script.for.Windows.11.LTSC.2024"
			}
			else
			{
				$Version = "Sophia_Script_for_Windows_11_LTSC_2024_PowerShell_7"
				$Archive = "Sophia.Script.for.Windows.11.LTSC.2024.PowerShell.7"
			}
		}
		elseif ((Get-CimInstance -ClassName CIM_Processor).Caption -match "ARM")
		{
			# Windows 11 Arm
			$JSONKey = "Sophia_Script_Windows_11"

			if ($PSVersionTable.PSVersion.Major -eq 5)
			{
				$Version = "Sophia_Script_for_Windows_11_Arm"
				$Archive = "Sophia.Script.for.Windows.11.Arm"
			}
			else
			{
				$Version = "Sophia_Script_for_Windows_11_Arm_PowerShell_7"
				$Archive = "Sophia.Script.for.Windows.11.Arm.PowerShell.7"
			}
		}
		else
		{
			# Windows 11
			$JSONKey = "Sophia_Script_Windows_11"

			if ($PSVersionTable.PSVersion.Major -eq 5)
			{
				$Version = "Sophia_Script_for_Windows_11"
				$Archive = "Sophia.Script.for.Windows.11"
			}
			else
			{
				$Version = "Sophia_Script_for_Windows_11_PowerShell_7"
				$Archive = "Sophia.Script.for.Windows.11.PowerShell.7"
			}
		}
	}
}

if (-not $Version)
{
	Write-Verbose -Message "Your Windows version is not supported. Update your Windows and try again." -Verbose

	# Receive updates for other Microsoft products when you update Windows
	(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "")

	# Check for updates
	& "$env:SystemRoot\System32\UsoClient.exe" StartInteractiveScan

	# Open the "Windows Update" page
	Start-Process -FilePath "ms-settings:windowsupdate"

	Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
	Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

	pause
	exit
}

Remove-Item -Path "$env:SystemDrive\Sophia_Script_Temp" -Recurse -Force -ErrorAction Ignore

if (Test-Path -Path "$env:SystemDrive\Sophia_Script_Temp")
{
	Write-Verbose -Message "Cannot delete $env:SystemDrive\Sophia_Script_Temp folder. Check it manually and try again." -Verbose

	# Receive updates for other Microsoft products when you update Windows
	(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "")

	# Check for updates
	& "$env:SystemRoot\System32\UsoClient.exe" StartInteractiveScan

	# Open the "Windows Update" page
	Start-Process -FilePath "ms-settings:windowsupdate"

	Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
	Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

	pause
	exit
}

New-Item -Path "$env:SystemDrive\Sophia_Script_Temp" -ItemType Directory -Force

try
{
	# https://github.com/farag2/Sophia-Script-for-Windows/blob/main/Sophia_Script_Releases.json
	$Parameters = @{
		Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/main/Sophia_Script_Releases.json"
		UseBasicParsing = $true
		Verbose         = $true
	}
	$LatestRelease = (Invoke-RestMethod @Parameters).$JSONKey

	$Parameters = @{
		Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/releases/latest/download/$Archive.v$LatestRelease.zip"
		OutFile         = "$env:SystemDrive\Sophia_Script_Temp\Sophia.Script.zip"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters
}
catch
{
	Write-Warning -Message "$($Parameters.Uri) is unreachable. Please check Internet connection or change your DNS records."
	Write-Information -MessageData "" -InformationAction Continue

	$InterfaceIndex = (Find-NetRoute -RemoteIPAddress "1.1.1.1" | Select-Object -First 1).InterfaceIndex
	$DNS = (Get-NetAdapter -InterfaceIndex $InterfaceIndex | Get-DnsClientServerAddress -AddressFamily IPv4).ServerAddresses

	Write-Warning -Message "You're using $(if ($DNS.Count -gt 1) {$DNS -join ', '} else {$DNS}) DNS records"

	Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
	Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

	Remove-Item -Path $env:SystemDrive\Sophia_Script_Temp -Recurse -Force

	pause
	exit
}

# tar.exe cannot extract an archive if it is located in a folder whose path includes $env:USERPROFILE path, so we download the archive to the $env:SystemDrive\Sophia_Script_Temp folder
& "$env:SystemRoot\System32\tar.exe" -xvf "$env:SystemDrive\Sophia_Script_Temp\Sophia.Script.zip" -C $env:SystemDrive\Sophia_Script_Temp

if (-not (Test-Path -Path "$env:SystemDrive\Sophia_Script_Temp\$($Version)_v$LatestRelease"))
{
	Write-Verbose -Message "Archive cannot be expanded. Probably, this was caused by your antivirus. Please update its definitions and try again." -Verbose

	# Try to display available AVs
	try
	{
		Get-CimInstance -ClassName AntiVirusProduct -Namespace root/SecurityCenter2 -ErrorAction Stop
	}
	catch
	{
		Write-Verbose -Message "Failed to obtain installed antivirus." -Verbose
	}

	# Check for updates
	& "$env:SystemRoot\System32\UsoClient.exe" StartInteractiveScan

	# Open the "Windows Update" page
	Start-Process -FilePath "ms-settings:windowsupdate"

	Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
	Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

	Remove-Item -Path $env:SystemDrive\Sophia_Script_Temp -Recurse -Force

	pause
	exit
}

$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
$Parameters = @{
	Path        = "$env:SystemDrive\Sophia_Script_Temp\$($Version)_v$LatestRelease"
	Destination = $DownloadsFolder
	Recurse     = $true
	Force       = $true
}
Copy-Item @Parameters

Remove-Item -Path $env:SystemDrive\Sophia_Script_Temp -Recurse -Force

Invoke-Item -Path "$DownloadsFolder\$($Version)_v$LatestRelease"
Set-Location -Path "$DownloadsFolder\$($Version)_v$LatestRelease"

$Signature = @{
	Namespace          = "WinAPI"
	Name               = "ForegroundWindow"
	Language           = "CSharp"
	MemberDefinition   = @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
[DllImport("user32.dll")]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool SetForegroundWindow(IntPtr hWnd);
"@
}

# PowerShell 7 compiles in memory and has no CompilerParameters argument
# https://github.com/PowerShell/PowerShell/issues/21070
if ($PSVersionTable.PSVersion.Major -eq 5)
{
	$Signature.Add("CompilerParameters", $CompilerParameters)
}

if (-not ("WinAPI.ForegroundWindow" -as [type]))
{
	Add-Type @Signature
}

Start-Sleep -Seconds 1

Get-Process -Name explorer | Where-Object -FilterScript {$_.MainWindowTitle -match "$($Version)_v$LatestRelease"} | ForEach-Object -Process {
	# Show window, if minimized
	[WinAPI.ForegroundWindow]::ShowWindowAsync($_.MainWindowHandle, 5)

	# Force move the console window to the foreground
	[WinAPI.ForegroundWindow]::SetForegroundWindow($_.MainWindowHandle)
} | Out-Null
