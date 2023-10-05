#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "rwmake.ch"

/*/ 
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ 
<Descricao> : WebServices especÌfico para operaÁ„o do portal de central de aprovaÁıes em PHP
<Data> : 28/09/2015
<Processo> : Central de aprovaÁ„o 
<Ip:porta> : http://187.94.60.7:8035/ws/CENTRAPR.apw  //homologacao         
http://187.94.60.7:8035/ws/CENTRAPR.apw?wsdl
<Obs> :  
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ 
*/  

//VALORES 
WsStruct MapVl
	WsData cFil 		As String
	WsData nTotal   	As Float
EndWsStruct

WsStruct stArrayValor
     WsData ListVl 	As Array Of MapVl
EndWsStruct                                                




///////MAPA COTA«√O                                  
WsStruct MapCot
//	WsData cEmp 		As String
	WsData cFil 		As String
	WsData cNumCot   	As String
	WsData cComprador   As String
	WsData cCC 		    As String      

	WsData cCO 			As String      
	WsData cdescco 		As String      

	WsData cDtVal 		As String      
	WsData cDtEnv 		As String      
	WsData cRanking		As String      

//	WsData nGlOrder 	As Integer

EndWsStruct

WsStruct stArrayMapCot
     WsData ListMapCot 	As Array Of MapCot
EndWsStruct                                                


////////MAPA PEDIDO DE COMPRA
WsStruct MapPC
//	WsData cEmp 		As String
	WsData cFil 		As String
	WsData cNumPC   	As String
	WsData cFornecedor  As String
	WsData cDtEnt 		As String      
	WsData cComprador	As String      
	WsData cCotacao  	As String      
	WsData cCC 		    As String      

	WsData cCO 			As String      
	WsData cdescco 		As String      

	WsData nTotal   	As Float
	WsData cObs 		As String      
	WsData cStatus		As String      
EndWsStruct

WsStruct stArrayMapPC
     WsData ListMapPC 	As Array Of MapPC
EndWsStruct                                                



//////APROVA«√O COTA«√O
WsStruct Ranking
	WsData cAprovador	As String
	WsData cObs	   		As String
	WsData cPrimeiro    As String
	WsData cSegundo		As String      
	WsData cTerceiro	As String      
	WsData cQuarto  	As String      
	WsData cQuinto 		As String      
EndWsStruct

WsStruct stArrayRanking
     WsData ListRanking 	As Array Of Ranking
EndWsStruct                                                

WsStruct ItemCot
	WsData cItem		As String
	WsData nQtd			As Float  
	WsData cUM			As String      
	WsData cDesc    	As String
	WsData cForn1    	As String
	WsData nPrcUn1	 	As Float
	WsData cForn2    	As String
	WsData nPrcUn2	 	As Float
	WsData cForn3    	As String
	WsData nPrcUn3	 	As Float
	WsData cForn4    	As String
	WsData nPrcUn4	 	As Float
	WsData cForn5    	As String
	WsData nPrcUn5	 	As Float
EndWsStruct

WsStruct stArrayItemCot
     WsData ListItemCot 	As Array Of ItemCot
EndWsStruct                                                

WsStruct Fornecedor
	WsData cCodigo		As String
	WsData cUF	   		As String
	WsData cCondpag 	As String

//	WsData ItensCot    	As stArrayItemCot OPTIONAL //Array of ItemCot OPTIONAL
                   
	WsData nTotal    	As Float
	WsData cPrazo    	As String
	WsData nFrete    	As Float
	WsData nIPI	   		As Float
	WsData nICMS    	As Float
	WsData cContato    	As String
	WsData cNota    	As String
	WsData cRanking    	As String
EndWsStruct

WsStruct stArrayFornecedor
     WsData ListForn 	As Array Of Fornecedor
EndWsStruct                                                

WsStruct Cotacao
//	WsData cEmp 		As String
	WsData cFil 		As String
	WsData cNumCot		As String
	WsData cDtVal	   	As String
	WsData cCC	   	As String
	WsData cStatus 		As String      

	WsData cCO 			As String      
	WsData cdescco 		As String      

	WsData cComprador	As String      
	WsData cDtEnv		As String      
	WsData cAprovador 	As String      
	WsData cSolic 		As String      

	WsData Forn 		As StArrayFornecedor
	WsData Rank 		As StArrayRanking
	WsData ItensCot    	As stArrayItemCot

	WsData cObsComp		As String      
	WsData cObs		As String      
//	WsData cStatus		As String      

EndWsStruct



//////APROVA«√O PEDIDO COMPRA
WsStruct Aprov
	WsData cAprovador	As String
	WsData cNome	   	As String
	WsData cStatus    	As String
	WsData cDtLib		As String      
	WsData cObsLib		As String      
EndWsStruct

WsStruct stArrayAprov
     WsData ListAprov 	As Array Of Aprov
EndWsStruct                                                


WsStruct ItemPC
	WsData cItem		As String
	WsData cCodProd	   	As String
	WsData cDesc    	As String
	WsData cUM		As String      
	WsData nQtd		As Float    
	WsData nPrcUn	 	As Float
	WsData nDesc		As Float
	WsData nTotal		As Float
	WsData nTUltCom		As Float
	WsData cDtUlCom		As String
EndWsStruct

WsStruct stArrayItem
     WsData ListItemPC 	As Array Of ItemPC
EndWsStruct                                                



WsStruct PedCom
//	WsData cEmp 		As String
	WsData cFil 		As String

	WsData cNumPC		As String
	WsData cFornecedor   	As String
	WsData cCondPag	   	As String
	WsData cDtPrev		As String      
	WsData cComprador	As String      
	WsData cNumCot	 	As String      

	WsData Itens		As StArrayItem	
	WsData nTotal 		As Float      

	WsData cCC 		As String      
	WsData cStatus 		As String      

	WsData cCO 		As String      
	WsData cdescco 		As String      

	WsData cDescCC 		As String      
	WsData nValAcu 		As Float      

	WsData Aprovs		As stArrayAprov

	WsData cObsComp		As String      
	WsData cObsApr		As String      

	//WsData cStatus		As String      

EndWsStruct    


WsStruct PCAP
	WsData cFil 		As String
	WsData cNumPC		As String
	WsData cUser 		As String	
	WsData cObs 		As String      
	WsData cStatus		As String      
EndWsStruct    

WsStruct stArrayPCAP
     WsData ListPCAP 	As Array Of PCAP
EndWsStruct                                                

WsService CENTRAPR DESCRIPTION "WebService especÌfico portal de compras" 
    //Login Usu·rio
	WsMethod LogUsr 		Description "Autentica usu·rio pelo cadastro de usu·rios do Protheus."

	//Consulta Listas - CotaÁıes, PC
	//CotaÁıes
	WsData ListCot 			As stArrayMapCot
	WsMethod ChqMapCot 		Description "Retorna as cotaÁıes inerentes ao usu·rio."

	//PCs
	WsData ListPC 			As stArrayMapPC
	WsMethod ChqMapPC 		Description "Retorna os pedidos de compra inerentes ao usu·rio."

	//Consulta Totais - CotaÁıes, PCs
	WsData ListValor 		As stArrayValor
	//PCs
	WsMethod ChqValPC 		Description "Retorna total dos pedidos de compra inerentes ao usu·rio."
	//CotaÁıes
	WsMethod ChqValCot 		Description "Retorna total das cotaÁıes inerentes ao usu·rio."

	//Consulta Detalhes - CotaÁ„o, PC
	//PC
	WsData PedCom 			As PedCom          
	WsMethod ChqPedCom 		Description "Retorna todos os dados para visualizaÁ„o e analise do pedido de compra."
	//CotaÁ„o
	WsData Cotacao 			As Cotacao          
	WsMethod ChqCotacao 	Description "Retorna todos os dados para visualizaÁ„o e analise da cotaÁ„o."

	//AprovaÁıes - CotaÁ„o, PC
	//PCs
	WsMethod AprPedCom 		Description "Realiza a aprovaÁ„o ou rejeiÁ„o do pedido de compra."
	//CotaÁıes
	WsMethod AprCotacao 	Description "Realiza a aprovaÁ„o ou rejeiÁ„o da cotaÁ„o."

	WsData ListPCAP 		As stArrayPCAP

	WsData lOk 				As Boolean                     
	WsData cReceb 			As String
	WsData cReturn 			As String

EndWsService


//Login de usu·rio pelo cadastro de usuarios do protheus
WsMethod LogUsr WsReceive cReceb WsSend cReturn WsService CENTRAPR               

    Local cAlias   := GetNextAlias()                                    
	Local cBufAux := AllTrim(cReceb)
	ncontcol := 1
	cXUser := ""
	cXPsw := ""	
			
	While !Empty(cBufAux)
    // Usuario|Status
        xPos := AT("|",cBufAux)    

        Do Case 
            Case nContCol == 1         
                cXUser   := AllTrim(SubSTR(cBufAux,1,xPos-1))
            Case nContCol == 2         
                cXPsw    := AllTrim(SubSTR(cBufAux,1))
            Otherwise              
        EndCase            

        If xPos > 0    
            cBufAux := SubSTR(cBufAux,xPos+1)
        Else
            cBufAux := ""        
        Endif

        nContCol++
    EndDo     
	
    
    PswOrder(2)
    If !Empty(cXUser) .And. PswSeek(cXUser)
        cCodAux := PswRet(1)[1][1]
        If !PswName(cXPsw)
            cMsg := "Senha inv·lida!"
        Else
            cMsg := AllTrim(cCodAux)
        endif
    Else
        cMsg := "Usu·rio n„o encontrado!"
    EndIf
	::cReturn := cMsg

Return .T.


//Retorna o mapa de cotaÁıes do usu·rio
WsMethod ChqMapCot WsReceive cReceb WsSend ListCot WsService CENTRAPR               

    Local cAlias   := GetNextAlias()                                    
	Local cBufAux := AllTrim(cReceb)
	ncontcol := 1
	cXUser := ""
	cXSta := ""	
	cXDtI := ""
	cXDtF := ""
			
	While !Empty(cBufAux)
    // Usuario|Status|DtI|DtF
        xPos := AT("|",cBufAux)    

        Do Case 
            Case nContCol == 1         
                cXUser   := SubSTR(cBufAux,1,xPos-1)
            Case nContCol == 2         
                cXSta   := SubSTR(cBufAux,1,xPos-1)
            Case nContCol == 3         
                cXDtI   := SubSTR(cBufAux,1,xPos-1)
            Case nContCol == 4         
                cXDtF   := SubSTR(cBufAux,1)
            Otherwise              
        EndCase            

        If xPos > 0    
            cBufAux := SubSTR(cBufAux,xPos+1)
        Else
            cBufAux := ""        
        Endif

        nContCol++
    EndDo                
    
	cQuery := "SELECT " + CRLF
	cQuery += "     CR_FILIAL, CR_NUM, CR_NIVEL, C8_NUMSC, C8_XUSER, C8_VALIDA, CR_STATUS, C8_WFID, C8_XCO,C8_XDTENV,C8_XHRENV " + CRLF
	cQuery += "FROM " + CRLF
	cQuery += "    " + RetSqlName("SCR") + " SCR, "+ RetSqlName("SC8") +" SC8  " 
	cQuery += "WHERE " + CRLF
	cQuery += "    CR_TIPO = 'MC' AND " + CRLF
	cQuery += "    CR_USER = '"+cXUser+"' AND " + CRLF
