### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	RCS-CSM_DIGITAL_AUTOPILOT.agc
## Purpose:	Part of the source code for Artemis (i.e., Colossus 3),
##		build 072.  This is for the Command Module's (CM) 
##		Apollo Guidance Computer (AGC), for 
##		Apollo 15-17.
## Assembler:	yaYUL
## Contact:	Sergio Navarro <sergionavarrog@gmail.com>
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2009-08-27 SN	Adapted from corresponding Comanche 055 file.
## 		2009-09-04 JL	Fixed typos. Fixed page comment.
## 		2009-09-10 JL	Fixed typos.
## 		2010-02-01 JL	Fixed build errors.
##		2010-02-20 RSB	Un-##'d this header.
##		2017-02-08 RSB	Proofed comment text by diff'ing vs Comanche 55
##				and/or octopus/ProoferComments as most-appropriate.


# T5 INTERRUPT PROGRAM FOR THE RCS-CSM AUTOPILOT
# 	START OF T5 INTERRUPT PROGRAM

		SETLOC	DAPS3
		BANK

		COUNT*	$$/DAPRC
		EBANK=	KMPAC
REDORCS		LXCH	BANKRUPT	# RESTART OF AUTOPILOT COMES HERE
		CA	T5PHASE		# ON A T5 RUPT.
		EXTEND
		BZMF	+2		# IF T5PHASE +0, -0, OR -, RESET TO -
		TCF	+3		# IF T5PHASE +, LEAVE IT +.  DO A FRESHDAP
		CS	ONE
		TS	T5PHASE
		EXTEND
		DCA	RCSLOC
		DXCH	T5LOC		# HOOK UP T5RUPT TO AUTOPILOT
		TCF	RCSATT +1
		EBANK=	KMPAC
RCSLOC		2CADR	RCSATT


RCSATT		LXCH	BANKRUPT	# SAVE BB
 +1		EXTEND			# SAVE Q
		QXCH	QRUPT
		CAF	BIT15		# BIT15 CHAN31 = 0 IF IMU POWER IS ON AND
		TC	C31BTCHK	# S/C CONT SW IS IN CMC (I.E. IF G/C DAP
		TCF	SETT5		# IS FULLY ENABLED).     IF SO8
					# GO TO SETT5

		CS	RCSFLAGS	# IF G/C AUTOPILOT IS NOT FULLY ENABLED,
		MASK	BIT14
		ADS	RCSFLAGS	# SET NORATE FLAG,
		CAF	POSMAX
		TS	HOLDFLAG	# SET HOLDFLAG +,
		CAF	ZERO		# ZERO ERRORX, ERRORY, AND ERRORZ,
		TS	ERRORX
		TS	ERRORY
		TS	ERRORZ
		CAF	BIT14
		TC	C31BTCHK	# AND CHECK FREE FUNCTION (BIT14 CHAN31)
		TCF	SETT5
		TS	T5PHASE		# IF NOT IN FREE MODE,
		CAF	OCT37766	# SCHEDULE REINITIALIZATION (FRESHDAP)
		TS	TIME5		# IN 100 MS VIA T5RUPT

		TCR	ZEROJET		# ZERO JET CHANNELS IN 14 MS VIA ZEROJET
		TCF	KMATRIX
DELTATT		OCT	37770		# 80MS (TIME5)
DELTATT2	=	OCT37776	# 20 MS (TIME5)

# CHECK PHASE OF T5 PROGRAM
#
#     BECAUSE OF THE LENGTH OF THE T5 PROGRAM, IT HAS BEEN DIVIDED INTO 
# THREE PARTS, T5PHASE1, T5PHASE2, AND THE JET SELECTION LOGIC,
# TO ALLOW FOR THE EXECUTION OF OTHER
# INTERRUPTS.  T5PHASE IS ALSO USED IN THE INITIALIZATION OF THE AUTOPILOT
# VARIABLES AT TURN ON.
# THE CODING OF T5PHASE IS...
#
#            + = INITIALIZE T5 RCS-CSM AUTOPILOT
# T5PHASE = +0 = PHASE2 OF THE T5 PROGRAM
#            - = RESTART DAP
#           -0 = PHASE1 OF THE T5 PROGRAM

SETT5		CCS	T5PHASE
		TCF	FRESHDAP	# TURN ON AUTOPILOT
		TCF	T5PHASE2	# BRANCH TO PHASE2 OF PROGRAM
		TCF	REDAP		# RESTART AUTOPILOT

		TS	T5PHASE		# PHASE 1  RESET  FOR PHASE 2
		CA	TIME5
		TS	T5TIME		# USED IN COMPENSATING FOR DELAYS IN T5
		CAF	DELTATT2	# RESET FOR T5RUPT IN 20MS FOR PHASE2
		TS	TIME5		# OF PROGRAM


# IMU STATUS CHECK

		CS	IMODES33	# CHECK IMU STATUS
		MASK	NOIMUDAP	# BIT6 = 0 IMU OK
		CCS	A		# BIT6 = 1 NO IMU
		TCF	RATEFILT
FREECHK		CS	RCSFLAGS	# BIT14 INDICATES THAT RATES HAVE NOT BEEN
		MASK	BIT14		# INITIALIZED
		ADS	RCSFLAGS
		CAF	BIT14		# NO ATTITUDE REFERENCE
		TS	HOLDFLAG	# STOP ANY AUTOMATIC STEERING AND PREPARE
					# TO PICK UP CDU ANGLES UPON RESUMPTION OF
					# ATTITUDE HOLD
		TC	C31BTCHK	# CHECK FOR FREE MODE
		TCF	KRESUME1	# IN FREE, PROVIDE FREE CONTROL ONLY
		TCF	REINIT		# .....TILT...............................
