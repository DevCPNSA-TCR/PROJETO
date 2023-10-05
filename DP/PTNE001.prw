#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"               
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#include 'ap5mail.ch' 
#include 'fwprintsetup.ch'  
#INCLUDE "RPTDEF.CH"        
#Include "ParmType.ch"

#DEFINE CRLF chr(13)+chr(10)

/* 
Metodo: PTNE001 Desenvolvido por: Vinicius Figueiredo - Doit - 20140129

Aviso de data de Fim do contrato por email

*/
User Function PTNE001()

Prepare Environment Empresa "01" Filial "0101"
ThisFunc()
Reset environment

Return

User Function PTNE001a()


ThisFunc()


Return

Static Function ThisFunc()

Private cTpF := ""
Private dDt := ""
Private cMatI := ""
Private cMatF := ""
Private cCCI := ""
Private cCCF := ""
Private cPGT := ""
Private aHtm := {}
Private cpath := ""                
Private aERR := {}
Private cXLog := ""
Private cELog := ""
Private cLastProc := ""
Private nImp := ""
Private nAb := ""
Private aUser     :={}  
Private _cServer  := AllTrim(GetMV("MV_RELSERV")) // 
Private _cUser    := AllTrim(GetMV("MV_RELACNT")) //
Private _cPass    := AllTrim(GetMV("MV_RELPSW")) // 
Private _lAut       := GETMV("MV_RELAUTH") // 
Private _cFrom      := AllTrim(GETMV("MV_RELFROM")) // 
Private nDias      :=  val(Alltrim(GETNewPar("MV_XDIASCT", 90))) //
Private nDias2     :=  val(Alltrim(GETNewPar("MV_XDIACT2", 10))) // 
Private _cTo        := "" //
Private _cCC        := ""                             		// 
Private _cBCC       := ""                            	   // 
Private _cSubject   := "Aviso Encerramento Contrato " //
Private cEmp
private cCNPJ 
Private cyear
Private cMes

Private cUser       := ""
Private aDifs       := {}     

DbSelectArea("SM0")      
DbSetOrder(1)
DbSeek(cEmpAnt+cFilAnt)
xConout("************************************** Envio de email de vencimento de Contratos **************************************")
cEmp := SM0->M0_NOMECOM
cCNPJ := SM0->M0_CGC

CQUERY := " SELECT CN9_FILIAL , CN9_DTFIM , CN9_NUMERO, MAX(CN9_REVISA) CN9_REVISA  , CNN_GRPCOD " + CRLF //, CNN_USRCOD
CQUERY += " FROM "+ RetSQLName("CN9")+ " CN9 ,  "+ RetSQLName("CNN")+ " CNN   " + CRLF		
CQUERY += " WHERE  CN9_FILIAL =  CNN_FILIAL  " + CRLF 
cQuery += "  AND   (CN9_DTFIM <= '"+DToS(DdATABASE+NDIAS)+"' AND CN9_DTFIM >= '"+DToS(dDataBase)+"'  OR " 
cQuery += "        CN9_DTFIM <= '"+DToS(DdATABASE+nDias2)+"' AND CN9_DTFIM >= '"+DToS(dDataBase)+"') " 
cQuery += "  AND   CN9_NUMERO = CNN_CONTRA "  
cQuery += "  AND   CN9_SITUAC = '05' "  
//cQuery += "  AND   CN9_NUMERO IN( '0300/2013' ) " // TESTEES    ( '0499/2013', '0365/2013', '0014/2013' )  
CQUERY += "  AND   CNN_GRPCOD <>  ' '    " + CRLF
CQUERY += "  AND   CN9.D_E_L_E_T_ =  ' '  " + CRLF
CQUERY += "  AND   CNN.D_E_L_E_T_ =  ' '  " + CRLF
CQUERY += "  GROUP BY CN9_FILIAL , CN9_DTFIM , CN9_NUMERO, CNN_GRPCOD  ORDER BY CN9_DTFIM, CN9_NUMERO  " + CRLF      //CNN_USRCOD
Aviso("Query","cQuery = " + cQuery,{"OK"})
TcQuery cQuery Alias "DIF" New

