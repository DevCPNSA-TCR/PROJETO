#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.Ch"
#DEFINE   c_ent      CHR(13)+CHR(10)

/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
���Programa  �PTNV002   �Autor  �Vinicius F.         � Data �  18/02/14   ����
�������������������������������������������������������������������������͹���
���Desc.     � 	rotina de valida��o das op��es escolhidas pelo usuario no  ���
���				pergunte da rotina de atualiza��o de cota��o.			   ���
���																		   ���
���Dever� ser ajustado o SX1 do grupo de perguntas MTA150 conforme abaixo: ���
���																		   ���
���		parametro 4 - MV_PAR04 - X1_VALID := U_PTNV002(MV_PAR04)           ���
���																		   ���
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/

User Function PTNV002(cPar)
Private lRet := .T.

If cPar<>2
	ALERT("Apenas permitida a exclus�o por cota��o favor ajustar o parametro da rotina.")
	lRet := .F.
Endif                     

Return lRet