#INCLUDE "PROTHEUS.CH"

#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � PTNV001  � Autor � Ricardo Ferreira   �    Data � 14/10/2013 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Valida��o do campo RA_ADMISSA, n�o permitir que seja altera- ���
���          � do sem avisar que � necessario alterar a dt base de ferias   ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                 ���
���������������������������������������������������������������������������Ĵ��
���Parametros�                                                              ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Cadastro de Funcion�rios                                     ���
���������������������������������������������������������������������������Ĵ��
*/

User Function PTNV001()
Local lRet := .t.


DbSelectArea("SRF")
DbSetOrder(1)
IF DbSeek(xFilial("SRF")+M->RA_MAT)
	If M->RA_ADMISSA > SRF->RF_DATABAS
		lRet := .f.
		Alert("Data de admissao maior que a data base de f�rias! Favor ajustar a data base de f�rias na programa��o de f�rias antes de alterar a data de admiss�o!!")
	Endif
Endif


Return lRet