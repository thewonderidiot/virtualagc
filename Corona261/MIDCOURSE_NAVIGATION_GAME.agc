		BANK	24

U24,6000	INDEX	MPAC
		TC	+1
		TC	ENDMID
		TC	U24,6041
		TC	U24,6041
		TC	U24,6041
		TC	U24,6041
		TC	U24,6041
		TC	ENDMID

		TC	BANKCALL
		CADR	U13,6717

U24,6013	TC	INTPRET
		AXT,1	2
		SXA,1	AXT,1
		SXA,1
			TESTVEC1
			PBODY
			U24,6315
			STEPEXIT

		VAD	0
			U24,7433
			DELR
		STORE	REFRRECT

		NOLOD	0
		STORE	REFRCV

		VAD	0
			U24,7441
			DELVEL
		STORE	REFVRECT

		NOLOD	0
		STORE	REFVCV

		EXIT	0

		TC	ENDMID

U24,6041	CS	ONE
		AD	MPAC
		TS	UNK1302

		TC	BANKCALL
		CADR	MKRELEAS

		CAF	U24,6434
		MASK	FFFLAGS
		INDEX	UNK1302
		AD	U24,6273
		TS	FFFLAGS

U24,6053	TC	PHASCHNG
		OCT	01101
		TC	ENDMID
		TC	MIDSTCHK

U24,6057	CAF	ONE
		TS	NUMBOPT

		TC	MIDGRAB

		CAF	U24,7010
		MASK	FFFLAGS
		CCS	A
		TC	U24,6117

		CAF	U24,6262
		MASK	FFFLAGS
		CCS	A
		TC	U24,6174

U24,6072	CAF	VB21N32
		TC	NVSUB
		TC	PRENVBSY
		TC	DATAWAIT
		TC	ENDMID
		TC	U24,6072

		TC	U24,7232

		TC	INTPRET

		DMPR	0
			TDEC
			U24,6115
		STORE	LONGDES

		ITC	0
			U31,6000

		DMOVE	0
			TDEC
		STORE	TET

		ITC	0
			U24,7042

U24,6115	2DEC	125269880	## FIXME

U24,6117	CAF	SITEADR
		TS	MPAC +2
		CAF	VB21N02
		TC	NVSUB
		TC	PRENVBSY
		TC	DATAWAIT
		TC	ENDMID
		TC	U24,6117

		CAF	U24,6223
		MASK	SITENUMB
		INDEX	A
		TC	+1
		TC	U24,6117
		TC	U24,6146
		TC	U24,6146
		TC	U24,6146
		TC	U24,6153
		TC	U24,6143
		TC	U24,6117
		TC	U24,6117

U24,6143	CAF	TWO
		TS	NUMBOPT
		TC	U24,6651

U24,6146	CAF	U24,7343
		MASK	SITENUMB
		CCS	A
		TC	U24,6644
		TC	U24,6651

U24,6153	CAF	FIVE
		TS	NUMBOPT

		CAF	VB25N72
		TC	NVSUB
		TC	PRENVBSY
		TC	DATAWAIT
		TC	ENDMID
		TC	U24,6651

		TC	FFFLGUP
		OCT	01001

		CAF	V21N32
		TC	NVSUB
		TC	PRENVBSY
		TC	DATAWAIT
		TC	ENDMID
		TC	U24,6651

		TC	U24,6644

U24,6174	CAF	V21N32
		TC	NVSUB
		TC	PRENVBSY
		TC	DATAWAIT
		TC	ENDMID
		TC	U24,6174

U24,6202	TC	PHASCHNG
		OCT	01201
		TC	ENDMID
		TC	MIDSTCHK

		TC	U24,6225

U24,6207	TC	FFFLGDWN
		OCT	04000

U24,6211	CS	FFFLAGS
		MASK	U24,6743
		CCS	A
		TC	U24,6225

		CAF	U24,6223
		MASK	SITENUMB
		EXTEND
		SU	THREE
		CCS	A
		TC	ENDMID
