#Include 'rwmake.ch'
#Include 'protheus.ch'
#Include 'totvs.ch'
#Include 'topconn.ch'

/*/{Protheus.doc} novo

@author			 Leonardo Pereira
@since			 14/08/2014
@version		 1.0
@description Relatorio de CURVA ABC

/*/
User Function PNR009()
	
	/*/--< variaveis >--/*/
	Private aBox
	Private cLogo := IIf((AllTrim(SM0->M0_CODFIL) == '0101'), 'LogoPNovo.png', 'LogoTCR.png')
	Private aCab := {}
	Private lEnd := .F.
	Private nLin := 10000
	
	Private oFontaN := TFont():New('Verdana',, 10,, .T.,,,,, .F., .F.)
	Private oFontbN := TFont():New('Verdana',, 06,, .T.,,,,, .F., .F.)
	Private oFontc := TFont():New('Verdana',, 16,, .F.,,,,, .F., .F.)
	Private oFontcN := TFont():New('Verdana',, 16,, .T.,,,,, .F., .F.)
	Private oFonte := TFont():New('Verdana',, 09,, .F.,,,,, .F., .F.)
	Private oFonteN := TFont():New('Verdana',, 09,, .T.,,,,, .F., .F.)
	Private oFontfN := TFont():New('Verdana',, 23,, .T.,,,,, .F., .F.)
	Private oFontg := TFont():New('Verdana',, 08,, .F.,,,,, .F., .F.)
	Private oFontgN := TFont():New('Verdana',, 08,, .T.,,,,, .F., .F.)
	Private oBrush1 := TBrush():New(, RGB(235, 235, 235))
	Private oBrush2 := TBrush():New(, RGB(250, 250, 250))
	Private oBrush3 := TBrush():New(, RGB(248, 202, 139))
	
	Private aDadExc1 := {}
	Private aDadExc2 := {}
	
	Private oPrn := TmsPrinter():New('CURVA ABC')
	Private nMaxH := 0
	Private nMaxV := 0
	
	Private aDimObj1
	Private aDimObj2
	Private aDimObj3
	Private aDimObj4
	Private aDimObj5
	Private aDimObj6
	Private aDimObj7
	
	Private cPerg := 'PTNR009'

	PutSx1(cPerg, "01", "Filial De?"      , "", "", "mv_ch1", "C", TamSX3("CR_FILIAL")[1], 0, 0, "G", "", "XM0", "", "", "MV_PAR01")
	PutSx1(cPerg, "02", "Filial Atï¿½?"     , "", "", "mv_ch2", "C", TamSX3("CR_FILIAL")[1], 0, 0, "G", "", "XM0", "", "", "MV_PAR02")
	PutSx1(cPerg, "03", "Data De?"        , "", "", "mv_ch3", "D", 08                    , 0, 0, "G", "", "   ", "", "", "MV_PAR03")
	PutSx1(cPerg, "04", "Data Ate?"       , "", "", "mv_ch4", "D", 08                    , 0, 0, "G", "", "   ", "", "", "MV_PAR04")
	PutSx1(cPerg, "05", "Grupo De?"       , "", "", "mv_ch5", "C", TamSX3("B1_GRUPO")[1] , 0, 0, "G", "", "SBM", "", "", "MV_PAR05")
	PutSx1(cPerg, "06", "Grupo Ate?"      , "", "", "mv_ch6", "C", TamSX3("B1_GRUPO")[1] , 0, 0, "G", "", "SBM", "", "", "MV_PAR06")
	PutSx1(cPerg, "07", "Quebra C. Custo?", "", "", "mv_ch7", "N", 01                    , 0, 0, "C", "", "   ", "", "", "MV_PAR07", "Sim", "Sim", "Sim", "", "Nao", "Nao", "Nao")
	PutSx1(cPerg, "08", "C. Custo De?"    , "", "", "mv_ch8", "C", TamSX3("CTT_CUSTO")[1], 0, 0, "G", "", "CTT", "", "", "MV_PAR08")
	PutSx1(cPerg, "09", "C. Custo Ate?"   , "", "", "mv_ch9", "C", TamSX3("CTT_CUSTO")[1], 0, 0, "G", "", "CTT", "", "", "MV_PAR09")
	//Incluido por Rafael Sacramento (Criare Consulting) em 27/10/2015 - O parâmetro abaixo foi incluído para as exceções de CC.
	PutSx1(cPerg, "17", "Exceto C.Custo De?", "", "", "mv_chh", "C", TamSX3("CTT_CUSTO")[1], 0, 0, "G", "", "CTT", "", "", "MV_PAR17")
	PutSx1(cPerg, "18", "Exceto C.Custo Ate?","", "", "mv_chi", "C", TamSX3("CTT_CUSTO")[1], 0, 0, "G", "", "CTT", "", "", "MV_PAR18")
	PutSx1(cPerg, "10", "% Curva A?"      , "", "", "mv_cha", "N", 03                    , 0, 0, "G", "", "   ", "", "", "MV_PAR10")
	PutSx1(cPerg, "11", "% Curva B?"      , "", "", "mv_chb", "N", 03                    , 0, 0, "G", "", "   ", "", "", "MV_PAR11")
	PutSx1(cPerg, "12", "% Curva C?"    , "", "", "mv_chc", "N", 03                    , 0, 0, "G", "", "   ", "", "", "MV_PAR12")
	PutSx1(cPerg, "13", "Curva ABC"       , "", "", "mv_chd", "N", 01                    , 0, 0, "C", "", "   ", "", "", "MV_PAR13", "Quantidade","Quantidade" , "Quantidade", "", "Valor", "Valor", "Valor")
	PutSx1(cPerg, "14", "Relatorio?"      , "", "", "mv_che", "N", 01                    , 0, 0, "C", "", "   ", "", "", "MV_PAR14", "Sintetico" , "Sintetico" , "Sintetico" , "", "Sint. + Analit.", "Sint. + Analit.", "Sint. + Analit.")
	PutSx1(cPerg, "15", "Exibe Classif.?", "", "", "mv_chf", "C", 03                    , 0, 0, "G", "", "   ", "", "", "MV_PAR15")
	PutSx1(cPerg, "16", "Gerar Planilha?" , "", "", "mv_chg", "N", 01                    , 0, 0, "C", "", "   ", "", "", "MV_PAR16", "Sim", "Sim", "Sim", "", "Nao", "Nao", "Nao")
	
	If !(Pergunte(cPerg, .T.))
		Return
	EndIf
	
	If ((mv_par10 + mv_par11 + mv_par12) > 100) .Or. ((mv_par10 + mv_par11 + mv_par12) < 100)
		MsgAlert('A soma dos % informados nas CURVAS A,B e C e DIFERENTE de 100%' + Chr(13) +;
			'Corrija os dados e tente novamente!', 'Atencao !')
		Return
	EndIf
	
	oPrn:SetLandScape()
	oPrn:SetSize(297, 210)
	
	nMaxV := oPrn:nVertRes()
	nMaxH := oPrn:nHorzRes()
	aBox := {{0055, 200, 500, 1300 , 1500, 1600, 1800, 2100, (nMaxH - 55)}}
	
	cTitulo := 'CURVA ABC DE COMPRAS'
	
	aAdd(aCab, cTitulo)
	
	Processa({ |lEnd| PNRBox(@lEnd)}, 'CURVA ABC de COMPRAS', 'Processando dados...', .T.)
	
