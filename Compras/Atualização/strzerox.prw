#INCLUDE "RWMAKE.ch"
#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �strzerox    � Autor � Marcelo Amaral   � Data �  09/12/11   ��� 
�������������������������������������������������������������������������͹��
���Descricao � Preenche campo com zeros a esquerda                        ���
�������������������������������������������������������������������������͹��
���Uso       � Brasil PCH                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function strzerox(nTam)

Local aArea     := GetArea()     
Local cVarTxt   := &(readvar())
Local cVarTxt2  := ""
Local nCont     := 0
// Inclu�do por Peder Munksgaard (Criare Consulting) 05/05/2015
Local _lRet     := .T.
// Fim inclus�o.

Default nTam   := 0

if alltrim(cVarTxt) <> ""
    
	for nCont := 1 to Len(alltrim(cVarTxt))
		if substr(alltrim(cVarTxt),nCont,1) $ "0123456789"
			cVarTxt2 := cVarTxt2 + substr(alltrim(cVarTxt),nCont,1)
		endif
	next
	cVarTxt := cVarTxt2
	
	cVarTxt := strzero(val(alltrim(cVarTxt)),if(nTam <> 0, nTam, TamSX3(substr(readvar(),4,len(readvar())-3))[1]))

endif

// Inclu�do por Peder Munksgaard (Criare Consulting) 05/05/2015
If Empty(cVarTxt) .Or. cVarTxt == Replicate("0",TamSX3("F1_DOC")[1])

   _lRet   := .F.
   cVarTxt := Space(TamSX3("F1_DOC")[1])
      
Endif
// Fim inclus�o.

&(readvar()) := cVarTxt

RestArea(aArea)

Return _lRet //cVarTxt