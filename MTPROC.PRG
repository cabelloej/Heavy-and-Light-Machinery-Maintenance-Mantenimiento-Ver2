*****************
PROCEDURE INDICES
*****************
DEFI WIND WININD FROM 05,50 TO 07,72 ;
                 TITLE " REORGANIZAR " ;
                 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WININD
@ 0,0 CLEAR
store 2 to wop
do while .t.
   store space(10) to wclaveind
   @ 00,00  say "Clave:" get wclaveind
   read
   if UPPER(wclaveind)<>"EJCM      "
      exit
   endif
   @ 00,00  get wop pict "@*H Aceptar ;Cancelar" defa wop
   read
   if lastkey()=13
      exit
   endif
enddo
if wop=1
   @ 00,00 
   @ 00,00 SAY "Favor esperar..."
else
   RELE WIND WININD
   RETURN
endif
***
CLOSE DATA
CLOSE INDEX
***
USE MTCAT
IF FILLOC()
   INDEX ON CODCAT            TO MTCAT1
   INDEX ON DESCAT            TO MTCAT2
ELSE
   STORE "OPERACION RECHAZADA, REINTENTE" TO WTEXT
   DO AVISO WITH WTEXT
ENDIF
***
USE MTSEC
IF FILLOC()
   INDEX ON CODCAT+CODSEC     TO MTSEC1
   INDEX ON DESSEC            TO MTSEC2
ELSE
   STORE "OPERACION RECHAZADA, REINTENTE" TO WTEXT
   DO AVISO WITH WTEXT
ENDIF
***
USE MTPLA
IF FILLOC()
   INDEX ON CODCAT+CODPLA     TO MTPLA1
   INDEX ON DESPLA            TO MTPLA2
ELSE
   STORE "OPERACION RECHAZADA, REINTENTE" TO WTEXT
   DO AVISO WITH WTEXT
ENDIF
***
USE MTACT
IF FILLOC()
   INDEX ON CODCAT+CODSEC+CODPLA+CODACT TO MTACTXS
   INDEX ON CODCAT+CODPLA+CODSEC+CODACT TO MTACTXP
ELSE
   STORE "OPERACION RECHAZADA, REINTENTE" TO WTEXT
   DO AVISO WITH WTEXT
ENDIF
***
USE MTTACT
IF FILLOC()
   INDEX ON CODTIP TO MTTACT
ELSE
   STORE "OPERACION RECHAZADA, REINTENTE" TO WTEXT
   DO AVISO WITH WTEXT
ENDIF
***
***
USE MTADM
IF FILLOC()
   INDEX ON CODIGO TO MTADM
ELSE
   STORE "OPERACION RECHAZADA, REINTENTE" TO WTEXT
   DO AVISO WITH WTEXT
ENDIF
***
***
USE MTGEO
IF FILLOC()
   INDEX ON CODIGO TO MTGEO
ELSE
   STORE "OPERACION RECHAZADA, REINTENTE" TO WTEXT
   DO AVISO WITH WTEXT
ENDIF
***
***
USE MTMAR
IF FILLOC()
   INDEX ON CODIGO TO MTMAR
ELSE
   STORE "OPERACION RECHAZADA, REINTENTE" TO WTEXT
   DO AVISO WITH WTEXT
ENDIF
***
***
USE MTMOD
IF FILLOC()
   INDEX ON PADRE+CODIGO TO MTMOD
ELSE
   STORE "OPERACION RECHAZADA, REINTENTE" TO WTEXT
   DO AVISO WITH WTEXT
ENDIF
***
***
USE MTPER
IF FILLOC()
   INDEX ON CODIGO TO MTPER
ELSE
   STORE "OPERACION RECHAZADA, REINTENTE" TO WTEXT
   DO AVISO WITH WTEXT
ENDIF
***
***
USE MTTINS
IF FILLOC()
   INDEX ON CODIGO TO MTTINS
ELSE
   STORE "OPERACION RECHAZADA, REINTENTE" TO WTEXT
   DO AVISO WITH WTEXT
ENDIF
***
***
USE MTINS
IF FILLOC()
   INDEX ON PADRE+CODIGO TO MTINS
ELSE
   STORE "OPERACION RECHAZADA, REINTENTE" TO WTEXT
   DO AVISO WITH WTEXT
