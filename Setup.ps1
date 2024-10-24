#Requires -RunAsAdministrator

Write-Host "Installing Packages"
winget import -i ./windows.apps.json --accept-package-agreements --accept-source-agreements

Write-Host "Setting Up AutoHotKey Task"
# get path from script directory
$ahkPath = "$PSScriptRoot\Toggle.ahk"
$ahkTask = New-ScheduledTaskAction -Execute $ahkPath
$ahkTrigger = New-ScheduledTaskTrigger -AtLogOn
$ahkSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -TaskName "AutoHotKey" -Action $ahkTask -Trigger $ahkTrigger -Settings $ahkSettings