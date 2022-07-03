#requires -Version 2.0

$script:MachineExtensionGuids = '[{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{D02B1F72-3407-48AE-BA88-E8213C6761F1}]'
$script:UserExtensionGuids	= '[{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{D02B1F73-3407-48AE-BA88-E8213C6761F1}]'

function OpenPolicyFile
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]
		$Path
	)

	$policyFile = New-Object -TypeName TJX.PolFileEditor.PolFile
	$policyFile.FileName = $PSCmdlet.GetUnresolvedProviderPathFromPSPath($Path)

	if (Test-Path -LiteralPath $policyFile.FileName)
	{
		try
		{
			$policyFile.LoadFile()
		}
		catch [TJX.PolFileEditor.FileFormatException]
		{
			$message = "File '$Path' is not a valid POL file."
			$exception = New-Object -TypeName System.Exception($message)

			$errorRecord = New-Object -TypeName System.Management.Automation.ErrorRecord(
				$exception, 'InvalidPolFileContents', [System.Management.Automation.ErrorCategory]::InvalidData, $Path
			)

			throw $errorRecord
		}
		catch
		{
			$errorRecord = $_
			$message = "Error loading policy file at path '$Path': $($errorRecord.Exception.Message)"
			$exception = New-Object -TypeName System.Exception($message, $errorRecord.Exception)

			$newErrorRecord = New-Object -TypeName System.Management.Automation.ErrorRecord(
				$exception, 'FailedToOpenPolicyFile', [System.Management.Automation.ErrorCategory]::OperationStopped, $Path
			)

			throw $newErrorRecord
		}
	}

	return $policyFile
}

function PolEntryToPsObject
{
	param
	(
		[TJX.PolFileEditor.PolEntry] $PolEntry
	)

	$type = PolEntryTypeToRegistryValueKind $PolEntry.Type
	$data = GetEntryData -Entry $PolEntry -Type $type

	return New-Object -TypeName PSObject -Property @{
		Key       = $PolEntry.KeyName
		ValueName = $PolEntry.ValueName
		Type      = $type
		Data      = $data
	}
}

function GetEntryData
{
	param
	(
		[TJX.PolFileEditor.PolEntry]
		$Entry,

		[Microsoft.Win32.RegistryValueKind]
		$Type
	)

	switch ($type)
	{
		([Microsoft.Win32.RegistryValueKind]::Binary)
		{
			return $Entry.BinaryValue
		}

		([Microsoft.Win32.RegistryValueKind]::DWord)
		{
			return $Entry.DWORDValue
		}

		([Microsoft.Win32.RegistryValueKind]::ExpandString)
		{
			return $Entry.StringValue
		}

		([Microsoft.Win32.RegistryValueKind]::MultiString)
		{
			return $Entry.MultiStringValue
		}

		([Microsoft.Win32.RegistryValueKind]::QWord)
		{
			return $Entry.QWORDValue
		}

		([Microsoft.Win32.RegistryValueKind]::String)
		{
			return $Entry.StringValue
		}
	}

}

