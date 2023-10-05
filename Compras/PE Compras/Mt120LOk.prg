#Include 'totvs.ch'
/*
*******************************************************************************************************************************
*** Funcao: MT120LOK   -   Autor: Leonardo Pereira   -   Data: 01/11/2010.                                                  ***
*** Descricao: Realiza a validacao dos dados digitados na linha do grid da tela de solicitacoes.                            ***
*******************************************************************************************************************************
*** Alterado em 30/06/2017 por Ricardo Ferreira - Busca grupo de aprovação pela tabela DBL (entidades contáveis x Grupo Apr)***
*******************************************************************************************************************************
*/
User Function Mt120LOk()

	Local lRet := .T.
	Local nPGrApr 	:= aScan(aHeader, {|x| AllTrim(x[2]) == 'C7_APROV'})
	Local nPNumSC 	:= aScan(aHeader, {|x| AllTrim(x[2]) == 'C7_NUMSC'})
	Local nPCodCC 	:= aScan(aHeader, {|x| AllTrim(x[2]) == 'C7_CC'})
	Local cGrupo 	:= ""
	Local cCusto	:= ""
	
	If (AllTrim(FunName()) == 'CNTA120')
		Return(lRet)
	EndIf

	/*/ Procura grupo de aprovacao /*/
	If !Empty(aCols[n, nPNumSC])
		SC1->(DbSetOrder(1))
		If SC1->(DbSeek(xFilial('SC1') + aCols[n, nPNumSC]))
			/*
			Alterado por Ricardo Ferreira em  30/06/2017
			//Alteração para tabela padrão DBL
			CTT->(DbSetorder(1))
			If CTT->(DbSeek(xFilial('CTT') + SC1->C1_CC))
			If !Empty(AllTrim(CTT->CTT_XGPCMP))
			aCols[n, nPGrApr] := AllTrim(CTT->CTT_XGPCMP)
			Else
			MsgAlert('N?o existe GRUPO DE APROVA??O associado ao CENTRO DE CUSTO: ' + AllTrim(SC1->C1_CC) + '.', 'Atencao!')
			lRet := .F.
			EndIf
			EndIf
			*/
			cCusto := SC1->C1_CC 
			

		EndIf
	Else

		/*
		Alterado por Ricardo Ferreira em  30/06/2017
		//Alteração para tabela padrão DBL
		CTT->(DbSetorder(1))
		If CTT->(DbSeek(xFilial('CTT') + aCols[n, nPCodCC]))
		If !Empty(AllTrim(CTT->CTT_XGPCMP))
		aCols[n, nPGrApr] := AllTrim(CTT->CTT_XGPCMP)
		Else
		MsgAlert('N?o existe GRUPO DE APROVA??O associado ao CENTRO DE CUSTO: ' + AllTrim(aCols[n, nPCodCC]) + '.', 'Atencao!')
		lRet := .F.
		EndIf
		EndIf
		*/
		cCusto := aCols[n, nPCodCC] 
		

	EndIf
	cGrupo := u_RetGrpCC(cCusto)
	If !Empty(cGrupo)
		aCols[n, nPGrApr] := AllTrim(cGrupo)
	Else
		MsgAlert('Não existe GRUPO DE APROVAÇÃO associado ao CENTRO DE CUSTO: ' + AllTrim(cCusto) + '.', 'Atenção!')
		lRet := .F.
	EndIf


Return(lRet)
