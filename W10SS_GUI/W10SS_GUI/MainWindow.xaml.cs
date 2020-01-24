using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace W10SS_GUI
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        Storyboard animationHamburgerMenu = Animation.NewHamburgerMenuAnimation();

        private void SetLanguageDictionary()
        {
            ResourceDictionary dict = new ResourceDictionary();

            switch (Thread.CurrentThread.CurrentCulture.ToString())
            {
                default:
                    dict.Source = new Uri("pack://application:,,,/LocalizedResources/localizedRU.xaml", UriKind.Absolute);
                    break;
            }

            Resources.MergedDictionaries.Add(dict);
        }

        public MainWindow()
        {
            InitializeComponent();
            SetLanguageDictionary();
        }

        private void ButtonClose_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            Window.Close();            
        }

        private void ButtonMinimize_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            Window.WindowState = WindowState.Minimized;
        }

        private void ButtonHamburger_MouseDown(object sender, MouseButtonEventArgs e)
        {
            Animation.SetHamburgerMenuAnimationDirection(animationHamburgerMenu, panelHamburger.ActualWidth);
            animationHamburgerMenu.Begin(panelHamburger);
        }

        private void Window_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            DragMove();
        }        
    }
}
