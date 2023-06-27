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
                QXCH    UE5,1661
                CAF     V06N61E
                TC      NVSBWAIT
                TC      FLASHON
                TC      ENDIDLE
                TC      LODLATAZ +2
                TC      UE5,1661
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

U15,2131        TC      BANKCALL
                CADR    IMUCOARS
                TC      BANKCALL
                CADR    IMUSTALL
                TC      PRELEXIT

                TC      PHASCHNG
                OCT     00200

U15,2140        TC      BANKCALL
                CADR    IMUFINE
                
                CAF     U15,2223
                TS      MPAC
                CAF     ZERO
                INDEX   MPAC
                TS      UE5,1567
                CCS     MPAC
                TC      -5

                EXTEND
                DCA     TIME2
                DXCH    UE5,1641
                TC      BANKCALL
                CADR    IMUSTALL
                TC      PRELEXIT

                TC      NEWMODEX
                OCT     05

                CAF     U15,2224
                TS      UE5,1657
                TC      BANKCALL
                CADR    PIPUSE

                CAF     NINE
                TS      UE5,1660
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
                STORE   UE5,1567
                STODL   LOS1                ## FIXME SUSPECT
                SIN
                STORE   UE5,1571
                DCOMP   CLEAR
                        OPTUSE
                STODL   UE5,1575
                        U15,2535
                STORE   WANGI               ## FIXME SUSPECT
                EXIT

                INHINT
                CAF     U15,2554
                TC      WAITLIST
                2CADR   U15,2225

                TC      ENDOFJOB

U15,2223        OCT     00061
U15,2224        OCT     01130

U15,2225        CAF     ZERO
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
                DXCH    UE5,1671

U15,2247        CAF     U15,2554
                TC      WAITLIST
                2CADR   U15,2225

                CAF     PRIO20
                TC      FINDVAC
                2CADR   U15,2262

                TC      TASKOVER

U15,2260        TC      LOADDATA
                TC      U15,2265

U15,2262        TC      STORDATA
                TC      PHASCHNG
                OCT     00400

U15,2265        TC      INTPRET
                VLOAD   VXM
                        DELVX
                        UE5,1567
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

                CCS     UE5,1657
                TC      +3
                TC      NEWMODEX
                OCT     2
                TS      UE5,1657

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

                CCS     UE5,1660
                TC      U15,2504

                CCS     LGYRO
                TCF     U15,2505

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
                STORE   UE5,1567
                STODL   LOS1                ## FIXME SUSPECT
                SIN
                STORE   UE5,1571
                DCOMP
                STORE   UE5,1575

U15,2427        DLOAD   DSU
                        UE5,1671
                        UE5,1641
                BPL     DAD
                        +2
                        U15,2551
                SL      VXSC
                        6
                        UE5,1643
                VAD     MXV
                        UE5,1611
                        UE5,1567
                VSL1    VAD
                        UE5,1617
                STOVL   UE5,1617
                        U15,2527
                STORE   UE5,1611
                BOFF    CLEAR
                        OPTUSE
                        U15,2460
                        OPTUSE
                VLOAD   VAD
                        UE5,1617
                        OGC
                STORE   UE5,1617
U15,2460        EXIT

                EXTEND
                DCA     UE5,1671
                DXCH    UE5,1641

                TC      PHASCHNG
                OCT     00500

                CAF     NINE
                TS      UE5,1660
                TC      U15,3062

                TC      NOVAC
                2CADR   U15,2475

                TC      ENDOFJOB

U15,2475        CAF     U15,2510
                TC      BANKCALL
                CADR    IMUPULSE
                TC      BANKCALL
                CADR    IMUSTALL
                TC      PRELEXIT
                TCF     ENDOFJOB

U15,2504        TS      UE5,1660
U15,2505        TC      PHASCHNG
                OCT     00500
                TC      ENDOFJOB

U15,2510        ECADR   UE5,1617

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
U15,2553        DEC     43
U15,2554        DEC     50

