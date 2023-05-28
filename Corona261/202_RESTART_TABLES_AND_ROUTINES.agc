### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	501_RESTART_TABLES_AND_ROUTINES.agc
## Purpose:	Part of the source code for Solarium build 55. This
##		is for the Command Module's (CM) Apollo Guidance
##		Computer (AGC), for Apollo 6.
## Assembler:	yaYUL --block1
## Contact:	Jim Lawton <jim DOT lawton AT gmail DOT com>
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2009-10-02 JL	Created.
##		2016-08-18 RSB	Corrected typos
##		2016-08-23 RSB	More of the same.
## 		2016-12-28 RSB	Proofed comment text using octopus/ProoferComments,
##				and fixed errors found.

#  RESTART  TABLES
#  ----------------
#
#	THESE CONTROL RESTART OPERATION.
#



#  ...IMPORTANT...   DO NOT MOVE THIS SECTION FROM BEGINNING OF BANK. DJL

		SETLOC	26000		# START OF BANK 13.
WTDTTAB		DEC	0		# WAITLIST DT FOR RESTART 1.0
WCADRTAB	CADR	0		# WAITLIST CADR.
PRIOTAB		OCT	0		# PRIORITY VALUE.
CADRTAB		CADR	0		# CADR OF CURRENT JOB

# ANY JOB 1 RESTARTS SHOULD GO HEFE.

## 202 ???: Added 2.1SPOT
2.1SPOT		OCT	77777		# 2.1 RESTART
		OCT	77777
		CADR	TROLL +1
		CADR	MONITSK1

2.2SPOT		OCT	0		# RESTART 2.2 VALUES.
		OCT	0
		OCT	12000		# PRIO12
## 202 K: Renamed to VERTINIT
		CADR	VERTINIT

2.3SPOT		OCT	0		# 2.3 RESTART
		OCT	0
		OCT	12000
		CADR	ATTIJOB1 -1

2.4SPOT		OCT	0		# RESTART 2.4
		OCT	0
		OCT	12000
		CADR	ATTIJOB
		
## 202 ???: Added 2.5SPOT
2.5SPOT		OCT	0		# 2.5 RESTART.
		OCT	0
		OCT	77777
		CADR	DOMANU

# ANY MORE GROUP 2 RESTART VALUES SHOULD GO HERE.
#

3.1SPOT		OCT	77777		# 3.1 RESTART.
		OCT	77777
## 202 ???: Changed names
		CADR	TPITCH +1	# CONTAINS DT
		CADR	MONITASK
		
3.2SPOT		OCT	77777		# 3.2 RESTART
		OCT	77777
		CADR	TTUMON
		CADR	TUMBTSK1
		
		OCT	0		# 3.3 RESTART
		OCT	0
		OCT	77777
		CADR	REDO3.3
		
		DEC	700		# 3.4 RESTART.
		CADR	GIMPOWOF
		OCT	0
		OCT	0
		
		DEC	1050		# 3.5 RESTART
		CADR	DVMODOFF
		OCT	0
		OCT	0
		
		DEC	1075		# 3.6 RESTART.
		CADR	ATTCONON
		OCT	0
		OCT	0
		
		DEC	75		# 3.7RESTART
		CADR	CGTASK
		OCT	0
		OCT	0
		
		DEC	200		# 3.8 RESTART.
		CADR	GMPOFF3
		OCT	0
		OCT	0
		
		OCT	0		# 3.9 REATART.
		OCT	0
		OCT	77777
		CADR	SETMOD23
		
		OCT	0		# 3.10 RESTART.
		OCT	0
		OCT	27000
		CADR	SHUTJOB
		
		DEC	500		# 3.11 RESTART.
		CADR	CDUXTASK	# 5SECS FROM TBASE3
		OCT	0
		OCT	0
		
