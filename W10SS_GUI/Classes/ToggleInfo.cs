using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace W10SS_GUI.Classes
{
    internal class ToggleInfo
    {
        internal string DescriptionEN { get; set; } = default(string);
        internal string DescriptionRU { get; set; } = default(string);
        internal string HeaderEN { get; set; } = default(string);
        internal string HeaderRU { get; set; } = default(string);
        internal string PanelName { get; set; } = default(string);
        internal string ScriptPath { get; set; } = default(string);
        internal bool IsValid { get; set; } = default(bool);
    }
}
