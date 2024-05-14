### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	REENTRY_CONTROL.agc.agc
## Purpose:	A section of Comanche revision 067.
##		It is part of the reconstructed source code for the flight
##		software for the Command Module's (CM) Apollo Guidance Computer
##		(AGC) for Apollo 12. No original listings of this program are
##		available; instead, this file was created via dissassembly of
##		dumps of Comanche 067 core rope modules and comparison with
##		other AGC programs.
## Assembler:	yaYUL
## Contact:	Ron Burkey <info@sandroid.org>.
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2023-08-16 MAS	Created from Comanche 055.
##		2024-05-13 MAS	Updated for Comanche 067.

# ENTRY INITIALIZATION ROUTINE
#  -----------------------------

		BANK	25
		SETLOC	REENTRY
		BANK
		
		COUNT*	$$/ENTRY
		EBANK=	RTINIT
		
EBENTRY		=	EBANK7
EBAOG		EQUALS	EBANK6
NTRYPRIO	EQUALS	PRIO20		# (SERVICER)
CM/FLAGS	EQUALS	STATE +6

STARTENT	EXIT			# MM = 63

					# COME HERE FROM CM/POSE.  RESTARTED IN CM/POSE.
		CS	ENTMASK		# INITIALIZE ALL SWITCHES TO ZERO
					# EXCEPT LATSW, ENTRYDSP AND GONEPAST.
					# GONEBY 112D BIT8 FLAG7, SELF INITIALIZING
		INHINT
		MASK	CM/FLAGS
					# ENTRYDSP = 92D B13
					# GONEPAST=95D B10,	RELVELSW=96D B9
					# EGSW = 97D B8		NOSWITCH = 98D B7
					# HIND=99D B6		INRLSW=100D B5
					# LATSW=101D B4		.05GSW=102D B3
					
		AD	ENTRYSW		# SET ENTRYDSP, LATSW, GONEPAST.
		TS	CM/FLAGS
		
		RELINT
		
		TC	INTPRET
		
		SLOAD
			LODPAD
		STORE	LOD
		
		SLOAD
			LADPAD
		STORE	LAD
		
		DMP			# L/DCMINR = LAD COS(15)
			COS15
		STODL	L/DCMINR
			LATSLOPE
		DMP	SR1		# KLAT = LAD/24
			LAD
		STODL	KLAT
			Q7F
		STODL	Q7		# Q7 = Q7F
			NEARONE		# 1.0 -1BIT
		STODL	FACTOR
			LAD
		SIGN	DCOMP
			HEADSUP		# MAY BE NOISE FOR DISPLAY P61
		STCALL	L/D		# L/D = - LAD SGN(HEADSUP)
		
			STARTEN1	# RETURN VIA GOTOADDR
		VLOAD	VXV
			VN		# (-7) M/CS
			UNITR		# .5 UNIT		REF COORDS
		UNIT	DOT
			RT		# RT/2 TARGET VECTOR	REF COORDS
		STORE	LATANG		# LATANG = UNI.RT /4
		DCOMP	RTB
			SIGNMPAC
		STODL	K2ROLL		# K2ROLL = -SGN(LATANG)
		
			LAD
		DMP	DAD
			Q21
			Q22
		STORE	Q2		# Q2 = -1152 + 500 LAD
		
		SSP	SSP
			GOTOADDR	# SET SELECTOR FOR INITIAL PASS
			INITROLL
			POSEXIT
			SCALEPOP	# SET CM/POSE TO CONTINUE AT SCALEPOP
			
		RTB
			SERVNOUT	# OMIT INITIAL DISPLAY, SINCE 1ST GUESSBAD
			
# CALCULATE THE INITIAL TARGET VECTOR: RTINIT, ALSO RTEAST, RTNORM AND RT.  ALL ARE .5 UNIT AND IN
# REFERENCE COORDINATES.

STARTEN1	STQ	VLOAD
			GOTOADDR
			LAT(SPL)	# TARGET COORDINATES
		CLEAR	CLEAR		# DO CALL USING PAD RADIUS.  WILL UNIT IT.
			ERADFLAG	# ANYWAY.
			LUNAFLAG
		STODL	LAT
			3ZEROS
			
		STODL	LAT +4		# SET ALT=0.
			PIPTIME		# ESTABLISH RTINIT AT TIME OF PRESENT
					# RN AND VN.
		STCALL	TIME/RTO	# SAVE TIME BASE OF RTINIT.
			LALOTORV	# C(MPAC) =TIME  (PIPTIME)
		UNIT			# ANSWER IN ALPHAV ALSO
		STODL	RTINIT		# .5 UNIT TARGET		REF COORDS
			500SEC		# NOMINAL ENTRY TIME FOR P63
					# TIME/RTO = PIPTIME, STILL.
		STCALL	DTEAROT		# INITIALIZE EARROT
			EARROT1		# GET RT
		DOT	SL1
			UNITR		# RT/2 IN MPAC
		ACOS
		STCALL	THETAH		# RANGE ANGLE /360
			GOTOADDR	# RETURN TO CALLER
			
500SEC		2DEC	50000 B-28	# CS

ENTMASK		OCT	11774
ENTRYSW		OCT	11010		# ENTRYDSP B13,  GONEPAST B10,  LATSW B4

SCALEPOP	CALL	
			TARGETNG
			
		EXIT
		
REFAZE10	TC	PHASCHNG
		OCT	10035		# SERVICER 5.3 RESTART AT REFAZE10
		
		TC	INTPRET
		
# JUMP TO PARTICULAR RE-ENTRY PHASE:
#				SEQUENCE
		GOTO
			GOTOADDR
			
