### FILE="Main.annotation"
## Copyright:    Public domain.
## Filename:     OPTIMUM_PRELAUNCH_ALIGNMENT_CALIBRATION.agc
## Purpose:      Part of the source code for Aurora (revision 12).
## Assembler:    yaYUL
## Contact:      Ron Burkey <info@sandroid.org>.
## Website:      https://www.ibiblio.org/apollo.
## Mod history:  2016-09-20 JL   Created.
##               2016-09-27 MAS  Started.
##               2016-10-15 HG   Fix operand INPRET -> INTPRET
##                                           PHASECHNG -> PHASCHNG
##                               Fix operator TC -> CA
##		 2016-12-08 RSB	 Proofed comments with octopus/ProoferComments
##				 and fixed errors found.


# THIS PROGRAM USES A VERTICAL,SOUTH,EAST COORDINATE SYSTEM FOR PIPAS
                BANK    16
                EBANK=  XSM

# G SCHMIDT SIMPLIFIED ESTIMATION PROGRAM FOR ALIGNMENT CALIBRATION. THE
# PROGRAM IS COMPLETELY RESTART PROFED. DATA STORED IN BANK4.
ESTIMS          CA      UE5,1704
                TS      GEOSAVED
                EXTEND
                BZMF    ESTIMS1
                TC      BANKCALL
                CADR    EARTHR

ESTIMS1         TC      PHASCHNG
                OCT     00101

RSTGTS1         INHINT                  #  COMES HERE PHASE1 RESTART
                CA      GEOSAVED
                TS      UE5,1704

                CAF     1SEC
                TC      WAITLIST
                2CADR   ALLOOP

                CAF     ZERO            # ZERO THE PIPAS
                TS      PIPAX
                TS      PIPAY
                TS      PIPAZ
                TS      ALTIM

                CAF     13DECML
                TS      ZERONDX
                CAF     U16,2114
                TC      BANKCALL
                CADR    ZEROING

                RELINT
                CAF     BIT6
                TS      ZERONDX
                CAF     U16,2115
                TC      BANKCALL
                CADR    ZEROING
                CAF     SEVEN
                TS      ZERONDX
                CAF     U16,3174
                TC      BANKCALL
                CADR    ZEROING
                TC      INTPRET
                DLOAD
                        INTVAL
                STOVL   S1
                        INTVAL +2
                STOVL   ALX1S
                        GEORGED
                STOVL   TRANSM1
                        GEORGEC
                STOVL   TRANSM1 +6
                        GEORGEB
                STORE   TRANSM1 +12D
                EXIT

                CCS     UE5,1704
                TC      U16,2173
                TC      U16,2111

                CAF     ONE
                TS      UE5,1704

                TC      INTPRET
U16,2067        SLOAD   DCOMP
                        UE5,1711
                PUSH
                SLOAD   PUSH
                        UE5,1710
                SLOAD   VDEF
                        UE5,1707
                VXM     VSL1
                        XSM
                STORE   UE5,1633
                EXIT

                TC      BANKCALL
                CADR    LOADGTSM

                CCS     UE5,1776
                TC      U16,2111
                TC      INTPRET
                GOTO
                        BOOP -3

U16,2111        TC      PHASCHNG
                OCT     00301
                TC      ENDOFJOB

U16,2114        GENADR  INTY            ## FIXME
U16,2115        GENADR  VLAUN -1        ## FIXME

PIPASC          2DEC    .76376833

VELSC           2DEC    -.52223476      # 512/980.402

ALSK            2DEC    .17329931       # SSWAY VEL GAIN X 980.402/4096

                2DEC    -.00835370      # SSWAY ACCEL GAIN X 980.402/4096

GEORGED         2DEC    -.75079894

                2DEC    -.13613567

                2DEC    -.12721382

GEORGEC         2DEC    .94817689

                2DEC    .46251787

                2DEC    .29123377

GEORGEB         2DEC    -.33613492

                2DEC    .31165878
                
                2DEC    -.49757417

GEORGEJ         2DEC    .63661977

