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

                BANK    15
                EBANK=  XSM

2STODP1S        CCS     A
                AD      ONE
                TCF     2TO1OUT
                AD      ONE
                AD      ONE
                OVSK
                TCF     +4
                ZL
                CS      BIT14
                TC      Q
                COM
2TO1OUT         EXTEND
                MP      BIT14
                TC      Q

DP1STO2S        DDOUBL
                CCS     A
                AD      ONE
                TCF     +2
                COM
                TS      L
                TC      Q
                INDEX   A
                CAF     LIMITS
                ADS     L
                TC      Q

LODLATAZ        EXTEND
                QXCH    QSAVED
                CAF     V06N61E
                TC      NVSBWAIT
                TC      FLASHON
                TC      ENDIDLE
                TC      LODLATAZ +2
                TC      QSAVED
                TC      LODLATAZ +2

V06N61E         OCT     00661
U15,2043        OCT     05550

STARTPL         TC      NEWMODEX
                OCT     01
                EXTEND
                DCA     AZIMUTH
                TC      DP1STO2S
                TS      DSPTEM1

                CAF     ZERO
                TS      DSPTEM1 +1
                TC      LODLATAZ

                CA      DSPTEM1
                TC      2STODP1S
                DXCH    AZIMUTH
                EXTEND
                DCA     AZIMUTH
                DXCH    UE5,1763
                DXCH    UE5,1667
                TC      DP1STO2S
                TS      DSPTEM1
                DXCH    LATITUDE
                DDOUBL
                DDOUBL
                TS      DSPTEM1 +1
                TC      LODLATAZ

                CA      DSPTEM1
                TC      2STODP1S
                DXCH    UE5,1667
                CA      DSPTEM1 +1
                EXTEND
                MP      BIT13
                DXCH    LATITUDE
                TC      FREEDSP

                EXTEND
                DCA     UE5,1667
                TC      DP1STO2S
                TS      MPAC
                EXTEND
                DCA     UE5,1763
                TC      DP1STO2S
                EXTEND
                MSU     MPAC
                TC      DP1STO2S +1
                TS      THETAD
                CAF     BIT14
                TS      THETAD +1
                CAF     ZERO
                TS      THETAD +2

                TC      BANKCALL
                CADR    IMUZERO
                TC      BANKCALL
                CADR    IMUSTALL
                TC      PRELEXIT
                
                TC      PHASCHNG
                OCT     00100

REDO0.1         TC      BANKCALL
                CADR    IMUCOARS
                TC      BANKCALL
                CADR    IMUSTALL
                TC      PRELEXIT

                TC      PHASCHNG
                OCT     00200

REDO0.2         TC      BANKCALL
                CADR    IMUFINE
                
                CAF     DEC49
ZEROS1          TS      MPAC
                CAF     ZERO
                INDEX   MPAC
                TS      XSM1
                CCS     MPAC
                TC      ZEROS1

                EXTEND
                DCA     TIME2
                DXCH    PREVTIME
                TC      BANKCALL
                CADR    IMUSTALL
                TC      PRELEXIT

                TC      NEWMODEX
                OCT     05

                CAF     SIXHNDRD
                TS      GYROCSW

                TC      BANKCALL
                CADR    PIPUSE

                CAF     NINE
                TS      PRELTEMP
                TC      INTPRET
                DLOAD   SIN
                        LATITUDE
                DCOMP   DMP
                        GOMEGA
                STODL   UE5,1647
                        LATITUDE
                COS     DMP
                        GOMEGA
                STODL   UE5,1643
                        UE5,1763
                PUSH    COS
                STORE   XSM1
                STODL   XSM1 +8D
                SIN
                STORE   XSM1 +2
                DCOMP   CLEAR
                        OPTUSE
                STODL   XSM1 +6
                        U15,2535
                STORE   WANGI               ## FIXME WRONG
                EXIT

                INHINT
                CAF     PRELDT
                TC      WAITLIST
                2CADR   PRELALTS

                TC      ENDOFJOB

DEC49           DEC     49
SIXHNDRD        DEC     600

PRELALTS        CAF     ZERO
                XCH     PIPAX
                TS      DELVX
                CAF     ZERO
                XCH     PIPAY
                TS      DELVX +2
                CAF     ZERO
                XCH     PIPAZ
                TS      DELVX +4
                CAF     ZERO
                TS      DELVX +1
                TS      DELVX +3
                TS      DELVX +5

                TC      PHASCHNG
                OCT     00300

                EXTEND
                DCA     TIME2
                DXCH    PIPTIME

REPRELAL        CAF     PRELDT
                TC      WAITLIST
                2CADR   PRELALTS

                CAF     PRIO20
                TC      FINDVAC
                2CADR   PRAWAKE

                TC      TASKOVER