ENDIF
***
***
USE MTFIC
IF FILLOC()
   INDEX ON CODFIC        TO MTFIC
   INDEX ON DESFIC        TO MTFIC2
   INDEX ON CODCAT        TO MTFIC3
   INDEX ON CODMAR+CODMOD TO MTFIC4
   INDEX ON CODOPE        TO MTFIC5
ELSE
   STORE "OPERACION RECHAZADA, REINTENTE" TO WTEXT
   DO AVISO WITH WTEXT
ENDIF
***
***
USE MTAXF
IF FILLOC()
   INDEX ON CODFIC+CODCAT+CODSEC+CODPLA+CODACT TO MTAXFS
   INDEX ON CODFIC+CODCAT+CODPLA+CODSEC+CODACT TO MTAXFP
ELSE
   STORE "OPERACION RECHAZADA, REINTENTE" TO WTEXT
   DO AVISO WITH WTEXT
ENDIF
***
***
USE MTAXFH
IF FILLOC()
   INDEX ON CODFIC+CODCAT+CODSEC+CODPLA+CODACT TO MTAXFHS
   INDEX ON CODFIC+CODCAT+CODPLA+CODSEC+CODACT TO MTAXFHP
ELSE
   STORE "OPERACION RECHAZADA, REINTENTE" TO WTEXT
   DO AVISO WITH WTEXT
ENDIF


STORE "EL SISTEMA SE REINICIARA, OPRIMA <ENTER> PARA CONTINUAR." TO WTEXT
DO AVISO WITH WTEXT
RELE WIND WININD
CLOSE DATA
CLOSE INDEX
SET PROC TO SYSPROC
RETURN TO MASTER

******************
PROCEDURE COMPACTA
******************
DEFI WIND WINCOM FROM 05,50 TO 07,72 ;
                 TITLE " COMPACTAR " ;
                 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINCOM
@ 0,0 CLEAR
store 2 to wop
do while .t.
   store space(10) to wclaveind
   @ 00,00  say "Clave:" get wclaveind
   read
   if UPPER(wclaveind)<>"EJCM      "
      exit
   endif
   @ 00,00  get wop pict "@*H Aceptar ;Cancelar" defa wop
   read
   if lastkey()=13
      exit
   endif
enddo
if wop=1
   @ 00,00 
   @ 00,00 SAY "Favor esperar..."
else
   RELE WIND WINCOM
   RETURN
endif
***
***
STORE "EL SISTEMA SE REINICIARA, OPRIMA <ENTER> PARA CONTINUAR." TO WTEXT
DO AVISO WITH WTEXT
RELE WIND WINCOM
CLOSE DATA
CLOSE INDEX
SET PROCEDURE TO SYSPROC
RETURN TO MASTER

****************
PROCEDURE RECLOC
****************
DEFI WIND WINRLOCK FROM 12,05 TO 18,75 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
STORE .F. TO WFLAGRL
STORE .F. TO WRECMES
STORE .T. TO WRECLOC
DO WHILE WRECLOC
   IF RLOCK()
      STORE .T. TO WFLAGRL
      EXIT
   ELSE
      IF .NOT. WRECMES
         ACTI WIND WINRLOCK
         @ 02,15 SAY "REGISTRO OCUPADO POR OTRO USUARIO, REINTENTANDO ..."
         @ 03,15 SAY "          OPRIMA [ESC] PARA ABANDONAR              "
         STORE .T. TO WRECMES
      ENDIF
      WVALUE = INKEY()
      IF WVALUE = 27
         EXIT
      ENDIF
   ENDIF
ENDDO
RELEASE WIND WINRLOCK
RETURN WFLAGRL

****************
PROCEDURE FILLOC
****************
DEFI WIND WINFLOCK FROM 12,05 TO 18,75 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
STORE .F. TO WFLAGFL
STORE .F. TO WFILMES
STORE .T. TO WFILLOC
DO WHILE WFILLOC
   IF FLOCK()
      STORE .T. TO WFLAGFL
      EXIT
   ELSE
      IF .NOT. WFILMES
         ACTI WIND WINFLOCK
         @ 02,15 SAY "ARCHIVO  OCUPADO POR OTRO USUARIO, REINTENTANDO ..."
         @ 03,15 SAY "          OPRIMA [ESC] PARA ABANDONAR              "
         STORE .T. TO WFILMES
      ENDIF
      WVALUE = INKEY()
      IF WVALUE = 27
         EXIT
      ENDIF
   ENDIF
