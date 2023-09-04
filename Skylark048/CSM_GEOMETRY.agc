### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	CSM_GEOMETRY.agc
## Purpose:	Part of the source code for Artemis (i.e., Colossus 3),
##		build 072.  This is for the Command Module's (CM)
##		Apollo Guidance Computer (AGC), for
##		Apollo 15-17.
## Assembler:	yaYUL
## Contact:	Jim Lawton <jim DOT lawton AT gmail DOT com>
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2009-08-08 JL	Adapted from corresponding Comanche 055 file.
##		2010-02-08 JL	Fixed a line that should have been commented out on p305.
##		2010-02-20 RSB	Un-##'d this header.
##		2017-01-21 RSB	Proofed comment text by diff'ing vs Comanche 55
##				and corrected errors found.
##		2017-01-28 RSB	WTIH -> WITH.


		SETLOC	COMGEOM1
		BANK

# THIS ROUTINE TAKES THE SHAFT AND TRUNNION ANGLES AS READ BY THE CM OPTICAL SYSTEM AND CONVERTS THEM INTO A UNIT
# VECTOR REFERENCED TO THE NAVIGATION BASE COORDINATE SYSTEM AND COINCIDENT WITH THE SEXTANT LINE OF SIGHT.
#
# THE INPUTS ARE  1) THE SEXTANT SHAFT AND TRUNNION ANGLES ARE STORED SP IN LOCATIONS 3 AND 5 RESPECTIVELY OF THE
# MARK VAC AREA.  2) THE COMPLEMENT OF THE BASE ADDRESS OF THE MARK VAC AREA IS STORED SP AT LOCATION X1 OF YOUR
# JOB VAC AREA.
#
# THE OUTPUT IS A HALF-UNIT VECTOR IN NAVIGATION BASE COORDINATES AND STORED AT LOCATION 32D OF THE VAC AREA. THE
# OUTPUT IS ALSO AVAILABLE AT MPAC.

		COUNT*	$$/GEOM
SXTNB		SLOAD*	RTB		# PUSHDOWN 00,02,04,(17D-19D),32D-36D
			5,1		# TRUNNION = TA
			CDULOGIC
		RTB	PUSH
			SXTLOGIC
		SIN	SL1
		PUSH	SLOAD*		# PD2 = SIN(TA)
			3,1		# SHAFT = SA
		RTB	PUSH		# PD4 = SA
			CDULOGIC

		COS	DMP
			2
		STODL	STARM		# COS(SA)SIN(TA)

		SIN	DMP
		STADR
		STODL	STARM +2	# SIN(SA)SIN(TA)

		COS
		STOVL	STARM +4
			STARM		# STARM = 32D
		MXV	VSL1
			NB1NB2
		STORE	32D
		RVQ

SXTLOGIC	CAF	10DEGS-		# CORRECT FOR 19.775 DEGREE OFFSET
		ADS	MPAC
		CAF	QUARTER
		TC	SHORTMP
		TC	DANZIG


# CALCSXA COMPUTES THE SEXTANT SHAFT AND TRUNNION ANGLES REQUIRED TO POSITION THE OPTICS SUCH THAT A STAR LINE-
# OF-SIGHT LIES ALONG THE STAR VECTOR. THE ROUTINE TAKES THE GIVEN STAR VECTOR AND EXPRESSES IT AS A VECTOR REF-
# ERENCED TO THE OPTICS COORDINATE SYSTEM. IN ADDITION IT SETS UP THREE UNIT VECTORS DEFINING THE X, Y, AND Z AXES
# REFERENCED TO THE OPTICS COORDINATE SYSTEM.
#
# THE INPUTS ARE  1) THE STAR VECTOR REFERRED TO PRESENT STABLE MEMBER COORDINATES STORED AT STAR.  2) SAME ANGLE
# INPUT AS *SMNB*, I.E. SINES AND COSINES OF THE CDU ANGLES, IN THE ORDER Y Z X, AT SINCDU AND COSCDU.  A CALL
# TO CDUTRIG WILL PROVIDE THIS INPUT.
#
# THE OUTPUTS ARE THE SEXTANT SHAFT AND TRUNNION ANGLES STORED DP AT SAC AND PAC RESPECTIVELY.  (LOW ORDER PART
# EQUAL TO ZERO).

