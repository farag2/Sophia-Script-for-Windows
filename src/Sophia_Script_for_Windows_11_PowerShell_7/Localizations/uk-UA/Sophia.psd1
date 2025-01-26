﻿ConvertFrom-StringData -StringData @'
UnsupportedOSBuild                        = Скрипт підтримує тільки Windows 11 23H2 і вище. Ваша ОС — {0}.
UnsupportedWindowsTerminal                = Версія Windows Terminal нижча за 1.20. Будь ласка, оновіть його в Microsoft Store і спробуйте заново.
UpdateWarning                             = Ваш білд Windows 11: {0}.{1}. Підтримувані збірки: {2} і вище.. Запустіть Windows Update і повторіть спробу.
UnsupportedLanguageMode                   = Сесія PowerShell працює в обмеженому режимі.
LoggedInUserNotAdmin                      = Поточний користувач, що увійшов, не має прав адміністратора.
UnsupportedPowerShell                     = Ви намагаєтеся запустити скрипт в PowerShell {0}.{1}. Запустіть скрипт у відповідній версії PowerShell.
UnsupportedHost                           = Скрипт не підтримує роботу через {0}.
Win10TweakerWarning                       = Windows була заражена трояном через бекдор у Win 10 Tweaker. Перевстановіть Windows, використовуючи тільки справжній ISO-образ.
TweakerWarning                            = Стабільність вашої ОС могла бути порушена використанням {0}. Перевстановіть Windows, використовуючи тільки справжній ISO-образ.
Bin                                       = У папці "{0}" відсутні файли. Будь ласка, перекачайте архів.
RebootPending                             = Комп'ютер очікує на перезавантаження.
UnsupportedRelease                        = Виявлено нову версію скрипта. Будь ласка, використовуйте тільки останню версію Sophia Script. 
KeyboardArrows                            = Для вибору відповіді використовуйте на клавіатурі стрілки  {0} і {1}
CustomizationWarning                      = Ви налаштували всі функції в пресет-файлі {0} перед запуском Sophia Script?
WindowsComponentBroken                    = {0} пошкоджено або видалено з ОС. Перевстановіть Windows, використовуючи тільки справжній ISO-образ.
MicroSoftStorePowerShellWarning           = PowerShell, завантажений з Microsoft Store, не підтримується. Будь ласка, запустіть MSI-версію.\nhttps://github.com/powershell/powershell/releases/latest
ControlledFolderAccessDisabled            = Контрольований доступ до папок вимкнений.
InitialActionsCheckFailed                 = Функцію InitialActions не можна завантажити з пресет-файлу {0}. Будь ласка, перевірте пресет-файл і спробуйте заново.
ScheduledTasks                            = Заплановані задачі
OneDriveUninstalling                      = Видалення OneDrive...
OneDriveInstalling                        = OneDrive встановлюється...
OneDriveDownloading                       = Завантажується OneDrive...
OneDriveWarning                           = Функція "WinPrtScrFolder -Desktop" буде застосована тільки в разі, якщо користувач налаштував видалення OneDrive (або застосунок уже видалено).\nІнакше ламається функціонал резервного копіювання для папок "Робочий стіл" і "Зображення" в OneDrive.
WindowsFeaturesTitle                      = Компоненти Windows
OptionalFeaturesTitle                     = Додаткові компоненти
EnableHardwareVT                          = Увімкніть віртуалізацію в UEFI.
UserShellFolderNotEmpty                   = У папці "{0}" залишилися файли. Перемістіть їх вручну в нове розташування.
UserFolderLocationMove                    = Не слід переміщати користувацькі папки в корінь диска C.
DriveSelect                               = Виберіть диск, в корні якого буде створена папка для "{0}".
CurrentUserFolderLocation                 = Поточне розташування папки "{0}": "{1}".
UserFolderRequest                         = Бажаєте змінити розташування папки "{0}"?
UserDefaultFolder                         = Бажаєте змінити розташування папки "{0}" на значення за замовчуванням?
ReservedStorageIsInUse                    = Операція не підтримується, поки використовується зарезервоване сховище\nБудь ласка, повторно запустіть функцію "{0}" після перезавантаження.
UninstallUWPForAll                        = Для всіх користувачів
UWPAppsTitle                              = UWP-додатки
GraphicsPerformanceTitle                  = Встановити для будь-якої програми за вашим вибором налаштування продуктивності графіки на "Висока продуктивність"?
ScheduledTaskPresented                    = Функцію "{0}" уже було створено від імені "{1}".
CleanupTaskNotificationTitle              = Очищення Windows
CleanupTaskNotificationEvent              = Запустити завдання з очищення невикористовуваних файлів і оновлень Windows?
CleanupTaskDescription                    = Очищення невикористовуваних файлів і оновлень Windows, використовуючи вбудовану програму Очищення диска. Завдання може бути запущено, тільки якщо користувач "{0}" увійшов у систему.
CleanupNotificationTaskDescription        = Спливаюче повідомлення з нагадуванням про очищення невикористовуваних файлів і оновлень Windows. Завдання може бути запущено, тільки якщо користувач "{0}" увійшов у систему.
SoftwareDistributionTaskNotificationEvent = Кеш оновлень Windows успішно видалено.
TempTaskNotificationEvent                 = Папка тимчасових файлів успішно очищена.
FolderTaskDescription                     = Очищення папки "{0}". Завдання може бути запущено, тільки якщо користувач "{0}" увійшов у систему.
EventViewerCustomViewName                 = Створення процесу
EventViewerCustomViewDescription          = Події створення нового процесу і аудит командного рядка.
RestartWarning                            = Обов'язково перезавантажте ваш ПК.
ErrorsLine                                = Рядок
ErrorsMessage                             = Помилки/попередження
DialogBoxOpening                          = Діалогове вікно відкривається...
Disable                                   = Вимкнути
Enable                                    = Увімкнути
AllFilesFilter                            = Усі файли
FolderSelect                              = Виберіть папку
FilesWontBeMoved                          = Файли не будуть перенесені.
Install                                   = Встановити
Uninstall                                 = Видалити
NoData                                    = Відсутні дані.
RestartFunction                           = Будь ласка, повторно запустіть функцію "{0}".
NoResponse                                = Не вдалося встановити зв’язок із {0}.
Restore                                   = Відновити
Run                                       = Запустити
Skipped                                   = Функцію "{0}" пропущено.
GPOUpdate                                 = Оновлення GPO...
ThankfulToastTitle                        = Дякуємо за використання Sophia Script
DonateToastButton                         = Пожертвувати
'@
