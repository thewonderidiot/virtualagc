### FILE="Main.annotation"
## Copyright:    Public domain.
## Filename:     ALARM_AND_ABORT.agc
## Purpose:      Part of the source code for Aurora (revision 12).
## Assembler:    yaYUL
## Contact:      Ron Burkey <info@sandroid.org>.
## Website:      https://www.ibiblio.org/apollo.
## Mod history:  2016-09-20 JL   Created.
##               2016-10-18 MAS  Transcribed.
##               2016-12-08 RSB  Proofed comments with octopus/ProoferComments
##                               but no errors found.

#          THE FOLLOWING SUBROUTINE MAY BE CALLED TO DISPLAY A NON-ABORTIVE ALARM CONDITION. IT MAY BE CALLED
# EITHER IN INTERRUPT OR UNDER EXECUTIVE CONTROL.

#          CALLING SEQUENCE IS AS FOLLOWS:

#          TC     ALARM
#          OCT    AAANN           ALARM NO. NN IN GENERAL AREA AAA.
#                                 (RETURNS HERE)

                SETLOC  ENDPINBF
                EBANK=  FAILREG

ALARM           INHINT
                XCH     Q
                TS      RUPTREG4

                CCS     FAILREG         # SEE IF ONE FAILURE HAS OCCURRED SINCE
                                        #  THE LAST ERROR RESET.
                TC      MULTFAIL        # YES - INDICATE MULTIPLE FAILURES.
                TC      NEWALARM        # FIRST SINCE RESET.

MULTEXIT        CA      RUPTREG4        # FREE RUPTREG4 BEFORE RELINT.
                RELINT
                INDEX   A
                TC      1               # RETURN TO CALLER.

MULTFAIL        AD      OCT40001        # BIT 15 = 1 INDICATES MULTIPLE FAILURES.
                TS      FAILREG
                TC      MULTEXIT

NEWALARM        TC      PROGLARM        # TURN ON THE PROGRAM ALARM LIGHT.

                CAF     PRIO37
                TC      NOVAC
                2CADR   DOALARM         # CALL (SEPARATE) JOB FOR DISPLAY.

                INDEX   RUPTREG4
                CAF     0
                TC      MULTFAIL +1

PROGLARM        CS      OCT40400        # TURN ON PROGRAM ALARM LIGHT VIA OUT0.
                MASK    DSPTAB +11D
                AD      OCT40400
                TS      DSPTAB +11D
                TC      Q

OCT40400        OCT     40400

#          THE FOLLOWING ROUTINE IS CALLED TO INITIATE AN ABORT. FAILREG IS SET (ACCORDING TO THE MULTIPLE
# FAILURES CONVENTION) AND A RE-START IS INITIATED BY TC-SELF. THIS IS CALLED ONLY UNDER RARE CIRCUMSTANCES.

ABORT           INHINT                  # MAY BE CALLED IN INTERRUPT OR UNDER EXEC
                INDEX   Q               # PICK UP FAILURE CODE.
                CAF     0
                TS      ITEMP1

                CCS     FAILREG         # SEE IF THIS IS A MULTIPLE FAILURE.
                TC      SETMULTF        # SET BIT 15 TO INDICATE YES.
                TC      NEWABORT        # FIRST FAILURE.

WHIMPER         TC      WHIMPER         # NOT WITH A BANG...

SETMULTF        AD      OCT40001        # RESTORE AND SET BIT 15.
                TC      +3

NEWABORT        TC      PROGLARM        # FIRST FAILURE - TURN ON ALARM LIGHT.
                XCH     ITEMP1
 +3             TS      FAILREG
                TC      WHIMPER         # UNIVERSAL ABORT LOCATION.

CCSHOLE         XCH     Q
                TS      SFAIL

                TC      ABORT
                OCT     1103

ENDFAILF        EQUALS

#          JOB WHICH CALLS NVSUB FOR ALARM DISPLAY.

                SETLOC  ENDWAITS

DOALARM         TC      GRABWAIT        # DISPLAY FAILREG.
                CAF     FAILDISP
                TC      NVSBWAIT

                TC      EJFREE          # FREE DISPLAY AND END JOB.

FAILDISP        OCT     00531

ENDFAILS        EQUALS
