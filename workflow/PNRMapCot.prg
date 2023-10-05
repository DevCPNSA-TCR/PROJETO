#Include 'rwmake.ch'
#Include 'protheus.ch'
#Include 'totvs.ch'
#Include 'topconn.ch'

/*/{Protheus.doc} novo

@author				Leonardo Pereira
@since				01/01/2014
@version			1.0
@description	Relatorio do mapa de cotacao - Ranking

/*/
User Function PNRMapCot()

	/*/--< variaveis >--/*/
	Private aBox
	Private cLogo := If((AllTrim(SM0->M0_CODFIL) == '0101'), 'LogoPNovo.png', 'LogoTCR.png')
	Private aCab := {}
	Private aNomFor := {}
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
	Private oPrn := TmsPrinter():New('Mapa de Cotacao')
	Private nMaxH := 0
	Private nMaxV := 0
	Private nQTDPg := 0
	Private nPgAtu := 0
	Private nCount := 0
	Private nQtdIt := 19
	Private aDimObj1
	Private aDimObj2
	Private aDimObj3
	Private aDimObj4
	Private aDimObj5
	Private aDimObj6
	Private aDimObj7
	Private aInfoUsu
	Private cProdAval := ''
	// Inclus„o por Peder Munksgaard (Criare Consulting) em 01/06/2015
	Private _aArea := SaveArea1({"SC8","SY1","SA2","SCR"})
    
    SC8->(dbClearFilter())
	// Fim Inclus„o.
	
	cPerg := 'PNRMP'
	
	If !Pergunte(cPerg, .T.)
		Return
	EndIf
	
	oPrn:Setup()
	oPrn:SetLandScape()
	oPrn:SetSize(297, 210)
	
	nMaxV := oPrn:nVertRes()
	nMaxH := oPrn:nHorzRes()
	aBox := {{0055, 200, 500, 1300 , 1500, 1600, 1800, 2100, (nMaxH - 55)}}
	
	cTitulo := 'MAPA DE COTACAO'
	
	aAdd(aCab, cTitulo)
	
	Processa({ |lEnd| PNRBox(@lEnd)}, 'MAPA DE COTACAO', 'Processando dados...', .T.)
	
	RestArea1(_aArea)
	
Return

/*/{Protheus.doc} novo

@author				Leonardo Pereira
@since				01/01/2014
@version			1.0
@description	Imprime os boxes do relatorio

/*/
Static Function PNRBox(lEnd)

	Local nCountFor := 0, nTamDes, nY, nCodFor
	
	Private aCodFor := {}
	
	SC8->(DbGoTop())
	SC8->(DbSetOrder(1))
	If !SC8->(DbSeek(xFilial('SC8') + mv_par01))
		MsgAlert('COTACAO informada nao foi encontrada!', 'Atencao!')
		Return
	EndIf
	
	SC1->(DbSetOrder(1))
	//SC1->(DbSeek(xFilial('SC1') + SC8->C8_NUMSC))
	SC1->(DbSeek(SC8->(C8_FILIAL+C8_NUMSC)))
	
	/*/ Calcula quantidade de quebras de linha para determinar a quantidade final de paginas /*/
	nQLin := 0
	
	//cCodFor := (SC8->C8_FORNECE + SC8->C8_LOJA)
	cCodFor := SC8->C8_FORNECE
	cLjFor  := SC8->C8_LOJA
	
	
	//While !SC8->(Eof()) .And. (SC8->(C8_FILIAL+C8_NUM) == cFilAnt+mv_par01) .And. (cCodFor == (SC8->C8_FORNECE + SC8->C8_LOJA))
	//Alterado por Rafael Sacramento em 30/12/2016
	  While !SC8->(Eof()) .And. (SC8->(C8_FILIAL+C8_NUM) == cFilAnt+mv_par01) .And. (cCodFor == SC8->C8_FORNECE) .And. (cLjFor == SC8->C8_LOJA)
	  
	  
		cDescPro := AllTrim(Posicione('SC1', 1, SC8->( C8_FILIAL + C8_NUMSC + C8_ITEMSC ), 'C1_DESCRI'))
		nTDesc := Len(cDescPro)
		cProdAval += "'" + AllTrim(SC8->C8_PRODUTO) + "',"
		If (nTDesc > 36)
			cDesc := ''
			While !Empty(cDescPro)
				For nTamDes := 1 To nTDesc
					cDesc += SubStr(cDescPro, 1, 1)
					cDescPro := SubStr(cDescPro, 2)
					If (nTamDes == 36) .Or. Empty(cDescPro)
						If (Len(cDescPro) > 0)
							cDesc := ''
							nTamDes := 0
							nQLin++
						Else
							Exit
						EndIf
					EndIf
				Next
			End
		EndIf
		SC8->(DbSkip())
	End
	
	/*/ Realiza a avaliacao dos fornecedores /*/
	cProdAval := SubStr(cProdAval, 1, (Len(cProdAval) - 1))
	
	SC8->(DbGoTop())
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(xFilial('SC8') + mv_par01))
	
	/*/ Verifica se a tabela esta em USO /*/
	If (Select('TMPQTD') > 0)
		TMPQTD->(DbCloseArea())
	EndIf
	/*/ Totaliza o custo de entrada dos itens DEVOLVIDOS /*/
	//cQry := 'SELECT COUNT(C8_NUM) QTDIT FROM ' + RetSqlName('SC8') + " WHERE C8_NUM = '" + SC8->C8_NUM + "' AND C8_FORNECE+C8_LOJA = " + cCodFor + " AND D_E_L_E_T_ = ' ' "
	//Alterado por Rafael Sacramento em 30/12/2016
	cQry := 'SELECT COUNT(C8_NUM) QTDIT FROM ' + RetSqlName('SC8') + " WHERE C8_NUM = '" + SC8->C8_NUM + "' AND D_E_L_E_T_ = ' ' "
	
	TcQuery cQry New ALIAS 'TMPQTD'
	TMPQTD->(DbGoTop())
	If (TMPQTD->QTDIT > 0)
		nQTDPg := ((TMPQTD->QTDIT + nQLin) / nQtdIt)
	EndIf
	If (Int(nQTDPg) < nQTDPg)
		nQTDPg := (Int(nQTDPg) + 2)
	ElseIf (Int(nQTDPg) == nQTDPg)
		nQTDPg := (Int(nQTDPg) + 1)
	EndIf
	
	/*/ Verifica se a tabela esta em USO /*/
	If (Select('WFFORN') > 0)
		WFFORN->(DbCloseArea())
	EndIf
	cQry := 'SELECT DISTINCT C8_FORNECE, C8_LOJA, C8_MOEDA '
	cQry += 'FROM ' + RetSQLName('SC8') + ' SC8 '
	cQry += "WHERE SC8.C8_NUM = '" + SC8->C8_NUM + "' "
	cQry += "AND SC8.C8_FILIAL = '" + SC8->C8_FILIAL + "' "
	cQry += "AND SC8.D_E_L_E_T_ = ' ' "
	cQry += 'ORDER BY C8_FORNECE, C8_LOJA '
	TCQuery cQry New ALIAS 'WFFORN'
	WFFORN->(DbGoTop())
	nCountFor := 0
	While !WFFORN->(Eof())
		nCountFor++
		If (nCountFor > 5)
			Exit
		EndIf
		aAdd(aCodFor, ({'C8_' + ALLTRIM(WFFORN->C8_FORNECE) + ALLTRIM(WFFORN->C8_LOJA) ,WFFORN->C8_MOEDA}))
		WFFORN->(DbSkip())
	End
	
	/*/ Complementa o vetor de fornecedores /*/
	nCodFor := (5 - Len(aCodFor))
	For nY := 1 To nCodFor
		If (nY == 1)
			aAdd(aCodFor, {'A',1})
		ElseIf (nY == 2)
			aAdd(aCodFor, {'B',1})
		ElseIf (nY == 3)
			aAdd(aCodFor, {'C',1})
		ElseIf (nY == 4)
			aAdd(aCodFor, {'D',1})
		EndIf
	Next
	
	/*/ Imprime o cabecalho do mapa de cotacao /*/
	nLin := PNRCabec(1)
	nLin := PNRItens()
	nLin := PNRTotal(2)
	nLin := PNRCabec(2)
	nLin := PNRAprov()
	nLin := PNRObser()
	
	oPrn:EndPage()
	oPrn:Preview()
	
