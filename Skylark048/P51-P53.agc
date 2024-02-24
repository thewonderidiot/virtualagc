### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	P51-P53.agc
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


# PROGRAM NAME - PROG52				DATE - AUGUST 1,1969
# MODIFICATION BY ALBERT,BARNERT,HASLAM		LOG SECTION - P51-P5
#
# FUNCTION -
#
# ALIGNS THE IMU TO ONE OF THREE ORIENTATIONS SELECTED BY THE ASTRONAUT. THE PRESENT IMU ORIENTATION IS KNOWN
# AND IS STORED IN REFSMMAT. THE THREE POSSIBLE ORIENTATIONS MAY BE_
#
#	(A) PREFERRED ORIENTATION
#
#	AN OPTIMUM ORIENTATION FOR A PREVIOUSLY CALCULATED MANUEVER. THIS ORIENTATION MUST BE CALCULATED AND
#	STORED BY A PREVIOUSLY SELECTED PROGRAM.
#
#	(B) NOMINAL (LOCAL VERTICAL) ORIENTATION
#
#		X   = UNIT ( Y   X Z   )
#		-SM          -SM   -SM
#
#		Y   = UNIT (V X R)
#		-SM         -   -
#
#		Z   = UNIT ( -R )
#		-SM           -
#
#		WHERE_
#
#		R = THE GEOCENTRIC RADIUS VECTOR AT TIME T(ALIGN) SELECTED BY THE ASTRONAUT
#		-
#
#		V = THE INERTIAL VELOCITY VECTOR AT TIME T(ALIGN) SELECTED BY THE ASTRONAUT
#		-
#
#	(C) REFSMMAT ORIENTATION
#
#	THIS ORIENTATION IS SELECTED AUTOMATICALLY UNLESS THE ASTRONAUT KEYS IN A DIFFERENT OPTION CODE
#
#	THIS SELECTION CORRECTS THE PRESENT IMU ORIENTATION. THE PRESENT ORIENTATION DIFFERS FROM THAT TO WHICH IT
#	WAS LAST ALIGNED ONLY DUE TO GYRO DRIFT (I.E. NEITHER GIMBAL LOCK NOR IMU POWER INTERRUPTION HAS OCCURED
#	SINCE THE LAST ALIGNMENT).
#
# AFTER A IMU ORIENTATION HAS BEEN SELECTED ROUTINE S52.2 IS OPERATED TO COMPUTE THE GIMBAL ANGLES USING THE
# NEW ORIENTATION AND THE PRESENT VEHICLE ATTITUDE.  CAL52A THEN USES THESE ANGLES, STORED IN THETAD,+1,+2, TO
# COARSE ALIGN THE IMU. THE STAR SELECTION ROUTINE, R56, IS THEN OPERATED. IF 2 STARS ARE NOT AVAILABLE AN ALARM
# IS FLASHED TO NOTIFY THE ASTRONAUT. AT THIS POINT THE ASTRONAUT WILL MANUEVER THE VEHICLE AND SELECT 2 STARS
# EITHER MANUALLY OR AUTOMATICALLY. AFTER 2 STARS HAVE BEEN SELECTED THE IMU IS FINE ALIGNED USING ROUTINE R51. IF
# THE RENDEZVOUS NAVIGATION PROCESS IS OPERATING (INDICATED BY RNDVZFLG) P20 IS DISPLAYED. OTHERWISE P00 IS
# REQUESTED.
#
# CALLING SEQUENCE -
#
#	THE PROGRAM IS CALLED BY THE ASTRONAUT BY DSKY ENTRY.
#
# SUBROUTINES CALLED -
#
#	1. FLAGDOWN		 6. S52.2		11. GOPERF3
#	2. R02BOTH		 7. CAL53A		12. NEWMODEX
#	3. GOPERF4		 8. FLAGUP		13. PRIOLARM
#	4. MATMOVE		 9. R56
#	5. GOFLASH		10. R51
#
# NORMAL EXIT MODES -
#
#	EXITS TO ENDOFJOB
#
# ALARM OR ABORT EXIT MODES -
#
#	NONE
#
# OUTPUT -
#
#	THE FOLLOWING MAY BE FLASHED ON THE DSKY
#		1. IMU ORIENTATION CODE
#		2. ALARM CODE 215 - PREFERRED IMU ORIENTATION NOT SPECIFIED
#		3. TIME OF NEXT IGNITION
#		4. GIMBAL ANGLES
#		5. ALARM CODE 405 - TWO STARS NOT AVAILABLE
#		6. PLEASE PERFORM P00
#	THE MODE DISPLAY MAY BE CHANGED TO 20
#
# ERASABLE INITIALIZATION REQUIRED -
#
#	PFRATFLG SHOULD BE SET IF A PREFERRED ORIENTATION HAS BEEN COMPUTED. IF IT HAS BEEN COMPUTED IT IS STORED IN
#	XSMD, YSMD, ZSMD.
#	RNDVZFLG INDICATES WHETHER THE RENDEZVOUS NAVIGATION PROCESS IS OPERATING.
#
# DEBRIS -
#
#	WORK AREA

P54		=	PROG52
		SETLOC	P50S
		BANK

		SBANK=	LOWSUPER
		EBANK=	SAC
		COUNT*	$$/P52
PROG52		TC	DOWNFLAG
		ADRES	UPDATFLG	# BIT 7 FLAG 1
		TC	DOWNFLAG
		ADRES	TRACKFLG	# BIT 5 FLAG 1
		TC	BANKCALL
		CADR	R02BOTH		# IMU STATUS CHECK
		TC	INTPRET
		BON	EXIT		# MINKEY SEQUENCE?
			AUTOSEQ
			P52AUTO		# YES

		CA	FLAGWRD8
		MASK	UTBIT
		EXTEND
		BZF	+6

		CCS	OPTNTYPE
		TCF	+2
		TCF	+3
		TC	UPFLAG
		ADRES	TRACKFLG

		CAF	PFRATBIT
		MASK	FLAGWRD2	# PREFERRED ORIENTATION
		CCS	A
		TC	P52A
		CAF	THREE		# ION
		TC	P52A +1
P52A		CAF	BIT1		# YES - SET OPTION 2 = 1
 +1		TS	OPTION2
P52B		CAF	BIT1
		TC	BANKCALL	# FLASH OPTION CODE AND ORIENTATION CODE
		CADR	GOPERF4
		TC	GOTOPOOH
		TC	+2	
		TC	P52B		# NEW CODE - NEW ORIENTATION CODE INPUT
		CS	OPTION2
		MASK	THREE
		EXTEND
		BZF	P52C		# REFERENCE
		MASK	BIT1
		EXTEND
		BZF	P52J		# PREFERRED
		EXTEND			# NOMINAL (LOCAL VERTICAL), LANDING SIGHT
		DCA	NEG0
		DXCH	DSPTEM1
		CAF	V06N34		# PREFERRED
		TC	VNFLASH
		CA	DSPTEM1
		EXTEND
		BZF	+2
		TCF	+4

		EXTEND
		DCA	TIME2
		DXCH	DSPTEM1

# NAME - S52.3
# FUNCTION - TO COMPUTE AMD DISPLAY THE
# GIMBAL ANGLES, ALLOW ASTRONAUT TO CHOOSE
# BETWEEN FAST AND ACCURATE IMU REALIGNMENT.
# NOMINAL (LOCAL VERTICAL) ORIENTATION IS:
#		XSMD= UNIT(YSMD X ZSMD)
#		YSMD= UNIT(V X R)
#		ZSMD= UNIT(-R)
#
# INPUT -	TIME OF ALIGNMENT IN MPAC
#
# OUTPUT -	X,Y,ZSMD
#
# SUBROUTINES - CSMCONIC

S52.3		TC	INTPRET
		DLOAD
			DSPTEM1
		STCALL	TDEC1
			CSMPREC
		SETPD	VLOAD
			0
			RATT
		VCOMP	UNIT
		STOVL	ZSMD
			VATT
		VXV	UNIT
			RATT
		STORE	YSMD
		VXV	UNIT
			ZSMD
		STORE	XSMD
		EXIT
