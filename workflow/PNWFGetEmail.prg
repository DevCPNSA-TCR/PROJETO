#Include 'totvs.ch'
#Include 'topconn.ch'
#Include 'rwmake.ch'
#Include 'protheus.ch'
#Include 'tbiconn.ch'
/*/
*****************************************************************************************************
*** Programa: WFGETMAIL   -   Autor: Leonardo Pereira   -   Data:                                 ***
*** Descricao: Faz a leitura do email no servidor POP e salva os arquivos em anexo.               ***
*****************************************************************************************************
/*/
User Function WFGetMail()

	Local lEnd := .F.
	Local aTabEnv := {'SAK', 'SC7', 'SC1', 'SCR', 'SAL', 'SA2', 'WF3', 'WFA', 'SY1', 'SE4', 'SB1'}

	/*/ Inicializa o ambiente /*/
	RPCSetType(2)
	If (RPCSetEnv('01', '0101', 'userwf', 'wf123', 'COM',, aTabEnv, .F., .T., .T., .T.))
		WFGetMail(@lEnd)
	EndIf

	/*/ Fecha o ambiente /*/
	RPCClearEnv()

Return

/*
*****************************************************************************************************
*** Programa: WFGETMAIL   -   Autor: Leonardo Pereira   -   Data:                                 ***
*** Descricao: Faz a leitura do email no servidor POP e salva os arquivos em anexo.               ***
*****************************************************************************************************
*/
Static Function WFGetMail(lEnd)

	Local oServer
	Local oMessage
	Local lArqAtt := .F.
	Local cMailTo := Nil
	Local nNumMsg := 0
	Local nNumAtt := 0
	Local aInfoAtt := {}
	Local nJ := 0
	Local nI := 0
	/*/ Cria uma conex?o POP /*/
	u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ WFGETMAIL ]')
	u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Iniciando rotina ]')
	oServer := TMailManager():New()
	oServer:SetUseSSL(.T.)
	oServer:Init('mail.portonovosa.com.br', '', 'wf@compras.portonovosa.com.br', '7orCP2te', 995) // Conexao pop
	nTimeOut := oServer:GetPOPTimeout()
	If ((nRet := oServer:SetPopTimeOut(nTimeOut)) <> 0)
		u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Falha ao configurar o timeout, POP')
		u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] ' + oServer:GetErrorString(nRet))
		Return
	Else
		u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Sucesso ao configurar o timeout, POP')
	EndIf

	If ((nRet := oServer:POPConnect()) <> 0)
		u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Falha ao conectar no servidor POP')
		u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] ' + oServer:GetErrorString(nRet))
	Return
	Else
		u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Sucesso ao conectar no servidor POP')
	EndIf

	/*/ Recebe o n?mero de mensagens do servidor /*/
	If (oServer:GetNumMsgs(@nNumMsg) <> 0)
		u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Falha ao contar mensagens no servidor POP')
		u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] ' + oServer:GetErrorString(nRet))
	Return
	Else
		u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Sucesso ao contar mensagens no servidor POP')
	EndIf

	/*/ Cria o objeto da mensagem /*/
	oMessage := TMailMessage():New()

	For nI := 1 To nNumMsg
		u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Analisando e-mail de resposta...')
		/*/ Limpa o objeto da mensagem /*/
		oMessage:Clear()

		/*/ Recebe a mensagem do servidor /*/
		If (oMessage:Receive(oServer, nI) == 0)
			/*/ Verifica quem recebeu a mensagem /*/
			u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Recebendo mensagem...')
			cMailTo := AllTrim(oMessage:cTo)
			nPosIni := aT('<', cMailTo)
			nPosFim := aT('@', cMailTo)
			cMailTo := SubStr(cMailTo, (nPosIni + 1), (nPosFim - (nPosIni+1)))

			/*/ Conta os anexos da mensagem /*/
			nNumAtt := oMessage:GetAttachCount()
			For nJ := 1 To nNumAtt
				aInfoAtt := oMessage:GetAttachInfo(nJ)
				If (Upper(Right(AllTrim(aInfoAtt[4]), 3)) == 'RET')
					cCodUsrApr := SubStr(AllTrim(aInfoAtt[4]), 9, 6)
					cContAtt := oMessage:GetAttach(nJ)

					cDirSRV := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\retorno\'
					cDirSRVEML := cDirSRV + 'eml\'

					/*/ Verifica se o arquivo ja existe /*/
					If File(cDirSRV + AllTrim(aInfoAtt[4]))
						fErase(cDirSRV + AllTrim(aInfoAtt[4]))
					EndIf

					/*/ Cria o arquivo /*/
					nHand := fCreate(cDirSRV + AllTrim(aInfoAtt[4]))

					/*/ Grava no arquivo o conteudo do anexo. /*/
					If (nHand > 0)
						fWrite(nHand, cContAtt)
						fClose(nHand)
						lArqAtt := .T.
					EndIf
				EndIf
			Next

			/*/ Verifica se o anexo ? uma resposta de workflow /*/
			/*/ Salva a mensagem processada /*/
			If lArqAtt
				oMessage:Save(cDirSRVEML + AllTrim(aInfoAtt[4]) + '.eml')
				u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Gravando mensagem em disco...')

				oServer:DeleteMsg(nI)
				u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Deletando a mensagem...')
			EndIf
		Else
			u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Nao foi possivel receber a mensagem...')
		EndIf
	Next

	/*/ Desconecta do servidor POP /*/
	If (nRet := oServer:PopDisconnect() <> 0)
		u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Falha ao desconectar do servidor POP')
		u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] ' + oServer:GetErrorString(nRet))
	Return
	Else
		u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Sucesso ao desconectar do servidor POP')
	EndIf

	u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ FInalizando rotina ]')
	u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ WFGETMAIL ]')

Return
