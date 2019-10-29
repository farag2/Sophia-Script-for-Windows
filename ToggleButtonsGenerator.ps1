$currentDir = $MyInvocation.MyCommand.Definition | Split-Path -Parent
$outFile = "{0}\ToggleButtonsGenerator.txt"-f $currentDir

if (Test-Path -Path $outFile) {
    Remove-Item -Path $outFile -Force -Confirm:$false
    Write-Warning -Message "File ""ToggleButtonsGenerator.txt"" deleted!"
}

"Privacy", "UI", "OneDrive", "System", "StartMenu", "Edge",
"UWPApps", "WindowsGameRecording", "ScheduledTasks", "MicrosoftDefender", "ContextMenu" | ForEach-Object {
    $categoryName = $_
    $categoryFile = "{0}\En\Settings-{1}.txt"-f $currentDir, $categoryName

    if (Test-Path -Path $categoryFile) {

        $text = Get-Content -Path $categoryFile

        for ($i = 0; $i -lt $text.Count; $i++) {

            $string = $text[$i]

            if ($string.Contains('"')) {
                $string = $text[$i].Replace('"', '&quot;')
            }

            if ($string.Contains('&')) {
                $string = $text[$i].Replace('&', '&amp;')
            }

            $toggleName = "Toggle_{0}_{1}" -f $categoryName, $i
            $textBlockName = "TextToggle_{0}_{1}" -f $categoryName, $i

            if ($i -eq 0) {
@"
<!--#region $categoryName Toggle-->
<StackPanel Name="PanelToggle_$categoryName" Style="{StaticResource PanelToggle}">
"@ | Out-File -FilePath $outFile -Append
            }

#region Write Toggle Buttons
@"

<Grid HorizontalAlignment="Left">
<ToggleButton Name="$toggleName" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="$string"
    FontSize="18" Margin="10" IsChecked="False" />
<TextBlock Name="$textBlockName" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
<TextBlock.Style>
<Style TargetType="TextBlock">
<Setter Property="Text" Value="Off" />
<Style.Triggers>
<DataTrigger Binding="{Binding ElementName=$toggleName, Path=IsChecked}" Value="True">
<Setter Property="Text" Value="On" />
</DataTrigger>
<DataTrigger Binding="{Binding ElementName=$toggleName, Path=IsEnabled}" Value="false">
<Setter Property="Opacity" Value="0.2" />
</DataTrigger>
</Style.Triggers>
</Style>
</TextBlock.Style>
</TextBlock>
</Grid>
"@ | Out-File -FilePath $outFile -Append
#endregion Write Toggle Buttons

        }

#region Write Placeholder
@"
</StackPanel>
<!--#endregion $categoryName Toggle-->

"@ | Out-File -FilePath $outFile -Append
#endregion Write Placeholder

        Write-Warning -Message "File ""ToggleButtonsGenerator.txt"" created!"
    }

    else {
        Write-Warning -Message "File ""$categoryFile"" not found!"
    }
}