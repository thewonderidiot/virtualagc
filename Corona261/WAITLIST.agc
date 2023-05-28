### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	WAITLIST.agc
## Purpose:	Part of the source code for Solarium build 55. This
##		is for the Command Module's (CM) Apollo Guidance
##		Computer (AGC), for Apollo 6.
## Assembler:	yaYUL --block1
## Contact:	Jim Lawton <jim DOT lawton AT gmail DOT com>
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2009-09-21 JL	Created.
##		2016-08-18 RSB	Some fixes.
## 		2016-12-28 RSB	Proofed comment text using octopus/ProoferComments,
##				and fixed errors found.


# CHECK-OUT STATUS - UNIT VERIFICATION COMPLETE MAY, 1965		EXCEPT LONGCALL SECTION.
#
# DO NOT CHANGE THIS SECTION WITHOUT PRB APPROVAL.
#
# GROUNDRULE....DELTA T SHOULD NOT EXCEED 12000 (= 2 MINUTES)

		BANK	1
WAITLIST	TS	DELT		# STORE DELTA T = TD - T (TD = DESIRED
		XCH	Q		#   TIME FOR FUTURE ACTION).
		TC	EXECCOM		# PICK UP TASK ADDRESS AND SAVE BANKREG.
		TC	WTLST3

		BANK	4
WTLST3		CS	TIME3
		AD	+1		# CCS  A  = + 1/4
		CCS	A		# TEST  1/4 - C(TIME3).  IF POSITIVE,
					# IT MEANS THAT TIME3 OVERFLOW HAS OCCURRED PRIOR TO CS  TIME3 AND THAT
					# C(TIME3) = T - T1, INSTEAD OF 1.0 - (T1 - T).  THE FOLLOWING FOUR
					# ORDERS SET C(A) = TD - T1 + 1 IN EITHER CASE.  C(CSQ) = CS  Q = 40001
					# AND  C(TSQ) = TS  Q = 50001   NOTATION...   1 - 00001,  1.0 = 37777+1

		AD	CSQ		# OVERFLOW HAS OCCURRED.  SET C(A) = 
		CS	A		# T - T1 + 3/4 - 1

# NORMAL CASE (C(A) MINUS) YIELDS SAME C(A)  -(-(1.0-(T1-T))+1/4)-1

		AD	TSQ		# TS  Q  = - 3/4 + 2
		AD	DELT		# RESULT = TD - T1 + 1
					#		10W		
		CCS	A		# TEST TD - T1 + 1

		AD	LST1		# IF TD - T1 POS, GO TO WTLST5 WITH
		TC	WTLST5		# C(A) = (TD - T1) + C(LST1) = TD-T2+1

		TC	+1
		CS	DELT

# NOTE THAT THIS PROGRAM SECTION IS NEVER ENTERED WHEN T-T1 G/E -1, 
# SINCE TD-T1+1 = (TD-T) + (T-T1+1), AND DELTA T = TD-T G/E +1.  (G/E
# SYMBOL MEANS GREATER THAN OR EQUAL TO).  THUS THERE NEED BE NO CON-
# CERN OVER A PREVIOUS OR IMMINENT OVERFLOW OF TIME3 HERE.

		AD	POS1/2		# WHEN TD IS NEXT, FORM QUANTITY
		AD	POS1/2		#   1.0 - DELTA T = 1.0 - (TD - T)
		XCH	TIME3
		AD	MSIGN
		AD	DELT
		TS	DELT
		CAF	ZERO
		XCH	DELT
WTLST4		XCH	LST1
		XCH	LST1 +1
		XCH	LST1 +2
		XCH	LST1 +3
		XCH	LST1 +4
		XCH	LST1 +5
		XCH	LST1 +6
		XCH	EXECTEM2	# TASK ADDRESS.
		INDEX	NVAL
		TC	+1
		XCH	LST2
		XCH	LST2 +1
		XCH	LST2 +2
		XCH	LST2 +3
		XCH	LST2 +4
		XCH	LST2 +5		# AT END, CHECK THAT C(LST2+5) IS STD
		XCH	LST2 +6
		XCH	LST2 +7
		AD	ENDTASK		#   END ITEM, AS CHECK FOR EXCEEDING
					#   THE LENGTH OF THE LIST.
		CCS	A
		TC	ABORT		# WAITLIST OVERFLOW.
		OCT	01203
		TC	-2

		XCH	EXECTEM1	# RETURN TO CALLER.
		TC	LVWTLIST	# SAME ROUTINE AS FINDVAC, ETC., EXIT.


