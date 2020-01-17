# Set the operating system diagnostic data level to "Basic"
# Установить уровень отправляемых диагностических сведений на "Базовый"
New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection -Name AllowTelemetry -PropertyType DWord -Value 1 -Force