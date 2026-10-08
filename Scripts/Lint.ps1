# Check module

Write-Verbose -Message "PowerShell ScriptAnalyzer" -Verbose

$Results = @(Get-ChildItem -Path src -File -Recurse -Include *.ps1, *.psm1 | Invoke-ScriptAnalyzer)
if ($Results | Where-Object -FilterScript {($_.Severity -eq "Error") -or ($_.Severity -eq "ParseError")})
{
	Write-Verbose -Message "Found script issue" -Verbose

	$Results | Where-Object -FilterScript {($_.Severity -eq "Error") -or ($_.Severity -eq "ParseError")} | ForEach-Object -Process {
	[PSCustomObject]@{
		Line    = $_.Line
		Message = $_.Message
		Path    = $_.ScriptPath
	}
	} | Format-Table -AutoSize -Wrap

	# Exit with a non-zero status to fail the job
	exit 1
}

Write-Verbose -Message "JSONs validity" -Verbose

# Check JSONs
$JSONs = [Array]::TrueForAll((@(Get-ChildItem -Path Wrapper -File -Recurse -Filter *.json).FullName),
[Predicate[string]]{
	param($JSON)

	Test-Json -Path $JSON -ErrorAction Ignore
})
if (-not $JSONs)
{
	Write-Verbose -Message "Found JSON issue" -Verbose
	# Exit with a non-zero status to fail the job
	exit 1
}

Write-Verbose -Message "Check psd1 files" -Verbose

# Check psd1 files
function Parse-PSD1
{
	[CmdletBinding()]
	param
	(
		[Microsoft.PowerShell.DesiredStateConfiguration.ArgumentToConfigurationDataTransformation()]
		[hashtable]
		$Path
	)

	return $Path
}

Get-ChildItem -Path src -File -Filter *.psd1 -Recurse | ForEach-Object -Process {
	# try/catch expects for $Error variable
	$File = $_.FullName

	try
	{
		Parse-PSD1 -Path $_.FullName -ErrorAction Stop | Out-Null
	}
	catch
	{
		Write-Verbose -Message $File -Verbose
		# Exit with a non-zero status to fail the job
		exit 1
	}
}

Write-Verbose -Message "Localizations integrity" -Verbose

foreach ($Folder in @(Get-ChildItem -Path src -Directory))
{
	# Read all scripts once per folder
	$Content = Get-ChildItem -Path $Folder.FullName -Include *.ps1, *.psm1 -Recurse -File | Get-Content -Raw

	foreach ($Locale in @(Get-ChildItem -Path "$($Folder.FullName)\Module\Localizations" -Directory))
	{
		Import-LocalizedData -BindingVariable Localization -UICulture $Locale.Name -BaseDirectory "$($Folder.FullName)\Module\Localizations" -FileName Sophia

		foreach ($Key in $Localization.Keys)
		{
			# "\b" prevents "Enable" from matching "EnableSecureBoot"
			if (-not ($Content -cmatch "Localization\.$Key\b"))
			{
				Write-Verbose -Message "$($Locale.FullName)\Sophia.psd1 is not used in $($Folder.Name)" -Verbose

				$Failed = $true
			}
		}
	}
}

if ($Failed)
{
	# Exit with a non-zero status to fail the job
	exit 1
}

Write-Verbose -Message "Localizations integrity within psm1 modules" -Verbose

# Check that every $Localization.Key used in the code exists in all localization files of the same edition
$Problems = [System.Collections.Generic.List[object]]::new()

