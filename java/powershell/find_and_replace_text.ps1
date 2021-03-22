<#
file_name = find_and_replace_text.ps1
.SYNOPSIS
    .
.DESCRIPTION
    .
.PARAMETER SearchPath
    The path to search for files.
.PARAMETER LogName
	The name of the file which will be used to logging.
.PARAMETER BackupFolder
	The file path and name of backup folder location where
	copies of files will be placed prior to modifying.
.PARAMETER SearchString
	The string to search for in all files.
.PARAMETER ReplaceString
	The string that will replace the SearchString parameter.
.EXAMPLE
	C:\PS> .\find_and_replace_text.ps1 'C:\creativeFolder' 'C:\creativeFolder.log' 'C:\creativeFolderBackup'
	
	dos prompt
	powershell -ExecutionPolicy Bypass "C:\Temp\find_and_replace_text.ps1 'C:\Temp\creativeFolder' 'C:\Temp\creativeFolder.log' 'C:\Temp\creativeFolderBackup'"
	
	D:\Hung\Work\PowerShell
	dos prompt
	powershell -ExecutionPolicy Bypass "D:\Hung\Work\PowerShell\find_and_replace_text.ps1 'D:\Hung\Work\PowerShell\creativeFolder' 'D:\Hung\Work\PowerShell\creativeFolder.log' 'D:\Hung\Work\PowerShell\creativeFolderBackup'"
#>
param (
	[Parameter(Mandatory=$true)][string]$SearchPath,
	[Parameter(Mandatory=$true)][string]$LogName,
	[Parameter(Mandatory=$true)][string]$BackupFolder 
)

## test params
if ($SearchPath -eq "") {
	Write-Error "$SearchPath must be provided..."
	exit
}
if ($LogName -eq "") {
	Write-Error "$LogName must be provided..."
	exit
}
if ($BackupFolder -eq "") {
	Write-Error "$BackupFolder must be provided..."
	exit
}

##########################################################

## search string and replacement string(s)
$SearchString    = "@[@optout]"
$ReplaceString   = "(converted_optout)"
$SearchString2   = "@[@optin]"
$ReplaceString2  = "(converted_optin)"
$SearchString3   = $SearchString 
$ReplaceString3  = $ReplaceString
$SearchString4   = $SearchString 
$ReplaceString4  = $ReplaceString

<#
"test_@[@optout]_test" -replace [regex]::escape("@[@optout]"), "(converted_optout)"
========================
'@[@optout]' -match '@\[@(.+)\]'
true

'@[@optout]' -match '@\[@([a-zA-Z]+)\]'
true
========================
Out-File -Encoding Ascii -append textfile.txt
"This is a test" | Add-Content textfile.txt
#>

## remove '-Append' : write to log file to clear contents (overwrite)
Get-Date -UFormat "[%Y-%m-%d %I:%M %p] ===" | Out-File -Encoding ASCII $LogName

Get-Date -UFormat "[%Y-%m-%d %I:%M %p] search path - $SearchPath" | Out-File -Encoding ASCII -Append $LogName
Get-Date -UFormat "[%Y-%m-%d %I:%M %p] backup folder - $BackupFolder" | Out-File -Encoding ASCII -Append $LogName
Get-Date -UFormat "[%Y-%m-%d %I:%M %p] log file - $LogName" | Out-File -Encoding ASCII -Append $LogName
Get-Date -UFormat "[%Y-%m-%d %I:%M %p] ===" | Out-File -Encoding ASCII -Append $LogName

##########################################################

$output = foreach ($file in Get-ChildItem -Path $SearchPath -Filter "*.html" | Select-String -pattern $SearchString, $SearchString2 | Select-Object -Unique path) {$file.path}
$output | Out-File -Encoding ASCII -Append $LogName
Get-Date -UFormat "[%Y-%m-%d %I:%M %p] ===" | Out-File -Encoding ASCII -Append $LogName

##########################################################

## test if backup folder exist
if ((Test-Path -PathType Container $BackupFolder) -eq $False) {
	Get-Date -UFormat "[%Y-%m-%d %I:%M %p] backup folder does not exist...creating..." | Out-File -Encoding ASCII -Append $LogName
	New-Item -ItemType Directory -Force -Path $BackupFolder
	Get-Date -UFormat "[%Y-%m-%d %I:%M %p] ===" | Out-File -Encoding ASCII -Append $LogName
}

##########################################################

## get all *.html containing $SearchString
$ChildItems=(Get-ChildItem -Path $SearchPath *.html -Recurse | Select-String -Pattern $SearchString, $SearchString2 -List | Select-Object -Expand Path)

## iter thru html
$ChildItems | foreach-object {

	## set current html
	$ChildItem = $_

	## copy html to $BackupFolder
	Get-Date -UFormat "[%Y-%m-%d %I:%M %p] copying file $ChildItem" | Out-File -Encoding ASCII -Append $LogName
	Copy-Item -LiteralPath $ChildItem -Destination $BackupFolder
	
	## retrieve list ([]) of line numbers which match provided search string
	$LineNum = (Select-String -Path $ChildItem -Pattern $SearchString, $SearchString2).LineNumber

	## log the list of lines ([1,2,3...])
	Get-Date -UFormat "[%Y-%m-%d %I:%M %p] line numbers of the file being updated: $LineNum" | Out-File -Encoding ASCII -Append $LogName

	<#
	Get-Content with the -Raw switch will ignore newline character and return the entire 
	contents of the file as a single string leaving newline characters preserved
	
	Set-Content occasionaly throws a silent (non-catchable) error "unable to read stream"
	when iterating over large lists and because of this, when that happens it will write 
	and empty set to the file...the file turns out blank!
	#>
	<#
	(Get-Content $ChildItem | ForEach {
		$Content = $_
		If ($Content -Match $SearchString) {
			Write-Output "File change from $Content to $ReplaceString" | Out-File -Encoding ASCII -Append $LogName
			$Content -replace $SearchString, $ReplaceString
		}
	}) | Set-Content $ChildItem
	#>
	
	try {
		[System.IO.File]::WriteAllText(
	        $ChildItem,
	        ([System.IO.File]::ReadAllText($ChildItem) -replace [regex]::escape($SearchString), $ReplaceString)
	    )
		[System.IO.File]::WriteAllText(
	        $ChildItem,
	        ([System.IO.File]::ReadAllText($ChildItem) -replace [regex]::escape($SearchString2), $ReplaceString2)
	    )
	}
	catch {
		Get-Date -UFormat "[%Y-%m-%d %I:%M %p] [ERROR] could not update file $ChildItem" | Out-File -Encoding ASCII -Append $LogName
	}	
	
	Get-Date -UFormat "[%Y-%m-%d %I:%M %p] ===" | Out-File -Encoding ASCII -Append $LogName
}

##### pad log
Write-Output "" | Out-File -Encoding ASCII -Append $LogName

Get-Date -UFormat "[%Y-%m-%d %I:%M %p] Exiting" | Out-File -Encoding ASCII -Append $LogName
