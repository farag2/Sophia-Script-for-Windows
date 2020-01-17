# Do not offer tailored experiences based on the diagnostic data setting
# Не предлагать персонализированныее возможности, основанные на выбранном параметре диагностических данных
New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy -Name TailoredExperiencesWithDiagnosticDataEnabled -PropertyType DWord -Value 0 -Force