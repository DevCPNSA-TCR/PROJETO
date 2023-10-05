#Include 'totvs.ch'
/*
*******************************************************************************************************************************
*** Funcao: MT120BRW   -   Autor: Leonardo Pereira   -   Data:                                                              ***
*** Descricao: Adiciona nova rotina ao menu de contexto da rotina de atualizacao de cotacao.                                ***
*******************************************************************************************************************************
*/
User Function Mt120Brw()

//Define Array contendo as Rotinas a executar do programa
// ----------- Elementos contidos por dimensao ------------
// 1. Nome a aparecer no cabecalho
// 2. Nome da Rotina associada
// 3. Usado pela rotina
// 4. Tipo de Transa??o a ser efetuada
	//    1 - Pesquisa e Posiciona em um Banco de Dados
	//    2 - Simplesmente Mostra os Campos
	//    3 - Inclui registros no Bancos de Dados
	//    4 - Altera o registro corrente
	//    5 - Remove o registro corrente do Banco de Dados
	//    6 - Altera determinados campos sem incluir novos Regs	
	nPosWFAtu := aScan(aRotina, {|x| AllTrim(x[1]) == 'Alterar'})
	nPosWFExc := aScan(aRotina, {|x| AllTrim(x[1]) == 'Excluir'})
	
	/*/ Verifica se é possivel atualizar o pedido /*/
	aRotina[nPosWFAtu, 2] := 'U_WF120Atu()'
	
	/*/ Verifica se é possivel excluir o pedido /*/
	aRotina[nPosWFExc, 2] := 'U_WF120Exc()'
	
Return


/*
*******************************************************************************************************************************
*** Funcao: WF150ATU   -   Autor: Leonardo Pereira   -   Data:                                                              ***
*** Descricao: Verifica se é possivel a alteracao do pedido de compra                                                       ***
*******************************************************************************************************************************
*/
User Function WF120Atu()

	If !(Empty(SC7->C7_WFID))
		IF Aviso("WORKFLOW","Este pedido possui WORKFLOW enviado, TEM CERTEZA que deseja altera-lo ?",{"Sim","N�o"}) = 1
			A120Pedido('SC7', SC7->(Recno()), 4)
		Else
		
			Return
		Endif
	Else
		A120Pedido('SC7', SC7->(Recno()), 4)
	EndIf

Return

/*
*******************************************************************************************************************************
*** Funcao: WF150EXC   -   Autor: Leonardo Pereira   -   Data:                                                              ***
*** Descricao: Verifica se é possivel a exclusao do pedido de compra.                                                       ***
*******************************************************************************************************************************
*/
User Function WF120Exc()
	
	If !Empty(SC7->C7_WFID)
		If (MsgYesNo('Este pedido possui WORKFLOW enviado, deseja realmente exclui-lo ?', 'WORKFLOW'))
			A120Pedido('SC7', SC7->(Recno()), 5)
		EndIf
	Else
		A120Pedido('SC7', SC7->(Recno()), 5)
	EndIf
	
Return