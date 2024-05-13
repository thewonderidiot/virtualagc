### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	IMU_MODE_SWITCHING_ROUTINES.agc.agc
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

		BLOCK	02
		SETLOC	FFTAG3
		BANK

		EBANK=	COMMAND

# FIXED-FIXED ROUTINES.

		COUNT	02/IMODE
		
ZEROICDU	CAF	ZERO		# ZERO ICDU COUNTERS.
		TS	CDUX
		TS	CDUY
		TS	CDUZ
		TC	Q

SPSCODE		=	BIT9

# IMU ZEROING ROUTINE.

		BANK	11
		SETLOC	MODESW
		BANK

		COUNT	07/IMODE
		
IMUZERO		INHINT			# ROUTINE TO ZERO ICDUS.
		CS	DSPTAB +11D	# DONT ZERO CDUS IF IMU IN GIMBAL LOCK AND
		MASK	BITS4&6		# COARSE ALIGN (GIMBAL RUNAWAY PROTECTION)
		CCS	A
		TCF	IMUZEROA

		TC	ALARM		# IF SO.
		OCT	00206

		TCF	CAGETSTJ +4	# IMMEDIATE FAILURE.

IMUZEROA	TC	CAGETSTJ

# DO ALL THE WORK.

		CS	IMODES33	# DISABLE DAP AUTO AND HOLD MODES
		MASK	SUPER011	# 	BIT5 FOR GROUND
		ADS	IMODES33

		CS	IMODES30	# INHIBIT ICDUFAIL AND IMUFAIL (IN CASE WE
		MASK	BITS3&4		# JUST CAME OUT OF COARSE ALIGN).
		ADS	IMODES30

		CS	BITS4&6		# SEND ZERO ENCODE WITH COARSE AND ERROR
		EXTEND			# COUNTER DISABLED.
		WAND 	CHAN12

		TC	NOATTOFF	# TURN OFF NO ATT LAMP.

		CAF	BIT5
		EXTEND
		WOR	CHAN12

		TC	ZEROICDU
		CAF	BIT6		# WAIT 320 MS TO GIVE AGS ADEQUATE TIME TO
		TC	WAITLIST	# RECEIVE ITS PULSE TRAIN.
		EBANK=	CDUIND
		2CADR	IMUZERO2

		CS	IMODES30	# SEE IF IMU OPERATING AND ALARM IF NOT.
		MASK	BIT9
		CCS	A
		TCF	MODEEXIT
		TC	ALARM
		OCT	210

MODEEXIT	RELINT			# GENERAL MODE-SWITCHING EXIT.
		TCF	SWRETURN

IMUZERO2	TC	CAGETEST
		TC	ZEROICDU	# ZERO CDUX, CDUY, CDUZ

		CS	BIT5		# REMOVE ZERO DISCRETE.
		EXTEND
		WAND	CHAN12

		CAF	BIT11		# WAIT 10 SECS FOR CTRS TO FIND GIMBALS
		TC	VARDELAY

IMUZERO3	TC	CAGETEST
		CS	BITS3&4		# REMOVE IMUFAIL AND ICDUFAIL INHIBIT.
		MASK	IMODES30
		TS	IMODES30

		CS	SUPER011	# ENABLE DAP AUTO AND HOLD MODES
		MASK	IMODES33	#	BIT5 FOR GROUND
		TS	IMODES33

		TC	IBNKCALL	# SET ISS WARNING IF EITHER OF ABOVE ARE
		CADR	SETISSW		# PRESENT.

		TCF	ENDIMU

# IMU COARSE ALIGN MODE.

IMUCOARS	INHINT
		TC	CAGETSTJ
		TC	SETCOARS

		CAF	SIX
		TC	WAITLIST
		EBANK=	CDUIND
		2CADR	COARS

		TCF	MODEEXIT

COARS		TC	CAGETEST
		CAF	BIT6		# ENABLE ALL THREE ISS CDU ERROR COUNTERS
		EXTEND
		WOR	CHAN12

		CAF	TWO		# SET CDU INDICATOR
COARS1		TS	CDUIND

		INDEX	CDUIND		# COMPUTE THETAD - THETAA IN 1:S
		CA	THETAD		# 	COMPLEMENT FORM
		EXTEND
		INDEX	CDUIND
		MSU	CDUX
		EXTEND
		MP	BIT13		# SHIFT RIGHT 2
		XCH	L		# ROUND
		DOUBLE
		TS	ITEMP1
		TCF	+2
		ADS	L

		INDEX	CDUIND		# DIFFERENCE TO BE COMPUTED
		LXCH	COMMAND
		CCS	CDUIND
		TC	COARS1

		CAF	TWO		# MINIMUM OF 4 MS WAIT
		TC 	VARDELAY

COARS2		TC	CAGETEST	# DONT CONTINUE IF CAGED.
		TS	ITEMP1		# SETS TO +0.
		CAF	TWO		# SET CDU INDICATOR
 +3		TS	CDUIND

		INDEX	CDUIND
		CCS	COMMAND		# NUMBER OF PULSES REQUIRED
		TC	COMPOS		# GREATER THAN MAX ALLOWED
		TC	NEXTCDU +1
		TC	COMNEG
		TC	NEXTCDU +1

