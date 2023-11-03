;=============================================================================;
; console.asm - Console utilities
; Author: Trevor Schiff
;=============================================================================;

INCLUDE Irvine32.inc
INCLUDE string.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
dStdin DWORD ?
dStdout DWORD ?
dStderr DWORD ?

.code

;=============================================================================;
; Name: Console_Init
; Details: Initializes console handles
; 
; Arguments: None
; Return: None
;=============================================================================;
Console_Init proc
    ; stdin
    invoke GetStdHandle, STD_INPUT_HANDLE
    mov dStdin, eax

    ; stdout
    invoke GetStdHandle, STD_OUTPUT_HANDLE
    mov dStdout, eax

    ; stderr
    invoke GetStdHandle, STD_ERROR_HANDLE
    mov dStderr, eax

    ret
Console_Init endp

;=============================================================================;
; Name: Console_Print
; Details: Prints string to console (stdout)
; 
; Arguments: Message
; Return: None
;=============================================================================;
Console_Print proc, msg:PTR BYTE
    local len:DWORD

    ; Get string length
    invoke String_Length, msg
    mov len, eax

    ; Write string to console
    invoke WriteConsole, dStdout, msg, len, NULL, NULL
    
    ret
Console_Print endp

end
