#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "colors.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "TBICONN.CH"
#Define cEnt Chr(13)+Chr(10)

//CN9_SITUAC//
//01=Anulado;  02=Elaboracion;03=Emitido;    04=Aprobacion;  ∫±±
//05=Vigente;  06=Paraliza.;  07=Sol. Finalizac;08=Finali.;  ∫±±
//09=Revision; 10=Revisado                                   ∫±±


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ PTNR050   ∫ Autor ≥ Leonardo Freire   ∫ Data ≥  13/03/2015 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ Relatorio contratos por status.                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Porto Novo                                                 ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function PTNR050()  


Private cQuery    := ""
Private cQuery1   := ""
Private TmpCN9    := GetNextAlias()
Private TmpCNA    := GetNextAlias()
Private TmpCND    := GetNextAlias()
Private aCabec    := {}
//Private aDadosCN9 := {}
Private titulo    := 'RelatÛrio Consolidado de Contratos'
Private cSituaca  := ""
Private cUniVig   := ""
Private cCC       := ""
PRIVATE _DESCRI   := ""
PRIVATE nMedicao  := "" 
PRIVATE dDtaMed   := ""
PRIVATE nValorMed := 0



Private aDadosCN9 := {}

Private nCount    := 0
Private aCabBox1  := {"Filial", "Num Contrato","Revisao", "Contratada", "Cnpj", "Tip. Contrato", "Objeto", "Valor Ini.", "Valor Atual", "Saldo", "Dta Ini", "Dta Final", "Vigencia",;
                      "Unid. Vigencia", "Num Medicao","Valor Medicao","Dta. Medicao", "Desc. Pgto", "Status","C.C.", "Dta Assina","Dta Encerra","Clausula","Ult Just"}
                        
PRIVATE _cPerg := 'PTNR050'


//Private aCabBox2   := {' ', '', '', ''}
//Private LenCabBox2 := 1


PutSx1(_cPerg,"01","Contrato De?"        ,"Contrato De?"         ,"Contrato De?"      ,"mv_ch1","C",TAMSX3("CN9_NUMERO")[1], 0,0,"G","","CN9","","","mv_par01")
PutSx1(_cPerg,"02","Contrato AtÈ?"       ,"Contrato Ate?"        ,"Contrato Ate?"     ,"mv_ch2","C",TAMSX3("CN9_NUMERO")[1], 0,0,"G","","CN9","","","mv_par02")
PutSx1(_cPerg,"03","Fornecedor de?"      ,"Fornecedor de"        ,"Fornecedor de?"    ,"mv_ch3","C",TAMSX3("CNA_FORNEC")[1], 0,0,"G","","SA2","","","mv_par03")
//PutSx1(_cPerg,"04","Loja de?"            ,"Loja de?"             ,"Loja de?"          ,"mv_ch4","C",TAMSX3("CNA_LJFORN")[1], 0,0,"G","","","",""   ,"mv_par04")
PutSx1(_cPerg,"04","Fornecedor AtÈ?"     ,"Fornecedor AtÈ"       ,"Fornecedor AtÈ?"   ,"mv_ch4","C",TAMSX3("CNA_FORNEC")[1], 0,0,"G","","SA2","","","mv_par04")
//PutSx1(_cPerg,"06","Loja AtÈ?"           ,"Loja AtÈ?"            ,"Loja AtÈ?"         ,"mv_ch6","C",TAMSX3("CNA_LJFORN")[1], 0,0,"G","","","",""   ,"mv_par06")
PutSx1(_cPerg,"05","Tipo Contrato?"      ,"Tipo Contrato?"       ,"Tipo Contrato?"    ,"mv_ch5","C",TAMSX3("CN9_TPCTO")[1], 0,0,"G","","CN1","","","mv_par05")
PutSx1(_cPerg,"06","STATUS ?	  "      ,"STATUS ?	     "       ,"STATUS ?	     "    ,"mv_ch6","N",01,0,0,"C","","","","","mv_par06","02 - ElaboraÁ„o","02 - ElaboraÁ„o","02 - ElaboraÁ„o","05 - Vigente","05 - Vigente","05 - Vigente","07 - Sol Finaliz","07 - Sol Finaliz","07 - Sol Finaliz","08 - Finalizado","08 - Finalizado","08 - Finalizado","99 - Todos","99 - Todos","99 - Todos","", "","",{},{},{})

