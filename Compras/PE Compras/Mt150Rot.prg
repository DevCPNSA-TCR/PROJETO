#Include 'totvs.ch'
/*
*******************************************************************************************************************************
*** Funcao: MT150ROT   -   Autor: Leonardo Pereira   -   Data: 01/11/2010.                                                  ***
*** Descricao: Adiciona nova rotina ao menu de contexto da rotina de atualizacao de cotacao.                                ***
*******************************************************************************************************************************
*/
User Function Mt150Rot()

//Define Array contendo as Rotinas a executar do programa
// ----------- Elementos contidos por dimensao ------------
// 1. Nome a aparecer no cabecalho
// 2. Nome da Rotina associada
// 3. Usado pela rotina
// 4. Tipo de Transa??o a ser efetuada
	//    1 - Pesquisa e Posiciona em um Banco de Dados
	//    2 - Simplesmente Mostra os Campos
	//    3 - Inclui registros no Bancos de Dados
	//    4 - Altera o registro corrente
	//    5 - Remove o registro corrente do Banco de Dados
	//    6 - Altera determinados campos sem incluir novos Regs	
	
	nPosWFPro := aScan(aRotina, {|x| AllTrim(x[1]) == 'Proposta'})
		
	/*/ Elimina a opcao de inclusao de proposta na cotacao /*/
	if nPosWFPro > 0
	   aDel(aRotina, nPosWFPro)
	   aSize(aRotina, (Len(aRotina) - 1))
	endif
  	
	nPosWFAtu := aScan(aRotina, {|x| AllTrim(x[1]) == 'Atualizar'})
	nPosWFExc := aScan(aRotina, {|x| AllTrim(x[1]) == 'Excluir'})
	nPosWFNov := aScan(aRotina, {|x| AllTrim(x[1]) == 'Novo Particip.'})
  	
	/*/ Inclui uma nova rotina no menu /*/
//	aAdd(aRotina, {'Enviar Workflow', 'U_PNEnvWF()', 0, 4})
	aAdd(aRotina, {'Enviar Workflow', 'U_PNEnvWF()', 0, 4, nil})  //WFEnvMsg(nOpc,cxFil,cXUser,cXPed,aXMail)
		
	/*/ Inclui uma nova rotina no menu /*/
	aAdd(aRotina, {'Add Observacao', 'U_PNObsWF()', 0, 4, nil})
	
	/*/ Inclui uma nova rotina no menu /*/
	aAdd(aRotina, {'Consultar Ranking', 'U_PNConRkn("SC8", Recno(), 4, "MC")', 0, 4, nil})
	
	/*/ Inclui uma nova rotina no menu /*/
	aAdd(aRotina, {'Restaurar  Cotacao', "U_PNResCot('R')", 0, 6,nil})	
	
	/*/ Verifica se é possivel atualizar cotacao /*/
	aRotina[nPosWFAtu, 2] := 'U_WF150Atu()'
	
	/*/ Verifica se é possivel atualizar cotacao /*/
	aRotina[nPosWFExc, 2] := 'U_WF150Exc()'
	
	/*/ Verifica se é possivel atualizar cotacao /*/
	aRotina[nPosWFNov, 2] := 'U_WF150Nov()'
	
Return(aRotina)


/*
*******************************************************************************************************************************
*** Funcao: WF150ATU   -   Autor: Leonardo Pereira   -   Data:                                                              ***
*** Descricao: Verifica se é possivel a exclusao da cotacao.                                                                ***
*******************************************************************************************************************************
*/
User Function WF150Atu()

	If !Empty(SC8->C8_WFID)
		MsgAlert('Esta cotacao possui WORKFLOW enviado, nao e possivel atualiza-la!', 'WORKFLOW')
		Return
	Else
		A150Digita('SC8', SC8->(Recno()), 3)
	EndIf

Return