P52J		TC	INTPRET
P52D		CALL			# READ VEHICLE ATTITUDE AND
			S52.2		#  COMPUTE GIMBAL ANGLES
		EXIT
		CAF	V06N22
		TC	BANKCALL	# DISPLAY GIMBAL ANGLES
		CADR	GOFLASH
		TC	GOTOPOOH
		TC	COARSTYP
		TC	P52J		# RECYCLE - VEHICLE HAS BEEN MANEUVERED
COARSTYP	CS	FLGWRD10
		MASK	AUTSQBIT
		EXTEND
		BZF	PERF20		# IF MINKEY
		CAF	OCT13		# PLEASE PERFORM NORMAL/GYRO TORQUE
		TC	BANKCALL
		CADR	GOPERF1
		TCF	GOTOPOOH	# V34
		TCF	P52K		# NORMAL COARSE
GYCRS		TC	INTPRET
		VLOAD	MXV
			XSMD
			REFSMMAT
		UNIT
		STOVL	XDC
			YSMD
		MXV	UNIT
			REFSMMAT
		STOVL	YDC
			ZSMD
		MXV	UNIT
			REFSMMAT
		STCALL	ZDC
			CALCGTA
		CLEAR	CLEAR
			DRIFTFLG
			REFSMFLG
		EXIT
		CAF	V16N20
		TC	BANKCALL
		CADR	GODSPR
		CAF	R55CDR
		TC	BANKCALL
		CADR	IMUPULSE
		TC	BANKCALL
		CADR	IMUSTALL
		TC	217ALARM	# BAD END
		TC	PHASCHNG
		OCT	04024
		TC	INTPRET
		AXC,1	AXC,2
			XSMD
			REFSMMAT
		CALL
			MATMOVE
		CLEAR	SET
			PFRATFLG
			REFSMFLG
		RTB	VLOAD
			SET1/PDT
			ZEROVEC
		STORE	GCOMP
		SET	BOF
			DRIFTFLG
			AUTOSEQ
			R51K		# CONTINUE FINE ALIGN IF NOT MINKEY
		CLEAR
			PCFLAG
P50SEXIT	EXIT
		TCF	MNKGOPOO
V16N20		VN	1620
ALRM15		EQUALS	OCT15
P52AUTO		BOFF	RTB
			PCFLAG
			P52AUTO1
			RDCDUS
		SLOAD	SR1
			2
		COS
		SIGN	CLEAR
			DELVLVC +2
			TCOMPFLG
		BPL	SET
			P52AUTO1
			TCOMPFLG
P52AUTO1	VLOAD	VSR1		# XDES = UNIT(XREF COS45 + YERF SIN45) (1)
			REFSMMAT	#			 - 	       (2)
		PDVL	VSR1
			REFSMMAT +6	# (1) FOR 1ST, +45-DEGREE MANEUVER
		BON	VCOMP		# (2)     2ND  -
			PCFLAG		# IN EITHER CASE, COS45 = SIN45, AND
			+1		# 	'UNIT' OBVIATES NEED FOR THEN.
		BOFF	VCOMP
			TCOMPFLG
			P52AUTOX

P52AUTOX	VAD	UNIT
		STADR
		STOVL	XSMD
			REFSMMAT +12D
		STORE	ZSMD		# ZDES = ZREF
		VXV	UNIT
			XSMD
		STORE	YSMD		# YDES = UNIT(ZDES * ZDES)
		SET	GOTO
			PFRATFLG
			P52D

PERF20		CAF	BIT5		# =OCT 20, PLEASE PERF MINKEY PC TORQUE
		TC	BANKCALL
		CADR	GOPERF1
		TC	GOTOPOOH	# V 34
		TC	GYCRS		# PRO - DO IT
		TC	INTPRET		# ENTR
		BON	EXIT
			PCFLAG
			P50SEXIT	# OK TO FLUSH IT 1ST TIME ONLY
		TC	ALARM		# BUT MAKE HIM DO 2ND
		OCT	00402
		TC	PERF20
# NAME - CAL53A
# FUNCTION - COARSE ALIGN THE IMU, IF NECESSARY,
# INPUT - PRESENT GIMBAL ANGLES - CDUX, CDUY, CDUZ
#	  DESIRED GIMBAL ANGLES - THETAD,+1,+2
# OUTPUT - THE IMU COORDINATES ARE STORED IN REFSMMAT
# SUBROUTINES USED - 1.IMUCOARS 2.IMUSTALL 3.CURTAINS

		COUNT*	$$/R50
P52K		TC	INTPRET
CAL53A		CALL
			S52.2		# MAKE FINAL COMP OF GIMBAL ANGLES
		RTB	SSP
			RDCDUS		# READ CDUS
			S1
			1
		AXT,1	SETPD
			3
			4

CALOOP		DLOAD*	SR1
			THETAD +3D,1
		PDDL*	SR1
			4,1
		DSU	ABS
		PUSH	DSU
			DEGREE1
		BMN	DLOAD
			CALOOP1
		DSU	BPL
			DEG359
			CALOOP1
COARFINE	EXIT
		TC	PHASCHNG
		OCT	04024
		TC	COARSUB		# PERFORM ALIGNMENT
		TC	INTPRET
		GOTO
			FINEONLY
CALOOP1		TIX,1
			CALOOP
FINEONLY	SLOAD			## FIXME FINEONLY HAS CHANGED DRAMATICALLY
			THETAD
		STODL	CDUSPOT +4
			THETAD +1
		STODL	CDUSPOT
			THETAD +2
		STOVL	CDUSPOT +2
			XUNIT
		CALL
			TRG*NBSM
		STOVL	STARAD
			YUNIT
		CALL
			*NBSM*
		STCALL	STARAD +6
			CDUTRIG
		CALL
			CALCSMSC
		VLOAD
			XDC
		STOVL	6D
			YDC
		STCALL	12D
			AXISGEN
		CALL
			CALCGTA
		CLEAR	CLEAR
			REFSMFLG
			DRIFTFLG
		EXIT
		CA	R55CDR
		TC	BANKCALL
		CADR	IMUPULSE
		TC	BANKCALL
		CADR	IMUSTALL
		TC	217ALARM
		TC	PHASCHNG
		OCT	04024
		TC	INTPRET
		RTB	VLOAD
			SET1/PDT
			ZEROVEC
		STORE	GCOMP
		SET	AXC,1
			DRIFTFLG
			XSMD
		AXC,2	CALL
			REFSMMAT
			MATMOVE
CAL53RET	SET	EXIT
			REFSMFLG
		COUNT*	$$/P52
P52C		TC	PHASCHNG
		OCT	04024
		TC	E7SETTER
		CAF	ALRM15
		TC	BANKCALL
		CADR	GOPERF1
		TC	GOTOPOOH
		TC	+2		# V33
		TC	R51		# FINE ALIGN
		TC	INTPRET
		RTB	DAD
			LOADTIME
			TSIGHT1
		CALL
			LOCSAM
		COUNT*	$$/PICAP

