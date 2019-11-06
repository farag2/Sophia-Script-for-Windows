Cls
$currentDir = $MyInvocation.MyCommand.Definition | Split-Path -Parent
$rusTextPath = "{0}\Ru"-f $currentDir
Get-ChildItem -Path $rusTextPath | %{
	$file = $_
	$file.BaseName
	[string]$s = $null
	Get-Content -Path $file.FullName -Encoding UTF8 | %{
		$s = $s + """{0}"", "-f $_	
	}
	$s
	
	Write-Host "------------------------------------------------"
}