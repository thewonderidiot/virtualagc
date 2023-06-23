### FILE="Main.annotation"
## Copyright:    Public domain.
## Filename:     INTERRUPT_LEAD_INS.agc
## Purpose:      Part of the source code for Aurora (revision 12).
## Assembler:    yaYUL
## Contact:      Ron Burkey <info@sandroid.org>.
## Website:      https://www.ibiblio.org/apollo.
## Mod history:  2016-09-20 JL   Created.
##               2016-10-04 hg   Fix instruction argument, label

                SETLOC          4000
                
                INHINT                                  # GO
                CAF             GOBB
                XCH             BBANK
                TCF             GOPROG
                
                DXCH            ARUPT                   # T6RUPT
                CAF             T6RPTBB
                XCH             BBANK
                TCF             RESUME      +3          # ***FIX LATER***
                
                DXCH            ARUPT                   # T5RUPT
                EXTEND
                DCA             T5LOC                   # T5LOC EQUALS T5ADR
                DTCB
                
                DXCH            ARUPT                   # T3RUPT
                CAF             T3RPTBB
                XCH             BBANK
                TCF             T3RUPT
                
                DXCH            ARUPT                   # T4RUPT
                CAF             ZERO
                TCF             T4RUPT
                EBANK=          TIME3                   ## FIXME: WAS M11
T4RPTBB         BBCON           T4RUPTA

                DXCH            ARUPT                   # KEYRUPT1
                CAF             KEYRPTBB
                XCH             BBANK
                TCF             KEYRUPT1
                
                DXCH            ARUPT                   # KEYRUPT2
                CAF             MKRUPTBB
                XCH             BBANK
                TCF             MARKRUPT
                
                DXCH            ARUPT                   # UPRUPT
                CAF             UPRPTBB
                XCH             BBANK
                TCF             UPRUPT
                
                DXCH            ARUPT                   # DOWNRUPT
                CAF             DWNRPTBB
                XCH             BBANK
                TCF             DODOWNTM
                
                DXCH            ARUPT                   # RADAR RUPT
                CAF             RDRPTBB
                XCH             BBANK
                TCF             RESUME +3               # NOT USED
                
                DXCH            ARUPT                   # HAND CONTROL RUPT
                CA              HCRUPTBB
                XCH             BBANK
                TCF             RESUME +3               # NOT USED
                
                EBANK=          LST1                    # RESTART USES E0, E3
GOBB            BBCON           GOPROG

                EBANK=          TIME1
T6RPTBB         BBCON           RESUME                  # ***FIX LATER***

                EBANK=          LST1
T3RPTBB         BBCON           T3RUPT

                EBANK=          KEYTEMP1
KEYRPTBB        BBCON           KEYRUPT1

                EBANK=          TIME3                   ## FIXME: MRKBUF1
MKRUPTBB        BBCON           MARKRUPT

UPRPTBB         =               KEYRPTBB

                EBANK=          DNTMBUFF
DWNRPTBB        BBCON           DODOWNTM

                EBANK=          TIME1
RDRPTBB         BBCON           RESUME                  # NOT USED

                EBANK=          TIME1
HCRUPTBB        BBCON           RESUME                  # NOT USED

ENDINTFF        EQUALS
