#Include 'rwmake.ch'
#Include 'protheus.ch'
#Include 'totvs.ch'
#Include 'topconn.ch'

/*/
*****************************************************************************************************
*** Funcao   : PNOVOPC   -   Autor: Leonardo Pereira   -   Data:                                  ***
*** Descricao: Impressao do Relatorio de Formacao de precos.                                      ***
*****************************************************************************************************
/*/
User Function PNRPedCom()

    // Incluído por Peder Munksgaard (Criare Consulting) em 28/05/2015
    // Guardo a área de todas as tabelas utilizadas pelo relatório pois
    // este é chamado internamente pela MATA120. Erro_log apontado pelos
    // usuários após a execução do relatório.
    
    Local   _MV_PAR01 := MV_PAR01
    Local   _MV_PAR02 := MV_PAR02
    
    Private _nRecno    
    Private _aArea := SaveArea1({"SC7","SY1","SM0","SA2","SC8","SCR"})
    
    // Fim inclusão.

	Private aBox
	Private cLogo := If((AllTrim(SM0->M0_CODFIL) == '0101'), 'LogoPNOVO.png', 'LogoTCR.png')
	Private aCab := {}
	Private lEnd := .F.
	Private nLin := 10000
	Private oFontaN := TFont():New('Verdana',, 14,, .T.,,,,, .F., .F.)
	Private oFontbN := TFont():New('Verdana',, 06,, .T.,,,,, .F., .F.)
	Private oFontc := TFont():New('Verdana',, 10,, .F.,,,,, .F., .F.)
	Private oFontc2 := TFont():New('Verdana',, 08,, .F.,,,,, .F., .F.)
	Private oFontcN := TFont():New('Verdana',, 10,, .T.,,,,, .F., .F.)
	Private oFontdN := TFont():New('Verdana',, 12,, .T.,,,,, .F., .F.)
	Private oFonte := TFont():New('Verdana',, 09,, .F.,,,,, .F., .F.)
	Private oFonteN := TFont():New('Verdana',, 09,, .T.,,,,, .F., .F.)
	Private oFontf := TFont():New('Verdana',, 25,, .F.,,,,, .F., .F.)
	Private oFontfN := TFont():New('Verdana',, 25,, .T.,,,,, .F., .F.)
	Private oFontg := TFont():New('Verdana',, 07,, .F.,,,,, .F., .F.)
	Private oFontgN := TFont():New('Verdana',, 08,, .T.,,,,, .F., .F.)
	Private oFonthN := TFont():New('Verdana',, 16,, .T.,,,,, .F., .F.)
	Private oBrush1 := TBrush():New(, RGB(240, 240, 240))
	Private oBrush2 := TBrush():New(, RGB(255, 255, 155))
	Private _oPrn := TmsPrinter():New('Pedido de Fornecimento')
	Private nMaxH := 0
	Private nMaxV := 0
	Private nQTDPg := 0
	Private nPgAtu := 0
	Private nCount := 0
	Private aCabBox := {{'ITEM', 'CODIGO', 'DESCRICAO', 'QUANT.', 'UM', 'PRECO UNIT.', 'DESC.', 'IPI', 'TOTAL','TES'}}
	Private nQtdIt := 12
	//Private nQtdIt := 10
	Private nTotIT := nTotFRT := nTotSEG := nTotDSP := nTotDSC := nTotIPI := nTotEMB := 0
	Private cMsgEnt := ''
	Private cMsgBkp := ''
	
	cPerg := 'PNPED'
	
	If !Pergunte(cPerg, .T.)
		Return
	EndIf

	_oPrn:Setup()

	nMaxV := _oPrn:nVertRes()
	nMaxH := _oPrn:nHorzRes()
	//aBox := {{0055, 200, 600, 1900 , 2150, 2250, 2550, 2750, 2950, 3250, 3423, (nMaxH - 55)}} - Alterado por Rafael Sacramento em 22/11/2016
	aBox := {{0055, 200, 560, 1828, 2050, 2150, 2450, 2700, 2950, 3250, 3450, (nMaxH - 55)}}

	cTitulo := 'P E D I D O   DE   F O R N E C I M E N T O'

	aAdd(aCab, cTitulo)

	Processa({ |lEnd| PNRelPC(@lEnd)}, 'PEDIDO DE FORNECIMENTO', 'Processando dados...', .T.)
    
    MV_PAR01 := _MV_PAR01
    MV_PAR02 := _MV_PAR02
    
    RestArea1(_aArea)
    
Return

/*/
*****************************************************************************************************
***                                                                                               ***
***                                                                                               ***
*****************************************************************************************************
/*/
Static Function PNRelPC(lEnd)

	Local oFont2 	:= TFont():New('Courier New', Nil, 14, Nil, .F., Nil, Nil, Nil, Nil, .F., .F.)
	Local oFont3 	:= TFont():New('Verdana', Nil, 18, Nil, .F., Nil, Nil, Nil, Nil, .F., .F.)
	Local nTime 	:= 1
	Local lComprador := .F.
	Local nTamDes, _cPedKey
	
	Private cMsgEnt	:= ''
	Private lFirst 	:= .T.
	
	/*/ Verifica se o usuario logado e um comprador /*/
	DbSelectArea('SY1')
	DbSetOrder(3)
	If (DbSeek(xFilial('SY1') + __cUserId))
		lComprador := .T.
	EndIf
	
	SC7->(dbSetOrder(1))
	If !SC7->(dbSeek(mv_par02+mv_par01))
		MsgAlert('O PEDIDO informado nao foi encontrado!', 'Atencao!')
		Return
    Else
       _nRecno := SC7->(Recno())
	EndIf
          
	cMsgEnt := SC7->C7_XENTREG
	
	If lComprador
		/*/ Dialog para digitacao do endereco de entrega /*/
		_oDlg1 := MsDialog():New(000, 000, 250, 450, 'E N D E R E C O   DE   E N T R E G A',,,,,,,,, .T.)
		_oGrp1 := TGroup():New(005, 002, 093, 225,' Dados ', _oDlg1,,, .T.)
		_oTMultiGet1 := TMultiget():New(013, 006, {|u| If((PCount() > 0), cMsgEnt := u, cMsgEnt)}, _oGrp1, 215, 075, oFont3, .F., RGB(000,000,000), RGB(255,255,255),, .T.,,, {|u| },,, .F., {|u| },,, .F., .T.)
		/*/ Botoes /*/
		SButton():New(098, 198, 01, {|u| _oDlg1:End()}, _oDlg1, .T., 'Ok',)
		/*/ Barra de Status /*/
		_oTMsgBar1 := TMsgBar():New(_oDlg1, 'Totvs 2013 Serie T',,,,, RGB(255,255,255),, oFont2, .F., '')
		/*/ Cria itens na barra de status /*/
		_oTMsg1 := TMsgItem():New(_oTMsgBar1, Time(), 100,,,,.T., {|u| MsgAlert('Data: ' + Dtoc(dDataBase) + Chr(13) + 'Hora: ' + Time()), _oTMsgBar1:Refresh()})
		/*/ Cria o relogio na barra de status da dialog /*/
		_oTTimer1 := TTimer():New(nTime,, _oDlg1)
		_oTTimer1:bAction := {|u| _oTMsg1:SetText(Time())}
		_oTTimer1:lActive := .T.
		_oTTimer1:Activate()
		_oDlg1:Activate(,,, .T.,,,)
	EndIf
		
	cMsgBkp := cMsgEnt
		
	/*/ Calcula quantidade de quebras de linha para determinar a quantidade final de paginas /*/
	nQLin := 0
	
	While !SC7->(Eof()) .And. (SC7->(C7_FILIAL+C7_NUM) == MV_PAR02+MV_PAR01)
		cDescPro := AllTrim(SC7->C7_DESCRI)+" "+AllTrim(SC7->C7_OBS) 
		nTDesc := Len(cDescPro)
		cDesc := ''
		/*
		While !Empty(cDescPro)
			For nTamDes := 1 To nTDesc
				cDesc += SubStr(cDescPro, 1, 1)
				cDescPro := SubStr(cDescPro, 2)
				If (nTamDes == 67) .Or. Empty(cDescPro)
					If (Len(cDesc) > 0)
						cDesc := ''
						nTamDes := 0
						nQLin++
					Else
						Exit
					EndIf
				EndIf
			Next
		End     
		*/
		
		nQLin += Len(AllTrim(cDescPro))/67
		
		SC7->(dbSkip())
	End
	
    SC7->(dbGoto(_nRecno))
	
	/* Grava o Endereï¿½o de entrega no primeiro item do pedido.*/
	RecLock('SC7', .F.)
	SC7->C7_XENTREG := cMsgEnt
	MsUnlock()
	
	/*/ Verifica se a tabela esta em USO /*/
	If (Select('TMPQTD') > 0)
		TMPQTD->(DbCloseArea())
	EndIf
	/*/ Totaliza o custo de entrada dos itens DEVOLVIDOS /*/
	cQry := 'SELECT COUNT(C7_NUM) QTDIT, SUM(C7_SEGURO) C7_SEGURO, SUM(C7_DESPESA) C7_DESPESA, SUM(C7_VALEMB) C7_VALEMB '
	cQry += 'FROM ' + RetSqlName('SC7') + " SC7 WHERE C7_FILIAL = '" + xFilial("SC7") + "' AND C7_NUM = '" + SC7->C7_NUM +"' AND D_E_L_E_T_ = ' ' "
	TcQuery cQry New ALIAS 'TMPQTD'
	TMPQTD->(DbGoTop())
	
	If (TMPQTD->QTDIT > 0)
	    // Alteração por Peder Munksgaard (Criare Consulting) em 28/05/2015
	    // Simplificação da lógica matemática utilizada.
		//nQTDPg := (nQLin / nQtdIt)
		
		//Alterado por Rafael Sacramento (Criare Consulting) em 15/10/2015 - Relatório se perde na contagem quando possui 2 páginas.
		//nQTDPg := If((nQTDPg == NoRound(nQTDPg, 0)), (nQTDPg + 1), (NoRound(nQTDPg, 0) + 2))
		//nQTDPg ++
		nQTDPg := Iif ((mod(nQlin, nQtdIt) == 0), NoRound((nQlin / nQtdIt),0), NoRound((nQlin / nQtdIt) + 1,0)) 	
			
	EndIf
	
	nTotSEG := TMPQTD->C7_SEGURO
	nTotDSP := TMPQTD->C7_DESPESA
	nTotEMB := TMPQTD->C7_VALEMB
	
	TMPQTD->(DbCloseArea())
	
	ProcRegua(0)
	While !SC7->(Eof()) .And. (SC7->C7_NUM == mv_par01)
		IncProc('Selecionando dados para o relatorio...')
		
		If Interrupcao(@lEnd)
			Exit
		EndIf
		
		/*/ Impressao dos dados do relatorio /*/
        /*
		If lFirst .Or. (nCount == nQtdIt)
			If !lFirst
				// Imprime a parte inferior do pedido de compras
				nLin := (nMaxV - ((nMaxV * 40) / 100))
				PRNRodape()
			EndIf
			nLin := PNRCabec(_oPrn, cLogo, aCab, aBox)
			nLin := PNRCabGrd(aCabBox)
			lFirst := .F.
			
			nCount := 0 // inserido por Felipe do Nascimento - 17/11/2014
		EndIf
	   	*/					
		/*/ Imprime os registros (itens) /*/

		If lFirst .Or. (nCount >= nQtdIt)
			If !lFirst
				// Imprime a parte inferior do pedido de compras
				nLin := (nMaxV - ((nMaxV * 40) / 100))
				PRNRodape()
			EndIf
			nLin := PNRCabec(_oPrn, cLogo, aCab, aBox)
			nLin := PNRCabGrd(aCabBox)
			lFirst := .F.
			
			nCount := 0 // inserido por Felipe do Nascimento - 17/11/2014
		EndIf
				
		PNRItem()
		
		SC7->(DbSkip())		
		 
	End
	
    SC7->(dbGoto(_nRecno))

	/*/ Imprime a parte inferior do pedido de compras /*/
	nLin := ((nMaxV - ((nMaxV * 40) / 100)) + 5)
	PRNRodape()

	/*/ Imprime as informa??es do verso /*/
	PNRVerso()

	If Interrupcao(@lEnd)
		_oPrn:Say(1100, 1650, 'PROCESSO CANCELADO PELO USUARIO', oFontf,,,, 2)
	EndIf

	_oPrn:Preview()

