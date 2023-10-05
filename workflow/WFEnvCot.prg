#Include 'totvs.ch'
#Include 'rwmake.ch'
#Include 'topconn.ch'
#Include 'tbiconn.ch'
#Include 'tbicode.ch'
#Include 'ap5mail.ch'
#Include 'fileio.ch'
#INCLUDE "PROTHEUS.CH"
#DEFINE NTRYSEND 5

/*
****************************************************************************************************
*** Funcao: PNENVWF   -   Autor: Leonardo Pereira   -   Data:                                    ***
*** Descricao:                                                                                   ***
****************************************************************************************************
*/
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAutoLË+LË+¿
//³Autor: Yttalo P. Martins                                ³
//³Data: 13/03/15                                          ³
//³Gestão da permissao de envio do workflow quando da falha³ 
//e quando do tamanho do arquivo apos transferencia        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAutoÙ
ENDDOC*/
User Function PNEnvWF(cNivAtu, nExec)

	Local lRet := 0
	Local cQry := ''
	Local oFont2 := TFont():New('Courier New', Nil, 14, Nil, .F., Nil, Nil, Nil, Nil, .F., .F.)
	Local oFont3 := TFont():New('Verdana', Nil, 18, Nil, .F., Nil, Nil, Nil, Nil, .F., .F.)
	Local aAreaSC1 := SC1->(GetArea())
	Local aAreaSC8 := SC8->(GetArea())
	Local _lRet := .T.

	Private oDlg1
	Private nTime := 1
	Private cHTML := ''
	Private cINFO := ''
	Private cArqHTM := ''
	Private cArqINF := ''
	Private aArqRkn := {}
	Private WFProcessID := ''
	Private cProdAval := ''
	Private lEnd := .F.
	Private cMsgComp := Space(150)
	Private cEOL := Chr(13) + Chr(10)
	Private cNumCOT := SC8->C8_NUM
	Private cFilCOT := AllTrim(SC8->C8_FILIAL)
	Private cNextNiv := 0
	Private oProcess
	Private nK := 0
	Private nY := 0
	Private nX := 0
	Private lAmbProd := (Upper(AllTrim(GetEnvServer())) $ AllTrim(GetMV('MV_XAMBIEN')))
	Private cCodUser

	/*/ Codigo extraido do cadastro de processos. /*/
	Private cCodProcesso := 'WFRKMC'

	/*/ Assunto da mensagem /*/
	Private cAssunto := 'Ranking da cotacao de compras'
	Private cHost := ''

	Default cNivAtu := 0
	Default nExec := 1

	/*/ Verifica o codigo de usuario do comprador responsavel /*/
	SY1->(DbSetOrder(3))
	If SY1->(DbSeek(xFilial('SY1') + If((nExec == 1), __cUserID, aDadosTxt[1, 8])))
		cCodUser := SY1->Y1_USER

		/*
		If !(Empty(SY1->Y1_XRESP))
			SY1->(DbSetOrder(1))
			If SY1->(DbSeek(xFilial('SY1') + SY1->Y1_XRESP))
				cCodUser := SY1->Y1_USER
			EndIf
		Else
		*/
		//EndIf                    

	Else

		IF !l150Auto
			MsgAlert('Usuario nao e comprador. Rotina cancelada!', 'Atencao!')
		ELSE
			u_xConOut(Repl("-",80))
			u_xConOut('Usuario nao e comprador. Rotina cancelada!')
			u_xConOut(Repl("-",80))			
		ENDIF									

		Return	
	EndIf

	If lAmbProd
		cHost := 'http://centraldeaprovacao.portonovosa.com/portalcompras/' //'http://compras.portonovosa.com.br/workflow/'
	Else
		//cHost := 'https://centraldeaprovacao.portonovosa.com/portalcomprashomolog/'
		cHost := 'https://centraldeaprovacao.portonovosa.com/portalcomprasteste/'

	EndIf


	/*/ Verifica se j? foi enviado /*/
	If (nExec == 1)
		If !(Empty(SC8->C8_FLAGWF))
			MsgAlert('Workflow ja enviado para esta cotacao!', 'Atencao!')
			Return
		EndIf
	EndIf

	/*/ Verifica se a cotacao teve algum item atualizado /*/
	If (nExec == 1)
		If (Select('WFVALCT') > 0)
			WFVALCT->(DbCloseArea())
		EndIf
		cQry := 'SELECT COUNT(*) TOTREG '
		cQry += 'FROM ' + RetSQLName('SC8') + ' SC8 '
		cQry += 'WHERE SC8.C8_PRECO = 0'
		cQry += "AND SC8.C8_NUM = '" + cNumCOT + "' "
		cQry += "AND SC8.C8_FILIAL = '" + cFilCOT + "' "
		cQry += "AND SC8.D_E_L_E_T_ = '' "
		TCQuery cQry New ALIAS 'WFVALCT'
		WFVALCT->(DbGoTop())
		If (WFVALCT->TOTREG > 0)
			MsgAlert('Cotacao nao foi TOTALMENTE ATUALIZADA, nao e possivel enviar o Workflow', 'Atencao!')
			Return
		Else
			/*/ Gera os controles de aprovacao do mapa de cotacao /*/
			MsgRun('P R O C E S S A N D O   C O N T R O L E   DE   A L C A D A. . .', 'A g u a r d e...', { |lEnd| WFGAprCot() })
		EndIf

		If (Select('WFVALCT') > 0)
			WFVALCT->(DbCloseArea())
		EndIf
		cQry := 'SELECT COUNT(*) TOTREG '
		cQry += 'FROM ' + RetSQLName('SC8') + ' SC8 '
		cQry += "WHERE SC8.C8_VALIDA < '" + DtoS(dDataBase) + "' "
		cQry += "AND SC8.C8_NUM = '" + cNumCOT + "' "
		cQry += "AND SC8.C8_FILIAL = '" + cFilCOT + "' "
		cQry += "AND SC8.D_E_L_E_T_ = '' "
		TCQuery cQry New ALIAS 'WFVALCT'
		WFVALCT->(DbGoTop())
		If (WFVALCT->TOTREG > 0)
			MsgAlert('Cotacao esta EXPIRADA, nao e possivel enviar o Workflow', 'Atencao!')
			Return
		EndIf
	EndIf

	/*/ Pergunta se o usu?rio realmente deseja enviar o workflow /*/
	If (nExec == 1)
		If !(MsgYesNo('Deseja realmente enviar o WORKFLOW, para a cotacao: ' + cNumCOT, 'WORKFLOW'))
			Return
		EndIf
	EndIf

	If (nExec == 1)
		/*/ Dialog para digitacao da mensagem do comprador /*/
		oDlg1 := MsDialog():New(000, 000, 250, 450, 'O B S E R V A C O E S',,,,,,,,, .T.)
		oGrp1 := TGroup():New(005, 002, 093, 225,' Observacoes do Comprador ', oDlg1,,, .T.)
		//		oTMultiGet1 := TMultiGet():New(013, 006, {|u| If((PCount() > 0), cMsgComp := u, cMsgComp)}, oGrp1, 215, 075, oFont3, .F., RGB(000,000,000), RGB(255,255,255),, .T.,,, {|u| },,, .F., {|u| PNValObs() },,, .F., .T.)
		oTMultiGet1 := TMultiGet():New(013, 006, {|u| If((PCount() > 0), cMsgComp := u, cMsgComp)}, oGrp1, 215, 075, oFont3, .F., RGB(000,000,000), RGB(255,255,255),, .T.,,, {|u| },,, .F.,                ,,, .F., .T.)
		/*/ Botoes /*/
		//		oBtn1 := SButton():New(098, 168, 01, {|u|  Iif(EnvCotVal(),{ lRet := 1, oDlg1:End()},Alert("O valor total, somado ao frete ultrapassa R$ 500,00, por favor informe uma observação!") ) }, oDlg1, .T., 'Ok',)

		oBtn1 := SButton():New(098, 168, 01, {|u|  Iif(PnValOBS(),{ lRet := 1, oDlg1:End()},{ lRet := 2 } ) }, oDlg1, .T., 'Ok',)

		//		oBtn1 := SButton():New(098, 168, 01, {|u| lRet := 1, oDlg1:End() }, oDlg1, .T., 'Ok',)
		oBtn2 := SButton():New(098, 198, 02, {|u| lRet := 2, oDlg1:End()}, oDlg1, .T., 'Cancelar',)
		/*/ Barra de Status /*/
		oTMsgBar1 := TMsgBar():New(oDlg1, 'Totvs 2013 Serie T',,,,, RGB(255,255,255),, oFont2, .F., '')
		/*/ Cria itens na barra de status /*/
		oTMsg1 := TMsgItem():New(oTMsgBar1, Time(), 100,,,,.T., {|u| MsgAlert('Data: ' + Dtoc(dDataBase) + Chr(13) + 'Hora: ' + Time()), oTMsgBar1:Refresh()})
		/*/ Cria o relogio na barra de status da dialog /*/
		oTTimer1 := TTimer():New(nTime,, oDlg1)
		oTTimer1:bAction := {|u| oTMsg1:SetText(Time())}
		oTTimer1:lActive := .T.
		oTTimer1:Activate()

		oDlg1:Activate(,,, .T.,,,)

		If (lRet == 1)
			Processa({ |lEnd| WFGeraRank(cNivAtu, nExec, @_lRet) }, 'WORKFLOW', 'P R O C E S S A N D O    D A D O S . . .', .F.)

			*'Yttalo P. Martins 13/03/15-INICIO--------------------------------------------------------'*
			If _lRet
				*'Yttalo P. Martins 13/03/15-FIM-----------------------------------------------------------'*			

				/*/ Grava a ID do processo de workflow gerado nos registros da cotacao /*/
				SC8->(DbGoTop())
				SC8->(DbSetOrder(1))
				SC8->(DbSeek(xFilial('SC8') + cNumCOT))
				While !SC8->(Eof()) .And. (xFilial('SC8') == SC8->C8_FILIAL .And. cNumCOT == SC8->C8_NUM)
					SC8->(RecLock('SC8', .F.))
					SC8->C8_WFID := "WFID" //WFProcessID
					SC8->C8_FLAGWF := '1'
					SC8->C8_XUSER := cCodUser			// Codigo do usuario
					SC8->C8_XOBSCOT := AllTrim(cMsgComp) //AllTrim(SC8->C8_XOBSCOT)+" "+AllTrim(cMsgComp)
					SC8->(MsUnLock())
					SC8->(DbSkip())
				End

				SC8->(DbGoTop())
				SC8->(DbSetOrder(1))                                  
				SC8->(DbSeek(xFilial('SC8') + cNumCOT))

				SCR->(DbGoTop())
				SCR->(DbSetOrder(2))
				//				If SCR->(DbSeek(xFilial('SCR') + 'MC' + SC8->C8_NUM + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))))
				//					While !SCR->(Eof()) .And. (SCR->CR_TIPO == 'MC') .And. (AllTrim(SCR->CR_NUM) == cNumCOT)
				If SCR->(DbSeek(xFilial('SCR') + 'MC' + SC8->C8_NUM + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))+SC8->C8_XUSER))
					While !SCR->(Eof()) .And. (SCR->CR_TIPO == 'MC') .And. (AllTrim(SCR->CR_NUM) == cNumCOT) .AND. (SCR->CR_USER == SC8->C8_XUSER)		
						RecLock('SCR', .F.)
						SCR->CR_WFID := SC8->C8_WFID
						SCR->(MsUnLock())
						SCR->(DbSkip())
					End
				EndIf

				*'Yttalo P. Martins 13/03/15-INICIO--------------------------------------------------------'*
			EndIf
			*'Yttalo P. Martins 13/03/15-FIM-----------------------------------------------------------'*			

		EndIf

	Else

		WFGeraRank(cNivAtu, nExec, @_lRet)

		*'Yttalo P. Martins 13/03/15-INICIO--------------------------------------------------------'*
		If _lRet
			*'Yttalo P. Martins 13/03/15-FIM-----------------------------------------------------------'*					

			/*/ Grava a ID do processo de workflow gerado nos registros da cotacao /*/
			SC8->(DbGoTop())
			SC8->(DbSetOrder(1))
			SC8->(DbSeek(xFilial('SC8') + cNumCOT))
			While !SC8->(Eof()) .And. (xFilial('SC8') == SC8->C8_FILIAL .And. cNumCOT == SC8->C8_NUM)
				SC8->(RecLock('SC8', .F.))
				SC8->C8_WFID := "WFID" //WFProcessID
				SC8->C8_FLAGWF := '1'
				SC8->(MsUnLock())
				SC8->(DbSkip())
			End

			*'Yttalo P. Martins 13/03/15-INICIO--------------------------------------------------------'*
		EndIf
		*'Yttalo P. Martins 13/03/15-FIM-----------------------------------------------------------'*					

	EndIf

	RestArea(aAreaSC1)
	RestArea(aAreaSC8)

Return  


Static Function EnvCotVal()
	Local lVRet := .T.    
	Local nMaxVlr := 0                    
	Local nFornecs := 0
	If (Select('WFMAXVLVAL') > 0)
		WFMAXVLVAL->(DbCloseArea())
	EndIf
	cQry := 'SELECT SUM(C8_TOTAL+C8_TOTFRE) C8_TOTAL '
	cQry += 'FROM ' + RetSQLName('SC8') + ' '
	cQry += "WHERE C8_NUM = '" + cNumCOT + "' "
	cQry += "AND C8_FILIAL = '" + cFilCOT + "' and D_E_L_E_T_ = ' ' "
	cQry += 'GROUP BY C8_FORNECE, C8_LOJA '
	TCQuery cQry New ALIAS 'WFMAXVLVAL'
	WFMAXVLVAL->(DbGoTop())
	While !WFMAXVLVAL->(Eof())
		/*/ Gera codigo do formulario HTML, para os ITENS do pedido/*/
		If WFMAXVLVAL->C8_TOTAL  > nMaxVlr
			nMaxVlr := WFMAXVLVAL->C8_TOTAL  
		Endif

		nFornecs++

		WFMAXVLVAL->(Dbskip())	

	EndDo

	iF nMaxVlr > 500 .AND. nFornecs == 1 .AND. Empty(cMsgComp)
		lVRet := .F. //obriga a informar msg	
		MsgAlert("O valor total, somado ao frete ultrapassa R$ 500,00, por favor informe uma observação!")
	Endif