function SavePolicyFile
{
	[CmdletBinding(SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true)]
		[TJX.PolFileEditor.PolFile]
		$PolicyFile,

		[switch]
		$UpdateGptIni
	)

	if ($PSCmdlet.ShouldProcess($PolicyFile.FileName, 'Save new settings'))
	{
		$parentPath = Split-Path $PolicyFile.FileName -Parent
		if (-not (Test-Path -LiteralPath $parentPath -PathType Container))
		{
			try
			{
				$null = New-Item -Path $parentPath -ItemType Directory -ErrorAction Stop -Confirm:$false -WhatIf:$false
			}
			catch
			{
				$errorRecord = $_
				$message = "Error creating parent folder of path '$Path': $($errorRecord.Exception.Message)"
				$exception = New-Object -TypeName System.Exception($message, $errorRecord.Exception)

				$newErrorRecord = New-Object -TypeName System.Management.Automation.ErrorRecord(
					$exception, 'CreateParentFolderError', $errorRecord.CategoryInfo.Category, $Path
				)

				throw $newErrorRecord
			}
		}

		try
		{
			$PolicyFile.SaveFile()
		}
		catch
		{
			$errorRecord = $_
			$message = "Error saving policy file to path '$($PolicyFile.FileName)': $($errorRecord.Exception.Message)"
			$exception = New-Object -TypeName System.Exception($message, $errorRecord.Exception)

			$newErrorRecord = New-Object -TypeName System.Management.Automation.ErrorRecord(
				$exception, 'FailedToSavePolicyFile', [System.Management.Automation.ErrorCategory]::OperationStopped, $PolicyFile
			)

			throw $newErrorRecord
		}
	}

	if ($UpdateGptIni)
	{
		if (($policyFile.FileName -match '^(.*)\\+([^\\]+)\\+[^\\]+$') -and (($Matches[2] -eq 'User') -or ($Matches[2] -eq 'Machine')))
		{
			$iniPath = Join-Path -Path $Matches[1] -ChildPath GPT.ini

			if (Test-Path -LiteralPath $iniPath -PathType Leaf)
			{
				if ($PSCmdlet.ShouldProcess($iniPath, 'Increment version number in INI file'))
				{
					IncrementGptIniVersion -Path $iniPath -PolicyType $Matches[2] -Confirm:$false -WhatIf:$false
				}
			}
			else
			{
				if ($PSCmdlet.ShouldProcess($iniPath, 'Create new gpt.ini file'))
				{
					NewGptIni -Path $iniPath -PolicyType $Matches[2]
				}
			}
		}
	}
}

function NewGptIni
{
	param (
		[string] $Path,
		[string[]] $PolicyType
	)

	$parent = Split-Path $Path -Parent

	if (-not (Test-Path $parent -PathType Container))
	{
		$null = New-Item -Path $parent -ItemType Directory -ErrorAction Stop
	}

	$version = GetNewVersionNumber -Version 0 -PolicyType $PolicyType

	Set-Content -Path $Path -Encoding Ascii -Value @"
[General]
gPCMachineExtensionNames=$script:MachineExtensionGuids
Version=$version
gPCUserExtensionNames=$script:UserExtensionGuids
"@
}

function IncrementGptIniVersion
{
	[CmdletBinding(SupportsShouldProcess = $true)]
	param (
		[string] $Path,
		[string[]] $PolicyType
	)

	$foundVersionLine = $false
	$section = ''

	$newContents = @(
		foreach ($line in Get-Content -Path $Path)
		{
			# This might not be the most unreadable regex ever, but it's trying hard to be!
			# It's looking for section lines:  [SectionName]
			if ($line -match '^\s*\[([^\]]+)\]\s*$')
			{
				if ($section -eq 'General')
				{
					if (-not $foundVersionLine)
					{
						$foundVersionLine = $true
						$newVersion = GetNewVersionNumber -Version 0 -PolicyType $PolicyType

						"Version=$newVersion"
					}

					if (-not $foundMachineExtensionLine)
					{
						$foundMachineExtensionLine = $true
						"gPCMachineExtensionNames=$script:MachineExtensionGuids"
					}

					if (-not $foundUserExtensionLine)
					{
						$foundUserExtensionLine = $true
						"gPCUserExtensionNames=$script:UserExtensionGuids"
					}
				}

				$section = $matches[1]
			}
			elseif (($section -eq 'General') -and
					($line -match '^\s*Version\s*=\s*(\d+)\s*$') -and
					($null -ne ($version = $matches[1] -as [uint32])))
			{
				$foundVersionLine = $true
				$newVersion = GetNewVersionNumber -Version $version -PolicyType $PolicyType
				$line = "Version=$newVersion"
			}
			elseif (($section -eq 'General') -and ($line -match '^\s*gPC(Machine|User)ExtensionNames\s*='))
			{
				if ($matches[1] -eq 'Machine')
				{
					$foundMachineExtensionLine = $true
				}
				else
				{
					$foundUserExtensionLine = $true
				}

				$line = EnsureAdminTemplateCseGuidsArePresent $line
			}

			$line
		}

		if ($section -eq 'General')
		{
			if (-not $foundVersionLine)
			{
				$foundVersionLine = $true
				$newVersion = GetNewVersionNumber -Version 0 -PolicyType $PolicyType

				"Version=$newVersion"
			}

			if (-not $foundMachineExtensionLine)
			{
				$foundMachineExtensionLine = $true
				"gPCMachineExtensionNames=$script:MachineExtensionGuids"
			}

			if (-not $foundUserExtensionLine)
			{
				$foundUserExtensionLine = $true
				"gPCUserExtensionNames=$script:MachineExtensionGuids"
			}
		}
	)

	if ($PSCmdlet.ShouldProcess($Path, 'Increment Version number'))
	{
		Set-Content -Path $Path -Value $newContents -Encoding Ascii -Confirm:$false -WhatIf:$false
	}
}

