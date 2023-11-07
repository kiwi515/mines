;=============================================================================;
; const.inc - Game constants
; Author: Trevor Schiff
;=============================================================================;

;
; Text color tables
;

; Background color table. Index using (bTiles[n] & kTileFlagClear)
externdef kBgColTable: WORD
; Foreground color table. Index using bAdjacency[n]
externdef kFgColTable: WORD

;
; Tile adjacency character table
;

; Index using bAdjacency[n] to get which character to draw.
externdef kAdjCharTable: BYTE

;
; Game configuration constants
;

; Tile font size
externdef kTileFontSize: COORD
; Board dimensions (9x9)
kBoardWidth  EQU 9
kBoardHeight EQU 9
; Number of mines in the board
kNumMine EQU 10

;
; Text color constants
;

; Text background colors
kBgColHidden EQU lightGray ; Hidden tile
kBgColClear  EQU gray      ; Cleared (revealed) tile
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
