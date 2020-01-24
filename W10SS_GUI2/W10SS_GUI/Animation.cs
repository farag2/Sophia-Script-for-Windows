using System;
using System.Windows;
using System.Windows.Media.Animation;

namespace W10SS_GUI
{
    internal class Animation
    {
        internal static void NewAnimationFactory()
        {
            DoubleAnimation hamburgerAnimation = new DoubleAnimation
            {
                Duration = new Duration(new TimeSpan(hours: 0, minutes: 0, seconds: (int)GuiEnum.AnimationHamburgerDuration)),
                SpeedRatio = (double)GuiEnum.AnimationHamburgerSpeedRatio
            };
        }
    }
}