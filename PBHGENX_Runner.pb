; ··············································································
; ··············································································
; ······························· PBHGENX RUNNER ·······························
; ··············································································
; ··············································································
; "PBHGENX_Runner" is a dummy-test runner for PBHGENX: it should set as a tool
; invoked at source-save time. It will check if "<SourceFilename>.pbhgen.pbi"
; (or ".sbi" in case of a SpideBASIC source file) exists: If yes, it calls
; PBHGENX. This prevents PBHGENX from ALWAYS creating a header file.
; The code for this test was separated from the main PBHGENX code (Entry.pb)
; because PBHGENX is part of the PB-XTOOLS collection of tools, which offers
; a single common code for filtering out various tools invocations (for different
; triggering events) and decides which tools should be called, and in which order.
; The actual code that will be calling PBHGENX is to be found in PB-XTOOLS source,
; this file is for testing purposes, and for inclusion in the final PB-XTOOLS.
; ------------------------------------------------------------------------------
; PBHGENX is a fork of PBHGEN (00laboratories) which differs in its behavior:
;  -- Created header files are named:
;     --  "<SourceFilename>.pbhgen.pbi" (PureBASIC)
;     --  "<SourceFilename>.pbhgen.sbi" (SpiderBASIC)
;  -- Creation of an header file will happen only if a header file (named according
;     to the above mentioned pattern) is present. This creation "on demand" prevents
;     creation of unneeded header files.
; ------------------------------------------------------------------------------

; -----------------------------------------------------------------------------
If CountProgramParameters() = 1
  SourceFileName$ = ProgramParameter(0)
Else
  SourceFileName$ = ProgramParameter(0)
  For i=1 To CountProgramParameters() -1
    SourceFileName$ + " " + ProgramParameter(i)
  Next
EndIf

SourceExt.s = GetExtensionPart(SourceFileName$)
Select SourceExt
  Case "pb", "pbi"
    HeaderExt.s = "pbhgen.pbi"
  Case "sb", "sbi"
    HeaderExt.s = "pbhgen.sbi"
  Default
    ; Abort: File extension unknown!
    End
EndSelect

HeaderFileName$ = Left(SourceFileName$, Len(SourceFileName$)-Len(SourceExt)) + HeaderExt

If FileSize(HeaderFileName$) < 0
  ; Abort: No header file exists!
  End
EndIf

; All tests passed ...
; ------------------------------------------------------------------------------
;                                Invoke PBHGEN(X)                               
; ------------------------------------------------------------------------------
CallResult = RunProgram("PBHGENX", SourceFileName$, "")
If Not CallResult
  MessageRequester("PBHGENX ERROR", "Couldn't launch PBHGENX!", #PB_MessageRequester_Error)
EndIf