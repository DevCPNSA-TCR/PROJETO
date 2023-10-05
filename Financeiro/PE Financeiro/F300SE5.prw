#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F300SE5  ºAutor  ³Yttalo P. Martins   º Data ³  08/10/14    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE executado ao final após gravação do movimento bancário deº±±
±±ºDesc.     ³desconto/juros/multa/valor                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FINA300                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F300SE5()

Local _nRecno := SE2->(Recno())
Local _cCC    := ""
Local _cChave := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA_+E2_TIPO+E2_FORNECE+E2_LOJA)
_aArea       := GetArea()
_aAreaSE2    := SE2->(GetArea())
_aAreaSE5    := SE5->(GetArea())

//conforme solicitação da Porto Novo, o centro de custo crédito será prrenchido com centro de custo débito, pois
//na ilcusão do PA o sistema não alimenta o centrod e custo na SE5 e a Porto Novo utilizada o E5_CCC para filtro

	DbSelectArea("SE5")
	SE5->(DbSetOrder(7))
	If SE5->(DbSeek(xFilial("SE5")+_cChave))
	
		While SE5->(!EOF()) .AND. SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA_+E5_TIPO+E5_CLIFOR+E5_LOJA)	== xFilial("SE5")+_cChave 				
	        
			If EMPTY(SE5->E5_CCC)
			
				_cCC := SE2->E2_CCD
				
				RecLock( "SE5", .F. )
				SE5->E5_CCC := _cCC
				SE5->E5_CCD := _cCC
				MsUnlock()
			
			EndIf
		
		SE5->(DbSkip())
		EndDo
	
	EndIf
	
	DbSelectArea("SE2")
	SE2->(DbGoTo(_nRecno))


RestArea(_aAreaSE5)
RestArea(_aAreaSE2)
RestArea(_aArea)

Return