#          GOTOADDR CONTAINS THE ADDRESS OF THE ROLL COMMAND EQUATIONS APPROPRIATE TO THE CURRENT PHASE OF
# RE-ENTRY.  SEQUENCING IS AS FOLLOWS:
#
# INITROLL	ADDRESS IS SET HERE INITIALLY.  HOLDS INITIAL ROLL ATTITUDE UNTIL  KAT  IS EXCEEDED.  THEN HOLDS NEW ROLL
#		ATTITUDE UNTIL  VRTHRESH  IS EXCEEDED.  THEN BRANCHES TO
#
# HUNTEST	THIS SECTION CHECKS TO SEE IF THE PREDICTED RANGE AT NOMINAL   L/D FROM PRESENT CONDITIONS IS LESS
#		THAN THE DESIRED RANGE.
#			IF NOT - A ROLL COMMAND IS GENERATED BY THE CONSTANT DRAG CONTROLLER.
#			IF SO  - CONTROL AND GOTOADDR ARE SET TO UPCONTRL.
#		USUALLY NO ITERATION IS INVOLVED EXCEPT IF THE RANGE DESIRED IS TOO LONG ON THE FIRST PASS THROUGH
#		HUNTEST.
#
# UPCONTRL	CONTROLS ROLL DURING THE SUPER-CIRCULAR PHASE.  UPCONTRL IS TERMINATED EITHER
#			(A) WHEN THE DRAG (AS MEASURED BY THE PIPAS) FALLS BELOW Q7, OR
#			(B) IF RDOT IS NEGATIVE AND REFERENCE VL EXCEEDS V.
#		IN CASE (A),  GOTOADDR  IS SET TO  KEP2  AND IN CASE (B), TO  PREDICT3  SKIPPING THE KEPLER PHASE OF
#		ENTRY.
#
# KEP2		GOTOADDR IS SET HERE DURING THE KEPLER PHASE TO MONITOR DRAG.  THE SPACECRAFT IS INSTANTANEOUSLY
#		TRIMMED IN PITCH AND YAW TO THE COMPUTED RELATIVE VELOCITY.  THE LAST COMPUTED ROLL ANGLE IS MAINTAINED.
#		WHEN THE MEASURED DRAG EXCEEDS Q7 +0.5,  GOTOADDR  IS SET TO
#
# PREDICT3	THIS CONTROLS THE FINAL SUB-ORBITAL PHASE. ROLL COMMANDS CEASE
#		WHEN  V  IS LESS THAN  VQUIT .  AN EXIT IS MADE TO
#
# P67.1		THE LAST COMPUTED ROLL ANGLE IS MAINTAINED.  RATE DAMPING IS DONE IN PITCH AND YAW.  PRESENT LATITUDE
#		AND LONGITUDE ARE COMPUTED FOR DISPLAY.
#		ENTRY IS TERMINATED WHEN DISKY RESPONSE IS MADE TO TO THIS FINAL FLASHING DISPLAY.

# PROCESS AVERAGE G OUTPUT...SCALE IT AND GET INPUT DATA

# * START  TARGETING ...

		EBANK=	RTINIT
		
					# TARGETNG IS CALLED BY P61, FROM GROUP 4.
					# TARGETNG IS CALLED BY ENTRY, FROM GROUP 5.
			
					# ALL MM COME HERE.		
TARGETNG	BOFF	VLOAD		# ENTER WITH PROPER EB FROM CM/POSE(TEST)
			RELVELSW	# RELVELSW = 96D BIT9
			GETVEL		# WANT INERTIAL VEL.  GO GET IT.
			-VREL		# NEW V IS RELATIVE, CONTINUE
			
		VCOMP	GOTO		# (VREL) = (V) + KWE UNITR*UNITW
			GETUNITV -1	# - VREL WAS LEFT BY CM/POSE
			
GETVEL		VLOAD	VXSC		# INERTIAL V WANTED
			VN		# KVSCALE = (12800 / .3048) / 2VS
			KVSCALE		# KVSCALE = .81491944
		STORE	VEL		# V/2 VS
		
GETUNITV	UNIT	STQ
			60GENRET
		STODL	UNITV
			34D
		STORE	VSQUARE		# VSQ/4
		
		DSU			# LEQ = VSQUARE - 1
			FOURTH		# 4 G-S FULL SCALE
		STODL	LEQ		# LEQ/4
		
			36D
		STOVL	V		# V/2 VS = VEL/2 VS
		
			VEL
		DOT	SL1		# RDOT= V.UNITR
			UNITR
		STOVL	RDOT		# RDOT /2 VS
		
			DELV		# PIPA COUNTS IN PLATFORM COORDS.
		ABVAL	DMP
			KASCALE
		SL1	BZE
			SETMIND
DSTORE		STOVL	D		# ACCELERATION USED TO APPROX DRAG
			VEL
		VXV	UNIT		# UNI = UNIT(V*R)
			UNITR
		STORE	UNI		# .5 UNI		REF COORDS.
		
		BOFF	DLOAD
			RELVELSW
			GETETA
			3ZEROS
UPDATERT	DSU	DAD		# PIPTIME-TIME/RTO =ELAPSED TIME SINCE
					# RTINIT WAS ESTABLISHED.
			TIME/RTO
			PIPTIME
		STCALL	DTEAROT		# GET PREDICTED TARGET VECTOR RT
		
			EARROT2
		DOT	SETPD		# SINCE (RT) UNIT VECT, THIS IS 1/4 MAX
			UNI		# LATANG = RT.UNI
			0
		STOVL	LATANG		# LATANG = MAC LATANG / 4
		
			RT
		CLEAR
			GONEBY		# SHOW HAVE NOT GONE PAST TARGET.
		VXV	DOT		# IF RT*UNITR.UNI NEG, GONEBY=1
			UNITR		# GONEPAST IS CONDITIONAL SW SET IN
			UNI		# FINAL PHASE.
		BPL	SET
			+2
			GONEBY		# SHOW HAVE GONE PAST TARGET.
			
		VLOAD
			RT
GETANGLE	DOT	DSU		# THETA = ARCCOS(RT.UNITR)
			UNITR
			NEAR1/4		# TO IMPROVE ACCURACY, CALC RANGE BY
		BPL	DAD		# TINYTHET IF HIGH ORDER PART OF
			TINYTHET	# ARCCOS ARGUMENT IS ZERO
			NEAR1/4
		SL1	ACOS
THETDONE	STORE	THETAH		# THETAH/360
					# HI WORD, LO BIT =1.32 NM=360 60/16384
					
		BON	DCOMP
			GONEBY		# =1 IF HAVE GONE PAST TARGET.
					# (SIGN MAY BECOME ERRATIC VERY NEAR
					# TARGET DUE TO LOSS OF PRECISION.)
			+1
		STODL	RTGON67		# RANGE ERROR:  NEG IF WILL FALL SHORT.
		
			D
		DSU	BMN
			.05G
			NO.05G
		SET	VLOAD
			.05GSW
			DELVREF
		PUSH	DOT
			UXA/2
		SL1	DSQ
		PDVL	VSQ		# EXCHANGE WITH PDL.
		DSU	DDV
			0
		BOV	SQRT
			NOLDCALC	# OVFL LAST CLEARED IN EARROT2 ABOVE.
		STORE	L/DCALC
		
NOLDCALC	GOTO
			60GENRET
			
NO.05G		CLEAR	GOTO		# THIS WAY FOR DAP. (MAY INTERRUPT)
			.05GSW		# .05GSW = 102D B3
			NOLDCALC	# KEEP SINGLE EXIT FOR TARGETNG

# SUBROUTINES CALLED BY SCALEPOP (TARGETING):

		BANK	26
		SETLOC	REENTRY1
		BANK
		
		COUNT*	$$/ENTRY
		
GETETA		DLOAD	DDV		# D = D +D(-RDOT/HS -2D/V)  DT/2
					# DT/2 = 2/2 =1
			RDOT
			-HSCALED
		PDDL	DMP
			D
			-KSCALE
		DDV	DAD
			V
					# -RDOT/HS FROM PDL.
		DMP	DAD
			D
			D
		STORE	D
		
		BON	DLOAD		# EGSW INDICATES FINAL PHASE.
			EGSW
			SUBETA
			THETAH
		DMP	GOTO
			KTETA		# = 1000X2PI/(2)E14 163.84
			UPDATERT
			
