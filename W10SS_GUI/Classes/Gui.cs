using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media.Animation;
using W10SS_GUI.Controls;
using W10SS_GUI.Properties;

namespace W10SS_GUI.Classes
{
    internal class Gui
    {
        private Dictionary<string, StackPanel> _togglesCategoryAndPanels = new Dictionary<string, StackPanel>();
        private static uint TogglesCounter = default(uint);
        private MainWindow MainWindow = Application.Current.MainWindow as MainWindow;
        private HamburgerCategoryButton _lastclickedbutton;
        private static List<ToggleSwitch> TogglesSwitches = new List<ToggleSwitch>();

        internal string LastClickedButtonName => _lastclickedbutton.Name as string;
        
        internal Gui()
        {
            InitializeGuiVariables();            
        }

        private void InitializeGuiVariables()
        {
            foreach (var tagValue in Application.Current.Resources.MergedDictionaries.Where(r => r.Source.LocalPath == "/Resource/tags.xaml").First().Values)
            {
                _togglesCategoryAndPanels.Add(tagValue.ToString(), MainWindow.panelTogglesCategoryContainer.Children.OfType<StackPanel>().Where(p => p.Tag == tagValue).First());
            }
        }
        
        internal void SetActivePanel(HamburgerCategoryButton button)
        {
            _lastclickedbutton = button;

            foreach (KeyValuePair<string, StackPanel> kvp in _togglesCategoryAndPanels)
            {
                kvp.Value.Visibility = kvp.Key == button.Tag as string ? Visibility.Visible : Visibility.Collapsed;
            }

            MainWindow.textTogglesHeader.Text = MainWindow.Resources[button.Name] as string;            
        }

        internal void HamburgerReOpen()
        {
            MouseEventArgs mouseLeaveArgs = new MouseEventArgs(Mouse.PrimaryDevice, 0)
            {
                RoutedEvent = Mouse.MouseLeaveEvent
            };

            MouseEventArgs mouseEnterArgs = new MouseEventArgs(Mouse.PrimaryDevice, 0)
            {
                RoutedEvent = Mouse.MouseEnterEvent
            };

            MainWindow.panelHamburger.RaiseEvent(mouseLeaveArgs);
            MainWindow.panelHamburger.RaiseEvent(mouseEnterArgs);
        }

        internal void SetHamburgerWidth(string cultureName)
        {
            Storyboard hamburgerOpen = MainWindow.TryFindResource("animationHamburgerOpen") as Storyboard;
            DoubleAnimation animation = hamburgerOpen.Children[0] as DoubleAnimation;
            animation.To = cultureName == "ru"
                ? Convert.ToDouble(MainWindow.TryFindResource("panelHamburgerRuMaxWidth"))
                : Convert.ToDouble(MainWindow.TryFindResource("panelHamburgerEnMaxWidth"));            
        }

        internal void InitializeToggles()
        {
            for (int i = 0; i < _togglesCategoryAndPanels.Keys.Count; i++)
            {
                string categoryName = _togglesCategoryAndPanels.Keys.ToList()[i];
                StackPanel categoryPanel = _togglesCategoryAndPanels[categoryName];
                string psScriptsDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, categoryName);
                
                List<ToggleSwitch> togglesSwitches = Directory.Exists(psScriptsDir)
                    && Directory.EnumerateFiles(psScriptsDir, "*.*", SearchOption.AllDirectories)
                                .Where(f => f.EndsWith(".ps1"))
                                .Count() > 0

                    ? Directory.EnumerateFiles(psScriptsDir, "*.*", SearchOption.AllDirectories)
                               .Where(f => f.EndsWith(".ps1"))
                               .Select(f => CreateToogleSwitchFromScript(f))
                               .ToList()
                    : null ;

                togglesSwitches?.Where(t => t.IsValid == true).ToList().ForEach(t => categoryPanel.Children.Add(t));               
            }
        }

        internal static ToggleSwitch CreateToogleSwitchFromScript(string scriptPath)
        {
            string dictionaryHeaderID = $"ToggleHeader-{TogglesCounter}";
            string dictionaryDescriptionID = $"ToggleDescription-{TogglesCounter}";
            string[] arrayLines = new string[4];

            ResourceDictionary dictionaryEN = new ResourceDictionary
            {
                Source = new Uri("/Localized/EN.xaml", UriKind.Relative)
            };

            ResourceDictionary dictionaryRU = new ResourceDictionary()
            {
                Source = new Uri("/Localized/RU.xaml", UriKind.Relative)
            };

            ToggleSwitch toggleSwitch = new ToggleSwitch()
            {
                ScriptPath = scriptPath
            };
                        
            try
            {
                using (StreamReader streamReader = new StreamReader(scriptPath, Encoding.UTF8))
                {
                    for (int i = 0; i < 4; i++)
                    {
                        string textLine = streamReader.ReadLine();                        
                        toggleSwitch.IsValid = textLine.StartsWith("# ") && textLine.Length >= 10 ? true : false;
                        arrayLines[i] = textLine.Replace("# ", "");                                               
                    }
                }
            }
            catch (Exception)
            {
                
            }

            dictionaryEN[dictionaryHeaderID] = arrayLines[0];
            dictionaryEN[dictionaryDescriptionID] = arrayLines[1];
            dictionaryRU[dictionaryHeaderID] = arrayLines[2];
            dictionaryRU[dictionaryDescriptionID] = arrayLines[3];

            toggleSwitch.SetResourceReference(ToggleSwitch.HeaderProperty, dictionaryHeaderID);
            toggleSwitch.SetResourceReference(ToggleSwitch.DescriptionProperty, dictionaryDescriptionID);
            
            TogglesCounter++;
            TogglesSwitches.Add(toggleSwitch);
            return toggleSwitch;
        }        
    }
}