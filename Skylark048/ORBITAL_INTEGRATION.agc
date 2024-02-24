### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	ORBITAL_INTEGRATION.agc
## Purpose:	A section of Skylark revision 048.
##		It is part of the source code for the Apollo Guidance Computer
##		(AGC) for Skylab-2, Skylab-3, Skylab-4, and ASTP. No original
##		listings of this software are available; instead, this file was
##		created via disassembly of the core rope modules actually flown
##		on Skylab-2.
## Assembler:	yaYUL
## Contact:	Ron Burkey <info@sandroid.org>.
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2023-09-04 MAS  Created from Artemis 072.

# DELETE
		SETLOC	ORBITAL
		BANK
		COUNT*	$$/ORBIT

# DELETE
KEPPREP		SETPD	DLOAD
			0
			MUEARTH
		SQRT	PDVL		# SQRT(MU) (+18 OR +15)		0D	PL 2D
			RCV
		UNIT	PDVL		#					PL 8D
			36D
		NORM	PDVL		# NORM R (+29 OR +27 - N1)	2D	PL 4D
			X1
		DOT	PDDL		# F*SQRT(MU) (+7 OR +5) 	4D	PL 6D
			VCV
			TAU.		# (+28)
		DSU	NORM
			TC
			S1
		SR1
		DDV	PDDL
			2D
		DMP	PUSH		# FS (+6 +N1-N2) 		6D	PL 8D
			4D
		DSQ	PDDL		# (FS)SQ (+12 +2(N1-N2))	8D	PL 10D
			4D
		DSQ	PDDL		# SSQ/MU (-2 OR +2(N1-N2))	10D	PL 12D
			MUEARTH
		SR3	SR4
		PDVL	VSQ		# PREALIGN MU (+43 OR +37) 	12D	PL 14D
			VCV
		DMP	BDSU		#					PL 12D
			36D
		DDV	DMP		#					PL 10D
			2D		# -(1/R-ALPHA) (+12 +3N1-2N2)
		DMP	SL*
			DP2/3
			0 -3,1		# 10L(1/R-ALPHA) (+13 +2(N1-N2))
		XSU,1	DAD		# 2(FS)SQ - ETCETRA			PL 8D
			S1		# X1 = N2-N1
		SL*	DSU		# -FS+2(FS)SQ ETC (+6 +N1-N2)		PL 6D
			8D,1
		DMP	DMP
			0D
			4D
		SL*	SL*
			8D,1
			0,1		# S(-FS(1-2FS)-1/6...) (+17 OR +16)
		DAD	PDDL		#					PL 6D
			XKEP
		DMP	SL*		# S(+17 OR +16)
			0D
			1,1
		BOVB	DAD
			TCDANZIG
		STADR
		STORE	XKEPNEW
		STQ	GOTO
			KEPRTN
			KEPLERN

FBR3		LXA,1	SSP
			DIFEQCNT
			S1
		DEC	-13
		DLOAD	SR
			DT/2
			9D
		TIX,1	ROUND
			+1
		PUSH	DAD
			TC
		STODL	TAU.
		DAD
			TET
		STCALL	TET
			KEPPREP


# AGC ROUTINE TO COMPUTE ACCELERATION COMPONENTS.

ACCOMP		VLOAD
			ZEROVEC
		STOVL	FV
			ALPHAV
		SR	VAD
			7
			RCV
		STORE	BETAV
		BOF	XCHX,2
			DIM0FLAG
			+5
			DIFEQCNT
		STORE	VECTAB,2
		XCHX,2
			DIFEQCNT
		VLOAD	UNIT
			ALPHAV
		STODL	ALPHAV
			36D
		STCALL	ALPHAM
			GAMCOMP
		VLOAD	SXA,1
			BETAV
			S2
		STODL	ALPHAV
			BETAM
		STORE	ALPHAM
		GOTO
			OBLATE