WTLST5		CCS	A		# TEST  TD - T2 + 1
		AD	LST1 +1
		TC	+4
		AD	ONE
		TC	WTLST2
		OCT	1

 +4		CCS	A		# TEST  TD - T3 + 1
		AD	LST1 +2
		TC	+4
		AD	ONE
		TC	WTLST2
		OCT	2

 +4		CCS	A		# TEST  TD - T4 + 1
		AD	LST1 +3
		TC	+4
		AD	ONE
		TC	WTLST2
		OCT	3

 +4		CCS	A		# TEST  TD - T5 + 1
		AD	LST1 +4
		TC	+4
		AD	ONE
		TC	WTLST2
		OCT	4

 +4		CCS	A		# TEST  TD - T6 + 1
		AD	LST1 +5
		TC	+4
		AD	ONE
		TC	WTLST2
		OCT	5

 +4		CCS	A
		AD	LST1 +6
		TC	+4
		AD	ONE
		TC	WTLST2
		OCT	6

 +4		CCS	A
		TC	WTALARM
		NOOP
		AD	ONE
		TC	WTLST2
		OCT	7

WTALARM		TC	ABORT
		OCT	01204

LVWTLIST	EQUALS	FOUNDVAC

SVCT3X		CCS	FLAGWRD2	# IF DURING FREE-FALL AND AFTER
		TC	TASKOVER	# PLATFORM HAS BEEN ALIGNED, COMPENSATE
		TC	TASKOVER	# FOR GYRO BIAS DRIFT.
		TC	+1

		CAF	PRIO35
		TC	NOVAC
		CADR	BIASONLY
LTSKOV		TC	TASKOVER	# USED BY LONGCALL.

# C(TIME3) = 1.0 - (T1 - T)
#
# C(LST1  ) = - (T2 - T1) + 1
# C(LST1+1) = - (T3 - T2) + 1
# C(LST1+2) = - (T4 - T3) + 1
# C(LST1+3) = - (T5 - T4) + 1
# C(LST1+4) = - (T6 - T5) + 1

# C(LST2  ) = TC  TASK1
# C(LST2+1) = TC  TASK2
# C(LST2+2) = TC  TASK3
# C(LST2+3) = TC  TASK4
# C(LST2+4) = TC  TASK5
# C(LST2+5) = TC  TASK6						11W


# THE ENTRY TO WTLST2 JUST PRECEDING OCT  N  IS FOR T  LE TD LE T   -1.
#                                                    N           N+1
# (LE MEANS LESS THAN OR EQUAL TO).  AT ENTRY, C(A) = -(TD - T   + 1)
#                                                             N+1
#
# THE LST1 ENTRY -(T   - T +1) IS TO BE REPLACED BY -(TD - T + 1), AND
#                   N+1   N                                 N
#
# THE ENTRY -(T   - TD + 1) IS TO BE INSERTED IMMEDIATELY FOLLOWING.
#              N+1

WTLST2		XCH	Q		# NEW C(Q) = -(TD - T   + 1)
		INDEX	A		#                    N+1
		CAF	0
		TS	NVAL		# VALUE OF N INTO NVAL

		CAF	ONE
		AD	Q
		INDEX	NVAL		# C(A) = -(TD - T ) + 1.
		AD	LST1 -1		#                N

		INDEX	NVAL
		TS	LST1 -1

		CS	Q		# -C(Q) = -(T    - TD) + 1
		INDEX	NVAL		#            N+1
		TC	WTLST4


# THIS ROUTINE HANDLES TASKS MORE THAN 120 SECS IN THE FUTURE. IT REQUIRES CALL TIME IN LONGTIME, +1 SCALED SAME
# AS TIME2, 1 AND THE TASK ADDRESS IN CALLCADR. ENTER WITH
#								TC	IBNKCALL
#								CADR	LONGCALL
# THE ROUTINE ONLY HANDLES ONE CALL AT A TIME

LONGCALL	XCH	Q
		TS	LONGEXIT

		XCH	LONGTIME +1
		DOUBLE
		TS	LONGTIME +1
		CAF	ZERO
		AD	LONGTIME
		AD	LONGTIME
		TS	LONGTIME
		TC	+2
		TC			# ERROR TRAP.   DT TOO BIG

		CAF	ONE
		AD	LONGTIME +1
		AD	POSMAX
		TS	LONGTIME +1
		CAF	ZERO

		AD	LONGTIME
		AD	POSMAX
		TS	LONGTIME
		TC	CCSHOLE

		CAF	BIT14
		EXTEND
		MP	LONGTIME +1
		TS	LONGTIME +1