Return

/*/{Protheus.doc} novo

@author				Leonardo Pereira
@since				01/01/2014
@version			1.0
@description	Imprime o cabecalho do relatorio

/*/
Static Function PNRCabec(nOpc)

    Local nY, nX, nW, nZ
    
	nPgAtu++
	
	If !File(cLogo)
		cLogo := 'lgrl' + AllTrim(SM0->M0_CODIGO) + '.bmp'
		If !File(cLogo)
			cLogo := 'lgrl.bmp'
		EndIf
	EndIf

	cLogo := If((cLogo == Nil), '', cLogo)
	aCab := If((aCab == Nil), {''}, aCab)

	oPrn:EndPage()
	oPrn:StartPage()

	/*/ Calcula disposicao/dimensoes do box da pagina do relatorio /*/
	aADisp1 := {0000, 0000, nMaxV, nMaxH}
	aObjHor1 := {{98}}
	aObjVer1 := {{97}}
	aObjMar1 := {50, 50, 50, 0, 0}
	aDimObj1 := U_LMPCalcObj(1, aADisp1, aObjHor1, aObjVer1, aObjMar1)

	/*/ Desenha o box da pagina /*/
	For nX := 1 To Len(aDimObj1)
		For nY := 1 To Len(aDimObj1[nX])
			oPrn:Box(aDimObj1[nX, nY, 1], aDimObj1[nX, nY, 2], aDimObj1[nX, nY, 3], aDimObj1[nX, nY, 4])	// Box da Pagina.
		Next
	Next

	/*/ Calcula disposicao/dimensoes dos boxs do cabecalho do relatorio /*/
	aADisp2 := {aDimObj1[1, 1, 1], aDimObj1[1, 1, 2], aDimObj1[1, 1, 3], aDimObj1[1, 1, 4]}
	aObjHor2 := {{06, 33, 10.17, 10.17, 10.17, 10.17, 10.17, 10.15}, {33, 33, 17, 17}, {100}, {33, 67}, {3, 7, 3, 20, 13.40, 13.40, 13.40, 13.40, 13.40}}
	aObjVer2 := {{7, 7, 7, 7, 7, 7, 7, 7}, {5, 5, 5, 5}, {3}, {7, 7}, {3, 3, 3, 3, 3, 3, 3, 3, 3}}
	aObjMar2 := {5, 5, 10, 5, 5}
	aDimObj2 := U_LMPCalcObj(1, aADisp2, aObjHor2, aObjVer2, aObjMar2)

	/*/ Desenha os boxes do cabecalho /*/
	For nX := 1 To Len(aDimObj2)
		For nY := 1 To Len(aDimObj2[nX])
			If (nX == 1)
				oPrn:Box(aDimObj2[nX, nY, 1], aDimObj2[nX, nY, 2], aDimObj2[nX, nY, 3], aDimObj2[nX, nY, 4])		// Box do cabecalho
				If (nY == 1)
					oPrn:SayBitmap((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 5), cLogo, 0189, 0139)													// Impressao do Logotipo.
				ElseIf (nY == 2)
					oPrn:Say((aDimObj2[nX, nY, 1] + 80), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), aCab[Len(aCab)], oFontaN,,,, 2)					// Impressao do Titulo.
				ElseIf (nY == 3)
					oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'No Solicitacao', oFontbN,,,, 0)									// Solicitacao
					oPrn:Say((aDimObj2[nX, nY, 1] + 80), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), SC8->C8_NUMSC, oFontcN,,,, 2)
				ElseIf (nY == 4)
					oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'No Cotacao', oFontbN,,,, 0)											// Cotacao
					oPrn:Say((aDimObj2[nX, nY, 1] + 80), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), SC8->C8_NUM, oFontcN,,,, 2)											// Natureza
				ElseIf (nY == 5)
					oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Centro de Custo', oFontbN,,,, 0)							// Centro de Custo
					oPrn:Say((aDimObj2[nX, nY, 1] + 80), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), AllTrim(SC1->C1_CC), oFontcN,,,, 2)
				ElseIf (nY == 6)
					oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Conta Orcamentaria', oFontbN,,,, 0)									// Conta Orcamentaria
					oPrn:Say((aDimObj2[nX, nY, 1] + 80), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), AllTrim(SC8->C8_XCO), oFontcN,,,, 2)
				ElseIf (nY == 7)
					oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Natureza', oFontbN,,,, 0)									// Natureza
					oPrn:Say((aDimObj2[nX, nY, 1] + 80), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), AllTrim(SC8->C8_XNAT), oFontcN,,,, 2)
				ElseIf (nY == 8)
					oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Pagina', oFontbN,,,, 0)									// Pagina
					oPrn:Say((aDimObj2[nX, nY, 1] + 50), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), (StrZero(nPgAtu, 2) + '/' + StrZero(nQTDPg, 2)), oFontfN,, RGB(215, 215, 215),, 2)
				EndIf
			ElseIf (nX == 2)
				oPrn:Box(aDimObj2[nX, nY, 1], aDimObj2[nX, nY, 2], aDimObj2[nX, nY, 3], aDimObj2[nX, nY, 4])		// Box do cabecalho
				If (nY == 1)
					oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Solicitante', oFontbN,,,, 0)									// Solicitante
					PswOrder(1)
					If (PswSeek(AllTrim(SC1->C1_USER), .T.))
						aInfoUsu := PswRet(1)
						oPrn:Say((aDimObj2[nX, nY, 1] + 50), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), Upper(AllTrim(aInfoUsu[1, 4])), oFontcN,,,, 2)
					EndIf
				ElseIf (nY == 2)
					oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Comprador', oFontbN,,,, 0)									// Comprador
					SY1->(DbSetOrder(3))
					If SY1->(DbSeek(xFilial('SY1') + SC8->C8_XUSER))
						If !Empty(SY1->Y1_XRESP)
							SY1->(DbSetOrder(1))
							If SY1->(DbSeek(xFilial('SY1') + SY1->Y1_XRESP))
								oPrn:Say((aDimObj2[nX, nY, 1] + 50), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), Upper(AllTrim(SY1->Y1_NOME)), oFontcN,,,, 2)
							EndIf
						Else
							oPrn:Say((aDimObj2[nX, nY, 1] + 50), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), Upper(AllTrim(SY1->Y1_NOME)), oFontcN,,,, 2)
						EndIf
					EndIf
				ElseIf (nY == 3)
					oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Data da Solicitacao', oFontbN,,,, 0)									// Data da Solicitacao
					oPrn:Say((aDimObj2[nX, nY, 1] + 50), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), DtoC(SC1->C1_EMISSAO), oFontcN,,,, 2)
				ElseIf (nY == 4)
					oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Data de Envio da Cotacao', oFontbN,,,, 0)									// Data Envio
					SCR->(DbGoTop())
					SCR->(DbSetOrder(2))
					If SCR->(DbSeek(xFilial('SCR') + 'MC' + SC8->C8_NUM + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))))
						oPrn:Say((aDimObj2[nX, nY, 1] + 50), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), DtoC(SCR->CR_EMISSAO), oFontcN,,,, 2)
					EndIf
				EndIf
			ElseIf (nX == 3)
				If (nOpc == 1)
					oPrn:Box(aDimObj2[nX, nY, 1], aDimObj2[nX, nY, 2], aDimObj2[nX, nY, 3], aDimObj2[nX, nY, 4])		// Box do cabecalho
					oPrn:FillRect({(aDimObj2[nX, nY, 1] + 1), (aDimObj2[nX, nY, 2] + 2), (aDimObj2[nX, nY, 3] - 1), (aDimObj2[nX, nY, 4] - 1)}, oBrush1)
					oPrn:Say((aDimObj2[nX, nY, 1] + 20), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), 'D A D O S   F O R N E C E D O R E S', oFontaN,,,, 2)					// Impressao do titulo da sessao.
				EndIf
			ElseIf (nX == 4)
				If (nOpc == 1)
					oPrn:Box(aDimObj2[nX, nY, 1], aDimObj2[nX, nY, 2], aDimObj2[nX, nY, 3], aDimObj2[nX, nY, 4])		// Box do cabecalho
					If (nY == 2)
						/*/ Calcula disposicao/dimensoes dos boxs do cabecalho do relatorio /*/
						aADisp3 := {aDimObj2[nX, nY, 1], aDimObj2[nX, nY, 2], aDimObj2[nX, nY, 3], aDimObj2[nX, nY, 4]}
						aObjHor3 := {{20, 20, 20, 20, 20}, {20, 20, 20, 20, 20}}
						aObjVer3 := {{70, 70, 70, 70, 70}, {30, 30, 30, 30, 30}}
						aObjMar3 := {0, 0, 0, 0, 0}
						aDimObj3 := U_LMPCalcObj(1, aADisp3, aObjHor3, aObjVer3, aObjMar3)
					
						For nZ := 1 To Len(aDimObj3)
							For nW := 1 To Len(aDimObj3[nZ])
								oPrn:Box(aDimObj3[nZ, nW, 1], aDimObj3[nZ, nW, 2], aDimObj3[nZ, nW, 3], aDimObj3[nZ, nW, 4])		// Box da razao social do fornecedor
								If (nZ == 1)
									SA2->(DbSetOrder(1))
									If SA2->(DbSeek(xFilial('SA2') + SubStr(aCodFor[nW,1], 4)))
										If (SA2->A2_COD + Alltrim(SA2->A2_LOJA) == SubStr(aCodFor[nW,1], 4))
											oPrn:Say((aDimObj3[nZ, nW, 1] + 15), ((aDimObj3[nZ, nW, 2] + aDimObj3[nZ, nW, 4]) / 2), SubStr(SA2->A2_NOME, 1, 15), oFontaN,,,, 2)
											oPrn:Say((aDimObj3[nZ, nW, 1] + 50), ((aDimObj3[nZ, nW, 2] + aDimObj3[nZ, nW, 4]) / 2), SubStr(SA2->A2_NOME, 16, 15), oFontaN,,,, 2)
										EndIf
									EndIf
								ElseIf (nZ == 2)
									SA2->(DbSetOrder(1))
									If SA2->(DbSeek(xFilial('SA2') + SubStr(aCodFor[nW,1], 4)))
										If (SA2->A2_COD + alltrim(SA2->A2_LOJA) == SubStr(aCodFor[nW,1], 4))
											oPrn:Say((aDimObj3[nZ, nW, 1] + 5), ((aDimObj3[nZ, nW, 2] + aDimObj3[nZ, nW, 4]) / 2), 'UF: ' + SA2->A2_EST, oFontaN,,,, 2)					// Item
										EndIf
									EndIf
								EndIf
							Next
						Next
					EndIf
				EndIf
			ElseIf (nX == 5)
				If (nOpc == 1)
					oPrn:Box(aDimObj2[nX, nY, 1], aDimObj2[nX, nY, 2], aDimObj2[nX, nY, 3], aDimObj2[nX, nY, 4])		// Box do cabecalho
					oPrn:FillRect({(aDimObj2[nX, nY, 1] + 2), (aDimObj2[nX, nY, 2] + 2), (aDimObj2[nX, nY, 3] - 1), (aDimObj2[nX, nY, 4] - 1)}, oBrush1)
					If (nY == 1)
						oPrn:Say((aDimObj2[nX, nY, 1] + 20), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), 'IT', oFontaN,,,, 2)					// Item
					ElseIf (nY == 2)
						oPrn:Say((aDimObj2[nX, nY, 1] + 20), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), 'QUANT', oFontaN,,,, 2)					// Quant
					ElseIf (nY == 3)
						oPrn:Say((aDimObj2[nX, nY, 1] + 20), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), 'UM', oFontaN,,,, 2)					// UM
					ElseIf (nY == 4)
						oPrn:Say((aDimObj2[nX, nY, 1] + 20), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), 'DESCRICAO', oFontaN,,,, 2)					// Descricao
					ElseIf (nY == 5)
						oPrn:Say((aDimObj2[nX, nY, 1] + 20), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), 'PRECO UNIT', oFontaN,,,, 2)					// Preco Unitario
					ElseIf (nY == 6)
						oPrn:Say((aDimObj2[nX, nY, 1] + 20), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), 'PRECO UNIT', oFontaN,,,, 2)					// Preco Unitario
					ElseIf (nY == 7)
						oPrn:Say((aDimObj2[nX, nY, 1] + 20), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), 'PRECO UNIT', oFontaN,,,, 2)					// Preco Unitario
					ElseIf (nY == 8)
						oPrn:Say((aDimObj2[nX, nY, 1] + 20), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), 'PRECO UNIT', oFontaN,,,, 2)					// Preco Unitario
					ElseIf (nY == 9)
						oPrn:Say((aDimObj2[nX, nY, 1] + 20), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), 'PRECO UNIT', oFontaN,,,, 2)					// Preco Unitario
					EndIf
				EndIf
			EndIf
		Next
	Next

