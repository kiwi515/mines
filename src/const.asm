;=============================================================================;
; const.asm - Game constants
; Author: Trevor Schiff
;=============================================================================;

INCLUDE Irvine32.inc
INCLUDE const.inc

.386
.model flat,stdcall
.stack 4096

.data

;
; Index using tile.dwFlags.
;

; Foreground color table
kFlagsToColorFG BYTE \
    kBGColorHidden, \ ; none
    kBGColorClear,  \ ; clear
    kFGColorFlag,   \ ; flag
    0,              \ ; flag & clear (INVALID)
    kBGColorHidden, \ ; mine
    kFGColorMine,   \ ; mine & clear
    0                 ; mine & flag & clear (INVALID)

; Background color table
kFlagsToColorBG BYTE \
    kBGColorHidden, \ ; none
    kBGColorClear,  \ ; clear
    kBGColorHidden, \ ; flag
    0,              \ ; flag & clear (INVALID)
    kBGColorHidden, \ ; mine
    kBGColorMine,   \ ; mine & clear
    0                 ; mine & flag & clear (INVALID)

; Character table
kFlagsToChar BYTE \
    kCharClear, \ ; none
    kCharClear, \ ; clear
    kCharFlag,  \ ; flag
    0,          \ ; flag & clear (INVALID)
    kCharClear, \ ; mine
    kCharMine,  \ ; mine & clear
    0             ; mine & flag & clear (INVALID)

;
; Index using tile.dwNumMine.
;

; Foreground color table
kAdjToColorFG BYTE  \
    kBGColorHidden, \ ; Zero adjacent mines
    kFGColorOne,    \ ; One adjacent mine
    kFGColorTwo,    \ ; Two adjacent mines
    kFGColorThree,  \ ; Three adjacent mines
    kFGColorFour,   \ ; Four adjacent mines
    kFGColorFive,   \ ; Five adjacent mines
    kFGColorSix,    \ ; Six adjacent mines
    kFGColorSeven,  \ ; Seven adjacent mines
    kFGColorEight     ; Eight(!) adjacent mines 

; Character table
kAdjToChar BYTE  \
    kCharClear, \ ; Zero adjacent mines
    '1',        \ ; One adjacent mine
    '2',        \ ; Two adjacent mines
    '3',        \ ; Three adjacent mines
    '4',        \ ; Four adjacent mines
    '5',        \ ; Five adjacent mines
    '6',        \ ; Six adjacent mines
    '7',        \ ; Seven adjacent mines
    '8'           ; Eight(!) adjacent mines 

; Tile font size
kTileFontSize COORD <76, 76>

end
