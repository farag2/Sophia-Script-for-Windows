# Change $env:TEMP environment variable path to $env:SystemDrive\Temp
# Изменить путь переменной среды для временных файлов на $env:SystemDrive\Temp
IF (-not (Test-Path -Path $env:SystemDrive\Temp))
{
	New-Item -Path $env:SystemDrive\Temp -ItemType Directory -Force
}
[Environment]::SetEnvironmentVariable("TMP", "$env:SystemDrive\Temp", "User")
New-ItemProperty -Path HKCU:\Environment -Name TMP -PropertyType ExpandString -Value %SystemDrive%\Temp -Force
[Environment]::SetEnvironmentVariable("TEMP", "$env:SystemDrive\Temp", "User")
New-ItemProperty -Path HKCU:\Environment -Name TEMP -PropertyType ExpandString -Value %SystemDrive%\Temp -Force
[Environment]::SetEnvironmentVariable("TMP", "$env:SystemDrive\Temp", "Machine")
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name TMP -PropertyType ExpandString -Value %SystemDrive%\Temp -Force
[Environment]::SetEnvironmentVariable("TEMP", "$env:SystemDrive\Temp", "Machine")
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name TEMP -PropertyType ExpandString -Value %SystemDrive%\Temp -Force
[Environment]::SetEnvironmentVariable("TMP", "$env:SystemDrive\Temp", "Process")
[Environment]::SetEnvironmentVariable("TEMP", "$env:SystemDrive\Temp", "Process")
Remove-Item $env:LOCALAPPDATA\Temp -Recurse -Force -ErrorAction SilentlyContinue
Restart-Service -Name Spooler -Force
Remove-Item -Path $env:SystemRoot\Temp -Recurse -Force -ErrorAction SilentlyContinue