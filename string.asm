;=============================================================================;
; string.asm - String utilities
; Author: Trevor Schiff
;=============================================================================;

.386
.model flat,stdcall
.stack 4096

.code
;=============================================================================;
; Name: String_Length
;
; Details: Measures length of string
; 
; Arguments: pbMsg: String to measure
;
; Return: String length
;=============================================================================;
String_Length proc USES esi, pbMsg: PTR BYTE
    ; String length
    local len:DWORD
    mov len, 0

    ; Begin loop
    mov esi, pbMsg
    jmp _loop_body

_loop_post:
    inc len
    inc esi

_loop_body:
    ; Check for null terminator
    cmp BYTE PTR [esi], 0
    jne _loop_post

    ; Return value
    mov eax, len
    ret
String_Length endp

end
