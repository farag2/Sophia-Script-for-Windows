# Clear-Host
# $sourceText = Get-Content -Path "C:\Tmp\text.txt"


# for ($i = 0; $i -lt $sourceText.Count; $i++) {
    
#     if ($i % 2 -eq 0) {
#         $string += """{0}"","-f $sourceText[$i].Replace("# ","")
#     }
# }

#region Eng Description
# $text = "Turn off ""Connected User Experiences and Telemetry"" service","Turn off per-user services","Turn off the Autologger session at the next computer restart",
# "Turn off the SQMLogger session at the next computer restart","Set the operating system diagnostic data level to ""Basic""","Turn off Windows Error Reporting","Change Windows Feedback frequency to ""Never""",
# "Turn off diagnostics tracking scheduled tasks","Do not offer tailored experiences based on the diagnostic data setting","Do not let apps on other devices open and message apps&#x0a;on this device, and vice versa",
# "Do not allow apps to use advertising ID","Do not use sign-in info to automatically finish setting&#x0a;up device after an update or restart","Do not let websites provide locally relevant content by&#x0a;accessing language list",
# "Turn off reserved storage","Turn off tip, trick, and suggestions as you use Windows","Turn off suggested content in the Settings","Turn off automatic installing suggested apps","Set File Explorer to open to This PC by default",
# "Show Hidden Files, Folders, and Drives","Show File Name Extensions","Hide Task View button on taskbar","Show folder merge conflicts","Turn off Snap Assist","Turn off check boxes to select items","Show seconds on taskbar clock",
# "Hide People button on the taskbar","Hide all folders in the navigation pane","Turn on acrylic taskbar transparency","Turn off app launch tracking to improve Start menu and search results","Show ""This PC"" on Desktop",
# "Show more details in file transfer dialog","Remove the ""Previous Versions"" tab from properties context menu","Always show all icons in the notification area","Set the Control Panel view by large icons",
# "Remove 3D Objects folder in ""This PC"" and in the navigation pane","Hide ""Frequent folders"" in Quick access","Hide ""Recent files"" in Quick access","Turn off creation of an Edge shortcut on the desktop for each user profile",
# "Hide ""Windows Ink Workspace"" button in taskbar","Hide search box or search icon on taskbar","Turn on recycle bin files delete confirmation","Turn on ribbon in File Explorer","Choose theme color for default Windows mode",
# "Choose theme color for default app mode","Turn off ""New App Installed"" notification","Turn off recently added apps on Start Menu", "Turn off thumbnail cache removal","Turn off user first sign-in animation",
# "Turn off JPEG desktop wallpaper import quality reduction","Show Task Manager details","Unpin Microsoft Edge and Microsoft Store from taskbar","Remove Microsoft Edge shortcut from the Desktop",
# "Let Windows try to fix apps so they're not blurry","Import Start menu layout from pre-saved reg file","Show accent color on the title bars and window borders","Turn off automatically hiding scroll bars",
# "Save screenshots by pressing Win+PrtScr to the Desktop","Show more Windows Update restart notifications about restarting","Turn off the ""- Shortcut"" name extension for new shortcuts",
# "Turn on Storage Sense to automatically free up space","Run Storage Sense every month","Delete temporary files that apps aren't using","Delete files in recycle bin if they have been there for over 30 days",
# "Never delete files in ""Downloads"" folder","Turn off app suggestions on Start menu","Turn off hibernate","Turn off location for this device","Change environment variable for $env:TEMP to $env:SystemDrive\Temp",
# "Turn on Win32 long paths","Group svchost.exe processes","Turn on Retpoline patch against Spectre v2","Turn on the display of stop error information on the BSoD","Do not preserve zone information",
# "Turn off Admin Approval Mode for administrators","Turn on access to mapped drives from app running with elevated permissions with Admin Approval Mode enabled","Set download mode for delivery optization on ""HTTP only""",
# "Always wait for the network at computer startup and logon","Turn off Cortana","Do not allow Windows 10 to manage default printer","Turn off Windows features","Remove Windows capabilities","Uninstall Onedrive",
# "Turn on updates for other Microsoft products","Enable System Restore","Turn off Windows Script Host","Turn off default background apps except","Set power management scheme for desktop and laptop",
# "Turn on .NET 4 runtime for all apps","Turn on firewall &amp; network protection","Do not allow the computer to turn off the device to save power for desktop","Set the default input method to the English language",
# "Remove printers","Turn on Windows Sandbox","Open shortcut to the Command Prompt from Start menu as Administrator","Use the PrtScn button to open screen snipping",
# "Create old style shortcut for ""Devices and Printers"" in ""$env:APPDATA\Microsoft\Windows\Start Menu\Programs\System Tools""","Set location of the ""Desktop"", ""Documents"" ""Downloads"" ""Music"", ""Pictures"", and ""Videos""",
# "Turn on automatic recommended troubleshooting","Set ""High performance"" in graphics performance preference for apps","Automatically adjust active hours for me based on daily usage",
# "Launch folder in a separate process","Turn on automatic backup the system registry to the ""$env:SystemRoot\System32\config\RegBack"" folder","Turn off ""The Windows Filtering Platform has blocked a connection"" message",
# "Turn off SmartScreen for apps and files","Turn off F1 Help key","Turn on Num Lock at startup","Turn off sticky Shift key after pressing 5 times","Turn off Windows Defender SmartScreen for Microsoft Edge",
# "Do not allow Microsoft Edge to start and load the Start and New Tab page at Windows startup and each time Microsoft Edge is closed",
# "Do not allow Microsoft Edge to pre-launch at Windows startup, when the system is idle, and each time Microsoft Edge is closed","Uninstall all UWP apps from all accounts except","Uninstall all UWP apps from all accounts except",
# "Turn off Windows Game Recording and Broadcasting","Turn off Game Bar","Turn off Game Mode","Turn off Game Bar tips","Create scheduled task with the disk cleanup tool in Task Scheduler. The task runs every 90 days",
# "Create task to clean out the ""$env:SystemRoot\SoftwareDistribution\Download"" folder in Task Scheduler","Create scheduled task with the $env:TEMP folder cleanup in Task Scheduler. The task runs every 62 days",
# "Add folder to exclude from Windows Defender Antivirus scan","Turn on Windows Defender Exploit Guard Network Protection","Turn on Controlled folder access and add protected folders",
# "Turn on Windows Defender PUA Protection","Hide notification about sign in with Microsoft in the Windows Security","Hide notification about disabled Smartscreen for Microsoft Edge","Turn on Windows Defender Sandbox",
# "Add ""Extract"" to MSI file type context menu","Add ""Run as different user"" from context menu for .exe file type","Add ""Install"" to CAB file type context menu","Remove ""Cast to Device"" from context menu",
# "Remove ""Share"" from context menu","Remove ""Previous Versions"" from file context menu","Remove ""Edit with Paint 3D"" from context menu","Remove ""Include in Library"" from context menu",
# "Remove ""Turn on BitLocker"" from context menu","Remove ""Edit with Photos"" from context menu","Remove ""Create a new video"" from Context Menu","Remove ""Edit"" from Context Menu",
# "Remove ""Print"" from batch and cmd files context menu","Remove ""Compressed (zipped) Folder"" from context menu","Remove ""Rich Text Document"" from context menu","Remove ""Bitmap image"" from context menu",
# "Remove ""Send to"" from folder context menu","Make the ""Open"", ""Print"", ""Edit"" context menu items available, when more than 15 selected","Turn off ""Look for an app in the Microsoft Store"" in ""Open with"" dialog"
#endregion Eng Description

