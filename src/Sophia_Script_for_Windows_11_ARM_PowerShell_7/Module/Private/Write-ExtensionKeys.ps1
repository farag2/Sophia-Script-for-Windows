<#
	.SYNOPSIS
	Write registry keys for extensions for Set-Association function

	.VERSION
	7.3.0

	.DATE
	03.09.2026

	.COPYRIGHT
	(c) 2014—2026 Team Sophia

	.LINK
	https://github.com/farag2/Sophia-Script-for-Windows
#>
function Global:Write-ExtensionKeys
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

	$SubKey = "Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice"
	$Path   = "HKCU:\$SubKey"

	# We have to use GetValue() due to "Set-StrictMode -Version Latest"
	$OrigProgID = [Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Classes\$Extension", "", $null)
	if ($OrigProgID)
	{
		# Save ProgIds history with extensions or protocols for the system ProgId
		$Global:RegisteredProgIDs += $OrigProgID
	}

	# Save possible ProgIds history with extension: the full ProgId and its leaf (they differ for "Applications\app.exe" style ProgIds)
	$ToastNames = @("$($ProgId)_$($Extension)", ("{0}_{1}" -f (Split-Path -Path $ProgId -Leaf), $Extension)) | Sort-Object -Unique
	foreach ($Name in $ToastNames)
	{
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts -Name $Name -PropertyType DWord -Value 0 -Force
	}

	# If the system ProgId doesn't exist set the specified ProgId for the extension
	if (-not $OrigProgID)
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

	# Set the system ProgId to the extension parameters for File Explorer to the possible options for the assignment
	if ($OrigProgID)
	{
		if (-not (Test-Path -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\OpenWithProgids"))
		{
			New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\OpenWithProgids" -Force
		}
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\OpenWithProgids" -Name $OrigProgID -PropertyType None -Value ([byte[]]@()) -Force
	}

	Start-Sleep -Seconds 1

	# UCPD driver blocks access to UserChoice keys by process name (powershell.exe, reg.exe, ...), and the list of protected extensions is not documented,
	# so every UserChoice operation is done from a renamed copy of powershell.exe regardless of the extension
	# The DENY ACE on UserChoice covers KEY_SET_VALUE only, so the key is deleted and recreated with the parent's inherited (clean) ACL instead of editing the DACL
	& "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell_temp.exe" -NoProfile -Command "& {[Microsoft.Win32.Registry]::CurrentUser.DeleteSubKey('$SubKey', `$false); New-Item -Path '$Path' -Force; New-ItemProperty -Path '$Path' -Name ProgId -PropertyType String -Value '$ProgId' -Force}"

	# The hash is derived from the key's last write time, so it has to be calculated after ProgId is written
	$ProgHash = Get-Hash -ProgId $ProgId -Extension $Extension -SubKey $SubKey

	# Writing the hash and then setting the same block Windows sets on UserChoice: DENY KEY_SET_VALUE for the current user
	# Writing the owner needs WRITE_OWNER and writing the DACL needs WRITE_DAC, so both rights are requested
	$UserSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
	$Sddl    = "O:$($UserSID)G:$($UserSID)D:AI(D;;DC;;;$($UserSID))"

	& "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell_temp.exe" -NoProfile -Command "& {New-ItemProperty -Path '$Path' -Name Hash -PropertyType String -Value '$ProgHash' -Force; `$Key = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('$SubKey', 'ReadWriteSubTree', 'ChangePermissions, TakeOwnership'); `$Acl = [System.Security.AccessControl.RegistrySecurity]::new(); `$Acl.SetSecurityDescriptorSddlForm('$Sddl'); `$Key.SetAccessControl(`$Acl); `$Key.Close()}"
}
