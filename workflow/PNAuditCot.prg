#Include 'rwmake.ch'
#Include 'protheus.ch'
#Include 'totvs.ch'
#Include 'topconn.ch'

/*
*****************************************************************************************************
*** Funcao   : PNAUDCOT   -   Autor: Leonardo Pereira   -   Data:                                 ***
*** Descricao:                                                                                    ***
*****************************************************************************************************
*/
User Function PNAudCot()

	Private aBox1
	Private aBox2
	Private cLogo := 'LogoPNovo.png'
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
	Private oFontfN := TFont():New('Verdana',, 25,, .T.,,,,, .F., .F.)
	Private oFontg := TFont():New('Verdana',, 08,, .F.,,,,, .F., .F.)
	Private oFontgN := TFont():New('Verdana',, 08,, .T.,,,,, .F., .F.)
	Private oBrush1 := TBrush():New(, RGB(240, 240, 240))
	Private oPrn := TmsPrinter():New('Auditoria - Mapa de Cotacao')
	Private nMaxH := 0
	Private nMaxV := 0
	Private nQTDPg := 0
	Private nCountPg := 0
	Private aCabBox1 := {{'NIVEL', 'USUARIO', 'SITUACAO', 'USUARIO LIB.', 'DATA', 'OBSERVACAO', '1o COLOCADO', '2o COLOCADO', '2o COLOCADO', '4o COLOCADO', '5o COLOCADO'}}
	Private aCabBox2 := {{'CODIGO', 'NOME', 'ENTREGA', 'MOTIVO'}}
	Private nQtdIt := 29
	Private aDimObj1
	Private aDimObj2
	Private aDimObj3
	Private aDimObj4
	Private aInfoUsu
	Private dValidade
	
	cPerg := 'PNAUD'
	
	If !Pergunte(cPerg, .T.)
	Return
	EndIf

	oPrn:SetLandScape()
	oPrn:SetSize(297, 210)
	
	nMaxV := oPrn:nVertRes()
	nMaxH := oPrn:nHorzRes()
	aBox1 := {{0055, 170, 500, 0700 , 1050, 1250, 1950, 2250, 2550, 2850, 3150, (nMaxH - 77)}}
	aBox2 := {{0055, 300, 1200, 1500, (nMaxH - 77)}}
	
	cTitulo := 'AUDITORIA - MAPA DE COTACAO'
	
	aAdd(aCab, cTitulo)
	
	Processa({ |lEnd| PNAudCOT(@lEnd)}, 'AUDITORIA - MAPA DE COTACAO', 'Processando dados...', .T.)
	
Return

	/*
*****************************************************************************************************
***                                                                                               ***
***                                                                                               ***
*****************************************************************************************************
	*/
Static Function PNAudCOT(lEnd)

	SCR->(DbGoTop())
	SCR->(DbSetOrder(1))
	SCR->(DbSeek(xFilial('SCR') + 'MC' + mv_par01))
	ProcRegua(0)
	
	cNumDOC := AllTrim(SCR->CR_NUM)
	lFirst := .T.
	
	While !SCR->(Eof()) .And. (SCR->CR_FILIAL == xFilial('SCR')) .AND. (SCR->CR_TIPO == 'MC') .And. (AllTrim(SCR->CR_NUM) == cNumDOC)
		IncProc('Selecionando dados para o relatorio...')

		If Interrupcao(@lEnd)
			Exit
		EndIf

		/*/ Impressao dos dados do relatorio /*/
		If lFirst
			nLin := PNRCabec(oPrn, cLogo, aCab)
			
			/*/ Imprime subcabecalho /*/
			nLin := PNSubCab(1)
			nLin := PNRCabGrd(aCabBox1, 1)
			
			lFirst := .F.
		EndIf

		/*/ Imprime os registros do ranking /*/
		PNAudRk()

		SCR->(DbSkip())
	End
	
	nLin += 0100
	
	/*/ Imprime subcabecalho /*/
	nLin := PNSubCab(2)
	
	/*/ Imprime a parte inferior da auditoria /*/
	nLin := PNRCabGrd(aCabBox2, 2)
	
	/*/ Imprime os registros da auditoria da analise /*/
	PNAudAn()

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
Static Function PNRCabec(oPrn, cLogo, aCab)

	Local nY :=0
	Local nX :=0

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
	
	SC8->(DbGoTop())
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(xFilial('SC8') + mv_par01))
	
	SC1->(DbGoTop())
	SC1->(DbSetOrder(1))
	SC1->(DbSeek(xFilial('SC1') + SC8->C8_NUMSC))

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
	aObjHor2 := {{7, 40, 9, 9, 15, 10, 10}}
	aObjVer2 := {{7, 7, 7, 7, 7, 7, 7}}
	aObjMar2 := {5, 5, 5, 5, 5}
	aDimObj2 := U_LMPCalcObj(1, aADisp2, aObjHor2, aObjVer2, aObjMar2)

	/*/ Desenha os boxes do cabecalho /*/
	For nX := 1 To Len(aDimObj2)
		For nY := 1 To Len(aDimObj2[nX])
			oPrn:Box(aDimObj2[nX, nY, 1], aDimObj2[nX, nY, 2], aDimObj2[nX, nY, 3], (aDimObj2[nX, nY, 4] - 5))		// Box do cabecalho

			/*/ Imprime as informacoes em cada box /*/
			If (nY == 1)
				oPrn:SayBitmap((aDimObj2[nX, nY, 1] + 10), (((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2) - 97), cLogo, 0189, 0139)													// Impressao do Logotipo.
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
				oPrn:Say((aDimObj2[nX, nY, 1] + 80), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), DtoC(SCR->CR_EMISSAO), oFontcN,,,, 2)											// Data emissao
			EndIf
		Next
	Next

