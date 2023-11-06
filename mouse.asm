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
    ; For some reason, I have to disable Win10 "Quick Edit" mode
    ; or mouse events will go uncaught.
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
    ASSERT_FALSE(eax == 0)
    
    ; Track mouse events
    invoke SetConsoleMode, \
        dwStdIn, \         ; hConsoleHandle
        ENABLE_MOUSE_INPUT ; dwMode

    ; Check for success
    ASSERT_FALSE(eax == 0)

    ret
Mouse_Init endp

;=============================================================================;
; Name: Mouse_Poll
;
; Details: Polls mouse input state
; 
; Arguments: None
;
; Return: Whether a click input was read
;=============================================================================;
Mouse_Poll proc

    ; Clear previous input state
    mov dwNumEvt, 0
    mMemory_Clear        \
        ADDR stMouseEvt, \ ; pbDst
        SIZEOF stMouseEvt  ; dwSize

    ; Try reading mouse event
    invoke ReadConsoleInput, \
        dwStdIn,           \ ; hConsoleInput
        ADDR stMouseEvt,   \ ; lpBuffer
        LENGTH stMouseEvt, \ ; nLength
        ADDR dwNumEvt        ; lpNumberOfEventsRead

    ; Check for success
    ASSERT_FALSE(eax == 0)

    ; Did we read anything?
    cmp dwNumEvt, 0
    je _no_input

    ; Did we specifically read a *mouse* event?
    cmp stMouseEvt.EventType, MOUSE_EVENT
    jne _no_input

    ; Did a click (left/right) just happen?
    test stMouseEvt.Event.dwButtonState, \
           FROM_LEFT_1ST_BUTTON_PRESSED  \ ; Left-click
        OR RIGHTMOST_BUTTON_PRESSED        ; Right-click
    jz _no_input

    ; We read a click input in this window!
    mov eax, TRUE
    ret

    ; No click input :(
_no_input:
    mov eax, FALSE
    ret
Mouse_Poll endp

end