/*data da assinatura, fornecedores*/

If !Pergunte(_cPerg, .T.)
	Return
EndIf


Processa({ |lEnd| UTIL00A(@lEnd)}, 'CONTRATOS - CONSOLIDADO', 'Processando dados...', .T.)

Return


Static Function UTIL00A(lEnd)

Local OBJCTO  := ""
Local ALTCLA  := ""
Local JUSTIF  := ""  
Local _SITUAC := "99"  

Private xJUSTIF   := ""
Private xALTCLA   := ""
Private xOBJCTO   := ""
Private xnLinhas  := ""
Private xMemo     := ""


aCabec := {"Filial", "Num Contrato","Revisao", "Contratada", "Cnpj","Tip. Contrato", "Objeto", "Valor Ini.", "Valor Atual", "Saldo", "Dta Ini", "Dta Final", "Vigencia",;
           "Unid. Vigencia", "Num Medicao","Valor Medicao","Dta. Medicao", "Desc. Pgto", "Status","C.C.", "Dta Assina","Dta Encerra","Clausula","Ult Just"}

//AAdd(aDados, {aVetMat2[nCont][1], substr(aVetMat2[nCont][2],1,24), aVetMat2[nCont][16], Transform(aVetMat2[nCont][04],"@R 999,999,999.99"), Transform(aVetMat2[nCont][05],"@R 999,999,999.99"), Transform(aVetMat2[nCont][06],"@R 999,999,999.99"), Transform(aVetMat2[nCont][07],"@R 999,999,999.99"), Transform(aVetMat2[nCont][08],"@R 999,999,999.99"), Transform(aVetMat2[nCont][09],"@R 999,999,999.99"), Transform(aVetMat2[nCont][10],"@R 999,999,999.99"), Transform(aVetMat2[nCont][11],"@R 999,999,999.99"), Transform(aVetMat2[nCont][12],"@R 999,999,999.99"), Transform(aVetMat2[nCont][13],"@R 999,999,999.99"), Transform(aVetMat2[nCont][14],"@R 999,999,999.99"), Transform(aVetMat2[nCont][15],"@R 999,999,999.99")})


//Begin Transaction

//Atualiza Contratos (Principal)
//dbSelectArea("CN9")


DO CASE 
	Case mv_par06 = 1
			_SITUAC := "02"
		Case mv_par06 = 2
			_SITUAC := "05"
		Case mv_par06 = 3
			_SITUAC := "08"
		Case mv_par06 = 4
			_SITUAC := "07"
		Case mv_par06 = 5
			_SITUAC := "99"
	EndCase

