### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	FRESH_START_AND_RESTART.agc
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


# PROGRAM DESCRIPTION						8 APRIL, 1967
#								SUNDISK REV 120
# FUNCTIONAL DESCRIPTION
#
# SLAP1		MAN INITIATED FRESH START
#	1.	EXECUTE STARTSUB
#	2.	TURN OFF DSKY DISCRETE-LAMPS
#	3.	CLEAR FAIL REGISTERS,SELF CHECK ERROR COUNTER AND RESTART
#		COUNTER
#	4.	INITIALIZE OUTBIT CHANNEL 77
#	5.	EXECUTE DOFSTART
#
# DOFSTART	MACHINE INITIATED FRESH START
#
#	1.	CLEAR SELF-CHECK REGISTERS, MODE REGISTER AND CDUZ REGISTER
#	2.	CLEAR PHASE TABLE
#	3.	INITIALIZE IMU FLAGS
#	4.	INITIALIZE FLAGWORDS
#	5.	TRANSFER CONTROL TO IDLE LOOP IN DUMMYJOB
#
# GOPROG	HARDWARE RESTART
#
#	0.	EXECUTE STARTSUB
#	1.	TRANSFER CONTROL TO DOFSTART IF ANY OF THE FOLLOWING CONDITIONS
#		EXIST.
#		A.	RESTART OCCURED DURING EXECUTION OF ERASCHK
#		B.	BOTH OSCILLATOR FAIL AND AGC WARNING ARE ON
#		C.	MARK REJECT AND EITHER NAV OR MAIN DSKY ERROR LIGHT RESET
#			ARE ON.
#	2.	SCHEDULE A T5RUPT PROGRAM FOR THE DAP
#	3.	SET FLAGWRD5 BITS FOR INTWAKE ROUTINE
#	4.	EXTINGUISH ALL DSKY LAMPS, EXCEPT PROGRAM ALARM, GIMBAL LOCK AND
#		NO ATT
#	5.	INITIALIZE IMU FLAGS
#	6.	IF ENGINE COMMAND IS ON (FLAGWRD5, BIT 7), SET ENGINE ON (CHAN-
#		NEL 11, BIT 13)
#	7.	TRANSFER CONTROL TO GOPROG3
#
# ENEMA		SOFTWARE RESTART    INITIATED BY MAJOR MODE CHANGE
#
#	1.	EXECUTE STARTSB2
#	2.	KILL PROGRAMS THAT WERE INTEGRATING OR WAITING FOR INTEGRATION
#		ROUTINE
#	3.	TRANSFER CONTROL TO GOPROG3
#
# GOPROG3	SUBROUTINE COMMON TO GOPROG AND ENEMA
#
#	1.	TEST PHASE TABLES - IF INCORRECT, DISPLAY ALARM 1107 AND
#		TRANSFER CONTROL TO DOFSTART
#	2.	DISPLAY MAJOR MODE


#	3.  	IF ANY GROUPS WERE ACTIVE UPON RESTART, TRANSFER CONTROL TO THE
#		RESTARTS SUBROUTINE TO RESCHEDULE PENDING TASKS, LONGCALLS, AND
#		JOBS (P20 IS RESTARTED VIA FINDVAC)
#	4.	IF NO GROUPS WERE ACTIVE UPON RESTART, DISPLAY ALARM CODE
#		1110 (RESTART WITH NO ACTIVE GROUPS).
#	5.	TRANSFER CONTROL TO IDLE LOOP IN DUMMYJOB
#
# STARTSUB	SUBROUTINE COMMON TO SLAP1 AND GOPROG
#
#	1.	CLEAR OUTBIT CHANNELS 5 AND 6
#	2.	INITIALIZE TIME5, TIME4, TIME3
#	3.	TRANSFER CONTROL TO STARTSB2
#
# STARTSB2	SUBROUTINE COMMON TO STARTSUB AND ENEMA
#
#	1.	INITIALIZE OUTBIT CHANNELS 11,12,13 AND 14
#	2.	REPLACE ALL TASKS ON WAITLIST WITH ENDTASK
#	3.	MAKE ALL EXECUTIVE REGISTERS AVAILABLE
#	4.	MAKE ALL VAC AREAS AVAILABLE
#	5.	CLEAR DSKY REGISTERS
#	6.	ZERO NUMEROUS SWITCHES
#	7.	INITIALIZE OPTICS FLAGS
#	8.	INITIALIZE PIPA AND TELEMETRY FAIL FLAGS
#	9.	INITIALIZE DOWN TELEMETRY
#
# INPUT/OUTPUT INITIALIZATION
#
#	A.	CALLING SEQUENCE
#
#		SLAP1 -	TC POSTJUMP	OR	VERB 36,ENTER
#			CADR SLAP1
#
#		ENEMA -	TC POSTJUMP	***  DO NOT CALL ENEMA WITHOUT  ***
#			CADR ENEMA	***  CONSULTING POOH PEOPLE     ***
#
#	B.	OUTPUT
#
#		ERASABLE MEMORY INITIALIZATION
#
# PROGRAM ANALYSIS
#
#	A.	SUBROUTINES CALLED
#
#		MR.KLEAN,WAITLIST,DSPMM,ALARM,RESTARTS,FINDVAC
#
#	B.	ALARMS
#
#		1107	PHASE TABLE ERROR
#		1110	RESTART WITH NO ACTIVE GROUPS

		SETLOC	FRANDRES
		BANK

		EBANK=	LST1

		COUNT*	$$/START
SLAP1		INHINT			# FRESH START. COMES HERE FROM PINBALL.
		TC	STARTSUB	# SUBROUTINE DOES MOST OF THE WORK.

STARTSW		TCF	SKIPSIM

STARTSIM	CAF	BIT14

		TC	FINDVAC

SIM2CADR	OCT	77777

		OCT	77777
SKIPSIM		CA	DSPTAB +11D
		MASK	BITS4&6
		AD	BIT15
		TS	DSPTAB +11D	# REQUESTED FRESH START.

		CAF	ZERO		# SAME STORY ON ZEROING FAILREG.
		TS	ERCOUNT
		TS	FAILREG
		TS	FAILREG +1
		TS	FAILREG +2
		TS	REDOCTR

		EXTEND
		WRITE	CHAN77		# ZERO CHANNEL 77
		CS	PRIO12
		TS	DSRUPTSW