ENDDO
RELEASE WIND WINFLOCK
RETURN WFLAGFL

******************
PROCEDURE PREGUNTA
******************
DEFI WIND WINPRE FROM 22,0 TO 24,79;
          DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINPRE
STORE .T. TO WPREG
DO WHILE WPREG
   @ 0,0
   STORE SUBSTR(WCH,1,1) TO WCHOICE
   @ 0,40- (LEN(WTEXT)/2) SAY WTEXT GET WCHOICE
   READ
   STORE UPPER(WCHOICE) TO WCHOICE
   IF AT(WCHOICE,WCH) > 0
      STORE .F. TO WPREG
      EXIT
   ENDIF
ENDDO
@ 0,0
STORE WCHOICE TO WCH
RELE WIND WINPRE
RETURN
***************
PROCEDURE AVISO
***************
PARAMETERS WTEXT
DEFI WIND WINAVI FROM 22,0 TO 24,79;
     DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINAVI
?? CHR(7)
?? CHR(7)
@ 0,40-(LEN(WTEXT)/2) SAY WTEXT
READ
RELE WIND WINAVI
RETURN

*****************
PROCEDURE MENSAJE
*****************
PARAMETERS WTEXT
DEFI WIND WINMES FROM 22,0 TO 24,79 DOUBLE  NOFLOAT;
                 NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINMES
@ 0,40-(LEN(WTEXT)/2) SAY WTEXT
RELE WIND WINMES
RETURN

****************
PROCEDURE CHKACC
****************
PARAMETERS WUSERCODE,WPROGRAMA,WACCESO
SELECT SYSUSERD
STORE WUSERCODE+WPROGRAMA TO WCLAVEACC
SEEK WCLAVEACC
IF FOUND()
   STORE ACCESO TO WACCESO
ENDIF
RETURN

*************
PROC ACEPCANC
*************
PARA WTITLE
DEFI WIND WINDAC FROM 12,20 TO 14,60;
          TITLE WTITLE;
          DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTIVATE WIND WINDAC
DO WHILE .T.
   @ 00,03 SAY "OPCIONES: ";
   GET WOP PICT "@*H ACEPTAR  ;CANCELAR " DEFA WOP
   READ
   IF LASTKEY()=13
      EXIT
   ENDIF
ENDDO
RELE WIND WINDAC
RETURN

*************
PROC CANCACEP
*************
PARA WTITLE
DEFI WIND WINDAC FROM 12,20 TO 14,60;
          TITLE WTITLE;
          DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTIVATE WIND WINDAC
DO WHILE .T.
   @ 00,03 SAY "OPCIONES: ";
   GET WOP PICT "@*H CANCELAR ;ACEPTAR  " DEFA WOP
   READ
   IF LASTKEY()=13
      EXIT
   ENDIF
ENDDO
RELE WIND WINDAC
RETURN

************
PROC PROCNUL
************
STORE "OPERACION RECHAZADA, FAVOR REINTENTAR." TO WTEXT
DO AVISO WITH WTEXT
CLOSE DATA
CLOSE INDEX
RETURN TO MASTER
RETURN

***********
PROC CONNUM
***********
PARAMETERS WNUMERO
STORE LTRIM(STR(WNUMERO,7))                   TO WNUMERO
STORE REPLICATE("0",7-LEN(WNUMERO))+WNUMERO   TO WNUMERO
RETURN



********************************************************************
***************   RUTINAS PARA MANEJO DE CATALOGOS   ***************
********************************************************************

***********
PROC VALCAT
***********
*** Elimina espacios y puntos innecesarios del codigo de catalogo
***
store m.codcat      to wcodcat
store len(m.codcat) to wlencat
store len(m.codcat) to wconcar
do while wconcar>0
   store substr(wcodcat,wconcar,1) to wcar
   if wcar=" ".or.wcar="."
      *** ok
   else
      exit
   endif
   store wconcar-1 to wconcar
