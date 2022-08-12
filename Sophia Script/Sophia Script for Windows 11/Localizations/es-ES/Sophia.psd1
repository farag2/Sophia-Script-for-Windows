ConvertFrom-StringData -StringData @'
UnsupportedOSBuild                        = El script es compatible con versión Windows 11 21H2 y superiores
UpdateWarning                             = Su build de Windows 11: {0}.{1}. Compilaciones compatibles: 22000.739, 22509 y superiores
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
DefenderBroken                            = \nMicrosoft Defender defekt oder aus dem Betriebssystem entfernt
ControlledFolderAccessDisabled            = Acceso a la carpeta controlada deshabilitado
ScheduledTasks                            = Tareas programadas
OneDriveUninstalling                      = Desinstalar OneDrive...
OneDriveInstalling                        = Instalación de OneDrive...
OneDriveDownloading                       = Descargando OneDrive... ~33 MB
OneDriveWarning                           = La función "{0}" se aplicará sólo si el preajuste está configurado para eliminar OneDrive (o la aplicación ya fue eliminada), de lo contrario la funcionalidad de copia de seguridad para las carpetas "Escritorio" e "Imágenes" en OneDrive se rompe
WindowsFeaturesTitle                      = Características de Windows
OptionalFeaturesTitle                     = Características opcionales
EnableHardwareVT                          = Habilitar la virtualización en UEFI
OpenInWindowsTerminalAdmin                = Abrir en el terminal de Windows
UserShellFolderNotEmpty                   = Algunos archivos quedan en la carpeta "{0}". Moverlos manualmente a una nueva ubicación
RetrievingDrivesList                      = Recuperando lista de unidades...
DriveSelect                               = Seleccione la unidad dentro de la raíz de la cual se creó la carpeta "{0}"
CurrentUserFolderLocation                 = La ubicación actual de la carpeta "{0}": "{1}"
UserFolderRequest                         = ¿Le gustaría cambiar la ubicación de la "{0}" carpeta?
UserFolderSelect                          = Seleccione una carpeta para la carpeta "{0}"
UserDefaultFolder                         = ¿Le gustaría cambiar la ubicación de la carpeta "{0}" para el valor por defecto?
ReservedStorageIsInUse                    = Esta operación no es compatible cuando el almacenamiento reservada está en uso\nPor favor, vuelva a ejecutar la función "{0}" después de reiniciar el PC
ShortcutPinning                           = El acceso directo "{0}" está siendo clavado en Start...
SSDRequired                               = Para utilizar Windows Subsystem for Android™ en su dispositivo, su PC debe tener instalada una unidad de estado sólido (SSD)
UninstallUWPForAll                        = Para todos los usuarios
UWPAppsTitle                              = Aplicaciones UWP
HEVCDownloading                           = Descargando HEVC Vídeo Extensiones del Fabricante del dispositivo... ~2,8 MB
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
# MIIbmwYJKoZIhvcNAQcCoIIbjDCCG4gCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUnM4VlvMfTaZLoj2cZUp9crBm
# /rOgghYTMIIDAjCCAeqgAwIBAgIQTi4881vPeZpMOBarbc4BIjANBgkqhkiG9w0B
# AQsFADAZMRcwFQYDVQQDDA5Tb3BoaWEgUHJvamVjdDAeFw0yMjA4MTIxODU5NTJa
# Fw0yNDA4MTIxOTA5NTNaMBkxFzAVBgNVBAMMDlNvcGhpYSBQcm9qZWN0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuoX0mQe9LtGb04hBzYBwIcIzWInz
# bWUnwEut02rPmZMKEbAab3l71s+dMstqFIb4R68kIKVvI6B0evG/r3ptzZRlshf+
# wc2i3FLNkandkrVhG8Dr9Su6xEeONMkFLwt9Ubob5KVh9Y0UnGhJJnQnBEWqqo4b
# 4wHaVRO5nJtVRPI0pRHqfSwXovmcuHhf4P/2aV2GR2YWyO8aAUs8Ktfat7Cebiu1
# iYwrob9ZZzKMN7r3kd2WiXpMxxr/KBYwHJP2M9TBb7ce3dJofffqo0eoRtu+AICM
# eoprAiHz8HzYdej7yT2/wF+qMNHq0xthF7YKmulC1dubxMMCisQ13EihVQIDAQAB
# o0YwRDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0O
# BBYEFHwRFeDU2hgDQAQEC8oRBaS+IBUxMA0GCSqGSIb3DQEBCwUAA4IBAQBZYQhx
# 99tegt8LTt4fW4alMRExbNzRUdEaVYgkzaGJgW4OQ/zLEuDp5mEmfEgpzxBwQiqo
# 6Taoca8P7x4d45VpAGy0KoLynd+kd/0wyboCqxCyvX/4LA5eAOt9+nnvNDVLaZkb
# 8WeIwwo+opCMcuyVOMRKSGhh3b2EgMiF83pE6NoNg0ayQST7HvP1Jgglet14nfhk
# 51fo6UKQ9mU4/vL/EtB8FI/ste8U+rYSlsSm0hq45lvKwzL8Q8M6zD29a/DsPknt
# JOXk8//QwWmEmvDB1A0TJCeM9uKa1lMiaou/fKwF/SEky6i5kixuZInlFilrGElU
# x2Hp3M2OnBQWOBfOMIIFjTCCBHWgAwIBAgIQDpsYjvnQLefv21DiCEAYWjANBgkq
# hkiG9w0BAQwFADBlMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5j
# MRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBB
# c3N1cmVkIElEIFJvb3QgQ0EwHhcNMjIwODAxMDAwMDAwWhcNMzExMTA5MjM1OTU5
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
# wI+isX4KJpn15GkvmB0t9dmpsh3lGwIDAQABo4IBOjCCATYwDwYDVR0TAQH/BAUw
# AwEB/zAdBgNVHQ4EFgQU7NfjgtJxXWRM3y5nP+e6mK4cD08wHwYDVR0jBBgwFoAU
# Reuir/SSy4IxLVGLp6chnfNtyA8wDgYDVR0PAQH/BAQDAgGGMHkGCCsGAQUFBwEB
# BG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMGCCsG
# AQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1
# cmVkSURSb290Q0EuY3J0MEUGA1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRp
# Z2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwEQYDVR0gBAow
# CDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUAA4IBAQBwoL9DXFXnOF+go3QbPbYW1/e/
# Vwe9mqyhhyzshV6pGrsi+IcaaVQi7aSId229GhT0E0p6Ly23OO/0/4C5+KH38nLe
# JLxSA8hO0Cre+i1Wz/n096wwepqLsl7Uz9FDRJtDIeuWcqFItJnLnU+nBgMTdydE
# 1Od/6Fmo8L8vC6bp8jQ87PcDx4eo0kxAGTVGamlUsLihVo7spNU96LHc/RzY9Hda
# XFSMb++hUD38dglohJ9vytsgjTVgHAIDyyCwrFigDkBjxZgiwbJZ9VVrzyerbHbO
# byMt9H5xaiNrIv8SuFQtJ37YOtnwtoeW/VvRXKwYw02fc7cBqZ9Xql4o4rmUMIIG
# rjCCBJagAwIBAgIQBzY3tyRUfNhHrP0oZipeWzANBgkqhkiG9w0BAQsFADBiMQsw
# CQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cu
# ZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQw
# HhcNMjIwMzIzMDAwMDAwWhcNMzcwMzIyMjM1OTU5WjBjMQswCQYDVQQGEwJVUzEX
# MBUGA1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNVBAMTMkRpZ2lDZXJ0IFRydXN0
# ZWQgRzQgUlNBNDA5NiBTSEEyNTYgVGltZVN0YW1waW5nIENBMIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAxoY1BkmzwT1ySVFVxyUDxPKRN6mXUaHW0oPR
# nkyibaCwzIP5WvYRoUQVQl+kiPNo+n3znIkLf50fng8zH1ATCyZzlm34V6gCff1D
# tITaEfFzsbPuK4CEiiIY3+vaPcQXf6sZKz5C3GeO6lE98NZW1OcoLevTsbV15x8G
# ZY2UKdPZ7Gnf2ZCHRgB720RBidx8ald68Dd5n12sy+iEZLRS8nZH92GDGd1ftFQL
# IWhuNyG7QKxfst5Kfc71ORJn7w6lY2zkpsUdzTYNXNXmG6jBZHRAp8ByxbpOH7G1
# WE15/tePc5OsLDnipUjW8LAxE6lXKZYnLvWHpo9OdhVVJnCYJn+gGkcgQ+NDY4B7
# dW4nJZCYOjgRs/b2nuY7W+yB3iIU2YIqx5K/oN7jPqJz+ucfWmyU8lKVEStYdEAo
# q3NDzt9KoRxrOMUp88qqlnNCaJ+2RrOdOqPVA+C/8KI8ykLcGEh/FDTP0kyr75s9
# /g64ZCr6dSgkQe1CvwWcZklSUPRR8zZJTYsg0ixXNXkrqPNFYLwjjVj33GHek/45
# wPmyMKVM1+mYSlg+0wOI/rOP015LdhJRk8mMDDtbiiKowSYI+RQQEgN9XyO7ZONj
# 4KbhPvbCdLI/Hgl27KtdRnXiYKNYCQEoAA6EVO7O6V3IXjASvUaetdN2udIOa5kM
# 0jO0zbECAwEAAaOCAV0wggFZMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYE
# FLoW2W1NhS9zKXaaL3WMaiCPnshvMB8GA1UdIwQYMBaAFOzX44LScV1kTN8uZz/n
# upiuHA9PMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggrBgEFBQcDCDB3Bggr
# BgEFBQcBAQRrMGkwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNv
# bTBBBggrBgEFBQcwAoY1aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lD
# ZXJ0VHJ1c3RlZFJvb3RHNC5jcnQwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2Ny
# bDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RHNC5jcmwwIAYDVR0g
# BBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0GCSqGSIb3DQEBCwUAA4ICAQB9
# WY7Ak7ZvmKlEIgF+ZtbYIULhsBguEE0TzzBTzr8Y+8dQXeJLKftwig2qKWn8acHP
# HQfpPmDI2AvlXFvXbYf6hCAlNDFnzbYSlm/EUExiHQwIgqgWvalWzxVzjQEiJc6V
# aT9Hd/tydBTX/6tPiix6q4XNQ1/tYLaqT5Fmniye4Iqs5f2MvGQmh2ySvZ180HAK
# fO+ovHVPulr3qRCyXen/KFSJ8NWKcXZl2szwcqMj+sAngkSumScbqyQeJsG33irr
# 9p6xeZmBo1aGqwpFyd/EjaDnmPv7pp1yr8THwcFqcdnGE4AJxLafzYeHJLtPo0m5
# d2aR8XKc6UsCUqc3fpNTrDsdCEkPlM05et3/JWOZJyw9P2un8WbDQc1PtkCbISFA
# 0LcTJM3cHXg65J6t5TRxktcma+Q4c6umAU+9Pzt4rUyt+8SVe+0KXzM5h0F4ejjp
# nOHdI/0dKNPH+ejxmF/7K9h+8kaddSweJywm228Vex4Ziza4k9Tm8heZWcpw8De/
# mADfIBZPJ/tgZxahZrrdVcA6KYawmKAr7ZVBtzrVFZgxtGIJDwq9gdkT/r+k0fNX
# 2bwE+oLeMt8EifAAzV3C+dAjfwAL5HYCJtnwZXZCpimHCUcr5n8apIUP/JiW9lVU
# Kx+A+sDyDivl1vupL0QVSucTDh3bNzgaoSv27dZ8/DCCBsYwggSuoAMCAQICEAp6
# SoieyZlCkAZjOE2Gl50wDQYJKoZIhvcNAQELBQAwYzELMAkGA1UEBhMCVVMxFzAV
# BgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQDEzJEaWdpQ2VydCBUcnVzdGVk
# IEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGluZyBDQTAeFw0yMjAzMjkwMDAw
# MDBaFw0zMzAzMTQyMzU5NTlaMEwxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdp
# Q2VydCwgSW5jLjEkMCIGA1UEAxMbRGlnaUNlcnQgVGltZXN0YW1wIDIwMjIgLSAy
# MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAuSqWI6ZcvF/WSfAVghj0
# M+7MXGzj4CUu0jHkPECu+6vE43hdflw26vUljUOjges4Y/k8iGnePNIwUQ0xB7pG
# bumjS0joiUF/DbLW+YTxmD4LvwqEEnFsoWImAdPOw2z9rDt+3Cocqb0wxhbY2rzr
# svGD0Z/NCcW5QWpFQiNBWvhg02UsPn5evZan8Pyx9PQoz0J5HzvHkwdoaOVENFJf
# D1De1FksRHTAMkcZW+KYLo/Qyj//xmfPPJOVToTpdhiYmREUxSsMoDPbTSSF6IKU
# 4S8D7n+FAsmG4dUYFLcERfPgOL2ivXpxmOwV5/0u7NKbAIqsHY07gGj+0FmYJs7g
# 7a5/KC7CnuALS8gI0TK7g/ojPNn/0oy790Mj3+fDWgVifnAs5SuyPWPqyK6BIGtD
# ich+X7Aa3Rm9n3RBCq+5jgnTdKEvsFR2wZBPlOyGYf/bES+SAzDOMLeLD11Es0Md
# I1DNkdcvnfv8zbHBp8QOxO9APhk6AtQxqWmgSfl14ZvoaORqDI/r5LEhe4ZnWH5/
# H+gr5BSyFtaBocraMJBr7m91wLA2JrIIO/+9vn9sExjfxm2keUmti39hhwVo99Rw
# 40KV6J67m0uy4rZBPeevpxooya1hsKBBGBlO7UebYZXtPgthWuo+epiSUc0/yUTn
# gIspQnL3ebLdhOon7v59emsCAwEAAaOCAYswggGHMA4GA1UdDwEB/wQEAwIHgDAM
# BgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMCAGA1UdIAQZMBcw
# CAYGZ4EMAQQCMAsGCWCGSAGG/WwHATAfBgNVHSMEGDAWgBS6FtltTYUvcyl2mi91
# jGogj57IbzAdBgNVHQ4EFgQUjWS3iSH+VlhEhGGn6m8cNo/drw0wWgYDVR0fBFMw
# UTBPoE2gS4ZJaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3Rl
# ZEc0UlNBNDA5NlNIQTI1NlRpbWVTdGFtcGluZ0NBLmNybDCBkAYIKwYBBQUHAQEE
# gYMwgYAwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBYBggr
# BgEFBQcwAoZMaHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1
# c3RlZEc0UlNBNDA5NlNIQTI1NlRpbWVTdGFtcGluZ0NBLmNydDANBgkqhkiG9w0B
# AQsFAAOCAgEADS0jdKbR9fjqS5k/AeT2DOSvFp3Zs4yXgimcQ28BLas4tXARv4QZ
# iz9d5YZPvpM63io5WjlO2IRZpbwbmKrobO/RSGkZOFvPiTkdcHDZTt8jImzV3/ZZ
# y6HC6kx2yqHcoSuWuJtVqRprfdH1AglPgtalc4jEmIDf7kmVt7PMxafuDuHvHjiK
# n+8RyTFKWLbfOHzL+lz35FO/bgp8ftfemNUpZYkPopzAZfQBImXH6l50pls1klB8
# 9Bemh2RPPkaJFmMga8vye9A140pwSKm25x1gvQQiFSVwBnKpRDtpRxHT7unHoD5P
# ELkwNuTzqmkJqIt+ZKJllBH7bjLx9bs4rc3AkxHVMnhKSzcqTPNc3LaFwLtwMFV4
# 1pj+VG1/calIGnjdRncuG3rAM4r4SiiMEqhzzy350yPynhngDZQooOvbGlGglYKO
# KGukzp123qlzqkhqWUOuX+r4DwZCnd8GaJb+KqB0W2Nm3mssuHiqTXBt8CzxBxV+
# NbTmtQyimaXXFWs1DoXW4CzM4AwkuHxSCx6ZfO/IyMWMWGmvqz3hz8x9Fa4Uv4px
# 38qXsdhH6hyF4EVOEhwUKVjMb9N/y77BDkpvIJyu2XMyWQjnLZKhGhH+MpimXSuX
# 4IvTnMxttQ2uR2M4RxdbbxPaahBuH0m3RFu0CAqHWlkEdhGhp3cCExwxggTyMIIE
# 7gIBATAtMBkxFzAVBgNVBAMMDlNvcGhpYSBQcm9qZWN0AhBOLjzzW895mkw4Fqtt
# zgEiMAkGBSsOAwIaBQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqG
# SIb3DQEJAzEMBgorBgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3
# AgEVMCMGCSqGSIb3DQEJBDEWBBTxEvFbEPlJ4AMcHpwAkSYgZb2AETANBgkqhkiG
# 9w0BAQEFAASCAQAC5hE11nJVTCNI2ovarpiDa+EtoFWfwPXIWgrcN8bHCSy/x6UB
# spsjV73VU1VktU3nJoO7xiPLXCS6HOx9CZcqwEhhie6VVHm0Ub1UHg+ugZH3IZUA
# t2NN1VLHNXZjGnPlroVXUSy+auyAfzRhZHwQhH3zraa8yKDUntBZjj2QC1PMqhMb
# 7hgIeXeCm3UoHtrAbF+lZlPY9tyG3TNaqwvt613m3iTYLODSSGiTHu8+VAas5QE2
# +KligVcrbHS34/X0mx6zXiZf5xVSiLAGdcXEH08IFpOvkbtFtrqGEPbHT9ihHbTF
# PPmtT2M/HO9HmRb5aaN5HkJ4dgzeqJJWyvlloYIDIDCCAxwGCSqGSIb3DQEJBjGC
# Aw0wggMJAgEBMHcwYzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJ
# bmMuMTswOQYDVQQDEzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2
# IFRpbWVTdGFtcGluZyBDQQIQCnpKiJ7JmUKQBmM4TYaXnTANBglghkgBZQMEAgEF
# AKBpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIy
# MDgxMjE5MTAwN1owLwYJKoZIhvcNAQkEMSIEINV/pUMndzs7EcnWrKSo639myYMy
# yhX7OitHU0ywT2atMA0GCSqGSIb3DQEBAQUABIICAHWJjggjVdvf9gW6+oyF/92D
# iFIA1o1Hv52/ebwq3UYaXFeX4pwZNMuzYlfTbMj7BVaEtK0UWUiJdCvcdvdoahEM
# BdUyn/3c4ehjo2XrEtSSx5obI5ukYzuOfsnvY0SambZXQZNPkuMyhHDeAJn7WvOF
# AqYh+FYIOurtveQGSCSNYXnysX/A7jx0xt6JxicYjV1HGo73Bz0wzuc9C8T8Xeeu
# 6mu5G0ITmG2ekAke+7qQDfKyi7YL+NcgQBVJU1wVhBmU2MwCN2PHpgEj3Z8GzwLg
# 54EQ213NByiKgPzJ0owFNlpEQXkFk2S4o0nAXSI2m53XqEdgwwjU3+o9W+hRG8WH
# PTP+ymlg8x59Q3N5n5UeyhU3umfxiK2VNsH9qX30z8wHQqlMGop2ZCwbp3sUCpNo
# J+ZkZLQeNbvnOyuNDuMRnRFm3irZgFN9FPqpDXKZ2SzTVkvPhB+8Sc5sAE7ZSbZL
# ObYhml21DpwhWl0+wxJXlhkoEIVw0dM/u8tMaT4ylpJ15hl7EkVXJsPousXP6Jex
# J8/ywQ2EbpFoxIQst03oxppE/0F7uOaKuUd5UYt3MbslB9Yc0EsWT530LZjr6VGN
# ApevnHs/b7oGib6oOf3WdTtyi7Zg3glQLck60WDgy4UHpMnNt7EXUI9596YsZQTy
# EzwAI+hmS5xAwjJaEyqZ
# SIG # End signature block
