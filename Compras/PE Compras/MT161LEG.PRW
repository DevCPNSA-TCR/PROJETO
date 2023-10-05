#Include 'totvs.ch'
/*
**************************************************************************************************
*** Funcao: M160LEG   -   Autor: Leonardo Pereira   -   Data: 01/11/2010.                      ***
*** Descricao: Adiciona cores de status e descricao de leganda na rotina de analise de cotacao.***
**************************************************************************************************
*/
User Function MT161LEG()

Local aNewCores := aClone(PARAMIXB[1])

//aAdd(aLegenda, {'BR_MARRON', 'Cotacao Rejeitada'})
aAdd(aNewCores, {"C8_FLAGWF=='2'.And.Empty(C8_NUMPED)", 'BR_MARRON','Cotação Rejeitada'})

/*/ Modifica a condicao do STATUS ENABLE /*/
//aNewCores[1][1] := "Empty(C8_NUMPED).And.C8_PRECO<>0.And.!Empty(C8_COND).And.C8_FLAGWF=='1'"  



Return(aNewCores)