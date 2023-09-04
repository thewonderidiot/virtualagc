### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	ASSEMBLY_AND_OPERATION_INFORMATION.agc
## Purpose:	Part of the source code for Artemis (i.e., Colossus 3),
##		build 072.  This is for the Command Module's (CM) 
##		Apollo Guidance Computer (AGC), for 
##		Apollo 15-17.
## Assembler:	yaYUL
## Contact:	Ron Burkey <info@sandroid.org>.
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2004-12-21 RSB	Created.
##		2005-05-14 RSB	Corrects website reference above.
##		2009-07-25 RSB	Fixups for this header so that it can
##				be used for code conversions.
## 		2009-09-03 JL	Adapted from corresponding Comanche 055 file.
## 		2009-09-11 JL	Whitespace fixes.
##		2010-02-20 RSB	Un-##'d this header.
##		2017-01-04 RSB	Proofed comment text using octopus/ProoferComments
##				and fixed errors found.
##		2017-01-21 RSB	Proofed comment text by diff'ing vs Comanche 55
##				and corrected errors found.


# ASSEMBLY AND OPERATIONS INFORMATION
# TAGS FOR RELATIVE SETLOC AND BLANK BANK CARDS
# ABSOLUTE LOCATIONS FOR UPDATES
# SUBROUTINE CALLS
#
#
#	ERASTOTL
#		ERASABLE ASSIGNMENTS
#		CHECK EQUALS LIST
#	DIOGENES
#		INTERRUPT LEAD INS
#		T4RUPT PROGRAM
#		DOWNLINK LISTS
#		FRESH START AND RESTART
#		RESTART TABLES
#		SXTMARK
#		EXTENDED VERBS
#		PINBALL NOUN TABLES
#		CSM GEOMETRY
#		IMU COMPENSATION PACKAGE
#		PINBALL GAME  BUTTONS AND LIGHTS
#		R60,R62
#		ANGLFIND
#		GIMBAL LOCK AVOIDANCE
#		KALCMANU STEERING
#		SYSTEM TEST STANDARD LEAD INS
#		IMU CALIBRATION AND ALIGNMENT
#	MEDUSA
#		GROUND TRACKING DETERMINATION PROGRAM - P21
#		P34-P35, P74-P75
#		R31
#		P76
#		R30
#	MENELAUS
#		P15
#		P11
#		P20-P25
#		P30,P31
#		P32-P33, P72-P73
#		P40-P47
#		P51-P53
#		LUNAR AND SOLAR EPHEMERIDES SUBROUTINES
#		P61-P67
#		SERVICER207
#		ENTRY LEXICON
#		REENTRY CONTROL
#		CM BODY ATTITUDE
#		P37, P70
#		S-BAND ANTENNA FOR CM
#	ULYSSES
#		TVCINITIALIZE
#		TVCEXECUTIVE
#		TVCMASSPROP
#		TVCRESTARTS
#		TVCDAPS
#		TVCROLLDAP
#		MYSUBS
#		RCS-CSM DIGITAL AUTOPILOT
#		AUTOMATIC MANEUVERS
#		RCS-CSM DAP EXECUTIVE PROGRAMS
#		JET SELECTION LOGIC
#		CM ENTRY DIGITAL AUTOPILOT
#	ZEUS
#		DOWN-TELEMETRY PROGRAM
#		INTER-BANK COMMUNICATION
#		INTERPRETER
#		FIXED-FIXED CONSTANT POOL
#		INTERPRETIVE CONSTANTS
#		SINGLE PRECISION SUBROUTINES
#		EXECUTIVE
#		WAITLIST
#		LATITUDE LONGITUDE SUBROUTINES
#		PLANETARY INERTIAL ORIENTATION
#		MEASUREMENT INCORPORATION
#		CONIC SUBROUTINES
#		INTEGRATION INITIALIZATION
#		ORBITAL INTEGRATION
#		INFLIGHT ALIGNMENT ROUTINES
#		POWERED FLIGHT SUBROUTINES
#		TIME OF FREE FALL
#		STAR TABLES
#		AGC BLOCK TWO SELF-CHECK
#		PHASE TABLE MAINTENANCE
#		RESTARTS ROUTINE
#		IMU MODE SWITCHING ROUTINES
#		KEYRUPT, UPRUPT
#		DISPLAY INTERFACE ROUTINES
#		SERVICE ROUTINES
#		ALARM AND ABORT
#		UPDATE PROGRAM
#		RTB OP CODES

# SYMBOL TABLE LISTING
# UNREFERENCED SYMBOL LISTING
# ERASABLE & EQUALS CROSS-REFERENCE TABLE
# SUMMARY OF SYMBOL TABLE LISTINGS
# MEMORY TYPE & AVAILABLITY DISPLAY
# COUNT TABLE
# PARAGRAPHS GENERATED FOR THIS ASSEMBLY
# OCTAL LISTING
# OCCUPIED LOCATIONS TABLE
# SUBROS CALLED & PROGRAM STATUS

# VERB LIST FOR CSM

# REGULAR VERBS

# 00 NOT IN USE
# 01 DISPLAY OCTAL COMP 1 IN R1
# 02 DISPLAY OCTAL COMP 2 IN R1
# 03 DISPLAY OCTAL COMP 3 IN R1
# 04 DISPLAY OCTAL COMP 1,2 IN R1,R2
# 05 DISPLAY OCTAL COMP 1,2,3 IN R1,R2,R3
# 06 DISPLAY DECIMAL IN R1 OR R1,R2 OR R1,R2,R3
# 07 DISPLAY DP DECIMAL IN R1,R2 (TEST ONLY)
# 08
# 09
# 10
# 11 MONITOR OCTAL COMP 1 IN R1
# 12 MONITOR OCTAL COMP 2 IN R1
# 13 MONITOR OCTAL COMP 3 IN R1
# 14 MONITOR OCTAL COMP 1,2 IN R1,R2
# 15 MONITOR OCTAL COMP 1,2,3 IN R1,R2,R3
# 16 MONITOR DECIMAL IN R1 OR R1,R2 OR R1,R2,R3
# 17 MONITOR DP DECIMAL IN R1,R2 (TEST ONLY)
# 18
# 19
# 20
# 21 LOAD COMPONENT 1 INTO R1
# 22 LOAD COMPONENT 2 INTO R2
# 23 LOAD COMPONENT 3 INTO R3
# 24 LOAD COMPONENT 1,2 INTO R1,R2
# 25 LOAD COMPONENT 1,2,3 INTO R1,R2,R3
# 26
# 27 DISPLAY FIXED MEMORY
# 28
# 29
# 30 REQUEST EXECUTIVE
# 31 REQUEST WAITLIST
# 32 RECYCLE PROGRAM
# 33 PROCEED WITHOUT DSKY INPUTS
# 34 TERMINATE FUNCTION
# 35 TEST LIGHTS
# 36 REQUEST FRESH START
# 37 CHANGE PROGRAM (MAJOR MODE)
# 38
# 39


