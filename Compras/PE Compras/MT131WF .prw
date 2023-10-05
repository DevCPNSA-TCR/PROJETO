
#Include 'totvs.ch'
#Include 'topconn.ch'
#Include 'protheus.ch'

/*
******************************************************************************************************
*** Funcao: MT131WF   -   Autor: Ricardo Ferreira   -   Data:29/06/2017                            ***
*** Descricao: Adiciona cores de status e descricao de leganda na rotina de atualizacao de cotacao.***
******************************************************************************************************
*/


User Function MT131WF()
Local cNumC8 	:= PARAMIXB[1]
Local aSc8Num 	:= PARAMIXB[2]
Local cUpd		:= ""
Local aArea		:= GetArea("SC8")

//Atualizacao de campos customizados no SC8

cUpd := "Update " + RetSqlName("SC8") + " SET " + chr(13)+chr(10)
cUpd += "C8_XCO = C1_XCO, C8_XNAT = C1_XNAT, C8_CONAPRO = 'B',C8_XUSER = '" + __cUserID + "',C8_MOEDA = 1,C8_APROV = DBL_GRUPO  " + chr(13)+chr(10)
cUpd += "from " + RetSqlName("SC8") + " SC8" + chr(13)+chr(10)
cUpd += "INNER JOIN " + RetSqlName("SC1") + " SC1 ON SC1.D_E_L_E_T_ = ' ' AND  C1_COTACAO = C8_NUM AND C1_ITEM = C8_ITEMSC" + chr(13)+chr(10)
cUpd += "INNER JOIN " + RetSqlName("DBL") + " DBL ON DBL.D_E_L_E_T_ = ' ' AND DBL_CC = C1_CC" + chr(13)+chr(10)
cUpd += "WHERE C8_FILIAL = '" + xFilial("SC8") + "' AND C8_NUM = '" + cNumC8 + "'" + chr(13)+chr(10)

If TcSQLExec(cUpd) < 0
	Alert("Erro na atualização do banco de dados!" + TcSQLError() )	
Endif


CQUERY := " SELECT C8_ITEM, C8_FORNECE, C8_LOJA, R_E_C_N_O_ AS RECN  " 
CQUERY += " FROM "+ RetSQLName("SC8")+ " SC8" + chr(13)+chr(10)
CQUERY += " WHERE   C8_FILIAL =  '" + xFilial("SC8") + "' " + chr(13)+chr(10)
cQuery += "  AND   C8_NUM = '"+cNumC8+"'  " + chr(13)+chr(10)
//CQUERY += "  AND   SC8.D_E_L_E_T_ =  ' '  " + chr(13)+chr(10)
CQUERY += "  ORDER BY C8_FORNECE, C8_LOJA, C8_ITEM " + chr(13)+chr(10)

TcQuery cQuery Alias "DIF" New

cCtrl := "" 
While DIF->(!Eof())     	
	If Empty(cCtrl) .OR. cCtrl <> DIF->C8_FORNECE+DIF->C8_LOJA		
		nLin := 0
		cCtrl := DIF->C8_FORNECE+DIF->C8_LOJA		
	Endif

	nLin := nLin+1

	//If STRZERO(nLin,TamSX3("C8_ITEM")[1]) <> DIF->C8_ITEM 
    //Alert("Ajustando o item "+AllTrim(STR(nLin))+" Fornecedor "+DIF->C8_FORNECE+DIF->C8_LOJA)

		DbSelectArea("SC8")                          
		DbGoTo(DIF->RECN)
		Reclock("SC8",.F.)
		SC8->C8_ITEM := STRZERO(nLin,TamSX3("C8_ITEM")[1]) 
		SC8->(MsUnlock())
	
	//Endif

	DIF->(DbSkip())
EndDo
DIF->(DbCloseArea())




RestArea(aArea)

Return
