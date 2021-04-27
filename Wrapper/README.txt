File: README.TXT for 'Sophia Script Wrapper' created by https://benchtweakgaming.com/2020/10/10/windows-10-debloat-tool/
Created for farag2 Windows 10 Sophia Script: https://github.com/farag2/Windows-10-Sophia-Script

INTRODUCTION
------------
Please read this document to understand how to use this program.

BenchTweakGaming.com now works with the farag team.

This program create a PowerShell script file that you can run to tweak/'Debloat' Windows 10 based on farag2 
Windows 10 Sophia Script. It serves as a front-end GUI for the Sophia script (Wrapper).

The options are arranged in different tabs and there is a Default preset in the menu so you can debloat a 
set of options. You can choose the Default preset first and then add your own choices. You can also create your own 
Sophia script to share and open it up. There is also a ‘Opposite’ menu choice to select the alternate radiobutton choices. 
This is good to revert the changes into a script to run. There are ToolTips balloon message popups for detailed info 
for each radiobutton. There is also a square button with each radiobutton for you to go launch a text window and read 
or edit the function in the PowerShell 'Sophia.psm1' file module.

After choosing your options you can directly run the PowerShell script from the program after creating your script. 
Click the ‘Run Powershell’ button after you fill in the radiobutton choices and click the ‘Output PowerShell’ button. 
The “Run PowerShell” button creates a PowerShell script called ‘Sophia.ps1’ in the same directory and runs it.

OR save the PowerShell script as ‘Sophia.ps1’ with the other files (see heading FILES below) and run it using 
the following commands.

Launch PowerShell (Run as administrator) and navigate to where your script is.

1. Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
2. .\Sophia.ps1

FILES
-----
There needs to be 5 files for this program to run properly.

►Sophia Script Wrapper.exe: The GUI program.
►data.txt: Contains the options (function names) to select from (usually only 2 options that something is Enable or Disable or "LeaveAlone").
Notice the sections "#region Xxx" and how a semi colon separate the function commands. The last command option in each
section does not have a semi colon. Add or substract from the set.
►default.txt : Contains Default preset to debloat. Click this preset from Option menu in program.
►tooltip.txt : Contains ToolTips for each radiobutton option. In English.
►README.txt : This documentation.

INSTRUCTIONS
------------
UNZIP the files and open the 'Sophia.ps1' file to import your preset and to get the path for files to run.
If you do not open 'Sophia.ps1' then you can not run directly the PowerShell script you create and must run 
your script manually via PowerShell command line in console.

***********************************************************************************************************
*** For the file 'Sophia.ps1', you should make a copy/backup of it as the wrapper overwrites this file. ***
***********************************************************************************************************

►Sophia.ps1 : Original Windows PowerShell Script. Make a copy of this file for backup.
►Sophia.psd1 : Windows PowerShell Data File
►Sophia.psm1 : Windows PowerShell Script Module
►Functions.ps1 : PS script to run functions with tab autocompletion

The folders are localized language files for prompts during the PowerShell execution each with a PowerShell Data File 'Sophia.psd1'

►cn-CN
►de-DE
►en-US
►es-ES
►fr-FR
►it-IT
►ru-RU
►tr-TR
►uk-UA