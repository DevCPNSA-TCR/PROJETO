#Include 'rwmake.ch'
#Include 'protheus.ch'
#Include 'totvs.ch'
#Include 'topconn.ch'

/*
Relatorio de gestao de compras.                                               
*/

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄO E?
//?LTERAÇÃO - 11/03/15                                                 ?
//?TTALO P MARTINS - AJUSTE NO TRATAMENTO DO ?TIMO DIA DA APROVAÇÃO E ?
//?NCLUS? DE COLUNA NO EXCEL INFORMANDO SE H?MAPA DE COTAÇÃO         ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄO E?
ENDDOC*/

User Function PNRGesCom()

	Private aAreaSM0 := SM0->(GetArea())
	Private cPerg := 'PNRGC'
	Private lEnd := .F.
	Private nLin := 10000
	Private nPerPag := 5
	Private oFonta := TFont():New('Verdana',, 08,, .F.,,,,, .F., .F.)
	Private oFontaN := TFont():New('Verdana',, 08,, .T.,,,,, .F., .F.)
	Private oFontb := TFont():New('Verdana',, 10,, .F.,,,,, .F., .F.)
	Private oFontbN := TFont():New('Verdana',, 10,, .T.,,,,, .F., .F.)
	Private oFontc := TFont():New('Verdana',, 12,, .F.,,,,, .F., .F.)
	Private oFontcN := TFont():New('Verdana',, 20,, .T.,,,,, .F., .F.)
	Private oBrush := TBrush():New(, RGB(235, 235, 235))
	Private oPrn := TmsPrinter():New('GESTAO DE COMPRAS')
	Private aDadosCOM := {}
	
	Private nMaxV := 0
	Private nMaxH := 0
	
	Private aDimObj1
	Private aDimObj2
	Private aDimObj3
	Private aDimObj4
	
	Private aInd1 := {}
	Private aInd2 := {}
	Private aInd3 := {}
	Private aInd4 := {}
	Private aInd5 := {}
	Private aInd6 := {}
	Private aInd7 := {}
	
	If !Pergunte(cPerg, .T.)
		Return
	EndIf

	oPrn:SetPortrait()
	oPrn:SetSize(210, 297)
	
	nMaxV := oPrn:nVertRes()
	nMaxH := oPrn:nHorzRes()

	/*/ Abre as areas de trabalho que serao utilizadas /*/
	DbSelectArea('SA2')
	DbSelectArea('SC1')
	DbSelectArea('SC7')
	DbSelectArea('SC8')
	DbSelectArea('SCR')
	DbSelectArea('SD1')
	DbSelectArea('CTT')

	Processa({ |lEnd| PNRImpDad(@lEnd)}, 'GESTAO DE COMPRAS',, .T.)
	
	RestArea(aAreaSM0)

Return

/*
 Realiza a impressao dos dados do relatorio.    
*/
Static Function PNRImpDad(lEnd)
	
	Local cStrPED := ''
	Local cDescCTT := ''
	Local nO   := 0
	Local nImp :=0

	Private aFilPED := {}
	Private aMovCOM := {}
	Private aPMC := {}
	Private aPMA := {}
	Private aTotGrp := {}
	Private aTotFil := {}
	
	/*/ Busca os pedidos que serao impressos /*/
	Processa({ |lEnd| PNConPed(@lEnd) }, 'GESTAO DE COMPRAS',, .T.)

	/*/ Gera a planilha EXCEL /*/
	Processa({ |lEnd| PNGerExcel(@lEnd) }, 'GESTAO DE COMPRAS',, .T.)
	
	/*/ Organiza o array por centro de custo /*/
	aSort(aDadosCOM,,, { |x,y| x[6] < y[6] })
	
	If (Len(aDadosCOM) > 0)
		If (mv_par09 == 1)
			aVlrCCMes := {}
			aQtdCCMes := {}
			aQItCCMes := {}
			
			/*/ Totaliza os pedidos de compra no mes por Centro de Custo /*/
			ProcRegua(Len(aDadosCOM))
			For nO := 1 To Len(aDadosCOM)
				IncProc('Totalizando dados...')
				
				/*/ Quantidade de Pedidos do Comprador/Centro de Custo /*/
				If ((nPos := aScan(aQtdCCMes, { |x| AllTrim(x[1]) + AllTrim(x[2]) + AllTrim(x[3]) == AllTrim(aDadosCOM[nO, 01]) + AllTrim(aDadosCOM[nO, 05]) + AllTrim(aDadosCOM[nO, 06]) })) == 0)
					aAdd(aQtdCCMes, {AllTrim(aDadosCOM[nO, 01]), AllTrim(aDadosCOM[nO, 05]), AllTrim(aDadosCOM[nO, 06]), 1, Val(StrTran(StrTran(aDadosCOM[nO, 21], '.', ''), ',', '.')) })
				Else
					aQtdCCMes[nPos, 04] += 1
					aQtdCCMes[nPos, 05] += Val(StrTran(StrTran(aDadosCOM[nO, 21], '.', ''), ',', '.'))
				EndIf
				
				/*/ Valor Total do Comprador/Centro de Custo /*/
				If ((nPos := aScan(aVlrCCMes, { |x| AllTrim(x[1]) + AllTrim(x[2]) + AllTrim(x[3]) == AllTrim(aDadosCOM[nO, 01]) + AllTrim(aDadosCOM[nO, 05]) + AllTrim(aDadosCOM[nO, 06]) })) == 0)
					aAdd(aVlrCCMes, {AllTrim(aDadosCOM[nO, 01]), AllTrim(aDadosCOM[nO, 05]), AllTrim(aDadosCOM[nO, 06]), (Val(StrTran(StrTran(aDadosCOM[nO, 07], '.', ''), ',', '.')) * Val(StrTran(StrTran(aDadosCOM[nO, 21], '.', ''), ',', '.'))), Val(StrTran(StrTran(aDadosCOM[nO, 07], '.', ''), ',', '.')) })
				Else
					aVlrCCMes[nPos, 04] += (Val(StrTran(StrTran(aDadosCOM[nO, 07], '.', ''), ',', '.')) * Val(StrTran(StrTran(aDadosCOM[nO, 21], '.', ''), ',', '.')))
					aVlrCCMes[nPos, 05] += Val(StrTran(StrTran(aDadosCOM[nO, 07], '.', ''), ',', '.'))
				EndIf
								
				/*/ Quantidade de Itens do Comprador/*/
				If ((nPos := aScan(aQItCCMes, { |x| AllTrim(x[1]) + AllTrim(x[2]) + AllTrim(x[3]) == AllTrim(aDadosCOM[nO, 01]) + AllTrim(aDadosCOM[nO, 05]) + AllTrim(aDadosCOM[nO, 06]) })) == 0)
					aAdd(aQItCCMes, {AllTrim(aDadosCOM[nO, 01]), AllTrim(aDadosCOM[nO, 05]), AllTrim(aDadosCOM[nO, 06]), Val(StrTran(StrTran(aDadosCOM[nO, 10], '.', ''), ',', '.')) })
				Else
					aQItCCMes[nPos, 04] += Val(StrTran(StrTran(aDadosCOM[nO, 10], '.', ''), ',', '.'))
				EndIf
			Next
			
			ProcRegua(Len(aDadosCOM))
			For nImp := 1 To Len(aDadosCOM)
				IncProc('Agrupando dados...')
				
				If (aScan(aPMC, { |x| AllTrim(x[1]) + AllTrim(x[2]) + AllTrim(x[3]) == AllTrim(aDadosCOM[nImp, 01]) + AllTrim(aDadosCOM[nImp, 05]) + AllTrim(aDadosCOM[nImp, 06]) }) == 0)
					aAdd(aPMC, {aDadosCOM[nImp, 01], aDadosCOM[nImp, 05], aDadosCOM[nImp, 06], 0, 0, 0, 0})
				EndIf
			Next
			
			/*/ Organiza o array por filial + comprador /*/
			aSort(aPMC,,, { |x,y| x[1] + x[2] + x[3] < y[1] + y[2] + y[3] })
			
			ProcRegua(Len(aPMC))
			For nImp := 1 To Len(aPMC)
				IncProc('Agrupando dados...')
								
				/*/ PMC 1 /*/
				nPos1 := aScan(aQtdCCMes, { |x| AllTrim(x[1]) + AllTrim(x[2]) + AllTrim(x[3]) == AllTrim(aPMC[nImp, 01]) + AllTrim(aPMC[nImp, 02]) + AllTrim(aPMC[nImp, 03]) })
				aPMC[nImp, 04] := (aQtdCCMes[nPos1, 05] / aQtdCCMes[nPos1, 04])
				
				/*/ PMC 2 /*/
				nPos2 := aScan(aVlrCCMes, { |x| AllTrim(x[1]) + AllTrim(x[2]) + AllTrim(x[3]) == AllTrim(aPMC[nImp, 01]) + AllTrim(aPMC[nImp, 02]) + AllTrim(aPMC[nImp, 03]) })
				aPMC[nImp, 05] := (aVlrCCMes[nPos2, 04] / aVlrCCMes[nPos2, 05])
				
				/*/ PMC 3 /*/
				nPos3 := aScan(aQtdCCMes, { |x| AllTrim(x[1]) + AllTrim(x[2]) + AllTrim(x[3]) == AllTrim(aPMC[nImp, 01]) + AllTrim(aPMC[nImp, 02]) + AllTrim(aPMC[nImp, 03]) })
				aPMC[nImp, 06] := (aQtdCCMes[nPos3, 04] / mv_par10)
				
				/*/ PMC 4 /*/
				nPos4 := aScan(aQItCCMes, { |x| AllTrim(x[1]) + AllTrim(x[2]) + AllTrim(x[3]) == AllTrim(aPMC[nImp, 01]) + AllTrim(aPMC[nImp, 02]) + AllTrim(aPMC[nImp, 03]) })
				aPMC[nImp, 07] := (aQItCCMes[nPos4, 04] / mv_par10)
			Next
			
			cFilIni := aPMC[1, 01]
			cGrpIni := aPMC[1, 02]
			
			nTotGRP1 := 0
			nTotGRP2 := 0
			nTotGRP3 := 0
			nTotGRP4 := 0
			nMedGrp := 0
			
			nTotFIL1 := 0
			nTotFIL2 := 0
			nTotFIL3 := 0
			nTotFIL4 := 0
			nMedFil := 0
			
			ProcRegua(Len(aPMC))
			For nImp := 1 To Len(aPMC)
				If Interrupcao(@lEnd)
					Exit
				EndIf
	
				IncProc('Imprimindo dados...')
	
				/*/	Verifica se Ã© necessario criar nova pagina /*/
				If (nLin >= (nMaxV - ((nMaxV * nPerPag) / 100)))
					RestArea(aAreaSM0)
					nLin := PNRCabec(1)
				EndIf
	
				nLin := PNRItens(1)
								
				/*/ Verifica se o grupo de compras modificou /*/
				If ((nImp + 1) <= Len(aPMC))
					If (cFilIni != aPMC[(nImp + 1), 01])
						nLin := PNRSubCab(cGrpIni, 1)
						nLin := PNRSubCab(cFilIni, 2)
						
						cFilIni := aPMC[(nImp + 1), 01]
						cGrpIni := aPMC[(nImp + 1), 02]
						
						nTotGRP1 := 0
						nTotGRP2 := 0
						nTotGRP3 := 0
						nTotGRP4 := 0
						nMedGrp := 0
						
						nTotFIL1 := 0
						nTotFIL2 := 0
						nTotFIL3 := 0
						nTotFIL4 := 0
						nMedFil := 0
					Else
						If (cGrpIni != aPMC[(nImp + 1), 02])
							nLin := PNRSubCab(cGrpIni, 1)
							cGrpIni := aPMC[(nImp + 1), 02]
						
							nTotGRP1 := 0
							nTotGRP2 := 0
							nTotGRP3 := 0
							nTotGRP4 := 0
							nMedGrp := 0
						EndIf
					EndIf
				EndIf
			Next
			nLin := PNRSubCab(cGrpIni, 1)
			nLin := PNRSubCab(cFilIni, 2)
		ElseIf (mv_par09 == 2)
			aVlrCCMes := {}
			aQtdCCMes := {}
			aQItCCMes := {}
			
			nVlrMes := 0
			
			/*/ Totaliza os pedidos de compra no mes por Centro de Custo /*/
			ProcRegua(Len(aDadosCOM))
			For nO := 1 To Len(aDadosCOM)
				IncProc('Totalizando dados...')
				
				/*/ Valor Total Geral das NFÂ´s do Mes /*/
				nVlrMes += Val(StrTran(StrTran(aDadosCOM[nO, 29], '.', ''), ',', '.'))
				
				/*/ Valor Total do Comprador/Centro de Custo /*/
				If ((nPos := aScan(aVlrCCMes, { |x| AllTrim(x[1]) + AllTrim(x[2]) + AllTrim(x[3]) == AllTrim(aDadosCOM[nO, 01]) + AllTrim(aDadosCOM[nO, 05]) + AllTrim(aDadosCOM[nO, 06]) })) == 0)
					aAdd(aVlrCCMes, {AllTrim(aDadosCOM[nO, 01]), AllTrim(aDadosCOM[nO, 05]), AllTrim(aDadosCOM[nO, 06]), (Val(StrTran(StrTran(aDadosCOM[nO, 23], '.', ''), ',', '.')) * Val(StrTran(StrTran(aDadosCOM[nO, 29], '.', ''), ',', '.'))), Val(StrTran(StrTran(aDadosCOM[nO, 29], '.', ''), ',', '.')) })
				Else
					aVlrCCMes[nPos, 04] += (Val(StrTran(StrTran(aDadosCOM[nO, 23], '.', ''), ',', '.')) * Val(StrTran(StrTran(aDadosCOM[nO, 29], '.', ''), ',', '.')))
					aVlrCCMes[nPos, 05] += Val(StrTran(StrTran(aDadosCOM[nO, 29], '.', ''), ',', '.'))
				EndIf
				
				/*/ Quantidade de Pedidos do Comprador/Centro de Custo e Prazo de Atendimento /*/
				If ((nPos := aScan(aQtdCCMes, { |x| AllTrim(x[1]) + AllTrim(x[2]) + AllTrim(x[3]) == AllTrim(aDadosCOM[nO, 01]) + AllTrim(aDadosCOM[nO, 05]) + AllTrim(aDadosCOM[nO, 06]) })) == 0)
					aAdd(aQtdCCMes, {AllTrim(aDadosCOM[nO, 01]), AllTrim(aDadosCOM[nO, 05]), AllTrim(aDadosCOM[nO, 06]), 1, Val(StrTran(StrTran(aDadosCOM[nO, 23], '.', ''), ',', '.')) })
				Else
					aQtdCCMes[nPos, 04] += 1
					aQtdCCMes[nPos, 05] += Val(StrTran(StrTran(aDadosCOM[nO, 23], '.', ''), ',', '.'))
				EndIf
				
				/*/ Quantidade de Itens do Comprador /*/
				If ((nPos := aScan(aQItCCMes, { |x| AllTrim(x[1]) + AllTrim(x[2]) + AllTrim(x[3]) == AllTrim(aDadosCOM[nO, 01]) + AllTrim(aDadosCOM[nO, 05]) + AllTrim(aDadosCOM[nO, 06]) })) == 0)
					aAdd(aQItCCMes, {AllTrim(aDadosCOM[nO, 01]), AllTrim(aDadosCOM[nO, 05]), AllTrim(aDadosCOM[nO, 06]), Val(StrTran(StrTran(aDadosCOM[nO, 10], '.', ''), ',', '.')), Val(StrTran(StrTran(aDadosCOM[nO, 28], '.', ''), ',', '.')) })
				Else
					aQItCCMes[nPos, 04] += Val(StrTran(StrTran(aDadosCOM[nO, 10], '.', ''), ',', '.'))
					aQItCCMes[nPos, 05] += Val(StrTran(StrTran(aDadosCOM[nO, 28], '.', ''), ',', '.'))
				EndIf
			Next
			
			ProcRegua(Len(aDadosCOM))
			For nImp := 1 To Len(aDadosCOM)
				IncProc('Agrupando dados...')
				
				If (aScan(aPMA, { |x| AllTrim(x[1]) + AllTrim(x[2]) + AllTrim(x[3]) == AllTrim(aDadosCOM[nImp, 01]) + AllTrim(aDadosCOM[nImp, 05]) + AllTrim(aDadosCOM[nImp, 06]) }) == 0)
					aAdd(aPMA, {aDadosCOM[nImp, 01], aDadosCOM[nImp, 05], aDadosCOM[nImp, 06], 0, 0, 0, 0})
				EndIf
			Next
			
			/*/ Organiza o array por filial + comprador /*/
			aSort(aPMA,,, { |x,y| x[1] + x[2] + x[3] < y[1] + y[2] + y[3] })
			
			ProcRegua(Len(aPMA))
			For nImp := 1 To Len(aPMA)
				IncProc('Agrupando dados...')
				
				/*/ PMA 1 /*/
				nPos1 := aScan(aQtdCCMes, { |x| AllTrim(x[1]) + AllTrim(x[2]) + AllTrim(x[3]) == AllTrim(aPMA[nImp, 01]) + AllTrim(aPMA[nImp, 02]) + AllTrim(aPMA[nImp, 03]) })
				aPMA[nImp, 04] := (aQtdCCMes[nPos1, 05] / aQtdCCMes[nPos1, 04])
				
				/*/ PMA 2 /*/
				nPos2 := aScan(aVlrCCMes, { |x| AllTrim(x[1]) + AllTrim(x[2]) + AllTrim(x[3]) == AllTrim(aPMA[nImp, 01]) + AllTrim(aPMA[nImp, 02]) + AllTrim(aPMA[nImp, 03]) })
				aPMA[nImp, 05] := (aVlrCCMes[nPos2, 04] / aVlrCCMes[nPos2, 05])
				
				/*/ PMA 3 /*/
				nPos3 := aScan(aQItCCMes, { |x| AllTrim(x[1]) + AllTrim(x[2]) + AllTrim(x[3]) == AllTrim(aPMA[nImp, 01]) + AllTrim(aPMA[nImp, 02]) + AllTrim(aPMA[nImp, 03]) })
				aPMA[nImp, 06] := ((If((aQItCCMes[nPos3, 05] > aQItCCMes[nPos3, 04]), aQItCCMes[nPos3, 04], aQItCCMes[nPos3, 05]) / aQItCCMes[nPos3, 04]) * 100)
			Next
			
			cFilIni := aPMA[1, 01]
			cGrpIni := aPMA[1, 02]
			
			nTotGRP1 := 0
			nTotGRP2 := 0
			nTotGRP3 := 0
			nTotGRP4 := 0
			nMedGrp := 0
			
			nTotFIL1 := 0
			nTotFIL2 := 0
			nTotFIL3 := 0
			nTotFIL4 := 0
			nMedFil := 0
			
			ProcRegua(Len(aPMA))
			For nImp := 1 To Len(aPMA)
				If Interrupcao(@lEnd)
					Exit
				EndIf
	
				IncProc('Imprimindo dados...')
	
				/*/	Verifica se Ã© necessario criar nova pagina /*/
				If (nLin >= (nMaxV - ((nMaxV * nPerPag) / 100)))
					RestArea(aAreaSM0)
					nLin := PNRCabec(2)
				EndIf
	
				nLin := PNRItens(2)
				
				/*/ Verifica se o grupo de compras modificou /*/
				If ((nImp + 1) <= Len(aPMA))
					If (cFilIni != aPMA[(nImp + 1), 1])
						nLin := PNRSubCab(cGrpIni, 3)
						nLin := PNRSubCab(cFilIni, 4)
						
						cFilIni := aPMA[(nImp + 1), 01]
						cGrpIni := aPMA[(nImp + 1), 02]
						
						nTotGRP1 := 0
						nTotGRP2 := 0
						nTotGRP3 := 0
						nTotGRP4 := 0
						nMedGrp := 0
						
						nTotFIL1 := 0
						nTotFIL2 := 0
						nTotFIL3 := 0
						nTotFIL4 := 0
						nMedFil := 0
					Else
						If (cGrpIni != aPMA[(nImp + 1), 02])
							nLin := PNRSubCab(cGrpIni, 3)
							cGrpIni := aPMA[(nImp + 1), 02]
						
							nTotGRP1 := 0
							nTotGRP2 := 0
							nTotGRP3 := 0
							nTotGRP4 := 0
							nMedGrp := 0
						EndIf
					EndIf
				EndIf
			Next
			nLin := PNRSubCab(cGrpIni, 3)
			nLin := PNRSubCab(cFilIni, 4)
		EndIf
	EndIf
	
	If Interrupcao(@lEnd)
		oPrn:Say((nMaxV / 2), (nMaxH / 2), 'PROCESSO CANCELADO PELO USUARIO', oFontaN,,,, 2)
	EndIf

	oPrn:Preview()

