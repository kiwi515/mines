;=============================================================================;
; board.asm - Game board
; Author: Trevor Schiff
;=============================================================================;

INCLUDE Irvine32.inc
INCLUDE board.inc

INCLUDE const.inc
INCLUDE console.inc
INCLUDE memory.inc
INCLUDE windows.inc
INCLUDE debug.inc

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
; Name: Board_Debug
;
; Details: Truly randomizes the contents of the board, for debugging purposes.
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_Debug proc USES eax ebx
    
    ; Loop counter
    local i: DWORD

    ; Current tile pointer
    mov ebx, OFFSET stBoardTiles

    .WHILE (i < (kBoardWidth * kBoardHeight))
        ; Randomize tile flags
        mov eax, kTileFlagClear OR kTileFlagMine
        call RandomRange
        mov (BOARD_TILE_S PTR [ebx]).dwFlags, eax

        ; Randomize tile adjacency
        mov eax, 3*3
        call RandomRange
        mov (BOARD_TILE_S PTR [ebx]).dwNumMine, eax

        ; Increment tile pointer
        add ebx, SIZEOF BOARD_TILE_S
        ; Increment counter
        inc i
    .ENDW

    ret
Board_Debug endp

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
                invoke Console_SetAttr,
                    kFgColTable[edx], ; bColorFG
                    kBgColTable[ecx], ; bColorBG
                    TRUE              ; bGrid

                ; Print cell character
                invoke Console_PrintChar,
                    kAdjCharTable[edx] ; bChar
            .ELSE
                ;
                ; Hidden tile
                ;

                ; Use hidden color constant (& no FG color)
                invoke Console_SetAttr,
                    0,            ; bColorFG
                    kBgColHidden, ; bColorBG
                    TRUE          ; bGrid

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
    invoke Console_SetAttr,
        white, ; bColorFG
        black, ; bColorBG
        FALSE  ; bGrid

    ret
Board_Draw endp

;=============================================================================;
; Name: Board_GetTile
;
; Details: Gets pointer to tile on the board
; 
; Arguments: bPosX: Tile X position.
;            bPosY: Tile Y position.
;
; Return: Pointer to tile (if possible, otherwise NULL)
;=============================================================================;
Board_GetTile proc USES ebx ecx,
    bPosX: BYTE,
    bPosY: BYTE

    ; Find the index of the tile that was clicked
    mov cx, kBoardWidth
    movzx eax, bPosY
    mul cx           ; Y * WIDTH
    movzx ecx, bPosX
    add eax, ecx     ; X + (Y * WIDTH)

    ; Index bounds check
    .IF (eax > kBoardWidth * kBoardHeight)
        ; Tile out of bounds
        mov eax, NULL
        ret
    .ENDIF

    ; Get pointer to tile
    mov ebx, SIZEOF BOARD_TILE_S
    mul bx                       ; eax = Offset into stBoardTiles
    add eax, OFFSET stBoardTiles ; Offset base address

    ret
Board_GetTile endp

;=============================================================================;
; Name: Board_ModifyTile
;
; Details: Attempt to modify tile on the board
; 
; Arguments: pstMouseEvt: Pointer to mouse input event that caused
;                         this tile modification.
;
; Return: Whether the board should be re-drawn
;=============================================================================;
Board_ModifyTile proc USES ebx ecx edx,
    pstMouseEvt: PTR INPUT_RECORD

    local dwButtonState: DWORD ; Mouse click flags
    local dwTileFlags:   DWORD ; Tile flags
    local dwTileNumMine: DWORD ; Number of adjacent mines
    
    ; Tile position
    local bPosX: BYTE
    local bPosY: BYTE

    ; Load mouse input data
    mov ebx, pstMouseEvt

    ; Save mouse button state
    mov ecx, (INPUT_RECORD PTR [ebx]).Event.dwButtonState
    mov dwButtonState, ecx
    
    ; Convert positions from WORD to BYTE
    movzx ecx, (INPUT_RECORD PTR [ebx]).Event.dwMousePosition.X
    movzx edx, (INPUT_RECORD PTR [ebx]).Event.dwMousePosition.Y
    ; Position high bytes should never be set (board is not big enough)
    ; Need to make sure though, because if they were, that would break this
    ASSERT_TRUE(ch == 0 && dh == 0)
    mov bPosX, cl
    mov bPosY, dl

    ; Get pointer to tile
    invoke Board_GetTile,
        bPosX, ; bPosX
        bPosY  ; bPosY

    ; Does the tile not exist?
    .IF (eax == 0)
        ; Board state was not modified
        mov eax, FALSE
        ret
    .ENDIF

    ; Load tile flags/mine count
    mov ebx, (BOARD_TILE_S PTR [eax]).dwFlags
    mov dwTileFlags, ebx
    mov ebx, (BOARD_TILE_S PTR [eax]).dwNumMine
    mov dwTileNumMine, ebx

    ; If the tile is already revealed, nothing to do
    .IF (dwTileFlags & kTileFlagClear)
        ; Board state was not modified
        mov eax, FALSE
        ret
    .ENDIF

    ;
    ; TODO!!!!
    ; Make functions for clear/flag tile.
    ; PropgateTileClear should be replaced by recursibe Board_ClearTile
    ;

    ; Left-click to reveal tiles
    .IF (dwButtonState & FROM_LEFT_1ST_BUTTON_PRESSED)
        or dwTileFlags, kTileFlagClear

        ; If we just cleared a blank tile,
        ; we must also clear all adjacent blank tiles.
        .IF (dwTileNumMine == 0)
            invoke Board_PropogateTileClear,
                bPosX, ; bPosX
                bPosY ; bPosY
        .ENDIF

    ; Right click to flag tiles (toggle)
    .ELSEIF (dwButtonState & RIGHTMOST_BUTTON_PRESSED)
        xor dwTileFlags, kTileFlagFlagged
    .ENDIF

    ; Save tile flags after modification
    mov ebx, dwTileFlags
    mov (BOARD_TILE_S PTR [eax]).dwFlags, ebx

    ; The board state was modified, re-draw next frame
    mov eax, TRUE
    ret
Board_ModifyTile endp

;=============================================================================;
; Name: Board_PropogateTileClear
;
; Details: Propogates clearing of "zero" tile to all adjacent zero tiles.
; 
; Arguments: bPosX: Tile X position.
;            bPosY: Tile Y position.
;
; Return: None
;=============================================================================;
Board_PropogateTileClear proc,
    bPosX: BYTE,
    bPosY: BYTE
    
    ret
Board_PropogateTileClear endp

end
