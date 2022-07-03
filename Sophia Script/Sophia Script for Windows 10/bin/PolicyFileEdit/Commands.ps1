#requires -Version 2.0

. "$PSScriptRoot\Common.ps1"

<#
	.SYNOPSIS
	Creates or modifies a value in a .pol file

	.DESCRIPTION
	Creates or modifies a value in a .pol file. By default, also updates the version number in the policy's GPT.ini file

	.PARAMETER Path
	Path to the .pol file that is to be modified

	.PARAMETER Key
	The registry key inside the .pol file that you want to modify.

	.PARAMETER ValueName
	The name of the registry value. May be set to an empty string to modify the default value of a key

	.PARAMETER Data
	The new value to assign to the registry key / value. Cannot be $null, but can be set to an empty string or empty array

	.PARAMETER Type
	The type of registry value to set in the policy file. Cannot be set to Unknown or None, but all other values of the RegistryValueKind enum are legal

	.PARAMETER NoGptIniUpdate
	When this switch is used, the command will not attempt to update the version number in the GPT.ini file

	.EXAMPLE
	Set-PolicyFileEntry -Path $env:SystemRoot\system32\GroupPolicy\Machine\registry.pol -Key Software\Policies\Something -ValueName SomeValue -Data 'Hello, World!' -Type String
	Assigns a value of 'Hello, World!' to the String value Software\Policies\Something\SomeValue in the local computer Machine GPO. Updates the Machine version counter in $env:SystemRoot\system32\GroupPolicy\GPT.ini

	.EXAMPLE
	Set-PolicyFileEntry -Path $env:SystemRoot\system32\GroupPolicy\Machine\registry.pol -Key Software\Policies\Something -ValueName SomeValue -Data 'Hello, World!' -Type String -NoGptIniUpdate
	Same as example 1, except this one does not update GPT.ini right away. This can be useful if you want to set multiple values in the policy file and only trigger a single Group Policy refresh

	.EXAMPLE
	Set-PolicyFileEntry -Path $env:SystemRoot\system32\GroupPolicy\Machine\registry.pol -Key Software\Policies\Something -ValueName SomeValue -Data '0x12345' -Type DWord
	Example demonstrating that strings with valid numeric data (including hexadecimal strings beginning with 0x) can be assigned to the numeric types DWord, QWord and Binary

	.EXAMPLE
	$entries = @(
		New-Object psobject -Property @{ValueName = 'MaxXResolution'; Data = 1680}
		New-Object psobject -Property @{ValueName = 'MaxYResolution'; Data = 1050}
	)
	$entries | Set-PolicyFileEntry -Path $env:SystemRoot\system32\GroupPolicy\Machine\registry.pol -Key 'SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' -Type DWord

	Example of using pipeline input to set multiple values at once. The advantage to this approach is that the .pol file on disk (and the GPT.ini file) will be updated if _any_ of the specified settings had to be modified,
	and will be left alone if the file already contained all of the correct values.
	The Key and Type properties could have also been specified via the pipeline objects instead of on the command line, but since both values shared the same Key and Type, this example shows that you can pass the values in either way.

	.INPUTS
	The Key, ValueName, Data, and Type properties may be bound via the pipeline by property name

	.OUTPUTS
	None. This command does not generate output

	.NOTES
	If the specified policy file already contains the correct value, the file will not be modified, and the GPT.ini file will not be updated

	.LINK
	Get-PolicyFileEntry

	.LINK
	Remove-PolicyFileEntry

	.LINK
	Update-GptIniVersion

	.LINK
	about_RegistryValuesForAdminTemplates
