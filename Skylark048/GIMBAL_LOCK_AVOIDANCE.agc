### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	GIMBAL_LOCK_AVOIDANCE.agc
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

		
		SETLOC	KALCMON1
		BANK
		
		COUNT*	$$/KALC
		EBANK=	BCDU
		
# DETECTING GIMBAL LOCK
LOCSKIRT	EQUALS	WCALC
WCALC		LXC,1	DLOAD*
			RATEINDX
			ARATE,1	
		SR4	CALL		# COMPUTE THE INCREMENTAL ROTATION MATRIX
			DELCOMP		# DEL CORRESPONDING TO A 1 SEC ROTATION
					# ABOUT COF
		DLOAD*	VXSC
			ARATE,1
			COF
		MXV
			QUADROT
		STODL	BRATE	
			AM
		DMP	DDV*
			ANGLTIME
			ARATE,1
		SR
			5
		STORE	TM
		BON	VLOAD
			CYC61FLG
			RCYCLR61
			BRATE
		VXSC
			BIASCALE
		STORE	BIASTEMP	# ATTITUDE ERROR BIAS TO PREVENT OVERSHOOT
					# IN SYSTEM
		SETGO			# STATE SWITCH CALCMAN2 (43D)
			CALCMAN2	# 0(OFF) = BYPASS STARTING PROCEDURE
			NEWANGL +1	# 1(ON) = START MANEUVER
			
			
ARATE		2DEC	.0022222222	# = .05 DEG/SEC
		2DEC	.0088888889	# = .2 DEG/SEC
		2DEC	.0222222222	# = .5 DEG/SEC
		2DEC	.0888888889	# = 2 DEG/SEC                $22.5 DEG/SEC
ANGLTIME	2DEC	.000190735	# = 100B - 19
					# MANEUVER ANGLE TO MANEUVER TIME
QUADROT		2DEC	.1		# ROTATION MATRIX FROM S/C AXES TO CONTROL
		2DEC	0		# AXES (X ROT = -7.25 DEG)
		2DEC	0
		2DEC	0
		2DEC	.099200		# =(.1)COS7.25
		2DEC	-.012620	# =-(.1)SIN7.25
		2DEC	0
		2DEC	.012620		# (.1)SIN7.25
		2DEC	.099200		# (.1)COS7.25
BIASCALE	2DEC	.0002543132	# = (450/180)(1/0.6)(1/16384)
