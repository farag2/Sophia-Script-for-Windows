<#
	.SYNOPSIS
	Write registry keys for extensions for Set-Association function

	.VERSION
	7.0.4

	.DATE
	05.01.2026

	.COPYRIGHT
	(c) 2014—2026 Team Sophia

	.LINK
	https://github.com/farag2/Sophia-Script-for-Windows
#>
function Write-ExtensionKeys
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

	# We have to use GetValue() due to "Set-StrictMode -Version Latest"
	$OrigProgID = [Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Classes\$Extension", "", $null)
	if ($OrigProgID)
	{
		# Save ProgIds history with extensions or protocols for the system ProgId
		$Global:RegisteredProgIDs += $OrigProgID
	}

	# We have to use GetValue() due to "Set-StrictMode -Version Latest"
	if ([Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Classes\$Extension", "", $null) -ne "")
	{
		# Save possible ProgIds history with extension
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts -Name "$($ProgID)_$($Extension)" -PropertyType DWord -Value 0 -Force
	}

	$Name = "{0}_$($Extension)" -f (Split-Path -Path $ProgId -Leaf)
	New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts -Name $Name -PropertyType DWord -Value 0 -Force

	if ("$($ProgID)_$($Extension)" -ne $Name)
	{
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts -Name "$($ProgID)_$($Extension)" -PropertyType DWord -Value 0 -Force
	}

	# If ProgId doesn't exist set the specified ProgId for the extensions
	# We have to use GetValue() due to "Set-StrictMode -Version Latest"
	if (-not [Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Classes\$Extension", "", $null))
	{
		if (-not (Test-Path -Path "HKCU:\Software\Classes\$Extension"))
		{
			New-Item -Path "HKCU:\Software\Classes\$Extension" -Force
		}
		New-ItemProperty -Path "HKCU:\Software\Classes\$Extension" -Name "(default)" -PropertyType String -Value $ProgId -Force
	}

	# Set the specified ProgId in the possible options for the assignment
	if (-not (Test-Path -Path "HKCU:\Software\Classes\$Extension\OpenWithProgids"))
	{
		New-Item -Path "HKCU:\Software\Classes\$Extension\OpenWithProgids" -Force
	}
	New-ItemProperty -Path "HKCU:\Software\Classes\$Extension\OpenWithProgids" -Name $ProgId -PropertyType None -Value ([byte[]]@()) -Force

	# Set the system ProgId to the extension parameters for File Explorer to the possible options for the assignment, and if absent set the specified ProgId
	# We have to use GetValue() due to "Set-StrictMode -Version Latest"
	if ($OrigProgID)
	{
		if (-not (Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\OpenWithProgids"))
		{
			New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\OpenWithProgids" -Force
		}
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\OpenWithProgids" -Name $OrigProgID -PropertyType None -Value ([byte[]]@()) -Force
	}

	if (-not (Test-Path -Path "HKCU:\Software\Classes\$Extension\OpenWithProgids"))
	{
		New-Item -Path "HKCU:\Software\Classes\$Extension\OpenWithProgids" -Force
	}
	New-ItemProperty -Path "HKCU:\Software\Classes\$Extension\OpenWithProgids" -Name $ProgID -PropertyType None -Value ([byte[]]@()) -Force

	# A small pause added to complete all operations, unless sometimes PowerShell has not time to clear reguistry permissions
	Start-Sleep -Seconds 1

	# Removing the UserChoice key
	[WinAPI.Action]::DeleteKey([Microsoft.Win32.RegistryHive]::CurrentUser, "Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice")
	Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice" -Force -ErrorAction Ignore

	# Setting parameters in UserChoice. The key is being autocreated
	if (-not (Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice"))
	{
		New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice" -Force
	}

	# We need to remove DENY permission set for user before setting a value
	if (@(".pdf", "http", "https") -contains $Extension)
	{
		# https://powertoe.wordpress.com/2010/08/28/controlling-registry-acl-permissions-with-powershell/
		$Key = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey("Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice",[Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,[System.Security.AccessControl.RegistryRights]::ChangePermissions)
		$ACL = $key.GetAccessControl()
		$Principal = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
		# https://learn.microsoft.com/en-us/dotnet/api/system.security.accesscontrol.filesystemrights
		$Rule = New-Object -TypeName System.Security.AccessControl.RegistryAccessRule -ArgumentList ($Principal,"FullControl","Deny")
		$ACL.RemoveAccessRule($Rule)
		$Key.SetAccessControl($ACL)

		# We need to use here an approach with "-Command & {}" as there's a variable inside
		& "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell_temp.exe" -Command "& {New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice' -Name ProgId -PropertyType String -Value $ProgID -Force}"
	}
	else
	{
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice" -Name ProgId -PropertyType String -Value $ProgID -Force
	}

	# Getting a hash based on the time of the section's last modification. After creating and setting the first parameter
	$ProgHash = Get-Hash -ProgId $ProgId -Extension $Extension -SubKey "Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice"

	if (-not (Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice"))
	{
		New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice" -Force
	}

	if (@(".pdf", "http", "https") -contains $Extension)
	{
		# We need to use here an approach with "-Command & {}" as there's a variable inside
		& "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell_temp.exe" -Command "& {New-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice' -Name Hash -PropertyType String -Value $ProgHash -Force}"
	}
	else
	{
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice" -Name Hash -PropertyType String -Value $ProgHash -Force
	}

	# Setting a block on changing the UserChoice section
	# We have to use OpenSubKey() due to "Set-StrictMode -Version Latest"
	$OpenSubKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey("Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice", "ReadWriteSubTree", "TakeOwnership")
	if ($OpenSubKey)
	{
		$Acl = [System.Security.AccessControl.RegistrySecurity]::new()
		# Get current user SID
		$UserSID = (Get-CimInstance -ClassName Win32_UserAccount | Where-Object -FilterScript {$_.Name -eq $env:USERNAME}).SID
		$Acl.SetSecurityDescriptorSddlForm("O:$UserSID`G:$UserSID`D:AI(D;;DC;;;$UserSID)")
		$OpenSubKey.SetAccessControl($Acl)
		$OpenSubKey.Close()
	}
}