Return lVRet


/*
************************************************************************************************************************************
*** Funcao: GERAWFRANK   -   Autor: Leonardo Pereira   -   Data: 01/11/2010                                                      ***
*** Descricao:                                                                                                                   ***
************************************************************************************************************************************
*/
Static Function WFGeraRank(cNivAtu, nExec, _lRet)

	Local nMaxVlr := 0
	Local lFirst := .T.
	Local nX :=0
	Private aEMail := {}
	Private aCodFor := {}
	Private nTotDesc := 0
	Private nTotIpi := 0
	Private nTotFrt := 0
	Private nTotIT := 0
	Private nTotPed := 0
	Private nTUltCpm := 0
	Private cCCusto := ''

	SC8->(DbGoTop())
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(xFilial('SC8') + cNumCOT))

	cCodFor := SC8->C8_FORNECE
	cLojFor := SC8->C8_LOJA
	cFilEnt := SC8->C8_FILENT
	cFilPag := SC8->C8_FILIAL
	cTipFre := SC8->C8_TPFRETE

	/*/ Coleta dados do(s) aprovador(es) /*/
	If (nExec == 1)
		/*
		SC8->(DbGoTop())
		SC8->(DbSetOrder(1))
		SC8->(DbSeek(xFilial('SC8') + cNumCOT))
		nValX := SC8->C8_TOTAL+SC8->C8_TOTFRE

		SCR->(DbGoTop())
		SCR->(DbSetOrder(2))
		If SCR->(DbSeek(xFilial('SCR') + 'MC' + SC8->C8_NUM + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))))
		While !SCR->(Eof()) .And. (SCR->CR_TIPO == 'MC') .And. (AllTrim(SCR->CR_NUM) == cNumCOT)

		If !MaAlcLim(SCR->CR_APROV,nValX ) .AND. (SCR->CR_STATUS <> "03" .AND. SCR->CR_STATUS <> "04") //,nMoeda,nTaxa)
		RecLock('SCR', .F.)
		DbDelete()				
		SCR->(MsUnLock())
		EndIf
		SCR->(DbSkip())
		EndDo
		EndIf
		*/

		SCR->(DbGoTop())
		SCR->(DbSetOrder(1))
		If SCR->(DbSeek(xFilial('SCR') + 'MC' + cNumCOT))
			cNivel := Val(SCR->CR_NIVEL)
			While !SCR->(Eof()) .And. (xFilial('SCR') + 'MC' + cNumCOT == SCR->CR_FILIAL + SCR->CR_TIPO + AllTrim(SCR->CR_NUM)) .And. (Val(SCR->CR_NIVEL) == cNIvel)
				SAK->(DbSetOrder(1))
				SAK->(DbSeek(xFilial('SAK') + SCR->CR_APROV))

				/*/ Coleta informacoes do usuario /*/
				PswOrder(1)
				If (PswSeek(AllTrim(SAK->AK_USER), .T.))
					aInfoUsu := PswRet(1)
					//aAdd(aEMail, {AllTrim(aInfoUsu[1, 14]), SAK->AK_COD, AllTrim(SAK->AK_NOME), SAK->AK_USER})
					//PARA TESTES
					aAdd(aEMail, {AllTrim(aInfoUsu[1, 14]), SAK->AK_COD, AllTrim(SAK->AK_NOME), SAK->AK_USER})
				EndIf
				SCR->(DbSkip())
			End
		EndIf
	ElseIf (nExec == 2)
		SCR->(DbGoTop())
		SCR->(DbSetOrder(1))
		If SCR->(DbSeek(xFilial('SCR') + 'MC' + cNumCOT))
			lFirst := .T.
			While !SCR->(Eof()) .And. (xFilial('SCR') + 'MC' + cNumCOT == SCR->CR_FILIAL + SCR->CR_TIPO + AllTrim(SCR->CR_NUM))
				If lFirst
					If (Val(SCR->CR_NIVEL) > cNivAtu) .And. Empty(SCR->CR_DATALIB)
						cNextNiv := Val(SCR->CR_NIVEL)
						lFirst := .F.

						SAK->(DbSetOrder(1))
						SAK->(DbSeek(xFilial('SAK') + SCR->CR_APROV))

						/*/ Coleta informacoes do usuario /*/
						PswOrder(1)
						If (PswSeek(AllTrim(SAK->AK_USER), .T.))
							aInfoUsu := PswRet(1)
							//aAdd(aEMail, {AllTrim(aInfoUsu[1,14]), SAK->AK_COD, AllTrim(SAK->AK_NOME), SAK->AK_USER})
							//PARA TESTES
							aAdd(aEMail, {AllTrim(aInfoUsu[1, 14]), SAK->AK_COD, AllTrim(SAK->AK_NOME), SAK->AK_USER})
						EndIf
					EndIf
				Else
					If (Val(SCR->CR_NIVEL) == cNextNiv) .And. Empty(SCR->CR_DATALIB)
						SAK->(DbSetOrder(1))
						SAK->(DbSeek(xFilial('SAK') + SCR->CR_APROV))

						/*/ Coleta informacoes do usuario /*/
						PswOrder(1)
						If (PswSeek(AllTrim(SAK->AK_USER), .T.))
							aInfoUsu := PswRet(1)
							//aAdd(aEMail, {AllTrim(aInfoUsu[1,14]), SAK->AK_COD, AllTrim(SAK->AK_NOME), SAK->AK_USER})
							//PARA TESTES
							aAdd(aEMail, {AllTrim(aInfoUsu[1, 14]), SAK->AK_COD, AllTrim(SAK->AK_NOME), SAK->AK_USER})
						EndIf
					EndIf
				EndIf
				SCR->(DbSkip())
			End
		EndIf
	EndIf

	/*/ Faz verificacao do e-mail e gera os processos /*/
	If (nExec == 1)
		ProcRegua(0)
	EndIf

	*'Yttalo P. Martins 13/03/15-INICIO--------------------------------------------------------'*
	/*
	For nX := 1 To Len(aEMail)
	cINFO := ''
	If (nExec == 1)
	IncProc('Gerando E-mail para o(s) gestor(es)...')
	Else
	u_xConOut('Gerando E-mail para o(s) gestor(es)...')
	EndIf

	// Gera codigo do formulario HTML.
	CSGerFor(0, nExec, cNextNiv)

	// Gera codigo do formulario HTML, para o quadro de rankin anterior
	aAAntSAK := SAK->(GetArea())
	aAAntSC8 := SC8->(GetArea())
	aAAntSCR := SCR->(GetArea())


	SC8->(DbGoTop())
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(xFilial('SC8') + cNumCOT))

	SCR->(DbGoTop())
	SCR->(DbSetOrder(2))
	If SCR->(DbSeek(xFilial('SCR') + 'MC' + SC8->C8_NUM + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))))
	While !SCR->(Eof()) .And. (SCR->CR_TIPO == 'MC') .And. (AllTrim(SCR->CR_NUM) == SC8->C8_NUM)
	If (SCR->CR_STATUS == '03')
	CSGerFor(1, nExec, cNextNiv)
	EndIf
	SCR->(DbSkip())
	End
	EndIf

	RestArea(aAAntSAK)
	RestArea(aAAntSC8)
	RestArea(aAAntSCR)

	// Gera codigo do formulario HTML, para o cabe?alho do pedido
	CSGerFor(2, nExec, cNextNiv)

	// Zera as variaveis de totais, para novo acumulo
	nTotPed := nTotIT := nTotDesc := nTotIpi := nTotFrt := 0

	// Assinala novos valores para os itens do pedido //
	cStrFor := ''
	For nY := 1 To Len(aCodFor)
	cStrFor += '[' + aCodFor[nY,1] + '],'
	Next

	nCodFor := (5 - Len(aCodFor))
	For nY := 1 To nCodFor
	If (nY == 1)
	cStrFor += '[A],'
	aAdd(aCodFor, {'A',1})
	ElseIf (nY == 2)
	cStrFor += '[B],'
	aAdd(aCodFor, {'B',1})
	ElseIf (nY == 3)
	cStrFor += '[C],'
	aAdd(aCodFor, {'C',1})
	ElseIf (nY == 4)
	cStrFor += '[D],'
	aAdd(aCodFor, {'D',1})
	EndIf
	Next
	cStrFor := SubStr(cStrFor, 1, (Len(cStrFor) - 1))

	If (Select('WFITENS') > 0)
	WFITENS->(DbCloseArea())
	EndIf
	cQry := 'SELECT C8_FILIAL, C8_ITEM, C8_QUANT, C8_UM, C8_PRODUTO, ' + cStrFor + ', C8_NUMSC, C8_ITEMSC '
	cQry += "FROM (SELECT DISTINCT C8_FILIAL, C8_ITEM, C8_QUANT, C8_UM, C8_PRODUTO, C8_PRECO, ('C8_'+C8_FORNECE+C8_LOJA) FORNECE, C8_NUMSC, C8_ITEMSC "
	cQry += ' FROM ' + RetSQLName('SC8') + ' SC8 '
	cQry += " WHERE SC8.C8_NUM = '" + cNumCOT + "' "
	cQry += " AND SC8.C8_FILIAL = '" + cFilCOT + "' "
	cQry += " AND SC8.D_E_L_E_T_ = '') AS SOURCEPVT "
	cQry += 'PIVOT (SUM(C8_PRECO) FOR FORNECE IN(' + cStrFor + ')) AS PVT '
	cQry += "WHERE C8_FILIAL = '" + cFilCOT + "' "
	cQry += 'ORDER BY PVT.C8_ITEM '
	TCQuery cQry New ALIAS 'WFITENS'
	WFITENS->(DbGoTop())
	While !WFITENS->(Eof())
	// Gera codigo do formulario HTML, para os ITENS do pedido
	CSGerFor(3, nExec, cNextNiv)
	WFITENS->(DbSkip())
	End

	SC8->(DbGoTop())
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(xFilial('SC8') + cNumCOT))

	// Gera codigo do formulario HTML.
	CSGerFor(4, nExec, cNextNiv)

	// Gera codigo do formulario HTML.
	CSGerFor(5, nExec, cNextNiv)

	// Gera os processos do workflow e envia o e-mail
	CotGeraWF(nExec)
	Next
	*/
	If (Len(aEMail) > 0)

		Begin Transaction
			aEnv := {}	

			For nX := 1 To Len(aEMail)
				/*
				cINFO := ''
				If (nExec == 1)
				IncProc('Gerando E-mail para o(s) gestor(es)...')
				Else
				u_xConOut('Gerando E-mail para o(s) gestor(es)...')
				EndIf

				// Gera codigo do formulario HTML.
				CSGerFor(0, nExec, cNextNiv, @_lRet)

				If !_lRet
				DisarmTransaction()
				Break
				EndIf			

				// Gera codigo do formulario HTML, para o quadro de rankin anterior
				aAAntSAK := SAK->(GetArea())
				aAAntSC8 := SC8->(GetArea())
				aAAntSCR := SCR->(GetArea())


				SC8->(DbGoTop())
				SC8->(DbSetOrder(1))
				SC8->(DbSeek(xFilial('SC8') + cNumCOT))

				SCR->(DbGoTop())
				SCR->(DbSetOrder(2))
				If SCR->(DbSeek(xFilial('SCR') + 'MC' + SC8->C8_NUM + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))))
				While !SCR->(Eof()) .And. (SCR->CR_TIPO == 'MC') .And. (AllTrim(SCR->CR_NUM) == SC8->C8_NUM)
				If (SCR->CR_STATUS == '03')
				CSGerFor(1, nExec, cNextNiv, @_lRet)

				If !_lRet
				DisarmTransaction()
				Break
				EndIf							

				EndIf
				SCR->(DbSkip())
				End
				EndIf

				RestArea(aAAntSAK)
				RestArea(aAAntSC8)
				RestArea(aAAntSCR)

				// Gera codigo do formulario HTML, para o cabe?alho do pedido
				CSGerFor(2, nExec, cNextNiv, @_lRet)

				If !_lRet
				DisarmTransaction()
				Break
				EndIf

				// Zera as variaveis de totais, para novo acumulo
				nTotPed := nTotIT := nTotDesc := nTotIpi := nTotFrt := 0

				// Assinala novos valores para os itens do pedido //
				cStrFor := ''
				For nY := 1 To Len(aCodFor)
				cStrFor += '[' + aCodFor[nY,1] + '],'
				Next

				nCodFor := (5 - Len(aCodFor))
				For nY := 1 To nCodFor
				If (nY == 1)
				cStrFor += '[A],'
				aAdd(aCodFor, {'A',1})
				ElseIf (nY == 2)
				cStrFor += '[B],'
				aAdd(aCodFor, {'B',1})
				ElseIf (nY == 3)
				cStrFor += '[C],'
				aAdd(aCodFor, {'C',1})
				ElseIf (nY == 4)
				cStrFor += '[D],'
				aAdd(aCodFor, {'D',1})
				EndIf
				Next
				cStrFor := SubStr(cStrFor, 1, (Len(cStrFor) - 1))

				If (Select('WFITENS') > 0)
				WFITENS->(DbCloseArea())
				EndIf
				cQry := 'SELECT C8_FILIAL, C8_ITEM, C8_QUANT, C8_UM, C8_PRODUTO, ' + cStrFor + ', C8_NUMSC, C8_ITEMSC '
				cQry += "FROM (SELECT DISTINCT C8_FILIAL, C8_ITEM, C8_QUANT, C8_UM, C8_PRODUTO, C8_PRECO, ('C8_'+C8_FORNECE+C8_LOJA) FORNECE, C8_NUMSC, C8_ITEMSC "
				cQry += ' FROM ' + RetSQLName('SC8') + ' SC8 '
				cQry += " WHERE SC8.C8_NUM = '" + cNumCOT + "' "
				cQry += " AND SC8.C8_FILIAL = '" + cFilCOT + "' "
				cQry += " AND SC8.D_E_L_E_T_ = '') AS SOURCEPVT "
				cQry += 'PIVOT (SUM(C8_PRECO) FOR FORNECE IN(' + cStrFor + ')) AS PVT '
				cQry += "WHERE C8_FILIAL = '" + cFilCOT + "' "
				cQry += 'ORDER BY PVT.C8_ITEM '
				TCQuery cQry New ALIAS 'WFITENS'
				WFITENS->(DbGoTop())
				While !WFITENS->(Eof())
				// Gera codigo do formulario HTML, para os ITENS do pedido
				CSGerFor(3, nExec, cNextNiv, @_lRet)

				If !_lRet
				DisarmTransaction()
				Break
				EndIf				

				WFITENS->(DbSkip())
				End

				SC8->(DbGoTop())
				SC8->(DbSetOrder(1))
				SC8->(DbSeek(xFilial('SC8') + cNumCOT))

				// Gera codigo do formulario HTML.
				CSGerFor(4, nExec, cNextNiv, @_lRet)

				If !_lRet
				DisarmTransaction()
				Break
				EndIf

				// Gera codigo do formulario HTML.
				CSGerFor(5, nExec, cNextNiv, @_lRet)

				If !_lRet
				DisarmTransaction()
				Break
				EndIf
				*/		
				// Gera os processos do workflow e envia o e-mail
				//CotGeraWF(nExec, @_lRet)


				If aScan(aEnv, {|x| AllTrim(x[1]) == AllTrim(aemail[nx][4])}) == 0

					U_WFEnvMsg(8,cFilCot,aEMail[nx][4],cNumCot,aEMail[nx],cCodProcesso)

					aAdd(aEnv,{aemail[nx][4]})		

					If !_lRet
						DisarmTransaction()
						Break
					EndIf
				Endif										
			Next

		End Transaction

	Else

		IF !l150Auto

			MsgAlert('Nao foram encontrados APROVADORES para envio de workflow! (WFENVCOT)', 'Atencao!')

		ELSE

			u_xConOut(Repl("-",80))
			u_xConOut("Nao foram encontrados APROVADORES para envio de workflow! (WFENVCOT)")
			u_xConOut(Repl("-",80))

		ENDIF		

	EndIf		
	*'Yttalo P. Martins 13/03/15-FIM-----------------------------------------------------------'*
