#region Privacy & Telemetry Normalized Text
$textPrivacy = "Change Windows Feedback frequency to &quot;Never&quot;",
"Turn off automatic installing suggested apps",
"Turn off &quot;Connected User Experiences and Telemetry&quot; service",
"Turn off the SQMLogger session at the next computer restart",
"Do not allow apps to use advertising ID",
"Do not use sign-in info to automatically finish setting up device after an update or restart", "Do not let websites provide locally relevant content by accessing language list",
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
#endregion Privacy & Telemetry Normalized Text

#region UI & Personalization Normalized Text
$textUi = "Set the Control Panel view by large icons",
"Hide search box or search icon on taskbar",
"Turn off &quot;New App Installed&quot; notification",
"Turn off automatically hiding scroll bars",
"Hide all folders in the navigation pane",
"Hide &quot;Frequent folders&quot; in Quick access",
"Choose theme color for default app mode",
"Show File Name Extensions",
"Show &quot;This PC&quot; on Desktop",
"Show Task Manager details",
"Remove Microsoft Edge shortcut from the Desktop",
"Import Start menu layout from pre-saved reg file",
"Show more details in file transfer dialog",
"Turn off recently added apps on Start Menu",
"Remove the &quot;Previous Versions&quot; tab from properties context menu",
"Show more Windows Update restart notifications about restarting",
"Turn off check boxes to select items",
"Turn on acrylic taskbar transparency",
"Always show all icons in the notification area",
"Hide &quot;Windows Ink Workspace&quot; button in taskbar",
"Hide Task View button on taskbar",
"Turn off thumbnail cache removal",
"Show accent color on the title bars and window borders",
"Save screenshots by pressing Win+PrtScr to the Desktop",
"Turn on ribbon in File Explorer",
"Turn on recycle bin files delete confirmation",
"Choose theme color for default Windows mode",
"Turn off user first sign-in animation",
"Let Windows try to fix apps so they're not blurry",
"Turn off the &quot;- Shortcut&quot; name extension for new shortcuts",
"Turn off JPEG desktop wallpaper import quality reduction",
"Unpin Microsoft Edge and Microsoft Store from taskbar",
"Show seconds on taskbar clock",
"Hide People button on the taskbar",
"Turn off Snap Assist",
"Show Hidden Files, Folders, and Drives",
"Show folder merge conflicts",
"Hide &quot;Recent files&quot; in Quick access",
"Turn off creation of an Edge shortcut on the desktop for each user profile",
"Remove 3D Objects folder in &quot;This PC&quot; and in the navigation pane",
"Turn off app launch tracking to improve Start menu and search results",
"Set File Explorer to open to This PC by default"
#endregion UI & Personalization Normalized Text

#region System
$text = "Group svchost.exe processes",
"Remove Windows capabilities",
"Turn on Num Lock at startup",
"Turn on the display of stop error information on the BSoD",
"Always wait for the network at computer startup and logon",
"Turn on Storage Sense to automatically free up space",
"Set the default input method to the English language",
"Do not allow the computer to turn off the device to save power for desktop",
"Turn off &quot;The Windows Filtering Platform has blocked a connection&quot; message",
"Turn off default background apps except",
"Turn off SmartScreen for apps and files",
"Turn on .NET 4 runtime for all apps",
"Launch folder in a separate process",
"Turn off hibernate",
"Uninstall Onedrive",
"Delete temporary files that apps aren't using",
"Turn on automatic recommended troubleshooting",
"Delete files in recycle bin if they have been there for over 30 days",
"Open shortcut to the Command Prompt from Start menu as Administrator",
"Turn off app suggestions on Start menu",
"Turn
on firewall & network protection",
"Remove printers",
"Turn on Windows Sandbox",
"Turn off sticky Shift key after pressing 5 times",
"Set power management scheme for desktop and laptop",
"Turn off Windows Script Host",
"Set &quot;High performance&quot; in graphics performance preference for apps",
"Automatically adjust active hours for me based on daily usage",
"Turn on automatic backup the system registry to the 'C:\Windows\System32\config\RegBack' folder",
"Set location of the &quot;Desktop&quot;, &quot;Documents&quot; &quot;Downloads&quot; &quot;Music&quot;, &quot;Pictures&quot; and &quot;Videos&quot;",
"Use the PrtScn
button to open screen snipping",
"Create old style shortcut for &quot;Devices and Printers&quot; in 'C:\Users\dmitriy.demin\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools'",
"Turn off F1 Help key",
"Turn on Win32 long paths",
"Turn on Retpoline patch against Spectre v2",
"Do not preserve zone information",
"Change environment variable for 'C:\Temp' to 'C:\Temp'",
"Run Storage Sense every month",
"Never delete files in &quot;Downloads&quot; folder",
"Turn off location for this device",
"Turn off Admin Approval Mode for administrators",
"Turn off Windows features",
"Turn on updates for other Microsoft products",
"Enable System Restore",
"Do not allow Windows 10 to manage default printer",
"Turn on access to mapped
drives from app running with elevated permissions with Admin Approval Mode enabled",
"Set download mode for delivery optization on &quot;HTTP only&quot;",
"Turn off Cortana"
#endregion System

#region Toggle Buttons Generator
if (Test-Path -Path "C:\Tmp\toggleButtons.txt") {
    Remove-Item -Path "C:\Tmp\toggleButtons.txt" -Force -Confirm:$false
}

$toggleSwitchName = "ToggleSwitchSystem" # For UI & Personalization Settings

#"ToggleSwitchPrivacy" # For Privacy & Telemetry Settings
#"ToggleSwitchUi" # For UI & Personalization Settings
#"ToggleSwitchSystem" # For System Settings

$texBoxName = "TexBlockSystem" # For UI & Personalization Settings
#"TexBlockPrivacy" # For Privacy & Telemetry Settings
#"TexBlockUi" # For UI & Personalization Settings
#"TexBlockSystem" # For System Settings

for ($i = 0; $i -lt $text.Length; $i++) {
    $content = $text[$i].Replace("""", "&quot;")
    @"
<Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
<StackPanel Orientation="Horizontal" Margin="10">
<Grid HorizontalAlignment="Left">
<ToggleButton Name="$toggleSwitchName$i" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
<TextBlock Name="$texBoxName$i" Text="$content" Margin="65 0 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
<TextBlock.Style>
<Style TargetType="{x:Type TextBlock}">
<Style.Triggers>
<DataTrigger Binding="{Binding ElementName=$toggleSwitchName$i, Path=IsChecked}" Value="True">
<Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
</DataTrigger>
<DataTrigger Binding="{Binding ElementName=$toggleSwitchName$i, Path=IsEnabled}" Value="false">
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
    # Add Placeholder Panel to Group End
    if ($i -eq ($text.Length - 1)) {
@"
<!--Placeholder Panel-->
<StackPanel Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Height="{Binding ElementName=BorderPrivacy, Path=Height}" Background="Transparent"/>
"@ | Out-File -FilePath "C:\Tmp\toggleButtons.txt" -Append    
    }

}
#endregion Toggle Buttons Generator