BITS4,5		=	BITS4&5

RATEFILT	CA	RCSFLAGS	# SEE IF RATEFILTER HAS BEEN INITIALIZED
		MASK	BIT14
		EXTEND			# IF SO, PROCEED WITH RATE DERIVATION
		BZF	+2
		TCF	KMATRIX		# IF NOT, SKIP RATE DERIVATION

# 		RATE FILTER	TIMING = 7.72 MS
#
# RATE FILTER EQUATIONS
# DRHO = DELRHO - (.1)ADOT + (1 - GAIN1)DRHO
#					    -1
# ADOT = ADOT   + GAIN2 DRHO + KMJ DFT
#	     -1
#       -        *     -     -
# WHERE DELRHO = AMGB (CDU - CDU  )
#			 	-1

 +2		CAF	TWO
DRHOLOOP	TS	SPNDX
		DOUBLE
		TS	DPNDX
		INDEX	DPNDX
		CS	DRHO		# DRHO SCALED 180 DEGS
		EXTEND
		INDEX	ATTKALMN	# PICK UP DESIRED FILTER GAIN
		MP	GAIN1
		INDEX	DPNDX
		DAS	DRHO		# (1 -.064) DRHO
		EXTEND
		INDEX	DPNDX
		DCS	ADOT
		DXCH	KMPAC		# -(.1)ADOT
		CA	QUARTER
		TC	SMALLMP
		DXCH	KMPAC
		INDEX	DPNDX
		DAS	DRHO
		CCS	SPNDX
		TCF	DRHOLOOP

		CA	CDUX		# MEASURED BODY RATES--
		XCH	RHO
		EXTEND
		MSU	RHO		# -        *     -     -
		COM			# DELRHO = AMGB (CDU - CDU  )
					#			  -1
		ZL
		DXCH	DELTEMPX
		CA	CDUY
		XCH	RHO1
		EXTEND
		MSU	RHO1
		COM
		TS	T5TEMP		# (CDUY - RHO1)	   SCALED 90 DEGS
		EXTEND
		MP	AMGB1
		DAS	DELTEMPX	# DELTEMPX = (CDUX-RHO) + AMGB1(CDUY-RHO1)
					# MUST BE DOUBLE PRECISION OR WILL LOSE
					# PULSES
		CA	AMGB4
		EXTEND
		MP	T5TEMP
		DXCH	DELTEMPY
		CA	AMGB7
		EXTEND
		MP	T5TEMP
		DXCH	DELTEMPZ
		CA	CDUZ
		XCH	RHO2
		EXTEND
		MSU	RHO2
		COM
		TS	T5TEMP		# (CDUZ - RHO2)    SCALED 90 DEGS
		EXTEND
		MP	AMGB5
		DAS	DELTEMPY	# DELTEMPY = AMGB4(CDUY-RHO1)
					#		   + AMGB5(CDUZ-RHO2)
		CA	AMGB8
		EXTEND
		MP	T5TEMP
		DAS	DELTEMPZ	# DELTEMPZ = AMGB7(CDUY-RHO1)
					#		  + AMGB8(CDUZ-RHO2)
		CAF	TWO
ADOTLOOP	TS	SPNDX
		DOUBLE
		TS	DPNDX
		EXTEND
		INDEX	DPNDX
		DCA	DELTEMPX
		INDEX	DPNDX
		DAS	DRHO
		EXTEND
		INDEX	DPNDX
		DCA	DELTEMPX
		INDEX	DPNDX
		DAS	MERRORX
		INDEX	DPNDX
		CA	DRHO
		DOUBLE			# N.B.
		DOUBLE			# N.B.
		EXTEND
		INDEX	ATTKALMN	# PICK UP DESIRED FILTER GAINS
		MP	GAIN2
		INDEX	DPNDX		# ADOT   + (.16)(.1)DRHO
		DAS	ADOT		#     -1
		INDEX	SPNDX		# S/C TORQUE TO INERTIA RATIO
		CA	KMJ		# SCALED (450)(1600)/(57.3)(16384)=1/1.3
		EXTEND
		INDEX	SPNDX
		MP	DFT
		INDEX	DPNDX
		DAS	ADOT		# KMJ(DFT)
		CCS	SPNDX
		TCF	ADOTLOOP	# END CALCULATION OF VEHICLE RATES
KMATRIX		CA	ATTSEC
		MASK	LOW4
		CCS	A
		TCF	TENTHSEK
		CAF	PRIO34		# CALL FOR 1 SEC UPDATE OF TRANSFORMATION
		TC	NOVAC		# MATRIX FROM GIMBAL AXES TO BODY AXES
		EBANK=	KMPAC
		2CADR	AMBGUPDT

		CAF	NINE

TENTHSEK	TS	ATTSEC

