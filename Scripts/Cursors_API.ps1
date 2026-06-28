# https://www.deviantart.com/team/status-update/An-adjustments-being-made-to-1307747979

# Start listiner to copy code from URL
$Listener = [System.Net.HttpListener]::new()
# With "/"
$Listener.Prefixes.Add('http://localhost:8080/cb/')
$Listener.Start()

$Bytes = [byte[]]::new(32)
[System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($Bytes)
$codeVerifier  = [Convert]::ToBase64String($Bytes).TrimEnd('=').Replace('+','-').Replace('/','_')
$Hash = [System.Security.Cryptography.SHA256]::Create().ComputeHash([Text.Encoding]::ASCII.GetBytes($CodeVerifier))
$CodeChallenge = [Convert]::ToBase64String($Hash).TrimEnd('=').Replace('+','-').Replace('/','_')
$state = [guid]::NewGuid().ToString('N')
$ClientId    = $env:DEVIANTART_CLIENT_ID
$RedirectURL = [uri]::EscapeDataString("http://localhost:8080/cb")
Start-Process -FilePath "https://www.deviantart.com/oauth2/authorize?response_type=code&client_id=$clientId&redirect_uri=$RedirectURL&scope=browse&state=$State&code_challenge=$CodeChallenge&code_challenge_method=S256"

# Blocks until the browser hits the redirect_uri
$context = $Listener.GetContext()
$request = $context.Request
$code = $request.QueryString['code']
$context.Response.Close()
$Listener.Stop()

# Get access token
# https://deviantart.readme.io/docs/authentication
$Body = @{
	grant_type    = "authorization_code"
	client_id     = $env:DEVIANTART_CLIENT_ID
	client_secret = $env:DEVIANTART_CLIENT_SECRET
	redirect_uri  = "http://localhost:8080/cb"
	code          = $code
	code_verifier = $codeVerifier
}
$Parameters = @{
	Uri             = "https://www.deviantart.com/oauth2/token"
	Body            = $Body
	Method          = "Post"
	Verbose         = $true
	UseBasicParsing = $true
}
$Response = Invoke-RestMethod @Parameters

# Get download URL
# UUID is 8A8DC033-242C-DD2E-EDB0-CC864772D5F4
# https://www.deviantart.com/jepricreations/art/Windows-11-Cursors-Concept-886489356
$Headers = @{
	Authorization = "Bearer $($Response.access_token)"
}
$Parameters = @{
	Uri             = "https://www.deviantart.com/api/v1/oauth2/deviation/download/8A8DC033-242C-DD2E-EDB0-CC864772D5F4?mature_content=true"
	Headers         = $Headers
	Verbose         = $true
	UseBasicParsing = $true
}
$Response = Invoke-RestMethod @Parameters
$Response.src