// Alterado por Rafael Sacramento (Criare Consulting) em 29/09/2015
/*
cQuery := "SELECT * " + cEnt
cQuery += "FROM "+RetSqlName("CN9")+" CN9  LEFT JOIN " +RetSqlName("CNA")+ " CNA " + cEnt
cQuery += "  ON CN9.CN9_FILIAL = CNA.CNA_FILIAL " + cEnt
cQuery += " AND CN9.CN9_NUMERO = CNA.CNA_CONTRA " + cEnt
cQuery += " AND CN9.CN9_REVISA = CNA.CNA_REVISA " + cEnt
cQuery += "LEFT JOIN "+RetSqlName("SA2")+" SA2 " + cEnt
cQuery += "  ON SA2.A2_COD = CNA.CNA_FORNEC " + cEnt
cQuery += " AND SA2.A2_LOJA = CNA.CNA_LJFORN" + cEnt
cQuery += "INNER JOIN "+RetSqlName("CN1")+" CN1 " + cEnt
cQuery += "  ON CN1.CN1_CODIGO = CN9.CN9_TPCTO " + cEnt
cQuery += " AND CN1.CN1_FILIAL = CN9.CN9_FILIAL" + cEnt
cQuery += "INNER JOIN "+RetSqlName("SE4")+" SE4 " + cEnt
cQuery += "  ON SE4.E4_CODIGO = CN9.CN9_CONDPG " + cEnt  
cQuery += "WHERE CN9.CN9_FILIAL = '"+xfilial("CN9")+"' " + cEnt
If ALLTRIM(_SITUAC) <> "99"
cQuery += " AND CN9.CN9_SITUAC = '"+_SITUAC+"'" + cEnt
EndIf    
If ALLTRIM(mv_par05) <> "999"
cQuery += "AND CN9.CN9_TPCTO  = '"+mv_par05+"'" + cEnt
EndIf
cQuery += "AND CN9.CN9_NUMERO >= '"+mv_par01+"'" + cEnt
cQuery += "AND CN9.CN9_NUMERO <= '"+mv_par02+"'" + cEnt
cQuery += "AND CNA.CNA_FORNEC >= '"+mv_par03+"'" + cEnt
cQuery += "AND CNA.CNA_FORNEC <= '"+mv_par04+"'" + cEnt
//cQuery += "AND CNA.CNA_LJFORN >= '"+mv_par04+"'" + cEnt
//cQuery += "AND CNA.CNA_LJFORN <= '"+mv_par06+"'" + cEnt     

cQuery += "AND CN9.D_E_L_E_T_ <> '*' " + cEnt
cQuery += "AND CNA.D_E_L_E_T_ <> '*' " + cEnt
cQuery += "AND SA2.D_E_L_E_T_ <> '*' " + cEnt
cQuery += "AND CN1.D_E_L_E_T_ <> '*' " + cEnt
*/

// InÌcio na query modificada

cQuery := "SELECT * FROM "+RetSqlName("CN9")+" CN9 " + cEnt
cQuery += "INNER JOIN CN1010 CN1 " + cEnt 
cQuery += "ON CN9.CN9_FILIAL = CN1.CN1_FILIAL " + cEnt 
cQuery += "AND CN9.CN9_TPCTO = CN1.CN1_CODIGO " + cEnt
cQuery += "AND CN1.D_E_L_E_T_ <> '*' " + cEnt

cQuery += "INNER JOIN "+RetSqlName("CNC")+" CNC " + cEnt 
cQuery += "ON CN9.CN9_FILIAL = CNC.CNC_FILIAL " + cEnt 
cQuery += "AND CN9.CN9_NUMERO = CNC.CNC_NUMERO " + cEnt
cQuery += "AND CN9.CN9_REVISA = CNC.CNC_REVISA " + cEnt
cQuery += "AND CNC.D_E_L_E_T_ <> '*' " + cEnt

cQuery += "INNER JOIN "+RetSqlName("SA2")+" SA2 " + cEnt 
cQuery += "ON CNC.CNC_CODIGO = SA2.A2_COD " + cEnt 
cQuery += "AND CNC.CNC_LOJA = SA2.A2_LOJA " + cEnt
cQuery += "AND SA2.D_E_L_E_T_ <> '*' " + cEnt

cQuery += "INNER JOIN "+RetSqlName("SE4")+" SE4 " + cEnt 
cQuery += "ON CN9.CN9_CONDPG = SE4.E4_CODIGO " + cEnt
cQuery += "AND SE4.D_E_L_E_T_ <> '*' " + cEnt

cQuery += "LEFT JOIN "+RetSqlName("CNA")+" CNA " + cEnt 
cQuery += "ON CN9.CN9_FILIAL = CNA.CNA_FILIAL " + cEnt
cQuery += "AND CN9.CN9_NUMERO = CNA.CNA_CONTRA " + cEnt
cQuery += "AND CN9.CN9_REVISA = CNA.CNA_REVISA " + cEnt 
cQuery += "AND CNA.D_E_L_E_T_ <> '*' " + cEnt

cQuery += "WHERE CN9.CN9_FILIAL = '"+xfilial("CN9")+"' " + cEnt

