cHaving = ""  
IF EMPTY(WCODFIC)
   CHAVING= "!EMPTY(mtaxfh.CODFIC)"
ELSE
   CHAVING= "mtaxfh.CODFIC = WCODFIC"
ENDIF
IF !EMPTY(WDESDE)
   CHAVING = CHAVING+ " .AND. BETWEEN(mtaxfh.FECPRO,WDESDE,WHASTA)"
ENDIF
 *select mtaxfh
 *browse
 SELECT mtaxfh.CODFIC, mtaxfh.CODSEC, mtaxfh.CODPLA, mtaxfh.CODACT, mtaxfh.CODCAT, mtaxfh.FECPRO, mtaxfh.USOPRO, mtaxfh.FECEJE, mtaxfh.USOEJE, mtaxfh.COSTO,;
  MTACT.DESACT1,MTACT.DESACT2,MTACT.DESACT3,MTACT.DESACT4,MTACT.DESACT5,;
   MTSEC.DESSEC ;
    FROM MTAXFH,MTACT,MTSEC ;
     WHERE mtaxfh.CODCAT+mtaxfh.CODSEC+mtaxfh.CODACT = MTACT.CODCAT+MTACT.CODSEC+MTACT.CODACT ;
      AND mtaxfh.CODCAT+mtaxfh.CODSEC = MTSEC.CODCAT+MTSEC.CODSEC;
       HAVING &cHaving ;
        ORDER BY mtaxfh.CODFIC,mtaxfh.CODCAT,mtaxfh.CODPLA,mtaxfh.CODSEC,mtaxfh.CODACT ;
         INTO CURSOR XPEPE
SELECT XPEPE
IF WSALIDA = 1
   report form MTRHIS PREVIEW 
ELSE
   report form MTRHIS TO PRINTER
ENDIF
SELECT XPEPE
USE

