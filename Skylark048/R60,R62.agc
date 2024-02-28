### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	R60,R62.agc
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

		SETLOC	MANUVER
		BANK
		
		EBANK=	TEMPR60
		
		COUNT*	$$/R60
	
# R60CSM	
# REV 13   CONFORMS TO GSOP CHAPTER FOUR REVISION LOGIC  09  JAN 18,1968

R60CSM		TC	MAKECADR
		TS	TEMPR60

REDOMANN	TC	INTPRET
		BON	CALL		# IS 3-AXIS FLAG SET
			3AXISFLG
			TOBALL1		# YES
			VECPOINT	# NO CALL VECPOINT
		STORE	CPHI
TOBALL1		EXIT
		
TOBALL		CAF	V06N18
		TC	BANKCALL
		CADR	GOPERF2R	# DISPLAY PLEASE PERFORM AUTO MANEUVER
		TC	R61TEST
		TC	REDOMANC -1
		TCF	ENDMANU1	# ENTER I.E. FINISHED WITH R60
		
		TC	CHKLINUS	# TO CHECK FOR PRIORITY DISPLAYS
		TC	ENDOFJOB

 -1		TC	INTPRET
REDOMANC	BON	CALL		# IS 3-AXIS FLAG SET
			3AXISFLG
			+3		# YES
			VECPOINT	# NO CALL VECPOINT
		STORE	CPHI		# STORE ANGLES
		EXIT

TOBALLC		CAF	FURST3		# BITS 15,14,13 OF CHAN31 = 011
		TC	C31BTCHK	# FOR AUTO AND G&N CONTROL
		TCF	+1
		AD	NEG30000
		EXTEND
		BZF	+2		# AUTO, NON-FLASH N18
		TCF	TOBALL		# NOT AUTO
		CAF	V06N18		# SET UP NON-FLASHING V06 N18
		TC	BANKCALL
		CADR	GODSPR
		TC	CHKLINUS
		
STARTMNV	TC	POSTJUMP
		CADR	KALCMAN3

ENDMANUV	TC	INTPRET
		BOFF	BOFF
			AUTOSEQ
			TOBALL1
			TRACKFLG
			TOBALL1
		EXIT

ENDMANU1	CA	TEMPR60
		TC	BANKJUMP	#					-
		
CHKLINUS	CS	FLAGWRD4
		MASK	PDSPFBIT	# IS PRIORITY DISPLAY FLAG SET
		CCS	A		#					-
		TC	Q		# NO - EXIT
		CA	Q
		TS	MPAC +2		# SAVE RETURN
		CS	THREE		# OBTAIN LOCATION FOR RESTART.
		AD	BUF2		# HOLDS Q OF LAST DISPALY
		TS	TBASE1
		
		TC	PHASCHNG
		OCT	71		# 1.7SPOT FOR RELINUS
		
1P7SPT1		=	1.7SPOT
		CAF	BIT7
		TC	LINUS		# GO SET BITS FOR PRIORITY DISPLAY	-
		TC	MPAC +2
		
RELINUS		CAF	TRACKBIT	# IS TRACK FLAG ON
		MASK	FLAGWRD1
		EXTEND
		BZF	GOREDO20	# NO
		
		TC	UPFLAG
		ADRES	PDSPFLAG	# R60 PRIODSP FLAG
		
		CA	FLAGWRD8
		MASK	UTBIT
		CCS	A
		TC	RELINUSX	# UTFLAG SET,DO NOT SET TARG1FLG,OPTIND
		TC	UPFLAG
		ADRES	TARG1FLG	# FOR R52
		
		CAF	ZERO		# RESET TO ZERO, SINCE
		TS	OPTIND		# OPTIND WAS SET TO -1 BY V379

		CAF	BIT1
		TC	WAITLIST
		EBANK=	FIXTIME
		2CADR	CTASK

		TC	UPFLAG
		ADRES	R21MARK		# ALLOW OPTICS MARKING DURING P2
		
RELINUSX	CAF	PRIO14		# RESTORE ORIGINAL PRIORITY
		TC	PRIOCHNG
		
		TC	TBASE1
		
GOREDO20	TC	POSTJUMP	# RESTORE R03 DEADBAND, DO STOPRATE,
		CADR	FIXDB		#  SET UP 1.11 RESTART, EOJ.
