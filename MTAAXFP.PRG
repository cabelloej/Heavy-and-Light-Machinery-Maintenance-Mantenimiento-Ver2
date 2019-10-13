***
***  ACTIVIDADES POR FICHA DE EQUIPO (PREVENTIVO)
***
PUSH KEY CLEAR
DEFI WIND WINDAXF FROM 03,00 TO 20,79;
          TITLE "< PLANIFICACION PREVENTIVA DEL EQUIPO "+ALLTRIM(MTFIC.CODFIC)+" >" ;
          FOOTER " F1=Inc plan, F3=Eli act., F9=Prog.mtto., F10=Ejec.mtto., Tab=Desp., Ent=Sal. " ;
          DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINDAXF
ON KEY LABEL F1  DO PROCAXFIP
ON KEY LABEL F3  DO PROCAXFE
ON KEY LABEL F9  DO PROCAXFPP
ON KEY LABEL F10 DO PROCAXFEJ
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
       KEY MTFIC.CODFIC;
       FOR FUNTIP()
DEACT WIND WINDAXF
POP KEY
RETURN
***********
FUNC FUNTIP
***********
SELECT MTPLA
SEEK MTAXF.CODCAT+MTAXF.CODPLA
IF FOUND()
   IF TIPO="P"
      STORE .T. TO WVALOR
   ELSE
      STORE .F. TO WVALOR
   ENDIF
ELSE
   STORE .F. TO WVALOR
ENDIF
SELECT MTAXF
RETURN WVALOR
**************
PROC PROCAXFIP
**************
PUSH KEY CLEAR
STORE SPACE(1) TO WCODMAN
STORE .F.      TO WFLAGSEL
DO SELMAN
IF WFLAGSEL
   STORE " Desea incluir act. preventivas adicionales del manual? (S/N)" to wtext
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
PROC PROCAXFPP
**************
PUSH KEY CLEAR
STORE "PROGRAMACION PREVENTIVA GENERAL" TO WFLAGRAXF
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
                     REPLACE FECREG WITH WFECULT
                     REPLACE USOREG WITH WUSOULT
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

**************
PROC PROCAXFEJ
**************
PUSH KEY CLEAR
SELECT MTAXF
STORE MTAXF.CODPLA TO WPLANEJE
STORE "EJECUCION PLAN PREVENTIVO: "+WPLANEJE TO WFLAGRAXF
IF .NOT. EOF()
   SCATT MEMV
   DEFI WIND WINDGAXF FROM 04,20 TO 07,60;
             TITLE  WFLAGRAXF;
             DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
   ACTI WIND WINDGAXF
   DO WHILE .T.
      @ 00,01 SAY "Fecha Ejec de mantto.:"
      @ 01,01 SAY "Uso   Ejec de mantto.:"
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
            *** FILTRO POR PLAN
            IF MTAXF.CODPLA<>WPLANEJE
               SKIP
               LOOP
            ENDIF
            STORE CODCAT TO WCODCAT
            STORE CODPLA TO WCODPLA
            SELECT MTPLA
            SEEK WCODCAT+WCODPLA
            IF .NOT.EOF()
               IF TIPO="P"
                  *** CREA HISTORICO
                  SELECT MTAXF
                  SCAT MEMV
                  SELECT MTAXFH
                  IF FILLOC()
                     APPEND BLANK
                     GATH MEMV
                     REPLACE FECEJE WITH WFECULT
                     REPLACE USOEJE WITH WUSOULT
                     UNLOCK ALL
                  ELSE
                     DO PROCNUL
                  ENDIF
                  *** ACTUALIZA PLAN
                  SELECT MTAXF
                  IF RECLOC()
                     REPLACE FECREG WITH WFECULT
                     REPLACE USOREG WITH WUSOULT
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
   STORE TIPO                       TO WTIPPLA
ELSE
   STORE "?"    TO WDESPLA
   STORE TIPO                       TO WTIPPLA
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
   STORE "?"           TO WDESACT1
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
            store .t. to wflagsel
            store "Manual encontrado: "+alltrim(mtcat.descat) to wtext
            do aviso with wtext
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
return
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
SELECT MTFIC
IF RECLOC()
   REPLACE CODMAN WITH WCODMAN
   UNLOCK ALL
ELSE
   DO PROCNUL
ENDIF
SELECT MTACT
RETURN


