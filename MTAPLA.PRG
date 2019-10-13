***
*** ACTUALIZA PLANES DE LAS CATEGORIAS
***
STORE "< CATEGORIA: "+ALLTRIM(MTCAT.DESCAT)+" >" TO WTITLE
PUSH KEY CLEAR
DEFI WIND WINDPLA FROM 03,00 TO 20,79;
          TITLE WTITLE ;
          FOOTER " F1=Inc, F2=Mod, F3=Eli, F4=Bus, F11=Activ, Tab=Desp, Enter=Sal " ;
          DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINDPLA
ON KEY LABEL F1  DO PROPLAI
ON KEY LABEL F2  DO PROPLAM
ON KEY LABEL F3  DO PROPLAE
ON KEY LABEL F4  DO PROPLAB
ON KEY LABEL F11 DO PROCACT
ON KEY LABEL ENTER KEYBOARD '{CTRL+W}'
SELECT MTPLA
BROWSE FIELDS CODPLA         :H="Plan",;
              DESPLA         :H="Descripcion",;
              TIPO           :H="Tipo",;
              ORIGEN         :H="Origen",;
              DIAS           :H="Lapso x dias",;
              WFUSO=WFUNUSO():H="Lapso x Uso";
       KEY  MTCAT.CODCAT;
       NOAPPEND NODELETE NOEDIT NOMENU NOOPTIMIZE REST SAVE IN WINDOW WINDPLA
DEACT WIND WINDPLA
POP KEY
RETURN

************
PROC PROPLAI
************
PUSH KEY CLEAR
STORE "INCLUIR" TO WFLAGRPLA
SCATT MEMV BLANK
STORE MTCAT.CODCAT TO M.CODCAT
DO WHILE .T.
   SELECT MTPLA
   STORE SPACE(LEN(M.DESPLA)) TO M.DESPLA
   DO GETPLA
   DO SHOWPLAS
   IF LASTKEY()=27
      EXIT
   ENDIF
ENDDO
POP KEY
RETURN

************
PROC PROPLAM
************
PUSH KEY CLEAR
STORE "MODIFICAR" TO WFLAGRPLA
SELECT MTPLA
IF .NOT. EOF()
   SCATT MEMV
   DO GETPLA
ENDIF
POP KEY
RETURN

************
PROC PROPLAE
************
SELECT MTPLA
IF EOF()
   RETURN
ENDIF
PUSH KEY CLEAR
STORE "ELIMINAR" TO WFLAGRPLA
STORE 2 TO WOP
DO CANCACEP WITH WFLAGRPLA
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
PROC PROPLAB
************
PUSH KEY CLEAR
STORE "BUSCAR" TO WFLAGRPLA
DEFI WIND WINDBUS FROM 04,5 TO 06,75;
          TITLE  WFLAGRPLA ;
          DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINDBUS
DO WHILE .T.
   SCATT MEMV BLANK
   @ 0,1 GET M.CODPLA
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF M.CODPLA<>SPACE(LEN(M.CODPLA))
      SELECT MTPLA
      SET ORDER TO MTPLA1
      SEEK MTCAT.CODCAT+M.CODPLA
      IF FOUND()
         EXIT
      ELSE
         STORE "NO REGISTRADO, REINTENTE" TO WTEXT
         DO AVISO WITH WTEXT
         LOOP
      ENDIF
   ELSE
      @ 0,LEN(M.CODPLA)+2 GET M.DESPLA
      READ
      IF LASTKEY()=27
         EXIT
      ENDIF
      IF M.DESPLA<>SPACE(LEN(M.DESPLA))
         SELECT MTPLA
         SET ORDER TO MTPLA2
         SEEK ALLTRIM(M.DESPLA)
         IF FOUND()
            EXIT
         ELSE
            STORE "NO REGISTRADO, REINTENTE" TO WTEXT
            DO AVISO WITH WTEXT
            LOOP
         ENDIF
      ENDIF
      EXIT
   ENDIF
ENDDO
SELECT MTPLA
SET ORDER TO MTPLA1
RELE WIND WINDBUS
POP KEY
RETURN