3.12SPOT	DEC	1000		# 3.12 RESTART.
		CADR	CM/SMTSK	# 10SECS FROM TBASE3
		OCT	20000
		CADR	CDUXJOB
		
		DEC	1000		# 3.13 RESTART.
		CADR	CM/SMTSK
		OCT	20000
		CADR	REDO3.13
		
		DEC	1000		# 3.14 RESTART.
		CADR	CM/SMTSK
		OCT	0
		OCT	0
		
3.15SPOT	DEC	1500		# 3.15 RESTART
		CADR	ENTATASK	# 15SECS FROM TBASE3
		OCT	0
		OCT	0
		
3.16SPOT	OCT	0		# 3.16 RESTART.
		OCT	0
		OCT	15000		# PRIO TO REDO HUNTEST.
		CADR	PREHUNT

3.17SPOT	2DEC	0		# 3.17 RESTART.  ...PRELAUNCH...
		OCT	20000
		CADR	REPL11
		
		2DEC	0		# 3.18 RESTART.  ...PRELAUNCH...
		OCT	20000
		CADR	REPL12
		
		2DEC	0		# 3.19 RESTART  ...PRELAUNCH...
		OCT	20000
		CADR	REDO3.21
		
		2DEC	0		# 3.20 RESTART.  ...PRELAUNCH...
		OCT	77777
		CADR	REDO3.20
		
		DEC	50		# 3.21 RESTART.  ...PRELAUNCH...
		CADR	REPRELAL
		OCT	21000
		CADR	REDO3.21
		
		DEC	50		# 3.22 RESTART.  ...PRELAUNCH
		CADR	REPRELAL
		2DEC	0.0

3.23SPOT	DEC	200		# 3.23 RESTART
		CADR	GMPOFF2
		2DEC	0.0
		
3.24SPOT	DEC	350		# 3.24 RESTART
		CADR	DVMODOF2
		2DEC	0.0
		
		DEC	550		# 3.25 RESTART
		CADR	DVMODOF2
		2DEC	0.0
#  ANY MORE GROUP 3 RESTART VALUES SHOULD GO HERE.
		2DEC	0.0		# 3.26 RESTART
		OCT	77777
		CADR	MONITASK
		
		2DEC	0.0		# 3.27 RESTART
		OCT	77777
		CADR	TUMBTSK1

#	ANY MORE GROUP 3 RESTARTS GO IN HERE

4.1SPOT		OCT	0		# 4.1 RESTART.
		OCT	0
		OCT	34000		# HIGH PRIO.  (WATCH THIS.)
		CADR	REDO4.1
		
4.2SPOT		OCT	77777		# 4.2 RESTART.
		OCT	77777
		CADR	LONGTIME +1
		CADR	ENGINOFF
		
4.3SPOT		DEC	1050		# 4.3 RESTART.
		CADR	COASTPHS
		OCT	77777
		CADR	REDO4.3
		
4.4SPOT		2DEC	-30000		# 4.4 RESTART
		2DEC	0
		
		DEC	14616		# 4.5 RESTART  (DT = 146.16 SEC
		CADR	FDAOFTSK	#    (310 - 163.84 SEC.)
		2DEC	0
		
		OCT	77777		# 4.6 RESTART
		CADR	TCOAST		# TCOAST = TIME FORM CUTOFF TO UPTASK.
		2DEC	0
		
		OCT	0		# 4.7 RESTART
		OCT	0
		OCT	77777
		CADR	UPTASK
		
## 202 ???
		DEC	1800		# 4.8 RESTART
		CADR	PLUSX1
		OCT	06000
		CADR	UPJOB
		
		DEC	1800		# 4.9 RESTART
		CADR	PLUSX1
		OCT	06000
		CADR	REDO4.9
		
		DEC	600		# 4.10 RESTART
		CADR	GIMPOWON
		OCT	77777
		CADR	REDO4.10
		
		DEC	200		# 4.11 RESTART.
		CADR	TARGTASK
		2DEC	0
		
		DEC	170		# 4.12 RESTART.
		CADR	ABRTWAIT	#  IN 1.7 SEC.
		OCT	25000
		CADR	SETS4SEP
		
