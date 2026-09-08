<#
	.SYNOPSIS
	Set console font to Consolas when the script is launched from the Wrapper, as it is not applied by default

	.LINK
	https://github.com/ReneNyffenegger/ps-modules-console
#>

# We have to be sure that powershell.exe was spawned by the Wrapper, otherwise the Sophia Script logo gets distorted
$ParentProcessId = (Get-CimInstance -ClassName Win32_Process -Filter "ProcessId = $PID" -Property ParentProcessId).ParentProcessId
$ParentProcess = Get-Process -Id $ParentProcessId -ErrorAction Ignore
$ParentProcess.ProcessName -eq "SophiaScriptWrapper" |set-content -path D:\Sophia-Script-for-Windows\Wrapper\1.txt
pause
if ($ParentProcess.ProcessName -eq "SophiaScriptWrapper")
{
	$Signature = @{
		Namespace        = "WinAPI"
		Name             = "ConsoleFont"
		Language         = "CSharp"
		UsingNamespace   = "System.ComponentModel"
		MemberDefinition = @"
[StructLayout(LayoutKind.Sequential)]
public struct COORD
{
	public short X;
	public short Y;
}

[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
public struct CONSOLE_FONT_INFOEX
{
	public uint cbSize;
	public uint nFont;
	public COORD dwFontSize;
	// The four low-order bits specify the pitch and technology, the four high-order bits specify the font family
	// 54 = TMPF_VECTOR | TMPF_TRUETYPE | FF_MODERN
	public int FontFamily;
	public int FontWeight;
	[MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
	public string FaceName;
}

[DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
private static extern IntPtr CreateFile(string lpFileName, uint dwDesiredAccess, uint dwShareMode, IntPtr lpSecurityAttributes, uint dwCreationDisposition, uint dwFlagsAndAttributes, IntPtr hTemplateFile);

[DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
private static extern bool GetCurrentConsoleFontEx(IntPtr hConsoleOutput, bool bMaximumWindow, ref CONSOLE_FONT_INFOEX lpConsoleCurrentFont);

[DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
private static extern bool SetCurrentConsoleFontEx(IntPtr hConsoleOutput, bool bMaximumWindow, ref CONSOLE_FONT_INFOEX lpConsoleCurrentFont);

[DllImport("kernel32.dll", SetLastError = true)]
private static extern bool CloseHandle(IntPtr hObject);

public static void SetName(string name)
{
	// GENERIC_READ | GENERIC_WRITE, FILE_SHARE_READ | FILE_SHARE_WRITE, OPEN_EXISTING
	// Unlike GetStdHandle(-11), CONOUT$ always refers to the console even if stdout is redirected
	IntPtr handle = CreateFile("CONOUT$", 0x80000000 | 0x40000000, 3, IntPtr.Zero, 3, 0, IntPtr.Zero);
	if (handle == new IntPtr(-1))
	{
		throw new Win32Exception(Marshal.GetLastWin32Error(), "Cannot open CONOUT$");
	}

	try
	{
		CONSOLE_FONT_INFOEX font = new CONSOLE_FONT_INFOEX();
		font.cbSize = (uint)Marshal.SizeOf(typeof(CONSOLE_FONT_INFOEX));

		if (!GetCurrentConsoleFontEx(handle, false, ref font))
		{
			throw new Win32Exception(Marshal.GetLastWin32Error(), "GetCurrentConsoleFontEx failed");
		}

		if (font.FaceName == name)
		{
			return;
		}

		font.FaceName = name;
		font.FontFamily = 54;
		font.FontWeight = 400;
		// Let the console calculate the glyph width itself, as the current one may come from a raster font
		font.dwFontSize.X = 0;
		if (font.dwFontSize.Y <= 0)
		{
			font.dwFontSize.Y = 16;
		}

		if (!SetCurrentConsoleFontEx(handle, false, ref font))
		{
			throw new Win32Exception(Marshal.GetLastWin32Error(), "SetCurrentConsoleFontEx failed");
		}
	}
	finally
	{
		CloseHandle(handle);
	}
}
"@
	}

	if (-not ("WinAPI.ConsoleFont" -as [type]))
	{
		Add-Type @Signature
	}

	[WinAPI.ConsoleFont]::SetName("Consolas")
}