#>
function Set-PolicyFileEntry
{
	[CmdletBinding(SupportsShouldProcess = $true)]
	param
	(
		[Parameter(
			Mandatory = $true,
			Position = 0
		)]
		[string]
		$Path,

		[Parameter(
			Mandatory = $true,
			Position = 1,
			ValueFromPipelineByPropertyName = $true
		)]
		[string]
		$Key,

		[Parameter(
			Mandatory = $true,
			Position = 2,
			ValueFromPipelineByPropertyName = $true
		)]
		[AllowEmptyString()]
		[string]
		$ValueName,

		[Parameter(
			Mandatory = $true,
			Position = 3,
			ValueFromPipelineByPropertyName = $true
		)]
		[AllowEmptyString()]
		[AllowEmptyCollection()]
		[object]
		$Data,

		[Parameter(ValueFromPipelineByPropertyName = $true)]
		[ValidateScript({
			if ($_ -eq [Microsoft.Win32.RegistryValueKind]::Unknown)
			{
				throw 'Unknown is not a valid value for the Type parameter'
			}

			if ($_ -eq [Microsoft.Win32.RegistryValueKind]::None)
			{
				throw 'None is not a valid value for the Type parameter'
			}

			return $true
		})]
		[Microsoft.Win32.RegistryValueKind]
		$Type = [Microsoft.Win32.RegistryValueKind]::String,

		[switch]
		$NoGptIniUpdate
	)

	begin
	{
		if (Get-Command [G]et-CallerPreference -CommandType Function -Module PreferenceVariables)
		{
			Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
		}

		$dirty = $false

		try
		{
			$policyFile = OpenPolicyFile -Path $Path -ErrorAction Stop
		}
		catch
		{
			$PSCmdlet.ThrowTerminatingError($_)
		}
	}

	process
	{
		$existingEntry = $policyFile.GetValue($Key, $ValueName)

		if (($null -ne $existingEntry) -and ($Type -eq (PolEntryTypeToRegistryValueKind $existingEntry.Type)))
		{
			$existingData = GetEntryData -Entry $existingEntry -Type $Type
			if (DataIsEqual $Data $existingData -Type $Type)
			{
				Write-Verbose "Policy setting '$Key\$ValueName' is already set to '$Data' of type '$Type'."
				return
			}
		}

		Write-Verbose "Configuring '$Key\$ValueName' to value '$Data' of type '$Type'."

		try
		{
			switch ($Type)
			{
				([Microsoft.Win32.RegistryValueKind]::Binary)
				{
					$bytes = $Data -as [byte[]]
					if ($null -eq $bytes)
					{
						$errorRecord = InvalidDataTypeCombinationErrorRecord -Message 'When -Type is set to Binary, -Data must be passed a Byte[] array.'
						$PSCmdlet.ThrowTerminatingError($errorRecord)
					}
					else
					{
						$policyFile.SetBinaryValue($Key, $ValueName, $bytes)
					}

					break
				}

				([Microsoft.Win32.RegistryValueKind]::String)
				{
					$array = @($Data)

					if ($array.Count -ne 1)
					{
						$errorRecord = InvalidDataTypeCombinationErrorRecord -Message 'When -Type is set to String, -Data must be passed a scalar value or single-element array.'
						$PSCmdlet.ThrowTerminatingError($errorRecord)
					}
					else
					{
						$policyFile.SetStringValue($Key, $ValueName, $array[0].ToString())
					}

					break
				}

				([Microsoft.Win32.RegistryValueKind]::ExpandString)
				{
					$array = @($Data)

					if ($array.Count -ne 1)
					{
						$errorRecord = InvalidDataTypeCombinationErrorRecord -Message 'When -Type is set to ExpandString, -Data must be passed a scalar value or single-element array.'
						$PSCmdlet.ThrowTerminatingError($errorRecord)
					}
					else
					{
						$policyFile.SetStringValue($Key, $ValueName, $array[0].ToString(), $true)
					}

					break
				}

				([Microsoft.Win32.RegistryValueKind]::DWord)
				{
					$array = @($Data)
					$dword = ($array | Select-Object -First 1) -as [UInt32]
					if ($null -eq $dword -or $array.Count -ne 1)
					{
						$errorRecord = InvalidDataTypeCombinationErrorRecord -Message 'When -Type is set to DWord, -Data must be passed a valid UInt32 value.'
						$PSCmdlet.ThrowTerminatingError($errorRecord)
					}
					else
					{
						$policyFile.SetDWORDValue($key, $ValueName, $dword)
					}

					break
				}

				([Microsoft.Win32.RegistryValueKind]::QWord)
				{
					$array = @($Data)
					$qword = ($array | Select-Object -First 1) -as [UInt64]
					if ($null -eq $qword -or $array.Count -ne 1)
					{
						$errorRecord = InvalidDataTypeCombinationErrorRecord -Message 'When -Type is set to QWord, -Data must be passed a valid UInt64 value.'
						$PSCmdlet.ThrowTerminatingError($errorRecord)
					}
					else
					{
						$policyFile.SetQWORDValue($key, $ValueName, $qword)
					}

					break
				}

				([Microsoft.Win32.RegistryValueKind]::MultiString)
				{
					$strings = [string[]] @(
						foreach ($item in @($Data))
						{
							$item.ToString()
						}
					)

					$policyFile.SetMultiStringValue($Key, $ValueName, $strings)

					break
				}

			} # switch ($Type)

			$dirty = $true
		}
		catch
		{
			throw
		}
	}

	end
	{
		if ($dirty)
		{
			$doUpdateGptIni = -not $NoGptIniUpdate

			try
			{
				# SavePolicyFile contains the calls to $PSCmdlet.ShouldProcess, and will inherit our
				# WhatIfPreference / ConfirmPreference values from here.
				SavePolicyFile -PolicyFile $policyFile -UpdateGptIni:$doUpdateGptIni -ErrorAction Stop
			}
			catch
			{
				$PSCmdlet.ThrowTerminatingError($_)
			}
		}
	}
}

