***
*** ACTUALIZA FICHAS DE EQUIPOS
***
PUSH KEY CLEAR
DEFI WIND WINDFIC FROM 02,00 TO 20,79;
          TITLE "< FICHAS DE EQUIPOS >";
          FOOTER "F1=Inc F2=Mod F3=Eli F4=Bus F5=Ord F6=Prev F7=Falla F8=Hist" ;
          DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINDFIC
STORE SPACE(10) TO WFILTRO
ON KEY LABEL F1  DO PROFICI
ON KEY LABEL F2  DO PROFICM
ON KEY LABEL F3  DO PROFICE
ON KEY LABEL F4  DO PROFICB
ON KEY LABEL F5  DO PROFICO
ON KEY LABEL F6  DO MTAAXFP
ON KEY LABEL F7  DO MTAAXFC
ON KEY LABEL F8  DO MTAAXFH
ON KEY LABEL ENTER KEYBOARD '{CTRL+W}'
SELECT MTFIC
SET ORDER TO MTFIC
BROWSE FIELDS CODFIC            :H="Codigo",;
              DESFIC            :H="Descripcion",;
              ESTATUS           :H="Estatus",;
              USOOPE            :H="Uso total",;
              WUNIUSO=FUNUNI()  :H=" ",;
              WDESCAT=FUNCAT()  :H="Categoria",;
              WDESMAN=FUNMAN()  :H="Manual Prev.",;
              WDESMAR=FUNMAR()  :H="Marca",;
              WDESMOD=FUNMOD()  :H="Modelo",;
              SERIAL            :H="Serial",;
              WDESADM=FUNADM()  :H="Ubic.administrativa",;
              WDESGEO=FUNGEO()  :H="Ubic.geogr fica",;
              WDESSUP=FUNSUP()  :H="Supervisor de mtto.",;
              WDESOPE=FUNOPE()  :H="Asignado/operado",;
              INIOPE            :H="Inicio operaciones",;
              WDESADML=FUNADML():H="Ubic.adm.anterior",;
              WDESGEOL=FUNGEOL():H="Ubic.geo.anterior";
       NOAPPEND NODELETE NOEDIT NOMENU NOOPTIMIZE REST SAVE IN WINDOW WINDFIC
DEACT WIND WINDFIC
POP KEY
RETURN
************
PROC PROFICI
************
PUSH KEY CLEAR
STORE "INCLUIR" TO WFLAGRFIC
SELECT MTFIC
SET ORDER TO MTFIC
SCATT MEMV BLANK
DO WHILE .T.
   DO GETFIC
   IF LASTKEY()=27
      EXIT
   ENDIF
ENDDO
POP KEY
RETURN
************
PROC PROFICM
************
PUSH KEY CLEAR
STORE "MODIFICAR" TO WFLAGRFIC
IF .NOT. EOF()
   SELECT MTFIC
   SET ORDER TO MTFIC
   SCATT MEMV
   DO GETFIC
ENDIF
POP KEY
RETURN
************
PROC PROFICE
************
IF EOF()
   RETURN
ENDIF
PUSH KEY CLEAR
STORE "ELIMINAR" TO WFLAGRFIC
STORE 2 TO WOP
DO CANCACEP WITH WFLAGRFIC
IF WOP=2
   SELECT MTFIC
   SET ORDER TO MTFIC
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
PROC PROFICO
************
PUSH KEY CLEAR
STORE "ORDENAR" TO WFLAGRFIC
DEFI WIND WINDORD FROM 03,33 TO 06,47;
          TITLE  WFLAGRFIC ;
          DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINDORD
store 1 to wvalop
do while .t.
   @ 00,00 get wvalop pict "@*V  Codigo     ;Descripcion" defa wvalop
   read
   if lastkey()=13
      exit
   endif
enddo
select mtfic
do case
   case wvalop=1
        set order to mtfic
   case wvalop=2
        set order to mtfic2
endcase
RELE WIND WINDORD
POP KEY
RETURN
***********
************
PROC PROFICB
************
PUSH KEY CLEAR
STORE "BUSCAR" TO WFLAGRFIC
DEFI WIND WINDBUS FROM 03,35 TO 05,75;
          TITLE  WFLAGRFIC ;
          DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINDBUS
DO WHILE .T.
   SELECT MTFIC
   STORE SPACE(15) TO WCLAVE
   @ 0,1 GET WCLAVE
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   IF WCLAVE<>SPACE(15)
      SEEK RTRIM(WCLAVE)
      IF FOUND()
         EXIT
      ELSE
         STORE "NO REGISTRADO, REINTENTE" TO WTEXT
         DO AVISO WITH WTEXT
         LOOP
      ENDIF
   ENDIF