If ALLTRIM(_SITUAC) <> "99"
cQuery += " AND CN9.CN9_SITUAC = '"+_SITUAC+"'" + cEnt
EndIf    
If ALLTRIM(mv_par05) <> "999"
cQuery += "AND CN9.CN9_TPCTO  = '"+mv_par05+"'" + cEnt
EndIf
cQuery += "AND CN9.CN9_NUMERO >= '"+mv_par01+"'" + cEnt
cQuery += "AND CN9.CN9_NUMERO <= '"+mv_par02+"'" + cEnt
cQuery += "AND CNC.CNC_CODIGO >= '"+mv_par03+"'" + cEnt
cQuery += "AND CNC.CNC_CODIGO <= '"+mv_par04+"'" + cEnt
cQuery += "AND CN9.D_E_L_E_T_ <> '*' " + cEnt

If Select(TmpCN9) > 0
	dbSelectArea(TmpCN9)
	dbCloseArea()
EndIf

cQuery := CHANGEQUERY(cQuery)
dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery), TmpCN9 ,.T.,.T.)

Do While (TmpCN9)->(!Eof())
	
	Do Case
		Case (TmpCN9)->CN9_SITUAC == "01"
			cSituaca := "Anulado"
		Case (TmpCN9)->CN9_SITUAC == "02"
			cSituaca := "Elaboracion"
		Case (TmpCN9)->CN9_SITUAC == "03"
			cSituaca := "Emitido"
		Case (TmpCN9)->CN9_SITUAC == "04"
			cSituaca := "Aprobacion"
		Case (TmpCN9)->CN9_SITUAC == "05"
			cSituaca := "Vigente"
		Case (TmpCN9)->CN9_SITUAC == "06"
			cSituaca := "Paraliza"
		Case (TmpCN9)->CN9_SITUAC == "07"
			cSituaca := "Sol. Finalizac"
		Case (TmpCN9)->CN9_SITUAC == "08"
			cSituaca := "Finalizado"
		Case (TmpCN9)->CN9_SITUAC == "09"
			cSituaca := "Revision"
		Case (TmpCN9)->CN9_SITUAC == "10"
			cSituaca := "Revisado"
	EndCase                                 
	   
	
	Do Case
		Case (TmpCN9)->CN9_UNVIGE == "1"
			cUniVig := "Dias"
		Case (TmpCN9)->CN9_UNVIGE == "2"
			cUniVig := "Meses"
		Case (TmpCN9)->CN9_UNVIGE == "3"
			cUniVig := "Anos"
		Case (TmpCN9)->CN9_UNVIGE == "4"
			cUniVig := "Indeterminado"
	EndCase                                 
	
	
	
	cQuery1 := "SELECT CNB_FILIAL, CNB_NUMERO, CNB_REVISA, CNB_ITEM, CNB_XCC " + cEnt
	cQuery1 += "FROM "+RetSqlName("CN9")+" CN9  INNER JOIN " +RetSqlName("CNA")+ " CNA " + cEnt
	cQuery1 += "  ON CN9.CN9_FILIAL = CNA.CNA_FILIAL " + cEnt
	cQuery1 += " AND CN9.CN9_NUMERO = CNA.CNA_CONTRA " + cEnt
	cQuery1 += " AND CN9.CN9_REVISA = CNA.CNA_REVISA " + cEnt
	cQuery1 += "INNER JOIN "+RetSqlName("CNB")+" CNB " + cEnt
	cQuery1 += "  ON CNB.CNB_NUMERO = CNA.CNA_NUMERO " + cEnt
	cQuery1 += " AND CNB.CNB_FILIAL = CNA.CNA_FILIAL" + cEnt
	cQuery1 += " AND CNB.CNB_REVISA = CNA.CNA_REVISA" + cEnt
	cQuery1 += "WHERE CN9.CN9_FILIAL = '"+(TmpCN9)->CN9_FILIAL+"' " + cEnt
	cQuery1 += "AND CN9.D_E_L_E_T_ <> '*' " + cEnt
	cQuery1 += "AND CNA.D_E_L_E_T_ <> '*' " + cEnt
	cQuery1 += "AND CNB.D_E_L_E_T_ <> '*' " + cEnt
	cQuery1 += "AND CNA.CNA_CONTRA = '"+(TmpCN9)->CN9_NUMERO+"' " + cEnt
	cQuery1 += "AND CNA.CNA_NUMERO = '"+(TmpCN9)->CNA_NUMERO+"' " + cEnt
	cQuery1 += "AND CNA.CNA_REVISA = '"+(TmpCN9)->CNA_REVISA+"' " + cEnt
	cQuery1 += "AND CN9.CN9_NUMERO = '"+(TmpCN9)->CN9_NUMERO+"' " + cEnt
	cQuery1 += "AND CN9.CN9_REVISA = '"+(TmpCN9)->CN9_REVISA+"' " + cEnt
	cQuery1 += "ORDER BY CNB_FILIAL, CNB_NUMERO, CNB_REVISA, CNB_ITEM " + cEnt
	
	
	If Select(TmpCNA) > 0
		dbSelectArea(TmpCNA)
		dbCloseArea()
	EndIf
	
	cQuery1 := CHANGEQUERY(cQuery1)
	dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery1), TmpCNA ,.T.,.T.)
	
	Do While (TmpCNA)->(!Eof())
		
		cCC := (TmpCNA)->CNB_XCC
		
		(TmpCNA)->(dbSkip())
		
	EndDo
	                       
	
	
	cQuery2 := "SELECT CND_FILIAL, CND_DTFIM, CND_CONTRA, CND_REVISA, CND_NUMERO, CND_NUMMED, CND_VLTOT  " + cEnt
	cQuery2 += "FROM "+RetSqlName("CN9")+" CN9  INNER JOIN " +RetSqlName("CNA")+ " CNA " + cEnt
	cQuery2 += "  ON CN9.CN9_FILIAL = CNA.CNA_FILIAL " + cEnt
	cQuery2 += " AND CN9.CN9_NUMERO = CNA.CNA_CONTRA " + cEnt
	cQuery2 += " AND CN9.CN9_REVISA = CNA.CNA_REVISA " + cEnt
	cQuery2 += "INNER JOIN "+RetSqlName("CND")+" CND " + cEnt
	cQuery2 += " ON  CND.CND_FILIAL = CN9.CN9_FILIAL" + cEnt
	cQuery2 += " AND CND.CND_REVISA = CN9.CN9_REVISA" + cEnt 
	cQuery2 += " AND CND.CND_CONTRA = CN9.CN9_NUMERO" + cEnt 
	cQuery2 += " AND CND.CND_NUMERO = CNA.CNA_NUMERO" + cEnt 
	cQuery2 += "WHERE CN9.CN9_FILIAL = '"+(TmpCN9)->CN9_FILIAL+"' " + cEnt
	cQuery2 += "AND CN9.D_E_L_E_T_ <> '*' " + cEnt
	cQuery2 += "AND CNA.D_E_L_E_T_ <> '*' " + cEnt
	cQuery2 += "AND CND.D_E_L_E_T_ <> '*' " + cEnt
	cQuery2 += "AND CNA.CNA_CONTRA = '"+(TmpCN9)->CN9_NUMERO+"' " + cEnt
	cQuery2 += "AND CNA.CNA_NUMERO = '"+(TmpCN9)->CNA_NUMERO+"' " + cEnt
	cQuery2 += "AND CNA.CNA_REVISA = '"+(TmpCN9)->CNA_REVISA+"' " + cEnt
	cQuery2 += "AND CN9.CN9_NUMERO = '"+(TmpCN9)->CN9_NUMERO+"' " + cEnt
	cQuery2 += "AND CN9.CN9_REVISA = '"+(TmpCN9)->CN9_REVISA+"' " + cEnt
	cQuery2 += "ORDER BY CND_FILIAL, CND_CONTRA, CND_REVISA, CND_NUMERO, CND_NUMMED DESC " + cEnt
	      
	
	If Select(TmpCND) > 0
		dbSelectArea(TmpCND)
		dbCloseArea()
	EndIf
	
	cQuery2 := CHANGEQUERY(cQuery2)
	dbUseArea(.T.,'TOPCONN',TCGENQRY(,,cQuery2), TmpCND,.T.,.T.)
	
	//Do While (TmpCND)->(!Eof())
	IF 	(TmpCND)->(!Eof())
	
		dDtaMed   := (TmpCND)->CND_DTFIM  
		nMedicao  := (TmpCND)->CND_NUMMED 
		nValorMed := (TmpCND)->CND_VLTOT
		
		//(TmpCND)->(dbSkip())
	
	ENDIF	
	//EndDo
	
	
	
	
 	OBJCTO := MSMM((TmpCN9)->CN9_CODOBJ)
	//OBJCTO := STRTRAN( OBJCTO, CHR(13),"")
 	//OBJCTO := CleanSpecChar(AllTrim(OBJCTO)) //If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(OBJCTO)),AllTrim(OBJCTO))+" "
	
	ALTCLA := MSMM((TmpCN9)->CN9_CODCLA)
	//ALTCLA := ""//STRTRAN( ALTCLA, CHR(13)," ")
	//ALTCLA := ""//If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(ALTCLA)),AllTrim(ALTCLA))+" "
	
	JUSTIF := MSMM((TmpCN9)->CN9_CODJUS)
	//JUSTIF := ""//STRTRAN( JUSTIF, CHR(13)," ")
	//JUSTIF := ""//If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(JUSTIF)),AllTrim(JUSTIF))+" "   
	
