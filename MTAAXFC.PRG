***
***  Reporte averias / Solicitud mtto  (actividades corresctivas x equipo)
***
PUSH KEY CLEAR
DEFI WIND WINDAXFC FROM 03,00 TO 14,79;
          TITLE "< NOTIFICACION DE AVERIAS DEL EQUIPO "+ALLTRIM(MTFIC.CODFIC)+" >" ;
          FOOTER " F1=Inc, F2= Obs, F3=Eli, F9=Prog.mtto, F10=Ejec.mtto., Tab=Des, Ent=Sal " ;
          DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
DEFI WIND WINDOBS FROM 15,00 TO 22,79;
          TITLE "< OBSERVACIONES >" ;
          DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINDOBS
ACTI WIND WINDAXFC
ON KEY LABEL F1  DO PROCAXFIC
ON KEY LABEL F2  DO PROCAXFO
ON KEY LABEL F3  DO PROCAXFE
ON KEY LABEL F9  DO PROCAXFPC
ON KEY LABEL F10 DO PROCAXFEJ 
ON KEY LABEL ENTER KEYBOARD '{CTRL+W}'
SELECT MTAXF
SET ORDER TO MTAXFS

BROWSE FIELDS FECREG           :H='Fec.aver.',;
              WDESSEC=FUNDESS():H='Seccion',  ;
              WDESACT=FUNDESA():H='Actividad',;
              FECPRO           :H='Fec prog.',;
              USOPRO           :H='Uso prog.' ;
       NOAPPEND NODELETE NOEDIT NOMENU NOOPTIMIZE REST SAVE IN WINDOW WINDAXFC;
       KEY MTFIC.CODFIC;
       FOR FUNTIP();
       WHEN WINOBS()
DEACT WIND WINDOBS
DEACT WIND WINDAXFC
POP KEY
RETURN
***********
FUNC FUNTIP 
***********
SELECT MTPLA
SEEK MTAXF.CODCAT+MTAXF.CODPLA
IF FOUND()
   IF TIPO="C"
      STORE .T. TO WVALOR
   ELSE
      STORE .F. TO WVALOR
   ENDIF
ELSE
   STORE .F. TO WVALOR
ENDIF
SELECT MTAXF
RETURN WVALOR
***********
PROC WINOBS
***********
ACTI WIND WINDOBS
@ 0,1 SAY MTAXF.OBSERVA1+MTAXF.OBSERVA2
@ 1,1 SAY MTAXF.OBSERVA3+MTAXF.OBSERVA4
@ 2,1 SAY MTAXF.OBSERVA5+MTAXF.OBSERVA6
ACTI WIND WINDAXFC
RETURN
*************
PROC PROCAXFO
*************
ACTI WIND WINDOBS
@ 0,01 GET MTAXF.OBSERVA1
@ 0,39 GET MTAXF.OBSERVA2
@ 1,01 GET MTAXF.OBSERVA3
@ 1,39 GET MTAXF.OBSERVA4
@ 2,01 GET MTAXF.OBSERVA5
@ 2,39 GET MTAXF.OBSERVA6
READ
ACTI WIND WINDAXFC
RETURN
**************
PROC PROCAXFIC
**************
STORE "INCLUIR ACTIVIDADES CORRECTIVAS" TO WFLAGRAXF
* TOMA EL CODIGO DEL MANUAL PREVENTIVO ASIGNADO
STORE MTFIC.CODMAN TO M.CODMAN

* MOSTRAR LAS SECCIONES DEL MANUAL PARA AGREGAR LIBREMENTE LAS ACTIVIDADES.
STORE .F.          TO WFLAGSELP
STORE SPACE(10)    TO M.CODCAT
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

   *** REGISTRA LA ACTIVIDAD EN LA FICHA
   IF LASTKEY()<>27
      SELECT MTACT
      SCAT MEMV
      STORE MTFIC.CODFIC TO M.CODFIC
      STORE DATE()       TO M.FECREG
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
      *** ACTUALIZA ESTATUS EQUIPO
       SELECT MTFIC
       IF RECLOC()
          REPLACE ESTATUS WITH "Reporta falla"
          UNLOCK ALL
       ELSE
          DO PROCNUL
       ENDIF
      ***
   ENDIF
ENDIF
SELECT MTAXF
RETURN
***********
PROC SELPLA
***********
PUSH KEY CLEAR
*** Selecciona los planes correctivos disponibles
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
**
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

**************
PROC PROCAXFPC
**************
PUSH KEY CLEAR
STORE "PROGRAMACION CORRECTIVA" TO WFLAGRAXF
SELECT MTAXF
IF .NOT. EOF()
   SCATT MEMV
   DEFI WIND WINDGAXF FROM 04,20 TO 07,60;
             TITLE  WFLAGRAXF;
             DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
   ACTI WIND WINDGAXF
   DO WHILE .T.
      @ 00,01 SAY "Fecha Prog de mantto.:"
      @ 01,01 SAY "Uso   Prog de mantto.:"
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
               IF TIPO="C"
                  SELECT MTAXF
                  IF RECLOC()
                     REPLACE FECPRO WITH WFECULT
                     REPLACE USOPRO WITH WUSOULT
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
STORE "EJECUCION PLAN CORRECTIVO: "+WPLANEJE TO WFLAGRAXF
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
               IF TIPO="C"
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
                  *** ACTUALIZA FICHA
                  SELECT MTFIC
                  IF RECLOC()
                     REPLACE ESTATUS WITH "Operativo"
                     *iniope  ** se van a considerar valores iniciales
                     *usoope     de registro en el sistema y seran act. 
                     UNLOCK ALL
                  ELSE
                     DO PROCNUL
                  ENDIF
                  *** ACTUALIZA PLAN
                  SELECT MTAXF
                  IF RECLOC()
                     DELETE
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
   STORE "?"                        TO WDESPLA
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
   STORE "?"                 TO WDESSEC
ENDIF
SELECT MTAXF
RETURN WDESSEC

************
FUNC FUNDESA
************
SELECT MTACT
IF ORDER()="MTACTXS"
   STORE MTAXF.CODCAT+MTAXF.CODSEC+MTAXF.CODPLA+MTAXF.CODACT    TO WCLAVEACT
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

*****************************************************************************

***********
PROC SELMAN
***********
*** Busca con el codigo de clasificacion del equipo,
*** el manual de mantenimiento mas cercano para tomar las secciones.
*** Recibe wflagselm=.f.
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
            store .t. to wflagselm
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
select mtsec
seek wcodman
if found()
   store mtcat.codsec  to m.codsec
   return .t.
else
   store space(10)     to m.codsec
   return .f.
endif
return
*************
