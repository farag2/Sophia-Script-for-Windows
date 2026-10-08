<#
	.SYNOPSIS
	"Show menu" function with the up/down arrow keys and enter key to make a selection

	.PARAMETER Menu
	Array of items to choose from

	.PARAMETER Default
	Zero-based index of the item selected by default. The hint line and the "Skip" item are appended after the menu items

	.PARAMETER AddSkip
	Add localized extracted "Skip" string from %SystemRoot%\System32\shell32.dll

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
	$Menu += $Localization.KeyboardArrows -f [char]0x2191, [char]0x2193

	if ($AddSkip)
	{
		# Extract localized "Skip" string from %SystemRoot%\System32\shell32.dll
		$Menu += [WinAPI.GetStrings]::GetString(16956)
	}

	# Reserve a line for each menu item
	foreach ($Item in $Menu)
	{
		Write-Host -Object ""
	}

	# The last valid index is $Menu.Count - 1
	$SelectedValueIndex = [Math]::Max([Math]::Min($Default, $Menu.Count - 1), 0)

	while ($true)
	{
		[Console]::SetCursorPosition(0, [Console]::CursorTop - $Menu.Count)

		for ($i = 0; $i -lt $Menu.Count; $i++)
		{
			if ($i -eq $SelectedValueIndex)
			{
				Write-Host -Object "[>] $($Menu[$i])"
			}
			else
			{
				Write-Host -Object "[ ] $($Menu[$i])"
			}
		}

		$Key = [Console]::ReadKey($true)
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
			"Escape"
			{
				if ($AddSkip)
				{
					return $Menu[-1]
				}
			}
		}
	}
}