Return

/*
Seleciona os pedidos do relatorio.                                               
*/
Static Function PNConPed()
		
	If (mv_par09 == 1)
		/*/ Verifica se a tabela temporaria esta em USO /*/
		If (Select('TMPSCR') > 0)
			TMPSCR->(DbCloseArea())
		EndIf
		cQry := 'SELECT DISTINCT CR_FILIAL, CR_NUM, MAX(CR_DATALIB) CR_ULTAPV, MAX(CR_NIVEL) CR_NIVEL '
		cQry += 'FROM ' + RetSQLName('SCR') + ' SCR1 '
		cQry += "WHERE SCR1.CR_DATALIB BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
		cQry += "AND SCR1.CR_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
		cQry += "AND SCR1.CR_NIVEL = (SELECT MAX(CR_NIVEL) FROM " + RetSQLName('SCR') + " SCR2 WHERE SCR2.CR_NUM = SCR1.CR_NUM AND SCR2.D_E_L_E_T_ = '') "
		cQry += "AND SCR1.CR_TIPO = 'PC' "
		cQry += "AND SCR1.CR_FILIAL+SCR1.CR_NUM IN ( "
		cQry += 'SELECT DISTINCT C7_FILIAL+C7_NUM '
		cQry += 'FROM ' + RetSQLName('SC7') + ' SC7 '
		cQry += " WHERE C7_EMISSAO BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
		cQry += " AND C7_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
		cQry += " AND SC7.D_E_L_E_T_ = '' )"
		cQry += " AND SCR1.D_E_L_E_T_ = '' "
		cQry += 'GROUP BY SCR1.CR_FILIAL, SCR1.CR_NUM '
		cQry += 'ORDER BY SCR1.CR_FILIAL, SCR1.CR_NUM '
		
		TcQuery cQry NEW ALIAS 'TMPSCR'
		TMPSCR->(DbGoTop())
		ProcRegua(TMPSCR->(RecCount()))
		TMPSCR->(DbGoTop())
		While !TMPSCR->(Eof())
			IncProc('Selecionando pedidos...')
			If (aScan(aFilPED, TMPSCR->CR_FILIAL) == 0)
				aAdd(aFilPED, TMPSCR->CR_FILIAL)
			EndIf
			aAdd(aMovCOM, {TMPSCR->CR_FILIAL, AllTrim(TMPSCR->CR_NUM)})
			TMPSCR->(DbSkip())
		End
	ElseIf (mv_par09 == 2)
		/*/ Verifica se a tabela temporaria esta em USO /*/
		If (Select('TMPSD1') > 0)
			TMPSD1->(DbCloseArea())
		EndIf
		cQry := 'SELECT D1_FILIAL, D1_PEDIDO '
		cQry += 'FROM ' + RetSQLName('SD1') + ' '
		cQry += "WHERE D1_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
		cQry += "AND D1_DTDIGIT BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
		cQry += "AND D1_PEDIDO <> '' "
		cQry += "AND D_E_L_E_T_ = '' "
		cQry += 'GROUP BY D1_FILIAL, D1_PEDIDO '
		cQry += 'ORDER BY D1_FILIAL, D1_PEDIDO '
		TcQuery cQry NEW ALIAS 'TMPSD1'
		TMPSD1->(DbGoTop())
		ProcRegua(TMPSD1->(RecCount()))
		TMPSD1->(DbGoTop())
		While !TMPSD1->(Eof())
			IncProc('Selecionando Pedidos...')
			If (aScan(aFilPED, TMPSD1->D1_FILIAL) == 0)
				aAdd(aFilPED, TMPSD1->D1_FILIAL)
			EndIf
			aAdd(aMovCOM, {TMPSD1->D1_FILIAL, AllTrim(TMPSD1->D1_PEDIDO)})
			TMPSD1->(DbSkip())
		End
	EndIf

Return

/*
Gera a planilha excel com os pedidos de compra selecionados.                     
*/
Static Function PNGerExcel()