//	cQuery += "    CR_APROV = '"+cReceb+"' AND " + CRLF
	If !Empty(cXSta)
		If AllTrim(cXSta) <> "99"
			cQuery += "    CR_STATUS = '"+cXSTa+"' AND " + CRLF
		Endif
	Else
		cQuery += "    CR_STATUS = '02' AND " + CRLF
    Endif 
	cQuery += "    CR_FILIAL = C8_FILIAL AND "
	If cXDtI<> Nil .AND. !Empty(cXDtI)
		cQuery += "    C8_EMISSAO >= '"+cXDtI+"' AND " + CRLF
    Endif 
	If cXDtF<> Nil .AND. !Empty(cXDtF)
		cQuery += "    C8_EMISSAO <= '"+cXDtF+"' AND " + CRLF
    Endif 

	cQuery += "    CR_NUM = C8_NUM AND "
	cQuery += "    SCR.D_E_L_E_T_ = ' ' AND SC8.D_E_L_E_T_ = ' ' " 
	cQuery += "    GROUP BY CR_FILIAL, CR_NUM, CR_NIVEL, C8_NUMSC, C8_XUSER, C8_VALIDA, CR_STATUS , C8_WFID , C8_XCO,C8_XDTENV ,C8_XHRENV "
		
	DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cAlias, .F., .T.)
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())     
	If (cAlias)->(Eof())                                 
		aAdd(::ListCot:ListMapCot, WSClassNew("MapCot"))    
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cFil := ""
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cNumCot := ""
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cComprador := ""
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cCC := "" 
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cCO := "" 
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cdescco := "" 
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cDtVal := "" 
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cRanking := "" 
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cDtEnv := "" 

	Endif
	While !(cAlias)->(Eof())                                                 
	
		If (cAlias)->CR_NIVEL > '01'	
			cAlias2 := GetNextAlias()
			
			cQuery := "SELECT " + CRLF
			cQuery += "     CR_FILIAL, CR_NUM,  CR_STATUS " + CRLF
			cQuery += "FROM " + CRLF
			cQuery += "    " + RetSqlName("SCR") + " SCR " 
			cQuery += "WHERE " + CRLF
			cQuery += "    CR_FILIAL = '" + (cAlias)->CR_FILIAL + "' AND " + CRLF
			cQuery += "    CR_TIPO = 'MC' AND " + CRLF
			cQuery += "    CR_NIVEL = '"+STRZERO(val((cAlias)->CR_NIVEL)-1,2)+"' AND " + CRLF
			cQuery += "    CR_STATUS NOT IN ('02','04') AND " + CRLF   
			cQuery += "    CR_NUM = '"+(cAlias)->CR_NUM+"' AND " + CRLF			
			cQuery += "    D_E_L_E_T_ = '' " + CRLF
									
			DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cAlias2, .F., .T.)
			DbSelectArea(cAlias2)
			(cAlias2)->(DbGoTop())     
			If (cAlias2)->(Eof())                                 
				(cAlias)->(DbSkip())       
				Loop				                                                     	
		    Endif
           	(cAlias2)->(DbCloseArea())                                 
		Endif
			
        cXCC := ""
		aAdd(::ListCot:ListMapCot, WSClassNew("MapCot"))       
		cXCC := AllTrim(Posicione("SC1",1,(cAlias)->CR_FILIAL+(cAlias)->C8_NUMSC,"C1_CC"))
		If cXCC == NiL
			cXCC := ""     	
		Endif                                                                             
		
		cXUs := AllTrim(Posicione("SC1",1,(cAlias)->CR_FILIAL+(cAlias)->C8_NUMSC,"C1_USER"))
		DbSelectArea("SY1")
		SY1->(DbSetOrder(3))
		If SY1->(DbSeek(SubSTR((cAlias)->CR_FILIAL,1,2)+"  " + cXUs ))
			If !Empty(SY1->Y1_XRESP)
				SY1->(DbSetOrder(1))
				If SY1->(DbSeek(SubSTR((cAlias)->CR_FILIAL,1,2)+"  " + SY1->Y1_XRESP))
					cXUs := SY1->Y1_COD + ' - ' + AllTrim(SY1->Y1_NOME)
				EndIf
			Else
				cXUs := SY1->Y1_COD + ' - ' + AllTrim(SY1->Y1_NOME)
			EndIf
		Else
			cXUs := ""
		EndIf
		cDtEnv := (cAlias)->C8_XDTENV + " " + (cAlias)->C8_XHRENV
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cFil := (cAlias)->CR_FILIAL
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cNumCot := AllTrim((cAlias)->CR_NUM)
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cComprador := cXUs //cXUs+" - "+UsrFullName(cXUs)
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cCC := cXCC
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cCO := (cAlias)->C8_XCO
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cdescco := AllTrim(Posicione("AK5",1,xFilial("AK5")+AllTrim((cAlias)->C8_XCO),"AK5_DESCRI")) 
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cDtVal := (cAlias)->C8_VALIDA
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cRanking := (cAlias)->CR_STATUS
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cDtEnv := cDtEnv

	    cAlias2   := GetNextAlias()                                    
        
    /*
		cQuery := "SELECT " + CRLF
		cQuery += "      WF3_DATA, WF3_HORA AS HORAX  " + CRLF
		cQuery += "FROM " + CRLF
		cQuery += "    " + RetSqlName("WF3") +" WF3 " + CRLF
		cQuery += "WHERE " + CRLF
		cQuery += "    	SubSTRING(WF3_ID,1,8) = '"+(cAlias)->C8_WFID+"' AND "	
		cQuery += "     (WF3_STATUS = '100100' OR WF3_PROC = 'APRCOT' ) AND  "	
		cQuery += "     WF3.D_E_L_E_T_ = ' ' "                     	
		//cQuery += "    WF3_ID LIKE('%C8_WFID%') AND "
	//	cQuery += "    	SubSTRING(WF3_ID,1,8) = C8_WFID AND "	
		//cQuery += "     WF3_DESC LIKE '%"+AllTrim((cAlias)->CR_NUM)+"%' AND "				
	//	cQuery += "    	WF3_USU = '"+UsrFullName(cReceb)+"' AND "		
			
		DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cAlias2, .F., .T.)
		DbSelectArea(cAlias2)
		(cAlias2)->(DbGoTop())     
		If (cAlias2)->(!Eof())                                 						
        	cDtEnv := (cAlias2)->WF3_DATA+" "+(cAlias2)->HORAX				
		Endif
		                                                            			
		::ListCot:ListMapCot[Len(::ListCot:ListMapCot)]:cDtEnv := cDtEnv
		*/
		(cAlias)->(DbSkip())       

	EndDo	
	(cAlias)->(DbCloseArea())       

Return .T.


//Retorna o total de cotaÁıes do usu·rio
WsMethod ChqValCot WsReceive cReceb WsSend ListValor WsService CENTRAPR               

    Local cAlias   := GetNextAlias()                                    
	Local cBufAux := AllTrim(cReceb)
	ncontcol := 1
	cXUser := ""
	cXSta := ""	
	cXDtI := ""
	cXDtF := ""
			
	While !Empty(cBufAux)
    // Usuario|Status
        xPos := AT("|",cBufAux)    

        Do Case 
            Case nContCol == 1         
                cXUser   := SubSTR(cBufAux,1,xPos-1)
            Case nContCol == 2         
                cXSta   := SubSTR(cBufAux,1,xPos-1)
            Case nContCol == 3         
                cXDtI   := SubSTR(cBufAux,1,xPos-1)
            Case nContCol == 4         
                cXDtF   := SubSTR(cBufAux,1)
            Otherwise              
        EndCase            

        If xPos > 0    
            cBufAux := SubSTR(cBufAux,xPos+1)
        Else
            cBufAux := ""        
        Endif
        nContCol++
    EndDo                
    
	cQuery := "SELECT CR_FILIAL, " + CRLF
	cQuery += "     SUM(CR_TOTAL) AS TOTALCR " + CRLF
	cQuery += "FROM " + CRLF
	cQuery += "    " + RetSqlName("SCR") + " SCR, "+ RetSqlName("SC8") +" SC8  " 
	cQuery += "WHERE " + CRLF
	cQuery += "    CR_TIPO = 'MC' AND " + CRLF
	cQuery += "    CR_USER = '"+cXUser+"' AND " + CRLF
	If !Empty(cXSta)
		If AllTrim(cXSta) <> "99"
			cQuery += "    CR_STATUS = '"+cXSTa+"' AND " + CRLF
		Endif
	Else
		cQuery += "    CR_STATUS = '02' AND " + CRLF
    Endif 
	cQuery += "    CR_FILIAL = C8_FILIAL AND "
	If cXDtI<> Nil .AND. !Empty(cXDtI)
		cQuery += "    C8_EMISSAO >= '"+cXDtI+"' AND " + CRLF
    Endif 
	If cXDtF<> Nil .AND. !Empty(cXDtF)
		cQuery += "    C8_EMISSAO <= '"+cXDtF+"' AND " + CRLF
    Endif 
	cQuery += "    CR_NUM = C8_NUM AND "
	cQuery += "    SCR.D_E_L_E_T_ = ' ' AND SC8.D_E_L_E_T_ = ' ' " 
	cQuery += "    GROUP BY CR_FILIAL  ORDER BY CR_FILIAL  "
		
	DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cAlias, .F., .T.)
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())     
	lEmp1 := .F.
	lEmp2 := .F.
	If (cAlias)->(Eof())                                 
		lEmp1 := .F.
		lEmp2 := .F.
	Else       
		While (cAlias)->(!Eof())                                
			If SuBSTR((cAlias)->CR_FILIAL,1,2) == "01"
				lEmp1 := .T.
			ElseIf SuBSTR((cAlias)->CR_FILIAL,1,2) == "02"
				lEmp2 := .T.
			Endif 
			aAdd(::ListValor:ListVl, WSClassNew("MapVl"))     
			::ListValor:ListVl[Len(::ListValor:ListVl)]:cFil := (cAlias)->CR_FILIAL
			::ListValor:ListVl[Len(::ListValor:ListVl)]:nTotal := (cAlias)->TOTALCR
			(cAlias)->(DbSkip())                                 
		EndDo			
	Endif
	(cAlias)->(DbCloseArea())       
	If !lEmp1
		aAdd(::ListValor:ListVl, WSClassNew("MapVl"))     
		::ListValor:ListVl[Len(::ListValor:ListVl)]:cFil := "0101"
		::ListValor:ListVl[Len(::ListValor:ListVl)]:nTotal := 0
	Endif
	If !lEmp2
		aAdd(::ListValor:ListVl, WSClassNew("MapVl"))     
		::ListValor:ListVl[Len(::ListValor:ListVl)]:cFil := "0201"
		::ListValor:ListVl[Len(::ListValor:ListVl)]:nTotal := 0
	Endif
	
Return .T.


