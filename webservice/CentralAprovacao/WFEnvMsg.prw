#Include 'totvs.ch'
#Include 'rwmake.ch'
#Include 'topconn.ch'
#Include 'tbiconn.ch'
#Include 'tbicode.ch'
#Include 'ap5mail.ch'
#Include 'fileio.ch'
#INCLUDE "PROTHEUS.CH"

/*/
*****************************************************************************************************
*** Programa: WFENVMSG   -   Autor: Leonardo Pereira   -   Data:                                  ***
*** Descricao: Faz o envio do email para o comprador e o solicitante                              ***
*****************************************************************************************************
/*/
User Function WFEnvMsg(nOpc,cxFil,cXUser,cXPed,aXMail)

	Local nDias := 0, nHoras := 0, nMinutos := 10
	Local cCodStatus, cHtmlModelo
	Local cUsuarioWF, cTexto
	Local cTitulo := If((nOpc <= 4), 'Aprovacao do pedido de compra', 'Ranking da cotacao')+Iif((SubStr(cXFil, 1, 2) == '01')," - CPN"," - TCR")
	Local lAmbProd := (Upper(AllTrim(GetEnvServer())) $ AllTrim(GetMV('MV_XAMBIENT')))    

	Private lRetMail := .F.

	//Private cHost := Iif(AT("_WS",Upper(AllTrim(GetEnvServer())))==0.AND.!Empty(cHost) ,cHost,'')
	cHost :=""
	If Empty(cHost)
		If lAmbProd 
			cHost := 'http://centraldeaprovacao.portonovosa.com/portalcompras/' //'http://compras.portonovosa.com.br/workflow/'
		Else
			cHost := 'https://centraldeaprovacao.portonovosa.com/portalcomprashomolog/' 
			//cHost := 'https://centraldeaprovacao.portonovosa.com/portalcomprasteste/'
		EndIf
	Endif
	
	cHost := AllTrim(GetNewPar('MV_XHOSWSPC',cHost))
	
	
	//Enquanto valida na teste
	//cHost := 'https://centraldeaprovacao.portonovosa.com/portalcomprasteste/'
	/* Ric */ 
	//return 
	/* Ric */ 
	If nOpc < 7
		/*/ C?digo extra?do do cadastro de processos. /*/
		cCodProcesso := 'ENVMSG'

		/*/ Assunto da mensagem /*/
		cAssunto := cTitulo

		/*/ Arquivo html template utilizado para montagem da aprova??o 	
		1 //O pedido de compras No. !WNumPed!, foi liberado!
		2 //O pedido de compras No. !WNumPed!, referente a sua solicitacao de compras No. !WNumSol!, foi liberado!
		3 //O pedido de compras No. !WNumPed!, foi rejeitado!
		4 //O pedido de compras No. !WNumPed!, referente a sua solicitacao de compras No. !WNumSol!, foi rejeitado!
		5 //O ranking do mapa de cotacoes No. !WNumCot!, foi realizado!
		6 //O ranking do mapa de cotacoes No. !WNumCot!, referente a sua solicitacao de compras No. !WNumSol!, foi realizado!	
		/*/
		If (nOpc == 1) //O pedido de compras No. !WNumPed!, foi liberado!
			//			cHtmlModelo := If((SubStr(cxFil, 1, 2) == '01'), '\workflow\modelos\WFPedCom01.htm' , '\workflow\modelos\WFPedCom02.htm')
			cHtmlModelo := '\workflow\modelos\WFPedCom.htm'
		ElseIf (nOpc == 2) //O pedido de compras No. !WNumPed!, referente a sua solicitacao de compras No. !WNumSol!, foi liberado!
			//			cHtmlModelo := If((SubStr(cxFil, 1, 2) == '01'), '\workflow\modelos\WFPedSol01.htm' , '\workflow\modelos\WFPedSol02.htm') 
			cHtmlModelo := '\workflow\modelos\WFPedSol.htm' 
		ElseIf (nOpc == 3) //O pedido de compras No. !WNumPed!, foi rejeitado!
			//			cHtmlModelo := If((SubStr(cxFil, 1, 2) == '01'), '\workflow\modelos\WFPedRCom01.htm' , '\workflow\modelos\WFPedRCom02.htm')
			cHtmlModelo := '\workflow\modelos\WFPedRCom.htm'
		ElseIf (nOpc == 4) //O pedido de compras No. !WNumPed!, referente a sua solicitacao de compras No. !WNumSol!, foi rejeitado!
			//			cHtmlModelo := If((SubStr(cxFil, 1, 2) == '01'), '\workflow\modelos\WFPedRSol01.htm' , '\workflow\modelos\WFPedRSol02.htm')
			cHtmlModelo := '\workflow\modelos\WFPedRSol.htm'
		ElseIf (nOpc == 5) //O ranking do mapa de cotacoes No. !WNumCot!, foi realizado!
			//			cHtmlModelo := If((SubStr(cxFil, 1, 2) == '01'), '\workflow\modelos\WFCotCom01.htm' , '\workflow\modelos\WFCotCom02.htm')
			cHtmlModelo := '\workflow\modelos\WFCotCom.htm'
		ElseIf (nOpc == 6) //O ranking do mapa de cotacoes No. !WNumCot!, referente a sua solicitacao de compras No. !WNumSol!, foi realizado!
			//			cHtmlModelo := If((SubStr(cxFil, 1, 2) == '01'), '\workflow\modelos\WFCotSol01.htm' , '\workflow\modelos\WFCotSol02.htm')
			cHtmlModelo := '\workflow\modelos\WFCotSol.htm'
		EndIf

		PswOrder(1)
		PswSeek(cXUser,.T.)	
		aInfoUsu := PswRet( 1 )	
		cUsuarioWF := aInfoUsu[1][4]                    
		If Empty(cUsuarioWF)
			cUsuarioWF := aXmail[03]
		Endif
		/*/ Inicialize a classe TWFProcess e assinale a vari?vel objeto oProcess /*/
		//oProcess := TWFProcess():New(cCodProcesso, cAssunto)

		/*/ Cria uma tarefa /*/
		//oProcess:NewTask(cTitulo, cHtmlModelo)

		//cXBuffer := oProcess:oHtml:cbuffer
		cXBuffer := u_PTNLEHTM(cHtmlModelo)
		/*/ Cria um texto que identifique as etapas do processo que foi realizado para futuras consultas na janela de rastreabilidade /*/
		/*
		If (nOpc <= 4)
		cTexto := 'Iniciando o envio de comunicacao do pedido No.: ' + cXPed
		ElseIf (nOpc >= 5)
		cTexto := 'Iniciando o envio de comunicacao de ranking da cotacao No.: ' + cXPed
		EndIf
		cCodStatus := '100100' // C?digo do cadastro de status de processo
		oProcess:Track(cCodStatus, cTexto, cUsuarioWF) // Rastreabilidade*/

		/*/ Adicione informac?es a serem inclu?das na rastreabilidade /
		cTexto := 'Gerando envio de comunica??o...'
		cCodStatus := '100200'
		oProcess:Track(cCodStatus, cTexto, cUsuarioWF)*/

		If (nOpc == 1) .Or. (nOpc == 3) .Or. (nOpc == 5)
			/* Coleta informacoes do usuario - [E-Mail]
			PswOrder(1)
			If (PswSeek(AllTrim(aDadosTXT[1, 8]), .T.))
			aInfoUsu := PswRet(1)
			//ConOut('[' + DtoC(Date()) + '][' + Time() + '] Sucesso ao pesquisar usuario')
			Else
			//ConOut('[' + DtoC(Date()) + '][' + Time() + '] Falha ao pesquisar usuario')
			EndIf
			*/
			//oProcess:oHtml:ValByName('WComprador', Alltrim(cUsuarioWF) )
			cXBuffer := replace(cXBuffer,'!WComprador!', Alltrim(cUsuarioWF) )

			If (nOpc <= 4)
				//oProcess:oHtml:ValByName('WNumPed', cXPed )
				cComp := ""
				DbSelectArea("SC7")
				DbSetOrder(1)
				If DbSeek(cXFil + cXPed )    	
					cComp += " Fornecedor: "+SC7->C7_FORNECE+"/"+SC7->C7_LOJA+" - "+AllTrim(Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME"))
                Endif

				cXBuffer := replace(cXBuffer,'!WNumPed!',cXPed+cComp )
				
			ElseIf (nOpc >= 5)
				//oProcess:oHtml:ValByName('WNumCot', cXPed )
				cXBuffer := replace(cXBuffer,'!WNumCot!',cXPed )
			EndIf


		ElseIf (nOpc == 2) .Or. (nOpc == 4) .Or. (nOpc == 6)
			SC1->(DbGoTop())
			SC1->(DbSetOrder(1))
			SC1->(DbSeek(xFilial('SC1') + If((nOpc == 6), SC8->C8_NUMSC, SC7->C7_NUMSC)))

			/* Coleta informacoes do usuario - [E-Mail]
			PswOrder(1)
			If (PswSeek(AllTrim(SC1->C1_USER), .T.))
			aInfoUsu := PswRet(1)
			//ConOut('[' + DtoC(Date()) + '][' + Time() + '] Sucesso ao pesquisar usuario do solicitante')
			Else
			//ConOut('[' + DtoC(Date()) + '][' + Time() + '] Falha ao pesquisar usuario do solicitante')
			EndIf
			*/

			//oProcess:oHtml:ValByName('WSolicitante', AllTrim(cUsuarioWF))
			cXBuffer := replace(cXBuffer,'!WSolicitante!',Alltrim(cUsuarioWF))
			If (nOpc <= 4)
				//oProcess:oHtml:ValByName('WNumPed', cXPed )
				cXBuffer := replace(cXBuffer,'!WNumPed!',cXPed)
			ElseIf (nOpc >= 5)
				//oProcess:oHtml:ValByName('WNumCot', cXPed )
				cXBuffer := replace(cXBuffer,'!WNumCot!',cXPed)
			EndIf

			nPrazo := 0
			If(nOpc == 6)
				DbSelectArea("SC8")
				DbSetOrder(1)
				DbSeek(cXFil + cXPed )
				cSol := SC8->C8_NUMSC    
				nPrazo := SC8->C8_PRAZO
			Else
				DbSelectArea("SC7")
				DbSetOrder(1)
				DbSeek(cXFil + cXPed )    	
				cSol := SC7->C7_NUMSC
			Endif

			//oProcess:oHtml:ValByName('WNumSol', cSol )
			cXBuffer := replace(cXBuffer,'!WNumSol!',cSol)
			If (nPrazo = 0)
				//oProcess:oHtml:ValByName('WDataEntrega', DtoC(Date() + nPrazo + 1))
				cXBuffer := replace(cXBuffer,'!WDataEntrega!',DtoC(Date() + nPrazo + 1))
			EndIf
		EndIf

		If SubSTR(cXFil,1,2) == '01'
			cIm := '<img src="http://compras.portonovosa.com.br/workflow/img/logoportonovo.png" width="150" height="112" />'
		Else
			cIm := '<img src="http://compras.portonovosa.com.br/workflow/img/logotcr.png" width="237" height="103" />'
		Endif 

		//oProcess:oHtml:ValByName('WImag', cIm )
		cXBuffer := replace(cXBuffer,'!WImag!',cIm)   
		cXBuffer := replace(cXBuffer,'v.11.5','v.12')
		/*/ Repasse o texto do assunto criado para a propriedade espec?fica do processo /*/
		//oProcess:cSubject := cAssunto

		/*/ Informe o endere?o eletr?nico do destinat?rio /*/
		//oProcess:cTo := AllTrim(aInfoUsu[1, 14])   ///"fabio.regueira@portonovosa.com" //
		cTo := AllTrim(aInfoUsu[1, 14])
		/*/ Utilize a funcao WFCodUser para obter o c?digo do usu?rio Protheus /*/
		//oProcess:UserSiga := cXUser //aDadosTXT[1, 8]

		/*/ Informe o nome da fun??o de retorno a ser executada quando a mensagem de respostas retornar ao Workflow /*/
		//oProcess:bReturn := 'U_WFMailPN()'

		/*/ Informe o nome da fun??o do tipo timeout que ser? executada se houver um timeout ocorrido para esse processo. Neste exemplo, ela ser? executada cinco minutos ap?s o envio /*/
		/*/ do e-mail para o destinat?rio. Caso queira-se aumentar ou diminuir o tempo, altere os valores das vari?veis: nDias, nHoras e nMinutos /*/
		//oProcess:bTimeOut := ''

		/*/ Adicione as informac?es a serem inclu?das na rastreabilidade /*/
		/*If (nOpc <= 4)
		cTexto := 'Enviando comunicacao de aprovacao...'
		ElseIf (nOpc >= 5)
		cTexto := 'Enviando comunicacao de ranking...'
		EndIf
		cCodStatus := '100300'
		oProcess:Track(cCodStatus, cTexto , cUsuarioWF)

		WFProcessID := oProcess:fProcessID*/

		/*/ Ap?s ter repassado todas as informac?es necess?rias para o Workflow, execute o m?todo Start() para gerar todo o processo e enviar a mensagem ao destinat?rio /*/
		//oProcess:Start()

		//aFiles   := {"\html\RH\Logos\"+SubSTR(cxFil,1,2)+"\PTN_logo.jpg"} 

		lRetMail := u_Envmail(cTo , cXBuffer , cTitulo ,cXFil)	     

		//If !(MailSend( Trim(GetMV("MV_RELFROM")) ,{{oProcess:cTo}},{},{},cTitulo,cXBuffer,aFiles,.T.))
		//   Msgstop("Erro no envio do e-mail!! - " + MailGetErr())
		//EndIf

		/*/ Adicione as informac?es a serem inclu?das na rastreabilidade /*/
		/*cTexto := 'Enviando comunicacao de Finalizacao...'
		cCodStatus := '100400'
		oProcess:Track(cCodStatus, cTexto , cUsuarioWF) // Rastreabilidade

		oProcess:Finish()*/                                                       

	ElseIf nOpc == 7	
		PedGeraWF(cXFil , cXUser ,  cXped, aXMail)
	ElseIf nOpc == 8
		CotGeraWF(cXFil, cXUser , cXPed ,aXMail )	
	Endif                                                                  
	/*
	If lRetMail
	If nOpc == 5 .Or. nOpc == 6 .Or. nOpc == 8 // COTAÇOES

	Else

	Endif
	Endif	
	*/
Return                



/*
**********************************************************************************************************************************
*** Funcao: PEDGERAWF   -   Autor: Leonardo Pereira   -   Data: 02/12/2010                                                      ***
*** Descricao: Gera formulario HTML para acesso via LINK.                                                                      ***
**********************************************************************************************************************************
*/
Static Function PedGeraWF(cXFil, cXUser , cXPed ,aXMail )

	Local nDias := 0, nHoras := 0, nMinutos := 10
	Local cCodStatus, cHtmlModelo
	Local cUsuarioWF, cTexto
	Local cNumPedWF := CXPed //SC7->C7_NUM
	Local cTitulo 	:= 'Aprovacao do pedido de compra'+Iif((SubStr(cXFil, 1, 2) == '01')," - CPN"," - TCR")
	Local cTo		:= ""
	cAssunto := cTitulo
	IncProc('Enviando email...')

	/*/ Arquivo html template utilizado para montagem da aprova??o /*/
	//	cHtmlModelo := If((SubStr(cXFil, 1, 2) == '01'), '\workflow\modelos\WFPedLink01.htm', '\workflow\modelos\WFPedLink02.htm')
	cHtmlModelo := '\workflow\modelos\WFPedLink.htm'


	/*/ Registra o nome do usu?rio corrente que est? criando o processo: /*/
	PswOrder(1)
	PswSeek(cxUser,.T.)	
	aInfoUsu := PswRet( 1 )	
	/*/ Registra o nome do usu?rio corrente que est? criando o processo: /*/
	cUsuarioWF := aInfoUsu[1][4]
	cCodProcesso := 'APRPED'

	//oProcess := TWFProcess():New(cCodProcesso, cAssunto)

	/*/ Cria uma tarefa /*/
	//oProcess:NewTask(cTitulo, cHtmlModelo)    
	//cXBuffer := oProcess:oHtml:cbuffer

	If SubSTR(cXFil,1,2) == '01'
		cIm := '<img src="http://compras.portonovosa.com.br/workflow/img/logoportonovo.png" width="150" height="112" />'
		//cHtmlModelo := '\workflow\modelos\WFPedLink01.htm'
	Else
		cIm := '<img src="http://compras.portonovosa.com.br/workflow/img/logotcr.png" width="237" height="103" />'
		//cHtmlModelo := '\workflow\modelos\WFPedLink02.htm'
	Endif 

	cXBuffer := u_PTNLEHTM(cHtmlModelo)

	/*/ Cria um texto que identifique as etapas do processo que foi realizado para futuras consultas na janela de rastreabilidade /*/
	//	cTexto := 'Iniciando a solicitacao de ' + cAssunto + ' No.: ' + cXPed
	//	cCodStatus := '100100' // C?digo do cadastro de status de processo
	//	oProcess:Track(cCodStatus, cTexto, cUsuarioWF) // Rastreabilidade

	/*/ Adicione informac?es a serem inclu?das na rastreabilidade /*/
	//	cTexto := 'Gerando solicitacao para aprovacao...'
	//	cCodStatus := '100200'
	//	oProcess:Track(cCodStatus, cTexto, cUsuarioWF)

	//oProcess:oHtml:ValByName('WCod', aXmail[ 02])
	cXBuffer := replace(cXBuffer,'!WCod!',aXmail[ 02])
	//oProcess:oHtml:ValByName('WAprovador', aXmail[ 03])
	cXBuffer := replace(cXBuffer,'!WAprovador!',aXmail[ 03])
	//oProcess:oHtml:ValByName('WNumPed', cXPed)
	cXBuffer := replace(cXBuffer,'!WNumPed!',cXPed)
	//oProcess:oHtml:ValByName('WLink', cHost )
	cXBuffer := replace(cXBuffer,'!WLink!',cHost)
	//oProcess:oHtml:ValByName('WTexto', cHost )
	cXBuffer := replace(cXBuffer,'!Wtexto!',cHost)

	cXBuffer := replace(cXBuffer,'!WImag!',cIm)   
	cXBuffer := replace(cXBuffer,'v.11.5','v.12')

	cTo := aXmail[ 01]


	lRetMail := u_Envmail(cTo , cXBuffer , cTitulo ,cXFil)                                                            


Return




/*
****************************************************************************************************
*** Funcao: COTGERAWF   -   Autor: Leonardo Pereira   -   Data:                                  ***
*** Descricao:                                                                                   ***
****************************************************************************************************
*/
Static Function CotGeraWF(cXFil, cXUser , cXPed ,aXMail ,cXProc )
	Local nDias := 0, nHoras := 0, nMinutos := 10
	Local cCodStatus, cHtmlModelo
	Local cUsuarioWF, cTexto
	Local cNumCotWF := cXPed
	Local cTitulo := 'Ranking da cotacao de compras'+Iif((SubStr(cXFil, 1, 2) == '01')," - CPN"," - TCR")

	cAssunto := cTitulo
	/*/ Arquivo html template utilizado para montagem da aprova??o /*/
	//	cHtmlModelo := If((SubStr(cXFil, 1, 2) == '01'), '\workflow\modelos\WFCotLink01.htm', '\workflow\modelos\WFCotLink02.htm')
	cHtmlModelo :=  '\workflow\modelos\WFCotLink.htm'

	/*/ Registra o nome do usu?rio corrente que est? criando o processo: /*/
	//cUsuarioWF := //If((nExec == 1), SubStr(cUsuario, 7, 15), Lower(aDadosTxt[1, 7]))
	PswOrder(1)
	PswSeek(cxUser,.T.)	
	aInfoUsu := PswRet( 1 )	
	//If (PswSeek(AllTrim(cXUser), .T.))
	//aInfoUsu := PswRet(1)
	//Endif
	/*/ Registra o nome do usu?rio corrente que est? criando o processo: /*/
	cUsuarioWF := aInfoUsu[1][4]
	/*
	If !Empty(cxProc)
	cCodProcesso := cXProc    
	Else    
	cCodProcesso := 'APRCOT'
	Endif

	oProcess := TWFProcess():New(cCodProcesso, cAssunto)
	*/
	/*/ Cria uma tarefa /*/
	//oProcess:NewTask(cTitulo, cHtmlModelo)
	//cXBuffer := oProcess:oHtml:cbuffer
	cXBuffer := u_PTNLEHTM(cHtmlModelo)


	/*/ Cria um texto que identifique as etapas do processo que foi realizado para futuras consultas na janela de rastreabilidade /*/

	//cTexto := 'Iniciando a solicitacao de ' + cAssunto + ' No.: ' + cXPed
	//cEnv := Alltrim(GetEnvServer())
	//If SubSTR(cEnv,Len(cEnv)-2) == "_WS"
	//cCodStatus := '100100' // C?digo do cadastro de status de processo
	//Else
	//	cCodStatus := '000001' // C?digo do cadastro de status de processo	
	//Endif
	//oProcess:Track(cCodStatus, cTexto, cUsuarioWF) // Rastreabilidade


	/*/ Adicione informac?es a serem inclu?das na rastreabilidade /*/
	//cTexto := 'Gerando solicitacao para ranking...'
	//If SubSTR(cEnv,Len(cEnv)-2) == "_WS"
	//cCodStatus := '100200' // C?digo do cadastro de status de processo
	//Else
	//	cCodStatus := '000002' // C?digo do cadastro de status de processo	
	//Endif
	//oProcess:Track(cCodStatus, cTexto, cUsuarioWF)


	//oProcess:oHtml:ValByName('WAprovador', aXmail[03])
	cXBuffer := replace(cXBuffer,'!WAprovador!',aXmail[ 03])
	//oProcess:oHtml:ValByName('WNumCot', cNumCotWF)
	cXBuffer := replace(cXBuffer,'!WNumCot!',cNumCotWF)
	//oProcess:oHtml:ValByName('WLink', cHost )
	cXBuffer := replace(cXBuffer,'!WLink!',cHost)
	//oProcess:oHtml:ValByName('WTexto', cHost )
	cXBuffer := replace(cXBuffer,'!Wtexto!',cHost)   

	If SubSTR(cXFil,1,2) == '01'
		cIm := '<img src="http://compras.portonovosa.com.br/workflow/img/logoportonovo.png" width="150" height="112" />'
	Else
		cIm := '<img src="http://compras.portonovosa.com.br/workflow/img/logotcr.png" width="237" height="103" />'
	Endif 

	//oProcess:oHtml:ValByName('WImag', cIm )
	cXBuffer := replace(cXBuffer,'!WImag!',cIm)   


	/*/ Repasse o texto do assunto criado para a propriedade espec?fica do processo /*/
//	oProcess:cSubject := cAssunto

	/*/ Informe o endere?o eletr?nico do destinat?rio /*/
	//oProcess:cTo := aXmail[ 01]
	cTo :=aXmail[ 01]
	/*/ Utilize a funcao WFCodUser para obter o c?digo do usu?rio Protheus /*/
	//oProcess:UserSiga := cXUser //WFCodUser(cUsuarioWF) //If((nExec == 1), WFCodUser(cUsuarioWF), aDadosTxt[1, 8])

	/*/ Informe o nome da fun??o de retorno a ser executada quando a mensagem de respostas retornar ao Workflow /*/
	//oProcess:bReturn := 'U_WFMCRetPN()'

	/*/ Informe o nome da fun??o do tipo timeout que ser? executada se houver um timeout ocorrido para esse processo. Neste exemplo, ela ser? executada cinco minutos ap?s o envio /*/
	/*/ do e-mail para o destinat?rio. Caso queira-se aumentar ou diminuir o tempo, altere os valores das vari?veis: nDias, nHoras e nMinutos /*/
	//oProcess:bTimeOut := ''

	/*/ Adicione as informac?es a serem inclu?das na rastreabilidade /*/
	//cTexto := 'Enviando solicitacao de ranking...'
	//If SubSTR(cEnv,Len(cEnv)-2) == "_WS"
	//cCodStatus := '100300' // C?digo do cadastro de status de processo
	//Else
	//	cCodStatus := '000003' // C?digo do cadastro de status de processo	
	//Endif
	//oProcess:Track(cCodStatus, cTexto , cUsuarioWF)

	//cCodStatus := '100300'

	//WFProcessID := oProcess:fProcessID

	/*/ Ap?s ter repassado todas as informac?es necess?rias para o Workflow, execute o m?todo Start() para gerar todo o processo e enviar a mensagem ao destinat?rio /*/
	//oProcess:Start()                                     
	//cFrom    := Trim(GetMV("MV_RELFROM"))
	//aCC      := {}
	//aBcc     := {}
	//cTexto   := MemoRead(cNewFile)
	//aTo := {}
	//aAdd(aTo , oProcess:cTo )
	//aFiles   := {"\html\RH\Logos\"+SubSTR(cxFil,1,2)+"\PTN_logo.jpg"} 
	//If !(MailSend( cFrom , aTo,aCC,aBCC,cTitulo,cXBuffer,aFiles,.T.))
	//   Msgstop("Erro no envio do e-mail!! - " + MailGetErr())
	//EndIf

	lRetMail := u_Envmail(cTo , cXBuffer , cTitulo , cXFil )

	/*/ Adicione as informac?es a serem inclu?das na rastreabilidade /*/
	//cTexto := 'Aguarde retorno...'
	//If SubSTR(cEnv,Len(cEnv)-2) == "_WS"
	//cCodStatus := '100400' // C?digo do cadastro de status de processo
	//Else
	//cCodStatus := '000004' // C?digo do cadastro de status de processo	
	//Endif
	//oProcess:Track(cCodStatus, cTexto , cUsuarioWF) // Rastreabilidade	

	//If lRetMail
	SC8->(DbGoTop())
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(xFilial('SC8') + cNumCOTwf))
	While !SC8->(Eof()) .And. (xFilial('SC8') == SC8->C8_FILIAL .And. cNumCOTwf == SC8->C8_NUM)
		SC8->(RecLock('SC8', .F.))
		SC8->C8_WFID := "WFID" //WFProcessID
		SC8->C8_FLAGWF := '1'

		If Empty(SC8->C8_XUSER)
			SC8->C8_XUSER := cXUser			// Codigo do usuario

		Endif
		SC8->C8_XDTENV := dDataBase
		SC8->C8_XHRENV := TIME() //SubStr(TIME(),5)
		SC8->(MsUnLock())
		SC8->(DbSkip())
	End

	SC8->(DbGoTop())
	SC8->(DbSetOrder(1))
	SC8->(DbSeek(xFilial('SC8') + cNumCOTwf))

	SCR->(DbGoTop())
	SCR->(DbSetOrder(2))
	If SCR->(DbSeek(xFilial('SCR') + 'MC' + SC8->C8_NUM + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))))
		While !SCR->(Eof()) .And. (SCR->CR_TIPO == 'MC') .And. (AllTrim(SCR->CR_NUM) == cNumCOTwf)
			//If SCR->(DbSeek(xFilial('SCR') + 'MC' + SC8->C8_NUM + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))+SC8->C8_XUSER))
			//While !SCR->(Eof()) .And. (SCR->CR_TIPO == 'MC') .And. (AllTrim(SCR->CR_NUM) == cNumCOTwf) .AND. (SCR->CR_USER == SC8->C8_XUSER)		
			RecLock('SCR', .F.)
			SCR->CR_WFID := SC8->C8_WFID
			SCR->(MsUnLock())
			SCR->(DbSkip())
		End
	EndIf



	Return

	*-----------------------------------------------------*