## 202 ???
		DEC	1220		# 4.13 RESTART
		CADR	ATTCNOFF	# IN 12.2 SEC.
		2DEC	0
		
4.14SPOT	DEC	600		# 4.14 RESTART.
		CADR	GIMPOWON
		OCT	77777
		CADR	REDO4.14
		
		DEC	250		# 4.15 RESTART.
		CADR	ATTCNOFF	# IN 2.5 SEC
		OCT	25000
		CADR	ABORTRPT -3	#  WATCH THIS LOC.
		
## 202 ???: 550->250
		DEC	250		# 4.16 RESTART
		CADR	ATTCNOFF
		OCT	25000
		CADR	REDO4.16


## 202 ???: 10800->4600
		DEC	4600		# 4.17 RESTART
		CADR	GIMPOWON
		2DEC	0
		
		2DEC	0		# 4.18 RESTART.
		OCT	77777
		CADR	ATTCNOFF

		DEC	25		# 4.19 RESTART.
		CADR	DVMODEON
		2DEC	0
		
		DEC	50		# 4.20 RESTART.
		CADR	ENGINEON
		2DEC	0
		
4.21SPOT	DEC	1550		# 4.21 RESTART
		CADR	PLUSXOFF
		OCT	77777
		CADR	REDO4.22
		
		2DEC	0		# 4.22 RESTART.
		OCT	77777
		CADR	REDO4.22
		
		DEC	350		# 4.23 RESTART
		CADR	ENGINOFF
		OCT	77777
		CADR	STEEROFF
		
		2DEC	0		# 4.24 RESTART.
		OCT	77777
		CADR	GIMPOWON
		
		DEC	350		# 4.25 RESTART
		CADR	ATTCNOFF
		2DEC	0
		
4.26SPOT	2DEC	0		# 4.26 RESTSRT.
		OCT	12000		# LOWERED.
		CADR	UPTHETA1

4.27SPOT	DEC	2000		# 4.27 RESTART
		CADR	PLUSX2
		2DEC	0

4.28SPOT	2DEC	0		# 4.28 RESTART SAVES ENGIN OFF SEQUENCE
		OCT	77777		# WHILE TBASE4 UPDATED
		CADR	SPS1TEST
		
#  ANY MORE GROUP 4 RESTART VALUES SHOULD GO HERE.

5.1SPOT		DEC	200		# 5.1 RESTART
		CADR	REREADAC
		2DEC	0
		
5.2SPOT		2DEC	0
		OCT	77777
		CADR	REDO5.2
		
		DEC	200		# 5.3 RESTART
		CADR	REREADAC
		OCT	17000
		CADR	REDO5.3
		
		DEC	200		# 5.4 RESTART
		CADR	REREADAC
		OCT	17000
		CADR	REFAZE6


		DEC	200		# 5.5 RESTART.
		CADR	REREADAC
		OCT	17000
		CADR	REDO5.5
		
		DEC	200		# 5.6 RESTART
		CADR	REREADAC
		OCT	35000
		CADR	MODE32
		
5.7SPOT		2DEC	0		# 5.7 RESTART
		OCT	77777
		CADR	REDO5.7
		
		DEC	200		# 5.8 RESTART
## 202 K: Renamed to VERTASK1 and VERTIJOB
		CADR	VERTASK1
		OCT	14000
		CADR	VERTIJOB
		
		DEC	200		# 5.9 RESTART.
		CADR	VERTASK1
		OCT	13000
		CADR	REFAZE6
		
		2DEC	0		# 5.10 RESTART.
		OCT	12000
		CADR	REDO5.10
		
		DEC	200		# 5.11 RESTART
		CADR	VERTASK1
		2DEC	0
		
