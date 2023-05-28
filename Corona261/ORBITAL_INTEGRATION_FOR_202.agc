### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	ORBITAL_INTEGRATION_FOR_501.agc
## Purpose:	Part of the source code for Solarium build 55. This
##		is for the Command Module's (CM) Apollo Guidance
##		Computer (AGC), for Apollo 6.
## Assembler:	yaYUL --block1
## Contact:	Jim Lawton <jim DOT lawton AT gmail DOT com>
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2009-09-22 JL	Created.
##		2009-09-22 JL	Fixed typo.
##		2009-10-30 JL	Fixed filename comment.
## 		2016-12-28 RSB	Proofed comment text using octopus/ProoferComments,
##				and fixed errors found.


		SETLOC	60000

AVETOMD1	AXC,1	2
		ITA	SXA,1
		ITC
			1
			MIDEXIT
			MEASMODE
			AVETOMID

AVETOMD2	AXC,1	1
		ITA	SXA,1
			2
			MIDEXIT
			MEASMODE

AVETOMID	VMOVE	6
		AXT,1	SXA,1
		AXT,1	SXA,1
		AXT,1	SXA,1
		AXT,1	SXA,1
		AXT,1	SXA,1
		AXT,1	SXA,1
			ZEROVEC
			0
			WMATFLAG	# TURN OFF WMATRIX INTEGRATION.
			RSCALE
			SCALER		# SET SCALE OF POSITION.
			4
			SCALDELT	# ALSO DEVIATION.
			18D
			SCALEDT		# AND TIME STEP.
			TESTVEC1	## 202 FIXME
			PBODY
			TESTTET
			STEPEXIT
		STORE	TDELTAV		# ZERO POSITION DEVIATION.

		NOLOD	0
		STORE	TNUV		# ALSO VELOCITY.

		NOLOD	0		# AND TIME SINCE RECTIFICATION, TIME, 
		STORE	TC		# AND KEPLER X.
		AXT,1	1
## 202 ???: Added EXIT
		AST,1	EXIT
			12D
			6

## 202 ???: Added STATE setting
		CS	INITMSK
		MASK	STATE
		TS	STATE
		TC	INTPRET

RVTOMID		VXSC*	1		# TRANSFORM POSITION AND VELOCITY TO
		VXM	VSLT
			RRECT +12D,1
			SCLRAVMD +12D,1
			REFSMMAT
			2
		STORE	RRECT +12D,1

		NOLOD	0
		STORE	RCV +12D,1

		TIX,1	0
			RVTOMID

## 202 ???: Changed this equation from a simple DMOVE
		DMP	1
		TSLT
			TAVEGON
			SCLTAVMD ## FIXME
			3
		STORE	TDEC


## 202 ???: Removed EXIT 0, TC INTPRET
TESTTET		LXC,1	1
		AST,1	TIX,1
			MEASMODE
			1
			+3

		ITC	0
			+4

		TEST	0
			UPDATFLG
			NOSTATE

		STZ	0
			OVFIND

## 202 ???: Removed RTB SGNAGREE, changed shift from 11D to 9D
		DSU	1
		TSLT	DDV
			TDEC
			TET
			9D
			EARTHTAB
		STORE	DT/2

		BOV	3
		ABS	DSU
		BMN	DAD
		DSU	BMN
			USEMAXDT
			DT/2
			DT/2MIN
			DODCSION
			DT/2MIN
			DT/2MAX
			TIMESTEP

USEMAXDT	DMOVE	1
		SIGN
			DT/2MAX
			DT/2
		STORE	DT/2

		ITC	0
			TIMESTEP


DODCSION	ITC	0		# RECTIFY TO OBTAIN FULL POSITION
			RECTIFY		# AND VELOCUTY VECTORS.

		SMOVE	1
		BMN	BZE
			MEASMODE	# TEST MEASMODE.
			AVEGON		# MEASMODE = -1.
			IGN-4SEC	# MEASMODE = 0.

		AXT,1	1		# MEASMODE = +1.
		AST,1
			12D
			6

RVTOAVE		VXSC*	1		# TRANSFORM POSITION AND VELOCITY VECTORS
		MXV	VSLT
			RRECT +12D,1
			SCLRMDAV +12D,1
			REFSMMAT
			1
		STORE	RIGNTION +12D,1

		VXSC*	1
		MXV	VSLT
			RAVEGON +12D,1
			SCLRMDAV +12D,1
			REFSMMAT
			1
		STORE	RAVEGON +12D,1

		TIX,1	0
			RVTOAVE

		ITCI	0
			MIDEXIT		# RETURN. 


AVEGON		VMOVE	0		# SAVE POSITION AND VELOCITY AT
			RRECT		# AVERAGE G ON TIME.
		STORE	RAVEGON

		VMOVE	0
			VRECT
		STORE	VAVEGON

		LXC,1	1
		AST,1	TIX,1
			MEASMODE
			1
			RVTOAVE -4

		DAD	1
		AXT,1	SXA,1
			TDEC
			12M56S		# 12 MINUTES, 56 SECS
			0
			MEASMODE	# MAKE MEASMODE 0.
		STORE	TDEC

		ITC	0
			TESTTET		# CONTINUE INTEGRATION.



IGN-4SEC	VXSC	1		# TRANSFORM AND SAVE POSITION ONLY
		MXV	VSLT
			RRECT
			SCLRMDAV
			REFSMMAT
			1
		STORE	RIG-4SEC

		DAD	1
		AXT,1	SXA,1
			TDEC
			4SECONDS	# ADD 4 SECONDS TO DECISION TIME.
			1
			MEASMODE	# MAKE MEASMODE +1.
		STORE	TDEC

		ITC	0
			TESTTET		# DO LAST INTEGRATION STEP.

12M56S		2DEC	11540		## FIXME
4SECONDS	2DEC	1775		## FIXME
## 202 ???: Moved DT/2MIN and DT/2MAX elsewhere
INITMSK		OCT	30000
