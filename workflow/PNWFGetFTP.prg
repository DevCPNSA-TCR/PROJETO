#Include 'totvs.ch'
#Include 'rwmake.ch'
#Include 'topconn.ch'
#Include 'tbiconn.ch'
#Include 'tbicode.ch'
#Include 'ap5mail.ch'
/*/
*****************************************************************************************************
*** Programa: WFGETFTP   -   Autor: Leonardo Pereira   -   Data:                                  ***
*** Descricao: Faz o upload e a exclusao do arquivos do FTP                                       ***
*****************************************************************************************************
/*/
User Function WFGetFTP()

	Local lEnd := .F.
	Local aTabEnv := {'SAK', 'SC7', 'SC1', 'SCR', 'SAL', 'SA2', 'WF3', 'WFA', 'SY1', 'SE4', 'SB1'}

	/*/ Inicializa o ambiente /*/
	RPCSetType(2)
	If (RPCSetEnv('01', '0101', 'userwf', 'wf123', 'COM',, aTabEnv, .F., .T., .T., .T.))
		WFGetFTP(@lEnd)
	EndIf

	/*/ Fecha o ambiente /*/
	RPCClearEnv()

Return

/*
****************************************************************************************************
*** Programa: WFGETFTP   -   Autor: Leonardo Pereira   -   Data:                                 ***
*** Descricao: Faz o upload e a exclusao do arquivos do FTP                                      ***
****************************************************************************************************
*/
Static Function WFGetFTP(lEnd)

	Local aArqFTP := {}
	Local nX := 0
	Local nW := 0
	Private lAmbProd := (Upper(AllTrim(GetEnvServer())) $ AllTrim(GetMV('MV_XAMBIENT')))
	
	/*/ Configuracao do FTP - Para upload/exclusao dos arquivos /*/
	Private cSrvFTP := 'ftp.portonovosa.com.br'
	Private nPortaFTP := 21
	Private cDirFTP := ''
	Private cUsrFTP := 'doit@portonovosa.com.br'
	Private cPswFTP := 'P@ssw0rd'

	If lAmbProd
		cDirFTP := '/workflow/'
	Else
		cDirFTP := '/workflow/homologacao/'
	EndIf

	cDSrvUP := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\upload\'
	cDSrvDEL := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\apagar\'
	cDSrvRET := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\retorno\'

	u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ WFGETFTP ]')
	u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Iniciando rotina ]')

	For nW := 1 To 3
		If (nW == 1)
			/*/ Faz a leitura dos arquivos baixados. /*/
			aDir(cDSrvUP + '*.*', aArqFTP)
			/*/ Conexao no FnTP /*/
			FTPDisconnect()
			u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Conectando no FTP ]')
			If FTPConnect(cSrvFTP, nPortaFTP, cUsrFTP, cPswFTP)
				u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Conectado no FTP ]')
				/*/ Tipo de Transfer?ncia utilizada 0=ASCII; 1=BINARIO/*/
				FTPSetType(1)
				/*/ Verifica se existem arquivos para processar /*/
				For nX := 1 To Len(aArqFTP)
					/*/ Posiciona no diretorio de destino no FTP /*/
					u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Acessando o diretorio: ' + cDirFTP + 'aprvs/' + SubStr(aArqFTP[nX], 9, 6) + '/pen/' + ']')
					If FTPDirChange(cDirFTP + 'aprvs/' + SubStr(aArqFTP[nX], 9, 6) + '/pen/')
						u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Diretorio acessado ]')
						/*/ Verifica se existem arquivos para processar /*/
						u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Lendo arquivos do diretorio ]')
						/*/ Envia o formulario para o FTP/*/
						If FTPUpload(cDSrvUP + aArqFTP[nX], cDirFTP + 'aprvs/' + SubStr(aArqFTP[nX], 9, 6) + '/pen/' + Lower(aArqFTP[nX]))
							u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Realizando Upload do arquivo:' + Lower(aArqFTP[nX]) + ' ]')
							fErase(cDSrvUP + Lower(aArqFTP[nX]))
						Else
							u_xConOut('Falha ao copiar o arquivo: ' + aArqFTP[nX] + 'para o FTP')
						EndIf
					Else
						u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Falha ao acessar o diretorio no FTP!')
					EndIf
				Next
			Else
				u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Falha na conexao com FTP!')
			EndIf
			FTPDisconnect()
		ElseIf (nW == 2)
			/*/ Faz a leitura dos arquivos baixados. /*/
			aDir(cDSrvDEL + '*.exc', aArqFTP)
			u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Conectando no FTP ]')
			/*/ Conexao no FTP /*/
			FTPDisconnect()
			If FTPConnect(cSrvFTP, nPortaFTP, cUsrFTP, cPswFTP)
				/*/ Tipo de Transfer?ncia utilizada 0=ASCII; 1=BINARIO/*/
				u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Conectado no FTP ]')
				FTPSetType(1)
				/*/ Verifica se existem arquivos para processar /*/
				For nX := 1 To Len(aArqFTP)
					/*/ Posiciona no diretorio de destino no FTP /*/
					u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Acessando o diretorio: ' + cDirFTP + 'aprvs/' + SubStr(aArqFTP[nX], 9, 6) + '/pen/' + ']')
					If FTPDirChange(cDirFTP + 'aprvs/' + SubStr(aArqFTP[nX], 9, 6) + '/pen/')
						u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Diretorio acessado ]')
						/*/ Deleta o formulario no FTP/*/
						If FTPErase(cDirFTP + 'aprvs/' + SubStr(aArqFTP[nX], 9, 6) + '/pen/' + Lower(SubStr(aArqFTP[nX], 1, (Len(aArqFTP[nX]) - 4))) + '.php')
							u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Arquivo excluido:' + Lower(SubStr(aArqFTP[nX], 1, (Len(aArqFTP[nX]) - 4))) + '.php' + ' ]')
							fErase(cDSrvDEL + Lower(aArqFTP[nX]))
						Else
							u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Falha ao apagar o arquivo: ' + Lower(SubStr(aArqFTP[nX], 1, (Len(aArqFTP[nX]) - 4))) + '.php' + 'no FTP')
						EndIf
						If FTPErase(cDirFTP + 'aprvs/' + SubStr(aArqFTP[nX], 9, 6) + '/pen/' + Lower(SubStr(aArqFTP[nX], 1, (Len(aArqFTP[nX]) - 4))) + '.inf')
							u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Arquivo excluido:' + Lower(SubStr(aArqFTP[nX], 1, (Len(aArqFTP[nX]) - 4))) + '.inf' + ' ]')
							fErase(cDSrvDEL + Lower(aArqFTP[nX]))
						Else
							u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Falha ao apagar o arquivo: ' + Lower(SubStr(aArqFTP[nX], 1, (Len(aArqFTP[nX]) - 4))) + '.inf' + 'no FTP')
						EndIf
					Else
						u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Falha ao acessar o diretorio no FTP!')
					EndIf
				Next
			Else
				u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Falha na conexao com FTP!')
			EndIf
			FTPDisconnect()
		ElseIf (nW == 3)
			/*/ Conexao no FTP /*/
			FTPDisconnect()
			If FTPConnect(cSrvFTP, nPortaFTP, cUsrFTP, cPswFTP)
				/*/ Tipo de Transfer?ncia utilizada 0=ASCII; 1=BINARIO/*/
				u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Conectado no FTP ]')
				FTPSetType(1)
				/*/ Posiciona no diretorio de destino no FTP /*/
				u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Acessando o diretorio: ' + cDirFTP + 'retorno/ ]')
				If FTPDirChange(cDirFTP + 'retorno/')
					u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Diretorio acessado ]')
					/*/ Lista todos os arquivos na pasta do FTP/*/
					aRetDir := FTPDirectory('*.RET',)
					For nX := 1 To Len(aRetDir)
						/*/ Realzia o download do arquivo no FTP/*/
						If FTPDownload(cDSrvRET + aRetDir[nX, 01], aRetDir[nX, 01])
							u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo: ' + aRetDir[nX, 01] + ', baixado com sucesso!')
							If FTPRenameFile(aRetDir[nX, 01], SubStr(aRetDir[nX, 01], 1, (Len(aRetDir[nX, 01]) - 3)) + 'dow')
								u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo: ' + aRetDir[nX, 01] + ', renomeado com sucesso!')
							EndIf
						Else
							u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo: ' + aRetDir[nX, 01] + ', nao foi baixado!')
						EndIf
					Next
				Else
					u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Falha ao acessar o diretorio no FTP!')
				EndIf
			Else
				u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Falha na conexao com FTP!')
			EndIf
			FTPDisconnect()
		EndIf
	Next

	u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ WFGETFTP ]')
	u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Rotina Finalizada ]')

Return
