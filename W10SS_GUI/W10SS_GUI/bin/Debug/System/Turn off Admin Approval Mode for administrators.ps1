# Turn off Admin Approval Mode for administrators
# Отключить использование режима одобрения администратором для встроенной учетной записи администратора
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -PropertyType DWord -Value 0 -Force