[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$LatestRelease = (Invoke-RestMethod -Uri "https://api.github.com/repos/farag2/Sophia-Script-for-Windows/releases/latest" -UseBasicParsing).tag_name
$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"

switch ((Get-CimInstance -ClassName Win32_OperatingSystem).BuildNumber)
{
	"17763"
	{
		$LatestStableVersion = (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json" -UseBasicParsing).Sophia_Script_Windows_10_LTSC
		$Parameters = @{
			Uri = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestRelease/Sophia.Script.LTSC.v$LatestStableVersion.zip"
			OutFile = "$DownloadsFolder\Sophia.Script.zip"
		}
	}
	{($_ -ge 19041) -and ($_ -le 19044)}
	{
		$LatestStableVersion = (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json" -UseBasicParsing).Sophia_Script_Windows_10_PowerShell_5_1
		$Parameters = @{
			Uri = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestRelease/Sophia.Script.v$LatestStableVersion.zip"
			OutFile = "$DownloadsFolder\Sophia.Script.zip"
		}
	}
	"22000"
	{
		$LatestStableVersion = (Invoke-RestMethod -Uri "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json" -UseBasicParsing).Sophia_Script_Windows_11_PowerShell_5_1
		$Parameters = @{
			Uri = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestRelease/Sophia.Script.v$LatestStableVersion.zip"
			OutFile = "$DownloadsFolder\Sophia.Script.zip"
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