function EnsureAdminTemplateCseGuidsArePresent
{
	param ([string] $Line)

	# These lines contain pairs of GUIDs in "registry" format (with the curly braces), separated by nothing, with
	# each pair of GUIDs wrapped in square brackets. Example:

	# gPCMachineExtensionNames=[{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{D02B1F72-3407-48AE-BA88-E8213C6761F1}]

	# Per Darren Mar-Elia, these GUIDs must be in alphabetical order, or GP processing will have problems.

	if ($Line -notmatch '\s*(gPC(?:Machine|User)ExtensionNames)\s*=\s*(.*)$')
	{
		throw "Malformed gpt.ini line: $Line"
	}

	$valueName = $matches[1]
	$guidStrings = @($matches[2] -split '(?<=\])(?=\[)')

	if ($matches[1] -eq 'gPCMachineExtensionNames')
	{
		$toolExtensionGuid = $script:MachineExtensionGuids
	}
	else
	{
		$toolExtensionGuid = $script:UserExtensionGuids
	}

	$guidList = @(
		$guidStrings
		$toolExtensionGuid
	)

	$newGuidString = ($guidList | Sort-Object -Unique) -join ''

	return "$valueName=$newGuidString"
}

function GetNewVersionNumber
{
	param (
		[UInt32] $Version,
		[string[]] $PolicyType
	)

	# User version is the high 16 bits, Machine version is the low 16 bits.
	# Reference:  http://blogs.technet.com/b/grouppolicy/archive/2007/12/14/understanding-the-gpo-version-number.aspx

	$pair = UInt32ToUInt16Pair -UInt32 $version

	if ($PolicyType -contains 'User')
	{
		$pair.HighPart++
	}

	if ($PolicyType -contains 'Machine')
	{
		$pair.LowPart++
	}

	return UInt16PairToUInt32 -UInt16Pair $pair
}

function UInt32ToUInt16Pair
{
	param ([UInt32] $UInt32)

	# Deliberately avoiding bitwise shift operators here, for PowerShell v2 compatibility.

	$lowPart  = $UInt32 -band 0xFFFF
	$highPart = ($UInt32 - $lowPart) / 0x10000

	return New-Object -TypeName PSObject -Property @{
		LowPart  = [UInt16] $lowPart
		HighPart = [UInt16] $highPart
	}
}

function UInt16PairToUInt32
{
	param ([object] $UInt16Pair)

	# Deliberately avoiding bitwise shift operators here, for PowerShell v2 compatibility.

	return ([UInt32] $UInt16Pair.HighPart) * 0x10000 + $UInt16Pair.LowPart
}