Return(aDimObj2[Len(aDimObj2), 1, 3])

	/*
********************************************************************************************************
***                                                                                                  ***
***                                                                                                  ***
********************************************************************************************************
	*/
Static Function PNRCabGrd(aCabBox1, nOpc)

	Local nLenCab := 0090
	Local cVarCab := 'aBox' + AllTrim(Str(nOpc))
	Local nCnt:=0 
	Local nCntBox := 0
	Local nCntCab := 0

	nLin += 0010
	nLinAnt := nLin

	/*/ Montagem dos box?s do cabe?alho das colunas do relatorio. /*/
	For nCntBox := 1 To Len(&(cVarCab))
		For nCnt := 1 To (Len(&(cVarCab)[nCntBox]) - 1)
			oPrn:FillRect({(nLin + 1), (&(cVarCab)[nCntBox, nCnt] + 1), (nLin + 0049), (&(cVarCab)[nCntBox, (nCnt + 1)] - 1)}, oBrush1)
			oPrn:Box(nLin, &(cVarCab)[nCntBox, nCnt], (nLin + 0050), &(cVarCab)[nCntBox, (nCnt + 1)])
		Next
	Next

	nLin := (nLinAnt - 0020)
	nSkipLin := (nLenCab / 3)

	/*/ Titulos das colunas do relatorio. /*/
	nLin += nSkipLin
	For nCntCab := 1 To Len(aCabBox1)
		For nCnt := 1 To Len(aCabBox1[nCntCab])
			oPrn:Say(nLin,((&(cVarCab)[nCntCab, nCnt] + &(cVarCab)[nCntCab, (nCnt + 1)]) / 2), aCabBox1[nCntCab, nCnt], oFontcN,,,, 2)
		Next
	Next

	nLin += ((nLenCab - 0015) - nSkipLin)

	/*/ Montagem dos box?s das colunas do relatorio. /*/
	/*/
	For nCntBox := 1 To Len(&(cVarCab))
		For nCnt := 1 To (Len(&(cVarCab)[nCntBox]) - 1)
			oPrn:Box(nLin, &(cVarCab)[nCntBox, nCnt], (nMaxV - ((nMaxV * 30) / 100)), &(cVarCab)[nCntBox, nCnt + 1])
		Next
	Next
	/*/
	
	nLin += 0015

Return(nLin)

	/*
********************************************************************************************************
***                                                                                                  ***
***                                                                                                  ***
********************************************************************************************************
	*/
Static Function PNSubCab(nOpc)
	nLin += 0020
	oPrn:FillRect({(nLin + 0001), 0061, (nLin + 0049), (nMaxH - 0078)}, oBrush1)
	oPrn:Box(nLin, 0060, (nLin + 0050), (nMaxH - 0077))
	oPrn:Say((nLin + 0010), 0065, If((nOpc == 1), 'DEFINICOES DO MAPA DE COTACAO', 'DEFINICOES DO PEDIDO DE COMPRA'), oFontcN,,,, 0)