Return

/*/{Protheus.doc} novo

@author			 Leonardo Pereira
@since			 14/08/2014
@version		 1.0
@description Imprime os boxes do relatorio

/*/
Static Function PNRBox(lEnd)
	
	Local cTipNF := AllTrim(GetMV('MV_XTIPNF'))
	Local cStrTP := ''
	Local cSepStr := ';'
	Local nX  := 0
	Local nY  := 0
	local nArrABC := 0
	local nK 	:= 0
	local nDet  := 0
	local nImp	:= 0
	local nExc2 := 0
	local nExc1 := 0
	
	While !(Empty(cTipNF))
		nPosStr := aT(cSepStr, cTipNF)
		cStrTP += "'" + SubStr(cTipNF,1, (nPosStr - 1)) + "',"
		cTipNF := SubStr(cTipNF, (nPosStr + 1))
	End
	cStrTP := SubStr(cStrTP, 1, (Len(cStrTP) - 1))
	
	If (Select('SD1ABC') > 0)
		SD1ABC->(DbCloseArea())
	EndIf
	cQuery := 'SELECT F1.F1_FILIAL, F1.F1_ESPECIE, D1.D1_CC, '
	cQuery += 'D1.D1_COD, D1.D1_DOC, B1.B1_DESC, D1.D1_ITEM, F1.F1_EMISSAO, D1.D1_QUANT, D1.D1_VUNIT, D1.D1_TOTAL, D1.D1_FORNECE, D1.D1_LOJA, D1.D1_PEDIDO '
	cQuery += 'FROM ' + RetSQLName('SF1') + ' F1, ' + RetSQLName('SD1') + ' D1, ' + RetSQLName('SB1') + ' B1 '
	cQuery += "WHERE F1.F1_FILIAL BETWEEN  '" + mv_par01 + "' AND  '" + mv_par02 + "' "
	cQuery += "AND F1.F1_EMISSAO BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
	cQuery += "AND D1.D1_CC BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "' "
	//Incluido por Rafael Sacramento (Criare Consulting) em 27/10/2015 - O parâmetro abaixo foi incluído para as exceções de CC.
	cQuery += "AND D1.D1_CC NOT BETWEEN '" + mv_par17 + "' AND '" + mv_par18 + "' "
	cQuery += "AND F1.F1_ESPECIE IN(" + cStrTP + ") "
	cQuery += 'AND F1.F1_FILIAL = D1.D1_FILIAL '
	cQuery += 'AND F1.F1_DOC = D1.D1_DOC '
	cQuery += 'AND F1.F1_SERIE = D1.D1_SERIE '
	cQuery += 'AND F1.F1_FORNECE = D1.D1_FORNECE '
	cQuery += 'AND F1.F1_LOJA = D1.D1_LOJA '
	cQuery += 'AND D1.D1_COD = B1.B1_COD '
	cQuery += "AND D1.D1_GRUPO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
	cQuery += "AND B1.D_E_L_E_T_ = ' ' "
	cQuery += "AND D1.D_E_L_E_T_ = ' ' "
	cQuery += "AND F1.D_E_L_E_T_ = ' ' "
	If (mv_par07 == 1)
		cQuery += 'ORDER BY F1.F1_FILIAL, D1.D1_CC, D1.D1_COD '
	ElseIf (mv_par07 == 2)
		cQuery += 'ORDER BY F1.F1_FILIAL, D1.D1_COD '
	EndIf
	TcQuery cQuery Alias 'SD1ABC' New
	
	aDetABC := {}
	aSintABC := {}
	aIndArrCC := {}
	nContCC := 0
	
	SD1ABC->(DbGoTop())
	While !(SD1ABC->(Eof()))
		SC7->(DbSetOrder(1))
		If !(Empty(AllTrim(SD1ABC->D1_PEDIDO)))
			If SC7->(DbSeek(xFilial('SC7') + SD1ABC->D1_PEDIDO))
				If !(Empty(AllTrim(SC7->C7_CONTRA)))
					SD1ABC->(DbSkip())
					Loop
				EndIf
			EndIf
		EndIf
		
		aAdd(aDetABC, {SD1ABC->F1_FILIAL, SD1ABC->D1_CC, SD1ABC->D1_COD, SD1ABC->D1_FORNECE, SD1ABC->D1_LOJA, SD1ABC->D1_DOC, SD1ABC->D1_ITEM, SD1ABC->F1_EMISSAO, SD1ABC->D1_QUANT, SD1ABC->D1_VUNIT, SD1ABC->D1_TOTAL})
		
		If (mv_par07 == 1)
			nPosIndABC := aScan(aIndArrCC, {|x| x[3] + x[1] == SD1ABC->F1_FILIAL + SD1ABC->D1_CC})
			If (nPosIndABC == 0)
				nContCC++
				
				cNomArr := ('aCcABC' + AllTrim(Str(nContCC)))
				&(cNomArr) := {}
				
				aAdd(aIndArrCC, {SD1ABC->D1_CC, cNomArr, SD1ABC->F1_FILIAL})
			EndIf
						
			nPosABC := aScan(&(cNomArr), {|x| x[10] + x[1] + x[2] == SD1ABC->F1_FILIAL + SD1ABC->D1_CC + SD1ABC->D1_COD})
			
			If (nPosABC == 0)
				aAdd(&(cNomArr), {SD1ABC->D1_CC, SD1ABC->D1_COD, SD1ABC->B1_DESC, SD1ABC->D1_QUANT, 0, SD1ABC->D1_TOTAL, 0, '', 0, SD1ABC->F1_FILIAL})
			Else
				&(cNomArr)[nPosABC, 04] += SD1ABC->D1_QUANT
				&(cNomArr)[nPosABC, 06] += SD1ABC->D1_TOTAL
			EndIf
		ElseIf (mv_par07 == 2)
			nPosABC := aScan(aSintABC, {|x| x[9] + x[1] == SD1ABC->F1_FILIAL + SD1ABC->D1_COD})
			
			If (nPosABC == 0)
				aAdd(aSintABC, {SD1ABC->D1_COD, SD1ABC->B1_DESC, SD1ABC->D1_QUANT, 0, SD1ABC->D1_TOTAL, 0, '', 0, SD1ABC->F1_FILIAL})
			Else
				aSintABC[nPosABC, 03] += SD1ABC->D1_QUANT
				aSintABC[nPosABC, 05] += SD1ABC->D1_TOTAL
			EndIf
		EndIf
		SD1ABC->(DbSkip())
	End
	
	/*/ Organiza os dados auxiliares da CURVA ABC /*/
	aSort(aIndArrCC,,, { |x, y| x[1] < y[1] })
	
	If (mv_par07 == 1)
		If (mv_par13 == 1)
			For nX := 1 To Len(aIndArrCC)
				aSort(&(aIndArrCC[nX, 02]),,, { |x, y| x[4] > y[4] })
			Next
		ElseIf (mv_par13 == 2)
			For nX := 1 To Len(aIndArrCC)
				aSort(&(aIndArrCC[nX, 02]),,, { |x, y| x[6] > y[6] })
			Next
		EndIf
				
		For nArrABC := 1 To Len(aIndArrCC)
			nQtdItA := 0
			nQtdItB := 0
			nQtdItC := 0
			
			/*/ Calcula o % de cada classificacao A, B e C /*/
			nQtdItA := If((Round(((Len(&(aIndArrCC[nArrABC, 02])) * mv_par10) / 100), 0) <= 0), 1, Round(((Len(&(aIndArrCC[nArrABC, 02])) * mv_par10) / 100), 0))
			If (nQtdItA < Len(&(aIndArrCC[nArrABC, 02])))
				nQtdItB := Round(((Len(&(aIndArrCC[nArrABC, 02])) * mv_par11) / 100), 0)
			EndIf
			If ((nQtdItA + nQtdItB) < Len(&(aIndArrCC[nArrABC, 02])))
				nQtdItC := Round((Len(&(aIndArrCC[nArrABC, 02])) - (nQtdItA + nQtdItB)), 0)
			EndIf
	
			/*/ Marca cada produto com sua classificacao /*/
			For nX := 1 To 3
				If (nX == 1)
					For nY := 1 To nQtdItA
						&(aIndArrCC[nArrABC, 02])[nY, 08] := 'A'
					Next
				ElseIf (nX == 2)
					For nY := (nQtdItA + 1) To (nQtdItA + nQtdItB)
						&(aIndArrCC[nArrABC, 02])[nY, 08] := 'B'
					Next
				ElseIf (nX == 3)
					For nY := ((nQtdItA + nQtdItB) + 1) To Len(&(aIndArrCC[nArrABC, 02]))
						&(aIndArrCC[nArrABC, 02])[nY, 08] := 'C'
					Next
				EndIf
			Next
	
			/*/ Total no periodo /*/
			nTotGer := 0
			For nX := 1 To Len(&(aIndArrCC[nArrABC, 02]))
				nTotGer += &(aIndArrCC[nArrABC, 02])[nX, IIf((mv_par13 == 1), 04, 06)]
			Next
	
			/*/ Calcula o % de participacao do periodo e preco unitario medio /*/
			For nX := 1 To Len(&(aIndArrCC[nArrABC, 02]))
				&(aIndArrCC[nArrABC, 02])[nX, 09] := Round(((&(aIndArrCC[nArrABC, 02])[nX, IIf((mv_par13 == 1), 04, 06)] / nTotGer) * 100), 2)
				&(aIndArrCC[nArrABC, 02])[nX, 05] := Round((&(aIndArrCC[nArrABC, 02])[nX, 06] / &(aIndArrCC[nArrABC, 02])[nX, 04]), 2)
			Next
	
			/*/ Calcula o % de variacao de precos do periodo /*/
			For nX := 1 To Len(&(aIndArrCC[nArrABC, 02]))
				If (Select('SD1ABC') > 0)
					SD1ABC->(DbCloseArea())
				EndIf
				cQuery := 'SELECT D1_PEDIDO, D1.D1_VUNIT '
				cQuery += 'FROM ' + RetSQLName('SF1') + ' F1, ' + RetSQLName('SD1') + ' D1 '
				cQuery += "WHERE F1.F1_FILIAL BETWEEN  '" + mv_par01 + "' AND  '" + mv_par02 + "' "
				cQuery += "AND F1.F1_EMISSAO BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
				cQuery += "AND D1.D1_CC = '" + AllTrim(&(aIndArrCC[nArrABC, 02])[nX, 01]) + "' "
				cQuery += "AND F1.F1_ESPECIE IN(" + cStrTP + ") "
				cQuery += 'AND F1.F1_FILIAL = D1.D1_FILIAL '
				cQuery += 'AND F1.F1_DOC = D1.D1_DOC '
				cQuery += 'AND F1.F1_SERIE = D1.D1_SERIE '
				cQuery += 'AND F1.F1_FORNECE = D1.D1_FORNECE '
				cQuery += 'AND F1.F1_LOJA = D1.D1_LOJA '
				cQuery += "AND D1.D1_COD = '" + AllTrim(&(aIndArrCC[nArrABC, 02])[nX, 02]) + "' "
				cQuery += "AND D1.D1_GRUPO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
				cQuery += "AND D1.D_E_L_E_T_ = ' ' "
				cQuery += "AND F1.D_E_L_E_T_ = ' ' "
				TcQuery cQuery Alias 'SD1ABC' New
				aVarPRC := {}
				While !(SD1ABC->(Eof()))
					SC7->(DbSetOrder(1))
					If !(Empty(AllTrim(SD1ABC->D1_PEDIDO)))
						If SC7->(DbSeek(xFilial('SC7') + SD1ABC->D1_PEDIDO))
							If !(Empty(AllTrim(SC7->C7_CONTRA)))
								SD1ABC->(DbSkip())
								Loop
							Else
								aAdd(aVarPRC, SD1ABC->D1_VUNIT)
							EndIf
						EndIf
					Else
						aAdd(aVarPRC, SD1ABC->D1_VUNIT)
					EndIf
					SD1ABC->(DbSkip())
				End
				aSort(aVarPRC,,, { |x, y| x < y })
				
				If (Len(aVarPRC) > 0)
					If (aVarPRC[1] > 0) .And. (aVarPRC[Len(aVarPRC)] > 0)
						If (((aVarPRC[Len(aVarPRC)] / aVarPRC[1]) - 1) != 0)
							&(aIndArrCC[nArrABC, 02])[nX, 07] := Round((((aVarPRC[Len(aVarPRC)] / aVarPRC[1]) - 1) * 100), 2)
						EndIf
					EndIf
				EndIf
			Next
		Next
	ElseIf (mv_par07 == 2)
		If (mv_par13 == 1)
			aSort(aSintABC,,, { |x, y| x[3] > y[3] })
		ElseIf (mv_par13 == 2)
			aSort(aSintABC,,, { |x, y| x[5] > y[5] })
		EndIf
		
		/*/ Calcula o % de cada classificacao A, B e C /*/
		nQtdItA := Round(((Len(aSintABC) * mv_par10) / 100), 0)
		nQtdItB := Round(((Len(aSintABC) * mv_par11) / 100), 0)
		nQtdItC := Round((Len(aSintABC) - (nQtdItA + nQtdItB)), 0)
	
		/*/ Marca cada produto com sua classificacao /*/
		For nX := 1 To 3
			If (nX == 1)
				For nY := 1 To nQtdItA
					aSintABC[nY, 07] := 'A'
				Next
			ElseIf (nX == 2)
				For nY := (nQtdItA + 1) To (nQtdItA + nQtdItB)
					aSintABC[nY, 07] := 'B'
				Next
			ElseIf (nX == 3)
				For nY := ((nQtdItA + nQtdItB) + 1) To Len(aSintABC)
					aSintABC[nY, 07] := 'C'
				Next
			EndIf
		Next
	
		/*/ Total no periodo /*/
		nTotGer := 0
		For nX := 1 To Len(aSintABC)
			nTotGer += aSintABC[nX, IIf((mv_par13 == 1), 03, 05)]
		Next
	
		/*/ Calcula o % de participacao do periodo e preco unitario medio /*/
		For nX := 1 To Len(aSintABC)
			aSintABC[nX, 08] := Round(((aSintABC[nX, IIf((mv_par13 == 1), 03, 05)] / nTotGer) * 100), 2)
			aSintABC[nX, 04] := Round((aSintABC[nX, 05] / aSintABC[nX, 03]), 2)
		Next
	
		/*/ Calcula o % de variacao de precos do periodo /*/
		For nX := 1 To Len(aSintABC)
			If (Select('SD1ABC') > 0)
				SD1ABC->(DbCloseArea())
			EndIf
			cQuery := 'SELECT D1.D1_PEDIDO, D1.D1_VUNIT '
			cQuery += 'FROM ' + RetSQLName('SF1') + ' F1, ' + RetSQLName('SD1') + ' D1 '
			cQuery += "WHERE F1.F1_FILIAL BETWEEN  '" + mv_par01 + "' AND  '" + mv_par02 + "' "
			cQuery += "AND F1.F1_EMISSAO BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
			cQuery += "AND D1.D1_CC BETWEEN '" + mv_par08 + "' AND '" + mv_par09 + "' "
			//Incluido por Rafael Sacramento (Criare Consulting) em 27/10/2015 - O parâmetro abaixo foi incluído para as exceções de CC.
			cQuery += "AND D1.D1_CC NOT BETWEEN '" + mv_par17 + "' AND '" + mv_par18 + "' "
			cQuery += "AND F1.F1_ESPECIE IN(" + cStrTP + ") "
			cQuery += 'AND F1.F1_FILIAL = D1.D1_FILIAL '
			cQuery += 'AND F1.F1_DOC = D1.D1_DOC '
			cQuery += 'AND F1.F1_SERIE = D1.D1_SERIE '
			cQuery += 'AND F1.F1_FORNECE = D1.D1_FORNECE '
			cQuery += 'AND F1.F1_LOJA = D1.D1_LOJA '
			cQuery += "AND D1.D1_COD = '" + AllTrim(aSintABC[nX, 01]) + "' "
			cQuery += "AND D1.D1_GRUPO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
			cQuery += "AND D1.D_E_L_E_T_ = ' ' "
			cQuery += "AND F1.D_E_L_E_T_ = ' ' "
			TcQuery cQuery Alias 'SD1ABC' New
			aVarPRC := {}
			While !(SD1ABC->(Eof()))
				SC7->(DbSetOrder(1))
				If !(Empty(AllTrim(SD1ABC->D1_PEDIDO)))
					If SC7->(DbSeek(xFilial('SC7') + SD1ABC->D1_PEDIDO))
						If !(Empty(AllTrim(SC7->C7_CONTRA)))
							SD1ABC->(DbSkip())
							Loop
						Else
							aAdd(aVarPRC, SD1ABC->D1_VUNIT)
						EndIf
					EndIf
				Else
					aAdd(aVarPRC, SD1ABC->D1_VUNIT)
				EndIf
				SD1ABC->(DbSkip())
			End
			aSort(aVarPRC,,, { |x, y| x < y })
			
			If (Len(aVarPRC) > 0)
				If (aVarPRC[1] > 0) .And. (aVarPRC[Len(aVarPRC)] > 0)
					If (((aVarPRC[Len(aVarPRC)] / aVarPRC[1]) - 1) != 0)
						aSintABC[nX, 06] := Round((((aVarPRC[Len(aVarPRC)] / aVarPRC[1]) - 1) * 100), 2)
					EndIf
				EndIf
			EndIf
		Next
	EndIf
		
	/*/ Imprime o relatorio /*/
	If (mv_par07 == 1)
		aSort(aDetABC,,, { |x, y| x[1] + x[2] + x[3] < y[1] + y[2] + y[3]})
		
		For nArrABC := 1 To Len(aIndArrCC)
		
			/*/ Total do CC no periodo /*/
			nTotCC := 0
			For nK := 1 To Len(&(aIndArrCC[nArrABC, 02]))
				nTotCC += &(aIndArrCC[nArrABC, 02])[nK, IIf((mv_par13 == 1), 04, 06)]
			Next
		
			For nImp := 1 To Len(&(aIndArrCC[nArrABC, 02]))
				If (&(aIndArrCC[nArrABC, 02])[nImp, 08] $ AllTrim(mv_par15))
					If (nLin > (nMaxV - ((nMaxV / 100) * 7)))
			
						/*/ Imprime o cabecalho do relatorio /*/
						nLin := PNRCabec()
						
						/*/ Imprime o identificador do C. Custo /*/
						nLin := PNRCabCC()
						
						/*/ Imprime o sub-cabecalho 1 do relatorio /*/
						nLin := PNRCabSint()
					Else
						If (nImp == 1)
							If (nLin > (nMaxV - ((nMaxV / 100) * 7)))
			
								/*/ Imprime o cabecalho do relatorio /*/
								nLin := PNRCabec()
						
								/*/ Imprime o identificador do C. Custo /*/
								nLin := PNRCabCC()
						
								/*/ Imprime o sub-cabecalho 1 do relatorio /*/
								nLin := PNRCabSint()
							Else
								/*/ Imprime o identificador do C. Custo /*/
								nLin := PNRCabCC()
							EndIf
						EndIf
					EndIf
					
					nLin := PNRItSint(1)
										
					If (mv_par14 == 2)
						/*/ Imprime os ITENS do detalhamento ABC /*/
						nPosABC := aScan(aDetABC, {|x| x[2] + x[3] == &(aIndArrCC[nArrABC, 02])[nImp, 01] + &(aIndArrCC[nArrABC, 02])[nImp, 02]})
						lFirst := .T.
						For nDet := nPosABC To Len(aDetABC)
							If (nLin > (nMaxV - ((nMaxV / 100) * 7)))
								/*/ Imprime o cabecalho do relatorio /*/
								nLin := PNRCabec()
						
								/*/ Imprime o identificador do C. Custo /*/
								nLin := PNRCabCC()
								
								/*/ Imprime o sub-cabecalho 1 do relatorio /*/
								nLin := PNRCabSint()
							
								nLin := PNRItSint(1)
							
								/*/ Imprime o sub-cabecalho 2 do relatorio /*/
								nLin := PNRCabDet(1)
							Else
								If lFirst
									/*/ Imprime o sub-cabecalho 2 do relatorio /*/
									nLin := PNRCabDet(2)
									lFirst := .F.
								EndIf
							EndIf
							
							If (&(aIndArrCC[nArrABC, 02])[nImp, 01] + &(aIndArrCC[nArrABC, 02])[nImp, 02] == aDetABC[nDet, 02] + aDetABC[nDet, 03])
								nLin := PNRItDet(1)
							Else
								nLin += 10
								oPrn:Say(nLin, (aDimObj1[1, 1, 1] + 5), Replicate('-', 225), oFonte,, RGB(200, 200, 200),, 0)
								nLin += 40
								Exit
							EndIf
						Next
					EndIf
				EndIf
			Next
		Next
	ElseIf (mv_par07 == 2)
		aSort(aDetABC,,, { |x, y| x[1] + x[3] < y[1] + y[3] })
		
		For nImp := 1 To Len(aSintABC)
			If (aSintABC[nImp, 07] $ AllTrim(mv_par15))
				If (nLin > (nMaxV - ((nMaxV / 100) * 7)))
					/*/ Imprime o cabecalho do relatorio /*/
					nLin := PNRCabec()
			
					/*/ Imprime o sub-cabecalho 1 do relatorio /*/
					nLin := PNRCabSint()
				EndIf
				
				nLin := PNRItSint(2)
								
				If (mv_par14 == 2)
					/*/ Imprime os ITENS do detalhamento ABC /*/
					nPosABC := aScan(aDetABC, {|x| x[3] == aSintABC[nImp, 01]})
					lFirst := .T.
					For nDet := nPosABC To Len(aDetABC)
						If (nLin > (nMaxV - ((nMaxV / 100) * 7)))
							/*/ Imprime o cabecalho do relatorio /*/
							nLin := PNRCabec()
						
							/*/ Imprime o sub-cabecalho 1 do relatorio /*/
							nLin := PNRCabSint()
							
							/*/ Imprime o sub-cabecalho 2 do relatorio /*/
							nLin := PNRCabDet(1)
						Else
							If lFirst
								/*/ Imprime o sub-cabecalho 2 do relatorio /*/
								nLin := PNRCabDet(2)
								lFirst := .F.
							EndIf
						EndIf
						
						If (aSintABC[nImp, 01] == aDetABC[nDet, 03])
							nLin := PNRItDet(1)
						Else
							nLin += 10
							oPrn:Say(nLin, (aDimObj1[1, 1, 1] + 5), Replicate('-', 225), oFonte,, RGB(200, 200, 200),, 0)
							nLin += 40
							Exit
						EndIf
					Next
				EndIf
			EndIf
		Next
	EndIf
	
	If (mv_par16 == 1)
		If !(ApOleClient('MSExcel')) /*/ Testa a interacao com o excel /*/
			MsgAlert('Microsoft Excel nao instalado!')
		EndIf
		
		aAdd(aDadExc1, {'PRODUTO', 'DESCRICAO', 'QUANT', 'R$ MEDIO', 'R$ TOTAL', '% VAR. PRECO', 'CLASSE', '% GERAL', 'EMP/FIL', 'C.CUSTO', 'CODIGO', 'FORNECEDOR', 'N.FISCAL/IT', 'EMISSAO', 'QUANT', 'R$ UNIT.', 'R$ TOTAL'})
		
		aSort(aDetABC,,, { |x, y| x[1] + x[3] < y[1] + y[3] })
		
		For nExc1 := 1 To Len(aDadExc2)
			nPosABC := aScan(aDetABC, {|x| x[3] == aDadExc2[nExc1, 01]})
			If (nPosABC > 0)
				For nExc2 := nPosABC To Len(aDetABC)
					If (aDadExc2[nExc1, 01] == aDetABC[nExc2, 03])
						aAdd(aDadExc1, {Chr(160) + aDadExc2[nExc1, 01], aDadExc2[nExc1, 02], aDadExc2[nExc1, 03], aDadExc2[nExc1, 04], aDadExc2[nExc1, 05], aDadExc2[nExc1, 06], aDadExc2[nExc1, 07], aDadExc2[nExc1, 08], aDetABC[nExc2, 01], AllTrim(aDetABC[nExc2, 02]) + '/' + Posicione('CTT', 1, aDetABC[nExc2, 01] + AllTrim(aDetABC[nExc2, 02]), 'CTT_DESC01'), aDetABC[nExc2, 04] + '/' + aDetABC[nExc2, 05], AllTrim(Posicione('SA2', 1, xFilial('SA2') + aDetABC[nExc2, 04] + aDetABC[nExc2, 05], 'A2_NOME')), aDetABC[nExc2, 06] + '/' + aDetABC[nExc2, 07], DtoC(StoD(aDetABC[nExc2, 08])), Transform(aDetABC[nExc2, 09], '@E 999,999,999.99'), Transform(aDetABC[nExc2, 10], '@E 999,999,999.99'), Transform(aDetABC[nExc2, 11], '@E 999,999,999.99')})
					Else
						Exit
					EndIf
				Next
			EndIf
		Next
		DlgToExcel({{'ARRAY', OemToAnsi('Relatorio CURVA ABC de COMPRAS'), {}, aDadExc1}})
	EndIf
	
	oPrn:EndPage()
	oPrn:Preview()
	
