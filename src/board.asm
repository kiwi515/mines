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
; Whether the first click has happened
bFirstClick BYTE ?

;
; Mine-flag "difference".
; +1 for each mine, -1 for each flag.
;
; A: If non-zero, the game cannot possibly be over.
; B: If zero, the game is over if every mine is flagged.
;
dwMineFlagDiff DWORD ?

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

    ; Reset board state
    mov dwBoardState, kBoardStatePlay
    mov dwMineFlagDiff, 0
    mov bFirstClick, FALSE

    ret
Board_Reset endp

;=============================================================================;
; Name: Board_PlaceMines
;
; Details: Randomly places mines across the board. Cleared tiles are
;          not considered, so this can be called after the initial click. 
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_PlaceMines proc USES eax

    local i: DWORD ; Loop counter
    local x: BYTE ; Random X position
    local y: BYTE ; Random Y position

    ; Place mines randomly
    mov i, 0
    .WHILE (i < kNumMine)
        ;
        ; Generate a random position on the board.
        ;

        ; X position
        mov eax, kBoardWidth
        call RandomRange
        mov x, al

        ; Y position
        mov eax, kBoardHeight
        call RandomRange
        mov y, al

        ;
        ; Mark tile as a mine.
        ;

        ; Get pointer to this tile
        invoke Board_GetTile,
            x, ; bPosX
            y  ; bPosY

        ; Tile should always exist
        ASSERT_FALSE(eax == NULL)

        ; Load tile flags
        mov ebx, (BOARD_TILE_S PTR [eax]).dwFlags

        ; First click is *ALWAYS* safe!!!
        ; To implement this, we generate mines after the first click.
        ; This means we must not place mines on cleared tiles.
        .IF (ebx & kTileFlagClear)
            .CONTINUE
        .ENDIF

        ; Mark as mine
        or (BOARD_TILE_S PTR [eax]).dwFlags, kTileFlagMine

        ; Mine placed!
        inc i
    .ENDW

    ; Set difference for later
    mov dwMineFlagDiff, kNumMine

    ret
Board_PlaceMines endp

;=============================================================================;
; Name: Board_ComputeAdjacency
;
; Details: Computes number of adjacent mines for every tile. 
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Board_ComputeAdjacency proc USES eax ebx

    local bPosX: BYTE
    local bPosY: BYTE

    local i: BYTE
    local j: BYTE

    local pTile: PTR BOARD_TILE_S

    ; Iterate over rows
    mov bPosY, 0
    .WHILE (bPosY < kBoardHeight)
        ; Iterate over columns
        mov bPosX, 0
        .WHILE (bPosX < kBoardWidth)
            ; Get pointer to this tile
            invoke Board_GetTile,
                bPosX, ; bPosX
                bPosY  ; bPosY

            ; This tile should always exist
            ASSERT_FALSE(eax == NULL)
            mov pTile, eax

            ;
            ; Compute mine adjacency by counting the number of
            ; neighboring cells which contain mines.
            ;

            ; Iterate over rows
            mov i, 0
            .WHILE (i < 3)
                ; Iterate over columns
                mov j, 0
                .WHILE (j < 3)

                    ; Subtract 1 from i/j to change range from
                    ; [0, 2] (iteration) to [-1, 1] (offset!!!)
                    mov bh, i
                    mov bl, j
                    sub bh, 1
                    sub bl, 1

                    ; Derive coordinates of adjacent tile
                    add bl, bPosX
                    add bh, bPosY

                    ; Get pointer to neighboring tile
                    invoke Board_GetTile,
                        bl, ; bPosX
                        bh  ; bPosY

                    ; Does the neighboring tile exist?
                    .IF (eax != NULL)
                        ; Load flags of neighbor tile
                        mov ebx, (BOARD_TILE_S PTR [eax]).dwFlags
                        
                        ; Count the mine if it has one
                        .IF (ebx & kTileFlagMine)
                            mov eax, pTile
                            inc (BOARD_TILE_S PTR [eax]).dwNumMine
                        .ENDIF
                    .ENDIF

                    ; Increment counter
                    inc j
                .ENDW

                ; Increment counter
                inc i
            .ENDW

            ; Increment counter
            inc bPosX
        .ENDW

        ; Increment counter
        inc bPosY
    .ENDW

    ret