GAMCOMP		VLOAD	VSR1
			BETAV
		VSQ	SETPD
			0
		NORM	ROUND
			31D
		PDDL	NORM		# NORMED B SQUARED TO PD LIST
			ALPHAM		# NORMALIZE (LESS ONE) LENGTH OF ALPHA
			32D		# SAVING NORM SCALE FACTOR IN X1
		SR1	PDVL
			BETAV		# C(PDL+2) = ALMOST NORMED ALPHA
		UNIT
		STODL	BETAV
			36D
		STORE	BETAM
		NORM	BDDV		# FORM NORMALIZED QUOTIENT ALPHAM/BETAM
			33D
		SR1R	PDDL		# C(PDL+2) = ALMOST NORMALIZED RHO.
			ASCALE
		STORE	S1
		XCHX,2	XAD,2
			S1
			32D
		XSU,2	DLOAD
			33D
			2D
		SR*	XCHX,2
			0 -1,2
			S1
		PUSH	SR1R		# RHO/4 TO 4D
		PDVL	DOT
			ALPHAV
			BETAV
		SL1R	BDSU		# (RHO/4) - 2(ALPHAV/2.BETAV/2)
		PUSH	DMPR		# TO PDL+6
			4
		SL1
		PUSH	DAD
			DQUARTER
		PUSH	SQRT
		DMPR	PUSH
			10D
		SL1	DAD
			DQUARTER
		PDDL	DAD		# (1/4)+2((Q+1)/4)	TO PD+14D
			10D
			HALFDP
		DMPR	SL1
			8D
		DAD	DDV
			THREE/8
			14D
		DMPR	VXSC
			6
			BETAV		#               -
		PDVL	VSR3		# (G/2)(C(PD+4))B/2 TO PD+16D
			ALPHAV
		VAD	PUSH		# A12 + C(PD+16D) TO PD+16D
		DLOAD	DMP
			0
			12D		# -
		NORM	ROUND
			30D
		BDDV	DMP
			2
			MUEARTH
		DCOMP	VXSC
		XCHX,2	XAD,2
			S1
			S2
		XSU,2	XSU,2
			30D
			31D
		BOV			# CLEAR OVIND
			+1
		VSR*	XCHX,2
			0 -1,2
			S1
		VAD
			FV
		STORE	FV
		BOV	RVQ		# RETURN IF NO OVERFLOW
			+1
GOBAQUE		VLOAD	ABVAL
			TDELTAV
		BZE
			INT-ABRT
		DLOAD	SR
			H
			9D
		PUSH	BDSU
			TC
		STODL	TAU.
			TET
		DSU	STADR
		STCALL	TET
			KEPPREP
		CALL
			RECTIFY
		GOTO
			TESTLOOP

INT-ABRT	EXIT
		TC	POODOO
		OCT	20430		# SUB-SURFACE STATE VECTOR


# THE OBLATE ROUTINE COMPUTES THE ACCELERATION DUE TO OBLATENESS. IT USES THE UNIT OF THE VEHICLE
# POSITION VECTOR FOUND IN ALPHAV AND THE DISTANCE TO THE CENTER IN ALPHAM. THIS IS ADDED TO THE SUM OF THE
# DISTURBING ACCELERATIONS IN FV AND THE PROPER DIFEQ STAGE IS CALLED VIA X1.

