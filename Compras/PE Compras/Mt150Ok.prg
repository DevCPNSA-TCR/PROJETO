#Include 'totvs.ch'
/*
*******************************************************************************************************************************
*** Funcao: MT150OK   -   Autor: Leonardo Pereira   -   Data:                                                               ***
*** Descricao: Realiza a validacao dos dados digitados na linha do grid da tela de atualizacao de cotacao                   ***
*******************************************************************************************************************************
*/
User Function Mt150Ok()

	Local lRet := .T.
	Local nPPrazo 	:= aScan(aHeader, {|x| AllTrim(x[2]) == 'C8_PRAZO'})
	Local nPTotal 	:= aScan(aHeader, {|x| AllTrim(x[2]) == 'C8_TOTAL'})
	Local nPTES 	:= aScan(aHeader, {|x| AllTrim(x[2]) == 'C8_TES'})
	Local aPrazo := {}
	Local nX := 0
	Local lFirst := .T.
	Local nVlTot	:= 0
	Local lObrigat := .f.
	If (ParamIXB[1] == 2) .Or. (ParamIXB[1] == 3)
		/*/ Procura grupo de aprovacao /*/
		For nX := 1 To Len(aCols)
			If lFirst
				aAdd(aPrazo, aCols[nX, nPPrazo])
				lFirst := .F.
			Else
				If (aScan(aPrazo, aCols[nX, nPPrazo]) == 0)
					MsgAlert('Nao e permitido digitar DIVERSOS prazos de entrega para a mesma COTACAO/FORNECEDOR' + Chr(13) +;
					'Ajuste o prazo do ITEM: ' + StrZero(nX, 4), 'Atencao!')
					lRet := .F.
				EndIf
			EndIf
			//Soma o total dos itens
			nVlTot += aCols[nX, nPTotal]
			//Validar se o campo tes e prazo estão preenchidos em todas as linhas
			If aCols[nX, nPPrazo] = 0 //.or. Empty(aCols[nX, nPTES])
				lObrigat := .t.
			Endif
		Next


		If a150Var[1] <> nVlTot
			lRet:= .f.
			MsgAlert("O total dos itens não foi atualizado no total da cotação (RODAPÉ)" + Chr(13) +;
			"É importante pressionar Enter no campo TOTAL em todos os itens!!", 'Atencao!')
		Endif

		If lObrigat
			//MsgAlert('É obrigatório preencher os campos TES e Prazo em todos os itens.' , 'Atencao!')
			MsgAlert('É obrigatório preencher o campo Prazo em todos os itens.' , 'Atencao!')
			lRet := .F.
		Endif
	EndIf


	//a150Var[8]
	//VALIDAR O VALOR TOTAL SOMANDO AS LINHAS COM O QUE ESTÁ NA VARIAVEL
	//CRITICAR QUANDO NÃO ESTIVER BATENDO


Return(lRet)