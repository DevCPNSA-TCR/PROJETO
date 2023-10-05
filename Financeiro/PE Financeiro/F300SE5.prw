#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F300SE5  �Autor  �Yttalo P. Martins   � Data �  08/10/14    ���
�������������������������������������������������������������������������͹��
���Desc.     �PE executado ao final ap�s grava��o do movimento banc�rio de���
���Desc.     �desconto/juros/multa/valor                                  ���
�������������������������������������������������������������������������͹��
���Uso       �FINA300                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F300SE5()

Local _nRecno := SE2->(Recno())
Local _cCC    := ""
Local _cChave := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA_+E2_TIPO+E2_FORNECE+E2_LOJA)
_aArea       := GetArea()
_aAreaSE2    := SE2->(GetArea())
_aAreaSE5    := SE5->(GetArea())

//conforme solicita��o da Porto Novo, o centro de custo cr�dito ser� prrenchido com centro de custo d�bito, pois
//na ilcus�o do PA o sistema n�o alimenta o centrod e custo na SE5 e a Porto Novo utilizada o E5_CCC para filtro

	DbSelectArea("SE5")
	SE5->(DbSetOrder(7))
	If SE5->(DbSeek(xFilial("SE5")+_cChave))
	
		While SE5->(!EOF()) .AND. SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA_+E5_TIPO+E5_CLIFOR+E5_LOJA)	== xFilial("SE5")+_cChave 				
	        
			If EMPTY(SE5->E5_CCC)
			
				_cCC := SE2->E2_CCD
				
				RecLock( "SE5", .F. )
				SE5->E5_CCC := _cCC
				SE5->E5_CCD := _cCC
				MsUnlock()
			
			EndIf
		
		SE5->(DbSkip())
		EndDo
	
	EndIf
	
	DbSelectArea("SE2")
	SE2->(DbGoTo(_nRecno))


RestArea(_aAreaSE5)
RestArea(_aAreaSE2)
RestArea(_aArea)

Return