<#
	.SYNOPSIS
	Retrieves the current setting(s) from a .pol file

	.DESCRIPTION
	Retrieves the current setting(s) from a .pol file

	.PARAMETER Path
	Path to the .pol file that is to be read

	.PARAMETER Key
	The registry key inside the .pol file that you want to read

	.PARAMETER ValueName
	The name of the registry value. May be set to an empty string to read the default value of a key

	.PARAMETER All
	Switch indicating that all entries from the specified .pol file should be output, instead of searching for a specific key / ValueName pair

	.EXAMPLE
	Get-PolicyFileEntry -Path $env:systemroot\system32\GroupPolicy\Machine\registry.pol -Key Software\Policies\Something -ValueName SomeValue
	Reads the value of Software\Policies\Something\SomeValue from the Machine admin templates of the local GPO.
	Either returns an object with the data and type of this registry value (if present), or returns nothing, if not found.

	.EXAMPLE
	Get-PolicyFileEntry -Path $env:systemroot\system32\GroupPolicy\Machine\registry.pol -All
	Outputs all of the registry values from the local machine Administrative Templates

	.INPUTS
	None. This command does not accept pipeline input.

	.OUTPUTS
	If the specified registry value is found, the function outputs a PSCustomObject with the following properties:
	ValueName: The same value that was passed to the -ValueName parameter
	Key:       The same value that was passed to the -Key parameter
	Data:      The current value assigned to the specified Key / ValueName in the .pol file.
	Type:      The RegistryValueKind type of the specified Key / ValueName in the .pol file.
	If the specified registry value is not found in the .pol file, the command returns nothing. No error is produced.

	.LINK
	Set-PolicyFileEntry

	.LINK
	Remove-PolicyFileEntry

	.LINK
	Update-GptIniVersion

	.LINK
	about_RegistryValuesForAdminTemplates
#>
function Get-PolicyFileEntry
{
	[CmdletBinding(DefaultParameterSetName = 'ByKeyAndValue')]
	param (
		[Parameter(
			Mandatory = $true,
			Position = 0
		)]
		[string]
		$Path,

		[Parameter(
			Mandatory = $true,
			Position = 1,
			ParameterSetName = 'ByKeyAndValue'
		)]
		[string]
		$Key,

		[Parameter(
			Mandatory = $true,
			Position = 2,
			ParameterSetName = 'ByKeyAndValue'
		)]
		[string]
		$ValueName,

		[Parameter(
			Mandatory = $true,
			ParameterSetName = 'All'
		)]
		[switch]
		$All
	)

	if (Get-Command [G]et-CallerPreference -CommandType Function -Module PreferenceVariables)
	{
		Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
	}

	try
	{
		$policyFile = OpenPolicyFile -Path $Path -ErrorAction Stop
	}
	catch
	{
		$PSCmdlet.ThrowTerminatingError($_)
	}

	if ($PSCmdlet.ParameterSetName -eq 'ByKeyAndValue')
	{
		$entry = $policyFile.GetValue($Key, $ValueName)

		if ($null -ne $entry)
		{
			PolEntryToPsObject -PolEntry $entry
		}
	}
	else
	{
		foreach ($entry in $policyFile.Entries)
		{
			PolEntryToPsObject -PolEntry $entry
		}
	}
}

<#
	.SYNOPSIS
	Removes a value from a .pol file

	.DESCRIPTION
	Removes a value from a .pol file. By default, also updates the version number in the policy's GPT.ini file

	.PARAMETER Path
	Path to the .pol file that is to be modified

	.PARAMETER Key
	The registry key inside the .pol file from which you want to remove a value

	.PARAMETER ValueName
	The name of the registry value to be removed. May be set to an empty string to remove the default value of a key

	.PARAMETER NoGptIniUpdate
	When this switch is used, the command will not attempt to update the version number in the GPT.ini fil

	.EXAMPLE
	Remove-PolicyFileEntry -Path $env:systemroot\system32\GroupPolicy\Machine\registry.pol -Key Software\Policies\Something -ValueName SomeValue
	Removes the value Software\Policies\Something\SomeValue from the local computer Machine GPO, if present. Updates the Machine version counter in $env:systemroot\system32\GroupPolicy\GPT.ini

	.EXAMPLE
	$entries = @(
		New-Object -TypeName PSObject -Property @{ValueName = 'MaxXResolution'; Data = 1680}
		New-Object -TypeName PSObject -Property @{ValueName = 'MaxYResolution'; Data = 1050}
	)
	$entries | Remove-PolicyFileEntry -Path $env:SystemRoot\system32\GroupPolicy\Machine\registry.pol -Key 'SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'

	Example of using pipeline input to remove multiple values at once. The advantage to this approach is that the .pol file on disk (and the GPT.ini file) will be updated if _any_ of the specified settings had to be removed,
	and will be left alone if the file already did not contain any of those values.

	The Key property could have also been specified via the pipeline objects instead of on the command line, but
	since both values shared the same Key, this example shows that you can pass the value in either way.

	.INPUTS
	The Key and ValueName properties may be bound via the pipeline by property name

	.OUTPUTS
	None. This command does not generate output

	.NOTES
	If the specified policy file is already not present in the .pol file, the file will not be modified, and the GPT.ini file will not be updated

	.LINK
	Get-PolicyFileEntry

	.LINK
	Set-PolicyFileEntry

	.LINK
	Update-GptIniVersion

	.LINK
	about_RegistryValuesForAdminTemplates
