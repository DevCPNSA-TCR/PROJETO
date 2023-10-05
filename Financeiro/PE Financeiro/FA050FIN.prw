#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050FIN  ºAutor  ³Yttalo P. Martins   º Data ³  08/10/14    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE executado ao final da gravação do título a pagar         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FINA050                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA050FIN()

Local _nRecno := SE2->(Recno())
Local _cCC    := ""
Local _cChave := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA_+E2_TIPO+E2_FORNECE+E2_LOJA)
_aArea       := GetArea()
_aAreaSE2    := SE2->(GetArea())
_aAreaSE5    := SE5->(GetArea())

//conforme solicitação da Porto Novo, o centro de custo crédito será prrenchido com centro de custo débito, pois
//na ilcusão do PA o sistema não alimenta o centrod e custo na SE5 e a Porto Novo utilizada o E5_CCC para filtro
If "PA" $ SE2->E2_TIPO

	DbSelectArea("SE5")
	SE5->(DbSetOrder(7))
	If SE5->(DbSeek(xFilial("SE5")+_cChave))					
	
		_cCC := SE2->E2_CCD
		
		RecLock( "SE5", .F. )
		SE5->E5_CCC := _cCC
		SE5->E5_CCD := _cCC
		MsUnlock()
	
	EndIf
	
	DbSelectArea("SE2")
	SE2->(DbGoTo(_nRecno))

EndIf

RestArea(_aAreaSE5)
RestArea(_aAreaSE2)
RestArea(_aArea)

Return