GEORGEK         2DEC    .59737013

U16,2154        2DEC    .78539816       ## FIXME PI/4.0?

AINGYRO         ECADR   GYROD

U16,2157        DEC     60
                DEC     -1
                2DEC    .00473468
                2DEC    .000004839

U16,2165        2DEC    -.00016228
                2DEC    -.00211173
                2DEC    .00001489

U16,2173        CAF     150DECML
                TS      LENGTHOT

                TC      INTPRET
                VLOAD
                        U16,2157
                STOVL   ALX1S
                        U16,2165
                STORE   UE5,1575
                GOTO
                        U16,2067

ALLOOP          INHINT
                CS      PHASE1
                AD      THREE
                EXTEND
                BZF     +2
                TC      SOMEERRR

                CA      ALTIM
                TS      GEOSAVED
                TC      PHASCHNG
                OCT     00201
                TC      +2

ALLOOP1         INHINT                  # RESTARTS COME IN HERE
                CA      GEOSAVED
                TS      ALTIM
                CCS     A
                TC      SOMEERRR        # SHOULD NEVER HIT THIS LOCATION
                TS      ALTIMS
                CS      A
                TS      ALTIM
                CA      LENGTHOT
                EXTEND
                BZMF    ALLOOP2
                CAF     1SEC
                TC      WAITLIST
                2CADR   ALLOOP

ALLOOP2         CAF     ZERO
                TS      DELVX2 +1
                TS      DELVY2 +1
                TS      DELVZ2 +1
                XCH     PIPAX
                TS      DELVX2
                CAF     ZERO
                XCH     PIPAY
                TS      DELVY2
                CAF     ZERO
                XCH     PIPAZ
                TS      DELVZ2
                RELINT
SPECSTS         CAF     PRIO20
                TC      FINDVAC
                2CADR   ALFLT           # START THE JOB

                TC      TASKOVER

ALKCG           AXT,2   LXA,1           # LOADS SLOPES AND TIME CONSTANTS AT RQST
                        12D
                        ALX1S
ALKCG2          DLOAD*  INCR,1
                        ALFDK +156D,1
                DEC     -2
                STORE   ALDK +10D,2
                TIX,2   SXA,1
                        ALKCG2
                        ALX1S
                GOTO
                        ALFLT2

ALFLT           TC      STOREDTA        #  STORE DATA IN CASE OF RESTART IN JOB
                CA      LENGTHOT
                TS      UNK1023
                TC      PHASCHNG        # THIS IS THE JOB DONE EVERY ITERATION
                OCT     01101
                TC      NORMLOP
U16,2303        CA      GEOBND1
                TS      EBANK

ALFLT1          TC      LOADSTDT        # COMES HERE ON RESTART

                CA      UNK1023
                TS      LENGTHOT
                EXTEND
                BZMF    NORMLOP
                INHINT
                CAF     BIT7
                TC      WAITLIST
                2CADR   ALLOOP

                RELINT

NORMLOP         TC      INTPRET
                DLOAD
                        INTVAL
                STORE   S1              # STEP REGISTERS MAY HAVE BEEN WIPED OUT
                SLOAD   BZE
                        ALTIMS          ## FIXME WAS GEOCOMPS
                        ALKCG

ALFLT2          VLOAD   VXM
                        DELVX2
                        GEOMTRX
                STORE   DELVX2
                DLOAD   DCOMP
                        DELVY2
                STODL   DPIPAY
                        DELVZ2
                STORE   DPIPAZ

                SETPD   AXT,1           # MEASUREMENT INCORPORATION ROUTINES.
                        0
                        8D

DELMLP          DLOAD*  DMP
                        DPIPAY +8D,1
                        PIPASC
                SLR     BOVB
                        10D
                        SOMERR1
                BDSU*
                        INTY +8D,1
                STORE   INTY +8D,1
                PDDL    DMP*
                        VELSC
                        VLAUN +8D,1
                SL2R
                DSU     STADR
                STORE   DELM +8D,1
                STORE   DELM +10D,1
                TIX,1   AXT,2
                        DELMLP
                        4
