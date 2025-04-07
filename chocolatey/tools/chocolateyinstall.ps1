<#
	.SYNOPSIS
	Get direct URL of Sophia Script archive, depending on which Windows it is run on

	.SYNOPSIS
	For example, if you start script on Windows 11 you will start downloading Sophia Script for Windows 11

	.EXAMPLE To download for PowerShell 5.1
	choco install sophia --force -y

	.EXAMPLE To download for PowerShell 7
	choco install sophia --params "/PS7" --force -y
#>
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Parameters = @{
	Uri             = "https://api.github.com/repos/farag2/Sophia-Script-for-Windows/releases/latest"
	UseBasicParsing = $true
}
$LatestGitHubRelease = (Invoke-RestMethod @Parameters).tag_name

$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/sophia_script_versions.json"
	UseBasicParsing = $true
}
$JSONVersions = Invoke-RestMethod @Parameters

$null = $packageParameters
$packageParameters = $env:chocolateyPackageParameters

switch ((Get-CimInstance -ClassName Win32_OperatingSystem).BuildNumber)
{
	"17763"
	{
		# Check for Windows 10 LTSC 2019
		if ((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName) -match "LTSC 2019")
		{
			$LatestRelease = $JSONVersions.Sophia_Script_Windows_10_LTSC2019
			$URL = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.10.LTSC.2019.v$LatestRelease.zip"
			$Hash = "Hash_Sophia_Script_Windows_10_LTSC2019"
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
			$LatestRelease = $JSONVersions.Sophia_Script_Windows_10_LTSC2021
			$URL = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.10.LTSC.2021.v$LatestRelease.zip"
			$Hash = "Hash_Sophia_Script_Windows_10_LTSC2021"
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
		if ($packageParameters)
		{
			if ($packageParameters.Contains('PS7'))
			{
				$LatestRelease = $JSONVersions.Sophia_Script_Windows_10_PowerShell_7
				$URL = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.10.PowerShell.7.v$LatestRelease.zip"
				$Hash = "Hash_Sophia_Script_Windows_10_PowerShell_7"
			}
		}
		else
		{
			$LatestRelease = $JSONVersions.Sophia_Script_Windows_10_PowerShell_5_1
			$URL = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.10.v$LatestRelease.zip"
			$Hash = "Hash_Sophia_Script_Windows_10_PowerShell_5_1"
		}
	}
	{$_ -ge 26100}
	{
		# Check for Windows 11 LTSC 2024
		if ((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName) -match "LTSC 2024")
		{
			$LatestRelease = $JSONVersions.Sophia_Script_Windows_11_LTSC2024
			$URL = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.11.LTSC.2024.v$LatestRelease.zip"
			$Hash = "Hash_Sophia_Script_Windows_11_LTSC2024"
		}
		else
		{
			if ($packageParameters)
			{
				if ($packageParameters.Contains('PS7'))
				{
					$LatestRelease = $JSONVersions.Sophia_Script_Windows_11_PowerShell_7
					$URL = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.11.PowerShell.7.v$LatestRelease.zip"
					$Hash = "Hash_Sophia_Script_Windows_11_PowerShell_7"
				}
			}
			else
			{
				$LatestRelease = $JSONVersions.Sophia_Script_Windows_11_PowerShell_5_1
				$URL = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.11.v$LatestRelease.zip"
				$Hash = "Hash_Sophia_Script_Windows_11_PowerShell_5_1"
			}
		}
	}
}

$Downloads = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
$packageArgs = @{
	packageName   = $env:ChocolateyPackageName
	fileType      = "ZIP"
	unzipLocation = $Downloads
	url           = $URL
	checksum      = $Hash
	checksumType  = "sha256"
}
Install-ChocolateyZipPackage @packageArgs
