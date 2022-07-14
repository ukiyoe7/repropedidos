## Bibliotecas necessárias

library(DBI)
library(dplyr)


## conexão com banco replica 

con2 <- dbConnect(odbc::odbc(), "reproreplica")



library(tidyverse)

#CURRENT MONTH

pedidos <- dbGetQuery(con2,"
  
 WITH CLI AS (SELECT DISTINCT C.CLICODIGO,
                       CLINOMEFANT,
                        ENDCODIGO,
                         GCLCODIGO,
                         SETOR
                          FROM CLIEN C
                           LEFT JOIN (SELECT CLICODIGO,E.ZOCODIGO,ZODESCRICAO SETOR,ENDCODIGO FROM ENDCLI E
                            LEFT JOIN (SELECT ZOCODIGO,ZODESCRICAO FROM ZONA WHERE ZOCODIGO IN (20,21,22,23,24,25,28))Z ON E.ZOCODIGO=Z.ZOCODIGO WHERE ENDFAT='S')A ON C.CLICODIGO=A.CLICODIGO
                             WHERE CLICLIENTE='S'),

  
  PED AS (SELECT ID_PEDIDO,
                  TPCODIGO,
                   PEDDTEMIS,
                    PEDDTBAIXA,
                     P.CLICODIGO,
                      GCLCODIGO,
                       CLINOMEFANT,
                        PEDORIGEM
                         FROM PEDID P
                          LEFT JOIN CLI C ON P.CLICODIGO=C.CLICODIGO AND P.ENDCODIGO=C.ENDCODIGO
                           WHERE PEDDTEMIS BETWEEN '01.07.2022' AND 'TODAY' AND PEDSITPED<>'C')
  
  
    SELECT PD.ID_PEDIDO,
            TPCODIGO,
             PEDDTEMIS,
              PEDDTBAIXA,
               CLICODIGO,
                CLINOMEFANT,
                 GCLCODIGO,
                  PEDORIGEM,
                   FISCODIGO,
                    PROCODIGO,
                     PDPDESCRICAO,
                      PDPPCOUNIT,
                       SUM(PDPQTDADE)QTD,
                        SUM(PDPUNITLIQUIDO*PDPQTDADE)VRVENDA 
                         FROM PDPRD PD
                          INNER JOIN PED P ON PD.ID_PEDIDO=P.ID_PEDIDO
                           GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12 ORDER BY ID_PEDIDO DESC")  


View(pedidos)