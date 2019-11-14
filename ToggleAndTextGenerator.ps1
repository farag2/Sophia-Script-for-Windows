Cls
#region Toggles Text

#region Toggles Text Eng

[Array]$Text_Eng_Privacy =
	"Turn off `"Connected User Experiences and Telemetry`" service",
	"Turn off per-user services",
	"Turn off the SQMLogger session at the next computer restart",
	"Set the operating system diagnostic data level to `"Basic`"",
	"Turn off Windows Error Reporting",
	"Change Windows Feedback frequency to `"Never`"",
	"Turn off diagnostics tracking scheduled tasks",
	"Do not offer tailored experiences based on the diagnostic data setting",
	"Do not let apps on other devices open and message apps on this device, and vice versa",
	"Do not allow apps to use advertising ID",
	"Do not use sign-in info to automatically finish setting up device after an update or restart",
	"Do not let websites provide locally relevant content by accessing language list",
	"Turn on tip, trick, and suggestions as you use Windows",
	"Do not show app suggestions on Start menu",
	"Do not show suggested content in the Settings",
	"Turn off automatic installing suggested apps",
	"Do not let track app launches to improve Start menu and search results"

[Array]$Text_Eng_UI =
	"Show `"This PC`" on Desktop",
	"Set File Explorer to open to This PC by default",
	"Show Hidden Files, Folders, and Drives",
	"Turn off check boxes to select items",
	"Show File Name Extensions",
	"Show folder merge conflicts",
	"Do not show all folders in the navigation pane",
	"Do not show Cortana button on taskbar",
	"Do not show Task View button on taskbar",
	"Do not show People button on the taskbar",
	"Show seconds on taskbar clock",
	"Turn on acrylic taskbar transparency",
	"Do not show when snapping a window, what can be attached next to it",
	"Show more details in file transfer dialog",
	"Turn on ribbon in File Explorer",
	"Turn on recycle bin files delete confirmation",
	"Remove 3D Objects folder in `"This PC`" and in the navigation pane",
	"Do not show `"Frequent folders`" in Quick access",
	"Do not show `"Recent files`" in Quick access",
	"Remove the `"Previous Versions`" tab from properties context menu",
	"Hide search box or search icon on taskbar",
	"Do not show `"Windows Ink Workspace`" button in taskbar",
	"Always show all icons in the notification area",
	"Unpin Microsoft Edge and Microsoft Store from taskbar",
	"Set the Control Panel view by large icons",
	"Choose theme color for default Windows mode",
	"Choose theme color for default app mode",
	"Do not show `"New App Installed`" notification",
	"Do not show user first sign-in animation",
	"Turn off JPEG desktop wallpaper import quality reduction",
	"Show Task Manager details",
	"Show accent color on the title bars and window borders",
	"Turn off automatically hiding scroll bars",
	"Show more Windows Update restart notifications about restarting",
	"Turn off the `"- Shortcut`" name extension for new shortcuts",
	"Use the PrtScn button to open screen snipping",
	"Automatically adjust active hours for me based on daily usage"

[Array]$Text_Eng_OneDrive = "Uninstall OneDrive"

[Array]$Text_Eng_System =
	"Turn on Storage Sense to automatically free up space",
	"Run Storage Sense every month",
	"Delete temporary files that apps aren't using",
	"Delete files in recycle bin if they have been there for over 30 days",
	"Never delete files in `"Downloads`" folder",
	"Let Windows try to fix apps so they're not blurry",
	"Turn off hibernate",
	"Turn off location for this device",
	"Change %TEMP% environment variable path to %SystemDrive%\Temp",
	"Turn on Win32 long paths",
	"Group svchost.exe processes",
	"Turn on the display of stop error information on the BSoD",
	"Do not preserve zone information",
	"Turn off Admin Approval Mode for administrators",
	"Turn on access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled",
	"Set download mode for delivery optization on `"HTTP only`"",
	"Always wait for the network at computer startup and logon",
	"Do not let Windows manage default printer",
	"Turn off Windows features",
	"Remove Windows capabilities",
	"Turn on updates for other Microsoft products",
	"Remove Shadow copies (restoration points)",
	"Turn off Windows Script Host",
	"Turn off default background apps, except the followings...",
	"Set power management scheme for !!!",
	"Turn on latest installed .NET runtime for all apps",
	"Do not allow the computer to turn off the Ethernet adapter to save power",
	"Set the default input method to the English language",
	"Turn on Windows Sandbox",
	"Set location of the `"Desktop`", `"Documents`", `"Downloads`", `"Music`", `"Pictures`", and `"Videos`"",
	"Run troubleshooters automatically, then notify",
	"Set `"High performance`" in graphics performance preference for apps",
	"Launch folder in a separate process",
	"Turn off and delete reserved storage after the next update installation",
	"Turn on automatic backup the system registry to the %SystemRoot%\System32\config\RegBack folder",
	"Turn off `"The Windows Filtering Platform has blocked a connection`" message in `"Windows Logs\Security`"",
	"Turn off SmartScreen for apps and files",
	"Turn off F1 Help key",
	"Turn on Num Lock at startup",
	"Turn off sticky Shift key after pressing 5 times",
	"Turn off AutoPlay for all media and devices",
	"Turn off thumbnail cache removal",
	"Turn on automatically save my restartable apps when sign out and restart them after sign in"

