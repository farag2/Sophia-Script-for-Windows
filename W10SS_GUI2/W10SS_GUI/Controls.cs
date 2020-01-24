using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;

namespace W10SS_GUI
{
    public partial class Controls : ResourceDictionary
    {
        private void ButtonClose_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            Application.Current.MainWindow.Close();
        }

        private void ButtonMinimize_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            Application.Current.MainWindow.WindowState = WindowState.Minimized;
        }

        private void ButtonHamburger_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            
        }
    }
}