Return

/*/{Protheus.doc} novo

@author				Leonardo Pereira
@since				14/08/2014
@version			1.0
@description	Imprime o cabecalho do relatorio

/*/
Static Function PNRCabec()
local nY := 0
local nX := 0
local nK := 0

	If !File(cLogo)
		cLogo := ('lgrl' + AllTrim(SM0->M0_CODIGO) + '.bmp')
		If !File(cLogo)
			cLogo := 'lgrl.bmp'
		EndIf
	EndIf
	
	cLogo := IIf((cLogo == Nil), '', cLogo)
	aCab := IIf((aCab == Nil), {''}, aCab)
	
	oPrn:EndPage()
	oPrn:StartPage()
	
	/*/ Calcula disposicao/dimensoes do box da pagina do relatorio /*/
	aADisp1 := {0000, 0000, nMaxV, nMaxH}
	aObjHor1 := {{98}}
	aObjVer1 := {{98}}
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
	aObjHor2 := {{06, 50, 24, 10, 10}}
	aObjVer2 := {{7, 7, 7, 7, 7, 7}}
	aObjMar2 := {5, 5, 10, 5, 5}
	aDimObj2 := U_LMPCalcObj(1, aADisp2, aObjHor2, aObjVer2, aObjMar2)
	
	/*/ Desenha os boxes do cabecalho /*/
	For nX := 1 To Len(aDimObj2)
		For nY := 1 To Len(aDimObj2[nX])
			oPrn:Box(aDimObj2[nX, nY, 1], aDimObj2[nX, nY, 2], aDimObj2[nX, nY, 3], aDimObj2[nX, nY, 4])		// Box do cabecalho
			If (nY == 1)
				oPrn:SayBitmap((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 5), cLogo, 0189, 0139)													// Impressao do Logotipo.
			ElseIf (nY == 2)
				oPrn:Say((aDimObj2[nX, nY, 1] + 20), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), aCab[Len(aCab)], oFontcN,,,, 2)					// Impressao do Titulo.
				oPrn:Say((aDimObj2[nX, nY, 1] + 100), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), 'PERIODO: [' + DtoC(mv_par03) + ' ate ' + DtoC(mv_par04) + ']', oFontaN,,,, 2)					// Impressao do Titulo.
			ElseIf (nY == 3)
				/*/ Total no periodo /*/
				nTotRel := 0
				For nK := 1 To Len(aDetABC)
					nTotRel += aDetABC[nK, IIf((mv_par13 == 1), 09, 11)]
				Next
				
				oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), IIf((mv_par13 == 1), 'Quantidade Total Geral', 'R$ Total Geral'), oFontbN,,,, 0)									// Pagina
				oPrn:Say((aDimObj2[nX, nY, 1] + 50), (aDimObj2[nX, nY, 4] - 10), Transform(nTotRel, IIf((mv_par13 == 1), '@E 9,999,999,999', '@E 9,999,999,999.99')), oFontfN,, RGB(215, 215, 215),, 1)
			ElseIf (nY == 4)
				oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Data/Hora', oFontbN,,,, 0)									// Data/Hora
				oPrn:Say((aDimObj2[nX, nY, 1] + 50), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), DtoC(dDataBase), oFontaN,, RGB(215, 215, 215),, 2)
				oPrn:Say((aDimObj2[nX, nY, 1] + 100), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), Time(), oFontaN,, RGB(215, 215, 215),, 2)
			ElseIf (nY == 5)
				oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Pagina(s)', oFontbN,,,, 0)									// Pagina
				oPrn:Say((aDimObj2[nX, nY, 1] + 50), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), StrZero(oPrn:nPage, 2), oFontfN,, RGB(215, 215, 215),, 2)
			EndIf
		Next
	Next

