<#
	.SYNOPSIS
	Calculate hash for Set-Association function

	.VERSION
	7.1.0

	.DATE
	31.10.2026

	.COPYRIGHT
	(c) 2014—2026 Team Sophia

	.LINK
	https://github.com/farag2/Sophia-Script-for-Windows
#>
function Global:Get-Hash
{
	[CmdletBinding()]
	[OutputType([string])]
	Param
	(
		[Parameter(
			Mandatory = $true,
			Position = 0
		)]
		[string]
		$ProgId,

		[Parameter(
			Mandatory = $true,
			Position = 1
		)]
		[string]
		$Extension,

		# The minute the UserChoice key is written in: [WinAPI.PatentHash]::GetCurrentMinute()
		[Parameter(
			Mandatory = $true,
			Position = 2
		)]
		[long]
		$Minute
	)

	# Get user SID
	$UserSID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value

	return [WinAPI.PatentHash]::Get($Extension, $UserSID, $ProgId, $Minute)
}
