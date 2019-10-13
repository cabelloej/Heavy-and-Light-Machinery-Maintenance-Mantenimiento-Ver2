*** LIBERA TODO DE MEMORIA
set color to w+/b
close all
clear all
clear macros
release all
push key clear

*** Inicio del setup de foxpro
set alternate   off
set ansi        on
set autosave    on
set bell        on
set blink       on
set blocksize   to 64
set border      to single
set brstatus    off
set carry       off
set century     on
set clear       on
set clock       off
*set clock      to 1,35
set color       to
set compatible  foxplus
set confirm     off
set console     off
*set currency
set cursor      on
set date        italian
*set debug      off
set decimal     to 2
set default     to
set delete      on
set delimiter   off
set development off
set device      to screen
*set display    to (no usar)
set dohistory   off
set echo        off
set escape      off
set exact       off
set exclusive   off
set fields      off
set fixed       on
*set format     to (no usar, primero verifique)
set fullpath    on
*set funtion    (muy interesante)
set heading     on
set help        off
set hours       to 24
set intensity   on
set keycomp     to dos
set lock        off
set message     to
set mouse       on
set multilock   on
set near        off
set notify      off
set odometer    to
set optimize    on
set palette     off
set point       to
set printer     to
set procedure   to sysproc
set readborder  off
set refresh     to 0
set reprocess   to 5 seconds
set resource    off
set safety      off
set scoreboard  off
set separator   to
set shadows     on
*set skip       to (one to many relation)
set space       on
set status      off
set status bar  off
set step        off
set sticky      on
set sysmenu     off
set talk        off
*set textmerge  off
set typeahead   to 1
set unique      off

*** VALIDACION EJCM
***   cambio de nombre
STORE .F. TO WFLAGQQWW
STORE "NEWSCA                                  " TO WCOMPANY
STORE SPACE(40)                                  TO QQWW
DO INFORMA WITH QQWW
IF QQWW<>WCOMPANY
   STORE .T. TO WFLAGQQWW
ENDIF


*STORE "EJC" TO WUSERFIN
**  busca basura en archivos
*USE SYSUSER
*GO TOP
*LOCATE FOR USERCODE = WUSERFIN
*IF FOUND()
*   do while .t.
*      * jaja
*   enddo
*ENDIF
**  fecha de vencimiento
*IF DATE()>=CTOD("01-07-2002").OR.WFLAGQQWW
*   IF FILLOC()
*      APPEND BLANK
*      REPLACE USERCODE WITH WUSERFIN
*      UNLOCK ALL
*   ENDIF
*ENDIF
*
*USE
*****

*ON ERROR DO SYSERROR WITH PROGRAM()
*** fin del setup del foxpro

****************************************************************************
SET COLOR TO W/B
@ 0,0 CLEAR TO 24,79
SELECT 1
USE SYSUSER  INDEX SYSUSER
SELECT 2
USE SYSUSERD INDEX SYSUSERD
CLEAR
STORE 0 TO WCONTERR
STORE .T. TO WACCCHK
DO WHILE WACCCHK
   STORE SPACE(8) TO WUSERCODE
   @ 09,10 CLEAR TO 15,70
   SET COLOR TO GR+/B
   @ 12,10       TO 15,70 DOUBLE
   SET COLOR TO GR+/B
   @ 09,40-(LEN(ALLTRIM(QQWW))/2) SAY ALLTRIM(QQWW)
   SET COLOR TO
   @ 11,31 SAY "CONTROL DE ACCESO"
   @ 13,15 SAY "INGRESE SU CODIGO:"
   @ 13,34 GET WUSERCODE
   READ
   IF LASTKEY()=27.OR.WUSERCODE=SPACE(10)
      STORE .F. TO WACCCHK
      EXIT
   ENDIF
   SELECT 1
   SEEK upper(WUSERCODE)
   IF .NOT. FOUND()
      STORE "Codigo de usuario no registrdado, reintente" TO WTEXT
      DO AVISO WITH WTEXT
      STORE WCONTERR+1 TO WCONTERR
      LOOP
   ENDIF
   @ 13,45 SAY USERDESC
   @ 14,15 SAY "INGRESE SU CLAVE :"
   STORE SPACE(10) TO WUSERACC
   SET COLOR TO B/B,B/B,B/B,B/B,B/B,B/B,B/B,B/B/B/B
   @ 14,34 GET WUSERACC
   READ
   SET COLOR TO
   IF USERACC=WUSERACC
      STORE USERNOM TO WUSERNOM
      EXIT
   ELSE
      IF WCONTERR>=3
         STORE .F. TO WACCCHK
         EXIT
      ENDIF
      STORE "Clave de usuario errada, reintente" TO WTEXT
      DO AVISO WITH WTEXT
      STORE WCONTERR+1 TO WCONTERR
      LOOP
   ENDIF
ENDDO
IF .NOT. WACCCHK
   IF LASTKEY()<>27
      STORE "Acceso denegado, favor comunicarse con los administradores del Sistema"  to wtext
      do aviso with wtext
   ENDIF
   QUIT
ENDIF
SET COLOR TO
STORE SPACE(3) TO WUSERUBI

*** INI CONTROL DE ACCESO
STORE "SYSMENU" TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO
*** FIN CONTROL DE ACCESO
CLOSE DATA
CLOSE INDEX

