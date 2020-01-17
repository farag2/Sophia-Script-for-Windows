# Turn on latest installed .NET runtime for all apps
# Использовать последнюю установленную версию .NET для всех приложений
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\.NETFramework -Name OnlyUseLatestCLR -PropertyType DWord -Value 1 -Force
New-ItemProperty -Path HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework -Name OnlyUseLatestCLR -PropertyType DWord -Value 1 -Force