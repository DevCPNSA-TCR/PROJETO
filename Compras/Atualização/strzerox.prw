#INCLUDE "RWMAKE.ch"
#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณstrzerox    บ Autor ณ Marcelo Amaral   บ Data ณ  09/12/11   บฑฑ 
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Preenche campo com zeros a esquerda                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Brasil PCH                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function strzerox(nTam)

Local aArea     := GetArea()     
Local cVarTxt   := &(readvar())
Local cVarTxt2  := ""
Local nCont     := 0
// Incluํdo por Peder Munksgaard (Criare Consulting) 05/05/2015
Local _lRet     := .T.
// Fim inclusใo.

Default nTam   := 0

if alltrim(cVarTxt) <> ""
    
	for nCont := 1 to Len(alltrim(cVarTxt))
		if substr(alltrim(cVarTxt),nCont,1) $ "0123456789"
			cVarTxt2 := cVarTxt2 + substr(alltrim(cVarTxt),nCont,1)
		endif
	next
	cVarTxt := cVarTxt2
	
	cVarTxt := strzero(val(alltrim(cVarTxt)),if(nTam <> 0, nTam, TamSX3(substr(readvar(),4,len(readvar())-3))[1]))

endif

// Incluํdo por Peder Munksgaard (Criare Consulting) 05/05/2015
If Empty(cVarTxt) .Or. cVarTxt == Replicate("0",TamSX3("F1_DOC")[1])

   _lRet   := .F.
   cVarTxt := Space(TamSX3("F1_DOC")[1])
      
Endif
// Fim inclusใo.

&(readvar()) := cVarTxt

RestArea(aArea)

Return _lRet //cVarTxt