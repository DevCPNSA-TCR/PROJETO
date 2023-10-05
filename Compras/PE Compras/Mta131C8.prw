#Include 'totvs.ch'
/*
******************************************************************************************************
*** Funcao: MTA131C8  -   Autor: Ricardo Ferreira	   -   Data: 29/06/2017                        ***
*** Descricao: Adiciona cores de status e descricao de leganda na rotina de atualizacao de cotacao.***
******************************************************************************************************
*/


User Function MTA131C8()
	Local oModFor := PARAMIXB[1]
	
	
	//Customizações do usuario
	oModFor:LoadValue("C8_XCO",SC1->C1_XCO)
	oModFor:LoadValue("C8_XNAT",SC1->C1_XNAT)
	oModFor:LoadValue("C8_CONAPRO",'B')
	oModFor:LoadValue("C8_XUSER",__cUserID)
	oModFor:LoadValue("C8_OBS",SC1->C1_OBS)
	oModFor:LoadValue("C8_MOEDA",1)

	// Procura grupo de aprovacao 
	/*
	Alterado por Ricardo Ferreira - Criare Consulting
	Tratamento sendo feito no MT131WF
	CTT->(DbSetorder(1))
	If CTT->(DbSeek(xFilial('CTT') + SC1->C1_CC))
		oModFor:LoadValue("C8_APROV",CTT->CTT_XGPCMP)	// Grupo de aprovacao
	EndIf
	*/

Return