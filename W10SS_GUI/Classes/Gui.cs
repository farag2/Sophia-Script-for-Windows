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

        private void InitializeVariables()
        {
            foreach (var tagValue in Application.Current.Resources.MergedDictionaries.Where(r => r.Source.Segments[2] == "tags.xaml").FirstOrDefault().Values)
            {
                _togglesCategoryAndPanels.Add(tagValue.ToString(), MainWindow.panelTogglesCategoryContainer.Children.OfType<StackPanel>().Where(p => p.Tag == tagValue).FirstOrDefault());
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

        internal void HamburgerReopen()
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
                string scriptsCategoryDirs = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, _togglesCategoryAndPanels.Keys.ToList()[i]);
                List<string> scriptsFiles = Directory.Exists(scriptsCategoryDirs)
                    && Directory.EnumerateFiles(scriptsCategoryDirs, "*.*", SearchOption.AllDirectories).Where(f => f.EndsWith(".ps1")).Count() > 0
                    ? Directory.EnumerateFiles(scriptsCategoryDirs, "*.*", SearchOption.AllDirectories).Where(f => f.EndsWith(".ps1")).ToList()
                    : null ;

                scriptsFiles?.ForEach(s =>
                {
                    Gui.ReadToggleData(s);

                    
                });
            }
        }

        internal StackPanel GetPanelByName(string name) => _togglesCategoryAndPanels[name] as StackPanel;
    }
}