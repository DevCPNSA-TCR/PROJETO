#INCLUDE "CNTR040X.CH"
#INCLUDE "PROTHEUS.CH"

#DEFINE ATOTAL   1
#DEFINE ADESCONT 2
#DEFINE AMULTAS  3
#DEFINE AVLBRUT  4
#DEFINE ARETENC  5
#DEFINE AIRRF    6
#DEFINE AISS     7
#DEFINE AINSS    8
#DEFINE APIS     9
#DEFINE ACOFIN   10
#DEFINE ACSLL    11
#DEFINE AVLLIQ   12

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |PTNR040   ºAutor  ³Vinicius Figueiredo º Data ³  07/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime boletim da medicao de acordo com o layout acordado  º±±
±±º          ³com a Porto novo                                     		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PTNR040                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PTNR040()
local cMens := ""
Local nOpca := 0

Private cTitRel := OemToAnsi(STR0001) //Medicoes
Private lEnd	:= .F.

AjustaSX1()

AjustaSXB()

If FindFunction("CliConsPad")
	CliConsPad() 
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         |
//| mv_par01     // Medicao de:                                  |
//| mv_par02     // Medicao ate:	                             |
//³ mv_par03     // Contrato de:                                 ³
//³ mv_par04     // Contrato ate:                                ³
//³ mv_par05     // Data Inicio:                                 ³
//³ mv_par06     // Data Fim:                                    ³
//³ mv_par07     // Situacao de:                                 ³
//³ mv_par08     // Situacao ate:                                ³
//³ mv_par09     // Fornecedor de:                               ³
//³ mv_par10     // Fornecedor ate:                              ³
//³ mv_par11     // Tipo de Contrato?:                           ³
//³ mv_par12     // Exibir Desconto: Sim/Nao                     ³
//³ mv_par13     // Exibir Multas/Bonificacoes: Sim/Nao          ³
//³ mv_par14     // Exibir Caucoes Retidas: Sim/Nao              ³  
//³ mv_par15     // Cliente de:  					             ³
//³ mv_par16     // Cliente ate: 				                 ³
//³ mv_par17     // Revisão de:  					             ³
//³ mv_par18     // Revisão ate: 				                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("CNR040",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tela de configuracao do Relatorio			         	     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg FROM  96,9 TO 310,592 TITLE OemToAnsi(STR0001) PIXEL    //"Medicoes"
@ 18, 6 TO 66, 287 LABEL "" OF oDlg  PIXEL
@ 29, 15 SAY OemToAnsi(STR0002) SIZE 268, 8 OF oDlg PIXEL    //"Este relatorio ira emitir uma relacao de medicoes, exibindo suas respectivas"
@ 38, 15 SAY OemToAnsi(STR0003) SIZE 268, 8 OF oDlg PIXEL    //"multas/bonificacoes, descontos e caucoes retidas. Favor verificar os  "
@ 48, 15 SAY OemToAnsi(STR0004) SIZE 268, 8 OF oDlg PIXEL    //"parametros do relatorio.."
DEFINE SBUTTON FROM 80, 190 TYPE 5 ACTION Pergunte("CNR040",.T.) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 223 TYPE 1 ACTION (oDlg:End(),nOpca:=1) ENABLE OF oDlg
DEFINE SBUTTON FROM 80, 255 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTER

If nOpca == 1
	RptStatus({|lEnd| CNR040Imp(@lEnd)})
EndIf

Return Nil



Static Function AjustaSXB()
Local i,j
Local aSXB
Local aEstrut

dbSelectArea("SXB")
dbSetOrder(1)

If !SXB->(dbSeek("CND"))
	aSXB := {}
	aEstrut:= {"XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM"}
	Aadd(aSXB,{"CND   ","1","01","DB","Medições"   ,""           ,""            ,"CND"            })
	Aadd(aSXB,{"CND   ","2","01","01","Nr Medicao" ,"Nr Medicion","Measur. Nbr.",""               })
	Aadd(aSXB,{"CND   ","4","01","01","Nr Contrato","Nr Contrato","Contract Nr" ,"CND_CONTRA"     })
	Aadd(aSXB,{"CND   ","4","01","02","Nr Medicao" ,"Nr Medicao" ,"Nr Medicao"  ,"CND_NUMMED"     })
	Aadd(aSXB,{"CND   ","5","01",""  ,""           ,""           ,""            ,"CND->CND_NUMMED"})
	
	For i:= 1 To Len(aSXB)
		If !Empty(aSXB[i][1])
			If !dbSeek(aSXB[i,1]+aSXB[i,2]+aSXB[i,3]+aSXB[i,4])
				RecLock("SXB",.T.)
				
				For j:=1 To Len(aSXB[i])
					If !Empty(FieldName(FieldPos(aEstrut[j])))
						FieldPut(FieldPos(aEstrut[j]),aSXB[i,j])
					EndIf
				Next j
				
				dbCommit()
				MsUnLock()
			EndIf
		EndIf
	Next i
EndIf

Return


Static Function AjustaSX1()
Local aAreaAnt := GetArea()
Local aHelpPor := {}
Local aHelpEng := {}
Local aHelpSpa := {}
Local cPerg	   := "CNR040"
local cTamSx1  := "SX1->X1_GRUPO"
local cValid   := "SX1->X1_VALID"
local cTamSx   := "SX1->X1_TAMANHO"
local cX1_f3   := "SX1->X1_F3"
Local nTamSX1  := Len(&(cTamSx1))
Local nTamCli  := TamSx3('A1_COD')[1]
Local nTamFor  := TamSx3('A2_COD')[1]

