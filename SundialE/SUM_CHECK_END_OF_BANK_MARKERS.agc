### FILE="Main.annotation"
## Copyright:    Public domain.
## Filename:     SUM_CHECK_END_OF_BANK_MARKERS.agc
## Purpose:      Part of the source code for Aurora (revision 12).
## Assembler:    yaYUL
## Contact:      Ron Burkey <info@sandroid.org>.
## Website:      https://www.ibiblio.org/apollo.
## Mod history:  2016-09-20 JL   Created.
##               2016-10-09 OH   Transcribed.
##               2016-10-16 HG   Fix operand ENDT45 -> ENDT4S
##               2016-12-08 RSB  Proofed comments with octopus/ProoferComments
##                               but no errors found.


                SETLOC  ENDIMUF
                TC
                TC

                SETLOC  ENDINTF
                TC
                TC

                SETLOC  ENDINTS0
                TC
                TC

                SETLOC  ENDSLFS2
                TC
                TC

                SETLOC  ENDRTBSS
                TC
                TC

                SETLOC  ENDDNTMS
                TC
                TC

                BANK    06
                TC
                TC

                SETLOC  ENDCSITS
                TC
                TC

                BANK    10              ## FIXME WAS SETLOC  ENDRTSTS
                TC
                TC

                BANK    11              ## FIXME WAS SETLOC  ENDCMS
                TC
                TC

                SETLOC  ENDFRPS
                TC
                TC

                SETLOC  ENDIMPS
                TC
                TC

                BANK    14              ## FIXME SETLOC  ENDIMUS1
                TC
                TC

                BANK    15              ## FIXME WAS SETLOC  ENDINFSS
                TC
                TC

                BANK    16              ## FIXME SETLOC  ENDIMUS3
                TC
                TC

                SETLOC  ENDIMUS2
                TC
                TC

                BANK    20
                TC
                TC

                BANK    21
                TC
                TC
