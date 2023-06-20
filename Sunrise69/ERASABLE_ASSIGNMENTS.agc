### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	ERASABLE_ASSIGNMENTS.agc
## Purpose:	A section of Sunrise 45.
##		It is part of the reconstructed source code for the penultimate
##		release of the Block I Command Module system test software. No
##		original listings of this program are available; instead, this
##		file was created via disassembly of dumps of Sunrise core rope
##		memory modules and comparison with the later Block I program
##		Solarium 55.
## Assembler:	yaYUL --block1
## Contact:	Ron Burkey <info@sandroid.org>.
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2022-12-09 MAS	Initial reconstructed source.
##		2023-06-03 MAS	Deleted BETAVTAB; renamed TESTVADR to PBODY
##				and ACCIDX to GMODE.


# COUNTER AND SPECIAL REGISTER TAGS
# ------- --- ------- -------- ----

A		EQUALS	0
Q		EQUALS	1
Z		EQUALS	2
LP		EQUALS	3
IN0		EQUALS	4
IN1		EQUALS	5
IN2		EQUALS	6
IN3		EQUALS	7
OUT0		EQUALS	10
OUT1		EQUALS	11
OUT2		EQUALS	12
OUT4		EQUALS	14
BANKREG		EQUALS	15
RELINT		EQUALS	16
INHINT		EQUALS	17
CYR		EQUALS	20
SR		EQUALS	21
CYL		EQUALS	22
SL		EQUALS	23
ZRUPT		EQUALS	24
BRUPT		EQUALS	25
ARUPT		EQUALS	26
QRUPT		EQUALS	27

OVCTR		EQUALS	34
TIME2		EQUALS	35
TIME1		EQUALS	36
TIME3		EQUALS	37
TIME4		EQUALS	40
UPLINK		EQUALS	41
OUTCR1		EQUALS	42
OUTCR2		EQUALS	43
PIPAX		EQUALS	44
PIPAY		EQUALS	45
PIPAZ		EQUALS	46
CDUX		EQUALS	47
CDUY		EQUALS	50
CDUZ		EQUALS	51
OPTX		EQUALS	52
OPTY		EQUALS	53

#          INTERPRETIVE SPECIAL REGISTERS CONTAINED IN THE WORK AREA.

VAC		EQUALS	32D		# RELATIVE TO FIXLOC
VACX		EQUALS	VAC
VACY		EQUALS	VAC + 2
VACZ		EQUALS	VAC + 4
X1		EQUALS	38D		# INDEXES ARE RELATIVE TO FIXLOC
X2		EQUALS	39D
S1		EQUALS	40D		# AND SO ARE STEP REGISTERS
S2		EQUALS	41D
QPRET		EQUALS	42D		# AS IS QPRET

		SETLOC	60

#	   THE FOLLOWING REGISTERS ARE USED BY THE INTERPRETER, AND MAY BE USED BY A BASIC JOB OR BASIC
# PORTIONS OF AN INTERPRETIVE JOB (SOME RESTRICTIONS APPEAR WITH RTB FOLLOWED BY TC DANZIG, BUT THE NINE REGISTERS
# VBUF AND BUF ARE AVAILABLE THEN). THE REGISTERS ARE NOT SAVED IN THEIR ENTIRETY DURING CHANGE JOB (MOST OF THEM
# ARE IGNORED), SO THAT THESE MUST BE USED ONLY AS TEMPORARIES BETWEEN ANY CCS NEWJOBS.

