;=============================================================================;
; mines - Minesweeper for the MASM x86 assembler
;
; Author: Trevor Schiff (tschiff2020)
;         3 November 2023
;
; Some Win32 API functions are used, but only those which are included
; as part of the Irvine32 library.
;
; Help: Left-click to clear tiles, right-click to flag them (toggle).
;
;       For 5000 points, you can middle-click to use the "scanner" powerup.
;       It reveals the targeted tile and its neighbors (green=OK, red=MINE).
;   
;       The very first "clear" (left-click) will always be safe.
;       You win the game when all mines (and nothing else) are flagged.
;
;       To change the board size, zoom in/out in the Command Prompt window,
;       using CTRL+ScrollUp or CTRL+ScrollDown.
;=============================================================================;
; Updates:
;
; 3 November 2023 - First version.
;                   Finished as entry for the first CSE3120 assembly
;                   programming contest.
;
; 5 December 2023 - Finished as entry for the SECOND programming contest.
;                   Added mine "scanner" power-up, costs 5000 points.
;                   To purchase & use, middle-click a tile to reveal.
;                   The tile and all its neighbors will be revealed.
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