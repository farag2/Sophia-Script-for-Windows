<#
	.SYNOPSIS
	Download the latest Sophia Script version from the last commit available, depending on which Windows or PowerShell versions are used to

	.DESCRIPTION
	For example, if you start script on Windows 11 via PowerShell 5.1 you will start downloading Sophia Script for Windows 11 PowerShell 5.1

	.EXAMPLE
	iwr sl.sophia.team -useb | iex
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
			$Version = "Sophia_Script_for_Windows_10_LTSC_2019"
		}
	}
	19044
	{
		# Windows 10 LTSC 2021
		if ($ProductName -match "LTSC 2021")
		{
			$Version = "Sophia_Script_for_Windows_10_LTSC_2021"
		}
	}
	19045
	{
		# Windows 10
		if ($PSVersionTable.PSVersion.Major -eq 5)
		{
			$Version = "Sophia_Script_for_Windows_10"
		}
		else
		{
			$Version = "Sophia_Script_for_Windows_10_PowerShell_7"
		}
	}
	{$_ -gt 19045}
	{
		if ($ProductName -match "LTSC 2024")
		{
			# Windows 11 LTSC 2024
			if ($PSVersionTable.PSVersion.Major -eq 5)
			{
				$Version = "Sophia_Script_for_Windows_11_LTSC_2024"
			}
			else
			{
				$Version = "Sophia_Script_for_Windows_11_LTSC_2024_PowerShell_7"
			}
		}
		elseif ((Get-CimInstance -Namespace root/CIMV2 -ClassName CIM_Processor).Architecture -eq 12)
		{
			# Windows 11 Arm
			if ($PSVersionTable.PSVersion.Major -eq 5)
			{
				$Version = "Sophia_Script_for_Windows_11_Arm"
			}
			else
			{
				$Version = "Sophia_Script_for_Windows_11_Arm_PowerShell_7"
			}
		}
		else
		{
			# Windows 11
			if ($PSVersionTable.PSVersion.Major -eq 5)
			{
				$Version = "Sophia_Script_for_Windows_11"
			}
			else
			{
				$Version = "Sophia_Script_for_Windows_11_PowerShell_7"
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
	# https://github.com/farag2/Sophia-Script-for-Windows/archive/refs/heads/main.zip
	$Parameters = @{
		Uri             = "https://codeload.github.com/farag2/Sophia-Script-for-Windows/zip/refs/heads/main"
		OutFile         = "$env:SystemDrive\Sophia_Script_Temp\main.zip"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	# Download LGPO
	# https://techcommunity.microsoft.com/t5/microsoft-security-baselines/lgpo-exe-local-group-policy-object-utility-v1-0/ba-p/701045
	$Parameters = @{
		Uri             = "https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip"
		OutFile         = "$env:SystemDrive\Sophia_Script_Temp\LGPO.zip"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	if ($Version -match "PowerShell_7")
	{
		# Download Microsoft.Windows.SDK.NET.dll & WinRT.Runtime.dll
		# https://www.nuget.org/packages/Microsoft.Windows.SDK.NET.Ref
		$Parameters = @{
			Uri             = "https://www.nuget.org/api/v2/package/Microsoft.Windows.SDK.NET.Ref"
			OutFile         = "$env:SystemDrive\Sophia_Script_Temp\microsoft.windows.sdk.net.ref.zip"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters
	}
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
& "$env:SystemRoot\System32\tar.exe" -xvf "$env:SystemDrive\Sophia_Script_Temp\main.zip" -C $env:SystemDrive\Sophia_Script_Temp --strip-components=2 "Sophia-Script-for-Windows-main/src/$Version"

if (-not (Test-Path -Path "$env:SystemDrive\Sophia_Script_Temp\$Version"))
{
	Write-Verbose -Message "Archive cannot be expanded. Probably, this was caused by your antivirus. Please update its definitions and try again." -Verbose

	# Try to display available AVs
	try
	{
		Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiVirusProduct -ErrorAction Stop
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

New-Item -Path "$env:SystemDrive\Sophia_Script_Temp\$Version\Module\Binaries" -ItemType Directory -Force

# Extract LGPO.exe
& "$env:SystemRoot\System32\tar.exe" -xvf "$env:SystemDrive\Sophia_Script_Temp\LGPO.zip" -C "$env:SystemDrive\Sophia_Script_Temp\$Version\Module\Binaries" --strip-components=1 "LGPO_30/LGPO.exe"

if ($Version -match "PowerShell_7")
{
	# Extract Microsoft.Windows.SDK.NET.dll & WinRT.Runtime.dll
	& "$env:SystemRoot\System32\tar.exe" -xvf "$env:SystemDrive\Sophia_Script_Temp\microsoft.windows.sdk.net.ref.zip" -C "$env:SystemDrive\Sophia_Script_Temp\$Version\Module\Binaries" --strip-components=2 "lib/net9.0/WinRT.Runtime.dll" "lib/net9.0/Microsoft.Windows.SDK.NET.dll"
}

Rename-Item -Path "$env:SystemDrive\Sophia_Script_Temp\$Version" -NewName "$($Version)_Latest" -Force

$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
$Parameters = @{
	Path        = "$env:SystemDrive\Sophia_Script_Temp\$($Version)_Latest"
	Destination = $DownloadsFolder
	Recurse     = $true
	Force       = $true
}
Copy-Item @Parameters

Remove-Item -Path $env:SystemDrive\Sophia_Script_Temp -Recurse -Force

Invoke-Item -Path "$DownloadsFolder\$($Version)_Latest"
Set-Location -Path "$DownloadsFolder\$($Version)_Latest"

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

Get-Process -Name explorer | Where-Object -FilterScript {$_.MainWindowTitle -match "$($Version)_Latest"} | ForEach-Object -Process {
	# Show window, if minimized
	[WinAPI.ForegroundWindow]::ShowWindowAsync($_.MainWindowHandle, 5)

	# Force move the console window to the foreground
	[WinAPI.ForegroundWindow]::SetForegroundWindow($_.MainWindowHandle)
} | Out-Null
