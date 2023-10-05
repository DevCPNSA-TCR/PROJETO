#include "Rwmake.ch"

************************
User Function MT150LIN()
************************

Local a_area  := Getarea()
 
Reclock("SC8",.F.)  

SC8->C8_XCO := SC1->C1_XCO // Conta orc. 

MsUnlock()     

Restarea(a_area)

Return 