Return      




/*/
*******************************************************************************************************
*** Funcao: PNRESCOT   -   Autor: Leonardo Pereira   -   Data:                                      ***
*** Descricao: Realiza a restauracao da cotacao                                                     ***
*******************************************************************************************************
/*/
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAutoLË+LË+¿
//³Autor: Yttalo P. Martins                    ³
//³Data: 13/03/15                              ³
//³Gestão da exclusão da rastreabilidade no ftp³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAutoÙ
ENDDOC*/
User Function PNResCot(cOrigem)

	/*/ Configuracao do FTP - Para upload dos arquivos /*/
	Local cSrvFTP := 'ftp.portonovosa.com.br'
	Local cUsrFTP := 'doit@portonovosa.com.br'
	Local cPswFTP := 'P@ssw0rd'
	Local nPortaFTP := 21
	Local cDirFTP := ''
	Local lRet := .T.
	Local cArqHTM := ''
	Local cArqINF := ''
	Local aAreaSC8 := SC8->(GetArea())
	Local cChave := SC8->C8_NUM
	Local _cArqTemp2:=""
	Local _lRetFTP  := .F.
	local nTryS     := 1// variavel auxiliar para o numero de tentativas de envio	
	Local _lArqHTM  := .F.
	Local _lArqINF  := .F.
	Local _aRetDir  := {}
	Local nL        := 1
	Local _lExistHTM  := .F.
	Local _lExistINF  := .F.		
	Local lAmbProd := (Upper(AllTrim(GetEnvServer())) $ AllTrim(GetMV('MV_XAMBIENT')))
	Local cMsg		:= "ERRO"


	/*Origem = R - Restaurar Cotaçaõ E - Excluir Cotação*/



	If cOrigem = "R"
		cMsg := "restaurá-la"
	ElseIf cOrigem = "E"
		cMsg := "excluí-la"
	EndIf

	If !Empty(SC8->C8_WFID)
		If (MsgYesNo("Esta COTACAO possui WORKFLOW enviado, deseja realmente " + cMsg + " ?", "WORKFLOW"))

			/*/ Exclui as aprovacoes /*/
			SCR->(DbSetOrder(1))
			If SCR->(DbSeek(xFilial('SCR') + 'MC' + SC8->C8_NUM))
				While !SCR->(Eof()) .And. (xFilial('SCR') + 'MC' + SC8->C8_NUM == SCR->CR_FILIAL + SCR->CR_TIPO + AllTrim(SCR->CR_NUM))
					RecLock('SCR', .F.)
					SCR->(DbDelete())
					SCR->(MsUnLock())
					SCR->(DbSkip())
				End
			EndIf

			/*/ Ecluindo Registro de rastreabilidade do workflow 
			cQryWF3 := 'DELETE ' + RetSQLName('WF3') + ' '
			cQryWF3 += "WHERE WF3_ID LIKE('%" + AllTrim(SC8->C8_WFID) + "%') "
			TcSQLExec(cQryWF3)

			/ Ecluindo Registro de rastreabilidade do workflow 
			cQryWFA := 'DELETE ' + RetSQLName('WFA') + ' '
			cQryWFA += "WHERE WFA_IDENT LIKE('%" + AllTrim(SC8->C8_WFID) + "%') "
			TcSQLExec(cQryWFA)
			*/

			/*/ Limpa os flags da cotacao /*/
			SC8->(DbSetOrder(1))
			If SC8->(DbSeek(xFilial('SC8') + cChave))
				While !SC8->(Eof()) .And. (SC8->C8_NUM == cChave)
					RecLock('SC8' , .F.)
					SC8->C8_FLAGWF := ''
					SC8->C8_WFID := ''
					SC8->(DbSkip())
				End
			EndIf
		Endif
	Endif

	RestArea(aAreaSC8)

Return    



























/*
****************************************************************************************************
*** Funcao: COTGERAWF   -   Autor: Leonardo Pereira   -   Data:                                  ***
*** Descricao:                                                                                   ***
****************************************************************************************************
*/
Static Function CotGeraWF(nExec,_lRet)

	Local nDias := 0, nHoras := 0, nMinutos := 10
	Local cCodStatus, cHtmlModelo
	Local cUsuarioWF, cTexto
	Local cNumCotWF := cNumCOT
	Local cTitulo := 'Ranking da cotacao de compras'

	/*/ Arquivo html template utilizado para montagem da aprova??o /*/
	cHtmlModelo := If((SubStr(cFilAnt, 1, 2) == '01'), '\workflow\modelos\WFCotLink01.htm', '\workflow\modelos\WFCotLink02.htm')

	/*/ Registra o nome do usu?rio corrente que est? criando o processo: /*/
	cUsuarioWF := If((nExec == 1), SubStr(cUsuario, 7, 15), Lower(aDadosTxt[1, 7]))

	/*/ Cria uma tarefa /*/
	oProcess:NewTask(cTitulo, cHtmlModelo)

	/*/ Cria um texto que identifique as etapas do processo que foi realizado para futuras consultas na janela de rastreabilidade /*/
	cTexto := 'Iniciando a solicitacao de ' + cAssunto + ' No.: ' + cNumCotWF

	/*/ Informe o c?digo de status correspondente a essa etapa /*/
	cCodStatus := '100100' // C?digo do cadastro de status de processo

	/*/ Repasse as informa??es para o m?todo respons?vel pela rastreabilidade /*/
	oProcess:Track(cCodStatus, cTexto, cUsuarioWF) // Rastreabilidade

	/*/ Adicione informac?es a serem inclu?das na rastreabilidade /*/
	cTexto := 'Gerando solicitacao para ranking...'
	cCodStatus := '100200'
	oProcess:Track(cCodStatus, cTexto, cUsuarioWF)

	oProcess:oHtml:ValByName('WAprovador', aEmail[nX, 03])
	oProcess:oHtml:ValByName('WNumCot', cNumCotWF)
	oProcess:oHtml:ValByName('WLink', cHost )
	oProcess:oHtml:ValByName('WTexto', cHost )

	/*/ Repasse o texto do assunto criado para a propriedade espec?fica do processo /*/
	oProcess:cSubject := cAssunto

	/*/ Informe o endere?o eletr?nico do destinat?rio /*/
	oProcess:cTo := aEmail[nX, 01]
	//oProcess:cTo := "fabio.regueira@portonovosa.com"

	/*/ Utilize a funcao WFCodUser para obter o c?digo do usu?rio Protheus /*/
	oProcess:UserSiga := If((nExec == 1), WFCodUser(cUsuarioWF), aDadosTxt[1, 8])

	/*/ Informe o nome da fun??o de retorno a ser executada quando a mensagem de respostas retornar ao Workflow /*/
	//oProcess:bReturn := 'U_WFMCRetPN()'

	/*/ Informe o nome da fun??o do tipo timeout que ser? executada se houver um timeout ocorrido para esse processo. Neste exemplo, ela ser? executada cinco minutos ap?s o envio /*/
	/*/ do e-mail para o destinat?rio. Caso queira-se aumentar ou diminuir o tempo, altere os valores das vari?veis: nDias, nHoras e nMinutos /*/
	oProcess:bTimeOut := ''

	/*/ Adicione as informac?es a serem inclu?das na rastreabilidade /*/
	cTexto := 'Enviando solicitacao de ranking...'
	cCodStatus := '100300'
	oProcess:Track(cCodStatus, cTexto , cUsuarioWF)

	WFProcessID := oProcess:fProcessID

	/*/ Ap?s ter repassado todas as informac?es necess?rias para o Workflow, execute o m?todo Start() para gerar todo o processo e enviar a mensagem ao destinat?rio /*/
	//oProcess:Start()

	/*/ Adicione as informac?es a serem inclu?das na rastreabilidade /*/
	cTexto := 'Aguarde retorno...'
	cCodStatus := '100400'
	oProcess:Track(cCodStatus, cTexto , cUsuarioWF) // Rastreabilidade

Return
















