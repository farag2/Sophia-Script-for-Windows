# https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-886489356
# https://www.deviantart.com/developers/authentication
# https://www.deviantart.com/studio/apps

# Get access token
$Body = @{
	grant_type    = "client_credentials"
	client_id     = $env:DEVIANTART_CLIENT_ID
	client_secret = $env:DEVIANTART_CLIENT_SECRET
}
$Parameters = @{
	Uri             = "https://www.deviantart.com/oauth2/token"
	Body            = $Body
	Verbose         = $true
	UseBasicParsing = $true
}
$Response = Invoke-RestMethod @Parameters

# Get download URL
$Body = @{
	access_token = $Response.access_token
}
$Parameters = @{
	# UUID is 8A8DC033-242C-DD2E-EDB0-CC864772D5F4
	Uri             = "https://www.deviantart.com/api/v1/oauth2/deviation/download/8A8DC033-242C-DD2E-EDB0-CC864772D5F4"
	Body            = $Body
	Verbose         = $true
	UseBasicParsing = $true
}
$Response = Invoke-RestMethod @Parameters

# Download archive
$Parameters = @{
	Uri             = $Response.src
	OutFile         = "Cursors\Windows11Cursors.zip"
	Verbose         = $true
	UseBasicParsing = $true
}
Invoke-WebRequest @Parameters