DOFSTART	CAF	ZERO		# DO A FRESH START.
		TS	ERESTORE	# ***** MUST NOT BE REMOVED FROM DOFSTART
		TS	SMODE		# ***** MUST NOT BE REMOVED FROM DOFSTART
		TS	UPSVFLAG	# UPDATE STATE VECTOR REQUEST FLAGWORD
		EXTEND
		WRITE	CHAN5		# TURN OFF RCS JETS
		EXTEND
		WRITE	CHAN6		# TURN OFF RCS JETS
		EXTEND
		WRITE	DSALMOUT	# ZERO CHANNEL 11
		EXTEND
		WRITE	CHAN12		# ZERO CHANNEL 12
		EXTEND
		WRITE	CHAN13		# ZERO CHANNEL 13
		EXTEND
		WRITE	CHAN14		# ZERO CHANNEL 14
		TS	WTOPTION
		TS	DNLSTCOD

		TS	NVSAVE
		TS	EBANKTEM
		TS	TRKMKCNT
		TS	VHFCNT
		TS	EXTVBACT

		CS	DSPTAB +11D
		MASK	BITS4&6
		CCS	A
		TC	+4
		CA	BITS4&6
		EXTEND			# THE IMU WAS IN COARSE ALIGN IN GIMBAL
		WOR	CHAN12		# LOCK, SO PUT IT BACK INTO COARSE ALIGN.
		TC	MR.KLEAN

		CS	ZERO
		TS	MODREG

		CAF	PRIO30
		TS	RESTREG

		CAF	IM30INIF	# FRESH START IMU INITIALIZATION.
		TS	IMODES30

		CAF	NEGONE
		TS	OPTIND		# KILL COARSE OPTICS

		CAF	OPTINITF
		TS	OPTMODES

		CAF	IM33INIT
		TS	IMODES33

		EXTEND			# LET T5 IDLE.
		DCA	T5IDLER
		DXCH	T5LOC

		CA	SWINIT
		TS	STATE

		CA	FLAGWRD1
		MASK	NOP01BIT	# LEAVE NODOP01 FLAG UNTOUCHED
		AD	SWINIT +1
		TS	FLAGWRD1

		CA 	SWINIT +2
		TS	STATE +2

		CA	FLAGWRD3
		MASK	REFSMBIT
		AD	SWINIT +3
		TS	FLAGWRD3

		EXTEND
		DCA	SWINIT +4
		DXCH	STATE +4
		EXTEND
		DCA	SWINIT +6
		DXCH	STATE +6
		EXTEND
		DCA	SWINIT +8D
		DXCH	SWINIT +8D

		CAF	HDSUPBIT
		MASK	FLGWRD10
		AD	SWINIT +10D
		TS	FLGWRD10

		CAF	SWINIT +11D
		TS	FLGWRD11

ENDRSTRT	TC	POSTJUMP
		CADR	DUMMYJOB +2	# DOES A RELINT.  (IN A SWITCHED BANK.)

MR.KLEAN	INHINT
		EXTEND
		DCA	NEG0
		DXCH	-PHASE2
POOKLEAN	EXTEND
		DCA	NEG0
		DXCH	-PHASE4
		EXTEND
		DCA	NEG0
		DXCH	-PHASE1
V37KLEAN	EXTEND
		DCA	NEG0
		DXCH	-PHASE3
		EXTEND
		DCA	NEG0
		DXCH	-PHASE5
UPKLEAN		EXTEND
		DCA	NEG0
		DXCH	-PHASE6
		TC	Q

OCT6200		OCT	6200

# COMES HERE FROM LOCATION 4000, GOJAM. RESTART ANY PROGRAMS WHICH MAY HAVE BEEN RUNNING AT THE TIME.

GOPROG		INCR	REDOCTR		# ADVANCE RESTART COUNTER.

		LXCH	Q
		EXTEND
		ROR	SUPERBNK
		DXCH	RSBBQ
		TC	BANKCALL	# STORE ERASABLES FOR DEBUGGING PURPOSES.
		CADR	VAC5STOR
		CA	BIT15		# TEST OSC FAIL BIT TO SEE IF WE HAVE
		EXTEND			# HAD A POWER TRANSIENT. IF SO, ATTEMPT
		WAND	CHAN33		# A RESTART. IF NOT, CHECK THE PRESENT
		EXTEND			# STATE OF AGC WARNING BIT.
		BZF	BUTTONS

		CA	BIT14		# IF AGC WARNING ON (BIT = 0), DO A
		EXTEND			# FRESH START ON ASSUMPTION THAT
		RAND	CHAN33		# WE ARE IN A RESTART LOOP.
		EXTEND
		BZF	NONAVKEY +1

BUTTONS		TC	LIGHTSET	# MAKE FRESH START CHECKS BEFORE ERESTORE.

# ERASCHK TEMPORARILY STORES THE CONTENTS OF TWO ERASABLE LOCATIONS, X
# AND X+1 INTO SKEEP5 AND SKEEP6. IT ALSO STORES X INTO SKEEP7 AND
# ERESTORE. IF ERASCHK IS INTERRUPTED BY A RESTART, C(ERESTORE) SHOULD
# EQUAL C(SKEEP7),AND BE A + NUMBER LESS THAN 2000 OCT.  OTHERWISE
# C(ERESTORE) SHOULD EQUAL +0.

		CAF	HI5
		MASK	ERESTORE
		EXTEND
		BZF	+2		# IF ERESTORE NOT = +0 OR +N LESS THAN 2K,
		TCF	NONAVKEY +1	# DOUBT E MEMORY AND DO FRESH START.
		CS	ERESTORE
		EXTEND
		BZF	ELRSKIP -1
		AD	SKEEP7
		EXTEND
		BZF	+2		# = SKEEP7, RESTORE E MEMORY.
		TCF	NONAVKEY +1	# NOT = SKEEP7, DOUBT EMEM, DO FRESH START
		CA	SKEEP4
		TS	EBANK		# EBANK OF E MEMORY THAT WAS UNDER TEST.
		EXTEND			# (NOT DXCH SINCE THIS MIGHT HAPPEN AGAIN)
		DCA	SKEEP5
		INDEX	SKEEP7
		DXCH	0000		# E MEMORY RESTORED.
		CA	ZERO
		TS	ERESTORE
 -1		TC	STARTSUB	# DO INITIALIZATION AFTER ERASE RESTORE.
ELRSKIP		CA	FLAGWRD6	# RESTART AUTOPILOTS
		MASK	DPCONFIG
		EXTEND
		MP	BIT3		# BITS 15,14	00	T5IDLOC
		MASK	SIX		#		01	REDORCS
		EXTEND			#		10	REDOTVC
		INDEX	A		#		11	REDOSAT
		DCA	T5IDLER
		DXCH	T5LOC

		CS	INTFLBIT
		MASK	FLGWRD10
		TS	FLGWRD10

		CA	OPTMODES
		MASK	OPTINITR
		AD	OCDUFBIT
		TS	OPTMODES

		CAF	NOIMUDAP
		MASK	IMODES33
		AD	IM33INIT
		TS	IMODES33

		CA	9,6,4		# LEAVE PROG ALARM, GIMBAL LOCK, NO ATT
		MASK	DSPTAB +11D	# LAMPS INTACT ON HARDWARE RESTART
		AD	BIT15
		XCH	DSPTAB +11D
		MASK	BIT4		# IF NO ATT LAMP WAS ON, LEAVE ISS IN
		EXTEND			# COURSE ALIGN
		BZF	NOCOARSE
		TC	IBNKCALL	# IF NO ATT LAMP ON, RETURN ISS TO
		CADR	SETCOARS	#	COARSE ALIGN

		CAF	SIX
		TC	WAITLIST
		EBANK=	CDUIND
		2CADR	CA+ECE

NOCOARSE	CAF	IFAILINH	# LEAVE FAILURE INHIBITS INTACT ON
		MASK	IMODES30	#	HARDWARE RESTART. RESET ALL
		AD	IM30INIR	#	FAILURE CODES.
		TS	IMODES30

		CS	FLAGWRD5
		MASK	ENGONBIT
		CCS	A
		TCF	GOPROG3
		CAF	BIT13
		EXTEND
		WOR	DSALMOUT	# TURN ENGINE ON
		TCF	GOPROG3
ENEMA		INHINT
		TC	LIGHTSET	# EXIT TO DOFSTART IF ERROR RESET AND
		TC	STARTSB2	# MARK REJECT DEPRESSED SIMULTANEOUSLY
		CS	INTFLBIT
		MASK	FLGWRD10
		TS	FLGWRD10

		CS	FLAGWRD6	# IS TVC ON
		MASK	DPCONFIG
		EXTEND
		BZMF	GOPROG3		# NO

		CAF	.5SEC		# YES, CALL TVCEXEC TASK WHICH WAS KILLED
		TC	WAITLIST	# 	IN STARTSB2.
		EBANK=	CNTR
		2CADR	TVCEXEC

