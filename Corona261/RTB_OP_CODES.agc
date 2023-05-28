### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	RTB_OP_CODES.agc
## Purpose:	A section of Corona revision 261.
##		It is part of the source code for the Apollo Guidance Computer
##		(AGC) for AS-202. No original listings of this software are
##		available; instead, this file was created via disassembly of
##		the core rope modules actually flown on the mission.
## Assembler:	yaYUL
## Contact:	Ron Burkey <info@sandroid.org>.
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2023-05-27 MAS  Created from Solarium 55.


		BANK	30
# ROUTINE TO LOAD TIME OF DAY INTO MPAC

LOADTIME	TC	READTIME
		CS	RUPTSTOR
		TS	MPAC
		CS	RUPTSTOR +1
		TS	MPAC +1
		RELINT
		CAF	ZERO
		TS	NEWEQIND
		TS	MPAC +2
		TC	DPEXIT


# ROUTINE TO RESET THE PUSHDOWN POUNTER

FRESHPD		CS	FIXLOC
		COM
		TS	PUSHLOC
		TC	RE-ENTER


# ROUTINE TO ZERO OUT THE FIRST 38 LOCS OF A VAC AREA

ZEROVAC		CAF	37DEC
ZVLOOP		TS	TEM2
		AD	FIXLOC
		TS	Q
		CAF	ZERO
		INDEX	Q
		TS	0
		CCS	TEM2
		TC	ZVLOOP
		TC	RE-ENTER

37DEC		DEC	37


# ROUTINE TO CONVERT IS COMP. NOS. TO 1S COMP.

CDULOGIC	CCS	MPAC		# THIS BASIC ROUTINE TESTS CDU ANGLES FOR
		TC	CDULOG1		# +OR-SIGN INCLUDING ZERO AND FORMS A DP
		TC	CDULOG1		# NUMBER CORRESPONDING TO ANGLE
		TC	+1
		CS	HALF		# USE		SMOVE	1
		TC	+2		# 		RTB
CDULOG1		CS	ZERO		# 			CDUXYZ
		XCH	OVCTR		#			CDULOGIC
		XCH	MPAC
		EXTEND
		MP	HALF
		XCH	OVCTR
		AD	LP
		XCH	MPAC +1
		XCH	OVCTR
		XCH	MPAC
		TC	DPEXIT


# ROUTINE TO CONVERT 1S COMP. NOS. TO 2S COMP.

1STO2S		CAF	ZERO
		XCH	MPAC +1
		DOUBLE
		TS	OVCTR
		CAF	ZERO
		AD	MPAC
		AD	MPAC
		CCS	A
		AD	ONE
		TC	+2
		COM
ZYXR		TS	MPAC		# AND MAYBE OVERFLOW.
		TC	DPEXIT
		
		INDEX	A		# HANDLE OVERFLOW IN STANDARD ANGULAR WAY.
		CAF	LIMITS
		AD	MPAC		# GUARANTEED NO OVERFLOW.
		TC	ZYXR


READPIPS	INHINT
		CS	PIPAX
		CS	A
		INDEX	FIXLOC
		TS	VAC
		CS	PIPAY
		CS	A
		INDEX	FIXLOC
		TS	VAC +2
		CS	PIPAZ
		CS	A
		INDEX	FIXLOC
		TS	VAC +4
		RELINT
		CAF	ZERO
		INDEX	FIXLOC
		TS	VAC +1
		INDEX	FIXLOC
		TS	VAC +3
		INDEX	FIXLOC
		TS	VAC +5
		TS	NEWEQIND	# LOAD INDICATOR OFF.
VMODE		CS	ZERO
		TC	DPEXIT +1



PULSEIMU	INDEX	FIXLOC		# ADDRESS OF GYRO COMMANDS SHOULD BE IN X1
		CS	X1
		COM
		TC	BANKCALL
		CADR	GYRODPNT
		
		TC	RE-ENTER


SGNAGREE	TC	BANKCALL
		CADR	TPAGREE
		TC	DPEXIT


