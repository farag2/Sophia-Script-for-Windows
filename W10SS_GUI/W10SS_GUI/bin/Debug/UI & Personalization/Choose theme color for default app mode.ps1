# Choose theme color for default app mode
# Выбрать режим приложения по умолчанию
IF ($RU)
{
	Write-Host "`nВыберите режим приложения по умолчанию, введя букву: "
	Write-Host "[L]ight " -ForegroundColor Yellow -NoNewline
	Write-Host "для светлого режима или " -NoNewline
	Write-Host "[D]ark " -ForegroundColor Yellow -NoNewline
	Write-Host "для тёмного."
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nChoose theme color for default app mode by typing"
	Write-Host "[L]ight " -ForegroundColor Yellow -NoNewline
	Write-Host "for the light mode or " -NoNewline
	Write-Host "[D]ark " -ForegroundColor Yellow -NoNewline
	Write-Host "for the dark"
	Write-Host "`nPress Enter to skip" -NoNewline
}
Do
{
	$theme = Read-Host -Prompt " "
	IF ($theme -eq "L")
	{
		# Light theme color for default app mode
		# Режим приложений по умолчанию светлый
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -PropertyType DWord -Value 1 -Force
	}
	IF ($theme -eq "D")
	{
		# Dark theme color for default app mode
		# Режим приложений по умолчанию темный
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -PropertyType DWord -Value 0 -Force
	}
	elseif ([string]::IsNullOrEmpty($theme))
	{
		break
	}
	else
	{
		IF ($RU)
		{
			Write-Host "`nНеправильная буква." -ForegroundColor Yellow
			Write-Host "Введите правильную букву: " -NoNewline
			Write-Host "[L]ight " -ForegroundColor Yellow -NoNewline
			Write-Host "для светлого режима или " -NoNewline
			Write-Host "[D]ark " -ForegroundColor Yellow -NoNewline
			Write-Host "для тёмного."
			Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
		}
		else
		{
			Write-Host "`nInvalid letter." -ForegroundColor Yellow
			Write-Host "Type the correct letter: " -NoNewline
			Write-Host "[L]ight " -ForegroundColor Yellow -NoNewline
			Write-Host "for the light mode or " -NoNewline
			Write-Host "[D]ark " -ForegroundColor Yellow -NoNewline
			Write-Host "for the dark."
			Write-Host "`nPress Enter to skip" -NoNewline
		}
	}
}
Until ($theme -eq "L" -or $theme -eq "D"