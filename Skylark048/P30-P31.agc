### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	P30-P31.agc
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

# PROGRAM DESCRIPTION	P30	DATE 5-1-69
#
# MOD.I BY S. ZELDIN-  TO ADD P31 AND ADAPT P30 FOR P31 USE.	22DEC67
# MOD.II BY P.WOLFF TO REDUCE CODING AND DELETE RESTART PROTECTION	4-30-69
# MOD.III BY C.BEALS TO DELETE P31	1NOV69
#
# FUNCTIONAL DESCRIPTION
#	P30 (EXTERNAL DELTA-V TARGETTING PROGRAM)
#		ACCEPTS ASTRONAUT INPUTS OF TIG,DELV(LV) AND COMPUTES, FOR DISPLAY,
#		APOGEE, PERIGEE, DELV(MAG), MGA ASSOCIATED WITH DESIRED MANEUVER
#
# THE FOLLOWING SUBROUTINES ARE USED IN P30
#	S30/31.1  COMPUTES APOGEE AND PERIGEE ALTITUDE
#	P30/P31 - DISPLAYS TIG
#	CNTUP30 - DISPLAYS DELV(LV)
#	COMPTGO	  CLOCKTASK COMPUTE TTOGO
#	LOMAT	  COMPUTE X,Y,Z IN LV COORDS
#	PARAM30 - DISPLAYS APOGEE, PERIGEE, DELV(MAG), MGA, TIME FROM TIG,
#	   	  MARKS SINCE LAST THRUSTING MANEUVER
#
# CALLING SEQUENCE VIA JOB FROM V37
#
# EXIT VIA V37 CALL OR GOTOPOOH
#
# OUTPUT FOR POWERED FLIGHT
#	VTIG	X
#	RTIG
#	DELVSIN	X
#
# P30 CALCULATIONS
#
# P30 CALC BASED ON STORED TARGET PARAMETERS (R OF IGNITION (RTIG), V OF
# IGNITION (VTIG), TIME OF IGNITION (TIG), DELV(LV), COMPUTE PERIGEE ALTITUDE
# APOGEE ALTITUDE AND DELTA-V REQUIRED IN REF. COORDS. (DELVSIN)
# 
# ERASABLE INITIALIZATION REQUIRED
#	TIG		TIME OF IGNITION			DP	B28CS
#	DELVSLV		SPECIFIED DELTA-V IN LOCAL VERT.
#			COORDS. OF ACTIVE VEHICLE AT
#			TIME OF IGNITION			VCT.	B+7M/CS
#
# SUBROUTINES CALLED
#	THISPREC
#
# OUTPUT
#	RTIG		POSITION AT TIG				VCT.	B+29M
#	VTIG		VELOCITY AT TIG				VCT.	B+7M
#	DELVSIN		DELVSLV IN REF COORDS			VCT.	B+7M/CS
#
# DEBRIS QTEMP    TEMP. ERASABLE
#	 QPRET, MPAC
#	 PUSHLIST

		SETLOC	P30S1
		BANK

		EBANK=	+MGA

		COUNT*	$$/P30
P30		TC	UPFLAG
		ADRES	UPDATFLG	# SET UPDATFLG
		TC	UPFLAG
		ADRES	TRACKFLG	# SET TRACKFLG
DSP0633		CAF	V06N33		# DISPLAY TIME OF IGNITION
		TC	VNFLASH
		CAF	V06N81
		TC	VNFLASH
		TC	UPFLAG
		ADRES	XDELVFLG	# BIT 8 FLAG 2
		TC	INTPRET
		CLEAR	DLOAD
			UPDATFLG	# RESET UPDATFLG
			TIG		# TIME IGNITION SCALED AT 2(+28)CS
		STCALL	TDEC1
			THISPREC	# ENCKE ROUTINE FOR

		VLOAD
			VATT
		STOVL	VTIG
			RATT
		STORE	RTIG
		STORE	RACT3
		VXV	UNIT
			VTIG
		STCALL	UNRM
			LOMAT
		VLOAD	VXM
			DELVSLV
			0
		VSL1
		STORE	DELVSIN
		ABVAL
		STOVL	VGDISP		# MAG DELV
			RTIG
		PDVL	VAD
			DELVSIN
			VTIG
		CALL	
			S30/31.1
		EXIT
PARAM30		CAF	V06N42		# DISPLAY HAPO, HPER, DELTAV
		TC	VNFLASH
