#Include 'totvs.ch'
#Include 'topconn.ch'
#Include 'rwmake.ch'
#Include 'protheus.ch'
#Include 'tbiconn.ch'
/*
*****************************************************************************************************
*** Programa: WFENVMAIL   -   Autor: Leonardo Pereira   -   Data:                                 ***
*** Descricao:                                                                                    ***
*****************************************************************************************************
*/
User Function WFEnvMail()

	Local aTabEnv := {'SAK', 'SC7', 'SC1', 'SCR', 'SCE', 'SCS', 'SAL', 'SA2', 'WF3', 'WFA', 'SY1', 'SE4', 'SB1'}

	Private lEnd := .F.
	Private lLiberou := .T.

	/*/ Inicializa o ambiente /*/
	RPCSetType(2)
	If (RPCSetEnv('01', '0101', 'userwf', 'wf123', 'COM',, aTabEnv, .F., .T., .T., .T.))
		WFEnvMail(@lEnd)
	EndIf

	/*/ Fecha o ambiente /*/
	RPCClearEnv()

Return

	/*
*****************************************************************************************************
*** Programa: WFENVMAIL   -   Autor: Leonardo Pereira   -   Data:                                 ***
*** Descricao: Faz o envio de email ao detectar que mapa ou pedido de compra estao com aprovacao  ***
***            pendente com periodo igual ou superior ao parametrizado.                           ***
*****************************************************************************************************
	*/
Static Function WFEnvMail(lEnd)

	Local aAreaSM0 := SM0->(GetArea())
	Local nX := 0
	/*/ Realiza a abertura da tabela de empresas /*/
	SM0->(DbGoTop())
	SM0->(DbSetOrder(1))
	While !SM0->(Eof())
		cEmpAnt := SM0->M0_CODIGO
		cFilAnt := AllTrim(SM0->M0_CODFIL)

		/*/ Realiza a leitura e processamento dos arquivos de retorno /*/
		WFVerSCR()
		SM0->(DbSkip())
	End
	
	RestArea(aAreaSM0)

Return

	/*
*****************************************************************************************************
*** Programa: WFVERSCR   -   Autor: Leonardo Pereira   -   Data:                                  ***
*** Descricao: Faz a leitura da tabela SCR verificando atraso nas liberacoes.                     ***
*****************************************************************************************************
	*/
