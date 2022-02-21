#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.

#IfWinActive, ahk_class CabinetWClass ; explorer

    ^+`:: 
        ActiveExplorerPath := GetActiveExplorerPath()
        EnvGet, localappdata, LOCALAPPDATA
        Run "%localappdata%\Microsoft\WindowsApps\wt.exe" -d "%ActiveExplorerPath%", %ActiveExplorerPath%
        Sleep, 1000
        ShowAndPositionTerminal()
    return

#IfWinActive

^`::ToggleTerminal()

; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=69925

GetActiveExplorerPath() {
    explorerHwnd := WinActive("ahk_class CabinetWClass")
    if (explorerHwnd)
    {
        for window in ComObjCreate("Shell.Application").Windows
        {
            if (window.hwnd==explorerHwnd)
                return window.Document.Folder.Self.Path
        }
    }
}

ShowAndPositionTerminal()
{
    WinShow ahk_class CASCADIA_HOSTING_WINDOW_CLASS
    WinActivate ahk_class CASCADIA_HOSTING_WINDOW_CLASS

    WinMaximize, ahk_class CASCADIA_HOSTING_WINDOW_CLASS
}

ToggleTerminal()
{
    EnvGet, home, HOME
    EnvGet, localappdata, LOCALAPPDATA 

    WinMatcher := "ahk_class CASCADIA_HOSTING_WINDOW_CLASS"

    DetectHiddenWindows, On

    if WinExist(WinMatcher)
        ; Window Exists
    {
        DetectHiddenWindows, Off

        ; Check if its hidden
        if !WinExist(WinMatcher) || !WinActive(WinMatcher)
        {
            ShowAndPositionTerminal()
        }
        else if WinExist(WinMatcher)
        {
            ; Script sees it without detecting hidden windows, so..
            WinHide ahk_class CASCADIA_HOSTING_WINDOW_CLASS
            Send !{Esc}
        }
    }
    else
    {
        Run "%localappdata%\Microsoft\WindowsApps\wt.exe", %home%
        Sleep, 1000
        ShowAndPositionTerminal()
    }
}