Return(If((nOpc == 1), aDimObj2[5, 1, 3], aDimObj2[2, 1, 3]))

/*/{Protheus.doc} novo

@author				Leonardo Pereira
@since				01/01/2014
@version			1.0
@description	Imprime os itens da cotacao

/*/
Static Function PNRItens()
		
	Local nLinBkp1
	Local nLinBkp2
	Local cDesProd := ''
	Local cDesImp := '' 
	Local nLenDesc := 0, nY, nTamDes
	local _mV_Simb1 := AllTrim(GetMV('MV_SIMB' + AllTrim(Str(aCodFor[1,2]))))
	local _mV_Simb2	:= AllTrim(GetMV('MV_SIMB' + AllTrim(Str(aCodFor[2,2]))))
	local _mV_Simb3 := AllTrim(GetMV('MV_SIMB'+ AllTrim(Str(aCodFor[3,2]))))
	local _mV_Simb4 := AllTrim(GetMV('MV_SIMB' + AllTrim(Str(aCodFor[4,2]))))
	local _mV_Simb5 := AllTrim(GetMV('MV_SIMB' + AllTrim(Str(aCodFor[5,2]))))
	/*/ Assinala novos valores para os itens da cotacao /*/
	cStrFor := ''
	For nY := 1 To Len(aCodFor)
		cStrFor += '[' + aCodFor[nY,1] + '],'
	Next
	cStrFor := SubStr(cStrFor, 1, (Len(cStrFor) - 1))
	
	/*/ Verifica se a tabela esta em USO /*/
	If (Select('WFITENS') > 0)
		WFITENS->(DbCloseArea())
	EndIf
	
	cQry := 'SELECT C8_FILIAL, C8_ITEM, C8_QUANT, C8_UM, C8_PRODUTO, ' + cStrFor + ', C8_NUMSC, C8_ITEMSC '
	cQry += "FROM (SELECT DISTINCT C8_FILIAL, C8_ITEM, C8_QUANT, C8_UM, C8_PRODUTO, C8_PRECO, ('C8_'+C8_FORNECE+C8_LOJA) FORNECE, C8_NUMSC, C8_ITEMSC "
	cQry += ' FROM ' + RetSQLName('SC8') + ' SC8 '
	cQry += " WHERE SC8.C8_NUM = '" + SC8->C8_NUM + "' "
	cQry += " AND SC8.C8_FILIAL = '" + SC8->C8_FILIAL + "' "
	cQry += " AND SC8.D_E_L_E_T_ = '') AS SOURCEPVT "
	cQry += 'PIVOT (SUM(C8_PRECO) FOR FORNECE IN(' + cStrFor + ')) AS PVT '
	cQry += "WHERE C8_FILIAL = '" + SC8->C8_FILIAL + "' "
	cQry += 'ORDER BY PVT.C8_FILIAL, PVT.C8_ITEM, PVT.C8_PRODUTO '
	TCQuery cQry New ALIAS 'WFITENS'
	WFITENS->(DbGoTop())
	nCntLin := 0
	While !WFITENS->(Eof())
		nCntLin++
		/*/ Impressao dos dados do relatorio /*/
		If (nCount >= nQtdIt)
			/*/ Imprime a parte inferior do pedido de compras /*/
			nLin := PNRTotal(1)
			nLin := PNRCabec(1)
			nCount := 0
			nCntLin := 1
		EndIf
		
		If (Len(AllTrim(Str(nCntLin))) > 1)
			If (SubStr(AllTrim(Str(nCntLin)),2) $ '0|2|4|6|8')
				oPrn:FillRect({(nLin + 15), aDimObj2[5, 1, 2], (nLin + 60), aDimObj2[5, 9, 4]}, oBrush1)
			EndIf
		Else
			If (AllTrim(Str(nCntLin)) $ '0|2|4|6|8')
				oPrn:FillRect({(nLin + 15), aDimObj2[5, 1, 2], (nLin + 60), aDimObj2[5, 9, 4]}, oBrush1)
			EndIf
		EndIf
		
		/*/ Imprime os ITENS da cotacao /*/
		oPrn:Say((nLin + 25), ((aDimObj2[5, 1, 2] + aDimObj2[5, 1, 4]) / 2), WFITENS->C8_ITEM, oFontc,,,, 2)
		oPrn:Say((nLin + 25), ((aDimObj2[5, 2, 2] + aDimObj2[5, 2, 4]) / 2), Transform(WFITENS->C8_QUANT, '@E 999,999.99'), oFontc,,,, 2)
		oPrn:Say((nLin + 25), ((aDimObj2[5, 3, 2] + aDimObj2[5, 3, 4]) / 2), WFITENS->C8_UM, oFontc,,,, 2)
				
		cDesProd := AllTrim(Posicione('SC1', 1, xFilial('SC1') + WFITENS->C8_NUMSC + WFITENS->C8_ITEMSC, 'C1_DESCRI'))
		nLenDesc := Len(cDesProd)
		
		If (nLenDesc > 36)
			nLinBkp1 := nLin
			While !Empty(cDesProd)
				If (nCount == nQtdIt)
					/*/ Imprime a parte inferior do pedido de compras /*/
					nLin := PNRTotal(1)
					nLin := PNRCabec(1)
					nCount := 0
				EndIf
				For nTamDes := 1 To nLenDesc
					cDesImp += SubStr(cDesProd, 1, 1)
					cDesProd := SubStr(cDesProd, 2)
					If (nTamDes == 36) .Or. Empty(cDesProd)
						If (Len(AllTrim(Str(nCntLin))) > 1)
							If (SubStr(AllTrim(Str(nCntLin)),2) $ '0|2|4|6|8')
								oPrn:FillRect({(nLin + 15), aDimObj2[5, 4, 2], (nLin + 60), aDimObj2[5, 9, 4]}, oBrush1)
							EndIf
						Else
							If (AllTrim(Str(nCntLin)) $ '0|2|4|6|8')
								oPrn:FillRect({(nLin + 15), aDimObj2[5, 4, 2], (nLin + 60), aDimObj2[5, 9, 4]}, oBrush1)
							EndIf
						EndIf
						oPrn:Say((nLin + 25), (aDimObj2[5, 4, 2] + 10), cDesImp, oFontc,,,, 0)
						cDesImp := ''
						lFirst := .F.
						nTamDes := 0
						nCount++
						nLin += 0045
						If (Len(cDesProd) == 0)
							nLin -= 0045
							Exit
						EndIf
					EndIf
				Next
			End
		Else
			nCount++
			oPrn:Say((nLin + 25), (aDimObj2[5, 4, 2] + 10), cDesProd, oFontc,,,, 0)
		EndIf
		
		If (nLenDesc > 36)
			nLinBkp2 := nLin
			nLin := nLinBkp1
		EndIf
        
        // AlteraÁ„o por Peder Munksgaard (Criare Consulting) em 01/06/2015
        // Se faz necess·rio devido ao aparente erro de c·lculo com apenas duas casas
        // decimais.
        /* 		        
		oPrn:Say((nLin + 25), ((aDimObj2[5, 5, 2] + aDimObj2[5, 5, 4]) / 2),+ AllTrim(GetMV('MV_SIMB' + AllTrim(Str(aCodFor[1,2]))))+ " " + Transform(&('WFITENS->' + aCodFor[1,1]), '@E 9,999,999.99'), oFontc,,,, 2)
		oPrn:Say((nLin + 25), ((aDimObj2[5, 6, 2] + aDimObj2[5, 6, 4]) / 2),+ AllTrim(GetMV('MV_SIMB' + AllTrim(Str(aCodFor[2,2]))))+ " " + Transform(&('WFITENS->' + aCodFor[2,1]), '@E 9,999,999.99'), oFontc,,,, 2)
		oPrn:Say((nLin + 25), ((aDimObj2[5, 7, 2] + aDimObj2[5, 7, 4]) / 2),+ AllTrim(GetMV('MV_SIMB' + AllTrim(Str(aCodFor[3,2]))))+ " " + Transform(&('WFITENS->' + aCodFor[3,1]), '@E 9,999,999.99'), oFontc,,,, 2)
		oPrn:Say((nLin + 25), ((aDimObj2[5, 8, 2] + aDimObj2[5, 8, 4]) / 2),+ AllTrim(GetMV('MV_SIMB' + AllTrim(Str(aCodFor[4,2]))))+ " " + Transform(&('WFITENS->' + aCodFor[4,1]), '@E 9,999,999.99'), oFontc,,,, 2)
		oPrn:Say((nLin + 25), ((aDimObj2[5, 9, 2] + aDimObj2[5, 9, 4]) / 2),+ AllTrim(GetMV('MV_SIMB' + AllTrim(Str(aCodFor[5,2]))))+ " " + Transform(&('WFITENS->' + aCodFor[5,1]), '@E 9,999,999.99'), oFontc,,,, 2)
		*/
		oPrn:Say((nLin + 25), ((aDimObj2[5, 5, 2] + aDimObj2[5, 5, 4]) / 2),+ _mV_Simb1 + " " + Transform(&('WFITENS->' + aCodFor[1,1]), '@E 9,999,999.9999'), oFontc,,,, 2)
		oPrn:Say((nLin + 25), ((aDimObj2[5, 6, 2] + aDimObj2[5, 6, 4]) / 2),+ _mV_Simb2 + " " + Transform(&('WFITENS->' + aCodFor[2,1]), '@E 9,999,999.9999'), oFontc,,,, 2)
		oPrn:Say((nLin + 25), ((aDimObj2[5, 7, 2] + aDimObj2[5, 7, 4]) / 2),+ _mV_Simb3 + " " + Transform(&('WFITENS->' + aCodFor[3,1]), '@E 9,999,999.9999'), oFontc,,,, 2)
		oPrn:Say((nLin + 25), ((aDimObj2[5, 8, 2] + aDimObj2[5, 8, 4]) / 2),+ _mV_Simb4 + " " + Transform(&('WFITENS->' + aCodFor[4,1]), '@E 9,999,999.9999'), oFontc,,,, 2)
		oPrn:Say((nLin + 25), ((aDimObj2[5, 9, 2] + aDimObj2[5, 9, 4]) / 2),+ _mV_Simb5 + " " + Transform(&('WFITENS->' + aCodFor[5,1]), '@E 9,999,999.9999'), oFontc,,,, 2)		
		WFITENS->(DbSkip())
		
		If (nLenDesc > 36)
			nLin := nLinBkp2
		EndIf

		nLin += 0050
		oPrn:Say(nLin, 0065, Replicate('-', 259), oFontc,, RGB(220, 220, 220),, 0)
		nLin += 0020
	End

