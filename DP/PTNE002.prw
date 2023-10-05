#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"               
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#include 'ap5mail.ch' 
#include 'fwprintsetup.ch'  
#INCLUDE "RPTDEF.CH"         
#Include "ParmType.ch"
#include "colors.ch"      

#DEFINE CRLF chr(13)+chr(10)

#xtranslate bSetGet(<uVar>) => {|u| If(PCount()== 0, <uVar>,<uVar> := u)}

/* 
Metodo: PTNE002 Desenvolvido por: Vinicius Figueiredo - Doit - 20140130       1293

Funções para envio de avisos do RH 
*/       

************************
User Function PTNE002(aX)
************************
local n_z := 0
Local x := 0
Private cMailSmtp  := ""
Private cMailConta := ""
Private cMailSenha := ""
Private cDests := ""
Private aTo := {}, aCodUser := {}                                                                                          
Private aArea := GetArea()
Private xFil := ""   
Private aXParam := aX

/*
If (aXParam[1] <> NiL .AND. !Empty(aXParam[1]))
	aFils := {cFilant}
Else
	aFils := {"0101","0201"}
Endif
*/
aXParam := {nIl}
aFils := {"0101"}

cMailSmtp  := GetMv("MV_RELSERV")
cMailConta := GetMv("MV_RELACNT")  // alteração fabio 01/02/2021 - office 365
cMailSenha := GetMv("MV_RELPSW")   // alteração fabio 01/02/2021 - office 365   

for n_z := 1 to Len(aFils)

	xFil := aFils[n_z]
	u_xConout('OI 20170130 '+xFil)      
	If aXParam[1] == NiL .OR. Empty(aXParam[1])
		Prepare Environment Empresa "01" Filial xFil
    Endif
	//cMailConta := GetNewPar("MV_XRELRH","avisorh@portonovosa.com") // GetMv("MV_RELACNT")
	//cMailSenha := GetNewPar("MV_XRELRH","lNUoxMHauhn4TLx0Jrzb") //GetMv("MV_RELPSW")   // //        
	//cDests := GetNewPar("MV_XPTNE02","000073;000131")  // Inserido Felipe do Nascimento 07/10/2015       
	//cDests := GetNewPar("MV_XPTNE02","000073;000067")    // Fábio Flores / Leonardo Freire       
    // ******* Fabio 02/08/2016 ******
    cDests := GetNewPar("MV_XPTNE02")  //"000227" 
    //********************************     
       
	If !(MailSmtpOn(cMailSmtp, cMailConta, cMailSenha))
		MsgStop("Erro na conexão de e-mail !!!" + MailGetErr())
		Return
	Endif

	//If !(MailAuth(cMailConta,cMailSenha))
		//MsgStop("Erro na Autenticação do Email!!!" + MailGetErr())
		//Return
	//Endif
	
	/* BLOCO INICIO inserido Felipe do Nascimeto - Esvaziar a lista de e-mail destinatários 07/10/2015
	   Incidente ocorrendo duplicidade de envio do e-mail */
	
	aCodUser := aTo := {}
	aCodUser := separa(cDests, ";")
	
	for x := 1 to len(aCodUser)
	    
	    cCodX := allTrim(aCodUser[x])
	    
		PswOrder(1) 
		PswSeek(cCodX,.t.)
		aUser := PswRet(1)
		
		if ! aUser[1, 17]  // verifica se usuário bloqueado
		   cmail := Alltrim(aUser[1,14]) //email do usuario
		   cUser := Alltrim(aUser[1,4] ) //Usuario
		
		   If !Empty(cMail)
		      aAdd(aTo,cMail)
		   Endif	
		   
		endif
		
	next x
	
	// BLOCO FIM
	
	/* BLOCO INICIO retirado Felipe do Nascimento 
	cDestAux := cDests
	While !Empty(cDestAux)
		nP := AT(";",cDestAux)
	
		If nP <> 0                                
			cCodX := 	SubSTR(cDestAux,1,nP-1)
			//aAdd(aTo,SubSTR(cDestAux,1,nP-1))
			cDestAux := SubSTR(cDestAux,nP+1)
		Else
			//aAdd(aTo,SubSTR(cDestAux,1))
			cCodX := 	SubSTR(cDestAux,1)
			cDestAux := ""
		Endif             
		
		PswOrder(1) 
		PswSeek(cCodX,.t.)
		aUser := PswRet(1)
		cmail := Alltrim(aUser[1,14]) //email do usuario
		cUser := Alltrim(aUser[1,4] ) //Usuario
		
		If !Empty(cMail)
			aAdd(aTo,cMail)
		Endif	
	EndDo
	
	BLOCO FIM */
	
	
	/*	
	Processa({|| fFerias()    } , "Analisando Registros de Férias ...") 
	//Processa({|| fContrat1()  } , "Analisando Contratos 45 Dias   ...") 
	Processa({|| fContrat2()  } , "Analisando Contratos 90 Dias   ...") 
	*/
    
	
   	fFerias() 
	
	//fContrat1()        829 a 832

	fContrat2()	
	
	fODEP() 
	 
	                                                                 
	MailSmtpOff()
	If aXParam[1] == NiL
		//Reset Environment
	Endif	                                                                 
	u_xConout('OI FUNCIONOU OI '+xFil)     
	