# WHEN AUTOMATIC MANEUVERS ARE BEING PERFORMED, THE FOLLOWING ANGLE ADDITION MUST BE MADE TO PROVIDE A SMOOTH
# SEQUENCE OF ANGULAR COMMANDS TO THE AUTOPILOT--
#
#	CDUXD = CDUXD + DELCDUX		(DOUBLE PRECISION)
#	CDUYD = CDUYD + DELCDUY		(DOUBLE PRECISION)
#	CDUZD = CDUZD + DELCDUZ		(DOUBLE PRECISION)
#
# THE STEERING PROGRAMS-
#	1) ATTITUDE MANEUVER ROUTINE
#	2) LEM TRACKING
#
# SHOULD GENERATE THE DESIRED ANGLES (CDUXD, CDUYD, CDUZD) AS WELL AS THE INCREMENTAL ANGLES (DELCDUX, DELCDUY,
# DELCDUZ) SO THAT THE GIMBAL ANGLE COMMANDS CAN BE INTERPOLATED BETWEEN UPDATES.
#
# HOLDFLAG CODING-
#
#     + = GRAB PRESENT CDU ANGLES AND STORE IN THETADX, THETADY, THETADZ
#	  AND PERFORM ATTITUDE HOLD ABOUT THESE ANGLES
#	  ALSO IGNORE AUTOMATIC STEERING
#	  SET = + BY
#		 1) INITIALIZATION PHASE OF AUTOPILOT
#		 2) OCCURANCE OF RHC COMMANDS
#		 3) FREE MODE
#		 4) SWITCH OVER TO ATTITUDE HOLD FROM AUTO
#		    WHILE DOING AUTOMATIC STEERING (IN THIS CASE
#		    HOLDFLAG IS NOT ACTUALLY SET TO +, BUT THE LOGIC
#		    FUNCTIONS AS IF IT WERE.)
#		 5) S/C CONTROL SWITCH IN SCS
#		 6) IMU POWER OFF
#     +0 = IN ATTITUDE HOLD ABOUT A PREVIOUSLY ESTABLISHED REFERENCE
#      - = PERFORMING AUTOMATIC MANEUVER
#     -0 = NOT USED AT PRESENT
#
# 	NOTE THAT THIS FLAG MUST BE  SET = -  BY THE STEERING PROGRAM IF IT IS TO COMMAND THE AUTOPILOT.
# SINCE ASTRONAUT ACTION MAY CHANGE THE HOLDFLAG SETTING, IT SHOULD BE MONITORED BY THE STEERING PROGRAM TO
# DETERMINE IF THE AUTOMATIC SEQUENCE HAS BEEN INTERRUPTED AND IF SO, TAKE APPROPRIATE ACTION.


		CS	HOLDFLAG
		EXTEND
		BZMF	DACNDLS		# IF HOLDFLAG +0,-0,+, BYPASS AUTOMATIC
					# COMMANDS
DCDUINCR	CAF	TWO
DELOOP		TS	SPNDX
		DOUBLE
		TS	DPNDX
		EXTEND
		INDEX	A
		DCA	CDUXD
		DXCH	KMPAC
		EXTEND
		INDEX	DPNDX
		DCA	DELCDUX
		TC	DPADD
		EXTEND
		DCA	KMPAC
		INDEX	SPNDX
		TS	THETADX
		INDEX	DPNDX
		DXCH	CDUXD
		CCS	SPNDX
		TCF	DELOOP


# RCS-CSM AUTOPILOT ATTITUDE ERROR DISPLAY
#
# THREE TYPES OF ATTITUDE ERRORS MAY BE DISPLAYED ON THE FDAI-
#
#		MODE 1)	AUTOPILOT FOLLOWING ERRORS		SELECTED BY V61E
#			GENERATED INTERNALLY BY THE AUTOPILOT
#
#		MODE 2)	TOTAL ATTITUDE ERRORS			SELECTED BY V62E
#			WITH RESPECT TO THE CONTENTS OF N22
#
#		MODE 3)	TOTAL ASTRONAUT ATTITUDE ERRORS		SELECTED BY V63E
#			WITH RESPECT TO THE CONTENTS OF N17
#
# MODE 1 IS PROVIDED AS A MONITOR OF THE RCS DAP AND ITS ABILITY TO TRACK AUTOMATIC STEERING COMMANDS.  IN THIS
# MODE THE ATTITUDE ERRORS WILL BE ZEROED WHEN THE CMC MODE SWITCH IS IN FREE
#
# MODE 2 IS PROVIDED TO ASSIST THE CREW IN MANUALLY MANEUVERING THE S/C TO THE ATTITUDE (GIMBAL ANGLES) SPECIFIED
# IN N22.  THE ATTITUDE ERRORS WRT THESE ANGLES AND THE CURRENT CDU ANGLES ARE RESOLVED INTO S/C CONTROL AXES
# AS A FLY-TO INDICATOR.
#
# MODE 3 IS PROVIDED TO ASSIST THE CREW IN MANUALLY MANEUVERING THE S/C TO THE ATTITUDE (GIMBAL ANGLES) SPECIFIED
# IN N17.  THE ATTITUDE ERRORS WRT THESE ANGLES AND THE CURRENT CDU ANGLES ARE RESOLVED INTO S/C CONTROL AXES
# AS A FLY-TO INDICATOR.
#
#    V60 IS PROVIDED TO LOAD N17 WITH A SNAPSHOT OF THE CURRENT CDU ANGLES, THUS SYNCHRONIZING THE MODE 3 DISPLAY
# WITH THE CURRENT S/C ATTITUDE.  THIS VERB MAY BE USED AT ANY TIME.
#
#    THESE DISPLAYS WILL BE AVAILIABLE IN ANY MODE (AUTO, HOLD, FREE, G+N, OR SCS) ONCE THE RCS DAP HAS BEEN
# INITIATED VIA V46E.  MODE 1, HOWEVER, WILL BE MEANINGFUL ONLY IN G+N AUTO OR HOLD.  THE CREW MAY PRESET (VIA
# V25N17) AN ATTITUDE REFERENCE (DESIRED GIMBAL ANGLES) INTO N17 AT ANY TIME.

