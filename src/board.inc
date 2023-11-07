;=============================================================================;
; board.inc - Game board
; Author: Trevor Schiff
;=============================================================================;

; Tile flags
kTileFlagClear EQU 1 ; Tile has been cleared
kTileFlagMine  EQU 2 ; Tile contains a mine

;=============================================================================;
; Name: Board_Init
;
; Details: Initializes game state
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_Init proto

;=============================================================================;
; Name: Board_Draw
;
; Details: Draws game state to the console
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_Draw proto
