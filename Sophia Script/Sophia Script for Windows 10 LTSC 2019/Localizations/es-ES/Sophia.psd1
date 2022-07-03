ConvertFrom-StringData -StringData @'
UnsupportedOSBitness                      = El script sólo es compatible con Windows 10 x64
UnsupportedOSBuild                        = El script es compatible con versión Windows 10 Enterprise LTSC 2019
UnsupportedLanguageMode                   = Sesión de PowerShell ejecutada en modo de lenguaje limitado
LoggedInUserNotAdmin                      = El usuario que inició sesión no tiene derechos de administrador
UnsupportedPowerShell                     = Estás intentando ejecutar el script a través de PowerShell {0}.{1}. Ejecute el script en la versión apropiada de PowerShell
UnsupportedISE                            = El script no es compatible con la ejecución a través de Windows PowerShell ISE
Win10TweakerWarning                       = Probablemente su sistema operativo fue infectado a través del backdoor Win 10 Tweaker
Windows10DebloaterWarning                 = La estabilidad del sistema operativo Windows puede haberse visto comprometida al utilizar el script PowerShell Windows10Debloater de Sycnex. De forma preventiva, reinstale todo el sistema operativo
bin                                       = No hay archivos en la carpeta bin. Por favor, vuelva a descargar el archivo
RebootPending                             = El PC está esperando a ser reiniciado
UnsupportedRelease                        = Una nueva versión encontrada
CustomizationWarning                      = \n¿Ha personalizado todas las funciones del archivo predeterminado {0} antes de ejecutar Sophia Script?
ControlledFolderAccessDisabled            = Acceso a la carpeta controlada deshabilitado
ScheduledTasks                            = Tareas programadas
WindowsFeaturesTitle                      = Características de Windows
OptionalFeaturesTitle                     = Características opcionales
EnableHardwareVT                          = Habilitar la virtualización en UEFI
UserShellFolderNotEmpty                   = Algunos archivos quedan en la carpeta "{0}". Moverlos manualmente a una nueva ubicación
RetrievingDrivesList                      = Recuperando lista de unidades...
DriveSelect                               = Seleccione la unidad dentro de la raíz de la cual se creó la carpeta "{0}"
CurrentUserFolderLocation                 = La ubicación actual de la carpeta "{0}": "{1}"
UserFolderRequest                         = ¿Le gustaría cambiar la ubicación de la "{0}" carpeta?
UserFolderSelect                          = Seleccione una carpeta para la carpeta "{0}"
UserDefaultFolder                         = ¿Le gustaría cambiar la ubicación de la carpeta "{0}" para el valor por defecto?
GraphicsPerformanceTitle                  = Preferencia de rendimiento gráfico
GraphicsPerformanceRequest                = ¿Le gustaría establecer la configuración de rendimiento gráfico de una aplicación de su elección a "alto rendimiento"?
TaskNotificationTitle                     = Notificación
CleanupTaskNotificationTitle              = Información importante
CleanupTaskDescription                    = La limpieza de Windows los archivos no utilizados y actualizaciones utilizando una función de aplicación de limpieza de discos
CleanupTaskNotificationEventTitle         = ¿Ejecutar la tarea de limpiar los archivos no utilizados y actualizaciones de Windows?
CleanupTaskNotificationEvent              = Ventanas de limpieza no tomará mucho tiempo. La próxima vez que esta notificación aparecerá en 30 días
CleanupTaskNotificationSnoozeInterval     = Seleccionar un recordatorio del intervalo
CleanupNotificationTaskDescription        = Pop-up recordatorio de notificaciones sobre la limpieza de archivos no utilizados de Windows y actualizaciones
SoftwareDistributionTaskNotificationEvent = La caché de actualización de Windows eliminado correctamente
TempTaskNotificationEvent                 = Los archivos de la carpeta Temp limpiados con éxito
FolderTaskDescription                     = La limpieza de la carpeta "{0}"
EventViewerCustomViewName                 = Creación de proceso
EventViewerCustomViewDescription          = Eventos de auditoría de línea de comandos y creación de procesos
RestartWarning                            = Asegúrese de reiniciar su PC
ErrorsLine                                = Línea
ErrorsFile                                = Archivo
ErrorsMessage                             = Errores/Advertencias
Add                                       = Agregar
AllFilesFilter                            = Todos los archivos (*.*)|*.*
Browse                                    = Examinar
DialogBoxOpening                          = Viendo el cuadro de diálogo...
Disable                                   = Desactivar
Enable                                    = Habilitar
EXEFilesFilter                            = *.exe|*.exe|Todos los Archivos (*.*)|*.*
FolderSelect                              = Seleccione una carpeta
FilesWontBeMoved                          = Los archivos no se transferirán
FourHours                                 = 4 horas
HalfHour                                  = 30 minutos
Install                                   = Instalar
Minute                                    = 1 minuto
NoData                                    = Nada que mostrar
NoInternetConnection                      = No hay conexión a Internet
RestartFunction                           = Por favor, reinicie la función "{0}"
NoResponse                                = No se pudo establecer una conexión con {0}
No                                        = No
Yes                                       = Sí
Open                                      = Abierta
Patient                                   = Por favor espere...
Restore                                   = Restaurar
Run                                       = Iniciar
SelectAll                                 = Seleccionar todo
Skipped                                   = Omitido
FileExplorerRestartPrompt                 = \nA veces, para que los cambios surtan efecto, hay que reiniciar el proceso del Explorador de archivos
TelegramGroupTitle                        = Únete a nuestro grupo oficial de Telegram
TelegramChannelTitle                      = Únete a nuestro canal oficial de Telegram
Uninstall                                 = Desinstalar
'@