Return(nLin)

/*/{Protheus.doc} novo

@author				Leonardo Pereira
@since				01/01/2014
@version			1.0
@description	Imprime os grids de totais (analise) do relatorio

/*/
Static Function PNRTotal(nOpc)

    Local nK, nJ
    
	If (nLin <= 2000)
		nLin := 2000
	Else
		nLin := PNRCabec(1)
	EndIf
	 
	/*/ Calcula disposicao/dimensoes do box da pagina do relatorio /*/
	aADisp4 := {(nLin - 100), aDimObj1[1, 1, 2], aDimObj1[1, 1, 3], aDimObj1[1, 1, 4]}
	aObjHor4 := {{100}, {33, 13.40, 13.40, 13.40, 13.40, 13.40}, {33, 13.40, 13.40, 13.40, 13.40, 13.40}, {33, 13.40, 13.40, 13.40, 13.40, 13.40}, {33, 13.40, 13.40, 13.40, 13.40, 13.40}, {33, 13.40, 13.40, 13.40, 13.40, 13.40}, {33, 13.40, 13.40, 13.40, 13.40, 13.40}, {33, 13.40, 13.40, 13.40, 13.40, 13.40}}
	aObjVer4 := {{12.50}, {12.50, 12.50, 12.50, 12.50, 12.50, 12.50}, {12.50, 12.50, 12.50, 12.50, 12.50, 12.50}, {12.50, 12.50, 12.50, 12.50, 12.50, 12.50}, {12.50, 12.50, 12.50, 12.50, 12.50, 12.50}, {12.50, 12.50, 12.50, 12.50, 12.50, 12.50}, {12.50, 12.50, 12.50, 12.50, 12.50, 12.50}, {12.50, 12.50, 12.50, 12.50, 12.50, 12.50}}
	aObjMar4 := {5, 5, 10, 10, 5}
	aDimObj4 := U_LMPCalcObj(1, aADisp4, aObjHor4, aObjVer4, aObjMar4)
	
	/*/ Desenha os boxes da analise /*/
	For nJ := 1 To Len(aDimObj4)
		For nK := 1 To Len(aDimObj4[nJ])
			oPrn:Box(aDimObj4[nJ, nK, 1], aDimObj4[nJ, nK, 2], aDimObj4[nJ, nK, 3], aDimObj4[nJ, nK, 4])		// Box do cabecalho
			If (nJ == 1)
				If (nK == 1)
					oPrn:FillRect({(aDimObj4[nJ, nK, 1] + 1), (aDimObj4[nJ, nK, 2] + 2), (aDimObj4[nJ, nK, 3] - 1), (aDimObj4[nJ, nK, 4] - 1)}, oBrush1)
					oPrn:Say((aDimObj4[nJ, nK, 1] + 5), ((aDimObj4[nJ, nK, 2] + aDimObj4[nJ, nK, 4]) / 2), 'D A D O S   A N A L I S E', oFontaN,,,, 2)					// Impressao do titulo da sessao.
				EndIf
			ElseIf (nJ > 1)
				If (nK == 1)
					oPrn:FillRect({(aDimObj4[nJ, nK, 1] + 1), (aDimObj4[nJ, nK, 2] + 2), (aDimObj4[nJ, nK, 3] - 1), (aDimObj4[nJ, nK, 4] - 1)}, oBrush1)
				EndIf
				If (nJ == 2) .And. (nK == 1)
					oPrn:Say((aDimObj4[nJ, nK, 1] + 5), ((aDimObj4[nJ, nK, 2] + aDimObj4[nJ, nK, 4]) / 2), 'TOTAL DA COTACAO', oFontaN,,,, 2)					// Impressao do total da cotacao.
				ElseIf (nJ == 3) .And. (nK == 1)
					oPrn:Say((aDimObj4[nJ, nK, 1] + 5), ((aDimObj4[nJ, nK, 2] + aDimObj4[nJ, nK, 4]) / 2), 'PRAZO DE ENTREGA', oFontaN,,,, 2)					// Impressao do prazo de entrega.
				ElseIf (nJ == 4) .And. (nK == 1)
					oPrn:Say((aDimObj4[nJ, nK, 1] + 5), ((aDimObj4[nJ, nK, 2] + aDimObj4[nJ, nK, 4]) / 2), 'TOTAL DO FRETE', oFontaN,,,, 2)					// Impressao do total do frete.
				ElseIf (nJ == 5) .And. (nK == 1)
					oPrn:Say((aDimObj4[nJ, nK, 1] + 5), ((aDimObj4[nJ, nK, 2] + aDimObj4[nJ, nK, 4]) / 2), 'TOTAL DO IPI', oFontaN,,,, 2)					// Impressao do total do IPI.
				ElseIf (nJ == 6) .And. (nK == 1)
					oPrn:Say((aDimObj4[nJ, nK, 1] + 5), ((aDimObj4[nJ, nK, 2] + aDimObj4[nJ, nK, 4]) / 2), 'TOTAL DO ICMS', oFontaN,,,, 2)					// Impressao do total do ICMS.
				ElseIf (nJ == 7) .And. (nK == 1)
					oPrn:Say((aDimObj4[nJ, nK, 1] + 5), ((aDimObj4[nJ, nK, 2] + aDimObj4[nJ, nK, 4]) / 2), 'CONDICAO DE PAGAMENTO', oFontaN,,,, 2)					// Impressao do condicao de pagto.
				ElseIf (nJ == 8) .And. (nK == 1)
					oPrn:Say((aDimObj4[nJ, nK, 1] + 5), ((aDimObj4[nJ, nK, 2] + aDimObj4[nJ, nK, 4]) / 2), 'AVALIACAO DO FORNECEDOR', oFontaN,,,, 2)					// Impressao da avaliacao do fornecedor.
				EndIf
			EndIf
		Next
	Next
	
	If (nOpc == 2)
		/*/ Verifica se a tabela esta em USO /*/
		If (Select('WFDADOS') > 0)
			WFDADOS->(DbCloseArea())
		EndIf
		cQry := 'SELECT SC8.C8_NUM, SC8.C8_FORNECE, SC8.C8_LOJA, SC8.C8_PRAZO, SC8.C8_COND, SC8.C8_CONTATO, MAX(SC8.C8_TOTFRE) C8_TOTFRE, SUM(SC8.C8_TOTAL) C8_TOTCOT, SUM(SC8.C8_VALIPI) C8_TOTIPI, SUM(SC8.C8_VALICM) C8_TOTICM,'
		cQry += 'SUM(SC8.C8_VLDESC) C8_VLDESC, SUM(SC8.C8_DESPESA) C8_DESPESA, SUM(SC8.C8_SEGURO) C8_SEGURO '
		cQry += 'FROM ' + RetSQLName('SC8') + ' SC8 '
		cQry += "WHERE SC8.C8_NUM = '" + SC8->C8_NUM + "' "
		cQry += "AND SC8.C8_FILIAL = '" + SC8->C8_FILIAL + "' "
		cQry += "AND SC8.D_E_L_E_T_ = '' "
		cQry += 'GROUP BY SC8.C8_NUM, SC8.C8_FORNECE, SC8.C8_LOJA, SC8.C8_PRAZO, SC8.C8_COND, SC8.C8_CONTATO '
		cQry += 'ORDER BY SC8.C8_NUM, SC8.C8_FORNECE, SC8.C8_LOJA'
		TCQuery cQry New ALIAS 'WFDADOS'
		
		///WFDADOS->(DbGoTop())
		
		//nLinFor := 2
		//nColFor := 2
		_nRegs := Contar("WFDADOS","!Eof()")
		
		nLinFor := Iif( _nRegs > 5, 1, 2)
		nColFor := Iif( _nRegs > 5, 1, 2)

        WFDADOS->(DbGoTop())
        	    	    
		While !WFDADOS->(Eof())
			oPrn:Say((aDimObj4[nLinFor, nColFor, 1] + 5), ((aDimObj4[nLinFor, nColFor, 2] + aDimObj4[nLinFor, nColFor, 4]) / 2), Transform(((WFDADOS->C8_TOTCOT + WFDADOS->C8_TOTFRE + WFDADOS->C8_TOTIPI + WFDADOS->C8_DESPESA + WFDADOS->C8_SEGURO) - WFDADOS->C8_VLDESC), '@E 9,999,999.99'), oFontaN,,,, 2)
			nLinFor++
			oPrn:Say((aDimObj4[nLinFor, nColFor, 1] + 5), ((aDimObj4[nLinFor, nColFor, 2] + aDimObj4[nLinFor, nColFor, 4]) / 2), Transform(WFDADOS->C8_PRAZO, '@E 999') + ' DIAS', oFontaN,,,, 2)
			nLinFor++
			oPrn:Say((aDimObj4[nLinFor, nColFor, 1] + 5), ((aDimObj4[nLinFor, nColFor, 2] + aDimObj4[nLinFor, nColFor, 4]) / 2), Transform(WFDADOS->C8_TOTFRE, '@E 9,999,999.99'), oFontaN,,,, 2)
			nLinFor++
			oPrn:Say((aDimObj4[nLinFor, nColFor, 1] + 5), ((aDimObj4[nLinFor, nColFor, 2] + aDimObj4[nLinFor, nColFor, 4]) / 2), Transform(WFDADOS->C8_TOTIPI, '@E 9,999,999.99'), oFontaN,,,, 2)
			nLinFor++
			oPrn:Say((aDimObj4[nLinFor, nColFor, 1] + 5), ((aDimObj4[nLinFor, nColFor, 2] + aDimObj4[nLinFor, nColFor, 4]) / 2), Transform(WFDADOS->C8_TOTICM, '@E 9,999,999.99'), oFontaN,,,, 2)
			nLinFor++
			/*/ Condicao de pagamento /*/
			SE4->(DbSetOrder(1))
			If SE4->(DbSeek(xFilial('SE4') + WFDADOS->C8_COND))
				oPrn:Say((aDimObj4[nLinFor, nColFor, 1] + 5), ((aDimObj4[nLinFor, nColFor, 2] + aDimObj4[nLinFor, nColFor, 4]) / 2), SE4->E4_CODIGO + ' - ' + AllTrim(SE4->E4_DESCRI), oFontaN,,,, 2)
			EndIf
		
			nLinFor++

			/*/ Verifica se a tabela esta em USO /*/
			If (Select('WFAVALb') > 0)
				WFAVALb->(DbCloseArea())
			EndIf
			cQry := 'SELECT (SUM(A5_NOTA) / COUNT(A5_PRODUTO)) AVGNOTA '
			cQry += 'FROM ' + RetSQLName('SA5') + ' SA5 '
			cQry += "WHERE SA5.A5_FORNECE = '" + WFDADOS->C8_FORNECE + "' "
			cQry += "AND SA5.A5_LOJA = '" + WFDADOS->C8_LOJA + "' "
			cQry += "AND SA5.A5_PRODUTO IN(" + cProdAval + ") "
			TCQuery cQry New ALIAS 'WFAVALb'
			WFAVALb->(DbGoTop())
			If !WFAVALb->(Eof())
				oPrn:Say((aDimObj4[nLinFor, nColFor, 1] + 5), ((aDimObj4[nLinFor, nColFor, 2] + aDimObj4[nLinFor, nColFor, 4]) / 2), 'NOTA: ' + StrZero(WFAVALb->AVGNOTA, 1), oFontaN,,,, 2)
			EndIf
			WFDADOS->(DbSkip())
			nLinFor := 2
			nColFor++
		End
	EndIf

