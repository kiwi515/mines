;=============================================================================;
; mines - Minesweeper for the MASM x86 assembler
;
; Author: Trevor Schiff (tschiff2020)
;         3 November 2023
;
; Entry for the first CSE3120 assembly programming contest
;=============================================================================;

INCLUDE Irvine32.inc

INCLUDE game.inc

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
    ; Initialize
    invoke Game_Init

_loop:
    ; Game logic step
    invoke Game_Update

    ; Should we exit?
    cmp eax, TRUE
    jne _loop

    ; Exit program
    invoke ExitProcess, 0
main endp

end main