#Include 'totvs.ch'
/*
******************************************************************************************************
*** Funcao: MTA130C8  -   Autor: Leonardo Pereira   -   Data:                                      ***
*** Descricao: Adiciona cores de status e descricao de leganda na rotina de atualizacao de cotacao.***
******************************************************************************************************
*/
User Function Mta130C8()
	
	/***********************DESCONTINUAO NO P12********************/
	
	Local aArea := GetArea()
	
	DbSelectArea('SC1')
	DbSelectArea('SC8')

	SC8->(RecLock('SC8', .F.))
	SC8->C8_XCO := SC1->C1_XCO 		// Conta orcamentaria.
	SC8->C8_XNAT := SC1->C1_XNAT		// Natureza financeira.
	SC8->C8_CONAPRO := 'B'				// Flag de controle de aprovacao 
	SC8->C8_XUSER := __cUserID			// Codigo do usuario
	SC8->C8_OBS := SC1->C1_OBS			// Observacao	

	/*/ Procura grupo de aprovacao /*/
	CTT->(DbSetorder(1))
	If CTT->(DbSeek(xFilial('CTT') + SC1->C1_CC))
		SC8->C8_APROV := AllTrim(CTT->CTT_XGPCMP)	// Grupo de aprovacao
	EndIf
	SC8->(MsUnLock())

	RestArea(aArea)

Return
