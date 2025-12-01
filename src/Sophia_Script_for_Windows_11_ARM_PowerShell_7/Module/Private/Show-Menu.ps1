<#
	.SYNOPSIS
	"Show menu" function with the up/down arrow keys and enter key to make a selection

	.PARAMETER Menu
	Array of items to choose from

	.PARAMETER Default
	Default selected item in array

	.PARAMETER AddSkip
	Add localized extracted "Skip" string from shell32.dll

	.EXAMPLE
	Show-Menu -Menu @($Item1, $Item2) -Default 1

	.LINK
	https://qna.habr.com/answer?answer_id=1522379
	https://github.com/ryandunton/InteractivePSMenu
#>
function Global:Show-Menu
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[array]
		$Menu,

		[Parameter(Mandatory = $true)]
		[int]
		$Default,

		[Parameter(Mandatory = $false)]
		[switch]
		$AddSkip
	)

	Write-Information -MessageData "" -InformationAction Continue

	# Add "Please use the arrow keys 🠕 and 🠗 on your keyboard to select your answer" to menu
	$Menu += $Localization.KeyboardArrows -f [System.Char]::ConvertFromUtf32(0x2191), [System.Char]::ConvertFromUtf32(0x2193)

	if ($AddSkip)
	{
		# Extract the localized "Skip" string from shell32.dll
		$Menu += [WinAPI.GetStrings]::GetString(16956)
	}

	$i = 0
	while ($i -lt $Menu.Count)
	{
		$i++
		Write-Host -Object ""
	}

	$SelectedValueIndex = [Math]::Max([Math]::Min($Default, $Menu.Count), 0)

	do
	{
		[Console]::SetCursorPosition(0, [Console]::CursorTop - $Menu.Count)

		for ($i = 0; $i -lt $Menu.Count; $i++)
		{
			if ($i -eq $SelectedValueIndex)
			{
				Write-Host -Object "[>] $($Menu[$i])" -NoNewline
			}
			else
			{
				Write-Host -Object "[ ] $($Menu[$i])" -NoNewline
			}

			Write-Host -Object ""
		}

		$Key = [Console]::ReadKey()
		switch ($Key.Key)
		{
			"UpArrow"
			{
				$SelectedValueIndex = [Math]::Max(0, $SelectedValueIndex - 1)
			}
			"DownArrow"
			{
				$SelectedValueIndex = [Math]::Min($Menu.Count - 1, $SelectedValueIndex + 1)
			}
			"Enter"
			{
				return $Menu[$SelectedValueIndex]
			}
		}
	}
	while ($Key.Key -notin ([ConsoleKey]::Escape, [ConsoleKey]::Enter))
}
