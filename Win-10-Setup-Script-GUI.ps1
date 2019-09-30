Add-Type -AssemblyName "PresentationCore", "PresentationFramework", "WindowsBase"

[xml]$xamlMarkup = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"                        
        Title="Windows 10 Setup Script" MinHeight="710" MinWidth="650" Height="910" Width="1760" FontFamily="Sergio UI"
        FontSize="14" TextOptions.TextFormattingMode="Display" WindowStartupLocation="CenterScreen" 
        SnapsToDevicePixels="True" WindowStyle="None" ResizeMode="CanResizeWithGrip" AllowsTransparency="True" 
        ShowInTaskbar="True" Background="#FAFAFA"
        Foreground="{DynamicResource {x:Static SystemColors.WindowTextBrushKey}}">

    <Window.Resources>

        <!--#region Brushes -->

        <SolidColorBrush x:Key="RadioButton.Static.Background" Color="#FFFFFFFF"/>
        <SolidColorBrush x:Key="RadioButton.Static.Border" Color="#FF333333"/>
        <SolidColorBrush x:Key="RadioButton.Static.Glyph" Color="#FF333333"/>

        <SolidColorBrush x:Key="RadioButton.MouseOver.Background" Color="#FFFFFFFF"/>
        <SolidColorBrush x:Key="RadioButton.MouseOver.Border" Color="#FF000000"/>
        <SolidColorBrush x:Key="RadioButton.MouseOver.Glyph" Color="#FF000000"/>

        <SolidColorBrush x:Key="RadioButton.MouseOver.On.Background" Color="#FF4C91C8"/>
        <SolidColorBrush x:Key="RadioButton.MouseOver.On.Border" Color="#FF4C91C8"/>
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

        <SolidColorBrush x:Key="RadioButton.Checked.Background" Color="#FF0063B1"/>
        <SolidColorBrush x:Key="RadioButton.Checked.Border" Color="#FF0063B1"/>
        <SolidColorBrush x:Key="RadioButton.Checked.Glyph" Color="#FFFFFFFF"/>

        <!--#endregion-->

        <Style x:Key="ToggleSwitchLeftStyle" TargetType="{x:Type ToggleButton}">
            <Setter Property="VerticalAlignment" Value="Center"/>
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
                            <Grid x:Name="markGrid" Grid.Row="1" Margin="10 0 10 0" Width="44" Height="20"
								  HorizontalAlignment="{TemplateBinding HorizontalContentAlignment}">
                                <Border x:Name="normalBorder" Opacity="1" BorderThickness="2" CornerRadius="10"
										BorderBrush="{TemplateBinding BorderBrush}" Background="{StaticResource RadioButton.Static.Background}"/>
                                <Border x:Name="checkedBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource  RadioButton.Checked.Border}" Background="{StaticResource RadioButton.Checked.Background}"/>
                                <Border x:Name="hoverBorder" Opacity="0" BorderThickness="2" CornerRadius="10"
										BorderBrush="{StaticResource RadioButton.MouseOver.Border}" Background="{StaticResource RadioButton.MouseOver.Background}"/>
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

        <SolidColorBrush x:Key="Hover.Enter.Brush" Color="#FFF2F2F2" />
        <SolidColorBrush x:Key="Hover.Exit.Brush" Color="#01FFFFFF" />

        <Storyboard x:Key="Hover.Enter.Storyboard"/>

        <Storyboard x:Key="Hover.Exit.Storyboard"/>

        <Style x:Key="HoverBorder" TargetType="Border">
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Margin" Value="0 4"/>
            <Setter Property="Padding" Value="10 2"/>
            <Style.Triggers>
                <EventTrigger RoutedEvent="Mouse.MouseEnter">
                    <BeginStoryboard Storyboard="{StaticResource Hover.Enter.Storyboard}" />
                </EventTrigger>
                <EventTrigger RoutedEvent="Mouse.MouseLeave">
                    <BeginStoryboard Storyboard="{StaticResource Hover.Exit.Storyboard}" />
                </EventTrigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="TitleButtonStyle" TargetType="Canvas">
            <Setter Property="Height" Value="35"/>
            <Setter Property="Width" Value="35"/>
            <Style.Triggers>
                <Trigger Property="Canvas.IsMouseOver" Value="True">
                    <Setter Property="Canvas.Background" Value="#FF1744"/>
                </Trigger>
            </Style.Triggers>
        </Style>

        <Style x:Key="ButtonTextBlock" TargetType="{x:Type TextBlock}">
            <Setter Property="VerticalAlignment" Value="Center"/>
            <Setter Property="HorizontalAlignment" Value="Center"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Margin" Value="0 5 0 0"/>
        </Style>

        <Style x:Key="BorderHoverStyle" TargetType="{x:Type Border}">
            <Setter Property="Background" Value="#FFFFFF"/>            
        </Style>

    </Window.Resources>

    <Border Name="BorderWindow" BorderThickness="1" BorderBrush="#0078d7">
        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="40"/>
                <RowDefinition Height="45"/>
                <RowDefinition Height="*"/>                
            </Grid.RowDefinitions>
            <!--#region Title Panel-->
            <Grid Grid.Row="0" Margin="0 0 0 5" Background="{Binding ElementName=BorderWindow, Path=BorderBrush}">
                <Grid.Effect>
                    <DropShadowEffect ShadowDepth="2" Direction="315" BlurRadius="3" Opacity="0.5"/>
                </Grid.Effect>
                <!--Icon-->
                <Viewbox Width="28" Height="28" HorizontalAlignment="Left" Margin="10 0 0 3">
                    <Canvas Width="24" Height="24">
                        <Path Data="M3,12V6.75L9,5.43V11.91L3,12M20,3V11.75L10,11.9V5.21L20,3M3,13L9,13.09V19.9L3,18.75V13M20,13.25V22L10,20.09V13.1L20,13.25Z" Fill="{Binding ElementName=TitleHeader,Path=Foreground}" />
                    </Canvas>
                </Viewbox>
                <!--Header-->
                <TextBlock Name="TitleHeader" Text="Windows 10 Setup Script" FontFamily="Sergio UI" FontSize="14"
                           FontWeight="Bold" VerticalAlignment="Center" HorizontalAlignment="Center" Foreground="#FFFFFF"/>
                <!--Minimize Button-->
                <Canvas Name="MinimizeButton" VerticalAlignment="Center" HorizontalAlignment="Right" 
                        Margin="0 0 35 0" Style="{StaticResource TitleButtonStyle}">
                    <Viewbox Width="24" Height="24" Canvas.Left="4">
                        <Path  Data="M20,14H4V10H20" Fill="{Binding ElementName=TitleHeader,Path=Foreground}" />
                    </Viewbox>
                </Canvas>
                <!--Close Button-->
                <Canvas Name="CloseButton" VerticalAlignment="Center" HorizontalAlignment="Right" Style="{StaticResource TitleButtonStyle}">
                    <Viewbox Width="24" Height="24" Canvas.Left="4" Canvas.Top="2">
                        <Path Data="M19,6.41L17.59,5L12,10.59L6.41,5L5,6.41L10.59,12L5,17.59L6.41,19L12,13.41L17.59,19L19,17.59L13.41,12L19,6.41Z" Fill="{Binding ElementName=TitleHeader,Path=Foreground}" />
                    </Viewbox>
                </Canvas>
            </Grid>
            <!--#endregion Title Panel-->

            <!--#region Action Buttons Panel-->
            <StackPanel Name="ActionButtonsPanel" Margin="0 0 0 5" Orientation="Horizontal" Grid.Row="1" VerticalAlignment="Center" HorizontalAlignment="Center">

                <!--#region Apply Setting Button-->
                <StackPanel Margin="10 0 0 0" Height="35" Width="35" Orientation="Horizontal">
                    <StackPanel.Style>
                        <Style TargetType="{x:Type StackPanel}">
                            <Style.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter Property="Background" Value="#DADADA"/>
                                </Trigger>
                                <Trigger Property="IsMouseOver" Value="False">
                                    <Setter Property="Background" Value="{Binding ElementName=Window, Path=Background}"/>
                                </Trigger>
                                <EventTrigger RoutedEvent="MouseEnter">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="130" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseLeave">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="35" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseDown">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <ThicknessAnimation Storyboard.TargetProperty="Margin" Duration="0:0:0.5" To="10 4 0 0" SpeedRatio="5" AutoReverse="True" />
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                            </Style.Triggers>
                        </Style>
                    </StackPanel.Style>
                    <Viewbox Width="18" Height="18" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="8 0 9 0">
                        <Canvas Width="24" Height="24">
                            <Path Data="M11,15H13V17H11V15M11,7H13V13H11V7M12,2C6.47,2 2,6.5 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2M12,20A8,8 0 0,1 4,12A8,8 0 0,1 12,4A8,8 0 0,1 20,12A8,8 0 0,1 12,20Z"
                                  Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="ApplyButtonText" Text="apply settings" FontSize="14" VerticalAlignment="Center"
                               Margin="0 0 8 0" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                </StackPanel>
                <!--#endregion Apply Button-->

                <!--#region Save Setting Button-->
                <StackPanel Margin="10 0 0 0" Height="35" Width="35" Orientation="Horizontal">
                    <StackPanel.Style>
                        <Style TargetType="{x:Type StackPanel}">
                            <Style.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter Property="Background" Value="#DADADA"/>
                                </Trigger>
                                <Trigger Property="IsMouseOver" Value="False">
                                    <Setter Property="Background" Value="{Binding ElementName=Window, Path=Background}"/>
                                </Trigger>
                                <EventTrigger RoutedEvent="MouseEnter">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="125" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseLeave">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="35" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseDown">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <ThicknessAnimation Storyboard.TargetProperty="Margin" Duration="0:0:1" To="10 4 0 0" SpeedRatio="5" AutoReverse="True"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                            </Style.Triggers>
                        </Style>
                    </StackPanel.Style>
                    <Viewbox Width="18" Height="18" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="8 0 9 0">
                        <Canvas Width="24" Height="24">
                            <Path Data="M12,2A3,3 0 0,0 9,5C9,6.27 9.8,7.4 11,7.83V10H8V12H11V18.92C9.16,18.63 7.53,17.57 6.53,16H8V14H3V19H5V17.3C6.58,19.61 9.2,21 12,21C14.8,21 17.42,19.61 19,17.31V19H21V14H16V16H17.46C16.46,17.56 14.83,18.63 13,18.92V12H16V10H13V7.82C14.2,7.4 15,6.27 15,5A3,3 0 0,0 12,2M12,4A1,1 0 0,1 13,5A1,1 0 0,1 12,6A1,1 0 0,1 11,5A1,1 0 0,1 12,4Z"
                                  Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="SaveButtonText" Text="save settings" FontSize="14" VerticalAlignment="Center"
                               Margin="0 0 8 0" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                </StackPanel>
                <!--#endregion Save Setting Button-->

                <!--#region Load Setting Button-->
                <StackPanel Margin="10 0 0 0" Height="35" Width="35" Orientation="Horizontal">
                    <StackPanel.Style>
                        <Style TargetType="{x:Type StackPanel}">
                            <Style.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter Property="Background" Value="#DADADA"/>
                                </Trigger>
                                <Trigger Property="IsMouseOver" Value="False">
                                    <Setter Property="Background" Value="{Binding ElementName=Window, Path=Background}"/>
                                </Trigger>
                                <EventTrigger RoutedEvent="MouseEnter">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="125" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseLeave">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="35" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseDown">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <ThicknessAnimation Storyboard.TargetProperty="Margin" Duration="0:0:1" To="10 4 0 0" SpeedRatio="5" AutoReverse="True"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                            </Style.Triggers>
                        </Style>
                    </StackPanel.Style>
                    <Viewbox Width="18" Height="18" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="8 0 9 0">
                        <Canvas Width="24" Height="24">
                            <Path Data="M7.5,5.6L5,7L6.4,4.5L5,2L7.5,3.4L10,2L8.6,4.5L10,7L7.5,5.6M19.5,15.4L22,14L20.6,16.5L22,19L19.5,17.6L17,19L18.4,16.5L17,14L19.5,15.4M22,2L20.6,4.5L22,7L19.5,5.6L17,7L18.4,4.5L17,2L19.5,3.4L22,2M13.34,12.78L15.78,10.34L13.66,8.22L11.22,10.66L13.34,12.78M14.37,7.29L16.71,9.63C17.1,10 17.1,10.65 16.71,11.04L5.04,22.71C4.65,23.1 4,23.1 3.63,22.71L1.29,20.37C0.9,20 0.9,19.35 1.29,18.96L12.96,7.29C13.35,6.9 14,6.9 14.37,7.29Z" 
                                  Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="LoadButtonText" Text="load settings" FontSize="14" VerticalAlignment="Center"
                               Margin="0 0 8 0" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                </StackPanel>
                <!--#endregion Load Setting Button-->

                <!--#region Change Language Button-->
                <StackPanel Margin="10 0 0 0" Height="35" Width="35" Orientation="Horizontal">
                    <StackPanel.Style>
                        <Style TargetType="{x:Type StackPanel}">
                            <Style.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter Property="Background" Value="#DADADA"/>
                                </Trigger>
                                <Trigger Property="IsMouseOver" Value="False">
                                    <Setter Property="Background" Value="{Binding ElementName=Window, Path=Background}"/>
                                </Trigger>
                                <EventTrigger RoutedEvent="MouseEnter">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="150" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseLeave">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="35" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseDown">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <ThicknessAnimation Storyboard.TargetProperty="Margin" Duration="0:0:1" To="10 4 0 0" SpeedRatio="5" AutoReverse="True"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                            </Style.Triggers>
                        </Style>
                    </StackPanel.Style>
                    <Viewbox Width="18" Height="18" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="8 0 9 0">
                        <Canvas Width="24" Height="24">
                            <Path Data="M16.36,14C16.44,13.34 16.5,12.68 16.5,12C16.5,11.32 16.44,10.66 16.36,10H19.74C19.9,10.64 20,11.31 20,12C20,12.69 19.9,13.36 19.74,14M14.59,19.56C15.19,18.45 15.65,17.25 15.97,16H18.92C17.96,17.65 16.43,18.93 14.59,19.56M14.34,14H9.66C9.56,13.34 9.5,12.68 9.5,12C9.5,11.32 9.56,10.65 9.66,10H14.34C14.43,10.65 14.5,11.32 14.5,12C14.5,12.68 14.43,13.34 14.34,14M12,19.96C11.17,18.76 10.5,17.43 10.09,16H13.91C13.5,17.43 12.83,18.76 12,19.96M8,8H5.08C6.03,6.34 7.57,5.06 9.4,4.44C8.8,5.55 8.35,6.75 8,8M5.08,16H8C8.35,17.25 8.8,18.45 9.4,19.56C7.57,18.93 6.03,17.65 5.08,16M4.26,14C4.1,13.36 4,12.69 4,12C4,11.31 4.1,10.64 4.26,10H7.64C7.56,10.66 7.5,11.32 7.5,12C7.5,12.68 7.56,13.34 7.64,14M12,4.03C12.83,5.23 13.5,6.57 13.91,8H10.09C10.5,6.57 11.17,5.23 12,4.03M18.92,8H15.97C15.65,6.75 15.19,5.55 14.59,4.44C16.43,5.07 17.96,6.34 18.92,8M12,2C6.47,2 2,6.5 2,12A10,10 0 0,0 12,22A10,10 0 0,0 22,12A10,10 0 0,0 12,2Z"
                                  Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="ChangeLanguageButtonText" Text="change language" FontSize="14" VerticalAlignment="Center"
                               Margin="0 0 8 0" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                </StackPanel>
                <!--#endregion Change Language Button-->

                <!--#region Github Button-->
                <StackPanel Margin="10 0 0 0" Height="35" Width="35" Orientation="Horizontal">
                    <StackPanel.Style>
                        <Style TargetType="{x:Type StackPanel}">
                            <Style.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter Property="Background" Value="#DADADA"/>
                                </Trigger>
                                <Trigger Property="IsMouseOver" Value="False">
                                    <Setter Property="Background" Value="{Binding ElementName=Window, Path=Background}"/>
                                </Trigger>
                                <EventTrigger RoutedEvent="MouseEnter">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="135" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseLeave">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <DoubleAnimation Storyboard.TargetProperty="Width" Duration="0:0:1" To="35" SpeedRatio="3"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                                <EventTrigger RoutedEvent="MouseDown">
                                    <EventTrigger.Actions>
                                        <BeginStoryboard>
                                            <Storyboard>
                                                <ThicknessAnimation Storyboard.TargetProperty="Margin" Duration="0:0:1" To="10 4 0 0" SpeedRatio="5" AutoReverse="True"/>
                                            </Storyboard>
                                        </BeginStoryboard>
                                    </EventTrigger.Actions>
                                </EventTrigger>
                            </Style.Triggers>
                        </Style>
                    </StackPanel.Style>
                    <Viewbox Width="18" Height="18" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="8 0 9 0">
                        <Canvas Width="24" Height="24">
                            <Path Data="M12,2A10,10 0 0,0 2,12C2,16.42 4.87,20.17 8.84,21.5C9.34,21.58 9.5,21.27 9.5,21C9.5,20.77 9.5,20.14 9.5,19.31C6.73,19.91 6.14,17.97 6.14,17.97C5.68,16.81 5.03,16.5 5.03,16.5C4.12,15.88 5.1,15.9 5.1,15.9C6.1,15.97 6.63,16.93 6.63,16.93C7.5,18.45 8.97,18 9.54,17.76C9.63,17.11 9.89,16.67 10.17,16.42C7.95,16.17 5.62,15.31 5.62,11.5C5.62,10.39 6,9.5 6.65,8.79C6.55,8.54 6.2,7.5 6.75,6.15C6.75,6.15 7.59,5.88 9.5,7.17C10.29,6.95 11.15,6.84 12,6.84C12.85,6.84 13.71,6.95 14.5,7.17C16.41,5.88 17.25,6.15 17.25,6.15C17.8,7.5 17.45,8.54 17.35,8.79C18,9.5 18.38,10.39 18.38,11.5C18.38,15.32 16.04,16.16 13.81,16.41C14.17,16.72 14.5,17.33 14.5,18.26C14.5,19.6 14.5,20.68 14.5,21C14.5,21.27 14.66,21.59 15.17,21.5C19.14,20.16 22,16.42 22,12A10,10 0 0,0 12,2Z"
                                  Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                        </Canvas>
                    </Viewbox>
                    <TextBlock Name="GithubButtonText" Text="follow on githib" FontSize="14" VerticalAlignment="Center"
                               Margin="0 0 8 0" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                </StackPanel>
                <!--#endregion Change Language Button-->
            </StackPanel>
            <!--#endregion Action Buttons Panel-->

            <!--#region Alert Panel-->
            <StackPanel Name="AlertPanel" Visibility="Collapsed" Orientation="Horizontal" Grid.Row="1" VerticalAlignment="Center">

            </StackPanel>
            <!--#endregion Alert Panel-->

            <!--#region Toggle Buttons Panel-->
            <ScrollViewer Grid.Row="2" VerticalScrollBarVisibility="Auto" HorizontalScrollBarVisibility="Auto">
                <StackPanel Orientation="Horizontal" >
                    <StackPanel Orientation="Vertical" VerticalAlignment="Top">
                        
                        <!--#region Privacy & Telemetry-->
                        <Border Name="BorderPrivacy" BorderBrush="#DADADA" BorderThickness="1 0 1 1" Margin="10 0 10 0" Height="43" Background="#FFFFFF">
                            <StackPanel Orientation="Horizontal">
                                <Viewbox Name="IconPrivacy" Width="24" Height="24" HorizontalAlignment="Center" VerticalAlignment="Center" Margin="22 0 0 3">
                                    <Canvas Width="24" Height="24">
                                        <Path Data="M18.15,4.94C17.77,4.91 17.37,5 17,5.2L8.35,10.2C7.39,10.76 7.07,12 7.62,12.94L9.12,15.53C9.67,16.5 10.89,16.82 11.85,16.27L13.65,15.23C13.92,15.69 14.32,16.06 14.81,16.27V18.04C14.81,19.13 15.7,20 16.81,20H22V18.04H16.81V16.27C17.72,15.87 18.31,14.97 18.31,14C18.31,13.54 18.19,13.11 17.97,12.73L20.5,11.27C21.47,10.71 21.8,9.5 21.24,8.53L19.74,5.94C19.4,5.34 18.79,5 18.15,4.94M6.22,13.17L2,13.87L2.75,15.17L4.75,18.63L5.5,19.93L8.22,16.63L6.22,13.17Z" Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}" />
                                    </Canvas>
                                </Viewbox>
                                <TextBlock Name="HeaderPrivacy" Text="Privacy &amp; Telemetry Settings" FontSize="16" VerticalAlignment="Center" HorizontalAlignment="Left" Margin="10 0 10 0" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchPrivacy0" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockPrivacy0" Text="Change Windows Feedback frequency to &quot;Never&quot;" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy0, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy0, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchPrivacy1" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockPrivacy1" Text="Turn off automatic installing suggested apps" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy1, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy1, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchPrivacy2" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockPrivacy2" Text="Turn off &quot;Connected User Experiences and Telemetry&quot; service" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy2, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy2, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchPrivacy3" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockPrivacy3" Text="Turn off the SQMLogger session at the next computer restart" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy3, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy3, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchPrivacy4" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockPrivacy4" Text="Do not allow apps to use advertising ID" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy4, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy4, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchPrivacy5" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockPrivacy5" Text="Do not use sign-in info to automatically finish setting up device&#x0a;after an update or restart" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy5, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy5, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchPrivacy6" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockPrivacy6" Text="Do not let websites provide locally relevant content by accessing&#x0a;language list" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy6, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy6, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchPrivacy7" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockPrivacy7" Text="Turn off suggested content in the Settings" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy7, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy7, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchPrivacy8" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockPrivacy8" Text="Turn off tip, trick, and suggestions as you use Windows" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy8, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy8, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchPrivacy9" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockPrivacy9" Text="Turn off reserved storage" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy9, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy9, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchPrivacy10" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockPrivacy10" Text="Do not let apps on other devices open and message apps&#x0a;on this device, and vice versa" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy10, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy10, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchPrivacy11" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockPrivacy11" Text="Set the operating system diagnostic data level to &quot;Basic&quot;" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy11, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy11, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchPrivacy12" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockPrivacy12" Text="Turn off the Autologger session at the next computer restart" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy12, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy12, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchPrivacy13" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockPrivacy13" Text="Turn off per-user services" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy13, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy13, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchPrivacy14" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockPrivacy14" Text="Do not offer tailored experiences based on the diagnostic data setting" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy14, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy14, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchPrivacy15" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockPrivacy15" Text="Turn off diagnostics tracking scheduled tasks" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy15, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy15, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchPrivacy16" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockPrivacy16" Text="Turn off Windows Error Reporting" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy16, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchPrivacy16, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>                        
                        <!--#endregion Privacy & Telemetry-->

                        <!--#region Context Menu-->
                        <StackPanel Orientation="Vertical" VerticalAlignment="Top">
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" 
                                Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Height="{Binding ElementName=BorderPrivacy, Path=Height}"
                                Background="{Binding ElementName=BorderPrivacy, Path=Background}">
                                <StackPanel Orientation="Horizontal">
                                    <Viewbox Width="{Binding ElementName=IconPrivacy, Path=Width}" Height="{Binding ElementName=IconPrivacy, Path=Height}" HorizontalAlignment="{Binding ElementName=IconPrivacy,Path=HorizontalAlignment}" VerticalAlignment="{Binding ElementName=IconPrivacy,Path=VerticalAlignment}" Margin="{Binding ElementName=IconPrivacy,Path=Margin}">
                                        <Canvas Width="24" Height="24">
                                            <Path Data="M3,3H9V7H3V3M15,10H21V14H15V10M15,17H21V21H15V17M13,13H7V18H13V20H7L5,20V9H7V11H13V13Z" Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}" />
                                        </Canvas>
                                    </Viewbox>
                                    <TextBlock Name="HeaderMenu" Text="Context Menu Settings" FontSize="{Binding ElementName=HeaderPrivacy,Path=FontSize}" VerticalAlignment="{Binding ElementName=HeaderPrivacy,Path=VerticalAlignment}" HorizontalAlignment="{Binding ElementName=HeaderPrivacy,Path=HorizontalAlignment}" Margin="{Binding ElementName=HeaderPrivacy,Path=Margin}" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu0" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu0" Text="Remove &quot;Edit with Paint 3D&quot; from context menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu0, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu0, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu1" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu1" Text="Remove &quot;Include in Library&quot; from context menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu1, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu1, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu2" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu2" Text="Remove &quot;Create a new video&quot; from Context Menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu2, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu2, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu3" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu3" Text="Remove &quot;Rich Text Document&quot; from context menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu3, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu3, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu4" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu4" Text="Add &quot;Extract&quot; to MSI file type context menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu4, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu4, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu5" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu5" Text="Add &quot;Install&quot; to CAB file type context menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu5, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu5, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu6" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu6" Text="Remove &quot;Edit with Photos&quot; from context menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu6, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu6, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu7" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu7" Text="Remove &quot;Cast to Device&quot; from context menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu7, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu7, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu8" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu8" Text="Remove &quot;Send to&quot; from folder context menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu8, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu8, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu9" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu9" Text="Remove &quot;Print&quot; from batch and cmd files context menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu9, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu9, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu10" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu10" Text="Remove &quot;Compressed (zipped) Folder&quot; from context menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu10, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu10, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu11" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu11" Text="Turn off &quot;Look for an app in the Microsoft Store&quot; in &quot;Open with&quot; dialog" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu11, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu11, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu12" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu12" Text="Make the &quot;Open&quot;, &quot;Print&quot;, &quot;Edit&quot; context menu items available,&#x0a;when more than 15 selected" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu12, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu12, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu13" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu13" Text="Remove &quot;Bitmap image&quot; from context menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu13, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu13, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu14" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu14" Text="Remove &quot;Share&quot; from context menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu14, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu14, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu15" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu15" Text="Add &quot;Run as different user&quot; from context menu for .exe file type" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu15, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu15, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu16" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu16" Text="Remove &quot;Previous Versions&quot; from file context menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu16, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu16, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu17" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu17" Text="Remove &quot;Edit&quot; from Context Menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu17, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu17, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchMenu18" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockMenu18" Text="Remove &quot;Turn on BitLocker&quot; from context menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu18, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchMenu18, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>                            
                        </StackPanel>
                        <!--#endregion Context Menu-->
                        
                        <!--#region Windows Game-->
                        <StackPanel Orientation="Vertical" VerticalAlignment="Top">
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" 
                                Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Height="{Binding ElementName=BorderPrivacy, Path=Height}"
                                Background="{Binding ElementName=BorderPrivacy, Path=Background}">
                                <StackPanel Orientation="Horizontal">
                                    <Viewbox Width="{Binding ElementName=IconPrivacy, Path=Width}" Height="{Binding ElementName=IconPrivacy, Path=Height}" HorizontalAlignment="{Binding ElementName=IconPrivacy,Path=HorizontalAlignment}" VerticalAlignment="{Binding ElementName=IconPrivacy,Path=VerticalAlignment}" Margin="{Binding ElementName=IconPrivacy,Path=Margin}">
                                        <Canvas Width="24" Height="24">
                                            <Path Data="M6.43,3.72C6.5,3.66 6.57,3.6 6.62,3.56C8.18,2.55 10,2 12,2C13.88,2 15.64,2.5 17.14,3.42C17.25,3.5 17.54,3.69 17.7,3.88C16.25,2.28 12,5.7 12,5.7C10.5,4.57 9.17,3.8 8.16,3.5C7.31,3.29 6.73,3.5 6.46,3.7M19.34,5.21C19.29,5.16 19.24,5.11 19.2,5.06C18.84,4.66 18.38,4.56 18,4.59C17.61,4.71 15.9,5.32 13.8,7.31C13.8,7.31 16.17,9.61 17.62,11.96C19.07,14.31 19.93,16.16 19.4,18.73C21,16.95 22,14.59 22,12C22,9.38 21,7 19.34,5.21M15.73,12.96C15.08,12.24 14.13,11.21 12.86,9.95C12.59,9.68 12.3,9.4 12,9.1C12,9.1 11.53,9.56 10.93,10.17C10.16,10.94 9.17,11.95 8.61,12.54C7.63,13.59 4.81,16.89 4.65,18.74C4.65,18.74 4,17.28 5.4,13.89C6.3,11.68 9,8.36 10.15,7.28C10.15,7.28 9.12,6.14 7.82,5.35L7.77,5.32C7.14,4.95 6.46,4.66 5.8,4.62C5.13,4.67 4.71,5.16 4.71,5.16C3.03,6.95 2,9.35 2,12A10,10 0 0,0 12,22C14.93,22 17.57,20.74 19.4,18.73C19.4,18.73 19.19,17.4 17.84,15.5C17.53,15.07 16.37,13.69 15.73,12.96Z" Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}" />
                                        </Canvas>
                                    </Viewbox>
                                    <TextBlock Name="HeaderGame" Text="Windows Game Settings" FontSize="{Binding ElementName=HeaderPrivacy,Path=FontSize}" VerticalAlignment="{Binding ElementName=HeaderPrivacy,Path=VerticalAlignment}" HorizontalAlignment="{Binding ElementName=HeaderPrivacy,Path=HorizontalAlignment}" Margin="{Binding ElementName=HeaderPrivacy,Path=Margin}" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchGame0" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockGame0" Text="Turn off Game Bar" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchGame0, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchGame0, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchGame1" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockGame1" Text="Turn off Game Mode" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchGame1, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchGame1, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchGame2" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockGame2" Text="Turn off Game Bar tips" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchGame2, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchGame2, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchGame3" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockGame3" Text="Turn off Windows Game Recording and Broadcasting" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchGame3, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchGame3, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>                            
                        </StackPanel>
                        <!--#endregion Windows Game-->

                        <!--#region Edge-->
                        <StackPanel Orientation="Vertical" VerticalAlignment="Top">
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" 
                                Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Height="{Binding ElementName=BorderPrivacy, Path=Height}"
                                Background="{Binding ElementName=BorderPrivacy, Path=Background}">
                                <StackPanel Orientation="Horizontal">
                                    <Viewbox Width="{Binding ElementName=IconPrivacy, Path=Width}" Height="{Binding ElementName=IconPrivacy, Path=Height}" HorizontalAlignment="{Binding ElementName=IconPrivacy,Path=HorizontalAlignment}" VerticalAlignment="{Binding ElementName=IconPrivacy,Path=VerticalAlignment}" Margin="{Binding ElementName=IconPrivacy,Path=Margin}">
                                        <Canvas Width="24" Height="24">
                                            <Path Data="M2.74,10.81C3.83,-1.36 22.5,-1.36 21.2,13.56H8.61C8.61,17.85 14.42,19.21 19.54,16.31V20.53C13.25,23.88 5,21.43 5,14.09C5,8.58 9.97,6.81 9.97,6.81C9.97,6.81 8.58,8.58 8.54,10.05H15.7C15.7,2.93 5.9,5.57 2.74,10.81Z" Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                        </Canvas>
                                    </Viewbox>
                                    <TextBlock Name="HeaderEdge" Text="Microsoft Edge Settings" FontSize="{Binding ElementName=HeaderPrivacy,Path=FontSize}" VerticalAlignment="{Binding ElementName=HeaderPrivacy,Path=VerticalAlignment}" HorizontalAlignment="{Binding ElementName=HeaderPrivacy,Path=HorizontalAlignment}" Margin="{Binding ElementName=HeaderPrivacy,Path=Margin}" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchEdge0" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockEdge0" Text="Do not allow Microsoft Edge to pre-launch at Windows startup,&#x0a;when the system is idle, and each time Microsoft Edge is closed" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchEdge0, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchEdge0, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchEdge1" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockEdge1" Text="Do not allow Microsoft Edge to start and load the Start and New Tab page&#x0a;at Windows startup and each time Microsoft Edge is closed" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchEdge1, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchEdge1, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchEdge2" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockEdge2" Text="Turn off Windows Defender SmartScreen for Microsoft Edge" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchEdge2, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchEdge2, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>                            
                        </StackPanel>
                        <!--#endregion Edge-->

                        <!--#region Scheduled Tasks-->
                        <StackPanel Orientation="Vertical" VerticalAlignment="Top">
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" 
                                Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Height="{Binding ElementName=BorderPrivacy, Path=Height}"
                                Background="{Binding ElementName=BorderPrivacy, Path=Background}">
                                <StackPanel Orientation="Horizontal">
                                    <Viewbox Width="{Binding ElementName=IconPrivacy, Path=Width}" Height="{Binding ElementName=IconPrivacy, Path=Height}" HorizontalAlignment="{Binding ElementName=IconPrivacy,Path=HorizontalAlignment}" VerticalAlignment="{Binding ElementName=IconPrivacy,Path=VerticalAlignment}" Margin="{Binding ElementName=IconPrivacy,Path=Margin}">
                                        <Canvas Width="24" Height="24">
                                            <Path Data="M19,19H5V8H19M19,3H18V1H16V3H8V1H6V3H5C3.89,3 3,3.9 3,5V19A2,2 0 0,0 5,21H19A2,2 0 0,0 21,19V5A2,2 0 0,0 19,3M16.53,11.06L15.47,10L10.59,14.88L8.47,12.76L7.41,13.82L10.59,17L16.53,11.06Z" Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                        </Canvas>
                                    </Viewbox>
                                    <TextBlock Name="HeaderTasks" Text="Scheduled Tasks Settings" FontSize="{Binding ElementName=HeaderPrivacy,Path=FontSize}" VerticalAlignment="{Binding ElementName=HeaderPrivacy,Path=VerticalAlignment}" HorizontalAlignment="{Binding ElementName=HeaderPrivacy,Path=HorizontalAlignment}" Margin="{Binding ElementName=HeaderPrivacy,Path=Margin}" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchTasks0" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockTasks0" Text="Create scheduled task with the &quot;%TEMP%&quot; folder cleanup in Task Scheduler.&#x0a;The task runs every 62 days" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchTasks0, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchTasks0, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchTasks1" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockTasks1" Text="Create task to clean out the &quot;%SystemRoot%\SoftwareDistribution\Download&quot;&#x0a;folder in Task Scheduler. The task runs on Thursdays every 4 weeks" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchTasks1, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchTasks1, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchTasks2" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockTasks2" Text="Create scheduled task with the disk cleanup tool in Task Scheduler.&#x0a;The task runs every 90 days" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchTasks2, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchTasks2, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>                            
                        </StackPanel>
                        <!--#endregion Scheduled Tasks-->
                        <!--Placeholder Panel-->
                        <StackPanel Height="{Binding ElementName=BorderPrivacy, Path=Height}"/>

                    </StackPanel>                    
                    <StackPanel Orientation="Vertical" VerticalAlignment="Top">
                        <!--#region UI & Personalization-->
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" 
                                Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Height="{Binding ElementName=BorderPrivacy, Path=Height}"
                                Background="{Binding ElementName=BorderPrivacy, Path=Background}">
                            <StackPanel Orientation="Horizontal">
                                <Viewbox Width="{Binding ElementName=IconPrivacy, Path=Width}" Height="{Binding ElementName=IconPrivacy, Path=Height}" HorizontalAlignment="{Binding ElementName=IconPrivacy,Path=HorizontalAlignment}" VerticalAlignment="{Binding ElementName=IconPrivacy,Path=VerticalAlignment}" Margin="{Binding ElementName=IconPrivacy,Path=Margin}">
                                    <Canvas Width="24" Height="24">
                                        <Path Data="M4 4C2.89 4 2 4.89 2 6V18C2 19.11 2.9 20 4 20H12V18H4V8H20V12H22V8C22 6.89 21.1 6 20 6H12L10 4M18 14C17.87 14 17.76 14.09 17.74 14.21L17.55 15.53C17.25 15.66 16.96 15.82 16.7 16L15.46 15.5C15.35 15.5 15.22 15.5 15.15 15.63L14.15 17.36C14.09 17.47 14.11 17.6 14.21 17.68L15.27 18.5C15.25 18.67 15.24 18.83 15.24 19C15.24 19.17 15.25 19.33 15.27 19.5L14.21 20.32C14.12 20.4 14.09 20.53 14.15 20.64L15.15 22.37C15.21 22.5 15.34 22.5 15.46 22.5L16.7 22C16.96 22.18 17.24 22.35 17.55 22.47L17.74 23.79C17.76 23.91 17.86 24 18 24H20C20.11 24 20.22 23.91 20.24 23.79L20.43 22.47C20.73 22.34 21 22.18 21.27 22L22.5 22.5C22.63 22.5 22.76 22.5 22.83 22.37L23.83 20.64C23.89 20.53 23.86 20.4 23.77 20.32L22.7 19.5C22.72 19.33 22.74 19.17 22.74 19C22.74 18.83 22.73 18.67 22.7 18.5L23.76 17.68C23.85 17.6 23.88 17.47 23.82 17.36L22.82 15.63C22.76 15.5 22.63 15.5 22.5 15.5L21.27 16C21 15.82 20.73 15.65 20.42 15.53L20.23 14.21C20.22 14.09 20.11 14 20 14M19 17.5C19.83 17.5 20.5 18.17 20.5 19C20.5 19.83 19.83 20.5 19 20.5C18.16 20.5 17.5 19.83 17.5 19C17.5 18.17 18.17 17.5 19 17.5Z" Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                    </Canvas>
                                </Viewbox>
                                <TextBlock Name="HeaderUi" Text="User Interface &amp; Personalization Settings" FontSize="{Binding ElementName=HeaderPrivacy,Path=FontSize}" VerticalAlignment="{Binding ElementName=HeaderPrivacy,Path=VerticalAlignment}" HorizontalAlignment="{Binding ElementName=HeaderPrivacy,Path=HorizontalAlignment}" Margin="{Binding ElementName=HeaderPrivacy,Path=Margin}" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi0" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi0" Text="Set the Control Panel view by large icons" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Setter Property="TextOptions.TextFormattingMode" Value="Display"/>
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi0, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi0, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi1" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi1" Text="Hide search box or search icon on taskbar" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi1, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi1, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi2" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi2" Text="Turn off &quot;New App Installed&quot; notification" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi2, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi2, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi3" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi3" Text="Turn off automatically hiding scroll bars" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi3, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi3, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi4" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi4" Text="Hide all folders in the navigation pane" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi4, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi4, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi5" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi5" Text="Hide &quot;Frequent folders&quot; in Quick access" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi5, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi5, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi6" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi6" Text="Choose theme color for default app mode" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi6, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi6, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi7" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi7" Text="Show File Name Extensions" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi7, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi7, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi8" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi8" Text="Show &quot;This PC&quot; on Desktop" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi8, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi8, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi9" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi9" Text="Show Task Manager details" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi9, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi9, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi10" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi10" Text="Remove Microsoft Edge shortcut from the Desktop" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi10, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi10, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi11" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi11" Text="Import Start menu layout from pre-saved reg file" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi11, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi11, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi12" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi12" Text="Show more details in file transfer dialog" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi12, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi12, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi13" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi13" Text="Turn off recently added apps on Start Menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi13, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi13, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi14" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi14" Text="Remove the &quot;Previous Versions&quot; tab from properties context menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi14, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi14, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi15" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi15" Text="Show more Windows Update restart notifications about restarting" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi15, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi15, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi16" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi16" Text="Turn off check boxes to select items" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi16, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi16, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi17" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi17" Text="Turn on acrylic taskbar transparency" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi17, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi17, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi18" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi18" Text="Always show all icons in the notification area" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi18, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi18, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi19" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi19" Text="Hide &quot;Windows Ink Workspace&quot; button in taskbar" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi19, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi19, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi20" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi20" Text="Hide Task View button on taskbar" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi20, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi20, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi21" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi21" Text="Turn off thumbnail cache removal" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi21, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi21, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi22" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi22" Text="Show accent color on the title bars and window borders" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi22, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi22, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi23" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi23" Text="Save screenshots by pressing Win+PrtScr to the Desktop" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi23, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi23, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi24" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi24" Text="Turn on ribbon in File Explorer" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi24, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi24, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi25" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi25" Text="Turn on recycle bin files delete confirmation" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi25, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi25, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi26" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi26" Text="Choose theme color for default Windows mode" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi26, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi26, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi27" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi27" Text="Turn off user first sign-in animation" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi27, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi27, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi28" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi28" Text="Let Windows try to fix apps so they're not blurry" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi28, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi28, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi29" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi29" Text="Turn off the &quot;- Shortcut&quot; name extension for new shortcuts" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi29, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi29, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi30" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi30" Text="Turn off JPEG desktop wallpaper import quality reduction" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi30, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi30, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi31" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi31" Text="Unpin Microsoft Edge and Microsoft Store from taskbar" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi31, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi31, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi32" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi32" Text="Show seconds on taskbar clock" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi32, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi32, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi33" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi33" Text="Hide People button on the taskbar" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi33, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi33, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi34" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi34" Text="Turn off Snap Assist" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi34, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi34, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi35" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi35" Text="Show Hidden Files, Folders, and Drives" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi35, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi35, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi36" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi36" Text="Show folder merge conflicts" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi36, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi36, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi37" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi37" Text="Hide &quot;Recent files&quot; in Quick access" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi37, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi37, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi38" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi38" Text="Turn off creation of an Edge shortcut on the desktop for each user profile" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi38, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi38, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi39" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi39" Text="Remove 3D Objects folder in &quot;This PC&quot; and in the navigation pane" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi39, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi39, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi40" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi40" Text="Turn off app launch tracking to improve Start menu and search results" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi40, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi40, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchUi41" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockUi41" Text="Set File Explorer to open to This PC by default" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi41, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchUi41, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>                        
                        <!--#endregion UI & Personalization-->

                        <!--#region Microsoft Defender-->
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" 
                                Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Height="{Binding ElementName=BorderPrivacy, Path=Height}"
                                Background="{Binding ElementName=BorderPrivacy, Path=Background}">
                            <StackPanel Orientation="Horizontal">
                                <Viewbox Width="{Binding ElementName=IconPrivacy, Path=Width}" Height="{Binding ElementName=IconPrivacy, Path=Height}" HorizontalAlignment="{Binding ElementName=IconPrivacy,Path=HorizontalAlignment}" VerticalAlignment="{Binding ElementName=IconPrivacy,Path=VerticalAlignment}" Margin="{Binding ElementName=IconPrivacy,Path=Margin}">
                                    <Canvas Width="24" Height="24">
                                        <Path Data="M21,11C21,16.55 17.16,21.74 12,23C6.84,21.74 3,16.55 3,11V5L12,1L21,5V11M12,21C15.75,20 19,15.54 19,11.22V6.3L12,3.18V21Z" Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                    </Canvas>
                                </Viewbox>
                                <TextBlock Name="HeaderDefender" Text="Microsoft Defender Settings" FontSize="{Binding ElementName=HeaderPrivacy,Path=FontSize}" VerticalAlignment="{Binding ElementName=HeaderPrivacy,Path=VerticalAlignment}" HorizontalAlignment="{Binding ElementName=HeaderPrivacy,Path=HorizontalAlignment}" Margin="{Binding ElementName=HeaderPrivacy,Path=Margin}" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchDefender0" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockDefender0" Text="Add folder to exclude from Windows Defender Antivirus scan" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchDefender0, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchDefender0, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchDefender1" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockDefender1" Text="Turn on Controlled folder access and add protected folders" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchDefender1, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchDefender1, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchDefender2" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockDefender2" Text="Hide notification about disabled Smartscreen for Microsoft Edge" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchDefender2, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchDefender2, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchDefender3" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockDefender3" Text="Turn on Windows Defender Sandbox" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchDefender3, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchDefender3, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchDefender4" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockDefender4" Text="Hide notification about sign in with Microsoft in the Windows Security" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchDefender4, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchDefender4, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchDefender5" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockDefender5" Text="Turn on Windows Defender Exploit Guard Network Protection" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchDefender5, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchDefender5, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>
                        <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                            <StackPanel Orientation="Horizontal" Margin="5">
                                <Grid HorizontalAlignment="Left">
                                    <ToggleButton Name="ToggleSwitchDefender6" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                    <TextBlock Name="TexBlockDefender6" Text="Turn on Windows Defender PUA Protection" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                        <TextBlock.Style>
                                            <Style TargetType="{x:Type TextBlock}">
                                                <Style.Triggers>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchDefender6, Path=IsChecked}" Value="True">
                                                        <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                    </DataTrigger>
                                                    <DataTrigger Binding="{Binding ElementName=ToggleSwitchDefender6, Path=IsEnabled}" Value="false">
                                                        <Setter Property="Opacity" Value="0.2" />
                                                    </DataTrigger>
                                                </Style.Triggers>
                                            </Style>
                                        </TextBlock.Style>
                                    </TextBlock>
                                </Grid>
                            </StackPanel>
                        </Border>                        
                        <!--#endregion Microsoft Defender-->
                        
                    </StackPanel>
                    <StackPanel Orientation="Vertical" VerticalAlignment="Top">
                        
                        <!--#region System-->
                        <StackPanel Orientation="Vertical" VerticalAlignment="Top">
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" 
                                Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Height="{Binding ElementName=BorderPrivacy, Path=Height}"
                                Background="{Binding ElementName=BorderPrivacy, Path=Background}">
                                <StackPanel Orientation="Horizontal">
                                    <Viewbox Width="{Binding ElementName=IconPrivacy, Path=Width}" Height="{Binding ElementName=IconPrivacy, Path=Height}" HorizontalAlignment="{Binding ElementName=IconPrivacy,Path=HorizontalAlignment}" VerticalAlignment="{Binding ElementName=IconPrivacy,Path=VerticalAlignment}" Margin="{Binding ElementName=IconPrivacy,Path=Margin}">
                                        <Canvas Width="24" Height="24">
                                            <Path Data="M12,15.5A3.5,3.5 0 0,1 8.5,12A3.5,3.5 0 0,1 12,8.5A3.5,3.5 0 0,1 15.5,12A3.5,3.5 0 0,1 12,15.5M19.43,12.97C19.47,12.65 19.5,12.33 19.5,12C19.5,11.67 19.47,11.34 19.43,11L21.54,9.37C21.73,9.22 21.78,8.95 21.66,8.73L19.66,5.27C19.54,5.05 19.27,4.96 19.05,5.05L16.56,6.05C16.04,5.66 15.5,5.32 14.87,5.07L14.5,2.42C14.46,2.18 14.25,2 14,2H10C9.75,2 9.54,2.18 9.5,2.42L9.13,5.07C8.5,5.32 7.96,5.66 7.44,6.05L4.95,5.05C4.73,4.96 4.46,5.05 4.34,5.27L2.34,8.73C2.21,8.95 2.27,9.22 2.46,9.37L4.57,11C4.53,11.34 4.5,11.67 4.5,12C4.5,12.33 4.53,12.65 4.57,12.97L2.46,14.63C2.27,14.78 2.21,15.05 2.34,15.27L4.34,18.73C4.46,18.95 4.73,19.03 4.95,18.95L7.44,17.94C7.96,18.34 8.5,18.68 9.13,18.93L9.5,21.58C9.54,21.82 9.75,22 10,22H14C14.25,22 14.46,21.82 14.5,21.58L14.87,18.93C15.5,18.67 16.04,18.34 16.56,17.94L19.05,18.95C19.27,19.03 19.54,18.95 19.66,18.73L21.66,15.27C21.78,15.05 21.73,14.78 21.54,14.63L19.43,12.97Z" Fill="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                        </Canvas>
                                    </Viewbox>
                                    <TextBlock Name="HeaderSystem" Text="System Settings" FontSize="{Binding ElementName=HeaderPrivacy,Path=FontSize}" VerticalAlignment="{Binding ElementName=HeaderPrivacy,Path=VerticalAlignment}" HorizontalAlignment="{Binding ElementName=HeaderPrivacy,Path=HorizontalAlignment}" Margin="{Binding ElementName=HeaderPrivacy,Path=Margin}" Foreground="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem0" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem0" Text="Group svchost.exe processes" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem0, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem0, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem1" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem1" Text="Remove Windows capabilities" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem1, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem1, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem2" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem2" Text="Turn on Num Lock at startup" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem2, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem2, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem3" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem3" Text="Turn on the display of stop error information on the BSoD" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem3, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem3, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem4" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem4" Text="Always wait for the network at computer startup and logon" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem4, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem4, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem5" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem5" Text="Turn on Storage Sense to automatically free up space" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem5, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem5, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem6" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem6" Text="Set the default input method to the English language" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem6, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem6, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem7" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem7" Text="Do not allow the computer to turn off the device to save power for desktop" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem7, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem7, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem8" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem8" Text="Turn off &quot;The Windows Filtering Platform has blocked a connection&quot; message" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem8, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem8, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem9" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem9" Text="Turn off default background apps except" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem9, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem9, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem10" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem10" Text="Turn off SmartScreen for apps and files" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem10, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem10, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem11" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem11" Text="Turn on .NET 4 runtime for all apps" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem11, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem11, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem12" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem12" Text="Launch folder in a separate process" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem12, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem12, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem13" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem13" Text="Turn off hibernate" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem13, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem13, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem14" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem14" Text="Uninstall OneDrive" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem14, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem14, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem15" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem15" Text="Delete temporary files that apps aren't using" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem15, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem15, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem16" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem16" Text="Turn on automatic recommended troubleshooting" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem16, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem16, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem17" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem17" Text="Delete files in recycle bin if they have been there for over 30 days" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem17, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem17, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem18" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem18" Text="Open shortcut to the Command Prompt from Start menu as Administrator" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem18, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem18, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem19" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem19" Text="Turn off app suggestions on Start menu" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem19, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem19, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem20" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem20" Text="Turn on firewall &amp; network protection" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem20, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem20, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem21" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem21" Text="Remove printers" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem21, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem21, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem22" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem22" Text="Turn on Windows Sandbox" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem22, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem22, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem23" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem23" Text="Turn off sticky Shift key after pressing 5 times" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem23, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem23, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem24" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem24" Text="Set power management scheme for desktop and laptop" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem24, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem24, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem25" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem25" Text="Turn off Windows Script Host" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem25, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem25, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem26" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem26" Text="Set &quot;High performance&quot; in graphics performance preference for apps" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem26, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem26, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem27" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem27" Text="Automatically adjust active hours for me based on daily usage" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem27, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem27, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem28" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem28" Text="Turn on automatic backup the system registry to the&#x0a;&quot;C:\Windows\System32\config\RegBack&quot; folder" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem28, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem28, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem29" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem29" Text="Set location of the &quot;Desktop&quot;, &quot;Documents&quot; &quot;Downloads&quot; &quot;Music&quot;,&#x0a;&quot;Pictures&quot; and &quot;Videos&quot;" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem29, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem29, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem30" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem30" Text="Use the PrtScn button to open screen snipping" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem30, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem30, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem31" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem31" Text="Create old style shortcut for &quot;Devices and Printers&quot; in&#x0a;&quot;%AppData%\Roaming\Microsoft\Windows\Start Menu\Programs\System Tools&quot;" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem31, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem31, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem32" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem32" Text="Turn off F1 Help key" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem32, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem32, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem33" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem33" Text="Turn on Win32 long paths" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem33, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem33, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem34" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem34" Text="Turn on Retpoline patch against Spectre v2" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem34, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem34, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem35" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem35" Text="Do not preserve zone information" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem35, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem35, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem36" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem36" Text="Change environment variable for &quot;%Temp%&quot; to &quot;%SystemDrive%\Temp&quot;" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem36, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem36, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem37" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem37" Text="Run Storage Sense every month" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem37, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem37, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem38" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem38" Text="Never delete files in &quot;Downloads&quot; folder" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem38, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem38, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem39" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem39" Text="Turn off location for this device" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem39, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem39, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem40" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem40" Text="Turn off Admin Approval Mode for administrators" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem40, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem40, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem41" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem41" Text="Turn off Windows features" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem41, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem41, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem42" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem42" Text="Turn on updates for other Microsoft products" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem42, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem42, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem43" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem43" Text="Enable System Restore" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem43, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem43, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem44" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem44" Text="Do not allow Windows 10 to manage default printer" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem44, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem44, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem45" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem45" Text="Turn on access to mapped drives from app running&#x0a;with elevated permissions with Admin Approval Mode enabled" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem45, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem45, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem46" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem46" Text="Set download mode for delivery optization on &quot;HTTP only&quot;" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem46, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem46, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem47" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem47" Text="Turn off Cortana" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem47, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem47, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>
                            <Border BorderBrush="{Binding ElementName=BorderPrivacy, Path=BorderBrush}" BorderThickness="{Binding ElementName=BorderPrivacy, Path=BorderThickness}" Margin="{Binding ElementName=BorderPrivacy, Path=Margin}" Style="{StaticResource BorderHoverStyle}">
                                <StackPanel Orientation="Horizontal" Margin="5">
                                    <Grid HorizontalAlignment="Left">
                                        <ToggleButton Name="ToggleSwitchSystem48" Style="{DynamicResource ToggleSwitchLeftStyle}" IsChecked="False"/>
                                        <TextBlock Name="TexBlockSystem48" Text="Turn off IPv6" Margin="65 2 10 0" VerticalAlignment="Center" IsHitTestVisible="False">
                                            <TextBlock.Style>
                                                <Style TargetType="{x:Type TextBlock}">
                                                    <Style.Triggers>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem48, Path=IsChecked}" Value="True">
                                                            <Setter Property="Foreground" Value="{Binding ElementName=BorderWindow, Path=BorderBrush}"/>
                                                        </DataTrigger>
                                                        <DataTrigger Binding="{Binding ElementName=ToggleSwitchSystem48, Path=IsEnabled}" Value="false">
                                                            <Setter Property="Opacity" Value="0.2" />
                                                        </DataTrigger>
                                                    </Style.Triggers>
                                                </Style>
                                            </TextBlock.Style>
                                        </TextBlock>
                                    </Grid>
                                </StackPanel>
                            </Border>                            
                        </StackPanel>
                        <!--#endregion System-->
                        
                    </StackPanel>
                </StackPanel>
            </ScrollViewer>
            <!--#endregion Toggle Buttons Panel-->
        </Grid>
    </Border>
</Window>
'@

$xamlGui = [System.Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xamlMarkup))
$xamlMarkup.SelectNodes('//*[@Name]') | ForEach-Object {
    
    if ($_.Name.Contains("ToggleButton")) {

        $ToggleBtn = $xamlGui.FindName($_.Name)
        [Void]$ToggleButtons.Add($ToggleBtn)
    }
	
	else
	{
		New-Variable -Name $_.Name -Value $xamlGui.FindName($_.Name)
	}    
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

$xamlGui.add_MouseLeftButtonDown( {
        $xamlGui.DragMove()
    })

$MinimizeButton.add_MouseLeftButtonDown( {
        $xamlGui.WindowState = "Minimized"
    })

$CloseButton.add_MouseLeftButtonDown( {
        $xamlGui.Close()
    })

#endregion

Hide-Console
$xamlGui.ShowDialog() | Out-Null