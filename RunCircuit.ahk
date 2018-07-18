/*;========================================================
;==  INI Values (DO NOT ADJUST THE LINE SPACING!!!)
;==========================================================
[INI_Section]
version=1
*/
;==========================================================
;==  Boilerplate
;==========================================================

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases, prevents checking empty variables
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#SINGLEINSTANCE force
CurrentVer = 0
NewVer = 0
;SetBatchLines, -1	; Runs the script at max speed, default is 10 or 20 ms

;==========================================================
;==  GENERAL NOTES
;==========================================================

; Key	Syntax
; Alt       !
; Ctrl      ^
; Shift     +
; Win Logo  #

;main.py — C:\Users\truevox\Documents\Code\Sultry_Saver — Atom
;main.py — C:\Users\truevox\Documents\Code\Sultry_Saver — Atom..
;          C:\Users\truevox\Documents\Code\Sultry_Saver

;If it matches the /dir/me/code/ #IfWinActive WinTitle, WinText code (Set title match mode 2, don't forget) then ~Ctrl S will run. This then loops through an if then statement that uses WinActive() to test fo win in the array.



LegalFile := ["main.py", "bearlibs.py"]

for FileNameIndex in LegalFile
{
    LegalFilePath := LegalFile[FileNameIndex] . " — " . A_ScriptDir
    GroupAdd, LegalScripts, LegalFilePath   ; FileNameIndex . A_ScriptDir
}


+!r::
{
    msgbox, , , Reloading, 0.33
    Reload
    ExitApp
    return
}

SetTitleMatchMode, 2
;TODO Need to add code to get the " — Atom"  involved
#IfWinActive LegalScripts
~^s::
{
    ;SetTitleMatchMode, 1
    for LegalFileName in LegalFile
    {
        if WinActive(LegalFile[LegalFileName])
            msgbox, LegalFile[LegalFileName]
    }
    ;if WinActive("main.py")
    msgbox,
    Reload
    ExitApp
    return
}




