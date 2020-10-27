### FILE="Main.annotation"
# Copyright:    Public domain.
# Filename:     MAIN.agc
# Purpose:      Part of the source code for Aurora (revision 12),
# Assembler:    yaYUL
# Contact:      Ron Burkey <info@sandroid.org>.
# Website:      https://www.ibiblio.org/apollo/index.html
# Page Scans:   https://archive.org/details/aurora00dapg
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
$IMU_COMPENSATION_PACKAGE.agc
$AOTMARK.agc
$RADAR_LEAD-IN_ROUTINES.agc
$RADAR_TEST_PROGRAMS.agc
$EXTENDED_VERBS.agc
$KEYRUPT,_UPRUPT.agc
$PINBALL_GAME__BUTTONS_AND_LIGHTS.agc
$ALARM_AND_ABORT.agc
$CONTROLLER_AND_METER_ROUTINES.agc
$DOWN-TELEMETRY_PROGRAM.agc
$AGC_BLOCK_TWO_SELF-CHECK.agc
$INFLIGHT_ALIGNMENT_ROUTINES.agc
$RTB_OP_CODES.agc
$LEM_FLIGHT_CONTROL_SYSTEM_TEST.agc
$IMU_PERFORMANCE_TESTS_1.agc
$IMU_PERFORMANCE_TESTS_2.agc
$IMU_PERFORMANCE_TESTS_3.agc
$OPTIMUM_PRELAUNCH_ALIGNMENT_CALIBRATION.agc
$DIGITAL_AUTOPILOT_ERASABLE.agc
$P-AXIS_REACTION_CONTROL_SYSTEM_AUTOPILOT.agc
$DAPIDLER_PROGRAM.agc
$Q,R-AXES_REACTION_CONTROL_SYSTEM_AUTOPILOT.agc
$JET_FAILURE_CONTROL_LOGIC.agc
$KALMAN_FILTER_FOR_LEM_DAP.agc
$TRIM_GIMBAL_CONTROL_SYSTEM.agc
$AOSTASK.agc
$RCS_FAILURE_MONITOR.agc
$ASCENT_INERTIA_UPDATER.agc
$SUM_CHECK_END_OF_BANK_MARKERS.agc
