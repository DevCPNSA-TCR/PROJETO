#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  22/08/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Arqs \system\: CEFTCR.2re e CEFCPN.2re 

User Function inccnab(pCod,pAge,pCt,pSubCt)

pCod := PADR(ALLTRIM(pCod),tamsx3("EE_CODIGO")[1])
pAge := PADR(ALLTRIM(pAge),tamsx3("EE_AGENCIA")[1])
pCt  := PADR(ALLTRIM(pCt), tamsx3("EE_CONTA")[1])
pSubCt := PADR(ALLTRIM(pSubCt), tamsx3("EE_SUBCTA")[1])

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

//alert(xfilial("SEE")+" - "+pCod+" - "+pAge+" - "+pCt+" - "+pSubct )

DbSelectArea("SEE")      
DbSetOrder(1)
if DbSeek(XFILIAL("SEE")+pCod+pAge+pCt+pSubct)  
   reclock('SEE',.F.)
   SEE->EE_ULTDSK := SOMA1(SEE->EE_ULTDSK)
   SEE->(MSUNLOCK())
endif
 
Return('')
