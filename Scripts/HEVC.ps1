# https://store.rg-adguard.net
# https://apps.microsoft.com/detail/9N4WGH0Z6VHQ

if (-not (Test-Path -Path HEVC))
{
	New-Item -Path HEVC -ItemType Directory -Force
}

# Bypass Cloudflare protection
try
{
	$Headers = @{
		"User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
	}
	$Parameters = @{
		Uri             = "https://store.rg-adguard.net"
		Headers         = $Headers
		UseBasicParsing = $true
	}
	Invoke-WebRequest @Parameters | Out-Null
}
catch [System.Net.WebException]
{
	Write-Verbose -Message "Connection could not be established with https://store.rg-adguard.net" -Verbose

	exit 1 # Exit with a non-zero status to fail the job
}

try
{
	$Headers = @{
		"User-Agent"       = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
		"Accept"           = "application/json, text/javascript, */*; q=0.01"
		"Content-Type"     = "application/x-www-form-urlencoded; charset=UTF-8"
		"X-Requested-With" = "XMLHttpRequest"
		"Origin"           = "https://store.rg-adguard.net"
		"Referer"          = "https://store.rg-adguard.net"
	}
	$Body = @{
		type = "url"
		url  = "https://apps.microsoft.com/detail/9N4WGH0Z6VHQ"
		ring = "Retail"
		lang = "en-US"
	}
	$Parameters = @{
		Uri             = "https://store.rg-adguard.net/api/GetFiles"
		Method          = "Post"
		ContentType     = "application/x-www-form-urlencoded"
		Body            = $Body
		Headers         = $Headers
		UseBasicParsing = $true
		Verbose         = $true
	}
	$Raw = Invoke-WebRequest @Parameters
}
catch [System.Net.WebException]
{
	Write-Verbose -Message "Connection could not be established with https://store.rg-adguard.net/api/GetFiles" -Verbose

	exit 1 # Exit with a non-zero status to fail the job
}

# Get a temp URL
# Replace &, unless it fails to be parsed
[xml]$TempURL = ($Raw.Links.outerHTML | Where-Object -FilterScript {$_ -match "appxbundle"}).Replace("&", "&amp;") | Select-Object -Last 1
if (-not $TempURL)
{
	Write-Verbose -Message "https://store.rg-adguard.net/api/GetFiles does not output correct URL" -Verbose

	exit 1 # Exit with a non-zero status to fail the job
}

# Get package build version and save to HEVC\HEVC_version.txt
$TempURL.a."#text".Split("_") | Select-Object -Index 1 | Set-Content -Path HEVC\HEVC_version.txt -Encoding utf8 -Force

# Download archive
$Parameters = @{
	Uri             = $TempURL.a.href
	OutFile         = "HEVC\Microsoft.HEVCVideoExtension_8wekyb3d8bbwe.appx"
	Verbose         = $true
	UseBasicParsing = $true
}
Invoke-WebRequest @Parameters
