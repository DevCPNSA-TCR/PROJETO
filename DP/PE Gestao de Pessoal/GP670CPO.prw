#INCLUDE "rwmake.ch"

User Function GP670CPO()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SE2")
dbSetOrder(1)
Reclock("SE2",.F.)


SE2->E2_CCD     := RC1->RC1_CC
SE2->E2_HIST    := RC1->RC1_DESCRI 	

/* inserido por Felipe do Nascimento - 29/08/2014
   objetivo é atender a solicitação do Sispag que depende do código de retenção no titulo
*/   
SE2->E2_CODRET	:=	posicione("SED",1,xFilial("SED")+SE2->E2_NATUREZ,"ED_XCODRET") 

Msunlock()

Return  