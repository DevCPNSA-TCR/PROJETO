#Include 'rwmake.ch'
#Include 'protheus.ch'
#Include 'totvs.ch'
#Include 'topconn.ch'
#define cCrLf Chr(13) + Chr(10)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PNR001     º Autor ³Yttalo P. Martins  º Data ³  07/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rel para Análise de Compras de Fornecedores                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PNR001()

Private cPerg        := "PNR001"

PutSx1( cPerg, "01","C.Custo de"  ,"C.Custo de" ,"C.Custo de" ,"MV_CH1","C",TAMSX3("CTT_CUSTO")[1],0,0,"G","","CTT","","","MV_PAR01")
PutSx1( cPerg, "02","C.Custo até" ,"C.Custo de" ,"C.Custo de" ,"MV_CH2","C",TAMSX3("CTT_CUSTO")[1],0,0,"G","","CTT","","","MV_PAR02")
PutSx1( cPerg, "03","Num SC de"   ,"Num SC de"  ,"Num SC de"  ,"MV_CH3","C",TAMSX3("C1_NUM")[1],0,0,"G","","SC1","","","MV_PAR03")
PutSx1( cPerg, "04","Num SC até"  ,"Num SC até" ,"Num SC até" ,"MV_CH4","C",TAMSX3("C1_NUM")[1],0,0,"G","","SC1","","","MV_PAR04")
PutSx1( cPerg, "05","Dt.Emiss SC de","Dt.Emiss SC de" ,"Dt.Emiss SC de" ,"MV_CH5","D",8,0,0,"G","",""   ,"","","MV_PAR05")
PutSx1( cPerg, "06","Dt.Emiss SC até" ,"Dt.Emiss SC até" ,"Dt.Emiss SC até" ,"MV_CH6","D",8,0,0,"G","",""   ,"","","MV_PAR06")
PutSx1( cPerg, "07","Num PC de"   ,"Num PC de"  ,"Num PC de"  ,"MV_CH7","C",TAMSX3("C1_NUM")[1],0,0,"G","","SC7","","","MV_PAR07")
PutSx1( cPerg, "08","Num PC até"  ,"Num PC até" ,"Num PC até" ,"MV_CH8","C",TAMSX3("C1_NUM")[1],0,0,"G","","SC7","","","MV_PAR08")
PutSx1( cPerg, "09","Dt.Emiss PC de","Dt.Emiss PC de" ,"Dt.Emiss PC de" ,"MV_CH9","D",8,0,0,"G","",""   ,"","","MV_PAR09")
PutSx1( cPerg, "10","Dt.Emiss PC até" ,"Dt.Emiss PC até" ,"Dt.Emiss PC até" ,"MV_CHA","D",8,0,0,"G","",""   ,"","","MV_PAR10")
PutSx1( cPerg, "11","Num Cotação de"  ,"Num Cotação de"  ,"Num Cotação de"  ,"MV_CHB","C",TAMSX3("C1_NUM")[1],0,0,"G","","SC8","","","MV_PAR11")
PutSx1( cPerg, "12","Num Cotação até" ,"Num Cotação até" ,"Num Cotação até" ,"MV_CHC","C",TAMSX3("C1_NUM")[1],0,0,"G","","SC8","","","MV_PAR12")
PutSx1( cPerg, "13","Dt.Emiss Cotação de"  ,"Dt.Emiss Cotação de"  ,"Dt.Emiss Cotação de" ,"MV_CHD","D",8,0,0,"G","",""   ,"","","MV_PAR13")
PutSx1( cPerg, "14","Dt.Emiss Cotação até" ,"Dt.Emiss Cotação até" ,"Dt.Emiss Cotação até" ,"MV_CHE","D",8,0,0,"G","",""   ,"","","MV_PAR14")
PutSx1( cPerg, "15","Gera Excel?" ,"Gera Excel?" ,"Gera Excel?" ,"MV_CHF","N",1,0,0,"C","",""   ,"","","MV_PAR15","Sim","Sim","Sim","","Não","Não","Não")

If !Pergunte(cPerg,.T.)
	Return
EndIf

RptStatus({|| RunReport() },"Gerando consulta...")
Return

***************************************************************************************************************************

Static Function RunReport()

Local nOrdem
Local cQuery:=""
Local nPos  := 0
Local _aArea
Local oTempTable as object

Private nReg := 0
PRIVATE aArqTemp	:={},aArqTemp2	:={}
PRIVATE aTam    	:={}
PRIVATE cArqTemp2	:="",cIndTemp2:=""
PRIVATE cArqTemp3	:="",cIndTemp3:=""
Private _nCount     := 0
Private aTotCC      := {}
Private aTotGeral   := ARRAY(2)

aTotGeral[1] := 0
aTotGeral[2] := 0

oTempTable := FWTemporaryTable():New("TMPSC7","TMPSC72") 

If Select("TMPSC7")>0
	DbSelectArea("TMPSC7")
	DbCloseArea()
EndIf

If Select("TMPSC72")>0
	DbSelectArea("TMPSC72")
	DbCloseArea()
EndIf

aArqTemp :={}
aTam:=TamSX3("C7_FILIAL")
AADD(aArqTemp,{"C7_FILIAL"	,"C",aTam[1],aTam[2]})
aTam:=TamSX3("C7_CC")
AADD(aArqTemp,{"C7_CC"	,"C",aTam[1],aTam[2]})
AADD(aArqTemp,{"MESANO"	,"C",6,0})
aTam:=TamSX3("C7_NUM")
AADD(aArqTemp,{"C7_NUM"	,"C",aTam[1],aTam[2]})
AADD(aArqTemp,{"C7_EMISSAO"	,"C",8,0})
aTam:=TamSX3("C7_GRUPCOM")
AADD(aArqTemp,{"C7_GRUPCOM"	,"C",aTam[1],aTam[2]})
aTam:=TamSX3("A2_NOME")
AADD(aArqTemp,{"A2_NOME"	,"C",aTam[1],aTam[2]})
aTam:=TamSX3("C8_NUM")
AADD(aArqTemp,{"C8_NUM"	,"C",aTam[1],aTam[2]})
AADD(aArqTemp,{"C8_EMISSAO"	,"C",8,0})
aTam:=TamSX3("C8_FORNECE")
AADD(aArqTemp,{"C8_FORNECE"	,"C",aTam[1],aTam[2]})
aTam:=TamSX3("C8_LOJA")
AADD(aArqTemp,{"C8_LOJA"	,"C",aTam[1],aTam[2]})
aTam:=TamSX3("C1_NUM")
AADD(aArqTemp,{"C1_NUM"	,"C",aTam[1],aTam[2]})
AADD(aArqTemp,{"C1_EMISSAO"	,"C",8,0})
AADD(aArqTemp,{"TOTFOR"	,"N",2,0})
aTam:=TamSX3("C7_TOTAL")
AADD(aArqTemp,{"C7_TOTAL"	,"N",aTam[1],aTam[2]})
AADD(aArqTemp,{"TIPO"	,"C",1,0})

AADD(aArqTemp,{"EMERGE"	,"C",8,0})
AADD(aArqTemp,{"EMEOBS"	,"C",200,0})
		
cArqTemp2:=oTempTable:SetFields(aArqTemp)
oTempTable:Create()
//cIndTemp2:=Substr(CriaTrab(NIL,.F.),1,7)+"1"
dbUseArea(.T.,nil,cArqTemp2,"TMPSC7",.T.,.F.)
IndRegua("TMPSC7",cIndTemp2,"C7_FILIAL+C7_CC+TIPO+C7_EMISSAO")
DbClearIndex()
DbSetIndex(cIndTemp2+OrdBagExt())
oTempTable:Delete()

