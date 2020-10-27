### FILE="Main.annotation"
## Copyright:    Public domain.
## Filename:     T4RUPT_PROGRAM.agc
## Purpose:      Part of the source code for Aurora (revision 12).
## Assembler:    yaYUL
## Contact:      Ron Burkey <info@sandroid.org>.
## Website:      https://www.ibiblio.org/apollo.
## Mod history:  2016-09-20 JL   Created.
##               2016-10-12 HG   fix operand  DSPRUPTSW -> DSRUPTSW
##               2016-10-15 HG   fix operand  DSPRUPTEM -> DSRUPTEM
##                                            SEDTISSW  -> SETISSW 
##                                            GLOCKKOK  -> GLOCKOK 
##                                            NCTFL33   -> NXTFL33  
##                                            BITS56&15 -> BITS6&15 
##                                            COSMSG    -> COSMG   
##                               fix label and operand
##                                            NXTIBIT   -> NTXIBT
##                                            GLOCKON   -> GLOCKOK
##		 2016-12-08 RSB	 Proofed comments with octopus/ProoferComments
##				 and fixed the errors found.

## This source code has been transcribed or otherwise adapted from
## digitized images of a hardcopy from the private collection of 
## Don Eyles.  The digitization was performed by archive.org.

## Notations on the hardcopy document read, in part:

##       473423A YUL SYSTEM FOR BLK2: REVISION 12 of PROGRAM AURORA BY DAP GROUP
##       NOV 10, 1966

##       [Note that this is the date the hardcopy was made, not the
##       date of the program revision or the assembly.]

## The scan images (with suitable reduction in storage size and consequent 
## reduction in image quality) are available online at 
##       https://www.ibiblio.org/apollo.  
## The original high-quality digital images are available at archive.org:
##       https://archive.org/details/aurora00dapg

                SETLOC          ENDPHMNF
                EBANK=          3                       ## FIXME
T4RUPT          EXTEND                                  # ZERO OUT0 EVERY T4RUPT.
                WRITE           OUT0                    # (COMES HERE WITH +0 IN A)

                INDEX           T4LOC                   # NORMALLY TO NORMT4, BUT TO LMPRESET OR
                TCF             0                       # DSKYRSET AFTER OUT0 COMMAND.

NORMT4          CCS             DSRUPTSW                # GOES 7(-1)0.
                TCF             +2
                CAF             SEVEN
                TS              DSRUPTSW

                CAF             T4RPTBB                 # OFF TO SWITCHED BANK
                XCH             BBANK
                TCF             T4RUPTA

LMPRESET        CAF             90MRUPT                 # 30 MS ON / 90 MS OFF.
                TCF             +2

DSKYRSET        CAF             100MRUPT                # 20 MS ON / 100 MS OFF.
                TS              TIME4
                CAF             LNORMT4
                TS              T4LOC
                TCF             NOQBRSM

90MRUPT         DEC             16375
100MRUPT        DEC             16374
LNORMT4         ADRES           NORMT4
74K             OCT             74000

# RELTAB IS A PACKED TABLE. RELAYWORD CODE IN UPPER 4 BITS, RELAY CODE
# IN LOWER 5 BITS.

RELTAB          OCT             04025
                OCT             10003
                OCT             14031
                OCT             20033
                OCT             24017
                OCT             30036
                OCT             34034
                OCT             40023
                OCT             44035
                OCT             50037
                OCT             54000
RELTAB11        OCT             60000
ENDT4FF         EQUALS

#          SWITCHED-BANK PORTION.

                SETLOC          ENDFRESS

T4RUPTA         TS              BANKRUPT
                EXTEND
                QXCH            QRUPT

LMPOUT          CCS             LMPCMD                  # SEE IF LMP COMMAND TO BE SENT. IF SO,
                TCF             CDRVE                   # BIT 15 = 1 AND (UP TO) BITS 1 - 11
                TCF             CDRVE                   # CONTAIN THE COMMAND.

                CAF             LOW11
                MASK            LMPCMD                  # LEAVE COMMAND PORTION INTACT.
                TS              LMPCMD
                AD              74K
                EXTEND
                WRITE           OUT0

                CAF             LLMPRS
                TS              T4LOC
                CAF             30MRUPT
                TCF             SETTIME4