BANKSET		ERASE			# STORAGE FOR BANK BITS OF OBJECT PROGRAM
ADDRWD		ERASE			# THIS WILL CONTAIN A PROPER 12 BIT ADDR
ORDER		ERASE			# STORAGE FOR RIGHT-HAND OPERATORS
UPDATRET	=	ORDER		# RETURN FOR UPDATNN, UPDATVB
CHAR		=	ORDER		# TEMP FOR CHARIN
ERCNT		=	ORDER		# COUNTER FOR ERROR LIGHT RESET
DECOUNT		=	ORDER		# COUNTER FOR SCALING AND DISPLAY (DEC)
TEM11		ERASE
SGNON		=	TEM11		# TEMP FOR +,- ON
NOUNTEM		=	TEM11		# COUNTER FOR MIXNOUN FETCH
DISTEM		=	TEM11		# COUNTER FOR OCTAL DISPLAY VERBS
DECTEM		=	TEM11		# COUNTER FOR FETCH (DEC DISPLAY VERBS)
DECTEM1		=	TEM11		# TEMP FOR NUM
MODE		ERASE			# DENOTES VECTOR, DP, OR TP.
ENTRET		=	MODE		# EXIT FROM ENTER
LOADIND		ERASE			# LOAD INDICATOR
NEWEQIND	EQUALS	LOADIND
MONTEM		=	NEWEQIND	# TEMP RETURN FOR MONITOR
FIXLOC		ERASE			# ADDRESS OF CURRENT VAC AREA
VACLOC		ERASE			# ADDRESS OF CURRENT VAC (= FIXLOC+32D)
VBUF		ERASE	+5		# 6 WORD TEMPORARY BLOCK FOR VXV, MXV, ETC
TEMQS		EQUALS	VBUF		# TEMP STORAGE FOR SWCALL ROUTINE
BANKTEM		EQUALS	VBUF +1		# LIKEWISE
B		EQUALS	VBUF +2		# ARGUMENT STORAGE IN FUNCTIONS
PROGREG		=	VBUF +2		# FOR GO EXEC PROGRAM
MIXTEMP		=	VBUF +2		# FOR MIXNOUN DATA
SIGNRET		=	VBUF +2		# RETURN FOR +,- ON
# ALSO PROGREG+1, PROGREG+2.  MIXTEMP+1, MIXTEMP+2.
ESCAPE2		EQUALS	VBUF +4		# NEGATIVE ARGUMENT SWITCH IN ARCCOS
TAG1		EQUALS	VBUF +4		# USED FOR PICKING UP INDEX AND STEP REGS
TEMQ3		EQUALS	VBUF +5		# RETURN FROM DDV AND SQRTDIV
POLISH		EQUALS	VBUF +5		# TEMPORARY STORAGE FOR COMPLETE ADDRESSES
WDCNT		=	VBUF +5		# CHAR COUNTER FOR DSPWD
INREL		=	VBUF +5		# INPUT BUFFER SELECTOR ( X,Y,Z, REG )
BUF		ERASE	+2		# USED BY DMP1, SQRTDIV
LOGTEM		EQUALS	BUF		# LOG SUBROUTINE TEMP.
SGNDMAX		EQUALS	BUF +2		# USED IN TPAGREE
TEM3		EQUALS	BUF +2
GCOMPSW		EQUALS	BUF +2
TEM2		ERASE
DSREL		=	TEM2		# REL ADDRESS FOR DSPIN(TEM2 USED BY DAD1)
TEM4		ERASE
TEMQ		EQUALS	TEM4		# RETURN FROM TPAGREE
DSMAG		=	TEM4		# MAGNITUDE STORE FOR DSPIN
IDADDTEM	=	TEM4		# MIXNOUN INDIRECT ADDRESS STORAGE
TEM5		ERASE
TEMQ2		EQUALS	TEM5
BASE		=	TEM5
COUNT		=	TEM5		# FOR DSPIN  (TEM5 IS USED BY DAD)
TEM8		ERASE
TEM6		EQUALS	TEM8		# ERASABLE ASSIGNMENTS BY EQUALS
TEM9		ERASE
WRDRET		=	TEM9		# RETURN FOR 5BLANK
WDRET		=	TEM9		# RETURN FOR DSPWD
DECRET		=	TEM9		# RETURN FOR PUTCOM(DEC LOAD)
21/22REG	=	TEM9		# TEMP FOR CHARIN
TEM10		ERASE
IND		EQUALS	TEM10		# USED IN CROSS ROUTINE
MIXBR		=	TEM10		# INDICATOR FOR MIXED OR NORMAL NOUN
DSPMMTEM	=	TEM10		# DSPCOUNT SAVE FOR DSPMM
DVSW		ERASE			# (THIS CAN PROBABLY BE EQUATED)
SGNOFF		=	DVSW		# TEMP FOR +,- ON
NVTEMP		=	DVSW		# TEMP FOR NVSUB
SFTEMP1		=	DVSW		# STORAGE FOR SF CONST HI PART(=SFTEMP2-1)
DECTEM2		=	DVSW		# TEMP FOR NUM
BRANCHQ		ERASE			# (DITTO)
CODE		=	BRANCHQ		# FOR DSPIN
SFTEMP2		=	BRANCHQ		# STORAGE FOR SF CONST LO PART(=SFTEMP1+1)
COMPON		ERASE			# (DITTO)
DSEXIT		=	COMPON		# RETURN FOR DSPIN
EXITEM		=	COMPON		# RETURN FOR SCALE FACTOR ROUTINE SELECT
BLANKRET	=	COMPON		# RETURN FOR 2BLANK
ARETURN		ERASE			# RETURN ADDRESS FOR ARCSIN/ARCCOS.
LSTPTR		=	ARETURN		# LIST POINTER FOR GRABUSY
RELRET		=	ARETURN		# RETURN FOR RELDSP
FREERET		=	ARETURN		# RETURN FOR FREEDSP

