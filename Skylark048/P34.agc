### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	P34.agc
## Purpose:	A section of Skylark revision 048.
##		It is part of the source code for the Apollo Guidance Computer
##		(AGC) for Skylab-2, Skylab-3, Skylab-4, and ASTP. No original
##		listings of this software are available; instead, this file was
##		created via disassembly of the core rope modules actually flown
##		on Skylab-2.
## Assembler:	yaYUL
## Contact:	Ron Burkey <info@sandroid.org>.
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2024-02-18 MAS  Created.


# CONSTANT DELTA HEIGHT (CDH) PROGRAMS (P33 AND P73)
# MOD NO -1		LOG SECTION - P32-P35, P72-P75
# MOD BY WHITE.P	DATE  1 JUNE 67
#
# PURPOSE
#
#	(1) TO CALCULATE PARAMETERS ASSOCIATED WITH THE CONSTANT DELTA
#	    ALTITUDE MANEUVER (CDH).
#
#	(2) TO CALCULATE THESE PARAMETERS BASED UPON MANEUVER DATA
#	    APPROVED AND KEYED INTO THE DSKY BY THE ASTRONAUT.
#
#	(3) TO DISPLAY TO THE ASTRONAUT AND THE GROUND DEPENDENT VARIABLES
#	    ASSOCIATED WITH THE CDH MANEUVER FOR APPROVAL BY THE
#	    ASTRONAUT/GROUND.
#
#	(4) TO STORE THE CDH TARGET PARAMETERS FOR USE BY THE DESIRED
#	    THRUSTING PROGRAM.
#
# ASSUMPTIONS
#
#	(1) THIS PROGRAM IS BASED UPON PREVIOUS COMPLETION OF THE
#	    CO-ELLIPTIC SEQUENCE INITIATION (CSI) PROGRAM (P32/P72).
#	    THERFORE -
#
#		(A) AT A SELECTED TPI TIME (NOW IN STORAGE) THE LINE OF SIGHT
#		    BETWEEN THE ACTIVE AND PASSIVE VEHICLES WAS SELECTED TO BE
#		    A PRESCRIBED ANGLE (E) (NOW IN STORAGE) FROM THE
#		    HORIZONTAL PLANE DEFINED BY THE ACTIVE VEHICLE POSITION.
#
#		(B) THE TIME BETWEEN CSI IGNITION AND CDH IGNITION WAS
#		    COMPUTED TO BE GREATER THAN 10 MINUTES.
#
#		(C) THE TIME BETWEEN CDH IGNITION AND TPI IGNITION WAS
#		    COMPUTED TO BE GREATER THAN 10 MINUTES.
#
#		(D) THE VARIATION OF THE ALTITUDE DIFFERENCE BETWEEN THE
#		    ORBITS WAS MINMIZED.
#
#		(E) CSI BURN WAS DEFINED SUCH THAT THE IMPULSIVE DELTA V WAS
#		    IN THE HORIZONTAL PLANE DEFINED BY ACTIVE VEHICLE
#		    POSITION AT CSI IGNITION.
#
#		(F) THE PERICENTER ALTITUDES OF THE ORBITS FOLLOWING CSI AND
#		    CDH WERE COMPUTED TO BE GREATER THAN 35,000 FT FOR LUNAR
#		    ORBIT OR 85 NM FOR EARTH ORBIT.
#
#		(G) THE CSI AND CDH MANEUVERS WERE ASSUMED TO BE PARALLEL TO
#		    THE PLANE OF THE PASSIVE VEHICLE ORBIT.  HOWEVER, CREW
#		    MODIFICATION OF DELTA V (LV) COMPONENTS MAY HAVE RESULTED
#		    IN AN OUT-OF-PLANE MANEUVER.
#
#	(2) STATE VECTOR UPDATES BY P27 ARE DISALLOWED DURING AUTOMATIC
#	    STATE VECTOR UPDATING INITIATED BY P20 (SEE ASSUMPTION 4).
#
#	(3) COMPUTED VARIABLES MAY BE STORED FOR LATER VERIFICATION BY
#	    THE GROUND.  THESE STORAGE CAPABILITES ARE NORMALLY LIMITED
#	    ONLY TO THE PARAMETERS FOR ONE THRUSTING MANEUVER AT A TIME
#	    EXCEPT FOR CONCENTRIC FLIGHT PLAN MANEUVER SEQUENCES.
#
#	(4) THE RENDEZVOUS RADAR MAY OR MAY NOT BE USED TO UPDATE THE LM
#	    OR CSM STATE VECTORS FOR THIS PROGRAM.  IF RADAR USE IS
#	    DESIRED THE RADAR WAS TURNED ON AND LOCKED ON THE CSM BY
#	    PREVIOUS SELECTION OF P20.  RADAR SIGHTING MARKS WILL BE MADE
#	    AUTOMATICALLY APPROXIMATELY ONCE A MINUTE WHEN ENABLED BY THE
#	    TRACK AND UPDATE FLAGS (SEE P20).  THE RENDEZVOUS TRACKING
#	    MARK COUNTER IS ZEROED BY THE SELECTION OF P20 AND AFTER EACH
#	    THRUSTING MANEUVER.
#
#	(5) THE ISS NEED NOT BE ON TO COMPLETE THIS PROGRAM.
#
#	(6) THE OPERATION OF THE PROGRAM UTILIZES THE FOLLOWING FLAGS -
#
#		ACTIVE VEGICLE FLAG - DESIGNATES THE VEHICLE WHICH IS
#		DOING RENDEZVOUS THRUSTING MANEUVERS TO THE PROGRAM WHICH
#		CALCULATES THE MANEUVER PARAMETERS.  SET AT THE START OF
#		EACH RENDEZVOUS PRE-THRUSTING PROGRAM.
#
#		FINAL FLAG - SELECTS FINAL PROGRAM DISPLAYS AFTER CREW HAS
#		COMPLETED THE FINAL MANEUVER COMPUTATION AND DISPLAY
#		CYCLE.
#
#		EXTERNAL DELTA V STEERING FLAG - DESIGNATES THE TYPE OF
#		STEERING REQUIRED FOR EXECUTION OF THIS MANEUVER BY THE
#		THRUSTING PROGRAM SELECTED AFTER COMPLETION OF THIS
#		PROGRAM.
#
#	(7) IT IS NORMALLY REQUIRED THAT THE ISS BE ON FOR 1 HOUR PRIOR TO
#	    A THRUSTING MANEUVER.
#
#	(8) THIS PROGRAM IS SELECTED BY THE ASTRONAUT BY DSKY ENTRY -
#
#		P33 IF THIS VEHICLE IS ACTIVE VEHICLE.
#
#		P73 IF THIS VEHICLE IS PASSIVE VEHICLE.
#
# INPUT
#
#	(1) TTPI0	TIME OF THE TPI MANEUVER - SAVED FROM P32/P72
#	(2) ELEV	DESIRED LOS ANGLE AT TPI - SAVED FROM P32/P72
#	(3) TCDH	TIME OF THE CDH MANEUVER
#
# OUTPUT
#
#	(1) TRKMKCNT	NUMBER OF MARKS
#	(2) TTOGO	TIME TO GO
#	(3) +MGA	MIDDLE GIMBAL ANGLE
#	(4) DIFFALT	DELTA ALTITUDE AT CDH
#	(5) T2TOT3	DELTA TIME FROM CDH TO COMPUTED TPI
#	(6) NOMTPI	DELTA TIME FROM NOMINAL TPI TO COMPUTED TPI
#	(7) DELVLVC	DELTA VELOCITY AT CDH - LOCAL VERTICAL COORDINATES
#
# DOWNLINK
#
#	(1) TCDH	TIME OF THE CDH MANEUVER
#	(2) TTPI	TIME OF THE TPI MANEUVER
#	(3) TIG		TIME OF THE CDH MANEUVER
#	(4) DELVEET2	DELTA VELOCITY AT CDH - REFERENCE COORDINATES
#	(5) DIFFALT	DELTA ALTITUDE AT CDH
#	(6) ELEV	DESIRED LOS ANGLE AT TPI
#
# COMMUNICATION TO THRUSTING PROGRAMS
#
#	(1) TIG		TIME OF THE CDH MANEUVER
#	(2) RTIG	POSITION OF ACTIVE VEHICLE AT CDH - BEFORE ROTATION
#			INTO PLANE OF PASSIVE VEHICLE
#	(3) VTIG	VELOCITY OF ACTIVE VEHICLE AT CDH - BEFORE ROTATION
#			INTO PLANE OF PASSIVE VEHICLE
#	(4) DELVSIN	DELTA VELOCITY AT CDH - REFERENCE COORDINATES
#	(5) DELVSAB	MAGNITUDE OF DELTA VELOCITY AT CDH
#	(6) XDELVFLG	SET TO INDICATE EXTERNAL DELTA V VG COMPUTATION
#
# SUBROUTINES USED
#
#	P20FLGON
#	VNPOOH
#	SELECTMU
#	ADVANCE
#	CDHMVR
#	INTINT3P
#	ACTIVE
#	PASSIVE
#	S33/34.1
#	ALARM
#	BANKCALL
#	GOFLASH
#	GOTOPOOH
#	S32/33.1
#	VN1645

		SETLOC	CSI/CDH1
		BANK
		EBANK=	SUBEXIT
		COUNT*	$$/P3373
