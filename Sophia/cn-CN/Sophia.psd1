# Do not remove double quotes in double-quoted strings where they are present

ConvertFrom-StringData -StringData @'
UnsupportedOSBitness = 本脚本仅支持 Windows 10 x64
ControlledFolderAccessDisabled = 关闭受控文件夹访问权限

# OneDrive
OneDriveUninstalling = 卸载OneDrive...
OneDriveNotEmptyFolder = "$OneDriveUserFolder 不是一个空文件夹.请手动删除"
OneDriveFileSyncShell64dllBlocked = "$FileSyncShell64dll 访问被拒绝.请手动删除"
OneDriveInstalling = OneDriveSetup.exe 正在启动...
OneDriveDownloading = 正在下载OneDrive... ~33 MB
OneDriveNoInternetConnection = 无网络连接

# TempPath
LOCALAPPDATAFilesBlocked = "The following files are being blocked by third-party party apps `nRemove them manually and continue"
LOCALAPPDATANotEmpty = "$env:LOCALAPPDATA\\Temp 不是一个空文件夹.请手动删除并重试"

# DisableWindowsCapabilities
FODWindowTitle = 移除可选功能 (FODv2)
FODWindowButton = 卸载
DialogBoxOpening = 显示对话窗口...
NoData = 无数据

# WindowsSandbox
EnableHardwareVT = UEFI中开启虚拟化

# ChangeUserShellFolderLocation
UserShellFolderNotEmpty = "一些文件留在了$UserShellFolderRegValue 文件夹.请手动将它们移到一个新位置"
RetrievingDrivesList = 取得驱动器列表...
# Desktop
DesktopDriveSelect = 请选择一个驱动器,桌面文件夹将创建在其根目录
DesktopFilesWontBeMoved = 文件将不会被移动
DesktopFolderRequest = 是否要更改桌面文件夹位置?
DesktopFolderChange = 更改
DesktopFolderSkip = 跳过
DesktopSkipped = 已跳过
# Documents
DocumentsDriveSelect = 请选择一个驱动器,文档文件夹将创建在其根目录
DocumentsFilesWontBeMoved = 文件将不会被移动
DocumentsFolderRequest = 是否要更改文档文件夹位置?
DocumentsFolderChange = 更改
DocumentsFolderSkip = 跳过
DocumentsSkipped = 已跳过
# Downloads
DownloadsDriveSelect = 请选择一个驱动器,下载文件夹将创建在其根目录
DownloadsFilesWontBeMoved = 文件将不会被移动
DownloadsFolderRequest = 是否要更改下载文件夹位置?
DownloadsFolderChange = 更改
DownloadsFolderSkip = 跳过
DownloadsSkipped = 已跳过
# Music
MusicDriveSelect = 请选择一个驱动器,音乐文件夹将创建在其根目录
MusicFilesWontBeMoved = 文件将不会被移动
MusicFolderRequest = 是否要更改音乐文件夹位置?
MusicFolderChange = 更改
MusicFolderSkip = 跳过
MusicSkipped = 已跳过
# Pictures
PicturesDriveSelect = 请选择一个驱动器,图片文件夹将创建在其根目录
PicturesFilesWontBeMoved = 文件将不会被移动
PicturesFolderRequest = 是否要更改图片文件夹位置?
PicturesFolderChange = 更改
PicturesFolderSkip = 跳过
PicturesSkipped = 已跳过
# Videos
VideosDriveSelect = 请选择一个驱动器,视频文件夹将创建在其根目录
VideosFilesWontBeMoved = 文件将不会被移动
VideosFolderRequest = 是否要更改视频文件夹位置?
VideosFolderChange = 更改
VideosFolderSkip = 跳过
VideosSkipped = 已跳过

# SetDefaultUserShellFolderLocation
# Desktop
DesktopDefaultFolder = 是否要将桌面文件夹位置改为默认值?
# Documents
DocumentsDefaultFolder = 是否要将文档文件夹位置改为默认值?
# Downloads
DownloadsDefaultFolder = 是否要将下载文件夹位置改为默认值?
# Music
MusicDefaultFolder = 是否要将音乐文件夹位置改为默认值?
# Pictures
PicturesDefaultFolder = 是否要将图片文件夹位置改为默认值?
# Videos
VideosDefaultFolder = 是否要将视频文件夹位置改为默认值?

# ReservedStorage
ReservedStorageIsInUse = 保留存储空间正在使用时不支持此操作. 请等待所有服务操作完成后再重试