U24,6223	OCT	00007
		TC	+1

U24,6225	CS	FFFLAGS
		MASK	U24,6701
		CCS	A
		TC	U24,6300

		CAF	U24,6572
		MASK	FFFLAGS
		CCS	A
		TC	U24,6307

		CAF	U24,7010
		MASK	FFFLAGS
		CCS	A
		TC	U24,6250

		TC	MIDGRAB

		INHINT
		CAF	PRIO6
		TC	NOVAC
		CADR	U24,6454
		RELINT

		TC	U24,6307

U24,6250	CS	FFFLAGS
		MASK	U24,6743
		CCS	A
		TC	U24,6304

		CAF	U24,6223
		MASK	SITENUMB
		EXTEND
		SU	THREE
		CCS	A
		TC	U24,6302

U24,6262	CCS	A
		TC	+1
		TC	MIDGRAB

		INHINT
		CAF	PRIO6
		TC	NOVAC
		CADR	U24,6514
		RELINT

		TC	U24,6307

U24,6273	OCT	12000
		OCT	10000
		OCT	12240
		OCT	12040
		OCT	00000

U24,6300	CAF	ZERO
		TS	NUMBOPT

U24,6302	TC	FFFLGUP
		OCT	00010

U24,6304	TC	FREEDSP
		TC	FFFLGDWN
		OCT	00001

U24,6307	CAF	U24,6610
		MASK	FFFLAGS
		CCS	A
		TC	U24,6611
		TC	U24,7232

		TC	+2

U24,6315	EXIT	0

		CAF	U24,6343
		MASK	FFFLAGS
		CCS	A
		TC	U24,6207

		CAF	U24,6723
		MASK	FFFLAGS
		CCS	A
		TC	+4

		CAF	ZERO
		TS	WMATFLAG
		TC	U24,6353

		CAF	ONE
		TS	WMATFLAG
		TC	U24,6353

U24,6334	EXIT	0

		TC	PHASCHNG
		OCT	01601
		TC	ENDMID
		TC	MIDSTCHK
		TC	+3

U24,6342	TC	FFFLGUP
U24,6343	OCT	04000

		TC	U24,7216

		TC	PHASCHNG
		OCT	01201
		TC	+2
		TC	+1

		TC	INTPRET
		ITCQ	0

U24,6353	TC	INTPRET
		BMN	0
			TDEC
			U24,7042

		STZ	0
			OVFIND

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
			U24,6403
			DT/2
			DT/2MIN
			U24,6606
			DT/2MIN
			DT/2MAX
			TIMESTEP

U24,6403	DMOVE	1
		SIGN
			DT/2MAX
			DT/2
		STORE	DT/2

		ITC	0
			TIMESTEP

ENDMID		TC	FREEDSP
		TC	FFFLGDWN
		OCT	00001

		TC	BANKCALL
		CADR	MKRELEAS

		CS	ONE
		TC	NEWPHASE
		OCT	1

		TC	ENDOFJOB

MIDGRAB		XCH	Q
		TS	MIDEXIT

		CAF	U24,6434
		MASK	FFFLAGS
		CCS	A
		TC	MIDEXIT

		TC	GRABDSP
		TC	PREGBSY

		TC	FFFLGUP
U24,6434	OCT	00001

		TC	MIDEXIT

FFFLGUP		INDEX	Q
		CS	0
		MASK	FFFLAGS
		INDEX	Q
		AD	0
		TS	FFFLAGS
		INDEX	Q
		TC	1

FFFLGDWN	INDEX	Q
		CS	0
		MASK	FFFLAGS
		TS	FFFLAGS
		INDEX	Q
		TC	1

U24,6454	CAF	SITEADR
		TS	MPAC +2

		CAF	VB21N02
		TC	NVSUB
		TC	PRENVBSY
		TC	DATAWAIT
		TC	U24,6600
		TC	U24,6603

		CAF	U24,7344
		MASK	SITENUMB
		EXTEND
		SU	U24,6472
		CCS	A
		TC	U24,6454
