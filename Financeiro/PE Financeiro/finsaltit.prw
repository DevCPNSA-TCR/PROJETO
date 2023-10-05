/*/
*+-------------------------------------------------------------------------+*
*|Funcao	  | FINSALTIT | Autor | Fagner Oliveira da Silva       		   |*
*+------------+------------------------------------------------------------+*
*|Data		  | 09.07.2014												   |*
*+------------+------------------------------------------------------------+*
*|Descricao   | Ponto de entranda na baixa do titulo a receber. Fará a in- |*
*|            | tegração com o Webservice da cherwell caso o titulo seja   |*
*|            | oriundo do Cherwell.                                       |*
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

*-----------------------*
User Function FINSALTIT()
*-----------------------*
Local aAreaSE1 := GetArea("SE1")
Local aPagCher //:= fStrPag()

cRecN := SE1->(Recno())

U_CherSE1() 
                       
DbSelectArea("SE1")
DbGoto(cRecN)
aPagCher := fStrPag()

If SE1->E1_XCHERWE .And. Len(aPagCher) > 0
	U_CHEWSPAG(aPagCher[1,1], aPagCher[1,2], AllTrim(Str(nValRec)), DTOC(dBaixa), DTOC(DDATABASE), aPagCher[1,3], aPagCher[1,4])
EndIf

RestArea(aAreaSE1)

Return(0)

*-----------------------*
Static Function fStrPag()
*-----------------------*
Local aAreaSC5 := GetArea("SC5")
Local aAreaSD2 := GetArea("SD2")
Local aRet     := {}

Local cFILSD2  := xFilial("SD2")
Local cFILSC5  := xFilial("SC5")

dbSelectArea("SC5")
dbSetOrder(1)

dbSelectArea("SD2")
dbSetOrder(3)

//If dbSeek(cFILSD2+SE1->(E1_NUMNOTA+E1_SERIE+E1_CLIENTE+E1_LOJA))
If SD2->(dbSeek(cFILSD2+SE1->(E1_NUM+E1_SERIE+E1_CLIENTE+E1_LOJA)))

//						.And. SD2->D2_DOC     == SE1->E1_NUMNOTA ;

	While SD2->(!Eof()) .And. SD2->D2_FILIAL  == cFILSD2  ;
						.And. SD2->D2_DOC     == SE1->E1_NUM     ;
						.And. SD2->D2_SERIE   == SE1->E1_SERIE   ;
						.And. SD2->D2_CLIENTE == SE1->E1_CLIENTE ;
						.And. SD2->D2_LOJA    == SE1->E1_LOJA

		If SC5->(dbSeek(cFILSC5+SD2->D2_PEDIDO))
			If SC5->C5_XCHERWE
				AADD(aRet, {SC5->C5_XDELIN, SC5->C5_NUM , SD2->D2_DOC , SD2->D2_SERIE })
				Exit
			Endif
		Endif

		SD2->(dbSkip())

	End

EndIf

RestArea(aAreaSD2)
RestArea(aAreaSC5)

Return(aRet)