# EXTENDED VERBS

# 40 ZERO CDU-S
# 41 COARSE ALIGN CDU-S
# 42 FINE ALIGN IMU-S
# 43 LOAD IMU ATT ERROR METERS
# 44 REQUEST DOCKED DAP DATA LOAD ROUTINE (R04)
# 45 DOCKED DAP TURN ON
# 46 ESTABLISH G+C CONTROL
# 47 MOVE OWS STATE VECTOR INTO CM STATE VECTOR.
# 48 REQUEST DAP DATA LOAD ROUTINE (R03)
# 49 REQUEST CREW DEFINED MANEUVER ROUTINE (R62)
# 50 PLEASE PERFORM
# 51 PLEASE MARK
# 52 SPARE
# 53 PLEASE PERFORM ALTERNATE LOS MARK
# 54 REQUEST RENDEZVOUS BACKUP SIGHTING MARK ROUTINE (R23)
# 55 INCREMENT AGC TIME (DECIMAL)
# 56 TERMINATE RENDEZVOUS TRACKING (P20)
# 57 DISPLAY UPDAT STATE OF FULTKFLG
# 58 ENABLE AUTO MANEUVER IN P20
# 59 ENABLE JETS DISABLED IN R04 DOCKED DATA LOAD ROUTINE
# 60 SET ASTRONAUT TOTAL ATTITUDE (N17) TO PRESENT ATTITUDE
# 61 DISPLAY DAP ATTITUDE ERROR
# 62 DISPLAY TOTAL ATTITUDE ERROR (WRT N22 (THETAD))
# 63 DISPLAY TOTAL ASTRONAUT ATTITUDE ERROR (WRT N17 (CPHIX))
# 64 TRANSFORM OPTICS ANGLES TO TRACKING ANGLES
# 65 OPTICAL VERIFICATION OF PRELAUNCH ALIGNMENT
# 66 VEHICLES ARE ATTACHED.  MOVE THIS VEHICLE STATE TO OTHER VEHICLE.
# 67 DISPLAY W MATRIX
# 68 SPARE
# 69 CAUSE RESTART
# 70 UPDATE LIFTOFF TIME
# 71 UNIVERSAL UPDATE - BLOCK ADR
# 72 UNIVERSAL UPDATE - SINGLE ADR
# 73 UPDATE AGC TIME (OCTAL)
# 74 INITIALIZE ERASABLE DUMP VIA DOWNLINK
# 75 BACKUP LIFTOFF
# 76 START R27 IN P20
# 77 KILL R27
# 78 UPDATE PRELAUNCH AZIMUTH
# 79 SPARE
# 80 UPDATE OWS STATE VECTOR
# 81 UPDATE CSM STATE VECTOR
# 82 REQUEST ORBIT PARAM DISPLAY (R30)
# 83 REQUEST REND  PARAM DISPLAY (R31)
# 84 SPARE
# 85 REQUEST RENDEZVOUS PARAMETER DISPLAY NO. 2 (R34)
# 86 REJECT RENDEZVOUS BACKUP SIGHTING MARK
# 87 SET VHF RANGE FLAG
# 88 RESET VHF RANGE FLAG
# 89 REQUEST RENDEZVOUS FINAL ATTITUDE ROUTINE (R63)
# 90 REQUEST RENDEZVOUS OUT OF PLANE DISPLAY ROUTINE (R36)
# 91 DISPLAY BANK SUM
# 92 SPARE
# 93 ENABLE W MATRIX INITIALIZATION
# 94 SPARE
# 95 SPARE
# 96 TERMINATE INTEGRATION AND GO TO P00
# 97 PERFORM ENGINE FAIL PROCEDURE
# 98 SPARE
# 99 PLEASE ENABLE ENGINE

# IN THE FOLLOWING NOUN LIST THE :NO LOAD: RESTRICTION MEANS THE NOUN
# CONTAINS AT LEAST ONE COMPONENT WHICH CANNOT BE LOADED, I.E. OF
# SCALE TYPE L (MIN/SEC) OR PP (2 INTEGERS).
#
# IN THIS CASE VERBS 24 AND 25 ARE NOT ALLOWED, BUT VERBS 21, 22 OR 23
# MAY BE USED TO LOAD ANY OF THE NOUN:S COMPONENTS WHICH ARE NOT OF THE
# ABOVE SCALE TYPES.
#
# THE :DEC ONLY: RESTRICTION MEANS ONLY DECIMAL OPERATION IS ALLOWED ON
# EVERY COMPONENT IN THE NOUN. (NOTE THAT :NO LOAD: IMPLIES :DEC ONLY:.)

