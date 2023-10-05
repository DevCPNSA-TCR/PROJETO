#Include "TopConn.Ch"

**************************************************************************************
* Programa    : CN120PED                                               Em : 25/08/11 *
* Objetivo    : Ponto de Entrada na Geração do Pedido de Compra pelo GCT, utilizado  *
*               para criar e gravar campos customizados no SC7.                      *
* Autor       : Totvs                                                                *
*                                                                                    *
**************************************************************************************    


User Function CN120PED()

Local aCab := PARAMIXB[1]
Local aItm := PARAMIXB[2]
Local aArea:= GetArea() 
//Local nPIt := aScan(aItm[1],{|x|x[1]=="C7_ITEM"})
Local Nx := 0

DbSelectArea("CNE")
DbSetOrder(1)
//DbSeek(xFilial("CNE")+CND->CND_CONTRA+CND->CND_REVISA+CND->CND_NUMERO)
DbSeek(xFilial("CNE")+CND->CND_CONTRA+CND->CND_REVISA+CND->CND_NUMERO+CND->CND_NUMMED)  // Roberto Lima 08/04/2013

For Nx:=1 to Len(aItm)
	// Grava Campos customizados no SC7
	DbSelectArea("CNB")
	DbSetOrder(1)                
	DbSeek(xFilial("CNB")+CND->CND_CONTRA+CND->CND_REVISA+CND->CND_NUMERO+STRZERO(Nx,Len(CNE->CNE_ITEM)) ) 
	
	//Conta Orcamentaria 
	If (nLin :=aScan(aItm[Nx],{|x|x[1]=="C7_XCO"}))>0
		aItm[Nx][nLin][2] := CNB->CNB_XCO
	Else
		aAdd(aItm[Nx],{"C7_XCO",CNB->CNB_XCO,nil})
	EndIF 
	
	// centro de Custo
	If (nLin :=aScan(aItm[Nx],{|x|x[1]=="C7_CC"}))>0
		//aItm[Nx][nLin][2] := CNB->CNB_XCC   Marcia 05/03/2013
		aItm[Nx][nLin][2] := CNE->CNE_XCC
	Else
		//aAdd(aItm[Nx],{"C7_CC",CNB->CNB_XCC,nil}) Marcia 05/03/2013      
		aAdd(aItm[Nx],{"C7_CC",CNE->CNE_XCC,nil})
	EndIf
Next

RestArea(aArea)

Return({aCab,aItm})
