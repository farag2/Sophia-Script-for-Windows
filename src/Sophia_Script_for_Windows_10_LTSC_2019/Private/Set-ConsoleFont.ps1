<#
	.SYNOPSIS
	Set console font to Consolas when script is called from the Wrapper due to it is not loaded by default

	.LINK
	https://github.com/ReneNyffenegger/ps-modules-console
#>
function Set-ConsoleFont
{
	$Signature = @{
		Namespace          = "WinAPI"
		Name               = "ConsoleFont"
		Language           = "CSharp"
		MemberDefinition   = @"
[StructLayout(LayoutKind.Sequential)]

public struct COORD
{
	public short X;
	public short Y;

	public COORD(short x, short y)
	{
		X = x;
		Y = y;
	}
}

[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]

public struct CONSOLE_FONT_INFOEX
{
	public uint  cbSize;
	public uint  n;
	public COORD size;

	// The four low-order bits of 'family' specify information about the pitch and the technology:
	//     1 = TMPF_FIXED_PITCH, 2 = TMPF_VECTOR, 4 = TMPF_TRUETYPE, 8 = TMPF_DEVICE.
	// The four high-order bits specifies the fonts family:
	//     80 = FF_DECORATIVE, 0 = FF_DONTCARE, 48 = FF_MODERN, 16 = FF_ROMAN, 64 = FF_SCRIPT, 32 = FF_SWISS
	//     I assume(!) this value is always 48.
	//    (In fact, it seems that family is is always 54 = TMPF_VECTOR + TMPF_TRUETYPE + FF_MODERN)
	public int   family;
	public int   weight;

	[MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
	public string name;
}

[DllImport("kernel32.dll", SetLastError = true)] 
public static extern IntPtr GetStdHandle(int nStdHandle);

[DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
extern static bool GetCurrentConsoleFontEx(
	IntPtr hConsoleOutput,
	bool   bMaximumWindow,
	ref    CONSOLE_FONT_INFOEX lpConsoleCurrentFont
);

[DllImport("kernel32.dll", SetLastError = true)]
static extern Int32 SetCurrentConsoleFontEx(
	IntPtr ConsoleOutput,
	bool   MaximumWindow,
	ref    CONSOLE_FONT_INFOEX lpConsoleCurrentFont
);

public static CONSOLE_FONT_INFOEX GetFont()
{
	CONSOLE_FONT_INFOEX ret = new CONSOLE_FONT_INFOEX();

	ret.cbSize = (uint) Marshal.SizeOf(ret);
	if (GetCurrentConsoleFontEx(GetStdHandle(-11), false, ref ret))
	{
		return ret;
	}

	throw new Exception("something went wrong with GetCurrentConsoleFontEx");
}

public static void SetFont(CONSOLE_FONT_INFOEX font)
{
	if (SetCurrentConsoleFontEx(GetStdHandle(-11), false, ref font ) == 0)
	{
		throw new Exception("something went wrong with SetCurrentConsoleFontEx");
	}
}

public static void SetSize(short w, short h)
{
	CONSOLE_FONT_INFOEX font = GetFont();
	font.size.X = w;
	font.size.Y = h;
	SetFont(font);
}

public static void SetName(string name)
{
	CONSOLE_FONT_INFOEX font = GetFont();
	font.name = name;
	SetFont(font);
}
"@
	}
	if (-not ("WinAPI.ConsoleFont" -as [type]))
	{
		Add-Type @Signature
	}
	[WinAPI.ConsoleFont]::SetName("Consolas")
}

# We need to be sure that the Wrapper generated a powershell.exe process. If that true, we need to set Consolas font, unless a Sophia Script logo in console is distored
$PowerShellParentProcessId = (Get-CimInstance -ClassName CIM_Process | Where-Object -FilterScript {$_.Name -eq "powershell.exe"}).ParentProcessId
$ParrentProcess = Get-Process -Id $PowerShellParentProcessId -ErrorAction Ignore
$WrapperProcess = Get-Process -Name SophiaScriptWrapper -ErrorAction Ignore
if ($ParrentProcess.Id -eq $WrapperProcess.Id)
{
	Set-ConsoleFont
}
