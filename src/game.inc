;=============================================================================;
; game.inc - Game manager
; Author: Trevor Schiff
;=============================================================================;

;=============================================================================;
; Name: Game_Init
;
; Details: Initializes game system
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Game_Init proto

;=============================================================================;
; Name: Game_Reset
;
; Details: Resets game system (for playing again)
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Game_Reset proto

;=============================================================================;
; Name: Game_Update
;
; Details: Steps game system forward once
; 
; Arguments: None
;
; Return: Whether program should exit
;=============================================================================;
Game_Update proto

;=============================================================================;
; Name: Game_Draw
;
; Details: Renders game system
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Game_Draw proto

;=============================================================================;
; Name: _Game_UpdatePlay
;
; Details: Update system in 'play' state
; 
; Arguments: None
;
; Return: Whether program should exit
;=============================================================================;
_Game_UpdatePlay proto

;=============================================================================;
; Name: _Game_UpdateWinLose
;
; Details: Update system in 'win' or 'lose' state
; 
; Arguments: None
;
; Return: Whether program should exit
;=============================================================================;
_Game_UpdateWinLose proto
