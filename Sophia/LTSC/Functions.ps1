<#
	.SYNOPSIS
	Run the specific function, using the TAB completion

	Version: v5.2.1
	Date: 12.04.2021

	Copyright (c) 2014–2021 farag
	Copyright (c) 2019–2021 farag & oZ-Zo

	Thanks to all https://forum.ru-board.com members involved

	.DESCRIPTION
	To be able to call the specific function(s) enter ". .\Function.ps1" first (with a dot at the beginning)
	Running this script will add the TAB completion for functions and their arguments by typing its' first letters

	Чтобы иметь возможность вызывать конкретную функцию, введите сначала ". .\Functions.ps1" (с точкой в начале)
	Запуск этого скрипта добавит, используя табуляцию, автопродление имен функций и их аргументов по введенным первым буквам

	.EXAMPLE Run the specific function(s)
	. .\Functions.ps1
	Sophia -Functions <tab>
	Sophia -Functions temp<tab>
	Sophia -Functions "DiagTrackService -Disable", "DiagnosticDataLevel -Minimal", UninstallUWPApps

	.NOTES
	Set execution policy to be able to run scripts only in the current PowerShell session:
		Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force

	.NOTES
	Separate functions with comma

	.NOTES
	https://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15
	https://habr.com/post/521202/
	https://forums.mydigitallife.net/threads/powershell-windows-10-sophia-script.81675/
	https://www.reddit.com/r/PowerShell/comments/go2n5v/powershell_script_setup_windows_10/

	.LINK
	https://t.me/sophianews
	https://t.me/sophia_chat

	.LINK
	https://github.com/farag2
	https://github.com/Inestic

	.LINK
	https://github.com/farag2/Windows-10-Sophia-Script
#>
function Sophia
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $false)]
		[string[]]
		$Functions
	)

	<#
		Regardless of the functions entered as an argument, the "Checkings" function will be executed first,
		and the "Refresh" and "Errors" functions will be executed at the end
	#>
	Invoke-Command -ScriptBlock {Checkings}

	foreach ($Function in $Functions)
	{
		Invoke-Expression -Command $Function
	}

	Invoke-Command -ScriptBlock {Refresh; Errors}
}

Clear-Host

$Host.UI.RawUI.WindowTitle = "Windows 10 Sophia Script v5.10.1 | Made with $([char]::ConvertFromUtf32(0x1F497)) of Windows 10 | $([char]0x00A9) farag & oz-zo, 2015–2021"

Remove-Module -Name Sophia -Force -ErrorAction Ignore
Import-Module -Name $PSScriptRoot\Sophia.psd1 -PassThru -Force

Import-LocalizedData -BindingVariable Global:Localization -FileName Sophia

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

			# If module command is PinToStart
			if ($Command -eq "PinToStart")
			{
				# Get all command arguments, excluding defaults
				foreach ($ParameterSet in $ParameterSets.Name)
				{
					# If Argument is PinToStart
					if ($ParameterSet -eq "Tiles")
					{
						$ValidValues =  ((Get-Command -Name PinToStart).Parametersets.Parameters | Where-Object -FilterScript {$null -eq $_.Attributes.AliasNames}).Attributes.ValidValues
						foreach ($ValidValue in $ValidValues)
						{
							# "PinToStart -Tites ControlPanel" construction
							# "PinToStart -Tites DevicesPrinters" construction
							# "PinToStart -Tites PowerShell" construction
							"PinToStart" + " " + "-" + $ParameterSet + " " + $ValidValue | Where-Object -FilterScript {$_ -like "*$wordToComplete*"} | ForEach-Object -Process {"`"$_`""}
						}

						# "PinToStart -Tites ControlPanel, DevicesPrinters, PowerShell" construction
						"PinToStart" + " " + "-" + $ParameterSet + " " + ($ValidValues -join ", ") | Where-Object -FilterScript {$_ -like "*$wordToComplete*"} | ForEach-Object -Process {"`"$_`""}
					}

					continue
				}
			}

			# If module command is UninstallUWPApps
			if ($Command -eq "UninstallUWPApps")
			{
				(Get-Command -Name $Command).Name | Where-Object -FilterScript {$_ -like "*$wordToComplete*"}

				# Get all command arguments, excluding defaults
				foreach ($ParameterSet in $ParameterSets.Name)
				{
					# If Argument is ForAllUsers
					if ($ParameterSet -eq "ForAllUsers")
					{
						# "UninstallUWPApps -ForAllUsers" construction
						"UninstallUWPApps" + " " + "-" + $ParameterSet | Where-Object -FilterScript {$_ -like "*$wordToComplete*"} | ForEach-Object -Process {"`"$_`""}
					}

					continue
				}
			}

			foreach ($ParameterSet in $ParameterSets.Name)
			{
				# "Function -Argument" construction
				$Command + " " + "-" + $ParameterSet | Where-Object -FilterScript {$_ -like "*$wordToComplete*"} | ForEach-Object -Process {"`"$_`""}
			}

			# Get functions list without arguments to complete
			Get-Command -Name $Command | Where-Object -FilterScript {$null -eq $_.Parametersets.Parameters} | Where-Object -FilterScript {$_.Name -like "*$wordToComplete*"}
		}
	}
}
Register-ArgumentCompleter @Parameters

Write-Information -MessageData "`n" -InformationAction Continue
Write-Verbose -Message "Sophia -Functions <tab>" -Verbose
Write-Verbose -Message "Sophia -Functions temp<tab>" -Verbose
Write-Verbose -Message "Sophia -Functions `"DiagTrackService -Disable`", `"DiagnosticDataLevel -Minimal`", UninstallUWPApps" -Verbose
Write-Information -MessageData "`n" -InformationAction Continue
Write-Verbose -Message "UninstallUWPApps, `"PinToStart -UnpinAll`"" -Verbose
