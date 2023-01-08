# Download cloc
# https://github.com/AlDanial/cloc

$Token = ConvertTo-SecureString '${{ secrets.GITHUB_TOKEN }}' -AsPlainText
$Parameters = @{
	Uri             = "https://api.github.com/repos/AlDanial/cloc/releases/latest"
	Token           = $Token
	Authentication  = "Bearer"
	UseBasicParsing = $true
	Verbose         = $true
}
$Tag = (Invoke-RestMethod @Parameters).tag_name.replace("v", "")

$Parameters = @{
	Uri             = "https://github.com/AlDanial/cloc/releases/download/v$Tag/cloc-$Tag.exe"
	OutFile         = "$PSScriptRoot\cloc.exe"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters
