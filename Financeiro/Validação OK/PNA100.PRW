#INCLUDE "topconn.ch"
#INCLUDE "Tbiconn.ch"
#include 'RWMAKE.CH'
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PNA100    ºAutor  ³Yttalo P. Martins   º Data ³  15/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para filtro por CCusto e Banco em rotinas do Contas aº±±
±±º          ³Pagar e MOvimentação bancária                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PNA100(_cRotina,_nPagar,_cBordero)

Local _aGrupo     := {}
Local _nX         := 1
Local _cRet       := nil
Local _lTemp      := .T.
Local _lTemp2     := .T.
Local _lGrpMatObr := .F.
Local _cGrupo     := ALLTRIM(GetNewPar("MV_XMTOBR",""))
Local nMoedBco    := IIF(SA6->(FieldPos("A6_MOEDA")>0), SA6->A6_MOEDA, 1)
Local lBrasil     := cPaisLoc=="BRA"

Private _cPerg    := "PNA100"
Private _MVPAR01  := MV_PAR01
Private _MVPAR02  := MV_PAR02
Private _MVPAR03  := MV_PAR03
Private _MVPAR04  := MV_PAR04
Private _MVPAR05  := MV_PAR05

Public _cCustoPNA100 := U_PNA100A()
Public _aBancoPNA100 := U_PNA100B()