#region Privacy & Telemetry Normalized
$text = "Change Windows Feedback frequency to &quot;Never&quot;",
"Turn off automatic installing suggested apps",
"Turn off &quot;Connected User Experiences and Telemetry&quot; service",
"Turn off the SQMLogger session at the next computer restart",
"Do not allow apps to use advertising ID",
"Do not use sign-in info to automatically finish setting up device after an update or restart","Do not let websites provide locally relevant content by accessing language list",
"Turn off suggested content in the Settings",
"Turn off tip, trick, and suggestions as you use Windows",
"Turn off reserved storage",
"Do not let apps on other devices open and message apps on this device, and vice versa",
"Set the operating system diagnostic data level to &quot;Basic&quot;",
"Turn off the Autologger session at the next computer restart",
"Turn off per-user services",
"Do not offer tailored experiences based on the diagnostic data setting",
"Turn off diagnostics tracking scheduled tasks",
"Turn off Windows Error Reporting"
#endregion Privacy & Telemetry Normalized

#region Normalize Text by Length
# $textLength = New-Object System.Collections.ArrayList($null)

# for ($i = 0; $i -lt 17; $i++) {    
#     $obj = New-Object -TypeName PSObject -Property @{TextLength = $text[$i].Length; Text = $text[$i]}
#     [void]$textLength.Add($obj)
# }

# ($textLength | Group-Object -Property TextLength | Sort-Object -Property Count -Descending).Group.Text -replace """", "&quot;" | ForEach-Object {
#     """{0}"","-f $_
# }
#endregion Normalize Text by Length

#region Toggle Buttons Generator

# Privacy & Telemetry: $i = 0; $i -lt 17 ; $i++

if (Test-Path -Path "C:\Tmp\toggleButtons.txt") {
    Remove-Item -Path "C:\Tmp\toggleButtons.txt" -Force -Confirm:$false
}

for ($i = 0; $i -lt $text.Length; $i++) {
    $content = $text[$i].Replace("""", "&quot;")
@"
<Border BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Background="#FFFFFF">
<StackPanel Orientation="Horizontal" Margin="10">
<Grid HorizontalAlignment="Left">
<ToggleButton Name="ToggleSwitch$i" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
<TextBlock Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
<TextBlock.Style>
<Style TargetType="TextBlock" BasedOn="{StaticResource TextBlockStyle}">
<Setter Property="Text" Value="$content" />
<Style.Triggers>
<DataTrigger Binding="{Binding ElementName=ToggleSwitch$i, Path=IsChecked}" Value="True">
<Setter Property="Text" Value="$content"/>
<Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
</DataTrigger>
<DataTrigger Binding="{Binding ElementName=ToggleSwitch$i, Path=IsEnabled}" Value="false">
<Setter Property="Opacity" Value="0.2" />
</DataTrigger>
</Style.Triggers>
</Style>
</TextBlock.Style>
</TextBlock>
</Grid>
</StackPanel>
</Border>
"@ | Out-File -FilePath "C:\Tmp\toggleButtons.txt" -Append
}
#endregion Toggle Buttons Generator