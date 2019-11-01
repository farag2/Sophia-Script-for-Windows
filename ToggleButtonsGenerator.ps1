$currentDir = $MyInvocation.MyCommand.Definition | Split-Path -Parent
$outFile = "{0}\ToggleButtonsGenerator.txt"-f $currentDir

if (Test-Path -Path $outFile) {
    Remove-Item -Path $outFile -Force -Confirm:$false
    Write-Warning -Message "File ""ToggleButtonsGenerator.txt"" deleted!"
}

"Privacy", "Ui", "OneDrive", "System", "StartMenu", "Edge", "Uwp", "Game", "Tasks", "Defender", "ContextMenu" | ForEach-Object {
    
	$categoryName = $_
    $categoryFile = "{0}\En\{1}.txt"-f $currentDir, $categoryName

    if (Test-Path -Path $categoryFile) {

        $text = Get-Content -Path $categoryFile
		
@"
<!--#region $categoryName Toggles-->
<StackPanel Name="PanelToggle_$categoryName" Style="{StaticResource PanelToggle}">
"@ | Out-File -FilePath $outFile -Append            

        for ($i = 0; $i -lt $text.Count; $i++) {

            $string = $text[$i]
			$toggleName = "Toggle_{0}_{1}" -f $categoryName, $i
            $textBlockName = "TextToggle_{0}_{1}" -f $categoryName, $i

@"

<Border Style="{StaticResource ToggleBorder}">
<DockPanel Margin="0 10 0 10">
<Grid HorizontalAlignment="Left">
<ToggleButton Name="$toggleName" Style="{StaticResource ToggleSwitchLeftStyle}" IsChecked="False"/>
<TextBlock Name="$textBlockName" Text="$string" Margin="65 0 10 0" VerticalAlignment="Center" TextWrapping="Wrap" IsHitTestVisible="False">
<TextBlock.Style>
<Style TargetType="{x:Type TextBlock}">
<Style.Triggers>
<DataTrigger Binding="{Binding ElementName=$toggleName, Path=IsChecked}" Value="True">
<Setter Property="Foreground" Value="#3F51B5"/>
</DataTrigger>                                                    
</Style.Triggers>
</Style>
</TextBlock.Style>
</TextBlock>
</Grid>
</DockPanel>
</Border>
"@ | Out-File -FilePath $outFile -Append
        }

@"
</StackPanel>
<!--#endregion $categoryName Toggles-->

"@ | Out-File -FilePath $outFile -Append


        Write-Warning -Message "File ""ToggleButtonsGenerator.txt"" created!"
    }

    else {
        Write-Warning -Message "File ""$categoryFile"" not found!"
    }
}