aArqTemp2 :={}
aTam:=TamSX3("C7_FILIAL")
AADD(aArqTemp2,{"FILIAL"	,"C",aTam[1],aTam[2]})
aTam:=TamSX3("C7_CC")
AADD(aArqTemp2,{"CCUSTO"	,"C",aTam[1],aTam[2]})
aTam:=TamSX3("C7_QUANT")
AADD(aArqTemp2,{"TOTQTDCC"	,"N",aTam[1],aTam[2]})
aTam:=TamSX3("C7_TOTAL")
AADD(aArqTemp2,{"TOTVLRCC"	,"N",aTam[1],aTam[2]})
aTam:=TamSX3("C7_QUANT")
AADD(aArqTemp2,{"TOTQTDPC"	,"N",aTam[1],aTam[2]})
aTam:=TamSX3("C7_TOTAL")
AADD(aArqTemp2,{"TOTVLRPC"	,"N",aTam[1],aTam[2]})
aTam:=TamSX3("C7_QUANT")
AADD(aArqTemp2,{"TOTQTDPD"	,"N",aTam[1],aTam[2]})
aTam:=TamSX3("C7_TOTAL")
AADD(aArqTemp2,{"TOTVLRPD"	,"N",aTam[1],aTam[2]})
//Leonardo Freire 24/07/2015     
aTam:=TamSX3("C7_QUANT")
AADD(aArqTemp2,{"TOTQTDEM"	,"N",aTam[1],aTam[2]})
aTam:=TamSX3("C7_TOTAL")
AADD(aArqTemp2,{"TOTVLREM"	,"N",aTam[1],aTam[2]})

cArqTemp3:=oTempTable:SetFields(aArqTemp2)
oTempTable:Create()
//cIndTemp3:=Substr(CriaTrab(NIL,.F.),1,7)+"1"
dbUseArea(.T.,nil,cArqTemp3,"TMPSC72",.T.,.F.)
IndRegua("TMPSC72",cIndTemp3,"FILIAL+CCUSTO")
DbClearIndex()
DbSetIndex(cIndTemp3+OrdBagExt())
oTempTable:Delete()


cQuery+=" SELECT C7_FILIAL, C7_CC, SUBSTRING(C7_EMISSAO,1,6) AS MESANO, C7_NUM, C7_EMISSAO, C7_GRUPCOM, C7_FORNECE, C7_LOJA, A2_NOME, C8_NUM, C8_EMISSAO, C8_FORNECE, C8_LOJA ,C1_NUM, C1_EMISSAO, C7_XEMERGE, C7_XEMEOBS , " + cCrLf
cQuery+=" (SELECT COUNT(DISTINCT C8_FORNECE) FROM "+RetSqlName("SC8") +" SC82 WHERE SC82.C8_FILIAL = SC7.C7_FILIAL AND SC82.C8_NUM = SC8.C8_NUM AND SC82.D_E_L_E_T_ = ' ' ) AS TOTFOR, " + cCrLf
cQuery+=" (SELECT SUM(C7_TOTAL) FROM "+RetSqlName("SC7") +" SC72 WHERE SC72.C7_FILIAL = SC7.C7_FILIAL AND SC72.C7_NUM = SC7.C7_NUM AND SC72.D_E_L_E_T_ = ' ') AS C7_TOTAL " + cCrLf

cQuery+=" FROM "+RetSqlName("SC7") +" SC7 "  + cCrLf
cQuery+=" 		INNER JOIN "+RetSqlName("SA2") +" SA2 ON " + cCrLf
cQuery+=" 			C7_FORNECE  = A2_COD AND " + cCrLf
cQuery+=" 			C7_LOJA     = A2_LOJA AND " + cCrLf
cQuery+=" 			SA2.D_E_L_E_T_ = ' ' " + cCrLf


cQuery+=" 		LEFT OUTER JOIN "+RetSqlName("SC8") +" SC8 ON " + cCrLf
///// Alterado por Leonardo Freire 23/09/2015.
//cQuery+=" 			C7_NUM    = C8_NUMPED AND " + cCrLf
//cQuery+=" 			C8_FILIAL = '"+xFilial("SC8")+"' AND " + cCrLf
//cQuery+="			C8_NUM BETWEEN  '"+MV_PAR11+"'  AND  '"+MV_PAR12+"' AND " + cCrLf
//cQuery+="			C8_EMISSAO BETWEEN    '"+Dtos(MV_PAR13)+"'  AND '"+Dtos(MV_PAR14)+"' AND " + cCrLf
//cQuery+=" 			SC8.D_E_L_E_T_ = ' ' " + cCrLf       

cQuery+="    C7_FILIAL = '"+xFilial("SC8")+"' AND " + cCrLf
cQuery+="    C7_NUM    = C8_NUMPED AND " + cCrLf   
cQuery+="    C7_ITEM   = C8_ITEMPED AND " + cCrLf  
cQuery+=" 			SC8.D_E_L_E_T_ = ' ' " + cCrLf       

cQuery+=" 		LEFT OUTER JOIN "+RetSqlName("SC1") +" SC1 ON " + cCrLf
//cQuery+=" 			C7_NUMSC  = C1_NUM AND " + cCrLf
//cQuery+=" 			C1_FILIAL = '"+xFilial("SC1")+"' AND " + cCrLf
//Query+=" 			    C1_NUM BETWEEN  '"+MV_PAR03+"'  AND  '"+MV_PAR04+"' AND " + cCrLf
//cQuery+=" 			C1_EMISSAO BETWEEN    '"+Dtos(MV_PAR05)+"'  AND '"+Dtos(MV_PAR06)+"' AND " + cCrLf

cQuery+="    C1_FILIAL = '"+xFilial("SC1")+"' AND " + cCrLf
cQuery+="    C7_NUMSC  = C1_NUM AND " + cCrLf
cQuery+="    C7_ITEMSC  = C1_ITEM AND " + cCrLf
cQuery+=" 	 SC1.D_E_L_E_T_ = ' ' " + cCrLf
 
/// fim da alteração 22/09/2015.

cQuery+=" WHERE C7_FILIAL = '"+xFilial("SC7")+"' " + cCrLf
cQuery+=" AND C7_CONTRA  = '' " + cCrLf
cQuery+=" AND C7_CC BETWEEN  '"+MV_PAR01+"'  AND  '"+MV_PAR02+"' " + cCrLf
cQuery+=" AND C7_NUM BETWEEN  '"+MV_PAR07+"'  AND  '"+MV_PAR08+"' " + cCrLf
cQuery+=" AND C7_EMISSAO BETWEEN    '"+Dtos(MV_PAR09)+"'  AND '"+Dtos(MV_PAR10)+"' " + cCrLf

cQuery+=" AND SC7.D_E_L_E_T_ = ' ' " + cCrLf 

// Leonardo Freire 03/08/2015                                             
cQuery+=" AND SC7.C7_CONAPRO = 'L' " + cCrLf
//Leonardo Freire 03/08/2015

cQuery+=" GROUP BY C7_FILIAL, C7_CC, SUBSTRING(C7_EMISSAO,1,6), C7_NUM, C7_EMISSAO, C7_GRUPCOM, C7_FORNECE, C7_LOJA, A2_NOME, C8_NUM, C8_EMISSAO, C8_FORNECE, C8_LOJA, C1_NUM, C1_EMISSAO , C7_XEMERGE, C7_XEMEOBS	" + cCrLf
cQuery+=" ORDER BY C7_FILIAL, C7_CC, C7_EMISSAO " + cCrLf

Memowrite("C:\temp\PNR001.txt",cQuery)

If Select("TRBPNR")>0
	DbSelectArea("TRBPNR")
	DbCloseArea()
EndIf

TcQuery cQuery New ALias "TRBPNR"
DbSelectArea("TRBPNR")
DbGotop()

