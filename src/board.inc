;=============================================================================;
; board.inc - Game board
; Author: Trevor Schiff
;=============================================================================;

; Possible tile flags
kTileFlagClear   EQU   1b ; Tile has been cleared
kTileFlagFlagged EQU  10b ; Tile has been flagged
kTileFlagMine    EQU 100b ; Tile contains a mine

; Possible board states
kBoardStatePlay EQU 0 ; Ongoing
kBoardStateWin  EQU 1 ; All mines flagged
kBoardStateLose EQU 2 ; Mine was triggered

; Board tile structure
BOARD_TILE_S STRUCT
    dwFlags   DWORD ? ; Tile flags
    dwNumMine DWORD ? ; Number of adjacent mines
BOARD_TILE_S ENDS

; Global board state
externdef dwBoardState: DWORD

;=============================================================================;
; Name: Board_Reset
;
; Details: Resets board state
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_Reset proto

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
Board_Randomize proto

;=============================================================================;
; Name: Board_Debug
;
; Details: Truly randomizes the contents of the board, for debugging purposes.
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_Debug proto

;=============================================================================;
; Name: Board_Draw
;
; Details: Draws board state to the console
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_Draw proto

;=============================================================================;
; Name: Board_GetTile
;
; Details: Gets pointer to tile on the board
; 
; Arguments: bPosX: Tile X position.
;            bPosY: Tile Y position.
;
; Return: Pointer to tile (if possible, otherwise NULL)
;=============================================================================;
Board_GetTile proto,
    bPosX: BYTE,
    bPosY: BYTE

;=============================================================================;
; Name: Board_ModifyTile
;
; Details: Attempts to modify tile on the board
; 
; Arguments: pstMouseEvt: Pointer to mouse input event that caused
;                         this tile modification.
;
; Return: Whether the board should be re-drawn
;=============================================================================;
Board_ModifyTile proto,
    pstMouseEvt: PTR INPUT_RECORD

;=============================================================================;
; Name: Board_PropogateTileClear
;
; Details: Propogates clearing of "zero" tile to all adjacent zero tiles.
; 
; Arguments: bPosX: Tile X position.
;            bPosY: Tile Y position.
;
; Return: None
;=============================================================================;
Board_PropogateTileClear proto,
    bPosX: BYTE,
    bPosY: BYTE
