# https://github.com/PowerShell/PowerShell/issues/21070
$Global:CompilerParameters                  = [System.CodeDom.Compiler.CompilerParameters]::new("System.dll")
$Global:CompilerParameters.TempFiles        = [System.CodeDom.Compiler.TempFileCollection]::new($env:TEMP, $false)
$Global:CompilerParameters.GenerateInMemory = $true

# Extract localized strings from %SystemRoot%\System32\shell32.dll
$Signature = @{
	Namespace        = "WinAPI"
	Name             = "GetStrings"
	Language         = "CSharp"
	UsingNamespace   = "System.Text"
	CompilerOptions  = $CompilerParameters
	MemberDefinition = @"
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
	Namespace        = "WinAPI"
	Name             = "ForegroundWindow"
	Language         = "CSharp"
	CompilerOptions  = $CompilerOptions
	MemberDefinition = @"
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
	Namespace        = "WinAPI"
	Name             = "Winbrand"
	Language         = "CSharp"
	CompilerOptions  = $CompilerParameters
	MemberDefinition = @"
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
	Namespace        = "WinAPI"
	Name             = "Cursor"
	Language         = "CSharp"
	CompilerOptions  = $CompilerParameters
	MemberDefinition = @"
[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, uint pvParam, uint fWinIni);
"@
}
if (-not ("WinAPI.Cursor" -as [type]))
{
	Add-Type @Signature
}
[WinAPI.Cursor]::SystemParametersInfo(0x0057, 0, $null, 0)

# Read registry key last write time for Get-Hash (Set-Association)
$Signature = @{
	Namespace        = "WinAPI"
	Name             = "Action"
	Language         = "CSharp"
	UsingNamespace   = "Microsoft.Win32"
	CompilerOptions  = $CompilerParameters
	MemberDefinition = @"
[DllImport("advapi32.dll", CharSet = CharSet.Unicode, EntryPoint = "RegOpenKeyExW", ExactSpelling = true)]
private static extern int RegOpenKeyEx(IntPtr hKey, string lpSubKey, int ulOptions, int samDesired, out IntPtr phkResult);

[DllImport("advapi32.dll", ExactSpelling = true)]
private static extern int RegCloseKey(IntPtr hKey);

[DllImport("advapi32.dll", CharSet = CharSet.Unicode, EntryPoint = "RegQueryInfoKeyW", ExactSpelling = true)]
private static extern int RegQueryInfoKey(IntPtr hKey, IntPtr lpClass, IntPtr lpcchClass, IntPtr lpReserved,
	out uint lpcSubKeys, out uint lpcbMaxSubKeyLen, out uint lpcbMaxClassLen, out uint lpcValues,
	out uint lpcbMaxValueNameLen, out uint lpcbMaxValueLen, out uint lpcbSecurityDescriptor,
	out System.Runtime.InteropServices.ComTypes.FILETIME lpftLastWriteTime);

private const int ERROR_SUCCESS   = 0;
private const int KEY_READ        = 0x20019;
private const int KEY_WOW64_64KEY = 0x0100;

// winreg.h defines predefined keys as ((HKEY)(ULONG_PTR)((LONG)0x8000000n)),
// i.e. sign-extended to 64 bits. new IntPtr(int) reproduces that exactly.
private static IntPtr ToHandle(RegistryHive hive)
{
	return new IntPtr((int)hive);
}

// Returns the key's last write time as UTC, or null if the key cannot be opened or queried.
public static DateTime? GetLastModified(RegistryHive hive, string subKey)
{
	IntPtr hKey = IntPtr.Zero;

	try
	{
		if (RegOpenKeyEx(ToHandle(hive), subKey, 0, KEY_READ | KEY_WOW64_64KEY, out hKey) != ERROR_SUCCESS)
		{
			return null;
		}

		uint subKeys, maxSubKeyLen, maxClassLen, values, maxValueNameLen, maxValueLen, securityDescriptor;
		System.Runtime.InteropServices.ComTypes.FILETIME lastWriteTime;

		if (RegQueryInfoKey(hKey, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero,
			out subKeys, out maxSubKeyLen, out maxClassLen, out values,
			out maxValueNameLen, out maxValueLen, out securityDescriptor, out lastWriteTime) != ERROR_SUCCESS)
		{
			return null;
		}

		long fileTime = ((long)lastWriteTime.dwHighDateTime << 32) | (uint)lastWriteTime.dwLowDateTime;

		return DateTime.FromFileTimeUtc(fileTime);
	}
	finally
	{
		if (hKey != IntPtr.Zero)
		{
			RegCloseKey(hKey);
		}
	}
}
"@
}

if (-not ("WinAPI.Action" -as [type]))
{
	Add-Type @Signature
}