REDO0.4         TC      PRLRSTOR
                TC      RE0.4

PRAWAKE         TC      PRLSAVE
                TC      PHASCHNG
                OCT     00400

RE0.4           TC      INTPRET
                VLOAD   VXM
                        DELVX
                        XSM1
                VSL1    VSU
                        UE5,1625
                VXSC    VAD
                        GEOCONS1
                        UE5,1625
                STORE   UE5,1625
                VAD
                        UE5,1633
                STORE   UE5,1633
                EXIT

                TC      CHECKMM
                OCT     5
                TC      U15,2330

NOGYROCM        CCS     GYROCSW
                TC      MORE
                TC      NEWMODEX
                OCT     2

MORE            TS      GYROCSW

                TC      INTPRET
                VLOAD   VXSC
                        UE5,1633
                        GEOCONS2
                VAD     VXSC
                        UE5,1625
                        U15,2551
                VXV     VAD
                        U15,2531
                        UE5,1611
                STORE   UE5,1611
                GOTO
                        U15,2344

U15,2330        TC      INTPRET
                VLOAD   MXV
                        UE5,1625
                        U15,2511
                VAD
                        UE5,1611
                STODL   UE5,1611
                        UE5,1635
                DMP     DAD
                        GEOCONS4
                        UE5,1611
                STORE   UE5,1611
U15,2344        EXIT

                CCS     PRELTEMP
                TC      JUMPY

                CCS     LGYRO
                TCF     JUMPY +1

                TC      CHECKMM
                OCT     03
                TC      U15,2362

                TC      INTPRET
                VLOAD
                        U15,2527
                STORE   UE5,1611
                GOTO
                        U15,2427

U15,2362        TC      INTPRET
                DLOAD   DSU
                        AZIMUTH
                        UE5,1763
                BZE     PUSH
                        U15,2427
                DSU     BPL
                        U15,2547
                        U15,2401
                DLOAD   DAD
                        0D
                        U15,2547
                BMN     GOTO
                        U15,2406
                        U15,2411

U15,2401        DLOAD
                        U15,2547
                STORE   0D
                GOTO
                        U15,2411

U15,2406        DLOAD   DCOMP
                        U15,2547
                STORE   0D

U15,2411        DLOAD   DAD
                        0D
                        UE5,1623
                STODL   UE5,1623
                DAD
                        UE5,1763
                STORE   UE5,1763
                PUSH    COS
                STORE   XSM1
                STODL   XSM1 +8D
                SIN
                STORE   XSM1 +2
                DCOMP
                STORE   XSM1 +6

U15,2427        DLOAD   DSU
                        PIPTIME
                        PREVTIME
                BPL     DAD
                        +2
                        U15,2551
                SL      VXSC
                        6
                        UE5,1643
                VAD     MXV
                        UE5,1611
                        XSM1
                VSL1    VAD
                        GYROANG
                STOVL   GYROANG
                        U15,2527
                STORE   UE5,1611
                BOFF    CLEAR
                        OPTUSE
                        +6
                        OPTUSE
                VLOAD   VAD
                        GYROANG
                        OGC
                STORE   GYROANG
                EXIT

                EXTEND
                DCA     PIPTIME
                DXCH    PREVTIME

                TC      PHASCHNG
                OCT     00500

                CAF     NINE
                TS      PRELTEMP
                TC      GOSPITGY

                TC      NOVAC
                2CADR   SPITGYRO

                TC      ENDOFJOB

SPITGYRO        CAF     LGYROANG
                TC      BANKCALL
                CADR    IMUPULSE
                TC      BANKCALL
                CADR    IMUSTALL
                TC      PRELEXIT
                TCF     ENDOFJOB

JUMPY           TS      PRELTEMP
                TC      PHASCHNG
                OCT     00500
                TC      ENDOFJOB

LGYROANG        ECADR   GYROANG

U15,2511        2DEC    0                   ## FIXME MATRIX VALUES
                2DEC    .062
                2DEC    0
                2DEC    -.062
                2DEC    0
                2DEC    0
                2DEC    -.999999999
U15,2527        2DEC    0
U15,2531        2DEC    0
                2DEC    0
U15,2535        2DEC    .5                  ## FIXME VALUE

GEOCONS4        2DEC    .00003
GEOCONS2        2DEC    .005
GOMEGA          2DEC    0.97356192          # EARTH RATE IN IRIG PULSES/CS
GEOCONS1        2DEC    .1
U15,2547        2DEC    .005555555
U15,2551        2DEC    .999999999
DEC43           DEC     43
PRELDT          DEC     .5 E2               # HALF SECOND PRELAUNCH CYCLE

