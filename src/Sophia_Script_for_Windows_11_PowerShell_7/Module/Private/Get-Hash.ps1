<#
	.SYNOPSIS
	Calculate hash for Set-Association function

	.VERSION
	7.3.0

	.DATE
	05.09.2026

	.COPYRIGHT
	(c) 2014—2026 Team Sophia

	.LINK
	https://github.com/farag2/Sophia-Script-for-Windows
#>
function Get-Hash
{
	[CmdletBinding()]
	[OutputType([string])]
	Param
	(
		[Parameter(
			Mandatory = $true,
			Position = 0
		)]
		[string]
		$ProgId,

		[Parameter(
			Mandatory = $true,
			Position = 1
		)]
		[string]
		$Extension,

		[Parameter(
			Mandatory = $true,
			Position = 2
		)]
		[string]
		$SubKey
	)

	$Signature = @{
		Namespace        = "WinAPI"
		Name             = "PatentHash"
		Language         = "CSharp"
		CompilerOptions  = $CompilerParameters
		MemberDefinition = @"
// Secret static string stored in %SystemRoot%\System32\shell32.dll
private const string UserExperience = "User Choice set via Windows User Experience {D18B6DD5-6124-4341-9318-804003BAFA0B}";

[DllImport("advapi32.dll", CharSet = CharSet.Unicode)]
private static extern int RegQueryInfoKey(
	Microsoft.Win32.SafeHandles.SafeRegistryHandle hKey,
	IntPtr lpClass,
	IntPtr lpcchClass,
	IntPtr lpReserved,
	IntPtr lpcSubKeys,
	IntPtr lpcbMaxSubKeyLen,
	IntPtr lpcbMaxClassLen,
	IntPtr lpcValues,
	IntPtr lpcbMaxValueNameLen,
	IntPtr lpcbMaxValueLen,
	IntPtr lpcbSecurityDescriptor,
	out long lpftLastWriteTime
);

private static string GetKeyTimestamp(string subKey)
{
	using (Microsoft.Win32.RegistryKey key = Microsoft.Win32.Registry.CurrentUser.OpenSubKey(subKey))
	{
		if (key == null)
		{
			throw new ArgumentException("Registry key not found: HKCU\\" + subKey, "subKey");
		}

		long fileTime;
		int result = RegQueryInfoKey(key.Handle, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, IntPtr.Zero, out fileTime);
		if (result != 0)
		{
			throw new InvalidOperationException(String.Format("RegQueryInfoKey failed: 0x{0:X8}", result));
		}

		// Truncate to whole minutes: 1 minute = 600 000 000 * 100 ns
		fileTime -= fileTime % 600000000L;

		return fileTime.ToString("x16");
	}
}

public static string Get(string extension, string sid, string progId, string subKey)
{
	string baseInfo = (extension + sid + progId + GetKeyTimestamp(subKey) + UserExperience).ToLowerInvariant();

	// UTF-16LE with the terminating null character included
	byte[] data = System.Text.Encoding.Unicode.GetBytes(baseInfo + "\0");

	byte[] md5;
	using (System.Security.Cryptography.MD5 hasher = System.Security.Cryptography.MD5.Create())
	{
		md5 = hasher.ComputeHash(data);
	}

	// Number of DWORDs, rounded down to an even value
	int length = (data.Length >> 2) & ~1;
	if (length < 2)
	{
		throw new ArgumentException("Input data is too short");
	}

	unchecked
	{
		uint c0 = BitConverter.ToUInt32(md5, 0) | 1;
		uint c1 = BitConverter.ToUInt32(md5, 4) | 1;
		uint d0 = c0 + 0x69FB0000;
		uint d1 = c1 + 0x13DB0000;

		// a* - WordSwap state, b* - Reversible state
		uint a1 = 0, a2 = 0, b1 = 0, b2 = 0;

		for (int offset = 0; offset < length * 4; offset += 8)
		{
			uint x0 = BitConverter.ToUInt32(data, offset);
			uint x1 = BitConverter.ToUInt32(data, offset + 4);

			// WordSwap
			uint n  = x0 + a1;
			uint t  = n * d0 - 0x10FA9605 * (n >> 16);
			uint v1 = 0x79F8A395 * t + 0x689B6B9F * (t >> 16);
			uint v2 = 0xEA970001 * v1 - 0x3C101569 * (v1 >> 16);
			uint v3 = x1 + v2;
			uint v4 = v3 * d1 - 0x3CE8EC25 * (v3 >> 16);
			uint v5 = 0x59C3AF2D * v4 - 0x2232E0F1 * (v4 >> 16);
			a1  = 0x1EC90001 * v5 + 0x35BD1EC9 * (v5 >> 16);
			a2 += a1 + v2;

			// Reversible
			n  = (x0 + b1) * c0;
			n  = 0xB1110000 * n - 0x30674EEF * (n >> 16);
			v1 = 0x5B9F0000 * n - 0x78F7A461 * (n >> 16);
			t  = 0x12CEB96D * (v1 >> 16) - 0x46930000 * v1;
			v2 = 0x1D830000 * t + 0x257E1D83 * (t >> 16);
			v3 = c1 * (x1 + v2);
			v4 = 0x16F50000 * v3 - 0x5D8BE90B * (v3 >> 16);
			t  = 0x96FF0000 * v4 - 0x2C7C6901 * (v4 >> 16);
			v5 = 0x2B890000 * t + 0x7C932B89 * (t >> 16);
			b1  = 0x9F690000 * v5 - 0x405B6097 * (v5 >> 16);
			b2 += b1 + v2;
		}

		// Little-endian: low DWORD = o1 xor, high DWORD = o2 xor
		byte[] hash = new byte[8];
		BitConverter.GetBytes(a1 ^ b1).CopyTo(hash, 0);
		BitConverter.GetBytes(a2 ^ b2).CopyTo(hash, 4);

		return Convert.ToBase64String(hash);
	}
}
"@
	}

	if (-not ("WinAPI.PatentHash" -as [type]))
	{
		Add-Type @Signature
	}

	# Get user SID
	$UserSID = (Get-CimInstance -Namespace root/CIMV2 -ClassName Win32_UserAccount | Where-Object -FilterScript {$_.Name -eq $env:USERNAME}).SID

	return [WinAPI.PatentHash]::Get($Extension, $UserSID, $ProgId, $SubKey)
}
