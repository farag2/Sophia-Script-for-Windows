<#
	.SYNOPSIS
	Download the latest Sophia Script version, depending on what Windows or PowerShell versions are used to

	.SYNOPSIS
	Download the latest Sophia Script version, depending on what Windows or PowerShell versions are used to
	E.g., if you start script on Windows 11 via PowerShell 5.1 you will start downloading Sophia Script for Windows 11 PowerShell 5.1

	.EXAMPLE Download and expand Sophia Script archive
	irm script.sophi.app -useb | iex

	.EXAMPLE Download and expand Wrapper archive
	iex "& {$(irm script.sophi.app -useb)} -Wrapper"

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

$Parameters = @{
	Uri              = "https://api.github.com/repos/farag2/Sophia-Script-for-Windows/releases/latest"
	UseBasicParsing   = $true
}
$LatestGitHubRelease = (Invoke-RestMethod @Parameters).tag_name

$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"

if ($Wrapper)
{
	$Parameters = @{
		Uri              = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json"
		UseBasicParsing  = $true
	}
	$LatestRelease = (Invoke-RestMethod @Parameters).Sophia_Script_Wrapper
	$Parameters = @{
		Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.Wrapper.v$LatestRelease.zip"
		OutFile         = "$DownloadsFolder\Sophia.Script.Wrapper.zip"
		UseBasicParsing = $true
		Verbose         = $true
	}
	Invoke-WebRequest @Parameters

	$Version = "Wrapper"

	$Parameters = @{
		Path            = "$DownloadsFolder\Sophia.Script.Wrapper.zip"
		DestinationPath = "$DownloadsFolder"
		Force           = $true
	}
	Expand-Archive @Parameters

	Remove-Item -Path "$DownloadsFolder\Sophia.Script.Wrapper.zip" -Force

	Start-Sleep -Second 1

	Invoke-Item -Path "$DownloadsFolder\Sophia_Script_Wrapper_v$LatestRelease"
}

switch ((Get-CimInstance -ClassName Win32_OperatingSystem).BuildNumber)
{
	"17763"
	{
		$Parameters = @{
			Uri              = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json"
			UseBasicParsing  = $true
		}
		$LatestRelease = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_10_LTSC2019
		$Parameters = @{
			Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.10.LTSC.2019.v$LatestRelease.zip"
			OutFile         = "$DownloadsFolder\Sophia.Script.zip"
			UseBasicParsing = $true
			Verbose         = $true
		}

		$Version = "LTSC2019"

		break
	}
	{($_ -ge 19044) -and ($_ -le 19048)}
	{
		if ($PSVersionTable.PSVersion.Major -eq 5)
		{
			# Check if Windows 10 is an LTSC 2021
			if ((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName) -eq "Windows 10 Enterprise LTSC 2021")
			{
				$Parameters = @{
					Uri              = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json"
					UseBasicParsing  = $true
				}
				$LatestRelease = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_10_LTSC2021
				$Parameters = @{
					Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.10.LTSC.2021.v$LatestRelease.zip"
					OutFile         = "$DownloadsFolder\Sophia.Script.zip"
					UseBasicParsing = $true
					Verbose         = $true
				}

				$Version = "LTSC2021"
			}
			else
			{
				$Parameters = @{
					Uri              = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json"
					UseBasicParsing  = $true
				}
				$LatestRelease = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_10_PowerShell_5_1
				$Parameters = @{
					Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.10.v$LatestRelease.zip"
					OutFile         = "$DownloadsFolder\Sophia.Script.zip"
					UseBasicParsing = $true
					Verbose         = $true
				}

				$Version = "Windows_10_PowerShell_5.1"
			}
		}
		else
		{
			$Parameters = @{
				Uri              = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json"
				UseBasicParsing  = $true
			}
			$LatestRelease = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_10_PowerShell_7
			$Parameters = @{
				Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.10.PowerShell.7.v$LatestRelease.zip"
				OutFile         = "$DownloadsFolder\Sophia.Script.zip"
				UseBasicParsing = $true
				Verbose         = $true
			}

			$Version = "Windows_10_PowerShell_7"
		}

	}
	{$_ -ge 22000}
	{
		if ($PSVersionTable.PSVersion.Major -eq 5)
		{
			$Parameters = @{
				Uri              = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json"
				UseBasicParsing  = $true
			}
			$LatestRelease = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_11_PowerShell_5_1
			$Parameters = @{
				Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.11.v$LatestRelease.zip"
				OutFile         = "$DownloadsFolder\Sophia.Script.zip"
				UseBasicParsing = $true
				Verbose         = $true
			}

			$Version = "Windows_11_PowerShell_5.1"
		}
		else
		{
			$Parameters = @{
				Uri              = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json"
				UseBasicParsing  = $true
			}
			$LatestRelease = (Invoke-RestMethod @Parameters).Sophia_Script_Windows_11_PowerShell_7
			$Parameters = @{
				Uri             = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.11.PowerShell.7.v$LatestRelease.zip"
				OutFile         = "$DownloadsFolder\Sophia.Script.zip"
				UseBasicParsing = $true
				Verbose         = $true
			}

			$Version = "Windows_11_PowerShell_7"
		}
	}
}
Invoke-WebRequest @Parameters

$Parameters = @{
	Path            = "$DownloadsFolder\Sophia.Script.zip"
	DestinationPath = "$DownloadsFolder"
	Force           = $true
}
Expand-Archive @Parameters

Remove-Item -Path "$DownloadsFolder\Sophia.Script.zip" -Force

Start-Sleep -Second 1

switch ($Version)
{
	"Wrapper"
	{
		Invoke-Item -Path "$DownloadsFolder\Sophia_Script_Wrapper_v$LatestRelease"
	}
	"LTSC2019"
	{
		Invoke-Item -Path "$DownloadsFolder\Sophia_Script_for_Windows_10_LTSC_2019_v$LatestRelease"
	}
	"LTSC2021"
	{
		Invoke-Item -Path "$DownloadsFolder\Sophia_Script_for_Windows_10_LTSC_2021_v$LatestRelease"
	}
	"Windows_10_PowerShell_5.1"
	{
		Invoke-Item -Path "$DownloadsFolder\Sophia_Script_for_Windows_10_v$LatestRelease"
	}
	"Windows_10_PowerShell_7"
	{
		Invoke-Item -Path "$DownloadsFolder\Sophia_Script_for_Windows_10_PowerShell_7_v$LatestRelease"
	}
	"Windows_11_PowerShell_5.1"
	{
		Invoke-Item -Path "$DownloadsFolder\Sophia_Script_for_Windows_11_v$LatestRelease"
	}
	"Windows_11_PowerShell_7"
	{
		Invoke-Item -Path "$DownloadsFolder\Sophia_Script_for_Windows_11_PowerShell_7_v$LatestRelease"
	}
}

$SetForegroundWindow = @{
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
	Add-Type @SetForegroundWindow
}

Start-Sleep -Seconds 1

Get-Process -Name explorer | Where-Object -FilterScript {$_.MainWindowTitle -match "Sophia_Script_for_Windows_$([System.Environment]::OSVersion.Version.Major)"} | ForEach-Object -Process {
	# Show window, if minimized
	[WinAPI.ForegroundWindow]::ShowWindowAsync($_.MainWindowHandle, 5)

	# Force move the console window to the foreground
	[WinAPI.ForegroundWindow]::SetForegroundWindow($_.MainWindowHandle)
} | Out-Null
