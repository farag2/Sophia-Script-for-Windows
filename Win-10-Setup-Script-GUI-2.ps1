Add-Type -AssemblyName "PresentationCore", "PresentationFramework", "WindowsBase"

[xml]$xamlMarkup = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"                        
        Name="Window"
        Title="Windows 10 Setup Script" Height="933" Width="969" MinHeight="933" MinWidth="969"
        Background="Transparent"        
        FontFamily="Sergio UI" FontSize="16" TextOptions.TextFormattingMode="Display" WindowStartupLocation="CenterScreen"
        SnapsToDevicePixels="True" WindowStyle="None" ResizeMode="CanResizeWithGrip" AllowsTransparency="True" 
        ShowInTaskbar="True" Foreground="{DynamicResource {x:Static SystemColors.WindowTextBrushKey}}">
    <Window.Resources>
        <Style x:Key="TitlePanelCloseHover" TargetType="StackPanel">
            <Setter Property="Orientation" Value="Horizontal"/>
            <Setter Property="Height" Value="35"/>
            <Setter Property="Width" Value="35"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#FF1744"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="TitlePanelHover" TargetType="StackPanel" BasedOn="{StaticResource TitlePanelCloseHover}">
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#E6E6E6"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="TitleButtonViewBox" TargetType="Viewbox">
            <Setter Property="Width" Value="24"/>
            <Setter Property="Height" Value="24"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="HorizontalAlignment" Value="Center"/>
            <Setter Property="Margin" Value="5 0 0 0"/>
        </Style>

        <Style x:Key="ActionButtonViewBox" TargetType="Viewbox" BasedOn="{StaticResource TitleButtonViewBox}">
            <Setter Property="Margin" Value="10 0 0 0"/>
        </Style>

        <Style x:Key="ActionButtonPanel" TargetType="StackPanel">
            <Setter Property="Grid.Column" Value="0"/>
            <Setter Property="Orientation" Value="Horizontal"/>
            <Setter Property="Height" Value="40"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="Margin" Value="0 0 0 5"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#E6E6E6"/>
                </Trigger>
                <EventTrigger RoutedEvent="MouseDown">
                    <EventTrigger.Actions>
                        <BeginStoryboard>
                            <Storyboard>
                                <ThicknessAnimation Storyboard.TargetProperty="Margin" Duration="0:0:0.5" To="0 5 0 0" SpeedRatio="5" AutoReverse="True"/>
                            </Storyboard>
                        </BeginStoryboard>
                    </EventTrigger.Actions>
                </EventTrigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="ActionButtonTextBlock" TargetType="TextBlock">
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="HorizontalAlignment" Value="Center"/>
            <Setter Property="Margin" Value="10 2 20 0"/>
            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
        </Style>        

    </Window.Resources>
    <Border Name="BorderWindow" BorderThickness="1" BorderBrush="#0078d7">
        <Grid>
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>
            <!--Transparent Panel-->
            <StackPanel Grid.Column="0" Width="280" Background="#FAFAFA" Opacity="0.96" Orientation="Vertical"/>
            <!--Non-transparent Panel-->
            <StackPanel Name="PanelToggle" Grid.Column="1" Background="#FFFFFF" Orientation="Vertical"/>
            <!--#region Window Title-->
            <StackPanel Name="WindowTitleLogo" Grid.Column="0" Orientation="Horizontal" Height="40" VerticalAlignment="Top">
                <!--Icon-->
                <Viewbox Width="28" Height="28" HorizontalAlignment="Left" Margin="10 0 10 0">
                    <Canvas Width="24" Height="24">
                        <Path Data="M3,12V6.75L9,5.43V11.91L3,12M20,3V11.75L10,11.9V5.21L20,3M3,13L9,13.09V19.9L3,18.75V13M20,13.25V22L10,20.09V13.1L20,13.25Z" Fill="{Binding ElementName=BorderWindow,Path=BorderBrush}" />
                    </Canvas>
                </Viewbox>
                <!--Title Text-->
                <TextBlock Text="{Binding ElementName=Window, Path=Title}" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}" VerticalAlignment="Center" Margin="0 5 0 0"/>
            </StackPanel>
            <StackPanel Grid.Column="1" Orientation="Horizontal" VerticalAlignment="Top" HorizontalAlignment="Right">
                <!--Minimize Button-->
                <StackPanel Name="ButtonTitleMin" Style="{StaticResource TitlePanelHover}">
                    <Viewbox Style="{StaticResource TitleButtonViewBox}">
                        <Canvas Width="24" Height="24">
                            <Path Data="M20,14H4V10H20" Fill="{Binding ElementName=Window,Path=Foreground}" />
                        </Canvas>
                    </Viewbox>
                </StackPanel>
                <!--Maximize Button-->
                <StackPanel Name="ButtonTitleMax" Style="{StaticResource TitlePanelHover}">
                    <Viewbox Style="{StaticResource TitleButtonViewBox}">
                        <Canvas Width="24" Height="24">
                            <Path Data="M4,4H20V20H4V4M6,8V18H18V8H6Z" Fill="{Binding ElementName=Window,Path=Foreground}" />
                        </Canvas>
                    </Viewbox>
                </StackPanel>
                <!--Close Button-->
                <StackPanel Name="ButtonTitleClose" Style="{StaticResource TitlePanelCloseHover}">
                    <Viewbox Style="{StaticResource TitleButtonViewBox}">
                        <Canvas Width="24" Height="24">
                            <Path Data="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z" Fill="{Binding ElementName=Window,Path=Foreground}" />
                        </Canvas>
                    </Viewbox>
                </StackPanel>
            </StackPanel>

            <!--#endregion Window Title Panel-->
            <!--#region Action Buttons-->
            <StackPanel Name="PanelActionButtons" Orientation="Vertical" VerticalAlignment="Top" Margin="0 50 0 0">
                <!--#region Privacy Button-->
                <StackPanel Style="{StaticResource ActionButtonPanel}">
                    <Viewbox Style="{StaticResource ActionButtonViewBox}">
                        <Canvas Width="24" Height="24">
                            <Path Name="IconActionPrivacy" Data="M4,4A2,2 0 0,0 2,6V17A2,2 0 0,0 4,19V20H6V19H17V20H19V19A2,2 0 0,0 21,17V16H22V14H21V9H22V7H21V6A2,2 0 0,0 19,4H4M4,6H19V17H4V6M13.5,7.5A4,4 0 0,0 9.5,11.5A4,4 0 0,0 13.5,15.5A4,4 0 0,0 17.5,11.5A4,4 0 0,0 13.5,7.5M5,9V14H7V9H5M13.5,9.5A2,2 0 0,1 15.5,11.5A2,2 0 0,1 13.5,13.5A2,2 0 0,1 11.5,11.5A2,2 0 0,1 13.5,9.5Z" Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}" />
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="TextBlockActionPrivacy" Text="PRIVACY &amp; TELEMETRY" Style="{StaticResource ActionButtonTextBlock}"/>                    
                </StackPanel>
                <!--#endregion Privacy Button-->

                <!--#region UI & Personalization Button-->
                <StackPanel Style="{StaticResource ActionButtonPanel}">
                    <Viewbox Style="{StaticResource ActionButtonViewBox}">
                        <Canvas Width="24" Height="24">
                            <Path Data="M4 4C2.89 4 2 4.89 2 6V18C2 19.11 2.9 20 4 20H12V18H4V8H20V12H22V8C22 6.89 21.1 6 20 6H12L10 4M18 14C17.87 14 17.76 14.09 17.74 14.21L17.55 15.53C17.25 15.66 16.96 15.82 16.7 16L15.46 15.5C15.35 15.5 15.22 15.5 15.15 15.63L14.15 17.36C14.09 17.47 14.11 17.6 14.21 17.68L15.27 18.5C15.25 18.67 15.24 18.83 15.24 19C15.24 19.17 15.25 19.33 15.27 19.5L14.21 20.32C14.12 20.4 14.09 20.53 14.15 20.64L15.15 22.37C15.21 22.5 15.34 22.5 15.46 22.5L16.7 22C16.96 22.18 17.24 22.35 17.55 22.47L17.74 23.79C17.76 23.91 17.86 24 18 24H20C20.11 24 20.22 23.91 20.24 23.79L20.43 22.47C20.73 22.34 21 22.18 21.27 22L22.5 22.5C22.63 22.5 22.76 22.5 22.83 22.37L23.83 20.64C23.89 20.53 23.86 20.4 23.77 20.32L22.7 19.5C22.72 19.33 22.74 19.17 22.74 19C22.74 18.83 22.73 18.67 22.7 18.5L23.76 17.68C23.85 17.6 23.88 17.47 23.82 17.36L22.82 15.63C22.76 15.5 22.63 15.5 22.5 15.5L21.27 16C21 15.82 20.73 15.65 20.42 15.53L20.23 14.21C20.22 14.09 20.11 14 20 14M19 17.5C19.83 17.5 20.5 18.17 20.5 19C20.5 19.83 19.83 20.5 19 20.5C18.16 20.5 17.5 19.83 17.5 19C17.5 18.17 18.17 17.5 19 17.5Z" Fill="{Binding ElementName=IconActionPrivacy, Path=Fill}" />
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="TextBlockActionUi" Text="UI &amp; PERSONALIZATION" Style="{StaticResource ActionButtonTextBlock}"/>                    
                </StackPanel>
                <!--#endregion UI & Personalization Button-->

                <!--#region System Button-->
                <StackPanel Style="{StaticResource ActionButtonPanel}">
                    <Viewbox Style="{StaticResource ActionButtonViewBox}">
                        <Canvas Width="24" Height="24">
                            <Path Data="M12,15.5A3.5,3.5 0 0,1 8.5,12A3.5,3.5 0 0,1 12,8.5A3.5,3.5 0 0,1 15.5,12A3.5,3.5 0 0,1 12,15.5M19.43,12.97C19.47,12.65 19.5,12.33 19.5,12C19.5,11.67 19.47,11.34 19.43,11L21.54,9.37C21.73,9.22 21.78,8.95 21.66,8.73L19.66,5.27C19.54,5.05 19.27,4.96 19.05,5.05L16.56,6.05C16.04,5.66 15.5,5.32 14.87,5.07L14.5,2.42C14.46,2.18 14.25,2 14,2H10C9.75,2 9.54,2.18 9.5,2.42L9.13,5.07C8.5,5.32 7.96,5.66 7.44,6.05L4.95,5.05C4.73,4.96 4.46,5.05 4.34,5.27L2.34,8.73C2.21,8.95 2.27,9.22 2.46,9.37L4.57,11C4.53,11.34 4.5,11.67 4.5,12C4.5,12.33 4.53,12.65 4.57,12.97L2.46,14.63C2.27,14.78 2.21,15.05 2.34,15.27L4.34,18.73C4.46,18.95 4.73,19.03 4.95,18.95L7.44,17.94C7.96,18.34 8.5,18.68 9.13,18.93L9.5,21.58C9.54,21.82 9.75,22 10,22H14C14.25,22 14.46,21.82 14.5,21.58L14.87,18.93C15.5,18.67 16.04,18.34 16.56,17.94L19.05,18.95C19.27,19.03 19.54,18.95 19.66,18.73L21.66,15.27C21.78,15.05 21.73,14.78 21.54,14.63L19.43,12.97Z" Fill="{Binding ElementName=IconActionPrivacy, Path=Fill}" />
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="TextBlockActionSystem" Text="SYSTEM" Style="{StaticResource ActionButtonTextBlock}"/>                                      
                </StackPanel>
                <!--#endregion System Button-->

                <!--#region Edge Button-->
                <StackPanel Style="{StaticResource ActionButtonPanel}">
                    <Viewbox Style="{StaticResource ActionButtonViewBox}">
                        <Canvas Width="24" Height="24">
                            <Path Data="M2.74,10.81C3.83,-1.36 22.5,-1.36 21.2,13.56H8.61C8.61,17.85 14.42,19.21 19.54,16.31V20.53C13.25,23.88 5,21.43 5,14.09C5,8.58 9.97,6.81 9.97,6.81C9.97,6.81 8.58,8.58 8.54,10.05H15.7C15.7,2.93 5.9,5.57 2.74,10.81Z" Fill="{Binding ElementName=IconActionPrivacy, Path=Fill}" />
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="TextBlockActionEdge" Text="MICROSOFT EDGE" Style="{StaticResource ActionButtonTextBlock}"/>                                        
                </StackPanel>
                <!--#endregion Edge Button-->

                <!--#region Game Button-->
                <StackPanel Style="{StaticResource ActionButtonPanel}">
                    <Viewbox Style="{StaticResource ActionButtonViewBox}">
                        <Canvas Width="24" Height="24">
                            <Path Data="M6.43,3.72C6.5,3.66 6.57,3.6 6.62,3.56C8.18,2.55 10,2 12,2C13.88,2 15.64,2.5 17.14,3.42C17.25,3.5 17.54,3.69 17.7,3.88C16.25,2.28 12,5.7 12,5.7C10.5,4.57 9.17,3.8 8.16,3.5C7.31,3.29 6.73,3.5 6.46,3.7M19.34,5.21C19.29,5.16 19.24,5.11 19.2,5.06C18.84,4.66 18.38,4.56 18,4.59C17.61,4.71 15.9,5.32 13.8,7.31C13.8,7.31 16.17,9.61 17.62,11.96C19.07,14.31 19.93,16.16 19.4,18.73C21,16.95 22,14.59 22,12C22,9.38 21,7 19.34,5.21M15.73,12.96C15.08,12.24 14.13,11.21 12.86,9.95C12.59,9.68 12.3,9.4 12,9.1C12,9.1 11.53,9.56 10.93,10.17C10.16,10.94 9.17,11.95 8.61,12.54C7.63,13.59 4.81,16.89 4.65,18.74C4.65,18.74 4,17.28 5.4,13.89C6.3,11.68 9,8.36 10.15,7.28C10.15,7.28 9.12,6.14 7.82,5.35L7.77,5.32C7.14,4.95 6.46,4.66 5.8,4.62C5.13,4.67 4.71,5.16 4.71,5.16C3.03,6.95 2,9.35 2,12A10,10 0 0,0 12,22C14.93,22 17.57,20.74 19.4,18.73C19.4,18.73 19.19,17.4 17.84,15.5C17.53,15.07 16.37,13.69 15.73,12.96Z" Fill="{Binding ElementName=IconActionPrivacy, Path=Fill}" />
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="TextBlockActionGame" Text="WINDOWS GAME" Style="{StaticResource ActionButtonTextBlock}"/>                    
                </StackPanel>
                <!--#endregion Game Button-->

                <!--#region Scheduled Tasks Button-->
                <StackPanel Style="{StaticResource ActionButtonPanel}">
                    <Viewbox Style="{StaticResource ActionButtonViewBox}">
                        <Canvas Width="24" Height="24">
                            <Path Data="M19,19H5V8H19M19,3H18V1H16V3H8V1H6V3H5C3.89,3 3,3.9 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V5A2,2 0 0,0 19,3M16.53,11.06L15.47,10L10.59,14.88L8.47,12.76L7.41,13.82L10.59,17L16.53,11.06Z" Fill="{Binding ElementName=IconActionPrivacy, Path=Fill}" />
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="TextBlockActionTasks" Text="SCHEDULED TASKS" Style="{StaticResource ActionButtonTextBlock}"/>                    
                </StackPanel>
                <!--#endregion Scheduled Tasks Button-->

                <!--#region Microsoft Defender Button-->
                <StackPanel Style="{StaticResource ActionButtonPanel}">
                    <Viewbox Style="{StaticResource ActionButtonViewBox}">
                        <Canvas Width="24" Height="24">
                            <Path Data="M21,11C21,16.55 17.16,21.74 12,23C6.84,21.74 3,16.55 3,11V5L12,1L21,5V11M12,21C15.75,20 19,15.54 19,11.22V6.3L12,3.18V21Z" Fill="{Binding ElementName=IconActionPrivacy, Path=Fill}" />
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="TextBlockActionDefender" Text="MICROSOFT DEFENDER" Style="{StaticResource ActionButtonTextBlock}"/>                    
                </StackPanel>
                <!--#endregion Microsoft Defender Button-->

                <!--#region Context Menu Button-->
                <StackPanel Style="{StaticResource ActionButtonPanel}">
                    <Viewbox Style="{StaticResource ActionButtonViewBox}">
                        <Canvas Width="24" Height="24">
                            <Path Data="M3,3H9V7H3V3M15,10H21V14H15V10M15,17H21V21H15V17M13,13H7V18H13V20H7L5,20V9H7V11H13V13Z" Fill="{Binding ElementName=IconActionPrivacy, Path=Fill}" />
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="TextBlockActionMenu" Text="CONTEXT MENU" Style="{StaticResource ActionButtonTextBlock}"/>                    
                </StackPanel>
                <!--#endregion Microsoft Defender Button-->

            </StackPanel>
            <!--#endregion Action Button-->
        </Grid>


    </Border>
