#Include 'totvs.ch'
#INCLUDE "FILEIO.CH"
#INCLUDE "PROTHEUS.CH"
#DEFINE NTRYSEND 5
/*
*******************************************************************************************************************************
*** Funcao: MTA120E   -   Autor: Leonardo Pereira   -   Data:                                                               ***
*** Descricao: Realiza a exclusao dos processos de workflow                                                                 ***
*******************************************************************************************************************************
*/
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAutoLË+LË+¿
//³Autor: Yttalo P. Martins                    ³
//³Data: 13/03/15                              ³
//³Gestão da exclusão da rastreabilidade no ftp³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAutoÙ
ENDDOC*/  
User Function Mta120E()

	/*/ Configuracao do FTP - Para upload dos arquivos /*/
	Local cSrvFTP := 'ftp.portonovosa.com.br'
	Local cUsrFTP := 'doit@portonovosa.com.br'
	Local cPswFTP := 'P@ssw0rd'
	Local nPortaFTP := 21
	Local cDirFTP := ''
	Local lRet := .T.
	Local cArqHTM := ''
	Local cArqINF := ''
	Local aAreaSC7 := SC7->(GetArea())
	Local _cArqTemp2:=""
	Local _lRetFTP  := .F.
	local nTryS     := 1// variavel auxiliar para o numero de tentativas de envio	
	Local _lArqHTM  := .F.
	Local _lArqINF  := .F.	
	
	Private lAmbProd := (Upper(AllTrim(GetEnvServer())) $ AllTrim(GetMV('MV_XAMBIENT')))
	
	If lAmbProd
		cDirFTP := '/workflow/'
	Else
		cDirFTP := '/workflow/homologacao/'
	EndIf

	If (ParamIXB[1] == 1)
		If !Empty(SC7->C7_WFID)
			If (MsgYesNo('Este PEDIDO possui WORKFLOW enviado, deseja realmente exclui-lo ?', 'WORKFLOW'))
							
				/*/ Ecluindo Registro de rastreabilidade do workflow /*/
				cQryWF3 := 'DELETE ' + RetSQLName('WF3') + ' '
				cQryWF3 += "WHERE WF3_ID LIKE('%" + AllTrim(SC7->C7_WFID) + "%') "
				TcSQLExec(cQryWF3)

				/*/ Ecluindo Registro de rastreabilidade do workflow /*/
				cQryWFA := 'DELETE ' + RetSQLName('WFA') + ' '
				cQryWFA += "WHERE WFA_IDENT LIKE('%" + AllTrim(SC7->C7_WFID) + "%') "
				TcSQLExec(cQryWFA)
			Endif
		EndIf
	EndIf
	
	RestArea(aAreaSC7)

Return(lRet)