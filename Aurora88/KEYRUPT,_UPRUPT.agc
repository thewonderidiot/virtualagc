### FILE="Main.annotation"
## Copyright:    Public domain.
## Filename:     KEYRUPT_UPRUPT.agc
## Purpose:      Part of the source code for Aurora (revision 12).
## Assembler:    yaYUL
## Contact:      Ron Burkey <info@sandroid.org>.
## Website:      https://www.ibiblio.org/apollo.
## Mod history:  2016-09-20 JL   Created.
##               2016-12-08 RSB  Proofed comments with octopus/ProoferComments
##                               and fixed the errors found.


                SETLOC  ENDT4S
        
KEYRUPT1        TS      BANKRUPT
                XCH     Q
                TS      QRUPT
                TC      LODSAMPT        # TIME IS SNATCHED IN RUPT FOR NOUN 65.
                CAF     LOW5
                EXTEND 
                RAND    MNKEYIN
KEYCOM          TS      RUPTREG4
                CAF     CHRPRIO
                TC      NOVAC
                EBANK=  DSPCOUNT
                2CADR   CHARIN
                CA      RUPTREG4
                INDEX   LOCCTR
                TS      MPAC            # LEAVE 5 BIT KEY CDE IN MPAC FOR CHARIN
                TC      RESUME

# UPRUPT PROGRAM

UPRUPT          TS      BANKRUPT
                XCH     Q
                TS      QRUPT
                TC      LODSAMPT        # TIME IS SNATCHED IN RUPT FOR NOUN 65.
                CAF     ZERO
                XCH     INLINK
                TS      KEYTEMP1
                CAF     BIT3            # TURN ON UPACT LIGHT
                EXTEND                  # (BIT 3 OF CHANNEL 11)
                WOR     DSALMOUT
UPRUPT1         CAF     LOW5            # TEST FOR TRIPLE CHAR REDUNDANCY
                MASK    KEYTEMP1        # LOW5 OF WORD
                XCH     KEYTEMP1        # LOW5 INTO KEYTEMP1
                XCH     SR              # WHOLE WORD INTO SR
                TS      KEYTEMP2        # ORIGINAL SR INTO KEYTEMP2
                TC      SRGHT5
                MASK    LOW5            # MID 5
                AD      HI10
                TC      UPTEST
                TC      SRGHT5
                MASK    LOW5            # HIGH 5
                COM
                TC      UPTEST
UPOK            TC      RESTORSR        # CODE IS GOOD
                CS      ELRCODE         # IF CODE = ERROR LIGHT RESET, PUT +0
                AD      KEYTEMP1        # INTO BIT1 OF UPLOCK.
                CCS     A               # IF CODE NOT= ELR, PASS CODE ONLY IF
                TC      TSTUPLOK        # BIT1 OF UPLOCK = 0.
ELRCODE         OCT     22
                TC      TSTUPLOK
                CS      BIT1            # PUT 0 INTO BIT1 OF UPLOCK
                MASK    UPLOCK
                TS      UPLOCK
                TC      ACCEPTUP
TSTUPLOK        CAF     BIT1
                MASK    UPLOCK
                CCS     A
                TC      RESUME          # BIT1 OF UPLOCK = 1.
ACCEPTUP        XCH     KEYTEMP1        # BIT1 OF UPLOCK = 0.
                TC      KEYCOM
         
TMFAIL2         TC      RESTORSR        # CODE IS BAD
                CS      BIT1            # LOCK OUT FURTHER UPLINK ACTIVITY (BY
                MASK    UPLOCK          # PUTTING 1 INTO BIT1 OF UPLOCK) UNTIL ELR
                AD      BIT1            # IS SENT UP UPLINK.
                TS      UPLOCK
TMFAIL1         TC      TMALM
                TC      RESUME
RESTORSR        XCH     KEYTEMP2
                DOUBLE
                TS      SR
                TC      Q
         
TMALM           =       RESUME          # FOR NOW

SRGHT5          CS      SR
                CS      SR
                CS      SR
                CS      SR
                CS      SR
                CS      A
                TC      Q               # DELIVERS WORD UNCOMPLEMENTED
          
UPTEST          AD      KEYTEMP1
                CCS     A
                TC      TMFAIL2
HI10            OCT     77740
                TC      TMFAIL2
                TC      Q
                
# UPACT IS TURNED OFF BY VBRELDSP, ALSO BY ERROR LIGHT RESET.       
# THE RECEPTION OF A BAD CODE BY UPLINK LOCKS OUT FURTHER UPLINK ACTIVITY
# BY PLACING A 1 INTO BIT1 OF UPLOCK. BIT9 (ALONG WITH BIT11) OF TMKEYBUF
# IS SET TO 1 TO SEND AN INDICATION OF THIS SITUATION DOWN THE DOWNLINK.
# THE UPLINK INTERLOCK IS ALLOWED WHEN AN ERROR LIGHT RESET CODE IS SENT
# UP THE UPLINK, OR WHEN A FRESH START IS PERFORMED.

## FIXME PATCHES
4SECS           DEC     400

GOPROG1         INCR    REDOCTR         # ADVANCE RESTART COUNTER.

                CA      ERESTORE
                EXTEND
                BZF     +5

                EXTEND                  # RESTORE B(X) AND B(X+1) IF RESTART
                DCA     SKEEP5          # HAPPENED WHILE SELF-CHECK HAD REPLACED
                NDX     SKEEP7          # THEM WITH CHECKING WORDS.
                DXCH    0000

                TC      GOPROG +1

STARTSB1        TS      ERESTORE
                CAF     PRIO34          # ENABLE INTERRUPTS.
                TC      STARTSB2

UNZ2B           TC      IBNKCALL        # TURN OFF NO ATT LAMP.
                CADR    NOATTOFF
                TC      ZEROICDU
                TC      UNZ2 +1

OPONLY1         CAF     BIT4            # IF OPERATE ON ONLY, AND WE ARE IN COARSE
                EXTEND                  # ALIGN, DONT ZERO THE CDUS BECAUSE WE
                RAND    CHAN12          # MIGHT BE IN GIMBAL LOCK.
                CCS     A
                TCF     C33TEST

                CAF     IMUSEFLG        # OTHERWISE, ZERO THE COUNTERS
                TC      OPONLY +1       # UNLESS SOMEONE IS USING THE IMU.

CAGESUB3        CS      OC40010
                MASK    DSPTAB +11D
                AD      OC40010
                TS      DSPTAB +11D
CAGESUB4        CS      OCT75
                TCF     CAGESUB2 +1

OC40010         OCT     40010
 
ENDKRURS        EQUALS