$string = $null
$sourceText = Get-Content -Path "C:\Tmp\text.txt"
for ($i = 0; $i -lt $sourceText.Count; $i++) {
    
    if ($i % 2 -eq 0) {
        $string += """{0}"","-f $sourceText[$i].Replace("# ","")
    }
}


$text = "Add ""Extract"" to MSI file type context menu","Add ""Run as different user"" from context menu for .exe file type","Add ""Install"" to CAB file type context menu","Remove ""Cast to Device"" from context menu","Remove ""Share"" from context menu","Remove ""Previous Versions"" from file context menu","Remove ""Edit with Paint 3D"" from context menu","Remove ""Include in Library"" from context menu","Remove ""Turn on BitLocker"" from context menu","Remove ""Edit with Photos"" from context menu","Remove ""Create a new video"" from Context Menu","Remove ""Edit"" from Context Menu","Remove ""Print"" from batch and cmd files context menu","Remove ""Compressed (zipped) Folder"" from context menu","Remove ""Rich Text Document"" from context menu","Remove ""Bitmap image"" from context menu","Remove ""Send to"" from folder context menu","Make the ""Open"", ""Print"", ""Edit"" context menu items available, when more than 15 selected","Turn off ""Look for an app in the Microsoft Store"" in ""Open with"" dialog"

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