/*
************************************************************************************************************************************
*** Funcao: CSGerFor   -   Autor: Leonardo Pereira   -   Data: 02/12/2010                                                        ***
*** Descricao: Gera formulario HTML para acesso via LINK.                                                                        ***
************************************************************************************************************************************
*/
Static Function CSGerFor(nOpc, nExec, cNextNiv, _lRet)

	Local cQry := ''
	Local nCountFor := 0
	Local nA := 0
	Local nK := 0
	Local nZ := 0
	Local aArqFTP := {}

	Local _lRetFTP  := .F.
	lOCAL _lArqINF	:= .F.
	lOCAL _lArqINF2	:= .F.
	local _cArqTemp := ""
	local _cArqTemp2:= ""
	local nTryS     := 1// variavel auxiliar para o numero de tentativas de envio
	Local aRetDir	:= {}		
	Local nL := 0

	/*/ Configuracao do FTP - Para upload/exclusao dos arquivos /*/
	Private cSrvFTP := 'ftp.portonovosa.com.br'
	Private nPortaFTP := 21
	Private cDirFTP := ''
	Private cUsrFTP := 'doit@portonovosa.com.br'
	Private cPswFTP := 'P@ssw0rd'
	Private nHdl := nHd2 := 0

	If lAmbProd
		cDirFTP := '/workflow/'
	Else
		cDirFTP := '/workflow/homologacao/'
	EndIf

	/*/ Inicialize a classe TWFProcess e assinale a vari?vel objeto oProcess /*/
	If (nOpc == 0)
		oProcess := TWFProcess():New(cCodProcesso, cAssunto)
	EndIf

	Do Case
		Case (nOpc == 0)
		/*/ Montagem do HTML /*/
		cHTML := ''
		cHTML += '<?php session_start(); ini_set("default_charset","iso-8859-1"); ?>' + cEOL
		cHTML += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' + cEOL
		cHTML += '<html xmlns="http://www.w3.org/1999/xhtml">' + cEOL
		cHTML += '   <head>' + cEOL
		cHTML += '      <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />' + cEOL
		cHTML += '      <title>..:: Consorcio Porto - Central de Aprovacoes ::..</title>' + cEOL
		cHTML += '      <script src="' + cHost + 'jscript/WFAprCot.js?c=987654321" type="text/javascript"></script>' + cEOL

		/*/ Verifica se o usuario realizou login /*/
		cHTML += '      <?php' + cEOL
		cHTML += '      // Inclui o arquivo com a classe de login' + cEOL
		cHTML += "      require_once('../../../php/class.usuarios.php');" + cEOL
		cHTML += '' + cEOL
		cHTML += '      // Instancia a classe' + cEOL
		cHTML += '      $userClass = new Usuario();' + cEOL
		cHTML += '' + cEOL
		cHTML += '      // Verifica se n?o h? um usu?rio logado' + cEOL
		cHTML += '      if ($userClass->usuarioLogado() === false) {' + cEOL
		cHTML += '         // N?o h? um usu?rio logado, redireciona pra tela de login' + cEOL
		cHTML += "         header('Location: " + cHost + "index.php');" + cEOL
		cHTML += '         exit;' + cEOL
		cHTML += '      }' + cEOL
		cHTML += '      ?>' + cEOL

		/*/ Verifica se o usuario da sessao tem acesso a pagina /*/
		cHTML += '<?php' + cEOL
		cHTML += 'if (!($_SESSION[' + "'usuario_codusu'] == '" + '%WFUsrApr%' + "')) {" + cEOL
		cHTML += '   // Verifica se o usuario da sessao tem acesso a pagina' + cEOL
		cHTML += '   echo "<script language=' + "'javascript'>alert('Esta p?gina nao ? permitida para este usu?rio!');</script>" + '";' + cEOL
		cHTML += '   echo "<script language=' + "'javascript'>location.href='" + cHost + "index.php';</script>" + '";' + cEOL
		cHTML += '   exit;' + cEOL
		cHTML += '}' + cEOL
		cHTML += '?>' + cEOL

		/*/ Sessao de estilo dos elementos /*/
		cHTML += '      <style type="text/css">' + cEOL
		cHTML += '         .tit1 {' + cEOL
		cHTML += '            font-family: Tahoma, Geneva, sans-serif;' + cEOL
		cHTML += '            font-size: 24px;' + cEOL
		cHTML += '            font-weight: bold;' + cEOL
		cHTML += '            color: #FFFFFF;' + cEOL
		cHTML += '         }' + cEOL
		cHTML += '         .tit2 {' + cEOL
		cHTML += '            font-family: Tahoma, Geneva, sans-serif;' + cEOL
		cHTML += '            font-size: 18px;' + cEOL
		cHTML += '            font-weight: bold;' + cEOL
		cHTML += '            color: #FFFFFF;' + cEOL
		cHTML += '         }' + cEOL
		cHTML += '         .tit3 {' + cEOL
		cHTML += '            font-family: Tahoma, Geneva, sans-serif;' + cEOL
		cHTML += '            font-size: 13px;' + cEOL
		cHTML += '            font-weight: bold;' + cEOL
		cHTML += '            color: #001A33;' + cEOL
		cHTML += '         }' + cEOL
		cHTML += '         .tit5 {' + cEOL
		cHTML += '            font-family: Tahoma, Geneva, sans-serif;' + cEOL
		cHTML += '            font-size: 18px;' + cEOL
		cHTML += '            font-weight: bold;' + cEOL
		cHTML += '            color: #666666;' + cEOL
		cHTML += '         }' + cEOL
		cHTML += '         .cabec {' + cEOL
		cHTML += '            font-family: Tahoma, Geneva, sans-serif;' + cEOL
		cHTML += '            font-size: 12px;' + cEOL
		cHTML += '            font-weight: bold;' + cEOL
		cHTML += '            color: #FFFFFF;' + cEOL
		cHTML += '         }' + cEOL
		cHTML += '         .grid0a {' + cEOL
		cHTML += '            font-family: Tahoma, Geneva, sans-serif;' + cEOL
		cHTML += '            font-weight: bold;' + cEOL
		cHTML += '            font-size: 14px;' + cEOL
		cHTML += '            color: #FFFFFF;' + cEOL
		cHTML += '         }' + cEOL
		cHTML += '         .grid0b {' + cEOL
		cHTML += '            font-family: Tahoma, Geneva, sans-serif;' + cEOL
		cHTML += '            font-weight: bold;' + cEOL
		cHTML += '            font-size: 14px;' + cEOL
		cHTML += '            color: #000000;' + cEOL
		cHTML += '         }' + cEOL
		cHTML += '         .grid3 {' + cEOL
		cHTML += '            font-family: Tahoma, Geneva, sans-serif;' + cEOL
		cHTML += '            font-size: 12px;' + cEOL
		cHTML += '            font-weight: bold;' + cEOL
		cHTML += '            color: #00376F;' + cEOL
		cHTML += '         }' + cEOL
		cHTML += '         .grid4 {' + cEOL
		cHTML += '            font-family: Tahoma, Geneva, sans-serif;' + cEOL
		cHTML += '            font-size: 12px;' + cEOL
		cHTML += '            font-weight: bold;' + cEOL
		cHTML += '            color: #00376F;' + cEOL
		cHTML += '         }' + cEOL
		cHTML += '         .rodape {' + cEOL
		cHTML += '            font-family: Tahoma, Geneva, sans-serif;' + cEOL
		cHTML += '            font-size: 13px;' + cEOL
		cHTML += '            font-weight: bold;' + cEOL
		cHTML += '            color: #001A33;' + cEOL
		cHTML += '         }' + cEOL
		cHTML += '         body {' + cEOL
		cHTML += '            margin-left: 0px;' + cEOL
		cHTML += '            margin-top: 0px;' + cEOL
		cHTML += '            margin-right: 0px;' + cEOL
		cHTML += '            margin-bottom: 0px;' + cEOL
		cHTML += '         }' + cEOL
		cHTML += '      </style>' + cEOL
		cHTML += '   </head>' + cEOL
		cHTML += '   <body>' + cEOL

		/*/ Declara os campos ocultos no formulario /*/
		cHTML += '      <form id="WFForm1" name="WFForm1" method="post" action="' + cHost + 'php/WFGrvCot.php">' + cEOL
		cHTML += '		    <input type="hidden" name="WFGrvCot" id="WFGrvCot"/>' + cEOL
		cHTML += '		    <input type="hidden" name="WFCodEmp" id="WFCodEmp" value="%WFCodEmp%"/>' + cEOL
		cHTML += '		    <input type="hidden" name="WFCodFil" id="WFCodFil" value="%WFCodFil%"/>' + cEOL
		cHTML += '		    <input type="hidden" name="WFNumCot" id="WFNumCot" value="%WFNumCot%"/>' + cEOL
		cHTML += '		    <input type="hidden" name="WFUsrApr" id="WFUsrApr" value="%WFUsrApr%"/>' + cEOL
		cHTML += '		    <input type="hidden" name="WFDtRank" id="WFDtRank" value="%WFDtRank%"/>' + cEOL
		cHTML += '	 	    <input type="hidden" name="WFForRk1" id="WFForRk1" value="%WFForRk1%"/>' + cEOL
		cHTML += '		    <input type="hidden" name="WFForRk2" id="WFForRk2" value="%WFForRk2%"/>' + cEOL
		cHTML += '		    <input type="hidden" name="WFForRk3" id="WFForRk3" value="%WFForRk3%"/>' + cEOL
		cHTML += '		    <input type="hidden" name="WFForRk4" id="WFForRk4" value="%WFForRk4%"/>' + cEOL
		cHTML += '		    <input type="hidden" name="WFForRk5" id="WFForRk5" value="%WFForRk5%"/>' + cEOL
		cHTML += '		    <input type="hidden" name="WFQtdFor" id="WFQtdFor" value="%WFQtdFor%"/>' + cEOL
		cHTML += '		    <input type="hidden" name="WFVlFor1" id="WFVlFor1" value="%WFVlFor1%"/>' + cEOL
		cHTML += '		    <input type="hidden" name="WFVlFor2" id="WFVlFor2" value="%WFVlFor2%"/>' + cEOL
		cHTML += '		    <input type="hidden" name="WFVlFor3" id="WFVlFor3" value="%WFVlFor3%"/>' + cEOL
		cHTML += '		    <input type="hidden" name="WFVlFor4" id="WFVlFor4" value="%WFVlFor4%"/>' + cEOL
		cHTML += '		    <input type="hidden" name="WFVlFor5" id="WFVlFor5" value="%WFVlFor5%"/>' + cEOL
		cHTML += '		    <input type="hidden" name="WFRejeita" id="WFRejeita" value="0"/>' + cEOL

		/*/ Dados do cabecalho da cotacao /*/
		cHTML += '         <table width="100%" border="0" cellspacing="1" cellpadding="1">' + cEOL
		cHTML += '            <tr>' + cEOL
		If (SubStr(AllTrim(cFilAnt), 1, 2) == '01')
			cHTML += '               <td width="11%" height="54" rowspan="2" align="center" valign="middle" bgcolor="#001A33" class="tit1"><img src="' + cHost + 'img/logoportonovo.png" width="150" height="112"/></td>' + cEOL
		ElseIf (SubStr(AllTrim(cFilAnt), 1, 2) == '02')
			cHTML += '               <td width="11%" height="54" rowspan="2" align="center" valign="middle" bgcolor="#001A33" class="tit1"><img src="' + cHost + 'img/logotcr.png" width="255" height="112"/></td>' + cEOL
		EndIf
		cHTML += '               <td width="40%" height="54" rowspan="2" align="center" valign="middle" bgcolor="#001A33" class="tit1">MAPA DE COTACAO</td>' + cEOL
		cHTML += '               <td width="17%" height="54" align="center" valign="middle" bgcolor="#001A33" class="tit1">No. COTACAO:</td>' + cEOL
		cHTML += '               <td width="17%" height="54" align="center" valign="middle" bgcolor="#001A33" class="tit1">DATA VALIDADE</td>' + cEOL
		cHTML += '               <td width="15%" height="54" align="center" valign="middle" bgcolor="#001A33" class="tit1">C. CUSTO</td>' + cEOL
		cHTML += '            </tr>' + cEOL
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td width="17%" height="54" align="center" valign="middle" bgcolor="#001A33" class="tit1">%WFNumCot%</td>' + cEOL
		cHTML += '               <td width="17%" height="54" align="center" valign="middle" bgcolor="#001A33" class="tit1">%WFDatVal%</td>' + cEOL
		cHTML += '               <td width="15%" height="54" align="center" valign="middle" bgcolor="#001A33" class="tit1">%WFCCusto%</td>' + cEOL
		cHTML += '            </tr>' + cEOL
		cHTML += '         </table>' + cEOL

		/*/ Dados da analise anterior da cotacao /*/
		cHTML += '         <table width="100%" border="0" cellspacing="1" cellpadding="1">' + cEOL
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td colspan="7">&nbsp;</td>' + cEOL
		cHTML += '            </tr>' + cEOL
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td colspan="7" align="center" valign="middle" bgcolor="#001A33" class="tit1">RANKING ANTERIOR</td>' + cEOL
		cHTML += '            </tr>' + cEOL
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td width="15%" height="15" align="center" valign="middle" bgcolor="#00376F" class="cabec">APROVADOR</td>' + cEOL
		cHTML += '						 <td width="15%" height="15" align="center" valign="middle" bgcolor="#00376F" class="cabec">OBSERVACAO</td>' + cEOL
		cHTML += '               <td width="14%" height="15" align="center" valign="middle" bgcolor="#00376F" class="cabec">1o - COLOCADO</td>' + cEOL
		cHTML += '               <td width="14%" height="15" align="center" valign="middle" bgcolor="#00376F" class="cabec">2o - COLOCADO</td>' + cEOL
		cHTML += '               <td width="14%" height="15" align="center" valign="middle" bgcolor="#00376F" class="cabec">3o - COLOCADO</td>' + cEOL
		cHTML += '               <td width="14%" height="15" align="center" valign="middle" bgcolor="#00376F" class="cabec">4o - COLOCADO</td>' + cEOL
		cHTML += '               <td width="14%" height="15" align="center" valign="middle" bgcolor="#00376F" class="cabec">5o - COLOCADO</td>' + cEOL
		cHTML += '            </tr>' + cEOL
		cHTML += '            <rankant>' + cEOL
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td colspan="7">&nbsp;</td>' + cEOL
		cHTML += '            </tr>' + cEOL
		cHTML += '         </table>' + cEOL

		/*/ Dados dos fornecedores da cotacao /*/
		cHTML += '         <table width="100%" border="0" cellspacing="1" cellpadding="1">' + cEOL
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td colspan="9" align="center" valign="middle" bgcolor="#001A33" class="tit1">DADOS DOS FORNECEDORES</td>' + cEOL
		cHTML += '            </tr>' + cEOL
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td width="30%" height="20" colspan="4" rowspan="2" bgcolor="#EBEBEB" class="tit3">&nbsp;</td>' + cEOL
		cHTML += '               <td width="14%" height="30" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFNomFor1%</td>' + cEOL
		cHTML += '               <td width="14%" height="30" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFNomFor2%</td>' + cEOL
		cHTML += '               <td width="14%" height="30" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFNomFor3%</td>' + cEOL
		cHTML += '               <td width="14%" height="30" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFNomFor4%</td>' + cEOL
		cHTML += '               <td width="14%" height="30" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFNomFor5%</td>' + cEOL
		cHTML += '           </tr>' + cEOL
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td width="14%" height="30" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFUfFor1%</td>' + cEOL
		cHTML += '               <td width="14%" height="30" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFUfFor2%</td>' + cEOL
		cHTML += '               <td width="14%" height="30" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFUfFor3%</td>' + cEOL
		cHTML += '               <td width="14%" height="30" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFUfFor4%</td>' + cEOL
		cHTML += '               <td width="14%" height="30" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFUfFor5%</td>' + cEOL
		cHTML += '            </tr>' + cEOL

		/*/ Dados dos Itens da cotacao /*/
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td width="5%" height="15" align="center" valign="middle" bgcolor="#00376F" class="cabec">ITEM</td>' + cEOL
		cHTML += '               <td width="5%" height="15" colspan="-25" align="center" valign="middle" bgcolor="#00376F" class="cabec">QTD.</td>' + cEOL
		cHTML += '               <td width="5%" height="15" colspan="-25" align="center" valign="middle" bgcolor="#00376F" class="cabec">UND.</td>' + cEOL
		cHTML += '               <td width="15%" height="15" colspan="-25" align="center" valign="middle" bgcolor="#00376F" class="cabec">DESCRICAO DO MATERIAL</td>' + cEOL
		cHTML += '               <td width="14%" height="15" align="center" valign="middle" bgcolor="#00376F" class="cabec">PRECO UNIT.</td>' + cEOL
		cHTML += '               <td width="14%" height="15" align="center" valign="middle" bgcolor="#00376F" class="cabec">PRECO UNIT.</td>' + cEOL
		cHTML += '               <td width="14%" height="15" align="center" valign="middle" bgcolor="#00376F" class="cabec">PRECO UNIT.</td>' + cEOL
		cHTML += '               <td width="14%" height="15" align="center" valign="middle" bgcolor="#00376F" class="cabec">PRECO UNIT.</td>' + cEOL
		cHTML += '               <td width="14%" height="15" align="center" valign="middle" bgcolor="#00376F" class="cabec">PRECO UNIT.</td>' + cEOL
		cHTML += '            </tr>' + cEOL
		cHTML += '            <itens>' + cEOL
		cHTML += '         </table>' + cEOL

		/*/ Dados para analise da cotacao /*/
		cHTML += '         <table width="100%" border="0" cellspacing="1" cellpadding="1">' + cEOL
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td colspan="7" width="100%" height="35" align="center" valign="middle" bgcolor="#001A33" class="tit1">ANALISE DAS COTACOES</td>' + cEOL
		cHTML += '            </tr>' + cEOL

		/*/ Valor total dos itens /*/
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td width="15%" height="25" align="left" valign="middle" bgcolor="#001A33" class="cabec">COMPRADOR:</td>' + cEOL
		cHTML += '               <td width="15%" height="25" align="left" valign="middle" bgcolor="#00376F" class="cabec">TOTAL DA COTACAO:</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFPrcTot1%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFPrcTot2%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFPrcTot3%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFPrcTot4%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFPrcTot5%</td>' + cEOL
		cHTML += '            </tr>' + cEOL

		/*/ Prazo de entrega /*/
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td width="15%" height="25" align="center" valign="middle" bgcolor="#001A33" class="cabec">%WFNomComp%</td>' + cEOL
		cHTML += '               <td width="15%" height="25" align="left" valign="middle" bgcolor="#00376F" class="cabec">PRAZO DE ENTREGA:</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFPrazo1%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFPrazo2%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFPrazo3%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFPrazo4%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFPrazo5%</td>' + cEOL
		cHTML += '            </tr>' + cEOL

		/*/ Valor do frete /*/
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td width="15%" height="25" align="left" valign="middle" bgcolor="#001A33" class="cabec">DATA DE ENVIO:</td>' + cEOL
		cHTML += '               <td width="15%" height="25" align="left" valign="middle" bgcolor="#00376F" class="cabec">FRETE:</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFFrete1%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFFrete2%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFFrete3%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFFrete4%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFFrete5%</td>' + cEOL
		cHTML += '            </tr>' + cEOL

		/*/ Valor do IPI /*/
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td width="15%" height="25" align="center" valign="middle" bgcolor="#001A33" class="cabec">%WFDatEnv%</td>' + cEOL
		cHTML += '               <td width="15%" height="25" align="left" valign="middle" bgcolor="#00376F" class="cabec">IPI:</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFIPI1%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFIPI2%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFIPI3%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFIPI4%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFIPI5%</td>' + cEOL
		cHTML += '            </tr>' + cEOL

		/*/ Valor do ICMS /*/
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td width="15%" height="25" align="left" valign="middle" bgcolor="#001A33" class="cabec">APROVADOR:</td>' + cEOL
		cHTML += '               <td width="15%" height="25" align="left" valign="middle" bgcolor="#00376F" class="cabec">ICMS:</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFICMS1%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFICMS2%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFICMS3%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFICMS4%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFICMS5%</td>' + cEOL
		cHTML += '            </tr>' + cEOL

		/*/ Condicao de pagamento /*/
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td width="15%" height="25" align="center" valign="middle" bgcolor="#001A33" class="cabec">%WFNomApr%</td>' + cEOL
		cHTML += '               <td width="15%" height="25" align="left" valign="middle" bgcolor="#00376F" class="cabec">CONDICAO DE PAGTO:</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFCPag1%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFCPag2%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFCPag3%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFCPag4%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFCPag5%</td>' + cEOL
		cHTML += '            </tr>' + cEOL

		/*/ Dados de contato /*/
		cHTML += '            <tr>' + cEOL
		cHTML += '						 <td width="15%" height="25" align="left" valign="middle" bgcolor="#001A33" class="cabec">SOLICITANTE:</td>' + cEOL
		cHTML += '               <td width="15%" height="25" align="left" valign="middle" bgcolor="#00376F" class="cabec">CONTATO:</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFContato1%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFContato2%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFContato3%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFContato4%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFContato5%</td>' + cEOL
		cHTML += '            </tr>' + cEOL

		/*/ Avaliacao de desempenho do fornecedor /*/
		cHTML += '            <tr>' + cEOL
		cHTML += '						 <td width="15%" height="25" align="center" valign="middle" bgcolor="#001A33" class="cabec">%WFNomeSol%</td>' + cEOL
		cHTML += '               <td width="15%" height="25" align="left" valign="middle" bgcolor="#00376F" class="cabec">AVALIACAO DE DESEMPENHO:</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFAval1%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFAval2%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFAval3%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFAval4%</td>' + cEOL
		cHTML += '               <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">%WFAval5%</td>' + cEOL
		cHTML += '            </tr>' + cEOL

		/*/ Ranking /*/
		cHTML += '            <tr>' + cEOL
		cHTML += '						 <td width="15%" height="25" align="left" valign="middle" bgcolor="#001A33" class="cabec">&nbsp;</td>' + cEOL
		cHTML += '               <td width="15%" align="left"   valign="middle" bgcolor="#00376F" class="cabec" height="25">RANKING:</td>' + cEOL
		cHTML += '               <rank>' + cEOL
		cHTML += '            </tr>' + cEOL
		cHTML += '         </table>' + cEOL

		/*/ Observacoes do comprador /*/
		cHTML += '         <table width="100%" border="0" cellspacing="1" cellpadding="1">' + cEOL
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td>&nbsp;</td>' + cEOL
		cHTML += '            </tr>' + cEOL
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td align="center" valign="middle" bgcolor="#001A33" width="100%" height="25" class="tit1">OBSERVACOES DO COMPRADOR</td>' + cEOL
		cHTML += '            </tr>' + cEOL
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td align="center" valign="middle" bgcolor="#CCCCCC"><textarea id="WFObsMC1" name="WFObsMC1" cols="184" rows="7" readonly="readonly" class="grid4">%WFObsMC1%</textarea></td>' + cEOL
		cHTML += '            </tr>' + cEOL
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td bgcolor="#00376F">&nbsp;</td>' + cEOL
		cHTML += '            </tr>' + cEOL
		cHTML += '            <tr>' + cEOL
		cHTML += '               <td>&nbsp;</td>' + cEOL
		cHTML += '            </tr>' + cEOL
		cHTML += '         </table>

		/*/ Quadro de resposta do mapa de cotacao /*/
		cHTML += '				<table width="100%" border="0" cellspacing="1" cellpadding="1">' + cEOL
		cHTML += '					<tr>' + cEOL
		cHTML += '						<td colspan="2" height="25" align="center" valign="middle" bgcolor="#001A33" class="tit1">OBSERVACOES</td>' + cEOL
		cHTML += '					</tr>' + cEOL
		cHTML += '					<tr>
		cHTML += '						<td width="78%" rowspan="3" height="35" align="left" valign="middle" bgcolor="#CCCCCC"><textarea id="WFObsMC2" name="WFObsMC2" cols="150" rows="7" class="grid4"></textarea></td>' + cEOL
		cHTML += '					<td width="20%" height="18" align="center" valign="middle" bgcolor="#CCCCCC"><input name="WFBotao1" type="submit" class="tit5" id="WFBotao1" value="Aprovar" onClick="return ValidaAprovado(' + "'" + 'WFForm1' + "'" + ');"/></td>' + cEOL
		cHTML += '						</tr>' + cEOL
		cHTML += '					<tr>' + cEOL
		cHTML += '						<td width="20%" height="18" align="center" valign="middle" bgcolor="#CCCCCC"><input name="WFBotao2" type="submit" class="tit5" id="WFBotao2" value="Rejeitar" onClick="return ValidaRejeitado(' + "'" + 'WFForm1' + "'" + ');"/></td>' + cEOL
		cHTML += '					</tr>' + cEOL
		cHTML += '					<tr>' + cEOL
		cHTML += '						<td width="22%" height="25" align="center" valign="middle" bgcolor="#CCCCCC"><input name="WFBotao3" type="reset" class="tit5" id="WFBotao3" value="Limpar"/></td>' + cEOL
		cHTML += '					</tr>' + cEOL
		cHTML += '					<tr>' + cEOL
		cHTML += '						<td height="10" colspan="2" bgcolor="#00376F">&nbsp;</td>' + cEOL
		cHTML += '					</tr>' + cEOL
		cHTML += '					<tr>' + cEOL
		cHTML += '						<td height="10" colspan="2">&nbsp;</td>' + cEOL
		cHTML += '					</tr>' + cEOL
		cHTML += '				</table>' + cEOL

		cHTML += '      </form>' + cEOL
		cHTML += '   </body>' + cEOL
		cHTML += '</html>' + cEOL
		Case (nOpc == 1)
		/*/ Faz a leitura dos arquivos no diretorio /*/
		If (cNextNiv > 0)
			SAK->(DbGoTop())
			SAK->(DbSetOrder(2))
			If SAK->(DbSeek(xFilial('SAK') + SCR->CR_USER))
				/*/ Cria as linhas do grid de ranking anterior /*/
				cHTMLIt := ''
				cHTMLIt += '            <tr>' + cEOL
				cHTMLIt += '						<td width="15%" height="20" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">' + SAK->AK_COD + ' - ' + AllTrim(SAK->AK_NOME) + '</td>' + cEOL
				cHTMLIt += '						<td width="15%" height="20" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3"><textarea id="WFObsMC" name="WFObsMC"' + ' cols="50" rows="3" readonly="readonly" class="tit3">' + AllTrim(SCR->CR_XOBSAPR) + '</textarea></td>' + cEOL
				cHTMLIt += '						<td width="14%" height="20" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">' + SCR->CR_RKN1 + ' - ' + AllTrim(Posicione('SA2', 1, xFilial('SA2') + SubStr(SCR->CR_RKN1,1,6) + SubStr(SCR->CR_RKN1,8,2), 'A2_NOME')) + '</td>' + cEOL
				cHTMLIt += '						<td width="14%" height="20" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">' + SCR->CR_RKN2 + ' - ' + AllTrim(Posicione('SA2', 1, xFilial('SA2') + SubStr(SCR->CR_RKN2,1,6) + SubStr(SCR->CR_RKN2,8,2), 'A2_NOME')) + '</td>' + cEOL
				cHTMLIt += '               <td width="14%" height="20" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">' + SCR->CR_RKN3 + ' - ' + AllTrim(Posicione('SA2', 1, xFilial('SA2') + SubStr(SCR->CR_RKN3,1,6) + SubStr(SCR->CR_RKN3,8,2), 'A2_NOME')) + '</td>' + cEOL
				cHTMLIt += '               <td width="14%" height="20" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">' + SCR->CR_RKN4 + ' - ' + AllTrim(Posicione('SA2', 1, xFilial('SA2') + SubStr(SCR->CR_RKN4,1,6) + SubStr(SCR->CR_RKN4,8,2), 'A2_NOME')) + '</td>' + cEOL
				cHTMLIt += '               <td width="14%" height="20" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">' + SCR->CR_RKN5 + ' - ' + AllTrim(Posicione('SA2', 1, xFilial('SA2') + SubStr(SCR->CR_RKN5,1,6) + SubStr(SCR->CR_RKN5,8,2), 'A2_NOME')) + '</td>' + cEOL
				cHTMLIt += '            </tr>' + cEOL
				cHTMLIt += '            <rankant>' + cEOL
				cHTML := StrTran(cHTML, '<rankant>', cHTMLIt)
			EndIf
		EndIf
		Case (nOpc == 2)
		cHTML := StrTran(cHTML, '%WFCodEmp%', cEmpAnt)
		cHTML := StrTran(cHTML, '%WFCodFil%', AllTrim(cFilAnt))
		cHTML := StrTran(cHTML, '%WFNumCot%', SC8->C8_NUM)
		cHTML := StrTran(cHTML, '%WFDatVal%', DtoC(SC8->C8_VALIDA))

		If (nExec == 1)
			//cMsgComp := NoAcento(StrTran(AllTrim(cMsgComp), ';', ' '))
			cMsgComp := StrTran(AllTrim(cMsgComp), ';', ' ')
			cHTML := StrTran(cHTML, '%WFObsMC1%', AllTrim(cMsgComp))
			SC8->(RecLock('SC8', .F.))
			SC8->C8_XOBSCOT := AllTrim(cMsgComp)
			SC8->(MsUnLock())
		Else
			cHTML := StrTran(cHTML, '%WFObsMC1%', aDadosTxt[1, If((Len(aDadosTxt[1]) == 28), (Len(aDadosTxt[1]) - 1), (Len(aDadosTxt[1]) - 2))])
		EndIf

		/*/ pega o nome da empresa e da filial /*/
		cINFO += SubStr(AllTrim(cFilAnt), 1, 2) + '|' 	// 0
		cINFO += AllTrim(SM0->M0_FILIAL) + '|' 				// 1
		cINFO += AllTrim(cFilAnt) + '|' 							// 2
		cINFO += AllTrim(SM0->M0_NOMECOM) + '|' 				// 3
		cINFO += SC8->C8_NUM + '|' 									// 4

		If (Select('WFFORN') > 0)
			WFFORN->(DbCloseArea())
		EndIf
		cQry := 'SELECT DISTINCT C8_FORNECE, C8_LOJA, C8_MOEDA '
		cQry += 'FROM ' + RetSQLName('SC8') + ' SC8 '
		cQry += "WHERE SC8.C8_NUM = '" + cNumCOT + "' "
		cQry += "AND SC8.C8_FILIAL = '" + cFilCOT + "' "
		cQry += "AND SC8.D_E_L_E_T_ = '' "
		cQry += 'ORDER BY C8_FORNECE, C8_LOJA '
		TCQuery cQry New ALIAS 'WFFORN'
		WFFORN->(DbGoTop())
		nCountFor := 0
		aCodFor := {}
		While !WFFORN->(Eof())
			nCountFor++
			If (nCountFor > 5)
				Exit
			EndIf
			SA2->(DbSetOrder(1))
			SA2->(DbSeek(xFilial('SA2') + WFFORN->C8_FORNECE + WFFORN->C8_LOJA))
			cHTML := StrTran(cHTML, '%WFNomFor' + StrZero(nCountFor,1) + '%', SA2->A2_COD + '/' + SA2->A2_LOJA + ' - ' + AllTrim(SA2->A2_NREDUZ))
			cHTML := StrTran(cHTML, '%WFForRk' + StrZero(nCountFor,1) + '%', SA2->A2_COD + '/' + SA2->A2_LOJA + ' - ' + AllTrim(SA2->A2_NREDUZ))
			cHTML := StrTran(cHTML, '%WFUfFor' + StrZero(nCountFor,1) + '%', SA2->A2_EST)

			cHTMLIt := ''
			cHTMLIt += ' <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3"><input name="WFRank' + StrZero(nCountFor,1) + '" type="text" class="grid4" id="WFRank' + StrZero(nCountFor,1) + '" size="5" maxlength="1" onChange="return ValidaDigitacao(' + "'" + 'WFForm1' + "'" + ');"/></td>' + cEOL
			cHTMLIt += '<rank>' + cEOL
			cHTML := StrTran(cHTML, '<rank>', cHTMLIt)
			aAdd(aCodFor, ({'C8_' + SA2->A2_COD + SA2->A2_LOJA,WFFORN->C8_MOEDA}))
			WFFORN->(DbSkip())
		End
		cHTML := StrTran(cHTML, '%WFQtdFor%', AllTrim(Str(nCountFor)))
		If (nCountFor < 5)
			For nZ := 1 To (5 - nCountFor)
				cHTML := StrTran(cHTML, '%WFNomFor' + StrZero((nCountFor + nZ), 1) + '%', '')
				cHTML := StrTran(cHTML, '%WFForRk' + StrZero((nCountFor + nZ), 1) + '%', '')
				cHTML := StrTran(cHTML, '%WFUfFor' + StrZero((nCountFor + nZ), 1) + '%', '')
				cHTMLIt := ''
				cHTMLIt += ' <td width="14%" height="25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3"><input name="WFRank' + StrZero((nCountFor + nZ), 1) + '" type="text" class="grid4" id="WFRank' + StrZero((nCountFor + nZ), 1) + '" size="5" maxlength="1" value="' + StrZero((nCountFor + nZ), 1) + '" readonly="readonly" onChange="return ValidaDigitacao(' + "'" + 'WFForm1' + "'" + ');"/></td>' + cEOL
				cHTMLIt += '<rank>' + cEOL
				cHTML := StrTran(cHTML, '<rank>', cHTMLIt)
			Next
		EndIf
		cHTML := StrTran(cHTML, '<rank>', '')
		Case (nOpc == 3)
		/*/ Monta a string para avaliacao dos fornecedores /*/
		cProdAval += "'" + AllTrim(WFITENS->C8_PRODUTO) + "',"

		/*/ Faz a inclusao de itens no grid do HTML /*/
		cHTMLIt := ''
		cHTMLIt += '<tr>' + cEOL
		cHTMLIt += '   <td width="5%" height="20" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">' + WFITENS->C8_ITEM + '</td>' + cEOL
		cHTMLIt += '   <td width="5%" height="20" colspan="-25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">' + Transform(WFITENS->C8_QUANT, '@E 999,999.99') + '</td>' + cEOL
		cHTMLIt += '   <td width="5%" height="20" colspan="-25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">' + WFITENS->C8_UM + '</td>' + cEOL
		cHTMLIt += '   <td width="15%" height="20" colspan="-25" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">' + AllTrim(Posicione('SC1', 1, xFilial('SC1') + WFITENS->C8_NUMSC + WFITENS->C8_ITEMSC, 'C1_DESCRI')) + '</td>' + cEOL
		cHTMLIt += '   <td width="14%" height="20" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">'+ AllTrim(GetMV('MV_SIMB' + AllTrim(Str(aCodFor[1,2]))))+ " " + Transform(&('WFITENS->' + aCodFor[1,1]), '@E 9,999,999.99') + '</td>' + cEOL
		cHTMLIt += '   <td width="14%" height="20" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">'+ AllTrim(GetMV('MV_SIMB' + AllTrim(Str(aCodFor[2,2]))))+ " " + Transform(&('WFITENS->' + aCodFor[2,1]), '@E 9,999,999.99') + '</td>' + cEOL
		cHTMLIt += '   <td width="14%" height="20" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">'+ AllTrim(GetMV('MV_SIMB' + AllTrim(Str(aCodFor[3,2]))))+ " " + Transform(&('WFITENS->' + aCodFor[3,1]), '@E 9,999,999.99') + '</td>' + cEOL
		cHTMLIt += '   <td width="14%" height="20" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">'+ AllTrim(GetMV('MV_SIMB' + AllTrim(Str(aCodFor[4,2]))))+ " " + Transform(&('WFITENS->' + aCodFor[4,1]), '@E 9,999,999.99') + '</td>' + cEOL
		cHTMLIt += '   <td width="14%" height="20" align="center" valign="middle" bgcolor="#EBEBEB" class="tit3">'+ AllTrim(GetMV('MV_SIMB' + AllTrim(Str(aCodFor[5,2]))))+ " " + Transform(&('WFITENS->' + aCodFor[5,1]), '@E 9,999,999.99') + '</td>' + cEOL
		cHTMLIt += '</tr>' + cEOL
		cHTMLIt += '<itens>' + cEOL
		cHTML := StrTran(cHTML, '<itens>', cHTMLIt)


		Case (nOpc == 4)
		SY1->(DbSetOrder(3))
		If SY1->(DbSeek(xFilial('SY1') + cCodUser))
			If !Empty(SY1->Y1_XRESP)
				SY1->(DbSetOrder(1))
				If SY1->(DbSeek(xFilial('SY1') + SY1->Y1_XRESP))
					cHTML := StrTran(cHTML, '%WFNomComp%', SY1->Y1_COD + ' - ' + AllTrim(SY1->Y1_NOME))
				EndIf
			Else
				cHTML := StrTran(cHTML, '%WFNomComp%', SY1->Y1_COD + ' - ' + AllTrim(SY1->Y1_NOME))
			EndIf
		Else
			cHTML := StrTran(cHTML, '%WFNomComp%', '')
		EndIf

		cINFO += SY1->Y1_COD + '|' // Codigo do Comprador // 5
		cINFO += AllTrim(SY1->Y1_NOME) + '|' // Nome do Comprador // 6
		cINFO += cCodUser + '|' // Codigo de Usuario do comprador // 7
		cINFO += aEMail[nX, 02] + '|' // Codigo do Aprovador // 8
		cINFO += aEMail[nX, 03] + '|' // Nome do Aprovador // 9
		cINFO += aEMail[nX, 04] + '|' // Codigo de Usuario do Aprovador // 10

		SC1->(DbGoTop())
		SC1->(DbSetOrder(1))
		SC1->(DbSeek(xFilial('SC1') + SC8->C8_NUMSC))
		cINFO += AllTrim(AllTrim(SC1->C1_CC)) + '|' // Codigo do Centro de Custo // 11

		PswOrder(1)
		If (PswSeek(AllTrim(SC1->C1_USER), .T.))
			aInfoUsu := PswRet(1)
			cHTML := StrTran(cHTML, '%WFNomeSol%', AllTrim(aInfoUsu[1, 4]))
		Else
			cHTML := StrTran(cHTML, '%WFNomeSol%', '')
		EndIf

		cHTML := StrTran(cHTML, '%WFDatEnv%', DtoC(Date()) + ' ' + Time())
		cHTML := StrTran(cHTML, '%WFDtRank%', DtoC(Date()) + ' ' + Time())
		cHTML := StrTran(cHTML, '%WFNomApr%', aEMail[nX, 03])
		cHTML := StrTran(cHTML, '%WFUsrApr%', aEMail[nX, 04])
		cHTML := StrTran(cHTML, '%WFCCusto%', SC1->C1_CC)

		cINFO += DtoC(SC8->C8_VALIDA) + '|' // 12
		cINFO += DtoC(Date()) + ' ' + Time() + '|' // 13

		If (Select('WFDADOS') > 0)
			WFDADOS->(DbCloseArea())
		EndIf
		cQry := 'SELECT SC8.C8_NUM, SC8.C8_FORNECE, SC8.C8_LOJA, SC8.C8_PRAZO, SC8.C8_COND, SC8.C8_CONTATO, SUM(SC8.C8_VALFRE) C8_TOTFRE, SUM(SC8.C8_TOTAL) C8_TOTCOT, SUM(SC8.C8_VALIPI) C8_TOTIPI, SUM(SC8.C8_VALICM) C8_TOTICM,'
		cQry += 'SUM(SC8.C8_VLDESC) C8_VLDESC, SUM(SC8.C8_DESPESA) C8_DESPESA, SUM(SC8.C8_SEGURO) C8_SEGURO '
		cQry += 'FROM ' + RetSQLName('SC8') + ' SC8 '
		cQry += "WHERE SC8.C8_NUM = '" + cNumCOT + "' "
		cQry += "AND SC8.C8_FILIAL = '" + cFilCOT + "' "
		cQry += "AND SC8.D_E_L_E_T_ = '' "
		cQry += 'GROUP BY SC8.C8_NUM, SC8.C8_FORNECE, SC8.C8_LOJA, SC8.C8_PRAZO, SC8.C8_COND, SC8.C8_CONTATO '
		cQry += 'ORDER BY SC8.C8_NUM, SC8.C8_FORNECE, SC8.C8_LOJA'
		TCQuery cQry New ALIAS 'WFDADOS'
		WFDADOS->(DbGoTop())
		nCountFor := 0
		While !WFDADOS->(Eof())
			nCountFor++

			cHTML := StrTran(cHTML, '%WFPrcTot' + AllTrim(Str(nCountFor)) + '%', Transform(((WFDADOS->C8_TOTCOT + WFDADOS->C8_TOTFRE + WFDADOS->C8_TOTIPI + WFDADOS->C8_DESPESA + WFDADOS->C8_SEGURO) - WFDADOS->C8_VLDESC), '@E 9,999,999.99'))
			cHTML := StrTran(cHTML, '%WFVlFor' + AllTrim(Str(nCountFor)) + '%', AllTrim(Transform(((WFDADOS->C8_TOTCOT + WFDADOS->C8_TOTFRE + WFDADOS->C8_TOTIPI + WFDADOS->C8_DESPESA + WFDADOS->C8_SEGURO) - WFDADOS->C8_VLDESC), '@E 9999999.99')))
			cHTML := StrTran(cHTML, '%WFPrazo' + AllTrim(Str(nCountFor)) + '%', Transform(WFDADOS->C8_PRAZO, '@E 999') + ' DIAS')
			cHTML := StrTran(cHTML, '%WFFrete' + AllTrim(Str(nCountFor)) + '%', Transform(WFDADOS->C8_TOTFRE, '@E 9,999,999.99'))
			cHTML := StrTran(cHTML, '%WFIPI' + AllTrim(Str(nCountFor)) + '%', Transform(WFDADOS->C8_TOTIPI, '@E 9,999,999.99'))
			cHTML := StrTran(cHTML, '%WFICMS' + AllTrim(Str(nCountFor)) + '%', Transform(WFDADOS->C8_TOTICM, '@E 9,999,999.99'))

			/*/ Condicao de pagamento /*/
			SE4->(DbSetOrder(1))
			If SE4->(DbSeek(xFilial('SE4') + WFDADOS->C8_COND))
				cHTML := StrTran(cHTML, '%WFCPag' + AllTrim(Str(nCountFor)) + '%', SE4->E4_CODIGO + ' - ' + AllTrim(SE4->E4_DESCRI))
			EndIf

			cHTML := StrTran(cHTML, '%WFContato' + AllTrim(Str(nCountFor)) + '%', AllTrim(WFDADOS->C8_CONTATO))

			WFDADOS->(DbSkip())
		End

		/*/ Realiza a avaliacao dos fornecedores /*/
		cProdAval := SubStr(cProdAval, 1, (Len(cProdAval) - 1))

		If (Select('WFAVALa') > 0)
			WFAVALa->(DbCloseArea())
		EndIf
		cQry := 'SELECT DISTINCT C8_FORNECE, C8_LOJA '
		cQry += 'FROM ' + RetSQLName('SC8') + ' SC8 '
		cQry += "WHERE SC8.C8_NUM = '" + cNumCOT + "' "
		cQry += "AND SC8.C8_FILIAL = '" + cFilCOT + "' "
		cQry += "AND SC8.D_E_L_E_T_ = '' "
		cQry += 'ORDER BY SC8.C8_FORNECE, SC8.C8_LOJA '
		TCQuery cQry New ALIAS 'WFAVALa'
		WFAVALa->(DbGoTop())
		nCountAvl := 0
		While !WFAVALa->(Eof())
			nCountAvl++
			If (Select('WFAVALb') > 0)
				WFAVALb->(DbCloseArea())
			EndIf
			cQry := 'SELECT (SUM(A5_NOTA) / COUNT(A5_PRODUTO)) AVGNOTA '
			cQry += 'FROM ' + RetSQLName('SA5') + ' SA5 '
			cQry += "WHERE SA5.A5_FORNECE = '" + WFAVALa->C8_FORNECE + "' "
			cQry += "AND SA5.A5_LOJA = '" + WFAVALa->C8_LOJA + "' "
			cQry += "AND SA5.A5_PRODUTO IN(" + cProdAval + ") "
			TCQuery cQry New ALIAS 'WFAVALb'
			WFAVALb->(DbGoTop())
			If !WFAVALb->(Eof())
				cHTML := StrTran(cHTML, '%WFAval' + StrZero(nCountAvl, 1) + '%', 'NOTA: ' + StrZero(WFAVALb->AVGNOTA, 1))
			EndIf
			WFAVALa->(DbSkip())
		End

		If (nCountFor < 5)
			For nZ := 1 To (5 - nCountFor)
				cHTML := StrTran(cHTML, '%WFPrcTot' + StrZero((nCountFor + nZ), 1) + '%', '')
				cHTML := StrTran(cHTML, '%WFVlFor' + StrZero((nCountFor + nZ), 1) + '%', '0')
				cHTML := StrTran(cHTML, '%WFPrazo' + StrZero((nCountFor + nZ), 1) + '%', '')
				cHTML := StrTran(cHTML, '%WFFrete' + StrZero((nCountFor + nZ), 1) + '%', '')
				cHTML := StrTran(cHTML, '%WFIPI' + StrZero((nCountFor + nZ), 1) + '%', '')
				cHTML := StrTran(cHTML, '%WFICMS' + StrZero((nCountFor + nZ), 1) + '%', '')
				cHTML := StrTran(cHTML, '%WFCPag' + StrZero((nCountFor + nZ), 1) + '%', '')
				cHTML := StrTran(cHTML, '%WFContato' + StrZero((nCountFor + nZ), 1) + '%', '')
				cHTML := StrTran(cHTML, '%WFAval' + StrZero((nCountFor + nZ), 1) + '%', '')
			Next
		EndIf

		cHTML := StrTran(cHTML, '<itens>', '')
		cHTML := StrTran(cHTML, '<rankant>', '')
		Case (nOpc == 5)
		/*/ Verifica e cria as pastas necessarias /*/
		MakeDir('\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\cotacao')
		MakeDir('\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\upload')
		MakeDir('\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\cotacao\' + aEMail[nX, 4])
		MakeDir('\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\cotacao\' + aEMail[nX, 4] + '\html')
		MakeDir('\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\cotacao\' + aEMail[nX, 4] + '\eml')
		MakeDir('\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\cotacao\' + aEMail[nX, 4] + '\rankeados')

		/*/ Cria o arquivo HTML /*/
		cDirSRV := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\cotacao\' + aEmail[nX, 4] + '\html\'
		cDSrvUP := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\upload\'

		cArqHTM := 'mc' + cEmpAnt + AllTrim(cFilAnt) + AllTrim(aEMail[nX, 04]) + cNumCOT + '.php'
		cArqINF := 'mc' + cEmpAnt + AllTrim(cFilAnt) + AllTrim(aEMail[nX, 04]) + cNumCOT + '.inf'

		cINFO += '<a href="' + cHost + 'aprvs/' + aEMail[nX, 04] + '/pen/' + cArqHTM + '">ABRIR</a>' + '|' // 14
		cINFO += oProcess:fProcessID + '|' // 15
		cINFO += 'mc|' // 16
		cINFO += '|' // 17
		cINFO += '|' // 18
		cINFO += '' // 19

		nHdl := fCreate(cDirSRV + cArqHTM)
		nHd2 := fCreate(cDirSRV + cArqINF)
		nHd3 := fCreate(cDSrvUP + cArqHTM)
		nHd4 := fCreate(cDSrvUP + cArqINF)

		*'Yttalo P. Martins 13/03/15-INICIO--------------------------------------------------------'*
		/*
		If (nHdl == -1)
		MsgAlert('O arquivo de nome: ' + cDirSRV + cArqHTM + ' nao pode ser criado! Verifique os previlegios de gravacao.' + Chr(13) +;
		'Informe ao SUPORTE de TI', 'Atencao!')
		Return
		EndIf
		If (nHd2 == -1)
		MsgAlert('O arquivo de nome: ' + cDirSRV + cArqINF + ' nao pode ser criado! Verifique os previlegios de gravacao.' + Chr(13) +;
		'Informe ao SUPORTE de TI', 'Atencao!')
		Return
		EndIf
		If (nHd3 == -1)
		MsgAlert('O arquivo de nome: ' + cDSrvUP + cArqHTM + ' nao pode ser criado! Verifique os previlegios de gravacao.' + Chr(13) +;
		'Informe ao SUPORTE de TI', 'Atencao!')
		Return
		EndIf
		If (nHd4 == -1)
		MsgAlert('O arquivo de nome: ' + cDSrvUP + cArqINF + ' nao pode ser criado! Verifique os previlegios de gravacao.' + Chr(13) +;
		'Informe ao SUPORTE de TI', 'Atencao!')
		Return
		EndIf
		*/
		If (nHdl == -1)

			_lRet := .F.

			IF !l160Auto

				MsgAlert('O arquivo de nome: ' + cDirSRV + cArqHTM + ' nao pode ser criado! Verifique os previlegios de gravacao.' + Chr(13) +;
				'Informe ao SUPORTE de TI.', 'Atencao!')
			ELSE

				u_xConOut(Repl("-",80))
				u_xConOut('O arquivo de nome: ' + cDirSRV + cArqHTM + ' nao pode ser criado! Verifique os previlegios de gravacao. Informe ao SUPORTE de TI.! (MT160WF)')
				u_xConOut(Repl("-",80))			

			ENDIF

			Return
		EndIf
		If (nHd2 == -1)

			_lRet := .F.

			IF !l160Auto
				MsgAlert('O arquivo de nome: ' + cDirSRV + cArqINF + ' nao pode ser criado! Verifique os previlegios de gravacao.' + Chr(13) +;
				'Informe ao SUPORTE de TI.', 'Atencao!')
			ELSE
				u_xConOut(Repl("-",80))
				u_xConOut('O arquivo de nome: ' + cDirSRV + cArqINF + ' nao pode ser criado! Verifique os previlegios de gravacao. Informe ao SUPORTE de TI.! (MT160WF)')
				u_xConOut(Repl("-",80))			
			ENDIF

			Return
		EndIf
		If (nHd3 == -1)

			_lRet := .F.

			IF !l160Auto
				MsgAlert('O arquivo de nome: ' + cDSrvUP + cArqHTM + ' nao pode ser criado! Verifique os previlegios de gravacao.' + Chr(13) +;
				'Informe ao SUPORTE de TI.', 'Atencao!')
			ELSE
				u_xConOut(Repl("-",80))
				u_xConOut('O arquivo de nome: ' + cDSrvUP + cArqHTM + ' nao pode ser criado! Verifique os previlegios de gravacao. Informe ao SUPORTE de TI.! (MT160WF)')
				u_xConOut(Repl("-",80))			
			ENDIF

			Return
		EndIf
		If (nHd4 == -1)

			_lRet := .F.

			IF !l160Auto
				MsgAlert('O arquivo de nome: ' + cDSrvUP + cArqINF + ' nao pode ser criado! Verifique os previlegios de gravacao.' + Chr(13) +;
				'Informe ao SUPORTE de TI.', 'Atencao!')
			ELSE
				u_xConOut(Repl("-",80))
				u_xConOut('O arquivo de nome: ' + cDSrvUP + cArqINF + ' nao pode ser criado! Verifique os previlegios de gravacao. Informe ao SUPORTE de TI.! (MT160WF)')
				u_xConOut(Repl("-",80))			
			ENDIF

			Return
		EndIf				
		*'Yttalo P. Martins 13/03/15-FIM----------------------------------------------------------'*

		/*/ Grava os dados no arquivo /*/
		fWrite(nHdl, cHTML, Len(cHTML))
		fWrite(nHd2, cINFO, Len(cINFO))
		fWrite(nHd3, cHTML, Len(cHTML))
		fWrite(nHd4, cINFO, Len(cINFO))

		/*/ Fecha o arquivo /*/
		fClose(nHdl)
		fClose(nHd2)
		fClose(nHd3)
		fClose(nHd4)

		/*/ Verifica se o conteudo do arquivo foi gravado como esperado /*/
		FT_FUse(cDirSRV + cArqINF)
		FT_FGoTop()

		aDadosArq := {}

		While !FT_FEof()
			cLinTxt := FT_FReadln()
			If Empty(cLinTxt)
				FT_FSkip()
				Loop
			EndIf
			aAdd(aDadosArq, TxtToArr(cLinTxt, '|'))
			FT_FSkip()
		End

		/*/ Fecha o arquivo aberto /*/
		FT_FUse()

		If (Len(aDadosArq[1]) <> 20)

			*'Yttalo P. Martins 13/03/15-INICIO----------------------------------------------------------'*
			/*
			fErase(cDirSRV + cArqINF)
			fErase(cDSrvUP + cArqINF)

			nHd2 := fCreate(cDirSRV + cArqINF)
			nHd4 := fCreate(cDSrvUP + cArqINF)

			If (nHd2 == -1)
			MsgAlert('O arquivo de nome: ' + cDirSRV + cArqINF + ' nao pode ser criado! Verifique os previlegios de gravacao.' + Chr(13) +;
			'Informe ao SUPORTE de TI', 'Atencao!')
			Return
			Else
			fWrite(nHd2, cINFO, Len(cINFO))
			fClose(nHd2)
			EndIf
			If (nHd4 == -1)
			MsgAlert('O arquivo de nome: ' + cDSrvUP + cArqINF + ' nao pode ser criado! Verifique os previlegios de gravacao.' + Chr(13) +;
			'Informe ao SUPORTE de TI', 'Atencao!')
			Return
			Else
			fWrite(nHd4, cINFO, Len(cINFO))
			fClose(nHd4)
			EndIf
			*/
			_lRetFTP := .F.        
			nTryS    := 1
			while nTryS <= NTRYSEND

				_lArqINF  := IIF(_lArqINF, .T. ,IIF(fErase(cDirSRV + cArqINF)<>-1,.T.,.F.) )
				_lArqINF2 := IIF(_lArqINF2, .T. ,IIF(fErase(cDSrvUP + cArqINF)<>-1,.T.,.F.) )

				IF _lArqINF2 .AND. _lArqINF
					_lRetFTP := .T.
				ENDIF

				if ( !_lRetFTP )
					nTryS++
					sleep(5000)
				else
					exit
				endif								
			end

			IF !_lRetFTP
				_lRet := .F.
				RETURN
			ENDIF

			nHd2 := fCreate(cDirSRV + cArqINF)
			nHd4 := fCreate(cDSrvUP + cArqINF)
			If (nHd2 == -1)					

				_lRet := .F.

				IF !l150Auto
					MsgAlert('O arquivo de nome: ' + cDirSRV + cArqINF + ' nao pode ser criado! Verifique os previlegios de gravacao.' + Chr(13) +;
					'Informe ao SUPORTE de TI.', 'Atencao!')
				ELSE
					u_xConOut(Repl("-",80))
					u_xConOut('O arquivo de nome: ' + cDirSRV + cArqINF + ' nao pode ser criado! Verifique os previlegios de gravacao. Informe ao SUPORTE de TI.! (WFENVCOT)')
					u_xConOut(Repl("-",80))			
				ENDIF					

				Return

			Else
				fWrite(nHd2, cINFO, Len(cINFO))
				fClose(nHd2)
			EndIf
			If (nHd4 == -1)

				_lRet := .F.

				IF !l150Auto
					MsgAlert('O arquivo de nome: ' + cDSrvUP + cArqINF + ' nao pode ser criado! Verifique os previlegios de gravacao.' + Chr(13) +;
					'Informe ao SUPORTE de TI.', 'Atencao!')
				ELSE
					u_xConOut(Repl("-",80))
					u_xConOut('O arquivo de nome: ' + cDSrvUP + cArqINF + ' nao pode ser criado! Verifique os previlegios de gravacao. Informe ao SUPORTE de TI.! (WFENVCOT)')
					u_xConOut(Repl("-",80))			
				ENDIF					

				Return

			Else
				fWrite(nHd4, cINFO, Len(cINFO))
				fClose(nHd4)
			EndIf			
			*'Yttalo P. Martins 13/03/15-FIM----------------------------------------------------------'*
		EndIf

		cDSrvUP := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\upload\'

		*'Yttalo P. Martins 13/03/15-INICIO----------------------------------------------------------'*
		/*
		// Faz a leitura dos arquivos baixados.
		aDir(cDSrvUP + '*.*', aArqFTP)
		// Conexao no FnTP
		FTPDisconnect()
		If FTPConnect(cSrvFTP, nPortaFTP, cUsrFTP, cPswFTP)
		// Tipo de Transfer?ncia utilizada 0=ASCII; 1=BINARIO
		FTPSetType(1)
		// Verifica se existem arquivos para processar 
		For nK := 1 To Len(aArqFTP)
		// Posiciona no diretorio de destino no FTP
		If FTPDirChange(cDirFTP + 'aprvs/' + SubStr(aArqFTP[nK], 9, 6) + '/pen/')
		// Verifica se existem arquivos para processar
		// Envia o formulario para o FTP
		If FTPUpload(cDSrvUP + aArqFTP[nK], cDirFTP + 'aprvs/' + SubStr(aArqFTP[nK], 9, 6) + '/pen/' + Lower(aArqFTP[nK]))
		fErase(cDSrvUP + Lower(aArqFTP[nK]))
		EndIf
		EndIf
		Next
		EndIf
		FTPDisconnect()
		*/

		// Faz a leitura dos arquivos baixados.
		aArqFTP := Directory(cDSrvUP + '*.*')

		For nK := 1 To Len(aArqFTP)

			_lRetFTP := .F.        
			nTryS    := 1
			while nTryS <= NTRYSEND

				If FTPConnect(cSrvFTP, nPortaFTP, cUsrFTP, cPswFTP)
					// Tipo de Transfer?ncia utilizada 0=ASCII; 1=BINARIO
					FTPSetType(1)

					// Posiciona no diretorio de destino no FTP
					_cArqTemp2:= cDirFTP + 'aprvs/' + SubStr(aArqFTP[nK][1], 9, 6) + '/pen/'

					If FTPDirChange(cDirFTP + 'aprvs/' + SubStr(aArqFTP[nK][1], 9, 6) + '/pen/')
						// Verifica se existem arquivos para processar
						// Envia o formulario para o FTP
						If FTPUpload(cDSrvUP + aArqFTP[nK][1], cDirFTP + 'aprvs/' + SubStr(aArqFTP[nK][1], 9, 6) + '/pen/' + Lower(aArqFTP[nK][1]))

							aRetDir := FTPDirectory('*.*',)

							For nL := 1 To Len(aRetDir)
								If Lower(aRetDir[nL][1]) == Lower(aArqFTP[nK][1])
									If aRetDir[nL][2] <> aArqFTP[nK][2]//verifica se arquivo no ftp possui tamanho igual ao servidor do protheus
										_lRetFTP := FTPErase(cDirFTP + 'aprvs/' + SubStr(aArqFTP[nK][1], 9, 6) + '/pen/' + Lower(aArqFTP[nK][1]))//apaga o arquivo corrompido

									ELSE
										//SE O UPLOAD OCORREU COM SUCESSO DELETA ARQUIVO DE ORIGEM
										_lRetFTP := IIF(fErase(cDSrvUP + Lower(aArqFTP[nK][1]) )<>-1,.T.,.F.)
										_cArqTemp := cDSrvUP + Lower(aArqFTP[nK][1])

									EndIf

									EXIT

								EndIf
							Next nL

						EndIf

					Else

						_lRet := .F.

						IF !l150Auto
						//	MsgAlert('Falha ao posicionar no diretorio de destino no FTP: ' + _cArqTemp2 + '! Envio de workflow cancelado! (WFENVCOT)' , 'Atencao!')
						ELSE
						//	u_xConOut(Repl("-",80))
						//	u_xConOut('Falha ao posicionar no diretorio de destino no FTP: ' + _cArqTemp2 + '! Envio de workflow cancelado! (WFENVCOT)')
						//	u_xConOut(Repl("-",80))			
						ENDIF

						FTPDisconnect()											

						Return

					EndIf

					FTPDisconnect()

				ENDIF

				if ( !_lRetFTP )
					nTryS++
					sleep(5000)
				else
					exit
				endif								
			end

			IF !_lRetFTP

				_lRet := .F.

				IF !l150Auto
					MsgAlert('Falha no upload do arquivo: ' + _cArqTemp + ' para o ftp! Envio de workflow cancelado! (WFENVCOT)' , 'Atencao!')
				ELSE
					u_xConOut(Repl("-",80))
					u_xConOut('Falha no upload do arquivo: ' + _cArqTemp + ' para o ftp! Envio de workflow cancelado! (WFENVCOT)')
					u_xConOut(Repl("-",80))			
				ENDIF					

				Return						
			ENDIF

		Next

		*'Yttalo P. Martins 13/03/15-FIM-------------------------------------------------------------'*

	EndCase

Return


/*
***************************************************************************************************
*** Funcao: TxtToArr   -   Autor: Leonardo Pereira   -   Data: 02/12/2010                       ***
*** Descricao: Faz a leitura da linha do arquivo texto e adiciona em um array.                  ***
***************************************************************************************************
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

/*
***************************************************************************************************
*** Funcao: WFGAPRCOT   -   Autor: Leonardo Pereira   -   Data:                                 ***
*** Descricao: Realiza a geracao dos registros de controle de aprovacao para o mapa de cotacao  ***
***************************************************************************************************
*/
Static Function WFGAprCot()

	Local nMinFor := GetMV('MV_MINFWF')
	Local nVlrFree := GetMV('MV_VLFREWF')
	Local cGrupo	:= ""
	Local xT := 0
	Local n_x := 0
	/*/ Totaliza a QTD de forncedores na cotacao /*/
	If (Select('WFQTDFOR') > 0)
		WFQTDFOR->(DbCloseArea())
	EndIf
	cQry := 'SELECT COUNT(*) QTDFOR '
	cQry += 'FROM (SELECT DISTINCT C8_FORNECE, C8_LOJA '
	cQry += 'FROM ' + RetSQLName('SC8') + ' '
	cQry += "WHERE C8_NUM = '" + cNumCOT + "' "
	cQry += "AND C8_FILIAL = '" + cFilCOT + "' AND D_E_L_E_T_ = ' ') A "
	TCQuery cQry New ALIAS 'WFQTDFOR'
	WFQTDFOR->(DbGoTop())
	If !WFQTDFOR->(Eof())
		/*/ Gera codigo do formulario HTML, para os ITENS do pedido/*/
		nQtdFor := WFQTDFOR->QTDFOR
	EndIf

	/*/ Busca o maior valor da cotacao /*/
	If (Select('WFMAXVL') > 0)
		WFMAXVL->(DbCloseArea())
	EndIf
	
	cQry := 'SELECT MAX(A.C8_TOTAL) MAXVLCOT '
	
	//	cQry += 'FROM (SELECT SUM(C8_TOTAL) C8_TOTAL '
	cQry += 'FROM (SELECT SUM(C8_TOTAL+C8_VALFRE) C8_TOTAL '
	cQry += 'FROM ' + RetSQLName('SC8') + ' '
	cQry += "WHERE C8_NUM = '" + cNumCOT + "' "
	cQry += "AND C8_FILIAL = '" + cFilCOT + "' and D_E_L_E_T_ = ' ' "
	cQry += 'GROUP BY C8_FORNECE, C8_LOJA) A '
	TCQuery cQry New ALIAS 'WFMAXVL'
	WFMAXVL->(DbGoTop())
	If !WFMAXVL->(Eof())
		/*/ Gera codigo do formulario HTML, para os ITENS do pedido/*/
		nMaxVlr := WFMAXVL->MAXVLCOT
	EndIf

	SC8->(DbGoTop())
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(xFilial('SC8') + cNumCOT))

	SCR->(DbGoTop())
	SCR->(DbSetOrder(2))
	If SCR->(DbSeek(xFilial('SCR') + 'MC' + SC8->C8_NUM + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))))
		While !SCR->(Eof()) .And. (SCR->CR_TIPO == 'MC') .And. (AllTrim(SCR->CR_NUM) == cNumCOT)
			RecLock('SCR', .F.)
			DbDelete()
			SCR->(MsUnLock())
			SCR->(DbSkip())
		End
	EndIf

	aV := {}
	
	SC1->(DbSetOrder(1))
	If SC1->(DbSeek(xFilial('SC1') + SC8->C8_NUMSC))
		/*
		CTT->(DbGoTop())
		CTT->(DbSetorder(1))
		If CTT->(DbSeek(xFilial('CTT') + SC1->C1_CC))
		*/
		/*
		cGrupo := u_RetGrpCC(SC1->C1_CC)
		If !Empty(AllTrim(cGrupo )) //CTT->CTT_XGPCMP
			If ((nMaxVlr > nVlrFree) .And. (nQtdFor >= nMinFor)) // Controla por alcada
				SAL->(DbGoTop())
				SAL->(DbSetOrder(2))
				If SAL->(DbSeek(xFilial('SAL') + AllTrim(cGrupo ))) //CTT->CTT_XGPCMP
					While !SAL->(Eof()) .And. (SAL->AL_COD == AllTrim(cGrupo )) //CTT->CTT_XGPCMP
						SAK->(DbGoTop())
						SAK->(DbSetOrder(1))
						If SAK->(DbSeek(xFilial('SAK') + SAL->AL_APROV))
							If (nMaxVlr >= SAK->AK_LIMMIN) .And. (nMaxVlr <= SAK->AK_LIMMAX)
								RecLock('SCR', .T.)
								SCR->CR_FILIAL := SC8->C8_FILIAL
								SCR->CR_NUM := SC8->C8_NUM
								SCR->CR_TIPO := 'MC'
								SCR->CR_USER := SAL->AL_USER
								SCR->CR_APROV := SAL->AL_APROV
								SCR->CR_NIVEL := SAL->AL_NIVEL
								SCR->CR_STATUS := '02'
								SCR->CR_EMISSAO := dDataBase
								SCR->CR_TOTAL := nMaxVlr
								SCR->(MsUnLock())
							EndIf
						EndIf
						SAL->(DbSkip())
					End
				EndIf
			ElseIf (nMaxVlr <= nVlrFree)
				// Procura gestor(es) do proximo nivel 
				SAL->(DbGoTop())
				SAL->(DbSetOrder(2))
				If SAL->(DbSeek(xFilial('SAL') + AllTrim(cGrupo ))) //CTT->CTT_XGPCMP
					While !SAL->(Eof()) .And. (SAL->AL_COD == AllTrim(cGrupo )) //CTT->CTT_XGPCMP
						SAK->(DbGoTop())
						SAK->(DbSetOrder(1))
						If SAK->(DbSeek(xFilial('SAK') + SAL->AL_APROV))
							If (nMaxVlr >= SAK->AK_LIMMIN) .And. (nMaxVlr <= SAK->AK_LIMMAX)
								RecLock('SCR', .T.)
								SCR->CR_FILIAL := SC8->C8_FILIAL
								SCR->CR_NUM := SC8->C8_NUM
								SCR->CR_TIPO := 'MC'
								SCR->CR_USER := SAL->AL_USER
								SCR->CR_APROV := SAL->AL_APROV
								SCR->CR_NIVEL := SAL->AL_NIVEL
								SCR->CR_STATUS := '02'
								SCR->CR_EMISSAO := dDataBase
								SCR->CR_TOTAL := nMaxVlr
								SCR->CR_WFID := SC8->C8_WFID
								SCR->(MsUnLock())
							EndIf
						EndIf
						SAL->(DbSkip())
					End
				EndIf
			ElseIf ((nMaxVlr > nVlrFree) .And. (nQtdFor < nMinFor))
				// Procura gestor(es) do proximo nivel 
				SAL->(DbGoTop())
				SAL->(DbSetOrder(2))
				If SAL->(DbSeek(xFilial('SAL') + AllTrim(cGrupo ))) //CTT->CTT_XGPCMP
					While !SAL->(Eof()) .And. (SAL->AL_COD == AllTrim(cGrupo )) //CTT->CTT_XGPCMP
						// Excecao do presidente 
						If (AllTrim(SAL->AL_USER) == '000150')
							SAL->(DbSkip())
							Loop
						EndIf
						RecLock('SCR', .T.)
						SCR->CR_FILIAL := SC8->C8_FILIAL
						SCR->CR_NUM := SC8->C8_NUM
						SCR->CR_TIPO := 'MC'
						SCR->CR_USER := SAL->AL_USER
						SCR->CR_APROV := SAL->AL_APROV
						SCR->CR_NIVEL := SAL->AL_NIVEL
						SCR->CR_STATUS := '02'
						SCR->CR_EMISSAO := dDataBase
						SCR->CR_TOTAL := nMaxVlr
						SCR->CR_WFID := SC8->C8_WFID
						SCR->(MsUnLock())
						SAL->(DbSkip())
					End
				EndIf
			EndIf
			*/
			/*
			DbSelectArea("SY1")
			SY1->(DbSetOrder(3))
			If SY1->(DbSeek(xFilial("SY1") + SC8->C8_XUSER))
				
				If !Empty(SY1->Y1_XRESP)
					SY1->(DbSetOrder(1))
					If SY1->(DbSeek(SubSTR(cXFil,1,2)+"  " + SY1->Y1_XRESP))
						cxcod	:= SY1->Y1_USER //SY1->Y1_COD
					EndIf
				Else
					cxcod	:=  SY1->Y1_USER //SY1->Y1_COD                              
				EndIf
				
			Else
				cxcod	:= ""
				MsgAlert('Nao existe solicitante vinculado a esse usuário favor revisar cadastro.' + Chr(13) +;
				'WORKFLOW, nao foi disparado!' + Chr(10) +;
				'Faca a associacao e ENVIE novamente o workflow.', 'Atencao!')	
				Return
			EndIf				                            
			*/
			
			cXCod := SC8->C8_XUSER
			xV:={cXCod}         
			
	        For xT := 1 to Len(xV) 
				dbSelectArea("SAK")
				dbSetOrder(2)
				If dbSeek(xFilial("SAK")+xV[xT])
					nPx := aScan(aV,{|x|AllTrim(x[2])==AllTrim(SAK->AK_USER) } )
					If  nPx == 0 .OR. (nPx > 0	.AND. Val(av[nPx][3]) < 1)
						aAdd(aV, { SAK->AK_COD, SAK->AK_USER, AllTRIM(STRZERO(xT,TamSX3("CR_NIVEL")[1])) })
					Endif
				Endif                
			Next xT
			
		/*
		Else
			MsgAlert('Nao existe GRUPO DE APROVACAO associado ao CENTRO DE CUSTO: ' + AllTrim(SC1->C1_CC) + '.' + Chr(13) +;
			'WORKFLOW, nao foi disparado!' + Chr(10) +;
			'Faca a associacao e ENVIE novamente o workflow.', 'Atencao!')
		EndIf
        */
		If Len(aV) > 0
		
			aV := aSort(aV,,,{|x,y| x[3] < y[3]})					   
		
			For n_x := 1 to Len(aV)
			
				Reclock("SCR",.T.)
				SCR->CR_FILIAL := SC8->C8_FILIAL
				SCR->CR_NUM := SC8->C8_NUM
				SCR->CR_TIPO := 'MC'
				SCR->CR_NIVEL	:= aV[n_x][3]
				SCR->CR_USER	:= aV[n_x][2]
				SCR->CR_APROV	:= aV[n_x][1]
				SCR->CR_STATUS	:= If(aV[n_x][3]=="01",'02','01') 
				SCR->CR_TOTAL	:= nMaxVlr
				SCR->CR_EMISSAO := dDatabase
				SCR->CR_WFID 	:= SC8->C8_WFID
				SCR->(MsUnlock())

			next n_x     
		Else
			MsgAlert('Nao existe Aprovador associado a esse solicitante favor revisar cadastro.' + Chr(13) +;
			'WORKFLOW, nao foi disparado!' + Chr(10) +;
			'Faca a associacao e ENVIE novamente o workflow.', 'Atencao!')			
		Endif	

	Endif	

Return

/*
****************************************************************************************************
*** Funcao: PNVALOBS   -   Autor: Leonardo Pereira   -   Data:                                   ***
*** Descricao:                                                                                   ***
****************************************************************************************************
*/
Static Function PNValObs()

	Local lRet := .F.
	Local nMaxVlr := 0
	Local nMinFor := GetMV('MV_MINFWF')
	Local nVlrFree := GetMV('MV_VLFREWF')

	If (Select('WFFORN') > 0)
		WFFORN->(DbCloseArea())
	EndIf
	cQry := 'SELECT DISTINCT C8_FORNECE, C8_LOJA '
	cQry += 'FROM ' + RetSQLName('SC8') + ' SC8 '
	cQry += "WHERE SC8.C8_NUM = '" + cNumCOT + "' "
	cQry += "AND SC8.C8_FILIAL = '" + cFilCOT + "' "
	cQry += "AND SC8.D_E_L_E_T_ = '' "
	cQry += 'ORDER BY C8_FORNECE, C8_LOJA '
	TCQuery cQry New ALIAS 'WFFORN'
	WFFORN->(DbGoTop())
	nCountFor := 0
	While !WFFORN->(Eof())
		nCountFor++
		WFFORN->(DbSkip())
	End
	DbSelectArea("WFFORN")
	DbCloseArea()

	/*/ Busca o maior valor da cotacao /*/
	If (Select('WFMAXVL') > 0)
		WFMAXVL->(DbCloseArea())
	EndIf
	
	cQry := 'SELECT MAX(A.C8_TOTAL) MAXVLCOT '
 '
	cQry += 'FROM (SELECT SUM(C8_TOTAL+C8_VALFRE) C8_TOTAL  '
	cQry += 'FROM ' + RetSQLName('SC8') + ' '
	cQry += "WHERE C8_NUM = '" + cNumCOT + "' "
	cQry += "AND C8_FILIAL = '" + cFilCOT + "' and D_E_L_E_T_ = ' ' "
	cQry += 'GROUP BY C8_FORNECE, C8_LOJA) A '
	TCQuery cQry New ALIAS 'WFMAXVL'
	WFMAXVL->(DbGoTop())
	If !WFMAXVL->(Eof())
		/*/ Gera codigo do formulario HTML, para os ITENS do pedido/*/
		nMaxVlr := WFMAXVL->MAXVLCOT
	EndIf
	DbSelectArea("WFMAXVL")
	DbCloseArea()



	If (nCountFor >= nMinFor) 
		lRet := .T.
		oBtn1:lReadOnly := .F.
		oBtn1:Refresh()
	Else

		If !(Empty(cMsgComp))
			lRet := .T.
			oBtn1:lReadOnly := .F.
			oBtn1:Refresh()
		Else 
			If nMaxVlr >  nVlrFree

				MsgAlert('Por favor, PREENCHA o campo OBSERVACOES, justificando nao haver a quantidade minima de fornecedores cotados!')
				oBtn1:lReadOnly := .F.
				oBtn1:Refresh()
			Else

				lRet := .T.
				oBtn1:lReadOnly := .F.
				oBtn1:Refresh()
			Endif

		EndIf                                
	EndIf                                    


	If lREt
	//	lRet :=	EnvCotVal()	
		oBtn1:lReadOnly := .F.
		oBtn1:Refresh()
	Endif		

Return(lRet)
