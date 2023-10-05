#Include 'rwmake.ch'
#Include 'protheus.ch'
#Include 'totvs.ch'
#Include 'topconn.ch'

/*/
********************************************************************************************************
*** Funcao   : PNRSOLCOM   -   Autor: Leonardo Pereira   -   Data:                                   ***
*** Descricao:                                                                                       ***
********************************************************************************************************
/*/
User Function PNRSolCom()

	Private aBox
	Private cLogo := If((AllTrim(SM0->M0_CODFIL) == '0101'), 'LogoPNOVO.png', 'LogoTCR.png')
	Private aCab := {}
	Private lEnd := .F.
	Private nLin := 10000
	Private oFontaN := TFont():New('Verdana',, 10,, .T.,,,,, .F., .F.)
	Private oFontbN := TFont():New('Verdana',, 06,, .T.,,,,, .F., .F.)
	Private oFontc := TFont():New('Verdana',, 08,, .F.,,,,, .F., .F.)
	Private oFontcN := TFont():New('Verdana',, 08,, .T.,,,,, .F., .F.)
	Private oFontdN := TFont():New('Verdana',, 12,, .T.,,,,, .F., .F.)
	Private oFonte := TFont():New('Verdana',, 09,, .F.,,,,, .F., .F.)
	Private oFonteN := TFont():New('Verdana',, 09,, .T.,,,,, .F., .F.)
	Private oFontfN := TFont():New('Verdana',, 23,, .T.,,,,, .F., .F.)
	Private oFontg := TFont():New('Verdana',, 08,, .F.,,,,, .F., .F.)
	Private oFontgN := TFont():New('Verdana',, 08,, .T.,,,,, .F., .F.)
	Private oBrush1 := TBrush():New(, RGB(240, 240, 240))
	Private oPrn := TmsPrinter():New('Pedido de Fornecimento')
	Private nMaxH := 0
	Private nMaxV := 0
	Private nQTDPg := 0
	Private nPgAtu := 0
	Private nCount := 0
	Private aCabBox := {{'ITEM', 'CODIGO', 'DESCRICAO', 'QUANT.', 'UM', 'DATA NEC.', 'R$ UNIT.', 'R$ TOTAL'}}
	Private nQtdIt := 29
	Private aDimObj1
	Private aDimObj2
	Private aDimObj3
	Private aDimObj4
	Private aInfoUsu := {}
	Private dValidade
	Private mv_par01 := If((AllTrim(FunName()) == 'MATA130') .or. (AllTrim(FunName()) == 'MATA131'), ParamIXB[1], Space(06))
	
	cPerg := 'PNSOL'
	
	If (AllTrim(FunName()) # 'MATA130' .and. AllTrim(FunName()) # 'MATA131')
		If !Pergunte(cPerg, .T.)
			Return
		EndIf
	EndIf
	
	oPrn:SetPortrait()
	oPrn:SetSize(210, 297)
	
	nMaxV := oPrn:nVertRes()
	nMaxH := oPrn:nHorzRes()
	aBox := {{0055, 200, 500, 1300 , 1500, 1600, 1800, 2100, (nMaxH - 55)}}

	cTitulo := 'SOLICITACAO DE COLETA DE PRECOS'

	aAdd(aCab, cTitulo)

	Processa({ |lEnd| PNRelPC(@lEnd)}, 'SOLICITACAO DE COLETA DE PRECOS', 'Processando dados...', .T.)

Return

/*/
******************************************************************************************************
***                                                                                                ***
***                                                                                                ***
******************************************************************************************************
/*/
Static Function PNRelPC(lEnd)

	Local lFirst := .T.
	Local lCont := .T.
	Local cMsgObs1 := ''
	Local cMsgObs2 := ''
	Local cStr := ''
	Local nLinEnt := 0
	Local nY := 0
	Local nX := 0
	Local nObs := 0

	SC8->(DbGoTop())
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(xFilial('SC8') + mv_par01))
	For nLinEnt := 1 To 99
		cStr := AllTrim(MemoLine(SC8->C8_XOBSCOT,, nLinEnt)) + ' '
		If Empty(cStr)
			Exit
		Else
			cMsgObs1 += cStr
		EndIf
	Next
		
	ProcRegua(0)
	cFornece := (SC8->C8_FORNECE + SC8->C8_LOJA)
	While !SC8->(Eof()) .And. (xFilial('SC8') == SC8->C8_FILIAL) .And. (mv_par01 == SC8->C8_NUM)
		IncProc('Selecionando dados para o relatorio...')
		
		dValidade := DtoC(SC8->C8_VALIDA)
			
		/*/ Verifica se a tabela esta em USO /*/
		If (Select('TMPQTD') > 0)
			TMPQTD->(DbCloseArea())
		EndIf
		/*/ Totaliza a quantidade de paginas /*/
		cQry := 'SELECT MAX(C8_ITEM) QTDIT '
		cQry += ' FROM ' + RetSqlName('SC8') + ' '
		cQry += "WHERE C8_NUM = '" + SC8->C8_NUM + "' "
		cQry += "AND C8_FORNECE+C8_LOJA = '" + cFornece + "' "
		cQry += "AND D_E_L_E_T_ = ' ' "
		TcQuery cQry New ALIAS 'TMPQTD'
		TMPQTD->(DbGoTop())
		If (Val(TMPQTD->QTDIT) > 0)
			nQTDPg := Round(((Val(TMPQTD->QTDIT) / nQtdIt) + 1), 0)
			//nQTDPg := If((nQTDPg == NoRound(nQTDPg, 0)), (nQTDPg + 1), (NoRound(nQTDPg, 0) + 2))
		EndIf
		
		SC1->(DbGoTop())
		SC1->(DbSetOrder(1))
		SC1->(DbSeek(xFilial('SC1') + SC8->C8_NUMSC + SC8->C8_ITEMSC))

		If Interrupcao(@lEnd)
			Exit
		EndIf

		/*/ Impressao dos dados do relatorio /*/
		If (lFirst .Or. (nCount > nQtdIt))
			If !lFirst
				/*/ Imprime a parte inferior do pedido de compras /*/
				nLin := (nMaxV - ((nMaxV * 15) / 100))
				PRNRodape()
			EndIf
			nLin := PNRCabec(oPrn, cLogo, aCab, aBox)
			nLin := PNRCabGrd(aCabBox)
			lFirst := .F.
			nCount := 1
			nPgAtu++
		EndIf

		/*/ Imprime os registros (itens) /*/
		nCount++
		PNRItem()

		SC8->(DbSkip())
		If (cFornece <> (SC8->C8_FORNECE + SC8->C8_LOJA)) .Or. (SC8->C8_NUM <> mv_par01)
			/*/ Imprime a parte inferior do pedido de compras /*/
			nLin := (nMaxV - ((nMaxV * 15) / 100))
			PRNRodape()
			lFirst := .T.
			cFornece := (SC8->C8_FORNECE + SC8->C8_LOJA)
		EndIf
	End
		
	SC8->(DbGoTop())
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(xFilial('SC8') + mv_par01))
	ProcRegua(0)
	lImpObs1 := .F.
	lImpObs2 := !Empty(cMsgObs1)
	While !SC8->(Eof()) .And. (xFilial('SC8') == SC8->C8_FILIAL) .And. (mv_par01 == SC8->C8_NUM)
		IncProc('Analisando observacoes do relatorio...')
		If (!(Empty(SC8->C8_OBS)))
			lImpObs1 := .T.
		EndIf
		SC8->(DbSkip())
	End
	
	If lImpObs1
		SC8->(DbGoTop())
		SC8->(DbSetOrder(1))
		SC8->(DbSeek(xFilial('SC8') + mv_par01))
		ProcRegua(0)
		cFornece := (SC8->C8_FORNECE + SC8->C8_LOJA)
		lFirst := .T.
		While !SC8->(Eof()) .And. (xFilial('SC8') == SC8->C8_FILIAL) .And. (mv_par01 == SC8->C8_NUM) .And. (cFornece == (SC8->C8_FORNECE + SC8->C8_LOJA))
			IncProc('Imprimindo observacoes do relatorio...')
		
			If Interrupcao(@lEnd)
				Exit
			EndIf

			/*/ Impressao dos dados do relatorio /*/
			If lFirst
				oPrn:EndPage()
				oPrn:StartPage()
			
				nLin := aDimObj1[1, 1, 1]
			
				/*/ Desenha o box da pagina /*/
				For nX := 1 To Len(aDimObj1)
					For nY := 1 To Len(aDimObj1[nX])
						oPrn:Box(aDimObj1[nX, nY, 1], aDimObj1[nX, nY, 2], aDimObj1[nX, nY, 3], aDimObj1[nX, nY, 4])	// Box da Pagina.
						nLin += 30
						oPrn:Say(nLin, 0065, Replicate('-', 181), oFontc,, RGB(220, 220, 220),, 0)
						nLin += 30
						oPrn:Say(nLin, ((aDimObj1[nX, nY, 2] + aDimObj1[nX, nY, 4]) / 2), 'O B S E R V A C O E S   DOS   I T E N S   DA   C O T A C A O', oFontaN,,,, 2)
						nLin += 30
						oPrn:Say(nLin, 0065, Replicate('-', 181), oFontc,, RGB(220, 220, 220),, 0)
						nLin += 50
						lFirst := .F.
					Next
				Next
			
				If (nLin >= ((nMaxV - ((nMaxV * 15) / 100)) - 50))
					lFirst := .T.
				EndIf
			EndIf

			/*/ Imprime a observacao dos registros (itens) /*/
			If (!(Empty(AllTrim(SC8->C8_OBS))))
				PNRObs()
			EndIf

			SC8->(DbSkip())
		End
	EndIf
	
	/*/ Imprime as observacoes gerais da cotacao /*/
	If lImpObs2
		If (nLin >= ((nMaxV - ((nMaxV * 15) / 100)) - 50))
			oPrn:EndPage()
			oPrn:StartPage()
	
			nLin := aDimObj1[1, 1, 1]
	
			/*/ Desenha o box da pagina /*/
			For nX := 1 To Len(aDimObj1)
				For nY := 1 To Len(aDimObj1[nX])
					oPrn:Box(aDimObj1[nX, nY, 1], aDimObj1[nX, nY, 2], aDimObj1[nX, nY, 3], aDimObj1[nX, nY, 4])	// Box da Pagina.
					nLin += 30
					oPrn:Say(nLin, 0065, Replicate('-', 181), oFontc,, RGB(220, 220, 220),, 0)
					nLin += 30
					oPrn:Say(nLin, ((aDimObj1[nX, nY, 2] + aDimObj1[nX, nY, 4]) / 2), 'O B S E R V A C O E S   DA   C O T A C A O', oFontaN,,,, 2)
					nLin += 30
					oPrn:Say(nLin, 0065, Replicate('-', 181), oFontc,, RGB(220, 220, 220),, 0)
					nLin += 50
				Next
			Next
		Else
			nLin += 0030
			oPrn:Say(nLin, 0065, Replicate('-', 181), oFontc,, RGB(220, 220, 220),, 0)
			nLin += 0030
			oPrn:Say(nLin, ((aDimObj1[1, 1, 2] + aDimObj1[1, 1, 4]) / 2), 'O B S E R V A C O E S   DA   C O T A C A O', oFontaN,,,, 2)
			nLin += 0030
			oPrn:Say(nLin, 0065, Replicate('-', 181), oFontc,, RGB(220, 220, 220),, 0)
			nLin += 0050
		EndIf
		If !lImpObs2
			nCont := 0
			For nObs := 1 To Len(cMsgObs1)
				nCont++
				cMsgObs2 += SubStr(cMsgObs1, nObs, 1)
				If (nCont == 130)
					nCont := 0
					If (nLin >= ((nMaxV - ((nMaxV * 15) / 100)) - 50))
						cMsgObs2 := ''
						Exit
					EndIf
					oPrn:Say(nLin, 0060, cMsgObs2, oFontc,, RGB(000, 000, 000),, 0)
					cMsgObs2 := ''
					nLin += 40
				EndIf
				If (nLin >= ((nMaxV - ((nMaxV * 15) / 100)) - 50))
					oPrn:EndPage()
					oPrn:StartPage()
	
					nLin := aDimObj1[1, 1, 1]
	
					/*/ Desenha o box da pagina /*/
					For nX := 1 To Len(aDimObj1)
						For nY := 1 To Len(aDimObj1[nX])
							oPrn:Box(aDimObj1[nX, nY, 1], aDimObj1[nX, nY, 2], aDimObj1[nX, nY, 3], aDimObj1[nX, nY, 4])	// Box da Pagina.
							nLin += 30
							oPrn:Say(nLin, 0065, Replicate('-', 181), oFontc,, RGB(220, 220, 220),, 0)
							nLin += 30
							oPrn:Say(nLin, ((aDimObj1[nX, nY, 2] + aDimObj1[nX, nY, 4]) / 2), 'O B S E R V A C O E S   DA   C O T A C A O', oFontaN,,,, 2)
							nLin += 30
							oPrn:Say(nLin, 0065, Replicate('-', 181), oFontc,, RGB(220, 220, 220),, 0)
							nLin += 50
						Next
					Next
				EndIf
			Next
			If !Empty(cMsgObs2)
				oPrn:Say(nLin, 0060, cMsgObs2, oFontc,, RGB(000, 000, 000),, 0)
			EndIf
		EndIf
	EndIf
		
	oPrn:EndPage()
	
	If Interrupcao(@lEnd)
		oPrn:Say(1100, 1650, 'PROCESSO CANCELADO PELO USUARIO', oFontf,,,, 2)
	EndIf
	
	oPrn:Preview()
