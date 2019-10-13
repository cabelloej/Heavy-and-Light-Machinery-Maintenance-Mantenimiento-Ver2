***
***  ACTIVIDADES  PREV Y CORR POR FICHA DE EQUIPO
***  ACTUALMENTE NO ESTA EN USO
***
PUSH KEY CLEAR
DEFI WIND WINDAXF FROM 03,00 TO 20,79;
          TITLE "< ACTIVIDADES DEL EQUIPO "+ALLTRIM(MTFIC.CODFIC)+" >" ;
          FOOTER " F1=Inc prev, F3=Eli, F5=Inc corr, F12=Prog prev, Tab=Des, Ent=Sal " ;
          DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINDAXF
ON KEY LABEL F1  DO PROCAXFIP
ON KEY LABEL F3  DO PROCAXFE
ON KEY LABEL F5  DO PROCAXFIC
ON KEY LABEL F12 DO PROCAXFPP
ON KEY LABEL ENTER KEYBOARD '{CTRL+W}'
SELECT MTAXF
SET ORDER TO MTAXFP
BROWSE FIELDS WDESPLA=FUNDESP():H='Plan'              ,;
              WDESSEC=FUNDESS():H='Seccion'           ,;
              WDESACT=FUNDESA():H='Actividad'         ,;
              FECPRO           :H='Fec prog.'         ,;
              USOPRO           :H='Uso prog.'         ,;
              WDESOBS=FUNDESO():H='Observaciones'      ;
       NOAPPEND NODELETE NOEDIT NOMENU NOOPTIMIZE REST SAVE IN WINDOW WINDAXF;
       KEY MTFIC.CODFIC
DEACT WIND WINDAXF
POP KEY
RETURN

**************
PROC PROCAXFIP
**************
PUSH KEY CLEAR
STORE SPACE(1) TO WCODMAN
STORE .F.      TO WFLAGSEL
DO SELMAN
IF WFLAGSEL
   STORE "incluir actividades preventivas adicionales del manual? (S/N)" to wtext
   store "SN" to wch
   do pregunta
   store wch to wflagap
   DO APPMAN
ELSE
   STORE "No se encontro manual para la categoria o esta incompleto" TO MES
   DO AVISO WITH MES
ENDIF
POP KEY
RETURN

**************
PROC PROCAXFIC
**************
STORE "INCLUIR ACTIVIDADES CORRECTIVAS" TO WFLAGRAXF
*** Selecciona el plan
STORE .F. TO WFLAGSELP
STORE SPACE(10) TO M.CODCAT
DO SELPLA
STORE MTPLA.CODPLA TO M.CODPLA
IF WFLAGSELP
   *** Actualiza i/o Selecciona la actividad
   SELECT MTCAT
   SEEK M.CODCAT
   IF EOF()
      STORE "ERROR, CATEGORIA: "+M.CODCAT+" NO REGISTRADA EN MANUAL" TO MES
      DO AVISO WITH MES
   ENDIF
   SELECT MTACT
   SET ORDER TO MTACTXP
   STORE "M.CODCAT+M.CODPLA" TO WKEYACT
   DO MTAACT
   SET ORDER TO MTACTXS
   *** Registra la actividad en la ficha
   IF LASTKEY()=27
   ELSE
      SELECT MTACT
      SCAT MEMV
      STORE MTFIC.CODFIC TO M.CODFIC
      SELECT MTAXF
      SEEK M.CODFIC+M.CODCAT+M.CODPLA+M.CODSEC+M.CODACT
      IF .NOT. FOUND()
         IF FILLOC()
            APPEND BLANK
            UNLOCK ALL
         ELSE
            DO PROCNUL
         ENDIF
      ENDIF
      IF RECLOC()
         GATH MEMV
         UNLOCK ALL
      ELSE
         DO PROCNUL
      ENDIF
   ENDIF
ENDIF
RETURN

