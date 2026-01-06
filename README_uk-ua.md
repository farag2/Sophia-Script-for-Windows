[English](/README.md) | [Deutsche](/README_de-de.md) | [Русский](/README_ru-ru.md) | [Українська](/README_uk-ua.md)

<div align="center">

<img src="https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/refs/heads/master/img/Sophia.png" alt="Sophia Script for Windows" width='150'>

# Sophia Script for Windows

**Найпотужніший PowerShell-модуль на GitHub для тонкого настроювання Windows**

Зроблено з <img src="https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/img/heart.svg" height="17px"/> до Windows

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
	<a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://img.shields.io/badge/Завантажити-green?labelColor=151B23&color=151B23&style=for-the-badge"></a>
</kbd>

<br>
<br>

<img src="../img/SophiaScript.gif" width='800'>

</div>

## Про Sophia Script

`Sophia Script для Windows` - це найпотужніший модуль PowerShell на `GitHub` для тонкого налаштування і автоматизації рутинних завдань в `Windows 10` і `Windows 11`. Він пропонує сучасні UI/UX, більше 150 різних функцій і показує, як можна налаштувати Windows, не ламаючи функціонал.

> [!IMPORTANT]
> Кожна зміна у файлі налаштувань має відповідну функцію для відновлення налаштувань за замовчуванням.

## Ключові особливості

