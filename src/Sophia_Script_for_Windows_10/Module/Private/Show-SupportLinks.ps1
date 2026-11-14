<#
	.SYNOPSIS
	Show the links where to ask a question: GitHub issues, Telegram chat and channel, and Discord

	.EXAMPLE
	Show-SupportLinks
#>
function Global:Show-SupportLinks
{
	Write-Verbose -Message $Localization.AskQuestion -Verbose
	Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
	Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
	Write-Verbose -Message "https://t.me/sophianews" -Verbose
	Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose
}