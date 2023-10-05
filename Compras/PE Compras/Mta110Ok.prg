#Include 'totvs.ch'
/*
*******************************************************************************************************************************
*** Funcao: MTA110OK   -   Autor: Leonardo Pereira   -   Data: 01/11/2010.                                                  ***
*** Descricao: Realiza a validacao de todas as informacoes digitadas na tela de solicitacao.                                ***
*******************************************************************************************************************************
*/
User Function Mta110Ok()

	Local aCCSol := {}
	Local nPCCusto := aScan(aHeader, {|x| AllTrim(x[2]) == 'C1_CC'})
	Local nX := 0
	Local lRet := .T.
	Local lExist

	For nX := 1 To Len(aCols)
		If !(aCols[nX, Len(aCols[nX])])
			If (nX == 1)
				aAdd(aCCSol, aCols[nX, nPCCusto])
			Else
				lExist := (aScan(aCCSol, aCols[nX, nPCCusto]) > 0)
				If lExist
					Loop
				Else
					MsgAlert('Nao e PERMITIDO a inclusao de solicitacoes com diversos Centros de Custo!', 'Atencao!')
					lRet := .F.
					Return(lRet)
				EndIf
			EndIf
		EndIf
	Next

Return(lRet)