//Retorna o mapa de pedidos de compra do usu·rio
WsMethod ChqMapPC WsReceive cReceb WsSend ListPC WsService CENTRAPR               

    Local cAlias   := GetNextAlias()                                    
	Local cBufAux := AllTrim(cReceb)
	ncontcol := 1
	cXUser := ""
	cXSta := ""	
	cXDtI := ""	
	cXDtF := ""	

	While !Empty(cBufAux)
    // Usuario|Status
        xPos := AT("|",cBufAux)    

        Do Case 
            Case nContCol == 1         
                cXUser   := SubSTR(cBufAux,1,xPos-1)
            Case nContCol == 2         
                cXSta   := SubSTR(cBufAux,1,xPos-1)
            Case nContCol == 3         
                cXDtI   := SubSTR(cBufAux,1,xPos-1)
            Case nContCol == 4         
                cXDtF   := SubSTR(cBufAux,1)
            Otherwise              
        EndCase            

        If xPos > 0    
            cBufAux := SubSTR(cBufAux,xPos+1)
        Else
            cBufAux := ""        
        Endif
        nContCol++
    EndDo                    
    
	cQuery := "SELECT " + CRLF
	cQuery += "   CR_FILIAL, CR_NUM, CR_NIVEL, C7_FORNECE, C7_LOJA, C7_DATPRF , C7_USER, C7_NUMCOT, C7_CC, CR_STATUS, SUM(C7_TOTAL) AS TOTAL , C7_XCO" + CRLF
	cQuery += "  FROM " + CRLF
	cQuery += "    " + RetSqlName("SCR") + " SCR, "+ RetSqlName("SC7") +" SC7 " + CRLF
	cQuery += "WHERE " + CRLF
	cQuery += "    CR_TIPO = 'PC' AND " + CRLF
	cQuery += "    CR_USER = '"+cXUser+"' AND " + CRLF
	If !Empty(cXSta)
		If AllTrim(cXSta) <> "99"
			cQuery += "    CR_STATUS = '"+cXSTa+"' AND " + CRLF
		Endif
	Else
		cQuery += "    CR_STATUS = '02' AND " + CRLF
    Endif 
	If cXDtI<> Nil .AND. !Empty(cXDtI)
		cQuery += "    C7_EMISSAO >= '"+cXDtI+"' AND " + CRLF
    Endif 
	If cXDtF<> Nil .AND. !Empty(cXDtF)
		cQuery += "    C7_EMISSAO <= '"+cXDtF+"' AND " + CRLF
    Endif 
	cQuery += "    CR_FILIAL = C7_FILIAL AND "
	cQuery += "    CR_NUM = C7_NUM AND "
	cQuery += "    SCR.D_E_L_E_T_ = ' ' AND SC7. D_E_L_E_T_ = ' ' "                     	
  	cQuery += "    GROUP BY CR_FILIAL, CR_NUM, CR_NIVEL,  C7_FORNECE, C7_LOJA, C7_DATPRF , C7_USER, C7_NUMCOT, C7_CC, CR_STATUS, C7_XCO "
		
	DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cAlias, .F., .T.)
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())     
	If (cAlias)->(Eof())                                 
		aAdd(::ListPC:ListMapPC, WSClassNew("MapPC"))    
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cFil := (cAlias)->CR_FILIAL
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cNumPC := AllTrim((cAlias)->CR_NUM)
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cFornecedor := (cAlias)->C7_FORNECE+"/"+(cAlias)->C7_LOJA+" - "+Posicione("SA2",1,xFilial("SA2")+(cAlias)->C7_FORNECE+(cAlias)->C7_LOJA,"A2_NOME")
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cDtEnt := (cAlias)->C7_DATPRF
		
		DbSelectArea("SY1")
		SY1->(DbSetOrder(3))
		If SY1->(DbSeek(SubSTR((cAlias)->CR_FILIAL,1,2)+"  " + (cAlias)->C7_USER))
			If !Empty(SY1->Y1_XRESP)
				SY1->(DbSetOrder(1))
				If SY1->(DbSeek(SubSTR((cAlias)->CR_FILIAL,1,2)+"  " + SY1->Y1_XRESP))
					::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cComprador := SY1->Y1_COD + ' - ' + AllTrim(SY1->Y1_NOME)
				EndIf
			Else
				::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cComprador := SY1->Y1_COD + ' - ' + AllTrim(SY1->Y1_NOME)
			EndIf
		Else
			::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cComprador := ""
		EndIf
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cCotacao := (cAlias)->C7_NUMCOT				
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cCC := AllTrim((cAlias)->C7_CC)
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cCO := AllTrim((cAlias)->C7_XCO)
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cdescco := AllTrim(Posicione("AK5",1,xFilial("AK5")+AllTrim((cAlias)->C7_XCO),"AK5_DESCRI"))  
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:nTotal := (cAlias)->TOTAL
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cObs := "" //(cAlias)->C7_OBS
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cStatus := (cAlias)->CR_STATUS
	Endif
	While !(cAlias)->(Eof())  
/*
//Alterado por Ricardo Ferreira em 23/11/2017: Motivo. quando n„o tem todos os nÌveis d· erro. 
N„o tem necessidade dessa parte, pois se o status est· 02 ent„o est· para o usu·rio aprovar.
		If (cAlias)->CR_NIVEL > '01'	
			cAlias2 := GetNextAlias()
			
			cQuery := "SELECT " + CRLF
			cQuery += "     CR_FILIAL, CR_NUM,  CR_STATUS " + CRLF
			cQuery += "FROM " + CRLF
			cQuery += "    " + RetSqlName("SCR") + " SCR " 
			cQuery += "WHERE " + CRLF
			cQuery += "    CR_FILIAL = '" + (cAlias)->CR_FILIAL + "' AND " + CRLF
			cQuery += "    CR_TIPO = 'PC' AND " + CRLF
			cQuery += "    CR_NIVEL = '"+STRZERO(val((cAlias)->CR_NIVEL)-1,2)+"' AND " + CRLF
			cQuery += "    CR_NUM = '"+(cAlias)->CR_NUM+"' AND " + CRLF			
			cQuery += "    CR_STATUS NOT IN ('02','04') AND " + CRLF
			cQuery += "    D_E_L_E_T_ = '' " + CRLF
									
			DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cAlias2, .F., .T.)
			DbSelectArea(cAlias)
			(cAlias2)->(DbGoTop())     
			If (cAlias2)->(Eof())                                 
				(cAlias)->(DbSkip())       
				Loop				                                                     	
		    Endif
           	(cAlias2)->(DbCloseArea())                                 
		Endif
*/
		aAdd(::ListPC:ListMapPC, WSClassNew("MapPC"))    
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cFil := (cAlias)->CR_FILIAL
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cNumPC := AllTrim((cAlias)->CR_NUM)
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cFornecedor := (cAlias)->C7_FORNECE+"/"+(cAlias)->C7_LOJA+" - "+Posicione("SA2",1,xFilial("SA2")+(cAlias)->C7_FORNECE+(cAlias)->C7_LOJA,"A2_NOME")
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cDtEnt := (cAlias)->C7_DATPRF		

		DbSelectArea("SY1")
		SY1->(DbSetOrder(3))
		If SY1->(DbSeek(SubSTR((cAlias)->CR_FILIAL,1,2)+"  " + (cAlias)->C7_USER))
			If !Empty(SY1->Y1_XRESP)
				SY1->(DbSetOrder(1))
				If SY1->(DbSeek(SubSTR((cAlias)->CR_FILIAL,1,2)+"  " + SY1->Y1_XRESP))
					::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cComprador := SY1->Y1_COD + ' - ' + AllTrim(SY1->Y1_NOME)
				EndIf
			Else
				::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cComprador := SY1->Y1_COD + ' - ' + AllTrim(SY1->Y1_NOME)
			EndIf
		Else
			::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cComprador := ""
		EndIf
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cCotacao := (cAlias)->C7_NUMCOT				
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cCC := AllTrim((cAlias)->C7_CC)
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cCO := AllTrim((cAlias)->C7_XCO)
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cdescco := AllTrim(Posicione("AK5",1,xFilial("AK5")+AllTrim((cAlias)->C7_XCO),"AK5_DESCRI"))  
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:nTotal := (cAlias)->TOTAL
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cObs := "" //(cAlias)->C7_OBS
		::ListPC:ListMapPC[Len(::ListPC:ListMapPC)]:cStatus := (cAlias)->CR_STATUS

		(cAlias)->(DbSkip())       
	EndDo	
	(cAlias)->(DbCloseArea())       

Return .T.


//Retorna o mapa de pedidos de compra do usu·rio
WsMethod ChqValPC WsReceive cReceb WsSend ListValor WsService CENTRAPR               

    Local cAlias   := GetNextAlias()                                    
	Local cBufAux := AllTrim(cReceb)
	ncontcol := 1
	cXUser := ""
	cXSta := ""	
	cXDtI := ""	
	cXDtF := ""	

	While !Empty(cBufAux)
    // Usuario|Status
        xPos := AT("|",cBufAux)    

        Do Case 
            Case nContCol == 1         
                cXUser   := SubSTR(cBufAux,1,xPos-1)
            Case nContCol == 2         
                cXSta   := SubSTR(cBufAux,1,xPos-1)
            Case nContCol == 3         
                cXDtI   := SubSTR(cBufAux,1,xPos-1)
            Case nContCol == 4         
                cXDtF   := SubSTR(cBufAux,1)
            Otherwise              
        EndCase            

        If xPos > 0    
            cBufAux := SubSTR(cBufAux,xPos+1)
        Else
            cBufAux := ""        
        Endif
        nContCol++
    EndDo                
