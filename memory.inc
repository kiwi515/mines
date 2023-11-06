;=============================================================================;
; memory.inc - Memory utilities
; Author: Trevor Schiff
;=============================================================================;

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
Memory_Copy proto     \
    pbDst:  PTR BYTE, \
    pbSrc:  PTR BYTE, \
    dwSize: DWORD

;=============================================================================;
; Name: Memory_Set
;
; Details: Initializes memory to a specified value
; 
; Arguments: pbDst:  Destination
;            bVal:   Byte value to set
;            dwSize: Number of bytes to set
;
; Return: None
;=============================================================================;
Memory_Set proto      \
    pbDst:  PTR BYTE, \
    bVal:   BYTE,     \
    dwSize: DWORD

;=============================================================================;
; Name: mMemory_Clear
;
; Details: Zeroes out memory
; 
; Arguments: pbDst:  Destination
;            dwSize: Number of bytes to set
;
; Return: None
;=============================================================================;
mMemory_Clear macro pbDst, dwSize
    invoke Memory_Set, \
        pbDst, \ ; pbDst
        0,     \ ; bVal
        dwSize   ; dwSize
endm
