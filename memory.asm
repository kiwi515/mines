;=============================================================================;
; memory.asm - Memory utilities
; Author: Trevor Schiff
;=============================================================================;

INCLUDE Irvine32.inc
INCLUDE const.inc

.386
.model flat,stdcall
.stack 4096

.code
;=============================================================================;
; Name: Memory_Copy
;
; Details: Copies memory
; 
; Arguments: pbDst:  Copy destination
;            pbSrc:  Copy source
;            dwSize: Number of bytes to copy
;
; Return: None
;=============================================================================;
Memory_Copy proc USES eax ebx edx, pbDst: PTR BYTE, pbSrc: PTR BYTE, dwSize: DWORD
    ; Load parameters
    mov eax, pbDst
    mov ebx, pbSrc

    ; Begin loop
    jmp _loop_cond

_loop_body:
    ; Copy current byte
    mov dl, BYTE PTR [ebx]
    mov BYTE PTR [eax], dl

    ; Increment pointers
    inc eax
    inc ebx
    ; Update count
    dec dwSize

_loop_cond:
    cmp dwSize, 0
    jg _loop_body
    
    ret
Memory_Copy endp

;=============================================================================;
; Name: Memory_Set
;
; Details: Sets bytes of memory to a specified value
; 
; Arguments: pbDst:  Destination
;            bVal:   Byte value to set
;            dwSize: Number of bytes to set
;
; Return: None
;=============================================================================;
Memory_Set proc USES eax ebx, pbDst: PTR BYTE, bVal: BYTE, dwSize: DWORD
    ; Load parameters
    mov eax, pbDst
    mov bl,  bVal

    ; Begin loop
    jmp _loop_cond

_loop_body:
    ; Write current byte
    mov BYTE PTR [eax], bl

    ; Increment pointers
    inc eax
    ; Update count
    dec dwSize

_loop_cond:
    cmp dwSize, 0
    jg _loop_body
    
    ret
Memory_Set endp

end
