#Include 'totvs.ch'
#Include 'rwmake.ch'
#Include 'topconn.ch'
#Include 'tbiconn.ch'
#Include 'tbicode.ch'
#Include 'ap5mail.ch'
/*/
*****************************************************************************************************
*** Programa: PNMOVMAIL   -   Autor: Leonardo Pereira   -   Data:                                 ***
*** Descricao: Realiza omovimento dos arquivos de email para pasta de saida.                      ***
*****************************************************************************************************
/*/
User Function PNMovMail()

	Local lEnd := .F.
	Local aTabEnv := {'SAK', 'SC7', 'SC1', 'SCR', 'SCE', 'SCS', 'SAL', 'SA2', 'WF3', 'WFA', 'SY1', 'SE4', 'SB1'}
	
	u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ WFMOVMAIL - Inicio]')
	
	/*/ Inicializa o ambiente /*/
	RPCSetType(2)
	If (RPCSetEnv('01', '0101', 'userwf', 'wf123', 'COM',, aTabEnv, .F., .T., .T., .T.))
		/*/ Realiza a abertura da tabela de empresas /*/
		SM0->(DbGoTop())
		SM0->(DbSetOrder(1))
		While !SM0->(Eof())
			cEmpAnt := SM0->M0_CODIGO
			cFilAnt := AllTrim(SM0->M0_CODFIL)
			
			/*/ Realiza a leitura e processamento dos arquivos /*/
			WFMovMail(@lEnd)
			SM0->(DbSkip())
		End
	EndIf
	
	u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ WFMOVMAIL - Final]')

	/*/ Fecha o ambiente /*/
	RPCClearEnv()

Return

/*
*******************************************************************************************************
*** Programa: WFMOVMAIL   -   Autor: Leonardo Pereira   -   Data:                                   ***
*** Descricao: Realiza o movimento do arquivo de email para a pasta outbox.                         ***
*******************************************************************************************************
*/
Static Function WFMovMail(lEnd)

	Local aArqMAIL := {}
	Local nX := 0
	
	cDSrvORI := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\outbox\'
	cDSrvDES := '\workflow\emp' + cEmpAnt + '\mail\workflow porto novo\outbox\000000\'

	/*/ Faz a leitura dos arquivos. /*/
	aDir(cDSrvORI + '*.*', aArqMAIL)
	/*/ Verifica se existem arquivos para processar /*/
	For nX := 1 To Len(aArqMAIL)
		u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ WFMOVMAIL - Leitura de Arquivos]')
		/*/ Movimenta o arquivo para o diretorio de destino /*/
		If ((fRename(cDSrvORI + aArqMAIL[nX], cDSrvDES + aArqMAIL[nX]) == 0))
			u_xConOut('[' + DtoC(Date()) + '][' + Time() + '] [ WFMOVMAIL - Movendo Arquivo: ' + aArqMAIL[nX] + ' ]')
			//If ((fErase(cDSrvORI + aArqMAIL[nX]) == 0))
			//EndIf
		EndIf
	Next

Return