COMPOS		AD	-COMMAX		# COMMAX = MAX NUMBER OF PULSES ALLOWED
		EXTEND			# 	MINUS ONE
		BZMF	COMZERO
		INDEX	CDUIND
		TS	COMMAND		# REDUCE COMMAND BY MAX NUMBER OF PULSES
		CS	-COMMAX-	# 	ALLOWED

NEXTCDU		INCR	ITEMP1
		AD	NEG0
		INDEX	CDUIND
		TS	CDUXCMD		# SET UP COMMAND REGISTER.

		CCS	CDUIND
		TC	COARS2 +3

		CCS	ITEMP1		# SEE IF ANY PULSES TO GO OUT.
		TCF	SENDPULS

		TC	FIXDELAY	# WAIT FOR GIMBALS TO SETTLE.
		DEC	150

		CAF	TWO		# AT END OF COMMAND, CHECK TO SEE THAT
CHKCORS		TS	ITEMP1		# GIMBALS ARE WITHIN 2 DEGREES OF THETAD.
		INDEX	A
		CA	CDUX
		EXTEND
		INDEX	ITEMP1
		MSU	THETAD
		CCS	A
		TCF	COARSERR
		TCF	CORSCHK2
		TCF	COARSERR

CORSCHK2	CCS	ITEMP1
		TCF	CHKCORS
		TCF	ENDIMU		# END OF COARSE ALIGNMENT.

COARSERR	AD	COARSTOL	# 2 DEGREES.
		EXTEND
		BZMF	CORSCHK2

		TC	ALARM		# COARSE ALIGN ERROR.
		OCT	211

		TCF	IMUBAD

COARSTOL	DEC	-.01111		# 2 DEGREES SCALED AT HALF-REVOLUTIONS

COMNEG		AD	-COMMAX
		EXTEND
		BZMF	COMZERO
		COM
		INDEX	CDUIND
		TS	COMMAND
		CA	-COMMAX-
		TC	NEXTCDU

COMZERO		CAF	ZERO
		INDEX	CDUIND
		XCH	COMMAND
		TC	NEXTCDU

SENDPULS	CAF	13,14,15
		EXTEND
		WOR	CHAN14
		CAF	600MS
		TCF	COARS2 -1	# THEN TO VARDELAY

CA+ECE		CAF	BIT6		# ENABLE ALL THREE ISS CDU ERROR COUNTERS
		EXTEND
		WOR	CHAN12
		TC	TASKOVER

SETCOARS	CAF	BIT4		# BYPASS IF ALREADY IN COARSE ALIGN
		EXTEND
		RAND	CHAN12
		CCS	A
		TC	Q

		CS	BIT6		# CLEAR ISS ERROR COUNTERS
		EXTEND
		WAND	CHAN12

		CS	BIT10		# KNOCK DOWN GYRO ACTIVITY
		EXTEND
		WAND	CHAN14
		CS	ZERO
		TS	GYROCMD

		CAF	BIT4		# PUT ISS IN COARSE ALIGN
		EXTEND
		WOR	CHAN12

		CS	DSPTAB +11D	# TURN ON NO ATT LAMP
		MASK	OCT40010
		ADS	DSPTAB +11D

		CS	IMODES33	# DISABLE DAP AUTO AND HOLD MODES
		MASK	BIT6
		ADS	IMODES33

		CS	IMODES30	# DISABLE IMUFAIL
		MASK	BIT4
		ADS	IMODES30

RNDREFDR	CS	BIT5		# KNOCK DOWN TRACK FLAG
		MASK	FLAGWRD1
		TS	FLAGWRD1

		CS	BIT15		# KNOCK DOWN DRIFT FLAG
		MASK	FLAGWRD2
		TS	FLAGWRD2

		CS	BIT13		# KNOCK DOWN REFSMMAT FLAG
		MASK	FLAGWRD3
		TS	FLAGWRD3

		TC	Q

OCT40010	OCT	40010

# IMU FINE ALIGN MODE SWITCH.

IMUFINE		INHINT
		TC	CAGETSTJ	# SEE IF IMU BEING CAGED.

		CS	BITS4-5		# RESET ZERO AND COARSE
		EXTEND
		WAND	CHAN12

		CS	BIT6		# INSURE DAP AUTO AND HOLD MODES ENABLED
		MASK	IMODES33
		TS	IMODES33

		TC	NOATTOFF

		CAF	BIT10		# IMU FAIL WAS INHIBITED DURING THE
		TC	WAITLIST	# PRESUMABLY PRECEDING COARSE ALIGN.  LEAVE
		EBANK=	CDUIND
		2CADR	IFAILOK		# IT ON FOR THE FIRST 5 SECS OF FINE ALIGN

		CAF	2SECS
		TC	WAITLIST
		EBANK=	CDUIND
		2CADR	IMUFINED

		TCF	MODEEXIT

