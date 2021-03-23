<#
file_name = bakcup.ps1

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
	C:\PS> .\bakcup.ps1 'C:\creativeFolder' 'C:\creativeFolder.log' 'C:\creativeFolderBackup'
	
	dos prompt
	powershell -ExecutionPolicy Bypass "D:\Hung\Work\PowerShell\bakcup.ps1 'C:\Temp\creativeFolder' 'C:\Temp\creativeFolder.log' 'C:\Temp\creativeFolderBackup'"
	
	C:\PS> .\bakcup.ps1 '\\gr-test\test\creativedirs\Dm5ErieTestRelease\creatives\viewfile' '.\Dm5ErieTestRelease.log' '.\Dm5ErieTestRelease_Backup'
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
$SearchString    = "@\[@([a-zA-Z]+)\]"

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

Get-Date -UFormat "[%Y-%m-%d %I:%M %p] all matches" | Out-File -Encoding ASCII -Append $LogName
Get-ChildItem -Path $SearchPath *.html -Recurse | Select-String -Pattern $SearchString -allmatch | foreach-object {$_.matches.value} | Select-Object -unique | Out-File -Encoding ASCII -Append $LogName
Get-Date -UFormat "[%Y-%m-%d %I:%M %p] ===" | Out-File -Encoding ASCII -Append $LogName

Get-Date -UFormat "[%Y-%m-%d %I:%M %p] all files" | Out-File -Encoding ASCII -Append $LogName
$output = foreach ($file in Get-ChildItem -Path $SearchPath -Filter "*.html" | Select-String -pattern $SearchString | Select-Object -Unique path) {$file.path}
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
$ChildItems=(Get-ChildItem -Path $SearchPath *.html -Recurse | Select-String -Pattern $SearchString -List | Select-Object -Expand Path)

## iter thru html
$ChildItems | foreach-object {

	## set current html
	$ChildItem = $_

	## copy html to $BackupFolder
	Get-Date -UFormat "[%Y-%m-%d %I:%M %p] copying file $ChildItem" | Out-File -Encoding ASCII -Append $LogName
	Copy-Item -LiteralPath $ChildItem -Destination $BackupFolder
}

##### pad log
Write-Output "" | Out-File -Encoding ASCII -Append $LogName

Get-Date -UFormat "[%Y-%m-%d %I:%M %p] Exiting" | Out-File -Encoding ASCII -Append $LogName

