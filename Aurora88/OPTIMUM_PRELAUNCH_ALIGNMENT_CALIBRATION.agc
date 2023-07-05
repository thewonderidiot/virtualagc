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
##               2016-12-08 RSB  Proofed comments with octopus/ProoferComments
##                               and fixed errors found.


# THIS PROGRAM USES A VERTICAL,SOUTH,EAST COORDINATE SYSTEM FOR PIPAS
                BANK    21
                EBANK=  XSM

# G SCHMIDT SIMPLIFIED ESTIMATION PROGRAM FOR ALIGNMENT CALIBRATION. THE
# PROGRAM IS COMPLETELY RESTART PROFED. DATA STORED IN BANK4.
ESTIMS          TC      MAKECADR
                TS      QPLACE
RSTGTS1         INHINT                  #  COMES HERE PHASE1 RESTART
                CAF     1SEC
                TC      WAITLIST
                2CADR   ALLOOP

                CAF     ZERO            # ZERO THE PIPAS
                TS      PIPAX
                TS      PIPAY
                TS      PIPAZ
                TS      ALTIM
                CA      U21,2133
                TS      ZERONDX
                CA      U21,2064
                TC      BANKCALL
                CADR    ZEROING
                RELINT
                CCS     NEWJOB
                TC      CHANG1
                INHINT
                CAF     BIT5
                TS      ZERONDX
                CA      U21,2065
                TC      BANKCALL
                CADR    ZEROING
                CA      SEVEN
                TS      ZERONDX
                CA      U21,2066
                TC      BANKCALL
                CADR    ZEROING

                TS      UE5,1725
                TS      UE5,1726
                TS      UE5,1730
                RELINT
                TC      INTPRET
                DLOAD
                        INTVAL +2
                STODL   ALX1S
                        SOUPLY
                STODL   ALK
                        SOUPLY +2
                STOVL   ALK +2
                        GEORGED
                STOVL   TRANSM1
                        GEORGEC
                STOVL   TRANSM1 +6
                        GEORGEB
                STORE   TRANSM1 +12D
                EXIT
                CA      QPLACE
                TCF     BANKJUMP

U21,2064        ECADR   GENPL           ## FIXME
U21,2065        ECADR   GENPL           ## FIXME
U21,2066        ECADR   GENPL           ## FIXME

1SEC            DEC     100

PIPASC          2DEC    .13055869

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

PI/4.0          2DEC    .78539816

U21,2130        OCT     26501           ## FIXME
U21,2131        OCT     07640           ## FIXME
U21,2132        OCT     02521           ## FIXME
U21,2133        OCT     00015           ## FIXME

ALLOOP          INHINT                  #  TASK EVERY .5 OR 1 SEC (COMPASS-DRIFT)
                CCS     ALTIM
                TC      U21,2216        # SHOULD NEVER HIT THIS LOCATION
                TS      ALTIMS
                CS      A
                TS      ALTIM
                
                CAF     1SEC
                TC      WAITLIST
                2CADR   ALLOOP

                CAF     ZERO
                TS      DELVX +1
                TS      DELVY +1
                TS      DELVZ +1
                XCH     PIPAX
                TS      DELVX
                CAF     ZERO
                XCH     PIPAY
                TS      DELVY
                CAF     ZERO
                XCH     PIPAZ
                TS      DELVZ

                RELINT

                TCF     U21,2173

                ## FIXME
                OCT     51572
                OCT     00000
                OCT     55661
                OCT     31665
                OCT     51574
                OCT     00000
                OCT     55665

U21,2173        CCS     UE5,1746
                TC      U21,2205
                CA      UE5,1727
                EXTEND
                INDEX   UE5,1745
                SU      UE5,1661
                EXTEND
                MP      U21,2130
                INDEX   UE5,1745
                DXCH    UE5,1661
U21,2205        CAF     U21,2235
                TC      JOBWAKE
                CCS     LOCCTR
                TC      TASKOVER
                TC      TASKOVER
                TC      ALARM
                OCT     01600
                TC      BANKCALL
                CADR    ENDTEST

U21,2216        RELINT
                TC      TASKOVER

ALKCG           TC      INTPRET
                AXT,2   LXA,1           # LOADS SLOPES AND TIME CONSTANTS AT RQST
                        12D
                        ALX1S
ALKCG2          DLOAD*  INCR,1
                        ALFDK +156D,1
                DEC     -2
                STORE   ALDK  +10D,2
                TIX,2   SXA,1
                        ALKCG2
                        ALX1S
                GOTO
                        ALCGKK

U21,2235        CADR    NORMLOP

