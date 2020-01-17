# Turn on Win32 long paths
# Включить длинные пути Win32
New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem -Name LongPathsEnabled -PropertyType DWord -Value 1 -Force