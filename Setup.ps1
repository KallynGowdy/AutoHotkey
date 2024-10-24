#Requires -RunAsAdministrator

Write-Host "Installing Packages"

$apps = (Get-Content "$PSScriptRoot\windows.apps.json" | ConvertFrom-Json)

foreach($source in $apps.Sources) {
    $details = $source.SourceDetails
    $sourceName = $details.Name
    Write-Host "Installing from $sourceName"
    foreach($package in $source.Packages) {
        $id = $package.PackageIdentifier
        $scope = $package.Scope

        if ($scope) {
            Write-Host "Installing $id/$scope"
            winget install --id $id --silent --accept-package-agreements --source $sourceName --scope $scope
        } else {
            Write-Host "Installing $id"
            winget install --id $id --silent --accept-package-agreements --source $sourceName
        }
    }
}

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