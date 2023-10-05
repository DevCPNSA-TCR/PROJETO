#INCLUDE "rwmake.ch"

/*/
----------------------------------------------------------------------------
Programa  FA050IRF()º Autor ³ Roberto Lima                º Data ³  05/09/12
----------------------------------------------------------------------------
Descricao  Ponto de entrada para atualização dos campos ítem contábil,
centros de custos e históricos nos títulos de IRRF gerados
automaticamente.
----------------------------------------------------------------------------
/*/

User Function F050GER()

Local cAlias 	:= ""
Local nReg		:= ""
Local cItemC 	:= ""
Local cCCusto	:= ""
Local cHist	:= ""
Local cTitPai	:= ""
Local aArea 	:= getarea()

If Type("PARAMIXB") ="A" .and. Len(PARAMIXB) > 0
	cAlias 	:= PARAMIXB[1][1]
	nReg		:= PARAMIXB[1][2]

	DbSelectArea(cAlias)
	DBGOTO(nReg)

	cTitPai := SE2->E2_TITPAI


	DbSelectArea(cAlias)
	DbsetOrder(1)
	If DbSeek(xFilial(cAlias)+cTitPai)

		cItemC  := SE2->E2_ITEMD
		cCCusto := SE2->E2_CCD
		cHist   := SE2->E2_HIST
	
	//Atualiza titulo de imposto
	
		DbSelectArea(cAlias)
		DBGOTO(nReg)
		Reclock("SE2", .F.)
		SE2->E2_ITEMD := cItemC
		SE2->E2_CCD   := cCCusto
		SE2->E2_HIST  := cHist
		MsUnlock()
		

	Endif
Endif
restarea(aArea)




Return