IMUFINED	TC	CAGETEST	# SEE THAT NO ONE HAS CAGED THE IMU.
		TCF	ENDIMU

IFAILOK		TC	CAGETSTQ	# ENABLE IMU FIAL UNLESS IMU BEING CAGED.
		TCF	TASKOVER	# IT IS.

		CAF	BIT4		# DONT RESET IMU FAIL INHIBIT IF SOMEONE
		EXTEND			# HAS GONE INTO COARSE ALIGN.
		RAND	CHAN12
		CCS	A
		TCF	TASKOVER

		CS	IMODES30	# RESET IMUFAIL.
		MASK	BIT13
		ADS	IMODES30
		CS	BIT4
PFAILOK2	MASK	IMODES30
		TS	IMODES30
		TC	IBNKCALL	# THE ISS WARNING LIGHT MAY COME ON NOW
		CADR	SETISSW		# THAT THE INHIBIT HAS BEEN REMOVED.
		TCF	TASKOVER

PFAILOK		TC	CAGETSTQ	# ENABLE PIP FAIL PROG ALARM.
		TCF	TASKOVER

		CS	IMODES30	# RESET IMU AND PIPA FAIL BITS.
		MASK	BIT10
		ADS	IMODES30

		CS	IMODES33
		MASK	BIT13
		ADS	IMODES33

		CS	BIT5
		TCF	PFAILOK2

NOATTOFF	CS	OCT40010	# SUBROUTINE TO TURN OFF NO ATT LAMP.
		MASK	DSPTAB +11D
		AD	BIT15
		TS	DSPTAB +11D
		TC	Q

# ROUITNES TO INITIATE AND TERMINATE PROGRAM USE OF THE PIPAS.  NO IMUSTALL REQUIRED IN EITHER CASE.

PIPUSE		CS	ZERO
		TS	PIPAX
		TS	PIPAY
		TS	PIPAZ

PIPUSE1		TC	CAGETSTQ	# DO NOT ENABLE PIPA FAIL IF IMU IS CAGED
		TCF	SWRETURN

		INHINT
		CS	BIT1		# IF PIPA FAILS FROM NOW ON (UNTIL
		MASK	IMODES30	# PIPFREE), LIGHT ISS WARNING.
		TS	IMODES30

PIPFREE2	TC	IBNKCALL	# ISS WARNING MIGHT COME ON NOW.
		CADR	SETISSW		# (OR GO OFF ON PIPFREE).

		TCF	MODEEXIT

PIPFREE		INHINT			# PROGRAM DONE WITH PIPAS.  DONT LIGHT
		CS	IMODES30	# ISS WARNING.
		MASK	BIT1
		ADS	IMODES30

		MASK	BIT10		# IF PIP FAIL ON, DO PROG ALSRM AND RESET
		CCS	A		# ISS WARNING.
		TCF	MODEEXIT

		TC	ALARM
		OCT	212

		INHINT

		TCF	PIPFREE2

# THE FOLLOWING ROUTINE TORQUES THE IRIGS ACCORDING TO DOUBLE PRECISION INPUTS IN THE SIX REGISTERS
# BEGINNING AT THE ECADR ARRIVING IN A.  THE MINIMUM SIZE OF ANY PULSE TRAIN IS 16 PULSES (.25 CDU COUNTS).  THE
# UNSENT PORTION OF THE COMMAND IS LEFT INTACT IN THE INPUT COMMAND REGISTERS.

		EBANK=	1400		# VARIABLE, ACTUALLY.

IMUPULSE	TS	MPAC +5		# SAVE ARRIVING ECADR.
		TC	CAGETSTJ	# DONT PROCEED IF IMU BEING CAGED.

		CCS	LGYRO		# SEE IF GYROS BUSY.
		TC	GYROBUSY	# SLEEP.

		TS	MPAC +2
		CAF	BIT6		# ENABLE THE POWER SUPPLY.
		EXTEND
		WOR	CHAN14

		CAF	FOUR
GWAKE2		TC	WAITLIST	# (IF A JOB WAS PUT TO SLEEP, THE POWER
		EBANK=	CDUIND		# SUPPLY IS LEFT ON BY THE WAKING JOB).
		2CADR	STRTGYRO

		CA	MPAC +5		# SET UP EBANK, SAVING CALLER'S EBANK FOR
		XCH	EBANK		# RESTORATION ON RETURN.
		XCH	MPAC +5
		TS	LGYRO		# RESERVES GYROS.
		MASK	LOW8
		TS	ITEMP1

		CAF	TWO		# FORCE SIGN AGREEMENT ON INPUTS.
GYROAGRE	TS	MPAC +3
		DOUBLE
		AD	ITEMP1
		TS	MPAC +4
		EXTEND
		INDEX	A
		DCA	1400
		DXCH	MPAC
		TC	TPAGREE
		DXCH	MPAC
		INDEX	MPAC +4
		DXCH	1400

		CCS	MPAC +3
		TCF	GYROAGRE

		CA	MPAC +5		# RESTORE CALLER'S EBANK.
		TS	EBANK
		TCF	MODEEXIT