DACNDLS		CS	RCSFLAGS	# ALTERNATE  BETWEEN FDAIDSP1 AND FDAIDSP2
		MASK	BIT4
		EXTEND
		BZF	FDAIDSP2

FDAIDSP1	ADS	RCSFLAGS
		TC	NEEDLER
KRESUME1	TCF	RESUME		# END PHASE 1


# FDAI ATTITUDE ERROR DISPLAY SUBROUTINE
#
# PROGRAM DESCRIPTION:    D. KEENE   5/24/67
#
#     THIS SUBROUTINE IS USED TO DISPLAY ATTITUDE ERRORS ON THE FDAI VIA THE DIGITAL TO ANALOG CONVERTERS (DACS)
# IN THE CDUS.  CARE IS TAKEN TO METER OUT THE APPROPRIATE NUMBER OF PULSES TO THE IMU ERROR COUNTERS AND PREVENT
# OVERFLOW, TO CONTROL THE RELAY SEQUENCING, AND TO AVOID INTERFERENCE WITH THE COARSE ALIGN LOOP WHICH ALSO USES
# THE DACS.
#
#
# CALLING SEQUENCE:
#
#     DURING THE INITIALIZATION SECTION OF THE USER'S PROGRAM, BIT3 OF RCSFLAGS SHOULD BE SET TO INITIATE THE
# TURN-ON SEQUENCE WITHIN THE NEEDLES PROGRAM:
#
#		CS	RCSFLAGS	IN EBANK6
#		MASK	BIT3
#		ADS	RCSFLAGS
#
# THEREAFTER, THE ATTITUDE ERRORS GENERATED BY THE USER SHOULD BE TRANSFERED TO THE FOLLOWING LOCATIONS IN EBANK6:
#
#		AK	SCALED 180 DEGREES  NOTE: THESE LOCATIONS ARE SUBJECT
#		AK1	SCALED 180 DEGREES	  TO CHANGE
#		AK2	SCALED 180 DEGREES
#
# FULL SCALED DEFLECTION CORRESPONDS TO 16 7/8 DEGREES OF ATTITUDE ERROR
#		(= 384 BITS IN IMU ERROR COUNTER)
#
# A CALL TO NEEDLER WILL THEN UPDATE THE DISPLAY:
#
#		INHINT
#		TC	IBNKCALL	NOTE: EBANK SHOULD BE SET TO E6
#		CADR	NEEDLER
#		RELINT
#
#     THIS PROCESS SHOULD BE REPEATED EACH TIME THE ERRORS ARE UPDATED.  AT LEAST 3 PASSES THRU THE PROGRAM ARE
# REQUIRED BEFORE ANYTHING IS ACTUALLY DISPLAYED ON THE ERROR METERS.
# NOTE: EACH CALL TO NEEDLER MUST BE SEPARATED BY AT LEAST 50MS TO ASSURE PROPER RELAY SEQUENCING.
#
# ERASABLE USED:
#			AK		CDUXCMD
#			AK1		CDUYCMD
#			AK2		CDUZCMD
#			EDRIVEX		A,L,Q
#			EDRIVEY		T5TEMP
#			EDRIVEZ		SPNDX
#
# SWITCHES:		RCSFLAGS	BITS 3,2
#
# I/O CHANNELS:		CHAN12		BIT 4 (COARSE ALIGN - READ ONLY)
#			CHAN12		BIT 6 (IMU ERROR COUNTER ENABLE)
#			CHAN14		BIT 13,14,15 (DAC ACTIVITY)
#
# SIGN CONVENTION<	AK = THETAC - THETA
#           WHERE	THETAC = COMMAND ANGLE
#			THETA = PRESENT ANGLE

NEEDLER		CAF	BIT4		# CHECK FOR COARSE ALIGN ENABLE
		EXTEND			# IF IN COARSE ALIGN DO NOT USE IMU
		RAND	CHAN12		# ERROR COUNTERS. DONT USE NEEDLES
		EXTEND
		BZF	NEEDLER1
RCSINT		CS	RCSFLAGS	# SET BIT3 FOR INITIALIZATION PASS
		MASK	BIT3
		ADS	RCSFLAGS
		TC	Q

NEEDLER1	CA	RCSFLAGS
		MASK	SIX
		EXTEND
		BZF	NEEDLES3
		MASK	BIT3
		EXTEND
		BZF	NEEDLER2	# BIT3 = 0, BIT2 = 1
		
		CS	BIT6		# FIRST PASS BIT3 = 1
		EXTEND			# DISABLE IMU ERROR COUNTER TO ZERO DACS
		WAND	CHAN12		# MUST WAIT AT LEAST 60 MS BEFORE
NEEDLE11	CS	ZERO		# ENABLING COUNTERS.
		TS	AK		# ZERO THE INPUTS ON FIRST PASS
		TS	AK1
		TS	AK2
		TS	EDRIVEX		# ZERO THE DISPLAY REGISTERS
		TS	EDRIVEY	
		TS	EDRIVEZ
		TS	CDUXCMD		# ZERO THE OUT COUNTERS
		TS	CDUYCMD
		TS	CDUZCMD
		CS	SIX		# RESET RCSFLAGS FOR PASS2
		MASK	RCSFLAGS
		AD	BIT2
		TS	RCSFLAGS
		TC	Q		# END PASS1

NEEDLER2	CAF	BIT6		# ENABLE IMU ERROR COUNTERS
		EXTEND
		WOR	CHAN12
		CS	SIX		# RESET RCSFLAGS TO DISPLAY ATTITUDE
		MASK	RCSFLAGS	# ERRORS    WAIT AT LEAST 4 MS FOR
		TS	RCSFLAGS	# RELAY CLOSURE
		TC	Q