local lResiduo := .F.
Local nFil := 0
Local nPED := 0
Local nTxt := 0
Local nImp := 0

	For nPED := 1 To Len(aFilPED)
		aAreaSM0 := SM0->(GetArea())
		SM0->(DbSetOrder(1))
		SM0->(DbSeek(cEmpAnt + aFilPED[nPED]))
		cFilBkp := cFilAnt
		cFilAnt := aFilPED[nPED]
		cStrPED := ''
		For nFil := 1 To Len(aMovCOM)
			If (aMovCOM[nFil, 1] == aFilPED[nPED])
				cStrPED += "'" + aMovCOM[nFil, 2] + "',"
			EndIf
		Next
		cStrPED := SubStr(cStrPED, 1, (Len(cStrPED) - 1))
		
		If (Select('TMPSC7') > 0)
			TMPSC7->(DbCloseArea())
		EndIf
		
		lResiduo := .F.
		
		cQry := 'SELECT C7_FILIAL, C7_NUM, C7_CC, C7_EMISSAO, C7_FORNECE, C7_LOJA, C7_NUMCOT, C7_CONAPRO, C7_XDATALI, C7_RESIDUO, C7_USER AS C7_GRUPCOM '
		cQry += 'FROM ' + RetSQLName('SC7') + ' SC7 '
		cQry += "WHERE SC7.C7_FILIAL = '" + aFilPED[nPED] + "' "
		cQry += "AND SC7.C7_NUM IN(" + cStrPED + ") "
		cQry += "AND SC7.C7_CC BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
		// Retirado por Rafael Sacramento - Criare consulting em 10/06/2016 - com a finalidade de filtrar pelo usuário do mapa de cotações.
		//cQry += "AND SC7.C7_USER BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' " 
		cQry += " AND SC7.C7_NUMCOT <> '' "
		cQry += "AND SC7.D_E_L_E_T_ = '' "
		cQry += 'GROUP BY C7_FILIAL, C7_NUM, C7_CC, C7_EMISSAO, C7_FORNECE, C7_LOJA, C7_NUMCOT, C7_CONAPRO, C7_XDATALI, C7_RESIDUO, C7_USER '
		cQry += 'ORDER BY C7_FILIAL, C7_USER, C7_CC '
		TcQuery cQry NEW ALIAS 'TMPSC7'
		TMPSC7->(DbGoTop())
		ProcRegua(TMPSC7->(RecCount()))
		TMPSC7->(DbGoTop())
		While !TMPSC7->(Eof())
			IncProc('Gerando Planilha...')
			If (Select('TMPSC8') > 0)
				TMPSC8->(DbCloseArea())
			EndIf
			
			If TMPSC7->C7_RESIDUO == "S"
				lResiduo := .T.
			Else
				lResiduo := .F.
			EndIf
//			cQry := 'SELECT DISTINCT C8_FILIAL, C8_NUM, C8_EMISSAO, C8_NUMSC "			
			cQry := 'SELECT DISTINCT C8_FILIAL, C8_NUM, C8_EMISSAO, C8_NUMSC '
			cQry += 'FROM ' + RetSQLName('SC8') + ' '
			cQry += "WHERE C8_FILIAL = '" + TMPSC7->C7_FILIAL + "' "
			cQry += "AND C8_NUM = '" + TMPSC7->C7_NUMCOT + "' "
			//Incluído por Rafael Sacramento - Criare Consulting em 10/06/2016 - Com a finalidade de filtrar pelo usuário do mapa de cotação.
			cQry += "AND C8_XUSER BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' "
			//Fim da inclusão
			cQry += "AND D_E_L_E_T_ = ' ' "
			TcQuery cQry NEW ALIAS 'TMPSC8'
			TMPSC8->(DbGoTop())
			If !TMPSC8->(Eof())
				If (Select('TMPSC1') > 0)
					TMPSC1->(DbCloseArea())
				EndIf
				cQry := 'SELECT DISTINCT C1_FILIAL, C1_NUM, C1_EMISSAO '
				cQry += 'FROM ' + RetSQLName('SC1') + ' '
				cQry += "WHERE C1_FILIAL = '" + aFilPED[nPED] + "' "
				cQry += "AND C1_NUM = '" + TMPSC8->C8_NUMSC + "' "
				cQry += "AND D_E_L_E_T_ = ' ' "
				TcQuery cQry NEW ALIAS 'TMPSC1'
				TMPSC1->(DbGoTop())
				If !TMPSC1->(Eof())
					If (Select('TMPSD1') > 0)
						TMPSD1->(DbCloseArea())
					EndIf
					cQry := 'SELECT DISTINCT D1_FILIAL, D1_EMISSAO, D1_DOC, D1_SERIE, D1_DTDIGIT, D1_FORNECE, D1_LOJA '
					cQry += 'FROM ' + RetSQLName('SD1') + ' '
					cQry += "WHERE D1_FILIAL = '" + TMPSC7->C7_FILIAL + "' "
					cQry += "AND D1_PEDIDO = '" + TMPSC7->C7_NUM + "' "
					cQry += "AND D1_FORNECE = '" + TMPSC7->C7_FORNECE + "' "
					cQry += "AND D1_LOJA = '" + TMPSC7->C7_LOJA + "' "
					If (mv_par09 == 2) 		// PMA
						cQry += "AND D1_DTDIGIT BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
					EndIf
					cQry += "AND D_E_L_E_T_ = ' ' "
					TcQuery cQry NEW ALIAS 'TMPSD1'
					TMPSD1->(DbGoTop())
					If !TMPSD1->(Eof())		// PMA
						While !TMPSD1->(Eof())
							cDescCTT := AllTrim(Posicione('CTT', 1, xFilial('CTT') + AllTrim(TMPSC7->C7_CC), 'CTT_DESC01'))
							
							/*/ Alimentar o array /*/
							cDescFil := AllTrim(Posicione('SM0', 1, cEmpAnt + aFilPED[nPED], 'M0_FILIAL'))
							Restarea(aAreaSM0)
							
                     		if TMPSC7->C7_NUM = "006388"
                    		   alert('aqui')
                     		endif
                     		
							nVlrTPed := PNRFun1(TMPSC7->C7_FILIAL, TMPSC7->C7_NUM)
							nQtdItXX := PNRFun2(TMPSC7->C7_FILIAL, TMPSC7->C7_NUM)
							nQtItPed := AllTrim(Transform(nQtdItXX, '@E 999,999,999.99'))
							dVencNF := DtoC(PNRFun3(TMPSD1->D1_FILIAL, TMPSD1->D1_DOC, TMPSD1->D1_SERIE, TMPSD1->D1_FORNECE, TMPSD1->D1_LOJA))
							dUApvPed := IIF(lResiduo, DtoC(StoD(TMPSC7->C7_XDATALI)), DtoC(PNRFun4(TMPSC7->C7_FILIAL, TMPSC7->C7_NUM)))
							nPNRFUN4 := CToD(dUApvPed)
                            
							nPrzCot := Abs(StoD(TMPSC8->C8_EMISSAO) - StoD(TMPSC1->C1_EMISSAO))
							nPrzCot -=  GetFds(StoD(TMPSC1->C1_EMISSAO),StoD(TMPSC8->C8_EMISSAO))
							nPrzCot := AllTrim(Transform(Abs(nPrzcot), '@E 999,999'))

//							aDt := GetDtCot(TMPSC8->C8_FILIAL, TMPSC8->C8_NUM)
							aDt := GetDtCot(TMPSC8->C8_FILIAL, TMPSC8->C8_NUM, dUApvPed) // Felipe do Nascimento - 01/05/2015
							
							aDt[1] := DToC(StoD(TMPSC8->C8_EMISSAO))
							
							nPrzRKCot := Abs(CToD(adt[2]) - CToD(adt[1]))
							nPrzRKCot -= GetFds(CToD(adt[2]), CToD(adt[1]))
							nPrzRKCot := AllTrim(Transform(ABS(nPrzRKCot), '@E 999,999'))

							nPrzAPed := Abs(StoD(TMPSC7->C7_EMISSAO) - CToD(adt[2]) )
							
							nPrzAPed -= GetFds(CToD(adt[2]), StoD(TMPSC7->C7_EMISSAO))
							nPrzAPed := AllTrim(Transform(ABS(nPrzAPed), '@E 999,999'))
							
							IF lResiduo							

								nPAPvPed := Abs(StoD(TMPSC7->C7_XDATALI) - StoD(TMPSC7->C7_EMISSAO))
								nPAPvPed -= GetFds(StoD(TMPSC7->C7_EMISSAO), nPNRFUN4)
								nPAPvPed := AllTrim(Transform(Abs(nPAPvPed), '@E 999,999'))
								
								nPrzCom := Abs(StoD(TMPSC7->C7_XDATALI) - StoD(TMPSC1->C1_EMISSAO))
								nPrzCom -= GetFds(StoD(TMPSC1->C1_EMISSAO),nPNRFUN4)
								nPrzCom := AllTrim(Transform(Abs(nPrzCom), '@E 999,999'))
								
								nPrzEnt := Abs(StoD(TMPSD1->D1_DTDIGIT) - StoD(TMPSC7->C7_XDATALI))
								nPrzEnt -= GetFds(nPNRFUN4, StoD(TMPSD1->D1_DTDIGIT))
								nPrzEnt := AllTrim(Transform(Abs(nPrzEnt), '@E 999,999'))																
							ELSE

								nPAPvPed := Abs(PNRFun4(TMPSC7->C7_FILIAL, TMPSC7->C7_NUM) - StoD(TMPSC7->C7_EMISSAO))
								nPAPvPed -= GetFds(StoD(TMPSC7->C7_EMISSAO),nPNRFUN4)
								nPAPvPed := AllTrim(Transform(Abs(nPAPvPed), '@E 999,999'))
								
								nPrzCom := Abs(PNRFun4(TMPSC7->C7_FILIAL, TMPSC7->C7_NUM) - StoD(TMPSC1->C1_EMISSAO))
								nPrzCom -= GetFds(StoD(TMPSC1->C1_EMISSAO),nPNRFUN4)
								nPrzCom := AllTrim(Transform(Abs(nPrzCom), '@E 999,999'))
								
								nPrzEnt := Abs(StoD(TMPSD1->D1_DTDIGIT) - PNRFun4(TMPSC7->C7_FILIAL, TMPSC7->C7_NUM))
								nPrzEnt -= GetFds(nPNRFUN4,StoD(TMPSD1->D1_DTDIGIT))
								nPrzEnt := AllTrim(Transform(Abs(nPrzEnt), '@E 999,999'))																							
							ENDIF

							
							nPrzAtend := Abs(StoD(TMPSD1->D1_DTDIGIT) - StoD(TMPSC1->C1_EMISSAO))
							nPrzAtend -= GetFds(StoD(TMPSD1->D1_DTDIGIT),StoD(TMPSC1->C1_EMISSAO))
							nPrzAtend := AllTrim(Transform(ABS(nPrzAtend), '@E 999,999'))

							nVlrNF := PNRFun6(TMPSD1->D1_FILIAL, TMPSD1->D1_DOC, TMPSD1->D1_SERIE, TMPSD1->D1_FORNECE, TMPSD1->D1_LOJA, TMPSC7->C7_NUM)
							nQtdItNF := PNRFun7(TMPSD1->D1_FILIAL, TMPSD1->D1_DOC, TMPSD1->D1_SERIE, TMPSD1->D1_FORNECE, TMPSD1->D1_LOJA, TMPSC7->C7_NUM)
							nQtdItSC := PNRFun8(TMPSC1->C1_FILIAL, TMPSC1->C1_NUM)
							
							cxus := Posicione("SC8",1,TMPSC7->C7_FILIAL+TMPSC8->C8_NUM,"C8_XUSER")
							cXUs := GetUserR(cxus,TMPSC7->C7_FILIAL)

							
							aAdd(aDadosCOM, {cDescFil,;												// 01 - Descricao da Filial
							TMPSC1->C1_NUM,;																	// 02 - Numero da Solicitacao de Compra
							DtoC(StoD(TMPSC1->C1_EMISSAO)),;										// 03 - Data de Emissao da Solicitacao de Compra
							TMPSC7->C7_CONAPRO,;															// 04 - Status do Pedido de Compra B = Bloqueado; L = Liberado
							cxus,;															// 05 - Codigo do Grupo de Compras   TMPSC7->C7_GRUPCOM
							cDescCTT,;																			// 06 - Descricao do Centro de Custo
							AllTrim(Transform(nVlrTPed, '@E 999,999,999.99')),;		// 07 - Valor Total do Pedido de Compra
							TMPSC7->C7_NUM,;																	// 08 - Numero do Pedido de Compra
							DtoC(StoD(TMPSC7->C7_EMISSAO)),;										// 09 - Data de Emissao do Pedido de Compra
							nQtItPed,;																			// 10 - Quantidade de Itens do Pedido de Compra
							TMPSD1->D1_DOC + '/' + TMPSD1->D1_SERIE,;						// 11 - Numero e Serie da Nota Fiscal
							DtoC(StoD(TMPSD1->D1_EMISSAO)),;										// 12 - Data de Emissao da Nota Fiscal
							dVencNF,;																				// 13 - Data do 1o Vencimento da Nota Fiscal
							TMPSC7->C7_FORNECE + '/' + TMPSC7->C7_LOJA + '-' + AllTrim(Posicione('SA2', 1, xFilial('SA2') + TMPSC7->C7_FORNECE + TMPSC7->C7_LOJA, 'A2_NOME')),;		// 14 - Dados do Fornecedor
							dUApvPed,;																			// 15 - Data da Ultima Aprovacao do Pedido de Compras
							DtoC(StoD(TMPSD1->D1_DTDIGIT)),;										// 16 - Data de Digitacao da Nota Fiscal
							nPrzCot,;																				// 17 - Prazo Geracao da Cotacao
							nPrzRKCot,;																			// 18 - Prazo do Ranking da Cotacao
							nPrzAPed,;																			// 19 - Prazo de Analise da Cotacao
							nPAPvPed,;																			// 20 - Prazo da Aprovacao do Pedido de Compra
							nPrzCom,;																				// 21 - Prazo de Compra
							nPrzEnt,;																				// 22 - Prazo de Entrega
							nPrzAtend,;																			// 23 - Prazo de Atendimento
							DtoC(StoD(TMPSD1->D1_DTDIGIT)),; 										// 24 - Dt Digitacao Doc entrada
							aDt[1],; 																				// 25 - Dt envio WF da cotaï¿½ï¿½o
							aDt[2],;																				// 26 - Dt ultima aprovacao mapa cotacao
							AllTrim(Transform(nQtdItSC, '@E 999,999,999.99')),;		// 27 - Qtd de Itens da Solicitacao
							AllTrim(Transform(If((nQtdItNF > nQtdItXX), nQtdItXX, nQtdItNF), '@E 999,999,999.99')),;		// 28 - Qtd de Itens da NF
							AllTrim(Transform(nVlrNF, '@E 999,999,999.99')) ,;												// 29 - Valor da Nota Fiscal
							aDt[3] })																						// 30 - Possui mapa de cotação?			
														
							aAdd(aInd1, {AllTrim(TMPSC7->C7_NUM) + AllTrim(TMPSD1->D1_DOC) + AllTrim(TMPSD1->D1_SERIE), (StoD(TMPSC8->C8_EMISSAO) - StoD(TMPSC1->C1_EMISSAO))})
							aAdd(aInd2, {AllTrim(TMPSC7->C7_NUM) + AllTrim(TMPSD1->D1_DOC) + AllTrim(TMPSD1->D1_SERIE), ((StoD(TMPSC8->C8_EMISSAO) - StoD(TMPSC1->C1_EMISSAO)) * nVlrTPed)})
							
							aAdd(aInd3, {(AllTrim(TMPSC7->C7_NUM) + AllTrim(TMPSD1->D1_DOC) + AllTrim(TMPSD1->D1_SERIE)), Val(nPrzAtend)})
							aAdd(aInd4, {(AllTrim(TMPSC7->C7_NUM) + AllTrim(TMPSD1->D1_DOC) + AllTrim(TMPSD1->D1_SERIE)), (Val(nPrzAtend) * nVlrNF)})
							
							/*/ Totaliza o valor das NFs /*/
							If ((nPos := aScan(aInd5, { |x| AllTrim(x[1]) == AllTrim(cDescCTT) })) == 0)
								aAdd(aInd5, {AllTrim(cDescCTT), nVlrNF})
							Else
								aInd5[nPos, 02] += nVlrNF
							EndIf
							
							/*/ Totaliza a quantidade de itens das NFs /*/
							If ((nPos := aScan(aInd6, { |x| AllTrim(x[1]) == AllTrim(cDescCTT) })) == 0)
								aAdd(aInd6, {AllTrim(cDescCTT), nQtdItNF })
							Else
								aInd6[nPos, 02] += nQtdItNF
							EndIf
							
							/*/ Totaliza a quantidade de itens das solicitacoes /*/
							If ((nPos := aScan(aInd7, { |x| AllTrim(x[1]) == AllTrim(cDescCTT) })) == 0)
								aAdd(aInd7, {AllTrim(cDescCTT), nQtdItSC})
							Else
								aInd7[nPos, 02] += nQtdItSC
							EndIf
							
							TMPSD1->(DbSkip())
						End
					Else // PMC
						If (mv_par09 == 1)
							cDescCTT := AllTrim(Posicione('CTT', 1, xFilial('CTT') + AllTrim(TMPSC7->C7_CC), 'CTT_DESC01'))
							
							/*/ Alimentar o array /*/
							cDescFil := AllTrim(Posicione('SM0', 1, cEmpAnt + aFilPED[nPED], 'M0_FILIAL'))
							Restarea(aAreaSM0)
							
							nVlrTPed := PNRFun1(TMPSC7->C7_FILIAL, TMPSC7->C7_NUM)
							nQtItPed := AllTrim(Transform(PNRFun2(TMPSC7->C7_FILIAL, TMPSC7->C7_NUM), '@E 999,999,999.99'))
							dVencNF := ''
							dUApvPed := IIF(lResiduo, DtoC(StoD(TMPSC7->C7_XDATALI)), DtoC(PNRFun4(TMPSC7->C7_FILIAL, TMPSC7->C7_NUM)))
							
							nPNRFUN4 := CToD(dUApvPed)
							
							nPrzCot := Abs(StoD(TMPSC8->C8_EMISSAO) - StoD(TMPSC1->C1_EMISSAO))
							nPrzCot -=  GetFds(StoD(TMPSC1->C1_EMISSAO),StoD(TMPSC8->C8_EMISSAO))
							nPrzCot := AllTrim(Transform(Abs(nPrzcot), '@E 999,999'))
							
