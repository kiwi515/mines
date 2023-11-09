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
; Name: Console_MoveCursor
;
; Details: Sets cursor position
; 
; Arguments: bPosX: Cursor X-position
;            bPosY: Cursor Y-position
;
; Return: None
;=============================================================================;
Console_MoveCursor proc USES eax edx,
    bPosX: BYTE,
    bPosY: BYTE

    ; Call down to Irvine
    mov dl, bPosX
    mov dh, bPosY
    call Gotoxy
    
    ret
Console_MoveCursor endp

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
Console_ResizeWindow proc USES eax,
    wWidth:  WORD,
    wHeight: WORD

    ; Window dimensions
    local stSize: SMALL_RECT
    
    ; Zero-initialize
    mMemory_Clear    \
        ADDR stSize, \ ; pbDst
        SIZEOF stSize  ; dwSize

    ; Pack dimensions into rect structure
    mov ax, wWidth
    mov stSize.Right, ax
    mov ax, wHeight
    mov stSize.Bottom, ax

    invoke SetConsoleWindowInfo,
        dwStdOut,   ; hConsoleOutput
        TRUE,       ; bAbsolute
        ADDR stSize ; lpConsoleWindow

    ; Check for success
    ASSERT_FALSE(eax == 0)

    ret
Console_ResizeWindow endp

;=============================================================================;
; Name: Console_ShowCursor
;
; Details: Set cursor visibility
; 
; Arguments: bVisible: Whether the cursor should be visible
;
; Return: None
;=============================================================================;
Console_ShowCursor proc USES eax,
    bVisible: BYTE

    ; Cursor info
    local stCursor: CONSOLE_CURSOR_INFO

    ; Get current info
    invoke GetConsoleCursorInfo,
        dwStdOut,     ; hConsoleOutput
        ADDR stCursor ; lpConsoleCursorInfo
    ; Check for success
    ASSERT_FALSE(eax == 0)

    ; Modify visibility
    movzx eax, bVisible ; Need DWORD for Irvine structure
    mov stCursor.bVisible, eax

    ; Set new info
    invoke SetConsoleCursorInfo,
        dwStdOut,     ; hConsoleOutput
        ADDR stCursor ; lpConsoleCursorInfo
    ; Check for success
    ASSERT_FALSE(eax == 0)

    ret
Console_ShowCursor endp

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
Console_SetTextAttr proc USES eax ebx ecx edx,
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
Console_SetTextAttr endp

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
