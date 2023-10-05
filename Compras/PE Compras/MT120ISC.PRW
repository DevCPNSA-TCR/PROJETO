#include "Rwmake.ch"

**************************************************************************************
* Programa    : MT120ISC                                               Em : 29/08/11 *
* Objetivo    : Gravar informações do PCO da solicitação de compras para o pedido de *
*               Compra										                         *
* Observacoes : Ponto de Entrada disparado da rotina MATA121                         *   
* Autor       : TOTVS                                                                *
*                                                                                    *
************************************************************************************** 

************************
User Function MT120ISC()
************************  

Local _VnX := 0

For _VnX := 1 To Len(aHeader)
             
   If Trim(aHeader[_VnX][2]) == "C7_XCO"
      aCols[n][_VnX] := SC1->C1_XCO     // Conta Orçamentária
   Endif                          
    
Next _VnX  
 
Return 