# ROUTINES TO ALLOW TORQUING BY ONLY ONE JOB AT A TIME.

GYROBUSY	EXTEND			# SAVE RETURN 2FCADR.
		DCA	BUF2
		DXCH	MPAC
REGSLEEP	CAF	LGWAKE
		TCF	JOBSLEEP

GWAKE		CCS	LGYRO		# WHEN AWAKENED, SEE IF GYROS STILL BUSY.
		TCF	REGSLEEP	# IF SO, SLEEP SOME MORE.

		TS	MPAC +2
		EXTEND
		DCA	MPAC
		DXCH	BUF2		# RESTORE SWRETURN INFO.
		CAF	ONE
		TCF	GWAKE2

LGWAKE		CADR	GWAKE

# GYRO-TORQUING WAITLIST TASKS.

STRTGYRO	CS	GDESELCT	# DE-SELECT LAST GYRO.
		EXTEND
		WAND	CHAN14

		TC	CAGETEST

STRTGYR2	CA	LGYRO		# JUMP ON PHASE COUNTER IN BITS 13-14.
		EXTEND
		MP	BIT4
		INDEX	A
		TCF	+1
		TC	GSELECT		# =0.  DO Y GYRO.
		OCT	00202

		TC	GSELECT		# =1.  DO Z GYRO.
		OCT	00302

		TC	GSELECT -2	# =2.  DO X GYRO.
		OCT	00100

		CAF	ZERO		# =3.  DONE
		TS	LGYRO
		CAF	LGWAKE		# WAKE A POSSIBLE SLEEPING JOB.
		TC	JOBWAKE

NORESET		TCF	IMUFINED	# DO NOT RESET POWER SUPPLY
 -2		CS	FOUR		# SPECIAL ENTRY TO REGRESS LGYRO FOR X.
		ADS	LGYRO

GSELECT		INDEX	Q		# SELECT GYRO.
		CAF	0		# PACKED WORD CONTAINS GYRO SELECT BITS
		TS	ITEMP4		# AND INCREMENT TO LGYRO.
		MASK	SEVEN
		AD	BIT13
		ADS	LGYRO
		TS	EBANK
		MASK	LOW8
		TS	ITEMP1

		CS	SEVEN
		MASK	ITEMP4
		TS	ITEMP4

		EXTEND			# MOVE DP COMMAND TO RUPTREGS FOR TESTING.
		INDEX	ITEMP1
		DCA	1400
		DXCH	RUPTREG1

		CCS	RUPTREG1
		TCF	MAJ+
		TCF	+2
		TCF	MAJ-

		CCS	RUPTREG2
		TCF	MIN+
		TCF	STRTGYR2
		TCF	MIN-
		TCF	STRTGYR2

MIN+		AD	-GYROMIN	# SMALL POSITIVE COMMAND.  SEE IF AT LEAST
		EXTEND			# 16 GYRO PULSES.
		BZMF	STRTGYR2

MAJ+		EXTEND			# DEFINITE POSITIVE OUTPUT.
		DCA	GYROFRAC
		DAS	RUPTREG1

		CA	ITEMP4		# SELECT POSITIVE TORQUING FOR THIS GYRO.
		EXTEND
		WOR	CHAN14

		CAF	LOW7		# LEAVE NUMBER OF POSSIBLE 8192 AUGMENTS
		MASK	RUPTREG2	# TO INITIAL COMMAND IN MAJOR PART OF LONG
		XCH	RUPTREG2	# TERM STORAGE AND TRUNCATED FRACTION
GMERGE		EXTEND			# IN MINOR PART.  THE MAJOR PART WILL BE
		MP	BIT8		# COUNTED DOWN TO ZERO IN THE COURSE OF
		TS	ITEMP2		# PUTTING OUT THE ENTIRE COMMAND.
		CA	RUPTREG1
		EXTEND
		MP	BIT9
		TS	RUPTREG1
		CA	L
		EXTEND
		MP	BIT14
		ADS	ITEMP2		# INITIAL COMMAND.

		EXTEND			# SEE IF MORE THAN ONE PULSE TRAIN NEEDED
		DCA	RUPTREG1	# (MORE THAN 16383 PULSES).
		AD	MINUS1
		CCS	A
		TCF	LONGGYRO
-GYROMIN	OCT	-176		# MAY BE ADJUSTED TO SPECIFY MINIMUM CMD
		TCF	+4

		CAF	BIT14
		ADS	ITEMP2
		CAF	ZERO

 +4		INDEX	ITEMP1
		DXCH	1400
		CA	ITEMP2		# ENTIRE COMMAND.
LASTSEG		TS	GYROCMD
		EXTEND
		MP	BIT10		# WAITLIST DT
		AD	THREE		# TRUNCATION AND PHASE UNCERTAINTIES.
		TC	WAITLIST
		EBANK=	CDUIND
		2CADR	STRTGYRO

GYROEXIT	CAF	BIT10
		EXTEND
		WOR	CHAN14
		TCF	TASKOVER