NEEDLES3	CAF	BIT6		# CHECK TO SEE IF IMU ERROR COUNTER
		EXTEND			# IS ENABLED
		RAND	CHAN12
		EXTEND			# IF NOT RECYCLE NEEDLES
		BZF	RCSINT
NEEDLES		CAF	TWO
DACLOOP		TS	SPNDX
		CS	QUARTER
		EXTEND
		INDEX	SPNDX
		MP	AK
		TS	L
		CCS	A
		CA	DACLIMIT
		TCF	+2
		CS	DACLIMIT
		AD	L
		TS	T5TEMP		# OVFLO CHK
		TCF	OVSPOT
		INDEX	A		# ON OVERFLOW LIMIT OUTPUT TO +-384
		CAF	DACLIMIT
		TS	L
OVSPOT		INDEX	SPNDX
		CS	EDRIVEX		# CURRENT VALUE OF DAC
		AD	L
		INDEX	SPNDX
		ADS	CDUXCMD
		INDEX	SPNDX
		LXCH	EDRIVEX
		CCS	SPNDX
		TCF	DACLOOP
		CAF	13,14,15
		EXTEND
DRIVEDAC	WOR	CHAN14		# SET DAC ACTIVITY BITS
		TC	Q

REINIT		CAF	DELAY200	# ........TILT LOGIC
		TS	TIME5		# REINITIALIZE DAP IN 200MS
		TS	T5PHASE
		TCF	RESUME
DELAY200	DEC	16364		# 200MS


		DEC	-384
DACLIMIT	DEC	16000
		DEC	384


# INITIALIZATION PROGRAM FOR RCS-CSM AUTOPILOT
#
# THE FOLLOWING QUANTITIES WILL BE ZEROED AND SHOULD APPEAR IN CONSECUTIVE LOCATIONS IN MEMORY AFTER WBODY
#
# WBODY   (+1)    DFT             TAU2
# WBODY1  (+1)    DFT1            BIAS
# WBODY2  (+1)    DFT2            BIAS1
# ADOT    (+1)    DRHO   (+1)     BIAS2
# ADOT1   (+1)    DRHO1  (+1)     ERRORX
# ADOT2   (+1)    DRHO2  (+1)     ERRORY
# MERRORX (+1)    ATTSEC          ERRORZ
# MERRORY (+1)    TAU
# MERRORZ (+1)    TAU1

FRESHDAP	CAF	ONE		# RESET HOLDFLAG TO STOP AUTOMATIC
		TS	HOLDFLAG	# STEERING AND PREPARE TO PICK UP AN
					# ATTITUDE HOLD REFERENCE
			
REDAP		TC	IBNKCALL	# DECODE DAPDATR1, DAPDATR2 FOR DEADBANDS
		CADR	S41.2		# RATES, QUADFAILS, QUAD MANAGEMENT

		TC	IBNKCALL	# DECODE IXX, IAVG AND CONVERT
		CADR	S40.14		# TO AUTOPILOT GAINS

		CAF	NO.T5VAR	# NO. LOCATIONS TO BE ZEROED MINUS 2
					# NO.T5VAR MUST BE ODD *************
ZEROT5		CCS	A
		TS	SPNDX
		CAF	ZERO
		TS	L
		INDEX	SPNDX
		DXCH	WBODY +1
		CCS	SPNDX
		TCF	ZEROT5
		TS	WBODY		# ZERO LAST (FIRST) ONE

		TC	ZEROJET
		CS	ZERO
		TS	CHANTEMP	# INITIALIZE MINIMUM IMPULSE CONTROL

		TS	CH31TEMP	# INITIALIZE RHC POSITION MEMORY FOR
					# MANUAL RATE MODES
			
		CAF	=.24
		TS	SLOPE		# INITIALIZE SWITCHING LOGIC SLOPE

		CAF	FOUR
		TS	T5TIME		# PHASE 0 RESETS FOR PHASE 2 INTERRUPT IN
					# 60 MS. PHASE 2 RESETS FOR PHASE 1 RUPT
					# IN (80MS - T5TIME(40MS)). THEREFORE
					# PHASE 1 (RATEFILTER) BEGINS CYCLING 100
					# MS FROM NOW AND EVERY 100MS THEREAFTER
		CAF	ELEVEN
		TS	ATTKALMN	# RESET TO PICK UP KALMAN FILTER GAINS
					# TO INITIALIZE THE S/C ANGULAR RATES
		CA	CDUX
		TS	RHO
		CA	CDUY
		TS	RHO1
		CA	CDUZ
		TS	RHO2
		CAF	ZERO		# RESET AUTOPILOT TO BEGIN EXECUTING
		TS	T5PHASE		# PHASE2 OF PROGRAM

		CS	IMODES33	# CHECK IMU STATUS
		MASK	NOIMUDAP	# IF BIT6 =0 IMU IN FINE ALIGN
		CCS	A		# IF BIT6 = 1 IMU NOT READY
		TCF	IMUAOK
		TS	ATTKALMN	# CANNOT USE IMU
		CAF	RCSINITB	# PROVIDE FREE CONTROL ONLY
		TCF	RCSSWIT		# DONT START UP RATE FILTER
					# SIGNAL NO RATE FILTER