CALCSXA		ITA	VLOAD		# PUSHDOWN 00-26D,28D,30D,32D-36D
			28D
			STAR
		CALL
			*SMNB*
		MXV	VSL1
			NB2NB1
		STOVL	STAR
			HIUNITX
		STOVL	XNB1
			HIUNITY
		STOVL	YNB1
			HIUNITZ
		STCALL	ZNB1
			SXTANG1


# SXTANG COMPUTES THE SEXTANT SHAFT AND TRUNNION ANGLES REQUIRED TO POSITION THE OPTICS SUCH THAT A STAR LINE-OF-
# SIGHT LIES ALONG THE STAR VECTOR.
#
# THE INPUTS ARE  1) THE STAR VECTOR REFERRED TO ANY COORDINATE SYSTEM STORED AT STAR.  2) THE NAVIGATION BASE
# COORDINATES REFERRED TO THE SAME COORDINATE SYSTEM. THESE THREE HALF-UNIT VECTORS ARE STORED AT XNB, YNB, AND
# ZNB.
#
# THE OUTPUTS ARE THE SEXTANT SHAFT AND TRUNNION ANGLES STORED DP AT SAC AND PAC RESPECTIVELY.  (LOW ORDER PART
# EQUAL TO ZERO).

SXTANG		ITA	RTB		# PUSHDOWN 16D,18D,22D-26D,28D
			28D
			TRANSP1		# EREF WRT NB2
		VLOAD	MXV
			XNB
			NB2NB1
		VSL1
		STOVL	XNB1
			YNB
		MXV	VSL1
			NB2NB1
		STOVL	YNB1
			ZNB
		MXV	VSL1
			NB2NB1
		STORE	ZNB1

		RTB	RTB
			TRANSP1
			TRANSP2

SXTANG1		VLOAD	VXV
			ZNB1
			STAR
		BOV
			+1
		UNIT	BOV
			ZNB=S1
		STORE	PDA		# PDA = UNIT(ZNB X S)

		DOT	DCOMP
			XNB1
		STOVL	SINTH		# SIN(SA) = PDA . -XNB
			PDA

		DOT
			YNB1
		STCALL	COSTH		# COS(SA) = PDA . YNB
			ARCTRIG
		RTB
			1STO2S
		STOVL	SAC
			STAR
		BOV
			+1
		DOT	SL1
			ZNB1
		ACOS
		BMN	SL2
			SXTALARM	# TRUNNION ANGLE NEGATIVE
		BOV	DSU
			SXTALARM	# TRUNNION ANGLE GREATER THAN 90 DEGREES
			20DEG-
		RTB
			1STO2S
		STORE	PAC		# FOR FLIGHT USE, CULTFLAG IS ON IF
		CLRGO			# TRUNION IS GREATER THAN 90 DEG
			CULTFLAG
			28D
SXTALARM	SETGO			# ALARM HAS BEEN REMOVED FROM THIS
			CULTFLAG
			28D		# SUBROUTINE, ALARM WILL BE SET BY MPI
ZNB=S1		DLOAD
			270DEG
		STODL	SAC
			20DEGS-
		STORE	PAC
		CLRGO
			CULTFLAG
			28D


# THESE TWO ROUTINES COMPUTE THE ACTUAL STATE VECTOR FOR LM, CSM BY ADDING
# THE CONIC R,V AND THE DEVIATIONS R,V.  THE STATE VECTORS ARE CONVERTED TO
# METERS B-29 AND METERS/CSEC B-7 AND STORED APPROPRIATELY IN RN,VN OR
# R-OTHER , V-OTHER FOR DOWNLINK. THE ROUTINES NAMES ARE SWITCHED IN THE
# OTHER VEHICLES COMPUTER.
#
# INPUT
#	STATE VECTOR IN TEMPORARY STORAGE AREA
#	IF STATE VECTOR IS SCALED POS B27 AND VEL B5
#		SET X2 TO +2
#	IF STATE VECTOR IS SCALED POS B29 AND VEL B7
#		SET X2 TO 0
#
# OUTPUT
#	R(T) IN RN, V(T) IN VN, T IN PIPTIME
# OR
#	R(T) IN R-OTHER, V(T) IN V-OTHER	(T IS DEFINED BY T-OTHER)

		SETLOC	COMGEOM2
		BANK
		COUNT*	$$/GEOM
