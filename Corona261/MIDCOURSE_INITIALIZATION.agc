### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	MIDCOURSE_INITIALIZATION.agc
## Purpose:	A section of Corona revision 261.
##		It is part of the source code for the Apollo Guidance Computer
##		(AGC) for AS-202. No original listings of this software are
##		available; instead, this file was created via disassembly of
##		the core rope modules actually flown on the mission.
## Assembler:	yaYUL
## Contact:	Ron Burkey <info@sandroid.org>.
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2023-05-27 MAS  Created from Solarium 55.

		BANK	13

U13,6717	TC	GRABDSP
		TC	PREGBSY

## Zero everything between DELTAV and DELVEL +5
		CS	U13,7010
		AD	U13,7011

U13,6723	TS	UNK1302
		CAF	ZERO
		INDEX	UNK1302
		TS	DELTAV
		CCS	UNK1302
		TC	U13,6723

## Set SXT-ON flag in WASOPSET
		CAF	BIT13
		TS	WASOPSET

## Clear MIDFLAG and MOONFLAG
		CS	MINITMSK
		MASK	STATE
		TS	STATE

## Ask user to load DELR
		CAF	VN2572
		TC	NVSUB
		TC	PRENVBSY
		TC	DATAWAIT
		TC	U13,7006
		TC	+1

## Ask user to load DELVEL
		CAF	VN2573
		TC	NVSUB
		TC	PRENVBSY
		TC	DATAWAIT
		TC	U13,7006
		TC	+1

## Initialize REFSMMAT to hardcoded initial values
		CAF	U13,7012
U13,6753	TS	UNK1302
		INDEX	UNK1302
		CAF	U13,7133
		INDEX	UNK1302
		TS	REFSMMAT
		CCS	UNK1302
		TC	U13,6753

## Initialize TE and TET with hardcoded initial value
		CAF	U13,7021
		TS	TE
		TS	TET
		CAF	U13,7021 +1
		TS	TE +1
		TS	TET +1

## Initialize scales with initial values
		CAF	U13,7014
		TS	SCALEDT
		CAF	FOUR
		TS	SCALDELT
		CAF	U13,7013
		TS	SCALER

## Initialize W to hardcoded initial values
		CAF	U13,7015
U13,6777	TS	UNK1302
		INDEX	UNK1302
		CAF	U13,7023
		INDEX	UNK1302
		TS	W
		CCS	UNK1302
		TC	U13,6777

## Back to MNG when done. TERMINATE on the load VERBs sends you straight back.
U13,7006	TC	BANKCALL
		CADR	U24,6013

U13,7010	ADRES	DELTAV
U13,7011	ADRES	DELVEL +5
U13,7012	DEC	17
U13,7013	DEC	14
U13,7014	DEC	18
U13,7015	DEC	71
MINITMSK	OCT	30000
VN2572		OCT	02572
VN2573		OCT	02573
U13,7021	2DEC	.077494159

U13,7023	2DEC	.125
		2DEC	0
		2DEC	0

		2DEC	0
		2DEC	.125
		2DEC	0

		2DEC	0
		2DEC	0
		2DEC	.125

		2DEC	0
		2DEC	0
		2DEC	0

		2DEC	0
		2DEC	0
		2DEC	0

		2DEC	0
		2DEC	0
		2DEC	0

		2DEC	0
		2DEC	0
		2DEC	0

		2DEC	0
		2DEC	0
		2DEC	0

		2DEC	0
		2DEC	0
		2DEC	0

		2DEC	.051901456
		2DEC	0
		2DEC	0

		2DEC	0
		2DEC	.051901456
		2DEC	0

		2DEC	0
		2DEC	0
		2DEC	.051901456

U13,7133	2DEC	-.326527826
		2DEC	-.378503058
		2DEC	.010724388
		2DEC	-.209651023
		2DEC	.168924633
		2DEC	-.421320442
		2DEC	.315318927
		2DEC	-.279642455
		2DEC	-.269024294
