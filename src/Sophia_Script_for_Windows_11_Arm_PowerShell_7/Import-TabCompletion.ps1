<#
	.SYNOPSIS
	Enable tab completion to invoke functions if you do not know their names

	.VERSION
	7.3.0

	.DATE
	05.09.2026

	.COPYRIGHT
	(c) 2014—2026 Team Sophia

	.DESCRIPTION
	Dot source the script first: . .\Import-TabCompletion.ps1 (with a dot at the beginning)
	Start typing any characters contained in the function's name or its arguments, and press TAB button

	.EXAMPLE
	Sophia -Functions <tab>
	Sophia -Functions temp<tab>
	Sophia -Functions "DiagTrackService -Disable", "DiagnosticDataLevel -Minimal", Uninstall-UWPApps

	.NOTES
	Use commas to separate functions

	.LINK
	https://github.com/farag2/Sophia-Script-for-Windows
#>

#Requires -RunAsAdministrator
#Requires -Version 7.6

# Import localizations before dot-sourcing private functions: WinAPI.ps1 needs them to display warnings
try
{
	Import-LocalizedData -BindingVariable Global:Localization -UICulture $PSUICulture -BaseDirectory $PSScriptRoot\Module\Localizations -FileName Sophia -ErrorAction Stop
}
catch
{
	# If there's no folder with current localization ID ($PSUICulture), then import en-US localization
	Import-LocalizedData -BindingVariable Global:Localization -UICulture en-US -BaseDirectory $PSScriptRoot\Module\Localizations -FileName Sophia -ErrorAction Ignore
}

# Check whether script wasn't dot-sourced, but called explicitly. Must go before importing the module
if ($MyInvocation.InvocationName -ne ".")
{
	Write-Warning -Message $Localization.DotSourceFunction
	Write-Information -MessageData "" -InformationAction Continue

	Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows?tab=readme-ov-file#how-to-run-the-specific-functions" -Verbose
	Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
	Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

	return
}

$Global:Failed = $false

# Unload and import private functions and module
Get-ChildItem -Path function: | Where-Object -FilterScript {$_.ScriptBlock.File -match "Sophia_Script_for_Windows"} | Remove-Item -Force
Remove-Module -Name SophiaScript -Force -ErrorAction Ignore
Import-Module -Name $PSScriptRoot\Module\Manifest\SophiaScript.psd1 -PassThru -Force
Get-ChildItem -Path $PSScriptRoot\Module\Private | ForEach-Object -Process {. $_.FullName}

# Global variable if WinAPI.ps1 failed to compile the code
if ($Global:Failed)
{
	exit
}

# Run initial checks
InitialActions

# Global variable if checks failed
if ($Global:Failed)
{
	exit
}

function Sophia
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $false)]
		[string[]]
		$Functions
	)

	foreach ($Function in $Functions)
	{
		Invoke-Expression -Command $Function
	}

	# The "PostActions" function will be executed at the end
	PostActions
}

# Build the completion list
$Completions = & {
	# Functions which can be run without arguments, and their construction with the AllUsers argument
	$AllUsersFunctions = @{
		"OneDrive"          = "OneDrive -Install -AllUsers"
		"Uninstall-UWPApps" = "Uninstall-UWPApps -AllUsers"
	}

	# Functions with an argument that accepts a set of values
	$ValidValuesFunctions = @{
		"Install-DotNetRuntimes" = "Runtimes"
	}

	# Only functions defined in the module itself, excluding commands re-exported from nested or imported modules
	$ModuleFunctions = (Get-Module -Name SophiaScript).ExportedCommands.Values | Where-Object -FilterScript {($_.CommandType -eq "Function") -and ($_.ModuleName -eq "SophiaScript")}

	foreach ($Command in $ModuleFunctions)
	{
		# Get function arguments, excluding common parameters (all of them have aliases)
		$Arguments = $Command.ParameterSets.Parameters | Where-Object -FilterScript {$null -eq $_.Attributes.AliasNames}
		# An argument may be presented in several parameter sets
		$ArgumentNames = $Arguments.Name | Select-Object -Unique

		# The "Function" and "Function -AllUsers" constructions
		if ($AllUsersFunctions.ContainsKey($Command.Name))
		{
			$Command.Name

			if ($ArgumentNames -contains "AllUsers")
			{
				'"{0}"' -f $AllUsersFunctions[$Command.Name]
			}
		}

		# The "Function -Argument <value>" and "Function -Argument <values>" constructions
		if ($ValidValuesFunctions.ContainsKey($Command.Name))
		{
			$ArgumentName = $ValidValuesFunctions[$Command.Name]
			$ValidValues = ($Arguments | Where-Object -FilterScript {$_.Name -eq $ArgumentName}).Attributes.ValidValues | Select-Object -Unique

			if ($ValidValues)
			{
				foreach ($ValidValue in $ValidValues)
				{
					'"{0} -{1} {2}"' -f $Command.Name, $ArgumentName, $ValidValue
				}

				'"{0} -{1} {2}"' -f $Command.Name, $ArgumentName, ($ValidValues -join ", ")
			}
		}

		# The "Function -Argument" construction
		foreach ($ArgumentName in $ArgumentNames)
		{
			'"{0} -{1}"' -f $Command.Name, $ArgumentName
		}

		# Functions without arguments
		if (-not $ArgumentNames)
		{
			$Command.Name
		}
	}
} | Select-Object -Unique

$Parameters = @{
	CommandName   = "Sophia"
	ParameterName = "Functions"
	ScriptBlock   = {
		param
		(
			$commandName,
			$parameterName,
			$wordToComplete,
			$commandAst,
			$fakeBoundParameters
		)

		$Completions | Where-Object -FilterScript {$_ -like "*$wordToComplete*"}
	}.GetNewClosure()
}
Register-ArgumentCompleter @Parameters

Write-Verbose -Message "Sophia -Functions <tab>" -Verbose
Write-Verbose -Message "Sophia -Functions temp<tab>" -Verbose
Write-Verbose -Message "Sophia -Functions 'DiagTrackService -Disable', 'DiagnosticDataLevel -Minimal', Uninstall-UWPApps" -Verbose
Write-Information -MessageData "" -InformationAction Continue
Write-Verbose -Message "Sophia -Functions Uninstall-UWPApps, UnpinAllStartTiles" -Verbose
Write-Verbose -Message "Sophia -Functions `"Set-Association -ProgramPath '%ProgramFiles%\Notepad++\notepad++.exe' -Extension .txt -Icon '%ProgramFiles%\Notepad++\notepad++.exe,0'`"" -Verbose
