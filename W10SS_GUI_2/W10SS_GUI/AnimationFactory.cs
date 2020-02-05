using System;
using System.Collections;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Media.Animation;

namespace W10SS_GUI
{
    internal class AnimationFactory
    {
        private struct Duration
        {
            internal const int ButtonHamburger = 1;
        }

        private struct Speed
        {
            internal const int ButtonHamburger = 5;
        }

        internal Dictionary<string, Storyboard> Storyboards = new Dictionary<string, Storyboard>();
        internal Dictionary<string, DoubleAnimation> Animations = new Dictionary<string, DoubleAnimation>();

        public AnimationFactory()
        {
            #region Hamburger Animation

            DoubleAnimation animation = new DoubleAnimation
            {
                Duration = new System.Windows.Duration(new TimeSpan(hours: 0, minutes: 0, seconds: Duration.ButtonHamburger)),
                SpeedRatio = Speed.ButtonHamburger
            };

            Storyboard storyboard = new Storyboard();
            Storyboard.SetTargetProperty(animation, new PropertyPath(FrameworkElement.WidthProperty));
            storyboard.Children.Add(animation);

            Animations.Add("Hamburger", animation);
            Storyboards.Add("Hamburger", storyboard);
            
            #endregion Hamburger Animation
        }

    }
}