If !TRBPNR->(EOF())
	
	While !TRBPNR->(EOF())
		
		RecLock("TMPSC7",.T.)
		
		TMPSC7->C7_FILIAL := xFilial("SC7")
		TMPSC7->C7_CC     := TRBPNR->C7_CC
		TMPSC7->MESANO    := TRBPNR->MESANO
		TMPSC7->C7_NUM    := TRBPNR->C7_NUM
		TMPSC7->C7_EMISSAO:= TRBPNR->C7_EMISSAO
		TMPSC7->C7_GRUPCOM:= TRBPNR->C7_GRUPCOM
		TMPSC7->A2_NOME   := TRBPNR->A2_NOME
		TMPSC7->C8_NUM    := TRBPNR->C8_NUM
		TMPSC7->C8_EMISSAO:= TRBPNR->C8_EMISSAO
		TMPSC7->C8_FORNECE:= TRBPNR->C8_FORNECE
		TMPSC7->C8_LOJA   := TRBPNR->C8_LOJA
		TMPSC7->C1_NUM    := TRBPNR->C1_NUM
		TMPSC7->C1_EMISSAO:= TRBPNR->C1_EMISSAO
		TMPSC7->TOTFOR    := TRBPNR->TOTFOR
		TMPSC7->C7_TOTAL  := TRBPNR->C7_TOTAL
		TMPSC7->TIPO      := IIF( EMPTY(TRBPNR->C8_NUM),"B","A")

		TMPSC7->EMERGE := TRBPNR->C7_XEMERGE
		TMPSC7->EMEOBS := TRBPNR->C7_XEMEOBS

		_nCount++
		
		("TMPSC7")->(MsUnLock())
		
		_aArea := GetArea()		
		
		DbSelectArea("TMPSC72")
		("TMPSC72")->(DbSetOrder(1))
		If !("TMPSC72")->(DbSeek(TMPSC7->C7_FILIAL+TMPSC7->C7_CC))
	
			RecLock("TMPSC72",.T.)
				
			TMPSC72->FILIAL    := TMPSC7->C7_FILIAL
			TMPSC72->CCUSTO    := TMPSC7->C7_CC
			TMPSC72->TOTQTDCC  := 1
			TMPSC72->TOTVLRCC  := TMPSC7->C7_TOTAL
			// Leonardo Freire 24/07/2015
		    IF 	ALLTRIM(TMPSC7->EMERGE) == 'S'
				TMPSC72->TOTQTDEM  := 1
				TMPSC72->TOTVLREM  := TMPSC7->C7_TOTAL
			EndIF
			//////////////////////////////
			
			If TMPSC7->TIPO $ "A"
				TMPSC72->TOTQTDPC  := 1
				TMPSC72->TOTVLRPC  := TMPSC7->C7_TOTAL
				TMPSC72->TOTQTDPD  := 0
				TMPSC72->TOTVLRPD  := 0				
			Else
				TMPSC72->TOTQTDPD  := 1
				TMPSC72->TOTVLRPD  := TMPSC7->C7_TOTAL
				TMPSC72->TOTQTDPC  := 0
				TMPSC72->TOTVLRPC  := 0								
			EndIf			
			
			("TMPSC72")->(MsUnLock())
	
		Else
		
			RecLock("TMPSC72",.F.)
				
			TMPSC72->TOTQTDCC  += 1
			TMPSC72->TOTVLRCC  += TMPSC7->C7_TOTAL
		    // Leonardo Freire 24/07/2015
		    IF 	TMPSC7->EMERGE = 'S'
				TMPSC72->TOTQTDEM  += 1
				TMPSC72->TOTVLREM  += TMPSC7->C7_TOTAL
			EndIF
			//////////////////////////////           
			
			
			If TMPSC7->TIPO $ "A"
				TMPSC72->TOTQTDPC  += 1
				TMPSC72->TOTVLRPC  += TMPSC7->C7_TOTAL
			Else
				TMPSC72->TOTQTDPD  += 1
				TMPSC72->TOTVLRPD  += TMPSC7->C7_TOTAL
			EndIf        
			
			
			
			("TMPSC72")->(MsUnLock())			
		
		EndIf    
		
		aTotGeral[1] += 1
		aTotGeral[2] += TMPSC7->C7_TOTAL
		
		If (nPos := aScan( aTotCC, { |x| x[1] == TMPSC7->C7_CC } ) ) == 0
			aAdd( aTotCC, { TMPSC7->C7_CC, TMPSC7->C7_TOTAL } )
		Else
			aTotCC[nPos][2] += TMPSC7->C7_TOTAL
		EndIf
		
		RestArea(_aArea)
		
		TRBPNR->(DBSKIP())
		
	EndDo
	
	Processa( {|lFim| xGerPlan() }, "Gerando relatório.....")
	
Else
	MsgAlert( "Não há dados a serem apresentados!" )
EndIf


If Select("TMPSC7")>0
	DbSelectArea("TMPSC7")
	DbCloseArea()
EndIf

If Select("TMPSC72")>0
	DbSelectArea("TMPSC72")
	DbCloseArea()
EndIf

If Select("TRBPNR")>0
	dbSelectArea("TRBPNR")
	DbCloseArea()
EndIf

Ferase(cArqTemp2+GetDBExtension())
Ferase(cIndTemp2+OrdBagExt())

Ferase(cArqTemp3+GetDBExtension())
Ferase(cIndTemp3+OrdBagExt())

Return

*************************************************************************************************************************

Static Function xGerPlan()

LOCAL cDirDocs  := MsDocPath()
Local aStru		:= {}
Local cArquivo 	:= CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local Arquivo
Local cMesAno   := ""
Local cCCusto   := ""
Local cTipo     := ""
//Local cCampos   := "Num PC;Dt.Emiss PC;Num SC;Dt.Emiss SC;Num Cotação;Dt.Emiss Cotação;Obs.Gestores;Obs.Compradores;Grp.Compras;Vlr.Total;Tot.Part.Cotação;Fornecedor PC;"
Local cCampos   := "Num PC;Dt.Emiss PC;Num SC;Dt.Emiss SC;Num Cotação;Dt.Emiss Cotação;Obs.Gestores;Obs.Compradores;Grp.Compras;Vlr.Total;Tot.Part.Cotação;Fornecedor PC;Emergencial;Obs.Emergencia;"
Local cVlrCpos  := ""
Local cVlrSubtot:= ""
Local cVlrSubt2 := ""
Local cVlrtot   := 0
Local nTotPed   := 0
Local nTotPedCC := 0
Local nQtdPed   := 0
Local nQtdPedCC := 0
Local nQtdTotal := 0
Local nVlrTotal := 0
Local nPercPed  := 0
Local nPercPed1 := 0
Local nPos      := 0
Local cObsCom   := ""
Local cObsGes   := ""
Local lFirst    := .T.

Private aBox
Private cLogo := IIf((AllTrim(SM0->M0_CODFIL) == '0101'), 'LogoPNovo.png', 'LogoTCR.png')
Private aCab := {}
Private lEnd := .F.
Private nLin := 10000

Private oFontaN := TFont():New('Verdana',, 10,, .T.,,,,, .F., .F.)
Private oFontbN := TFont():New('Verdana',, 06,, .T.,,,,, .F., .F.)
Private oFontc := TFont():New('Verdana',, 16,, .F.,,,,, .F., .F.)
Private oFontcN := TFont():New('Verdana',, 16,, .T.,,,,, .F., .F.)
Private oFonte := TFont():New('Verdana',, 09,, .F.,,,,, .F., .F.)
Private oFonteN := TFont():New('Verdana',, 09,, .T.,,,,, .F., .F.)
Private oFontfN := TFont():New('Verdana',, 23,, .T.,,,,, .F., .F.)
Private oFontg := TFont():New('Verdana',, 08,, .F.,,,,, .F., .F.)
Private oFontgN := TFont():New('Verdana',, 08,, .T.,,,,, .F., .F.)
Private oFonthN := TFont():New('Verdana',, 14,, .T.,,,,, .F., .F.)
Private oBrush1 := TBrush():New(, RGB(235, 235, 235))
Private oBrush2 := TBrush():New(, RGB(250, 250, 250))
Private oBrush3 := TBrush():New(, RGB(248, 202, 139))

Private aDadExc1 := {}
Private aDadExc2 := {}

Private oPrn := TmsPrinter():New('Análise de Compras de Fornecedores')
Private nMaxH := 0
Private nMaxV := 0

Private aDimObj1
Private aDimObj2
Private aDimObj3
Private aDimObj4
Private aDimObj5
Private aDimObj6
Private aDimObj7

oPrn:SetLandScape()
oPrn:SetSize(297, 210)

nMaxV := oPrn:nVertRes()
nMaxH := oPrn:nHorzRes()
aBox := {{0055, 200, 500, 1300 , 1500, 1600, 1800, 2100, (nMaxH - 55)}}

cTitulo := 'Análise de Compras de Fornecedores'

aAdd(aCab, cTitulo)


