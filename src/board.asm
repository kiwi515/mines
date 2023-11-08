;=============================================================================;
; board.asm - Game board
; Author: Trevor Schiff
;=============================================================================;

INCLUDE Irvine32.inc
INCLUDE board.inc

INCLUDE const.inc
INCLUDE console.inc
INCLUDE memory.inc

.386
.model flat,stdcall
.stack 4096

.data
; Board tiles
stBoardTiles BOARD_TILE_S (kBoardWidth * kBoardHeight) DUP(<>)
; Board state
dwBoardState DWORD ?

.code
;=============================================================================;
; Name: Board_Reset
;
; Details: Resets board state
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_Reset proc

    ; Clear tile data
    mMemory_Clear          \
        ADDR stBoardTiles, \ ; pbDst
        SIZEOF stBoardTiles  ; dwSize

    ; Set board state
    mov dwBoardState, kBoardStatePlay

    ret
Board_Reset endp

;=============================================================================;
; Name: Board_Randomize
;
; Details: Randomly places mines across the board. Cleared tiles are
;          not considered, so this can be called after the initial click. 
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_Randomize proc

    ret
Board_Randomize endp

;=============================================================================;
; Name: Board_Draw
;
; Details: Draws board state to the console
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_Draw proc USES eax ebx ecx edx

    local i: DWORD ; Board row
    local j: DWORD ; Board column

    ; Current tile pointer
    mov ebx, OFFSET stBoardTiles

    mov i, 0
    .WHILE (i < kBoardHeight)
        ; Jump cursor to new row
        invoke Console_SetPos,
            0,            ; bPosX
            BYTE PTR [i]  ; bPosY

        mov j, 0
        .WHILE (j < kBoardWidth)
            ; Load flags of current tile
            mov ecx, (BOARD_TILE_S PTR [ebx]).dwFlags
            ; Load adjacency of current tile
            mov edx, (BOARD_TILE_S PTR [ebx]).dwNumMine

            ; Is the tile revealed?
            .IF (ecx & kTileFlagClear)
                ;
                ; Revealed tile
                ;

                ; Set text color for this tile
                invoke Console_SetColor,
                    kFgColTable[ecx], ; bColorFG
                    kBgColTable[ecx]  ; bColorBG

                ; Print cell character
                invoke Console_PrintChar,
                    kAdjCharTable[edx] ; bChar
            .ELSE
                ;
                ; Hidden tile
                ;

                ; Use hidden color constant (& no FG color)
                invoke Console_SetColor,
                    0,           ; bColorFG
                    kBgColHidden ; bColorBG

                ; Empty space to fill cell with BG color
                invoke Console_PrintChar,
                    ' ' ; bChar
            .ENDIF

            ; Increment tile pointer
            add ebx, SIZEOF BOARD_TILE_S

            ; Increment counter
            inc j
        .ENDW

        ; Increment counter
        inc i
    .ENDW

    ; Restore color
    invoke Console_SetColor,
        white, ; bColorFG
        black  ; bColorBG

    ret
Board_Draw endp

end
