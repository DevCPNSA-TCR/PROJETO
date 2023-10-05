#INCLUDE "rwmake.ch"

/*/
----------------------------------------------------------------------------
Programa  FA050PIS()º Autor ³ Roberto Santana            º Data ³  05/09/12   
----------------------------------------------------------------------------
Descricao  Ponto de entrada para atualização dos campos ítem contábil e 
           centros de custos nos títulos de PIS gerados automaticamente. 
----------------------------------------------------------------------------
/*/

User Function F050PIS()
PRIVATE nRegistro, aArea, cItemConta, cCentroCusto, cHistorico

aArea := getarea()

DbSelectArea("SE2")
nRegistro := PARAMIXB
DBGOTO(nRegistro) 

cItemConta   := SE2->E2_ITEMD
cCentroCusto := SE2->E2_CCD  
cHistorico   := SE2->E2_HIST  

restarea(aArea)