SUBETA		DLOAD	DSU		# SWITCH FROM INERTIAL TO RELATIVE VEL.
			V
			VMIN
		BPL	SET
			SUBETA2
			RELVELSW
			
SUBETA2		DLOAD	DMP

			THETAH
			KT1		# KT1 = KT
		DDV	GOTO
			V		# KT = RE(2 PI)/2 VS 16384 163.84/ 2 VSAT
			UPDATERT
			
SETMIND		DLOAD	GOTO
			1BITDP
			DSTORE
			
TINYTHET	DSU	ABS		# ENTER WITH X-.249
			1BITDP +1	# GET 1/4 - MPAC
		SL	SQRT		# SCALE UP BEFORE SQRT
			13D		# HAS FACTOR FOR UP SCALING
		DMP	GOTO
			KACOS
			THETDONE
			
# * START	INITIAL ROLL ...

		BANK	25
		SETLOC	REENTRY
		BANK
		
		COUNT*	$$/ENTRY
		
					# MM = 63, 64 ..
INITROLL	BON	BOFF		# IF D- .05G NEG, GO TO LIMITL/D
			INRLSW
			INITRL1
			.05GSW
			LIMITL/D
			
					# MM = 64, NOW
					#	      3
					# KA = KA1 LEQ  + KA2
		DLOAD	DSQ
			LEQ
		DMP	DDV
			LEQ
			1/KA1		# = 25 /(64  1.8)
		DAD	RTB
			KA2		# = .2
			P64		# ROLLC		VI		RDOT
					# XXX.XX DEG	XXXXX. FPS	XXXXX. FPS
		STORE	KAT
		
		DSU	BMN
			KALIM
			+4
		DLOAD	
			KALIM
		STORE	KAT
		DLOAD	DSU		# IF V-VFINAL1 NEG, GO TO FINAL PHASE.
			V
			VFINAL1
		CLEAR	BPL		# (CAN'T CLEAR INRLSW AFTER HERE: RESTARTS)
			GONEPAST	# GONEPAST WAS INITIALLY SET=1 TO FORCE
					# ROLLC TO REMAIN AS DEFINED BY HEADSUP
					# UNTIL START OF P64.  (UNTIL D > .05G)
			D0EQ
		SSP	GOTO
			GOTOADDR
			KEP2		# AND IDLE UNTIL D > 0.2 G.  (NO P66 HERE)
			INROLOUT	# GO TO LIMITL/D AFTER SETTING INRLSW.
			
D0EQ		DLOAD	DMP		# D0 = KA3 LEQ + KA4
			LEQ
			KA3
		DAD
			KA4
		STORE	D0		# D0/805
		BDDV	BOV
			C001		# (-4/25 G) B-8
			+1		# CLEAR OVFIND, IF ON.
		STODL	C/D0		# (-4/D0) B-8
			LAD		# IF V-VFINAL +K(RDOT/V)CUBED POS,L/D=-LAD
		STODL	L/D
			RDOT
		DDV	PUSH
			V
		DSQ	DMP
		DDV	DSU
			1/K44
			VFINAL
					#		    3
					# V-VFINAL +(RDOT/V)  / K44	OVFL $
					
		DAD	BOV
			V
			INROLOUT	# GO TO LIMITL/D AFTER SETTING INRLSW.
		BMN	DLOAD
			INROLOUT	# GO TO LIMITL/D AFTER SETTING INRLSW.
			LAD
		DCOMP
		STORE	L/D
		
					# SET INRLSW AT END FOR RESTART PROTECTION
INROLOUT	BOFSET			# END OF PRE .05G PATH OF INITROLL.
			INRLSW		# SWITCH IS ZERO INITIALLY.
			LIMITL/D	# (GO TO)
			
KATEST		DLOAD	DSU		# IF KAT - D POS, GO TO CONSTD
			KAT
			D		# IF POS, OUT WITH COMMAND VIA LIMITL/D
		BPL	GOTO
			LIMITL/D
			CONSTD
			
INITRL1		DLOAD	DAD		# IF RDOT + VRCONT POS, GO TO HUNTEST
			RDOT
			VRCONT
		BMN	CALL		# IF POSITIVE, FALL INTO HUNTEST.
			KATEST
			
			FOREHUNT	# INITIALIZE HUNTEST.
			
# * START	HUNT TEST ..
					# MM = 64
		SSP			# INITIALIZE HUNTEST ON FIRST PASS
			GOTOADDR
			HUNTEST		# MUST GO AFTER FOREHUNT FOR RESTARTS.
			
HUNTEST		DLOAD
			D
		STODL	A1		# A1/805 = A1/25G
		
			LAD
		STODL	TEM1B
			RDOT
		BMN	DLOAD		# IF RDOT NEG,TEM1B=LAD, OTHERWISE = LEWD
			A0CALC
			LEWD
		STODL	TEM1B
		
			RDOT
A0CALC		DDV	DAD		# V1 = V + RDOT/TEM1B
			TEM1B
			V
		STODL	V1		# V1/2 VS
		
			RDOT
		DSQ	DDV		# A0=(V1/V)SQ(D+RDOT SQ/(TEM1B 2 C1 HS)
			TEM1B
		DDV	DAD
			2C1HS
			D
		DMP	DMP
			V1
			V1
		DDV
			VSQUARE
		STODL	A0		# A0/805 = A0/25G
		
			RDOT
		BPL	DLOAD
			V1LEAD
			A0
		STORE	A1		# A1/25G
		
V1LEAD		DLOAD	BPL		# IF L/D NEG, V1=V1 - 1000
			L/D
			HUNTEST1
			
		DLOAD	DSU
			V1
			VQUIT
		STORE	V1
		
HUNTEST1	DLOAD	DMP		# ALP = 2 C1 HS A0/LEWD V1 V1
			A0
			2C1HS
		DDV	SETPD
			V1
			0
		DDV	DDV
			V1
			LEWD
		STORE	ALP
		
		BDSU	BDDV		# FACT1 = V1 / (1 - ALP)
			BARELY1
			V1
		STODL	FACT1		# FACT1 / 2VS
		
			ALP
		DSU	DMP		# FACT2 = ALP(ALP - 1) / A0
			BARELY1
			ALP
		DDV
			A0
		STORE	FACT2		# FACT2 (25G)
		
		DMP	DAD
			Q7		# Q7 / 805 = Q7 / 25G
			ALP		# VL=FACT1 (1-SQRT(Q7 FACT2 +ALP) )
		SQRT	BDSU
			BARELY1
		DMP
			FACT1
		STORE	VL		# VL / 2 VS
		
		BDSU	DMP		# GAMMAL1 = LEWD (V1-VL)/VL
			V1
			LEWD
		DDV
			VL
		STODL	GAMMAL1		# GAMMAL1 USED IN UPCONTROL
		
					# GAMMAL1 = PDL 22D.
			VL
		DSU	BMN		# IF VL-VLMIN NEG, GO TO PREFINAL
			VLMIN
			PREFINAL
			
		DLOAD	DSQ
			VL
		STODL	VBARS		# VBARS / 4 VS VS
		
			HALVE		# IF VSAT-VL NEG, GO TO CONSTD
		DSU	BMN
			VL
			BECONSTD	# SET MODE=HUNTEST, CONTINUE IN CONSTD
		STODL	DVL		# DVL / 2VS
		
			HALVE
		STORE	VS1		# VS1 = VSAT
		
		DSU	BMN		# IF V1 GREATER THAN VSAT, GO ON
			V1
			GETDHOOK
		BDSU
			DVL
		STODL	DVL		# DVL = DVL - (VSAT-V1) = V1 - VL
			V1
		STORE	VS1		# VS1 = V1, IN THIS CASE
		