//	_DESCRI:= If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim((TmpCN9)->E4_DESCRI)),AllTrim((TmpCN9)->E4_DESCRI))+" "   
	
		

   //	OBJCTO := (TmpCN9)->CN9_CODOBJ
//	xnLinhas := MlCount(OBJCTO,105)
 //	For xni := 1 To xnLinhas
		
  //		xMemo := MemoLine(OBJCTO,105,xni)
//		xMemo := STRTRAN(xMemo,Chr(13),"")
			
  //		OBJCTO += If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(xMemo)),AllTrim(xMemo))+" "
			
//	Next xni 
	
	/*
	ALTCLA := (TmpCN9)->CN9_CODCLA
	xnLinhas := MlCount(ALTCLA,105)
	For xni := 1 To xnLinhas
		
		xMemo := MemoLine(ALTCLA,105,xni)
		xMemo := STRTRAN(xMemo,Chr(13),"")
			
	    ALTCLA += If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(xMemo)),AllTrim(xMemo))+" "
			
	Next xni 
	
	
	JUSTIF := (TmpCN9)->CN9_CODJUS
	xnLinhas := MlCount(JUSTIF,105)
	For xni := 1 To xnLinhas                                                                    
		
		xMemo := MemoLine(JUSTIF,105,xni)
		xMemo := STRTRAN(xMemo,Chr(13),"")
			
		JUSTIF += If(FindFunction('CleanSpecChar'),CleanSpecChar(AllTrim(xMemo)),AllTrim(xMemo))+" "
			
	Next xni 
	  */
	
	
	AAdd(aDadosCN9, {(TmpCN9)->CN9_FILIAL,;
		             (TmpCN9)->CN9_NUMERO,; //+ " - " + (TmpCN9)->CN9_REVISA,;
					 (TmpCN9)->CN9_REVISA,;
	                 (TmpCN9)->A2_COD + "/" + (TmpCN9)->A2_LOJA + " - " + (TmpCN9)->A2_NOME ,; //+ " - " + (TmpCN9)->A2_CGC,;
					 Transform((TmpCN9)->A2_CGC, "@R 99.999.999/9999-99"),;
					 (TmpCN9)->CN9_TPCTO + " - " + (TmpCN9)->CN1_DESCRI,;
	                 ALLTRIM(OBJCTO),;
	                 Transform((TmpCN9)->CN9_VLINI,"@R 999,999,999.99"),;
	                 Transform((TmpCN9)->CN9_VLATU,"@R 999,999,999.99"),;
	                 Transform((TmpCN9)->CN9_SALDO,"@R 999,999,999.99"),;
	                 substr((TmpCN9)->CN9_DTINIC,7,2) + "/" + substr((TmpCN9)->CN9_DTINIC,5,2) + "/" + substr((TmpCN9)->CN9_DTINIC,1,4),;
	                 substr((TmpCN9)->CN9_DTFIM,7,2) + "/" + substr((TmpCN9)->CN9_DTFIM,5,2) + "/" + substr((TmpCN9)->CN9_DTFIM,1,4),;
	                 (TmpCN9)->CN9_VIGE,;
	                 cUniVig,;//(TmpCN9)->CN9_UNVIGE,;
	                 nMedicao,;  
	                 Transform(nValorMed,"@R 999,999,999.99"),;    
	                 substr(dDtaMed,7,2) + "/" + substr(dDtaMed,5,2) + "/" + substr(dDtaMed,1,4),;
	                 AllTrim((TmpCN9)->E4_DESCRI),;
	                 cSituaca,;
	                 cCC,;
	                 substr((TmpCN9)->CN9_DTASSI,7,2) + "/" + substr((TmpCN9)->CN9_DTASSI,5,2) + "/" + substr((TmpCN9)->CN9_DTASSI,1,4),;
	                 substr((TmpCN9)->CN9_DTENCE,7,2) + "/" + substr((TmpCN9)->CN9_DTENCE,5,2) + "/" + substr((TmpCN9)->CN9_DTENCE,1,4),;
	                 ALLTRIM(ALTCLA),;
	                 ALLTRIM(JUSTIF)})
	
	(TmpCN9)->(dbSkip())
	
	cSituaca := ""
	cCC      := ""
	OBJCTO   := ""
	ALTCLA   := ""
	JUSTIF   := ""
	
