using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Media.Animation;

namespace W10SS_GUI
{
    internal class Animation
    {
        internal static Storyboard NewHamburgerMenuAnimation()
        {
            DoubleAnimation animation = new DoubleAnimation
            {
                Duration = new Duration(new TimeSpan(hours: 0, minutes: 0, seconds: (int)GuiEnum.AnimationHamburgerDuration)),
                SpeedRatio = (double)GuiEnum.AnimationHamburgerSpeedRatio
            };

            Storyboard storyboard = new Storyboard();
            Storyboard.SetTargetProperty(animation, new PropertyPath(System.Windows.Controls.StackPanel.WidthProperty));
            storyboard.Children.Add(animation);
            return storyboard;
        }

        internal static void SetHamburgerMenuAnimationDirection(Storyboard storyboard, double hamburgerMenuWidth)
        {
            ((DoubleAnimation)storyboard.Children[0]).To = hamburgerMenuWidth == (double)GuiEnum.HamburgerMenuMinWidth
                ? (double)GuiEnum.HamburgerMenuMaxWidth : (double)GuiEnum.HamburgerMenuMinWidth;           
        }
    }
}
