### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	TVCINITIALIZE.agc
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

# NAME		TVCDAPON (TVC DAP INITIALIZATION AND STARTUP CALL)
# LOG SECTION...TVCINITIALIZE			SUBROUTINE...DAPCSM
# MODIFIED BY SCHLUNDT				21 OCTOBER 1968
# MODIFIED BY BEALS TO ELIMINATE CSMMASS UPDATE LOGIC (NOW DONE IN S40.8)
# FUNCTIONAL DESCRIPTION
#	PERFORMS TVCDAP INITIALIZATION (GAINS, TIMING PARAMETERS, FILTER VARIABLES, ETC.)
#	COMPUTES STEERING (S40.8) GAIN KPRIMEDT, AND ZEROES PASTDELV,+1 VARIABLE
#	MAKES INITIALIZATION CALL TO ..NEEDLER.. FOR TVC DAP NEEDLES-SETUP
#	PERFORMS INITIALIZATION FOR ROLL DAP
#	CALLS TVCEXECUTIVE AT TVCEXEC, VIA WAITLIST
#	CALLS TVCDAP CDU-RATE INITIALIZATION PKG AT DAPINIT  VIA T5
#	PROVIDES FOR LOADING OF LOW-BANDWIDTH COEFFS AND GAINS AT SWICHOVR
# CALLING SEQUENCE - T5LOC=2CADR(TVCDAPON,EBANK=BZERO), T5=.6SECT5
#	IN PARTICULAR, CALLED BY ..DOTVCON.. IN P40
#	MRCLEAN AND TVCINIT4 ARE POSSIBLE RESTART ENTRY POINTS
# NORMAL EXIT MODE
#	TCF RESUME
# SUBROUTINES CALLED
#	NEEDLER, MASSPROP
# ALARM OR ABORT EXIT MODES
#	NONE
# ERASABLE INITIALIZATION REQUIRED
#	CSMMASS, LEMMASS, DAPDATR1 (FOR MASSPROP SUBROUTINE)
#	TVC PAD LOADS (SEE EBANK6 IN ERASABLE ASSIGNMENTS)
#	PACTOFF, YACTOFF, CDUX
#	TVCPHASE AND THE T5 BITS OF FLAGWRD6 (SET AT DOTVCON IN P40)
# OUTPUT
#	ALL TVC AND ROLL DAP ERASABLES, FLAGWRD6 (BITS 13,14), T5, WAITLIST
# DEBRIS
#	NONE

		SETLOC	DAPS7
		BANK

		COUNT*	$$/INIT
		EBANK=	CNTR		
TVCDAPON	LXCH	BANKRUPT	# T5 RUPT ARRIVAL (CALL BY DOTVCON - P40)
		EXTEND			# SAVE Q REQUIRED IN RESTARTS (MRCLEAN AND
		QXCH	QRUPT		#	TVCINIT4 ARE ENTRIES)
MRCLEAN		CAF	NZERO		# NUMBER TO ZERO, LESS ONE  (MUST BE ODD)
					#	TVC RESTARTS ENTER HERE  (NEW BANK)
 +1		CCS	A
		TS	CNTR
		CAF	ZERO
		TS	L
		INDEX	CNTR
		DXCH	OMEGAYC		# FIRST (LAST) TWO LOCATIONS
		CCS	CNTR
		TCF	MRCLEAN +1
		EXTEND			# SET UP ANOTHER T5 RUPT TO CONTINUE
		DCA	INITLOC2	#	INITIALIZATION AT TVCINIT1
		DXCH	T5LOC		# THE PHSCHK2 ENTRY  (REDOTVC) AT TVCDAPON
		CAF	POSMAX		#	+3 IS IN ANOTHER BANK. MUST RESET
		TS	TIME5		#	BBCON TOO (FULL 2CADR), FOR THAT
ENDMRC		TCF	RESUME		#	ENTRY.

