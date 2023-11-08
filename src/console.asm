;=============================================================================;
; console.asm - Console utilities
; Author: Trevor Schiff
;=============================================================================;

INCLUDE Irvine32.inc
INCLUDE console.inc

INCLUDE debug.inc
INCLUDE windows.inc
INCLUDE memory.inc

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
Console_Init proc USES eax

    ; Set window title
    invoke SetConsoleTitle,
        ADDR sWndTitle ; lpConsoleTitle
    ; Check for success
    ASSERT_FALSE(eax == 0)

    ; Acquire stdin
    invoke GetStdHandle,
        STD_INPUT_HANDLE ; nStdHandle
    mov dwStdIn, eax
    ; Check for success
    ASSERT_TRUE(dwStdIn > 0)

    ; Acquire stdout
    invoke GetStdHandle,
        STD_OUTPUT_HANDLE ; nStdHandle
    mov dwStdOut, eax
    ; Check for success
    ASSERT_TRUE(dwStdOut > 0)

    ; Acquire stderr
    invoke GetStdHandle,
        STD_ERROR_HANDLE ; nStdHandle
    mov dwStdErr, eax
    ; Check for success
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
Console_SetPos proc USES eax edx,
    bPosX: BYTE,
    bPosY: BYTE

    ; Call down to Irvine
    mov dl, bPosX
    mov dh, bPosY
    call Gotoxy
    
    ret
Console_SetPos endp

;=============================================================================;
; Name: Console_SetFontSize
;
; Details: Sets size of the current font
; 
; Arguments: stSize: Font size (width, height)
;
; Return: None
;=============================================================================;
Console_SetFontSize proc USES eax,
    stSize: COORD

    ; Font info structure
    local stInfo: CONSOLE_FONT_INFOEX

    ; Per MS docs:
    ; "This member must be set to sizeof(CONSOLE_FONT_INFOEX)
    ; before calling GetCurrentConsoleFontEx or it will fail."
    mov stInfo.cbSize, SIZEOF stInfo

    ; Get current font info
    invoke GetCurrentConsoleFontEx,
        dwStdOut,   ; hConsoleOutput
        FALSE,      ; bMaximumWindow
        ADDR stInfo ; lpConsoleCurrentFontEx
    ; Check for success
    ASSERT_FALSE(eax == 0)

    ; Insert new font size
    invoke Memory_Copy,
        ADDR stInfo.dwFontSize,  ; pbDst
        ADDR stSize,             ; pbSrc
        SIZEOF stInfo.dwFontSize ; dwSize

    ; Set modified font info
    invoke SetCurrentConsoleFontEx,
        dwStdOut,   ; hConsoleOutput
        FALSE,      ; bMaximumWindow
        ADDR stInfo ; lpConsoleCurrentFontEx
    ; Check for success
    ASSERT_FALSE(eax == 0)

    ret
Console_SetFontSize endp

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
; Name: Console_SetColor
;
; Details: Sets text and background colors
; 
; Arguments: bColorFG: Foreground color
;            bColorBG: Background color
;
; Return: None
;=============================================================================;
Console_SetColor proc USES eax,
    bColorFG: BYTE,
    bColorBG: BYTE

    ; Construct text attribute
    mov ax, 0
    or al, bColorBG
    shl al, 4
    or al, bColorFG

    ; Apply attributes to all future text
    invoke SetConsoleTextAttribute,
        dwStdOut, ; hConsoleOutput
        ax        ; wAttributes

    ; Check for success
    ASSERT_FALSE(eax == 0)

    ret
Console_SetColor endp

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

    ; Check for success
    ASSERT_FALSE(eax == 0)
    
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
Console_PrintChar proc USES eax,
    bChar: BYTE

    ; Write single character to console
    invoke WriteConsole,
        dwStdOut,     ; hConsoleOutput
        ADDR bChar,   ; lpBuffer
        SIZEOF bChar, ; nNumberOfCharsToWrite
        NULL,         ; lpNumberOfCharsWritten
        NULL          ; lpReserved

    ; Check for success
    ASSERT_FALSE(eax == 0)

    ret
Console_PrintChar endp

end
