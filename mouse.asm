;=============================================================================;
; mouse.asm - Mouse input
; Author: Trevor Schiff
;=============================================================================;

INCLUDE Irvine32.inc
INCLUDE mouse.inc

INCLUDE console.inc
INCLUDE windows.inc
INCLUDE memory.inc
INCLUDE debug.inc

.386
.model flat,stdcall
.stack 4096

.data
; Mouse input event
stMouseEvt INPUT_RECORD <>
; How many mouse input events were just read
dwNumEvt DWORD 0

; Whether a click input is ready for the game
bMouseClicked BYTE FALSE

.code
;=============================================================================;
; Name: Mouse_Init
;
; Details: Initialize mouse input
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Mouse_Init proc \ 
    USES eax

    ;
    ; Have to disable Win10 text "Quick Edit" mode or mouse events will not show up.
    ;
    ; Per Microsoft documentation:
    ; 
    ; ENABLE_QUICK_EDIT_MODE 0x0040
    ;   This flag enables the user to use the mouse to select and edit text.
    ;   To enable this mode, use ENABLE_QUICK_EDIT_MODE | ENABLE_EXTENDED_FLAGS.
    ;   To disable this mode, use ENABLE_EXTENDED_FLAGS without this flag.
    ;
    ; https://learn.microsoft.com/en-us/windows/console/setconsolemode
    ;

    ; Disable "Quick Edit" mode
    invoke SetConsoleMode, \
        dwStdIn, \            ; hConsoleHandle
        ENABLE_EXTENDED_FLAGS ; dwMode

    ; Check for success
    mDebug_AssertFalse(eax == 0)
    
    ; Track mouse events
    invoke SetConsoleMode, \
        dwStdIn, \         ; hConsoleHandle
        ENABLE_MOUSE_INPUT ; dwMode

    ; Check for success
    mDebug_AssertFalse(eax == 0)

    ret
Mouse_Init endp

;=============================================================================;
; Name: Mouse_Poll
;
; Details: Polls mouse input state
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Mouse_Poll proc \
    USES eax

    ; Clear previous input state
    mMemory_Clear \
        ADDR stMouseEvt, \ ; pbDst
        SIZEOF stMouseEvt  ; dwSize
    mov dwNumEvt,      0
    mov bMouseClicked, FALSE

    ; Try reading mouse event
    invoke ReadConsoleInput, \
        dwStdIn, \           ; hConsoleInput
        ADDR stMouseEvt, \   ; lpBuffer
        LENGTH stMouseEvt, \ ; nLength
        ADDR dwNumEvt        ; lpNumberOfEventsRead

    ; Check for success
    mDebug_AssertFalse(eax == 0)

    ; Did we read anything?
    cmp dwNumEvt, 0
    je _finish

    ; Did we specifically read a *mouse* event?
    cmp stMouseEvt.EventType, MOUSE_EVENT
    jne _finish

    ; Did a click (left/right) just happen?
    test stMouseEvt.Event.dwButtonState, \
        FROM_LEFT_1ST_BUTTON_PRESSED \ ; Left-click
        OR RIGHTMOST_BUTTON_PRESSED    ; Right-click
    jz _finish

    ; We read a click input in this window!
    mov bMouseClicked, TRUE

_finish:
    ret
Mouse_Poll endp

end
