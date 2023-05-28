### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	IRIG_PULSE-TORQUING_ROUTINES.agc
## Purpose:	Part of the source code for Solarium build 55. This
##		is for the Command Module's (CM) Apollo Guidance
##		Computer (AGC), for Apollo 6.
## Assembler:	yaYUL --block1
## Contact:	Jim Lawton <jim DOT lawton AT gmail DOT com>
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2009-10-07 JL	Created.
## 		2016-12-28 RSB	Proofed comment text using octopus/ProoferComments,
##				and fixed errors found.


#	THE FOLLOWING PULSE-TORQUING OPTIONS ARE AVAILABLE:
#
#	GYROSPNT		SINGLE PRECISION INPUTS WITH NO TWITCH (IE ZERO OUTPUT ON ZERO COMMAND).
#	GYROSPTW		SINGLE PRECISION INPUT WITH TWITCH ON ZERO (2+ THEN 2-).
#	GYRODPNT		DOUBLE PRECISION INPUTS (SIGN AGREEMENT UNNECESSARY) WITH NO TWITCH.
#
# ALL OF THE ABOVE SHOULD BE FOLLOWED EVENTUALLY BY A CALL TO IMUSTALL.



		BANK	14
GYROSPNT	TS	MPAC		# ADDRESS OF THREE REGISTER COMMAND SET
		CCS	LGYRO		# ARRIVES IN A. SEE IF GYRO ROUTINES BUSY.
		TC	GYROBUSY	# (AND RETURN WHEN AVAILABLE.)
		
SPNT		CAF	TWO		# SET UP LOOP TO AUGMENT (+ OR -) EACH
		TS	MPAC +1		# COMMAND BY TWO IF NON-ZERO.
		DOUBLE
		AD	MPAC
		TS	BUF
		INDEX	A
		CCS	0
		CAF	TWO
		TC	+2		# (NO INCREMENT IF +-0).
		CS	TWO
		INDEX	BUF
		AD	0
		INDEX	BUF
		XCH	0		# (JUST TO BE SAFE).
		
		CCS	MPAC +1
		TC	SPNT +1
		
SPGYREX		INHINT
		CAF	ONE
		TC	WAITLIST
		CADR	DOGYROSP
		
GYROEX2		CS	THREE		# INITIALIZE CDUIND TO START GYRO TASKS
		TS	CDUIND		# AT Y GYRO (ORDER IS YZX).
		CS	FOUR
		AD	MPAC		# SET LGYROD PNZ TO INDICATE GYRO ACTIVITY
		TS	LGYRO		# AND USE LGYRO TO STORE THE ADDRESS OFF
		TC	MODEEXIT	# THE COMMANDS.
		

#	SINGLE PRECISION WITH TWITCH.

GYROSPTW	TS	MPAC
		CCS	LGYRO		# SAME PROLOGUE AS GYROSPNT
		TC	GYROBUSY
		
SPTW		CAF	TWO		# SET UP LOOP TO AUGMENT BY 2 (+ OR-),
		TS	MPAC +1		# WITH A PLUS TWO AUGMENT ON +-0.
		DOUBLE
		AD	MPAC
		TS	BUF
		INDEX	A
		CCS	0
		TC	+3
		TC	+2
		TC	+3
		
		CAF	TWO
		TC	+2
		
 +3		CS	TWO
		INDEX	BUF
		AD	0
		INDEX	BUF
		XCH	0
		
		CCS	MPAC +1
		TC	SPTW +1
		
		TC	SPGYREX		# SET UP PULSE-TORQUING TASKS. 
		

#	DOUBLE PRECISION INPUTS WITH NO TWITCH ON ZERO.

GYRODPNT	TS	ARETURN		# SAVE ADDRESS OF INPUT COMMANDS.
		TC	MAKECADR	# SAVE RETURN ADDRESS SINCE WE MUST
		XCH	ADDRWD		# DO A BANKCALL TO TPAGREE.
		TS	TEM11
		CAF	ZERO
		TS	MPAC +2