REFTEST		TC	INTPRET
		BOFF	VLOAD
			REFSMFLG	# TEST FOR REFSMFLAG ON
			NOTSET
			DELVSIN
		PUSH	CALL
			GET+MGA
		EXIT
DISPMGA		TC	COMPTGO

DISP45		CAF	V16N45		# DISPLAY MARK CNT, TFI, +MGA
		TC	VNFLASH
		TC	DOWNFLAG
		ADRES	TIMRFLAG	# RESET TIMRFLAG
		TCF	GOTOPOOH

COMPTGO		EXTEND
		QXCH	PHSPRDT6

		TC	UPFLAG		# SET TIMRFLAG
		ADRES	TIMRFLAG
		CAF	ZERO
		TS	NVWORD1

		CAF	ONE
		TC	WAITLIST
		EBANK=	TIG
		2CADR	CLOKTASK

		TC	2PHSCHNG
		OCT	40036		# 6.3SPOT FOR CLOKTASK
		OCT	05024		# GROUP 4 CONTINUES HERE
		OCT	13000

6P3SPT1		=	6.3SPOT
		TC	PHSPRDT6

NOTSET		DLOAD	DCOMP
			MARSDP
		STORE	+MGA
		RTB
			DISPMGA
MARSDP		OCT	00000		# (00000) (16440) = (+00001)
		OCT	35100
					# ( .01 ) DEGREES IN THE LOW ORDER REGISTE
			
V06N42		VN	0642


# S30/31.1	SUBROUTINE USED BY P30/P31 CALCULATIONS
# MOD NO 1		LOG SECTION P30,P37
#
# FUNCTIONAL DESCRIPTION
#	THROUGH A SERIES OF CALLS COMPUTES APOGEE AND PERIGEE ALTITUDE
#
# SUBROUTINES CALLED
#	PERIAPO1
#	MAXCHK
#
# CALLING SEQUENCE
#	L	CALL
#	L+1		S30/31.1
#
# NORMAL EXIT MODE
#	AT L+2 OR CALLING SEQUENCE
#
# OUTPUT
#	HAPO		APOGEE ALT.		DP 	B+29 M
#	HPER		PERIGEE ALT.		DP 	B+29 M

		SETLOC	P30S1A
		BANK
		
		COUNT*	$$/P30
S30/31.1	STQ	CALL
			QTEMP
			PERIAPO1
		CALL
			MAXCHK
		STODL	HPER		# PERIGEE ALT B+29
			4D
		CALL
			MAXCHK
		STCALL	HAPO		# APOGEE ALT B+29
			QTEMP


# SUBROUTINE NAME:	DELRSPL		(CONTINUATION OF V 82 IN CSM IF P11 ACTI
# TRANSFERRED COMPLETELY FROM SUNDISK, P30S REV 33. 9 SEPT 67.
# MOD NO: 0	MOD BY: ZELDIN		DATE:
# MOD NO: 1	MOD BY: RR BAIRNSFATHER	DATE: 11 APR 67
# MOD NO: 2	MOD BY: RR BAIRNSFATHER	DATE: 12 MAY 67		ADD UR.RT CALC WHEN BELOW 300K FT
# MOD NO: 2.1	MOD BY: RR BAIRNSFATHER	DATE: 5 JULY 67		FIX ERROR IN MOD. 2.
# MOD NO: 3	MOD BY: RR BAIRNSFATHER	DATE: 12 JUL 67		CHANGE SIGN OF DISPLAYED ERROR.
# MOD 4		MOD BY  S.ZELDIN	DATE  3 APRIL 68	CHANGE EQUATIONS FOR L/D=.18 WHICH REPLA
#
# FUNCTION:	CALCULATE (FOR DISPLAY ON CALL) AN APPROXIMATE MEASURE OF IN-PLANE SPLASH DOWN
#		ERROR. IF THE FREE-FALL TRANSFER ANGLE TO 300K FT ABOVE PAD RADIUS IS POSITIVE:
#		SPLASH ERROR= -RANGE TO TARGET + FREE-FALL TRANSFER ANGLE + ESTIMATED ENTRY ANGLE.
#		THE TARGET LOCATION AT ESTIMATED TIME OF IMPACT IS USED.  IF THE FREE-FALL TRANSFER
#		ANGLE IS NEGATIVE:  SPLASH ERROR= -RANGE TO TARGET
#		THE PRESENT TARGET LOCATION IS USED.
#
# CALLING SEQUENCE  CALLED AFTER SR30.1 IF IN CSM AND IF P11 OPERATING (UNDER CONTROL OF V82)
#
# SUBROUTINES CALLED:  VGAMCALC, TFF/TRIG, LALOTORV.
#
# EXIT 		RETURN DIRECTLY TO V 82 PROG. AT SPLRET
#
# ERASABLE INITIALIZATION   LEFT BY SR30.1 AND V82GON1
#
# OUTPUT:	RSP-RREC  RANGE IN REVOLUTIONS   		DSKY DISPLAY IN N. MI.
#
# DEBRIS:	QPRET, PDL0 ... PDL7, PDL10
# 		THETA(1)

		SETLOC	DELRSPL1
		BANK
		COUNT*	$$/P30		# PROGRAMS: P30 EXTERNAL DELTA V
		
