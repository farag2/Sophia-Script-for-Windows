# Remove "Previous Versions" from file context menu
# Удалить пункт "Восстановить прежнюю версию" из контекстного меню
IF (-not (Test-Path -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked"))
{
	New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Force
}
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" -Name "{596AB062-B4D2-4215-9F74-E9109B0A8153}" -PropertyType String -Value "" -Force