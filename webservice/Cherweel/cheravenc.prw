#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "rwmake.ch"


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao>  : GravaÁ„o Log
<Autor>      : Vinicius Figueiredo Moreira
<Data>       : 16/06/2014
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
User Function CherLog(cTipo, cNum, dData, mLogMemo , cDelin ,cXSta )
//Grava Log de registro
Local cFile := ""
Local cPathLog := ""
Local aArea := GetArea()

chkfile("SZX")
DbSelectArea("SZX")                  
DbSetOrder(1)

Reclock("SZX",.T.)
SZX->ZX_FILIAL 	:= xFilial("SZX")
SZX->ZX_CODINT := cTipo //Float CÛdigo do Tipo da IntegraÁ„o (Tabela GenÈrica)
SZX->ZX_DATA := dData //String Data de GeraÁ„o do Log 
SZX->ZX_HORA := Time() //String Hora de GeraÁ„o do Log

If cTipo == "01" //IntegraÁ„o Cliente
	SZX->ZX_CODCLI := cNum //Float CÛdigo do Cliente no CHERAVENC 
	
ElseIf cTipo == "02" .OR. ; //Autoriza Faturamento
		cTipo == "03" .OR. ;//Altera Vencimento
		cTipo == "04" .OR. ;//RETORNO AF
		cTipo == "05" //Exclus„o faturamento

	SZX->ZX_CODPED := cNum //String CÛdigo do Pedido de Venda do Protheus	
Endif                

If cDelin == NiL
	cDelin := ""
Endif

SZX->ZX_CONTRAT := "" //Float N˙mero do Contrato
SZX->ZX_PERIODO := "" //String DescriÁ„o do PerÌodo de Referencia 

SZX->ZX_DELIN := cDelin //Float N˙mero do Delin 
SZX->ZX_MENSAG := mLogMemo //String Mensagem de Erro           
If cXSta <> NiL .AND. !Empty(cXSta)
	SZX->ZX_STATUS := cXSta
Else
	SZX->ZX_STATUS := Iif((Empty(mLogMemo).OR.mLogMemo==NiL),"Sucesso","Erro") //String Status da IntegraÁ„o (Sucesso, Erro)
Endif
//SZX->ZX_MENSAG := MSMM(,TamSX3("ZZ_LOGM")[1],,mlogmemo,1,,,"SZZ","ZZ_LOGM")

SZX->(MsUnlock())	
SZX->(DbCloseArea())					
RestArea(aArea)	
Return	                                         


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
<Descricao>  : Busca o que invalidou o processo no log padr„o do protheus
<Autor>      : Vinicius Figueiredo Moreira
<Data>       : 02/05/2014                               

Exemplo chamada do metodo:

If lMsErroAuto

	cFile  := "ImpProd_"+alltrim(cIdtCode)+".log"   
	cpath := "\Log_erros\"
	cLog := MostraErro(cpath,cfile)	
	//buscar no TXT qual erro ocorreu e acrescentar ao cErr antes de enviar ao Log 				
	cErr := U_cherErr(cpath+cfile) 				
	
	//ApÛs isso basta chamar a funÁ„o de gravaÁ„o de log
	U_CherLog(cTipo, cNum, dData, cErr )            
	//cTipo cÛdigo do tipo da integraÁ„o
	//cNum  cÛdigo identificador do objeto Ex.: CÛdigo pedido, cÛdigo cliente, etc.
	//dData data que ocorreu a tentativa
	//cErr variavÈl contendo o erro interpretado pela funÁ„o cherErr
	
Endif 

‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
*/
User Function CherErr(cTxt)

Local n_x  := 1
Local cRet := ""
Local cAux := ""

u_xConOut("BUSCANDO ERRO EXECAUTO "+ctxt)
FT_FUSE(cTxt)

FT_FGOTOP()
ProcRegua(FT_FLASTREC())

nContLin := 0
cBufAux := ""  