# NORMAL NOUNS					   COMPONENTS	SCALE AND DECIMAL POINT		RESTRICTIONS
#
# 00  NOT IN USE
# 01  SPECIFY MACHINE ADDRESS (FRACTIONAL)		3COMP	.XXXXX FOR EACH
# 02  SPECIFY MACHINE ADDRESS (WHOLE)			3COMP	XXXXX. FOR EACH
# 03  SPECIFY MACHINE ADDRESS (DEGREES)			3COMP	XXX.XX DEG FOR EACH
# 04  ATTITUDE ERRORS					3COMP	XXX.XX DEG FOR EACH		NO LOAD, DEC ONLY
# 05  ANGULAR ERROR/DIFFERENCE				2COMP	XXX.XX DEG FOR EACH
#     CELESTIAL ANGLE
# 06  OPTION CODE					2COMP	OCTAL ONLY FOR EACH
# LOADING NOUN 07 WILL SET OR RESET SELECTED BITS IN ANY ERASABLE REGISTER
# 07  ECADR OF WORD TO BE MODIFIED			3COMP	OCTAL ONLY FOR EACH
#     ONES FOR BITS TO BE MODIFIED
#     1 TO SET OR 0 TO RESET SELECTED BITS
# 08  ALARM DATA					3COMP	OCTAL ONLY FOR EACH
# 09  ALARM CODES					3COMP	OCTAL ONLY FOR EACH
# 10  CHANNEL TO BE SPECIFIED				1COMP	OCTAL ONLY
# 11  TIG OF NCC					3COMP	00XXX. HRS			DEC ONLY
#								000XX. MIN			MUST LOAD 3 COMPS
#								0XX.XX SEC
# 12  OPTION CODE					2COMP	OCTAL ONLY FOR EACH
#      (USED BY EXTENDED VERBS ONLY)
# 13  TIG OF NSR					3COMP	00XXX. HRS			DEC ONLY
#								000XX. MIN			MUST LOAD 3 COMPS
#								0XX.XX SEC
# 14  STAR TRACKER AZIMUTH				2COMP	XXXXX. MIN
#                  ELEVATION					XXXXX. MIN
# 15  INCREMENT MACHINE ADDRESS				1COMP	OCTAL ONLY
# 16  TIME OF EVENT					3COMP	00XXX. HRS			DEC ONLY
#      (USED BY EXTENDED VERBS ONLY)				000XX. MIN			MUST LOAD 3 COMPS
#								0XX.XX SEC
# 17  ASTRONAUT TOTAL ATTITUDE				3COMP	XXX.XX DEG FOR EACH
# 18  AUTO MANEUVER BALL ANGLES				3COMP	XXX.XX DEG FOR EACH
# 19  STAR TRACKER AZIMUTH IN 2-WORD OCTAL		2COMP	OCTAL ONLY
#     FORMAT (USE VERB 04 TO DISPLAY)
# 20  ICDU ANGLES					3COMP	XXX.XX DEG FOR EACH
# 21  PIPAS						3COMP	XXXXX. PULSES FOR EACH
# 22  NEW ICDU ANGLES					3COMP	XXX.XX DEG FOR EACH
# 23  NAV BASE TO ATM EULER ANGLES			3COMP	XXX.XX DEG FOR EACH
# 24  DELTA TIME FOR AGC CLOCK				3COMP	00XXX. HRS			DEC ONLY
#								000XX. MIN			MUST LOAD 3 COMPS
#								0XX.XX SEC
# 25  CHECKLIST						3COMP	XXXXX. FOR EACH
#      (USED WITH PLEASE PERFORM ONLY)
# 26  PRIORITY/DELAY, ADRES, BBCON			3COMP	OCTAL ONLY FOR EACH
# 27  SELF TEST ON/OFF SWITCH				1COMP	XXXXX.
# 28  TIG OF NC2					3COMP	00XXX. HRS			DEC ONLY
#								000XX. MIN			MUST LOAD 3 COMPS
#								0XX.XX SEC
# 29  XSM LAUNCH AZIMUTH				1COMP	XXX.XX DEG			DEC ONLY
# 30  TARGET CODES					3COMP	XXXXX. FOR EACH
# 31  TIME OF W INIT					3COMP	00XXX. HRS			DEC ONLY
#								000XX. MIN			MUST LOAD 3 COMPS
# 								0XX.XX SEC
# 32  TIME FROM PERIGEE					3COMP	00XXX. HRS			DEC ONLY
#								000XX. MIN			MUST LOAD 3 COMPS
#								0XX.XX SEC
# 33  TIME OF IGNITION					3COMP	00XXX. HRS			DEC ONLY
#								000XX. MIN			MUST LOAD 3 COMPS
#								0XX.XX SEC
# 34  TIME OF EVENT					3COMP	00XXX. HRS			DEC ONLY
#								000XX. MIN			MUST LOAD 3 COMPS
#								0XX.XX SEC
# 35  TIME FROM EVENT					3COMP	00XXX. HRS			DEC ONLY
#								000XX. MIN			MUST LOAD 3 COMPS
#								0XX.XX SEC
# 36  TIME OF AGC CLOCK					3COMP	00XXX. HRS			DEC ONLY
#								000XX. MIN			MUST LOAD 3 COMPS
#								0XX.XX SEC
# 37  TIG OF TPI					3COMP	00XXX. HRS			DEC ONLY
#								000XX. MIN			MUST LOAD 3 COMPS
#								0XX.XX SEC
# 38  TIME OF STATE VECTOR				3COMP	00XXX. HRS			DEC ONLY
#								000XX. MIN			MUST LOAD 3 COMPS
#								0XX.XX SEC
# 39  TIG OF LAST MANEUVER				3COMP	00XXX. HRS			DEC ONLY
#								000XX. MIN			MUST LOAD 3 COMPS
#								0XX.XX SEC


