# Full Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 5.4.0.1 - 06.02.2021

## Windows 10 2004 (20H1)/20H2 (2009)

Diff from v5.4
[5.4...5.4.0.1](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.4...5.4.0.1)

* Fixed UWP apps form not loading.

## 5.4 - 04.02.2021

## Windows 10 2004 (20H1)/20H2 (2009) | LTSC

Diff from v5.3.3
[5.3.3...5.4](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.3.3...5.4)

* Now all archives are being created and uploaded to the release page via [GitHub Actions](https://github.com/farag2/Windows-10-Sophia-Script/blob/master/.github/workflows/Sophia.yml);
  * Thnx to @inv2004
* When running the script using ```.\Sophia.ps1 -Functions "FunctionName1 -Parameter"``` regardless of the functions entered as an argument, the ```Checkings``` function will be executed first, and the ```Refresh``` and ```Errors``` functions will be executed at the end;
* Updated the ```CreateRestorePoint``` function
  * Closed #124
* Updated the ```EnableWSL2``` function
* Code refactoring for the ```ScheduledTasks```, ```WindowsFeatures```, ```WindowsCapabilities``` & ```UninstallUWPApps```
  * The ```WindowsFeatures``` function generates **friendly** Windows features names instead of packages names :rocket:
  * The ```WindowsCapabilities``` function generates **friendly** Windows capabilities names instead of packages names :rocket:
  * The ```UninstallUWPApps``` function generates **friendly** UWP apps names instead of packages names :rocket:
    * Clicking on "Uninstall for all users" dynamically generates UWP apps list for all users and vice versa. Currently works only on PowerShell 5.1 :thinking:
  * Thanks to [iNNOKENTIY21](https://forum.ru-board.com/profile.cgi?action=show&member=iNNOKENTIY21) & @oz-zo
  * Closed #56
* Removed unnecessary ```WSLSwap``` & ```syspin``` functions;
* Updated description;
* Wrapper updated;
* Minor changes. :feelsgood:

## 5.3.3 - 21.01.2021

## Windows 10 2004 (20H1)/20H2 (2009) | LTSC

Diff from v5.3.2
[5.3.2...5.3.3](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.3.2...5.3.3)

* Added the feature to run the script by specifying module functions as parameters
  * If you want to run the specific functions without editing the preset file you can run them as parameters now

  ```powershell
  .\Sophia.ps1 -Functions CreateRestorePoint, "ScheduledTasks -Disable", "WindowsCapabilities -Disable", Refresh
  ```

  * The quotation marks required;
  * Thnx to [YuS 2](https://forum.ru-board.com/profile.cgi?action=show&member=YuS%202) & [iNNOKENTIY21](https://forum.ru-board.com/profile.cgi?action=show&member=iNNOKENTIY21) for spending their time.
* Bugfixed and improved the "WindowsCapabilities" function. Thnx to [cheetoh](https://forums.mydigitallife.net/members/cheetoh.977530)
* There is a bug in KVM with QEMU: enabling the ```DefenderSandbox -Enabled``` function causes VM to freeze up during the loading phase of Windows
  * Read more on #120
* The ```MediaPlayback``` feature in the ```WindowsFeatures``` function is unchecked now by default. Thnx to [Nevals](https://forums.mydigitallife.net/members/nevals.1442013)
  * If you want to leave "Multimedia settings" in the advanced settings of Power Options do not uninstall this feature
* Updated description;
* Minor changes. :feelsgood:

## 5.3.2 - 16.01.2021

## Windows 10 2004 (20H1)/20H2 (2009) | LTSC

Diff from v5.3.1
[5.3.1...5.3.2](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.3.1...5.3.2)

* Updated "TelemetryService" function
  * Renamed into "DiagTrackService";
  * Added "Disable firewall rule for Unified Telemetry Client Outbound Traffic and block connection" feature.
    * Closed #116
    * To do it run manually

    ```powershell
    Get-NetFirewallRule -Group DiagTrack | Set-NetFirewallRule -Enabled False -Action Block
    ```

* Added online checking whether the current module version is the latest;
* Added "Disable Caps Lock" function;
* Swaped "disable"/"enable" arguments in the "AppsLanguageSwitch" function;
* Minor changes. :feelsgood:

## 5.3.1 - 22.12.2020

## Windows 10 2004 (20H1)/20H2 (2009)

Diff from v5.3
[5.3...5.3.1](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.3...5.3.1)

* Also uploaded the updated LTSC module version up to 5.0;
* Added a new logo on the main page. Logo made by [teahead](https://twitter.com/tea_head_)
* Added [PowerShell 7.1](https://github.com/PowerShell/PowerShell) <img src="https://raw.githubusercontent.com/PowerShell/PowerShell/master/assets/ps_black_64.svg" width="30"> compatibility :trophy:
  * Closed #70;
  * Anyway sometimes pinning shortcuts via syspin do nothing. It's PS Core bug. :thinking:
* Fixed typo causing bug in ```CleanUpTask -Register``` function. Please re-register task;
* Added ```Logging``` function using the ```Start-Transcript``` cmdlet. Commented out by default.
  * To stop logging just close the console or type ```Stop-Transcript```. The log will be being recorded into the script folder
* Added ```AppsLanguageSwitch``` function. Lets use a different input method for each app window. Thanks to [WindR](https://forum.ru-board.com/profile.cgi?action=show&member=WindR)
* Updated the Italian translation. Closed #103. Thanks to @garf02;
* Updated syspin app up to the 0.99.9.1;
* Minor changes. :feelsgood:
* Added the New Year ```easter egg``` to the console title! :hand_over_mouth:

## 5.3 - 12.12.2020

## Windows 10 2004 (20H1)/20H2 (2009)

Diff from v5.2
[5.2...5.3](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.2...5.3)

* Some functions were updated and improved, especially
  * ```ScheduledTasks```,  ```WindowsFeatures```,  ```WindowsCapabilities``` now support arguments to load pop-up dialog box;
  * ```SetUserShellFolderLocation``` gets  ```-Custom``` argument (commented out by default) to select a folder for the location of the user folders manually using a folder browser dialog. Closed #98;
  * Fixed and changed method for saving code for creating the "Windows Cleanup" task in ```CleanUpTask``` function;
    * There won't be any more AV false positives. Better to reregistre task again. Sometimes a toast didn't even load and the task runs forever. LOL
* Updated the ```Sophia.ps1``` preset file. Use the new one;
* Added Spanish localization :es:. Thanks to @AnxoMJ;
* Updated, improved and simplified all localizations. Thanks to all translators;
  * Now available in: :uk: :cn: :de: :fr: :it: :ru: :ukraine: :tr: :es:
* Updated descriptions;
* Closed #101
* Minor changes. :feelsgood:

## 5.2 - 11.11.2020

## Windows 10 2004 (20H1)/2009 (20H2)

Diff from v5.1.1
[5.1.1...5.2](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.1.1...5.2)

* Code refactoring. Thx to [FrankSinatra 🏆]( https://habr.com/ru/users/FrankSinatra) & [iNNOKENTIY21 🏆](http://forum.ru-board.com/profile.cgi?action=show&member=iNNOKENTIY21);
  * Almost all functions were rewritten to accept arguments;
  * e.g. ```DisableTelemetryServices``` and ```EnableTelemetryServices``` are now

```powershell
TelemetryService -Disable
TelemetryService -Enable
```

* Updated the ```Sophia.ps1``` preset file. Use the new one!;
* Added localizations
  * Chinese simplified (#79). Thanks to @JonathanChuyan;
  * Italian (#80). Thanks to @garf02;
  * Turkish (#82). Thanks to @v30xy;
  * French. Thanks to [coleoptere2007](https://forums.mydigitallife.net/members/coleoptere2007.26684);
  * Ukranian. Thanks to **lowlif3**;
  * Now available in: Available in: <img src="https://upload.wikimedia.org/wikipedia/commons/a/ae/Flag_of_the_United_Kingdom.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/f/fa/Flag_of_the_People's_Republic_of_China.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/b/ba/Flag_of_Germany.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/c/c3/Flag_of_France.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/0/03/Flag_of_Italy.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/f/f3/Flag_of_Russia.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/4/49/Flag_of_Ukraine.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/b/b4/Flag_of_Turkey.svg" height="11px"/>
* Updated localizations;
* Closed #81, #83, #84, #85, #86, #87
* Minor changes.

Also guy from [benchtweakgaming.com](https://benchtweakgaming.com/2020/11/12/windows-10-debloat-tool/) created a GUI wrapper for the script. Hope it'll help! 🗡️

## 5.1.1 - 09.10.2020

## Windows 10 2004/2009

Diff from v5.1 (2004/2009)
[5.1...5.1.1](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.1...5.1.1)

* Added the German localization. Thanks to [ERRASoft 🏆](https://forums.mydigitallife.net/members/errasoft.449648/);
* Updated localizations;
* Added manifest file;
* ```EnableWin32LongPaths``` function wasn't enabled as a default one;
* Functions updated
  * ```DisableWindowsErrorReporting```;
  * ```EnableWindowsErrorReporting```;
  * ```DisableScheduledTasks```;
  * ```EnableScheduledTasks```.
* Minor changes.

## 5.1 - 08.10.2020

## Windows 10 2004/2009

Diff from v5.0.1 (2004/2009)
[5.0.1...5.1](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.0.1...5.1)

* The script becomes fully translatable 🏆;
  * The translations are moved to separate files ```Sophia.psd1```;
  * To translate into your language you should
    * Create a folder with the appropriate future localization name;

      ```powershell
      $PSUICulture
      ```

    * Place the translation into this folder without changing the file name (```Sophia.psd1```)
    * Thanks to [FrankSinatra](https://habr.com/ru/users/FrankSinatra/) & [westlife](http://forum.ru-board.com/profile.cgi?action=show&member=westlife) for the tip.
* "DisableSuggestedContent" function renamed into "DisableWhatsNewInWindows";
* "EnableSuggestedContent" function renamed into "EnableWhatsNewInWindows";
* Closed #65, #71, #72 thanks to [westlife](http://forum.ru-board.com/profile.cgi?action=show&member=westlife);
* Functions improved
  * UninstallOneDrive;
  * SetupWSL;
  * DisableBackgroundUWPApps [westlife 🏆](http://forum.ru-board.com/profile.cgi?action=show&member=westlife);
  * DisableReservedStorage.
* Functions simplified
  * RemoveProtectedFolders;
  * RemoveAppsControlledFolder;
  * RemoveDefenderExclusionFolders;
  * RemoveDefenderExclusionFiles.
* The preset file renamed into ```Sophia.ps1```;
* Comments;
* Minor changes.

## 5.0.1 - 25.09.2020

## Windows 10 2004/2009 **only**

Diff from v5.0.0 (2004/2009)
[5.0.0...5.0.1](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.0.0...5.0.1)

* The "SetTempPath" function;
  * Fixed error ```There is a mismatch between the tag specified in the request and the tag present in the reparse point```
* Descriptions;
* Minor changes.

## 5.0 - 24.09.2020

## Windows 10 2004/2009 **only**

* The script has a new name: Windows 10 Sophia Script ❤️
* The Script was rewritten into module (about **270** functions) with a preset file!
  * Now it should be ran via .\Preset.ps1
  * Every tweak in a preset file has its' corresponding function to **restore the default settings**;
  * Create your own preset file!
* Minor changes. No new features.

## 4.6 - 18.08.2020

## Windows 10 2004 | 1903/1909 | LTSC Enterprise 2019

Diff from v4.5.7
[4.5.7...4.6](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.5.7...4.6)

- **Fixed and improved translations and comments**. Closed <https://github.com/farag2/Windows-10-Setup-Script/pull/58> & <https://github.com/farag2/Windows-10-Setup-Script/pull/59>. Thanks a lot to @skycommand for the help with translation;
- Removed the "Group svchost.exe processes" section;
  - To revert to the default changes rub

  ```powershell
  New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control -Name SvcHostSplitThresholdInKB -PropertyType DWord -Value 3670016 -Force

  # Restart required
  ```

- Removed the "Show the "File Explorer" and "Settings" folders on Start" section;
- Updated the "Turn off Delivery Optimization" section;
  - To enable it run

  ```powershell
  New-ItemProperty -Path Registry::HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings -Name DownloadMode -PropertyType DWord -Value 0 -Force
  New-ItemProperty -Path Registry::HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings -Name DownloadModeProvider -PropertyType DWord -Value 8 -Force
  ```

- Updated the "Turn off Windows features" section;
  - The "Microsoft Print to PDF" feature was excluded from disabling;
  - To revert to the proper values run

  ```powershell
  Enable-WindowsOptionalFeature -Online -FeatureName Printing-PrintToPDFServices-Features # -NoRestart
  ```

- Updated the "Change the location of the user folders to %SystemDrive%" section;
  - Added the ```RemoveDesktopINI``` argument to remove ```desktop.ini``` in the old user shell folder;
- Fixed wrong value in "Add the "Extract all" item to Windows Installer (.msi) context menu" section;
  - To revert to the proper values run

  ```powershell
  New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Name MUIVerb -PropertyType String -Value "@shell32.dll,-37514" -Force
  ```

- Updated the "Do not add the "- Shortcut" suffix to the file name of created shortcuts" section;
- Minor changes.

## 4.5.7 - 17.08.2020

## Windows 10 2004 | 1903/1909 | LTSC Enterprise 2019 Versions

Diff from v4.5.6 (2004)
[4.5.6...4.5.7](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.5.6...4.5.7)

- Removed "Turn off per-user services" section;
  - Closed #50 & #52;
  - To revert these services back run

  ```powershell
  New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\PimIndexMaintenanceSvc -Name Start -PropertyType DWord -Value 3 -Force
  Remove-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\PimIndexMaintenanceSvc -Name UserServiceFlags -Force
  New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\UnistoreSvc -Name Start -PropertyType DWord -Value 3 -Force
  Remove-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\UnistoreSvc -Name UserServiceFlags -Force
  New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\UserDataSvc -Name Start -PropertyType DWord -Value 3 -Force
  Remove-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\UserDataSvc -Name UserServiceFlags -Force

  # Restart required
  ```

- Updated "Turn on Windows 10 20H2 new Start style" section;
- Updated "Change %TEMP% environment variable path to the %SystemDrive%\Temp" section;
  - Added prompt for choice;
    - Added symbolic link creation;
  - Closed #51.
    - Create required folder

    ```powershell
    New-Item -Path $env:LOCALAPPDATA\Temp -ItemType Directory -Force
    ```

- Minor changes.

## Windows 10 LTSC Enterprise 2019 Version

- As I was asked many times, released the LTSC version;
- Closed #40 & #39;
- Minor changes.

## 4.5.6 - 03.08.2020

Diff from v4.5.5 (Windows 10 2004)

## Windows 10 2004 | 1903/1909 Version

[4.5.5...4.5.6](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.5.5...4.5.6)

- Added "Turn on Windows 10 20H2 new Start style" section. The new Start style described [here](https://www.windowslatest.com/2020/08/02/windows-10-2004-gets-20h2-features/);
- Added "Install the Windows Subsystem for Linux (WSL)" section;
- Added new package "Microsoft.Photos.MediaEngineDLC" to the $UncheckedAppxPackages variable in "Uninstall UWP apps" section;
- region Edge removed (only for 1903/1909 Version);
- Comments;
- Minor changes.

## Windows 10 LTSC Enterprise 2019 Version

- As I was asked many times, released the LTSC version;
- Closed #40 & #39;
- Minor changes.

## 4.5.5 - 07.07.2020

Diff from v4.5.4
[4.5.4...4.5.5](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.5.4...4.5.5)

- Closed #40 & #39
- Comments;
- Minor changes.

## 4.5.4 - 29.06.2020

Diff from v4.5.3 (Windows 10 2004)
[4.5.3...4.5.4](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.5.3...4.5.4)

- Updated "Turn off Cortana autostarting" section
- Updated "Create "Process Creation" Event Viewer Custom View" section
  - Closed #37
- Removed "Uninstall all Xbox related UWP apps from all accounts" section because it's unnecassary
- Closed #36. Removed sections
  - Show accent color on Start, taskbar, and action center
  - Show accent color on the title bars and window borders
  - Increase taskbar transparency
- Comments;
- Minor changes

## 4.5.3 - 23.06.2020

Diff from v4.5.2 (Windows 10 2004)
[4.5.2...4.5.3](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.5.2...4.5.3)

- Updated help section
- Updated "Turn off Cortana autostarting" section
- Added "Create "Process Creation" Event Viewer Custom View" section
  - For this custom view to function, it is necessary to enable the following sections
    - Turn on events auditing generated when a process is created or starts
    - Include command line in process creation events
  - This feature allows to conveniently track the creation of suspicious processes along with the process command line argument
  - Go to Event Viewer - Custom View - Process Creation
- Minor changes

## 4.5.2 - 19.06.2020

Diff from v4.5.1 (Windows 10 2004)
[4.5.1...4.5.2](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.5.1...4.5.2)

- Removed sections due to Network troubleshooter is unable to start DPS service
  - Stop event trace sessions
  - Turn off the data collectors at the next computer restart
  - To restore Network troubleshooter download attached DiagLog_EN.xml and execute in CMD

  ```cmd
  :: Restart needed
  logman import -name "DiagLog" -xml "PathTo\DiagLog_EN.xml"
  logman start "DiagLog"
  ```

- Updated "Turn on logging for all Windows PowerShell modules" section
  - Fixed typo in registry path key creation
  - To restore execute

  ```powershell
  Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames -Name EnableModuleLogging -Force
  New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging -Name EnableModuleLogging -PropertyType DWord -Value 1 -Force
  ```

- Minor changes

## 4.5.1 - 17.06.2020

Diff from v4.5.0.1 (Windows 10 2004)
[4.5.0.1...4.5.1](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.5.0.1...4.5.1)

- Updated "Unpin all the Start tiles" section
  - Now using another method to unpin all Start tiles
- Updated "Pin the shortcuts to Start" section
  - Updated check for the internet connection

## 4.5.0.1 - 11.06.2020

Diff from v4.5
[4.5...4.5.0.1](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.5...4.5.0.1)

- Updated "Remove Windows capabilities" section
  - Moved Notepad from the $CheckedCapabilities variable to the $ExcludedCapabilities
  - To restore uninstalled Notepad execute

    ```powershell
    Get-WindowsCapability -Online -Name Microsoft.Windows.Notepad* | Add-WindowsCapability -Online -Verbose
    ```

- Updated "Turn on hardware-accelerated GPU scheduling" section
  - Added determining whether an OS is not installed on a virtual machine

## 4.5 - 10.06.2020

- Updated sections
  - Stop event trace sessions;
  - Turn off Windows features;
  - Turn off background apps, except the followings...;
  - Turn off and delete reserved storage after the next update installation;
  - Hide the "Edit with Photos" item from the context menu;
  - Hide the "Create a new video" item from the context menu;
  - Hide the "Edit" item from the images context menu;
  - Remove the "Bitmap image" item from the "New" context menu;
  - Remove the "Rich Text Document" item from the "New" context menu.
- Added sections
  - Turn on automatically save my restartable apps when sign out and restart them after sign in
  - Turn off Cortana autostarting;
  - Turn on hardware-accelerated GPU scheduling.
- Due to Microsoft Edge moved to Chromium rendering engine, the following sections was removed
  - Remove Microsoft Edge shortcut from the Desktop;
  - Do not allow Microsoft Edge to start and load the Start and New Tab page at Windows startup and each time Microsoft Edge is closed;
    - To remove unnecessary key execute

    ```powershell
    Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader -Name AllowTabPreloading -Force
    ```

  - Do not allow Microsoft Edge to pre-launch at Windows startup, when the system is idle, and each time Microsoft Edge is closed;
    - To remove unnecessary key execute unnecessary key execute

    ```powershell
    Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main -Name AllowPrelaunch -Force
    ```

  - Turn off Windows Defender SmartScreen for Microsoft Edge;
    - To remove unnecessary key execute

    ```powershell
    $edge = (Get-AppxPackage -Name Microsoft.MicrosoftEdge).PackageFamilyName
    Remove-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\PhishingFilter" -Name EnabledV9 -Force
    ```

  - Turn off creation of an Edge shortcut on the desktop for each user profile;
    - To remove unnecessary key execute

    ```powershell
    Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name DisableEdgeDesktopShortcutCreation -Force
    ```

- In Windows 10 the "Turn on automatic recommended troubleshooting and tell when problems get fixed" feature was renamed into "Run troubleshooters automatically, then notify"
- Comments;
- Minor changes.

## 4.4.1 - 02.06.2020

Diff from v4.4
[4.4...4.4.1](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.4...4.4.1)

- Comments;
- Minor changes.

## 4.4 - 02.06.2020

Diff from v4.3.0.1
[4.3.0.1...4.4](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.3.0.1...4.4)

- Updated links in the comment-based help section;
- Updated "Increase taskbar transparency" section
  - Removed "ForceEffectMode" key, that blocked Windows 10 transparency effects
  - To remove unnecessary key, execute

  ```powershell
  # Restart needed
  Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\Dwm -Name ForceEffectMode -Force
  ```

- Updated "Change location of the user folders" section
  - Added comment-based section;
  - Added the ability to skip (#25)
- Updated "Uninstall UWP apps" section
  - Added "Uninstall for All Users" button to the form (unchecked by default) (@oz-zo) to uninstall UWP apps from all account
- Add the "Run as different user" item to the .exe files types context menu
  - Removed unnecessary keys
- Comments;
- Minor changes.

## 4.3.0.1 - 23.05.2020

Diff from v4.2.1
[4.2.1...4.3.0.1](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.2.1...4.3.0.1)

- Fixed bug in "Show accent color on Start, taskbar, and action center" section;
- The "Change location of the user folders" section was rewritten into interactive menu using up/down arrows and Enter key to make a selection (menu by [MaxKozlov](https://qna.habr.com/user/MaxKozlov))
  - A user will be prompted to select the drive letter where the user folders will be moved programmatically
  - Files will not be moved. Do it manually
  - [Video](https://www.youtube.com/watch?v=cjyi9nX8sFA)
- The task "Update cleanup" in the Task Scheduler renamed into "Windows Cleanup";
- Comments;
- Minor changes;
- Thanks [YuS_2](http://forum.ru-board.com/profile.cgi?action=show&member=YuS_2) and [westlife](http://forum.ru-board.com/profile.cgi?action=show&member=westlife) for the tips.

## 4.2.1 - 16.05.2020

- Now the form for removing capabilities and UWP apps will not be initialized if there are no elements for removal;
- Added for the all tasks in the Task Scheduler a description displayed in the "Description" section;
- Fixed bug in "Include command line in process creation events" section
- Minor changes;
- Thanks [4r0](http://forum.ru-board.com/profile.cgi?action=show&member=4r0) for found bugs.

## 4.2 - 12.05.2020

- Now the script will not be executed by PowerShell ISE;
- Moved from the "Read-Host" cmdlet to $Host.UI.PromptForChoice();
- Updated "Create a task in the Task Scheduler to start Windows cleaning up";
  - A [toast notification](https://docs.microsoft.com/ru-ru/windows/uwp/design/shell/tiles-and-notifications/adaptive-interactive-toasts) will be activated before starting cleaning up;
  - Now cleanmgr.exe window starts minimized;
  - Now using DISM to clean up unused Windows updates instead of cleanmgr.exe

```cmd
DISM.exe /Online /English /Cleanup-Image /StartComponentCleanup /NoRestart
```

- Minor changes;
- Thanks [westlife](http://forum.ru-board.com/profile.cgi?action=show&member=westlife) for the tips.

## 4.1 - 03.05.2020

- The "Turn off Windows features" and "Uninstall all UWP apps from all accounts" sections moved from CLI to GUI!
- WPF form made by [oz-zo](https://github.com/oz-zo), fixes by [westlife](http://forum.ru-board.com/profile.cgi?action=show&member=westlife)
- Minor changes.

## 4.0.34 - 28.04.2020

- Added the "Create a restore point" section (#14 );
- Updated "Include command line in process creation events" section;
- Minor changes;
- Comments.

## 4.0.33 - 24.04.2020

- The "Set "High performance" in graphics performance preference for apps" section moved from CLI to GUI
- Minor changes;
- Comments.

## 4.0.32 - 20.04.2020

- Comments;
- Added Internet connection test in "Pin the shortcuts to Start" section to ensure syspin.exe will be downloaded from GitHub. Anyway it can be loaded locally;
- The following sections transferred from CLI to GUI
  - Turn on Controlled folder access and add protected folders;
  - Allow an app through Controlled folder access;
  - Add exclusion folder from Microsoft Defender Antivirus scanning;
  - Add exclusion file from Windows Defender Antivirus scanning.
- Minor changes.

## 4.0.31 - 10.04.2020

- Improved "Uninstall OneDrive" section;
  - Now it takes into account whether user signed in to OnedDrive;
- Added Xbox related apps to the exclusion list in "Uninstall all UWP apps from all accounts, except the followings..." section;
- Added "Uninstall all Xbox related UWP apps from all accounts" section;
- Comments;
- Minor changes.

## 4.0.30 - 08.04.2020

- Improved "Uninstall OneDrive" section. Thanks [westlife](http://forum.ru-board.com/profile.cgi?action=show&member=westlife);
- Added "Open Microsoft Store "HEVC Video Extensions from Device Manufacturer" page" section
- Comments;
- Minor changes.

## 4.0.29 - 05.04.2020

- Totally rewritten "Uninstall OneDrive" section
- "Turn off diagnostics tracking scheduled tasks" section
  - Now the "FODCleanupTask" task, related to Windows Hello, does not turn off if device is a laptop
- "Remove Windows capabilities" section
  - Now the "Hello.Face*" сapabilities, related to Windows Hello, does not removed if device is a laptop
- "Save screenshots by pressing Win+PrtScr to the Desktop" section
- "Set "High performance" in graphics performance preference for apps" section
- "Uninstall all UWP apps from all accounts" section
  - Now using "-Verbose" instead of "Write-Progress";
  - Added "Realtek Audio Console" app to the exclusion
- Comments;
- Minor changes.

## 4.0.28 - 20.03.2020

- Added "Do not show sync provider notification" section;
- "Save screenshots by pressing Win+PrtScr to the Desktop" section. To return the original value execute

  ```powershell
  Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{b7bede81-df94-4682-a7d8-57a52620b86f}" -Name RelativePath -Type String -Value Screenshots -Force
  ```

- Removed "Uninstall all provisioned UWP apps from System account, except the followings..." section
  - Using the "-AllUsers" key, applications were already deleted from all accounts
- Fixed all en dashes (0x2013). Thanks to [YuS_2](http://forum.ru-board.com/profile.cgi?action=show&member=YuS_2);
- Comments;
- Minor changes.

## 4.0.27 - 18.03.2020

- "Uninstall OneDrive" section
  - Now even after restarting File Explorer your opened folders will be restored
- "Uninstall all UWP apps from all accounts, except the followings..." section
- "Uninstall all provisioned UWP apps from System account, except the followings..." section
  - Now displays progress bar while uninstalling
- Deleted "Checking whether the script was saved in UTF-8 with BOM encoding if it runs locally" section
  - There is [no way](https://github.com/MicrosoftDocs/PowerShell-Docs/blob/staging/reference/docs-conceptual/components/vscode/understanding-file-encoding.md#common-causes-of-encoding-issues) for PowerShell to automatically determine the file encoding
  - Anyway this code checks the encoding

  ```powershell
  if ($PSCommandPath)
  {
       $bytes = Get-Content -Path $PSCommandPath -Encoding Byte -Raw
       # https://tools.ietf.org/html/rfc3629#section-6
       if ($bytes[0] -ne 239 -and $bytes[1] -ne 187 -and $bytes[2] -ne 191)
       {
            Write-Warning -Message "The script wasn't saved in `"UTF-8 with BOM`" encoding"
            break
       }
  }
  ```

- Comments
- Minor changes.

## 4.0.26 - 16.03.2020

- Do not allow apps to use advertising ID. To delete unnecessary key execute

  ```powershell
  Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -Force
  ```

- Turn on acrylic taskbar transparency;
- Added "Show me the Windows welcome experiences after updates and occasionally when I sign in to highlight what's new and suggested" section;
- Added "Check for updates for UWP apps" section;
- Added "Do not suggest ways I can finish setting up my device to get the most out of Windows" section;
- Comments;
- Minor changes.

## 4.0.25 - 13.03.2020

- Added F5 pressing simulation to refresh the desktop
- Comments;
- Minor changes.

## 4.0.24 - 11.03.2020

- Turn on recycle bin files delete confirmation
  - Now configuring without using policy. To delete unnecessary key execute

  ```powershell
  Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name ConfirmFileDelete -Force
  ```

- Turn off Delivery Optimization
  - Now using cmdlets. To delete unnecessary key execute

  ```powershell
  Remove-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization -Force
  ```

- Rearranged "Set power management scheme for desktop and laptop" section
- Renamed sections
  - "Turn off hibernate" to "Turn off hibernate for devices, except laptops"
  - "Turn off location for this device" to "Turn off location access for this device"
- Minor changes.

## 4.0.23 - 06.03.2020

- Comments;
- Rewritten "Pin to Start the shortcuts" section;
  - Now using [syspin.exe](http://www.technosys.net/products/utils/pintotaskbar) to pin shortcuts
  - Hash (SHA256): 6967E7A3C2251812DD6B3FA0265FB7B61AADC568F562A98C50C345908C6E827
  - Shorcuts pinned by default:
    - Control Panel;
    - Devices and Printers;
    - Command Prompt.
- Minor changes.

## 4.0.22 - 03.03.2020

- Added Comment-Based Help;
- Fixed bug in a task to clear the $env:SystemRoot\SoftwareDistribution\Download folder;
- Minor changes.

## 4.0.21 - 25.02.2020

- Removed "Use Unicode UTF-8 for worldwide language support (beta)" section due to instability. To recover execute

  ```powershell
  # Open Administrative Tab in Region
  cmd.exe --% /c control intl.cpl,,1
  # Change system locale
  # Uncheck "Beta: Use Unicode UTF-8 for worldwide language support"
  # Restart PC
  ```

- Minor changes.

## 4.0.20 - 21.02.2020

- Removed "Let Windows track app launches to improve Start menu and search results" section. To recover execute

  ```powershell
  Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Start_TrackProgs -Force
  ```

- Removed "Turn off Windows Game Recording and Broadcasting" section. To recover execute

  ```powershell
  Remove-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR -Force
  ```

- Removed "Turn off Game Mode" section. To recover execute

  ```powershell
  Remove-ItemProperty -Path HKCU:\Software\Microsoft\GameBar -Name AllowAutoGameMode -Force
  ```

- Removed "Remove "Previous Versions" from file context menu" section. To recover execute

  ```powershell
  Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force
  ```

- Removed "Turn off "The Windows Filtering Platform has blocked a connection" message in "Windows Logs/Security"" section. To recover execute

  ```cmd
  auditpol /set /subcategory:"{0CCE9226-69AE-11D9-BED3-505054503030}" /success:enable /failure:enable
  ```

- Added
  - "Use Unicode UTF-8 for worldwide language support (beta)";
  - "Turn on logging for all Windows PowerShell modules";
  - "Turn on logging of all PowerShell script input to the Microsoft-Windows-PowerShell/Operational event log";
  - "Turn on events auditing generated when a process is created or starts".
- Comments
- Minor changes.

## 4.0.19 - 17.02.2020

- Uploaded file with UTF-8 with BOM encoding by default;
- Added "Checking the file encoding if it runs locally" section;
- Minor changes.

## 4.0.18 - 11.02.2020

- Fixed typo in "Unpin all Start menu tiles section;
- Updated "Uninstall OneDrive" section;
- Minor changes.

## 4.0.17 - 10.02.2020

- Now using "switch" operator in the interactive prompts;
- Comments;
- Minor changes.

## 4.0.16 - 04.02.2020

- Added OS edition detection to add proper value for the "AllowTelemetry" registry key.;
- "Stop event trace sessions" section;
- "Set the operating system diagnostic data level" section;
- "Unpin all Start menu tiles" section;
  - Now it's possible to skip unpinning all Start menu tiles
- Minor changes.

## 4.0.15 - 31.01.2020

- Added "Include command line in progress creation events" section;
- Added "Let track app launches to improve Start menu and search results" section;
- Removed "Do not let track app launches to improve Start menu and search results" section;
- Added "Stop event trace sessions" section;
- Updated "Turn off the data collectors at the next computer restart" section;
- Updated "Turn off diagnostics tracking scheduled tasks" section. Some tasks has been removed from the list. To recover execute

  ```powershell
  $tasks = @(
  "DmClient"
  "DmClientOnScenarioDownload"
  "EnableLicenseAcquisition"
  "GatherNetworkInfo"
  "MNO Metadata Parser"
  "NetworkStateChangeTask"
  "TempSignedLicenseExchange"
  )
  Get-ScheduledTask -TaskName $tasks | Enable-ScheduledTask
  ```

- Comments
- Minor changes.

## 4.0.14 - 15.11.2019

- Comments;
- Minor changes.

## 4.0.13 - 11.11.2019

- Added the detections of the OS bitness and PowerShell session;
- Minor changes.

## 4.0.12 - 08.11.2019

- Sections rearranged
- Comments
- Removed unnecessary "Turn off Cortana" section. To remove the key execute

  ```powershell
  Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force
  ```

- Removed unnecessary "Turn on Retpoline patch against Spectre v2" section;
- Removed unnecessary "Turn on firewall & network protection" section;
- "Enable System Restore" section redone into "Remove Shadow copies (restoration points)"
- Minor changes.

## 4.0.11 - 05.11.2019

"Uninstall UWP apps" section.

## 4.0.10 - 22.10.2019

- Improved "Turn off Windows features" and "Turn off default background apps, except the followings..." sections
- Total runtime reduced by ~ 10 sec.

## 4.0.9 - 21.10.2019

- Ready for Windows 10 November 2019 Update;
- Minor changes.

## 4.0.8 - 11.10.2019

- The "Save screenshots by pressing Win+PrtScr to the Desktop" section  was moved to the "Set location of the "Desktop", "Documents" "Downloads" "Music", "Pictures", and "Videos"" section
  - Fixes saving a screenshot when it was saved in the old desktop folder if the path to the desktop was changed after that.
- Reorganized the "UI & Personalization" directive
- Translations
- Removed unnecessary keys in the "OneDrive" section. To remove them, execute

  ```powershell
  Remove-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive -Force
  Remove-ItemProperty -Path HKCU:\Software\Microsoft\OneDrive -Name DisablePersonalSync -Force
  ```

- Removed "Remove printers" section;
- Added "Sticky Notes" app to the exclusion list of a "Uninstall all UWP apps from all accounts except" section;
- Minor changes.

## 4.0.7 - 08.10.2019

- Added "Lock App" app to the exclusion list of a "Turn off default background apps except" section;
  - Fixes freeze when trying to open a link from lock screen when Windows spotlight enabled. To fix execute:

```powershell
$LockApp = (Get-AppxPackage -AllUsers | Where-Object -FilterScript {$_.PackageFamilyName -like "Microsoft.LockApp*"}).PackageFamilyName
$LockApp = $LockApp.Split(",")[0]
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\$LockApp" -Name * -Force
Write-Host "Restart required"
```

- Removed "Remove printers" section;
- Added "Sticky Notes" app to the exclusion list of a "Uninstall all UWP apps from all accounts except" section;
- Minor changes.

## 4.0.6- 04.10.2019

- Added "Allow an app through Controlled folder access";
- Reorganized the tweaks, dividing into 11 categories:
  - Privacy;
  - UI & Personalization;
  - OneDrive;
  - System;
  - Start menu;
  - Edge;
  - UWP apps;
  - Windows Game Recording;
  - Scheduled tasks;
  - Microsoft Defender;
  - Context menu;
- Minor changes.

## 4.0.5 - 16.09.2019

- Added "Set the encoding to UTF-8 without BOM for the PowerShell session";
  - `ping.exe | Out-Null` used due to output is encoded with the default encoding despite changes (bug in .NET);
- Descriptions;
- Open shortcut to the Command Prompt from Start menu as Administrator;
- Added

  ```powershell
  New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 3 -Force
  ```

command to "Turn on automatic recommended troubleshooting and tell when problems get fixed" section due to the diagnostic data level needs to be set to "Full" in order to work;

- Minor changes.

## 4.0.4 - 09.09.2019

- Added "#Requires -RunAsAdministrator" statement;
- Removed all diagnostics tracking services except "DiagTrack";

 ```powershell
Get-Service -Name DusmSvc | Set-Service -StartupType Automatic
Get-Service -Name SSDPSRV | Set-Service -StartupType Manual
Get-Service -Name DusmSvc, SSDPSRV | Start-Service
 ```

- Added check whether the PC is a work station when applying the patch against Spectre v2;
- Added calculator to exceptions for uninstalling UWP applications;
- Added forced focus on the file open dialog;
- Minor changes.

## 4.0.3 - 02.09.2019

Removed Get-ResolvedPath function from script due to lack of need;
Fixed typo in "Show Task Manager details" section.

## 4.0.2 - 31.08.2019

Removed CDPSvc service from list due to Night ligth doesn't start.
Revert service backTurn the service back on:

```powershell
Get-Service -Name CDPSvc | Set-Service -StartupType Automatic
Get-Service -Name CDPSvc | Start-Service
```

## 4.0.1 - 29.08.2019

Fixed loop in "Set "High performance" in graphics performance preference for apps"

## 4.0.0 - 20.08.2019

- Turn off diagnostics tracking services,
- Uninstall all UWP apps from all accounts except,
- Turn off diagnostics tracking scheduled tasks;
  - The foreach instruction is no longer used;
  - Increased processing speed
- Import Start menu layout from pre-saved reg file;
  - Now it's possible to select a file to import through OpenFileDialog
- Turn on Windows Sandbox;
  - Changed the method for determining if a Hyper-V service is enabled
- Fixed typo in "Turn on Windows Sandbox"
- Minor changes.
