#include "Protheus.ch"

User Function valcbar(cCodBar)
Local lRet := .t.
cCodBar := U_CONVLD(cCodBar)

BeginSql Alias "CODBAR"
%noparser% 

select count(*) CONT  
FROM %table:SE2010% SE2
WHERE	E2_CODBAR = %exp:cCodBar% and
		SE2.%notdel%
EndSql	

If CODBAR->CONT > 0
	lRet := .f.
	Alert("O c�digo de barras j� foi informado em outro t�tulo!!!")
Endif

DbSelectArea("CODBAR")
DbCloseArea()


RETURN(lRet)
