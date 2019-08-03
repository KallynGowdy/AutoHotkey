#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

^`:: toggleApp("C:\Users\kally\AppData\Local\hyper\Hyper.exe", "Hyper.exe")

toggleApp(exePath, exe) {
    IfWinExist, ahk_exe %exe%
        IfWinActive, ahk_exe %exe% 
        {
            WinMinimize, ahk_exe %exe%
        }
        else 
        {
            WinActivate, ahk_exe %exe%
        }
}