# syspin
syspinNoInternetConnection = 无网络连接
syspinDownloading = syspin下载中... ~20 KB

# PinControlPanel/PinDevicesPrinters/PinCommandPrompt
ControlPanelPinning = "$ControlPanelLocalizedName 快捷方式将被固定到开始菜单"
DevicesPrintersPinning = "$DevicesAndPrintersLocalizedName 快捷方式将被固定到开始菜单"
CMDPinning = CMD快捷方式将被固定到开始菜单

# UninstallUWPApps
UninstallUWPForAll = 为所有用户卸载
UninstallUWPTitle = 需要卸载的UWP应用
UninstallUWPUninstallButton = 卸载

# WSL
WSLUpdateDownloading = Linux内核更新包下载中... ~14 MB
WSLUpdateInstalling = 安装Linux内核更新包...

# SetAppGraphicsPerformance
GraphicsPerformanceTitle = 图形性能偏好
GraphicsPerformanceRequest = 是否将所选应用程序的图形性能设置设为"高性能"?
GraphicsPerformanceAdd = 添加
GraphicsPerformanceSkip = 跳过
GraphicsPerformanceFilter = *.exe|*.exe|所有文件 (*.*)|*.*
GraphicsPerformanceSkipped = 已跳过

# CreateCleanUpTask
CleanUpTaskToast = 将在一分钟内清理未使用的Windows文件和更新
CleanUpTaskDescription = 使用内置磁盘清理工具清理未使用的Windows文件和更新. 要想解码已编码命令,使用 [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("string"))

# CreateSoftwareDistributionTask
SoftwareDistributionTaskDescription = 定时清理 %SystemRoot%\\SoftwareDistribution\\Download

# CreateTempTask
TempTaskDescription = 清理%TEMP%文件夹

# AddProtectedFolders
AddProtectedFoldersTitle = 受控文件夹访问权限
AddProtectedFoldersRequest = 是否启用受控文件夹访问权限并指定文件夹,由微软Defender保护其免受恶意应用程序威胁?
AddProtectedFoldersAdd = 添加
AddProtectedFoldersSkip = 跳过
AddProtectedFoldersDescription = 选择一个文件夹
AddProtectedFoldersSkipped = 已跳过

# RemoveProtectedFolders
RemoveProtectedFoldersList = 已被移除的文件夹

# AddAppControlledFolder
AddAppControlledFolderTitle = 添加应用获取受控文件夹访问权限
AddAppControlledFolderRequest = 是否指定应用获取受控文件夹访问权限?
AddAppControlledFolderAdd = 添加
AddAppControlledFolderSkip = 跳过
AddAppControlledFolderFilter = *.exe|*.exe|所有文件 (*.*)|*.*
AddAppControlledFolderSkipped = 已跳过

# RemoveAllowedAppsControlledFolder
RemoveAllowedAppsControlledFolderList = 移除已授权应用

# AddDefenderExclusionFolder
AddDefenderExclusionFolderTitle = Microsoft Defender
AddDefenderExclusionFolderRequest = 是否要添加指定文件夹到微软Defender的恶意软件扫描白名单?
AddDefenderExclusionFolderAdd = 添加
AddDefenderExclusionFolderSkip = 跳过
AddDefenderExclusionFolderDescription = 请选择一个文件夹
AddDefenderExclusionFolderSkipped = 已跳过

# RemoveDefenderExclusionFolders
RemoveDefenderExclusionFoldersList = 已被移除白名单的文件夹

# AddDefenderExclusionFile
AddDefenderExclusionFileTitle = Microsoft Defender
AddDefenderExclusionFileRequest = 是否要添加指定文件到微软Defender的恶意软件扫描白名单?
AddDefenderExclusionFileAdd = 添加
AddDefenderExclusionFileSkip = 跳过
AddDefenderExclusionFileFilter = 所有文件 (*.*)|*.*
AddDefenderExclusionFileSkipped = 已跳过

# RemoveDefenderExclusionFiles
RemoveDefenderExclusionFilesList = 已被移除白名单的文件

# CreateEventViewerCustomView
EventViewerCustomViewName = 进程创建
EventViewerCustomViewDescription = 进程创建和命令行审核事件

# Refresh
RestartWarning = 重启电脑

# Errors
ErrorsLine = 行
ErrorsFile = 文件
ErrorsMessage = 错误/警告
'@