# SIG # Begin signature block
# MIIbvwYJKoZIhvcNAQcCoIIbsDCCG6wCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUWdT3oqF87eWX9WgpqBuEPn/r
# PxigghY3MIIDAjCCAeqgAwIBAgIQTAKXY9arCY5B5sFCEY9uhTANBgkqhkiG9w0B
# AQsFADAZMRcwFQYDVQQDDA5Tb3BoaWEgUHJvamVjdDAeFw0yMjA3MDMxODEzMzha
# Fw0yNDA3MDMxODIzMzhaMBkxFzAVBgNVBAMMDlNvcGhpYSBQcm9qZWN0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAr4TTInWlmoGtza2HunTKTaqQy2Yx
# 9LIXKqdOe+DMMuE09ApzK6IZh2iuX+37R0DuvmBo/cjnAJDIWJmCQKQ+kUYRpzF0
# 3WUOWURe/kw+VlxTq0L+V1U58tKQNHdnDLEeVlfT7Ix1imGS2JARyQM3wVr/aHKl
# Ll9fv34Gp1SJqQXFbqCfONjRU2vjFHHgved/Mlw+Mw0Q48WCnvMY5egSN+34Q70l
# +2Jtgmf6iR8aTj1Z8JgP0xsrsIbtacP2ewvVP5U6K4fCEfy+rMt4VGD3KghJLSvH
# q0tHjzeHa3AumZTvWzmNglx0OKk4wn2q6SODVNXVwl3HegcH9ngxWwSQsQIDAQAB
# o0YwRDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0O
# BBYEFAQ5j+ZXlCTmPOT9dejE0leAZRO+MA0GCSqGSIb3DQEBCwUAA4IBAQB7XklM
# bEs+Q3rwzE43GB97a5I6jZafKTc+6kk7vgd1AsNyipeLU+t/6klRtaoVgN/+eBSl
# cEuPM7InwzJXT+xlaDQ83x+4QAoojb4Er4yh/R/kRNnKrPXPpw0SgqAa7eZ+Yw1z
# z3K/8TTt9h7igEJajs1/3S3BqrwUQ3LWLoM3DQ1fFDxFSvum5dwSeVU6KUPJXdLS
# ZZSeyKflVTxwi/mUxnU3eUouxnubTayCV6adwaig/W1aHrbkpJwX7s7juhp4kmSO
# e6QDJe/d0y75QBZq5F35gskUqTkiXc11KAhxpgG1LrRQAa+DmseWsS/ZdsiRqX9w
# +U7avAaGnv/YN0p4MIIFsTCCBJmgAwIBAgIQASQK+x44C4oW8UtxnfTTwDANBgkq
# hkiG9w0BAQwFADBlMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5j
# MRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBB
# c3N1cmVkIElEIFJvb3QgQ0EwHhcNMjIwNjA5MDAwMDAwWhcNMzExMTA5MjM1OTU5
# WjBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQL
# ExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVkIFJv
# b3QgRzQwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC/5pBzaN675F1K
# PDAiMGkz7MKnJS7JIT3yithZwuEppz1Yq3aaza57G4QNxDAf8xukOBbrVsaXbR2r
# snnyyhHS5F/WBTxSD1Ifxp4VpX6+n6lXFllVcq9ok3DCsrp1mWpzMpTREEQQLt+C
# 8weE5nQ7bXHiLQwb7iDVySAdYyktzuxeTsiT+CFhmzTrBcZe7FsavOvJz82sNEBf
# sXpm7nfISKhmV1efVFiODCu3T6cw2Vbuyntd463JT17lNecxy9qTXtyOj4DatpGY
# QJB5w3jHtrHEtWoYOAMQjdjUN6QuBX2I9YI+EJFwq1WCQTLX2wRzKm6RAXwhTNS8
# rhsDdV14Ztk6MUSaM0C/CNdaSaTC5qmgZ92kJ7yhTzm1EVgX9yRcRo9k98FpiHaY
# dj1ZXUJ2h4mXaXpI8OCiEhtmmnTK3kse5w5jrubU75KSOp493ADkRSWJtppEGSt+
# wJS00mFt6zPZxd9LBADMfRyVw4/3IbKyEbe7f/LVjHAsQWCqsWMYRJUadmJ+9oCw
# ++hkpjPRiQfhvbfmQ6QYuKZ3AeEPlAwhHbJUKSWJbOUOUlFHdL4mrLZBdd56rF+N
# P8m800ERElvlEFDrMcXKchYiCd98THU/Y+whX8QgUWtvsauGi0/C1kVfnSD8oR7F
# wI+isX4KJpn15GkvmB0t9dmpsh3lGwIDAQABo4IBXjCCAVowDwYDVR0TAQH/BAUw
# AwEB/zAdBgNVHQ4EFgQU7NfjgtJxXWRM3y5nP+e6mK4cD08wHwYDVR0jBBgwFoAU
# Reuir/SSy4IxLVGLp6chnfNtyA8wDgYDVR0PAQH/BAQDAgGGMBMGA1UdJQQMMAoG
# CCsGAQUFBwMIMHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29j
# c3AuZGlnaWNlcnQuY29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdp
# Y2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MEUGA1UdHwQ+MDww
# OqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJ
# RFJvb3RDQS5jcmwwIAYDVR0gBBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0G
# CSqGSIb3DQEBDAUAA4IBAQCaFgKlAe+B+w20WLJ4ragjGdlzN9pgnlHXy/gvQLmj
# H3xATjM+kDzniQF1hehiex1W4HG63l7GN7x5XGIATfhJelFNBjLzxdIAKicg6oku
# FTngLD74dXwsgkFhNQ8j0O01ldKIlSlDy+CmWBB8U46fRckgNxTA7Rm6fnc50lSW
# x6YR3zQz9nVSQkscnY2W1ZVsRxIUJF8mQfoaRr3esOWRRwOsGAjLy9tmiX8rnGW/
# vjdOvi3znUrDzMxHXsiVla3Ry7sqBiD5P3LqNutFcpJ6KXsUAzz7TdZIcXoQEYoI
# dM1sGwRc0oqVA3ZRUFPWLvdKRsOuECxxTLCHtic3RGBEMIIGrjCCBJagAwIBAgIQ
# BzY3tyRUfNhHrP0oZipeWzANBgkqhkiG9w0BAQsFADBiMQswCQYDVQQGEwJVUzEV
# MBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29t
# MSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQwHhcNMjIwMzIzMDAw
# MDAwWhcNMzcwMzIyMjM1OTU5WjBjMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGln
# aUNlcnQsIEluYy4xOzA5BgNVBAMTMkRpZ2lDZXJ0IFRydXN0ZWQgRzQgUlNBNDA5
# NiBTSEEyNTYgVGltZVN0YW1waW5nIENBMIICIjANBgkqhkiG9w0BAQEFAAOCAg8A
# MIICCgKCAgEAxoY1BkmzwT1ySVFVxyUDxPKRN6mXUaHW0oPRnkyibaCwzIP5WvYR
# oUQVQl+kiPNo+n3znIkLf50fng8zH1ATCyZzlm34V6gCff1DtITaEfFzsbPuK4CE
# iiIY3+vaPcQXf6sZKz5C3GeO6lE98NZW1OcoLevTsbV15x8GZY2UKdPZ7Gnf2ZCH
# RgB720RBidx8ald68Dd5n12sy+iEZLRS8nZH92GDGd1ftFQLIWhuNyG7QKxfst5K
# fc71ORJn7w6lY2zkpsUdzTYNXNXmG6jBZHRAp8ByxbpOH7G1WE15/tePc5OsLDni
# pUjW8LAxE6lXKZYnLvWHpo9OdhVVJnCYJn+gGkcgQ+NDY4B7dW4nJZCYOjgRs/b2
# nuY7W+yB3iIU2YIqx5K/oN7jPqJz+ucfWmyU8lKVEStYdEAoq3NDzt9KoRxrOMUp
# 88qqlnNCaJ+2RrOdOqPVA+C/8KI8ykLcGEh/FDTP0kyr75s9/g64ZCr6dSgkQe1C
# vwWcZklSUPRR8zZJTYsg0ixXNXkrqPNFYLwjjVj33GHek/45wPmyMKVM1+mYSlg+
# 0wOI/rOP015LdhJRk8mMDDtbiiKowSYI+RQQEgN9XyO7ZONj4KbhPvbCdLI/Hgl2
# 7KtdRnXiYKNYCQEoAA6EVO7O6V3IXjASvUaetdN2udIOa5kM0jO0zbECAwEAAaOC
# AV0wggFZMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFLoW2W1NhS9zKXaa
# L3WMaiCPnshvMB8GA1UdIwQYMBaAFOzX44LScV1kTN8uZz/nupiuHA9PMA4GA1Ud
# DwEB/wQEAwIBhjATBgNVHSUEDDAKBggrBgEFBQcDCDB3BggrBgEFBQcBAQRrMGkw
# JAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBBBggrBgEFBQcw
# AoY1aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJv
# b3RHNC5jcnQwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2NybDMuZGlnaWNlcnQu
# Y29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RHNC5jcmwwIAYDVR0gBBkwFzAIBgZngQwB
# BAIwCwYJYIZIAYb9bAcBMA0GCSqGSIb3DQEBCwUAA4ICAQB9WY7Ak7ZvmKlEIgF+
# ZtbYIULhsBguEE0TzzBTzr8Y+8dQXeJLKftwig2qKWn8acHPHQfpPmDI2AvlXFvX
# bYf6hCAlNDFnzbYSlm/EUExiHQwIgqgWvalWzxVzjQEiJc6VaT9Hd/tydBTX/6tP
# iix6q4XNQ1/tYLaqT5Fmniye4Iqs5f2MvGQmh2ySvZ180HAKfO+ovHVPulr3qRCy
# Xen/KFSJ8NWKcXZl2szwcqMj+sAngkSumScbqyQeJsG33irr9p6xeZmBo1aGqwpF
# yd/EjaDnmPv7pp1yr8THwcFqcdnGE4AJxLafzYeHJLtPo0m5d2aR8XKc6UsCUqc3
# fpNTrDsdCEkPlM05et3/JWOZJyw9P2un8WbDQc1PtkCbISFA0LcTJM3cHXg65J6t
# 5TRxktcma+Q4c6umAU+9Pzt4rUyt+8SVe+0KXzM5h0F4ejjpnOHdI/0dKNPH+ejx
# mF/7K9h+8kaddSweJywm228Vex4Ziza4k9Tm8heZWcpw8De/mADfIBZPJ/tgZxah
# ZrrdVcA6KYawmKAr7ZVBtzrVFZgxtGIJDwq9gdkT/r+k0fNX2bwE+oLeMt8EifAA
# zV3C+dAjfwAL5HYCJtnwZXZCpimHCUcr5n8apIUP/JiW9lVUKx+A+sDyDivl1vup
# L0QVSucTDh3bNzgaoSv27dZ8/DCCBsYwggSuoAMCAQICEAp6SoieyZlCkAZjOE2G
# l50wDQYJKoZIhvcNAQELBQAwYzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lD
# ZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYg
# U0hBMjU2IFRpbWVTdGFtcGluZyBDQTAeFw0yMjAzMjkwMDAwMDBaFw0zMzAzMTQy
# MzU5NTlaMEwxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjEk
# MCIGA1UEAxMbRGlnaUNlcnQgVGltZXN0YW1wIDIwMjIgLSAyMIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAuSqWI6ZcvF/WSfAVghj0M+7MXGzj4CUu0jHk
# PECu+6vE43hdflw26vUljUOjges4Y/k8iGnePNIwUQ0xB7pGbumjS0joiUF/DbLW
# +YTxmD4LvwqEEnFsoWImAdPOw2z9rDt+3Cocqb0wxhbY2rzrsvGD0Z/NCcW5QWpF
# QiNBWvhg02UsPn5evZan8Pyx9PQoz0J5HzvHkwdoaOVENFJfD1De1FksRHTAMkcZ
# W+KYLo/Qyj//xmfPPJOVToTpdhiYmREUxSsMoDPbTSSF6IKU4S8D7n+FAsmG4dUY
# FLcERfPgOL2ivXpxmOwV5/0u7NKbAIqsHY07gGj+0FmYJs7g7a5/KC7CnuALS8gI
# 0TK7g/ojPNn/0oy790Mj3+fDWgVifnAs5SuyPWPqyK6BIGtDich+X7Aa3Rm9n3RB
# Cq+5jgnTdKEvsFR2wZBPlOyGYf/bES+SAzDOMLeLD11Es0MdI1DNkdcvnfv8zbHB
# p8QOxO9APhk6AtQxqWmgSfl14ZvoaORqDI/r5LEhe4ZnWH5/H+gr5BSyFtaBocra
# MJBr7m91wLA2JrIIO/+9vn9sExjfxm2keUmti39hhwVo99Rw40KV6J67m0uy4rZB
# Peevpxooya1hsKBBGBlO7UebYZXtPgthWuo+epiSUc0/yUTngIspQnL3ebLdhOon
# 7v59emsCAwEAAaOCAYswggGHMA4GA1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAA
# MBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMCAGA1UdIAQZMBcwCAYGZ4EMAQQCMAsG
# CWCGSAGG/WwHATAfBgNVHSMEGDAWgBS6FtltTYUvcyl2mi91jGogj57IbzAdBgNV
# HQ4EFgQUjWS3iSH+VlhEhGGn6m8cNo/drw0wWgYDVR0fBFMwUTBPoE2gS4ZJaHR0
# cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0UlNBNDA5NlNI
# QTI1NlRpbWVTdGFtcGluZ0NBLmNybDCBkAYIKwYBBQUHAQEEgYMwgYAwJAYIKwYB
# BQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBYBggrBgEFBQcwAoZMaHR0
# cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZEc0UlNBNDA5
# NlNIQTI1NlRpbWVTdGFtcGluZ0NBLmNydDANBgkqhkiG9w0BAQsFAAOCAgEADS0j
# dKbR9fjqS5k/AeT2DOSvFp3Zs4yXgimcQ28BLas4tXARv4QZiz9d5YZPvpM63io5
# WjlO2IRZpbwbmKrobO/RSGkZOFvPiTkdcHDZTt8jImzV3/ZZy6HC6kx2yqHcoSuW
# uJtVqRprfdH1AglPgtalc4jEmIDf7kmVt7PMxafuDuHvHjiKn+8RyTFKWLbfOHzL
# +lz35FO/bgp8ftfemNUpZYkPopzAZfQBImXH6l50pls1klB89Bemh2RPPkaJFmMg
# a8vye9A140pwSKm25x1gvQQiFSVwBnKpRDtpRxHT7unHoD5PELkwNuTzqmkJqIt+
# ZKJllBH7bjLx9bs4rc3AkxHVMnhKSzcqTPNc3LaFwLtwMFV41pj+VG1/calIGnjd
# RncuG3rAM4r4SiiMEqhzzy350yPynhngDZQooOvbGlGglYKOKGukzp123qlzqkhq
# WUOuX+r4DwZCnd8GaJb+KqB0W2Nm3mssuHiqTXBt8CzxBxV+NbTmtQyimaXXFWs1
# DoXW4CzM4AwkuHxSCx6ZfO/IyMWMWGmvqz3hz8x9Fa4Uv4px38qXsdhH6hyF4EVO
# EhwUKVjMb9N/y77BDkpvIJyu2XMyWQjnLZKhGhH+MpimXSuX4IvTnMxttQ2uR2M4
# RxdbbxPaahBuH0m3RFu0CAqHWlkEdhGhp3cCExwxggTyMIIE7gIBATAtMBkxFzAV
# BgNVBAMMDlNvcGhpYSBQcm9qZWN0AhBMApdj1qsJjkHmwUIRj26FMAkGBSsOAwIa
# BQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgor
# BgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3
# DQEJBDEWBBRE0JVVdxeGuOWPjV6Ov2ZBVOPnqzANBgkqhkiG9w0BAQEFAASCAQAn
# R25+CDLj2PctsWuJsrhd7dERwtJYcVWJ9EZtELCIfIdrlmphEjwAn70WtT7i8djI
# v7DVkDBjFNRvoWTldfBxkPzv+VlBSOkCPUSlgRrKpzN7rFyZVlo2tSdSZ9Qq65kT
# qGyTmR0/x4q4aOTL18/HyVVdPCD9ZpnvNMVtmzobEDus7L2LAPf5ji7DnJLBNi/X
# J4i50oiYHAW7zEvlnIgOS7Brw4FTQ3AW2FSWsDP3tkVRdVVp7FN7P/eBAqJ9uO6l
# aN0wKS3MWYXc/QIvsPnX7odn8DG2a9sX2FRecBJ3+mw6A2hiq502EwRVI7YEgMfJ
# oABdQ1ZssJsS8mVgiR9IoYIDIDCCAxwGCSqGSIb3DQEJBjGCAw0wggMJAgEBMHcw
# YzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQD
# EzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGlu
# ZyBDQQIQCnpKiJ7JmUKQBmM4TYaXnTANBglghkgBZQMEAgEFAKBpMBgGCSqGSIb3
# DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDcwMzE4MjMzN1ow
# LwYJKoZIhvcNAQkEMSIEIDw5YU66bG/RDwBOC+aSbanMe+rghhfXLuAzYQ0kvm2y
# MA0GCSqGSIb3DQEBAQUABIICAJstIrSzq48XgeCDxwSwmS0JZD2zqP6uU4vFmsGj
# dFRwUDQ1uQ95Zt5R3EYdiOpVRlwa+5ENp+n+EwATexGkGje/e50qZQ1ChGEgSAxG
# uBKQYWlNVxbQqHv75qd954T4qM38BT3GiRW9ADxx6AHSjcfprSSVgYJYv6FMnMLa
# XhmSESoY6TGdtkHPn977ZZB1e1vl32kDS4aHpfvgBWH3t8HjoWo9flTmiJo6cVBe
# yu4/exaFtXKrtkwJFtah5xqc5PgpNgk7gk2g6BONerURIOr8T98Ilai3bvXBpaqw
# ICpq7DeLC0+Eqo0BDdZ1DnMTF/IsWJi03C5jL1BeeS0z47BK64/mPFpPvQ6JaEpp
# 4/HN5Z8yM/mKmoeFGBmzx0ZfTRYTGjIUG5/uOBVp8dgG4igM5SdBC2gtV4rCwake
# KOCPK5RAKCBkzrjdGa5w9curZ8QwQda2Ar/QUXuRPIAK3jm+nX+6PQEzUnVtRvBt
# S1vbx7geGBtmBYXHYKnBswBqxulZvHfbbIGgp1a7jZV7MGPkEyINSr3KfNKyBr+A
# QzBqbRtbJlQoVnToJNSiD7jNJq1qNiGyxbQ8Td1M39lRS1Y6g4XbyOXprmIs/c8O
# KoHwxobpm3QEB1FiToO0nZ0kdf7+cTZn+B8b7KirpNSNikPJxvJ+1R5pxN5/VrXL
# pkzy
# SIG # End signature block