ALILP           DLOAD*  DMPR*
                        ALK +4,2
                        ALDK +4,2
                STORE   ALK  +4,2
                TIX,2   AXT,2
                        ALILP
                        8D
ALKLP           LXC,1   SXA,1
                        CMPX1
                        CMPX1
                DLOAD*  DMPR*
                        ALK +1,1
                        DELM +8D,2
                DAD*
                        INTY +8D,2
                STODL*  INTY +8D,2
                        ALK +12D,2
                DAD*
                        ALDK +12D,2
                STORE   ALK +12D,2
                DMPR*   DAD*
                        DELM +8D,2
                        INTY +16D,2
                STODL*  INTY +16D,2
                        ALSK +1,1
                DMP*    SL1R
                        DELM +8D,2
                DAD*
                        VLAUN +8D,2
                STORE   VLAUN +8D,2
                TIX,2   AXT,1
                        ALKLP
                        8D


LOOSE           DLOAD*  DMPR
                        VLAUN +8D,1
                        TRANSM1
                SL1
                PDDL*   DMPR
                        POSNV +8D,1
                        TRANSM1 +2
                PDDL*   DMPR
                        POSNV +8D,1
                        TRANSM1 +4
                PDDL*   DMPR
                        POSNV +8D,1
                        TRANSM1 +6
                PDDL*   DMPR
                        VLAUN +8D,1
                        TRANSM1 +8D
                DAD
                PDDL*   DMPR
                        ACCWD +8D,1
                        TRANSM1 +10D
                DAD     STADR
                STODL*  POSNV +8D,1
                        VLAUN +8D,1
                DMPR
                        TRANSM1 +12D
                DAD
                PDDL*   DMPR
                        ACCWD +8D,1
                        TRANSM1 +14D
                DAD     STADR
                STODL*  VLAUN +8D,1
                        ACCWD +8D,1
                DMPR
                        TRANSM1 +16D
                DAD
                DAD     STADR
                STORE   ACCWD +8D,1
                TIX,1
                        LOOSE


                AXT,2   AXT,1           # EVALUATE SINES AND COSINES
                        6
                        2
BOOP            DLOAD*  DMPR
                        ANGX +2,1
                        GEORGEJ
                SR2R
                PUSH    SIN
                SL1R    XAD,1
                        X1
                STODL   UE5,1727,2
                COS
                STORE   WPLATO,2        # COSINES FIXME
                TIX,2
                        BOOP
                DLOAD   SL2
                        UE5,1725
                DAD
                        INTY
                STODL   INTY
                        UE5,1723
                DMP     SL3R
                        XNB1            ## FIXME: THESE XNB1S MAY NOT BE XNB1
                DAD
                        INTZ
                STODL   INTZ
                        UE5,1727
                DMPR    DMPR
                        UE5,1731
                        UE5,1725
                SL2
                PDDL    DMPR
                        UE5,1721
                        UE5,1723
                DAD
                DMPR
                        WANGI
                PDDL    DMPR
                        UE5,1731
                        XNB1
                DMP     SL2R
                        WANGO
                BDSU
                        DRIFTO
                DSU     STADR
                STODL   WPLATO
                        UE5,1727
                DMPR    DMP
                        XNB1
                        WANGI
                SL2R
                PDDL    DMPR
                        WANGO
                        UE5,1725
                DAD
                        DRIFTI
                DSU
                PDDL    DMPR
                        WANGT
                        WANGI
                DAD     STADR
                STODL   WPLATI
                        UE5,1731
                DMP     SL1R
                        UE5,1721
                PDDL    DMPR
                        UE5,1723
                        UE5,1727
                DMP     SL1R
                        UE5,1725
                BDSU
                DMPR
                        WANGI
                PDDL    DMPR
                        UE5,1723
                        XNB1
                DMP     SL1R
                        WANGO
                BDSU
                        DRIFTT
                DAD     STADR           #  WPLATT NOW IN MPAC
                STORE   WPLATT          # PUSH IT DOWN-X IT BY SANG +2 FIXME
                DMPR    SR1R
                        UE5,1723
                PDDL    DMPR
                        WPLATO
                        UE5,1731
                DAD
                DDV
                        XNB1
                PUSH    DMPR
                        GEORGEK
                SRR     DAD
                        13D
                        ANGX
                STODL   ANGX
                DMPR    DAD
                        UE5,1725
                        WPLATI
                DMPR    SRR
                        GEORGEK
                        13D
                DAD
                        ANGY
                STODL   ANGY
                        UE5,1731
                DMP     SL1R            # MULTIPLY X WPLATT -SL1- PUSH AND RELOAD
                        YNB1            ## FIXME
                PDDL    DMPR
                        UE5,1723
                        WPLATO
                BDSU
                DMPR    SRR
                        GEORGEK
                        DELVY2          ## FIXME
                DAD
                        ANGZ
                STORE   ANGZ
                EXIT

