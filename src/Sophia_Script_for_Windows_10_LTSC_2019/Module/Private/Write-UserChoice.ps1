<#
	.SYNOPSIS
	Write UserChoice registry keys with their hashes for Set-Association and Import-Associations functions

	.VERSION
	7.1.0

	.DATE
	31.10.2026

	.COPYRIGHT
	(c) 2014—2026 Team Sophia

	.LINK
	https://github.com/farag2/Sophia-Script-for-Windows
#>
function Global:Write-UserChoice
{
	[CmdletBinding(DefaultParameterSetName = "Write")]
	Param
	(
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Write"
		)]
		[string]
		$SubKey,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Write"
		)]
		[string]
		$ProgId,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Write"
		)]
		[string]
		$Extension,

		# Set the same block Windows sets on UserChoice of an extension: DENY KEY_SET_VALUE for the current user
		[Parameter(
			Mandatory = $false,
			ParameterSetName = "Write"
		)]
		[switch]
		$Protect,

		# Write the keys queued by Import-Associations
		[Parameter(
			Mandatory = $true,
			ParameterSetName = "Flush"
		)]
		[switch]
		$Flush
	)

	if ($PSCmdlet.ParameterSetName -eq "Flush")
	{
		[array]$Choices = $Global:UserChoiceQueue
		Remove-Variable -Name UserChoiceQueue -Scope Global -Force -ErrorAction Ignore
	}
	else
	{
		$Choice = @{
			SubKey    = $SubKey
			ProgId    = $ProgId
			Extension = $Extension
			Protect   = $Protect.IsPresent
		}

		# Import-Associations queues the keys to write them all by a single powershell_temp.exe launch
		if ($null -ne $Global:UserChoiceQueue)
		{
			$Global:UserChoiceQueue.Add($Choice)

			return
		}

		[array]$Choices = $Choice
	}

	if (-not $Choices)
	{
		return
	}

	# Microsoft has blocked write access to UserChoice key with KB5034765 release, so we have to write values with a copy of powershell.exe to bypass UCPD driver restrictions
	# UCPD driver tracks all executables to block the access to the registry so all UserChoice records will be made within powershell_temp.exe
	# Set-Association creates and removes the copy by itself. When the queue is written, Set-Association has already finished
	$PowerShellTemp = "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell_temp.exe"
	$CopyCreated    = -not (Test-Path -Path $PowerShellTemp)
	if ($CopyCreated)
	{
		Copy-Item -Path "$env:SystemRoot\System32\WindowsPowerShell\v1.0\powershell.exe" -Destination $PowerShellTemp -Force
	}

	# Writing the owner needs WRITE_OWNER and writing the DACL needs WRITE_DAC, so both rights are requested
	$UserSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
	$SDDL    = "O:$($UserSID)G:$($UserSID)D:AI(D;;DC;;;$($UserSID))"

	# The keys are passed in a file: a command line is too short for hundreds of them
	$ListFile = "$env:TEMP\UserChoice.txt"

	try
	{
		# The hash is derived from the minute the key is written in, so it is calculated for the current minute beforehand
		# That lets write ProgId and Hash of all keys by a single powershell_temp.exe launch
		# If the minute has changed while the keys were being written, the keys written after that are written once again
		foreach ($Attempt in 1..2)
		{
			$Minute = [WinAPI.PatentHash]::GetCurrentMinute()
			$Lines  = foreach ($Choice in $Choices)
			{
				$Choice.SubKey, $Choice.ProgId, (Get-Hash -ProgId $Choice.ProgId -Extension $Choice.Extension -Minute $Minute), $Choice.Protect -join "`t"
			}
			[System.IO.File]::WriteAllLines($ListFile, [string[]]$Lines, [System.Text.UTF8Encoding]::new($true))

			# .NET methods are used instead of cmdlets: powershell_temp.exe doesn't load the registry provider and returns no objects, so it finishes faster
			& $PowerShellTemp -NoProfile -Command {
				param ($ListFile, $SDDL)

				foreach ($Line in [System.IO.File]::ReadAllLines($ListFile))
				{
					$SubKey, $ProgId, $ProgHash, $Protect = $Line.Split("`t")

					[Microsoft.Win32.Registry]::CurrentUser.DeleteSubKey($SubKey, $false)
					$Key = [Microsoft.Win32.Registry]::CurrentUser.CreateSubKey($SubKey)
					$Key.SetValue("ProgId", $ProgId)
					$Key.SetValue("Hash", $ProgHash)
					$Key.Close()

					if ($Protect -eq "True")
					{
						$Key = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey($SubKey, "ReadWriteSubTree", "ChangePermissions, TakeOwnership")
						$Acl = [System.Security.AccessControl.RegistrySecurity]::new()
						$Acl.SetSecurityDescriptorSDDLForm($SDDL)
						$Key.SetAccessControl($Acl)
						$Key.Close()
					}
				}
			} -args $ListFile, $SDDL

			[array]$Choices = $Choices | Where-Object -FilterScript {[WinAPI.PatentHash]::GetKeyMinute($_.SubKey) -ne $Minute}
			if (-not $Choices)
			{
				break
			}
		}
	}
	finally
	{
		Remove-Item -Path $ListFile -Force -ErrorAction Ignore

		if ($CopyCreated)
		{
			Remove-Item -Path $PowerShellTemp -Force -ErrorAction Ignore
		}
	}
}
