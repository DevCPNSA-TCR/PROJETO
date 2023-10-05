#Include 'totvs.ch'
#Include 'topconn.ch'
/*
******************************************************************************************************
*** Funcao: MT161PRO   -   Autor: Ricardo Ferreira  -   Data:  21/06/2017                           ***
*** Descricao: Processa o retorno do ranking do mapara de cotacao.                                 ***
******************************************************************************************************
10-05-2018 - NÃO USAR POIS A ANALISE DA COTAÇÃO SERÁ REALIZADA PELO ITEM DA COTAÇÃO. GMUD000777
*/   

 User Function MT161PRO()
//	Local aPropostas	:= PARAMIXB[1]
//	Local cQuery 		:= ""
//	Local cForVenc		:= Space(6)
//	Local cLjVenc		:= Space(2)


	
	/*------- Estrutura do Array de aPropostas --------*/

	//CABEÇALHO//
	//aPropostas[n]			: número da página
	//aPropostas[n,p]			: posição do pedido na página (1,2)
	//aPropostas[n,p,1,x]	: Dados do cabeçalho da proposta 
	//aPropostas[n,p,1,1 ]	: Cod Fornecedor 
	//aPropostas[n,p,1,2 ]	: Loja 
	//aPropostas[n,p,1,3 ]	: Nome 
	//aPropostas[n,p,1,4 ]	: Proposta 
	//aPropostas[n,p,1,5 ]	: Cond pagto 
	//aPropostas[n,p,1,6 ]	: Frete 
	//aPropostas[n,p,1,7 ]	: Valor total (soma de nCusto dos itens)
	//ITENS DA PROPOSTA// 
	//aPropostas[n,p,2,x]	: Itens da proposta 
	//aPropostas[n,p,2,x,1]	: Flag vencendor 
	//aPropostas[n,p,2,x,2]	: Item
	//aPropostas[n,p,2,x,3]	: Cod produto
	//aPropostas[n,p,2,x,4]	: Valor total (nCusto)
	//aPropostas[n,p,2,x,5]	: Data de entrega 
	//aPropostas[n,p,2,x,6]	: Observações
	//aPropostas[n,p,2,x,7]	: Filial Entrega 
	//aPropostas[n,p,2,x,8]	: Flag finalizado 
	//aPropostas[n,p,2,x,9]	: Recno SC8 

	/*------- -------------------------------------- --------*/

//	BeginSql Alias "TMPSCR"
//	%noparser%

//	SELECT TOP 1 CR_NUM,CR_TIPO,CR_STATUS,CR_RKN1,CR_RKN2,CR_RKN3,CR_RKN4,CR_RKN5,CR_USER 
//	FROM SCR010
//	WHERE CR_TIPO = 'MC' AND CR_NUM = %exp:SC8->C8_NUM% AND D_E_L_E_T_ = ' ' AND CR_STATUS = '03'
//	ORDER BY CR_NIVEL DESC

//	EndSql

//	If !TMPSCR->(Eof())
//		cForVenc 	:= SubStr(TMPSCR->CR_RKN1,1,6)
//		cLjVenc		:= SubStr(TMPSCR->CR_RKN1,8,2)

//		For x1 := 1 to Len(aPropostas)

//			For x2 := 1 to Len(aPropostas[x1])
//				IF Len(aPropostas[x1][x2][1]) > 0 // pode acontecer de criar a linha sem fornecedor dentro.
//					If aPropostas[x1][x2][1][1]/*Cod Fornecedor*/ + aPropostas[x1][x2][1][2] /*Loja Fornecedor*/ == cForVenc+cLjVenc

//						For x3 := 1 to Len(aPropostas[x1][x2][2]) /*Itens*/

//							aPropostas[x1][x2][2][x3][1] := .T.  //Marca o vencedor. Irá marcar todos os itens desse fornecedor, pois o ranking atual é por total da cotação.


//						Next
//					Else
//						For x3 := 1 to Len(aPropostas[x1][x2][2]) /*Itens*/

//							aPropostas[x1][x2][2][x3][1] := .F.  //Desmarca todos os outros fornecedores caso o sistema tenha escolhido diferente


//						Next

//					Endif
//				Endif
//			Next
//		Next


//	Else
//		Aviso("A V I S O ! ! !","Não foi encontrado ranking liberado para a Cotação. A escolha do vencedor seguiu as regras padrões do sistema",{"OK"})
//	Endif
//	DbSelectArea("TMPSCR")
//	DbCloseArea()


Return()