# NAME - PICAPAR	NOW IN-LINE
#
# FUNCTION -
# THIS PROGRAM READ THE IMU-CDUS AND COMPUTES THE VEHICLE ORIENTATION
# WITH RESPECT TO INERTIAL SPACE. IT THEN COMPUTES THE SHAFT AXIS (SAX)
# WITH RESPECT TO REFERENCE INERTIAL. EACH STAR IN THE CATALOG IS TESTED
# TO DETERMINE IF IT IS OCCULTED BY EITHER THE EARTH, SUN OR MOON. IF A
# STAR IS NOT OCCULTED THEN IT IS PAIRED WITH ALL STAR OF LOWER INDEX.
# THE PAIRED STAR IS TESTED FOR OCCULTATION. PAIRS OF STARS THAT PASS
# THE OCCULTATION TESTS ARE TESTED FOR GOOD SEPARATION. A PAIR OF STARS
# HAVE GOOD SEPARATION IF THE ANGLE BETWEEN THEM IS LESS THAN 76 DEGREES
# AND MORE THAN 30 DEGREES. THOSE PAIRS OF STARS WITH GOOD SEPARATION
# ARE THEN TESTED TO SEE IF THEY LIE IN CURRENT FIELD OF VIEW. (WITHIN
# 38 DEGREES OF SAX). THE PAIR WITH MAXIMUM SEPARATION IS CHOSEN FROM
# THOSE WITH GOOD SEPARATION, AND IN FIELD OF VIEW.
#
# OUTPUT
#	BESTI, BESTJ - SINGLE PREC, INTEGERS, STAR NUMBERS TIMES 6
#	VFLAG - FLAG BIT  SET IMPLIES NO STARS IN FIELD OF VIEW
#
# INITIALIZATION
# 	1) A CALL TO LOCSAM MUST BE MADE
# 	2) VEARTH = -UNIT(R) WHERE R HAS BEEN UPDATED TOO APPROXIMATE TIME OF
#		SIGHTINGS.
#
# DEBRIS
#	WORK AREA
#	X,Y,ZNB
#	SINCDU, COSCDU
#	STARAD - STAR +5

		CALL
			CDUTRIG
		SETPD	CALL
			0
			CALCSMSC
		SET	DLOAD		# VFLAG = 1
			VFLAG
			DPZERO
		STOVL	BESTI
			XNB
		VXSC	PDVL
			SIN33
			ZNB
		AXT,1	VXSC
			228D		# X1 = 37 X 6 + 6
			COS33
		VAD
		VXM	UNIT
			REFSMMAT
		STORE	SAX		# SAX = SHAFT AXIS
		SSP	SSP		# S1 = S2 = 6
			S1
			6
			S2
			6
PIC1		TIX,1	GOTO		# MAJOR STAR
			PIC2
			PICEND
PIC2		VLOAD*	CALL
			CATLOG,1
			OCCULT
		BON	LXA,2
			CULTFLAG
			PIC1
			X1
PIC3		TIX,2	GOTO
			PIC4
			PIC1
PIC4		VLOAD*	CALL
			CATLOG,2
			OCCULT
		BON	VLOAD*
			CULTFLAG
			PIC3
			CATLOG,1
		DOT*	DSU
			CATLOG,2
			CSS66		# SEPARATION LESS THAN 76 DEG.
		BMN	DAD
			PIC3
			CSS6640		# SEPARATION MORE THAN 30 DEG.
		BPL	
			PIC3
		VLOAD*	DOT
			CATLOG,1
			SAX
		DSU	BMN		# MAJOR STAR IN CONE
			CSS33
			PIC1
		VLOAD*	DOT
			CATLOG,2
			SAX
		DSU	BMN
			CSS33
			PIC3
STRATGY		BONCLR
			VFLAG
			NEWPAR
 -3		XCHX,1	XCHX,2
			BESTI
			BESTJ
STRAT		VLOAD*	DOT*
			CATLOG,1
			CATLOG,2
		PUSH	BOFINV
			VFLAG
			STRAT -3
		DLOAD	DSU
		BPL
			PIC3
NEWPAR		SXA,1	SXA,2
			BESTI
			BESTJ
		GOTO
			PIC3
OCCULT		MXV	BVSU
			CULTRIX
			CSS
		BMN	DLOAD
			CULTED
			MPAC +3
		BMN	CLRGO
			CULTED
			CULTFLAG
			QPRET
CULTED		SETGO
			CULTFLAG
			QPRET
CSS		= 	CEARTH
SIN33		2DEC	.5376381241

COS33		2DEC	.8431756920

CSS66		2DEC	.060480472	# (COS76)/4

CSS6640		2DEC	-.15602587	# (COS76 - COS30)/4

CSS33		2DEC	.197002688	# COS(1/2(76))/4

#V1		=	12D
PICEND		BOF	EXIT
			VFLAG
			P52F
P52I		TC	ALARM
		OCT	405
		CAF	V05N09
		TC	BANKCALL
		CADR	GOFLASH
		TC	GOTOPOOH
		TC	R51		# PROCEED - DO R51 FINE ALIGN
		TC	P52C		# RECYCLE - VEHICLE HAS BEEN MANUEVERED			
P52F		EXIT
		TCF	R51
		

# NAME - R51	FINE ALIGN
# FUNCTION - TO ALIGN THE STABLE MEMBER TO REFSMMAT
# INPUT - BESTI, BESTJ (PAIR OF STAR NO )
# OUTPUT - GYRO TORQUE PULSES
# SUBROUTINES - R52, R54, R55 (SXTNB, NBSM, AXISGEN

		COUNT*	$$/R51
R51		CAF	BIT1
R51.3		TS	STARIND

		TC	PHASCHNG
		OCT	05024		# RESTART  GR 4  FOR R52-R53
		OCT	13000
		INDEX	STARIND
		CA	BESTI
		EXTEND
		MP	1/6TH
		TS	STARCODE

R51DSP		CAF	V01N70
		TC	VNFLASHR
		TC	+4
		CAF	SIX
		TC	BLANKET
		TCF	ENDOFJOB
		TC	CHKSCODE
		TC	FALTON
		TC	R51DSP
		TC	INTPRET
		RTB	CALL
			LOADTIME
			PLANET
		SSP	LXA,1
			S1
			0
			STARIND
		TIX,1
			R51ST
		STCALL	STARSAV2	# 2ND STAR
			R51ST +1
R51ST		STORE	STARSAV1	# 1ST STAR
 +1		SLOAD	SL		# IS THIS P54
			MODREG
			12D
		BHIZ	CALL
			R51A1		# NO
			R56
R51B		CALL
			SXTSM
		STORE	STARSAV2
		DLOAD	CALL
			TSIGHT
			PLANET
		MXV	UNIT
			REFSMMAT
		EXIT
		CCS	STARIND
		TC	R51.4
		TC	INTPRET
		STOVL	STARAD
			STARSAV2
		STOVL	6D
			STARSAV1
		STOVL	12D
			PLANVEC
		STCALL	STARAD +6
			R54		# STAR DATA TEST
		BOFF	CALL
			FREEFLAG
			R51K
			AXISGEN

# NAME - R55 - GYRO TORQUE
# FUNCTION - COMPUTE AND SEND GYRO PULSES
# INPUT - X,Y,ZDC - REFSMMAT WRT PRESENT STABLE MEMBER
# OUTPUT - GYRO PULSES
# SUBROUTINES - CALCGTA, GOFLASH, GODSPR, IMUFINE, IMUPULSE, GOPERF1

		COUNT*	$$/R55		
R55		CALL			# COMPUTE AND SEND GYRO PULSES
			CALCGTA
PULSEM		EXIT
R55.1		CAF	V06N93
		TC	BANKCALL
		CADR	GOFLASH
		TC	GOTOPOOH
		TC	R55.2
		TC	R55RET
R55.2		TC	PHASCHNG
		OCT	00314
4P31SPT1	=	4.31SPOT
		CA	R55CDR
		TC	BANKCALL
		CADR	IMUPULSE
		TC	BANKCALL
		CADR	IMUSTALL
		TC	217ALARM	# BAD END
		TC	PHASCHNG
		OCT	05024
		OCT	13000
R55RET		TC	DOWNFLAG
		ADRES	PFRATFLG
		COUNT*	$$/R51
R51KA		CAF	OCT14
		TC	BANKCALL
		CADR	GOPERF1
		TC	GOTOPOOH
		TC	P52C		# V33
		TC	GOTOPOOH
R51.4		TC	INTPRET
		STOVL	PLANVEC
			STARSAV2
		STORE	STARSAV1
		EXIT
		CAF	ZERO
		TCF	R51.3		# CLEAR STARIND