CDRVE           CCS             DSPTAB          +11D
                TC              DSPOUT
                TC              DSPOUT

                XCH             DSPTAB          +11D
                MASK            LOW11
                TS              DSPTAB          +11D
                AD              RELTAB11
                TC              DSPLAYC

# DSPOUT PROGRAM. PUTS OUT DISPLAYS.

DSPOUT          CCS             NOUT                    # DRIVE DISPLAY SYSTEM RELAYS.
                TCF             +3

NODSPOUT        CAF             120MRUPT                # SET FOR RUPT IN 120 MS IF NO RELAYS.
                TCF             SETTIME4

                TS              NOUT
                CS              ZERO
                TS              DSRUPTEM                # SET TO -0 FOR 1ST PASS THRU DSPTAB
                XCH             DSPCNT
                AD              NEG0                    # TO PREVENT +0
                TS              DSPCNT
DSPSCAN         INDEX           DSPCNT
                CCS             DSPTAB
                CCS             DSPCNT                  # IF DSPTAB ENTRY +, SKIP
                TC              DSPSCAN         -2      # IF DSPCNT +, AGAIN
                TC              DSPLAY                  # IF DSPTAB ENTRY -, DISPLAY
TABLNTH         OCT             12                      # DEC 10   LENGTH OF DSPTAB
                CCS             DSRUPTEM                # IF DSRUPTEM=+0,2ND PASS THRU DSPTAB
120MRUPT        DEC             16372                   # (DSPCNT = 0). +0 INTO NOUT.
                TS              NOUT
                TCF             NODSPOUT
                TS              DSRUPTEM                # IF DSRUPTEM=-0,1ST PASS THRU DSPTAB
                CAF             TABLNTH                 # (DSPCNT=0). +0 INTO DSRUPTEM. PASS AGAIN
                TC              DSPSCAN         -1

DSPLAY          AD              ONE
                INDEX           DSPCNT
                TS              DSPTAB                  # REPLACE POSITIVELY
                MASK            LOW11                   # REMOVE BITS 12 TO 15
                TS              DSRUPTEM
                CAF             HI5
                INDEX           DSPCNT
                MASK            RELTAB                  # PICK UP BITS 12 TO 15 OF RELTAB ENTRY
                AD              DSRUPTEM
DSPLAYC         EXTEND
                WRITE           OUT0

                CAF             LDSKYRS
                TS              T4LOC
                CAF             20MRUPT

SETTIME4        TS              TIME4
# JUMP TO APPROPRIATE ONCE-PER SECOND (.96 SEC ACTUALLY) ACTIVITY

T4JUMP          INDEX           DSRUPTSW
                TCF             +1

                TC              ALTOUT

                TCF             
                TCF             IMUMON
                TCF             
                TC              ALTROUT
                TCF             
                TCF             IMUMON
                TCF             
LDSKYRS         ADRES           DSKYRSET
LLMPRS          ADRES           LMPRESET

30MRUPT         DEC             16381
20MRUPT         DEC             16382
# THIS ROUTINE SERVICES THE METER OUTPUTS.


# DIDFLG INDICATES THE STATE OF THE PROGRAM..............
# IF GREATER THAN ZERO, THEN UNABLE TO DISPLAY DATA
# IF EQUAL TO ZERO, THEN THE PROGRAM IS IN USE
# IF LESS THAN ZERO, THEN THE PROGRAM IS ABLE TO BE USED............

ALTOUT          TC              DISINDAT
                CS              BIT2
                EXTEND
                WAND            14                      # SET UP OUTPUT FOR ALTITUDE
                CCS             ALT                     # -1 IF OLD DATA TO BE EXTRAPOLATED.
                TCF             +4                      # NEW DATA.
                TCF             +3
                TCF             OLDDATA

                TS              ALT                     # CHANGE -0 IN ALT TO +0.
                CS              ONE                     # RESET ALTSAVE.
                DXCH            ALT
ZDATA2          DXCH            ALTSAVE
                TCF             NEWDATA

