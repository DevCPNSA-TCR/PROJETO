#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F450GRAVA  �Autor  �Yttalo P. Martins   � Data �  16/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Filtrar registros na compensa��o em carteiras ap�s grava��o ���
���          �da tabela tempor�ria para apresenta��o no markbrowse        ���
�������������������������������������������������������������������������͹��
���Uso       �FINA450                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F450GRAVA()

Local _nPagar := 0
_aArea := GetArea()


//Aplica filtro por C.Custo caso as condi��es sejam satisfeitas

If PARAMIXB[1] == "SE2"   // Fabio - 29/01/2015 - corre��o do erro na compensa��o entre carteiras. 
// If PARAMIXB == "SE2"  
	U_PNA100( ALLTRIM(FunName()),@_nPagar, )
	
	If _nPagar > 0
	    
		//vari�el private usado antes do F450GRAVA para incrementar valo a pagar
		nTotalP -= _nPagar
	
	EndiF 
EndIf

RestArea(_aArea)

Return