IMUAOK		CAF	PRIO34		# START MATRIX INITIALIZATION
		TC	NOVAC		# BYPASS IF IMU NOT IN FINE ALIGN
		EBANK=	KMPAC
		2CADR	AMBGUPDT

		CAF	RCSINIT		# CLEAR BIT14 -ASSUME WE HAVE A GOOD IMU
RCSSWIT		TS	RCSFLAGS	# CLEAR BIT1  -INITIALIZE T6 PROGRAM
					#   SET BIT3  -INITIALIZE NEEDLES
					# CLEAR BIT4  -RESET FOR FDAIDSP1
		CAF	T5WAIT60	# NEXT T5RUPT 60 MS FROM NOW TO ALLOW IMU
					# ERROR COUNTER TO ZERO.
					# (MINIMUM DELAY = 15 MS)
		TS	TIME5		# SINCE ATTKALMN IS +11, PROGRAM WILL THEN
		TC	RESUME		# PICK UP THE KALMAN FILTER GAINS. RATE
					# FILTER WILL BEGIN OPERATING ZOOMS FROM
					# NOW
					
# CONSTANTS USED IN INITIALIZATION PROGRAM


NO.T5VAR	DEC	35		# NO. OF LOCATIONS TO BE ZEROED
					# MINUS 2...MUST BE ODD

# FOR AN EVEN NUMBER OF VARIABLES TO BE ZEROED....
#  * SET NO.T5VAR EQUAL TO NUMBER OF VARIABLES MINUS 1
#  * DO DXCH WBODY INSTEAD OF WBODY + 1
#  * DELETE TS WBODY

=.24		DEC	.24		# = SLOPE OF 0.6/SEC
RCSINIT		=	BIT3
RCSINITB	OCT	20004


T5WAIT60	DEC	16378		# = 6 CS
		EBANK=	KMPAC
T6ADDR		2CADR	T6START


-75DEGS		DEC	-.41666		# -75 DEGS IN REVS * 2
ZEROJET		CAF	ELEVEN		# ZERO  BLAST2, BLAST1, BLAST, YWORD2,
 +1		TS	SPNDX		# YWORD1,PWORD2,PWORD1,RWORD2,
		CAF	ZERO		# AND RWORD1.
		INDEX	SPNDX
		TS	RWORD1
		CCS	SPNDX
		TCF	ZEROJET +1

		CAF	FOUR
		TS	BLAST1 +1
		CAF	ELEVEN
		TS	BLAST2 +1

		CS	BIT1
		MASK	RCSFLAGS
		TS	RCSFLAGS	# RESET BIT1 OF RCSFLAGS TO 0

		EXTEND
		DCA	T6ADDR
		DXCH	T6LOC
		CAF	=+14MS		# ENABLE T6RUPT TO SHUT OFF JETS IN 14 MS.
		TS	TIME6
		EXTEND
		QXCH	RUPTREG1
		TC	C13STALL
		CAF	BIT15
		EXTEND
		WOR	CHAN13

		TC	RUPTREG1

T5PHASE2	CCS	ATTKALMN	# IF (+) INITIALIZE RATE ESTIMATE
		TCF	KALUPDT


		TCF	+2		# ONLY IF ATTKALMN POSITIVE
		TCF	+1
		CA	DELTATT2	# RESET FOR PHASE3 IN 20 MS
		XCH	TIME5		# (JET SELECTION LOGIC )
		ADS	T5TIME		# TO COMPENSATE FOR DELAYS IN T5RUPT


		CCS	CDUZ
		TCF	GIMBY		# +(
		TCF	OKGIMB		# +0
		TCF	GIMBY		# -N
		TCF	OKGIMB		# -0
GIMBY		AD	-75DEGS
		EXTEND
		BZMF	OKGIMB

		TC	UPFLAG		# ATTITUDE HOLD WHEN MIDDLE GIMBAL ANGLE
		ADRES	STIKFLAG	#   GREATER THAN 75 DEGREES
		CAF	ZERO
		TS	HOLDFLAG

OKGIMB		CA	RCSFLAGS	# IF A HIGH RATE AUTO MANEUVER IS IN
		MASK	BIT15		# PROGRESS (BIT 15 OF RCSFLAGS SET), SET
		EXTEND			# ATTKALMN TO -1
		BZF	NOHIAUTO	# OTHERWISE SET ATTKALMN TO 0.
		CS	ONE
NOHIAUTO	TS	ATTKALMN


# 	MANUAL ROTATION COMMANDS

		CS	OCT01760	# RESET FORCED FIRING BITS (BITS 10 TO 5
		MASK	RCSFLAGS	# OF RCSFLAGS) TO ZERO
		TS	RCSFLAGS

		EXTEND
		READ	CHAN31
		TS	L
		CA	CH31TEMP
		EXTEND
		RXOR	LCHAN
		MASK	MANROT		# = OCT00077
		EXTEND
		BZMF	NOCHANGE

		LXCH	A
		TS	CH31TEMP	# SAVE CONTENTS OF CHANNEL 31 IN CH31TEMP

		CA	L
		EXTEND
		MP	BIT5		# PUT BITS 6-1 OF A IN BITS 10-5 OF L
		CA	L
		ADS	RCSFLAGS	# SET FORCED FIRING BITS FOR AXES WITH
					# WITH CHANGES IN COMMAND. BITS 10,9 FOR
					# ROLL, BITS 8,7 FOR YAW, BITS 6,5 FOR
					# PITCH

		CS	RCSFLAGS	# SET RATE DAMPING FLAGS (BITS 13,12,AND
		MASK	OCT16000	# 11 OF RCSFLAGS)
		ADS	RCSFLAGS