Board_ComputeAdjacency endp

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
            
            ;
            ; When the player loses, we show all mines.
            ;
            .IF ((ecx & kTileFlagMine) \
                && (dwBoardState == kBoardStateLose))
                ; Set tile attributes
                invoke Console_SetAttr,
                    kFGColorMine, ; bColorFG
                    kBGColorMine, ; bColorBG
                    TRUE          ; bGrid

                ; Draw tile
                invoke Console_PrintChar,
                    kCharMine ; bChar
            ;
            ; Check whether we need to draw the adjacency number, or a symbol.
            ; If the tile is cleared AND is not a mine, then we draw the number.
            ;
            .ELSEIF ((ecx & kTileFlagClear) \
                && !(ecx & kTileFlagMine))
                ; Set tile attributes
                invoke Console_SetAttr,
                    kAdjToColorFG[edx],   ; bColorFG
                    kFlagsToColorBG[ecx], ; bColorBG
                    TRUE                  ; bGrid

                ; Draw tile
                invoke Console_PrintChar,
                    kAdjToChar[edx] ; bChar
            ;
            ; Draw whatever symbol corresponds to this tile.
            ;
            .ELSE
                ; Set tile attributes
                invoke Console_SetAttr,
                    kFlagsToColorFG[ecx], ; bColorFG
                    kFlagsToColorBG[ecx], ; bColorBG
                    TRUE                  ; bGrid

                ; Draw tile
                invoke Console_PrintChar,
                    kFlagsToChar[ecx] ; bChar
            .ENDIF

            ; Increment tile pointer
            add ebx, SIZEOF BOARD_TILE_S

            ; Increment counter
            inc j
        .ENDW

        ; Increment counter
        inc i
    .ENDW

    ; Reset attributes
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

    ; Bounds check
    .IF (bPosX >= kBoardWidth \
        || bPosY >= kBoardHeight)
        mov eax, NULL
        ret
    .ENDIF

    ; Find the index of the tile that was clicked
    mov cx, kBoardWidth
    movzx eax, bPosY
    mul cx           ; Y * WIDTH
    movzx ecx, bPosX
    add eax, ecx     ; X + (Y * WIDTH)

    ; Get pointer to tile
    mov ebx, SIZEOF BOARD_TILE_S
    mul bx                       ; eax = Offset into stBoardTiles
    add eax, OFFSET stBoardTiles ; Offset base address

    ret
Board_GetTile endp

;=============================================================================;
; Name: Board_MouseProc
;
; Details: Processes mouse input event
; 
; Arguments: pstMouseEvt: Pointer to mouse input event
;
; Return: Whether the board should be re-drawn
;=============================================================================;
Board_MouseProc proc USES ebx ecx edx,
    pstMouseEvt: PTR INPUT_RECORD

    local dwButtonState: DWORD ; Mouse click flags
    local bPosX:         BYTE  ; Tile X position
    local bPosY:         BYTE  ; Tile Y position

    ; Load mouse input data
    mov ebx, pstMouseEvt

    ; Save mouse button state
    mov ecx, (INPUT_RECORD PTR [ebx]).Event.dwButtonState
    mov dwButtonState, ecx
    
    ; Convert positions from WORD to BYTE
    movzx ecx, (INPUT_RECORD PTR [ebx]).Event.dwMousePosition.X
    movzx edx, (INPUT_RECORD PTR [ebx]).Event.dwMousePosition.Y
    mov bPosX, cl
    mov bPosY, dl

    ; Position high bytes should never be set (board is not big enough)
    ; Need to make sure though, because if they were, that would break this
    ASSERT_TRUE(ch == 0 && dh == 0)

    ; Handle click
    .IF (dwButtonState & FROM_LEFT_1ST_BUTTON_PRESSED)
        ; Left-click to reveal tiles
        invoke Board_ClearTile,
            bPosX, ; bPosX
            bPosY  ; bPosY
    .ELSEIF (dwButtonState & RIGHTMOST_BUTTON_PRESSED)
        ; Right click to flag tiles (toggle)
        invoke Board_FlagTile,
            bPosX, ; bPosX
            bPosY  ; bPosY
    .ENDIF

    ret
Board_MouseProc endp