SVDWN1		BOF	RVQ			# SW=1=AVETOMID DOING W-MATRIX INTEG
			AVEMIDSW
			+1
		VLOAD	VSL*
			TDELTAV
			0 	-7,2
		VAD	VSL*
			RCV
			0,2
		STOVL	RN
			TNUV
		VSL*	VAD
			0	-4,2
			VCV
		VSL*
			0,2
		STODL	VN
			TET
		STORE	PIPTIME
		RVQ

SVDWN2		VLOAD	VSL*
			TDELTAV
			0	-7,2
		VAD	VSL*
			RCV
			0,2
		STOVL	R-OTHER
			TNUV
		VSL*	VAD
			0	-4,2
			VCV
		VSL*
			0,2
		STORE	V-OTHER
		RVQ


# SUBROUTINE TO COMPUTE THE NATURAL LOG OF C(MPAC, MPAC +1).
#
#	ENTRY:	CALL
#			LOG
#
# SUBROUTINE RETURNS WITH -LOG IN DP MPAC.
#
# EBANK IS ARBITRARY..

		SETLOC	POWFLIT2
		BANK
		COUNT*	$$/GEOM
LOG		NORM	BDSU		# GENERATES LOG BY SHIFTING ARG
			MPAC +3		# UNTIL IT LIES BETWEEN .5 AND 1.
			NEARLY1		# THE LOG OF THIS PART IS FOUND AND THE
		EXIT			# LOG OF THE SHIFTED PART IS COMPUTED

		TC	POLY		# AND ADDED IN. SHIFT COUNT STORED

		DEC	2		# (N-1, SUPPLIED BY SMERZH)
		2DEC	0		# IN MPAC +3.
		2DEC	.031335467
		2DEC	.0130145859
		2DEC	.0215738898

		CAF	ZERO
		TS	MPAC +2
		EXTEND
		DCA	CLOG2/32
		DXCH	MPAC
		DXCH	MPAC +3
		COM			# LOAD POSITIVE SHIFT COUNT IN A.
		TC	SHORTMP		# MULTIPLY BY SHIFT COUNT.

		DXCH	MPAC +1
		DXCH	MPAC
		DXCH	MPAC +3
		DAS	MPAC
		TC	INTPRET		# RESULT IN MPAC, MPAC +1

		RVQ

NEARLY1		=	NEARONE
CLOG2/32	2DEC	.0216608494


