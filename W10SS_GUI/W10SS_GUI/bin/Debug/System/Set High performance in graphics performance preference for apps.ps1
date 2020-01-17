# Set "High performance" in graphics performance preference for apps
# Установить параметры производительности графики для отдельных приложений на "Высокая производительность"
IF ((Get-CimInstance -ClassName Win32_ComputerSystem).PCSystemType -ne 2 -and (Get-CimInstance -ClassName Win32_VideoController | Where-Object -FilterScript {$_.AdapterDACType -ne "Internal" -and $null -ne $_.AdapterDACType}))
{
	IF ($RU)
	{
		Write-Host "`nВведите полные пути до .exe файлов, " -NoNewline
		Write-Host "для которого следует установить"
		Write-Host "параметры производительности графики на `"Высокая производительность`"."
		Write-Host "Пути должны быть разделены запятыми и взяты в кавычки." -ForegroundColor Yellow
		Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
	}
	else
	{
		Write-Host "`nType the full paths to .exe files for which to set"
		Write-Host "graphics performance preference to `"High performance GPU`"."
		Write-Host "The paths must be separated by commas and taken in quotes." -ForegroundColor Yellow
		Write-Host "`nPress Enter to skip" -NoNewline
	}
	IF (Test-Path -Path "${env:ProgramFiles(x86)}\Steam")
	{
		Start-Process -FilePath "${env:ProgramFiles(x86)}\Steam\steamapps\common"
	}
	function GpuPreference
	{
		[CmdletBinding()]
		Param
		(
			[Parameter(Mandatory = $True)]
			[string[]]$apps
		)
		$apps = $apps.Replace("`"", "").Split(",").Trim()
		foreach ($app in $apps)
		{
			New-ItemProperty -Path HKCU:\Software\Microsoft\DirectX\UserGpuPreferences -Name $app -PropertyType String -Value "GpuPreference=2;" -Force
		}
	}
	Do
	{
		$apps = Read-Host -Prompt " "
		IF ($apps -match ".exe" -and $apps -match "`"")
		{
			GpuPreference $apps
		}
		elseif ([string]::IsNullOrEmpty($apps))
		{
			break
		}
		else
		{
			IF ($RU)
			{
				Write-Host "`nПути не взяты в кавычки или не содержат ссылки на .exe файлы." -ForegroundColor Yellow
				Write-Host "Введите полные пути до .exe файлов, взяв в кавычки и разделив запятыми."
				Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
			}
			else
			{
				Write-Host "`nThe paths hasn't been taken in quotes or do not contain links to .exe files" -ForegroundColor Yellow
				Write-Host "Type the full paths to .exe files by quoting and separating by commas."
				Write-Host "`nPress Enter to skip" -NoNewline
			}
		}
	}
	Until ($apps -match ".exe" -and $apps -match "`"")
}