LONGGYRO	INDEX	ITEMP1
		DXCH	1400		# INITIAL COMMAND OUT PLUS N AUGMENTS OF
		CAF	BIT14		# 8192.  INITIAL COMMAND IS AT LEAST 8192.
		AD	ITEMP2
		TS	GYROCMD

AUG3		EXTEND			# GET WAITLIST DT TO TIME WHEN TRAIN IS
		MP	BIT10		# ALMOST OUT.
		AD	NEG3
		TC	WAITLIST
		EBANK=	CDUIND
		2CADR	8192AUG

		TCF	GYROEXIT

8192AUG		TC	CAGETEST

		CAF	BIT4
		EXTEND
		RAND	CHAN12
		CCS	A
		TCF	IMUBAD
		CA	LGYRO		# ADD 8192 PULSES TO GYROCMD
		TS	EBANK
		MASK	LOW8
		TS	ITEMP1

		INDEX	ITEMP1		# SEE IF THIS IS THE LAST AUG.
		CCS	1400
		TCF	AUG2		# MORE TO COME.

		CAF	BIT14
		ADS	GYROCMD
		TCF	LASTSEG +1

AUG2		INDEX	ITEMP1
		TS	1400
		CAF	BIT14
		ADS	GYROCMD
		TCF	AUG3		# COMPUTE DT.

MIN-		AD	-GYROMIN	# POSSIBLE NEGATIVE OUTPUT.
		EXTEND
		BZMF	STRTGYR2

MAJ-		EXTEND			# DEFINITE NEGATIVE OUTPUT.
		DCS	GYROFRAC
		DAS	RUPTREG1

		CA	ITEMP4		# SELECT NEGATIVE TORQUING FOR THIS GYRO.
		AD	BIT9
		EXTEND
		WOR	CHAN14

		CS	RUPTREG1	# SET UP RUPTREGS TO FALL INTO GMERGE.
		TS	RUPTREG1	# ALL NUMBERS PUT INTO GYROCMD ARE
		CS	RUPTREG2	# POSITIVE - BIT9 OF CHAN 14 DETERMINES
		MASK	LOW7		# THE SIGN OF THE COMMAND.
		COM
		XCH	RUPTREG2
		COM
		TCF	GMERGE

GDESELCT	OCT	1700		# TURN OFF SELECT AND ACTIVITY BITS.

GYROFRAC	2DEC	.215 B-21

# IMU MODE SWITCHING ROUTINES COME HERE WHEN ACTION COMPLETE.

ENDIMU		EXTEND			# MODE IS BAD IF CAGE HAS OCCURED OR IF
		READ	DSALMOUT	# ISS WARNING IS ON.
		MASK	BIT1
		CCS	A
		TCF	IMUBAD

IMUGOOD		TCF	GOODEND		# WITH C(A) = 0.

IMUBAD		CAF	ZERO
		TCF	BADEND

CAGETEST	CAF	BIT6		# SUBROUTINE TO TERMINATE IMU MODE
		MASK	IMODES30	# SWITCH IF IMU HAS BEEN CAGED.
		CCS	A
		TCF	IMUBAD		# DIRECTLY.
		TC	Q		# WITH C(A) = +0.

CAGETSTQ	CS	IMODES30	# SKIP IF IMU NOT BEING CAGED.
		MASK	BIT6
		CCS	A
		INCR	Q
		TC	Q

CAGETSTJ	CS	IMODES30	# IF DURING MODE SWITCH INITIALIZATION
		MASK	BIT6		# IT IS FOUND THAT THE IMU IS BEING CAGED,
		CCS	A		# SET IMUCADR TO -0 TO INDICATE OPERATION
		TC	Q		# COMPLETE BUT FAILED.  RETURN IMMEDIATELY
		CS	ZERO		# TO SWRETURN.
		TS	IMUCADR
		TCF	MODEEXIT

# GENERALIZED MODE SWITCHING TERMINATION.  ENTER AT GOODEND FOR SUCCESSFUL COMPLETION OF AN I/O OPERATION
# OR AT BADEND FOR AN UNSUCCESSFUL ONE.  C(A) OR ARRIVAL =0 FOR IMU, 1 FOR OPTICS.

BADEND		TS	RUPTREG2	# DEVICE INDEX.
		CS	ZERO		# FOR FAILURE.
		TCF	GOODEND +2

GOODEND		TS	RUPTREG2
		CS	ONE		# FOR SUCCESS.

		TS	RUPTREG3
		INDEX	RUPTREG2	# SEE IF USING PROGRAM ASLEEP.
		CCS	MODECADR
		TCF	+2		# YES - WAKE IT UP.
		TCF	ENDMODE		# IF 0, PROGRAM NOT IN YET.

		CAF	ZERO		# WAKE SLEEPING PROGRAM.
		INDEX	RUPTREG2
		XCH	MODECADR
		TC	JOBWAKE

		CS	RUPTREG3	# ADVANCE LOC IF SUCCESSFUL.
		INDEX	LOCCTR
		ADS	LOC

		TCF	TASKOVER