While !FT_FEOF()

    cBufLin   := TrataLin(FT_FREADLN())
	If nContlIN == 0 
		u_xConOut("LENDO ARQUIVO "+cbuflin)    
		ncontlin++
	Endif
	nAt1 := At("HELP",cBufLin)	
	nAt2 := At("INV¡LIDO",cBufLin)	
	If nAt2 == 0	
		nAt2 := At("INVALIDO",cBufLin)		
	Endif                     
	
	If nAt1 > 0
	    FT_FSKIP()                  	       	
	    cBufLin   := TrataLin(FT_FREADLN())

		While !Empty(cBufLin) .AND. !FT_FEOF()
	
		    cBufLin   := TrataLin(FT_FREADLN())
		
		    If !Empty(cBufLin)
				cRet += Lower(Replace(cBufLin,(CHR(13)+CHR(10))," ")+" ")
			endif
				
		    FT_FSKIP()                  	       	
		    
		EndDo		    

	ElseIf nAt2 > 0		
		cRet += cBufLin
	Endif
	//u_xConOut("CRET "+cRet)

    FT_FSKIP()                  
    
Enddo                                   
u_xConOut(cRet)
FT_FUSE()       
Return cRet     
                                           

Static Function TrataLin(cXLin)
Local cRet := ""

cRet := Upper(AllTrim(replace(cXLin,"	","")))
cRet := replace(cRet,"  ","")

//u_xConOut("CRET "+cRet)

Return  cRet

/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ 
<Descricao> : WebService especÌfico para integraÁ„o dos dados do Protheus e CHERAVENC
<Data> : 16/06/2014
<Processo> : IntegraÁ„o Protheus x CHERAVENC
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹ 
*/  

//*****************************************************    
// Estrutura de alteraÁ„o do vencimento do titulo
//*****************************************************
WsStruct AVenc
	WsData cFil As String //Filial no protheus
	WsData cDelin As String //N˙mero do Delin
	WsData nContrato As Float //N˙mero do Contrato 
	WsData cPedido As String //CÛdigo do Pedido no Protheus
	WsData cVencimento As String //Novo vencimento do tÌtulo
	
	WsData cWsUsuario As String //User autentica
	WsData cWsPassword As String //Senha autentica
				     
EndWsStruct

WsStruct stArrayAVenc
     WsData AVencs As Array Of AVenc
EndWsStruct      
                                      
WsService CHERWELLALTERVENC DESCRIPTION "WebService especÌfico para alterar a data de vencimento do tÌtulo no Protheus" NAMESPACE "http://187.94.60.7:8060/ws/CHERWELLALTERVENC.apw" 

	// AVencs                 
	WsData Avenc As Avenc
	WsData ListAVenc As stArrayAVenc
	WsMethod AltVenc 		Description "Altera a data de vencimento do tÌtulo."    
	//N„o sei se ter· necessidade desse metodo. Caso n„o consiga popular a estrutura utilizando apenas o metodo de alteraÁ„o do vencimento, 
	//esse metodo retorna uma estrutura do tipo esperado vazia para preenchimento
	//WsMethod NovoListAVenc 		Description "retorna um array com o tipo criado para alteraÁ„o de vencimento no protheus para preenchimento."    
	
	WsData lOk As Boolean                     
	WsData cReceb As String
	WsData nQtdRegs As Integer
	WsData cErrorLog As String
	WsData cOS As String
	WsData cTransId As String