U24,6472	DEC	3
		TC	+1

		CCS	SITENUMB
		TC	U24,6505
		TC	U24,6600
		TC	+2
		TC	U24,6600

		CAF	V21N34
		TC	NVSUB
		TC	PRENVBSY
		TC	+4
U24,6505	CAF	VB21N34
		TC	NVSUB
		TC	PRENVBSY
		TC	DATAWAIT
		TC	U24,6600
		TC	U24,6603

		TC	U24,6553

U24,6514	CAF	SITEADR
		TS	MPAC +2
		CAF	VB21N02
		TC	NVSUB
		TC	PRENVBSY
		TC	DATAWAIT
		TC	U24,6600
		TC	U24,6603

		CAF	U24,6223
		MASK	SITENUMB
		INDEX	A
		TC	+1
		TC	U24,6514
		TC	U24,6540
		TC	U24,6540
		TC	U24,6540
		TC	U24,6553
		TC	U24,6553
		TC	U24,6514
		TC	U24,6514

U24,6540	CAF	U24,7343
		MASK	SITENUMB
		CCS	A
		TC	+2
		TC	U24,6514

		EXTEND
		SU	U24,6551
		CCS	A
		TC	U24,6514
U24,6551	OCT	00760
		TC	+1

U24,6553	TC	INTPRET

		DSU	2
		ABS	DSU
		BMN
			TDEC
			TET
			DT/2MIN
			U24,6570

		EXIT	0

		TC	FREEDSP

		TC	FFFLGDWN
		OCT	00001

		TC	+2

U24,6570	EXIT	0

		TC	FFFLGUP
U24,6572	OCT	00010

		INHINT
		CAF	U24,6617
		TC	JOBWAKE
		RELINT

		TC	ENDOFJOB

U24,6600	TC	FFFLGUP
U24,6601	OCT	00002

		TC	U24,6553

U24,6603	TC	FFFLGUP
U24,6604	OCT	00004

		TC	U24,6553

U24,6606	EXIT	0

		TC	FFFLGUP
U24,6610	OCT	00020

U24,6611	CAF	U24,6572
		MASK	FFFLAGS
		CCS	A
		TC	U24,6620

		CAF	U24,6617
		TC	JOBSLEEP

U24,6617	CADR	U24,6620

U24,6620	CAF	U24,6701
		MASK	FFFLAGS
		CCS	A
		TC	U24,6627

U24,6624	CAF	ZERO
		TS	NUMBTEMP
		TC	U24,7042 +1

U24,6627	CAF	U24,6601
		MASK	FFFLAGS
		CCS	A
		TC	ENDMID

		CAF	U24,6604
		MASK	FFFLAGS
		CCS	A
		TC	U24,6624

		CS	FFFLAGS
		MASK	U24,7010
		CCS	A
		TC	U24,6762 +1
		TC	U24,6747

U24,6644	TC	PHASCHNG
		OCT	01701
		TC	ENDMID
		TC	MIDSTCHK

U24,6650	TC	+1

U24,6651	TC	PHASCHNG
		OCT	02001
		TC	ENDMID
		TC	MIDSTCHK

U24,6655	CAF	ZERO
		AD	NUMBOPT

		TC	BANKCALL
		CADR	SCTMARK

		TC	BANKCALL
		CADR	OPTSTALL
		TC	ENDMID

		INDEX	MARKSTAT
		CCS	QPRET
		TC	+2
		TC	ENDMID

		TS	NUMBOPT
		CCS	A
		TC	U24,6703

		CAF	U24,6223
		MASK	SITENUMB
		EXTEND
		SU	FOUR
		CCS	A
		TC	ENDMID
U24,6701	OCT	00040
		TC	+1

U24,6703	TC	INTPRET

		LXC,1	0
			MARKSTAT

		DMOVE*	1
		DMP	TSLT
			0,1
			SCLTAVMD
			3
		STORE	TDEC

		EXIT	0

		CAF	U24,6223
		MASK	SITENUMB
		EXTEND
		SU	THREE
		CCS	A
		TC	U24,6736