Return(aDimObj2[1, 1, 3])

/*/{Protheus.doc} novo

@author				Leonardo Pereira
@since				14/08/2014
@version			1.0
@description	Imprime o sub-cabecalho do relatorio

/*/
Static Function PNRCabSint()
local nY :=0
Local nX :=0

	Local aSubCab1 := {'PRODUTO', 'DESCRICAO', 'QUANT', 'R$ MEDIO', 'R$ TOTAL', '% VAR. PRECO', 'CLASSE', '% GERAL'}
	
	/*/ Calcula disposicao/dimensoes dos boxs do sub-cabecalho do relatorio /*/
	//aADisp3 := {aDimObj2[1, 1, 3], aDimObj1[1, 1, 2], aDimObj1[1, 1, 3], aDimObj1[1, 1, 4]}
	aADisp3 := {nLin, aDimObj1[1, 1, 2], aDimObj1[1, 1, 3], aDimObj1[1, 1, 4]}
	aObjHor3 := {{12.71, 30, 10.71, 9.71, 10.71, 10.71, 7.71, 7.74}}
	aObjVer3 := {{3, 3, 3, 3, 3, 3, 3, 3}}
	aObjMar3 := {5, 5, 10, 5, 5}
	aDimObj3 := U_LMPCalcObj(1, aADisp3, aObjHor3, aObjVer3, aObjMar3)
	
	/*/ Desenha os boxes do cabecalho /*/
	For nX := 1 To Len(aDimObj3)
		oPrn:FillRect({aDimObj3[1, 1, 1], aDimObj3[1, 1, 2], aDimObj3[1, 1, 3], aDimObj3[1, 8, 4]}, oBrush1)
		For nY := 1 To Len(aDimObj3[nX])
			oPrn:Box(aDimObj3[nX, nY, 1], aDimObj3[nX, nY, 2], aDimObj3[nX, nY, 3], aDimObj3[nX, nY, 4])		// Box do sub-cabecalho
			oPrn:Say((aDimObj3[nX, nY, 1] + 15), ((aDimObj3[nX, nY, 2] + aDimObj3[nX, nY, 4]) / 2), aSubCab1[nY], oFontaN,,,, 2)		// Impressao do Titulo da coluna.
		Next
	Next

