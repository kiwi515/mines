;=============================================================================;
; windows.inc - Windows functionality missing from Irvine's library
; Author: Trevor Schiff
;=============================================================================;

; For MOUSE_EVENT_RECORD.dwButtonState
FROM_LEFT_1ST_BUTTON_PRESSED EQU 1h ; The leftmost mouse button.
RIGHTMOST_BUTTON_PRESSED     EQU 2h ; The rightmost mouse button.

; For SetConsoleMode:dwMode
ENABLE_EXTENDED_FLAGS EQU 80h
