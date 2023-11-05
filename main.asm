;=============================================================================;
; main.asm - Program entrypoint
; Author: Trevor Schiff
;=============================================================================;

INCLUDE Irvine32.inc
INCLUDE console.inc

.386
.model flat,stdcall
.stack 4096

.code

;=============================================================================;
; Name: main
; Details: Program entrypoint
; 
; Arguments: None
; Return: None
;=============================================================================;
main proc
    invoke Console_Init

    ; Exit program
    invoke ExitProcess,0
main endp

end main