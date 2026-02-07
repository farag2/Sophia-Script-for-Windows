# https://store.rg-adguard.net
# https://apps.microsoft.com/detail/9N4WGH0Z6VHQ

if (-not (Test-Path -Path HEVC))
{
	New-Item -Path HEVC -ItemType Directory -Force
}

try
{
	$Body = @{
		type = "url"
		url  = "https://apps.microsoft.com/detail/9N4WGH0Z6VHQ"
		ring = "Retail"
		lang = "en-US"
	}
	$Parameters = @{
		Uri             = "https://ru.store.rg-adguard.net/api/GetFiles"
		Method          = "Post"
		ContentType     = "application/x-www-form-urlencoded"
		Body            = $Body
		UseBasicParsing = $true
		Verbose         = $true
	}
	$Raw = Invoke-WebRequest @Parameters
}
catch [System.Net.WebException]
{
	Write-Verbose -Message "Connection could not be established with https://store.rg-adguard.net" -Verbose

	exit 1  # Exit with a non-zero status to fail the job
}

# Get a temp URL
$TempURL = $Raw.Links.href | Sort-Object -Property Length -Descending | Select-Object -First 1
if (-not $TempURL)
{
	Write-Verbose -Message "https://store.rg-adguard.net does not output correct URL" -Verbose

	exit 1 # Exit with a non-zero status to fail the job
}

# Download archive
$Parameters = @{
	Uri             = $TempURL
	OutFile         = "HEVC\Microsoft.HEVCVideoExtension_8wekyb3d8bbwe.appx"
	Verbose         = $true
	UseBasicParsing = $true
}
Invoke-WebRequest @Parameters