Return(aDimObj3[1, 1, 3])

/*/{Protheus.doc} novo

@author				Leonardo Pereira
@since				14/08/2014
@version			1.0
@description	Imprime o sub-cabecalho do relatorio

/*/
Static Function PNRCabDet(nOpc)
Local nX := 0
Local nY := 0
	Local aSubCab2 := {'EMP/FIL', 'C.CUSTO', 'CODIGO', 'FORNECEDOR', 'N.FISCAL/IT', 'EMISSAO', 'QUANT', 'R$ UNIT.', 'R$ TOTAL'}
	
	If (nOpc == 1)
		nLin += 5
	ElseIf (nOpc == 2)
		nLin += 15
	EndIf
		
	/*/ Calcula disposicao/dimensoes dos boxs do sub-cabecalho do relatorio /*/
	aADisp4 := {nLin, aDimObj1[1, 1, 2], (nLin + 55), aDimObj1[1, 1, 4]}
	aObjHor4 := {{7, 22.12, 7, 16.24, 11.12, 8.12, 8.12, 10.12, 10.16}}
	aObjVer4 := {{100, 100, 100, 100, 100, 100, 100, 100, 100}}
	aObjMar4 := {5, 5, 10, 5, 5}
	aDimObj4 := U_LMPCalcObj(1, aADisp4, aObjHor4, aObjVer4, aObjMar4)
	
	/*/ Desenha os boxes do cabecalho /*/
	For nX := 1 To Len(aDimObj4)
		oPrn:FillRect({aDimObj4[1, 1, 1], aDimObj4[1, 1, 2], aDimObj4[1, 1, 3], aDimObj4[1, 9, 4]}, oBrush2)
		For nY := 1 To Len(aDimObj4[nX])
			oPrn:Box(aDimObj4[nX, nY, 1], aDimObj4[nX, nY, 2], aDimObj4[nX, nY, 3], aDimObj4[nX, nY, 4])		// Box do sub-cabecalho
			oPrn:Say((aDimObj4[nX, nY, 1] + 6), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), aSubCab2[nY], oFontaN,,,, 2)		// Impressao do Titulo da coluna.
		Next
	Next

