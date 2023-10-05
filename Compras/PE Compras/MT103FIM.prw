#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#DEFINE   c_ent      CHR(13)+CHR(10)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103FIM  ºAutor  ³Leonardo Freire     º Data ³  29/03/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada utilizado para excluir o titulo de cauçãoº±±
±±º          ³gerado pela customização da retenção contratual.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function MT103FIM()

Local nOpcao := PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina
Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFE
Local cquery 	:= " "
Local cUpd		:= " "
Local nUfir	:= GetMV("MV_XTXUFIR")

Local _aArea    := SaveArea1({"CN1","SE2"}) // Incluído por Fabio Regueira 09/06/2015.   

If nOpcao = 5 .and. nConfirma == 1 // exclusão da NF de entrada

	CQUERY := " 	SELECT CN9.R_E_C_N_O_  AS RECN   FROM "+ RetSQLName("SD1")+" D1, "+ RetSQLName("CNE")+ " CNE, "+ RetSQLName("CN9")+ " CN9	"
	CQUERY += " 	WHERE D1_FILIAL = '"+xFIlial("SD1")+"' "
	CQUERY += " 	AND CNE_FILIAL = '"+xFIlial("CNE")+"' "
	CQUERY += " 	AND CN9_FILIAL = '"+xFIlial("CN9")+"' "
	CQUERY += " 	AND CN9.D_E_L_E_T_ = ' ' "
	CQUERY += " 	AND CNE.D_E_L_E_T_ = ' ' "
	//CQUERY += " 	AND D1.D_E_L_E_T_ = ' ' "
	CQUERY += " 	AND D1_DOC = '"+SF1->F1_DOC+"' "
	CQUERY += " 	AND D1_FORNECE = '"+SF1->F1_FORNECE+"' "
	CQUERY += " 	AND D1_LOJA = '"+SF1->F1_LOJA+"' "
	CQUERY += " 	AND D1_SERIE = '"+SF1->F1_SERIE+"' "
	CQUERY += " 	AND D1_PEDIDO = CNE_PEDIDO "	
	CQUERY += " 	AND CNE_CONTRA = CN9_NUMERO "
	CQUERY += " 	AND CNE_REVISA = CN9_REVISA "
	CQUERY += " 	GROUP BY CN9.R_E_C_N_O_ "	

	TcQuery cQuery Alias "DIF" New
	If DIF->(!Eof())       

		dbSelectArea("CN9")
		DBGoTo(DIF->RECN)
	
		dbSelectArea("CN1")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("CN1")+CN9->CN9_TPCTO)
			
			If CN1->CN1_XPERET > 0 .AND. ALLTRIM(UPPER(FUNNAME()))== "MATA103"  //Documento de Entrada com retenção contratual				
				
				//nValor := ROUND(((SE2->E2_VALOR*CN1->CN1_XPERET)/100),2) 
				
				dbSelectArea('SE2')                                         
				DBSETORDER(1)				
				//IF DBSEEK(XFILIAL("SE2")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+"CAU"+SE2->E2_FORNECE+SE2->E2_LOJA)				
				IF DBSEEK(SF1->(F1_FILIAL+F1_PREFIXO+F1_DOC+SPACE(TAMSX3("E2_PARCELA")[1])+"CAU"+F1_FORNECE+F1_LOJA))      // Incluido por Fabio Regueira 09/06/2015. 
					
					RecLock('SE2',.F.)
					dbDelete()
					MsUnLock()
					
				EndIF
			EndIf		
		EndIf
	EndIf		
	
	DIF->(DbCloseArea())    		
	
ElseIf nOpcao == 3 .and. nConfirma == 1   // Incluido por Vinicius figueiredo - Doit - 2013 09 11 - Gravar dados do item do documento de entrada no ativo fixo
//0.8287 UFIR
//Alterado por Ricardo Ferreira em 26/09/2013 
//Trocado para update para atualizar todos os itens do n1 e n3 ao mesmo tempo.