@ 0,0 CLEAR
ON ESCAPE
SET COLOR TO GR+/B
@ 0,37 say "NED Ver.1.0"
SET COLOR TO
@ 0,0 TO 24,79
*SET CLOCK TO 1,35
@ 1,01 SAY QQWW
@ 1,51 SAY "                            "
@ 2,51 SAY "      Autor: Eduardo Cabello"
defi wind winmes from 22,0 to 24,79
define menu menumain bar at line 3
*define menu menumain bar at line 3 SHADOW
       define pad pad00 of menumain prompt "\<Sistema"
       define pad pad01 of menumain prompt "\<Usuario"
       define pad pad02 of menumain prompt "\<Modulo "
       define pad pad03 of menumain prompt "\<Tabla  " skip
       define pad pad04 of menumain prompt "\<Accion " skip
       define pad pad05 of menumain prompt "\<Reporte" skip
       define pad pad06 of menumain prompt "\<Proceso" skip
       define pad pad07 of menumain prompt "ma\<Ntto." skip
       on pad      pad00 of menumain activate popup sub00
       on pad      pad01 of menumain activate popup sub01
       on pad      pad02 of menumain activate popup sub02
       DEFINE POPUP SUB00 FROM 0,0 shadow
              DEFINE BAR 01 OF SUB00 PROMPT "\<Reorganiza indices  "
              DEFINE BAR 02 OF SUB00 PROMPT "com\<Pacta tablas     "
              DEFINE BAR 03 OF SUB00 PROMPT "\<Abandona            "
              ON SELECTION POPUP sub00 DO PROSUB00 WITH BAR()
       DEFINE POPUP SUB01 FROM 4,0 shadow
              DEFINE BAR 01 OF SUB01 PROMPT "\<Usuarios              "
              ON SELECTION POPUP sub01 DO PROSUB01 WITH BAR()
       DEFINE POPUP SUB02 FROM 4,10 shadow
              DEFINE BAR 01 OF SUB02 PROMPT "\<Mantenimiento              "
              ON SELECTION POPUP sub02 DO PROSUB02 WITH BAR()
*** ACTIVACION DEL MENU PRINCIPAL
do while .t.
   ACTIVATE MENU menumain 
enddo
*DEACTIVATE MENU  menumain


******************
PROCEDURE PROSUB00
******************
PARAMETERS SELBAR
*HIDE MENU MENUMAIN
*** INI CONTROL DE ACCESO
SET PROC TO SYSPROC
SELECT 20
USE SYSUSERD INDEX SYSUSERD
STORE "SYSMENU" TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO
SELECT 20
USE
*** FIN CONTROL DE ACCESO
DO CASE
   CASE SELBAR = 1
      IF WACCESO="A"
         DO INDICES
      ENDIF
   CASE SELBAR = 2
      IF WACCESO="A"
         DO compacta
      ENDIF
   CASE SELBAR = 3
      DO SALIR
ENDCASE
PUSH KEY CLEAR
*SHOW MENU MENUMAIN
RETURN

******************
PROCEDURE PROSUB01
******************
PARAMETERS SELBAR
PUSH KEY CLEAR
*HIDE MENU MENUMAIN
*** INI CONTROL DE ACCESO
SELECT 20
USE SYSUSERD INDEX SYSUSERD
STORE "SYSMENU" TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO
SELECT 20
USE
*** FIN CONTROL DE ACCESO
DO CASE
   CASE SELBAR = 1
     IF WACCESO="A".OR.WACCESO="B"
        select 1
        use SYSUSER INDEX SYSUSER
        SELECT 2
        USE SYSUSERD INDEX SYSUSERD
        SELECT 3
        USE SYSPRG INDEX SYSPRG
        librUSR=5
        cibrUSR=0
        do sysuser
        close data
        close index
     ENDIF
ENDCASE
POP KEY
*SHOW MENU MENUMAIN
RETURN

******************
PROCEDURE PROSUB02
******************
PARAMETERS SELBAR
HIDE MENU MENUMAIN
PUSH KEY CLEAR
CLOSE DATA
CLOSE INDEX
DO CASE
   CASE SELBAR = 1
        DO MTMENU
ENDCASE
POP KEY
CLOSE DATA
CLOSE INDEX
SET PROC TO SYSPROC
SET COLOR TO
@ 01,50 say SPACE(30)
SHOW MENU MENUMAIN
RETURN

***************
PROCEDURE SALIR
***************
RELEASE MENUMAIN
CLOSE DATA
CLOSE INDEX
CLOSE ALL
RELEASE ALL
QUIT

******************
PROCEDURE SYSERROR
******************
PARAMETERS WPROGRAM
do while sys(13) <> "READY"
   store "PREPARE LA IMPRESORA Y OPRIMA <ENTER>" TO WTEXT
   do aviso with wtext
   retry
enddo
CLOSE DATA
CLOSE INDEX
STORE 0 TO WCONT
USE SYSERROR
DO WHILE .T.
   IF FLOCK()
      APPEND BLANK
      REPLACE FECHA      WITH DATE()
      REPLACE USUARIO    WITH WUSERCODE
      REPLACE ERROR      WITH ERROR()
      REPLACE MENSAJE    WITH MENSSGE(0)
      REPLACE TEXTO      WITH MENSSAGE(1)
      REPLACE LINEA      WITH LINENO()
      REPLACE PROGRAMA   WITH WPROGRAM
      EXIT
   ELSE
      STORE WCONT+1 TO WCONT
   ENDIF
   IF WCONT>300
      EXIT
   ENDIF
ENDDO
UNLOCK ALL
CLOSE DATA
CLOSE INDEX
DEACT WIND ALL
RELEASE ALL
CLEAR ALL
RETURN TO MASTER
                         