[Array]$Text_Eng_StartMenu =
	"Do not show recently added apps on Start menu",
	"Open shortcut to the Command Prompt from Start menu as Administrator",
	"Add old style shortcut for `"Devices and Printers`" to the Start menu",
	"Import Start menu layout from pre-saved .reg file",
	"Unpin all Start menu tiles"

[Array]$Text_Eng_Edge =
	"Turn off Windows Defender SmartScreen for Microsoft Edge",
	"Do not allow Microsoft Edge to start and load the Start and New Tab page at Windows startup and each time Microsoft Edge is closed",
	"Do not allow Microsoft Edge to pre-launch at Windows startup, when the system is idle, and each time Microsoft Edge is closed",
	"Turn off creation of an Edge shortcut on the desktop for each user profile"

#$Text_Eng_UWP =
#	"Uninstall all UWP apps from all accounts, except the followings...",
#	"Uninstall all provisioned UWP apps from System account, except the followings..."

[Array]$Text_Eng_WindowsGameRecording =
	"Turn off Windows Game Recording and Broadcasting",
	"Turn off Game Bar",
	"Turn off Game Mode",
	"Turn off Game Bar tips"

[Array]$Text_Eng_ScheduledTasks = 
	"Create a task in the Task Scheduler to start Windows cleaning up",
	"Create a task in the Task Scheduler to clear the %SystemRoot%\SoftwareDistribution\Download folder",
	"Create a task in the Task Scheduler to clear the %SystemRoot%\Temp folder"

[Array]$Text_Eng_MicrosoftDefender =
	"Add exclusion folder from Windows Defender Antivirus scanning",
	"Turn on Controlled folder access and add protected folders",
	"Allow an app through Controlled folder access",
	"Turn on Windows Defender Exploit Guard Network Protection",
	"Turn on Windows Defender PUA Protection",
	"Turn on Windows Defender Sandbox",
	"Hide notification about sign in with Microsoft in the Windows Security",
	"Hide notification about disabled SmartScreen for Microsoft Edge"

[Array]$Text_Eng_ContextMenu =
	"Add `"Extract`" to MSI file type context menu",
	"Add `"Run as different user`" from context menu for .exe file type",
	"Add `"Install`" to CAB file type context menu",
	"Remove `"Cast to Device`" from context menu",
	"Remove `"Share`" from context menu",
	"Remove `"Previous Versions`" from file context menu",
	"Remove `"Edit with Paint 3D`" from context menu",
	"Remove `"Include in Library`" from context menu",
	"Remove `"Turn on BitLocker`" from context menu",
	"Remove `"Edit with Photos`" from context menu",
	"Remove `"Create a new video`" from context menu",
	"Remove `"Edit`" from images context menu",
	"Remove `"Print`" from batch and cmd files context menu",
	"Remove `"Compressed (zipped) Folder`" from context menu",
	"Remove `"Send to`" from folder context menu",
	"Make the `"Open`", `"Print`", `"Edit`" context menu items available, when more than 15 selected",
	"Turn off `"Look for an app in the Microsoft Store`" in `"Open with`" dialog"
#endregion Toggles Text Eng