Return

	/*
********************************************************************************************************
*** Funcao   : PNRCABEC   -   Autor: Leonardo Pereira   -   Data: 27/08/2013                         ***
*** Descricao: Impress?o do Relat?rio de Formacao de precos.                                         ***
********************************************************************************************************
	*/
Static Function PNRCabec(oPrn, cLogo, aCab, aBox)

	Local nCnt
	Local nLinRep
	Local nY := 0
	Local nX := 0

	If !File(cLogo)
		cLogo := 'LGRL' + SM0->M0_CODIGO + '.BMP'
		If !File(cLogo)
			cLogo := 'LGRL.BMP'
		EndIf
	EndIf

	cLogo := If((cLogo == Nil), '', cLogo)
	aCab := If((aCab == Nil), {''}, aCab)

	oPrn:EndPage()
	oPrn:StartPage()

	nLin := 0050

	/*/ Calcula disposicao/dimensoes do box da pagina do relatorio /*/
	aADisp1 := {0000, 0000, (nMaxV - 50), nMaxH}
	aObjHor1 := {{98}}
	aObjVer1 := {{98}}
	aObjMar1 := {50, 50, 50, 50, 50}
	aDimObj1 := U_LMPCalcObj(1, aADisp1, aObjHor1, aObjVer1, aObjMar1)

	/*/ Desenha o box da pagina /*/
	For nX := 1 To Len(aDimObj1)
		For nY := 1 To Len(aDimObj1[nX])
			oPrn:Box(aDimObj1[nX, nY, 1], aDimObj1[nX, nY, 2], aDimObj1[nX, nY, 3], aDimObj1[nX, nY, 4])	// Box da Pagina.
		Next
	Next

	/*/ Calcula disposicao/dimensoes dos boxs do cabecalho do relatorio /*/
	aADisp2 := {aDimObj1[1, 1, 1], aDimObj1[1, 1, 2], aDimObj1[1, 1, 3], aDimObj1[1, 1, 4]}
	aObjHor2 := {{09, 38, 9, 9, 15, 10, 10}}
	aObjVer2 := {{5, 5, 5, 5, 5, 5, 5}}
	aObjMar2 := {5, 5, 5, 5, 5}
	aDimObj2 := U_LMPCalcObj(1, aADisp2, aObjHor2, aObjVer2, aObjMar2)

	/*/ Desenha os boxes do cabe?alho /*/
	For nX := 1 To Len(aDimObj2)
		For nY := 1 To Len(aDimObj2[nX])

			oPrn:Box(aDimObj2[nX, nY, 1], aDimObj2[nX, nY, 2], aDimObj2[nX, nY, 3], (aDimObj2[nX, nY, 4] - 5))		// Box do cabecalho

			If (nY == 1)
				oPrn:SayBitmap((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 5), cLogo, 0189, 0139)													// Impressao do Logotipo.
			ElseIf (nY == 2)
				oPrn:Say((aDimObj2[nX, nY, 1] + 80), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), aCab[Len(aCab)], oFontaN,,,, 2)					// Impressao do Titulo.
			ElseIf (nY == 3)
				oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Cotacao', oFontbN,,,, 0)											// Solicitacao
				oPrn:Say((aDimObj2[nX, nY, 1] + 80), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), SC8->C8_NUM, oFontcN,,,, 2)	// Solicitacao
			ElseIf (nY == 4)
				oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Natureza', oFontbN,,,, 0)											// Natureza
				oPrn:Say((aDimObj2[nX, nY, 1] + 80), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), AllTrim(SC8->C8_XNAT), oFontcN,,,, 2)											// Natureza
			ElseIf (nY == 5)
				oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Conta Orcamentaria', oFontbN,,,, 0)							// Conta orcamentaria
				oPrn:Say((aDimObj2[nX, nY, 1] + 80), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), AllTrim(SC8->C8_XCO), oFontcN,,,, 2)											// Conta orcamentaria
			ElseIf (nY == 6)
				oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Centro de Custo', oFontbN,,,, 0)									// Centro de Custo
				oPrn:Say((aDimObj2[nX, nY, 1] + 80), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), AllTrim(SC1->C1_CC), oFontcN,,,, 2)											// Centro de Custo
			ElseIf (nY == 7)
				oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Emissao', oFontbN,,,, 0)									// Data emissao
				oPrn:Say((aDimObj2[nX, nY, 1] + 80), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), DtoC(SC8->C8_EMISSAO), oFontcN,,,, 2)											// Data emissao
			EndIf
		Next
	Next

	/*/ Calcula disposicao/dimensoes dos boxs do cabecalho do relatorio /*/
	aADisp3 := {aDimObj2[1, 1, 3], aDimObj1[1, 1, 2], aDimObj1[1, 1, 3], aDimObj1[1, 1, 4]}
	aObjHor3 := {{100}, {50, 50}}
	aObjVer3 := {{8}, {10, 10}}
	aObjMar3 := {5, 5, 5, 5, 5}
	aDimObj3 := U_LMPCalcObj(1, aADisp3, aObjHor3, aObjVer3, aObjMar3)

	/*/ Desenha os boxes do cabe?alho /*/
	For nX := 1 To Len(aDimObj3)
		For nY := 1 To Len(aDimObj3[nX])
			If (nX == 1)
				oPrn:FillRect({(aDimObj3[nX, nY, 1] + 2), (aDimObj3[nX, nY, 2] + 2), (aDimObj3[nX, nY, 3] - 2), ((aDimObj3[nX, nY, 4] - 5) - 2)}, oBrush1)
				oPrn:Say((aDimObj3[nX, nY, 1] + 10), (aDimObj3[nX, nY, 2] + 10), 'Dados da Empresa:', oFontbN,,,, 0)										// Dados da Empresa
				oPrn:Say((aDimObj3[nX, nY, 1] + 50), 0065, AllTrim(SM0->M0_NOMECOM), oFontcN,,,, 0)								// Nome da Empresa
				oPrn:Say((aDimObj3[nX, nY, 1] + 100), (aDimObj3[nX, nY, 2] + 10), 'ENDERECO: ' + AllTrim(SM0->M0_ENDCOB) + ', ' + AllTrim(SM0->M0_CIDCOB) + ' - ' + SM0->M0_ESTCOB, oFontgN,,,, 0)		// Endereco da Empresa
				oPrn:Say((aDimObj3[nX, nY, 1] + 100), (aDimObj3[nX, nY, 2] + 1100), 'CEP: ' + Transform(SM0->M0_CEPCOB, '@R 99999-999'), oFontcN,,,, 0)			// CEP da Empresa
				oPrn:Say((aDimObj3[nX, nY, 1] + 100), (aDimObj3[nX, nY, 2] + 1500), 'WEBSITE: www.portonovosa.com', oFontcN,,,, 0)		// Site da Empresa
				oPrn:Say((aDimObj3[nX, nY, 1] + 150), (aDimObj3[nX, nY, 2] + 10), 'CNPJ: ' + Transform(SM0->M0_CGC, '@R 99.999.999/9999-99'), oFontcN,,,, 0)	// CNPJ da Empresa
				If (AllTrim(SM0->M0_INSC) <> 'ISENTO')
					oPrn:Say((aDimObj3[nX, nY, 1] + 150), (aDimObj3[nX, nY, 2] + 500), 'INSC. ESTADUAL: ' + Transform(SM0->M0_INSC, '@R 99.999.99-9'), oFontcN,,,, 0)	// Inscricao Estadual da Empresa
				Else
					oPrn:Say((aDimObj3[nX, nY, 1] + 150), (aDimObj3[nX, nY, 2] + 500), 'INSC. ESTADUAL: ' + SM0->M0_INSC, oFontcN,,,, 0)	// Inscricao Estadual da Empresa
				EndIf
				If (AllTrim(SM0->M0_INSCM) <> 'ISENTO')
					oPrn:Say((aDimObj3[nX, nY, 1] + 150), (aDimObj3[nX, nY, 2] + 1100), 'INSC. MUNICIPAL: ' + Transform(SM0->M0_CGC, '@R 9.999.999-9'), oFontcN,,,, 0)	// Inscricao Municipal da Empresa
				Else
					oPrn:Say((aDimObj3[nX, nY, 1] + 150), (aDimObj3[nX, nY, 2] + 1100), 'INSC. MUNICIPAL: ' + SM0->M0_INSCM, oFontcN,,,, 0)	// Inscricao Municipal da Empresa
				EndIf

				/*/ Pesquisa os dados do contato /*/
				PswOrder(1)
				If (PswSeek(AllTrim(SC8->C8_XUSER), .T.))
					aInfoUsu := PswRet(1)
				EndIf
				oPrn:Say((aDimObj3[nX, nY, 1] + 200), (aDimObj3[nX, nY, 2] + 10), 'CONTATO: ' + AllTrim(aInfoUsu[1, 4]), oFontcN,,,, 0)		// Contato da Empresa
				oPrn:Say((aDimObj3[nX, nY, 1] + 200), (aDimObj3[nX, nY, 2] + 800), 'TELEFONE: ' + Transform(SM0->M0_TEL, '@R (99)9999-9999'), oFontcN,,,, 0)		// Telefone do Contato
				oPrn:Say((aDimObj3[nX, nY, 1] + 200), (aDimObj3[nX, nY, 2] + 1500), 'E-MAIL: ' + AllTrim(aInfoUsu[1, 14]), oFontcN,,,, 0)		// E-mail do Contato
			ElseIf (nX == 2)
				If (nY == 1)
					SA2->(DbGoTop())
					SA2->(DbSetOrder(1))
					If SA2->(DbSeek(xFilial('SA2') + SC8->C8_FORNECE + SC8->C8_LOJA))
						/*/ Dados do Fornecedor /*/
						oPrn:Say((aDimObj3[nX, nY, 1] + 10), (aDimObj3[nX, nY, 2] + 10), 'Dados do Fornecedor:', oFontbN,,,, 0)										// Dados da Empresa
						oPrn:Say((aDimObj3[nX, nY, 1] + 50), (aDimObj3[nX, nY, 2] + 10), AllTrim(SA2->A2_NOME), oFonteN,,,, 0)		// Nome
						oPrn:Say((aDimObj3[nX, nY, 1] + 100), (aDimObj3[nX, nY, 2] + 10), 'CNPJ: ' + Transform(AllTrim(SA2->A2_CGC), '@R 99.999.999/9999-99'), oFontgN,,,, 0)		// CNPJ
						oPrn:Say((aDimObj3[nX, nY, 1] + 100), (aDimObj3[nX, nY, 2] + 900), 'CEP: ' + Transform(SA2->A2_CEP, '@R 99999-999'), oFontgN,,,, 0)		// CEP
						oPrn:Say((aDimObj3[nX, nY, 1] + 150), (aDimObj3[nX, nY, 2] + 10), 'ENDERECO: ' + AllTrim(SA2->A2_END) + ' - ' + AllTrim(SA2->A2_BAIRRO) + ' - ' + AllTrim(SA2->A2_EST), oFontgN,,,, 0)		// Endereco
						oPrn:Say((aDimObj3[nX, nY, 1] + 200), (aDimObj3[nX, nY, 2] + 10), 'CONTATO: ' + AllTrim(SC7->C7_CONTATO), oFonte,,,, 0)		// Contato
						oPrn:Say((aDimObj3[nX, nY, 1] + 200), (aDimObj3[nX, nY, 2] + 500), 'WEBSITE: ' + Lower(AllTrim(SA2->A2_HPAGE)), oFonte,,,, 0)			// Site
						oPrn:Say((aDimObj3[nX, nY, 1] + 250), (aDimObj3[nX, nY, 2] + 10), 'TELEFONE: ' + Transform(AllTrim(SA2->A2_TEL), '@R (99)9999-9999'), oFonte,,,, 0)		// Telefone
						oPrn:Say((aDimObj3[nX, nY, 1] + 250), (aDimObj3[nX, nY, 2] + 500), 'E-MAIL: ' + Lower(AllTrim(SA2->A2_EMAIL)), oFonte,,,, 0)		// E-mail
					EndIf
				ElseIf (nY == 2)
					/*/ Dados do Distribuidor /*/
					oPrn:Say((aDimObj3[nX, nY, 1] + 10), (aDimObj3[nX, nY, 2] + 10), 'Dados do Distribuidor:', oFontbN,,,, 0)										// Dados da Empresa
					oPrn:Say((aDimObj3[nX, nY, 1] + 50), (aDimObj3[nX, nY, 2] + 10), '', oFonteN,,,, 0)		// Nome
					oPrn:Say((aDimObj3[nX, nY, 1] + 100), (aDimObj3[nX, nY, 2] + 10), 'CNPJ: ' + Transform('', '@R 99.999.999/9999-99'), oFontgN,,,, 0)		// CNPJ
					oPrn:Say((aDimObj3[nX, nY, 1] + 100), (aDimObj3[nX, nY, 2] + 900), 'CEP: ' + Transform('', '@R 99999-999'), oFontgN,,,, 0)		// CEP
					oPrn:Say((aDimObj3[nX, nY, 1] + 150), (aDimObj3[nX, nY, 2] + 10), 'ENDERECO: ', oFontgN,,,, 0)		// Endereco
					oPrn:Say((aDimObj3[nX, nY, 1] + 200), (aDimObj3[nX, nY, 2] + 10), 'CONTATO: ', oFonte,,,, 0)		// Contato
					oPrn:Say((aDimObj3[nX, nY, 1] + 200), (aDimObj3[nX, nY, 2] + 500), 'WEBSITE: ', oFonte,,,, 0)			// Site
					oPrn:Say((aDimObj3[nX, nY, 1] + 250), (aDimObj3[nX, nY, 2] + 10), 'TELEFONE: ' + Transform(AllTrim(''), '@R (99)9999-9999'), oFonte,,,, 0)		// Telefone
					oPrn:Say((aDimObj3[nX, nY, 1] + 250), (aDimObj3[nX, nY, 2] + 500), 'E-MAIL: ', oFonte,,,, 0)		// E-mail
				EndIf
			EndIf
			oPrn:Box(aDimObj3[nX, nY, 1], aDimObj3[nX, nY, 2], aDimObj3[nX, nY, 3], (aDimObj3[nX, nY, 4] - 5))		// Box dos dados da empresa
		Next
	Next

