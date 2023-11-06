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
; Game board tiles
bBoard     BYTE (kBoardWidth * kBoardHeight) DUP(?)
; Tile mine adjacency (pre-computed)
bAdjacency BYTE (kBoardWidth * kBoardHeight) DUP(?)

; Game state
dwBoardState DWORD ?

.code
;=============================================================================;
; Name: Board_Init
;
; Details: Initializes game state
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_Init proc
    ; Clear board
    invoke Memory_Set, ADDR bBoard,     0, SIZEOF bBoard
    invoke Memory_Set, ADDR bAdjacency, 0, SIZEOF bAdjacency

    ; Set play state
    mov dwBoardState, kStatePlay

    ret
Board_Init endp

;=============================================================================;
; Name: Board_Draw
;
; Details: Draws game state to the console
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_Draw proc
    ; Put cursor in top-left
    invoke Console_SetPos, 0, 0

    ret
Board_Draw endp

end
