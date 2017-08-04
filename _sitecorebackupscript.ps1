<# Sitecore Backup Script - Gabriel Streza (sitecoregabe.com) 
**************************************************************************
Powershell script that backups your Sitecore website while excluding unessesary files.

Modify Settings.xml to control Source and Directory paths. 

**************************************************************************
#>

# Directory definitions
$scriptpath = $MyInvocation.MyCommand.Path
$directory = Split-Path $scriptpath
[xml]$ConfigFile = Get-Content "$directory\Settings.xml"

# Script Variable Defintions
$ExcludePaths = $ConfigFile.Settings.ExcludePaths
$DateFormat = Get-Date -format $ConfigFile.Settings.DateFormat
$SourceDirectory = $ConfigFile.Settings.SourceDirectory
$BackupDirectory = $ConfigFile.Settings.BackupDirectory
$dest = $BackupDirectory + '_' + $DateFormat

# Folders to exclude
$exclude = "_DEV", "App_Data", "Content", "temp", "upload", "sitecore", "sitecore modules"

# Run as Administrator
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# File copy
robocopy $SourceDirectory $dest /s /xj /xd $exclude

# Completed
Write-Host -NoNewLine 'DONE! Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');