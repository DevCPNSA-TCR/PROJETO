#include "Protheus.ch"
#Define cEnt CHR(13) + CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณpna001 บAutor  ณYttalo P. Martins      บ Data ณ  18/06/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de integra็ใo Protheus x Excel para exporta็ใo de    บฑฑ
ฑฑบ          ณsaldo realizados de contas or็amentแrias para planilha      บฑฑ
ฑฑบ          ณconfigurada previamente configurada                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function pna001(cCusto,cCO,cMes,cAno)  

Local aVetor	:= {}
Local dUltDia   := lastday(date())
Local dPriDia   := lastday(date())
Local nSaldo    := 0
//Local nIniCC    := AT(":",cCusto)+1
//Local nFimCC    := AT("-",cCusto)-1
Local cAliasAKS := GetnextAlias()
Local cQuery    := ""              

cAno   := strZero(year(cMes),4) // ALLTRIM( SUBSTRING(ALLTRIM(cAno),10,Len(cAno)) )

If ValType(cMes) = "D"
	cMes := DTOC(cMes)
	cMes := SUBSTRING(cMes,4,2)
Elseif ValType(cMes) = "C"
	cMes := ""
	cMes := SUBSTRING(cMes,4,2)
EndIf

//cAno   := ALLTRIM( SUBSTRING(ALLTRIM(cAno),10,Len(cAno)) )

cCusto := allTrim(str(cCusto))

//cCusto := ALLTRIM( SUBSTRING(cCusto,nIniCC,(nFimCC-nIniCC)) )
//cCusto := STRTRAN(cCusto,".","")

dPriDia:= CTOD("01/"+cMes+"/"+cAno)
dUltDia:= LASTDAY(dPriDia)

dPriDia:= DTOS(dPriDia)
dUltDia:= DTOS(dUltDia)

If ValType(cCO) = "N"
	cCO := ALLTRIM(STR(cCO))
	cCO := STRTRAN(cCO,".","")
Elseif ValType(cCO) = "C"
	cCO := ALLTRIM(cCO)
	cCO := STRTRAN(cCO,".","")
Else
	cCO := ""
EndIf

/*
//ACUMULADO DO MสS (saldo final do perํodo)
cQuery := " SELECT AKS_FILIAL,AKS_DATA, (AKS_SDCRD1-AKS_SDDEB1) AS SALDO,AKS_CHAVE FROM "+ RetsqlName("AKS") + " AKS "+ cEnt
cQuery += " WHERE AKS_FILIAL = '" + xFilial("AKS") + "' "+ cEnt
cQuery += " AND AKS_NIV01 = '" + cCusto + "' "+ cEnt
cQuery += " AND AKS_NIV02 = '" + cCO + "' "+ cEnt
cQuery += " AND AKS_TPSALD = 'RE' "+ cEnt
cQuery += " AND AKS_CONFIG = '02' "+ cEnt
cQuery += " AND AKS_DATA <= '" + dUltDia + "' "+ cEnt
cQuery += " AND AKS.D_E_L_E_T_<> '*' "+ cEnt
cQuery += " ORDER BY AKS_FILIAL,AKS_DATA DESC "+ cEnt
*/

//Total dos movimentos diแrios(Movimento do perํodo)
cQuery := " SELECT SUM(AKT_MVCRD1-AKT_MVDEB1) AS SALDO FROM "+ RetsqlName("AKT") + " AKT "+ cEnt
cQuery += " WHERE AKT_FILIAL  = '" + xFilial("AKT") + "' "+ cEnt
cQuery += " AND AKT_NIV01 = '" + cCusto + "' "+ cEnt
cQuery += " AND AKT_NIV02 = '" + cCO + "' "+ cEnt
cQuery += " AND AKT_TPSALD = 'RE' "+ cEnt
cQuery += " AND AKT_CONFIG = '02' "+ cEnt
cQuery += " AND AKT.D_E_L_E_T_ <> '*' "+ cEnt
cQuery += " AND AKT_DATA BETWEEN '" + dPriDia + "' AND '"+ dUltDia + "' "+ cEnt

memowrite("c:\temp\pna001_" + cCusto + "_" + cCO + "_" + dPriDia + "_" + dUltDia + ".txt", cQuery)

DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQuery), cAliasAKS, .F., .T.)
DbSelectArea(cAliasAKS)
(cAliasAKS)->(DbGoTop())
  
If !(cAliasAKS)->(Eof())
	nSaldo    := (cAliasAKS)->SALDO
Else
	nSaldo    := 0
EndIf

DbSelectArea(cAliasAKS)
(cAliasAKS)->(DbCloseArea())  

Aadd(aVetor,{nSaldo})		

Return(aVetor)       


			