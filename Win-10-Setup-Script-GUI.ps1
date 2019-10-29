Add-Type -AssemblyName "PresentationCore", "PresentationFramework", "WindowsBase"

[xml]$xamlMarkup = @'
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        Name="Window" Title="Windows 10 Setup Script" MinHeight="855" MinWidth="0" Height="855" Width="1165" 
        FontFamily="Calibri" FontSize="14" TextOptions.TextFormattingMode="Display" WindowStartupLocation="CenterScreen" 
        SnapsToDevicePixels="True" ResizeMode="CanResize" 
        ShowInTaskbar="True" Background="{DynamicResource {x:Static SystemColors.WindowBrushKey}}"
        Foreground="{DynamicResource {x:Static SystemColors.WindowTextBrushKey}}">
    <Window.Resources>

        <!--#region Brushes -->

        <SolidColorBrush x:Key="RadioButton.Static.Background" Color="#FFFFFFFF"/>
        <SolidColorBrush x:Key="RadioButton.Static.Border" Color="#FF333333"/>
        <SolidColorBrush x:Key="RadioButton.Static.Glyph" Color="#FF333333"/>

        <SolidColorBrush x:Key="RadioButton.MouseOver.Background" Color="#FFFFFFFF"/>
        <SolidColorBrush x:Key="RadioButton.MouseOver.Border" Color="#FF000000"/>
        <SolidColorBrush x:Key="RadioButton.MouseOver.Glyph" Color="#FF000000"/>

        <SolidColorBrush x:Key="RadioButton.MouseOver.On.Background" Color="#3F51B5"/>
        <SolidColorBrush x:Key="RadioButton.MouseOver.On.Border" Color="#3F51B5"/>
        <SolidColorBrush x:Key="RadioButton.MouseOver.On.Glyph" Color="#FFFFFFFF"/>

        <SolidColorBrush x:Key="RadioButton.Disabled.Background" Color="#FFFFFFFF"/>
        <SolidColorBrush x:Key="RadioButton.Disabled.Border" Color="#FF999999"/>
        <SolidColorBrush x:Key="RadioButton.Disabled.Glyph" Color="#FF999999"/>

        <SolidColorBrush x:Key="RadioButton.Disabled.On.Background" Color="#FFCCCCCC"/>
        <SolidColorBrush x:Key="RadioButton.Disabled.On.Border" Color="#FFCCCCCC"/>
        <SolidColorBrush x:Key="RadioButton.Disabled.On.Glyph" Color="#FFA3A3A3"/>

        <SolidColorBrush x:Key="RadioButton.Pressed.Background" Color="#FF999999"/>
        <SolidColorBrush x:Key="RadioButton.Pressed.Border" Color="#FF999999"/>
        <SolidColorBrush x:Key="RadioButton.Pressed.Glyph" Color="#FFFFFFFF"/>

        <SolidColorBrush x:Key="RadioButton.Checked.Background" Color="#3F51B5"/>
        <SolidColorBrush x:Key="RadioButton.Checked.Border" Color="#3F51B5"/>
        <SolidColorBrush x:Key="RadioButton.Checked.Glyph" Color="#FFFFFFFF"/>

        <!--#endregion-->

        <Style x:Key="HamburgerButton" TargetType="StackPanel">
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="Orientation" Value="Horizontal"/>
            <Setter Property="Height" Value="50"/>
            <Setter Property="Width" Value="50"/>
            <Setter Property="Background" Value="#3F51B5"/>
        </Style>

        <Style x:Key="PanelHamburgerMenu" TargetType="StackPanel">
            <Setter Property="Orientation" Value="Horizontal"/>
            <Setter Property="Height" Value="55"/>
            <Setter Property="Width" Value="{Binding ElementName=HamburgerMenu, Path=Width}"/>
            <Style.Triggers>
                <Trigger  Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#2196F3"/>
                </Trigger>
                <Trigger  Property="IsMouseOver" Value="False">
                    <Setter Property="Background" Value="#3F51B5"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="PanelToggle" TargetType="StackPanel">

        </Style>

        <Style x:Key="TextblockHamburgerMenu" TargetType="TextBlock">
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="FontSize" Value="16"/>
            <Setter Property="Margin" Value="5 0 5 0"/>
            <Setter Property="Opacity" Value="0.5"/>
        </Style>

        <Style x:Key="ViewboxFooter" TargetType="{x:Type Viewbox}">
            <Setter Property="Width" Value="22"/>
            <Setter Property="Height" Value="22"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="HorizontalAlignment" Value="Center"/>
            <Setter Property="Margin" Value="5 0 5 0"/>
        </Style>

        <Style x:Key="PanelFooterButtons" TargetType="StackPanel">
            <Setter Property="Orientation" Value="Horizontal"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="HorizontalAlignment" Value="Center"/>
            <Style.Triggers>
                <EventTrigger RoutedEvent="MouseDown">
                    <EventTrigger.Actions>
                        <BeginStoryboard>
                            <Storyboard>
                                <ThicknessAnimation  Storyboard.TargetProperty="Margin" Duration="0:0:1" From="0 0 0 0" To="0 0 0 -5" SpeedRatio="5" AutoReverse="True" />
                            </Storyboard>
                        </BeginStoryboard>
                    </EventTrigger.Actions>
                </EventTrigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="BorderActionsButtons" TargetType="Border">
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Margin" Value="5 0 5 0"/>
            <Setter Property="Canvas.Top" Value="10"/>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#2196F3"/>
                    <Setter Property="BorderBrush" Value="#2196F3"/>
                </Trigger>
                <Trigger Property="IsMouseOver" Value="False">
                    <Setter Property="Background" Value="#3F51B5"/>
                    <Setter Property="BorderBrush" Value="#3F51B5"/>
                </Trigger>
                <Trigger Property="Visibility" Value="Visible">
                    <Trigger.EnterActions>
                        <BeginStoryboard>
                            <Storyboard>
                                <DoubleAnimation Storyboard.TargetProperty="Opacity" From="0.0" To="1.0" Duration="0:0:0.2"/>
                                <ThicknessAnimation Storyboard.TargetProperty="Margin" Duration="0:0:0.2" From="5 5 5 0" To="5 0 5 0" />
                            </Storyboard>
                        </BeginStoryboard>
                    </Trigger.EnterActions>
                </Trigger>
                <EventTrigger RoutedEvent="MouseDown">
                    <EventTrigger.Actions>
                        <BeginStoryboard>
                            <Storyboard>
                                <ThicknessAnimation Storyboard.TargetProperty="Margin" Duration="0:0:0.5" From="5 0 5 0" To="5 5 5 0" SpeedRatio="5" AutoReverse="True" />
                            </Storyboard>
                        </BeginStoryboard>
                    </EventTrigger.Actions>
                </EventTrigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="TextblockActionsButtons" TargetType="TextBlock">
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Foreground" Value="#FFFFFF"/>
            <Setter Property="Margin" Value="15 5 15 5"/>
        </Style>

        <Style x:Key="ToggleSwitchTopStyle" TargetType="{x:Type ToggleButton}">
            <Setter Property="Background" Value="{StaticResource RadioButton.Static.Background}"/>
            <Setter Property="BorderBrush" Value="{StaticResource RadioButton.Static.Border}"/>
            <Setter Property="Foreground" Value="{DynamicResource {x:Static SystemColors.ControlTextBrushKey}}"/>
            <Setter Property="HorizontalContentAlignment" Value="Left"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="SnapsToDevicePixels" Value="True"/>
            <Setter Property="FocusVisualStyle" Value="{x:Null}"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="{x:Type ToggleButton}">
                        <Grid x:Name="templateRoot" 
							  Background="Transparent" 
							  SnapsToDevicePixels="{TemplateBinding SnapsToDevicePixels}">
                            <VisualStateManager.VisualStateGroups>
                                <VisualStateGroup x:Name="CommonStates">
                                    <VisualState x:Name="Normal"/>
                                    <VisualState x:Name="MouseOver">
                                        <Storyboard>
                                            <DoubleAnimation To="0" Duration="0:0:0.2" Storyboard.TargetName="normalBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <DoubleAnimation To="1" Duration="0:0:0.2" Storyboard.TargetName="hoverBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0:0:0.2">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMarkOn" Storyboard.TargetProperty="Fill" Duration="0:0:0.2">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.On.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                    <VisualState x:Name="Pressed">
                                        <Storyboard>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="pressedBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Pressed.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                    <VisualState x:Name="Disabled">
                                        <Storyboard>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="checkedBorder" Storyboard.TargetProperty="BorderBrush">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Border}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="checkedBorder" Storyboard.TargetProperty="Background">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Background}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="disabledBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMarkOn" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                </VisualStateGroup>
                                <VisualStateGroup x:Name="CheckStates">
                                    <VisualState x:Name="Unchecked"/>
                                    <VisualState x:Name="Checked">
                                        <Storyboard>
                                            <ObjectAnimationUsingKeyFrames Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill" Duration="0">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Static.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <DoubleAnimationUsingKeyFrames Duration="0:0:0.5" Storyboard.TargetProperty="(UIElement.RenderTransform).(TransformGroup.Children)[3].(TranslateTransform.X)" Storyboard.TargetName="optionMark">
                                                <EasingDoubleKeyFrame KeyTime="0" Value="12"/>
                                            </DoubleAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="optionMark" Storyboard.TargetProperty="Fill">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Checked.Glyph}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="hoverBorder" Storyboard.TargetProperty="BorderBrush">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.On.Border}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="hoverBorder" Storyboard.TargetProperty="Background">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.MouseOver.On.Background}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="optionMarkOn" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <DoubleAnimation To="1" Duration="0" Storyboard.TargetName="checkedBorder" Storyboard.TargetProperty="(UIElement.Opacity)"/>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="disabledBorder" Storyboard.TargetProperty="BorderBrush">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Border}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                            <ObjectAnimationUsingKeyFrames Duration="0" Storyboard.TargetName="disabledBorder" Storyboard.TargetProperty="Background">
                                                <DiscreteObjectKeyFrame KeyTime="0" Value="{StaticResource RadioButton.Disabled.On.Background}"/>
                                            </ObjectAnimationUsingKeyFrames>
                                        </Storyboard>
                                    </VisualState>
                                    <VisualState x:Name="Indeterminate"/>
                                </VisualStateGroup>
                                <VisualStateGroup x:Name="FocusStates">
                                    <VisualState x:Name="Unfocused"/>
                                    <VisualState x:Name="Focused"/>
                                </VisualStateGroup>
                            </VisualStateManager.VisualStateGroups>
                            <Grid.RowDefinitions>
                                <RowDefinition />
                                <RowDefinition Height="Auto"/>
                            </Grid.RowDefinitions>
                            <ContentPresenter x:Name="contentPresenter" 
											  Focusable="False" RecognizesAccessKey="True" 
											  HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}" 
											  Margin="{TemplateBinding Padding}" 
											  SnapsToDevicePixels="{TemplateBinding SnapsToDevicePixels}" 
											  VerticalAlignment="{TemplateBinding VerticalContentAlignment}"/>
                            <Grid x:Name="markGrid" Grid.Row="1" Margin="0 8 0 2" Width="44" Height="20"
								  HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}">
                                <Border x:Name="normalBorder" Opacity="1" BorderThickness="2" CornerRadius="10"
										BorderBrush="{TemplateBinding BorderBrush}" Background="Transparent"/>
                                <Border x:Name="checkedBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource  RadioButton.Checked.Border}" Background="{StaticResource RadioButton.Checked.Background}"/>
                                <Border x:Name="hoverBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource RadioButton.MouseOver.Border}" Background="Transparent"/>
                                <Border x:Name="pressedBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource RadioButton.Pressed.Border}" Background="{StaticResource RadioButton.Pressed.Background}"/>
                                <Border x:Name="disabledBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource RadioButton.Disabled.Border}" Background="{StaticResource RadioButton.Disabled.Background}"/>
                                <Ellipse x:Name="optionMark"
										 Height="10" Width="10" Fill="{StaticResource RadioButton.Static.Glyph}" StrokeThickness="0" 
										 VerticalAlignment="Center" Margin="5,0" RenderTransformOrigin="0.5,0.5">
                                    <Ellipse.RenderTransform>
                                        <TransformGroup>
                                            <ScaleTransform/>
                                            <SkewTransform/>
                                            <RotateTransform/>
                                            <TranslateTransform X="-12"/>
                                        </TransformGroup>
                                    </Ellipse.RenderTransform>
                                </Ellipse>
                                <Ellipse x:Name="optionMarkOn" Opacity="0"
										 Height="10" Width="10" Fill="{StaticResource RadioButton.Checked.Glyph}" StrokeThickness="0" 
										 VerticalAlignment="Center" Margin="5,0" RenderTransformOrigin="0.5,0.5">
                                    <Ellipse.RenderTransform>
                                        <TransformGroup>
                                            <ScaleTransform/>
                                            <SkewTransform/>
                                            <RotateTransform/>
                                            <TranslateTransform X="12"/>
                                        </TransformGroup>
                                    </Ellipse.RenderTransform>
                                </Ellipse>
                            </Grid>
                        </Grid>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>

    </Window.Resources>

    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="50"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>

        <!--#region Title Panel-->
        <Canvas Grid.Row="0" Background="#E4E4E4">

            <!--#region Hamburger Button-->
            <StackPanel Name="Button_Hamburger" Style="{StaticResource HamburgerButton}">
                <StackPanel Name="Container_Hamburger" Background="{Binding ElementName=Button_Hamburger, Path=Background}">
                    <StackPanel.Triggers>
                        <EventTrigger RoutedEvent="MouseDown">
                            <EventTrigger.Actions>
                                <BeginStoryboard>
                                    <Storyboard>
                                        <ThicknessAnimation Storyboard.TargetProperty="Margin" Duration="0:0:0.5" From="0 0 0 0" To="0 5 0 0" SpeedRatio="5" AutoReverse="True" />
                                    </Storyboard>
                                </BeginStoryboard>
                            </EventTrigger.Actions>
                        </EventTrigger>
                    </StackPanel.Triggers>
                    <Viewbox Width="28" Height="28" Margin="11">
                        <Canvas Width="24" Height="24">
                            <Path Data="M3,6H21V8H3V6M3,11H21V13H3V11M3,16H21V18H3V16Z" Fill="#FFFFFF" />
                        </Canvas>
                    </Viewbox>
                </StackPanel>
            </StackPanel>
            <!--#endregion Hamburger Button-->

            <!--#region Category Text-->
            <TextBlock Name="TextBlock_Category" Text="Privacy &amp; Telemetry" FontSize="18" Canvas.Left="60" Canvas.Top="14" />
            <!--#endregion Category Text-->

            <!--#region Save Load Apply Buttons-->

            <!--#region Apply Button-->
            <Border Name="Button_Apply" Style="{StaticResource BorderActionsButtons}" Canvas.Right="151" >
                <TextBlock Text="Apply" Style="{StaticResource TextblockActionsButtons}"/>
            </Border>
            <!--#endregion Apply Button-->

            <!--#region Save Button-->
            <Border Name="Button_Save" Style="{StaticResource BorderActionsButtons}" Canvas.Right="81" >
                <TextBlock Text="Save" Style="{StaticResource TextblockActionsButtons}"/>
            </Border>
            <!--#endregion Save Button-->

            <!--#region Load Button-->
            <Border Name="Button_Load" Style="{StaticResource BorderActionsButtons}" Canvas.Right="10">
                <TextBlock Text="Load" Style="{StaticResource TextblockActionsButtons}"/>
            </Border>
            <!--#endregion Load Button-->

            <!--#endregion Save Load Apply Buttons-->

        </Canvas>
        <!--#endregion Title Panel-->

        <!--#region Body Panel-->
        <Grid Grid.Row="1">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="Auto"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>

            <!--#region Hamburger Panel-->
            <Canvas Name="HamburgerMenu" Width="50" Background="#3F51B5" Grid.Column="0">

                <!--#region Privacy & Telemetry Button-->
                <StackPanel Name="Button_Privacy" Style="{StaticResource PanelHamburgerMenu}" Canvas.Top="0">
                    <StackPanel.Triggers>
                        <EventTrigger RoutedEvent="MouseDown">
                            <EventTrigger.Actions>
                                <BeginStoryboard>
                                    <Storyboard>
                                        <ThicknessAnimation Storyboard.TargetName="Container_Privacy" Storyboard.TargetProperty="Margin" Duration="0:0:0.5" From="0 0 0 0" To="0 5 0 0" SpeedRatio="5" AutoReverse="True" />
                                    </Storyboard>
                                </BeginStoryboard>
                            </EventTrigger.Actions>
                        </EventTrigger>
                    </StackPanel.Triggers>
                    <StackPanel Name="Container_Privacy" Orientation="Horizontal">
                        <Viewbox Name="Viewbox_Privacy" Width="28" Height="28" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="10">
                            <Canvas Width="24" Height="24">
                                <Path Data="M18,20V10H6V20H18M18,8A2,2 0 0,1 20,10V20A2,2 0 0,1 18,22H6C4.89,22 4,21.1 4,20V10A2,2 0 0,1 6,8H15V6A3,3 0 0,0 12,3A3,3 0 0,0 9,6H7A5,5 0 0,1 12,1A5,5 0 0,1 17,6V8H18M12,17A2,2 0 0,1 10,15A2,2 0 0,1 12,13A2,2 0 0,1 14,15A2,2 0 0,1 12,17Z"
                                  Fill="#FFFFFF">
                                    <Path.Style>
                                        <Style TargetType="Path">
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Button_Privacy, Path=IsMouseOver}" Value="True">
                                                    <Setter Property="Opacity" Value="1"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Button_Privacy, Path=IsMouseOver}" Value="False">
                                                    <Setter Property="Opacity" Value="0.5"/>
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </Path.Style>
                                </Path>
                            </Canvas>
                        </Viewbox>
                        <TextBlock Name="Textblock_Privacy" Text="Privacy &amp; Telemetry">
                            <TextBlock.Style>
                                <Style TargetType="TextBlock">
                                    <Setter Property="VerticalAlignment" Value="Center"/>
                                    <Setter Property="Foreground" Value="#FFFFFF"/>
                                    <Setter Property="FontSize" Value="16"/>
                                    <Setter Property="Margin" Value="5 0 5 0"/>
                                    <Style.Triggers>
                                        <DataTrigger Binding="{Binding ElementName=Button_Privacy, Path=IsMouseOver}" Value="True">
                                            <Setter Property="Opacity" Value="1"/>
                                        </DataTrigger>
                                        <DataTrigger Binding="{Binding ElementName=Button_Privacy, Path=IsMouseOver}" Value="False">
                                            <Setter Property="Opacity" Value="0.5"/>
                                        </DataTrigger>
                                    </Style.Triggers>
                                </Style>
                            </TextBlock.Style>
                        </TextBlock>
                    </StackPanel>
                </StackPanel>
                <!--#endregion Privacy & Telemetry Button-->

                <!--#region UI & Personalization Button-->
                <StackPanel Name="Button_Ui" Style="{StaticResource PanelHamburgerMenu}" Canvas.Top="55">
                    <StackPanel.Triggers>
                        <EventTrigger RoutedEvent="MouseDown">
                            <EventTrigger.Actions>
                                <BeginStoryboard>
                                    <Storyboard>
                                        <ThicknessAnimation Storyboard.TargetName="Container_Ui" Storyboard.TargetProperty="Margin" Duration="0:0:0.5" From="0 0 0 0" To="0 5 0 0" SpeedRatio="5" AutoReverse="True" />
                                    </Storyboard>
                                </BeginStoryboard>
                            </EventTrigger.Actions>
                        </EventTrigger>
                    </StackPanel.Triggers>
                    <StackPanel Name="Container_Ui" Orientation="Horizontal">
                        <Viewbox Name="Viewbox_Ui" Width="28" Height="28" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="10">
                            <Canvas Width="24" Height="24">
                                <Path Data="M4 4C2.89 4 2 4.89 2 6V18C2 19.11 2.9 20 4 20H12V18H4V8H20V12H22V8C22 6.89 21.1 6 20 6H12L10 4M18 14C17.87 14 17.76 14.09 17.74 14.21L17.55 15.53C17.25 15.66 16.96 15.82 16.7 16L15.46 15.5C15.35 15.5 15.22 15.5 15.15 15.63L14.15 17.36C14.09 17.47 14.11 17.6 14.21 17.68L15.27 18.5C15.25 18.67 15.24 18.83 15.24 19C15.24 19.17 15.25 19.33 15.27 19.5L14.21 20.32C14.12 20.4 14.09 20.53 14.15 20.64L15.15 22.37C15.21 22.5 15.34 22.5 15.46 22.5L16.7 22C16.96 22.18 17.24 22.35 17.55 22.47L17.74 23.79C17.76 23.91 17.86 24 18 24H20C20.11 24 20.22 23.91 20.24 23.79L20.43 22.47C20.73 22.34 21 22.18 21.27 22L22.5 22.5C22.63 22.5 22.76 22.5 22.83 22.37L23.83 20.64C23.89 20.53 23.86 20.4 23.77 20.32L22.7 19.5C22.72 19.33 22.74 19.17 22.74 19C22.74 18.83 22.73 18.67 22.7 18.5L23.76 17.68C23.85 17.6 23.88 17.47 23.82 17.36L22.82 15.63C22.76 15.5 22.63 15.5 22.5 15.5L21.27 16C21 15.82 20.73 15.65 20.42 15.53L20.23 14.21C20.22 14.09 20.11 14 20 14M19 17.5C19.83 17.5 20.5 18.17 20.5 19C20.5 19.83 19.83 20.5 19 20.5C18.16 20.5 17.5 19.83 17.5 19C17.5 18.17 18.17 17.5 19 17.5Z"
                                  Fill="#FFFFFF">
                                    <Path.Style>
                                        <Style TargetType="Path">
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Button_Ui, Path=IsMouseOver}" Value="True">
                                                    <Setter Property="Opacity" Value="1"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Button_Ui, Path=IsMouseOver}" Value="False">
                                                    <Setter Property="Opacity" Value="0.5"/>
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </Path.Style>
                                </Path>
                            </Canvas>
                        </Viewbox>
                        <TextBlock Name="Textblock_Ui" Text="UI &amp; Personalization" >
                            <TextBlock.Style>
                                <Style TargetType="TextBlock">
                                    <Setter Property="VerticalAlignment" Value="Center"/>
                                    <Setter Property="Foreground" Value="#FFFFFF"/>
                                    <Setter Property="FontSize" Value="16"/>
                                    <Setter Property="Margin" Value="5 0 5 0"/>
                                    <Style.Triggers>
                                        <DataTrigger Binding="{Binding ElementName=Button_Ui, Path=IsMouseOver}" Value="True">
                                            <Setter Property="Opacity" Value="1"/>
                                        </DataTrigger>
                                        <DataTrigger Binding="{Binding ElementName=Button_Ui, Path=IsMouseOver}" Value="False">
                                            <Setter Property="Opacity" Value="0.5"/>
                                        </DataTrigger>
                                    </Style.Triggers>
                                </Style>
                            </TextBlock.Style>
                        </TextBlock>
                    </StackPanel>
                </StackPanel>
                <!--#endregion UI & Personalization Button-->

                <!--#region OneDrive Button-->
                <StackPanel Name="Button_OneDrive" Style="{StaticResource PanelHamburgerMenu}" Canvas.Top="110">
                    <StackPanel.Triggers>
                        <EventTrigger RoutedEvent="MouseDown">
                            <EventTrigger.Actions>
                                <BeginStoryboard>
                                    <Storyboard>
                                        <ThicknessAnimation Storyboard.TargetName="Container_OneDrive" Storyboard.TargetProperty="Margin" Duration="0:0:0.5" From="0 0 0 0" To="0 5 0 0" SpeedRatio="5" AutoReverse="True" />
                                    </Storyboard>
                                </BeginStoryboard>
                            </EventTrigger.Actions>
                        </EventTrigger>
                    </StackPanel.Triggers>
                    <StackPanel Name="Container_OneDrive" Orientation="Horizontal">
                        <Viewbox Name="Viewbox_OneDrive" Width="28" Height="28" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="10">
                            <Canvas Width="24" Height="24">
                                <Path Data="M19,18H6A4,4 0 0,1 2,14A4,4 0 0,1 6,10H6.71C7.37,7.69 9.5,6 12,6A5.5,5.5 0 0,1 17.5,11.5V12H19A3,3 0 0,1 22,15A3,3 0 0,1 19,18M19.35,10.03C18.67,6.59 15.64,4 12,4C9.11,4 6.6,5.64 5.35,8.03C2.34,8.36 0,10.9 0,14A6,6 0 0,0 6,20H19A5,5 0 0,0 24,15C24,12.36 21.95,10.22 19.35,10.03Z"
                                  Fill="#FFFFFF">
                                    <Path.Style>
                                        <Style TargetType="Path">
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Button_OneDrive, Path=IsMouseOver}" Value="True">
                                                    <Setter Property="Opacity" Value="1"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Button_OneDrive, Path=IsMouseOver}" Value="False">
                                                    <Setter Property="Opacity" Value="0.5"/>
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </Path.Style>
                                </Path>
                            </Canvas>
                        </Viewbox>
                        <TextBlock Name="Textblock_OneDrive" Text="OneDrive" >
                            <TextBlock.Style>
                                <Style TargetType="TextBlock">
                                    <Setter Property="VerticalAlignment" Value="Center"/>
                                    <Setter Property="Foreground" Value="#FFFFFF"/>
                                    <Setter Property="FontSize" Value="16"/>
                                    <Setter Property="Margin" Value="5 0 5 0"/>
                                    <Style.Triggers>
                                        <DataTrigger Binding="{Binding ElementName=Button_OneDrive, Path=IsMouseOver}" Value="True">
                                            <Setter Property="Opacity" Value="1"/>
                                        </DataTrigger>
                                        <DataTrigger Binding="{Binding ElementName=Button_OneDrive, Path=IsMouseOver}" Value="False">
                                            <Setter Property="Opacity" Value="0.5"/>
                                        </DataTrigger>
                                    </Style.Triggers>
                                </Style>
                            </TextBlock.Style>
                        </TextBlock>
                    </StackPanel>
                </StackPanel>
                <!--#endregion OneDrive Button-->

                <!--#region System Button-->
                <StackPanel Name="Button_System" Style="{StaticResource PanelHamburgerMenu}" Canvas.Top="165">
                    <StackPanel.Triggers>
                        <EventTrigger RoutedEvent="MouseDown">
                            <EventTrigger.Actions>
                                <BeginStoryboard>
                                    <Storyboard>
                                        <ThicknessAnimation Storyboard.TargetName="Container_System" Storyboard.TargetProperty="Margin" Duration="0:0:0.5" From="0 0 0 0" To="0 5 0 0" SpeedRatio="5" AutoReverse="True" />
                                    </Storyboard>
                                </BeginStoryboard>
                            </EventTrigger.Actions>
                        </EventTrigger>
                    </StackPanel.Triggers>
                    <StackPanel Name="Container_System" Orientation="Horizontal">
                        <Viewbox Name="Viewbox_System" Width="28" Height="28" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="10">
                            <Canvas Width="24" Height="24">
                                <Path Data="M12,8A4,4 0 0,1 16,12A4,4 0 0,1 12,16A4,4 0 0,1 8,12A4,4 0 0,1 12,8M12,10A2,2 0 0,0 10,12A2,2 0 0,0 12,14A2,2 0 0,0 14,12A2,2 0 0,0 12,10M10,22C9.75,22 9.54,21.82 9.5,21.58L9.13,18.93C8.5,18.68 7.96,18.34 7.44,17.94L4.95,18.95C4.73,19.03 4.46,18.95 4.34,18.73L2.34,15.27C2.21,15.05 2.27,14.78 2.46,14.63L4.57,12.97L4.5,12L4.57,11L2.46,9.37C2.27,9.22 2.21,8.95 2.34,8.73L4.34,5.27C4.46,5.05 4.73,4.96 4.95,5.05L7.44,6.05C7.96,5.66 8.5,5.32 9.13,5.07L9.5,2.42C9.54,2.18 9.75,2 10,2H14C14.25,2 14.46,2.18 14.5,2.42L14.87,5.07C15.5,5.32 16.04,5.66 16.56,6.05L19.05,5.05C19.27,4.96 19.54,5.05 19.66,5.27L21.66,8.73C21.79,8.95 21.73,9.22 21.54,9.37L19.43,11L19.5,12L19.43,13L21.54,14.63C21.73,14.78 21.79,15.05 21.66,15.27L19.66,18.73C19.54,18.95 19.27,19.04 19.05,18.95L16.56,17.95C16.04,18.34 15.5,18.68 14.87,18.93L14.5,21.58C14.46,21.82 14.25,22 14,22H10M11.25,4L10.88,6.61C9.68,6.86 8.62,7.5 7.85,8.39L5.44,7.35L4.69,8.65L6.8,10.2C6.4,11.37 6.4,12.64 6.8,13.8L4.68,15.36L5.43,16.66L7.86,15.62C8.63,16.5 9.68,17.14 10.87,17.38L11.24,20H12.76L13.13,17.39C14.32,17.14 15.37,16.5 16.14,15.62L18.57,16.66L19.32,15.36L17.2,13.81C17.6,12.64 17.6,11.37 17.2,10.2L19.31,8.65L18.56,7.35L16.15,8.39C15.38,7.5 14.32,6.86 13.12,6.62L12.75,4H11.25Z"
                                  Fill="#FFFFFF">
                                    <Path.Style>
                                        <Style TargetType="Path">
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Button_System, Path=IsMouseOver}" Value="True">
                                                    <Setter Property="Opacity" Value="1"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Button_System, Path=IsMouseOver}" Value="False">
                                                    <Setter Property="Opacity" Value="0.5"/>
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </Path.Style>
                                </Path>
                            </Canvas>
                        </Viewbox>
                        <TextBlock Name="Textblock_System" Text="System" >
                            <TextBlock.Style>
                                <Style TargetType="TextBlock">
                                    <Setter Property="VerticalAlignment" Value="Center"/>
                                    <Setter Property="Foreground" Value="#FFFFFF"/>
                                    <Setter Property="FontSize" Value="16"/>
                                    <Setter Property="Margin" Value="5 0 5 0"/>
                                    <Style.Triggers>
                                        <DataTrigger Binding="{Binding ElementName=Button_System, Path=IsMouseOver}" Value="True">
                                            <Setter Property="Opacity" Value="1"/>
                                        </DataTrigger>
                                        <DataTrigger Binding="{Binding ElementName=Button_System, Path=IsMouseOver}" Value="False">
                                            <Setter Property="Opacity" Value="0.5"/>
                                        </DataTrigger>
                                    </Style.Triggers>
                                </Style>
                            </TextBlock.Style>
                        </TextBlock>
                    </StackPanel>
                </StackPanel>
                <!--#endregion System Button-->

                <!--#region Start Menu Button-->
                <StackPanel Name="Button_StartMenu" Style="{StaticResource PanelHamburgerMenu}" Canvas.Top="220">
                    <StackPanel.Triggers>
                        <EventTrigger RoutedEvent="MouseDown">
                            <EventTrigger.Actions>
                                <BeginStoryboard>
                                    <Storyboard>
                                        <ThicknessAnimation Storyboard.TargetName="Container_StartMenu" Storyboard.TargetProperty="Margin" Duration="0:0:0.5" From="0 0 0 0" To="0 5 0 0" SpeedRatio="5" AutoReverse="True" />
                                    </Storyboard>
                                </BeginStoryboard>
                            </EventTrigger.Actions>
                        </EventTrigger>
                    </StackPanel.Triggers>
                    <StackPanel Name="Container_StartMenu" Orientation="Horizontal">
                        <Viewbox Name="Viewbox_StartMenu" Width="28" Height="28" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="10">
                            <Canvas Width="24" Height="24">
                                <Path Data="M3,12V6.75L9,5.43V11.91L3,12M20,3V11.75L10,11.9V5.21L20,3M3,13L9,13.09V19.9L3,18.75V13M20,13.25V22L10,20.09V13.1L20,13.25Z"
                                  Fill="#FFFFFF">
                                    <Path.Style>
                                        <Style TargetType="Path">
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Button_StartMenu, Path=IsMouseOver}" Value="True">
                                                    <Setter Property="Opacity" Value="1"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Button_StartMenu, Path=IsMouseOver}" Value="False">
                                                    <Setter Property="Opacity" Value="0.5"/>
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </Path.Style>
                                </Path>
                            </Canvas>
                        </Viewbox>
                        <TextBlock Name="Textblock_StartMenu" Text="Start Menu" >
                            <TextBlock.Style>
                                <Style TargetType="TextBlock">
                                    <Setter Property="VerticalAlignment" Value="Center"/>
                                    <Setter Property="Foreground" Value="#FFFFFF"/>
                                    <Setter Property="FontSize" Value="16"/>
                                    <Setter Property="Margin" Value="5 0 5 0"/>
                                    <Style.Triggers>
                                        <DataTrigger Binding="{Binding ElementName=Button_StartMenu, Path=IsMouseOver}" Value="True">
                                            <Setter Property="Opacity" Value="1"/>
                                        </DataTrigger>
                                        <DataTrigger Binding="{Binding ElementName=Button_StartMenu, Path=IsMouseOver}" Value="False">
                                            <Setter Property="Opacity" Value="0.5"/>
                                        </DataTrigger>
                                    </Style.Triggers>
                                </Style>
                            </TextBlock.Style>
                        </TextBlock>
                    </StackPanel>
                </StackPanel>
                <!--#endregion Start Menu Button-->

                <!--#region Microsoft Edge Button-->
                <StackPanel Name="Button_Edge" Style="{StaticResource PanelHamburgerMenu}" Canvas.Top="275">
                    <StackPanel.Triggers>
                        <EventTrigger RoutedEvent="MouseDown">
                            <EventTrigger.Actions>
                                <BeginStoryboard>
                                    <Storyboard>
                                        <ThicknessAnimation Storyboard.TargetName="Container_Edge" Storyboard.TargetProperty="Margin" Duration="0:0:0.5" From="0 0 0 0" To="0 5 0 0" SpeedRatio="5" AutoReverse="True" />
                                    </Storyboard>
                                </BeginStoryboard>
                            </EventTrigger.Actions>
                        </EventTrigger>
                    </StackPanel.Triggers>
                    <StackPanel Name="Container_Edge" Orientation="Horizontal">
                        <Viewbox Name="Viewbox_Edge" Width="28" Height="28" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="10">
                            <Canvas Width="24" Height="24">
                                <Path Data="M2.74,10.81C3.83,-1.36 22.5,-1.36 21.2,13.56H8.61C8.61,17.85 14.42,19.21 19.54,16.31V20.53C13.25,23.88 5,21.43 5,14.09C5,8.58 9.97,6.81 9.97,6.81C9.97,6.81 8.58,8.58 8.54,10.05H15.7C15.7,2.93 5.9,5.57 2.74,10.81Z"
                                  Fill="#FFFFFF">
                                    <Path.Style>
                                        <Style TargetType="Path">
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Button_Edge, Path=IsMouseOver}" Value="True">
                                                    <Setter Property="Opacity" Value="1"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Button_Edge, Path=IsMouseOver}" Value="False">
                                                    <Setter Property="Opacity" Value="0.5"/>
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </Path.Style>
                                </Path>
                            </Canvas>
                        </Viewbox>
                        <TextBlock Name="Textblock_Edge" Text="Microsoft Edge" >
                            <TextBlock.Style>
                                <Style TargetType="TextBlock">
                                    <Setter Property="VerticalAlignment" Value="Center"/>
                                    <Setter Property="Foreground" Value="#FFFFFF"/>
                                    <Setter Property="FontSize" Value="16"/>
                                    <Setter Property="Margin" Value="5 0 5 0"/>
                                    <Style.Triggers>
                                        <DataTrigger Binding="{Binding ElementName=Button_Edge, Path=IsMouseOver}" Value="True">
                                            <Setter Property="Opacity" Value="1"/>
                                        </DataTrigger>
                                        <DataTrigger Binding="{Binding ElementName=Button_Edge, Path=IsMouseOver}" Value="False">
                                            <Setter Property="Opacity" Value="0.5"/>
                                        </DataTrigger>
                                    </Style.Triggers>
                                </Style>
                            </TextBlock.Style>
                        </TextBlock>
                    </StackPanel>
                </StackPanel>
                <!--#endregion Microsoft Edge Button-->

                <!--#region UWP Apps Button-->
                <StackPanel Name="Button_Uwp" Style="{StaticResource PanelHamburgerMenu}" Canvas.Top="330">
                    <StackPanel.Triggers>
                        <EventTrigger RoutedEvent="MouseDown">
                            <EventTrigger.Actions>
                                <BeginStoryboard>
                                    <Storyboard>
                                        <ThicknessAnimation Storyboard.TargetName="Container_Uwp" Storyboard.TargetProperty="Margin" Duration="0:0:0.5" From="0 0 0 0" To="0 5 0 0" SpeedRatio="5" AutoReverse="True" />
                                    </Storyboard>
                                </BeginStoryboard>
                            </EventTrigger.Actions>
                        </EventTrigger>
                    </StackPanel.Triggers>
                    <StackPanel Name="Container_Uwp" Orientation="Horizontal">
                        <Viewbox Name="Viewbox_Uwp" Width="28" Height="28" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="10">
                            <Canvas Width="24" Height="24">
                                <Path Data="M3,13A9,9 0 0,0 12,22A9,9 0 0,0 3,13M5.44,15.44C7.35,16.15 8.85,17.65 9.56,19.56C7.65,18.85 6.15,17.35 5.44,15.44M12,22A9,9 0 0,0 21,13A9,9 0 0,0 12,22M14.42,19.57C15.11,17.64 16.64,16.11 18.57,15.42C17.86,17.34 16.34,18.86 14.42,19.57M12,14A6,6 0 0,0 18,8V3C17.26,3 16.53,3.12 15.84,3.39C15.29,3.62 14.8,3.96 14.39,4.39L12,2L9.61,4.39C9.2,3.96 8.71,3.62 8.16,3.39C7.47,3.12 6.74,3 6,3V8A6,6 0 0,0 12,14M8,5.61L9.57,7.26L12,4.83L14.43,7.26L16,5.61V8A4,4 0 0,1 12,12A4,4 0 0,1 8,8V5.61Z"
                                  Fill="#FFFFFF">
                                    <Path.Style>
                                        <Style TargetType="Path">
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Button_Uwp, Path=IsMouseOver}" Value="True">
                                                    <Setter Property="Opacity" Value="1"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Button_Uwp, Path=IsMouseOver}" Value="False">
                                                    <Setter Property="Opacity" Value="0.5"/>
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </Path.Style>
                                </Path>
                            </Canvas>
                        </Viewbox>
                        <TextBlock Name="Textblock_Uwp" Text="UWP Apps" >
                            <TextBlock.Style>
                                <Style TargetType="TextBlock">
                                    <Setter Property="VerticalAlignment" Value="Center"/>
                                    <Setter Property="Foreground" Value="#FFFFFF"/>
                                    <Setter Property="FontSize" Value="16"/>
                                    <Setter Property="Margin" Value="5 0 5 0"/>
                                    <Style.Triggers>
                                        <DataTrigger Binding="{Binding ElementName=Button_Uwp, Path=IsMouseOver}" Value="True">
                                            <Setter Property="Opacity" Value="1"/>
                                        </DataTrigger>
                                        <DataTrigger Binding="{Binding ElementName=Button_Uwp, Path=IsMouseOver}" Value="False">
                                            <Setter Property="Opacity" Value="0.5"/>
                                        </DataTrigger>
                                    </Style.Triggers>
                                </Style>
                            </TextBlock.Style>
                        </TextBlock>
                    </StackPanel>
                </StackPanel>
                <!--#endregion UWP Apps Button-->

                <!--#region Windows Game Recording Button-->
                <StackPanel Name="Button_Game" Style="{StaticResource PanelHamburgerMenu}" Canvas.Top="385">
                    <StackPanel.Triggers>
                        <EventTrigger RoutedEvent="MouseDown">
                            <EventTrigger.Actions>
                                <BeginStoryboard>
                                    <Storyboard>
                                        <ThicknessAnimation Storyboard.TargetName="Container_Game" Storyboard.TargetProperty="Margin" Duration="0:0:0.5" From="0 0 0 0" To="0 5 0 0" SpeedRatio="5" AutoReverse="True" />
                                    </Storyboard>
                                </BeginStoryboard>
                            </EventTrigger.Actions>
                        </EventTrigger>
                    </StackPanel.Triggers>
                    <StackPanel Name="Container_Game" Orientation="Horizontal">
                        <Viewbox Name="Viewbox_Game" Width="28" Height="28" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="10">
                            <Canvas Width="24" Height="24">
                                <Path Data="M6.43,3.72C6.5,3.66 6.57,3.6 6.62,3.56C8.18,2.55 10,2 12,2C13.88,2 15.64,2.5 17.14,3.42C17.25,3.5 17.54,3.69 17.7,3.88C16.25,2.28 12,5.7 12,5.7C10.5,4.57 9.17,3.8 8.16,3.5C7.31,3.29 6.73,3.5 6.46,3.7M19.34,5.21C19.29,5.16 19.24,5.11 19.2,5.06C18.84,4.66 18.38,4.56 18,4.59C17.61,4.71 15.9,5.32 13.8,7.31C13.8,7.31 16.17,9.61 17.62,11.96C19.07,14.31 19.93,16.16 19.4,18.73C21,16.95 22,14.59 22,12C22,9.38 21,7 19.34,5.21M15.73,12.96C15.08,12.24 14.13,11.21 12.86,9.95C12.59,9.68 12.3,9.4 12,9.1C12,9.1 11.53,9.56 10.93,10.17C10.16,10.94 9.17,11.95 8.61,12.54C7.63,13.59 4.81,16.89 4.65,18.74C4.65,18.74 4,17.28 5.4,13.89C6.3,11.68 9,8.36 10.15,7.28C10.15,7.28 9.12,6.14 7.82,5.35L7.77,5.32C7.14,4.95 6.46,4.66 5.8,4.62C5.13,4.67 4.71,5.16 4.71,5.16C3.03,6.95 2,9.35 2,12A10,10 0 0,0 12,22C14.93,22 17.57,20.74 19.4,18.73C19.4,18.73 19.19,17.4 17.84,15.5C17.53,15.07 16.37,13.69 15.73,12.96Z"
                                  Fill="#FFFFFF">
                                    <Path.Style>
                                        <Style TargetType="Path">
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Button_Game, Path=IsMouseOver}" Value="True">
                                                    <Setter Property="Opacity" Value="1"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Button_Game, Path=IsMouseOver}" Value="False">
                                                    <Setter Property="Opacity" Value="0.5"/>
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </Path.Style>
                                </Path>
                            </Canvas>
                        </Viewbox>
                        <TextBlock Name="Textblock_Game" Text="Windows Game Recording" >
                            <TextBlock.Style>
                                <Style TargetType="TextBlock">
                                    <Setter Property="VerticalAlignment" Value="Center"/>
                                    <Setter Property="Foreground" Value="#FFFFFF"/>
                                    <Setter Property="FontSize" Value="16"/>
                                    <Setter Property="Margin" Value="5 0 5 0"/>
                                    <Style.Triggers>
                                        <DataTrigger Binding="{Binding ElementName=Button_Game, Path=IsMouseOver}" Value="True">
                                            <Setter Property="Opacity" Value="1"/>
                                        </DataTrigger>
                                        <DataTrigger Binding="{Binding ElementName=Button_Game, Path=IsMouseOver}" Value="False">
                                            <Setter Property="Opacity" Value="0.5"/>
                                        </DataTrigger>
                                    </Style.Triggers>
                                </Style>
                            </TextBlock.Style>
                        </TextBlock>
                    </StackPanel>
                </StackPanel>
                <!--#endregion Windows Game Recording Button-->

                <!--#region Scheduled Tasks Button-->
                <StackPanel Name="Button_Tasks" Style="{StaticResource PanelHamburgerMenu}" Canvas.Top="440">
                    <StackPanel.Triggers>
                        <EventTrigger RoutedEvent="MouseDown">
                            <EventTrigger.Actions>
                                <BeginStoryboard>
                                    <Storyboard>
                                        <ThicknessAnimation Storyboard.TargetName="Container_Tasks" Storyboard.TargetProperty="Margin" Duration="0:0:0.5" From="0 0 0 0" To="0 5 0 0" SpeedRatio="5" AutoReverse="True" />
                                    </Storyboard>
                                </BeginStoryboard>
                            </EventTrigger.Actions>
                        </EventTrigger>
                    </StackPanel.Triggers>
                    <StackPanel Name="Container_Tasks" Orientation="Horizontal">
                        <Viewbox Name="Viewbox_Tasks" Width="28" Height="28" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="10">
                            <Canvas Width="24" Height="24">
                                <Path Data="M19,19H5V8H19M19,3H18V1H16V3H8V1H6V3H5C3.89,3 3,3.9 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V5A2,2 0 0,0 19,3M16.53,11.06L15.47,10L10.59,14.88L8.47,12.76L7.41,13.82L10.59,17L16.53,11.06Z"
                                  Fill="#FFFFFF">
                                    <Path.Style>
                                        <Style TargetType="Path">
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Button_Tasks, Path=IsMouseOver}" Value="True">
                                                    <Setter Property="Opacity" Value="1"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Button_Tasks, Path=IsMouseOver}" Value="False">
                                                    <Setter Property="Opacity" Value="0.5"/>
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </Path.Style>
                                </Path>
                            </Canvas>
                        </Viewbox>
                        <TextBlock Name="Textblock_Tasks" Text="Scheduled Tasks" >
                            <TextBlock.Style>
                                <Style TargetType="TextBlock">
                                    <Setter Property="VerticalAlignment" Value="Center"/>
                                    <Setter Property="Foreground" Value="#FFFFFF"/>
                                    <Setter Property="FontSize" Value="16"/>
                                    <Setter Property="Margin" Value="5 0 5 0"/>
                                    <Style.Triggers>
                                        <DataTrigger Binding="{Binding ElementName=Button_Tasks, Path=IsMouseOver}" Value="True">
                                            <Setter Property="Opacity" Value="1"/>
                                        </DataTrigger>
                                        <DataTrigger Binding="{Binding ElementName=Button_Tasks, Path=IsMouseOver}" Value="False">
                                            <Setter Property="Opacity" Value="0.5"/>
                                        </DataTrigger>
                                    </Style.Triggers>
                                </Style>
                            </TextBlock.Style>
                        </TextBlock>
                    </StackPanel>
                </StackPanel>
                <!--#endregion Scheduled Tasks Button-->

                <!--#region Microsoft Defender Button-->
                <StackPanel Name="Button_Defender" Style="{StaticResource PanelHamburgerMenu}" Canvas.Top="495">
                    <StackPanel.Triggers>
                        <EventTrigger RoutedEvent="MouseDown">
                            <EventTrigger.Actions>
                                <BeginStoryboard>
                                    <Storyboard>
                                        <ThicknessAnimation Storyboard.TargetName="Container_Defender" Storyboard.TargetProperty="Margin" Duration="0:0:0.5" From="0 0 0 0" To="0 5 0 0" SpeedRatio="5" AutoReverse="True" />
                                    </Storyboard>
                                </BeginStoryboard>
                            </EventTrigger.Actions>
                        </EventTrigger>
                    </StackPanel.Triggers>
                    <StackPanel Name="Container_Defender" Orientation="Horizontal">
                        <Viewbox Name="Viewbox_Defender" Width="28" Height="28" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="10">
                            <Canvas Width="24" Height="24">
                                <Path Data="M21,11C21,16.55 17.16,21.74 12,23C6.84,21.74 3,16.55 3,11V5L12,1L21,5V11M12,21C15.75,20 19,15.54 19,11.22V6.3L12,3.18V21Z"
                                  Fill="#FFFFFF">
                                    <Path.Style>
                                        <Style TargetType="Path">
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Button_Defender, Path=IsMouseOver}" Value="True">
                                                    <Setter Property="Opacity" Value="1"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Button_Defender, Path=IsMouseOver}" Value="False">
                                                    <Setter Property="Opacity" Value="0.5"/>
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </Path.Style>
                                </Path>
                            </Canvas>
                        </Viewbox>
                        <TextBlock Name="Textblock_Defender" Text="Microsoft Defender" >
                            <TextBlock.Style>
                                <Style TargetType="TextBlock">
                                    <Setter Property="VerticalAlignment" Value="Center"/>
                                    <Setter Property="Foreground" Value="#FFFFFF"/>
                                    <Setter Property="FontSize" Value="16"/>
                                    <Setter Property="Margin" Value="5 0 5 0"/>
                                    <Style.Triggers>
                                        <DataTrigger Binding="{Binding ElementName=Button_Defender, Path=IsMouseOver}" Value="True">
                                            <Setter Property="Opacity" Value="1"/>
                                        </DataTrigger>
                                        <DataTrigger Binding="{Binding ElementName=Button_Defender, Path=IsMouseOver}" Value="False">
                                            <Setter Property="Opacity" Value="0.5"/>
                                        </DataTrigger>
                                    </Style.Triggers>
                                </Style>
                            </TextBlock.Style>
                        </TextBlock>
                    </StackPanel>
                </StackPanel>
                <!--#endregion Microsoft Defender Button-->

                <!--#region Context Menu Button-->
                <StackPanel Name="Button_ContextMenu" Style="{StaticResource PanelHamburgerMenu}" Canvas.Top="550">
                    <StackPanel.Triggers>
                        <EventTrigger RoutedEvent="MouseDown">
                            <EventTrigger.Actions>
                                <BeginStoryboard>
                                    <Storyboard>
                                        <ThicknessAnimation Storyboard.TargetName="Container_ContextMenu" Storyboard.TargetProperty="Margin" Duration="0:0:0.5" From="0 0 0 0" To="0 5 0 0" SpeedRatio="5" AutoReverse="True" />
                                    </Storyboard>
                                </BeginStoryboard>
                            </EventTrigger.Actions>
                        </EventTrigger>
                    </StackPanel.Triggers>
                    <StackPanel Name="Container_ContextMenu" Orientation="Horizontal">
                        <Viewbox Name="Viewbox_ContextMenu" Width="28" Height="28" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="10">
                            <Canvas Width="24" Height="24">
                                <Path Data="M3,3H9V7H3V3M15,10H21V14H15V10M15,17H21V21H15V17M13,13H7V18H13V20H7L5,20V9H7V11H13V13Z"
                                  Fill="#FFFFFF">
                                    <Path.Style>
                                        <Style TargetType="Path">
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Button_ContextMenu, Path=IsMouseOver}" Value="True">
                                                    <Setter Property="Opacity" Value="1"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Button_ContextMenu, Path=IsMouseOver}" Value="False">
                                                    <Setter Property="Opacity" Value="0.5"/>
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </Path.Style>
                                </Path>
                            </Canvas>
                        </Viewbox>
                        <TextBlock Name="Textblock_ContextMenu" Text="Context Menu" >
                            <TextBlock.Style>
                                <Style TargetType="TextBlock">
                                    <Setter Property="VerticalAlignment" Value="Center"/>
                                    <Setter Property="Foreground" Value="#FFFFFF"/>
                                    <Setter Property="FontSize" Value="16"/>
                                    <Setter Property="Margin" Value="5 0 5 0"/>
                                    <Style.Triggers>
                                        <DataTrigger Binding="{Binding ElementName=Button_ContextMenu, Path=IsMouseOver}" Value="True">
                                            <Setter Property="Opacity" Value="1"/>
                                        </DataTrigger>
                                        <DataTrigger Binding="{Binding ElementName=Button_ContextMenu, Path=IsMouseOver}" Value="False">
                                            <Setter Property="Opacity" Value="0.5"/>
                                        </DataTrigger>
                                    </Style.Triggers>
                                </Style>
                            </TextBlock.Style>
                        </TextBlock>
                    </StackPanel>
                </StackPanel>
                <!--#endregion ContextMenu Button-->

                <!--#region Change Language Button-->
                <StackPanel Name="Button_ChangeLanguage" Style="{StaticResource PanelHamburgerMenu}" Canvas.Bottom="55">
                    <StackPanel.Triggers>
                        <EventTrigger RoutedEvent="MouseDown">
                            <EventTrigger.Actions>
                                <BeginStoryboard>
                                    <Storyboard>
                                        <ThicknessAnimation Storyboard.TargetName="Container_ChangeLanguage" Storyboard.TargetProperty="Margin" Duration="0:0:0.5" From="0 0 0 0" To="0 5 0 0" SpeedRatio="5" AutoReverse="True" />
                                    </Storyboard>
                                </BeginStoryboard>
                            </EventTrigger.Actions>
                        </EventTrigger>
                    </StackPanel.Triggers>
                    <StackPanel Name="Container_ChangeLanguage" Orientation="Horizontal">
                        <Viewbox Name="ViewboxChangeLanguage" Width="28" Height="28" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="10">
                            <Canvas Width="24" Height="24">
                                <Path  Data="M16.36,14C16.44,13.34 16.5,12.68 16.5,12C16.5,11.32 16.44,10.66 16.36,10H19.74C19.9,10.64 20,11.31 20,12C20,12.69 19.9,13.36 19.74,14M14.59,19.56C15.19,18.45 15.65,17.25 15.97,16H18.92C17.96,17.65 16.43,18.93 14.59,19.56M14.34,14H9.66C9.56,13.34 9.5,12.68 9.5,12C9.5,11.32 9.56,10.65 9.66,10H14.34C14.43,10.65 14.5,11.32 14.5,12C14.5,12.68 14.43,13.34 14.34,14M12,19.96C11.17,18.76 10.5,17.43 10.09,16H13.91C13.5,17.43 12.83,18.76 12,19.96M8,8H5.08C6.03,6.34 7.57,5.06 9.4,4.44C8.8,5.55 8.35,6.75 8,8M5.08,16H8C8.35,17.25 8.8,18.45 9.4,19.56C7.57,18.93 6.03,17.65 5.08,16M4.26,14C4.1,13.36 4,12.69 4,12C4,11.31 4.1,10.64 4.26,10H7.64C7.56,10.66 7.5,11.32 7.5,12C7.5,12.68 7.56,13.34 7.64,14M12,4.03C12.83,5.23 13.5,6.57 13.91,8H10.09C10.5,6.57 11.17,5.23 12,4.03M18.92,8H15.97C15.65,6.75 15.19,5.55 14.59,4.44C16.43,5.07 17.96,6.34 18.92,8M12,2C6.47,2 2,6.5 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2Z"
                                  Fill="#FFFFFF">
                                    <Path.Style>
                                        <Style TargetType="Path">
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Button_ChangeLanguage, Path=IsMouseOver}" Value="True">
                                                    <Setter Property="Opacity" Value="1"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Button_ChangeLanguage, Path=IsMouseOver}" Value="False">
                                                    <Setter Property="Opacity" Value="0.5"/>
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </Path.Style>
                                </Path>
                            </Canvas>
                        </Viewbox>
                        <TextBlock Name="Textblock_ChangeLanguage" Text="Change Language" >
                            <TextBlock.Style>
                                <Style TargetType="TextBlock">
                                    <Setter Property="VerticalAlignment" Value="Center"/>
                                    <Setter Property="Foreground" Value="#FFFFFF"/>
                                    <Setter Property="FontSize" Value="16"/>
                                    <Setter Property="Margin" Value="5 0 5 0"/>
                                    <Style.Triggers>
                                        <DataTrigger Binding="{Binding ElementName=Button_ChangeLanguage, Path=IsMouseOver}" Value="True">
                                            <Setter Property="Opacity" Value="1"/>
                                        </DataTrigger>
                                        <DataTrigger Binding="{Binding ElementName=Button_ChangeLanguage, Path=IsMouseOver}" Value="False">
                                            <Setter Property="Opacity" Value="0.5"/>
                                        </DataTrigger>
                                    </Style.Triggers>
                                </Style>
                            </TextBlock.Style>
                        </TextBlock>
                    </StackPanel>
                </StackPanel>
                <!--#endregion GitHub Button-->

                <!--#region GitHub Button-->
                <StackPanel Name="Button_GitHub" Style="{StaticResource PanelHamburgerMenu}" Canvas.Bottom="0">
                    <StackPanel.Triggers>
                        <EventTrigger RoutedEvent="MouseDown">
                            <EventTrigger.Actions>
                                <BeginStoryboard>
                                    <Storyboard>
                                        <ThicknessAnimation Storyboard.TargetName="Container_GitHub" Storyboard.TargetProperty="Margin" Duration="0:0:0.5" From="0 0 0 0" To="0 5 0 0" SpeedRatio="5" AutoReverse="True" />
                                    </Storyboard>
                                </BeginStoryboard>
                            </EventTrigger.Actions>
                        </EventTrigger>
                    </StackPanel.Triggers>
                    <StackPanel Name="Container_GitHub" Orientation="Horizontal">
                        <Viewbox Name="ViewboxGitHub" Width="28" Height="28" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="10">
                            <Canvas Width="24" Height="24">
                                <Path Data="M12,2A10,10 0 0,0 2,12C2,16.42 4.87,20.17 8.84,21.5C9.34,21.58 9.5,21.27 9.5,21C9.5,20.77 9.5,20.14 9.5,19.31C6.73,19.91 6.14,17.97 6.14,17.97C5.68,16.81 5.03,16.5 5.03,16.5C4.12,15.88 5.1,15.9 5.1,15.9C6.1,15.97 6.63,16.93 6.63,16.93C7.5,18.45 8.97,18 9.54,17.76C9.63,17.11 9.89,16.67 10.17,16.42C7.95,16.17 5.62,15.31 5.62,11.5C5.62,10.39 6,9.5 6.65,8.79C6.55,8.54 6.2,7.5 6.75,6.15C6.75,6.15 7.59,5.88 9.5,7.17C10.29,6.95 11.15,6.84 12,6.84C12.85,6.84 13.71,6.95 14.5,7.17C16.41,5.88 17.25,6.15 17.25,6.15C17.8,7.5 17.45,8.54 17.35,8.79C18,9.5 18.38,10.39 18.38,11.5C18.38,15.32 16.04,16.16 13.81,16.41C14.17,16.72 14.5,17.33 14.5,18.26C14.5,19.6 14.5,20.68 14.5,21C14.5,21.27 14.66,21.59 15.17,21.5C19.14,20.16 22,16.42 22,12A10,10 0 0,0 12,2Z"
                                  Fill="#FFFFFF">
                                    <Path.Style>
                                        <Style TargetType="Path">
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Button_GitHub, Path=IsMouseOver}" Value="True">
                                                    <Setter Property="Opacity" Value="1"/>
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Button_GitHub, Path=IsMouseOver}" Value="False">
                                                    <Setter Property="Opacity" Value="0.5"/>
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </Path.Style>
                                </Path>
                            </Canvas>
                        </Viewbox>
                        <TextBlock Name="Textblock_GitHub" Text="Follow on GitHub" >
                            <TextBlock.Style>
                                <Style TargetType="TextBlock">
                                    <Setter Property="VerticalAlignment" Value="Center"/>
                                    <Setter Property="Foreground" Value="#FFFFFF"/>
                                    <Setter Property="FontSize" Value="16"/>
                                    <Setter Property="Margin" Value="5 0 5 0"/>
                                    <Style.Triggers>
                                        <DataTrigger Binding="{Binding ElementName=Button_GitHub, Path=IsMouseOver}" Value="True">
                                            <Setter Property="Opacity" Value="1"/>
                                        </DataTrigger>
                                        <DataTrigger Binding="{Binding ElementName=Button_GitHub, Path=IsMouseOver}" Value="False">
                                            <Setter Property="Opacity" Value="0.5"/>
                                        </DataTrigger>
                                    </Style.Triggers>
                                </Style>
                            </TextBlock.Style>
                        </TextBlock>
                    </StackPanel>
                </StackPanel>
                <!--#endregion GitHub Button-->

            </Canvas>
            <!--#endregion Hamburger Panel-->

            <!--#region Toggle Buttons-->
            <ScrollViewer Grid.Column="1" HorizontalScrollBarVisibility="Disabled" VerticalScrollBarVisibility="Auto">
                <StackPanel>
                    
                    <!--#region Privacy Toggle-->
                    <StackPanel Name="PanelToggle_Privacy" Style="{StaticResource PanelToggle}">

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Privacy_0" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off &quot;Connected User Experiences and Telemetry&quot; service"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Privacy_0" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_0, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_0, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Privacy_1" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off per-user services"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Privacy_1" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_1, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_1, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Privacy_2" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off the Autologger session at the next computer restart"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Privacy_2" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_2, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_2, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Privacy_3" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off the SQMLogger session at the next computer restart"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Privacy_3" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_3, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_3, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Privacy_4" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Set the operating system diagnostic data level to &quot;Basic&quot;"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Privacy_4" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_4, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_4, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Privacy_5" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off Windows Error Reporting"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Privacy_5" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_5, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_5, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Privacy_6" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Change Windows Feedback frequency to &quot;Never&quot;"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Privacy_6" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_6, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_6, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Privacy_7" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off diagnostics tracking scheduled tasks"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Privacy_7" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_7, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_7, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Privacy_8" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Do not offer tailored experiences based on the diagnostic data setting"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Privacy_8" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_8, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_8, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Privacy_9" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Do not let apps on other devices open and message apps on this device, and vice versa"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Privacy_9" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_9, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_9, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Privacy_10" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Do not allow apps to use advertising ID"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Privacy_10" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_10, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_10, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Privacy_11" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Do not use sign-in info to automatically finish setting up device after an update or restart"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Privacy_11" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_11, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_11, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Privacy_12" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Do not let websites provide locally relevant content by accessing language list"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Privacy_12" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_12, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_12, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Privacy_13" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on tip, trick, and suggestions as you use Windows"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Privacy_13" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_13, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_13, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Privacy_14" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off app suggestions on Start menu"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Privacy_14" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_14, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_14, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Privacy_15" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off suggested content in the Settings"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Privacy_15" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_15, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_15, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Privacy_16" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off automatic installing suggested apps"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Privacy_16" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_16, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_16, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Privacy_17" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off app launch tracking to improve Start menu and search results"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Privacy_17" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_17, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Privacy_17, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>
                    <!--#endregion Privacy Toggle-->

                    <!--#region UI Toggle-->
                    <StackPanel Name="PanelToggle_UI" Style="{StaticResource PanelToggle}">

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_0" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Set File Explorer to open to This PC by default"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_0" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_0, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_0, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_1" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Show Hidden Files, Folders, and Drives"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_1" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_1, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_1, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_2" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Show File Name Extensions"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_2" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_2, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_2, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_3" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Hide Task View button on taskbar"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_3" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_3, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_3, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_4" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Show folder merge conflicts"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_4" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_4, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_4, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_5" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off Snap Assist"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_5" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_5, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_5, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_6" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off check boxes to select items"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_6" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_6, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_6, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_7" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Show seconds on taskbar clock"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_7" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_7, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_7, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_8" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Hide People button on the taskbar"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_8" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_8, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_8, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_9" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Hide all folders in the navigation pane"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_9" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_9, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_9, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_10" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove 3D Objects folder in &quot;This PC&quot; and in the navigation pane"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_10" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_10, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_10, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_11" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Hide &quot;Frequent folders&quot; in Quick access"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_11" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_11, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_11, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_12" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Hide &quot;Recent files&quot; in Quick access"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_12" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_12, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_12, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_13" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on acrylic taskbar transparency"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_13" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_13, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_13, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_14" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Show &quot;This PC&quot; on Desktop"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_14" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_14, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_14, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_15" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Show more details in file transfer dialog"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_15" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_15, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_15, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_16" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove the &quot;Previous Versions&quot; tab from properties context menu"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_16" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_16, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_16, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_17" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Always show all icons in the notification area"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_17" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_17, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_17, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_18" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Set the Control Panel view by large icons"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_18" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_18, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_18, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_19" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Hide &quot;Windows Ink Workspace&quot; button in taskbar"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_19" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_19, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_19, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_20" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Hide search box or search icon on taskbar"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_20" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_20, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_20, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_21" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on recycle bin files delete confirmation"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_21" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_21, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_21, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_22" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on ribbon in File Explorer"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_22" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_22, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_22, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_23" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Choose theme color for default Windows mode"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_23" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_23, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_23, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_24" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Choose theme color for default app mode"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_24" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_24, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_24, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_25" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off &quot;New App Installed&quot; notification"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_25" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_25, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_25, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_26" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off recently added apps on Start menu"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_26" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_26, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_26, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_27" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off user first sign-in animation"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_27" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_27, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_27, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_28" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off JPEG desktop wallpaper import quality reduction"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_28" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_28, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_28, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_29" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Show Task Manager details"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_29" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_29, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_29, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_30" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Unpin Microsoft Edge and Microsoft Store from taskbar"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_30" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_30, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_30, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_31" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove Microsoft Edge shortcut from the Desktop"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_31" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_31, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_31, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_32" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Show accent color on the title bars and window borders"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_32" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_32, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_32, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_33" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off automatically hiding scroll bars"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_33" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_33, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_33, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_34" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Save screenshots by pressing Win+PrtScr to the Desktop"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_34" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_34, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_34, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_35" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Show more Windows Update restart notifications about restarting"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_35" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_35, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_35, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_36" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off the &quot;- Shortcut&quot; name extension for new shortcuts"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_36" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_36, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_36, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_37" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Use the PrtScn button to open screen snipping"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_37" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_37, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_37, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UI_38" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Automatically adjust active hours for me based on daily usage"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UI_38" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_38, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UI_38, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>
                    <!--#endregion UI Toggle-->

                    <!--#region OneDrive Toggle-->
                    <StackPanel Name="PanelToggle_OneDrive" Style="{StaticResource PanelToggle}">

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_OneDrive_0" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Uninstall OneDrive"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_OneDrive_0" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_OneDrive_0, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_OneDrive_0, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>
                    <!--#endregion OneDrive Toggle-->

                    <!--#region System Toggle-->
                    <StackPanel Name="PanelToggle_System" Style="{StaticResource PanelToggle}">

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_0" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on Storage Sense to automatically free up space"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_0" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_0, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_0, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_1" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Run Storage Sense every month"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_1" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_1, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_1, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_2" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Delete temporary files that apps aren't using"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_2" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_2, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_2, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_3" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Delete files in recycle bin if they have been there for over 30 days"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_3" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_3, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_3, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_4" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Never delete files in &quot;Downloads&quot; folder"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_4" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_4, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_4, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_5" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Let Windows try to fix apps so they're not blurry"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_5" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_5, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_5, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_6" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off hibernate"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_6" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_6, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_6, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_7" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off location for this device"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_7" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_7, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_7, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_8" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Change environment variable for &quot;%TEMP%&quot; to &quot;%SystemDrive%\Temp&quot;"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_8" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_8, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_8, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_9" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove &quot;%LOCALAPPDATA%\Temp&quot;"
    FontSize="18" Margin="10" IsChecked="False" />
                                <TextBlock Name="TextToggle_System_9" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock">
                                            <Setter Property="Text" Value="Off" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Toggle_System_9, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="On" />
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Toggle_System_9, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_10" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove &quot;%SYSTEMROOT%\Temp&quot;"
    FontSize="18" Margin="10" IsChecked="False" />
                                <TextBlock Name="TextToggle_System_10" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock">
                                            <Setter Property="Text" Value="Off" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Toggle_System_10, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="On" />
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Toggle_System_10, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_11" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on Win32 long paths"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_11" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_11, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_11, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_12" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Group svchost.exe processes"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_12" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_12, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_12, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_13" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on Retpoline patch against Spectre v2"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_13" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_13, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_13, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_14" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on the display of stop error information on the BSoD"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_14" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_14, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_14, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_15" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Do not preserve zone information"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_15" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_15, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_15, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_16" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off Admin Approval Mode for administrators"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_16" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_16, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_16, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_17" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on access to mapped drives from app running with elevated permissions with&#x0a;Admin Approval Mode enabled"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_17" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_17, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_17, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_18" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Set download mode for delivery optization on &quot;HTTP only&quot;"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_18" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_18, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_18, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_19" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Always wait for the network at computer startup and logon"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_19" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_19, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_19, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_20" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off Cortana"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_20" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_20, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_20, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_21" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Do not allow Windows 10 to manage default printer"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_21" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_21, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_21, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_22" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off Windows features"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_22" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_22, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_22, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_23" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove Windows capabilities"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_23" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_23, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_23, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_24" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on updates for other Microsoft products"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_24" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_24, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_24, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_25" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Enable System Restore"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_25" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_25, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_25, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_26" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off Windows Script Host"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_26" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_26, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_26, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_27" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off default background apps except"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_27" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_27, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_27, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_28" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Set power management scheme for desktop and laptop"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_28" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_28, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_28, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_29" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on .NET 4 runtime for all apps"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_29" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_29, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_29, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_30" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on firewall &amp; network protection"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_30" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_30, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_30, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_31" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Do not allow the computer to turn off the device to save power for desktop"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_31" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_31, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_31, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_32" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Set the default input method to the English language"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_32" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_32, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_32, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_33" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on Windows Sandbox"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_33" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_33, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_33, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_34" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Set location of the &quot;Desktop&quot;, &quot;Documents&quot; &quot;Downloads&quot; &quot;Music&quot;, &quot;Pictures&quot;, and &quot;Videos&quot;"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_34" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_34, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_34, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_35" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on automatic recommended troubleshooting and tell when problems get fixed"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_35" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_35, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_35, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_36" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Set &quot;High performance&quot; in graphics performance preference for apps"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_36" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_36, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_36, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_37" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Launch folder in a separate process"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_37" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_37, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_37, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_38" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off and delete reserved storage after the next update installation"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_38" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_38, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_38, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_39" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on automatic backup the system registry to the &quot;%SystemRoot%\System32\config\RegBack&quot; folder"
    FontSize="18" Margin="10" IsChecked="False" />
                                <TextBlock Name="TextToggle_System_39" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock">
                                            <Setter Property="Text" Value="Off" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Toggle_System_39, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="On" />
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Toggle_System_39, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_40" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off &quot;The Windows Filtering Platform has blocked a connection&quot; message"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_40" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_40, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_40, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_41" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off SmartScreen for apps and files"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_41" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_41, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_41, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_42" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off F1 Help key"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_42" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_42, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_42, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_43" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on Num Lock at startup"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_43" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_43, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_43, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_44" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off sticky Shift key after pressing 5 times"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_44" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_44, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_44, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_45" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off AutoPlay for all media and devices"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_45" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_45, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_45, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_46" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off creation of an Edge shortcut on the desktop for each user profile"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_46" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_46, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_46, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_47" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off thumbnail cache removal"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_47" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_47, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_47, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_System_48" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn On automatically save my restartable apps when sign out and restart them after sign in"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_System_48" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_48, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_System_48, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>
                    <!--#endregion System Toggle-->

                    <!--#region StartMenu Toggle-->
                    <StackPanel Name="PanelToggle_StartMenu" Style="{StaticResource PanelToggle}">

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_StartMenu_0" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Open shortcut to the Command Prompt from Start menu as Administrator"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_StartMenu_0" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_StartMenu_0, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_StartMenu_0, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_StartMenu_1" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Create old style shortcut for &quot;Devices and Printers&quot; in&#x0a;&quot;%APPDATA%\Microsoft\Windows\Start menu\Programs\System Tools&quot;"
    FontSize="18" Margin="10" IsChecked="False" />
                                <TextBlock Name="TextToggle_StartMenu_1" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock">
                                            <Setter Property="Text" Value="Off" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Toggle_StartMenu_1, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="On" />
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Toggle_StartMenu_1, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_StartMenu_2" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Import Start menu layout from pre-saved reg file"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_StartMenu_2" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_StartMenu_2, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_StartMenu_2, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>
                    <!--#endregion StartMenu Toggle-->

                    <!--#region Edge Toggle-->
                    <StackPanel Name="PanelToggle_Edge" Style="{StaticResource PanelToggle}">

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Edge_0" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off Windows Defender SmartScreen for Microsoft Edge"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Edge_0" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Edge_0, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Edge_0, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Edge_1" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Do not allow Microsoft Edge to start and load the Start and New Tab page at&#x0a;Windows startup and each time Microsoft Edge is closed"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Edge_1" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Edge_1, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Edge_1, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_Edge_2" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Do not allow Microsoft Edge to pre-launch at Windows startup, when the system is idle,&#x0a;and each time Microsoft Edge is closed"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_Edge_2" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Edge_2, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_Edge_2, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>
                    <!--#endregion Edge Toggle-->

                    <!--#region UWPApps Toggle-->
                    <StackPanel Name="PanelToggle_UWPApps" Style="{StaticResource PanelToggle}">

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UWPApps_0" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Uninstall all UWP apps from all accounts except"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UWPApps_0" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UWPApps_0, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UWPApps_0, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_UWPApps_1" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Uninstall all provisioned UWP apps from all accounts except"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_UWPApps_1" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UWPApps_1, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_UWPApps_1, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>
                    <!--#endregion UWPApps Toggle-->

                    <!--#region WindowsGameRecording Toggle-->
                    <StackPanel Name="PanelToggle_WindowsGameRecording" Style="{StaticResource PanelToggle}">

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_WindowsGameRecording_0" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off Windows Game Recording and Broadcasting"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_WindowsGameRecording_0" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_WindowsGameRecording_0, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_WindowsGameRecording_0, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_WindowsGameRecording_1" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off Game Bar"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_WindowsGameRecording_1" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_WindowsGameRecording_1, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_WindowsGameRecording_1, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_WindowsGameRecording_2" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off Game Mode"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_WindowsGameRecording_2" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_WindowsGameRecording_2, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_WindowsGameRecording_2, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_WindowsGameRecording_3" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off Game Bar tips"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_WindowsGameRecording_3" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_WindowsGameRecording_3, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_WindowsGameRecording_3, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>                        
                    </StackPanel>
                    <!--#endregion WindowsGameRecording Toggle-->

                    <!--#region ScheduledTasks Toggle-->
                    <StackPanel Name="PanelToggle_ScheduledTasks" Style="{StaticResource PanelToggle}">

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ScheduledTasks_0" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Create a task in the Task Scheduler to start Windows cleaning up&#x0a;The task runs every 90 days"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ScheduledTasks_0" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ScheduledTasks_0, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ScheduledTasks_0, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ScheduledTasks_1" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Create a task in the Task Scheduler to clear the &quot;%SystemRoot%\SoftwareDistribution\Download&quot; folder&#x0a;The task runs on Thursdays every 4 weeks"
    FontSize="18" Margin="10" IsChecked="False" />
                                <TextBlock Name="TextToggle_ScheduledTasks_1" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock">
                                            <Setter Property="Text" Value="Off" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Toggle_ScheduledTasks_1, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="On" />
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Toggle_ScheduledTasks_1, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ScheduledTasks_2" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Create a task in the Task Scheduler to clear the %TEMP% folder&#x0a;The task runs every 62 days"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ScheduledTasks_2" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ScheduledTasks_2, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ScheduledTasks_2, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>
                    <!--#endregion ScheduledTasks Toggle-->

                    <!--#region MicrosoftDefender Toggle-->
                    <StackPanel Name="PanelToggle_MicrosoftDefender" Style="{StaticResource PanelToggle}">

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_MicrosoftDefender_0" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Add folder to exclude from Windows Defender Antivirus scan"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_MicrosoftDefender_0" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_MicrosoftDefender_0, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_MicrosoftDefender_0, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_MicrosoftDefender_1" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on Controlled folder access and add protected folders"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_MicrosoftDefender_1" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_MicrosoftDefender_1, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_MicrosoftDefender_1, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_MicrosoftDefender_2" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Allow an app through Controlled folder access"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_MicrosoftDefender_2" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_MicrosoftDefender_2, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_MicrosoftDefender_2, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_MicrosoftDefender_3" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on Windows Defender Exploit Guard Network Protection"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_MicrosoftDefender_3" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_MicrosoftDefender_3, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_MicrosoftDefender_3, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_MicrosoftDefender_4" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on Windows Defender PUA Protection"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_MicrosoftDefender_4" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_MicrosoftDefender_4, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_MicrosoftDefender_4, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_MicrosoftDefender_5" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn on Windows Defender Sandbox"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_MicrosoftDefender_5" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_MicrosoftDefender_5, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_MicrosoftDefender_5, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_MicrosoftDefender_6" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Hide notification about sign in with Microsoft in the Windows Security"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_MicrosoftDefender_6" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_MicrosoftDefender_6, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_MicrosoftDefender_6, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_MicrosoftDefender_7" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Hide notification about disabled Smartscreen for Microsoft Edge"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_MicrosoftDefender_7" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_MicrosoftDefender_7, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_MicrosoftDefender_7, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>
                    <!--#endregion MicrosoftDefender Toggle-->

                    <!--#region ContextMenu Toggle-->
                    <StackPanel Name="PanelToggle_ContextMenu" Style="{StaticResource PanelToggle}">

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_0" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Add &quot;Extract&quot; to MSI file type context menu"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ContextMenu_0" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_0, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_0, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_1" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Add &quot;Run as different user&quot; from context menu for .exe file type"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ContextMenu_1" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_1, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_1, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_2" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Add &quot;Install&quot; to CAB file type context menu"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ContextMenu_2" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_2, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_2, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_3" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove &quot;Cast to Device&quot; from context menu"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ContextMenu_3" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_3, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_3, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_4" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove &quot;Share&quot; from context menu"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ContextMenu_4" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_4, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_4, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_5" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove &quot;Previous Versions&quot; from file context menu"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ContextMenu_5" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_5, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_5, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_6" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove &quot;Edit with Paint 3D&quot; from context menu"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ContextMenu_6" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_6, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_6, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_7" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove &quot;Include in Library&quot; from context menu"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ContextMenu_7" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_7, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_7, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_8" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove &quot;Turn on BitLocker&quot; from context menu"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ContextMenu_8" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_8, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_8, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_9" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove &quot;Edit with Photos&quot; from context menu"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ContextMenu_9" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_9, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_9, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_10" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove &quot;Create a new video&quot; from Context Menu"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ContextMenu_10" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_10, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_10, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_11" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove &quot;Edit&quot; from Context Menu"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ContextMenu_11" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_11, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_11, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_12" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove &quot;Print&quot; from batch and cmd files context menu"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ContextMenu_12" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_12, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_12, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_13" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove &quot;Compressed (zipped) Folder&quot; from context menu"
    FontSize="18" Margin="10" IsChecked="False" />
                                <TextBlock Name="TextToggle_ContextMenu_13" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                    <TextBlock.Style>
                                        <Style TargetType="TextBlock">
                                            <Setter Property="Text" Value="Off" />
                                            <Style.Triggers>
                                                <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_13, Path=IsChecked}" Value="True">
                                                    <Setter Property="Text" Value="On" />
                                                </DataTrigger>
                                                <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_13, Path=IsEnabled}" Value="false">
                                                    <Setter Property="Opacity" Value="0.2" />
                                                </DataTrigger>
                                            </Style.Triggers>
                                        </Style>
                                    </TextBlock.Style>
                                </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_14" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove &quot;Rich Text Document&quot; from context menu"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ContextMenu_14" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_14, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_14, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_15" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove &quot;Bitmap image&quot; from context menu"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ContextMenu_15" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_15, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_15, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_16" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Remove &quot;Send to&quot; from folder context menu"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ContextMenu_16" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_16, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_16, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_17" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Make the &quot;Open&quot;, &quot;Print&quot;, &quot;Edit&quot; context menu items available, when more than 15 selected"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ContextMenu_17" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_17, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_17, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>

                        <Grid HorizontalAlignment="Left">
                            <ToggleButton Name="Toggle_ContextMenu_18" Style="{StaticResource ToggleSwitchTopStyle}"
    Content="Turn off &quot;Look for an app in the Microsoft Store&quot; in &quot;Open with&quot; dialog"
    FontSize="18" Margin="10" IsChecked="False" />
                            <TextBlock Name="TextToggle_ContextMenu_18" Margin="60 10 10 12" VerticalAlignment="Bottom" FontSize="18">
                                <TextBlock.Style>
                                    <Style TargetType="TextBlock">
                                        <Setter Property="Text" Value="Off" />
                                        <Style.Triggers>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_18, Path=IsChecked}" Value="True">
                                                <Setter Property="Text" Value="On" />
                                            </DataTrigger>
                                            <DataTrigger Binding="{Binding ElementName=Toggle_ContextMenu_18, Path=IsEnabled}" Value="false">
                                                <Setter Property="Opacity" Value="0.2" />
                                            </DataTrigger>
                                        </Style.Triggers>
                                    </Style>
                                </TextBlock.Style>
                            </TextBlock>
                        </Grid>
                    </StackPanel>
                    <!--#endregion ContextMenu Toggle-->

                </StackPanel>
            </ScrollViewer>
            <!--#endregion Toggle Buttons-->
        </Grid>
        <!--#endregion Body Panel-->
    </Grid>