U16,2665        CCS     LENGTHOT
                TC      SLEEPIE
                TC      SETUPER

                CCS     UE5,1704
                TC      U16,2705
                
                CCS     TORQNDX
                TC      +2
                TC      U16,3201
                TC      BANKCALL
                CADR    VALMIS

SLEEPIE         TS      LENGTHOT        # TEST NOT OVER-DECREMENT LENGTHOT
                TC      PHASCHNG        #  CHANGE PHASE
                OCT     00301
                CCS     TORQNDX         # ARE WE DOING VERTDRIFT
                TC      EARTTPRQ        # YES,DO HOR ERATE TORQ THEN SLEEP
                TC      ENDOFJOB

U16,2705        TC      INTPRET
                DLOAD
                        UE5,1631
                STODL   UNK1024
                        UE5,1701
                STORE   UNK1026
                EXIT
                TC      U16,3201

EARTTPRQ        TC      BANKCALL        # IN VERTDRIFT,ADD HOR ERATE AND SLEEP
                CADR    EARTHR
                TC      ENDOFJOB

ALFDK           DEC     -28             # SLOPES AND TIME CONSTANTS FOR FIRST 30SC
                DEC     -1
                2DEC    .91230833       # TIME CONSTANTS-PIPA OUTPUTS

                2DEC    .81193187       # TIME CONSTANT-ERECTION ANGLES

                2DEC    -.00035882      # SLOPE-AZIMUTH ANGLE

                2DEC    -.00000029      # SLOPE-VERTICAL DRIFT

                2DEC    .00013262       # SLOPE-NORTH SOUTH DRIFT


                DEC     -58             # 31-90 SEC
                DEC     -1
                2DEC    .99122133

                2DEC    .98940595

                2DEC    -.00079010

                2DEC    -.00000265

                2DEC    .00043154


                DEC     -8              # 91-100 SEC
                DEC     -1
                2DEC    .99971021

                2DEC    .99852047

                2DEC    .00042697

                2DEC    -.00000213

                2DEC    .00011864

                DEC     -98             # 101-200 SEC
                DEC     -1
                2DEC    .99550063

                2DEC    .98992124

                2DEC    .00043452

                2DEC    -.00000401

                2DEC    -.00021980


                DEC     -248            # 201-450 SEC
                DEC     -1
                2DEC    .99673264

                2DEC    .99365467

                2DEC    .00003767

                2DEC    -.00002317

                2DEC    -.00003305


                DEC     -338            # 451-790 SEC
                DEC     -1
                2DEC    .99924362

                2DEC    .99888274

                2DEC    .00000064

                2DEC    -.00004012

                2DEC    -.00000195


                DEC     -408            # 791-1200 SEC
                DEC     -1
                2DEC    .99963845

                2DEC    .99913162

                2DEC    .00000090

                2DEC    .00002927

                2DEC    -.00000026


                DEC     -498            # 1201-1700 SEC
                DEC     -1
                2DEC    .99934865

                2DEC    .99868793

                2DEC    .00000055

                2DEC    .00001183

                2DEC    -.00000005


                DEC     -398            # 1701-2100 SEC
                DEC     -1
                2DEC    .99947099

                2DEC    .99894799

                2DEC    .00000018

                2DEC    .00000300

                2DEC    -.00000001


                DEC     -598            # 2101-2700 SEC
                DEC     -1
                2DEC    .99957801

                2DEC    .99916095

                2DEC    .00000007

                2DEC    .00000096

                2DEC    .00000000


                DEC     -698            # 2700-3400 SEC
                DEC     -1
                2DEC    .99966814

                2DEC    .99933952

                2DEC    .00000002

                2DEC    .00000028

                2DEC    .00000000


                DEC     -598            # 3401-4000 SEC
                DEC     -1
                2DEC    .99972716

                2DEC    .99945654

                2DEC    .00000001

                2DEC    .00000010

                2DEC    .00000000


                DEC     -16000          ## FIXME
                DEC     -1
                2DEC    .99999999

                2DEC    .99999999

