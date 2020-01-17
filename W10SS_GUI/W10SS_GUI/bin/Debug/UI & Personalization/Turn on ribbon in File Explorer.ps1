# Turn on ribbon in File Explorer
# Включить отображение ленты проводника в развернутом виде
IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Name MinimizedStateTabletModeOff -PropertyType DWord -Value 0 -Force