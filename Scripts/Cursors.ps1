# https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-886489356
# https://jepricreations.com/products/w11-cursor-concept-free

# We cannot download archive using Deviant Art's API due to limitations as it requires a human interection
# https://www.deviantart.com/team/status-update/An-adjustments-being-made-to-1307747979

Get-Process -Name msedgedriver, msedge -ErrorAction Ignore | Stop-Process -Force -ErrorAction Ignore

Write-Verbose -Message "Microsoft Edge driver" -Verbose

# Get runner Microsoft Edge Version
# https://edgeupdates.microsoft.com/api/products
# https://github.com/GoogleChromeLabs/chrome-for-testing/blob/main/data/last-known-good-versions-with-downloads.json
$RunnerEdgeVersion = (Get-Item -Path "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe").VersionInfo.FileVersion

# Download Microsoft Edge driver
# https://developer.microsoft.com/microsoft-edge/tools/webdriver/
$Parameters = @{
	Uri             = "https://msedgedriver.microsoft.com/$RunnerEdgeVersion/edgedriver_win64.zip"
	OutFile         = "Cursors\edgedriver_win64.zip"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-Webrequest @Parameters

& "$env:SystemRoot\System32\tar.exe" -xvf "Cursors\edgedriver_win64.zip" -C "Cursors" "msedgedriver.exe"

Write-Verbose -Message "Selenium web driver" -Verbose

# Download Selenium web driver
# https://www.nuget.org/packages/selenium.webdriver
# https://www.nuget.org/packages/selenium.support
# https://github.com/SeleniumHQ/selenium
try
{
	$Parameters = @{
		Uri             = "https://www.nuget.org/api/v2/package/Selenium.WebDriver"
		OutFile         = "Cursors\selenium.webdriver.nupkg"
		UseBasicParsing = $true
		Verbose         = $true
		ErrorAction     = "Stop"
	}
	Invoke-WebRequest @Parameters
}
catch
{
	Write-Verbose -Message "Cannot download Selenium web driver" -Verbose

	# Exit with a non-zero status to fail the job
	exit 1
}

& "$env:SystemRoot\System32\tar.exe" -xvf "Cursors\selenium.webdriver.nupkg" -C "Cursors" --strip-components=2 "lib/net8.0/Selenium.WebDriver.dll"

$Paths = @(
	"Cursors\edgedriver_win64.zip",
	"Cursors\selenium.webdriver.nupkg"
)
Remove-Item -Path $Paths -Force -Recurse

Write-Verbose -Message "Adding web driver" -Verbose

# Start parsing page
Add-Type -Path "Cursors\Selenium.WebDriver.dll"

$Options = New-Object -TypeName OpenQA.Selenium.Edge.EdgeOptions
$Options.AddArgument("--headless=new")
$Options.AddArgument("--window-size=1280,720")
$Options.AddArgument("--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0")
$Driver = New-Object -TypeName OpenQA.Selenium.Edge.EdgeDriver("Cursors\msedgedriver.exe", $Options)

$Driver.Navigate().GoToUrl("https://jepricreations.com/products/w11-cursor-concept-free")
# Find "Download for free" button on the page
$Button = [OpenQA.Selenium.By]::XPath("//button[contains(normalize-space(.),'Download for free')] | //a[contains(normalize-space(.),'Download for free')]")
# Downloading w11-cursor-concept-free.zip
$Driver.FindElement($Button).Click()

# Get runner Downloads folder
$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"

# Wait until archive is being downloaded
do
{
	$ZIP = Test-Path -Path "$DownloadsFolder\*.zip"

	if (-not $ZIP)
	{
		Write-Verbose -Message "Waiting for archive to be downloaded..."
		Get-ChildItem -Path $DownloadsFolder -File
		Start-Sleep -Seconds 5
	}
}
while (-not $ZIP)

$Driver.Quit()

# Copy APK to Morphe_Builder folder
$Parameters = @{
	Path        = "$DownloadsFolder\*.zip"
	Destination = "Cursors"
	Force       = $true
}
Copy-Item @Parameters
