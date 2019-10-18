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

#region Write Header
@"
######################### $categoryName #########################
<StackPanel Orientation="Horizontal">
<TextBlock Name="Header_$categoryName" Text="$categoryName" Style="{StaticResource ToggleHeaderTextBlock}"/>
</StackPanel>
"@ | Out-File -FilePath $outFile -Append
#endregion Write Header        
        
        $text = Get-Content -Path $categoryFile

        for ($i = 0; $i -lt $text.Count; $i++) {
            
            $string = $text[$i]

            if ($string.Contains('"')) {
                $string = $text[$i].Replace('"', '&quot;')
            }

            if ($string.Contains('&')) {
                $string = $text[$i].Replace('&', '&amp;')
            }

            $toggleName = "ToggleSwitch_{0}_{1}"-f $categoryName, $i
            $textBlockName = "TextBlock_{0}_{1}"-f $categoryName, $i

#region Write Toggle Buttons
@"
<Border Style="{StaticResource ToggleBorder}">
<StackPanel Orientation="Horizontal" Margin="5">
<Grid HorizontalAlignment="Left">
<ToggleButton Name="$toggleName" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
<TextBlock Name="$textBlockName" Text="$string" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
<TextBlock.Style>
<Style TargetType="{x:Type TextBlock}">
<Style.Triggers>
<DataTrigger Binding="{Binding ElementName=$toggleName, Path=IsChecked}" Value="True">
<Setter Property="Foreground" Value="#0078d7"/>
</DataTrigger>
<DataTrigger Binding="{Binding ElementName=$toggleName, Path=IsEnabled}" Value="false">
<Setter Property="Opacity" Value="0.2" />
</DataTrigger>
</Style.Triggers>
</Style>
</TextBlock.Style>
</TextBlock>
</Grid>
</StackPanel>
</Border>
"@ | Out-File -FilePath $outFile -Append
#endregion Write Toggle Buttons

        }

#region Write Placeholder
@"
<!--#region Category End Placeholder-->
<Border Style="{StaticResource ToggleBorder}"/>
<!--#endregion Category End Placeholder-->
"@ | Out-File -FilePath $outFile -Append
#endregion Write Placeholder

        Write-Warning -Message "File ""ToggleButtonsGenerator.txt"" created!"
    }

    else {
        Write-Warning -Message "File ""$categoryFile"" not found!"
    }
}