PswOrder(1)
If PswSeek( __cUserID, .T. )
  
    _aGrupo := PswRet()[1,10]   //grupos que o usuario pertence
    
    For _nX := 1 To  Len(_aGrupo)  //Busca os grupos q o usuario tem acesso
        
    	//Materiais Obras
	  	If ALLTRIM(_aGrupo[_nX]) == _cGrupo
	  	    
	  		_lGrpMatObr := .T.
	  	
			Do Case                                                                         
		
				Case _cRotina $ "FINA050#FINA080#FINA590#FINA290#FINA340"//contas a pagar	                                         
	  				
	  				//_cCustoPNA100 := U_PNA100A()//Busca centros de custos que são de Materiais Obras
	  				
	  				If ALLTRIM(Procname(1)) == "U_FA590BOR"
	  				 
						_cRet := U_PNA100C(_cBordero)
										  	

				  	ElseIf ALLTRIM(Procname(1)) == "U_F290OWN"
			  		
				  		If EMPTY(_cCustoPNA100)
				  			
				  			_cRet := ""
				  			Exit
				  		EndIf
				  		
				  		// Alteração por Peder Munksgaard (Criare Consulting) em 23/04/2015
                        // Necessário devido a mudança na interpretação do fonte FINA290.prw
                        // de filtro tipo IndRegua para um filtro tipo Sql.

				  		/*
				  		_cRet := ''
						_cRet += '.AND.DTOS(E2_EMISSAO)>="' + DTOS( dDataDe ) + '"'
						_cRet += '.AND.DTOS(E2_EMISSAO)<="' + DTOS( dDataAte ) + '"'
						_cRet += '.AND.(E2_CCD $ "'+_cCustoPNA100+'") .AND. !EMPTY(E2_CCD) '
					   */
					   
						_cRet := ""
						_cRet += " AND E2_EMISSAO BETWEEN '" + DTOS( dDataDe )  + "' AND '" + DTOS( dDataAte ) + "'"  
						_cRet += " AND E2_CCD IN " +FormatIn(_cCustoPNA100,"|") + " AND E2_CCD <> '' "
						
				  	    // Fim Alteração

				  	ElseIf ALLTRIM(Procname(1)) == "U_F340FLCP"
				  	
				  		If EMPTY(_cCustoPNA100)
				  			
				  			_cRet := ""
				  			Exit
				  		EndIf
				  		
				  		_cRet := ""
						_cRet += " AND E2_CCD IN "+FormatIn(_cCustoPNA100,"|") +" "
						_cRet += " AND E2_CCD <> '' "										  	
				  	
				  	
				  	ElseIf ALLTRIM(Procname(1)) == "U_FA080DT"
				  	    
				  		_cRet := U_PNA100D( cBanco,cAgencia,cConta )					  	


				  	ElseIf ALLTRIM(Procname(1)) == "U_FA050PA"
				  	    
				  		_cRet := U_PNA100D( PARAMIXB[1],PARAMIXB[2],PARAMIXB[3] )	
																  	
				  	
				  	Else
				  		
				  		If EMPTY(_cCustoPNA100)
				  			Exit
				  		EndIf
				  		
						dbSelectArea("SE2")
						SET FILTER TO SE2->E2_FILIAL == XFILIAL("SE2") .AND. (SE2->E2_CCD $ _cCustoPNA100 .AND. !EMPTY(SE2->E2_CCD))				  						  		
				  	
				  	EndIf
				  		  				
					
				
				Case _cRotina $ "FINA240|FINA241"
			  		
			  		//_cCustoPNA100 := U_PNA100A()//Busca centros de custos que são de Materiais Obras
			  		
			  		If ALLTRIM(Procname(1)) == "U_F240FPGT"
			  		
				  		If EMPTY(_cCustoPNA100)
				  			
				  			_cRet := ""
				  			Exit
				  		EndIf
				  		
				  		_cRet := ""
						_cRet += "E2_CCD IN "+FormatIn(_cCustoPNA100,"|") +" AND "
						_cRet += "E2_CCD <> '' AND "						
					
					ElseIf ALLTRIM(Procname(1)) == "U_F240TBOR"
					    
					    dbselectarea("SEA")
					    If FieldPos("EA_XUSRGRP") > 0
					    
							RecLock("SEA",.F.)
								SEA->EA_XUSRGRP := CUSERNAME
								SEA->EA_XMTOBR  := "S"
							("SEA")->(MsUnlock())
						
						EndIf
						
					
					ElseIf ALLTRIM(Procname(1)) == "U_F240OK2"
				  	    
				  		_cRet := U_PNA100D( cPort240,cAgen240,cConta240 )					  	
					
						
					EndIf
					
					
				
				Case _cRotina $ "FINA450"//compensação de carteiras	                                         
	  				
	  				//_cCustoPNA100 := U_PNA100A()//Busca centros de custos que são de Materiais Obras
	  				
			  		If EMPTY(_cCustoPNA100)
			  			Exit
			  		EndIf
			  		
			  		dbSelectArea("TRB")
			  		
			  		dbSelectArea("SE2")
			  		dbSelectArea(1)
			  		If dbSeek(TRB->CHAVE)
			  		
				  		If !(SE2->E2_CCD $ _cCustoPNA100) .AND. !EMPTY(SE2->E2_CCD)
				  		
					  		dbSelectArea("TRB")
					  		
					  		_nPagar := TRB->PAGAR
					  		
					  		RecLock("TRB",.F.)
					  			("TRB")->(dbDelete())
					  		("TRB")->(MsUnlock())
				  		
				  		EndIf
			  		
			  		EndIf
			  			  				
				
				
				Case _cRotina $ "FINA100"//Movimentação bancária	                                         
	                
	                //_cBancoPNA100 := U_PNA100B()//Busca os bancos que são de Materiais Obras
	                
			  		If EMPTY(_aBancoPNA100)// .OR. EMPTY(_cCustoPNA100)
			  			Exit
			  		EndIf	  					  				
	  		
					dbSelectArea("SE5")
					SET FILTER TO SE5->E5_FILIAL == XFILIAL("SE5") .AND. SE5->E5_BANCO $ _aBancoPNA100[1] ;
						.AND. SE5->E5_AGENCIA $ _aBancoPNA100[2] ;
						.AND. SE5->E5_CONTA $ _aBancoPNA100[3]
						//.AND. SE5->E5_CCC $ _cCustoPNA100           
						
					
					
				Case _cRotina $ "FINA380"//conciliação bancária
			  		
	                //_cBancoPNA100 := U_PNA100B()//Busca os bancos que são de Materiais Obras
	                If ALLTRIM(Procname(1)) == "U_F380FIL"
	                
				  		If EMPTY(_aBancoPNA100)// .OR. EMPTY(_cCustoPNA100)
				  			
				  			_cRet := ""
				  			Exit
				  		EndIf
				  		
				  		_cRet := ''
						_cRet += '(E5_BANCO $ "'+_aBancoPNA100[1]+'") .AND. (E5_AGENCIA $ "'+_aBancoPNA100[2]+'") .AND. (E5_CONTA $ "'+_aBancoPNA100[3]+'") '
						//_cRet += ' .AND. (E5_CCC $ "'+_cCustoPNA100+'") '
				
					        
					
					ElseIf ALLTRIM(Procname(1)) == "U_F380RECO"
					
						If IsMark("E5_OK",cMarca) .AND. TRB->E5_RECPAG == "P"
						    
						    If !EMPTY(_aBancoPNA100)
						        
						    	_lTemp2 := U_PNA100D( TRB->E5_BANCO,TRB->E5_AGENCIA,TRB->E5_CONTA )
							
							EndIf
							
							dbSelectArea("SE2")
							dbSetorder(1)
							If dbSeek(xFilial("SE2")+TRB->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))
							
								dbSelectArea("CTT")
								dbSetorder(1)
								
								If dbSeek(xFilial("CTT")+SE2->E2_CCD)							
								    
									If CTT->CTT_XMTOBR <> "S"
									    
										_lTemp2 := .F.
										
										MSGAlert("C.Custo não permitido. Verifique se pertence ao Grupo de Usuário: 'Materiais Obras' e Campo: 'Mat.Obras' no "+;
										"cadastro de Centro de Custos!")
									
									EndIf
								
								EndIf
							
							EndIf							
						    
							If _lTemp2 == .F.
							    
								RecLock( "TRB", .F. )
								TRB->E5_OK := "  "               
								msUnlock()
								
								nValPag -= IIF(nMoedBco>1 .And. lBrasil,TRB->E5_VLMOED2,TRB->E5_VALOR)
								nValPagT += IIF(nMoedBco>1 .And. lBrasil,TRB->E5_VLMOED2,TRB->E5_VALOR)
								nQtdTitP--
							EndIf
		
						EndIf
					
					EndIf
					
					
					                                                                                                                                  
			EndCase                                                                         
	  	
	  		Exit
	  	
	  	Endif
	    	
  	Next
  	
  	If _lGrpMatObr == .F. .AND. _cRotina $ "FINA240|FINA241"
  	    
  		If ALLTRIM(Procname(1)) == "U_F240FPGT"
  	
			ValidPerg()
			If !pergunte(_cPerg,.T.)
				_cRet := "(E2_CCD ='######') AND "
	  		Else
	  		    
	  			If MV_PAR01 == 1//IGUAL A
	  		
			  		_cRet := ""
					_cRet += "(E2_CCD BETWEEN '" + MV_PAR02 + "' AND '"+ MV_PAR03 + "') AND "
					_cRet += "(E2_XDTAGEN BETWEEN '"+DTOS(MV_PAR04)+"' AND '"+DTOS(MV_PAR05)+"') AND "
				
				Else//DIFERENTE DE
	
			  		_cRet := ""
					_cRet += "(E2_CCD NOT BETWEEN '" + MV_PAR02 + "' AND '"+ MV_PAR03 + "') AND "
					_cRet += "(E2_XDTAGEN NOT BETWEEN '"+DTOS(MV_PAR04)+"' AND '"+DTOS(MV_PAR05)+"') AND "
								
				EndIf
	  	
			EndIf
		
		EndIf
		
		
	EndIf
	
    
