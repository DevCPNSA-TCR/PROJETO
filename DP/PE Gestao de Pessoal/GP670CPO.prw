#INCLUDE "rwmake.ch"

User Function GP670CPO()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de Variaveis                                             � 
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

dbSelectArea("SE2")
dbSetOrder(1)
Reclock("SE2",.F.)


SE2->E2_CCD     := RC1->RC1_CC
SE2->E2_HIST    := RC1->RC1_DESCRI 	

/* inserido por Felipe do Nascimento - 29/08/2014
   objetivo � atender a solicita豫o do Sispag que depende do c�digo de reten豫o no titulo
*/   
SE2->E2_CODRET	:=	posicione("SED",1,xFilial("SED")+SE2->E2_NATUREZ,"ED_XCODRET") 

Msunlock()

Return  