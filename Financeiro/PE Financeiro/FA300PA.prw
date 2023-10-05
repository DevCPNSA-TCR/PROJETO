#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA300PA  �Autor  �Yttalo P. Martins   � Data �  29/09/14 ���
�������������������������������������������������������������������������͹��
���Desc.     �PE executado para grava��o da SE5(PA e TAXA) no retorno do  ���
���Desc.     �SISPAG                                                       ��
�������������������������������������������������������������������������͹��
���Uso       �FINA300                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA300PA()

Local _nRecno := SE5->(Recno())
Local _cCC    := ""
Local _cChave := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA_+E5_TIPO+E5_CLIFOR+E5_LOJA)

_aArea       := GetArea()
_aAreaSE2    := SE2->(GetArea())
_aAreaSE5    := SE5->(GetArea())

//conforme solicita��o da Porto Novo, o centro de custo cr�dito ser� prrenchido com centro de custo d�bito, pois
//na baixa por devolu��o do PA o sistema n�o alimenta o centrod e custo na SE5 e a Porto Novo utilizada o E5_CCC para filtro
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