GETDHOOK	DLOAD	CALL		# DHOOK=((1-VS1/FACT1) SQ -ALP)/FACT2
			VS1		# VS1 / 2 VS
			DHOOKYQ7	# GO CALC DHOOK
		STORE	DHOOK		# DHOOK / 25G
		
		SR	DDV
			6		# CHOOK
			Q7
		DSU	
			CHOOK		# = .25/16 = (-6)
		STORE	AHOOKDV
		
		DAD	DMP		# GAMMAL= GAMMAL1-CH1 DVL SQ(1+AHOOK DVL)
			1/16TH
			CH1
		DMP	DMP
			DVL
			DVL
		DDV	DDV
			DHOOK
			VBARS
		BDSU	BMN
			GAMMAL1
			NEGAMA
HUNTEST3	STORE	GAMMAL

		DSU			# GAMMAL1=GAMMAL1 +Q19 (GAMMAL-GAMMAL1)
			GAMMAL1
		DMP	DAD
			Q19
			GAMMAL1
		STODL	GAMMAL1
			GAMMAL

# *START	RANGE PREDICTION ...
					# C(MPAC) = GAMMAL
RANGER		DSQ	SR2		# COSG = 1-GAMMAL SQ/2, TRUNCATED SERIES
		BDSU
			HALVE
		STODL	COSG/2
			VBARS		# E=SQRT(1+VBARS........
			
		DSU	DMP
			HALVE
			VBARS
		DMP	DMP
			COSG/2
			COSG/2
		SL2	DAD
			C1/16		# C1/16 = 1/16
		SQRT	PDDL		# E/4 INTO PDL
		
			VBARS
		DMP	DMP		# ASKEP/2 = ARCSIN(VBARS COSG SING/E)
			COSG/2
			GAMMAL
		DDV	ASIN
		SL1	PUSH		# ASKEP TO PDL 0.
		STODL	ASKEP		# BALLISTIC RANGE	ASKEP/2PI
		
					# FOR TM, STORE RANGE COMPONENTS OVERLAPPING (SP)
			VL
		DMP	DAD		# ASP1 = Q2 + Q3 VL
			Q3
			Q2
		STORE	ASP1		# FINAL PHASE RANGE	ASP1/2 PI
		
		PDDL	DSQ		# ASP1 TO PDL 2.
			V1
					#		    2
					# ASPUP= -C12 LOG(V1 Q7/VBARS A0)/GAMMAL1
		DMP	DDV
			Q7
			VBARS
		DDV	CALL
			A0
			LOG		# RETURN WITH -LOG IN MPAC
			
		DMP	DDV
			C12
			GAMMAL1
		STORE	ASPUP		# UP PHASE RANGE	ASPUP / 2 PI
		PDDL	DMP		# ASPUP TO PDL 4.
			KC3		# KC3 = -4 VS VS / 2 PI 805 RE
					# ASPDWN = KC3 RDOT V / A0
			RDOT
		DMP	DDV
			V
			A0
		DDV	PUSH		# ASPDWN TO PDL 6.
			LAD
		STODL	ASPDWN		# RANGE TO PULL OUT	ASPDWN /2 PI
		
			Q6
		DSU	DMP		# ASP3 = Q5(Q6-GAMMAL)
			GAMMAL
			Q5
		STOVL	ASP3		# GAMMA CORRECTION	ASP3/2PI
		
			ASKEP		# GET HI-WD AND
		STODL	ASPS(TM)	# SAVE HI-WORD OF ASP'S FOR TM.
		
			ASP3
		DAD	DAD
					# ASPDWN FROM PDL 6.
					# ASPUP FROM PDL 4.
		DAD	DAD
					# ASP1 FROM PDL 2.
					# ASKEP FROM PDL 0.
		DSU	BOVB		# CLEAR OVFIND.
			THETAH
			TCDANZIG
		STORE	DIFF		# DIFF = (ASP-THETAH) / 2 PI
					# ASP=ASKEP+ASP1+ASPUP+ASP3+ASPDWN = TOTAL RANGE
					
		ABS	DSU		# IF ABS(THETAH-ASP) -25NM NEG, GO TO UPSY
			25NM
		BMN	BON
			GOTOUPSY
			HIND
			GETLEWD
			
		DLOAD	BPL
			DIFF
			DCONSTD		# EVENTUALLY SETS MODE = HUNTEST.
GETLEWD		DLOAD	DMP
					# DLEWD = DLEWD (DIFF/(DIFFOLD-DIFF))
			DLEWD
			DIFF
		PDDL	DSU
			DIFFOLD
			DIFF
		BDDV
LWDSTORE	STADR
		STORE	DLEWD
		DAD	BMN		# IF LEWD+DLEWD NEG, DLEWD=-LEWD/2
			LEWD
			LEWDPTR
		BOV
			LEWDOVFL
		STORE	LEWD
		
SIDETRAK	EXIT

		CA	EBENTRY
		TS	EBANK
		
		CA	PRIO16		# DROP GRP 5 RESTART PRIO TO 1 LESS THAN
		TS	PHSPRDT5	# GRP 4.
		
		TC	PHASCHNG
		OCT	00474		# RESTART GRP 4 AT PRE-HUNT.
					# FORCE RESTART TO PICK UP IN GRP 4:
					# USE PRIO 17 FOR GRP 4 (< SERVICER PRIO)
		CA	PRIO16		# CONTINUE GRP 5 AT LOWER PRIO THAN EITHER
					# GRP 4 OR SERVICER.
		TC	PRIOCHNG
		
		CAF	ADENDEXT	# SIDETRACK NEXT PASS UNTIL THIS ONE DONE.
		TS	GOTOADDR	# ONLY AFTER RESTART IS LEFT AFTER DETOUR.
		
		TC	INTPRET
		
		DLOAD	SET
			DIFF
			HIND
		STODL	DIFFOLD		# DIFFOLD / 2 PI
		
			Q7F
		STCALL	Q7		# Q7 / 805 FPSS
			HUNTEST		# (GO TO)
			
LEWDOVFL	DLOAD
			NEARONE
		STCALL	LEWD
			DCONSTD		# (GO TO)  ALSO WILL SET MODE = HUNTEST
			
LEWDPTR		DLOAD	SR1
			LEWD
		DCOMP	GOTO
			LWDSTORE

