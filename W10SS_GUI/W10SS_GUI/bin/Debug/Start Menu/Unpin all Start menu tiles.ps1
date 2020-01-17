# Unpin all Start menu tiles
# Открепить все ярлыки от начального экрана
$tilecollection = Get-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*start.tilegrid`$windows.data.curatedtilecollection.tilecollection\Current
$unpin = $tilecollection.Data[0..25] + ([byte[]](202,50,0,226,44,1,1,0,0))
New-ItemProperty -Path $tilecollection.PSPath -Name Data -PropertyType Binary -Value $unpin -Force