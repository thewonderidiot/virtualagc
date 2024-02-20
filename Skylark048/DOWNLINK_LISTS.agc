### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	DOWNLINK_LISTS.agc
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

		SETLOC	DOWNTELM
		BANK

		EBANK=	DNTMBUFF

# SPECIAL DOWNLINK OP CODES
#	OP CODE		 ADDRESS(EXAMPLE)	  SENDS..		BIT 15		BITS 14-12	BITS 11
#													     -0
#	------		----------		----------		------		----------	-------
#													     --
#	1DNADR		TIME2			(2 AGC WDS)		0		0		ECADR
#	2DNADR		TEPHEM			(4 AGC WDS)		0		1		ECADR
#	3DNADR		VGBODY			(6 AGC WDS)		0		2		ECADR
#	4DNADR		STATE			(8 AGC WDS)		0		3		ECADR
#	5DNADR		UPBUFF			(10 AGC WDS)		0		4		ECADR
#	6DNADR		DSPTAB			(12 AGC WDS)		0		5		ECADR
#	DNCHAN		30			CHANNELS		0		7		CHANNEL
#													ADDRESS
#	DNPTR		NEXTLIST		POINTS TO NEXT		0		6		ADRES
#						LIST.
#
# DOWNLIST FORMAT DEFINITIONS AND RULES -
# 1. END OF A LIST = -XDNADR (X = 1 TO 6), -DNPTR, OR -DNCHAN.
# 2. SNAPSHOT SUBLIST = LIST WHICH STARTS WITH A -1DNADR.
# 3. SNAPSHOT SUBLIST CAN ONLY CONTAIN 1DNADRS.
# 4. TIME2 1DNADR MUST BE LOCATED IN THE CONTROL LIST OF A DOWNLIST.
# 5. ERASABLE DOWN TELEMETRY WORDS SHOULD BE GROUPED IN SEQUENTIAL
#    LOCATIONS AS MUCH AS POSSIBLE TO SAVE STORAGE USED BY DOWNLINK LISTS.
# 6. THE DOWNLINK LISTS (INCLUDING SUBLISTS) ARE ORGANIZED SUCH THAT THE ITEMS LISTED FIRST (IN FRONT OF FBANK) ARE
#    SENT FIRST. EXCEPTION--- SNAPSHOT SUBLISTS. IN THE SNAPSHOT SUBLISTS THE DATA REPRESENTED BY THE FIRST
#    11 1DNADRS IS PRESERVED (IN ORDER) IN DNTMBUFF AND SENT BY THE NEXT 11 DOWNRUPTS.  THE DATA REPRESENTED BY THE
#    LIST IS SENT IMMEDIATELY.

		COUNT*	$$/DLIST
ERASZERO	EQUALS	7
SPARE		EQUALS	ERASZERO			# USE SPARE TO INDICATE AVAILABLE SPACE
LOWIDCOD	OCT	77340				# LOW ID CODE

NOMDNLST	EQUALS	CMCSTADL			# FRESH START AND POST P27 DOWNLIST
UPDNLIST	EQUALS	CMENTRDL			# UPDATE PROGRAM (P27) DOWNLIST


# CSM POWERED FLIGHT DOWNLIST

# --------------------------CONTROL LIST----------------------------------

CMPOWEDL	EQUALS
		DNPTR	CMPOWE01			# COLLECT SNAPSHOT
		6DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	CMPOWE02			# COLLECT SECOND SNAPSHOT
		4DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	CMPOWE03			# COMMON DATA
		1DNADR	TIG				# TIG,+1
		1DNADR	DELLT4				# DELLT4,+1
		3DNADR	RTARG				# RTARG,+1,+2,...+5
		1DNADR	TGO				# TGO,+1
		1DNADR	PIPTIME1			# PIPTIME1,+1
		3DNADR	DELV				# DELV,+1,...+4,+5
		1DNADR	PACTOFF				# PACTOFF,YACTOFF
		1DNADR	PCMD				# PCMD,YCMD
		1DNADR	CSTEER				# CSTEER,GARBAGE
		3DNADR	DELVEET1			# CSI DELTA VELOCITY COMPONENTS   (31-33)
		6DNADR	REFSMMAT			# REFSMMAT,+1,...+10,+11
		DNPTR	CMPOWE04			# COMMON DATA
		1DNADR	TIME2				# TIME2,TIME1
		DNPTR	CMPOWE05			# COLLECT SNAPSHOT
		6DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	CMPOWE02			# COLLECT SNAPSHOT
		4DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	CMPOWE03			# COMMON DATA
		DNPTR	CMPOWE08			# COMMON DATA
		1DNADR	ELEV				# ELEV,+1
		1DNADR	CENTANG				# CENTANG,+1
		1DNADR	SPARE
		1DNADR	STATE	+10D			# FALGWRDS 10 AND 11
		1DNADR	TEVENT				# TEVENT,+1
		1DNADR	PCMD				# PCMD,YCMD
		1DNADR	OPTMODES			# OPTMODES,HOLDFLAG
		DNPTR	CMPOWE07			# COMMON DATA
		3DNADR	VGTIG				# VGTIG,+1,...+4,+5
		-3DNADR DELVEET2			# CDH DELTA VELOCITY COMPONENTS   (98-100)

