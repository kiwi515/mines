;=============================================================================;
; mines - Minesweeper for the MASM x86 assembler
;
; Author: Trevor Schiff (tschiff2020)
;         3 November 2023
;
; Entry for the first CSE3120 assembly programming contest.
;
; Some Win32 API functions are used, but only those which are included
; as part of the Irvine32 library.
;
; Help: Left-click to clear tiles, right-click to flag them (toggle).
;       The very first "clear" (left-click) will always be safe.
;       You win the game when all mines (and nothing else) are flagged.
;
;       To change the board size, zoom in/out in the Command Prompt window,
;       using CTRL+ScrollUp or CTRL+ScrollDown.
;=============================================================================;

INCLUDE Irvine32.inc

INCLUDE game.inc
INCLUDE windows.inc

.386
.model flat,stdcall
.stack 4096

.data
; Whether to exit the game
dwDoExit DWORD FALSE

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
    ; Update game state
    invoke Game_Update
    mov dwDoExit, eax

    ; Draw game state
    invoke Game_Draw

    ; Exit program if necessary
    cmp dwDoExit, TRUE
    jne _loop
    invoke ExitProcess, 0
main endp

end main