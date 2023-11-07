;=============================================================================;
; mouse.inc - Mouse input
; Author: Trevor Schiff
;=============================================================================;

; Whether a click input is ready for the game
externdef bMouseClicked: BYTE

;=============================================================================;
; Name: Mouse_Init
;
; Details: Initialize mouse input
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Mouse_Init proto

;=============================================================================;
; Name: Mouse_Poll
;
; Details: Polls mouse input state
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Mouse_Poll proto