# ---------------------------SUB LISTS------------------------------------

CMPOWE01	-1DNADR	RN	+2			# RN+2,+3			SNAPSHOT DATA
		1DNADR	RN	+4			# RN+4,+5
		1DNADR	VN				# VN,+1
		1DNADR	VN	+2			# VN+2,+3
		1DNADR	VN	+4			# VN+4,+5
		1DNADR	PIPTIME				# PIPTIME,+1
		-1DNADR	RN				# RN,+1

CMPOWE02	-1DNADR	CDUZ				# CDUZ,CDUT			SNAPSHOT DATA
		1DNADR	ADOT				# ADOT,+1/OGARATE,+1
		1DNADR	ADOT	+2			# ADOT+2,+3/OMEGAB+2,+3
		1DNADR	ADOT	+4			# ADOT+4,+5/OMEGAB+4,+5
		-1DNADR	CDUX				# CDUX,CDUY

CMPOWE03	2DNADR	AK				# AK,AK1,AK2,RCSFLAGS		COMMON DATA
		-2DNADR	THETADX				# THETADX,THETADY,THETADZ,GARBAGE

CMPOWE04	5DNADR	STATE				# FLAGWRD0 THRU FLAGWRD9	COMMON DATA
		-6DNADR	DSPTAB				# DISPLAY TABLES

CMPOWE05	-1DNADR	R-OTHER	+2			# R-OTHER+2,+3			SNAPSHOT DATA
		1DNADR	R-OTHER	+4			# R-OTHER+4,+5
		1DNADR	V-OTHER				# V-OTHER,+1
		1DNADR	V-OTHER	+2			# V-OTHER+2,+3
		1DNADR	V-OTHER	+4			# V-OTHER+4,+5
		1DNADR	T-OTHER				# T-OTHER,+1
		-1DNADR	R-OTHER				# R-OTHER,+1

CMPOWE06	1DNADR	OPTION1				# OPTION1,2			COMMON DATA
		1DNADR	TET				# TET,+1
		2DNADR	THETADX				# THETADX,THETADY,THETEDZ,GARBAGE
CMPOWE08	1DNADR	RSBBQ				# RSBBQ,+1
		DNCHAN	76				# CHANNELS 76(GARBAGE),77
		2DNADR	C31FLWRD			# C31FLWRD,FAILREG,+1,+2
		-2DNADR	CDUS				# CDUS,PIPAX,PIPAY,PIPAZ

CMPOWE07	1DNADR	LEMMASS				# LEMMASS,CSMMASS		COMMON DATA
		1DNADR	DAPDATR1			# DAPDATR1,DAPDATR2
		2DNADR	ERRORX				# ERRORX,ERRORY,ERRORZ,GARBAGE
		3DNADR	WBODY				# WBODY,...+5/OMEGAC,...+5
		2DNADR	REDOCTR				# REDOCTR,THETAD,+1,+2
		1DNADR	IMODES30			# IMODES30,IMODES33
CMPOWE09	DNCHAN	11				# CHANNELS 11,12
		DNCHAN	13				# CHANNELS 13,14
		DNCHAN	30				# CHANNELS 30,31
		-DNCHAN	32				# CHANNELS 32,33

