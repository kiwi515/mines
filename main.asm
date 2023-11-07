;=============================================================================;
; mines - Minesweeper for the MASM x86 assembler
;
; Author: Trevor Schiff (tschiff2020)
;         3 November 2023
;
; Entry for the CSE3120 first assembly programming contest
;=============================================================================;

INCLUDE Irvine32.inc

INCLUDE console.inc
INCLUDE board.inc
INCLUDE mouse.inc
INCLUDE debug.inc

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
    cmp eax, FALSE
    je _after_draw
    jmp _temp

    ; Clear screen and re-draw board
    invoke Clrscr
    invoke Board_Draw

_after_draw:
    jmp _loop

_temp:
    ;================================================;
    ; Finalize
    ;================================================;
    invoke ExitProcess, 0
main endp

end main