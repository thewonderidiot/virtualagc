### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	P50,P55.agc
## Purpose:	A section of Skylark revision 048.
##		It is part of the source code for the Apollo Guidance Computer
##		(AGC) for Skylab-2, Skylab-3, Skylab-4, and ASTP. No original
##		listings of this software are available; instead, this file was
##		created via disassembly of the core rope modules actually flown
##		on Skylab-2.
## Assembler:	yaYUL
## Contact:	Ron Burkey <info@sandroid.org>.
## Website:	www.ibiblio.org/apollo/index.html
## Mod history:	2024-02-18 MAS  Created.
		SETLOC	P50LOC
		BANK
		EBANK=	MRKBUF1

P50		CAF	ONE
		TS	OPTION2

		CAF	OCT12
		TC	BANKCALL
		CADR	GOPERF4
		TC	GOTOPOOH
		TCF	+2
		TCF	P50 +2

		CA	OPTION2
		MASK	THREE
		INDEX	A
		TCF	+1
		TCF	+4
		TCF	P50.1
		TCF	P50.2
		TCF	P50.3

		TC	FALTON
		TCF	P50 +2

P50.1		TC	UPFLAG
		ADRES	P50.1FLG

P50.2		TC	BANKCALL
		CADR	R02BOTH

		CAF	ZERO
		TS	STARIND

		CAF	OCT46
		TS	STARCODE

		TC	INTPRET
		CALL
			R53
		VLOAD
			MRKBUF1 +2
		STODL	CDUSPOT
			MRKBUF1
		STCALL	TSIGHT
			PLANET
		MXV	UNIT
			REFSMMAT
		CALL
			TRG*SMNB
		STOVL	12D
			VSUN
		MXV	UNIT
			REFSMMAT
		CALL
			*SMNB*
		STORE	6D
		BON	CALL
			P50.1FLG
			P50.1A
			OASTAR
		STCALL	STARAD +6
			P50GEN

P50.1A		VLOAD
			YUNIT
		STOVL	STARAD +6
			NBOA +6
		STORE	12D

P50GEN		VLOAD
			ZUNIT
		STCALL	STARAD
			AXISGEN
		AXC,1	AXC,2
			XDC
			XSM
		GOTO
			OAVECS

P50.3		TC	INTPRET
		CALL
			U11,2421
		AXC,1	AXC,2
			NBOA
			XSM

OAVECS		CALL
			MATMOVE
		SET	VLOAD
			P50FLAG
			XUNIT
		STOVL	XDC
			YUNIT
		STOVL	YDC
			ZUNIT
		STCALL	ZDC
			CALCGA
		TLOAD
			THETAD
		STORE	N23TEMP
		EXIT

		TC	U11,2370

		CAF	V06N23
		TC	BANKCALL
		CADR	GOFLASH
		TC	GOTOPOOH
		TCF	DOVECS
		TCF	-5

DOVECS		TC	U11,2370

		TC	INTPRET
		TLOAD	DCOMP
			N23TEMP
		TAD	BZE
			THETAD
			P50OUT
		EXIT

		CA	THETAD
		TS	CDUSPOT +4
		CA	THETAD +1
		TS	CDUSPOT
		CA	THETAD +2
		TS	CDUSPOT +2

		TC	INTPRET
		CALL
			CD*TR*G
		CALL
			CALCSMSC
		VLOAD	MXV
			YUNIT
			XDC
		UNIT
		STOVL	YSM
			ZUNIT
		MXV	UNIT
			XDC
		STORE	ZSM

P50OUT		AXC,1	AXC,2
			XSM
			NBOA
		CALL
			MATMOVE
		EXIT

		TC	GOTOPOOH

U11,2370	CAF	NEGMAX
		EXTEND
		MSU	THETAD
		TS	THETAD
		TC	Q

OASTAR		SETPD	SLOAD
			0
			MRKBUF1 +5
		RTB	PUSH
			CDULOGIC
		SIN	DCOMP
		PDDL	COS
		STADR
		STODL	4
			MRKBUF1 +3
		RTB	PUSH
			CDULOGIC
		COS	DMP
			4
		DCOMP	SL1
		PDDL	SIN
		DMP	SL1
			4
		VDEF	UNIT
		RVQ

U11,2421	VLOAD	VXV
			NBOA +6
			NBOA +12D
		UNIT
		STORE	NBOA
		RVQ

