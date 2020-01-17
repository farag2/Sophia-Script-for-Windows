# Allow an app through Controlled folder access
# Разрешить работу приложения через контролируемый доступ к папкам
IF ((Get-MpPreference).EnableControlledFolderAccess -eq 1)
{
	IF ($RU)
	{
		Write-Host "`nВведите путь до приложения, чтобы добавить в список разрешенных приложений."
		Write-Host "Пути должны быть разделены запятыми и взяты в кавычки." -ForegroundColor Yellow
		Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
	}
	else
	{
		Write-Host "`nType app path to add to an allowed app list."
		Write-Host "The paths must be separated by commas and taken in quotes." -ForegroundColor Yellow
		Write-Host "`nPress Enter to skip" -NoNewline
	}
	function ControlledFolderAllowedApplications
	{
		[CmdletBinding()]
		Param
		(
			[Parameter(Mandatory = $True)]
			[string[]]$paths
		)
		$paths = $paths.Replace("`"", "").Split(",").Trim()
		Add-MpPreference -ControlledFolderAccessAllowedApplications $paths
	}
	Do
	{
		$paths = Read-Host -Prompt " "
		IF ($paths -match "`"")
		{
			ControlledFolderAllowedApplications $paths
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
}