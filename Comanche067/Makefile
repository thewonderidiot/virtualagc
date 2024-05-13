# Copyright:	Public domain.
# Filename:	Makefile
# Purpose:	Makefile for Comanche 067.
#		The source code for the Command Module's (CM) Apollo
#		Guidance Computer (AGC) for Apollo 12. It has been
#		reconstructed from a listing of Comanche 067 and dumps
#		of a complete set of core rope memory modules.
# Contact:	Ron Burkey <info@sandroid.org>.
# Website:	http://www.ibiblio.org/apollo
# Mod history:	2023-08-16 MAS	Created from Comanche 55.

BASENAME=Comanche067

EXTRA_YAYUL_ARGS+=--parity
NO_BINSOURCE=yes
EXTRA_TARGETS=diffComanche067

include ../Makefile.inc

.PHONY: diffComanche067
diffComanche067:
	diff -s Comanche067.bin Comanche067-dump.bin
