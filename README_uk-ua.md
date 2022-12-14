<div align="right">
  This page also in:
  <a title="English" href="README.md"><img src="https://upload.wikimedia.org/wikipedia/commons/a/ae/Flag_of_the_United_Kingdom.svg" height="11px"/></a>
</div>

# Sophia Script для Windows

<img src="./img/Sophia.png" alt="Sophia Script" width='350' align="right">

<img src="https://upload.wikimedia.org/wikipedia/commons/0/05/Windows_10_Logo.svg" height="30px"/> &emsp; <img src="https://upload.wikimedia.org/wikipedia/commons/e/e6/Windows_11_logo.svg" height="30px"/>

<p align="left">
  <a href="https://github.com/farag2/Sophia-Script-for-Windows/actions"><img src="https://img.shields.io/github/workflow/status/farag2/Sophia-Script-for-Windows/Build?label=GitHub%20Actions&logo=GitHub"></a>
  <img src="https://img.shields.io/badge/PowerShell%205.1%20&%207.3-Ready-blue.svg?color=5391FE&style=flat&logo=powershell">

  <a href="https://github.com/farag2/Sophia-Script-for-Windows/releases"><img src="https://img.shields.io/github/v/release/farag2/Sophia-Script-for-Windows">
  </a><a href="https://github.com/farag2/Sophia-Script-for-Windows"><img src="https://img.shields.io/endpoint?url=https://gist.githubusercontent.com/farag2/9852d6b9569a91bf69ceba8a94cc97f4/raw/0ab9790ab7ca11c7598ea469edf36cda05a1e7b1/SophiaScript.json"></a>

  <a href="https://github.com/farag2/Sophia-Script-for-Windows/releases"><img src="https://img.shields.io/github/downloads/farag2/Sophia-Script-for-Windows/total?label=downloads%20%28since%20May%202020%29"></a>

  <a href="https://twitter.com/tea_head_"><img src="https://img.shields.io/badge/Logo%20by-teahead-blue?style=flat&logo=Twitter"></a>
  <img src="https://img.shields.io/badge/Made%20with-149ce2.svg?color=149ce2"><img src="https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/img/heart.svg" height="17px"/>

  [telegram-news-badge]: https://img.shields.io/badge/Sophia%20News-Telegram-blue?style=flat&logo=Telegram
  [telegram-news]: https://t.me/sophianews
  [telegram-group]: https://t.me/sophia_chat
  [telegram-group-badge]: https://img.shields.io/badge/Sophia%20Chat-Telegram-blue?style=flat&logo=Telegram

  [![Telegram][telegram-news-badge]][telegram-news]
  [![Telegram][telegram-group-badge]][telegram-group]

  [discord-news-badge]: https://discordapp.com/api/guilds/1006179075263561779/widget.png?style=shield
  [discord-link]: https://discord.gg/sSryhaEv79
  [![Discord][discord-news-badge]][discord-link]
</p>

<p align="left">
  <img src="https://upload.wikimedia.org/wikipedia/commons/a/ae/Flag_of_the_United_Kingdom.svg" height="20px"/>
  &nbsp;
  <img src="https://upload.wikimedia.org/wikipedia/commons/f/fa/Flag_of_the_People's_Republic_of_China.svg" height="20px"/>
  &nbsp;
  <img src="https://upload.wikimedia.org/wikipedia/commons/b/ba/Flag_of_Germany.svg" height="20px"/>
  &nbsp;
  <img src="https://upload.wikimedia.org/wikipedia/commons/c/c3/Flag_of_France.svg" height="20px"/>
  &nbsp;
  <img src="https://upload.wikimedia.org/wikipedia/commons/0/03/Flag_of_Italy.svg" height="20px"/>
  &nbsp;
  <img src="https://upload.wikimedia.org/wikipedia/commons/f/f3/Flag_of_Russia.svg" height="20px"/>
  &nbsp;
  <img src="https://upload.wikimedia.org/wikipedia/commons/4/49/Flag_of_Ukraine.svg" height="20px"/>
  &nbsp;
  <img src="https://upload.wikimedia.org/wikipedia/commons/b/b4/Flag_of_Turkey.svg" height="20px"/>
  &nbsp;
  <img src="https://upload.wikimedia.org/wikipedia/commons/9/9a/Flag_of_Spain.svg" height="20px"/>
  &nbsp;
  <img src="https://upload.wikimedia.org/wikipedia/commons/5/5c/Flag_of_Portugal.svg" height="20px"/>
  &nbsp;
  <img src="https://upload.wikimedia.org/wikipedia/commons/c/c1/Flag_of_Hungary.svg" height="20px"/>
  &nbsp;
  <img src="https://upload.wikimedia.org/wikipedia/commons/1/12/Flag_of_Poland.svg" height="20px"/>