DELRSPL		STORE	8D
		BPL	DSU
			CANTDO		# GONE PAST 300K FT ALT
			1BITDP
		BOV	CALL
			CANTDO		# POSMAX INDICATES NO 300K FT SOLUTION.
			VGAMCALC	# +GAMMA(REV) IN PMAC,V300 MAG(B-7)=PDL 0
		PUSH	CALL
			TFF/TRIG
		CALL
			AUGEKUGL
		PDDL	ACOS		# T ENTRY PDL 6
			CDELF/2
		DAD
			4
GETARG		STOVL	THETA(1)
			LAT(SPL)
		STODL	LAT
			HI6ZEROS
		STODL	ALT		# ALT=0 = LAT +4
			PIPTIME
		BON	DLOAD
			V37FLAG
			+2
			TSTART82
		DSU	DAD
			8D
		CLEAR	CALL
			ERADFLAG
			LALOTORV	# R RECOV. IN ALPHAV AND MPAC

		UNIT	PDVL
			RONE
		UNIT	DOT
		SL1	ARCCOS
		BDSU			# ERROR = THETA EST - THETA TARG
					# NEGATIVE NUMBER SIGNIFIES THAT WILL FALL SHORT.
					# POSITIVE NUMBER SIGNIFIES THAT WILL OVERSHOOT.
			THETA(1)
DELRDONE	STCALL	RSP-RREC	# DOWNRANGE RECOVERY RANGE ERROR	/360
			INTWAKE0
		CALL
			SPLRET
CANTDO		DLOAD	PDDL		# INITIALIZE ERASE TO DOT TARGET AND UR
					# FOR RANGE ANGLE.
			HIDPHALF	# TO PDL 0 FOR DEN IN DDV.
			HI6ZEROS
		PUSH			# ZERO TO PDL 2 FOR PHI ENTRY
		STCALL	8D
			GETARG		# GO SET RSP-RREC =0
			
AUGEKUGL	VLOAD
			X1CON -2
		STODL	X1 -2
			0
		DSU	BMN
			V(21K)
			LOOPSET
		XSU,1	XCHX,2
			S1
			X1
		XCHX,2	DSU
			S1
			V(3K)
		BMN	XCHX,2
			LOOPSET
			S1
		DSU	BMN
			V(4K)
			LOOPSET
		XCHX,2	XCHX,2
			S1
			X1
		DSU	BMN
			V(400)
			LOOPSET
		SXA,1
			S1
LOOPSET		INCR,1	GOTO
		DEC	1
			K1K2LOOP
K2CALC		SXA,1
			S1
K1K2LOOP	DLOAD	DSU*
			0
			V(32K) +1,1
		DMP*	DAD*
			YK1K2 +1,1
			CK1K2 +1,1
		PDDL	TIX,1
			2
			K2CALC
		DSU	BDDV
		PUSH	BOV		# PHI ENTRY PDL 4D
			MAXPHI
		BMN	DSU
			MAXPHI
			MAXPHIC
		BPL
			MAXPHI
PHICALC		DLOAD	DSU
			0
			V(26K)
		BPL	DLOAD
			TGR26
			TLESS26
		DDV
			0
TENT		DMP	RVQ
			4D
TGR26		DLOAD	GOTO
			TGR26CON
			TENT
			
MAXPHI		DLOAD	PDDL
			MAXPHIC
		GOTO
			PHICALC
