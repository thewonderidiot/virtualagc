# Copyright:	Public domain.
# Filename:	Makefile
# Purpose:	Makefile for Sundial E.
# Contact:	Ron Burkey <info@sandroid.org>.
# Website:	www.ibiblio.org/apollo/index.html
# Mod history:	2019-07-23 RSB	So far we have no source code, so 
#				this is just an empty shell right now.

BASENAME=SundialE

EXTRA_TARGETS=diffSundialE.txt checkSundialE

NO_BINSOURCE=yes
EXTRA_YAYUL_ARGS+=--blk2 --early-sbank --parity

include ../Makefile.inc

diffSundialE.txt: ../Tools/bdiffhead $(BASENAME).bin
	../Tools/bdiffhead SundialE_dump.bin $(BASENAME).bin | tail -n+3 > $@

.PHONY: checkSundialE
checkSundialE: diffSundialE.txt
	cat $< | wc -l