5.12SPOT	DEC	200		# 5.12 RESTART.
		CADR	REPIPUP
		2DEC	0
		
		2DEC	0		# 5.13 RESTART.
		OCT	77777
		CADR	REDO5.13
		
		DEC	200
		CADR	REPIPUP
		OCT	17000
		CADR	ENTRYTOP +3
		
		DEC	200		# 5.15 RESTART.
		CADR	REPIPUP
		OCT	17000
		CADR	REFAZE4
		
		DEC	200		# 5.16
		CADR	REPIPUP
		OCT	16000
		CADR	REFAZE6
		
		DEC	200		# 5.17 RESTART.
		CADR	REPIPUP
		OCT	17000
		CADR	REFAZE8
		
5.18SPOT	DEC	200		# 5.18 RESTART
		CADR	REPIPUP
		OCT	17000
		CADR	REFAZE10
		
5.19SPOT	DEC	200		# 5.19 RESTART.  (PIPUP IN 2 SEC.)
		CADR	REPIPUP
		OCT	17000
		CADR	NUMODE63	# SETS MODE 63 AND FINISHES ENTRY INITIAL.
		
5.20SPOT	2DEC	0.0		# 5.20 RESTART FOR VERB 76
		OCT	34000
		CADR	REDO5.20
		
5.21SPOT	DEC	0.		# 5.21 RESTART IS SPARE
		CADR
		OCT	0
		CADR
		
5.22SPOT	DEC	0.		# 5.22 RESTART IS SPARE
		CADR
		OCT	0
		CADR
		
5.23SPOT	DEC	200		# 5.23 RESTART
		CADR	REREADAC
		OCT	17000
		CADR	REDO5.23
		
# 	ANY MORE GROUP 5 RESTARTS GO HERE.

#
6.1SPOT		DEC	0		# 6.1 RESTART  (UNDEFINED)



#
#   ANY MORE GROUP 6 RESTART VALUES SHOULD GO HERE.
#



SIZETAB		DEC	0		# 0 INCREMENT FOR GROUP 1.
		TC	2.1SPOT -26004	# INCREMENT TO INDEX GROUP 2 TABLE
		TC	3.1SPOT -26004	# INCREMENT TO INDEX GROUP 3
		TC	4.1SPOT -26004	# INCREMENT TO INDEX GROUP 4 TABLE.
		TC	5.1SPOT -26004	# INCREMENT TO INDEX GROUP 5 TABLE.
		TC	6.1SPOT -26004	# INCREMENT TO INDEX GROUP 6 TABLE.


#   GENERALIZED RESTART ROUTINE.



# FOR EACH FAZEBIT VALUE , THE ASUMPTION IS MADE THAT THERE MAY EXIST
#  ONE WAITLIST OR LONGCALL TASK TO BE RECALLED.  AND ONE CURRENT TASK OR
#  JOB TO BE RESTARTED.  (SPECIAL RESTARTS ARE POSSIBLE FOR SITUATIONS 
#  WHICH DONOT FIT THE GENERAL FORM.)  FOR THE GENERAL CASE,  FOUR TABLES
#  ARE USED.
#	(RATHER,  ONE TABLE WITH 4 ENTRIES PER FAZEBIT VALUE.)
#		1.  WTDTTAB.  WAITLIST DT TABLE.
#		2.  WCADRTAB  WAITLIST CADR TABLE.
#		3.  PRIOTAB  CURRENT JOB PRIORITY. (NEG NUMB IF TASK.)
#		4.  CADRTAB  CURRENT JOB (OR TASK) RESTART LOCATION.
#  IN ADDITION, THERE EXISTS A SIZE TABLE THAT LISTS THE NUMBER OF
#  LOCATIONS USED BY EACH PROFRAM FOR RESTARTS.
#		...MORE TO COME LATER...		(DJL)