NOCHANGE	CS	CH31TEMP
		MASK	MANROT
		EXTEND
		BZMF	AHFNOROT	# IF NO MANUAL COMMANDS, GO TO AHFNOROT

		TS	HOLDFLAG	# SET HOLDFLAG +

		TC	STICKCHK	# WHEN THE RHC IS OUT OF DETENT, PMANNDX,
					# YMANNDX, AND RMANNDX ARE ALL SET, BY
					# MEANS OF STICKCHK, TO 0, 1, OR 2 FOR NO,
					# +, OR - ROTATION RESPECTIVELY AS
					# COMMANDED BY THE RHC.
					#
					# HOWEVER, IT IS WELL TO NOTE THAT AFTER
					# THE RHC IS RETURNED TO DETENT, THE
					# PROGRAM BRANCHES TO AHFNOROT AND AVOIDS
					# STICKCHK SO PMANNDX, YMANNDX, AND
					# RMANNDX ARE NOT RESET TO ZERO BUT RATHER
					# LEFT SET TO THEIR LAST OUT OF DETENT
					# VALUES.

		CS	FLAGWRD1	# SET STIKFLAG TO INFORM STEERING
		MASK	STIKBIT		# PROGRAMS (P20) THAT ASTRONAUT HAS
		ADS	FLAGWRD1	# ASSUMED ROTATIONAL CONTROL OF SPACECRAFT

		CAF	BIT14
		TC	C31BTCHK
		TCF	FREEFUNC
		CA	RCSFLAGS	# EXAMINE RCSFLAGS TO SEE IF RATE FILTER
		MASK	BIT14		# HAS BEEN INITIALIZED
		CCS	A		# IF SO, PROCEED WITH MANUAL RATE COMMANDS
		TCF	REINIT		# .....TILT, RECYCLE TO INITIALIZE FILTER

		CS	FIVE		# IF MANUAL MANEUVER IS AT HIGH RATE, SET
		AD	RATEINDX	# ATTKALMN TO -1.
		EXTEND			# OTHERWISE, LEAVE ATTKALMN ALONE.
		BZMF	+3
		CS	ONE
		TS	ATTKALMN


		CAF	TWO		# AUTO-HOLD MANUAL ROTATION
SETWBODY	TS	SPNDX
		DOUBLE
		TS	DPNDX
		INDEX	SPNDX		# RMANNDX = 0 NO ROTATION
		CA	RMANNDX		#	  = 1  + ROTATION
		EXTEND			#  	  = 2  - ROTATION
		BZF	NORATE		# IF NO ROTATION COMMAND ON THIS AXIS,
					# GO TO NORATE.

		AD	RATEINDX	# RATEINDX = 0  0.05 DEG/SEC
		TS	Q		#          = 2  0.2 DEG/SEC
		INDEX	Q		#          = 4  0.5 DEG/SEC
		CA	MANTABLE -1	#          = 6  2.0 DEG/SEC
		EXTEND
		MP	BIT9		# MULTIPLY MANTABLE BY 2 TO THE -6
		INDEX	DPNDX		# TO GET COMMANDED RATE.
		DXCH	WBODY		# SET WBODY TO COMMANDED RATE.

		CA	RCSFLAGS
		MASK	OCT16000	# IS RATE DAMPING COMPLETED (BITS 13,12 AND
		EXTEND			# 11 OF RCSFLAGS ALL ZERO.)  IF SO, GO TO
		BZF	MERUPDAT	# MERUPDAT TO UPDATE CUMULATIVE ATTITUDE
					# ERROR.

ZEROER		CA	ZERO		# ZEROER ZEROS MERRORS
		ZL
		INDEX	DPNDX
		DXCH	MERRORX
		TCF	SPNDXCHK

NORATE		ZL
		INDEX	DPNDX
		DXCH	WBODY		# ZERO WBODY FOR THIS AXIS
		CA	RCSFLAGS
		MASK	OCT16000
		EXTEND			# IS RATE DAMPING COMPLETED
		BZF	SPNDXCHK	# YES, KEEP CURRENT MERRORX GO TO SPNDXCHK
		TCF	ZEROER		# NO, GO TO ZEROER

MERUPDAT	INDEX	Q		# MERRORX=MERRORX+MEASURED CHANGE IN ANGLE
		CS	MANTABLE -1	# -COMMANDED CHANGE IN ANGLE
		EXTEND			# THE ADDITION OF MEASURED CHANGE IN ANGLE
		MP	BIT7		# HAS ALREADY BEEN DONE IN THE RATE FILTER
		INDEX	DPNDX		# COMMANDED CHANGE IN ANGLE = WBODY TIMES
		DAS	MERRORX		# .1SEC = MANTABLE ENTRY TIMES 2 TO THE -8

SPNDXCHK	INDEX	DPNDX
		CA	MERRORX
		INDEX	SPNDX
		TS	ERRORX		# ERRORX = HIGH ORDER WORD OF MERRORX
		CCS	SPNDX
		TCF	SETWBODY
		TCF	JETS


OCT01760	OCT	01760		# FORCED FIRING BITS MASK

OCT01400	OCT	01400		# ROLL FORCED FIRING MASK	ORDER OF
OCT00060	OCT	00060		# PITCH FORCED FIRING MASK	DEFINITION
OCT00300	OCT	00300		# YAW FORCED FIRING MASK	MUST BE
					#				PRESERVED
					#			      FOR INDEXING
MANROT		OCT	77
OCT16000	OCT	16000		# RATE DAMPING FLAGS MASK
MANTABLE	DEC	.0071111
		DEC	-.0071111
		DEC	.028444
		DEC	-0.028444
		DEC	.071111
		DEC	-.071111
		DEC	.284444
		DEC	-.284444