/*
//Alterado por Ricardo Ferreira em 23/11/2017: Motivo: LÛgica pegando o SC7 est· errada, pois multiplica o total pela quantidade dos itens.*/    
   	cQuery := "SELECT  CR_FILIAL, " + CRLF
	cQuery += "     SUM(CR_TOTAL) AS TOTALCR " + CRLF
	cQuery += "  FROM " + CRLF
	cQuery += "    " + RetSqlName("SCR") + " SCR, "+ RetSqlName("SC7") +" SC7 " + CRLF 
	cQuery += "WHERE " + CRLF
	cQuery += "    CR_TIPO = 'PC' AND " + CRLF
	cQuery += "    CR_USER = '"+cXUser+"' AND " + CRLF
	If !Empty(cXSta)
		If AllTrim(cXSta) <> "99"
			cQuery += "    CR_STATUS = '"+cXSTa+"' AND " + CRLF
		Endif
	Else
		cQuery += "    CR_STATUS = '02' AND " + CRLF
    Endif 
	If cXDtI<> Nil .AND. !Empty(cXDtI)
		cQuery += "    C7_EMISSAO >= '"+cXDtI+"' AND " + CRLF 
    Endif 
	If cXDtF<> Nil .AND. !Empty(cXDtF)
		cQuery += "    C7_EMISSAO <= '"+cXDtF+"' AND " + CRLF 
    Endif 
	cQuery += "    CR_FILIAL = C7_FILIAL AND "
	cQuery += "    CR_NUM = C7_NUM AND "
	cQuery += "    C7_ITEM = '0001' AND " //Ricardo Ferreira - 23/11/2017 - Pega somente o item 001 par buscar sÛ a emissao, assim n„o multiplica pela qtde de itens.
	cQuery += "    SCR.D_E_L_E_T_ = ' ' AND SC7. D_E_L_E_T_ = ' ' "                      	
  	cQuery += "    GROUP BY CR_FILIAL    ORDER BY CR_FILIAL    "
		
	DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cAlias, .F., .T.)
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())     
	lEmp1 := .F.
	lEmp2 := .F.
	If (cAlias)->(Eof())                         
		lEmp1 := .F.
		lEmp2 := .F.
	Else
		While (cAlias)->(!Eof())                                
			If SuBSTR((cAlias)->CR_FILIAL,1,2) == "01"
				lEmp1 := .T.
			ElseIf SuBSTR((cAlias)->CR_FILIAL,1,2) == "02"
				lEmp2 := .T.
			Endif 
			aAdd(::ListValor:ListVl, WSClassNew("MapVl"))     
			::ListValor:ListVl[Len(::ListValor:ListVl)]:cFil := (cAlias)->CR_FILIAL
			::ListValor:ListVl[Len(::ListValor:ListVl)]:nTotal := (cAlias)->TOTALCR
			(cAlias)->(DbSkip())                                 
		EndDo					
	Endif               
	(cAlias)->(DbCloseArea())       
	
	If !lEmp1
		aAdd(::ListValor:ListVl, WSClassNew("MapVl"))     
		::ListValor:ListVl[Len(::ListValor:ListVl)]:cFil := "0101"
		::ListValor:ListVl[Len(::ListValor:ListVl)]:nTotal := 0
	Endif
	If !lEmp2
		aAdd(::ListValor:ListVl, WSClassNew("MapVl"))     
		::ListValor:ListVl[Len(::ListValor:ListVl)]:cFil := "0201"
		::ListValor:ListVl[Len(::ListValor:ListVl)]:nTotal := 0
	Endif
	
Return .T.


//Retorna a cotaÁ„o detalhada para analise
WsMethod ChqCotacao WsReceive cReceb WsSend Cotacao WsService CENTRAPR               
	Local cBufAux := AllTrim(cReceb)
	Local nContCol := 1
	Local nTotAprv := 0
	Local nTot := 0
	Local lNAchou
	Local nLoop := 1
	Local aItens := {}
	Local aInfoUsu := {}
	Local n_x := 0
			
	While !Empty(cBufAux)
    // Filial|Pedido
        xPos := AT("|",cBufAux)    

        Do Case 
            Case nContCol == 1         
                cXFil   := SubSTR(cBufAux,1,xPos-1)
            Case nContCol == 2         
                cXPed   := SubSTR(cBufAux,1,xPos-1)
            Case nContCol == 3         
                cXUser  := SubSTR(cBufAux,1)                
            Otherwise              
        EndCase            

        If xPos > 0    
            cBufAux := SubSTR(cBufAux,xPos+1)
        Else
            cBufAux := ""        
        Endif
        nContCol++
    EndDo                
	
	WSClassNew("Cotacao")          
	
	SC8->(DbGoTop())
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(cXFil + cXPed))

	::Cotacao:cFil := cXFil
	::Cotacao:cNumCot := cXPed
	::Cotacao:cDtVal := DToS(SC8->C8_VALIDA)	
	::Cotacao:cCC	:= AllTrim(Posicione("SC1",1,SC8->C8_FILIAL+SC8->C8_NUMSC,"C1_CC"))
	::Cotacao:cStatus	 := GetSta("MC",cXUser,SC8->C8_NUM, SC8->C8_FILIAL) //AllTrim(Posicione("SCR",2,xFilial("SCR")+"MC"+Space(TamSX3("CR_NUM")[1]-Len(AllTrim(cXPed)))+cXUser,"CR_STATUS"))  
	::Cotacao:cCO	:= AllTrim(SC8->C8_XCO)
	::Cotacao:cdescco := AllTrim(Posicione("AK5",1,xFilial("AK5")+AllTrim(SC8->C8_XCO),"AK5_DESCRI"))  	
	cXApr := ""	
	PswOrder(1)
	If (PswSeek(AllTrim(cXUser), .T.))
		aInfoUsu := PswRet(1)
		cXApr := AllTrim(aInfoUsu[1, 4])
	Endif
	
	::Cotacao:cAprovador := cXApr  
	
	cXSolic := ""
	PswOrder(1)
	If (PswSeek(AllTrim(Posicione("SC1",1,SC8->C8_FILIAL+SC8->C8_NUMSC,"C1_USER")), .T.))
		aInfoUsu := PswRet(1)
		cXSolic := AllTrim(aInfoUsu[1, 4])
	Endif

	::Cotacao:cSolic 	:= cXSolic         

	cAlias   := GetNextAlias()                                    
	cXEnv := ""    
