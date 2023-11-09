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
; Name: Console_ResizeWindow
;
; Details: Set window dimensions
; 
; Arguments: wWidth:  Window width
;            wHeight: Window height
;
; Return: None
;=============================================================================;
Console_ResizeWindow proto,
    wWidth:  WORD,
    wHeight: WORD

;=============================================================================;
; Name: Console_MoveCursor
;
; Details: Sets cursor position
; 
; Arguments: bPosX: Cursor X-position
;            bPosY: Cursor Y-position
;
; Return: None
;=============================================================================;
Console_MoveCursor proto,
    bPosX: BYTE,
    bPosY: BYTE

;=============================================================================;
; Name: Console_ShowCursor
;
; Details: Set cursor visibility
; 
; Arguments: bVisible: Whether the cursor should be visible
;
; Return: None
;=============================================================================;
Console_ShowCursor proto,
    bVisible: BYTE

;=============================================================================;
; Name: Console_SetTextAttr
;
; Details: Sets text and background colors
; 
; Arguments: bColorFG: Foreground color
;            bColorBG: Background color
;
; Return: None
;=============================================================================;
Console_SetTextAttr proto,
    bColorFG: BYTE,
    bColorBG: BYTE

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
