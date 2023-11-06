;=============================================================================;
; debug.inc - Debugging utilities
; Author: Trevor Schiff
;=============================================================================;

;=============================================================================;
; Name: mDebug_AssertTrue
;
; Details: Assertion macro that expects an expression to evaluate to TRUE.
; 
; Arguments: exp: Boolean expression
;
; Return: None
;=============================================================================;
mDebug_AssertTrue macro exp
    .IF exp
    .ELSE
        ; Show last Win32 error
        invoke Debug_CheckErrorWin32
        
        ; Exit program
        invoke ExitProcess, \
            0 ; uExitCode
    .ENDIF
endm

;=============================================================================;
; Name: mDebug_AssertFalse
;
; Details: Assertion macro that expects an expression to evaluate to FALSE.
; 
; Arguments: exp: Boolean expression
;
; Return: None
;=============================================================================;
mDebug_AssertFalse macro exp
    .IF exp
        ; Show last Win32 error
        invoke Debug_CheckErrorWin32
        
        ; Exit program
        invoke ExitProcess, \
            0 ; uExitCode
    .ELSE
    .ENDIF
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
