#Include 'rwmake.ch'
#Include 'protheus.ch'
#Include 'totvs.ch'
#Include 'topconn.ch'

/*/
*****************************************************************************************************
*** Funcao   : PNRSOLCON   -   Autor: Leonardo Pereira/Yttalo P. Martins   -   Data:27/01/15      ***
*** Descricao: Impressao do Relatorio Consolidado das Solicitacoes de Compra                      ***
*****************************************************************************************************
/*/
User Function PTNR011()

Private nCount := 0
Private aCabBox1 := {'CENTRO DE CUSTO', 'CONTA ORCAMENTARIA', 'NATUREZA', 'CONTA CONTABIL', 'CODIGO PRODUTO', 'DESCRICAO', 'UND', 'QUANTIDADE', ;
'VALOR UITARIO', 'VALOR TOTAL', 'SOLICITANTE', 'NUMERO REQ', 'DATA DA SOLICITACAO', 'STATUS DA SOLICITACAO', 'NUMERO DA COTACAO', 'STATUS DA COTACAO', ;
'DATA DE ENVIO DA COTACAO', 'APROVADOR DA COTACAO', 'DATA DA APROVACAO/REJEICAO', 'APROVADOR DO PEDIDO DE COMPRA', 'NUMERO DO PEDIDO', 'ITEM DO PEDIDO', ;
'DATA EMISSAO PEDIDO','STATUS DO PEDIDO', 'DATA DA APROVACAO/REJEICAO', 'PREV. ENTREGA PC', 'FORNECEDOR'}
Private aCabBox2 := {'NF         ', 'DATA ENTREGA', 'QUANTIDADE', 'SALDO'}
Private LenCabBox2 := 1

cPerg := 'PTNR011'

PutSx1(cPerg, "01", "Centro de Custo De ?", "", "", "mv_ch1", "C", 010, 0, 0, "G", "", "", "","", "mv_par01")
PutSx1(cPerg, "02", "Centro de Custo Ate?", "", "", "mv_ch2", "C", 010, 0, 0, "G", "", "", "","", "mv_par02")
PutSx1(cPerg, "03", "Data de Emissao De ?", "", "", "mv_ch3", "D", 008, 0, 0, "G", "", "", "","", "mv_par03")
PutSx1(cPerg, "04", "Data de Emissao Ate?", "", "", "mv_ch4", "D", 008, 0, 0, "G", "", "", "","", "mv_par04")

If !Pergunte(cPerg, .T.)
	Return
EndIf

Processa({ |lEnd| PTNR011A(@lEnd)}, 'SOLICITACOES DE COMPRAS - CONSOLIDADO', 'Processando dados...', .T.)

Return

/*/
*****************************************************************************************************
***                                                                                               ***
***                                                                                               ***
*****************************************************************************************************
/*/
Static Function PTNR011A(lEnd)

Local aArea
Local cLegSC1 := ""
Local cLegSC7 := ""
Local cLegSC8 := ""
Local dPreEntr:= ""
Private aDadSC1 := {}
Private aDadSC7 := {}
Private aDadSC8 := {}
Private aDadSD1 := {}
Private aDadSCRMC := {}
Private aDadSCRPC := {}
Private aLinItNF  := {}
Private nSaldoC7  := 0
Private nSaldo    := 0
Private nQuantD1  := 0
Private lFirst    := .T.
Private nTotReg   := 0

If (Select('TMPSC1') > 0)
	TMPSC1->(DbCloseArea())
EndIf
cQry := 'SELECT C1_CC, C1_XCO, C1_XNAT, C1_CONTA, C1_PRODUTO, C1_DESCRI, C1_UM, C1_QUANT, C1_SOLICIT, C1_NUM, C1_ITEM, C1_EMISSAO, R_E_C_N_O_ SC1RECNO '
cQry += 'FROM ' + RetSQLName('SC1') + ' SC1 '
cQry += "WHERE SC1.C1_FILIAL = '" + XFILIAL("SC1") + "' "
cQry += "AND SC1.C1_CC BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
cQry += "AND SC1.C1_EMISSAO BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
cQry += "AND SC1.D_E_L_E_T_ = ' ' "
cQry += 'ORDER BY C1_FILIAL, C1_EMISSAO, C1_NUM, C1_ITEM '
TcQuery cQry NEW ALIAS 'TMPSC1'
TMPSC1->(DbGoTop())

Count To nTotReg
ProcRegua(nTotReg)

