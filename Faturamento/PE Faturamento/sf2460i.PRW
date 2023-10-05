/*/
*+-------------------------------------------------------------------------+*
*|Funcao	  | SF2460I | Autor | Fagner Oliveira da Silva       		   |*
*+------------+------------------------------------------------------------+*
*|Data		  | 09.07.2014												   |*
*+------------+------------------------------------------------------------+*
*|Descricao   | Ponto de entranda na emissao da NF para preencher o campo  |*
*|            | flag que informa se o título é de um pedido de venda vindo |*
*|            | do Cherwell.                                               |*
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

*---------------------*
//User Function SF2460I(cKey)
User Function SF2460I()
*---------------------*
Local aArea    := GetArea()
Local aAreaSE1 := GetArea("SE1")
Local cFILSE1  := xFilial("SE1")
Local lPedCher  ///:= fPedCher()


//dbSelectArea("SF2")
//If dbSeek(cKey)
	lPedCher := fPedCher()
	dbSelectArea("SE1")
	
	If SE1->(dbSeek(cFILSE1+SF2->F2_PREFIXO+SF2->F2_DOC))
	
		While !Eof() .And. SE1->E1_FILIAL  == cFILSE1  ;
		             .And. SE1->E1_PREFIXO == SF2->F2_PREFIXO ;
		             .And. SE1->E1_NUM     == SF2->F2_DOC ;
		             .And. lPedCher
			Reclock("SE1",.F.)
				SE1->E1_XCHERWE := lPedCher
			MsunLock()
	
			SE1->(dbSkip())
			
		End
	
	EndIf

//Endif
	
RestArea(aArea)

Return

*------------------------*
Static Function fPedCher()
*------------------------*
Local aAreaSD2 := GetArea("SD2")
Local aAreaSC5 := GetArea("SC5")
Local lRet     := .F.

Local cFILSD2  := xFilial("SD2")
Local cFILSC5  := xFilial("SC5")

dbSelectArea("SC5")
dbSetOrder(1)

dbSelectArea("SD2")
dbSetOrder(3)

If dbSeek(cFILSD2+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)

	While SD2->(!Eof()) .And. SD2->D2_FILIAL  == SF2->F2_FILIAL  ;
						.And. SD2->D2_DOC     == SF2->F2_DOC     ;
						.And. SD2->D2_SERIE   == SF2->F2_SERIE   ;
						.And. SD2->D2_CLIENTE == SF2->F2_CLIENTE ;
						.And. SD2->D2_LOJA    == SF2->F2_LOJA

		If SC5->(dbSeek(cFILSC5+SD2->D2_PEDIDO))
			If SC5->C5_XCHERWE
				lRet := .T.
				Exit
			Endif
		Endif

		SD2->(dbSkip())

	End

EndIf

RestArea(aAreaSD2)
RestArea(aAreaSC5)

Return(lRet)