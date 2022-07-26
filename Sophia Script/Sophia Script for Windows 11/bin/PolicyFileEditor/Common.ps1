#requires -Version 2.0

$script:MachineExtensionGuids = '[{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{D02B1F72-3407-48AE-BA88-E8213C6761F1}]'
$script:UserExtensionGuids    = '[{35378EAC-683F-11D2-A89A-00C04FBBCFA2}{D02B1F73-3407-48AE-BA88-E8213C6761F1}]'

function OpenPolicyFile
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Path
    )

    $policyFile = New-Object TJX.PolFileEditor.PolFile
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
            $exception = New-Object System.Exception($message)

            $errorRecord = New-Object System.Management.Automation.ErrorRecord(
                $exception, 'InvalidPolFileContents', [System.Management.Automation.ErrorCategory]::InvalidData, $Path
            )

            throw $errorRecord
        }
        catch
        {
            $errorRecord = $_
            $message = "Error loading policy file at path '$Path': $($errorRecord.Exception.Message)"
            $exception = New-Object System.Exception($message, $errorRecord.Exception)

            $newErrorRecord = New-Object System.Management.Automation.ErrorRecord(
                $exception, 'FailedToOpenPolicyFile', [System.Management.Automation.ErrorCategory]::OperationStopped, $Path
            )

            throw $newErrorRecord
        }
    }

    return $policyFile
}

function PolEntryToPsObject
{
    param (
        [TJX.PolFileEditor.PolEntry] $PolEntry
    )

    $type = PolEntryTypeToRegistryValueKind $PolEntry.Type
    $data = GetEntryData -Entry $PolEntry -Type $type

    return New-Object psobject -Property @{
        Key       = $PolEntry.KeyName
        ValueName = $PolEntry.ValueName
        Type      = $type
        Data      = $data
    }
}

function GetEntryData
{
    param (
        [TJX.PolFileEditor.PolEntry] $Entry,
        [Microsoft.Win32.RegistryValueKind] $Type
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
    param (
        [Parameter(Mandatory = $true)]
        [TJX.PolFileEditor.PolFile] $PolicyFile,

        [switch] $UpdateGptIni
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
                $exception = New-Object System.Exception($message, $errorRecord.Exception)

                $newErrorRecord = New-Object System.Management.Automation.ErrorRecord(
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
            $exception = New-Object System.Exception($message, $errorRecord.Exception)

            $newErrorRecord = New-Object System.Management.Automation.ErrorRecord(
                $exception, 'FailedToSavePolicyFile', [System.Management.Automation.ErrorCategory]::OperationStopped, $PolicyFile
            )

            throw $newErrorRecord
        }
    }

    if ($UpdateGptIni)
    {
        if ($policyFile.FileName -match '^(.*)\\+([^\\]+)\\+[^\\]+$' -and
            $Matches[2] -eq 'User' -or $Matches[2] -eq 'Machine')
        {
            $iniPath = Join-Path $Matches[1] GPT.ini

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
        foreach ($line in Get-Content $Path)
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
            elseif ($section -eq 'General' -and
                    $line -match '^\s*Version\s*=\s*(\d+)\s*$' -and
                    $null -ne ($version = $matches[1] -as [uint32]))
            {
                $foundVersionLine = $true
                $newVersion = GetNewVersionNumber -Version $version -PolicyType $PolicyType
                $line = "Version=$newVersion"
            }
            elseif ($section -eq 'General' -and $line -match '^\s*gPC(Machine|User)ExtensionNames\s*=')
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
    # each pair of GUIDs wrapped in square brackets.  Example:

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

    return New-Object psobject -Property @{
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
                return Join-Path $env:SystemRoot System32\GroupPolicy\Machine\registry.pol
            }

            'User'
            {
                return Join-Path $env:SystemRoot System32\GroupPolicy\User\registry.pol
            }

            'Administrators'
            {
                # BUILTIN\Administrators well-known SID
                return Join-Path $env:SystemRoot System32\GroupPolicyUsers\S-1-5-32-544\User\registry.pol
            }

            'NonAdministrators'
            {
                # BUILTIN\Users well-known SID
                return Join-Path $env:SystemRoot System32\GroupPolicyUsers\S-1-5-32-545\User\registry.pol
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

            return Join-Path $env:SystemRoot "System32\GroupPolicyUsers\$($sid.Value)\User\registry.pol"
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
        $exception = New-Object System.Exception($message, $_.Exception)
        $errorRecord = New-Object System.Management.Automation.ErrorRecord(
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
    param (
        [object] $First,
        [object] $Second,
        [Microsoft.Win32.RegistryValueKind] $Type
    )

    if ($Type -eq [Microsoft.Win32.RegistryValueKind]::String -or
        $Type -eq [Microsoft.Win32.RegistryValueKind]::ExpandString -or
        $Type -eq [Microsoft.Win32.RegistryValueKind]::DWord -or
        $Type -eq [Microsoft.Win32.RegistryValueKind]::QWord)
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
    param ([string] $KeyValueName)

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
    param (
        [string] $Path,
        [string] $KeyValueName
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
    param (
        [string] $Path,
        [string] $KeyValueName,
        [string] $Ensure,
        [string[]] $Data,
        [Microsoft.Win32.RegistryValueKind] $Type
    )

    if ($null -eq $Data) { $Data = @() }

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
    param (
        [string] $Path,
        [string] $KeyValueName,
        [string] $Ensure,
        [string[]] $Data,
        [Microsoft.Win32.RegistryValueKind] $Type
    )

    if ($null -eq $Data) { $Data = @() }

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
        if (-not $fileExists) { return $false }
        $entry = Get-PolicyFileEntry -Path $Path -Key $key -ValueName $valueName

        return $null -ne $entry -and $Type -eq $entry.Type -and (DataIsEqual $entry.Data $Data -Type $Type)
    }
    else # Ensure is 'Absent'
    {
        if (-not $fileExists) { return $true }
        $entry = Get-PolicyFileEntry -Path $Path -Key $key -ValueName $valueName

        return $null -eq $entry
    }

}

function Assert-ValidDataAndType
{
    param (
        [string[]] $Data,
        [Microsoft.Win32.RegistryValueKind] $Type
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
    $exception = New-Object System.Exception($Message)
    return New-Object System.Management.Automation.ErrorRecord(
        $exception, 'InvalidDataTypeCombination', [System.Management.Automation.ErrorCategory]::InvalidArgument, $null
    )
}
