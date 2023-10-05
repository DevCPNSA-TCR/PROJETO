#Include 'totvs.ch'
#Include 'topconn.ch'
#Include 'rwmake.ch'
#Include 'protheus.ch'
#Include 'tbiconn.ch'
/*/
*****************************************************************************************************
*** Programa: PNRETWF   -   Autor: Leonardo Pereira   -   Data:                                   ***
*** Descricao: Faz a leitura do email no servidor POP e salva os arquivos em anexo.               ***
*****************************************************************************************************
/*/
User Function PNRetWF()

	Local aTabEnv := {'SAK', 'SC7', 'SC1', 'SCR', 'SCE', 'SCS', 'SAL', 'SA2', 'WF3', 'WFA', 'SY1', 'SE4', 'SB1'}
	
	Private cNivAtu := 0
	Private lEnd := .F.
	Private lLiberou := .T.
	Private aDadosTXT := {}
	Private nTamRET := 0
	Private cDirSRVRET
	Private cDirSRVEML
	Private cArqRET
	Private aRet := {}
	
	u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ WFRETORNO ]')
	
	/*/ Inicializa o ambiente /*/
	RPCSetType(2)
	If (RPCSetEnv('01', '0101', 'userwf', 'wf123', 'COM',, aTabEnv, .F., .T., .T., .T.))
		WFGetRet(@lEnd)
	Else
		u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ NAO INICIOU O AMBIENTE ]')
	EndIf
	
	/*/ Fecha o ambiente /*/
	RPCClearEnv()
	
Return

/*/
*****************************************************************************************************
*** Programa: WFGETRET   -   Autor: Leonardo Pereira   -   Data:                                  ***
*** Descricao: Faz a leitura do email no servidor POP e salva os arquivos XML em anexo.           ***
*****************************************************************************************************
/*/
Static Function WFGetRet(lEnd)

	/*/ Realiza a abertura da tabela de empresas /*/
	SM0->(DbGoTop())
	SM0->(DbSetOrder(1))
	While !SM0->(Eof())
		u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ ' + SM0->M0_CODIGO + ' - ' + AllTrim(SM0->M0_CODFIL) + ']')
		cEmpAnt := SM0->M0_CODIGO
		cFilAnt := AllTrim(SM0->M0_CODFIL)
		
		/*/ Realiza a leitura e processamento dos arquivos de retorno /*/
		GetArqRET()
		SM0->(DbSkip())
	End

Return