## 202 V: Restored check of bit 13 of WASOPSET.
# ROUTINE TO COMPLETE OPTICS TRUNNION ANGLE CONVERSION FROM COUNTER
# READING TO DP REVOLUTIONS. CALLS TO TRUNLOG SHOULD BE IMMEDIATELY
# PRECEDED BY A CALL TO CDULOGIC.
TRUNLOG		CAF	BIT13
		MASK	WASOPSET
		CCS	A
		TC	+4

		CAF	HALF
TRUNLOG1	TC	SHORTMP
		TC	DANZIG		# WITH PD IF AT END W/ NO ADDRESSES.

		CAF	10DEGS		# CORRECT FOR 20 DEG OFFSET (CDULOGIC
		AD	MPAC		#  ALREADY SHIFTED IT RIGHT ONE) AND SHIFT
		TS	MPAC		#  RIGHT TWO ADDITIONAL PLACES.
		CAF	QUARTER
		TC	TRUNLOG1
		
10DEGS		DEC	3600		# HALF OF SXT TRUNION OFFSET


INCRCDUS	CAF	LOCTHETA
		TS	BUF
		CAF	TWO
INCRCDU2	TS	BUF +1
		DOUBLE
		AD	VACLOC
		INDEX	A
		CS	0
		COM
		TC	BANKCALL
		CADR	CDUINC
		
		CCS	BUF
		TS	BUF
		CCS	BUF +1
		TC	INCRCDU2
		TC	VMODE
		
LOCTHETA	ADRES	THETAD +2


#	LOG FUNCTION SUBROUTINE
#
#   INPUT... X  (IN IMPAC)
#  OUTPUT... -LN(X)/32		( IN MPAC.  SCALED BY 32TO FIT LOG OF 2EXP-28.

LOG		TC	SWAPLOC		#  CALLED BY 	RTB	LOG
		TC	INTPRET
		
		NOLOD	2		# GENERATES LOG BY SHIFTING ARG UNTIL
		TSLC	BDSU		# IT LIES BETWEEN .5 AND1.  THE LOG OF
		EXIT			# THIS PART IS FOUND AND THE LOG OF THE
					# SHIFTED PART IS COMPUTED AND ADDED IN.
			31D		# SHIFT COUNT STORED IN LOC 31 OF VAC AREA
			NEARONE
		
		TC	POLY		# GETS LOG OF PRINCIPLE PART.
		DEC	6
		2DEC	0
		2DEC	.031335467
		2DEC	.0130145859
		2DEC	.0215738898
		CAF	ZERO
		TS	MPAC +2
		CAF	CLOG1/2 +1
		XCH	MPAC +1
		TS	LOGTEM +1
		CAF	CLOG1/2
		XCH	MPAC
		XCH	LOGTEM
		INDEX	FIXLOC
		CS	31D		# LOAD POSITIVE SHIFT COUNT IN A.
		TC	SHORTMP2	# MULTIPLY BY SHIFT COUNT.
		
		XCH	MPAC +2
		XCH	MPAC +1
		XCH	MPAC		# RESULT WAS IN MPAC +1 AND MPAC +2.
		TC	DAD		# ADD IN PREVIOUS RESULT. LEFT IN LOGTEM.
		ADRES	LOGTEM
		TC	SWAPLOC
		TC	DPEXIT
		
CLOG1/2		2DEC	.0216608494


# 	SUBROUTINE TO COMPUTE THE ARCTAN OF THE RATIO OF TWO FUNCTIONS.
#
#	CALLED AS THOUGH A BASIC SUBR...	RTB	ARCTAN

ARCTAN		TC	SWAPLOC		# ARCTAN COMPUTES ARCTAN(VACZ/VACX)
		TC	INTPRET		#                        ---------
INATAN		DSQ	0		# RESULT HAS VALUE BETWEEN + AND - 1/2
			VACZ		# (180 DEG. SCALED) IS LEFT IN MPAC.
		
		DSQ	4
		DAD	BOV
		BZE	SQRT
		BDDV	BOV
		TSRT	ASIN
			VACX
			-
			2BIG
			ATAN0/0
			VACZ
			ATAN=90
			1		# AND PUSH IT DOWN
		
		BMN	2
		LODON	DMOVE
		EXIT
			VACX
			NEGVX
			-		# (INACTIVE NEEDED FOR PUSH-UP).

