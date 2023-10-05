#Include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PTNA001 ºAutor  ³ Vinicius Figueiredo Moreira ºData³ 22/05/13 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Trata conta orçamentaria debito ou credito lançamento PCO   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PTNA001(cCpo)

Local cComp := Alltrim(CT2->CT2_ORIGEM)
Local cRet := ""
Local aVet1 := {{"23002"},{'216','302','303','310','311','312','313','345','347','477','480'}}
Local aVet2 := {{"23005"},{'300','306','308','340','344','475','478'}}
Local aVet3 := {{"23008"},{'472','473','474'}}    
Local aVet := {aVet1,aVet2,aVet3}
Local n_y := 0
Local n_x := 0

For n_x := 1 to len(aVet)

	aThis := aVet[n_x]
	aItem := aThis[2]

	For n_y := 1 to Len(aItem)
		If cComp == aItem[n_y]
			cRet := aThis[1][1]		
		Endif	
	Next n_y

Next n_x

If empty(cRet)
	cRet := POSICIONE("CT1",1, XFILIAL("CT1")+CT2->(&cCpo),"CT1_XCO")
endif

Return cRet
