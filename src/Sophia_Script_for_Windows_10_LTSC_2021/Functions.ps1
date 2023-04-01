<#
	.SYNOPSIS
	The TAB completion for functions and their arguments

	Version: v5.16.4
	Date: 01.04.2023

	Copyright (c) 2014—2023 farag
	Copyright (c) 2019—2023 farag & Inestic

	Thanks to all https://forum.ru-board.com members involved

	.DESCRIPTION
	Dot source the script first: . .\Function.ps1 (with a dot at the beginning)
	Start typing any characters contained in the function's name or its arguments, and press the TAB button

	.EXAMPLE
	Sophia -Functions <tab>
	Sophia -Functions temp<tab>
	Sophia -Functions "DiagTrackService -Disable", "DiagnosticDataLevel -Minimal"

	.NOTES
	Use commas to separate funtions

	.LINK
	https://github.com/farag2/Sophia-Script-for-Windows
#>

#Requires -RunAsAdministrator
#Requires -Version 5.1

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

	# The "PostActions" and "Errors" functions will be executed at the end
	Invoke-Command -ScriptBlock {PostActions; Errors}
}

Clear-Host

$Host.UI.RawUI.WindowTitle = "Sophia Script for Windows 10 LTSC 2021 v5.16.4 | Made with $([char]::ConvertFromUtf32(0x1F497)) of Windows | $([char]0x00A9) farag & Inestic, 2014$([char]0x2013)2023"

Remove-Module -Name Sophia -Force -ErrorAction Ignore
Import-Module -Name $PSScriptRoot\Manifest\Sophia.psd1 -PassThru -Force

Import-LocalizedData -BindingVariable Global:Localization -FileName Sophia -BaseDirectory $PSScriptRoot\Localizations

# The mandatory checks. Please, do not comment out this function
Checks

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

		# Get functions list with arguments to complete
		$Commands = (Get-Module -Name Sophia).ExportedCommands.Keys
		foreach ($Command in $Commands)
		{
			$ParameterSets = (Get-Command -Name $Command).Parametersets.Parameters | Where-Object -FilterScript {$null -eq $_.Attributes.AliasNames}

			# If a module command is PinToStart
			if ($Command -eq "PinToStart")
			{
				# Get all command arguments, excluding defaults
				foreach ($ParameterSet in $ParameterSets.Name)
				{
					# If an argument is Tiles
					if ($ParameterSet -eq "Tiles")
					{
						$ValidValues = ((Get-Command -Name PinToStart).Parametersets.Parameters | Where-Object -FilterScript {$null -eq $_.Attributes.AliasNames}).Attributes.ValidValues
						foreach ($ValidValue in $ValidValues)
						{
							# The "PinToStart -Tiles <function>" construction
							"PinToStart" + " " + "-" + $ParameterSet + " " + $ValidValue | Where-Object -FilterScript {$_ -like "*$wordToComplete*"} | ForEach-Object -Process {"`"$_`""}
						}

						# The "PinToStart -Tiles <functions>" construction
						"PinToStart" + " " + "-" + $ParameterSet + " " + ($ValidValues -join ", ") | Where-Object -FilterScript {$_ -like "*$wordToComplete*"} | ForEach-Object -Process {"`"$_`""}
					}

					continue
				}
			}

			# If a module command is Set-Policy
			if ($Command -eq "Set-Policy")
			{
				continue
			}

			foreach ($ParameterSet in $ParameterSets.Name)
			{
				# The "Function -Argument" construction
				$Command + " " + "-" + $ParameterSet | Where-Object -FilterScript {$_ -like "*$wordToComplete*"} | ForEach-Object -Process {"`"$_`""}

				continue
			}

			# Get functions list without arguments to complete
			Get-Command -Name $Command | Where-Object -FilterScript {$null -eq $_.Parametersets.Parameters} | Where-Object -FilterScript {$_.Name -like "*$wordToComplete*"}

			continue
		}
	}
}
Register-ArgumentCompleter @Parameters

Write-Information -MessageData "" -InformationAction Continue
Write-Verbose -Message "Sophia -Functions <tab>" -Verbose
Write-Verbose -Message "Sophia -Functions temp<tab>" -Verbose
Write-Verbose -Message "Sophia -Functions `"DiagTrackService -Disable`", `"DiagnosticDataLevel -Minimal`"" -Verbose
Write-Information -MessageData "" -InformationAction Continue
Write-Verbose -Message "Sophia -Functions `"`"PinToStart -UnpinAll`" -Verbose"
Write-Verbose -Message "Sophia -Functions `"Set-Association -ProgramPath ```"%ProgramFiles%\Notepad++\notepad++.exe```" -Extension .txt -Icon ```"%ProgramFiles%\Notepad++\notepad++.exe,0```"`"" -Verbose