function PolEntryTypeToRegistryValueKind
{
	param ([TJX.PolFileEditor.PolEntryType] $PolEntryType)

	switch ($PolEntryType)
	{
		([TJX.PolFileEditor.PolEntryType]::REG_NONE)
		{
			return [Microsoft.Win32.RegistryValueKind]::None
		}

		([TJX.PolFileEditor.PolEntryType]::REG_DWORD)
		{
			return [Microsoft.Win32.RegistryValueKind]::DWord
		}

		([TJX.PolFileEditor.PolEntryType]::REG_DWORD_BIG_ENDIAN)
		{
			return [Microsoft.Win32.RegistryValueKind]::DWord
		}

		([TJX.PolFileEditor.PolEntryType]::REG_BINARY)
		{
			return [Microsoft.Win32.RegistryValueKind]::Binary
		}

		([TJX.PolFileEditor.PolEntryType]::REG_EXPAND_SZ)
		{
			return [Microsoft.Win32.RegistryValueKind]::ExpandString
		}

		([TJX.PolFileEditor.PolEntryType]::REG_MULTI_SZ)
		{
			return [Microsoft.Win32.RegistryValueKind]::MultiString
		}

		([TJX.PolFileEditor.PolEntryType]::REG_QWORD)
		{
			return [Microsoft.Win32.RegistryValueKind]::QWord
		}

		([TJX.PolFileEditor.PolEntryType]::REG_SZ)
		{
			return [Microsoft.Win32.RegistryValueKind]::String
		}
	}
}

function GetPolFilePath
{
	param (
		[Parameter(Mandatory = $true, ParameterSetName = 'PolicyType')]
		[string] $PolicyType,

		[Parameter(Mandatory = $true, ParameterSetName = 'Account')]
		[string] $Account
	)

	if ($PolicyType)
	{
		switch ($PolicyType)
		{
			'Machine'
			{
				return "$env:SystemRoot\System32\GroupPolicy\Machine\registry.pol"
			}

			'User'
			{
				return "$env:SystemRoot\System32\GroupPolicy\User\registry.pol"
			}

			'Administrators'
			{
				# BUILTIN\Administrators well-known SID
				return "$env:SystemRoot\System32\GroupPolicyUsers\S-1-5-32-544\User\registry.pol"
			}

			'NonAdministrators'
			{
				# BUILTIN\Users well-known SID
				return "$env:SystemRoot\System32\GroupPolicyUsers\S-1-5-32-545\User\registry.pol"
			}
		}
	}
	else
	{
		try
		{
			$sid = $Account -as [System.Security.Principal.SecurityIdentifier]

			if ($null -eq $sid)
			{
				$sid = GetSidForAccount $Account
			}

			return "$env:SystemRoot\System32\GroupPolicyUsers\$($sid.Value)\User\registry.pol"
		}
		catch
		{
			throw
		}
	}
}

function GetSidForAccount($Account)
{
	$acc = $Account
	if ($acc -notlike '*\*') { $acc = "$env:COMPUTERNAME\$acc" }

	try
	{
		$ntAccount = [System.Security.Principal.NTAccount]$acc
		return $ntAccount.Translate([System.Security.Principal.SecurityIdentifier])
	}
	catch
	{
		$message = "Could not translate account '$acc' to a security identifier."
		$exception = New-Object -TypeName System.Exception($message, $_.Exception)
		$errorRecord = New-Object -TypeName System.Management.Automation.ErrorRecord(
			$exception,
			'CouldNotGetSidForAccount',
			[System.Management.Automation.ErrorCategory]::ObjectNotFound,
			$Acc
		)

		throw $errorRecord
	}
}