//							aDt:=GetDtCot(TMPSC8->C8_FILIAL, TMPSC8->C8_NUM)
							aDt := GetDtCot(TMPSC8->C8_FILIAL, TMPSC8->C8_NUM, dUApvPed) // Felipe do Nascimento - 01/05/2015
							aDt[1]:=DToC(StoD(TMPSC8->C8_EMISSAO))
														
							nPrzRKCot := Abs(CToD(adt[2])-CToD(adt[1]))
							nPrzRKCot -= GetFds(CToD(adt[2]),CToD(adt[1]))
							nPrzRKCot := AllTrim(Transform(ABS(nPrzRKCot), '@E 999,999'))
							
							nPrzAPed := Abs(StoD(TMPSC7->C7_EMISSAO) - CToD(adt[2]) )
							nPrzAPed -= GetFds(CToD(adt[2]),StoD(TMPSC7->C7_EMISSAO))
							nPrzAPed := AllTrim(Transform(ABS(nPrzAPed), '@E 999,999'))
                            
							IF lResiduo

								nPAPvPed := Abs(StoD(TMPSC7->C7_XDATALI) - StoD(TMPSC7->C7_EMISSAO))
								nPAPvPed -= GetFds(StoD(TMPSC7->C7_EMISSAO),nPNRFUN4)
								nPAPvPed := AllTrim(Transform(Abs(nPAPvPed), '@E 999,999'))
								
								nPrzCom := Abs(StoD(TMPSC7->C7_XDATALI) - StoD(TMPSC1->C1_EMISSAO))
								nPrzCom -= GetFds(StoD(TMPSC1->C1_EMISSAO),nPNRFUN4)
								nPrzCom := AllTrim(Transform(Abs(nPrzCom), '@E 999,999'))
							
							ELSE
							
								nPAPvPed := Abs(PNRFun4(TMPSC7->C7_FILIAL, TMPSC7->C7_NUM) - StoD(TMPSC7->C7_EMISSAO))
								nPAPvPed -= GetFds(StoD(TMPSC7->C7_EMISSAO),nPNRFUN4)
								nPAPvPed := AllTrim(Transform(Abs(nPAPvPed), '@E 999,999'))
								
								nPrzCom := Abs(PNRFun4(TMPSC7->C7_FILIAL, TMPSC7->C7_NUM) - StoD(TMPSC1->C1_EMISSAO))
								nPrzCom -= GetFds(StoD(TMPSC1->C1_EMISSAO),nPNRFUN4)
								nPrzCom := AllTrim(Transform(Abs(nPrzCom), '@E 999,999'))
														
							ENDIF
							
							nPrzEnt := 0
							
							nPrzAtend := Abs(StoD(TMPSD1->D1_DTDIGIT) - StoD(TMPSC1->C1_EMISSAO))
							nPrzAtend -= GetFds(StoD(TMPSD1->D1_DTDIGIT),StoD(TMPSC1->C1_EMISSAO))
							nPrzAtend := AllTrim(Transform(ABS(nPrzAtend), '@E 999,999'))
							
							cxus := Posicione("SC8",1,TMPSC7->C7_FILIAL+TMPSC8->C8_NUM,"C8_XUSER")
							cXUs := GetUserR(cxus,TMPSC7->C7_FILIAL)
							
							aAdd(aDadosCOM, {cDescFil,;												// 1 - Descricao da Filial
							TMPSC1->C1_NUM,;																	// 2 - Numero da Solicitacao de Compra
							DtoC(StoD(TMPSC1->C1_EMISSAO)),;										// 3 - Data de Emissao da Solicitacao de Compra
							TMPSC7->C7_CONAPRO,;															// 4 - Status do Pedido de Compra B = Bloqueado; L = Liberado
							cxus,;															// 5 - Codigo do Grupo de Compras   TMPSC7->C7_GRUPCOM
							cDescCTT,;																			// 6 - Descricao do Centro de Custo
							AllTrim(Transform(nVlrTPed, '@E 999,999,999.99')),;		// 7 - Valor Total do Pedido de Compra
							TMPSC7->C7_NUM,;																	// 8 - Numero do Pedido de Compra
							DtoC(StoD(TMPSC7->C7_EMISSAO)),;										// 9 - Data de Emissao do Pedido de Compra
							nQtItPed,;																			// 10 - Quantidade de Itens do Pedido de Compra
							'',;																						// 11 - Numero e Serie da Nota Fiscal
							'',;																						// 12 - Data de Emissao da Nota Fiscal
							dVencNF,;																				// 13 - Data do 1o Vencimento da Nota Fiscal
							TMPSC7->C7_FORNECE + '/' + TMPSC7->C7_LOJA + '-' + AllTrim(Posicione('SA2', 1, xFilial('SA2') + TMPSC7->C7_FORNECE + TMPSC7->C7_LOJA, 'A2_NOME')),;		// 14 - Dados do Fornecedor
							dUApvPed,;																			// 15 - Data da Ultima Aprovacao do Pedido de Compras
							'',;																						// 16 - Data de Digitacao da Nota Fiscal
							nPrzCot,;																				// 17 - Prazo de Geracao da Cotacao
							nPrzRKCot,;																			// 18 - Prazo do Ranking da Cotacao
							nPrzAPed,;																			// 19 - Prazo de Analise da Cotacao
							nPAPvPed,;																			// 20 - Prazo da Aprovacao do Pedido de Compra
							nPrzCom,;																				// 21 - Prazo de Compra
							Transform(nPrzEnt, '999,999'),;											// 22 - Prazo de Entrega
							nPrzAtend,;																			// 23 - Prazo de Atendimento
							DtoC(StoD(TMPSD1->D1_DTDIGIT)),; 										// 24 - Dt Digitacao Doc entrada
							aDt[1],; 																				// 25 - Dt envio WF da cotaï¿½ï¿½o
							aDt[2],;																				// 26 - Dt ultima aprovacao mapa cotacao
							aDt[3]}) 																				// 27 - Possui mapa de cotacao?
						
							aAdd(aInd1, {AllTrim(TMPSC7->C7_NUM) + AllTrim(TMPSD1->D1_DOC) + AllTrim(TMPSD1->D1_SERIE), (StoD(TMPSC8->C8_EMISSAO) - StoD(TMPSC1->C1_EMISSAO))})
							aAdd(aInd2, {AllTrim(TMPSC7->C7_NUM) + AllTrim(TMPSD1->D1_DOC) + AllTrim(TMPSD1->D1_SERIE), ((StoD(TMPSC8->C8_EMISSAO) - StoD(TMPSC1->C1_EMISSAO)) * nVlrTPed)})
						EndIf
					EndIf
				EndIf
			EndIf
			TMPSC7->(DbSkip())
		End
		
		cFilAnt := cFilBkp
		RestArea(aAreaSM0)
	Next
	
	If (mv_par11 == 1)
		/*/ Verifica se o arquivo existe /*/
		If File(AllTrim(mv_par12) + '.csv')
			/*/ Apaga o arquivo /*/
			fErase(AllTrim(mv_par12) + '.csv')
		EndIf
		nHdl := fCreate(AllTrim(mv_par12) + '.csv')
	
		If (nHdl == -1)
			MsgAlert('O arquivo de nome: ' + mv_par12 + ' nao pode ser criado! Verifique os previlegios de gravacao.' + Chr(13) +;
				'Informe ao SUPORTE de TI', 'Atencao!')
		EndIf
		
		If (mv_par09 == 1) // PMC
			cTxtARQ := ';;;;;;;;;;INDICADORES PMC - ' + DtoC(mv_par03) + ' A ' + DtoC(mv_par04) + ' ;;;;;;;;;' + Chr(13) + Chr(10)
			
			*'Yttalo P. Martins-INICIO-11/03/15------------------------------------------------'*
			//cTxtARQ += 'FILIAL;NUMERO SC;EMISSAO SC;STATUS PC;COMPRADOR;CENTRO CUSTO;ENVIO WF;ULT APROV;R$ TOTAL PC;NUMERO PC;EMISSAO PC;QTD ITENS PC;NUMERO NF;EMISSAO NF;VECTO NF;FORNECEDOR;DATA APRV PC;DATA RECEB NF;PRAZO COTACAO;PRAZO RANKING;PRAZO ANALISE;PRAZO APROVACAO;PRAZO COMPRA' + Chr(13) + Chr(10)
			cTxtARQ += 'FILIAL;NUMERO SC;EMISSAO SC;STATUS PC;COMPRADOR;CENTRO CUSTO;ENVIO WF;ULT APROV;R$ TOTAL PC;NUMERO PC;EMISSAO PC;QTD ITENS PC;NUMERO NF;EMISSAO NF;VECTO NF;FORNECEDOR;DATA APRV PC;DATA RECEB NF;PRAZO COTACAO;PRAZO RANKING;PRAZO ANALISE;PRAZO APROVACAO;PRAZO COMPRA;POSSUI MP COTACAO' + Chr(13) + Chr(10)
			*'Yttalo P. Martins-FIM-11/03/15---------------------------------------------------'*
			
		ElseIf (mv_par09 == 2) // PMA
			cTxtARQ := ';;;;;;;;;;;INDICADORES PMA - ' + DtoC(mv_par03) + ' A ' + DtoC(mv_par04) + ' ;;;;;;;;;;' + Chr(13) + Chr(10)
			
			*'Yttalo P. Martins-INICIO-11/03/15------------------------------------------------'*
			//cTxtARQ += 'FILIAL;NUMERO SC;EMISSAO SC;STATUS PC;COMPRADOR;CENTRO CUSTO;ENVIO WF;ULT APROV;R$ TOTAL PC;NUMERO PC;EMISSAO PC;QTD ITENS PC;NUMERO NF;EMISSAO NF;VECTO NF;FORNECEDOR;DATA APRV PC;DATA RECEB NF;PRAZO COTACAO;PRAZO RANKING;PRAZO ANALISE;PRAZO APROVACAO;PRAZO COMPRA;PRAZO ENTREGA;PRAZO ATENDIMENTO;VALOR DA NF;QTD ITENS NF' + Chr(13) + Chr(10)
			cTxtARQ += 'FILIAL;NUMERO SC;EMISSAO SC;STATUS PC;COMPRADOR;CENTRO CUSTO;ENVIO WF;ULT APROV;R$ TOTAL PC;NUMERO PC;EMISSAO PC;QTD ITENS PC;NUMERO NF;EMISSAO NF;VECTO NF;FORNECEDOR;DATA APRV PC;DATA RECEB NF;PRAZO COTACAO;PRAZO RANKING;PRAZO ANALISE;PRAZO APROVACAO;PRAZO COMPRA;PRAZO ENTREGA;PRAZO ATENDIMENTO;VALOR DA NF;QTD ITENS NF;POSSUI MP COTACAO' + Chr(13) + Chr(10)			
			*'Yttalo P. Martins-FIM-11/03/15---------------------------------------------------'*
		EndIf
		
		/*/ Organiza o array por filial + comprador /*/
		aSort(aDadosCOM,,, { |x,y| x[1] + x[5] + x[6] < y[1] + y[5] + y[6] })
		
		ProcRegua(Len(aDadosCOM))
		For nImp := 1 To Len(aDadosCOM)
			If Interrupcao(@lEnd)
				Exit
			EndIf
			
			IncProc('Gravando dados...')
			
			If (mv_par09 == 1) // PMC
			
				For nTxt := 1 To Len(aDadosCOM[nImp])
					If (nTxt < 22)
						If (nTxt == 6)
							cRep := '-X-' + AllTrim(STR(nTxt)) + ";"
						Else
							cRep := ''
						EndIf
						cTxtARQ += aDadosCOM[nImp, nTxt] + ';' + cRep
					EndIf
				Next
				cTxtARQ := Replace(cTxtARQ, '-X-6', aDadosCOM[nImp][25] + ';' + aDadosCOM[nImp][26])
				
				*'Yttalo P. Martins-INICIO-11/03/15------------------------------------------------'*
				cTxtARQ += aDadosCOM[nImp, len(aDadosCOM[nImp]) ] + ';'
				*'Yttalo P. Martins-FIM-11/03/15---------------------------------------------------'*
				
			ElseIf (mv_par09 == 2)	// PMA
				For nTxt := 1 To Len(aDadosCOM[nImp])
					If (nTxt < 24)
						If (nTxt == 6)
							cRep := '-X-' + AllTrim(Str(nTxt)) + ';'
						Else
							cRep := ''
						EndIf
						cTxtARQ += aDadosCOM[nImp, nTxt] + ';' + cRep
					EndIf
				Next
				cTxtARQ := Replace(cTxtARQ, '-X-6', aDadosCOM[nImp][25] + ';' + aDadosCOM[nImp][26])
				cTxtARQ += aDadosCOM[nImp, 29] + ';'
				cTxtARQ += aDadosCOM[nImp, 28] + ';'
				
				*'Yttalo P. Martins-INICIO-11/03/15------------------------------------------------'*
				cTxtARQ += aDadosCOM[nImp, len(aDadosCOM[nImp]) ] + ';'
				*'Yttalo P. Martins-FIM-11/03/15---------------------------------------------------'*
			EndIf
			
			cTxtARQ := SubStr(cTxtARQ, 1, (Len(cTxtARQ) - 1))
			cTxtARQ += Chr(13) + Chr(10)
		Next
		
		/*/ Grava os dados no arquivo /*/
		fWrite(nHdl, cTxtARQ, Len(cTxtARQ))
		
		/*/ Fecha o arquivo /*/
		fClose(nHdl)
	EndIf

