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
        private List<ToggleSwitch> TogglesSwitches = new List<ToggleSwitch>();

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
                string categoryName = _togglesCategoryAndPanels[_togglesCategoryAndPanels.Keys.ToList()[i]].Name;
                string psScriptsDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, categoryName.Name);
                
                TogglesSwitches = Directory.Exists(psScriptsDir)
                    && Directory.EnumerateFiles(psScriptsDir, "*.*", SearchOption.AllDirectories)
                                .Where(f => f.EndsWith(".ps1"))
                                .Count() > 0

                    ? Directory.EnumerateFiles(psScriptsDir, "*.*", SearchOption.AllDirectories)
                               .Where(f => f.EndsWith(".ps1"))
                               .Select(p => CreateToogleSwitchFromScript(scriptPath:p, panelName:categoryName))
                               .ToList()
                    : null;



            }
        }

        internal ToggleSwitch CreateToogleSwitchFromScript(string scriptPath, string panelName)
        {
            ToggleSwitch toggleSwitch = new ToggleSwitch();
            //{
            //    ScriptPath = scriptPath,
            //    PanelName = panel
            //};

            //try
            //{
            //    using (StreamReader streamReader = new StreamReader(scriptPath, Encoding.UTF8))
            //    {
            //        for (int i = 0; i < 4; i++)
            //        {
            //            string textLine = streamReader.ReadLine();
            //            toggleInfo.IsValid = textLine.StartsWith("# ") && textLine.Length >= 10 ? true : false;

            //            switch (i)
            //            {
            //                case 0:
            //                    toggleInfo.HeaderEN = textLine.Replace("# ", "");
            //                    break;

            //                case 1:
            //                    toggleInfo.DescriptionEN = textLine.Replace("# ", "");
            //                    break;

            //                case 2:
            //                    toggleInfo.HeaderRU = textLine.Replace("# ", "");
            //                    break;

            //                case 3:
            //                    toggleInfo.DescriptionRU = textLine.Replace("# ", "");
            //                    break;

            //                default:
            //                    break;
            //            }
            //        }
            //    }
            //}
            //catch (Exception)
            //{

            //}

            return toggleSwitch;
        }

        //internal ToggleInfo NewToogleInfoFromScript(string scriptPath, string panelName)
        //{
        //    ToggleInfo toggleInfo = new ToggleInfo
        //    {
        //        ScriptPath = scriptPath,
        //        PanelName = panelName
        //    };

        //    try
        //    {
        //        using (StreamReader streamReader = new StreamReader(scriptPath, Encoding.UTF8))
        //        {
        //            for (int i = 0; i < 4; i++)
        //            {
        //                string textLine = streamReader.ReadLine();
        //                toggleInfo.IsValid = textLine.StartsWith("# ") && textLine.Length >= 10 ? true : false;

        //                switch (i)
        //                {
        //                    case 0:
        //                        toggleInfo.HeaderEN = textLine.Replace("# ", "");
        //                        break;

        //                    case 1:
        //                        toggleInfo.DescriptionEN = textLine.Replace("# ", "");
        //                        break;

        //                    case 2:
        //                        toggleInfo.HeaderRU = textLine.Replace("# ", "");
        //                        break;

        //                    case 3:
        //                        toggleInfo.DescriptionRU = textLine.Replace("# ", "");
        //                        break;

        //                    default:
        //                        break;
        //                }
        //            }                   
        //        }
        //    }
        //    catch (Exception)
        //    {

        //    }

        //    return toggleInfo;
        //}
    }
}