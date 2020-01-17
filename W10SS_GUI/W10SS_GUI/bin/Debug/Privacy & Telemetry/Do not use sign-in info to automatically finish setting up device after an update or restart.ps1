# Do not use sign-in info to automatically finish setting up device after an update or restart
# Не использовать данные для входа для автоматического завершения настройки устройства после перезапуска или обновления
$sid = (Get-CimInstance -ClassName Win32_UserAccount | Where-Object -FilterScript {$_.Name -eq "$env:USERNAME"}).SID
IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$sid"))
{
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$sid" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\UserARSO\$sid" -Name OptOut -PropertyType DWord -Value 1 -Force