Arquivo := MsfCreate(cDirDocs+"\"+cArquivo+".csv",0)

If Arquivo > 0
	
	DbSelectArea("TMPSC7")
	("TMPSC7")->(DbSetOrder(1))
	("TMPSC7")->(dbGoTop())
	
	ProcREgua(_nCount)
	
	While ("TMPSC7")->(!Eof())
		
		IncProc("Gerando arquivo...")
		
		If lFirst == .T.
			//If (nLin > (nMaxV - ((nMaxV / 100) * 7)))
			
			/*/ Imprime o cabecalho do relatorio /*/
			nLin := PNRCabec()
			
			/*/ Imprime o identificador do C. Custo /*/
			nLin := PNRCabCC()
			
			/*/ Imprime o tipo de pedido /*/
			If TMPSC7->TIPO $ "A"
				nLin := PNRTipPC(1)
			Else
				nLin := PNRTipPC(2)
			EndIf
			
			/*/ Imprime o cabeçalho das colunas /*/
			nLin := PNRCabec2()
			
			//EndIf
		Else
		    
			If cTipo <> TMPSC7->TIPO
			    
				If (nLin > (nMaxV - ((nMaxV / 100) * 7)))
			
					//Imprime o cabecalho do relatorio
					nLin := PNRCabec()
			 	EndIf
			 	
				If cCCusto <> TMPSC7->C7_CC

					/*/ Imprime o identificador do C. Custo /*/
					nLin := PNRCabCC()
			    
			    EndIf			 	   
			
				/*/ Imprime o tipo de pedido /*/
				If TMPSC7->TIPO $ "A"
					nLin := PNRTipPC(1)
				Else
					nLin := PNRTipPC(2)
				EndIf        
				
				/*/ Imprime o cabeçalho das colunas /*/
				nLin := PNRCabec2()
				
			
			ElseIf cCCusto <> TMPSC7->C7_CC

				If (nLin > (nMaxV - ((nMaxV / 100) * 7)))
			
					//Imprime o cabecalho do relatorio
					nLin := PNRCabec()
			 	EndIf
			 	
				/*/ Imprime o identificador do C. Custo /*/
				nLin := PNRCabCC()
				
				/*/ Imprime o tipo de pedido /*/
				If TMPSC7->TIPO $ "A"
					nLin := PNRTipPC(1)
				Else
					nLin := PNRTipPC(2)
				EndIf        
				
				/*/ Imprime o cabeçalho das colunas /*/
				nLin := PNRCabec2()							 				
			
			EndIf
			
		EndIf

		
		If (nLin > (nMaxV - ((nMaxV / 100) * 7)))
			
			//Imprime o cabecalho do relatorio
			nLin := PNRCabec()
			
			/*/ Imprime o cabeçalho das colunas /*/
			nLin := PNRCabec2()
		EndIf
		
		/*/ Imprime os itens /*/
		nLin := PNRItPc(1)		

		
		//EXCEL------------------------------------------------------------
		If MV_PAR15 == 1
			
			If cTipo <> TMPSC7->TIPO .OR. cCCusto <> TMPSC7->C7_CC
				
				If nQtdPed > 0
					
					If cTipo $ "A"
						
						cVlrSubt2  := "%Vlr.Ped.Completos:;"
						
						cVlrSubtot := "Qtd.Ped.Completos:;"
						cVlrSubtot += ALLTRIM(STR(nQtdPed))+";"
						cVlrSubtot += "Vlr.Ped.Completos:;"
						cVlrSubtot += Transform(nTotPed ,"@E 999,999,999.99")  + ";"
					Else
						cVlrSubt2  := "%Vlr.Ped.Diretos:;"
						
						cVlrSubtot := "Qtd.Ped.Diretos:;"
						cVlrSubtot += ALLTRIM(STR(nQtdPed))+";"
						cVlrSubtot += "Vlr.Ped.Diretos:;"
						cVlrSubtot += Transform(nTotPed ,"@E 999,999,999.99")  + ";"
					EndIf
					
					nPos       := aScan( aTotCC, { |x| x[1] == cCCusto } )
					nPercPed   := ALLTRIM( STR( ROUND( (nTotPed*100)/aTotCC[nPos][2],2 ) ) )
					cVlrSubt2  += nPercPed+"%;"
					
					fWrite(Arquivo,";;;;;;;;;"+cVlrSubt2 )
					fWrite(Arquivo,cCrLf + ";;;;;;"+cVlrSubtot+cCrLf+cCrLf )
					
				EndIf
				
				nTotPed   := 0
				nQtdPed   := 0
			EndIf
			
			If cCCusto <> TMPSC7->C7_CC
				
				If lFirst == .F.
					cVlrSubtot := "Total Qtd.CC:;"
					cVlrSubtot += ALLTRIM(STR(nQtdPedCC))+";"
					cVlrSubtot += "Total Vlr.CC:;"
					cVlrSubtot += Transform(nTotPedCC ,"@E 999,999,999.99")  + ";"
					
					fWrite(Arquivo,cCrLf + ";;;;;;"+cVlrSubtot+cCrLf+cCrLf )
				Else
					
					fWrite(Arquivo,"Período de:;"+DTOC(MV_PAR09)+";a;"+DTOC(MV_PAR10)+";"+cCrLf+cCrLf )
					
				EndIf
				
				fWrite(Arquivo,"C.Custo:"+ ";'" + TMPSC7->C7_CC + ";" + cCrLf + cCrLf + cCampos + cCrLf )
				
				nTotPed   := 0
				nQtdPed   := 0
				nTotPedCC := 0
				nQtdPedCC := 0
				//fWrite(Arquivo,TMPSC7->C7_CC + ";" )
				//fWrite(Arquivo, cCrLf + cCrLf ) // Pula linha
				//fWrite(Arquivo, cCampos)
				//fWrite(Arquivo, cCrLf + cCrLf )
			EndIf
			
			
			cVlrCpos  := "'"+TMPSC7->C7_NUM+";"
			cVlrCpos  += DTOC(STOD(TMPSC7->C7_EMISSAO))+";"
			cVlrCpos  += "'"+TMPSC7->C1_NUM+";"
			cVlrCpos  += DTOC(STOD(TMPSC7->C1_EMISSAO))+";"
			cVlrCpos  += "'"+TMPSC7->C8_NUM+";"
			cVlrCpos  += DTOC(STOD(TMPSC7->C8_EMISSAO))+";"
			cVlrCpos  += PNR001A(1)+";"
			cVlrCpos  += PNR001A(2)+";"
			cVlrCpos  += "'"+TMPSC7->C7_GRUPCOM+";"
			cVlrCpos  += Transform(TMPSC7->C7_TOTAL ,"@E 999,999,999.99")  + ";"
			cVlrCpos  += ALLTRIM(STR(TMPSC7->TOTFOR))+" ;"
			cVlrCpos  += ALLTRIM(TMPSC7->A2_NOME)+" ;"

			cVlrCpos  += ALLTRIM(TMPSC7->EMERGE)+" ;"
			cVlrCpos  += ALLTRIM(TMPSC7->EMEOBS)+" ;"

			cVlrCpos  += cCrLf
			
			fWrite(Arquivo,cVlrCpos)
			
			nQtdPed++
			nTotPed     += TMPSC7->C7_TOTAL
			nQtdPedCC++
			nTotPedCC   += TMPSC7->C7_TOTAL
			nQtdTotal++
			nVlrTotal   += TMPSC7->C7_TOTAL
			
		EndIf
		
		//EXCEL------------------------------------------------------------
		
		lFirst      := .F.
		cTipo       := TMPSC7->TIPO
		cMesAno     := TMPSC7->MESANO
		cCCusto     := TMPSC7->C7_CC
			
		("TMPSC7")->(dbSkip())
		
		If ("TMPSC7")->(EOF())
			
			If MV_PAR15 == 1
				
				If nQtdPed > 0
					
					If cTipo $ "A"
						
						cVlrSubt2  := "%Vlr.Ped.Completos:;"
						
						cVlrSubtot := "Qtd.Ped.Completos:;"
						cVlrSubtot += ALLTRIM(STR(nQtdPed))+";"
						cVlrSubtot += "Vlr.Ped.Completos:;"
						cVlrSubtot += Transform(nTotPed ,"@E 999,999,999.99")  + ";"
					Else
						cVlrSubt2  := "%Vlr.Ped.Diretos:;"
						
						cVlrSubtot := "Qtd.Ped.Diretos:;"
						cVlrSubtot += ALLTRIM(STR(nQtdPed))+";"
						cVlrSubtot += "Vlr.Ped.Diretos:;"
						cVlrSubtot += Transform(nTotPed ,"@E 999,999,999.99")  + ";"
					EndIf
					
					nPos       := aScan( aTotCC, { |x| x[1] == cCCusto } )
					nPercPed   := ALLTRIM( STR( ROUND( (nTotPed*100)/aTotCC[nPos][2],2 ) ) )
					cVlrSubt2  += nPercPed+"%;"
					
					fWrite(Arquivo,";;;;;;;;;"+cVlrSubt2 )
					fWrite(Arquivo,cCrLf + ";;;;;;"+cVlrSubtot+cCrLf+cCrLf )
					
					cVlrSubtot := "Total Qtd.CC:;"
					cVlrSubtot += ALLTRIM(STR(nQtdPedCC))+";"
					cVlrSubtot += "Total Vlr.CC:;"
					cVlrSubtot += Transform(nTotPedCC ,"@E 999,999,999.99")  + ";"
					
					fWrite(Arquivo,cCrLf + ";;;;;;"+cVlrSubtot+cCrLf+cCrLf )
					
					
					cVlrtot := "Qtd.Total.Ped:;"
					cVlrtot += ALLTRIM(STR(nQtdTotal))+";"
					cVlrtot += "Vlr.Total.Ped:;"
					cVlrtot += Transform(nVlrTotal ,"@E 999,999,999.99")  + ";"
					
					fWrite(Arquivo,";;;;;;"+cVlrtot )
					
				EndIf
				
			EndIf
			
		EndIF
		
	Enddo
	
	fClose(Arquivo)
	
	oPrn:EndPage()
	oPrn:Preview()
	
	If MV_PAR15 == 1
		
		CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
		
		If ! ApOleClient( 'MsExcel' )
			MsgAlert( "ERRO - Microsoft Excel não instalado" )
			Return
		EndIf
		
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" )
		oExcelApp:SetVisible(.T.)
		
	EndIf
	
	FErase(cPath+cArquivo+".CSV" )
	
Else
	
	MsgAlert( "Falha na criação do arquivo" )
	
Endif

Return

//-----------------------------------------------------------------------------------------------------------------------------------
Static Function PNR001A(nTab)

Local cLinha  := ""
Local cLinTmp := ""
Local _aArea := GetArea()
Local nx := 0
If nTab == 1
	
	DbSelectArea("SCR")
	("SCR")->(DbSetOrder(1))
	IF ("SCR")->(DbSeek(xFilial("SCR")+"PC"+TMPSC7->C7_NUM))
		
		While ("SCR")->(!EOF()) .AND. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SC7")+"PC"+TMPSC7->C7_NUM
			
			cLinTmp := ""
			
			For nX := 1 to MlCount(SCR->CR_XOBSAPR,150)
				cLinTmp += Alltrim(MemoLine(SCR->CR_XOBSAPR,150,nX)) + " "
			Next nX
			
			cLinTmp := StrTran(cLinTmp,';',",")
			cLinha += IIF( EMPTY(ALLTRIM(cLinTmp)),"",ALLTRIM(cLinTmp)+"#")
			
			("SCR")->(DbSkip())
		EndDo
		
		
	Else
		cLinha := ""
	EndIF
	
Else
	
	DbSelectArea("SC8")
	("SC8")->(DbSetOrder(1))
	IF ("SC8")->(DbSeek(xFilial("SC8")+TMPSC7->C8_NUM+TMPSC7->C8_FORNECE+TMPSC7->C8_LOJA))
		
		While ("SC8")->(!EOF()) .AND. SC8->C8_FILIAL+SC8->C8_NUM+SC8->C8_FORNECE+SC8->C8_LOJA == xFilial("SC8")+TMPSC7->C8_NUM+TMPSC7->C8_FORNECE+TMPSC7->C8_LOJA
			
			cLinTmp := ""
			
			For nX := 1 to MlCount(SC8->C8_XOBSCOT,150)
				cLinTmp += Alltrim(MemoLine(SC8->C8_XOBSCOT,150,nX)) + " "
			Next nX
			
			cLinTmp := StrTran(cLinTmp,';',",")
			cLinha += IIF( EMPTY(ALLTRIM(cLinTmp)),"",ALLTRIM(cLinTmp)+"#")
			
			("SC8")->(DbSkip())
		EndDo
		
	Else
		cLinha := ""
	EndIF
EndIf

RestArea(_aArea)

Return(cLinha)

*************************************************************************************************************************

Static Function PNRCabec()
Local nX :=0
Local nY :=0

If !File(cLogo)
	cLogo := ('lgrl' + AllTrim(SM0->M0_CODIGO) + '.bmp')
	If !File(cLogo)
		cLogo := 'lgrl.bmp'
	EndIf
EndIf

cLogo := IIf((cLogo == Nil), '', cLogo)
aCab := IIf((aCab == Nil), {''}, aCab)

oPrn:EndPage()
oPrn:StartPage()

/*/ Calcula disposicao/dimensoes do box da pagina do relatorio /*/
aADisp1 := {0000, 0000, nMaxV, nMaxH}
aObjHor1 := {{98}}
aObjVer1 := {{98}}
aObjMar1 := {50, 50, 50, 0, 0}
aDimObj1 := LMPCalcObj(1, aADisp1, aObjHor1, aObjVer1, aObjMar1)

/*/ Desenha o box da pagina /*/
For nX := 1 To Len(aDimObj1)
	For nY := 1 To Len(aDimObj1[nX])
		oPrn:Box(aDimObj1[nX, nY, 1], aDimObj1[nX, nY, 2], aDimObj1[nX, nY, 3], aDimObj1[nX, nY, 4])	// Box da Pagina.
	Next
Next

/*/ Calcula disposicao/dimensoes dos boxs do cabecalho do relatorio /*/
aADisp2 := {aDimObj1[1, 1, 1], aDimObj1[1, 1, 2], aDimObj1[1, 1, 3], aDimObj1[1, 1, 4]}
//aObjHor2 := {{06, 50, 24, 10, 10}}
aObjHor2 := {{06, 34, 20 ,20, 10, 10}}
aObjVer2 := {{7, 7, 7, 7, 7, 7}}
aObjMar2 := {5, 5, 10, 5, 5}
aDimObj2 := LMPCalcObj(1, aADisp2, aObjHor2, aObjVer2, aObjMar2)

/*/ Desenha os boxes do cabecalho /*/
For nX := 1 To Len(aDimObj2)
	For nY := 1 To Len(aDimObj2[nX])
		oPrn:Box(aDimObj2[nX, nY, 1], aDimObj2[nX, nY, 2], aDimObj2[nX, nY, 3], aDimObj2[nX, nY, 4])		// Box do cabecalho
		If (nY == 1)
			oPrn:SayBitmap((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 5), cLogo, 0189, 0139)													// Impressao do Logotipo.
		ElseIf (nY == 2)
			oPrn:Say((aDimObj2[nX, nY, 1] + 20), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), aCab[Len(aCab)], oFonthN,,,, 2)					// Impressao do Titulo.
			oPrn:Say((aDimObj2[nX, nY, 1] + 100), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), 'PERIODO: [' + DtoC(mv_par09) + ' ate ' + DtoC(mv_par10) + ']', oFontaN,,,, 2)					// Impressao do Titulo.
		ElseIf (nY == 3)
			/*/ Total no periodo /*/
			
			
			oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Qtd.Total', oFontgN,,,, 0)									// Pagina
			oPrn:Say((aDimObj2[nX, nY, 1] + 50), (aDimObj2[nX, nY, 4] - 10), Transform(aTotGeral[1], '@E 9,999,999,999'), oFonthN,, RGB(215, 215, 215),, 1)
		ElseIf (nY == 4)
			/*/ Total no periodo /*/
			
			
			oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Vlr.Total', oFontgN,,,, 0)									// Pagina
			oPrn:Say((aDimObj2[nX, nY, 1] + 50), (aDimObj2[nX, nY, 4] - 10), Transform(aTotGeral[2], '@E 9,999,999,999.99'), oFonthN,, RGB(215, 215, 215),, 1)
		ElseIf (nY == 5)
			oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Data/Hora', oFontgN,,,, 0)									// Data/Hora
			oPrn:Say((aDimObj2[nX, nY, 1] + 50), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), DtoC(dDataBase), oFontaN,, RGB(215, 215, 215),, 2)
			oPrn:Say((aDimObj2[nX, nY, 1] + 100), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), Time(), oFontaN,, RGB(215, 215, 215),, 2)
		ElseIf (nY == 6)
			oPrn:Say((aDimObj2[nX, nY, 1] + 10), (aDimObj2[nX, nY, 2] + 10), 'Pagina(s)', oFontgN,,,, 0)									// Pagina
			oPrn:Say((aDimObj2[nX, nY, 1] + 50), ((aDimObj2[nX, nY, 2] + aDimObj2[nX, nY, 4]) / 2), StrZero(oPrn:nPage, 2), oFontfN,, RGB(215, 215, 215),, 2)
		EndIf
	Next
