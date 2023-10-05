#Include 'totvs.ch'
#Include 'topconn.ch'
/*
*******************************************************************************************************************************
*** Funcao: MTA160MNU   -   Autor: Leonardo Pereira   -   Data:                                                             ***
*** Descricao: Adiciona nova rotina ao menu de contexto da rotina de analise de cotacao.                                    ***
*******************************************************************************************************************************
*/


/*
*******************************************************************************************************************************
*** Funcao: WF150ANA   -   Autor: Leonardo Pereira   -   Data:                                                             ***
*** Descricao: Verifica se é possivel a analise da cotacao.                                                                ***
*******************************************************************************************************************************
*/
User Function WF160Ana()

	Local cDirSRVCOT
	Local aArqCOT := {}
	Local lRet := .T.
	Local nRecSC8 := 0
	
	If (SC8->C8_FLAGWF == '2')
		MsgAlert('Cotacao REJEITADA!, Nao e possivel realizar analise!', 'Atencao!')
		Return
	EndIf
	
	/*/ Realiza o ranking do mapa de cotacao /*/
	SCR->(DbGoTop())
	SCR->(DbSetOrder(2))
	If SCR->(DbSeek(xFilial('SCR') + 'MC' + SC8->C8_NUM + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))))
		SCR->(DbSetOrder(1))
		nRecSC8 := SCR->(Recno())
		While SCR->(!Eof()) .And. (AllTrim(SCR->CR_NUM) == SC8->C8_NUM)
			If (SCR->CR_STATUS == '02')
				lRet := .F.
				Exit
			EndIf
			SCR->(DbSkip())
		End
	EndIf
	
	If lRet
		nPos := aScan(aRotina, {|x| x[4]== 6})
		If (nPos <> 0)
			bBlock := &('{ |x,y,z,k,m| ' + 'A160Analis' + '(x,y,z,k,m) }')
			Eval(bBlock, Alias(), SC1->(Recno()), nPos, Nil)
			lRet := .T.
		EndIf
	EndIf
	If nRecSC8 > 0
		SCR->(DbGoTo(nRecSC8))
	Endif
		
	// cDirSRVCOT := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\rankeados\'

	// aDir(cDirSRVCOT + '*.ret', aArqCOT)

	/*/ Faz a leitura dos arquivos baixados. /*/
	/*/
	If !(Empty(aArqCOT))
		For nX := 1 To Len(aArqCOT)
			If (SubStr(aArqCOT[nX], 3, 6) == cEmpAnt + cFilAnt)
				// Verifica se o arquivo corresponde a cotacao selecionada 
				If (SubStr(aArqCOT[nX], 15, 6) == SC8->C8_NUM)
					nPos := aScan(aRotina, {|x| x[4]== 6})
					If (nPos <> 0)
						bBlock := &('{ |x,y,z,k,m| ' + 'A160Analis' + '(x,y,z,k,m) }')
						Eval(bBlock, Alias(), SC1->(Recno()), nPos, Nil)
						lRet := .T.
					EndIf
				EndIf
			EndIf
		Next
	EndIf
	/*/
	
	If lRet
		SC7->(DbSetOrder(14))
		If (SC7->(DbSeek(SC8->C8_FILIAL + SC8->C8_NUMPED)))
			While SC7->(!Eof()) .And. (SC7->C7_NUM == SC8->C8_NUMPED)
				SC7->(RecLock('SC7', .F.))
				SC7->C7_FILIAL := SC8->C8_FILIAL
				SC7->(MsUnLock())
				SC7->(DbSkip())
			End
		EndIf
	EndIf
	
	If !(lRet)
		MsgAlert('O RANKING desta cotacao ainda nao foi finalizado!', 'Atencao!')
	EndIf
	
Return