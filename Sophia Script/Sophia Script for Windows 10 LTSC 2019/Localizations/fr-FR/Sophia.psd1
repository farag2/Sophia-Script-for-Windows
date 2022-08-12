ConvertFrom-StringData -StringData @'
UnsupportedOSBitness                      = Le script supporte uniquement Windows 10 x64
UnsupportedOSBuild                        = Le script supporte le version Windows 10 Enterprise LTSC 2019
UpdateWarning                             = La mise à jour cumulative de Windows 10 est installée : {0}. Mise à jour cumulative prise en charge : 3046 et plus
UnsupportedLanguageMode                   = La session PowerShell s'exécute dans un mode de langue limité
LoggedInUserNotAdmin                      = L'utilisateur connecté n'a pas de droits d'administrateur
UnsupportedPowerShell                     = Vous essayez d'exécuter le script via PowerShell {0}.{1}. Exécutez le script dans la version appropriée de PowerShell
UnsupportedISE                            = Le script ne supporte pas l'exécution via Windows PowerShell ISE
Win10TweakerWarning                       = Votre système d'exploitation a probablement été infecté par la porte dérobée Win 10 Tweaker
Windows10DebloaterWarning                 = La stabilité de l'OS Windows peut avoir été compromise par l'utilisation du script PowerShell Windows10Debloater de Sycnex. De manière préventive, réinstallez l'ensemble de l'OS
bin                                       = Il n'y a pas de fichiers dans le dossier bin. Veuillez retélécharger l'archive
RebootPending                             = Le PC attend d'être redémarré
UnsupportedRelease                        = Nouvelle version trouvée
CustomizationWarning                      = \nAvez-vous personnalisé chaque fonction du fichier de préréglage {0} avant d'exécuter Sophia Script?
DefenderBroken                            = \nMicrosoft Defender cassé ou supprimé du système d'exploitation
ControlledFolderAccessDisabled            = Contrôle d'accès aux dossiers désactivé
ScheduledTasks                            = Tâches planifiées
WindowsFeaturesTitle                      = Fonctionnalités
OptionalFeaturesTitle                     = Fonctionnalités optionnelles
EnableHardwareVT                          = Activer la virtualisation dans UEFI
UserShellFolderNotEmpty                   = Certains fichiers laissés dans le dossier "{0}". Déplacer les manuellement vers un nouvel emplacement
RetrievingDrivesList                      = Récupération de la liste des lecteurs...
DriveSelect                               = Sélectionnez le disque à la racine dans lequel le dossier "{0}" sera créé.
CurrentUserFolderLocation                 = L'emplacement actuel du dossier "{0}": "{1}"
UserFolderRequest                         = Voulez vous changer où est placé le dossier "{0}" ?
UserFolderSelect                          = Sélectionnez un dossier pour le dossier "{0}"
UserDefaultFolder                         = Voulez vous changer où est placé le dossier "{0}" à sa valeur par défaut?
GraphicsPerformanceTitle                  = Préférence de performances graphiques
GraphicsPerformanceRequest                = Souhaitez-vous définir le paramètre de performances graphiques d'une application de votre choix sur "Haute performance"?
TaskNotificationTitle                     = Notification
CleanupTaskNotificationTitle              = Une information importante
CleanupTaskDescription                    = Nettoyage des fichiers Windows inutilisés et des mises à jour à l'aide de l'application intégrée pour le nettoyage de disque
CleanupTaskNotificationEventTitle         = Exécuter la tâche pour nettoyer les fichiers et les mises à jour inutilisés de Windows?
CleanupTaskNotificationEvent              = Le nettoyage de Windows ne prendra pas longtemps. Cette notification apparaîtra à nouveau dans 30 jours
CleanupTaskNotificationSnoozeInterval     = Sélectionnez un intervalle de rappel
CleanupNotificationTaskDescription        = Rappel de notification contextuelle sur le nettoyage des fichiers et des mises à jour inutilisés de Windows
SoftwareDistributionTaskNotificationEvent = Le cache de mise à jour Windows a bien été supprimé
TempTaskNotificationEvent                 = Le dossier des fichiers temporaires a été nettoyé avec succès
FolderTaskDescription                     = Nettoyage du dossier "{0}"
EventViewerCustomViewName                 = Création du processus
EventViewerCustomViewDescription          = Audit des événements de création du processus et de ligne de commande
RestartWarning                            = Assurez-vous de redémarrer votre PC
ErrorsLine                                = Ligne
ErrorsFile                                = Fichier
ErrorsMessage                             = Erreurs/Avertissements
Add                                       = Ajouter
AllFilesFilter                            = Tous les Fichiers (*.*)|*.*
Browse                                    = Parcourir
DialogBoxOpening                          = Afficher la boîte de dialogue...
Disable                                   = Désactiver
Enable                                    = Activer
EXEFilesFilter                            = *.exe|*.exe|Tous les Fichiers (*.*)|*.*
FolderSelect                              = Sélectionner un dossier
FilesWontBeMoved                          = Les fichiers ne seront pas déplacés
FourHours                                 = 4 heures
HalfHour                                  = 30 minutes
Install                                   = Installer
Minute                                    = 1 minute
NoData                                    = Rien à afficher
NoInternetConnection                      = Pas de connexion Internet
RestartFunction                           = Veuillez redémarrer la fonction "{0}"
NoResponse                                = Une connexion n'a pas pu être établie avec {0}
No                                        = Non
Yes                                       = Oui
Open                                      = Ouvert
Patient                                   = Veuillez patienter...
Restore                                   = Restaurer
Run                                       = Démarrer
SelectAll                                 = Tout sélectionner
Skipped                                   = Passé
FileExplorerRestartPrompt                 = \nParfois, pour que les modifications soient prises en compte, il faut redémarrer l'Explorateur de fichiers
TelegramGroupTitle                        = Rejoignez notre groupe Telegram officiel
TelegramChannelTitle                      = Rejoignez notre canal Telegram officiel
Uninstall                                 = Désinstaller
'@

