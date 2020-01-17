# Turn on automatic backup the system registry to the $env:SystemRoot\System32\config\RegBack folder
# Включить автоматическое создание копии реестра в папку $env:SystemRoot\System32\config\RegBack
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Configuration Manager" -Name EnablePeriodicBackup -PropertyType DWord -Value 1 -Force