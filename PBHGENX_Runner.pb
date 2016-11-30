; ··············································································
; ··············································································
; ······························· PBHGENX RUNNER ·······························
; ··············································································
; ··············································································
; PBHGENX v5.50a (= PBHGEN v5.43)
; [ 2016-11-30 ]
; ------------------------------------------------------------------------------
; "PBHGENX_Runner" is a boilerplate code and test-runner for PBHGENX:
; It should be set as a tool invoked at source-save time. It will check for the
; existence of a "<SourceFilename>.pbhgen.pbi" (or ".sbi" for SpideBASIC):
; If yes, it calls PBHGENX and passes on to it the arguments.
; This prevents PBHGENX from ALWAYS creating a header file.
; The code for this test was separated from the main PBHGENX code (Entry.pb)
; because PBHGENX is part of the PB-XTOOLS collection of tools, which aims to use
; a single common code for filtering out various tools invocations (for different
; triggering events) and decide which tools should be called, and in which order.
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
;  -- Some differences in the comments within the generated header file.
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
  Err$ =  ~"Couldn't launch PBHGENX!\n"+
          ~"Retry, and if the problem persists check PBHGENX settings.\n"+
          ~"Or consider disabling this tool until the problem is fixed:\n"+
          ~"(go to menu: \"Tools\" -> \"Configure Tools…\")"
  MessageRequester("PBHGENX ERROR", Err$, #PB_MessageRequester_Error)
EndIf