</Window>
'@

$xamlGui = [System.Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xamlMarkup))
$xamlMarkup.SelectNodes('//*[@Name]') | ForEach-Object {
    New-Variable -Name $_.Name -Value $xamlGui.FindName($_.Name)
    
    # if ($_.Name.Contains("ToggleButton")) {

    #     $ToggleBtn = $xamlGui.FindName($_.Name)
    #     [Void]$ToggleButtons.Add($ToggleBtn)
    # }
	
	# else
	# {
	# 	New-Variable -Name $_.Name -Value $xamlGui.FindName($_.Name)
	# }    
}

#region Script Functions
function Hide-Console {
    <#
    .SYNOPSIS
    Hide Powershell console before show WPF GUI.    
    #>

    [CmdletBinding()]
    param ()

    Add-Type -Name Window -Namespace Console -MemberDefinition '
    [DllImport("Kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
    [Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0)
}

#endregion

#region Controls Events

$Window.add_MouseLeftButtonDown( {
        $Window.DragMove()
    })

$ButtonTitleMin.add_MouseLeftButtonDown( {
        $Window.WindowState = "Minimized"
    })

$ButtonTitleMax.add_MouseLeftButtonDown( {
        if ($Window.WindowState -eq "Normal") {
            $Window.WindowState = "Maximized"
        }

        else {
            $Window.WindowState = "Normal"            
        }
    })

$ButtonTitleClose.add_MouseLeftButtonDown( {
        $Window.Close()
    })

#endregion

Hide-Console
$xamlGui.ShowDialog() | Out-Null