Return

/*/
*****************************************************************************************************
*** Funcao   : PNRCABEC   -   Autor: Leonardo Pereira   -   Data: 27/08/2013                      ***
*** Descricao: Impress?o do Relat?rio de Formacao de precos.                                      ***
*****************************************************************************************************
/*/
Static Function PNRCabec(_oPrn, cLogo, aCab, aBox)

	Local nCnt
	Local aInfoUsu
	Local nLinCab
	Local nLinRep
	
	nPgAtu++

	If !File(cLogo)
		cLogo := 'LGRL' + SM0->M0_CODIGO + '.BMP'
		If !File(cLogo)
			cLogo := 'LGRL.BMP'
		EndIf
	EndIf

	cLogo := If((cLogo == Nil), '', cLogo)
	aCab := If((aCab == Nil), {''}, aCab)

	_oPrn:EndPage()
	_oPrn:StartPage()

	nLin := 0050

	/*/ Desenha os boxes do cabe?alho /*/
	_oPrn:Box(nLin, 0050, (nMaxV - 50), (nMaxH - 50))											// Box da Pagina.
	nLin += 0005
	_oPrn:Box(nLin, 0055, 0220, 0268)																		// Box do Logotipo.
	_oPrn:Box(nLin, 0268, 0220, 1850)																		// Box do Titulo do Relatorio.

	nLinCab := If((Len(aCab) > 1), 0025, 0050)
	For nCnt := 1 To Len(aCab)
		nLinCab += 0060
		_oPrn:Say(nLinCab, ((0268 + 1500) / 2), aCab[nCnt], oFontaN,,,, 2)			// Impressao do Titulo.
	Next

	_oPrn:Box(nLin, 1850, 0220, 2100)																		// Box do No da Solicitacao
	_oPrn:Box(nLin, 2100, 0220, 2430)																		// Box do No da Cota??o
	_oPrn:Box(nLin, 2430, 0220, 2620)																		// Box do No do Pedido

	_oPrn:Box(nLin, 2620, 0220, 3000)																		// Box do Centro de Custo
//	_oPrn:Box(nLin, 2650, 0220, 3050)																		// Box da Conta Orcamentaria
	_oPrn:Box(nLin, 3000, 0220, (nMaxH - 55))														     	// Box da Natureza
	nLin += 0012
	_oPrn:SayBitmap(nLin, 0067, cLogo, 0189, 0139)													// Impressao do Logotipo.

	nLin -= 0002
	_oPrn:Say(nLin, 1860, 'Solicitacao:', oFontbN,,,, 0)										// Solicitacao
	_oPrn:Say(nLin, 2110, 'No. da Cotacao:', oFontbN,,,, 0)									// No da Cota??o
	_oPrn:Say(nLin, 2460, 'No. do Pedido:', oFontbN,,,, 0)									// No do Pedido
	_oPrn:Say(nLin, 2630, 'Centro de Custo:', oFontbN,,,, 0)								// Centro de Custo
//	_oPrn:Say(nLin, 2660, 'Conta Orcamentaria:', oFontbN,,,, 0)							// No da Conta Orcamentaria
	_oPrn:Say(nLin, 3060, 'Natureza:', oFontbN,,,, 0)											// No da Natureza

	nLin += 0050
	_oPrn:Say(nLin, ((1850 + 2100) / 2), SC7->C7_NUMSC, oFontdN,,,, 2)				// Solicitacao
	_oPrn:Say(nLin, ((2100 + 2450) / 2), SC7->C7_NUMCOT, oFontdN,,,, 2)				// No da Cota??o
	_oPrn:Say(nLin, ((2450 + 2600) / 2), SC7->C7_NUM, oFontdN,,,, 2)					// No do Pedido
	_oPrn:Say(nLin, ((2620 + 3000) / 2), AllTrim(SC7->C7_CC), oFontdN,,,, 2)		// Centro de Custo
//	_oPrn:Say(nLin, ((2650 + 3050) / 2), SC7->C7_XCO, oFontdN,,,, 2)					// No da Conta Orcamentaria
	_oPrn:Say(nLin, ((3050 + (nMaxH - 55)) / 2), SC7->C7_XNAT, oFontdN,,,, 2)	// No da Natureza

	nLin += 0111
	_oPrn:FillRect({nLin, 0056, 0489, (nMaxH - 56)}, oBrush1)
	_oPrn:Box((nLin - 1), 0055, 0490, (nMaxH - 55))												// Box dos Dados da Empresa

	nLin += 0009
	_oPrn:Say(nLin, 0065, 'Dados da Empresa:', oFontbN,,,, 0)								// Dados da Empresa

	nLin += 0040
	_oPrn:Say(nLin, 0065, AllTrim(SM0->M0_NOMECOM), oFontcN,,,, 0)						// Nome da Empresa

	nLin += 0050
	_oPrn:Say(nLin, 0065, 'ENDERECO: ' + AllTrim(SM0->M0_ENDCOB) + ', ' + AllTrim(SM0->M0_CIDCOB) + ' - ' + SM0->M0_ESTCOB, oFontgN,,,, 0)		// Endereco da Empresa
	_oPrn:Say(nLin, 1150, 'CEP: ' + Transform(SM0->M0_CEPCOB, '@R 99999-999'), oFontcN,,,, 0)			// CEP da Empresa
	_oPrn:Say(nLin, 2400, 'WEBSITE: www.portonovosa.com', oFontcN,,,, 0)		// Site da Empresa

	nLin += 0050
	_oPrn:Say(nLin, 0065, 'CNPJ: ' + Transform(SM0->M0_CGC, '@R 99.999.999/9999-99'), oFontcN,,,, 0)	// CNPJ da Empresa
	If (AllTrim(SM0->M0_INSC) <> 'ISENTO')
		_oPrn:Say(nLin, 1150, 'INSC. ESTADUAL: ' + Transform(SM0->M0_INSC, '@R 99.999.99-9'), oFontcN,,,, 0)	// Inscricao Estadual da Empresa
	Else
		_oPrn:Say(nLin, 1150, 'INSC. ESTADUAL: ' + SM0->M0_INSC, oFontcN,,,, 0)	// Inscricao Estadual da Empresa
	EndIf
	If (AllTrim(SM0->M0_INSCM) <> 'ISENTO')
		_oPrn:Say(nLin, 2400, 'INSC. MUNICIPAL: ' + Transform(SM0->M0_INSCM, '@R 999999-9'), oFontcN,,,, 0)	// Inscricao Municipal da Empresa
	Else
		_oPrn:Say(nLin, 2400, 'INSC. MUNICIPAL: ' + SM0->M0_INSCM, oFontcN,,,, 0)	// Inscricao Municipal da Empresa
	EndIf

	nLin += 0050
	
	
	cUsrComp:= SC7->C7_USER
	/*/ Pesquisa os dados do contato /*/
	SY1->(DbSetOrder(3))
	If SY1->(DbSeek(xFilial('SY1') + SC7->C7_USER))
		If !Empty(SY1->Y1_XRESP)
			SY1->(DbSetOrder(1))
			If SY1->(DbSeek(xFilial('SY1') + SY1->Y1_XRESP))
				cUsrComp := SY1->Y1_USER
			EndIf
		Endif
	EndIf
	
	PswOrder(1)
	If (PswSeek(AllTrim(cUsrComp), .T.))
		aInfoUsu := PswRet(1)
	EndIf
	_oPrn:Say(nLin, 0065, 'CONTATO: ' + AllTrim(aInfoUsu[1,4]), oFontcN,,,, 0)		// Contato da Empresa
	_oPrn:Say(nLin, 1150, 'TELEFONE: ' + SM0->M0_TEL, oFontcN,,,, 0)		// Telefone do Contato
	_oPrn:Say(nLin, 2400, 'E-MAIL: ' + AllTrim(aInfoUsu[1,14]), oFontcN,,,, 0)		// E-mail do Contato

	nLin += 0070
	_oPrn:Box(nLin, 0055, 0755, ((nMaxH - 55) / 2) + 100)		// Box dos Dados do Fornecedor
	_oPrn:Box(nLin, (((nMaxH - 55) / 2) + 100), 0755, (nMaxH - 55))	// Box dos Dados do Representante

	nLin += 0015
	_oPrn:Say(nLin, 0065, 'Dados do Fornecedor:', oFontbN,,,, 0)		// Dados do Fornecedor
	_oPrn:Say(nLin, (((nMaxH - 55) / 2) + 110), 'Dados do Representante:', oFontbN,,,, 0)		// Dados do Representante

	nLin += 0040
	nLinRep := nLin
	SA2->(DbSetOrder(1))
	If SA2->(DbSeek(xFilial('SA2') + SC7->(C7_FORNECE + C7_LOJA)))
		/*/ Dados do Fornecedor /*/
		_oPrn:Say(nLin, 0065, SubStr(AllTrim(SA2->A2_NOME), 1, 50), oFonteN,,,, 0)		// Nome
		_oPrn:Say(nLin, 1150, 'CNPJ: ' + Transform(AllTrim(SA2->A2_CGC), '@R 99.999.999/9999-99'), oFonteN,,,, 0)		// CNPJ
		nLin += 0050
		_oPrn:Say(nLin, 0065, 'ENDERECO: ' + AllTrim(SA2->A2_END) + ' - ' + AllTrim(SA2->A2_BAIRRO) + ' - ' + AllTrim(SA2->A2_EST), oFontgN,,,, 0)		// Endereco
		nLin += 0040
		_oPrn:Say(nLin, 0065, 'CEP: ' + Transform(SA2->A2_CEP, '@R 99999-999'), oFonte,,,, 0)		// CEP
		_oPrn:Say(nLin, 0600, 'CONTATO: ' + AllTrim(SC7->C7_CONTATO), oFonte,,,, 0)		// Contato
		//_oPrn:Say(nLin, 0800, 'WEBSITE: ' + Lower(AllTrim(SA2->A2_HPAGE)), oFonte,,,, 0)			// Site
		nLin += 0040
		_oPrn:Say(nLin, 0065, 'TELEFONE: ' + Transform(AllTrim(SA2->(A2_DDD+A2_TEL)), '@R 999-9999-9999'), oFonte,,,, 0)		// Telefone
		_oPrn:Say(nLin, 0600, 'E-MAIL: ' + Lower(AllTrim(SA2->A2_EMAIL)), oFonte,,,, 0)		// E-mail
	EndIf

	/*/ Dados do Representante /*/
	_oPrn:Say(nLinRep, (((nMaxH - 55) / 2) + 110), '', oFonteN,,,, 0)				// Nome
	_oPrn:Say(nLinRep, 2850, 'CNPJ: ', oFonteN,,,, 0)									// CNPJ
	nLinRep += 0050
	_oPrn:Say(nLinRep, (((nMaxH - 55) / 2) + 110), 'ENDERECO: ', oFontgN,,,, 0)	// Endereco
	nLinRep += 0040
	_oPrn:Say(nLinRep, (((nMaxH - 55) / 2) + 110), 'CEP: ', oFonte,,,, 0)										// CEP
	_oPrn:Say(nLinRep, 2500, 'CONTATO: ', oFonte,,,, 0)		// Contato
	//_oPrn:Say(nLinRep, 2500, 'WEBSITE: ', oFonte,,,, 0)									// Site
	nLinRep += 0040
	_oPrn:Say(nLinRep, (((nMaxH - 55) / 2) + 110), 'TELEFONE: ', oFonte,,,, 0)	// Telefone
	_oPrn:Say(nLinRep, 2500, 'E-MAIL: ', oFonte,,,, 0)									// E-mail

	nLin := 0755

