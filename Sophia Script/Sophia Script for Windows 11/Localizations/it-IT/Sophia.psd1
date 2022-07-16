ConvertFrom-StringData -StringData @'
UnsupportedOSBuild                        = Lo script supporta Windows 11 21H2 e versioni successive
UpdateWarning                             = La tua build di Windows 11 {0}.{1} non è supportata. Build supportate: 22000.739, 22509 e successive
UnsupportedLanguageMode                   = La sessione PowerShell è in esecuzione in modalità lingua limitata
LoggedInUserNotAdmin                      = L'utente in suo non ha i diritti di amministratore
UnsupportedPowerShell                     = Stai cercando di eseguire lo script tramite PowerShell {0}.{1}. Esegui lo script nella versione di PowerShell appropriata
UnsupportedISE                            = Lo script non supporta l'esecuzione tramite Windows PowerShell ISE
Win10TweakerWarning                       = Probabilmente il tuo sistema operativo è stato infettato tramite una backdoor in Win 10 Tweaker
Windows10DebloaterWarning                 = La stabilità del sistema operativo Windows potrebbe essere stata compromessa dall'utilizzo dello script PowerShell Windows10Debloater di Sycnex. È consigliato reinstallare il sistema operativo
bin                                       = Non ci sono file nella cartella bin. Per favore, scarica di nuovo l'archivio
RebootPending                             = Il PC è in attesa di essere riavviato
UnsupportedRelease                        = Nuova versione trovata
CustomizationWarning                      = \nSono state personalizzate tutte le funzioni nel file di configurazione {0} prima di eseguire Sophia Script?
DefenderBroken                            = \nMicrosoft Defender rimosso dal sistema
ControlledFolderAccessDisabled            = l'accesso alle cartelle controllata disattivata
ScheduledTasks                            = Attività pianificate
OneDriveUninstalling                      = Disinstallazione di OneDrive...
OneDriveInstalling                        = Installazione di OneDrive...
OneDriveDownloading                       = Download di OneDrive... ~ Circa 33 MB
OneDriveWarning                           = La funzione "{0}" sarà applicata solo se il preset è configurato per rimuovere OneDrive (o se l'app è già stata rimossa), altrimenti la funzionalità di backup per le cartelle "Desktop" e "Pictures" in OneDrive si interromperà
WindowsFeaturesTitle                      = Funzionalità di Windows
OptionalFeaturesTitle                     = Caratteristiche opzionali
EnableHardwareVT                          = Abilita virtualizzazione in UEFI
OpenInWindowsTerminalAdmin                = Aprire in Windows Terminal (Admin)
UserShellFolderNotEmpty                   = Alcuni file rimasti nella cartella "{0}". Spostali manualmente in una nuova posizione
RetrievingDrivesList                      = Recupero lista unità...
DriveSelect                               = Selezionare l'unità all'interno della radice del quale verrà creato la cartella "{0}" 
CurrentUserFolderLocation                 = La posizione attuale della cartella "{0}": "{1}"
UserFolderRequest                         = Volete cambiare la posizione della cartella "{0}"?
UserFolderSelect                          = Selezionare una posizione per la cartella "{0}"
UserDefaultFolder                         = Volete cambiare la posizione della cartella "{0}" al valore di default?
ReservedStorageIsInUse                    = Questa operazione non è supportata quando spazio riservato è in uso Si prega di eseguire nuovamente la funzione "{0}" dopo il riavvio del PC
ShortcutPinning                           = Il collegamento "{0}" è stato bloccato...
SSDRequired                               = Per utilizzare Windows Subsystem for Android™ sul proprio dispositivo, è necessario che sul PC sia installata un'unità a stato solido (SSD)
UninstallUWPForAll                        = Per tutti gli utenti
UWPAppsTitle                              = UWP Apps
HEVCDownloading                           = Download del codec video HEVC Video estenxion dal produttore... ~ Circa 2,8 MB
GraphicsPerformanceTitle                  = Preferenza per le prestazioni grafiche
GraphicsPerformanceRequest                = Volete impostare l'impostazione delle prestazioni grafiche di un app di vostra scelta a "Prestazioni elevate"?
TaskNotificationTitle                     = Notifiche
CleanupTaskNotificationTitle              = Informazioni importanti
CleanupTaskDescription                    = Pulizia di Windows e dei file inutilizzati degli aggiornamenti utilizzando l'app built-in ""pulizia disco"
CleanupTaskNotificationEventTitle         = Eseguire l'operazione di pulizia dei file inutilizzati e aggiornamenti di Windows?
CleanupTaskNotificationEvent              = Per la Pulizia di Windows non ci vorrà molto. La notifica  verrà mostrata nuovamente fra 30 giorni
CleanupTaskNotificationSnoozeInterval     = Selezionare intervallo del promemoria 
CleanupNotificationTaskDescription        = Pop-up promemoria di pulizia dei file inutilizzati e degli aggiornamenti di Windows
SoftwareDistributionTaskNotificationEvent = La cache degli aggiornamenti di Windows cancellata con successo
TempTaskNotificationEvent                 = I file cartella Temp puliti con successo
FolderTaskDescription                     = Pulizia della cartella "{0}"
EventViewerCustomViewName                 = Creazione del processo
EventViewerCustomViewDescription          = Creazione del processi e degli eventi di controllo della riga di comando
RestartWarning                            = Assicurarsi di riavviare il PC
ErrorsLine                                = Linea
ErrorsFile                                = File
ErrorsMessage                             = Errori/avvisi
Add                                       = Inserisci
AllFilesFilter                            = Tutti i file (*.*)|*.*
Browse                                    = Sfogliare
DialogBoxOpening                          = Visualizzazione della finestra di dialogo...
Disable                                   = Disattivare
Enable                                    = Abilitare
EXEFilesFilter                            = *.exe|*.exe|Tutti i file (*.*)|*.*
FolderSelect                              = Selezionare una cartella
FilesWontBeMoved                          = I file non verranno trasferiti
FourHours                                 = 4 ore
HalfHour                                  = 30 minuti
Install                                   = Installare
Minute                                    = 1 minuto
NoData                                    = Niente da esposizione
NoInternetConnection                      = Nessuna connessione Internet
RestartFunction                           = Si prega di riavviare la funzione "{0}"
NoResponse                                = Non è stato possibile stabilire una connessione con {0}
No                                        = No
Yes                                       = Sì
Open                                      = Aperto
Patient                                   = Attendere prego...
Restore                                   = Ristabilire
Run                                       = Eseguire
SelectAll                                 = Seleziona tutto
Skipped                                   = Saltato
FileExplorerRestartPrompt                 = \nA volte, affinché le modifiche abbiano effetto, il processo di File Explorer deve essere riavviato
TelegramGroupTitle                        = Unisciti al nostro gruppo ufficiale Telegram
TelegramChannelTitle                      = Unisciti al nostro canale ufficiale di Telegram
Uninstall                                 = Disinstallare
'@

# SIG # Begin signature block
# MIIbvwYJKoZIhvcNAQcCoIIbsDCCG6wCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUzTfj1PBZbHSJGvMjryCwbgvT
# l22gghY3MIIDAjCCAeqgAwIBAgIQbPiUYMntEr9PH9C5Mau3xTANBgkqhkiG9w0B
# AQsFADAZMRcwFQYDVQQDDA5Tb3BoaWEgUHJvamVjdDAeFw0yMjA3MTYxNDM2MDda
# Fw0yNDA3MTYxNDQ2MDdaMBkxFzAVBgNVBAMMDlNvcGhpYSBQcm9qZWN0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtFM5b/hNUQPcNCKlWVisE5zIERdC
# TZWdsnkliCg98qv0qkPH08AAuZ5LOgdctfaocVX4RbygcWCLyaphktSC29aMHmP/
# T/JPBSYnLmWIJ6NbNVBn4BqqCZusjmYRj1LH+Ega9Kv4gFfF4lyCE8OnebDkWPu1
# Y+5VAoZ6BaVvHEw5rtrHcH8/W15mE1Z+uuYIKNVPg3MMGNGQ5MiLUduuCu5l+J4K
# yU/nLvx7tI3tIx8wJY2S2SYDNPf/bMOeeb0jlcD1/bVh5TNn3Z4wIXQ3r4yNxllO
# dBPidPT3Ck4+aDTzP/Y8vrFeIMLKSCYGY+cOCankPZmUCVFJxABvW5EKDQIDAQAB
# o0YwRDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0O
# BBYEFMJrBhADhZmuEvA18MvGfrBsUpDhMA0GCSqGSIb3DQEBCwUAA4IBAQCzuSeY
# YdiLsJYFPUW21r2QjSbIi7oOAa58Y2C7KM+QvAm7R6W7l3y6Zz58mBZmSCt+u6au
# HHYYxo71eCKcH6Lx/2BAeg3GBfZClCZ480nxH1+T4fobdWuT/f4Iw8ZalqcnqJQQ
# xXhK2U8sMS6oIlb8VZhzosiP68gSZwNgcBbO8P1nAVa7WXyhdmo5CTpa1CihfOT2
# a3x7runLfgPHmgDcTQpJYAl4xA1JgM+5adlGo33uDXNDgN+6MPZKCuD89wFIYbXw
# WM6i+SHOBvqACWvM5goBCiVuIq2aI/6r6jeW8UiN51L0/IIniY+P0e7ZibjiadZR
# DuMQLs5d3GLELtT3MIIFsTCCBJmgAwIBAgIQASQK+x44C4oW8UtxnfTTwDANBgkq
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
# BgNVBAMMDlNvcGhpYSBQcm9qZWN0AhBs+JRgye0Sv08f0Lkxq7fFMAkGBSsOAwIa
# BQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgor
# BgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3
# DQEJBDEWBBQgf4ByMI8M39S5Fs1sQldY94iLnzANBgkqhkiG9w0BAQEFAASCAQCI
# QFrYJNFFvtDl0+sI4kLruD+Ot8cHry0S0RkiQPoIMg6TViP1n/TC3wJkXgy8npNh
# U52KpwFtPpj1YcT5toXK4o0RhmMhBa2poOZ8amSulqbTUYM4Uj9CAH4Lu1iMxlsw
# quCMJP6OxFbl+1vgnmVxrJcTLs2pHrjVgBbEwhW6xjxG+PYdgIyo+qQzDT58srec
# EbSCfntVVv8Guuu/MxnPsQ7HZFO+zPvJDx8j0FRL8AXoeHh3FSoljtZdEYDOIuGe
# zlkLJOlj6nnqUmojIuVE42kyZRJsbHVzKmMtop1fLxpuBK9slcNq7nAEVs+VZjuq
# OLXIQKdRBMWrDZcwo+K5oYIDIDCCAxwGCSqGSIb3DQEJBjGCAw0wggMJAgEBMHcw
# YzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQD
# EzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGlu
# ZyBDQQIQCnpKiJ7JmUKQBmM4TYaXnTANBglghkgBZQMEAgEFAKBpMBgGCSqGSIb3
# DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDcxNjE0NDYxOVow
# LwYJKoZIhvcNAQkEMSIEIJgN6dzefhhc0AdUqDpWCcal8SmbrxOGFcBeuQyOnHkW
# MA0GCSqGSIb3DQEBAQUABIICABpnEx3Dq7G6l41/Fs9krBabzyjLotiPYmJ/22AF
# Gc8r5vXiOx4GFhRvbkRyU/K1IRYXw/br64isOAUGqObZfj4pj3GcbohrQsZ99oED
# BcSkqtVmZObMC4T9qEMmkBA0f2mtTS69Kz8qEFoQiW5Hc0/j2qkOZSwoniXMlRdW
# NMgq9QlsXGEwD7RuDTW+iuLIuqp4aD90FKmvM2zvS0a+Ki4VaiEPaEqfTyzWCw80
# buMdsINIq9WK8MEEmLmNecU0XA2RZKfLRbiTTJWMVmQafWbY9bwl3PH5qlVqvkq7
# 2NXfujXErLFZo0i17xTxHlj7j1Tntc5Q3aqym2oIHsRugrazcvDO2EIffwf9m4pu
# kY/0HIklc7xe+4n/DVH+SMHD1IAA13CCf6IjBUTCmPE/dplgWk/gJ4/dt98l10W6
# bqf2GEeo7eUzG9aoPWVicdrt8tCRqyuJVUV8xdWaibKRqtmV/MYMG3vwEcR/S5QD
# 0yUsIgPVrxSh9zePHSjK5ut2mhhlomef1mASiCUqdNAPj9sqFLpyJvzheP0ZfKuM
# yX1EW5DLc0sVnUxTBvcgEbceVdUt/Vr+yLtJIqxXJAa+2mMKjio1zspCgFUbaA4V
# uLUhSjnyYC7EsCyuUOTL9CeiwAW4Mi737zwM7aPz75OYhKo6fKGN+IMZy379qmYM
# stp0
# SIG # End signature block