R51A1		SLOAD	SR
			STARCODE
			6
		BHIZ	CALL
			R51A
			R53
		GOTO
			R51B
R51A		CALL
			R52
		GOTO
			R51B
R51K		EXIT
		TC	R51KA
R55CDR		ECADR	OGC
1/6TH		DEC	.1666667

# NAME - R52 - AUTOMATIC OPTICS POSITIONING ROUTINE
#
# FUNCTION-  (1) TO POINT THE STAR LOS OF THE OPTICS AT A STAR OR LANDMARK DEFINED BY THE PROGRAM OR BY DSKY INPUT.
#	     (2) TO POINT THE STAR LOS OF THE OPTICS AT THE LEM DURING RENDEZVOUS TRACKING OPERATIONS.
#
# CALLING SEQUENCE- CALL R52
#
# INPUT- 1. TARG1FLG AND TARG2FLG - PRESET BY CALLER
#	 2. RNDVZFLG AND TRACKFLG - PRESET BY CALLER
#	 3. STAR CODE - PRESET BY CALLER. ALSO INPUT THROUGH DSKY
#	 4. LAT, LONG AND ALT OF LANDMARK - INPUT THROUGH DSKY
#	 5. NO. OF MARKS (MARKINDX) - PRESET BY CALLER
#
# OUTPUT- DRIVE SHAFT AND TRUNNION CDUS
#
# SUBROUTINES-	1.  FIXDELAY		7.  CLEANDSP
#		2.  GOPERF1		8.  GODSPR
#		3.  GOFLASH		9.  REFLASHR
#		4.  R53			10. R52.2
#		5.  ALARM		11. R52.3
#		6.  SR52.1

		COUNT*	$$/R52
R52		STQ	EXIT
			SAVQR52
		CAF	EBANK5		# CALLER NOT ALWAYS IN E5.
		XCH	EBANK
		TS	R52BNKSV
		EXTEND
		DCA	CDUT
		DXCH	DESOPTT
		TC	INTPRET
		SSP	CLEAR
			OPTIND
			0
			R53FLAG
		BON	CLEAR
			TARG1FLG
			R52H
			TERMIFLG
		EXIT
R52C		CA	SWSAMPLE	# IS OPTICS MODE IN AGC
		EXTEND
		BZMF	R52M		# MANUAL
R52D		TC	INTPRET		# THIS IS SR52.1 - NOW IN-LINE
# NAME - SR52.1
#
# FUNCTION
#  TARG1 AND TARG2 FLAGS ARE LOOKED AT TO DETERMINE IF THE TARGET IS THE
#  LEM, STAR OR LANDMARK. IN CASE OF LEM OR LMK, THE PRESENT TIME PLUS
#  2 SECONDS IS SAVED IN AOPTIME (ALIAS STARAD, +1). IF THE LEM IS 
#  THE TARGET THEN CONIC UPDATES OF THE CSM AND LEM ARE MADE TO
#  THE TIME IN AOPTIME. THE UNIT OF THE DIFFERENCE OF LEM AND CSM
#  POSITION VECTORS BECOMES THE REFERENCE SIGHTING VECTOR USED IN THE
#  COMMON PART OF THIS PROGRAM.
#
#  IN THE CASE OF LANDMARK, THE CSM IS UPDATED CONICALLY. THE RADIUS
#  VECTOR FOR THE LANDMARK IS OBTAINED FROM LALOTORV. BOTH OF THESE ARE
#  FOUND FOR THE TIME IN AOPTIME. THE UNIT OF THE DIFFERENCE BETWEEN
#  THE LANDMARK AND CSM RADIUS VECTORS BECOMES THE REFERENCE SIGHTING
#  VECTOR FOR THE COMMON PART OF THIS ROUTINE.
#
#  IF A STAR IS THE TARGET, THE PROPER STAR IS OBTAINED FROM THE CATALOG
#  AND THIS VECTOR BECOMES THE REFERENCE SIGHTING VECTOR.
#
#  THE COMMON PART OF THIS PROGRAM TRANSFORMS THE REFERENCE SIGHTING
#  VECTOR INTO STABLE MEMBER COORDINATES. IT READS THE IMU-CDUS AND USES
#  THIS DATA IN A CALL TO CALCSXA. ON RETURN FROM CALCSXA A TEST IS
#  MADE TO SEE IF THE TRUNNION ANGLE IS GREATER THAN 90DEG. OR 50DEG.
#
# OUTPUT
#  SAC - SINGLE PREC, 2S COMP, SCALED AT HALF REVS - SHAFT ANGLE DESIRED
#  PAC - SINGLE PREC, 2S COMP SCALED AT EIGTH REVS - TRUNNION ANGLE DESIRED
#
# INITIALIZATION
#  IF TARG1FLG =1 THEN TARGET IS LEM - NO OTHER INPUT REQUIRED
#  IF TARG1FLG =0 AND TARG2FLG =0 THE TARGET IS STAR, STARIND SHOULD
#  0 OR 1 DENOTING BESTI OR BESTJ RESPECTIVELY AS STAR CODE. STAR CODES
#  ARE 6 TIMES STAR NUMBER.
#  IF TARG1FLG =0 AND TARG2FLG =1 THEN TARGET IS LANDMARK. SEE ROUTINE
#  LALOTORV FOR INPUT REQUIREMENTS. HERE FIXERAD=1 FOR CONSTANT EARTH
#  RADIUS
#
# DEBRIS
#  WORK AREA
#  STARAD - STAR+5 (STAR IS DESIRED LOS IN STABLE MEMBER COORDINATES)

		BON	SSP
			TARG1FLG
			LEM52
			S1
			0
		LXA,1	TIX,1
			STARIND
			ST52ST
		VLOAD	GOTO
			STARSAV2
			COM52
LEM52		RTB	DAD
			LOADTIME
			2.4SECDP
		STCALL	TDEC1
			LEMCONIC
		VLOAD
			RATT
LMKLMCOM	STODL	STAR
			TAT
		STCALL	TDEC1
			CSMCONIC
		VLOAD	VSU
			STAR
			RATT
		UNIT	GOTO
			COM52
ST52ST		VLOAD
			STARSAV1
COM52		MXV	UNIT
			REFSMMAT
		STORE	STAR
		SETPD	CALL
			0
			CDUTRIG		# COMPUTES SINES AND COSINES FOR CALCSXA
		CALL			#	NOW EXPECT TO SEE THE CDU ANGLES
			CALCSXA
		BON	DLOAD
			CULTFLAG
			R52L		# GR 90 DEGREES
			PAC
		DSU	BPL
			38TRDEG
			R52J		# GR 50 DEGREES
		DLOAD	DSU
			PAC
			20DEGSMN
		BMN	EXIT
			R52J
		CA	PAC
		TS	PACTEMP
R52JA		TC	INTPRET
		BON
			TARG1FLG
			R52E
R53CHK		BON	EXIT
			R53FLAG
			R52E
		CAF	V06N92		# NO
		TC	BANKCALL
		CADR	GODSPR
		TC	INTPRET
R52E		EXIT
		CA	PACTEMP
		TS	DESOPTT
		CA	SAC
		TS	DESOPTS
R52F		CAF	.5SEC		# WAIT .5 SEC
 +1		TC	BANKCALL
		CADR	DELAYJOB
		CAF	TARG1BIT
		MASK	FLAGWRD1
		CCS	A
		TC	R52HA

		CAF	TERMIBIT
		MASK	FLAGWRD7
		EXTEND
		BZF	R52C

R52Q		CA	R52BNKSV
		TS	EBANK

		TC	INTPRET
		GOTO
			SAVQR52

R52H		EXIT			# LEM
R52HA		TC	BANKCALL
		CADR	R61CSM
		CAF	TRACKBIT
		MASK	FLAGWRD1
		EXTEND
		BZF	R52Q
		TC	INTPRET
		BOF	GOTO
			UPDATFLG
			R52SYNC
			R52D +1
