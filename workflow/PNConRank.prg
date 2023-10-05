#Include 'totvs.ch'
#Include 'topconn.ch'

/*
*****************************************************************************************************
*** Funcao: PNCONRKN   -   Autor: Leonardo Pereira   -   Data:                                    ***
*** Descricao: Consulta do status do ranking dos mapas de cotacao.                                ***
*****************************************************************************************************
*/
User Function PNConRkn(cAlias, nReg, nOpcx, cTipoDoc)

	Local aArea := GetArea()
	Local cHelpApv  := ''
	//Local cAliasSCR := 'TMP'
	Local cComprador := ''
	Local cSituaca := ''
	Local cTitle := ''
	Local cTitDoc := ''

	Local lBloq := .F.
	Local n := 0
	Local nX := 0
	Local nY := 0
	Local oDlg
	Local oGet
	Local oBold
	Local cStatus  := 'AGUARDANDO RANKING'
	Local cX3_TITULO  := ""
	Local cX3_CAMPO   := ""
	Local cX3_PICTURE := ""
	Local cX3_TAMANHO := ""
	Local cX3_DECIMAL := ""
	Local cX3_VALID   := ""
	Local cX3_USADO   := ""
	Local cX3_TIPO    := ""
	Local cX3_F3      := ""
	Local cX3_CONTEXT := ""
	//Local cX3_CBOX    := ""
	//Local cX3_RELACAO := ""


	//Local cQuery := ''
	Local aStruSCR := {}
	Local lLiber := .T.
	Local x := 0
	Default cTipoDoc := 'MC'
	Default cCampo := ""

	nRecSC8 := SC8->(Recno())
	cNumSC8 := SC8->C8_NUM
	cTitle := 'Ranking do Mapa de Cotacao'
	cTitDoc := 'Cotacao'
	cHelpApv := 'Este mapa de cotacao nao possui controle de ranking.'
	cComprador:= UsrRetName(SC8->C8_XUSER)
		
	/*/ Realiza o ranking do mapa de cotacao /*/
	SCR->(DbGoTop())
	SCR->(DbSetOrder(2))
	If SCR->(DbSeek(xFilial('SCR') + 'MC' + cNumSC8 + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))))
		SCR->(DbSetOrder(1))
		While SCR->(!Eof()) .And. (AllTrim(SCR->CR_NUM) == cNumSC8)
			If (SCR->CR_STATUS == '02')
				lLiber := .F.
			EndIf
			SCR->(DbSkip())
		End
	EndIf
	 
	/*/ Posiciona na tabela de cotacoes /*/
	SC8->(DbGoTop())
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(xFilial('SC8') + cNumSC8))
	While SC8->(!Eof()) .And. (SC8->C8_NUM == cNumSC8)
		RecLock('SC8', .F.)
		SC8->C8_CONAPRO := If(lLiber, 'L', 'B')
		SC8->(MsUnLock())
		SC8->(DbSkip())
	End
	
	SC8->(DbGoTop())
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(xFilial('SC8') + cNumSC8))
	While SC8->(!Eof()) .And. (SC8->C8_NUM == cNumSC8)
		If (cTipoDoc == 'MC')
			If (SC8->C8_CONAPRO == 'L')
				cStatus := 'COTACAO RANKEADA'
				Exit
			EndIf
		EndIf
		SC8->(DbSkip())
	End	
	SC8->(DbGoTo(nRecSC8))
	
	If !Empty(cNumSC8)
		aHeader:= {}
		aCols  := {}
					aSX3 := FWSX3Util():GetAllFields("SCR",.T.)

						For nX := 1	to Len(aSX3)

								cX3_USADO 	:= GetSx3Cache(aSX3[nX],"X3_USADO")
								cX3_NIVEL 	:= GetSx3Cache(aSX3[nX],"X3_NIVEL")
								cX3_CAMPO 	:= GetSx3Cache(aSX3[nX],"X3_CAMPO")
								cX3_TITULO 	:= GetSx3Cache(aSX3[nX],"X3_TITULO")
								cX3_PICTURE	:= GetSx3Cache(aSX3[nX],"X3_PICTURE")
								cX3_TAMANHO := GetSx3Cache(aSX3[nX],"X3_TAMANHO")
								cX3_DECIMAL := GetSx3Cache(aSX3[nX],"X3_DECIMAL")
								cX3_VALID 	:= GetSx3Cache(aSX3[nX],"X3_VALID")
								cX3_TIPO	:= GetSx3Cache(aSX3[nX],"X3_TIPO")
								cX3_F3		:= GetSx3Cache(aSX3[nX],"X3_F3")
								cX3_CONTEXT	:= GetSx3Cache(aSX3[nX],"X3_CONTEXT")

								If AllTrim(cX3_CAMPO) $ 'CR_NIVEL/CR_OBS/CR_DATALI'
									aAdd(aHeader,{Trim(cX3_TITULO),;
									cX3_CAMPO  ,;
									cX3_PICTURE,;
									cX3_TAMANHO,;
									cX3_DECIMAL,;
									cX3_VALID  ,;
									cX3_USADO  ,;
									cX3_TIPO   ,;
									cX3_F3     ,;
									cX3_CONTEXT})
						 		EndIf
								If (AllTrim(cX3_CAMPO) == 'CR_NIVEL')
									aAdd(aHeader, {'Usuario', 'CR_NOME', '', 15, 0, '', '', 'C', '', ''})
									aAdd(aHeader, {'Situacao', 'CR_SITUACA', '', 20, 0, '', '', 'C', '', ''})
									aAdd(aHeader, {'Usuario Lib.', 'CR_NOMELIB', '', 15, 0, '', '', 'C', '', ''})
								EndIf
						next	
		/*/ Faz a montagem do aHeader com os campos fixos. /*/
		/*SX3->(DbGoTop())
		SX3->(DbSetOrder(1))
		SX3->(MsSeek('SCR'))
		While !Eof() .And. (SX3->X3_ARQUIVO == 'SCR')
			If AllTrim(SX3->X3_CAMPO) $ 'CR_NIVEL/CR_OBS/CR_DATALIB'
				aAdd(aHeader, {AllTrim(X3Titulo()), SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, SX3->X3_USADO, SX3->X3_TIPO, SX3->X3_ARQUIVO, SX3->X3_CONTEXT})
				If (AllTrim(SX3->X3_CAMPO) == 'CR_NIVEL')
					aAdd(aHeader, {'Usuario', 'CR_NOME', '', 15, 0, '', '', 'C', '', ''})
					aAdd(aHeader, {'Situacao', 'CR_SITUACA', '', 20, 0, '', '', 'C', '', ''})
					aAdd(aHeader, {'Usuario Lib.', 'CR_NOMELIB', '', 15, 0, '', '', 'C', '', ''})
				EndIf
			EndIf
			SX3->(DbSkip())
		EndDo*/
		aAdd(aHeader, {'1o Colocado', 'CR_RKN1', '', 09, 0, '', '', 'C', '', ''})
		aAdd(aHeader, {'2o Colocado', 'CR_RKN2', '', 09, 0, '', '', 'C', '', ''})
		aAdd(aHeader, {'3o Colocado', 'CR_RKN3', '', 09, 0, '', '', 'C', '', ''})
		aAdd(aHeader, {'4o Colocado', 'CR_RKN4', '', 09, 0, '', '', 'C', '', ''})
		aAdd(aHeader, {'5o Colocado', 'CR_RKN5', '', 09, 0, '', '', 'C', '', ''})

		aDHeadRec('SCR', aHeader)
		aStruSCR := SCR->(DbStruct())
		cTipoDoc := 'MC'
			
		For nX := 1 To Len(aStruSCR)
			If (aStruSCR[nX, 2] <> 'C')
				TcSetField('SCR', aStruSCR[nX, 1], aStruSCR[nX, 2], aStruSCR[nX, 3], aStruSCR[nX, 4])
			EndIf
		Next
		
		/*/ Realiz o ranking do mapa de cotacao /*/
		SCR->(DbGoTop())
		SCR->(DbSetOrder(2))
		If SCR->(DbSeek(xFilial('SCR') + 'MC' + SC8->C8_NUM + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))))
			While !SCR->(Eof()) .And. (SCR->CR_FILIAL + SCR->CR_TIPO + SubStr(SCR->CR_NUM, 1, Len(SC8->C8_NUM)) == xFilial('SCR') + cTipoDoc + cNumSC8)
				aAdd(aCols, Array(Len(aHeader) + 1))
				nY++
				For nX := 1 To Len(aHeader)
					If (nX == 1)
						aCols[nY, nX] := SCR->CR_NIVEL
					ElseIf (nX == 2)
						aCols[nY, nX] := UsrRetName(SCR->CR_USER)
					ElseIf(nX == 3)
						Do Case
						Case (SCR->CR_STATUS == '02')
							cSituaca := 'Aguardando'
						Case (SCR->CR_STATUS == '03')
							cSituaca := 'Rankeado'
						Case (SCR->CR_STATUS == '05')
							cSituaca := 'Nivel Liberado'
						Case (SCR->CR_STATUS == '04')
							cSituaca := 'Rejeitado'
						EndCase
						aCols[nY, nX] := cSituaca
					ElseIf (nX == 4)
						aCols[nY, nX] := UsrRetName(SCR->CR_USERLIB)
					ElseIf (nX == 5)
						aCols[nY, nX] := SCR->CR_DATALIB
					ElseIf (nX == 6)
						aCols[nY, nX] := SCR->CR_OBS
					ElseIf (nX == 7)
						aCols[nY, nX] := SCR->CR_RKN1
					ElseIf (nX == 8)
						aCols[nY, nX] := SCR->CR_RKN2
					ElseIf (nX == 9)
						aCols[nY, nX] := SCR->CR_RKN3
					ElseIf (nX == 10)
						aCols[nY, nX] := SCR->CR_RKN4
					ElseIf (nX == 11)
						aCols[nY, nX] := SCR->CR_RKN5
					ElseIf (nX == 12)
						aCols[nY, nX] := 'SCR'
					ElseIf (nX == 13)
						aCols[nY, nX] := SCR->(Recno())
					EndIf
				Next
				aCols[nY, Len(aHeader)+1] := .F.
				SCR->(DbSkip())
			End
			
			/*/ Organiza o aCols por Nivel /*/
			aSort(aCols,,, { |x,y| x[1] < y[1]})
		
			If !Empty(aCols)
				If lBloq
					cStatus := 'Bloqueado'
				EndIf
				n := If((n > Len(aCols)), Len(aCols), n)  /*/ Feito isto p/evitar erro fatal(Array out of Bounds). /*/
				Define FONT oBold NAME 'Arial' SIZE 0, -12 BOLD
				Define MsDialog oDlg TITLE cTitle From 109,095 To 400,600 OF oMainWnd PIXEL
				@ 005,003 TO 032,250 LABEL '' OF oDlg PIXEL
				@ 015,007 SAY cTitDoc OF oDlg FONT oBold PIXEL SIZE 046,009
				@ 014,041 MSGET cNumSC8 PICTURE '' WHEN .F. PIXEL SIZE 050,009 OF oDlg FONT oBold
				If (cTipoDoc <> 'NF')
					@ 015,103 SAY 'Comprador' OF oDlg PIXEL SIZE 033,009 FONT oBold
					@ 014,138 MSGET cComprador PICTURE '' WHEN .F. of oDlg PIXEL SIZE 103,009 FONT oBold
				EndIf
				@ 132,008 SAY 'Situacao:' OF oDlg PIXEL SIZE 052,009
				@ 132,038 SAY cStatus OF oDlg PIXEL SIZE 120,009 FONT oBold
				@ 132,205 BUTTON 'Fechar' SIZE 035 ,010  FONT oDlg:oFont Action(oDlg:End()) OF oDlg PIXEL
				oGet := MsGetDados():New(038, 003, 120, 250, nOpcx,,, '')
				oGet:Refresh()
				@ 126,002 TO 127,250 LABEL '' OF oDlg PIXEL
				Activate MsDialog oDlg Centered
			Else
				Aviso('Atencao', cHelpApv, {'Voltar'})
			EndIf
		Else
			Aviso('Atencao', cHelpApv, {'Voltar'})
		EndIf
	EndIf

	DbSelectArea(cAlias)
	RestArea(aArea)

Return
