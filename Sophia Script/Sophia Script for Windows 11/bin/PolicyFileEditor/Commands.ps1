#requires -Version 2.0

$scriptRoot = Split-Path $MyInvocation.MyCommand.Path
. "$scriptRoot\Common.ps1"

<#
.SYNOPSIS
   Creates or modifies a value in a .pol file.
.DESCRIPTION
   Creates or modifies a value in a .pol file.  By default, also updates the version number in the policy's gpt.ini file.
.PARAMETER Path
   Path to the .pol file that is to be modified.
.PARAMETER Key
   The registry key inside the .pol file that you want to modify.
.PARAMETER ValueName
   The name of the registry value.  May be set to an empty string to modify the default value of a key.
.PARAMETER Data
   The new value to assign to the registry key / value.  Cannot be $null, but can be set to an empty string or empty array.
.PARAMETER Type
   The type of registry value to set in the policy file.  Cannot be set to Unknown or None, but all other values of the RegistryValueKind enum are legal.
.PARAMETER NoGptIniUpdate
   When this switch is used, the command will not attempt to update the version number in the gpt.ini file
.EXAMPLE
   Set-PolicyFileEntry -Path $env:systemroot\system32\GroupPolicy\Machine\registry.pol -Key Software\Policies\Something -ValueName SomeValue -Data 'Hello, World!' -Type String

   Assigns a value of 'Hello, World!' to the String value Software\Policies\Something\SomeValue in the local computer Machine GPO.  Updates the Machine version counter in $env:systemroot\system32\GroupPolicy\gpt.ini
.EXAMPLE
   Set-PolicyFileEntry -Path $env:systemroot\system32\GroupPolicy\Machine\registry.pol -Key Software\Policies\Something -ValueName SomeValue -Data 'Hello, World!' -Type String -NoGptIniUpdate

   Same as example 1, except this one does not update gpt.ini right away.  This can be useful if you want to set multiple
   values in the policy file and only trigger a single Group Policy refresh.
.EXAMPLE
   Set-PolicyFileEntry -Path $env:systemroot\system32\GroupPolicy\Machine\registry.pol -Key Software\Policies\Something -ValueName SomeValue -Data '0x12345' -Type DWord

   Example demonstrating that strings with valid numeric data (including hexadecimal strings beginning with 0x) can be assigned to the numeric types DWord, QWord and Binary.
.EXAMPLE
   $entries = @(
       New-Object psobject -Property @{ ValueName = 'MaxXResolution'; Data = 1680 }
       New-Object psobject -Property @{ ValueName = 'MaxYResolution'; Data = 1050 }
   )

   $entries | Set-PolicyFileEntry -Path $env:SystemRoot\system32\GroupPolicy\Machine\registry.pol `
                                  -Key  'SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services' `
                                  -Type DWord

   Example of using pipeline input to set multiple values at once.  The advantage to this approach is that the
   .pol file on disk (and the GPT.ini file) will be updated if _any_ of the specified settings had to be modified,
   and will be left alone if the file already contained all of the correct values.

   The Key and Type properties could have also been specified via the pipeline objects instead of on the command line,
   but since both values shared the same Key and Type, this example shows that you can pass the values in either way.
.INPUTS
   The Key, ValueName, Data, and Type properties may be bound via the pipeline by property name.
.OUTPUTS
   None.  This command does not generate output.
.NOTES
   If the specified policy file already contains the correct value, the file will not be modified, and the gpt.ini file will not be updated.
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
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [string] $Key,

        [Parameter(Mandatory = $true, Position = 2, ValueFromPipelineByPropertyName = $true)]
        [AllowEmptyString()]
        [string] $ValueName,

        [Parameter(Mandatory = $true, Position = 3, ValueFromPipelineByPropertyName = $true)]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [object] $Data,

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
        [Microsoft.Win32.RegistryValueKind] $Type = [Microsoft.Win32.RegistryValueKind]::String,

        [switch] $NoGptIniUpdate
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

        if ($null -ne $existingEntry -and $Type -eq (PolEntryTypeToRegistryValueKind $existingEntry.Type))
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
   Retrieves the current setting(s) from a .pol file.
.DESCRIPTION
   Retrieves the current setting(s) from a .pol file.
.PARAMETER Path
   Path to the .pol file that is to be read.
.PARAMETER Key
   The registry key inside the .pol file that you want to read.
.PARAMETER ValueName
   The name of the registry value.  May be set to an empty string to read the default value of a key.
.PARAMETER All
   Switch indicating that all entries from the specified .pol file should be output, instead of searching for a specific key / ValueName pair.
.EXAMPLE
   Get-PolicyFileEntry -Path $env:systemroot\system32\GroupPolicy\Machine\registry.pol -Key Software\Policies\Something -ValueName SomeValue

   Reads the value of Software\Policies\Something\SomeValue from the Machine admin templates of the local GPO.
   Either returns an object with the data and type of this registry value (if present), or returns nothing, if not found.
