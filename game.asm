;=============================================================================;
; game.asm - Game state manager
; Author: Trevor Schiff
;=============================================================================;

INCLUDE Irvine32.inc
INCLUDE game.inc

INCLUDE console.inc
INCLUDE board.inc
INCLUDE mouse.inc
INCLUDE debug.inc

.386
.model flat,stdcall
.stack 4096

.data
; Game state
dwGameState DWORD ?

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

    ; Reset game state
    invoke Game_Reset

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

    .IF dwGameState == kGameStatePlay
        invoke Game_UpdatePlay
    .ELSEIF dwGameState == kGameStateWin || dwGameState == kGameStateLose
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

    ; Whether to exit the game after this tick
    local dwExitGame: DWORD

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

    ; Message box text
    local pbMsg: PTR BYTE
    ; Whether to exit the game after this tick
    local dwExitGame: DWORD

    ; By default, do not exit after this
    mov dwExitGame, FALSE

    ; Choose message box text based on game result
    ; TODO

    ; Present message box
    invoke MessageBox,  \
        NULL,           \     ; hWnd
        pbMsg,          \     ; lpText
        ADDR sMsgTitle, \     ; lpCaption
        MB_ICONERROR OR MB_OK ; uType

    ;
    ; Handle button choice
    ;
    .IF eax == IDYES
        ; 'Yes' selected, play again
        invoke Game_Reset
    .ELSEIF eax == IDNO
        ; 'No' selected, exit game
        mov dwExitGame, TRUE
    .ELSE
        ; Unreachable, invalid button ID
        ASSERT_TRUE(FALSE)
    .ENDIF

    mov eax, dwExitGame
    ret
Game_UpdateWinLose endp

end