GOPROG3		CA	FLAGWRD6
		MASK	DPCONFIG
		EXTEND
		BZMF	GOPROG4
		CAF	TRACKBIT
		MASK	FLAGWRD1
		CCS	A
		TCF	GOPROG4
		TC	E6SETTER
		TC	STOPRATE
		CAF	EBANK3
		TS	EBANK
GOPROG4		CAF	NUMGRPS		# VERIFY PHASE TABLE AGREEMENTS
PCLOOP		TS	MPAC +5
		DOUBLE
		EXTEND
		INDEX	A
		DCA	-PHASE1		# COMPLEMENT INTO A, DIRECT INTO L.
		EXTEND
		RXOR	LCHAN		# RESULT MUST BE -0 FOR AGREEMENT.
		CCS	A
		TCF	PTBAD		# RESTART FAILURE.
		TCF	PTBAD
		TCF	PTBAD

		CCS	MPAC +5		# PROCESS ALL RESTART GROUPS.
		TCF	PCLOOP
		TS	MPAC +6		# SET TO +0.
		TC	MMDSPLAY	# DISPLAY MAJOR MODE

		INHINT			# RELINT DONE IN MMDSPLAY

		CAF	NUMGRPS		# SEE IF ANY GROUPS RUNNING.
NXTRST		TS	MPAC +5
		DOUBLE
		INDEX	A
		CCS	PHASE1
		TCF	PACTIVE		# PNZ - GROUP ACTIVE.
		TCF	PINACT		# +0 - GROUP NOT RUNNING.

PACTIVE		TS	MPAC
		INCR	MPAC		# ABS OF PHASE.
		INCR	MPAC +6		# INDICATE GROUP DEMANDS PRESENT.
		TC	BANKCALL
		CADR	RESTARTS

PINACT		CCS	MPAC +5		# PROCESS ALL RESTART GROUPS.
		TCF	NXTRST

		CCS	MPAC +6		# NO, CHECK PHASE ACTIVITY FLAG
		TCF	ENDRSTRT	# PHASE ACTIVE
		CAF	BIT15		# IS MODE -0
		MASK	MODREG
		EXTEND
		BZF	GOTOPOOH	# NO
		TCF	ENDRSTRT	# YES
PTBAD		TC	ALARM		# SET ALARM TO SHOW PHASE TABLE FAILURE.
		OCT	1107

		TCF	DOFSTART	# IN R2).

# ******** ****** ******

# DO NOT USE GOPROG2 OR ENEMA WITHOUT CONSULTING POOH PEOPLE

GOPROG2		INHINT
		TC	STARTSB2
		CS	INTFLBIT
		MASK	FLGWRD10
		TS	FLGWRD10
		TCF	GOPROG4
OCT10000	=	BIT13
OCT30000	=	PRIO30
LIGHTSET	CAF	BIT7		# DOFSTART IF MARK REJECT AND EITHER
		EXTEND			# ERROR LIGHT RESET BUTTONS ARE DEPRESSED
		RAND	NAVKEYIN
		EXTEND
		BZF	NONAVKEY	# NO MARK REJECT
		CAF	OCT37
		EXTEND
		RAND	NAVKEYIN	# NAV DSKY KEYCODES,MARK,MARK REJECT
		AD	-ELR
		EXTEND
		BZF	NONAVKEY +1
		EXTEND
		READ	MNKEYIN		# MAIN DSKY KEYCODES
		AD	-ELR
		EXTEND
		BZF	+2

NONAVKEY	TC	Q

 +1		TC	STARTSUB
		TCF	DOFSTART
STARTSUB	CAF	LDNPHAS1	# SET POINTER SO NEXT 20MS DOWNRUPT WILL
		TS	DNTMGOTO	# CAUSE THE CURRENT DOWNLIST TO BE
					# INTERRUPTED AND START SENDING FROM THE
					# BEGINNING OF THE CURRENT DOWNLIST.

		CAF	OCT37774	# 37774 TO TIME5
		TS	TIME5
		AD	ONE		# 37775 TO TIME4
		TS	TIME4

STARTSB2	CAF	OCT77603	# TURN OFF UPLINK ACTY, TEMP CAUTION, KR,
		EXTEND			# FLASH, OP. ERROR, LEAVE OTHERS UNCHANGED
		WAND	DSALMOUT

		CAF	POSMAX		# 37777 to TIME3.
		TS	TIME3

		CAF	OCT74777	# TURN OFF TEST ALARMS, STANDBY ENABLE.
		EXTEND
		WAND	CHAN13
		CAF	R21BIT		# CLEAR BITS
		AD	P21BIT
		AD	SKIPVBIT
		AD	REVBIT
		COM
		MASK	FLAGWRD2
		AD	SKIPVBIT	# NOW SET SKIPVHF FLAG.
		TS	FLAGWRD2
		CS	MARKBIT
		MASK	FLAGWRD1
		TS	FLAGWRD1

		CS	CYC61BIT
		MASK	FLAGWRD0
		TS	FLAGWRD0
		EBANK=	LST1
		CAF	EBANK3
		TS	EBANK		# SET FOR E3

		CAF	NEG1/2		# INITIALIZE WAITLIST DELTA-TS.
		TS	LST1 +7
		TS	LST1 +6
		TS	LST1 +5
		TS	LST1 +4
		TS	LST1 +3
		TS	LST1 +2
		TS	LST1 +1
		TS	LST1

		CS	ENDTASK
		TS	LST2
		TS	LST2 +2
		TS	LST2 +4
		TS	LST2 +6
		TS	LST2 +8D
		TS	LST2 +10D
		TS	LST2 +12D
		TS	LST2 +14D
		TS	LST2 +16D
		CS	ENDTASK +1
		TS	LST2 +1
		TS	LST2 +3
		TS	LST2 +5
		TS	LST2 +7
		TS	LST2 +9D
		TS	LST2 +11D
		TS	LST2 +13D
		TS	LST2 +15D
		TS	LST2 +17D

		CS	ZERO		# MAKE ALL EXECUTIVE REGISTER SETS
		TS	PRIORITY	# AVAILABLE.
		TS	PRIORITY +12D
		TS	PRIORITY +24D
		TS	PRIORITY +36D
		TS	PRIORITY +48D
		TS	PRIORITY +60D
		TS	PRIORITY +72D

		TS	DSRUPTSW
		TS	NEWJOB		# SHOWS NO ACTIVE JOBS.

		CAF	VAC1ADRC	# MAKE ALL VAC AREAS AVAILABLE.
		TS	VAC1USE
		AD	LTHVACA
		TS	VAC2USE
		AD	LTHVACA
		TS	VAC3USE
		AD	LTHVACA
		TS	VAC4USE
		AD	LTHVACA
		TS	VAC5USE

		CAF	TEN		# BLANK DSKY REGISTERS (PROGRAM,VERB,NOUN,
					# R1,R2,R3)
DSPOFF		TS	MPAC
		CS	BIT12
		INDEX	MPAC
		TS	DSPTAB
		CCS	MPAC
		TCF	DSPOFF

		TS	DELAYLOC
		TS	DELAYLOC +1
		TS	DELAYLOC +2
		TS	DELAYLOC +3
		TS	INLINK
		TS	DSPCNT
		TS	CADRSTOR
		TS	REQRET
		TS	CLPASS
		TS	DSPLOCK
		TS	MONSAVE		# KILL MONITOR
		TS	MONSAVE1
		TS	VERBREG
		TS	NOUNREG
		TS	DSPLIST
		TS	IMUCADR
		TS	LGYRO
		TS	FLAGWRD4	# KILL INTERFACE DISPLAYS
		TS	MARKINDX
		TS	EXTVBACT
		CAF	NOUTCON
		TS	NOUT

		CAF	LESCHK		# SELF CHECK GO-TO REGISTER.
		TS	SELFRET

		CS	VD1
		TS	DSPCOUNT

		TC	Q