***********
PROC GETPLA
***********
DEFI WIND WINDGETS FROM 04,04 TO 11,75;
          TITLE  WFLAGRPLA ;
          DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINDGETS
DO WHILE .T.
   @ 00,01 SAY "Plan ......................:"
   @ 01,01 SAY "Descripcion ...............:"
   @ 02,01 SAY "Tipo de plan ..............:"
   @ 03,01 SAY "Origen del plan ...........:"
   @ 04,01 SAY "Lapso por dias ............:"
   @ 05,01 SAY "Lapso por uso .............:"
   IF WFLAGRPLA="INCLUIR"
      @ 0,30 GET M.CODPLA
      READ
      IF LASTKEY()=27
         EXIT
      ENDIF
      SELECT MTPLA
      SEEK MTCAT.CODCAT+M.CODPLA
      IF FOUND()
         @ 1,30 SAY DESPLA
         @ 2,30 SAY TIPO
         @ 3,30 SAY ORIGEN
         @ 4,30 SAY DIAS   picture "999,999,999.99"
         @ 5,30 SAY USO    picture "999,999,999.99"
         STORE "CODIGO YA EXISTE" TO WTEXT
         DO AVISO WITH WTEXT
         LOOP
      ENDIF
      ***
   ELSE
      @ 0,30 SAY M.CODPLA
   ENDIF
   @ 1,30   GET M.DESPLA VALID VALDES()
   @ 2,30   GET M.TIPO   VALID VALTIP()
   @ 3,30   GET M.ORIGEN VALID VALORI()
   @ 4,30   GET M.DIAS   picture "999,999,999.99" WHEN M.TIPO="P"
   @ 5,30   GET M.USO    picture "999,999,999.99" WHEN M.TIPO="P"
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   STORE 1 TO WOP
   DO ACEPCANC WITH WFLAGRPLA
   IF WOP=1
      SELECT MTPLA
      IF WFLAGRPLA="INCLUIR"
         IF FILLOC()
            APPEND BLANK
            GATH MEMV
            UNLOCK ALL
         ELSE
           DO PROCNUL
         ENDIF
      ELSE
         IF RECLOC()
            GATH MEMV
            UNLOCK ALL
         ELSE
            DO PROCNUL
         ENDIF
      ENDIF
   ENDIF
   EXIT
ENDDO
RELE WIND WINDGETS
RETURN

*************
PROC SHOWPLAS
*************
RETURN

***********
FUNC VALDES
***********
IF M.DESPLA<>SPACE(LEN(M.DESPLA))
   RETURN .T.
ELSE
   RETURN .F.
ENDIF

***********
FUNC VALTIP
***********
do while .t.
   if m.tipo="P".or.m.tipo="C"
      exit
   endif
   defi wind winvalpla from 01,30 to 03,60 in wind windgets
   acti wind winvalpla
   @ 00,00 clear
   store 1 to wvalop
   do while .t.
      @ 00,01 get wvalop pict "@*H  Preventivo;Correctivo" defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   if wvalop=1
      store "P" to m.tipo
   else
      store "C" to m.tipo
   endif
   rele wind winvalpla
enddo
return .t.

***********
FUNC VALORI
***********
do while .t.
   if m.origen="M".or.m.origen="A"
      exit
   endif
   defi wind winvalpla from 02,30 to 04,60 in wind windgets
   acti wind winvalpla
   @ 00,00 clear
   store 1 to wvalop
   do while .t.
      @ 00,01 get wvalop pict "@*H  Manuales  ;Adicional " defa wvalop
      read
      if lastkey()=13
         exit
      endif
   enddo
   if wvalop=1
      store "M" to m.origen
   else
      store "A" to m.origen
   endif
   rele wind winvalpla
enddo
return .t.

************
PROC PROCACT
************
SELECT MTACT
SET ORDER TO MTACTXP
STORE "MTCAT.CODCAT+MTPLA.CODPLA" TO WKEYACT
DO MTAACT
SET ORDER TO MTACTXS
RETURN

************
FUNC WFUNUSO
************
STORE STR(USO,12,2)+" "+MTCAT.UNIUSO TO WFUSO
RETURN WFUSO