Next

Return(aDimObj2[1, 1, 3])

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Static Function PNRCabCC()

Local cDesCC := ''

nLin += 5

CTT->(DbSetorder(1))
If CTT->(DbSeek(xFilial("CTT") + TMPSC7->C7_CC))
	cDesCC := AllTrim(CTT->CTT_DESC01)
EndIf

DbSelectArea("TMPSC72")
("TMPSC72")->(DbSetOrder(1))
("TMPSC72")->(DbSeek(TMPSC7->C7_FILIAL+TMPSC7->C7_CC)) 

/*/ Desenha o box do cabecalho /*/
oPrn:FillRect({nLin, (aDimObj1[1, 1, 2] + 5), (nLin + 55), (aDimObj1[1, 1, 4] - 5)}, oBrush3)
oPrn:Box(nLin, (aDimObj1[1, 1, 2] + 5), (nLin + 50), (aDimObj1[1, 1, 4] - 5))		// Box do sub-cabecalho
oPrn:Say((nLin + 6), (aDimObj1[1, 1, 2] + 10), 'CENTRO DE CUSTO: ' + AllTrim(TMPSC7->C7_CC) + ' - ' + cDesCC, oFontgN,,,, 0)
oPrn:Say((nLin + 6), aDimObj2[1, 3, 2], 'QTD.TOTAL: ', oFontgN,,,, 0)
oPrn:Say((nLin + 6), aDimObj2[1, 3, 4], Transform(TMPSC72->TOTQTDCC, '@E 9,999,999,999'), oFontgN,,,, 1)
oPrn:Say((nLin + 6), aDimObj2[1, 4, 2], 'VLR.TOTAL: ', oFontgN,,,, 0)
oPrn:Say((nLin + 6), aDimObj2[1, 4, 4], Transform(TMPSC72->TOTVLRCC, '@E 9,999,999,999.99'), oFontgN,,,, 1)  
nLin += 60
  