Return(aDimObj3[2, 1, 3])

	/*
********************************************************************************************************
***                                                                                                  ***
***                                                                                                  ***
********************************************************************************************************
	*/
Static Function PNRCabGrd(aCabBox)

	Local nLenCab := 0090
	Local nCnt := 0
	Local nCntBox := 0
	Local nCntCab := 0

	nLin += 0010
	nLinAnt := nLin

	/*/ Montagem dos boxs do cabecalho das colunas do relatorio. /*/
	For nCntBox := 1 To Len(aBox)
		For nCnt := 1 To (Len(aBox[nCntBox]) - 1)
			oPrn:FillRect({(nLin + 1), (aBox[nCntBox, nCnt] + 1), (nLin + 0049), (aBox[nCntBox, (nCnt + 1)] - 1)}, oBrush1)
			oPrn:Box(nLin, aBox[nCntBox, nCnt], (nLin + 0050), aBox[nCntBox, (nCnt + 1)])
		Next
	Next

	nLin := (nLinAnt - 0020)
	nSkipLin := (nLenCab / 3)

	/*/ Titulos das colunas do relatorio. /*/
	nLin += nSkipLin
	For nCntCab := 1 To Len(aCabBox)
		For nCnt := 1 To Len(aCabBox[nCntCab])
			oPrn:Say(nLin,((aBox[nCntCab, nCnt] + aBox[nCntCab, (nCnt + 1)]) / 2), aCabBox[nCntCab, nCnt], oFontcN,,,, 2)
		Next
	Next

	nLin += ((nLenCab - 0015) - nSkipLin)

	/*/ Montagem dos boxs das colunas do relatorio. /*/
	For nCntBox := 1 To Len(aBox)
		For nCnt := 1 To (Len(aBox[nCntBox]) - 1)
			oPrn:Box(nLin, aBox[nCntBox, nCnt], (nMaxV - ((nMaxV * 15) / 100)), aBox[nCntBox, nCnt + 1])
		Next
	Next

	nLin += 0015

