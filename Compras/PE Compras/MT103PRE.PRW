#include "Rwmake.ch"

**************************************************************************************
* Programa    : MT103PRE                                               Em : 07/01/14 *
* Objetivo    : Ponto de Entrada para o rateio de centro de custos na nota de entrada*
*              Utilizado para preencher o campo de conta contabil do rateio de acordo*
*	 			com a conta do item da nota                                            *  	
* Autor       : Ricardo Ferreira                                                     *
*                                                                                    *
************************************************************************************** 
************************
User Function MT103PRE()
************************
Local aHeadRet 	:= aClone(ParamIxb[1])
Local aColsRet 	:= aClone(ParamIxb[2])
Local nPDeConta	:= aScan(aHeadRet,{|x| AllTrim(x[2]) == "DE_CONTA"} )
Local nPD1Conta	:= aScan(aOrigHeader,{|x| AllTrim(x[2]) == "D1_CONTA"} )
Local nPDeCO		:= aScan(aHeadRet,{|x| AllTrim(x[2]) == "DE_XCO"} )
Local nPD1CO		:= aScan(aOrigHeader,{|x| AllTrim(x[2]) == "D1_XCO"} )
Local nPDePerc	:= aScan(aHeadRet,{|x| AllTrim(x[2]) == "DE_PERC"} )
Local nPDeVal		:= aScan(aHeadRet,{|x| AllTrim(x[2]) == "DE_XVALOR"} )
Local nPD1Total	:= aScan(aOrigHeader,{|x| AllTrim(x[2]) == "D1_TOTAL"} )


If Empty(aColsRet[Len(acolsRet)][nPDeConta])
	aColsRet[Len(acolsRet)][nPDeConta]:=aOrigAcols[nOrigN][nPD1Conta]
Endif
If Empty(aColsRet[Len(acolsRet)][nPDeCO])
	aColsRet[Len(acolsRet)][nPDeCO]:=aOrigAcols[nOrigN][nPD1CO]
Endif

//Preencher o campo Valor
aColsRet[Len(acolsRet)][nPDeVal]:= (aColsRet[Len(acolsRet)][nPDePerc]/100) * aOrigAcols[nOrigN][nPD1Total]




Return aColsRet


