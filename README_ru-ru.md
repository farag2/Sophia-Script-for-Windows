🌐 [English](/README.md) | [Deutsche](/README_de-de.md) | [Русский](/README_ru-ru.md) | [Українська](/README_uk-ua.md)

<div align="center">

<img src="https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/refs/heads/master/img/Sophia.png" alt="Sophia Script for Windows" width='150'>

# Sophia Script for Windows

Самый мощный PowerShell-модуль на GitHub для тонкой настройки Windows

Сделано с <img src="https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/img/heart.svg" height="17px"/> к Windows

<kbd>
	<a href="https://github.com/farag2/Sophia-Script-for-Windows/actions"><img src="https://img.shields.io/github/actions/workflow/status/farag2/Sophia-Script-for-Windows/Sophia.yml?labelColor=151B23&color=151B23&style=for-the-badge&label=build&logo=GitHub"></a>
</kbd>
<kbd>
	<a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Arm-support-green?labelColor=151B23&color=151B23&style=for-the-badge&logo=Arm&logoColor=white" href="#"></a>
</kbd>
<kbd>
	<a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Human%20Coded%20100%25-green?labelColor=151B23&color=151B23&style=for-the-badge" href="#"></a>
</kbd>

<br>

<kbd>
	<a href="https://github.com/farag2/Sophia-Script-for-Windows/blob/master/.github/workflows/Badge_downloads.yml"><img src="https://img.shields.io/endpoint?labelColor=151B23&color=151B23&style=for-the-badge&url=https://gist.githubusercontent.com/farag2/25ddc72387f298503b752ad5b8d16eed/raw/SophiaScriptDownloadsCount.json"></a>
</kbd>
<kbd>
	<a href="https://github.com/farag2/Sophia-Script-for-Windows/blob/master/.github/workflows/Badge_lines.yml"><img src="https://img.shields.io/endpoint?labelColor=151B23&color=151B23&style=for-the-badge&url=https://gist.githubusercontent.com/farag2/9852d6b9569a91bf69ceba8a94cc97f4/raw/SophiaScript.json"></a>
</kbd>

<br>

<kbd>
	<a href="https://t.me/sophianews"><img src="https://img.shields.io/badge/Sophia%20News-green?labelColor=151B23&color=151B23&style=for-the-badge&logo=telegram&logoColor=white"></a>
</kbd>
<kbd>
	<a href="https://t.me/sophia_chat"><img src="https://img.shields.io/badge/Sophia%20Chat-green?labelColor=151B23&color=151B23&style=for-the-badge&logo=telegram&logoColor=white"></a>
</kbd>
<kbd>
	<a href="https://discord.gg/sSryhaEv79"><img src="https://img.shields.io/badge/Discord-green?labelColor=151B23&color=151B23&style=for-the-badge&logo=discord&logoColor=white" href="#"></a>
</kbd>

<br>
<br>

<kbd>
	<a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Скачать-green?labelColor=151B23&color=151B23&style=for-the-badge"></a>
</kbd>

<br>
<br>

<img src="./img/SophiaScript.gif" width='800'>

</div>

## Ключевые возможности

* `Sophia Script for Windows` заботится о стабильности вашей Windows и уведомит вас в случае обнаружения проблемы
* Более 150 уникальных функций для настройки Windows с использованием официально задокументированных методов Microsoft без вреда системе
  * Каждая настройка имеет соответствующую функцию для восстановления значений по умолчанию