ESCAPE		ERASE			# ARCSIN/ARCCOS SWITCH
CADRTEM		=	ESCAPE		# TEMP STORAGE FOR GRAB ROUTINES

#	THE FOLLOWING REGISTERS ARE USED EXCLUSIVELY BY THE EXECUTIVE.
MPAC		ERASE	+2		# MULTIPLE-PRECISION ACCUMULATOR
LOC		ERASE			# LOCATION COUNTER FOR OPERATOR WORDS
ADRLOC		ERASE			# LOCATION COUNTER FOR OPERAND ADDRESSES
OVFIND		ERASE			# 0 FOR NO OVERFLOW, NON-ZERO OTHERWISE
PUSHLOC		ERASE			# NEXT AVAILABLE ENTRY IN PUSH-DOWN LIST
PRIORITY	ERASE			# PRIORITY OF CURRENT JOB

		ERASE	+55D		# EIGHT JOBS POSSIBLE

VAC1USE		ERASE			# SEE EXECUTIVE PROGRAMS FOR USE OF THESE
VAC1		ERASE	+42D		# REGISTERS
VAC2USE		ERASE
VAC2		ERASE	+42D
VAC3USE		ERASE
VAC3		ERASE	+42D
VAC4USE		ERASE
VAC4		ERASE	+42D
VAC5USE		ERASE
VAC5		ERASE	+42D

NEWJOB		ERASE			# SET NON-ZERO TO SIGNAL EXECUTIVE RUPT

#	THE FOLLOWING REGISTERS ARE USED EXCLUSIVELY BY THE WAITLISTER.

LST1		ERASE	+4		# DELTA T'S.
LST2		ERASE	+5		# TASK CADRS.
RUPTAGN		ERASE			# WAITLIST ADDITIONAL TASK INDICATOR.

KEYTEMP2	=	RUPTAGN		# TEMP FOR KEYRUPT, UPRUPT

#	THE FOLLOWING GROUP OF REGISTERS MAY BE USED AS TEMPORARY STORAGE BY ANY INTERRUPT PROGRAM OR BY ANY
# PROGRAM WHICH INHIBITS INTERRUPT. CARE MUST BE TAKEN, HOWEVER, TO SEE THAT THEY ARE NOT USED DURING A CALL
# TO THE EXECUTIVE (FOR EXAMPLE), FOR THE EXECUTIVE MAY USE THEM AS TEMPORARIES TOO.

