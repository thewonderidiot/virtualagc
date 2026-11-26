### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	INTERRUPT_TRANSFER_ROUTINES.agc
## Purpose:	Part of a work-in-progress reconstruction of the source
##		code for Solarium build 54, the original release of the
##		Command Module's (CM) Apollo Guidance Computer (AGC)
##		software for Apollo 4. It was created from Solarium 55.
##		Changes related to the scaling issue were then backed out,
##		matching Corona 261.
## Assembler:	yaYUL --block1
## Contact:	Jim Lawton <jim DOT lawton AT gmail DOT com>
## Website:	www.ibiblio.org/apollo/index.html
## Page Scans:	www.ibiblio.org/apollo/ScansForConversion/Solarium055/
## Mod history:	2026-11-25 MAS	Created from Solarium 55.

## Page 35
		SETLOC	2000

		TS	ARUPT
		XCH	Q
		XCH	QRUPT
		TC	T3RUPT

		TS	ARUPT
		XCH	Q
		XCH	QRUPT
		TC	ERRUPT

		TS	ARUPT
		XCH	Q
		XCH	QRUPT
		TC	T4RUPT		# OUTPUT CONTROL.

		TS	ARUPT
		XCH	Q
		XCH	QRUPT
		TC	KEYRUPT

		TS	ARUPT
		XCH	Q
		XCH	QRUPT
		TC	UPRUPT

		TS	ARUPT
		XCH	Q
		XCH	QRUPT
		TC	DOWNRUPT	# DOWNLINK.

		INHINT			# GOJAM - PARITY ALARM, POWER FAIL, ETC.
		CAF	EXECBANK

		TS	BANKREG
		TC	GOPROG

## Page 36
ERRUPT		TC	ALARM		# ***NO ERRUPTS IN SYSTEM 5***
		OCT	01101
		TC	NBRESUME

UPRUPT		CAF	UPBANK		# CALL IN BANK WITH UPRUPT PROGRAM.
		XCH	BANKREG
		TC	UPRUPTB

KEYRUPT		CAF	MODEBANK
		XCH	BANKREG
		TC	KEYRUPTA

MODEBANK	CADR	KEYRUPTA