function DataIsEqual
{
	param
	(
		[object]
		$First,

		[object]
		$Second,

		[Microsoft.Win32.RegistryValueKind]
		$Type
	)

	if
	(
		$Type -eq [Microsoft.Win32.RegistryValueKind]::String -or
		$Type -eq [Microsoft.Win32.RegistryValueKind]::ExpandString -or
		$Type -eq [Microsoft.Win32.RegistryValueKind]::DWord -or
		$Type -eq [Microsoft.Win32.RegistryValueKind]::QWord
	)
	{
		return @($First)[0] -ceq @($Second)[0]
	}

	# If we get here, $Type is either MultiString or Binary, both of which need to compare arrays.
	# The PolicyFileEditor module never returns type Unknown or None.

	$First = @($First)
	$Second = @($Second)

	if ($First.Count -ne $Second.Count) { return $false }

	$count = $First.Count
	for ($i = 0; $i -lt $count; $i++)
	{
		if ($First[$i] -cne $Second[$i]) { return $false }
	}

	return $true
}

function ParseKeyValueName
{
	param
	(
		[string]
		$KeyValueName
	)

	$key = $KeyValueName -replace '^\\+|\\+$'
	$valueName = ''

	if ($KeyValueName -match '^\\*(?<Key>.+?)\\+(?<ValueName>[^\\]*)$')
	{
		$key = $matches['Key'] -replace '\\{2,}', '\'
		$valueName = $matches['ValueName']
	}

	return $key, $valueName
}

function GetTargetResourceCommon
{
	param
	(
		[string]
		$Path,

		[string]
		$KeyValueName
	)

	$configuration = @{
		KeyValueName = $KeyValueName
		Ensure       = 'Absent'
		Data         = $null
		Type         = [Microsoft.Win32.RegistryValueKind]::Unknown
	}

	if (Test-Path -LiteralPath $path -PathType Leaf)
	{
		$key, $valueName = ParseKeyValueName $KeyValueName
		$entry = Get-PolicyFileEntry -Path $Path -Key $key -ValueName $valueName

		if ($entry)
		{
			$configuration['Ensure'] = 'Present'
			$configuration['Type']   = $entry.Type
			$configuration['Data']   = @($entry.Data)
		}
	}

	return $configuration
}

function SetTargetResourceCommon
{
	param
	(
		[string]
		$Path,

		[string]
		$KeyValueName,

		[string]
		$Ensure,

		[string[]]
		$Data,

		[Microsoft.Win32.RegistryValueKind]
		$Type
	)

	if ($null -eq $Data)
	{
		$Data = @()
	}

	try
	{
		Assert-ValidDataAndType -Data $Data -Type $Type
	}
	catch
	{
		Write-Error -ErrorRecord $_
		return
	}

	$key, $valueName = ParseKeyValueName $KeyValueName

	if ($Ensure -eq 'Present')
	{
		Set-PolicyFileEntry -Path $Path -Key $key -ValueName $valueName -Data $Data -Type $Type
	}
	else
	{
		Remove-PolicyFileEntry -Path $Path -Key $key -ValueName $valueName
	}
}

function TestTargetResourceCommon
{
	[OutputType([bool])]
	param
	(
		[string]
		$Path,

		[string]
		$KeyValueName,

		[string]
		$Ensure,

		[string[]]
		$Data,

		[Microsoft.Win32.RegistryValueKind]
		$Type
	)

	if ($null -eq $Data)
	{
		$Data = @()
	}

	try
	{
		Assert-ValidDataAndType -Data $Data -Type $Type
	}
	catch
	{
		Write-Error -ErrorRecord $_
		return $false
	}

	$key, $valueName = ParseKeyValueName $KeyValueName

	$fileExists = Test-Path -LiteralPath $Path -PathType Leaf

	if ($Ensure -eq 'Present')
	{
		if (-not $fileExists)
		{
			return $false
		}
		$entry = Get-PolicyFileEntry -Path $Path -Key $key -ValueName $valueName

		return $null -ne $entry -and $Type -eq $entry.Type -and (DataIsEqual $entry.Data $Data -Type $Type)
	}
	else # Ensure is 'Absent'
	{
		if (-not $fileExists)
		{
			eturn $true 
		}
		$entry = Get-PolicyFileEntry -Path $Path -Key $key -ValueName $valueName

		return $null -eq $entry
	}

}