EndIf

MV_PAR01 := _MVPAR01
MV_PAR02 := _MVPAR02
MV_PAR03 := _MVPAR03
MV_PAR04 := _MVPAR04
MV_PAR05 := _MVPAR05
	
Return(_cRet)


**************************************************************************************************************

User Function PNA100A()

Local _aArea    := GetArea()
Local _aAreaSE2 := SE2->(GetArea())
Local _cRet   := ""
Local _cQuery := ""
Local _ArqTmp := GetNextAlias()

Local _aGrupo     := {}
Local _lGrpMatObr := .F.
Local _cGrupo     := ALLTRIM(GetNewPar("MV_XMTOBR",""))
Local _nX         := 1

PswOrder(1)
If PswSeek( __cUserID, .T. )
  
    _aGrupo := PswRet()[1,10]   //grupos que o usuario pertence
    
    For _nX := 1 To  Len(_aGrupo)  //Busca os grupos q o usuario tem acesso
        
    	//Materiais Obras
	  	If ALLTRIM(_aGrupo[_nX]) == _cGrupo
	  	    
	  		_lGrpMatObr := .T.
	  	EndIf
	 
	Next _nX

EndIf

dbSelectArea("CTT")
If FieldPos("CTT_XMTOBR") > 0

	_cQuery += " SELECT * FROM "+RetSqlName("CTT")+" CTT "
	_cQuery += " WHERE CTT.CTT_FILIAL = '"+xFilial("CTT")+"' "
	_cQuery += " AND CTT_XMTOBR = 'S' "
	_cQuery += " AND CTT.D_E_L_E_T_ = '' "
	
	_cQuery := ChangeQuery(_cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_ArqTmp,.T.,.T.)						
	
	dbSelectArea(_ArqTmp)
	(_ArqTmp)->(dbGotop())
	
	If (_ArqTmp)->(!EOF())
	
		While (_ArqTmp)->(!EOF())
		
			_cRet += (_ArqTmp)->CTT_CUSTO+"|"
			
		(_ArqTmp)->(dbSkip())
		EndDo
	
	Else
	
		_cRet := "######"
		
		If _lGrpMatObr == .T.
			ApMsgInfo("Não existe Centro de Custo com campo:"+RetTitle("CTT_XMTOBR")+" com conteúdo 'SIM' para o grupo de usuário: 'Materiais Obras' !")
		EndIf
		
	EndIf
	
	If Select(_ArqTmp) > 0
		dbSelectArea(_ArqTmp)
		(_ArqTmp)->(dbCloseArea())
	EndIf