EXECTEM1	ERASE			# THESE REGISTERS, EXECTEM1-3, MAY BE USED
RUPTSTOR	=	EXECTEM1
PHASE		=	EXECTEM1
IN1HITEM	=	EXECTEM1	# INTERRUPT TEMP FOR STANDBY PREP
EXECTEM2	ERASE			# AS SCRATCH STORAGE BY ANY PROGRAM WHICH
PROG		EQUALS	EXECTEM2
IN1LOTEM	=	EXECTEM2	# INTERRUPT TEMP FOR STANDBY PREP
EXECTEM3	ERASE			# INHIBITS INTERRUPTS
ITEMP3		EQUALS	EXECTEM3
SRRUPT		EQUALS	EXECTEM3	# SHORT STORAGE FOR SR DURING INTERRUPT.
LOOKRET		=	EXECTEM3	# INTERRUPT TEMP FOR STANDBY PREP
PHASEDIG	=	EXECTEM3
EXECTEM4	ERASE
PHASELP		=	EXECTEM4
EXECTEM5	ERASE			# BANK RETURN FROM PHASE CONTROL.
NEWPRIO		ERASE			# PRIORITY OF NEW JOB
NVAL		=	NEWPRIO
DELT		=	NVAL
ITEMP1		=	NEWPRIO
PHASEWD		=	NEWPRIO	
WTEXIT		ERASE
ITEMP2		=	WTEXIT
KEYTEMP1	=	WTEXIT		# TEMP FOR KEYRUPT, UPRUPT
DSRUPTEM	=	WTEXIT		# TEMP FOR DSPOUT
LOCCTR		ERASE			# USED TO LOCATE STORAGE FOR CORE REGISTRS
PHASDATA	EQUALS	LOCCTR

BANKRUPT	ERASE
OVRUPT		ERASE
LPRUPT		ERASE

# LONG-TERM STORAGE USED DURING INTERUPT, NOT USED BY EXECUTIVE, WAITLIST, ETC.
 
RUPTREG1	ERASE
KSAMPTEM	EQUALS	RUPTREG1
RUPTREG2	ERASE
OSAMPTEM	EQUALS	RUPTREG2
RUPTREG3	ERASE
RUPTREG4	ERASE

# ERASABLE ASSIGNMENTS SPECIFIC TO PINBALL

		SETLOC	612
VERBREG		ERASE			# VERB CODE
NOUNREG		ERASE			# NOUN CODE
XREG		ERASE			# R1 INPUT BUFFER
YREG		ERASE			# R2 INPUT BUFFER
ZREG		ERASE			# R3 INPUT BUFFER
XREGLP		ERASE			# LO PART OF XREG (FOR DEC CONV ONLY)
YREGLP		ERASE			# LO PART OF YREG (FOR DEC CONV ONLY)
ZREGLP		ERASE			# LO PART OF ZREG (FOR DEC CONV ONLY)
MODREG		ERASE			# MODE CODE
DSPLOCK		ERASE			# KEYBOARD/SUBROUTINE CALL INTERLOCK
REQRET		ERASE			# RETURN REGISTER FOR LOAD
DSPCOUNT	ERASE			# DISPLAY POSITION INDICATOR
DECBRNCH	ERASE			# +DEC, - DEC, OCT INDICATOR
DSPTEM1		ERASE	+2		# BUFFER STORAGE AREA 1 (MOSTLY FOR TIME)
DSPTEM2		ERASE	+2		# BUFFER STORAGE AREA 2 (MOSTLY FOR DEG)
NOUNADD		ERASE			# MACHINE ADDRESS FOR NOUN
MONSAVE		ERASE			# N/V CODE FOR MONITOR. ALSO ACTIVITY
MONSAVE1	ERASE			# NOUNADD STORAGE FOR MONITOR WITH MATBS
CADRSTOR	ERASE			# ENDIDLE STORAGE
GRABLOCK	ERASE			# INTERNAL INTERLOCK FOR DISPLAY SYSTEM
NVBNKTEM	ERASE			# NVSUB STORAGE FOR CALLING BANK
IN0WORD		ERASE			# INPUT CODE STORAGE (KEYRUPT OR UPRUPT)
NVQTEM		ERASE			# NVSUB STORAGE FOR CALLING Q
LOADSTAT	ERASE			# STATUS INDICATOR FOR LOADTST
CLPASS		ERASE			# PASS INDICATOR FOR CLEAR
DSPLIST		ERASE	+2		# WAITING LIST FOR DSP SYST INTERNAL USE