TVCINIT1	LXCH	BANKRUPT
		EXTEND
		QXCH	QRUPT

		TC	IBNKCALL	# UPDATE IXX, IAVG/TLX FOR DAP GAINS (R03
		CADR	MASSPROP	#	OR NOUNS 46 AND 47 MUST BE CORRECT)

		CAE	DAPDATR1	# CHECK LEM-ON/OFF
		MASK	BIT14
		CCS	A
		CAF	BIT1		# LEM-ON (BIT1)
		TS	CNTR		# LEM-OFF (ZERO)

		INDEX	CNTR		# LOAD THE FILTER COEFFICIENTS
		CAF	CSMCFADR
		TS	COEFFADR
		TC	LOADCOEF

		INDEX	CNTR		# PICK UP LM-OFF,-ON KTLX/I
		CAE	EKTLX/I		#	SCALED (1.08 B+2) 1/SECSQ CSM/LM
		TS	KTLX/I		#	       ( "   B+4)    "    CSM

		TCR	S40.15		# COMPUTE 1/CONACC, VARK

TVCINIT2	CS	CNTR		# PICK LM-OFF,-ON VALUE FOR FILTER PERIOD
		INDEX	A		# DETERMINATION:
		CAF	BIT2		#	BIT2 FOR CSM ONLY 40MS FILTER
		TS	KPRIMEDT	#	BIT3 FOR CSM/LM 80MS FILTER

		COM			# PREPARE T5TVCDT
		AD	POSMAX
		AD	BIT1
		TS	T5TVCDT

		CS	SWTOVBIT	# RESET SWTOVER FLAG
		MASK	FLAGWRD9
		TS	FLAGWRD9
		INDEX	CNTR		# PICK UP LEM-OFF,-ON KPRIME
		CAE	EKPRIME		#	SCALED (100 PI)/16
		EXTEND
		MP	KPRIMEDT	# (TVCDT/2, SC.AT B+14CS)
		LXCH	A		#	SC.AT PI/8	(DIMENSIONLESS)
		DXCH	KPRIMEDT
		INDEX	CNTR		# PICK UP LEM-OFF,-ON REPFRAC
		CAE	EREPFRAC
		TS	REPFRAC

		INDEX	CNTR		# PICK UP ONE-SHOT CORRECTION TIME
		CAF	TCORR
		TS	CNTR

		CAF	NINETEEN	# SET VCNTR FOR VARIABLE-GAIN UPDATES IN
		TS	VCNTR		# 10 SECS (TVCEXEC 1/2 SEC RATE)
TVCINIT3	CAE	PACTOFF		# TRIM VALUES TO TRIM-TRACKERS, OUTPUT
		TS	PDELOFF		#	TRACKERS, OFFSET-UPDATES, AND
		TS	PCMD		#	OFFSET-TRACKER FILTERS
		TS	DELPBAR		#	NOTE, LO-ORDER DELOFF,DELBAR ZEROED

		CAE	YACTOFF
		TS	YDELOFF
		TS	YCMD
		TS	DELYBAR

ATTINIT		CAE	DAPDATR1	# ATTITUDE-ERROR INITIALIZATION LOGIC
		MASK	BIT13		#	TEST FOR CSM OR CSM/LM
		EXTEND
		BZF	NEEDLEIN	#	BYPASS INITIALIZATION FOR CSM/LM

		CAF	BIT1		#	SET UP TEMPORARY COUNTER
 +5		TS	TTMP1

		INDEX	TTMP1
		CA	ERRBTMP		# ERRBTMP CONTAINS RCS ATTITUDE ERRORS
		EXTEND			#	ERRORY & ERRORZ (P40 AT DOTVCON)
		MP	1/ATTLIM	# .007325(ERROR) = 0 IF ERROR < 1.5 DEG
		EXTEND
		BZF	+8D		#	|ERROR| LESS THAN 1.5 DEG
		EXTEND
		BZMF	+3		#	|ERROR| > 1.5 DEG, AND NEG
		CA	ATTLIM		#	|ERROR| > 1.5 DEG, AND POS
		TCF	+2
 +3		CS	ATTLIM
 +2		INDEX	TTMP1
		TS	ERRBTMP
 +8		CCS 	TTMP1		#	TEST TEMPORARY COUNTER
		TCF	ATTINIT +5	#	BACK TO REPEAT FOR PITCH ERROR

		CA	ERRBTMP		# ERRORS ESTABLISHED AND LIMITED
		TS	PERRB
		CA	ERRBTMP +1
		TS	YERRB

