@ECHO OFF
chcp 65001 >nul

:: Add this file to the same directory as the Powershell file to be executed
:: and name the * .cmd like the powershell file.
:: When executing the * .cmd, all ExecutionPolicy are bypassed.

:: The powershell window remains open after the execution,
:: if this is not desired simply remove the -NoExit argument

if exist "%~dpn0.ps1" goto begin
for /F "tokens=3 delims= " %%G in ('reg query "hklm\system\controlset001\control\nls\language" /v InstallLanguage') DO set "lang=%%G"
echo.
echo ===================================================================================
echo =                                                                                 =
if [%lang%] EQU [0419] (echo =  В том же каталоге нет файла Powershell со следующими именами!                  =
) else if [%lang%] EQU [0407] (echo =  Es gibt keine Powershell Datei mit folgenden Namen im selben Verzeichnis!      =
) else (echo =  There is no Powershell file with the following name in the same directory!     =)
echo =  %~dpn0.ps1
echo =                                                                                 =
echo ===================================================================================
echo.
pause
goto:eof

:begin
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoExit -NoLogo -NoProfile -ExecutionPolicy Bypass -File ""%~dpn0.ps1""' -Verb RunAs}";