# NEGAMA IS PART OF HUNTEST ...

NEGAMA		DMP	DMP		# ENTER WITH GAMMAL IN MPAC

			VL
			1/3RD
		PDDL	DMP		# PUSH GAMMAL VL/3
			LEWD
			1/3RD
		PDDL	DAD		# PUSH LEWD/3
			AHOOKDV
			1/24TH
		DMP	DMP		# DEL VL = (GAMMAL VL/3)/(LEWD/3-DVL
			DVL		# (2/3 + AHOOKDV)(CH1 GS/DHOOK VL))
			CH1
		DDV	DDV
			DHOOK
			VL
		BDSU	BDDV
					# LEWD/3
					# GAMMAL VL /3
		DAD
			VL
		STCALL	VL		# VL/2 VS
		
			DHOOKYQ7	# GO CALC Q7
					# Q7=((1-VL/FACT1)SQ - ALP)/FACT2
		STODL	Q7		# Q7 / 25G
		
			VL
		DSQ
		STODL	VBARS		# VBARS / 4 VS VS
		
			3ZEROS
		GOTO			# SET GAMMAL = 0
			HUNTEST3
			
DHOOKYQ7	SR1	DDV		# SUBROUTINE TO CALC DHOOK OR Q7)
			FACT1
		BDSU	SL1
			HALVE
		DSQ	DSU
			ALP
		DDV	RVQ
			FACT2
			
					# COME TO PRE-HUNT WHEN RESTART OCCURS AFTER
					# HUNTEST IS SIDE-TRACKED AT SIDETRAK.
					# PICK UP IN GROUP 4.
					
PRE-HUNT	TC	INTPRET
		CLEAR	CALL
			HIND		# HIND	99D BIT 6 FLAG 6
			FOREHUNT	# RE-INITIALIZE HUNTEST AFTER RE-START.
		GOTO
			HUNTEST
			
FOREHUNT	DLOAD			# INITIALIZE HUNTEST.
			3ZEROS
		STODL	DIFFOLD
			DLEWD0
		STODL	DLEWD
			LEWD1
		STORE	LEWD
		RVQ
		
ADENDEXT	CADR	ENDEXIT

# * START	UP CONTROL ...
					# MM = 65
GOTOUPSY	RTB			# END OF HUNTEST
			P65		# HUNTEST USE OF GRP4 IS DISABLED BY P65
					# USE FOR DISPLAY.
					# SET MODE = UPCONTRL.
					# RETURN FROM P65 DIRECTLY TO UPCONTRL
					# VIA THE GOTOADDR AT REFAZE10.
					
UPCONTRL	DLOAD	DSU		# IF D-140 POS, NOSWITCH =1
			D		# (SUPPRESS LATERAL SWITCH)
			C21
		BMN	SET
			+2
			NOSWITCH
			
		DLOAD	DSU		# IF V-V1 POS, GO TO DOWN CONTROL.
			V
			V1
		BPL	DLOAD
			DOWNCNTL
			D
		DSU	BMN		# IF D- Q7 NEG, GO TO KEP
			Q7
			KEP
		DLOAD	BPL		# IF RDOT NEG, DO VLTEST
			RDOT
			CONT1
			
VLTEST		DLOAD	DSU		# IF V-VL-C18 NEG,EGSW=1,MODE=PREDICT3
			V
			VL
		DSU	BMN
			C18
			PREFINAL
			
CONT1		DLOAD			# IF D-A0 POS, L/D = LAD, GO TO LIMITL/D
			D
		DSU	BMN
			A0
			CONT3
		DLOAD	GOTO
			LAD
			STOREL/D
			
CONT3		DLOAD	DMP		# VREF=FACT1(1-SQRT(FACT2 D + ALP))
			D
			FACT2
		DAD	SQRT
			ALP
		BDSU	DMP
			BARELY1
			FACT1
		STORE	VREF		# VREF / 2VS
		
		BDSU	DMP		# RDOTREF = LEWD(V1-VREF)
			V1
			LEWD
		STODL	RDOTREF		# RDOTREF / 2VS
		
			VS1
		DSU	BMN		# IF VSAT-VREF NEG, GO TO CONTINU2
			VREF
			CONTINU2
			
		PUSH	PUSH		# VS1-VREF  TO PDL TWICE
		DMP	DDV		# RDHOOK=CH1(1+DV AHOOKDV/DVL) DV DV
			AHOOKDV		#	/DHOOK VREF
			DVL		# WHERE  DV = (VS1-VREF)
		DAD	DMP
			1/16TH
			CH1
		DMP	DMP
					# VS1-VREF  FROM PDL TWICE.
		DDV
			DHOOK
		DDV	BDSU
			VREF
			RDOTREF		# C(RDOTREF)= LEWD (V1-VREF)
		STORE	RDOTREF		# RDOTREF = RDOTREF - RDHOOK
		
CONTINU2	DLOAD	DSU
			D
			Q7MIN
		BOVB	BMN
			TCDANZIG	# CLEAR OVFL IND, IF ON.
			UPCNTRL3
		DLOAD	DSU
			A1
			Q7
		PDDL	DSU
			D
			Q7
		DDV	STADR
		STORE	FACTOR		# FACTOR / 25G
		
# SKIPPER
					# DELTA L/D=-((RDOT-RDOTREF)F1 KB1+V-VREF)F1 KB2
					#	WHERE F1 = FACTOR
					
UPCNTRL3	DLOAD
			RDOT
		DSU	DMP		# L/D = LEWD
			RDOTREF		# -((RDOT-RDOTREF)F1/KB1+V-VREF)F1/KB2
			FACTOR
		DDV	DAD
			1/KB1
			V
		DSU	DMP
			VREF
			FACTOR
		DDV	PUSH
		
			-1/KB2		# DELTA L/D INTO PDL
		BOV	ABS		# NONLINEAR CIRCUIT FOR REDUCING HIGH GAIN
			GOMAXL/D
		DSU	BMN
			PT1/16
			NEXT1
		DMP	DAD
			POINT1
			PT1/16
		SIGN	PUSH		# ATTACH SIGN OF PUSH TO MPAC THEN PUSH
		
NEXT1		DLOAD	SL4
					# DELTA L/D FROM PDL.
					
		DAD
			LEWD
NEGTESTS	BOV	PUSH		# L/D TO PDL FOR USE IN NEGTESTS.
			GOMAXL/D
		STODL	L/D
					# IF D-C20 POS, LATSW =0
					# AND IF L/D NEG, L/D = 0.
			D
		DSU	BMN
			C20
			LIMITL/D
		CLEAR	DLOAD
			LATSW		# =21D.  ROLL OVER TOP, REGARDLESS.
					# L/D FROM PDL.
		BPL	DLOAD
			LIMITL/D
			3ZEROS
		STCALL	L/D
			LIMITL/D	# (GO TO)

DCONSTD		DLOAD			# TWO RANGER ENTRIES TO CONSTD HERE
			DIFF
					# SAVE OLD VALUE OF DIFF FOR NEXT PASS.
		STODL	DIFFOLD		# DIFFOLD / 2 PI
		
			Q7F
		STORE	Q7
		
