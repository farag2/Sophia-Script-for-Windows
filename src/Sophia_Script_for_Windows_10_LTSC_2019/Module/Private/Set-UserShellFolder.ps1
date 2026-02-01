<#
	.SYNOPSIS
	Change the location of the each user folder using SHSetKnownFolderPath function

	.EXAMPLE
	Set-UserShellFolder -UserFolder Desktop -Path "$env:SystemDrive:\Desktop"

	.LINK
	https://learn.microsoft.com/en-us/windows/win32/api/shlobj_core/nf-shlobj_core-shgetknownfolderpath

	.NOTES
	User files or folders won't be moved to a new location
#>
function Global:Set-UserShellFolder
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateSet("Desktop", "Documents", "Downloads", "Music", "Pictures", "Videos")]
		[string]
		$UserFolder,

		[Parameter(Mandatory = $true)]
		[string]
		$Path
	)

	# Get current user folder path
	$CurrentUserFolderPath = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name $UserFolderRegistry[$UserFolder]
	if ($CurrentUserFolder -ne $Path)
	{
		if (-not (Test-Path -Path $Path))
		{
			New-Item -Path $Path -ItemType Directory -Force
		}

		Remove-Item -Path "$CurrentUserFolderPath\desktop.ini" -Force -ErrorAction Ignore

		# Redirect user folder to a new location
		Set-KnownFolderPath -KnownFolder $UserFolder -Path $Path
		New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name $UserFolderGUIDs[$UserFolder] -PropertyType ExpandString -Value $Path -Force

		# Save desktop.ini in the UTF-16 LE encoding
		Set-Content -Path "$Path\desktop.ini" -Value $DesktopINI[$UserFolder] -Encoding Unicode -Force
		(Get-Item -Path "$Path\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
		(Get-Item -Path "$Path\desktop.ini" -Force).Refresh()

		# Warn user is some files left in an old folder
		if ((Get-ChildItem -Path $CurrentUserFolderPath -ErrorAction Ignore | Measure-Object).Count -ne 0)
		{
			Write-Warning -Message ($Localization.UserShellFolderNotEmpty -f $CurrentUserFolderPath)
			Write-Error -Message ($Localization.UserShellFolderNotEmpty -f $CurrentUserFolderPath) -ErrorAction SilentlyContinue
			Write-Information -MessageData "" -InformationAction Continue
		}
	}
}