* Проект с полностью открытым исходным кодом
  * Все архивы собираются и загружаются на страницу релизов, используя [GitHub Actions](https://github.com/farag2/Sophia-Script-for-Windows/actions)
* Настроить Windows AI
* Настройка приватности, безопасности и персонализации Windows
* Доступен через Scoop, Chocolatey и WinGet
* Поддержка ARM64
* Поддержка PowerShell 7
* Не конфликтует с [VAC](https://help.steampowered.com/faqs/view/571A-97DA-70E9-FF74#whatisvac)
* Удалить UWP-приложений с отображением локализованных имен пакетов
  * Скрипт генерирует список установленных UWP-приложений [динамически](#скриншоты)
* Примененные политики реестра будут отображаться в оснастке редактирования групповых политик (gpedit.msc)
* Установить на выбор следующие DNS-провайдеры, используя DNS-over-HTTPS
  * [Cloudflare DNS](https://developers.cloudflare.com/1.1.1.1/setup/windows/)
  * [Google Public DNS](https://developers.google.com/speed/public-dns/docs/using)
  * [Quad9 DNS](https://quad9.net/service/service-addresses-and-features/)
  * [Comss.one DNS](https://www.comss.ru/page.php?id=7315)
  * [AdGuard DNS](https://adguard-dns.io/public-dns.html)
* Удалить OneDrive
* Интерактивные [подсказки и всплывающие окна](#скриншоты)
* [Автопродление](#как-выполнить-конкретную-функциюи) функций и их аргументов с помощью <kbd>TAB</kbd> (используя Import-TabCompletion.ps1)
* Изменить расположение пользовательских папок (без перемещения пользовательских файлов) с помощью интерактивного меню
  * Рабочий стол
  * Документы
  * Загрузки
  * Музыка
  * Изображения
  * Видео
* Установить бесплатный (светлый и темный) курсор "Windows 11 Cursors Concept v2" от [Jepri Creations](https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356) на лету (без перезагрузок)
  * Архив был скачан в папку [Cursors](https://github.com/farag2/Sophia-Script-for-Windows/tree/master/Cursors), используя [DeviantArt API](https://github.com/farag2/Sophia-Script-for-Windows/blob/master/.github/workflows/Cursors.yml)
* Установить приложение по умолчанию для конкретного расширения без всплывающего окошка `Каким образом вы хотите открыть этот файл?`
* Экспортировать и импортировать все ассоциации в Windows. Необходимо установить все приложения в соответствии с экспортированным файлом JSON-файлом, чтобы восстановить ассоциации
* Установить дистрибутив Linux через WSL, используя локализованные имена дистрибутивов с помощью всплывающего [окна](#скриншоты)
* Создать задания в Планировщике заданий с [нативным тостовым уведомлением](#скриншоты)
  * Создать задания `Windows Cleanup` и `Windows Cleanup Notification` для очистки Winsows от неиспользуемых файлов и файлов обновлений
  * Создать задание `SoftwareDistribution` для очистки `%SystemRoot%\SoftwareDistribution\Download`
  * Создать задание `Temp` для очистки `%TEMP%`
* Установить последней версии распространяемых пакетов Microsoft Visual C++ 2015–2026 x86/x64
* Установить последней версии распространяемых пакетов .NET Desktop Runtime 8, 9, 10 x64
* Много других твиков проводника и контекстного меню

## Содержание

* [Ключевые возможности](#ключевые-возможности)
* [Как скачать](#как-скачать)
* [Как использовать](#как-использовать)
  * [Как выполнить конкретную функцию(и)](#как-выполнить-конкретную-функциюи)
* [Системные требования](#системные-требования)
* [Скриншоты](#скриншоты)
* [Перевод](#перевод)
* [Ссылки](#ссылки)
* [SophiApp 2.0](#sophiapp-20-c--winui-3)

## Как скачать

### Со страницы релиза

<table>
  <tbody>
    <tr>
      <td align="center">Windows 10</td>
      <td align="center">Windows 11</td>
    </tr>
    <tr>
      <td align="left"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Windows%2010%20x64-PowerShell%205.1-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
      <td align="left"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Windows%2011-PowerShell%205.1-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
    </tr>
    <tr>
      <td align="left"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Windows%2010%20x64-PowerShell%207-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
      <td align="left"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Windows%2011-PowerShell%207-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
    </tr>
    <tr>
      <td align="left"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Windows%2010%20x64-LTSC%202019-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
      <td align="left"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Windows%2011%20LTSC%202024-PowerShell%205.1-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
    </tr>
    <tr>
      <td align="left"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Windows%2010%20x64-LTSC%202021-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
      <td align="left"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Windows%2011%20Arm-PowerShell%205.1-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
    </tr>
    <tr>
      <td align="left"></td>
      <td align="left"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Windows%2011%20Arm-PowerShell%207-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
    </tr>
    <tr>
      <td align="center" colspan="2"><a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Sophia%20Script%20Wrapper-green?labelColor=151B23&color=151B23&style=for-the-badge"></a></td>
    </tr>
  </tbody>
</table>

### Скачать через PowerShell

Скачать и распаковать в папку Загрузки последнюю версию `Sophia Script for Windows` в зависимости от версий ваших Windows и PowerShell.

```powershell
iwr script.sophia.team -useb | iex
```

Скачать и распаковать в папку Загрузки последнюю версию `Sophia Script for Windows` из актуального [коммита](https://github.com/farag2/Sophia-Script-for-Windows/commits/master/) в зависимости от версий ваших Windows и PowerShell.

```powershell
iwr sl.sophia.team -useb | iex
```

### Chocolatey

<https://chocolatey.org>

Скачать и распаковать в папку Загрузки последнюю версию `Sophia Script for Windows` в зависимости от вашей версии Windows.

```powershell
choco install sophia --force -y
```

Скачать и распаковать в папку Загрузки последнюю версию `Sophia Script for Windows` для PowerShell 7 в зависимости от вашей версии Windows.

```powershell
choco install sophia --params "/PS7" --force -y
```

```powershell
# Удалить, а затем удалить вручную скачанную папку
choco uninstall sophia --force -y
```

### WinGet

Скачать и распаковать в папку Загрузки последнюю версию `Sophia Script for Windows` для Windows 11 и PowerShell 5.1 (SFX-архив `sophiascript.exe`).

```powershell
$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
winget install --id TeamSophia.SophiaScript --location $DownloadsFolder --accept-source-agreements --force

& "$DownloadsFolder\sophiascript.exe"
```

```powershell
# Удалить Sophia Script for Windows
winget uninstall --id TeamSophia.SophiaScript --force
```

### Scoop

Скачать и распаковать в папку Загрузки последнюю версию `Sophia Script for Windows` для Windows 11 и PowerShell 5.1.

```powershell
# scoop bucket rm extras
scoop bucket add extras
scoop install sophia-script --no-cache
```

```powershell
# Удалить Sophia Script for Windows
scoop uninstall sophia-script --purge
```

## Как использовать

<https://github.com/user-attachments/assets/5af5c234-5fb5-4e7e-a3d0-ae496a89e6ba>

* Скачайте и распакуйте архив для вашей системы
* Просмотрите файл `Sophia.ps1` для настройки того, что выхотите, чтобы запускалось
  * Поставьте символ `#` перед функцией, если не хотите, чтобы она не запускалась
  * Удалите символ `#` перед функцией, если хотите, чтобы она запускалась
* Скопируйте путь до папки `Sophia Script for Windows`
* Нажмите правой кнопкой по кнопке Windows и откройте Терминал (PowerShell) от имени администратора и вставьте скопированный путь

```batch
  cd путь\до\папки
```

* Установите политику выполнения, чтобы можно было выполнять скрипты в текущей сессии PowerShell

```powershell
  Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
```

* Введите `.\Sophia.ps1` и нажмите <kbd>Enter</kbd>

### Как выполнить конкретную функцию(и)

<https://github.com/user-attachments/assets/d70150d6-af8c-4933-9ec5-b2cf3bb1dd34>

* Выполните все шаги из пункта [Как использовать](#как-использовать) и остановитесь на пункте по изменнию политики выполнения скриптов в `PowerShell`
* Сначала загрузите файл `Import-TabCompletion.ps1` через [дот сорсинг](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators#dot-sourcing-operator-):

```powershell
# С точкой в начале
. .\Import-TabCompletion.ps1
```

* Вызовите любую функцию из скрипта с использованием автопродления имени с помощью <kbd>TAB</kbd>

```powershell
Sophia -Functions<TAB>
Sophia -Functions temp<TAB>
Sophia -Functions unin<TAB>
Sophia -Functions uwp<TAB>
Sophia -Functions "DiagTrackService -Disable", "DiagnosticDataLevel -Minimal", Uninstall-UWPApps

Uninstall-UWPApps, "PinToStart -UnpinAll"
```

<https://github.com/user-attachments/assets/b7ba9ff5-fa3f-481c-a91f-d8bac5631a56>

## Wrapper

<img src="./img/Wrapper.png" width='600'>

Wrapper — это сторонний лончер с закрытым исходным кодом для `Sophia Script for Windows`. Проект полностью поддерживается [@BenchTweakGaming](https://github.com/BenchTweakGaming).

Подробнее [здесь](./Wrapper/README.md)

## Системные требования

[Windows-10]: https://support.microsoft.com/topic/windows-10-update-history-8127c2c6-6edf-4fdf-8b9f-0f7be1ef3562
[Windows-10-LTSC-2019]: https://support.microsoft.com/topic/windows-10-and-windows-server-2019-update-history-725fc2e1-4443-6831-a5ca-51ff5cbcb059
[Windows-10-LTSC-2021]: https://support.microsoft.com/topic/windows-10-update-history-857b8ccb-71e4-49e5-b3f6-7073197d98fb
[Windows-11-LTSC-2024]: https://support.microsoft.com/topic/windows-11-version-24h2-update-history-0929c747-1815-4543-8461-0160d16f15e5
[Windows-11-24h2]: https://support.microsoft.com/topic/windows-11-version-25h2-update-history-99c7f493-df2a-4832-bd2d-6706baa0dec0

|                Версия                    |                 Сборка                       |      Издание        |
|:-----------------------------------------|:--------------------------------------------:|:-------------------:|
| Windows 11 24H2/25H2+                    | [Последняя стабильная][Windows-11-24h2]      | Home/Pro/Enterprise |
| Windows 10 x64 22H2                      | [Последняя стабильная][Windows-10]           | Home/Pro/Enterprise |
| Windows 11 Enterprise LTSC 2024          | [Последняя стабильная][Windows-11-LTSC-2024] | Enterprise          |
| Windows 10 x64 21H2 Enterprise LTSC 2021 | [Последняя стабильная][Windows-10-LTSC-2021] | Enterprise          |
| Windows 10 x64 1809 Enterprise LTSC 2019 | [Последняя стабильная][Windows-10-LTSC-2019] | Enterprise          |

## Скриншоты

<div class="row">
  <img src="./img/uwpapps.png" width='314'>
  <img src="./img/WSL.png" width='350'>
</div>

<img src="./img/Toasts.png" width='400'>

## Перевод

* Выполните команду `$PSUICulture` в PowerShell, чтобы узнать код культуры
* Создайте папку с названием вашей культуры
* Поместите ваш переведенный файл SophiaScript.psd1 в эту папку.

## Ссылки

<details>
<a href="https://www.xda-developers.com/sophia-script-returns-control-windows-11">XDA</a>

<a href="https://4sysops.com/archives/windows-10-sophia-script-powershell-functions-for-windows-10-fine-tuning-and-automating-routine-configuration-tasks/">4sysops</a>

<a href="https://www.ghacks.net/2020/09/27/windows-10-setup-script-has-a-new-name-and-is-now-easier-to-use/">gHacks</a>

<a href="https://www.neowin.net/news/this-windows-10-setup-script-lets-you-fine-tune-around-150-functions-for-new-installs">Neowin</a>

<a href="https://www.comss.ru/page.php?id=8019">Comss.ru</a>

<a href="https://habr.com/company/skillfactory/blog/553800">Habr</a>

<a href="https://www.deskmodder.de/blog/2021/08/07/sophia-script-for-windows-jetzt-fuer-windows-11-und-10/)">Deskmodder.de</a>

<a href="https://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15">Ru-Board</a>

<a href="https://rutracker.org/forum/viewtopic.php?t=5996011">rutracker</a>

<a href="https://forums.mydigitallife.net/threads/powershell-windows-10-sophia-script.81675/">My Digital Life</a>
</details>

***

## SophiApp 2.0 (C# + WinUI 3)

[SophiApp 2.0](https://github.com/Sophia-Community/SophiApp) находится в активной разработке. 🚀

![Image](https://github.com/farag2/Sophia-Script-for-Windows/raw/master/img/0.gif)
![Image](https://github.com/farag2/Sophia-Script-for-Windows/raw/master/img/1.png)
