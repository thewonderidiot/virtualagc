### FILE="Main.annotation"
## Copyright:    Public domain.
## Filename:     T4RUPT_PROGRAM.agc
## Purpose:      Part of the source code for Aurora (revision 12).
## Assembler:    yaYUL
## Contact:      Ron Burkey <info@sandroid.org>.
## Website:      https://www.ibiblio.org/apollo.
## Pages:        160-188
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
##               2016-12-08 RSB  Proofed comments with octopus/ProoferComments
##                               and fixed the errors found.

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

## Page 160
                SETLOC          ENDPHMNF
T4RUPT          EXTEND                                  # ZERO OUT0 EVERY T4RUPT.
                WRITE           OUT0                    # (COMES HERE WITH +0 IN A)

                CCS             DSRUPTSW                # SEE IF THIS IS A SPECIAL RUPT TO
                TCF             REGRUPT         +1      # ZERO OUT0 20MS AFTER IT WAS DRIVEN BY
                TCF             REGRUPT                 # DSPOUT. IF SO, DSRUPTSW IS NNZ.
                AD              ONE
                TS              DSRUPTSW

DSKYRSET        CAF             100MRUPT                # 20 MS ON / 100 MS OFF.
                TS              TIME4
                TCF             NOQBRSM

REGRUPT         CAF             SEVEN
 +1             TS              ITEMP1
                TS              DSRUPTSW

                CAF             T4RPTBB                 # OFF TO SWITCHED BANK
                XCH             BBANK
                TCF             T4RUPTA

100MRUPT        DEC             16374
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
## Page 161
ENDT4FF         EQUALS

## Page 162
#          SWITCHED-BANK PORTION.

                SETLOC          ENDFRESS

T4RUPTA         TS              BANKRUPT
                EXTEND
                QXCH            QRUPT

CDRVE           CCS             DSPTAB          +11D
                TC              DSPOUT
                TC              DSPOUT

                XCH             DSPTAB          +11D
                MASK            LOW11
                TS              DSPTAB          +11D
                AD              RELTAB11
                TC              DSPLAYC

## Page 163
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

                CS              DSRUPTSW
                TS              DSRUPTSW
                CAF             20MRUPT

SETTIME4        TS              TIME4

# JUMP TO APPROPRIATE ONCE-PER SECOND (.96 SEC ACTUALLY) ACTIVITY

T4JUMP          INDEX           ITEMP1
                TCF             +1

                TCF             OPTDRIVE
                TCF             OPTMON
                TCF             IMUMON
                TCF             RESUME
                TCF             OPTDRIVE
                TCF             OPTMON
                TCF             IMUMON
                TCF             RESUME

20MRUPT         DEC             16382

## Page 165
# IMU INBIT MONITOR - ENTERED EVERY 480 MS BY T4RUPT.

IMUMON          CAF             BIT4                    # CHECK IF COARSE ALIGNING
                EXTEND
                RAND            12
                EXTEND
                BZF             NOATTOFF                # NOT COARSE ALIGNING. TURN OFF NO ATT

                CS              DSPTAB          +11D    # COARSE ALIGNING. ENSURE NO ATT LIGHT ON.
                MASK            BIT4
                EXTEND
                BZF             C30TEST                 # NO ATT LIGHT IS ON

                CA              OCT40010
                ADS             DSPTAB          +11D
                TCF             C30TEST

NOATTOFF        CS              DSPTAB          +11D    # CHECK IF NO ATT ON
                MASK            BIT4
                CCS             A
                TC              C30TEST                 # NOT ON. CARRY ON.

                CA              DSPTAB          +11D    # LIGHT IS ON. TURN IT OFF
                MASK            OCT37767
                AD              BIT15
                TS              DSPTAB          +11D

C30TEST         CA              IMODES30                # SEE IF THERE HAS BEEN A CHANGE IN THE
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
## Page 169
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
## Page 170
UNZ2            TC              ZEROICDU

                CS              BITS4&5                 # REMOVE ZERO AND COARSE.
                EXTEND
                WAND            12

                CAF             4SECS                   # ALLOW 4 SECS FOR COUNTER TO FIND GIMBAL.
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