PRELGO          INDEX   PHASE0
                TC      +0
                TC      REPL1
                TC      REPL2
                TC      REPL3
                TC      REPL4
                TC      REPL5

REPL1           CAF     PRIO21
                TC      FINDVAC
                2CADR   U15,2131

                TC      SWRETURN

REPL2           CAF     PRIO21
                TC      FINDVAC
                2CADR   U15,2140

                TC      SWRETURN

REPL3           CAF     ONE
                TC      WAITLIST
                2CADR   U15,2247

                TC      SWRETURN

REPL4           CAF     PRIO21
                TC      FINDVAC
                2CADR   U15,2260

REPL5           CAF     U15,2510
                TS      EBANK
                CS      TIME1
                AD      UE5,1672
                EXTEND
                BZMF    +2
                AD      NEGMAX
                AD      U15,2554
                EXTEND
                BZMF    RIGHTGTS
WTGTSMPL        TC      WAITLIST
                2CADR   U15,2225

                TC      SWRETURN

RIGHTGTS        CAF     ONE
                TC      WAITLIST
                2CADR   U15,2225

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

STORDATA        CAF     U15,2553
                TS      MPAC
                INDEX   MPAC
                CAF     UE5,1567
                INDEX   MPAC
                TS      UE5,1707
                CCS     MPAC
                TCF     STORDATA +1
                TC      Q

LOADDATA        CAF     U15,2553
                TS      MPAC
                INDEX   MPAC
                CA      UE5,1707
                INDEX   MPAC
                TS      UE5,1567
                CCS     MPAC
                TCF     LOADDATA +1
                TC      Q

GCOMPVER        TC      GRABWAIT
                TC      NEWMODEX
                OCT     03
                TC      BANKCALL
                CADR    MKRELEAS
                CAF     ZERO
U15,2673        TS      UE5,1765
                AD      BIT1
                TS      DSPTEM1 +2
                CAF     V06N30E
                TC      NVSBWAIT
                INDEX   UE5,1765
                XCH     UE5,1663
                TS      DSPTEM1
                INDEX   UE5,1765
                XCH     UE5,1665
                TS      DSPTEM1 +1
                TC      LODLATAZ
                XCH     DSPTEM1
                INDEX   UE5,1765
                TS      UE5,1663
                XCH     DSPTEM1 +1
                INDEX   UE5,1765
                TS      UE5,1665
                CCS     UE5,1765
                TCF     +3
                CAF     BIT1
                TC      U15,2673

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
                TC      U15,3022

                TC      INTPRET
                CALL
                        U15,3032
                VLOAD   MXV
                        UE5,1673
                        UE5,1567
                VSL1
                STOVL   STARAD
                        UE5,1701
                MXV     VSL1
                        UE5,1567
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
                STORE   UE5,1651
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
                        UE5,1651
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
                TC      U15,3022
                TC      +2
                TC      U15,3010

                TC      INTPRET
                SET     EXIT
                        OPTUSE

U15,3022        TC      FREEDSP
                TC      BANKCALL
                CADR    MKRELEAS

                TC      NEWMODEX
                OCT     02

                TC      ENDOFJOB

V06N30E         OCT     00630
V06N60E         OCT     00660

U15,3032        AXT,1   AXT,2
                        1
                        12D
U15,3035        SSP     SLOAD*
                        S2
                        6
                        UE5,1666,1
                SR2     PUSH
                SIN     DCOMP
                STODL   UE5,1713,2
                COS     PUSH
                SLOAD*  RTB
                        UE5,1664,1
                        CDULOGIC
                PUSH    SIN
                DMP     SL1
                        0D
                STODL   UE5,1711,2
                COS     DMP
                SL1     AXT,1
                        0D
                STORE   UE5,1707,2
                TIX,2   RVQ
                        U15,3035

U15,3062        INHINT
                CAF     PRIO26
                TC      NOVAC
                2CADR   U15,2475
                
                TC      ENDOFJOB

ENDPRELS        EQUALS