R52SYNC		EXIT
		CAF	1.8SEC
		TCF	R52F +1
R52J		EXIT
		CA	38TRDEG
		TS	PACTEMP
		TC	R52JA
R52M		CAF	R53FLBIT	# IS R53FLAG SET
		MASK	FLAGWRD0
		CCS	A
		TC	R52F		# YES
		INHINT			# NO
		CAF	PRIO24
		TC	FINDVAC
		EBANK=	MRKBUF1
		2CADR	R53JOB

		RELINT
		TC	R52F
R53JOB		TC	INTPRET
		CALL
			R53
ENDPLAC		EXIT			# INTERPRETER RETURN TO ENDOFJOB (R22 USES)
		TC	ENDOFJOB		
V06N92		VN	00692
38TRDEG		2DEC	.66666667	# CORRESPONDS TO 50 DEGS IN TRUNNION

2.4SECDP	2DEC	240

.5SECDP		2DEC	50

20DEGSMN	DEC	-07199
		DEC	-0
R52L		BON	EXIT
			TARG1FLG
			R52J
		CAF	OCT404
		TC	BANKCALL
		CADR	PRIOLARM
		TCF	TERM52		# TERMINATE
		TCF	R52F		# PROCEED
		TCF	R52F		# NO PROVISION FOR NEW DATA
		TCF	ENDOFJOB
		
OCT404		OCT	404

1.8SEC		DEC	180

TERM52		TC	BANKCALL
		CADR	KLEENEX

		TC	POSTJUMP
		CADR	TERMSXT

# NAME - LOCSAM ALIAS S50
#
# FUNCTION - TO COMPUTE QUATITIGS LISTED BELOW, USED IN THE
#	     IMU ALIGNMENT PROGRAMS
#
# DEFINE:
#	RATT	= POSITION VECTOR OF CM  WRT PRIMARY BODY
#	VATT	= VELOCITY VECTOR OF CM  WRT PRIMARY BODY
#	RE	= RADIUS OF EARTH
#	RM	= RADIUS OF MOON
#	ECLIPOL	= POLE OF ECLIPTIC SCALED BY TANGENTIAL VELOCITY OF EARTH
#		  WRT TO SUN  OVER  THE VELOCITY OF LIGHT
#	REM	= POSITION OF MOON  WRT  EARTH
#	RES	= POSITION OF SUN  WRT  EARTH
#	C	= VELOCITY OF LIGHT
#
#
#		EARTH IS PRIMARY			MOON IS PRIMARY
#		        -                                       -
#		VEARTH=-1(RATT)				VEARTH=-1(REM+RATT)
#		        -				        -
#		VMOON = 1(REM-RATT)			VMOON =-1(RATT)
#		        -				        -
#		VSUN  = 1(RES)				VSUN  = 1(RES-REM)
#		              -1
#		CEARTH=COS(SIN  (RE/RATT)+5)		CEARTH=COS 5
#								      -1
#		CMOON =COS 5				CMOON =COS(SIN  CRM/RATT)+5)
#
#		CSUN  =COS 15				CSUN  =COS 15
#
#			    VEL/C = VSUN X ECLIPOL + VATT/C
#
#
# CALL -	DLOAD	CALL
#			DESIRED TIME
#			LOCSAM
#
# INPUTS - MPAC = TIME
#
# OUTPUTS- VEARTH,VMOON,VSUN,CEARTH,CMOON,CSUN,VEL/C
#
# SUBROUTINES- LSPOS,CSMCONIC
#
# DEBRIS - VAC AREA, SEE SUBROUTINES

		SETLOC	SR52/1
		BANK
		
		COUNT*	$$/S50

LOCSAM		=	S50
S50		STQ
			QMAJ
		STCALL	TSIGHT
			LSPOS
		VLOAD
			2D
		STODL	VSUN
			TSIGHT
		STCALL	TDEC1
			CSMCONIC
EARTCNTR	VLOAD
			RATT
		UNIT	VCOMP
		STODL	VEARTH
			RSUBE
OCCOS		DDV	SR1
			36D
		ASIN	DAD
			5DEGREES
		COS	SR1
		STOVL	CEARTH
			VSUN
ENDSAM		VXV
			ECLIPOL
		STOVL	VEL/C
			VATT
		VXSC	VAD
			1/C
			VEL/C
		STODL	VEL/C
			CSSUN
		STCALL	CSUN
			QMAJ
		SETLOC	P50S2
		BANK
		COUNT*	$$/S50
RSUBE		2DEC	6378166 B-29

5DEGREES	2DEC	.013888889 	# SCALED IN REVS

1/C		2DEC	.000042696 B-1	# 1/(9835712 FT/CS) SCALED CSEC/M B+7

ECLIPOL		2DEC	0		# POLE OF ECLIPTIC FOR B0=.409157363336 RAD

		2DEC	-.0000395319722	# AND CONST.AB = 20.496 ARC-SEC
		
		2DEC	+.0000911652662	# ECLIPOL = CONST.AB.(0, -SIN B0, COS B0)
		
TSIGHT1		2DEC	24000

CSUN		=	14D
CEARTH		=	16D

CSSUN		2DEC	.24148		# COS 15 /4

R54		=	CHKSDATA

# NAME - CHKSDATA
#
# FUNCTIONAL DESCRIPTION - CHECKS THE VALIDITY OF A PAIR OF STAR SIGHTINGS. WHEN A PAIR OF STAR SIGHTINGS ARE MADE
# BY THE ASTRONAUT THIS ROUTINE OPERATES AND CHECKS THE OBSERVED SIGHTINGS AGAINST STORED STAR VECTORS IN THE
# COMPUTER TO INSURE A PROPER SIGHTING WAS MADE. THE FOLLOWING COMPUTATIONS ARE PERFORMED_
#
#	OS1 = OBSERVED STAR 1 VECTOR
#	OS2 = OBSERVED STAR 2 VECTOR
#	SS1 = STORED STAR 1 VECTOR
#	SS2 = STORED STAR 2 VECTOR
#	 A1 = ARCCOS(OS1 - OS2)
#	 A2 = ARCCOS(SS1 - SS2)
#	  A = ABS(2(A1 - A2))
#
# THE ANGULAR DIFFERENCE IS DISPLAYED FOR ASTRONAUT ACCEPTENCE
# EXIT MODE 1. FREEFLAG SET  IMPLIES ASTRONAUT WANTS TO PROCEED
#	    2. FREEFLAG RESET IMPLIES ASTRONAUT WANTS TO RECYCLE            ERANCE)
# OUTPUT - 1. VERB 6,NOUN 3 - DISPLAYS ANGULAR DIFFERENCE BETWEEN 2 SETS OF STARS.
#	   2. STAR VECTORS FROM STAR CATALOG ARE LEFT IN 6D AND 12D.
#
# ERASABLE INITIALIZATION REQUIRED -
#	1. MARK VECTORS ARE STORED IN STARAD AND STARAD +6.
#	2. CATALOG VECTORS ARE STORED IN 6D AND 12D.
#
# DEBRIS -

		EBANK=	WHOCARES
		COUNT*	$$/R54
CHKSDATA	STQ	SET
			QMIN
			FREEFLAG
CHKSAB		AXC,1			# SET X1 TO STORE EPHEMERIS DATA
			STARAD

CHKSB		VLOAD*	DOT*		# CAL. ANGLE THETA
			0,1
			6,1
		SL1	ACOS
		STORE	THETA
		BOFF	INVERT		# BRANCH TO CHKSD IF THIS IS 2ND PASS
			FREEFLAG
			CHKSD
			FREEFLAG	# CLEAR FREEFLAG
		AXC,1	DLOAD		# SET X1 TO MARK ANGLES
			6D
			THETA
		STCALL	18D
			CHKSB