/*    
	cQuery := "SELECT " + CRLF
	cQuery += "     MAX(WF3_DATA) AS DATAX , MAX(WF3_HORA) AS HORAX " + CRLF
	cQuery += "FROM " + CRLF
	cQuery += "    " + RetSqlName("SCR") + " SCR, "+ RetSqlName("SC8") +" SC8 , "+ RetSqlName("WF3") +" WF3 " + CRLF
	cQuery += "WHERE " + CRLF
	cQuery += "    CR_FILIAL = '" + cXFil + "' AND " + CRLF
	cQuery += "    CR_TIPO = 'MC' AND " + CRLF
	cQuery += "    CR_USER = '"+cXUser+"' AND " + CRLF
	cQuery += "    CR_NUM = '"+cXPed+"' AND "     
	cQuery += "    CR_FILIAL = C8_FILIAL AND "
	cQuery += "    WF3_FILIAL = C8_FILIAL AND "
	cQuery += "    CR_NUM = C8_NUM AND "
	cQuery += "    	SubSTRING(WF3_ID,1,8) = C8_WFID AND "		
	cQuery += "    	WF3_PROC = 'WFRKMC' AND "    /// WF3_STATUS = '100100' AND  "	
//	cQuery += "     WF3_DESC LIKE '%"+cXPed+"%' AND "		
	cQuery += "    SCR.D_E_L_E_T_ = ' ' AND SC8. D_E_L_E_T_ = ' ' AND WF3. D_E_L_E_T_ = ' ' "                     	
//	cQuery += "    GROUP BY CR_FILIAL, CR_NUM, C8_NUMSC, C8_XUSER, C8_VALIDA, WF3_DATA, CR_STATUS "


	cQuery := "SELECT " + CRLF
	cQuery += "      WF3_DATA AS DATAX, WF3_HORA AS HORAX  " + CRLF
	cQuery += "FROM " + CRLF
	cQuery += "    " + RetSqlName("WF3") +" WF3 " + CRLF
	cQuery += "WHERE " + CRLF
	cQuery += "    	SubSTRING(WF3_ID,1,8) = '"+SC8->C8_WFID+"' AND "	
	cQuery += "     (WF3_STATUS = '100100' OR WF3_PROC = 'APRCOT' ) AND  "	
	cQuery += "     WF3.D_E_L_E_T_ = ' ' "                     	
	
	DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cAlias, .F., .T.)
	DbSelectArea(cAlias)
	(cAlias)->(DbGoTop())     
	If (cAlias)->(!Eof())                                 
		cXEnv := (cAlias)->DATAX+" "+(cAlias)->HORAX
	Endif  
	(cAlias)->(DbCloseArea())
	 */
	::Cotacao:cDtEnv := DTOS(SC8->C8_XDTENV) + " " + SC8->C8_XHRENV 

	cXComp := ""	
	SY1->(DbSetOrder(3))
	If SY1->(DbSeek(SubSTR(cXFil,1,2)+"  "+Posicione("SC1",1,SC8->C8_FILIAL+SC8->C8_NUMSC,"C1_USER")))              //xFilial('SY1')+Posicione("SC1",1,SC8->C8_FILIAL+SC8->C8_NUMSC,"C1_USER")))
		If !Empty(SY1->Y1_XRESP)
			SY1->(DbSetOrder(1))
			If SY1->(DbSeek(SubSTR(cXFil,1,2)+"  " + SY1->Y1_XRESP))
				cXComp :=  SY1->Y1_COD + ' - ' + AllTrim(SY1->Y1_NOME)
			EndIf
		Else
			cXComp :=  SY1->Y1_COD + ' - ' + AllTrim(SY1->Y1_NOME)
		EndIf
	Else
		cXComp := ''
	EndIf

	::Cotacao:cComprador := cXComp
                                                             	
	::Cotacao:cObsComp	:= AllTrim(SC8->C8_XOBSCOT)				 //NoAcento(AllTrim(SC8->C8_XOBSCOT+AllTrim(Posicione("SC1",1,SC8->C8_FILIAL+SC8->C8_NUMSC,"C1_OBS"))))				
	
	::Cotacao:cObs	:= ""    

    cForn1 := SC8->C8_FORNECE+SC8->C8_LOJA
    
	//WsData Rank 		As StArrayRanking
    lNAchou := .T.
	SCR->(DbGoTop())
	SCR->(DbSetOrder(1))
	If SCR->(DbSeek(cXFil + 'MC' + SC8->C8_NUM )) //+ Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))           //xFilial('SCR') + 'MC' + SC8->C8_NUM + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))))
		While !SCR->(Eof()) .And. (SCR->CR_TIPO == 'MC') .And. (AllTrim(SCR->CR_NUM) == SC8->C8_NUM)
			If (SCR->CR_STATUS == '03') //.OR. (SCR->CR_STATUS == '05') 

				SAK->(DbGoTop())
				SAK->(DbSetOrder(2))
				If SAK->(DbSeek(cXFil + SCR->CR_USER))     //xFilial('SAK') + SCR->CR_USER))
					lNAchou := .F.	
					aAdd(::Cotacao:Rank:ListRanking, WSClassNew("Ranking"))  
					::Cotacao:Rank:ListRanking[Len(::Cotacao:Rank:ListRanking)]:cAprovador := SAK->AK_COD + ' - ' + AllTrim(SAK->AK_NOME) 
					::Cotacao:Rank:ListRanking[Len(::Cotacao:Rank:ListRanking)]:cObs :=  AllTrim(SCR->CR_XOBSAPR)
					::Cotacao:Rank:ListRanking[Len(::Cotacao:Rank:ListRanking)]:cPrimeiro := SCR->CR_RKN1 + ' - ' + AllTrim(Posicione('SA2', 1, xFilial('SA2') + SubStr(SCR->CR_RKN1,1,6) + SubStr(SCR->CR_RKN1,8,2), 'A2_NOME')) 
					::Cotacao:Rank:ListRanking[Len(::Cotacao:Rank:ListRanking)]:cSegundo := SCR->CR_RKN2 + ' - ' + AllTrim(Posicione('SA2', 1, xFilial('SA2') + SubStr(SCR->CR_RKN2,1,6) + SubStr(SCR->CR_RKN2,8,2), 'A2_NOME')) 														
					::Cotacao:Rank:ListRanking[Len(::Cotacao:Rank:ListRanking)]:cTerceiro := SCR->CR_RKN3 + ' - ' + AllTrim(Posicione('SA2', 1, xFilial('SA2') + SubStr(SCR->CR_RKN3,1,6) + SubStr(SCR->CR_RKN3,8,2), 'A2_NOME')) 
					::Cotacao:Rank:ListRanking[Len(::Cotacao:Rank:ListRanking)]:cQuarto := SCR->CR_RKN4 + ' - ' + AllTrim(Posicione('SA2', 1, xFilial('SA2') + SubStr(SCR->CR_RKN4,1,6) + SubStr(SCR->CR_RKN4,8,2), 'A2_NOME')) 
					::Cotacao:Rank:ListRanking[Len(::Cotacao:Rank:ListRanking)]:cQuinto := SCR->CR_RKN5 + ' - ' + AllTrim(Posicione('SA2', 1, xFilial('SA2') + SubStr(SCR->CR_RKN5,1,6) + SubStr(SCR->CR_RKN5,8,2), 'A2_NOME')) 																				
				EndIf                      											
			EndIf
			If !Empty(AllTrim(SCR->CR_XOBSAPR)) .AND. SCR->CR_USER == cXUser  .AND. (SCR->CR_STATUS <> '03')
				::Cotacao:cObs	+= AllTrim(SCR->CR_XOBSAPR)    
			Endif
			SCR->(DbSkip())
		EndDo
	EndIf

	If lNAchou
		aAdd(::Cotacao:Rank:ListRanking, WSClassNew("Ranking"))  
		::Cotacao:Rank:ListRanking[Len(::Cotacao:Rank:ListRanking)]:cAprovador := ""
		::Cotacao:Rank:ListRanking[Len(::Cotacao:Rank:ListRanking)]:cObs :=  ""
		::Cotacao:Rank:ListRanking[Len(::Cotacao:Rank:ListRanking)]:cPrimeiro := ""
		::Cotacao:Rank:ListRanking[Len(::Cotacao:Rank:ListRanking)]:cSegundo := ""
		::Cotacao:Rank:ListRanking[Len(::Cotacao:Rank:ListRanking)]:cTerceiro := ""
		::Cotacao:Rank:ListRanking[Len(::Cotacao:Rank:ListRanking)]:cQuarto := ""
		::Cotacao:Rank:ListRanking[Len(::Cotacao:Rank:ListRanking)]:cQuinto := ""
	Endif

    //u_xConOut("1 WS TESTE "+SC8->C8_FILIAL+SC8->C8_NUM+" - "+cXFil+cXPed)
	While SC8->C8_FILIAL+SC8->C8_NUM == cXFil+cXPed

		aAdd(::Cotacao:Forn:ListForn, WSClassNew("Fornecedor"))            
		cCond := ""
		SE4->(DbSetOrder(1))
		If SE4->(DbSeek(xFilial('SE4') + SC8->C8_COND))
			cCond := SE4->E4_CODIGO + ' - ' + AllTrim(SE4->E4_DESCRI)
		EndIf     
		cUF := ""
		cXFor := ""         

		SA2->(DbSetOrder(1))
		If SA2->(DbSeek(xFilial('SA2') + SC8->C8_FORNECE+SC8->C8_LOJA ))
        	cUF := SA2->A2_EST
        	cXFor := SA2->A2_COD + '/' + SA2->A2_LOJA + ' - ' + AllTrim(SA2->A2_NOME)
		Endif 

		::Cotacao:Forn:ListForn[Len(::Cotacao:Forn:ListForn)]:cCodigo := cXFor 
		::Cotacao:Forn:ListForn[Len(::Cotacao:Forn:ListForn)]:cUF := cUF
		::Cotacao:Forn:ListForn[Len(::Cotacao:Forn:ListForn)]:cCondpag := cCond
		::Cotacao:Forn:ListForn[Len(::Cotacao:Forn:ListForn)]:cContato := SC8->C8_CONTATO
		::Cotacao:Forn:ListForn[Len(::Cotacao:Forn:ListForn)]:cPrazo := AllTrim(STR(SC8->C8_PRAZO))	
		::Cotacao:Forn:ListForn[Len(::Cotacao:Forn:ListForn)]:cRanking := ""
	
	    nTot := 0
   		nValFre := 0
		nValIPI := 0
		nValICM := 0
		nValDesc := 0
		nValDesp := 0
		nValSeg := 0
		cProdAval := ""        
		
		While SC8->C8_FILIAL+SC8->C8_NUM+SC8->C8_FORNECE+SC8->C8_LOJA == cXFil+cXPed+cForn1  			
		
			nP := aScan(aItens,{|x| AllTrim(x[1]) == AllTrim(SC8->C8_ITEM) })
			If nP == 0 
				aAdd(aItens,{SC8->C8_ITEM,SC8->C8_QUANT,SC8->C8_UM,AllTrim(Posicione('SC1', 1, cXFil + SC8->C8_NUMSC + SC8->C8_ITEMSC, 'C1_DESCRI')),cXFor,SC8->C8_PRECO,"",0,"",0,"",0,"",0})
			Else
				If nLoop == 2
					nY1 := 7
					nY2 := 8
				ElseIF nLoop == 3
					nY1 := 9
					nY2 := 10				
				ElseIF nLoop == 4
					nY1 := 11
					nY2 := 12
				ElseIF nLoop == 5
					nY1 := 13
					nY2 := 14
				Endif
			    aItens[nP][nY1] := cXFor //cForn1
			    aItens[nP][nY2] := SC8->C8_PRECO
			Endif
					
            nTot += SC8->C8_TOTAL + SC8->C8_VALFRE + SC8->C8_DESPESA + SC8->C8_SEGURO + SC8->C8_VALIPI - SC8->C8_VLDESC
            nValFre += SC8->C8_VALFRE 
			nValIPI += SC8->C8_VALIPI
			nValICM += SC8->C8_VALICM
			nValDesc += SC8->C8_VLDESC
			nValDesp += SC8->C8_DESPESA
			nValSeg += SC8->C8_SEGURO
			cProdAval += SC8->C8_PRODUTO+","

			SC8->(DbSkip())
        	
		EndDo    

		::Cotacao:Forn:ListForn[Len(::Cotacao:Forn:ListForn)]:nTotal := nTot
		::Cotacao:Forn:ListForn[Len(::Cotacao:Forn:ListForn)]:nFrete := nValFre
		::Cotacao:Forn:ListForn[Len(::Cotacao:Forn:ListForn)]:nIPI := nValIPI
		::Cotacao:Forn:ListForn[Len(::Cotacao:Forn:ListForn)]:nICMS := nValICM
        
        cNota := ""
		If !Empty(cProdAval)
			cProdAval := SubSTR(cProdAval,1,Len(cProdAval)-1)
			cProdAval := Replace(cProdAval,",","','")
			cProdAval := "'"+cProdAval+"'"		
	        cQry := 'SELECT (SUM(A5_NOTA) / COUNT(A5_PRODUTO)) AVGNOTA '
			cQry += 'FROM ' + RetSQLName('SA5') + ' SA5 '
			cQry += "WHERE SA5.A5_FORNECE = '" + SubSTR(cForn1,1,6) + "' "
			cQry += "AND SA5.A5_LOJA = '" + SubSTR(cForn1,7,2) + "' "
			cQry += "AND SA5.A5_PRODUTO IN(" + cProdAval + ") "
			TCQuery cQry New ALIAS 'WFAVALb'
			WFAVALb->(DbGoTop())
			If !WFAVALb->(Eof())
				cNota := StrZero(WFAVALb->AVGNOTA, 1)
			EndIf
			WFAVALb->(DbCloseArea())
	
		Endif

		::Cotacao:Forn:ListForn[Len(::Cotacao:Forn:ListForn)]:cNota := cNota      
					
	    cForn1 := SC8->C8_FORNECE+SC8->C8_LOJA
        nLoop++
        
	EndDo	              
	
	If Len(aItens) > 0
	
		For n_x := 1 to Len(aItens)
			aAdd(::Cotacao:ItensCot:ListItemCot , WSClassNew("ItemCot"))			    
			::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:cItem := aItens[n_x][1]
			::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:nQtd := aItens[n_x][2]
			::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:cUM := aItens[n_x][3]
			::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:cDesc := aItens[n_x][4]
			::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:cForn1 := aItens[n_x][5]
			::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:nPrcUn1 :=aItens[n_x][6]
			::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:cForn2 := aItens[n_x][7]
			::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:nPrcUn2 :=aItens[n_x][8]
			::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:cForn3 := aItens[n_x][9]
			::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:nPrcUn3 :=aItens[n_x][10]
			::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:cForn4 := aItens[n_x][11]
			::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:nPrcUn4 :=aItens[n_x][12]
			::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:cForn5 := aItens[n_x][13]
			::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:nPrcUn5 :=aItens[n_x][14]
																				
		next n_x                 
	Else
	
		aAdd(::Cotacao:ItensCot:ListItemCot , WSClassNew("ItemCot"))		    
		::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:cItem := ""
		::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:nQtd := 0
		::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:cUM := ""
		::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:cDesc := ""
		::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:cForn1 := ""
		::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:nPrcUn1 :=0
		::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:cForn2 := ""
		::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:nPrcUn2 :=0
		::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:cForn3 := ""
		::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:nPrcUn3 :=0
		::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:cForn4 := ""
		::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:nPrcUn4 :=0
		::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:cForn5 := ""
		::Cotacao:ItensCot:ListItemCot[Len(::Cotacao:ItensCot:ListItemCot)]:nPrcUn5 :=0

	Endif
	    
Return .T.


