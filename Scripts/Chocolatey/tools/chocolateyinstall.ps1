<#
	.SYNOPSIS
	Get direct URL of Sophia Script archive, depending on which Windows it is run on

	.DESCRIPTION
	For example, if you start script on Windows 11 you will start downloading Sophia Script for Windows 11

	.EXAMPLE To download for PowerShell 5.1
	choco install sophia --force -y

	.EXAMPLE To download for PowerShell 7
	choco install sophia --params "/PS7" --force -y
#>

Clear-Host
$Error.Clear()

if ($PSVersionTable.PSVersion.Major -eq 5)
{
	# Progress bar can significantly impact cmdlet performance
	# https://github.com/PowerShell/PowerShell/issues/2138
	$Script:ProgressPreference = "SilentlyContinue"

	[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
}

$Parameters = @{
	Uri             = "https://api.github.com/repos/farag2/Sophia-Script-for-Windows/releases/latest"
	UseBasicParsing = $true
	Verbose         = $true
}
$LatestGitHubRelease = (Invoke-RestMethod @Parameters).tag_name

# https://github.com/farag2/Sophia-Script-for-Windows/blob/main/Sophia_Script_Releases.json
$Parameters = @{
	Uri             = "https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/main/Sophia_Script_Releases.json"
	UseBasicParsing = $true
	Verbose         = $true
}
$JSON = Invoke-RestMethod @Parameters

$packageParameters = $env:chocolateyPackageParameters

switch ((Get-CimInstance -Namespace root/CIMV2 -ClassName CIM_OperatingSystem).BuildNumber)
{
	"17763"
	{
		# Windows 10 LTSC 2019
		$LatestRelease = $JSON.Sophia_Script_Windows_10_LTSC_2019
		$URL = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.10.LTSC.2019.v$LatestRelease.zip"
		$Hash = "Hash_Sophia_Script_Windows_10_LTSC_2019"
	}
	"19044"
	{
		# Windows 10 LTSC 2021
		$LatestRelease = $JSON.Sophia_Script_Windows_10_LTSC_2021
		$URL = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.10.LTSC.2021.v$LatestRelease.zip"
		$Hash = "Hash_Sophia_Script_Windows_10_LTSC_2021"
	}
	"19045"
	{
		# Windows 10
		if ($packageParameters -and $packageParameters.Contains("PS7"))
		{
			$LatestRelease = $JSON.Sophia_Script_Windows_10
			$URL = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.10.PowerShell.7.v$LatestRelease.zip"
			$Hash = "Hash_Sophia_Script_Windows_10_PowerShell_7"
		}
		else
		{
			$LatestRelease = $JSON.Sophia_Script_Windows_10
			$URL = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.10.v$LatestRelease.zip"
			$Hash = "Hash_Sophia_Script_Windows_10_PowerShell_5_1"
		}
	}
	"26100"
	{
		# Windows 11 Enterprise LTSC 2024
		if ((Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName) -match "LTSC 2024")
		{
			if ($packageParameters -and $packageParameters.Contains("PS7"))
			{
				$LatestRelease = $JSON.Sophia_Script_Windows_11_LTSC_2024
				$URL = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.11.LTSC.2024.PowerShell.7.v$LatestRelease.zip"
				$Hash = "Hash_Sophia_Script_Windows_11_LTSC_2024_PowerShell_7"
			}
			else
			{
				$LatestRelease = $JSON.Sophia_Script_Windows_11_LTSC_2024
				$URL = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.11.LTSC.2024.v$LatestRelease.zip"
				$Hash = "Hash_Sophia_Script_Windows_11_LTSC_2024_PowerShell_5_1"
			}
		}
	}
	{[int]$_ -ge 26200}
	{
		# Windows 11
		if ($packageParameters -and $packageParameters.Contains("PS7"))
		{
			# Windows 11 Arm
			if ((Get-CimInstance -Namespace root/CIMV2 -ClassName CIM_Processor).Architecture -eq 12)
			{
				$LatestRelease = $JSON.Sophia_Script_Windows_11
				$URL = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.11.Arm.PowerShell.7.v$LatestRelease.zip"
				$Hash = "Hash_Sophia_Script_Windows_11_Arm_PowerShell_7"
			}
			else
			{
				$LatestRelease = $JSON.Sophia_Script_Windows_11
				$URL = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.11.PowerShell.7.v$LatestRelease.zip"
				$Hash = "Hash_Sophia_Script_Windows_11_PowerShell_7"
			}
		}
		else
		{
			# Windows 11 Arm
			if ((Get-CimInstance -Namespace root/CIMV2 -ClassName CIM_Processor).Architecture -eq 12)
			{
				$LatestRelease = $JSON.Sophia_Script_Windows_11
				$URL = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.11.Arm.v$LatestRelease.zip"
				$Hash = "Hash_Sophia_Script_Windows_11_Arm_PowerShell_5_1"
			}
			else
			{
				$LatestRelease = $JSON.Sophia_Script_Windows_11
				$URL = "https://github.com/farag2/Sophia-Script-for-Windows/releases/download/$LatestGitHubRelease/Sophia.Script.for.Windows.11.v$LatestRelease.zip"
				$Hash = "Hash_Sophia_Script_Windows_11_PowerShell_5_1"
			}
		}
	}
}

Write-Verbose -Message "URL is $URL. Hash is $Hash" -Verbose

$Downloads = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
$Parameters = @{
	PackageName   = $env:ChocolateyPackageName
	UnzipLocation = $Downloads
	Url           = $URL
	Checksum      = $Hash
	ChecksumType  = "sha256"
	Verbose       = $true
}
Install-ChocolateyZipPackage @Parameters