P34		TC	P20FLGON
		CAF	V06N13		# TCDH
		TC	VNFLASH
		TC	INTPRET
		DLOAD	CLEAR
			TTPI
			FINALFLG
		STODL	TTPI0
			TCDH
		STCALL	TIG
			VN1645
P33/P73B	DLOAD	CALL
			TIG
			ADVANCE
		CALL
			CDHMVR
		STORE	DELVEET1	# CDH DV TO USE DISDVLVC SUB FOR N81 DISP
		SETPD	VLOAD
			0D
			VACT3
		PDVL	CALL
			RACT2
			INTINT3P
		CALL
			ACTIVE
		SETPD	VLOAD
			0D
			VPASS2
		PDVL	CALL
			RPASS2
			INTINT3P
		CALL
			PASSIVE
		DLOAD	SET
			ZEROVECS
			ITSWICH
		STCALL	NOMTPI
			S33/34.1
		BZE	EXIT
			P33/P73C
		TC	ALARM
		OCT	611
		CAF	V05N09
		TC	BANKCALL
		CADR	GOFLASH
		TC	GOTOPOOH
		TC	+2
		TC	P34
		TC	INTPRET
		DLOAD
			ZEROVECS
		STORE	NOMTPI
P33/P73C	BON	SET
			FINALFLG
			P33/P73D
			UPDATFLG
