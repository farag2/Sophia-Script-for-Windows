using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Markup;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace W10SS_GUI.Controls
{
    /// <summary>
    /// Логика взаимодействия для TogglesCategoryPanel.xaml
    /// </summary>
    
    public partial class TogglesCategoryPanel : UserControl
    {
        public TogglesCategoryPanel()
        {
            InitializeComponent();
        }



        public Thickness HeaderMargin
        {
            get { return (Thickness)GetValue(HeaderMarginProperty); }
            set { SetValue(HeaderMarginProperty, value); }
        }

        // Using a DependencyProperty as the backing store for HeaderMargin.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty HeaderMarginProperty =
            DependencyProperty.Register("HeaderMargin", typeof(Thickness), typeof(TogglesCategoryPanel), new PropertyMetadata(default(Thickness)));
        
    }
}