Return((nLin + 0060))

	/*
********************************************************************************************************
***                                                                                                  ***
***                                                                                                  ***
********************************************************************************************************
	*/
Static Function PNAudRk()

	Local nBox := Len(aBox1)
		
	oPrn:Say(nLin, ((aBox1[nBox, 01] + aBox1[nBox, 02]) / 2), SCR->CR_NIVEL, oFontc,,,, 2)
	oPrn:Say(nLin, ((aBox1[nBox, 02] + aBox1[nBox, 03]) / 2), AllTrim(UsrRetName(SCR->CR_USER)), oFontc,,,, 2)
	Do Case
	Case (SCR->CR_STATUS == '02')
		oPrn:Say(nLin, ((aBox1[nBox, 03] + aBox1[nBox, 04]) / 2), 'AGUARDANDO', oFontc,,,, 2)
	Case (SCR->CR_STATUS == '03')
		oPrn:Say(nLin, ((aBox1[nBox, 03] + aBox1[nBox, 04]) / 2), 'FINALIZADO', oFontc,,,, 2)
	Case (SCR->CR_STATUS == '04')
		oPrn:Say(nLin, ((aBox1[nBox, 03] + aBox1[nBox, 04]) / 2), 'NIVEL FIN.', oFontc,,,, 2)
	EndCase
	oPrn:Say(nLin, ((aBox1[nBox, 04] + aBox1[nBox, 05]) / 2), AllTrim(UsrRetName(SCR->CR_USERLIB)), oFontc,,,, 2)
	oPrn:Say(nLin, ((aBox1[nBox, 05] + aBox1[nBox, 06]) / 2), DtoC(SCR->CR_DATALIB), oFontc,,,, 2)
	cObsSCR := MemoLine(SCR->CR_OBS)
	oPrn:Say(nLin, (aBox1[nBox, 06] + 0010), cObsSCR, oFontc,,,, 0)
	oPrn:Say(nLin, ((aBox1[nBox, 07] + aBox1[nBox, 08]) / 2), SCR->CR_RKN1, oFontc,,,, 2)
	oPrn:Say(nLin, ((aBox1[nBox, 08] + aBox1[nBox, 09]) / 2), SCR->CR_RKN2, oFontc,,,, 2)
	oPrn:Say(nLin, ((aBox1[nBox, 09] + aBox1[nBox, 10]) / 2), SCR->CR_RKN3, oFontc,,,, 2)
	oPrn:Say(nLin, ((aBox1[nBox, 10] + aBox1[nBox, 11]) / 2), SCR->CR_RKN4, oFontc,,,, 2)
	oPrn:Say(nLin, ((aBox1[nBox, 11] + aBox1[nBox, 12]) / 2), SCR->CR_RKN5, oFontc,,,, 2)

	nLin += 0025
	oPrn:Say(nLin, 0065, Replicate('-', 259), oFontc,, RGB(220, 220, 220),, 0)
	nLin += 0030

Return

	/*
********************************************************************************************************
***                                                                                                  ***
***                                                                                                  ***
********************************************************************************************************
	*/
Static Function PNAudAn()

	Local nBox := Len(aBox2)
	SCE->(DbGoTop())
	SCE->(DbSetOrder(1))
	SCE->(DbSeek(xFilial('SCE') + mv_par01))
	oPrn:Say(nLin, ((aBox2[nBox, 01] + aBox2[nBox, 02]) / 2), SCE->CE_FORNECE + '/' + SCE->CE_LOJA, oFontc,,,, 2)
	oPrn:Say(nLin, (aBox2[nBox, 02] + 0010), AllTrim(Posicione('SA2', 1, xFilial('SA2') + SCE->CE_FORNECE + SCE->CE_LOJA, 'A2_NOME')), oFontc,,,, 0)
	oPrn:Say(nLin, ((aBox2[nBox, 03] + aBox2[nBox, 04]) / 2), DtoC(SCE->CE_ENTREGA), oFontc,,,, 2)
	oPrn:Say(nLin, (aBox2[nBox, 04] + 0010), AllTrim(SCE->CE_MOTIVO), oFontc,,,, 0)

	nLin += 0025
	oPrn:Say(nLin, 0065, Replicate('-', 259), oFontc,, RGB(220, 220, 220),, 0)
	nLin += 0030

Return
