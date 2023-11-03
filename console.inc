;=============================================================================;
; console.inc - Console utilities
; Author: Trevor Schiff
;=============================================================================;

;=============================================================================;
; Name: Console_Init
; Details: Initializes console handles
; 
; Arguments: None
; Return: None
;=============================================================================;
Console_Init proto

;=============================================================================;
; Name: Console_Print
; Details: Prints string to console (stdout)
; 
; Arguments: Message
; Return: None
;=============================================================================;
Console_Print proto, msg:PTR BYTE
