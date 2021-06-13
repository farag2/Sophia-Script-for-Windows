@{
	RootModule            = '..\Module\Sophia.psm1'
	ModuleVersion         = '5.2.7'
	GUID                  = 'a36a65ca-70f9-43df-856c-3048fc5e7f01'
	Author                = 'Dmitry "farag" Nefedov'
	Copyright             = '(c) 2014–2021 farag & Inestic. All rights reserved'
	Description           = 'Module for Windows 10 fine-tuning and automating the routine tasks'
	PowerShellVersion     = '5.1'
	ProcessorArchitecture = 'AMD64'
	FunctionsToExport     = '*'

	PrivateData = @{
		PSData = @{
			LicenseUri    = 'https://github.com/farag2/Windows-10-Sophia-Script/blob/master/LICENSE'
			ProjectUri    = 'https://github.com/farag2/Windows-10-Sophia-Script'
			IconUri       = 'https://raw.githubusercontent.com/farag2/Windows-10-Sophia-Script/master/img/Sophia.png'
			ReleaseNotes  = 'https://github.com/farag2/Windows-10-Sophia-Script/blob/master/CHANGELOG.md'
		}
	}
}