ENDMODE		CA	RUPTREG3	# -0 INDICATES OPERATION COMPLETE BUT
		INDEX	RUPTREG2	# UNSUCCESSFUL - -1 INDICATES COMPLETE AND
		TS	MODECADR	# SUCCESSFUL.
		TCF	TASKOVER

# GENERAL STALLING ROUTINE.  USING PROGRAMS COME HERE TO WAIT FOR I/O COMPLETION.
#
# PROGRAM DESCRIPTION				DATE - 21 FEB 1967
#						LOG SECTION IMU MODE SWITCHING
# MOD BY - R. MELANSON TO ADD DOCUMENTATION	ASSEMBLY SUNDISK REV. 82
#
# FUNCTIONAL DESCRIPTION -
#	TO DELAY FURTHER EXECUTION OF THE CALLING ROUTINE UNTIL ITS SELECTED
#	I/O FUNCTION IS COMPLETE.  THE FOLLOWING CHECKS ON THE CALLING ROUTINE:S
#	MODECADR ARE MADE AND ACTED UPON.
#	1) +0 INDICATES INCOMPLETE I/O OPERATION.  CALLING ROUTINE IS PUT TO
#	   SLEEP.
#	2) -1 INDICATES COMPLETED I/O OPERATION.  STALL BYPASSES JOBSLEEP
#	   CALL AND RETURNS TO CALLING ROUTINE AT L+3
#	3) -0 INDICATES COMPLETED I/O WITH FAILURE.  STALL CLEARS MODECADR
#	   AND RETURNS TO CALLING ROUTINE AT L+2.
#	4) VALUE GREATER THAN 0 INDICATES TWO ROUTINES CALLING FOR USE OF
#	   SAME DEVICE.  STALL EXITS TO ABORT WHICH EXECUTES A PROGRAM
#	   RESTART WHICH IN TURN CLEARS ALL MODECADR REGISTERS.
#
# CALLING SEQUENCE -
#	L 	TC	BANKCALL
#	L+1	CADR	(ONE OF 5 STALL ADDRESSES  I.E. IMUSTALL, OPTSTALL, RADSTALL,
#			AOTSTALL, OR ATTSTALL)
#
# NORMAL-EXIT MODE -
#	TCF JOBSLEEP	OR	TCF MODEXIT
#
# ALARM OR ABORT EXIT MODE -
#	TC	ABORT
#
# OUTPUT -
#	MODECADR=CADR 	IF JOBSLEEP
#	MODECADR=+0	IF I/O COMPLETE
#	BUF2=L+3	IF I/O COMPLETE AND GOOD.
#	BUF2=L+2	IF I/O COMPLETE BUT FAILED.
#
# ERASABLE INITIALIZATION -
#	BUF2 CONTAINS RETURN ADDRESS PLUS 1,(L+2)
#	BUF2+1 CONTAINS FBANK VALUE OF CALLING ROUTINE.
#	MODECADR OF CALLING ROUTINE CONTAINS +0,-1,-0 OR CADR RETURN ADDRESS.
#
# DEBRIS -
#	RUPTREG2 AND CALLING ROUTINE MODECADR.

AOTSTALL	CAF	ONE		# AOT.
		TC	STALL

RADSTALL	CAF	TWO
		TCF	STALL

OPTSTALL	EQUALS	AOTSTALL

IMUSTALL	CAF	ZERO		# IMU.

STALL		INHINT
		TS	RUPTREG2	# SAVE DEVICE INDEX.
		INDEX	A		# SEE IF OPERATION COMPLETE.
		CCS	MODECADR
		TCF	MODABORT	# ALLOWABLE STATES ARE +0, -1, AND -0.
		TCF	MODESLP		# OPERATION INCOMPLETE.
		TCF	MODEGOOD	# COMPLETE AND GOOD IF = -1.

MG2		INDEX	RUPTREG2	# COMPLETE AND FAILED IF -0.  RESET TO +0.
		TS	MODECADR	# RETURN TO CALLER.
		TCF	MODEEXIT

MODEGOOD	CCS	A		# MAKE SURE INITIAL STATE -1.
		TCF	MODABORT

		INCR	BUF2		# IF SO, INCREMENT RETURN ADDRESS AND
		TCF	MG2		# RETURN IMMEDIATELY, SETTING CADR = +0.

MODESLP		TC	MAKECADR	# CALL FROM SWITCHABLE FIXED ONLY.
		INDEX	RUPTREG2
		TS	MODECADR
		TCF	JOBSLEEP

MODABORT	TC	POODOO		# TWO PROGRAMS USING SAME DEVICE.
		OCT	21210

# CONSTANTS FOR MODE SWITCHING ROUTINES

