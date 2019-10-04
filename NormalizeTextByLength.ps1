$text = ""

$textLength = New-Object System.Collections.ArrayList($null)

for ($i = 0; $i -lt $text.Length; $i++) {    
    $obj = New-Object -TypeName PSObject -Property @{TextLength = $text[$i].Length; Text = $text[$i] }
    [void]$textLength.Add($obj)
}

($textLength | Group-Object -Property TextLength | Sort-Object -Property Count -Descending).Group.Text -replace """", "&quot;" | ForEach-Object {
    """{0}""," -f $_
}