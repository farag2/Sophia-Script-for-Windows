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
        public MainWindow()
        {
            InitializeComponent();            
        }        

        private void Window_Initialized(object sender, EventArgs e)
        {
            SetLanguageDictionary();                        
        }        
        
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
    }
}
