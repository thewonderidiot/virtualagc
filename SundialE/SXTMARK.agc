### FILE="Main.annotation"
## Copyright:    Public domain.
## Filename:     AOTMARK.agc
## Purpose:      Part of the source code for Aurora (revision 12).
## Assembler:    yaYUL
## Contact:      Ron Burkey <info@sandroid.org>.
## Website:      https://www.ibiblio.org/apollo.
## Pages:        218-226
## Mod history:  2016-09-20 JL   Created.
##               2016-12-08 RSB  Proofed comments with octopus/ProoferComments
##                               but no errors found.

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

## Page 218
                SETLOC          ENDIMODS
                
                EBANK=          AOTAZ
SXTMARK         INHINT
                TS              RUPTREG1                # BIT14=INFLIGHT 0=NONFLIGHT
                CCS             MARKSTAT                # ARE MARKS BUTTONS IN USE
                TC              +2                      # MARKS BUTTONS NOT AVAILABLE
                TC              MKVAC                   # FIND A VAC AREA
                TC              ALARM
                OCT             00105
                TC              ENDOFJOB

MKVAC           CCS             VAC1USE
                TC              MKVACFND
                CCS             VAC2USE
                TC              MKVACFND
                CCS             VAC3USE
                TC              MKVACFND
                CCS             VAC4USE
                TC              MKVACFND
                CCS             VAC5USE
                TC              MKVACFND
                TC              ABORT                   # VAC AREAS OCCUPIED
                OCT             01207

MKVACFND        AD              TWO
                TS              MARKSTAT
                INDEX           A
                TS              QPRET                   # STORE NEXT AVAILABLE MARK SLOT
                
                CAF             ZERO                    # SHOW VAC AREA OCCUPIED
                INDEX           MARKSTAT
                TS              0            -1

                CAF             BIT12                   # PLACE DESIRED NUMBER OF MARKS IN 12 - 14
                EXTEND
                MP              RUPTREG1
                XCH             L
                ADS             MARKSTAT                # JUST CONTAINS LOW 9 BITS OF VAC ADDRESS.
                
MARKEXIT        CAF             PRIO32
                TC              NOVAC
                EBANK=          MARKSTAT
                2CADR           MKVB51
                
                RELINT
                TCF             SWRETURN                # SAME AS MODEEXIT

MKRELEAS        CS              BIT9                    # COARSE OPTICS RETURN FLAG.
                MASK            OPTMODES
                TS              OPTMODES

                CAF             NEGONE
                TS              OPTIND                  # KILL COARS OPTICS

                CAF             ZERO
                XCH             MARKSTAT                # SET MARKSTAT ZERO
                CCS             A
                INDEX           A
                TS              0                       # SHOW VAC AREA AVAILABLE
                TC              SWRETURN

MARKRUPT        TS              BANKRUPT                # STORE  CDUS AND OPTICS NOW
                CA              OPTY
                TS              RUPTSTOR        +5
                CA              OPTX
                TS              RUPTSTOR        +3
                CA              CDUY
                TS              RUPTSTOR        +2
                CA              CDUZ
                TS              RUPTSTOR        +4
                CA              CDUX
                TS              RUPTSTOR        +6
                EXTEND
                DCA             TIME2                   # GET TIME
                DXCH            RUPTSTOR
                EXTEND
                DCA             RUPTSTOR
                DXCH            SAMPTIME                # RUPT TIME FOR NOUN 65.
                
                XCH             Q
                TS              QRUPT
                
                CAF             BIT6                    # SEE IF MARK OR MKREJECT
                EXTEND
                RAND            NAVKEYIN
                CCS             A
                TC              MARKIT                  # ITS A MARK

                CAF             BIT7                    # NOT A MARK, SEE IF MKREJECT
                EXTEND
                RAND            NAVKEYIN
                CCS             A
                TC              MKREJECT                # ITS A MARK REJECT