BECONSTD	SSP	RTB		# A HUNTEST ENTRY INTO CONSTD.
			GOTOADDR	# RESET MODE TO HUNTEST
			HUNTEST
			KILLGRP4	# DEACTIVATE GRP4 FROM HUNTEST.
			
CONSTD		BOVB	
			TCDANZIG	# CLEAR OVF IND IF ON.
			
		DLOAD	DMP
			LEQ
			C/D0		# C/D0 = -4/D0 B-8
		PDDL	DMP		# LEQ C/D0 INTO PDL
			2HS		# 2HS / 4 VS VS
			D0
		DDV	DAD		# RDOTREF = -2 HS D0/V
			V
			RDOT
		DMP	DAD
			K2D		# C/D0 LEQ + K2D(RDOT-RDOTREF) INTO PD
		PDDL
			D0		# D0 /805
			
CONSTD1		BDSU			# ENTER WITH DREF IN MPAC
			D
		DMP	DAD
			K1D		# K2D TERM FROM PUSH
		SL	GOTO
			8D
			NEGTESTS	# (GO TO)
			
DOWNCNTL	BOVB			# INITIAL PART OF UPCONTROL.
			TCDANZIG	# CLEAR OVFIND, IF ON.
			
		DLOAD	SR
			LAD
			8D
		PDDL	DSU		# RDTR = LAD(V1-V)
			V
			V1
		DMP	DAD
			LAD
			RDOT
		DMP	DAD
			K2D
					# PUSH UP LAD.
		PDDL	DSU		# LAD + K2D(RDOT-RDTR) INTO PD
			V1
			V
		DSQ	DMP
			LAD
		DDV	PDDL		# (V1-V)SQ LAD/(2 C1 HS) INTO PD
			2C1HS
			V1
		DSQ	DDV
			VSQUARE
		BDDV	DSU		# DREF = (V/V1)SQ A0 - PD
			A0
					# PUSH UP HERE
		GOTO			# C(MPAC) = DREF
			CONSTD1
			
					#              2           2
					# DREF = (V/V1)  A0 -(V-V1)  LAD/2 C1 HS
# * START	BALLISTIC PHASE ...
					# MM = 66	UPCONTRL ENTRY INTO KEP2.
KEP		RTB	SSP
			P66		# DISPLAY TRIM GIMBAL ANGLE VALUES.
			GOTOADDR	# SET GOTOADDR TO KEPLER PHASE.
			KEP2
			
					# KEP2 CAN ALSO BE STARTED UP DIRECTLY FROM INITROLL
					# IN P64.  PROGRAM WILL IDLE IN P64 UNTIL D EXCEEDS
					# .2 G BEFORE GOING ON TO P67.
					
KEP2		DLOAD	DSU		# IF Q7F+KDMIN -D NEG, GO TO FINAL PHASE.
			Q7FKDMIN	# (Q7F + KDMIN)/805
			D
		BMN	TLOAD
			PREFINAL
					# SET ROLLHOLD = ROLLC, IN CASE CMDAPMOD
			ROLLC		# = +1 EVER ENTERED.
		BON	TLOAD		# IF D > .05G, KEEP PRESENT ROLL COMMAND.
			.05GSW		# IF D < .05G, SET ROLL COMMAND = 0.
			+2
			3ZEROS		# SET ROLLC & ROLLHOLD =0.
 +2		STCALL	ROLLC		# (SP ROLLHOLD FOLLOWS DP ROLLC)
			P62.3		# CALC DESIRED GIMBAL ANGLES AT PRESENT
					# RN, VN TO YIELD TRIM ATTITUDE.
					# AVAILABLE IN CPHI'S FOR N22.
# START FINAL PHASE ..
					# MM = 67
PREFINAL	SSP	RTB
			GOTOADDR	# RESTART PROTECT: RESET GOTOADDR IF CAME
			PREFINAL	# FROM HUNTEST.
			P67		# DISABLES GRP4.  FINE IF FROM HUNTEST. BUT 
					# MAY ALSO REMOVE RESTART PROTECTION OF
					# N69 (P65).
					# ROLLC		XRNGERR		DNRNGERR
					# XXX.XX DEG	XXXX.X NM	XXXX.X NM
					
		SET	SSP
			EGSW
			GOTOADDR
			PREDICT3
			
PREDICT3	DLOAD	DSU		# IF V-VQUIT NEG, STOP STEERING
			V
			VQUIT
		BMN	EXIT
			STEEROFF
			
		CA	EBENTRY		# PRECAUTIONARY.
		TS	EBANK
		
		CA	TWELVE
BACK		TS	JJ

		CS	V
		INDEX	JJ
		AD	VREFER		# VREF - V, HIGHEST VREF AT END OF TABLE.
		CCS	A		# IF VREF-V POS LOOP BACK
		CCS	JJ		# DECREMENT JJ, JJ CANNOT BE ZERO
		TCF	BACK
		AD	ONE
		TS	TEM1B		# V-VREF IN TEM1B (MUST BE POSITIVE NUM)
		
		INDEX	JJ
		CS	VREFER
		INDEX	JJ
		AD	VREFER +1	# V(K+1) - V(K)			(POS NUM)
		XCH	TEM1B
		ZL	
		EXTEND
		DV	TEM1B
		TS	GRAD		# GRAD = (V-VREF)/(VK+1 - VK)	(POS NUM
		
		CAF	FIVE

BACK2		TS	MM
		CAF	THIRTEEN
		ADS	JJ
		INDEX	A
		CS	VREFER
		INDEX	JJ
		AD	VREFER	 +1	# X(K+1) - X(K)
		EXTEND
		MP	GRAD
		INDEX	JJ
		AD	VREFER
		INDEX	MM
		TS	FX		# FX = AK + GRAD (AK+1 - AK)
		CCS	MM
		TCF	BACK2
		XCH	FX 	+1	# ZERO FX +1 AND GET DREFR
		AD	D
		EXTEND
		MP	FX	+5	# F1
		DXCH	MPAC		# MPAC = F1(D-DREF)
		
		EXTEND
		DCS	RDOT		# FORM RDOTREF - RDOT
		DDOUBL
		DDOUBL
		DDOUBL			# SCALE UP BY 8 FOR THIS PHASE.
		AD	FX 	+3	# RDOTREF
		EXTEND
		MP	FX 	+4	# F2
		AD	FX	+2	# RTOGO
		DAS	MPAC		# ADD F2(DADV1-DADVR)
		CA	MPAC
		TS	PREDANG
					# L/D = LOD + (THETA- PREDANG)/ Y
		TC	INTPRET
		
		SR3	DSU
			THETAH
		BON	BOFF
			GONEPAST
			GONEGLAD
			GONEBY
			HAVDNRNG
		DLOAD	SET		# SET GONEPAST IF GONEBY SET & LATCH IN-
			MAXRNG		# DISPLAY = 9999.9 IF GONEBY	   PLACE
			GONEPAST
		STCALL	DNRNGERR
			GONEGLAD
			