aUsers := FWSFALLUSERS()

While DIF->(!Eof())    

	nDiasF := 0	

/*
	PswOrder(1) 
	PswSeek(DIF->CNN_USRCOD,.t.)
	aUser := PswRet(1)
	cmail := Alltrim(aUser[1,14]) //email do usuario
	cUser := Alltrim(aUser[1,4] )//Usuario
	
	If Empty(cMail)
		DIF->(DbSkip())  	
		Loop
	Endif

	nDiasF := (SToD(DIF->CN9_DTFIM)-ddatabase)//+1
	
	cDiasF := AllTrim(STR(nDiasF ))	
	If SubSTR(cDiasF,Len(cDiasF),1) == "0" //.OR. Len(cDiasF) == 1 Ricardo Ferreira - Retirado o OR para que não envie dia a dia após o 10º dia.
		aAdd(aDifs,{cmail,;
					cuser,; 
					DIF->CN9_FILIAL,;
					AllTrim(DIF->CN9_NUMERO),;
					DIF->CN9_DTFIM			,;
					cDiasF ,;
					DIF->CN9_REVISA			})			
	Endif			
	
	DIF->(DbSkip())  
*/
	*'Yttalo P. Martins-INICIO-02/12/14---------------------------------------------------------------------------------------------------------'*
	*'Envia aviso se faltam 90 dias(MV_XDIASCT) ou 10 dias(MV_XDIACT2) para vencimento do contrato----------------------------------------------'*
	/*
	nDiasF := (SToD(DIF->CN9_DTFIM)-ddatabase)//+1
	
	cDiasF := AllTrim(STR(nDiasF ))	
	
	If SubSTR(cDiasF,Len(cDiasF),1) == "0" //.OR. Len(cDiasF) == 1 Ricardo Ferreira - Retirado o OR para que não envie dia a dia após o 10º dia.
	*/
	nDiasF := (SToD(DIF->CN9_DTFIM)-ddatabase)
	cDiasF := AllTrim(STR(nDiasF ))
	
	If nDiasF == nDias .OR. nDiasF == nDias2
	*'Yttalo P. Martins-FIM-02/12/14------------------------------------------------------------------------------------------------------------'*
	
		for n_x := 1 to Len(aUsers)
			cGrp := ""
			aGrp := aUsers[n_x][1][10]
			If Len(aGrp) > 0
				cGrp := aGrp[1]
				
				If !Empty(cGRP) .AND. AllTrim(cGrp) == AllTrim(CNN_GRPCOD)
			
					cmail := Alltrim(aUsers[n_x][1][14]) //email do usuario
					cUser := Alltrim(aUsers[n_x][1][4] )//Usuario
				
					If Empty(cMail)
						//DIF->(DbSkip())  	
						//Loop
					Else		
						aAdd(aDifs,{cmail,;
									cuser,; 
									DIF->CN9_FILIAL,;
						   			AllTrim(DIF->CN9_NUMERO),;
						   			DIF->CN9_DTFIM			,;
						   			cDiasF ,;
									DIF->CN9_REVISA			})			
					Endif
			
				Endif
			Endif			
		next n_x  
	
	Endif	

	DIF->(DbSkip())  
		
EndDo

DIF->(DbCloseArea())
If Len(aDifs) > 0
	SendIt()
Endif

Return 



Static Function SendIt()
Local cAttach	 
Private cBody := ""

cErrUsr := ""        