foreach ($Edition in (Get-ChildItem -Path src -Directory))
{
	# Code files of the edition: Sophia.psm1, private functions, the preset and Import-TabCompletion.ps1
	$CodeFiles = Get-ChildItem -Path $Edition.FullName -Recurse -File -Include *.ps1, *.psm1

	# Find $Localization.Key and $Global:Localization.Key with the PowerShell parser, so that commented code isn't counted
	$UsedKeys = foreach ($CodeFile in $CodeFiles)
	{
		$ParseErrors = $null
		$Ast = [System.Management.Automation.Language.Parser]::ParseFile($CodeFile.FullName, [ref]$null, [ref]$ParseErrors)

		# A file with syntax errors may be parsed only partially, so its keys may be missed
		foreach ($ParseError in $ParseErrors)
		{
			$Problems.Add([PSCustomObject]@{
				"Full Path"     = $CodeFile.FullName
				Key             = "<syntax error> $($ParseError.Message)"
				"String Number" = $ParseError.Extent.StartLineNumber
				"Missing In"    = $null
			})
		}

		$Ast.FindAll({
			param
			(
				$Node
			)

			# VariablePath.UnqualifiedPath is internal in Windows PowerShell 5.1 and always returns $null, so the public UserPath is used
			# UserPath is the variable name as written in the code: "Localization" or "Global:Localization"
			($Node -is [System.Management.Automation.Language.MemberExpressionAst]) -and
			($Node.Expression -is [System.Management.Automation.Language.VariableExpressionAst]) -and
			($Node.Expression.VariablePath.UserPath -in @("Localization", "Global:Localization")) -and
			($Node.Member -is [System.Management.Automation.Language.StringConstantExpressionAst])
		}, $true) | ForEach-Object -Process {
			[PSCustomObject]@{
				Key  = $_.Member.Value
				File = $CodeFile.FullName
				Line = $_.Extent.StartLineNumber
			}
		}
	}

	# Missing key and the list of languages, where it's missing
	$MissingIn = @{}

	$LocalizationsPath = Join-Path -Path $Edition.FullName -ChildPath Module\Localizations
	$LanguageFolders = @(Get-ChildItem -Path $LocalizationsPath -Directory)
	foreach ($Language in $LanguageFolders)
	{
		# Load the file the same way the script does, so that syntax errors in it are found too
		try
		{
			Import-LocalizedData -BindingVariable Strings -BaseDirectory $LocalizationsPath -UICulture $Language.Name -FileName Sophia -ErrorAction Stop
		}
		catch
		{
			$Problems.Add([PSCustomObject]@{
				"Full Path"     = (Join-Path -Path $Language.FullName -ChildPath Sophia.psd1)
				Key             = "<file can't be loaded> $($_.Exception.Message)"
				# The line isn't known, $null keeps sorting by numbers working
				"String Number" = $null
				"Missing In"    = $Language.Name
			})

			continue
		}

		foreach ($UsedKey in $UsedKeys)
		{
			if (-not $Strings.ContainsKey($UsedKey.Key))
			{
				if (-not $MissingIn.ContainsKey($UsedKey.Key))
				{
					$MissingIn[$UsedKey.Key] = [System.Collections.Generic.List[string]]::new()
				}

				# A key may be used in several places, so the language is added once
				if (-not $MissingIn[$UsedKey.Key].Contains($Language.Name))
				{
					$MissingIn[$UsedKey.Key].Add($Language.Name)
				}
			}
		}
	}

	# One row per file and missing key, with all line numbers of the key in this file in one cell
	$UsedKeys | Where-Object -FilterScript {$MissingIn.ContainsKey($_.Key)} | Group-Object -Property File, Key | ForEach-Object -Process {
		$Key = $_.Group[0].Key

		# "All" instead of the list of all 12 languages keeps the table narrow
		if ($MissingIn[$Key].Count -eq $LanguageFolders.Count)
		{
			$MissingInLanguages = "All"
		}
		else
		{
			$MissingInLanguages = $MissingIn[$Key] -join ", "
		}

		$Problems.Add([PSCustomObject]@{
			"Full Path"     = $_.Group[0].File
			Key             = $Key
			"String Number" = (($_.Group.Line | Sort-Object -Unique) -join ", ")
			"Missing In"    = $MissingInLanguages
		})
	}
}

if ($Problems)
{
	# Sort by the first line number as a number, as "String Number" may contain several numbers, e.g. "6966, 6967"
	$FirstLineNumber = {
		if ($null -eq $_."String Number")
		{
			0
		}
		else
		{
			[int]("$($_."String Number")".Split(",")[0])
		}
	}
	$Problems | Sort-Object -Property "Full Path", $FirstLineNumber | Format-Table -AutoSize -Wrap

	exit 1
}
else
{
	Write-Verbose -Message "All localization keys used in the code exist in all localization files" -Verbose
}