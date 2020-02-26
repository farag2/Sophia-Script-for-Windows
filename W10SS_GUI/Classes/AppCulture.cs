using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;

namespace W10SS_GUI
{
    internal class AppCulture
    {
       private class Culture
        {
            internal const string EN = "en";
            internal const string RU = "ru";
        }

        private string _culture = Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName == Culture.RU ? Culture.RU : Culture.EN;
        private ResourceDictionary resourceDictionaryEn = new ResourceDictionary() { Source = new Uri("pack://application:,,,/Localized/EN.xaml", UriKind.Absolute) };
        private ResourceDictionary resourceDictionaryRu = new ResourceDictionary() { Source = new Uri("pack://application:,,,/Localized/RU.xaml", UriKind.Absolute) };
        internal ResourceDictionary CurrentCulture
        {
            get
            {
                return _culture == Culture.RU ? resourceDictionaryRu : resourceDictionaryEn;
            }            
        }

        internal ResourceDictionary ChangeCulture()
        {
            if (_culture == Culture.RU) _culture = Culture.EN;
            else _culture = Culture.RU;
            return _culture == Culture.RU ? resourceDictionaryRu : resourceDictionaryEn;
        }
    }
}