;=============================================================================;
; Name: Board_ClearTile
;
; Details: Attempts to clear tile
; 
; Arguments: bPosX: Tile X position.
;            bPosY: Tile Y position.
;
; Return: Whether the board should be re-drawn
;=============================================================================;
Board_ClearTile proc USES ebx ecx,
    bPosX: BYTE,
    bPosY: BYTE

    local dwFlags:   DWORD ; Tile flags
    local dwNumMine: DWORD ; Number of adjacent mines

    local i: BYTE
    local j: BYTE

    ; Get pointer to tile
    invoke Board_GetTile,
        bPosX, ; bPosX
        bPosY  ; bPosY

    ; Does the tile exist?
    .IF (eax == NULL)
        ; Board was not modified and does not need to be re-drawn
        mov eax, FALSE
        ret
    .ENDIF

    ; Load tile flags & mine count
    mov ebx, (BOARD_TILE_S PTR [eax]).dwFlags
    mov dwFlags, ebx
    mov ebx, (BOARD_TILE_S PTR [eax]).dwNumMine
    mov dwNumMine, ebx

    ; Cannot clear tiles that:
    ; 1. Already have been cleared
    ; 2. Are flagged (to prevent accidental clicks)
    .IF ((dwFlags & kTileFlagClear) \
        || (dwFlags & kTileFlagFlagged))
        ; Board was not modified and does not need to be re-drawn
        mov eax, FALSE
        ret
    .ENDIF

    ; Check for mine
    .IF (dwFlags & kTileFlagMine)
        ; Oh no! We just lost the game :(
        mov dwBoardState, kBoardStateLose
    .ENDIF

    ; Set flag to clear tile
    or dwFlags, kTileFlagClear

    ; Save new tile flags
    mov ebx, dwFlags
    mov (BOARD_TILE_S PTR [eax]).dwFlags, ebx

    ; Did we just clear a 'empty' tile (tile with no adjacent mines)?
    .IF ((dwNumMine == 0) && (bFirstClick))
        ;
        ; We must propogate the clear operation to all adjacent empty tiles.
        ; Check all adjacent tiles, and clear ones that are surrounded by NO mines.
        ;

        ; Iterate over rows
        mov i, 0
        .WHILE (i < 3)
            ; Iterate over columns
            mov j, 0
            .WHILE (j < 3)

                ; Subtract 1 from i/j to change range from
                ; [0, 2] (iteration) to [-1, 1] (offset!!!)
                mov ch, i
                mov cl, j
                sub ch, 1
                sub cl, 1

                ; Derive coordinates of adjacent tile
                add cl, bPosX
                add ch, bPosY

                ; Clear adjacent tiles if possible
                invoke Board_PropogateClearTile,
                    cl, ; bPosX
                    ch  ; bPosY

                ; Increment counter
                inc j
            .ENDW

            ; Increment counter
            inc i
        .ENDW
    .ENDIF

    ; First clear operation has happened, we can place mines now.
    .IF (!bFirstClick)
        mov bFirstClick, TRUE
        invoke Board_PlaceMines
        invoke Board_ComputeAdjacency
    .ENDIF

    ; Board WAS modified and should be re-drawn
    mov eax, TRUE
    ret
Board_ClearTile endp

;=============================================================================;
; Name: Board_FlagTile
;
; Details: Attempts to flag tile
; 
; Arguments: bPosX: Tile X position.
;            bPosY: Tile Y position.
;
; Return: Whether the board should be re-drawn
;=============================================================================;
Board_FlagTile proc,
    bPosX: BYTE,
    bPosY: BYTE

    local dwFlags: DWORD ; Tile flags

    ; Get pointer to tile
    invoke Board_GetTile,
        bPosX, ; bPosX
        bPosY  ; bPosY

    ; Does the tile exist?
    .IF (eax == NULL)
        ; Board was not modified and does not need to be re-drawn
        mov eax, FALSE
        ret
    .ENDIF

    ; Load tile flags
    mov ebx, (BOARD_TILE_S PTR [eax]).dwFlags
    mov dwFlags, ebx

    ; Cannot flag tiles that already have been cleared
    .IF (dwFlags & kTileFlagClear)
        ; Board was not modified and does not need to be re-drawn
        mov eax, FALSE
        ret
    .ENDIF

    ; Toggle flag
    xor dwFlags, kTileFlagFlagged

    ; Save new tile flags
    mov ebx, dwFlags
    mov (BOARD_TILE_S PTR [eax]).dwFlags, ebx

    ; Board WAS modified and should be re-drawn
    mov eax, TRUE
    ret
Board_FlagTile endp

;=============================================================================;
; Name: Board_PropogateClearTile
;
; Details: Attempts to propogate clear operation to the specified neighbor
;          tile.
; 
; Arguments: bPosX: Tile X position.
;            bPosY: Tile Y position.
;
; Return: None
;=============================================================================;
Board_PropogateClearTile proc USES eax ebx ecx,
    bPosX: BYTE,
    bPosY: BYTE

    ; Get pointer to tile
    invoke Board_GetTile,
        bPosX, ; bPosX
        bPosY  ; bPosY

    ; Does this tile exist?
    .IF (eax != NULL)
        ; Load tile flags
        mov ebx, (BOARD_TILE_S PTR [eax]).dwFlags
        ; Load adjacent mine count
        mov ecx, (BOARD_TILE_S PTR [eax]).dwNumMine

        ; Propogate the clear operation if:
        .IF (!(ebx & kTileFlagMine)      \ ; 1. Tile is not a mine
            && !(ebx & kTileFlagClear)   \ ; 2. Tile is not cleared
            && !(ebx & kTileFlagFlagged))  ; 3. Tile is not flagged
            invoke Board_ClearTile,
                bPosX, ; bPosX
                bPosY  ; bPosY
        .ENDIF
    .ENDIF

    ret
Board_PropogateClearTile endp

end
