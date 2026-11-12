<#
	.SYNOPSIS
	Bring the Sophia Script console window to the foreground and emulate sending the Backspace key to prevent the console window from freezing

	.EXAMPLE
	Send-ConsoleBackspace
#>
function Global:Send-ConsoleBackspace
{
	Start-Sleep -Milliseconds 500

	Add-Type -AssemblyName System.Windows.Forms

	# We cannot use Get-Process -Id $PID as script might be invoked via Terminal with different $PID
	Get-Process -Name powershell, WindowsTerminal -ErrorAction Ignore | Where-Object -FilterScript {$_.MainWindowTitle -match "Sophia Script for Windows"} | ForEach-Object -Process {
		# Restore the window only if it is minimized
		# SW_SHOWDEFAULT (10) would also reset a maximized or resized window to its default size
		if ([WinAPI.ForegroundWindow]::IsIconic($_.MainWindowHandle))
		{
			# SW_RESTORE
			[void][WinAPI.ForegroundWindow]::ShowWindowAsync($_.MainWindowHandle, 9)

			Start-Sleep -Seconds 1
		}

		# Force move the console window to the foreground
		# Send the key only if the console window has got the focus, otherwise it would be sent to another window
		if ([WinAPI.ForegroundWindow]::SetForegroundWindow($_.MainWindowHandle))
		{
			Start-Sleep -Seconds 1

			# Emulate sending the Backspace key
			[System.Windows.Forms.SendKeys]::SendWait("{BACKSPACE 1}")
		}
	}
}
