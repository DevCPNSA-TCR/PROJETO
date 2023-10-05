#INCLUDE "rwmake.ch"

/*/
----------------------------------------------------------------------------
Programa  FA050PIS()� Autor � Roberto Santana            � Data �  05/09/12   
----------------------------------------------------------------------------
Descricao  Ponto de entrada para atualiza��o dos campos �tem cont�bil e 
           centros de custos nos t�tulos de PIS gerados automaticamente. 
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