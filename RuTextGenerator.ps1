$currentDir = $MyInvocation.MyCommand.Definition | Split-Path -Parent
$outFile = "{0}\RuTextGenerator.txt"-f $currentDir

if (Test-Path -Path $outFile) {
    Remove-Item -Path $outFile -Force -Confirm:$false
    Write-Warning -Message "File ""RuTextGenerator.txt"" deleted!"
}

"Privacy", "UI", "OneDrive", "System", "StartMenu", "Edge",
"UWPApps", "WindowsGameRecording", "ScheduledTasks", "MicrosoftDefender", "ContextMenu" | ForEach-Object {
    
    $categoryName = $_
    $categoryFile = "{0}\Ru\Settings-{1}.txt"-f $currentDir, $categoryName

    if (Test-Path -Path $categoryFile) {
@"
######################### $categoryName #########################
"@ | Out-File -FilePath $outFile -Append

    $text = Get-Content -Path $categoryFile

    for ($i = 0; $i -lt $text.Count; $i++) {
        """{0}"", "-f $text[$i] | Out-File -FilePath $outFile -Append
    }
}

else {
    Write-Warning -Message "File ""$categoryFile"" not found!"
}

}