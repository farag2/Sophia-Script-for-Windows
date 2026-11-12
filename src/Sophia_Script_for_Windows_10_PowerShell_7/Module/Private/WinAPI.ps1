<#
	.SYNOPSIS
	Compile WinAPI types used by the module and private functions

	.EXAMPLE
	Import-WinAPI

	.VERSION
	7.1.0

	.DATE
	31.10.2026

	.COPYRIGHT
	(c) 2014—2026 Team Sophia

	.LINK
	https://github.com/farag2/Sophia-Script-for-Windows
#>
function Import-WinAPI
{
	$Signature = @{
		Language           = "CSharp"
		TypeDefinition     = @"
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;

namespace WinAPI
{
	// Extract localized strings from %SystemRoot%\System32\shell32.dll
	public class GetStrings
	{
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
		[DllImport("shlwapi.dll", CharSet = CharSet.Unicode)]
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
	}

	// Move window to foreground
	public class ForegroundWindow
	{
		[DllImport("user32.dll")]
		public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

		[DllImport("user32.dll")]
		[return: MarshalAs(UnmanagedType.Bool)]
		public static extern bool SetForegroundWindow(IntPtr hWnd);

		// Check whether the window is minimized
		[DllImport("user32.dll")]
		[return: MarshalAs(UnmanagedType.Bool)]
		public static extern bool IsIconic(IntPtr hWnd);
	}

	// Get the real Windows version like %SystemRoot%\system32\winver.exe relies on
	public class Winbrand
	{
		[DllImport("Winbrand.dll", CharSet = CharSet.Unicode)]
		public extern static string BrandingFormatString(string sFormat);
	}

	// Reload cursor on-the-fly for Install-Cursors function
	public class Cursor
	{
		[DllImport("user32.dll", EntryPoint = "SystemParametersInfo", SetLastError = true)]
		public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, IntPtr pvParam, uint fWinIni);
	}

	// Simulate pressing F5 to refresh Desktop and refresh desktop icons, environment variables, taskbar
	public class UpdateEnvironment
	{
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

		[DllImport("user32.dll", SetLastError = true)]
		public static extern int PostMessageW(IntPtr hWnd, uint Msg, UIntPtr wParam, IntPtr lParam);

		public static void PostMessage()
		{
			// Simulate pressing F5 to refresh the desktop
			PostMessageW(hWnd, Msg, UIntPtr, IntPtr.Zero);
		}
	}

	// Read and write Registry.pol of the local Group Policy object. It replaces LGPO.exe
	// Registry.pol: the "PReg" signature, version 1, then [key;value;type;size;data] records
	// Brackets and semicolons are UTF-16LE characters. Key and value name are UTF-16LE strings with a null terminator
	// Type and size are 32-bit integers. Size is the data length in bytes
	// https://learn.microsoft.com/previous-versions/windows/desktop/policy/registry-policy-file-format
	// https://aaron-margosis.medium.com/corrections-to-microsoft-documentation-about-the-registry-policy-file-format-f6cb0caa9a80
	public class RegistryPolicy
	{
		public class Entry
		{
			// Registry key path without the root key. HKLM or HKCU is defined by the folder: Machine or User
			public string Key;
			// Value name. Names that start with ** are instructions: **del.name, **delvals., **DeleteValues, **DeleteKeys, **soft.name, **Comment:
			public string ValueName;
			// Registry value type from winnt.h: REG_SZ = 1, REG_EXPAND_SZ = 2, REG_DWORD = 4
			public uint Type;
			// Raw value data
			public byte[] Data;
		}

		// "PReg" and version 1
		private static readonly byte[] Header = new byte[] { 0x50, 0x52, 0x65, 0x67, 0x01, 0x00, 0x00, 0x00 };

		// Registry client-side extension, and Administrative Templates snap-ins for computer and for user
		private const string RegistryExtension = "{35378EAC-683F-11D2-A89A-00C04FBBCFA2}";
		private const string MachineSnapIn = "{D02B1F72-3407-48AE-BA88-E8213C6761F1}";
		private const string UserSnapIn = "{D02B1F73-3407-48AE-BA88-E8213C6761F1}";

		// Read all records. They are kept as is, including instructions and comments, so nothing is lost when the file is written back
		// A missing or an empty file gives an empty list
		public static List<Entry> Read(string path)
		{
			List<Entry> entries = new List<Entry>();

			if (!File.Exists(path))
			{
				return entries;
			}

			byte[] bytes = File.ReadAllBytes(path);

			if (bytes.Length == 0)
			{
				return entries;
			}

			if (bytes.Length < Header.Length)
			{
				throw new FormatException(path + " is not a registry policy file");
			}

			for (int i = 0; i < Header.Length; i++)
			{
				if (bytes[i] != Header[i])
				{
					throw new FormatException(path + " is not a registry policy file");
				}
			}

			int position = Header.Length;

			while (position < bytes.Length)
			{
				Entry entry = new Entry();

				ReadChar(bytes, ref position, '[', path);
				entry.Key = ReadString(bytes, ref position, path);
				ReadChar(bytes, ref position, ';', path);
				entry.ValueName = ReadString(bytes, ref position, path);
				ReadChar(bytes, ref position, ';', path);
				entry.Type = ReadUInt32(bytes, ref position, path);
				ReadChar(bytes, ref position, ';', path);
				uint size = ReadUInt32(bytes, ref position, path);
				ReadChar(bytes, ref position, ';', path);

				if (size > (uint)(bytes.Length - position))
				{
					throw new FormatException(path + " is corrupted at offset " + position);
				}

				entry.Data = new byte[size];
				Buffer.BlockCopy(bytes, position, entry.Data, 0, (int)size);
				position += (int)size;

				ReadChar(bytes, ref position, ']', path);

				entries.Add(entry);
			}

			return entries;
		}

		// Recreate the file from the list, so it has the records from the list only. An empty list removes the file
		// Return true if the file was changed, so the caller knows whether gpt.ini must be updated
		public static bool Write(string path, List<Entry> entries)
		{
			if (entries.Count == 0)
			{
				if (!File.Exists(path))
				{
					return false;
				}

				// Removing a file without records changes nothing for Group Policy, so it is not reported as a change
				bool hadRecords = new FileInfo(path).Length > Header.Length;

				// A read-only file can't be removed
				File.SetAttributes(path, FileAttributes.Normal);
				File.Delete(path);

				return hadRecords;
			}

			byte[] bytes = GetBytes(entries);

			if (File.Exists(path) && SameBytes(File.ReadAllBytes(path), bytes))
			{
				return false;
			}

			Directory.CreateDirectory(Path.GetDirectoryName(path));

			// Write to a temporary file first, so Registry.pol is never left half-written
			string temporaryPath = path + ".tmp";
			File.WriteAllBytes(temporaryPath, bytes);

			if (File.Exists(path))
			{
				File.SetAttributes(path, FileAttributes.Normal);
				File.Delete(path);
			}

			File.Move(temporaryPath, path);

			return true;
		}

		// Add or change a value. Types are the same as in Add-Policy: DWORD, SZ, EXSZ
		public static void Set(List<Entry> entries, string key, string valueName, string type, string value)
		{
			string name = valueName ?? "";
			uint entryType;
			byte[] data;

			switch (type.ToUpperInvariant())
			{
				case "DWORD":
				{
					// Accept both 4294967295 and -1 for 0xFFFFFFFF
					long number = Int64.Parse(value, NumberStyles.Integer, CultureInfo.InvariantCulture);
					entryType = 4;
					data = BitConverter.GetBytes(unchecked((uint)number));
					break;
				}
				case "SZ":
				{
					// String data has a null terminator
					entryType = 1;
					data = Encoding.Unicode.GetBytes((value ?? "") + "\0");
					break;
				}
				case "EXSZ":
				{
					entryType = 2;
					data = Encoding.Unicode.GetBytes((value ?? "") + "\0");
					break;
				}
				default:
				{
					throw new ArgumentException("Unsupported registry value type: " + type);
				}
			}

			// The value is set, so the instruction to delete it must go
			for (int i = entries.Count - 1; i >= 0; i--)
			{
				if (Matches(entries[i], key, "**del." + name))
				{
					entries.RemoveAt(i);
				}
			}

			int index = -1;
			for (int i = 0; i < entries.Count; i++)
			{
				if (Matches(entries[i], key, name))
				{
					index = i;
					break;
				}
			}

			if (index < 0)
			{
				Entry entry = new Entry();
				entry.Key = key.Trim('\\');
				entry.ValueName = name;
				entry.Type = entryType;
				entry.Data = data;
				entries.Add(entry);

				return;
			}

			// Change the existing record in place: the same policies always give the same file, so nothing is rewritten for no reason
			entries[index].Type = entryType;
			entries[index].Data = data;

			// Remove duplicates of the record
			for (int i = entries.Count - 1; i > index; i--)
			{
				if (Matches(entries[i], key, name))
				{
					entries.RemoveAt(i);
				}
			}
		}

		// Remove a value and the instruction to delete it. Other records of the key stay
		public static void Remove(List<Entry> entries, string key, string valueName)
		{
			string name = valueName ?? "";

			for (int i = entries.Count - 1; i >= 0; i--)
			{
				if (Matches(entries[i], key, name) || Matches(entries[i], key, "**del." + name))
				{
					entries.RemoveAt(i);
				}
			}
		}

		// Increase the version in gpt.ini, so Group Policy processes Registry.pol again, and register the Administrative Templates extension
		// LGPO.exe /t did it by itself. Only the side that was changed is updated
		public static void UpdateGptIni(string path, bool machine, bool user)
		{
			List<string> lines = new List<string>();

			if (File.Exists(path))
			{
				lines.AddRange(File.ReadAllLines(path, Encoding.Default));
			}

			bool hasGeneral = false;
			foreach (string line in lines)
			{
				if (string.Equals(line.Trim(), "[General]", StringComparison.OrdinalIgnoreCase))
				{
					hasGeneral = true;
				}
			}

			if (!hasGeneral)
			{
				lines.Insert(0, "[General]");
			}

			uint version;
			if (!UInt32.TryParse(GetIniValue(lines, "Version"), NumberStyles.Integer, CultureInfo.InvariantCulture, out version))
			{
				version = 0;
			}

			// The low word is the computer version, the high word is the user version
			uint machineVersion = version & 0xFFFF;
			uint userVersion = version >> 16;

			if (machine)
			{
				machineVersion = (machineVersion >= 0xFFFF) ? 1 : machineVersion + 1;
				SetIniValue(lines, "gPCMachineExtensionNames", AddExtension(GetIniValue(lines, "gPCMachineExtensionNames"), MachineSnapIn));
			}

			if (user)
			{
				userVersion = (userVersion >= 0xFFFF) ? 1 : userVersion + 1;
				SetIniValue(lines, "gPCUserExtensionNames", AddExtension(GetIniValue(lines, "gPCUserExtensionNames"), UserSnapIn));
			}

			SetIniValue(lines, "Version", ((userVersion << 16) | machineVersion).ToString(CultureInfo.InvariantCulture));

			Directory.CreateDirectory(Path.GetDirectoryName(path));

			// A hidden or read-only file can't be overwritten, so drop its attributes and set them back after
			FileAttributes attributes = FileAttributes.Normal;
			if (File.Exists(path))
			{
				attributes = File.GetAttributes(path);
				File.SetAttributes(path, FileAttributes.Normal);
			}

			File.WriteAllLines(path, lines.ToArray(), Encoding.Default);
			File.SetAttributes(path, attributes);
		}

		// Key and value names are not case-sensitive in the registry
		private static bool Matches(Entry entry, string key, string valueName)
		{
			return string.Equals((entry.Key ?? "").Trim('\\'), key.Trim('\\'), StringComparison.OrdinalIgnoreCase) &&
				string.Equals(entry.ValueName ?? "", valueName, StringComparison.OrdinalIgnoreCase);
		}

		private static byte[] GetBytes(List<Entry> entries)
		{
			using (MemoryStream stream = new MemoryStream())
			{
				stream.Write(Header, 0, Header.Length);

				foreach (Entry entry in entries)
				{
					byte[] data = entry.Data ?? new byte[0];

					// Key and value name are followed by a null terminator before the semicolon
					WriteText(stream, "[" + (entry.Key ?? "") + "\0;" + (entry.ValueName ?? "") + "\0;");
					WriteUInt32(stream, entry.Type);
					WriteText(stream, ";");
					WriteUInt32(stream, (uint)data.Length);
					WriteText(stream, ";");
					stream.Write(data, 0, data.Length);
					WriteText(stream, "]");
				}

				return stream.ToArray();
			}
		}

		private static bool SameBytes(byte[] first, byte[] second)
		{
			if (first.Length != second.Length)
			{
				return false;
			}

			for (int i = 0; i < first.Length; i++)
			{
				if (first[i] != second[i])
				{
					return false;
				}
			}

			return true;
		}

		private static void ReadChar(byte[] bytes, ref int position, char expected, string path)
		{
			if ((position + 2 > bytes.Length) || (BitConverter.ToChar(bytes, position) != expected))
			{
				throw new FormatException(path + " is corrupted at offset " + position);
			}

			position += 2;
		}

		// Read a UTF-16LE string and skip its null terminator
		private static string ReadString(byte[] bytes, ref int position, string path)
		{
			StringBuilder builder = new StringBuilder();

			while (true)
			{
				if (position + 2 > bytes.Length)
				{
					throw new FormatException(path + " is corrupted at offset " + position);
				}

				char character = BitConverter.ToChar(bytes, position);
				position += 2;

				if (character == '\0')
				{
					return builder.ToString();
				}

				builder.Append(character);
			}
		}

		private static uint ReadUInt32(byte[] bytes, ref int position, string path)
		{
			if (position + 4 > bytes.Length)
			{
				throw new FormatException(path + " is corrupted at offset " + position);
			}

			uint value = BitConverter.ToUInt32(bytes, position);
			position += 4;

			return value;
		}

		// Write characters as UTF-16LE code units one by one, so any string is written back exactly as it was read
		private static void WriteText(MemoryStream stream, string text)
		{
			foreach (char character in text)
			{
				stream.WriteByte((byte)(character & 0xFF));
				stream.WriteByte((byte)(character >> 8));
			}
		}

		private static void WriteUInt32(MemoryStream stream, uint value)
		{
			byte[] bytes = BitConverter.GetBytes(value);
			stream.Write(bytes, 0, bytes.Length);
		}

		private static int FindIniLine(List<string> lines, string name)
		{
			for (int i = 0; i < lines.Count; i++)
			{
				int separator = lines[i].IndexOf('=');

				if ((separator > 0) && string.Equals(lines[i].Substring(0, separator).Trim(), name, StringComparison.OrdinalIgnoreCase))
				{
					return i;
				}
			}

			return -1;
		}

		private static string GetIniValue(List<string> lines, string name)
		{
			int index = FindIniLine(lines, name);

			if (index < 0)
			{
				return null;
			}

			return lines[index].Substring(lines[index].IndexOf('=') + 1).Trim();
		}

		private static void SetIniValue(List<string> lines, string name, string value)
		{
			int index = FindIniLine(lines, name);

			if (index >= 0)
			{
				lines[index] = name + "=" + value;

				return;
			}

			// A new line goes right after the [General] section header
			for (int i = 0; i < lines.Count; i++)
			{
				if (string.Equals(lines[i].Trim(), "[General]", StringComparison.OrdinalIgnoreCase))
				{
					lines.Insert(i + 1, name + "=" + value);

					return;
				}
			}
		}

		// The value is a list of groups: [{client-side extension}{snap-in}{snap-in}][{client-side extension}{snap-in}]
		// Groups are sorted by the extension GUID, and snap-ins are sorted inside a group
		private static string AddExtension(string value, string snapIn)
		{
			List<List<string>> groups = new List<List<string>>();

			foreach (string groupText in (value ?? "").Split(new char[] { '[', ']' }, StringSplitOptions.RemoveEmptyEntries))
			{
				List<string> guids = new List<string>();

				foreach (string guid in groupText.Split(new char[] { '{', '}' }, StringSplitOptions.RemoveEmptyEntries))
				{
					if (guid.Trim().Length > 0)
					{
						guids.Add("{" + guid.Trim() + "}");
					}
				}

				if (guids.Count > 0)
				{
					groups.Add(guids);
				}
			}

			List<string> registryGroup = null;
			foreach (List<string> guids in groups)
			{
				if (string.Equals(guids[0], RegistryExtension, StringComparison.OrdinalIgnoreCase))
				{
					registryGroup = guids;
				}
			}

			if (registryGroup == null)
			{
				registryGroup = new List<string>();
				registryGroup.Add(RegistryExtension);
				groups.Add(registryGroup);
			}

			bool hasSnapIn = false;
			foreach (string guid in registryGroup)
			{
				if (string.Equals(guid, snapIn, StringComparison.OrdinalIgnoreCase))
				{
					hasSnapIn = true;
				}
			}

			if (!hasSnapIn)
			{
				registryGroup.Add(snapIn);
			}

			StringBuilder builder = new StringBuilder();

			groups.Sort(delegate (List<string> first, List<string> second)
			{
				return string.Compare(first[0], second[0], StringComparison.OrdinalIgnoreCase);
			});

			foreach (List<string> guids in groups)
			{
				// The first GUID is the extension itself, so it stays first
				guids.Sort(1, guids.Count - 1, StringComparer.OrdinalIgnoreCase);

				builder.Append("[");
				foreach (string guid in guids)
				{
					builder.Append(guid);
				}
				builder.Append("]");
			}

			return builder.ToString();
		}
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
}
