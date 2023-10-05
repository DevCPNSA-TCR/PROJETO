#Include 'rwmake.ch'
#Include 'protheus.ch'
#Include 'topconn.ch'
/*/
******************************************************************************************************
*** Funcao: ATUCPODAT   -   Autor: Leonardo Pereira   -   Data:                                    ***
*** Descricao: Gravar a data da ultima Aprovacao no SC7                                            ***
******************************************************************************************************
/*/
User Function AtuCpoDat()
	
	If (Select('TMPSC7') > 0)
		TMPSC7->(DbCloseArea())
	EndIf
	cQry := 'SELECT DISTINCT C7_FILIAL, C7_NUM '
	cQry += 'FROM ' + RetSQLName('SC7') + ' '
	cQry += "WHERE D_E_L_E_T_ = ' ' "
	TcQuery cQry NEW ALIAS 'TMPSC7'
	TMPSC7->(DbGoTop())
	While !TMPSC7->(Eof())
		If (Select('TMPSCR') > 0)
			TMPSCR->(DbCloseArea())
		EndIf
		
		cQry := 'SELECT MAX(CR_DATALIB) CR_ULTAPV '
		cQry += 'FROM ' + RetSQLName('SCR') + ' '
		cQry += "WHERE CR_TIPO = 'PC' "
		cQry += "AND CR_FILIAL = '" + TMPSC7->C7_FILIAL + "' "
		cQry += "AND CR_NUM = '" + TMPSC7->C7_NUM + "' "
		TcQuery cQry NEW ALIAS 'TMPSCR'
		TMPSCR->(DbGoTop())
		If !TMPSCR->(Eof())
			If !(Empty(TMPSCR->CR_ULTAPV))
				cQry := ' UPDATE ' + RetSQLName('SC7') + ' '
				cQry += ' SET C7_XDATALI = ' + TMPSCR->CR_ULTAPV + ' '
				cQry += " WHERE D_E_L_E_T_ = ' ' "
				cQry += " AND C7_FILIAL = '" + TMPSC7->C7_FILIAL + "' "
				cQry += " AND C7_NUM = '" + TMPSC7->C7_NUM + "' "
				TcSqlExec(cQry)
			EndIf
		EndIf
		TMPSC7->(DbSkip())
	End
	
Return