TMPSC1->(DbGoTop())
If !TMPSC1->(Eof())
	While !TMPSC1->(Eof())
		IncProc('Processando dados...')
		
		aArea := GetArea()
		
		dbSelectArea("SC1")
		dbGoTo(TMPSC1->SC1RECNO)
		
		cLegSC1 := PTNR011C()
		
		RestArea(aArea)
		
		aAdd(aDadSC1, {TMPSC1->C1_NUM, TMPSC1->C1_CC, TMPSC1->C1_XCO, TMPSC1->C1_XNAT, TMPSC1->C1_CONTA,TMPSC1->C1_PRODUTO, TMPSC1->C1_DESCRI, ;
		TMPSC1->C1_UM, TMPSC1->C1_QUANT, TMPSC1->C1_SOLICIT, DTOC(STOD(TMPSC1->C1_EMISSAO)),cLegSC1,TMPSC1->C1_ITEM })
		If (Select('TMPSC8') > 0)
			TMPSC8->(DbCloseArea())
		EndIf
		cQry := 'SELECT C8_FILIAL, C8_NUM, C8_EMISSAO, C8_NUMPED, C8_ITEMPED, R_E_C_N_O_ SC8RECNO '
		cQry += 'FROM ' + RetSQLName('SC8') + ' '
		cQry += "WHERE C8_FILIAL = '" + XFILIAL("SC8") + "' "
		cQry += "AND C8_NUMSC = '" + TMPSC1->C1_NUM + "' "
		cQry += "AND C8_ITEMSC = '" + TMPSC1->C1_ITEM + "' "
		//cQry += "AND (C8_NUMPED <> '' AND C8_NUMPED <> 'XXXXXX') "
		cQry += "AND C8_NUMPED <> 'XXXXXX' "
		cQry += "AND D_E_L_E_T_ = ' ' "
		TcQuery cQry NEW ALIAS 'TMPSC8'
		TMPSC8->(DbGoTop())
		If !TMPSC8->(Eof())
			
			aArea := GetArea()
			
			dbSelectArea("SC8")
			dbGoTo(TMPSC8->SC8RECNO)
			
			cLegSC8 := PTNR011D()
			
			RestArea(aArea)
			
			aAdd(aDadSC8, {TMPSC1->C1_NUM, TMPSC8->C8_NUM, DTOC(STOD(TMPSC8->C8_EMISSAO)), cLegSC8 })
			
			If (Select('TMPSCR') > 0)
				TMPSCR->(DbCloseArea())
			EndIf
			cQry := 'SELECT CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL, CR_DATALIB, CR_EMISSAO, CR_USERLIB  '
			cQry += 'FROM ' + RetSQLName('SCR') + " WHERE CR_TIPO = 'MC' "
			cQry += "AND CR_FILIAL = '" + XFILIAL("SCR") + "' "
			cQry += "AND CR_NUM = '" + TMPSC8->C8_NUM + "' "
			cQry += "AND D_E_L_E_T_ = ' ' "
			cQry += "ORDER BY CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL DESC "
			TcQuery cQry NEW ALIAS 'TMPSCR'
			TMPSCR->(DbGoTop())
			If !TMPSCR->(Eof())
				aAdd(aDadSCRMC, {TMPSC1->C1_NUM, DTOC(STOD(TMPSCR->CR_DATALIB)), DTOC(STOD(TMPSCR->CR_EMISSAO)), UsrRetName(TMPSCR->CR_USERLIB)})
			Else
				aAdd(aDadSCRMC, {"", "  /  /  ", "  /  /  ", ""})
			EndIf
			
			If (Select('TMPSC7') > 0)
				TMPSC7->(DbCloseArea())
			EndIf
			cQry := 'SELECT C7_FILIAL, C7_NUM, C7_ITEM, C7_EMISSAO, C7_DATPRF, C7_FORNECE, C7_LOJA, C7_UM, C7_QUANT, C7_PRECO, C7_TOTAL, R_E_C_N_O_ SC7RECNO '
			cQry += 'FROM ' + RetSQLName('SC7') + ' '
			cQry += "WHERE C7_FILIAL = '" + XFILIAL("SC7") + "' "
			cQry += "AND C7_NUM = '" + TMPSC8->C8_NUMPED + "' "
			cQry += "AND C7_ITEM = '" + TMPSC8->C8_ITEMPED + "' "
			cQry += "AND D_E_L_E_T_ = ' ' "
			TcQuery cQry NEW ALIAS 'TMPSC7'
			TMPSC7->(DbGoTop())
			If !TMPSC7->(Eof())
				
				aArea := GetArea()
				
				dbSelectArea("SC7")
				dbGoTo(TMPSC7->SC7RECNO)
				
				cLegSC7 := PTNR011E()
				
				RestArea(aArea)
				
				aAdd(aDadSC7, {TMPSC1->C1_NUM, TMPSC7->C7_NUM, TMPSC7->C7_ITEM, DTOC(STOD(TMPSC7->C7_EMISSAO)), PTNR011F(), ;
				TMPSC7->C7_FORNECE, TMPSC7->C7_LOJA, TMPSC7->C7_UM, Transform(TMPSC7->C7_QUANT,PesqPict("SC7","C7_QUANT")), ;
				Transform(TMPSC7->C7_PRECO,PesqPict("SC7","C7_PRECO")), Transform(TMPSC7->C7_TOTAL,PesqPict("SC7","C7_TOTAL")), cLegSC7 })
				
				nSaldoC7    := TMPSC7->C7_QUANT
				nQuantD1    := 0
				
				If (Select('TMPSCR') > 0)
					TMPSCR->(DbCloseArea())
				EndIf
				cQry := 'SELECT CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL, CR_DATALIB, CR_EMISSAO, CR_USERLIB '
				cQry += 'FROM ' + RetSQLName('SCR') + " WHERE CR_TIPO = 'PC' "
				cQry += "AND CR_FILIAL = '" + XFILIAL("SCR") + "' "
				cQry += "AND CR_NUM = '" + TMPSC7->C7_NUM + "' "
				cQry += "AND D_E_L_E_T_ = ' ' "
				cQry += "ORDER BY CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL DESC "
				TcQuery cQry NEW ALIAS 'TMPSCR'
				TMPSCR->(DbGoTop())
				If !TMPSCR->(Eof())
					aAdd(aDadSCRPC, {TMPSC1->C1_NUM, DTOC(STOD(TMPSCR->CR_DATALIB)), DTOC(STOD(TMPSCR->CR_EMISSAO)), UsrRetName(TMPSCR->CR_USERLIB)})
				Else
					aAdd(aDadSCRPC, {"", "  /  /  ", "  /  /  ", ""})
					aAdd(aDadSD1, {"","","","","","  /  /  ","0","0"})
				EndIf
				
				If (Select('TMPSD1') > 0)
					TMPSD1->(DbCloseArea())
				EndIf
				cQry := 'SELECT D1_FILIAL, D1_DOC, D1_SERIE, D1_DTDIGIT, D1_QUANT '
				cQry += 'FROM ' + RetSQLName('SD1') + ' '
				cQry += "WHERE D1_FILIAL = '" + XFILIAL("SD1") + "' "
				cQry += "AND D1_PEDIDO = '" + TMPSC7->C7_NUM + "' "
				cQry += "AND D1_ITEMPC = '" + TMPSC7->C7_ITEM + "' "
				cQry += "AND D1_FORNECE = '" + TMPSC7->C7_FORNECE + "' "
				cQry += "AND D1_LOJA = '" + TMPSC7->C7_LOJA + "' "
				cQry += "AND D_E_L_E_T_ = ' ' "
				TcQuery cQry NEW ALIAS 'TMPSD1'
				TMPSD1->(DbGoTop())
				If !TMPSD1->(Eof())
					
					nQuantD1:= 0
					nSaldo  := 0
					nCount  := 0
					
					While TMPSD1->(!Eof())
						
						nCount++
						
						nQuantD1  += TMPSD1->D1_QUANT
						nSaldo    := nSaldoC7-nQuantD1
						
						aAdd(aDadSD1, {TMPSC1->C1_NUM,TMPSC1->C1_ITEM,TMPSC7->C7_NUM,TMPSC7->C7_ITEM,TMPSD1->D1_DOC+"-"+TMPSD1->D1_SERIE,;
						DTOC(STOD(TMPSD1->D1_DTDIGIT)), Transform(TMPSD1->D1_QUANT,PesqPict("SD1","D1_QUANT")), Transform(nSaldo,PesqPict("SD1","D1_QUANT"))})
						
						TMPSD1->(dbSkip())
					EndDo
					
					LenCabBox2 := IIF(nCount > LenCabBox2,nCount,LenCabBox2 )
					
				Else
					aAdd(aDadSD1, {"","","","","","  /  /  ","",""})
				EndIf
				
			Else
				aAdd(aDadSC7, {"","","","  /  /  ","  /  /  ","","","","0","0","0",""})
				aAdd(aDadSCRPC, {"", "  /  /  ", "  /  /  ", ""})
				aAdd(aDadSD1, {"","","","","","  /  /  ","",""})
			EndIf
			
			
		Else
			aAdd(aDadSC8, {"", "", "  /  /  ",""})
			aAdd(aDadSCRMC, {"", "  /  /  ", "  /  /  ", ""})
			aAdd(aDadSC7, {"","","","  /  /  ","  /  /  ","","","","0","0","0",""})
			aAdd(aDadSCRPC, {"", "  /  /  ", "  /  /  ", ""})
			aAdd(aDadSD1, {"","","","","","  /  /  ","",""})
		EndIf
		
		TMPSC1->(DbSkip())
	EndDo
	
