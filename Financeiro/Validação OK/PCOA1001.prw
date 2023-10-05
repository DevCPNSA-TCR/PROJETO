#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE cEOL CHR(13) + CHR(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao	 �PCOA1001  �Autor  � YTTALO P MARTINS -    Data 12/01/12     ���
���Desc.     �Adiciona bot�o para importa��o de C.O.                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���Altera��es:  � 18/03/2015 Leonardo Freire - inclus�o do bota�o para    ���
���             �excluir o centro de custo por periodo.                   ��� 
���             �                                                         ��� 
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
*/

User Function PCOA1001()

Local _aRotina := {}

If ALLTRIM(FUNNAME()) == "PCOA100"
	
	 aAdd(_aRotina, {"Importar C.O.",  "U_PTNA050"	, 0, 4, 0, .F.} )
	 aAdd(_aRotina, {"Excluir C.C.",   "U_PTNA051"	, 0, 4, 0, .F.} )
	 
   //	_aRotina := {{ "Importar C.O.",  "U_PTNA050"	, 0, 4	}}      
	  
	
EndIf

Return(_aRotina)                 
