#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F240OK2  �Autor  �Yttalo P. Martins   � Data �  29/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �O ponto de entrada FA050PA ser� utilizado para valida��o do  �� 
���          �ok da tela de dados do border� de pagamentos                ���
�������������������������������������������������������������������������͹��
���Uso       �FINA240                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F240OK2()

LOCAL _lRet     := .T.

_aArea := GetArea()

//Aplica filtro por banco caso as condi��es sejam satisfeitas
_lRet := U_PNA100( ALLTRIM(FunName()),, )
_lRet := If(_lRet==nil, .T., _lRet)

RestArea(_aArea)

Return(_lRet)