EndIf

If (Select('TMPSC1') > 0)
	dbSelectArea('TMPSC1')
	TMPSC1->(DbCloseArea())
EndIf
If (Select('TMPSC8') > 0)
	dbSelectArea('TMPSC8')
	TMPSC8->(DbCloseArea())
EndIf
If (Select('TMPSCR') > 0)
	dbSelectArea('TMPSCR')
	TMPSCR->(DbCloseArea())
EndIf
If (Select('TMPSC7') > 0)
	dbSelectArea('TMPSC7')
	TMPSC7->(DbCloseArea())
EndIf
If (Select('TMPSD1') > 0)
	dbSelectArea('TMPSD1')
	TMPSD1->(DbCloseArea())
EndIf

//--------------------------------------------------------------------------------------------------
//Gera Excel com as informações coletadas-----------------------------------------------------------
//--------------------------------------------------------------------------------------------------

If LEN(aDadSC1) > 0
	Processa({ |lEnd| PTNR011B(@lEnd)}, 'SOLICITACOES DE COMPRAS - CONSOLIDADO', 'Gerando planilha...', .T.)
ELSE
	Aviso("Aviso!","Não há dados a serem exibidos com os parâmetros informados!",{"OK"})
EndIf

Return


*******************************************************************************************************************************************

