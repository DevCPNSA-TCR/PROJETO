
/*
-----------------------------------------------------------------------------------------------------
| FUNÇÃO: PNFORMC57                   | AUTOR: Felipe do Nascimento              | DATA: 28/01/2015 |
-----------------------------------------------------------------------------------------------------
| OBJETIVO: Get do CNPJ do fornecedor do titulo principal para os modelos 17. Retenção do INSS      |
|                                                                                                   |
-----------------------------------------------------------------------------------------------------
|                                     CONTROLE DE REVISÕES                                          |
-----------------------------------------------------------------------------------------------------
|    DATA    |         AUTOR          |                      OBJETIVO                               |
-----------------------------------------------------------------------------------------------------
| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
-----------------------------------------------------------------------------------------------------
*/
#Include 'protheus.ch'

#define _LF chr(32)+chr(13)

// cE2_NUM -> Caracter - Número da fatura que deseja retornar o fornecedor
// cE2_PREF -> Caracter - Prefixo da fatura que deseja retornar o fornecedor
// cVar    -> Caracter - Nome da variavel de campo que deseja retornar

user function PNFORMC57(cE2_NUM,cE2_PREF,cVar)

local cQry   := ""
local cRet   := ""
local lDebug := .f.
local cTMP   := getNextAlias()
local cTMP2  := getNextAlias()

cQry += _LF + "SELECT SE22.E2_FORNECE, SE22.E2_LOJA FROM " + retSQLName("SE2") + " SE22 "
cQry += _LF + "WHERE SE22.D_E_L_E_T_ = '' "
cQry += _LF + "AND SE22.E2_FILIAL = '" + xFilial("SE2") + "' "
cQry += _LF + "AND SE22.E2_PARCELA = '' "
cQry += _LF + "AND SE22.E2_NUM = ( "
cQry += _LF + "SELECT MAX(SE2.E2_NUM) FROM " + retSQLName("SE2") + " SE2 "
cQry += _LF + "WHERE SE2.D_E_L_E_T_ = SE22.D_E_L_E_T_ "
cQry += _LF + "AND SE2.E2_FILIAL = SE22.E2_FILIAL "
cQry += _LF + "AND SE2.E2_FATURA = '" + cE2_NUM + "' "
cQry += _LF + "AND SE2.E2_PREFIXO = '" + cE2_PREF + "' ) "

if lDebug
	autoGrLog(cQry)
	mostraErro()
endif

memowrite("Formula C57",cQry)

if select(cTMP) > 0; (cTMP)->(dbCloseArea()); endif
dbUseArea(.t., 'TOPCONN', TCGenQry(,,cQry), cTMP, .F., .T.)

if (cTMP)->(eof())
	
	cQry := ""
	cQry += _LF + "SELECT SE22.E2_FORNECE, SE22.E2_LOJA FROM " + retSQLName("SE2") + " SE22 "
	cQry += _LF + "WHERE SE22.D_E_L_E_T_ = '' "
	cQry += _LF + "AND SE22.E2_FILIAL = '" + xFilial("SE2") + "' "
	cQry += _LF + "AND SE22.E2_PARCELA = '' "
	cQry += _LF + "AND SE22.E2_NUM = ( "
	cQry += _LF + "SELECT MAX(SE2.E2_NUM) FROM " + retSQLName("SE2") + " SE2 "
	cQry += _LF + "WHERE SE2.D_E_L_E_T_ = SE22.D_E_L_E_T_ "
	cQry += _LF + "AND SE2.E2_FILIAL = SE22.E2_FILIAL "
	cQry += _LF + "AND SUBSTRING(SE2.E2_TITPAI,4,9) = '" + cE2_NUM + "' "
	cQry += _LF + "AND SUBSTRING(SE2.E2_TITPAI,1,3) = '" + cE2_PREF + "' ) "
	
	if lDebug
		autoGrLog(cQry)
		mostraErro()
	endif
	
	memowrite("Formula C57_2",cQry)
	
	If select(cTMP2) > 0; (cTMP2)->(dbCloseArea()); endif
	dbUseArea(.t., 'TOPCONN', TCGenQry(,,cQry), cTMP2, .F., .T.)
	
	if (cTMP2)->(eof())
		
		cRet := posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,cVar)
		
	Else
		
		cRet := posicione("SA2",1,xFilial("SA2")+(cTMP2)->E2_FORNECE+(cTMP2)->E2_LOJA,cVar)
	EndIf

	
else
	cRet := posicione("SA2",1,xFilial("SA2")+(cTMP)->E2_FORNECE+(cTMP)->E2_LOJA,cVar)
	
endif

If select(cTMP) > 0
	dbSelectArea(cTMP)
	(cTMP)->(dbCloseArea())
EndIf

If select(cTMP2) > 0
	dbSelectArea(cTMP2)
	(cTMP2)->(dbCloseArea())
EndIf

return(cRet)

/*
Abaixo seguem mundanças das formulas

*** C17 ***

Antes: "01"+IIF(SE2->E2_TIPO="INS","2631","2100")+SUBSTR(DTOS(SE2->E2_EMISSAO),5,2)+SUBSTR(DTOS(SE2->E2_EMISSAO),1,4)+FORMULA("C57")
Depois: "01"+IIF(SE2->E2_TIPO="INS","2631","2100")+SUBSTR(DTOS(SE2->E2_EMISSAO),5,2)+SUBSTR(DTOS(SE2->E2_EMISSAO),1,4)+u_PNFORMC57(SE2->E2_NUM, "A2_CGC")

*** C47 ***

Antes: SPACE(8)+SE2->E2_IDCNAB+SPACE(40)+FORMULA("C58")
Depois: SPACE(8)+SE2->E2_IDCNAB+SPACE(40)+u_PNFORMC57(SE2->E2_NUM, "A2_NOME")

*/

