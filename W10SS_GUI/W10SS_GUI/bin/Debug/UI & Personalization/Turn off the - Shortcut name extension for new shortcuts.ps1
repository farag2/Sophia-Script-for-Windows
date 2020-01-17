# Turn off the "- Shortcut" name extension for new shortcuts
# Нe дoбaвлять "- яpлык" для coздaвaeмыx яpлыкoв
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name link -PropertyType Binary -Value ([byte[]](00, 00, 00, 00)) -Force