R61TEST		CA	MODREG		# ARE WE IN P00.  IF YES THIS MUST BE
		EXTEND			#     VERB49 OR VERB89 SO DO ENDEXT.
		BZF	ENDMANU1	# RESET 3-AXIS & RUTURN.  USER DOES ENDEXT
		CA	FLAGWRD4	# ARE WE IN R61 (P20)
		MASK	PDSPFBIT
		EXTEND
		BZF	GOTOPOOH	# NO
		TC	GOTOV56		# YES

# PROGRAM DESCRIPTION - VECPOINT


#          THIS INTERPRETIVE SUBROUTINE MAY BE USED TO POINT A SPACECRAFT AXIS IN A DESIRED DIRECTION.  THE AXIS
# TO BE POINTED MUST APPEAR AS A HALF UNIT DOUBLE PRECISION VECTOR IN SUCCESSIVE LOCATIONS OF ERASABLE MEMORY
# BEGINNING WITH THE LOCATION CALLED SCAXIS.  THE COMPONENTS OF THIS VECTOR ARE GIVEN IN SPACECRAFT COORDINATES.
# THE DIRECTION IN WHICH THIS AXIS IS TO BE POINTED MUST APPEAR AS A HALF UNIT DOUBLE PRECISION VECTOR IN
# SUCCESSIVE LOCATIONS OF ERASABLE MEMORY BEGINNING WITH THE ADDRESS CALLED POINTVSM.  THE COMPONENTS OF THIS
# VECTOR ARE GIVEN IN STABLE MEMBER COORDINATES.  WITH THIS INFORMATION VECPOINT COMPUTES A SET OF THREE GIMBAL
# ANGLES (2S COMPLEMENT) CORRESPONDING TO THE CROSS-PRODUCT ROTATION BETWEEN SCAXIS AND POINTVSM AND STORES THEM
# IN T(MPAC) BEFORE RETURNING TO THE CALLER.
#         THIS ROTATION, HOWEVER, MAY BRING THE S/C INTO GIMBAL LOCK.  WHEN POINTING A VECTOR IN THE Y-Z PLANE,
# THE TRANSPONDER AXIS, OR THE AOT FOR THE LEM, THE PROGRAM WILL CORRECT THIS PROBLEM BY ROTATING THE CROSS-
# PRODUCT ATTITUDE ABOUT POINTVSM BY A FIXED AMOUNT SUFFICIENT TO ROTATE THE DESIRED S/C ATTITUDE OUT OF GIMBAL
# LOCK.  IF THE AXIS TO BE POINTED IS MORE THAN 40.6 DEGREES BUT LESS THAN 60.5 DEG FROM THE +X (OR -X) AXIS,
# THE ADDITIONAL ROTATION TO AVOID GIMAL LOCK IS 35 DEGREES.  IF THE AXIS IS MORE THAN 60.5 DEGEES FROM +X (OR -X)
# THE ADDITIONAL ROTATION IS 35 DEGREES.  THE GIMBAL ANGLES CORRESPONDING TO THIS ATTITUDE ARE THEN COMPUTED AND
# STORED AS 2S COMPLIMENT ANGLES IN T(MPAC) BEFORE RETURNING TO THE CALLER.
#          WHEN POINTING THE X-AXIS, OR THE THRUST VECTOR, OR ANY VECTOR WITHIN 40.6 DEG OF THE X-AXIS, VECPOINT
# CANNOT CORRECT FOR A CROSS-PRODUCT ROTATION INTO GIMBAL LOCK.  IN THIS CASE A PLATFORM REALIGNMENT WOULD BE
# REQUIRED TO POINT THE VECTOR IN THE DESIRED DIRECTION.  AT PRESENT NO INDICATION IS GIVEN FOR THIS SITUATION
# EXCEPT THAT THE FINAL MIDDLE GIMBAL ANGLE IN MPAC +2 IS GREATER THAN 59 DEGREES.
#
# CALLING SEQUENCE -
#
#	1) LOAD SCAXIS, POINTVSM
#	2) CALL
#		VECPOINT
#
# RETURNS WITH
#
#	1) DESIRED OUTER  GIMBAL ANGLE IN MPAC
#	2) DESIRED INNER  GIMBAL ANGLE IN MPAC +1
#	3) DESIRED MIDDLE GIMBAL ANGLE IN MPAC +2
#
# ERASABLES USED -
#
#	1) SCAXIS		 6
#	2) POINTVSM		 6
#	3) MIS			18
#	4) DEL			18
#	5) COF			 6
#	6) VECQTEMP		 1
#	7) ALL OF VAC AREA	43
#
#			TOTAL	99

		SETLOC	VECPT
		BANK
		EBANK=	BCDU
		
		COUNT*	$$/VECPT
