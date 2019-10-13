set proc to MTPROC
*** INI CONTROL DE ACCESO
SELECT 20
USE SYSUSERD INDEX SYSUSERD
STORE "MTMENU " TO WPROGRAMA
STORE SPACE(1)  TO WACCESO
DO CHKACC WITH WUSERCODE,WPROGRAMA,WACCESO
IF WACCESO=" "
   RETURN
ENDIF
USE
*** FIN CONTROL DE ACCESO

store "Mantenimiento" to wmodulo
@ 2,01 say space(38)
@ 2,01 say wmodulo

SELECT 1
USE MTCONF
STORE MASKCAT               TO WMASKCAT
STORE LEN(ALLTRIM(MASKCAT)) TO WLARGCAT
STORE MASKEST               TO WMASKSEC
STORE LEN(ALLTRIM(MASKEST)) TO WLARGSEC

*** CATEGORIAS
SELECT 2
USE MTCAT  INDEX MTCAT1,MTCAT2

*** SECCIONES DE CATEGORIAS
SELECT 3
USE MTSEC  INDEX MTSEC1,MTSEC2

*** PLANES POR CATEGORIAS
SELECT 4
USE MTPLA  INDEX MTPLA1,MTPLA2

*** ACTIVIDADES  POR SECCIONES Y POR PLAN
SELECT 5
USE MTACT  INDEX MTACTXS,MTACTXP

*** TIPOS DE ACTIVIDADES
SELECT 6
USE MTTACT INDEX MTTACT

*** FICHAS DE EQUIPOS
SELECT 7
USE MTFIC INDEX MTFIC,MTFIC2,MTFIC3,MTFIC4,MTFIC5

*** ACTIVIDADES POR EQUIPO
SELECT 8
USE MTAXF INDEX MTAXFS, MTAXFP

*** HISTORICO
SELECT 9
USE MTAXFH INDEX MTAXFHS, MTAXFHP

STORE SPACE(1) TO T7
STORE .T. TO WJUMPING
***************************************
define menu menucon bar at line 3 shadow
*      define pad padcon00 of menucon prompt "\<Sistema" skip
       define pad padcon01 of menucon prompt "\<Usuario" skip
       define pad padcon02 of menucon prompt "\<Modulo " skip
       define pad padcon03 of menucon prompt "\<Tabla  "
       define pad padcon04 of menucon prompt "\<Equipo "
       define pad padcon05 of menucon prompt "\<Reporte"
       define pad padcon06 of menucon prompt "\<Otros  "
       define pad padcon07 of menucon prompt "\<Salir  "
       on pad padcon03 of menucon activate popup subcon03
       on pad padcon04 of menucon activate popup subcon04
       on pad padcon05 of menucon activate popup subcon05
       on pad padcon06 of menucon activate popup subcon06
       on sele pad padcon07 of menucon RETURN
       DEFINE POPUP subcon03 FROM 4,30 shadow
              DEFINE BAR 01 OF subcon03 PROMPT "      Configuracion          " SKIP
              DEFINE BAR 02 OF subcon03 PROMPT "\<Formato de c¢digos         "
              DEFINE BAR 03 OF subcon03 PROMPT "         Codigos             " SKIP
              DEFINE BAR 04 OF subcon03 PROMPT "\<Tipos de actividades       "
              DEFINE BAR 05 OF subcon03 PROMPT "ubic. \<Administrativas      "
              DEFINE BAR 06 OF subcon03 PROMPT "ubic. \<Geogr ficas          "
              DEFINE BAR 07 OF subcon03 PROMPT "ma\<Rcas                     "
              DEFINE BAR 08 OF subcon03 PROMPT "mo\<Delos                    "
              DEFINE BAR 09 OF subcon03 PROMPT "\<Personal                   "
           *   DEFINE BAR 10 OF subcon03 PROMPT "tipos de \<Insumos           "
           *   DEFINE BAR 11 OF subcon03 PROMPT "in\<Sumos                    "
              ON SELECTION POPUP subcon03 DO subcon03 WITH BAR()
       DEFINE POPUP subcon04 FROM 4,40 shadow
              DEFINE BAR 01 OF subcon04 PROMPT "\<Manuales de Mantenimiento"
              DEFINE BAR 02 OF subcon04 PROMPT "\<Fichas de Equipos        "
              ON SELECTION POPUP subcon04 DO subcon04 WITH BAR()
       DEFINE POPUP subcon05 FROM 4,50 shadow
              DEFINE BAR 01 OF subcon05 PROMPT "Manuales                   "
              DEFINE BAR 02 OF subcon05 PROMPT "Fichas de Equipos          "
              DEFINE BAR 03 OF subcon05 PROMPT "Planificacion              "
              DEFINE BAR 04 OF subcon05 PROMPT "Programacion por fechas    "
              DEFINE BAR 05 OF subcon05 PROMPT "Programacion por uso       "
              DEFINE BAR 06 OF subcon05 PROMPT "Historico de Ejecucion     "
              ON SELECTION POPUP subcon05 DO subcon05 WITH BAR()
       DEFINE POPUP subcon06 FROM 4,70 shadow
              DEFINE BAR 01 OF subcon06 PROMPT "\<Reorganizar indices        "
              DEFINE BAR 02 OF subcon06 PROMPT "\<Compactar tablas de datos  "
              ON SELECTION POPUP subcon06 DO subcon07 WITH BAR()
