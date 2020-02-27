using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using W10SS_GUI;

namespace W10SS_GUI.Classes
{
    internal class Gui
    {
        private Dictionary<string, StackPanel> _togglesCategoryPanels = new Dictionary<string, StackPanel>();
        private MainWindow MainWindow = Application.Current.MainWindow as MainWindow;

        public Gui()
        {
            InitializeVariables();            
        }

        private void InitializeVariables()
        {
            foreach (var tagValue in Application.Current.Resources.MergedDictionaries.Where(r => r.Source.Segments[2] == "tags.xaml").FirstOrDefault().Values)
            {
                _togglesCategoryPanels.Add(tagValue.ToString(), MainWindow.panelTogglesCategoryContainer.Children.OfType<StackPanel>().Where(p => p.Tag == tagValue).FirstOrDefault());
            }
        }

        internal void SetActivePanel(string PanelsTag, string HeaderText)
        {
            foreach (KeyValuePair<string, StackPanel> kvp in _togglesCategoryPanels)
            {
                kvp.Value.Visibility = kvp.Key == PanelsTag ? Visibility.Visible : Visibility.Collapsed;
            }

            MainWindow.textTogglesHeader.Text = HeaderText;            
        }
    }
}