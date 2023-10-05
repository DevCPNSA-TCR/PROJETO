
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110FIL  �Autor �Fabio Flores Regueira � Data �  01/10/2015���
�������������������������������������������������������������������������͹��
���Desc.     � Usu�rios que perten�am ao grupo de usu�rios (Almoxarifado) ���
���          � n�o poder� visualizar as cota��es.                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//*********************************
User Function MT160FIL()
//*********************************

Local cAliasSC8 := ParamIxb[1]
Local cFiltro := ""
Local lVisual := .T.
Local cUser	 := UsrRetName(__cUserId)
local _cGrupo := ALLTRIM(GetNewPar("MV_XGRPALM",""))  
local _nX:= 0
                 // Parametro que indica o codigo do grupo do usu�rio (ALMOXARIFADO).

PswOrder(1)

If PswSeek( __cUserID, .T. )
  
    _aGrupo := PswRet()[1,10]   //grupos que o usuario pertence
    
    For _nX := 1 To  Len(_aGrupo)  //Busca os grupos q o usuario tem acesso
        
    	// VERIFICA SE O USU�RIO EST� NO GRUPO DE ALMOXARIFADO. 

    	if ALLTRIM(_aGrupo[_nX]) == _cGrupo

           lVisual := .f. 
	       
         Endif 

    next 

endif 

if lvisual = .f. 

   cFiltro := "SC8->C8_XUSER = '" + cUser + "'"

   Aviso("ATEN��O","Usu�rio n�o possui acesso a visualiza��o da cota��o, pois o mesmo pertence ao Grupo de Almoxarifado!.",{"OK"})
   
endif 
 

Return (cFiltro)