Return(aDimObj4[8, 1, 3])

/*/{Protheus.doc} novo

@author				Leonardo Pereira
@since				01/01/2014
@version			1.0
@description	Imprime os grids de aprovadores (ranking) do relatorio

/*/
Static Function PNRAprov()

    Local nJ, nK, nL, nFor
	/*/ Calcula disposicao/dimensoes do box da pagina do relatorio /*/
	aADisp5 := {nLin, aDimObj1[1, 1, 2], aDimObj1[1, 1, 3], aDimObj1[1, 1, 4]}
	aObjHor5 := {{100}, {14, 9, 7, 14, 14, 14, 14, 14}}
	aObjVer5 := {{3}, {3, 3, 3, 3, 3, 3, 3, 3}}
	aObjMar5 := {5, 5, 10, 5, 5}
	aDimObj5 := U_LMPCalcObj(1, aADisp5, aObjHor5, aObjVer5, aObjMar5)
	
	/*/ Desenha os boxes da analise /*/
	For nJ := 1 To Len(aDimObj5)
		For nK := 1 To Len(aDimObj5[nJ])
			oPrn:Box(aDimObj5[nJ, nK, 1], aDimObj5[nJ, nK, 2], aDimObj5[nJ, nK, 3], aDimObj5[nJ, nK, 4])		// Box do cabecalho
			If (nJ == 1)
				If (nK == 1)
					oPrn:FillRect({(aDimObj5[nJ, nK, 1] + 1), (aDimObj5[nJ, nK, 2] + 2), (aDimObj5[nJ, nK, 3] - 1), (aDimObj5[nJ, nK, 4] - 1)}, oBrush1)
					oPrn:Say((aDimObj5[nJ, nK, 1] + 5), ((aDimObj5[nJ, nK, 2] + aDimObj5[nJ, nK, 4]) / 2), 'RANKING DO MAPA DE COTACAO', oFontaN,,,, 2)					// Impressao do titulo da sessao.
				EndIf
			ElseIf (nJ == 2)
				oPrn:FillRect({(aDimObj5[nJ, nK, 1] + 1), (aDimObj5[nJ, nK, 2] + 2), (aDimObj5[nJ, nK, 3] - 1), (aDimObj5[nJ, nK, 4] - 1)}, oBrush1)
				If (nK == 1)
					oPrn:Say((aDimObj5[nJ, nK, 1] + 5), ((aDimObj5[nJ, nK, 2] + aDimObj5[nJ, nK, 4]) / 2), 'APROVADOR', oFontaN,,,, 2)						// Impressao do APROVADOR.
				ElseIf (nK == 2)
					oPrn:Say((aDimObj5[nJ, nK, 1] + 5), ((aDimObj5[nJ, nK, 2] + aDimObj5[nJ, nK, 4]) / 2), 'DATA APRV', oFontaN,,,, 2)				// Impressao da DATA DE APROVACAO.
				ElseIf (nK == 3)
					oPrn:Say((aDimObj5[nJ, nK, 1] + 5), ((aDimObj5[nJ, nK, 2] + aDimObj5[nJ, nK, 4]) / 2), 'STATUS', oFontaN,,,, 2)				// Impressao do STATUS.
				ElseIf (nK == 4)
					oPrn:Say((aDimObj5[nJ, nK, 1] + 5), ((aDimObj5[nJ, nK, 2] + aDimObj5[nJ, nK, 4]) / 2), '1O COLOCADO', oFontaN,,,, 2)					// Impressao do 1O COLOCADO.
				ElseIf (nK == 5)
					oPrn:Say((aDimObj5[nJ, nK, 1] + 5), ((aDimObj5[nJ, nK, 2] + aDimObj5[nJ, nK, 4]) / 2), '2O COLOCADO', oFontaN,,,, 2)					// Impressao do 2O COLOCADO.
				ElseIf (nK == 6)
					oPrn:Say((aDimObj5[nJ, nK, 1] + 5), ((aDimObj5[nJ, nK, 2] + aDimObj5[nJ, nK, 4]) / 2), '3O COLOCADO', oFontaN,,,, 2)					// Impressao do 3O COLOCADO.
				ElseIf (nK == 7)
					oPrn:Say((aDimObj5[nJ, nK, 1] + 5), ((aDimObj5[nJ, nK, 2] + aDimObj5[nJ, nK, 4]) / 2), '4O COLOCADO', oFontaN,,,, 2)					// Impressao do 4O COLOCADO.
				ElseIf (nK == 8)
					oPrn:Say((aDimObj5[nJ, nK, 1] + 5), ((aDimObj5[nJ, nK, 2] + aDimObj5[nJ, nK, 4]) / 2), '5O COLOCADO', oFontaN,,,, 2)					// Impressao do 5O COLOCADO.
				EndIf
			EndIf
		Next
	Next
	
	nLin := (aDimObj5[2, 1, 3] + 15)
	
	SCR->(DbGoTop())
	SCR->(DbSetOrder(1))
	If SCR->(DbSeek(xFilial('SCR') + 'MC' + SC8->C8_NUM + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))))
		While !SCR->(Eof()) .And. (SCR->CR_TIPO == 'MC') .And. (AllTrim(SCR->CR_NUM) == SC8->C8_NUM)
			If (AllTrim(SCR->CR_STATUS) == '03') .Or. (AllTrim(SCR->CR_STATUS) == '04')
				SAK->(DbGoTop())
				SAK->(DbSetOrder(2))
				If SAK->(DbSeek(xFilial('SAK') + SCR->CR_USER))
					oPrn:Say(nLin, ((aDimObj5[2, 1, 2] + aDimObj5[2, 1, 4]) / 2), SubStr(Upper(SAK->AK_NOME), 1, 17), oFontaN,,,, 2)					// Impressao do APROVADOR.
				EndIf
				
				oPrn:Say(nLin, ((aDimObj5[2, 2, 2] + aDimObj5[2, 2, 4]) / 2), DtoC(SCR->CR_DATALIB), oFontaN,,,, 2)					// Impressao do DATA LIBERACAO.
				oPrn:Say(nLin, ((aDimObj5[2, 3, 2] + aDimObj5[2, 3, 4]) / 2), If((AllTrim(SCR->CR_STATUS) == '03'), 'APRV.', 'REJ.'), oFontaN,,,, 2)					// Impressao do STATUS.
				
				SA2->(DbSetOrder(1))
				For nL := 1 To 5
					cCpo := 'SCR->CR_RKN' + AllTrim(Str(nL))
					If SA2->(DbSeek(xFilial('SA2') + SubStr(&(cCpo),1,6) + SubStr(&(cCpo), 8, 2)))
						oPrn:Say(nLin, ((aDimObj5[2, (3 + nL), 2] + aDimObj5[2, (3 + nL), 4]) / 2), SubStr(&(cCpo),1,6) + '/' + SubStr(&(cCpo), 8, 2), oFontaN,,,, 2)					// Impressao do CODIGO DO FORNECEDOR.
						If (aScan(aNomFor, {|x| AllTrim(x[1]) == SubStr(&(cCpo),1,6) + '/' + SubStr(&(cCpo), 8, 2)}) == 0)
							aAdd(aNomFor, {SubStr(&(cCpo),1,6) + '/' + SubStr(&(cCpo), 8, 2), AllTrim(SA2->A2_NOME)})
						EndIf
					EndIf
				Next
				nLin += 0030
				oPrn:Say(nLin, 0065, Replicate('-', 259), oFontc,, RGB(220, 220, 220),, 0)
				nLin += 0040
			EndIf
			SCR->(DbSkip())
		End
		
		/*/ Impressao do nome do fornecedor /*/
		oPrn:Say(nLin, 0065, 'FORNECEDORES:', oFontaN,,,, 0)
		nLin += 0045
		For nFor := 1 To Len(aNomFor)
			oPrn:Say(nLin, 0065, aNomFor[nFor, 01] + ' - ' + aNomFor[nFor, 02], oFontaN,,,, 0)					// Impressao do NOME DO FORNECEDOR.
			nLin += 0045
		Next
	EndIf
	