BITS3&4		=	OCT14
BITS4&6		=	OCT50
BITS4-5		EQUALS	BITS4&5
IMUSEFLG	EQUALS	BIT8		# INTERPRETER SWITCH 7.
-COMMAX		DEC	-191
-COMMAX-	DEC	-192
600MS		DEC	60
IMUFIN20	=	IMUFINE
GOMANUR		CA	ATTCADR		# IS KALCMANU FREE
		EXTEND
		BZF	+3
		TC	POODOO		# NO
		OCT	21210		# 2 TRYING TO USE SAME DEVICE

 +3		EXTEND
		DCA	BUF2
		DXCH	ATTCADR		# SAVE FINAL RETURN FOR KALCMAN3

		CA	BBANK
		MASK	SEVEN
		ADS	ATTCADR +1

		CA	PRIORITY
		MASK	PRIO37
		TS	ATTPRIO		# SAVE USERS PRIO

		CAF	KALEBCON	# SET EBANK FOR KALCMAN3
		TS	EBANK
		TC	POSTJUMP
		CADR	KALCMAN3
KALEBCON	ECADR	BCDU

# PROGRAM DESCRIPTION
# IMU STATUS CHECK ROUTINE R02 (SUBROUTINE UTILITY)
# MOD NO - 1
# MOD BY - N.BRODEUR
#
# FUNCTIONAL DESCRIPTION
#	TO CHECK WHETHER IMU IS ON AND IF ON WHETHER IT IS ALIGNED TO AN
# 	ORIENTATION KNOWN BY THE CMC.  TO REQUEST SELECTION OF THE APPROPRIATE
# 	PROGRAM IF THE IMU IS OFF OR NOT ALIGNED TO AN ORIENTATION KNOWN BY THE
#	CMC.  CALLED THROUGH BANKCALL
#
# CALLING SEQUENCE -
#	L	TC	BANKCALL
#	L+1	CADR	R02BOTH
#
# SUBROUTINES CALLED
#	VARALARM
#	FLAGUP
#
# NORMAL EXIT MODES
#	AT L+2 OF CALLING SEQUENCE
#
# ALARM OR ABORT EXIT MODES
#	GOTOPOOH, WITH ALARM
#
# ERASABLE INITIALIZATION REQUIRED
#	NONE
#
# DEBRIS
#	CENTRALS - A,Q,L

		BANK	34
		SETLOC	R02
		BANK
		COUNT	04/R02		# COUNT*
		
DEC51		DEC	51
R02BOTH		CAF	BIT13
		MASK	STATE +3	# REFSMFLG
		CCS	A
		TC	R02ZERO		# ZERO IMUS

		CA	IMODES30
		MASK	BIT9		# IS ISS INITIALIZED
		EXTEND
		BZF	+2
		CS	BIT4		# SEND IMU ALARM CODE 210
		AD	OCT220		# SEND REFSMM ALARM
		TC	VARALARM

		TC	GOTOPOOH

R02ZERO		TC	UPFLAG
		ADRES	IMUSE
		TCF	SWRETURN
OCT220		OCT	220

# PROGRAM DESCRIPTION 	P06 		10FEB67
#
# TRANSFER THE ISS/CMC FROM THE OPERATE TO THE STANDBY CONDITION.
#
# THE NORMAL CONDITION OF READINESS OF THE GNCS WHEN NOT IN USE IS STANDBY.  IN THIS CONDITION THE IMU
# HEATER POWER IS ON.  THE IMU OPERATE POWER IS OFF.  THE COMPUTER POWER IS ON.  THE OPTICS POWER IS OFF.  THE
# CMC STANDBY ON THE MAIN AND LEB DISKYS IS ON.
#
# CALLING SEQUENCE:
#	ASTRONAUT REQUEST THROUGH DSKY	V37E 06E.
#
# SUBROUTINES CALLED:
#	GOPERF1
#	BANKCALL
#	FLAGDOWN
#
# PRESTAND PREPARES FOR STANDBY BY SNAPSHOTTING THE SCALER AND TIME1 TIME2
# THE LOW 5 BITS OF THE SCALER ARE INSPECTED TO INSURE COMPATABILITY
# BETWEEN THE SCALER READING AND THE TIME1 TIME2 READING.

		SETLOC	P05P06
		BANK

		EBANK=	TIME2SAV
		COUNT*	$$/P06

P06		TC	UPFLAG		# SET NODOV37 BIT
		ADRES	NODOFLAG

PRESTAND	INHINT
		EXTEND
		DCA	TIME2		# SNAPSHOT TIME1 TIME2
		DXCH	TIME2SAV
		TC	SCALPREP
		TC	PRESTAND	# T1,T2,SCALER NOT COMPATIBLE
		DXCH	MPAC		# T1,T2 AND SCALER OK
		DXCH	SCALSAVE	# STORE SCALER
		INHINT
		TC	BANKCALL
		CADR	RNDREFDR	# REFSMM, DRIFT, TRACK FLAGS DOWN

		TC	DOWNFLAG
		ADRES	IMUSE		# IMUSE DOWN
		TC	DOWNFLAG
		ADRES	RNDVZFLG	# RNDVZFLG DOWN

		CAF	BIT11
		EXTEND
		WOR	CHAN13		# SET STANDBY ENABLE BIT

		TC	PHASCHNG	# SET RESTART TO POSTAND WHEN STANDBY
		OCT	07024		#	RECOVERS
		OCT	20000
		EBANK=	SCALSAVE
		2CADR	POSTAND

		CAF	OCT62
		TC	BANKCALL
		CADR	GOPERF1
		TCF	-3
		TCF	-4
		TCF	-5

