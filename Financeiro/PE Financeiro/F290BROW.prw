#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F290BROW  �Autor  �Yttalo P. Martins   � Data �  15/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Filtrar registros no Faturas a Pagar                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �FINA290                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F290BROW()

_aArea := GetArea()

//Aplica filtro por C.Custo caso as condi��es sejam satisfeitas
U_PNA100( ALLTRIM(FunName()),, )

RestArea(_aArea)

Return