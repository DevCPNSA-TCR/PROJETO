/*/{Protheus.doc} xQuery

@author Peder Munksgaard (iTMiX Solutions)
@since 29/05/2015
@version P11 R8

@description Programa para execu��o e exporta��o de query
             atrav�s do Protheus.

@type User Function
/*/

#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"

User Function xQuery()

   Private _aParam   := {}
   Private _aRet     := {}
   
  // 2 - Combo
  //[2] : Descri��o
  //[3] : Num�rico contendo a op��o inicial do combo
  //[4] : Array contendo as op��es do Combo
  //[5] : Tamanho do Combo
  //[6] : Valida��o
  //[7] : Flag .T./.F. Par�metro Obrigat�rio ?   
   
  // 6 - File
  //[2] : Descri��o
  //[3] : String contendo o inicializador do campo
  //[4] : String contendo a Picture do campo
  //[5] : String contendo a valida��o
  //[6] : String contendo a valida��o When
  //[7] : Tamanho do MsGet
  //[8] : Flag .T./.F. Par�metro Obrigat�rio ?
  //[9] : Texto contendo os tipos de arquivo Ex.: "Arquivos .CSV |*.CSV"
  //[10]: Diret�rio inicial do cGetFile
  //[11]: PARAMETROS do cGETFILE   
     
  // 11 - MultiGet (Memo)
  //[2] : Descri��o
  //[3] : Inicializador padrao
  //[4] : String contendo a valida��o
  //[5] : String contendo a valida��o When
  //[6] : Flag .T./.F. Par�metro Obrigat�rio ?
 
   aAdd( _aParam , {11, "Query para executar   ","", ".T.","",.T.})   
   aAdd( _aParam , {6 , "Salvar em:            ",Space(100),"","","", 100,.T.,".csv|*.csv"})
   
   While ParamBox(@_aParam, "Parametros", @_aRet)   
            
      Processa( {|| _fProc() }, 'Exportando resultados da query','Processando...', .F. )
      
      MsgInfo("Opera��o conclu�da!","xQuery")
      
   End
   
      MsgStop("Opera��o cancelada!","xQuery")
           
Return NiL

/*/{Protheus.doc} _fProcExp

@author Peder Munksgaard (iTMiX Solutions)
@since 12/05/2015
@version P11 R8

@description Fun��o de processamento auxiliar respons�vel para 
             realiza��o das tarefas resultantes da query.

@type Static Function
/*/

Static Function _fProc()

   Local _nX     := 0
   Local _cAlias := GetNextAlias()
   Local _aStru  := {}
   Local _cQry   := ""
   Local _cRes   := ""
   
   _aRet[2] := Iif(ValType(_aRet[2]) <> 'C', "C:\QUERY\XQUERY.CSV", _aRet[2])  
   

   _cQry := ChangeQuery(_aRet[1])         
     
   TcQuery _cQry Alias (_cAlias) New 
      
   _aStru := (_cAlias)->(dbStruct())     
      
   ProcRegua(Contar((_cAlias),"!Eof()"))
   Incproc()
      
   (_cAlias)->(dbGotop())

   For _nX := 1 to Len(_aStru)
         
      _cRes += _aStru[_nX][1] + ";"
            
   Next _nX               
         
   _cRes += CRLF      
      
   While (_cAlias)->(!Eof())
         
      For _nX := 1 to Len(_aStru)
         
         If (_cAlias)->(FieldPos(_aStru[_nX][1])) > 0
         
            If _aStru[_nX][2] == "N"
         
               _cRes += Str((_cAlias)->&(_aStru[_nX][1])) + ";"
            
            Elseif _aStru[_nX][2] == "M"
         
               _cRes += Memoline((_cAlias)->&(_aStru[_nX][1]),50) + ";"
            
            Elseif _aStru[_nX][2] == "L"
            
               _cRes += Iif((_cAlias)->&(_aStru[_nX][1]),"T","F")
         
            Else
         
               _cRes += (_cAlias)->&(_aStru[_nX][1]) + ";"
            
            Endif
            
         Endif
                  
      Next _nX
         
      _cRes += CRLF
                           
      (_cAlias)->(dbSkip())
      Incproc()
         
   End
         
   If !Empty(_cRes)
   
      Memowrite(_aRet[2], _cRes)
      
   Endif
   
Return NiL