VECPOINT	STQ	BOV		# SAVE RETURN ADDRESS
			VECQTEMP
			VECLEAR		# AND CLEAR OVFIND
VECLEAR		AXC,2	RTB
			MIS		# READ THE PRESENT CDU ANGLES AND
			READCDUK	# STORE THEM IN PD25, 26, 27
		STCALL	25D
			CDUTODCM	# S/C AXES TO STABLE MEMBER AXES (MIS)
		VLOAD	VXM
			POINTVSM	# RESOLVE THE POINTING DIRECTION VF INTO
			MIS		# INITIAL S/C AXES (VF = POINTVSM)
		UNIT
		STORE	28D
					# PD 28 29 30 31 32 33
		VXV	UNIT		# TAKE THE CROSS PRODUCT VF X VI
			SCAXIS		# WHERE VI = SCAXIS
		BOV	VCOMP
			PICKAXIS
		STODL	COF		# CHECK MAGNITUDE
			36D		# OF CROSS PRODUCT
		DSU	BMN		# VECTOR, IF LESS
			DPB-14		# THAN B-14 ASSUME
			PICKAXIS	# UNIT OPERATION
		VLOAD	DOT		#          INVALID.
			SCAXIS
			28D
		SL1	ARCCOS
COMPMATX	CALL			# NOW COMPUTE THE TRANSFORMATION FROM
			DELCOMP		# FINAL S/C AXES TO INITIAL S/C AXES	MFI
		AXC,1	AXC,2
			MIS		# COMPUTE THE TRANSFORMATION FROM FINAL
			DEL		# S/C AXES TO STABLE MEMBER AXES
		CALL			# MFS = MIS MFI
			MXM3		# (IN PD LIST)
			
		DLOAD	ABS
			6		# MFS6 = SIN(CPSI)			$2
		DSU	BMN
			SINGIMLC	# = SIN(59 DEGS)			$2
			FINDGIMB	# /CPSI/ LESS THAN 59 DEGS
					# I.E. DESIRED ATTITUDE NOT IN GIMBAL LOCK
					
		DLOAD	ABS		# CHECK TO SEE IF WE ARE POINTING
			SCAXIS		# THE THRUST AXIS
		DSU	BPL
			SINVEC1		# SIN 49.4 DEGS				$2
			FINDGIMB	# IF SO, WE ARE TRYING TO POINT IT INTO
		VLOAD			# GIMBAL LOCK, ABORT COULD GO HERE
		STADR
		STOVL	MIS +12D
		STADR			# STORE MFS (IN PD LIST) IN MIS
		STOVL	MIS +6
		STADR
		STOVL	MIS
			MIS +6		# INNER GIMBAL AXIS IN FINAL S/C AXES
		BPL	VCOMP		# LOCATE THE IG AXIS DIRECTION CLOSEST TO
			IGSAMEX		# FINAL X S/C AXIS
			
IGSAMEX		VXV	BMN		# FIND THE SHORTEST WAY OF ROTATING THE 
			SCAXIS		# S/C OUT OF GIMBAL LOCK BY A ROTATION 
			U=SCAXIS	# ABOUT +- SCAXIS, I.E. IF  (IG (SGN MFS3)
					# X SCAXIS . XF) LESS THAN 0, U = SCAXIS
					# OTHERWISE U = -SCAXIS
					
		VLOAD	VCOMP
			SCAXIS
		STCALL	COF		# ROTATE ABOUT -SCAXIS
			CHEKAXIS
U=SCAXIS	VLOAD
			SCAXIS
		STORE	COF		# ROTATE ABOUT + SCAXIS
