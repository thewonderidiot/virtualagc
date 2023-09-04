### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	P15.agc
## Purpose:	Part of the source code for Artemis (i.e., Colossus 3),
##		build 072.  This is for the Command Module's (CM) 
##		Apollo Guidance Computer (AGC), for 
##		Apollo 15-17.
## Assembler:	yaYUL
## Contact:	Hartmuth Gutsche <hgutsche@xplornet.com>
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2009-12-17 HG	Initial version
##		2010-01-26 JL	Updated header comments.
##		2010-01-26 JL	Minor updates.
##		2010-01-31 JL	Fixed build errors.
##		2010-02-20 RSB	Un-##'d this header.
##		2017-02-05 RSB	Proofed comment-text the old-fashioned
##				way.  (No corresponding file in any
##				other AGC version to diff against, at 
##				this writing.)


# P15 TLI INITIATE/CUTOFF
#	
#	DISPLAYS N33 : TIME OF SIVB INJECTION SEQUENCE START (TB6)
#	ESTABLISHES T6SET TO BE EXECUTED AT TB6 TIME
#	SETS TLITIG = TB6 + 9:37.6
#	DISPLAYS N14 : INERTIAL VELOCITY MAGNITUDE AT TLI C/O
#	DISPLAYS N95 : TFI - TIME FROM TLITIG (DECREASING)
#		       VG  - VELOCITY-TO-BE-GAINED
#		       V   - INERTIAL VELOCITY MAGNITUDE
#	T6SET : SETS THE SIVB INJECTION SEQUENCE START BIT,
#	ESTABLISHES T6RESET (DT = 10 SECS), AND
#	TURNS ON THE UPLINK ACTIVITY LIGHT
#	T6RESET : CLEARS THE SIVB I.S.S. BIT AND
#	TURNS OFF THE UPLINK ACTIVITY LIGHT
#	P40S/SV : CALLS MIDTOAV1 TO INTEGRATE THE CSM
#	STATE VECTOR TO TLITLIG - 100 AND
#	ESTABLISHES TIGBLNK AT TLITIG - 105
#	TIGBLNK : BLANKS THE DSKY FOR 5 SECS AND
#	ESTABLISHES TIGAVEG FOR TLITIG - 100 
#	TIGAVEG : STARTS READACCS AND REDISPLAYS
#	N95 (VG AND V NOW DYNAMIC)
#	SIVBCOMP : UPDATES VG AND V AND
#	AFTER TLITIG + 10 CALCULATES TGO AND
#	CHANGES THE N95 R1 DISPLAY TO TFC
#	WHEN TGO < 4 SECS, SIVBCOMP ESTABLISHES SIVBOFF (DT = TGO)
#	SIVBOFF : SHUTS DOWN THE SIVB AND CALLS POSTTLI
#	POSTTLI : FLASHES N95 TO INDICATE TLI IS COMPLETED
#	P15 EXITS VIA GOTOPOOH
		SETLOC	P15LOC1
		BANK
		COUNT*	$$/P15
		EBANK=	TIG
P15JOB		CAF	V06N33		# DISPLAY TB6 TIME
		TC	VNFLASH
		TC	INTPRET
		DLOAD	DAD
			TIG
			TLIDT
		STORE	TLITMP
		RTB	BDSU
			LOADTIME
			TIG
		STORE	P40TMP		# TIG-TIME2
		EXIT			# .TO P40TMP
		DXCH	MPAC		# ..AND A,L
		TC	LONGCALL
		EBANK=	P40TMP
		2CADR	T6SET
		TC	2PHSCHNG
		OCT	00153		# A,3.15=T6SET IN P40TMP CSEC
		OCT	24024		# C,JOB BELOW,LONGBASE FOR A ABOVE
3P15SPT1	=	3.15SPOT
		EXTEND
		DCA	TLITMP
		DXCH	TIG		# TLITIG = TB6 + 9:37.6
DISP14		CAF	V06N14		# DISPLAY V AT TLI C/O
		TC	VNFLASH
		TC	INTPRET
		VLOAD	ABVAL
			VRECTCSM	# M/CS B+7
		STORE	VNOW
		BDSU	SET
			VC/O		#      B+7
			TIMRFLAG	# ENABLE CLOKTASK
		STODL	VGTLI		# VGTLI = VC/O - |VRECTCSM| B+7
			S4BCOMP
		STORE	AVEGEXIT	# SET AVERAGEG EXIT TO SIVBCOMP
		EXIT
		CAF	V06N95
		TS	NVWORD1		# ENABLE CLOCKJOB
CLOKNOW		CAF	ONE
		TC	WAITLIST
		EBANK=	TIG
		2CADR	CLOKTASK

		TC	2PHSCHNG
		OCT	40036		# 6.3SPOT FOR CLOKTASK
		OCT	00004		# KILL GROUP 4
6P3SPT4		=	6.3SPOT
		TCF	ENDOFJOB

TLIDT		2DEC	57760		# 9 MIN 37.6 SEC (TB6 + TLIDT = TLITIG)

		EBANK=	TIG
S4BCOMP		2CADR	SIVBCOMP

V06N14		VN	0614
V06N95		VN	0695


		SETLOC	P15LOC
		BANK
		EBANK=	TIG
		COUNT*	$$/P15
T6SET		EXTEND
		DCA	TIME2
		DXCH	TEVENT
		CAF	10SEC		# T6RESET IN 10 SEC.
		TC	TWIDDLE
		ADRES	T6RESET
		TC	PHASCHNG	
		OCT	40023		# A,3.2=T6CHNSET IMMED.,
					#       T6RESET IN 10 SEC,TBASE NOW