CHKSD		DLOAD	DSU
			THETA
			18D		# COMPUTE POS DIFF
		ABS	RTB		
			SGNAGREE
		SL1
		STODL	NORMTEM1
			18D
		SL1
		STORE	DSPTEM1 +1
		SET	EXIT
			FREEFLAG
		CAF	ZERO
		TC	BANKCALL
		CADR	CLEANDSP

		CAF	VB6N5
		TC	BANKCALL	
		CADR	GOFLASH
		TCF	GOTOPOOH
		TC	CHKSDA		# PROCEED
		TC	DOWNFLAG
		ADRES	FREEFLAG
CHKSDA		TC	INTPRET
		GOTO
			QMIN
VB6N5		VN	605

		COUNT*	$$/R50
MATMOVE		VLOAD*			# TRANSFER MATRIX
			0,1
		STORE	0,2
		VLOAD*
			6D,1
		STORE	6D,2
		VLOAD*
			12D,1
		STORE	12D,2
		RVQ
DEGREE1		DEC	46
DEG359		DEC	16338	
RDCDUS		INHINT			# READ CDUS
		EXTEND
		DCA	CDUX
		INDEX	FIXLOC
		DXCH	1
		CA	CDUZ
		INDEX	FIXLOC
		TS	3
		RELINT
		TC	DANZIG

# NAME - CALCSMSC
#
# FUNCTION - DETERMINE AND COMPUTE THE DESIRED GIMBAL ANGLES TO BE USED FOR COARSE ALIGNMENT.
#
# CALLING SEQUENCE - CALL CALCSMSC
#
# INPUT - DESIRED IMU INERTIAL ORIENTATION VECTORS - XSMD, YSMD, ZSMD
#
# OUTPUT - GIMBAL ANGLES LEFT IN THETAD, +1, +2				+
#
# SUBROUTINES USED - 1.CDUTRIG 2.CALCSMSC 3.CALCGA

		SETLOC	P50S2
		BANK
		COUNT*	$$/R51
CALCSMSC	DLOAD	DMP
			SINCDUY
			COSCDUZ
		DCOMP
		PDDL	SR1
			SINCDUZ
		PDDL	DMP
			COSCDUY
			COSCDUZ
		VDEF	VSL1
		STODL	XNB
			SINCDUX
		DMP	SL1
			SINCDUZ
		STORE	26D
		DMP	PDDL
			SINCDUY
			COSCDUX
		DMP	DSU
			COSCDUY
		PDDL	DMP
			SINCDUX
			COSCDUZ
		DCOMP	PDDL	
			COSCDUX
		DMP	PDDL
			SINCDUY
			COSCDUY
		DMP	DAD
			26D
		VDEF	VSL1
		STORE	ZNB
		VXV	VSL1
			XNB
		STORE	YNB
		RVQ

# PROGRAM NAME - P51 - IMU ORIENTATION DETERMINATION		DATE - AUGUST 1,1969
# MODIFICATION BY ALBERT,BARNERT,HASLAM				LOG SECTION - P51-P5
#
# FUNCTION -
#
# DETERMINES THE INERTIAL ORIENTATION OF THE IMU. THE PROGRAM IS SELECTED BY DSKY ENTRY. THE SIGHTING
# ROUTINE IS CALLED TO COLLECT THE CDU COUNTERS AND SHAFT AND TRUNNION ANGLES FOR A SIGHTED STAR. THE DATA IS
# THEN PROCESSED AS FOLLOWS.
#
#	1. SEXTANT ANGLES ARE COMPUTED IN TERMS OF NAVIGATIONAL BASE COORDINATES. LET SA AND TA BE THE SHAFT AND
#	TRUNNION ANGLES, RESPECTIVELY. THEN,
#		-
#		V  = (SIN(TA)*COS(SA), SIN(TA)*SIN(SA), COS(TA))	(A COLUMN VECTOR)
#       	 NB
#	THE OUTPUT IS A HALF-UNIT VECTOR STORED IN STARM.
#
#	2. THIS VECTOR IN NAV. BASE COORDS. IS THEN TRANSFORMED TO ONE IN STABLE MEMBER COORDINATES.
#
#		-    T  T  T -
#		V = Q *Q *Q *V  , WHERE
#		     1  2  3  NB
#
#		     ( COS(IG)	 0    -SIN(IG) )
#		     (			       )				THE GIMBAL ANGLES ARE COMPUTED FROM
#		Q  = (   0	 1  	 0     ), IG= INNER GIMBAL ANGLE	THE CDU COUNTERS AT NBSM (USING AXIS-
#		 1   (			       )				ROT AND CDULOGIC)
#		     ( SIN(IG)	 0     COS(IG) )
#
#
#		     ( COS(MG) SIN(MG)   0     )
#		     (			       )
#		Q  = (-SIN(MG) COS(MG)   0     ), MG= MIDDLE GIMBAL ANGLE
#		 2   (                         )
#		     (   0       0       1     )
#
#
#		     (   1       0       0     )
#		     (                         )
#		Q  = (   0     COS(OG) SIN(OG) ), OG= OUTER GIMBAL ANGLE
#		 3   (                         )
#		     (   0    -SIN(OG) COS(OG) )
#
#	3. THE STAR NUMBER IS SAVED AND THE SECOND STAR IS THEN SIMILARLY PROCESSED.
#
#	4. THE ANGLE BETWEEN THE TWO STARS IS THEN CHECKED AT CKSDATA.
#
#	5. REFSMMAT IS THEN COMPUTED AT AXISGEN AS FOLLOWS.
#		    -      -
#	   LET S  AND S  BE TWO STAR VECTORS EXPRESSED IN TWO COORDINATE SYSTEMS, A AND B (BASIC AND STABLE MEMBER).
#		     1      2
#
#     DEFINE,	-    -
#		U  = S
#		 A    A1
#
#		-         -    -
#		V  = UNIT(S  X S  )
#		 A         A1   A2
#
#		-    -   -
#		W  = U X V
#		 A    A   A
#
#	  AND
#		-    -
#		U  = S
#		 B    B1
#
#		-         -    -
#		V  = UNIT(S  X S  )
#		 B         B1   B2
#
#		-    -   -
#		W  = U X V
#		 B    B   B
#
#	 THEN	-        -       -       -
#		X  = U  *U + V  *V + W  *W
#		      B1  A   B1  A   B1  A
#
#		-        -       -       -		(REFSMMAT)
#		Y  = U  *U + V  *V + W  *W
#		      B2  A   B2  A   B2  A
#
#		-        -       -       -
#		Z  = U  *U + V  *V + W  *W
#		      B3  A   B3  A   B3  A
#
# 	   THE INPUTS CONSIST OF THE FOUR HALF-UNIT VECTORS STORED AS FOLLOWS
#		-
#		S   IN 6-11 OF THE VAC AREA
#		 A1
#
#		-
#		S   IN 12-17 OF THE VAC AREA
#		 A2
#
#		-
#		S   IN STARAD
#		 B1
#
#		-
#		S   IN STARAD +6
#		 B2
#
# CALLING SEQUENCE
#
#	THE PROGRAM IS CALLED BY THE ASTRONAUT BY DSKY ENTRY.
#
# SUBROUTINES CALLED.
#
#	GOPERF3
#	GOPERF1R
#	GODSPR
#	IMUCOARS
#	IMUFIN20
#	R53
#	SXTNB
#	NBSM
#	MKRELEAS
#	CHKSDATA
#	MATMOVE
#
# ALARMS
#
#	NONE.
#
# ERASABLE INITIALIZATION
#
#	IMU ZERO FLAG SHOULD BE SET.
#
# OUTPUT
#
#	REFSMMAT
#	REFSMFLG
#
# DEBRIS
#
#	WORK AREA
#	STARAD
#	STARIND
#	BESTI
#	BESTJ

		SETLOC	P50S1
		BANK
		COUNT*	$$/P5153
P53		EQUALS	P51		
P51		CS	IMODES30
		MASK	IMUOPBIT
		CCS	A
		TC	P51A
		TC	ALARM
		OCT	210
		TC	GOTOPOOH
P51A		TC	BANKCALL
		CADR	R02ZERO