EndWsService


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±∫Desc.     ≥Altera a data de vencimento do tÌtulo.        		      ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Retorno.  ≥LÛgico		  											  ∫±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
//WsMethod AltVenc WsReceive ListAVenc WsSend lOk WsService CHERWELLALTERVENC
WsMethod AltVenc WsReceive AVenc WsSend lOK WsService CHERWELLALTERVENC //cFil,nDelin,nContrato,cPedido,cVencimento,cWsUsuario,cWsPassword

    Local cQry     := GetNextAlias()
    Local cQry2    := GetNextAlias() 
	Local cFilSC5  := ""
	Local cBKPFil  := ""
 		
	::lOk := .T.
 
   //	For nX := 1 To Len(::ListAVenc:AVencs)		

	nCDelin := ::Avenc:cdelin //::ListAVenc:AVencs[nX]:nDelin 
	nContra := ::Avenc:ncontrato //::ListAVenc:AVencs[nX]:nContrato
	cPed  := ::Avenc:cpedido //::ListAVenc:AVencs[nX]:cPedido 
	cVenc := ::Avenc:cvencimento //::ListAVenc:AVencs[nX]:cVencimento		
 	cXFil := ::Avenc:cFil //::ListAVenc:AVencs[nX]:cFil //SubSTR(::Avenc:cFil,3,2) //
 	cXEmp := "01" //SubSTR(::Avenc:cFil,1,2) //::ListAVenc:AVencs[nX]:cFil

	cXUser := ::Avenc:cWSusuario //::ListAVenc:AVencs[nX]:cWsUsuario
	cXPsw:=	::Avenc:cWsPassword //::ListAVenc:AVencs[nX]:cWsPassword
    

	cXFil  := PADR(ALLTRIM(cXFil),TAMSX3("C5_FILIAL")[1])
	u_xConOut("cXFil: " + cXFil )

	If Empty(nCdelin)
			::lOk := .F.
			cSta := "Erro"				
			cErr := "CÛdigo delin n„o informado"
			
			u_xConOut("Erro - CÛdigo delin n„o informado" )
	
	ElseIf Empty(cPed)
			::lOk := .F.
			cSta := "Erro"				
			cErr := "CÛdigo pedido Protheus n„o informado"
			
			u_xConOut("Erro - CÛdigo pedido Protheus n„o informado" )
	
	ElseIf Empty(cVenc)	
			::lOk := .F.
			cSta := "Erro"				
			cErr := "Vencimento a ser alterado n„o informado"
            
			u_xConOut("Erro - Vencimento a ser alterado n„o informado" )

	ElseIf AllTrim(cXUser) == "Cherwell" .And. AllTrim(cXPsw) == "123456"
	    
		Prepare Environment Empresa cxEmp Filial cXFil
		
		u_xConOut("cFilant: " + cFilant )
		cFilSC5 := xFilial("SC5")
		u_xConOut("xFilial(SC5): " + cFilSC5 )
		
		cBKPFil  := cFilant
		cFilant  := cXFil
		
		u_xConOut("cFilant: " + cFilant )
		cFilSC5 := xFilial("SC5")
		u_xConOut("xFilial(SC5): " + cFilSC5 )
		
		dbSelectArea("SM0")
		SM0->(dbGotop())
		If SM0->(dbseek(cxEmp+cXFil))
			u_xConOut("Achou empresa: " + cEmpant +" Filial: "+cFilant )
		Else
			u_xConOut("No Achou empresa: " + cEmpant +" Filial: "+cFilant )
		EndIf
		

		cQuery := " SELECT DISTINCT E1.R_E_C_N_O_ RECN FROM " + CRLF 
		cQuery += " "+RetSqlName("SE1")+" E1 ,"+RetSqlName("SF2")+" F2, "+RetSqlName("SD2")+" D2, "+ RetSqlName("SC5") + " C5 " + CRLF 
		cQuery += " WHERE C5_FILIAL = '"+cXFil+"'" + CRLF 
		cQuery += " AND C5_FILIAL = D2_FILIAL" + CRLF 
		cQuery += " AND D2_FILIAL = F2_FILIAL" + CRLF 
		cQuery += " AND E1_FILIAL = D2_FILIAL" + CRLF 
		cQuery += " AND C5_XDELIN = '"+nCDelin+"' " + CRLF 
		cQuery += " AND C5_NUM = '"+ALLTRIM(cPed)+"' " + CRLF 
		cQuery += " AND D2_PEDIDO = C5_NUM " + CRLF 
		cQuery += " AND D2_SERIE+D2_DOC = F2_SERIE+F2_DOC" + CRLF 
		cQuery += " AND E1_PREFIXO+E1_NUM = F2_SERIE+F2_DOC " + CRLF 
		cQuery += " AND E1.D_E_L_E_T_ = ' '" + CRLF 
		cQuery += " AND F2.D_E_L_E_T_ = ' '" + CRLF 
		cQuery += " AND D2.D_E_L_E_T_ = ' '" + CRLF 
		cQuery += " AND C5.D_E_L_E_T_ = ' '" + CRLF 
		//u_xConOut(cquery)				
		DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cQry, .F., .T.)
		DbSelectArea(cQry)
		(cQry)->(DbGoTop())  
		If (cQry)->(!Eof())  
			While (cQry)->(!Eof())                    
			
				DbSelectArea("SE1")
				DbGoto((cQry)->RECN)

				RecLock("SE1",.F.)
				cOldVenc := SE1->E1_VENCREA
				SE1->E1_VENCTO  := DataValida(SToD(cVenc))
				SE1->E1_VENCREA  := DataValida(SToD(cVenc))
				SE1->E1_XVENORI := cOldVenc
				SE1->E1_XALTVEN := dDataBase
				SE1->E1_XCHERWE := .T.
				
				MsUnlock()  
				cSta := "Sucesso"                
				cErr := ""

				U_CherLog("03", cPed, dDatabase, "Vencimento alterado" , ALLTRIM(nCDelin) ,"Sucesso" )            

				(cQry)->(DbSkip())		
			EndDo
			
			u_xConOut("Vencimento do(s) tÌtulo(s) alterado(s) para o PV: "+ALLTRIM(cPed) )
		//----------------------------------------------------------------------------------
		//Se ainda n„o faturou nota, e portanto, n„o existe tÌtulo, alterar vencimento no PV
		//Yttalo P. Martins - 05/11/14------------------------------------------------------
		//----------------------------------------------------------------------------------
		Else

			cQuery := " SELECT DISTINCT C5.R_E_C_N_O_ RECN FROM " + CRLF 
			cQuery += " "+RetSqlName("SC5") + " C5 " + CRLF 
			cQuery += " WHERE C5_FILIAL = '"+cFilSC5+"'" + CRLF 
			cQuery += " AND C5_XDELIN = '"+nCDelin+"' " + CRLF 
			cQuery += " AND C5_NUM = '"+ALLTRIM(cPed)+"' " + CRLF 
			cQuery += " AND (C5_NOTA = ' ' AND C5_BLQ = ' ') " + CRLF		
			cQuery += " AND C5.D_E_L_E_T_ = ' '" + CRLF
			
			DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cQry2, .F., .T.)
			DbSelectArea(cQry2)
			(cQry2)->(DbGoTop())  
			If (cQry2)->(!Eof())
			
				DbSelectArea("SC5")
				DbGoto((cQry2)->RECN)
				
				RecLock("SC5",.F.)
					SC5->C5_DATA1  := DataValida(SToD(cVenc))
				MsUnlock()
				  
				cSta := "Sucesso"                
				cErr := ""

				U_CherLog("03", cPed, dDatabase, "Vencimento alterado" , ALLTRIM(nCDelin) ,"Sucesso" )											
			    
				u_xConOut("Vencimento alterado para o PV: "+ALLTRIM(cPed) )
			Else
		
				::lOk := .F.
				cSta := "Erro"				
				cErr := "N„o encontrado"			
		        
				u_xConOut("Vencimento n„o alterado. N„o encontrado tÌtulo ou pedido: "+ALLTRIM(cPed)+" j· faturado. " )
		
			EndIf
			
			(cQry2)->(DbCloseArea())  		 

		Endif					        
        
		cFilant := cBKPFil

		(cQry)->(DbCloseArea())       
	Else                
		::lOk := .F.
		cSta := "Erro"				
		cErr := "N„o autenticado "+cXUser+" "+cXPSW				
	Endif			 

	If !Empty(cErr)
		U_CherLog("03", cPed, dDatabase, cErr , ALLTRIM(nCDelin)  )            	
	Endif			
	
   //	Next

Return .T.
                                                                      
/*
WsMethod NovoListAVenc WsReceive nQtdRegs WsSend ListAVenc WsService CHERWELLALTERVENC
 
	Local nX := 0
	
	For nX := 1 to ::nQtdRegs                                             
	    	
		aAdd(::ListAVenc:AVencs, WSClassNew("AVenc"))        
		::ListAVenc:AVencs[nX]:cFil := ""
		::ListAVenc:AVencs[nX]:nDelin := 0
		::ListAVenc:AVencs[nX]:nContrato := 0
		::ListAVenc:AVencs[nX]:cPedido := ""
		::ListAVenc:AVencs[nX]:cVencimento := ""
		
	 Next nX
	 	
Return .T.
*/
//http://187.94.60.7:8035/ws/CHERWELLALTERVENC.apw?WSDL
//http://187.94.60.223:7008/ws/CHERWELLALTERVENC.apw?WSDL - teste