U24,6723	OCT	02000
		TC	+1
		TC	INTPRET

		SMOVE*	1
		RTB	RTB
			5,1
			CDULOGIC
			TRUNLOG
		STORE	MEASQ

		EXIT	0

		TC	+5

U24,6736	TC	INTPRET
		ITC	0
			U24,7165

		EXIT	0

		TC	FFFLGUP
U24,6743	OCT	00100

U24,6744	TC	FFFLGDWN
		OCT	00020

		TC	U24,6202

U24,6747	TC	INTPRET
		LXC,1	1
		VMOVE*
			MARKSTAT
			0,1
		STORE	VECTAB

		TEST	1
		SWITCH
			FIRSTFLG
			+2
			FIRSTFLG

U24,6762	EXIT	0

		TC	PHASCHNG
		OCT	01301
		TC	ENDMID
		TC	MIDSTCHK
		TC	U24,7012

U24,6770	CAF	ZERO
		TS	NUMBOPT

		CS	FFFLAGS
		MASK	U24,7010
		CCS	A
		TC	U24,7012

		CS	U24,6262
		MASK	FFFLAGS
		CCS	A
		TC	U24,7012

		CAF	U24,6223
		MASK	SITENUMB
		EXTEND
		SU	FOUR
		CCS	A
		TC	ENDMID
U24,7010	OCT	00200
		TC	+1

U24,7012	TC	INTPRET

		TEST	1
		ITC
			FIRSTFLG
			U31,6426
			U31,7236

U24,7020	EXIT	0

		TC	PHASCHNG
		OCT	01401
		TC	+4
		TC	+3

U24,7025	CAF	ZERO
		TS	NUMBOPT

		TC	U24,7216

		TC	INTPRET
		LXA,1	1
		SXA,1
			NUMBOPT
			NUMBTEMP

		TEST	1
		ITC
			FIRSTFLG
			+2
			U24,6762

U24,7042	EXIT	0

		TC	PHASCHNG
		OCT	01501
		TC	ENDMID
		TC	MIDSTCHK

		TC	MIDGRAB
		TC	+3

U24,7051	CAF	ZERO
		TS	NUMBTEMP

		CS	VB06N33
		TS	NVCODE
		TC	MIDDISP

		TC	INTPRET

		RTB	0
			FRESHPD

		DMOVE	1
		ITC
			TET
			U31,6175

		ITC	0
			U31,6272

		DMOVE	1
		RTB
			LAT
			1STO2S
		STORE	THETAD

		DMOVE	1
		RTB
			LONG
			1STO2S
		STORE	THETAD +1

		DMOVE	1
		RTB
			AZ
			1STO2S
		STORE	THETAD +2

		EXIT	0

		CS	VB06N22
		TS	NVCODE
		TC	MIDDISP

		TC	INTPRET

		VMOVE	0
			DELR
		STORE	DSPTEM1

		EXIT	0

		CS	VB06N76
		TS	NVCODE
		TC	MIDDISP

		TC	INTPRET

		VMOVE	0
			DELVEL
		STORE	DSPTEM1

		EXIT	0

		CS	VB06N77
		TS	NVCODE
		TC	MIDDISP

		CCS	NUMBTEMP
		TC	+2
		TC	ENDMID
		TS	NUMBOPT

		INDEX	MARKSTAT
		CS	QPRET
		AD	NUMBTEMP
		DOUBLE
		DOUBLE
		DOUBLE
		EXTEND
		MP	U24,7335
		EXTEND
		SU	MARKSTAT
		INDEX	FIXLOC
		TS	X1

		TC	INTPRET

		DMOVE*	1
		DMP	TSLT
			0,1
			SCLTAVMD
			3
		STORE	TDEC

		ITC	0
			U24,7165

		EXIT	0

		TC	U24,6744

