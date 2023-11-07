;=============================================================================;
; debug.asm - Debugging utilities
; Author: Trevor Schiff
;=============================================================================;

INCLUDE Irvine32.inc
INCLUDE debug.inc

INCLUDE windows.inc

.386
.model flat,stdcall
.stack 4096

.data
; Window title for Win32 error
sTitleWin32 BYTE "Win32 Error",0

.code
;=============================================================================;
; Name: Debug_CheckErrorWin32
;
; Details: Shows the last Win32 error using a message box.
;          Irvine32 already does this but prints it to the console instead.
; 
; Arguments: None
;
; Return: None
;=============================================================================;
Debug_CheckErrorWin32 proc \
    USES eax

    local dwFlags:     DWORD
    local dwMessageId: DWORD
    local pErrMsg:     PTR BYTE
    
    ; Get message ID
    invoke GetLastError
    mov dwMessageId, eax

    ; FormatMessage flags
    ; (Need this so the function call doesnt go over the 512 character limit...)
    mov dwFlags, FORMAT_MESSAGE_ALLOCATE_BUFFER \ ; Windows allocates memory, not me
              OR FORMAT_MESSAGE_FROM_SYSTEM       ; Use system message table

    ; Get message string
    invoke FormatMessage, \
        dwFlags,      \ ; dwFlags
        NULL,         \ ; lpSource
        dwMessageId,  \ ; dwMessageId
        0,            \ ; dwLangaugeId
        ADDR pErrMsg, \ ; lpBuffer
        0,            \ ; nSize
        NULL            ; Arguments

    ; Show message through message box
    invoke MessageBox,     \
        NULL,              \  ; hWnd
        pErrMsg,           \  ; lpText
        ADDR sTitleWin32,  \  ; lpCaption
        MB_ICONERROR OR MB_OK ; uType

    ; Release memory that Windows allocated
    invoke LocalFree, pErrMsg

_no_error:
    ret
Debug_CheckErrorWin32 endp

end