**************
PROC PROCAXFPP
**************
PUSH KEY CLEAR
STORE "PROGRAMACION PREVENTIVA" TO WFLAGRAXF
SELECT MTAXF
IF .NOT. EOF()
   SCATT MEMV
   DEFI WIND WINDGAXF FROM 04,20 TO 07,60;
             TITLE  WFLAGRAXF;
             DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
   ACTI WIND WINDGAXF
   DO WHILE .T.
      @ 00,01 SAY "Fecha ultimo mantto. :"
      @ 01,01 SAY "Uso   ultimo mantto. :"
      STORE DATE() TO WFECULT
      STORE 0      TO WUSOULT
      @ 0,24 GET WFECULT
      @ 1,24 GET WUSOULT
      READ
      IF LASTKEY()=27
         EXIT
      ENDIF
      STORE 1 TO WOP
      DO ACEPCANC WITH WFLAGRAXF
      IF WOP=1
         SELECT MTAXF
         SEEK M.CODFIC
         DO WHILE .NOT. EOF().AND.MTAXF.CODFIC=MTFIC.CODFIC
            STORE CODCAT TO WCODCAT
            STORE CODPLA TO WCODPLA
            SELECT MTPLA
            SEEK WCODCAT+WCODPLA
            IF .NOT.EOF()
               IF TIPO="P"
                  SELECT MTAXF
                  IF RECLOC()
                     REPLACE FECPRO WITH WFECULT+MTPLA.DIAS
                     REPLACE USOPRO WITH WUSOULT+MTPLA.USO
                     UNLOCK ALL
                  ELSE
                     DO PROCNUL
                  ENDIF
               ENDIF
            ENDIF
            SELECT MTAXF
            SKIP
         ENDDO
      ENDIF
      EXIT
   ENDDO
   RELE WIND WINDGAXF
ENDIF
POP KEY
RETURN

*************
PROC PROCAXFE
*************
SELECT MTAXF
IF EOF()
   RETURN
ENDIF
PUSH KEY CLEAR
STORE "ELIMINAR" TO WFLAGRAXF
STORE 2 TO WOP
DO CANCACEP WITH WFLAGRAXF
IF WOP=2
   IF RECLOC()
      DELETE
      UNLOCK
   ELSE
      DO PROCNUL
   ENDIF
ENDIF
POP KEY
RETURN

************
FUNC FUNDESP
************
SELECT MTPLA
SEEK MTAXF.CODCAT+MTAXF.CODPLA
IF FOUND()
   STORE ALLTRIM(CODPLA)+" "+DESPLA TO WDESPLA
ELSE
   STORE "?"    TO WDESPLA
ENDIF
SELECT MTAXF
RETURN WDESPLA

************
FUNC FUNDESS
************
SELECT MTSEC
SEEK MTAXF.CODCAT+MTAXF.CODSEC
IF FOUND()
   STORE SUBSTR(DESSEC,1,25) TO WDESSEC
ELSE
   STORE "?"    TO WDESSEC
ENDIF
SELECT MTAXF
RETURN WDESSEC

************
FUNC FUNDESA
************
SELECT MTACT
IF ORDER()="MTACTXS"
   STORE MTAXF.CODCAT+MTAXF.CODSEC+MTAXF.CODPLA+MTAXF.CODACT TO WCLAVEACT
ELSE
   IF ORDER()="MTACTXP"
      STORE MTAXF.CODCAT+MTAXF.CODPLA+MTAXF.CODSEC+MTAXF.CODACT TO WCLAVEACT
   ENDIF
ENDIF
SEEK WCLAVEACT
IF FOUND()
   STORE DESACT1+" "+;
         DESACT2+" "+;
         DESACT3+" "+;
         DESACT4+" "+;
         DESACT5       TO WDESACT1
ELSE
   STORE "?"     TO WDESACT1
ENDIF
SELECT MTAXF
RETURN WDESACT1
************
FUNC FUNDESO
************
STORE ALLTRIM(OBSERVA1)+" "+;
      ALLTRIM(OBSERVA2)+" "+;
      ALLTRIM(OBSERVA3)+" "+;
      ALLTRIM(OBSERVA4)+" "+;
      ALLTRIM(OBSERVA5)+" "+;
      ALLTRIM(OBSERVA6) TO WDESOBS
RETURN WDESOBS

***********
PROC SELMAN
***********
***
*** Busca con el codigo de clasificacion del equipo,
*** el manual de mantenimiento mas cercano.
*** Recibe wflagsel=.f.
***
store mtfic.codcat  to wcodcat,wcodman
store len(wcodcat)  to wconcar
store .t.           to wflagseek
do while wconcar>0
   store substr(wcodcat,wconcar,1) to wcar
   if wcar="."
      store substr(wcodcat,1,wconcar-1) to wcodman
      store .t. to wflagseek
   endif
   if wflagseek
      select mtcat
      seek wcodman
      if found()
         if wflagman()
            store "Manual encontrado: "+alltrim(mtcat.descat)+", correcto? (s/n)" to wtext
            store "SN" TO WCH
            do pregunta
            if wch="S"
               store .t. to wflagsel
               exit
            endif
         endif
      endif
      store .f. to wflagseek
   endif
   store wconcar-1 to wconcar
