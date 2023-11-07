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
    ; Clear tile flags
    mMemory_Clear    \
        ADDR bBoard, \ ; pbDst
        SIZEOF bBoard  ; dwSize

    ; Clear tile adjacency
    mMemory_Clear        \
        ADDR bAdjacency, \ ; pbDst
        SIZEOF bAdjacency  ; dwSize

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
    invoke Console_SetPos, \
        0, \ ; bPosX
        0    ; bPosY

    ret
Board_Draw endp

end
