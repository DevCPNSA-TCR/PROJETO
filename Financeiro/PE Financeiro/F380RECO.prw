#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F380RECO  �Autor  �Yttalo P. Martins   � Data �  22/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �PE executado durante a gravacao do E5_OK para marcacao.     ���
���          �do titulo como reconciliado.                                ���
�������������������������������������������������������������������������͹��
���Uso       �FINA380                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F380RECO()

_aArea := GetArea()

//Aplica filtro por C.Custo caso as condi��es sejam satisfeitas
U_PNA100( ALLTRIM(FunName()),, )

RestArea(_aArea)

Return