NORMLOP         TC      INTPRET
                DLOAD
                        INTVAL
                STORE   S1              # STEP REGISTERS MAY HAVE BEEN WIPED OUT
                EXIT
                CCS     ALTIMS
                TC      +2
                TC      ALKCG
                TC      INTPRET
ALCGKK          GOTO
                        ALFLT2

                NOOP

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
                STORE   ALK +4,2
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
                STODL   BPLAC +6,2
                COS
                STORE   BPLAC +12D,2    # COSINES
                TIX,2
                        BOOP
                DLOAD   SL2     
                        BPLAC +4
                DAD
                        INTY
                STODL   INTY
                        BPLAC +2
                DMP     SL3R
                        BPLAC +10D
                DAD
                        INTZ
                STODL   INTZ
                        BPLAC +6
                DMPR    DMPR
                        BPLAC +8D
                        BPLAC +4
                SL2
                PDDL    DMPR
                        BPLAC
                        BPLAC +2
                DAD
                DMPR
                        WANGI
                PDDL    DMPR
                        BPLAC +8D
                        BPLAC +10D
                DMP     SL2R
                        WANGO
                BDSU
                        DRIFTO
                DSU     STADR
                STODL   WPLATO
                        BPLAC +6
                DMPR    DMP
                        BPLAC +10D
                        WANGI
                SL2R
                PDDL    DMPR
                        WANGO
                        BPLAC +4
                DAD
                        DRIFTI
                DSU
                PDDL    DMPR
                        WANGT
                        WANGI
                DAD     STADR
                STODL   WPLATI
                        BPLAC +8D
                DMP     SL1R
                        BPLAC
                PDDL    DMPR
                        BPLAC +2
                        BPLAC +6
                DMP     SL1R
                        BPLAC +4
                BDSU
                DMPR
                        WANGI
                PDDL    DMPR
                        BPLAC +2
                        BPLAC +10D
                DMP     SL1R
                        WANGO
                BDSU
                        DRIFTT
                DAD     STADR           #  WPLATT NOW IN MPAC
                STORE   WPLATT          # PUSH IT DOWN-X IT BY SANG +2
                DMPR    SR1R
                        BPLAC +2
                PDDL    DMPR
                        WPLATO
                        BPLAC +8D
                DAD
                DDV
                        BPLAC +10D
                PUSH    DMPR
                        GEORGEK
                SRR     DAD
                        13D
                        ANGX
                STODL   ANGX
                DMPR    DAD
                        BPLAC +4
                        WPLATI
                DMPR    SRR
                        GEORGEK
                        13D
                DAD
                        ANGY
                STODL   ANGY
                        BPLAC +8D
                DMP     SL1R            # MULTIPLY X WPLATT -SL1- PUSH AND RELOAD
                        WPLATT
                PDDL    DMPR
                        BPLAC +2
                        WPLATO
                BDSU
                DMPR    SRR
                        GEORGEK
                        13D
                DAD
                        ANGZ
                STORE   ANGZ

SETUPER1        PDDL                    # ANGLES FROM DRIFT TEST ONLY
                        ANGY
                PDDL    VDEF
                        ANGX
                VCOMP   VXSC
                        GEORGEJ
                MXV     VSR1
                        GEOMTRX
                STORE   OGC
                EXIT

                CCS     UE5,1730
                TC      U21,3055
                CA      QPLACE
                TCF     BANKJUMP


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


                DEC     -16000          # 4001- SEC
                DEC     -1
                2DEC    .99999999

                2DEC    .99999999

                2DEC    .00000000

                2DEC    .00000000

                2DEC    .00000000

SOUPLY          2DEC    .93505870       # INITIAL GAINS FOR PIP OUTPUTS

                2DEC    .26266423       # INITIAL GAINS/4 FOR ERECTION ANGLES

INTVAL          OCT     4
                OCT     2
                DEC     144
                DEC     -1

U21,3055        CA      ONE
                TS      ALTIM
                TC      INTPRET
                VLOAD
                        UE5,1621
                STORE   UE5,1521
                EXIT

                CA      U21,2132
                TC      BANKCALL
                CADR    IMUPULSE
                TC      BANKCALL
                CADR    IMUSTALL
                TC      SOMERR2
                CA      U21,2131
                TS      LENGTHOT
                TC      RSTGTS1

SOMERR1         TC      ALARM
                OCT     1601
                TC      BANKCALL
                CADR    ENDTEST

SOMERR2         TC      ALARM
                OCT     1602
                TC      BANKCALL
                CADR    ENDTEST

ENDPREL1        EQUALS
