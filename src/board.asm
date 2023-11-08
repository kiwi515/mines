;=============================================================================;
; board.asm - Game board
; Author: Trevor Schiff
;=============================================================================;

INCLUDE Irvine32.inc
INCLUDE board.inc

INCLUDE const.inc
INCLUDE console.inc
INCLUDE memory.inc

.386
.model flat,stdcall
.stack 4096

.data
; Board tiles
stBoardTiles BOARD_TILE_S (kBoardWidth * kBoardHeight) DUP(<>)
; Board state
dwBoardState DWORD ?

.code
;=============================================================================;
; Name: Board_Reset
;
; Details: Resets board state
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_Reset proc

    ; Clear tile data
    mMemory_Clear          \
        ADDR stBoardTiles, \ ; pbDst
        SIZEOF stBoardTiles  ; dwSize

    ; Set board state
    mov dwBoardState, kBoardStatePlay

    ret
Board_Reset endp

;=============================================================================;
; Name: Board_Randomize
;
; Details: Randomly places mines across the board. Cleared tiles are
;          not considered, so this can be called after the initial click. 
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_Randomize proc

    ret
Board_Randomize endp

;=============================================================================;
; Name: Board_Draw
;
; Details: Draws board state to the console
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_Draw proc

    ret
Board_Draw endp

end