Return(nLin)

/*/{Protheus.doc} novo

@author				Leonardo Pereira
@since				01/01/2014
@version			1.0
@description	Imprime os grids de observacoes do relatorio

/*/
Static Function PNRObser()

	// Local cDesImp := '' RETIRADO FELIPE DO NASCIMENTO 11/02/2015
    local aObs, nK, nJ
	local x
	
	/*/ Calcula disposicao/dimensoes do box da pagina do relatorio /*/
	aADisp6 := {(nLin + 50), aDimObj1[1, 1, 2], aDimObj1[1, 1, 3], aDimObj1[1, 1, 4]}
	aObjHor6 := {{100}}
	aObjVer6 := {{4}}
	aObjMar6 := {5, 5, 10, 5, 5}
	aDimObj6 := U_LMPCalcObj(1, aADisp6, aObjHor6, aObjVer6, aObjMar6)
	
	/*/ Desenha os boxes da observacao /*/
	oPrn:Box(aDimObj6[1, 1, 1], aDimObj6[1, 1, 2], aDimObj6[1, 1, 3], aDimObj6[1, 1, 4])		// Box do cabecalho
	oPrn:FillRect({(aDimObj6[1, 1, 1] + 1), (aDimObj6[1, 1, 2] + 2), (aDimObj6[1, 1, 3] - 1), (aDimObj6[1, 1, 4] - 1)}, oBrush1)
	oPrn:Say((aDimObj6[1, 1, 1] + 7), ((aDimObj6[1, 1, 2] + aDimObj6[1, 1, 4]) / 2), 'OBSERVACAO DO COMPRADOR', oFontaN,,,, 2)					// Impressao do titulo da sessao.
	
	nLin := (aDimObj6[1, 1, 3] + 50)
	
	SC8->(DbGoTop())
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(xFilial('SC8') + mv_par01))
	//cCodFor := (SC8->C8_FORNECE + SC8->C8_LOJA)
	cCodFor := SC8->C8_FORNECE
	cLjFor := SC8->C8_LOJA
	
	//Alterado por Rafael Sacramento em 25/10/2016 - Para exibir apenas a observaÁ„o do primeiro item.
	//While !SC8->(Eof()) .And. (SC8->C8_NUM == mv_par01) .And. (cCodFor == (SC8->C8_FORNECE + SC8->C8_LOJA))

	//While !SC8->(Eof()) .And. (SC8->C8_NUM == mv_par01) .And. (cCodFor == (SC8->C8_FORNECE + SC8->C8_LOJA)) .And. (SC8->C8_ITEM == '0001')
	  While !SC8->(Eof()) .And. (SC8->C8_NUM == mv_par01) .And. (cCodFor == SC8->C8_FORNECE) .And. (cLjFor == SC8->C8_LOJA) .And. (SC8->C8_ITEM == '0001')
	
	    // INICIO INSERIDO FELIPE DO NASCIMENTO - 11/02/2015
	    
	    aObs := breakObs(SC8->C8_XOBSCOT, ((aDimObj6[1, 1, 4] - aDimObj6[1, 1, 2]) + 10), oPrn, oFontc)
		
		for x := 1 to len(aObs)
		   oPrn:Say(nLin, (aDimObj6[1, 1, 2] + 10), aObs[x], oFontc,,,, 0)
		   nLin += 0045
		next x
		
		// FIM INSERIDO FELIPE DO NASCIMENTO - 11/02/2015
		
		
		/* INICIO RETIRADO FELIPE DO NASCIMENTO - 11/02/2015 
		If !(Empty(SC8->C8_XOBSCOT))
			cObserv := ''
			For nObs := 1 To 10
				cObserv += AllTrim(MemoLine(SC8->C8_XOBSCOT, , nObs))+ ' '
			Next
			nLenObs := Len(cObserv)
			If (nLenObs > 250)
				While !Empty(cObserv)
					For nTamDes := 1 To nLenObs
						cDesImp += SubStr(cObserv, 1, 1)
						cObserv := SubStr(cObserv, 2)
						If (nTamDes == 250) .Or. Empty(cObserv)
							oPrn:Say(nLin, (aDimObj6[1, 1, 2] + 10), cDesImp, oFontc,,,, 0)
							cDesImp := ''
							nTamDes := 0
							nLin += 0045
							If (Len(cObserv) == 0)
								Exit
							EndIf
						EndIf
					Next
				End
			Else
				oPrn:Say(nLin, (aDimObj6[1, 1, 2] + 10), cObserv, oFontc,,,, 0)
				nLin += 0045
			EndIf
			Exit
		EndIf
		FIM RETIRADO FELIPE DO NASCIMENTO */
		
		SC8->(DbSkip())
	End
	
	SC8->(DbGoTop())
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(xFilial('SC8') + mv_par01))
		
	/*/ Calcula disposicao/dimensoes do box da pagina do relatorio /*/
	aADisp7 := {(nLin + 50), aDimObj1[1, 1, 2], aDimObj1[1, 1, 3], aDimObj1[1, 1, 4]}
	aObjHor7 := {{100}, {30, 70}}
	aObjVer7 := {{5}, {5, 5}}
	aObjMar7 := {5, 5, 10, 5, 5}
	aDimObj7 := U_LMPCalcObj(1, aADisp7, aObjHor7, aObjVer7, aObjMar7)
		
	/*/ Desenha os boxes da observacao /*/
	For nJ := 1 To Len(aDimObj7)
		For nK := 1 To Len(aDimObj7[nJ])
			oPrn:Box(aDimObj7[nJ, nK, 1], aDimObj7[nJ, nK, 2], aDimObj7[nJ, nK, 3], aDimObj7[nJ, nK, 4])		// Box do cabecalho
			oPrn:FillRect({(aDimObj7[nJ, nK, 1] + 1), (aDimObj7[nJ, nK, 2] + 2), (aDimObj7[nJ, nK, 3] - 1), (aDimObj7[nJ, nK, 4] - 1)}, oBrush1)
			If (nJ == 1)
				oPrn:Say((aDimObj7[nJ, nK, 1] + 5), ((aDimObj7[nJ, nK, 2] + aDimObj7[nJ, nK, 4]) / 2), 'OBSERVACOES DOS APROVADORES', oFontaN,,,, 2)					// Impressao do titulo da sessao.
			ElseIf (nJ == 2)
				If (nK == 1)
					oPrn:Say((aDimObj7[nJ, nK, 1] + 5), ((aDimObj7[nJ, nK, 2] + aDimObj7[nJ, nK, 4]) / 2), 'APROVADOR', oFontaN,,,, 2)					// Impressao do titulo da sessao.
				ElseIf (nK == 2)
					oPrn:Say((aDimObj7[nJ, nK, 1] + 5), ((aDimObj7[nJ, nK, 2] + aDimObj7[nJ, nK, 4]) / 2), 'OBSERVACAO', oFontaN,,,, 2)					// Impressao do titulo da sessao.
				EndIf
			EndIf
		Next
	Next
	
	nLin := (aDimObj7[2, 1, 3] + 50)
	
	
	SCR->(DbGoTop())
	SCR->(DbSetOrder(1))
	If SCR->(DbSeek(xFilial('SCR') + 'MC' + SC8->C8_NUM + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))))
		While !SCR->(Eof()) .And. (SCR->CR_TIPO == 'MC') .And. (AllTrim(SCR->CR_NUM) == SC8->C8_NUM)
			If (AllTrim(SCR->CR_STATUS) == '03') .Or. (AllTrim(SCR->CR_STATUS) == '04')
			
