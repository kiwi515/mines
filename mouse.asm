;=============================================================================;
; mouse.asm - Mouse input
; Author: Trevor Schiff
;=============================================================================;

INCLUDE Irvine32.inc
INCLUDE mouse.inc

.386
.model flat,stdcall
.stack 4096

.data
; Last mouse click position
wLastClickX WORD 0
wLastClickY WORD 0

; Last mouse click status
wLastClickFlags DWORD 0

.code
;=============================================================================;
; Name: Mouse_Init
;
; Details: Initialize mouse driver
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Mouse_Init proc USES eax
    ;==============================;
    ; TODO: int 33h is broken?     ;
    ; Maybe see what Silaghi says  ;
    ;==============================;
    ret

    ; Trigger reset interrupt
    mov ax, 0
    int 33h
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
Mouse_Poll proc USES eax ebx ecx edx
    ;==============================;
    ; TODO: int 33h is broken?     ;
    ; Maybe see what Silaghi says  ;
    ;==============================;
    ret

    ; Clear previous status
    mov wLastClickX,     0
    mov wLastClickY,     0
    mov wLastClickFlags, 0

    ; Trigger interrupt to check for left-click
    mov ax, kMouseIntGetPress
    mov bx, kMouseBtnLeft
    int 33h

    ; Was left-click pressed since the last call?
    cmp bx, 0
    jbe _poll_right_click

    ; Left-click *did* happen
    or  wLastClickFlags, kMousePressLeft
    mov wLastClickX,     cx
    mov wLastClickY,     dx

_poll_right_click:
    ; Trigger interrupt to check for right-click
    mov ax, kMouseIntGetPress
    mov bx, kMouseBtnRight
    int 33h

    ; Was right-click pressed since the last call?
    cmp bx, 0
    jbe _poll_finish

    ; Right-click *did* happen
    or  wLastClickFlags, kMousePressRight
    mov wLastClickX,     cx
    mov wLastClickY,     dx

_poll_finish:
    ret
Mouse_Poll endp

end