OBLATE		SETPD	VLOAD
			0
			UNITW
		DOT
			ALPHAV
		STORE	COSPHI/2
		DMPR	PDDL		# P	B-6	 ,  3COSPHI/64		 AT 00D
			3/32		#  2
			COSPHI/2
		DSQ	DMPR	
			15/16		#  '                            2
		DSU	PUSH		# P	B-5	 ,(1/2)(15COSPHI -3)	 AT 02D
			3/64		#  3
		DMPR	DMP
			COSPHI/2
			7/12
		SL1R	PDDL
			0D
		DMPR	BDSU
			2/3		#  '				 '    '
		PUSH	DMPR		# P	B-7	 ,(1/3)(7COSPHI P  -4P ) AT 04D
			COSPHI/2	#  4				 3    2
		DMPR	PDDL
			9/16
			2D		#  '				 '    '
		DMPR	BDSU		# P	B-10	 ,(1/4)(9COSPHI P  -5P )
			5/128		#  5				 4    3
		DMP	DDV		#			     '
			J4REQ/J3	#	B-	 ,(J RP/J R)P
			ALPHAM		# 		    4    3   5
		DAD	DMPR
			4D		# 		        2     2  '              '
			2J3RE/J2	# 	B	 ,(2J RP /J2 R )P  +(2J RP/J2R)P
		DDV	DAD		# 		     4           5     3        4
			ALPHAM		#  -        2 '  2         '        '
			2D		# (R/R)(J RP P /R + 2J RP P /  + J P )
		VXSC			#        4    5       3    4  2   2 3
			ALPHAV		#                   4       2  '           -
		STODL	TVEC		# 	B-6	, (SUM((J /R )P   (COSPHI))UR)
		DMP	SR1		#                  I=2   I     I+1
			J4REQ/J3	#                          '
		DDV	DAD		# 		(J RP/J R)P
			ALPHAM		# 		  4    3   4
		DMPR	SR3		# 	      2    2  '              '
			2J3RE/J2	# 	(2J RP /J R )P  +(2J RP/J R)P
		DDV	DAD		# 	   4     2    4     3    2   3
			ALPHAM		# 
		VXSC	BVSU		# 		 4   '        -
			UNITW		# 	B-6	SUM(P(COSPHI))UZ
					#		I=2  I
			TVEC	        #  4              I-2   '          -
		STODL	TVEC		# SUM((MU J (RP/R)   )(P   (COSPHI)UR -
			ALPHAM		# I=2      I            I+2
		NORM	DSQ		#             P (COSPHI)UZ))	B-6 	AT 20D
			X1		#              I
		DSQ	NORM
			S1		#             4
		PUSH	BDDV		# NORMALIZED R				AT 00D
			J2REQSQ
		VXSC	BOV
			TVEC
			+1		# B+38 FOR EARTH, B+42 FOR MOON
		XAD,1	XAD,1
			X1
			X1
		XAD,1	VSL*
			S1
			0 -22D,1
		VAD	BOV
			FV
			GOBAQUE
		STORE	FV		# B+16 FOR EARTH
NBRANCH		SLOAD	LXA,1
			DIFEQCNT
			MPAC
		DMP	CGOTO
			-1/12
			MPAC
			DIFEQTAB

DIFEQTAB	CADR	DIFEQ+0
		CADR	DIFEQ+1
		CADR	DIFEQ+2
		
TIMESTEP	VLOAD	ABVAL		# RECTIFY IF
			TDELTAV
		BOV
			CALLRECT
		DSU	BPL		#	1) EITHER TDELTAV OR TNUV EQUALS OR
			3/4		#	   EXCEEDS 3/4 IN MAGNITUDE
			CALLRECT	#
		DAD	SR		#			OR
			3/4		#
			7		#	2) ABVAL(TDELTAV) EQUALS OR EXCEEDS
		DDV	DSU		#	   .01(ABVAL(RCV))
			10D
			RECRATIO
		BPL	VLOAD
			CALLRECT
			TNUV
		ABVAL	DSU
			3/4
		BOV	BMN
			CALLRECT
			INTGRATE
CALLRECT	CALL
			RECTIFY
INTGRATE	CLEAR	VLOAD
			JSWITCH
			TNUV
		STOVL	ZV
			TDELTAV
		STORE	YV
