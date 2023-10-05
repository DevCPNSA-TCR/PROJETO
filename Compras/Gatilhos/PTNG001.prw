#include 'protheus.ch'
#include 'parmtype.ch'

/*
****************************************************************************************************
*** Funcao: PTNG001   -   Autor: Ricardo Ferreira - Criare Consulting   -   Data:06/07/2017      ***
*** Descricao: Gatilho executado no campo AL_NIVEL para preencher com 0 com 2 caracteres         ***
****************************************************************************************************
*/

User function PTNG001()
Local cRet	:= ""
	oModel := FWModelActive()
	
	oModelSAL := oModel:getModel("DetailSAL")
	
	
	
	oModelSAL:SetValue("AL_NIVEL",strzero(Val(oModelSAL:GetValue("AL_NIVEL")),2))
	
	
	
return 