enddo
store substr(wcodcat,1,(wconcar))+space(wlencat-wconcar) to m.codcat
if at(" ",rtrim(m.codcat))>0
   return .f.
else
   return .t.
endif
RETURN
*************
PROC MTWINCAT
*************
PUSH KEY CLEAR
DEFI WIND WINDCAT FROM WLINCAT,WCOLCAT TO WLINCAT+10,WCOLCAT+60;
          TITLE "< MANUALES DE MANTENIMIENTO >" ;
          FOOTER " Enter=Seleccionar " ;
          DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINDCAT
ON KEY LABEL ENTER KEYBOARD '{CTRL+W}'
SELECT MTCAT
BROWSE FIELDS CODCAT:H="Categoria",DESCAT:H="Descripcion";
       NOAPPEND NODELETE NOEDIT NOMENU NOOPTIMIZE REST SAVE IN WINDOW WINDCAT
DEACT WIND WINDCAT
POP KEY
RETURN

***********
PROC VALSEC
***********
*** Elimina espacios y puntos innecesarios del codigo de seccion
***
store m.codsec      to wcodsec
store len(m.codsec) to wlensec
store len(m.codsec) to wconcar
do while wconcar>0
   store substr(wcodsec,wconcar,1) to wcar
   if wcar=" ".or.wcar="."
      *** ok
   else
      exit
   endif
   store wconcar-1 to wconcar
enddo
store substr(wcodsec,1,(wconcar))+space(wlensec-wconcar) to m.codsec
if at(" ",rtrim(m.codsec))>0
   return .f.
else
   return .t.
endif
RETURN
*************
PROC VALCATPA
*************
*** Verifica que el codigo padre exista
*** necesita recibir variable wpadre(valor=.t.)
***
store m.codcat      to wcodcat
store len(m.codcat) to wconcar
do while wconcar>0
   store substr(wcodcat,wconcar,1) to wcar
   if wcar="."
      store substr(wcodcat,1,wconcar-1) to wcodpadre
      seek wcodpadre
      if .not. found()
         store "Error: Codigo sin padre, Verifique." to text
         do aviso with text
         store .f. to wpadre
      endif
      exit
   endif
   store wconcar-1 to wconcar
enddo
return wpadre
RETURN

*************
PROC VALSECPA
*************
*** Verifica que el codigo padre exista
*** necesita recibir variable wpadre(valor=.t.)
***
store m.codsec      to wcodsec
store len(m.codsec) to wconcar
do while wconcar>0
   store substr(wcodsec,wconcar,1) to wcar
   if wcar="."
      store substr(wcodsec,1,wconcar-1) to wcodpadre
      seek mtcat.codcat+wcodpadre
      if .not. found()
         store "Error: Codigo sin padre, Verifique." to text
         do aviso with text
         store .f. to wpadre
      endif
      exit
   endif
   store wconcar-1 to wconcar
enddo
return wpadre
RETURN


********************************************************
******  RUTINAS PARA MANEJO DE FICHAS DE EQUIPOS  ******
********************************************************
***********
FUNC FUNCAT
***********
SELECT MTCAT
SEEK MTFIC.CODCAT
IF FOUND()
   STORE DESCAT TO WDESCAT
ELSE
   STORE "?"    TO WDESCAT
ENDIF
SELECT MTFIC
RETURN WDESCAT
***********
FUNC FUNMAN
***********
SELECT MTCAT
SEEK MTFIC.CODMAN
IF FOUND()
   STORE DESCAT TO WDESMAN
ELSE
   STORE "?"    TO WDESMAN
ENDIF
SELECT MTFIC
RETURN WDESMAN
***********
FUNC FUNMAR
***********
SELECT 20
USE MTMAR INDEX MTMAR
SEEK MTFIC.CODMAR
IF FOUND()
   STORE DESCRI TO WDESMAR
ELSE
   STORE "?"    TO WDESMAR
ENDIF
SELECT MTFIC
RETURN WDESMAR
***********
FUNC FUNMOD
***********
SELECT 21
USE MTMOD INDEX MTMOD
SEEK MTFIC.CODMAR+MTFIC.CODMOD
IF FOUND()
   STORE DESCRI TO WDESMOD
ELSE
   STORE "?"    TO WDESMOD