DIFEQ0		VLOAD	SSP
			YV
			DIFEQCNT
			0
		STODL	ALPHAV
			DPZERO
		STORE	H		# START H AT ZERO. GOES 0(DELT/2)DELT.
		BON	GOTO
			JSWITCH
			DOW..
			ACCOMP

# THE RECTIFY SUBROUTINE IS CALLED BY THE INTEGRATION PROGRAM AND OCCASIONALLY BY THE MEASUREMENT INCORPORATION
# ROUTINES TO ESTABLISH A NEW CONIC.

RECTIFY		VLOAD	VSR
			TDELTAV
			7
		VAD
			RCV
		STORE	RRECT
		STOVL	RCV
			TNUV
		VSR	VAD
			4
			VCV
MINIRECT	STORE	VRECT
TINIRECT	STOVL	VCV
			ZEROVEC
		STORE	TDELTAV
		STODL	TNUV
			ZEROVEC
		STORE	TC
		STORE	XKEP
		RVQ


# THE THREE DIFEQ ROUTINES - DIFEQ+0, DIFEQ+12, AND DIFEQ+24 - ARE ENTEREDTO PROCESS THE CONTRIBUTIONS AT THE
# BEGINNING, MIDDLE, AND END OF THE TIMESTEP, RESPECTIVELY. THE UPDATING IS DONE BY THE NYSTROM METHOD.

DIFEQ+0		VLOAD	VSR3
			FV
		STCALL	PHIV
			DIFEQCOM
DIFEQ+1		VLOAD	VSR1
			FV
		PUSH	VAD
			PHIV
		STOVL	PSIV
		VSR1	VAD
			PHIV
		STCALL	PHIV
			DIFEQCOM
DIFEQ+2		DLOAD	DMPR
			H
			DP2/3
		PUSH	VXSC
			PHIV
		VSL1	VAD
			ZV
		VXSC	VAD
			H
			YV
		STOVL	YV
			FV
		VSR3	VAD
			PSIV
		VXSC	VSL1
		VAD
			ZV
		STORE	ZV
		BOFF	CALL
			JSWITCH
			ENDSTATE
			GRP2PC
		LXA,2	VLOAD
			COLREG
			ZV
		VSL3			# ADJUST W-POSITION FOR STORAGE
		STORE	W +54D,2
		VLOAD
			YV
		VSL3	BOV
			WMATEND
		STORE	W,2

		CALL
			GRP2PC
		LXA,2	SSP
			COLREG
			S2
			0
		INCR,2	SXA,2
			6
			YV
		TIX,2	CALL
			RELOADSV
			GRP2PC
		LXA,2	SXA,2
			YV
			COLREG

NEXTCOL		CALL
			GRP2PC
		LXA,2	VLOAD*
			COLREG
			W,2
		VSR3			# ADJUST W-POSITION FOR INTEGRATION
		STORE	YV
		VLOAD*	AXT,1
			W +54D,2
			0
		VSR3			# ADJUST W-VELOCITY FOR INTEGRATION
		STCALL	ZV
			DIFEQ0

ENDSTATE	BOV	VLOAD
			GOBAQUE
			ZV
		STOVL	TNUV
			YV
		STORE	TDELTAV
		BON	BOFF
			MIDAVFLG
			CKMID2		# CHECK FOR MID2 BEFORE GOING TO TIMEINC
			DIM0FLAG
			TESTLOOP
		EXIT
		TC	PHASCHNG
		OCT	04022		# PHASE 1
		TC	UPFLAG		# PHASE CHANGE HAS OCCURRED BETWEEN
		ADRES	REINTFLG	# INTSTALL AND INTWAKE
		TC	INTPRET
		SSP
			QPRET
			AMOVED
		BON	GOTO
			VINTFLAG
			ATOPCSM
			ATOPLEM
AMOVED		SET	SSP
			JSWITCH
			COLREG
		DEC	-30
		GOTO
			NEXTCOL