ATANDUN		TC	SWAPLOC
		TC	DPEXIT



NEGVX		COMP	2		# IF VACX NEGATIVE, CHNAGE RESULT.
		BPL	DAD
		RTB
			-
			NEGOUT
			HALVE
			ATANDUN
NEGOUT		NOLOD	1
		DSU	RTB
			HALVE
			ATANDUN

2BIG		NOLOD	1
		VSRT	ITC
			1
			INATAN

ATAN0/0		DMOVE	1
		RTB
			3ZEROS		# WHAT SHOULD ARCTAN(0/0) =
			ATANDUN

ATAN=90		SIGN	1
		RTB
			FOURTH
			VACZ
			ATANDUN


#	BASIC SUBROUTINE TO SAVE INTERPRETER REGISTERS  (SAME BANK AS RTBS).

SWAPLOC		XCH	LOC		# SUBROUTINE TO SWAP LOC, ADRLOC, AND
		INDEX	FIXLOC		# ORDER REGISTERS WITH LOCATIONS 28,
		XCH	28D		# 29, AND 30 IN TEMP AREA.
		TS	LOC
		XCH	ADRLOC		# USEFUL FOR USING INTERPRETER IN SUBROUT
		INDEX	FIXLOC		# AND THEN ABLE TO CONTINUE IN MIDDLE OF
		XCH	29D		# CURRENT EQUATIONS.
		TS	ADRLOC		# USE...	TC	SWAPLOC
		CS	BANKSET		# PACK INTERPRETIVE BANK AND ORDER IN 30D.
		AD	ORDER
		INDEX	FIXLOC		#		.........
		XCH	30D		#		TC   SWAPLOC
		TS	ORDER		#		TC   DANZIG
		MASK	LOW7
		XCH	ORDER
		MASK	BANKMASK
		COM
		TS	BANKSET
		TC	Q


#	SUBROUTINE TO SET MPACS TO POS OR NEG MAX DEPENDING ON SIGN MPAC
SIGNMPAC	CCS	MPAC
		TC	SETPOS
		TC	SETPOS
		TC	+1
		CAF	NEGSIGN
		TS	MPAC
		TS	MPAC +1
		TS	MPAC +2
		CAF	ZERO
		TS	NEWEQIND
		TC	DPEXIT
		
SETPOS		CAF	POSMAX
		TC	-7


V1STO2S		CAF	TWO		# THIS ROUTINE TAKES GIMBAL ANGLES SCALED
		TS	VBUF		# 2PI IN THE VAC AND LEAVES 2S COMPLIMENT
		DOUBLE			# ANSWERS IN MPAC.....MPAC +2
		AD	VACLOC		# BASE ADDRESS OF VECTOR ACCUMULATOR
		TS	VBUF +1
		INDEX	VBUF +1
		CS	Q
		COM
		DOUBLE
		TS	OVCTR		# SKIPS ON OVERFLOW
		CAF	ZERO
		INDEX	VBUF +1
		AD	A
		INDEX	VBUF +1
		AD	A
		CCS	A		# TEZT FOR NEGATIVE MAJOR PART
		AD	ONE
		TC	+2
		COM
ZYXW		INDEX	VBUF
		TS	MPAC
		TC	ZYXWV
		INDEX	A
		CAF	LIMITS		# NORMAL PROCEDURE FOR ANGLE OVERFLOW
		INDEX	VBUF
		AD	MPAC
		TC	ZYXW
		
ZYXWV		CCS	VBUF
		TC	V1STO2S +1
		TS	NEWEQIND
		CS	TWO
		TC	DPEXIT +1
