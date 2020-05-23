@echo off
chcp 65001 >nul

powershell.exe -ExecutionPolicy ByPass -Scope Process -NoExit -NoProfile -NoLogo -File "%~dp0Win 10.ps1"
