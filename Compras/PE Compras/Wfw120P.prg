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
*****************************************************************************************************
*** Funcao: WFW120P   -   Autor: Leonardo Pereira   -   Data:                                     ***
*** Descricao: Ponto de entrada para envio de Workflow para aprovacao do pedido de compras        ***
*****************************************************************************************************
*/
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAutoLË+LË+¿
//³Autor: Yttalo P. Martins                                ³
//³Data: 07/07/15                                          ³
//³Gestão da permissao de envio do workflow quando da falha³ 
//e quando do tamanho do arquivo apos transferencia        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAutoÙ
ENDDOC*/
User Function WFW120P(cNivAtu, nExec)

	Local aAreaSC1 := SC1->(GetArea())
	Local aAreaSC7 := SC7->(GetArea())
	Local aAreaSC8 := SC8->(GetArea())
	Local aAreaSCE := SCE->(GetArea())
	Local aAreaSM0 := SM0->(GetArea())

	Local _lRet := .T.
	//Local nX := 0

	Private cHTML := ''
	Private cArqHTM := ''
	Private cINFO := ''
	Private cArqINF := ''
	Private lAmbProd := (Upper(AllTrim(GetEnvServer())) $ AllTrim(GetMV('MV_XAMBIENT')))
	Private cHost := ''
	Private WFProcessID := ''
	Private lEnd := .F.
	Private oProcess, cCodProcesso, cAssunto
	Private cNumPed := ""
	Private cCodFor := ""
	Private cLojFor := ""
	Private cTipFre := ""
	Private cUserFullName:=UsrFullName(SC7->C7_USER)

	Default nExec := 1

	cNumPed := SC7->C7_NUM
	cCodFor := SC7->C7_FORNECE
	cLojFor := SC7->C7_LOJA
	cTipFre := SC7->C7_TPFRETE

	If lAmbProd
		cHost := 'http://centraldeaprovacao.portonovosa.com/portalcompras/' //'http://compras.portonovosa.com.br/workflow/'
	Else
		cHost := 'https://centraldeaprovacao.portonovosa.com/portalcomprashomolog/'                       
	EndIf

	If (AllTrim(FunName()) == 'CNTA120')
		Return
	EndIf
	If (AllTrim(FunName()) == 'CNTA121')
		Return
	EndIf

	cNivAtu := If((cNivAtu == Nil), 0, cNivAtu)

	/*/ C?digo extra?do do cadastro de processos. /*/
	cCodProcesso := 'APRPED'

	/*/ Assunto da mensagem /*/
	cAssunto := 'Aprovacao do pedido de compra'
	u_Wf120pAlc() //Trata cotacoes com menos de 3 fornecedores, envia para alçada full

	/*/ Coleta os codigos informados nos parametros /*/
	If (nExec == 1)
		Processa({ |lEnd| PCInicio(cNivAtu, nExec, @_lRet) }, 'WORKFLOW', 'Aguarde, Gerando dados...', .F.)
	Else
		PCInicio(cNivAtu, nExec, @_lRet)
	EndIf

	*'Yttalo P. Martins 13/03/15-INICIO--------------------------------------------------------'*
	If _lRet
		*'Yttalo P. Martins 13/03/15-FIM-----------------------------------------------------------'*	

		/*/ Posiciona na cotacao caso exista /*/
		cNumCO := ''
		cNumNat := ''

		SC8->(DbGoTop())
		SC8->(DbSetOrder(1))
		If SC8->(DbSeek(xFilial('SC8') + SC7->C7_NUMCOT))
			cNumCO := SC8->C8_XCO /*/ Conta orcamentaria /*/
			cNumNat := SC8->C8_XNAT /*/ Natureza financeira /*/
		Else
			cNumCO := SC7->C7_XCO /*/ Conta orcamentaria /*/
			cNumNat := SC7->C7_XNAT /*/ Natureza financeira /*/
		EndIf

		/*/ Assinala o ID do processo /*/
		SC7->(DbGoTop())
		SC7->(DbSetOrder(1))
		SC7->(DbSeek(xFilial('SC7') + cNumPed))
		While !SC7->(Eof()) .And. (xFilial('SC7') == SC7->C7_FILIAL .And. cNumPed == SC7->C7_NUM .And. cCodFor == SC7->C7_FORNECE .And. cLojFor = SC7->C7_LOJA)
			If SC7->(RecLock('SC7', .F.))
				SC7->C7_WFID := WFProcessID
				SC7->C7_XCO := cNumCO
				SC7->C7_XNAT := cNumNat
				SC7->(MsUnLock())
			EndIf
			SC7->(DbSkip())
		End

		*'Yttalo P. Martins 13/03/15-INICIO--------------------------------------------------------'*
	EndIf
	*'Yttalo P. Martins 13/03/15-FIM-----------------------------------------------------------'*		

	RestArea(aAreaSC1)
	RestArea(aAreaSC7)
	RestArea(aAreaSC8)
	RestArea(aAreaSCE)
	RestArea(aAreaSM0)