NEEDLEIN	CS	RCSFLAGS	# SET BIT 3 FOR INITIALIZATION PASS AND GO
		MASK	BIT3		#	TO NEEDLER.  WILL CLEAR FOR TVC DAP
		ADS	RCSFLAGS	#	(RETURNS AFTER CADR)
		TC	IBNKCALL
		CADR	NEEDLER

TVCINIT4	CAF	ZERO		# SET TVCPHASE TO INDICATE TVCDAPON-THRU-
		TS	TVCPHASE	#	NEEDLEIN INITIALIZATION FINISHED.
					#	(POSSIBLE TVC-RESTART ENTRY)

		CAE	CDUX		# PREPARE ROLL DAP
		TS	OGANOW

		CAF	NZERO		# CALL TVCEXECUTIVE IN 0.51 SEC
		TC	WAITLIST
		EBANK=	CNTR
		2CADR	TVCEXEC


		EXTEND			# CALL FOR DAPINIT
		DCA	DAPINIT5
		DXCH	T5LOC
		CAE	T5TVCDT		# (ALLOW TIME FOR RESTART COMPUTATIONS)
		TS	TIME5

ENDTVCIN	TCF	RESUME


SWICHOVR	INHINT
		CA	TVCPHASE	# SAVE TVCPHASE
		TS	PHASETMP
		CS	BIT2		# SET TVCPHASE = -2 (INDICATES SWITCH-OVER
		TS	TVCPHASE	#	TO RESTART LOGIC)

 +5		EXTEND			# SAVE Q FOR RETURN (RESTART ENTRY POINT,
		QXCH	RTRNLOC		#	TVCPHASE AND PHASETMP ALREADY SET)

		CAF	NZEROJR		# ZEROING LOOP FOR FILTER STORAGE LOCS
 +8		TS	CNTRTMP

MCLEANJR	CA	ZERO
		TS	L
		INDEX	CNTRTMP
		DXCH	PTMP1 -1
		CCS	CNTRTMP
		CCS	A
		TCF	SWICHOVR +8D

		CS	FLAGWRD9	# SET SWITCHOVER FLAG FOR DOWNLINK
		MASK	SWTOVBIT
		ADS	FLAGWRD9

		CAE	EKTLX/I +2	# LOW BANDWIDTH GAINS - DAP
		TS	KTLX/I
		TCR	S40.15 	+7

		CAF	FKPRIMDT	#			- STEERING
		TS	KPRIMEDT

		CAF	FREPFRAC	#			- TMC LOOP
		TS	REPFRAC

		EXTEND			# UPDATE TRIM ESTIMATES
		DCA	DELPBAR
		DXCH	PDELOFF
		EXTEND
		DCA	DELYBAR
		DXCH	YDELOFF

		CA	LBCFADR
		TS	COEFFADR
		TC	LOADCOEF

		CAE	PHASETMP	# RESTORE TVCPHASE
		TS	TVCPHASE

		TC	RTRNLOC		# BACK TO PRESWTCH OR TVCRESTARTS


LOADCOEF	EXTEND			# LOAD DAP FILTER COEFFICIENTS
		INDEX	COEFFADR	#   FROM: ERASABLE FOR CSM/LM HB
		DCA	0		#         FIXED    FOR CSM/LM LB
		DXCH	N10		#         FIXED    FOR CSM

		EXTEND			# NOTE: FOR CSM/LM, NORMAL COEFFICIENT
		INDEX	COEFFADR	# LOAD WILL BE HIGH BANDWIDTH PAD LOAD
		DCA	2		# ERASABLES. DURING CSM/LM SWITCHOVER, 
		DXCH	N10 +2		# THIS LOGIC IS USED TO LOAD LOW BANDWIDTH
					# COEFFICIENTS FROM FIXED MEMORY.

		EXTEND
		INDEX	COEFFADR
		DCA	4
		DXCH	N10 +4

		EXTEND
		INDEX	COEFFADR
		DCA	6
		DXCH	N10 +6
		EXTEND
		INDEX	COEFFADR
		DCA	8D
		DXCH	N10 +8D

		EXTEND
		INDEX	COEFFADR
		DCA	10D
		DXCH	N10 +10D

		EXTEND
		INDEX	COEFFADR
		DCA	12D
		DXCH	N10 +12D

		INDEX	COEFFADR
		CA	14D
		TS	N10 +14D

		TC	Q

