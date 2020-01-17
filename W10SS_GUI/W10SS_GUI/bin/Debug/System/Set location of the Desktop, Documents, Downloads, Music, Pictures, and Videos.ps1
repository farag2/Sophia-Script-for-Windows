# Set location of the "Desktop", "Documents", "Downloads", "Music", "Pictures", and "Videos"
# Переопределить расположение папок "Рабочий стол", "Документы", "Загрузки", "Музыка", "Изображения", "Видео"
Function KnownFolderPath
{
	Param (
		[Parameter(Mandatory = $true)]
		[ValidateSet("Desktop", "Documents", "Downloads", "Music", "Pictures", "Videos")]
		[string]$KnownFolder,

		[Parameter(Mandatory = $true)]
		[string]$Path
	)
	$KnownFolders = @{
		"Desktop"	= @("B4BFCC3A-DB2C-424C-B029-7FE99A87C641");
		"Documents"	= @("FDD39AD0-238F-46AF-ADB4-6C85480369C7", "f42ee2d3-909f-4907-8871-4c22fc0bf756");
		"Downloads"	= @("374DE290-123F-4565-9164-39C4925E467B", "7d83ee9b-2244-4e70-b1f5-5393042af1e4");
		"Music"		= @("4BD8D571-6D19-48D3-BE97-422220080E43", "a0c69a99-21c8-4671-8703-7934162fcf1d");
		"Pictures"	= @("33E28130-4E1E-4676-835A-98395C3BC3BB", "0ddd015d-b06c-45d5-8c4c-f59713854639");
		"Videos"	= @("18989B1D-99B5-455B-841C-AB7C74E4DDFC", "35286a68-3c57-41a1-bbb1-0eae73d76c95");
	}
	$Signature = @{
		Namespace = "WinAPI"
		Name = "KnownFolders"
		Language = "CSharp"
		MemberDefinition = @"
			[DllImport("shell32.dll")]
			public extern static int SHSetKnownFolderPath(ref Guid folderId, uint flags, IntPtr token, [MarshalAs(UnmanagedType.LPWStr)] string path);
"@
	}
	IF (-not ("WinAPI.KnownFolders" -as [type]))
	{
		Add-Type @Signature
	}
	foreach ($guid in $KnownFolders[$KnownFolder])
	{
		[WinAPI.KnownFolders]::SHSetKnownFolderPath([ref]$guid, 0, 0, $Path)
	}
	(Get-Item -Path $Path -Force).Attributes = "ReadOnly"
}
[hashtable] $DesktopINI = @{
	"Desktop"	=	"",
					"[.ShellClassInfo]",
					"LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21769",
					"IconResource=%SystemRoot%\system32\imageres.dll,-183"
	"Documents"	=	"",
					"[.ShellClassInfo]",
					"LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21770",
					"IconResource=%SystemRoot%\system32\imageres.dll,-112",
					"IconFile=%SystemRoot%\system32\shell32.dll",
					"IconIndex=-235"
	"Downloads"	=	"",
					"[.ShellClassInfo]","LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21798",
					"IconResource=%SystemRoot%\system32\imageres.dll,-184"
	"Music"		=	"",
					"[.ShellClassInfo]","LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21790",
					"InfoTip=@%SystemRoot%\system32\shell32.dll,-12689",
					"IconResource=%SystemRoot%\system32\imageres.dll,-108",
					"IconFile=%SystemRoot%\system32\shell32.dll","IconIndex=-237"
	"Pictures"	=	"",
					"[.ShellClassInfo]",
					"LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21779",
					"InfoTip=@%SystemRoot%\system32\shell32.dll,-12688",
					"IconResource=%SystemRoot%\system32\imageres.dll,-113",
					"IconFile=%SystemRoot%\system32\shell32.dll",
					"IconIndex=-236"
	"Videos"	=	"",
					"[.ShellClassInfo]",
					"LocalizedResourceName=@%SystemRoot%\system32\shell32.dll,-21791",
					"InfoTip=@%SystemRoot%\system32\shell32.dll,-12690",
					"IconResource=%SystemRoot%\system32\imageres.dll,-189",
					"IconFile=%SystemRoot%\system32\shell32.dll","IconIndex=-238"
}
$drives = (Get-Disk | Where-Object -FilterScript {$_.BusType -ne "USB"} | Get-Partition | Get-Volume).DriveLetter
IF ($RU)
{
	$OFS = ", "
	Write-Host "`nВаши диски: " -NoNewline
	Write-Host "$($drives | Sort-Object -Unique)" -ForegroundColor Yellow
	$OFS = " "
}
else
{
	$OFS = ", "
	Write-Host "`nYour drives: " -NoNewline
	Write-Host "$($drives | Sort-Object -Unique)" -ForegroundColor Yellow
	$OFS = " "
}
# Desktop
# Рабочий стол
IF ($RU)
{
	Write-Host "`nВведите букву диска, в корне которого будет создана папка для " -NoNewline
	Write-Host "`"Рабочий стол`"" -ForegroundColor Yellow
	Write-Host "Файлы не будут перенесены: сделайте это вручную"
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nType the drive letter in the root of which the " -NoNewline
	Write-Host "`"Desktop`" " -ForegroundColor Yellow -NoNewline
	Write-Host "folder will be created."
	Write-Host "Files will not be moved. Do it manually"
	Write-Host "`nPress Enter to skip" -NoNewline
}
Do
{
	$drive = Read-Host -Prompt " "
	IF ($drives -eq $drive)
	{
		$drive = $(${drive}.ToUpper())
		$DesktopFolder = "${drive}:\Desktop"
		$DesktopReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Desktop
		IF ($DesktopReg -ne $DesktopFolder)
		{
			IF (-not (Test-Path -Path $DesktopFolder))
			{
				New-Item -Path $DesktopFolder -ItemType Directory -Force
			}
			KnownFolderPath -KnownFolder Desktop -Path $DesktopFolder
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{754AC886-DF64-4CBA-86B5-F7FBF4FBCEF5}" -PropertyType ExpandString -Value $DesktopFolder -Force
			Set-Content -Path "$DesktopFolder\desktop.ini" -Value $DesktopINI["Desktop"] -Encoding Unicode -Force
			(Get-Item -Path "$DesktopFolder\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$DesktopFolder\desktop.ini" -Force).Refresh()
		}
		# Save screenshots by pressing Win+PrtScr to the Desktop
		# Сохранить скриншот по Win+PrtScr на рабочем столе
		New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{b7bede81-df94-4682-a7d8-57a52620b86f}" -Name RelativePath -PropertyType String -Value $DesktopFolder -Force
	}
	elseif ([string]::IsNullOrEmpty($drive))
	{
		break
	}
	else
	{
		IF ($RU)
		{
			Write-Host "`nДиск $(${drive}.ToUpper()): не существует. " -ForegroundColor Yellow -NoNewline
			Write-Host "Введите букву диска."
			Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
		}
		else
		{
			Write-Host "The disk $(${drive}.ToUpper()): does not exist. " -ForegroundColor Yellow -NoNewline
			Write-Host "Type the drive letter."
			Write-Host "`nPress Enter to skip" -NoNewline
		}
	}
}
Until ($drives -eq $drive)
# Documents
# Документы
IF ($RU)
{
	Write-Host "`nВведите букву диска, в корне которого будет создана папка для " -NoNewline
	Write-Host "`"Документы`"" -ForegroundColor Yellow
	Write-Host "Файлы не будут перенесены: сделайте это вручную"
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nType the drive letter in the root of which the " -NoNewline
	Write-Host "`"Documents`" " -ForegroundColor Yellow -NoNewline
	Write-Host "folder will be created."
	Write-Host "Files will not be moved. Do it manually"
	Write-Host "`nPress Enter to skip" -NoNewline
}
Do
{
	$drive = Read-Host -Prompt " "
	IF ($drives -eq $drive)
	{
		$drive = $(${drive}.ToUpper())
		$DocumentsFolder = "${drive}:\Documents"
		$DocumentsReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Personal
		IF ($DocumentsReg -ne $DocumentsFolder)
		{
			IF (-not (Test-Path -Path $DocumentsFolder))
			{
				New-Item -Path $DocumentsFolder -ItemType Directory -Force
			}
			KnownFolderPath -KnownFolder Documents -Path $DocumentsFolder
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{F42EE2D3-909F-4907-8871-4C22FC0BF756}" -PropertyType ExpandString -Value $DocumentsFolder -Force
			Set-Content -Path "$DocumentsFolder\desktop.ini" -Value $DesktopINI["Documents"] -Encoding Unicode -Force
			(Get-Item -Path "$DocumentsFolder\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$DocumentsFolder\desktop.ini" -Force).Refresh()
		}
	}
	elseif ([string]::IsNullOrEmpty($drive))
	{
		break
	}
	else
	{
		IF ($RU)
		{
			Write-Host "`nДиск $(${drive}.ToUpper()): не существует. " -ForegroundColor Yellow -NoNewline
			Write-Host "Введите букву диска."
			Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
		}
		else
		{
			Write-Host "The disk $(${drive}.ToUpper()): does not exist. " -ForegroundColor Yellow -NoNewline
			Write-Host "Type the drive letter."
			Write-Host "`nPress Enter to skip" -NoNewline
		}
	}
}
Until ($drives -eq $drive)
# Downloads
# Загрузки
IF ($RU)
{
	Write-Host "`nВведите букву диска, в корне которого будет создана папка для " -NoNewline
	Write-Host "`"Загрузки`"" -ForegroundColor Yellow
	Write-Host "Файлы не будут перенесены: сделайте это вручную"
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nType the drive letter in the root of which the " -NoNewline
	Write-Host "`"Downloads`" " -ForegroundColor Yellow -NoNewline
	Write-Host "folder will be created."
	Write-Host "Files will not be moved. Do it manually"
	Write-Host "`nPress Enter to skip" -NoNewline
}
Do
{
	$drive = Read-Host -Prompt " "
	IF ($drives -eq $drive)
	{
		$drive = $(${drive}.ToUpper())
		$DownloadsFolder = "${drive}:\Downloads"
		$DownloadsReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
		IF ($DownloadsReg -ne $DownloadsFolder)
		{
			IF (-not (Test-Path -Path $DownloadsFolder))
			{
				New-Item -Path $DownloadsFolder -ItemType Directory -Force
			}
			KnownFolderPath -KnownFolder Downloads -Path $DownloadsFolder
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}" -PropertyType ExpandString -Value $DownloadsFolder -Force
			Set-Content -Path "$DownloadsFolder\desktop.ini" -Value $DesktopINI["Downloads"] -Encoding Unicode -Force
			(Get-Item -Path "$DownloadsFolder\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$DownloadsFolder\desktop.ini" -Force).Refresh()
			# Microsoft Edge downloads folder ###
			# Папка загрузок Microsoft Edge
			$edge = (Get-AppxPackage "Microsoft.MicrosoftEdge").PackageFamilyName
			New-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\Main" -Name "Default Download Directory" -PropertyType String -Value $DownloadsFolder -Force
		}
	}
	elseif ([string]::IsNullOrEmpty($drive))
	{
		break
	}
	else
	{
		IF ($RU)
		{
			Write-Host "`nДиск $(${drive}.ToUpper()): не существует. " -ForegroundColor Yellow -NoNewline
			Write-Host "Введите букву диска."
			Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
		}
		else
		{
			Write-Host "The disk $(${drive}.ToUpper()): does not exist. " -ForegroundColor Yellow -NoNewline
			Write-Host "Type the drive letter."
			Write-Host "`nPress Enter to skip" -NoNewline
		}
	}
}
Until ($drives -eq $drive)
# Music
# Музыка
IF ($RU)
{
	Write-Host "`nВведите букву диска, в корне которого будет создана папка для " -NoNewline
	Write-Host "`"Музыка`"" -ForegroundColor Yellow
	Write-Host "Файлы не будут перенесены: сделайте это вручную"
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nType the drive letter in the root of which the " -NoNewline
	Write-Host "`"Music`" " -ForegroundColor Yellow -NoNewline
	Write-Host "folder will be created."
	Write-Host "Files will not be moved. Do it manually"
	Write-Host "`nPress Enter to skip" -NoNewline
}
Do
{
	$drive = Read-Host -Prompt " "
	IF ($drives -eq $drive)
	{
		$drive = $(${drive}.ToUpper())
		$MusicFolder = "${drive}:\Music"
		$MusicReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Music"
		IF ($MusicReg -ne $MusicFolder)
		{
			IF (-not (Test-Path -Path $MusicFolder))
			{
				New-Item -Path $MusicFolder -ItemType Directory -Force
			}
			KnownFolderPath -KnownFolder Music -Path $MusicFolder
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{A0C69A99-21C8-4671-8703-7934162FCF1D}" -PropertyType ExpandString -Value $MusicFolder -Force
			Set-Content -Path "$MusicFolder\desktop.ini" -Value $DesktopINI["Music"] -Encoding Unicode -Force
			(Get-Item -Path "$MusicFolder\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$MusicFolder\desktop.ini" -Force).Refresh()
		}
	}
	elseif ([string]::IsNullOrEmpty($drive))
	{
		break
	}
	else
	{
		IF ($RU)
		{
			Write-Host "`nДиск $(${drive}.ToUpper()): не существует. " -ForegroundColor Yellow -NoNewline
			Write-Host "Введите букву диска."
			Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
		}
		else
		{
			Write-Host "The disk $(${drive}.ToUpper()): does not exist. " -ForegroundColor Yellow -NoNewline
			Write-Host "Type the drive letter."
			Write-Host "`nPress Enter to skip" -NoNewline
		}
	}
}
Until ($drives -eq $drive)
# Pictures
# Изображения
IF ($RU)
{
	Write-Host "`nВведите букву диска, в корне которого будет создана папка для " -NoNewline
	Write-Host "`"Изображения`"" -ForegroundColor Yellow
	Write-Host "Файлы не будут перенесены: сделайте это вручную"
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nType the drive letter in the root of which the " -NoNewline
	Write-Host "`"Pictures`" " -ForegroundColor Yellow -NoNewline
	Write-Host "folder will be created."
	Write-Host "Files will not be moved. Do it manually"
	Write-Host "`nPress Enter to skip" -NoNewline
}
Do
{
	$drive = Read-Host -Prompt " "
	IF ($drives -eq $drive)
	{
		$drive = $(${drive}.ToUpper())
		$PicturesFolder = "${drive}:\Pictures"
		$PicturesReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Pictures"
		IF ($PicturesReg -ne $PicturesFolder)
		{
			IF (-not (Test-Path -Path $PicturesFolder))
			{
				New-Item -Path $PicturesFolder -ItemType Directory -Force
			}
			KnownFolderPath -KnownFolder Pictures -Path $PicturesFolder
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{0DDD015D-B06C-45D5-8C4C-F59713854639}" -PropertyType ExpandString -Value $PicturesFolder -Force
			Set-Content -Path "$PicturesFolder\desktop.ini" -Value $DesktopINI["Pictures"] -Encoding Unicode -Force
			(Get-Item -Path "$PicturesFolder\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$PicturesFolder\desktop.ini" -Force).Refresh()
		}
	}
	elseif ([string]::IsNullOrEmpty($drive))
	{
		break
	}
	else
	{
		IF ($RU)
		{
			Write-Host "`nДиск $(${drive}.ToUpper()): не существует. " -ForegroundColor Yellow -NoNewline
			Write-Host "Введите букву диска."
			Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
		}
		else
		{
			Write-Host "`nThe disk $(${drive}.ToUpper()): does not exist. " -ForegroundColor Yellow -NoNewline
			Write-Host "Type the drive letter."
			Write-Host "`nPress Enter to skip" -NoNewline
		}
	}
}
Until ($drives -eq $drive)
# Videos
# Видео
IF ($RU)
{
	Write-Host "`nВведите букву диска, в корне которого будет создана папка для " -NoNewline
	Write-Host "`"Видео`"" -ForegroundColor Yellow
	Write-Host "Файлы не будут перенесены: сделайте это вручную"
	Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
}
else
{
	Write-Host "`nType the drive letter in the root of which the " -NoNewline
	Write-Host "`"Videos`" " -ForegroundColor Yellow -NoNewline
	Write-Host "folder will be created."
	Write-Host "Files will not be moved. Do it manually"
	Write-Host "`nPress Enter to skip" -NoNewline
}
Do
{
	$drive = Read-Host -Prompt " "
	IF ($drives -eq $drive)
	{
		$drive = $(${drive}.ToUpper())
		$VideosFolder = "${drive}:\Videos"
		$VideosReg = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "My Video"
		IF ($VideosReg -ne $VideosFolder)
		{
			IF (-not (Test-Path -Path $VideosFolder))
			{
				New-Item -Path $VideosFolder -ItemType Directory -Force
			}
			KnownFolderPath -KnownFolder Videos -Path $VideosFolder
			New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{35286A68-3C57-41A1-BBB1-0EAE73D76C95}" -PropertyType ExpandString -Value $VideosFolder -Force
			Set-Content -Path "$VideosFolder\desktop.ini" -Value $DesktopINI["Videos"] -Encoding Unicode -Force
			(Get-Item -Path "$VideosFolder\desktop.ini" -Force).Attributes = "Hidden", "System", "Archive"
			(Get-Item -Path "$VideosFolder\desktop.ini" -Force).Refresh()
		}
	}
	elseif ([string]::IsNullOrEmpty($drive))
	{
		break
	}
	else
	{
		IF ($RU)
		{
			Write-Host "`nДиск $(${drive}.ToUpper()): не существует. " -ForegroundColor Yellow -NoNewline
			Write-Host "Введите букву диска."
			Write-Host "`nЧтобы пропустить, нажмите Enter" -NoNewline
		}
		else
		{
			Write-Host "`nThe disk $(${drive}.ToUpper()): does not exist. " -ForegroundColor Yellow -NoNewline
			Write-Host "Type the drive letter."
			Write-Host "`nPress Enter to skip" -NoNewline
		}
	}
}
Until ($drives -eq $drive)