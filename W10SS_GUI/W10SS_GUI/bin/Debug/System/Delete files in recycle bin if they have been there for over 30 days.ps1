# Uninstall OneDrive
# Удалить OneDrive
Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue
Start-Process -FilePath "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" -ArgumentList "/uninstall" -Wait
Stop-Process -Name explorer
Remove-ItemProperty -Path HKCU:\Environment -Name OneDrive -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:ProgramData\Microsoft OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
Unregister-ScheduledTask -TaskName *OneDrive* -Confirm:$false
IF ((Get-ChildItem -Path $env:USERPROFILE\OneDrive -ErrorAction SilentlyContinue | Measure-Object).Count -eq 0)
{
	Remove-Item -Path $env:USERPROFILE\OneDrive -Recurse -Force -ErrorAction SilentlyContinue
}
else
{
	Write-Error "$env:USERPROFILE\OneDrive folder is not empty"
}
Wait-Process -Name OneDriveSetup -ErrorAction SilentlyContinue
Remove-Item -Path $env:LOCALAPPDATA\Microsoft\OneDrive -Recurse -Force -ErrorAction SilentlyContinue
$Error.RemoveAt(0)