Else

	_cRet := "######"
    
	If _lGrpMatObr == .T.
		ApMsgInfo("Campo:"+RetTitle("CTT_XMTOBR")+" não existente no cadastro de Centro de Custo!")
	EndIf
	
EndIf

RestArea(_aAreaSE2)
RestArea(_aArea)
		
Return(_cRet)

************************************************************************************************

User Function PNA100B()

Local _aArea    := GetArea()
Local _aAreaSE2 := SE2->(GetArea())
Local _aAreaSE5 := SE5->(GetArea())
Local _aRet   := ARRAY(3)
Local _cQuery := ""
Local _ArqTmp := GetNextAlias()

Local _aGrupo     := {}
Local _lGrpMatObr := .F.
Local _cGrupo     := ALLTRIM(GetNewPar("MV_XMTOBR",""))
Local _nX         := 1

PswOrder(1)
If PswSeek( __cUserID, .T. )
  
    _aGrupo := PswRet()[1,10]   //grupos que o usuario pertence
    
    For _nX := 1 To  Len(_aGrupo)  //Busca os grupos q o usuario tem acesso
        
    	//Materiais Obras
	  	If ALLTRIM(_aGrupo[_nX]) == _cGrupo
	  	    
	  		_lGrpMatObr := .T.
	  	EndIf
	 
	Next _nX

EndIf

_aRet[1] := SPACE(TAMSX3("A6_COD")[1])
_aRet[2] := SPACE(TAMSX3("A6_AGENCIA")[1])
_aRet[3] := SPACE(TAMSX3("A6_NUMCON")[1])

dbSelectArea("SA6")
If FieldPos("A6_XMTOBR") > 0

	_cQuery += " SELECT * FROM "+RetSqlName("SA6")+" SA6 "
	_cQuery += " WHERE SA6.A6_FILIAL = '"+xFilial("SA6")+"' "
	_cQuery += " AND A6_XMTOBR = 'S' "
	_cQuery += " AND SA6.D_E_L_E_T_ = '' "
	
	_cQuery := ChangeQuery(_cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_ArqTmp,.T.,.T.)						
	
	dbSelectArea(_ArqTmp)
	(_ArqTmp)->(dbGotop())
	
	If (_ArqTmp)->(!EOF())
	
		While (_ArqTmp)->(!EOF())
		
			_aRet[1] += (_ArqTmp)->A6_COD+"|"
			_aRet[2] += (_ArqTmp)->A6_AGENCIA+"|"
			_aRet[3] += (_ArqTmp)->A6_NUMCON+"|"
			
		(_ArqTmp)->(dbSkip())
		EndDo
	
	Else
	
		_aRet[1] := "###"
		_aRet[2] := "###"
		_aRet[3] := "###"
		
		If _lGrpMatObr == .T.
			ApMsgInfo("Não existe Banco com campo:"+RetTitle("A6_XMTOBR")+" com conteúdo 'SIM' para o grupo de usuário: 'Materiais Obras' !")		
	    EndIf
	    
	EndIf
	
	If Select(_ArqTmp) > 0
		dbSelectArea(_ArqTmp)
		(_ArqTmp)->(dbCloseArea())
	EndIf						