for n_x := 1 to Len(aDifs)
	If !Empty(aDifs[n_x][1])                           

		cAttach	  := "\html\PTN_logo"+aDifs[n_x][3]+".jpg"      	
		
		cBody :=" <html>" 
		cBody +=" <head>" 
		cBody +="   <meta content='text/html; charset=ISO-8859-1' http-equiv='content-type'>" 
		cBody +="   <title>"+_cSubject+"</title>" 
		cBody +="  <style type='text/css'> "
		cBody +="<!--"
		cBody +=".style3 {font-size: 16px}"
		cBody +="-->  "
		cBody +="  </style> "
		cBody +=" </head>" 
		cBody +=" <body>"             
		cBody +=" <p align=CENTER> "
		cBody += "<h3>ATENÇÃO !! </h3></br></br>"                             		
		cBody += "O contrato "+aDifs[n_x][4]

		CQUERY := " SELECT DISTINCT CNC_CODIGO , CNC_LOJA   " + CRLF 
		CQUERY += " FROM "+ RetSQLName("CNC")+ " CNC  " + CRLF		
		CQUERY += " WHERE  CNC_FILIAL =  '"+aDifs[n_x][3]+"'  " + CRLF 
		cQuery += "  AND   CNC_NUMERO = '"+aDifs[n_x][4]+"' " 
		CQUERY += "  AND   CNC.D_E_L_E_T_ =  ' '  " + CRLF
		CQUERY += "  ORDER BY CNC_CODIGO " + CRLF
		
		TcQuery cQuery Alias "DIF" New
		If DIF->(!Eof())    		
			cBody += ", fornecedor(es) : </br> "		
		Endif
		While DIF->(!Eof())    		
			cBody += DIF->CNC_CODIGO+" "+DIF->CNC_LOJA+" - "+Alltrim(Posicione("SA2",1,xFilial("SA2")+DIF->CNC_CODIGO+DIF->CNC_LOJA,"A2_NOME"))+"; </br> "
			DIF->(DbSkip())    
		Enddo		
		
		DIF->(DbCloseArea())    		
		
		cBody += " tem previsão de encerramento em "+aDifs[n_x][6]+" dias, com data de encerramento em "+DToC(SToD(aDifs[n_x][5]))+"." 
		cBody += "  </br></br><img src='PTN_Logo"+aDifs[n_x][3]+".jpg'  vspace='0' align='center'></br>"
		cBody +=" </body>" 
		cBody +=" </html>" 	
		
		/*/                                                
		±±³Parametros³ ExpC1 : Conta para conexao com servidor SMTP                 ³±±
		±±³          | ExpC2 : Password da conta para conexao com o servidor SMTP   ³±±
		±±³          ³ ExpC3 : Servidor de SMTP                                    ³±±
		±±³          ³ ExpC4 : Conta de origem do e-mail. O padrao eh a mesma conta ³±±
		±±³          ³        de conexao com o servidor SMTP.                      ³±±
		±±³          ³ ExpC5 : Conta de destino do e-mail.                          ³±±
		±±³          ³ ExpC6 : Assunto do e-mail.                                   ³±±
		±±³          ³ ExpC7 : Corpo da mensagem a ser enviada.                        |±±
		±±³          | ExpC8 : Patch com o arquivo que serah enviado               |±±
		±±³          | ExpC9 : .T. Exibir mensagem de erro, .f. não exibir msg      |±±
		±±³          | ExpC10 : Parâmetro por referência, armazena o erro de envio |±±
		/*/

		/*
		cCt := Replace(aDifs[n_x][4],"/","")			                                             				
		memowrite("D:\testehtml"+alltrim(cCt)+".html",cbody)		
		*/                                                                                 
		
		xACSendMail (_cUser,_cPass,_cServer,_cFrom,aDifs[n_x][1],Replace(_cSubject,"ê","e"),cBody,cAttach,.T.)

							
		
	Endif
							
Next n_x

return


