#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F080EST  �Autor  �Yttalo P. Martins   � Data �  08/10/14    ���
�������������������������������������������������������������������������͹��
���Desc.     �PE executado ao final da grava��o do cancelamento da baixa  ���
�������������������������������������������������������������������������͹��
���Uso       �FINA080                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F080EST()

Local _nRecno := SE5->(Recno())
Local _cCC    := ""
Local _cChave := SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA_+E5_TIPO+E5_CLIFOR+E5_LOJA)
_aArea       := GetArea()
_aAreaSE5    := SE5->(GetArea())

//conforme solicita��o da Porto Novo, o centro de custo cr�dito ser� prrenchido com centro de custo d�bito, pois
//na ilcus�o do PA o sistema n�o alimenta o centrod e custo na SE5 e a Porto Novo utilizada o E5_CCC para filtro

DbSelectArea("SE5")
SE5->(DbSetOrder(7))
SE5->(DbSeek(_cChave))					

_cCC := SE5->E5_CCC

SE5->(DbGoTo(_nRecno))

RecLock( "SE5", .F. )
SE5->E5_CCC := _cCC
SE5->E5_CCD := _cCC
MsUnlock()

RestArea(_aAreaSE5)
RestArea(_aArea)

Return