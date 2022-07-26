ConvertFrom-StringData -StringData @'
UnsupportedOSBitness                      = A szkript csak a Windows 10 64 bites verziót támogatja
UnsupportedOSBuild                        = A szkript támogatja a Windows 10 Enterprise LTSC 2021
UpdateWarning                             = A Windows 10 összesített frissítése telepítve: {0}. Támogatott kumulatív frissítés: 1766 és magasabb verziószámok
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
ReservedStorageIsInUse                    = Ez a művelet nem hajtható végre, amíg a fenntartott tárhely használatban van\nPonovno pokrenite funkciju "{0}" nakon ponovnog pokretanja računala
ShortcutPinning                           = A gyorsindító ikon "{0}" Startmenüre helyezése...
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
# MIIbvwYJKoZIhvcNAQcCoIIbsDCCG6wCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUrHYPNzfGh7m+XuVI0xrsHd7/
# mMugghY3MIIDAjCCAeqgAwIBAgIQGSBH1ceugJNJQBs2CFGB8jANBgkqhkiG9w0B
# AQsFADAZMRcwFQYDVQQDDA5Tb3BoaWEgUHJvamVjdDAeFw0yMjA3MjYxOTQ1MjRa
# Fw0yNDA3MjYxOTU1MjRaMBkxFzAVBgNVBAMMDlNvcGhpYSBQcm9qZWN0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1cjscVGXKEfNl8m0K75jJnd0Z0jQ
# T4OWo1g+C4USBBtzOvYaj9t6oQgRwoT627OjU5y0bJBP0e+mgxKn/RYXn5ZVm3dB
# ooqCGC9iEu2ak1pNdyffY7BZjJ3aVl9TLVaUA1joJgEpDFN1yrLt3be2eYcp61PS
# ARCiTH6+EFtX5pkhfhsBfwO8HvmOb5WFcZk1ugZ1MnPf+of8A9OB0I3ZTomUCgOr
# Ou6gDb2TEpjZE1Y7bRt+h3Ocadv3D8wvCvohveRRaAZyswxwe0LvIjGiCxIfeOGC
# 7+Y9WgYqoUcg7sb8eTw88jdNdX1eCgSB3rUJRXgR7JZ076m9idPlySJ5/QIDAQAB
# o0YwRDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0O
# BBYEFN9xgFEiCFjTYHqxP+s5D4Wr6l/+MA0GCSqGSIb3DQEBCwUAA4IBAQAtEBEG
# 3g7vYiCDNM+rar1LMFDit2/wL72ROHc95uEWPnwCfaESh2mERwlvNSCH4xqWzxU9
# px1mpuNzaydnmTXHWC5F11jCX/JxXarI6g4FltKPj6KhPdSsWdeTzcCS3g3KCZIq
# OjA9bGATppUGcb3xYvCbgBta9cGP1NpyHuHkI2ajKs4BFaPq6T7UN1IqhVHAntAG
# SkfxKPt4lMY+MCHQWJgQCVx7D/nDenyCG+8D6HMYwsVH1PI4L7EkulsNuCDEvNB6
# EMmwPCsdGTdc7W+Xef/Fd6Ma4ZRmr3VR5Cf/wMOsXwmFG7f4rjAyNfWNQEybNj8I
# K0WSXnOEAqNTDTfgMIIFsTCCBJmgAwIBAgIQASQK+x44C4oW8UtxnfTTwDANBgkq
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
# BgNVBAMMDlNvcGhpYSBQcm9qZWN0AhAZIEfVx66Ak0lAGzYIUYHyMAkGBSsOAwIa
# BQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgor
# BgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3
# DQEJBDEWBBSV2dXf5d63AUX53YzqF+0m+AtTUDANBgkqhkiG9w0BAQEFAASCAQCZ
# i2KfERsdfnAAdRs3QQKOcngh6KmY90fdEUz3DH2Lebx3JjibSRAXkng1CC9hoIVd
# SNHNpKOGowktsF6N4g/e6xN/pd/q0PpgwRYAtUxTM3l1VLeOVi9n9mFHM4PiA6nm
# Sr0l7LdMblZTH063WXFRIfc02sk68ffGYq0r0XLY6WTw5UXHJpiwZ+H/Pp0OpWeW
# VvLAIqlyQ2stMw5QUf4fGamdD//edX9Pr7c7oqS8XXhpPbQEpkUVmpQBbhUGg9HB
# IHgYHcRVJDEj5zZTbrrJx1loM8H8+V6Px/+iCepfmRpmBkWic9Le/EUDfWtDD295
# Ytw5XCy+ypDwRKRZ85RRoYIDIDCCAxwGCSqGSIb3DQEJBjGCAw0wggMJAgEBMHcw
# YzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQD
# EzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGlu
# ZyBDQQIQCnpKiJ7JmUKQBmM4TYaXnTANBglghkgBZQMEAgEFAKBpMBgGCSqGSIb3
# DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDcyNjE5NTUzNFow
# LwYJKoZIhvcNAQkEMSIEIAFc8gzEY3dZVDE8OkqMtAOnIG6TOokxvf76lYFSfYog
# MA0GCSqGSIb3DQEBAQUABIICAFK3g4ClrlyywpDYcIufShLhmk/p9bv3u9/wHGSt
# szaJHkFZ0P/5Mzlf92mYFdoHYc8mhzXhscoCepnrln55G+r5tUOf8CkU8gclGzA5
# bxyoL5dlO487j+sB/h1FTZRlr9QjteJ6jnDKndXHSFQiO1sL4KSAA22RXvUP0Rrd
# +OAk0xJW4gl4DjgmsKOTid6+ctULXc5+5mcbIyE7PrC+MGfELArgs/kS6hnJjD59
# lM0RDthS49nFIYzH6W85FLhtoSfPhLwdrSiZFJWJwuOpfbE3+HMjVsHZCVww95l1
# 2SPXXJtcYdNM11sQauYKgLSAiBxEA19br/hcaqfz3sj5tIpNQsPjHBvW8+758EYM
# L1cyVTnZ7ibnaMJE3xyB04jn8OKxXOmJOtqDF5sSBIWqJmfnb299xFntK96UfHdA
# pf30SX53AzDfO6/8loBGdXq/4zocQoHwGq9zMVwcoQhZQKnIuoXbkjxbOuLbGfHO
# WHEM6ArxIKS4aRSBoWG9us1uJLh0Bk01GshnTtvWabShATyCm+qpXRP9jw4B+C4w
# hNX/jwjS2AEJRbKDZuBr/otQ5dqPC6/EkWpB35vx9zCqkABwkSmZA4ECJdT2NIoP
# ubChAk0vvIR8stSLr4BEmzYE1LWM96kDBO6U7K2/prbgGbpQ0mK8vyrsO3pplZcI
# /iOQ
# SIG # End signature block