Static Function WFVerSCR()
	
	Local cDirSRVa := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\sent\'
	Local cDirSRVb := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\outbox\'
	Local aArqRET := {}
	Local lAprov := .F.
	Local MVDiasWF := GetMV('MV_DIASWF')
	Local nX :=0
	/*/ Verifica se existem aprovacoes pendentes /*/
	If (Select('WFSCRMAIL') > 0)
		WFSCRMAIL->(DbCloseArea())
	EndIf
	cQry := 'SELECT * '
	cQry += 'FROM ' + RetSQLName('SCR') + ' '
	cQry += "WHERE CR_DATALIB = '' "
	cQry += "AND D_E_L_E_T_ = '' "
	cQry += 'ORDER BY CR_FILIAL, CR_TIPO, CR_NUM, CR_NIVEL '
	TCQuery cQry New ALIAS 'WFSCRMAIL'
	WFSCRMAIL->(DbGoTop())
	While !WFSCRMAIL->(Eof())
		nDiasApr := (Date() - StoD(WFSCRMAIL->CR_EMISSAO))
		If (nDiasApr >= MVDiasWF)
		
			aDir(cDirSRVa + WFSCRMAIL->CR_EMISSAO + '\*.wfm', aArqRET)
			
			For nX := 1 To Len(aArqRET)
				If (Upper(SubStr(AllTrim(aArqRET[nX]), 1, 8)) == Upper(WFSCRMAIL->CR_WFID))
					cArqRET := (cDirSRVa + WFSCRMAIL->CR_EMISSAO + '\' + aArqRET[nX])

					/*/ Abre o arquivo /*/
					FT_FUse(cArqRET)
					FT_FGoTop()
					cLinTXT := ''
					While !FT_FEof()
						cLinTXT += FT_FReadln() + ' '
						FT_FSkip()
					End
					/*/ Fecha o arquivo /*/
					FT_FUse()
				
					lAprov := If((aT('[' + WFSCRMAIL->CR_APROV + ']', cLinTXT) > 0), .T., .F.)
			
					If lAprov
						If ((fRename(cDirSRVa + WFSCRMAIL->CR_EMISSAO + '\' + AllTrim(aArqRET[nX]), cDirSRVb + AllTrim(aArqRET[nX])) == 0))
							u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo transferido:' + cDirSRVa + AllTrim(aArqRET[nX]))
						Else
							u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Nao foi possivel transferir:' + cDirSRV + AllTrim(aArqRET[nX]))
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		WFSCRMAIL->(DbSkip())
	End
	
	/*/ Verifica se existem cotacoes expirados/*/
	If (Select('WFSCRMAIL') > 0)
		WFSCRMAIL->(DbCloseArea())
	EndIf
	cQry := 'SELECT * '
	cQry += 'FROM ' + RetSQLName('SC8') + ' '
	cQry += "WHERE C8_VALIDA < '" + DtoS(Date()) + "' "
	cQry += "AND C8_CONAPRO <> 'L' "
	cQry += "AND C8_FLAGWF = '1' "
	cQry += "AND D_E_L_E_T_ = '' "
	cQry += 'ORDER BY C8_FILIAL, C8_NUM '
	TCQuery cQry New ALIAS 'WFSCRMAIL'
	WFSCRMAIL->(DbGoTop())
	While !WFSCRMAIL->(Eof())
		SC1->(DbGoTop())
		SC1->(DbSetOrder(1))
		If SC1->(DbSeek(xFilial('SC1') + AllTrim(WFSCRMAIL->C8_NUMSC)))
			CotGeraWF(1, SC1->C1_NUM, SC1->C1_USER)
			CotGeraWF(2, WFSCRMAIL->C8_NUM, WFSCRMAIL->C8_XUSER)
			
			/*/ Envia mensagens para aprovadores que ainda nao realizaram a tarefa. /*/
			SCR->(DbGoTop())
			SCR->(DbSetOrder(2))
			If SCR->(DbSeek(xFilial('SCR') + 'MC' + WFSCRMAIL->C8_NUM + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))))
				While SCR->(!Eof()) .And. (AllTrim(SCR->CR_NUM) == WFSCRMAIL->C8_NUM)
					If (SCR->CR_STATUS == '02')
						CotGeraWF(3, AllTrim(SCR->CR_NUM), SCR->CR_USER)
					EndIf
					SCR->(DbSkip())
				End
			EndIf
		EndIf
		WFSCRMAIL->(DbSkip())
	End

Return

/*
****************************************************************************************************
*** Funcao: COTGERAWF   -   Autor: Leonardo Pereira   -   Data:                                  ***
*** Descricao:                                                                                   ***
****************************************************************************************************
*/
Static Function CotGeraWF(nExec, cNumDOC, cCodUsr)

	Local cCodStatus, cHtmlModelo
	Local cUsuarioWF, cTexto
	Local cNumCotWF := cNumCOT
	Local cTitulo := 'Ranking da cotacao de compras'

	/*/ Arquivo html template utilizado para montagem da aprova??o /*/
	cHtmlModelo := If((SubStr(cFilAnt, 1, 2) == '01'), '\workflow\modelos\WFCotExp01.htm', '\workflow\modelos\WFCotExp02.htm')

	/*/ Registra o nome do usu?rio corrente que est? criando o processo: /*/
	cUsuarioWF := UsrRetName(cCodUsr)

	/*/ Cria uma tarefa /*/
	oProcess:NewTask(cTitulo, cHtmlModelo)

	/*/ Cria um texto que identifique as etapas do processo que foi realizado para futuras consultas na janela de rastreabilidade /*/
	cTexto := 'Iniciando a comunicacao de termino da ' + If((nOpc == 1), 'cotacao', 'pedido') + ' No.: ' + cNumDOC

	/*/ Informe o c?digo de status correspondente a essa etapa /*/
	cCodStatus := '100100' // C?digo do cadastro de status de processo

	/*/ Repasse as informa??es para o m?todo respons?vel pela rastreabilidade /*/
	oProcess:Track(cCodStatus, cTexto, cUsuarioWF) // Rastreabilidade

	/*/ Adicione informac?es a serem inclu?das na rastreabilidade /*/
	cTexto := 'Gerando comunicacao...'
	cCodStatus := '100200'
	oProcess:Track(cCodStatus, cTexto, cUsuarioWF)

	If (nExec == 1)
		oProcess:oHtml:ValByName('WAprovador', cUsuarioWF)
		oProcess:oHtml:ValByName('WNumCot', cNumDOC + 'referente a solicitacao No:' + SC1->C1_NUM + ' ')
	ElseIf (nExec == 2) .Or. (nExec == 3)
		oProcess:oHtml:ValByName('WCod', )
		oProcess:oHtml:ValByName('WAprovador', cUsuarioWF)
		oProcess:oHtml:ValByName('WNumCot', cNumDOC)
	EndIf
	
	/*/ Repasse o texto do assunto criado para a propriedade espec?fica do processo /*/
	oProcess:cSubject := cAssunto

	/*/ Informe o endere?o eletr?nico do destinat?rio /*/
	PswOrder(1)
	If (PswSeek(AllTrim(aDadosTXT[1, 8]), .T.))
		aInfoUsu := PswRet(1)
	EndIf
	oProcess:cTo := AllTrim(aInfoUsu[1, 14])

	/*/ Utilize a funcao WFCodUser para obter o c?digo do usu?rio Protheus /*/
	oProcess:UserSiga := cCodUsr

	/*/ Informe o nome da fun??o de retorno a ser executada quando a mensagem de respostas retornar ao Workflow /*/
	oProcess:bReturn := 'U_WFMCRetPN()'

	/*/ Informe o nome da fun??o do tipo timeout que ser? executada se houver um timeout ocorrido para esse processo. Neste exemplo, ela ser? executada cinco minutos ap?s o envio /*/
	/*/ do e-mail para o destinat?rio. Caso queira-se aumentar ou diminuir o tempo, altere os valores das vari?veis: nDias, nHoras e nMinutos /*/
	oProcess:bTimeOut := ''

	/*/ Adicione as informac?es a serem inclu?das na rastreabilidade /*/
	cTexto := 'Enviando comunicacao de ranking...'
	cCodStatus := '100300'
	oProcess:Track(cCodStatus, cTexto , cUsuarioWF)

	WFProcessID := oProcess:fProcessID

	/*/ Ap?s ter repassado todas as informac?es necess?rias para o Workflow, execute o m?todo Start() para gerar todo o processo e enviar a mensagem ao destinat?rio /*/
	oProcess:Start()

	/*/ Adicione as informac?es a serem inclu?das na rastreabilidade /*/
	cTexto := 'Aguarde retorno...'
	cCodStatus := '100400'
	oProcess:Track(cCodStatus, cTexto , cUsuarioWF) // Rastreabilidade
	
	oProcess:Finish()

Return