P51AA		CAF	PRFMSTAQ
		TC	BANKCALL
		CADR	GOPERF1
		TC	GOTOPOOH	# TERM.
		TC	P51B		# V 33
		TC	PHASCHNG
		OCT	05024
		OCT	13000
		CAF	P51ZERO
		TS	THETAD		# ZERO THE GIMBALS
		TS	THETAD +1
		TS	THETAD +2
		CAF	V06N22
		TC	BANKCALL
		CADR	GODSPRET
		CAF	V41K		# NOW DISPLAY COARSE ALIGN VERB 41
		TC	BANKCALL
		CADR	GODSPRET
		TC	COARSUB		# PERFORM ALIGNMENT
		TC	PHASCHNG
		OCT	05024
		OCT	13000
		TCF	P51AA		# COARSE ALIGN DONE - RECYCLE FOR FINE


#    DO STAR SIGHTING AND COMPUTE NEW REFSMMAT

P51B		TC	E7SETTER
		TC	INTPRET
		SSP	SETPD
			STARIND		# INDEX - STAR 1 OR 2
			0
			0
		RTB	VLOAD
			SET1/PDT
			ZEROVEC
		STORE	GCOMP
		SET	EXIT
			DRIFTFLG	# ENABLE T4 COMPENSATION
P51C		TC	PHASCHNG
		OCT	05024
		OCT	13000
		TC	CHECKMM
		MM	53		# BACKUP PROGRAM
		TCF	P51C.1		# NOT P53
		TC	INTPRET
		CALL
			R56
		GOTO
			P51C.2
P51C.1		TC	INTPRET
		CALL
			R53		# SIGHTING ROUTINE
P51C.2		CALL			# COMPUTE LOS IN SM FROM MARK DATA
			SXTSM
		PUSH
		SLOAD	BZE
			STARIND
			P51D
		VLOAD	STADR
		STCALL	STARSAV2	# DOWNLINK
			P51E
P51D		VLOAD	STADR
		STODL	STARSAV1
			TSIGHT
		CALL
			PLANET
		STORE	PLANVEC
P51E		EXIT
		TC	PHASCHNG
		OCT	05024
		OCT	13000
		CCS	STARIND
		TCF	P51F		# STAR 2
		TC	PHASCHNG
		OCT	05024
		OCT	13000
		CAF	BIT1
		TS	STARIND
		TCF	P51C		# GO DO SECOND STAR
P51F		TC	PHASCHNG
		OCT	05024
		OCT	13000
		TC	INTPRET
		DLOAD	CALL
			TSIGHT
			PLANET
		STOVL	12D
			PLANVEC
		STOVL	6D
			STARSAV1
		STOVL	STARAD
			STARSAV2
		STCALL	STARAD +6
			CHKSDATA	# CHECK STAR ANGLES IN STARAD AND
		BON	EXIT
			FREEFLAG
			P51G
		CAF	EBANK5
		TS	EBANK
		TC	P51AA
		SETLOC	P50S4
		BANK

		COUNT*	$$/P5153
P51G		CALL
			AXISGEN		# COME BACK WITH REFSMMAT IN XDC
		AXC,1	AXC,2
			XDC
			REFSMMAT
		CLEAR	CALL
			REFSMFLG
			MATMOVE
		SET	EXIT
			REFSMFLG
		TC	GOTOPOOH
		SETLOC	P50S1
		BANK

		COUNT*	$$/P5153
PRFMSTAQ	=	OCT15
P51ZERO		=	ZERO
P51FIVE		=	FIVE
V41K		VN	4100
SET1/PDT	CA	TIME1
		TS	1/PIPADT
		TCF	DANZIG
		
# SXTSM COMPUTES AN LOS VECTOR IN SM COORD FROM OCDU AND ICDU MARK DATA

		SETLOC	P50S3
		BANK
		COUNT*	$$/R51
SXTSM		SET	DLOAD
			ATMFLAG
			MRKBUF1
		STORE	TSIGHT
		AXC,1
			MRKBUF1		# ADDRESS OF MARK DATA FOR P50'S
SXTSM1		STQ			# CALLED HERE FROM GETUM (P20 AND P22)
			QMAJ
		LXC,2	SLOAD*
			STARIND
			MKDNCDR,2
		LXC,2	VLOAD*
			MPAC
			0,1
		STORE	0,2
		DLOAD*
			5,1
		STORE	5,2
SXTSM2		VLOAD*
			2,1
		STCALL	CDUSPOT
			SXTNB
		CALL
			TRG*NBSM	# TRANSFER LOS TO SM
		STCALL	32D
			QMAJ
MKDNCDR		ECADR	MARKDOWN
		ECADR	MARK2DWN

# NAME - R53 - SIGHTING MARK ROUTINE
#
# FUNCTION -
#  TO PERFORM A SATISFACTORY NUMBER OF SIGHTING MARKS FOR THE REQUESTING PROGRAM (OR ROUTINE). SIGHTINGS
#  CAN BE MADE ON A STAR OR LANDMARK. WHEN THE CMC ACCEPTS A MARK IT RECORDS AND STORES 5 ANGLES (3 ICDUS AND 2
#  OCDUS) AND THE TIME OF THE MARK.
#
# CALLING SEQUENCE
#  R53 IS CALLED AND RETURNS IN INTERPRETIVE CODE. RETURN IS VIA QPRET.
#  THERE IS NO ERROR EXIT IN THIS ROUTINE ITSELF.
#
# SUBROUTINES CALLED	
#  SXTMARK
#  OPTSTALL
#  GOFLASH
#
# ERASABLE INITIALIZATION
#  TARGET FLAG - STAR OR LANDMARK
#  MARKINDX - NUMBER OF MARKS WANTED
#  STARIND - INDEX TO BESTI OR BESTJ (STAR NUMBER)
#
# OUTPUT
#  MARKSTAT CONTAINS INDEX TO VACANT AREA WHERE MARK DATA IS STORED
#  BESTI (INDEXED BY STARIND) CONTAINS STAR NUMBER SIGHTED
#
# DEBRIS
#  MARKINDX CONTAINS NUMBER OF MARKS DESIRED

		SETLOC	RT53
		BANK

		COUNT*	$$/R53
R53		STQ	SET		# SET SIGHTING MARK FLAG
			R53EXIT
			R53FLAG
		EXIT
R53A		TC	BANKCALL
		CADR	SXTMARK
		CCS	MARKINDX
		TCF	R53A		# NO MARKS TAKEN.  DO AGAIN.
R53A1		TC	BANKCALL
		CADR	MKRELEAS
R53C1		CAF	ZERO
		TC	BANKCALL
		CADR	CLEANDSP		
R53B		CS	BIT6		# CUT BETWEEN P20S AND P50S
		AD	MODREG		# P22,P23 CALL		
		EXTEND
		BZMF	R53D		# YES
		CS	FLAGWRD0
		MASK	P50.1BIT
		EXTEND
		BZF	R53D
R53C		CAF	V01N71
		TC	VNFLASH
R53Z		TC	CHKSCODE
# ROUTINE TO ALLOW ONLY +0 <= STARCODE <= +50, OTHERWISE 'OPERATOR ERROR'
		TC	FALTON
		TC	R53C
		TC	STORIJ		# SET BESTI(BESTJ) = 1ST(2ND) STARCODE
		TC	CHECKMM
		MM	50
		TCF	+2
		TCF	R53DISP
		CAF	BIT8
		MASK	STARCODE
		EXTEND
		BZF	R53D
R53DISP		CAF	V06N14
		TC	VNFLASH
		CA	TRKAZ
		DOUBLE
		TS	MRKBUF1 +3
		TCF	+2
		TC	UNK4614
		CA	TRKEL
		DOUBLE
		TS	MRKBUF1 +5
		TCF	R53D
		TC	UNK4614
R53D		TC	INTPRET
R53OUT		SETGO
			TERMIFLG	# SET TERMINATE FOR R52
			R53EXIT