LONGCYCL	CCS	LONGTIME
		TC	LOOPAGIN

		CCS	LONGTIME +1	# TEST FOR LOWER ORDER ZERO
		TC	+2
		TC	GETCADR

		XCH	LONGTIME +1
		TC	WAITLIST
		CADR	GETCADR

		TC	LONGC1
LOOPAGIN	TS	LONGTIME
		CAF	BIT14
		TC	WAITLIST
		CADR	LONGCYCL

LONGC1		CAF	LTSKOV
		XCH	LONGEXIT
		XAQ

GETCADR		XCH	CALLCADR
		TC	BANKJUMP


#	ENTERS HERE ON T3 RUPT TO DISPATCH WAITLISTED TASK.

		SETLOC	WAITLIST +4	# BACK TO FF.

T3RUPT		XCH	BANKREG		#  TIME 3 OVERFLOW INTERRUPT PROGRAM
		TS	BANKRUPT
		XCH	OVCTR		# 1.  PICK UP CONTENTS OF THE OVERFLOW
		TS	OVRUPT		#    AND SAVE IN OVRUPT FOR ENTIRE T3RUPT.

T3RUPT2		CS	ZERO		# SET RUPTAGN TO -0 INITIALLY, AND SET
		TS	RUPTAGN		# T3 TO -0 WHILE WE MAKE UP ITS NEW
		XCH	TIME3		# CONTENTS SO WE CAN DETECT AN INCREMENT
		TS	Q		# OCCURING IN THE PROCESS.

		CAF	NEG1/2
		XCH	LST1 +6
		XCH	LST1 +5
		XCH	LST1 +4		# 3.  MOVE UP LST1 CONTENTS, ENTERING
		XCH	LST1 +3		#     A VALUE OF 1/2 +1 AT THE BOTTOM
		XCH	LST1 +2		#     FOR T6-T5, CORRESPONDING TO THE
		XCH	LST1 +1		#     INTERVAL 81.93 SEC FOR ENDTASK.
		XCH	LST1
		AD	POSMAX		# 4. SET T3 = 1.0 - T2 -T USING LIST 1.
		AD	Q		# SAMPLED T3.
		TS	A		# SEE IF NEW T3 HAS OVERFLOW. IF SO, NEXT
		TC	+4		# TASK IS DUE THIS T3 RUPT AND SET RUPTAGN
		XCH	RUPTAGN		# ACCORDINGLY.
		CAF	ONE
		XCH	RUPTAGN

 +4		XCH	TIME3
		CCS	A		# T3 IS ALMOST ALWAYS -0 UNLESS AN
		CAF	ONE		# INCREMENT OCCURRED IN WHICH CASE WE MUST
		AD	TIME3		# ADD IT TO THE NEW T3.
		TC	XTRAINC


T3DSP		CS	ENDTASK
		XCH	LST2 +7
		XCH	LST2 +6
		XCH	LST2 +5		#	ENTERING THE ENDTASK AT BOTTOM.
		XCH	LST2 +4
		XCH	LST2 +3
		XCH	LST2 +2
		XCH	LST2 +1
		XCH	LST2		# 9.  PICK UP TOP TASK ON LIST

		TS	BANKREG		# SWITCH BANKS IF NECESSARY
		TS	ITEMP1
		MASK	70K
		CCS	A
		TC	+2		# IF +
		TC	ITEMP1
		XCH	ITEMP1
		MASK	LOW10
		INDEX	A
		TC	6000



# RETURN, AFTER EXECUTION OF TIME3 OVERFLOW TASK.

TASKOVER	CCS	RUPTAGN		# IF +1 RETURN TO T3RUPT, IF -0 RESUME.
		TC	T3RUPT2		# DISPATCH NEXT TASK IF IT WAS DUE.

ENDTASK        -CADR	SVCT3
BANKMASK	OCT	76000

OVRESUME	XCH	OVRUPT		# OVCTR RESTORE AND BANKREG RESTORE.
		TS	OVCTR

RESUME		XCH	BANKRUPT	# STANDARD BANK-SWITCH RESUME.
		TS	BANKREG

NBRESUME	XCH	QRUPT		# NO-BANK-SWITCH RESUME.
		TS	Q
		XCH	ARUPT
		RESUME

#	FINISH UP RARE EVENT OF EXTRA INCREMENT TO T3.

XTRAINC		TS	TIME3
		TC	T3DSP		# USUAL CASE.
		TS	RUPTAGN		# EVEN MORE RARE - THE NEXT TASK IS DUE
		TC	T3DSP		# THIS T3RUPT.

		