#region Toggles Text Ru
[Array]$Text_Ru_Privacy =
	"Отключить службу `"Функциональные возможности для подключенных пользователей и телеметрия`"",
	"Отключить пользовательские службы",
	"Отключить сборщик SQMLogger при следующем запуске ПК",
	"Установить уровень отправляемых диагностических сведений на `"Базовый`"",
	"Отключить отчеты об ошибках Windows",
	"Изменить частоту формирования отзывов на `"Никогда`"",
	"Отключить задачи диагностического отслеживания",
	"Не предлагать персонализированныее возможности, основанные на выбранном параметре диагностических данных",
	"Не разрешать приложениям на других устройствах запускать приложения и отправлять сообщения на этом устройстве и наоборот",
	"Не разрешать приложениям использовать идентификатор рекламы",
	"Не использовать данные для входа для автоматического завершения настройки устройства после перезапуска или обновления",
	"Не позволять веб-сайтам предоставлять местную информацию за счет доступа к списку языков",
	"Показывать советы, подсказки и рекомендации при использованию Windows",
	"Не показывать рекомендации в меню `"Пуск`"",
	"Не показывать рекомендуемое содержание в `"Параметрах`"",
	"Отключить автоматическую установку рекомендованных приложений",
	"Не разрешать Windows отслеживать запуски приложений для улучшения меню `"Пуск`" и результатов поиска и не показывать недавно добавленные приложения"

[Array]$Text_Ru_UI =
	"Отобразить `"Этот компьютер`" на рабочем столе",
	"Открывать `"Этот компьютер`" в Проводнике",
	"Показывать скрытые файлы, папки и диски",
	"Отключить флажки для выбора элементов",
	"Показывать расширения для зарегистрированных типов файлов",
	"Не скрывать конфликт слияния папок",
	"Не отображать все папки в области навигации",
	"Не показывать кнопку Кортаны на панели задач",
	"Не показывать кнопку Просмотра задач",
	"Не показывать панель `"Люди`" на панели задач",
	"Отображать секунды в системных часах на панели задач",
	"Включить прозрачную панель задач",
	"Не показывать при прикреплении окна, что можно прикрепить рядом с ним",
	"Развернуть диалог переноса файлов",
	"Включить отображение ленты проводника в развернутом виде",
	"Запрашивать подтверждение на удалении файлов из корзины",
	"Скрыть папку `"Объемные объекты`" из `"Этот компьютер`" и на панели быстрого доступа",
	"Не показывать недавно используемые папки на панели быстрого доступа",
	"Не показывать недавно использовавшиеся файлы на панели быстрого доступа",
	"Отключить отображение вкладки `"Предыдущие версии`" в свойствах файлов и папок",
	"Скрыть поле или значок поиска на Панели задач",
	"Не показывать кнопку Windows Ink Workspace на панели задач",
	"Всегда отображать все значки в области уведомлений",
	"Открепить Microsoft Edge и Microsoft Store от панели задач",
	"Установить крупные значки в панели управления",
	"Выбрать режим Windows по умолчанию",
	"Выбрать режим приложения по умолчанию",
	"Не показывать уведомление `"Установлено новое приложение`"",
	"Не показывать анимацию при первом входе в систему",
	"Отключить снижение качества фона рабочего стола в формате JPEG",
	"Раскрыть окно Диспетчера задач",
	"Отображать цвет элементов в заголовках окон и границ окон",
	"Отключить автоматическое скрытие полос прокрутки в Windows",
	"Показывать уведомление, когда компьютеру требуется перезагрузка для завершения обновления",
	"Нe дoбaвлять `"- яpлык`" для coздaвaeмыx яpлыкoв",
	"Использовать кнопку PRINT SCREEN, чтобы запустить функцию создания фрагмента экрана",
	"Автоматически изменять период активности для этого устройства на основе действий"

[Array]$Text_Ru_OneDrive = "Удалить OneDrive"

[Array]$Text_Ru_System =
	"Включить Память устройства для автоматического освобождения места",
	"Запускать контроль памяти каждый месяц",
	"Удалять временные файлы, не используемые в приложениях",
	"Удалять файлы, которые находятся в корзине более 30 дней",
	"Никогда не удалять файлы из папки `"Загрузки`"",
	"Разрешить Windows исправлять размытость в приложениях",
	"Отключить гибридный спящий режим",
	"Отключить местоположение для этого устройства",
	"Изменить путь переменной среды %TEMP% на %SystemDrive%\Temp",
	"Включить длинные пути Win32",
	"Группировать процессы svchost.exe",
	"Включить дополнительную информацию при выводе BSoD",
	"Не хранить сведения о зоне происхождения вложенных файлов",
	"Отключить использование режима одобрения администратором для встроенной учетной записи администратора",
	"Включить доступ к сетевым дискам при включенном режиме одобрения администратором при доступе из программ, запущенных с повышенными правами",
	"Отключить оптимизацию доставки для обновлений с других ПК",
	"Всегда ждать сеть при запуске и входе в систему",
	"Не разрешать Windows управлять принтером, используемым по умолчанию",
	"Отключить компоненты",
	"Удалить компоненты",
	"Включить автоматическое обновление для других продуктов Microsoft",
	"Удалить теневые копии (точки восстановения)",
	"Отключить Windows Script Host",
	"Запретить стандартным приложениям работать в фоновом режиме, кроме следующих...",
	"Установить схему управления питания для !!!",
	"Использовать последнюю установленную версию .NET для всех приложений",
	"Запретить отключение Ethernet-адаптера для экономии энергии",
	"Установить метод ввода по умолчанию на английский язык",
	"Включить Windows Sandbox",
	"Переопределить расположение папок `"Рабочий стол`", `"Документы`", `"Загрузки`", `"Музыка`", `"Изображения`", `"Видео`"",
	"Автоматически запускать средства устранения неполадок, а затем уведомлять",
	"Установить параметры производительности графики для отдельных приложений на `"Высокая производительность`"",
	"Запускать окна с папками в отдельном процессе",
	"Отключить и удалить зарезервированное хранилище после следующей установки обновлений",
	"Включить автоматическое создание копии реестра в папку %SystemRoot%\System32\config\RegBack",
	"Отключить в `"Журналах Windows\Безопасность`" сообщение `"Платформа фильтрации IP-пакетов Windows разрешила подключение`"",
	"Отключить SmartScreen для приложений и файлов",
	"Отключить справку по нажатию F1",
	"Включить Num Lock при загрузке",
	"Отключить залипание клавиши Shift после 5 нажатий",
	"Отключить автозапуск с внешних носителей",
	"Отключить удаление кэша миниатюр",
	"Автоматически сохранять мои перезапускаемые приложения при выходе из системы и перезапустить их после выхода"