MAXPHIC		2DEC	.09259298	# 2000 NM FOR MAXIMUM PHI ENTRY

		COUNT*	$$/P30

		
					# 		BELOW
					# <<<< TABLE IS INDEXED. KEEP IN ORDER >>>

		2DEC	7.07304526 E-4		# 5500
		
		2DEC	3.08641975 E-4		# 2400
		
		2DEC	3.08641975 E-4		# 2400
		
		2DEC	-8.8888888 E-3		# -3.2
		
		2DEC	2.7777777 E-3		# 1
		
CK1K2		2DEC	6.6666666 E-3		# 2.4

		2DEC	0			# 0
		
		2DEC*	-1.86909989 E-5 B7* 	# -.443
		
		2DEC	0
		
		2DEC*	1.11639691 E-3 B7*	# .001225
		
		2DEC*	9.56911636 E-4 B7*	# .00105
		
YK1K2		2DEC*	2.59733157 E-4 B7*	# .000285

V(400)		2DEC	1.2192 B-7

V(28K)		2DEC	85.344 B-7

V(3K)		2DEC	9.144 B-7

V(24K)		2DEC	73.152 B-7

		2DEC	85.344 B-7
		
V(32K)		2DEC	97.536 B-7

V(4K)		2DEC	12.192 B-7

V(21K)		2DEC	64.008 B-7

TLESS26		2DEC*	5.70146688 E7 B-35*	# 8660PHI/V

TGR26CON	2DEC	7.2 E5 B-28		# PHI/3

V(26K)		2DEC	79.248 B-7		# 26000

X1CON		DEC	10


		DEC	8
		DEC	6
					# <<<< TABLE IS INDEXED. KEEP IN ORDER >>>
					#		ABOVE

		SETLOC	P30SUBS
		BANK
		COUNT*	$$/P30
		EBANK=	SUBEXIT
P20FLGON	EXTEND
		QXCH	SUBEXIT
		TC	UPFLAG
		ADRES	TRACKFLG
		TC	UPFLAG
		ADRES	UPDATFLG
		TC	DOWNFLAG
		ADRES	PCFLAG
		TC	SUBEXIT

		SETLOC	P38TAG
		BANK
# PLANE CHANGE TARGETING PROGRAM	P38
# 
# PURPOSE
#	TO COMPUTE PARAMETERS FOR PLANE CHANGE MANEUVER
#
# INPUT
#	TCSI
# 
# OUTPUT
# 	TIG		TIME OF PLANE CHANGE MANEUVER  COMPUTED TO BE
#			TCSI + 90 DEG TRANSFER TIME
#	DELVLVC		DELTA VELOCITY AT PC - LOCAL VERTICAL
#	DELVSIN		DELTA VELOCITY AT PC - REFERENCE

		COUNT*	$$/P3138
P38		TC	P20FLGON	# SET TRACK,UPDATE - CLEAR PC FLAGS
		TC	UPFLAG
		ADRES	PCFLAG

		TC	INTPRET
		CLEAR	DLOAD
			FINALFLG
			TIG
		STORE	LASTTIG
		EXIT
		CAF	V06N39
		TC	VNFLASH
		TC	INTPRET
P38A		SET	DLOAD
			XDELVFLG
			LASTTIG
		STCALL	TDEC1
			CSMCONIC	# INTEGRATE STATES TO TCSI
		DLOAD	SET
			ZEROVECS
			RVSW
		STODL	CSTH		# COS 90 DEGREES
			CS359+
		STOVL	SNTH		# SINE 90 DEGREES
			RATT
		STOVL	RVEC
			VATT
		STCALL	VVEC		# COMPUTE TRANSFER TIME OF 90 DEG
			TIMETHET
		DAD
			LASTTIG
		STORE	TIG
		EXIT
		CAF	V06N33
		TC	VNFLASH
		TC	INTPRET
		CALL
			VN1645
P38RECYC	VLOAD
			ZEROVECS
		STODL	DELVLVC
			TIG
		STCALL	TDEC1
			PRECSET
		BON	SET
			FINALFLG
			+2
			UPDATFLG
		VLOAD
			VACT3
		STOVL	VTIG
			RACT3
		STCALL	RTIG
			DISPN90
		CALL
			LOMAT
		VLOAD	VXM
			DELVLVC
			0D
		VSL1
		STCALL	DELVSIN
			VN1645
		GOTO
			P38RECYC

CS359+		2DEC	+.499999992
V06N39		VN	0639