# 	INTERPRETER SWITCH ASSIGNMENTS.

STATE		ERASE	+2		# 45 SWITCHES USED BY INTERPRETIVE PROGS.

FLAGWRD1	EQUALS	STATE +1
FLAGWRD2	EQUALS	STATE +2

JSWITCH		EQUALS	1		# FREE-FALL INTEGRATION.
NBSMBIT		EQUALS	5		# IN-FLIGHT ALIGNMENT.

#	STORAGE USED BY PHASE CONTROL.

PHASETAB	ERASE	+3		# PHASE VALUES FOR 4 PROGRAMS
BACKPHAS	ERASE	+3
PHASEBAR	ERASE	+3		# COMPLEMENTED COPY.
PWTPROG		ERASE	+1
PWTCADR		ERASE	+1

#	THE FOLLOWING REGISTERS ARE USED BY THE DOWNRUPT PROGRAM.

TELCOUNT	ERASE			# ENDPULSE FREQUENCY MONITORING COUNTER.
DISPBUF		ERASE
DNLSTADR	ERASE
IDPLACER	ERASE
TMINDEX		ERASE
TMKEYBUF	ERASE


#	THE FOLLOWING STORAGE IS USED BY T4RUPT.

DSRUPTSW	ERASE			# T4RUPT PHASE COUNT GOES 7(-1)0
CDUIND		ERASE			# IMU CDU STATUS INDICATOR AND INDEXER.
THETAD		ERASE	+2		# SET OF THREE DEISRED ANGLES IN 2S COMPL.
PRELXGA		=	THETAD
PRELYGA		=	THETAD +1
PRELZGA		=	THETAD +2
COMMAND		ERASE	+2		# LAST COMMANDS TO CDUS.
KG		ERASE			# CDU DRIVING GAIN.
KH		ERASE			# CDU DRIVING GAIN.
GYROD		ERASE	+5		# GYRO PULSE TRAIN COMMANDS.
OPTIND		ERASE			# OPTICS CDU STATUS INDICATOR AND INDEXER.
DESOPTX		ERASE	+1		# DESIRED OPTICS CDU ANGLES.

DSPCNT		ERASE			# STEPS THROUGH K-RELAY SLOTS IN DSPTAB.
NOUT		ERASE			# HOLDS NUMBER OF RELAY WORDS TO CHANGE.
DSPTAB		ERASE	+13D		# HOLDS STATE OF ALL RELAYS AND CHANGE INF

OLDERR		ERASE			# LAST-SAMPLED SYSTEM ERROR BITS.
#	THE BITS OF OLDERR HAVE THE FOLLOWING MEANINGS:
#
# BIT  1 = 1 IF THE PILOTS ATTITUDE BUTTON IS DEPRESSED.
# BIT  2 = 1 IF RESTART FAILED (AND DID A FRESH START).
# BIT  3 = 1 IF BIT 4 OF OUT1 WAS NOT INVERTED LAST NWJOB.
# BIT  4 = 1 TO INHIBIT IMU FAIL FOR 5 SECONDS AFTER COARSE ALIGN.
# BIT  5 = 1 IF CURTAINS CALLED (IMU MODING FAILURE, ETC.)
# BIT 10 = 1 IF CDU FAIL IS ON IN FINE ALIGN.
# BIT 11 = 1 IF PIPA FAIL IS ON.
# BIT 12 = 1 IF IMU FAIL IS ON IN ANY MODE BUT COARSE ALIGN.
#
#	IN FLIGHT 501, BITS 2, 5, 11, AND 12 INHIBIT MAINTENANCE OF THE NIGHT WATCHMAN ALARM
# SO THAT IF THEY ARE PRESENT FOR 2 CONSECUTIVE NWJOBS, G & N FAIL WILL BE SENT TO THE MCP.

