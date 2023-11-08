;=============================================================================;
; const.inc - Game constants
; Author: Trevor Schiff
;=============================================================================;

; Background color table. Index using (dwFlags & kTileFlagClear).
externdef kBgColTable: BYTE
; Foreground color table. Index using dwNumMine.
externdef kFgColTable: BYTE
; Index using dwNumMine to get which character to draw.
externdef kAdjCharTable: BYTE

; Tile font size
externdef kTileFontSize: COORD

; Board dimensions (9x9)
kBoardWidth  EQU 9
kBoardHeight EQU 9

; Number of mines in the board
kNumMine EQU 10

; Text background colors
kBgColHidden EQU white ; Hidden tile
kBgColClear  EQU lightGray      ; Cleared (revealed) tile

; Text foreground colors
kFgColMine  EQU black        ; Mine
kFgColOne   EQU lightBlue    ; One adjacent mine
kFgColTwo   EQU lightGreen   ; Two adjacent mines
kFgColThree EQU lightRed     ; Three adjacent mines
kFgColFour  EQU blue         ; Four adjacent mines
kFgColFive  EQU red          ; Five adjacent mines
kFgColSix   EQU cyan         ; Six adjacent mines
kFgColSeven EQU lightMagenta ; Seven adjacent mines
kFgColEight EQU magenta      ; Eight(!) adjacent mines