# MIXED NOUNS					   COMPONENTS	SCALE AND DECIMAL POINT		RESTRICTIONS
#
# 40  TIME FROM IGNITION/CUTOFF				3COMP	XXBXX  MIN/SEC			NO LOAD, DEC ONLY
#     VG,							XXXX.X FT/SEC
#     DELTA V (ACCUMULATED)					XXXX.X FT/SEC
# 41  TARGET  AZIMUTH,					2COMP	XXX.XX DEG
#             ELEVATION						XX.XXX DEG
# 42  APOGEE,						3COMP	XXXX.X NAUT MI			DEC ONLY
#     PERIGEE,							XXXX.X NAUT MI
#     DELTA V (REQUIRED)					XXXX.X FT/SEC
# 43  LATITUDE,						3COMP	XXX.XX DEG			DEC ONLY
#     LONGITUDE,						XXX.XX DEG
#     ALTITUDE							XXXX.X NAUT MI
# 44  APOGEE,						3COMP	XXXX.X NAUT MI			NO LOAD, DEC ONLY
#     PERIGEE,							XXXX.X NAUT MI
#     TFF							XXBXX  MIN/SEC
# 45  MARKS (VHF - OPTICS)				3COMP	+XXBXX				NO LOAD, DEC ONLY
#     TFI OF NEXT BURN						XXBXX  MIN/SEC
#     MGA							XXX.XX DEG
# 46  AUTOPILOT CONFIGURATION				2COMP	OCTAL ONLY FOR EACH
# 47  THIS VEHICLE WEIGHT				2COMP	XXXXX. LBS			DEC ONLY
#     OTHER VEHICLE WEIGHT					XXXXX. LBS
# 48  PITCH TRIM					2COMP	XXX.XX DEG			DEC ONLY
#     YAW TRIM,							XXX.XX DEG
# 49  DELTA R						3COMP	XXX.XX NAUT MI			DEC ONLY
#     DELTA V							XXXX.X FT/SEC
#     VHF OR OPTICS CODE					XXXXX.
# 50  SPLASH ERROR,					3COMP	XXXX.X NAUT MI			NO LOAD, DEC ONLY
#     PERIGEE,							XXXX.X NAUT MI
#     TFF							XXBXX  MIN/SEC
# 51  SPARE
# 52  CENTRAL ANGLE OF ACTIVE VEHICLE			1COMP	XXX.XX DEG
# 53  RANGE,						3COMP	XXX.XX NAUT MI			DEC ONLY
#     RANGE RATE,						XXXX.X FT/SEC
#     PHI							XXX.XX DEG
# 54  RANGE,						3COMP	XXX.XX NAUT MI			DEC ONLY
#     RANGE RATE,						XXXX.X FT/SEC
#     THETA							XXX.XX DEG
# 55  PERIGEE CODE					2COMP	XXXXX.				DEC ONLY
#     ELEVATION ANGLE						XXX.XX DEG
# 56  VEHICLE RATE					3COMP	X.XXXX DEG/SEC FOR EACH		NO LOAD, DEC ONLY
# 57  NO. OF HALF REVS					3COMP	XXXXX.				DEC ONLY
#     DELTA ALT NCC						XXXX.X NAUT MI
#     DELTA ALT NSR						XXXX.X NAUT MI
# 58  DELTA V TPI					3COMP	XXXX.X FT/SEC			DEC ONLY
#     DELTA V TPF						XXXX.X FT/SEC
#     DELTA TIME (TPI - NOMTPI)					XXXBXX MIN/SEC
# 59  DELTA VELOCITY LOS				3COMP	XXXX.X FT/SEC FOR EA.		DEC ONLY
# 60  GMAX,						3COMP	XXX.XX G			DEC ONLY
#     VPRED,							XXXXX. FT/SEC
#     GAMMA EI							XXX.XX DEG
# 61  IMPACT LATITUDE,					3COMP	XXX.XX DEG			DEC ONLY
#     IMPACT LONGITUDE,						XXX.XX DEG
#     HEADS UP/DOWN						+/- 00001
# 62  INERTIAL VEL MAG (VI),				3COMP	XXXXX. FT/SEC			DEC ONLY
#     ALT RATE CHANGE (HDOT),					XXXXX. FT/SEC
#     ALT ABOVE PAD RADIUS (H)					XXXX.X NAUT MI
# 63  RANGE  297,431 TO SPLASH (RTGO),			3COMP	XXXX.X NAUT MI			NO LOAD, DEC ONLY
#     PREDICTED INERT VEL (VIO),				XXXXX. FT/SEC
#     TIME FROM 297,431 (TFE)					XXBXX  MIN/SEC
# 64  DRAG ACCELERATION,				3COMP	XXX.XX G			DEC ONLY
#     INERTIAL VELOCITY (VI),					XXXXX. FT/SEC
#     RANGE TO SPLASH						XXXX.X NAUT MI
# 65  SAMPLED AGC TIME					3COMP	00XXX. HRS			DEC ONLY
#      (FETCHED IN INTERRUPT)					000XX. MIN			MUST LOAD 3 COMPS
#								0XX.XX SEC
# 66  COMMAND BANK ANGLE (BETA),			3COMP	XXX.XX DEG			DEC ONLY
#     CROSS RANGE ERROR,					XXXX.X NAUT MI
#     DOWN RANGE ERROR						XXXX.X NAUT MI
# 67  RANGE TO TARGET,					3COMP	XXXX.X NAUT MI			DEC ONLY
#     PRESENT LATITUDE,						XXX.XX DEG
#     PRESENT LONGITUDE						XXX.XX DEG
# 68  COMMAND BANK ANGLE (BETA),			3COMP	XXX.XX DEG			DEC ONLY
#     INERTIAL VELOCITY (VI)	,				XXXXX. FT/SEC
#     ALT RATE CHANGE (RDOT)					XXXXX. FT/SEC
# 69  BETA						3COMP	XXX.XX DEG			DEC ONLY
#     DL							XXX.XX G
#     VL							XXXXX. FT/SEC
# 70  STAR CODE,					3COMP	OCTAL ONLY
# 71  STAR CODE						3COMP	OCTAL ONLY
# 72  TIME OF R27 OPTIMIZATION				3COMP	00XXX. HRS			DEC ONLY
#								000XX. MIN			MUST LOAD 3 COMPS
#								0XX.XX SEC
# 73  ALTITUDE						3COMP	XXXXXB. NAUT MI
#     VELOCITY							XXXXX.  FT/SEC
#     FLIGHT PATH ANGLE						XXX.XX  DEG
# 74  COMMAND BANK ANGLE (BETA)				3COMP	XXX.XX DEG
#     INERTIAL VELOCITY (VI)					XXXXX. FT/SEC
#     DRAG ACCELERATION						XXX.XX G
# 75  DELTA ALTITUDE CDH				3COMP	XXXX.X NAUT MI			NO LOAD, DEC ONLY
#     DELTA TIME (CDH-CSI OR TPI-CDH)				XXBXX  MIN/SEC
#     DELTA TIME (TPI-CDH OR TPI-NOMTPI)			XXBXX  MIN/SEC
# 76  CURRENT R27 RANGE					3COMP	XXX.XX NAUT MI			NO LOAD, DEC ONLY
#     CURRENT R27 RANGE-RATE					XXXX.X FT/SEC
#     TIME FROM R27 OPTIMIZATION				XXBXX  MIN/SEC
# 77  OPTIMIZED R27 RANGE				3COMP	XXX.XX NAUT MI			DEC ONLY
#     OPTIMIZED R27 RANGE-RATE					XXXX.X FT/SEC
#     R27 THETA/PHI						XXXXX. DEG
# 78  YAW ANGLE FOR P20					3COMP	XXX.XX DEG			DEC ONLY
#     PITCH ANGLE FOR P20					XXX.XX DEG
#     AZIMUTH CONSTRAINT FOR P20				XXX.XX DEG
# 79  P20 ROTATION RATE					2COMP	X.XXXX DEG/SEC			DEC ONLY
#     P20 ROTATION DEADBAND					XXX.XX DEG
# 80  TIME FROM IGNITION/CUTOFF				3COMP	XXBXX  MIN/SEC			NO LOAD, DEC ONLY
#     VG							XXXXX. FT/SEC
#     DELTA V (ACCUMULATED)					XXXXX. FT/SEC
# 81  DELTA V (LV)					3COMP	XXXX.X FT/SEC FOR EACH		DEC ONLY
# 82  NSR DELTA V (LV)					3COMP	XXXX.X FT/SEC FOR EACH		DEC ONLY
# 83  DELTA V (BODY)					3COMP	XXXX.X FT/SEC FOR EACH		DEC ONLY
# 84  DELTA V NEXT MANEUVER				3COMP	XXXX.X FT/SEC			DEC ONLY
#     DELTA ALT - NEXT MANEUVER					XXXX.X NAUT MI
#     DELTA V THIRD MANEUVER					XXXX.X FT/SEC
# 85  VG (BODY)						3COMP	XXXX.X FT/SEC FOR EACH		DEC ONLY
# 86  DELTA V (LV)					3COMP	XXXXX. FT/SEC FOR EACH		DEC ONLY
# 87  DOCKED DAP FLAG SPECIFICATION			3COMP	OCTAL ONLY FOR EACH
#     CHANNEL 5 JETS INHIBITED BY DOCKED DAP
#     CHANNEL 6 JETS INHIBITED BY DOCKED DAP
# 88  HALF UNIT SUN OR PLANET VECTOR			3COMP	.XXXXX FOR EACH			DEC ONLY
# 89  MANUAL/AUTO DOCKED DAP MANEUVER RATES		2COMP	X.XXXX DEG/SEC
#     DEAD BAND FOR DOCKED DAP					XXX.XX DEG
# 90  Y ACTIVE VEH					3COMP	XXX.XX NM			DEC ONLY
#     Y DOT ACTIVE VEH						XXXX.X FPS
#     Y DOT PASSIVE VEH						XXXX.X FPS
# 91  OCDU ANGLES  SHAFT,				2COMP	XXX.XX DEG
#		   TRUNION					XX.XXX DEG
# 92  NEW OPTICS ANGLES  SHAFT,				2COMP	XXX.XX DEG
#			 TRUNION				XX.XXX DEG
# 93  DELTA GYRO ANGLES					3COMP	XX.XXX DEG FOR EACH
# 94  NEW OPTICS ANGLES  SHAFT				2COMP	XXX.XX DEG
#			 TRUNNION				XX.XXX DEG
# 95  TIG OF NC1					3COMP	00XXX. HRS			DEC ONLY
#								000XX. MIN			MUST LOAD 3 COMPS
#								0XX.XX SEC
# 96  Y CM						3COMP	XXX.XX NM			DEC ONLY
#     Y DOT CM							XXXX.X FPS
#     Y DOT LM							XXXX.X FPS
# 97  SYSTEM TEST INPUTS				3COMP	XXXXX. FOR EACH
# 98  SYSTEM TEST RESULTS AND INPUTS			3COMP	XXXXX.
#								.XXXXX
#								XXXXX.
# 99  RMS IN POSITION					3COMP	XXXXX. FT			DEC ONLY
#     RMS IN VELOCITY						XXXX.X FT/SEC
#     RMS OPTION						XXXXX.