S40.15		CAE	IXX		# GAIN COMPUTATIONS (1/CONACC, VARK)
		EXTEND			# ENTERED FROM TVCINITIALIZE AND TVCEXEC
		MP	2PI/M		#	2PI/M SCALED 1/(B+8 N M)
		DDOUBL			#	IXX   SCALED B+20 KG-MSQ
		DDOUBL
		DDOUBL
		TS	1/CONACC	#	      SCALED B+9 SEC-SQ/REV

					# ENTRY FROM CSM/LM V46 SWITCHOVER
 +7		CAE	KTLX/I		#	SCALED (1.08 B+2) 1/SECSQ CSM/LM
		EXTEND			#	       (  "  B+4)   CSM
		MP	IAVG/TLX	#	      SCALED B+2 SECSQ
		DDOUBL
		DDOUBL
		TS	VARK		#	SCALED (1.08 B+2)   CSM/LM
		TC	Q		#	       (  "  B+4)   CSM


CSMN10		DEC	.99999		# N10	CSM ONLY FILTER COEFFICIENTS
		DEC	-.2549		# N11/2
		DEC	.0588		# N12
		DEC	-.7620		# D11/2
		DEC	.7450		# D12

		DEC	.99999		# N20
		DEC	-.4852		# N21/2
		DEC	0		# N22
		DEC	-.2692		# D22/2
		DEC	0		# D22

LBN10		DEC	+.99999		# N10	LOW BANDWIDTH FILTER COEFFICIENTS
		DEC	-.3285		# N11/2
		DEC	-.3301		# N12
		DEC	-.9101		# D11/2
		DEC	+.8460		# D12

		DEC	+.03125		# N20
		DEC	0		# N21/2
		DEC	0		# N22
		DEC	-.9101		# D21/2
		DEC	+.8460		# D22

		DEC	+.5000		# N30
		DEC	-.47115		# N31/2
		DEC	+.4749		# N32
		DEC	-.9558		# D31/2
		DEC	+.9372		# D32


CSMCFADR	GENADR	CSMN10		# CSM ONLY COEFFICIENTS ADDRESS
HBCFADR		GENADR	HBN10		# HIGH BANDWIDTH COEFFICIENTS ADDRESS
LBCFADR		GENADR	LBN10		# LOW BANDWIDTH COEFFICIENTS ADDRESS

NZERO		DEC	51		# MUST BE ODD FOR MRCLEAN
NZEROJR		DEC	23		# MUST BE ODD FOR MCLEANJR

ATTLIM		DEC	0.00833		# INITIAL ATTITUDE ERROR LIMIT (1.5 DEG)
1/ATTLIM	DEC	0.007325	# .007325(ERROR) = 0 IF ERROR < 1.5 DEG

TCORR		OCT	00005		# CSM
 +1		OCT	00000		# CSM/LM (HB,LB)

FKPRIMDT	DEC	.0102		# CSM/LM (LB), (.05 X .08) SCALED AT PI/8
FREPFRAC	DEC	.0375 B-2	# CSM/LM (LB),  0.0375 SCALED AT B+2

NINETEEN	=	VD1
2PI/M		DEC	.00331017 B+8	# 2PI/M, SCALED AT 1/(B+8 N-M)

		EBANK=	CNTR
DAPINIT5	2CADR	DAPINIT


		EBANK=	CNTR
INITLOC2	2CADR	TVCINIT1