User Function Envmail(cXTo , cXMsg , cAssunto , cXFil)
	*-----------------------------------------------------*
	Local nRet		:= 0
	//Local nSendPort := 0, nSendSec := 0, nTimeout := 120
	Local nSendPort := 587, nSendSec := 0, nTimeout := 120  // fabio informei aqui devido a urgencia.
	
	Private aLista  := {}
	Private aDados  := {}

	Private cMSG     := "" //'<html><head><title> WF </title>'+SubSTR(cXMSG,At("<Style ",cXMSG))

	Private cError   	:= ""
	Private cPass    	:= AllTrim(GetMV("MV_RELPSW"))  //"Ot2ygTLgBcHJ"
	Private cAccount	:= AllTrim(GetMV("MV_RELACNT")) //""
	Private cServer  	:= substr(AllTrim(GetMV("MV_RELSERV")),1,18) // 06/02/2021 - Fabio
	Private cFrom    	:= AllTrim(GetMV("MV_RELFROM")) //""
	Private nTimeout 	:= GetMV("MV_RELTIME") //"" timeout
	Private lAuth    	:= GetMV("MV_RELAUTH") //""
	Private lSSL    	:= GetMV("MV_RELSSL ") //""
	Private lTLS    	:= GetMV("MV_RELTLS ") //""
	Private cBody		:= ""

	Private lResult        

	Private oMail := TMailManager():New()

	//Private aFiles   := {}

	dbSelectArea("SX6")                                              

	//cXMSG := ACTxt2Htm(cXMSG)

	cBody  := '<html><head><title> WF </title></head>'+SubSTR(cXMSG,At("<body>",cXMSG))

	u_xConOut("----------- Dados do envio de email ------------" )
	u_xConOut("Servidor.: " + cServer)
	u_xConOut("Conta....: " + cAccount)
	u_xConOut("Senha....: " + cPass)
	u_xConOut("De.......: " + cFrom)
	u_xConOut("Para.....: " + cXTO)
	u_xConOut("----------- Dados do envio de email ------------" )
	/*	
	Alert("----------- Dados do envio de email ------------" + chr(13) + Chr(10) +; 
	"Servidor.: " + cServer + chr(13) + Chr(10)+;
	"Conta....: " + cAccount+ chr(13) + Chr(10)+;
	"Senha....: " + cPass+ chr(13) + Chr(10)+;
	"De.......: " + cFrom+ chr(13) + Chr(10)+;
	"Para.....: " + cXTO+ chr(13) + Chr(10)+;
	"----------- Dados do envio de email ------------" )
	Alert("cXTO => " + cXTO)*/
	/***************************************************/
	oServer := TMailManager():New()
	   
	oServer:SetUseSSL(lSSL)
	oServer:SetUseTLS(lTLS )
	   

	   
	  // once it will only send messages, the receiver server will be passed as ""
	  // and the receive port number won't be passed, once it is optional
	xRet := oServer:Init( "", cServer, cAccount, cPass, , nSendPort )  // 06/02/2021 - Fabio
	//xRet := oServer:Init( "", 'smtp.office365.com', cAccount, cPass, , nSendPort )
	if xRet != 0
		cMsg := "Could not initialize SMTP server: " + oServer:GetErrorString( xRet )
		u_xConOut( cMsg )
		return
	endif
	   
	  // the method set the timout for the SMTP server
	xRet := oServer:SetSMTPTimeout( nTimeout )
	if xRet != 0
		cMsg := "Could not set  timeout to " + cValToChar( nTimeout )
		u_xConOut( cMsg )
		//Alert(cMsg)
	endif
	   
	  // estabilish the connection with the SMTP server
	xRet := oServer:SMTPConnect()
	if xRet <> 0
		cMsg := "Could not connect on SMTP server: " + oServer:GetErrorString( xRet )
		u_xConOut( cMsg )
		//Alert(cMsg)
		return
	endif
	   
	// authenticate on the SMTP server (if needed)
	If lAuth
		xRet := oServer:SmtpAuth( cAccount, cPass )
		if xRet <> 0
			cMsg := "Could not authenticate on SMTP server: " + oServer:GetErrorString( xRet )
			u_xConOut( cMsg )
			oServer:SMTPDisconnect()
			//Alert(cMsg)
			return
		endif
	Endif
	   
	oMessage := TMailMessage():New()
	oMessage:Clear()
	   
	oMessage:cDate := cValToChar( dDataBase)
	oMessage:cFrom := cFrom
	oMessage:cTo := cXTO
	oMessage:cSubject := cAssunto
	oMessage:cBody := cBody
	   
	xRet := oMessage:Send( oServer )
	if xRet <> 0
		cMsg := "Could not send message: " + oServer:GetErrorString( xRet )
		u_xConOut( cMsg )
		//Alert(cMsg)
	Else
		//Alert("Enviou o email")
	endif
	   
	xRet := oServer:SMTPDisconnect()
	if xRet <> 0
		cMsg := "Could not disconnect from SMTP server: " + oServer:GetErrorString( xRet )
		u_xConOut( cMsg )
	endif