RESTARTS	XCH	MPAC		# FAZE BITS FOR THIS PROG IN MPAC.
		DOUBLE
		DOUBLE			# MULTILY BY 4.  (4 ITEMS PER ENTRY.)
		INDEX	PROG		# PROG CONTAINS THE PROGRAM NUMBER.
		AD	SIZETAB -1
		TS	POINTER
		CAF	TCURRENT
		TS	GOLOC +1	# EXIT LOCATION.
		CAF	TCWAIT		# SET A WAITLIST CALL IN ERASABLE.
		TS	GOLOC -1
		
		INDEX	POINTER
		CAF	WTDTTAB
		CCS	A
		TC	WTCALL		# +N = WAITLIST CALL
		TC	CURNTJOB	# +0 = NO CALL
		TC	LONGCLER	# -N = LONGCALL
		INDEX	POINTER		# -0 = INDIRECT (PROBABLY)
		CAF	WCADRTAB
		CCS	A
		TC	INDIRECT
TCURRENT	TC	CURNTJOB	# NO ZERO CALLS
		TC	LONGCLER -1	# NEG OF TIME FOR SHORT LONG.
		TC	SINDIR
		
		CS	ONE
LONGCLER	AD	ONE		# RESTORE LONGTIME
		TS	RECALL
		INDEX	POINTER
		CS	WCADRTAB	# STORED NEGATIVELY.
		TS	RECALL +1
		TC	IBNKCALL
		CADR	NULONGDT
		TC	IBNKCALL
		CADR	LONGCALL
		TC	CURNTJOB



# 



#  INDIRECT SECTION TAKES THE DP TIME FRON THE ERASABLE LOCATIONS BY THE
#     NUMBER IN THE WCADRTAB.    (WTDTTAB = -0.)

INDIRECT	TS	ECADTEM		# CADR-1 IS STORED.  (DUE TO CCS.) 
		INDEX	A
		CS	1		# (1 NOT 0 BECAUSE CADR OFF BY 1.)
		COM			# (NOT NEEDED IF NEG TIME STROED.USAGE..)
		TS	RECALL		# AND STORE MAJOR PART.
		INDEX	ECADTEM
		CS	2		# AGAIN ONE MORE THAN USUAL.
		COM
		TC	LONGCLER +4	# STORE MINOR PART THERE



# ASSIGNMENTS ETC.

GOLOC		EQUALS	OVFIND		# USES ONE LOCATION ON EACH SIDE OF IT.
TEMDT		EQUALS	MPAC +2
RECALL		EQUALS	MPAC +1		# MUNTZ NOW USINF LOC IN RESTART CONTROL.
ECADTEM		EQUALS	RECALL +1	# LOOKS OK.
POINTER		EQUALS	MPAC
#   MPAC + 1 SAVED BECAUSE OF USE IN RESTART CONTROL.  (CCS MPAC + 1)

#    THIS ROUTINE LEAVES THE WITLIST CALL AS GIVEN BY WCADRTAB.

WTCALL		AD	ONE		# DT-1 IN A ON ENTRY.  (FROM CCS.)
		COM			# STORE NEGATIVE OF DT IN TEMDT.
		TS	TEMDT
		INDEX	POINTER
		CAF	WCADRTAB	# PICK UP CADR FOR THIS CALL.
		TS	GOLOC		# GOLOC+1 AND -1 ALREADY SET-UP.
		
WTCALL2		INDEX	PROG		# FIRST GET TBASE - TIME1
		CS	TBASE2 -2	# TBASE STORED NEGATIVELY
		EXTEND
		SU	TIME1		# TBASE - TIME1
		CCS	A		# THIS SHOULD BE NEGATIVE IF ALL OK.
		COM			# GET POSMAX - A.
		AD	OCT37776	# 1 BIT SHY OF POSMAX.
		AD	ONE		# RESTORE BIT LOST BY CCS.
		AD	TEMDT		# TIME1 - TBASE -DT  NOW IN A.
		CCS	A		# TEST IT.  SHOULD BE NEGATIVE.
		CAF	ZERO		# EXCEEDED TIME.  BAD,BAD...
		TC	+2		# (+0 JUST POSSIBLE.)
		TC	+1		# YES, EVERYTHING OK.
		AD	ONE		# NOW IS THE TIME.
		TC	GOLOC -1



