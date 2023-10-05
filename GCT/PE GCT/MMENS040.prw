/*/{Protheus.doc} MMENS040

@author Peder Munksgaard (Criare Consulting)
@since 28/04/2015
@version P11 R8

@description Ponto de entrada com a finalizade de modificar a mensagem enviada
             pelo envento 040 (notificar sobre saldo de planilha de contratos).
             Interven��o necess�ria conforme solicita��o da usu�ria Eidilane Jardim
             atrav�s do chamado 15549.            

@type User Function

/*/

#Include "Protheus.ch"
#Include "Topconn.ch"

User function MMENS040()

   Local _aDados := aClone(ParamIXB[1])
   Local _cMsg   := ParamIXB[2]
      
   If Isincallstack("U_CN120ENCMD")
   
      //������������������������������������������������������������������������Ŀ
      //�"040" - Limite de saldo das planilhas de contrato - (SIGAGCT)           �
      //��������������������������������������������������������������������������
      _cMsg := "O saldo do contrato abaixo, atingiu o percentual minimo estabelecido. Informa��es: "         + CRLF
      _cMsg += "Contrato\Revisao: " + _aDados[2] + "/" + _aDados[3]                                          + CRLF
      _cMsg += "Filial : "                             + _aDados[6]                                          + CRLF      
      _cMsg += "Valor Total: "                         + Transform(_aDados[4],PesqPict("CN9","CN9_VLATU"))   + CRLF
      _cMsg += "Saldo: "                               + Transform(_aDados[5],PesqPict("CN9","CN9_SALDO"))   + CRLF
      _cMsg += "Percentual m�nimo: "                   + StrZero(GetNewPar( "MV_XPERGCT" , 10 ),2) + " % "   + CRLF
      _cMsg += "Fornecedor:  "                         + RetForCnc(_aDados[6], _aDados[2], _aDados[3])       + CRLF
      _cMsg += "Empresa: "                             + FwFilName(cEmpAnt,_aDados[6])                       + CRLF

   Else
   
      _cMsg += "Fornecedor:  "                         + RetForCnc(_aDados[6], _aDados[2], _aDados[3])       + CRLF
      _cMsg += "Empresa: "                             + FwFilName(cEmpAnt,_aDados[6])                       + CRLF
               
   Endif     
	
Return _cMsg

/*/{Protheus.doc} RetForCnc

@author Peder Munksgaard (Criare Consulting)
@since 29/04/2015
@version P11 R8 
 
@param _cFil   , caracter, filial do contrato
@param _cContra, carcater, n�mero do contrato
@param _cRevisa, carcater, revis�o do contrato

@description Fun��o auxiliar � fim de retornar o nome reduzido
             do fornecedor para contrato/revis�o informados.

@type Static Function

/*/

Static Function RetForCnc(_cFil, _cContra, _cRevisa)

   Local _cQry    := ""
   Local _cAlias  := GetNextAlias()
   Local _cNomFor := ""
   
   // Altera��o por Peder Munksgaard (Criare Consulting) em 20/05/2015
   // Solicitado pela usu�ria Eidilane Jardim atrav�s do chamao 17175
   // para utilizar a raz�o social do fornecedor e n�o o nome fantasia.

   //_cQry += CRLF + "SELECT A2_NREDUZ FROM " + RetSqlName("SA2") + " A2 (NOLOCK)"
   _cQry += CRLF + "SELECT A2_NOME FROM " + RetSqlName("SA2") + " A2 (NOLOCK)"   
   _cQry += CRLF + "INNER JOIN " + RetSqlName("CNC") + " CNC"
   _cQry += CRLF + "        ON CNC.CNC_CODIGO = A2.A2_COD"
   _cQry += CRLF + "       AND CNC.CNC_LOJA   = A2.A2_LOJA"
   _cQry += CRLF + "WHERE CNC.D_E_L_E_T_ = ''"
   _cQry += CRLF + "AND   CNC.CNC_FILIAL = '" + _cFil + "'"
   _cQry += CRLF + "AND   CNC.CNC_NUMERO = '" + _cContra + "'"
   _cQry += CRLF + "AND   CNC.CNC_REVISA = '" + _cRevisa + "'"
   
   // Fim altera��o.

   _cQry := ChangeQuery(_cQry)
   
   If Select((_cAlias)) > 0 ; (_cAlias)->(dbCloseArea()) ; Endif   
   
   TcQuery _cQry New Alias (_cAlias) 
   
   _cNomFor := (_cAlias)->A2_NOME
   
Return _cNomFor