# REGISTERS AND SCALING  FOR NORMAL NOUNS
#
# NOUN		REGISTER		SCALE TYPE
#
# 00		NOT IN USE
# 01		SPECIFY ADDRESS		B
# 02		SPECIFY ADDRESS		C
# 03		SPECIFY ADDRESS		D
# 04			AK		F
# 05			DSPTEM1		F
# 06			OPTION1		A
# 07			XREG		A
# 08			ALMCADR		A
# 09			FAILREG		A
# 10		SPECIFY CHANNEL		A
# 11			TCSI		K
# 12			OPTIONX		A
# 13			TCDH		K
# 14			TRKAZ		BBB
# 15		INCREMENT ADDRESS	A
# 16			DSPTEMX		K
# 17			CPHIX		D
# 18			THETAD		D
# 19			TRKAZOCT	A
# 20			CDUX		D
# 21			PIPAX		C
# 22			THETAD		D
# 23			THETAD		D
# 24			DSPTEM2 +1	K
# 25			DSPTEM1		C
# 26			N26/PRI		A
# 27			SMODE		C
# 28			NC2TIG		K
# 29			DSPTEM1		D
# 30			DSPTEM1		C
# 31			AGEOFW		K
# 32			-TPER		K
# 33			TIG		K
# 34			DSPTEM1		K
# 35			TTOGO		K
# 36			TIME2		K
# 37			TTPI		K
# 38			TET		K
# 39			LASTTIG		K


# REGISTERS AND SCALING FOR MIXED NOUNS
#
# NOUN	COMP	REGISTER	SCALE TYPE
#
# 40	1	TTOGO		L
#	2	VGDISP		S
#	3	DVTOTAL		S
# 41	1	DSPTEM1		D
#	2	DSPTEM1 +1	E
# 42	1	HAPO		Q
#	2	HPER		Q
#	3	VGDISP		S
# 43	1	LAT		H
#	2	LONG		H
#	3	ALT		Q
# 44	1	HAPOX		Q
#	2	HPERX		Q
#	3	TFF		L
# 45	1	VHFCNT		PP
#	2	TTOGO		L
#	3	+MGA		H
# 46	1	DAPDATR1	A
#	2	DAPDATR2	A
# 47	1	CSMMASS		KK
#	2	LEMMASS		KK
# 48	1	PACTOFF		FF
#	2	YACTOFF		FF
# 49	1	N49DISP		Q
#	2	N49DISP +2	S
#	3	N49DISP +4	C
# 50	1	RSP-RREC	LL
#	2	HPERX		Q
#	3	TFF		L
# 51	SPARE
# 52	1	ACTCENT		H
# 53	1	RANGE		JJ
#	2	RRATE		S
# 	3	RTHETA		H
# 54	1	RANGE		JJ
#	2	RRATE		S
# 	3	RTHETA		H
# 55	1	NN1		C
# 	2	ELEV		H
# 56	1	ADOT		EEE
#	2	ADOT +2		EEE
#	3	ADOT +4		EEE
# 57	1	HALFREVS	C
#	2	DHNCC		Q
#	3	DELH1		Q
# 58	1	DELVTPI		S
#	2	DELVTPF		S
#	3	T2TOT3		L
# 59	1	DVLOS		S
#	2	DVLOS +2	S
#	3	DVLOS +4	S
# 60	1	GMAX		T
#	2	VPRED		P
#	3	GAMMAEI		H
# 61	1	LAT(SPL)	H
#	2	LNG(SPL)	H
#	3	HEADSUP		C
# 62	1	VMAGI		P
#	2	HDOT		P
#	3	ALTI		Q
# 63	1	RTGO		LL
#	2	VIO		P
#	3	TTE		L
# 64	1	D		MM
#	2	VMAGI		P
#	3	RTGON64		LL
# 65	1	SAMPTIME	K
#	2	SAMPTIME	K
#	3	SAMPTIME	K
# 66	1	ROLLC		H
#	2	XRNGERR		VV
#	3	DNRNGERR	LL
# 67	1	RTGON67		LL
#	2	LAT		H
#	3	LONG		H
# 68	1	ROLLC		H
#	2	VMAGI		P
#	3	RDOT		UU
# 69	1	ROLLC		H
#	2	Q7		MM
#	3	VL		UU
# 70	1	STARCODE	A
# 71	1	STARCODE	A
# 72	1	FIXTIME		K
#	2	FIXTIME		K
#	3	FIXTIME		K
# 73	1	P21ALT		Q (MEMORY/100 TO DISPLAY TENS N.M.)
#	2	P21VEL		P
#	3	P21GAM		H
# 74	1	ROLLC		H
#	2	VMAGI		P
#	3	D		MM
# 75	1	DIFFALT		Q
#	2	T1TOT2		L
#	3	T2TOT3		L
# 76	1	SVEC		DDD
#	2	SVEC +2		CCC
#	3	TFO		H
# 77	1	OPVEC		DDD
#	2	OPVEC +2	CCC
#	3	PHETA		H
# 78	1	UTYAW		D
# 78	2	UTPIT		D
# 78	3	AZIMANGL	D
# 79	1	RATEPTC		E (MEMORY/10 TO LOAD X.XXXX DEG/SEC)
#	2	DBPTC		D
# 80	1	TTOGO		L
#	2	VGDISP		P
#	3	DVTOTAL		P
# 81	1	DELVLVC		S
#	2	DELVLVC +2	S
#	3	DELVLVC +4	S
# 82	1	VGNSR		S
#	2	VGNSR +2	S
#	3	VGNSR +4	S
# 83	1	DELVIMU		S
#	2	DELVIMU +2	S
#	3	DELVIMU +4	S
# 84	1	DVDSP1		S
#	2	DHDSP		Q
#	3	DVDSP2		S
# 85	1	VGBODY		S
#	2	VGBODY +2	S
#	3	VGBODY +4	S
# 86	1	DELVLVC		P
#	2	DELVLVC +2	P
#	3	DELVLVC +4	P
# 87	1	DAPDATR3	A
#	2	CH5FAIL		A
#	3	CH6FAIL		A
# 88	1	STARSAV	3	ZZ
#	2	STARSAV3 +2	ZZ
#	3	STARSAV3 +4	ZZ
# 89	1	DKRATE		AAA
#	2	DKDB		F
# 90	1	YCSM		JJ
#	2	YDOTC		S
#	3	YDOTL		S
# 91	1	CDUS		D
#	2	CDUT		J
# 92	1	SAC		D
#	2	PAC		J
# 93	1	OGC		G
#	2	OGC +2		G
#	3	OGC +4		G
# 94	1	MRKBUF1 +3	D
#	2	MRKBUF1 +5	J
# 95	1	NC1TIG		H
#	2	NC1TIG		H
#	3	NC1TIG		H
# 96	1	RANGE		JJ
#	2	RRATE		S
#	3	RRATE2		S
# 97	1	DSPTEM1		C
#	2	DSPTEM1 +1	C
# 	3	DSPTEM1 +2	C
# 98	1	DSPTEM2		C
#	2	DSPTEM2 +1	B
#	3	DSPTEM2 +2	C
# 99	1	WWPOS		XX
#	2	WWVEL		YY
#	3	WWOPT		C