Return

/*
*********************************************************************************************************************************************
*** Funcao: PCInicio   -   Autor: Leonardo Pereira   -   Data: 01/11/2010                                                                 ***
*** Descricao: Coleta os dados do pedido, cria o processo e envia o workflow                                                              ***
*********************************************************************************************************************************************
*/
Static Function PCInicio(cNivAtu, nExec,_lRet)

	Local oFont2 := TFont():New('Courier New', Nil, 14, Nil, .F., Nil, Nil, Nil, Nil, .F., .F.)
	Local oFont3 := TFont():New('Verdana', Nil, 18, Nil, .F., Nil, Nil, Nil, Nil, .F., .F.)
	Local nTime := 1
	Local nLinEnt := 0
	Local nX := 0
	Private aEMail := {}
	Private nTotDesc := 0
	Private nTotIpi := 0
	Private nTotFrt := 0
	Private nTotIT := 0
	Private nTotPed := 0
	Private cMsgComp := ''
	Private cMsgPed := ''
	Private cSimbMoed:= ""

	Private aAmb   := {"S = Sim","N = Não"}
	Private ocombo := nIl
	Private cMsgGrv:= ""		
	Private cMsgEme:= ""

	/*/ Posiciona no primeiro item do pedido /*/
	SC7->(DbGoTop())
	SC7->(DbSetOrder(1))
	SC7->(DbSeek(xFilial('SC7') + cNumPed))
	If (AllTrim(FunName()) == 'CNTA121')
		Return
	EndIf

	cSimbMoed := AllTrim(GetMV('MV_SIMB' + AllTrim(Str(SC7->C7_MOEDA))))
	/*/ Coleta dados do(s) aprovador(es) /*/
	
	If (nExec == 1)
		/*/ Dialog para digitacao da mensagem do comprador /*/
		oDlg1 := MsDialog():New(000, 000, 550, 450, 'O B S E R V A C O E S',,,,,,,,, .T.)

		oGrp1 := TGroup():New(005, 002, 061, 225,' Observacoes para APROVADOR ', oDlg1,,, .T.)
		oTMultiGet1 := TMultiget():New(015, 006, {|u| If((PCount() > 0), cMsgComp := u, cMsgComp)}, oGrp1, 215, 040, oFont3, .F., RGB(000,000,000), RGB(255,255,255),, .T.,,, {|u| },,, .F., {|u| },,, .F., .T.)

		oGrp2 := TGroup():New(071, 002, 127, 225,' Observacoes para PEDIDO DE COMPRAS ', oDlg1,,, .T.)
		oTMultiGet2 := TMultiget():New(081, 006, {|u| If((PCount() > 0), cMsgPed := u, cMsgPed)}, oGrp2, 215, 040, oFont3, .F., RGB(000,000,000), RGB(255,255,255),, .T.,,, {|u| },,, .F., {|u| },,, .F., .T.)

		oSay:= TSay():New(137,02,{||'Emergencial'},oDlg1,,,,                  ,,.T.,CLR_RED,CLR_WHITE,80,20)
		cCombo:= aAmb[2]    
		oCombo := TComboBox():New(137,75,{|u|if(PCount()>0,cCombo:=u,cCombo)},aAmb,100,20,oDlg1,,{||},,,,.T.,,,,,,,,,'cCombo')

		oGrp3 := TGroup():New(152, 002, 208, 225,' Observacoes para EMERGÊNCIA ', oDlg1,,, .T.)
		oTMultiGet3 := TMultiget():New(162, 006, {|u| If((PCount() > 0), cMsgEme := u, cMsgEme)}, oGrp3, 215, 040, oFont3, .F., RGB(000,000,000), RGB(255,255,255),, .T.,,, {|u| },,, .F., {|u| },,, .F., .T.)

		/*/ Botoes /*/
		SButton():New(212, 198, 01, {|u| valEME() }, oDlg1, .T., 'Ok',)
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

		//cMsgPed := NoAcento(cMsgPed)
		If !(Empty(AllTrim(cMsgPed)))
			//			SC7->(DbGoTop())
			//			SC7->(DbSetOrder(1))
			//			SC7->(DbSeek(xFilial('SC7') + cNumPed))
			cMsgGrv := ''
			For nLinEnt := 1 To 99
				cStr := AllTrim(MemoLine(cMsgPed,, nLinEnt)) + ' '
				If Empty(cStr)
					Exit
				Else
					cMsgGrv += cStr
				EndIf
			Next

		EndIf     

		SC7->(DbGoTop())
		SC7->(DbSetOrder(1))
		SC7->(DbSeek(xFilial('SC7') + cNumPed))	
		RecLock('SC7', .F.)
		SC7->C7_XOBS := cMsgGrv
		SC7->(MsUnLock())

		cMsgGrv := ''
		If !(Empty(AllTrim(cMsgComp)))

			For nLinEnt := 1 To 99
				cStr := AllTrim(MemoLine(cMsgComp,, nLinEnt)) + ' '
				If Empty(cStr)
					Exit
				Else
					cMsgGrv += cStr
				EndIf
			Next

		EndIf

		SC7->(DbGoTop())
		SC7->(DbSetOrder(1))
		SC7->(DbSeek(xFilial('SC7') + cNumPed))	
		//cXAux := SC7->C7_OBS
		//cMsgGrv := AllTrim(cXAux+cMsgGrv)
		RecLock('SC7', .F.)		
		SC7->C7_XOBS2 := cMsgGrv
		SC7->(MsUnLock())


		If Empty(AllTrim(Upper(cCombo))) .OR. AllTrim(Upper(cCombo)) == "N"
			cCombo := "N"	
		Endif
		If !(Empty(AllTrim(cMsgEme))) .AND. AllTrim(Upper(cCombo)) == "S"
			SC7->(DbGoTop())
			SC7->(DbSetOrder(1))
			SC7->(DbSeek(xFilial('SC7') + cNumPed))
			cMsgGrv := ''
			For nLinEnt := 1 To 99
				cStr := AllTrim(MemoLine(cMsgEme,, nLinEnt)) + ' '
				If Empty(cStr)
					Exit
				Else
					cMsgGrv += cStr
				EndIf
			Next

			While !SC7->(Eof()) .And. (xFilial('SC7') == SC7->C7_FILIAL .And. cNumPed == SC7->C7_NUM .And. cCodFor == SC7->C7_FORNECE .And. cLojFor = SC7->C7_LOJA)

				RecLock('SC7', .F.)
				SC7->C7_XEMERGE := cCombo
				SC7->C7_XEMEOBS := cMsgGrv
				SC7->C7_XEMEDT := dDatabase
				SC7->C7_XEMEUSR :=cUserFullName

				SC7->(MsUnLock())
				SC7->(DbSkip())

			EnddO

		EndIf

		SC7->(DbGoTop())
		SC7->(DbSetOrder(1))
		SC7->(DbSeek(xFilial('SC7') + cNumPed))		


		SCR->(DbGoTop())
		SCR->(DbSetOrder(1))
		If SCR->(DbSeek(xFilial('SCR') + 'PC' + cNumPed))
			cNivel := Val(SCR->CR_NIVEL)
			While SCR->(!Eof()) .And. (xFilial('SCR') + 'PC' + cNumPed == SCR->CR_FILIAL + SCR->CR_TIPO + AllTrim(SCR->CR_NUM)) .And. (Val(SCR->CR_NIVEL) == cNIvel)
				SAK->(DbSetOrder(1))
				SAK->(DbSeek(xFilial('SAK') + SCR->CR_APROV))

				/*/ Coleta informacoes do usuario /*/
				PswOrder(1)
				If (PswSeek(AllTrim(SAK->AK_USER), .T.))
					aInfoUsu := PswRet(1)
					//aAdd(aEMail, {AllTrim(aInfoUsu[1, 14]), SAK->AK_COD, AllTrim(SAK->AK_NOME), SAK->AK_USER})
					aAdd(aEMail, {AllTrim(aInfoUsu[1, 14]), SAK->AK_COD, AllTrim(SAK->AK_NOME), SAK->AK_USER})
					//PARA TESTES
					//aAdd(aEMail, {AllTrim("fabio.regueira@portonovosa.com"), SAK->AK_COD, AllTrim(SAK->AK_NOME), SAK->AK_USER})
				EndIf
				SCR->(DbSkip())
			End
		EndIf
	ElseIf (nExec == 2)
		SCR->(DbGoTop())
		SCR->(DbSetOrder(1))
		If SCR->(DbSeek(xFilial('SCR') + 'PC' + cNumPed))
			lFirst := .T.
			While !SCR->(Eof()) .And. (xFilial('SCR') + 'PC' + cNumPed == SCR->CR_FILIAL + SCR->CR_TIPO + AllTrim(SCR->CR_NUM))
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
							aAdd(aEMail, {AllTrim(aInfoUsu[1, 14]), SAK->AK_COD, AllTrim(SAK->AK_NOME), SAK->AK_USER})
							//PARA TESTES
							//aAdd(aEMail, {AllTrim("fabio.regueira@portonovosa.com"), SAK->AK_COD, AllTrim(SAK->AK_NOME), SAK->AK_USER})
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
							aAdd(aEMail, {AllTrim(aInfoUsu[1, 14]), SAK->AK_COD, AllTrim(SAK->AK_NOME), SAK->AK_USER})
							//PARA TESTES
							//aAdd(aEMail, {AllTrim("fabio.regueira@portonovosa.com"), SAK->AK_COD, AllTrim(SAK->AK_NOME), SAK->AK_USER})
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

	If (Len(aEMail) > 0)

		Begin Transaction

			For nX := 1 To Len(aEMail)
				cINFO := ''
				IncProc('Gerando E-mail para o(s) aprovador(es)...')

				// Gera os processos do workflow e envia o e-mail
				U_WFEnvMsg(7,cFilant,aemail[nx][4],cNumPed,aemail[nx])
				//PedGeraWF(nExec, @_lRet)

				If !_lRet
					DisarmTransaction()
					Break
				EndIf			
			Next

		End Transaction

	Else

		IF !l120Auto

			MsgAlert('Nao foram encontrados APROVADORES para envio de workflow! (WFW120P)', 'Atencao!')

		ELSE

			u_xConOut(Repl("-",80))
			u_xConOut("Nao foram encontrados APROVADORES para envio de workflow! (WFW120P)")
			u_xConOut(Repl("-",80))

		ENDIF		

	EndIf	