T5IDLOC		CA	L		# T5RUPT COMES HERE EVERY 163.84 SECS
		TCF	NOQRSM	+1	# WHEN NOBODY IS USING IT.

		EBANK=	OGANOW
T5IDLER		2CADR	T5IDLOC

		EBANK=	OGANOW
		2CADR	REDORCS

		EBANK=	OGANOW
		2CADR	REDOTVC

		EBANK=	OGANOW
		2CADR	REDOSAT

IFAILINH	OCT	435
LDNPHAS1	GENADR	DNPHASE1
LESCHK		GENADR	SELFCHK
VAC1ADRC	ADRES	VAC1USE
OCT77603	OCT	77603
OCT74777	OCT	74777
NUMGRPS		EQUALS	FIVE
-ELR		OCT	-22		# -ERROR LIGHT RESET KEY CODE.
IM30INIF	OCT	37411		# INHIBITS IMU FAIL FOR 5 SEC AND PIP ISSW
IM30INIR	=	PRIO37
IM33INIT	=	PRIO16		# NO PIP OR TM FAIL SIGNALS.
9,6,4		OCT	450
OPTINITF	OCT	130
OPTINITR	=	BITS4&5
SWINIT		OCT	0
		OCT	0
		OCT	0
		OCT	0

		OCT	0
		OCT	0
		OCT	00004		# .05GSW
		OCT	0
		OCT	0
		OCT	0
		OCT	0
		OCT	0
# ROUTINE NAME		GOTOPOOH -- ENTRANCE TO ROUTINE R00 (SELECTION OF NEW PROGRAM VIA V37)
# FUNCTIONAL DESCRIPTION
#
#	1. FLASH V37	TO REQUEST SELECTION OF NEW PROGRAM

		SETLOC	FFTAG10
		BANK

		COUNT*	$$/POO
GOTOPOOH	TC	DOWNFLAG
		ADRES	AUTOSEQ
MNKGOPOO	TC	PHASCHNG
		OCT	05024
		OCT	13000
		TC	POSTJUMP
		CADR	GOPOOFIX
AUTOCHK		CAF	AUTSQBIT		# IS THIS AN AUTO SEQUENCE
		MASK	FLGWRD10
		EXTEND
		BZF	TCQ			# NO, RETURN TO CALLER
AUTOCHK1	TC	PHASCHNG
		OCT	05024
		OCT	13000

						# GROUP 4 USE IS OK SINCE V37 TO FOLLOW
		CAF	BIT13
		XCH	FBANK			# INCORRECT IF P80'S NOT IN BANK 4 (BIT13)
		TC	AUTPOINT
		SETLOC	VERB37
		BANK

		COUNT*	$$/POO
GOPOOFIX	TC	INITSUB
		TC	CLEARMRK +2
		TC	AUTOCHK
		CAF	V37N99
		TC	VNFLASH
		TC	-2

V37N99		VN	3799

# PROGRAM NAME		V37				ASSEMBLY	SUNDISK
# LOG SECTION		FRESH START AND RESTART
#
# FUNCTIONAL DESCRIPTION
#
#	1. CHECK IF NEW PROGRAM ALLOWED. IF BIT 1 OF FLAGWRD2 (NODOFLAG) IS SET, AN ALARM 1520 IS CALLED.
#	2. CHECK FOR VALIDITY OF PROGRAM SELECTED. IF AN INVALID PROGRAM IS SELECTED, THE OPERATOR ERROR LIGHT IS
#	   SET AND CURRENT ACTIVITY, IF ANY, CONTINUES.
#	3. SERVICER IS TERMINATED IF IT HAS BEEN RUNNING.
#	4. INSTALL IS EXECUTED TO AVOID INTERRUPTING INTEGRATION.
#	5. THE ENGINE IS TURNED OFF AND THE DAP IS INITIALIZED FOR COAST.
#	6. TRACK, UPDATE AND TARG1 FLAGS ARE SET TO ZERO.
#	7. DISPLAY SYSTEM IS RELEASED.
#	8. THE FOLLOWING ARE PERFORMED FOR EACH OF THE THREE CASES.
#		A. PROGRAM SELECTED IS P00.
#			1. RENDEZVOUS FLAG IS RESET (KILL P20).
#			2. STATINT1 IS SCHEDULED BY SETTING RESTART GROUP 2.
#			3. MAJOR MODE 00 IS STORED IN THE MODE REGISTER (MODREG).
#			4. SUPERBANK 3 IS SELECTED.
#			5. NODOFLAG IS RESET.
#			6. ALL RESTART GROUPS EXCEPT GROUP 2 ARE CLEARED. CONTROL IS TRANSFERRED TO RESTART PROGRAM (GOPROG2)
#			   WHICH CAUSES ALL CURRENT ACTIVITY TO BE DISCONTINUED AND A 9 MINUTE INTEGRATION CYCLE TO BE
#			   INITIATED.
#		B. PROGRAM SELECTED IS P20
#			1. IF THE CURRENT MAJOR MODE IS THE SAME AS THE SELECTED NEWPROGRAM, THE PROGRAM IS RE-INITIALIZED
#			   VIA V37XEQ, ALL RESTART GROUPS, EXCEPT GROUP 4 ARE CLEARED.
#			2. IF THE CURRENT MAJOR MODE IS NOT EQUAL TO THE NEW REQUEST, A CHECK IS MADE TO SEE IF THE REQUEST-
#			   ED MAJOR MODE HAS BEEN RUNNING IN THE BACKGROUND,
#			   AND IF IT HAS, NO NEW PROGRAM IS SCHEDULED, THE EXISTING
#			   P20 IS RESTARTED TO CONTINUE, AND ITS MAJOR MODE IS SET.
#			3. CONTROL IS TRANSFERRED TO GOPROG2.
#		C. PROGRAM SELECTED IS NEITHER P00 NOR P20
#			1. V37XEQ IS SCHEDULED (AS A JOB) BY SETTING RESTART GROUP 4
#			2. ALL CURRENT ACTIVITY EXCEPT RENDEZVOUS AND TRACKING IS DISCONTINUED BY CLEARING ALL RESTART
#			   GROUPS. GROUP 2 IS CLEARED. IF THE RENDEZVOUS FLAG IS ON P20 IS RESTARTED IN GOPROG2 VIA REDOP20.
#			   TO CONTINUE.
#
# INPUT/OUTPUT INFORMATION
#
#	A. CALLING SEQUENCE
#
#		CONTROL IS DIRECTED TO V37 BY THE VERBFAN ROUTINE.
#		VERBFAN GOES TO C(VERBTAB+C(VERBREG)). VERB 37 = MMCHANG.
#		MMCHANG EXECUTES A	TC POSTJUMP, CADR V37.
#
#	B. ERASABLE INITIALIZATION		NONE
#
# 	C. OUTPUT
#		MAJOR MODE CHANGE
#
#	D. DEBRIS
#		MMNUMBER, MPAC +1, MINDEX, BASETEMP +C(MINDEX), FLAGWRD0, FLAGWRD1, FLAGWRD2, MODREG, GOLOC -1,
#		GOLOC, GOLOC +1, GOLOC +2, BASETEMP, -PHASE2, PHASE2, -PHASE4
#
# PROGRAM ANALYSIS
#
#	A. SUBROUTINES CALLED
#		ALARM, RELDSP, PINBRNCH, INTSTALL, ENGINOF2, ALLCOAST, V37KLEAN, GOPROG2, FALTON, FINDVAC, SUPERSW,
#		DSPMM
#
#	B. NORMAL EXIT				TC ENDOFJOB
#
#	C. ALARMS				1520 (MAJOR MODE CHANGE NOT PERMITTED)

		SETLOC	FFTAG10
		BANK

		COUNT*	$$/V37