OLDDATA         CA              ALTRATE                 # USE ALTRATE TO EXTRAPOLATE.
                EXTEND
                MP              ARTOA                   # RATE APPLIES FOR .96 SEC.
                AD              ALTSAVE         +1
                TS              ALTSAVE         +1      # AND MAYBE SKIP.
                CAF             ZERO
                ADS             ALTSAVE

                CAF             POSMAX                  # FORCE SIGN AGREEMENT ASSUMING ALTSAVE IS
                AD              ONE                     # NOT NEGATIVE. IF IT IS, THE FINAL TS
                AD              ALTSAVE         +1      # WILL NOT SKIP AND WE CAN SET ALTSAVE TO
                TS              ALTSAVE         +1      # ZERO IN THAT CASE.
                CAF             ZERO
                AD              POSMAX
                AD              ALTSAVE
                TS              ALTSAVE
                TCF             ZERODATA                # ALTSAVE NEGATIVE - SET TO ZERO.

NEWDATA         CCS             ALTSAVE                 # MAKE UP 15 BIT UNSIGNED OUTPUT.
                CAF             BIT15                   # MAJOR PART +1 OR +0.
                AD              ALTSAVE         +1
METEROUT        TS              ALTM
                CAF             BITSET
                EXTEND
                WOR             14
                TCF             DONEDID
ALTROUT         TC              DISINDAT
                CAF             BIT2
                EXTEND
                WOR             14                      # SET UP OUTPUT FOR ALT. RATE
                CA              ALTRATE
                TCF             METEROUT

DISINDAT        CCS             DIDFLG
                TCF             DONEDID
                NOOP
                CAF             BIT6
                EXTEND
                RAND            30                      # CHECK DISPLAY INERTIAL DATA BIT
                CCS             A
                TCF             ALLDONE
                CCS             DIDFLG
                NOOP
                TCF             GOAGN

FIRSTIME        CAF             BIT8
                EXTEND
                WOR             12                      # ENABLE DISPLAY INERTIAL DATA
                CAF             ZERO
                TS              DIDFLG
                TS              LASTXCMD
                TS              LASTYCMD
                CAF             SIX
                TC              WAITLIST
                2CADR           INTLZE

                TC              DONEDID

INTLZE          CAF             BIT2
                EXTEND
                WOR             12                      # ENABLE RR ERROR COUNTER
                TC              TASKOVER

GOAGN           CS              LASTXCMD
                AD              FORVEL
                TS              OPTXCMD
                CA              FORVEL
                TS              LASTXCMD
                CS              LASTYCMD
                AD              LATVEL
                TS              OPTYCMD
                CA              LATVEL
                TS              LASTYCMD
                TC              Q

ALLDONE         CS              DIDRESET                # REMOVE DISPLAY INERTIAL DATA AND ECTR.
                EXTEND
                WAND            12                      # RESET RR ERROR COUNTER
DONEDID         TCF             
ZERODATA        CAF             ZERO
                TS              L
                TCF             ZDATA2

ARTOA           DEC             .20469                  # ALT DUE TO ALTRATE FOR .96 SEC.
BITSET          OCT             6004

DIDRESET        OCT             202
# IMU INBIT MONITOR - ENTERED EVERY 480 MS BY T4RUPT.

IMUMON          CA              IMODES30                # SEE IF THERE HAS BEEN A CHANGE IN THE
                EXTEND                                  # RELEVENT BITS OF CHAN 30.
                RXOR            30
                MASK            30RDMSK
                EXTEND
                BZF             TNONTEST                # NO CHANGE IN STATUS.

                TS              RUPTREG1                # SAVE BITS WHICH HAVE CHANGED.
                LXCH            IMODES30                # UPDATE IMODES30.
                EXTEND
                RXOR            L
                TS              IMODES30

                CS              ONE
                XCH             RUPTREG1
                EXTEND
                BZMF            TLIM                    # CHANGE IN IMU TEMP.
                TCF             NXTIFBIT                # BEGIN BIT SCAN.

 -1             AD              ONE                     # (RE-ENTERS HERE FROM NXTIFAIL.)
