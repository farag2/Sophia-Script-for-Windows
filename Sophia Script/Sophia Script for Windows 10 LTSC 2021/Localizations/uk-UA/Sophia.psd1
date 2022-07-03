ConvertFrom-StringData -StringData @'
UnsupportedOSBitness                      = Скрипт підтримує тільки Windows 10 x64
UnsupportedOSBuild                        = Скрипт підтримує тільки Windows 10 Enterprise LTSC 2021
UpdateWarning                             = Встановлений зведене оновлення Windows 10: {0}. Підтримуваний накопичувальний пакет оновлення: 1348 і вище
UnsupportedLanguageMode                   = Сесія PowerShell працює в обмеженому режимі
LoggedInUserNotAdmin                      = Поточний увійшов користувач не володіє правами адміністратора
UnsupportedPowerShell                     = Ви намагаєтеся запустити скрипт в PowerShell {0}.{1}. Запустіть скрипт у відповідній версії PowerShell
UnsupportedISE                            = Скрипт не підтримує роботу через Windows PowerShell ISE
Win10TweakerWarning                       = Ваша ОС, можливо, через бекдор в Win 10 Tweaker заражена трояном. Детальніше: https://itnan.ru/post.php?c=1&p=557388
Windows10DebloaterWarning                 = Стабільність вашої ОС могла бути порушена використанням скрипту Windows10Debloater від Sycnex. З метою профілактики перевстановіть ОС
bin                                       = У папці bin немає файлів. Будь ласка, повторно завантажте архів
RebootPending                             = Комп'ютер очікує на перезавантаження
UnsupportedRelease                        = Виявлено нову версію
CustomizationWarning                      = \nВи налаштували всі функції в пресет-файлі {0} перед запуском Sophia Script?
ControlledFolderAccessDisabled            = Контрольований доступ до папок вимкнений
ScheduledTasks                            = Заплановані задачі
WindowsFeaturesTitle                      = Компоненти Windows
OptionalFeaturesTitle                     = Додаткові компоненти
EnableHardwareVT                          = Увімкніть віртуалізацію в UEFI
UserShellFolderNotEmpty                   = У папці "{0}" залишились файли. Перемістіть їх вручну у нове розташування
RetrievingDrivesList                      = Отримання списку дисків...
DriveSelect                               = Виберіть диск, в корні якого буде створена папка для "{0}"
CurrentUserFolderLocation                 = Текуще розташування папок "{0}": "{1}"
UserFolderRequest                         = Хочете змінити розташування папки "{0}"?
UserFolderSelect                          = Виберіть папку для "{0}"
UserDefaultFolder                         = Хочете змінити розташування папки "{0}" на значення за замовчуванням?
ReservedStorageIsInUse                    = Операція не підтримується, поки використовується зарезервоване сховище\nБудь ласка, повторно запустіть функцію "{0}" після перезавантаження
ShortcutPinning                           = Ярлик "{0}" закріплюється на початковому екрані...
GraphicsPerformanceTitle                  = Налаштування продуктивності графіки
GraphicsPerformanceRequest                = Встановити для будь-якої програми за вашим вибором налаштування продуктивності графіки на "Висока продуктивність"?
TaskNotificationTitle                     = Cповіщення
CleanupTaskNotificationTitle              = Важлива інформація
CleanupTaskDescription                    = Очищення зайвих файлів і оновлень Windows, використовуючи вбудовану програму очищення диска
CleanupTaskNotificationEventTitle         = Запустити задачу по очищенню зайвих файлів і оновлень Windows?
CleanupTaskNotificationEvent              = Очищення Windows не займе багато часу. Наступний раз це повідомлення з'явиться через 30 днів
CleanupTaskNotificationSnoozeInterval     = Виберіть інтервал повтору повідомлення
CleanupNotificationTaskDescription        = Спливаюче повідомлення про нагадуванні з очищення зайвих файлів і оновлень Windows
SoftwareDistributionTaskNotificationEvent = Кеш оновлень Windows успішно видалений
TempTaskNotificationEvent                 = Папка тимчасових файлів успішно очищена
FolderTaskDescription                     = Очищення папки "{0}"
EventViewerCustomViewName                 = Створення процесу
EventViewerCustomViewDescription          = Події створення нового процесу і аудит командного рядка
RestartWarning                            = Обов'язково перезавантажте ваш ПК
ErrorsLine                                = Рядок
ErrorsFile                                = Файл
ErrorsMessage                             = Помилки/попередження
Add                                       = Додати
AllFilesFilter                            = Усі файли (*.*)|*.*
Browse                                    = Переглядати
DialogBoxOpening                          = Діалогове вікно відкривається...
Disable                                   = Вимкнути
Enable                                    = Увімкнути
EXEFilesFilter                            = *.exe|*.exe|Усі файли (*.*)|*.*
FolderSelect                              = Виберіть папку
FilesWontBeMoved                          = Файли не будуть перенесені
FourHours                                 = 4 години
HalfHour                                  = 30 хвилин
Install                                   = Встановити
Minute                                    = 1 хвилина
NoData                                    = Відсутні дані
NoInternetConnection                      = Відсутнє інтернет-з'єднання
RestartFunction                           = Будь ласка, повторно запустіть функцію "{0}"
NoResponse                                = Не вдалося встановити зв’язок із {0}
No                                        = Немає
Yes                                       = Так
Open                                      = Відкрити
Patient                                   = Будь ласка, зачекайте...
Restore                                   = Відновити
Run                                       = Запустити
SelectAll                                 = Вибрати все
Skipped                                   = Пропущено
FileExplorerRestartPrompt                 = \nІноді для того, щоб зміни вступили в силу, процес провідника необхідно перезапустити
TelegramGroupTitle                        = Приєднуйтесь до нашої офіційної групи в Telegram
TelegramChannelTitle                      = Приєднуйтесь до нашого офіційного каналу в Telegram
Uninstall                                 = Видалити
'@