//Aprova ou rejeita a cotaÁ„o e grava o ranking informado
WsMethod AprCotacao WsReceive cReceb WsSend cReturn WsService CENTRAPR               

	Local cBufAux := AllTrim(cReceb)
	Local nContCol := 1
	Local nTotAprv := 0
	Local nTot := 0
	Local lNAchou                           
	Local cMen := ""
	Local cXObs := ""
	Local aInfousu := {}                       
	//Local aEmail := {}
		
	While !Empty(cBufAux)
    // Filial|Pedido|Usu·rio|SouN|Forn1|Forn2|Forn3|Forn4|Forn5|Obs
        xPos := AT("|",cBufAux)    

        Do Case 
            Case nContCol == 1         
                cXFil   := SubSTR(cBufAux,1,xPos-1)+"01"
            Case nContCol == 2         
                cXPed   := SubSTR(cBufAux,1,xPos-1)
            Case nContCol == 3         
                cXUser  := SubSTR(cBufAux,1,xPos-1)
            Case nContCol == 4         
                cXOp  := SubSTR(cBufAux,1,xPos-1)                    
            Case nContCol == 5         
                cXF1  := SubSTR(cBufAux,1,xPos-1)
                //cXF1  := Replace(cXF1,"/","")
            Case nContCol == 6         
                cXF2  := SubSTR(cBufAux,1,xPos-1)
                //cXF2  := Replace(cXF2,"/","")
            Case nContCol == 7         
                cXF3  := SubSTR(cBufAux,1,xPos-1)
                //cXF3  := Replace(cXF3,"/","")
            Case nContCol == 8         
                cXF4  := SubSTR(cBufAux,1,xPos-1)
                //cXF4  := Replace(cXF4,"/","")                
            Case nContCol == 9         
                cXF5  := SubSTR(cBufAux,1,xPos-1)
                //cXF5  := Replace(cXF5,"/","")
            Case nContCol == 10         
                cXObs  := SubSTR(cBufAux,1)                             
            Otherwise              
        EndCase            

        If xPos > 0    
            cBufAux := SubSTR(cBufAux,xPos+1)
        Else
            cBufAux := ""        
        Endif
        nContCol++
    EndDo                

	cUsrCtr := cXUser
	
	dbSelectArea("SC8")
	dbSetOrder(1)
	If dbSeek(cXfil+cXPed)
	     cMen+=" - passei no c8 - chave da SCR "+cXFil+'MC'+cXPed+cXUser+" "    
		cGrupo := SC8->C8_GRUPCOM
		
		cCodComp := SC8->C8_XUSER 
		PswOrder(1)
		PswSeek(cCodComp,.T.)	
		aUser := PswRet( 1 )	
		cNomeComp := aUser[1][4]
		
		DbSelectArea("SCR")
		DbSetOrder(2)
		If DbSeek(cXFil+'MC'+cXPed+Space(TamSX3("CR_NUM")[1]-Len(cXPed))+cXUser)
	     	cMen +=" - passei no cr - "		
			nTotal := SCR->CR_TOTAL
			cUsrCtr := SCR->CR_USER
			cNivAtu := SCR->CR_NIVEL
			aAreaSCR := SCR->(GetArea())                       
			cUserLib := SCR->CR_USER
			cUserApr := SCR->CR_APROV
			
			DbSelectArea("SCR")
			DbSetOrder(1)
			If DbSeek(cXFil+'MC'+cXPed+Space((TamSX3('CR_NUM')[1] - TamSX3('C7_NUM')[1])) +cNivAtu)							
				While !SCR->(Eof()) .And. (AllTrim(SCR->CR_NUM) == cXPed )
                        
					If cXOp<>'S'
						SCR->(RecLock('SCR', .F.))
						SCR->CR_STATUS	 := '04'
						SCR->CR_DATALIB := Date()                                       
						
						SCR->CR_USERLIB := cUserLib //SCR->CR_USER
						SCR->CR_LIBAPRO := cUserApr                 						
						SCR->CR_OBS := AllTrim(cXObs)
						SCR->CR_XOBSAPR := AllTrim(cxobs)				
						SCR->(MsUnLock())                        
						//Enviar email rejeiÁ„o Ranking							
					Else						
						If (SCR->CR_STATUS == '02') .And. (SCR->CR_NIVEL == cNivAtu) .AND. SCR->CR_USER <> cXUser
							SCR->(RecLock('SCR', .F.))
							SCR->CR_STATUS	:= "05"
							SCR->CR_DATALIB := Date()
							SCR->CR_USERLIB := cUserLib //SCR->CR_USER
							//SCR->CR_LIBAPRO := SCR->CR_APROV
							SCR->CR_OBS := "Lib Auto Nivel"
							SCR->(MsUnLock())
						ElseIf (SCR->CR_STATUS == '02') .And. (SCR->CR_NIVEL == cNivAtu) .AND. SCR->CR_USER == cXUser
							SCR->(RecLock('SCR', .F.))
							SCR->CR_STATUS	:= "03"
							SCR->CR_DATALIB := Date()
							SCR->CR_USERLIB := cUserLib //SCR->CR_USER
							SCR->CR_LIBAPRO := SCR->CR_APROV
							SCR->CR_OBS := AllTrim(cXObs)
							SCR->CR_RKN1 := cXF1
							SCR->CR_RKN2 := cXF2
							SCR->CR_RKN3 := cXF3
							SCR->CR_RKN4 := cXF4
							SCR->CR_RKN5 := cXF5
							SCR->CR_XOBSAPR := AllTrim(cxobs)				
							SCR->(MsUnLock())
						ElseIf (Val(SCR->CR_NIVEL) == Val(cNivAtu)+1)
							SCR->(RecLock('SCR', .F.))
							SCR->CR_STATUS := '02'                    
							//Enviar email aguardando aprovaÁ„o Ranking
							SCR->(MsUnLock())

							PswOrder(1)
							PswSeek(SCR->CR_USER,.T.)	
							aUser := PswRet( 1 )	
							cNome := aUser[1][4]
						
							//PswOrder(1)
							//If (PswSeek(AllTrim(SCR->CR_USER), .T.))
							//	aUser := PswRet(1)

								//aAdd(aEMail, {AllTrim(aUser[1, 14]), SCR->CR_APROV, AllTrim(SAK->AK_NOME), SCR->CR_USER})
								//aAdd(aEMail, {AllTrim("fabio.regueira@portonovosa.com"), SCR->CR_APROV, AllTrim(SAK->AK_NOME), SCR->CR_USER})
								//PARA TESTES
								//aAdd(aEMail, {AllTrim("fabio.regueira@portonovosa.com"), SAK->AK_COD, AllTrim(SAK->AK_NOME), SAK->AK_USER})
								//U_WFEnvMsg(8,cxFil,SCR->CR_USER,cXPed,{AllTrim("fabio.regueira@portonovosa.com"), SCR->CR_APROV, AllTrim(cNome), SCR->CR_USER},"")
								U_WFEnvMsg(8,cxFil,SCR->CR_USER,cXPed,{AllTrim(aUser[1, 14]), SCR->CR_APROV, AllTrim(cNome), SCR->CR_USER},"")
							//EndIf
			
							
						EndIf
					Endif
					SCR->(DbSkip())

				EndDo
			Endif
			
			RestArea(aAreaSCR)

			/*
 				[1][1] N˙mero do documento
                [1][2] Tipo de Documento 
                [1][3] Valor do Documento 
                [1][4] CÛdigo do Aprovador
                [1][5] CÛdigo do Usu·rio
                [1][6] Grupo do Aprovador
                [1][7] Aprovador Superior
                [1][8] Moeda do Documento
                [1][9] Taxa da Moeda 
                [1][10] Data de Emiss„o do Documento
                [1][11] Grupo de Compras 
     		*/ 

			If cXOp<>'S'
				DbSelectArea("SC8")
				DbSetOrder(1)
				If DbSeek(cXFil+padr(alltrim(cxped),tamsx3("C8_NUM")[1]))		
					While SC8->(!Eof()) .And. (SC8->C8_FILIAL+alltrim(SC8->C8_NUM) == cXFil+alltrim(cxped))
						Reclock("SC8",.F.)
						SC8->C8_CONAPRO := "B"
						SC8->C8_FLAGWF := '2'
						SC8->C8_NUMPED := ""   
						MsUnlock()
						SC8->(DbSkip())
					EndDo						
				Endif
			Endif
							

			If IsFullLib(cXFil+"MC"+cxped)	
			
				DbSelectArea("SC8")
				DbSetOrder(1)
				If DbSeek(cXFil+padr(alltrim(cxped),tamsx3("C8_NUM")[1]))		
					While SC8->(!Eof()) .And. (SC8->C8_FILIAL+alltrim(SC8->C8_NUM) == cXFil+alltrim(cxped))
						Reclock("SC8",.F.)
						SC8->C8_CONAPRO := "L"
						MsUnlock()
						SC8->(DbSkip())
					EndDo						
				Endif

				DbSelectArea("SC8")
				DbSetOrder(1)
				DbSeek(cXFil+padr(alltrim(cxped),tamsx3("C8_NUM")[1]))
						
				cxcod := ""
				DbSelectArea("SY1")
				SY1->(DbSetOrder(3))
				If SY1->(DbSeek(SubSTR(cXFil,1,2)+"  " + SC8->C8_XUSER))
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
				EndIf				

				PswOrder(1)
				PswSeek(cxcod,.T.)	
				aUser := PswRet( 1 )	                   
				cNome := aUser[1][4]				
				If ( aUser[1,14] <> " " ) 
					//U_WFEnvMsg(5,cxFil,cXCod,cXPed,{"","", AllTrim(cNome), ""})
					U_WFEnvMsg(5,cxFil,cXCod,cXPed,{AllTrim(aUser[1, 14]),"", AllTrim(cNome), cxcod})
				EndIf                                          
				
				cxcod	:= ""						
				DbSelectArea("SC1")
				DbSetOrder(5)
				If DbSeek(cXFil + SC8->C8_NUM)
					cxcod	:= SC1->C1_USER																		
					DbSelectArea("SY1")
					DbSetOrder(3)
					If DbSeek(SubSTR(cXFil,1,2)+"  " + SC1->C1_USER)
						If !Empty(SY1->Y1_XRESP)
							SY1->(DbSetOrder(1))
							If DbSeek(SubSTR(cXFil,1,2)+"  " + SY1->Y1_XRESP)
								cxcod	:= SY1->Y1_USER 
							EndIf
						EndIf
					Endif

					PswOrder(1)
					PswSeek(cxcod,.T.)	
					aUser := PswRet( 1 )
					cNome := aUser[1][4]	
					If ( aUser[1,14] <> " " )
						U_WFEnvMsg(6,cxFil,cXCod,cXPed,{AllTrim(aUser[1, 14]),"", AllTrim(cNome), cxcod})
					EndIf                     				
	
				Endif	                                 
				
			Endif

		Endif
				    
	Endif

::cReturn := "OK"

Return .T.