OPONLY          TC              COARSCHK
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
## Page 171
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
## Page 172
# MONITOR FOR GIMBAL LOCK.

GLOCKMON        CCS             CDUZ
                TCF             GLOCKCHK                # SEE IF MAGNITUDE OF MGA IS GREATER THAN
                TCF             SETGLOCK                # 70 DEGREES.
                TCF             GLOCKCHK
                TCF             SETGLOCK

GLOCKCHK        AD              -70DEGS
                EXTEND
                BZMF            SETGLOCK        -1      # NO LOCK.

                TCF             GLOCKALN                # ENABLE COARSE ALIGN IF 85 DEGREES
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
## Page 173
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
## Page 174
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
## Page 175
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
## Page 176
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
## Page 177
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

OCT15           OCT             15
OCT37767        OCT             37767
OCT40010        OCT             40010
33RDMSK         EQUALS          PRIO16
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
NOIMUMON        EQUALS          GLOCKOK
# RR INBIT MONITOR.
# OPTICS MONITORING AND ZERO ROUTINES
OPTMON          CA              OPTMODES                # MONITOR OPTICS INBITS IN CHAN 30 AND 33
                EXTEND
                RXOR            30                      # LOOK FOR OCDU FAIL BIT CHANGE
                MASK            BIT7
                TS              RUPTREG1                # STORE CHANGE BIT
                CCS             A
                TC              OCDUFTST                # PROCESS OCDUFAIL BIT CHANGE

                CA              OPTMODES                # LOOK FOR OPTICS MODE SWITCH CHANGE
                EXTEND
                RXOR            33    
                MASK            OCTHIRTY
                ADS             RUPTREG1                # STORE INBIT CHANGES
                LXCH            OPTMODES
                EXTEND
                RXOR            L     
                TS              OPTMODES                # UPDATE OPTMODES TO SHOW BIT  CHANGES

                COM                                     # SAMPLE CURRENT SWITCH SETTING
                MASK            OCTHIRTY
                EXTEND
                BZF             SETSAMP                 # MANUAL-SET ZERO IN SWSAMPLE

                MASK            BIT5                    # SEE IF CSC
                CCS             A
                TC              +2                      # CSC-SET SWSAMPLE POS
                CAF             NEGONE                  # ZOPTICS-SET SWSAMPLE (-1)
SETSAMP         TS              SWSAMPLE                # CURRENT OPTICS SWITCH SETTING

PROCESSW        CCS             DESOPMOD                # BRANCH ON PREVIOUS SETTING
                TC              CSCDES                  # CSC
                TC              MANUDES                 # MANUAL
                TC              ZOPTDES                 # ZERO OPTICS
# ## Page 156
ZOPTDES         CCS             SWSAMPLE                # IS SWITCH STILL AT ZOPTICS
                TC              ZTOCSC                  # NOW AT CSC
                TC              ZTOMAN                  # MANUAL
                TC              ZOPFINI                 # ZOPTICS-SEE IF ZOPT PROCESSING
                TC              SETDESMD                # ZOPT NOT PROCESSING-NO ACTION

                CCS             ZOPTCNT                 # ZOPT PROCESSING-CHECK COUNTER
                TC              SETCNT                  # 32 SAMPLE NOT FINISHED-SET COUNTER
                TC              SETZOEND                # 32 SAMPLE WAIT COMPLETED-SET UP ZOP END

ZTOMAN          TC              ZOPFINI                 # ZOP TO MANUAL-IS ZOPT DONE
                TC              SETDESMD                # YES-NORMAL EXIT

ZOPALARM        TC              ALARM                   # ALARM-SWITCHED ALTERED WHILE ZOPTICS
                OCT             00116
                CAF             OCT13                   # PROCESSING-SET RETURN OPTION
                TS              WTOPTION

                TC              CANZOPT                 # CANCEL ZOPT

                TC              SETDESMD

ZTOCSC          TC              ZOPFINI                 # SEE IF ZOPT PROCESSING
                TC              MANTOCSC +3             # NO-CHECK RETURN TO COARS OPT
                TC              ALARM                   # ZOPT PROCESSING-ALARM
                OCT             00116
                TC              CANZOPT                 # CANCEL ZOPT
                TC              MANTOCSC                # ZERO CNT-LOOK FOR COARS OPT RETURN