ENDIF
SELECT MTFIC
RETURN WDESMOD
***********
FUNC FUNADM
***********
SELECT 20
USE MTADM INDEX MTADM
SEEK MTFIC.CODADM
IF FOUND()
   STORE DESCRI TO WDESADM
ELSE
   STORE "?"    TO WDESADM
ENDIF
SELECT MTFIC
RETURN WDESADM
***********
FUNC FUNGEO
***********
SELECT 20
USE MTGEO INDEX MTGEO
SEEK MTFIC.CODGEO
IF FOUND()
   STORE DESCRI TO WDESGEO
ELSE
   STORE "?"    TO WDESGEO
ENDIF
SELECT MTFIC
RETURN WDESGEO
***********
FUNC FUNSUP
***********
SELECT 20
USE MTPER INDEX MTPER
SEEK MTFIC.CODSUP
IF FOUND()
   STORE DESCRI TO WDESSUP
ELSE
   STORE "?"    TO WDESSUP
ENDIF
SELECT MTFIC
RETURN WDESSUP
***********
FUNC FUNOPE
***********
SELECT 20
USE MTPER INDEX MTPER
SEEK MTFIC.CODOPE
IF FOUND()
   STORE DESCRI TO WDESOPE
ELSE
   STORE " "    TO WDESOPE
ENDIF
SELECT MTFIC
RETURN WDESOPE
***********
FUNC FUNUNI
***********
SELECT MTCAT
SEEK MTFIC.CODCAT
IF FOUND()
   STORE UNIUSO TO WUNIUSO
ELSE
   STORE "?"    TO WUNIUSO
ENDIF
RETURN WUNIUSO
************
FUNC FUNADML
************
SELECT 20
USE MTADM INDEX MTADM
SEEK MTFIC.CODADMLAST
IF FOUND()
   STORE DESCRI TO WDESADML
ELSE
   STORE " "    TO WDESADML
ENDIF
SELECT MTFIC
RETURN WDESADML
************
FUNC FUNGEOL
************
SELECT 20
USE MTGEO INDEX MTGEO
SEEK MTFIC.CODGEOLAST
IF FOUND()
   STORE DESCRI TO WDESGEOL
ELSE
   STORE " "    TO WDESGEOL
ENDIF
SELECT MTFIC
RETURN WDESGEOL
***********
FUNC VALDES
***********
IF M.DESFIC<>SPACE(LEN(MTFIC.DESFIC))
   RETURN .T.
ELSE
   RETURN .F.
ENDIF
*************
FUNC VALCATSE
*************
SELECT MTCAT
SEEK M.CODCAT
IF FOUND()
   STORE DESCAT  TO WDESCAT
   STORE DESCAT  TO M.DESCAT
ELSE
   STORE 06 TO WLINCAT
   STORE 25 TO WCOLCAT
   DO MTWINCAT
   STORE CODCAT  TO M.CODCAT
   STORE DESCAT  TO M.DESCAT
ENDIF
SELECT MTFIC
@ WLINFIC+02,36 SAY M.DESCAT
RETURN .T.
***********
FUNC VALMAR
***********
SELECT 20
USE MTMAR INDEX MTMAR
SEEK M.CODMAR
IF FOUND()
   STORE DESCRI  TO M.DESMAR
ELSE
   DO MTAMAR
   STORE CODIGO  TO M.CODMAR
   STORE DESCRI  TO M.DESMAR
ENDIF
SELECT MTFIC
@ WLINFIC+04,36 SAY M.DESMAR
RETURN .T.
***********
FUNC VALMOD
***********
SELECT 21
USE MTMOD INDEX MTMOD
SEEK M.CODMAR+M.CODMOD
DO WHILE .T.
   IF FOUND()
      STORE DESCRI  TO M.DESMOD
   ELSE
      STORE M.CODMAR TO WFILTRO
      STORE .F.      TO WVALOR
      DO MTAMOD
      STORE CODIGO  TO M.CODMOD
      STORE DESCRI  TO M.DESMOD
   ENDIF
   IF MTMOD.PADRE<>M.CODMAR
      STORE "**********" TO M.CODMOD
      LOOP
   ELSE
      EXIT
   ENDIF