# SUBROUTINE NAME:  EARTH ROTATOR	(EARROT1 OR EARROT2)		DATE:  15 FEB 67
# MOD NO:  N +1								LOG SECTION:  POWERED FLIGHT SUBROS
# MOD BY:  ENTRY GROUP (BAIRNSFATHER)
#
# FUNCTIONAL DESCRIPTION:  THIS ROUTINE PROJECTS THE INITIAL EARTH TARGET VECTOR   RTINIT   AHEAD THROUGH
#	THE ESTIMATED TIME OF FLIGHT. INITIAL CALL RESOLVES THE INITIAL TARGET VECTOR   RTINIT   INTO EASTERLY
#	AND NORMAL COMPONENTS   RTEAST   AND   RTNORM   . INITIAL AND SUBSEQUENT CALLS ROTATE THIS VECTOR
#	ABOUT THE (FULL) UNIT POLAR AXIS   UNITW   THROUGH THE ANGLE   WIE DTEAROT   TO OBTAIN THE ROTATED
#	TARGET VECTOR   RT   . ALL VECTORS EXCEPT   UNITW   ARE HALF UNIT.
#	THE EQUATIONS ARE
#		-    -        -                      -
#		RT = RTINIT + RTNORM (COS(WT) - 1) + RTEAST SIN(WT)
#
#	WHERE	WT = WIE DTEAROT
#
#		RTINIT = INITIAL TARGET VECTOR
#		-        -       -
#		RTEAST = UNITW * RTINIT
#		-        -        -
#		RTNORM = RTEAST * UNITW
#
#	FOR CONTINUOUS UPDATING, ONLY ONE ENTRY TO EARROT1 IS REQUIRED, WITH SUBSEQUENT ENTRIES AT EARROT2.
#
# CALLING SEQUENCE:	FIRST CALL			SUBSEQUENT CALL
#			STCALL	DTEAROT			STCALL	DTEAROT
#				EARROT1				EARROT2
#			C(MPAC) UNSPECIFIED		C(MPAC) = DTEAROT
#	PUSHLOC = PDL+0, ARBITRARY.  6 LOCATIONS USED.
#
# SUBROUTINES USED:  NONE
#
# NORMAL EXIT MODES:  RVQ
#
# ALARMS:  NONE
#
# OUTPUT:	RTEAST	(-1)		.5 UNIT VECTOR EAST, COMPNT OF RTINIT	LEFT BY FIRST CALL
#		RTNORM	(-1)		.5 UNIT VECTOR NORML, COMPNT OF RTINIT	LEFT BY FIRST CALL
#		RT	(-1)		.5 UNIT TARGET VECTOR, ROTATED		LEFT BY ALL CALLS
#		DTEAROT	(-28) CS	MAY BE CHANGED BY EARROT2, IF OVER 1 DAY
#
# ERASABLE INITIALIZATION REQUIRED:
#		UNITW	(0)		UNIT POLAR VECTOR			PAD LOADED
#		RTINIT	(-1)		.5 UNIT INITIAL TARGET VECTOR		LEFT BY ENTRY
#		DTEAROT	(-28) CS	TIME OF FLIGHT				LEFT BY CALLER
#
# DEBRIS:  QPRET, PDL+0 ... PDL+5

		EBANK=	RTINIT

EARROT1		VLOAD	VXV
			UNITW		# FULL UNIT VECTOR
			RTINIT		# .5 UNIT
		STORE	RTEAST		# .5 UNIT

		VXV
			UNITW		# FULL UNIT
		STODL	RTNORM		# .5 UNIT
			DTEAROT		# (-28) CS

EARROT2		BOVB	DDV
			TCDANZIG	# RESET OVFIND, IF ON
			1/WIE
		BOV	PUSH
			OVERADAY
		COS	DSU
			HIDPHALF
		VXSC	PDDL		# XCH W PUSH LIST
			RTNORM		# .5 UNIT
		SIN	VXSC
			RTEAST		# .5 UNIT
		VAD	VSL1
		VAD	UNIT		# INSURE THAT RT IS 'UNIT'.
			RTINIT		# .5 UNIT
		STORE	RT		# .5 UNIT TARGET VECTOR

		RVQ

OVERADAY	DLOAD	SIGN
			1/WIE
			DTEAROT
		BDSU
			DTEAROT
		STORE	DTEAROT

		GOTO
			EARROT2

#WIE		2DEC	.1901487997
1/WIE		2DEC	8616410

NB2NB1		2DEC	+.8431756920 B-1
		2DEC	0
		2DEC	-.5376381241 B-1


ZERINFLT	2DEC	0

HALFNFLT	2DEC	.5
		2DEC	0
		2DEC	+.5376381241 B-1
		2DEC	0
		2DEC	+.8431756920 B-1

NB1NB2		2DEC	+.8431756920 B-1
		2DEC	0
		2DEC	+.5376381241 B-1
		2DEC	0
		2DEC	.5
		2DEC	0
		2DEC	-.5376381241 B-1
		2DEC	0
		2DEC	+.8431756920 B-1


10DEGS-		DEC	3600

270DEG		OCT	60000		# SHAFT   270 DEGREES	2S COMP.
		OCT	00000

20DEGS-		DEC	-07199
		DEC	-00000

20DEG-		DEC	03600
		DEC	00000