# ------------------------------------------------------------------------
# *** THE FOLLOWING IS A LIST OF LOCATIONS IN DOWNLINK LISTS
# *** BUT NOT REFERENCED IN THE DIRECTORY BECAUSE THEY ARE NOT
# *** THE FIRST LOCATION REFERENCED IN AN INSTRUCTION
# *** THIS LIST SHOULD BE UPDATED WHEN ANY CHANGES ARE MADE TO LISTS.
#
#			LOCATION			  LIST NAME
#
DL101		=	YACTOFF				# CMPOWEDL
DL102		=	YCMD
DL103		=	TIME1
DL104		=	YCMD
DL105		=	HOLDFLAG
DL1055		=	VMAGI
DL1056		=	VGTLI
DL106		=	CDUT				# CMPOWE02
DL107		=	OGARATE
DL108		=	OMEGAB
DL109		=	CDUY
DL110		=	AK1				# CMPOWE03
DL111		=	AK2
DL112		=	RCSFLAGS
DL113		=	THETADY
DL114		=	THETADZ
DL115		=	OPTION2				# CMPOWE06
DL116		=	THETADY
DL117		=	THETADZ
DL118		=	FAILREG				# CMPOWE08
DL119		=	PIPAX
DL120		=	PIPAY
DL121		=	PIPAZ
DL122		=	CSMMASS				# CMPOWE07
DL123		=	DAPDATR2
DL124		=	ERRORY
DL125		=	ERRORZ
DL126		=	OMEGAC
DL127		=	THETAD
DL128		=	IMODES33


# CSM COAST AND ALIGNMENT DOWNLIST

# ------------------------------CONTROL LIST------------------------------

CMCSTADL	EQUALS					# SEND ID BY SPECIAL CODING
		DNPTR	CMCSTA01			# COLLECT SNAPSHOT
		6DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	CMCSTA02			# COLLECT SECOND SNAPSHOT
		4DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	CMCSTA03			# COMMON DATA
		1DNADR	TIG				# TIG,+1
		1DNADR	BESTI				# BESTI,BESTJ
		4DNADR	MARKDOWN			# MARKDOWN,+1...+5,+6,GARBAGE
		4DNADR	MARK2DWN			# MARK2DWN,+1...+5,+6
		2DNADR	HAPOX				# HAPOX,+1,HPERX,+1
		1DNADR	PACTOFF				# PACTOFF, YACTOFF                 (30)
		3DNADR	VGTIG				# VGTIG,...+5
		6DNADR	REFSMMAT			# REFSMMAT,+1,...+10,+11
		DNPTR	CMCSTA04			# COMMON DATA
		1DNADR	TIME2				# TIME2,TIME1
		DNPTR	CMCSTA05			# COLLECT SNAPSHOT
		6DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	CMCSTA02			# COLLECT SNAPSHOT
		4DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	CMCSTA06			# COMMON DATA
		3DNADR	OGC				# OGC,+1,IGC,+1,MGC,+1
		1DNADR	STATE	+10D			# FALGWRDS 10 AND 11
		1DNADR	TEVENT				# TEVENT,+1
		1DNADR	LAUNCHAZ			# LAUNCHAZ,+1
		1DNADR	OPTMODES			# OPTMODES,HOLDFLAG
		DNPTR	CMCSTA07			# COMMON DATA
		-6DNADR	DSPTAB				# DISPLAY TABLES

# --------------------------SUB LISTS-------------------------------------

CMCSTA01	EQUALS	CMPOWE01			# COMMON DOWNLIST DATA

CMCSTA02	EQUALS	CMPOWE02			# COMMON DOWNLIST DATA

CMCSTA03	EQUALS	CMPOWE03			# COMMON DOWNLIST DATA

CMCSTA04	EQUALS	CMPOWE04			# COMMON DOWNLIST DATA

CMCSTA05	EQUALS	CMPOWE05			# COMMON DOWNLIST DATA

CMCSTA06	EQUALS	CMPOWE06			# COMMON DOWNLIST DATA

CMCSTA07	EQUALS	CMPOWE07			# COMMON DOWNLIST DATA

# ------------------------------------------------------------------------
# *** UNREFERENCED LOCATIONS USED IN LIST 2
# *** UPDATE THIS LIST WHEN ANY CHANGES ARE MADE TO DOWNLINK LISTS
#
#			LOCATION			  LIST NAME
#
DL201		=	BESTJ				# CSMSTADL
DL202		=	HPERX
DL203		=	YACTOFF
DL204		=	TIME1
DL205		=	IGC
DL206		=	MGC


# CSM RENDEZVOUS AND PRETHRUST LIST

# ----------------------------CONTROL LIST--------------------------------

