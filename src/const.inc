;=============================================================================;
; const.inc - Game constants
; Author: Trevor Schiff
;=============================================================================;

;
; Index using tile.dwFlags.
;
externdef kFlagsToColorFG: BYTE
externdef kFlagsToColorBG: BYTE
externdef kFlagsToChar: BYTE

;
; Index using tile.dwNumMine.
;
externdef kAdjToColorFG: BYTE
externdef kAdjToChar: BYTE

;
; Game configuration
;

; Board dimensions
; (2:1 ratio because of the text cell width/height)
kBoardWidth  EQU 18
kBoardHeight EQU 9

; Number of mines in the board
; (Approx. one mine every eight tiles)
kNumMine EQU (kBoardWidth * kBoardHeight) / 8

;
; Text character constants
;

kCharClear EQU ' '
kCharFlag  EQU '!'
kCharMine  EQU 'X'

;
; Text color constants
;

; Background colors
kBGColorHidden EQU lightGray  ; Hidden tile
kBGColorClear  EQU white      ; Cleared (revealed) tile
kBGColorMine   EQU lightRed   ; Triggered mine
kBGColorFlag   EQU lightGray  ; Flag

; Foreground colors
kFGColorMine  EQU black        ; Mine
kFGColorFlag  EQU red          ; Flag
kFGColorOne   EQU lightBlue    ; One adjacent mine
kFGColorTwo   EQU lightGreen   ; Two adjacent mines
kFGColorThree EQU lightRed     ; Three adjacent mines
kFGColorFour  EQU blue         ; Four adjacent mines
kFGColorFive  EQU red          ; Five adjacent mines
kFGColorSix   EQU cyan         ; Six adjacent mines
kFGColorSeven EQU lightMagenta ; Seven adjacent mines
kFGColorEight EQU magenta      ; Eight(!) adjacent mines
