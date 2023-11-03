;=============================================================================;
; main.asm - Program entrypoint
; Author: Trevor Schiff
;=============================================================================;

INCLUDE Irvine32.inc
INCLUDE console.inc

.386
.model flat,stdcall
.stack 4096

.data
sExampleStr BYTE "Example message",0

.code
main proc
    invoke Console_Init
    invoke Console_Print, ADDR sExampleStr

    ; Exit program
    invoke ExitProcess,0
main endp
end main