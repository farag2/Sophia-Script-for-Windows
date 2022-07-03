ConvertFrom-StringData -StringData @'
UnsupportedOSBitness                      = O script suporta somente Windows 10 x64
UnsupportedOSBuild                        = O script suporta versões Windows 10 2004/20H2/21H1/21H2
UpdateWarning                             = Atualização cumulativa do Windows 10 instalado: {0}. Actualização acumulada suportada: 1151 e superior
UnsupportedLanguageMode                   = A sessão PowerShell em funcionamento em um modo de linguagem limitada
LoggedInUserNotAdmin                      = O usuário logado não tem direitos de administrador
UnsupportedPowerShell                     = Você está tentando executar o script via PowerShell {0}.{1}. Execute o script na versão apropriada do PowerShell
UnsupportedISE                            = O guião não suporta a execução através do Windows PowerShell ISE
Win10TweakerWarning                       = Probabilmente il tuo sistema operativo è stato infettato tramite la backdoor Win 10 Tweaker
Windows10DebloaterWarning                 = A estabilidade do sistema operacional Windows pode ter sido comprometida pela utilização do script Windows10Debloater PowerShell da Sycnex. Preventivamente, reinstale todo o sistema operacional
bin                                       = Não existem ficheiros na pasta bin. Por favor, volte a descarregar o arquivo
RebootPending                             = O PC está esperando para ser reiniciado
UnsupportedRelease                        = Nova versão encontrada
CustomizationWarning                      = \nVocê personalizou todas as funções no arquivo de predefinição {0} antes de executar o Sophia Script?
ControlledFolderAccessDisabled            = Acesso controlado a pasta desativada
ScheduledTasks                            = Tarefas agendadas
OneDriveUninstalling                      = Desinstalar OneDrive...
OneDriveInstalling                        = Instalar o OneDrive...
OneDriveDownloading                       = Baixando OneDrive... ~33 MB
OneDriveWarning                           = A função "{0}" será aplicada somente se a predefinição for configurada para remover o OneDrive (ou a aplicação já foi removida), caso contrário a funcionalidade de backup para as pastas "Desktop" e "Pictures" no OneDrive quebra
WindowsFeaturesTitle                      = Recursos do Windows
OptionalFeaturesTitle                     = Recursos opcionais
EnableHardwareVT                          = Habilitar virtualização em UEFI
UserShellFolderNotEmpty                   = Alguns arquivos deixados na pasta "{0}". Movê-los manualmente para um novo local
RetrievingDrivesList                      = Recuperando lista de unidades...
DriveSelect                               = Selecione a unidade dentro da raiz da qual a pasta "{0}" será criada
CurrentUserFolderLocation                 = A localização actual da pasta "{0}": "{1}"
UserFolderRequest                         = Gostaria de alterar a localização da pasta "{0}"?
UserFolderSelect                          = Selecione uma pasta para a pasta "{0}"
UserDefaultFolder                         = Gostaria de alterar a localização da pasta "{0}" para o valor padrão?
ReservedStorageIsInUse                    = Esta operação não é suportada quando o armazenamento reservada está em uso\nFavor executar novamente a função "{0}" após o reinício do PC
ShortcutPinning                           = O atalho "{0}" está sendo fixado no Iniciar...
UninstallUWPForAll                        = Para todos os usuários...
UWPAppsTitle                              = Apps UWP
HEVCDownloading                           = Baixando HEVC Vídeo Extensões de Dispositivo Fabricante... ~ 2,8 MB
GraphicsPerformanceTitle                  = Preferência de desempenho gráfico
GraphicsPerformanceRequest                = Gostaria de definir a configuração de performance gráfica de um app de sua escolha para "alta performance"?
TaskNotificationTitle                     = Notificação
CleanupTaskNotificationTitle              = Informação importante
CleanupTaskDescription                    = Limpando o Windows arquivos não utilizados e atualizações usando o aplicativo de limpeza aplicativo de limpeza embutido no disco
CleanupTaskNotificationEventTitle         = Executar tarefa para limpar arquivos e atualizações não utilizados do Windows?
CleanupTaskNotificationEvent              = Limpeza de janelas não vai demorar muito. Da próxima vez que esta notificação será exibida em 30 dias
CleanupTaskNotificationSnoozeInterval     = Selecione um lembrete de intervalo
CleanupNotificationTaskDescription        = Pop-up lembrete de notificação sobre a limpeza do Windows arquivos não utilizados e actualizações
SoftwareDistributionTaskNotificationEvent = O cache de atualização do Windows excluído com sucesso
TempTaskNotificationEvent                 = Os arquivos da pasta Temp limpos com sucesso
FolderTaskDescription                     = A limpeza da pasta "{0}"
EventViewerCustomViewName                 = Criação de processo
EventViewerCustomViewDescription          = Criação de processos e eventos de auditoria de linha de comando
RestartWarning                            = Certifique-se de reiniciar o PC
ErrorsLine                                = Linha
ErrorsFile                                = Arquivo
ErrorsMessage                             = Erros/Avisos
Add	                                  = Adicionar
AllFilesFilter                            = Todos os arquivos (*.*)|*.*
Browse                                    = Procurar
DialogBoxOpening                          = Exibindo a caixa de diálogo...
Disable                                   = Desativar
Enable                                    = Habilitar
EXEFilesFilter                            = *.exe|*.exe| Todos os arquivos (*.*)|*.*
FolderSelect                              = Escolha uma pasta
FilesWontBeMoved                          = Os arquivos não serão transferidos
FourHours                                 = 4 horas
HalfHour                                  = 30 minutos
Install                                   = Instalar
Minute                                    = 1 minuto
NoData        	                          = Nada à exibir
NoInternetConnection                      = Sem conexão à Internet
RestartFunction                           = Favor reiniciar a função "{0}"
NoResponse                                = Uma conexão não pôde ser estabelecida com {0}
No                                        = Não
Yes                                       = Sim
Open                                      = Abrir
Patient                                   = Por favor, espere...
Restore                                   = Restaurar
Run                                       = Executar
SelectAll                                 = Selecionar tudo
Skipped                                   = Ignorados
FileExplorerRestartPrompt                 = \nPor vezes, para que as alterações tenham efeito, o processo File Explorer tem de ser reiniciado
TelegramGroupTitle                        = Entre no grupo oficial do Telegram
TelegramChannelTitle                      = Entre no canal oficial do Telegram
Uninstall                                 = Desinstalar
'@

