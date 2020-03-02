using System;
using System.Collections.Generic;
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
            Storyboard storyboard = MainWindow.TryFindResource("animationHamburgerOpen") as Storyboard;
            DoubleAnimation animation = storyboard.Children[0] as DoubleAnimation;
            animation.To = cultureName == "ru"
                ? Convert.ToDouble(MainWindow.TryFindResource("panelHamburgerRuMaxWidth"))
                : Convert.ToDouble(MainWindow.TryFindResource("panelHamburgerEnMaxWidth"));                   
        }
    }
}