# Run once locally to sign in to DeviantArt in a browser and get a refresh token for CI/CD
# https://www.deviantart.com/studio/apps

$ClientID     = ""
$ClientSecret = ""

$Bytes = [byte[]]::new(32)
[System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($Bytes)
$CodeVerifier  = [Convert]::ToBase64String($Bytes).TrimEnd("=").Replace("+", "-").Replace("/", "_")
$Hash          = [System.Security.Cryptography.SHA256]::Create().ComputeHash([Text.Encoding]::ASCII.GetBytes($CodeVerifier))
$CodeChallenge = [Convert]::ToBase64String($Hash).TrimEnd("=").Replace("+", "-").Replace("/", "_")
$State         = [guid]::NewGuid().ToString("N")
$RedirectURL   = [uri]::EscapeDataString("http://localhost:8080/cb")

# Start listener to get code from redirect URL
$Listener = [System.Net.HttpListener]::new()
# With "/"
$Listener.Prefixes.Add("http://localhost:8080/cb/")

try
{
	$Listener.Start()

	Start-Process -FilePath "https://www.deviantart.com/oauth2/authorize?response_type=code&client_id=$ClientID&redirect_uri=$RedirectURL&scope=browse&state=$State&code_challenge=$CodeChallenge&code_challenge_method=S256"

	# Blocks until the browser hits the redirect_uri
	$Context       = $Listener.GetContext()
	$Code          = $Context.Request.QueryString["code"]
	$ReturnedState = $Context.Request.QueryString["state"]

	$Buffer = [Text.Encoding]::UTF8.GetBytes("Done. You can close this tab.")
	$Context.Response.OutputStream.Write($Buffer, 0, $Buffer.Length)
	$Context.Response.Close()
}
finally
{
	# Release http://localhost:8080/cb/ even if the script failed or was interrupted
	$Listener.Close()
}

$Body = @{
	grant_type    = "authorization_code"
	client_id     = $ClientID
	client_secret = $ClientSecret
	redirect_uri  = "http://localhost:8080/cb"
	code          = $Code
	code_verifier = $CodeVerifier
}
$Parameters = @{
	Uri             = "https://www.deviantart.com/oauth2/token"
	Body            = $Body
	Method          = "Post"
	Verbose         = $true
	UseBasicParsing = $true
}
$Token = Invoke-RestMethod @Parameters

$Token.refresh_token

Set-Clipboard -Value $Token.refresh_token
Start-Process -FilePath "https://github.com/farag2/Sophia-Script-for-Windows/settings/secrets/actions/DEVIANTART_TOKEN"