/*/
*****************************************************************************************************
*** Programa: GETARQPED   -   Autor: Leonardo Pereira   -   Data:                                 ***
*** Descricao: Faz a leitura do arquivo baixado do email no retorno do workflow.                  ***
*****************************************************************************************************
/*/
Static Function GetArqRET()

	Local aArqRET := {}
	Local nQtdFor := 0
	Local nMaxVlr := 0
	Local nMinFor := GetMV('MV_MINFWF')
	Local nVlrFree := GetMV('MV_VLFREWF')
	Local nX := 0
	cDirSRVRET := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\retorno\'
	
	aDir(cDirSRVRET + '*.ret', aArqRET)
	
	/*/ Faz a leitura dos arquivos baixados. /*/
	For nX := 1 To Len(aArqRET)
		u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Realiza a leitura dos arquivos ]')
		cNivAtu := 0
		cNextNiv := 0
		nQtdFor := 0
		nMaxVlr := 0
		aDadosTXT := {}
		
		If (Upper(SubStr(AllTrim(aArqRET[nX]), 1, 2)) == 'MC')
			u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Processa os retornos dos MAPAS DE COTACAO ]')
			If (SubStr(AllTrim(aArqRET[nX]), 3, 6) == cEmpAnt + cFilAnt)

				cArqRET := (cDirSRVRET + aArqRET[nX])

				u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Abrindo arquivo em disco: ' + cArqRET + '...')

				/*/ Abre o arquivo /*/
				FT_FUse(cArqRET)
				FT_FGoTop()

				cLinTxt := ''
				nLinTxt := 0
				While !FT_FEof()
					nLinTxt++
					If (nLinTxt == 1)
						cLinTxt += FT_FReadln()
					Else
						cLinTxt += ' ' + FT_FReadln()
					EndIf
					FT_FSkip()
				End

				/*/ Fecha o arquivo /*/
				FT_FUse()

				aAdd(aDadosTXT, TxtToArr(cLinTxt, '|'))

				nTamRET := Len(aDadosTXT[Len(aDadosTXT)])
				
				If (nTamRET > 0)
					u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Processando aDADOSTXT ]')
					/*/ Posiciona na tabela de pedidos /*/
					SC8->(DbGoTop())
					SC8->(DbSetOrder(1))
					SC8->(DbSeek(xFilial('SC8') + aDadosTXT[1, 5]))

					cCodLiber := aDadosTXT[1, 9]
					dDatRef := CtoD(SubStr(aDadosTXT[1, If((nTamRET == 28), Len(aDadosTxt[1]), (Len(aDadosTxt[1]) - 1))], 1, 10))

					/*/ Realiza o ranking do mapa de cotacao /*/
					SCR->(DbGoTop())
					SCR->(DbSetOrder(2))
					If SCR->(DbSeek(xFilial('SCR') + 'MC' + aDadosTXT[1, 5] + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1])) + aDadosTXT[1, 11]))
						cNivAtu := Val(SCR->CR_NIVEL)
						cNivAtu1:= SCR->CR_NIVEL
						nRecSCR := SCR->(Recno())
						SCR->(DbSetOrder(1))
						nCont := 0
						While !SCR->(Eof()) .And. (Val(SCR->CR_NIVEL) == cNivAtu) .And. (AllTrim(SCR->CR_NUM) == aDadosTXT[1, 5])
							nCont++
							If (SCR->CR_STATUS == '02')
								u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Gravando LIBERACAO do NIVEL' +  SCR->CR_NIVEL + ' ]')
								//Alterado por Ricardo Ferreira em 08/05/2014
								//Motivo: Na rejei��o o Reclock n�o estava em lugar correTO
								//SCR->(RecLock('SCR', .F.))
								If (aDadosTXT[Len(aDadosTXT), Len(aDadosTXT[Len(aDadosTXT)])] == '1')
									aAreaSCR := SCR->(GetArea())
									SCR->(DbGotop())
									SCR->(DbSetOrder(1)) //ORDEM POR NIVEL = FILIAL+TIPO+NUM+NIVEL
									If SCR->(DbSeek(xFilial('SCR') + 'MC' + aDadosTXT[1, 5] + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1])) + cNivAtu1 ))
										While !SCR->(Eof()) .And. (AllTrim(SCR->CR_NUM) == aDadosTXT[1, 5])
											SCR->(RecLock('SCR', .F.))
											SCR->CR_STATUS	 := '04'
											SCR->CR_DATALIB := dDatRef
											SCR->CR_USERLIB := aDadosTXT[1, 11]
											SCR->CR_LIBAPRO := cCodLiber
											//Grava tamb�m a observa��o do aprovador que rejeitou //Ricardo Ferreira em 08/05/2014
											SCR->CR_OBS := AllTrim(aDadosTXT[1, If((nTamRET == 28), (Len(aDadosTxt[1]) - 2), (Len(aDadosTxt[1]) - 3))])
											SCR->CR_XOBSAPR := AllTrim(aDadosTXT[1, If((nTamRET == 28), (Len(aDadosTxt[1]) - 2), (Len(aDadosTxt[1]) - 3))])
											SCR->(MsUnLock())
											SCR->(DbSkip())
										End
										Exit //Ricardo Ferreira: Sai do loop anterior, pois j� fez o loop completo internamente.
										RestArea(aAreaSCR)
									EndIf
								Else
									SCR->(RecLock('SCR', .F.))
									SCR->CR_STATUS := If((nCont == 1), '03', '05')
									SCR->CR_DATALIB := dDatRef
									SCR->CR_USERLIB := aDadosTXT[1, 11]
									SCR->CR_LIBAPRO := cCodLiber
									SCR->CR_RKN1 := aDadosTXT[1, If((nTamRET == 28), (Len(aDadosTxt[1]) - 7), (Len(aDadosTxt[1]) - 8))]
									SCR->CR_RKN2 := aDadosTXT[1, If((nTamRET == 28), (Len(aDadosTxt[1]) - 6), (Len(aDadosTxt[1]) - 7))]
									SCR->CR_RKN3 := aDadosTXT[1, If((nTamRET == 28), (Len(aDadosTxt[1]) - 5), (Len(aDadosTxt[1]) - 6))]
									SCR->CR_RKN4 := aDadosTXT[1, If((nTamRET == 28), (Len(aDadosTxt[1]) - 4), (Len(aDadosTxt[1]) - 5))]
									SCR->CR_RKN5 := aDadosTXT[1, If((nTamRET == 28), (Len(aDadosTxt[1]) - 3), (Len(aDadosTxt[1]) - 4))]
									SCR->CR_OBS := NoAcento(AllTrim(aDadosTXT[1, If((nTamRET == 28), (Len(aDadosTxt[1]) - 2), (Len(aDadosTxt[1]) - 3))]))
									SCR->CR_XOBSAPR := AllTrim(aDadosTXT[1, If((nTamRET == 28), (Len(aDadosTxt[1]) - 2), (Len(aDadosTxt[1]) - 3))])
								EndIf
								//Alterado por Ricardo Ferreira em 08/05/2014
								//Motivo: Na rejei��o o Reclock n�o estava em lugar correto.
								//SCR->(MsUnLock())
							EndIf
							SCR->(DbSkip())
						End
						
						If (aDadosTXT[Len(aDadosTXT), Len(aDadosTXT[Len(aDadosTXT)])] == '1')
							SC8->(DbGoTop())
							SC8->(DbSetOrder(1))
							SC8->(DbSeek(xFilial('SC8') + aDadosTxt[1, 5]))
							While !SC8->(Eof()) .And. (SC8->C8_NUM == aDadosTxt[1, 5])
								RecLock('SC8', .F.)
								SC8->C8_FLAGWF := '2'
								SC8->(MsUnLock())
								SC8->(DbSkip())
							End
							
							SC8->(DbGoTop())
							SC8->(DbSetOrder(1))
							SC8->(DbSeek(xFilial('SC8') + aDadosTxt[1, 5]))
							
							/*/ Movimenta o arquivo de resposta para outra pasta /*/
							cDirSrvEXC := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\apagar\'
						
							/*/ Cria arquivo de retorno do ranking /*/
							nHd1 := fCreate(cDirSrvEXC + Left(aArqRET[nX], aT('.', aArqRET[nX]) - 1) + '.exc')
							If (nHd1 >= 0)
								u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo gravado:' + cDirSrvEXC + Left(aArqRET[nX], aT('.', aArqRET[nX]) - 1) + '.exc')
								fClose(nHd1)
							EndIf
							If ((fErase(cDirSrvRET + aArqRET[nX]) == 0))
								u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo excluido:' + cDirSrvRET + aArqRET[nX])
							Else
								u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Nao foi possivel excluir:' + cDirSrvRET + aArqRET[nX])
							EndIf
						Else
							/*/ Verifica e Libera todos os regitros do mesmo nivel /*/
							cNivApr := StrZero(cNivAtu, 2)
							SCR->(DbGoTop())
							SCR->(DbSetOrder(1))
							If SCR->(DbSeek(xFilial('SCR') + 'MC' + aDadosTXT[1, 5] + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))))
								While !SCR->(Eof()) .And. (AllTrim(SCR->CR_NUM) == aDadosTXT[1, 5])
									If (SCR->CR_NIVEL == cNivApr)
										If (SCR->CR_STATUS == '02')
											u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Gravando LIBERACAO do NIVEL' +  SCR->CR_NIVEL + ' ]')
											SCR->(RecLock('SCR', .F.))
											SCR->CR_STATUS	:= '05'
											SCR->CR_DATALIB := dDatRef
											SCR->CR_USERLIB := aDadosTXT[1, 11]
											SCR->CR_LIBAPRO := cCodLiber
											SCR->CR_RKN1 := aDadosTXT[1, If((nTamRET == 28), (Len(aDadosTxt[1]) - 7), (Len(aDadosTxt[1]) - 8))]
											SCR->CR_RKN2 := aDadosTXT[1, If((nTamRET == 28), (Len(aDadosTxt[1]) - 6), (Len(aDadosTxt[1]) - 7))]
											SCR->CR_RKN3 := aDadosTXT[1, If((nTamRET == 28), (Len(aDadosTxt[1]) - 5), (Len(aDadosTxt[1]) - 6))]
											SCR->CR_RKN4 := aDadosTXT[1, If((nTamRET == 28), (Len(aDadosTxt[1]) - 4), (Len(aDadosTxt[1]) - 5))]
											SCR->CR_RKN5 := aDadosTXT[1, If((nTamRET == 28), (Len(aDadosTxt[1]) - 3), (Len(aDadosTxt[1]) - 4))]
											SCR->CR_OBS := NoAcento(AllTrim(aDadosTXT[1, If((nTamRET == 28), (Len(aDadosTxt[1]) - 2), (Len(aDadosTxt[1]) - 3))]))
											SCR->CR_XOBSAPR := AllTrim(aDadosTXT[1, If((nTamRET == 28), (Len(aDadosTxt[1]) - 2), (Len(aDadosTxt[1]) - 3))])
											SCR->(MsUnLock())
										EndIf
									EndIf
									SCR->(DbSkip())
								End
							EndIf
			
							/*/ Verifica se foi totalmente liberado /*/
							SCR->(DbGoTop())
							SCR->(DbSetOrder(1))
							If SCR->(DbSeek(xFilial('SCR') + 'MC' + aDadosTXT[1, 5] + Space((TamSX3('CR_NUM')[1] - TamSX3('C8_NUM')[1]))))
								While !SCR->(Eof()) .And. (AllTrim(SCR->CR_NUM) == aDadosTXT[1, 5])
									If (AllTrim(SCR->CR_STATUS) == '02')
										lLiberou := .F.
										Exit
									EndIf
									SCR->(DbSkip())
								End
							Else
								u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Nao foi possivel encontrar o aprovador...')
								Loop
							EndIf
						
							If lLiberou
								u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Mapa de cotacao rankeado...')

								SC8->(DbGoTop())
								SC8->(DbSetOrder(1))
								SC8->(DbSeek(xFilial('SC8') + aDadosTXT[1, 5]))
			
								u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Enviando e-mail confirmacao do ranking, comprador...')
								/*/ Envia e-mail ao comprador referente a liberacao do pedido /*/
								WFEnvMsg(5)

								/*/ Verifica se a cotacao possui solicitacao /*/
								If !(Empty(SC8->C8_NUMSC))
									u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Enviando e-mail confirmacao do ranking, solicitante...')
									/*/ Envia e-mail ao solicitante referente a liberacao do pedido /*/
									WFEnvMsg(6)
								EndIf

								SC8->(DbGoTop())
								SC8->(DbSetOrder(1))
								SC8->(DbSeek(xFilial('SC8') + aDadosTXT[1, 5]))

								/*/ Cria registro para rastreabilidade das tarefas e eventos no workflow /*/
								WFGerPro(2)

								SC8->(DbGoTop())
								SC8->(DbSetOrder(1))
								SC8->(DbSeek(xFilial('SC8') + aDadosTxt[1, 5]))
								u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Gravando LIBERACAO do MAPA DE COTACAO ]')
								While !SC8->(Eof()) .And. (SC8->C8_NUM == aDadosTxt[1, 5])
									RecLock('SC8', .F.)
									SC8->C8_CONAPRO := 'L'
									SC8->(MsUnLock())
									SC8->(DbSkip())
								End
								SC8->(DbGoTop())
								SC8->(DbSetOrder(1))
								SC8->(DbSeek(xFilial('SC8') + aDadosTxt[1, 5]))
						
								/*/ Movimenta o arquivo de resposta para outra pasta /*/
								cDirSrvEXC := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\apagar\'
								cDirSrvCOT := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\rankeados\'
						
								/*/ Cria arquivo de retorno do ranking /*/
								nHd1 := fCreate(cDirSrvEXC + Left(aArqRET[nX], aT('.', aArqRET[nX]) - 1) + '.exc')
								If (nHd1 >= 0)
									u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo gravado:' + cDirSrvEXC + Left(aArqRET[nX], aT('.', aArqRET[nX]) - 1) + '.exc')
									fClose(nHd1)
								EndIf
								//Verifica se o arquivo existe na pasta de Rankeados. Se existir, apaga. 
								iF File(cDirSrvCOT + aArqRET[nX])
									u_xConOut('[' + DtoC(Date()) + '[' + Time() + ']Encontrou o arquivo:' + cDirSrvCOT + aArqRET[nX])
									IF fErase(cDirSrvCOT + aArqRET[nX]) = 0
										u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo excluido:' + cDirSrvCOT + aArqRET[nX])
									Else
										u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Falha ao apagar Arquivo:' + cDirSrvCOT + aArqRET[nX])
									Endif
									
								Else
									u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] N�O Encontrou o arquivo:' + cDirSrvCOT + aArqRET[nX])
								Endif
								If ((fRename(cDirSrvRET + aArqRET[nX], cDirSrvCOT + aArqRET[nX]) == 0))
									u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo transferido:' + cDirSrvRET + aArqRET[nX])
								Else
									u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Nao foi possivel transferir:' + cDirSrvRET + aArqRET[nX])
								EndIf
							ElseIf !lLiberou
								u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Enviando e-mail para ranking da cotacao do proximo nivel...')
								SC8->(DbGoTop())
								SC8->(DbSetOrder(1))
								SC8->(DbSeek(xFilial('SC8') + aDadosTxt[1, 5]))
							
								U_PNEnvWF(cNivAtu, 2)

								SC8->(DbGoTop())
								SC8->(DbSetOrder(1))
								SC8->(DbSeek(xFilial('SC8') + aDadosTxt[1, 5]))
						
								/*/ Cria registro para rastreabilidade das tarefas e eventos no workflow /*/
								WFGerPro(2)
						
								SC8->(DbGoTop())
								SC8->(DbSetOrder(1))
								SC8->(DbSeek(xFilial('SC8') + aDadosTxt[1, 5]))
						
								/*/ Movimenta o arquivo de resposta para outra pasta /*/
								cDirSrvEXC := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\apagar\'
						
								/*/ Cria arquivo de retorno do ranking /*/
								nHd1 := fCreate(cDirSrvEXC + Left(aArqRET[nX], aT('.', aArqRET[nX]) - 1) + '.exc')
								If (nHd1 >= 0)
									u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo gravado:' + cDirSrvEXC + Left(aArqRET[nX], aT('.', aArqRET[nX]) - 1) + '.exc')
									fClose(nHd1)
								EndIf
								If ((fErase(cDirSrvRET + aArqRET[nX]) == 0))
									u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo excluido:' + cDirSrvRET + aArqRET[nX])
								Else
									u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Nao foi possivel excluir:' + cDirSrvRET + aArqRET[nX])
								EndIf
							EndIf
						EndIf
					Else
						u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Nao foi possivel encontrar o aprovador...')
						Loop
					EndIf
				EndIf
			EndIf
		ElseIf (Upper(SubStr(AllTrim(aArqRET[nX]), 1, 2)) == 'PC')
			u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Processa os retornos dos PEDIDOS DE COMPRA]')
			If (SubStr(AllTrim(aArqRET[nX]), 3, 6) == cEmpAnt + cFilAnt)
				cArqRET := (cDirSRVRET + aArqRET[nX])

				u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Abrindo arquivo em disco: ' + cArqRET + '...')

				/*/ Abre o arquivo /*/
				FT_FUse(cArqRET)
				FT_FGoTop()

				cLinTxt := ''
				nLinTxt := 0
				While !FT_FEof()
					nLinTxt++
					If (nLinTxt == 1)
						cLinTxt += FT_FReadln()
					Else
						cLinTxt += ' ' + FT_FReadln()
					EndIf
					FT_FSkip()
				End

				/*/ Fecha o arquivo /*/
				FT_FUse()

				aAdd(aDadosTXT, TxtToArr(cLinTxt, '|'))
				
				nTamRET := Len(aDadosTXT[Len(aDadosTXT)])
				
				If (nTamRET >= 23)
					u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ Processando aDADOSTXT ]')
					/*/ Posiciona na tabela de pedidos /*/
					SC7->(DbGoTop())
					SC7->(DbSetOrder(1))
					SC7->(DbSeek(xFilial('SC7') + aDadosTXT[1, 5]))

					cCodLiber := aDadosTXT[1, 9]
					dDatRef := CtoD(SubStr(aDadosTXT[1, If((nTamRET > 24), (24 + (nTamRET - 24)), 24)], 1, 10))

					SCR->(DbGoTop())
					SCR->(DbSetOrder(2))
					If SCR->(DbSeek(xFilial('SCR') + 'PC' + SC7->C7_NUM + Space((TamSX3('CR_NUM')[1] - TamSX3('C7_NUM')[1])) + aDadosTXT[1, 11]))
						cNivAtu := Val(SCR->CR_NIVEL)
						If !(Empty(SCR->CR_DATALIB))
							u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Esta operacao nao podera ser realizada pois este registro ja se encontra LIBERADO!')
							If ((fErase('\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\retorno\' + aArqRET[nX]) == 0))
								u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo excluido:' + aArqRET[nX])
							Else
								u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Nao foi possivel excluir:' + aArqRET[nX])
							EndIf
							Loop
						EndIf
						If SCR->(RecLock('SCR', .F.))
							SCR->CR_OBS := NoAcento(aDadosTXT[1, If((nTamRET > 24), (22 + (nTamRET - 24)), 22)])
							SCR->CR_XOBSAPR := aDadosTXT[1, If((nTamRET > 24), (22 + (nTamRET - 24)), 22)]
							SCR->(MsUnLock())
						EndIf
					Else
						u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] INDICE falhou, Nao foi possivel encontrar o aprovador...')
						Loop
					EndIf

					/*/ Posiciona no aprovador dentro do grupo de aprovadores /*/
					SAL->(DbGoTop())
					SAL->(DbSetOrder(3))
					SAL->(DbSeek(xFilial('SAL') + SC7->C7_APROV + cCodLiber))

					/*/ Posiciona no fornecedor do pedido de compra /*/
					SA2->(DbGoTop())
					SA2->(DbSetOrder(1))
					SA2->(DbSeek(xFilial('SA2') + SC7->C7_FORNECE + SC7->C7_LOJA))

					/*/ Inicializa as variaveis utilizadas no Display. /*/
					aRetSaldo := MaSalAlc(cCodLiber, dDatRef)
					nSaldo := aRetSaldo[1]
					CRMoeda := A097Moeda(aRetSaldo[2])
					cName := AllTrim(aDadosTXT[1, 10])
					nTotal := xMoeda(SCR->CR_TOTAL, SCR->CR_MOEDA, aRetSaldo[2], SCR->CR_EMISSAO,, SCR->CR_TXMOEDA)

					/*/ Verifica o tipo de limite do aprovador /*/
					SAK->(DbGoTop())
					SAK->(DbSetOrder(1))
					SAK->(DbSeek(xFilial('SAK') + aDadosTxt[1, 9]))

					Do Case
					Case (SAK->AK_TIPO == 'D')
						cTipoLim := OemToAnsi('Diario')
					Case (SAK->AK_TIPO == 'S')
						cTipoLim := OemToAnsi('Semanal')
					Case (SAK->AK_TIPO == 'M')
						cTipoLim := OemToAnsi('Mensal')
					Case (SAK->AK_TIPO == 'A')
						cTipoLim := OemToAnsi('Anual')
					EndCase

					lAprov := If(aDadosTXT[1, If((nTamRET > 24), (23 + (nTamRET - 24)), 23)] == '1', .T., .F.)
					nSalDif := (nSaldo - If(lAprov, 0, nTotal))

					/*/ Faz o destravamento de todos os registros da SC7 /*/
					SC7->(MsUnLockAll())
					lLibOk := A097Lock(AllTrim(SCR->CR_NUM), SCR->CR_TIPO)

					If lLibOk
						u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Liberando pedido: ' + SC7->C7_NUM + '...')
						Begin Transaction
							lLiberou := MaAlcDoc({AllTrim(SCR->CR_NUM), SCR->CR_TIPO, SCR->CR_TOTAL, aDadosTXT[1, 9], aDadosTXT[1, 11], SAL->AL_COD,, SC7->C7_MOEDA, SC7->C7_TXMOEDA, SCR->CR_EMISSAO, SC7->C7_APROV}, dDatRef, If(aDadosTXT[1, If((nTamRET > 24), (23 + (nTamRET - 24)), 23)] == '1', 4, 6))
						End Transaction
						If lLiberou
							u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Pedido liberado...')

							SC7->(DbGoTop())
							SC7->(DbSetOrder(1))
							SC7->(DbSeek(xFilial('SC7') + aDadosTXT[1, 5]))

							cPCFil := SC7->C7_FILIAL
							cPCLib := SC7->C7_NUM
							cPCUser:= SC7->C7_USER

							/*/ Grava a Liberacao em todos os registros do pedido de compra /*/
							While !SC7->(Eof()) .And. (SC7->C7_FILIAL + SC7->C7_NUM == xFilial('SC7') + cPCLib)
								SC7->(Reclock('SC7', .F.))
								SC7->C7_CONAPRO := 'L'
								SC7->C7_XDATALI := dDataBase
								SC7->(MsUnLock())
								SC7->(DbSkip())
							End

							SC7->(DbGoTop())
							SC7->(DbSetOrder(1))
							SC7->(DbSeek(xFilial('SC7') + aDadosTXT[1, 5]))

							u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Enviando e-mail confirmacao da liberacao, comprador...')
							/*/ Envia e-mail ao comprador referente a liberacao do pedido /*/
							WFEnvMsg(1)

							/*/ Verifica se o pedido possui solicitacao /*/
							If !(Empty(SC7->C7_NUMSC))
								u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Enviando e-mail confirmacao da liberacao, solicitante...')
								/*/ Envia e-mail ao solicitante referente a liberacao do pedido /*/
								WFEnvMsg(2)
							EndIf

							SC7->(DbGoTop())
							SC7->(DbSetOrder(1))
							SC7->(DbSeek(xFilial('SC7') + aDadosTXT[1, 5]))

							/*/ Cria registro para rastreabilidade das tarefas e eventos no workflow /*/
							WFGerPro(1)

							/*/ Movimenta o arquivo de resposta para outra pasta /*/
							cDirSrvEXC := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\apagar\'
							cDirSrvPED := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\pedido\' + aDadosTxt[1, 11] + '\aprovados\'

							/*/ Cria arquivo de retorno da aprovacao /*/
							nHd1 := fCreate(cDirSrvEXC + Left(aArqRET[nX], aT('.', aArqRET[nX]) - 1) + '.exc')
							If (nHd1 >= 0)
								u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo gravado:' + cDirSrvEXC + Left(aArqRET[nX], aT('.', aArqRET[nX]) - 1) + '.exc')
								fClose(nHd1)
							EndIf
							
							//Verifica se o arquivo existe na pasta de Rankeados. Se existir, apaga. 
							If File(cDirSrvPED + aArqRET[nX])
								fErase(cDirSrvPED + aArqRET[nX])
							EndIf
							If ((fRename(cDirSrvRET + aArqRET[nX], cDirSrvPED + aArqRET[nX]) == 0))
								u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo transferido:' + cDirSrvRET + aArqRET[nX])
							Else
								u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Nao foi possivel transferir:' + cDirSrvRET + aArqRET[nX])
							EndIf
						ElseIf !lLiberou .And. (aDadosTXT[1, If((nTamRET > 24), (23 + (nTamRET - 24)), 23)] == '1')
							u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Processando proximo nivel de aprovacao...')

							SC7->(DbGoTop())
							SC7->(DbSetOrder(1))
							SC7->(DbSeek(xFilial('SC7') + aDadosTXT[1, 5]))

							cPCFil := SC7->C7_FILIAL
							cPCLib := SC7->C7_NUM
							cPCUser:= SC7->C7_USER

							While !SC7->(Eof()) .And. (SC7->C7_FILIAL + SC7->C7_NUM == xFilial('SC7') + cPCLib)
								SC7->(Reclock('SC7', .F.))
								SC7->C7_CONAPRO := 'B'
								SC7->C7_XDATALI := dDataBase
								SC7->(MsUnLock())
								SC7->(DbSkip())
							End

							SC7->(DbGoTop())
							SC7->(DbSetOrder(1))
							SC7->(DbSeek(xFilial('SC7') + aDadosTXT[1, 5]))

							/*/ Envia e-mail ao aprovador do proximo nivel /*/
							u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Enviando e-mail liberacao do proximo nivel...')
							U_Mt160WF(cNivAtu, 2)

							SC7->(DbGoTop())
							SC7->(DbSetOrder(1))
							SC7->(DbSeek(xFilial('SC7') + aDadosTXT[1, 5]))

							/*/ Cria registro para rastreabilidade das tarefas e eventos no workflow /*/
							u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Finalizando o processo de workflow do nivel anterior...')
							WFGerPro(1)

							/*/ Movimenta o arquivo de resposta para outra pasta /*/
							cDirSrvEXC := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\apagar\'
							cDirSrvPED := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\pedido\' + aDadosTxt[1, 11] + '\aprovados\'

							/*/ Cria arquivo de retorno da aprovacao /*/
							nHd1 := fCreate(cDirSrvEXC + Left(aArqRET[nX], aT('.', aArqRET[nX]) - 1) + '.exc')
							If (nHd1 >= 0)
								u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo gravado:' + cDirSrvEXC + Left(aArqRET[nX], aT('.', aArqRET[nX]) - 1) + '.exc')
								fClose(nHd1)
							EndIf
							If ((fRename(cDirSrvRET + aArqRET[nX], cDirSrvPED + aArqRET[nX]) == 0))
								u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo transferido:' + cDirSrvRET + aArqRET[nX])
							Else
								u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Nao foi possivel transferir:' + cDirSrvRET + aArqRET[nX])
							EndIf
						ElseIf !lLiberou .And. (aDadosTXT[1, If((nTamRET > 24), (23 + (nTamRET - 24)), 23)] == '2')
							u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Processando Rejeicao do pedido de compra...')

							SC7->(DbGoTop())
							SC7->(DbSetOrder(1))
							SC7->(DbSeek(xFilial('SC7') + aDadosTXT[1, 5]))

							cPCFil := SC7->C7_FILIAL
							cPCLib := SC7->C7_NUM
							cPCUser:= SC7->C7_USER

							While !SC7->(Eof()) .And. (SC7->C7_FILIAL + SC7->C7_NUM == xFilial('SC7') + cPCLib)
								SC7->(Reclock('SC7', .F.))
								SC7->C7_CONAPRO := 'B'
								SC7->C7_XDATALI := dDataBase
								SC7->(MsUnLock())
								SC7->(DbSkip())
							End

							SC7->(DbGoTop())
							SC7->(DbSetOrder(1))
							SC7->(DbSeek(xFilial('SC7') + aDadosTXT[1, 5]))

							u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Enviando e-mail confirmacao da rejeicao, comprador...')
							/*/ Envia e-mail ao comprador referente a rejeicao do pedido /*/
							WFEnvMsg(3)

							SC7->(DbGoTop())
							SC7->(DbSetOrder(1))
							SC7->(DbSeek(xFilial('SC7') + aDadosTXT[1, 5]))

							/*/ Verifica se o pedido possui solicitacao /*/
							If !(Empty(SC7->C7_NUMSC))
								u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Enviando e-mail confirmacao da rejeicao, solicitante...')
								/*/ Envia e-mail ao solicitante referente a rejeicao do pedido /*/
								WFEnvMsg(4)
							EndIf

							SC7->(DbGoTop())
							SC7->(DbSetOrder(1))
							SC7->(DbSeek(xFilial('SC7') + aDadosTXT[1, 5]))

							/*/ Cria registro para rastreabilidade das tarefas e eventos no workflow /*/
							WFGerPro(1)

							/*/ Movimenta o arquivo de resposta para outra pasta /*/
							cDirSrvEXC := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\apagar\'
							cDirSrvPED := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\archive\pedido\' + aDadosTxt[1, 11] + '\rejeitados\'

							/*/ Cria arquivo de retorno da aprovacao /*/
							nHd1 := fCreate(cDirSrvEXC + Left(aArqRET[nX], aT('.', aArqRET[nX]) - 1) + '.exc')
							If (nHd1 >= 0)
								u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo gravado:' + cDirSrvEXC + Left(aArqRET[nX], aT('.', aArqRET[nX]) - 1) + '.exc')
								fClose(nHd1)
							EndIf
							If ((fRename(cDirSrvRET + aArqRET[nX], cDirSrvPED + aArqRET[nX]) == 0))
								u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo transferido:' + cDirSrvRET + aArqRET[nX])
							Else
								u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Nao foi possivel transferir:' + cDirSrvRET + aArqRET[nX])
							EndIf
						EndIf
					EndIf
					SCR->(DbGoTop())
					SCR->(DbSetOrder(2))
					If SCR->(DbSeek(xFilial('SCR') + 'PC' + SC7->C7_NUM + Space((TamSx3('CR_NUM')[1] - TamSx3('C7_NUM')[1])) + aDadosTXT[1, 11]))
						If SCR->(RecLock('SCR', .F.))
							SCR->CR_WFID := SC7->C7_WFID
							SCR->CR_OBS := NoAcento(aDadosTXT[1, If((nTamRET > 24), (22 + (nTamRET - 24)), 22)])
							SCR->CR_XOBSAPR := aDadosTXT[1, If((nTamRET > 24), (22 + (nTamRET - 24)), 22)]
							SCR->(MsUnLock())
						EndIf
					EndIf
				Else
					If ((fErase(cDirSrvRET + aArqRET[nX]) == 0))
						u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Arquivo excluido:' + cDirSrvRET + aArqRET[nX])
					Else
						u_xConOut('[' + DtoC(Date()) + '[' + Time() + '] Nao foi possivel excluir:' + cDirSrvRET + aArqRET[nX])
					EndIf
				EndIf
			EndIf
			SC7->(MsUnLockAll())
		EndIf
	Next

Return

/*/
*****************************************************************************************************
*** Programa: WFENVMSG   -   Autor: Leonardo Pereira   -   Data:                                  ***
*** Descricao: Faz o envio do email para o comprador e o solicitante                              ***
*****************************************************************************************************
/*/
Static Function WFEnvMsg(nOpc)

	Local nDias := 0, nHoras := 0, nMinutos := 10
	Local cCodStatus, cHtmlModelo
	Local cUsuarioWF, cTexto
	Local cTitulo := If((nOpc <= 4), 'Aprovacao do pedido de compra', 'Ranking da cotacao')
	Local dDataPRV := ''

	u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Gerando rastreabilidade...')

	/*/ C?digo extra?do do cadastro de processos. /*/
	cCodProcesso := 'ENVMSG'

	/*/ Assunto da mensagem /*/
	cAssunto := If((nOpc <= 4), 'Aprovacao do pedido de compra', 'Ranking da cotacao')

	/*/ Arquivo html template utilizado para montagem da aprova??o /*/
	If (nOpc == 1)
		cHtmlModelo := If((SubStr(cFilAnt, 1, 2) == '01'), '\workflow\modelos\WFPedCom01.htm', '\workflow\modelos\WFPedCom02.htm')
	ElseIf (nOpc == 2)
		cHtmlModelo := If((SubStr(cFilAnt, 1, 2) == '01'), '\workflow\modelos\WFPedSol01.htm', '\workflow\modelos\WFPedSol02.htm')
	ElseIf (nOpc == 3)
		cHtmlModelo := If((SubStr(cFilAnt, 1, 2) == '01'), '\workflow\modelos\WFPedRCom01.htm', '\workflow\modelos\WFPedRCom02.htm')
	ElseIf (nOpc == 4)
		cHtmlModelo := If((SubStr(cFilAnt, 1, 2) == '01'), '\workflow\modelos\WFPedRSol01.htm', '\workflow\modelos\WFPedRSol02.htm')
	ElseIf (nOpc == 5)
		cHtmlModelo := If((SubStr(cFilAnt, 1, 2) == '01'), '\workflow\modelos\WFCotCom01.htm', '\workflow\modelos\WFCotCom02.htm')
	ElseIf (nOpc == 6)
		cHtmlModelo := If((SubStr(cFilAnt, 1, 2) == '01'), '\workflow\modelos\WFCotSol01.htm', '\workflow\modelos\WFCotSol02.htm')
	EndIf

	/*/ Registra o nome do usu?rio corrente que est? criando o processo: /*/
	cUsuarioWF := aDadosTXT[1, 7]

	/*/ Inicialize a classe TWFProcess e assinale a vari?vel objeto oProcess /*/
	oProcess := TWFProcess():New(cCodProcesso, cAssunto)

	/*/ Cria uma tarefa /*/
	oProcess:NewTask(cTitulo, cHtmlModelo)

	/*/ Cria um texto que identifique as etapas do processo que foi realizado para futuras consultas na janela de rastreabilidade /*/
	If (nOpc <= 4)
		cTexto := 'Iniciando o envio de comunicacao do pedido No.: ' + aDadosTXT[1, 5]
	ElseIf (nOpc >= 5)
		cTexto := 'Iniciando o envio de comunicacao de ranking da cotacao No.: ' + aDadosTXT[1, 5]
	EndIf

	/*/ Informe o c?digo de status correspondente a essa etapa /*/
	cCodStatus := '100100' // C?digo do cadastro de status de processo

	/*/ Repasse as informa??es para o m?todo respons?vel pela rastreabilidade /*/
	oProcess:Track(cCodStatus, cTexto, cUsuarioWF) // Rastreabilidade

	/*/ Adicione informac?es a serem inclu?das na rastreabilidade /*/
	cTexto := 'Gerando envio de comunica??o...'
	cCodStatus := '100200'
	oProcess:Track(cCodStatus, cTexto, cUsuarioWF)

	If (nOpc == 1) .Or. (nOpc == 3) .Or. (nOpc == 5)
		/*/ Coleta informacoes do usuario - [E-Mail] /*/
		PswOrder(1)
		If (PswSeek(AllTrim(aDadosTXT[1, 8]), .T.))
			aInfoUsu := PswRet(1)
			u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Sucesso ao pesquisar usuario')
		Else
			u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Falha ao pesquisar usuario')
		EndIf

		oProcess:oHtml:ValByName('WComprador', aInfoUsu[1, 4])
		If (nOpc <= 4)
			oProcess:oHtml:ValByName('WNumPed', aDadosTXT[1, 5])
		ElseIf (nOpc >= 5)
			oProcess:oHtml:ValByName('WNumCot', aDadosTXT[1, 5])
		EndIf
	ElseIf (nOpc == 2) .Or. (nOpc == 4) .Or. (nOpc == 6)
		SC1->(DbGoTop())
		SC1->(DbSetOrder(1))
		SC1->(DbSeek(xFilial('SC1') + If((nOpc == 6), SC8->C8_NUMSC, SC7->C7_NUMSC)))

		/*/ Coleta informacoes do usuario - [E-Mail] /*/
		PswOrder(1)
		If (PswSeek(AllTrim(SC1->C1_USER), .T.))
			aInfoUsu := PswRet(1)
			u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Sucesso ao pesquisar usuario do solicitante')
		Else
			u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Falha ao pesquisar usuario do solicitante')
		EndIf

		oProcess:oHtml:ValByName('WSolicitante', AllTrim(aInfoUsu[1, 4]))
		If (nOpc <= 4)
			oProcess:oHtml:ValByName('WNumPed', aDadosTXT[1, 5])
		ElseIf (nOpc >= 5)
			oProcess:oHtml:ValByName('WNumCot', aDadosTXT[1, 5])
		EndIf
		oProcess:oHtml:ValByName('WNumSol', SC1->C1_NUM)
		If (nOpc == 2)
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// Alterado 16/01/2015 - Fabio e Leonardo - Ajuste na Data de Entrega
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
		  /*/ Pesquisa dados de pagamento do pedido /*/
	     SCR->(DbGoTop())
	     SCR->(DbSetOrder(1))
	     SCR->(DbSeek(xFilial('SCR') + 'PC' + SC7->C7_NUM))
	     While SCR->(!Eof()) .And. (AllTrim(SCR->CR_NUM) == SC7->C7_NUM)
		    If !Empty(SCR->CR_DATALIB)
			   dDataPRV := (SCR->CR_DATALIB + SC8->C8_PRAZO + 1)
		    EndIf
		    SCR->(DbSkip())
	     End
		 oProcess:oHtml:ValByName('WDataEntrega', dtoc(ddataPRV))
			
		 // oProcess:oHtml:ValByName('WDataEntrega', DtoC(Date() + SC8->C8_PRAZO + 1))
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// fim - Alterado 16/01/2015 - Fabio e Leonardo - Ajuste na Data de Entrega
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
		EndIf
	EndIf

	/*/ Repasse o texto do assunto criado para a propriedade espec?fica do processo /*/
	oProcess:cSubject := cAssunto

	/*/ Informe o endere?o eletr?nico do destinat?rio /*/
	oProcess:cTo := AllTrim(aInfoUsu[1, 14])

	/*/ Utilize a funcao WFCodUser para obter o c?digo do usu?rio Protheus /*/
	oProcess:UserSiga := aDadosTXT[1, 8]

	/*/ Informe o nome da fun??o de retorno a ser executada quando a mensagem de respostas retornar ao Workflow /*/
	oProcess:bReturn := 'U_WFMailPN()'

	/*/ Informe o nome da fun??o do tipo timeout que ser? executada se houver um timeout ocorrido para esse processo. Neste exemplo, ela ser? executada cinco minutos ap?s o envio /*/
	/*/ do e-mail para o destinat?rio. Caso queira-se aumentar ou diminuir o tempo, altere os valores das vari?veis: nDias, nHoras e nMinutos /*/
	oProcess:bTimeOut := ''

	/*/ Adicione as informac?es a serem inclu?das na rastreabilidade /*/
	If (nOpc <= 4)
		cTexto := 'Enviando comunicacao de aprovacao...'
	ElseIf (nOpc >= 5)
		cTexto := 'Enviando comunicacao de ranking...'
	EndIf
	cCodStatus := '100300'
	oProcess:Track(cCodStatus, cTexto , cUsuarioWF)

	WFProcessID := oProcess:fProcessID

	/*/ Ap?s ter repassado todas as informac?es necess?rias para o Workflow, execute o m?todo Start() para gerar todo o processo e enviar a mensagem ao destinat?rio /*/
	oProcess:Start()

	/*/ Adicione as informac?es a serem inclu?das na rastreabilidade /*/
	cTexto := 'Enviando comunicacao de Finalizacao...'
	cCodStatus := '100400'
	oProcess:Track(cCodStatus, cTexto , cUsuarioWF) // Rastreabilidade

	oProcess:Finish()

Return

/*/
*****************************************************************************************************
*** Funcao: WFGERPRO   -   Autor: Leonardo Pereira   -   Data:                                    ***
*** Descricao: Gera formulario HTML para acesso via LINK.                                         ***
*****************************************************************************************************
/*/
Static Function WFGerPro(nOpc)

	Local cCodStatus, cHtmlModelo
	Local cUsuarioWF, cTexto
	Local cTitulo := If((nOpc == 1), 'Aprovacao do pedido de compra', 'Ranking da cotacao')
	Local oProcess, cCodProcesso, cAssunto

	/*/ Registra o nome do usu?rio corrente que est? criando o processo: /*/
	PswOrder(1)
	If (PswSeek(aDadosTXT[1, 8], .T.))
		aInfoUsu := PswRet(1)
	EndIf
	cUsuarioWF := aDadosTXT[1, 7]

	/*/ Gravando Registro de rastreabilidade do workflow /*/
	If WF3->(RecLock('WF3', .T.))
		WF3->WF3_FILIAL := xFilial('WF3')
		WF3->WF3_ID := If((nOpc == 1), aDadosTXT[1, 19], aDadosTXT[1, 16]) + '.01'
		WF3->WF3_PROC := If((nOpc == 1), 'APRPED', 'WFRKMC')
		WF3->WF3_STATUS := If(aDadosTXT[1, 23] == '1', '100500', '100600')
		WF3->WF3_HORA := Time()
		WF3->WF3_DATA := Date()
		WF3->WF3_USU := cUsuarioWF
		If (nOpc == 1)
			WF3->WF3_DESC := If(aDadosTXT[1, 23] == '1', 'Aprovando pedido de compra', 'Rejeitando pedido de compra')
		Else
			WF3->WF3_DESC := 'Realizando ranking das cota??es'
		EndIf
		WF3->(MsUnLock())
		u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Sucesso ao gravar rastreabilidade,' + If(aDadosTXT[1, 23] == '1', '100500', '100600'))
	EndIf

	If WF3->(RecLock('WF3', .T.))
		WF3->WF3_FILIAL := xFilial('WF3')
		WF3->WF3_ID := If((nOpc == 1), aDadosTXT[1, 19], aDadosTXT[1, 16]) + '.01'
		WF3->WF3_PROC := If((nOpc == 1), 'APRPED', 'WFRKMC')
		WF3->WF3_STATUS := '100800'
		WF3->WF3_HORA := Time()
		WF3->WF3_DATA := Date()
		WF3->WF3_USU := cUsuarioWF
		WF3->WF3_DESC := 'Finalizado'
		WF3->(MsUnLock())

		/*/ Fizaliza o processo de workflow /*/
		WFA->(DbSetOrder(2))
		If WFA->(DbSeek(xFilial('WFA') + If((nOpc == 1), aDadosTXT[1, 19], aDadosTXT[1, 16])))
			If WFA->(RecLock('WFA', .F.))
				WFA->WFA_TIPO := '4'
				WFA->(MsUnLock())
				u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] Sucesso ao gravar finalizacao')
			EndIf
		EndIf
	EndIf

Return

/*/
*****************************************************************************************************
*** Funcao: TxtToArr   -   Autor: Leonardo Pereira   -   Data: 02/12/2010                         ***
*** Descricao: Faz a leitura da linha do arquivo texto e adiciona em um array.                    ***
*****************************************************************************************************
/*/
Static Function TxtToArr(cTexto, cDelim)

	aRet := {}
	cFinal := ''
	nPosIni := 1
	nTamTxt := Len(cTexto)

	While .T.
		nCol := At(cDelim, SubStr(cTexto, nPosIni, nTamTxt))
		If (nCol == 0)
			cFinal := Upper(SubStr(cTexto, nPosIni, nTamTxt))
			If Empty(cFinal)
				Exit
			EndIf
		EndIf
		nPosFim := If(Empty(cFinal), (nCol - 1), Len(cFinal))
		aAdd(aRet, Upper(SubStr(cTexto, nPosIni, nPosFim)))
		nPosIni += If(Empty(cFinal), nCol, Len(cFinal))
	End

Return(aRet)
