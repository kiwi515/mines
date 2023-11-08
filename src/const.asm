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
kBgColTable BYTE  \
    kBgColHidden, \
    kBgColClear

; Foreground color table. Index using dwNumMine.
kFgColTable BYTE \
    kFgColOne,   \
    kFgColTwo,   \
    kFgColThree, \
    kFgColFour,  \
    kFgColFive,  \
    kFgColSix,   \
    kFgColSeven, \
    kFgColEight

; Index using dwNumMine to get which character to draw over the tile.
kAdjCharTable BYTE " 123456789",0

; Tile font size
kTileFontSize COORD <36, 36>

end