</p>

***

<a href="https://github.com/farag2/Sophia-Script-for-Windows/releases/latest"><img src="https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/img/SSdownloadbutton.svg" width=220px height=55px></a>

***

<p align="center">
 &bull;
 <a href="#пожертвування">Пожертвування</a>
 &bull;
 <a href="#системні-вимоги">Системні вимоги</a>
 &bull;
 <a href="#скріншоти">Скріншоти</a>
 &bull;
 <a href="#відео">Відео</a>
 &bull;
 <a href="#ключові-особливості">Ключові особливості</a>
 &bull;
 <a href="#як-користуватися">Як користуватися</a>
 &bull;
 <a href="#як-перекласти">Як перекласти</a>
 &bull;
 <a href="#sophiapp-community-edition-c--wpf">SophiApp</a>
 &bull;
 <a href="https://github.com/farag2/Sophia-Script-for-Windows/blob/master/CHANGELOG.md">Changelog</a>
</p>

## Про Sophia Script

Sophia Script для Windows - найбільший модуль PowerShell на `GitHub` для тонкого налаштування і автоматизації рутинних завдань в `Windows 10` і `Windows 11`

## Перед запуском

> **Note**: У зв'язку з тим, що скрипт містить більше **150** функцій з різними аргументами, необхідно уважно прочитати весь **Sophia.ps1** і **закоментувати/розкоментувати** ті функції, які Ви бажаєте/не бажаєте, щоб виконувалися (без необхідності редагування коду), або скористатися [Wrapper](https://github.com/farag2/Sophia-Script-for-Windows#davids-sophia-script-wrapper). Кожна зміна у файлі налаштувань має відповідну функцію для **відновлення налаштувань за замовчуванням**. Запускати скрипт найкраще на свіжій установці, оскільки запуск на **неправильно** налаштованій системі може призвести до виникнення помилок.

## Пожертвування

<a href="https://yoomoney.ru/to/4100116615568835"><img src="https://yoomoney.ru/i/shop/iomoney_logo_color_example.png" width=220px height=46px align="left">
</a><a href="https://ko-fi.com/farag"><img src="https://www.ko-fi.com/img/githubbutton_sm.svg" width=220px height=46px align="left"></a>

