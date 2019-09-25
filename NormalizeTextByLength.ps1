$string = $null
$sourceText = Get-Content -Path "C:\Tmp\text.txt"
for ($i = 0; $i -lt $sourceText.Count; $i++) {
    
    if ($i % 2 -eq 0) {
        $string += """{0}"","-f $sourceText[$i].Replace("# ","")
    }
}


$text = "Turn on Storage Sense to automatically free up space","Run Storage Sense every month","Delete temporary files that apps aren't using","Delete files in recycle bin if they have been there for over 30 days","Never delete files in ""Downloads"" folder","Turn off app suggestions on Start menu","Turn off hibernate","Turn off location for this device","Change environment variable for '$env:TEMP' to '$env:SystemDrive\Temp'","Turn on Win32 long paths","Group svchost.exe processes","Turn on Retpoline patch against Spectre v2","Turn on the display of stop error information on the BSoD","Do not preserve zone information","Turn off Admin Approval Mode for administrators","Turn on access to mapped
drives from app running with elevated permissions with Admin Approval Mode enabled","Set download mode for delivery optization on ""HTTP only""","Always wait for the network at computer startup and logon","Turn off Cortana","Do not allow Windows 10 to manage default printer","Turn off Windows features","Remove Windows capabilities","Uninstall Onedrive","Turn on updates for other Microsoft products","Enable System Restore","Turn off Windows Script Host","Turn off default background apps except","Set power management scheme for desktop and laptop","Turn on .NET 4 runtime for all apps","Turn
on firewall & network protection","Do not allow the computer to turn off the device to save power for desktop","Set the default input method to the English language","Remove printers","Turn on Windows Sandbox","Open shortcut to the Command Prompt from Start menu as Administrator","Use the PrtScn
button to open screen snipping","Create old style shortcut for ""Devices and Printers"" in '$env:APPDATA\Microsoft\Windows\Start Menu\Programs\System Tools'","Set location of the ""Desktop"", ""Documents"" ""Downloads"" ""Music"", ""Pictures"" and ""Videos""","Turn on automatic recommended troubleshooting","Set ""High performance"" in graphics performance preference for apps","Automatically adjust active hours for me based on daily usage","Launch folder in a separate process","Turn on automatic backup the system registry to the '$env:SystemRoot\System32\config\RegBack' folder","Turn off ""The Windows Filtering Platform has blocked a connection"" message","Turn off SmartScreen for apps and files","Turn off F1 Help key","Turn on Num Lock at startup","Turn off sticky Shift key after pressing 5 times"

#region Normalize Text by Length
$textLength = New-Object System.Collections.ArrayList($null)

for ($i = 0; $i -lt $text.Length; $i++) {    
    $obj = New-Object -TypeName PSObject -Property @{TextLength = $text[$i].Length; Text = $text[$i] }
    [void]$textLength.Add($obj)
}

($textLength | Group-Object -Property TextLength | Sort-Object -Property Count -Descending).Group.Text -replace """", "&quot;" | ForEach-Object {
    """{0}""," -f $_
}
#endregion Normalize Text by Length