SCHZEROS        2DEC    .00000000

                2DEC    .00000000

                2DEC    .00000000


INTVAL          OCT     4
                OCT     2
                DEC     156
                DEC     -1
SOUPLY          2DEC    .93505870       # INITIAL GAINS FOR PIP OUTPUTS

                2DEC    .26266423       # INITIAL GAINS/4 FOR ERECTION ANGLES


GTSCPSS         CS      ONE
                TS      UE5,1704        # THIS IS THE LEAD IN FOR COMPASS
                CA      ZERO
                TS      UE5,1703
                TS      UE5,1776
                TC      U16,3274
                TC      BANKCALL
                CADR    GEOIMUTT        # TO IMU PERF TESTS 2

U16,3174        GENADR  UE5,1575
U16,3175        OCT     01000
13DECML         DEC     13
1SEC            DEC     100
150DECML        DEC     150

U16,3201        TC      PHASCHNG
                OCT     00401

                CA      UE5,1704
                TS      GEOSAVED
                CCS     A
                TC      +4
                TC      SETUPER1
                TC      SOMERR2
                TC      U16,3227

                TC      INTPRET
                DLOAD
                        UNK1024
                STODL   UE5,1631
                        UNK1026
                STORE   UE5,1701

                DSU     DMP
                        GAZIMUTH
                        U16,2154
                SL3R    DAD
                        UE5,1631
                STORE   UE5,1631
                EXIT

U16,3227        TC      U16,3274
                        
SETUPER1        TC      INTPRET
                DLOAD   PDDL            # ANGLES FROM DRIFT TEST ONLY
                        ANGZ
                        ANGY
                PDDL    VDEF
                        ANGX
                VCOMP   VXSC
                        GEORGEJ
                MXV     VSR1
                        GEOMTRX
                STORE   GYROD           ## FIXME WAS OGC
                EXIT


TORQINCH        TC      PHASCHNG
                OCT     00501
                CA      AINGYRO
                TC      BANKCALL
                CADR    IMUPULSE
                TC      BANKCALL
                CADR    IMUSTALL
                TC      SOMERR2         # BAD GYRO TORQUE-END OF TEST

U16,3254        CCS     GEOSAVED
                TC      U16,3316
                TC      BANKCALL
                CADR    TORQUE

                TC      U16,3425

SOMEERRR        RELINT
                TC      ALARM
                OCT     1600
                TC      U16,2665

SOMERR1         TC      ALARM
                OCT     1601
                TC      U16,2665

SOMERR2         TC      ALARM
                OCT     1602
                TC      BANKCALL
                CADR    ENDTEST

U16,3274        EXTEND
                QXCH    QPLACES
                TC      INTPRET
                DLOAD
                        GAZIMUTH        ## FIXME: MAYBE WRONG
                STORE   UE5,1701
                PUSH    SIN
                STODL   UE5,1712
                COS
                STORE   UE5,1714
                STORE   YSM +2
                STODL   XSM +4
                STORE   UE5,1712
                STORE   YSM +4
                VCOMP
                STORE   XSM +2
                EXIT
                TC      QPLACES

