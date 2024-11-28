<#
	.SYNOPSIS
	Download the latest Sophia Script version from the last commit available, depending on which Windows or PowerShell versions are used to

	.SYNOPSIS
	For example, if you start script on Windows 11 via PowerShell 5.1 you will start downloading Sophia Script for Windows 11 PowerShell 5.1

	.EXAMPLE
	iwr sl.sophia.team -useb | iex
#>
Clear-Host

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Remove-Variable * -ErrorAction Ignore

if ($Host.Version.Major -eq 5)
{
	# Progress bar can significantly impact cmdlet performance
	# https://github.com/PowerShell/PowerShell/issues/2138
	$Script:ProgressPreference = "SilentlyContinue"
}

$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
$Parameters = @{
	Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/archive/refs/heads/master.zip"
	OutFile         = "$DownloadsFolder\master.zip"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-RestMethod @Parameters

switch ((Get-CimInstance -ClassName Win32_OperatingSystem).BuildNumber)
{
	"17763"
	{
		# Check for Windows 10 LTSC 2019
		if ((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName) -match "LTSC 2019")
		{
			$Version = "Sophia_Script_for_Windows_10_LTSC_2019"
			$Host.UI.RawUI.WindowTitle = "Sophia Script for Windows 10 LTSC 2019 | Latest | Made with $([System.Char]::ConvertFromUtf32(0x1F497)) of Windows | $([System.Char]0x00A9) farag, Inestic & lowl1f3, 2014$([System.Char]0x2013)2024"
		}
		else
		{
			Write-Verbose -Message "Windows version is not supported. Update your Windows" -Verbose

			# Receive updates for other Microsoft products when you update Windows
			(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "")

			# Check for updates
			Start-Process -FilePath "$env:SystemRoot\System32\UsoClient.exe" -ArgumentList StartInteractiveScan

			# Open the "Windows Update" page
			Start-Process -FilePath "ms-settings:windowsupdate"

			pause
			exit
		}
	}
	"19044"
	{
		# Check for Windows 10 LTSC 2021
		if ((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName) -match "LTSC 2021")
		{
			$Version = "Sophia_Script_for_Windows_10_LTSC_2021"
			$Host.UI.RawUI.WindowTitle = "Sophia Script for Windows 10 LTSC 2021 | Latest | Made with $([System.Char]::ConvertFromUtf32(0x1F497)) of Windows | $([System.Char]0x00A9) farag, Inestic & lowl1f3, 2014$([System.Char]0x2013)2024"
		}
		else
		{
			Write-Verbose -Message "Windows version is not supported. Update your Windows" -Verbose

			# Receive updates for other Microsoft products when you update Windows
			(New-Object -ComObject Microsoft.Update.ServiceManager).AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "")

			# Check for updates
			Start-Process -FilePath "$env:SystemRoot\System32\UsoClient.exe" -ArgumentList StartInteractiveScan

			# Open the "Windows Update" page
			Start-Process -FilePath "ms-settings:windowsupdate"

			pause
			exit
		}
	}
	"19045"
	{
		if ($Host.Version.Major -eq 5)
		{
			$Version = "Sophia_Script_for_Windows_10"
			$Host.UI.RawUI.WindowTitle = "Sophia Script for Windows 10 | Latest | Made with $([System.Char]::ConvertFromUtf32(0x1F497)) of Windows | $([System.Char]0x00A9) farag, Inestic & lowl1f3, 2014$([System.Char]0x2013)2024"
		}
		else
		{
			$Version = "Sophia_Script_for_Windows_10_PowerShell_7"
			$Host.UI.RawUI.WindowTitle = "Sophia Script for Windows 10 PowerShell 7 | Latest | Made with $([System.Char]::ConvertFromUtf32(0x1F497)) of Windows | $([System.Char]0x00A9) farag, Inestic & lowl1f3, 2014$([System.Char]0x2013)2024"
		}
	}
	{$_ -ge 22631}
	{
		# Check for Windows 11 LTSC 2024
		if ((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName) -notmatch "LTSC 2024")
		{
			if ($Host.Version.Major -eq 5)
			{
				$Version = "Sophia_Script_for_Windows_11"
				$Host.UI.RawUI.WindowTitle = "Sophia Script for Windows 11 | Latest | Made with $([System.Char]::ConvertFromUtf32(0x1F497)) of Windows | $([System.Char]0x00A9) farag, Inestic & lowl1f3, 2014$([System.Char]0x2013)2024"
			}
			else
			{
				$Version = "Sophia_Script_for_Windows_11_PowerShell_7"
				$Host.UI.RawUI.WindowTitle = "Sophia Script for Windows 11 PowerShell 7 | Latest | Made with $([System.Char]::ConvertFromUtf32(0x1F497)) of Windows | $([System.Char]0x00A9) farag, Inestic & lowl1f3, 2014$([System.Char]0x2013)2024"
			}
		}
		else
		{
			$Version = "Sophia_Script_for_Windows_11_LTSC_2024"
			$Host.UI.RawUI.WindowTitle = "Sophia Script for Windows 11 LTSC 2024 | Latest | Made with $([System.Char]::ConvertFromUtf32(0x1F497)) of Windows | $([System.Char]0x00A9) farag, Inestic & lowl1f3, 2014$([System.Char]0x2013)2024"
		}
	}
}