EndDo


//End Transaction


//If MsgYesNo("Exporta RelatÛrio para o Excel?")
 	If !ApOleClient("MSExcel")
	  
		MsgAlert("Microsoft Excel n„o instalado!")
	  	Return
	
	Else
	  
	  DlgToExcel({ {"ARRAY", titulo, aCabec, aDadosCN9} })
	  
	EndIf
 	
//endif

Return()


//--------------------------------------------------------------------------------------------------
//Gera Excel com as informaÁıes coletadas-----------------------------------------------------------
//--------------------------------------------------------------------------------------------------

//If LEN(aDadosCN9) > 0
//	Processa({ |lEnd| UTIL2B(@lEnd)}, 'CONTRATOS - CONSOLIDADO', 'Gerando planilha...', .T.)
//ELSE
 //	Aviso("Aviso!","N„o h· dados a serem exibidos com os par‚metros informados!",{"OK"})
//EndIf

//Return()

  



*************************************************************************************************************
*************************************************************************************************************

Static Function ValidPerg()
/*
Local aHelpPor := {}
Local aHelpEsp := {}
Local aHelpEng := {}

PutSx1(_cPerg,"01","Contrato De?"        ,"Contrato De?"         ,"Contrato De?"      ,"mv_ch1","C",TAMSX3("CN9_NUMERO")[1],0,0,"G","","CN9","","","mv_par01")
PutSx1(_cPerg,"02","Contrato AtÈ?"       ,"Contrato Ate?"        ,"Contrato Ate?"     ,"mv_ch2","C",TAMSX3("CN9_NUMERO")[1],0,0,"G","","CN9","","","mv_par02")
PutSx1(_cPerg,"03","Revis„o De?"         ,"Revis„o De?"          ,"Revis„o De?"       ,"mv_ch3","C",TAMSX3("CN9_REVISA")[1],0,0,"G","","CN9","","","mv_par03")
PutSx1(_cPerg,"04","Revis„o AtÈ?"        ,"Revis„o AtÈ?"         ,"Revis„o AtÈ?"      ,"mv_ch4","C",TAMSX3("CN9_REVISA")[1],0,0,"G","","CN9","","","mv_par04")
//PutSx1(_cPerg,"05","STATUS?"             ,"STATUS?"              ,"STATUS"            ,"mv_ch5","C",TAMSX3("CN9_SITUAC")[1],0,0,"G","","CN9","","","mv_par05")
PutSx1(_cPerg,"05",OemToAnsi("STATUS ?	")  ,"",""                                ,"mv_ch5","N",01,0,0,"C","","","","","mv_par05","02 - ElaboraÁ„o","02 - ElaboraÁ„o","02 - ElaboraÁ„o","","05 - Vigente","05 - Vigente","05 - Vigente", "08 - Finalizado","08 - Finalizado","08 - Finalizado","","","","", "","",{},{},{})



//PutSx1(_cPerg,"05","MesAno Ini (MMAAAA)?","MesAno Ini (MMAAAA)?","MesAno Ini (MMAAAA)?","mv_ch5","C",06,0,0,"G","","","","","mv_par05")
//PutSx1(_cPerg,"06","MesAno Fim (MMAAAA)?","MesAno Fim (MMAAAA)?","MesAno Fim (MMAAAA)?","mv_ch6","C",06,0,0,"G","","","","","mv_par06")


  */
