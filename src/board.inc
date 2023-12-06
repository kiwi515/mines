;=============================================================================;
; board.inc - Game board
; Author: Trevor Schiff
;=============================================================================;

; Possible tile flags
kTileFlagClear   EQU    1b ; Tile has been cleared
kTileFlagFlagged EQU   10b ; Tile has been flagged
kTileFlagMine    EQU  100b ; Tile contains a mine

; Possible board states
kBoardStatePlay EQU 0 ; Ongoing
kBoardStateWin  EQU 1 ; All mines flagged
kBoardStateLose EQU 2 ; Mine was triggered

; Board tile structure
BOARD_TILE_S STRUCT
    dwFlags   DWORD ? ; Tile flags
    dwScanned DWORD ? ; Whether the tile has been scanned
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
; Name: Board_PlaceMines
;
; Details: Randomly places mines across the board. Cleared tiles are
;          not considered, so this can be called after the initial click. 
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_PlaceMines proto

;=============================================================================;
; Name: Board_ComputeAdjacency
;
; Details: Computes number of adjacent mines for every tile. 
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_ComputeAdjacency proto

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
; Name: Board_Update
;
; Details: Processes mouse input event
; 
; Arguments: pstMouseEvt: Pointer to mouse input event
;
; Return: Whether the board should be re-drawn
;=============================================================================;
Board_Update proto,
    pstMouseEvt: PTR INPUT_RECORD

;=============================================================================;
; Name: Board_CheckWin
;
; Details: Checks whether the player has won (exactly all mines are flagged).
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_CheckWin proto

;=============================================================================;
; Name: Board_ClearTile
;
; Details: Attempts to clear tile
; 
; Arguments: bPosX: Tile X position.
;            bPosY: Tile Y position.
;
; Return: Whether the board should be re-drawn
;=============================================================================;
Board_ClearTile proto,
    bPosX: BYTE,
    bPosY: BYTE

;=============================================================================;
; Name: Board_FlagTile
;
; Details: Attempts to flag tile
; 
; Arguments: bPosX: Tile X position.
;            bPosY: Tile Y position.
;
; Return: Whether the board should be re-drawn
;=============================================================================;
Board_FlagTile proto,
    bPosX: BYTE,
    bPosY: BYTE

;=============================================================================;
; Name: Board_ScanTile
;
; Details: Attempts to scan tile (after purchasing the powerup)
; 
; Arguments: bPosX: Tile X position.
;            bPosY: Tile Y position.
;
; Return: Whether the board should be re-drawn
;=============================================================================;
Board_ScanTile proto,
    bPosX: BYTE,
    bPosY: BYTE

;=============================================================================;
; Name: Board_PropogateClearTile
;
; Details: Attempts to propogate clear operation to the specified neighbor
;          tile.
; 
; Arguments: bPosX: Tile X position.
;            bPosY: Tile Y position.
;
; Return: None
;=============================================================================;
Board_PropogateClearTile proto,
    bPosX: BYTE,
    bPosY: BYTE
