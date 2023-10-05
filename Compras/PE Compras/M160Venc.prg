#Include 'totvs.ch'
#Include 'topconn.ch'
/*
******************************************************************************************************
*** Funcao: M160VENC   -   Autor: Leonardo Pereira   -   Data:                                     ***
*** Descricao: Processa o retorno do ranking do mapara de cotacao.                                 ***
******************************************************************************************************
*/
User Function M160VENC()

	Local aSCE := aClone(ParamIXB[1])
	Local aPlanilha := aClone(ParamIXB[2])
	Local aCotacao := aClone(ParamIXB[3])
	Local aAreaSC8 := SC8->(GetArea())
	Local nPQtdSC8 := 0
	Local nPosRecno := 0
	//Local nX := 0
	Local nY := 0
	local nZ := 0
	
	Private aDadosTXT := {}
	
	If (mv_par18 == 1)
		MsgRun('P R O C E S S A N D O    R A N K I N G. . .', 'A g u a r d e...', { |lEnd| WFRknPro1() })
		
		If (Len(aDadosTXT) == 0)
			MsgAlert('O RANKING desta cotacao ainda nao foi finalizado' + Chr(13) +;
				'Serao UTILIZADOS os parametros da rotina.', 'Atencao!')
		Return({aSCE, aPlanilha})
		EndIf
		
		For nZ := 1 To Len(aCotacao[Len(aCotacao)])
			nPQtdSC8 := aScan(aCotacao[Len(aCotacao)][nZ], {|x| AllTrim(x[1]) == 'C8_QUANT'})
			nPosRecno := aScan(aCotacao[Len(aCotacao)][nZ], {|x| AllTrim(x[1]) == 'SC8RECNO'})
			nPosFor := aScan(aCotacao[Len(aCotacao)][nZ], {|x| AllTrim(x[1]) == 'C8_FORNECE'})
			nPosLoj := aScan(aCotacao[Len(aCotacao)][nZ], {|x| AllTrim(x[1]) == 'C8_LOJA'})

			DbSelectArea('SC8')
			SC8->(MsGoto(aCotacao[Len(aCotacao)][nZ][nPosRecno][2]))
			
			For nY := 1 to Len(aPlanilha)				
				If (Alltrim(aPlanilha[nY][nZ][2] + aPlanilha[nY][nZ][3]) == AllTrim(SubStr(aDadosTxt[1], 1, 6)) + AllTrim(SubStr(aDadosTxt[1], 8, 2)))
					aPlanilha[nY][nZ][1] := 'XX'
				Else
					aPlanilha[nY][nZ][1] := ''
				EndIf
	
				If (Alltrim(aSCE[nY][nZ][2] + aSCE[nY][nZ][3]) == AllTrim(SubStr(aDadosTxt[1], 1, 6)) + AllTrim(SubStr(aDadosTxt[1], 8, 2)))
					aSCE[nY][nZ][4] := aCotacao[nY][nZ][nPQtdSC8][2]
					aSCE[nY][nZ][5] := 'ESCOLHA DO GESTOR: ' + Upper(aDadosTxt[2])
					aSCE[nY][nZ][7] := 1
				Else
					aSCE[nY][nZ][4] := 0
					aSCE[nY][nZ][5] := ''
					aSCE[nY][nZ][7] := 0
				EndIf
			next nY	

		Next
	EndIf
	
	RestArea(aAreaSC8)

Return({aSCE, aPlanilha})

/*
*******************************************************************************************************************************
*** Funcao: WFRKNPRO1   -   Autor: Leonardo Pereira   -   Data:                                                             ***
*** Descricao: Processa o retorno do ranking do mapara de cotacao.                                                          ***
*******************************************************************************************************************************
*/
Static Function WFRknPro1()

	Local aAreaSC8 := SC8->(GetArea())
	Local cNumCOT := SC8->C8_NUM
	Local lLiber := .T.
	Local nRecSC8

	/*/ Posiciona na tabela de cotacoes /*/
	SC8->(DbGoTop())
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(xFilial('SC8') + cNumCOT))

	/*/ Realiza o ranking do mapa de cotacao /*/
	SCR->(DbGoTop())
	SCR->(DbSetOrder(2))
	If SCR->(DbSeek(xFilial('SCR') + 'MC' + SC8->C8_NUM + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))))
		SCR->(DbSetOrder(1))
		While SCR->(!Eof()) .And. (AllTrim(SCR->CR_NUM) == SC8->C8_NUM)
			If (SCR->CR_STATUS == '02')
				lLiber := .F.
			EndIf
			nRecSC8 := SCR->(Recno())
			SCR->(DbSkip())
		End
		
		If lLiber
			SCR->(DbGoTo(nRecSC8))
			/*/ Coleta informacoes do usuario /*/
			PswOrder(1)
			aInfoUsu := {}
			If (PswSeek(AllTrim(SCR->CR_USERLIB), .T.))
				aInfoUsu := PswRet(1)
			EndIf
			aAdd(aDadosTXT, SCR->CR_RKN1)
			If (Len(aInfoUsu) > 0)
				aAdd(aDadosTXT, AllTrim(aInfoUsu[1, 2]))
			Else
				aAdd(aDadosTXT, '')
			EndIf
			
			/*/ Posiciona na tabela de cotacoes /*/
			SC8->(DbGoTop())
			SC8->(DbSetOrder(1))
			SC8->(DbSeek(xFilial('SC8') + cNumCOT))
			While SC8->(!Eof()) .And. (SC8->C8_NUM == cNumCOT)
				RecLock('SC8', .F.)
				SC8->C8_CONAPRO := 'L'
				SC8->(MsUnLock())
				SC8->(DbSkip())
			End
		EndIf
		
	EndIf

	RestArea(aAreaSC8)

Return

/*
******************************************************************************************************
*** Funcao: TxtToArr   -   Autor: Leonardo Pereira   -   Data: 02/12/2010                          ***
*** Descricao: Faz a leitura da linha do arquivo texto e adiciona em um array.                     ***
******************************************************************************************************
*/
Static Function TxtToArr(cTexto, cDelim)

	aRet := {}
	cFinal := ''
	nPosIni := 1
	nTamTxt := Len(cTexto)

	While .T.
		nCol := At(cDelim, SubStr(cTexto, nPosIni, nTamTxt))
		If (nCol == 0)
			cFinal := Upper(SubStr(cTexto, nPosIni, nTamTxt))
			If Empty(cFinal)
				Exit
			EndIf
		EndIf
		nPosFim := If(Empty(cFinal), (nCol - 1), Len(cFinal))
		aAdd(aRet, Upper(SubStr(cTexto, nPosIni, nPosFim)))
		nPosIni += If(Empty(cFinal), nCol, Len(cFinal))
	End

Return(aRet)
