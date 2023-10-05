#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#DEFINE cEOL CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuncao	 ณPCOA1001  บAutor  ณ YTTALO P MARTINS -    Data 12/01/12     บฑฑ
ฑฑบDesc.     ณAdiciona botใo para importa็ใo de C.O.                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบAltera็๕es:  ณ 18/03/2015 Leonardo Freire - inclusใo do botaใo para    บฑฑ
ฑฑบ             ณexcluir o centro de custo por periodo.                   บฑฑ 
ฑฑบ             ณ                                                         บฑฑ 
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PCOA1001()

Local _aRotina := {}

If ALLTRIM(FUNNAME()) == "PCOA100"
	
	 aAdd(_aRotina, {"Importar C.O.",  "U_PTNA050"	, 0, 4, 0, .F.} )
	 aAdd(_aRotina, {"Excluir C.C.",   "U_PTNA051"	, 0, 4, 0, .F.} )
	 
   //	_aRotina := {{ "Importar C.O.",  "U_PTNA050"	, 0, 4	}}      
	  
	
EndIf

Return(_aRotina)                 