* Проект с полностью открытым исходным кодом
  * Всі архіви збираються і завантажуються на сторінку релізів, використовуючи GitHub Actions, в [автоматичному режимі](https://github.com/farag2/Sophia-Script-for-Windows/actions).
  * Курсоры от [Jepri Creations](https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356) были скачаны, используя [DeviantArt API](https://github.com/farag2/Sophia-Script-for-Windows/blob/master/.github/workflows/Cursors.yml)
* Доступний через scoop, Chocolatey та WinGet
* Не конфліктує з [VAC](https://help.steampowered.com/faqs/view/571A-97DA-70E9-FF74#whatisvac)
* Налаштування конфіденційності Windows
* Налаштування безпеки Windows
* Налаштування інтерфейсу і персоналізація
* Відобразити застосовані політики реєстру в оснащенні редагування групових політик (gpedit.msc)
* Активація DNS-over-HTTPS для IPv4
* Вимкнення запланованих завдань з відстеження зі спливаючою формою, написаною на [WPF](#скріншоти)
* "Правильне" видалення OneDrive
* Інтерактивні [підказки](#програмна-зміна-розташування-папок-користувача-за-допомогою-інтерактивного-меню)
* <kbd>TAB</kbd> [доповнення](#автодоповнення-tab-детальніше-тут) для функцій та їх аргументів (якщо використовується файл Import-TabCompletion.ps1)
* Зміна розташування користувацьких папок програмно (без переміщення користувацьких файлів) в інтерактивному меню за допомогою стрілок для вибору диска
  * Робочий стіл
  * Документи
  * Завантаження
  * Музика
  * Зображення
  * Відео
* Встановлення безкоштовних (світлий та темний) курсорів "Windows 11 Cursors Concept v2" від [Jepri Creations](https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356) на льоту
* Видалення UWP-додатків, що відображають назви пакетів
  * Скрипт генерує список встановлених UWP-додатків [динамічно](#локалізовані-назви-uwp-пакетів).
* Вимкнення функцій Windows для відображення дружніх назв пакетів у спливаючій формі, написаній на [WPF](#скріншоти)
* Видалення можливостей Windows відображати дружні назви пакетів у спливаючій формі, написаній на [WPF](#скріншоти)
* Завантаження та встановлення [HEVC Video Extensions від виробника пристрою](https://apps.microsoft.com/detail/9N4WGH0Z6VHQ) для відкриття формата [HEVC](https://en.wikipedia.org/wiki/High_Efficiency_Video_Coding)
* Реєстрація програми, розрахунок хешу та встановлення за замовчуванням для певного розширення без спливаючого вікна "Як ви хочете відкрити це" за допомогою спеціальної [функції](https://github.com/DanysysTeam/PS-SFTA)
* Експортувати всі асоціації в Windows у корінь папки у вигляді файлу Application_Associations.json
* Імпортувати всі асоціації в Windows з файлу Application_Associations.json. Вам необхідно встановити всі програми згідно з експортованим файлом Application_Associations.json, щоб відновити всі асоціації
* Встановлення будь-якого підтримуваного дистрибутива Linux для WSL з відображенням дружніх назв дистрибутивів у спливаючій формі, написаній на [WPF](#скріншоти)
  * Створити завдання з нативним тостовим повідомленням, де ви зможете запустити або скасувати [виконання](#інтерактивні-тости-для-запланованих-завдань) завдання
  * Створити завдання `Windows Cleanup` и `Windows Cleanup Notification` для очищення Windows від невикористовуваних файлів та оновлень
  * Створити завдання `SoftwareDistribution` для очищення `%SystemRoot%\SoftwareDistribution\Download`
  * Створити завдання `Temp` для очищення `%TEMP%`
* Встановити останню версію розповсюджуваних пакетів Microsoft Visual C++ 2015–2026 x86/x64 (підтримка ARM64)
* Встановити останню версію розповсюджуваних пакетів .NET Desktop Runtime 8, 9, 10 x64 (підтримка ARM64)
* Ще багато "глибоких" налаштувань Файлового Провідника та контекстного меню

## Зміст

* [Ключові особливості](#ключові-особливості)
* [Як завантажити](#як-завантажити)
  * [Зі сторінки релізу](#зі-сторінки-релізу)
  * [Завантажити через PowerShell](#завантажити-через-powershell)
  * [Завантажити через Chocolatey](#завантажити-через-chocolatey)
  * [Завантажити через WinGet](#завантажити-через-winget)
  * [Завантажити через scoop](#завантажити-через-scoop)
* [Як використовувати](#як-використовувати)
  * [Як запустити певну функцію(ї)](#як-запустити-певну-функціюї)
  * [Wrapper](#wrapper)
  * [Як відкотити зміни](#як-відкотити-зміни)
* [Пожертвування](#пожертвування)
* [Системні вимоги](#системні-вимоги)
* [Скріншоти](#скріншоти)
* [Відео](#відео)
* [Як перекласти](#як-перекласти)
* [Медіа](#медіа)
* [SophiApp 2](#sophiapp-2-c--winui-3)

## Як завантажити

### Зі сторінки релізу

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

### Завантажити через PowerShell

Завантажте та розпакуйте в папку Завантаження останню версію `Sophia Script for Windows` залежно від версій ваших Windows та PowerShell.

```powershell
iwr script.sophia.team -useb | iex
```
Завантажте та розпакуйте в папку Завантаження останню версію `Sophia Script for Windows` з актуального [коміту](https://github.com/farag2/Sophia-Script-for-Windows/commits/master/) залежно від версій ваших Windows і PowerShell.

```powershell
iwr sl.sophia.team -useb | iex
```

### Завантажити через Chocolatey

<https://chocolatey.org>

Завантажте та розпакуйте в папку Завантаження останню версію `Sophia Script for Windows` залежно від вашої версії Windows.

```powershell
choco install sophia --force -y
```

Завантажте та розпакуйте в папку Завантаження останню версію `Sophia Script for Windows` для PowerShell 7 залежно від вашої версії Windows.

```powershell
choco install sophia --params "/PS7" --force -y
```

```powershell
# Видалити, а потім видалити вручну завантажену папку
choco uninstall sophia --force -y
```

### Завантажити через WinGet

<https://github.com/microsoft/winget-cli>

Завантажте та розпакуйте в папку Завантаження останню версію `Sophia Script for Windows` для Windows 11 і PowerShell 5.1 (SFX-архів `sophiascript.exe`).

```powershell
$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
winget install --id TeamSophia.SophiaScript --location $DownloadsFolder --accept-source-agreements --force

& "$DownloadsFolder\sophiascript.exe"
```

```powershell
# Видалити Sophia Script for Windows
winget uninstall --id TeamSophia.SophiaScript --force
```

### Завантажити через scoop

<https://scoop.sh>

Завантажте та розпакуйте в папку Завантаження останню версію `Sophia Script for Windows` для Windows 11 та PowerShell 5.1.

```powershell
# scoop bucket rm extras
scoop bucket add extras
scoop install sophia-script --no-cache
```

```powershell
# Видалити Sophia Script for Windows
scoop uninstall sophia-script --purge
```

## Як використовувати

* Завантажте та розархівуйте архів
* Розпакуйте архів
* Перегляньте файл `Sophia.ps1` для налаштування функцій, які потрібно запустити
  * Помістіть символ `#` перед функцією, якщо ви не бажаєте, щоб вона виконувалась.
  * Приберіть символ `#` перед функцією, якщо ви бажаєте, щоб вона виконувалась.
* Скопіюйте весь шлях до `Sophia.ps1`
  * У `Windows 10` натисніть і утримуйте клавішу <kbd>Shift</kbd>, клацніть правою кнопкою миші на `Sophia.ps1` і виберіть Копіювати як шлях
  * У `Windows 11` клацніть правою кнопкою миші на `Sophia.ps1` і виберіть `Копіювати як шлях`.
* Відкрийте `Windows PowerShell`
  * У `Windows 10` натисніть `Файл` у Провіднику файлів, наведіть курсор на `Відкрити Windows PowerShell` і виберіть `Відкрити Windows PowerShell від імені адміністратора` [(покрокова інструкція зі скріншотами)](https://www.howtogeek.com/662611/9-ways-to-open-powershell-in-windows-10/)
  * У `Windows 11` натисніть правою кнопкою миші на іконку <kbd>Windows</kbd> і відкрийте `Термінал Windows (Адміністратор)`.
* Встановіть політику виконання, щоб мати змогу запускати сценарії лише у поточному сеансі PowerShell

```powershell
  Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
```

* Введіть `.\Sophia.ps1` і натисніть <kbd>Enter</kbd>

```powershell
  .\Sophia.ps1
```

### Windows 11

<https://github.com/user-attachments/assets/2654b005-9577-4e56-ac9e-501d3e8a18bd>

### Windows 10

<https://github.com/user-attachments/assets/f5bda68f-9509-41dc-b3b1-1518aeaee36f>

### Як запустити певну функцію(ї)

* Повторіть усі кроки з розділу [Як використовувати](#як-використовувати) і зупиніться на кроці встановлення політики виконання скриптів у `PowerShell`
* Для запуску певної функції(й) [запустити](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators#dot-sourcing-operator-) необхідно запустити файл `Import-TabCompletion.ps1`:

```powershell
# З крапкою на початку
. .\Import-TabCompletion.ps1
```

* Викличте будь-яку функцію зі скрипта з використанням автопродовження імені за допомогою <kbd>TAB</kbd>.

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

![Image](https://github.com/farag2/Sophia-Script-for-Windows/raw/master/img/Wrapper.png)

Детальніше [тут](../Wrapper/README.md)

[@BenchTweakGaming](https://github.com/BenchTweakGaming)

* Завантажте [останню](https://github.com/farag2/Sophia-Script-for-Windows/releases/latest) версію Wrapper
* Завантажте та розпакуйте архів
* Запустіть `SophiaScriptWrapper.exe` та імпортуйте `Sophia.ps1`
  * `Sophia.ps1` повинен знаходитись у тій папці `Sophia Script`
  * Wrapper має рендеринг інтерфейсу в реальному часі
* Налаштуйте кожну функцію
* Відкрийте вкладку `Console Output` і натисніть `Run PowerShell`.

## Як відкотити зміни

* Повторіть усі кроки з розділу [Як використовувати](#як-використовувати) і зупиніться на кроці встановлення політики виконання скриптів у `PowerShell`
* Для запуску певної функції(й) [запустити](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators#dot-sourcing-operator-) необхідно запустити файл `Import-TabCompletion.ps1`:

```powershell
# З крапкою на початку
. .\Import-TabCompletion.ps1
```

* Викличте функції з пресета `Sophia.ps1`, які ви хочете відкотити.

```powershell
Sophia -Functions "DiagTrackService -Enable", Uninstall-UWPApps
```

## Пожертвування

[![ko-fi](https://www.ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/farag)

## Системні вимоги

[Windows-10]: https://support.microsoft.com/topic/windows-10-update-history-8127c2c6-6edf-4fdf-8b9f-0f7be1ef3562
[Windows-10-LTSC-2019]: https://support.microsoft.com/topic/windows-10-and-windows-server-2019-update-history-725fc2e1-4443-6831-a5ca-51ff5cbcb059
[Windows-10-LTSC-2021]: https://support.microsoft.com/topic/windows-10-update-history-857b8ccb-71e4-49e5-b3f6-7073197d98fb
[Windows-11-LTSC-2024]: https://support.microsoft.com/topic/windows-11-version-24h2-update-history-0929c747-1815-4543-8461-0160d16f15e5
[Windows-11-24h2]: https://support.microsoft.com/topic/windows-11-version-25h2-update-history-99c7f493-df2a-4832-bd2d-6706baa0dec0

|                Версія                    |              Збіркa                   |       Видання       |
|:-----------------------------------------|:-------------------------------------:|:-------------------:|
| Windows 11 24H2/25H2+                    | [Latest stable][Windows-11-24h2]      | Home/Pro/Enterprise |
| Windows 10 x64 22H2                      | [Latest stable][Windows-10]           | Home/Pro/Enterprise |
| Windows 11 Enterprise LTSC 2024          | [Latest stable][Windows-11-LTSC-2024] | Enterprise          |
| Windows 10 x64 21H2 Enterprise LTSC 2021 | [Latest stable][Windows-10-LTSC-2021] | Enterprise          |
| Windows 10 x64 1809 Enterprise LTSC 2019 | [Latest stable][Windows-10-LTSC-2019] | Enterprise          |

## Скріншоти

### Локалізовані назви UWP-пакетів

![Image](../img/uwpapps.png)

### Завантажте та встановіть будь-який підтримуваний дистрибутив Linux в автоматичному режимі

![Image](../img/WSL.png)

### Інтерактивні тости для запланованих завдань

![Image](https://github.com/farag2/Sophia-Script-for-Windows/raw/master/img/Toasts.png)

## Відео

[Video Tutorial](https://www.youtube.com/watch?v=q_weQifFM58)

[Chris Titus Tech' Review](https://youtu.be/8E6OT_QcHaU?t=370)

[Znorux' Review](https://youtu.be/091SOihvx0k?t=490)

## Як перекласти

* Дізнайтеся мову інтерфейсу Вашої ОС, викликавши `$PSUICulture` в PowerShell
* Створіть папку з назвою Вашої мови інтерфейсу
* Помістіть ваш локалізований файл SophiaScript.psd1 в цю папку.

## Медіа

* [XDA](https://www.xda-developers.com/sophia-script-returns-control-windows-11)
* [4sysops](https://4sysops.com/archives/windows-10-sophia-script-powershell-functions-for-windows-10-fine-tuning-and-automating-routine-configuration-tasks/)
* [gHacks](https://www.ghacks.net/2020/09/27/windows-10-setup-script-has-a-new-name-and-is-now-easier-to-use/)
* [Neowin](https://www.neowin.net/news/this-windows-10-setup-script-lets-you-fine-tune-around-150-functions-for-new-installs)
* [Comss.ru](https://www.comss.ru/page.php?id=8019)
* [Habr](https://habr.com/company/skillfactory/blog/553800)
* [Deskmodder.de](https://www.deskmodder.de/blog/2021/08/07/sophia-script-for-windows-jetzt-fuer-windows-11-und-10/)
* [PCsoleil Informatique](https://www.pcsoleil.fr/successeur-de-win10-initial-setup-script-sophia-script-comment-lutiliser/)
* [Reddit (архівовано)](https://www.reddit.com/r/PowerShell/comments/go2n5v/powershell_script_setup_windows_10/)
  * Написати в [особисті](https://www.reddit.com/user/farag2/)
* [Ru-Board](https://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15)
* [rutracker](https://rutracker.org/forum/viewtopic.php?t=5996011)
* [My Digital Life](https://forums.mydigitallife.net/threads/powershell-windows-10-sophia-script.81675/)

***

## SophiApp 2.0 (C# + WinUI 3)

[SophiApp](https://github.com/Sophia-Community/SophiApp) перебуває в активній розробці. 🚀

![Image](https://github.com/farag2/Sophia-Script-for-Windows/raw/master/img/0.gif)
![Image](https://github.com/farag2/Sophia-Script-for-Windows/raw/master/img/1.png)
