using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
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

namespace W10SS_GUI.Controls
{
    /// <summary>
    /// Логика взаимодействия для ToggleSwitch.xaml
    /// </summary>
    public partial class ToggleSwitch : UserControl
    {
        private Brush brushBackground { get; set; } = Application.Current.TryFindResource("colorToggleBackground") as Brush;
        private Brush brushBackgroundHover { get; set; } = Application.Current.TryFindResource("colorToggleBackgroundHover") as Brush;

        public ToggleSwitch()
        {
            InitializeComponent();
        }

        public bool IsChecked
        {
            get { return (bool)GetValue(IsCheckedProperty); }
            set { SetValue(IsCheckedProperty, value); }
        }

        // Using a DependencyProperty as the backing store for IsChecked.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty IsCheckedProperty =
            DependencyProperty.Register("IsChecked", typeof(bool), typeof(ToggleSwitch), new PropertyMetadata(default(bool)));

        //public string Icon
        //{
        //    get { return (string)GetValue(IconProperty); }
        //    set { SetValue(IconProperty, value); }
        //}

        //// Using a DependencyProperty as the backing store for Icon.  This enables animation, styling, binding, etc...
        //public static readonly DependencyProperty IconProperty =
        //    DependencyProperty.Register("Icon", typeof(string), typeof(ToggleSwitch), new PropertyMetadata(default(string)));

        public string Header
        {
            get { return (string)GetValue(HeaderProperty); }
            set { SetValue(HeaderProperty, value); }
        }

        // Using a DependencyProperty as the backing store for Header.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty HeaderProperty =
            DependencyProperty.Register("Header", typeof(string), typeof(ToggleSwitch), new PropertyMetadata(default(string)));

        public string Description
        {
            get { return (string)GetValue(DescriptionProperty); }
            set { SetValue(DescriptionProperty, value); }
        }

        // Using a DependencyProperty as the backing store for Description.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty DescriptionProperty =
            DependencyProperty.Register("Description", typeof(string), typeof(ToggleSwitch), new PropertyMetadata(default(string)));

        public bool IsValid
        {
            get { return (bool)GetValue(IsValidProperty); }
            set { SetValue(IsValidProperty, value); }
        }

        // Using a DependencyProperty as the backing store for IsValid.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty IsValidProperty =
            DependencyProperty.Register("IsValid", typeof(bool), typeof(ToggleSwitch), new PropertyMetadata(default(bool)));


        public string ScriptPath
        {
            get { return (string)GetValue(ScriptPathProperty); }
            set { SetValue(ScriptPathProperty, value); }
        }

        // Using a DependencyProperty as the backing store for ScriptPath.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty ScriptPathProperty =
            DependencyProperty.Register("ScriptPath", typeof(string), typeof(ToggleSwitch), new PropertyMetadata(default(string)));


        private void ToggleSwitch_Click(object sender, RoutedEventArgs e)
        {
            gridToggleSwitch.Background = toggleSwitch.IsChecked == true ? brushBackgroundHover : brushBackground ;
        }

        private void GridToggleSwitch_MouseEnter(object sender, MouseEventArgs e)
        {
            if (toggleSwitch.IsChecked == false) gridToggleSwitch.Background = brushBackgroundHover;
        }

        private void GridToggleSwitch_MouseLeave(object sender, MouseEventArgs e)
        {
            if (toggleSwitch.IsChecked == false) gridToggleSwitch.Background = brushBackground;
        }
    }
}