Static Function PTNR011B()

Local oFwMsEx := NIL
Local cArq := ""
Local cDir := GetSrvProfString("Startpath","")
Local cWorkSheet := ""
Local cTable := ""
Local cDirTmp := GetTempPath()
Local ni := 1
Local nj := 1
Local nL := 1
Local aDados := {}
Local aTemp  := {}
Local TotLinaDados := 0
Local nLenaDados  := 0
Local lAchou := .F.
Local lExit := .F.//variável de controle para impedir repetição de notas quando por exemplo o relatório contiver um pedido que gerou 2 notas e um pedido
//que gerou 1 nota. Para que não repita a mesma nota nos campos dinâmicos(cabeçalho aCabBox2) ao final do relatório.

oFwMsEx := FWMsExcel():New()

cWorkSheet := "Plan1"
oFwMsEx:AddWorkSheet( cWorkSheet )

cTable := "Relatorio Consolidado das Solicitacoes de Compra"
oFwMsEx:AddTable( cWorkSheet, cTable )

For ni := 1 To Len(aCabBox1)
	
	oFwMsEx:AddColumn( cWorkSheet, cTable , aCabBox1[ni] , 1,1)
	
Next ni

For ni := 1 To LenCabBox2
	
	For nj := 1 To Len(aCabBox2)
		
		oFwMsEx:AddColumn( cWorkSheet, cTable , aCabBox2[nj] , 1,1)
		
	Next nj
	
Next ni


TotLinaDados := Len(aCabBox1)+(LenCabBox2*4)

ProcRegua(Len(aDadSC1))