//*************************************************************************
//Substituido pelo ponto de entrada AT010GRV.PRW - Fabio Flores Regueira
//*************************************************************************
/*	
	cUpd   := "Update " + RetSqlName("SN1") + " SET N1_VLAQUIS = (CASE WHEN F4_PISCOF IN ('1','2','3') then (D1_VUNIT *  N1_QUANTD) - (((D1_VUNIT *  N1_QUANTD)*(F4_BCRDCOF+F4_BCRDPIS))/100) ELSE (D1_VUNIT *  N1_QUANTD) END) "
	
			//cQuery será usado nos 2 updates pois é o mesmo tratamento assim economiza codigo.
	cQuery := "FROM " + RetSqlName("SN1") + " SN1 "
	cQuery += "INNER JOIN " + RetSqlName("SD1") + " SD1 ON " 
	cQuery += "N1_FILIAL = D1_FILIAL AND "
	cQuery += "	N1_NFISCAL = D1_DOC AND "
	cQuery += "	N1_NSERIE = D1_SERIE AND "
	cQuery += "	N1_FORNEC = D1_FORNECE AND "
	cQuery += "	N1_LOJA = D1_LOJA AND "
	cQuery += "	N1_NFITEM = D1_ITEM AND SD1.D_E_L_E_T_ = ' '"
	cQuery += "	INNER JOIN " + RetSqlName("SN3") + " SN3 ON "
	cQuery += "	N3_FILIAL = N1_FILIAL AND N3_CBASE = N1_CBASE AND N3_ITEM = N1_ITEM AND SN3.D_E_L_E_T_ = ' '"
	cQuery += "INNER JOIN SF4010 SF4 ON F4_CODIGO = D1_TES AND SF4.D_E_L_E_T_ = ' ' " 
	cQuery += "	WHERE 	N1_FILIAL 	= '" + SF1->F1_FILIAL 	+ "' AND "
	cQuery += "   			N1_NFISCAL	= '" + SF1->F1_DOC 		+ "' AND "
	cQuery += "   			N1_NSERIE 	= '" + SF1->F1_SERIE    	+ "' AND "
	cQuery += "			N1_FORNEC	= '" + SF1->F1_FORNECE  	+ "' AND "
	cQuery += "			N1_LOJA 	= '" + SF1->F1_LOJA	  	+ "' AND SN1.D_E_L_E_T_ = ' '"
						 	
	If (TCSQLExec(cUpd + cQuery) < 0)
		Aviso("A T E N Ç Ã O ! ! !","Erro ao atualizar os campos do ativo fixo, será necessário atualizar direto no modulo ativo fixo" + Chr(13) + Chr(10) + TCSQLError(),{"Fechar"})
	EndIf
		
	cUpd   := "Update " + RetSqlName("SN3") + " SET 	"
	cUpd   += "    N3_TIPO    = '',"  
	cUpd 	+= "	N3_HISTOR  = N1_DESCRIC, "
	cUpd	+= "	N3_CUSTBEM = D1_CC," 
	cUpd   += "   N3_VORIG1  = (CASE WHEN F4_PISCOF IN ('1','2','3') then (D1_VUNIT *  N1_QUANTD) - (((D1_VUNIT *  N1_QUANTD)*(F4_BCRDCOF+F4_BCRDPIS))/100) ELSE (D1_VUNIT *  N1_QUANTD) END) ," 
    cUpd   += "   N3_VORIG3  = (CASE WHEN F4_PISCOF IN ('1','2','3') then ((D1_VUNIT *  N1_QUANTD)*"+ cValtoChar(nUfir)+") - ((((D1_VUNIT *  N1_QUANTD)*(F4_BCRDCOF+F4_BCRDPIS))/100)*"+ cValtoChar(nUfir)+") ELSE ((D1_VUNIT *  N1_QUANTD)*"+ cValtoChar(nUfir)+") END) ," 
	cUpd	+= "	N3_CCDESP  = D1_CC "
			
	If (TCSQLExec(cUpd + cQuery) < 0)
		Aviso("A T E N Ç Ã O ! ! !","Erro ao atualizar os campos do ativo fixo, será necessário atualizar direto no modulo ativo fixo" + Chr(13) + Chr(10) + TCSQLError(),{"Fechar"})
	EndIf
*/
/*
  	dbSelectArea("SD1")
	dbSetOrdeR(1)
	If dbSeek( xFilial("SD1") + SF1->( F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA ) )
	    While !SD1->( eof() ) .AND.  (SF1->( F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA )) == (SD1->( D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA )  ) 
		 	dbSelectArea("SN1")
	    	dbSetOrder(8)//
	    	If dbSeek( xFilial("SN1") + SD1->( D1_FORNECE + D1_LOJA ) + SF1->F1_ESPECIE + SD1->( D1_DOC + D1_SERIE + D1_ITEM )  ) .OR.;
		    	dbSeek( xFilial("SN1") + SD1->( D1_FORNECE + D1_LOJA ) + Space(TamSX3("N1_NFESPEC")[1]) + SD1->( D1_DOC + D1_SERIE + D1_ITEM )  )
				RecLock("SN1",.F.)				
			  //	SN1->N1_VLAQUIS := SD1->D1_TOTAL         Alterado por Roberto Lima em 16/09/2013.
			     SN1->N1_VLAQUIS := SD1->D1_VUNIT
				MSUnLock()                 
			EndIf

		 	dbSelectArea("SN3")
	    	dbSetOrder(1)//
	    	If dbSeek( xFilial("SN3") + SN1->(N1_CBASE + N1_ITEM )  )
				RecLock("SN3",.F.)				
				SN3->N3_HISTOR  := POSICIONE("SB1",1,XFILIAL("SB1")+SN1->N1_PRODUTO,"B1_DESC")
				SN3->N3_CUSTBEM := SD1->D1_CC
				SN3->N3_VORIG3  := SD1->D1_CUSTO3
				SN3->N3_CCDESP  := SD1->D1_CC
				MSUnLock()                 
			EndIf

	      	SD1->( dbSkip() )
		EndDo                                                          
	EndIf
*/
	
	dbSelectArea("SD1")
	dbSetOrdeR(1)
	If dbSeek( xFilial("SD1") + SF1->( F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA ) )
	    While !SD1->( eof() ) .AND.  (SF1->( F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA )) == (SD1->( D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA )  ) 
			cComp := ""	
			DbSelectArea("SC7")
			DbSetORder(1)
			If DbSeek(xFilial("SC7")+SD1->D1_PEDIDO+SD1->D1_ITEMPC)
				dbSelectArea("CND")
				dbSetOrder(1)
				If dbSeek(xFilial("CND")+SC7->C7_CONTRA+SC7->C7_CONTREV+SC7->C7_PLANILH+SC7->C7_MEDICAO)
					cComp := CND->CND_COMPET
				ElseIf dbSeek(xFilial("CND")+SC7->C7_CONTRA+SC7->C7_CONTREV+Space(TamSx3("C7_PLANILH")[1])+SC7->C7_MEDICAO)
					cComp := CND->CND_COMPET
				Endif
			Endif
		  	
			RecLock("SD1",.F.)
			SD1->D1_XPERFAT :=cComp
			MsUnlock()
	      	SD1->( dbSkip() )
		EndDo                                                          
	EndIf

