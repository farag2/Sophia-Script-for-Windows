# Full Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 5.16.4 | 6.4.4 — 01.04.2023

* Fixes for #466, #472, #470, and #469
* Fixed a bug in Set-Association function when a used Desktop context menu item was accidentally removed;
  * Thanks to @lowl1f3.

## 5.16.3 | 6.4.3 — 28.03.2023

* Improved `Checks`;
  * Expanded the list of harmful tweakers, trojans and other unwanted apps blocking the script running;
  * Added Microsoft Edge installation if it was removed by harmful tweakers. [WebView2 Runtime](https://helpdeskgeek.com/help-desk/what-is-microsoft-edge-webview2-runtime-and-how-to-reduce-cpu-usage/) is a mandatory Windows component.
* Minor changes and improvements.

## 5.16.2 | 6.4.2 — 20.03.2023

* Added `LocalSecurityAuthority` function to prevent code injection (for Windows 11 22H2 only);
  * <https://learn.microsoft.com/en-us/windows-server/security/credentials-protection-and-management/configuring-additional-lsa-protection>
* Improved `Checks` having expanded the list of blocked harmful tweakers;
* Fixed `ThumbnailCacheRemoval` function;
* Removed `SnapAssistFlyout` function;
* Minor changes.

### Wrapper 2.6.4

* Minor changes.

## 5.16.1 | 6.4.1 — 14.03.2023

* Code refactoring;
* Fixed a bug in `ShowMenu` function when Windows Terminal console was overbuffered that broke interractive ShowMenu;
  * Big thanks to [iNNOKENTIY21](https://forum.ru-board.com/profile.cgi?action=show&member=iNNOKENTIY21);
  * <https://github.com/microsoft/terminal/issues/14992>
* Fixed `IPv6Component` by switching to <https://ipify.org>
* Removed `CheckUWPAppsUpdates` function and intergrated into code;
* Renamed `SetUserShellFolderLocation` function into `Set-UserShellFolderLocation`;
* Many small changes and improvements.

## 5.16.0 | 6.4.0 — 08.03.2023

* Dropped support for `Windows 11 22000` & `Windows 10 21H2`;
  * If you run the script on `Windows 11 22000` you will silently download and run [Windows 11 Installation Assistant](https://www.microsoft.com/software-download/windows11), then download the [PC Health Check app](https://support.microsoft.com/en-us/windows/how-to-use-the-pc-health-check-app-9c8abd9b-03ba-4e67-81ef-36f37caa7844) and expand it without installation to prepare for upgrading.
* `CleanupTask`, `SoftwareDistributionTask`, `TempTask` re-written;
  * Now all scheduled tasks respect `Focus Assist` mode and won't interrupt while you playing games or watching fullscreen videos with any notification toasts or powershell.exe pop-ups
  * Uses the [FocusAssistLib.cs](https://github.com/DCourtel/Windows_10_Focus_Assist/blob/master/FocusAssistLibrary/FocusAssistLib.cs) code from @DCourtel!
  * <https://redplait.blogspot.com/2018/07/wnf-ids-from-perfntcdll-adk-version.html>
  * **I strongly recommend you to update them** ([how-to](https://github.com/farag2/Sophia-Script-for-Windows#how-to-run-the-specific-functions))

  ```powershell
  # With dot at the beginning
  . .\Functions.ps1

  Sophia -Functions "CleanupTask -Register", "SoftwareDistributionTask -Register", "TempTask -Register"
  ```

* Improved `WSL-Install`;
* Removed `RunPowerShellShortcut` function as not necessary any more;
* `WSA` function renamed into `Install-WSA` and has no parameters any more;
* Added `TaskbarSearch -SearchIconLabel` new parameter to configure search bar design on the taskbar;
* Added `SATADrivesRemovableMedia` function to prevent all internal SATA drives from showing up as removable media in the taskbar notification area
* #453 closed;
* Many small changes and improvements.

## 5.15.2 | 6.3.2 — 11.02.2023

* Improved and fixed `WSL-Install` function when WSL output was parsed wrong;
  * Thanks to @lowl1f3.
* Improved `OneDrive` function;
* #449 closed;
* Minor changes.

* Wrapper 2.6.3
  * Minor changes.

## 5.15.1 | 6.3.1 — 06.02.2023

* `WSL` function re-written and renamed into `WSL-Install`
  * Now it generates always actual distros supported list by parsing the `wsl --list --online` output;
  * ![img](https://i.imgur.com/Xn5SqxE.png)
  * Thanks to @Inestic, the main [SophiApp](https://github.com/Sophia-Community/SophiApp) developer.
* Improved `OneDrive` function;
* Added `NavigationPaneExpand` function to expand navigation pane to open folder
  * Closes #444.
* Renamed `HEIF` function to `HEVC`;
* Minor changes.

* Wrapper 2.6.2
  * Minor changes.

## 5.15.0 | 6.3.0 — 30.01.2023

* Added new function to prevent Microsoft Edge desktop shortcut creation upon its' update;
  * By default it prevents for all Microsofot Edge channels (with checks if any of them is installed): `PreventEdgeShortcutCreation -Channels Stable, Beta, Dev, Canary`.
* The `IPv6Component` function gets new argument `-PreferIPv4overIPv6` to `Enable the Internet Protocol Version 6 (TCP/IPv6) component for all network connections if your ISP supports it. Prefer IPv4 over IPv6`;
  * Closes #440.
* Improved scheduled tasks functions: now it checks if tasks were already created for another user;
* Fixed rare bug for `SetUserShellFolderLocation` function when Microsoft Terminal deblicates PC drivers in the menu;
* Minor changes.

* `Wrapper` updated up to `2.6.0`;
  * Now fully compatitable with the latest script version.

## 5.14.7 | 6.2.7 — 08.01.2023

* Improved Microsoft Defender startup checks;
* Improved Badge.yml config;
* Minor changes.

## 5.14.6 | 6.2.6 — 26.12.2022

* Improved Defender startup checks;
  * Thanks to @alan-null.
* Improved `UninstallPCHealthCheck` function to install the "PC Health Check" app (Windows 10 only);
  * Thanks to @alan-null.
* Renamed `InstallDotNetRuntime7` into `InstallDotNetRuntimes` to let users install .NET Desktop Runtime 6 along side with the 7th version;
* Added `FolderGroupBy` function to let users do not group files and folder in the File Explorer;
* Minor changes.

* With best wishes for a happy New Year from `Sophia Team` ![img](https://forum.ru-board.com/board/s/deds.gif)

## 5.14.5 | 6.2.5 — 11.12.2022

* Switched .NET Desktop Runtime 6 to the 7th version;
* Minor changes.

## Wrapper

* Removed annoying pop-up notification while importing preset;
* @BenchTweakGaming.

## 5.14.4 | 6.2.4 — 04.12.2022

* Updated the Scheduled tasks notification toasts UI;
  ![Image](https://github.com/Sophia-Community/SophiApp/raw/master/img/Toasts.png)
  * Call `Sophia -Functions "CleanupTask -Register", "SoftwareDistributionTask -Register", "TempTask -Register"` to update existing Scheduled tasks to have a new toasts UI;
  * [Read](https://github.com/farag2/Sophia-Script-for-Windows#how-to-run-the-specific-functions) how to call specific function from Sophia Script for Windows.
* Fixed bug for `TempFolder` function to make it work without errors on systems with non-latin characters in username;
* Fixed small bug in `NetworkAdaptersSavePower`;
  * Now it doesn't hang script in rare cases.
* `EditWithPhotosContext` and `CreateANewVideoContext` function were removed for Windows 11 only due to they do not work for this Windows;
* Added `EditWithClipchampContext` for Windows only to let remove `Edit with Clipchamp` from the media files context menu;
* Fixed typos in `UpdateLGPEPolicies` function
  * Run this function again if you want to make all manually created policies visible in gpedit.msc snap-in.
* #411 merged;
* Fixed #406;
* Minor changes.

## Wrapper version bumped to 2.5.8

* Minor changes and added link to Discord channel;
* Wrapper 3.0 is on the way.

## 5.14.3 | 6.2.3 — 04.11.2022

* Hot fix for `HEIF` function;
  * Thanks to Ravz59 for bug reporting.

## 5.14.2 | 6.2.2 — 02.11.2022

* `HEIF` function was re-written;
  * Now it downloads the latest HEVC codec package using the <https://store.rg-adguard.net> parser again;
  * Now it checks version of installed package before installing;
  * #406 closed.
* Minor changes.

## 5.14.1 | 6.2.1 — 31.10.2022

* Fixed old bug in Meet Now function when it didn't save registry key value;
* Improved all scheduled tasks creation;
  * Unified tasks with [SophiApp](https://github.com/Sophia-Community/SophiApp): they are created now in `Sophia` folder;
  * When you remove all tasks in the `Task Scheduler`, folder will be removed too;
* Added missed strings in the Wrapper configs;
* Improved Wrapper German translation;
  * Thanks to @Henry2o1o.
* Minor changes.

## 5.14.0 | 6.2.0 — 23.10.2022

* Moved from `PolFileEditor.dll` to [LGPO.exe](https://techcommunity.microsoft.com/t5/microsoft-security-baselines/lgpo-exe-local-group-policy-object-utility-v1-0/ba-p/701045) from Microsoft;
  * It lets manually created policies keys in registry be visible in gpedit.msc snap-in by re-building policy cache by official way;
  * So all functions that rely on policy will be visible in the snap-in for you;
  * The `UpdateLGPEPolicies` was edited to be suitable for a new method based on LGPO.exe;
    * Commented out be default now.
* Added a new function `Cursors`

  ![img](https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/i/1d4615ed-fd22-417b-970a-753c792ac85b/densjkc-0b04ea68-6347-456b-ab8a-3e6dc03ebc02.jpg)

  * Lets you to install free (light and dark) "Windows 11 Cursors Concept v2" cursors from [Jepri Creations](https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-v2-886489356) on-the-fly;
  * Default option is `Dark`.
* The `InstallVCRedist` function now installs both x86 and x64 `Visual C++ Redistributable 2015–2022` packages;
* Fixed bug in the `Windows Cleanup` scheduled task for cleaning Windows. If you applied this function in 6.1.5 release, re-apply in again using this release, unless the task won't run at all.
  * [How-to](https://github.com/farag2/Sophia-Script-for-Windows#how-to-run-the-specific-functions) call specific function

  ```powershell
  Sophia -Functions "CleanupTask -Register"
  ```

* Minor changes.

## 5.13.5 | 6.1.5 — 09.10.2022

* Added a temp workaround to check whether `PolFileEditor.dll` assembly was loaded due to even it was unblocked for SmartScreen before, it's blocked for loading into PowerShell session;
  * Fixes bug when script couldn't load `PolFileEditor.dll` into session and broke the functionality that relies on it. Now if script detects that `PolFileEditor.dll` wasn't loaded, offer to restart powershell.exe session.
  * Will be obsolete with the 6.2.0 release.
* Fixed `winget` not installing Visual C++ Redistributable 2015–2022;
  * Microsoft [changed](https://github.com/microsoft/winget-pkgs/blob/master/manifests/m/Microsoft/VCRedist/2015%2B/x64/14.34.31823.3/Microsoft.VCRedist.2015%2B.x64.installer.yaml#L4) package identifier.
* Minor changes.

## 5.13.4 | 6.1.4 — 13.08.2022

## Windows 11 21H2/22H2 | Windows 10 2004/20H2/21H1/21H2/22H2 | Enterprise LTSC 2021 | Enterprise LTSC 2019

Diff from v6.1.3
[6.1.3...6.1.4](https://github.com/farag2/Sophia-Script-for-Windows/compare/6.1.3...6.1.4)

* We opened our official [Discord](https://discord.gg/sSryhaEv79) channel! Feel free to chat and talk! [![Discord](https://discordapp.com/api/guilds/1006179075263561779/widget.png?style=shield)](https://discord.gg/sSryhaEv79)
* Improved Defender checks;
  * Now they're skipped for `Windows 10 Enteprise G`;
  * Closes #379.
* Now all all `.ps1, .psm1, .psd1` files are signed in cloud via GitHub Actions by a self-issued certificates;
  * <https://github.com/farag2/Sophia-Script-for-Windows/blob/master/Scripts/Sign.ps1>
  * <https://github.com/farag2/Sophia-Script-for-Windows/blob/63de3f5896fba014d7f6bb0493d4934b221fe1ef/.github/workflows/Sophia.yml#L17>
* Removed unnecessary `BitLockerContext` function;
* Improved `UpdateLGPEPolicies` function;
  * Now it covers more GPOs to find in AMDX templates;
  * Thanks `Alex_Piggy` for the code snippet.
* Fixed bug when user couldn't launch PowerShell 7 based script if there is no localization for user's system;
  * Closes #377.
* `OpenWindowsTerminalAdminContext` function was re-written;
  * `OpenWindowsTerminalAdminContext -Enable`, `OpenWindowsTerminalAdminContext -Disable`;
  * Now it uses officially documented feature to make Windows Terminal to launch as administrator by default by editing `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json` file.
  To remove old context menu item, run

  ```powershell
  $Items = @(
    "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\runas",
    "Registry::HKEY_CLASSES_ROOT\Directory\shell\runas"
  )
  Remove-Item -Path $Items -Recurse -Force -ErrorAction Ignore
  ```

  And make Windows Terminal context menu item visible if you hid it before.

    ```powershell
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{9F156763-7844-4DC4-B2B1-901F640F5155}" -Force -ErrorAction Ignore
  ```

* Improved the Ukrainian 🇺🇦: translation.
  * Thanks to @lowl1f3;
  * #378 merged.
* Minor changes.

## 5.13.3 | 6.1.3 — 26.07.2022

## Windows 11 21H2/22H2 | Windows 10 2004/20H2/21H1/21H2/22H2 | Enterprise LTSC 2021 | Enterprise LTSC 2019

* Strengthen the Defender checking whether it was destroyed by 3rd party apps;
* Improved and fixed bug when `DNSoverHTTPS` function didn't enable DNS-over-HTTPS feature;
  * Please check if it's enabled for you in the Settings;
  * #374 closed.
* Improved the Ukrainian 🇺🇦 : translation.
  * #375 merged.
* Minor changes.

### Sophia Script Wrapper 2.5.7

* Output PowerShell: Refresh Console before Export
* Output `DNSoverHTTPS` for other languages other than English

## 5.13.2 | 6.1.2 — 16.07.2022

## Windows 11 21H2/22H2 | Windows 10 2004/20H2/21H1/21H2/22H2 | Enterprise LTSC 2021 | Enterprise LTSC 2019

## Anniversary build of Sophia Script!💯⭐

* Improved startup checks, especially regarding Microsoft Defender whether it wasn't removed or destroyed by malicious tweakers;
* Added `RKNBypass` function to enable proxying only blocked sites from the unified registry of Roskomnadzor;
  * The function will be applied only if the region in Windows is set to "Russia";
  * Based on <https://antizapret.prostovpn.org> proxy.
* Added `WSA` function to enable the latest Windows Subsystem for Android™ with Amazon Appstore;
  * All necessary dependencies will enabled (reboot may require) and the Microsoft Store WSA page will be opened to install it manually;
  * To use Windows Subsystem for Android™ on your device, your PC needs to have Solid State Drive (SSD) installed.
* #365 closed
* Minor changes;
* Fixed numerous typos.

### Sophia Script Wrapper 2.5.6

* @BenchTweakGaming fixed minor UI bug;
* Resized width of window for Russian and fixes scrolling per tab.

## 5.13.1 | 6.1.1 — 04.07.2022

## Windows 11 21H2/22H2 | Windows 10 2004/20H2/21H1/21H2/22H2 | Enterprise LTSC 2021 | Enterprise LTSC 2019

* Now the repo doesn't keep any 3rd party libraries, and all scripts are built using an updated GitHub Action [config](https://github.com/farag2/Sophia-Script-for-Windows/blob/master/.github/workflows/Sophia.yml);
  * 3rd party tools that are downloaded and used;
    * [PolicyFileEditor](https://github.com/dlwyatt/PolicyFileEditor) made by @dlwyatt;
    * [Microsoft.Windows.SDK.NET.Ref](https://www.nuget.org/packages/Microsoft.Windows.SDK.NET.Ref/);
    * [CsWinRT](https://github.com/microsoft/CsWinRT).
* Fixed bug in `NetworkAdaptersSavePower` function when script hung if one network adapter was disabled;
  * Reported by @poohart.
* Fixed bug in `UninstallUWPApps` function for PowerShell 7 based scripts when a WPF form didn't render at all;
  * Reported by @poohart.
* Improved `UpdateLGPEPolicies` function;
  * Now it creates `GPT.ini` file automatically if it doesn't exist.
* Minor changes;
* Fixed numerous typos.

### Sophia Script Wrapper 2.5.5

* @BenchTweakGaming fixed bug when the app crashed if a PowerShell 7 preset was imported;
* Minor changes;

## 5.13.0 | 6.1.0 — 04.07.2022

## Windows 11 21H2/22H2 | Windows 10 2004/20H2/21H1/21H2/22H2 | Enterprise LTSC 2021 | Enterprise LTSC 2019

* Added awesome `UpdateLGPEPolicies` function :ghost:
  * It's common known, that the `gpedit.msc` snap-in doesn't read settings from the Windows registry keys if they were made manually, bypassing the snap-in. This new function lets you update gpedit.msc to make all your policies created manually displayed regardless when registry keys were created. There is no need to run the whole `Sophia Script` — just call `UpdateLGPEPolicies` function. By default this function will be invoked at very end of script running to make all policies registry keys used in the script displayed.
  * To check all policies applied to your OS (if they have a record in `gpedit.msc`) after invoking `UpdateLGPEPolicies`, open `gpedit.msc` and navigate to:
    * `Computer Configuration` — `Administrative Templates` — `All Settings`;
    * `User Configuration` — `Administrative Templates` — `All Settings`.
  * Uses [PolicyFileEditor](https://github.com/dlwyatt/PolicyFileEditor) module created by [Dave Wyatt](https://github.com/dlwyatt)
* Added `InstallDotNetRuntime6` function to let user install the latest .NET Desktop Runtime 6 (x86/x64);
  * The Internet access required;
  * Closes #347.
* Fixed bug in `NetworkAdaptersSavePower` function that caused an error that there is no internet connection even if it was so;
* Formaly added Windows 10 22H2 support;
* Updated startup checks;
* Fixed `DiagnosticDataLevel` function;
  * Now it uses `gpedit.msc` path: `HKLM:\Software\Policies\Microsoft\Windows\DataCollection` instead of `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection`;
  * To updated registry keys run `DiagnosticDataLevel -Minimal`.
* Added `SearchHighlights` function to hide search highlights for Windows 10;
* Fixed `UnpinAllStartApps` function;
  * Now it's working for Windows 11 22H2 Insider Preview too.
* Removed `Windows10FileExplorer` to enabled `Windows 10 File Explorer` in Windows 11;
* Updated `TaskManagerWindow` function to make it not to be run on Windows 11 22H2;
  * Closes #348.
* Fixed a bug in `OpenWindowsTerminalAdminContext` function when you cannot open Windows Terminal as admin in a path ends in a backslash `\`;
  * Closes #340. Read more [here](https://github.com/microsoft/terminal/issues/4571).
* Signed all PowerShell files by a self-signed certificates;
  * ![image](https://i.imgur.com/9JX5Tvn.png)
* #345 closed;
* Minor changes;
* Updated descriptions;
  * Thanks to @THEBOSSMAGNUS

### Sophia Script Wrapper 2.5.4

* Updated translations;
* Works with the latest Sophia Script preset files;
* Minor changes;

## 5.12.14 | 6.0.14 — 09.04.2022

## Windows 11 21H2 | Windows 10 2004/20H2/21H1/21H2 | Enterprise LTSC 2021 | Enterprise LTSC 2019

* Added checking that triggers Windows updating and Microsoft Store apps in the background if the build the app is laucnhed ins't supported;

  ```powershell
  # Enable receiving updates for other Microsoft products when you update Windows
  (New-Object -ComObject Microsoft.Update.ServiceManager).AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "")

  # Check for UWP apps updates
  Get-CimInstance -Namespace "Root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod

  # Open the "Windows Update" page
  Start-Process -FilePath "ms-settings:windowsupdate-action"

  # Trigger Windows Update for detecting new updates
  (New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()
  ```

* Added Windows 11 Insider Support. Requires 22509 build. Closes #336;
* Added `StartLayout` function (for Windows 11 Insider 22509 build only
  * Adds ability to configure Start Layout

    ```powershell
    StartLayout -Default
    StartLayout -ShowMorePins
    StartLayout -ShowMoreRecommendations
    ```

* Added checking that checks whether OS is waiting to be rebooted;
* Improved the `DefaultTerminalApp` function;
* Fixed the `InstallVCRedistx64` function;
  * Now it downloads the right package. Closes #335.
* Removed the `DefenderSandbox` function for Windows 11;
  * Windows 11 has already Sandbox for Defender enabled.
* Minor changes;
* Updated descriptions;
* Check out [SophiApp](https://github.com/Sophia-Community/SophiApp) 1.0.0.50 :rocket:

## 5.12.12 | 6.0.13 — 27.02.2022

## Windows 11 21H2 | Windows 10 2004/20H2/21H1/21H2 | Enterprise LTSC 2021 | Enterprise LTSC 2019

* Added the checking whether Defender wasn't disabled;
* Fixed `XboxGameBar`;
  * To prevent popping up the "You'll need a new app to open this `ms-gamingoverlay`" warning, you need to disable the `Xbox Game Bar` app, even if you uninstalled it before.
* Updated descriptions.
* Check out [SophiApp](https://github.com/Sophia-Community/SophiApp) 1.0.0.23 beta 3 :rocket:

## 5.12.11 | 6.0.12 — 02.02.2022

## Windows 11 21H2 | Windows 10 2004/20H2/21H1/21H2 | Enterprise LTSC 2021 | Enterprise LTSC 2019

* Merged #315 & #326;
* Updated descriptions.
* Check out [SophiApp](https://github.com/Sophia-Community/SophiApp) 1.0.0.13 beta 2 :rocket:

## 5.12.10 | 6.0.11 — 31.12.2022

## Windows 11 21H2 | Windows 10 2004/20H2/21H1/21H2 | Enterprise LTSC 2021 | Enterprise LTSC 2019

* Merged #315 & #326;
* Updated descriptions.
* Check out [SophiApp](https://github.com/Sophia-Community/SophiApp) 1.0.0.13 beta 2 :rocket:

## 5.12.10 | 6.0.11 — 31.12.2021

## Windows 11 21H2 | Windows 10 2004/20H2/21H1/21H2 | Enterprise LTSC 2021 | Enterprise LTSC 2019

* Check out our new [how-to video](https://www.youtube.com/watch?v=q_weQifFM58) about Sophia Script and the Wrapper;
* The `NewsInterests` function now uses the policy due to Microsoft has blocked the ability to turn off the widget via registry;
* Improved and fixed `DNSoverHTTPS`;
  * Now the function can be applied if Hyper-V is enabled when a virtual net switch is being created.
* [Finally](https://t.me/SophiaNews/559), we released [SophiApp](https://github.com/Sophia-Community/SophiApp) 1.0.0 beta 1 :rocket:
* Happy New year! ![ruboard](https://forum.ru-board.com/board/s/deds.gif)

![SophiApp](https://i.imgur.com/6KBMwsG.png)
![SophiApp](https://i.imgur.com/AssAQ35.jpg)

## 5.12.9 | 6.0.10 — 15.12.2021

## Windows 11 21H2 | Windows 10 2004/20H2/21H1/21H2 | Enterprise LTSC 2021 | Enterprise LTSC 2019

* Fixed a bug thats prevented getting the current preset name loaded into session;
  * Closes #312.

## 5.12.8 | 6.0.9 — 14.12.2021

## Windows 11 21H2 | Windows 10 2004/20H2/21H1/21H2 | Enterprise LTSC 2021 | Enterprise LTSC 2019

* Fixed a typo in the `DefaultTerminalApp -WindowsTerminal` function that prevents the function to get the Windows Terminal `PackageFullName` variable value;
* The `WinPrtScrFolder -Desktop` function was improved;
* The `Windows 10 Enterprise LTSC 2019` version is now deprecated and won't be supported. Please, if you an ortodox who likes outdated and abandoned Windows, switch to `Windows 3.11` back, or at least `Windows 10 Enterprise LTSC 2021`;
* Minor changes.

## 5.12.7 | 6.0.8 — 05.12.2021

## Windows 11 21H2 | Windows 10 2004/20H2/21H1/21H2 | Enterprise LTSC 2021 | Enterprise LTSC 2019

* Fixed small bug in the `OneDrive` function that prevents a folder to be removed;
* Fixed small bug in the `OneDrive` function that prevents OneDrive to be downloaded (Microsoft changed the cloud XML silently);
* The `WinPrtScrFolder` function was improved;
  * Now it doesn't matter how your preset was named: the fucntion will parse the preset that was loaded into session to find whether the `OneDrive -Uninstall` function was commented out or not;
* Minor changes.

## Sophia Script Wrapper 2.5.3

* More validation for JSON added;
* Backup of `Sophia.ps1` to `Sophia-original.ps1` if using import ps1 file called `Sophia.ps1`;
  * Otherwise if importing `x.ps1`, the file will be overwritten if the `Run PowerShell` button is used.

## 5.12.6 | 6.0.7 — 23.11.2021

## Windows 11 21H2 | Windows 10 2004/20H2/21H1/21H2 | Enterprise LTSC 2021 | Enterprise LTSC 2019

* Added support for Windows 10 Enterprise LTSC 2021;
* Added the `UninstallPCHealthCheck` funtion;
  * This application is installed with the [KB5005463](https://support.microsoft.com/en-us/topic/kb5005463-pc-health-check-application-e33cf4e2-49e2-4727-b913-f3c5b1ee0e56) update to check if PC meets the system requirements of Windows 11;
  * For Windows 10 only.
* Added the `InstallVCRedist` funtion;
  * Install the latest supported Microsoft Visual C++ Redistributable 2015—2022 x64;
  * <https://docs.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist>;
* Added the `UnpinAllStartApps` function to provide a feature to unpin all Start apps;
* Minor changes.

## Sophia Script Wrapper 2.5.2

* Cleaned up JSONs;
* Cleaned up code;
* Added Portuguese-Brazil (pt-BR);
* JSON validation checker in wrapper: messagebox will popup telling you location of JSON error;
* Added support for LTSC 2021.

![Wrapper](https://i.imgur.com/yS0eESG.png)

## 5.12.5 | 6.0.6 — 24.10.2021

## Windows 11 21H2 | Windows 10 2004/20H2/21H1/21H2 | Enterprise LTSC 2019

* The `NotificationAreaIcons`, `TaskbarSize`, `RecentlyAddedAppsAdded` funtions were removed due to lack of necessity;
* Fixed typo in `FileExplorerCompactMode`;
  * The values for `Disable` and `Enable` were switched places by mistake;
* Fixed bug in `UpdateMicrosoftProducts`;
* Fixed bug in `IPv6Component`;
  * The parameter uses `U+2013` instead of `U+2010` character (hyphen)
* Fixed major in `WinPrtScrFolder` (closes #260);
  * It turned out that it has an influence on the OneDrive behavoir. Now the function will be applied only if the preset is configured to remove OneDrive, otherwise the backup functionality for the "Desktop" and "Pictures" folders in OneDrive breaks;
* Merged #264;
* Added `Spotify` for removing to `UninstallUWPApps`;
* `ShareContext` now uses another method that doesn't have an influence on `Windows10FileExplorer`
  * To revert changes invoke

  ```powershell
  Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{E2BF9676-5F8F-435C-97EB-11607A5BEDF7}" -Force -ErrorAction Ignore
  ```

  * And then invoke a new `ShareContext` [(how-to)](https://github.com/farag2/Sophia-Script-for-Windows#how-to-run-the-specific-functions);
* `OpenWindowsTerminalAdminContext` rewritten and now uses a native UAC icon and added to the top-level context menu
  * To revert changes invoke

  ```powershell
  $Items = @(
    "Registry::HKEY_CLASSES_ROOT\Directory\Background\shell\OpenWTHereAsAdmin",
    "Registry::HKEY_CLASSES_ROOT\Directory\shell\OpenWTHereAsAdmin",
    "HKLM:\SOFTWARE\Classes\Directory\shell\OpenWTHereAsAdmin\command",
    "HKLM:\SOFTWARE\Classes\Directory\Background\shell\OpenWTHereAsAdmin\command",
    "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\terminal.ico"
  )
  Remove-Item -Path $Items -Recurse -Force -ErrorAction Ignore
  ```

  ![Context](https://i.imgur.com/3xUXRQJ.png)

  * And then invoke a new `OpenWindowsTerminalAdminContext` [(how-to)](https://github.com/farag2/Sophia-Script-for-Windows#how-to-run-the-specific-functions);
* Added function to set the Windows 10 style context menu (closes #267);
* Minor changes.
* Check out the 3rd [SophiApp](https://github.com/Sophia-Community/SophiApp) public alpha build :rocket:
  * The 4th alpha version 0.0.0.5x will be released soon

![SophiApp](https://hsto.org/r/w780/getpro/habr/upload_files/be9/060/0b6/be90600b648639aa85d755fe10677cb2.jpg)

## Sophia Script Wrapper 2.5.1

* Cleaned up code: EXE should be now smaller;
* Fixed typos in JSONs;
* Added Spanish (es-ES);
* Fixed UI.

## 5.12.4 | 6.0.5 — 06.10.2021

## Windows 11 21H2 | Windows 10 2004/20H2/21H1/21H2 | Enterprise LTSC 2019

* Now you can download the always latest Sophia Script archive by invoking (`not as administrator too`) in PowerShell console

```powershell
irm script.sophi.app | iex
```

or without using aliases

```powershell
Invoke-RestMethod -Uri script.sophi.app | Invoke-Expression
```

* The command will download and expand the archive (`without running`) the latest Sophia Script according which Windows and PowerShell versions it is run on. If you run it on Windows 11 via PowerShell 5.1, it will download Sophia Script for `Windows 11 PowerShell 5.1`.
* Added `Sophia Script for Windows 11 (PowerShell 7)`
* Updated the `Windows10FileExplorer` function for Windows 11;
  * Invoke to revert changes

  ```powershell
  Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{E2BF9676-5F8F-435C-97EB-11607A5BEDF7}" -Force -ErrorAction Ignore
  ```

  * And then invoke a new `Windows10FileExplorer` [(how-to)](https://github.com/farag2/Sophia-Script-for-Windows#how-to-run-the-specific-functions);
* Removed `Windows10FileExplorerRibbon` because I "feel" the classic Windows 10 File Explorer days are near and the code will be removed sooner or later in the next Windows 11 builds;
* Fixed typo in the `MergeConflicts` function: the values were switched places by mistake;

  ```powershell
  # Hide
  New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideMergeConflicts -PropertyType DWord -Value 1 -Force
  # Show
  New-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideMergeConflicts -PropertyType DWord -Value 0 -Force
  ```

* Add the `OpenWindowsTerminalAdminContext -Show` function for Windows 11 only to allow opening `Windows Terminal` as admin in the Desktop and folders context menu;
* Fixed some bugs in the `script.sophi.app` downloader;
  * Now it supports Windows 11 PowerShell 7 too.
* Minor changes.
* Check out the 3rd [SophiApp](https://github.com/Sophia-Community/SophiApp) public alpha build :rocket:

## Sophia Script Wrapper 2.5

* You must import `Sophia.ps1` before using the Wrapper now. Disabled controls to do this;
* Closed #252, #253 (thnx to @Henry2o1o);
* More JSONs. Split up Windows 10 and Windows 11 config and tooltip JSONs files;
* Console Textbox is now resizable
* Moved "Save As" button to `Export Preset` in `Import/Export Preset` menu
* UI color changes
* Fixed some bugs.

## 5.12.3 | 6.0.4 — 19.09.2021

## Windows 11 21H2 | Windows 10 2004/20H2/21H1/21H2 | Enterprise LTSC 2019

* Now you can download the always latest Sophia Script archive by invoking (`not as administrator too`) in PowerShell console

```powershell
irm script.sophi.app | iex
```

or without using aliases

```powershell
Invoke-RestMethod -Uri script.sophi.app | Invoke-Expression
```

* The command will download and expand the archive (`without running`) the latest Sophia Script according which Windows and PowerShell versions it is run on. If you run it on Windows 11 via PowerShell 5.1, it will download Sophia Script for `Windows 11 PowerShell 5.1`.
* Updated functions
  * `FirstLogonAnimation`;
  * `MappedDrivesAppElevatedAccess`;
  * `BackgroundUWPApps`
* `OneDrive -Install`
  * Now the function parses the Microsoft official [XML](https://g.live.com/1rewlive5skydrive/OneDriveProduction) to get the link to the latest OneDrive installer
* Closed #240, #241, and #246 as fixed;
* Minor changes.

## Sophia Script Wrapper 2.4

* Updated the German translation again;
  * Thanks to @Henry2o1o & @uDEV2019
* You must import `Sophia.ps1` before using the Wrapper now. Disabled controls to do this;
* UI changes (color to highlight important controls);
* Special thanks to `usser_namme` for bug reporting;
* Fixed some bugs.

## 5.12.2 | 6.0.3 — 25.08.2021

## Windows 11 21H2 | Windows 10 2004/20H2/21H1/21H2 | Enterprise LTSC 2019

* Fixed bug when the `Errors output` function couldn't get path to a file with an error;
* Updated translations;
* Closed #234, #235, and #236 as fixed;
* Now script gets the latest version from [sophia_script_versions.json](https://github.com/farag2/Sophia-Script-for-Windows/blob/master/sophia_script_versions.json) to compare with;
* Minor changes.

## Sophia Script Wrapper 2.3

* Updated the German translation;
  * Thanks to @Henry2o1o & @uDEV2019
* Added icons to tabs;
* Fixed numerous bugs;
* UI changes;

## 5.12.1 | 6.0.2 — 06.08.2021

## Windows 11 21H2 | Windows 10 2004/20H2/21H1/21H2 | Enterprise LTSC 2019

* Fixed typo that prevets script from showing the error description;
* Fixed typos in descriptions.

## 5.12 | 6.0.1 — 05.08.2021

## Windows 11 21H2 | Windows 10 2004/20H2/21H1/21H2 | Enterprise LTSC 2019

* Added the `IPv6Component -Enable`, `IPv6Component -Disable` functions;
  * Disable the Internet Protocol Version 6 (TCP/IPv6) component for all network connections. Before invoking the function, a check will be run whether your ISP supports the IPv6 protocol using <https://ipv6-test.com>
* Added the `AeroShaking -Enable`, `AeroShaking -Disable` functions;
  * When I grab a windows's title bar and shake it, minimize all other windows
* @Inestic has re-writen the `WSL` functions into one with a `WPF form` with list of supported Linux distributions to install. Microsoft has allowed the supported Windows 10 versions to install Linux distributions with [one command](https://devblogs.microsoft.com/commandline/install-wsl-with-a-single-command-now-available-in-windows-10-version-2004-and-higher/) `wsl --install`;
  * Windows 10 `19041.1151` (Windows 11) build is minimum needed;
  * ![Image](https://i.imgur.com/j2KLZm0.png)
* The `XboxGameBar` function removed;
* Descriptions updated;
* Fixed typos;
* Minor changes.

***

## Windows 11 21H2

<details>
  <summary>Features removed compared to Windows 10</summary>

* Hide the Windows welcome experiences after updates and occasionally when I sign in to highlight what's new and suggested
  * `WindowsWelcomeExperience -Hide`
* Hide Cortana button on the taskbar
  * C`ortanaButton -Hide`
* Hide the "3D Objects" folder in "This PC" and Quick access
  * `3DObjects -Hide`
* Hide People button on the taskbar
  * `PeopleTaskbar -Hide`
* Hide seconds on the taskbar clock
  * `SecondsInSystemClock -Show`
* Hide the search on the taskbar
  * `TaskbarSearch -Hide`
* Hide the Windows Ink Workspace button on the taskbar
  * `WindowsInkWorkspace -Hide`
* Hide all icons in the notification area
  * `NotificationAreaIcons -Show`
* Hide the Meet Now icon in the notification area
  * `MeetNow -Hide`
* Disable "News and Interests" on the taskbar
  * `NewsInterests -Disable`
* NewAppInstalledNotification
  * `NewAppInstalledNotification -Hide`
* Hide app suggestions in the Start menu
  * `AppSuggestions -Hide`
* Pin the shortcuts to Start
  * `PinToStart -Tiles ControlPanel, DevicesPrinters, PowerShell`
* Do not let UWP apps run in the background
  * `BackgroundUWPApps -Disable`
* Hide the "Edit with Paint 3D" item from the media files context menu
  * `EditWithPaint3DContext -Hide`
* Hide the "Bitmap image" item from the "New" context menu
  * `BitmapImageNewContext -Hide`
* Hide the "Edit" item from the images context menu
  * `ImagesEditContext -Hide`
* Hide the "Rich Text Document" item from the "New" context menu
  * `RichTextDocumentNewContext -Hide`
  
</details>

<details>
  <summary>Features added for Windows 11 compared to Windows 10</summary>

* Enable the Windows 10 File Explorer
  * `Windows10FileExplorer` -Enable
* Disable the File Explorer compact mode
  * `FileExplorerCompactMode -Disable`
* Show snap layouts when I hover over a windows's maximaze button
  * `SnapAssistFlyout -Disable`
* Set the taskbar alignment to the left
  * `TaskbarAlignment -Left`
* Hide the search button from the taskbar
  * `TaskbarSearch -Hide`
* Hide the widgets icon on the taskbar
  * `TaskbarWidgets -Hide`
* Hide the Chat icon (Microsoft Teams) on the taskbar
  * `TaskbarChat -Hide`
* Open the "Notification Area Icons" page in Control Panel to enable "Always show all icons in the notification area" settings manually
  * `NotificationAreaIcons`
* Make the taskbar size small
  * `TaskbarSize -Small`
* Set Windows Terminal Preview as default terminal app to host the user interface for command-line applications
  * `DefaultTerminalApp -WindowsTerminal`
* Enable DNS-over-HTTPS for IPv4. The preferred DNS server: 1.0.0.1, the alternate: 1.1.1.1
  * `DNSoverHTTPS -Enable`
* Hide the "Open in Windows Terminal" menu option in the folders context menu
  * `WindowsTerminalContext -Hide`
  
</details>

***

## Sophia Script Wrapper 2.2

* Now supports the UI translation. ToolTips and UI labels are created from JSON files `tooltip.json` and `ui.json`.
  * Currently translated into English & русский languages stored in the JSON files in `Localizations` folder;
* Fixed some `ToolTip` display errors;
* Console is now autoupdated;
* Minor UI changes;
* Fixed typos.

## 5.11.1 — 13.07.2021

## Windows 10 2004/20H2/21H1 | Enterprise LTSC 2019

Diff from v5.11
[5.11...5.11.1](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.11...5.11.1)

* Fixed #212;
* Fixed typos.

***

* Sophia Script Wrapper 2.1
  * Fixed typos.

## 5.11 — 12.07.2021

## Windows 10 2004/20H2/21H1 | LTSC

Diff from v5.10.8
[5.10.8...5.11](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.10.8...5.11)

* Updated descriptions;
* Expanded the `Checks` funtion functionality;
* Updated the `OneDrive` function;
* Functions removed as not wanted
  * `ShareAcrossDevices`
  * `StorageSenseRecycleBin`
  * `AddProtectedFolders`
  * `RemoveProtectedFolders`
  * `AddAppControlledFolder`
  * `RemoveAllowedAppsControlledFolder`
  * `AddDefenderExclusionFolder`
  * `RemoveDefenderExclusionFolders`
  * `AddDefenderExclusionFile`
  * `RemoveDefenderExclusionFiles`
  * `PreviousVersionsPage`
* Some functions renamed;
* Minor changes & minor bugs fixed. :feelsgood:

***

* Sophia Script Wrapper 2.1
  * Improved UX;
  * All settings were moved to JSON (3 600 lines);
  * UI changes.

## 5.10.8 — 20.06.2021

## Windows 10 2004/20H2/21H1 | LTSC

Diff from v5.10.7
[5.10.7...5.10.8](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.10.7...5.10.8)

* The `UnpinTaskbarEdgeStore` function renamed into `UnpinTaskbarShortcuts`, and added feature to unpin the `Mail` shortcut
  * `UnpinTaskbarShortcuts -Shortcuts Edge, Store, Mail`.
* The `PowerManagementScheme` rename into `PowerPlan`;
* #195, #196, #200 closed;
* Updated the Chinese translation. Thanks to @flashercs;
* Minor changes. :feelsgood:

***

* Sophia Script Wrapper 2.0.2
  * Fixed runtime error;
  * Fixed PowerShell 7.1 lanuch (detects 5.1 or 7.1 and uses appropiate PowerShell to launch either);
  * Added online check for the latest Wrapper version. If you are using old version it will exit;
  * Added online check for the latest imported script version. If you are using old version it will disable directly running (run PowerShell button disabled);
  * UI changes.

## 5.10.7 — 13.06.2021

## Windows 10 2004/20H2/21H1 | LTSC

Diff from v5.10.6
[5.10.6...5.10.7](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.10.6...5.10.7)

* #190 closed;
* The manifest file moved to the `Manifest` folder;
* The module file moved to the `Module` folder;
* Minor changes. :feelsgood:

***

* Sophia Script Wrapper 2.0.1
  * Added multi-languages support (only for the functions' descriptions);
  * Reverted back the `Opposite` function. Closes #186;
  * UI changes.

## 5.10.6 — 01.06.2021

## Windows 10 2004/20H2/21H1 | LTSC

Diff from v5.10.5
[5.10.5...5.10.6](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.10.5...5.10.6)

* Added functions `NewsInterests -Hide` & `NewsInterests -Show` to configure "News and Interests" on the taskbar;
  * #184 closed.
* Updated the `CABInstallContext -Add` function;
  * If the .cab file extension type associated to open with a third party app by default, the "Install" context menu item won't be displayed, so the default association for the .cab file type will be restored forcedly.
* Updated the French translation;
  * #181 closed. Thanks @couleurm.
* Minor changes. :feelsgood:

***

* Sophia Script Wrapper was rewritten from the scratch;
  * Redefined UI and UX;
  * Many bugs fixed.
  * Supports LTSC and the current supported Windows 10 editions;
  * Dark and light themes;
  * Just import the `Sophia.ps1` file and all functions will be set up automatically.

![Wr](https://i.imgur.com/p76nAiN.png)
![Wr](https://i.imgur.com/yP1ykai.png)
![Wr](https://i.imgur.com/4bdGLtk.png)

## 5.10.5 — 17.05.2021

## Windows 10 2004/20H2/21H1 | LTSC

Diff from v5.10.4
[5.10.4...5.10.5](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.10.4...5.10.5)

* Updated all WPF forms;
  * The WPF forms' appearance has been brought to the single design;
  * Now window forms are opened in their own separate windows;
  * Fixed bug when opening window form freezed waiting for pressing any button;
  * Fixed bug when opened window form was in the background;
* PowerShell 7 version;
  * CsWinRT updated up to 1.2.6;
  * Microsoft.Windows.SDK.NET.Ref updated up to 10.0.19041.17.
* Minor changes. :feelsgood:

## 5.10.4 — 07.05.2021

## Windows 10 2004/20H2/21H1 | LTSC

Diff from v5.10.3
[5.10.3...5.10.4](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.10.3...5.10.4)

* Почитайте [лонгрид](https://habr.com/company/skillfactory/blog/553800) на Хабре, как происходила разработка скрипта последние полгода.
* Added a warning message before the script running to be sure a user has customized the `Sophia.ps1` preset file;
  * You may disable it by removing the `Warning` argument in the `Checks` function in the preset file.
![image](https://i.imgur.com/d3QUmIP.png)
* Moved all localization files to the `Localizations` folder;
![image](https://i.imgur.com/kQDktvj.png)
* Fixed bug in the `EventViewerCustomView` function when the `ProcessCreation.xml` file was being created with a wrong encodings;
  * You may invoke the function again: `EventViewerCustomView -Enable`.
* Updated the GitHub Action [config](https://github.com/farag2/Windows-10-Sophia-Script/blob/master/.github/workflows/Sophia.yml) to automate the SHA256 file creation and uploading to the release page. As @aaronhatesregex wanted 😄
* Updated the Turkish translation. Thanks to @v30xy;
* Added the Hungarian translation <img src="https://upload.wikimedia.org/wikipedia/commons/c/c1/Flag_of_Hungary.svg" height="11px"/>. Thanks to @84stangman;
* Updated Sophia Script Wrapper to 1.1 build 5;
  * The read/edit button function can now edit all functions in 'Sophia.psm1' file;
  * The wrapper now creates a 'Sophia_edited.ps1' file in Sophia Script folder to run instead of overwriting the existing one.

## 5.10.3 — 27.04.2021

## Windows 10 2004/20H2/21H1 | LTSC

Diff from v5.10.2
[5.10.2...5.10.3](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.10.2...5.10.3)

* Closed #163;
* The `DiagnosticDataLevel` function updated;
  * You may re-run it: `DiagnosticDataLevel -Minimal` or `DiagnosticDataLevel -Default`;
* The `ErrorReporting` & `RecommendedTroubleshooting` functions updated;
* Sophia Script Wrapper updated;
  * The version bumped to 1.1 build 4;
  * Fixed inability to open preset file from the LTSC version.
  ![wrapper](https://i.imgur.com/joOcKi5.png)
* Minor changes. :feelsgood:

## 5.10.2 — 23.04.2021

## Windows 10 2004/20H2/21H1 | LTSC

Diff from v5.10.1
[5.10.1...5.10.2](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.10.1...5.10.2)

* Updated the descriptions;
* PowerShell 7 version;
  * CsWinRT updated up to 1.2.5.
* Sophia Script Wrapper updated;
  * Minor UI changes;
  * Now you can just import the .ps1 preset file without the need to expand all files into the script folder.
* Minor changes. :feelsgood:

## 5.10.1 — 14.04.2021

## Windows 10 2004/20H2/21H1 | LTSC

Diff from v5.10
[5.10...5.10.1](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.10...5.10.1)

* Added the video of how the script scheduled tasks work

  [![YT](https://img.youtube.com/vi/MiQ85tVXQQA/0.jpg)](https://youtu.be/MiQ85tVXQQA)

* The developmet focus shifted to [SophiApp](https://github.com/SophiaUI/SophiApp) :rocket:
* The TAB automplete function improved;
* Revert the feature to call functions from Sophia.ps1

  ```powershell
  .\Sophia.ps1 -Functions CreateRestorePoint, "ScheduledTasks -Disable", "WindowsCapabilities -Uninstall"
  ```

* Closed #158;
* Remove the unnecessary `AppMode` function in LTSC version;
* Sophia Script Wrapper' version bumped to 1.1: UI updated;
  ![Image](https://i.imgur.com/GBN3UDM.png)
* Minor changes. :feelsgood:

## 5.10 — 09.04.2021

## Windows 10 2004/20H2/21H1 | LTSC

Diff from v5.9
[5.9...5.10](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.9...5.10)

* Calling the specific function was completely rewritten! :rocket:
  * Added the <kbd>Tab</kbd> functions autocompletion by typing its' first letters
    https://user-images.githubusercontent.com/10544660/225270281-908abad1-d125-4cae-a19b-2cf80d5d2751.mp4
  * The code from moved to the `Functions.ps1` file;
  * If you want to call the specific function you need to [dot source](https://docs.microsoft.com/ru-ru/powershell/module/microsoft.powershell.core/about/about_operators#dot-sourcing-operator-) the `Functions.ps1` first

    ```powershell
    # With a dot at the beginning
    . .\Functions
    ```

    * Now you can do like this

    ```powershell
    Sophia -Functions <tab>
    Sophia -Functions temp<tab>
    Sophia -Functions unin<tab>
    Sophia -Functions "DiagTrackService -Disable", "DiagnosticDataLevel -Minimal", UninstallUWPApps
    ```

  * The code isn't perfect but it works. Anyway it's better than recalling the functions' names. Hopefully I'll improve it in the next releases.
* Added the `RestoreUWPApps` function;

  ![Image](https://i.imgur.com/JQh0oSh.png)

  * Now it's possible to restore the default UWP apps uninstalled for current user;
  * Restorable packages will always be displayed in English in a pop form;
  * If you uninstalled packages for all users they can be restored only by downloading from the Microsoft Store.
* David updated his wrapper;
  * Now you need to import Sophia.ps1 to configure it.
* Fixed bug in the `PinToStart` function when it was unable to pin the "Devices and Printers" shortcut;
* Fixed bug in the `UninstallUWPApps` function when packages names displayed in the center instead of the top;
* Now the `TempTask` task removes only files and folders older than a day;
* After script applying a pop-up will apper

  ![Image](https://i.imgur.com/9s7Noud.png)

* Formally added the `21H1, 19043` build support;
* Minor changes. :feelsgood:

## 5.9 — 27.03.2021

## Windows 10 2004/20H2 | LTSC

Diff from v5.9
[5.8...5.9](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.8...5.9)

* Для граждан СНГ добавил перевод пожертвований с помощью [ЮMoney](https://yoomoney.ru/to/4100116615568835), используя прямой перевод с карты;
* Updated the `UnpinTaskbarEdgeStore` function again;
  * Fixed bug when calling this function before `UninstallUWPApps` breaks the retrieval of the localized UWP apps packages names;
  * Refixed #145;
  * Thanks to [iNNOKENTIY21](https://forum.ru-board.com/profile.cgi?action=show&member=iNNOKENTIY21)
* The `TempFolders` and the `OneDrive` functions update
  * `TempFolders` totally rewritten using the `MoveFileExA` [function](https://docs.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-movefileexa)
  * Now with the `MOVEFILE_DELAY_UNTIL_REBOOT` flag all unremovable files and folder will be removed after reboot (log off) automatically. After that the temporary scheduled task will create a symobolic link and remove itself;
  * Thanks to @gtumanyan for the tip;

<details>
  <summary>More details</summary>

```C#
public enum MoveFileFlags
{
  MOVEFILE_DELAY_UNTIL_REBOOT = 0x00000004
}

[DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
static extern bool MoveFileEx(string lpExistingFileName, string lpNewFileName, MoveFileFlags dwFlags);

public static bool MarkFileDelete (string sourcefile)
{
  return MoveFileEx(sourcefile, null, MoveFileFlags.MOVEFILE_DELAY_UNTIL_REBOOT);
}
```

</details>

* Fixed #152;
* Minor changes. :feelsgood:

## 5.8 — 17.03.2021

## Windows 10 2004/20H2 | LTSC

Diff from v5.7
[5.7...5.8](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.7...5.7)

* The `UninstallUWPApps` function huge update
  * The `PowerShell 7.x` version now shares the same codebase as PowerShell 5.1;
    * By loading the `WinRT.Runtime.dll` (289 KB) and `Microsoft.Windows.SDK.NET.dll` (25,4 MB) assemblies (both are being downloaded and archived by GitHub Actions) it becomes possible to get localized UWP apps packages names too;
    * <https://github.com/microsoft/CsWinRT>;
    * <https://www.nuget.org/packages/Microsoft.Windows.SDK.NET.Ref>;
    * ![Image](https://i.imgur.com/J93PTcT.png)
  * Added the `Select all` button;
  * Fixed #141;
  * Many fixes and improvements by @Inestic and [iNNOKENTIY21](https://forum.ru-board.com/profile.cgi?action=show&member=iNNOKENTIY21)
* The `Set-Association` function huge update
  * Fixed bug when PowerShell calculates the wrong hash;
  * Now possible to associate extension using the relative paths
  * `Set-Association -ProgramPath "%ProgramFiles%\Notepad++\notepad++.exe" -Extension .txt -Icon "%ProgramFiles%\Notepad++\notepad++.exe,0"`
  * Now contains code from <https://github.com/DanysysTeam/PS-SFTA> and <https://github.com/default-username-was-already-taken/set-fileassoc>
  * Fix by [westlife](https://forum.ru-board.com/profile.cgi?action=show&member=westlife) and @default-username-was-already-taken
* Updated the `SoftwareDistributionTask` and the `TempTask` task
  * Added pop-up notification after the successful task completion
    * ![Image](https://i.imgur.com/fmFxnaA.png)
    * ![Image](https://i.imgur.com/IbaYl3h.png)
  * To update the existing `SoftwareDistributionTask` and `TempTask` functions run (no need to restart)

  ```powershell
  .\Sophia.ps1 -Functions "SoftwareDistributionTask -Register", "TempTask -Register"
  ```

  * Fixed #143
* Fixed small bug in the `Windows Cleanup` function
  * To update the existing `Windows Cleanup` function run (no need to restart)

  ```powershell
  .\Sophia.ps1 -Functions "CleanUpTask -Register"
  ```

* Added the Portuguese translation <img src="https://upload.wikimedia.org/wikipedia/commons/5/5c/Flag_of_Portugal.svg" height="11px"/>
  * Thanks to ZZ
* Fixed typos;
* Minor changes. :feelsgood:
  * Thanks to @gtumanyan

## 5.7 — 05.03.2021

## Windows 10 2004/20H2 | LTSC

Diff from v5.6
[5.6...5.7](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.6...5.7)

<a href="https://t.me/Sophia_News"><img src="https://img.shields.io/badge/Sophia%20News-Telegram-blue?style=flat&logo=Telegram"></a>
<a href="https://t.me/Sophia_Chat"><img src="https://img.shields.io/badge/Sophia%20Chat-Telegram-blue?style=flat&logo=Telegram"></a>

* The `CleanupTask` function huge update;
  * Splited into two functions: `Windows Cleanup` and `Windows Cleanup Notification`. `Windows Cleanup Notification` enables you the option to run the cleanup task or not. The `Windows Cleanup Notification` function runs once every month and displays native toast notification where you can choose to snooze (with drop down menu time reminder), run the cleanup task now or dismiss. You will be asked for this notification about Windows cleanup once a month.
  ![Image](https://i.imgur.com/cZC40Fi.png)
  * To update the existing `Windows Cleanup` function run (no need to restart)

  ```powershell
  .\Sophia.ps1 -Functions "CleanUpTask -Register"
  ```

* Added `MeetNow` function;
  * Hide or show the `Meet Now` icon in the system tray;
* Updated Sophia Script Wrapper
  * Fixed `LeaveAlone` outputting to script when pressing `Output PowerShell`;
  * Moved Tooltips `ControlPanelView` to `Other` section;
* Fixed typos;
* Minor changes. :feelsgood:

## 5.6 — 02.03.2021

## Windows 10 2004/20H2 | LTSC

Diff from v5.5
[5.5...5.6](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.5...5.6)

* `PinToStart` function fixed & updated
  * Now, wherever the `-UnpinAll` (unpin all tiles) argument is placed, it will always be executed first, to avoid the situation when the tiles were pinned and then all were unpinned;
* The `HEIF` function huge update
  * Now it's possible to open Microsoft Store extension page manually (`-Manual` argument) or download and install (`-Install` argument) appx package directly from Microsoft server using the <https://store.rg-adguard.net> parser;
  * Built upon awesome @KaiWalter [function](https://dev.to/kaiwalter/download-windows-store-apps-with-powershell-from-https-store-rg-adguard-net-155m); :rocket:
  * Thanks to [iNNOKENTIY21](https://forum.ru-board.com/profile.cgi?action=show&member=iNNOKENTIY21) for the tips.
* Added the `Set-Association` function (`commented out by default`);
  * Now it's able to register an app, calculate special hash, and set as default for specific extension without the ["How do you want to open this"](https://filestore.community.support.microsoft.com/api/images/2383a021-b035-40b5-8d9b-b935cbb713e3) pop-up
  * Built upon awesome @Danyfirex [function](https://github.com/DanysysTeam/PS-SFTA); :rocket:
  * Learn more about the problem: <https://stackoverflow.com/a/49256437/8315671>;
  * See examples in the preset file;
* Updated descriptions;
* Fixed typos;
* Minor changes. :feelsgood:

## 5.5 — 20.02.2021

## Windows 10 2004/20H2 | LTSC

Diff from v5.4.0.1
[5.4.0.1...5.5](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.4.0.1...5.5)

* At last we created the video how to use Sophia Script!
* The `PinControlPanel`, `PinDevicesPrinters`, `PinCommandPrompt`, and `UnpinAllStartTiles` functions were rewritten into one, `PinToStart`
  * Now it's possible to pin Control Panel, Device and Printers, and PowerShell shortcuts without using the `syspin` app — just pure PowerShell! syspin was removed.
  * You can choose what to pin

  ```powershell
  PinToStart -Tiles ControlPanel, DevicesPrinters, PowerShell
  ```

  or unpin all tiles

    ```powershell
  PinToStart -UnpinAll
  ```

  * Thanks to [iNNOKENTIY21](https://forum.ru-board.com/profile.cgi?action=show&member=iNNOKENTIY21) for the tips.
* Updated descriptions;
* Fixed typos.

## 5.4.0.1 — 06.02.2021

## Windows 10 2004/20H2

Diff from v5.4
[5.4...5.4.0.1](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.4...5.4.0.1)

* Fixed UWP apps form not loading.

## 5.4 — 04.02.2021

## Windows 10 2004/20H2 | LTSC

Diff from v5.3.3
[5.3.3...5.4](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.3.3...5.4)

* Now all archives are being created and uploaded to the release page via [GitHub Actions](https://github.com/farag2/Windows-10-Sophia-Script/blob/master/.github/workflows/Sophia.yml);
  * Thnx to @inv2004
* When running the script using ```.\Sophia.ps1 -Functions "FunctionName1 -Parameter"``` regardless of the functions entered as an argument, the `Checks` function will be executed first, and the ```Refresh``` and ```Errors``` functions will be executed at the end;
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

## 5.3.3 — 21.01.2021

## Windows 10 2004/20H2 | LTSC

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

## 5.3.2 — 16.01.2021

## Windows 10 2004/20H2 | LTSC

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

## 5.3.1 — 22.12.2020

## Windows 10 2004/20H2 | LTSC

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

## 5.3 — 12.12.2020

## Windows 10 2004/20H2

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

## 5.2 — 11.11.2020

## Windows 10 2004/20H2

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
  * Ukrainian. Thanks to **lowlif3**;
  * Now available in: Available in: <img src="https://upload.wikimedia.org/wikipedia/commons/a/ae/Flag_of_the_United_Kingdom.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/f/fa/Flag_of_the_People's_Republic_of_China.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/b/ba/Flag_of_Germany.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/c/c3/Flag_of_France.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/0/03/Flag_of_Italy.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/f/f3/Flag_of_Russia.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/4/49/Flag_of_Ukraine.svg" height="11px"/> <img src="https://upload.wikimedia.org/wikipedia/commons/b/b4/Flag_of_Turkey.svg" height="11px"/>
* Updated localizations;
* Closed #81, #83, #84, #85, #86, #87
* Minor changes.

Also guy from [benchtweakgaming.com](https://benchtweakgaming.com/2020/11/12/windows-10-debloat-tool/) created a GUI wrapper for the script. Hope it'll help! 🗡️

## 5.1.1 — 09.10.2020

## Windows 10 2004/20H2

Diff from v5.1
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

## 5.1 — 08.10.2020

## Windows 10 2004/20H2

Diff from v5.0.1
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

## 5.0.1 — 25.09.2020

## Windows 10 2004/20H2

Diff from v5.0.0
[5.0.0...5.0.1](https://github.com/farag2/Windows-10-Sophia-Script/compare/5.0.0...5.0.1)

* The "SetTempPath" function;
  * Fixed error ```There is a mismatch between the tag specified in the request and the tag present in the reparse point```
* Descriptions;
* Minor changes.

## 5.0 — 24.09.2020

## Windows 10 2004/20H2

* The script has a new name: Windows 10 Sophia Script ❤️
* The Script was rewritten into module (about **270** functions) with a preset file!
  * Now it should be ran via .\Preset.ps1
  * Every tweak in a preset file has its' corresponding function to **restore the default settings**;
  * Create your own preset file!
* Minor changes. No new features.

## 4.6 — 18.08.2020

## Windows 10 2004 | 1903/1909 | LTSC

Diff from v4.5.7
[4.5.7...4.6](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.5.7...4.6)

* **Fixed and improved translations and comments**. Closed #58 & #59. Thanks a lot to @skycommand for the help with translation;
* Removed the "Group svchost.exe processes" section;
  * To revert to the default changes rub

  ```powershell
  New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control -Name SvcHostSplitThresholdInKB -PropertyType DWord -Value 3670016 -Force

  # Restart required
  ```

* Removed the "Show the "File Explorer" and "Settings" folders on Start" section;
* Updated the "Turn off Delivery Optimization" section;
  * To enable it run

  ```powershell
  New-ItemProperty -Path Registry::HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings -Name DownloadMode -PropertyType DWord -Value 0 -Force
  New-ItemProperty -Path Registry::HKEY_USERS\S-1-5-20\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings -Name DownloadModeProvider -PropertyType DWord -Value 8 -Force
  ```

* Updated the "Turn off Windows features" section;
  * The "Microsoft Print to PDF" feature was excluded from disabling;
  * To revert to the proper values run

  ```powershell
  Enable-WindowsOptionalFeature -Online -FeatureName Printing-PrintToPDFServices-Features # -NoRestart
  ```

* Updated the "Change the location of the user folders to %SystemDrive%" section;
  * Added the ```RemoveDesktopINI``` argument to remove ```desktop.ini``` in the old user shell folder;
* Fixed wrong value in "Add the "Extract all" item to Windows Installer (.msi) context menu" section;
  * To revert to the proper values run

  ```powershell
  New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Msi.Package\shell\Extract -Name MUIVerb -PropertyType String -Value "@shell32.dll,-37514" -Force
  ```

* Updated the "Do not add the "* Shortcut" suffix to the file name of created shortcuts" section;
* Minor changes.

## 4.5.7 — 17.08.2020

## Windows 10 2004 | 1903/1909 | LTSC

Diff from v4.5.6
[4.5.6...4.5.7](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.5.6...4.5.7)

* Removed "Turn off per-user services" section;
  * Closed #50 & #52;
  * To revert these services back run

  ```powershell
  New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\PimIndexMaintenanceSvc -Name Start -PropertyType DWord -Value 3 -Force
  Remove-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\PimIndexMaintenanceSvc -Name UserServiceFlags -Force
  New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\UnistoreSvc -Name Start -PropertyType DWord -Value 3 -Force
  Remove-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\UnistoreSvc -Name UserServiceFlags -Force
  New-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\UserDataSvc -Name Start -PropertyType DWord -Value 3 -Force
  Remove-ItemProperty -Path HKLM:\System\CurrentControlSet\Services\UserDataSvc -Name UserServiceFlags -Force

  # Restart required
  ```

* Updated "Turn on Windows 10 20H2 new Start style" section;
* Updated "Change %TEMP% environment variable path to the %SystemDrive%\Temp" section;
  * Added prompt for choice;
    * Added symbolic link creation;
  * Closed #51.
    * Create required folder

    ```powershell
    New-Item -Path $env:LOCALAPPDATA\Temp -ItemType Directory -Force
    ```

* Minor changes.

## Windows 10 LTSC Enterprise 2019 Version

* As I was asked many times, released the LTSC version;
* Closed #40 & #39;
* Minor changes.

## 4.5.6 — 03.08.2020

## Windows 10 2004 | 1903/1909

Diff from v4.5.5
[4.5.5...4.5.6](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.5.5...4.5.6)

* Added "Turn on Windows 10 20H2 new Start style" section. The new Start style described [here](https://www.windowslatest.com/2020/08/02/windows-10-2004-gets-20h2-features/);
* Added "Install the Windows Subsystem for Linux (WSL)" section;
* Added new package "Microsoft.Photos.MediaEngineDLC" to the $UncheckedAppxPackages variable in "Uninstall UWP apps" section;
* region Edge removed (only for 1903/1909 Version);
* Comments;
* Minor changes.

## Windows 10 LTSC Enterprise 2019 Version

* As I was asked many times, released the LTSC version;
* Closed #40 & #39;
* Minor changes.

## 4.5.5 — 07.07.2020

## Windows 10 2004 | 1903/1909

Diff from v4.5.4
[4.5.4...4.5.5](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.5.4...4.5.5)

* Closed #40 & #39
* Comments;
* Minor changes.

## 4.5.4 — 29.06.2020

## Windows 10 2004 | 1903/1909

Diff from v4.5.3
[4.5.3...4.5.4](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.5.3...4.5.4)

* Updated "Turn off Cortana autostarting" section
* Updated "Create "Process Creation" Event Viewer Custom View" section
  * Closed #37
* Removed "Uninstall all Xbox related UWP apps from all accounts" section because it's unnecassary
* Closed #36. Removed sections
  * Show accent color on Start, taskbar, and action center
  * Show accent color on the title bars and window borders
  * Increase taskbar transparency
* Comments;
* Minor changes

## 4.5.3 — 23.06.2020

## Windows 10 2004 | 1903/1909

Diff from v4.5.2
[4.5.2...4.5.3](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.5.2...4.5.3)

* Updated help section
* Updated "Turn off Cortana autostarting" section
* Added "Create "Process Creation" Event Viewer Custom View" section
  * For this custom view to function, it is necessary to enable the following sections
    * Turn on events auditing generated when a process is created or starts
    * Include command line in process creation events
  * This feature allows to conveniently track the creation of suspicious processes along with the process command line argument
  * Go to Event Viewer *Custom View* Process Creation
* Minor changes

## 4.5.2 — 19.06.2020

## Windows 10 2004 | 1903/1909

Diff from v4.5.1
[4.5.1...4.5.2](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.5.1...4.5.2)

* Removed sections due to Network troubleshooter is unable to start DPS service
  * Stop event trace sessions
  * Turn off the data collectors at the next computer restart
  * To restore Network troubleshooter download attached DiagLog_EN.xml and execute in CMD

  ```cmd
  :: Restart needed
  logman import -name "DiagLog" -xml "PathTo\DiagLog_EN.xml"
  logman start "DiagLog"
  ```

* Updated "Turn on logging for all Windows PowerShell modules" section
  * Fixed typo in registry path key creation
  * To restore execute

  ```powershell
  Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging\ModuleNames -Name EnableModuleLogging -Force
  New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging -Name EnableModuleLogging -PropertyType DWord -Value 1 -Force
  ```

* Minor changes

## 4.5.1 — 17.06.2020

## Windows 10 2004 | 1903/1909

Diff from v4.5.0.1
[4.5.0.1...4.5.1](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.5.0.1...4.5.1)

* Updated "Unpin all the Start tiles" section
  * Now using another method to unpin all Start tiles
* Updated "Pin the shortcuts to Start" section
  * Updated check for the internet connection

## 4.5.0.1 — 11.06.2020

## Windows 10 2004 | 1903/1909

Diff from v4.5
[4.5...4.5.0.1](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.5...4.5.0.1)

* Updated "Remove Windows capabilities" section
  * Moved Notepad from the $CheckedCapabilities variable to the $ExcludedCapabilities
  * To restore uninstalled Notepad execute

    ```powershell
    Get-WindowsCapability -Online -Name Microsoft.Windows.Notepad* | Add-WindowsCapability -Online -Verbose
    ```

* Updated "Turn on hardware-accelerated GPU scheduling" section
  * Added determining whether an OS is not installed on a virtual machine

## 4.5 — 10.06.2020

## Windows 10 2004 | 1903/1909

Diff from v4.4.1
[4.4.1...4.5](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.4.1...4.5)

* Updated sections
  * Stop event trace sessions;
  * Turn off Windows features;
  * Turn off background apps, except the followings...;
  * Turn off and delete reserved storage after the next update installation;
  * Hide the "Edit with Photos" item from the context menu;
  * Hide the "Create a new video" item from the context menu;
  * Hide the "Edit" item from the images context menu;
  * Remove the "Bitmap image" item from the "New" context menu;
  * Remove the "Rich Text Document" item from the "New" context menu.
* Added sections
  * Turn on automatically save my restartable apps when sign out and restart them after sign in
  * Turn off Cortana autostarting;
  * Turn on hardware-accelerated GPU scheduling.
* Due to Microsoft Edge moved to Chromium rendering engine, the following sections was removed
  * Remove Microsoft Edge shortcut from the Desktop;
  * Do not allow Microsoft Edge to start and load the Start and New Tab page at Windows startup and each time Microsoft Edge is closed;
    * To remove unnecessary key execute

    ```powershell
    Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader -Name AllowTabPreloading -Force
    ```

  * Do not allow Microsoft Edge to pre-launch at Windows startup, when the system is idle, and each time Microsoft Edge is closed;
    * To remove unnecessary key execute unnecessary key execute

    ```powershell
    Remove-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main -Name AllowPrelaunch -Force
    ```

  * Turn off Windows Defender SmartScreen for Microsoft Edge;
    * To remove unnecessary key execute

    ```powershell
    $edge = (Get-AppxPackage -Name Microsoft.MicrosoftEdge).PackageFamilyName
    Remove-ItemProperty -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\$edge\MicrosoftEdge\PhishingFilter" -Name EnabledV9 -Force
    ```

  * Turn off creation of an Edge shortcut on the desktop for each user profile;
    * To remove unnecessary key execute

    ```powershell
    Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name DisableEdgeDesktopShortcutCreation -Force
    ```

* In Windows 10 the "Turn on automatic recommended troubleshooting and tell when problems get fixed" feature was renamed into "Run troubleshooters automatically, then notify"
* Comments;
* Minor changes.

## 4.4.1 — 02.06.2020

## Windows 10 2004 | 1903/1909

Diff from v4.4
[4.4...4.4.1](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.4...4.4.1)

* Comments;
* Minor changes.

## 4.4 — 02.06.2020

## Windows 10 2004 | 1903/1909

Diff from v4.3.0.1
[4.3.0.1...4.4](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.3.0.1...4.4)

* Updated links in the comment-based help section;
* Updated "Increase taskbar transparency" section
  * Removed "ForceEffectMode" key, that blocked Windows 10 transparency effects
  * To remove unnecessary key, execute

  ```powershell
  # Restart needed
  Remove-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\Dwm -Name ForceEffectMode -Force
  ```

* Updated "Change location of the user folders" section
  * Added comment-based section;
  * Added the ability to skip (#25)
* Updated "Uninstall UWP apps" section
  * Added "Uninstall for All Users" button to the form (unchecked by default) (@oz-zo) to uninstall UWP apps from all account
* Add the "Run as different user" item to the .exe files types context menu
  * Removed unnecessary keys
* Comments;
* Minor changes.

## 4.3.0.1 — 23.05.2020

## Windows 10 2004 | 1903/1909

Diff from v4.2.1
[4.2.1...4.3.0.1](https://github.com/farag2/Windows-10-Sophia-Script/compare/4.2.1...4.3.0.1)

* Fixed bug in "Show accent color on Start, taskbar, and action center" section;
* The "Change location of the user folders" section was rewritten into interactive menu using up/down arrows and Enter key to make a selection (menu by [MaxKozlov](https://qna.habr.com/user/MaxKozlov))
  * A user will be prompted to select the drive letter where the user folders will be moved programmatically
  * Files will not be moved. Do it manually
  * [Video](https://www.youtube.com/watch?v=cjyi9nX8sFA)
* The task "Update cleanup" in the Task Scheduler renamed into "Windows Cleanup";
* Comments;
* Minor changes;
* Thanks [YuS_2](http://forum.ru-board.com/profile.cgi?action=show&member=YuS_2) and [westlife](http://forum.ru-board.com/profile.cgi?action=show&member=westlife) for the tips.

## 4.2.1 — 16.05.2020

## Windows 10 2004 | 1903/1909

* Now the form for removing capabilities and UWP apps will not be initialized if there are no elements for removal;
* Added for the all tasks in the Task Scheduler a description displayed in the "Description" section;
* Fixed bug in "Include command line in process creation events" section
* Minor changes;
* Thanks [4r0](http://forum.ru-board.com/profile.cgi?action=show&member=4r0) for found bugs.

## 4.2 — 12.05.2020

## Windows 10 2004 | 1903/1909

* Now the script will not be executed by PowerShell ISE;
* Moved from the "Read-Host" cmdlet to $Host.UI.PromptForChoice();
* Updated "Create a task in the Task Scheduler to start Windows cleaning up";
  * A [toast notification](https://docs.microsoft.com/ru-ru/windows/uwp/design/shell/tiles-and-notifications/adaptive-interactive-toasts) will be activated before starting cleaning up;
  * Now cleanmgr.exe window starts minimized;
  * Now using DISM to clean up unused Windows updates instead of cleanmgr.exe

```cmd
DISM.exe /Online /English /Cleanup-Image /StartComponentCleanup /NoRestart
```

* Minor changes;
* Thanks [westlife](http://forum.ru-board.com/profile.cgi?action=show&member=westlife) for the tips.

## 4.1 — 03.05.2020

* The "Turn off Windows features" and "Uninstall all UWP apps from all accounts" sections moved from CLI to GUI!
* WPF form made by [oz-zo](https://github.com/oz-zo), fixes by [westlife](http://forum.ru-board.com/profile.cgi?action=show&member=westlife)
* Minor changes.

## 4.0.34 — 28.04.2020

* Added the "Create a restore point" section (#14);
* Updated "Include command line in process creation events" section;
* Minor changes;
* Comments.

## 4.0.33 — 24.04.2020

* The "Set "High performance" in graphics performance preference for apps" section moved from CLI to GUI
* Minor changes;
* Comments.

## 4.0.32 — 20.04.2020

* Comments;
* Added Internet connection test in "Pin the shortcuts to Start" section to ensure syspin.exe will be downloaded from GitHub. Anyway it can be loaded locally;
* The following sections transferred from CLI to GUI
  * Turn on Controlled folder access and add protected folders;
  * Allow an app through Controlled folder access;
  * Add exclusion folder from Microsoft Defender Antivirus scanning;
  * Add exclusion file from Windows Defender Antivirus scanning.
* Minor changes.

## 4.0.31 — 10.04.2020

* Improved "Uninstall OneDrive" section;
  * Now it takes into account whether user signed in to OnedDrive;
* Added Xbox related apps to the exclusion list in "Uninstall all UWP apps from all accounts, except the followings..." section;
* Added "Uninstall all Xbox related UWP apps from all accounts" section;
* Comments;
* Minor changes.

## 4.0.30 — 08.04.2020

* Improved "Uninstall OneDrive" section. Thanks [westlife](http://forum.ru-board.com/profile.cgi?action=show&member=westlife);
* Added "Open Microsoft Store "HEVC Video Extensions from Device Manufacturer" page" section
* Comments;
* Minor changes.

## 4.0.29 — 05.04.2020

* Totally rewritten "Uninstall OneDrive" section
* "Turn off diagnostics tracking scheduled tasks" section
  * Now the "FODCleanupTask" task, related to Windows Hello, does not turn off if device is a laptop
* "Remove Windows capabilities" section
  * Now the "Hello.Face*" сapabilities, related to Windows Hello, does not removed if device is a laptop
* "Save screenshots by pressing Win+PrtScr to the Desktop" section
* "Set "High performance" in graphics performance preference for apps" section
* "Uninstall all UWP apps from all accounts" section
  * Now using "-Verbose" instead of "Write-Progress";
  * Added "Realtek Audio Console" app to the exclusion
* Comments;
* Minor changes.

## 4.0.28 — 20.03.2020

* Added "Do not show sync provider notification" section;
* "Save screenshots by pressing Win+PrtScr to the Desktop" section. To return the original value execute

  ```powershell
  Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{b7bede81-df94-4682-a7d8-57a52620b86f}" -Name RelativePath -Type String -Value Screenshots -Force
  ```

* Removed "Uninstall all provisioned UWP apps from System account, except the followings..." section
  * Using the "-AllUsers" key, applications were already deleted from all accounts
* Fixed all en dashes (0x2013). Thanks to [YuS_2](http://forum.ru-board.com/profile.cgi?action=show&member=YuS_2);
* Comments;
* Minor changes.

## 4.0.27 — 18.03.2020

* "Uninstall OneDrive" section
  * Now even after restarting File Explorer your opened folders will be restored
* "Uninstall all UWP apps from all accounts, except the followings..." section
* "Uninstall all provisioned UWP apps from System account, except the followings..." section
  * Now displays progress bar while uninstalling
* Deleted "Checking whether the script was saved in UTF-8 with BOM encoding if it runs locally" section
  * There is [no way](https://github.com/MicrosoftDocs/PowerShell-Docs/blob/staging/reference/docs-conceptual/components/vscode/understanding-file-encoding.md#common-causes-of-encoding-issues) for PowerShell to automatically determine the file encoding
  * Anyway this code checks the encoding

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

* Comments
* Minor changes.

## 4.0.26 — 16.03.2020

* Do not allow apps to use advertising ID. To delete unnecessary key execute

  ```powershell
  Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -Force
  ```

* Turn on acrylic taskbar transparency;
* Added "Show me the Windows welcome experiences after updates and occasionally when I sign in to highlight what's new and suggested" section;
* Added "Check for updates for UWP apps" section;
* Added "Do not suggest ways I can finish setting up my device to get the most out of Windows" section;
* Comments;
* Minor changes.

## 4.0.25 — 13.03.2020

* Added F5 pressing simulation to refresh the desktop
* Comments;
* Minor changes.

## 4.0.24 — 11.03.2020

* Turn on recycle bin files delete confirmation
  * Now configuring without using policy. To delete unnecessary key execute

  ```powershell
  Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name ConfirmFileDelete -Force
  ```

* Turn off Delivery Optimization
  * Now using cmdlets. To delete unnecessary key execute

  ```powershell
  Remove-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization -Force
  ```

* Rearranged "Set power management scheme for desktop and laptop" section
* Renamed sections
  * "Turn off hibernate" to "Turn off hibernate for devices, except laptops"
  * "Turn off location for this device" to "Turn off location access for this device"
* Minor changes.

## 4.0.23 — 06.03.2020

* Comments;
* Rewritten "Pin to Start the shortcuts" section;
  * Now using [syspin.exe](http://www.technosys.net/products/utils/pintotaskbar) to pin shortcuts
  * Hash (SHA256): 6967E7A3C2251812DD6B3FA0265FB7B61AADC568F562A98C50C345908C6E827
  * Shorcuts pinned by default:
    * Control Panel;
    * Devices and Printers;
    * Command Prompt.
* Minor changes.

## 4.0.22 — 03.03.2020

* Added Comment-Based Help;
* Fixed bug in a task to clear the $env:SystemRoot\SoftwareDistribution\Download folder;
* Minor changes.

## 4.0.21 — 25.02.2020

* Removed "Use Unicode UTF-8 for worldwide language support (beta)" section due to instability. To recover execute

  ```powershell
  # Open Administrative Tab in Region
  cmd.exe --% /c control intl.cpl,,1
  # Change system locale
  # Uncheck "Beta: Use Unicode UTF-8 for worldwide language support"
  # Restart PC
  ```

* Minor changes.

## 4.0.20 — 21.02.2020

* Removed "Let Windows track app launches to improve Start menu and search results" section. To recover execute

  ```powershell
  Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Start_TrackProgs -Force
  ```

* Removed "Turn off Windows Game Recording and Broadcasting" section. To recover execute

  ```powershell
  Remove-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR -Force
  ```

* Removed "Turn off Game Mode" section. To recover execute

  ```powershell
  Remove-ItemProperty -Path HKCU:\Software\Microsoft\GameBar -Name AllowAutoGameMode -Force
  ```

* Removed "Remove "Previous Versions" from file context menu" section. To recover execute

  ```powershell
  Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{596AB062-B4D2-4215-9F74-E9109B0A8153}" -Force
  ```

* Removed "Turn off "The Windows Filtering Platform has blocked a connection" message in "Windows Logs/Security"" section. To recover execute

  ```cmd
  auditpol /set /subcategory:"{0CCE9226-69AE-11D9-BED3-505054503030}" /success:enable /failure:enable
  ```

* Added
  * "Use Unicode UTF-8 for worldwide language support (beta)";
  * "Turn on logging for all Windows PowerShell modules";
  * "Turn on logging of all PowerShell script input to the Microsoft-Windows-PowerShell/Operational event log";
  * "Turn on events auditing generated when a process is created or starts".
* Comments
* Minor changes.

## 4.0.19 — 17.02.2020

* Uploaded file with UTF-8 with BOM encoding by default;
* Added "Checking the file encoding if it runs locally" section;
* Minor changes.

## 4.0.18 — 11.02.2020

* Fixed typo in "Unpin all Start menu tiles section;
* Updated "Uninstall OneDrive" section;
* Minor changes.

## 4.0.17 * 10.02.2020

* Now using "switch" operator in the interactive prompts;
* Comments;
* Minor changes.

## 4.0.16 — 04.02.2020

* Added OS edition detection to add proper value for the "AllowTelemetry" registry key.;
* "Stop event trace sessions" section;
* "Set the operating system diagnostic data level" section;
* "Unpin all Start menu tiles" section;
  * Now it's possible to skip unpinning all Start menu tiles
* Minor changes.

## 4.0.15 — 31.01.2020

* Added "Include command line in progress creation events" section;
* Added "Let track app launches to improve Start menu and search results" section;
* Removed "Do not let track app launches to improve Start menu and search results" section;
* Added "Stop event trace sessions" section;
* Updated "Turn off the data collectors at the next computer restart" section;
* Updated "Turn off diagnostics tracking scheduled tasks" section. Some tasks has been removed from the list. To recover execute

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

* Comments
* Minor changes.

## 4.0.14 — 15.11.2019

* Comments;
* Minor changes.

## 4.0.13 — 11.11.2019

* Added the detections of the OS bitness and PowerShell session;
* Minor changes.

## 4.0.12 — 08.11.2019

* Sections rearranged
* Comments
* Removed unnecessary "Turn off Cortana" section. To remove the key execute

  ```powershell
  Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force
  ```

* Removed unnecessary "Turn on Retpoline patch against Spectre v2" section;
* Removed unnecessary "Turn on firewall & network protection" section;
* "Enable System Restore" section redone into "Remove Shadow copies (restoration points)"
* Minor changes.

## 4.0.11 * 05.11.2019

"Uninstall UWP apps" section.

## 4.0.10 — 22.10.2019

* Improved "Turn off Windows features" and "Turn off default background apps, except the followings..." sections
* Total runtime reduced by ~ 10 sec.

## 4.0.9 — 21.10.2019

* Ready for Windows 10 November 2019 Update;
* Minor changes.

## 4.0.8 — 11.10.2019

* The "Save screenshots by pressing Win+PrtScr to the Desktop" section  was moved to the "Set location of the "Desktop", "Documents" "Downloads" "Music", "Pictures", and "Videos"" section
  * Fixes saving a screenshot when it was saved in the old desktop folder if the path to the desktop was changed after that.
* Reorganized the "UI & Personalization" directive
* Translations
* Removed unnecessary keys in the "OneDrive" section. To remove them, execute

  ```powershell
  Remove-Item -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive -Force
  Remove-ItemProperty -Path HKCU:\Software\Microsoft\OneDrive -Name DisablePersonalSync -Force
  ```

* Removed "Remove printers" section;
* Added "Sticky Notes" app to the exclusion list of a "Uninstall all UWP apps from all accounts except" section;
* Minor changes.

## 4.0.7 — 08.10.2019

* Added "Lock App" app to the exclusion list of a "Turn off default background apps except" section;
  * Fixes freeze when trying to open a link from lock screen when Windows spotlight enabled. To fix execute:

```powershell
$LockApp = (Get-AppxPackage -AllUsers | Where-Object -FilterScript {$_.PackageFamilyName -like "Microsoft.LockApp*"}).PackageFamilyName
$LockApp = $LockApp.Split(",")[0]
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\$LockApp" -Name * -Force
Write-Host "Restart required"
```

* Removed "Remove printers" section;
* Added "Sticky Notes" app to the exclusion list of a "Uninstall all UWP apps from all accounts except" section;
* Minor changes.

## 4.0.6 — 04.10.2019

* Added "Allow an app through Controlled folder access";
* Reorganized the tweaks, dividing into 11 categories:
  * Privacy;
  * UI & Personalization;
  * OneDrive;
  * System;
  * Start menu;
  * Edge;
  * UWP apps;
  * Windows Game Recording;
  * Scheduled tasks;
  * Microsoft Defender;
  * Context menu;
* Minor changes.

## 4.0.5 — 16.09.2019

* Added "Set the encoding to UTF-8 without BOM for the PowerShell session";
  * `ping.exe | Out-Null` used due to output is encoded with the default encoding despite changes (bug in .NET);
* Descriptions;
* Open shortcut to the Command Prompt from Start menu as Administrator;
* Added

  ```powershell
  New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 3 -Force
  ```

command to "Turn on automatic recommended troubleshooting and tell when problems get fixed" section due to the diagnostic data level needs to be set to "Full" in order to work;

* Minor changes.

## 4.0.4 — 09.09.2019

* Added "#Requires -RunAsAdministrator" statement;
* Removed all diagnostics tracking services except "DiagTrack";

 ```powershell
Get-Service -Name DusmSvc | Set-Service -StartupType Automatic
Get-Service -Name SSDPSRV | Set-Service -StartupType Manual
Get-Service -Name DusmSvc, SSDPSRV | Start-Service
 ```

* Added check whether the PC is a work station when applying the patch against Spectre v2;
* Added calculator to exceptions for uninstalling UWP applications;
* Added forced focus on the file open dialog;
* Minor changes.

## 4.0.3 — 02.09.2019

Removed Get-ResolvedPath function from script due to lack of need;
Fixed typo in "Show Task Manager details" section.

## 4.0.2 — 31.08.2019

Removed CDPSvc service from list due to Night ligth doesn't start.
Revert service backTurn the service back on:

```powershell
Get-Service -Name CDPSvc | Set-Service -StartupType Automatic
Get-Service -Name CDPSvc | Start-Service
```

## 4.0.1 — 29.08.2019

Fixed loop in "Set "High performance" in graphics performance preference for apps"

## 4.0.0 — 20.08.2019

* Turn off diagnostics tracking services,
* Uninstall all UWP apps from all accounts except,
* Turn off diagnostics tracking scheduled tasks;
  * The foreach instruction is no longer used;
  * Increased processing speed
* Import Start menu layout from pre-saved reg file;
  * Now it's possible to select a file to import through OpenFileDialog
* Turn on Windows Sandbox;
  * Changed the method for determining if a Hyper-V service is enabled
* Fixed typo in "Turn on Windows Sandbox"
* Minor changes.
