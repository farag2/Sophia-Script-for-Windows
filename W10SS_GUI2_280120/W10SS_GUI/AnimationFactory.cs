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

        internal struct Element
        {
            internal const int Hamburger = 0;
        }

        private struct Speed
        {
            internal const int ButtonHamburger = 5;
        }

        internal Dictionary<int, Storyboard> Storyboards = new Dictionary<int, Storyboard>();
        internal Dictionary<int, DoubleAnimation> Animations = new Dictionary<int, DoubleAnimation>();

        public AnimationFactory()
        {
            #region Hamburger Animation

            DoubleAnimation animation = new DoubleAnimation
            {
                Duration = new System.Windows.Duration(new TimeSpan(hours: 0, minutes: 0, seconds: Duration.ButtonHamburger)),
                SpeedRatio = Speed.ButtonHamburger
            };

            Storyboard storyboard = new Storyboard();
            Storyboard.SetTargetProperty(animation, new PropertyPath(FrameworkElement.HeightProperty));
            storyboard.Children.Add(animation);

            Animations.Add(Element.Hamburger, animation);
            Storyboards.Add(Element.Hamburger, storyboard);
            
            #endregion Hamburger Animation
        }

    }
}