HAVDNRNG	STORE	DNRNGERR	# = (PREDANG - THETA) /360
		DCOMP			# FALL SHORT IF NEG, OVERSHOOT IF POS
		BOVB	DDV
			TCDANZIG	# CLEAR OVFIND IF ON.
			FX		# FX= DRANGE/D L/D = Y
		SL	BOV
			5
			GOMAXL/D
		DAD	BOV
			LOD
			GOMAXL/D
		STCALL	L/D
			GLIMITER	# (GO TO)
			
# GONEGLAD AND GOPOSMAX ENTRY POINTS FOR GLIMITER ...

GONEGLAD	DLOAD			# SET L/D = -LAD
			GONEGLAD	# (ANY NEGATIVE NUMBER WILL DO)
			
GOMAXL/D	RTB	DMP		# L/D = LAD SIGN(MPAC)
			SIGNMPAC
			LAD
		STORE	L/D		# AND FALL INTO GLIMITER SECTION
		
GLIMITER	DLOAD	DSU		# IF GMAX/2-D POS, GO TO LIMITL/D
			GMAX/2
			D
		BPL	DAD		# IF GMAX  -D NEG, GO TO GOPOSLAD
			LIMITL/D
			GMAX/2
		BMN	DMP
			GOPOSLAD
			2HS
		PDDL	DMP		# 2HS(GMAX-D) INTO PD
			LEQ
			1/GMAX
		DAD	DMP
			LAD
		PDDL	DDV		# 2HS(GMAX-D) (LEQ/GMAX+LAD) INTO PD
			2HSGMXSQ
			VSQUARE
		DAD	SQRT		# XLIM = SQRT(PD+(2HSGMAX/V)SQ)
		DAD	BPL		# IF RDOT+XLIM POS, GO TO LIMITL/D
			RDOT
			LIMITL/D
			
GOPOSLAD	DLOAD
			LAD
STOREL/D	STORE	L/D

LIMITL/D	DLOAD
			L/D
		STODL	L/D1
			VSQUARE
			
		BON			# NO LATERAL CONTROL IF PAST TARGET
			GONEPAST
			L355
		DMP	DAD		# Y= KLAT VSQUARE + LATBIAS
			KLAT
			LATBIAS		# Y INTO PD
L350		PDDL	ABS		# IF ABS(L/D)-L/DCMINR NEG, GO TO L353
			L/D
		DSU	BMN
			L/DCMINR
			L353
		DLOAD	SIGN		# IF K2ROLL LATANG NEG, GO TO L357
			LATANG
			K2ROLL
		BMN	DLOAD
			L357
		SR1	PUSH		# Y = Y/2
L353		DLOAD	SIGN		# IF LATANG SIGN(K2ROLL)-Y POS, SWITCH
			LATANG
			K2ROLL
		DSU
		BMN	DLOAD
			L355
			K2ROLL
		BONCLR	DCOMP		# IF NOSWITCH =1, K2ROLL= K2ROLL
			NOSWITCH
			L355
		STORE	K2ROLL		# K2ROLL = -K2ROLL
		
L355		DLOAD	DDV		# ROLLC = ACOS( (L/D1) / LAD)
			L/D1
			LAD		# MPAC SET TO +-1 IF OVERFLOW***
		SR1	ACOS
		SIGN	CLEAR
			K2ROLL
			NOSWITCH
		STORE	ROLLC
		
ENDEXIT		EXIT

OVERNOUT	CA	BIT13		# ENTRYDSP =92D B13
		MASK	CM/FLAGS
		EXTEND
		BZF	NODISKY		# OMIT DISPLAY.
		CA	ENTRYVN		# ALL ENTRY DISPLAYS ARE DONE HERE.
		TC	BANKCALL
		CADR	REGODSPR	# NO ABORT IF DISKY IN USE
		
NODISKY		INHINT
		CCS	NEWJOB		# PROTECT READACCS GRP 5, IF SIDETRACKED.
		TC	CHANG1
SERVNOUT	TC	POSTJUMP	# ( COME HERE FROM P67.3 )
		CADR	SERVEXIT	# AND END AVERAGEG JOB VIA  ENDOFJOB.

# DISPLAY WHEN V IS LESS THAN VQUIT.

STEEROFF	EXIT
		CA	EBENTRY		# PRECAUTIONARY.
		TS	EBANK
		
		CA	PRIO16		# 2 LESS THAN NTRYPRIO.
		TC	NOVAC
		EBANK=	AOG		# ANY EB HERE
		2CADR	P67.1		# START UP REMAINDER OF P67
		
					# RTOGO		LAT		LONG
					# XXXX.X NM	XXX.XX DEG	XXX.XX DEG
					
		TC	2PHSCHNG	# INHINT/RELINT DONE.
		OCT	00414		# 4.41 RESTART FOR P67.1 DISPLAY JOB.
		OCT	10035		# SERVICER 5.3 RESTART.
		
		CA	P67.2CAD	# HEREAFTER, DO LAT, LONG.
		TS	GOTOADDR
		
		TC	INTPRET
		GOTO
P67.2CAD		P67.2		# CONTINUE FOR LAT, LONG THIS TIME.

L357		DLOAD	SIGN		# L/D = L/DCMINR SIGN(L/D)
			L/DCMINR
			L/D
		STCALL	L/D1
			L355		# (GO TO)

# TABLE USED FOR SUB-ORBITAL REFERENCE TRAJECTORY CONTROL.

