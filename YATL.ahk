;==============+
; AUTO-EXECUTE |
;===============================================================================
#SingleInstance, Force
#NoEnv

; Listbox message constants
;---------------------------------------
LB_INSERTSTRING := 0x181
LB_GETCURSEL := 0x188
LB_GETTEXT := 0x189
LB_GETTEXTLEN := 0x18A
LB_SETITEMDATA := 0x19A
LB_DELETESTRING := 0x182
LB_SETCURSEL := 0x186
LB_GETCOUNT := 0x18B

; SendMessageProc - for faster DllCalls
;---------------------------------------
SendMessageProc := GetProcAddress("user32", "SendMessageA")

; Gui options
;---------------------------------------
yatl_font = Tahoma
yatl_font_size = 10
yatl_font_color = White
yatl_tabstop = 12
yatl_margin = 10
yatl_bgcolor = 222222
yatl_control_bgcolor = 333333
yatl_guiW = 400
yatl_listboxH = 300


; Create the Gui's
;---------------------------------------
createGui()
createHelpText()
createHelpGui()

; Load the saved todo lists
;---------------------------------------
LoadTodos(hList)

OnExit, SaveAndExit
return
;===============================================================================


;========================+
; AUTO-EXECUTE FUNCTIONS |
;===============================================================================
createGui() {
   global
   Gui, +lastfound -caption +alwaysontop
   gid := WinExist()
   Gui, Margin, %yatl_margin%, %yatl_margin%
   Gui, Color, %yatl_bgcolor%, %yatl_control_bgcolor%
   Gui, Font, s%yatl_font_size% c%yatl_font_color%, %yatl_font%
   Gui, Add, Text, , YET ANOTHER TODO LIST
   Gui, Font, s%yatl_font_size%
   Gui, Add, ListBox, h%yatl_listboxH% w%yatl_guiW% t%yatl_tabstop% vyatl_list HwndhList,
   Gui, Add, Edit, xp yp wp hp vyatl_help -vscroll +readonly Hidden, Help stuff
   Gui, Add, Edit, r1 w%yatl_guiW% -WantReturn Hidden vyatl_edit,
   Gui, Add, Button, Default Hidden gAddOrEditTask,
   Gui, Show, AutoSize, YATL
   yatl_shown = 1
}

createHelpGui() {
   global
   Gui, 2: +lastfound -caption +alwaysontop +owner1
   hid := WinExist()
   Gui, 2: Margin, %yatl_margin%, %yatl_margin%
   Gui, 2: Color, 555555
   2fsize := yatl_font_size - 1
   Gui, 2: Font, s%2fsize% c%yatl_font_color%, %yatl_font%
   Gui, 2: Add, Text, , YATL - Command List
   Gui, 2: Add, Text, -vscroll +readonly, %yatl_helptext%
   Gui, 2: Show, Hide AutoSize, Help
   yatl_help_shown = 0
}

createHelpText() {
   global
   yatl_helptext =
   (LTrim
   CapsLock-t`t`tHide/show YATL
   n`t`tAdd a new task
   e`t`tEdit a task
   x`t`tCheck/uncheck a task
   Ctrl-x`t`tClear all checked tasks
   Delete`t`tDelete selected task
   Right`t`tIndent selected task
   Left`t`tDedent selected task
   Shift-Up`tMove task up
   Shift-Down`tMove task down
   Ctrl-q`t`tQuit YATL
   Ctrl-h`t`tToggle help window
   Escape`t`tEscape out of things
   )
}
;===============================================================================

; Set the hotkeys
;---------------------------------------
#IfWinActive, YATL AHK_class AutoHotkeyGUI
~n::
Gosub, _AddTask
Return
~e::
Gosub, _EditTask
return
~x::
Gosub, ToggleCheckMark
Return
^x::
Gosub, ClearChecked
Return
~Del::
Gosub, DeleteSelected
Return
~Right::
Gosub, Indent
Return
~Left::
Gosub, Dedent
Return
+Up::
Gosub, MoveUp
Return
+Down::
Gosub, MoveDown
Return
^q::
Gosub, Quit
Return
^h::
GoSub, ToggleHelpGui
Return
~Up::
~Down::
      ControlSend, , {%A_ThisHotkey%}, ahk_id %hList%
return
#IfWinActive
CapsLock & t::
Gosub, ToggleMainGUI
Return
#IfWinExist, YATL AHK_class AutoHotkeyGUI
Escape::
Gosub, yatlEscape
Return
#IfWinExist
;=====================+
; SHOW/HIDE THE GUI'S |
;===============================================================================
GuiClose:
ToggleMainGui:
   ToggleGui(gid, yatl_shown)
return

ToggleHelpGui:
   GuiControlGet, focused_control, focusv
   If (focused_control = "yatl_edit")
      return
   ToggleGui(hid, yatl_help_shown)
