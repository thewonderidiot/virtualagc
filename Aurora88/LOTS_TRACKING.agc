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

                SETLOC  ENDLFCSS
                EBANK=  LOTSFLAG

U06,2555        EXTEND
                QXCH    UNK1207
                XCH     UNK1113

                CAF     U06,2772
                MASK    LOTMODES
                TS      LOTMODES

                CA      AZANG
                EXTEND
                BZF     U06,2633

                CA      UNK1127
                EXTEND
                BZMF    U06,2633

                CA      AZANG
                EXTEND
                BZMF    U06,2614

                CA      UNK1127
                AD      U06,2777
                EXTEND
                BZMF    U06,2633

                CAF     BIT9
                MASK    LOTMODES
                CCS     A
                TCF     U06,2633

                INDEX   UNK1113
                TCF     +1

                TC      ALARM
                OCT     00601

                INDEX   UNK1113
                CAF     BIT4
                TC      U06,2757
                TCF     U06,2633

U06,2614        CS      UNK1127
                AD      U06,3000
                EXTEND
                BZMF    U06,2633

                CAF     BIT9
                MASK    LOTMODES
                CCS     A
                TCF     U06,2633

                INDEX   UNK1113
                TCF     +1

                TC      ALARM
                OCT     00602

                INDEX   UNK1113
                CAF     BIT3
                TC      U06,2757

U06,2633        CA      ELANG
                AD      U06,2766
                EXTEND
                BZMF    U06,2737

                CCS     UNK1113
                TCF     +2
                TCF     U06,2650

                CA      ELANG
                AD      U06,2776
                EXTEND
                BZMF    U06,2650

                CAF     BIT6
                TC      U06,2757

U06,2650        CA      ELANG
                AD      U06,2775
                EXTEND
                BZMF    U06,2662

                CAF     BIT7
                TC      U06,2757

                INDEX   UNK1113
                TCF     +1

                TC      ALARM
                OCT     00603

U06,2662        CAF     U06,2773
                MASK    LOTMODES
                CCS     A
                TCF     U06,2671

                CS      ONE
                TS      UNK1112
                TC      UNK1207

U06,2671        CAF     BIT8
                TC      U06,2757

                CCS     UNK1113
                TC      UNK1207

                CCS     UNK1112
                TCF     +3
                TCF     +4
                CA      U06,2774
                TS      UNK1112
                TCF     U06,2713

                CAF     BIT10
                MASK    LOTMODES
                CCS     A
                TCF     U06,2713

                CAF     PRIO20
                TC      NOVAC
                2CADR   U07,3251

U06,2713        INHINT
                LXCH    DSPTAB +11D
                CA      LOTMODES
                EXTEND
                RXOR    L
                MASK    BIT8
                CCS     A
                TCF     +2
                TCF     U06,2734

                CS      BIT8
                EXTEND
                WAND    L

                CA      LOTMODES
                MASK    BIT8
                AD      BIT15
                EXTEND
                WOR     L

U06,2734        LXCH    DSPTAB +11D
                RELINT
                TC      UNK1207

U06,2737        EXTEND
                READ    12
                MASK    U06,2770
                CCS     A
                TCF     U06,2662

                CAF     U06,2771
                MASK    LOTMODES
                CCS     A
                TCF     U06,2662

                CAF     BIT5
                TC      U06,2757

                INDEX   UNK1113
                TCF     +1

                TC      ALARM
                OCT     00604

                TCF     U06,2662

U06,2757        INHINT
                LXCH    LOTMODES
                EXTEND
                WOR     L
                LXCH    LOTMODES
                RELINT
                TC      Q

U06,2766        OCT     00133
U06,2767        OCT     04476
U06,2770        OCT     20002
U06,2771        OCT     11400
U06,2772        OCT     77400
U06,2773        OCT     00134
U06,2774        OCT     00024
U06,2775        OCT     60421
U06,2776        OCT     61042
U06,2777        OCT     60132
U06,3000        OCT     20133

U06,3001        TS      UNK1132

                CAF     BIT1
                MASK    UNK1131
                EXTEND
                BZF     U06,3014

                CS      BIT1
                MASK    UNK1131
                TS      UNK1131

                CAF     BIT1
                TS      UNK1135
                TC      U06,3025

U06,3014        CAF     BIT14
                EXTEND
                WOR     12

U06,3017        CAF     BIT14
                EXTEND
                RAND    12
                CCS     A
                TC      +2
                TC      ENDOFJOB