=+14MS		DEC	23
FREEFUNC	CA	RCSFLAGS
		EXTEND
		MP	BIT11		# SHIFT RIGHT 4 BITS
		TS	T5TEMP
		CS	CH31TEMP
		MASK	T5TEMP		# A= COMPLEMENT OF NEW CH 31 COMMANDS
		TCF	RHCMINP
T6PROGM		CAF	ZERO		# FOR MANUAL ROTATIONS
		TS	ERRORX
		TS	ERRORY
		TS	ERRORZ
		TCF	T6PROG


FREETAU		DEC	0
		DEC	480
		DEC	-480
		DEC	0


		DEC	.2112		# FILTER GAIN FOR TRANSLATION, LEM ON
		DEC	.8400		# FILTER GAIN FOR TRANSLATION 2(ZETA)WN DT
		DEC	.2112		# FILTER GAIN FOR 2 DEGREES/SEC MANEUVERS
GAIN1		DEC	.0640		# KALMAN FILTER GAINS FOR INITIALIZATION
		DEC	.3180		# OF ATTITUDE RATES
		DEC	.3452
		DEC	.3774
		DEC	.4161
		DEC	.4634
		DEC	.5223
		DEC	.5970
		DEC	.6933
		DEC	.8151
		DEC	.9342

		DEC	.0174		# FILTER GAIN FOR TRANSLATION, LEM ON
		DEC	.3600		# FILTER GAIN FOR TRANSLATION (WN)(WN)DT
		DEC	.0174		# FILTER GAIN FOR 2 DEGREES/SEC MANEUVERS
GAIN2		DEC	.0016		# SCALED 10
		DEC	.0454
		DEC	.0545
		DEC	.0666
		DEC	.0832
		DEC	.1069
		DEC	.1422
		DEC	.1985
		DEC	.2955
		DEC	.4817
		DEC	.8683
STICKCHK	TS	T5TEMP
		MASK	THREE		# INDECES FOR MANUAL ROTATION
		TS	PMANNDX
		CA	T5TEMP
		EXTEND			# MAN RATE 0   0 RATE (DP)
		MP	QUARTER		# 	   +1   +RATE (DP)
		TS	T5TEMP		#          +2   -RATE (DP)
		MASK	THREE		#	  (+3)  0 RATE (DP)
		TS	YMANNDX
		CA	T5TEMP
		EXTEND
		MP	QUARTER
		TS	RMANNDX
		TC	Q

KALUPDT		TS	ATTKALMN	# INITIALIZATION OF ATTITUDE RATES USING
					# KALMAN FILTER TAKES 1.1 SEC

		CA	DELTATT		# =1SEC - 80MS
		AD	T5TIME		# + DELAYS
		TS	TIME5
		TCF	+3
		CAF	DELTATT2	# SAFETY PLAY TO ASSURE
		TS	TIME5		# A T5RUPT


KRESUME2	CS	ZERO		# RESET FOR PHASE1
		TS	T5PHASE		# RESUME INTERRUPTED PROGRAM
		TCF	RESUME


FDAIDSP2	CS	BIT4		# RESET FOR FDAIDSP1
		MASK	RCSFLAGS
		TS	RCSFLAGS

		CS	FLAGWRD0	# ON - DISPLAY ONE OF THE TOTAL ATTITUDE
		MASK	NEEDLBIT	# ERRORS
		EXTEND
		BZF	FDAITOTL
		EXTEND
		DCS	ERRORX		# OFF - DISPLAY AUTOPILOT FOLLOWING ERROR
		DXCH	AK
		CS	ERRORZ
		TS	AK2
		TCF	RESUME		# END PHASE 1


FDAITOTL	CA	FLAGWRD9
		MASK	N2217BIT
		EXTEND
		BZF	WRTN17		# IS N22ORN17 (BIT6 OF FLAGWRD9) = 0
					# IF SO, GO TO WRTN17
WRTN22		EXTEND			# OTHERWISE, CONTINUE ON TO WRTN22 AND
		DCA	CTHETA		# GET SET TO COMPUTE TOTAL ATTITUDE
		DXCH	WTEMP		# ERROR WRT N22 BY PICKING UP THE THREE
		CA	CPHI		# COMPONENTS OF N22

GETAKS		EXTEND			# COMPUTE TOTAL ATTITUDE ERROR FOR
		MSU	CDUX		# DISPLAY ON FDAI ERROR NEEDLES
		TS	AK
		CA	WTEMP
		EXTEND
		MSU	CDUY
		TS	T5TEMP
		EXTEND
		MP	AMGB1
		ADS	AK
		CA	T5TEMP
		EXTEND
		MP	AMGB4
		TS	AK1
		CA	T5TEMP
		EXTEND
		MP	AMGB7
		TS	AK2
		CA	WTEMP +1
		EXTEND
		MSU	CDUZ
		TS	T5TEMP
		EXTEND
		MP	AMGB5
		ADS	AK1
		CA	T5TEMP
		EXTEND
		MP	AMGB8
		ADS	AK2
		TCF	RESUME		# END PHASE1 OF RCS DAP

WRTN17		EXTEND			# GET SET TO COMPUTE TOTAL ASTRONAUT
		DCA	CPHIX +1	# ATTITUDE ERROR WRT N17 BY PICKING UP
		DXCH	WTEMP		# THE THREE COMPONENTS OF N17
		CA	CPHIX
		TCF	GETAKS