Return((aDimObj4[1, 1, 3] + 10))

/*/{Protheus.doc} novo

@author				Leonardo Pereira
@since				14/08/2014
@version			1.0
@description	Imprime o sub-cabecalho do C. Custo do relatorio

/*/
Static Function PNRCabCC()
	
	Local cDesCC := ''
	
	nLin += 5
	
	CTT->(DbSetorder(1))
	If CTT->(DbSeek(aIndArrCC[nArrABC, 03] + &(aIndArrCC[nArrABC, 02])[nImp, 01]))
		cDesCC := AllTrim(CTT->CTT_DESC01)
	EndIf
	
	/*/ Desenha o box do cabecalho /*/
	oPrn:FillRect({nLin, (aDimObj1[1, 1, 2] + 5), (nLin + 55), (aDimObj1[1, 1, 4] - 5)}, oBrush3)
	oPrn:Box(nLin, (aDimObj1[1, 1, 2] + 5), (nLin + 50), (aDimObj1[1, 1, 4] - 5))		// Box do sub-cabecalho
	oPrn:Say((nLin + 6), (aDimObj1[1, 1, 2] + 10), 'CENTRO DE CUSTO: ' + AllTrim(&(aIndArrCC[nArrABC, 02])[nImp, 01]) + ' - ' + cDesCC + Space(5) + IIf((mv_par13 == 1), 'QUANTIDADE TOTAL: ', 'R$ TOTAL: ') + Transform(nTotCC, '@E 9,999,999,999.99'), oFontaN,,,, 0)		// Impressao do Titulo da coluna.
	
	nLin += 60