/*
~^s:: ;c Push an update directly from master to the CPE on D:\ - currently ONLY pulls main.py.
{
    Progress, w250,,, Hold yer ponies,  I'm pushing the newist D:\main.py to the repo�
    FileCopy, C:\Users\truevox\Documents\Code\Sultry_Saver\main.py, C:\Users\truevox\Documents\Code\Sultry_Saver\main.py.bak, 1
    Progress, 25
    sleep, 100
    FileCopy, D:\main.py, C:\Users\truevox\Documents\Code\Sultry_Saver\main.py, 1
    Progress, 75
    sleep, 100
    Progress, 100
    sleep, 100
    ; MsgBox If you see me, I either just updated when you triggered me to, or I updated last night. Either way, please click 'OK', and go about your day! Also, press 'Win+F2' to open up a quick help cheat-sheet.
    Reload
    ExitApp
}




/*
{
    Progress, w250,,, Hold yer ponies,  I'm downloading the newist D:\main.py�
    FileCopy, D:\main.py, D:\main.py.bak, 1
    Progress, 25
    sleep, 100
    FileCopy, D:\main.py, C:\Users\truevox\Documents\Code\Sultry_Saver\main.py.bak, 1  ; Come back and make C:\etc into a single variable, so I can call the same thing everywhere.
    Progress, 75
    sleep, 100
    UrlDownloadToFile, https://raw.githubusercontent.com/truevox/Sultry_Saver/master/main.py, D:\main.py ;*[ShortcutToolkit]
    Progress, 100
    sleep, 100
    ; MsgBox If you see me, I either just updated when you triggered me to, or I updated last night. Either way, please click 'OK', and go about your day! Also, press 'Win+F2' to open up a quick help cheat-sheet.
    Reload
    ExitApp
}


^+b:: ;c Push an update directly from the CPE on D:\ to the repo- currently ONLY pulls main.py.
{
    Progress, w250,,, Hold yer ponies,  I'm pushing the newist D:\main.py to the repo�
    FileCopy, C:\Users\truevox\Documents\Code\Sultry_Saver\main.py, C:\Users\truevox\Documents\Code\Sultry_Saver\main.py.bak, 1
    Progress, 25
    sleep, 100
    FileCopy, D:\main.py, C:\Users\truevox\Documents\Code\Sultry_Saver\main.py, 1
    Progress, 75
    sleep, 100
    Progress, 100
    sleep, 100
    ; MsgBox If you see me, I either just updated when you triggered me to, or I updated last night. Either way, please click 'OK', and go about your day! Also, press 'Win+F2' to open up a quick help cheat-sheet.
    Reload
    ExitApp
}






/*

;===========================================================
;==  Update Module
;===========================================================
; Files if hosted on Github    : https://raw.githubusercontent.com/MarvinFiveMaples/ShortcutToolkit/master/ShortcutToolkit.ahk?raw=true

SetTimer UpdateCheck, 60000 ; Check each minute
;Return

ButtonRestartToolkit:
^+#r:: ;c ?? Restart Marvin's ShortCutToolkit ?? Ctrl+Shift+Win+r | Pressing Ctrl+Shift+Win+r will restart the ShortCutToolkit - use this if it freezes up on you.
{
	Progress, w250,,, Hold yer ponies,  I'm restarting�
	vRestart := 0
	loop, 100
	{
		vRestart := vRestart + 2
		Progress, %vRestart%
		sleep, 10
	}
	Progress,  Off
	MsgBox Rebooted - please click 'OK' to proceed.
	Reload
	ExitApp
}


UpdateCheck:
If (A_Hour = 01 And A_Min = 12)
{
	Progress, w250,,, Hold yer ponies,  I'm updating�
	Sleep, 2000
	Progress, off
	gosub VersionCheck
	}
Return

; The following is for testing ONLY, and shouldn't be used otherwise.
/*
SetTimer UpdateCheckTest, 1000 ; Check each second
Return
UpdateCheckTest:
If (A_Hour = 13)
	{
	Msgbox, Hey!
	Progress, w250,,, Hold yer ponies,  I'm updating�
	Sleep, 10000
	Progress, off
	gosub VersionCheck
	}
Return




VersionCheck:
^+#t:: ; c If you didn't trigger this window by pressing 'Win+F2', then it must mean that you had an update last night! Yay! (you can click OK)
{
; IniRead, OutputVar, C:\Temp\myfile.ini, section2, key
; MsgBox, The value is %OutputVar%.
; FileReadLine, %CurrentVer%, ShortcutToolkit.ahk, 5
; FileReadLine, %NewVer%, //raw.githubusercontent.com/MarvinFiveMaples/ShortcutToolkit/master/ShortcutToolkit.ahk?raw=true, 5
IniRead, CurrentVer, ShortcutToolkit.ahk, INI_Section, version
UrlDownloadToFile, https://raw.githubusercontent.com/MarvinFiveMaples/ShortcutToolkit/master/ShortcutToolkit.ahk?raw=true, JunkKit.ahk ;*[ShortcutToolkit]
IniRead, NewVer, JunkKit.ahk, INI_Section, version
FileDelete, JunkKit.ahk
if (CurrentVer < NewVer)
	{
	gosub UpdateScript ; Insert the following above if you need to check anything in the future: MsgBox, %CurrentVer% & %NewVer%
	Return
	}
Return
}

ButtonForceUpdateToolkit:
UpdateScript:
^+#u:: ;c ?? Update Script ?? Ctrl+Shift+Win+u | Typing Ctrl+Shift+Win+u will trigger an update of the script - also automatically triggered every morning at 1:15am
{
	UrlDownloadToFile, https://raw.githubusercontent.com/MarvinFiveMaples/ShortcutToolkit/master/ShortcutToolkit.ahk?raw=true, ShortcutToolkit.ahk ;*[ShortcutToolkit]
	;Progress, w250,,, Hold yer ponies,  I'm updating�
	MsgBox If you see me, I either just updated when you triggered me to, or I updated last night. Either way, please click 'OK', and go about your day! Also, press 'Win+F2' to open up a quick help cheat-sheet.
	Reload
	ExitApp
}



;==========================================================
;==  Help File Section
;==========================================================

ButtonHelp:
#F2:: ;c ?? Activate "Help" Menu ?? WinKey+F2 | will bring up this help file, which attempts to automatically document these functions. It may go without saying, but I'm still working on it. :D
{
fileread content, %a_scriptfullpath%
comment=
loop parse, content,`n
{
 ifinstring a_loopfield,;c  ;;
  ifnotinstring a_loopfield,;;
 {
  position := InStr(a_loopfield,";c") ;;
  position +=1
  stringtrimleft com,a_loopfield,%position%
  comment =%comment%%com%`n`n
 }
}
  gui, submit
  msgbox %comment%
Return
}

*/