# SIG # Begin signature block
# MIIbvwYJKoZIhvcNAQcCoIIbsDCCG6wCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUDXFW6kVPw/alrs+5pQ2tja0t
# eN6gghY3MIIDAjCCAeqgAwIBAgIQTAKXY9arCY5B5sFCEY9uhTANBgkqhkiG9w0B
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
# DQEJBDEWBBS63MfVSejn/NdqrQBaeB/CcYr5/TANBgkqhkiG9w0BAQEFAASCAQAe
# tHXNUYKi03z3MgOxA53GEOj108JtCl8s3ucVRD93RQ8jbJe8JYsCCD/tWuU7uT3w
# SzOU2LnxhYQQVqDxf9yXhyBnI1vVwujMDEsUTd4ozgtcR9WeeNT8iW5SrqoU48HL
# SlOmvPMVBNpEP2kpcB/kxoR88/Vbp2V/WqYws2/xx1A+N7UX1RUy+6AxlTxIbeVZ
# vXDV/Sj1ONHXE3TnMGZ+KBtBsJ15GltSpohM5sps2zT8tG3v7j2Lvq2WudaAnudj
# X9x35LhQPg498/dcDp8QMLsXvq4Mn9qIJNXd987OwfjVnVbqw1BGikrZM4jmiNj9
# sGGS9a9rPTHUdPK8GQu9oYIDIDCCAxwGCSqGSIb3DQEJBjGCAw0wggMJAgEBMHcw
# YzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQD
# EzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGlu
# ZyBDQQIQCnpKiJ7JmUKQBmM4TYaXnTANBglghkgBZQMEAgEFAKBpMBgGCSqGSIb3
# DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDcwMzE4MjM0M1ow
# LwYJKoZIhvcNAQkEMSIEIHHPu670DacVQ2FyGdTlAD90kNPoSz2fQF/PuUoNquoQ
# MA0GCSqGSIb3DQEBAQUABIICABilhseX6IHoQswHCx62kKk+4QTHKRc1otSqStxA
# 0FzT0/lxVCNgDpKeozCf7655ZlnA2LmKfZ53JDpYSWBm2hKMi3s7ePZno8+ExH24
# c77451iBuHNXgle6x9LZ5jDGpzxa61m5fjz4GOwql+a9Ste5EY15Ws5vb0Ji28tU
# gLoowODVqQYLrFNNhn22YFHBZGCM7j5Eq+ds1gNiZcs6KDmEvlIDKv33G8NmYqOv
# XLaZ+JPrjmCfcIkXnzUXH8MvQoX9ZvfgLoplJ8C1vkhiYdn1BWzQ3bYx487S5g7v
# ZmByhQs9cj8/Sf82dhXaJjCDJDMakER0mZX5sfxwJidaLn78/zWgxgxausubuUUU
# bRuxo+/o5gVkCi+/8M5UQyRV2XYuBZ4N+2WgTgHWtUK2hcSZOw25eMQJUZ6JbiUr
# icrheFBuMtOHi10tDetOmKqevUrcdiSFa5xyYInCJLx4AeeSbizTPyvN2sq6Cyxo
# Tk2CkB/YrUAfrVa9FRdiBFWywocCbeXp1FPLAwY7UcFFagUR2eeidjIlBd1zfnCr
# u5wCJZI81+uNyJerd8BKaTu8WQ9SkPtL/i/+gnAIFKGyeqiZ1DWVbO1GJrHTMf27
# cVxKsrZ6Yj1+Hr90tEMs9Y7p4WafW/uZJF5b8j7IbD5wSfA1GfA8YuHvm47c4arg
# mcny
# SIG # End signature block
