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

	# Comments and empty lines carry nothing and are dropped
	$Blocks = @($Content | Where-Object -FilterScript {($_ -ne "") -and (-not $_.StartsWith(";"))})

	# Emit the lines back, an empty one after every 4th, skipping the block asked for
	$Lines = [System.Collections.Generic.List[string]]::new()

	for ($i = 0; $i -lt $Blocks.Count; $i += 4)
	{
		if (($Blocks[$i] -eq $Scope) -and ($Blocks[$i + 1] -eq $Path) -and ($Blocks[$i + 2] -eq $Name))
		{
			continue
		}

		$Lines.AddRange([string[]]$Blocks[$i..($i + 3)])
		$Lines.Add("")
	}

	# Save with UTF-16LE Unicode encoding
	Set-Content -Path "$env:TEMP\LGPO.txt" -Value $Lines -Encoding "Unicode" -Force
}