Return

/*
*******************************************************************************************************************************************************
*******************************************************************************************************************************************************
*/
Static Function ValEME()

	If AllTrim(Upper(cCombo)) == "S" .AND. Empty(cMsgEme) 
		Alert("A observação emergencial deve ser preenchida para pedidos emergenciais")
	Else
		oDlg1:End()
	Endif

Return
/*
*******************************************************************************************************************************************************
Trata cotacoes com menos de 3 fornecedores, envia para alçada full
Ricardo Ferreira
Criare Consulting
17/07/2018
*******************************************************************************************************************************************************
*/

User Function Wf120pAlc()
	Local nTot := 0
	Local dEmiss 	:= SToD("")
	Local cGrupo	:= ""
	Local cFili 	:= ""
	Local cCRNum 	:= ""
	Local nCrMoeda 	:= 0
	Local nTxMoeda	:= 0
	 
	DbSelectArea("SC8")
	SC8->(DbSetOrder(1))
	If SC8->(DbSeek(xFilial('SC8') + SC7->C7_NUMCOT))

		If (Select('TMPQTD') > 0)
			TMPQTD->(DbCloseArea())
		EndIf
		/*
		//Criare Consulting
		//Alterado por Ricardo Ferreira em 17/07/2018
		cQry := 'SELECT COUNT(C8_FORNECE) QTDIT '
		cQry += 'FROM ' + RetSqlName('SC8') + " SC8 WHERE C8_FILIAL = '" + xFilial("SC8") + "' AND C8_NUM = '" + SC7->C7_NUMCOT +"' AND D_E_L_E_T_ = ' ' GROUP BY C8_FORNECE"
		*/

		cQry := "select count(*) QTDIT from  ("
		cQry +=	"						SELECT C8_FORNECE,C8_LOJA	" 
		cQry += "FROM " + RetSqlName('SC8') + " SC8 WHERE C8_FILIAL = '" + xFilial("SC8") + "' AND C8_NUM = '" + SC7->C7_NUMCOT +"' AND D_E_L_E_T_ = ' '" 
		cQry += "GROUP BY C8_FORNECE,C8_LOJA) A"

		TcQuery cQry New ALIAS 'TMPQTD'
		TMPQTD->(DbGoTop())	

		
		//Guarda as variaveis necessárias
		SCR->(DbGoTop())
		SCR->(DbSetOrder(1))
		If SCR->(DbSeek(xFilial('SCR') + 'PC' + SC7->C7_NUM))
			cFili := SCR->CR_FILIAL
			nTot := SCR->CR_TOTAL
			dEmiss := SCR->CR_EMISSAO
			cGrupo:= SCR->CR_GRUPO
			cCRNum	:=SCR->CR_NUM
			nCrMoeda 	:= SCR->CR_MOEDA
			nTxMoeda	:= SCR->CR_TXMOEDA
		Endif
			
		If (TMPQTD->QTDIT < 3 ) .and. nTot >= 500 //Se o valor a ser aprovado for maior ou igual a 500 e foi cotado com menos de 3 fornecedores. 
			
			/*
			//Criare Consulting
			//Alterado por Ricardo Ferreira em 17/07/2018
			cQry := ' SELECT * '
			cQry += ' FROM ' + RetSqlName('SAL') + " SAL WHERE AL_FILIAL = '" + xFilial("SAL") + "' AND AL_COD = '" + SC7->C7_APROV +"' AND D_E_L_E_T_ = ' ' AND AL_NIVEL IN ( 			" // alterado dia 05/07/2018 - havia erro na query (fabio)
			cQry += ' SELECT MAX(AL_NIVEL) FROM ' + RetSqlName('SAL') + " SAL WHERE AL_FILIAL = '" + xFilial("SAL") + "' AND AL_COD = '" + SC7->C7_APROV +"' AND D_E_L_E_T_ = ' ' ) " 
			*/
			cQry := " SELECT AL_USER,AL_APROV,AL_NIVEL "
			cQry += " FROM " + RetSqlName('SAL') + " SAL WHERE AL_FILIAL = '" + xFilial("SAL") + "' AND AL_COD = '" + SC7->C7_APROV +"' AND D_E_L_E_T_ = ' ' "
			cQry += " ORDER BY AL_NIVEL,AL_APROV" 
			TcQuery cQry New ALIAS 'TMPQTD2'
			TMPQTD2->(DbGoTop())		
			While (TMPQTD2->(!EoF()))
				//cNivel := Val(TMPQTD2->AL_NIVEL)
				/*
				//Criare Consulting
				//Alterado por Ricardo Ferreira em 17/07/2018
				cQry := 'SELECT * '
				cQry += ' FROM ' + RetSqlName('SCR') + " SCR WHERE CR_FILIAL = '" + xFilial("SCR") + "' AND CR_NUM = '" + SC7->C7_NUM +"' AND D_E_L_E_T_ = ' ' "
				cQry += " AND CR_NIVEL = '"+TMPQTD2->AL_NIVEL+"' AND CR_TIPO = 'PC' AND CR_USER = '"+TMPQTD2->AL_USER+"' AND CR_APROV = '"+TMPQTD2->AL_APROV+"' "   // alterado dia 05/07/2018 - havia erro na query (fabio)
				TcQuery cQry New ALIAS 'TMPQTD3'

				TMPQTD3->(DbGoTop())		
				If (TMPQTD3->(EoF()))
				DbSelectArea("SCR")
				RecLock("SCR",.F.)
				SCR->CR_FILIAL := cFili
				SCR->CR_NUM := SC7->C7_NUMCOT
				SCR->CR_TIPO := "PC"
				SCR->CR_USER := TMPQTD2->AL_USER
				SCR->CR_APROV := TMPQTD2->AL_APROV
				SCR->CR_NIVEL := TMPQTD2->AL_NIVEL
				SCR->CR_STATUS := "02"
				SCR->CR_TOTAL := nTot
				SCR->CR_EMISSAO := dEmiss
				SCR->CR_GRUPO := cGrupo					
				MsUnlock()
				Endif
				TMPQTD3->(DbCloseArea())
				*/
				cQry := "SELECT COUNT(*) QTDSCR"
				cQry += " FROM " + RetSqlName('SCR') + " SCR WHERE CR_FILIAL = '" + xFilial("SCR") + "' AND CR_NUM = '" + SC7->C7_NUM +"' AND D_E_L_E_T_ = ' ' "
				cQry += " AND CR_NIVEL = '"+TMPQTD2->AL_NIVEL+"' AND CR_TIPO = 'PC' AND CR_USER = '"+TMPQTD2->AL_USER+"' AND CR_APROV = '"+TMPQTD2->AL_APROV+"' "   

				TcQuery cQry New ALIAS 'TMPQTD3'

				If TMPQTD3->QTDSCR = 0 
					DbSelectArea("SCR")
					RecLock("SCR",.T.)
					SCR->CR_FILIAL := cFili
					SCR->CR_NUM 	:= cCRNum
					SCR->CR_TIPO 	:= "PC"
					SCR->CR_USER 	:= TMPQTD2->AL_USER
					SCR->CR_APROV 	:= TMPQTD2->AL_APROV
					SCR->CR_NIVEL 	:= TMPQTD2->AL_NIVEL
					SCR->CR_STATUS	:= "01" //aguardando liberação de niveis anteriores
					SCR->CR_TOTAL 	:= nTot
					SCR->CR_EMISSAO	:= dEmiss
					SCR->CR_GRUPO 	:= cGrupo	
					SCR->CR_MOEDA	:= nCrMoeda
					SCR->CR_TXMOEDA	:= nTxMoeda	 			
					MsUnlock()
				Endif
				DbSelectArea("TMPQTD3")
				DbCloseArea()

				TMPQTD2->(DbSkip())										
			EndDo
			DbSelectArea("TMPQTD2")
			DbCloseArea()
		EndIf	
		DbSelectArea("TMPQTD")	
		DbCloseArea()
	Endif
