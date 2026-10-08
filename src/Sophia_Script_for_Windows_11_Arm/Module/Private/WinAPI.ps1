# https://github.com/PowerShell/PowerShell/issues/21070
$Global:CompilerParameters                  = [System.CodeDom.Compiler.CompilerParameters]::new("System.dll")
$Global:CompilerParameters.TempFiles        = [System.CodeDom.Compiler.TempFileCollection]::new($env:TEMP, $false)
$Global:CompilerParameters.GenerateInMemory = $true

# Extract localized strings from %SystemRoot%\System32\shell32.dll
$Signature = @{
	Namespace          = "WinAPI"
	Name               = "GetStrings"
	Language           = "CSharp"
	UsingNamespace     = "System.Text"
	CompilerParameters = $CompilerParameters
	MemberDefinition   = @"
[DllImport("kernel32.dll", CharSet = CharSet.Auto)]
public static extern IntPtr GetModuleHandle(string lpModuleName);

[DllImport("user32.dll", CharSet = CharSet.Auto)]
internal static extern int LoadString(IntPtr hInstance, uint uID, StringBuilder lpBuffer, int nBufferMax);

public static string GetString(uint strId)
{
	IntPtr intPtr = GetModuleHandle("shell32.dll");
	StringBuilder sb = new StringBuilder(255);
	LoadString(intPtr, strId, sb, sb.Capacity);
	return sb.ToString();
}

// Get string from other DLLs
[DllImport("shlwapi.dll", CharSet=CharSet.Unicode)]
private static extern int SHLoadIndirectString(string pszSource, StringBuilder pszOutBuf, int cchOutBuf, string ppvReserved);

public static string GetIndirectString(string indirectString)
{
	try
	{
		int returnValue;
		StringBuilder lptStr = new StringBuilder(1024);
		returnValue = SHLoadIndirectString(indirectString, lptStr, 1024, null);

		if (returnValue == 0)
		{
			return lptStr.ToString();
		}
		else
		{
			return null;
		}
	}
	catch
	{
		return null;
	}
}
"@
}

if (-not ("WinAPI.GetStrings" -as [type]))
{
	try
	{
		Add-Type @Signature -ErrorAction Stop
	}
	catch
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.CodeCompilationFailed, $Localization.ReinstallWindows -join " ")
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message $Localization.AskQuestion -Verbose
		Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://t.me/sophianews" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}
}

# Move window to foreground
$Signature = @{
	Namespace          = "WinAPI"
	Name               = "ForegroundWindow"
	Language           = "CSharp"
	CompilerParameters = $CompilerParameters
	MemberDefinition   = @"
[DllImport("user32.dll")]
public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

[DllImport("user32.dll")]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool SetForegroundWindow(IntPtr hWnd);
"@
}

if (-not ("WinAPI.ForegroundWindow" -as [type]))
{
	try
	{
		Add-Type @Signature -ErrorAction Stop
	}
	catch
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.CodeCompilationFailed, $Localization.ReinstallWindows -join " ")
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message $Localization.AskQuestion -Verbose
		Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://t.me/sophianews" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}
}

# Get the real Windows version like %SystemRoot%\system32\winver.exe relies on
$Signature = @{
	Namespace          = "WinAPI"
	Name               = "Winbrand"
	Language           = "CSharp"
	CompilerParameters = $CompilerParameters
	MemberDefinition   = @"
[DllImport("Winbrand.dll", CharSet = CharSet.Unicode)]
public extern static string BrandingFormatString(string sFormat);
"@
}
if (-not ("WinAPI.Winbrand" -as [type]))
{
	try
	{
		Add-Type @Signature -ErrorAction Stop
	}
	catch
	{
		Write-Information -MessageData "" -InformationAction Continue
		Write-Warning -Message ($Localization.CodeCompilationFailed, $Localization.ReinstallWindows -join " ")
		Write-Information -MessageData "" -InformationAction Continue

		Write-Verbose -Message $Localization.AskQuestion -Verbose
		Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
		Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
		Write-Verbose -Message "https://t.me/sophianews" -Verbose
		Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

		$Global:Failed = $true

		exit
	}
}

# Reload cursor on-the-fly for Install-Cursors function
$Signature = @{
	Namespace          = "WinAPI"
	Name               = "Cursor"
	Language           = "CSharp"
	CompilerParameters = $CompilerParameters
	MemberDefinition   = @"
[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, IntPtr pvParam, uint fWinIni);
"@
}
if (-not ("WinAPI.Cursor" -as [type]))
{
	Add-Type @Signature
}

# Simulate pressing F5 to refresh Desktop and refresh desktop icons, environment variables, taskbar
$Signature = @{
	Namespace          = "WinAPI"
	Name               = "UpdateEnvironment"
	Language           = "CSharp"
	CompilerParameters = $CompilerParameters
	MemberDefinition   = @"
private static readonly IntPtr HWND_BROADCAST = new IntPtr(0xffff);
private const int WM_SETTINGCHANGE = 0x1a;
private const int SMTO_ABORTIFHUNG = 0x0002;

[DllImport("shell32.dll", CharSet = CharSet.Auto, SetLastError = false)]
private static extern int SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2);

[DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = false)]
private static extern IntPtr SendMessageTimeout(IntPtr hWnd, int Msg, IntPtr wParam, string lParam, int fuFlags, int uTimeout, IntPtr lpdwResult);

[DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = false)]
static extern bool SendNotifyMessage(IntPtr hWnd, uint Msg, IntPtr wParam, string lParam);

public static void Refresh()
{
	// Update desktop icons
	SHChangeNotify(0x8000000, 0x1000, IntPtr.Zero, IntPtr.Zero);

	// Update environment variables
	SendMessageTimeout(HWND_BROADCAST, WM_SETTINGCHANGE, IntPtr.Zero, "Environment", SMTO_ABORTIFHUNG, 100, IntPtr.Zero);

	// Update taskbar
	SendNotifyMessage(HWND_BROADCAST, WM_SETTINGCHANGE, IntPtr.Zero, "TraySettings");
}

private static readonly IntPtr hWnd = new IntPtr(65535);
private const int Msg = 273;
// Virtual key ID of the F5 in File Explorer
private static readonly UIntPtr UIntPtr = new UIntPtr(41504);

[DllImport("user32.dll", SetLastError=true)]
public static extern int PostMessageW(IntPtr hWnd, uint Msg, UIntPtr wParam, IntPtr lParam);

public static void PostMessage()
{
	// Simulate pressing F5 to refresh the desktop
	PostMessageW(hWnd, Msg, UIntPtr, IntPtr.Zero);
}
"@
}
if (-not ("WinAPI.UpdateEnvironment" -as [type]))
{
	Add-Type @Signature
}
