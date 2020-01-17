# Add exclusion folder from Microsoft Defender Antivirus scanning
# Добавить папку в список исключений сканирования Защитника Windows
IF ($RU)
{
	Write-Host "`nВведите полные пути до файлов или папок, которые следует "
	Write-Host "исключить из списка сканирования Microsoft Defender."
	Write-Host "Пути должны быть разделены запятыми и взяты в кавычки." -ForegroundColor Yellow
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nType the full paths to files or folders, which to exclude "
	Write-Host "from Microsoft Defender Antivirus Scan."
	Write-Host "The paths must be separated by commas and taken in quotes." -ForegroundColor Yellow
	Write-Host "`nPress Enter to skip" -NoNewline
}
function ExclusionPath
{
	[CmdletBinding()]
	Param
	(
		[Parameter(Mandatory = $True)]
		[string[]]$paths
	)
	$paths = $paths.Replace("`"", "").Split(",").Trim()
	Add-MpPreference -ExclusionPath $paths -Force
}
Do
{
	$paths = Read-Host -Prompt " "
	IF ($paths -match "`"")
	{
		ExclusionPath $paths
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