COARSLOK        CAF             BIT9                    # IF COARS OPT SINCE FSTART GO TO L+2
                MASK            OPTMODES                # RETURNS TO L+1 PROCESSING AND
                CCS             A
                INCR            Q                       # L+2 IF NOT
                TC              Q

ZOPFINI         CAF             BIT1                    # SEE IF END ZOPT TASK WORKING
                MASK            OPTMODES
                CCS             A
                TC              RESUME                  # ZOPT TASK WORKING-WAIT ONE SAMPLE PERIOD

                CAF             BIT3                    # TEST IF ZOPTICS PROCESSING
                MASK            OPTMODES                # RETURNS TO L+1 PROCESSING AND
                CCS             A
                INCR            Q                       # L+2 IF NOT
                TC              Q

CANZOPT         CS              SIX                     # CANCEL ZERO OPTICS
                MASK            OPTMODES                # ZERO ZOPT PROCESSING BIT-ENABLE OCDUFAIL
                TS              OPTMODES
                CS              BIT1                    # MAKE SURE ZERO OCDU IS OFF
                EXTEND
                WAND            12
                TC              Q

MANUDES         CCS             SWSAMPLE                # SEE IF SWITCH STILL IN MANUAL MODE
                TC              MANTOCSC                # NOW AT CSC
                TC              MANTOMAN                # STILL MANUAL
                CCS             WTOPTION                # ZOPTICS-LOOK AT ZOPTICS RETURN OPTION
                TC              +2                      # 5 SEC RETURN GOOD-CONTINUE ZOPTICS
                TC              OPTZERO                 # ZOPTICS MUST START ANEW

                TC              INITZOPT                # SHOW ZERO OPTICS PROCESSING
                TC              SETDESMD                # NORMAL EXIT

MANTOMAN        CCS             WTOPTION                # DECREMENT RETURN OPTION TIME
                TS              WTOPTION
                TC              SETDESMD

MANTOCSC        CAF             ZERO                    # CANCEL ZOPT RETURN OPTION IF SET
                TS              WTOPTION
                TS              ZOPTCNT

                TC              COARSLOK                # CHECK FOR COARS OPT RETURN
                TC              SETDESMD                # NO COARS TASK-NO ACTION

                CAF     ONE                     # SET COARS OPT WORKING
                TS      OPTIND
                CAF     BIT2                    # ENABLE OPTICS CDU ERROR CNTS
                EXTEND
                WOR     12

                TC      SETDESMD

CSCDES          CCS     SWSAMPLE                # SEE IF SWITCH STILL AT CSC
                TC      SETDESMD                # STILL AT CSC
                TC      CSCTOMAN                # MANUAL
CSCTOZOP        CAF     OCT40                   # ZOPTICS-INITIALIZE FOR ZOPT
                TS      ZOPTCNT
                TC      INITZOPT

CSCTOMAN        CCS     OPTIND                  # SEE IF COARS WORKING
                TC      CANCOARS                # COARS WORKING-SWITCH NOT CSC-KILL COARS
                TC      CANCOARS
                TC      +1                      # NO COARS-NORMAL EXIT
                TC      SETDESMD
## Page 158
CANCOARS        CA      NEGONE
                TS      OPTIND                  # SET OPTIND (-1) TO SHOW NOT WORKING
                CS      BIT2                    # DISABLE OCDU ERR CNTS
                EXTEND
                WAND    12
                CS      BIT9                    # SET RETURN-TO-COARS BIT
                MASK    OPTMODES
                AD      BIT9
                TS      OPTMODES

                TC      SETDESMD
OPTZERO         TC      INITZOPT                # INITIALIZE ZERO OPTICS

                CA      OCT40                   # SET UP 32 SAMPLE WAIT
SETCNT          TS      ZOPTCNT
SETDESMD        CA      SWSAMPLE                # SET CURRENT SWITCH INDICATION-RESUME
                TS      DESOPMOD
                TC      RESUME

