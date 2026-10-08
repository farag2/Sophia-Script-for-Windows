# https://www.deviantart.com/team/status-update/An-adjustments-being-made-to-1307747979

# Get access token
# https://www.deviantart.com/developers/authentication
$Body = @{
	grant_type    = "refresh_token"
	client_id     = $env:DEVIANTART_CLIENT_ID
	client_secret = $env:DEVIANTART_CLIENT_SECRET
	refresh_token = $env:DEVIANTART_TOKEN
}
$Parameters = @{
	Uri             = "https://www.deviantart.com/oauth2/token"
	Body            = $Body
	Method          = "Post"
	Verbose         = $true
	UseBasicParsing = $true
}
$Token = Invoke-RestMethod @Parameters

# Hide tokens in the workflow log
Write-Output -InputObject "::add-mask::$($Token.access_token)"
Write-Output -InputObject "::add-mask::$($Token.refresh_token)"

# A new refresh token is issued on every refresh and the previous one stops working, so save the new one for the next run before doing anything else
# GITHUB_TOKEN cannot write secrets, so GH_TOKEN has to be a personal access token with the "Secrets: Read and write" permission
gh secret set DEVIANTART_TOKEN --body $Token.refresh_token --repo $env:GITHUB_REPOSITORY

# Get download URL
# UUID is 8A8DC033-242C-DD2E-EDB0-CC864772D5F4
# https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-886489356
$Headers = @{
	Authorization = "Bearer $($Token.access_token)"
}
$Parameters = @{
	Uri             = "https://www.deviantart.com/api/v1/oauth2/deviation/download/8A8DC033-242C-DD2E-EDB0-CC864772D5F4?mature_content=true"
	Headers         = $Headers
	Verbose         = $true
	UseBasicParsing = $true
}
$Response = Invoke-RestMethod @Parameters

# Download the archive to a temp folder first to not overwrite the valid one in the repo with a broken download
$Parameters = @{
	Uri             = $Response.src
	OutFile         = "$env:RUNNER_TEMP\w11-cursor-concept-free.zip"
	UseBasicParsing = $true
	Verbose         = $true
}
Invoke-WebRequest @Parameters

$Parameters = @{
	Path        = "$env:RUNNER_TEMP\w11-cursor-concept-free.zip"
	Destination = "Cursors\w11-cursor-concept-free.zip"
	Force       = $true
}
Move-Item @Parameters