# NOUN SCALES AND FORMATS
#
# -SCALE TYPE-					PRECISION
# UNITS			DECIMAL FORMAT			--	AGC FORMAT
# ------------		--------------			--	----------
#
# -A-
# OCTAL			XXXXX				SP	OCTAL
#
# -B-									 -14
# FRACTIONAL		.XXXXX				SP	BIT 1 = 2    UNITS
#			(MAX .99996)
#
# -C-
# WHOLE			XXXXX.				SP	BIT 1 = 1 UNIT
#			(MAX 16383.)
#
# -D-									     15
# CDU DEGREES		XXX.XX DEGREES			SP	BIT 1 = 360/2   DEGREES
#			(MAX 359.99)				(USES 15 BITS FOR MAGNI-
#								TUDE AND 2-S COMP.)
#
# -E-									    14
# ELEVATION DEGREES	XX.XXX DEGREES			SP	BIT 1 = 90/2   DEGREES
#			(MAX 89.999)
#
# -F-									     14
# DEGREES (180)		XXX.XX DEGREES			SP	BIT 1 = 180/2   DEGREES
#			(MAX 179.99)
#
# -G-
# DP DEGREES (90)	XX.XXX DEGREES			DP	BIT 1 OF LOW REGISTER =
#								     28
#								360/2   DEGREES
#
# -H-
# DP DEGREES (360)	XXX.XX DEGREES			DP	BIT 1 OF LOW REGISTER =
#			         				     28
#			(MAX 359.99)				360/2   DEGREES
#
# -J-									    15
# Y OPTICS DEGREES	XX.XXX DEGREES			SP	BIT 1 = 90/2   DEGREES
#			(BIAS OF 19.775				(USES 15 BITS FOR MAGNI-
#			DEGREES ADDED FOR			TUDE AND 2-S COMP.)
#			DISPLAY, SUBTRACTED
#			FOR LOAD.)
#			NOTE:  NEGATIVE NUM-
#			BERS CANNOT BE 
#			LOADED.
#
# -K-
# TIME (HR, MIN, SEC)	00XXX. HR			DP	BIT 1 OF LOW REGISTER =
#			000XX. MIN				  -2
#			0XX.XX SEC				10   SEC
#			(DECIMAL ONLY.
#			MAX MIN COMP=59
#			MAX SEC COMP=59.99
#			MAX CAPACITY=745 HRS
#			              39 MINS
#			              14.55 SECS.
#			WHEN LOADING, ALL 3
#			COMPONENTS MUST BE
#			SUPPLIED.)
#
# -L-
# TIME (MIN/SEC)	XXBXX MIN/SEC			DP	BIT 1 OF LOW REGISTER =
#			(B IS A BLANK				  -2
#			POSITION, DECIMAL			10   SEC
#			ONLY, DISPLAY OR 
#			MONITOR ONLY. CANNOT
#			BE LOADED.
#			MAX MIN COMP=59
#			MAX SEC COMP=59
#			VALUES GREATER THAN
#			59 MIN 59 SEC
#			ARE DISPLAYED AS
#			59 MIN 59 SEC.)
#
# -M-									  -2
# TIME (SEC)		XXX.XX SEC			SP	BIT 1 = 10   SEC
#			(MAX 163.83)
#
# -N-
# TIME (SEC) DP		XXX.XX SEC			DP	BIT 1 OF LOW REGISTER =
#								  -2
#								10   SEC
#
# -P-
# VELOCITY 2		XXXXX. FEET/SEC			DP	BIT 1 OF HIGH REGISTER =
#			(MAX 41994.)				 -7
#								2   METERS/CENTI-SEC
#
# -Q-
# POSITION 4		XXXX.X NAUTICAL MILES		DP	BIT 1 OF LOW REGISTER =
#								2 METERS
#
# -S-
# VELOCITY 3		XXXX.X FT/SEC			DP	BIT 1 OF HIGH REGISTER =
#								 -7
#								2   METERS/CENTI-SEC
# -T-									  -2
# G			XXX.XX G			SP	BIT 1 = 10   G
#			(MAX 163.83)
#
# -FF-
# TRIM DEGREES		XXX.XX DEG.			SP	LOW ORDER BIT = 85.41 SEC
#			(MAX 388.69)				OF ARC
#
# -GG-
# INERTIA		XXXXXBB. SLUG FT SQ		SP	FRACTIONAL PART OF
#			(MAX 07733BB.)				 20     2
#								2   KG M
#
# -II-										    20
# THRUST MOMENT		XXXXXBB. FT LBS			SP	FRACTIONAL PART OF 2
#			(MAX 07733BB.)				NEWTON METER
#
# -JJ-
# POSITION5		XXX.XX NAUT MI			DP	BIT 1 OF LOW REGISTER =
#								2 METERS
#
# -KK-										    16
# WEIGHT2		XXXXX. LBS			SP	FRACTIONAL PART OF 2   KG
#
# -LL-
# POSITION6		XXXX.X NAUT MI			DP	BIT 1 OF LOW REG =
#										    -28
#								(6,373,338)(2(PI))X2
#								-----------------------
#									1852
#								NAUT. MI.
#
# -MM-
# DRAG ACCELERATION	XXX.XX G			DP	BIT 1 OF LOW REGISTER =
#			MAX (024.99)				    -28
#								25X2    G
#
# -PP-
# 2 INTEGERS		+XXBYY				DP	BIT 1 OF HIGH REGISTER =
#			(B IS A BLANK				 1 UNIT OF XX
#			POSITION. DECIMAL			BIT 1 OF LOW REGISTER =
#			ONLY, DISPLAY OR			 1 UNIT OF YY
#			MONITOR ONLY. CANNOT			(EACH REGISTER MUST
#			BE LOADED.)				 CONTAIN A POSITIVE INTEGER
#			(MAX 99B99)				 LESS THAN 100)
#
# -UU-
# VELOCITY/2VS		XXXXX. FEET/SEC			DP	FRACTIONAL PART OF 
#			(MAX 51532.)				2VS FEET/SEC
#								(VS = 25766.1973)
# -VV-
# POSITION8		XXXX.X NAUT MI			DP	BIT 1 OF LOW REGISTER =
#										 -28
#								4 X 6,373,338 X 2
#								--------------------
#									1852
#								NAUT MI
#
# -XX-
# POSITION 9		XXXXX. FEET			DP	BIT 1 OF LOW REGISTER =
#								 -9
#								2   METERS
#
# -YY-
# VELOCITY 4		XXXX.X FEET/SEC			DP	FRACTIONAL PART OF
#			(MAX 328.0)				METERS/CENTI-SEC
#
# -ZZ-
# DP FRACTIONAL	.XXXXX					DP	BIT 1 OF HIGH REGISTER =
#								 -14
#								2    UNITS
# -AAA-
# RATE 1		X.XXXX DEG/SEC			DP	BIT 1 OF LOW REGISTER =
#								 -9
#								2   DEGREES/SEC
# -BBB-
# ARC MINUTES		XXXXX. MIN			DP	BIT 1 OF LOW REGISTER =
#								     28
#								360/2   DEGREES
# -CCC-
# VELOCITY 5		XXXX.X FEET/SEC			DP	BIT 1 OF LOW REGISTER =
#								 -6
#								2   METERS/CENTI-SEC
# -DDD-
# POSITION 10		XXX.XX NAUT MI			DP	BIT 1 OF LOW REGISTER =
#								 -20
#								2    NAUT MI
# -EEE-
# RATE 2		X.XXXX DEG/SEC			DP	BIT 1 OF LOW REGISTER =
#								     28
#								450/2   DEGREES/SEC