Return(nLin)

/*/
*****************************************************************************************************
***                                                                                               ***
***                                                                                               ***
*****************************************************************************************************
/*/
Static Function PNRCabGrd(aCabBox)

	Local nLenCab := 0090
	Local nCnt, nCntBox, nCntCab

	nLin += 0005
	nLinAnt := nLin

	/*/ Montagem dos box?s do cabe?alho das colunas do relatorio. /*/
	For nCntBox := 1 To Len(aBox)
		For nCnt := 1 To (Len(aBox[nCntBox]) - 1)
			_oPrn:FillRect({(nLin + 1), (aBox[nCntBox, nCnt] + 1), (nLin + 0049), (aBox[nCntBox, (nCnt + 1)] - 1)}, oBrush1)
			_oPrn:Box(nLin, aBox[nCntBox, nCnt], (nLin + 0050), aBox[nCntBox, (nCnt + 1)])
		Next
	Next

	nLin := (nLinAnt - 0020)
	nSkipLin := (nLenCab / 3)

	/*/ Titulos das colunas do relatorio. /*/
	nLin += nSkipLin
	For nCntCab := 1 To Len(aCabBox)
		For nCnt := 1 To Len(aCabBox[nCntCab])
			_oPrn:Say((nLin - 5),((aBox[nCntCab, nCnt] + aBox[nCntCab, (nCnt + 1)]) / 2), aCabBox[nCntCab, nCnt], oFontcN,,,, 2)
		Next
	Next

	nLin += ((nLenCab - 0015) - nSkipLin)

	/*/ Montagem dos box's das colunas do relatorio. /*/
	For nCntBox := 1 To Len(aBox)
		For nCnt := 1 To (Len(aBox[nCntBox]) - 1)
			_oPrn:Box(nLin, aBox[nCntBox, nCnt], (nMaxV - ((nMaxV * 40) / 100)), aBox[nCntBox, nCnt + 1])
		Next
	Next

	nLin += 0015

Return(nLin)

/*/
*****************************************************************************************************
***                                                                                               ***
***                                                                                               ***
*****************************************************************************************************
/*/
Static Function PNRItem()

	Local nLinBkp1
	Local nLinBkp2
	Local cDesProd := AllTrim(SC7->C7_DESCRI)+" "+AllTrim(SC7->C7_OBS) 
	//Local cDesProd := (SUBSTR(SC7->C7_DESCRI,1,54)) Alterado por Rafael Sacramento (Criare Consulting) em 27/10/2015
	Local cDesImp := ''
	Local nLenDesc := Len(cDesProd)
	Local lNewPg := .F., nTamDes
	
	nBox := Len(aBox)
	
	_oPrn:Say(nLin, ((aBox[nBox, 01] + aBox[nBox, 02]) / 2), SC7->C7_ITEM, oFontc,,,, 2)
	_oPrn:Say(nLin, (aBox[nBox, 02] + 0010), SC7->C7_PRODUTO, oFontc,,,, 0)
	
	If (nLenDesc > 55)
		nLinBkp1 := nLin
		While !Empty(cDesProd)
			For nTamDes := 1 To nLenDesc
				/*/ Impressao dos dados do relatorio /*/
				If (nCount == nQtdIt)
					If (nLenDesc > 55)
						nLin := nLinBkp1
					EndIf
					
					_oPrn:Say(nLin, (aBox[nBox, 05] - 0010), Transform(SC7->C7_QUANT, '@E 999,999.99'), oFontc,,,, 1)
					_oPrn:Say(nLin, ((aBox[nBox, 05] + aBox[nBox, 06]) / 2), SC7->C7_UM, oFontc,,,, 2)
					//_oPrn:Say(nLin, (aBox[nBox, 07] - 0010), Transform(SC7->C7_PRECO, '@E 9,999,999.99'), oFontc,,,, 1)
					//Alterado por Rafael Sacramento (Criare Consulting) em 23/06/2015 - Preço unitário deverá ter 4 casas decimais. Chamado 17757.
					_oPrn:Say(nLin, (aBox[nBox, 07] - 0010), Transform(SC7->C7_PRECO, '@E 9,999,999.9999'), oFontc,,,, 1)
					_oPrn:Say(nLin, (aBox[nBox, 08] - 0010), Transform(SC7->C7_DESC1, '@E 999.99'), oFontc,,,, 1)
					_oPrn:Say(nLin, (aBox[nBox, 09] - 0010), Transform(SC7->C7_IPI, '@E 999.99'), oFontc,,,, 1)
					_oPrn:Say(nLin, (aBox[nBox, 10] - 0010), Transform(SC7->C7_TOTAL, '@E 99,999,999.99'), oFontc,,,, 1)
					_oPrn:Say(nLin, ((aBox[nBox, 10] + aBox[nBox, 11]) / 2), SC7->C7_TES, oFontc,,,, 2)
					
					/*/ Imprime a parte inferior do pedido de compras /*/
					// Alteração por Peder Munksgaard (Criare Consulting) em 28/05/2015
					// Retirado o trecho (comentado) abaixo devido a criação de uma página
					// a mais em todos os relatórios.
					/*RICARDO FERREIRA - CRIARE CONSULTING -26/10/2017 
					Trecho foi descomentado, pois é o trecho que trata a quebra de paginas com descrições grandes.
					*/					
					nLin := (nMaxV - ((nMaxV * 40) / 100))

					PRNRodape()
                   
					nLin := PNRCabec(_oPrn, cLogo, aCab, aBox)
					nLin := PNRCabGrd(aCabBox)
					nCount := 0
					
					// Fim alteração.
					
					lNewPg := .T.
				EndIf
				
				cDesImp += SubStr(cDesProd, 1, 1)
				cDesProd := SubStr(cDesProd, 2)
				If (nTamDes == 67) .Or. Empty(cDesProd) //55 //67
					If (Len(cDesImp) > 0)
						_oPrn:Say(nLin, (aBox[nBox, 03] + 0010), cDesImp, oFontc2,,,, 0)
						cDesImp := ''
						nTamDes := 0
						nCount++
						nLin += 0045
					Else
						nLin -= 0045
						Exit
					EndIf
				EndIf
			Next
		End
	Else
		_oPrn:Say(nLin, (aBox[nBox, 03] + 0010), cDesProd, oFontc,,,, 0)
		
		++nCount  // inserido por Felipe do Nascimento -  17/11/2014
	EndIf
	
	If !lNewPg
		If (nLenDesc > 55)
			nLinBkp2 := nLin
			nLin := nLinBkp1
		EndIf
	
		_oPrn:Say(nLin, (aBox[nBox, 05] - 0010), Transform(SC7->C7_QUANT, '@E 999,999.99'), oFontc,,,, 1)
		_oPrn:Say(nLin, ((aBox[nBox, 05] + aBox[nBox, 06]) / 2), SC7->C7_UM, oFontc,,,, 2)
		//_oPrn:Say(nLin, (aBox[nBox, 07] - 0010), Transform(SC7->C7_PRECO, '@E 9,999,999.99'), oFontc,,,, 1)
		//Alterado por Rafael Sacramento (Criare Consulting) em 23/06/2015 - Preço unitário deverá ter 4 casas decimais. Chamado 17757.
		_oPrn:Say(nLin, (aBox[nBox, 07] - 0010), Transform(SC7->C7_PRECO, '@E 9,999,999.9999'), oFontc,,,, 1)
		_oPrn:Say(nLin, (aBox[nBox, 08] - 0010), Transform(SC7->C7_DESC1, '@E 999.99'), oFontc,,,, 1)
		_oPrn:Say(nLin, (aBox[nBox, 09] - 0010), Transform(SC7->C7_IPI, '@E 999.99'), oFontc,,,, 1)
		_oPrn:Say(nLin, (aBox[nBox, 10] - 0010), Transform(SC7->C7_TOTAL, '@E 99,999,999.99'), oFontc,,,, 1)
		_oPrn:Say(nLin, ((aBox[nBox, 10] + aBox[nBox, 11]) / 2), SC7->C7_TES, oFontc,,,, 2)
	
		If (nLenDesc > 55)
			nLin := nLinBkp2
		EndIf
	EndIf
    
    // Alteração - Peder Munksgaard (Criare Consulting) em 28/05/2015.
    // Retirada das váriaveis de totalização da função PNRItem(). Tal ponto
    // é considerado completamente inadequado para realizar qualquer totalização
    // tendo em vista que a própria função realiza a chamada para PRNRodape().
    // Totalizadores transferidos para a função PRNRodape().
    /*
	nTotIT += SC7->C7_TOTAL
	nTotDSC += SC7->C7_VLDESC
	nTotIPI += SC7->C7_VALIPI
	nTotFRT += SC7->C7_VALFRE	
	*/ 
	// Fim alteração.
	
	nLin += 0020
	_oPrn:Say(nLin, 0065, Replicate('-', 400), oFontc,, RGB(220, 220, 220),, 0)
	nLin += 0035

Return