NXTIFBIT        INCR            RUPTREG1                # ADVANCE BIT POSITION NUMBER.
 +1             DOUBLE
                TS              A                       # SKIP IF OVERFLOW.
                TCF             NXTIFBIT                # LOOK FOR BIT.

                XCH             RUPTREG2                # SAVE OVERFLOW-CORRECTED DATA.
                INDEX           RUPTREG1                # SELECT NEW VALUE OF THIS BIT.
                CAF             BIT14
                MASK            IMODES30
                INDEX           RUPTREG1
                TC              IFAILJMP

NXTIFAIL        CCS             RUPTREG2                # PROCESS ANY ADDITIONAL CHANGES.
                TCF             NXTIFBIT        -1

TNONTEST        CS              IMODES30                # AFTER PROCESSING ALL CHANGES, SEE IF IT
                MASK            BIT7                    # IS TIME TO ACT ON A TURN-ON SEQUENCE.
                CCS             A
                TCF             C33TEST                 # NO - EXAMINE CHANNEL 33.

                CAF             BIT8                    # SEE IF FIRST SAMPLE OR SECOND.
                MASK            IMODES30
                CCS             A
                TCF             PROCTNON                # REACT AFTER SECOND SAMPLE.

                CAF             BIT8                    # IF FIRST SAMPLE, SET BIT TO REACT NEXT
                ADS             IMODES30                # TIME.
                TCF             C33TEST
# PROCESS IMU TURN-ON REQUESTS AFTER WAITING 1 SAMPLE FOR ALL SIGNALS TO ARRIVE.

PROCTNON        CS              BITS7&8
                MASK            IMODES30
                TS              IMODES30
                MASK            BIT14                   # SEE IF TURN-ON REQUEST.
                CCS             A
                TCF             OPONLY                  # OPERATE ON ONLY.

                CS              IMODES30                # IF TURN-ON REQUEST, WE SHOULD HAVE IMU
                MASK            BIT9                    # OPERATE.
                CCS             A
                TCF             +3

                TC              ALARM                   # ALARM IF NOT.
                OCT             213

 +3             TC              CAGESUB
                CAF             90SECS
                TC              WAITLIST
                2CADR           ENDTNON
                TCF             C33TEST

RETNON          CAF             90SECS
                TC              VARDELAY

ENDTNON         CS              BIT2                    # RESET TURN-ON REQUEST FAIL BIT.
                MASK            IMODES30
                XCH             IMODES30
                MASK            BIT2                    # IF IT WAS OFF, SEND ISS DELAY COMPLETE.
                EXTEND
                BZF             ENDTNON2

                CAF             BIT14                   # IF IT WAS ON AND TURN-ON REQUEST NOW
                MASK            IMODES30                # PRESENT, RE-ENTER 90 SEC DELAY IN WL.
                EXTEND
                BZF             RETNON

                CS              STATE                   # IF IT IS NOT ON NOW, SEE IF A PROG WAS
                MASK            IMUSEFLG                # WAITING.
                CCS             A
                TCF             TASKOVER
                TC              POSTJUMP
                CADR            IMUBAD                  # UNSUCCESSFUL TURN-ON.

ENDTNON2        CAF             BIT15                   # SEND ISS DELAY COMPLETE.
                EXTEND
                WOR             12
UNZ2            TC              ZEROICDU

                CS              BITS4&5                 # REMOVE ZERO AND COARSE.
                EXTEND
                WAND            12

                CAF             3SECS                   # ALLOW 3 SECS FOR COUNTER TO FIND GIMBAL.
                TC              VARDELAY

ISSUP           CS              OCT54                   # REMOVE CAGING, IMU FAIL INHIBIT, AND
                MASK            IMODES30                # ICDUFAIL INHIBIT FLAGS.
                TS              IMODES30

                TC              SETISSW                 # ISS WARNING MIGHT HAVE BEEN INHIBITED.

                CS              BIT15                   # REMOVE IMU DELAY COMPLETE DISCRETE.
                EXTEND
                WAND            12

                CAF             BIT11                   # DONT ENABLE PROG ALARM ON PIP FAIL FOR
                TC              WAITLIST                # ANOTHER 10 SECS.
                2CADR           PFAILOK
                CS              STATE                   # SEE IF ANYONE IS WAITING FOR THE IMU AT
                MASK            IMUSEFLG                # IMUZERO. IF SO, WAKE THEM UP.
                CCS             A
                TCF             TASKOVER

                TC              POSTJUMP
                CADR            ENDIMU

