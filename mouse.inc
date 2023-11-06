;=============================================================================;
; mouse.inc - Mouse input
; Author: Trevor Schiff
;=============================================================================;

; Mouse interrupt functions
kMouseIntReset    EQU 0
kMouseIntGetPress EQU 5

; Return values from kMouseIntReset
kMouseNotAvailable EQU 0000h
kMouseAvailable    EQU FFFFh

; Mouse button IDs
kMouseBtnLeft   EQU 0
kMouseBtnRight  EQU 1
kMouseBtnCenter EQU 2

; Mouse button status bits
kMousePressLeft   EQU 1
kMousePressRight  EQU 2
kMousePressCenter EQU 4

; Last mouse click position
externdef wLastClickX: WORD
externdef wLastClickY: WORD

; Last mouse click status
externdef wLastClickFlags: DWORD

;=============================================================================;
; Name: Mouse_Init
;
; Details: Initialize mouse driver
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Mouse_Init proto

;=============================================================================;
; Name: Mouse_Poll
;
; Details: Polls mouse input state
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Mouse_Poll proto
