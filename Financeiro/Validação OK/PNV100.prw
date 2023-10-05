#INCLUDE "topconn.ch"
#INCLUDE "Tbiconn.ch"
#include 'RWMAKE.CH'
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PNV100    �Autor  �Yttalo P. Martins   � Data �  15/09/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para valida�ao por filtro por CCusto(E2_CCD)         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PNV100(_cValor)

Local _aGrupo  := {}
Local _nX      := 1
Local _cGrupo  := ALLTRIM(GetNewPar("MV_XMTOBR",""))
Local _cCusto  := U_PNA100A()//Busca centros de custos que s�o de Materiais Obras
Local _lRet    := .T.

Default _cValor := &(ReadVar())

PswOrder(1)
If PswSeek( __cUserID, .T. )
  
    _aGrupo := PswRet()[1,10]   //grupos que o usuario pertence
    
    For _nX := 1 To  Len(_aGrupo)  //Busca os grupos q o usuario tem acesso
        
    	//Materiais Obras
	  	If ALLTRIM(_aGrupo[_nX]) == _cGrupo
	  	    
	  		If EMPTY(_cCusto) .OR. EMPTY(_cValor)
				Exit
			EndIf	  				
			  		
			If !(_cValor $_cCusto) .OR. _cCusto == "######"
	  	        
	  	    	MSGAlert("C.Custo n�o permitido. Verifique se pertence ao Grupo de Usu�rio: 'Materiais Obras' e Campo: 'Mat.Obras' no cadastro de Centro "+;
	  	    	"de Custos!")
	  			_lRet := .F.
	  		
	  		EndIf
	  	
	  		Exit
	  	
	  	Endif
	    	
  	Next
  	
EndIf

Return(_lRet)