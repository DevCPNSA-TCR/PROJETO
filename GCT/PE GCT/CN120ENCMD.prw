/*/{Protheus.doc} CN120ENCMD

@author Peder Munksgaard (Criare Consulting)
@since 28/04/2015
@version P11 R8

@description Ponto de entrada ap�s o encerramento da medi��o � fim de 
             disparar o m-messenger para o usu�rio respons�vel quando
             o contrato possuir medi��o eventual e n�o possuir planilha
             fixa.
             Solicitado pela usu�ria Eidilane Jardim, atrav�s do chamado
             15549.

@type User Function

/*/

#Include "Protheus.ch"

User function CN120ENCMD()

   Local _aArea   := SaveArea1({"CN9","CND","CN1"})   // Salvo a area das tabelas CN9, CND e CN1
   
   Local _lCtrFix := Iif( CN1->(FieldPos("CN1_CTRFIX")) > 0 , .T. , .F. )  // Verifico a exist�ncia do campo "Planilha Fixa?"
   //Local _lFixo   := .T.
   
   Local _nPerAvi := GetNewPar( "MV_XPERGCT" , 10 )   // Caso deseje alterar o padr�o de 10% crie o par�metro MV_XPERGCT
   Local _nPerAtu := CN9->(CN9_SALDO * 100 / CN9_VLATU)   // C�lculo do percentual alcan�ado.
   
   
   If _lCtrFix
   
      dbSelectArea("CN1")
      CN1->(dbSetOrder(1))
      If CN1->(dbSeek(CN9->(CN9_FILIAL+CN9_TPCTO)))
      
         If CN1->CN1_CTRFIX == '2' .And. _nPerAtu <= _nPerAvi 
                
            //�����������������������������������Ŀ
            //� Emite alerta de saldo do contrato �
            //�������������������������������������
			// Neste ponto chamo a fun��o padr�o por�m 
            // utilizo o ponto de entrada MMENS040 para 
            // alterar a mensagem padr�o sobre aviso de 
            // saldo do contrato.

            MEnviaMail("040",{CND->CND_NUMERO,CND->CND_CONTRA,CND->CND_REVISA,CN9->CN9_VLATU,CN9->CN9_SALDO,CN9->CN9_FILIAL})            

         Endif
	    		
      Endif	
      		
   Endif
   
   RestArea1(_aArea)  // Restauro as areas salvas na declara��o de variaveis.
   	
Return NiL
