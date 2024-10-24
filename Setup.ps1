#Requires -RunAsAdministrator

Write-Host "Installing Packages"
winget import -i ./windows.apps.json --accept-package-agreements --accept-source-agreements

Write-Host "Setting Up AutoHotKey Task"
# get path from script directory
$ahkPath = "C:\Program Files\AutoHotkey\UX\AutoHotkeyUX.exe"
$launcherPath = "C:\Program Files\AutoHotkey\UX\launcher.ahk"
$togglePath = "$PSScriptRoot\Toggle.ahk"
$ahkTask = New-ScheduledTaskAction -Execute $ahkPath -Argument """$launcherPath"" /Launch ""$togglePath"""
$ahkTrigger = New-ScheduledTaskTrigger -AtLogOn
$ahkSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

$existingTask = Get-ScheduledTask -TaskName "AutoHotKey" -ErrorAction SilentlyContinue
if ($existingTask) {
    Unregister-ScheduledTask -TaskName "AutoHotKey" -Confirm:$false
}
Register-ScheduledTask -TaskName "AutoHotKey" -Action $ahkTask -Trigger $ahkTrigger -Settings $ahkSettings