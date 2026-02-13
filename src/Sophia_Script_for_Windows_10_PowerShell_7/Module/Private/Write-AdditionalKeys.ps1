<#
	.SYNOPSIS
	Write registry keys for Set-Association function

	.VERSION
	7.1.1

	.DATE
	13.02.2026

	.COPYRIGHT
	(c) 2014—2026 Team Sophia

	.LINK
	https://github.com/farag2/Sophia-Script-for-Windows
#>
function Write-AdditionalKeys
{
	Param
	(
		[Parameter(
			Mandatory = $true,
			Position = 0
		)]
		[string]
		$ProgId,

		[Parameter(
			Mandatory = $true,
			Position = 1
		)]
		[string]
		$Extension
	)

	# If there is a ProgId extension, overwrite it to the configured value by default
	# We have to use GetValue() due to "Set-StrictMode -Version Latest"
	if ([Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Classes\$Extension", "", $null))
	{
		if (-not (Test-Path -Path Registry::HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\FileAssociations\ProgIds))
		{
			New-Item -Path Registry::HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\FileAssociations\ProgIds -Force
		}
		New-ItemProperty -Path Registry::HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\FileAssociations\ProgIds -Name "_$($Extension)" -PropertyType DWord -Value 1 -Force
	}

	# Setting 'NoOpenWith' for all registered the extension ProgIDs
	# We have to check everything due to "Set-StrictMode -Version Latest"
	if (Get-Item -Path "Registry::HKEY_CLASSES_ROOT\$Extension\OpenWithProgids" -ErrorAction Ignore)
	{
		[psobject]$OpenSubkey = (Get-Item -Path "Registry::HKEY_CLASSES_ROOT\$Extension\OpenWithProgids" -ErrorAction Ignore).Property
		if ($OpenSubkey)
		{
			foreach ($AppxProgID in ($OpenSubkey | Where-Object -FilterScript {$_ -match "AppX"}))
			{
				# If an app is installed
				if (Get-ItemPropertyValue -Path "HKCU:\Software\Classes\$AppxProgID\Shell\open" -Name PackageId)
				{
					# If the specified ProgId is equal to UWP installed ProgId
					if ($ProgId -eq $AppxProgID)
					{
						# Remove association limitations for this UWP apps
						Remove-ItemProperty -Path "HKCU:\Software\Classes\$AppxProgID" -Name NoOpenWith, NoStaticDefaultVerb -Force -ErrorAction Ignore
					}
					else
					{
						New-ItemProperty -Path "HKCU:\Software\Classes\$AppxProgID" -Name NoOpenWith -PropertyType String -Value "" -Force
					}

					$Global:RegisteredProgIDs += $AppxProgID
				}
			}
		}
	}

	# We have to use GetValue() due to "Set-StrictMode -Version Latest"
	if ([Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\KindMap", $Extension, $null))
	{
		$picture = (Get-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\KindMap -Name $Extension -ErrorAction Ignore).$Extension
	}
	# We have to use GetValue() due to "Set-StrictMode -Version Latest"
	if ([Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Classes\PBrush\CLSID", "", $null))
	{
		$PBrush = (Get-ItemProperty -Path HKLM:\SOFTWARE\Classes\PBrush\CLSID -Name "(default)" -ErrorAction Ignore)."(default)"
	}

	# We have to check everything due to "Set-StrictMode -Version Latest"
	if (Get-Variable -Name picture -ErrorAction Ignore)
	{
		if (($picture -eq "picture") -and $PBrush)
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts -Name "PBrush_$($Extension)" -PropertyType DWord -Value 0 -Force
		}
	}

	# We have to use GetValue() due to "Set-StrictMode -Version Latest"
	if (([Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\KindMap", $Extension, $null)) -eq "picture")
	{
		$Global:RegisteredProgIDs += "PBrush"
	}

	if ($Extension.Contains("."))
	{
		[string]$Associations = "FileAssociations"
	}
	else
	{
		[string]$Associations = "UrlAssociations"
	}

	foreach ($Item in @((Get-Item -Path "HKLM:\SOFTWARE\RegisteredApplications").Property))
	{
		$Subkey = (Get-ItemProperty -Path "HKLM:\SOFTWARE\RegisteredApplications" -Name $Item -ErrorAction Ignore).$Item
		if ($Subkey)
		{
			if (Test-Path -Path "HKLM:\$Subkey\$Associations")
			{
				$isProgID = [Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\$Subkey\$Associations", $Extension, $null)
				if ($isProgID)
				{
					$Global:RegisteredProgIDs += $isProgID
				}
			}
		}
	}

	Clear-Variable -Name UserRegisteredProgIDs -Force -ErrorAction Ignore
	[array]$UserRegisteredProgIDs = @()

	foreach ($Item in (Get-Item -Path "HKCU:\Software\RegisteredApplications").Property)
	{
		$Subkey = (Get-ItemProperty -Path "HKCU:\Software\RegisteredApplications" -Name $Item -ErrorAction Ignore).$Item
		if ($Subkey)
		{
			if (Test-Path -Path "HKCU:\$Subkey\$Associations")
			{
				$isProgID = [Microsoft.Win32.Registry]::GetValue("HKEY_CURRENT_USER\$Subkey\$Associations", $Extension, $null)
				if ($isProgID)
				{
					$UserRegisteredProgIDs += $isProgID
				}
			}
		}
	}

	$UserRegisteredProgIDs = ($Global:RegisteredProgIDs + $UserRegisteredProgIDs | Sort-Object -Unique)
	foreach ($UserProgID in $UserRegisteredProgIDs)
	{
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" -Name "$($UserProgID)_$($Extension)" -PropertyType DWord -Value 0 -Force
	}
}