3P2SPT1		=	3.2SPOT
T6CHNSET	CAF	BIT13
		EXTEND			# SIVB INJECTION
		WOR	CHAN12		#  SEQUENCE START
		CAF	BIT3
		EXTEND
		WOR	DSALMOUT	# UPLINK ACTIV. ON
		TC	TASKOVER

10SEC		DEC	1000

T6RESET		CS	BIT13		# PROTECTED BY GROUP 3
		EXTEND			# CLEAR SIVB ISS
		WAND	CHAN12
		CS	BIT3		# TURN OFF UPLINK ACTIVITY
		EXTEND
		WAND	DSALMOUT
		TC	2PHSCHNG
		OCT	00003		# KILL GROUP 3
		OCT	05014
		DEC	-0		# GROUP 4 CONTINUES BELOW
P15INTEG	EXTEND
		DCA	100SEC
		DXCH	AVEGDT		# START AVERAGEG AT TIG - 100.00
		CAF	PRIO12
		TC	FINDVAC
		EBANK=	TIG
		2CADR	P40S/SV		# COMMON CODE IN P40
		TCF	TASKOVER	
		
100SEC		2DEC	10000


# SIVB SHUTDOWN COMPUTATIONS
#
# CALLED VIA AVEGEXIT EVERY 2 SECS STARTING AT TLITIG - 100
#	   VG AND V (N95) ARE ALWAYS UPDATED
#	   TGO CALCULATONS FOR TLI SHUTDOWN AND TTOGO (N95)
#	   ARE ENABLED (STEERSW = 1) AT TLITIG + 10
		SETLOC	P15LOC1
		BANK
		EBANK=	TIG
		COUNT*	$$/P15
SIVBCOMP	TC	INTPRET
		DLOAD	DSU
			TTOGO
			TENSEC		# TFI > +10 ? (TFC CAN NEVER EXCEED +2)
		BMN	SET		# YES, SET STERSW TO ENABLE TGO CALC
			+2		# NO
			STEERSW
		CALL
			S11.1		# VMAG, HDOT, AND H FOR N62
		DLOAD	BDSU
			VNOW		# VMAG      M/CS B+7 FOR N95
			VC/O		# VMAG(C/O) M/CS B+7
		STODL	VGTLI		# VG = VC/O - VNOW FOR N95
			VNOW
		BOFF	DSU
			STEERSW
			SETVPAST	# STEERSW = 0, EXIT
			VPAST		# MPAC = VNOW - VPAST (DV FOR LAST 2 SECS)
		BMN	PUSH		# 00D = DV FOR LAST 2 SECS
			SETVPAST	# DV NEGATIVE, EXIT
		DLOAD	SR
			VGTLI		# B+7
			09D		# SR9 NOW B+16
		DDV			# B+16 / B+7 NOW B+9
		BOV	DMP
			SETVPAST	# OVERFLOW, EXIT
			200B+19		# B+9 X B+19 NOW B+28
		PUSH	SLOAD		# 00D = TGO WITHOUT TAILOFF EFFECTS
			DTF		# TLI TAILOFF CONSTANT B+14
		SR	BDSU		# COMPENSATE FOR TAILOFF
			14D		# B+28
		PUSH	DAD		# 00D = COMPENSATED TGO
			PIPTIME
		STODL	TIG		# FOR CLOKTASK (N95)
		DSU	BMN		# TGO FROM 00D
			4SEC		# TGO < 4 SECS ?
			KILLSIVB	# YES : SET UP SIVB SHUTDOWN
SETVPAST	DLOAD
			VNOW
		STCALL	VPAST		# VPAST = VNOW
			SERVXT1		# ** NO RETURN ** SAME AS GOTO SERVXT1


		EBANK=	TIG
KILLSIVB	EXIT
		INHINT
		EXTEND
		DCA	TIG
		DXCH	MPAC
		EXTEND
		DCS	TIME2
		DAS	MPAC
		TCR	DPAGREE
		CAE	MPAC +1		# DT TO C/O = TIG - TIME2 (< 4 SECS TO GO)
					#	      PIPTIME + TGO - TIME2	
		EXTEND			# DT <= 0 ?
		BZMF	+2		# YES
		TCF	+2		# NO
		CAF	ONE
		TS	AVEGDT +1
		TC	TWIDDLE
		ADRES	SIVBOFF
		TC	2PHSCHNG
		OCT	40614		# 4.61 SIVBOFF IN (AVEGDT+1) CS
		OCT	10035

4P61SPT1	=	4.61SPOT
5P3SPT16	=	5.3SPOT
		TC	POSTJUMP
		CADR	CLEARSTR
		
		EBANK=	WHOCARES
SIVBOFF		CAF	BIT14
		EXTEND
		WOR	CHAN12		# SHUTDOWN THE SIVB
		EXTEND
		DCA	TIME2
		DXCH	TEVENT		# SET TEVENT
		TC	FIXDELAY
		DEC	250		# DELAY 2.5 SECS
		CAF	ZERO
		TS	NVWORD1		# ZERO NVWORD1 IN CASE CLOCKJOB WAITING
		CS	TIMRBIT
		MASK	FLAGWRD7	
		TS	FLAGWRD7	# DISABLE CLOKTASK
		TC	PHASCHNG
		OCT	05014
		DEC	-0		# START BELOW
		CAF	PRIO12
		TC	NOVAC
		EBANK=	WHOCARES
		2CADR	POSTTLI

		TC	TASKOVER

4SEC		2DEC	400
TENSEC		2DEC	1000
200B+19		2DEC	200 B-19


		SETLOC	P15LOC2
		BANK
		EBANK=	WHOCARES

		COUNT*	$$/P15
POSTTLI		CAF	V16N95
		TC	VNFLASH
		TCF	GOTOPOOH


V16N95		VN	1695