OCT62		EQUALS	.5SEC		# DEC 50 = OCT 62

# THE LOW 5 BITS OF THE SCALER READS 10000 FOR THE FIRST INTERVAL AFTER A
# T1 INCREMENT.  IF SCALPREP DETECTS THIS INTERVAL THE T1,T2 AND SCALER
# DATA ARE NOT COMPATABLE AND RETURN IS TO L+1 FOR ANOTHER READING OF THE
# DATA.  OTHERWISE, THE RETURN IS TO L+2 TO PROCEED.  ROUTINE ALSO PREPARES
# THE SCALER READING FOR COMPUTATION OF THE INCREMENT TO UPDATE T1T2.  (THE
# 10 MS BIT (BIT 6) OF THE SCALER IS INCREMENTED 5 MS OUT OF PHASE FROM
# T1.) ADDITION OF 5 MS (BIT 5) TO THE SCALER READING HAS THE EFFECT OF
# ADJUSTING BIT 6 IN THE SCALER TO BE IN PHASE WITH BIT 1 OF T1.  THE LOW 5
# BITS OF THE SCALER READING ARE THEN SET TO ZERO, TO TRUNCATE THE SCALER
# DATA TO 10 MS.  RESULTS ARE STORED IN MPAC, +1.

SCALPREP	EXTEND
		QXCH	MPAC +2
		TC	FINETIME +1
		RELINT
		DXCH	MPAC
		CA	BIT5		# ADD 5 MS TO THE SCALER READING.
		TS	L
		CA	ZERO
		DAS	MPAC
		CS	LOW5		# SET LOW 5 BITS OF (SCALER+5MS) TO ZERO
		MASK 	MPAC +1		# AND STORE RESULTS IN MPAC,+1.
		XCH	MPAC +1
		MASK	LOW5		# TEST LOW 5 BITS OF SCALER FOR THE FIRST
					# INTERVAL AFTER THE T1 INCREMENT
					# (NOW = 00000, SINCE BIT 5 ADDED).
		CCS	A		# IS IT 1ST INTERVAL AFTER T1 INCREMENT
		INCR	MPAC +2		# NO
		TC	MPAC +2		# YES

# POSTAND RECOVERS TIME AFTER STANDBY.  THE SCALER IS SNAPSHOTTED AND THE
# TIME1 TIME2 COUNTER IS SET TO ZERO.  THE LOW 5 BITS OF THE SCALER ARE
# INSPECTED TO INSURE COMPATABILITY BETWEEN THE SCALER READING AND THE
# CLEARING OF THE TIME COUNTER.  IT THEN COMPUTES THE DIFFERENCE IN SCALER
# VALUES (IN DP) AND ADDS THIS TO THE PREVIOUSLY SNAPSHOTTED VALUES OF
# TIME1 TIME2 AND PLACES THIS NEW TIME INTO THE TIME1 TIME2 COUNTER.

		COUNT*	$$/P05

POSTAND		CS	BIT11		# RECOVER TIME AFTER STANDBY.
		EXTEND
		WAND	CHAN13		# CLEAR STANDBY ENABLE BIT
		INHINT
		CA	ZERO
		TS	L
		DXCH	TIME2		# CLEAR TIME1 TIME2
		TC	SCALPREP	# STORE SCALER IN MPAC, MPAC+1
		TC	POSTAND +3	# T1,T2,SCALER NOT COMPATIBLE
		EXTEND			# T1,T2 AND SCALER OK
		DCS	SCALSAVE
		DAS	MPAC		# FORM DP DIFFERENCE OF POSTSTANDBY SCALER
		CAF	BIT10		# MINUS PRESTANDBY SCALER AND SHIFT RIGHT
		TC	SHORTMP		# 5 TO ALIGN BITS WITH TIME1 TIME2.
		CAF	ZERO
		TS	MPAC +2		# NEEDED FOR TP AGREE
		TC	TPAGREE		# MAKE DP DIFF AGREE
		CCS	MPAC
		TC	POSTCOM		# IF DP DIFF NET +, NO SCALER OVERFLOW
		TC	POSTCOM		# BETWEEN PRE AND POST STANDBY.
		TC	+1		# IF DP DIFF NET -, SCALER OVERFLOWED.  ADD
		CAF	BIT10		# BIT 10 TO HIGH DIFF TO CORRECT.
		ADS	MPAC
POSTCOM		EXTEND			# C(MPAC,+1) IS MAGNITUDE OF DELTA SCALER.
		DCA	TIME2SAV	# PRESTANDBY TIME1 TIME2
		DAS	MPAC
		TC	TPAGREE		# FORCE SIGN AGREEMENT
		DXCH	MPAC		# UPDATED VALUE FOR T1,T2.
		DAS	TIME2		# LOAD UPDATED VALUE INTO T1,T2, WITH
		TC	DOWNFLAG	# CLEAR NODOFLAG
		ADRES	NODOFLAG

		TC	GOTOPOOH
		