U16,3316        CCS     UE5,1703
                TC      +2
                TC      ESTIMS
                TC      SETUPER

                INHINT
                CAF     ZERO
                TS      DELVX2
                TS      DELVY2
                TS      DELVZ2

                CAF     1SEC
                TC      WAITLIST
                2CADR   U16,3337

                RELINT
                TC      PHASCHNG
                OCT     00601
                TC      ENDOFJOB

U16,3337        CS      UE5,1701
                AD      UE5,1705
                EXTEND
                BZF     +4

U16,3343        CA      ONE
                TS      DELVZ2
                TC      U16,3363
                CS      UE5,1702
                CA      UE5,1706
                EXTEND
                BZF     +2
                TC      U16,3343
                CCS     DELVX2
                TC      U16,3370
                INHINT
                CAF     1SEC
                TC      WAITLIST
                2CADR   U16,3337

                RELINT

U16,3363        CAF     PRIO20
                TC      FINDVAC
                2CADR   U16,3373

                TC      TASKOVER

U16,3370        CAF     ONE
                TS      DELVY2
                TC      U16,3363

U16,3373        TC      PHASCHNG
                OCT     00701
                
                TC      BANKCALL
                CADR    EARTHR
U16,3377        CCS     DELVZ2
                TC      +2
                TC      U16,3437

                TC      INTPRET
                DLOAD   DSU
                        UE5,1701
                        UE5,1705
                DMP     SL3R
                        U16,2154
                STORE   UE5,1631
                EXIT

                TC      PHASCHNG
                OCT     01001

U16,3414        CAF     ZERO
                TS      ANGY
                TS      ANGY +1
                TS      ANGZ
                TS      ANGZ +1
                TS      SAVE
                CS      A
                TS      UE5,1704
                TC      U16,3201

U16,3425        TC      SETUPER
                INHINT
                CAF     ONE
                TS      UE5,1704
                CAF     1SEC
                TC      WAITLIST
                2CADR   U16,3337

                RELINT
                TC      U16,3437 +2

U16,3437        CCS     DELVY2
                TC      +4
                TC      PHASCHNG
                OCT     00601
                TC      ENDOFJOB

                CAF     ZERO
                TS      UE5,1703
                TC      ESTIMS

U16,3447        CCS     DELVY2
                TC      U16,3377
                CCS     DELVZ2
                TC      U16,3377
                TC      SETUPER
                INHINT
                CAF     1SEC
                TC      WAITLIST
                2CADR   U16,3337

                RELINT
                TC      U16,3377

SETUPER         EXTEND                  # SUBROUTINE CALLED IN 3 PLACES
                QXCH    QPLACES
                TC      INTPRET
                CALL
                        ERTHRVSE
                EXIT
                TC      BANKCALL
                CADR    OGCZERO
                TC      QPLACES

OPTMSTRT        INDEX   PHASE1
                TC      +0
                TC      GTSGTS1
                TC      GTSGTS2
                TC      GTSGTS3
                TC      GTSGTS4
                TC      GTSGTS5
                TC      GTSGTS6
                TC      GTSGTS7
                TC      GTSGTS10
                TC      GTSGTS11


GTSGTS1         CAF     PRIO20
                TC      FINDVAC
                2CADR   RSTGTS1

                TC      SWRETURN
GTSGTS2         CAF     ONE
                TC      WAITLIST
                2CADR   ALLOOP1

                TC      SWRETURN
GTSGTS3         CAF     ONE
                TC      WAITLIST
                2CADR   ALLOOP

                TC      SWRETURN
GTSGTS4         CAF     PRIO20
                TC      FINDVAC
                2CADR   U16,3201

                TC      SWRETURN
GTSGTS5         CAF     PRIO20
                TC      FINDVAC
                2CADR   U16,3254

                TC      SWRETURN
GTSGTS6         CAF     ONE
                TC      WAITLIST
                2CADR   U16,3337

                TC      SWRETURN