Return

/*
 Imprime o cabecalho do relatorio.   
*/
Static Function PNRCabec(nRel)
Local nY := 0	
Local nX := 0
Local nZ := 0
Local nW := 0

	Private cLogo := If((AllTrim(SM0->M0_CODFIL) == '0101'), 'LogoPNovo.png', 'LogoTCR.png')
	
	If !File(cLogo)
		cLogo := 'lgrl' + AllTrim(SM0->M0_CODIGO) + '.bmp'
		If !File(cLogo)
			cLogo := 'lgrl.bmp'
		EndIf
	EndIf

	cLogo := If((cLogo == Nil), '', cLogo)

	oPrn:EndPage()
	oPrn:StartPage()

	/*/ Calcula disposicao/dimensoes do box da pagina do relatorio /*/
	aADisp1 := {0000, 0000, (nMaxV - 50), (nMaxH - 50)}
	aObjHor1 := {{100}}
	aObjVer1 := {{100}}
	aObjMar1 := {50, 50, 50, 50, 0}
	aDimObj1 := LMPCalcObj(1, aADisp1, aObjHor1, aObjVer1, aObjMar1)

	/*/ Desenha o box da pagina /*/
	For nX := 1 To Len(aDimObj1)
		For nY := 1 To Len(aDimObj1[nX])
			oPrn:Box(aDimObj1[nX, nY, 1], aDimObj1[nX, nY, 2], aDimObj1[nX, nY, 3], aDimObj1[nX, nY, 4])	// Box da Pagina.
		Next
	Next

	/*/ Calcula disposicao/dimensoes dos boxs do cabecalho do relatorio /*/
	aADisp2 := {aDimObj1[1, 1, 1], aDimObj1[1, 1, 2], aDimObj1[1, 1, 3], (aDimObj1[1, 1, 4] - 8)}
	aObjHor2 := {{10, 80, 10}}
	aObjVer2 := {{5, 5, 5}}
	aObjMar2 := {5, 5, 5, 5, 0}
	aDimObj2 := LMPCalcObj(1, aADisp2, aObjHor2, aObjVer2, aObjMar2)

	/*/ Desenha os boxes do cabecalho /*/
	For nX := 1 To Len(aDimObj2)
		nLin := aDimObj2[nX, nY, 3]
		For nY := 1 To Len(aDimObj2[nX])
			oPrn:Box(aDimObj2[nX, nY, 1], aDimObj2[nX, nY, 2], aDimObj2[nX, nY, 3], aDimObj2[nX, nY, 4])		// Box do cabecalho
			If (nY == 1)
				oPrn:SayBitmap((aDimObj2[nX, nY, 1] + 15), (aDimObj2[nX, nY, 2] + 25), cLogo, 0189, 0139)													// Impressao do Logotipo.
			ElseIf (nY == 2)
				oPrn:Say(((aDimObj2[nX, nY, 1] + aDimObj2[nX, nY, 3]) / 2), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), If((nRel == 1), 'INDICADORES PMC - ' + DtoC(mv_par03) + ' A ' + DtoC(mv_par04), 'INDICADORES PMA - ' + DtoC(mv_par03) + ' A ' + DtoC(mv_par04)), oFontbN,,,, 2)					// Impressao do Titulo.
			ElseIf (nY == 3)
				oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Pagina', oFontaN,,,, 0)									// Pagina
				oPrn:Say((((aDimObj2[nX, nY, 1] + aDimObj2[nX, nY, 3]) / 2) - 10), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), StrZero(oPrn:nPage, 2), oFontcN,, RGB(215, 215, 215),, 2)
			EndIf
		Next
	Next
	
	/*/ Calcula disposicao/dimensoes dos boxs do cabecalho do grid /*/
	aADisp3 := {nLin, aDimObj1[1, 1, 2], aDimObj1[1, 1, 3], (aDimObj1[1, 1, 4] - 8)}
	aObjHor3 := {{11, 17, 30, 8, 8, 26}}    //11,25
	aObjVer3 := {{3, 3, 3, 3, 3, 3}}
	aObjMar3 := {5, 5, 5, 5, 5}
	aDimObj3 := LMPCalcObj(1, aADisp3, aObjHor3, aObjVer3, aObjMar3)
	
	/*/ Desenha os boxes do cabecalho /*/
	For nX := 1 To Len(aDimObj3)
		nLin := aDimObj3[nX, nY, 3]
		For nY := 1 To Len(aDimObj3[nX])
			oPrn:Box(aDimObj3[nX, nY, 1], aDimObj3[nX, nY, 2], aDimObj3[nX, nY, 3], aDimObj3[nX, nY, 4])		// Box do cabecalho
			If (nY == 1)
				oPrn:Say((((aDimObj3[nX, nY, 1] + aDimObj3[nX, nY, 3]) / 2) - 10), ((aDimObj3[nX, nY, 2] + aDimObj3[nX, nY, 4]) / 2), 'FILIAL', oFontaN,,,, 2)									// Filial
			ElseIf (nY == 2)
				oPrn:Say((((aDimObj3[nX, nY, 1] + aDimObj3[nX, nY, 3]) / 2) - 10), ((aDimObj3[nX, nY, 2] + aDimObj3[nX, nY, 4]) / 2), 'COMPRADOR', oFontaN,,,, 2)									// Grupo Compras
			ElseIf (nY == 3)
				oPrn:Say((((aDimObj3[nX, nY, 1] + aDimObj3[nX, nY, 3]) / 2) - 10), ((aDimObj3[nX, nY, 2] + aDimObj3[nX, nY, 4]) / 2), 'CENTRO CUSTO', oFontaN,,,, 2)									// Centro Custo
			ElseIf (nY == 4)
				oPrn:Say((((aDimObj3[nX, nY, 1] + aDimObj3[nX, nY, 3]) / 2) - 10), ((aDimObj3[nX, nY, 2] + aDimObj3[nX, nY, 4]) / 2), If((nRel == 1), 'PMC 1', 'PMA 1'), oFontaN,,,, 2)									// PMC/PMA
			ElseIf (nY == 5)
				oPrn:Say((((aDimObj3[nX, nY, 1] + aDimObj3[nX, nY, 3]) / 2) - 10), ((aDimObj3[nX, nY, 2] + aDimObj3[nX, nY, 4]) / 2), If((nRel == 1), 'PMC 2', 'PMA 2'), oFontaN,,,, 2)									// PMC/PMA Ponderado
			ElseIf (nY == 6)
				/*/ Calcula disposicao/dimensoes dos boxs do cabecalho do grid /*/
				aADisp4 := {aDimObj3[nX, nY, 1], aDimObj3[nX, nY, 2], aDimObj3[nX, nY, 3], aDimObj3[nX, nY, 4]}
        	
				If (mv_par09 == 1)
					aObjHor4 := {{100}, {50, 50}}
					aObjVer4 := {{50}, {50, 50}}
				ElseIf (mv_par09 == 2)
					aObjHor4 := {{100},{100}}
					aObjVer4 := {{100},{0}}
				EndIf

				aObjMar4 := {0, 0, 0, 0, 0}
				aDimObj4 := LMPCalcObj(1, aADisp4, aObjHor4, aObjVer4, aObjMar4)

				For nW := 1 To Len(aDimObj4)
					For nZ := 1 To Len(aDimObj4[nW])
						oPrn:Box(aDimObj4[nW, nZ, 1], aDimObj4[nW, nZ, 2], aDimObj4[nW, nZ, 3], aDimObj4[nW, nZ, 4])		// Box do cabecalho

						If (nW == 1) .And. (nZ == 1)
							oPrn:Say((((aDimObj4[nW, nZ, 1] + aDimObj4[nW, nZ, 3]) / 2) - 15), ((aDimObj4[nW, nZ, 2] + aDimObj4[nW, nZ, 4]) / 2), 'EFICIENCIA COMPRADOR', oFontaN,,,, 2)									// Eficiencia Comprador
						ElseIf (nW == 2) .And. (nZ == 1) .AND. (mv_par09 == 1)
							oPrn:Say((((aDimObj4[nW, nZ, 1] + aDimObj4[nW, nZ, 3]) / 2) - 15), ((aDimObj4[nW, nZ, 2] + aDimObj4[nW, nZ, 4]) / 2), 'INDICADOR 1', oFontaN,,,, 2)									// Indicador 1
						ElseIf (nW == 2) .And. (nZ == 2) .AND. (mv_par09 == 1)
							oPrn:Say((((aDimObj4[nW, nZ, 1] + aDimObj4[nW, nZ, 3]) / 2) - 15), ((aDimObj4[nW, nZ, 2] + aDimObj4[nW, nZ, 4]) / 2), 'INDICADOR 2', oFontaN,,,, 2)									// Indicador 2
						ElseIf (nW == 2) .And. (nZ == 3)
							oPrn:Say((((aDimObj4[nW, nZ, 1] + aDimObj4[nW, nZ, 3]) / 2) - 15), ((aDimObj4[nW, nZ, 2] + aDimObj4[nW, nZ, 4]) / 2), 'INDICADOR 1 %', oFontaN,,,, 2)									// Indicador 1
						ElseIf (nW == 2) .And. (nZ == 4)
							oPrn:Say((((aDimObj4[nW, nZ, 1] + aDimObj4[nW, nZ, 3]) / 2) - 15), ((aDimObj4[nW, nZ, 2] + aDimObj4[nW, nZ, 4]) / 2), 'INDICADOR 2 %', oFontaN,,,, 2)									// Indicador 2
						EndIf
						
					Next
				Next
				
			EndIf
		Next
	Next