VREFER		DEC	.019288		# REFERENCE VELOCITY SCALED V/51532.3946
		DEC	.040809		# 13 POINTS ARE STORED AS THE INDEPENDENT
		DEC	.076107		# VARIABLE AND THEN SIX 13 POINT FUNCTIONS
		DEC	.122156		# OF V ARE STORED CONSECUTIVELY
		DEC	.165546
		DEC	.196012
		DEC	.271945
		DEC	.309533
		DEC	.356222
		DEC	.404192
		DEC	.448067
		DEC	.456023
		DEC	.67918		# HIGHVELOCITY FOR SAFETY
		
		DEC	-.010337	# DRANGE/DA	SCALED DRDA/(2700/805)
		DEC	-.016550
		DEC	-.026935
		DEC	-.042039
		DEC	-.058974
		DEC	-.070721
		DEC	-.098538
		DEC	-.107482
		DEC	-.147762
		DEC	-.193289
		DEC	-.602557
		DEC	-.99999
		DEC	-.99999
		
		DEC	-.0478599 B-3	# -DRANGE/DRDOT
		DEC	-.0683663 B-3	# SCALED ((2VS/8 2700) DR/DRDOT)
		DEC	-.1343468 B-3
		DEC	-.2759846 B-3
		DEC	-.4731437 B-3
		DEC	-.6472087 B-3
		DEC	-1.171693 B-3
		DEC	-1.466382 B-3
		DEC	-1.905171 B-3
		DEC	-2.547990 B-3
		DEC	-4.151220 B-3
		DEC	-5.813617 B-3
		DEC	-5.813617 B-3

		DEC	-.0134001  B3	# RDOTREF	SCALED (8 RDT/2VS)
		DEC	-.013947   B3
		DEC	-.013462   B3
		DEC	-.011813   B3
		DEC	-.0095631  B3
		DEC	-.00806946 B3
		DEC	-.006828   B3
		DEC	-.00806946 B3
		DEC	-.0109791  B3
		DEC	-.0151498  B3
		DEC	-.0179817  B3
		DEC	-.0159061  B3
		DEC	-.0159061  B3
		
		DEC	.00137037	#  3.7	RTOGO SCALED RTOGO/2700
		DEC	.00385185	# 10.4
		DEC	.00874074	# 23.6
		DEC	.017148
		DEC	.027926
		DEC	.037
		DEC	.063298
		DEC	.077889
		DEC	.098815
		DEC	.127519
		DEC	.186963
		DEC	.238148
		DEC	.294185185
		
		DEC	-.051099	# -AREF/805
		DEC	-.074534
		DEC	-.101242
		DEC	-.116646
		DEC	-.122360
		DEC	-.127081
		DEC	-.147453
		DEC	-.155528
		DEC	-.149565
		DEC	-.118509
		DEC	-.034907
		DEC	-.007950
		DEC	-.007950

		DEC	.004491		# DRANGE/D L/D SCALED Y/2700
		DEC	.008081
		DEC	.016030
		DEC	.035815
		DEC	.069422
		DEC	.104519
		DEC	.122
		DEC	.172407
		DEC	.252852
		DEC	.363148
		DEC	.512963
		DEC	.558519
		DEC	.558519		# END OF STORED REFERENCE
		
# REENTRY CONSTANTS.

# DEFINED BY EQUALS

DEC15		=	LOW4
#GAMMAL1	=	22D

MAXRNG		2OCT	1663106755	# DNRNGERR = 9999.9 IF GONEPAST=1

		BANK	26
		SETLOC	REENTRY1
		BANK
		
		COUNT*	$$/ENTRY
		
BARELY1		=	NEARONE		# COMMON TO BOTH DISK,DANCE.DEFND IN TFF
#1BITDP					COMMON TO BOTH DISK AND DANCE. DEFND IN VECPOINT.

1/12TH		DEC	.083333		# DP 1/12 USES HI WORD IN 1/3 BELOW
1/3RD		2DEC	.3333333333	# DP 1/3

1/16TH		=	DP2(-4)

# BELOW:  VS = VSAT = 25766.1973 FT/SEC

#	  RE = 21,202,900 FEET

LEWD1		2DEC	.15

POINT1		2DEC	.1

POINT2		2DEC	.2		# .2

DLEWD0		2DEC	-.05		# -.05

GMAX/2		2DEC	.16		# 8 GS / 2

3ZEROS		EQUALS	HI6ZEROS
NEAR1/4		2OCT	0777700000	# 1/4 LESS 1 BIT IN UPPER PART.

C18		2DEC	.0097026346	# 500/2VS

Q7FKDMIN	2DEC	.0080745342	# 6.5/805  (Q7F +KDMIN) = 6 + .5)

C1/16		=	DP2(-4)

Q3		2DEC	.167003132	# .07 2VS/21600
Q5		2DEC	.326388889	# .3 23500/21600

Q6		2DEC	.0349		# 2 DEG, APPROX 820/23500

Q7F		2DEC	.0074534161	# 6/805  (VALUE OF Q7 IN FIXED MEM.)

Q19		=	HALVE		# Q19 = .5

Q21		2DEC	.0231481481	# 500/21600

Q22		2DEC	-.053333333	# -1152/21600

VLMIN		2DEC	.34929485	# 18000/2 VS

VMIN		=	FOURTH		# (VS/2) / 2VS
C12		2DEC	.00684572901	# 32 28500/(21202900 2 PI)

1/KB1		2DEC	.29411765	# 1 / 3.4

-1/KB2		2DEC	-.0057074322 B4	# = -1/(.0034 2 VS) EXP +4

VQUIT		2DEC	.019405269	# 1000 /2VS

C20		2DEC	.26086957	# 210/805  90 DEG MAX ROLL IF ABOVE C20

C21		2DEC	.17391304	# 140/805

25NM		2DEC	.0011574074	# 25/21600	(25 NAUT MILES)

K1D		2DEC	.0314453125	# =C16 805/256 = .01 805/256

K2D		2DEC	-.402596836	# -C17 2VS/256 = -.002 2VS/256

KVSCALE		2DEC	.81491944	# 12800/(2 VS .3048)

KASCALE		2DEC	.97657358	# 5.85 16384/(4 .3048 100 805)

KTETA		2DEC*	.383495203 E2 B-14* # 1000 2PI/16384(163.84)

KT1		2DEC*	.157788327 E2 B-14* # RE(2PI)/2 VS(16384) 163.84

.05G		2DEC	.002		# .05/25

LATBIAS		2DEC	.00003		# APPRX .5 NM/ 4(21600/2 PI)

KWE		2DEC	.120056652 B-1

KACOS		2DEC	.004973592	# 1/32(2PI)

CHOOK		2DEC	1 B-6		# .25/16
1/24TH		2DEC	.0833333333 B-1

CH1		2DEC	.32 B1		# 16 CH1/25 = 16 (1) /25

KC3		2DEC	-.0247622232	# -(4 VS VS/ 2 PI 805 RE)

VRCONT		2DEC	.0135836886	# 700/2 VSAT

HALVE		EQUALS	HIDPHALF
FOURTH		EQUALS	HIDP1/4

1/GMAX		EQUALS	HALVE		# 4/GMAX = 4 / 8
2HS		2DEC	.0172786611	# 2 28500 25 32.2/(4 VS VS)

2HSGMXSQ	2DEC	.0000305717	# (2 28500 8 32.2/ 4 VS VS)SQ

C001		2DEC	-.000625	# -(4/25)/256	LEQ/D0 CONST

POINT8		2DEC	.8

2C1HS		2DEC	.0215983264	# 2 1.25 28500 805/(2 VS)SQ

PT1/16		2DEC	.1 B-4

1/K44		2DEC	.00260929464	# 2 VS/19749550

VFINAL		2DEC	.51618016	# 26600/2 VS

VFINAL1		2DEC	.523942273	# = 27000 / 2 VS

1/KA1		2DEC	.30048077	# 25/(1.3 64)

KA2		2DEC	.008		# .2/25

KA3		2DEC	.44720497	# = 90 4/805

KA4		2DEC	.049689441	# 40/805

KALIM		2DEC	.06		# 1.5/25

Q7MIN		=	KA4		# = 40/805 = .049689441
-HSCALED	2DEC	-.55305018	# -28500/2 VS

-KSCALE		2DEC	-.0312424837	# -805/VS 

COS15		2DEC	.965 

LATSLOPE	EQUALS	1/12TH
# ... END OF RE-ENTRY CONSTANTS ...
