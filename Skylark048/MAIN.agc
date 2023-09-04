### FILE="Main.annotation"
# Copyright:	Public domain.
# Filename:	MAIN.agc
# Purpose:	Part of the source code for Artemis (i.e., Colossus 3),
#		build 072.  This is for the Command Module's (CM) 
#		Apollo Guidance Computer (AGC), for 
#		Apollo 15-17.
# Assembler:	yaYUL
# Contact:	Ron Burkey <info@sandroid.org>.
# Website:	www.ibiblio.org/apollo/index.html
# Page Scans:	www.ibiblio.org/apollo/ScansForConversion/Artemis072/
# Mod history:	2004-12-21 RSB	Created.
#		2005-05-14 RSB	Corrects website reference above.
#		2009-07-25 RSB	Fixups for this header so that it can
#				be used for code conversions.
#		2009-08-12 JL	Fix typo.
#		2009-08-18 JL	Change some filenames to match log section names.
#		2009-09-03 JL	Comment out some modules that are not available yet, 
#				to start checking build.
#		2009-09-04 JL	Uncomment modules that are now available.
#		2010-02-20 RSB	The effects of most of the ## in this header were
#				horrible, so I removed them ... and in all of the
#				other included source files as well. 

# Source-file Name
# ----------------

$ASSEMBLY_AND_OPERATION_INFORMATION.agc
$TAGS_FOR_RELATIVE_SETLOC_AND_BLANK_BANK_CARDS.agc
$ABSOLUTE_LOCATIONS_FOR_UPDATES.agc
$SUBROUTINE_CALLS.agc
$ERASABLE_ASSIGNMENTS.agc

# ERASTOTL
$CHECK_EQUALS_LIST.agc

# DIOGENES
$INTERRUPT_LEAD_INS.agc
$T4RUPT_PROGRAM.agc
$DOWNLINK_LISTS.agc
$FRESH_START_AND_RESTART.agc
$RESTART_TABLES.agc
$SXTMARK.agc
$EXTENDED_VERBS.agc
$PINBALL_NOUN_TABLES.agc
$CSM_GEOMETRY.agc
$IMU_COMPENSATION_PACKAGE.agc
$PINBALL_GAME__BUTTONS_AND_LIGHTS.agc
$R60,R62.agc
$ANGLFIND.agc
$GIMBAL_LOCK_AVOIDANCE.agc
$KALCMANU_STEERING.agc
$SYSTEM_TEST_STANDARD_LEAD_INS.agc
$IMU_CALIBRATION_AND_ALIGNMENT.agc

# MEDUSA
$GROUND_TRACKING_DETERMINATION_PROGRAM_-_P21.agc
$P34-P35,_P74-P75.agc
$R31.agc
$R30.agc

# MENELAUS
$P15.agc
$P11.agc
$P20-P25.agc
$P30-P31.agc
$P40-P47.agc
$P51-P53.agc
$LUNAR_AND_SOLAR_EPHEMERIDES_SUBROUTINES.agc
$P61-P67.agc
$SERVICER207.agc
$ENTRY_LEXICON.agc
$REENTRY_CONTROL.agc
$CM_BODY_ATTITUDE.agc

# ULYSSES
$TVCINITIALIZE.agc
$TVCEXECUTIVE.agc
$TVCMASSPROP.agc
$TVCRESTARTS.agc
$TVCDAPS.agc
$TVCROLLDAP.agc
$MYSUBS.agc
$RCS-CSM_DIGITAL_AUTOPILOT.agc
$AUTOMATIC_MANEUVERS.agc
$RCS-CSM_DAP_EXECUTIVE_PROGRAMS.agc
$JET_SELECTION_LOGIC.agc
$CM_ENTRY_DIGITAL_AUTOPILOT.agc

# ZEUS
$DOWN-TELEMETRY_PROGRAM.agc
$INTER-BANK_COMMUNICATION.agc
$INTERPRETER.agc
$FIXED-FIXED_CONSTANT_POOL.agc
$INTERPRETIVE_CONSTANTS.agc
$SINGLE_PRECISION_SUBROUTINES.agc
$EXECUTIVE.agc
$WAITLIST.agc
$LATITUDE_LONGITUDE_SUBROUTINES.agc
$PLANETARY_INERTIAL_ORIENTATION.agc
$MEASUREMENT_INCORPORATION.agc
$CONIC_SUBROUTINES.agc
$INTEGRATION_INITIALIZATION.agc
$ORBITAL_INTEGRATION.agc
$INFLIGHT_ALIGNMENT_ROUTINES.agc
$POWERED_FLIGHT_SUBROUTINES.agc
$TIME_OF_FREE_FALL.agc
$STAR_TABLES.agc
$AGC_BLOCK_TWO_SELF-CHECK.agc
$PHASE_TABLE_MAINTENANCE.agc
$RESTARTS_ROUTINE.agc
$IMU_MODE_SWITCHING_ROUTINES.agc
$KEYRUPT,_UPRUPT.agc
$DISPLAY_INTERFACE_ROUTINES.agc
$SERVICE_ROUTINES.agc
$ALARM_AND_ABORT.agc
$UPDATE_PROGRAM.agc
$RTB_OP_CODES.agc
