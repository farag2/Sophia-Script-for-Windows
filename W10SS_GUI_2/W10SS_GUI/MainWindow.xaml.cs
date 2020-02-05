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
        //TODO: УДАЛИТЬ Animation Factory        
        AnimationFactory AnimationFactory = new AnimationFactory();

        public MainWindow()
        {
            InitializeComponent();            
        }        

        private void Window_Initialized(object sender, EventArgs e)
        {
            SetLanguageDictionary();            
            //buttonHamburger.Click += ButtonHamburger_Click;
        }

        private void ButtonWindowMinimize_Click(object sender, RoutedEventArgs e) => Application.Current.MainWindow.WindowState = WindowState.Minimized;
        
        private void ButtonWindowClose_Click(object sender, RoutedEventArgs e) => Application.Current.MainWindow.Close();
        
        private void SetLanguageDictionary()
        {
            ResourceDictionary dict = new ResourceDictionary();

            switch (Thread.CurrentThread.CurrentCulture.ToString())
            {
                default:
                    dict.Source = new Uri("pack://application:,,,/Localized/EN.xaml", UriKind.Absolute);
                    break;
            }

            Resources.MergedDictionaries.Add(dict);
        }

        private void ButtonHamburger_Click(object sender, RoutedEventArgs e)
        {
            //AnimationFactory.Animations["Hamburger"].To = panelHamburger.ActualWidth == panelHamburger.MinWidth ?
            //    panelHamburger.MaxWidth : panelHamburger.MinWidth;
            //AnimationFactory.Storyboards["Hamburger"].Begin(panelHamburger);
        }

        private void HamburgerCategoryButton_Loaded(object sender, RoutedEventArgs e)
        {

        }
    }
}