Else

	_aRet[1] := "###"
	_aRet[2] := "###"
	_aRet[3] := "###"
    
	If _lGrpMatObr == .T.
		ApMsgInfo("Campo:"+RetTitle("A6_XMTOBR")+" não existente no cadastro de Banco!")
    EndIf
    

EndIf

RestArea(_aAreaSE5)
RestArea(_aAreaSE2)
RestArea(_aArea)
		
Return(_aRet)

************************************************************************************************

User Function PNA100C(_Bordero)

Local _aArea    := GetArea()
Local _aAreaSE2 := SE2->(GetArea())
Local _aAreaSEA := SEA->(GetArea())
Local _lRet   := .T.
Local _cQuery := ""
Local _ArqTmp := GetNextAlias()

dbSelectArea("SEA")
If FieldPos("EA_XMTOBR") > 0

	_cQuery += " SELECT * FROM "+RetSqlName("SEA")+" SEA "
	_cQuery += " WHERE SEA.EA_FILIAL = '"+xFilial("SEA")+"' "
	_cQuery += " AND EA_XMTOBR = 'S' "
	_cQuery += " AND SEA.D_E_L_E_T_ = '' "
	
	_cQuery := ChangeQuery(_cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_ArqTmp,.T.,.T.)						
	
	dbSelectArea(_ArqTmp)
	(_ArqTmp)->(dbGotop())
	
	If (_ArqTmp)->(!EOF())
	
		_lRet   := .T.
	Else
		
		_lRet   := .F.
		ApMsgInfo("Este borderô não foi gerado pelo grupo de usuário: 'Materiais Obras' !")		
	
	EndIf
	
	If Select(_ArqTmp) > 0
		dbSelectArea(_ArqTmp)
		(_ArqTmp)->(dbCloseArea())
	EndIf						

Else

	_lRet := .F.

	ApMsgInfo("Campo:"+RetTitle("EA_XMTOBR")+" não existente no cadastro de Borderô!")


EndIf

RestArea(_aAreaSE2)
RestArea(_aAreaSEA)
RestArea(_aArea)
		
Return(_lRet)

*************************************************************************************************************
User Function PNA100D(_cBanco,_cAgencia,_cConta)

Local _aArea    := GetArea()
Local _lRet     := .T.

dbSelectArea("SA6")
dbSetorder(1)
If dbSeek(xFilial("SA6")+_cBanco+_cAgencia+_cConta)
	
	If SA6->A6_XMTOBR <> "S"
	    
		_lRet := .F.
	
		MSGAlert("Banco não permitido. Verifique se pertence ao Grupo de Usuário: 'Materiais Obras' e "+; 
		"Campo: 'Mat.Obras' no cadastro de Bancos!")
	
	EndIf
	
EndIf

RestArea(_aArea)

Return(_lRet)
*************************************************************************************************************

Static Function ValidPerg()

PutSx1(_cPerg,"01","Filtro C.C  ?"        ,"Filtro C.C  ?","Filtro C.C  ?","mv_ch1","N",08,0,0,"C","","","","","mv_par01",+;
	"Igual a","Igual a","Igual a","","Diferente de","Diferente de","Diferente de")

PutSx1(_cPerg,"02","C.Custo De  ?"        ,"C.Custo De  ?"     ,"C.Custo De  ?"     ,"mv_ch2","C",TAMSX3("CTT_CUSTO")[1],0,0,"G","","","","","mv_par02")
PutSx1(_cPerg,"03","C.Custo Até ?"        ,"C.Custo Até ?"     ,"C.Custo Até ?"     ,"mv_ch3","C",TAMSX3("CTT_CUSTO")[1],0,0,"G","","","","","mv_par03")
PutSx1(_cPerg,"04","Dt.Agendamen. De ?"   ,"Dt.Agendamen. De ?","Dt.Agendamen. De ?","mv_ch4","D",08                    ,0,0,"G","","","","","mv_par04")
PutSx1(_cPerg,"05","Dt.Agendamen. Ate?"   ,"Dt.Agendamen. Ate?","Dt.Agendamen. Ate?","mv_ch5","D",08                    ,0,0,"G","","","","","mv_par05")

Return