# SIG # Begin signature block
# MIIbvwYJKoZIhvcNAQcCoIIbsDCCG6wCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUIfcUJUlMLSpf0mcXm/HRwcBZ
# GPSgghY3MIIDAjCCAeqgAwIBAgIQHBJEoeFlZo5BtFhY0lY32zANBgkqhkiG9w0B
# AQsFADAZMRcwFQYDVQQDDA5Tb3BoaWEgUHJvamVjdDAeFw0yMjA3MDMyMTE5MTha
# Fw0yNDA3MDMyMTI5MThaMBkxFzAVBgNVBAMMDlNvcGhpYSBQcm9qZWN0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwGxQ5ya4aq2QIhrHY7iWfsgJablN
# ti3loiPnXdaV0zTf9Ksba98/Cbo54lI1PaM4zy2gUqLOGy88dKvtr+T7NkkiApns
# pIrPbp50QrBoUWx5WEDJ144nPj5FjTAnsYfFcaN3F+fKylPBHb0Pc0/B1F+dEZu/
# Z9BShmzDgL98JbjgafXWlGE6vJTjqy02SWSqovcEFfwAKcN1diK5mSnbC2RfyHvK
# /9ohG8XrubRZ4znHCin+mq96rOG0Mvz+3DLkodx4AsP+melPWfXOjWHiY5SHbEnb
# YL/ViesUNbvHP7VKLFA8Crap5DyMXpFfU96SuvzF9G4TBQy601MjcZ9U1QIDAQAB
# o0YwRDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0O
# BBYEFDZjgZi39aNu04e2Uoa8OPtzEiR1MA0GCSqGSIb3DQEBCwUAA4IBAQBh6dld
# oQH2U5YQ1Vzgn3F+OCtBVdwu2mIiYNddlbu6GmM7trnhKk0TzaYe49LdsJg7He5F
# bIMuv6u2gueTDxR2ZHm1cZMX50Fu3vlllk03R/wXElJhE1Li5ZIOQ6xYtDwWyYgG
# Uts3P1KudCttmZxFTGTl/JzPK3Ai1J3v6IoGsTS3lE+QolyEB5R9Khke/+ulkfyd
# IismxMfZKzLmwcp9jRUmrbRjj+cC2mh3Yhch4BRmyqPeIqAL6rMXhV8fuKVhMhP8
# UF5CtrCcRgO4NKLDnC7RJ6v7v/vYVl9aquLaj3utZWZ+L40yFQtvQKL56+LIckXG
# 0tmmFS0RnPnJmx48MIIFsTCCBJmgAwIBAgIQASQK+x44C4oW8UtxnfTTwDANBgkq
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
# BgNVBAMMDlNvcGhpYSBQcm9qZWN0AhAcEkSh4WVmjkG0WFjSVjfbMAkGBSsOAwIa
# BQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgor
# BgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3
# DQEJBDEWBBSitm6GuIk26ZWnNWgAbe0JjeBCVjANBgkqhkiG9w0BAQEFAASCAQCM
# uQ9w+t1PgwojH+KqRWPUmFlBNm2vZ7OKG1b5jE7D/BjqCu4N+k6vzYM/sSGOeyIw
# CMKphYXX7hzET6SJ1IyTB2b8DkyVBK9+GkGD0oTkVC4691tEsKKLKViAC8Qw30oK
# nGupQfy3cwFoc/1qSLuGqhiUNQiLwSA6/SPZNw5PjjodseIfpLXxnanygLl196cy
# 68MCATslKJxUBrEAL4KoIAAtaVTeMwSVRT2u+gdAbPz4yEFTK/ro7hUA2za4vHWx
# 9RO8HipMn1K9KhxWNbg4DltQow6tDw8Ckj2xhToHg62bIQ/qscLbKBTBR8LZJJWE
# O5kcHVDuHIpfiL16wt0KoYIDIDCCAxwGCSqGSIb3DQEJBjGCAw0wggMJAgEBMHcw
# YzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQD
# EzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGlu
# ZyBDQQIQCnpKiJ7JmUKQBmM4TYaXnTANBglghkgBZQMEAgEFAKBpMBgGCSqGSIb3
# DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDcwMzIxMjkyNlow
# LwYJKoZIhvcNAQkEMSIEIFSKfl3OXzhqThiR9WGt13Dq2n6CDMM3fHkqMVmFrsIH
# MA0GCSqGSIb3DQEBAQUABIICAG2bZRzRPHYetjzgPqpuvIHJjvlXMvXUWCHprJDQ
# BRNjg1+K0s5FNZw1cVyShmufmCTsMWpzptKD1JYp4+Df0o3JjjEfCivPUuomTvxY
# abvcWGqhCyADNw1dTigvTy2pP3EElCtfCecxHTvL9Ql7apzz0d/Rzh7smvriT5Rx
# jePdFaWIrLGBCvFrJQNSd8b3omIHUrbjOYLKJtNpPEKE9wSEMe79+ly5Cvy24rKg
# Dyqnx8VCVsbgBZ1a90F6PBrrF9SPdyoS0wBOaDFP98FeR74grcQl1+S89zsFKekw
# IR7wktjesN4DniIZJmJmpODcs/OLru66o5TsPrd3jfxzFKURqYo1xCvOUl29Qqng
# 3paFLHHFJczJB8LAN12xykFwqfkfrQQDtfRlhlSoNV+rcwKTPSkoMdYNEB1zwqCF
# NSh8ZiJpPPd57uO9xRwSj2YEYwN/oTRTEQVImA91dD7zRwCOYTjvOwaZoUMKRfGJ
# 7QFq5PFzykHLgRuWH1pTvhet1KPeqrOHtWUKdtNuklc8Pmrd2AFCHhNn/abBFlI8
# SPp8lDMu/0hOegcJAqzvmNQD1GwwR736GM+pjlPm3XMryVmg/wksNqJxumkCt9el
# tJWE6y07X0p8O3B3F/jg76gi6RcNUlhlGWllLiU/5fqdJztJQQ5/dTuCAO60VRnj
# yWW6
# SIG # End signature block
