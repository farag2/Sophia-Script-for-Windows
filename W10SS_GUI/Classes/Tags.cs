using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace W10SS_GUI
{
   internal static class Tags
    {
        internal static readonly string Privacy = string.Format("{0}", Application.Current.Resources["tagCategoryPrivacy"]);
        internal static readonly string Ui = string.Format("{0}", Application.Current.Resources["tagCategoryUi"]);
        internal static readonly string OneDrive = string.Format("{0}", Application.Current.Resources["tagCategoryOneDrive"]);
        internal static readonly string System = string.Format("{0}", Application.Current.Resources["tagCategorySystem"]);
        internal static readonly string StartMenu = string.Format("{0}", Application.Current.Resources["tagCategoryStartMenu"]);
        internal static readonly string Uwp = string.Format("{0}", Application.Current.Resources["tagCategoryUwp"]);
        internal static readonly string WinGame = string.Format("{0}", Application.Current.Resources["tagCategoryWinGame"]);
        internal static readonly string TaskScheduler = string.Format("{0}", Application.Current.Resources["tagCategoryTaskScheduler"]);
        internal static readonly string Defender = string.Format("{0}", Application.Current.Resources["tagCategoryDefender"]);
        internal static readonly string ContextMenu = string.Format("{0}", Application.Current.Resources["tagCategoryContextMenu"]);
    }
}