For ni := 1 To Len(aDadSC1)
	
	incproc()
	
	aDados     := ARRAY(TotLinaDados)
	aDados[1] := aDadSC1[ni][2]
	aDados[2] := aDadSC1[ni][3]
	aDados[3] := aDadSC1[ni][4]
	aDados[4] := aDadSC1[ni][5]
	aDados[5] := aDadSC1[ni][6]
	aDados[6] := aDadSC1[ni][7]
	aDados[7] := aDadSC1[ni][8]//aDadSC7[ni][8]
	aDados[8] := aDadSC1[ni][9]//aDadSC7[ni][9]
	aDados[9] := aDadSC7[ni][10]
	aDados[10] := aDadSC7[ni][11]
	aDados[11] := aDadSC1[ni][10]
	aDados[12] := aDadSC1[ni][1]
	aDados[13] := aDadSC1[ni][11]
	aDados[14] := aDadSC1[ni][12]
	aDados[15] := aDadSC8[ni][2]
	aDados[16] := aDadSC8[ni][4]
	aDados[17] := aDadSCRMC[ni][3]
	aDados[18] := aDadSCRMC[ni][4]
	aDados[19] := aDadSCRMC[ni][2]
	aDados[20] := aDadSCRPC[ni][4]
	aDados[21] := aDadSC7[ni][2]
	aDados[22] := aDadSC7[ni][3]
	aDados[23] := aDadSC7[ni][4]
	aDados[24] := aDadSC7[ni][12]
	aDados[25] := aDadSCRPC[ni][2]
	aDados[26] := aDadSC7[ni][5]
	aDados[27] := IIF( !EMPTY(aDadSC7[ni][6]), Posicione("SA2",1,xFilial("SA2")+aDadSC7[ni][6]+aDadSC7[ni][7],"A2_NOME"),"")
	
	nLenaDados  := Len(aCabBox1)
	lExit       := .F.
	
	For nj := 1 To LenCabBox2
		
		IF LEN(aDadSD1) == 0
			
			aDados[++nLenaDados] := ""
			aDados[++nLenaDados] := ""
			aDados[++nLenaDados] := ""
			aDados[++nLenaDados] := ""
			
		ELSE
			
			lAchou := .F.
			
			If lExit == .F.
				
				For nl := 1 To Len(aDadSD1)
					
					IF aDadSD1[nl][1] == aDadSC1[ni][1] .and. aDadSD1[nl][2] == aDadSC1[ni][13] .and.aDadSD1[nl][3] == aDadSC7[ni][2] .and.aDadSD1[nl][4] == aDadSC7[ni][3]
						
						lAchou := .T.
						
						aDados[++nLenaDados] := aDadSD1[nl][5]
						aDados[++nLenaDados] := aDadSD1[nl][6]
						aDados[++nLenaDados] := aDadSD1[nl][7]
						aDados[++nLenaDados] := aDadSD1[nl][8]
						
					ENDIF
					
					If nLenaDados == Len(aDados)
						nl := Len(aDadSD1)+1//se coletou todos os itens sai do laço
					EndIf
					
				Next nl
				
			EndIf
			
			If lAchou == .F.
				
				aDados[++nLenaDados] := ""
				aDados[++nLenaDados] := ""
				aDados[++nLenaDados] := ""
				aDados[++nLenaDados] := ""
				
			ElseIf lAchou == .T. .and. nLenaDados < Len(aDados)
				lExit := .T.
			EndIf
			
			
			If nLenaDados == Len(aDados)
				nj := LenCabBox2+1//se coletou todos os itens sai do laço
			EndIf
			
		ENDIF
		
		
	Next nj
	
	oFwMsEx:AddRow( cWorkSheet, cTable, aDados )
	
	aDados := {}
	
Next ni

//oFwMsEx:AddRow( cWorkSheet, cTable, { "1","","","","","","","","","","" } )

oFwMsEx:Activate()

cArq := CriaTrab( NIL, .F. ) + ".xml"
LjMsgRun( "Gerando o arquivo, aguarde...", "Gerar XML", {|| oFwMsEx:GetXMLFile( cArq ) } )
If __CopyFile( cArq, cDirTmp + cArq )
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cDirTmp + cArq )
	oExcelApp:SetVisible(.T.)
Else
	MsgInfo( "Arquivo não copiado para temporário do usuário." )
Endif

Return

***************************************************************************************************************************************
//status da solicitação
Static Function PTNR011C()