WASKSET		ERASE			# LAST SETTING OF IMU MODE SWITCHES.
WASOPSET	ERASE			# LAST SETTING OF OPTICS MODE SWITCHES.

DESKSET		ERASE			# DESIRED SETTING OF IMU MODE SWITCHES.
DESOPSET	ERASE			# DESIRED OPTICS MODES.

#	THE FOLLOWING REGISTERS ARE USED BY THE MODE SWITCHING AND MARK PROGRAMS.

IMUCADR		ERASE			# USED BY IMUSTALL.
MODECADR	EQUALS	IMUCADR		# FOR INDEXING PURPOSES.
OPTCADR		ERASE			# USED BY OPTSTALL.

MARKSTAT	ERASE			# MARK BUTTON STATUS REGISTER.

FAILREG		ERASE

#	THE FOLLOWING STORAGE IS TIME-SHARED BY MISSION PROGRAMS UNDER THE SUPERVISION OF MASTER COMTROL. IT IS
# ORGANIZED INTO THREE PARTS REFERRED TO AS A MEMORY, B MEMORY, AND C MEMORY. A PARTICULAR MISSION PHASE IS
# ASSIGNED TO ONE OF THE SEGMENTS IN SUCH A WAY THAT NO OTHER MISSION PHASE USING THE SAME SEGMENT WILL EVER RUN
# CONCURRENTLY; E.G., RE-ENTRY WILL NEVER RUN CONCURRENT WITH TVC. THE NUMBER OF AREAS (3) IS DETERMINED BY THE
# MAXIMUM NUMBER OF DISTINCT MISSION PROGRAMS WHICH RUN SIMULTANEOUSLY.
#
#	A MEMORY IS USED BY PRELAUNCH AND IN-FLIGHT ALIGNMENTS. B MEMORY IS USED BY MID-COURSE DURING FREE-FALL
# PORTIONS OF THE MISSION. THE C MEMORY PORTION IS USED THROUGHOUT MOST OF THE MISSION FOR THE MIDCOURSE ERROR
# TRANSITION MATRIX W. THE EXCEPTION IS SYSTEM TEST, ASSIGNED TO A MEMORY, WHICH NEVER RUNS CONCURRENTLY WITH
# MISSION PROGRAMS.

AMEMORY		ERASE	+152D
BMEMORY		ERASE	+166D
CMEMORY		ERASE	+71D


#	A MEMORY ASSIGNMENTS FOR PRE-LAUNCH ALIGNMENT.
GYROCSW		EQUALS	AMEMORY +000D
DRIFTY		EQUALS	AMEMORY +001D
DRIFTZ		EQUALS	AMEMORY +002D
DRIFTX		EQUALS	AMEMORY +003D
LATITUDE	EQUALS	AMEMORY +004D
AZIMUTH		EQUALS	AMEMORY +006D
PRELTEMP	EQUALS	AMEMORY +008D


#	THE FOLLOWING LOCATIONS ARE USED BY IN-FLIGHT ALIGNMENT:
STARAD		EQUALS	AMEMORY +009D
XNB		EQUALS	AMEMORY +009D
YNB		EQUALS	AMEMORY +015D
ZNB		EQUALS	AMEMORY +021D
STAR		EQUALS	AMEMORY +021D
XSM		EQUALS	AMEMORY +027D
YSM		EQUALS	AMEMORY +033D
ZSM		EQUALS	AMEMORY +039D
XDC		EQUALS	AMEMORY +045D
XDSMPR		EQUALS	AMEMORY +045D
YDC		EQUALS	AMEMORY +051D
YDSMPR		EQUALS	AMEMORY +051D
ZDC		EQUALS	AMEMORY +057D
ZDSMPR		EQUALS	AMEMORY +057D
OGC		EQUALS	AMEMORY +063D
SAC		EQUALS	AMEMORY +063D
IGC		EQUALS	AMEMORY +065D
PAC		EQUALS	AMEMORY +065D
MGC		EQUALS	AMEMORY +067D