SETZOEND        CAF     BIT1                    # SEND ZERO OPTICS CDU
                EXTEND
                WOR     12
                CA      200MS                   # HOLD ZERO CDU FOR 200 MS
                TC      WAITLIST
                2CADR   ENDZOPT

                CS      BIT1                    # SHOW ZOPTICS TASK WORKING
                MASK    OPTMODES
                AD      BIT1
                TS      OPTMODES

                TC      SETDESMD

ENDZOPT         TC      ZEROPCDU                # ZERO OCDU COUNTERS
                CS      BIT1                    # TURN OFF ZERO OCDU
                EXTEND
                WAND    12
                CAF     200MS                   # DELAY 200MS FOR CDUS TO RESYNCHRONIZE
                TC      VARDELAY

                CS      BIT10                   # SHOW ZOPTICS SINCE LAST FRESH START
                MASK    OPTMODES                #     OR RESTART
                AD      BIT10
                TS      OPTMODES

                CS      SEVEN                   # ENABLE OCDUFAIL-SHOW OPTICS COMPLETE
                MASK    OPTMODES
                TS      OPTMODES

                TC      OCDUFTST                # CHECK OCDU FAIL BIT AFTER ENABLE
                TC      TASKOVER

ZEROPCDU        CAF     ZERO
                TS      OPTX                    # ZERO IN OPTX,-20 IN OPTY
                CS      20DEGS
                TS      OPTY
                TC      Q

INITZOPT        CAF     ZERO                    # INITIALIZE ZOPTICS-INHIBIT OCDUFAIL
                TS      WTOPTION                # AND SHOW OPTICS PROCESSING
                CS      SIX                     # SET ZERO OPTICS PROCESSING
                MASK    OPTMODES                #     OPTICS CDU FAIL INHIBITED
                AD      SIX
                TS      OPTMODES
                TC      Q

OCDUFTST        CAF     BIT7                    # SEE IF OCDUFAIL ON OR OFF
                EXTEND
                RAND    30
                CCS     A
                TCF     OPFAILOF                # OCDUFAIL LIGHT OFF

                CAF     BIT2                    # OCDUFAIL LIGHT ON UNLESS INHIBITED
                MASK    OPTMODES
                CCS     A
                TC      Q                       # OCDUFAIL INHIBITED

OPFAILON        CAF     BIT8                    # ON BIT
                AD      DSPTAB  +11D
                MASK    BIT8
SETOFF          EXTEND
                BZF     TCQ                     # NO CHANGE

                TS      L
                CA      DSPTAB  +11D
                EXTEND
                RXOR    L
                MASK    POSMAX
                AD      BIT15                   # SHOW ACTION WANTED
                TS      DSPTAB  +11D
                TC      Q

OPFAILOF        CAF     BIT1                    # DONT TURN OFF IF LAMP TEST
                MASK    IMODES33
                CCS     A
                TC      Q                       # LAMP TEST IN PROGRESS

                CAF     BIT8                    # TURN OFF OCDUFAIL LIGHT
                MASK    DSPTAB  +11D
                TCF     SETOFF  +1

OCT13           OCT             13
OCTHIRTY        EQUALS          CALLCODE
20DEGS          DEC             7199
OCT40           OCT             40
200MS           DEC             20

# OPTICS CDU DRIVING PROGRAM

OPTDRIVE        CCS             OPTIND
                TC      +4                      # WORK COARS OPTICS
                TC      +3                      # WORK COARS OPTICS
                TC      RESUME                  # NO OPT
                TC      RESUME                  # NO OPT

                CCS     SWSAMPLE                # SEE IF SWITCH AT CMC
                TC      +3
                TC      RESUME                  # ZERO  (-1)         MANUAL  (+0)
                TC      RESUME

                CAF     BIT10                   # SEE IF OCDUS ZEROED SINCE LAST FSTART
                MASK    OPTMODES
                CCS     A
                TC      +3
                TC      ALARM                   # OPTICS NOT ZEROED
                OCT     00120

                CA      BIT2                    # SEE IF ERR CNTS ENABLED
                EXTEND
                RAND    12
                EXTEND
                BZF     SETBIT                  # CNTS NOT ENABLED-DO IT AND RESUME

                CAF     ONE                     # INITIALIZE OPTIND