CMRENDDL	EQUALS					# SEND ID BY SPECIAL CODING
		DNPTR	CMREND01			# COLLECT SNAPSHOT
		6DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	CMREND02			# COLLECT SECOND SNAPSHOT
		4DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	CMREND03			# COMMON DATA
		1DNADR	TIG				# TIG,+1
		1DNADR	DELLT4				# DELLT4,+1
		3DNADR	RTARG				# RTARG,+1...+4,+5
		1DNADR	VHFTIME				# VHFTIME,+1
		4DNADR	MARKDOWN			# MARKDOWN,+1...+5,+6,RM
		1DNADR	VHFCNT				# VHFCNT,TRKMKCNT
		1DNADR	TTPI				# TTPI,+1
		1DNADR	ECSTEER				# ECSTEER,GARBAGE
		1DNADR	DELVTPF				# DELVTPF,+1
		2DNADR	TCDH				# CDH AND CSI TIME                      (32-33)
		1DNADR	TPASS4				# TPASS4,+1
		3DNADR	DELVSLV				# DELVSLV,+1...+4,+5
		2DNADR	RANGE				# RANGE,+1,RRATE,+1
		DNPTR	CMREND04			# COMMON DATA
		1DNADR	TIME2				# TIME2,TIME1
		DNPTR	CMREND05			# COLLECT SNAPSHOT
		6DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	CMREND02			# COLLECT SNAPSHOT
		4DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	CMREND06			# COMMON DATA
		1DNADR	DIFFALT				# CDH DELTA ALTITUDE                    (74)
		1DNADR	CENTANG				# CENTANG,+1
		1DNADR	SPARE
		3DNADR	DELVEET3			# DELVEET3,+1,...+4,+5
		1DNADR	OPTMODES			# OPTMODES,HOLDFLAG
		DNPTR	CMREND07			# COMMON DATA
		1DNADR	RTHETA				# RTHETA,+1
		2DNADR	LAT(SPL)			# LAT(SPL),LNG(SPL),+1
		2DNADR	VPRED				# VPRED,+1,GAMMAEI,+1
		-1DNADR	STATE	+10D			# FALGWRDS 10 AND 11

# ----------------------------SUB LISTS-----------------------------------

CMREND01	EQUALS	CMPOWE01			# COMMON DOWNLIST DATA

CMREND02	EQUALS	CMPOWE02			# COMMON DOWNLIST DATA

CMREND03	EQUALS	CMPOWE03			# COMMON DOWNLIST DATA

CMREND04	EQUALS	CMPOWE04			# COMMON DOWNLIST DATA
CMREND05	EQUALS	CMPOWE05			# COMMON DOWNLIST DATA

CMREND06	EQUALS	CMPOWE06			# COMMON DOWNLIST DATA

CMREND07	EQUALS	CMPOWE07			# COMMON DOWNLIST DATA

# ------------------------------------------------------------------------
# *** UNREFERENCED LOCATIONS USED IN LIST 3
# *** UPDATE THIS LIST WHEN ANY CHANGES ARE MADE TO DOWNLINK LISTS
#
#			LOCATION			  LIST NAME
#
DL301		=	RM				# CMRENDDL
DL3015		=	TRKMKCNT
DL302		=	TCSI
DL303		=	RRATE
DL304		=	TIME1
DL305		=	LNG(SPL)
DL306		=	GAMMAEI


# CSM ENTRY AND UPDATE DOWNLIST

# ---------------------------CONTROL LIST---------------------------------