EndIf

RestArea1(_aArea)
			
Return


User Function 103vPerFat()
Local lret := .T.

//dbSelectArea("SD1")
//dbSetOrdeR(1)
//If dbSeek( xFilial("SD1") + SF1->( F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA ) )
    //While !SD1->( eof() ) .AND.  (SF1->( F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA )) == (SD1->( D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA )  ) 
		cComp := ""	
		cPed := aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == "D1_PEDIDO"})] //SD1->D1_PEDIDO
		cItPc := aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEMPC"})] //SD1->D1_ITEMPC
		DbSelectArea("SC7")
		DbSetORder(1)
		If DbSeek(xFilial("SC7")+cPed+cItPc)
			dbSelectArea("CND")
			dbSetOrder(1)
			If dbSeek(xFilial("CND")+SC7->C7_CONTRA+SC7->C7_CONTREV+SC7->C7_PLANILH+SC7->C7_MEDICAO)
				cComp := CND->CND_COMPET
			ElseIf dbSeek(xFilial("CND")+SC7->C7_CONTRA+SC7->C7_CONTREV+Space(TamSx3("C7_PLANILH")[1])+SC7->C7_MEDICAO)
				cComp := CND->CND_COMPET
			Endif
		Endif
		
		If !Empty(cComp) .AND. (aCols[n][aScan(aHeader,{|x| Alltrim(x[2]) == "D1_XPERFAT"})] <> cComp)
			lRet := .F.
			Alert("Competência informada diferente da competência da medição vinculada a esse documento!")
		Endif
	  	
      	//SD1->( dbSkip() )
//	EndDo                                                          
//EndIf

Return lret