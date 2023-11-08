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
; Name: Board_ModifyTile
;
; Details: Attempt to modify tile on the board
; 
; Arguments: pstMouseEvt: Pointer to mouse input event that caused
;                         this tile modification.
;
; Return: Whether the board should be re-drawn
;=============================================================================;
Board_ModifyTile proc USES ebx,
    pstMouseEvt: PTR INPUT_RECORD

    local dwPosX:        DWORD ; Selected tile X-position
    local dwPosY:        DWORD ; Selected tile Y-position
    local dwButtonState: DWORD ; Mouse click flags

    ;
    ; Load mouse input data
    ;
    mov eax, pstMouseEvt
    
    movzx ebx, (INPUT_RECORD PTR [eax]).Event.dwMousePosition.X
    mov dwPosX, ebx
    
    movzx ebx, (INPUT_RECORD PTR [eax]).Event.dwMousePosition.Y
    mov dwPosY, ebx
    
    mov ebx, (INPUT_RECORD PTR [eax]).Event.dwButtonState
    mov dwButtonState, ebx

    ; Find the index of the tile that was clicked
    mov bx,  kBoardWidth
    mov eax, dwPosY
    mul bx
    add eax, dwPosX

    ; Index bounds check
    .IF (eax > kBoardWidth * kBoardHeight)
        mov eax, FALSE
        ret
    .ENDIF

    ; Get pointer to tile
    mov eax, [OFFSET stBoardTiles] + eax * SIZEOF BOARD_TILE_S

    .IF (dwButtonState & FROM_LEFT_1ST_BUTTON_PRESSED)
        ; Left-click to reveal tiles
    .ELSEIF (dwButtonState & RIGHTMOST_BUTTON_PRESSED)
        ; Right click to flag tiles
    .ENDIF

    ; The board state was modified, re-draw next frame
    mov eax, TRUE
    ret
Board_ModifyTile endp

end