CMENTRDL	EQUALS					# SEND ID BY SPECIAL CODING
		DNPTR	CMENTR01			# COLLECT SNAPSHOT
		6DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	CMENTR02			# COLLECT SECOND SNAPSHOT
		4DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	CMENTR03			# COMMON DATA
		2DNADR	CMDAPMOD			# CMDAPMOD,PREL,QREL,RREL
		1DNADR	L/D1				# L/D1,+1
		6DNADR	UPBUFF				# UPBUFF,+1...+10,+11
		4DNADR	UPBUFF	+12D			# UPBUFF+12,13...+18,19D
		2DNADR	COMPNUMB			# COMPNUMB,UPOLDMOD,UPVERB,UPCOUNT
		1DNADR	PAXERR1				# PAXERR1,ROLLTM
		3DNADR	LATANG				# LATANG,+1,RDOT,+1,THETAH,+1
		2DNADR	LAT(SPL)			# LAT(SPL),+1,LNG(SPL),+1
		1DNADR	ALFA/180			# ALFA/180,BETA/180
		DNPTR	CMENTR04			# COMMON DATA
		1DNADR	TIME2				# TIME2,TIME1
		DNPTR	CMENTR05			# COLLECT SNAPSHOT
		6DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	CMENTR02			# COLLECT SNAPSHOT
		4DNADR	DNTMBUFF			# SEND SNAPSHOT
		1DNADR	OPTION1				# OPTION1,OPTION2
		1DNADR	TET				# TET,+1
		3DNADR	ERRORX				# ERRORX/Y/Z,THETADX/Y/Z
		2DNADR	CMDAPMOD			# CMDAPMOD,PREL,QREL,RREL
		6DNADR	UPBUFF				# UPBUFF+0,+1...+10,+11D
		4DNADR	UPBUFF	+12D			# UPBUFF+12,+13...+18,+19D
		1DNADR	LEMMASS				# LEMMASS,CSMMASS
		1DNADR	DAPDATR1			# DAPDATR1,DAPDATR2
		1DNADR	ROLLTM				# ROLLTM,ROLLC
		1DNADR	OPTMODES			# OPTMODES,HOLDFLAG
		3DNADR	WBODY				# WBODY,...+5/OMEGAC,...+5
		2DNADR	REDOCTR				# REDOCTR,THETAD+0,+1,+2
		1DNADR	IMODES30			# IMODES30,IMODES33
		DNPTR	CMENTR09			# COMMON DATA
		1DNADR	RSBBQ				# RSBBQ,+1
		DNCHAN	76				# CHANNELS 76(GARBAGE),77
		2DNADR	C31FLWRD			# C31FLWRD,FAILREG,+1,+2
		1DNADR	STATE	+10D			# FALGWRDS 10 AND 11
		-1DNADR	GAMMAEI				# GAMMAEI,+1

# ----------------------------SUB LISTS-----------------------------------

CMENTR01	EQUALS	CMPOWE01			# COMMON DOWNLIST DATA

CMENTR02	EQUALS	CMPOWE02			# COMMON DOWNLIST DATA

CMENTR03	EQUALS	CMPOWE03			# COMMON DOWNLIST DATA

CMENTR04	EQUALS	CMPOWE04			# COMMON DOWNLIST DATA

CMENTR05	-1DNADR	DELV				# DELV,+1			SNAPSHOT DATA
		1DNADR	DELV	+2			# DELV+2,+3
		1DNADR	DELV	+4			# DELV+4,+5
		1DNADR	TTE				# TTE,+1
		1DNADR	VIO				# VIO,+1
		1DNADR	VPRED				# VPRED,+1
		-1DNADR	PIPTIME1			# PIPTIME1,+1

CMENTR07	EQUALS	CMPOWE07			# COMMON DOWNLIST DATA

CMENTR09	EQUALS	CMPOWE09			# COMMON DOWNLIST DATA

# ------------------------------------------------------------------------
# *** UNREFERENCED LOCATIONS USED IN LIST 4
# *** UPDATE THIS LIST WHEN ANY CHANGES ARE MADE TO DOWNLINK LISTS
#
#			LOCATION			  LIST NAME
#
DL401		=	PREL				# CMENTRDL
DL402		=	QREL
DL403		=	RREL
DL404		=	UPOLDMOD
DL405		=	UPVERB
DL406		=	UPCOUNT
DL407		=	ROLLTM
DL408		=	RDOT
DL409		=	THETAH
DL410		=	LNG(SPL)
DL411		=	BETA/180
DL412		=	TIME1
DL413		=	OPTION2
DL414		=	ERRORY
DL415		=	ERRORZ
DL416		=	THETADX
DL417		=	THETADY
DL418		=	THETADZ
DL419		=	PREL
DL420		=	QREL
DL421		=	RREL
DL422		=	CSMMASS
DL423		=	DAPDATR2
DL424		=	ROLLC
DL425		=	HOLDFLAG
DL426		=	FAILREG


# P22 DOWNLISTS

# ----------------------------CONTROL LIST--------------------------------