OCT24		MM	20
OCT31		MM	25
		SETLOC	VERB37
		BANK

		COUNT*	$$/V37
V37		TS	MMNUMBER		# SAVE MAJOR MODE
		TC	DOWNFLAG
		ADRES	AUTOSEQ
		TC	DOWNFLAG
		ADRES	TPIMNFLG
		TC	DOWNFLAG
		ADRES	PCMANFLG
		TC	DOWNFLAG
		ADRES	VHFRFLAG
		TC	E7SETTER
		EBANK=	MRKBUF1
		CAF	NEGONE
		TS	MRKBUF1			# TO PREVENT P20 FROM PROCESSING P50'S MRK
		CS	MMNUMBER
		AD	DEC80
		EXTEND
		BZMF	V37NONO
		CS	FLAGWRD3
		MASK	REFSMBIT
		CCS	A
		TCF	AUTO37
MMOK		CA	MMNUMBER
		AD	NEG30
		EXTEND
		BZMF	AUTO37			# P01 - P30
		AD	NEG8
		EXTEND
		BZMF	REND30S			# P31 - P38 RENDEZVOUS
AUTO37		CAF	PRIO30
		TS	RESTREG

		CA	IMODES30		# IS IMU BEING INITIALIZED
		MASK	IMUNITBT
		CCS	A
		TCF	CANTROO

		CAF	ENGONBIT		# IS ENGINE ON
		MASK	FLAGWRD5
		CCS	A
		TCF	ROOTOPOO		# YES, SET UP FOR POO

		CS	FLAGWRD6		# NO, IS TVC DAP ON
		MASK	DPCONFIG
		EXTEND
		BZMF	ISITPOO			# NO, CONTINUE WITH ROO

ROOTOPOO	TC	E6SETTER

		EBANK=	DAPDATR1
		TC	BANKCALL		# SPSOFF DOES AN INHINT
		CADR	SPSOFF
		TC	IBNKCALL
		CADR	MASSPROP
		CAF	3.1SEC
		TC	IBNKCALL
		CADR	RCSDAPON +1

		TC	IBNKCALL
		CADR	TVCZAP			# DISABLE TVC
		CAF	ZERO
		TS	MMNUMBER
		RELINT
		CAF	FIVE
		TC	BANKCALL
		CADR	DELAYJOB
		CAF	ZERO
		EXTEND
		WRITE	5
		EXTEND
		WRITE	6
ISITPOO		CA	MMNUMBER
		EXTEND
		BZF	ISSERVON		# YES, CHECK SERVICER STATUS

		CS	FLAGWRD2		# NO, IS NODO V37 FLAG SET
		MASK	NODOBIT
		CCS	A
		TCF	CHECKTAB		# NO
CANTROO		TC	ALARM
		OCT	1520

V37BAD		TC	RELDSP			# RELEASES DISPLAY FROM ASTRONAUT

		TC	POSTJUMP		# BRING BACK LAST NORMAL DISPLAY IF THERE
		CADR	PINBRNCH		# WAS ONE. OY

CHECKTAB	CA	NOV37MM			# THE NO. OF MM
AGAINMM		TS	MPAC +1
		NDX	MPAC +1
		CA	PREMM1			# OBTAIN WHICH MM THIS IS FOR
		MASK	LOW7
		COM
		AD	MMNUMBER
		CCS	A
		CCS	MPAC +1			# IF GR, SEE IF ANY MORE IN LIST
		TCF	AGAINMM			# YES, GET NEXT ONE
		TCF	V37NONO			# LAST TIME OR PASSED MM

		CA	MPAC +1
		TS	MINDEX			# SAVE INDEX FOR LATER

		TC	UPFLAG
		ADRES	V50N18FL		# 66935 55  518 490731Y

ISSERVON	CS	FLAGWRD7		# V37 FLAG SET - I.E. IS SERVICER GOING
		MASK	V37FLBIT
		CCS	A
		TCF	CANV37			# NO

		INHINT
		CS	AVEGBIT			# YES TURN OFF AVERAGE G FLAG AND WAIT
		MASK	FLAGWRD1		# FOR SERVICER TO RETURN TO CANV37
		TS	FLAGWRD1

		TCF	ENDOFJOB

CANV37		CAF	ROOAD
		TS	TEMPFLSH

		TC	PHASCHNG
		OCT	14

ROO		TC	INTPRET

		CALL				# WAIT FOR INTEGRATION TO FINISH
			INTSTALL
DUMMYAD		EXIT

		CS	OCT1400			# CLEAR CAUTION RESET
		EXTEND				#   AND TEST CONNECTOR OUTBIT
		WAND	11

		CAF	OCT44571		# CLEAR ENABLE OPTICS ERROR COUNTER, STAR
		EXTEND				# TRAKERS ON BIT, TVC ENABLE, ZERO OPTICS,
		WAND	12			# DISENGAGE OPTICS DAP, SIVB INJ SEQUENCE
						# START, AND SIVB CUTOFF BIT.

		CS	OCT600			# CLEAR UNUSED BITS
		EXTEND
		WAND	13

		TC	INITSUB

		TC	CLEARMRK

		CAF	ZERO
		TS	STARIND

		TC	DOWNFLAG
		ADRES	STIKFLAG

		TC	UPACTOFF		# TURN OFF UPLINK ACTIV LIGHT

		TC	DOWNFLAG
		ADRES	R21MARK

		TC	DOWNFLAG
		ADRES	EXTRANGE

		CCS	MMNUMBER		# IS THIS A POOH REQUEST
		TCF	NOUVEAU			# NO, PICK UP NEW PROGRAM

		COUNT*	$$/POO
POOH		TC	RELDSP			# RELEASE DISPLAY SYSTEM

		CAF	PRIO5			# SET VARIABLE RESTART REGISTER FOR P00.
		TS	PHSPRDT2

		INHINT
		CS	NODOBIT			# TURN OFF NODOFLAG
		MASK	FLAGWRD2
		TS	FLAGWRD2

		CA	FIVE			# SET 2.5 RESTART FOR STATEINT1
		TS	L
		COM
2P5SPT1		=	2.5SPOT
		DXCH	-PHASE2

		CA	IMUSEBIT		# RESET IMUSE AND
		AD	RNDVZBIT		# KILL P20
		COM
		MASK	FLAGWRD0
		TS	FLAGWRD0		#			 RENDFLG

		CS	UTBIT
		MASK	FLAGWRD8
		TS	FLAGWRD8

		CAF	DNLADP00

		COUNT*	$$/V37
SEUDOPOO	TS	DNLSTCOD		# SET UP APPROPRIATE DOWNLIST.
						# (OLD ONE WILL BE FINISHED FIRST)

		CA	TRACKBIT
		AD	TARG1BIT
		AD	UPDATBIT
		COM
		TS	EBANKTEM
		MASK	FLAGWRD1
		TS	FLAGWRD1

		CS	R67BIT			# CLEAR R67FLAG. P20 WILL SET IT AGAIN
		MASK	FLAGWRD8		# IF APPROPRIATE
		TS	FLAGWRD8

		CAF	R27UP1BT
		AD	R27UP2BT
		AD	TDFLGBIT
		AD	P25BIT
		AD	P48BIT
		AD	SNAPBIT
		AD	CYCLFBIT
		COM
		MASK	FLGWRD11
		TS	FLGWRD11

