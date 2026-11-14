Write-Verbose -Message Dependencies -Verbose

New-Item -Path "Sophia_Script" -ItemType Directory -Force

# Download Microsoft.Windows.SDK.NET.dll & WinRT.Runtime.dll
# https://www.nuget.org/packages/Microsoft.Windows.SDK.NET.Ref
$Parameters = @{
	Uri             = "https://www.nuget.org/api/v2/package/Microsoft.Windows.SDK.NET.Ref"
	OutFile         = "Sophia_Script\microsoft.windows.sdk.net.ref.zip"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

# Extract Microsoft.Windows.SDK.NET.dll & WinRT.Runtime.dll only
& "$env:SystemRoot\System32\tar.exe" -xvf "Sophia_Script\microsoft.windows.sdk.net.ref.zip" -C "Sophia_Script" --strip-components 2 "lib/net9.0/WinRT.Runtime.dll" "lib/net9.0/Microsoft.Windows.SDK.NET.dll"

Remove-Item -Path "Sophia_Script\microsoft.windows.sdk.net.ref.zip" -Force