// Leonardo Freire 24/07/2015  


nPercPed1  := ALLTRIM( STR( ROUND( ((TMPSC72->TOTVLREM*100)/TMPSC72->TOTVLRCC),2 ) ) )
cVlrSubt1  := nPercPed1+"%"

oPrn:FillRect({nLin, (aDimObj1[1, 1, 2] + 5), (nLin + 55), (aDimObj1[1, 1, 4] - 5)}, oBrush1)
oPrn:Box(nLin, (aDimObj1[1, 1, 2] + 5), (nLin + 50), (aDimObj1[1, 1, 4] - 5))		// Box do sub-cabecalho
oPrn:Say((nLin + 6), (aDimObj1[1, 1, 2] + 10), 'PEDIDOS EMERGENCIAIS: ' , oFontgN,,,, 0)
oPrn:Say((nLin + 6), aDimObj2[1, 3, 2], 'QTD.TOTAL: ', oFontgN,,,, 0)
oPrn:Say((nLin + 6), aDimObj2[1, 3, 4], Transform(TMPSC72->TOTQTDEM, '@E 9,999,999,999'), oFontgN,,,, 1)
oPrn:Say((nLin + 6), aDimObj2[1, 4, 2], 'VLR.TOTAL: ', oFontgN,,,, 0)
oPrn:Say((nLin + 6), aDimObj2[1, 4, 4], Transform(TMPSC72->TOTVLREM, '@E 9,999,999,999.99'), oFontgN,,,, 1)  
oPrn:Say((nLin + 6), (aDimObj2[1, 5, 2]) + 10, 'PERCENT: ', oFontgN,,,, 0)
oPrn:Say((nLin + 6), aDimObj2[1, 5, 4], cVlrSubt1, oFontgN,,,, 1)
nLin += 60
         

Return(nLin)

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Static Function PNRTipPC(nopc)

Local cDesTip    := ''
Local nQTD       := 0
Local nVlR       := 0
Local nVLRCC     := TMPSC72->TOTVLRCC
Local nPercPed   := 0
Local cVlrSubt   := 0  
// Leonardo Freire 24/07/2015
Local nPercPed1  := 0
Local cVlrSubt1  := 0

nLin += 5

DbSelectArea("TMPSC72")
("TMPSC72")->(DbSetOrder(1))
("TMPSC72")->(DbSeek(TMPSC7->C7_FILIAL+TMPSC7->C7_CC))

If nopc == 1
	cDesTip := "PEDIDOS COMPLETOS: "
	nQTD    := TMPSC72->TOTQTDPC
	nVlR    := TMPSC72->TOTVLRPC
	
Else
	cDesTip := "PEDIDOS DIRETOS: "
	nQTD    := TMPSC72->TOTQTDPD
	nVlR    := TMPSC72->TOTVLRPD
	
EndIf

nPercPed  := ALLTRIM( STR( ROUND( (nVlR*100)/nVLRCC,2 ) ) )
cVlrSubt  := nPercPed+"%"
					
/*/ Desenha o box do cabecalho /*/
oPrn:FillRect({nLin, (aDimObj1[1, 1, 2] + 5), (nLin + 55), (aDimObj1[1, 1, 4] - 5)}, oBrush1)
oPrn:Box(nLin, (aDimObj1[1, 1, 2] + 5), (nLin + 50), (aDimObj1[1, 1, 4] - 5))		// Box do sub-cabecalho

oPrn:Say((nLin + 6), (aDimObj1[1, 1, 2] + 10), cDesTip, oFontgN,,,, 0)
oPrn:Say((nLin + 6), aDimObj2[1, 3, 2], 'QTD.TOTAL: ', oFontgN,,,, 0)
oPrn:Say((nLin + 6), aDimObj2[1, 3, 4], Transform(nQTD, '@E 9,999,999,999'), oFontgN,,,, 1)
oPrn:Say((nLin + 6), aDimObj2[1, 4, 2], 'VLR.TOTAL: ', oFontgN,,,, 0)
oPrn:Say((nLin + 6), aDimObj2[1, 4, 4], Transform(nVLR, '@E 9,999,999,999.99'), oFontgN,,,, 1)
oPrn:Say((nLin + 6), (aDimObj2[1, 5, 2]) + 10, 'PERCENT: ', oFontgN,,,, 0)
oPrn:Say((nLin + 6), aDimObj2[1, 5, 4], cVlrSubt, oFontgN,,,, 1)

nLin += 60

Return(nLin)

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Static Function PNRCabec2()

Local nY := 0
Local nX := 0 
//Local aSubCab2 := {'NUM PC', 'DT.EMISS.PC', 'NUM SC', 'DT.EMISS.SC', 'NUM COT', 'DT.EMISS.COT', 'GRP.COMPR', 'VLR.TOTAL', 'TOT.PART.COT','FORNECEDOR'}
Local aSubCab2 := {'NUM PC', 'DT.EMISS.PC','EMERGENCIAL', 'NUM SC', 'DT.EMISS.SC', 'NUM COT', 'DT.EMISS.COT', 'GRP.COMPR', 'VLR.TOTAL', 'TOT.PART.COT','FORNECEDOR'}

//If (nOpc == 1)
	nLin += 5
//ElseIf (nOpc == 2)
//	nLin += 15
//EndIf