Return(nLin)


/*/{Protheus.doc} novo

@author				Leonardo Pereira
@since				01/01/2014
@version			1.0
@description	Imprime os itens da classificacao ABC SINTETICO

/*/
Static Function PNRItSint(nOpc)
	Local nY := 0
	local nX := 0
	/*/ Desenha os boxes /*/
	For nX := 1 To Len(aDimObj3)
		oPrn:FillRect({nLin, aDimObj3[1, 1, 2], (nLin + (aDimObj3[1, 1, 3] - aDimObj3[1, 1, 1])), aDimObj3[1, 8, 4]}, oBrush1)
		For nY := 1 To Len(aDimObj3[nX])
			oPrn:Box(nLin, aDimObj3[nX, nY, 2], (nLin + (aDimObj3[nX, nY, 3] - aDimObj3[nX, nY, 1])), aDimObj3[nX, nY, 4])		// Box do sub-cabecalho
		Next
	Next
		
	If (nOpc == 1)
		oPrn:Say(nLin, ((aDimObj3[1, 1, 2] + aDimObj3[1, 1, 4]) / 2), AllTrim(&(aIndArrCC[nArrABC, 02])[nImp, 02]), oFontaN,,,, 2)
		oPrn:Say(nLin, (aDimObj3[1, 2, 2] + 10), AllTrim(&(aIndArrCC[nArrABC, 02])[nImp, 03]), oFontaN,,,, 0)
		oPrn:Say(nLin, (aDimObj3[1, 3, 4] - 10), Transform(&(aIndArrCC[nArrABC, 02])[nImp, 04], '@E 999,999,999.99'), oFontaN,,,, 1)
		oPrn:Say(nLin, (aDimObj3[1, 4, 4] - 10), Transform(&(aIndArrCC[nArrABC, 02])[nImp, 05], '@E 999,999,999.99'), oFontaN,,,, 1)
		oPrn:Say(nLin, (aDimObj3[1, 5, 4] - 10), Transform(&(aIndArrCC[nArrABC, 02])[nImp, 06], '@E 999,999,999.99'), oFontaN,,,, 1)
		oPrn:Say(nLin, ((aDimObj3[1, 6, 2] + aDimObj3[1, 6, 4]) / 2), Transform(&(aIndArrCC[nArrABC, 02])[nImp, 07], '@E 999,999,999.99'), oFontaN,,,, 2)
		oPrn:Say(nLin, ((aDimObj3[1, 7, 2] + aDimObj3[1, 7, 4]) / 2), &(aIndArrCC[nArrABC, 02])[nImp, 08], oFontaN,,,, 2)
		oPrn:Say(nLin, ((aDimObj3[1, 8, 2] + aDimObj3[1, 8, 4]) / 2), Transform(&(aIndArrCC[nArrABC, 02])[nImp, 09], '@E 999.99'), oFontaN,,,, 2)
		aAdd(aDadExc2, {AllTrim(&(aIndArrCC[nArrABC, 02])[nImp, 02]), AllTrim(&(aIndArrCC[nArrABC, 02])[nImp, 03]), Transform(&(aIndArrCC[nArrABC, 02])[nImp, 04], '@E 999,999,999.99'), Transform(&(aIndArrCC[nArrABC, 02])[nImp, 05], '@E 999,999,999.99'), Transform(&(aIndArrCC[nArrABC, 02])[nImp, 06], '@E 999,999,999.99'), Transform(&(aIndArrCC[nArrABC, 02])[nImp, 07], '@E 999,999,999.99'), &(aIndArrCC[nArrABC, 02])[nImp, 08], Transform(&(aIndArrCC[nArrABC, 02])[nImp, 09], '@E 999.99')})
	ElseIf (nOpc == 2)
		oPrn:Say(nLin, ((aDimObj3[1, 1, 2] + aDimObj3[1, 1, 4]) / 2), AllTrim(aSintABC[nImp, 01]), oFontaN,,,, 2)
		oPrn:Say(nLin, (aDimObj3[1, 2, 2] + 10), AllTrim(aSintABC[nImp, 02]), oFontaN,,,, 0)
		oPrn:Say(nLin, (aDimObj3[1, 3, 4] - 10), Transform(aSintABC[nImp, 03], '@E 999,999,999.99'), oFontaN,,,, 1)
		oPrn:Say(nLin, (aDimObj3[1, 4, 4] - 10), Transform(aSintABC[nImp, 04], '@E 999,999,999.99'), oFontaN,,,, 1)
		oPrn:Say(nLin, (aDimObj3[1, 5, 4] - 10), Transform(aSintABC[nImp, 05], '@E 999,999,999.99'), oFontaN,,,, 1)
		oPrn:Say(nLin, ((aDimObj3[1, 6, 2] + aDimObj3[1, 6, 4]) / 2), Transform(aSintABC[nImp, 06], '@E 999,999,999.99'), oFontaN,,,, 2)
		oPrn:Say(nLin, ((aDimObj3[1, 7, 2] + aDimObj3[1, 7, 4]) / 2), aSintABC[nImp, 07], oFontaN,,,, 2)
		oPrn:Say(nLin, ((aDimObj3[1, 8, 2] + aDimObj3[1, 8, 4]) / 2), Transform(aSintABC[nImp, 08], '@E 999.99'), oFontaN,,,, 2)
		aAdd(aDadExc2, {AllTrim(aSintABC[nImp, 01]), AllTrim(aSintABC[nImp, 02]), Transform(aSintABC[nImp, 03], '@E 999,999,999.99'), Transform(aSintABC[nImp, 04], '@E 999,999,999.99'), Transform(aSintABC[nImp, 05], '@E 999,999,999.99'), Transform(aSintABC[nImp, 06], '@E 999,999,999.99'), aSintABC[nImp, 07], Transform(aSintABC[nImp, 08], '@E 999.99')})
	EndIf
	
	nLin += 50
	
