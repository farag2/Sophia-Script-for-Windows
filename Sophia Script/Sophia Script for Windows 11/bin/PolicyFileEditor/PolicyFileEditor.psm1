#requires -Version 2.0

$scriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
$dllPath = Join-Path $scriptRoot PolFileEditor.dll

Add-Type -Path $dllPath -ErrorAction Stop

$commandsFile = Join-Path $scriptRoot Commands.ps1

. $commandsFile
