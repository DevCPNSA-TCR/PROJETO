#INCLUDE "topconn.ch"
#INCLUDE "Tbiconn.ch"
#include 'RWMAKE.CH'
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PNV101    ºAutor  ³Yttalo P. Martins   º Data ³  15/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para validaçao por banco(E5_BANCO|E5_AGENCIA|E5_CONTA)±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PNV101()

Local _aGrupo  := {}
Local _nX      := 1
Local _cGrupo  := ALLTRIM(GetNewPar("MV_XMTOBR",""))
Local _lRet    := .T.

PswOrder(1)
If PswSeek( __cUserID, .T. )
  
    _aGrupo := PswRet()[1,10]   //grupos que o usuario pertence
    
    For _nX := 1 To  Len(_aGrupo)  //Busca os grupos q o usuario tem acesso
        
    	//Materiais Obras
	  	If ALLTRIM(_aGrupo[_nX]) == _cGrupo
	  	    
	  		If !EMPTY(M->E5_BANCO) .AND. !EMPTY(M->E5_AGENCIA) .AND. !EMPTY(M->E5_CONTA)
	  		
				dbSelectArea("SA6")
				dbSetorder(1)
				If dbSeek(xFilial("SA6")+M->(E5_BANCO+E5_AGENCIA+E5_CONTA))
					
					If SA6->A6_XMTOBR <> "S"
					    
						_lRet := .F.
						M->E5_BANCO   := SPACE(TAMSX3("E5_BANCO")[1])
						M->E5_AGENCIA := SPACE(TAMSX3("E5_AGENCIA")[1])
						M->E5_CONTA   := SPACE(TAMSX3("E5_CONTA")[1])
					
						MSGAlert("Banco não permitido. Verifique se pertence ao Grupo de Usuário: 'Materiais Obras' e "+; 
						"Campo: 'Mat.Obras' no cadastro de Bancos!")
					
					EndIf
					
				EndIf	  		
	  		
	  		EndIf
	  	
	  		Exit
	  	
	  	Endif
	    	
  	Next
  	
EndIf

Return(_lRet)
