;=============================================================================;
; console.asm - Console utilities
; Author: Trevor Schiff
;=============================================================================;

INCLUDE Irvine32.inc
INCLUDE console.inc

INCLUDE debug.inc

.386
.model flat,stdcall
.stack 4096

.data
; Window title
sWndTitle BYTE "MASM Minesweeper",0

; stdin handle
dwStdIn  DWORD ?
; stdout handle
dwStdOut DWORD ?
; stderr handle
dwStdErr DWORD ?

.code
;=============================================================================;
; Name: Console_Init
;
; Details: Initializes console handles
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Console_Init proc

    ; Set window title
    invoke SetConsoleTitle,
        ADDR sWndTitle ; lpConsoleTitle
    ASSERT_FALSE(eax == 0)

    ; Acquire stdin
    invoke GetStdHandle,
        STD_INPUT_HANDLE ; nStdHandle
    mov dwStdIn, eax
    ASSERT_TRUE(dwStdIn > 0)

    ; Acquire stdout
    invoke GetStdHandle,
        STD_OUTPUT_HANDLE ; nStdHandle
    mov dwStdOut, eax
    ASSERT_TRUE(dwStdOut > 0)

    ; Acquire stderr
    invoke GetStdHandle,
        STD_ERROR_HANDLE ; nStdHandle
    mov dwStdErr, eax
    ASSERT_TRUE(dwStdErr > 0)

    ret
Console_Init endp

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
Console_SetPos proc USES edx,
    bPosX: BYTE,
    bPosY: BYTE

    ; Call down to Irvine
    mov dh, bPosX
    mov dl, bPosY
    call Gotoxy
    
    ret
Console_SetPos endp

;=============================================================================;
; Name: Console_SetColor
;
; Details: Sets text color
; 
; Arguments: bColorFG: Foreground color
;            bColorBG: Background color
;
; Return: None
;=============================================================================;
Console_SetColor proc USES eax,
    bColorFG: BYTE,
    bColorBG: BYTE

    ; Call down to Irvine
    mov al, bColorFG
    mov ah, bColorBG
    call SetTextColor

    ret
Console_SetColor endp

;=============================================================================;
; Name: Console_SetAttr
;
; Details: Sets text attributes
; 
; Arguments: wAttr: Character attributes
;
; Return: None
;=============================================================================;
Console_SetAttr proc USES eax,
    wAttr: BYTE

    ; Apply attributes to all future text
    invoke SetConsoleTextAttribute,
        dwStdOut, ; hConsoleOutput
        wAttr     ; wAttributes

    ; Check for success
    ASSERT_FALSE(eax == 0)

    ret
Console_SetAttr endp

;=============================================================================;
; Name: Console_Print
;
; Details: Prints string to stdout
; 
; Arguments: pbMsg: Message to print
;
; Return: None
;=============================================================================;
Console_Print proc USES eax,
    pbMsg: PTR BYTE

    ; Get string length
    invoke Str_length,
        pbMsg ; pString

    ; Write string to console
    invoke WriteConsole,
        dwStdOut, ; hConsoleOutput
        pbMsg,    ; lpBuffer
        eax,      ; nNumberOfCharsToWrite
        NULL,     ; lpNumberOfCharsWritten
        NULL      ; lpReserved
    
    ret
Console_Print endp

;=============================================================================;
; Name: Console_PrintChar
;
; Details: Prints character to stdout
; 
; Arguments: bChar: Character to print
;
; Return: None
;=============================================================================;
Console_PrintChar proc,
    bChar: BYTE

    ; Write single character to console
    invoke WriteConsole,
        dwStdOut,     ; hConsoleOutput
        ADDR bChar,   ; lpBuffer
        SIZEOF bChar, ; nNumberOfCharsToWrite
        NULL,         ; lpNumberOfCharsWritten
        NULL          ; lpReserved

    ret
Console_PrintChar endp

end