U06,3025        CAF     BIT3
                EXTEND
                RAND    33
                CCS     A
                TC      U06,3051

                CAF     BIT14
                EXTEND
                WOR     12

                CAF     ZERO
                TS      UNK1135

                CAF     BIT4
                EXTEND
                RAND    33
                CCS     A
                TC      U06,3053
                TS      UNK1204

                CS      BIT2
                EXTEND
                WAND    12

                TC      U06,3122

U06,3051        CAF     ONE
                TC      +2
U06,3053        CS      ZERO
                TS      UNK1136

                CCS     UNK1132
                TC      U06,3073

                CAF     BIT2
                MASK    UNK1131
                CCS     A
                TC      U06,3071

                CCS     UNK1136
                TC      ALARM
                OCT     00631
                TC      U06,3071
                TC      ALARM
                OCT     00632

U06,3071        TC      BANKCALL
                CADR    U07,2731

U06,3073        TS      UNK1132

                INHINT
                CAF     ONE
                TC      WAITLIST
                2CADR   U06,3110

                RELINT

                CCS     UNK1135
                TC      +3

                CAF     U06,3120
                TC      JOBSLEEP

                CAF     U06,3121
                TC      JOBSLEEP

U06,3110        CCS     UNK1135
                TC      +4

                CAF     U06,3120
                TC      JOBWAKE
                TC      +3

                CAF     U06,3121
                TC      JOBWAKE

                TC      TASKOVER

U06,3120        CADR    U06,3017
U06,3121        CADR    U06,3025

U06,3122        CAF     ZERO
                TS      UNK1134

                CS      U06,3303
                MASK    UNK1131
                AD      BIT11
                TS      UNK1131

U06,3130        CAF     BIT14
                EXTEND
                RAND    12
                CCS     A
                TC      +2
                TC      ENDOFJOB

                CAF     BIT4
                EXTEND
                RAND    33
                CCS     A
                TC      U06,3156

                CCS     UNK1134
                TC      +2
                TC      U06,3166
                TS      UNK1134

                INHINT
                CS      U06,3300
                MASK    DSPTAB +11D
                AD      BIT15
                TS      DSPTAB +11D
                RELINT

                TC      U06,3166

U06,3156        CCS     UNK1134
                TC      U06,3166

                CAF     ONE
                TS      UNK1134

                TC      BANKCALL
                CADR    U07,2713

                TC      ALARM
                OCT     00633

U06,3166        CAF     BIT3
                EXTEND
                RAND    33
                CCS     A
                TC      U06,3207

                INHINT
                CAF     FIVE
                TC      WAITLIST
                2CADR   U06,3202

                RELINT
                TC      ENDOFJOB

U06,3202        CAF     BIT14
                TC      FINDVAC
                2CADR   U06,3130

                TC      TASKOVER

U06,3207        CS      BIT11
                MASK    UNK1131
                TS      UNK1131

                CCS     UNK1170
                TC      U06,3230

                CAF     ZERO
                TS      FAILREG
                TC      ALARM
                OCT     00634

                CS      BIT2
                MASK    UNK1131
                AD      BIT2
                TS      UNK1131

                CAF     ZERO
                TS      UNK1135

                CAF     U06,3304
                TC      U06,3001

U06,3230        TC      BANKCALL
                CADR    U07,2143

                CAF     BIT2
                TC      U06,2555

                CAF     U06,3301
                MASK    LOTMODES
                CCS     A
                TC      +3
                TC      BANKCALL
                CADR    U07,2731

                CA      UNK1122
                TS      UNK1125

                CCS     AZANG
                TCF     U06,3261

                TC      U06,3256
                TC      U06,3254

                CS      UNK1125
                TS      UNK1125

                CAF     ZERO
                TCF     U06,3261

U06,3254        CS      ZERO
                TCF     U06,3261

U06,3256        CS      UNK1125
                TS      UNK1125
                CAF     ONE
U06,3261        TS      DESLOTSY

                CAF     U06,3302
                TS      DESLOTSX

                INHINT
                CA      UNK1202
                TC      WAITLIST
                2CADR   U06,3305

                RELINT

                CS      BIT1
                MASK    UNK1131
                AD      BIT1
                TS      UNK1131

                TC      BANKCALL
                CADR    U07,2335

U06,3300        OCT     40200
U06,3301        OCT     00140
U06,3302        OCT     16603
U06,3303        OCT     02003
U06,3304        OCT     05670

U06,3305        CAF     BIT14
                EXTEND
                WOR     12
                TC      TASKOVER

ENDLOTTS        EQUALS
