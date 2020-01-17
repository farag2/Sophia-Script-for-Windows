# Import Start menu layout from pre-saved .reg file
# Импорт настроенного макета меню "Пуск" из предварительно сохраненного .reg-файла
Add-Type -AssemblyName System.Windows.Forms
$OpenFileDialog = New-Object -TypeName System.Windows.Forms.OpenFileDialog
$OpenFileDialog.Multiselect = $false
$openfiledialog.ShowHelp = $true
# Initial directory "Downloads"
# Начальная папка "Загрузки"
$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
$OpenFileDialog.InitialDirectory = $DownloadsFolder
$OpenFileDialog.Multiselect = $false
$OpenFileDialog.ShowHelp = $false
IF ($RU)
{
	$OpenFileDialog.Filter = "Файлы реестра (*.reg)|*.reg|Все файлы (*.*)|*.*"
}
else
{
	$OpenFileDialog.Filter = "Registration Files (*.reg)|*.reg|All Files (*.*)|*.*"
}
# Focus on open file dialog
# Перевести фокус на диалог открытия файла
$tmp = New-Object -TypeName System.Windows.Forms.Form
$tmp.add_Shown(
{
	$tmp.Visible = $false
	$tmp.Activate()
	$tmp.TopMost = $true
	$OpenFileDialog.ShowDialog($tmp)
	$tmp.Close()
})
$tmp.ShowDialog()
IF ($OpenFileDialog.FileName)
{
	Remove-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount -Recurse -Force
	regedit.exe /s $OpenFileDialog.FileName
}