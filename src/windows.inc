;=============================================================================;
; windows.inc - Windows functionality missing from Irvine's library
; Author: Trevor Schiff
;=============================================================================;

; For MOUSE_EVENT_RECORD.dwButtonState
FROM_LEFT_1ST_BUTTON_PRESSED EQU  1h ; The leftmost mouse button.
RIGHTMOST_BUTTON_PRESSED     EQU  2h ; The rightmost mouse button.
FROM_LEFT_2ND_BUTTON_PRESSED EQU  4h ; The second button from the left.
FROM_LEFT_3RD_BUTTON_PRESSED EQU  8h ; The third button from the left.
FROM_LEFT_4TH_BUTTON_PRESSED EQU 10h ; The fourth button from the left.

; For SetConsoleMode:dwMode
ENABLE_EXTENDED_FLAGS EQU 80h