DPNT		CAF	TWO

		TS	BUF		# THIS LOOP FORCES SIGN AGREEMENT IN THE
		DOUBLE			# DP INPUT COMMANDS, AUGMENTING ON
		AD	ARETURN		# NON-ZERO.
		TS	BUF +1
		INDEX	A
		XCH	0
		TS	MPAC
		INDEX	BUF +1
		XCH	1
		TS	MPAC +1
		TC	BANKCALL
		CADR	TPAGREE
		
		CCS	A		# AUGMENT BYTWO IF NON-ZERO. TPAGREE
		CAF	TWO		# RETURNS +1,-0,-1.
		AD	TWO
		AD	NEG2
		
		AD	MPAC +1		# DIVIDE BY POSMAX - IE PLACE IN THE MAJOR
		AD	MPAC		# PART OF EACH COMMAND THE NUMBER OF
		INDEX	BUF +1		# POSMAX PULSE TRAINS TO BE PUT OUT, 
		TS	1		# LEAVING THE REMAINDER IN THE MINOR PART.
		TC	+8D
		
		TS	Q		# ON OVERFLOW, ADD +-1 TO THE MINOR PART 
		INDEX	BUF +1		# AS WELL AS THE MAJOR PART.
		AD	1
		INDEX	BUF +1		# NO OVERFLOW HERE.
		TS	1
		XCH	Q
		TC	+2
		
 +8D		CAF	ZERO
		AD	MPAC
		INDEX	BUF +1
		XCH	0
		CCS	BUF
		TC	DPNT +1
		
		XCH	ARETURN		# PREPARE FOR POSSIBLE GYROBUSY CALL.
		TS	MPAC
		CCS	LGYRO
		TC	GYROBSY2
		
		CAF	BANKMASK
		MASK	TEM11
		TS	BANKTEM
		CAF	LOW10
		MASK	TEM11
		AD	6K
		TS	TEMQS
		INHINT
		CAF	ONE
		TC	WAITLIST
		CADR	DOGYRO
		
		TC	GYROEX2
		

#	GYRO STALLING ROUTINES - CALLED VERY RARELY BY AT MOST ONE ROUTINE AT A TIME.

GYROBUSY	XCH	Q		# RETURN ADDRESS TO MPAC.
		TS	MPAC +2
		
		TC	MAKECADR	# CALLERS RETURN CADR TO MPAC +1.
		XCH	ADDRWD
		TS	MPAC +1
REGSLEEP	CAF	CADRNEWG
		TC	JOBSLEEP	# AT STANDARD LOCATION.
		
NEWGYRO		CCS	LGYRO		# SEE IF ROUTINES STILL AVAILABLE (SHOULD
		TC	REGSLEEP	# BE). IF NOT, WAIT SOME MORE.
		
		XCH	MPAC +1		# RESTORE RETURN CADR TO STANDARD SWCALL
		TS	BANKTEM		# (BANKCALL) FORM.
		MASK	LOW10
		AD	6K
		TS	TEMQS
		TC	MPAC +2
		
GYROBSY2	XCH	Q		# DP WAIT.
		TS	MPAC +2
		XCH	TEM11
		TC	REGSLEEP -1
		
CADRNEWG	CADR	NEWGYRO


#	TASKS FOR SENDING OUT SINGLE PRECISION COMMANDS. 

		BANK	10
DOGYROSP	TC	SETUPSUB	# COMMON INITIALIZATION SUBROUTINE.
		INDEX	RUPTREG3
		CCS	0		# PUT OUT NEXT COMMAND.
		TC	POSGOUTS
		TC	GYROADVS	# NO COMMAND IF +-0.
		TC	NEGGOUTS
		
GYROADVS	CS	CDUIND		# ADVANCE TO NEXT GYRO IN ORDER YZX.
		INDEX	A
		TC	-1
		TC	ENDGYRO
		CAF	SIX
		AD	NEG2
		COM
		TS	CDUIND
		TC	DOGYROSP
		
