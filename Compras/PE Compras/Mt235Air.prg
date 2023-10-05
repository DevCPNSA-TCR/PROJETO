#Include 'totvs.ch'
#Include 'topconn.ch'
/*/
******************************************************************************************************
*** Funcao: MT235AIR   -   Autor: Leonardo Pereira   -   Data:                                     ***
*** Descricao: Gravar a data da ultima aprovacao no SC7                                            ***
******************************************************************************************************
/*/
User Function Mt235Air()

	Local cQry := ''
	
	If (ParamIXB[2] == 1)
		If (Select('TMPAPV') > 0)
			TMPAPV->(DbCloseArea())
		EndIf
		cQry := 'SELECT MAX(CR_DATALIB) CR_ULTAPV '
		cQry += 'FROM ' + RetSQLName('SCR') + " WHERE CR_TIPO = 'PC' "
		cQry += "AND CR_FILIAL = '" + SC7->C7_FILIAL + "' "
		cQry += "AND CR_NUM = '" + SC7->C7_NUM + "' "
		TcQuery cQry NEW ALIAS 'TMPAPV'
		TMPAPV->(DbGoTop())
		If !TMPAPV->(Eof())
			RecLock('SC7', .F.)
			SC7->C7_XDATALI := StoD(TMPAPV->CR_ULTAPV)
			SC7->(MsUnLock())
		EndIf
	EndIf

Return