OCT37776	OCT	37776		# POSMAX - 1



SINDIR		CAF	TCSWRET
		TS	GOLOC +1
		INDEX	POINTER
		CAF	CADRTAB		# PICK UP CADR TO GO TO.
		TS	GOLOC
		
		INDEX	POINTER
		INDEX	PRIOTAB		# IT POINTS ATTHE ERASABLE LOCATION OF DT
		CS	0		# NEG OF DT IN A.
		TS	TEMDT
		TC	WTCALL2		# JOIN THERE TO RECOMPUTE TIME REMAINING.
		

#  GETS CURRENT JOB (OR TASK) RERUNNING.

CURNTJOB	INDEX	POINTER
		CAF	CADRTAB
		TS	GOLOC		# PUT ADDRESS THERE (CADR)
		CAF	TCSWRET
		TS	GOLOC +1	# WHERE TO WHEN DONE.
		INDEX	POINTER
		CAF	PRIOTAB		# PRIORITY TABLE.
		CCS	A		# TEST IT.
		TC	ITSAPRIO	# +N = PRIORITY.
TCSWRET		TC	SWRETURN	# +0 = NO JOB OR TASK.
		TC	SHINDIRT	# -N = SHORT INDIRECT FORM.
		AD	ONE		# -0 = IMMEDIATE WAITLIST CALL.
		TC	GOLOC -1	# -0 WILL CRASH OUT HERE...
		
ITSAPRIO	AD	ONE		# RESTORE CORRECT PRIORITY VALUE.
		TS	GOLOC -1	# SAVE THERE TEMPORARILY.
		CAF	TCFINDVC	# N3 RPOVISION FOR NOVAC.
		XCH	GOLOC -1	# PICKING UP PRIORITY AGAIN.
		TC	GOLOC -1	# AND GET THE JOB STARTED. (EXIT VIA SWRET



#   SHORT INDIRECT SECTION IS NOT USED AS YET.

SHINDIRT	INDEX	A
		CS	1		# CCS DECREASED ADDRESS BY 1 OF DT LOC.
		TS	TEMDT
		TC	WTCALL2		# -DT IN A WHEN REJOINING WTCALL.



#  TBASE REGISTERS CONTAIN NEGATIVE OF TIME AT START OF SEQUENCE.

#  ROUTINE TO GENERATE  NEW DELTA T (LONGTIME) FOR LONGCALL.

NULONGDT	TC	READTIME +1	# GET TIME.  (ALREADY INHIBITTED.)
		CAF	ZERO
		AD	TCUTOFF +1	#  (POSITIVE NUMBER)
		AD	RUPTSTOR +1	# (NEGATIVE NUMBER)
		AD	RECALL +1
		TS	LONGTIME +1	# (COULD OVERFLOW)
		CAF	ZERO
		AD	TCUTOFF
		AD	RUPTSTOR
		AD	RECALL
		XCH	LONGTIME	# NO OVERFLOW.
		CCS	LONGTIME	# TEST FOR POSITIVE DT.
		TC	ISWRETRN	# (DONT HAVE TO USE ICALLS IF SAME BANK.)
		TC	+2
		TC	BADLONG
		CCS	LONGTIME +1
		TC	ISWRETRN
		TC	+1
BADLONG		CAF	ZERO
		TS	LONGTIME
		CAF	ONE		# LEAVE A CALL FOR 1 DT.
		TS	LONGTIME +1
		TC	ISWRETRN	# ...AND EXIT.
#    THIS COULD BE MODIFIED EASILY TO CHANGE BAD DT POLICY.
