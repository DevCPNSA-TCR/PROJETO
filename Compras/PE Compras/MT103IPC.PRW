#include "Rwmake.ch"
    
**************************************************************************************
* Programa    : MT103IPC                                               Em : 29/08/11 *
* Objetivo    : Gravar os campos do Pedido de Compra na Nota                         *
* Autor       : Totvs                                                                *
**************************************************************************************    

************************
User Function 	MT103IPC()
************************
                     
         
 //A variável "N" contém o valor da linha atual.
  local nItem := PARAMIXB[1] //PARAMIXB[1] contem o numero do item do aCols

  ACOLS [nItem ,( aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="D1_XCO"}))]     := SC7->C7_XCO
  ACOLS [nItem ,( aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="D1_XDESC"}))]   := SC7->C7_DESCRI
  
  
//Restarea(a_area)

Return  
