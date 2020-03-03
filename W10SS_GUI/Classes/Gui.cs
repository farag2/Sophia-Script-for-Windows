using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media.Animation;
using W10SS_GUI.Controls;
using W10SS_GUI.Properties;

namespace W10SS_GUI.Classes
{
    internal class Gui
    {
        private Dictionary<string, StackPanel> _togglesCategoryPanels = new Dictionary<string, StackPanel>();
        private MainWindow MainWindow = Application.Current.MainWindow as MainWindow;
        private HamburgerCategoryButton _lastclickedbutton;

        internal string LastClickedButtonName
        {
            get
            {
                return _lastclickedbutton.Name as string;
            }
        }

        internal Gui()
        {
            InitializeVariables();            
        }

        internal void InitializeVariables()
        {
            foreach (var tagValue in Application.Current.Resources.MergedDictionaries.Where(r => r.Source.Segments[2] == "tags.xaml").FirstOrDefault().Values)
            {
                _togglesCategoryPanels.Add(tagValue.ToString(), MainWindow.panelTogglesCategoryContainer.Children.OfType<StackPanel>().Where(p => p.Tag == tagValue).FirstOrDefault());
            }
        }
        
        internal void SetActivePanel(HamburgerCategoryButton button)
        {
            _lastclickedbutton = button;

            foreach (KeyValuePair<string, StackPanel> kvp in _togglesCategoryPanels)
            {
                kvp.Value.Visibility = kvp.Key == button.Tag as string ? Visibility.Visible : Visibility.Collapsed;
            }

            MainWindow.textTogglesHeader.Text = MainWindow.Resources[button.Name] as string;            
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
            List<string> tagsByName = _togglesCategoryPanels.Keys.ToList();
            List<string> appScriptsFolders = tagsByName.Select(k => Path.Combine(AppDomain.CurrentDomain.BaseDirectory, k)).ToList();

            for (int i = 0; i < appScriptsFolders.Count; i++)
            {
                StackPanel panel = GetPanelByName(tagsByName[i]);

                if (Directory.Exists(appScriptsFolders[i]))
                {
                    uint sc = 0;
                    foreach (string item in Directory.GetFiles(appScriptsFolders[i], "*.ps1", SearchOption.AllDirectories))
                    {                        
                        ToggleSwitch toggleSwitch = new ToggleSwitch()
                        {
                            
                        };
                        sc++;
                    }
                }

                else
                {

                }
            }
        }

        internal StackPanel GetPanelByName(string name) => _togglesCategoryPanels[name] as StackPanel;
    }
}