ENDDO
SELECT MTFIC
@ WLINFIC+05,36 SAY M.DESMOD
RETURN .T.
***********
FUNC VALEST
***********
do while .t.
   if m.estatus="Operativo".or.m.estatus="Reporta falla".or.;
      m.estatus="Mantenimiento".or.m.estatus="Espera repto.".or.;
      m.estatus="Desincorporado"
      exit
   else
      do getestat
   endif
enddo
return
*************
PROC GETESTAT
*************
defi wind winvalest from 04,31 to 10,48;
       title " ESTATUS ";
       DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
acti wind winvalest
@ 00,00 clear
store 1 to wvalop
do while .t.
   @ 00,00 get wvalop pict "@*V    Operativo     ;Reporta falla ;Mantenimiento ;Espera repto. ;Desincorporado" defa wvalop
   read
   if lastkey()=13.or.lastkey()=23
      exit
   endif
enddo
if wvalop=1
   store "Operativo" to m.estatus
else
   if wvalop=2
      store "Reporta falla" to m.estatus
   else
      if wvalop=3
         store "Mantenimiento" to m.estatus
      else
         if wvalop=4
            store "Espera repto." to m.estatus
         else
            store "Desincorporado" to m.estatus
         endif
      endif
   endif
endif
rele wind winvalest
return .t.
RETURN
***********
FUNC VALADM
***********
SELECT 20
USE MTADM INDEX MTADM
SEEK M.CODADM
IF FOUND()
   STORE DESCRI  TO M.DESADM
ELSE
   DO MTAADM
   STORE CODIGO  TO M.CODADM
   STORE DESCRI  TO M.DESADM
ENDIF
SELECT MTFIC
@ WLINFIC+08,36 SAY M.DESADM
RETURN .T.
***********
FUNC VALGEO
***********
SELECT 20
USE MTGEO INDEX MTGEO
SEEK M.CODGEO
IF FOUND()
   STORE DESCRI  TO M.DESGEO
ELSE
   DO MTAGEO
   STORE CODIGO  TO M.CODGEO
   STORE DESCRI  TO M.DESGEO
ENDIF
SELECT MTFIC
@ WLINFIC+09,36 SAY M.DESGEO
RETURN .T.
***********
FUNC VALSUP
***********
SELECT 20
USE MTPER INDEX MTPER
SEEK M.CODSUP
IF FOUND()
   STORE DESCRI  TO M.DESSUP
ELSE
   DO MTAPER
   STORE CODIGO  TO M.CODSUP
   STORE DESCRI  TO M.DESSUP
ENDIF
SELECT MTFIC
@ WLINFIC+10,36 SAY M.DESSUP
RETURN .T.
***********
FUNC VALOPE
***********
IF M.CODOPE<>SPACE(LEN(M.CODOPE))
   SELECT 20
   USE MTPER INDEX MTPER
   SEEK M.CODOPE
   IF FOUND()
      STORE DESCRI  TO M.DESOPE
   ELSE
      DO MTAPER
      STORE CODIGO  TO M.CODOPE
      STORE DESCRI  TO M.DESOPE
   ENDIF
ELSE
    STORE SPACE(40) TO M.DESOPE   
ENDIF
SELECT MTFIC
@ WLINFIC+11,36 SAY M.DESOPE
RETURN .T.
************
FUNC VALADML
************
SELECT 20
USE MTADM INDEX MTADM
SEEK M.CODADMLAST
IF FOUND()
   STORE DESCRI  TO M.DESADMLAST
ELSE
   DO MTAADM
   STORE CODIGO  TO M.CODADMLAST
   STORE DESCRI  TO M.DESADMLAST
ENDIF
SELECT MTFIC
@ WLINFIC+14,36 SAY M.DESADMLAST
RETURN .T.
************
FUNC VALGEOL
************
SELECT 20
USE MTGEO INDEX MTGEO
SEEK M.CODGEOLAST
IF FOUND()
   STORE DESCRI  TO M.DESGEOLAST
ELSE
   DO MTAGEO
   STORE CODIGO  TO M.CODGEOLAST
   STORE DESCRI  TO M.DESGEOLAST
ENDIF
SELECT MTFIC
@ WLINFIC+15,36 SAY M.DESGEOLAST
RETURN .T.
*************************************************************
*************************************************************
*************************************************************