Local lAProvSI   := GetNewPar("MV_APROVSI",.F.)
Local lPrjCni := FindFunction("ValidaCNI") .And. ValidaCNI()
Local cTpCto     := iif ( lPrjCni, GETMV("MV_TPSCCT"), '')
Local cRet := ""
/*
If SC1->(FieldPos("C1_ACCPROC")) > 0 .and. EMPTY(cRet)
If SC1->C1_ACCPROC =="1" .And. SC1->C1_PEDIDO == Space(Len(SC1->C1_PEDIDO)) .and. EMPTY(cRet)
cRet :="Solicitação Pendente (MarketPlace)"
EndIf
If SC1->C1_ACCPROC =="1" .And. SC1->C1_PEDIDO <> Space(Len(SC1->C1_PEDIDO)) .and. EMPTY(cRet)
cRet :="Solicitação em Processo de Cotação (MarketPlace)"
EndIf

EndIf

If SC1->(FieldPos("C1_COMPRAC")) > 0 .and. EMPTY(cRet)
If SC1->C1_RESIDUO == 'S' .And. SC1->C1_COMPRAC == '1'
cRet :="SC em Compra Centralizada"
EndIf
EndIf

If lPrjCni .and. EMPTY(cRet)
If SC1->C1_XCLASSI .And. SC1->C1_APROV == "B" .and. EMPTY(cRet)
cRet :="Classificação Pendente"
EndIf
//-- Integracao com o modulo de Gestao de Contratos
If Empty(SC1->C1_RESIDUO) .And. SC1->C1_XSTGCT == "1" .And. SC1->C1_APROV $ " ,L" .And. SC1->C1_XTIPOSC == cTpCto .and. EMPTY(cRet)
cRet :="Aditivo Gerado no GCT"
Endif
If Empty(SC1->C1_RESIDUO) .And. SC1->C1_XSTGCT == "2" .And. SC1->C1_APROV $ " ,L" .And. SC1->C1_XTIPOSC == cTpCto .and. EMPTY(cRet)
cRet :="Aditivo não Gerado no GCT"
EndIf
EndIf

If SC1->C1_FLAGGCT == "1" .And. SC1->C1_QUJE < SC1->C1_QUANT .and. EMPTY(cRet)
cRet :="SC Totalmente Atendida pelo SIGAGCT"
EndIf

If SC1->(FieldPos("C1_TIPO"))>0 .and. EMPTY(cRet)
If SC1->C1_TIPO == 2
cRet :="Solicitacao de Importacao"
EndIf
Endif

If !Empty(SC1->C1_RESIDUO) .and. EMPTY(cRet)
cRet :="SC Eliminada por Residuo"
EndIf

If SC1->C1_QUJE == SC1->C1_QUANT .and. EMPTY(cRet)
cRet :="Solicitação Totalmente Atendida"
EndIf

If SC1->(FieldPos("C1_TPSC")) > 0 .and. EMPTY(cRet)
If SC1->C1_QUJE == 0 .And. SC1->C1_COTACAO == Space(Len(SC1->C1_COTACAO)) .And. SC1->C1_APROV $ " ,L" .And. SC1->C1_TPSC == "2" .and. EMPTY(cRet)
cRet :="Solicitacao para Licitacao"
EndIf
EndIf

if lPrjCni .and. EMPTY(cRet)
If SC1->C1_XTIPOSC <> cTpCto .And. SC1->C1_QUJE == 0 .And. SC1->C1_COTACAO == Space(Len(SC1->C1_COTACAO)) .And. SC1->C1_APROV $ " ,L" .and. EMPTY(cRet)
cRet :="Solicitacao Pendente"
EndIf
Else
If SC1->C1_QUJE == 0 .And. SC1->C1_COTACAO == Space(Len(SC1->C1_COTACAO)) .And. SC1->C1_APROV $ " ,L" .and. EMPTY(cRet)
cRet :="Solicitacao Pendente"
EndIf
EndIf

If lAprovSI .and. EMPTY(cRet)
If SC1->C1_QUJE == 0 .And. (SC1->C1_COTACAO == Space(Len(SC1->C1_COTACAO)) .Or. SC1->C1_COTACAO == "IMPORT") .And. SC1->C1_APROV == "R" .and. EMPTY(cRet)
cRet :="SC Rejeitada"
EndIf
If SC1->C1_QUJE == 0 .And. (SC1->C1_COTACAO == Space(Len(SC1->C1_COTACAO)) .Or. SC1->C1_COTACAO == "IMPORT") .And. SC1->C1_APROV == "B" .and. EMPTY(cRet)
cRet :="SC Bloqueada"
EndIf
Else
If SC1->C1_QUJE == 0 .And. SC1->C1_COTACAO == Space(Len(SC1->C1_COTACAO)) .And. SC1->C1_APROV == "R" .and. EMPTY(cRet)
cRet :="SC Rejeitada"
EndIf
If SC1->C1_QUJE == 0 .And. SC1->C1_COTACAO == Space(Len(SC1->C1_COTACAO)) .And. SC1->C1_APROV == "B" .and. EMPTY(cRet)
cRet :="SC Bloqueada"
EndIf
EndIf

If SC1->C1_QUJE > 0 .and. EMPTY(cRet)
cRet :="Solicitação Parcialmente Atendida"
EndIf

If SC1->C1_TPSC == "2" .And. SC1->C1_QUJE == 0 .And. !Empty(SC1->C1_CODED) .and. EMPTY(cRet)
cRet :="Solicitação em Processo de Edital"
EndIf

If SC1->C1_TPSC != "2" .And. SC1->C1_QUJE == 0 .And. SC1->C1_COTACAO <> Space(Len(SC1->C1_COTACAO)) .And. SC1->C1_IMPORT <>"S" .and. EMPTY(cRet)
cRet :="Solicitação Em Processo De Cotação"
EndIf

If lAprovSI .and. EMPTY(cRet)
If SC1->C1_QUJE == 0 .And. SC1->C1_COTACAO <> Space(Len(SC1->C1_COTACAO)) .And. SC1->C1_IMPORT == "S" .And.SC1->C1_APROV $ " ,L" .and. EMPTY(cRet)
cRet :="SC com Produto Importado"
EndIf
Else
If SC1->C1_QUJE == 0 .And. SC1->C1_COTACAO <> Space(Len(SC1->C1_COTACAO)) .And. SC1->C1_IMPORT == "S" .and. EMPTY(cRet)
cRet :="SC com Produto Importado"
EndIf
EndIf
*/
If SC1->C1_QUJE == SC1->C1_QUANT .and. EMPTY(cRet)
	cRet :="Solicitação Totalmente Atendida"