.EXAMPLE
   Get-PolicyFileEntry -Path $env:systemroot\system32\GroupPolicy\Machine\registry.pol -All

   Outputs all of the registry values from the local machine Administrative Templates
.INPUTS
   None.  This command does not accept pipeline input.
.OUTPUTS
   If the specified registry value is found, the function outputs a PSCustomObject with the following properties:
      ValueName:  The same value that was passed to the -ValueName parameter
      Key:        The same value that was passed to the -Key parameter
      Data:       The current value assigned to the specified Key / ValueName in the .pol file.
      Type:       The RegistryValueKind type of the specified Key / ValueName in the .pol file.
   If the specified registry value is not found in the .pol file, the command returns nothing.  No error is produced.
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
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'ByKeyAndValue')]
        [string] $Key,

        [Parameter(Mandatory = $true, Position = 2, ParameterSetName = 'ByKeyAndValue')]
        [string] $ValueName,

        [Parameter(Mandatory = $true, ParameterSetName = 'All')]
        [switch] $All
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
   Removes a value from a .pol file.
.DESCRIPTION
   Removes a value from a .pol file.  By default, also updates the version number in the policy's gpt.ini file.
.PARAMETER Path
   Path to the .pol file that is to be modified.
.PARAMETER Key
   The registry key inside the .pol file from which you want to remove a value.
.PARAMETER ValueName
   The name of the registry value to be removed.  May be set to an empty string to remove the default value of a key.
.PARAMETER NoGptIniUpdate
   When this switch is used, the command will not attempt to update the version number in the gpt.ini file
.EXAMPLE
   Remove-PolicyFileEntry -Path $env:systemroot\system32\GroupPolicy\Machine\registry.pol -Key Software\Policies\Something -ValueName SomeValue

   Removes the value Software\Policies\Something\SomeValue from the local computer Machine GPO, if present.  Updates the Machine version counter in $env:systemroot\system32\GroupPolicy\gpt.ini
.EXAMPLE
   $entries = @(
       New-Object psobject -Property @{ ValueName = 'MaxXResolution'; Data = 1680 }
       New-Object psobject -Property @{ ValueName = 'MaxYResolution'; Data = 1050 }
   )

   $entries | Remove-PolicyFileEntry -Path $env:SystemRoot\system32\GroupPolicy\Machine\registry.pol `
                                     -Key 'SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'

   Example of using pipeline input to remove multiple values at once.  The advantage to this approach is that the
   .pol file on disk (and the GPT.ini file) will be updated if _any_ of the specified settings had to be removed,
   and will be left alone if the file already did not contain any of those values.

   The Key property could have also been specified via the pipeline objects instead of on the command line, but
   since both values shared the same Key, this example shows that you can pass the value in either way.

.INPUTS
   The Key and ValueName properties may be bound via the pipeline by property name.
.OUTPUTS
   None.  This command does not generate output.
.NOTES
   If the specified policy file is already not present in the .pol file, the file will not be modified, and the gpt.ini file will not be updated.
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
        [Parameter(Mandatory = $true, Position = 0)]
        [string] $Path,

        [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [string] $Key,

        [Parameter(Mandatory = $true, Position = 2, ValueFromPipelineByPropertyName = $true)]
        [string] $ValueName,

        [switch] $NoGptIniUpdate
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
   Increments the version counter in a gpt.ini file.
.DESCRIPTION
   Increments the version counter in a gpt.ini file.
.PARAMETER Path
   Path to the gpt.ini file that is to be modified.
.PARAMETER PolicyType
   Can be set to either 'Machine', 'User', or both.  This affects how the value of the Version number in the ini file is changed.
.EXAMPLE
   Update-GptIniVersion -Path $env:SystemRoot\system32\GroupPolicy\gpt.ini -PolicyType Machine

   Increments the Machine version counter of the local GPO.
.EXAMPLE
   Update-GptIniVersion -Path $env:SystemRoot\system32\GroupPolicy\gpt.ini -PolicyType User

   Increments the User version counter of the local GPO.
.EXAMPLE
   Update-GptIniVersion -Path $env:SystemRoot\system32\GroupPolicy\gpt.ini -PolicyType Machine,User

   Increments both the Machine and User version counters of the local GPO.
.INPUTS
   None.  This command does not accept pipeline input.
.OUTPUTS
   None.  This command does not generate output.
.NOTES
   A gpt.ini file contains only a single Version value.  However, this represents two separate counters, for machine and user versions.
   The high 16 bits of the value are the User counter, and the low 16 bits are the Machine counter.  For example (on PowerShell 3.0
   and later), the Version value when the Machine counter is set to 3 and the User counter is set to 5 can be found by evaluating this
   expression: (5 -shl 16) -bor 3 , which will show up as decimal value 327683 in the INI file.
.LINK
   Get-PolicyFileEntry
.LINK
   Set-PolicyFileEntry
.LINK
   Remove-PolicyFileEntry
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
        [string] $Path,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Machine', 'User')]
        [string[]] $PolicyType
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
