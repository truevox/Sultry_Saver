/*;========================================================
;### INI Values (DO NOT ADJUST THE LINE SPACING!!!)
;==========================================================
[INI_Section]
version=1

;==========================================================
;### GENERAL NOTES
;==========================================================

; Key	Syntax
; Alt       !
; Ctrl      ^
; Shift     +
; Win Logo  #
;==========================================================
;### USEFUL REFERENCE CODE
;==========================================================

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; Just general syntax hints:

MsgBox % "The answer is: " . Add(3, 2)

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; This converts 1 and 2 dimension arrays to strings

F2:: MsgBox % join(["Alice", "Mary", "Bob"])
join( strArray )
{
  s := ""
  for i,v in strArray
    s .= ", " . v
  return substr(s, 3)
}

F3:: MsgBox % join2D([[1,2,3], [4,5,6]])
join2D( strArray2D )
{
  s := ""
  for i,array in strArray2D
    s .= ", [" . join(array) . "]"
  return substr(s, 3)
}

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; How to enumerate through an array:

for index, LegalFileName in LegalFile ; Enumeration is the recommended approach in most cases.
{
    ; Using "Loop", indices must be consecutive numbers from 1 to the number
    ; of elements in the array (or they must be calculated within the loop).
    ; MsgBox % "Element number " . A_Index . " is " . Array[A_Index]

    ; Using "for", both the index (or "key") and its associated value
    ; are provided, and the index can be *any* value of your choosing.
    MsgBox % "Legal File Name number " . index . " is " . LegalFileName
}

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;main.py — C:\Users\truevox\Documents\Code\Sultry_Saver — Atom
;main.py — C:\Users\truevox\Documents\Code\Sultry_Saver — Atom..
;          C:\Users\truevox\Documents\Code\Sultry_Saver

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

; iconx: Change the tray icon displayed for each of your scripts so you can keep track of which is which.
; Also now changes the icon of a compiled script (.exe)  < ICON [I_Icon] >
; Write up by KraZe_EyE Inspired by code seen in DirMenu.ahk (highly recommended)
; -http://www.autohotkey.com/board/topic/91109-favorite-folders-popup-menu-with-gui/

;- http://www.autohotkey.com/board/topic/121982-how-to-give-your-scripts-unique-icons-in-the-windows-tray/
;- http://www.iconarchive.com/show/multipurpose-alphabet-icons-by-hydrattz.html
;  Please note that this icon pack is not available for commercial use!

; If you wish to have a different icon for this script to distinguish it from other scripts in the tray.
; Provide the filepath/name below (leave blank to have it default to the usual 'H' all AHK scripts have).

; COLOR LISTING FILENAMES: BLACK, BLUE, GOLD, GREY, ORANGE, PINK, RED, VIOLET, LIGHTGREEN==lg, DARKGREEN==dg
;							File Directory\*LETTER DESIRED*\COLOR.ico

I_Icon = C:\Program Files\AutoHotkey\Letter Icons\K\grey.ico
ICON [I_Icon]                        ;Changes a compiled script's icon (.exe)
if I_Icon <>
IfExist, %I_Icon%
	Menu, Tray, Icon, %I_Icon%   ;Changes menu tray icon

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

;==========================================================
;### Boilerplate
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
;### Universal Hotkeys/Documentation
;==========================================================

### General Linux

::restartdocker:: sudo netstat -tulpn | grep LISTEN   ; You can manually see all the ports that are currently listening/taken


### Docker Related

::restartdocker::docker-compose -f ~/docker/docker-compose.yml up -d    ; run this every time I do something to a container or mess with docker-compose.yml
::seecontainers::docker ps -a
::seedockerlogs::docker-compose logs
::stopcontainer::docker-compose stop `; CONTAINER-NAME
::teardowndocker::docker-compose -f ~/docker/docker-compose.yml down    ; This SHOULD be safe, just run restartdocker to get it all right back (in theory)
::cleandocker1::docker sytem prune       ; Remember, one of the biggest benefits of Docker is that it is extremely hard to mess up your host operating
::cleandocker2::docker image prune       ; system. So you can create and destroy containers at will. But over time leftover Docker images, containers,
::cleandocker3::docker volume prune      ; and volumes can take several GBs of space. So at any time you can run the following clean up scripts and re-run your docker-compose as described above.
::cleandocker3::docker volume prune



; `%{Space}{Del}


;==========================================================
;### Rest of code
;==========================================================

LegalFile := ["main.py", "bearlibs.py"]
RunningTotal := ""



;If it matches the /dir/me/code/ #IfWinActive WinTitle, WinText code (Set title match mode 2, don't forget) then ~Ctrl S will run. This then loops through an if then statement that uses WinActive() to test fo win in the array.





for i, LegalFileName in LegalFile
{
    GroupAdd, LegalScripts, LegalFileName
    /*  ; This may be interesting later, so I'm saving it for posterity.
    ;TODO Get comfortable with source control so I don't have to save things in script for posterity.
    LegalFilePath := LegalFile[FileNameIndex] . " — " . A_ScriptDir
    GroupAdd, LegalScripts, LegalFilePath   ; FileNameIndex . A_ScriptDir
    */
}


