# https://github.com/PowerShell/PowerShell/issues/21070
$Global:CompilerParameters                  = [System.CodeDom.Compiler.CompilerParameters]::new("System.dll")
$Global:CompilerParameters.TempFiles        = [System.CodeDom.Compiler.TempFileCollection]::new($env:TEMP, $false)
$Global:CompilerParameters.GenerateInMemory = $true

# Get localization from dll
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
