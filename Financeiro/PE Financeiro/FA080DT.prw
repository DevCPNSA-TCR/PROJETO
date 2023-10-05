#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA080DT  �Autor  �Yttalo P. Martins   � Data �  29/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �O ponto de entrada FA080DT sera utilizado na validacao da   ���
���          �data da baixa do contas a pagar. O retorno .F. nao da       ���
���          �prosseguimento na rotina de baixa.                           ���
�������������������������������������������������������������������������͹��
���Uso       �FINA080                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA080DT()

LOCAL _lRet     := .T.
LOCAL _dDataBx  := PARAMIXB

_aArea := GetArea()

//Aplica filtro por banco caso as condi��es sejam satisfeitas
_lRet := U_PNA100( ALLTRIM(FunName()),, )
_lRet := If(_lRet==nil, .T., _lRet)

RestArea(_aArea)

Return(_lRet)