# SIG # Begin signature block
# MIIbmwYJKoZIhvcNAQcCoIIbjDCCG4gCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUFjXDCCpLNp+JvhC6dXxecSzT
# sIugghYTMIIDAjCCAeqgAwIBAgIQTi4881vPeZpMOBarbc4BIjANBgkqhkiG9w0B
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBRcAOOMJtQV2bT8Z2e701hRuDqfgzANBgkqhkiG
# 9w0BAQEFAASCAQAYAYFprpEvMwF2LqD9PJOpe5B/Lu+xEhXfbBb7UJtjypP+RKT3
# La6ICU2BFBSKcjH9zxCMz5ZZX49BYyhlcDR1CG16UTqezmKY/GzH9T4qZI1obpaC
# lM5uf5bqtqAdya50ByG4zHMKoprqtMfGvZP7hzqzSQC/Ygs4+NblI65MFnSPOa+f
# TqvuZr2of87m+XBOXbbToxoPNGvUMbU8b6+oOlM5gofEePygzVIyHzaMRT47xFa5
# 6ch3sa/lHoklvv2BYZI6Fv7hsHVpmuaZ63B6aKhpISVe17w/ERZYv6RfdcloXavD
# YcMX7eLBG1bo7IWXNg/PfKyYg23yONrH/wD5oYIDIDCCAxwGCSqGSIb3DQEJBjGC
# Aw0wggMJAgEBMHcwYzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJ
# bmMuMTswOQYDVQQDEzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2
# IFRpbWVTdGFtcGluZyBDQQIQCnpKiJ7JmUKQBmM4TYaXnTANBglghkgBZQMEAgEF
# AKBpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIy
# MDgxMjE5MDk1NVowLwYJKoZIhvcNAQkEMSIEIF6rx1+4KagpPNgQerflzlim76U7
# +2FCtFiYettorI6iMA0GCSqGSIb3DQEBAQUABIICAAG8wJxcqsR4S0C2SP2m5t2M
# Erkd6h9rRc36yYTfNBBrs3pZ3kzbnOPnffHR1dFKvsF1Q8Ll8+Qy7PpXb0XG1wGK
# jG5YW58/y/TrhI7Xcbz2af8Rg7L/hOCD6TSeqeuHnt+5otJGMJw1TgZDYujuAe7g
# lkoi4gqmcu9ILpDJqQl6sN9Js7cFcNpj/ZWeuOg9Ojb/vxiKyM1oNALI2nDzy2LR
# z8ZYEXiJsB65xQXSynLKGs7vVLlaNNBvCrlj440Z4PySUdLp0CXYd96eXzCT1eo7
# yJRYcFgURbhsfWCrcPbJXTSgVXYIGkxfCoQfuOkO6QBk3hGibhhNHjlxC8lQ6UHK
# 8EHFTjHtvr9KbF1m7pLO6yMgo27NN4zuXKqzkpZ/tpapmskW2EGfQ831ufJWELxM
# HK0sNKUoKR3qweYazNL1GQo36wk3YYNyiJP5kC/ZzTTiDmqZJXmGtvsNG8SXOiXb
# 7PqXZp7t6KosHqfK/91fP5uPJ42YKOouHersYV4EHCP2i+tAthTmhO9N766ynwr2
# QSZ2zHjtE3zp+qKgEqt8pssfKRCy9DYCT2KB2pNVOl4SJLYdiRkxkhLixrAZ3ntV
# cLACmCkby0vcNU/6Kp88YSuol7BQXOw1HFp3l/r8iF05PBcBruG+JYVNDb6Fm6JY
# m1qmhFbogSpHYebEDa2o
# SIG # End signature block