CHEKAXIS	DLOAD	ABS
			SCAXIS		# SEE IF WE ARE POINTING THE AOT
		DSU	BPL
			SINVEC2		# SIN 29.5 DEGS				$2
			PICKANG1	# IF SO, ROTATE 50 DEGS ABOUT +- SCAXIS
		DLOAD	GOTO		# IF NOT, MUST BE POINTING THE TRANSPONDER
			VECANG2		# OR SOME VECTOR IN THE Y, OR Z PLANE
			COMPMFSN	# IN THIS CASE ROTATE 35 DEGS TO GET OUT
					# OF GIMBAL LOCK (VECANG2  $360)
PICKANG1	DLOAD
			VECANG1		# = 50 DEGS			      $ 360
COMPMFSN	CALL
			DELCOMP		# COMPUTE THE ROTATION ABOUT SCAXIS TO
		AXC,1	AXC,2		# BRING MFS OUT OF GIMBAL LOCK
			MIS
			DEL
		CALL			# COMPUTE THE NEW TRANSFORMATION FROM
			MXM3		# DESIRED S/C AXES TO STABLE MEMBER AXES
					# WHICH WILL ALIGN VI WITH VF AND AVOID
					# GIMBAL LOCK
FINDGIMB	AXC,1	CALL
			0		# EXTRACT THE COMMANDED CDU ANGLES FROM
			DCMTOCDU	# THIS MATRIX
		RTB	
			V1STO2S		# CONVERT TO 2:S COMPLEMENT
VECPTRET	SETPD	GOTO
			0
			VECQTEMP	# RETURN TO CALLER
			
PICKAXIS	VLOAD	DOT		# IF VF X VI = 0, FIND VF . VI
			28D
			SCAXIS
		BMN	TLOAD
			ROT180
			25D
		GOTO			# IF VF = VI, CDU DESIRED = PRESENT CDU
			VECPTRET	# PRESENT CDU ANGLES
ROT180		VLOAD	VXV		# IF VF, VI ANTIPARALLEL, 180 DEG ROTATION
			MIS +6		# IS REQUIRED. Y STABLE MEMBER AXIS IN
			HIUNITX		# INITIAL S/C AXIS.
		UNIT	VXV		# FIND Y(SM) X X(I)
			SCAXIS		# FIND UNIT(VI X UNIT(Y(SM) X X(I)))
		UNIT	BOV		# I.E. PICK A VECTOR IN THE PLANE OF X(I),
			PICKX		# Y(SM) PERPENDICULAR TO VI
		STODL	COF
			36D		# CHECK MAGNITUDE
		DSU	BMN		# OF THIS VECTOR.
			DPB-14		# IF LESS THAN B-14,
			PICKX		# PICK X-AXIS.
		VLOAD
			COF
XROT		STODL	COF
			HIDPHALF
		GOTO
			COMPMATX
PICKX		VLOAD	GOTO		# PICK THE XAXIS IN THIS CASE
			HIUNITX
			XROT
		SETLOC	MANUVER1
		BANK
		
		COUNT*	$$/VECPT
SINGIMLC	2DEC	.4285836003	# = SIN(59)		$2
SINVEC1		2DEC	.3796356537	# = SIN(49.4)		$2
SINVEC2		2DEC	.2462117800	# = SIN(29.5)		$2
VECANG1		2DEC	.1388888889	# = 50 DEGREES			      $360
VECANG2		2DEC	.09722222222	# = 35 DEGREES			      $360

1BITDP		OCT	0		# KEEP THIS BEFORE DPB(-14)	 *********
DPB-14		OCT	00001
		OCT	00000
		SETLOC	MANUVER
		BANK
		
# ROUTINE FOR INITIATING AUTOMATIC MANEUVER VIA KEYBOARD (V49)

		EBANK=	CPHI
		
		COUNT*	$$/R62
R62DISP		CAF	V06N22		# DISPLAY COMMAND ICDUS CPHI, CTHETA, CPHI
		TC	BANKCALL
		CADR	GOFLASH
		TCF	ENDEXT	
		TCF	GOMOVE		# PROCEED
		TCF	R62DISP		# ENTER
		
					# ASTRONAUT MAY LOAD NEW ICDUS AT THIS
					# POINT
GOMOVE		TC	UPFLAG		# SET 3-AXIS FLAG
		ADRES	3AXISFLG	# BIT 6  FLAG 5
		TC	BANKCALL
		CADR	R60CSM

		TCF	ENDEXT	