/*/
*****************************************************************************************************
***                                                                                               ***
***                                                                                               ***
*****************************************************************************************************
/*/
Static Function PRNRodape()

	Local nTotPED := 0
	Local aMargem := {nLin, 0050, (nMaxV - 55), (nMaxH - 55)}
	Local aTitRod1 := {{'Frete:', 'Seguro:', 'Outras Despesas:', 'Desconto:', 'IPI:', 'Embalagem:', 'Total dos Itens:'},;
		{'Valor por Extenso:', 'Total do Pedido:'},;
		{'Dados para Emissao da NF:', 'Endereco para Entrega:'},;
		{'Dados para Cobranca:', ''},;
		{'Assinatura: Fornecedor/Representante:', ''},;
		{'Observacoes:'}}
	
	Local aValRod1
	Local aTitRod2 := {{'Prazo:', 'Forma de Pagamento:', 'Previsao de Entrega:'}}
	Local aTitRod3 := {{''}, {'Comprador/Solicitante:', 'Assinatura/Autorizacao do Gestor Solicitante:'}}
	Local nX := 0
	Local nY := 0
	Local nK := 0
	Local nW := 0
	Local nSubBox1 := 0
	Local nSubBox2 := 0
	Local dDataPRV := '', nLinEnt, nContTxt
		
	// Incluído por Peder Munksgaard (Criare Consulting) em 28/05/2015.
	// Devido a uma série de incontáveis erros de totalizador pelo fato
	// de a soma ser realizada na função de impressão de itens.
	
    Local _cAlias  := GetNextAlias()
	Local _aAreaC7 := SC7->(GetArea())
	Local _cQry    := ""
	
	dbSelectArea("SC7")
	SC7->(dbSetOrder(1))
	If SC7->(dbSeek(MV_PAR02+MV_PAR01))

	   nTotIT  := 0
	   nTotDSC := 0
	   nTotIPI := 0 
	   nTotFRT := 0	
	
	   While SC7->(!Eof()) .And. SC7->(C7_FILIAL+C7_NUM) == MV_PAR02+MV_PAR01
	   
	      nTotIT  += SC7->C7_TOTAL
	      nTotDSC += SC7->C7_VLDESC
	      nTotIPI += SC7->C7_VALIPI
	      nTotFRT += SC7->C7_VALFRE
	      
	      SC7->(dbSkip())
	      
	   End
	   
	Endif
	
	nTotPED := ((nTotIT + nTotFRT + nTotSEG + nTotDSP + nTotIPI + nTotEMB) - nTotDSC)	
	
	RestArea(_aAreaC7)
	
	// Fim inclusão
	
	aValRod1 := {{Transform(nTotFRT, '@E 9,999,999.99'), Transform(nTotSEG, '@E 9,999,999.99'), Transform(nTotDSP, '@E 9,999,999.99'), Transform(nTotDSC, '@E 9,999,999.99'), Transform(nTotIPI, '@E 9,999,999.99'), Transform(nTotEMB, '@E 9,999,999.99'), Transform(nTotIT, '@E 99,999,999.99')}, {Extenso(nTotPED, .F., SC7->C7_MOEDA), Transform(nTotPED, '@E 9,999,999.99')}}
	
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(SC7->(C7_FILIAL + C7_NUMCOT + SC7->C7_FORNECE + SC7->C7_LOJA)))
    
    /* 
    // Alterado por Peder Munksgaard (Criare Consulting) em 09/06/2015 
    // Trecho removido
	// Pesquisa dados de pagamento do pedido 
	
	SCR->(dbSetOrder(1))
	SCR->(dbSeek(SC7->(C7_FILIAL + 'PC' + PadL(C7_NUM,TamSX3("CR_NUM")[1]))))
	While SCR->(!Eof()) .And. SCR->(CR_FILIAL + CR_TIPO + CR_NUM) == SC7->(C7_FILIAL + 'PC' + PadL(C7_NUM,TamSX("CR_NUM")[1]))
	
	    // Alteração por Peder Munksgaard (Criare Consulting) em 09/06/2015
	    // Colocado o "else" para tratar caso não haja data de liberação do pedido ou tenha sido 
	    // eliminado o resíduo.
	    
		If !Empty(SCR->CR_DATALIB)
			dDataPRV := (SCR->CR_DATALIB + SC8->C8_PRAZO + 1)
	    Else
	        dDataPRV := (IIF(!Emtpy(SC7->C7_XDATALI),SC7->C7_XDATALI,SC7->C7_DATPRF) + SC8->C8_PRAZO + 1)   
		EndIf
		
		// Fim alteração.
		SCR->(DbSkip())
	End
	*/
	
	// Incluído por Peder Munksgaard (Criare Consulting) em 09/06/2015.
	_cQry += CRLF + "SELECT MAX(CR_DATALIB) AS CR_DATALIB FROM " + RetSqlName("SCR") + " SCR (NOLOCK) "
	_cQry += CRLF + "WHERE  SCR.D_E_L_E_T_     = ' '"
	_cQry += CRLF + "AND    SCR.CR_FILIAL      = '" + SC7->C7_FILIAL + "'"
	_cQry += CRLF + "AND    SCR.CR_TIPO        = 'PC'"
	_cQry += CRLF + "AND    RTRIM(SCR.CR_NUM)  = '" + SC7->C7_NUM + "'"
	
	_cQry := ChangeQuery(_cQry)

    If Select((_cAlias)) > 0
    
       (_cAlias)->(dbCloseArea())
       
    Endif
    	
	TcQuery _cQry Alias (_cAlias) New
	
	If !Empty((_cAlias)->CR_DATALIB)
	
	   dDataPRV := StoD((_cAlias)->CR_DATALIB) + SC8->C8_PRAZO + 1
	   
	Else
	
	   _cQry := CRLF + "SELECT MAX(C7_XDATALI) AS C7_XDATALI FROM " + RetSqlName("SC7") + " SC7 (NOLOCK) "
	   _cQry += CRLF + "WHERE  SC7.D_E_L_E_T_     = ' '"
	   _cQry += CRLF + "AND    SC7.C7_FILIAL      = '" + SC7->C7_FILIAL + "'"
	   _cQry += CRLF + "AND    RTRIM(SC7.C7_NUM)  = '" + SC7->C7_NUM + "'"
	
       _cQry := ChangeQuery(_cQry)
 
       If Select((_cAlias)) > 0
    
          (_cAlias)->(dbCloseArea())
       
       Endif
    	
	   TcQuery _cQry Alias (_cAlias) New	
	   
	   If !Empty((_cAlias)->C7_XDATALI)
	   
	      dDataPRV := StoD((_cAlias)->C7_XDATALI) + SC8->C8_PRAZO + 1
	      
	   Else
	   
	      dDataPRV := StoD(Space(8)) 
	      
	   Endif
	   	   
	Endif
	// Fim inclusão
	
	// Alteração por Peder Munksgaard (Criare Consulting) em 09/06/2015
	//aValRod2 := {{StrZero(SC8->C8_PRAZO, 5) + ' DIAS', AllTrim(Posicione('SE4', 1, xFilial('SE4') + AllTrim(SC7->C7_COND), 'E4_DESCRI')), If(Empty(dDataPRV), dDataPRV, DtoC(dDataPRV))}}
	aValRod2 := {{StrZero(SC8->C8_PRAZO, 5) + ' DIAS', AllTrim(Posicione('SE4', 1, xFilial('SE4') + AllTrim(SC7->C7_COND), 'E4_DESCRI')),  DtoC(dDataPRV)}}
	// Fim alteração.
	
	aValRod3 := {{''}, {'', ''}}
	
	SY1->(DbSetOrder(3))
	If SY1->(DbSeek(xFilial('SY1') + SC7->C7_USER))
		If !Empty(SY1->Y1_XRESP)
			SY1->(DbSetOrder(1))
			If SY1->(DbSeek(xFilial('SY1') + SY1->Y1_XRESP))
				aValRod3 := {{''}, {SY1->Y1_COD + ' - ' + AllTrim(SY1->Y1_NOME), Replicate('_', 25) + Space(5) + 'Data: _____/_____/__________'}}
			EndIf
		Else
			aValRod3 := {{''}, {SY1->Y1_COD + ' - ' + AllTrim(SY1->Y1_NOME), Replicate('_', 25) + Space(5) + 'Data: _____/_____/__________'}}
		EndIf
	EndIf      
	
	DbSelectArea("SC1")
	DbSetOrder(1)
	If DbSeek(xFilial('SC1') + SC8->C8_NUMSC + SC8->C8_ITEMSC)
		/*
		SY1->(DbSetOrder(3))
		If SY1->(DbSeek(xFilial('SY1') + SC7->C7_USER))
			If !Empty(SY1->Y1_XRESP)
				SY1->(DbSetOrder(1))
				If SY1->(DbSeek(xFilial('SY1') + SY1->Y1_XRESP))
					aValRod3[1][2][1] += " / "+ SY1->Y1_COD + ' - ' + AllTrim(SY1->Y1_NOME)
				Endif
			Else
				aValRod3[1][2][1] += " / "+ SY1->Y1_COD + ' - ' + AllTrim(SY1->Y1_NOME)
			EndIf
		EndIf                           	
		*/
		PswOrder(1)
		If (PswSeek(AllTrim(SC1->C1_USER), .T.))
			aInfoUsu := PswRet(1)
			aValRod3[2][1] += " / "+ AllTrim(ainfousu[1][4])   			
		Else
			aValRod3[2][1] += " / "+ AllTrim(SC1->C1_SOLCIIT)   		
		EndIf
	Endif	

	/*/ Calcula disposicao/dimensoes dos boxs no relatorio /*/
	aADisp1 := {aMargem[1], aMargem[2], aMargem[3], aMargem[4]}
	aObjHor1 := {{14.28, 14.28, 14.28, 14.28, 14.28, 14.28, 14.32}, {83.35, 16.65}, {50, 50}, {50, 50}, {50, 50}, {100}}
	aObjVer1 := {{10, 10, 10, 10, 10, 10, 10}, {10, 10}, {20, 20}, {20, 20}, {20, 20}, {20}}
	aObjMar1 := {5, 5, 5, 5, 5}
	aDimObj1 := U_LMPCalcObj(1, aADisp1, aObjHor1, aObjVer1, aObjMar1)

	For nX := 1 To Len(aDimObj1)
		For nY := 1 To Len(aDimObj1[nX])
			/*/ Preenche o box com cinza /*/
			If ((nX == 3) .And. (nY == 1)) .Or. ((nX == 4) .And. (nY == 1))
				_oPrn:FillRect({(aDimObj1[nX, nY, 1] + 1), (aDimObj1[nX, nY, 2] + 1), (aDimObj1[nX, nY, 3] - 1), (aDimObj1[nX, nY, 4] - 1)}, oBrush1)
			EndIf

			/*/ Preenche o box com amarelo /*/
			If ((nX == 2) .And. (nY == 2))
				_oPrn:FillRect({(aDimObj1[nX, nY, 1] + 1), (aDimObj1[nX, nY, 2] + 1), (aDimObj1[nX, nY, 3] - 1), (aDimObj1[nX, nY, 4] - 1)}, oBrush2)
			EndIf

			/*/ Desenha os box?s /*/
			_oPrn:Box(aDimObj1[nX, nY, 1], aDimObj1[nX, nY, 2], aDimObj1[nX, nY, 3], aDimObj1[nX, nY, 4])

			If ((nX == 3) .And. (nY == 1)) // Cria os sub-box?s desta linha do grid. BOX: DADOS PARA EMISSAO DA NOTA FISCAL
				//If (nPgAtu == (nQTDPg - 1))
				//If (nPgAtu == Iif(nQTDPg > 1, nQTDPg - 1, nQTDPg))
				//Alterado por Rafael Sacramento (Criare Consulting) em 15/10/2015
				If (nPgAtu == nQTDPg)
					_oPrn:Say((aDimObj1[nX, nY, 1] + 50), (aDimObj1[nX, nY, 2] + 10), AllTrim(SM0->M0_NOMECOM), oFontcN,,,, 0)								// Nome da Empresa
					_oPrn:Say((aDimObj1[nX, nY, 1] + 50), (aDimObj1[nX, nY, 2] + 1200), 'CEP: ' + Transform(SM0->M0_CEPCOB, '@R 99999-999'), oFontgN,,,, 0)			// CEP da Empresa
					_oPrn:Say((aDimObj1[nX, nY, 1] + 100), (aDimObj1[nX, nY, 2] + 10), 'ENDERECO: ' + AllTrim(SM0->M0_ENDCOB) + ', ' + AllTrim(SM0->M0_CIDCOB) + ' - ' + SM0->M0_ESTCOB, oFontgN,,,, 0)		// Endereco da Empresa
					_oPrn:Say((aDimObj1[nX, nY, 1] + 145), (aDimObj1[nX, nY, 2] + 10), 'CNPJ: ' + Transform(SM0->M0_CGC, '@R 99.999.999/9999-99'), oFontgN,,,, 0)	// CNPJ da Empresa
					If (AllTrim(SM0->M0_INSC) <> 'ISENTO')
						_oPrn:Say((aDimObj1[nX, nY, 1] + 145), (aDimObj1[nX, nY, 2] + 500), 'INSC. ESTADUAL: ' + Transform(SM0->M0_INSC, '@R 99.999.99-9'), oFontgN,,,, 0)	// Inscricao Estadual da Empresa
					Else
						_oPrn:Say((aDimObj1[nX, nY, 1] + 145), (aDimObj1[nX, nY, 2] + 500), 'INSC. ESTADUAL: ' + SM0->M0_INSC, oFontgN,,,, 0)	// Inscricao Estadual da Empresa
					EndIf
					If (AllTrim(SM0->M0_INSCM) <> 'ISENTO')
						_oPrn:Say((aDimObj1[nX, nY, 1] + 145), (aDimObj1[nX, nY, 2] + 1000), 'INSC. MUNICIPAL: ' + Transform(SM0->M0_CGC, '@R 9.999.999-9'), oFontgN,,,, 0)	// Inscricao Municipal da Empresa
					Else
						_oPrn:Say((aDimObj1[nX, nY, 1] + 145), (aDimObj1[nX, nY, 2] + 1000), 'INSC. MUNICIPAL: ' + SM0->M0_INSCM, oFontgN,,,, 0)	// Inscricao Municipal da Empresa
					EndIf
				EndIf
			ElseIf ((nX == 3) .And. (nY == 2)) // Cria os sub-box?s desta linha do grid. BOX: ENDERECO PARA ENTREGA
				/*/ Calcula disposicao/dimensoes dos boxs no relatorio /*/
				aADisp2 := {aDimObj1[nX, nY, 1], aDimObj1[nX, nY, 2], aDimObj1[nX, nY, 3], aDimObj1[nX, nY, 4]}
				aObjHor2 := {{100}, {100}}
				aObjVer2 := {{70}, {30}}
				aObjMar2 := {0, 0, 0, 0, 0}
				aDimObj2 := U_LMPCalcObj(1, aADisp2, aObjHor2, aObjVer2, aObjMar2)
				
				For nSubBox1 := 1 To Len(aDimObj2)
					For nSubBox2 := 1 To Len(aDimObj2[nSubBox1])
						If ((nSubBox1 == 1) .And. (nSubBox2 == 1))
							_oPrn:FillRect({(aDimObj2[nSubBox1, nSubBox2, 1] + 1), (aDimObj2[nSubBox1, nSubBox2, 2] + 1), (aDimObj2[nSubBox1, nSubBox2, 3] - 1), (aDimObj2[nSubBox1, nSubBox2, 4] - 1)}, oBrush2)
							
							cMsgImp := ''
							For nLinEnt := 1 To 10
								cStr := AllTrim(MemoLine(cMsgEnt, 100, nLinEnt)) + ' '
								If Empty(cStr)
									Loop
								Else
									cMsgImp += cStr
								EndIf
							Next
							
							nLinImp := (aDimObj2[nSubBox1, nSubBox2, 1] + 10)
							nColImp := (aDimObj2[nSubBox1, nSubBox2, 2] + 10)
							nCont := 0
							nContLin := 0
							cMsgEnt := ''
							For nLinEnt := 1 To Len(cMsgImp)
								nCont++
								cMsgEnt += SubStr(cMsgImp, nLinEnt, 1)
								//If (nCont == 63)
								//If (nCont == 100)
								//Alterado por Rafael Sacramento (Criare Consulting)em 25/06/2015 - Chamado 17665 - A mensagem está excedendo o espaço delimitado para o campo no relatório.
								If (nCont > 65)
									nCont := 0
									nContLin++
									If (nContLin > 3)
										cMsgEnt := ''
										Exit
									EndIf
									If (nContLin > 1)
										nLinImp += 40
									EndIf
									//If (nPgAtu == (nQTDPg - 1))
									//If (nPgAtu == Iif(nQTDPg > 1, nQTDPg - 1, nQTDPg))
									//Alterado por Rafael Sacramento (Criare Consulting) em 15/10/2015
									If (nPgAtu == nQTDPg)
										_oPrn:Say(nLinImp, If((nContLin == 1), (nColImp + 290), nColImp), cMsgEnt, oFontgN,, RGB(000, 000, 000),, 0)
									EndIf
									cMsgEnt := ''
								EndIf
							Next
							If !Empty(cMsgEnt) .And. (nContLin <= 3)
								//If (nPgAtu == (nQTDPg - 1))
								//If (nPgAtu == Iif(nQTDPg > 1, nQTDPg - 1, nQTDPg))
								//Alterado por Rafael Sacramento (Criare Consulting) em 15/10/2015
								If (nPgAtu == nQTDPg)
									nLinImp += 40
									_oPrn:Say(nLinImp, nColImp, cMsgEnt, oFontgN,, RGB(000, 000, 000),, 0)
								EndIf
							EndIf
							cMsgEnt := cMsgBkp
						EndIf
						_oPrn:Box(aDimObj2[nSubBox1, nSubBox2, 1], aDimObj2[nSubBox1, nSubBox2, 2], aDimObj2[nSubBox1, nSubBox2, 3], aDimObj2[nSubBox1, nSubBox2, 4])
						If (nSubBox1 == 2)
							_oPrn:Say((aDimObj2[nSubBox1, nSubBox2, 1] + 10), ((aDimObj2[nSubBox1, nSubBox2, 2] + aDimObj2[nSubBox1, nSubBox2, 4]) / 2), 'A MERCADORIA SOMENTE SERA ACEITA SE CONSTAR O NUMERO DO PEDIDO NA NOTA FISCAL', oFontgN,, RGB(255, 000, 000),, 2)
						EndIf
					Next
				Next
			EndIf

			If ((nX == 4) .And. (nY == 1)) // Cria os sub-box?s desta linha do grid. BOX: ENDERECO PARA COBRANCA
				//If (nPgAtu == (nQTDPg - 1))
				//If (nPgAtu == Iif(nQTDPg > 1, nQTDPg - 1, nQTDPg))
				//Alterado por Rafael Sacramento (Criare Consulting) em 15/10/2015
				If (nPgAtu == nQTDPg)
					_oPrn:Say((aDimObj1[nX, nY, 1] + 50), (aDimObj1[nX, nY, 2] + 10), 'ENDERECO: ' + AllTrim(SM0->M0_ENDCOB), oFontgN,,,, 0)		// Endereco de Cobranca da Empresa
					_oPrn:Say((aDimObj1[nX, nY, 1] + 50), (aDimObj1[nX, nY, 2] + 1200), 'TELEFONE: ' + Transform(SM0->M0_TEL, '@R (99)9999-9999'), oFontgN,,,, 0)		// Telefone de Cobranca
					_oPrn:Say((aDimObj1[nX, nY, 1] + 100), (aDimObj1[nX, nY, 2] + 10), 'CIDADE: ' + AllTrim(SM0->M0_CIDCOB), oFontgN,,,, 0)	// Cidade de Cobranca
					_oPrn:Say((aDimObj1[nX, nY, 1] + 100), (aDimObj1[nX, nY, 2] + 700), 'UF: ' + AllTrim(SM0->M0_ESTCOB), oFontgN,,,, 0)	// UF de Cobranca
					_oPrn:Say((aDimObj1[nX, nY, 1] + 100), (aDimObj1[nX, nY, 2] + 1200), 'CEP: ' + Transform(SM0->M0_CEPCOB, '@R 99999-999'), oFontgN,,,, 0)			// CEP de Cobranca
				EndIf
			ElseIf ((nX == 4) .And. (nY == 2)) // Cria os sub-box?s desta linha do grid. BOX: CONDICOES DE PAGAMENTO
				/*/ Calcula disposicao/dimensoes dos boxs no relatorio /*/
				aADisp3 := {aDimObj1[nX, nY, 1], aDimObj1[nX, nY, 2], aDimObj1[nX, nY, 3], aDimObj1[nX, nY, 4]}
				aObjHor3 := {{100}, {100}, {100}}
				aObjVer3 := {{33}, {33}, {34}}
				aObjMar3 := {0, 0, 0, 0, 0}
				aDimObj3 := U_LMPCalcObj(1, aADisp3, aObjHor3, aObjVer3, aObjMar3)
				For nSubBox1 := 1 To Len(aDimObj3)
					For nSubBox2 := 1 To Len(aDimObj3[nSubBox1])
						If (nSubBox1 == 1) // Preenche o box com cinza
						// _oPrn:FillRect({(aDimObj3[nX, nY, 1] + 1), (aDimObj3[nX, nY, 2] + 1), (aDimObj3[nX, nY, 3] - 1), (aDimObj3[nX, nY, 4] - 1)}, oBrush1)
						EndIf
						_oPrn:Box(aDimObj3[nSubBox1, nSubBox2, 1], aDimObj3[nSubBox1, nSubBox2, 2], aDimObj3[nSubBox1, nSubBox2, 3], aDimObj3[nSubBox1, nSubBox2, 4])
						If (nSubBox1 == 1)
							_oPrn:Say((aDimObj3[nSubBox1, nSubBox2, 1] + 10), ((aDimObj3[nSubBox1, nSubBox2, 2] + aDimObj3[nSubBox1, nSubBox2, 4]) / 2), 'CONDICOES DE PAGAMENTO', oFonteN,,,, 2)
						EndIf
						If (nSubBox1 == 2)
							/*/ Calcula disposicao/dimensoes dos boxs no relatorio /*/
							aADisp4 := {aDimObj3[nSubBox1, nSubBox2, 1], aDimObj3[nSubBox1, nSubBox2, 2], aDimObj3[nSubBox1, nSubBox2, 3], aDimObj3[nSubBox1, nSubBox2, 4]}
							aObjHor4 := {{20, 50, 30}}
							aObjVer4 := {{100, 100, 100}}
							aObjMar4 := {0, 0, 0, 0, 0}
							aDimObj4 := U_LMPCalcObj(1, aADisp4, aObjHor4, aObjVer4, aObjMar4)
							For nK := 1 To Len(aDimObj4)
								For nW := 1 To Len(aDimObj4[nK])
									_oPrn:Box(aDimObj4[nK, nW, 1], aDimObj4[nK, nW, 2], aDimObj4[nK, nW, 3], aDimObj4[nK, nW, 4])
									//_oPrn:Say((aDimObj4[nK, nW, 1] + 15), (aDimObj4[nK, nW, 2] + 10), aTitRod2[nK, nW] + If((nPgAtu == (nQTDPg - 1)), Space(5) + aValRod2[nK, nW], ''), oFontbN,,,, 0)
									//_oPrn:Say((aDimObj4[nK, nW, 1] + 15), (aDimObj4[nK, nW, 2] + 10), aTitRod2[nK, nW] + If((nPgAtu == Iif(nQTDPg > 1, nQTDPg, nQTDPg)), Space(5) + aValRod2[nK, nW], ''), oFontbN,,,, 0)
									//Alterado por Rafael Sacramento (Criare Consulting) em 15/10/2015
									_oPrn:Say((aDimObj4[nK, nW, 1] + 15), (aDimObj4[nK, nW, 2] + 10), aTitRod2[nK, nW] + If((nPgAtu == nQTDPg), Space(5) + aValRod2[nK, nW], ''), oFontbN,,,, 0)
								Next
							Next
						EndIf
						If (nSubBox1 == 3)
							_oPrn:Say((aDimObj3[nSubBox1, nSubBox2, 1] + 10), ((aDimObj3[nSubBox1, nSubBox2, 2] + aDimObj3[nSubBox1, nSubBox2, 4]) / 2), 'AJUSTAR A DATA DE VENCIMENTO PARA DATAS QUE A CPN REALIZA PAGTO: 5/10/15/20/25/30', oFontgN,, RGB(255, 000, 000),, 2)
						EndIf
					Next
				Next
			EndIf

			If ((nX == 5) .And. (nY == 1))
				_oPrn:Say((aDimObj1[nX, nY, 1] + 35), (aDimObj1[nX, nY, 2] + 10), 'MANIFESTAMOS NOSSA INTEGRAL ACEITACAO COM OS TERMOS DO PRESENTE PEDIDO DE FORNECIMENTO.', oFontbN,, RGB(255, 000, 000),, 0)
				_oPrn:Say((aDimObj1[nX, nY, 1] + 55), (aDimObj1[nX, nY, 2] + 10), 'INCLUSIVE NO QUE TANGE AS CONDICOES GERAIS CONSTANTES NO ANEXO I, OBRIGANDO-NOS, ASSIM, A SUA FIEL OBSERVANCIA.', oFontbN,, RGB(255, 000, 000),, 0)
				_oPrn:Say((aDimObj1[nX, nY, 3] - 40), ((aDimObj1[nX, nY, 2] + aDimObj1[nX, nY, 4]) / 2), Replicate('_', 50) + Space(10) + 'Data: _____/_____/__________', oFontbN,,,, 2)
			ElseIf ((nX == 5) .And. (nY == 2)) // Cria os sub-box?s desta linha do grid. BOX: ASSINATURA
				/*/ Calcula disposicao/dimensoes dos boxs no relatorio /*/
				aADisp5 := {aDimObj1[nX, nY, 1], aDimObj1[nX, nY, 2], aDimObj1[nX, nY, 3], aDimObj1[nX, nY, 4]}
				aObjHor5 := {{100}, {50, 50}}
				aObjVer5 := {{30}, {70, 70}}
				aObjMar5 := {0, 0, 0, 0, 0}
				aDimObj5 := U_LMPCalcObj(1, aADisp5, aObjHor5, aObjVer5, aObjMar5)
				For nSubBox1 := 1 To Len(aDimObj5)
					For nSubBox2 := 1 To Len(aDimObj5[nSubBox1])
						If ((nSubBox1 == 1) .And. (nSubBox2 == 1))
							_oPrn:FillRect({(aDimObj5[nSubBox1, nSubBox2, 1] + 1), (aDimObj5[nSubBox1, nSubBox2, 2] + 1), (aDimObj5[nSubBox1, nSubBox2, 3] - 1), (aDimObj5[nSubBox1, nSubBox2, 4] - 1)}, oBrush2)
						EndIf
						If ((nSubBox1 <> 2) .And. (nSubBox2 <> 2))
							_oPrn:Box(aDimObj5[nSubBox1, nSubBox2, 1], aDimObj5[nSubBox1, nSubBox2, 2], aDimObj5[nSubBox1, nSubBox2, 3], aDimObj5[nSubBox1, nSubBox2, 4])
						EndIf
						If ((nSubBox1 == 1) .And. (nSubBox2 == 1))
							_oPrn:Say((aDimObj5[nSubBox1, nSubBox2, 1] + 05), (aDimObj5[nSubBox1, nSubBox2, 2] + 10), 'IMPORTANTE:', oFontbN,, RGB(255, 000, 000),, 0)
							_oPrn:Say((aDimObj5[nSubBox1, nSubBox2, 1] + 25), (aDimObj5[nSubBox1, nSubBox2, 2] + 10), 'INFORMAMOS QUE A CONCESSIONARIA PORTO NOVO S/A: NAO AUTORIZA A NEGOCIACAO DE DESCONTO DE SEUS TITULOS.', oFontbN,, RGB(255, 000, 000),, 0)
						EndIf
						If ((nSubBox1 == 2) .And. (nSubBox2 == 1))
							_oPrn:Say((aDimObj5[nSubBox1, nSubBox2, 1] + 10), (aDimObj5[nSubBox1, nSubBox2, 2] + 10), aTitRod3[nSubBox1, nSubBox2], oFontbN,,,, 0)
							//If (nPgAtu == (nQTDPg - 1))
							//If (nPgAtu == Iif(nQTDPg > 1, nQTDPg - 1, nQTDPg))
							//Alterado por Rafael Sacramento (Criare Consulting) em 15/10/2015
							If (nPgAtu == nQTDPg)
								_oPrn:Say((aDimObj5[nSubBox1, nSubBox2, 1] + 40), (aDimObj5[nSubBox1, nSubBox2, 2] + 20), Upper(aValRod3[nSubBox1, nSubBox2]), oFonteN,,,, 0)
							EndIf
						//ElseIf ((nSubBox1 == 2) .And. (nSubBox2 == 2))
						//	_oPrn:Say((aDimObj5[nSubBox1, nSubBox2, 1] + 10), (aDimObj5[nSubBox1, nSubBox2, 2] + 10), aTitRod3[nSubBox1, nSubBox2], oFontbN,,,, 0)
						//	_oPrn:Say((aDimObj5[nSubBox1, nSubBox2, 3] - 40), ((aDimObj5[nSubBox1, nSubBox2, 2] + aDimObj5[nSubBox1, nSubBox2, 4]) / 2), aValRod3[nSubBox1, nSubBox2], oFontbN,,,, 2)
						EndIf
					Next
				Next
			EndIf

			/*/ Imprime os titulos dos boxs /*/
			_oPrn:Say((aDimObj1[nX, nY, 1] + 10), (aDimObj1[nX, nY, 2] + 10), aTitRod1[nX, nY], oFontbN,,,, 0)

			/*/ Preenche com os valores dos campos /*/
			If (nX == 1)
				//If (nPgAtu == (nQTDPg - 1))
				//If (nPgAtu == Iif(nQTDPg > 1, nQTDPg - 1, nQTDPg))
				//Alterado por Rafael Sacramento (Criare Consulting) em 15/10/2015
				If (nPgAtu == nQTDPg)
					_oPrn:Say((aDimObj1[nX, nY, 1] + 15), (aDimObj1[nX, nY, 4] - 10), aValRod1[nX, nY], oFontcN,,,, 1)
				EndIf
			EndIf
			
			If ((nX == 2) .And. (nY == 1))
				//If (nPgAtu == (nQTDPg - 1))
				//If (nPgAtu == Iif(nQTDPg > 1, nQTDPg - 1, nQTDPg))
				//Alterado por Rafael Sacramento (Criare Consulting) em 15/10/2015
				If (nPgAtu == nQTDPg)
					_oPrn:Say((aDimObj1[nX, nY, 1] + 15), (aDimObj1[nX, nY, 2] + 250), aValRod1[nX, nY], oFontcN,,,, 0)
				EndIf
			ElseIf ((nX == 2) .And. (nY == 2))
				//If (nPgAtu == (nQTDPg - 1))
				//If (nPgAtu == Iif(nQTDPg > 1, nQTDPg - 1, nQTDPg))
				//Alterado por Rafael Sacramento (Criare Consulting) em 15/10/2015
				If (nPgAtu == nQTDPg)
					_oPrn:Say((aDimObj1[nX, nY, 1] + 15), (aDimObj1[nX, nY, 4] - 10), aValRod1[nX, nY], oFontcN,,,, 1)
				EndIf
			ElseIf (nX == 6) // Cria os sub-box?s desta linha do grid. BOX: OBSERVACAO
				/*/ Calcula disposicao/dimensoes dos boxs no relatorio /*/
				aADisp7 := {aDimObj1[nX, nY, 1], aDimObj1[nX, nY, 2], aDimObj1[nX, nY, 3], aDimObj1[nX, nY, 4]}
				aObjHor7 := {{90, 10}}
				aObjVer7 := {{100, 100}}
				aObjMar7 := {0, 0, 0, 0, 0}
				aDimObj7 := U_LMPCalcObj(1, aADisp7, aObjHor7, aObjVer7, aObjMar7)
				For nSubBox1 := 1 To Len(aDimObj7)
					For nSubBox2 := 1 To Len(aDimObj7[nSubBox1])
						_oPrn:Box(aDimObj7[nSubBox1, nSubBox2, 1], aDimObj7[nSubBox1, nSubBox2, 2], aDimObj7[nSubBox1, nSubBox2, 3], aDimObj7[nSubBox1, nSubBox2, 4])
						
						If (nSubBox2 == 1)
							nRecSC7 := SC7->(Recno())
							SC7->(DbGoTop())
							SC7->(DbSetOrder(1))
							SC7->(DbSeek(mv_par02 + mv_par01))
							cMsgObs := ''
							nCont := 0
							nContObs := 0
							nLinObs := (aDimObj7[nSubBox1, nSubBox2, 1] + 30)
							nColObs := (aDimObj7[nSubBox1, nSubBox2, 2] + 10)
							
							cMsgImp := ''
							cTObs := AllTrim(SC7->C7_XOBS)
							For nLinEnt := 1 To 10
								cStr := AllTrim(MemoLine(cTObs, 100 , nLinEnt)) + ' '
								If Empty(cStr)
									Loop
								Else
									cMsgImp += cStr
								EndIf
							Next

							DbSelectArea("SC1")
							DbSetOrder(1)
							If DbSeek(xFilial('SC1') + SC8->C8_NUMSC )
								While xFilial('SC1') + SC8->C8_NUMSC == SC1->C1_FILIAL+SC1->C1_NUM
									cMsgImp += AllTrim(SC1->C1_OBS)+" "                                 
									SC1->(DbSkip())
								EndDo
							Endif
							
							For nContTxt := 1 To Len(AllTrim(cMsgImp))
								nCont++
								cMsgObs += SubStr(AllTrim(cMsgImp), nContTxt, 1)
								If (nCont == 160) .or. nContTxt = Len(AllTrim(SC7->C7_XOBS))
									nCont := 0
									nContObs++
									If (nContObs > 1)
										nLinObs += 40
									EndIf
									//If (nPgAtu == (nQTDPg - 1))
									//If (nPgAtu == Iif(nQTDPg > 1, nQTDPg - 1, nQTDPg))
									//Alterado por Rafael Sacramento (Criare Consulting) em 15/10/2015
								    If (nPgAtu == nQTDPg)
										_oPrn:Say(nLinObs, If((nContObs == 1), (nColObs + 230), nColObs), cMsgObs, oFontgN,, RGB(000, 000, 000),, 0)
									EndIf
									cMsgObs := ''
									
								EndIf
							Next
							If !Empty(cMsgObs)
								//If (nPgAtu == (nQTDPg - 1))
								//If (nPgAtu == Iif(nQTDPg > 1, nQTDPg - 1, nQTDPg))
								//Alterado por Rafael Sacramento (Criare Consulting) em 15/10/2015
								If (nPgAtu == nQTDPg)
									nLinObs += 40
									_oPrn:Say(nLinObs, nColObs, cMsgObs, oFontgN,, RGB(000, 000, 000),, 0)
								EndIf
							EndIf
							
							SC7->(DbGoTo(nRecSC7))
						ElseIf (nSubBox2 == 2)
							_oPrn:Say((aDimObj7[nSubBox1, nSubBox2, 1] + 10), (aDimObj7[nSubBox1, nSubBox2, 2] + 10), 'Pagina:', oFontbN,,,, 0)
							//Alterado por Rafael Sacramento (Criare Consulting) em 15/10/2015
							//_oPrn:Say((aDimObj7[nSubBox1, nSubBox2, 1] + 28), ((aDimObj7[nSubBox1, nSubBox2, 2] + aDimObj7[nSubBox1, nSubBox2, 4]) / 2), (StrZero(nPgAtu, 2) + '/' + StrZero(Iif(nQTDPg == 1, nQTDPg - 1, nQTDPg), 2)), oFontfN,, /*RGB(215, 215, 215)*/,, 2)
							  _oPrn:Say((aDimObj7[nSubBox1, nSubBox2, 1] + 68), ((aDimObj7[nSubBox1, nSubBox2, 2] + aDimObj7[nSubBox1, nSubBox2, 4]) / 2), (StrZero(nPgAtu, 2) + '/' + StrZero((nQTDPg + 1), 2)), oFonthN,, /*RGB(215, 215, 215)*/,, 2)
						EndIf
					Next
				Next
			EndIf
		Next
	Next

