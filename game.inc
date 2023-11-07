;=============================================================================;
; game.inc - Game state manager
; Author: Trevor Schiff
;=============================================================================;

; Game state list
kGameStatePlay EQU 0 ; Game is ongoing
kGameStateWin  EQU 1 ; Game was won
kGameStateLose EQU 2 ; Game was lost

;=============================================================================;
; Name: Game_Init
;
; Details: Initializes game subsystems
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Game_Init proto

;=============================================================================;
; Name: Game_Reset
;
; Details: Resets game subsystems (for playing again)
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Game_Reset proto

;=============================================================================;
; Name: Game_Tick
;
; Details: Steps game state forward once
; 
; Arguments: None
;
; Return: Whether program should exit
;=============================================================================;
Game_Tick proto

;=============================================================================;
; Name: Game_Draw
;
; Details: Renders game state
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Game_Draw proto

;=============================================================================;
; Name: Game_TickPlay
;
; Details: Update game in 'play' state
; 
; Arguments: None
;
; Return: Whether program should exit
;=============================================================================;
Game_TickPlay proto

;=============================================================================;
; Name: Game_TickWinLose
;
; Details: Update game in 'win' or 'lose' state
; 
; Arguments: None
;
; Return: Whether program should exit
;=============================================================================;
Game_TickWinLose proto
