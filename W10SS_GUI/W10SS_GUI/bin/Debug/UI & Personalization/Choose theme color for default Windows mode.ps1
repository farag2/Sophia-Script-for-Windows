# Choose theme color for default Windows mode
# Выбрать режим Windows по умолчанию
IF ($RU)
{
	Write-Host "`nВыберите режим Windows по умолчанию, введя букву: "
	Write-Host "[L]ight " -ForegroundColor Yellow -NoNewline
	Write-Host "для светлого режима или " -NoNewline
	Write-Host "[D]ark " -ForegroundColor Yellow -NoNewline
	Write-Host "для тёмного."
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nChoose theme color for default Windows mode by typing"
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
		# Show color only on taskbar
		# Отображать цвет элементов только на панели задач
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name ColorPrevalence -PropertyType DWord -Value 0 -Force
		# Light Theme Color for Default Windows Mode
		# Режим Windows по умолчанию светлый
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -PropertyType DWord -Value 1 -Force
	}
	elseif ($theme -eq "D")
	{
		# Turn on the display of color on Start menu, taskbar, and action center
		# Отображать цвет элементов в меню "Пуск", на панели задач и в центре уведомлений
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name ColorPrevalence -PropertyType DWord -Value 1 -Force
		# Dark Theme Color for Default Windows Mode
		# Режим Windows по умолчанию темный
		New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme -PropertyType DWord -Value 0 -Force
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
Until ($theme -eq "L" -or $theme -eq "D")