return

ToggleGui(hWnd, ByRef isshown) {
   If isshown
   {   WinHide, ahk_id %hWnd%
      isshown = 0
   } Else {
      WinShow, ahk_id %hWnd%
      isshown = 1
   }
}
;===============================================================================


;=========================+
; HOTKEYS AND SUBROUTINES |
;===============================================================================
_AddTask:
   GuiControlGet, focused_control, focusv
   If (focused_control != "yatl_list")
      return
   yatl_action := "add"
   GuiControl, Show, yatl_edit
   Gui, Show, Autosize
   GuiControl, Focus, yatl_edit
return

_EditTask:
   GuiControlGet, focused_control, focusv
   If (focused_control != "yatl_list")
      return
   yatl_action := "edit"
   Gui, Submit, NoHide
   RegExMatch(yatl_list, "(\s*\[.\] )(.*)", yedit)
   Guicontrol, , yatl_edit, %yedit2%
   GuiControl, Show, yatl_edit
   Gui, Show, Autosize
   GuiControl, Focus, yatl_edit
return

AddOrEditTask:
   Gui, Submit, NoHide
   If not yatl_edit
      return
   If (yatl_action = "add")
   {   yatl_edit := "[ ] " . yatl_edit
      i := GetCurrentSelection(hList)
      i := (i >= 0) ? i + 1 : i
      LB_InsertString(hList, i, yatl_edit)
   }
   If (yatl_action = "edit")
   {   yatl_edit := yedit1 . yatl_edit
      i := GetCurrentSelection(hList)
      LB_ReplaceString(hList, i, yatl_edit)
   }
   GuiControl, Hide, yatl_edit
   GuiControl, , yatl_edit,
   Gui, Show, Autosize
return

ToggleCheckMark:
   GuiControlGet, focused_control, focusv
   If (focused_control != "yatl_list")
      return
   i := GetCurrentSelection(hList)
   If (i < 0)
      return
   Gui, Submit, NoHide
   replaceStr := RegExReplace(yatl_list, "(\s*\[) (\])", "$1x$2", cnt)
   If not cnt
      replaceStr := RegExReplace(yatl_list, "(\s*\[)x(\])", "$1 $2")
   LB_ReplaceString(hList, i, replaceStr)
return

ClearChecked:
   deletelist := ""
   cnt := LB_GetCount(hList)
   Loop, % cnt
      If RegExmatch(LB_GetString(hList, A_Index - 1), "\s*\[x\]")
         deletelist .= (A_Index - 1) ","
   StringTrimRight, deletelist, deletelist, 1
   Sort, deletelist, D`, R
   Loop, parse, deletelist, `,
   {
      LB_DeleteString(hList, A_LoopField)
      If (A_LoopField >= LB_GetCount(hList))
         LB_SelectThis(hList, A_LoopField - 1)
   }
return

DeleteSelected:
   GuiControlGet, focused_control, focusv
   If (focused_control != "yatl_list")
      return
   i := GetCurrentSelection(hList)
   If (i < 0)
      return
   LB_DeleteString(hList, i)
   cnt := LB_GetCount(hList)
   If (i >= cnt)
      LB_SelectThis(hList, i - 1)

return

Indent:
Dedent:
   GuiControlGet, focused_control, focusv
   If (focused_control != "yatl_list")
      return
   i := GetCurrentSelection(hList)
   If (i < 0)
      return
   Gui, Submit, NoHide
   If (A_ThisLabel = "Indent")
      replaceStr := "`t" . yatl_list
   If (A_ThisLabel = "Dedent")
      replaceStr := (Substr(yatl_list, 1, 1) = "`t") ? Substr(yatl_list, 2) : yatl_list
   LB_ReplaceString(hList, i, replaceStr)
return

MoveUp:
MoveDown:
   GuiControlGet, focused_control, focusv
   If (focused_control != "yatl_list")
      return
   i := GetCurrentSelection(hList)
   If (i < 0)
      return
   j := (A_ThisLabel = "MoveUp") ? i - 1 : i + 1
   LB_SwapMove(hList, i, j)
return



yatlEscape:
   GuiControlGet, editisvisible, Visible, yatl_edit
   If editisvisible
   {   GuiControl, Hide, yatl_edit
      Gui, Show, Autosize
   }
   Else If yatl_help_shown
      Gosub, ToggleHelpGui
   Else
   {   WinHide, ahk_id %gid%
      WinActivate, ahk_id %curractive%
        shown := 0
   }
return

Quit:
   ExitApp
return

SaveAndExit:
   SaveToDos(hList)
   ExitApp
Return
;===============================================================================