P33/P73D	DLOAD	DAD
			NOMTPI
			TTPI
		STORE	TTPI
		DSU
			TCDH
P33/P73E	DSU	BPL
			60MIN
			P33/P73E
		DAD
			60MIN
		STCALL	T1TOT2
			U27,2566
		EXIT	

		CAF	V06N75
		TC	VNFLASH
		TC	INTPRET
SKIP75		CALL
			DISDVLVC	# PUT UP N81, COMPUTE DELVSIN
		CALL
			VN1645
		GOTO
			P33/P73B

## FIXME MOVE?
60MIN		2DEC	360000


		SETLOC	FFTAG12
		BANK

		COUNT*	$$/P3272
V06N11		VN	0611
V06N13		VN	0613
V06N75		VN	0675


# ..... DISDVLVC  .....
#
# SUBROUTINES USED
#
#	S32/33.X
#	VNPOOH

		SETLOC	CDHTAG3
		BANK

		COUNT*	$$/CSI
DISDVLVC	STQ	CALL
			NORMEX
			S32/33.X
		VLOAD	MXV
			DELVEET1
			0D
		VSL1
		STCALL	DELVLVC		# REF TO L V
			DISPN90
		CALL
			S32/33.X
		VLOAD	VXM
			DELVLVC
			0D
		VSL1
		STCALL	DELVSIN		# L V TO REF
			NORMEX

# ..... ADVANCE   .....
#
# SUBROUTINES USED
#	PRECSET
#	ROTATE

		SETLOC	CDHTAG3
		BANK

		COUNT*	$$/CDH
ADVANCE		STQ
			SUBEXIT
		STCALL	TDEC1
			PRECSET
		SET	VLOAD
			XDELVFLG
			VPASS3
		STOVL	VPASS2
			RPASS3
		STOVL	RPASS2
			RACT3
		STCALL	RTIG
			ROTATE
		STOVL	RACT2
			VACT3
		STCALL	VTIG
			ROTATE
		STCALL	VACT2
			SUBEXIT

# ..... ROTATE    .....

		SETLOC	CSIPROG6
		BANK

		COUNT*	$$/CSI
ROTATE		PUSH	PUSH
		DOT	VXSC
			UP1
			UP1
		VSL2	BVSU
		UNIT	PDVL
		ABVAL	VXSC
		VSL1	RVQ

# .... DISPN90 .....

		SETLOC CSIPROG
		BANK
		COUNT*	$$/CSI