/*/ Calcula disposicao/dimensoes dos boxs do sub-cabecalho do relatorio /*/
aADisp4 := {nLin, aDimObj1[1, 1, 2], (nLin + 55), aDimObj1[1, 1, 4]}
//aObjHor4 := {{7, 22.12, 7, 16.24, 11.12, 8.12, 8.12, 10.12, 10.16}}
//aObjHor4 := {{8, 8, 8, 8, 8, 8, 8, 10, 10, 24}}
//aObjVer4 := {{100, 100, 100, 100, 100, 100, 100, 100, 100, 100}}
aObjHor4 := {{6, 8, 6, 6, 8, 6, 8, 6, 10, 10, 24}}
aObjVer4 := {{100, 100, 100, 100, 100, 100, 100, 100, 100, 100, 100}}

aObjMar4 := {5, 5, 10, 5, 5}
aDimObj4 := LMPCalcObj(1, aADisp4, aObjHor4, aObjVer4, aObjMar4)

/*/ Desenha os boxes do cabecalho /*/
For nX := 1 To Len(aDimObj4)
	oPrn:FillRect({aDimObj4[1, 1, 1], aDimObj4[1, 1, 2], aDimObj4[1, 1, 3], aDimObj4[1, 9, 4]}, oBrush2)
	For nY := 1 To Len(aDimObj4[nX])
		oPrn:Box(aDimObj4[nX, nY, 1], aDimObj4[nX, nY, 2], aDimObj4[nX, nY, 3], aDimObj4[nX, nY, 4])		// Box do sub-cabecalho
		oPrn:Say((aDimObj4[nX, nY, 1] + 6), ((aDimObj4[nX, nY, 2] + aDimObj4[nX, nY, 4]) / 2), aSubCab2[nY], oFontgN,,,, 2)		// Impressao do Titulo da coluna.
	Next
Next

Return((aDimObj4[1, 1, 3] + 10))

//-------------------------------------------------------------------------------------------------------------------

Static Function PNRItPc()

oPrn:Say(nLin, (aDimObj4[1, 1, 4] - 10), AllTrim(TMPSC7->C7_NUM), oFonte,,,, 1)
oPrn:Say(nLin, (aDimObj4[1, 2, 4] - 10), DTOC(STOD(TMPSC7->C7_EMISSAO)), oFonte,,,, 1)

oPrn:Say(nLin, (aDimObj4[1, 3, 4] - 10), AllTrim(TMPSC7->EMERGE), oFonte,,,, 1)

oPrn:Say(nLin, (aDimObj4[1, 4, 4] - 10), AllTrim(TMPSC7->C1_NUM), oFonte,,,, 1)
oPrn:Say(nLin, (aDimObj4[1, 5, 4] - 10), DTOC(STOD(TMPSC7->C1_EMISSAO)), oFonte,,,, 1)
oPrn:Say(nLin, (aDimObj4[1, 6, 4] - 10), AllTrim(TMPSC7->C8_NUM), oFonte,,,, 1)
oPrn:Say(nLin, (aDimObj4[1, 7, 4] - 10), DTOC(STOD(TMPSC7->C8_EMISSAO)), oFonte,,,, 1)
oPrn:Say(nLin, (aDimObj4[1, 8, 4] - 10), AllTrim(TMPSC7->C7_GRUPCOM), oFonte,,,, 1)
oPrn:Say(nLin, (aDimObj4[1, 9, 4] - 10), Transform(TMPSC7->C7_TOTAL, '@E 999,999,999.99'), oFonte,,,, 1)
oPrn:Say(nLin, (aDimObj4[1, 10, 4] - 10), Transform(TMPSC7->TOTFOR, '@E 999.99'), oFonte,,,, 1)
oPrn:Say(nLin, (aDimObj4[1, 11, 2] + 10), AllTrim(SUBSTR(TMPSC7->A2_NOME,1,30)), oFonte,,,, 0)

nLin += 50

Return(nLin)

*************************************************************************************************
/*
? ?? ? Descricao ? Calcula as dimensoes dos objetos                                                  ? ?? ?
? ?? ???????????????????????????????????????????????????????????????????????????????????????????????? ?? ?
? ??????????????????????????????????????????????????????????????????????????????????????????????????????? ?
??????????????????????????????????????????????????????????????????????????????????????????????????????????
*/
Static Function LMPCalcObj(nTipo, aADisp, aObjHor, aObjVer, aObjMar)

/*/ nTipo /*/
/*/ Tipo de calculo a ser efetuado:/*/
/*/ 1 = Calcula as coordenadas do objeto [linha inicial, coluna inicial, linha final, coluna final] /*/
/*/ 2 = Calcula as coordenadas e a dimensao do objeto [linha inicial, coluna inicial, largura, altura] /*/

/*/ aADisp /*/
/*/ Coordenadas da area disponivel: /*/
/*/ {linha inicial, coluna inicial, linha final, coluna final} /*/

/*/ aObjHor /*/
/*/ Lista os objetos na horizontal (Linhas) e seus respectivos percentuais de ocupacao de area: /*/
/*/ {10, 50, 40} /*/

/*/ aObjVer /*/
/*/ Lista os objetos na vertical (Colunas) e seus respectivos percentuais de ocupacao de area: /*/
/*/ {100, 100, 100} /*/

/*/ aObjMar /*/
/*/ Relacao das margens esquerda, direita, acima, abaixo e entre os objetos: /*/
/*/ {5, 5, 5, 5, 5} /*/

Local aRet := {}
Local nObj := 0
Local nJ:= 0
Local nObjIT := 0
/*/ Cria os elementos do vetor de retorno /*/
For nObj := 1 To Len(aObjVer)
	aAdd(aRet, {})
	For nJ := 1 To Len(aObjHor[nObj])
		aAdd(aRet[nObj], {0, 0, 0, 0})
	Next
Next

