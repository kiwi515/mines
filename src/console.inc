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
; Details: Sets cursor position
; 
; Arguments: bPosX: Cursor X-position
;            bPosY: Cursor Y-position
;
; Return: None
;=============================================================================;
Console_SetPos proto,
    bPosX: BYTE,
    bPosY: BYTE

;=============================================================================;
; Name: Console_SetFontSize
;
; Details: Sets size of the current font
; 
; Arguments: stSize: Font size (width, height)
;
; Return: None
;=============================================================================;
Console_SetFontSize proto,
    stSize: COORD

;=============================================================================;
; Name: Console_SetAttr
;
; Details: Sets text and background colors
; 
; Arguments: bColorFG: Foreground color
;            bColorBG: Background color
;            bGrid:    Enable grid
;
; Return: None
;=============================================================================;
Console_SetAttr proto,
    bColorFG: BYTE,
    bColorBG: BYTE,
    bGrid:    BYTE

;=============================================================================;
; Name: Console_Print
;
; Details: Prints string to stdout
; 
; Arguments: pbMsg: Message to print
;
; Return: None
;=============================================================================;
Console_Print proto,
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
Console_PrintChar proto,
    bChar: BYTE
