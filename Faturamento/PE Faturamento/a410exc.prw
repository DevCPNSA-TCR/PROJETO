
#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"
#INCLUDE "topconn.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "rwmake.ch"

/*****************************************************************************
** Funcao   : A410EXC  Autor : 	Vinicius Figueiredo   Data : 16/06/14        *
******************************************************************************
** Ponto de entrada na exclusão do pedido de venda   **
Objetivo: consumir o WS do CHERWELL de exclusão de faturamento.
caso o retorno do WS seja negativo a exclusão deverá ser impedida no Protheus

Dados do WS
Acesso ao ambiente de testes:

http://lestcon.dnsalias.com:8080/tcrintegra/cherwellintegration.asmx
http://lestcon.dnsalias.com:8080/tcrintegra/cherwellintegration.asmx?wsdl

Dados do serviço:
WSCherwellIntegration
UpdateCancelPGMT

-retorno cUpdateCancelPGMTResult
-envio   cCD_PEDIDO

****************************************************************************/

USER FUNCTION A410EXC
Local l_ret := .T.
&& Esta rotina foi comentado para não ser executada neste PE.
&& O código será copiado e movido para o PE MT410TOK.
/*
Local ctip := "05"
cXNum := SC5->C5_NUM //Essa variavél é a chave que será passada ao cherwell
nCDelin := SC5->C5_XDELIN
cMens := "Faturamento excluido" 

//WSDLDbgLevel(2)	

oSvc := WSCherwellIntegration():New() //Alterar o nome do serviço a ser consumido	
oSvc:cCD_PEDIDO := cXNum

oSvc:UpdateCancelPGMT()

If oSvc:cUpdateCancelPGMTResult == "NOK" .OR. oSvc:cUpdateCancelPGMTResult == NiL    //Testar o metodo de update que sera disponibilizado no cherwell
	//caso não consiga realizar o update no cherwell o PV não deve ser excluído no Protheus.		
	cMens := "Erro exc fat ret WS: "+AllTrim(SubSTR(GetWSCError(),1,170))
	CONOUT(cMens)
	l_ret := .F.                                                     
	Alert("Não será possivel excluir o pedido pois não foi possivel integrar a exclusão ao Cherwell. Favor entrar em contato com o Administrador do sistema!")
		
Endif

U_CherLog(ctip, cXNUM, dDatabase, cMens , nCDelin  )            
*/
RETURN L_RET