[Array]$Text_Ru_StartMenu =
	"Не показывать недавно добавленные приложения в меню `"Пуск`"",
	"Запускать ярлык к командной строке в меню `"Пуск`" от имени Администратора",
	"Добавить ярлык старого формата для `"Устройства и принтеры`" в меню `"Пуск`"",
	"Импорт настроенного макета меню `"Пуск`" из предварительно сохраненного .reg-файла",
	"Открепить все ярлыки от начального экрана"

[Array]$Text_Ru_Edge =
	"Отключить Windows Defender SmartScreen в Microsoft Edge",
	"Не разрешать Edge запускать и загружать страницу при загрузке Windows и каждый раз при закрытии Edge",
	"Не разрешать предварительный запуск Edge при загрузке Windows, когда система простаивает, и каждый раз при закрытии Edge",
	"Отключить создание ярлыка Edge на рабочем столе для каждого профиля пользователя пользователя"

#$Text_Ru_UWP =
#	"Удалить все UWP-приложения из всех учетных записей, кроме следующих...",
#	"Удалить все UWP-приложения из системной учетной записи, кроме следующих..."

[Array]$Text_Ru_WindowsGameRecording =
	"Отключить Запись и трансляции игр Windows",
	"Отключить игровую панель",
	"Отключить игровой режим",
	"Отключить подсказки игровой панели"

[Array]$Text_Ru_ScheduledTasks =
	"Создать задачу в Планировщике задач по очистке обновлений Windows",
	"Создать задачу в Планировщике задач по очистке папки %SystemRoot%\SoftwareDistribution\Download",
	"Создать задачу в Планировщике задач по очистке папки %TEMP%"

[Array]$Text_Ru_MicrosoftDefender =
	"Добавить папку в список исключений сканирования Защитника Windows",
	"Включить контролируемый доступ к папкам и добавить защищенные папки",
	"Разрешить работу приложения через контролируемый доступ к папкам",
	"Включить Защиту сети в Защитнике Windows",
	"Включить блокировки потенциально нежелательных приложений",
	"Запускать Защитник Windows в песочнице",
	"Скрыть уведомление Защитника Windows об использовании аккаунта Microsoft",
	"Скрыть уведомление Защитника Windows об отключенном фильтре SmartScreen для Microsoft Edge"

[Array]$Text_Ru_ContextMenu =
	"Добавить пункт `"Extract`" для MSI в контекстное меню",
	"Добавить `"Запуск от имени другого пользователя`" в контекстное меню для .exe файлов",
	"Добавить пункт `"Установить`" для CAB-файлов в контекстном меню",
	"Удалить пункт `"Передать на устройство`" из контекстного меню",
	"Удалить пункт `"Отправить`" (поделиться) из контекстного меню",
	"Удалить пункт `"Восстановить прежнюю версию`" из контекстного меню",
	"Удалить пункт `"Изменить с помощью Paint 3D`" из контекстного меню",
	"Удалить пункт `"Добавить в библиотеку`" из контекстного меню",
	"Удалить пункт `"Включить BitLocker`" из контекстного меню",
	"Удалить пункт `"Изменить с помощью приложения `"Фотографии`"`" из контекстного меню",
	"Удалить пункт `"Создать новое видео`" из контекстного меню",
	"Удалить пункт `"Изменить`" из контекстного меню изображений",
	"Удалить пункт `"Печать`" из контекстного меню для bat- и cmd-файлов",
	"Удалить пункт `"Сжатая ZIP-папка`" из контекстного меню",
	"Удалить пункт `"Отправить`" из контекстного меню папки",
	"Сделать доступными элементы контекстного меню `"Открыть`", `"Изменить`" и `"Печать`" при выделении более 15 элементов",
	"Отключить поиск программ в Microsoft Store при открытии диалога `"Открыть с помощью`""