## Page 162
OPT2            TS      OPTIND
                EXTEND
                BZF     TRUNCMD                 # CHECK TRUNION COMMAND

GETOPCMD        INDEX   OPTIND
                CA      DESOPTX                 # PICK UP DESIRED OPT ANGLE
                EXTEND
                INDEX   OPTIND
                MSU     OPTY                    # GET DIFFERENCE
                EXTEND
                MP      BIT13
                XCH     L
                DOUBLE
                TS      ITEMP1
                TCF     +2                      # NO OVFL

                ADS     L                       # WITH OVFL
STORCMD         INDEX   OPTIND
                LXCH    COMMANDO                # STORE COMMAND
                CCS     OPTIND
                TCF     OPT2                    # GET NEXT COMMAND

                TS      ITEMP1                  # INITIALIZE SEND INDICATOR TO ZERO

CMDSETUP        CAF     ONE                     # SET OPTIND
                TS      OPTIND
                INDEX   A
                CCS     COMMANDO                # GET SIGN OF COMMAND
                TC      POSOPCMD
                TC      NEXTOPT +1              # ZERO COMMAND-SKIP SEND INDICATOR
                TC      NEGOPCMD
                TC      NEXTOPT +1              # ZERO COMMAND

TRUNCMD         CS      OPTY                    # IF COMMAND GREATER THAN 45 DEG-COMMAND
                AD      DESOPTX                 # 45 DEG
                TS      Q
                TC      GETOPCMD                # LESS THAN 45 DEG-NORMAL OPERATION

                CCS     A                       # GREATER THAN 45 DEG-USE OPSMAX WITH
                CA      POSMAX                  # CORRECT SIGN
                TC      +2
                CS      POSMAX
                TS      L
                TC      STORCMD
POSOPCMD        AD      MAXPLS1
                EXTEND
                BZMF    DELOPCMD                # COMMAND LESS THAN MAX PULSE
                CS      MAXPLS                  # GREATER THAN MAX PULSE-USE MAX PULSE

NEXTOPT         INCR    ITEMP1                  # SET SEND INDICATOR
                INDEX   OPTIND
                TS      OPTYCMD                 # STORE PULSE IN SEND REG

                CCS     OPTIND
                TC      CMDSETUP +1             # GET NEXT OPT

                CCS     ITEMP1                  # ARE ANY PULSES TO GO
                TCF     SENDOCMD                # YES-SEND EM
                TC      RESUME                  # NO

NEGOPCMD        AD      MAXPLS1
                EXTEND
                BZMF    DELOPCMD                # LESS THAN MAX PULSE
                CA      MAXPLS                  # MAX PULSES
                TCF     NEXTOPT
## Page 164
DELOPCMD        INDEX   OPTIND
                XCH     COMMANDO                # SET UP SMALL COMMAND
                TCF     NEXTOPT

SENDOCMD        CAF     11,12                   # SEND OCDU DRIVE COMMANDS
                EXTEND
                WOR     14
                TC      RESUME

SETBIT          CAF     BIT2                    # ENABLE OCDU ERR CNTS
                EXTEND
                WOR     CHAN12
                TC      RESUME                  # START COARS NEXT TIME AROUND

MAXPLS          DEC     -80
MAXPLS1         DEC     -79
11,12           EQUALS  PRIO6

# CODING FOR MODULE 3 REMAKE
#
GLOCKALN        AD      -15DEGS                 # CHECK IF ANGLE GREATER THAN 85 DEGREES
                EXTEND
                BZMF    +4

                CAF     BIT4                    # ENABLE COARSE ALIGN
                EXTEND
                WOR     12

                CAF     BIT6
                TCF     SETGLOCK

-15DEGS         DEC     -.083333                # -15 DEGREES SCALED IN HALF-REVOLUTIONS.

COARSCHK        CAF     BIT4                    # CHECK IF COARSE ALIGN ENABLED
                EXTEND
                RAND    12
                CCS     A
                TCF     C33TEST                 # YES, BYPASS OPONLY
                CAF     BIT8                    # NO
                TCF     OPONLY      +1

ENDT4RMK        EQUALS