Return




*******************************************************************************************************************************************

Static Function UTIL2B()

Local oFwMsEx := NIL
Local cArq := ""
//Local cDir := GetSrvProfString("Startpath","")
Local cWorkSheet := ""
Local cTable := ""
Local cDirTmp := GetTempPath()
Local ni := 1
//Local nj := 1
//Local nL := 1
Local aDados := {}
//Local aTemp  := {}
Local TotLinaDados := 0
Local nLenaDados  := 0
//Local lAchou := .F.
//Local lExit := .F.

oFwMsEx := FWMsExcel():New()

cWorkSheet := "Contratos"
oFwMsEx:AddWorkSheet( cWorkSheet )

cTable := "Relatorio Consolidado dos Contratos"
oFwMsEx:AddTable( cWorkSheet, cTable )

For ni := 1 To Len(aCabBox1)
	
	oFwMsEx:AddColumn( cWorkSheet, cTable , aCabBox1[ni] , 1,1)
	
Next ni

//For ni := 1 To LenCabBox2

//	For nj := 1 To Len(aCabBox2)

//	oFwMsEx:AddColumn( cWorkSheet, cTable , aCabBox2[nj] , 1,1)

//Next nj

//Next ni


TotLinaDados := Len(aCabBox1)   ///+(LenCabBox2*4)

