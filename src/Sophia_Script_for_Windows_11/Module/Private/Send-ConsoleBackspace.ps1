<#
	.SYNOPSIS
	Bring the Sophia Script console window to the foreground and emulate the Backspace key sending to prevent the console window to freeze

	.EXAMPLE
	Send-ConsoleBackspace
#>
function Global:Send-ConsoleBackspace
{
	Start-Sleep -Milliseconds 500

	Add-Type -AssemblyName System.Windows.Forms

	# We cannot use Get-Process -Id $PID as script might be invoked via Terminal with different $PID
	Get-Process -Name powershell, WindowsTerminal -ErrorAction Ignore | Where-Object -FilterScript {$_.MainWindowTitle -match "Sophia Script for Windows"} | ForEach-Object -Process {
		# Show window, if minimized
		[void][WinAPI.ForegroundWindow]::ShowWindowAsync($_.MainWindowHandle, 10)

		Start-Sleep -Seconds 1

		# Force move the console window to the foreground
		# Send the key only if the console window has got the focus, otherwise it would be sent to another window
		if ([WinAPI.ForegroundWindow]::SetForegroundWindow($_.MainWindowHandle))
		{
			Start-Sleep -Seconds 1

			# Emulate the Backspace key sending
			[System.Windows.Forms.SendKeys]::SendWait("{BACKSPACE 1}")
		}
	}
}