//Retorna o pedido de compra detalhado para analise
WsMethod ChqPedCom WsReceive cReceb WsSend PedCom WsService CENTRAPR               
	
	Local cBufAux := AllTrim(cReceb)
	Local nContCol := 1
	Local nTotAprv := 0
	Local nTot := 0
	Local lNAchou
		
	While !Empty(cBufAux)
    // Filial|Pedido|Usu·rio
        xPos := AT("|",cBufAux)    

        Do Case 
            Case nContCol == 1         
                cXFil   := SubSTR(cBufAux,1,xPos-1)
            Case nContCol == 2         
                cXPed   := SubSTR(cBufAux,1,xPos-1)
            Case nContCol == 3         
                cXUser  := SubSTR(cBufAux,1)
                
            Otherwise  
            
        EndCase            


        If xPos > 0    
            cBufAux := SubSTR(cBufAux,xPos+1)
        Else
            cBufAux := ""        
        Endif

        nContCol++
    EndDo                
	
	WSClassNew("PedCom")
    
    DbSelectArea("SC7")
    DbSetOrder(1)
    If DbSeek(cXFil+cXPed)

		::PedCom:cFil 	:= cXFil
		::PedCom:cNumPC	:= cXPed
		::PedCom:cFornecedor  := SC7->C7_FORNECE+"/"+SC7->C7_LOJA+" - "+Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")

		::PedCom:cDtPrev	:= DToS(SC7->C7_DATPRF) //DtoC(Date() + SC8->C8_PRAZO + 1)
		
		::PedCom:cObsComp	:= AllTrim(SC7->C7_XOBS2)				
		::PedCom:cObsApr	:= AllTrim(SC7->C7_XOBS)		

		::PedCom:cNumCot	 := SC7->C7_NUMCOT
		::PedCom:cStatus	 := GetSta("PC",cXUser,SC7->C7_NUM, SC7->C7_FILIAL) //AllTrim(Posicione("SCR",2,xFilial("SCR")+"PC"+AllTrim(SC7->C7_NUM)+Space(TamSX3("CR_NUM")[1]-Len(AllTrim(SC7->C7_NUM)))+cXUser,"CR_STATUS"))  
		
		::PedCom:cCC 		:= SC7->C7_CC

		::PedCom:cCO 		:= SC7->C7_XCO
		::PedCom:cdescco 	:= AllTrim(Posicione("AK5",1,xFilial("AK5")+AllTrim(SC7->C7_XCO),"AK5_DESCRI"))  

		::PedCom:cDescCC 	:= AllTrim(Posicione('CTT', 1, SubSTR(cXFil,1,2)+"  " + AllTrim(SC7->C7_CC), 'CTT_DESC01'))

		SE4->(DbSetOrder(1))
		If SE4->(DbSeek(xFilial('SE4') + SC7->C7_COND))
			::PedCom:cCondPag	 := SE4->E4_CODIGO + ' - ' + AllTrim(SE4->E4_DESCRI)
		EndIf
	    
		DbSelectArea("SY1")
		SY1->(DbSetOrder(3))
		If SY1->(DbSeek(SubSTR(cXFil,1,2)+"  " + SC7->C7_USER))
			If !Empty(SY1->Y1_XRESP)
				SY1->(DbSetOrder(1))
				If SY1->(DbSeek(SubSTR(cXFil,1,2)+"  " + SY1->Y1_XRESP))
					::PedCom:cComprador	:= SY1->Y1_COD + ' - ' + AllTrim(SY1->Y1_NOME)
				EndIf
			Else
				::PedCom:cComprador	:=  SY1->Y1_COD + ' - ' + AllTrim(SY1->Y1_NOME)
			EndIf
		Else
			::PedCom:cComprador	:= ""
		EndIf
	
	
		//::PedCom:Aprovs		As stArrayAprov
		
		SCR->(DbGoTop())
		SCR->(DbSetOrder(1))
		lNAchou := .T. 
		If SCR->(DbSeek(cXFil + 'PC' + SC7->C7_NUM))			
			While !SCR->(Eof()) .And. (cxFil + 'PC' + cXPed == SCR->CR_FILIAL + SCR->CR_TIPO + AllTrim(SCR->CR_NUM))
				If !Empty(SCR->CR_DATALIB) .AND. SCR->CR_STATUS == '03'
					aAdd(::PedCom:Aprovs:ListAprov, WSClassNew("Aprov"))    				
					//nApr++
					SAK->(DbSetOrder(1))
					SAK->(DbSeek(cXFil + SCR->CR_APROV))
					cXOBS := AllTrim(SCR->CR_OBS) //NoAcento(AllTrim(SC7->C7_OBS))				
                    lNAchou := .F.
                    
					::PedCom:Aprovs:ListAprov[Len(::PedCom:Aprovs:ListAprov)]:cAprovador := SAK->AK_COD
					::PedCom:Aprovs:ListAprov[Len(::PedCom:Aprovs:ListAprov)]:cNome := AllTrim(SAK->AK_NOME)
					::PedCom:Aprovs:ListAprov[Len(::PedCom:Aprovs:ListAprov)]:cStatus := If((AllTrim(SCR->CR_STATUS) $ '03|05'), 'LIBERADO', 'REJEITADO') 
					::PedCom:Aprovs:ListAprov[Len(::PedCom:Aprovs:ListAprov)]:cDtLib := DtoS(SCR->CR_DATALIB) 
					::PedCom:Aprovs:ListAprov[Len(::PedCom:Aprovs:ListAprov)]:cObsLib := cXobs 
					
				EndIf
				SCR->(DbSkip())
			End
		Else
			aAdd(::PedCom:Aprovs:ListAprov, WSClassNew("Aprov"))
			::PedCom:Aprovs:ListAprov[Len(::PedCom:Aprovs:ListAprov)]:cAprovador := ""
			::PedCom:Aprovs:ListAprov[Len(::PedCom:Aprovs:ListAprov)]:cNome := ""
			::PedCom:Aprovs:ListAprov[Len(::PedCom:Aprovs:ListAprov)]:cStatus := "" 
			::PedCom:Aprovs:ListAprov[Len(::PedCom:Aprovs:ListAprov)]:cDtLib := ""
			::PedCom:Aprovs:ListAprov[Len(::PedCom:Aprovs:ListAprov)]:cObsLib := ""			
		EndIf
		
		If lNachou       
	        aAdd(::PedCom:Aprovs:ListAprov, WSClassNew("Aprov")) 
			::PedCom:Aprovs:ListAprov[Len(::PedCom:Aprovs:ListAprov)]:cAprovador := ""
			::PedCom:Aprovs:ListAprov[Len(::PedCom:Aprovs:ListAprov)]:cNome := ""
			::PedCom:Aprovs:ListAprov[Len(::PedCom:Aprovs:ListAprov)]:cStatus := "" 
			::PedCom:Aprovs:ListAprov[Len(::PedCom:Aprovs:ListAprov)]:cDtLib := "" 
			::PedCom:Aprovs:ListAprov[Len(::PedCom:Aprovs:ListAprov)]:cObsLib := ""
	    Endif
		//::PedCom:cStatus	:= (cAlias)->CR_STATUS

		//::PedCom:Itens		As StArrayItem	
		If (Select('WFITENS') > 0)
			WFITENS->(DbCloseArea())
		EndIf
		cQry := ' SELECT * '
		cQry += ' FROM ' + RetSQLName('SC7') + ' SC7 '
		cQry += " WHERE SC7.C7_NUM = '" + AllTrim(cXPed) + "' "
		cQry += " AND SC7.C7_FILIAL = '" + cXFil + "' "
		cQry += " AND SC7.D_E_L_E_T_ = ' '"

		TcQuery cQry New ALIAS 'WFITENS'
		WFITENS->(DbGoTop())
		
		lNAchou := .T. 
		While WFITENS->(!Eof())     
		
			lNAchou := .F. 
			aAdd(::PedCom:Itens:ListItemPC, WSClassNew("ItemPC"))  

			::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:cItem := WFITENS->C7_ITEM
			::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:cCodProd := WFITENS->C7_PRODUTO
			::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:cDesc := AllTrim(WFITENS->C7_DESCRI)
			::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:cUM :=  WFITENS->C7_UM
			::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:nQtd := WFITENS->C7_QUANT    
			::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:nPrcUn := WFITENS->C7_PRECO
			::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:nDesc := WFITENS->C7_VLDESC
			::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:nTotal := WFITENS->C7_TOTAL
		
			nTot += WFITENS->C7_TOTAL	
 
	
			If (Select('WFULTCMP') > 0)
				WFULTCMP->(DbCloseArea())
			EndIf
			cQry := 'SELECT D1A.D1_VUNIT, D1A.D1_EMISSAO '
			cQry += 'FROM ' + RetSQLName('SD1') + ' D1A '
			cQry += "WHERE D1A.D1_COD = '" + AllTrim(WFITENS->C7_PRODUTO) + "' "
			cQry += "AND D1A.D1_TIPO = 'N' "
			cQry += 'AND D1A.D1_EMISSAO = (SELECT MAX(D1B.D1_EMISSAO) '
			cQry += 'FROM ' + RetSQLName('SD1') + ' D1B '
			cQry += "WHERE D1B.D1_COD = '" + AllTrim(WFITENS->C7_PRODUTO) + "' "
			cQry += "AND D1B.D1_TIPO = 'N' "
			cQry += "AND D1B.D_E_L_E_T_ = ' ') "
			cQry += "AND D1A.D_E_L_E_T_ = ' ' "
			TCQuery cQry New ALIAS 'WFULTCMP'
			WFULTCMP->(DbGoTop())
			If !WFULTCMP->(Eof())
				::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:nTUltCom := WFULTCMP->D1_VUNIT
				::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:cDtUlCom := WFULTCMP->D1_EMISSAO
			Else	
				::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:nTUltCom := 0
				::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:cDtUlCom := ""
			EndIf
	        
			WFULTCMP->(DbCloseArea())
		
			WFITENS->(DbSkip())
		End
		WFITENS->(DbCloseArea())

        If lNAchou
			aAdd(::PedCom:Itens:ListItemPC, WSClassNew("ItemPC"))  

			::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:cItem := ""
			::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:cCodProd := ""
			::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:cDesc := ""
			::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:cUM :=  ""
			::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:nQtd := 0    
			::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:nPrcUn := 0
			::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:nDesc := 0
			::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:nTotal := 0
			::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:nTUltCom := 0
			::PedCom:Itens:ListItemPC[Len(::PedCom:Itens:ListItemPC)]:cDtUlCom := ""			
		Endif

		::PedCom:nTotal 	:= nTot
        

		If (Select('WFTOTAPR') > 0)
			WFTOTAPR->(DbCloseArea())
		EndIf
		cQry := 'SELECT DISTINCT SCR.CR_NUM, SCR.CR_TOTAL '
		cQry += 'FROM ' + RetSQLName('SCR') + ' SCR '
		cQry += 'WHERE RTRIM(LTRIM(SCR.CR_NUM)) IN(SELECT C7_NUM '
		cQry += 'FROM ' + RetSQLName('SC7') + ' SC7 '
		cQry += "WHERE SC7.C7_CC = '" + AllTrim(SC7->C7_CC) + "' "
		cQry += "AND SC7.C7_FILIAL = '" + cXFil + "' "
		cQry += "AND SC7.C7_EMISSAO BETWEEN '" + DtoS(FirstDay(SC7->C7_EMISSAO)) + "' AND '" + DtoS(LastDay(SC7->C7_EMISSAO)) + "' "
		cQry += "AND SC7.D_E_L_E_T_ = ' ') "
		cQry += "AND SCR.CR_DATALIB = '' "
		cQry += "AND SCR.CR_TIPO = 'PC' "
		cQry += "AND SCR.D_E_L_E_T_ = '' "
		TcQuery cQry New ALIAS 'WFTOTAPR'
		WFTOTAPR->(DbGoTop())
		
		While WFTOTAPR->(!Eof())
			nTotAprv += WFTOTAPR->CR_TOTAL
			WFTOTAPR->(DbSkip())
		End
		WFTOTAPR->(DbCloseArea())
	
		::PedCom:nValAcu 	:= nTotAprv
	
    Endif
		
Return .T.