POSGOUTS	AD	ONE
		TS	OVCTR
		TC	OUT2SUB		# PUT OUT COMMAND, SAVING COMMAND FOR
		TC	GETDT		# DT COMPUTATION.
		XCH	LPRUPT
		TC	WAITLIST
		CADR	TWEAKSP		# PUT OUT 2- WHEN COMMAND IS OUT.
		TC	TASKOVER	# ALL FOR NOW.
		
TWEAKSP		TC	SETUPSUB	# INITIALIZE.
		CS	TWO		# PUT OUT 2- AND ADVANCE TO NEXT GYRO.
		TC	OUT2SUB
		TC	GYROADVS
		
NEGGOUTS	AD	ONE		# GET ABS OF COMMAND AND SAVE IN OVCTR.
		TS	OVCTR
		
		CAF	TWO		# PUT OUT 2+ BEFORE NEGATIVE PULSE TRAIN.
		TC	OUT2SUB
		TC	GETDT		# COMPUTE WAITLIST DELTA T.
		
		CAF	SEVEN		# PUT IN A DELAY TO ALLOW 2+ PULSES
		CCS	A		# ENOUGH TIME TO GET OUT (3 PULSE TIMES).
		TC	-1
		
		CS	OVCTR		# PUT OUT NEGATIVE COMMAND.
		TC	OUT2SUB
		
		XCH	LPRUPT		# CALL WAITLIST FOR TASK DUE WHEN PULSE
		TC	WAITLIST	# TRAIN COMPLETE.
		CADR	GYROADVS
		TC	TASKOVER
		

#	WAITLIST TASKS TO SEND OUT DP PULSE TRAINS TO THE GYROS.

TWEAKGY		TC	SETUPSUB	# FINISHED WITH POSITIVE TRAINS TO A GYRO.
		CS	TWO		#  SEND OUT 2- TO LEAVE GYRO IN - STATE.
		TC	OUT2SUB
		
GYROADV		CS	CDUIND		# ADVANCE TO THE NEXT GYRO IN ORDER YZX.
		MASK	LOW7		# BIT14 IS 1 IF 2+ PULSES HAD BEEN SENT
		INDEX	A		#  BEFORE A NEGATIVE COMMAND.
		TC	-1
		TC	ENDGYRO1
		CAF	SIX
		AD	NEG2		# (CAME HERE FROM TC WITH C(A)=4.)
		COM
		TS	CDUIND
		
DOGYRO		TC	SETUPSUB	# SERVICE GYRO WHOSE *NUMBER* IS IN CDUIND
		INDEX	RUPTREG3
		CCS	0		# MAJOR PART IS POSMAX COUNT.
		TC	DOPOSMAX	# PUT OUT POSMAX.
		TC	DOMINOR
		TC	DONEGMAX
		
DOMINOR		INDEX	RUPTREG3	# SEND OUT REMAINDER OF COMMAND.
		CCS	1
		TC	POSGOUT
		TC	TWEAKGY +1	# FINISHED WITH LONG . PULSE TRAIN.
		TC	NEGGOUT
		TC	GYROADV		# DONE WITH LONG - TRAIN OR ZERO INPUT.
		
DOPOSMAX	INDEX	RUPTREG3	# PUT AWAY DECREMENTED POSMAX COUNT.
		TS	0
		CAF	POSMAX
DOMAX		TC	OUT2SUB
		CAF	FULLDT
		
GYROWAIT	TC	WAITLIST
		CADR	DOGYRO
		TC	TASKOVER
		

DONEGMAX	COM
		INDEX	RUPTREG3
		TS	0		# DECREMENTED POSMAX (NEGMAX) COUNT.
		CS	CDUIND		# SEE IF 2+ PULSES HAVE BEEN PUT OUT YET,
		MASK	NEG1/2		#  LEAVING WORD THAT THEY WILL BE OUT
		AD	BIT14		#  BY TASKOVER TIME.
		COM
		XCH	CDUIND
		MASK	BIT14
		CCS	A
		TC	+2
		TC	NEGMAX2		# ALREADY OUT.
		
		CAF	TWO		# NOT OUT YET - DO SO.
		TC	OUT2SUB
		CAF	TWO		# WAIT FOR THEM TO GET OUT BEFORE DELIVER-
		CCS	A		#  ING THE REAL COMMAND.
		TC	-1
		
