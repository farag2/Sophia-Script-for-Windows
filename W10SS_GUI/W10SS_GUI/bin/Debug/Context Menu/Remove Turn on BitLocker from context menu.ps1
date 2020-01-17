# Remove "Turn on BitLocker" from context menu
# Удалить пункт "Включить BitLocker" из контекстного меню
IF (Get-WindowsEdition -Online | Where-Object -FilterScript {$_.Edition -eq "Professional" -or $_.Edition -eq "Enterprise"})
{
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\encrypt-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\encrypt-bde-elev -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\manage-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\resume-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\resume-bde-elev -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\Drive\shell\unlock-bde -Name ProgrammaticAccessOnly -PropertyType String -Value "" -Force
}