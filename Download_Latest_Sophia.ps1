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

	# Stop silently: "exit" would close the console if the function was called via Import-TabCompletion.ps1
	throw [System.Management.Automation.PipelineStoppedException]::new()
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

	# Stop silently: "exit" would close the console if the function was called via Import-TabCompletion.ps1
	throw [System.Management.Automation.PipelineStoppedException]::new()
}

New-Item -Path "$env:SystemDrive\Sophia_Script_Temp" -ItemType Directory -Force

# Download only the needed edition folder: about 0.6 MB instead of the whole repository archive (about 12 MB)
# If the GitHub API is unreachable or its limit of 60 requests per hour for an IP address is reached, the whole archive is downloaded as before
$FolderDownloaded = $false

try
{
	# Get the SHA of the last commit. Files are downloaded by the SHA, not by the branch name:
	# raw.githubusercontent.com caches files of a branch for several minutes, so right after a push files from different commits could be mixed
	$Parameters = @{
		Uri             = "https://api.github.com/repos/farag2/Sophia-Script-for-Windows/commits/main"
		Headers         = @{Accept = "application/vnd.github.sha"}
		UseBasicParsing = $true
		TimeoutSec      = 10
		Verbose         = $true
	}
	$Commit = ([string](Invoke-RestMethod @Parameters)).Trim()

	if ($Commit.Length -ne 40)
	{
		throw "Cannot get the last commit SHA"
	}

	# Get all files and folders of the commit with one request
	$Parameters = @{
		Uri             = "https://api.github.com/repos/farag2/Sophia-Script-for-Windows/git/trees/$($Commit)?recursive=1"
		UseBasicParsing = $true
		TimeoutSec      = 10
		Verbose         = $true
	}
	$Tree = Invoke-RestMethod @Parameters

	if ($Tree.truncated)
	{
		Write-Verbose -Message "GitHub returned not all files" -Verbose
		# Stop silently
		throw [System.Management.Automation.PipelineStoppedException]::new()
	}

	# Items of the edition folder. "type" is "tree" for a folder and "blob" for a file
	$Items = $Tree.tree | Where-Object -FilterScript {$_.path.StartsWith("src/$Version/")}
	$Folders = @($Items | Where-Object -FilterScript {$_.type -eq "tree"})
	$Files = @($Items | Where-Object -FilterScript {$_.type -eq "blob"})

	if ($Files.Count -eq 0)
	{
		Write-Verbose -Message "src/$Version not found" -Verbose
		# Stop silently
		throw [System.Management.Automation.PipelineStoppedException]::new()
	}

	# Paths in the repository start with "src/", e.g. src/Sophia_Script_for_Windows_11/Module/Sophia.psm1
	New-Item -Path "$env:SystemDrive\Sophia_Script_Temp\$Version" -ItemType Directory -Force
	foreach ($Folder in $Folders)
	{
		New-Item -Path "$env:SystemDrive\Sophia_Script_Temp\$($Folder.path.Substring(4))" -ItemType Directory -Force
	}

	# Invoke-WebRequest downloads files one by one, so HttpClient is used to download all files at the same time
	Add-Type -AssemblyName System.Net.Http

	# PowerShell 5.1 opens only 2 connections to the same server by default
	[System.Net.ServicePointManager]::DefaultConnectionLimit = 16

	# Text files are compressed by the server, so less data is downloaded
	$HttpClientHandler = [System.Net.Http.HttpClientHandler]::new()
	$HttpClientHandler.AutomaticDecompression = [System.Net.DecompressionMethods]::GZip -bor [System.Net.DecompressionMethods]::Deflate

	$HttpClient = [System.Net.Http.HttpClient]::new($HttpClientHandler)
	$HttpClient.Timeout = [timespan]::FromSeconds(60)

	try
	{
		# Start all downloads. Files are kept as bytes, so encoding and BOM stay as in the repository
		$Tasks = foreach ($File in $Files)
		{
			$HttpClient.GetByteArrayAsync("https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/$Commit/$($File.path)")
		}

		# Wait for all downloads. If any of them fails, an exception is thrown
		[System.Threading.Tasks.Task]::WaitAll([System.Threading.Tasks.Task[]]$Tasks)

		for ($i = 0; $i -lt $Files.Count; $i++)
		{
			[System.IO.File]::WriteAllBytes("$env:SystemDrive\Sophia_Script_Temp\$($Files[$i].path.Substring(4))", $Tasks[$i].Result)
		}
	}
	finally
	{
		$HttpClient.Dispose()
	}

	Write-Verbose -Message "Downloaded $($Files.Count) files of $Version, commit $Commit" -Verbose

	$FolderDownloaded = $true
}
catch
{
	Write-Verbose -Message "Cannot download the $Version folder only, so the whole archive will be downloaded: $($_.Exception.Message)" -Verbose

	# Remove partially downloaded files
	Remove-Item -Path "$env:SystemDrive\Sophia_Script_Temp\$Version" -Recurse -Force -ErrorAction Ignore
}

try
{
	if (-not $FolderDownloaded)
	{
		# https://github.com/farag2/Sophia-Script-for-Windows/archive/refs/heads/main.zip
		$Parameters = @{
			Uri             = "https://codeload.github.com/farag2/Sophia-Script-for-Windows/zip/refs/heads/main"
			OutFile         = "$env:SystemDrive\Sophia_Script_Temp\main.zip"
			UseBasicParsing = $true
			Verbose         = $true
		}
		Invoke-WebRequest @Parameters
	}

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

	# Stop silently: "exit" would close the console if the function was called via Import-TabCompletion.ps1
	throw [System.Management.Automation.PipelineStoppedException]::new()
}

if (-not $FolderDownloaded)
{
	# tar.exe cannot extract an archive if it is located in a folder whose path includes $env:USERPROFILE path, so we download the archive to the $env:SystemDrive\Sophia_Script_Temp folder
	& "$env:SystemRoot\System32\tar.exe" -xvf "$env:SystemDrive\Sophia_Script_Temp\main.zip" -C $env:SystemDrive\Sophia_Script_Temp --strip-components=2 "Sophia-Script-for-Windows-main/src/$Version"
}

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

	# Stop silently: "exit" would close the console if the function was called via Import-TabCompletion.ps1
	throw [System.Management.Automation.PipelineStoppedException]::new()
}

New-Item -Path "$env:SystemDrive\Sophia_Script_Temp\$Version\Module\Binaries" -ItemType Directory -Force

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