//				If !(Empty(AllTrim(SCR->CR_OBS)))  RETIRADO FELIPE DO NASCIMENTO 11/02/2015
				If !(Empty(AllTrim(SCR->CR_XOBSAPR)))
					SAK->(DbGoTop())
					SAK->(DbSetOrder(2))
					If SAK->(DbSeek(xFilial('SAK') + SCR->CR_USER))
						oPrn:Say(nLin, ((aDimObj7[2, 1, 2] + aDimObj7[2, 1, 4]) / 2), Upper(SAK->AK_NOME), oFontaN,,,, 2)					// Impressao do APROVADOR.
					EndIf

                    /* INICIO INSERIDO FELIPE DO NASCIMENTO - 11/02/2015 */
	                aObs := breakObs(SCR->CR_XOBSAPR, ((aDimObj7[2, 2, 4] - aDimObj7[2, 2, 2]) - 10), oPrn, oFontc)
		
		            for x := 1 to len(aObs)
		               oPrn:Say(nLin, (aDimObj7[2, 2, 2] + 10), aObs[x], oFontc,,,, 0)
		               nLin += 0045
		            next x
		
		            /* FIM INSERIDO FELIPE DO NASCIMENTO - 11/02/2015
		            */
			
					/* INICIO RETIRADO FELIPE DO NASCIMENTO - 11/02/2015
					cDesImp := ''
					cObserv := ""
					For nObs := 1 To 10
						cObserv += AllTrim(MemoLine(SCR->CR_XOBSAPR, , nObs))+ ' '
					Next
					cObserv := Alltrim(cObserv)
					nLenObs := Len(cObserv)
		
					If (nLenObs > 150)
						While !Empty(cObserv)
							For nTamDes := 1 To nLenObs
								cDesImp += SubStr(cObserv, 1, 1)
								cObserv := SubStr(cObserv, 2)
								If (nTamDes == 150) .Or. Empty(cObserv)
									oPrn:Say(nLin, (aDimObj7[2, 2, 2] + 10), cDesImp, oFontc,,,, 0)
									cDesImp := ''
									nTamDes := 0
									nLin += 0045
									If (Len(cObserv) == 0)
										Exit
									EndIf
								EndIf
							Next
						End
					Else
						oPrn:Say(nLin, (aDimObj7[2, 2, 2] + 10), cObserv, oFontc,,,, 0)
					EndIf
					FIM RETIRADO FELIPE DO NASCIMENTO 11/02/2015 */
					
					nLin += 0030
					oPrn:Say(nLin, 0065, Replicate('-', 259), oFontc,, RGB(220, 220, 220),, 0)
					nLin += 0040
					
				EndIf 
				
			EndIf
			SCR->(DbSkip())
		End
	EndIf
	