function Assert-ValidDataAndType
{
	param
	(
		[string[]]
		$Data,

		[Microsoft.Win32.RegistryValueKind]
		$Type
	)

	if ($Type -ne [Microsoft.Win32.RegistryValueKind]::MultiString -and
		$Type -ne [Microsoft.Win32.RegistryValueKind]::Binary -and
		$Data.Count -gt 1)
	{
		$errorRecord = InvalidDataTypeCombinationErrorRecord -Message 'Do not pass arrays with multiple values to the -Data parameter when -Type is not set to either Binary or MultiString.'
		throw $errorRecord
	}
}

function InvalidDataTypeCombinationErrorRecord($Message)
{
	$exception = New-Object -TypeName System.Exception($Message)
	return New-Object -TypeName System.Management.Automation.ErrorRecord(
		$exception, 'InvalidDataTypeCombination', [System.Management.Automation.ErrorCategory]::InvalidArgument, $null
	)
}

# SIG # Begin signature block
# MIIgTAYJKoZIhvcNAQcCoIIgPTCCIDkCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDALFsG1CQYsxut
# FXVEra7CVd9LuoTxSk58x1Un2xajtaCCG1YwggO3MIICn6ADAgECAhAM5+DlF9hG
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
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgGdghbC1R
# ABmMNAHBDBhAMpdee8w/PRz0WGmsnhYzkF4wDQYJKoZIhvcNAQEBBQAEggEAKLUY
# m0fi7udm5yptlHO3u94+XLUnUl/EcsfrUQZOYVz730S4LAkmnpiq6vMkFBilVhcf
# Z+WSUSFVw77a2PAhmW1482LBLOL36HxecMDvCh6HTPKwLPPV1ys6xMxWjnTqLU9Z
# 2nyXTcKlUEvCxBnfu1FkxIQHdfupj9ebYbC5qtiyx3Ii1rTspv8IVU7zEByfEpjp
# cqooJlsCYMsWYQGejayi18wCgzZC3mR7/EvV6p3q8cad5wFj0qDEJn+bPU94O7eE
# wnqXs7fscK+EAC/unQkJuAEvTfaDjGmtvfkyM+64Y1yUyRK6Bvqww7lUcjjSKGUC
# 8DyOS8fc2lZ7S/p/d6GCAg8wggILBgkqhkiG9w0BCQYxggH8MIIB+AIBATB2MGIx
# CzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3
# dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0IEFzc3VyZWQgSUQgQ0Et
# MQIQAwGaAjr/WLFr1tXq5hfwZjAJBgUrDgMCGgUAoF0wGAYJKoZIhvcNAQkDMQsG
# CSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTgwMjEyMjExOTQ0WjAjBgkqhkiG
# 9w0BCQQxFgQUBq3901VMJzFyXla8+r/hzbxFAfYwDQYJKoZIhvcNAQEBBQAEggEA
# fSeo9WEZDwsIhG/gv2D1AbimovEiSbFkPGalCa084r0MsslizkHo1JzuuSnbZNMb
# EiXKcOAJooU/S6iLsMKHKqREkfoY5y6ZSxPXvI6IqbOfeGKOW61nuxORARydkDBF
# DfSZL0oVC6dvFVB2EuK4/N8XYqY+mrwNbWLKfW/4gFsJQtNfC7VT/262WDzt0nSF
# GXNi74KNIUn1rZQ3CGrRmNiJjwgaA2UEFv9o3CeztUSX6fiHxvWw9U5A9ELvTL9E
# NOWROp3uV5SZY8cJiUsh5hBbG2cf6grLplOJ0Yufeu41ebZdkrG9BmIOjgyN2wZ7
# 2h4ILOyUjg5CtmkA38hj4A==
# SIG # End signature block
