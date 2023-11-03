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
; Details: Measures length of string
; 
; Arguments: String
; Return: Integer length
;=============================================================================;
String_Length proc USES esi, msg:PTR BYTE
    ; String length
    local len:DWORD
    mov len, 0

    ; Begin loop
    mov esi, msg
    jmp _loop_cond

_loop_body:
    inc len
    inc esi
_loop_cond:
    ; Check for null terminator
    cmp BYTE PTR [esi], 0
    jne _loop_body

    ; Return value
    mov eax, len
    ret
String_Length endp

end