OPONLY          CAF             IMUSEFLG                # IF OPERATE ON ONLY, ZERO THE COUNTERS
                MASK            STATE                   # UNLESS SOMEONE IS USING THE IMU.
                CCS             A
                TCF             C33TEST

                TC              CAGESUB2                # SET TURNON FLAGS.

                CAF             BIT5
                EXTEND
                WOR             12

                CAF             BIT6                    # WAIT 300 MS FOR AGS TO RECEIVE SIGNAL.
                TC              WAITLIST
                2CADR           UNZ2
                TCF             C33TEST
# MONITOR CHANNEL 33 FLIP-FLOP INPUTS.

C33TEST         CA              IMODES33                # SEE IF RELEVENT CHAN33 BITS HAVE
                MASK            33RDMSK
                TS              L                       # CHANGED.
                CAF             33RDMSK
                EXTEND
                WAND            33                      # RESETS FLIP-FLOP INPUTS.
                EXTEND
                RXOR            L
                EXTEND
                BZF             GLOCKMON                # ON NO CHANGE.

                TS              RUPTREG1                # SAVE BITS WHICH HAVE CHANGED.
                LXCH            IMODES33
                EXTEND
                RXOR            L
                TS              IMODES33                # UPDATED IMODES33.

                CAF             ZERO
                XCH             RUPTREG1
                DOUBLE
                TCF             NXTIBT          +1      # SCAN FOR BIT CHANGES.

 -1             AD              ONE
NXTIBT          INCR            RUPTREG1
 +1             DOUBLE
                TS              A                       # (CODING IDENTICAL TO CHAN 30).
                TCF             NXTIBT

                XCH             RUPTREG2
                INDEX           RUPTREG1                # GET NEW VALUE OF BIT WHICH CHANGED.
                CAF             BIT13
                MASK            IMODES33
                INDEX           RUPTREG1
                TC              C33JMP

NXTFL33         CCS             RUPTREG2                # PROCESS POSSIBLE ADDITIONAL CHANGES.
                TCF             NXTIBT          -1
# MONITOR FOR GIMBAL LOCK.

GLOCKMON        CCS             CDUZ
                TCF             GLOCKCHK                # SEE IF MAGNITUDE OF MGA IS GREATER THAN
                TCF             SETGLOCK                # 70 DEGREES.
                TCF             GLOCKCHK
                TCF             SETGLOCK

GLOCKCHK        AD              -70DEGS
                EXTEND
                BZMF            SETGLOCK        -1      # NO LOCK.

                CAF             BIT6                    # GIMAL LOCK.
                TCF             SETGLOCK

 -1             CAF             ZERO
SETGLOCK        AD              DSPTAB          +11D    # SEE IF PRESENT STATE OF GIMBAL LOCK LAMP
                MASK            BIT6                    # AGREES WITH DESIRED STATE BY HALF ADDING
                EXTEND                                  # THE TWO.
                BZF             GLOCKOK                 # OK AS IS.

                MASK            DSPTAB          +11D    # IF OFF, DONT TURN ON IF IMU BEING CAGED.
                CCS             A
                TCF             GLAMPTST                # TURN OFF UNLESS LAMP TEST IN PROGRESS.

                CAF             BIT6
                MASK            IMODES30
                CCS             A
                TCF             GLOCKOK

GLINVERT        CS              DSPTAB          +11D    # INVERT GIMBAL LOCK LAMP.
                MASK            BIT6
                AD              BIT15                   # TO INDICATE CHANGE IN DSPTAB +11D.
                XCH             DSPTAB          +11D
                MASK            OCT37737
                ADS             DSPTAB          +11D
                TCF             GLOCKOK