Return(nLin)

/*
 Impressao dos totais do relatorio.   
*/
Static Function PNRSubCab(cVarIni, nOpc)

	Local aMargens := {(nLin + 10), 0055, (nLin + 55), (aDimObj1[1, 1, 4] - 8)}

	oPrn:Box(aMargens[1], aMargens[2], aMargens[3], aMargens[4])
	oPrn:FillRect({(aMargens[1] + 2), (aMargens[2] + 2), (aMargens[3] - 2), (aMargens[4] - 2)}, oBrush)
	
	nLin += 12
	
	oPrn:Say(nLin, (aMargens[2] + 10), If((nOpc == 1) .Or. (nOpc == 3), 'TOTAL DO COMPRADOR: ', 'TOTAL DA FILIAL: ') + cVarIni , oFontaN,,,, 0)
	If (nOpc == 1)
		oPrn:Say(nLin, ((aDimObj3[1, 4, 2] + aDimObj3[1, 4, 4]) / 2), AllTrim(Transform((nTotGRP1 / nMedGrp), '@E 9,999.99')), oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj3[1, 5, 2] + aDimObj3[1, 5, 4]) / 2), AllTrim(Transform((nTotGRP2 / nMedGrp), '@E 9,999.99')), oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj4[2, 1, 2] + aDimObj4[2, 1, 4]) / 2), AllTrim(Transform(nTotGRP3, '@E 9,999.99')), oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj4[2, 2, 2] + aDimObj4[2, 2, 4]) / 2), AllTrim(Transform(nTotGRP4, '@E 9,999.99')), oFonta,,,, 2)
		
		nTotFIL1 += (nTotGRP1 / nMedGrp)
		nTotFIL2 += (nTotGRP2 / nMedGrp)
		nTotFIL3 += (nTotGRP3 / nMedGrp)
		nTotFIL4 += (nTotGRP4 / nMedGrp)
		
		nMedFil++
	ElseIf (nOpc == 2)
		oPrn:Say(nLin, ((aDimObj3[1, 4, 2] + aDimObj3[1, 4, 4]) / 2), AllTrim(Transform((nTotFIL1 / nMedFil), '@E 9,999.99')), oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj3[1, 5, 2] + aDimObj3[1, 5, 4]) / 2), AllTrim(Transform((nTotFIL2 / nMedFil), '@E 9,999.99')), oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj4[2, 1, 2] + aDimObj4[2, 1, 4]) / 2), AllTrim(Transform(nTotFIL3, '@E 9,999.99')), oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj4[2, 2, 2] + aDimObj4[2, 2, 4]) / 2), AllTrim(Transform(nTotFIL4, '@E 9,999.99')), oFonta,,,, 2)
	ElseIf (nOpc == 3)
		oPrn:Say(nLin, ((aDimObj3[1, 4, 2] + aDimObj3[1, 4, 4]) / 2), AllTrim(Transform((nTotGRP1 / nMedGrp), '@E 9,999.99')), oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj3[1, 5, 2] + aDimObj3[1, 5, 4]) / 2), AllTrim(Transform((nTotGRP2 / nMedGrp), '@E 9,999.99')), oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj4[2, 1, 2] + aDimObj4[2, 1, 4]) / 2), AllTrim(Transform((nTotGRP3 / nMedGrp), '@E 999,999.99')) + ' %', oFonta,,,, 2)
		If (mv_par09 == 1)
			oPrn:Say(nLin, ((aDimObj4[2, 2, 2] + aDimObj4[2, 2, 4]) / 2), AllTrim(Transform(nTotGRP4, '@E 999,999.99')) + ' %', oFonta,,,, 2)
			nTotFIL4 += (nTotGRP4 / nMedGrp)
		EndIf
		nTotFIL1 += (nTotGRP1 / nMedGrp)
		nTotFIL2 += (nTotGRP2 / nMedGrp)
		nTotFIL3 += (nTotGRP3 / nMedGrp)
		
		nMedFil++
	ElseIf (nOpc == 4)
		oPrn:Say(nLin, ((aDimObj3[1, 4, 2] + aDimObj3[1, 4, 4]) / 2), AllTrim(Transform((nTotFIL1 / nMedFil), '@E 9,999.99')), oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj3[1, 5, 2] + aDimObj3[1, 5, 4]) / 2), AllTrim(Transform((nTotFIL2 / nMedFil), '@E 9,999.99')), oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj4[2, 1, 2] + aDimObj4[2, 1, 4]) / 2), AllTrim(Transform((nTotFIL3 / nMedFil), '@E 999,999.99')) + ' %', oFonta,,,, 2)
		If (mv_par09 == 1)
			oPrn:Say(nLin, ((aDimObj4[2, 2, 2] + aDimObj4[2, 2, 4]) / 2), AllTrim(Transform(nTotFIL4, '@E 999,999.99')) + ' %', oFonta,,,, 2)
		EndIf
	EndIf
	
	nLin := aMargens[3]

Return(nLin)

/*
 Impressao dos itens do realtorio.  
*/
Static Function PNRItens(nRel)
	
	nLin += 0030
		
	If (nRel == 1)

		PswOrder(1)
		PswSeek(aPMC[nImp, 02], .T.)
		
		aUser := PswRet(1)
		
		cCompr := ''
		If (Len(aUser) > 0)
			cCompr := Upper(aPMC[nImp, 02] + ' - ' + aUser[1, 02])
		EndIf
		
		oPrn:Say(nLin, ((aDimObj3[1, 1, 2] + aDimObj3[1, 1, 4]) / 2), aPMC[nImp, 01], oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj3[1, 2, 2] + aDimObj3[1, 2, 4]) / 2), cCompr, oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj3[1, 3, 2] + aDimObj3[1, 3, 4]) / 2), aPMC[nImp, 03], oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj3[1, 4, 2] + aDimObj3[1, 4, 4]) / 2), AllTrim(Transform(aPMC[nImp, 04], '@E 999,999.99')), oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj3[1, 5, 2] + aDimObj3[1, 5, 4]) / 2), AllTrim(Transform(aPMC[nImp, 05], '@E 999,999.99')), oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj4[2, 1, 2] + aDimObj4[2, 1, 4]) / 2), AllTrim(Transform(aPMC[nImp, 06], '@E 999,999.99')), oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj4[2, 2, 2] + aDimObj4[2, 2, 4]) / 2), AllTrim(Transform(aPMC[nImp, 07], '@E 999,999.99')), oFonta,,,, 2)
		
		nTotGrp1 += aPMC[nImp, 04]
		nTotGrp2 += aPMC[nImp, 05]
		nTotGrp3 += aPMC[nImp, 06]
		nTotGrp4 += aPMC[nImp, 07]
		nMedGrp++
	ElseIf (nRel == 2)
		PswOrder(1)
		PswSeek(aPMA[nImp, 02],.T.)
		
		aUser := PswRet(1)
		cCompr := ''
		If (Len(aUser) > 0)
			cCompr := Upper(aPMA[nImp, 02] + ' - ' + aUser[1, 2])
		EndIf
			
		oPrn:Say(nLin, ((aDimObj3[1, 1, 2] + aDimObj3[1, 1, 4]) / 2), aPMA[nImp, 01], oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj3[1, 2, 2] + aDimObj3[1, 2, 4]) / 2), cCompr, oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj3[1, 3, 2] + aDimObj3[1, 3, 4]) / 2), aPMA[nImp, 03], oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj3[1, 4, 2] + aDimObj3[1, 4, 4]) / 2), AllTrim(Transform(aPMA[nImp, 04], '@E 999,999.99')), oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj3[1, 5, 2] + aDimObj3[1, 5, 4]) / 2), AllTrim(Transform(aPMA[nImp, 05], '@E 999,999.99')), oFonta,,,, 2)
		oPrn:Say(nLin, ((aDimObj4[2, 1, 2] + aDimObj4[2, 1, 4]) / 2), AllTrim(Transform(aPMA[nImp, 06], '@E 999,999.99')) + ' %', oFonta,,,, 2)
		
		nTotGRP1 += aPMA[nImp, 04]
		nTotGRP2 += aPMA[nImp, 05]
		nTotGRP3 += aPMA[nImp, 06]
		nTotGRP4 += 0
		nMedGrp++
	EndIf
		
	nLin += 0020
	oPrn:Say(nLin, 0065, Replicate('-', 118), oFontc,, RGB(220, 220, 220),, 0)
	nLin += 0020
	
Return(nLin)

/*
 Retorna o total do pedido de compras.    
*/
Static Function PNRFun1(cFil, cPed)

	Local nRet := 0

	If (Select('TOTSC7') > 0)
		TOTSC7->(DbCloseArea())
	EndIf
	cQry := 'SELECT SUM(C7_TOTAL) TOTPED '
	cQry += 'FROM ' + RetSQLName('SC7') + ' SC7 '
	cQry += "WHERE SC7.C7_FILIAL = '" + cFil + "' "
	cQry += "AND SC7.C7_NUM = '" + cPed + "' "
	cQry += "AND SC7.D_E_L_E_T_ = '' "
	TcQuery cQry NEW ALIAS 'TOTSC7'
	TOTSC7->(DbGoTop())
	If !TOTSC7->(Eof())
		nRet := TOTSC7->TOTPED
	EndIf

Return(nRet)

/*
 Retorna o total de itens do pedido de compras.   
 */
Static Function PNRFun2(cFil, cPed)

	Local nRet := 0

	If (Select('TOTSC7') > 0)
		TOTSC7->(DbCloseArea())
	EndIf
	cQry := 'SELECT COUNT(*) TOTITEM '
	cQry += 'FROM ' + RetSQLName('SC7') + ' SC7 '
	cQry += "WHERE SC7.C7_FILIAL = '" + cFil + "' "
	cQry += "AND SC7.C7_NUM = '" + cPed + "' "
	cQry += "AND SC7.D_E_L_E_T_ = '' "
	TcQuery cQry NEW ALIAS 'TOTSC7'
	TOTSC7->(DbGoTop())
	If !TOTSC7->(Eof())
		nRet := TOTSC7->TOTITEM
	EndIf

Return(nRet)


/*
Retorna a data do primeiro vencimento da NF.        
*/
Static Function PNRFun3(cFil, cNota, cSerie, cForn, cLoja)

	Local dRet := CtoD('  /  /  ')

	If (Select('TMPSE2') > 0)
		TMPSE2->(DbCloseArea())
	EndIf
	cQry := 'SELECT E2_VENCTO '
	cQry += 'FROM ' + RetSQLName('SE2') + ' '
	cQry += "WHERE E2_FILIAL = '" + cFil + "' "
	cQry += "AND E2_PREFIXO = '" + cSerie + "' "
	cQry += "AND E2_NUM = '" + cNota + "' "
	cQry += "AND E2_FORNECE = '" + cForn + "' "
	cQry += "AND E2_LOJA = '" + cLoja + "' "
	cQry += "AND D_E_L_E_T_ = '' "
	cQry += 'ORDER BY E2_PREFIXO, E2_NUM, E2_PARCELA '
	TcQuery cQry NEW ALIAS 'TMPSE2'
	TMPSE2->(DbGoTop())
	If !TMPSE2->(Eof())
		dRet := StoD(TMPSE2->E2_VENCTO)
	EndIf

Return(dRet)

