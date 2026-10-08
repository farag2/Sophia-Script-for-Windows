<#
	.SYNOPSIS
	Write registry keys for extensions for Set-Association function

	.VERSION
	7.3.0

	.DATE
	05.09.2026

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

	# We have to use GetValue() due to "Set-StrictMode -Version Latest"
	$OrigProgID = [Microsoft.Win32.Registry]::GetValue("HKEY_LOCAL_MACHINE\SOFTWARE\Classes\$Extension", "", $null)

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

	# The hash is derived from the key's last write time truncated to minutes, so ProgId and Hash have to be written within the same minute
	# Two powershell_temp.exe launches and the first Add-Type compilation in Get-Hash take a few seconds, so skip the end of the current minute
	if ((Get-Date).Second -ge 50)
	{
		Start-Sleep -Seconds (60 - (Get-Date).Second)
	}

	# Microsoft has blocked write access to UserChoice key with KB5034765 release, so we have to write values with a copy of powershell.exe to bypass UCPD driver restrictions
	# UCPD driver tracks all executables to block the access to the registry so all UserChoice records will be made within powershell_temp.exe
	$SubKey = "Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice"
	$Path   = "HKCU:\$SubKey"

	& "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell_temp.exe" -NoProfile -Command {
		param ($SubKey, $Path, $ProgId)

		[Microsoft.Win32.Registry]::CurrentUser.DeleteSubKey($SubKey, $false)
		New-Item -Path $Path -Force
		New-ItemProperty -Path $Path -Name ProgId -PropertyType String -Value $ProgId -Force
	} -args $SubKey, $Path, $ProgId

	# The hash is derived from the key's last write time, so it has to be calculated after ProgId is written
	$ProgHash = Get-Hash -ProgId $ProgId -Extension $Extension -SubKey $SubKey

	# Writing the hash and then setting the same block Windows sets on UserChoice: DENY KEY_SET_VALUE for the current user
	# Writing the owner needs WRITE_OWNER and writing the DACL needs WRITE_DAC, so both rights are requested
	$UserSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
	$SDDL    = "O:$($UserSID)G:$($UserSID)D:AI(D;;DC;;;$($UserSID))"

	& "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell_temp.exe" -NoProfile -Command {
		param ($Path, $ProgHash, $SubKey, $SDDL)

		New-ItemProperty -Path $Path -Name Hash -PropertyType String -Value $ProgHash -Force

		$Key = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey($SubKey, "ReadWriteSubTree", "ChangePermissions, TakeOwnership")
		$Acl = [System.Security.AccessControl.RegistrySecurity]::new()
		$Acl.SetSecurityDescriptorSDDLForm($SDDL)
		$Key.SetAccessControl($Acl)
		$Key.Close()
	} -args $Path, $ProgHash, $SubKey, $SDDL
}
