;=============================================================================;
; console.inc - Console utilities
; Author: Trevor Schiff
;=============================================================================;

; stdin handle
externdef dwStdIn:  DWORD
; stdout handle
externdef dwStdOut: DWORD
; stderr handle
externdef dwStdErr: DWORD

;=============================================================================;
; Name: Console_Init
;
; Details: Initializes console handles
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Console_Init proto

;=============================================================================;
; Name: Console_SetPos
;
; Details: Set cursor position
; 
; Arguments: bPosX: Cursor X-position
;            bPosY: Cursor Y-position
;
; Return: None
;=============================================================================;
Console_SetPos proto, \
    bPosX: BYTE,      \
    bPosY: BYTE

;=============================================================================;
; Name: Console_SetColor
;
; Details: Set text color
; 
; Arguments: bColorFG: Foreground color
;            bColorBG: Background color
;
; Return: None
;=============================================================================;
Console_SetColor proto, \
    bColorFG: BYTE,     \
    bColorBG: BYTE

;=============================================================================;
; Name: Console_SetAttr
;
; Details: Set text attributes
; 
; Arguments: wAttr: Character attributes
;
; Return: None
;=============================================================================;
Console_SetAttr proto, \
    wAttr: BYTE

;=============================================================================;
; Name: Console_Print
;
; Details: Prints string to stdout
; 
; Arguments: pbMsg: Message to print
;
; Return: None
;=============================================================================;
Console_Print proto, \
    pbMsg: PTR BYTE

;=============================================================================;
; Name: Console_PrintChar
;
; Details: Prints character to stdout
; 
; Arguments: bChar: Character to print
;
; Return: None
;=============================================================================;
Console_PrintChar proto, \
    bChar: BYTE
