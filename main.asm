;=============================================================================;
; main.asm - Program entrypoint
; Author: Trevor Schiff
;=============================================================================;

INCLUDE Irvine32.inc
INCLUDE console.inc
INCLUDE board.inc
INCLUDE mouse.inc

.386
.model flat,stdcall
.stack 4096

.code
;=============================================================================;
; Name: main
;
; Details: Program entrypoint
; 
; Arguments: None
;
; Return: None
;=============================================================================;
main proc
    ;================================================;
    ; Initialize
    ;================================================;
    ; Prepare hardware
    invoke Mouse_Init
    ; Prepare console
    invoke Console_Init
    ; Prepare board
    invoke Board_Init

    ;================================================;
    ; Game loop
    ;================================================;
_loop:
    ; Poll input
    invoke Mouse_Poll

    ; Draw board
    invoke Clrscr
    invoke Board_Draw

    jmp _loop

_temp:
    ;================================================;
    ; Finalize
    ;================================================;
    invoke ExitProcess, 0
main endp

end main