GLAMPTST        TC              LAMPTEST                # TURN OFF UNLESS LAMP TEST IN PROGRESS.
                TCF             GLOCKOK
                TCF             GLINVERT

-70DEGS         DEC             -.38888                 # -70 DEGREES SCALED IN HALF-REVOLUTIONS.
OCT37737        OCT             37737
# SUBROUTINES TO PROCESS INBIT CHANGES. NEW VALUE OF BIT ARRIVES IN A, EXCEPT FOR TLIM.

TLIM            MASK            POSMAX                  # REMOVE BIT FROM WORD OF CHANGES AND SET
                TS              RUPTREG2                # DSKY TEMP LAMP ACCORDINGLY.

                CCS             IMODES30
                TCF             TEMPOK
                TCF             TEMPOK

                CAF             BIT4                    # TURN ON LAMP.
                EXTEND
                WOR             11
                TCF             NXTIFAIL

TEMPOK          TC              LAMPTEST                # IF TEMP NOW OK, DONT TURN OFF LAMP IF
                TCF             NXTIFAIL                # LAMP TEST IN PROGRESS.

                CS              BIT4
                EXTEND
                WAND            11
                TCF             NXTIFAIL

ITURNON         CAF             BIT2                    # IF DELAY REQUEST HAS GONE OFF
                MASK            IMODES30                # PREMATURELY, DO NOT PROCESS ANY CHANGES
                CCS             A                       # UNTIL THE CURRENT 90 SEC WAIT EXPIRES.
                TCF             NXTIFAIL

                CAF             BIT14                   # SEE IF JUST ON OR OFF.
                MASK            IMODES30
                EXTEND
                BZF             ITURNON2                # IF JUST ON.

                CAF             BIT15
                EXTEND                                  # SEE IF DELAY PRESENT DISCRETE HAS BEEN
                RAND            12                      # SENT. IF SO, ACTION COMPLETE.
                EXTEND
                BZF             +2
                TCF             NXTIFAIL

                CAF             BIT2                    # IF NOT, SET BIT TO INDICATE REQUEST NOT
                ADS             IMODES30                # PRESENT FOR FULL DURATION.
                TC              ALARM
                OCTAL           207
                TCF             NXTIFAIL

ITURNON2        CS              BIT7                    # SET BIT 7 TO INITIATE WAIT OF 1 SAMPLE.
                MASK            IMODES30
                AD              BIT7
                TS              IMODES30
                TCF             NXTIFAIL
IMUCAGE         CCS             A                       # NO ACTION IF GOING OFF.
                TCF             NXTIFAIL

                CS              OCT71000                # TERMINATE ICDU AND GYRO PULSE TRAINS.
                EXTEND
                WAND            14

                TC              CAGESUB

                CAF             ZERO                    # ZERO COMMAND OUT-COUNTERS.
                TS              CDUXCMD
                TS              CDUYCMD
                TS              CDUZCMD
                TS              GYROCMD

                CS              OCT1700                 # HAVING WAITED AT LEAST 27 MCT FROM
                EXTEND                                  # GYRO PULSE TRAIN TERMINATION, WE CAN
                WAND            14                      # DE-SELECT THE GYROS.

                TCF             NXTIFAIL

IMUOP           EXTEND
                BZF             IMUOP2

                CS              STATE                   # IF GOING OFF, ALARM IF PROG USING IMU.
                MASK            IMUSEFLG
                CCS             A
                TCF             NXTIFAIL

                TC              ALARM
                OCT             214
                TCF             NXTIFAIL

IMUOP2          CAF             BIT2                    # SEE IF FAILED ISS TURN-ON SEQ IN PROG.
                MASK            IMODES30
                CCS             A
                TCF             NXTIFAIL                # IF SO, DONT PROCESS UNTIL PRESENT 90
                TCF             ITURNON2                # SECONDS EXPIRES.