/*
Retorna a data da ultima aprovacao do pedido de compra.     
*/
Static Function PNRFun4(cFil, cPed)

	Local dRet := CtoD('  /  /  ')
	
	If (Select('TMPAPV') > 0)
		TMPAPV->(DbCloseArea())
	EndIf

	cQry := 'SELECT MAX(CR_DATALIB) CR_ULTAPV '
	cQry += 'FROM ' + RetSQLName('SCR') + " WHERE CR_TIPO = 'PC' "
	cQry += "AND CR_FILIAL = '" + cFil + "' "
	cQry += "AND CR_NUM = '" + cPed + "' "
	cQry += "AND D_E_L_E_T_ = '' "
	TcQuery cQry NEW ALIAS 'TMPAPV'
	TMPAPV->(DbGoTop())
	If !TMPAPV->(Eof())
		dRet := StoD(TMPAPV->CR_ULTAPV)
	EndIf

Return(dRet)

/*
 Retorna o prazo do ranking da cotacao do pedido de compra.    
*/
Static Function PNRFun5(cFil, cCot)
	
	Local nRet := 0
	
	If (Select('TMPRKN') > 0)
		TMPRKN->(DbCloseArea())
	EndIf
	cQry := 'SELECT CR_EMISSAO, MAX(CR_DATALIB) CR_ULTAPV '
	cQry += 'FROM ' + RetSQLName('SCR') + " WHERE CR_TIPO = 'MC' "
	cQry += "AND CR_FILIAL = '" + cFil + "' "
	cQry += "AND CR_NUM = '" + cCot + "' "
	cQry += "AND D_E_L_E_T_ = '' "
	cQry += 'GROUP BY CR_EMISSAO '
	TcQuery cQry NEW ALIAS 'TMPRKN'
	TMPRKN->(DbGoTop())
	If !TMPRKN->(Eof())
		nRet := (StoD(TMPRKN->CR_ULTAPV) - StoD(TMPRKN->CR_EMISSAO))
		nRet -=  GetFds(StoD(TMPRKN->CR_ULTAPV),StoD(TMPRKN->CR_EMISSAO))
		
	EndIf
	
Return(Abs(nRet))

/*
 Retorn o valor total da nota fiscal.    
*/
Static Function PNRFun6(cFil, cNota, cSerie, cForn, cLoja, cPedCom)

	Local nRet := 0

	/*/ Verifica se a tabela temporaria esta em USO /*/
	If (Select('TOTNF') > 0)
		TOTNF->(DbCloseArea())
	EndIf
	cQry := 'SELECT SUM(D1_TOTAL) D1_TOTAL '
	cQry += 'FROM ' + RetSQLName('SD1') + ' '
	cQry += "WHERE D1_FILIAL = '" + cFil + "' "
	cQry += "AND D1_DOC = '" + cNota + "' "
	cQry += "AND D1_SERIE = '" + cSerie + "' "
	cQry += "AND D1_FORNECE = '" + cForn + "' "
	cQry += "AND D1_LOJA = '" + cLoja + "' "
	cQry += "AND D1_PEDIDO = '" + cPedCom + "' "
	cQry += "AND D_E_L_E_T_ = '' "
	TcQuery cQry NEW ALIAS 'TOTNF'
	TOTNF->(DbGoTop())
	If !TOTNF->(Eof())
		nRet := TOTNF->D1_TOTAL
	EndIf

Return(nRet)

/*
 Retorna a quantidade de itens da nota fiscal. 
*/
Static Function PNRFun7(cFil, cNota, cSerie, cForn, cLoja, cPedCom)

	Local nRet := 0

	/*/ Verifica se a tabela temporaria esta em USO /*/
	If (Select('TOTNF') > 0)
		TOTNF->(DbCloseArea())
	EndIf
	cQry := 'SELECT COUNT(D1_DOC) D1_TOTIT '
	cQry += 'FROM ' + RetSQLName('SD1') + ' '
	cQry += "WHERE D1_FILIAL = '" + cFil + "' "
	cQry += "AND D1_DOC = '" + cNota + "' "
	cQry += "AND D1_SERIE = '" + cSerie + "' "
	cQry += "AND D1_FORNECE = '" + cForn + "' "
	cQry += "AND D1_LOJA = '" + cLoja + "' "
	cQry += "AND D1_PEDIDO = '" + cPedCom + "' "
	cQry += "AND D_E_L_E_T_ = '' "
	TcQuery cQry NEW ALIAS 'TOTNF'
	TOTNF->(DbGoTop())
	If !TOTNF->(Eof())
		nRet := TOTNF->D1_TOTIT
	EndIf

Return(nRet)

/*
Retorna a quantidade de itens da solicitacao.  
*/
Static Function PNRFun8(cFil, cSolic)

	Local nRet := 0

	/*/ Verifica se a tabela temporaria esta em USO /*/
	If (Select('TOTSC') > 0)
		TOTSC->(DbCloseArea())
	EndIf
	cQry := 'SELECT COUNT(C1_ITEM) C1_TOTIT '
	cQry += 'FROM ' + RetSQLName('SC1') + ' '
	cQry += "WHERE C1_FILIAL = '" + cFil + "' "
	cQry += "AND C1_NUM = '" + cSolic + "' "
	cQry += "AND D_E_L_E_T_ = '' "
	TcQuery cQry NEW ALIAS 'TOTSC'
	TOTSC->(DbGoTop())
	If !TOTSC->(Eof())
		nRet := TOTSC->C1_TOTIT
	EndIf

Return(nRet)

/*
 Calcula as dimensoes dos objetos.    
*/
Static Function LMPCalcObj(nTipo, aADisp, aObjHor, aObjVer, aObjMar)

	/*/ nTipo /*/
	/*/ Tipo de calculo a ser efetuado:/*/
	/*/ 1 = Calcula as coordenadas do objeto [linha inicial, coluna inicial, linha final, coluna final] /*/
	/*/ 2 = Calcula as coordenadas e a dimensao do objeto [linha inicial, coluna inicial, largura, altura] /*/

	/*/ aADisp /*/
	/*/ Coordenadas da area disponivel: /*/
	/*/ {linha inicial, coluna inicial, linha final, coluna final} /*/

	/*/ aObjHor /*/
	/*/ Lista os objetos na horizontal (Linhas) e seus respectivos percentuais de ocupacao de area: /*/
	/*/ {10, 50, 40} /*/

	/*/ aObjVer /*/
	/*/ Lista os objetos na vertical (Colunas) e seus respectivos percentuais de ocupacao de area: /*/
	/*/ {100, 100, 100} /*/

	/*/ aObjMar /*/
	/*/ Relacao das margens acima, esquerda, abaixo, direita e entre os objetos: /*/
	/*/ {5, 5, 5, 5, 5} /*/

	Local aRet := {}
	Local nObj := 0
	Local nJ	:= 0
	Local nObjIT := 0

	/*/ Cria os elementos do vetor de retorno /*/
	For nObj := 1 To Len(aObjVer)
		aAdd(aRet, {})
		For nJ := 1 To Len(aObjHor[nObj])
			aAdd(aRet[nObj], {0, 0, 0, 0})
		Next
	Next

	/*/ Calcula as dimensoes dos objetos /*/
	For nObj := 1 To Len(aRet)
		If (nObj == 1)
			For nObjIT := 1 To Len(aRet[nObj])
				/*/ Calcula as dimensoes do primeiro objeto do vetor /*/
				If (nObjIT == 1)
					If (nTipo == 1)
						/*/ Calcula a linha inicial do objeto /*/
						aRet[nObj, nObjIT, 1] := (aADisp[1] + aObjMar[1])

						/*/ Calcula a coluna inicial do objeto /*/
						aRet[nObj, nObjIT, 2] := (aADisp[2] + aObjMar[2])

						/*/ Calcula a coluna final do objeto /*/
						nLargura := (aADisp[4] - aADisp[2])
						If (nObjIT == Len(aRet[nObj]))
							/*/ Calcula a coluna final do objeto se ultimo objeto do vetor/*/
							aRet[nObj, nObjIT, 4] := (aRet[nObj, nObjIT, 2] + (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[3]))
						Else
							aRet[nObj, nObjIT, 4] := (aRet[nObj, nObjIT, 2] + (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[5]))
						EndIf

						/*/ Calcula a linha final do objeto /*/
						nAltura := (aADisp[3] - aADisp[1])
						If (nObj == Len(aRet))
							/*/ Calcula a linha final do objeto se ultimo objeto do vetor/*/
							aRet[nObj, nObjIT, 3] := (aRet[nObj, nObjIT, 1] + (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[4]))
						Else
							aRet[nObj, nObjIT, 3] := (aRet[nObj, nObjIT, 1] + (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[5]))
						EndIf
					Else
						/*/ Calcula a linha inicial do objeto /*/
						aRet[nObj, nObjIT, 1] := (aADisp[1] + aObjMar[1])

						/*/ Calcula a coluna inicial do objeto /*/
						aRet[nObj, nObjIT, 2] := (aADisp[2] + aObjMar[2])

						/*/ Calcula a largura do objeto /*/
						nLargura := (aADisp[4] - aADisp[2])
						If (nObjIT == Len(aObjHor[nObj]))
							/*/ Calcula a largura final do objeto se ultimo objeto do vetor/*/
							aRet[nObj, nObjIT, 4] := (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[3])
						Else
							aRet[nObj, nObjIT, 4] := (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[5])
						EndIf

						/*/ Calcula a altura do objeto /*/
						nAltura := (aADisp[3] - aADisp[1])
						If (nObjIT == Len(aObjVer[nObj]))
							/*/ Calcula a altura do objeto se ultimo objeto do vetor/*/
							aRet[nObj, nObjIT, 3] := (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[4])
						Else
							aRet[nObj, nObjIT, 3] := (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[5])
						EndIf
					EndIf
				Else
					If (nTipo == 1)
						/*/ Calcula a linha inicial do objeto /*/
						aRet[nObj, nObjIT, 1] := (aADisp[1] + aObjMar[1])

						/*/ Calcula a coluna inicial do objeto /*/
						aRet[nObj, nObjIT, 2] := (aRet[nObj, (nObjIT - 1), 4] + aObjMar[5])

						/*/ Calcula a coluna final do objeto /*/
						nLargura := (aADisp[4] - aADisp[2])
						If (nObjIT == Len(aObjHor[nObj]))
							/*/ Calcula a coluna final do objeto se ultimo objeto do vetor/*/
							aRet[nObj, nObjIT, 4] := (aRet[nObj, nObjIT, 2] + (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[3]))
						Else
							aRet[nObj, nObjIT, 4] := (aRet[nObj, nObjIT, 2] + (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[5]))
						EndIf

						/*/ Calcula a linha final do objeto /*/
						nAltura := (aADisp[3] - aADisp[1])
						If (nObj == Len(aObjHor))
							/*/ Calcula a linha final do objeto se ultimo objeto do vetor/*/
							aRet[nObj, nObjIT, 3] := (aRet[nObj, nObjIT, 1] + (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[4]))
						Else
							aRet[nObj, nObjIT, 3] := (aRet[nObj, nObjIT, 1] + (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[5]))
						EndIf
					Else
						/*/ Calcula a linha inicial do objeto /*/
						aRet[nObj, nObjIT, 1] := (aADisp[1] + aObjMar[1])

						/*/ Calcula a coluna inicial do objeto /*/
						aRet[nObj, nObjIT, 2] := ((aRet[nObj, (nObjIT - 1), 2] + aRet[nObj, (nObjIT - 1), 4]) + aObjMar[5])

						/*/ Calcula a largura do objeto /*/
						nLargura := (aADisp[4] - aADisp[2])
						If (nObjIT == Len(aObjHor[nObj]))
							/*/ Calcula a coluna final do objeto se ultimo objeto do vetor/*/
							aRet[nObj, nObjIT, 4] := (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[3])
						Else
							aRet[nObj, nObjIT, 4] := (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[5])
						EndIf

						/*/ Calcula a altura do objeto /*/
						nAltura := (aADisp[3] - aADisp[1])
						If (nObj == Len(aObjHor))
							/*/ Calcula a linha final do objeto se ultimo objeto do vetor/*/
							aRet[nObj, nObjIT, 3] := (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[4])
						Else
							aRet[nObj, nObjIT, 3] := (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[5])
						EndIf
					EndIf
				EndIf
			Next
		Else
			For nObjIT := 1 To Len(aRet[nObj])
				If (nObjIT == 1)
					If (nTipo == 1)
						/*/ Calcula a linha inicial do objeto /*/
						aRet[nObj, nObjIT, 1] := (aRet[(nObj - 1), nObjIT, 3] + aObjMar[1])

						/*/ Calcula a coluna inicial do objeto /*/
						aRet[nObj, nObjIT, 2] := (aADisp[2] + aObjMar[2])

						/*/ Calcula a coluna final do objeto /*/
						nLargura := (aADisp[4] - aADisp[2])
						If (nObjIT == Len(aObjHor[nObj]))
							/*/ Calcula a coluna final do objeto se ultimo do vetor /*/
							aRet[nObj, nObjIT, 4] := (aRet[nObj, nObjIT, 2] + (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[3]))
						Else
							aRet[nObj, nObjIT, 4] := (aRet[nObj, nObjIT, 2] + (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[5]))
						EndIf

						/*/ Calcula a linha final do objeto /*/
						nAltura := (aADisp[3] - aADisp[1])
						If (nObj == Len(aObjHor))
							/*/ Calcula a linha final do objeto se ultimo do vetor /*/
							aRet[nObj, nObjIT, 3] := (aRet[nObj, nObjIT, 1] + (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[4]))
						Else
							aRet[nObj, nObjIT, 3] := (aRet[nObj, nObjIT, 1] + (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[5]))
						EndIf
					Else
						/*/ Calcula a linha inicial do objeto /*/
						aRet[nObj, nObjIT, 1] := ((aRet[(nObj - 1), nObjIT, 1] + aRet[(nObj - 1), nObjIT, 3]) + aObjMar[1])

						/*/ Calcula a coluna inicial do objeto /*/
						aRet[nObj, nObjIT, 2] := (aADisp[2] + aObjMar[2])

						/*/ Calcula a largura do objeto /*/
						nLargura := (aADisp[4] - aADisp[2])
						If (nObjIT == Len(aObjHor[nObj]))
							/*/ Calcula a largura do objeto se ultimo do vetor /*/
							aRet[nObj, nObjIT, 4] := (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[3])
						Else
							aRet[nObj, nObjIT, 4] := (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[5])
						EndIf

						/*/ Calcula a altura do objeto /*/
						nAltura := (aADisp[3] - aADisp[1])
						If (nObj == Len(aObjVer[nObj]))
							/*/ Calcula a altura do objeto se ultimo do vetor /*/
							aRet[nObj, nObjIT, 3] := (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[4])
						Else
							aRet[nObj, nObjIT, 3] := (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[5])
						EndIf
					EndIf
				Else
					/*/ Calcula a linha inicial do objeto /*/
					aRet[nObj, nObjIT, 1] := (aRet[(nObj - 1), Len(aRet[(nObj - 1)]), 3] + aObjMar[1])

					If (nTipo == 1)
						/*/ Calcula a coluna inicial do objeto /*/
						aRet[nObj, nObjIT, 2] := (aRet[nObj, (nObjIT - 1), 4] + aObjMar[5])

						/*/ Calcula a coluna final do objeto /*/
						nLargura := (aADisp[4] - aADisp[2])
						If (nObjIT == Len(aObjHor[nObj]))
							/*/ Calcula a coluna final do objeto se ultimo do vetor /*/
							aRet[nObj, nObjIT, 4] := (aRet[nObj, nObjIT, 2] + (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[3]))
						Else
							aRet[nObj, nObjIT, 4] := (aRet[nObj, nObjIT, 2] + (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[5]))
						EndIf

						/*/ Calcula a linha final do objeto /*/
						nAltura := (aADisp[3] - aADisp[1])
						If (nObj == Len(aObjVer[nObj]))
							/*/ Calcula a linha final do objeto se ultimo do vetor /*/
							aRet[nObj, nObjIT, 3] := (aRet[nObj, nObjIT, 1] + (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[4]))
						Else
							aRet[nObj, nObjIT, 3] := (aRet[nObj, nObjIT, 1] + (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[5]))
						EndIf
					Else
						/*/ Calcula a coluna inicial do objeto /*/
						aRet[nObj, nObjIT, 2] := ((aRet[nObj, (nObjIT - 1), 2] + aRet[nObj, (nObjIT - 1), 4]) + aObjMar[5])

						/*/ Calcula a largura do objeto /*/
						nLargura := (aADisp[4] - aADisp[2])
						If (nObjIT == Len(aObjHor[nObj]))
							/*/ Calcula a largura do objeto se ultimo do vetor /*/
							aRet[nObj, nObjIT, 4] := (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[3])
						Else
							aRet[nObj, nObjIT, 4] := (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[5])
						EndIf

						/*/ Calcula a altura do objeto /*/
						nAltura := (aADisp[3] - aADisp[1])
						If (nObj == Len(aObjVer[nObj]))
							/*/ Calcula a altura do objeto se ultimo do vetor /*/
							aRet[nObj, nObjIT, 3] := (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[4])
						Else
							aRet[nObj, nObjIT, 3] := (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[5])
						EndIf
					EndIf
				EndIf
			Next
		EndIf
	Next