KEYCALL         CAF             OCT37                   # NOT MARK OR MKREJECT, SEE IF KEYCODE
                EXTEND
                RAND            NAVKEYIN
                EXTEND
                BZF             +3                      # IF NO INBITS
                TC              POSTJUMP
                CADR            KEYCOM                  # IT,S A KEY CODE, NOT A MARK.

 +3             TC              ALARM                   # ALARM IF NO INBITS
                OCT             113
                TC              RESUME
                
MARKIT          CCS             MARKSTAT                # SEE IF MARKS CALLED FOR
                TC              MARK2                   # COLLECT MARKS

                CA              RUPTSTOR        +3
                TS              RUPTREG1
                CA              RUPTSTOR        +5
                TS              RUPTREG2
                CA              RUPTSTOR        +1
                TS              RUPTREG3

                CAF             PRIO5                   # CALL SPECIAL DISPLAY JOB
                TC              NOVAC
                EBANK=          MARKSTAT
                2CADR           MARKDISP

                CA              RUPTREG1                # PLANT INFORMATION IN MPAC OF REGISTER
                INDEX           LOCCTR                  # SET.
                TS              MPAC
                CA              RUPTREG2
                INDEX           LOCCTR
                TS              MPAC            +1
                CA              RUPTREG3
                INDEX           LOCCTR
                TS              MPAC            +2

                TC              RESUME

MARK2           AD              74K                     # SEE IF MARKS WANTED-REDUCE MARKS WANTED         
                EXTEND
                BZMF            +3                      # MARK NOT WANTED-ALARM
                TS              MARKSTAT
                TC              MARK3
 +3             TC              ALARM                   # MARK NOT WANTED
                OCT             114
                TC              RESUME

MARK3           CS              BIT10                   # SET BIT10 TO ENABLE REJECT
                MASK            MARKSTAT
                AD              BIT10
                TS              MARKSTAT

                MASK            LOW9
                TS              ITEMP1
                INDEX           A
                XCH             QPRET                   # PICK UP MARK SLOT-POINTER
                TS              ITEMP2                  # SAVE CURRENT POINTER
                AD              SEVEN                   # INCREMENT POINTER
                INDEX           ITEMP1
                TS              QPRET                   # STORE ADVANCED POINTER

VACSTOR         EXTEND
                DCA             RUPTSTOR
                INDEX           ITEMP2
                DXCH            0
                CA              RUPTSTOR        +2
                INDEX           ITEMP2
                TS              2
                CA              RUPTSTOR        +3
                INDEX           ITEMP2
                TS              3
                CA              RUPTSTOR        +4
                INDEX           ITEMP2
                TS              4
                CA              RUPTSTOR        +5
                INDEX           ITEMP2
                TS              5
                CA              RUPTSTOR        +6
                INDEX           ITEMP2
                TS              6

                CAF             PRIO34                  # IF ALL MARKS MADE FLASH VB50
                MASK            MARKSTAT
                EXTEND
                BZF             +2
                TC              RESUME
                CAF             PRIO32
                TC              NOVAC
                EBANK=          MARKSTAT
                2CADR           MKVB50
                TC              RESUME

MKREJECT        CCS             MARKSTAT                # SEE IF MARKS BEING ACCEPTED
                TC              REJECT2
                TC              ALARM                   # MARKS NOT BEING ACCEPTED
                OCT             112
                TC              RESUME

REJECT2         CS              BIT10                   # SEE IF MARK HAD BEEN MADE SINCE LAST
                MASK            MARKSTAT                # REJECT, AND SET BIT10 TO ZERO TO
                XCH             MARKSTAT                # SHOW MARK REJECT

                MASK            BIT10
                CCS             A
                TC              REJECT3

                TC              ALARM                   # DONT ACCEPT TWO REJECTS TOGETHER
                OCT             110
                TC              RESUME

