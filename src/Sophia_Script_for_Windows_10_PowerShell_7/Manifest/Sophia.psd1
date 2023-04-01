@{
	RootModule            = '..\Module\Sophia.psm1'
	ModuleVersion         = '5.16.4'
	GUID                  = 'aa0b47a7-1770-4b5d-8c9f-cc6c505bcc7a'
	Author                = 'Dmitry "farag" Nefedov'
	Copyright             = '(c) 2014—2023 farag & Inestic. All rights reserved'
	Description           = 'Module for Windows fine-tuning and automating the routine tasks'
	PowerShellVersion     = '7.3'
	ProcessorArchitecture = 'AMD64'
	FunctionsToExport     = '*'

	PrivateData = @{
		PSData = @{
			LicenseUri    = 'https://github.com/farag2/Sophia-Script-for-Windows/blob/master/LICENSE'
			ProjectUri    = 'https://github.com/farag2/Sophia-Script-for-Windows'
			IconUri       = 'https://raw.githubusercontent.com/farag2/Sophia-Script-for-Windows/master/img/Sophia.png'
			ReleaseNotes  = 'https://github.com/farag2/Sophia-Script-for-Windows/blob/master/CHANGELOG.md'
		}
	}
}