enddo
select mtaxf
return
*************
func wflagman
*************
select mtpla
seek wcodman
if found()
   select mtact
   seek wcodman
   if found()
      return .t.
   else
      return .f.
   endif
else
   return .f.
endif
***********
PROC APPMAN
***********
***
*** agrega las actividades preventivas del manual a la ficha del equipo
***
SELECT MTACT
SET ORDER TO MTACTXS
DO WHILE .NOT. EOF().AND.CODCAT=WCODMAN
   SCAT MEMV
   STORE MTFIC.CODFIC TO M.CODFIC
   ***
   *** Verifica que sea preventiva y del manual
   ***
   SELECT MTPLA
   SET ORDER TO MTPLA1
   SEEK M.CODCAT+M.CODPLA
   IF .NOT. FOUND()
      STORE "Error en manual, Plan: "+alltrim(m.codpla)+" no registrado" TO MES
      DO AVISO WITH MES
      SELECT MTACT
      SKIP
      LOOP
   ELSE
      IF TIPO="C"
         SELECT MTACT
         SKIP
         LOOP
      ELSE
         IF ORIGEN="A".AND.WFLAGAP="N"
            SELECT MTACT
            SKIP
            LOOP
         ENDIF
      ENDIF
   ENDIF
   ***
   *** Fin verificacion
   ***
   SELECT MTAXF
   SEEK M.CODFIC+M.CODCAT+M.CODPLA+M.CODSEC+M.CODACT
   IF .NOT. FOUND()
      IF FILLOC()
         APPEND BLANK
         UNLOCK ALL
      ELSE
         DO PROCNUL
      ENDIF
   ENDIF
   IF RECLOC()
      GATH MEMV
      UNLOCK ALL
   ELSE
      DO PROCNUL
   ENDIF
   SELECT MTACT
   SKIP
ENDDO
RETURN

***********
PROC SELPLA
***********
*
* Selecciona los planes correctivos disponibles
*
PUSH KEY CLEAR
SELECT MTAXF
SEEK MTFIC.CODFIC
IF EOF()
   STORE .F. TO WFLAGSEL
   DO SELMAN
   IF .NOT.WFLAGSEL
       POP KEY
       RETURN
   ELSE
       STORE MTCAT.CODCAT TO M.CODCAT
   ENDIF
ELSE
   STORE MTAXF.CODCAT TO M.CODCAT
ENDIF
*
SELECT MTPLA
SEEK M.CODCAT
DO WHILE .NOT.EOF().AND.CODCAT=M.CODCAT
   IF TIPO="C"
      STORE .T. TO WFLAGSELP
      EXIT
   ENDIF
   SKIP
ENDDO
IF .NOT. WFLAGSELP
   STORE "NO EXISTEN PLANES CORRECTIVOS EN EL MANUAL" TO MES
   DO AVISO WITH MES
   POP KEY
   RETURN
ENDIF
SEEK M.CODCAT
STORE "< PLANES CORRECTIVOS >" TO WTITLE
DEFI WIND WINDPLA FROM 04,00 TO 20,79;
          TITLE WTITLE ;
          FOOTER " Enter=Seleccionar, Esc=Abandonar " ;
          DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINDPLA
ON KEY LABEL ENTER KEYBOARD '{CTRL+W}'
BROWSE FIELDS CODPLA         :H="Plan",;
              DESPLA         :H="Descripcion",;
              TIPO           :H="Tipo",;
              ORIGEN         :H="Origen",;
              DIAS           :H="Lapso x dias",;
              WFUSO=WFUNUSO():H="Lapso x Uso";
       KEY  M.CODCAT;
       FOR TIPO="C";
       NOAPPEND NODELETE NOEDIT NOMENU NOOPTIMIZE REST SAVE IN WINDOW WINDPLA
DEACT WIND WINDPLA
POP KEY
RETURN
FUNC WFUNUSO
STORE STR(USO,12,2)+" "+MTCAT.UNIUSO TO WFUSO
RETURN WFUSO
************

