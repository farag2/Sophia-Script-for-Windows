# Turn on Controlled folder access and add protected folders
# Включить контролируемый доступ к папкам и добавить защищенные папки
IF ($RU)
{
	Write-Host "`nВведите путь до папки, чтобы добавить в список защищенных папок."
	Write-Host "Пути должны быть разделены запятыми и взяты в кавычки." -ForegroundColor Yellow
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nType folder path to add to protected folders list."
	Write-Host "The paths must be separated by commas and taken in quotes." -ForegroundColor Yellow
	Write-Host "`nPress Enter to skip" -NoNewline
}
function ControlledFolderAccess
{
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory = $True)]
		[string[]]$paths
	)
	Set-MpPreference -EnableControlledFolderAccess Enabled
	$paths = $paths.Replace("`"", "").Split(",").Trim()
	Add-MpPreference -ControlledFolderAccessProtectedFolders $paths
}
Do
{
	$paths = Read-Host -Prompt " "
	IF ($paths -match "`"")
	{
		ControlledFolderAccess $paths
	}
	elseif ([string]::IsNullOrEmpty($paths))
	{
		break
	}
	else
	{
		IF ($RU)
		{
			Write-Host "`nПути не взяты в кавычки." -ForegroundColor Yellow
			Write-Host "Введите пути, взяв в кавычки и разделив запятыми."
			Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
		}
		else
		{
			Write-Host "`nThe paths hasn't been taken in quotes." -ForegroundColor Yellow
			Write-Host "Type the paths by quoting and separating by commas."
			Write-Host "`nPress Enter to skip" -NoNewline
		}
	}
}
Until ($paths -match "`"")