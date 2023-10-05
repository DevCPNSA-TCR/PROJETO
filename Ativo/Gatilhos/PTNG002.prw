#include 'protheus.ch'
#include 'parmtype.ch'

/*
****************************************************************************************************
*** Funcao: PTNG002   -   Autor: Ricardo Ferreira - Criare Consulting   -   Data:06/07/2017      ***
*** Descricao: Gatilho executado no campo N1_DESCRIC para preencher o campo N3_HISTOR	         ***
****************************************************************************************************
*/

User function PTNG002()

	Local nI := 0
	oModel := FWModelActive()
	
	oModelSN3 := oModel:getModel("SN3DETAIL")
	
	ALERT(M->N1_DESCRIC)
	
	For nI := 1 To oModelSN3:Length()
		oModelSN3:GoLine( nI )
		oModelSN3:SetValue("N3_HISTOR",M->N1_DESCRIC)
	Next
	oModelSN3:Refresh()
	//eval({ || Acols[n,ascan(aHeader,{|X| Alltrim(x[2])="N3_HISTOR"})]:=M->N1_DESCRIC,	__oGet:Refresh()})
	//ALLTRIM(UPPER(FUNNAME())) <> "PTNI001"  
return 
