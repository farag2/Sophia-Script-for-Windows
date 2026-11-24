<#
	.SYNOPSIS
	Write registry keys for extensions for Set-Association function

	.VERSION
	8.1.0

	.DATE
	31.10.2026

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

	# Write the UserChoice key with its hash, and set the same block Windows sets on it: DENY KEY_SET_VALUE for the current user
	Write-UserChoice -SubKey "Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\$Extension\UserChoice" -ProgId $ProgId -Extension $Extension -Protect
}