#>
function Remove-PolicyFileEntry
{
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Parameter(
			Mandatory = $true,
			Position = 0
		)]
		[string]
		$Path,

		[Parameter(
			Mandatory = $true,
			Position = 1,
			ValueFromPipelineByPropertyName = $true
		)]
		[string]
		$Key,

		[Parameter(
			Mandatory = $true,
			Position = 2,
			ValueFromPipelineByPropertyName = $true
		)]
		[string]
		$ValueName,

		[switch]
		$NoGptIniUpdate
	)

	begin
	{
		if (Get-Command [G]et-CallerPreference -CommandType Function -Module PreferenceVariables)
		{
			Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
		}

		$dirty = $false

		try
		{
			$policyFile = OpenPolicyFile -Path $Path -ErrorAction Stop
		}
		catch
		{
			$PSCmdlet.ThrowTerminatingError($_)
		}
	}

	process
	{
		$entry = $policyFile.GetValue($Key, $ValueName)

		if ($null -eq $entry)
		{
			Write-Verbose "Entry '$Key\$ValueName' is already not present in file '$Path'."
			return
		}

		Write-Verbose "Removing entry '$Key\$ValueName' from file '$Path'"
		$policyFile.DeleteValue($Key, $ValueName)
		$dirty = $true
	}

	end
	{
		if ($dirty)
		{
			$doUpdateGptIni = -not $NoGptIniUpdate

			try
			{
				# SavePolicyFile contains the calls to $PSCmdlet.ShouldProcess, and will inherit our
				# WhatIfPreference / ConfirmPreference values from here.
				SavePolicyFile -PolicyFile $policyFile -UpdateGptIni:$doUpdateGptIni -ErrorAction Stop
			}
			catch
			{
				$PSCmdlet.ThrowTerminatingError($_)
			}
		}
	}
}

<#
	.SYNOPSIS
	Increments the version counter in a GPT.ini file

	.DESCRIPTION
	Increments the version counter in a GPT.ini file

	.PARAMETER Path
	Path to the GPT.ini file that is to be modified

	.PARAMETER PolicyType
	Can be set to either 'Machine', 'User', or both. This affects how the value of the Version number in the ini file is changed

	.EXAMPLE
	Update-GptIniVersion -Path $env:SystemRoot\system32\GroupPolicy\GPT.ini -PolicyType Machine
	Increments the Machine version counter of the local GPO

	.EXAMPLE
	Update-GptIniVersion -Path $env:SystemRoot\system32\GroupPolicy\GPT.ini -PolicyType User
	Increments the User version counter of the local GPO

	.EXAMPLE
	Update-GptIniVersion -Path $env:SystemRoot\system32\GroupPolicy\GPT.ini -PolicyType Machine, User
	Increments both the Machine and User version counters of the local GPO

	.INPUTS
	None. This command does not accept pipeline input.

	.OUTPUTS
	None. This command does not generate output

	.NOTES
	A GPT.ini file contains only a single Version value. However, this represents two separate counters, for machine and user versions.
	The high 16 bits of the value are the User counter, and the low 16 bits are the Machine counter. For example (on PowerShell 3.0and later),
	the Version value when the Machine counter is set to 3 and the User counter is set to 5 can be found by evaluating this expression:
	(5 -shl 16) -bor 3 , which will show up as decimal value 327683 in the INI file.

	.LINK
	Set-PolicyFileEntry

	.LINK
	about_RegistryValuesForAdminTemplates
#>
function Update-GptIniVersion
{
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[Parameter(Mandatory = $true)]
		[ValidateScript({
			if (Test-Path -LiteralPath $_ -PathType Leaf)
			{
				return $true
			}

			throw "Path '$_' does not exist."
		})]
		[string]
		$Path,

		[Parameter(Mandatory = $true)]
		[ValidateSet('Machine', 'User')]
		[string[]]
		$PolicyType
	)

	if (Get-Command [G]et-CallerPreference -CommandType Function -Module PreferenceVariables)
	{
		Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
	}

	try
	{
		IncrementGptIniVersion @PSBoundParameters
	}
	catch
	{
		$PSCmdlet.ThrowTerminatingError($_)
	}
}

