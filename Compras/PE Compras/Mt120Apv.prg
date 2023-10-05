#Include 'totvs.ch'
/*
*******************************************************************************************************************************
*** Funcao: MT120APV   -   Autor: Leonardo Pereira   -   Data: 01/11/2010.                                                  ***
*** Descricao: Realiza a manipulacao do grupo de aprovacao do pedido de compras.                                            ***
*******************************************************************************************************************************
*/
User Function Mt120Apv()

	Local cRet := ''
	Local aAreaSC7 := SC7->(GetArea())
	Local aAreaSM0 := SM0->(GetArea())

	If (AllTrim(FunName()) == 'CNTA120')
		Return(cRet)
	EndIf
	
	If (AllTrim(FunName()) == 'CNTA121')
		SC7->(RecLock("SC7", .f.))
		SC7->C7_CONAPRO := 'L'
		SC7->(MsUnlock())
		Return(cRet)
	EndIf

	// Procura grupo de aprovacao
	/*
	//Alterado por Ricardo Ferreira em 30/06/2017
	//Alterar para pegar da tabela Padrão DBL 
	CTT->(DbSetorder(1))
	If CTT->(DbSeek(xFilial('CTT') + SC7->C7_CC))
		cRet := AllTrim(CTT->CTT_XGPCMP)
	EndIf
	*/
	
	//Chama a função que busca o grupo responsável pelo Centro de custos.
	cRet := u_RetGrpCC(SC7->C7_CC)
	
	
	RestArea(aAreaSC7)
	RestArea(aAreaSM0)

Return(cRet)


User Function RetGrpCC(cCusto)
	Local cGrupo := ""

	BeginSQL Alias "TMPDBL"
	%noparser%
	SELECT DBL_GRUPO FROM %table:DBL% DBL
	WHERE DBL.%notdel% AND DBL_FILIAL = %xfilial:DBL% AND DBL_CC = %exp:cCusto% AND DBL_CONTA  = ' ' AND DBL_ITEMCT = ' ' AND DBL_CLVL = ' '
	EndSql

	If !TMPDBL->(Eof())
		cGrupo := TMPDBL->DBL_GRUPO
		
	Endif
	DbSelectArea("TMPDBL")
	DbCloseArea()
Return cGrupo
