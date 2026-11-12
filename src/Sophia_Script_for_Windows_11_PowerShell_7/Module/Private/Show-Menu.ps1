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

	# Add "Please use the arrow keys ↑ and ↓ on your keyboard to select your answer" to menu
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

	# Drop keys that were pressed before the menu appeared, e.g. while the previous function was running
	# Otherwise ReadKey replays them one by one, and the selection jumps between items by itself
	while ([Console]::KeyAvailable)
	{
		[void][Console]::ReadKey($true)
	}

	# Hide the cursor while the menu is redrawn, and show it back after
	$CursorVisible = [Console]::CursorVisible
	[Console]::CursorVisible = $false

	try
	{
		while ($true)
		{
			[Console]::SetCursorPosition(0, [Console]::CursorTop - $Menu.Count)

			$Lines = for ($i = 0; $i -lt $Menu.Count; $i++)
			{
				if ($i -eq $SelectedValueIndex)
				{
					"[>] $($Menu[$i])"
				}
				else
				{
					"[ ] $($Menu[$i])"
				}
			}

			# One call instead of a call for each item, so the menu is redrawn faster than a held key repeats
			Write-Host -Object ($Lines -join [System.Environment]::NewLine)

			# Read the pressed key and all keys that are already waiting, then redraw the menu once
			# Otherwise a held arrow key leaves a queue of redraws, and the selection keeps moving after the key is released
			do
			{
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
			while ([Console]::KeyAvailable)
		}
	}
	finally
	{
		[Console]::CursorVisible = $CursorVisible
	}
}