EndIf

If SC1->C1_QUJE > 0 .and. EMPTY(cRet)
	cRet :="Solicitação Parcialmente Atendida"
EndIf

If SC1->C1_QUJE == 0 .And. SC1->C1_COTACAO == Space(Len(SC1->C1_COTACAO)) .And. SC1->C1_APROV $ "R,B" .and. EMPTY(cRet)
	cRet :="Solicitação Rejeitada"
EndIf

If SC1->C1_QUJE == 0 .And. SC1->C1_APROV $ " ,L" .and. EMPTY(cRet)
	cRet :="Solicitacao Pendente"
EndIf

Return(cRet)

***************************************************************************************************************************************
//status da cotação
Static Function PTNR011D()

Local cRet    := ""
/*
Local cCotACC := (SC8->(FieldPos('C8_ACCNUM'))>0 .And. !Empty(SC8->C8_ACCNUM) .And. Empty(SC8->C8_NUMPED))

If !cCotACC .And.Empty(SC8->C8_NUMPED).And.SC8->C8_PRECO<>0 .and. EMPTY(cRet)
cRet := "Em analise"
EndIf
If !Empty(SC8->C8_NUMPED) .and. EMPTY(cRet)
cRet := "Analisada"
EndIf
If!cCotACC .And.SC8->C8_PRECO==0.And.Empty(SC8->C8_NUMPED) .and. EMPTY(cRet)
cRet := "Em aberto - nao cotada"
EndIf
If SC8->C8_FLAGWF == '1' .And. Empty(SC8->C8_NUMPED) .and. EMPTY(cRet)
cRet := "Workflow Enviado"
EndIf
If SC8->C8_FLAGWF == '2' .And. Empty(SC8->C8_NUMPED) .and. EMPTY(cRet)
cRet := "Cotacao Rejeitada"
EndIf
*/
Local aArea := GetArea()
Local cRet := 'Aguardando Ranking'
Local lLiber := .T.

cTipoDoc := 'MC'

nRecSC8 := SC8->(Recno())
cNumSC8 := SC8->C8_NUM

dbSelectArea("SCR")
SC8->(DbSetOrder(1))
SC8->(DbSeek(xFilial('SC8') + cNumSC8))
While SC8->(!Eof()) .And. (SC8->C8_NUM == cNumSC8)
	If (cTipoDoc == 'MC')
		
		If SC8->C8_FLAGWF == '2'
			cRet := 'Cotação Rejeitada'
			Return(cRet)
		EndIf
		
		If (SC8->C8_CONAPRO == 'L')
			cRet := 'Cotação Rankeada'
			Return(cRet)
		EndIf
		
		If SC8->C8_PRECO==0.And.Empty(SC8->C8_NUMPED)
			cRet := 'Cotação Pendente'
			Return(cRet)
		EndIf
		
	EndIf
	SC8->(DbSkip())
End
SC8->(DbGoTo(nRecSC8))

/*/ Realiz o ranking do mapa de cotacao /*/
SCR->(DbGoTop())
SCR->(DbSetOrder(1))
If SCR->(DbSeek(xFilial('SCR') + cTipoDoc + Padr(cNumSC8,Len(SCR->CR_NUM)) ) )
	While !SCR->(Eof()) .And. (SCR->CR_FILIAL + SCR->CR_TIPO + SCR->CR_NUM == xFilial('SCR') + cTipoDoc + Padr(cNumSC8,Len(SCR->CR_NUM)) )
		
		Do Case
			Case (SCR->CR_STATUS == '02')
				cRet := 'Aguardando Ranking'
			Case (SCR->CR_STATUS == '03')
				cRet := 'Cotação Rankeada'
			Case (SCR->CR_STATUS == '04')
				cRet := 'Cotação Rejeitada'
		EndCase
		
		SCR->(DbSkip())
	End
	
Else
	
	cRet := 'Mapa de Cotacão Sem Controle de Ranking'
	
EndIf

RestArea(aArea)

Return(cRet)

***************************************************************************************************************************************
//status do pedido
Static Function PTNR011E()

