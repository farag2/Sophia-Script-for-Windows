ConvertFrom-StringData -StringData @'
UnsupportedOSBitness                      = A szkript csak a Windows 10 64 bites verziót támogatja
UnsupportedOSBuild                        = A szkript támogatja a Windows 10 Enterprise LTSC 2019 kiadást
UpdateWarning                             = A Windows 10 összesített frissítése telepítve: {0}. Támogatott kumulatív frissítés: 3046 és magasabb verziószámok
UnsupportedLanguageMode                   = A PowerShell munkamenet korlátozott nyelvi üzemmódban fut
LoggedInUserNotAdmin                      = A bejelentkezett felhasználó nem rendelkezik admin jogokkal
UnsupportedPowerShell                     = A PowerShell {0}.{1} segítségével próbálja futtatni a szkriptet. Futtassa a szkriptet a megfelelő PowerShell-verzióban
UnsupportedISE                            = A szkript nem támogatja a Windows PowerShell ISE futtatását
Win10TweakerWarning                       = Valószínűleg az operációs rendszerét a Win 10 Tweaker backdoor segítségével fertőzték meg
Windows10DebloaterWarning                 = A Windows operációs rendszer stabilitását veszélyeztethette a Sycnex Windows10Debloater PowerShell szkriptje. Megelőzésképpen telepítse újra a teljes operációs rendszert
bin                                       = A bin mappában nincsenek fájlok. Kérjük, töltse le újra az archívumot
RebootPending                             = A számítógép újraindításra vár
UnsupportedRelease                        = Új verzió érhető el
CustomizationWarning                      = \nSzemélyre szabott minden opciót a {0} preset fájlban, mielőtt futtatni kívánja a Sophia szkriptet?
DefenderBroken                            = \nA Microsoft Defender elromlott vagy eltávolították az operációs rendszerből
ControlledFolderAccessDisabled            = Vezérelt mappához való hozzáférés kikapcsolva
ScheduledTasks                            = Ütemezett feladatok
WindowsFeaturesTitle                      = Windows szolgáltatások
OptionalFeaturesTitle                     = Opcionális szolgáltatások
EnableHardwareVT                          = Virtualizáció engedélyezése UEFI-ben
UserShellFolderNotEmpty                   = Néhány fájl maradt a "{0}" könyvtárban. Kérem helyezze át ezeket egy új helyre
RetrievingDrivesList                      = A meghajtók listájának lekérése...
DriveSelect                               = Válassza ki a meghajtó jelét a gyökérkönyvtárban ahol a "{0}" könyvtár létre lesz hozva
CurrentUserFolderLocation                 = Az aktuális "{0}" mappa helye: "{1}"
UserFolderRequest                         = Kívánja megváltoztatni a "{0}" könyvtár helyét?
UserFolderSelect                          = Válasszon ki egy könyvtárat a "{0}" könyvtárhoz
UserDefaultFolder                         = Szeretné visszaállítani a "{0}" könyvtár helyét a gyári értékekre?
GraphicsPerformanceTitle                  = Grafikus teljesítmény tulajdonság
GraphicsPerformanceRequest                = Szeretné megváltoztatni a grafikus teljesítmény beállítást az ön által kiválasztott alkalmazásban "Nagy teljesítményre"?
TaskNotificationTitle                     = Értesítés
CleanupTaskNotificationTitle              = Fontos Információ
CleanupTaskDescription                    = A nem használt Windows fájlok és frissítések eltávolítása a beépített lemezkarbantartó alkalmazással
CleanupTaskNotificationEventTitle         = Szeretné a nem használt fájlokat es frissitéseket eltávolítani?
CleanupTaskNotificationEvent              = A Windows megtisztítása nem tart már sokáig. Legközelebb 30 nap múlva jelenik meg ez a figyelmeztetés
CleanupTaskNotificationSnoozeInterval     = Válasszon ki egy emlékeztető időintervallumot
CleanupNotificationTaskDescription        = Előugró emlékeztető figyelmeztetés a nem használt Windows fájlok és frissítések törléséről
SoftwareDistributionTaskNotificationEvent = A Windows frissités számára fenntartott ideiglenes tárhely sikeresen megtisztítva
TempTaskNotificationEvent                 = Az ideiglenes fájlok tárolására szolgáló könyvtár tisztítása sikeresen megtörtént
FolderTaskDescription                     = A {0} könyvtár tisztítása
EventViewerCustomViewName                 = Folyamatok
EventViewerCustomViewDescription          = Folyamatok létrehozása és parancssor ellenőrző események
RestartWarning                            = Kérem ne felejtse el újraindítani a számítógépét
ErrorsLine                                = Sor
ErrorsFile                                = Fájl
ErrorsMessage                             = Hibák/Figyelmeztetések
Add                                       = Hozzáadás
AllFilesFilter                            = Összes fájl (*.*)|*.*
Browse                                    = Pregledavati
DialogBoxOpening                          = Párbeszédablak megjelenítése...
Disable                                   = Kikapcsolás
Enable                                    = Engedélyezés
EXEFilesFilter                            = *.exe|*.exe|Minden fájl (*.*)|*.*
FolderSelect                              = Válasszon ki egy könyvtárat
FilesWontBeMoved                          = A fájlok nem lesznek áthelyezve
FourHours                                 = 4 óra
HalfHour                                  = 30 perc
Install                                   = Telepítés
Minute                                    = 1 perc
NoData                                    = Nincs megjeleníthető információ
NoInternetConnection                      = Nincs internetkapcsolat
RestartFunction                           = Ponovo pokrenite funkciju "{0}"
NoResponse                                = Nem hozható létre kapcsolat a {0} weboldallal
No                                        = Nem
Yes                                       = Igen
Open                                      = Megnyitás
Patient                                   = Kérem várjon...
Restore                                   = Visszaállítás
Run                                       = Futtatás
SelectAll                                 = Összes kijelölése
Skipped                                   = Átugorva
FileExplorerRestartPrompt                 = \nNéha ahhoz, hogy a módosítások hatályba lépjenek, a File Explorer folyamatot újra kell indítani
TelegramGroupTitle                        = Pridružite se našoj službenoj grupi Telegram
TelegramChannelTitle                      = Pridružite se našem službenom kanalu Telegram
Uninstall                                 = Eltávolít
'@