GROUPKIL	TC	IBNKCALL		# KILL GROUPS 3(5,6
		CADR	V37KLEAN

		CCS	MMNUMBER		# IS IT POOH
		TCF	RENDVOO			# NO
		TC	IBNKCALL
		CADR	POOKLEAN		# REDUNDANT EXCEPT FOR GROUP 4.

		TC	INITSUBA
GOMOD		CA	MMNUMBER
		TS	MODREG


GOGOPROG	TC	POSTJUMP
		CADR	GOPROG2

RENDVOO		CS	MMNUMBER		# IS NEW PROG = 20
		AD	OCT24			# 20
		EXTEND
		BZF	RENDNOO			# YES
		TCF	POOFIZZ

RENDNOO		CS	MMNUMBER
		AD	MODREG
		EXTEND
		BZF	KILL20

		CA	FLAGWRD8
		MASK	UTBIT
		CCS	A
		TCF	STATQUO1

		CA	FLAGWRD0		# IS RENDEZVOO FLAG SET
		MASK	RNDVZBIT
		CCS	A
		TCF	STATQUO

POOFIZZ		CA	FLAGWRD8
		MASK	UTBIT
		CCS	A
		TCF	KILL20 +4
		CAF	RNDVZBIT
		MASK	FLAGWRD0
		CCS	A
		TCF	REV37
KILL20		EXTEND				# NO, KILL GROUPS 1 + 2
		DCA	NEG0
		DXCH	-PHASE1

		TC	INITSUBA
 +4		EXTEND
		DCA	NEG0
		DXCH	-PHASE2

REV37		CAF	V37QCAD			# SET RESTART POINT
		TS	TEMPFLSH

		TCF	GOGOPROG

STATQUO1	CAF	FIVE			# SET 2.5 RESTART for STATEINT1
		TS	L
2P5SPT2		=	2.5SPOT
		COM
		DXCH	-PHASE2
		TCF	STATQUO +3
STATQUO		CS	FLAGWRD1		# SET TRACK FLAG AND UPDATE FLAG
		MASK	UPDATBIT
		ADS	FLAGWRD1
 +3		CS	FLAGWRD1
		MASK	TRACKBIT
		ADS	FLAGWRD1

		EXTEND				# KILL GROUP 4
		DCA	NEG0
		DXCH	-PHASE4

		TCF	GOMOD

NOUVEAU		CAF	RNDVZBIT
		MASK	FLAGWRD0
		CCS	A
		TCF	+7
		CAF	UTBIT
		MASK	FLAGWRD8
		CCS	A
		TCF	+3
		TC	DOWNFLAG		# NO, RESET IMUSE FLAG.
		ADRES	IMUSE			# BIT 8 FLAG 0
 +3		INDEX	MINDEX
		CAF	PREMM1			# EXTRACT DOWNLIST ADDRESS
		TS	CYL			# SHIFT BITS 15 - 13 TO BITS 3 - 1
		CS	CYL
		CS	CYL
		XCH	CYL
		MASK	SEVEN			# KEEP DOWNLIST CODE BITS
		INHINT
		TCF	SEUDOPOO

V37NONO		TC	FALTON			# COME HERE IF MM REQUESTED DOESNT EXIST

		TCF	V37BAD

		SETLOC	VERB37			# MUST BE IN BANK 4 BECAUSE OF AUTOCHK
		BANK
		COUNT*	$$/MNKEY
DEC41		DEC	41
DEC52		DEC	52
DEC20		=	OCT24
DEC31		=	LOW5
DEC32		=	BIT6
DEC40		=	OCT50
DEC33		=	33DEC
DEC34		=	34DEC
DEC36		DEC	36
DEC35		DEC	35
DEC37		DEC	37
DEC38		DEC	38
DEC48		DEC	48
DEC80		=	SUPER101
NEG8		=	-OCT10
DEC88		DEC	88
NEG30		DEC	-30
DEC50		=	OCT62
CKLSTAUT	=	LOW4
REND30S		AD	DEC88			# CHANGE P3X to P8X
 +1		TS	TEMPMM			#      AND SAVE
		CAF	UTBIT
		MASK	FLAGWRD8
		EXTEND
		BZF	UTOFF

		TC	DOWNFLAG
		ADRES	TRACKFLG

		TC	DOWNFLAG
		ADRES	UTFLAG

UTOFF		CS	FLAGWRD0		# HAS P20 BEEN ON
		MASK	RNDVZBIT
		EXTEND
		BZF	NOP20			# YES
		TC	UPFLAG
		ADRES	AUTOSEQ			# SET TO CAUSE RETURN FROM P20

		CAF	DEC20			# NO - TURN ON P20
		TC	AUTOSET
NOP20		CA	TEMPMM
AUTOSETA	TS	MMNUMBER
		TC	AUTO37
MINKDISP	CA	Q
		TS	AUTPOINT
		CS	DEC50
		AD	MMNUMBER
		TC	NEWMODEA		# CHANGE MAJOR MODE TO 30'S
		TC	RELDSP
		CAF	CKLSTAUT
		TC	BANKCALL
		CADR	GOPERF1
		TCF	GOTOPOOH
		TC	STARTAUT		# PRO - DO MINKEY
		TC	DOWNFLAG		# ENTER - NO MINKEY
		ADRES	AUTOSEQ
		TC	AUTPOINT
STARTAUT	CA	FLGWRD11		# INITIALIZE MINKEY
		MASK	AZIMBIT
		CCS	A
		TCF	STRTAUT1
		TC	UPFLAG
		ADRES	AZIMFLAG
		ZL
		CS	FLGWRD10
		MASK	HDSUPBIT
		EXTEND
		BZF	+3
		ZL
		CA	HALF
		DXCH	AZIMANGL
STRTAUT1	CS	FLAGWRD5
		MASK	RENDWBIT
		EXTEND
		BZF	+5			# YES
		TC	UPFLAG			# NO
		ADRES	MANEUFLG
		TC	UPFLAG
		ADRES	PTV93FLG
		TC	DOWNFLAG
		ADRES	PCFLAG
		TC	UPFLAG
		ADRES	AUTOSEQ

		TC	AUTPOINT
AUTOSET		EXTEND
		QXCH	AUTTEMP
 +2		TS	MMNUMBER
		TC	PHASCHNG
		OCT	04024

		CA	AUTTEMP
		TS	AUTPOINT

		TC	AUTO37

BURNHOW		EXTEND
		QXCH	AUTTEMP
		TC	INTPRET
		VLOAD	ABVAL
			DELVLVC
		DSU	BPL
			DV40/41			# THRESHHOLD DELTA V FOR SPS BURN
			P40BURN
		EXIT
		CAF	DEC41			# CALL P41


		TC	AUTOSET +2
P40BURN		EXIT
		CAF	DEC40			# CALL P40
		TC	AUTOSET +2
DV40/41		2DEC	.03048 B-7		# 10 FPS IN M/CS B-7

P81		TC	MINKDISP
P81CONT1	CAF	DEC31
		TC	AUTOSET
		TC	BURNHOW
		TCF	P82CONT1
P82		TC	MINKDISP
P82CONT1	CAF	DEC32
		TC	AUTOSET
		TC	BURNHOW
		TCF	P83CONT1
P83		TC	MINKDISP
P83CONT1	CAF	DEC33
		TC	AUTOSET
		TC	BURNHOW
		TCF	P84CONT1