REJECT3         CAF             LOW9                    # DECREMENT POINTER TO REJECT MARK
                MASK            MARKSTAT
                TS              ITEMP1
                CS              SEVEN
                INDEX           ITEMP1
                ADS             QPRET                   # NEW POINTER

                CAF             BIT12                   # INCREMENT MARKS WANTED AND IF FIELD
                AD              MARKSTAT                # IS NOW NON-ZERO, CHANGE TO VB51 TO
                XCH             MARKSTAT                # INDICATE MORE MARKS WANTED
                MASK            PRIO34                  # INDICATE MORE MARKS WANTED
                CCS             A
                TC              RESUME
                CAF             PRIO32
                TC              NOVAC
                EBANK=          MARKSTAT
                2CADR           REMKVB51
                TC              RESUME

## Page 219
MKVB51          CAF             VB51                    # DISPLAY MARK VB51
                TC              NVSBWAIT
                TC              FLASHON
                TC              ENDIDLE
                TC              MKVB5X                  # DONT RESPOND TO PROCEED OR TERMINATE
                TC              MKVB5X

                CAF             OCT76                   # ON ENTER, SEE IF DATA LOADED INSTEAD.
                MASK            VERBREG
                AD              -OCT50                  # VERBS 50 AND 51 CAUSE END MARK ROUTINES.
                CCS             A
                TC              MKVB5X                  # ON DATA LOAD, RE-DISPLAY ORIGINAL VERB.
-OCT50          OCT             -50
                TC              MKVB5X

                CAF             LOW9
                MASK            MARKSTAT
                TS              MARKSTAT                # VAC ADR IN MARKSTAT AND NO. MARKS MADE
                COM
                INDEX           MARKSTAT                # WILL BE LEFT IN QPRET.
                AD              QPRET
                EXTEND
                MP              BIT12
                AD              ONE
                INDEX           MARKSTAT
                TS              QPRET

                INHINT                                  # GO SERVICE OPSTALL INTERFACE WITH
                CAF             ONE                     # USING PROGRAM.
                TC              WAITLIST
                EBANK=          MARKSTAT
                2CADR           ENDMARKS
                TC              ENDOFJOB

ENDMARKS        CAF             ONE
                TCF             GOODEND

MKVB5X          CAF             PRIO34
                MASK            MARKSTAT                # RE-DISPLAY VB51 IF MORE MARKS WANTED
                CCS             A                       # AND VB50 IF ALL IN
                CAF             BIT7                    # (MAKES VERB 51).
                AD              PRIO5
                TC              MKVB51          +1

#       ON RECEIPT OF LAST REQUESTED MARK, DISPLAY VERB 50 (STILL FLASHING).

MKVB50          CAF             PRIO5
                TS              NVTEMP                  # SPECIAL ENTRY TO NVSUB WHICH AVOIDS BUSY
                TC              NVSUB           +3      # TEST.
VB51            OCT             5100
                TC              ENDOFJOB

#       IF THE ABOVE IS REJECTED, REVERT TO VERB 51.

REMKVB51        CAF             VB51
                TC              MKVB50          +1

MARKDISP        TC              GRABDSP                 # SPECIAL JOB TO DISPLAY UNCALLED-FOR MARK
                TC              PREGBSY

REMKDSP         CA              MPAC
                TS              DSPTEM1
                CA              MPAC            +1
                TS              DSPTEM1         +1
                CA              MPAC            +2
                TS              DSPTEM2
                CAF             ZERO
                TS              DSPTEM1         +2

                CAF             MKDSPCOD                # NOUN-VERB FOR MARK DISPLAY.
                TC              NVSUB
                TC              MKDSPBSY                # IF BUSY.

ENDMKDSP        TC              FREEDSP
                
                TC              ENDOFJOB

MKDSPBSY        CAF             LREMKDSP                # TAKE DATA OUT OF MPAC WHEN RE-AWAKENED.
                TC              NVSUBUSY

MKDSPCOD        OCT             00656
LREMKDSP        CADR            REMKDSP

OCT37           OCT             37
OCT76           OCT             76

ENDOMODS        EQUALS