Return(nLin)

	/*
********************************************************************************************************
***                                                                                                  ***
***                                                                                                  ***
********************************************************************************************************
	*/
Static Function PNRItem()
	
	Local nLinBkp1
	Local nLinBkp2
	Local cDesProd := AllTrim(SC1->C1_DESCRI)
	Local cDesImp := ''
	Local nLenDesc := Len(cDesProd)
	Local nTamDes := 0

	Local nBox := Len(aBox)
	
	oPrn:Say(nLin, ((aBox[nBox, 01] + aBox[nBox, 02]) / 2), SC8->C8_ITEM, oFontc,,,, 2)
	oPrn:Say(nLin, (aBox[nBox, 02] + 0010), SC8->C8_PRODUTO, oFontc,,,, 0)
	If (nLenDesc > 52)
		nLinBkp1 := nLin
		While !Empty(cDesProd)
			For nTamDes := 1 To nLenDesc
				cDesImp += SubStr(cDesProd, 1, 1)
				cDesProd := SubStr(cDesProd, 2)
				If (nTamDes == 52) .Or. Empty(cDesProd)
					oPrn:Say(nLin, (aBox[nBox, 03] + 0010), cDesImp, oFontc,,,, 0)
					cDesImp := ''
					lFirst := .F.
					nTamDes := 0
					If (Len(cDesProd) > 0)
						nCount++
						nLin += 0045
					Else
						Exit
					EndIf
				EndIf
			Next
		End
	Else
		oPrn:Say(nLin, (aBox[nBox, 03] + 0010), cDesProd, oFontc,,,, 0)
	EndIf
	
	If (nLenDesc > 52)
		nLinBkp2 := nLin
		nLin := nLinBkp1
	EndIf
	
	oPrn:Say(nLin, (aBox[nBox, 05] - 0010), Transform(SC8->C8_QUANT, '@E 999,999.99'), oFontc,,,, 1)
	oPrn:Say(nLin, ((aBox[nBox, 05] + aBox[nBox, 06]) / 2), SC8->C8_UM, oFontc,,,, 2)
	oPrn:Say(nLin, ((aBox[nBox, 06] + aBox[nBox, 07]) / 2), DtoC(SC8->C8_DATPRF), oFontc,,,, 2)

	If (nLenDesc > 52)
		nLin := nLinBkp2
	EndIf

	nLin += 0025
	oPrn:Say(nLin, 0065, Replicate('-', 181), oFontc,, RGB(220, 220, 220),, 0)
	nLin += 0030

