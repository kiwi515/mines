;=============================================================================;
; board.inc - Game board
; Author: Trevor Schiff
;=============================================================================;

; Game state list
kStatePlay EQU 0 ; Game is ongoing
kStateWin  EQU 1 ; Game was won
kStateLose EQU 2 ; Game was lost

; Tile flags
kTileFlagClear EQU 1 ; Tile has been cleared
kTileFlagMine  EQU 2 ; Tile contains a mine

; Game state
externdef dwBoardState: DWORD

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