if (-not (Test-Path -Path "$DownloadsFolder\SophiaScriptTemp"))
{
	New-Item -Path "$DownloadsFolder\SophiaScriptTemp" -ItemType Directory -Force
}
else
{
	Remove-Item -Path "$DownloadsFolder\SophiaScriptTemp" -Force -Recurse

	if ((Get-ChildItem -Path "$DownloadsFolder\SophiaScriptTemp" -ErrorAction Ignore | Measure-Object).Count -ne 0)
	{
		Write-Verbose -Message "Some files in `"$DownloadsFolder\SophiaScriptTemp`" folder are in use. Please remove them manually and try to use script again." -Verbose

		pause
		exit
	}
}

if (Test-Path -Path "$DownloadsFolder\$($Version)_Latest")
{
	Remove-Item -Path "$DownloadsFolder\$($Version)_Latest" -Recurse -Force -ErrorAction Ignore

	if ((Get-ChildItem -Path "$DownloadsFolder\$($Version)_Latest" -ErrorAction Ignore | Measure-Object).Count -ne 0)
	{
		Write-Verbose -Message "Some files in `"$DownloadsFolder\$($Version)_Latest`" folder are in use. Please remove `"$DownloadsFolder\$($Version)_Latest`" manually and try to use script again." -Verbose

		pause
		exit
	}
}

& "$env:SystemRoot\System32\tar.exe" -C "$DownloadsFolder\SophiaScriptTemp" -xf "$DownloadsFolder\master.zip" "Sophia-Script-for-Windows-master/src/$Version"

New-Item -Path "$DownloadsFolder\SophiaScriptTemp\Sophia-Script-for-Windows-master\src\$Version\bin" -ItemType Directory -Force

