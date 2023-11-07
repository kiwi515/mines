;=============================================================================;
; windows.inc - Windows functionality missing from Irvine's library
; Author: Trevor Schiff
;=============================================================================;

; MOUSE_EVENT_RECORD.dwButtonState
FROM_LEFT_1ST_BUTTON_PRESSED EQU 1h
RIGHTMOST_BUTTON_PRESSED     EQU 2h

; SetConsoleMode:dwMode
ENABLE_EXTENDED_FLAGS EQU 80h