Next n_z
RestArea(aArea)

Return


*************************
Static Function fFerias()
*************************
//Local a_Area := GetArea()
local x := 0
Local i := 0

  SRA->(DbSetOrder(1)) 
  aDias   := StrToArray(GetNewPar("MV_XDIAFER","90"),";")
  aFerias := {}
	If (aXParam[1] <> NiL .AND. !Empty(aXParam[1]))
		aDias := {"1"}
	Endif
  For X:=1 To Len(aDias)
           
      dDataVer := dDataBase+(Val(AllTrim(Replace(aDias[X],'"',''))))       
      /* 
      DbSelectArea("SRF")
      cIndice := Criatrab(,.F.)
      cFiltro := " (RF_FILIAL = '"+xFil+"' .AND. Dtos(RF_DATAINI)='"+Dtos(dDataVer)+"') "
      IndRegua("SRF",cIndice,SRF->(IndexKey(1)),,cFiltro,"Selecionando Registros...")      
      
      While SRF->(!Eof())
            SRA->(DbSeek(SRF->RF_FILIAL+SRF->RF_MAT)) 
            
            IF SRA->RA_SITFOLH <> 'D'           
               Aadd(aFerias,{SRA->(Recno()),SRF->(Recno()),aDias[I]})  
            ENDIF
               
            SRF->(DbSkip())                         
      End                            
      */
	cQry := ' SELECT SRA.R_E_C_N_O_ RARECNO, SRF.R_E_C_N_O_   RFRECNO , RA_CC ,RA_FILIAL, RA_XRESCC   FROM '+ RetSQLName('SRA')+' SRA,'+ RetSQLName('SRF') +' SRF '
	cQry += ' WHERE ' 
	If X == Len(aDias) .AND. (aXParam[1] <> NiL .AND. !Empty(aXParam[1]))
		cQry += " RF_FILIAL = '"+xFilial("SRF")+"' "
		cQry += " AND( RA_MAT BETWEEN '"+aXParam[1][1]+"' AND '"+aXParam[1][2]+"' " //MATRICULA
		cQry += " AND RA_CC BETWEEN '"+aXParam[1][3]+"' AND '"+aXParam[1][4]+"'  " //CC
		cQry += " AND RF_DATAINI BETWEEN '"+aXParam[1][5]+"' AND '"+aXParam[1][6]+"' ) " //DATA
	Else
		cQry += " RF_FILIAL = '"+xFil+"' "
		cQry += " AND RF_DATAINI = '"+Dtos(dDataVer)+"' "		
	Endif
	cQry += " AND RA_FILIAL = RF_FILIAL "
	cQry += " AND RA_MAT = RF_MAT "
	cQry += " AND RA_SITFOLH <> 'D' "
	cQry += " AND SRA.D_E_L_E_T_ = '' AND SRF.D_E_L_E_T_ = '' "
	cQry += " ORDER BY RA_FILIAL, RA_XRESCC, RA_MAT  "
	
	if select('FUNCS') > 0; FUNCS->(dbCloseArea()); endif
	TcQuery cQry New ALIAS 'FUNCS'
	FUNCS->(DbGoTop())
    /*cXCC := "" -- Retirado por Felipe do Nascimento 27/06/2016                                        
    cXFi := "" */
    aXTo := aClone(aTo)
    
	cXCC := FUNCS->RA_XRESCC
	cXFi := FUNCS->RA_FILIAL
	
	While FUNCS->(!Eof())     
	  /*	If Empty(cXCC)   -- Retirado por Felipe do Nascimento 27/06/2016                          
			cXCC := FUNCS->RA_XRESCC
			cXFi := FUNCS->RA_FILIAL
		Endif */

		Aadd(aFerias,{FUNCS->RARECNO , FUNCS->RFRECNO , aDias[X]})  
		FUNCS->(DbSkip())     
	
