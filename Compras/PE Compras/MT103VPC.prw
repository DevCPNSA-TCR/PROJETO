#include "protheus.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "TopConn.ch"
#DEFINE   c_ent      CHR(13)+CHR(10)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������vivi������������������
���Programa  �MT103VPC   �Autor  � Roberto Lima      � Data �  24/01/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada do bot�o "Pedido" e "Item Ped" do Documen-���
���          � to de Entrada e Pre-Nota para realizar filtro dos Pedidos  ���  
���          � Compras. Ser�o filtrados somente os PCs que o campo        ���  
���          � C7_CONAPRO esteja com "L",ou seja,os pedido que            ��� 
���          � liberados                                          .       ���
�������������������������������������������������������������������������͹��
���Uso       � SIGACOM                                                    ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT103VPC()
Local aArea 	:= GetArea()
Local lRet		:= .T.
        

IF SC7->C7_CONAPRO = "L"
  Lret := .T.
Else
  lRet := .F.
Endif
RestArea(aArea)
Return lRet