V06N23		VN	0623

		SETLOC	P55LOC
		BANK
		EBANK=	MRKBUF1

P55		CAF	ONE
		TS	OPTION2

		CAF	OCT13
		TC	BANKCALL
		CADR	GOPERF4
		TC	GOTOPOOH
		TCF	+2
		TCF	-5

		CA	OPTION2
		MASK	THREE
		INDEX	A
		TCF	+1
		TCF	+3
		TCF	P55.1
		TCF	P55.2

		TC	FALTON
		TCF	P55 +2

P55.2		CAF	ZERO
		TS	STARIND

		CAF	OCT46
		TS	STARCODE

		TC	INTPRET
		CALL
			R53
		DLOAD	CALL
			MRKBUF1
			PLANET
		STOVL	12D
			VSUN
		STCALL	6D
			U11,2421
		AXC,1	CALL
			MRKBUF1
			SXTNB
		MXV	UNIT
			NBOA
		STOVL	STARAD +6
			ZUNIT
		STCALL	STARAD
			AXISGEN
		EXIT

		TCF	TRKSTAR

P55.1		TC	BANKCALL
		CADR	R02BOTH

		TC	UPFLAG
		ADRES	P55.1FLG

TRKSTAR		CAF	V01N70
		TC	BANKCALL
		CADR	GOFLASH
		TC	GOTOPOOH
		TCF	+2
		TCF	TRKSTAR

		CCS	STARCODE
		TCF	U07,2404
		TCF	U07,2410
		NOOP
U07,2402	TC	FALTON
		TCF	TRKSTAR

U07,2404	AD	NEG46
		EXTEND
		BZMF	U07,2410
		TCF	U07,2402

U07,2410	TC	INTPRET
		RTB	CALL
			LOADTIME
			PLANET
		BON	MXV
			P55.1FLG
			P55.1A
			XDC
		UNIT	GOTO
			P55GIMS

P55.1A		MXV	UNIT
			REFSMMAT
		STCALL	STARSAV1
			U11,2421
		VLOAD	CALL
			STARSAV1
			CDU*SMNB
		MXV	UNIT
			NBOA

P55GIMS		STODL	STARSAV1
			ZERODP
		PDDL	PDDL
			STARSAV1 +2
			STARSAV1
		VDEF	UNIT
		STOVL	STARSAV2
			YUNIT
		VCOMP	DOT
			STARSAV2
		STOVL	COSTH
			STARSAV2
		DOT
			XUNIT
		STCALL	SINTH
			ARCTRIG
		STOVL	TRKAZ
			STARSAV2
		DOT
			STARSAV1
		STOVL	COSTH
			ZUNIT
		VCOMP	DOT
			STARSAV1
		STCALL	SINTH
			ARCTRIG
		STORE	TRKEL
		EXIT

		CCS	TRKAZ
		AD	-87DEG
		TCF	+2
		TCF	-2
		EXTEND
		BZMF	+2
		TCF	U07,2504

		CCS	TRKEL
		AD	-40DEG
		TCF	+2
		TCF	-2
		EXTEND
		BZMF	N14DISP

U07,2504	TC	ALARM
		OCT	00107

N14DISP		CA	VB06N14
		TC	BANKCALL
		CADR	GOFLASH
		TC	GOTOPOOH
		TCF	+2
		TCF	TRKSTAR

		CCS	TRKAZ
		AD	ONE
		TCF	+2
		TCF	-2
		EXTEND
		MP	D21600

		LXCH	TRKAZOCT +1
		EXTEND
		MP	BIT12
		TS	TRKAZOCT
		LXCH	TRKAZOCT +1
		CA	L
		MASK	PRIO34
		EXTEND
		MP	BIT12
		AD	TRKAZOCT +1
		EXTEND
		MP	BIT10
		TS	TRKAZOCT +1
		CS	TRKAZ
		EXTEND
		BZMF	+3
		CAF	BIT10
		ADS	TRKAZOCT

		CAF	V04N19
		TC	BANKCALL
		CADR	GOFLASH
		TC	GOTOPOOH
		TCF	GOTOPOOH
		TCF	TRKSTAR

-40DEG		DEC	-.111111
-87DEG		DEC	-.241666
VB06N14		VN	0614
V04N19		VN	0419
D21600		DEC	21600 B-17
NEG46		OCT	-46
