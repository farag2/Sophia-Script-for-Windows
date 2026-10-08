<#
	.SYNOPSIS
	Remove policy block from exported policies made via LGPO.exe tool

	.PARAMETER Scope
	Computer or User

	.PARAMETER Path
	Registry key path

	.PARAMETER Name
	Registry key name

	.EXAMPLE
	Remove-Policy -Scope Computer -Path SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop -Name NoComponents

	.NOTES
	https://techcommunity.microsoft.com/t5/microsoft-security-baselines/lgpo-exe-local-group-policy-object-utility-v1-0/ba-p/701045

	.VERSION
	7.3.0

	.DATE
	05.09.2026

	.COPYRIGHT
	(c) 2014—2026 Team Sophia

	.LINK
	https://github.com/farag2/Sophia-Script-for-Windows
#>
function Global:Remove-Policy
{
	[CmdletBinding()]
	param
	(
		[ValidateSet("Computer", "User")]
		[string]
		$Scope,

		[string]
		$Path,

		[string]
		$Name
	)

	if (-not (Test-Path -Path "$env:SystemRoot\System32\gpedit.msc"))
	{
		return
	}

	if (Test-Path -Path "$env:TEMP\LGPO.txt")
	{
		$Content = @(Get-Content -Path "$env:TEMP\LGPO.txt" -Force)
	}
	else
	{
		# Export all current policies
		$Content = @()

		if (Test-Path -Path "$env:SystemRoot\System32\GroupPolicy\Machine\Registry.pol")
		{
			$Content += & "$PSScriptRoot\..\Binaries\LGPO.exe" /parse /m "$env:SystemRoot\System32\GroupPolicy\Machine\Registry.pol"
		}

		if (Test-Path -Path "$env:SystemRoot\System32\GroupPolicy\User\Registry.pol")
		{
			$Content += & "$PSScriptRoot\..\Binaries\LGPO.exe" /parse /u "$env:SystemRoot\System32\GroupPolicy\User\Registry.pol"
		}
	}

	# A block is 4 lines: scope, registry key, value name, and action. Comments and empty lines between blocks carry nothing and are dropped
	# A value name is an empty line for the default value, so lines are not filtered before splitting into blocks
	$Blocks = [System.Collections.Generic.List[string[]]]::new()

	for ($i = 0; ($i + 3) -lt $Content.Count; $i++)
	{
		if ($Content[$i].Trim() -in @("Computer", "User"))
		{
			$Blocks.Add([string[]]@($Content[$i].Trim(), $Content[$i + 1], $Content[$i + 2], $Content[$i + 3]))
			$i += 3
		}
	}

	# Emit the blocks back, an empty line after each, skipping the block asked for
	$Lines = [System.Collections.Generic.List[string]]::new()

	foreach ($Block in $Blocks)
	{
		if (($Block[0] -eq $Scope) -and ($Block[1] -eq $Path) -and ($Block[2] -eq $Name))
		{
			continue
		}

		$Lines.AddRange($Block)
		$Lines.Add("")
	}

	# Save with Unicode encoding
	Set-Content -Path "$env:TEMP\LGPO.txt" -Value $Lines -Encoding "utf-16LE" -Force
}