# THAT-S ALL ON THE NOUNS.


# ALARM CODES
# 	REPORT DEFICIENCIES TO JOHN SUTHERLAND @ MIT 617-864-6900 X1458

# *9		*18						*60					*25  COLUMN
#
# CODE       *	TYPE						SET BY					ALARM ROUTINE
#
# 00107		STAR TRACKER ANGLES OUT OF LIMITS		P55					ALARM
# 00110		NO MARK SINCE LAST MARK REJECT			SXTMARK					ALARM
# 00113		NO INBITS					SXTMARK					ALARM
# 00114		MARK MADE BUT NOT DESIRED			SXTMARK					ALARM
# 00115		OPTICS TORQUE REQUESTWITH SWITCH NOT AT		EXT VERB OPTICS CDU			ALARM
# 			CGC
# 00116		OPTICS SWITCH ALTERED BEFORE 15 SEC ZERO	T4RUPT					ALARM
#			TIME ELAPSED.
# 00117		OPTICS TORQUE REQUEST WITH OPTICS NOT		EXT VERB OPTICS CDU			ALARM
#			AVAILABLE (OPTIND=-0)
# 00120		OPTICS TORQUE REQUEST WITH OPTICS		T4RUPT					ALARM
#			NOT ZEROED
# 00121		CDUS NO GOOD AT TIME OF MARK			SXTMARK					ALARM
# 00205		BAD PIPA READING				SERVICER				ALARM
# 00206		ZERO ENCODE NOT ALLOWED WITH COARSE ALIGN	IMU MODE SWITCHING			ALARM
# 			+ GIMBAL LOCK
# 00207		ISS TURNON REQUEST NOT PRESENT FOR 90 SEC	T4RUPT					ALARM
# 00210		IMU NOT OPERATING				IMU MODE SWITCH, IMU-2, R02, P51	ALARM, VARALARM
# 00211		COARSE ALIGN ERROR - DRIVE > 2 DEGREES		IMU MODE SWITCH				ALARM
# 00212		PIPA FAIL BUT PIPA IS NOT BEING USED		IMU MODE SWITCH, T4RPT			ALARM
# 00213		IMU NOT OPERATING WITH TURN-ON REQUEST		T4RUPT					ALARM
# 00214		PROGRAM USING IMU WHEN TURNED OFF		T4RUPT					ALARM
# 00217		BAD RETURN FROM STALL ROUTINES.			CURTAINS				ALARM2
# 00220		IMU NOT ALIGNED - NO REFSMMAT			R02,P51					
# 00401		DESIRED GIMBAL ANGLES YIELD GIMBAL LOCK		IMF ALIGN, IMU-2			ALARM
# 00402		CREW MUST HONOR 2ND MINKEY TORQUE REQUEST	P52					ALARM
# 00404		TARGET OUT OF VIEW - TRUN ANGLE > 90 DEG	R52					PRIOLARM
# 00405		TWO STARS NOT AVAILABLE				P52,P54					ALARM
# 00406		REND NAVIGATION NOT OPERATING			R21,R23					ALARM
# 00421		W-MATRIX OVERFLOW				INTEGRV					VARALARM
# 00500		NOT ENOUGH PITCH OR YAW JETS			DOCKED DAP				ALARM FIXME
# 00501		NOT ENOUGH ROLL JETS				DOCKED DAP				ALARM FIXME
# 00600		10 ITERATIONS OF PHASE MATCH LOOP		P31, P32				ALARM FIXME
# 00601		15 ITERATIONS OF AN INNER LOOP			P31, P32				ALARM FIXME
# 00602		15 ITERATIONS OF OUTER LOOP			P31, P32				ALARM FIXME
# 00603		15 ITERATIONS OF QRDTP1 SUBROUTINE		P31, P32, P33				ALARM FIXME
# 00611		NO TIG FOR GIVEN ELEV ANGLE			P34,					VARALARM
# 00777		PIPA FAIL CAUSED ISS WARNING.			T4RUPT					VARALARM
# 01102		CMC SELF TEST ERROR									ALARM2
# 01105		DOWNLINK TOO FAST				T4RUPT					ALARM
# 01106		UPLINK TOO FAST					T4RUPT					ALARM
# 01107		PHASE TABLE FAILURE. ASSUME			RESATRT					ALARM
#		ERASABLE MEMORY IS DESTROYED
# 01301		ARCSIN-ARCCOS ARGUMENT TOO LARGE		INTERPRETER				ALARM
# 01407		VG INCREASING					S40.8					ALARM
# 01426		IMU UNSATISFACTORY				P61, P62				ALARM
# 01427		IMU REVERSED					P61, P62				ALARM
# 01520		V37 REQUEST NOT PERMITTED AT THIS TIME		V37					ALARM
# 01600		OVERFLOW IN DRIFT TEST				OPT PRE ALIGN CALIB			ALARM
# 01601		BAD IMU TORQUE					OPT PRE ALIGN CALIB			ALARM
# 01703		INSUF. TIME FOR INTEG., TIG WAS SLIPPED		R41					ALARM
# 03777		ICDU FAIL CAUSED THE ISS WARNING		T4RUPT					VARALARM
# 04777		ICDU, PIPA FAILS CAUSED THE ISS WARNING		T4RUPT					VARALARM
# 07777		IMU FAIL CAUSED THE ISS WARNING			T4RUPT					VARALARM
# 10777		IMU, PIPA FAILS CAUSED THE ISS WARNING		T4RUPT					VARALARM
# 13777		IMU, ICDU FAILS CAUSED THE ISS WARNING		T4RUPT					VARALARM
# 14777		IMU, ICDU, PIPA FAILS CAUSED THE ISS WNING	T4RUPT					VARALARM
# 20430     *	INTEG. ABORT DUE TO SUB-SURFACE S.V.		ALL CALLS TO INTEG.			POODOO
# 20607     *	NO SOLUTION FROM TIME-THETA OR			TIMETHET, TIMERAD			POODOO
# 		TIME-RADIUS
# 21204     *	NEGATIVE OR ZERO WAITLIST CALL			WAITLIST				POODOO
# 21206     *	SECOND JOB ATTEMPTS TO GO TO SLEEP		PINBALL					POODOO
# 			VIA KEYBOARD AND DISPLAY PROGRAM
# 21210     *	TWO PROGRAMS USING DEVICE AT SAME TIME		IMU MODE SWITCH				POODOO
# 21302     *	SQRT CALLED WITH NEGATIVE ARGUMENT. ABORT	INTERPRETER				POODOO
# 21501     *	KEYBOARD AND DISPLAY ALARM DURING		PINBALL					POODOO
# 			INTERNAL USE (NVSUB). ABORT.
# 21502     *	ILLEGAL FLASHING DISPLAY			GOPLAY					POODOO
# 21521     *	P01 OR P07 ILLEGALLY SELECTED			P01, P07				POODOO
# 31104     *	DELAY ROUTINE BUSY				SERVICE ROUTINES			BAILOUT
# 31201     *	EXECUTIVE OVERFLOW - NO VAC AREAS		EXECUTIVE				BAILOUT
# 31202     *	EXECUTIVE OVERFLOW - NO CORE SETS		EXECUTIVE				BAILOUT
# 31203     *	WAITLIST OVERFLOW - TOO MANY TASKS		WAITLIST				BAILOUT
# 31211     *	ILLEGAL INTERRUPT OF EXTENDED VERB		SXTMARK					BAILOUT
# 32000     *	JASK INTERRUPTING THE PRCEDING JASK		DKJSLECT				BAILOUT
#
#           *	INDICATES ABORT TYPE. ALL OTHERS NON-ABORTIVE


