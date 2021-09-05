<#
	.SYNOPSIS
	Download the latest Sophia Script version, depending on what Windows or PowerShell versions are used to
	E.g., if you start script on Windows 11 via PowerShell 5.1 you will start downloading Sophia Script for Windows 11 PowerShell 5.1

	.EXAMPLE Download and the Sophia Script archive
	irm script.sophi.app | iex

	.EXAMPLE Download and expand the Wrapper archive
	iex "& {$(irm script.sophi.app)} -Wrapper"

	.NOTES
	Current user
#>
[CmdletBinding()]
param
(
	[Parameter(Mandatory = $false)]
	[switch]
	$Wrapper
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$LatestRelease = (Invoke-RestMethod -Uri "https://api.github.com/repos/farag2/Sophia-Script-for-Windows/releases/latest" -UseBasicParsing).tag_name
$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"

if ($Wrapper)
{
	$LatestStableVersion = (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json" -UseBasicParsing).Sophia_Script_Wrapper
	$Parameters = @{
		Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestRelease/Sophia.Script.Wrapper.v$LatestStableVersion.zip"
		OutFile         = "$DownloadsFolder\Sophia.Script.Wrapper.zip"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	$Parameters = @{
		Path            = "$DownloadsFolder\Sophia.Script.Wrapper.zip"
		DestinationPath = "$DownloadsFolder"
		Force           = $true
	}
	Expand-Archive @Parameters

	Remove-Item -Path "$DownloadsFolder\Sophia.Script.Wrapper.zip" -Force

	Start-Sleep -Second 1

	Invoke-Item -Path "$DownloadsFolder\Sophia Script Wrapper v$LatestStableVersion"

	exit
}

switch ((Get-CimInstance -ClassName Win32_OperatingSystem).BuildNumber)
{
	"17763"
	{
		$LatestStableVersion = (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json" -UseBasicParsing).Sophia_Script_Windows_10_LTSC
		$Parameters = @{
			Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestRelease/Sophia.Script.LTSC.v$LatestStableVersion.zip"
			OutFile         = "$DownloadsFolder\Sophia.Script.zip"
			UseBasicParsing = $true
			Verbose         = $true
		}
	}
	{($_ -ge 19041) -and ($_ -le 19044)}
	{
		if ($PSVersionTable.PSVersion.Major -eq 5)
		{
			$LatestStableVersion = (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json" -UseBasicParsing).Sophia_Script_Windows_10_PowerShell_5_1
			$Parameters = @{
				Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestRelease/Sophia.Script.v$LatestStableVersion.zip"
				OutFile         = "$DownloadsFolder\Sophia.Script.zip"
				UseBasicParsing = $true
				Verbose         = $true
			}
		}
		else
		{
			$LatestStableVersion = (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json" -UseBasicParsing).Sophia_Script_Windows_10_PowerShell_7
			$Parameters = @{
				Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestRelease/Sophia.Script.v$LatestRelease.PowerShell.7.zip"
				OutFile         = "$DownloadsFolder\Sophia.Script.zip"
				UseBasicParsing = $true
				Verbose         = $true
			}
		}
	}
	"22000"
	{
		if ($PSVersionTable.PSVersion.Major -eq 5)
		{
			$LatestStableVersion = (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json" -UseBasicParsing).Sophia_Script_Windows_11_PowerShell_5_1
			$Parameters = @{
				Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestRelease/Sophia.Script.Windows.11.v$LatestStableVersion.zip"
				OutFile         = "$DownloadsFolder\Sophia.Script.zip"
				UseBasicParsing = $true
				Verbose         = $true
			}
		}
		else
		{
			$LatestStableVersion = (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json" -UseBasicParsing).Sophia_Script_Windows_11_PowerShell_7
			$Parameters = @{
				Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestRelease/Sophia.Script.Windows.11.v$LatestRelease.PowerShell.7.zip"
				OutFile         = "$DownloadsFolder\Sophia.Script.zip"
				UseBasicParsing = $true
				Verbose         = $true
			}
		}
	}
}
Invoke-WebRequest @Parameters

$Parameters = @{
	Path = "$DownloadsFolder\Sophia.Script.zip"
	DestinationPath = "$DownloadsFolder"
	Force = [switch]::Present
}
Expand-Archive @Parameters

Remove-Item -Path "$DownloadsFolder\Sophia.Script.zip" -Force

Start-Sleep -Second 1

Invoke-Item -Path "$DownloadsFolder\Sophia Script v$LatestRelease"

$SetForegroundWindow = @{
	Namespace = "WinAPI"
	Name = "ForegroundWindow"
	Language = "CSharp"
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
	Add-Type @SetForegroundWindow
}

Get-Process | Where-Object -FilterScript {$_.MainWindowTitle -eq "Sophia Script v$LatestRelease"} | ForEach-Object -Process {
	# Show window, if minimized
	[WinAPI.ForegroundWindow]::ShowWindowAsync($_.MainWindowHandle, 5)

	# Force move the console window to the foreground
	[WinAPI.ForegroundWindow]::SetForegroundWindow($_.MainWindowHandle)
}