/*
*******************************************************************************************************************************
*** Funcao: WF150EXC   -   Autor: Leonardo Pereira   -   Data:                                                              ***
*** Descricao: Verifica se é possivel a exclusao da cotacao.                                                                ***
*******************************************************************************************************************************
*/
User Function WF150Exc()

	If !Empty(SC8->C8_WFID)
	
		/*/ Como ja foi enviado Workflow, somente permite exclus�o da cota��o inteira /*/
		If MV_PAR04 <> 2
			Alert("Nao e possivel excluir fornecedor ou produto da cotacao, pois ja existe Workflow enviado!!!"+;
				Chr(13) + Chr(10) + "Verifique os Parametros em F12!")
		Else	
			If (MsgYesNo('Esta cotacao possui WORKFLOW enviado, deseja realmente exclui-la ?', 'WORKFLOW'))
				A150Digita('SC8', SC8->(Recno()), 5)
			EndIf
		Endif
	Else

		A150Digita('SC8', SC8->(Recno()), 5)
	EndIf
	
Return

/*
*********************************************************************************************************
*** Funcao: WF150NOV   -   Autor: Leonardo Pereira   -   Data:                                        ***
*** Descricao: Verifica se é possivel adicionar novo participante                                     ***
*********************************************************************************************************
*/
User Function WF150Nov()

	If !Empty(SC8->C8_WFID)
			
		MsgAlert('Esta cotacao possui WORKFLOW enviado, nao e possivel incluir novo participante!', 'WORKFLOW')
		Return
	Else
		A150Digita('SC8', SC8->(Recno()), 2)
	EndIf

Return

/*
********************************************************************************************************
*** Funcao: PNOBSWF   -   Autor: Leonardo Pereira   -   Data:                                        ***
*** Descricao: Dialog para digitacao e gravacao de observacoes da cotacao.                           ***
********************************************************************************************************
*/
User Function PNObsWF()

	Local oFont2 := TFont():New('Courier New', Nil, 14, Nil, .F., Nil, Nil, Nil, Nil, .F., .F.)
	Local oFont3 := TFont():New('Verdana', Nil, 18, Nil, .F., Nil, Nil, Nil, Nil, .F., .F.)
	Local nTime := 1
	Local cMsgObs1 := ''
	Local cNumSC8 := SC8->C8_NUM
	Local cString := ''
	local nLinEnt := 0
		
	/*/ Dialog para digitacao do endereco de entrega /*/
	oDlg1 := MsDialog():New(000, 000, 250, 450, 'O B S E R V A C O E S   DA   C O T A C A O',,,,,,,,, .T.)
	oGrp1 := TGroup():New(005, 002, 093, 225,' Dados ', oDlg1,,, .T.)
	oTMultiGet1 := TMultiget():New(013, 006, {|u| If((PCount() > 0), cMsgObs1 := u, cMsgObs1)}, oGrp1, 215, 075, oFont3, .F., RGB(000,000,000), RGB(255,255,255),, .T.,,, {|u| },,, .F., {|u| },,, .F., .T.)
	
	/*/ Botoes /*/
	SButton():New(098, 198, 01, {|u| oDlg1:End()}, oDlg1, .T., 'Ok',)
	/*/ Barra de Status /*/
	oTMsgBar1 := TMsgBar():New(oDlg1, 'Totvs 2013 Serie T',,,,, RGB(255,255,255),, oFont2, .F., '')
	
	/*/ Cria itens na barra de status /*/
	oTMsg1 := TMsgItem():New(oTMsgBar1, Time(), 100,,,,.T., { |u| MsgAlert('Data: ' + Dtoc(dDataBase) + Chr(13) + 'Hora: ' + Time()), oTMsgBar1:Refresh()})
	
	/*/ Cria o relogio na barra de status da dialog /*/
	oTTimer1 := TTimer():New(nTime,, oDlg1)
	oTTimer1:bAction := { |u| oTMsg1:SetText(Time())}
	oTTimer1:lActive := .T.
	oTTimer1:Activate()
	oDlg1:Activate(,,, .T.,,,)
		
	For nLinEnt := 1 To 99
		cStr := AllTrim(MemoLine(cMsgObs1,, nLinEnt)) + ' '
		If Empty(cStr)
			Exit
		Else
			cString += cStr
		EndIf
	Next
		
	SC8->(DbGoTop())
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(xFilial('SC8') + cNumSC8))
	While SC8->(!Eof()) .And. (SC8->C8_NUM == cNumSC8)
		RecLock('SC8', .F.)
		SC8->C8_XOBSCOT := cString
		SC8->(MsUnLock())
		SC8->(DbSkip())
	End
	
Return