ProcRegua(Len(aDadosCN9))


For ni := 1 To Len(aDadosCN9)
	
	incproc()
	
	aDados     := ARRAY(TotLinaDados)
	aDados[1]  := aDadosCN9[ni][1]
	aDados[2]  := aDadosCN9[ni][2]
	aDados[3]  := aDadosCN9[ni][3]
	aDados[4]  := aDadosCN9[ni][4]
	aDados[5]  := aDadosCN9[ni][5]
	aDados[6]  := aDadosCN9[ni][6]
	aDados[7]  := aDadosCN9[ni][7]
	aDados[8]  := aDadosCN9[ni][8]
	aDados[9]  := aDadosCN9[ni][9]
	aDados[10] := aDadosCN9[ni][10]
	aDados[11] := aDadosCN9[ni][11]
	aDados[12] := aDadosCN9[ni][12]
	aDados[13] := aDadosCN9[ni][13]
	aDados[14] := aDadosCN9[ni][14]
	aDados[15] := aDadosCN9[ni][15]
	aDados[16] := aDadosCN9[ni][16]
	aDados[17] := aDadosCN9[ni][17]
	aDados[18] := aDadosCN9[ni][18]
	
	nLenaDados  := Len(aCabBox1)
	//lExit       := .F.
	
	//	For nj := 1 To LenCabBox2
	
	//		IF LEN(aDadSD1) == 0
	
	//		aDados[++nLenaDados] := ""
	//		aDados[++nLenaDados] := ""
	//	aDados[++nLenaDados] := ""
	//	aDados[++nLenaDados] := ""
	
	//	ELSE
	
	
	//	ENDIF
	
	
	//Next nj
	
	oFwMsEx:AddRow( cWorkSheet, cTable, aDados )
	
	aDados := {}
	
Next ni

//oFwMsEx:AddRow( cWorkSheet, cTable, { "1","","","","","","","","","","" } )

oFwMsEx:Activate()

cArq := CriaTrab( NIL, .F. ) + ".xml"
LjMsgRun( "Gerando o arquivo, aguarde...", "Gerar XML", {|| oFwMsEx:GetXMLFile( cArq ) } )
If __CopyFile( cArq, cDirTmp + cArq )
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cDirTmp + cArq )
	oExcelApp:SetVisible(.T.)
Else
	MsgInfo( "Arquivo n„o copiado para tempor·rio do usu·rio." )
Endif

Return


