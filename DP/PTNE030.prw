#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"               
#INCLUDE "TopConn.ch"
#include 'fwprintsetup.ch'  
#INCLUDE "RPTDEF.CH"        
#Include "ParmType.ch"
#Include "Ap5Mail.CH"
#Include "ACADEF.ch"  
#Include "acaxfuna.ch" 

#DEFINE CRLF chr(13)+chr(10)

User Function PTNE030()

Local n_w, i := 1 

Private cTpF := ""
Private dDt := ""
Private cMatI := ""
Private cMatF := ""
Private cCCI := ""
Private cCCF := ""
Private cPGT := ""
Private aHtm := {}
Private cpath := ""                
Private aERR := {}
Private cXLog := ""
Private cELog := ""
Private cLastProc := ""
Private nImp := ""
Private nAb := ""
Private cSituac 	:= ""
Private cSubj 	:= ""
Private cSitSQL	:= ""	
private lDebug := .f.  // inserido Felipe do Nascimento 31/05/2016


cPerg := "PTNE030"
aMemo := {}

u_PutSX1(cPerg , "01" , "Matricula De        ?" , "" , "" , "mv_ch1"  , "C" , TAMSX3("RA_MAT")[1] , 0 , 0 , "G" , "", "SRA", "", "", "mv_par01" , "         " ,"","","","" , "   " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" )
u_PutSX1(cPerg , "02" , "Matricula Ate       ?" , "" , "" , "mv_ch2"  , "C" , TAMSX3("RA_MAT")[1] , 0 , 0 , "G" , "", "SRA", "", "", "mv_par02" , "         " ,"","","","" , "   " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" )
u_PutSX1(cPerg , "03" , "Centro custo De     ?" , "" , "" , "mv_ch3"  , "C" , TAMSX3("CTT_CUSTO")[1] , 0 , 0 , "G" , "", "CTT", "", "", "mv_par03" , "         " ,"","","","" , "   " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" )
u_PutSX1(cPerg , "04" , "Centro custo Ate    ?" , "" , "" , "mv_ch4"  , "C" , TAMSX3("CTT_CUSTO")[1] , 0 , 0 , "G" , "", "CTT", "", "", "mv_par04" , "         " ,"","","","" , "   " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" )
u_PutSX1(cPerg , "05" , "Tipo Pagto          ?" , "" , "" , "mv_ch5"  , "C" , TAMSX3("RA_TIPOPGT")[1] , 0 , 0 , "G" , "", "40", "", "", "mv_par05" , "         " ,"","","","" , "   " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" )
u_PutSX1(cPerg , "06" , "Competencia         ?" , "" , "" , "mv_ch6"  , "C" , 6 , 0 , 0 , "G" , "", "", "", "", "mv_par06" , "         " ,"","","","" , "   " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" )
u_PutSx1(cPerg , "07" , "Imprimir recibos    ?" ,"",""    ,"mv_ch7" ,"N",01,0,0,"C","","","","","mv_par07" ,"Folha+13 1 Parc"	,"","",""	,"13 2 Parc"				,"","","PLR","","","PREMIO ","",""," ","","")
u_PutSx1(cPerg , "08" , "Aberto/Fechado      ?" ,"",""    ,"mv_ch8" ,"N",01,0,0,"C","","","","","mv_par08" ,"Aberto"	,"","",""	,"Fechado"				,"",""," ","",""," ","",""," ","","")
u_PutSx1(cPerg , "09" , "Semana              ?" ,"",""    ,"mv_ch9" ,"C",02,0,0,"G","","","","","mv_par09" ,""	,"","",""	,""				,"",""," ","",""," ","",""," ","","")
u_PutSx1(cPerg , "10" , "Mensagem            ?" ,"",""    ,"mv_cha" ,"C",99,0,0,"G","","","","","mv_par10" ,""	,"","",""	,""				,"",""," ","",""," ","",""," ","","")
u_PutSx1(cPerg , "11" , "Mensagem            ?" ,"",""    ,"mv_chb" ,"C",99,0,0,"G","","","","","mv_par11" ,""	,"","",""	,""				,"",""," ","",""," ","",""," ","","")
u_PutSx1(cPerg , "12" , "Mensagem            ?" ,"",""    ,"mv_chc" ,"C",99,0,0,"G","","","","","mv_par12" ,""	,"","",""	,""				,"",""," ","",""," ","",""," ","","")
u_PutSx1(cPerg , "13" , "Situações           ?" ,"",""    ,"mv_chd" ,"C",05,0,0,"G","fSituacao","","","","mv_par13" ,""	,"","",""	,""				,"",""," ","",""," ","",""," ","","")
u_PutSx1(cPerg , "14" , "Assunto E-mail      ?" ,"",""    ,"mv_che" ,"C",60,0,0,"C","","","","","mv_par14" ,""	,"","",""	,""				,"",""," ","",""," ","",""," ","","")

If pergunte(cPerg,.T.)  
	cMatI := MV_PAR01
	cMatF := MV_PAR02
	cCCI := MV_PAR03
	cCCF := MV_PAR04
	cPGT := MV_PAR05	
	dDt := MV_PAR06+"01"
	cPath := "C:\Temp\"//AllTrim(MV_PAR07)  
	nImp := MV_PAR07
	nAb := MV_PAR08	
	cSemana := MV_PAR09	
	cMens := AllTrim(MV_PAR10)+AllTrim(MV_PAR11)+AllTrim(MV_PAR12)
	cSituac := MV_PAR13
	cSubj := AllTrim(MV_PAR14)
	
	
	For i := 1 to 5
		cSit := Substr(cSituac,i,1)
		IF cSit <> '*'
			cSitSQL += ",'" + cSit + "'"
		Endif
	Next
	cSitSQL := Substr(cSitSQL,2)
	
	If cSituac = "*****"
		cSitSql := "'*'"
	Endif
	
		
	If nImp == 1
		cTpF := "Folha"	 // Opção Folha (semana01) + 13. 1 Parcela(semana02) Quando Houver. 		
	ElseIf nImp == 2
		cTpF := "132"	 // opção 13 2 Parcela impressão em separado da folha.	
	ElseIf nImp == 3     
		cTpF := "PLR"    // opção PLR impressão em separado da folha. 
	ElseIf nImp == 4  
		cTpF := "VEX"    // opção VEX-Valores Extras ( PREMIO ) (semana01) impressão em separado da folha - 09/12/2020 
	Endif
	If !Empty(cSemana)
//		cTpF := "Adto."	
		cTpF := " "
	Endif                   

	Processa({||HoleMail() }," Gerando contracheques . . .")	

	aFiles := {}
	aSizes := {}

 	ADir(cpath+"holerite_*.pdf", aFiles, aSizes)	
	
	for n_w := 1 to len(aFiles)
		FErase(cpath+aFiles[n_w])	
	Next n_w
	                                                                
	CtIM := tIME()
	Memowrite(cPath+"Log_Holemail_"+SuBSTR(dDt,5,2)+SuBSTR(dDt,1,4)+"_"+Replace(DToC(Date()),"/","")+"_"+Replace(cTim,":","")+".txt",(cXLog+CRLF+cELog+CRLF+"Hora Fim "+cTim+CRLF	))
	
	Alert("O arquivo de log encontra-se no caminho c:\TEMP, esse deve ser copiado e guardado como comprovante de envio dos contracheques.")	
   
Endif	
Return

/* 
Metodo: HoleMail Desenvolvido por: Vinicius Figueiredo Moreira - Doit - 20130617

Espelho do contra cheque em formato HTML via email.

*/
Static Function HoleMail()

//Local cUser       := ""
Local aDifs       := {}     
Private aUser     :={} 
Private cQuery    :=""

Private _cServer  := AllTrim(GetMV("MV_RELSERV")) // 
Private _cUser    := AllTrim(GetMV("MV_RELACNT")) //
Private _cPass    := AllTrim(GetMV("MV_RELPSW")) // 

Private _cSMTPServer := GetMV("MV_WFSMTP")
Private _cAccount    := GetMV("MV_WFMAIL")
Private _cPassword   := GetMV("MV_WFPASSW")
//Private _cSMTPServer  := "compras.portonovosa.com.br" //"portonovosa.com.inbound10.mxlogicmx.net" 
//Private _cAccount    := "wf@compras.portonovosa.com.br"
//Private _cPassword    :=  "7orCP2te"


Private _lAut       := GETMV("MV_RELAUTH") // 
//Private _cFrom      := AllTrim(GETMV("MV_RELFROM")) //
//Private _cFrom      := "contracheque@portonovosa.com" //Email específico para envio de contracheques  
Private _cFrom      := _cUser // alteração  fabio 01/02/2021 - office 365.  

Private _cTo        := "" //
Private _cCC        := ""                             		// 
Private _cBCC       := ""                            	   // 
Private _cSubject   := "Contracheque Referente " //

Private cEmp
private cCNPJ 
Private cyear
Private cMes
DbSelectArea("SM0")      
DbSetOrder(1)
DbSeek(cEmpAnt+cFilAnt)

cEmp := SM0->M0_NOMECOM
cCNPJ := SM0->M0_CGC
/*
PswOrder(2) 
//PswSeek(Substr(cUsuario,7,15),.t.)
PswSeek(cUsername,.t.)
aUser := PswRet(1)
_cBCC := Alltrim(aUser[1,14]) //email do usuario
cUser := Alltrim(aUser[1,4] )//Usuario
_cTo := ""
If !Empty(_cBCC)
 _cTo += ";"+_cBCC                                               
Endif
*/

cYear := Year(SToD(dDt))
cMes := Month(SToD(dDt))

cYear := AllTrim(STR(cyear))
cMes := AllTrim(STRZERO(cmes,2))	   

cX := ""	

If 	cMes == "01"
	cX += "Janeiro"
ElseIf cMes == "02"
	cX += "Fevereiro"
ElseIf cMes == "03"
	cX += "Marco"
ElseIf cMes == "04"
	cX += "Abril"
ElseIf cMes == "05"
	cX += "Maio"
ElseIf cMes == "06"
	cX += "Junho"
ElseIf cMes == "07"
	cX += "Julho"
ElseIf cMes == "08"
	cX += "Agosto"
ElseIf cMes == "09"
	cX += "Setembro"
ElseIf cMes == "10"
	cX += "Outubro"
ElseIf cMes == "11"
	cX += "Novembro"
ElseIf cMes == "12"
	cX += "Dezembro"
Endif

//If !Empty(cSemana)
If cSemana <> "01"  .AND. !Empty(cSemana)
	_cSubject   := "Contracheque PLR - " 
Endif
_csubject += cX +" de "+cYear	

If !Empty(cSubj)
	_csubject := cSubj
Endif

	
If nImp == 1
	//RV_TIPOCOD 1=Provento;2=Desconto;3=Base                                                                                                    

	If nAb == 2 
		If cYear+cMes < '201709'
			//FECHADO
			If !TestaTab("RC"+cEmpant+SubSTR(dDt,3,4))
				Alert("Não foram encontrados dados.")			
				Return	
			Endif
			CQUERY := " SELECT RC_MAT MAT, RA_NOME NOME, RA_CC CC,  RA_CODFUNC CODFUN, RA_BCDEPSA BANCO, RA_CTDEPSA CONTA, RA_SALARIO SALARIO, RA_EMAIL EMAIL,"
			CQUERY += " RC_PD VERBA, RC_HORAS QTD, RC_VALOR VALOR, RV_DESC DESCRI , RV_TIPOCOD TPVER , SRA.R_E_C_N_O_ REC  " + CRLF //RA_DESCCC DCC,RA_DESCFUN DFUN , 	
			CQUERY += " FROM RC"+cEmpant+SubSTR(dDt,3,4)+" SRC ,"+ RetSQLName("SRV")+ " SRV ,"+ RetSQLName("SRA")+ " SRA   " + CRLF 
			CQUERY += " WHERE   RC_FILIAL =  '" + xFilial("SRC") + "' " + CRLF  // Alterado Felipe do Nascimento - 31/05/2016
			cQuery += "  AND   RV_FILIAL =  '" + xFilial("SRV") + "' " + CRLF 
			cQuery += "  AND   RA_FILIAL =  '" + xFilial("SRA") + "' " + CRLF 
			cQuery += "  AND   RC_MAT BETWEEN '"+cMatI+"' AND '"+cMatF+"'  " + CRLF   
	//		cQuery += "  AND   RC_DATA BETWEEN '"+cYear+cMes+"01' AND '"+cYear+cMes+"32'  " + CRLF - Retirado Felipe do Nascimento - 31/05/2016
	
			cQuery += "  AND   RC_SEMANA = '"+cSemana+"' " + CRLF
	
			cQuery += "  AND   RC_MAT = RA_MAT  " + CRLF
			cQuery += "  AND   RC_PD = RV_COD  " + CRLF 
			cQuery += "  AND   RA_CC BETWEEN '"+cCCI+"' AND '"+cCCF+"'  " + CRLF   
			cQuery += "  AND   RA_TIPOPGT = '"+cPGT+"' "+CRLF
			cQuery += "  AND   RA_SITFOLH IN (" + cSitSQL + ")  "+CRLF
			
			CQUERY += "  AND   SRC.D_E_L_E_T_ =  ' '  " + CRLF
			CQUERY += "  AND   SRV.D_E_L_E_T_ =  ' '  " + CRLF
			CQUERY += "  AND   SRA.D_E_L_E_T_ =  ' '  " + CRLF  
			CQUERY += "  AND   SRC.RC_ROTEIR  <> '132' " + CRLF
			CQUERY += "  ORDER BY RC_MAT , RC_PD ,RA_CC " + CRLF  
	
	/*	
			CQUERY := " SELECT RD_MAT MAT, RA_NOME NOME, RA_CC CC,  RA_CODFUNC CODFUN, RA_BCDEPSA BANCO, RA_CTDEPSA CONTA, RA_SALARIO SALARIO, RA_EMAIL EMAIL,"
			CQUERY += " RD_PD VERBA, RD_HORAS QTD, RD_VALOR VALOR, RV_DESC DESCRI , RV_TIPOCOD TPVER , SRA.R_E_C_N_O_ REC  " + CRLF //RA_DESCCC DCC,RA_DESCFUN DFUN , 
		
			CQUERY += " FROM "+ RetSQLName("SRD")+ " SRD ,"+ RetSQLName("SRV")+ " SRV ,"+ RetSQLName("SRA")+ " SRA   " + CRLF
			CQUERY += " WHERE   RD_FILIAL =  '" + xFilial("SRD") + "' " + CRLF 
			cQuery += "  AND   RV_FILIAL =  '" + xFilial("SRV") + "' " + CRLF 
			cQuery += "  AND   RA_FILIAL =  '" + xFilial("SRA") + "' " + CRLF 
			cQuery += "  AND   RD_MAT BETWEEN '"+cMatI+"' AND '"+cMatF+"'  " + CRLF   
			cQuery += "  AND   RD_DATARQ = '"+cYear+cMes+"'  " + CRLF
			cQuery += "  AND   RD_MAT = RA_MAT  " + CRLF
			cQuery += "  AND   RD_PD = RV_COD  " + CRLF 
			cQuery += "  AND   RA_CC BETWEEN '"+cCCI+"' AND '"+cCCF+"'  " + CRLF   
			cQuery += "  AND   RA_TIPOPGT = '"+cPGT+"' "+CRLF
			CQUERY += "  AND   SRD.D_E_L_E_T_ =  ' '  " + CRLF
			CQUERY += "  AND   SRV.D_E_L_E_T_ =  ' '  " + CRLF
			CQUERY += "  AND   SRA.D_E_L_E_T_ =  ' '  " + CRLF
			CQUERY += "  ORDER BY RD_MAT , RD_PD ,RA_CC " + CRLF  	
	*/
		Else
			//If nImp == 1 .AND. nAb == 2 .AND. DIF->(Eof())     
			//RV_TIPOCOD 1=Provento;2=Desconto;3=Base                                                                                                    
			CQUERY := " SELECT RD_MAT MAT, RA_NOME NOME, RA_CC CC,  RA_CODFUNC CODFUN, RA_BCDEPSA BANCO, RA_CTDEPSA CONTA, RA_SALARIO SALARIO, RA_EMAIL EMAIL,"
			CQUERY += " RD_PD VERBA, RD_HORAS QTD, RD_VALOR VALOR, RV_DESC DESCRI , RV_TIPOCOD TPVER , SRA.R_E_C_N_O_ REC  " + CRLF //RA_DESCCC DCC,RA_DESCFUN DFUN , 	
			CQUERY += " FROM "+ RetSQLName("SRD")+ " SRD ,"+ RetSQLName("SRV")+ " SRV ,"+ RetSQLName("SRA")+ " SRA   " + CRLF
			CQUERY += " WHERE   RD_FILIAL =  '" + xFilial("SRD") + "' " + CRLF 
			cQuery += "  AND   RV_FILIAL =  '" + xFilial("SRV") + "' " + CRLF 
			cQuery += "  AND   RA_FILIAL =  '" + xFilial("SRA") + "' " + CRLF 
			cQuery += "  AND   RD_MAT BETWEEN '"+cMatI+"' AND '"+cMatF+"'  " + CRLF   
			cQuery += "  AND   RD_PERIODO = '"+cYear+cMes+"'  " + CRLF
			cQuery += "  AND (  RD_SEMANA = '"+cSemana+"' " + CRLF
			If SubSTR(cFilAnt,1,2) == '02'
			cQuery += "  OR   RD_SEMANA = '02' " + CRLF
			Endif
			cQuery += "  ) " + CRLF
			
			cQuery += "  AND   RD_MAT = RA_MAT  " + CRLF
			cQuery += "  AND   RD_PD = RV_COD  " + CRLF 
			cQuery += "  AND   RA_CC BETWEEN '"+cCCI+"' AND '"+cCCF+"'  " + CRLF   
			cQuery += "  AND   RA_TIPOPGT = '"+cPGT+"' "+CRLF
			CQUERY += "  AND   SRD.D_E_L_E_T_ =  ' '  " + CRLF
	
			If nImp == 2
				CQUERY += "  AND   SRD.RD_ROTEIR  = '132' " + CRLF
			ElseIf nImp == 3
				CQUERY += "  AND   SRD.RD_ROTEIR  = 'PLR' " + CRLF
			ElseIf nImp == 4
				CQUERY += "  AND   SRD.RD_ROTEIR  = 'VEX' " + CRLF
			ElseIf nImp == 1  // 26/11/2020 - incluido o roteiro 131-13.1 parcela se houver no contracheque.
 				CQUERY += "  AND  ( SRD.RD_ROTEIR  = 'FOL'  OR SRD.RD_ROTEIR  = '131' )"+ CRLF

			Endif
			CQUERY += "  AND   SRV.D_E_L_E_T_ =  ' '  " + CRLF
			CQUERY += "  AND   SRA.D_E_L_E_T_ =  ' '  " + CRLF
			CQUERY += "  ORDER BY RD_MAT , RD_PD ,RA_CC " + CRLF  			
		Endif
	
	ElseIf nAb == 1	
		//ABERTO RC+empresa(01)+1313(AAMM)
		CQUERY := " SELECT RC_MAT MAT, RA_NOME NOME, RA_CC CC,  RA_CODFUNC CODFUN, RA_BCDEPSA BANCO, RA_CTDEPSA CONTA, RA_SALARIO SALARIO, RA_EMAIL EMAIL,"
		CQUERY += " RC_PD VERBA, RC_HORAS QTD, RC_VALOR VALOR, RV_DESC DESCRI , RV_TIPOCOD TPVER , SRA.R_E_C_N_O_ REC  " + CRLF //RA_DESCCC DCC,RA_DESCFUN DFUN , 	
		CQUERY += " FROM "+RetSQLName("SRC")+" SRC ,"+ RetSQLName("SRV")+ " SRV ,"+ RetSQLName("SRA")+ " SRA   " + CRLF
		CQUERY += " WHERE   RC_FILIAL =  '" + xFilial("SRC") + "' " + CRLF // Alterado Felipe do Nascimento - 31/05/2016
		cQuery += "  AND   RV_FILIAL =  '" + xFilial("SRV") + "' " + CRLF 
		cQuery += "  AND   RA_FILIAL =  '" + xFilial("SRA") + "' " + CRLF 
		cQuery += "  AND   RC_MAT BETWEEN '"+cMatI+"' AND '"+cMatF+"'  " + CRLF   
//		cQuery += "  AND   RC_DATARQ = '"+cYear+cMes+"'  " + CRLF
//		cQuery += "  AND   RC_DATA BETWEEN '"+cYear+cMes+"01' AND '"+cYear+cMes+"32'  " + CRLF - Retirado Felipe do Nascimento - 31/05/2016

		cQuery += "  AND (  RC_SEMANA = '"+cSemana+"' " + CRLF
		If SubSTR(cFilAnt,1,2) == '02'
			cQuery += "  OR   RC_SEMANA = '02' " + CRLF
		Endif
		cQuery += "  ) " + CRLF
		
		cQuery += "  AND   RC_MAT = RA_MAT  " + CRLF
		cQuery += "  AND   RC_PD = RV_COD  " + CRLF 
		cQuery += "  AND   RA_CC BETWEEN '"+cCCI+"' AND '"+cCCF+"'  " + CRLF   
		cQuery += "  AND   RA_TIPOPGT = '"+cPGT+"' "+CRLF
		cQuery += "  AND   RA_SITFOLH IN (" + cSitSQL + ")  "+CRLF
		CQUERY += "  AND   SRC.D_E_L_E_T_ =  ' '  " + CRLF
		If nImp == 2
			CQUERY += "  AND   SRC.RC_ROTEIR  = '132' " + CRLF
		ElseIf nImp == 3
			CQUERY += "  AND   SRC.RC_ROTEIR  = 'PLR' " + CRLF
		ElseIf nImp == 4
			CQUERY += "  AND   SRC.RC_ROTEIR  = 'VEX' " + CRLF
		ElseIf nImp == 1  // 26/11/2020 - incluido o roteiro 131-13.1 parcela se houver no contracheque.
			CQUERY += "  AND  ( SRC.RC_ROTEIR  = 'FOL'  OR SRC.RC_ROTEIR  = '131' )"+ CRLF

		Endif
		CQUERY += "  AND   SRV.D_E_L_E_T_ =  ' '  " + CRLF
		CQUERY += "  AND   SRA.D_E_L_E_T_ =  ' '  " + CRLF
		CQUERY += "  ORDER BY RC_MAT , RC_PD ,RA_CC " + CRLF  
		
	Endif

	
ElseIf nImp == 2  .OR. nImp == 3  .OR. nImp == 4

	/*
	If nAb == 2 //Se for Fechado, testa se existe a tabela
		If !TestaTab("RI"+cEmpant+SubSTR(dDt,3,2)+"13")
			Alert("Não foram encontrados dados. RI"+cEmpant+SubSTR(dDt,3,2)+"13")			
			Return	
		Endif
	Endif
	*/
	//CQUERY := " SELECT RI_MAT MAT, RA_NOME NOME, RA_CC CC,  RA_CODFUNC CODFUN, RA_BCDEPSA BANCO, RA_CTDEPSA CONTA, RA_SALARIO SALARIO, RA_EMAIL EMAIL,"
	//CQUERY += " RI_PD VERBA, RI_HORAS QTD, RI_VALOR VALOR, RV_DESC DESCRI , RV_TIPOCOD TPVER , SRA.R_E_C_N_O_ REC  " + CRLF //RA_DESCCC DCC,RA_DESCFUN DFUN , 

	If nAb == 1
	    //ABERTO
		//CQUERY += " FROM "+ RetSQLName("SRI")+ " SRI ,"+ RetSQLName("SRV")+ " SRV ,"+ RetSQLName("SRA")+ " SRA   " + CRLF

		CQUERY := " SELECT RC_MAT MAT, RA_NOME NOME, RA_CC CC,  RA_CODFUNC CODFUN, RA_BCDEPSA BANCO, RA_CTDEPSA CONTA, RA_SALARIO SALARIO, RA_EMAIL EMAIL,"
		CQUERY += " RC_PD VERBA, RC_HORAS QTD, RC_VALOR VALOR, RV_DESC DESCRI , RV_TIPOCOD TPVER , SRA.R_E_C_N_O_ REC  " + CRLF //RA_DESCCC DCC,RA_DESCFUN DFUN , 	
		CQUERY += " FROM "+RetSQLName("SRC")+" SRC ,"+ RetSQLName("SRV")+ " SRV ,"+ RetSQLName("SRA")+ " SRA   " + CRLF
		CQUERY += " WHERE   RC_FILIAL =  '" + xFilial("SRC") + "' " + CRLF // Alterado Felipe do Nascimento - 31/05/2016
		cQuery += "  AND   RV_FILIAL =  '" + xFilial("SRV") + "' " + CRLF 
		cQuery += "  AND   RA_FILIAL =  '" + xFilial("SRA") + "' " + CRLF 
		cQuery += "  AND   RC_MAT BETWEEN '"+cMatI+"' AND '"+cMatF+"'  " + CRLF   
//		cQuery += "  AND   RC_DATARQ = '"+cYear+cMes+"'  " + CRLF
//		cQuery += "  AND   RC_DATA BETWEEN '"+cYear+cMes+"01' AND '"+cYear+cMes+"32'  " + CRLF - Retirado Felipe do Nascimento - 31/05/2016

		cQuery += "  AND  ( RC_SEMANA = '"+cSemana+"' " + CRLF
		If SubSTR(cFilAnt,1,2) == '02'
			cQuery += "  OR   RC_SEMANA = '02' " + CRLF
		Endif
		cQuery += "  ) " + CRLF
		
		cQuery += "  AND   RC_MAT = RA_MAT  " + CRLF
		cQuery += "  AND   RC_PD = RV_COD  " + CRLF 
		cQuery += "  AND   RA_CC BETWEEN '"+cCCI+"' AND '"+cCCF+"'  " + CRLF   
		cQuery += "  AND   RA_TIPOPGT = '"+cPGT+"' "+CRLF
		cQuery += "  AND   RA_SITFOLH IN (" + cSitSQL + ")  "+CRLF
		CQUERY += "  AND   SRC.D_E_L_E_T_ =  ' '  " + CRLF
		CQUERY += "  AND   SRV.D_E_L_E_T_ =  ' '  " + CRLF
		CQUERY += "  AND   SRA.D_E_L_E_T_ =  ' '  " + CRLF
		If nImp == 2
			CQUERY += "  AND   SRC.RC_ROTEIR  = '132' " + CRLF
		ElseIf nImp == 3
			CQUERY += "  AND   SRC.RC_ROTEIR  = 'PLR' " + CRLF
		ElseIf nImp == 4
			CQUERY += "  AND   SRC.RC_ROTEIR  = 'VEX' " + CRLF
		ElseIf nImp == 1  // 26/11/2020 - incluido o roteiro 131-13.1 parcela se houver no contracheque.
			CQUERY += "  AND   ( SRC.RC_ROTEIR  = 'FOL' OR SRC.RC_ROTEIR  = '131' ) " + CRLF

		Endif
		CQUERY += "  ORDER BY RC_MAT , RC_PD ,RA_CC " + CRLF  
	
	
	
	ElseIf nAb == 2	
		//FECHADO RI+empresa(01)+1313(AAMM)
		//CQUERY += " FROM RI"+cEmpant+SubSTR(dDt,3,2)+"13 SRI ,"+ RetSQLName("SRV")+ " SRV ,"+ RetSQLName("SRA")+ " SRA   " + CRLF		
		
		
		/*
		CQUERY := " SELECT RC_MAT MAT, RA_NOME NOME, RA_CC CC,  RA_CODFUNC CODFUN, RA_BCDEPSA BANCO, RA_CTDEPSA CONTA, RA_SALARIO SALARIO, RA_EMAIL EMAIL,"
		CQUERY += " RC_PD VERBA, RC_HORAS QTD, RC_VALOR VALOR, RV_DESC DESCRI , RV_TIPOCOD TPVER , SRA.R_E_C_N_O_ REC  " + CRLF //RA_DESCCC DCC,RA_DESCFUN DFUN , 	
		CQUERY += " FROM RC"+cEmpant+SubSTR(dDt,3,4)+" SRC ,"+ RetSQLName("SRV")+ " SRV ,"+ RetSQLName("SRA")+ " SRA   " + CRLF 
		CQUERY += " WHERE   RC_FILIAL =  '" + xFilial("SRC") + "' " + CRLF  // Alterado Felipe do Nascimento - 31/05/2016
		cQuery += "  AND   RV_FILIAL =  '" + xFilial("SRV") + "' " + CRLF 
		cQuery += "  AND   RA_FILIAL =  '" + xFilial("SRA") + "' " + CRLF 
		cQuery += "  AND   RC_MAT BETWEEN '"+cMatI+"' AND '"+cMatF+"'  " + CRLF   
//		cQuery += "  AND   RC_DATA BETWEEN '"+cYear+cMes+"01' AND '"+cYear+cMes+"32'  " + CRLF - Retirado Felipe do Nascimento - 31/05/2016

		cQuery += "  AND  ( RC_SEMANA = '"+cSemana+"' " + CRLF
		If SubSTR(cFilAnt,1,2) == '02'
			cQuery += "  OR   RC_SEMANA = '02' " + CRLF
		Endif
		cQuery += "  ) " + CRLF

		cQuery += "  AND   RC_MAT = RA_MAT  " + CRLF
		cQuery += "  AND   RC_PD = RV_COD  " + CRLF 
		cQuery += "  AND   RA_CC BETWEEN '"+cCCI+"' AND '"+cCCF+"'  " + CRLF   
		cQuery += "  AND   RA_TIPOPGT = '"+cPGT+"' "+CRLF
		cQuery += "  AND   RA_SITFOLH IN (" + cSitSQL + ")  "+CRLF
		
		CQUERY += "  AND   SRC.D_E_L_E_T_ =  ' '  " + CRLF
		CQUERY += "  AND   SRV.D_E_L_E_T_ =  ' '  " + CRLF
		CQUERY += "  AND   SRA.D_E_L_E_T_ =  ' '  " + CRLF  
		If nImp == 2
			CQUERY += "  AND   SRC.RC_ROTEIR  = '132' " + CRLF
		ElseIf nImp == 3
			CQUERY += "  AND   SRC.RC_ROTEIR  = 'PLR' " + CRLF
		Endif
		CQUERY += "  ORDER BY RC_MAT , RC_PD ,RA_CC " + CRLF  
		*/
		
		CQUERY := " SELECT RD_MAT MAT, RA_NOME NOME, RA_CC CC,  RA_CODFUNC CODFUN, RA_BCDEPSA BANCO, RA_CTDEPSA CONTA, RA_SALARIO SALARIO, RA_EMAIL EMAIL,"
		CQUERY += " RD_PD VERBA, RD_HORAS QTD, RD_VALOR VALOR, RV_DESC DESCRI , RV_TIPOCOD TPVER , SRA.R_E_C_N_O_ REC  " + CRLF //RA_DESCCC DCC,RA_DESCFUN DFUN , 	
		CQUERY += " FROM "+ RetSQLName("SRD")+ " SRD ,"+ RetSQLName("SRV")+ " SRV ,"+ RetSQLName("SRA")+ " SRA   " + CRLF
		CQUERY += " WHERE   RD_FILIAL =  '" + xFilial("SRD") + "' " + CRLF 
		cQuery += "  AND   RV_FILIAL =  '" + xFilial("SRV") + "' " + CRLF 
		cQuery += "  AND   RA_FILIAL =  '" + xFilial("SRA") + "' " + CRLF 
		cQuery += "  AND   RD_MAT BETWEEN '"+cMatI+"' AND '"+cMatF+"'  " + CRLF   
		cQuery += "  AND   RD_PERIODO = '"+cYear+cMes+"'  " + CRLF
		cQuery += "  AND (  RD_SEMANA = '"+cSemana+"' " + CRLF
		If SubSTR(cFilAnt,1,2) == '02'
		cQuery += "  OR   RD_SEMANA = '02' " + CRLF
		Endif
		cQuery += "  ) " + CRLF
		
		cQuery += "  AND   RD_MAT = RA_MAT  " + CRLF
		cQuery += "  AND   RD_PD = RV_COD  " + CRLF 
		cQuery += "  AND   RA_CC BETWEEN '"+cCCI+"' AND '"+cCCF+"'  " + CRLF   
		cQuery += "  AND   RA_TIPOPGT = '"+cPGT+"' "+CRLF
		If nImp == 2
			CQUERY += "  AND   SRD.RD_ROTEIR  = '132' " + CRLF
		ElseIf nImp == 3
			CQUERY += "  AND   SRD.RD_ROTEIR  = 'PLR' " + CRLF
		ElseIf nImp == 4
			CQUERY += "  AND   SRD.RD_ROTEIR  = 'VEX' " + CRLF
		ElseIf nImp == 1  // 26/11/2020 - incluido o roteiro 131-13.1 parcela se houver no contracheque.
			CQUERY += "  AND   ( SRD.RD_ROTEIR  = 'FOL' OR SRD.RD_ROTEIR  = '131' ) " + CRLF

		Endif
		CQUERY += "  AND   SRD.D_E_L_E_T_ =  ' '  " + CRLF
		CQUERY += "  AND   SRV.D_E_L_E_T_ =  ' '  " + CRLF
		CQUERY += "  AND   SRA.D_E_L_E_T_ =  ' '  " + CRLF
		CQUERY += "  ORDER BY RD_MAT , RD_PD ,RA_CC " + CRLF  			
	
	
	Endif	
    
    /*
	CQUERY += " WHERE   RI_FILIAL =  '" + xFilial("SRI") + "' " + CRLF 
	cQuery += "  AND   RV_FILIAL =  '" + xFilial("SRV") + "' " + CRLF 
	cQuery += "  AND   RA_FILIAL =  '" + xFilial("SRA") + "' " + CRLF 
	cQuery += "  AND   RI_MAT BETWEEN '"+cMatI+"' AND '"+cMatF+"'  " + CRLF   
	cQuery += "  AND   RI_DATA BETWEEN '"+cYear+cMes+"01' AND '"+cYear+cMes+"32'  " + CRLF
	cQuery += "  AND   RI_MAT = RA_MAT  " + CRLF
	cQuery += "  AND   RI_PD = RV_COD  " + CRLF 
	cQuery += "  AND   RA_CC BETWEEN '"+cCCI+"' AND '"+cCCF+"'  " + CRLF   
	cQuery += "  AND   RA_TIPOPGT = '"+cPGT+"' "+CRLF
	CQUERY += "  AND   SRI.D_E_L_E_T_ =  ' '  " + CRLF
	CQUERY += "  AND   SRV.D_E_L_E_T_ =  ' '  " + CRLF
	CQUERY += "  AND   SRA.D_E_L_E_T_ =  ' '  " + CRLF
	CQUERY += "  ORDER BY RI_MAT , RI_PD ,RA_CC " + CRLF
	*/
Endif

/* Bloco Inicio - inserido Felipe do Nascimento - 31/05/2016
*/
If lDebug
   AutoGrLog(cQuery)
   MostraErro()
EndIf             
/* Bloco fim */
         	
TcQuery cQuery Alias "DIF" New

If DIF->(!Eof())     
	cXLog += "Data "+DToC(Date())+CRLF
	cXLog += "Hora Inicio "+Time()+CRLF	
	cXLog += "Competencia "+SubSTR(dDt,1,6)+CRLF+CRLF
	
	cMat := DIF->MAT
	nx := 1
Endif
While DIF->(!Eof())

    If cMat <> DIF->MAT
	    Prepmail(aDifs,nx)
    	nx++
		aDifs:={}	
		cMat := DIF->MAT	    
    Endif
		
	aAdd(aDifs,{DIF->MAT,;
				AllTrim(DIF->NOME),;
				DIF->CC,;
				AllTrim(Posicione("CTT",1,xFilial("CTT")+AllTrim(DIF->CC),"CTT_DESC01")),;				
				DIF->CODFUN,;				
				AllTrim(Posicione("SRJ",1,xFilial("SRJ")+AllTrim(DIF->CODFUN),"RJ_DESC")),;				
				DIF->SALARIO,;
				DIF->QTD,;
				DIF->VERBA,;
				AllTrim(DIF->DESCRI),;
				IiF(DIF->TPVER <> "2",DIF->VALOR,0),;
				IiF(DIF->TPVER == "2",DIF->VALOR,0),;
				AllTrim(DIF->EMAIL),;
				DIF->BANCO,;
				DIF->CONTA,;
				DIF->TPVER,;
				DIF->REC })	
	
	DIF->(DbSkip())  
EndDo
If Len(aDifs) > 0    
	nx++
	Prepmail(aDifs,nX)
	//SendIt()
Endif
DIF->(DbCloseArea())
/*
If Len(aErr) > 1
	cT := 	"Os funcionários abaixo estão sem email cadastrado favor verificar! \n"
	for n_x := 1 to Len(aERR)
		cT += aERR[nX][1]+"\n"
	next 
	Aviso("RH",,{"OK"})
	
Endif
*/
Return 


Static Function Prepmail(aVet,nCtrl)

Local _lResult  := .F.             
Local nTProv 	:= 0
Local nTDesc 	:= 0
//Local _cError     := ""  
Local n_x := 1
Local nBInssPA    := 0
Local nAteLim     := 0
Local nBaseFGTS   := 0
Local nFGTS       := 0
Local nBaseIR	  := 0
Local nBaseIrFe   := 0

Local cRotBlank := "132" //Space(GetSx3Cache( "RCH_ROTEIR", "X3_TAMANHO" ))

Private aPerAberto		:= {}
Private aPerFechado		:= {}
Private cProcesso		:= "" // Armazena o processo selecionado na Pergunte GPR040 (mv_par01).
//Private cRoteiro		:= "" // Armazena o Roteiro selecionado na Pergunte GPR040 (mv_par02).
Private cPeriodo		:= "" // Armazena o Periodo selecionado na Pergunte GPR040 (mv_par03).
//Private cMes	  := ""
//Private cAno    := ""
//Private Semana    := ""

Private aCodFol	  := {}
Private aTinss	  := {}
Private aInfo	  := {}

Private oPDF
Private n 		:= 0     
Private oFont 	:= TFont():New("Arial",,14,,.F.,,,,,.F.,.F.)
Private oFontC 	:= TFont():New("Arial",,14,,.F.)//,5,.T.,5,.T.,.F.)  
Private oFontN 	:= TFont():New("Arial",,14,,.T.,,,,,.F.,.F.)
Private oFontTit := TFont():New("Arial",24,24,.T.,.T.,5,.T.,5,.T.,.F.)	
Private lAdjustToLegacy := .T. 
Private lDisableSetup  	:= .T. 
Private cNomePDF		:= Replace("HOLERITE_"+cFilAnt+"_"+AllTrim(aVet[1][1])+"_"+cYear+cMes + "-" + Dtos(dDatabase) + StrTran(time(),":") ," ","")//Replace("HOLERITE_"+AllTrim(aVet[1][1])+"_"+cYear+cMes," ","")//Replace("HOLERITE_"+AllTrim(aVet[1][2])+"_"+cYear+cMes," ","")  
Private cTitulo := "DEMONSTRATIVO DE PAGAMENTO"	

If nImp == 2
	cNomePDF		:= Replace("HOLERITE_13sal_"+cFilAnt+"_"+AllTrim(aVet[1][1])+"_"+cYear+cMes+ "-" + Dtos(dDatabase) + StrTran(time(),":")," ","")//Replace("HOLERITE_"+AllTrim(aVet[1][1])+"_"+cYear+cMes," ","")//Replace("HOLERITE_"+AllTrim(aVet[1][2])+"_"+cYear+cMes," ","")
Endif
cPathPDF := cPath
/*
Nome	          Tipo							Descrição				Obrigatório	Referência
cFilePrintert	Caracter	Nome do arquivo de relatório a ser criado.	X	 
nDevice     	Numérico	Tipos de Saída aceitos:IMP_SPOOL Envia para impressora.IMP_PDF Gera arquivo PDF à partir do relatório.Default é IMP_SPOOL	 	 
lAdjustToLegacy	Lógico		Se .T. recalcula as coordenadas para manter o legado de proporções com a classe TMSPrinter. Default é .T.IMPORTANTE: Este cálculos não funcionam corretamente quando houver retângulos do tipo BOX e FILLRECT no relatório, podendo haver distorções de algumas pixels o que acarretará no encavalamento dos retângulos no momento da impressão.	 	 
cPathInServer	Caracter	Diretório onde o arquivo de relatório será salvo	 	 
lDisabeSetup	Lógico		Se .T. não exibe a tela de Setup, ficando à cargo do programador definir quando e se será feita sua chamada. Default é .F.	 	 
lTReport		Lógico		Indica que a classe foi chamada pelo TReport. Default é .F.	 	 
oPrintSetup		Objeto		Objeto FWPrintSetup instanciado pelo usuário.	 	X
cPrinter		Caracter	Impressora destino "forçada" pelo usuário. Default é ""	 	 
lServer			Lógico		Indica impressão via Server (.REL Não será copiado para o Client). Default é .F.	 	 
lPDFAsPNG		Lógico		.T. Indica que será gerado o PDF no formato PNG. O Default é .T.	 	 
lRaw			Lógico		.T. indica impressão RAW/PCL, enviando para o dispositivo de impressão caracteres binários(RAW) ou caracteres programáveis específicos da impressora(PCL)	 	 
lViewPDF		Lógico		Quando o tipo de impressão for PDF, define se arquivo será exibido após a impressão. O default é .T.	 	 
nQtdCopy		Numérico	Define a quantidade de cópias a serem impressas quando utilizado o metodo de impressão igual a SPOOL. Recomendavel em casos aonde a utilização da classe FwMsPrinter se da por meio de eventos sem a intervenção do usuario (JOBs / Schedule por exemplo)Obs: Aplica-se apenas a ambientes que possuam o fonte FwMsPrinter.prw com data igual ou superior a 03/05/2012.	 	 

FWMsPrinter(): SetFontEx ( < nSize>, [ cFontType], [ lItalic], [ lBold], [ lUnderline] ) 
oPDF:SetResolution(72)
oPDF:SayBitmap( 075, 150, SuperGetMv("MV_LOGO",.F.,""), 448, 132)	
FWMsPrinter(): Box ( < nRow>, < nCol>, < nBottom>, < nRight>, [ cPixel] )	
oPDF:Say  	(15,15,"Modelo :",oFontN)   
*/

If Len(aVet) > 0

	DbSelectArea("SRA")	
	DbGoTo(aVet[1][17])	    	                                       
	
	If ! Fp_CodFol(@aCodFol,xFilial("SRA")) .Or. ! fInfo(@aInfo,xFilial("SRA"))
		Return
	Endif
	
	//Carregar os periodos abertos (aPerAberto) e/ou 
	// os periodos fechados (aPerFechado), dependendo 
	// do periodo (ou intervalo de periodos) selecionado
	RetPerAbertFech(cProcesso	,; // Processo selecionado na Pergunte.
					cRotBlank	,; // Roteiro selecionado na Pergunte.
					cPeriodo	,; // Periodo selecionado na Pergunte.
					cSemana		,; // Numero de Pagamento selecionado na Pergunte.
					NIL			,; // Periodo Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um periodo.
					NIL			,; // Numero de Pagamento Ate - Passar "NIL", pois neste relatorio eh escolhido apenas um numero de pagamento.
					@aPerAberto	,; // Retorna array com os Periodos e NrPagtos Abertos
					@aPerFechado ) // Retorna array com os Periodos e NrPagtos Fechados
					
/*
	// Retorna o mes e o ano do periodo selecionado na pergunte.
	AnoMesPer(	cProcesso	,; // Processo selecionado na Pergunte.
				cRotBlank	,; // Roteiro selecionado na Pergunte.
				cPeriodo	,; // Periodo selecionado na Pergunte.
				@cMes		,; // Retorna o Mes do Processo + Roteiro + Periodo selecionado
				@cYear		,; // Retorna o Ano do Processo + Roteiro + Periodo selecionado     
				cSemana		 ) // Retorna a Semana do Processo + Roteiro + Periodo selecionado
*/	
	
	Car_inss(@aTInss,(cyear+cmes)) 
	If Len(aTinss) > 0	
		nBInssPA := aTinss[Len(aTinss),1]
	EndIf

	aVerbasFunc	:= RetornaVerbasFunc(	SRA->RA_FILIAL					,; // Filial do funcionario corrente
										SRA->RA_MAT	  					,; // Matricula do funcionario corrente
										NIL								,; // 
										cRotBlank	  					,; // Roteiro selecionado na pergunte
										NIL			  					,; // Array com as verbas que deverão ser listadas. Se NIL retorna todas as verbas.
										aPerAberto	  					,; // Array com os Periodos e Numero de pagamento abertos
										aPerFechado	 	 				,; // Array com os Periodos e Numero de pagamento fechados
										NIL								,;
										NIL								,;
										.T.) 							   // Controle para verificar se conteúdo veio transferido de outra empresa


	If !ExistDir ( cPathPDF )
		MakeDir (cPathPDF) 	    
    Endif	

	_cTo := aVet[1][13]
	aAdd(aHTM,{"",_cTo,aVet[1][1]+"-"+aVet[1][2],""})       
	
	If FOpen(cPathPDF+cNomePDF) >= 0
		FErase(cPathPDF+cNomePDF)
	Endif

	oPDF := FWMSPrinter():New(cNomePDF, IMP_PDF, lAdjustToLegacy, cPathPDF, lDisableSetup ) //, .F. , oPDF , "" , .F. , .F. , .T. , .F. )

	oPDF:SetPortrait()
	oPDF:SetPaperSize(DMPAPER_A4) 
	oPDF:SetMargin(60,60,60,60)  
	oPDF:cPathPDF := cPathPDF  //GetTempPath() 
	oPDF:lPDFasPNG := .F. 
	oPDF:SetViewPDF(.F.)
	
	//If Upper(oPDF:cPathPDF) == "C:\"
	//	ApMsgInfo("A impressão do relatório diretamente na unidade raiz pode não permitir a visualização correta. " + ;
	//				"Caso isto ocorra escolha um direório diferente.","Impressão do Relatório")
	//EndIf
	
	oPDF:StartPage()  	
	nLini := 080//150
	nLinF := 370//440
	nHLin := 50
	nPosBox := 30
	nPreBox := 70	

	//oBrush := TBrush():New( , )
	//oPDF:Fillrect( {nLini,0150,nLinF,2100 }, oBrush, "-2")	

	oPDF:Box(nLini,0150,nLinF+2,2100, "-2" )	
	If cFilAnt = "0101"
		oPDF:SayBitmap(nLini+8,0160, "\html\PTN_logo"+cFilAnt+".jpg", 420, 300)
	ElseIf cFilAnt = "0201"	
		oPDF:SayBitmap(nLini+8,0160, "\html\PTN_logo"+cFilAnt+".jpg", 448, 270)
	Endif
	oPDF:Say( nLini+165,0755, cTitulo, oFontTit,,,0)	

	nLinI := nLinF
	nLinF += 110		
	oPDF:Box(nLinI,0150,nLinF,1650, "-2" )	
	oPDF:Box(nLinI,1650,nLinF,2101, "-2" )	

	nLinI += nPosBox		
	oPDF:Say(nLinI,0200,Upper(cEmp)			,oFontN,,,0)
	oPDF:Say(nLinI,1685,"Referência"			,oFontN,,,0)
	nLinI += nHLin	
	oPDF:Say(nLinI,0200,"CNPJ: "+cCNPJ			,oFontN,,,0)
	oPDF:Say(nLinI,1685,cTpF+" "+cX+"/"+cYear		,oFontN,,,0)//,300,050,1,0

	nLinI := nLinF
	aY := U_EscFer(aVet[1][1])
	If Len(aY) > 0
		nA := 290//520	
	Else
		nA := 220//320	
	Endif
	nLinF := nLinI+nA 
	
	oPDF:Box(nLinI,0150,nLinF+2,2101, "-2" )	
	nLinI += nPosBox

	oPDF:Say(nLinI,0200,"Funcionario:      "			,oFontN,,,0)
	oPDF:Say(nLinI,0500,AllTrim(aVet[1][2])			,oFontN,,,0)
	oPDF:Say(nLinI,1680,"Matricula:        "			,oFontN,,,0)
	oPDF:Say(nLinI,1940,aVet[1][1]			,oFontN,,,0)
	/*
	nLinI += nHLin	
	oPDF:Say(nLinI,0200,"Matricula:        "			,oFontN,,,0)
	oPDF:Say(nLinI,0500,aVet[1][1]			,oFontN,,,0)
    */
	nLinI += nHLin	
	oPDF:Say(nLinI,0200,"Cargo:            "			,oFontN,,,0)		
	oPDF:Say(nLinI,0500,aVet[1][5]+" - "+aVet[1][6]			,oFontN,,,0)		
	/*
	nLinI += nHLin	
	oPDF:Say(nLinI,0200,"Local:            "			,oFontN,,,0)	
	oPDF:Say(nLinI,0500,cEmpant+cFilant			,oFontN,,,0)	
	*/
	nLinI += nHLin	
	oPDF:Say(nLinI,0200,"Centro de custo:  "			,oFontN,,,0)	
	oPDF:Say(nLinI,0500,Alltrim(aVet[1][3])+" - "+aVet[1][4]			,oFontN,,,0)	
	
	nLinI += nHLin	
	oPDF:Say(nLinI,0200,"Banco:            "	,oFontN,,,0)	
	oPDF:Say(nLinI,0500,SubSTR(aVet[1][14],1,3)+"-"+Posicione("SA6",1,xFilial("SA6")+aVet[1][14],"A6_NOME")			,oFontN,,,0)	
	oPDF:Say(nLinI,1100," Conta corrente: "+aVet[1][15]			,oFontN,,,0)			
    
	
	If len(aY) > 0
		nLinI += nHLin//+20	
		oPDF:Say(nLinI,0200,"Escala de férias:            "	,oFontN,,,0)	
		/*
		nLinI += nHLin	
		oPDF:Say(nLinI,0200, "Data 1"		,oFontN,,,0)
		oPDF:Say(nLinI,0500, "Data 2"		,oFontN,,,0)	
		oPDF:Say(nLinI,1100, "Abono"		,oFontN,,,0)			
		oPDF:Say(nLinI,1600, "Adianta 13°"			,oFontN,,,0)			
		
		nLinI += nHLin	
		oPDF:Say(nLinI,0200, aY[1][1]		,oFontN,,,0)	
		oPDF:Say(nLinI,0500, aY[1][2]		,oFontN,,,0)
		oPDF:Say(nLinI,1100, aY[1][3]		,oFontN,,,0)			
		oPDF:Say(nLinI,1600, aY[1][4]		    	,oFontN,,,0)			
		*/
		oPDF:Say(nLinI,0500, "Data 1"		,oFontN,,,0)	
		oPDF:Say(nLinI,0800, "Data 2"			,oFontN,,,0)			
		oPDF:Say(nLinI,1400, "Abono"		,oFontN,,,0)			
		oPDF:Say(nLinI,1800, "Adianta 13°"			,oFontN,,,0)			
		
		nLinI += nHLin	
		oPDF:Say(nLinI,0500, aY[1][1]		,oFontN,,,0)	
		oPDF:Say(nLinI,0800, aY[1][2]		,oFontN,,,0)			
		oPDF:Say(nLinI,1400, aY[1][3]		,oFontN,,,0)			
		oPDF:Say(nLinI,1800, aY[1][4]			,oFontN,,,0)		
	Endif

	nLinI := nLinF
	nLinF := nLinI+70
	oPDF:Box(nLinI,0150,nLinF,0502, "-2" )		
	oPDF:Box(nLinI,0500,nLinF,1300, "-2" )		
	oPDF:Box(nLinI,1300,nLinF,1501, "-2" )	
	oPDF:Box(nLinI,1500,nLinF,1800, "-2" )	
	oPDF:Box(nLinI,1800,nLinF,2101, "-2" )		
	
	nLinAux := nLinF
		
	nLinI += nPosBox+18
	oPDF:Say(nLinI,0250," Código "			,oFontN,,,0)
	oPDF:Say(nLinI,0850," Descrição "			,oFontN,,,0)	
	oPDF:Say(nLinI,1350," Qtd "			,oFontN,,,0)
	oPDF:Say(nLinI,1550," Proventos "			,oFontN,,,0)
	oPDF:Say(nLinI,1850," Descontos "			,oFontN,,,0)	

	nLinI += 065//100
	nLinF := nLinI+70
	
	for n_x := 1 to Len(aVet) 
		If  aVet[n_x][16] < "3"		    
		
			oPDF:Say(nLinI,0250,aVet[n_x][9]			,oFontN,,,0)
			oPDF:Say(nLinI,0550,aVet[n_x][10]			,oFont,,,0)	
			If aVet[n_x][8] > 0
				oPDF:Say(nLinI,1350,Transform(aVet[n_x][8],"@E 999.99")			,oFont,,,0)
			Endif
			If aVet[n_x][11] > 0
				oPDF:Say(nLinI,1550,Transform(aVet[n_x][11],"@E 999,999.99")			,oFont,,,0)
			Endif
			If aVet[n_x][12] > 0
				oPDF:Say(nLinI,1850,Transform(aVet[n_x][12],"@E 999,999.99")			,oFont,,,0)	
			endif
			nLinI += nHLin			
			nTProv += aVet[n_x][11]
		  	nTDesc += aVet[n_x][12]       
        Endif
        
		nVal := IiF(aVet[n_x][11]>0,aVet[n_x][11],aVet[n_x][12])
		//Esc        := IF( !( lTerminal ), mv_par03 , nRecTipo			)	//Emitir Recibos(Adto/Folha/1¦/2¦/V.Extra)
        /*
		If aVet[n_x][9] $ aCodFol[13,1]+'*'+aCodFol[19,1]) //== aCodFol[13,1]
			nAteLim += nVal
		ElseIf aVet[n_x][9] == aCodFol[221,1] 
			nAteLim += nVal
			nAteLim := Min( nAteLim, nBInssPA )
		Elseif aVet[n_x][9] $ aCodFol[108,1]+'*'+aCodFol[17,1]+'*'+ aCodFol[337,1]+'*'+aCodFol[398,1]
			nBaseFgts += nVal
		Elseif aVet[n_x][9]$ aCodFol[109,1]+'*'+aCodFol[18,1]+'*'+aCodFol[339,1]+'*'+aCodFol[400,1]
			nFgts += nVal
		Elseif aVet[n_x][9] $ aCodFol[10,1]+'*'+aCodFol[15,1]+'*'+aCodFol[27,1]) //== aCodFol[15,1]
			nBaseIr += nVal
		Elseif aVet[n_x][9] == aCodFol[16,1]
			nBaseIrFe += nVal
		Endif
		*/
		
		//alert(STR(ascan(acodfol,{|x| ALLTRIM(x[1]) == '092' })))
		
		If aVet[n_x][9] $ aCodFol[13,1]+'*'+aCodFol[19,1]+'*'+aCodFol[14,1]+'*'+aCodFol[225,1]+'*'+aCodFol[20,1] 
			nAteLim += nVal
		ElseIf aVet[n_x][9] == aCodFol[221,1] 
			nAteLim += nVal
			//nAteLim := Min( nAteLim, nBInssPA )
		Elseif aVet[n_x][9] $ aCodFol[108,1]+'*'+aCodFol[17,1]+'*'+ aCodFol[337,1]+'*'+aCodFol[398,1]
			nBaseFgts += nVal
		Elseif aVet[n_x][9]$ aCodFol[109,1]+'*'+aCodFol[18,1]+'*'+aCodFol[339,1]+'*'+aCodFol[400,1]
			nFgts += nVal
		Elseif aVet[n_x][9] $ aCodFol[10,1]+'*'+aCodFol[15,1]+'*'+aCodFol[27,1]+'*'+aCodFol[835,1]
		 //alert(aVet[n_x][9]+" "+STR(nval))
			nBaseIr += nVal
		Elseif aVet[n_x][9] == aCodFol[16,1]
			nBaseIrFe += nVal
		Endif                  

  	
	next n_x	
	
	nLinF := nLinI

	oPDF:Box(nLinAux,0150,nLinF,0150, "-2" )		
	oPDF:Box(nLinAux,0500,nLinF,0500, "-2" )		
	oPDF:Box(nLinAux,1300,nLinF,1300, "-2" )	
	oPDF:Box(nLinAux,1500,nLinF,1500, "-2" )	
	oPDF:Box(nLinAux,1800,nLinF,1800, "-2" )		
	oPDF:Box(nLinAux,2100,nLinF,2100, "-2" )		
	oPDF:Box(nLinF,0150,nLinF,2100, "-2" )		

	nLinI := nLinF
	nLinF := nLinI+107//110
		
	oPDF:Box(nLinI,0150,nLinF,1124, "-2" )		
	oPDF:Box(nLinI,1124,nLinF,1611, "-2" )	
	oPDF:Box(nLinI,1611,nLinF,2101, "-2" )		

	nLinX := nLinI+nPosBox+36
	oPDF:Say(nLinX,0500," TOTAIS "	,oFontN)

	nLinI += nPosBox		
	oPDF:Say(nLinI,1250,"Total Proventos"			,oFontN,,,0)
	oPDF:Say(nLinI,1700,"Total Descontos"			,oFontN,,,0)	
	nLinI += nHLin	
	oPDF:Say (nLinI,1400,Transform(nTProv,"@E 999,999,999.99")	,oFont)
	oPDF:Say (nLinI,1900,Transform(nTDesc,"@E 999,999,999.99")	,oFont)	

	nLinI := nLinF
	nLinF := nLinI+107//110

	oPDF:Box(nLinI,0150,nLinF,0637, "-2" )		
	oPDF:Box(nLinI,0637,nLinF,1125, "-2" )	
	oPDF:Box(nLinI,1124,nLinF,2101, "-2" )		

	nLinX := nLinI+nPosBox+34

	nLinI += nPosBox		
	oPDF:Say(nLinI,0160,"Sal. Base"			,oFontN,,,0)
	oPDF:Say(nLinI,0660,"Sal. contrib. INSS"			,oFontN,,,0)	
	nLinI += nHLin	
	oPDF:Say  	(nLinI,0380,Transform(aVet[1][7],"@E 999,999,999.99")	,oFont,,,0)
	oPDF:Say  	(nLinI,0840,Transform(nAteLim,"@E 999,999,999.99")	,oFont,,,0)

	oPDF:Say  	(nLinX,1300," VALOR LÍQUIDO        "+Transform(nTProv-nTDesc,"@E 999,999,999.99")	,oFont,,,0)	

	nLinI := nLinF
	nLinF := nLinI+107//110

	oPDF:Box(nLinI-2,0150,nLinF,0637, "-2" )		
	oPDF:Box(nLinI-2,0637,nLinF,1125, "-2" )		
	oPDF:Box(nLinI-2,1124,nLinF,1611, "-2" )	
	oPDF:Box(nLinI-2,1611,nLinF,2101, "-2" )		

	nLinX := nLinI+nPosBox+36
	
	nLinI += nPosBox		
	oPDF:Say(nLinI,0220,"Base Cálc. FGTS"			,oFontN,,,0)
	oPDF:Say(nLinI,0650,"FGTS do mês"			,oFontN,,,0)	
	oPDF:Say(nLinI,1130,"Base Calc. IRRF"			,oFontN,,,0)	
	oPDF:Say(nLinI,1620,"Faixa IRRF %"			,oFontN,,,0)		

	nLinI += nHLin	
	oPDF:Say  	(nLini,0300,Transform(nBaseFGTS,"@E 999,999,999.99")	,oFont)
	oPDF:Say  	(nLini,0800,Transform(nFGTS,"@E 999,999,999.99")	,oFont)
	oPDF:Say  	(nLini,1300,Transform(nBaseIR,"@E 999,999,999.99")	,oFont)	
	oPDF:Say  	(nLini,1800,""	,oFont)	

	nLinI := nLinF    
	IF !Empty(cMens)
		nX := 310	
	Else
		nX := 110	
	Endif
	
	nLinF := nLinI+nx 
	nLinIA := nLinI
	
	oPDF:Box 	(nLinI,0150,nLinF,2100 , "-2")
	
	nLinI += nPosBox+26                                                                                            
	
	oPDF:Say  	(nLinI,0160,"Mensagens: "	,oFont)
	
	if !Empty(cMens)
		cMensAux := cmens                                
		nTamMens := 120
		While !Empty(cMensAux)      
			nLinI += nHLin		 
				
			oPDF:Say  	(nLinI,0160,SubSTR(cMensAux,1,nTamMens)	,oFont)			
			
			cmensAux := SubSTR(cMensAux,nTamMens+1)
					
		EndDo
			
	Endif	
	//oPDF:Box 	(nLinIA,0150,nLinI+40,2100 , "-2")			
	
	oPDF:EndPage() 
	oPDF:Preview()  

	aHTM[Len(aHTM)][1] := cPathPDF+cNomePDF        
	aHTM[Len(aHTM)][4] := cNomePDF        
	
	SendIt()
	
	*'Yttalo P. Martins-INICIO-01/12/14----------------------------------------------------------------'*
	FreeObj(oPDF)
 	oPDF := Nil
	
	Sleep(5000) //Espera 5 segundos para próximo loop, para esperar envio/upload do e-mail em andamento	
	*'Yttalo P. Martins-FIM-01/12/14-------------------------------------------------------------------'*
		
	FErase(clastProc)
	
	aHtm := {}
	
Endif

Return _lResult      


Static Function SendIt()
Local cAttach	  := "\html\PTN_logo"+cFilAnt+".jpg"     //"\html\PTN_arrow.jpg",
Local _lRet       := .T.
Local cLog        := "" 
Local n_x := 1
Private cBody := ""

cErrUsr := ""        

cBody :=" <html>" 
cBody +=" <head>" 
cBody +="   <meta content='text/html; charset=UTF-8' http-equiv='content-type'>" 
cBody +="   <title>"+_cSubject+"</title>" 
cBody +="  <style type='text/css'> "
cBody +="<!--"
cBody +=".style3 {font-size: 16px}"
cBody +="-->  "
cBody +="  </style> "
cBody +=" </head>" 
cBody +=" <body>"             
cBody +=" <p align=CENTER> "
cBody +=_cSubject+"</br></br><img src='PTN_logo"+cFilAnt+".jpg'  vspace='0' align='center'></br>"
cBody +=" </body>" 
cBody +=" </html>" 	

/*/                                                
±±³Parametros³ ExpC1 : Conta para conexao com servidor SMTP                 ³±±
±±³          | ExpC2 : Password da conta para conexao com o servidor SMTP   ³±±
±±³          ³ ExpC3 : Servidor de SMTP                                    ³±±
±±³          ³ ExpC4 : Conta de origem do e-mail. O padrao eh a mesma conta ³±±
±±³          ³        de conexao com o servidor SMTP.                      ³±±
±±³          ³ ExpC5 : Conta de destino do e-mail.                          ³±±
±±³          ³ ExpC6 : Assunto do e-mail.                                   ³±±
±±³          ³ ExpC7 : Corpo da mensagem a ser enviada.                        |±±
±±³          | ExpC8 : Patch com o arquivo que serah enviado               |±±
±±³          | ExpC9 : .T. Exibir mensagem de erro, .f. não exibir msg      |±±
±±³          | ExpC10 : Parâmetro por referência, armazena o erro de envio |±±
/*/
For n_x := 1 to Len(aHTM)
cLog := ""


	If !Empty(aHTM[n_x][2])    

		CpyT2S(lower(cPath+aHTM[n_x][4]+".pdf"),lower("\html") )        

		
		//ACSendMail(_cUser,_cPass,_cServer,_cFrom,aHTM[n_x][2],Replace(_cSubject,"ê","e"),cBody,cAttach+","+lower("\html\"+aHTM[n_x][4]+".pdf"),.T.,cLog)
//		_lRet := xACSendMail(_cUser,_cPass,_cServer,_cFrom,aHTM[n_x][2],Replace(_cSubject,"ê","e"),cBody,cAttach+","+lower("\html\"+aHTM[n_x][4]+".pdf"),.T.,@cLog) 
		
		//_lRet := xACSendMail(_cUser,_cPass,_cServer,_cFrom,"vinicius.figueiredo@criareconsulting.com",_cSubject,cBody,cAttach+","+lower("\html\"+aHTM[n_x][4]+".pdf"),.T.,@cLog)
		_lRet := xACSendMail(_cUser,_cPass,_cServer,_cFrom,aHTM[n_x][2],_cSubject,cBody,cAttach+","+lower("\html\"+aHTM[n_x][4]+".pdf"),.T.,@cLog)
		
		If !Empty(cLog)
		   //MsgAlert("Erro ao enviar e-mail: " + cLog)
		   cELog += aHTM[n_x][3]+" E-mail: "+aHTM[n_x][2]+" Hora "+Time()+" erro "+cLog+CRLF
		Else
 	       cXLog += aHTM[n_x][3]+" E-mail: "+aHTM[n_x][2]+" Hora "+Time()+CRLF
		Endif                     

		cLastProc := lower(cPath+aHTM[n_x][4]+".pdf")		
		FErase(cLastProc)		
	

	Else
		cErrUsr += aHTM[n_x][3]+CRLF
		aAdd(aErr,{cErrUsr})
	   cELog += aHTM[n_x][3]+" E-mail: "+aHTM[n_x][2]+" Hora "+Time()+" erro sem e-mail cadastrado"+CRLF		
	Endif
	
Next n_x 


return


Static Function TestaTab(cX)
lret := .F.

	cQuery := "SELECT DISTINCT COUNT(*) CONT"
	cQuery += " FROM sysobjects"
//	cQuery += " WHERE xtype IN ('U', 'V')"
	cQuery += " WHERE name = '"+cX+"'"
	
	If Select("TAB") > 0
		DbSelectarea("TAB")
		DbCloseArea()
	Endif
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TAB", .T., .T.)
	
	If TAB->CONT > 0
		lRet := .t.
	Endif

Return lRet



User Function EscFer(cXMat)
aarea1 := getArea()
aRet := {}
       
DbSelectArea("SRF")
//cIndice := Criatrab(,.F.)
//cFiltro := " ( RF_MAT = '"+cXMat+"' .AND. RF_FILIAL = '"+xFil+"' ) "
//IndRegua("SRF",cIndice,SRF->(IndexKey(1)),,cFiltro,"Selecionando Registros...")            
//While SRF->(!Eof())

DbSelectArea("SRA")
DbSetOrder(1)    
DbSeek(xFilial("SRA")+cXMat) 	            
IF SRA->RA_SITFOLH <> 'D'           
	DbSelectArea("SRF")		
	DbSeek(xFilial("SRF")+cXMat)

	//Só alimenta a escala de Férias caso seja maior que a data da competencia.
	If SubStr(Dtos(SRF->RF_DATAINI),1,6) >= MV_PAR06
		Aadd(aRet,{DToC(SRF->RF_DATAINI),DToC(SRF->RF_DATINI2),Iif((SRF->RF_DABPRO1=0 ),"Não","Sim" ), Iif(SRF->RF_PERC13S > 0,"Sim","Não" )})
	Else
		Aadd(aRet,{""," "," "," "})
	Endif	  
ENDIF
               
	//SRF->(DbSkip())                         
//End

restarea(aarea1)

Return aRet
                
*********************************************************************************************************************************

/*/                                                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ xACSendMail³                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina para o envio de emails                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 : Conta para conexao com servidor SMTP                 ³±±
±±³          | ExpC2 : Password da conta para conexao com o servidor SMTP   ³±±
±±³          ³ ExpC3 : Servidor de SMTP                                     ³±±
±±³          ³ ExpC4 : Conta de origem do e-mail. O padrao eh a mesma conta ³±±
±±³          ³         de conexao com o servidor SMTP.                      ³±±
±±³          ³ ExpC5 : Conta de destino do e-mail.                          ³±±
±±³          ³ ExpC6 : Assunto do e-mail.                                   ³±±
±±³          ³ ExpC7 : Corpo da mensagem a ser enviada.               	    |±±
±±³          | ExpC8 : Patch com o arquivo que serah enviado                |±±
±±³          | ExpC9 : .T. Exibir mensagem de erro, .f. não exibir msg      |±±
±±³          | ExpC10 : Parâmetro por referência, armazena o erro de envio  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAGAC                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                 

ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function xACSendMail(cAccount,cPassword,cServer,cFrom,cEmail,cAssunto,cMensagem,cAttach,lMsg,cLog)

Local cEmailTo := ""
Local cEmailCc := ""
Local lResult  := .F.
Local cError   := ""
Local cUser
Local nAt
Local cFromGe  := GetNewPar("MV_ACEMAIL", "")	

Default lMsg := .T.                                                                                      
Default cLog := ""

// Verifica se serao utilizados os valores padrao.
cAccount	:= Iif( cAccount  == NIL, GetMV( "MV_RELACNT" ), cAccount  )
cPassword	:= Iif( cPassword == NIL, GetMV( "MV_RELPSW"  ), cPassword )
cServer		:= Iif( cServer   == NIL, GetMV( "MV_RELSERV" ), cServer   )
cAttach 	:= Iif( cAttach == NIL, "", cAttach )
cFrom		:= Iif( cFrom == NIL, Iif( Empty(GetMV( "MV_RELFROM" )), GetMV( "MV_RELACNT" ), GetMV( "MV_RELFROM" ) ), cFrom )  

If  !EMPTY(cFromGe)  
	If Alltrim(cFrom) == Alltrim( GetMV( "MV_RELACNT" ) ) .or. Alltrim(cFrom) == Alltrim( GetMV( "MV_RELFROM" ) ) // verifica se está utilizando o email do parametro global
		cFrom := cFromGe
	EndIf	
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o e-mail para a lista selecionada. Envia como CC                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If At(Chr(59),cEmail) > 0
	cEmailTo := SubStr(cEmail,1,At(Chr(59),cEmail)-1)
	cEmailCc := SubStr(cEmail,At(Chr(59),cEmail)+1,Len(cEmail))
Else
	cEmailTo := cEmail
	cEmailCc := ""
EndIf

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o Servidor de EMAIL necessita de Autenticacao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if lResult .and. GetMv("MV_RELAUTH")
	//Primeiro tenta fazer a Autenticacao de E-mail utilizando o e-mail completo
	lResult := MailAuth(cAccount, cPassword)
	//Se nao conseguiu fazer a Autenticacao usando o E-mail completo, tenta fazer a autenticacao usando apenas o nome de usuario do E-mail
	if !lResult
		nAt 	:= At("@",cAccount)
		cUser 	:= If(nAt>0,Subs(cAccount,1,nAt-1),cAccount)
		lResult := MailAuth(cUser, cPassword)
	endif
endif

If lResult
/*
	SEND MAIL FROM cFrom ;
	TO      	cEmailTo;
	CC     		cEmailCc;
	SUBJECT 	if( GetNewPar("MV_ACEMLAC", "1")$"1", ACTxt2Htm( cAssunto ), cAssunto );
	BODY    	if( GetNewPar("MV_ACEMLAC", "1")$"12", ACTxt2Htm( cMensagem ), cMensagem );
	ATTACHMENT  cAttach  ;
	RESULT lResult
*/
	SEND MAIL FROM cFrom ;
	TO      	cEmailTo;
	CC     		cEmailCc;
	SUBJECT 	cAssunto;
	BODY    	cMensagem;
	ATTACHMENT  cAttach  ;
	RESULT lResult
	
	If !lResult
		//Erro no envio do email
		GET MAIL ERROR cError
		If lMsg
			//Help(" ",1,"ATENCAO",,STR0286 + cEmailTo +" ."+ STR0289,4,5)
		EndIf
		cLog := STR0286 + cEmailTo 	
	EndIf
	
	DISCONNECT SMTP SERVER
	
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	If lMsg		
		//Help(" ",1,"ATENCAO",,STR0288 +" "+ STR0287+cError,4,5)
	EndIf
	cLog := STR0288 +" "+ STR0287+cError	
EndIf

Return(lResult)