#	SYSTEM TEST A MEMORY USAGE:

COUNTPL		EQUALS	AMEMORY +000D
PIPINDEX	EQUALS	AMEMORY +006D
GENPLACE	EQUALS	AMEMORY +069D
PIPANO		EQUALS	AMEMORY +149D
POSITON		EQUALS	AMEMORY +150D
RESULTCT	EQUALS	AMEMORY +151D
QPLACE		EQUALS	AMEMORY +152D


#	THE FOLLOWING B MEMORY LOCATIONS ARE USED BY MID-COURSE NAVIGATION:

FDSPWAIT	EQUALS	BMEMORY +000D
STEPEXIT	EQUALS	BMEMORY +001D
DIFEQCNT	EQUALS	BMEMORY +002D
SCALEA		EQUALS	BMEMORY +003D
SCALEB		EQUALS	BMEMORY +004D
SCALEDT		EQUALS	BMEMORY +005D
SCALDELT	EQUALS	BMEMORY +006D
SCALER		EQUALS	BMEMORY +007D
PBODY		EQUALS	BMEMORY +008D
FBRANCH		EQUALS	BMEMORY +009D
HBRANCH		EQUALS	BMEMORY +010D
FLSTPHAS	EQUALS	BMEMORY +011D
GMODE		EQUALS	BMEMORY +012D
BETAM		EQUALS	BMEMORY +013D
VECTAB		EQUALS	BMEMORY +015D
RRECT		EQUALS	BMEMORY +051D
VRECT		EQUALS	BMEMORY +057D
ALPHAM		EQUALS	BMEMORY +063D
TC		EQUALS	BMEMORY +065D
TAU		EQUALS	BMEMORY +067D
TETDISP		EQUALS	BMEMORY +069D
TET		EQUALS	BMEMORY +071D
ENDTET		EQUALS	BMEMORY +073D
DT/2		EQUALS	BMEMORY +075D
H		EQUALS	BMEMORY +077D
TDELTAV		EQUALS	BMEMORY +079D
TNUV		EQUALS	BMEMORY +085D
YV		EQUALS	BMEMORY +091D
ZV		EQUALS	BMEMORY +097D
RCV		EQUALS	BMEMORY +103D
FOUNDR		EQUALS	BMEMORY +103D
VCV		EQUALS	BMEMORY +109D
FOUNDV		EQUALS	BMEMORY +109D
ALPHAV		EQUALS	BMEMORY +115D
BETAV		EQUALS	BMEMORY +121D
PHIV		EQUALS	BMEMORY +127D
PSIV		EQUALS	BMEMORY +133D
FV		EQUALS	BMEMORY +139D
RDISP		EQUALS	BMEMORY +145D
VDISP		EQUALS	BMEMORY +151D
XKEPHI		EQUALS	BMEMORY +159D
XKEPLO		EQUALS	BMEMORY +161D
XSTOREX		EQUALS	BMEMORY +163D
ASQ		EQUALS	BMEMORY +165D


#	THE FOLLOWING IS THE MIDCOURSE 6X6 ERROR TRANSITION MATRIX:

W		EQUALS	CMEMORY +000D


#	THE FOLLOWING STORAGE IS USED BY SELF-CHECK

SMODE		ERASE
SFAIL		ERASE
SCOUNT		ERASE +1
SKEEP1		ERASE
SKEEP2		ERASE
SKEEP3		ERASE
SKEEP4		ERASE
SKEEP5		ERASE
SKEEP6		ERASE
OKREG		ERASE

# THE FOLLOWING STORAGE IS RESERVED EXCLUSIVELY FOR SELF-CHECK

SELFERAS	ERASE	1761 - 1777
S2MODE		=	1762
QADRS		=	1763
S2FAIL		=	1764
ER2COUNT	=	1765
S2COUNT		=	1766
S2KEEP1		=	1771
S2KEEP2		=	1772
S2KEEP3		=	1773
S2KEEP4		=	1774
S2KEEP5		=	1775
S2KEEP6		=	1776
S2KEEP7		EQUALS	1777
