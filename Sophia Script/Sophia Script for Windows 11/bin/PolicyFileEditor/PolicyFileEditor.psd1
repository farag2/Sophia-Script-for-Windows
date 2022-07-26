@{
    ModuleToProcess         = 'PolicyFileEditor.psm1'
    ModuleVersion           = '3.0.1'
    GUID                    = '110a2398-3053-4ffc-89d1-1b6a38a2dc86'
    Author                  = 'Dave Wyatt'
    CompanyName             = 'Home'
    Copyright               = '(c) 2015 Dave Wyatt. All rights reserved.'
    Description             = 'Commands and DSC resource for modifying Administrative Templates settings in local GPO registry.pol files.'
    PowerShellVersion       = '2.0'
    # PowerShellHostName    = ''
    # PowerShellHostVersion = ''
    DotNetFrameworkVersion  = '2.0'
    # CLRVersion            = ''
    # ProcessorArchitecture = ''
    # RequiredModules       = @()
    # RequiredAssemblies    = @()
    # ScriptsToProcess      = @()
    # TypesToProcess        = @()
    # FormatsToProcess      = @()
    # NestedModules         = @()
    FunctionsToExport       = @('Set-PolicyFileEntry', 'Remove-PolicyFileEntry', 'Get-PolicyFileEntry', 'Update-GptIniVersion')
    # CmdletsToExport       = '*'
    # VariablesToExport     = '*'
    # AliasesToExport       = '*'
    # DscResourcesToExport  = @()
    # ModuleList            = @()
    # FileList              = @()

    # HelpInfoURI           = ''

    # DefaultCommandPrefix  = ''

    PrivateData = @{
        PSData = @{
            # Tags         = @()
            LicenseUri   = 'https://www.apache.org/licenses/LICENSE-2.0.html'
            ProjectUri   = 'https://github.com/dlwyatt/PolicyFileEditor'
            # IconUri      = ''
            ReleaseNotes = 'Updated resource schemas to be more friendly with Invoke-DscResource.'
        }
    }
}