# SIG # Begin signature block
# MIIbmwYJKoZIhvcNAQcCoIIbjDCCG4gCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUnDvB+3kf2Or0z3WiGmwK9CA3
# koWgghYTMIIDAjCCAeqgAwIBAgIQTi4881vPeZpMOBarbc4BIjANBgkqhkiG9w0B
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
# AgEVMCMGCSqGSIb3DQEJBDEWBBRb3HZObZJ4LiM6cuMzI4LzDjyslDANBgkqhkiG
# 9w0BAQEFAASCAQAG/XwFTxG0v4ylT0+OORYkbe3qpr6mC6xlAqeByzqW80ezUd0x
# LaTZXu21BrRAxYuTR7sc1DfDEJ5Ini9UBhNuIDZ7UH182a20jUbQmSS3783CYKqa
# QtopNliu3jVuGWcUIYsFqg34cXzamXtVsRuXEbpKoXAL6D2ENMrR0vTVd+2L23TV
# mBUu8ha3X9YNnBAyLVxlHgQrsuQMcsDYGRyXrjWf3wm9o2L95BsW73bFZc0iM9VN
# L/OTeq2iKXnYzlfuuo9x70QNBTGvl0E6xXXRGzdhv4TorNFRGtymGN8cxpZYtG5i
# jYAINE1n6M6OxJTLqeO43c9lAtQoM6KdeWwMoYIDIDCCAxwGCSqGSIb3DQEJBjGC
# Aw0wggMJAgEBMHcwYzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJ
# bmMuMTswOQYDVQQDEzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2
# IFRpbWVTdGFtcGluZyBDQQIQCnpKiJ7JmUKQBmM4TYaXnTANBglghkgBZQMEAgEF
# AKBpMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIy
# MDgxMjE5MDk1NVowLwYJKoZIhvcNAQkEMSIEIDP20x6gEYdS9h9w+6aY6XnTVHZc
# fPJE2Bk4JDo0SASeMA0GCSqGSIb3DQEBAQUABIICAHAOI70CwS3aNhcOi9mLRxYu
# xAVqsPcoY0/eo/oiHBUqb5muve8DuXySsniasvvFUm9Q/uL608jiywUa+pdtQBcE
# +xY7bO/Uz9JKKrAkUPoRbmAuLdBxx/urN+2DiyoxppGkxHJB8tyh+oqy5/WII8FD
# Az7FdelqLSG1AN0QSZ1w2wyr+o1g/PeQsAR4h4H/Um6U1GJUi7igGXQRIQEW1nsg
# DGTtABhmcnmlLlmDkD0wubqccJ5yew2PQ5sioyT1VCg5vrM2HML8gl7l7gZnx6PU
# aVZuJMdkUCEVBRMNPYjdty3eBOs9MiwrXj9cOjUXYIsv6N+q9ZsnP3yr5U0U7t/Q
# 0ppRJP819M5ZtM3wNs7gdMBI7Vgxeg83c3BlC+KQrTYTW2NCD4lM1qgoJql6ir/z
# KKbic7azfDk2AUxs2aR07/VmjmRy3AVA2xEi5obf/unwpfhB8tztkzbF/wFZc5QB
# AP6zlJ7POF7IDsRfnr9yBURAzX8L7iRurmS6BlBHpW/DkpOyFuAns1BtoTiIibk+
# u9wjdKppN43uotVYcaAyOH6oAKSvbCcfkRVpvg4MAYIKw9DGee/y2rlOshE33fA6
# 6FB6GVNNlEZYIbt44jAEPW4pMy4ZNbwq2g+k1WoCF78T7Sq0FywZ8UAfL2NxgiuT
# HBN8O5nuu29FciYqHWI5
# SIG # End signature block