GTSGTS7         CAF     PRIO20
                TC      FINDVAC
                2CADR   U16,3447

                TC      SWRETURN
GTSGTS10        CAF     PRIO20
                TC      FINDVAC
                2CADR   U16,3414

                TC      SWRETURN
GTSGTS11        CAF     PRIO20
                TC      FINDVAC
                2CADR   U16,2303

                TC      SWRETURN

GEOBND          OCT     02000           #  BANK 4  -THIS IS THE STORE DTA SECTION
GEOBND1         OCT     02400           # BANK NUMBER 5


STOREDTA        CAF     GEOBND
                TS      L
                CAF     BIT7
                TS      MPAC
                INDEX   MPAC
                CA      ALX1S
                LXCH    EBANK
                EBANK=  JETSTEP
                INDEX   MPAC
                TS      JETSTEP
                LXCH    EBANK
                EBANK=  XSM
                CCS     MPAC
                TCF     +2
                TC      Q
                TS      MPAC
                CAF     GEOBND
                TS      L
                TCF     STOREDTA +4


LOADSTDT        CAF     BIT7
                TS      MPAC
                CA      GEOBND
                XCH     EBANK
                TS      L
                EBANK=  JETSTEP
                INDEX   MPAC
                CA      JETSTEP
                LXCH    EBANK
                EBANK=  XSM
                INDEX   MPAC
                TS      ALX1S
                CCS     MPAC
                TCF     +2
                TC      Q
                TS      MPAC
                TCF     LOADSTDT +2

U16,3626        TC      NEWMODEX
                OCT     10
                TC      BANKCALL
                CADR    MKRELEAS
                CAF     ONE
                TS      UE5,1703

                TC      BANKCALL
                CADR    U06,3455

                CAF     ONE
                TS      LENGTHOT
                INHINT
                CAF     U16,3772
                TC      WAITLIST
                2CADR   U16,3650

                RELINT
                CAF     U16,3767
                TC      JOBSLEEP

U16,3650        CAF     U16,3767
                TC      JOBWAKE
                TC      TASKOVER

U16,3653        CAF     ONE
                TS      DSPTEM1
                CAF     TWO
                TS      DSPTEM1 +1
                CAF     U16,3770
                TC      NVSBWAIT
                CAF     TWO
                TC      BANKCALL
                CADR    SXTMARK
                TC      BANKCALL
                CADR    OPTSTALL
                TC      U16,3764

                TC      INTPRET
                CALL
                        TAR/EREF
                VLOAD   MXV
                        6
                        XSM
                VSL1
                STOVL   STARAD
                        12D
                MXV     VSL1
                        XSM
                STORE   STARAD +6D
                LXC,1   AXT,2
                        MARKSTAT
                        2
                XSU,2   SXA,2
                        X1
                        S1
                CALL
                        SXTNB
                CALL
                        NBSM
                STORE   LOSVEC

                LXC,1   INCR,1
                        MARKSTAT
                DEC     -7
                AXT,2   XSU,2
                        2
                        X1
                SXA,2   CALL
                        S1
                        SXTNB
                CALL
                        NBSM
                STOVL   12D
                        LOSVEC
                STCALL  6D
                        AXISGEN
                CALL
                        CALCGTA
                EXIT

U16,3740        CAF     U16,3771
                TC      NVSBWAIT
                TC      FLASHON
                TC      ENDIDLE
                TC      U16,3755
                TCF     +2
                TCF     U16,3740

                TC      INTPRET
                VLOAD   VAD
                        OGC             ## FIXME SUSPECT
                        DELVX
                STORE   DELVX
                EXIT

U16,3755        CAF     ONE
                TS      DELVX2
                TC      BANKCALL
                CADR    MKRELEAS
                TC      NEWMODEX
                OCT     07
                TC      ENDOFJOB

U16,3764        TC      ALARM
                OCT     01603
                TC      U16,3755

U16,3767        CADR    U16,3653
U16,3770        OCT     00630
U16,3771        OCT     00660
U16,3772        DEC     1000

ENDPREL1        EQUALS
