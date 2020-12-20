; **********************************************************************
; **  Hardware:  SC114 / SCM                                          **
; **********************************************************************

ORG $8000

LD HL, String_Hello
CALL Print_String_HL
RET

Print_String_HL:
    LD A, (HL)
    OR A
    RET Z
    PUSH HL
    CALL SCM_OutputChar
    POP HL
    INC HL
    JP Print_String_HL

; Utilize the Small Computer Monitor API for outputting character
SCM_OutputChar:
    LD C, 2
    CALL $30
    RET

String_Hello:
	DB "Good day Mr. Hobbit!", $0A, 0 ; $0A = newline