//---------------------------------------MV_PAR01--------------------------------------------------
aHelpPor := {"Numero inicial da Medicao"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"01","Medicao de:","","","mv_ch1","C",6,0,0,"G","","CND","","S","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR02--------------------------------------------------
aHelpPor := {"Numero final da Medicao"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"02","Medicao ate:","","","mv_ch2","C",6,0,0,"G","","CND","","S","mv_par02","","","","ZZZZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR03--------------------------------------------------
aHelpPor := {"Numero inicial do Contrato"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"03","Contrato de:","","","mv_ch3","C",15,0,0,"G","","CN9","","S","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR04--------------------------------------------------
aHelpPor := {"Numero final do Contrato"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"04","Contrato ate:","","","mv_ch4","C",15,0,0,"G","","CN9","","S","mv_par04","","","","ZZZZZZZZZZZZZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR05--------------------------------------------------
aHelpPor := {"Data de inicio da Vigencia"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"05","Vigencia de:","","","mv_ch5","D",08,0,0,"G","","","","S","mv_par05","","","","01/01/06","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR06--------------------------------------------------
aHelpPor := {"Data de termino da Vigencia"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"06","Vigencia ate:","","","mv_ch6","D",08,0,0,"G","","","","S","mv_par06","","","","31/12/49","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR07--------------------------------------------------
aHelpPor := {"Codigo inicial da Situacao"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"07","Situacao de:","","","mv_ch7","C",2,0,0,"G","","","","S","mv_par07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR08--------------------------------------------------
aHelpPor := {"Codigo final da Situacao"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"08","Situacao ate:","","","mv_ch8","C",2,0,0,"G","","","","S","mv_par08","","","","99","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR09--------------------------------------------------
aHelpPor := {"Codigo inicial do Fornecedor"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"09","Fornecedor de:","","","mv_ch9","C",nTamFor,0,0,"G","CNR040ClFr('1')","SA2","","S","mv_par09","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR10--------------------------------------------------
aHelpPor := {"Codigo final do Fornecedor"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"10","Fornecedor ate:","","","mv_cha","C",nTamFor,0,0,"G","CNR040ClFr('1')","SA2","","S","mv_par10","","","","ZZZZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)


//---------------------------------------MV_PAR11--------------------------------------------------
aHelpPor := {"Codigo do Tipo de Contrato"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"11","Tipo de Contrato ?","","","mv_chb","C",3,0,0,"G","","CN1","","S","mv_par11","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR12--------------------------------------------------
aHelpPor := {"Percentual de cálculo do IRRF"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"12","% IRRF ?","","","mv_chc","N",5,2,0,"G","","","","S","mv_par12","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR13--------------------------------------------------
aHelpPor := {"Percentual de cálculo do ISS"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"13","% ISS ?","","","mv_chd","N",5,2,0,"G","","","","S","mv_par13","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR14--------------------------------------------------
aHelpPor := {"Percentual de cálculo do INSS"}
aHelpEng := {""}
aHelpSpa := {""}

PutSX1(cPerg,"14","% INSS ?","","","mv_che","N",5,2,0,"G","","","","S","mv_par14","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

//---------------------------------------MV_PAR15--------------------------------------------------
If !SX1->(dbSeek(PADR(cPerg,nTamSX1)+"15"))
	aHelpPor := {"Codigo inicial do Cliente"}
	aHelpSpa := {"Codigo inicio del Cliente"}
	aHelpEng := {"Client initial Code"}
	
	PutSX1(cPerg,"15","Cliente de:","","","mv_chf","C",nTamCli,0,0,"G","CNR040ClFr('2')","SA1GCT","","S","mv_par15","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
EndIf	

//---------------------------------------MV_PAR16--------------------------------------------------
If !SX1->(dbSeek(PADR(cPerg,nTamSX1)+"16"))
	aHelpPor := {"Codigo final do Cliente"}
	aHelpSpa := {"Codigo final del Cliente"}
	aHelpEng := {"Client final Code"}
	
	PutSX1(cPerg,"16","Cliente ate:","","","mv_chg","C",nTamCli,0,0,"G","CNR040ClFr('2')","SA1GCT","","S","mv_par16","","","","ZZZZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
EndIf	
                                                                                       
//---------------------------------------MV_PAR17--------------------------------------------------
If !SX1->(dbSeek(PADR(cPerg,nTamSX1)+"17"))
	aHelpPor := {"Codigo inicial da Revisão do Contrato"}
	aHelpSpa := {"Codigo inicio del Revision del Contrato"}
	aHelpEng := {"Review of Contract initial Code"}
	
	PutSX1(cPerg,"17","Revisao de:","","","mv_chh","C",3,0,0,"G","","","","S","mv_par17","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
EndIf	

//---------------------------------------MV_PAR18--------------------------------------------------
If !SX1->(dbSeek(PADR(cPerg,nTamSX1)+"18"))
	aHelpPor := {"Codigo final da Revisão do Contrato"}
	aHelpSpa := {"Codigo final del Revision del Contrato"}
	aHelpEng := {"Review of Contract final Code"}
	
	PutSX1(cPerg,"18","Revisao ate:","","","mv_chi","C",3,0,0,"G","","","","S","mv_par18","","","","ZZZ","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
EndIf	                                             

//---------------------------------------MV_PAR19--------------------------------------------------
If !SX1->(dbSeek(PadR(cPerg,nTamSX1)+"19")) 	
	aHelpPor := {"Data de referência para conversão","dos valores entre moedas."}
	aHelpEng := {"Fecha de referencia para conversión","de los valores entre monedas."}
	aHelpSpa := {"Reference date for values","convertion between currency."}
	
	PutSX1(cPerg,"19","Data de referencia","Fecha de referencia","Reference date","mv_chj","D",8,0,0,"G","","","","S","mv_par19","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inclui validação no parâmetro MV_PAR09 - Fornecedor de ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SX1->( dbSeek(PadR(cPerg,nTamSX1)+"09",.T.) ) 
	If  &(cValid) != "CNR040ClFr('1')"
		RecLock("SX1",.F.)
		&(cValid) := "CNR040ClFr('1')"
		MsUnlock()
	EndIf  

	If  &(cTamSx)!= nTamFor
		RecLock("SX1",.F.)
		&(cTamSx) := nTamFor
		MsUnlock()
	EndIf            
EndIf	                                              
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inclui validação e tamanho no parâmetro MV_PAR10 - Fornecedor para ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SX1->( dbSeek(PadR(cPerg,nTamSX1)+"10",.T.) ) 
	If  &(cValid) != "CNR040ClFr('1')"
		RecLock("SX1",.F.)
		&(cValid) := "CNR040ClFr('1')"
		MsUnlock()
	EndIf  
		
	If  &(cTamSx)!= nTamFor
		RecLock("SX1",.F.)
		&(cTamSx) := nTamFor
		MsUnlock()
	EndIf          
EndIf
             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inclui validação no parâmetro MV_PAR15 - Cliente    de ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SX1->( dbSeek(PadR(cPerg,nTamSX1)+"15",.T.) ) 
	If  &(cValid) != "CNR040ClFr('2')"
		RecLock("SX1",.F.)
		&(cValid) := "CNR040ClFr('2')"
		MsUnlock()
	EndIf  

	If  &(cTamSx)!= nTamCli
		RecLock("SX1",.F.)
		&(cTamSx) := nTamCli
		MsUnlock()
	EndIf         
	
	If &(cX1_f3)!= "SA1GCT"
		RecLock("SX1",.F.)
	   &(cX1_f3)  := "SA1GCT"
		MsUnlock()
	EndIf     
EndIf	                                              
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inclui validação e tamanho no parâmetro MV_PAR16 - Cliente para    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SX1->( dbSeek(PadR(cPerg,nTamSX1)+"16",.T.) ) 
	If  &(cValid) != "CNR040ClFr('2')"
		RecLock("SX1",.F.)
		&(cValid) := "CNR040ClFr('2')"
		MsUnlock()
	EndIf  
		
	If  &(cTamSx)!= nTamCli
		RecLock("SX1",.F.)
		&(cTamSx) := nTamCli
		MsUnlock()
	EndIf          
	
	If &(cX1_f3)!= "SA1GCT"
		RecLock("SX1",.F.)
		&(cX1_f3):= "SA1GCT"
		MsUnlock()
	EndIf  	
EndIf

RestArea(aAreaAnt)
Return


Static Function CNR040Imp(lEnd)

Local cQuery       := ""
Local cAliasCNE    := ""
Local cMedicao     := ""
Local cContra      := ""
Local cRevisa      := ""
Local cDescri      := ""  
Local cUM          := ""
Local cAliasCND    := GetNextAlias()

Local aStrucCND    := CND->(dbStruct())
Local aStrucCNE    := CNE->(dbStruct())
Local aStrucCNB    := CNB->(dbStruct())
Local aTot         := Array(12)
Local aTotINMO     := {}
Local aTotINME     := {}

Local cDirSpool    := GetMv("MV_RELT")

Local nTotAcm      := 0
Local nTot         := 0
Local nBruto       := 0
Local nMultAcm     := 0
Local nTotMult     := 0
Local nDescAcm     := 0
Local nRetAcm      := 0
Local nBrAcumulado := 0
Local nBrMedicao   := 0
Local nBrTotal     := 0
Local nLinBck      := 0
Local nX           := 0
Local nDescMe	   := 0
Local nRetCac	   := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa Fontes											           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local oFont06	:= TFont():New("Arial",06,08,,.T.,,,,.T.,.F.)
Local oFont07	:= TFont():New("Arial",06,08,,.F.,,,,.F.,.F.)
Local oFont08 	:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recupera Picture dos Campos								           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cPtVLMEAC := PesqPict("CND","CND_VLMEAC")
Local cPtVLSALD := PesqPict("CND","CND_VLSALD")
Local cPtVLTOT1 := PesqPict("CND","CND_VLTOT" )
Local cPtQTDSOL := PesqPict("CNE","CNE_QTDSOL")
Local cPtQTAMED := PesqPict("CNE","CNE_QTAMED")
Local cPtQUANT  := PesqPict("CNE","CNE_QUANT" )
Local cPtPERC   := PesqPict("CNE","CNE_PERC"  )
Local cPtVLUNIT := PesqPict("CNE","CNE_VLUNIT")
Local cPtVLTOT  := PesqPict("CNE","CNE_VLTOT" )   
Local cPtQTMED  := PesqPict("CNB","CNB_QTDMED")
Local cPtCNBTOT := PesqPict("CNB","CNB_VLTOT" )
Local cPtDESC   := PesqPict("CND","CND_DESCME")
Local cPtMULT   := PesqPict("CNR","CNR_VALOR" )
Local cPtRETC   := PesqPict("CND","CND_RETCAC")
Local cPtVLCTR  := PesqPict("CN9","CN9_VLATU" )
Local cPtINSMO  := PesqPict("CN9","CN9_INSSMO")
Local cPtINSME  := PesqPict("CN9","CN9_INSSME")

Local cProduto1 := ""
Local cProduto2 := ""
Local cDescri1  := ""
Local cDescri2  := ""
Local nCNETamPrd:= TamSX3("CNE_PRODUT")[1]
Local nCNETamDsc:= TamSX3("CNB_DESCRI")[1]

Local nTipo     := 2

Local lResumo   := ExistBlock("CNR040RES")

Local lFiltForn := !Empty(mv_par09) .Or. (!Empty(mv_par10) .And. UPPER(mv_par10) != REPLICATE("Z",TamSx3("CND_FORNEC")[1]))
Local lFixo     := .T.

Local dDataRef  := If(Empty(mv_par19),dDataBase,mv_par19)

Private nlin	 := 2900
Private nPagina := 0
Private oPrint

Private nxACM := 0		
Private nRetFINAc := 0

If ExistBlock("CNR040IMP")
	ExecBlock("CNR040IMP",.F.,.F.)
EndIf

oPrint:= TMSPrinter():New(STR0001)

oPrint:Setup()
oPrint:SetLandscape()

aStrucCND := CND->(dbStruct())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta query para selecao das medicoes      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT * FROM " + RetSQLName("CND")+ " CND," + RetSQLName("CN9") + " CN9 "
cQuery += "WHERE CND.CND_FILIAL = '"+xFilial("CND")+"'"
cQuery += "  AND CN9.CN9_FILIAL = '"+xFilial("CN9")+"'"
cQuery += "  AND CND.CND_CONTRA = CN9.CN9_NUMERO "
cQuery += "  AND CND.CND_REVISA = CN9.CN9_REVISA "
cQuery += "  AND CND.CND_NUMMED >= '"+mv_par01+"'"
cQuery += "  AND CND.CND_NUMMED <= '"+mv_par02+"'"
cQuery += "  AND CND.CND_CONTRA >= '"+mv_par03+"'"
cQuery += "  AND CND.CND_CONTRA <= '"+mv_par04+"'" 
cQuery += "  AND CND.CND_REVISA >= '"+mv_par17+"'"
cQuery += "  AND CND.CND_REVISA <= '"+mv_par18+"'"
cQuery += "  AND CN9.CN9_DTINIC >= '"+dtos(mv_par05)+"'"
cQuery += "  AND CN9.CN9_DTFIM  <= '"+dtos(mv_par06)+"'"
cQuery += "  AND CN9.CN9_SITUAC >= '"+mv_par07+ "'"
cQuery += "  AND CN9.CN9_SITUAC <= '"+mv_par08+ "'"
cQuery += "  AND "
If lFiltForn
	cQuery += " CND.CND_FORNEC >= '"+mv_par09+"' AND "
	cQuery += " CND.CND_FORNEC <= '"+mv_par10+"' AND "
Else
	cQuery += " CND.CND_CLIENT >= '"+mv_par15+"' AND "
	cQuery += " CND.CND_CLIENT <= '"+mv_par16+"' AND "
EndIf
If !Empty(mv_par11)
	cQuery += " CN9.CN9_TPCTO   = '"+mv_par11 + "' AND "
EndIf
cQuery += "      CND.D_E_L_E_T_ = ' ' "
cQuery += "  AND CN9.D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)
MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasCND,.F.,.T.)},STR0005) //-- Processando

For nX := 1 to Len(aStrucCND)
	If aStrucCND[nX,2] != 'C' .And. (cAliasCND)->( FieldPos( aStrucCND[nx,1] ) ) > 0
		TCSetField(cAliasCND,aStrucCND[nX,1], aStrucCND[nX,2],aStrucCND[nX,3],aStrucCND[nX,4])
	EndIf
Next nX

While !(cAliasCND)->(Eof())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Armazena o codigo da medicao, contrato e revisao  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cMedicao := (cAliasCND)->CND_NUMMED
	cContra  := (cAliasCND)->CND_CONTRA 
	cRevisa  := (cAliasCND)->CND_REVISA

	dbSelectArea("CN9")
	dbSetOrder(1)
	
	If dbSeek(xFilial("CN9")+(cAliasCND)->CND_CONTRA+(cAliasCND)->CND_REVISA)
		lFixo := Posicione("CN1",1,xFilial("CN1")+(cAliasCND)->CN9_TPCTO,"CN1_CTRFIX") == "1"
	
		If nLin >= 2350
			CNRCabec(Nil,Nil,cTitRel,,.T.) //-- Impressao do Cabecalho da pagina
		EndIf
		
		CNRBox(0050,3180,STR0016,,.T.,1)//"BOLETIM DE MEDIÇÃO DE SERVIÇOS"
		CNRBox(0050,0295,STR0017,(cAliasCND)->CND_NUMMED,.F.,,oFont08)	//"Medição"
		CNRBox(0300,0595,STR0018,(cAliasCND)->CND_CONTRA,.F.,,oFont08)	//"Contrato"
		CNRBox(0600,0750,STR0073,(cAliasCND)->CND_REVISA,.F.,,oFont08)	//"Revisão"
		CNRBox(0755,0910,STR0019,(cAliasCND)->CND_NUMERO,.F.,,oFont08)	//"Planilha"
		If !Empty((cAliasCND)->CND_FORNEC)
			CNRBox(0915,1800,STR0020,AllTrim((cAliasCND)->CND_FORNEC)+"-"+AllTrim((cAliasCND)->CND_LJFORN)+" - "+Posicione("SA2",1,xFilial("SA2")+(cAliasCND)->CND_FORNEC+(cAliasCND)->CND_LJFORN,"A2_NOME" ),.F.,,oFont08)//"Fornecedor"
		Else
			CNRBox(0915,1800,STR0072,AllTrim((cAliasCND)->CND_CLIENT)+"-"+AllTrim((cAliasCND)->CND_LOJACL)+" - "+Posicione("SA1",1,xFilial("SA1")+(cAliasCND)->CND_CLIENT+(cAliasCND)->CND_LOJACL,"A1_NOME" ),.F.,,oFont08)//"Cliente"		
		EndIf
		CNRBox(1805,2200,STR0021,TransForm(CN9->CN9_VLATU,cPtVLCTR),.F.,,oFont08)	//"Valor do Contrato"
		CNRBox(2205,2600,STR0022,DTOC(CN9->CN9_DTFIM),.F.,,oFont08)					//"Venc. do Contrato"
		CNRBox(2605,2930,STR0023,(cAliasCND)->CND_COMPET,.F.,,oFont08)				//"Periodo"
		CNRBox(2935,3180,STR0024,DTOC((cAliasCND)->CND_DTFIM),.T.,,oFont08)		//"Data"


		CNRBox(0050,0295,"Saldo Contrato",TransForm(CN9->CN9_SALDO,cPtVLCTR),.T.,,oFont08)	//"Saldo Contrato"
	
		dbSelectArea("CNE")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cabecalho dos Itens da Medicao						 		  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		CNRBox(0050,0150,STR0025,,.F.,2,oFont06)	//"Item"
		CNRBox(0155,0570,STR0026,,.F.,2,oFont06)	//"Produto"
		CNRBox(0575,1010,STR0027,,.F.,2,oFont06)	//"Descrição"
		CNRBox(1015,1090,STR0028,,.F.,2,oFont06)	//"Unid."
		CNRBox(1095,1345,STR0029,,.F.,2,oFont06)	//"Vl. Unit."
		CNRBox(1350,1620,STR0030,,.F.,2,oFont06)	//"Qtd. Total"
		CNRBox(1625,1880,STR0031,,.F.,2,oFont06)	//"Acum. Anter."
		CNRBox(1885,2145,STR0032,,.F.,2,oFont06)	//"Qtd. Med."
		CNRBox(2150,2410,STR0033,,.F.,2,oFont06)	//"Acum. Tot."
		CNRBox(2415,2660,STR0034,,.F.,2,oFont06)	//"Vl. Acum."
		CNRBox(2665,2930,STR0035,,.F.,2,oFont06)	//"Vl. Medicao"
		CNRBox(2935,3180,STR0036,,.T.,2,oFont06)	//"Vl. Acum. Tot."
	
	    If lFixo
			cQuery := "SELECT CNE.CNE_ITEM,    CNE.CNE_PRODUT, CNB.CNB_DESCRI, CNB.CNB_UM,     CNB.CNB_VLUNIT, CNE.CNE_QTDSOL, "
			cQuery += "       CNE.CNE_QTAMED,  CNE.CNE_QUANT,  CNE.CNE_PERC,   CNE.CNE_VLUNIT, CNE.CNE_VLTOT,  CNB.CNB_QUANT,  "
			cQuery += "       CNB.CNB_QTDMED, (CNE.CNE_QTDSOL-CNE.CNE_QTAMED) AS CNE_QTDACM "
			cQuery += "  FROM "+ RetSQLName("CNE")+" CNE, "+RetSQLName("CNB")+" CNB "
			cQuery += " WHERE CNE.CNE_FILIAL = '"+xFilial("CNE")+"'"
			cQuery += "   AND CNB.CNB_FILIAL = '"+xFilial("CNB")+"'"
			cQuery += "   AND CNE.CNE_NUMMED = '"+cMedicao+"'" 
			cQuery += "   AND CNE.CNE_CONTRA = '"+cContra +"'"
			cQuery += "   AND CNE.CNE_REVISA = '"+cRevisa +"'"
			cQuery += "   AND CNB.CNB_CONTRA = CNE.CNE_CONTRA "
			cQuery += "   AND CNB.CNB_REVISA = CNE.CNE_REVISA "
			cQuery += "   AND CNB.CNB_NUMERO = CNE.CNE_NUMERO "
			cQuery += "   AND CNB.CNB_ITEM   = CNE.CNE_ITEM   "
			cQuery += "   AND CNB.D_E_L_E_T_ = ' ' "
			cQuery += "   AND CNE.D_E_L_E_T_ = ' ' "
		Else  
			cQuery := "SELECT CNE.CNE_ITEM,    CNE.CNE_PRODUT, CNE.CNE_QTDSOL, "
			cQuery += "       CNE.CNE_QTAMED,  CNE.CNE_QUANT,  CNE.CNE_PERC,   "
			cQuery += "       CNE.CNE_VLUNIT, CNE.CNE_VLTOT, (CNE.CNE_QTDSOL-CNE.CNE_QTAMED) AS CNE_QTDACM "
			cQuery += "  FROM "+ RetSQLName("CNE")+" CNE "
			cQuery += " WHERE CNE.CNE_FILIAL = '"+xFilial("CNE")+"'"
			cQuery += "   AND CNE.CNE_NUMMED = '"+cMedicao+"'" 
			cQuery += "   AND CNE.CNE_CONTRA = '"+cContra +"'"
			cQuery += "   AND CNE.CNE_REVISA = '"+cRevisa +"'"
			cQuery += "   AND CNE.D_E_L_E_T_ = ' ' "		
		EndIf
		
		cAliasCNE := GetNextAlias()
		cQuery := ChangeQuery(cQuery)
		MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasCNE,.F.,.T.)},STR0005) //-- Processando

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza estrutura dos itens da medicao  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		For nX := 1 to Len(aStrucCNE)
			If aStrucCNE[nX,2] != 'C' .And. (cAliasCNE)->( FieldPos( aStrucCNE[nx,1] ) ) > 0
				TCSetField(cAliasCNE,aStrucCNE[nX,1], aStrucCNE[nX,2],aStrucCNE[nX,3],aStrucCNE[nX,4])
			EndIf
		Next nX

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza estrutura dos itens da planilha ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		For nX := 1 to Len(aStrucCNB)
			If aStrucCNB[nX,2] != 'C' .And. (cAliasCNE)->( FieldPos( aStrucCNB[nx,1] ) ) > 0
				TCSetField(cAliasCNE,aStrucCNB[nX,1], aStrucCNB[nX,2],aStrucCNB[nX,3],aStrucCNB[nX,4])
			EndIf
		Next nX

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza campo calculado na query ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		TCSetField(cAliasCNE,"CNE_QTDACM", "N",TamSx3("CNE_QUANT")[1],TamSx3("CNE_QUANT")[2])

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicializa as variaveis de totalizacao		  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		nTotAcm := 0
		nTot    := 0
		nBruto  := 0
		cDescri := ''
	
		While !(cAliasCNE)->(Eof())

			If nLin >= 2350
				CNRCabec(Nil,Nil,cTitRel,,.T.) //-- Impressao do Cabecalho da pagina
			EndIf   
			//Limpa as descricoes e produto
			cDescri1  := ""
			cDescri2  := ""
			cProduto1 := ""
			cProduto2 := ""
			
			// Descricao das medicoes
			If lFixo
				cDescri  := AllTrim((cAliasCNE)->CNB_DESCRI)   
			Else
		   		cDescri :=  Posicione("SB1",1,xFilial("SB1")+(cAliasCNE)->CNE_PRODUT,"B1_DESC")
		   		cUM     :=  Posicione("SB1",1,xFilial("SB1")+(cAliasCNE)->CNE_PRODUT,"B1_UM")
			EndIf
		   
			cDescri1 := cDescri
			If nCNETamDsc> 20 .And. !Empty(SubStr(cDescri,21,nCNETamDsc))
				nTipo := 5      
			   	cDescri1 := SubStr(cDescri,1,20)           
			   	cDescri2 := SubStr(cDescri,21,nCNETamDsc)     
			 Else
				nTipo    := 2
				cDescri2 :=""  		 
			 EndIf
					 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica o conteudo do campo Produto³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cProduto1 := (cAliasCNE)->CNE_PRODUT  
				
			If nCNETamPrd> 15 .And. !Empty(SubStr((cAliasCNE)->CNE_PRODUT,16,nCNETamPrd)) 
				nTipo := 5           
			   	cProduto1 := SubStr((cAliasCNE)->CNE_PRODUT,1,15)           
			   	cProduto2 := SubStr((cAliasCNE)->CNE_PRODUT,16,nCNETamPrd) 			   
			Else  
				If Empty(cDescri2)           
					nTipo    := 2
					cProduto2:=""					 
				EndIf
			EndIf
				
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao dos Itens da Medicao						  		  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//-- Item da Medicao
			CNRBox(0050,0150,(cAliasCNE)->CNE_ITEM,,.F.,nTipo,oFont06)
			//-- Produto
			CNRBox(0155,0570,cProduto1,cProduto2,.F.,nTipo,oFont06)
			If lFixo
				//-- Descricao                                            
				CNRBox(0575,1010,cDescri1,cDescri2,.F.,nTipo,oFont06)
				//-- Unidade de Medida
				CNRBox(1015,1090,(cAliasCNE)->CNB_UM,,.F.,nTipo,oFont06) 
			Else  
				//-- Descricao                                            
				CNRBox(0575,1010,cDescri1,cDescri2,.F.,nTipo,oFont06)
				//-- Unidade de Medida
				CNRBox(1015,1090,cUM,,.F.,nTipo,oFont06) 			
			EndIf
			//-- Valor Unitario
			CNRBox(1095,1345,TransForm(xMoeda((cAliasCNE)->CNE_VLUNIT,(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNE_VLUNIT")[2]),cPtVLUNIT),,.F.,nTipo,oFont06,.T.)
			//-- Quantidade Solicitada
			CNRBox(1350,1620,TransForm((cAliasCNE)->CNE_QTDSOL,cPtQTDSOL),,.F.,nTipo,oFont06,.T.)
  	        //-- Quantidade Acumulada
			CNRBox(1625,1880,TransForm((cAliasCNE)->CNE_QTDACM,cPtQTMED),,.F.,nTipo,oFont06,.T.)
			//-- Quantidade
			CNRBox(1885,2145,TransForm((cAliasCNE)->CNE_QUANT,cPtQUANT),,.F.,nTipo,oFont06,.T.)
			//-- Quantidade Total
			CNRBox(2150,2410,TransForm((cAliasCNE)->CNE_QTDACM+(cAliasCNE)->CNE_QUANT,cPtQTMED),,.F.,nTipo,oFont06,.T.)		
	 		//-- Valor Acumulado
			CNRBox(2415,2660,TransForm(xMoeda(((cAliasCNE)->CNE_QTDACM*(cAliasCNE)->CNE_VLUNIT),(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNB_VLTOT")[2]),cPtCNBTOT),,.F.,nTipo,oFont06,.T.)
			//-- Valor do Periodo
			CNRBox(2665,2930,TransForm(xMoeda((cAliasCNE)->CNE_VLTOT,(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNE_VLTOT")[2]),cPtVLTOT),,.F.,nTipo,oFont06,.T.)	
			//-- Valor Total
			CNRBox(2935,3180,TransForm(xMoeda(((cAliasCNE)->CNE_QTDACM+(cAliasCNE)->CNE_QUANT)*(cAliasCNE)->CNE_VLUNIT,(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNB_QTDMED")[2]),cPtVLCTR),,.T.,nTipo,oFont06,.T.)				
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza totalizadores 	       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotAcm += xMoeda((cAliasCNE)->CNE_QTDACM*(cAliasCNE)->CNE_VLUNIT,(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNE_VLUNIT")[2])
			nTot    += xMoeda(((cAliasCNE)->CNE_QTDACM+(cAliasCNE)->CNE_QUANT)*(cAliasCNE)->CNE_VLUNIT,(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNE_VLUNIT")[2])
			nBruto  += xMoeda((cAliasCNE)->CNE_VLTOT,(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNE_VLUNIT")[2])

			If (nCNETamPrd> 15 .Or. nCNETamDsc> 20) .And. (!Empty(cProduto2).Or.!Empty(cDescri2))
				nLin += 110 //-- Salta Linha
			EndIf
	
			(cAliasCNE)->(dbSkip())		
		EndDo

		nDescMe := xMoeda((cAliasCND)->CND_DESCME,(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CND_DESCME")[2])
		//nRetCac := xMoeda((cAliasCND)->CND_RETCAC,(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CND_RETCAC")[2])
		nRetCac := xMoeda(CNR040VlRet((cAliasCND)->CND_NUMMED),(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CND_RETCAC")[2])
				
		//Calcula valor acumulado das multas
		nMultAcm     := xMoeda(CNR040VlMt((cAliasCND)->CND_NUMMED,.T.,(cAliasCND)->CND_CONTRA,(cAliasCND)->CND_REVISA,(cAliasCND)->CND_NUMERO),(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNR_VALOR")[2])
		//Calcula valor total das multas
		nTotMult     := xMoeda(CNR040VlMt((cAliasCND)->CND_NUMMED,.F.,(cAliasCND)->CND_CONTRA,(cAliasCND)->CND_REVISA,(cAliasCND)->CND_NUMERO),(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNR_VALOR")[2])
		//Calcula valor acumulado dos descontos
		nDescAcm     := xMoeda(CNR040VlDc((cAliasCND)->CND_NUMMED,.T.),(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CNQ_VALOR")[2])
		//Calcula valor acumulado da retencao
		//nRetAcm      := xMoeda(CNR040VlRet((cAliasCND)->CND_NUMMED),(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CND_RETCAC")[2])
		nRetFIN := xMoeda(CNR040VlRet((cAliasCND)->CND_NUMMED,1),(cAliasCND)->CND_MOEDA,1,dDataRef,TamSX3("CND_RETCAC")[2])

		nRetACM := nxACM                                                                                                      
		nxACM += nRetCac

		//Calcula valores acumulados
		nBrAcumulado := nTotAcm - nDescAcm - nMultAcm
		nBrMedicao   := nBruto - nDescMe - nTotMult
		nBrTotal     := nTot - nDescAcm + nDescMe - nTotMult + nMultAcm
	
		aTot[ATOTAL]  := {nTotAcm,nBruto,nTot}//Total
		aTot[ADESCONT]:= {nDescAcm,nDescMe,nDescAcm + nDescMe}//Descontos
		aTot[AMULTAS] := {nMultAcm,nTotMult,nTotMult + nMultAcm}//Multas
		aTot[AVLBRUT] := {nTotAcm - nDescAcm - nMultAcm,nBruto - nDescMe - nTotMult,nTot - nDescAcm + nDescMe - nTotMult + nMultAcm}//Vl Bruto

		aTot[ARETENC] := {nRetAcm,nRetCac,nRetCac + nRetAcm}//Vl Bruto
		
		dbSelectArea("CN1")
		dbSetOrder(1)
		
		If dbSeek(xFilial("CN1")+CN9->CN9_TPCTO)
			aTotInMO := {((aTot[ATOTAL,1]*CN9->CN9_INSSMO)/100),((aTot[ATOTAL,2]*CN9->CN9_INSSMO)/100),((aTot[ATOTAL,3]*CN9->CN9_INSSMO)/100)}
			aTotInME := {((aTot[ATOTAL,1]*CN9->CN9_INSSME)/100),((aTot[ATOTAL,2]*CN9->CN9_INSSME)/100),((aTot[ATOTAL,3]*CN9->CN9_INSSME)/100)}

			//Impostos
			aTot[AIRRF]   := {((aTot[ATOTAL,1]*CN1->CN1_ALQTIR)/100),((aTot[ATOTAL,2]*CN1->CN1_ALQTIR)/100),((aTot[ATOTAL,3]*CN1->CN1_ALQTIR)/100)}
			aTot[AISS]    := {((aTot[ATOTAL,1]*CN9->CN9_ALCISS)/100),((aTot[ATOTAL,2]*CN9->CN9_ALCISS)/100),((aTot[ATOTAL,3]*CN9->CN9_ALCISS)/100)}
			aTot[APIS]    := {((aTot[ATOTAL,1]*CN1->CN1_ALQPIS)/100),((aTot[ATOTAL,2]*CN1->CN1_ALQPIS)/100),((aTot[ATOTAL,3]*CN1->CN1_ALQPIS)/100)}
			aTot[ACOFIN]  := {((aTot[ATOTAL,1]*CN1->CN1_ALCOFI)/100),((aTot[ATOTAL,2]*CN1->CN1_ALCOFI)/100),((aTot[ATOTAL,3]*CN1->CN1_ALCOFI)/100)}
			aTot[ACSLL]   := {((aTot[ATOTAL,1]*CN1->CN1_ALCSLL)/100),((aTot[ATOTAL,2]*CN1->CN1_ALCSLL)/100),((aTot[ATOTAL,3]*CN1->CN1_ALCSLL)/100)}
			aTot[AINSS]   := {((aTotInMO[1]*CN1->CN1_ALINSS)/100),((aTotInMO[2]*CN1->CN1_ALINSS)/100),((aTotInMO[3]*CN1->CN1_ALINSS)/100)}
			aTot[AVLLIQ]  := {aTot[AVLBRUT,1],aTot[AVLBRUT,2],aTot[AVLBRUT,3]}
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calculo valor liquido    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nx:=ARETENC to ACSLL
			aTot[AVLLIQ,1] -= aTot[nx,1]
			aTot[AVLLIQ,2] -= aTot[nx,2]
			aTot[AVLLIQ,3] -= aTot[nx,3]
		Next

		If nLin+600 >= 2350
			nLin := 2350
			CNRCabec(Nil,Nil,cTitRel,,.T.) //-- Impressao do Cabecalho da pagina
		EndIf		

		If (nCNETamPrd> 15 .Or. nCNETamDsc> 20) .And. (!Empty(SubStr((cAliasCNE)->CNE_PRODUT,16,nCNETamPrd)).Or.!Empty(SubStr(cDescri,21,nCNETamDsc)))
			nLin += 150 //-- Salta Linha
		Else
			nLin    += 50
		EndIf
		
		nLinBck := nLin
	
		CNRBox(1885,2410,STR0037,,.F.,2,oFont06)//STR0037
		CNRBox(2415,2660,TransForm(aTot[ATOTAL,1],cPtVLTOT1),,.F.,2,oFont06,.T.)
		CNRBox(2665,2930,TransForm(aTot[ATOTAL,2],cPtVLTOT1),,.F.,2,oFont06,.T.)
		CNRBox(2935,3180,TransForm(aTot[ATOTAL,3],cPtVLTOT1),,.T.,2,oFont06,.T.)

		CNRBox(1885,2410,STR0038,,.F.,2,oFont06)//STR0038
		CNRBox(2415,2660,TransForm(aTot[ADESCONT,1],cPtDESC),,.F.,2,oFont06,.T.)
		CNRBox(2665,2930,TransForm(aTot[ADESCONT,2],cPtDESC),,.F.,2,oFont06,.T.)
		CNRBox(2935,3180,TransForm(aTot[ADESCONT,3],cPtDESC),,.T.,2,oFont06,.T.)

		CNRBox(1885,2410,STR0039,,.F.,2,oFont06)//"Multas"
		CNRBox(2415,2660,TransForm(aTot[AMULTAS,1],cPtMULT),,.F.,2,oFont06,.T.)	
		CNRBox(2665,2930,TransForm(aTot[AMULTAS,2],cPtMULT),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(aTot[AMULTAS,3],cPtMULT),,.T.,2,oFont06,.T.)	

		CNRBox(1885,2410,STR0040,,.F.,2,oFont06)//"Vl Bruto"
		CNRBox(2415,2660,TransForm(aTot[AVLBRUT,1],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2665,2930,TransForm(aTot[AVLBRUT,2],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(aTot[AVLBRUT,3],cPtVLTOT1),,.T.,2,oFont06,.T.)

		nLin+=30	
		CNRBox(1885,2410,STR0041,,.F.,2,oFont06)//"Retenção"
		CNRBox(2415,2660,TransForm(aTot[ARETENC,1],cPtRETC),,.F.,2,oFont06,.T.)	
		CNRBox(2665,2930,TransForm(aTot[ARETENC,2],cPtRETC),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(aTot[ARETENC,3],cPtRETC),,.T.,2,oFont06,.T.)	
	
		CNRBox(1885,2410,STR0042,,.F.,2,oFont06)//"IRRF"
		CNRBox(2415,2660,TransForm(aTot[AIRRF,1],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2665,2930,TransForm(aTot[AIRRF,2],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(aTot[AIRRF,3],cPtVLTOT1),,.T.,2,oFont06,.T.)	

		CNRBox(1885,2410,STR0043,,.F.,2,oFont06)//"ISS"
		CNRBox(2415,2660,TransForm(aTot[AISS,1],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2665,2930,TransForm(aTot[AISS,2],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(aTot[AISS,3],cPtVLTOT1),,.T.,2,oFont06,.T.)	

		CNRBox(1885,2410,STR0044,,.F.,2,oFont06)//"INSS"
		CNRBox(2415,2660,TransForm(aTot[AINSS,1],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2665,2930,TransForm(aTot[AINSS,2],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(aTot[AINSS,3],cPtVLTOT1),,.T.,2,oFont06,.T.)	

		CNRBox(1885,2410,STR0066,,.F.,2,oFont06)//"PIS"
		CNRBox(2415,2660,TransForm(aTot[APIS,1],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2665,2930,TransForm(aTot[APIS,2],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(aTot[APIS,3],cPtVLTOT1),,.T.,2,oFont06,.T.)	

		CNRBox(1885,2410,STR0067,,.F.,2,oFont06)//"COFINS"
		CNRBox(2415,2660,TransForm(aTot[ACOFIN,1],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2665,2930,TransForm(aTot[ACOFIN,2],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(aTot[ACOFIN,3],cPtVLTOT1),,.T.,2,oFont06,.T.)	
		
		CNRBox(1885,2410,STR0068,,.F.,2,oFont06)//"CSLL"
		CNRBox(2415,2660,TransForm(aTot[ACSLL,1],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2665,2930,TransForm(aTot[ACSLL,2],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(aTot[ACSLL,3],cPtVLTOT1),,.T.,2,oFont06,.T.)	

		CNRBox(1885,2410,STR0045,,.F.,2,oFont06)//"Vl. Liq."
		CNRBox(2415,2660,TransForm(aTot[AVLLIQ,1],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2665,2930,TransForm(aTot[AVLLIQ,2],cPtVLTOT1),,.F.,2,oFont06,.T.)	
		CNRBox(2935,3180,TransForm(aTot[AVLLIQ,3],cPtVLTOT1),,.T.,2,oFont06,.T.)	


//		If nRetFIN > 0                 
			nRetFINAc += nRetFIN
			CNRBox(1885,2660,"Retenção a liberar no financeiro",,.F.,2,oFont06)//"Retenção registrada no financeiro"
			//CNRBox(2415,2660,"",,.F.,2,oFont06,.T.)	
			CNRBox(2665,2930,TransForm(nRetFIN,cPtRETC),,.F.,2,oFont06,.T.)	
			CNRBox(2935,3180,TransForm(nRetFINAc,cPtRETC),,.T.,2,oFont06,.T.)	
//        Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Finaliza a consulta aos itens ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		(cAliasCNE)->(dbCloseArea())	
	EndIf

	nLin := 2350 //-- Forca a Quebra da pagina por Medicao
   
	// Impressao do Resumo para faturamento
	If lResumo
		ExecBlock("CNR040RES",.F.,.F.,{(cAliasCND)->CND_CONTRA,(cAliasCND)->CND_NUMMED,(cAliasCND)->CND_FORNEC,(cAliasCND)->CND_LJFORN,cDescri,aTot[AISS][2],aTot[AINSS][2],aTot[ATOTAL,2],aTot[AIRRF,2],aTot[APIS,2],aTot[ACOFIN,2],aTot[ACSLL,2],aTotInMO[2],aTotInME[2]})
	EndIf

	(cAliasCND)->(dbSkip())

	If cContra <> 	(cAliasCND)->CND_CONTRA
		nxACM := 0			 
		nRetFINAc := 0
		nRetAcm := 0
		nRetCac := 0                                       		
	EndIf
	
EndDo

(cAliasCND)->(dbCloseArea())

//-- Grava Imagem em Disco
If !Empty(cDirSpool)
	oPrint:SaveAllAsJPEG(cDirSpool+"PTNR040",875,1170,140)
EndIF
                                                        
//-- Visualiza antes de Imprimir
oPrint:Preview()
Return



Static Function CNR040VlRet(cNumMed,nop)
Local cQuery := ""
Local cAlias := GetNextAlias()
Local aArea  := GetArea()
Local nTot   := 0
If nop == nIl
	nop := 0
Endif

dbSelectArea("CND")
dbSetOrder(4)

If dbSeek(xFilial("CND")+cNumMed) .AND. nop <> 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona as medicoes para calculo dos valores retidos   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT SUM(CND.CND_RETCAC) AS TOTRET "
	cQuery += "  FROM "+RetSQLName("CND")+" CND "
	cQuery += " WHERE CND.CND_FILIAL = '"+xFilial("CND")+"'"
	cQuery += "   AND CND.CND_NUMMED < '"+CND->CND_NUMMED+"'"
	cQuery += "   AND CND.CND_CONTRA = '"+CND->CND_CONTRA+"'"
	cQuery += "   AND CND.CND_REVISA = '"+CND->CND_REVISA+"'"
	cQuery += "   AND CND.CND_NUMERO = '"+CND->CND_NUMERO+"'"
	cQuery += "   AND CND.D_E_L_E_T_ = ' '"

	cAlias := GetNextAlias()
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza estrutura do total   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	TCSetField(cAlias,"TOTRET", "N",TamSx3("CND_RETCAC")[1],TamSx3("CND_RETCAC")[2])
	
	nTot := (cAlias)->TOTRET
	
	(cAlias)->(dbCloseArea())

EndIf               

/////////CUSTOM PTN
If nTot == 0

	dbSelectArea("CND")
	dbSetOrder(4)	
	If dbSeek(xFilial("CND")+cNumMed)

		cQuery := " SELECT E2_VALOR FROM "+RetSQLName("SC7")+" C7,"+RetSQLName("SD1")+" D1,"+RetSQLName("SF1")+" F1,"+RetSQLName("SE2")+" E2 "
		cQuery += " WHERE "                           
		cQuery += " C7.C7_FILIAL = '"+xFilial("SC7")+"'"
		cQuery += "AND D1.D1_FILIAL = '"+xFilial("SD1")+"'"		
		cQuery += "AND F1.F1_FILIAL = '"+xFilial("SF1")+"'"		
		cQuery += "AND E2.E2_FILIAL = '"+xFilial("SE2")+"'"		
		cQuery += "AND C7.C7_NUM = '"+CND->CND_PEDIDO +"' " 
		cQuery += "AND C7.C7_FORNECE = '"+CND->CND_FORNEC+"' " 
		cQuery += "AND C7.C7_LOJA = '"+CND->CND_LJFORN+"' " 
		cQuery += "AND D1.D1_PEDIDO = C7.C7_NUM "
		cQuery += "AND D1.D1_ITEMPC = C7.C7_ITEM "
		cQuery += "AND D1.D1_FORNECE = C7.C7_FORNECE "
		cQuery += "AND D1.D1_LOJA = C7.C7_LOJA "
		cQuery += "AND D1.D1_DOC = F1.F1_DOC "
		cQuery += "AND D1.D1_FORNECE = F1.F1_FORNECE "
		cQuery += "AND D1.D1_LOJA = F1.F1_LOJA "
		cQuery += "AND E2.E2_NUM = F1.F1_DUPL "
		cQuery += "AND E2.E2_PREFIXO = F1.F1_PREFIXO "
		cQuery += "AND E2.E2_FORNECE = F1.F1_FORNECE "
		cQuery += "AND E2.E2_LOJA = F1.F1_LOJA "
		cQuery += "AND E2.E2_TIPO = 'CAU' "

		cQuery += "AND E2.E2_BAIXA = ' ' "		
		
		cQuery += "AND C7.D_E_L_E_T_ = ' ' "
		cQuery += "AND D1.D_E_L_E_T_ = ' ' "
		cQuery += "AND F1.D_E_L_E_T_ = ' ' "
		cQuery += "AND E2.D_E_L_E_T_ = ' ' "
	
		cAlias := GetNextAlias()
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)
	
		nTot := (cAlias)->E2_VALOR
		
		(cAlias)->(dbCloseArea())
	
	EndIf               	

Endif

If nTot == 0 .AND. nop <> 1

	dbSelectArea("CND")
	dbSetOrder(4)	
	If dbSeek(xFilial("CND")+cNumMed)
	
		cQuery := " SELECT CN1_XPERET PER FROM "+RetSQLName("CN1")+" CN1,"+RetSQLName("CN9")+" CN9 "
		cQuery += " WHERE "                           
		cQuery += " CN1.CN1_FILIAL = '"+xFilial("CN1")+"'"
		cQuery += "AND CN9.CN9_FILIAL = '"+xFilial("CN9")+"'"		
		cQuery += "AND CN9.CN9_NUMERO = '"+CND->CND_CONTRA +"' " 
		cQuery += "AND CN9.CN9_REVATU = '"+CND->CND_REVISA+"' " 
		cQuery += "AND CN9.CN9_TPCTO = CN1_CODIGO " 
		cQuery += "AND CN1.D_E_L_E_T_ = ' ' "
		cQuery += "AND CN9.D_E_L_E_T_ = ' ' "
	
		cAlias := GetNextAlias()
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)
		If 	(cAlias)->(!EoF()) .AND. (cAlias)->PER > 0
			nTot := CND->CND_VLTOT*((cAlias)->PER/100)
		Endif		
		(cAlias)->(dbCloseArea())	

	Endif	
Endif

RestArea(aArea)

Return nTot



Static Function CNR040VlMt(cNumMed,lAcumulado,cContra,cRevisa,cNumero)
Local cQuery     := ""
Local cAlias    := GetNextAlias()
Local aArea     := GetArea()
Local nTot      := 0  
Local lCtMulBoni:= !Empty( CNR->( FieldPos( "CNR_CONTRA" ) ) ) 

dbSelectArea("CND")
dbSetOrder(1)

If dbSeek(xFilial("CND")+cContra+cRevisa+cNumero+cNumMed)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona as medicoes para calculo das multas    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT CNR.CNR_VALOR AS TOTMULT " 
	If lCtMulBoni
		cQuery += ", CNR.CNR_CONTRA "
	EndIf
	cQuery += "  FROM "+RetSQLName("CNR")+" CNR, "+RetSQLName("CND")+" CND"
	cQuery += " WHERE CNR.CNR_FILIAL = '"+xFilial("CNR")+"'"
	cQuery += "   AND CND.CND_FILIAL = '"+xFilial("CND")+"'"
	cQuery += "   AND CNR.CNR_NUMMED = CND.CND_NUMMED"      
	cQuery += "   AND "
	If lAcumulado
		cQuery += " CND.CND_NUMMED < '"+ CND->CND_NUMMED +"' AND "//Busca as medicoes anteriores
	Else
		cQuery += " CND.CND_NUMMED = '"+CND->CND_NUMMED+"' AND "//Busca medicao atual
	EndIf
	cQuery += "      CND.CND_CONTRA = '"+CND->CND_CONTRA+"'"
	cQuery += "  AND CND.CND_REVISA = '"+CND->CND_REVISA+"'"
	cQuery += "  AND CND.CND_NUMERO = '"+CND->CND_NUMERO+"'"
	cQuery += "  AND CND.D_E_L_E_T_ = ' '"
	cQuery += "  AND CNR.D_E_L_E_T_ = ' '"

	cAlias := GetNextAlias()
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza estrutura do total   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	TCSetField(cAlias,"TOTMULT", "N",TamSx3("CNR_VALOR")[1],TamSx3("CNR_VALOR")[2])
	
	While !( cAlias )->( Eof() )
		If lCtMulBoni
			If !Empty(( cAlias )->CNR_CONTRA) .And. (( cAlias )->CNR_CONTRA) <> CND->CND_CONTRA 
				( cAlias )->( dbSkip() )
				Loop  
			EndIf
		EndIf

		nTot += (cAlias)->TOTMULT
		( cAlias )->( dbSkip() )
	EndDo
	
	
	(cAlias)->(dbCloseArea())

EndIf

RestArea(aArea)

Return nTot



Static Function CNR040VlDc(cNumMed,lAcumulado)
Local cQuery := ""
Local cAlias := GetNextAlias()
Local aArea  := GetArea()
Local nTot   := 0

dbSelectArea("CND")
dbSetOrder(4)

If dbSeek(xFilial("CND")+cNumMed)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Seleciona as medicoes para calculo dos descontos ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cQuery := "SELECT SUM(CNQ.CNQ_VALOR) AS TOTDESC "
	cQuery += "  FROM "+RetSQLName("CNQ")+" CNQ, "+RetSQLName("CND")+" CND "
	cQuery += " WHERE CNQ.CNQ_FILIAL = '"+xFilial("CNQ")+"'"
	cQuery += "   AND CND.CND_FILIAL = '"+xFilial("CND")+"'"
	cQuery += "   AND CNQ.CNQ_NUMMED = CND.CND_NUMMED"   
	cQuery += "   AND CNQ.CNQ_CONTRA = CND.CND_CONTRA"
	cQuery += "   AND "
	If lAcumulado
		cQuery += "  CND.CND_NUMMED < '"+ CND->CND_NUMMED +"' AND "//Busca as medicoes anteriores
	Else
		cQuery += "  CND.CND_NUMMED = '"+CND->CND_NUMMED+"' AND "//Busca a medicao atual
	EndIf
	cQuery += "      CND.CND_CONTRA = '"+CND->CND_CONTRA+"'"
	cQuery += "  AND CND.CND_REVISA = '"+CND->CND_REVISA+"'"
	cQuery += "  AND CND.CND_NUMERO = '"+CND->CND_NUMERO+"'"
	cQuery += "  AND CND.D_E_L_E_T_ = ' '"
	cQuery += "  AND CNQ.D_E_L_E_T_ = ' '"

	cAlias := GetNextAlias()
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAlias,.F.,.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza estrutura do total   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	TCSetField(cAlias,"TOTDESC", "N",TamSx3("CNQ_VALOR")[1],TamSx3("CNQ_VALOR")[2])
	
	nTot := (cAlias)->TOTDESC
	
	(cAlias)->(dbCloseArea())

EndIf

RestArea(aArea)

Return nTot



Static Function CNR040ClFr(cTipo)
Local aSaveArea	:= GetArea()

If cTipo=="1"    
	If !Empty(mv_par09) .Or. (!Empty(mv_par10) .And. UPPER(mv_par10) != REPLICATE("Z",TamSx3("A2_COD")[1]))
		MV_PAR15	:= Space(6)
		MV_PAR16	:= REPLICATE("Z",TamSx3("A1_COD")[1])	 
	EndIf
Else
	If !Empty(mv_par15) .Or. (!Empty(mv_par16) .And. UPPER(mv_par16) != REPLICATE("Z",TamSx3("A1_COD")[1]))
		MV_PAR09	:= Space(6)
		MV_PAR10	:= REPLICATE("Z",TamSx3("A2_COD")[1])    
	EndIf
EndIf   

	    
RestArea(aSaveArea)

Return    
