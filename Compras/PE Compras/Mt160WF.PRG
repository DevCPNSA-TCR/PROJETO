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
******************************************************************************************************
*** Funcao: Mt160Wf   -   Autor: Leonardo Pereira   -   Data: 01/11/2010                           ***
*** Descricao: Ponto de entrada para envio de Workflow para aprovacao do pedido de compras         ***
******************************************************************************************************
*/
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAutoLË+LË+¿
//³Autor: Yttalo P. Martins                                ³
//³Data: 13/03/15                                          ³
//³Gestão da permissao de envio do workflow quando da falha³ 
//e quando do tamanho do arquivo apos transferencia        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAutoÙ
ENDDOC*/

User Function Mt160WF(cNivAtu, nExec, cXPED )
	
	Local aAreaSC1 := SC1->(GetArea())
	Local aAreaSC7 := SC7->(GetArea())
	Local aAreaSC8 := SC8->(GetArea())
	Local aAreaSCE := SCE->(GetArea())
	Local aAreaSM0 := SM0->(GetArea())
	
	Local _lRet := .T.
	
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
	Private nX := 0	
	
	Default nExec := 1
	
	If cXPED <> NiL
		DbSelectArea("SC7")
	//	SC7->(DbGoTop())
		SC7->(DbSetOrder(1))
		SC7->(DbSeek(xFilial('SC7') + cXPED))
	Endif	

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
	

	CQUERY := " SELECT C7_NUM  " 
	CQUERY += " FROM "+ RetSQLName("SC7")+ " SC7" + chr(13)+chr(10)
	CQUERY += " WHERE   C7_FILIAL =  '" + xFilial("SC7") + "' " + chr(13)+chr(10)
	cQuery += "  AND   C7_NUMCOT = '"+SC7->C7_NUMCOT+"' and D_E_L_E_T_ = ' '" + chr(13)+chr(10)
	TcQuery cQuery Alias "DIF" New
	cPeds := ""	
	While DIF->(!Eof())     		
		cPeds += "- "+AllTrim(DIF->C7_NUM)+(CHR(13)+CHR(10))
		DIF->(DbSkip())
	EndDo
	DIF->(DbCloseArea())

	MsgAlert("A cotação " + SC7->C7_NUMCOT + " gerou os pedidos de compras Nº " + (CHR(13)+CHR(10)) + cPeds)
	
	cNivAtu := If((cNivAtu == Nil), 0, cNivAtu)
	
	/*/ C?digo extra?do do cadastro de processos. /*/
	cCodProcesso := 'APRPED'

	/*/ Assunto da mensagem /*/
	cAssunto := 'Aprovacao do pedido de compra'
	u_Wf120pAlc()
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
Static Function PCInicio(cNivAtu, nExec, _lRet)

	Local oFont2 := TFont():New('Courier New', Nil, 14, Nil, .F., Nil, Nil, Nil, Nil, .F., .F.)
	Local oFont3 := TFont():New('Verdana', Nil, 18, Nil, .F., Nil, Nil, Nil, Nil, .F., .F.)
	Local nTime := 1
	local nLinEnt := 0
	local nX    := 0
	
	Private aEMail := {}
	Private nTotDesc := 0
	Private nTotIpi := 0
	Private nTotFrt := 0
	Private nTotIT := 0
	Private nTotPed := 0
	Private cMsgComp := ''
	Private cMsgPed := ''
	Private cSimbMoed := AllTrim(GetMV('MV_SIMB' + AllTrim(Str(SC7->C7_MOEDA))))
	
	Private aAmb   := {"N=Não","S=Sim"}
	Private ocombo := nIl
	Private cMsgGrv:= ""
	Private cMsgEme:= ""	
	Private nLinEnt := 0
	Private cUserFullName := UsrFullName(SC7->C7_USER) 
	
	/*/ Posiciona no primeiro item do pedido /*/
	SC7->(DbGoTop())
	SC7->(DbSetOrder(1))
	SC7->(DbSeek(xFilial('SC7') + cNumPed))
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
		//SButton():New(137, 198, 01, {|u| oDlg1:End()}, oDlg1, .T., 'Ok',)
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
		                            

		If !(Empty(AllTrim(cMsgComp)))
			cMsgGrv := ''
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

	If (nExec == 1)
		ProcRegua(0)
	EndIf	

	If (Len(aEMail) > 0)
	
		Begin Transaction
		
		For nX := 1 To Len(aEMail)
			cINFO := ''
			IncProc('Gerando E-mail para o(s) aprovador(es)...')
			
			// Gera os processos do workflow e envia o e-mail
			//PedGeraWF(nExec, @_lRet)
			U_WFEnvMsg(7,cFilant,aemail[nx][4],cNumPed,aemail[nx])	
			
			If !_lRet
				DisarmTransaction()
				Break
			EndIf
			
		Next
		
		End Transaction
		
	Else
			
	//	IF !l160Auto
		
			MsgAlert('Nao foram encontrados APROVADORES para envio de workflow! (MT160WF)', 'Atencao!')
		
//		ELSE
		
			u_xConOut(Repl("-",80))
			u_xConOut("Nao foram encontrados APROVADORES para envio de workflow! (MT160WF)")
			u_xConOut(Repl("-",80))
		
//		ENDIF		
		
	EndIf	
	*'Yttalo P. Martins 13/03/15-FIM-----------------------------------------------------------'*
	
Return

/*
*******************************************************************************************************************************************************
*******************************************************************************************************************************************************
*/
Static Function ValEME()

If cCombo == NiL
	Alert('Favor preencher emergencial com “S” (sim) ou “N” (não)')
	
ElseIf AllTrim(Upper(cCombo)) == "S" .AND. Empty(cMsgEme) 
//	Alert("A observação emergencial deve ser preenchida para pedidos emergenciais")
	Alert("A observação emergencial deve ser preenchida para pedidos emergenciais!")
	
Else
	oDlg1:End()
Endif

Return





/*/{Protheus.doc} novo

@author				Leonardo Pereira
@since				01/01/2014
@version			1.0
@description	Calcula as dimensoes dos objetos

/*/
User Function LMPCalcObj(nTipo, aADisp, aObjHor, aObjVer, aObjMar)

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
	local nJ   :=0
	Local nObjIT:= 0

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