;=====================+
; SAVE/LOAD FUNCTIONS |
;===============================================================================
SaveToDos(hWnd) {
   cnt := LB_GetCount(hWnd)
   Loop, % cnt
      todos .= LB_GetString(hWnd, A_Index - 1) . "`n"
   StringTrimRight, todos, todos, 1
   Loop, Read, %A_ScriptFullPath%
   {   thisscript .= A_LoopReadLine . "`n"
      If InStr(A_LoopReadLine, "Saved YATL List") and not Instr(A_LoopReadLine, "InStr")
         break
   }
   FileDelete, %A_ScriptFullPath%
   FileAppend, %thisscript%%todos%, %A_ScriptFullPath%
}

LoadToDos(hWnd) {
   istodo = 0
   Loop, Read, %A_ScriptFullPath%
   {   If istodo
      {   If A_LoopReadline
            todos .= A_LoopReadLine . "`n"
         continue
      }
      If InStr(A_LoopReadLine, "Saved YATL List") and not Instr(A_LoopReadLine, "InStr")
         istodo = 1
   }
   StringTrimRight, todos, todos, 1
   Loop, Parse, Todos, `n
      LB_InsertString(hWnd, -1, A_LoopField)
}
;===============================================================================


;===========================+
; DLLCALL WRAPPER FUNCTIONS |
;===============================================================================
GetProcAddress(dll, funcname) {
   return DllCall("GetProcAddress", UInt, DllCall("GetModuleHandle", Str, dll) ,Str, funcname)
}

GetCurrentSelection(hWnd) {
   global SendMessageProc
   global LB_GETCURSEL
   Return DllCall(SendMessageProc, UInt, hWnd, UInt, LB_GETCURSEL, UInt, 0, UInt, 0)
}

LB_SwapMove(hWnd, from_index, to_index) {
   global SendMessageProc
   global LB_GETTEXTLEN, LB_GETTEXT, LB_DELETESTRING, LB_INSERTSTRING, LB_SETCURSEL
   If (DllCall(SendMessageProc, UInt, hWnd, UInt, LB_GETTEXTLEN, UInt, j, UInt, 0) < 0)
      return
   lo := (from_index < to_index) ? from_index : to_index
   len := DllCall(SendMessageProc, UInt, hWnd, UInt, LB_GETTEXTLEN, UInt, lo, UInt, 0)
   VarSetCapacity(tmp, len)
   DllCall(SendMessageProc, UInt, hWnd, UInt, LB_GETTEXT, UInt, lo, UInt, &tmp)
   DllCall(SendMessageProc, UInt, hWnd, UInt, LB_DELETESTRING, UInt, lo, UInt, 0)
   DllCall(SendMessageProc, UInt, hWnd, UInt, LB_INSERTSTRING, UInt, lo + 1, UInt, &tmp)
   DllCall(SendMessageProc, UInt, hWnd, UInt, LB_SETCURSEL, UInt, to_index, UInt, 0)
}

LB_InsertString(hWnd, index, string) {
   global SendMessageProc
   global LB_INSERTSTRING, LB_SETCURSEL
   i := DllCall(SendMessageProc, UInt, hWnd, UInt, LB_INSERTSTRING, UInt, index, UInt, &string)
   Sleep, -1
   DllCall(SendMessageProc, UInt, hWnd, UInt, LB_SETCURSEL, UInt, i, UInt, 0)
   Return i
}

LB_ReplaceString(hWnd, index, string) {
   global SendMessageProc
   global LB_DELETESTRING
   DllCall(SendMessageProc, UInt, hWnd, UInt, LB_DELETESTRING, UInt, index, UInt, 0)
   LB_InsertString(hWnd, index, string)
}

LB_DeleteString(hWnd, index) {
   global SendMessageProc
   global LB_DELETESTRING
   DllCall(SendMessageProc, UInt, hWnd, UInt, LB_DELETESTRING, UInt, index, UInt, 0)
}

LB_GetString(hWnd, index) {
   global SendMessageProc
   global LB_GETTEXTLEN, LB_GETTEXT
   len := DllCall(SendMessageProc, UInt, hWnd, UInt, LB_GETTEXTLEN, UInt, index, UInt, 0)
   VarSetCapacity(tmp, len)
   DllCall(SendMessageProc, UInt, hWnd, UInt, LB_GETTEXT, UInt, index, UInt, &tmp)
   return tmp
}

LB_GetCount(hWnd) {
   global SendMessageProc
   global LB_GETCOUNT
   return DllCall(SendMessageProc, UInt, hWnd, UInt, LB_GETCOUNT, UInt, 0, UInt, 0)
}

LB_SelectThis(hWnd, index) {
   global SendMessageProc
   global LB_SETCURSEL
   DllCall(SendMessageProc, UInt, hWnd, UInt, LB_SETCURSEL, UInt, index, UInt, 0)
}
;===============================================================================


/*******************************************************************************
/*************** DO NOT MODIFY BELOW THIS LINE: Saved YATL List ****************
[ ] Press Ctrl-h for help
[ ] Press "Delete" to remove the selected task
