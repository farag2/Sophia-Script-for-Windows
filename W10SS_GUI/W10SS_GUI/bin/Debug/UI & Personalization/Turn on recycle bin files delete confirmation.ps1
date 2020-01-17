# Turn on recycle bin files delete confirmation
# Запрашивать подтверждение на удалении файлов из корзины
IF (-not (Test-Path -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer))
{
	New-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Force
}
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer -Name ConfirmFileDelete -PropertyType DWord -Value 1 -Force