Return

/*
-------------------------------------------------------------------------------------------------------
| FUN«√O: breakObserv                  | AUTOR: Felipe do Nascimento             | DATA: 11/02/2015   |
-------------------------------------------------------------------------------------------------------
| OBJETIVO: Quebrar string de observa√ß√£o do campo memo conforme o tamanho em pixel do retangulo     |
|           onde ela ser√° impressa. Valida para objetos TMSPrinter                                   |
| PARAMETROS:                                                                                         |
|            cObs <Carcter - Memo> - Campo memo contendo a observa√ß√£o a ser quebrada                |
|            nTamMaxLin <N√∫merico> - Tamanho m√°ximo da linha em pixel                               |
|            oPrn <TMSPRinter> - Nome do objeto TMSPrinter                                            |
|            oFont <TFont>     - Nome do objeto da fonte da string a ser impressa                     |
| RETORNO:                                                                                            |
|         <Vetor - Caracter> - Contendo as linhas quebradas da string                                 |
-------------------------------------------------------------------------------------------------------
|                                     CONTROLE DE REVIS√ïES                                           |
-------------------------------------------------------------------------------------------------------
|    DATA    |         AUTOR          |                      OBJETIVO                                 |
-------------------------------------------------------------------------------------------------------
| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                               |
-------------------------------------------------------------------------------------------------------
*/
static function breakObs(cObs, nTamMaxLin, oPrn, oFont)

local cObserv, cObsAux
local x, n
local aObs := {}

cObserv := ""
for x := 1 to mlCount(cObs) 
   cObserv += allTrim(memoLine(cObs,, x)) + " "
next x
						
if oPrn:getTextWidth(cObserv, oFont) > nTamMaxLin
   n := 0
   cObsAux := ""
                      
   while n <= len(cObserv)
			             
      if oPrn:getTextWidth(cObsAux + subStr(cObserv, ++n, 1), oFont) <= nTamMaxLin 
         cObsAux += subStr(cObserv, n, 1)
                            
      else
         aAdd(aObs, cObsAux)
         --n
         cObsAux := ""
         
      endif
      
   end
               
   cObserv := cObsAux
               
endif          
			
if ! empty(cObserv)
   aAdd(aObs, cObserv)
endif 

return(aObs)
