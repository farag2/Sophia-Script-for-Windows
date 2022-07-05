ConvertFrom-StringData -StringData @'
UnsupportedOSBuild                        = Скрипт поддерживает только Windows 11 21H2 и выше
UpdateWarning                             = Ваш билд Windows 11: {0}.{1}. Поддерживаемые сборки: 22000.739, 22509 и выше
UnsupportedLanguageMode                   = Сессия PowerShell работает в ограниченном режиме
LoggedInUserNotAdmin                      = Текущий вошедший пользователь не обладает правами администратора
UnsupportedPowerShell                     = Вы пытаетесь запустить скрипт в PowerShell {0}.{1}. Запустите скрипт в соответствующей версии PowerShell
UnsupportedISE                            = Скрипт не поддерживает работу через Windows PowerShell ISE
Win10TweakerWarning                       = Ваша ОС, возможно, через бэкдор в Win 10 Tweaker была заражена трояном. Подробнее: https://itnan.ru/post.php?c=1&p=557388
Windows10DebloaterWarning                 = Стабильность Вашей ОС могла быть нарушена использованием скрипта Windows10Debloater от Sycnex. В целях профилактики переустановите ОС
bin                                       = В папке bin отсутствутствуют файлы. Пожалуйста, перекачайте архив
RebootPending                             = Компьютер ожидает перезагрузки
UnsupportedRelease                        = Обнаружена новая версия
CustomizationWarning                      = \nВы настроили все функции в пресет-файле {0} перед запуском Sophia Script?
ControlledFolderAccessDisabled            = Контролируемый доступ к папкам выключен
ScheduledTasks                            = Запланированные задания
OneDriveUninstalling                      = Удаление OneDrive...
OneDriveInstalling                        = OneDrive устанавливается...
OneDriveDownloading                       = Скачивается OneDrive... ~33 МБ
OneDriveWarning                           = Функция "{0}" будет применена только в случае, если в пресете настроено удаление OneDrive (или приложение уже удалено), иначе ломается функционал резервного копирования для папок "Рабочий стол" и "Изображения" в OneDrive
WindowsFeaturesTitle                      = Компоненты Windows
OptionalFeaturesTitle                     = Дополнительные компоненты
EnableHardwareVT                          = Включите виртуализацию в UEFI
OpenInWindowsTerminalAdmin                = Открыть в Терминале Windows
UserShellFolderNotEmpty                   = В папке "{0}" остались файлы. Переместите их вручную в новое расположение
RetrievingDrivesList                      = Получение списка дисков...
DriveSelect                               = Выберите диск, в корне которого будет создана папка "{0}"
CurrentUserFolderLocation                 = Текущее расположение папки "{0}": "{1}"
UserFolderRequest                         = Хотите изменить расположение папки "{0}"?
UserFolderSelect                          = Выберите папку для "{0}"
UserDefaultFolder                         = Хотите изменить расположение папки "{0}" на значение по умолчанию?
ReservedStorageIsInUse                    = Операция не поддерживается, пока используется зарезервированное хранилище\nПожалуйста, повторно запустите функцию "{0}" после перезагрузки
ShortcutPinning                           = Ярлык "{0}" закрепляется на начальном экране...
UninstallUWPForAll                        = Для всех пользователей
UWPAppsTitle                              = UWP-приложения
HEVCDownloading                           = Скачивается расширения для видео HEVC от производителя устройства... ~2,8 МБ
GraphicsPerformanceTitle                  = Настройка производительности графики
GraphicsPerformanceRequest                = Установить для любого приложения по вашему выбору настройки производительности графики на "Высокая производительность"?
TaskNotificationTitle                     = Уведомление
CleanupTaskNotificationTitle              = Важная информация
CleanupTaskDescription                    = Очистка неиспользуемых файлов и обновлений Windows, используя встроенную программу Очистка диска
CleanupTaskNotificationEventTitle         = Запустить задачу по очистке неиспользуемых файлов и обновлений Windows?
CleanupTaskNotificationEvent              = Очистка Windows не займет много времени. Следующий раз это уведомление появится через 30 дней
CleanupTaskNotificationSnoozeInterval     = Выберите интервал повтора уведомления
CleanupNotificationTaskDescription        = Всплывающее уведомление с напоминанием об очистке неиспользуемых файлов и обновлений Windows
SoftwareDistributionTaskNotificationEvent = Кэш обновлений Windows успешно удален
TempTaskNotificationEvent                 = Папка временных файлов успешно очищена
FolderTaskDescription                     = Очистка папки {0}
EventViewerCustomViewName                 = Создание процесса
EventViewerCustomViewDescription          = События содания нового процесса и аудит командной строки
RestartWarning                            = Обязательно перезагрузите ваш ПК
ErrorsLine                                = Строка
ErrorsFile                                = Файл
ErrorsMessage                             = Ошибки/предупреждения
Add                                       = Добавить
AllFilesFilter                            = Все файлы (*.*)|*.*
Browse                                    = Обзор
DialogBoxOpening                          = Диалоговое окно открывается...
Disable                                   = Отключить
Enable                                    = Включить
EXEFilesFilter                            = *.exe|*.exe|Все файлы (*.*)|*.*
FolderSelect                              = Выберите папку
FilesWontBeMoved                          = Файлы не будут перенесены
FourHours                                 = 4 часа
HalfHour                                  = 30 минут
Install                                   = Установить
Minute                                    = 1 минута
NoData                                    = Отсутствуют данные
NoInternetConnection                      = Отсутствует интернет-соединение
RestartFunction                           = Пожалуйста, повторно запустите функцию "{0}"
NoResponse                                = Невозможно установить соединение с {0}
No                                        = Нет
Yes                                       = Да
Open                                      = Открыть
Patient                                   = Пожалуйста, подождите...
Restore                                   = Восстановить
Run                                       = Запустить
SelectAll                                 = Выбрать всё
Skipped                                   = Пропущено
FileExplorerRestartPrompt                 = \nИногда для того, чтобы изменения вступили в силу, процесс проводника необходимо перезапустить
TelegramGroupTitle                        = Присоединяйтесь к нашей официальной группе в Telegram
TelegramChannelTitle                      = Присоединяйтесь к нашему официальному каналу в Telegram
Uninstall                                 = Удалить
'@

