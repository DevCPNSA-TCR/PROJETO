#include 'protheus.ch'
#include 'parmtype.ch'
/*
Ricardo Ferreira - Criare Consulting
Atualizar a tabela DBL - Amarração grupos de aprovação x entidades 
*/

user function ATUDBL()

Alert("Atualizar DBL")

BeginSQl Alias "CTTTMP"
%noparser%
SELECT CTT_FILIAL,CTT_CUSTO,CTT_XGPCMP from CTT010 WHERE CTT_XGPCMP <> ' '
ORDER BY CTT_XGPCMP

EndSql

While !CTTTMP->(Eof())

	RecLock("DBL",.t.)
	DBL->DBL_FILIAL := CTTTMP->CTT_FILIAL
	DBL->DBL_GRUPO 	:= CTTTMP->CTT_XGPCMP
	DBL->DBL_ITEM	:= "01"
	DBL->DBL_CC		:= CTTTMP->CTT_CUSTO
	MSUnlock()
	
	CTTTMP->(DbSkip())
Enddo

Alert("Finalizou!")


	
return