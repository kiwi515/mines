;=============================================================================;
; mouse.inc - Mouse input
; Author: Trevor Schiff
;=============================================================================;

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
; Return: Mouse input event (if applicable, otherwise NULL)
;=============================================================================;
Mouse_Poll proto

;=============================================================================;
; Name: Mouse_Flush
;
; Details: Discard all unread input events
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Mouse_Flush proto