Return

/*/
*****************************************************************************************************
***                                                                                               ***
***                                                                                               ***
*****************************************************************************************************
/*/
Static Function PNRVerso()

	Local nSubBox1 := 0
	Local nSubBox2 := 0
	Local aMargem := {0020, 0020, (nMaxV - 55), (nMaxH - 55)}
	Local _cNivel  := ''
	
	_oPrn:EndPage()
	_oPrn:StartPage()
	
	/*/ Calcula disposicao/dimensoes dos boxs no relatorio /*/
	aADisp6 := {aMargem[1], aMargem[2], aMargem[3], aMargem[4]}
	aObjHor6 := {{100}, {15, 14, 14, 14, 14, 14, 15}, {80, 10, 10}}
	aObjVer6 := {{80}, {8, 8, 8, 8, 8, 8, 8}, {6, 6, 6}}
	aObjMar6 := {10, 10, 10, 10, 10}
	aDimObj6 := U_LMPCalcObj(1, aADisp6, aObjHor6, aObjVer6, aObjMar6)
	For nSubBox1 := 1 To Len(aDimObj6)
		For nSubBox2 := 1 To Len(aDimObj6[nSubBox1])
			_oPrn:Box(aDimObj6[nSubBox1, nSubBox2, 1], aDimObj6[nSubBox1, nSubBox2, 2], aDimObj6[nSubBox1, nSubBox2, 3], aDimObj6[nSubBox1, nSubBox2, 4])
			If (nSubBox1 == 1)
				nIncLin := aDimObj6[nSubBox1, nSubBox2, 1]
				_oPrn:Say((nIncLin += 20), ((aDimObj6[nSubBox1, nSubBox2, 2] + aDimObj6[nSubBox1, nSubBox2, 4]) / 2), 'Anexo I - Condições Gerais que Compoem o Pedido de Fornecimento', oFontcN,,,, 2)
				_oPrn:Say((nIncLin += 60), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'OS FORNECIMENTOS DECORRENTES DO PRESENTE PEDIDO SUBORDINAM-SE AS SEGUINTES CONDICOES GERAIS:', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '01 - O prazo de pagamento será contado a partir da data da entrega do material.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '02 - O pagamento do fornecimento objeto do presente pedido, inclusive em face de título de crédito eventualmente ao mesmo vinculado, fica subordinado a observância, pelo Fornecedor, das condições de cobranca aqui estipuladas.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '03 - O número deste pedido deverá constar no corpo da Nota Fiscal Fatura, Duplicata e Conhecimento.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '04 - O fornecedor deverá informar, quando da emissão de título de crédito, se o mesmo encontra-se para cobrança em banco ou carteira, devendo informar, no primeiro caso, o nome do banco, praça e agência.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '05 - O fornecedor fica obrigado a fabricar ou a entregar os bens de materiais, obedecendo rigorosamente às especificações constantes do pedido e aos métodos de fabricação mais adequados às Normas Técnicas expedidas pela A.B.N.T.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '06 - O  fornecedor fixará prazo para garantia do material fornecido, sempre contado do início de sua utilização pelo comprador.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '07 - O Fornecedor se obriga a cumprir rigorosamente os prazos de entrega fixados nos respectivos pedidos de fornecimento.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '08 - O recebimento do material fornecido fica subordinado a conferência ou inspeção preliminar, conforme o caso, sem prejuizo, porém, da garantia referida no item 6 ou da responsabilidade do fornecedor por defeitos ocultos ou vícios redibitórios.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '09 - O preço do fornecimento não será reajustado, salvo ajuste por escrito, em contrário.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '10 - O fornecimento obedecerá, salvo disposição em contrário, a cláusula "CIF", correndo por conta do fornecedor todas as despesas de frete, embalagem, carregamento e descarregamento, inclusive seguro.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '11 - Os pagamentos relativos ao preço do fornecimento serão feitos de acordo com os prazos fixados no pedido de fornecimento e, no caso de tratar-se de material sujeito a inspeção ou teste, após a realização destes.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '12 - Para garantia do integral cumprimento das obrigações do fornecedor, poderá o comprador reter 10% (dez por cento) do valor de cada pagamento, quando estes forem feitos parcelarmente. A quantia retida será entregue ao fornecedor, ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'sem juros ou correção monetária, após a completa e perfeita do pedido de fornecimento e depois de deduzidas as multas ou indenizações devidas ao comprador.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '13 - O atraso no cumprimento, pelo fornecedor, de quaisquer de suas obrigações contratuais, especialmente no que se refere aos prazos de entrega dos materiais, sujeita-o ao pagamento de multa, simplesmente moratória, equivalente a ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '20% (vinte por cento) do valor do pedido, sem prejuizo da faculdade contida no item subsequente.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '14 - O não cumprimento, pelo Fornecedor, de quaisquer de suas obrigações contratuais ou o seu cumprimento apenas parcial ou defeituoso, dará ao comprador a faculdade de considerar rescindido o contrato e cancelado o pedido de fornecimento,', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'de pleno direito, independentemente de aviso, notificação ou interpelação judicial ou extrajudicial, sujeitando-se, ainda, o Fornecedor ao pagamento de todas as perdas e danos que efetivamente forem causados pelo inadimplemento.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '15 - O Fornecedor assume ampla e integral responsabilidade pelos materiais fornecidos, garantindo-os quanto a vícios de qualidade ou quantidade que os tornem impróprios ou inadequações ao uso a que se destinam, ao tempo em que ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'assegura ao adquirente o reembolso de toda e qualquer despesa que este venha a ter em razão de falhas ou imperfeições dos materiais objeto do presente Pedido de Fornecimento. Com base na declaração do adquirente, ICMS foi calculado pela ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'alíquota interna, na forma do Art. 155, Paragrafo 2°, inciso VII, letra "b", da Constituição Federal. Adiquirente não e Contribuinte do ICMS.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '16 - O Fornecedor assume o compromisso de cumprir com os valores e princípios preservados e praticados pela Contratante, tais como afirma ter avaliado seus fornecedores e subcontratados e que os mesmos atendem aos normativos e as ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'condutas impostos pela Contratante, dentre os quais os específicos de responsabilidade social, tais como proibição do trabalho infantil, a pratica de relações de trabalho adequadas e respeito ao meio-ambiente, em especial a ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'observância quanto a certificação de origem dos insumos, bem como exige que a referida medida seja adotada nos contratos firmados com seus subcontratados e demais fornecedores de insumos e/ou prestadores de serviços, sob ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'pena de rescisão do contrato, obrigando-se a cumprir integralmente tais critérios, de acordo com legislação pertinente, sob pena de assim não procedendo ficar sujeita a imposição das penalidades previstas no presente ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'instrumento, autorizando desde já a realização da pertinente fiscalização pela Contratante.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '17 - A CONTRATADA renuncia expressamente a faculdade de emitir qualquer título de crédito, inclusive duplicatas, em razão dos serviços prestados e/ou compras efetuadas ademais, é vedado à CONTRATADA tanto utilizar o presente ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'contrato em garantia de transações bancárias e/ou financeiras, de qualquer espécie, quanto efetuar operação de desconto, negociar ou, de qualquer forma, ceder os créditos decorrentes da execução deste contrato as instituições ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'financeiras, empresas de factoring ou terceiros, sem prévia e expressa autorização da CONTRATANTE, sob pena de a CONTRATADA se sujeitar ao pagamento de multa de quarenta por cento (40%) do valor da duplicata e/ou título ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'irregularmente emitida ou apresentada, sem prejuizo de eventual indenização suplementar.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '18 - Os pagamentos decorrentes da prestação dos serviços e/ou das compras efetuadas serão efetuados única e exclusivamente por meio de depósito em conta corrente de titularidade da CONTRATADA, que deverá ser indicada em sua ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'Proposta Técnica e Comercial. Tais pagamentos serão considerados para todos os fins, como a mais plena, rasa, irrevogável e irretratável quitação pela prestação dos serviços e/ou compras efetuadas deste Pedido Compra.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '19 - Em caso de qualquer divergência entre os termos e condições da Proposta Técnica e Comercial e este Pedido de Compra, prevalecerão os termos e condições deste Pedido de Compra  e a tolerância por qualquer das partes, quanto ao ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'descumprimento das condições estipuladas nesta cláusula, representará mera liberalidade, não podendo ser invocada como novação contratual ou renúncia de direitos.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '20 - Em caso de Nota fiscal eletrônica de serviços, emitir até o dia 25 (vinte e cinco) de cada mês.', oFontg,,,, 0)
				
				//Incluído por Rafael Sacramento - Inclusão da cláusula anticorrupção - 18/02/2016
				
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '21 - O Fornecedor declara e garante por si e por suas subsidiárias, controladas e coligadas, bem como por seus respectivos acionistas, administradores (incluindo membros do conselho e diretores), executivos, funcionários, prepostos, agentes, ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'subcontratados, procuradores e qualquer outro representante a qualquer título (“Representantes”) que cumprem e continuarão cumprindo, durante a relação comercial estabelecida entre as PARTES, todas as leis e regulamentos aplicáveis às ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'atividades contratadas, incluindo, o Decreto-Lei nº 2.848/1940, Lei nº 8.429/1992, Lei nº 9.613/1998, Lei nº 12.529/2011 e a Lei 12.846/2013, em especial as disposições de seu artigo 5º, bem como seus respectivos regulamentos(“Normas Aplicáveis”).', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '21.1 - Sem prejuízo do disposto na cláusula anterior, o Fornecedor declara e garante que conhece o disposto no Código de Conduta de Fornecedores da Contratante, conforme Termo de Recebimento e Compromisso, comprometendo-se ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'a (i) observar e aplicar as regras do Código de Conduta de Fornecedores, e eventuais atualizações, durante a relação comercial estabelecida entre as PARTES; e (ii) divulgar o Código de Conduta de Fornecedores, e eventuais ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'atualizações, para seus diretores, executivos, funcionários, prepostos e/ou representantes, exigindo-lhes a aplicação e observância do referido Código, bem como das Normas Aplicáveis. O Fornecedor declara, ainda, que ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'aceitará receber treinamentos quanto às regras do Código de Conduta de Fornecedores, comprometendo-se a exigir a presença de todos os representantes envolvidos na execução das atividades contratadas nos referidos treinamentos.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '21.1.2 - A não realização dos treinamentos ou a não participação de qualquer representante do Fornecedor em treinamentos realizados não eximirá o Fornecedor da obrigação de cumprir as regras do Código de Conduta de Fornecedores.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '21.1.3 - O Fornecedor declara e garante que não é Autoridade Governamental e que nenhum de seus acionistas, administradores, membros de conselho, diretores, executivos, ou funcionários relacionados com as atividades ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'contratadas é Agente Público, ou tem relacionamento de qualquer natureza, incluindo pessoal, de negócios ou de associação, com qualquer Agente Público que está ou estará em posição de influenciar a obtenção de negócios ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'ou outras vantagens para a Contratante.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '21.1.4 - Qualquer prática, pelo Fornecedor, em violação às declarações constantes das cláusulas antecedentes poderá ensejar a resolução de pleno direito do PEDIDO DE FORNECIMENTO pela Contratante, de forma automática e ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'independentemente de qualquer formalidade, sendo certo que o Fornecedor isentará e manterá a Contratante indene em relação a quaisquer reivindicações, perdas ou danos, diretos e indiretos, inclusive lucros cessantes e danos ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'consequentes, relacionados ou decorrentes da violação cometida, sem prejuízo do direito de regresso da Contratante. O Fornecedor não terá direito a qualquer indenização, reivindicação ou demanda em face da Contratante por conta da ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'extinção do PEDIDO DE FORNECIMENTO.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '21.1.5 - O Fornecedor deverá comunicar imediatamente à Contratante qualquer evento que possa implicar violação de qualquer das Normas Aplicáveis, assim como do Código de Conduta de Fornecedores, devendo sempre agir no sentido de ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'evitar que referidas violações ou desconformidades ocorram.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '21.2 - Caso a Contratante tome conhecimento de fatos ou indícios para acreditar que ocorreu, ou que está na iminência de ocorrer, violação às declarações constantes das cláusulas acima por parte do Fornecedor e/ou por quaisquer dos seus ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'representantes, poderá a Contratante determinar, a seu exclusivo critério, a suspensão imediata da realização dos Serviços e/ou a substituição imediata dos representantes do Fornecedor envolvidos, sem prejuízo da faculdade ', oFontg,,,, 0) 
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'de rescindir PEDIDO DE FORNECIMENTO.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '21.3 - Caso qualquer autoridade pública venha a instaurar procedimento ou processo para investigar condutas previstas na cláusula 21 e relacionadas a este PEDIDO DE FORNECIMENTO, o Fornecedor se compromete a cooperar com ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'a CONTRATANTE, quando por esta solicitado, no âmbito de referida investigação.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '21.4 - Para fins deste PEDIDO DE FORNECIMENTO, o termo “Agente Público” terá a definição prevista no artigo 2º da Lei nº 8.429/92; abrangendo também qualquer dirigente de partido político, seus empregados ou outras pessoas que ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'atuem para ou em nome de um partido político ou candidato a cargo público, bem como a definição de agente público estrangeiro contida no art. 5º, § 3º, da Lei n.º 12.846/2013.', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '21.5 - Para fins deste PEDIDO DE FORNECIMENTO, o termo “Autoridade Governamental” significa qualquer órgão, entidade, autoridade, agência, autarquia, fundação, comissão ou repartição governamental brasileira, de qualquer nível ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'ou esfera de governo (federal, estadual, municipal, regional, distrital ou local), ou, ainda, qualquer pessoa jurídica controlada, direta ou indiretamente, pelo poder público brasileiro, ou órgão, entidade estatal ou representação diplomática de ', oFontg,,,, 0)
				_oPrn:Say((nIncLin += 29), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), 'país estrangeiro, de qualquer nível ou esfera de governo, bem como qualquer pessoa jurídica controlada, direta ou indiretamente, pelo poder público de país estrangeiro, ou organização pública internacional.', oFontg,,,, 0)
				//_oPrn:Say((nIncLin += 33), (aDimObj6[nSubBox1, nSubBox2, 2] + 15), '', oFontg,,,, 0)
				
				
			ElseIf (nSubBox1 == 3)
				If (nSubBox2 == 1)
					_oPrn:Say((aDimObj6[nSubBox1, nSubBox2, 1] + 10), (aDimObj6[nSubBox1, nSubBox2, 2] + 10), 'Fornecedor:', oFontbN,,,, 0)
					_oPrn:Say((aDimObj6[nSubBox1, nSubBox2, 3] - 40), (aDimObj6[nSubBox1, nSubBox2, 2] + 10), 'Local: ' + Replicate('_', 80) + Space(5) + 'Data: _____/_____/__________', oFontbN,,,, 0)
				ElseIf (nSubBox2 == 2)
					_oPrn:Say((aDimObj6[nSubBox1, nSubBox2, 1] + 10), (aDimObj6[nSubBox1, nSubBox2, 2] + 10), 'No. do Pedido:', oFontbN,,,, 0)
					_oPrn:Say((aDimObj6[nSubBox1, nSubBox2, 1] + 68), ((aDimObj6[nSubBox1, nSubBox2, 2] + aDimObj6[nSubBox1, nSubBox2, 4]) / 2), SC7->C7_NUM, oFonthN,, /*RGB(215, 215, 215)*/,, 2)
				ElseIf (nSubBox2 == 3)
					_oPrn:Say((aDimObj6[nSubBox1, nSubBox2, 1] + 10), (aDimObj6[nSubBox1, nSubBox2, 2] + 10), 'Pagina:', oFontbN,,,, 0)
					// Alteradol por Rafael Sacramento (Criare Consulting) em 15/10/2015
					//_oPrn:Say((aDimObj6[nSubBox1, nSubBox2, 1] + 48), ((aDimObj6[nSubBox1, nSubBox2, 2] + aDimObj6[nSubBox1, nSubBox2, 4]) / 2), (StrZero((nPgAtu + 1), 2) + '/' + StrZero(Iif(nQTDPg == 1, nQTDPg, nQTDPg + 1), 2)), oFontfN,,/* RGB(215, 215, 215)*/,, 2)
					  _oPrn:Say((aDimObj6[nSubBox1, nSubBox2, 1] + 68), ((aDimObj6[nSubBox1, nSubBox2, 2] + aDimObj6[nSubBox1, nSubBox2, 4]) / 2), (StrZero((nPgAtu + 1), 2) + '/' + StrZero((nQTDPg + 1), 2)), oFonthN,,/* RGB(215, 215, 215)*/,, 2)
				EndIf
			EndIf
		Next
	Next
	
	/*/ realiza a imoressao das aprovacoes do pedido /*/
	_cNivel := ''

	For nSubBox1 := 1 To Len(aDimObj6)
		For nSubBox2 := 1 To Len(aDimObj6[nSubBox1])
			If (nSubBox1 == 2)
				/*/ Pesquisa dados de aprovacao do pedido /*/
				SCR->(DbGoTop())
				SCR->(DbSetOrder(1))
				SCR->(DbSeek(xFilial('SCR') + 'PC' + SC7->C7_NUM))
												
				While SCR->(!Eof()) .And. (AllTrim(SC7->C7_NUM) == AllTrim(SCR->CR_NUM))
					If (nSubBox2 > 7)
						Exit
						nSubBox2 := 7
					EndIf
					If !(Empty(SCR->CR_DATALIB))
						If (SCR->CR_NIVEL > _cNivel)
							SAK->(DbGoTop())
							SAK->(DbSetOrder(1))
							SAK->(DbSeek(xFilial('SAK') + SCR->CR_APROV))
				
							_oPrn:Say((aDimObj6[nSubBox1, nSubBox2, 1] + 30), (aDimObj6[nSubBox1, nSubBox2, 2] + 10), 'Aprovador NIVEL ' + SCR->CR_NIVEL + ':', oFontbN,,,, 0)
							_oPrn:Say((aDimObj6[nSubBox1, nSubBox2, 1] + 70), ((aDimObj6[nSubBox1, nSubBox2, 2] + aDimObj6[nSubBox1, nSubBox2, 4]) / 2), AllTrim(SAK->AK_NOME), oFontbN,,,, 2)
							//_oPrn:Say((aDimObj6[nSubBox1, nSubBox2, 1] + 100), ((aDimObj6[nSubBox1, nSubBox2, 2] + aDimObj6[nSubBox1, nSubBox2, 4]) / 2), If((SCR->CR_STATUS == '04'), '*** [ REJEITADO ] ***', '*** [ APROVADO ] ***'), oFontbN,,,, 2) \\ o nivel Rejeitado mudou para 06 - alterado por Fabio 26/07/2018
							_oPrn:Say((aDimObj6[nSubBox1, nSubBox2, 1] + 100), ((aDimObj6[nSubBox1, nSubBox2, 2] + aDimObj6[nSubBox1, nSubBox2, 4]) / 2), If((SCR->CR_STATUS == '06'), '*** [ REJEITADO ] ***', '*** [ APROVADO ] ***'), oFontbN,,,, 2) 
							_oPrn:Say((aDimObj6[nSubBox1, nSubBox2, 3] - 60), ((aDimObj6[nSubBox1, nSubBox2, 2] + aDimObj6[nSubBox1, nSubBox2, 4]) / 2), DtoC(SCR->CR_DATALIB), oFontbN,,,, 2)
							_oPrn:Say((aDimObj6[nSubBox1, nSubBox2, 3] - 30), ((aDimObj6[nSubBox1, nSubBox2, 2] + aDimObj6[nSubBox1, nSubBox2, 4]) / 2), 'DATA', oFontbN,,,, 2)
							_cNivel := SCR->CR_NIVEL
							nSubBox2++
						EndIf
					EndIf
					SCR->(DbSkip())
				End
			EndIf
		Next
	Next

Return(nLin)




