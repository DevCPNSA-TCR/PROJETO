/*/
*+-------------------------------------------------------------------------+*
*|Funcao	  | MT410TOK | Autor | Fagner Oliveira da Silva       		   |*
*+------------+------------------------------------------------------------+*
*|Data		  | 01.07.2014												   |*
*+------------+------------------------------------------------------------+*
*|Descricao   | Ponto de entranda para validação do pedido de venda.       |*
*|            | Retorna .T. se for bem sucedido e .F. se houver críticas   |*
*+------------+------------------------------------------------------------+*
*|Solicitante | 														   |*
*+------------+------------------------------------------------------------+*
*|Arquivos	  | 														   |*
*+------------+------------------------------------------------------------+*
*|             ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            |*
*+-------------------------------------------------------------------------+*
*| Programador       |   Data   | Motivo da alteração                      |*
*+-------------------+----------+------------------------------------------+*
*|                   |          |                                          |*
*+-------------------+----------+------------------------------------------+*
/*/

#INCLUDE "PROTHEUS.CH"

*----------------------*
User Function MT410TOK()
*----------------------*
Local aArea     := GetArea()
Local lRet      := .T.
Local aParam    := ParamIXB

u_xConOut("MT410TOK - aParam[1]: "+str(aParam[1]) )

&& Só valida se for pedido do cherwell
If M->C5_XCHERWE
	If Altera
		lRet := fValCher()
	ElseIf !Inclui .And. !Altera .And. aParam[1]==1
		lRet := fExcCher()
	EndIf
EndIf

RestArea(aArea)

Return(lRet)

*------------------------*
Static function fValCher()
*------------------------*
Local aAreaSC6  := GetArea("SC6")

Local cFilSC6   := xFilial("SC6")
Local cMsg      := ""

Local lRet      := .T.

Local nPPedido  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUM"     })
Local nPItem	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"    })
Local nPProd    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" })
Local nPTES		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"     })
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"  })
Local nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"  })
Local nPValor   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"   })
Local nLenAcols := Len(aCols)
Local nPosAcols := 0
local nI :=0

For nI := 1 To Len(aCols)

	If aCols[nI][Len(aCols[nI])]

		lRet := .F.
		cMsg := "O item do pedido não pode ser deletado!"
		
	Else
		dbSelectArea("SC6")
		dbSetOrder(1)
	
		If dbSeek(cFilSC6+M->C5_NUM+aCols[nI][nPItem]+aCols[nI][nPProd])
	
			If AllTrim(aCols[nI][nPProd]) == AllTrim(SC6->C6_PRODUTO)
	
				If aCols[nI][nPTES] == SC6->C6_TES
	
					If aCols[nI][nPQtdVen] == SC6->C6_QTDVEN
	
						If aCols[nI][nPPrcVen] == SC6->C6_PRCVEN
	
							If aCols[nI][nPValor] <> SC6->C6_VALOR
	
								lRet := .F.
								cMsg := "O total do pedido não pode ser alterado!"
	
							EndIf
	
						Else
	
							lRet := .F.
							cMsg := "O preço unitário do pedido não pode ser alterado!"
	
						EndIf
	
					Else
	
						lRet := .F.
						cMsg := "A quantidade do pedido não pode ser alterado!"
	
					EndIf
	
				Else
	
					lRet := .F.
					cMsg := "O TES do pedido não pode ser alterado!"
	
				EndIf
	
			Else
	
				lRet := .F.
				cMsg := "O produto do pedido não pode ser alterado!"
	
			EndIf
	
		Else
	
			lRet := .F.
			cMsg += " O ítem não foi localizado!"
	
		EndIf

	EndIf

	If !lRet
		nPosAcols := nI
		nI := nLenAcols
	EndIf
Next

RestArea(aAreaSC6)

If !lRet

	cMsg += " Pedido de integração CHERWELL. Verifique o ítem [" + StrZero(nPosAcols,4) + "]."
	ApMsgAlert(cMsg)

EndIf

Return(lRet)

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
&& Este trecho do programa foi copiado do arquivo A410EXC.PRW desenvolvido pelo Vinicius.
&& Essa troca foi efetuada para que apenas após a confirmação da exclusão do pedido de venda
&& fosse feita a integração com o Cherwell.

*------------------------*
Static Function fExcCher()
*------------------------*
Local lRet    := .T.
Local cTip    := "05"
Local cXNum   := M->C5_NUM 			//Essa variavél é a chave que será passada ao cherwell
Local cDelin  := M->C5_XDELIN
Local cMens   := "Faturamento excluido"              
Local cSta := "Sucesso"

oSvc := WSCherwellIntegration():New() 	//Alterar o nome do serviço a ser consumido	
oSvc:cCD_PEDIDO := SC5->C5_NUM

oSvc:UpdateCancelPGMT()

If oSvc:cUpdateCancelPGMTResult == "NOK" .Or. oSvc:cUpdateCancelPGMTResult == Nil    //Testar o metodo de update que sera disponibilizado no cherwell
	//caso não consiga realizar o update no cherwell o PV não deve ser excluído no Protheus.		
	cMens := "Erro exc fat ret WS: "+AllTrim(SubSTR(GetWSCError(),1,170))
	u_xConOut(cMens)
	lRet := .F. 
	cSta := "Erro"
	                                                    
	Alert("Não será possivel excluir o pedido pois não foi possivel integrar a exclusão ao Cherwell. Favor entrar em contato com o Administrador do sistema!")
		
EndIf

U_CherLog(cTip, cXNUM, dDatabase, cMens , cDelin , cSta  )            

Return lRet
