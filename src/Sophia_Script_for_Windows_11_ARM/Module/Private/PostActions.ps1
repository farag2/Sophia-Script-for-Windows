<#
	.SYNOPSIS
	Post actions

	.VERSION
	7.3.0

	.DATE
	05.09.2026

	.COPYRIGHT
	(c) 2014—2026 Team Sophia

	.LINK
	https://github.com/farag2/Sophia-Script-for-Windows
#>
function PostActions
{
	# Simulate pressing F5 to refresh the desktop
	[WinAPI.UpdateEnvironment]::PostMessage()

	# Refresh desktop icons, environment variables, taskbar
	[WinAPI.UpdateEnvironment]::Refresh()

	# Restart Start menu
	Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction Ignore

	# Kill all explorer instances in case "launch folder windows in a separate process" enabled
	Get-Process -Name explorer | Stop-Process -Force
	Start-Sleep -Seconds 3

	# Restoring closed folders
	if (Get-Variable -Name OpenedFolder -ErrorAction Ignore)
	{
		foreach ($Global:OpenedFolder in $Global:OpenedFolders)
		{
			if (Test-Path -Path $Global:OpenedFolder)
			{
				Start-Process -FilePath "$env:SystemRoot\explorer.exe" -ArgumentList $Global:OpenedFolder
			}
		}
	}

	# Check whether any of scheduled tasks were created
	if ($Global:ScheduledTasks)
	{
		# Find and close taskschd.msc by its argument
		$taskschd_Process_ID = (Get-CimInstance -ClassName CIM_Process | Where-Object -FilterScript {($_.Name -eq "mmc.exe") -and ($_.CommandLine -match "taskschd.msc")}).Handle
		if ($taskschd_Process_ID)
		{
			Get-Process -Id $taskschd_Process_ID | Stop-Process -Force
		}

		# Open Task Scheduler
		Start-Process -FilePath taskschd.msc

		Get-ScheduledTask -TaskName SoftwareDistribution, Temp, "Windows Cleanup Notification" -ErrorAction Ignore | Start-ScheduledTask

		$Global:ScheduledTasks = $false
	}

	# Check whether Event Viewer custom view was created
	if ($Global:EventViewerCustomView)
	{
		# Find and close eventvwr.msc by its argument
		$eventvwr_Process_ID = (Get-CimInstance -ClassName CIM_Process | Where-Object -FilterScript {($_.Name -eq "mmc.exe") -and ($_.CommandLine -match "eventvwr.msc")}).Handle
		if ($eventvwr_Process_ID)
		{
			Get-Process -Id $eventvwr_Process_ID | Stop-Process -Force
		}

		# Open Event Viewer
		Start-Process -FilePath eventvwr.msc

		$Global:EventViewerCustomView = $false
	}

	#region Toast notifications
	# Enable notifications
	Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications -Name ToastEnabled -Force -ErrorAction Ignore
	Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.ActionCenter.SmartOptOut -Name Enable -Force -ErrorAction Ignore
	Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Sophia -Name ShowBanner, ShowInActionCenter, Enabled -Force -ErrorAction Ignore
	Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\SystemSettings\AccountNotifications -Name EnableAccountNotifications -Force -ErrorAction Ignore
	Remove-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\Explorer, HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer -Name DisableNotificationCenter -Force -ErrorAction Ignore
	Remove-ItemProperty -Path HKCU:\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications -Name NoToastApplicationNotification -Force -ErrorAction Ignore
	Remove-Policy -Scope Computer -Path SOFTWARE\Policies\Microsoft\Windows\Explorer -Name DisableNotificationCenter
	Remove-Policy -Scope User -Path Software\Policies\Microsoft\Windows\Explorer -Name DisableNotificationCenter

	if (-not (Test-Path -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia))
	{
		New-Item -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia -Force
	}
	# Register app
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia -Name DisplayName -Value Sophia -PropertyType String -Force
	# Determines whether the app can be seen in Settings where the user can turn notifications on or off
	New-ItemProperty -Path Registry::HKEY_CLASSES_ROOT\AppUserModelId\Sophia -Name ShowInSettings -Value 0 -PropertyType DWord -Force

	# Import policies back from LGPO.txt to re-build database database because gpedit.msc relies in its own database
	if (Test-Path -Path "$env:TEMP\LGPO.txt")
	{
		# Check if all policies were removed
		if (Get-Content -Path "$env:TEMP\LGPO.txt" | Where-Object -FilterScript {$_ -ne ""})
		{
			# Find and close taskschd.msc by its argument
			$gpedit_Process_ID = (Get-CimInstance -ClassName CIM_Process | Where-Object -FilterScript {($_.Name -eq "mmc.exe") -and ($_.CommandLine -match "gpedit.msc")}).Handle
			if ($gpedit_Process_ID)
			{
				Get-Process -Id $gpedit_Process_ID | Stop-Process -Force
			}

			# Recreate Registry.pol from scratch, because LGPO.exe /t only adds and changes values
			Remove-Item -Path "$env:SystemRoot\System32\GroupPolicy\Machine\Registry.pol", "$env:SystemRoot\System32\GroupPolicy\User\Registry.pol" -Force -ErrorAction Ignore

			& "$PSScriptRoot\..\Binaries\LGPO.exe" /t "$env:TEMP\LGPO.txt"
		}

		# PowerShell 5.1 (7.5 too) interprets 8.3 file name literally, if an environment variable contains a non-Latin word
		# https://github.com/PowerShell/PowerShell/issues/21070
		Get-Item -Path "$env:TEMP\LGPO.txt" -Force | Remove-Item -Force
	}

	# Call toast notification
	[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
	[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

	[xml]$ToastTemplate = @"
<toast duration="Long" scenario="reminder">
	<visual>
		<binding template="ToastGeneric">
			<text>$($Localization.DonateToastTitle)</text>
		</binding>
	</visual>
	<audio src="ms-winsoundevent:notification.default" />
	<actions>
		<action content="Ko-fi" arguments="https://ko-fi.com/farag" activationType="protocol"/>
	</actions>
</toast>
"@

	$ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::New()
	$ToastXml.LoadXml($ToastTemplate.OuterXml)

	$ToastMessage = [Windows.UI.Notifications.ToastNotification]::New($ToastXML)
	[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Sophia").Show($ToastMessage)
	#endregion Toast notifications

	Write-Information -MessageData "" -InformationAction Continue
	Write-Verbose -Message $Localization.AskQuestion -Verbose
	Write-Verbose -Message "https://github.com/farag2/Sophia-Script-for-Windows/issues" -Verbose
	Write-Verbose -Message "https://t.me/sophia_chat" -Verbose
	Write-Verbose -Message "https://t.me/sophianews" -Verbose
	Write-Verbose -Message "https://discord.gg/sSryhaEv79" -Verbose

	Write-Information -MessageData "" -InformationAction Continue
	Write-Verbose -Message $Localization.DonateToastTitle -Verbose
	Write-Verbose -Message "https://ko-fi.com/farag" -Verbose

	Write-Information -MessageData "" -InformationAction Continue
	Write-Warning -Message $Localization.RestartWarning

	Write-Information -MessageData "" -InformationAction Continue
	# Get how much restore points on C drive take up in GB
	$Volume = Get-CimInstance -ClassName Win32_Volume | Where-Object -FilterScript {$_.DriveLetter -eq "C:"}
	$RestorePointVolume = [math]::Round((Get-CimInstance -ClassName Win32_ShadowStorage | Where-Object -FilterScript {$_.Volume.DeviceID -eq $Volume.DeviceID}).UsedSpace/1GB, 2)
	if ($RestorePointVolume -ge 1)
	{
		Write-Warning -Message ($Localization.RestorePointVolume -f $RestorePointVolume)
		Write-Information -MessageData "" -InformationAction Continue

		# Open System Protection settings
		& "$env:SystemRoot\System32\SystemPropertiesProtection.exe"
	}

	if ($Global:Error)
	{
		($Global:Error | ForEach-Object -Process {
			# Some errors may have the Windows nature and don't have a path to any of the module's files
			$ErrorInFile = if ($_.InvocationInfo.PSCommandPath)
			{
				Split-Path -Path $_.InvocationInfo.PSCommandPath -Leaf
			}

			[PSCustomObject]@{
				$Localization.ErrorsLine                  = $_.InvocationInfo.ScriptLineNumber
				# Extract localized "File" string from %SystemRoot%\System32\shell32.dll
				"$([WinAPI.GetStrings]::GetString(4130))" = $ErrorInFile
				$Localization.ErrorsMessage               = $_.Exception.Message
			}
		} | Sort-Object -Property $Localization.ErrorsLine | Format-Table -AutoSize -Wrap | Out-String).Trim()
	}
}