| ![ko-fi](https://img.shields.io/badge/tether-168363?style=for-the-badge&logo=tether&logoColor=white) |
|:----------------------------------------------------------------------------------------------------:|
|                                         USDT (TRC20)                                                 |
|                             `TQtMjdocUWbKAeg1kLtB4ApjAVHt1v8Rtf`                                     |

## System Requirements

|                Версія                | Маркетингова назва  |   Збіркa    | Архітектура |       Видання       |
|:-------------------------------------|--------------------:|:-----------:|:-----------:|:-------------------:|
| Windows 11 Insider Preview 23H2      | 2023 Update         | 22509+      |             | Home/Pro/Enterprise |
| Windows 11 22H2                      | 2022 Update         | 22621       |             | Home/Pro/Enterprise |
| Windows 11 21H2                      |                     | 22000.739+  |             | Home/Pro/Enterprise |
| Windows 10 22H2                      | 2022 Update         | 19045.2006+ |     x64     | Home/Pro/Enterprise |
| Windows 10 21H2                      | October 2021 Update | 19044.1706+ |     x64     | Home/Pro/Enterprise |
| Windows 10 21H2 Enterprise LTSC 2021 | October 2021 Update | 19044.1706+ |     x64     | Enterprise          |
| Windows 10 1809 Enterprise LTSC 2019 | October 2018 Update | 17763.3046+ |     x64     | Enterprise          |

## Скріншоти

### Автодоповнення <kbd>TAB</kbd>. Детальніше [тут](#як-запустити-певну-функціюї)

![Image](./img/Autocomplete.gif)

### Програмна зміна розташування папок користувача за допомогою інтерактивного меню

![Image](https://i.imgur.com/gJFAEOk.png)

### Локалізовані назви UWP-пакетів

![Image](https://i.imgur.com/xeiBbes.png) ![Image](https://i.imgur.com/0zj0h2S.png)

### Локалізовані назви функцій Windows

![Image](https://i.imgur.com/xlMR2mz.png) ![Image](https://i.imgur.com/yl9j9Vt.png)

### Завантажте та встановіть будь-який підтримуваний дистрибутив Linux в автоматичному режимі

![Image](https://i.imgur.com/j2KLZm0.png)

### Інтерактивні тости для запланованих завдань

![Image](https://github.com/farag2/Sophia-Script-for-Windows/raw/master/img/Toasts.png)

### @BenchTweakGaming Sophia Script Wrapper

![Wrapper](https://i.imgur.com/x0W7zqm.png)

## Відео

[![YT](https://img.youtube.com/vi/q_weQifFM58/0.jpg)](https://www.youtube.com/watch?v=q_weQifFM58)

[![YT](https://img.youtube.com/vi/8E6OT_QcHaU/1.jpg)](https://youtu.be/8E6OT_QcHaU?t=370) [![YT](https://img.youtube.com/vi/091SOihvx0k/1.jpg)](https://youtu.be/091SOihvx0k?t=490)

## Ключові особливості

* Налаштування конфіденційності і телеметрії;
* Активація DNS-over-HTTPS для IPv4;
* Вимкнення запланованих завдань з відстеження зі спливаючою формою, написаною на [WPF](#скріншоти);
* Налаштування інтерфейсу і персоналізація;
* "Правильне" видалення OneDrive;
* Інтерактивні [підказки](#програмна-зміна-розташування-папок-користувача-за-допомогою-інтерактивного-меню);
* <kbd>TAB</kbd> [доповнення](#автодоповнення-tab-детальніше-тут) для функцій та їх аргументів (якщо використовується файл Functions.ps1);
* Зміна шляху до змінної середовища %TEMP% на %SystemDrive%\Temp;
* Зміна розташування користувацьких папок програмно (без переміщення користувацьких файлів) в інтерактивному меню за допомогою стрілок для вибору диска
  * "Робочий стіл"
  * "Документи"
  * "Завантаження"
  * "Музика"
  * "Зображення"
  * "Відео"
* Встановлення безкоштовних (світлий та темний) курсорів "Windows 11 Cursors Concept v2" від [Jepri Creations](https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356) на льоту;
* Видалення UWP-додатків, що відображають назви пакетів;
  * Динамічна генерація списку встановлених UWP-додатків
* Відновлення видалених за замовчуванням UWP-додатків для поточного користувача з відображенням [локалізованих](#локалізовані-назви-uwp-пакетів) назв пакетів;

* <kbd>TAB</kbd> [автодоповнення](#автодоповнення-tab-детальніше-тут) для функції та її аргументів шляхом введення перших літер;
* Вимкнення функцій Windows для відображення дружніх назв пакетів у спливаючій формі, написаній на [WPF](#скріншоти);
* Видалення можливостей Windows відображати дружні назви пакетів у спливаючій формі, написаній на [WPF](#скріншоти);
* Завантаження та встановлення [HEVC Video Extensions від виробника пристрою](https://www.microsoft.com/p/hevc-video-extensions-from-device-manufacturer/9n4wgh0z6vhq) для відкриття форматів .heic та .heif;
* Реєстрація програми, розрахунок хешу та встановлення за замовчуванням для певного розширення без спливаючого вікна "Як ви хочете відкрити це" за допомогою спеціальної [функції](https://github.com/DanysysTeam/PS-SFTA);
* Встановлення будь-якого підтримуваного дистрибутива Linux для WSL з відображенням дружніх назв дистрибутивів у спливаючій формі, написаній на [WPF](#скріншоти);
* Створення запланованих завдань `Очищення Windows` та `Повідомлення про очищення Windows` для очищення Windows від невикористовуваних файлів та оновлень;
  * Буде відображено сповіщення про інтерактивний тост, де ви можете вибрати сплячий режим, запустити завдання очищення або [відхилити](#інтерактивні-тости-для-запланованих-завдань)
* Створення завдання в Планувальнику завдань для очищення
  * `%SystemRoot%\SoftwareDistribution\Download`
  * `%TEMP%`
* Закріплення ярликів в Пуск через чистий PowerShell
  * Три ярлики попередньо налаштовані для закріплення: Панель керування, Пристрої та принтери "старого зразка" та Windows PowerShell
* Відкріплення всіх плиток меню "Пуск;
* Ввімкнення Контрольованого доступу до папок та додавання захищених папок за допомогою діалогового меню;
* Додавання папки виключення з перевірки антивірусом Microsoft Defender за допомогою діалогового меню;
* Додавання файлу виключення з перевірки антивірусу Microsoft Defender за допомогою діалогового меню;
* Оновлення значків робочого столу, змінних середовища і панелі завдань без перезапуску Провідника;
* Налаштування безпеки Windows;
* Ще багато "глибоких" налаштувань Файлового Провідника та контекстного меню.

## Як користуватися

* Виберіть відповідну версію скрипта для Вашої `Windows`;
* Завантажте [актуальну версію](https://github.com/farag2/Sophia-Script-for-Windows/releases/latest);
* Розпакуйте архів;
* Відкрийте папку розпакованого архіву;
* Перегляньте файл `Sophia.ps1` для налаштування функцій, які потрібно запустити;
  * Помістіть символ "#" перед функцією, якщо ви не бажаєте, щоб вона виконувалась.
  * Приберіть символ "#" перед функцією, якщо ви бажаєте, щоб вона виконувалась.
* В `Windows 10` натисніть `Файл` у Провіднику, наведіть курсор на `Запустити Windows PowerShell`, і виберіть `Запустити Windows PowerShell від імені адміністратора` [(як це зробити зі скріншотами)](https://www.howtogeek.com/662611/9-ways-to-open-powershell-in-windows-10/)
* В `Windows 11` натисніть правою кнопкою миші на <kbd>Windows</kbd> іконку і виберіть `Термінал (Адміністратор)`. Потім змініть поточне розташування

  ```powershell
  Set-Location -Path "Path\To\Sophia\Folder"
  ```

* Встановіть політику виконання, щоб запускати сценарії тільки в поточному сеансі PowerShell

  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
  ```

* Введіть `.\Sophia.ps1` <kbd>Enter</kbd> щоб запустити налаштований файл.

## Як використовувати Wrapper

* Завантажте та розпакуйте архів;
* Запустіть `SophiaScriptWrapper.exe` та імпортуйте Sophia.ps1;
  * Wrapper має рендеринг інтерфейсу в реальному часі;
* Налаштуйте кожну функцію;
* Відкрийте вкладку `Console Output` і натисніть `Run PowerShell`.

***

### Як запустити певну функцію(ї)

Для запуску певної функції(й) [dot source](https://docs.microsoft.com/ru-ru/powershell/module/microsoft.powershell.core/about/about_operators#dot-sourcing-operator) необхідно запустити файл `Functions.ps1`:

```powershell
# З крапкою на початку
. .\Functions.ps1
```

* Тепер можна зробити так (лапки обов'язкові)

```powershell
Sophia -Functions<kbd>TAB</kbd>
Sophia -Functions temp<kbd>TAB</kbd>
Sophia -Functions unin<kbd>TAB</kbd>
Sophia -Functions uwp<kbd>TAB</kbd>
Sophia -Functions "DiagTrackService -Disable", "DiagnosticDataLevel -Minimal", UninstallUWPApps

UninstallUWPApps, "PinToStart -UnpinAll"
```

Або використовуйте формат старого зразка без автозаповнення функцій TAB (лапки обов'язкові)

```powershell
.\Sophia.ps1 -Functions CreateRestorePoint, "ScheduledTasks -Disable", "WindowsCapabilities -Uninstall"
```

***

## Як завантажити Sophia Script через PowerShell

* Завантажте актуальний архів Sophia Script, викликавши (`також не від імені адміністратора`) в PowerShell

```powershell
irm script.sophi.app -useb | iex
```

* Команда завантажить і розпакує останній архів Sophia Script (`без запуску`) відповідно до того, під якою версією Windows і PowerShell він запускається. Якщо запустити її, наприклад, в Windows 11 через PowerShell 5.1, вона завантажить Sophia Script для `Windows 11 PowerShell 5.1`.

## Як перекласти

* Дізнайтеся мову інтерфейсу Вашої ОС, викликавши `$PSUICulture` в PowerShell;
* Створіть папку з назвою Вашої мови інтерфейсу;
* Помістіть ваш локалізований файл Sophia.psd1 в цю папку.

## Медіа

* [![Discord](https://discordapp.com/api/guilds/1006179075263561779/widget.png?style=shield)](https://discord.gg/sSryhaEv79)
* [Телеграм-група для обговорення](https://t.me/sophia_chat)
* [Telegram канал](https://t.me/sophianews)
* [Ru-Board](https://forum.ru-board.com/topic.cgi?forum=62&topic=30617#15)
* [rutracker](https://rutracker.org/forum/viewtopic.php?t=5996011)
* [My Digital Life](https://forums.mydigitallife.net/threads/powershell-windows-10-sophia-script.81675/)
* [4sysops](https://4sysops.com/archives/windows-10-sophia-script-powershell-functions-for-windows-10-fine-tuning-and-automating-routine-configuration-tasks/)
* [gHacks Technology News](https://www.ghacks.net/2020/09/27/windows-10-setup-script-has-a-new-name-and-is-now-easier-to-use/)
* [Neowin: Tech News, Reviews & Betas](https://www.neowin.net/news/this-windows-10-setup-script-lets-you-fine-tune-around-150-functions-for-new-installs)
* [Comss.ru](https://www.comss.ru/page.php?id=8019)
* [Habr](https://habr.com/company/skillfactory/blog/553800)
* [Deskmodder.d](https://www.deskmodder.de/blog/2021/08/07/sophia-script-for-windows-jetzt-fuer-windows-11-und-10/)
* [PCsoleil Informatique](https://www.pcsoleil.fr/successeur-de-win10-initial-setup-script-sophia-script-comment-lutiliser/)
* [Reddit (archived)](https://www.reddit.com/r/PowerShell/comments/go2n5v/powershell_script_setup_windows_10/)
  * Написати в [особисті](https://www.reddit.com/user/farag2/)

***

## SophiApp Community Edition (C# + WPF)

[SophiApp](https://github.com/Sophia-Community/SophiApp) в активній розробці 🚀

![Image](https://github.com/Sophia-Community/SophiApp/raw/master/img/0.gif)
![Image](https://github.com/Sophia-Community/SophiApp/raw/master/img/1.png)