PRELGO          INDEX   PHASE0
                TC      +0
                TC      REPL1
                TC      REPL2
                TC      REPL3
                TC      REPL4
                TC      REPL5

REPL1           CAF     PRIO21
                TC      FINDVAC
                2CADR   REDO0.1

                TC      SWRETURN

REPL2           CAF     PRIO21
                TC      FINDVAC
                2CADR   REDO0.2

                TC      SWRETURN

REPL3           CAF     ONE
                TC      WAITLIST
                2CADR   REPRELAL

                TC      SWRETURN

REPL4           CAF     PRIO21
                TC      FINDVAC
                2CADR   REDO0.4

REPL5           CAF     LGYROANG
                TS      EBANK
                CS      TIME1
                AD      PIPTIME +1
                EXTEND
                BZMF    +2
                AD      NEGMAX
                AD      PRELDT
                EXTEND
                BZMF    RIGHTGTS
WTGTSMPL        TC      WAITLIST
                2CADR   PRELALTS

                TC      SWRETURN

RIGHTGTS        CAF     ONE
                TC      WAITLIST
                2CADR   PRELALTS

                TC      SWRETURN

PRELEXIT        TC      BANKCALL
                CADR    PIPFREE
                INHINT
                CS      IMUSEFLG
                MASK    STATE
                TS      STATE
                TC      NEWMODEX
                OCT     0
                TC      ENDOFJOB

PRLSAVE         CAF     DEC43
                TS      MPAC
                INDEX   MPAC
                CAF     XSM1
                INDEX   MPAC
                TS      PTEMP
                CCS     MPAC
                TCF     PRLSAVE +1
                TC      Q

PRLRSTOR        CAF     DEC43
                TS      MPAC
                INDEX   MPAC
                CA      PTEMP
                INDEX   MPAC
                TS      XSM1
                CCS     MPAC
                TCF     PRLRSTOR +1
                TC      Q

OPTCHK          TC      GRABWAIT
                TC      NEWMODEX
                OCT     03
                TC      BANKCALL
                CADR    MKRELEAS
                CAF     ZERO
                TS      STARS
                AD      ONE
                TS      DSPTEM1 +2
                CAF     V06N30E
                TC      NVSBWAIT
                INDEX   STARS
                XCH     TAZ
                TS      DSPTEM1
                INDEX   STARS
                XCH     TEL
                TS      DSPTEM1 +1
                TC      LODLATAZ
                XCH     DSPTEM1
                INDEX   STARS
                TS      TAZ
                XCH     DSPTEM1 +1
                INDEX   STARS
                TS      TEL
                CCS     STARS
                TCF     +3
                CAF     ONE
                TC      OPTCHK +6

                TS      DSPTEM1 +2
                CAF     TWO
                TS      DSPTEM1 +1
                CAF     BIT1
                TS      DSPTEM1
                CAF     V06N30E
                TC      NVSBWAIT
                CAF     TWO
                TC      BANKCALL
                CADR    SXTMARK
                TC      BANKCALL
                CADR    OPTSTALL
                TC      CHEXIT

                TC      INTPRET
                CALL
                        PROCTARG
                VLOAD   MXV
                        TARGET1
                        XSM1
                VSL1
                STOVL   STARAD
                        TARGET1 +6
                MXV     VSL1
                        XSM1
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
                STORE   VECTEM
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
                        VECTEM
                STORE   6D
                CALL
                        AXISGEN
                CALL
                        CALCGTA
                EXIT

U15,3010        CAF     V06N60E
                TC      NVSBWAIT
                TC      FLASHON
                TC      ENDIDLE
                TC      CHEXIT
                TC      +2
                TC      U15,3010

                TC      INTPRET
                SET     EXIT
                        OPTUSE

CHEXIT          TC      FREEDSP
                TC      BANKCALL
                CADR    MKRELEAS

                TC      NEWMODEX
                OCT     02

                TC      ENDOFJOB

V06N30E         OCT     00630
V06N60E         OCT     00660

PROCTARG        AXT,1   AXT,2
                        1
                        12D
PROC1           SSP     SLOAD*
                        S2
                        6
                        TEL +1,1
                SR2     PUSH
                SIN     DCOMP
                STODL   TARGET1 +16D,2
                COS     PUSH
                SLOAD*  RTB
                        TAZ +1,1
                        CDULOGIC
                PUSH    SIN
                DMP     SL1
                        0D
                STODL   TARGET1 +14D,2
                COS     DMP
                SL1     AXT,1
                        0D
                STORE   TARGET1 +12D,2
                TIX,2   RVQ
                        PROC1

GOSPITGY        INHINT
                CAF     PRIO26
                TC      NOVAC
                2CADR   SPITGYRO
                
                TC      ENDOFJOB

ENDPRELS        EQUALS