U24,7165	ITA	0
			MIDEXIT

		RTB	0
			FRESHPD

		ITC	0
			SXTNB

		RTB	0
			FRESHPD

		VMOVE	2
		LXC,2	INCR,2
		SXA,2	ITC
			VAC
			X1
			2
			S1
			NBSM

		LXC,1	0
			MARKSTAT

		NOLOD	1
		VXM	VSLT
			REFSMMAT
			1
		STORE	0,1

		ITCI	0
			MIDEXIT

U24,7216	XCH	Q
		TS	MIDEXIT

		CAF	U24,7336
U24,7221	TS	NORMGAM

		CAF	ZERO
		INDEX	NORMGAM
		AD	RRECT
		INDEX	NORMGAM
		TS	REFRRECT
		CCS	NORMGAM
		TC	U24,7221
		TC	MIDEXIT

U24,7232	XCH	Q
		TS	MIDEXIT

		CAF	U24,7336
U24,7235	TS	NORMGAM

		CAF	ZERO
		INDEX	NORMGAM
		AD	REFRRECT
		INDEX	NORMGAM
		TS	RRECT

		CCS	NORMGAM
		TC	U24,7235

		TC	MIDEXIT

MIDDISP		XCH	Q
		TS	DSPRTRN

		CS	NVCODE
		TC	NVSUB
		TC	PRENVBSY
		TC	BANKCALL
		CADR	FLASHON
		TC	ENDIDLE
		TC	ENDMID
		TC	+2
		TC	ENDMID

		CS	-PHASE1
		TS	MPAC
		TC	MIDSTCHK
		TC	DSPRTRN

U24,7265	TC	MIDDISP

		TC	INTPRET
		ITC	0
			INCORP2

U24,7271	CAF	PRIO5
		TC	FINDVAC
		CADR	U24,6053

		TC	FFFLGDWN
		OCT	00001

		TC	SWRETURN

MIDSTCHK	CS	EIGHT
		AD	MPAC
		CCS	A
		TC	Q
		TC	U24,6000
		TC	U24,6000
		TC	U24,6000

U24,7306	CAF	PRIO5
		TC	FINDVAC
		CADR	U24,7312

		TC	SWRETURN

U24,7312	CS	-PHASE1
		TS	MPAC
		TC	MIDSTCHK

		CS	U24,7321
		AD	MPAC
		CCS	A
		TC	ENDMID
U24,7321	OCT	00020
		TC	+2
		TC	U24,6655

		INDEX	A
		TC	+1
		TC	U24,6650
		TC	U24,6342
		TC	U24,7051
		TC	U24,7025
		TC	U24,6770
		TC	U24,6211
		TC	U24,6057

U24,7335	DEC	.875
U24,7336	DEC	41
DT/2MIN		2DEC	.000006
DT/2MAX		2DEC	.65027077 B-1
U24,7343	OCT	00770
U24,7344	OCT	37777

SITEADR		ADRES	SITENUMB

VB21N32		OCT	02132
VB21N02		OCT	02102
VB25N72		OCT	02572
V21N32		OCT	02132
VB21N34		OCT	02134
V21N34		OCT	02134
VB06N33		OCT	00633
VB06N22		OCT	00622
VB06N76		OCT	00676
VB06N77		OCT	00677


## FIXME: I HAVE NO IDEA WHAT THIS STUFF IS
U24,7360	OCT	02457
U24,7361	2DEC	-.1558367759
		2DEC	.3148694038
		2DEC	.1669150814
		2DEC	-.2620636299
		2DEC	-.2535448819
		2DEC	-.1353740394
		2DEC	.3685102127
		2DEC	-.1105997413
		2DEC	-.0570649169
		2DEC	.5
		2DEC	0
		2DEC	0
		2DEC	0
		2DEC	.5
		2DEC	0
		2DEC	-.5
		2DEC	0
		2DEC	0
		2DEC	0
		2DEC	-.5
		2DEC	0

U24,7433	2DEC	-.25263062492
		2DEC	.22404696420
		2DEC	.21553979442

U24,7441	2DEC	-.51614918932
		2DEC	-.59831910208
		2DEC	.01694760099