Return lResult


User Function PTNLEHTM(cModelHTML)
	Local cBuffer := ""

	nHdl := FT_FUse( cModelHTML )
	// Abre o arquivonHandle := FT_FUse("c:\garbage\test.txt")// Se houver erro de abertura abandona processamentoif nHandle = -1  returnendif// Posiciona na primeria linhaFT_FGoTop()// Retorna o número de linhas do arquivonLast := FT_FLastRec()MsgAlert( nLast )While !FT_FEOF()   cLine  := FT_FReadLn() // Retorna a linha corrente  nRecno := FT_FRecno()  // Retorna o recno da Linha  MsgAlert( "Linha: " + cLine + " - Recno: " + StrZero(nRecno,3) )    // Pula para próxima linha  FT_FSKIP()End// Fecha o ArquivoFT_FUSE()

	If nHdl == -1
		u_xConOut("Ocorreu um erro na abertura do arquivo " + cModelHTML + ".")
		//Alert("Ocorreu um erro na abertura do arquivo " + cModelHTML + ".")
	Else

		FT_FGOTOP()
		While !FT_FEOF()
			cBuffer  += FT_FREADLN()
			FT_FSKIP()	
		Enddo


	Endif
	u_xConOut("******************** cBuffer => " + cBuffer)
	//Alert(cBuffer)
Return cBuffer