PIPFAIL         CCS             A                       # SET BIT10 IN IMODES30 SO ALL ISS WARNING
                CAF             BIT10                   # INFO IS IN ONE REGISTER.
                XCH             IMODES30
                MASK            -BIT10
                ADS             IMODES30

                TC              SETISSW

                CS              IMODES30                # IF PIP FAIL DOESNT LIGHT ISS WARNING, DO
                MASK            BIT1                    # A PROGRAM ALARM IF IMU OPERATING BUT NOT
                CCS             A                       # CAGED OR BEING TURNED ON.
                TCF             NXTFL33

                CA              IMODES30
                MASK            OCT1720
                CCS             A
                TCF             NXTFL33                 # ABOVE CONDITION NOT MET.

                TC              ALARM
                OCT             212
                TCF             NXTFL33

DNTMFAST        CCS             A                       # DO PROG ALARM IF TM TOO FAST.
                TCF             NXTFL33

                TC              ALARM
                OCT             1105
                TCF             NXTFL33

UPTMFAST        CCS             A                       # SAME AS DNLINK TOO FAST WITH DIFFERENT
                TCF             NXTFL33                 # ALARM CODE.

                TC              ALARM
                OCT             1106
                TCF             NXTFL33
# CLOSED SUBROUTINES FOR IMU MONITORING.
SETISSW         CAF             OCT15                   # SET ISS WARNING USING THE FAIL BITS IN
                MASK            IMODES30                # BITS 13, 12, AND 10 OF IMODES30 AND THE
                EXTEND                                  # FAILURE INHIBIT BITS IN POSITIONS
                MP              BIT10                   # 4, 3, AND 1.
                CA              IMODES30
                EXTEND
                ROR             L                       # 0 INDICATES FAILURE.
                COM
                MASK            OCT15000
                CCS A
                TCF             ISSWON                  # FAILURE.

ISSWOFF         CAF             BIT1                    # DONT TURN OFF ISS WARNING IF LAMP TEST
                MASK            IMODES33                # IN PROGRESS.
                CCS             A
                TC              Q

                CS              BIT1
                EXTEND
                WAND            11
                TC              Q

ISSWON          CAF             BIT1
                EXTEND
                WOR             11
                TC              Q

CAGESUB         CS              BITS6&15                # SET OUTBITS AND INTERNAL FLAGS FOR
                EXTEND                                  # SYSTEM TURN-ON OR CAGE. DISABLE THE
                WAND            12                      # ERROR COUNTER AND REMOVE IMU DELAY COMP.
                CAF             BITS4&5                 # SEND ZERO AND COARSE.
                EXTEND
                WOR             12

CAGESUB2        CS              OCT75                   # SET FLAGS TO INDICATE CAGING OR TURN-ON,
                MASK            IMODES30                # AND TO INHIBIT ALL ISS WARNING INFO.
                AD              OCT75
                TS              IMODES30

                TC              Q

IMUFAIL         EQUALS          SETISSW
ICDUFAIL        EQUALS          SETISSW
# JUMP TABLES AND CONSTANTS.
IFAILJMP        TCF             ITURNON                 # CHANNEL 30 DISPATCH.
                TCF             IMUFAIL
                TCF             ICDUFAIL
                TCF             IMUCAGE
30RDMSK         OCT             76400                   # (BIT 10 NOT SAMPLED HERE).
                TCF             IMUOP

C33JMP          TCF             PIPFAIL                 # CHANNEL 33 DISPATCH.
                TCF             DNTMFAST
                TCF             UPTMFAST

# SUBROUTINE TO SKIP IF LAMP TEST NOT IN PROGRESS.
LAMPTEST        CS              IMODES33                # BIT1 OF IMODES33 = 1 IF LAMP TEST IN
                MASK            BIT1                    # PROGRESS.
                CCS             A
                INCR            Q
                TC              Q

33RDMSK         EQUALS          PRIO16
OCT15           OCT             15
BITS4&5         OCT             30
OCT54           OCT             54
OCT75           OCT             75
BITS7&8         OCT             300
OCT1720         OCT             1720
OCT1700         OCT             1700
OCT15000        EQUALS          PRIO15
OCT71000        OCT             71000
BITS6&15        OCT             40040
-BIT10          OCT             -1000

90SECS          DEC             9000
120MS           DEC             12

GLOCKOK         EQUALS          RESUME

ENDT4S          EQUALS