P84		TC	MINKDISP
P84CONT1	CAF	DEC34
		TC	AUTOSET
		TC	BURNHOW
		TCF	P85CONT1
P85		TC	MINKDISP
P85CONT1	CA	DEC35
		TC	AUTOSET
		TC	BURNHOW
		TC	P86CONT1
P86		TC	MINKDISP
P86CONT1	CAF	DEC36
		TC	AUTOSET
		TC	BURNHOW
		CAF	DEC36
		TC	AUTOSET
		TC	BURNHOW
		TC	P87CONT1
P87		TC	MINKDISP
P87CONT1	CAF	DEC37
		TC	AUTOSET
		CAF	DEC48
		TC	AUTOSET
		TC	GOTOPOOH
P88		TC	MINKDISP
		CAF	DEC38
		TC	AUTOSET
		TC	INTPRET
		VLOAD	ABVAL
			DELVLVC
		BZE	EXIT
			NOPC
		CAF	DEC52
		TC	AUTOSET
		CS	FLGWRD10
		MASK	PCBIT
		EXTEND
		BZF	DOP41			# PULSE TORQUING NOT DONE - CALL P41
		TC	BURNHOW			# P40 OR P41
P86CONT2	TC	UPFLAG
		ADRES	PCMANFLG
		CAF	DEC20			# MANEUVER TO TRACK ATTITUDE
		TC	AUTOSET
		TC	DOWNFLAG
		ADRES	PCMANFLG
		CAF	DEC52
		TC	AUTOSET
		TC	GOTOPOOH
DOP41		CAF	DEC41
		TC	AUTOSET
		TC	GOTOPOOH
NOPC		EXIT
PCP76		TC	GOTOPOOH

		SBANK=	LOWSUPER
		SETLOC	VERB37
		BANK

		COUNT*	$$/V37
OCT00010	EQUALS	BIT4
V37XEQ		INHINT
		CAF	PRIO13
		TS	PHSPRDT4		# PRESET GROUP4 RESTART PRIORITY
V37XEQ+3	TS	NEWPRIO			# STORE PRIO FOR SPVAC
		INDEX	MINDEX
		CAF	PREMM1
		TS	MMTEMP			# OBTAIN PRIORITY BITS 15 - 11
		EXTEND
		MP	BIT8
		MASK	LOW3
		TS	L
		INDEX	MINDEX
		CAF	FCADRMM1
		TS	BASETEMP
		MASK	HI5
		ADS	L

		CA	BASETEMP		# OBTAIN GENADR PORTION OF 2CADR.
		MASK	LOW10
		AD	BIT11

		TC	SPVAC

V37XEQC		CA	MMTEMP			# UPON RETURN FROM FINDVAC PLACE THE
		MASK	LOW7			# NEW MM IN MODREG (THE LOW 7 BITS OF
		TC	NEWMODEA		# PHSBRDT1)

		TC	RELDSP			# RELEASE DISPLAY
		TC	ENDOFJOB		# AND EXIT

INITSUB		INHINT
		CAF	ELEVEN			# CLEAR INDICATED FLAG BITS
RAKE		TS	MPAC			# LOOP STARTS HERE
		INDEX	MPAC
		CS	FLAGTABL
		INDEX	MPAC
		MASK	FLAGWRD0
		INDEX	MPAC			# RESTORE REVISED FLAGWORD
		TS	FLAGWRD0

		CCS	MPAC
		TCF	RAKE

INITSUBA	EXTEND
		QXCH	MPAC +1

		INHINT
		CAF	TRACKBIT		# BYPASS IF TRACKFLG ON
		MASK	FLAGWRD1
		CCS	A
		TCF	INITRET
		TC	E6SETTER		# FOR DB CODE.. STARTSB2 WILL RESET.
		TC	STOPRATE

		CA	FLAGWRD9		# RESTORE DEADBAND
		MASK	MAXDBBIT
		CCS	A
		TCF	SETMAXER		# MAX DB SELECTED
		TC	BANKCALL		# MIN DB SELECTED
		CADR	SETMINDB
		TCF	INITRET

SETMAXER	TC	BANKCALL
		CADR	SETMAXDB

INITRET		RELINT
		CA	NEGONE
		TS	OPTIND
		TC	MPAC	+1		# RETURN FROM INITSUB

INITSUBB	TC	INITSUBA		# ENTRANCE USED BY RTB CALL FROM V56
		TC	DANZIG

FLAGTABL	OCT	17001			# P29FLAG FIXME
		OCT	40			# IDLEFAIL
		OCT	06404			# P21FLAG,STEERSW,IMPULSW FIXME
		OCT	20400			# GLOKFAIL, POOFLAG
		OCT	0
		OCT	01100			# V59FLAG,NEWTFLAG,ENGONFLG FIXME
		OCT	10000			# STRULLSW
		OCT	16000			# IGNFLAG,ASTNFLAG,TIMRFLAG
		OCT	0
		OCT	40000			# SWTOVER,V94FLAG FIXME
		OCT	0
		OCT	0

		SETLOC	VAC5LOC
		BANK
		COUNT*	$$/START
VAC5STOR	CA	ZERO			# INITIALIZE INDEX REGISTERS
		TS	ITEMP1
		TS	ITEMP2

V5LOOP1		EXTEND				# LOOP TO STORE LOCS, BANKSETS, AND PRIOS.
		INDEX	ITEMP1
		DCA	LOC
		INDEX	ITEMP2
		DXCH	VAC5

		INDEX	ITEMP1
		CA	PRIORITY
		INDEX	ITEMP2
		TS	VAC5 +2

		CS	ITEMP2			# HAVE WE STORED THEM ALL?
		AD	EIGHTEEN
		EXTEND
		BZF	V5OUT1			# YES, GET PHASE INFORMATION.

		CA	TWELVE			# NO, INCREMENT INDEXES AND LOOP.
		ADS	ITEMP1
		CA	THREE
		ADS	ITEMP2
		TCF	V5LOOP1

		EBANK=	PHSNAME1
V5OUT1		CA	EBANK3			# PHSNAME REGISTERS ARE IN EBANK3.
		TS	EBANK

		CA	ELEVEN			# GET PHASE 2CADRS.
		TC	GENTRAN
		ADRES	PHSNAME1
		ADRES	VAC5 +21D

		CA	ZERO			# NOW INITIALIZE INDEXES AGAIN.
		TS	ITEMP1
		TS	ITEMP2

V5LOOP2		INDEX	ITEMP1			# LOOP TO GET PHASE TABLES.
		CA	PHASE1
		INDEX	ITEMP2
		TS	VAC5 +33D
		CS	ITEMP2			# DO WE HAVE THEM ALL?
		AD	FIVE
		EXTEND
		BZF	V5OUT2			# YES, GO FINISH UP.

		CA	TWO			# NO, INCREMENT INDEXES AND LOOP.
		ADS	ITEMP1
		INCR	ITEMP2
		TCF	V5LOOP2

V5OUT2		CA	MPAC +3
		TS	VAC5 +39D

		EXTEND
		DCA	NEWLOC
		DXCH	VAC5 +40D

		CA	NEWJOB
		TS	VAC5 +22D

		CA	NEWPRIO
		TS	VAC5 +26D

		TC	SWRETURN

EIGHTEEN	EQUALS	OCT22
		SETLOC	VERB37
		BANK

		COUNT*	$$/V37
NEG7		EQUALS	OCT77770

OCT44571	OCT	44571			# CONSTANTS TO CLEAR CHANNEL BITS IN V37
OCT600		OCT	600
BIT7-8		OCT	300
OCT01120	OCT	01120