V2STOD1S	CAF	TWO		# THIS ROUTINE TAKES CDU ANGLES IN MPAC...
		TS	VBUF		# MPAC +2 AND CONVERTS TO ANGLES SCALED
		DOUBLE			# 2PI IN THE VAC LOCATIONS
		AD	VACLOC
		TS	VBUF +1



		INDEX	VBUF
		CS	MPAC
		EXTEND
		MP	NEG1/2
		TS	VBUF +2		# UNCORRECTED UPPER PARTS
		CCS	LP		# TEST SIGN OF LOWER WORD
		CAF	ZERO
		TC	+3		# POSITIVE CASE OK
		TC	+1
		CS	HALF		# NEGATIVE CASE
		AD	LP		# CORRECT LOWER WORD
		INDEX	VBUF +1
		TS	Q		# STORE LOWER WORD
		CAF	ZERO		# DEAL WITH OVERFLOW STANDARD WAY
		AD	VBUF +2
		INDEX	VBUF +1
		TS	A		# STORE UPPER WORD
		
		CCS	VBUF
		TC	V2STOD1S
		
		CS	ZERO
		TS	MODE
		TC	DANZIG


# ROUTINE TO FREE DSKY



DSPFREE		TC	FREEDSP
		TC	RE-ENTER


#	FINAGLE TO GET OGC CORRECTED TO NEAREST POINT ON 16 SPEED.

CDUXFIX		CS	OGC		# INTERPRETIVE SCALING.   (REVS)
		EXTEND
		MP	BIT12		# MULTIPLY BY 1/8 TH.
		TS	MPAC +1		# SAVE RESULT.
		
		CAF	BIT11		# 1/16 TH.
		AD	THETAD		# TO FIND NEAREST ZERO POINT.
		MASK	HI4		# DROPS BACK TO LOWER (MORE NEG) 1/8TH.
		TS	K1ROLL
		TC	+3		# SKIPS THIS IF ADDITION OVERFLEW.
		CAF	POSMAX		# IN THAT CASE, USE POSMAX.
		TS	K1ROLL
		
		CS	K1ROLL		# THE CURRENT NEAREST ZERO POINT ON 16 SPD
		AD	THETAD		# DELTA FROM ZERO POINT.
		AD	MPAC +1		# MINUS NEW COMMAND
					#   A = DELTHETAD -DELNEWCOMMAND
		AD	BIT11		# PLUS 1/16 TH.  (180 DEG SCALED.)
		CCS	A		# IF NEG, CHANGE IS MORE THAN + 180 DEG.
		TC	CHECKNEG	# OK, CHECK OTHER WAY.
NEG1/8+1	OCT	74000
		CS	BIT12		# CHANGE TOO BIG, MOVE TO NEXT LOWER 0-PT.
NEWBIAS		AD	K1ROLL		# (NEG ZERO OF CCS COMES HERE ALSO, SO..)
		TS	K1ROLL
		TC	GETNUOGC	# SKIPPING ON OVERFLOW.
		
		INDEX	A
		CS	LIMITS
		TC	NEWBIAS +1	# AND SET PROPER LIMIT VALUE.
		
CHECKNEG	AD	NEG1/8+1
		CCS	A		# CHECK OTHER SIDE.
		CAF	BIT12		# ADD 108 TH TO K1ROLL.
		TC	NEWBIAS		# (+ 0 IMPOSSIBLE.)
		TC	+1		# NO NEED TO CHANGE BIAS.
		
GETNUOGC	CS	MPAC +1		# NEW DELTA.
## 202 ???: Restored TS K2ROLL
		TS	K2ROLL
		AD	K1ROLL		# AS MODIFIES IF IT WAS NEC. 
		TS	MPAC
		TC	+4		# DETECT OVERFLOW.
		
		INDEX	A
		CAF	LIMITS		# GO TO POSMAX FROM NEGMAX. (AND VICEVERSA
		AD	MPAC		# AND GET NEW ANGLE.
		
		EXTEND
		MP	BIT14		# RESCALE TO REVS.
		TS	OGC
		TC	RE-ENTER	# TO NEXT EQUATION WITHOUT PUSHING DOWN.



HI4		OCT	74000
