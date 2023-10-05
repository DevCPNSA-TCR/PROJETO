#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F080BROW  �Autor  �Yttalo P. Martins   � Data �  15/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Filtrar registros no Baixas a Pagar Manual                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �FINA080                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F080BROW()

_aArea := GetArea()

//Aplica filtro por C.Custo caso as condi��es sejam satisfeitas
U_PNA100( ALLTRIM(FunName()),, )

RestArea(_aArea)

Return