SIGHTSIX	=	SIX
V01N71		VN	0171
V06N14		VN	0614

		SETLOC	FFTAG5
		BANK

UNK4614		TC	FALTON
		TC	R53DISP

		SETLOC	RT53
		BANK

# ****** KEEP IN SAME BANK AS R51 AND R53 *********
CHKSCODE	CS	STARCODE
		MASK	BIT15
		EXTEND			# NEGATIVE STARCODE OF ANY
		BZF	TCQ		# MAGNITUDE IS IMPROPER
		CS	HIGH9
		MASK	STARCODE
		AD	NEG47
		EXTEND
		BZMF	+2		# <= 50, OK
		TC	Q		# > 50, IMPROPER
		CAF	BIT7
		MASK	STARCODE
		EXTEND
		BZF	Q+2
		CA	STARCODE
		AD	NEG146
		EXTEND
		BZF	Q+2
		TC	Q
NEG47		OCT	77730
NEG146		OCT	77631

# NAME - S52.2
# FUNCTION - COMPUTE GIMBAL ANGLES FOR DESIRED SM AND PRESENT VEHICLE
# CALL - CALL S52.2
# INPUT - X,Y,ZSMD
# OUTPUT - OGC,IGC,MGC,THETAD,+1,+2
# SUBROUTINES - CDUTRIG, CALCSMSC, MATMOVE, CALCGA

		SETLOC	S52/2
		BANK

		COUNT*	$$/S52.2
S52.2		STQ	CALL
			QMAJ
			CDUTRIG
		CALL
			CALCSMSC
		AXT,1	SSP
			18D
			S1
			6D
S52.2A		VLOAD*	VXM
			XNB +18D,1
			REFSMMAT
		UNIT
		STORE	XNB +18D,1
		TIX,1
			S52.2A
S52.2.1		AXC,1	AXC,2
			XSMD
			XSM
		CALL
			MATMOVE
		CALL
			CALCGA
		GOTO
			QMAJ


# NAME - R56 - ALTERNATE LOS SIGHTING MARK ROUTINE
#
# FUNCTIONAL DESCRIPTION
# TO PERFORM SIGHTING MARKS FOR THE BACK-UP ALIGNMENT PROGRAMS (P53,P54).  THE ASTRONAUT KNOWS THE
# COORDINATES (OPTICS) OF THE ALTERNATE LINE OF SIGHT HE MUST USE FOR THIS ROUTINE.  WHEN THE ASTRONAUT KEYS IN
# ENTER IN RESPONSE TO THE FLASHING V50 N25 R1-XXXXX THE CMC STORES THE THREE ICDU ANGLES AND TWO ANGLES DISPLAYED
# IN N92.
#
# CALLING SEQUENCE
#	CALL
#		R56
#
# SUBROUTINES CALLED
#	A PORTION OF SXTMARK (VAC.AREA SEARCH)
#	GOFLASH
#	GOPERF1
#
# ERASABLE INITIALIZATION
#	STARIND - INDEX TO STAR NUMBER
#
# OUTPUT
#	MARKSTAT - INDEX TO VAC.AREA WHERE OUTPUT IS STORED.
#	BESTI (INDEXED BY STARIND) CONTAINS STAR NUMBER.
#	ICDU AND OCDU ANGLES IN VAC. AREA AS FOLLOWS-
#		VAC +2	CDUY
#		VAC +3	CDUS
#		VAC +4	CDUZ
#		VAC +5	CDUT
#		VAC +6	CDUX

		SETLOC	P50S3
		BANK
		COUNT*	$$/R56
R56		STQ	EXIT
			R53EXIT
		CAF	V06N94B
		TC	VNFLASH
R56A		TC	BANKCALL
		CADR	TESTMARK

		CAF	ZERO
		TC	BANKCALL
		CADR	CLEANDSP

R56A1		CAF	VB53		# DISPLAY V53 REQUESTING ALTERNATE MARK
		TC	BANKCALL
		CADR	GOMARK2
		TCF	GOTOPOOH	# V34-TERMINATE
		TCF	R56A1		# V33-DONT PROCEED-JUST ENTER TO MARK
		TC	INTPRET
		DLOAD
			MRKBUF1 +3
		STODL	SAC
			MRKBUF1 +5
		STORE	PAC
		EXIT
		INHINT
		TC	E7SETTER

		EBANK=	MRKBUF1
		EXTEND
		DCA	TIME2
		DXCH	MRKBUF1
		CA	CDUY		# ENTER-THIS IS A BACKUP SYSTEM MARK
		TS	MRKBUF1 +2
		CA	CDUZ
		TS	MRKBUF1 +4
		CA	CDUX
		TS	MRKBUF1 +6
		RELINT
		CAF	EBANK5		# MAY NOT NEED TO DO THIS
		TS	EBANK

		EBANK=	QMIN

		TC	CLEARMRK	# ENABLE EXTENDED VERBS
		CAF	OCT16
		TC	BANKCALL
		CADR	GOPERF1
		TC	GOTOPOOH	# TERM.
		TCF	R56B		# PROCEED-MARK COMPLETED
		TCF	R56A		# RECYCLE - DO ANOTHER MARK - LIKE REJECT
R56B		TC	BANKCALL
		CADR	R53C1
VB53		VN	05300		# ALTERNATE MARK VERB
V06N94B		VN	00694
		SETLOC	P50S1
		BANK

		COUNT*	$$/PLNET
PLANET		STORE	TSIGHT
		STQ	CALL
			QMIN
			LOCSAM
NOSAM		EXIT
		TC	STORIJ		# SET BESTI(BESTJ) = 1ST(2ND) STARCODE
		CCS	A
		TCF	NOTPLAN
		CAF	VNPLANV
		TC	VNFLASH
		TC	INTPRET
		VLOAD	VXSC
			STARSAV3
			1/SQR3
		UNIT	GOTO
			CORPLAN
NOTPLAN		CS	A
		AD	DEC227
		EXTEND
		BZMF	CALSAM1
		INDEX	STARIND
		CA	BESTI
		INDEX	FIXLOC
		TS	X1
		TC	INTPRET
		VLOAD*	GOTO
			CATLOG,1
			CORPLAN
CALSAM1		TC	INTPRET
		LXC,1	DLOAD*
			STARIND
			BESTI,1
		LXC,1	VLOAD*
			MPAC
			STARAD -228D,1
CORPLAN		VAD	UNIT
			VEL/C
		GOTO
			QMIN
DEC227		DEC	227
VNPLANV		=	V06N88
1/SQR3		2DEC	.57735021

STORIJ		CS	HIGH9		# CALLED AT R53Z, NOSAM(PLANET)
		MASK	STARCODE
		EXTEND
		MP	SIGHTSIX
		XCH	L
		INDEX	STARIND
		TS	BESTI
		TC	Q		# RETURN TO CALLER
		COUNT*	$$/R50
COARSUB		CA	Q
		TS	QMIN
STALLOOP	CA	MODECADR	# IS IMU IN USE?
		EXTEND
		BZF	CORSCALL	# NO, GO AHEAD WITH COARSE ALIGN
		CAF	1SEC		# YES, SO WAIT A SEC
		TC	BANKCALL
		CADR	DELAYJOB
		TC	STALLOOP	# 			AND TRY AGAIN
CORSCALL	TC	BANKCALL
		CADR	IMUCOARS	# PERFORM COARSE ALIGN
		TC	BANKCALL
		CADR	IMUSTALL
		TC	217ALARM	# BAD END
		TC	BANKCALL
		CADR	IMUFIN20	# PERFORM FINE ALIGN
		TC	BANKCALL
		CADR	IMUSTALL
		TC	217ALARM	# BAD END
		TC	QMIN
217ALARM	INHINT			# JUST LIKE 'CURTAINS', NOW DEPARTED
		CA	Q
		TC	ALARM2
		OCT	00217
		TC	ALMCADR		# RETURN TO USER