ENDDO
RELE WIND WINDBUS
POP KEY
RETURN
***********
PROC GETFIC
***********
DEFI WIND WINDGETF FROM 03,00 TO 20,79;
          TITLE  WFLAGRFIC ;
          DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10
ACTI WIND WINDGETF
DO WHILE .T.
   @ 0,0 CLEAR
   STORE 00 TO WLINFIC
   @ WLINFIC+00,01 SAY "Codigo ...............:"
   @ WLINFIC+01,01 SAY "Descripcion ..........:"
   @ WLINFIC+02,01 SAY "Categoria ............:"
   @ WLINFIC+03,01 SAY "Manual preventivo.....:"
   @ WLINFIC+04,01 SAY "Marca ................:"
   @ WLINFIC+05,01 SAY "Modelo ...............:"
   @ WLINFIC+06,01 SAY "Estatus ..............:"
   @ WLINFIC+07,01 SAY "Serial ...............:"
   @ WLINFIC+08,01 SAY "Ubic. administrativa .:"
   @ WLINFIC+09,01 SAY "Ubic. geografica .....:"
   @ WLINFIC+10,01 SAY "Sup. mantenimiento ...:"
   @ WLINFIC+11,01 SAY "Asignado / operado ...:"
   @ WLINFIC+12,01 SAY "Inicio de operaciones :"
   @ WLINFIC+13,01 SAY "Uso total ............:"
   @ WLINFIC+14,01 SAY "Ubic. adm. anterior ..:"
   @ WLINFIC+15,01 SAY "Ubic. geo. anterior ..:"
   ***
   IF WFLAGRFIC="INCLUIR"
      @ 0,25 GET M.CODFIC
      READ
      IF LASTKEY()=27
         EXIT
      ENDIF
      SELECT MTFIC
      SET ORDER TO MTFIC
      SEEK M.CODFIC
      IF FOUND()
         DO SHOWFIC
         STORE "CODIGO YA EXISTE" TO WTEXT
         DO AVISO WITH WTEXT
         LOOP
      ENDIF
   ELSE
      DO SHOWFIC
   ENDIF
   @ 01,25   GET M.DESFIC     VALID VALDES()
   @ 02,25   GET M.CODCAT     VALID VALCATSE()
   @ 03,25   SAY M.CODMAN     
   @ 04,25   GET M.CODMAR     VALID VALMAR()
   @ 05,25   GET M.CODMOD     VALID VALMOD()
   @ 06,25   GET M.ESTATUS    VALID VALEST()
   @ 07,25   GET M.SERIAL
   @ 08,25   GET M.CODADM     VALID VALADM()
   @ 09,25   GET M.CODGEO     VALID VALGEO()
   @ 10,25   GET M.CODSUP     VALID VALSUP()
   @ 11,25   GET M.CODOPE     VALID VALOPE()
   @ 12,25   GET M.INIOPE
   @ 13,25   GET M.USOOPE
   @ 14,25   GET M.CODADMLAST VALID VALADML()
   @ 15,25   GET M.CODGEOLAST VALID VALGEOL()
   READ
   ******************************************
   IF LASTKEY()=27
      EXIT
   ENDIF
   STORE 1 TO WOP
   DO ACEPCANC WITH WFLAGRFIC
   SELECT MTFIC
   SET ORDER TO
   IF WOP=1
      IF WFLAGRFIC="INCLUIR"
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
RELE WIND WINDGETF
RETURN
************
PROC SHOWFIC
************
@ 0,25 SAY M.CODFIC
@ WLINFIC+02,36 SAY FUNCAT()
@ WLINFIC+03,36 SAY FUNMAN()
@ WLINFIC+04,36 SAY FUNMAR()
@ WLINFIC+05,36 SAY FUNMOD()
*@ WLINFIC+06,36 SAY FUNEST()
@ WLINFIC+08,36 SAY FUNADM()
@ WLINFIC+09,36 SAY FUNGEO()
@ WLINFIC+10,36 SAY FUNSUP()
@ WLINFIC+11,36 SAY FUNOPE()
@ WLINFIC+13,40 SAY FUNUNI()
@ WLINFIC+14,36 SAY FUNADML()
@ WLINFIC+15,36 SAY FUNGEOL()
RETURN
***********
PROC MTAEJE
***********
STORE "EJE" TO WFLAGMAN
DO MTAMAN
RETURN
***********
PROC MTAHIS
***********
STORE "HIS" TO WFLAGMAN
DO MTAMAN
RETURN
************

