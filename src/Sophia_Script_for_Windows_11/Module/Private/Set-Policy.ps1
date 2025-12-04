<#
	.SYNOPSIS
	Create pre-configured text files for LGPO.exe tool

	.EXAMPLE Set AllowTelemetry to 0 for all users in gpedit.msc snap-in
	Set-Policy -Scope Computer -Path SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name AllowTelemetry -Type DWORD -Value 0

	.EXAMPLE Set DisableSearchBoxSuggestions to 0 for current user in gpedit.msc snap-in
	Set-Policy -Scope User -Path Software\Policies\Microsoft\Windows\Explorer -Name DisableSearchBoxSuggestions -Type DWORD -Value 1

	.EXAMPLE Set DisableNotificationCenter value to "Not configured" in gpedit.msc snap-in
	Set-Policy -Scope Computer -Path SOFTWARE\Policies\Microsoft\Windows\Explorer -Name DisableNotificationCenter -Type DELETE

	.NOTES
	https://techcommunity.microsoft.com/t5/microsoft-security-baselines/lgpo-exe-local-group-policy-object-utility-v1-0/ba-p/701045

	.VERSION
	7.0.0

	.DATE
	05.12.2025

	.COPYRIGHT
	(c) 2014—2026 Team Sophia

	.LINK
	https://github.com/farag2/Sophia-Script-for-Windows
#>
function Global:Set-Policy
{
	[CmdletBinding()]
	param
	(
		[Parameter(
			Mandatory = $true,
			Position = 1
		)]
		[string]
		[ValidateSet("Computer", "User")]
		$Scope,

		[Parameter(
			Mandatory = $true,
			Position = 2
		)]
		[string]
		$Path,

		[Parameter(
			Mandatory = $true,
			Position = 3
		)]
		[string]
		$Name,

		[Parameter(
			Mandatory = $true,
			Position = 4
		)]
		[ValidateSet("DWORD", "SZ", "EXSZ", "DELETE")]
		[string]
		$Type,

		[Parameter(
			Mandatory = $false,
			Position = 5
		)]
		$Value
	)

	if (-not (Test-Path -Path "$env:SystemRoot\System32\gpedit.msc"))
	{
		return
	}

	switch ($Type)
	{
		"DELETE"
		{
			$Policy = @"
$Scope
$($Path)
$($Name)
$($Type)`n
"@
		}
		default
		{
			$Policy = @"
$Scope
$($Path)
$($Name)
$($Type):$($Value)`n
"@
		}
	}

	# Save in UTF8 without BOM
	Add-Content -Path "$env:TEMP\LGPO.txt" -Value $Policy -Encoding Default -Force
}
