;=============================================================================;
; debug.inc - Debugging utilities
; Author: Trevor Schiff
;=============================================================================;

;=============================================================================;
;
; NOTE: For some reason, MASM doesnt like certain operations in these assert
;       expressions, such as the not-equal operator (!=).
;
;       So, these assertions must be inverted. For example:
;       ASSERT_TRUE(x != y) -> ASSERT_FALSE(x == y)
;
;       I cannot figure out why this happens, so I made two assert macros.
;
;=============================================================================;

;=============================================================================;
; Name: ASSERT_TRUE
;
; Details: Assertion macro that expects an expression to evaluate to TRUE.
; 
; Arguments: exp: Boolean expression
;
; Return: None
;=============================================================================;
ASSERT_TRUE macro exp
    .IF exp
    .ELSE
        _mDebug_FailAssert %@FileCur, %@Line, "&exp"
    .ENDIF
endm

;=============================================================================;
; Name: ASSERT_FALSE
;
; Details: Assertion macro that expects an expression to evaluate to FALSE.
; 
; Arguments: exp: Boolean expression
;
; Return: None
;=============================================================================;
ASSERT_FALSE macro exp
    .IF exp
        _mDebug_FailAssert %@FileCur, %@Line, "!&exp"
    .ELSE
    .ENDIF
endm

;=============================================================================;
; Name: _mDebug_FailAssert
;
; Details: Private macro, for throwing an assertion error
; 
; Arguments: file: Name of source file containing assertion
;            line: Line in source file where assertion was written
;            exp:  Boolean assertion which did not hold
;
; Return: None
;=============================================================================;
_mDebug_FailAssert macro file, line, exp
    ; Variables must be local to avoid conflict
    local sCaption
    local sMsg
    .data
        ; Window caption
        sCaption BYTE "Assertion Failed!",0
        ; Window message
        sMsg BYTE "Assertion """, exp, """ failed.",0Dh,0Ah, \
            "File: &file, line &line.",0

    ; Back to code
   .code
        ; Show message through message box
        invoke MessageBox,     \
            NULL,              \  ; hWnd
            ADDR sMsg,         \  ; lpText
            ADDR sCaption,     \  ; lpCaption
            MB_ICONERROR OR MB_OK ; uType

        ; Exit program
        invoke ExitProcess, \
            0 ; uExitCode
endm

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
Debug_CheckErrorWin32 proto
