### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	LATITUDE-LONGITUDE_SUBROUTINES.agc
## Purpose:	A section of Corona revision 261.
##		It is part of the source code for the Apollo Guidance Computer
##		(AGC) for AS-202. No original listings of this software are
##		available; instead, this file was created via disassembly of
##		the core rope modules actually flown on the mission.
## Assembler:	yaYUL
## Contact:	Ron Burkey <info@sandroid.org>.
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2023-05-27 MAS  Created from Solarium 55.

		BANK	31

U31,6000	ITA	0
			STEPEXIT

		ITC	0
			RECTIFY

		ITC	0
			KEPLER

		VXV	1
		AXT,2	UNIT
			UNITZ
			RRECT
			10D
		STORE	UNE

		VXV	1
		AST,2	UNIT
			UNITZ
			UNE
			1
		STORE	UNP

		DMOVE	1
		ITC
			TET
			U31,6175

		NOLOD	1
		BDSU	DDV
			LONGDES
			15/16
		STORE	DLONG

		ITC	0
			U31,6372

U31,6035	COS	1
		VXSC
			DLONG
			UNE

		SIN	1
		VXSC	VAD
			DLONG
			UNP

		VXV	1
		VXV	UNIT
			VRECT
			RRECT

		UNIT	2
		VSLT	DOT
		DAD	SQRT
			RRECT
			1
			-
			DP1/2

U31,6060	DSQ	2
		BDSU	DAD
		SQRT
			14D
			DP1/2
			DP1/2

		NOLOD	1
		DMPR
			ALPHAM
		STORE	VACZ
		
		DMPR	1
		BDSU	DMPR
			MEASQ
			-
			-
			HMAG
		STORE	VACX

		RTB	0
			ARCTAN

		ITC	0
			U31,6160

		LXA,1	1
		INCR,1	SXA,1
			FIXLOC
			14D
			PUSHLOC

		DMP	2
		TSRT	ROUND
		DAD
			18D
			EARTHTAB
			4
			TE
		STORE	TDEC

		EXIT	0

		CS	FFFLAGS
		MASK	U31,7445
		CCS	A
		TC	+4

		TC	INTPRET
		ITC	0
			U31,6671

		TC	INTPRET
		ITC	0
			U31,6175

		NOLOD	1
		BDSU	DDV
			LONGDES
			15/16

		NOLOD	2
		ABS	DSU
		BMN	TIX,2
			U31,6422
			+2
			U31,6153

		STZ	0
			GMODE

		ITCI	0
			STEPEXIT

U31,6153	DAD	0
			DLONG
		STORE	DLONG

		ITC	0
			U31,6035

U31,6160	NOLOD	2
		DMPR	DMPR
		DDV
			6
			PI/4.0
			ALPHAM
		STORE	XKEP

		ITA	0
			HBRANCH

		ITC	0
			KTIMEN+1

		ITC	0
			GETRANDV

U31,6175	NOLOD	0
		STORE	LONG

		ITA	0
			INCORPEX

		STZ	0
			OVFIND

		ITC	0
			U31,6327

		NOLOD	0
		STORE	DELR

		DSQ	0
			DELR

		DSQ	2
		DAD	SQRT
		DMPR
			DELR +2
			-
			U31,6420
		STORE	VACX

		DMOVE	0
			DELR +4
		STORE	VACZ

		RTB	0
			ARCTAN
		STORE	LAT

		DSU	2
		DMP	TSLT
		STZ	ROUND
			LONG
			U31,6424
			U31,7402
			3
			OVFIND
		STORE	DELVEL

		COS	0
			DELVEL
		STORE	DELVEL +4

		SIN	0
			DELVEL
		STORE	DELR +4

		DMPR	0
			DELR
			DELVEL +4

		DMPR	1
		DAD
			DELR +2
			DELR +4
		STORE	VACX

		DMPR	0
			DELR
			DELR +4

		DMPR	1
		DSU
			DELR +2
			DELVEL +4
		STORE	VACZ

		RTB	0
			ARCTAN
		STORE	LONG

		ITCI	0
			INCORPEX

U31,6272	ITA	0
			MIDEXIT

		ITC	0
			U31,6327

		NOLOD	0
		STORE	DELR

		ITC	0
			U31,6334

		NOLOD	0
		STORE	DELVEL

		RTB	0
			FRESHPD

		VXV	1
		VXV	UNIT
			DELR
			UNITZ
			DELR

		VXV	3
		VXV	UNIT
		DOT	TSLT
		ACOS
			DELR
			DELVEL
			DELR
			-
			1
		STORE	AZ
		
		ITCI	0
			MIDEXIT

U31,6327	VSRT	1
		VAD	ITCQ
			TDELTAV
			10D
			RCV

U31,6334	VSRT	1
		VAD	ITCQ
			TNUV
			8D
			VCV

GETERAD		ITA	0
			MIDEXIT

		ABVAL	4
		TSLT	BDDV
		DSQ	TSRT
		BDSU	DMPR
		BDSU	BDDV
			DELR
			1
			ALPHAV +4
			1
			DP1/2
			EE
			DP1/2
			B2XSC
		STORE	ERADSQ/4

		NOLOD	1
		SQRT
		STORE	ERAD/2

		ITCI	0
			MIDEXIT

U31,6366	ITC	0
			U31,6372

		ITC	0
			U31,6060

U31,6372	VXV	1
		ABVAL	TSLT
			RRECT
			VRECT
			1
		STORE	HMAG

		SQRT	1
		DMP
			10D
			6
		STORE	ALPHAM

		DOT	1
		DDV
			RRECT
			VRECT
			HMAG
		STORE	MEASQ

		ITCQ	0

EE		2DEC	6.69342279 E-3
B2XSC		2DEC	0.01881677
U31,6420	2DEC	0.993306577
U31,6422	2DEC	3 E-5
U31,6424	2DEC	.01