Local aArea := GetArea()
Local cRet := "Aguardando Aprovação"
Local lLiber := .T.
Local cRet    := ""
/*
If SC7->C7_TIPO!=1 .and. EMPTY(cRet)
cRet := "Autorizacao de Entrega ou Pedido"
EndIf
If !Empty(SC7->C7_RESIDUO) .and. EMPTY(cRet)
cRet := "Eliminado por Residuo"
EndIf
If SC7->(FieldPos("C7_ACCPROC")) > 0 .and. EMPTY(cRet)
If SC7->C7_ACCPROC<>"1" .And.  SC7->C7_CONAPRO=="B".And.SC7->C7_QUJE < SC7->C7_QUANT .and. EMPTY(cRet)
cRet :="Pedido Bloqueado"
EndIf
Else
If SC7->C7_CONAPRO=="B".And.SC7->C7_QUJE < SC7->C7_QUANT .and. EMPTY(cRet)
cRet :="Pedido Bloqueado"
EndIf
EndIf
If !Empty(SC7->C7_CONTRA).And.Empty(SC7->C7_RESIDUO) .and. EMPTY(cRet)
cRet :="Integracao com o Modulo de Gestao de Contratos
EndIf
If SC7->(FieldPos("C7_ACCPROC")) > 0 .And. (SuperGetMv("MV_MKPLACE",.F.,.F.)) .and. EMPTY(cRet)
If SC7->C7_ACCPROC=="1" .and. EMPTY(cRet)
cRet :="Integracao com o portal marketplace"
EndIf
EndIf
If SC7->C7_QUJE==0 .And. SC7->C7_QTDACLA==0 .and. EMPTY(cRet)
cRet :="Pedido Pendente"
EndIf
If SC7->C7_QUJE<>0.And.SC7->C7_QUJE<SC7->C7_QUANT .and. EMPTY(cRet)
cRet :="Pedido Parcialmente Atendido"
EndIf
If SC7->C7_QUJE>=C7_QUANT .and. EMPTY(cRet)
cRet :="Pedido Atendido"
EndIf
If SC7->C7_QTDACLA >0 .and. EMPTY(cRet)
cRet :="Pedido Usado em Pre-Nota"
EndIf
*/
If SC7->C7_QUJE>=C7_QUANT .and. EMPTY(cRet)
	cRet :="Pedido Atendido"
	Return(cRet)
EndIf

If SC7->C7_QUJE<>0.And.SC7->C7_QUJE<SC7->C7_QUANT .and. EMPTY(cRet)
	cRet :="Pedido Parcialmente Atendido"
	Return(cRet)
EndIf

If SC7->C7_CONAPRO=="B".And.SC7->C7_QUJE < SC7->C7_QUANT .and. EMPTY(cRet)
	cRet :="Pedido Rejeitado"
	Return(cRet)
EndIf

If SC7->C7_CONAPRO=="L"  .and. EMPTY(cRet)
	cRet := "Pedido Aprovado"
	Return(cRet)
EndIf

cTipoDoc := 'PC'
cNumSC7 := SC7->C7_NUM


dbSelectArea("SCR")
SCR->(DbSetOrder(1))
If SCR->(DbSeek(xFilial('SCR') + cTipoDoc + Padr(cNumSC7,Len(SCR->CR_NUM)) ) )
	While !SCR->(Eof()) .And. (SCR->CR_FILIAL + SCR->CR_TIPO + SCR->CR_NUM == xFilial('SCR') + cTipoDoc + Padr(cNumSC7,Len(SCR->CR_NUM)) )
		
		Do Case
			Case (SCR->CR_STATUS == '02')
				cRet := 'Aguardando Aprovação'
			Case (SCR->CR_STATUS == '03')
				cRet := 'Pedido Aprovado'
			Case (SCR->CR_STATUS == '04')
				cRet := 'Pedido Rejeitado'
		EndCase
		
		SCR->(DbSkip())
	End
	
Else
	
	cRet := 'Pedido Sem Controle de Aprovação'
	
EndIf

RestArea(aArea)

Return(cRet)

***************************************************************************************************************************************
//previsão de entrega do pedido
Static Function PTNR011F()

Local cRet := STOD(TMPSC7->C7_DATPRF)

aArea := GetArea()

dbSelectArea("SC7")
dbGoTo(TMPSC7->SC7RECNO)

dbSelectArea("SC8")
dbGoTo(TMPSC8->SC8RECNO)

dbSelectArea("SCR")
SCR->(DbSetOrder(1))
If SCR->(DbSeek(xFilial('SCR') + 'PC' + Padr(SC7->C7_NUM,Len(SCR->CR_NUM)) ) )
	While !SCR->(Eof()) .And. (SCR->CR_FILIAL + SCR->CR_TIPO + SCR->CR_NUM == xFilial('SCR') + 'PC' + Padr(SC7->C7_NUM,Len(SCR->CR_NUM)) )
	
	If !Empty(SCR->CR_DATALIB)
		cRet := (SCR->CR_DATALIB + SC8->C8_PRAZO + 1)
	EndIf
	
	SCR->(DbSkip())
	EndDo
	
EndIf

RestArea(aArea)

cRet := DTOC(cRet)

Return(cRet)