/*/                                                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ xACSendMail³                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina para o envio de emails                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 : Conta para conexao com servidor SMTP                 ³±±
±±³          | ExpC2 : Password da conta para conexao com o servidor SMTP   ³±±
±±³          ³ ExpC3 : Servidor de SMTP                                     ³±±
±±³          ³ ExpC4 : Conta de origem do e-mail. O padrao eh a mesma conta ³±±
±±³          ³         de conexao com o servidor SMTP.                      ³±±
±±³          ³ ExpC5 : Conta de destino do e-mail.                          ³±±
±±³          ³ ExpC6 : Assunto do e-mail.                                   ³±±
±±³          ³ ExpC7 : Corpo da mensagem a ser enviada.               	    |±±
±±³          | ExpC8 : Patch com o arquivo que serah enviado                |±±
±±³          | ExpC9 : .T. Exibir mensagem de erro, .f. não exibir msg      |±±
±±³          | ExpC10 : Parâmetro por referência, armazena o erro de envio  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGAC                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                 

ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function xACSendMail(cAccount,cPassword,cServer,cFrom,cEmail,cAssunto,cMensagem,cAttach,lMsg,cLog)

Local cEmailTo := ""
Local cEmailCc := ""
Local lResult  := .F.
Local cError   := ""
Local cUser
Local nAt
Local cFromGe  := GetNewPar("MV_ACEMAIL", "")	

Default lMsg := .T.                                                                                      
Default cLog := ""

// Verifica se serao utilizados os valores padrao.
cAccount	:= Iif( cAccount  == NIL, GetMV( "MV_RELACNT" ), cAccount  )
cPassword	:= Iif( cPassword == NIL, GetMV( "MV_RELPSW"  ), cPassword )
cServer		:= Iif( cServer   == NIL, GetMV( "MV_RELSERV" ), cServer   )
cAttach 	:= Iif( cAttach == NIL, "", cAttach )
cFrom		:= Iif( cFrom == NIL, Iif( Empty(GetMV( "MV_RELFROM" )), GetMV( "MV_RELACNT" ), GetMV( "MV_RELFROM" ) ), cFrom )  


If  !EMPTY(cFromGe)  
	If Alltrim(cFrom) == Alltrim( GetMV( "MV_RELACNT" ) ) .or. Alltrim(cFrom) == Alltrim( GetMV( "MV_RELFROM" ) ) // verifica se está utilizando o email do parametro global
		cFrom := cFromGe
	EndIf	
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o e-mail para a lista selecionada. Envia como CC                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If At(Chr(59),cEmail) > 0
	cEmailTo := SubStr(cEmail,1,At(Chr(59),cEmail)-1)
	cEmailCc := SubStr(cEmail,At(Chr(59),cEmail)+1,Len(cEmail))
Else
	cEmailTo := cEmail
	cEmailCc := ""
EndIf

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o Servidor de EMAIL necessita de Autenticacao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if lResult .and. GetMv("MV_RELAUTH")
	
	//Primeiro tenta fazer a Autenticacao de E-mail utilizando o e-mail completo
	lResult := MailAuth(cAccount, cPassword)
	//Se nao conseguiu fazer a Autenticacao usando o E-mail completo, tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
	if !lResult
		nAt 	:= At("@",cAccount)
		cUser 	:= If(nAt>0,Subs(cAccount,1,nAt-1),cAccount)
		lResult := MailAuth(cUser, cPassword)
	endif
endif

If lResult
	
	/*SEND MAIL FROM cFrom ;
	TO      	cEmailTo;
	CC     		cEmailCc;
	SUBJECT 	if( GetNewPar("MV_ACEMLAC", "1")$"1", ACTxt2Htm( cAssunto ), cAssunto );
	BODY    	if( GetNewPar("MV_ACEMLAC", "1")$"12", ACTxt2Htm( cMensagem ), cMensagem );
	ATTACHMENT  cAttach  ;
	RESULT lResult*/
	
	SEND MAIL FROM cFrom ;
	TO      	cEmailTo;
	CC     		cEmailCc;
	SUBJECT 	cAssunto;
	BODY    	cMensagem;
	ATTACHMENT  cAttach  ;
	RESULT lResult
	
	
	If !lResult
		//Erro no envio do email
		GET MAIL ERROR cError
		If lMsg
			//Help(" ",1,"ATENCAO",,STR0286 + cEmailTo +" ."+ STR0289,4,5)
		EndIf
		xConout("########## ERRO NO ENVIO DO EMAIL cError=>" + cError)
	//	cLog := STR0286 + cEmailTo 	
	EndIf
	
	DISCONNECT SMTP SERVER
	
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	If lMsg		
		//Help(" ",1,"ATENCAO",,STR0288 +" "+ STR0287+cError,4,5)
	EndIf
	xConout("##########  ERRO NA CONEXÃO cError=>" + cError)
	//cLog := STR0288 +" "+ STR0287+cError	
EndIf

Return(lResult)