+!r::
{
    msgbox, , , Reloading, 0.33
    Reload
    ExitApp
    return
}


CopyToCPX(SourceFileName, DestinationFileName:=0, DestinationFolder:="D:\") ;TODO Need to give a variable way to rename files during copy (so copy C:\A.txt to D:\B.Bat)
{
    if (DestinationFileName = 0)
    {
        DestinationFileName := SourceFileName
    }
    ;Progress, w250,,, Hold yer ponies,  I'm pushing the newist D:\main.py to the repo     ;TODO Come back and get this later - I'll need it elsewhere.
    ;Progress, 25     ;TODO Come back and get this later - I'll need it elsewhere.
    ;Progress, 75     ;TODO Come back and get this later - I'll need it elsewhere.
    ;Progress, 100    ;TODO Come back and get this later - I'll need it elsewhere.
    DestinationFull := DestinationFolder . DestinationFileName
    BackupFull := DestinationFileName . ".bak"
    Progress, w250,,, Please hold - Copying %SourceFileName%…
    Progress,
    FileCopy, %DestinationFull%, %BackupFull%, 1
    Progress, 35
    FileCopy, %SourceFileName%, %DestinationFull%, 1
    Progress, 65
    Progress, 100
    Progress, Off
    return "Copied " . SourceFileName . " to " . DestinationFull
    ; return [A_ScriptDir . "\" . SourceFileName, DestinationFolder . "\" . DestinationFileName] ;TODO Come back and make Array - for now, just return a string of the file name.
}

Join(strArray)
{
  s := ""
  for i,v in strArray
    s .= ", " . v
  return substr(s, 3)
}





DetectHiddenWindows, On
SetTitleMatchMode, 1
;TODO Need to add code to get the " — Atom"  involved

#IfWinActive main.py —

    ;TODO Change the below text into a function, and then just call that instead.

~^s:: ;c Push an update directly from my local repo to the CPE on D:\ - pulls from LegalFile array.
{
    for i, LegalFileName in LegalFile
    {
        ;msgbox % "Looping the copy stuff - now on: " . LegalFileName
        RunningTotal := RunningTotal . ", `n" . CopyToCPX(LegalFileName)
        for i, CopySuccessFile in CopySuccess
        {
            RunningTotal.Push(CopySuccessFile)
        }
    }
    msgbox, , , % substr(RunningTotal, 3), 0.5
    return
}

#IfWinActive bearlibs.py —

~^s:: ;c Push an update directly from my local repo to the CPE on D:\ - pulls from LegalFile array.
{
    for i, LegalFileName in LegalFile
    {
        ;msgbox % "Looping the copy stuff - now on: " . LegalFileName
        RunningTotal := RunningTotal . ", `n" . CopyToCPX(LegalFileName)
        for i, CopySuccessFile in CopySuccess
        {
            RunningTotal.Push(CopySuccessFile)
        }
    }
    msgbox, , , % substr(RunningTotal, 3), 0.5
    return
}





SetTitleMatchMode, 2

; #IfWinActive Atom   ; Need to come back and fix this, but for now…
#IfWinActive, ahk_exe atom.exe

:Z*:===::- [ ] ` ;c Swaps --- (or ===) for - [ ]  when ever it's typed into Atom.
:Z*:---::- [ ] ` ; Z* = (Z=reset hotstring rec (good for strings of hotstrings)) + (*=execute once last character is typed)
:Z*:msgb::msgbox `%{Space}{Del}


/*


~^s:: ;TODO Need to come back to this and make it only work on files that are open. For the moment, we'll just make sure Atom is open.
{
    for i, LegalFileName in LegalFile
    {
        if WinExist(LegalFileName)
            msgbox % "Looping the copy stuff - now on: " . LegalFileName
            CopySuccess := [CopyToCPX(LegalFileName)]
            for i, CopySuccessFile in CopySuccess
            {
                RunningTotal.Push(CopySuccessFile)
            }
    }
    MsgBox % Join(RunningTotal) . "Test"
    Reload   ; Erase later
    ExitApp  ; Erase later
    return
}

{
    ;SetTitleMatchMode, 1
    for LegalFileName in LegalFile

    ;if WinActive("main.py")
    for i in LegalFile
    {
        MiniMsg := A_ScriptDir . "\" . LegalFile[i]
        msgbox %MiniMsg%
    }
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
;### Update Module
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
;### Help File Section
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