DISPN90		STQ
			ANEXIT
		VLOAD	VCOMP
			AUTOY
		STODL	YCSM		# COMPLEMENT VALUES FOR N90 DISPLAYS.
			CMYDOT
		STORE	DELVLVC +2
		BOFF	ABS
			PCFLAG
			OKN81		# NOT IN P36
		DSU	BPL		# IS YDOT LESS THAN .1 FPS
			1/10FPS
			OKN81		# NO
		VLOAD			# YES - FORCE DSKY DISPLAY TO BE 0
			ZEROVEC
		STORE	DELVLVC
OKN81		EXIT

		CAF	V06N81
		TC	VNFLASH

		TC	INTPRET
		GOTO
			ANEXIT

1/10FPS		2DEC	.0003048 B-7	# .1 FPS

# ..... INTINTNA  .....

		SETLOC	CDHTAG2
		BANK

		COUNT*	$$/CDH
INTINT3P	PDDL	PDDL
			TCDH
			TTPI
		PDDL	PUSH
			TWOPI		# FOR CONIC INTEGRATION
		GOTO
			INTINT

# ..... S32/33.X  .....

		SETLOC	CDHTAGS
		BANK

		COUNT*	$$/CDH
S32/33.X	SETPD	VLOAD
			6D
			UP1
		VCOMP	PDVL
			RACT2
		UNIT	VCOMP
		PUSH	VXV
			UP1
		VSL1
		STORE	0D
		RVQ

		SETLOC	CDHTAG
		BANK

		COUNT*	$$/CDH

## FIXME NEW, PLACEMENT
U27,2566	DLOAD	DSU
			TTPI
			TTPI0
		PUSH
P33/P73F	ABS	DSU
			60MINH
		BPL	DAD
			P33/P73F
			60MINH
		SIGN	STADR
		STORE	T2TOT3
		RVQ


# ..... CDHMVR    .....
#
# SUBROUTINES USED
#	TIMETHET


CDHMVR		STQ	VLOAD
			SUBEXIT
			RACT2
		PUSH	UNIT
		STOVL	UNVEC		# UR SUB A
			RPASS2
		UNIT	DOT
			UNVEC
		PUSH	SL1
		STODL	CSTH
		DSQ	PDDL
			DP1/4TH
		SR2	DSU
		SQRT	SL1
		PDVL	VCOMP
		VXV
			RPASS2
		DOT	PDDL
			UP1
		SIGN	STADR
		STOVL	SNTH
			RPASS2
		STOVL	RVEC
			VPASS2
		CLEAR
			RVSW
		STCALL	VVEC
			TIMETHET
		STORE	18D
		DOT	SL1R
			UNVEC
		PDVL	ABVAL		# 0D = V SUB PV
		PDVL
			RACT2
		ABVAL	PDDL		# 2D = LENGTH OF R SUB A
		DSU
			02D
		STODL	DIFFALT		# DELTA H IN METERS		B+29
			R1A
		NORM	PDDL		# 2 - R V**/MU				04D
			X1
			R1
		SR1R	DDV
		SL*	PUSH
			0 -5,1
		DSU	PDDL		# A SUB A			B+29 	04D
			DIFFALT
		SR2	DDV		# A SUB P			B+31
			04D		#				B+2
		PUSH	SQRT		# A SUB P/A SUB A			06D
		DMPR	DMP
			06D
			00D
		SL3R	PDDL		# V SUB AV METERS/CS		B+7 	08D
			02D		# R SUB A MAGNITUDE		B+29
		NORM	PDDL
			X1
			RTMU
		SR1	DDV		# 2MU 				B+38
		SL*	PDDL		# 2 MU/R SUBAA			B+14 	10D
			0 -5,1
			04D		# ASUBA				B+29
		NORM	PDDL
			X2
			RTMU
		SR1	DDV
		SL*	BDSU
			0 -6,2		# 2U/R - U/A	 B+14  (METERS/CS)SQ
		PDDL	DSQ		#					10D
			08D
		BDSU	SQRT
		PDVL	VXV		# SQRT(MU(2/R SUB A-1/A SUB A)-VSUBA2)	10D
			UP1
			UNVEC
		UNIT	VXSC
			10D
		PDVL	VXSC
			UNVEC
			08D
		VAD	VSL1
		STADR
		STORE	VACT3
		VSU
			VACT2
		STCALL	DELVEET2	# DELTA VCDH - REFERENCE COORDINATES
			SUBEXIT

RTMU		2DEC*	3.986032 E10 B-36*