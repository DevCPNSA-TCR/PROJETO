#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA300PA  ºAutor  ³Yttalo P. Martins   º Data ³  29/09/14 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE executado para gravação da SE5(PA e TAXA) no retorno do  º±±
±±ºDesc.     ³SISPAG                                                       º±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³FINA300                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA300PA()

Local _nRecno := SE5->(Recno())
Local _cCC    := ""
Local _cChave := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA_+E5_TIPO+E5_CLIFOR+E5_LOJA)

_aArea       := GetArea()
_aAreaSE2    := SE2->(GetArea())
_aAreaSE5    := SE5->(GetArea())

//conforme solicitação da Porto Novo, o centro de custo crédito será prrenchido com centro de custo débito, pois
//na baixa por devolução do PA o sistema não alimenta o centrod e custo na SE5 e a Porto Novo utilizada o E5_CCC para filtro
If EMPTY(SE5->E5_CCC)

	DbSelectArea("SE2")
	SE2->(DbSetOrder(1))
	If SE2->(DbSeek(xFilial("SE2")+_cChave))
	
		_cCC := SE2->E2_CCD
		
		RecLock( "SE5", .F. )
		SE5->E5_CCC := _cCC
		SE5->E5_CCD := _cCC
		MsUnlock()
			
	EndIf
	
	DbSelectArea("SE5")
	SE5->(DbGoTo(_nRecno))

EndIf


RestArea(_aAreaSE5)
RestArea(_aAreaSE2)
RestArea(_aArea)

Return