Return(aRet)

/*
Calcula fins de semana no periodo X
*/
Static Function GetFds(dI,dF)
	Local Nret := 0

	Di := Datavalida(di)
	Df := Datavalida(df)

	If Di > Df
		dx := Df
		Df := Di
		Di := dx
	Endif
	If !Empty(Di)
		While Di <= Df
	
			cD := Datavalida(di)
			If cD <> di
				nRet++
			Endif
			Di+=1
	
		EndDo
	Endif
	If nRet > 0

	Endif
Return nRet

/*
 Trata usuario real
*/
Static Function GetUserR(cU,cxfil)
	cRet := cU
//cQry += " SELECT AK_USER FROM "+RetSQLName("SAK")+" AK  "
//cQry += " WHERE  BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' AND AK.D_E_L_E_T_ = '' "				
	If cU == '000092'
		www := 0
	Endif
	cApr := Posicione("SY1",3, SuBSTR(cxFil, 1, 2) + "  " + cU,"Y1_XRESP")
	If !Empty(cApr)
		cRet := Posicione("SY1",1,SuBSTR(cxFil,1,2)+"  "+cApr,"Y1_USER")
	Endif

Return cRet

/*
 Retorna data envio WF e ultima aprovacao mapa
*/
//Static Function GetDtCot(cFil, cCot)
Static Function GetDtCot(cFil, cCot, dUApvPed) 
/* Felipe do Nascimento - 01/05/2015 - tratado o problema da falta da data de ultima aprovacao quando
   o pedido nao possuir mapa de cotacao CR_TIPO = MC 
   passando como parametro a ultima aprovacao atribuida na variavel dUApvPed */
	
	Local aRet := {DToC(StoD("")),DToC(StoD(""))}
	
	If (Select('TMPRKN') > 0)
		TMPRKN->(DbCloseArea())
	EndIf
	cQry := 'SELECT CR_EMISSAO, MAX(CR_DATALIB) CR_ULTAPV '
	cQry += 'FROM ' + RetSQLName('SCR') + " WHERE CR_TIPO = 'MC' "
	cQry += "AND CR_FILIAL = '" + cFil + "' "
	cQry += "AND CR_NUM = '" + cCot + "' "
	cQry += "AND D_E_L_E_T_ = '' "
	cQry += 'GROUP BY CR_EMISSAO '
	TcQuery cQry NEW ALIAS 'TMPRKN'
	TMPRKN->(DbGoTop())
	If !TMPRKN->(Eof())

		*'Yttalo P. Martins-INICIO-11/03/15------------------------------------------------'*
		//aRet := { DToC(StoD(TMPRKN->CR_EMISSAO)) ,DToC(StoD(TMPRKN->CR_ULTAPV)) }		
		aRet := { DToC(StoD(TMPRKN->CR_EMISSAO)) ,DToC(StoD(TMPRKN->CR_ULTAPV)),"Sim" }
		*'Yttalo P. Martins-FIM-11/03/15---------------------------------------------------'*
	Else
		*'Yttalo P. Martins-INICIO-11/03/15------------------------------------------------'*
//		aRet := { DToC(StoD(TMPRKN->CR_EMISSAO)) ,DToC(StoD(TMPRKN->CR_ULTAPV)),"N?" }
		*'Yttalo P. Martins-FIM-11/03/15---------------------------------------------------'*
		
    	aRet := { DToC(StoD(TMPRKN->CR_EMISSAO)), dUApvPed,"Nao" } // Felipe do Nascimento - 01/05/2015
	EndIf
	
Return(aRet)

Static Function GetIndPMA(nInd,aKey)
	
	Local nRet := 0
	ntotitsol := 0
	ntotitnf := 0
	cFil :=aKey[1]
	cNumSC :=aKey[2]

	cGrCom := aKey[4]
	cCC := aKey[5]

	If (nInd == 1)
		If (Select('TMPRKNX') > 0)
			TMPRKNX->(DbCloseArea())
		EndIf
		cQry := 'SELECT C1_FILIAL, C1_NUM, sum(C1_QUANT) TOTITSOL , C1_PEDIDO, C1_ITEMPED , C1_EMISSAO '
		cQry += 'FROM ' + RetSQLName('SC1') + ' '
		cQry += "WHERE C1_FILIAL = '" + cfil + "' "
		cQry += "AND C1_NUM = '" + cNumSC + "' "
		cQry += "AND C1_EMISSAO BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
		cQry += "AND D_E_L_E_T_ = ' ' "
		cQry += " group by C1_FILIAL, C1_NUM , C1_PEDIDO, C1_ITEMPED , C1_EMISSAO "
		TcQuery cQry NEW ALIAS 'TMPRKNX'
	
		TMPRKNX->(DbGoTop())
		ntotitsol := 0
		ntotitnf := 0

		While !TMPRKNX->(Eof())
			ntotitsol += TMPRKNX->TOTITSOL

			If (Select('TMPSD1X') > 0)
				TMPSD1X->(DbCloseArea())
			EndIf
			cQry := 'SELECT D1_FILIAL, D1_PEDIDO , sum(D1_QUANT) TOTITSOL '
			cQry += 'FROM ' + RetSQLName('SD1') + ' '
			cQry += "WHERE D1_FILIAL = '" + TMPRKNX->C1_FILIAL + "' "
			cQry += "AND D1_PEDIDO = '"+TMPRKNX->C1_PEDIDO+"' "
			cQry += "AND D1_ITEMPC = '"+TMPRKNX->C1_ITEMPED+"' "
			cQry += "AND D1_DTDIGIT BETWEEN '" +SubSTR(TMPRKNX->C1_EMISSAO,1,6) + "01' AND '" +SubSTR(TMPRKNX->C1_EMISSAO,1,6)+ "32' "
			cQry += "AND D_E_L_E_T_ = '' "
			cQry += 'GROUP BY D1_FILIAL, D1_PEDIDO '
			cQry += 'ORDER BY D1_FILIAL, D1_PEDIDO '
			TcQuery cQry NEW ALIAS 'TMPSD1X'
			TMPSD1X->(DbGoTop())

			While !TMPSD1X->(Eof())
				ntotitnf += TMPRKNX->TOTITSOL
				TMPSD1X->(DbSkip())
			End
			TMPRKNX->(DbSkip())
		End
	ElseIf (nInd == 2)
		ntotitsol := 0
		ntotitnf := 0

		If (Select('TMPSD1X') > 0)
			TMPSD1X->(DbCloseArea())
		EndIf
		cQry := 'SELECT D1_FILIAL, D1_PEDIDO , sum(D1_QUANT) TOTITSOL '
		cQry += 'FROM ' + RetSQLName('SD1') + ' '
		cQry += "WHERE D1_FILIAL = '" + cFil + "' "
		cQry += "AND D1_PEDIDO <> ' ' "
		cQry += "AND D1_CC = '" +cCC + "' "
		cQry += "AND D1_DTDIGIT BETWEEN '" +DToS(MV_PAR03) + "' AND '" +DToS(MV_PAR04)+ "' "
		cQry += "AND D1_FILIAL+D1_PEDIDO+D1_ITEMPC IN ("
	
		cQry += "SELECT C1_FILIAL+C1_NUM+C1_ITEM	 FROM " + RetSQLName('SC1') + "	 "
		cQry += "WHERE C1_EMISSAO BETWEEN '" +DToS(MV_PAR03) + "' AND '" +DToS(MV_PAR04)+ "' "
		cQry += "AND C1_CC = '" +cCC + "' "
		cQry += "AND C1_FILIAL = '" +cFil + "' "
		cQry += "AND C1_USER = '" +cGrcom + "' "
		cQry += "  AND D_E_L_E_T_ = '' "
		cQry += " ) AND D_E_L_E_T_ = '' "
		cQry += 'GROUP BY D1_FILIAL, D1_PEDIDO '
		cQry += 'ORDER BY D1_FILIAL, D1_PEDIDO '
		TcQuery cQry NEW ALIAS 'TMPSD1X'
		TMPSD1X->(DbGoTop())

		While !TMPSD1X->(Eof())
			ntotitnf += TMPRKNX->TOTITSOL
			TMPSD1X->(DbSkip())
		End

		If (Select('TMPRKNX') > 0)
			TMPRKNX->(DbCloseArea())
		EndIf

		cQry := " SELECT C1_QUANT	 FROM " + RetSQLName('SC1') + " WHERE	"
		cQry += " C1_CC = '" +cCC + "'  "
		cQry += "AND C1_USER = '" +cGrcom + "'  "
		cQry += "AND C1_PEDIDO = ' '  "
		cQry += "  AND D_E_L_E_T_ = '' "
		TcQuery cQry NEW ALIAS 'TMPRKNX'
	
		TMPRKNX->(DbGoTop())
		While !TMPRKNX->(Eof())
			ntotitsol += TMPRKNX->C1_QUANT
			TMPRKNX->(DbSkip())
		End
	EndIf

	If (nTotitsol > 0)
		nRet := (nTotitnf / ntotitsol)*100
	EndIf

Return(nRet)
