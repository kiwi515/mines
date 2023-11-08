;=============================================================================;
; game.asm - Game manager
; Author: Trevor Schiff
;=============================================================================;

INCLUDE Irvine32.inc
INCLUDE game.inc

INCLUDE console.inc
INCLUDE board.inc
INCLUDE mouse.inc
INCLUDE const.inc
INCLUDE debug.inc

.386
.model flat,stdcall
.stack 4096

.data
; Whether to draw the current frame
bDoDraw BYTE ?

; Message box title
sMsgTitle BYTE "Game Over",0
; Message box text for each game outcome
sMsgWin   BYTE "Nice job, you won! Play again?",0
sMsgLose  BYTE "Better luck next time! Try again?",0

.code
;=============================================================================;
; Name: Game_Init
;
; Details: Initializes game system
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Game_Init proc

    ; Console must be setup before mouse input
    invoke Console_Init
    invoke Mouse_Init

    ; Set custom font size
    invoke Console_SetFontSize, kTileFontSize

    ; Reset game state
    invoke Game_Reset

    ret
Game_Init endp

;=============================================================================;
; Name: Game_Reset
;
; Details: Resets game system (for playing again)
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Game_Reset proc

    ; Seed Irvines RNG
    invoke Randomize
    
    ; Reset board
    invoke Board_Reset

    ; Draw new board
    mov bDoDraw, TRUE

    ret
Game_Reset endp

;=============================================================================;
; Name: Game_Update
;
; Details: Steps game system forward once
; 
; Arguments: None
;
; Return: Whether program should exit
;=============================================================================;
Game_Update proc

    ; Call update function that corresponds to the current state
    .IF (dwBoardState == kBoardStatePlay)
        invoke _Game_UpdatePlay
    .ELSEIF (dwBoardState == kBoardStateWin || dwBoardState == kBoardStateLose)
        invoke _Game_UpdateWinLose
    .ELSE
        ; Unreachable, invalid game state
        ASSERT_TRUE(FALSE)
    .ENDIF

    ret
Game_Update endp

;=============================================================================;
; Name: Game_Draw
;
; Details: Renders game system
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Game_Draw proc

    ; Should we draw this frame?
    .IF (!bDoDraw)
        ret
    .ENDIF

    ; Clear last frame
    invoke Clrscr

    ; Draw board
    invoke Board_Draw

    mov bDoDraw, FALSE

    ret
Game_Draw endp

;=============================================================================;
; Name: _Game_UpdatePlay
;
; Details: Update system in 'play' state
; 
; Arguments: None
;
; Return: Whether program should exit
;=============================================================================;
_Game_UpdatePlay proc PRIVATE

    local dwExitGame: DWORD ; Exit the game after this tick

    ; By default, do not exit after this
    mov dwExitGame, FALSE

    ; Poll input
    invoke Mouse_Poll

    ; Run game logic
    ; TODO

    mov eax, dwExitGame
    ret
_Game_UpdatePlay endp

;=============================================================================;
; Name: _Game_UpdateWinLose
;
; Details: Update system in 'win' or 'lose' state
; 
; Arguments: None
;
; Return: Whether program should exit
;=============================================================================;
_Game_UpdateWinLose proc PRIVATE

    local pbMsg:      PTR BYTE ; Message box text
    local dwExitGame: DWORD    ; Exit the game after this tick

    ; By default, do not exit after this
    mov dwExitGame, FALSE

    ; Choose message box text based on game result
    .IF (dwBoardState == kBoardStateWin)
        mov pbMsg, OFFSET sMsgWin
    .ELSE
        mov pbMsg, OFFSET sMsgLose
    .ENDIF

    ; Present message box
    invoke MessageBox,
        NULL,                 ; hWnd
        pbMsg,                ; lpText
        ADDR sMsgTitle,       ; lpCaption
        MB_ICONERROR OR MB_OK ; uType

    ; Handle button choice
    .IF (eax == IDYES)
        invoke Game_Reset    ; 'Yes' selected, play again
    .ELSEIF (eax == IDNO)
        mov dwExitGame, TRUE ; 'No' selected, exit game
    .ELSE
        ASSERT_TRUE(FALSE)   ; Unreachable, invalid button ID
    .ENDIF

    mov eax, dwExitGame
    ret
_Game_UpdateWinLose endp

end