# Download LGPO
# https://techcommunity.microsoft.com/t5/microsoft-security-baselines/lgpo-exe-local-group-policy-object-utility-v1-0/ba-p/701045
$Parameters = @{
	Uri             = "https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip"
	OutFile         = "$DownloadsFolder\SophiaScriptTemp\Sophia-Script-for-Windows-master\src\$Version\bin\LGPO.zip"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

$Parameters = @{
	Path            = "$DownloadsFolder\SophiaScriptTemp\Sophia-Script-for-Windows-master\src\$Version\bin\LGPO.zip"
	DestinationPath = "$DownloadsFolder\SophiaScriptTemp\Sophia-Script-for-Windows-master\src\$Version\bin"
	Force           = $true
	Verbose         = $true
}
Expand-Archive @Parameters

$Parameters = @{
	Path        = "$DownloadsFolder\SophiaScriptTemp\Sophia-Script-for-Windows-master\src\$Version\bin\LGPO_30\LGPO.exe"
	Destination = "$DownloadsFolder\SophiaScriptTemp\Sophia-Script-for-Windows-master\src\$Version\bin\LGPO.exe"
	Force       = $true
}
Move-Item @Parameters

if ($Version -match "PowerShell_7")
{
	# Download Microsoft.Windows.SDK.NET.dll & WinRT.Runtime.dll
	# https://www.nuget.org/packages/Microsoft.Windows.SDK.NET.Ref
	$Parameters = @{
		Uri             = "https://www.nuget.org/api/v2/package/Microsoft.Windows.SDK.NET.Ref"
		OutFile         = "$DownloadsFolder\SophiaScriptTemp\Sophia-Script-for-Windows-master\src\$Version\bin\microsoft.windows.sdk.net.ref.zip"
		UseBasicParsing = $true
	}
	Invoke-RestMethod @Parameters

	# Extract Microsoft.Windows.SDK.NET.dll & WinRT.Runtime.dll from archive
	Add-Type -Assembly System.IO.Compression.FileSystem
	$ZIP = [IO.Compression.ZipFile]::OpenRead("$DownloadsFolder\SophiaScriptTemp\Sophia-Script-for-Windows-master\src\$Version\bin\microsoft.windows.sdk.net.ref.zip")
	$Entries = $ZIP.Entries | Where-Object -FilterScript {($_.FullName -eq "lib/net8.0/Microsoft.Windows.SDK.NET.dll") -or ($_.FullName -eq "lib/net8.0/WinRT.Runtime.dll")}
	$Entries | ForEach-Object -Process {[IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$DownloadsFolder\SophiaScriptTemp\Sophia-Script-for-Windows-master\src\$Version\bin\$($_.Name)", $true)}
	$ZIP.Dispose()

	Remove-Item -Path "$DownloadsFolder\SophiaScriptTemp\Sophia-Script-for-Windows-master\src\$Version\bin\microsoft.windows.sdk.net.ref.zip" -Recurse -Force
}

$Parameters = @{
	Path    = "$DownloadsFolder\SophiaScriptTemp\Sophia-Script-for-Windows-master\src\$Version"
	NewName = "$($Version)_Latest"
	Force   = $true
}
Rename-Item @Parameters

$Parameters = @{
	Path        = "$DownloadsFolder\SophiaScriptTemp\Sophia-Script-for-Windows-master\src\$($Version)_Latest"
	Destination = "$DownloadsFolder"
	Force       = $true
}
Move-Item @Parameters

$Path = @(
	"$DownloadsFolder\SophiaScriptTemp",
	"$DownloadsFolder\$($Version)_Latest\bin\LGPO_30",
	"$DownloadsFolder\$($Version)_Latest\bin\LGPO.zip",
	"$DownloadsFolder\master.zip"
)
Remove-Item -Path $Path -Recurse -Force

switch ($Version)
{
	"Sophia_Script_for_Windows_10_LTSC_2019"
	{
		Invoke-Item -Path "$DownloadsFolder\Sophia_Script_for_Windows_10_LTSC_2019"

		if ((([System.Security.Principal.WindowsIdentity]::GetCurrent()).Owner -eq "S-1-5-32-544"))
		{
			Set-Location -Path "$DownloadsFolder\Sophia_Script_for_Windows_10_LTSC_2019_Latest"
		}
	}
	"Sophia_Script_for_Windows_10_LTSC_2021"
	{
		Invoke-Item -Path "$DownloadsFolder\Sophia_Script_for_Windows_10_LTSC_2021_Latest"

		if ((([System.Security.Principal.WindowsIdentity]::GetCurrent()).Owner -eq "S-1-5-32-544"))
		{
			Set-Location -Path "$DownloadsFolder\Sophia_Script_for_Windows_10_LTSC_2021_Latest"
		}
	}
	"Sophia_Script_for_Windows_11_LTSC_2024"
	{
		Invoke-Item -Path "$DownloadsFolder\Sophia_Script_for_Windows_11_LTSC_2024_Latest"

		if ((([System.Security.Principal.WindowsIdentity]::GetCurrent()).Owner -eq "S-1-5-32-544"))
		{
			Set-Location -Path "$DownloadsFolder\Sophia_Script_for_Windows_11_LTSC_2024_Latest"
		}
	}
	"Sophia_Script_for_Windows_10"
	{
		Invoke-Item -Path "$DownloadsFolder\Sophia_Script_for_Windows_10_Latest"

		if ((([System.Security.Principal.WindowsIdentity]::GetCurrent()).Owner -eq "S-1-5-32-544"))
		{
			Set-Location -Path "$DownloadsFolder\Sophia_Script_for_Windows_10_Latest"
		}
	}
	"Sophia_Script_for_Windows_10_PowerShell_7"
	{
		Invoke-Item -Path "$DownloadsFolder\Sophia_Script_for_Windows_10_PowerShell_7_Latest"

		if ((([System.Security.Principal.WindowsIdentity]::GetCurrent()).Owner -eq "S-1-5-32-544"))
		{
			Set-Location -Path "$DownloadsFolder\Sophia_Script_for_Windows_10_PowerShell_7_Latest"
		}
	}
	"Sophia_Script_for_Windows_11"
	{
		Invoke-Item -Path "$DownloadsFolder\Sophia_Script_for_Windows_11_Latest"

		if ((([System.Security.Principal.WindowsIdentity]::GetCurrent()).Owner -eq "S-1-5-32-544"))
		{
			Set-Location -Path "$DownloadsFolder\Sophia_Script_for_Windows_11_Latest"
		}

		return
	}
	"Sophia_Script_for_Windows_11_PowerShell_7"
	{
		Invoke-Item -Path "$DownloadsFolder\Sophia_Script_for_Windows_11_PowerShell_7_Latest"

		if ((([System.Security.Principal.WindowsIdentity]::GetCurrent()).Owner -eq "S-1-5-32-544"))
		{
			Set-Location -Path "$DownloadsFolder\Sophia_Script_for_Windows_11_PowerShell_7_Latest"
		}
	}
}

# https://github.com/PowerShell/PowerShell/issues/21070
$CompilerParameters = [System.CodeDom.Compiler.CompilerParameters]::new("System.dll")
$CompilerParameters.TempFiles = [System.CodeDom.Compiler.TempFileCollection]::new($env:TEMP, $false)
$CompilerParameters.GenerateInMemory = $true
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

# PowerShell 7 has CompilerOptions argument instead of CompilerParameters as PowerShell 5 has
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/add-type#-compileroptions
if ($Host.Version.Major -eq 7)
{
	$Signature.Remove("CompilerParameters")
	$Signature.Add("CompilerOptions", $CompilerParameters)
}

if (-not ("WinAPI.ForegroundWindow" -as [type]))
{
	Add-Type @Signature
}

Start-Sleep -Seconds 1

Get-Process -Name explorer | Where-Object -FilterScript {$_.MainWindowTitle -match "Sophia_Script_for_Windows"} | ForEach-Object -Process {
	# Show window, if minimized
	[WinAPI.ForegroundWindow]::ShowWindowAsync($_.MainWindowHandle, 5)

	# Force move the console window to the foreground
	[WinAPI.ForegroundWindow]::SetForegroundWindow($_.MainWindowHandle)
} | Out-Null
