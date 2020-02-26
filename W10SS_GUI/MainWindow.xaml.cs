using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
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
using W10SS_GUI.Controls;

namespace W10SS_GUI
{
    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private Dictionary<string, StackPanel> TogglesCategoryPanels = new Dictionary<string, StackPanel>();
        private AppCulture AppCulture = new AppCulture();        

        public MainWindow()
        {
            InitializeComponent();
            SetUiLanguage();
            InitializeVariables();
            InitializeToggles();                           
        }

        private void InitializeToggles()
        {
            //AppDomain.CurrentDomain.BaseDirectory
        }

        private void InitializeVariables()
        {
            ICollection tagsDictionaryValues = Application.Current.Resources.MergedDictionaries.Where(r => r.Source.Segments[2] == "tags.xaml").FirstOrDefault().Values;            
            
            foreach (var tagValue in tagsDictionaryValues)
            {
                TogglesCategoryPanels.Add(tagValue.ToString(), panelTogglesCategoryContainer.Children.OfType<StackPanel>().Where(p => p.Tag == tagValue).FirstOrDefault());
            }

            textTogglesHeader.Text = buttonHamburgerPrivacy.Text;
        }

        private void SetUiLanguage()
        {
            Resources.MergedDictionaries.Add(AppCulture.CurrentCulture);                
        }

        private void ButtonHamburger_Click(object sender, MouseButtonEventArgs e)
        {
            HamburgerCategoryButton button = sender as HamburgerCategoryButton;
            string tag = button.Tag.ToString();

            foreach (KeyValuePair<string, StackPanel> kvp in TogglesCategoryPanels)
            {
                kvp.Value.Visibility = kvp.Key == tag ? Visibility.Visible : Visibility.Collapsed;
            }

            textTogglesHeader.Text = button.Text;    
        }

        private void ButtonHamburgerLanguageSettings_Click(object sender, MouseButtonEventArgs e)
        {            
            Resources.MergedDictionaries.Add(AppCulture.ChangeCulture());
            textTogglesHeader.Text = buttonHamburgerPrivacy.Text;
        }
    }
}
