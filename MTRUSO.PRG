DEFI WIND WINDDP1 FROM 03,00 TO 08,79 ;
                 TITLE " PROGRAMACION POR USO";
                 DOUBLE NOFLOAT NOZOOM NOGROW SHADOW COLOR SCHEME 10

do while .t.
   acti wind winddp1
   @ 0,0 clear
   @ 01,02 SAY "Codido equipo       :"
   @ 02,02 SAY "Salida de datos     :"
   @ 03,02 SAY "Opciones            :"
   STORE "REPORTE DE PROGRAMACION POR USO" TO WREPORTNAME
   STORE SPACE(LEN(MTFIC.CODFIC)) TO WCODFIC
   @ 01,25 GET WCODFIC
   READ
   IF LASTKEY()=27
      EXIT
   ENDIF
   store 1 to wop
   do while .t.
      @ 02,25 get wop pict "@*H  Monitor ;Impresora"
      read
     if lastkey()=13
         exit
     endif
   enddo
   store wop to wsalida
   store 1 to wop
   do while .t.
      @ 03,25 get wop pict "@*H  Aceptar ;Cancelar "
      read
     *if lastkey()=13
         exit
     *endif
   enddo
   store wop to wopciones
   if wopciones=1
      DEFI WIND WINDDP2 FROM 00,00 TO 22,79
      deac wind winddp1
      acti wind winddp2
      do mtrusod
      deac wind winddp2
      acti wind winddp1
   endif
   exit
enddo
deac wind winddp1
return


