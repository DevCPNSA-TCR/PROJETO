#INCLUDE "rwmake.ch"

/*/
----------------------------------------------------------------------------
Programa  FA050CSL()º Autor ³ Roberto Lima          º Data ³  05/09/12   
----------------------------------------------------------------------------
Descricao  Ponto de entrada para atualização dos campos ítem contábil, 
           centros de custos e históricos nos títulos de CSLL gerados 
           automaticamente. 
----------------------------------------------------------------------------
/*/

User Function F050CSL()
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
   SE2->E2_CODRET := '5987'
MsUnlock()   

Return