CMPG22DL	EQUALS					# SEND ID BY SPECIAL CODING
		DNPTR	CMPG2201			# COLLECT SNAPSHOT
		6DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	CMPG2202			# COLLECT SNAPSHOT
		4DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	CMPG2203			# COMMON DATA
		DNPTR	MARK1/2				# MARK 1&2 DATA SNAPSHOT
		6DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	MARK3/4				# MARK 3&4 DATA SNAPSHOT
		6DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	MARK5				# MARK5 DATA SNAPSHOT
		3DNADR	DNTMBUFF			# SEND SNAPSHOT
		1DNADR	LANDMARK			# LANDMARK,GARBAGE
		1DNADR	SPARE
		1DNADR	SPARE
		1DNADR	SPARE
		DNPTR	CMPG2204			# COMMON DATA
		1DNADR	TIME2				# TIME2,TIME1
		DNPTR	CMPG2205			# COLLECT SNAPSHOT
		2DNADR	DNTMBUFF			# SEND SNAPSHOT
		1DNADR	SPARE
		1DNADR	SPARE
		1DNADR	SPARE
		1DNADR	SPARE
		DNPTR	CMPG2202			# COLLECT SNAPSHOT
		4DNADR	DNTMBUFF			# SEND SNAPSHOT
		DNPTR	CMPG2206			# COMMON DATA
		1DNADR	8NN				# 8NN,GARBAGE
		1DNADR	STATE	+10D			# FALGWRDS 10 AND 11
		3DNADR	SPARE				## FIXME
		1DNADR	SPARE
		1DNADR	OPTMODES			# OPTMODES,HOLDFLAG
		DNPTR	CMPG2207			# COMMON DATA
		1DNADR	SPARE
		1DNADR	SPARE
		1DNADR	SPARE
		1DNADR	SPARE
		1DNADR	SPARE
		-1DNADR	SPARE

# -----------------------------SUB LISTS----------------------------------

CMPG2201	EQUALS	CMPOWE01			# COMMON DOWNLIST DATA

CMPG2202	EQUALS	CMPOWE02			# COMMON DOWNLIST DATA

CMPG2203	EQUALS	CMPOWE03			# COMMON DOWNLIST DATA

CMPG2204	EQUALS	CMPOWE04			# COMMON DOWNLIST DATA

CMPG2205	-1DNADR	LONG				# LONG,+1			SNAPSHOT DATA
		1DNADR	ALT				# ALT,+1
		-1DNADR	LAT				# LAT,+1

CMPG2206	EQUALS	CMPOWE06			# COMMON DOWNLIST DATA

CMPG2207	EQUALS	CMPOWE07			# COMMON DOWNLIST DATA

MARK1/2		-1DNADR	SVMRKDAT +2			# SVMRKDAT+2,+3			SNAPSHOT DATA
		1DNADR	SVMRKDAT +4			# SVMRKDAT+4,+5
		1DNADR	SVMRKDAT +6			# SVMRKDAT+6,+7
		1DNADR	SVMRKDAT +8D			# SVMRKDAT+8,+9
		1DNADR	SVMRKDAT +10D			# SVMRKDAT+10,+11
		1DNADR	SVMRKDAT +12D			# SVMRKDAT+12,+13
		-1DNADR	SVMRKDAT			# SVMRKDAT,+1

MARK3/4		-1DNADR	SVMRKDAT +16D			# SVMRKDAT+16,+17		SNAPSHOT DATA
		1DNADR	SVMRKDAT +18D			# SVMRKDAT+18,+19
		1DNADR	SVMRKDAT +20D			# SVMRKDAT+20,+21
		1DNADR	SVMRKDAT +22D			# SVMRKDAT+22,+23
		1DNADR	SVMRKDAT +24D			# SVMRKDAT+24,+25
		1DNADR	SVMRKDAT +26D			# SVMRKDAT+26,+27
		-1DNADR	SVMRKDAT +14D			# SVMRKDAT+14,+15

MARK5		-1DNADR	SVMRKDAT +30D			# SVMRKDAT+30,+31			SNAPSHOT DATA
		1DNADR	SVMRKDAT +32D			# SVMRKDAT+32,+33
		1DNADR	SVMRKDAT +34D			# SVMRKDAT+34,GARBAGE
		-1DNADR	SVMRKDAT +28D			# SVMRKDAT+28,+29

# ------------------------------------------------------------------------
# *** UNREFERENCED LOCATIONS USED IN LIST 5
# *** UPDATE THIS LIST WHEN ANY CHANGES ARE MADE TO DOWNLINK LISTS
#
#			LOCATION			  LIST NAME
#
DL501		=	TIME1				# CMPG22DL

# ------------------------------------------------------------------------

DNTABLE		GENADR	CMCSTADL
		GENADR	CMENTRDL
		GENADR	CMRENDDL
		GENADR	CMPOWEDL
		GENADR	CMPG22DL

# ------------------------------------------------------------------------