#endregion Toggles Text Ru

#endregion Toggles Text

$curDir = $MyInvocation.MyCommand.Definition | Split-Path -Parent
$resultFile = "{0}\ToggleAndTextGenerator.txt"-f $curDir
$toggles = New-Object System.Collections.ArrayList($null)
$textE = New-Object System.Collections.ArrayList($null)
$textR = New-Object System.Collections.ArrayList($null)
$textBlockUid = 0
$toggleUid = 1000
$category = "ContextMenu", "Edge", "MicrosoftDefender", "OneDrive", "Privacy", "ScheduledTasks", 
"StartMenu", "System", "UI", "WindowsGameRecording"

if (Test-Path -Path $resultFile)
{
	Remove-Item -Path $resultFile -Confirm:$false -Force
	Write-Warning -Message "Файл ""$resultFile"" удален!"
}
 
$category | %{	
	$catName = "$_"	
	$textEng = Get-Variable -Name ("Text_Eng_$catName")
	$textRu = Get-Variable -Name ("Text_Ru_$catName")
	
	if ($textEng.Value.Count -eq $textRu.Value.Count)
	{
		[Void]$toggles.Add("------------ $catName ------------")
		for ($i=0;$i -lt $textEng.Value.Count;$i++)
		{
			$strE = $textEng.Value[$i]
			$strR = $textRu.Value[$i]
			
			if ($strE.Contains('"')) {$strE = $strE.Replace('"', '""')}
			if ($strR.Contains('"')) {$strR = $strR.Replace('"', '""')}			
			
			[Void]$textE.Add("""{0}"","-f $strE)
			[Void]$textR.Add("""{0}"","-f $strR)
			
			$toggleName = "Toggle_{0}_{1}"-f $catName, $toggleUid
			$textblockName = "Text_{0}_{1}"-f $catName, $textBlockUid
			$template = @"
			
<Border Style="{StaticResource ToggleBorder}">
<DockPanel Margin="0 10 0 10">
<Grid HorizontalAlignment="Left">
<ToggleButton Name="$toggleName" Uid="$toggleUid" Style="{StaticResource ToggleSwitchLeftStyle}" IsChecked="False"/>
<TextBlock Name="$textblockName" Uid="$textBlockUid" Text="" Margin="65 0 10 0" VerticalAlignment="Center" TextWrapping="Wrap" IsHitTestVisible="False">
<TextBlock.Style>
<Style TargetType="{x:Type TextBlock}">
<Style.Triggers>
<DataTrigger Binding="{Binding ElementName=$toggleName, Path=IsChecked}" Value="True">
<Setter Property="Foreground" Value="#3F51B5"/>
</DataTrigger>
</Style.Triggers>
</Style>
</TextBlock.Style>
</TextBlock>
</Grid>
</DockPanel>
</Border>			
"@
		[Void]$toggles.Add($template)
		$toggleUid++
		$textBlockUid++
		}
		[Void]$toggles.Add("------------ $catName ------------")
	}
	
	else
	{
		Write-Warning -Message "Количество строк в массивах ""$textEng"" и ""$textRu"" не совпадает!"		
	}
}

$toggles | Out-File -FilePath $resultFile -Force -Confirm:$false