//		If cXCC <> FUNCS->RA_XRESCC	.AND. Len(aFerias) > 0      -- Retirado por Felipe do Nascimento 27/06/2016
		If (cXFi+cXCC <> FUNCS->RA_FILIAL+FUNCS->RA_XRESCC ) .or. (FUNCS->(eof()) .and. Len(aFerias) > 0)     

			cXGer := cXCC   // FUNCS->RA_XRESCC  //Posicione("CTT",1,cXFi+cXCC,"CTT_XRESCC")
			PswOrder(1) 
			PswSeek(cXGer,.t.)
			aUser := PswRet(1)
			
			if ! aUser[1, 17]  // verifica se usuário bloqueado
			   cmail := Alltrim(aUser[1,14]) //email do usuario
			   cUser := Alltrim(aUser[1,4] ) //Usuario
			   //cmail := "eduardo.dasilva@portonovosa.com"			
			   If !Empty(cMail)
			      aAdd(aXTo,cMail)
			   Endif	                            
			
			// *********Fabio - 03/08/2016 ***********   
			   cUser := "Caro Gestor " + allTrim(cUser) + ", "
			else 
			   cUser := "Gestor não informado." 
			endif		
            
            // *********Fabio - 03/08/2016 ***********   
			/*
		    if empty(cUser)
		       cUser := "Gestor não informado"
		    else
		       cUser := "Caro Gestor " + allTrim(cUser) + ", "
		    endif                                   
		    */
		    
			oHtml:= TWFHTML():NEW("\html\RH\FERIAS.HTM")
			If oHtml:ExistField(1,"VAR.TITULO") ; oHTML:ValByName("VAR.TITULO","RELAÇÃO DE FÉRIAS") ; Endif
			If oHtml:ExistField(1,"RAGESTOR")   ; oHtml:ValByName("RAGESTOR"     , cUser) ;  Endif				
			
			cxFil := ""
			For I:=1 To Len(aFerias)
				SRA->(DbGoTo(aFerias[I,1]))
				SRF->(DbGoTo(aFerias[I,2]))
				
				cArea    := Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01")
				cCargo   := Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")
				cPeriodo := DTOC(SRF->RF_DATABAS)+"  "+DTOC(SRF->RF_DATABAS+365)
				
				If oHtml:ExistField(1,"MVDIAS")     ; oHtml:ValByName("MVDIAS"     , AllTrim(aFerias[I,3])                        ) ;  Endif				
				If oHtml:ExistField(2,"VAR.AREA")      ; Aadd(oHtml:valByName("VAR.AREA")      , AllTrim(SRA->RA_CC)+" - "+cArea          )  ;  Endif
				If oHtml:ExistField(2,"VAR.MATRICULA") ; Aadd(oHtml:valByName("VAR.MATRICULA") , SRA->RA_MAT    )  ;  Endif
				If oHtml:ExistField(2,"VAR.NOME")      ; Aadd(oHtml:valByName("VAR.NOME")      , SRA->RA_NOME   )  ;  Endif
				If oHtml:ExistField(2,"VAR.CARGO")     ; Aadd(oHtml:valByName("VAR.CARGO")     , cCargo         )  ;  Endif
				If oHtml:ExistField(2,"VAR.AQUISICAO") ; Aadd(oHtml:valByName("VAR.AQUISICAO") , cPeriodo       )  ;  Endif
				If oHtml:ExistField(2,"VAR.GOZO")      ; Aadd(oHtml:valByName("VAR.GOZO")      , SRF->RF_DATAINI)  ;  Endif
			    
			    // ******* Fabio 02/08/2016 ******     
				//If oHtml:ExistField(2,"VAR.13ANT")     ; Aadd(oHtml:valByName("VAR.13ANT")     , Iif( SRF->RF_DABPRO1 <> 0,"Sim","Não"))  ;  Endif
				//If oHtml:ExistField(2,"VAR.ABONO")     ; Aadd(oHtml:valByName("VAR.ABONO")     , Iif( SRF->RF_PERC13S <> 0,"Sim","Não"))  ;  Endif
				If oHtml:ExistField(2,"VAR.13ANT")     ; Aadd(oHtml:valByName("VAR.13ANT")     , Iif( SRF->RF_PERC13S <> 0,"Sim","Não"))  ;  Endif
				If oHtml:ExistField(2,"VAR.ABONO")     ; Aadd(oHtml:valByName("VAR.ABONO")     , Iif( SRF->RF_DABPRO1 <> 0,"Sim","Não"))  ;  Endif
                // *******************************            

				cxFil := SRA->RA_FILIAL
			Next
			
			cTime := Time()
			cNewFile := "\html\RH\FERIAS\FERIAS_"+DToS(Date())+SUBSTR(cTime, 1, 2)+SUBSTR(cTime, 4, 2)+SUBSTR(cTime, 7, 2)+".HTM"
			oHTML:SaveFile(cNewFile)
			
			cFrom    := cMailConta
			aCC      := {}
			aBcc     := {}
			cAssunto := "Sistema Totvs - Aviso de Férias"
			cTexto   := MemoRead(cNewFile)
			aFiles   := {"\html\RH\Logos\"+SubSTR(cxfil,1,2)+"\PTN_logo.jpg"}
			
			If !(MailSend(cFrom,aXTo,aCc,aBcc,cAssunto,cTexto,aFiles,.T.))
				Msgstop("Erro no envio do e-mail!! - " + MailGetErr())
			EndIf 
			      
			aFerias := {}       
			aXTo := aClone(aTo)
			cXCC := FUNCS->RA_XRESCC           
			cXFi := FUNCS->RA_FILIAL
			//cXResCC := FUNCS->RA_XRESCC  -- Retirado por Felipe do Nascimento 27/06/2016         
				
		Endif                            
	      
/*		Aadd(aFerias,{FUNCS->RARECNO , FUNCS->RFRECNO , aDias[X]})   -- Retirado por Felipe do Nascimento 27/06/2016
		cXFi :=  FUNCS->RA_FILIAL 
		     
		FUNCS->(DbSkip())     */
	EndDo
	FUNCS->(DbCloseArea())     
  
/* BLOCO INICIO excluido Felipe do Nascimeto - 27/06/2016
*/
  
/*	If Len(aFerias) > 0     

		cXGer := cXCC //Posicione("CTT",1,cXFi+cXCC,"CTT_XRESCC")
		PswOrder(1) 
		PswSeek(cXGer,.t.)
		aUser := PswRet(1)
		
		if ! aUser[1, 17]  // verifica se usuário bloqueado
		   cmail := Alltrim(aUser[1,14]) //email do usuario
		   cUser := Alltrim(aUser[1,4] ) //Usuario
		   //cmail := "eduardo.dasilva@portonovosa.com"			
		   If !Empty(cMail)
		      aAdd(aXTo,cMail)
		   Endif				   
		endif		
	
		oHtml:= TWFHTML():NEW("\html\RH\FERIAS.HTM")
		If oHtml:ExistField(1,"VAR.TITULO") ; oHTML:ValByName("VAR.TITULO","RELAÇÃO DE FÉRIAS") ; Endif
		
		cxFil := ""
		For I:=1 To Len(aFerias)
			SRA->(DbGoTo(aFerias[I,1]))
			SRF->(DbGoTo(aFerias[I,2]))
			
			cArea    := Posicione("CTT",1,xFilial("CTT")+SRA->RA_CC,"CTT_DESC01")
			cCargo   := Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")
			cPeriodo := DTOC(SRF->RF_DATABAS)+"  "+DTOC(SRF->RF_DATABAS+365)
			
			If oHtml:ExistField(1,"MVDIAS")     ; oHtml:ValByName("MVDIAS"     , AllTrim(aFerias[I,3])                        ) ;  Endif				
			If oHtml:ExistField(2,"VAR.AREA")      ; Aadd(oHtml:valByName("VAR.AREA")      , AllTrim(SRA->RA_CC)+" - "+cArea          )  ;  Endif
			If oHtml:ExistField(2,"VAR.MATRICULA") ; Aadd(oHtml:valByName("VAR.MATRICULA") , SRA->RA_MAT    )  ;  Endif
			If oHtml:ExistField(2,"VAR.NOME")      ; Aadd(oHtml:valByName("VAR.NOME")      , SRA->RA_NOME   )  ;  Endif
			If oHtml:ExistField(2,"VAR.CARGO")     ; Aadd(oHtml:valByName("VAR.CARGO")     , cCargo         )  ;  Endif
			If oHtml:ExistField(2,"VAR.AQUISICAO") ; Aadd(oHtml:valByName("VAR.AQUISICAO") , cPeriodo       )  ;  Endif
			If oHtml:ExistField(2,"VAR.GOZO")      ; Aadd(oHtml:valByName("VAR.GOZO")      , SRF->RF_DATAINI)  ;  Endif
			cxFil := SRA->RA_FILIAL
		Next
		
		cTime := Time()
		cNewFile := "\html\RH\FERIAS\FERIAS_"+DToS(Date())+SUBSTR(cTime, 1, 2)+SUBSTR(cTime, 4, 2)+SUBSTR(cTime, 7, 2)+".HTM"
		oHTML:SaveFile(cNewFile)
		
		cFrom    := cMailConta
		aCC      := {}
		aBcc     := {}
		cAssunto := "Sistema Totvs - Aviso de Férias"
		cTexto   := MemoRead(cNewFile)
		aFiles   := {"\html\RH\Logos\"+SubSTR(cxfil,1,2)+"\PTN_logo.jpg"}
		
		If !(MailSend(cFrom,aXTo,aCc,aBcc,cAssunto,cTexto,aFiles,.T.))
			Msgstop("Erro no envio do e-mail!! - " + MailGetErr())
		EndIf
		      
		aFerias := {}       
		aXTo := aTo
					
	Endif                            
/* BLOCO FIM excluido Felipe do Nascimeto - 27/06/2016
*/
	  
  Next  
  
/*  SRF->(DbClearFilter())  Retirado por Felipe do Nascimento 27/06/2016
   RetIndex("SRA") 
   RetIndex("SRF") */

//  RestArea(a_Area)

Return


  
***************************
Static Function fContrat1()
***************************
Local a_Area := GetArea()  
Local I := 0
     
  SRA->(DbSetOrder(1)) 
  aDias     := StrToArray(GetNewPar("MV_XDIACON","20"),";")
  aContrat1 := {}
  For I:=1 To Len(aDias)
      dDataVer := dDataBase+Val(aDias[I])
      DbSelectArea("SRA")
      cIndice := Criatrab(,.F.)
      cFiltro := "( RA_FILIAL = '"+XFil+"' .AND. Dtos(RA_VCTOEXP)='"+Dtos(dDataVer)+"' )"
      IndRegua("SRA",cIndice,SRA->(IndexKey(1)),,cFiltro,"Selecionando Registros...")      
      
      While SRA->(!Eof())           
            Aadd(aContrat1,{SRA->(Recno())})
            SRA->(DbSkip())
      End
  Next   
  
  If Len(aContrat1) > 0     
  
     For I:=1 To Len(aContrat1)    
         SRA->(DbGoTo(aContrat1[I,1]))
         oHtml:= TWFHTML():NEW("\html\RH\CONTRAT1.HTM")     
                                              
         If oHtml:ExistField(1,"RA_VCTOEXP") ; oHtml:ValByName("RA_VCTOEXP" , Dtoc(SRA->RA_VCTOEXP)              ) ;  Endif   
         If oHtml:ExistField(1,"RA_NOME")    ; oHtml:ValByName("RA_NOME"    , Capital(Alltrim(SRA->RA_NOME))     ) ;  Endif   
         If oHtml:ExistField(1,"RA_MAT")     ; oHtml:ValByName("RA_MAT"     , SRA->RA_MAT                        ) ;  Endif  

		 cTime := Time()     
	     cNewFile  := "\html\RH\CONTRATO45\CONTRAT1_"+AllTrim(SRA->RA_MAT)+"_"+DToS(Date())+SUBSTR(cTime, 1, 2)+SUBSTR(cTime, 4, 2)+SUBSTR(cTime, 7, 2)+".HTM"
	     oHtml:SaveFile(cNewFile) 
	
	     cFrom    := cMailConta
	
	     aCC      := {}
	     aBcc     := {}
	     cAssunto := "Sistema Totvs - Aviso de Vencimento de Contrato 45"
	     cTexto   := MemoRead(cNewFile)
	     //aFiles   := {"\html\RH\Logos\"+SubSTR(SRA->RA_FILIAL,1,2)+"\PTN_logo.jpg"}
		 aFiles   := {"\html\RH\Logos\"+SubSTR(xFil,1,2)+"\PTN_logo.jpg"}	     
	     
	     If !(MailSend(cFrom,aTo,aCc,aBcc,cAssunto,cTexto,aFiles,.T.))
	        Msgstop("Erro no envio do e-mail!! - " + MailGetErr())
	     EndIf
	     	
     Next                      

  Endif                 
  
  SRA->(DbClearFilter())  
  RetIndex("SRA") 
  RetIndex("SRF")
RestArea(a_Area)
Return      



***************************
Static Function fContrat2()
***************************
//Local a_Area := GetArea()
Local I := 0
Local X := 0
  SRA->(DbSetOrder(1))    
  cDias := GetNewPar("MV_XDIACON","60")
  aDias     := StrToArray(cDias,";")
  
  aContrat2 := {}
  For X:=1 To Len(aDias)

      dDataVer := dDataBase+Val(AllTrim(Replace(aDias[X],'"','')))
	/*
      DbSelectArea("SRA")
      cIndice := Criatrab(,.F.)
      //cFiltro := " ( RA_FILIAL = '"+XFil+"' .AND. Dtos(RA_VCTEXP2)='"+Dtos(dDataVer)+"' )"
      cFiltro := " ( RA_FILIAL = '"+XFil+"' .AND. Dtos(RA_VCTOEXP)='"+Dtos(dDataVer)+"' 
      cFiltro += " .AND. RA_CATFUNC = 'M' .AND. (RA_CODFUNC <> '00028' .OR. RA_CODFUNC <> '00097' .OR. RA_CODFUNC <> '00115') )"  // inserido Felipe do Nascimento. Solicitação Demerval Paraiso
                                             // contemplar somente mensalistas (chamado 19145)     
		
      IndRegua("SRA",cIndice,SRA->(IndexKey(1)),,cFiltro,"Selecionando Registros...")      
     
      While SRA->(!Eof())           
            Aadd(aContrat2,{SRA->(Recno()),aDias[I]})
            SRA->(DbSkip())
      End
      */      
      
	cQry := ' SELECT SRA.R_E_C_N_O_ RARECNO, RA_CC ,RA_FILIAL , RA_XRESCC  FROM '+ RetSQLName('SRA')+' SRA '
	cQry += ' WHERE ' 
	cQry += " RA_FILIAL = '"+xFil+"' "
	//cQry += " AND RA_SITFOLH <> 'D' "
	cQry += " AND RA_CATFUNC = 'M' AND RA_CODFUNC NOT IN ('00028','00097','00115')	"
	cQry += " AND (RA_VCTOEXP = '"+Dtos(dDataVer)+"' "
	cQry += " OR RA_VCTEXP2 = '"+Dtos(dDataVer)+"' )"
	cQry += " AND SRA.D_E_L_E_T_ = '' "
	//cQry += " ORDER BY RA_FILIAL, RA_CC, RA_MAT  "
	cQry += " ORDER BY RA_FILIAL, RA_XRESCC, RA_MAT  "

	if select('FUNCS') > 0; FUNCS->(dbCloseArea()); endif
	TcQuery cQry New ALIAS 'FUNCS'
	FUNCS->(DbGoTop())
    /*cXCC := ""  -- Retirado por Felipe do Nascimento 27/06/2016                                                 
    cXFi := "" */
    aXTo := aClone(aTo)

    cXCC := FUNCS->RA_XRESCC
	cXFi := FUNCS->RA_FILIAL
    		
	While FUNCS->(!Eof())     
/*		If Empty(cXCC)     -- Retirado por Felipe do Nascimento 27/06/2016                                 
			cXCC := FUNCS->RA_XRESCC
			cXFi := FUNCS->RA_FILIAL
		Endif */  

		Aadd(aContrat2,{FUNCS->RARECNO , aDias[X]})  
	
	    FUNCS->(DbSkip())     
	    
//	    If cXCC <> FUNCS->RA_XRESCC	.AND. Len(aContrat2) > 0 -- Retirado por Felipe do Nascimento 27/06/2016                                 
		If (cXFi+cXCC <> FUNCS->RA_FILIAL+FUNCS->RA_XRESCC)	.or. (FUNCS->(eof()) .and. Len(aContrat2) > 0)

			cXGer := cXCC  // cXGer := FUNCS->RA_XRESCC //Posicione("CTT",1,cXFi+cXCC,"CTT_XRESCC")
			PswOrder(1) 
			PswSeek(cXGer,.t.)
			aUser := PswRet(1)
			
			if ! aUser[1, 17]  // verifica se usuário bloqueado
			   cmail := Alltrim(aUser[1,14]) //email do usuario
			   cUser := Alltrim(aUser[1,4] ) //Usuario
			   //cmail := "eduardo.dasilva@portonovosa.com"	// retirado 10/12/2019.		 
			   If !Empty(cMail)
			      aAdd(aXTo,cMail)
			   Endif				   
			endif		

			//aXTo := {"marcia.santos@portonovosa.com"}
		    if empty(cUser)
		       cUser := "Gestor não informado"
		    else
		       cUser := "Caro Gestor " + allTrim(cUser) + ", "
		    endif
		
			For I:=1 To Len(aContrat2)
				
				SRA->(DbGoTo(aContrat2[I,1]))
				oHtml:= TWFHTML():NEW("\html\RH\CONTRAT2.HTM")
				
				cCargo   := Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")  // Fabio Flores Regueira 04-09-2014
				
				If oHtml:ExistField(1,"RAGESTOR")   ; oHtml:ValByName("RAGESTOR"     , cUser) ;  Endif				

				cDias    := ""	
				If SRA->RA_VCTOEXP == SRA->RA_ADMISSA+44
					cDias    := "45"					
					If oHtml:ExistField(1,"RA_VCTOEXP") ; oHtml:ValByName("RA_VCTOEXP" , Dtoc(SRA->RA_VCTOEXP)              ) ;  Endif

				ElseIf SRA->RA_VCTEXP2 == SRA->RA_ADMISSA+89
					cDias    := "90"	
					If oHtml:ExistField(1,"RA_VCTOEXP") ; oHtml:ValByName("RA_VCTOEXP" , Dtoc(SRA->RA_VCTEXP2)              ) ;  Endif

				Endif
				If oHtml:ExistField(1,"RA_NOME")    ; oHtml:ValByName("RA_NOME"    , Capital(Alltrim(SRA->RA_NOME))     ) ;  Endif
				If oHtml:ExistField(1,"RA_MAT")     ; oHtml:ValByName("RA_MAT"     , SRA->RA_MAT                        ) ;  Endif
				If oHtml:ExistField(2,"VAR.CARGO")  ; Aadd(oHtml:valByName("VAR.CARGO")     , cCargo                    )  ;  Endif    // Fabio Flores Regueira 04-09-2014
				
				If oHtml:ExistField(1,"MVDIAS")     ; oHtml:ValByName("MVDIAS"     , AllTrim(aContrat2[I,2])                        ) ;  Endif
				
				cTime := Time()
				cNewFile  := "\html\RH\CONTRATO90\CONTRAT2_"+AllTrim(SRA->RA_MAT)+"_"+DToS(Date())+SUBSTR(cTime, 1, 2)+SUBSTR(cTime, 4, 2)+SUBSTR(cTime, 7, 2)+".HTM"
				oHtml:SaveFile(cNewFile)
				
				cFrom    := cMailConta
				
				aCC      := {}
				aBcc     := {}
				cAssunto := "Sistema Totvs - Aviso de Vencimento de Contrato "+cDias+" dias"
				cTexto   := MemoRead(cNewFile)
				//aFiles   := {"\html\RH\Logos\"+SubSTR(SRA->RA_FILIAL,1,2)+"\PTN_logo.jpg"}
				aFiles   := {"\html\RH\Logos\"+SubSTR(xFil,1,2)+"\PTN_logo.jpg"}
				//	     aFiles   := {"\html\PTN_logo"+SRA->RA_FILIAL+".jpg"}
				
				If !(MailSend(cFrom,aXTo,aCc,aBcc,cAssunto,cTexto,aFiles,.T.))
					Msgstop("Erro no envio do e-mail!! - " + MailGetErr())
					alert("ERRO")
				Else
					alert("ENVIEI")
				EndIf 
				
			Next
			
//			aFerias := {}     -- Retirado por Felipe do Nascimento 27/06/2016           
			aContrat2 := {}
			aXTo := aClone(aTo)
			cXCC := FUNCS->RA_XRESCC           
			cXFi := FUNCS->RA_FILIAL                                       
				
		Endif                            

        //Aadd(aContrat2,{SRA->(Recno()),aDias[I]})	      
	/*	Aadd(aContrat2,{FUNCS->RARECNO , aDias[X]})  -- Retirado por Felipe do Nascimento 27/06/2016         
		cXFi :=  FUNCS->RA_FILIAL
		     
		FUNCS->(DbSkip())     */
	EndDo
	FUNCS->(DbCloseArea())       
      
  Next   

/* BLOCO INICIO excluido Felipe do Nascimeto - 27/06/2016
*/
  
/*  If Len(aContrat2) > 0     

	cXGer := cXCC //Posicione("CTT",1,cXFi+cXCC,"CTT_XRESCC")
	PswOrder(1) 
	PswSeek(cXGer,.t.)
	aUser := PswRet(1)
	
	if ! aUser[1, 17]  // verifica se usuário bloqueado
	   cmail := Alltrim(aUser[1,14]) //email do usuario
	   cUser := Alltrim(aUser[1,4] ) //Usuario
	   //cmail := "eduardo.dasilva@portonovosa.com"			
	   If !Empty(cMail)
	      aAdd(aXTo,cMail)
	   Endif				   
	endif		
  
     For I:=1 To Len(aContrat2)    
                  
         SRA->(DbGoTo(aContrat2[I,1]))
         oHtml:= TWFHTML():NEW("\html\RH\CONTRAT2.HTM")     
         
         cCargo   := Posicione("SRJ",1,xFilial("SRJ")+SRA->RA_CODFUNC,"RJ_DESC")  // Fabio Flores Regueira 04-09-2014
                                              
         If oHtml:ExistField(1,"RA_VCTOEXP") ; oHtml:ValByName("RA_VCTOEXP" , Dtoc(SRA->RA_VCTOEXP)              ) ;  Endif   
         If oHtml:ExistField(1,"RA_NOME")    ; oHtml:ValByName("RA_NOME"    , Capital(Alltrim(SRA->RA_NOME))     ) ;  Endif   
         If oHtml:ExistField(1,"RA_MAT")     ; oHtml:ValByName("RA_MAT"     , SRA->RA_MAT                        ) ;  Endif 
         If oHtml:ExistField(2,"VAR.CARGO")  ; Aadd(oHtml:valByName("VAR.CARGO")     , cCargo                    )  ;  Endif    // Fabio Flores Regueira 04-09-2014     

         If oHtml:ExistField(1,"MVDIAS")     ; oHtml:ValByName("MVDIAS"     , AllTrim(aContrat2[I,2])                        ) ;  Endif    
         
		  cTime := Time()     
	     cNewFile  := "\html\RH\CONTRATO90\CONTRAT2_"+AllTrim(SRA->RA_MAT)+"_"+DToS(Date())+SUBSTR(cTime, 1, 2)+SUBSTR(cTime, 4, 2)+SUBSTR(cTime, 7, 2)+".HTM"
	     oHtml:SaveFile(cNewFile) 
	
	     cFrom    := cMailConta
	
	     aCC      := {}
	     aBcc     := {}
	     cAssunto := "Sistema Totvs - Aviso de Vencimento de Contrato 60 dias"
	     cTexto   := MemoRead(cNewFile)
		 aFiles   := {"\html\RH\Logos\"+SubSTR(xFil,1,2)+"\PTN_logo.jpg"}   	     

	     If !(MailSend(cFrom,aXTo,aCc,aBcc,cAssunto,cTexto,aFiles,.T.))
	        Msgstop("Erro no envio do e-mail!! - " + MailGetErr())
	     EndIf
	
     Next                      

  Endif  
  SRA->(DbClearFilter()) 
  RetIndex("SRA") 
  RetIndex("SRF")
*/
/* BLOCO FIM excluido Felipe do Nascimeto - 27/06/2016
*/

  // RestArea(a_Area)
Return          










***************************
Static Function fOdep()
***************************
Local a_Area := GetArea()
Local z:= 0
Local X:= 0
SRA->(DbSetOrder(1))
cDias := GetNewPar("MV_XDIAODE","180")
aDias     := StrToArray(cDias,";")
cList := ""
aTo := {}

For X:=1 To Len(aDias)
	
	dDataVer := dDataBase-Val(AllTrim(Replace(aDias[X],'"','')))
	
	cQry := ' SELECT SRA.R_E_C_N_O_ RARECNO, RA_CC ,RA_FILIAL, RA_MAT, RA_NOME, RA_CODFUNC   FROM '+ RetSQLName('SRA')+' SRA '
	cQry += ' WHERE '
	cQry += " RA_FILIAL = '"+xFil+"' "
//	cQry += " AND RA_CATFUNC = 'M' AND RA_CODFUNC NOT IN ('00028','00097','00115')	"
	cQry += " AND RA_XDTSUSP = '"+Dtos(dDataVer)+"' "   // RA_XINCLUI = 'M'
	cQry += " AND RA_SITFOLH <> 'D' "	
	cQry += " AND SRA.D_E_L_E_T_ = '' "
	cQry += " ORDER BY RA_FILIAL, RA_CC, RA_MAT  "
	
	TcQuery cQry New ALIAS 'FUNCS'
	FUNCS->(DbGoTop())
	cList := ""
		
	While FUNCS->(!Eof())			
			
		cList += "<Br>"+FUNCS->RA_MAT+" - "+AllTrim(FUNCS->RA_NOME)
        
		DbSelectArea("SRA")
		SRA->(DbGoTo(FUNCS->RARECNO))		
		Reclock("SRA",.F.)
		SRA->RA_XDTSUSP := SToD("")
		SRA->RA_XINCLUI := 'I'
		MsUnlock()			
		FUNCS->(DbSkip())
	EndDo
	FUNCS->(DbCloseArea())

	If !Empty(cList) ///Len(aContrat2) > 0	
	
		cDests := GetNewPar("MV_XPTNEOD","000073;000067")    // Fábio Flores / Leonardo Freire       
		aCodUser := separa(cDests, ";")
		
		for z := 1 to len(aCodUser)
		    
		    cCodX := allTrim(aCodUser[z])
		    
			PswOrder(1) 
			PswSeek(cCodX,.t.)
			aUser := PswRet(1)
			
			if ! aUser[1, 17]  // verifica se usuário bloqueado
			   cmail := Alltrim(aUser[1,14]) //email do usuario
			   cUser := Alltrim(aUser[1,4] ) //Usuario
			
			   If !Empty(cMail)
			      aAdd(aTo,cMail)
			   Endif	
			   
			endif
			
		next x
		
	
		oHtml:= TWFHTML():NEW("\html\RH\ODESUSP.HTM")
						
		If oHtml:ExistField(1,"DIAS")     ; oHtml:ValByName("DIAS"     , AllTrim(aDias[x])                        ) ;  Endif
		If oHtml:ExistField(1,"FUNCS")     ; oHtml:ValByName("FUNCS"     , AllTrim(cList)                        ) ;  Endif
		
		cTime := Time()
		cNewFile  := "\html\RH\ODEPREV\ODESUSP_"+DToS(Date())+SUBSTR(cTime, 1, 2)+SUBSTR(cTime, 4, 2)+SUBSTR(cTime, 7, 2)+".HTM"
		oHtml:SaveFile(cNewFile)
		
		cFrom    := cMailConta
		
		aCC      := {}
		aBcc     := {}
		cAssunto := "Sistema Totvs - Aviso de alteração suspensão ODEPREV"
		cTexto   := MemoRead(cNewFile)
		aFiles   := {"\html\RH\Logos\"+SubSTR(xFil,1,2)+"\PTN_logo.jpg"}
		
		If !(MailSend(cFrom,aTo,aCc,aBcc,cAssunto,cTexto,aFiles,.T.))
			Msgstop("Erro no envio do e-mail!! - " + MailGetErr())
		EndIf	                                                                 
		
	Endif
	
	
Next


SRA->(DbClearFilter())
RetIndex("SRA")
RetIndex("SRF")
RestArea(a_Area)
Return

