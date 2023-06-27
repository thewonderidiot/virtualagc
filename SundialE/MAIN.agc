### FILE="Main.annotation"
# Copyright:    Public domain.
# Filename:     MAIN.agc
# Purpose:      Part of the source code for Aurora (revision 12),
# Assembler:    yaYUL
# Contact:      Ron Burkey <info@sandroid.org>.
# Website:      https://www.ibiblio.org/apollo/index.html
# Mod history:  2016-09-20 JL   Created.
#               
# MAIN.agc is a little different from the other Aurora12 files  
# provided, in that it doesn't represent anything that appears 
# directly in the original source.  What we have done for 
# organizational purposes is to split the huge monolithic source 
# code into smaller, more manageable chunks--i.e., into individual
# source files.  Those files are rejoined within this file as 
# "includes".  It just makes it a little easier to work with.  The
# code chunks correspond to natural divisions into sub-programs.  
# The divisions are by the assembly listing itself.

# Source file name
# ----------------

$ASSEMBLY_AND_OPERATION_INFORMATION.agc
$ERASABLE_ASSIGNMENTS.agc
$INPUT_OUTPUT_CHANNELS.agc
$INTERRUPT_LEAD_INS.agc
$INTER-BANK_COMMUNICATION.agc
$LIST_PROCESSING_INTERPRETER.agc
$SINGLE_PRECISION_SUBROUTINES.agc
$EXECUTIVE.agc
$WAITLIST.agc
$PHASE_TABLE_MAINTENANCE.agc
$FRESH_START_AND_RESTART.agc
$T4RUPT_PROGRAM.agc
$IMU_MODE_SWITCHING_ROUTINES.agc
$SXTMARK.agc
$EXTENDED_VERBS.agc
$KEYRUPT,_UPRUPT.agc
$PINBALL_GAME__BUTTONS_AND_LIGHTS.agc
$ALARM_AND_ABORT.agc
$DOWN-TELEMETRY_PROGRAM.agc
$AGC_BLOCK_TWO_SELF-CHECK.agc
$INFLIGHT_ALIGNMENT_ROUTINES.agc
$RTB_OP_CODES.agc
$CSM_AND_SATURN_INTEGRATED_TESTS.agc
$IMU_PERFORMANCE_TESTS_1.agc
$IMU_PERFORMANCE_TESTS_2.agc
$IMU_PERFORMANCE_TESTS_3.agc
$PRELAUNCH_ALIGNMENT_PROGRAM.agc
$OPTIMUM_PRELAUNCH_ALIGNMENT_CALIBRATION.agc
$SUM_CHECK_END_OF_BANK_MARKERS.agc
