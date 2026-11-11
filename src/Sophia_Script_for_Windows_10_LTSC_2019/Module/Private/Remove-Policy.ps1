<#
	.SYNOPSIS
	Remove a policy from the local Group Policy object to make it not configured in the Local Group Policy Editor snap-in (gpedit.msc)

	.PARAMETER Scope
	Computer or User

	.PARAMETER Path
	Registry key path

	.PARAMETER Name
	Registry value name

	.EXAMPLE
	Remove-Policy -Scope Computer -Path SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop -Name NoComponents

	.NOTES
	Policies are read from Registry.pol once, changed in memory, and written back in PostActions

	.NOTES
	https://learn.microsoft.com/previous-versions/windows/desktop/policy/registry-policy-file-format

	.VERSION
	8.1.0

	.DATE
	31.10.2026

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

	# Read all current policies once
	if ($null -eq $Global:RegistryPolicies)
	{
		try
		{
			$Global:RegistryPolicies = @{
				Computer = [WinAPI.RegistryPolicy]::Read("$env:SystemRoot\System32\GroupPolicy\Machine\Registry.pol")
				User     = [WinAPI.RegistryPolicy]::Read("$env:SystemRoot\System32\GroupPolicy\User\Registry.pol")
			}
		}
		catch
		{
			# Registry.pol cannot be read, so it is kept as is. An empty table means that there is nothing to change and to write back
			$Global:RegistryPolicies = @{}

			Write-Information -MessageData "" -InformationAction Continue
			Write-Warning -Message ($Localization.WindowsComponentStabilityDisrupted -f "Registry.pol")
			Write-Error -Message $_.Exception.Message -ErrorAction SilentlyContinue
		}
	}

	if ($Global:RegistryPolicies.Count -eq 0)
	{
		return
	}

	[WinAPI.RegistryPolicy]::Remove($Global:RegistryPolicies[$Scope], $Path, $Name)
}