V37QCAD		CADR	V37XEQ+3
ROOAD		CADR	DUMMYAD
3.1SEC		OCT	37312			# 2.5 + 0.6 SEC

# FOR VERB 37 TWO TABLES ARE MAINTAINED. EACH TABLE HAS AN ENTRY FOR EACH
# MAJOR MODE THAT CAN BE STARTED FROM THE KEYBOARD. THE ENTRIES ARE PUT
# INTO THE TABLE WITH THE ENTRY FOR THE HIGHEST MAJOR MODE COMING FIRST,
# TO THE LOWEST MAJOR MODE WHICH IS THE LAST ENTRY IN EACH TABLE.
#
# THE FCADRMM TABLE CONTAINS THE FCADR OF THE STARTING JOB OF
# THE MAJOR MODE.  FOR EXAMPLE,
#
#	FCADRMM1	FCADR	P79		START OF P 79
#			FCADR	PROG18		START OF P 18
#			FCADR	P01		START OF P 01

FCADRMM1	EQUALS
		FCADR	P88
		FCADR	P87
		FCADR	P86
		FCADR	P85
		FCADR	P84
		FCADR	P83
		FCADR	P82
		FCADR	P81
		FCADR	P77
		FCADR	P62
		FCADR	P61
		FCADR	P55
		FCADR	P54
		FCADR	P53
		FCADR	PROG52
		FCADR	P51
		FCADR	P50
		FCADR	P48CSM
		FCADR	P47CSM
		FCADR	P41CSM
		FCADR	P40CSM
		FCADR	P38
		FCADR	P37
		FCADR	P36
		FCADR	P35
		FCADR	P34
		FCADR	P33
		FCADR	P32
		FCADR	P31
		FCADR	P30
		FCADR	P29
		FCADR	P25CSM
		FCADR	PROG21
		FCADR	PROG20
		FCADR	P06
		FCADR	GTSCPSS1			# GYROCOMPASS STANDARD LEAD IN.
## FIXME DELETE THESE
P48CSM		EQUALS
P33		EQUALS
P32		EQUALS
P31		EQUALS
P25CSM		EQUALS

#          THE PREMM TABLE CONTAINS THE EBANK,MAJOR MODE AND DOWNLINK INFO.
# IT IS IN THE FOLLOWING FORMAT
#	   DDD 00E EEM MMM MMM
#          WHERE THE 7 M BITS CONTAIN THE MAJOR MODE NUMBER
#		      3 E BITS CONTAIN THE E-BANK NUMBER
#		      3 D BITS CONTAIN THE DOWNLIST ID
#
#	   COAST AND ALIGN LIST =  0
#	   EUTRY LIST		=  1
#	   RENDEZVOUS LIST	=  2
#	   POWERED FLIGHT LIST	=  3
#	   P22 LIST		=  4
#
#          FOR EXAMPLE,
#
#						   OCT     21137	DOWNLIST   = 2 (RENDEZVOUS)
#									E-BANK	   = 4
#									MAJOR MODE = 95
#
#						   OCT	   11476	DOWNLIST   = 1 (ENTRY)
#									E-BANK	   = 6
#									MAFOR MODE = 62

PREMM1		EQUALS
		OCT	21530		# MM 86  EBANK 6  DOWNLIST 2
		OCT	21527		# MM 86  EBANK 6  DOWNLIST 2
		OCT	21526		# MM 86  EBANK 6  DOWNLIST 2
		OCT	21525		# MM 85  EBANK 6  DOWNLIST 2
		OCT	21524		# MM 84  EBANK 6  DOWNLIST 2
		OCT	21523		# MM 83  EBANK 6  DOWNLIST 2
		OCT	21522		# MM 82  EBANK 6  DOWNLIST 2
		OCT	21521		# MM 81  EBANK 6  DOWNLIST 2
		OCT	21715		# MM 70 FIXME
		OCT	11476		# MM 62  EBANK 6  DOWNLIST 1
		OCT	31475		# MM 61  EBANK 6  DOWNLIST 3
		OCT	01667		# MM 55 FIXME
		OCT	01266		# MM 54  EBANK 5  DOWNLIST 0
		OCT	01265		# MM 53  EBANK 5  DOWNLIST 0
		OCT	01264		# MM 52  EBANK 5  DOWNLIST 0
		OCT	01263		# MM 51  EBANK 5  DOWNLIST 0
		OCT	01662		# MM 50 FIXME
		OCT	31460		# MM 48 FIXME
		OCT	31457		# MM 47  EBANK 7  DOWNLIST 3 FIXME
		OCT	31451		# MM 41  EBANK 6  DOWNLIST 3
		OCT	31450		# MM 40  EBANK 6  DOWNLIST 3
		OCT	21046		# MM 38 FIXME
		OCT	21645		# MM 37  EBANK 7  DOWNLIST 2 FIXME
		OCT	21044		# MM 36  EBANK 4  DOWNLIST 2
		OCT	21043		# MM 35  EBANK 4  DOWNLIST 2
		OCT	21042		# MM 34  EBANK 4  DOWNLIST 2
		OCT	21041		# MM 33  EBANK 4  DOWNLIST 2
		OCT	21040		# MM 32  EBANK 4  DOWNLIST 2
		OCT	21037		# MM 31  EBANK 4  DOWNLIST 2
		OCT	21636		# MM 30  EBANK 7  DOWNLIST 2
		OCT	21635		# MM 29  EBANK 7  DOWNLIST 2
		OCT	21431		# MM 25 FIXME
		OCT	21025		# MM 21  EBANK 4  DOWNLIST 2 FIXME
		OCT	21424		# MM 20  EBANK 6  DOWNLIST 2
		OCT	01006		# MM 06  EBANK 4  DOWNLIST 0
		OCT	01201		# MM 01  EBANK 5  DOWNLIST 0

# NOTE,    THE FOLLOWING CONSTANT IS THE NUMBER OF ENTRIES IN EACH OF
# ---- 	   THE ABOVE LISTS-1 (IE, THE NUMBER OF MAJOR MODES(EXCEPT P00)
#	   THAT CAN BE CALLED FROM THE KEYBOARD MINUS ONE)

EPREMM1		EQUALS			# END OF PREMM1 TABLE
		SETLOC	PREMM1		# THIS CODING WILL AUTOMATICALLY CHANGE
NO.MMS		=MINUS	EPREMM1		# THE 'NOV37MM' CONSTANT AS ENTRIES ARE
		SETLOC	VERB37		# INSERTED(IN) OR DELETED(FROM) THE
		BANK			# 'PREMM1' TABLE.

NOV37MM		ADRES	NO.MMS	-1	# ITEMS IN 'PREMM1' TABLE - 1. *DON'T MOVE*

DNLADP00	=	ZERO

		SETLOC	INTINIT3
		BANK

		COUNT*	$$/INTIN

		EBANK=	RRECTCSM

STATEUP		SET			# EXTRAPOLATE CM STATE VECTOR	
			VINTFLAG
		CLEAR	CALL
			PRECIFLG
			INTEGRV
		DLOAD
			TETCSM
		STCALL	TDEC1
			INTSTALL
		CLEAR	CALL		# EXTRAPOLATE LM STATE VECTOR
			VINTFLAG
			SETIFLGS	# 	AND 6X6 W-MATRIX IF VALID
		BOF	SET
			RENDWFLG	#	FOR RENDEZVOUS NAVIGATION
			+2
			DIM0FLAG
		SET	CALL
			PRECIFLG
			INTEGRV
STATEND		CLRGO
			NODOFLAG
			ENDINT

# THISVINT IS CALLED BY MIDTOAV1 AND 2

THISVINT	SET	RVQ
			VINTFLAG
