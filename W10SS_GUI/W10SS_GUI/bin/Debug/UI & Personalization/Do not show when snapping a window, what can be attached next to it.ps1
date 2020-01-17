# Do not show when snapping a window, what can be attached next to it
# Не показывать при прикреплении окна, что можно прикрепить рядом с ним
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name SnapAssist -PropertyType DWord -Value 0 -Force