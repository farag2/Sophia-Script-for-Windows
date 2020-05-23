@echo off
chcp 65001 >nul

powershell.exe -ExecutionPolicy RemoteSigned -NoExit -NoProfile -NoLogo -File "%~dp0Win 10.ps1"