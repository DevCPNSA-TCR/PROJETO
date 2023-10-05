#Include 'totvs.ch'
/*
*******************************************************************************************************************************
*** Funcao: MT110LOK   -   Autor: Leonardo Pereira   -   Data: 01/11/2010.                                                  ***
*** Descricao: Realiza a validacao dos dados digitados na linha do grid da tela de solicitacoes.                            ***
*******************************************************************************************************************************
*/
User Function Mt110LOk()

	Local aCCSol := {}
	Local nPCCusto := aScan(aHeader, {|x| AllTrim(x[2]) == 'C1_CC'})
	Local nX := 0
	Local lRet := .T.
	Local lExist
	
   /* inserido por Felipe do Nascimento - 24/11/2014
      objetivo: Validar o campo observaÁ„oo C1_OBS quando utilizado o fornecedor e loja padr√£o do produto
      inicio B2
   */	
   local nPC1_FORNECE := aScan(aHeader,{|x| allTrim(x[2])=="C1_FORNECE"})
   local nPC1_LOJA    := aScan(aHeader,{|x| allTrim(x[2])=="C1_LOJA"})
   local nPC1_OBS     := aScan(aHeader,{|x| allTrim(x[2])=="C1_OBS"})
   local nPC1_PRODUTO := aScan(aHeader,{|x| allTrim(x[2])=="C1_PRODUTO"})
   local cMsg         := "AtenÁ„o ! Fornecedor padr„o selecionado. Favor justificar no campo de OBSERVA«√O a escolha do fornecedor padr„o."
   local cFornLoja
   local lMsgC1_OBS   := .f.
   
   /* fim B2 */
  
/*
	For nX := 1 To Len(aCols)
		If !(aCols[nX, Len(aCols[nX])])
			If (nX == 1)
				aAdd(aCCSol, aCols[nX, nPCCusto])
			Else
				lExist := (aScan(aCCSol, aCols[nX, nPCCusto]) > 0)
				If !lExist
					MsgAlert('Nao e PERMITIDO a inclusao de solicitacoes com diversos Centros de Custo!', 'Atencao!')
					lRet := .F.
				EndIf
			EndIf
		EndIf
	Next
*/
   
   /* inserido Felipe do Nascimento - 24/11/2014
      inicio B1
   */
   if (! empty(aCols[n][nPC1_FORNECE]) .or. ! empty(aCols[n][nPC1_LOJA]))
   
      cFornLoja := posicione("SB1", 1, xFilial("SB1")+aCols[n][nPC1_PRODUTO], "B1_PROC+B1_LOJPROC")
      
      if (cFornLoja == aCols[n][nPC1_FORNECE]+aCols[n][nPC1_LOJA])  .and. ; // informado fornecedor padr√£o do produto
         (vazio(aCols[n][nPC1_OBS]))                                        // obrigatorio informar justificativa no campo C1_OBS
         lRet := .f.
         lMsgC1_OBS := ! lRet
      endif
   endif
   
   if lMsgC1_OBS
      msgAlert(cMsg)
   endif
   
   /* fim B1 */
      
return(lRet)