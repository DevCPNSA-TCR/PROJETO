#Include 'totvs.ch'
/*
*******************************************************************************************************************************
*** Funcao: M150LEG   -   Autor: Leonardo Pereira   -   Data: 01/11/2010.                                                   ***
*** Descricao: Adiciona cores de status e descricao de leganda na rotina de atualizacao de cotacao.                         ***
*******************************************************************************************************************************
*/
User Function Mt150Leg()

	Local nNum := PARAMIXB[1]
	Local aRet := {}

	If (nNum == 1)
		aAdd(aRet, {"C8_FLAGWF == '1' .And. Empty(C8_NUMPED)", 'BR_PRETO'})
		aAdd(aRet, {"C8_FLAGWF == '2' .And. Empty(C8_NUMPED)", 'BR_MARRON'})
	ElseIf (nNum == 2)
		aAdd(aRet, {'BR_PRETO' , 'Workflow Enviado' })
		aAdd(aRet, {'BR_MARRON' , 'Cotacao Rejeitada' })
	EndIf

Return(aRet)