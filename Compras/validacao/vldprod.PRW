/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �         � Autor  �Fabio Flores        � Data � 06/10/12    ���
�������������������������������������������������������������������������͹��
���Desc.     � valida informa��es do produto no momento da entrada        ���
���          � do item na nota fiscal                                     ���
�������������������������������������������������������������������������͹��
���Uso       � COMPRAS - item nota fiscal                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                                

#INCLUDE "rwmake.ch"   
#INCLUDE "PROTHEUS.CH"     

user function vldprod() 

local lret := .T. 
       
IF SB1->B1_POSIPI=="9999.99.99"  .OR. SB1->B1_POSIPI=="9999.99.99" .OR. SB1->B1_POSIPI=="    .  .  " .OR. EMPTY(SB1->B1_POSIPI)
   lret := .F. 
   msgalert("Ops! C�digo de NCM n�o Classificado. Favor informar o NCM atrav�s do Cadastro de Produtos!")
endif
     
return(lret)


