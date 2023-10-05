/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CN130VLIN �Autor  �Fabio Flores        � Data � 28/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � permite que sejam implementadas valida��es espec�ficas     ���
���          � nos itens da medi��o na tabela CNE.                         ���
�������������������������������������������������������������������������͹��
���Uso       � Apos Confirma��o da Inclus�o / Modifica��o                 ���
�������������������������������������������������������������������������ͼ��
���Pe        �                                                            ���
���Pe        �                                                            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                  

#Include "TopConn.Ch"

User function CN130VLIN() 

Local aItm := PARAMIXB[1]
Local aArea:= GetArea() 
Local Lret := .T. 
  
DbSelectArea("CTT")
DbSetOrder(1)

if dbseek(xFilial("CTT")+alltrim(aItm[4])) 
   if CTT->CTT_BLOQ = "1"
      lret := .F. 
      msgalert("Ops! Centro de custo bloqueado!, informe um Centro de custo V�lido!") 
   endif 
else
   lret := .F.  
   msgalert("Ops! Centro de custo inexistente ou inv�lido!, informe um Centro de custo V�lido!") 
endif    
  
RestArea(aArea)   

return(lret)    
 
  
