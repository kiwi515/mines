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
; Background color table. Index using (dwFlags & kTileFlagClear).
kBgColTable WORD  \
    kBgColHidden, \
    kBgColClear

; Foreground color table. Index using dwNumMine.
kFgColTable WORD \
    kFgColOne,   \
    kFgColTwo,   \
    kFgColThree, \
    kFgColFour,  \
    kFgColFive,  \
    kFgColSix,   \
    kFgColSeven, \
    kFgColEight

; Index using dwNumMine to get which character to draw.
kAdjCharTable BYTE "0123456789"

; Tile font size
kTileFontSize COORD <30, 30>

end