Return

	/*
********************************************************************************************************
***                                                                                                  ***
***                                                                                                  ***
********************************************************************************************************
	*/
Static Function PNRObs()

	Local nBox := Len(aBox)
	
	oPrn:Say(nLin, ((aBox[nBox, 01] + aBox[nBox, 02]) / 2), SC8->C8_ITEM, oFontc,,,, 2)
	oPrn:Say(nLin, (aBox[nBox, 02] + 0010), SC8->C8_OBS, oFontc,,,, 0)

	nLin += 0025
	oPrn:Say(nLin, 0065, Replicate('-', 181), oFontc,, RGB(220, 220, 220),, 0)
	nLin += 0030

Return

	/*
********************************************************************************************************
***                                                                                                  ***
***                                                                                                  ***
********************************************************************************************************
	*/
Static Function PRNRodape(nOpc)
Local nRegC8 := SC8->(Recno())
Local nW := 0
Local nK := 0
Local nY := 0
Local nX := 0

	DbSelectArea("SC8")	
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(xFilial('SC8') + mv_par01))
	
	/*/ Calcula disposicao/dimensoes dos boxs no relatorio /*/
	aADisp4 := {(nMaxV - ((nMaxV * 15) / 100)), aDimObj1[1, 1, 2], aDimObj1[1, 1, 3], aDimObj1[1, 1, 4]}
	aObjHor4 := {{20, 20, 20, 20, 20}, {20, 20, 20, 20, 20}, {20, 20, 20, 20, 20}}
	aObjVer4 := {{10, 10, 10, 10, 10}, {45, 45, 45, 45, 45}, {45, 45, 45, 45, 45}}
	aObjMar4 := {5, 5, 5, 5, 5}
	aDimObj4 := U_LMPCalcObj(1, aADisp4, aObjHor4, aObjVer4, aObjMar4)
	
	SY1->(DbGoTop())
	SY1->(DbSetOrder(3))
	//If !(AllTrim(FunName()) == 'MATA130')
	//	SY1->(DbSeek(xFilial('SY1') + __cUserID))
	//Else
	SY1->(DbSeek(xFilial('SY1') + SC8->C8_XUSER))
	//EndIf
	
	/*/ Pesquisa os dados do contato /*/
	PswOrder(1)
	If (PswSeek(AllTrim(SC1->C1_USER), .T.))
		aInfoUsu := PswRet(1)
	EndIf

	For nX := 1 To Len(aDimObj4)
		For nY := 1 To Len(aDimObj4[nX])
			oPrn:Box(aDimObj4[nX, nY, 1], aDimObj4[nX, nY, 2], (aDimObj4[nX, nY, 3] - 5), (aDimObj4[nX, nY, 4] - 5))
			If (nX == 1)
				If (nY == 1)
					oPrn:Say((aDimObj4[nX, nY, 1] + 5), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), 'CONDICAO PAGAMENTO', oFontbN,,,, 2)
				ElseIf (nY == 2)
					oPrn:Say((aDimObj4[nX, nY, 1] + 5), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), 'PRAZO DE ENTREGA', oFontbN,,,, 2)
				ElseIf (nY == 3)
					oPrn:Say((aDimObj4[nX, nY, 1] + 5), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), 'R$ FRETE', oFontbN,,,, 2)
				ElseIf (nY == 4)
					oPrn:Say((aDimObj4[nX, nY, 1] + 5), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), 'R$ OUTRAS DESPESAS', oFontbN,,,, 2)
				ElseIf (nY == 5)
					oPrn:Say((aDimObj4[nX, nY, 1] + 5), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), 'R$ DESCONTO', oFontbN,,,, 2)
				EndIf
			ElseIf (nX == 3)
				If (nY == 1)
					oPrn:Say((aDimObj4[nX, nY, 1] + 10), (aDimObj4[nX, nY, 2] + 10), 'Solicitante:', oFontbN,,,, 0)										// Solicitante
					oPrn:Say((aDimObj4[nX, nY, 3] - 115), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), AllTrim(aInfoUsu[1, 4]), oFontbN,,,, 2)										// Data
					oPrn:Say((aDimObj4[nX, nY, 3] - 65), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), DtoC(SC1->C1_EMISSAO), oFontbN,,,, 2)										// Data
					oPrn:Say((aDimObj4[nX, nY, 3] - 35), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), 'DATA', oFontbN,,,, 2)
				ElseIf (nY == 2)
					oPrn:Say((aDimObj4[nX, nY, 1] + 10), (aDimObj4[nX, nY, 2] + 10), 'Comprador:', oFontbN,,,, 0)										// Comprador
					oPrn:Say((aDimObj4[nX, nY, 3] - 115), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), AllTrim(SY1->Y1_NOME), oFontbN,,,, 2)
					oPrn:Say((aDimObj4[nX, nY, 3] - 65), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), DTOC(SC8->C8_EMISSAO), oFontbN,,,, 2)
					oPrn:Say((aDimObj4[nX, nY, 3] - 35), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), 'DATA', oFontbN,,,, 2)
				ElseIf (nY == 3)
					oPrn:Say((aDimObj4[nX, nY, 1] + 10), (aDimObj4[nX, nY, 2] + 10), 'Aprovador:', oFontbN,,,, 0)										// Aprovador
					oPrn:Say((aDimObj4[nX, nY, 3] - 115), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), '', oFontbN,,,, 2)
					oPrn:Say((aDimObj4[nX, nY, 3] - 65), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), '_____/_____/_____', oFontbN,,,, 2)										// Data
					oPrn:Say((aDimObj4[nX, nY, 3] - 35), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), 'DATA', oFontbN,,,, 2)
				ElseIf (nY == 4)
					oPrn:Say((aDimObj4[nX, nY, 1] + 10), (aDimObj4[nX, nY, 2] + 10), 'Almoxarife:', oFontbN,,,, 0)										// Almoxarife
					oPrn:Say((aDimObj4[nX, nY, 3] - 115), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), '', oFontbN,,,, 2)
					oPrn:Say((aDimObj4[nX, nY, 3] - 65), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), '_____/_____/_____', oFontbN,,,, 2)										// Data
					oPrn:Say((aDimObj4[nX, nY, 3] - 35), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), 'DATA', oFontbN,,,, 2)										// Data
				ElseIf (nY == 5)
					// Calcula disposicao/dimensoes dos boxs no relatorio //
					aADisp5 := {aDimObj4[nX, nY, 1], aDimObj4[nX, nY, 2], (aDimObj4[nX, nY, 3] - 5), (aDimObj4[nX, nY, 4] - 5)}
					aObjHor5 := {{100}, {100}}
					aObjVer5 := {{50}, {50}}
					aObjMar5 := {0, 0, 0, 0, 0}
					aDimObj5 := U_LMPCalcObj(1, aADisp5, aObjHor5, aObjVer5, aObjMar5)
				
					For nK := 1 To Len(aDimObj5)
						For nW := 1 To Len(aDimObj5[nK])
							oPrn:Box(aDimObj5[nK, nW, 1], aDimObj5[nK, nW, 2], aDimObj5[nK, nW, 3], aDimObj5[nK, nW, 4])
							If (nK == 1)
								oPrn:Say((aDimObj5[nK, nW, 1] + 10), (aDimObj5[nK, nW, 2] + 10), 'Validade', oFontbN,,,, 0)											// Validade
								oPrn:Say((aDimObj5[nK, nW, 1] + 25), ((aDimObj5[nK, nW, 2] + aDimObj5[nK, nW, 4]) / 2), dValidade, oFontaN,,,, 2)		// Data validade
							ElseIf (nK == 2)
								oPrn:Say((aDimObj5[nK, nW, 1] + 10), (aDimObj5[nK, nW, 2] + 10), 'Pagina:', oFontbN,,,, 0)										// No Pagina
								oPrn:Say(aDimObj5[nK, nW, 1], ((aDimObj5[nK, nW, 2] + aDimObj5[nK, nW, 4]) / 2), (StrZero(nPgAtu, 2) + '/' + StrZero(nQTDPg, 2)), oFontfN,, RGB(215, 215, 215),, 2)
							EndIf
						Next
					Next
				EndIf
			EndIf
		Next
	Next
SC8->(Dbgoto(nRegC8))
Return