# CHECKLIST CODES FOR 504

# PLEASE REPORT ANY DEFICIENCIES IN THIS LIST TO ASSEMBLY CONTROL

# *9		*17		*26  COLUMN
#
# R1 CODE	   ACTION TO BE EFFECTED
#
# 00013		KEY IN   COARSE ALIGN OPTION
# 00014		KEY IN   FINE ALIGNMENT OPTION
# 00015		PERFORM  CELESTIAL BODY ACQUISITION
# 00016		KEY IN   TERMINATE MARK SEQUENCE
# 00017		PERFORM MINKEY RENDEZVOUS
# 00020		PERFORM MINKEY PLANE CHANGE PULSE TORQUING
# 00041		SWITCH   CM/SM SEPARATION TO UP
# 00062		SWITCH   AGC POWER DOWN
# 00204		PERFORM  SPS GIMBAL TRIM
#
#		SWITCH DENOTES CHANGE POSITION OF A CONSOLE SWITCH
#		PERFORM DENOTES START OR END OF A TASK
#		KEY IN DENOTES KEY IN OF DATA THRU THE DSKY


# OPTION CODES FOR 504

# PLEASE REPORT ANY DEFICIENCIES IN THIS LIST TO ASSEMBLY CONTROL
#
# THE SPECIFIED OPTION CODES WILL BE FLASHED IN COMPONENT R1 IN 
# CONJUNCTION WITH VERB04NOUN06 TO REQUEST THE ASTRONAUT TO LOAD INTO
# COMPONENT R2 THE OPTION HE DESIRES.

# *9		*17					*52					*11
#
# OPTION	
# CODE		PURPOSE					INPUT FOR COMPONENT 2			PROGRAM(S)
#
# 00001		SPECIFY IMU ORIENTATION			1=PREF 2=NOM 3=REFSMMAT			P50'S
# 00002		SPECIFY VEHICLE				1=THIS 2=OTHER				P21,R30
# 00004		SPECIFY STATE OF TRACKING=FULTKFLAG	0=FULL 1=PARTIAL			P20
# 00012		SPECIFY P50 OPTION			1=SUN ONLY				P50
#							2=SUN AND STAR
#							3=INDEPENDENT STAR
#							ORBIT TO PASS OVER LM
# 00013		SPECIFY P55 OPTION			1=REFSMMAT 2=MARK			P55
# 00024		SPECIFY TRACKING OPTION			0 = RENDEZVOUS, VECPOINT		P20
#							1 = CELESTIAL BODY, VECPOINT
#							2 = ROTATION
#							4 = RENDEZVOUS, 3-AXIS
#							5 = CELESTIAL BODY, 3-AXIS