</Window>
'@

$xamlGui = [System.Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xamlMarkup))
$xamlMarkup.SelectNodes('//*[@Name]') | ForEach-Object {
    New-Variable -Name $_.Name -Value $xamlGui.FindName($_.Name)
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

function Use-HamburgerMenu {
    <#
    .SYNOPSIS
    Show or hide hamburger menu.
    #>

    [CmdletBinding()]
    param ()

    $minWidth = 50
    $maxWidth = 250
    $duration = New-Object System.Windows.Duration([timespan]::FromSeconds(1))
	$widthProperty = New-Object System.Windows.PropertyPath([System.Windows.Controls.Canvas]::WidthProperty)

    if ($HamburgerMenu.ActualWidth -eq $minWidth) {
        $animation = New-Object System.Windows.Media.Animation.DoubleAnimation($minWidth, $maxWidth, $duration)
    }

    else {
        $animation = New-Object System.Windows.Media.Animation.DoubleAnimation($maxWidth, $minWidth, $duration)
    }

    $animation.SpeedRatio ="3"
	$storyboard = New-Object System.Windows.Media.Animation.Storyboard
	[System.Windows.Media.Animation.Storyboard]::SetTargetProperty($animation, $widthProperty)
    $storyboard.Children.Add($animation)
    $storyboard.Begin($HamburgerMenu)	
}

function Set-HamburgerHover {
    <#
    .SYNOPSIS
    Mouse hover effect for hamburger button.
    #>

    [CmdletBinding()]
    param
	(
		[Parameter(Mandatory=$false)]
		[switch]$Active
	)
	
	
	if ($Active)
	{		
		$Button_Hamburger.Background = "#2196F3"
	}
	
	else
	{
		$Button_Hamburger.Background = "#3F51B5"
	}	
}

#endregion

#region Controls Events

$Button_Hamburger.Add_MouseLeftButtonDown({
    Use-HamburgerMenu
})

$Button_Hamburger.Add_MouseEnter({
	Set-HamburgerHover -Active
})

$Button_Hamburger.Add_MouseLeave({
	Set-HamburgerHover

})





#endregion

Hide-Console
$Window.ShowDialog() | Out-Null