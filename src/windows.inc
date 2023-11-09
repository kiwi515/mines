;=============================================================================;
; windows.inc - Windows functionality missing from Irvine's library
; Author: Trevor Schiff
;=============================================================================;

; For MOUSE_EVENT_RECORD.dwButtonState
FROM_LEFT_1ST_BUTTON_PRESSED EQU 1h ; The leftmost mouse button.
RIGHTMOST_BUTTON_PRESSED     EQU 2h ; The rightmost mouse button.

; For SetConsoleMode:dwMode
ENABLE_EXTENDED_FLAGS EQU 80h

; For CONSOLE_FONT_INFOEX
LF_FACESIZE EQU 32

CONSOLE_FONT_INFOEX STRUCT
    cbSize     DWORD ?
    nFont      DWORD ?
    dwFontSize COORD <>
    FontFamily DWORD ?
    FontWeight DWORD ?
    FaceName   WORD  LF_FACESIZE DUP(?)
CONSOLE_FONT_INFOEX ENDS

;=============================================================================;
; Name: GetCurrentConsoleFontEx
;
; Details: Retrieves extended information about the current console font.
; 
; Arguments: hConsoleOutput:
;               A handle to the console screen buffer
;            bMaximumWindow:
;               If this parameter is TRUE, font information is retrieved for
;               the maximum window size. If this parameter is FALSE, font
;               information is retrieved for the current window size.
;            lpConsoleCurrentFontEx:
;               A pointer to a CONSOLE_FONT_INFOEX structure that receives
;               the requested font information.
;
; Return: If the function succeeds, the return value is nonzero.
;=============================================================================;
GetCurrentConsoleFontEx proto,
    hConsoleOutput: DWORD,
    bMaximumWindow: DWORD,
    lpConsoleCurrentFontEx: PTR CONSOLE_FONT_INFOEX

;=============================================================================;
; Name: SetCurrentConsoleFontEx
;
; Details: Sets extended information about the current console font.
; 
; Arguments: hConsoleOutput:
;               A handle to the console screen buffer
;            bMaximumWindow:
;               If this parameter is TRUE, font information is set for
;               the maximum window size. If this parameter is FALSE,
;               font information is set for the current window size.
;            lpConsoleCurrentFontEx:
;               A pointer to a CONSOLE_FONT_INFOEX structure that contains
;               the font information.
;
; Return: If the function succeeds, the return value is nonzero.
;=============================================================================;
SetCurrentConsoleFontEx proto,
    hConsoleOutput: DWORD,
    bMaximumWindow: DWORD,
    lpConsoleCurrentFontEx: PTR CONSOLE_FONT_INFOEX