# SIG # Begin signature block
# MIIgTAYJKoZIhvcNAQcCoIIgPTCCIDkCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAWcBLp5Go0Yq2e
# WARWCHEIvOxdE5WCmcYIoSD6N4yxq6CCG1YwggO3MIICn6ADAgECAhAM5+DlF9hG
# /o/lYPwb8DA5MA0GCSqGSIb3DQEBBQUAMGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQK
# EwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAiBgNV
# BAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0wNjExMTAwMDAwMDBa
# Fw0zMTExMTAwMDAwMDBaMGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2Vy
# dCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAiBgNVBAMTG0RpZ2lD
# ZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
# AQoCggEBAK0OFc7kQ4BcsYfzt2D5cRKlrtwmlIiq9M71IDkoWGAM+IDaqRWVMmE8
# tbEohIqK3J8KDIMXeo+QrIrneVNcMYQq9g+YMjZ2zN7dPKii72r7IfJSYd+fINcf
# 4rHZ/hhk0hJbX/lYGDW8R82hNvlrf9SwOD7BG8OMM9nYLxj+KA+zp4PWw25EwGE1
# lhb+WZyLdm3X8aJLDSv/C3LanmDQjpA1xnhVhyChz+VtCshJfDGYM2wi6YfQMlqi
# uhOCEe05F52ZOnKh5vqk2dUXMXWuhX0irj8BRob2KHnIsdrkVxfEfhwOsLSSplaz
# vbKX7aqn8LfFqD+VFtD/oZbrCF8Yd08CAwEAAaNjMGEwDgYDVR0PAQH/BAQDAgGG
# MA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFEXroq/0ksuCMS1Ri6enIZ3zbcgP
# MB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3zbcgPMA0GCSqGSIb3DQEBBQUA
# A4IBAQCiDrzf4u3w43JzemSUv/dyZtgy5EJ1Yq6H6/LV2d5Ws5/MzhQouQ2XYFwS
# TFjk0z2DSUVYlzVpGqhH6lbGeasS2GeBhN9/CTyU5rgmLCC9PbMoifdf/yLil4Qf
# 6WXvh+DfwWdJs13rsgkq6ybteL59PyvztyY1bV+JAbZJW58BBZurPSXBzLZ/wvFv
# hsb6ZGjrgS2U60K3+owe3WLxvlBnt2y98/Efaww2BxZ/N3ypW2168RJGYIPXJwS+
# S86XvsNnKmgR34DnDDNmvxMNFG7zfx9jEB76jRslbWyPpbdhAbHSoyahEHGdreLD
# +cOZUbcrBwjOLuZQsqf6CkUvovDyMIIFJDCCBAygAwIBAgIQCRrHC94asIH2W7lu
# /i1eITANBgkqhkiG9w0BAQsFADByMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGln
# aUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYDVQQDEyhE
# aWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgQ29kZSBTaWduaW5nIENBMB4XDTE3MDYy
# MTAwMDAwMFoXDTE4MDgyOTEyMDAwMFowYTELMAkGA1UEBhMCQ0ExCzAJBgNVBAgT
# Ak9OMREwDwYDVQQHEwhCcmFtcHRvbjEYMBYGA1UEChMPRGF2aWQgTGVlIFd5YXR0
# MRgwFgYDVQQDEw9EYXZpZCBMZWUgV3lhdHQwggEiMA0GCSqGSIb3DQEBAQUAA4IB
# DwAwggEKAoIBAQDA/6cBpCOYJk6IY2cPgY23dVjs3xYcJKeSDIvnfvBl/SFqvEYX
# tJkfbETnjp2XkZ9UFk2j5b5JpRg25GpkTo4a0MYMAUyn7tfotxG64sjxsNLXrrYN
# nx3q2QUt4dpRjG11giMyFSjAFPjPO1JbM9976GN96ldiOUX3yH+UM4Ow6zS+0iGq
# MSnd88iPs/CqphaVTDBN+ZmU864hnzGhjiMBlyjw4z/aLtJeopeLmuk8wyxN+N3v
# P/wsFwmPpycxSU3hPlqa2GDDswYtiMuf5NOdG3CfEEX9Ntrd2NxpjXOPGDt6Ko0C
# 0mYSd9qgzznxuweJPXXg4GR6jeVZrq4pQZFlAgMBAAGjggHFMIIBwTAfBgNVHSME
# GDAWgBRaxLl7KgqjpepxA8Bg+S32ZXUOWDAdBgNVHQ4EFgQUDkf1juW1Z6Tp40ck
# YDz0SxGZDn8wDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMHcG
# A1UdHwRwMG4wNaAzoDGGL2h0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9zaGEyLWFz
# c3VyZWQtY3MtZzEuY3JsMDWgM6Axhi9odHRwOi8vY3JsNC5kaWdpY2VydC5jb20v
# c2hhMi1hc3N1cmVkLWNzLWcxLmNybDBMBgNVHSAERTBDMDcGCWCGSAGG/WwDATAq
# MCgGCCsGAQUFBwIBFhxodHRwczovL3d3dy5kaWdpY2VydC5jb20vQ1BTMAgGBmeB
# DAEEATCBhAYIKwYBBQUHAQEEeDB2MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5k
# aWdpY2VydC5jb20wTgYIKwYBBQUHMAKGQmh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0
# LmNvbS9EaWdpQ2VydFNIQTJBc3N1cmVkSURDb2RlU2lnbmluZ0NBLmNydDAMBgNV
# HRMBAf8EAjAAMA0GCSqGSIb3DQEBCwUAA4IBAQAqho5skBHIeG738khh3muTynOW
# TWwHZ4fJI0oWgAVLK/g1VNHKCWY+fqoxdXZcRZt6jZtklmuYAPx3q86XtOniVqYk
# EFIcJgBFJtBuAQDeYFyKyMWoidqGVQ4wIrzArUEWg6q/ba36S+u1TqnZr3GJ3+y0
# G9iNbc1nEzKoUPARo3rgWEirgARMjNCPSufDLHNsjPHCXwUNxbRtq+kiUxBgOIF7
# Rn4ADci9pCalNeby/V7I2poj5nQ22f2P7nwIMuIFszOsV7BBfI2ni9GzPhKBCwLy
# K6s3wzPQyuUewKiG84dQcnOIZO9f/8aB30BVu6FSnNvMdMjyLIRtlPP0txxvMIIF
# MDCCBBigAwIBAgIQBAkYG1/Vu2Z1U0O1b5VQCDANBgkqhkiG9w0BAQsFADBlMQsw
# CQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cu
# ZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJvb3Qg
# Q0EwHhcNMTMxMDIyMTIwMDAwWhcNMjgxMDIyMTIwMDAwWjByMQswCQYDVQQGEwJV
# UzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQu
# Y29tMTEwLwYDVQQDEyhEaWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgQ29kZSBTaWdu
# aW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA+NOzHH8OEa9n
# dwfTCzFJGc/Q+0WZsTrbRPV/5aid2zLXcep2nQUut4/6kkPApfmJ1DcZ17aq8JyG
# pdglrA55KDp+6dFn08b7KSfH03sjlOSRI5aQd4L5oYQjZhJUM1B0sSgmuyRpwsJS
# 8hRniolF1C2ho+mILCCVrhxKhwjfDPXiTWAYvqrEsq5wMWYzcT6scKKrzn/pfMuS
# oeU7MRzP6vIK5Fe7SrXpdOYr/mzLfnQ5Ng2Q7+S1TqSp6moKq4TzrGdOtcT3jNEg
# JSPrCGQ+UpbB8g8S9MWOD8Gi6CxR93O8vYWxYoNzQYIH5DiLanMg0A9kczyen6Yz
# qf0Z3yWT0QIDAQABo4IBzTCCAckwEgYDVR0TAQH/BAgwBgEB/wIBADAOBgNVHQ8B
# Af8EBAMCAYYwEwYDVR0lBAwwCgYIKwYBBQUHAwMweQYIKwYBBQUHAQEEbTBrMCQG
# CCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYBBQUHMAKG
# N2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJv
# b3RDQS5jcnQwgYEGA1UdHwR6MHgwOqA4oDaGNGh0dHA6Ly9jcmw0LmRpZ2ljZXJ0
# LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwOqA4oDaGNGh0dHA6Ly9j
# cmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwTwYD
# VR0gBEgwRjA4BgpghkgBhv1sAAIEMCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3
# LmRpZ2ljZXJ0LmNvbS9DUFMwCgYIYIZIAYb9bAMwHQYDVR0OBBYEFFrEuXsqCqOl
# 6nEDwGD5LfZldQ5YMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6enIZ3zbcgPMA0G
# CSqGSIb3DQEBCwUAA4IBAQA+7A1aJLPzItEVyCx8JSl2qB1dHC06GsTvMGHXfgtg
# /cM9D8Svi/3vKt8gVTew4fbRknUPUbRupY5a4l4kgU4QpO4/cY5jDhNLrddfRHnz
# NhQGivecRk5c/5CxGwcOkRX7uq+1UcKNJK4kxscnKqEpKBo6cSgCPC6Ro8AlEeKc
# FEehemhor5unXCBc2XGxDI+7qPjFEmifz0DLQESlE/DmZAwlCEIysjaKJAL+L3J+
# HNdJRZboWR3p+nRka7LrZkPas7CM1ekN3fYBIM6ZMWM9CBoYs4GbT8aTEAb8B4H6
# i9r5gkn3Ym6hU/oSlBiFLpKR6mhsRDKyZqHnGKSaZFHvMIIGajCCBVKgAwIBAgIQ
# AwGaAjr/WLFr1tXq5hfwZjANBgkqhkiG9w0BAQUFADBiMQswCQYDVQQGEwJVUzEV
# MBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29t
# MSEwHwYDVQQDExhEaWdpQ2VydCBBc3N1cmVkIElEIENBLTEwHhcNMTQxMDIyMDAw
# MDAwWhcNMjQxMDIyMDAwMDAwWjBHMQswCQYDVQQGEwJVUzERMA8GA1UEChMIRGln
# aUNlcnQxJTAjBgNVBAMTHERpZ2lDZXJ0IFRpbWVzdGFtcCBSZXNwb25kZXIwggEi
# MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCjZF38fLPggjXg4PbGKuZJdTvM
# buBTqZ8fZFnmfGt/a4ydVfiS457VWmNbAklQ2YPOb2bu3cuF6V+l+dSHdIhEOxnJ
# 5fWRn8YUOawk6qhLLJGJzF4o9GS2ULf1ErNzlgpno75hn67z/RJ4dQ6mWxT9RSOO
# hkRVfRiGBYxVh3lIRvfKDo2n3k5f4qi2LVkCYYhhchhoubh87ubnNC8xd4EwH7s2
# AY3vJ+P3mvBMMWSN4+v6GYeofs/sjAw2W3rBerh4x8kGLkYQyI3oBGDbvHN0+k7Y
# /qpA8bLOcEaD6dpAoVk62RUJV5lWMJPzyWHM0AjMa+xiQpGsAsDvpPCJEY93AgMB
# AAGjggM1MIIDMTAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIwADAWBgNVHSUB
# Af8EDDAKBggrBgEFBQcDCDCCAb8GA1UdIASCAbYwggGyMIIBoQYJYIZIAYb9bAcB
# MIIBkjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzCC
# AWQGCCsGAQUFBwICMIIBVh6CAVIAQQBuAHkAIAB1AHMAZQAgAG8AZgAgAHQAaABp
# AHMAIABDAGUAcgB0AGkAZgBpAGMAYQB0AGUAIABjAG8AbgBzAHQAaQB0AHUAdABl
# AHMAIABhAGMAYwBlAHAAdABhAG4AYwBlACAAbwBmACAAdABoAGUAIABEAGkAZwBp
# AEMAZQByAHQAIABDAFAALwBDAFAAUwAgAGEAbgBkACAAdABoAGUAIABSAGUAbAB5
# AGkAbgBnACAAUABhAHIAdAB5ACAAQQBnAHIAZQBlAG0AZQBuAHQAIAB3AGgAaQBj
# AGgAIABsAGkAbQBpAHQAIABsAGkAYQBiAGkAbABpAHQAeQAgAGEAbgBkACAAYQBy
# AGUAIABpAG4AYwBvAHIAcABvAHIAYQB0AGUAZAAgAGgAZQByAGUAaQBuACAAYgB5
# ACAAcgBlAGYAZQByAGUAbgBjAGUALjALBglghkgBhv1sAxUwHwYDVR0jBBgwFoAU
# FQASKxOYspkH7R7for5XDStnAs0wHQYDVR0OBBYEFGFaTSS2STKdSip5GoNL9B6J
# wcp9MH0GA1UdHwR2MHQwOKA2oDSGMmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9E
# aWdpQ2VydEFzc3VyZWRJRENBLTEuY3JsMDigNqA0hjJodHRwOi8vY3JsNC5kaWdp
# Y2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURDQS0xLmNybDB3BggrBgEFBQcBAQRr
# MGkwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBBBggrBgEF
# BQcwAoY1aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJl
# ZElEQ0EtMS5jcnQwDQYJKoZIhvcNAQEFBQADggEBAJ0lfhszTbImgVybhs4jIA+A
# h+WI//+x1GosMe06FxlxF82pG7xaFjkAneNshORaQPveBgGMN/qbsZ0kfv4gpFet
# W7easGAm6mlXIV00Lx9xsIOUGQVrNZAQoHuXx/Y/5+IRQaa9YtnwJz04HShvOlIJ
# 8OxwYtNiS7Dgc6aSwNOOMdgv420XEwbu5AO2FKvzj0OncZ0h3RTKFV2SQdr5D4HR
# mXQNJsQOfxu19aDxxncGKBXp2JPlVRbwuwqrHNtcSCdmyKOLChzlldquxC5ZoGHd
# 2vNtomHpigtt7BIYvfdVVEADkitrwlHCCkivsNRu4PQUCjob4489yq9qjXvc2EQw
# ggbNMIIFtaADAgECAhAG/fkDlgOt6gAK6z8nu7obMA0GCSqGSIb3DQEBBQUAMGUx
# CzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3
# dy5kaWdpY2VydC5jb20xJDAiBgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9v
# dCBDQTAeFw0wNjExMTAwMDAwMDBaFw0yMTExMTAwMDAwMDBaMGIxCzAJBgNVBAYT
# AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2Vy
# dC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IEFzc3VyZWQgSUQgQ0EtMTCCASIwDQYJ
# KoZIhvcNAQEBBQADggEPADCCAQoCggEBAOiCLZn5ysJClaWAc0Bw0p5WVFypxNJB
# Bo/JM/xNRZFcgZ/tLJz4FlnfnrUkFcKYubR3SdyJxArar8tea+2tsHEx6886QAxG
# TZPsi3o2CAOrDDT+GEmC/sfHMUiAfB6iD5IOUMnGh+s2P9gww/+m9/uizW9zI/6s
# VgWQ8DIhFonGcIj5BZd9o8dD3QLoOz3tsUGj7T++25VIxO4es/K8DCuZ0MZdEkKB
# 4YNugnM/JksUkK5ZZgrEjb7SzgaurYRvSISbT0C58Uzyr5j79s5AXVz2qPEvr+yJ
# IvJrGGWxwXOt1/HYzx4KdFxCuGh+t9V3CidWfA9ipD8yFGCV/QcEogkCAwEAAaOC
# A3owggN2MA4GA1UdDwEB/wQEAwIBhjA7BgNVHSUENDAyBggrBgEFBQcDAQYIKwYB
# BQUHAwIGCCsGAQUFBwMDBggrBgEFBQcDBAYIKwYBBQUHAwgwggHSBgNVHSAEggHJ
# MIIBxTCCAbQGCmCGSAGG/WwAAQQwggGkMDoGCCsGAQUFBwIBFi5odHRwOi8vd3d3
# LmRpZ2ljZXJ0LmNvbS9zc2wtY3BzLXJlcG9zaXRvcnkuaHRtMIIBZAYIKwYBBQUH
# AgIwggFWHoIBUgBBAG4AeQAgAHUAcwBlACAAbwBmACAAdABoAGkAcwAgAEMAZQBy
# AHQAaQBmAGkAYwBhAHQAZQAgAGMAbwBuAHMAdABpAHQAdQB0AGUAcwAgAGEAYwBj
# AGUAcAB0AGEAbgBjAGUAIABvAGYAIAB0AGgAZQAgAEQAaQBnAGkAQwBlAHIAdAAg
# AEMAUAAvAEMAUABTACAAYQBuAGQAIAB0AGgAZQAgAFIAZQBsAHkAaQBuAGcAIABQ
# AGEAcgB0AHkAIABBAGcAcgBlAGUAbQBlAG4AdAAgAHcAaABpAGMAaAAgAGwAaQBt
# AGkAdAAgAGwAaQBhAGIAaQBsAGkAdAB5ACAAYQBuAGQAIABhAHIAZQAgAGkAbgBj
# AG8AcgBwAG8AcgBhAHQAZQBkACAAaABlAHIAZQBpAG4AIABiAHkAIAByAGUAZgBl
# AHIAZQBuAGMAZQAuMAsGCWCGSAGG/WwDFTASBgNVHRMBAf8ECDAGAQH/AgEAMHkG
# CCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQu
# Y29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGln
# aUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MIGBBgNVHR8EejB4MDqgOKA2hjRodHRw
# Oi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3Js
# MDqgOKA2hjRodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVk
# SURSb290Q0EuY3JsMB0GA1UdDgQWBBQVABIrE5iymQftHt+ivlcNK2cCzTAfBgNV
# HSMEGDAWgBRF66Kv9JLLgjEtUYunpyGd823IDzANBgkqhkiG9w0BAQUFAAOCAQEA
# RlA+ybcoJKc4HbZbKa9Sz1LpMUerVlx71Q0LQbPv7HUfdDjyslxhopyVw1Dkgrkj
# 0bo6hnKtOHisdV0XFzRyR4WUVtHruzaEd8wkpfMEGVWp5+Pnq2LN+4stkMLA0rWU
# vV5PsQXSDj0aqRRbpoYxYqioM+SbOafE9c4deHaUJXPkKqvPnHZL7V/CSxbkS3BM
# AIke/MV5vEwSV/5f4R68Al2o/vsHOE8Nxl2RuQ9nRc3Wg+3nkg2NsWmMT/tZ4CMP
# 0qquAHzunEIOz5HXJ7cW7g/DvXwKoO4sCFWFIrjrGBpN/CohrUkxg0eVd3HcsRtL
# SxwQnHcUwZ1PL1qVCCkQJjGCBEwwggRIAgEBMIGGMHIxCzAJBgNVBAYTAlVTMRUw
# EwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20x
# MTAvBgNVBAMTKERpZ2lDZXJ0IFNIQTIgQXNzdXJlZCBJRCBDb2RlIFNpZ25pbmcg
# Q0ECEAkaxwveGrCB9lu5bv4tXiEwDQYJYIZIAWUDBAIBBQCggYQwGAYKKwYBBAGC
# NwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgeDlioT2f
# GHcGNTfuRsD0IKaxlXd1hWdfaxBVWx50HuMwDQYJKoZIhvcNAQEBBQAEggEAUPAK
# q7M3j9NMUPZulEA4Xw5ihJ034qItL2ZaAwGQ6ITLEXwqQp4o9sI5RJ4or9zCwKuI
# CSz9OUPEnYj2hIVVJY7Qd4+4J4u5thFJzWqj4nDJV/IVSpR7j+QWc+M4774mNQv3
# kjTaHWaI4ZGSN7QGXSqJiagS8cnq7s8puJu0eS2tvCjHPbAZ01pgMWckCqXpnKhw
# +cuSLQ69CFhAp9xL5oOWva0qrW/aL829MGfrmt3HtIOonLIip+p7E1pG/3L8N8oq
# sWG9LmyXR147VVev4pa/pzI+gjEG4yLNaSiC4IeF9uuyJ+DI7d0fVeJVQUROkzx1
# ertJoAoGC4g9/s2ATaGCAg8wggILBgkqhkiG9w0BCQYxggH8MIIB+AIBATB2MGIx
# CzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3
# dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IEFzc3VyZWQgSUQgQ0Et
# MQIQAwGaAjr/WLFr1tXq5hfwZjAJBgUrDgMCGgUAoF0wGAYJKoZIhvcNAQkDMQsG
# CSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMjEyMjExOTQzWjAjBgkqhkiG
# 9w0BCQQxFgQUHWtK+HMhOICqm+NK2ov+B+/Ica8wDQYJKoZIhvcNAQEBBQAEggEA
# lkoWbQS5N7Oi6fFD39t6V/wGuLkTj1a6MK4lLTcGu4KUTQeSGQpkWn8oeL2JdvgX
# 23jgLe9D7kn6W7GP5xgYgwFF3LN+8sgt5mzjOYBkGoUkGzwRSJcHsxIaT5P8B8pC
# ttYX/gD86GOT5OxT+DybiY6g6ejYy+a7qoAlawm9Vmth/Nx4MC85FFxgOFs6YJXy
# IShe2CmmIZxUmlgWRoxpx19wCOgY0O34CgnkNVSuVPDJMjdmxdlr3rhHDwwyp7C4
# n0DTzclyQs/g3DqnMGyj1/fgnHk+p4kqpJAHaWFom/V1vxK4KgWl7fT0OibEQBoQ
# q6k346yfNir+/qcW3OacgA==
# SIG # End signature block
