<#
	.SYNOPSIS
	Run the specific function, using the TAB completion

	Version: v5.10
	Date: 09.04.2021
	Copyright (c) 2015–2021 farag & oZ-Zo

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

$Host.UI.RawUI.WindowTitle = "Windows 10 Sophia Script v5.10 | Made with $([char]::ConvertFromUtf32(0x1F497)) of Windows 10 | $([char]0x00A9) farag & oz-zo, 2015–2021"

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
			$UnnecessaryParameters = @("Verbose", "Debug", "ErrorAction", "WarningAction", "InformationAction", "ErrorVariable", "WarningVariable", "InformationVariable", "OutVariable", "OutBuffer", "PipelineVariable")
			$ParameterSets = ((Get-Command -Name $Command).Parameters | Where-Object -FilterScript {$_.Keys}).Keys | Where-Object -FilterScript {$_ -notin $UnnecessaryParameters}
			foreach ($ParameterSet in $ParameterSets)
			{
				# "Function -Argument" construction
				$Command + " " + "-" + $ParameterSet | Where-Object -FilterScript {$_ -match $wordToComplete} | ForEach-Object -Process {"`"$_`""}
			}

			continue
		}

		# Get functions list without arguments to complete
		(Get-Command -Name @((Get-Module -Name Sophia).ExportedCommands.Keys)) | Where-Object -FilterScript {
			$_.CmdletBinding -eq $false
		} | Where-Object -FilterScript {$_.Name -match $wordToComplete}
	}
}
Register-ArgumentCompleter @Parameters

Write-Verbose -Message "Sophia -Functions <tab>" -Verbose
Write-Verbose -Message "Sophia -Functions temp<tab>" -Verbose
Write-Verbose -Message "Sophia -Functions `"DiagTrackService -Disable`", `"DiagnosticDataLevel -Minimal`", UninstallUWPApps" -Verbose