//Aprova ou rejeita o pedido de compra em analise
WsMethod AprPedCom WsReceive ListPCAP WsSend cReturn WsService CENTRAPR           

	//Local cBufAux := AllTrim(cReceb)
	Local nContCol := 1
	Local nTotAprv := 0
	Local nTot := 0
	Local lNAchou
	Local cMen := ""
	Local n_x := 0 

   	aVet := ::ListPCAP:ListPCAP
   	u_xConOut("********************** AprPedCom *****************************")
    u_xConOut("Len(aVet) =>  " + cvaltochar(Len(aVet)))
    For n_x := 1 to Len(aVet)
    
		cXFil   := aVet[n_x]:CFil 
		cXPed   := aVet[n_x]:CNumPc 
		cXUser  := aVet[n_x]:CUser 
		cXOp  	:= AllTrim(aVet[n_x]:CStatus)  
		cXObs  	:= aVet[n_x]:CObs
		u_xConOut("cXFil =>" 	+ cXFil)
		u_xConOut("cXPed =>" 	+ cXPed)
		u_xConOut("cXUser =>" 	+ cXUser)
		u_xConOut("cXOp =>" 	+ cXOp)
		u_xConOut("cXObs =>" 	+ cXObs)
		cUsrCtr := cXUser		
		
		dbSelectArea("SC7")
		dbSetOrder(1)
		If dbSeek(cXfil+cXPed)
			cMen += " - achei c7 - "
			u_xConOut("cMen => " + cMen)
			cGrupo := SC7->C7_APROV
			
			cCodComp := SC7->C7_USER 
			PswOrder(1)
			PswSeek(cCodComp,.T.)	
			aUser := PswRet( 1 )	
			cNomeComp := aUser[1][4]
			
			DbSelectArea("SCR")
			DbSetOrder(2)
			If DbSeek(cXFil+'PC'+cXPed+Space((TamSX3('CR_NUM')[1] - TamSX3('C7_NUM')[1])) +cXUser)
				cMen += " - achei cr - "
				u_xConOut("cMen => " + cMen)			
				nTotal := SCR->CR_TOTAL
				cUsrCtr := SCR->CR_USER
				
				cNivAtu := SCR->CR_NIVEL
				aAreaSCR := SCR->(GetArea())
				cUserLib := SCR->CR_USER                               
				cUserApr := SCR->CR_APROV

				DbSelectArea("SCR")
				DbSetOrder(1)
				If DbSeek(cXFil+'PC'+cXPed+Space((TamSX3('CR_NUM')[1] - TamSX3('C7_NUM')[1])) +cNivAtu)							
					While !SCR->(Eof()) .And. (AllTrim(SCR->CR_NUM) == cXPed )
                        
						If cXOp=='1'
							If (SCR->CR_STATUS == '02') .And. (SCR->CR_NIVEL == cNivAtu) .AND. SCR->CR_USER <> cXUser
								SCR->(RecLock('SCR', .F.))
								SCR->CR_STATUS	:= "05"
								SCR->CR_DATALIB := Date()
								SCR->CR_USERLIB := cUserLib //SCR->CR_USER
								//SCR->CR_LIBAPRO := SCR->CR_APROV
								SCR->CR_OBS := "Lib Auto Nivel"
								SCR->(MsUnLock())
							ElseIf (SCR->CR_STATUS == '02') .And. (SCR->CR_NIVEL == cNivAtu) .AND. SCR->CR_USER == cXUser
								SCR->(RecLock('SCR', .F.))
								SCR->CR_STATUS	:= "03"
								SCR->CR_DATALIB := Date()   
								SCR->CR_USERLIB := cUserLib //SCR->CR_USER
								SCR->CR_LIBAPRO := SCR->CR_APROV
								SCR->CR_OBS := alltrim(cXObs)
								SCR->(MsUnLock())
							ElseIf (Val(SCR->CR_NIVEL) == Val(cNivAtu)+1)
								SCR->(RecLock('SCR', .F.))
								SCR->CR_STATUS := '02'
								SCR->(MsUnLock())                     

								PswOrder(1)
								PswSeek(SCR->CR_USER,.T.)	
								aUser := PswRet( 1 )	
								cNome := aUser[1][4]
								u_xConOut("vai chamar envio de email => U_WFEnvMsg(7,cxFil,SCR->CR_USER,cXPed,{AllTrim(aUser[1, 14]), SCR->CR_APROV, AllTrim(cNome), SCR->CR_USER})")
								//U_WFEnvMsg(7,cxFil,SCR->CR_USER,cXPed,{AllTrim("fabio.regueira@portonovosa.com"), SCR->CR_APROV, AllTrim(cNome), SCR->CR_USER})
								U_WFEnvMsg(7,cxFil,SCR->CR_USER,cXPed,{AllTrim(aUser[1, 14]), SCR->CR_APROV, AllTrim(cNome), SCR->CR_USER})
								
								//Enviar email aguardando aprovaÁ„o Ranking
							EndIf
							
						Else		
							If 	(SCR->CR_STATUS == '02' .And. SCR->CR_NIVEL == cNivAtu .AND. SCR->CR_USER <> cXUser) .or. SCR->CR_NIVEL > cNivAtu
								SCR->(RecLock('SCR', .F.))
								SCR->CR_STATUS	:= "05"
								SCR->CR_DATALIB := Date()
								SCR->CR_USERLIB := cUserLib //SCR->CR_USER
								//SCR->CR_LIBAPRO := SCR->CR_APROV
								SCR->CR_OBS := "Rej Auto Nivel"
								SCR->(MsUnLock())
							ElseIf (SCR->CR_STATUS == '02') .And. (SCR->CR_NIVEL == cNivAtu) .AND. SCR->CR_USER == cXUser
								SCR->(RecLock('SCR', .F.))
								SCR->CR_STATUS	:= "06" //Rejeitado
								SCR->CR_DATALIB := Date()   
								SCR->CR_USERLIB := cUserLib //SCR->CR_USER
								SCR->CR_LIBAPRO := SCR->CR_APROV
								SCR->CR_OBS := alltrim(cXObs)
								SCR->(MsUnLock())
						
							Endif
                    
							//Enviar email rejeiÁ„o PC
						Endif
						SCR->(DbSkip())

					EndDo                             
					
				Endif
				RestArea(aAreaSCR)

										        
				/*				
		 			[1] [1] N˙mero do documento
	                [1][2] Tipo de Documento 
	                [1][3] Valor do Documento 
	                [1][4] CÛdigo do Aprovador
	                [1][5] CÛdigo do Usu·rio
	                [1][6] Grupo do Aprovador
	                [1][7] Aprovador Superior
	                [1][8] Moeda do Documento
	                [1][9] Taxa da Moeda 
	                [1][10] Data de Emiss„o do Documento
	                [1][11] Grupo de Compras          
	     		*/
			
				If IsFullLib(cXFil+"PC"+cxped)
					DbSelectArea("SC7")
					DbSetOrder(1)
					If DbSeek(cXFil+padr(alltrim(cxped),tamsx3("C7_NUM")[1]))
			
						While SC7->(!Eof()) .And. (SC7->C7_FILIAL+alltrim(SC7->C7_NUM) == cXFil+alltrim(cxped)) //.AND. cXOp=='1'
							Reclock("SC7",.F.)
							If cXOp=='1'
								SC7->C7_CONAPRO := "L"
							Else
								SC7->C7_CONAPRO := "R"
							Endif
							MsUnlock()
							DbSelectArea("SC7")
							DbSkip()
						EndDo						
                                                                             
                        DbSeek(cXFil+padr(alltrim(cxped),tamsx3("C7_NUM")[1]))
                        
						cXCod := ""
						DbSelectArea("SY1")
						SY1->(DbSetOrder(3))
						If SY1->(DbSeek(SubSTR(cXFil,1,2)+"  " + SC7->C7_USER))
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
						EndIf				

						PswOrder(1)
						PswSeek(cxcod,.T.)	
						aUser := PswRet( 1 )
						cNome := aUser[1][4]	
						If ( aUser[1,14] <> " " )  
							//U_WFEnvMsg(Iif(cXOp<>'1',3,1),cxFil,cXCod,cXPed,{"","", AllTrim(cNome), ""})
							U_WFEnvMsg(Iif(cXOp<>'1',3,1),cxFil,cXCod,cXPed,{AllTrim(aUser[1, 14]),"", AllTrim(cNome), cxcod})
						EndIf                                          
						
						cxcod	:= ""						
						DbSelectArea("SC1")
						SC1->(DbSetOrder(1))
						If SC1->(DbSeek(cXFil + SC7->C7_NUMSC))
																					
							DbSelectArea("SY1")
							SY1->(DbSetOrder(3))
							If SY1->(DbSeek(SubSTR(cXFil,1,2)+"  " + SC1->C1_USER))
								If !Empty(SY1->Y1_XRESP)
									SY1->(DbSetOrder(1))
									If SY1->(DbSeek(SubSTR(cXFil,1,2)+"  " + SY1->Y1_XRESP))
										cxcod	:= SY1->Y1_USER //SY1->Y1_COD
									EndIf
								Else
									cxcod	:=  SY1->Y1_USER //SY1->Y1_COD 
								EndIf
							Endif

							PswOrder(1)
							PswSeek(cxcod,.T.)	
							aUser := PswRet( 1 )
							cNome := aUser[1][4]	
							If ( aUser[1,14] <> " " )       
								//{AllTrim(aUser[1, 14]), SAK->AK_COD, AllTrim(SAK->AK_NOME), SAK->AK_USER})		  					
								U_WFEnvMsg(Iif(cXOp<>'1',4,2),cxFil,cXCod,cXPed,{AllTrim(aUser[1, 14]),"", AllTrim(cNome), cxcod})
							EndIf                                          						

						Endif	                                 
						
					Endif
					
				Endif
			
				//u_xConOut('Ainda tem niveis a liberar')
	
			Endif
					    
		Endif
	Next n_x                                                                           
	
::cReturn := "OK" //cMen+""	
		
Return .T.


Static Function IsFullLib(cKey)

Local lRet := .F.
Local cAlias2 := GetNextAlias()

cQuery := "SELECT " + CRLF
cQuery += "     CR_FILIAL, CR_NUM,  CR_STATUS " + CRLF
cQuery += "FROM " + CRLF
cQuery += "    " + RetSqlName("SCR") + " SCR " 
cQuery += "WHERE " + CRLF
cQuery += "    CR_FILIAL+CR_TIPO+CR_NUM = '" + cKey + "' AND " + CRLF
cQuery += "    CR_STATUS IN ('02') AND " + CRLF   
cQuery += "    D_E_L_E_T_ = '' " + CRLF
						
DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cAlias2, .F., .T.)

DbSelectArea(cAlias2)
(cAlias2)->(DbGoTop())     
If (cAlias2)->(Eof())
	lRet := .T.                                 
Endif
(cAlias2)->(DbCloseArea())                                 

Return lRet


Static Function GetSta(cXTipo,cXUser,cXNum, cXFil)
local cRet := ""
cAlias2 := GetNextAlias()

	cQuery := "SELECT " + CRLF
	cQuery += "    CR_STATUS " + CRLF
	cQuery += "FROM " + CRLF
	cQuery += "    " + RetSqlName("SCR") + " SCR " 
	cQuery += "WHERE " + CRLF
	cQuery += "    CR_TIPO = '"+cXTipo+"' AND " + CRLF
	cQuery += "    CR_USER = '"+cXUser+"' AND " + CRLF
	cQuery += "    CR_NUM = '"+cXNum+"' AND "
	cQuery += "    SCR.D_E_L_E_T_ = ' ' AND CR_FILIAL = '"+cXFil+"' " 
		
	DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cAlias2, .F., .T.)
	DbSelectArea(cAlias2)
	(cAlias2)->(DbGoTop())     
	If (cAlias2)->(!Eof())                                 
    	cRet := (cAlias2)->CR_STATUS
	Endif
(cAlias2)->(DbCloseArea())                                 
Return cRet