NEGMAX2		CS	POSMAX
		TC	DOMAX
		
POSGOUT		AD	ONE		# FRACTIONAL POSITIVE COMMAND.
		TS	OVCTR
		TC	OUT2SUB		# DELIVER COMMAND.
		TC	GETDT		# GET TIME TO END OF PULSE TRAIN.
		XCH	LPRUPT		# (ANSWER LEFT IN LPRUPT).
		TC	WAITLIST
		CADR	TWEAKGY		# SUPPLY 2- PULSES AT END.
		TC	TASKOVER
		
NEGGOUT		AD	ONE		# FRACTIONAL NEGATIVE COMMAND.
		TS	OVCTR
		CS	CDUIND		# SEE IF 2+ PULSES ALREADY OUT.
		MASK	BIT14
		CCS	A
		TC	NEGGOUT2
		
		CAF	TWO
		TC	OUT2SUB
		
		CAF	SEVEN		# ALLOW AT LEAST 3 PULSE TIMES FOR THE 2+
		CCS	A		# PULSES TO GET OUT.
		TC	-1
		
NEGGOUT2	TC	GETDT
		CS	OVCTR		# DELIVER COMMAND.
		TC	OUT2SUB
		XCH	LPRUPT		# GET WAITLIST DT LEFT BY  GETDT  .
		TC	WAITLIST
		CADR	GYROADV
		TC	TASKOVER
		

#	SUBROUTINES USED BY TASKS.

GETDT		XCH	LP		# COMPUTE NUMBER OF 10 MS TICKS IT WILL
		TS	LPRUPT		#  TAKE THE PULSE TRAIN WHOSE MAGNITUDE IS
		CAF	BIT10		#  IN OVCTR TO BE DELIVERED AT A RATE OF
		EXTEND			#  3200 PPS.
		MP	OVCTR
		AD	TWO		# INTERRUPT AND ROUND-OFF UNCERTAINTIES.
		XCH	LPRUPT		# LEAVE ANSWER IN LPRUPT.
		EXTEND
		MP	ONE
		TC	Q
		
		
		
SETUPSUB	CAF	ZERO		# SETS UP MISCELLANEOUS REGISTERS.
		TS	RUPTREG2	# USED BY OUT2SUB.
		CS	CDUIND
		MASK	LOW7		# KILL 2+ BIT.
		TS	RUPTREG1
		DOUBLE
		AD	LGYRO
		TS	RUPTREG3	# USED FOR INDEXING GYROD SET.
		TC	Q
		
ENDGYRO1	CAF	ONE		# SPLIT INTO TWO TASKS SO IT WONT LAST TOO
		TC	WAITLIST	# LONG IN ANY ONE INTERRUPT.
		CADR	ENDGYRO
		TC	TASKOVER
		
ENDGYRO		CAF	ZERO		# SHOW THAT THE GYROS ARE NOW AVAILABLE.
		TS	LGYRO
		
		XCH	IN3		# RESTORE CDUIND
		XCH	IN3		# BY CHECKING IMU MODE
		MASK	OCT122		# IMUCOARS, IMUATTC, IMUREENT MASK
		CCS	A
		CS	ZERO		# TO +0 IF MODES ACTIVE
		COM			# TO -0 IF INACTIVE
		TS	CDUIND
		
		CAF	LNEWGYRO	# WAKE UP ANY JOB WHICH MIGHT BE WAITING
		TC	JOBWAKE		# FOR THE GYROS (AT MOST ONE).
		
		TC	POSTJUMP	# RETURN TO ENDIMU SEQUENCE IN MAIN MODE
		CADR	IMUFINED	# BANK (CHECKS IMU AND CDU FAIL SIGNALS).
		
LNEWGYRO	CADR	NEWGYRO		# STANDARD SLEEPING LOCATION FOR GYROBUSY.
OCT122		OCT	122
FULLDT		DEC	5.13 E2