Return(nLin)

/*/{Protheus.doc} novo

@author				Leonardo Pereira
@since				01/01/2014
@version			1.0
@description	Imprime os itens da classificacao ABC DETALHADO

/*/
Static Function PNRItDet()

	Local cDesCC := ''
	
	DbSelectArea('SA2')
		
	CTT->(DbSetorder(1))
	If CTT->(DbSeek(aDetABC[nDet, 01] + aDetABC[nDet, 02]))
		cDesCC := SubStr(AllTrim(CTT->CTT_DESC01), 1, 24)
	EndIf
	
	oPrn:Say(nLin, ((aDimObj4[1, 1, 2] + aDimObj4[1, 1, 4]) / 2), AllTrim(aDetABC[nDet, 01]), oFonte,,,, 2)
	oPrn:Say(nLin, (aDimObj4[1, 2, 2] + 10), AllTrim(aDetABC[nDet, 02]) + '/' + cDesCC, oFonte,,,, 0)
	oPrn:Say(nLin, ((aDimObj4[1, 3, 2] + aDimObj4[1, 3, 4]) / 2), aDetABC[nDet, 04] + '/' + aDetABC[nDet, 05], oFonte,,,, 2)
	oPrn:Say(nLin, (aDimObj4[1, 4, 2] + 10), SubStr(AllTrim(Posicione('SA2', 1, xFilial('SA2') + aDetABC[nDet, 04] + aDetABC[nDet, 05], 'A2_NOME')), 1, 22), oFonte,,,, 0)
	oPrn:Say(nLin, ((aDimObj4[1, 5, 2] + aDimObj4[1, 5, 4]) / 2), aDetABC[nDet, 06] + '/' + aDetABC[nDet, 07], oFonte,,,, 2)
	oPrn:Say(nLin, ((aDimObj4[1, 6, 2] + aDimObj4[1, 6, 4]) / 2), DtoC(StoD(aDetABC[nDet, 08])), oFonte,,,, 2)
	oPrn:Say(nLin, (aDimObj4[1, 7, 4] - 10), Transform(aDetABC[nDet, 09], '@E 999,999,999.99'), oFonte,,,, 1)
	oPrn:Say(nLin, (aDimObj4[1, 8, 4] - 10), Transform(aDetABC[nDet, 10], '@E 999,999,999.99'), oFonte,,,, 1)
	oPrn:Say(nLin, (aDimObj4[1, 9, 4] - 10), Transform(aDetABC[nDet, 11], '@E 999,999,999.99'), oFonte,,,, 1)
	
	nLin += 50
	
Return(nLin)
