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
    /// Логика взаимодействия для HamburgerCategoryFlashButton.xaml
    /// </summary>
    public partial class HamburgerCategoryFlashButton : UserControl
    {
        public HamburgerCategoryFlashButton()
        {
            InitializeComponent();
        }

        public string Text
        {
            get { return (string)GetValue(TextProperty); }
            set { SetValue(TextProperty, value); }
        }

        // Using a DependencyProperty as the backing store for Text.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty TextProperty =
            DependencyProperty.Register("Text", typeof(string), typeof(HamburgerCategoryFlashButton), new PropertyMetadata(default(string)));

        public string Icon
        {
            get { return (string)GetValue(IconProperty); }
            set { SetValue(IconProperty, value); }
        }

        // Using a DependencyProperty as the backing store for IconText.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty IconProperty =
            DependencyProperty.Register("Icon", typeof(string), typeof(HamburgerCategoryFlashButton), new PropertyMetadata(default(string)));

        public Thickness TextMargin
        {
            get { return (Thickness)GetValue(TextMarginProperty); }
            set { SetValue(TextMarginProperty, value); }
        }

        // Using a DependencyProperty as the backing store for TextMargin.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty TextMarginProperty =
            DependencyProperty.Register("TextMargin", typeof(Thickness), typeof(HamburgerCategoryFlashButton), new PropertyMetadata(default(Thickness)));
        public Visibility IconVisibility
        {
            get { return (Visibility)GetValue(IconVisibilityProperty); }
            set { SetValue(IconVisibilityProperty, value); }
        }

        // Using a DependencyProperty as the backing store for IconVisibility.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty IconVisibilityProperty =
            DependencyProperty.Register("IconVisibility", typeof(Visibility), typeof(HamburgerCategoryFlashButton), new PropertyMetadata(default(Visibility)));

        public Geometry ViewboxPathData
        {
            get { return (Geometry)GetValue(ViewboxPathDataProperty); }
            set { SetValue(ViewboxPathDataProperty, value); }
        }

        // Using a DependencyProperty as the backing store for ViewboxPathData.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty ViewboxPathDataProperty =
            DependencyProperty.Register("ViewboxPathData", typeof(Geometry), typeof(HamburgerCategoryFlashButton), new PropertyMetadata(default(Geometry)));

        public Visibility ViewboxPathVisibility
        {
            get { return (Visibility)GetValue(ViewboxPathVisibilityProperty); }
            set { SetValue(ViewboxPathVisibilityProperty, value); }
        }

        // Using a DependencyProperty as the backing store for ViewboxPathVisibility.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty ViewboxPathVisibilityProperty =
            DependencyProperty.Register("ViewboxPathVisibility", typeof(Visibility), typeof(HamburgerCategoryFlashButton), new PropertyMetadata(default(Visibility)));
    }
}