RELOADSV	DLOAD			# RELOAD TEMPORARY STATE VECTOR
			TDEC		# FROM PERMANENT IN CASE OF
		STCALL	TDEC1
			INTEGRV2	# BY STARTING AT INTEGRV2.
DIFEQCOM	DLOAD	DAD		# INCREMENT H AND DIFEQCNT.
			DT/2
			H
		INCR,1	SXA,1
		DEC	-12
			DIFEQCNT	# DIFEQCNT SET FOR NEXT ENTRY.
		STORE	H
		VXSC	VSR1
			FV
		VAD	VXSC
			ZV
			H
		VAD
			YV
		STORE	ALPHAV
		BON	GOTO
			JSWITCH
			DOW..
			FBR3

WMATEND		CLEAR	CLEAR
			DIM0FLAG	# DONT INTEGRATE W THIS TIME
			RENDWFLG
		SET	EXIT
			STATEFLG	# PICK UP STATE VECTOR UPDATE
		TC	ALARM
		OCT	421
		TC	INTPRET
		GOTO
			TESTLOOP	# FINISH INTEGRATING STATE VECTOR


# ORBITAL ROUTINE FOR EXTRAPOLATION OF THE W MATRIX. IT COMPUTES THE SECOND DERIVATIVE OF EACH COLUMN POSITION
# VECTOR OF THE MATRIX AND CALLS THE NYSTROM INTEGRATION ROUTINES TO SOLVE THE DIFFERENTIAL EQUATIONS. THE PROGRAM
# USES A TABLE OF VEHICLE POSITION VECTORS COMPUTED DURING THE INTEGRATION OF THE VEHICLES POSITION AND VELOCITY.

DOW..		VLOAD	VSR4
			ALPHAV
		PDVL*	UNIT
			VECTAB,1
		PDVL	VPROJ
			ALPHAV
		VXSC	VSU
			3/4
		PDDL	NORM
			36D
			S2
		PUSH	DSQ
		DMP
		NORM	PDDL
			34D
			MUEARTH
		SR1	DDV
		VXSC
		LXA,2	XAD,2
			S2
			S2
		XAD,2	XAD,2
			S2
			34D
		VSL*
			0 -8D,2	
		STCALL	FV
			NBRANCH

		SETLOC	ORBITAL1
		BANK

		COUNT*	$$/ORBIT
THREE/8		2DEC	.375

.3D		2DEC	.3 B-2

3/64		2DEC	3 B-6

DP1/4		=	D1/4		# 1 B-2
DQUARTER	EQUALS	DP1/4
3/32		2DEC	3 B-5

15/16		2DEC	15. B-4

3/4		2DEC	3.0 B-2

7/12		2DEC	.5833333333

9/16		2DEC	9 B-4

5/128		2DEC	5 B-7

DPZERO		EQUALS	ZEROVEC
DP2/3		2DEC	.6666666667

2/3		EQUALS	DP2/3
# LM504 IS TEMPORARY
		SETLOC	ORBITAL1
		BANK
		COUNT*	$$/ORBIT
# IT IS VITAL THAT THE FOLLOWING CONSTANTS NOT BE SHUFFLED
ASCALE		DEC	-7
		DEC	-6
		
MUEARTH		=	MUTABLE
		
J4REQ/J3	2DEC*	.4991607391 E7 B-26*

2J3RE/J2	2DEC*	-.1355426363 E5 B-27*

J2REQSQ		2DEC*	1.75501139 E21 B-72*

-1/12		2DEC	-.1

RECRATIO	2DEC	.01

RATT		EQUALS 	00
VATT		EQUALS	6D
TAT		EQUALS	12D
RATT1		EQUALS	14D
VATT1		EQUALS	20D
MU(P)		EQUALS	26D
TDEC1		EQUALS	32D
URPV		EQUALS	14D
COSPHI/2	EQUALS	URPV +4
UZ		EQUALS	20D
TVEC		EQUALS	26D
