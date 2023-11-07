;=============================================================================;
; game.asm - Game state manager
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
; Game state
dwGameState DWORD ?
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
; Details: Initializes game subsystems
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

    invoke ExitProcess, 0

    ret
Game_Init endp

;=============================================================================;
; Name: Game_Reset
;
; Details: Resets game subsystems (for playing again)
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Game_Reset proc

    ; Reset board
    invoke Board_Init

    ; Reset game state
    mov dwGameState, kGameStatePlay
    mov bDoDraw,     TRUE

    ret
Game_Reset endp

;=============================================================================;
; Name: Game_Update
;
; Details: Steps game state forward once
; 
; Arguments: None
;
; Return: Whether program should exit
;=============================================================================;
Game_Update proc

    ; Call update function that corresponds to the current state
    .IF (dwGameState == kGameStatePlay)
        invoke Game_UpdatePlay
    .ELSEIF (dwGameState == kGameStateWin || dwGameState == kGameStateLose)
        invoke Game_UpdateWinLose
    .ELSE
        ; Unreachable, invalid game state
        ASSERT_TRUE(FALSE)
    .ENDIF

    ret
Game_Update endp

;=============================================================================;
; Name: Game_Draw
;
; Details: Renders game state
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

    ; Draw board
    invoke Board_Draw

    ret
Game_Draw endp

;=============================================================================;
; Name: Game_UpdatePlay
;
; Details: Update game in 'play' state
; 
; Arguments: None
;
; Return: Whether program should exit
;=============================================================================;
Game_UpdatePlay proc

    ;
    ; Locals
    ;
    local dwExitGame: DWORD ; Exit the game after this tick

    ; By default, do not exit after this
    mov dwExitGame, FALSE

    ; Poll input
    invoke Mouse_Poll

    ; Run game logic
    ; TODO

    ; Clear screen and re-draw board
    invoke Clrscr
    invoke Board_Draw

    mov eax, dwExitGame
    ret
Game_UpdatePlay endp

;=============================================================================;
; Name: Game_UpdateWinLose
;
; Details: Update game in 'win' or 'lose' state
; 
; Arguments: None
;
; Return: Whether program should exit
;=============================================================================;
Game_UpdateWinLose proc

    ;
    ; Locals
    ;
    local pbMsg: PTR BYTE ; Message box text
    local dwExitGame: DWORD ; Exit the game after this tick

    ; By default, do not exit after this
    mov dwExitGame, FALSE

    ; Choose message box text based on game result
    .IF (dwGameState == kGameStateWin)
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

    ;
    ; Handle button choice
    ;
    .IF (eax == IDYES)
        invoke Game_Reset    ; 'Yes' selected, play again
    .ELSEIF (eax == IDNO)
        mov dwExitGame, TRUE ; 'No' selected, exit game
    .ELSE
        ASSERT_TRUE(FALSE)   ; Unreachable, invalid button ID
    .ENDIF

    mov eax, dwExitGame
    ret
Game_UpdateWinLose endp

end