/*/ Calcula as dimensoes dos objetos /*/
For nObj := 1 To Len(aRet)
	If (nObj == 1)
		For nObjIT := 1 To Len(aRet[nObj])
			/*/ Calcula as dimensoes do primeiro objeto do vetor /*/
			If (nObjIT == 1)
				If (nTipo == 1)
					/*/ Calcula a linha inicial do objeto /*/
					aRet[nObj, nObjIT, 1] := (aADisp[1] + aObjMar[1])
					
					/*/ Calcula a coluna inicial do objeto /*/
					aRet[nObj, nObjIT, 2] := (aADisp[2] + aObjMar[2])
					
					/*/ Calcula a coluna final do objeto /*/
					nLargura := (aADisp[4] - aADisp[2])
					If (nObjIT == Len(aRet[nObj]))
						/*/ Calcula a coluna final do objeto se ultimo objeto do vetor/*/
						aRet[nObj, nObjIT, 4] := (aRet[nObj, nObjIT, 2] + (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[3]))
					Else
						aRet[nObj, nObjIT, 4] := (aRet[nObj, nObjIT, 2] + (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[5]))
					EndIf
					
					/*/ Calcula a linha final do objeto /*/
					nAltura := (aADisp[3] - aADisp[1])
					If (nObj == Len(aRet))
						/*/ Calcula a linha final do objeto se ultimo objeto do vetor/*/
						aRet[nObj, nObjIT, 3] := (aRet[nObj, nObjIT, 1] + (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[4]))
					Else
						aRet[nObj, nObjIT, 3] := (aRet[nObj, nObjIT, 1] + (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[5]))
					EndIf
				Else
					/*/ Calcula a linha inicial do objeto /*/
					aRet[nObj, nObjIT, 1] := (aADisp[1] + aObjMar[1])
					
					/*/ Calcula a coluna inicial do objeto /*/
					aRet[nObj, nObjIT, 2] := (aADisp[2] + aObjMar[2])
					
					/*/ Calcula a largura do objeto /*/
					nLargura := (aADisp[4] - aADisp[2])
					If (nObjIT == Len(aObjHor[nObj]))
						/*/ Calcula a largura final do objeto se ultimo objeto do vetor/*/
						aRet[nObj, nObjIT, 4] := (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[3])
					Else
						aRet[nObj, nObjIT, 4] := (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[5])
					EndIf
					
					/*/ Calcula a altura do objeto /*/
					nAltura := (aADisp[3] - aADisp[1])
					If (nObjIT == Len(aObjVer[nObj]))
						/*/ Calcula a altura do objeto se ultimo objeto do vetor/*/
						aRet[nObj, nObjIT, 3] := (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[4])
					Else
						aRet[nObj, nObjIT, 3] := (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[5])
					EndIf
				EndIf
			Else
				If (nTipo == 1)
					/*/ Calcula a linha inicial do objeto /*/
					aRet[nObj, nObjIT, 1] := (aADisp[1] + aObjMar[1])
					
					/*/ Calcula a coluna inicial do objeto /*/
					aRet[nObj, nObjIT, 2] := (aRet[nObj, (nObjIT - 1), 4] + aObjMar[5])
					
					/*/ Calcula a coluna final do objeto /*/
					nLargura := (aADisp[4] - aADisp[2])
					If (nObjIT == Len(aObjHor[nObj]))
						/*/ Calcula a coluna final do objeto se ultimo objeto do vetor/*/
						aRet[nObj, nObjIT, 4] := (aRet[nObj, nObjIT, 2] + (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[3]))
					Else
						aRet[nObj, nObjIT, 4] := (aRet[nObj, nObjIT, 2] + (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[5]))
					EndIf
					
					/*/ Calcula a linha final do objeto /*/
					nAltura := (aADisp[3] - aADisp[1])
					If (nObj == Len(aObjHor))
						/*/ Calcula a linha final do objeto se ultimo objeto do vetor/*/
						aRet[nObj, nObjIT, 3] := (aRet[nObj, nObjIT, 1] + (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[4]))
					Else
						aRet[nObj, nObjIT, 3] := (aRet[nObj, nObjIT, 1] + (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[5]))
					EndIf
				Else
					/*/ Calcula a linha inicial do objeto /*/
					aRet[nObj, nObjIT, 1] := (aADisp[1] + aObjMar[1])
					
					/*/ Calcula a coluna inicial do objeto /*/
					aRet[nObj, nObjIT, 2] := ((aRet[nObj, (nObjIT - 1), 2] + aRet[nObj, (nObjIT - 1), 4]) + aObjMar[5])
					
					/*/ Calcula a largura do objeto /*/
					nLargura := (aADisp[4] - aADisp[2])
					If (nObjIT == Len(aObjHor[nObj]))
						/*/ Calcula a coluna final do objeto se ultimo objeto do vetor/*/
						aRet[nObj, nObjIT, 4] := (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[3])
					Else
						aRet[nObj, nObjIT, 4] := (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[5])
					EndIf
					
					/*/ Calcula a altura do objeto /*/
					nAltura := (aADisp[3] - aADisp[1])
					If (nObj == Len(aObjHor))
						/*/ Calcula a linha final do objeto se ultimo objeto do vetor/*/
						aRet[nObj, nObjIT, 3] := (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[4])
					Else
						aRet[nObj, nObjIT, 3] := (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[5])
					EndIf
				EndIf
			EndIf
		Next
	Else
		For nObjIT := 1 To Len(aRet[nObj])
			If (nObjIT == 1)
				If (nTipo == 1)
					/*/ Calcula a linha inicial do objeto /*/
					aRet[nObj, nObjIT, 1] := (aRet[(nObj - 1), nObjIT, 3] + aObjMar[1])
					
					/*/ Calcula a coluna inicial do objeto /*/
					aRet[nObj, nObjIT, 2] := (aADisp[2] + aObjMar[2])
					
					/*/ Calcula a coluna final do objeto /*/
					nLargura := (aADisp[4] - aADisp[2])
					If (nObjIT == Len(aObjHor[nObj]))
						/*/ Calcula a coluna final do objeto se ultimo do vetor /*/
						aRet[nObj, nObjIT, 4] := (aRet[nObj, nObjIT, 2] + (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[3]))
					Else
						aRet[nObj, nObjIT, 4] := (aRet[nObj, nObjIT, 2] + (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[5]))
					EndIf
					
					/*/ Calcula a linha final do objeto /*/
					nAltura := (aADisp[3] - aADisp[1])
					If (nObj == Len(aObjHor))
						/*/ Calcula a linha final do objeto se ultimo do vetor /*/
						aRet[nObj, nObjIT, 3] := (aRet[nObj, nObjIT, 1] + (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[4]))
					Else
						aRet[nObj, nObjIT, 3] := (aRet[nObj, nObjIT, 1] + (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[5]))
					EndIf
				Else
					/*/ Calcula a linha inicial do objeto /*/
					aRet[nObj, nObjIT, 1] := ((aRet[(nObj - 1), nObjIT, 1] + aRet[(nObj - 1), nObjIT, 3]) + aObjMar[1])
					
					/*/ Calcula a coluna inicial do objeto /*/
					aRet[nObj, nObjIT, 2] := (aADisp[2] + aObjMar[2])
					
					/*/ Calcula a largura do objeto /*/
					nLargura := (aADisp[4] - aADisp[2])
					If (nObjIT == Len(aObjHor[nObj]))
						/*/ Calcula a largura do objeto se ultimo do vetor /*/
						aRet[nObj, nObjIT, 4] := (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[3])
					Else
						aRet[nObj, nObjIT, 4] := (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[5])
					EndIf
					
					/*/ Calcula a altura do objeto /*/
					nAltura := (aADisp[3] - aADisp[1])
					If (nObj == Len(aObjVer[nObj]))
						/*/ Calcula a altura do objeto se ultimo do vetor /*/
						aRet[nObj, nObjIT, 3] := (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[4])
					Else
						aRet[nObj, nObjIT, 3] := (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[5])
					EndIf
				EndIf
			Else
				/*/ Calcula a linha inicial do objeto /*/
				aRet[nObj, nObjIT, 1] := (aRet[(nObj - 1), Len(aRet[(nObj - 1)]), 3] + aObjMar[1])
				
				If (nTipo == 1)
					/*/ Calcula a coluna inicial do objeto /*/
					aRet[nObj, nObjIT, 2] := (aRet[nObj, (nObjIT - 1), 4] + aObjMar[5])
					
					/*/ Calcula a coluna final do objeto /*/
					nLargura := (aADisp[4] - aADisp[2])
					If (nObjIT == Len(aObjHor[nObj]))
						/*/ Calcula a coluna final do objeto se ultimo do vetor /*/
						aRet[nObj, nObjIT, 4] := (aRet[nObj, nObjIT, 2] + (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[3]))
					Else
						aRet[nObj, nObjIT, 4] := (aRet[nObj, nObjIT, 2] + (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[5]))
					EndIf
					
					/*/ Calcula a linha final do objeto /*/
					nAltura := (aADisp[3] - aADisp[1])
					If (nObj == Len(aObjVer[nObj]))
						/*/ Calcula a linha final do objeto se ultimo do vetor /*/
						aRet[nObj, nObjIT, 3] := (aRet[nObj, nObjIT, 1] + (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[4]))
					Else
						aRet[nObj, nObjIT, 3] := (aRet[nObj, nObjIT, 1] + (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[5]))
					EndIf
				Else
					/*/ Calcula a coluna inicial do objeto /*/
					aRet[nObj, nObjIT, 2] := ((aRet[nObj, (nObjIT - 1), 2] + aRet[nObj, (nObjIT - 1), 4]) + aObjMar[5])
					
					/*/ Calcula a largura do objeto /*/
					nLargura := (aADisp[4] - aADisp[2])
					If (nObjIT == Len(aObjHor[nObj]))
						/*/ Calcula a largura do objeto se ultimo do vetor /*/
						aRet[nObj, nObjIT, 4] := (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[3])
					Else
						aRet[nObj, nObjIT, 4] := (((nLargura / 100) * aObjHor[nObj, nObjIT]) - aObjMar[5])
					EndIf
					
					/*/ Calcula a altura do objeto /*/
					nAltura := (aADisp[3] - aADisp[1])
					If (nObj == Len(aObjVer[nObj]))
						/*/ Calcula a altura do objeto se ultimo do vetor /*/
						aRet[nObj, nObjIT, 3] := (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[4])
					Else
						aRet[nObj, nObjIT, 3] := (((nAltura / 100) * aObjVer[nObj, nObjIT]) - aObjMar[5])
					EndIf
				EndIf
			EndIf
		Next
	EndIf
Next

Return(aRet)