*** ACTIVACION DEL MENU DE bancos
do while .t.
   ACTIVATE MENU menucon 
enddo
RELEASE menucon
RETURN

******************
PROCEDURE subcon03
******************
PARAMETERS SELBAR
save scre to wscre01
hide menu menucon
push key clear
@ 4,0 CLEAR
DO CASE
   CASE SELBAR = 2
        do mtconf
   CASE SELBAR = 4
        do mtatact
   CASE SELBAR = 5
        do mtaadm
   CASE SELBAR = 6
        do mtageo
   CASE SELBAR = 7
        do mtamar
   CASE SELBAR = 8 
        store space(10) to wfiltro
        store .f.       to wvalor
        do mtamod
   CASE SELBAR = 9 
        do mtaper
  * CASE SELBAR = 10
  *      do mtatins
  * CASE SELBAR = 11
  *      store space(10) to wfiltro
  *      store .t.       to wvalor
  *      do mtains
ENDCASE
pop key
show menu menucon
restore scre from wscre01
RETURN

******************
PROCEDURE subcon04
******************
PARAMETERS SELBAR
save scre to wscre01
hide menu menumain
hide menu menucon
push key clear
DO CASE
   CASE SELBAR = 1
        DO mtacym
   CASE SELBAR = 2
        DO mtafic
ENDCASE
restore scre from wscre01
show menu menumain
show menu menucon
pop key
RETURN

******************
PROCEDURE subcon05
******************
PARAMETERS SELBAR
save scre to wscre01
hide menu menumain
hide menu menucon
push key clear
DO CASE
   CASE SELBAR =1
        DO mtrcat
   CASE SELBAR = 2
        
   CASE SELBAR = 3
        DO mtrpla
   CASE SELBAR = 4
        DO mtrpro
   CASE SELBAR = 5
        DO mtruso
   CASE SELBAR = 6
        DO mtreje
ENDCASE
restore scre from wscre01
show menu menumain
show menu menucon
pop key
RETURN             
            
******************
PROCEDURE subcon06
******************
PARAMETERS SELBAR
save scre to wscre01
hide menu menucon
push key clear
DO CASE
   CASE SELBAR = 1
   CASE SELBAR = 2
ENDCASE
save scre to wscre01
hide menu menucon
push key clear
RETURN

******************
PROCEDURE subcon07
******************
PARAMETERS SELBAR
save scre to wscre01
hide menu menucon
push key clear
DO CASE
   CASE SELBAR = 1
        DO INDICES
   CASE SELBAR = 2
        DO COMPACTA
ENDCASE
save scre to wscre01
hide menu menucon
push key clear
RETURN
***

