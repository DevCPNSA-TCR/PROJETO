#INCLUDE "rwmake.ch"

/*/
----------------------------------------------------------------------------
Programa  FA050INS()� Autor � Roberto Lima            � Data �  05/09/12   
----------------------------------------------------------------------------
Descricao  Ponto de entrada para atualiza��o dos campos �tem cont�bil, 
           centros de custos e hist�ricos nos t�tulos de INSS gerados 
           automaticamente. 
----------------------------------------------------------------------------
/*/

User Function F050INS()
PRIVATE nRegistro, aArea, cItemConta, cCentroCusto, cHistorico  

aArea := getarea()

DbSelectArea("SE2")
nRegistro := PARAMIXB
DBGOTO(nRegistro) 

cItemConta   := SE2->E2_ITEMD
cCentroCusto := SE2->E2_CCD 
cHistorico   := SE2->E2_HIST
 
restarea(aArea)

Reclock("SE2", .F.)
   SE2->E2_ITEMD := cItemConta
   SE2->E2_CCD   := cCentroCusto 
   SE2->E2_HIST  := cHistorico  
MsUnlock()   

Return