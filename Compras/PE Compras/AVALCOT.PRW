#include "Rwmake.ch"

**************************************************************************************
* Programa    : AVALCOT                                                Em : 29/08/11 *
* Objetivo    : Gravar os campos do PCO no pedido de compra                          *
* Autor       : Totvs                                                                *
**************************************************************************************    


************************
User Function AVALCOT()
************************

Local nEvento := PARAMIXB[1]
Local a_area  := Getarea()
 
If nEvento == 4 
   DbSelectArea("SC7")
   Reclock("SC7",.F.)
      SC7->C7_XCO:= SC1->C1_XCO // Conta Orçamentária
   MsUnlock()
EndIf      

Restarea(a_area)

Return 