# SIG # Begin signature block
# MIIbvwYJKoZIhvcNAQcCoIIbsDCCG6wCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU/9mmf1Po58kdNke8TSvnytZd
# P1SgghY3MIIDAjCCAeqgAwIBAgIQJleuSBzbO6BKj4tITuy73DANBgkqhkiG9w0B
# AQsFADAZMRcwFQYDVQQDDA5Tb3BoaWEgUHJvamVjdDAeFw0yMjA3MDUyMTM2Mzla
# Fw0yNDA3MDUyMTQ2MzlaMBkxFzAVBgNVBAMMDlNvcGhpYSBQcm9qZWN0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtLryHEs3RXTUcHI/12bpCYscds1j
# 1dQzO8Rq9IJLdU1Uv99J8O1pOC6O/nXL7BjhBzdMijh3gYHe9L9rDANgsk03zZWb
# ZIu37+7Rd8V7bkIpeHugeyxEtRiKTIF5B8WG7Gg+gAtsLUPWmkjfEK8hY1+Pwly0
# pqz/fIjOn7xm76sI+/A9+5JvDXxUMlH6fUySLpdwe6/Uf1R7UkscmG1SQlkfNAhs
# uTvXdtILSuneG5UAtC66MiOPNx6HnDntmt4In2B6UEyEXAhPlbZmPWRKcklFRaFv
# ZOsvUcIXRzXwf/o7C0C/SjTDIIvvO5A1xNHEBKmvALQ/MfqIZo8DO+xAvQIDAQAB
# o0YwRDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwHQYDVR0O
# BBYEFJCvnIKyGN8JJ0PdY41rLGlnKpw5MA0GCSqGSIb3DQEBCwUAA4IBAQCJzBTt
# MyUxzfIDFCjD0Z9dtF9Qr4tNz19+XM6mlrjFw7Q32B1nCI42vYEtHbX8s5kZSJN8
# 20JKIR6HuECjbRdtTslEHN5oPMMNd9jsqpheVlEcAn3u/VDxh7MJQocxhQyDp2Gm
# /ihlTmhXTPWaTXaIlD9Y3sUALAUiVRZuJ9bipwvaRsvn5ISi3db63SxKfdNuhUX6
# UmHQHegohrfioOq7rtAIolfvf8phg+oZ++t7fQOo6aSaowuSHxOOSRQ4J2wjpB2t
# hyAx4Y4+NE/VACR629qWBAXOIwD5LyDhAaLvAgjjeKKchzCS2C7M+J+OiwUxvAEE
# a4qX0OA77xC44aXdMIIFsTCCBJmgAwIBAgIQASQK+x44C4oW8UtxnfTTwDANBgkq
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
# BgNVBAMMDlNvcGhpYSBQcm9qZWN0AhAmV65IHNs7oEqPi0hO7LvcMAkGBSsOAwIa
# BQCgeDAYBgorBgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgor
# BgEEAYI3AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3
# DQEJBDEWBBQsiMiK57LSrnKg7t7zCcGX6pgnyDANBgkqhkiG9w0BAQEFAASCAQAE
# xRccbcVhbhH2jJJI4ZtyJ3DZ5lIaui20DD/F1dWgVR+KAkpY5W+ToV4mkfqlvYcB
# 7DRdQhoDO7rbeSrlvIohgMYeW3iGWq/2tTazAf4N+K5NuV8kLvlADIcSR/y5rjQ6
# eOLSMEiMBcpiZDOI31avUiYWEUFqXAo9i5XvKG9sFak58UuV9w5YDu4uukmzLjyS
# GARJXSEIEf7iE99S+fgQ+Dtunr17ojBgLTasEFF01h9tU02Z+JAWHEdLaD/ncuOb
# Wg4VeOTR6oMn7ZystRBLJPObbG3rRuKDif1GYygvI8H5neLhqIBco4bIZTJ2JdO3
# tZ6IBBZDpq/ivVP6uvL2oYIDIDCCAxwGCSqGSIb3DQEJBjGCAw0wggMJAgEBMHcw
# YzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQD
# EzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGlu
# ZyBDQQIQCnpKiJ7JmUKQBmM4TYaXnTANBglghkgBZQMEAgEFAKBpMBgGCSqGSIb3
# DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDcwNTIxNDY0OVow
# LwYJKoZIhvcNAQkEMSIEIPNREIcCXinV/pgmkcnARLNrz/ZyCIET8Sh9R+yQ1fkB
# MA0GCSqGSIb3DQEBAQUABIICAEs4gRtHHtfRWlGQIWqEdySWZSJtCF5khdmg2tMX
# aR8nI8vGpnRJei7fpMXAeQjKxiTl9wEWftxr778lC3DDyARKYDV2gUVyflyu4ZVh
# wjjQW5RTA42fub+feEX3kCT5jH9NWmTjuOeqBNjUMURQZLJ6zl9iVYVrLqgoHCY8
# 9CKvZnDP+GVTue3+DI7H8MkBemW1rP7Fx30nzZmzfsJ4ox0Z/lFzBUM6dtopailE
# fS6jhgtP3xTQwetRTaKIeTiw/p6ERTHv+H63lAkiOj47ZUMUjcFeqWZw/R+2qblR
# uaY+WIbrz6vh3YCB8rM6P34QZJlL/4vzg5i6q0/MRA+gKuH7IAwcM0Ysc+XmRkJ/
# L1CppBhU/SYfdO8lBrET03waWYOPJzLYXLjqjJBQUsJdJmH5lSgEMW2DhGqoJSLK
# iTrf1d2HwfER1z0T2/UYGeHTbKeHxI3eaiLEA11XyB0gV7hxu/HNFqWaUtUiW1fF
# iiF2QqqzRU+/uyw/rAM/cJ6Km3AabM+tsqsQs76NcXx91BpzFvDfXG1nUXCa2vNV
# Zk22WSAEW6Z9t6D1r4lnaponcn/hwr1xtYQ4mgN0sJCjrprRzLpMpDkoIlqtvV2N
# Yv1rk6SBRgsa1iMAPr0Jo4c81cv4PqwxhI9k+gogUIPu668e+bMLgawZ/sl2rp/M
# zHXS
# SIG # End signature block
