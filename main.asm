;=============================================================================;
; main.asm - Program entrypoint
; Author: Trevor Schiff
;=============================================================================;

INCLUDE Irvine32.inc

INCLUDE console.inc
INCLUDE board.inc
INCLUDE mouse.inc
INCLUDE debug.inc

.386
.model flat,stdcall
.stack 4096

.data
; Whether to draw this frame
bDoDraw BYTE TRUE

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
    invoke Console_Init
    invoke Mouse_Init
    invoke Board_Init

    ;================================================;
    ; Game loop
    ;================================================;
_loop:
    ; Poll input
    invoke Mouse_Poll

    ; Do we need to draw the board?
    cmp bDoDraw, FALSE
    je _after_draw

    ; Clear screen and re-draw board
    invoke Clrscr
    invoke Board_Draw

    ; Only draw when board changes to reduce lag
    mov bDoDraw, FALSE

_after_draw:
    jmp _loop

_temp:
    ;================================================;
    ; Finalize
    ;================================================;
    invoke ExitProcess, 0
main endp

end main