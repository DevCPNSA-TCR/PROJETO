#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA590BOR  �Autor  �Yttalo P. Martins   � Data �  19/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida se usu�rio e border� informado na manuten�� do border���
���          �pertence ao grupo materiais obras.                          ���
�������������������������������������������������������������������������͹��
���Uso       �FINA590                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA590BOR()

LOCAL _lRet     := .T.
LOCAL _cBordero := PARAMIXB[1]
LOCAL _cCart    := PARAMIXB[2]

_aArea := GetArea()

//Aplica filtro por C.Custo caso as condi��es sejam satisfeitas
If ALLTRIM(_cCart) == "P"

	_lRet := U_PNA100( ALLTRIM(FunName()),,_cBordero )
	_lRet := If(_lRet==nil, .T., _lRet)

Endif

RestArea(_aArea)

Return(_lRet)