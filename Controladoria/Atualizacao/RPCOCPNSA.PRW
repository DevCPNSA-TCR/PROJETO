#include "protheus.ch"
#DEFINE __CABFIXO  02

/*/
_F_U_N_C_ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³FUNCAO    ³ PCOC001  ³ AUTOR ³                       ³ DATA ³ 11/07/2006 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³DESCRICAO ³ Programa de impressao do demonstrativo de saldos orc. e comp ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ USO      ³ SIGAPCO                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³_DOCUMEN_ ³ PCOC002                                                      ³±±
±±³_DESCRI_  ³ Programa de impressao do demonstrativo de saldos ORÇADOS X   ³±±
±±³_           COMPROMETIDOS                                                ³±±
±±³_FUNC_    ³ Esta funcao devera ser utilizada com a sua chamada normal a  ³±±
±±³          ³ partir do Menu do sistema.                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±	
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function PCOC001()
Local aDados	:=	{}
Local oProcess
Local oDlg,oPanel,oPanel1
Local oView
Local oGraphic
Local aArea		:= GetArea()
Local cAlias
Local nRecView
Local nStep
Local dx
Local nSerie
Local cTexto
Local aSize    := {}
Local aPosObj  := {}
Local aObjects := {}
Local aInfo    := {}            
//Local aView	   := {{CtoD(""), "", 	"", 0, 0, 0, 0, 0}}
Local aView	   := {{CtoD(""), "", 	"", 0, 0,"", ""}}
Local aViewImp	:= {}
Local nx,nY
Local aButtons	:=	{}	
Local oDataDe,oDataAte,oSay3,oSay4,oGrp5,oSay6,oSay7,oGet8,oGet9,oGet10,oSay11,oGrp15,oSBtn16,oGrp17,oGrp19
Local dDataDe	:=	dDataBase//FirstDay(dDataBase)
Local dDataAte	:=	dDataBase
Local	cCo	:=	CriaVar('AKD_CO')
Local	cCC	:=	CriaVar('AKD_CC')
//Local aHeader	:=	{'Data ','Historico ','Tipo de saldo','OR+CT','ME','EM','RE','PG'}
Local aHeader	:=	{'Data ','Historico ','Tipo de saldo','OR+CT','RE','Lote','ID'}
Local aSizes	:=	{50,150,50,50,50,50,50,50}                         

SetKey(VK_F5,{|| Eval(oSBtn16:bAction)})


	aSize := MsAdvSize(,.F.,400)
	aObjects := {}
	
	AAdd( aObjects, { 100, 100 , .T., .T. } )
	
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 2, 2 }
	aPosObj := MsObjSize( aInfo, aObjects, .T. )
	
	DEFINE FONT oBold  NAME "Arial" SIZE 0, -11 BOLD
	DEFINE FONT oBold2 NAME "Arial" SIZE 0, -17 BOLD
	DEFINE FONT oFont2 NAME "Arial" SIZE 0, -12
	DEFINE FONT oFont  NAME "Arial" SIZE 0, -10


	DEFINE MSDIALOG oDlg TITLE "Consulta de movimentos" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	oDlg:lMaximized := .T.
	
	
	oPanel := TPanel():New(0,0,'',oDlg, , .T., .T.,, ,10,48,.T.,.T. )
	oPanel:Align := CONTROL_ALIGN_TOP

	oPanel1 := TPanel():New(0,0,'',oDlg, , .T., .T.,, ,40,60,.T.,.T. )
	oPanel1:Align := CONTROL_ALIGN_ALLCLIENT

//	@ 3,3 BITMAP oBar RESNAME "MYBAR" Of oPanel SIZE BrwSize(@oDlg,0)/2,8 NOBORDER When .F. PIXEL ADJUST

	//Inicio dados cabecalho
	oSay3 := TSAY():Create(oPanel)
	oSay3:cName := "oSay3"
	oSay3:cCaption := "Data de :"
	oSay3:nLeft := 10 //12
	oSay3:nTop := 24
	oSay3:nWidth := 70 //50
	oSay3:nHeight := 15
	oSay3:lShowHint := .F.
	oSay3:lReadOnly := .F.
	oSay3:Align := 0
	oSay3:lVisibleControl := .T.
	oSay3:lWordWrap := .F.
	oSay3:lTransparent := .F.

	oDataDe := TGET():Create(oPanel)
	oDataDe:cName 	:= "oDataDe"
	oDataDe:nLeft 	:= 55 //65
	oDataDe:nTop 	:= 22
	oDataDe:nWidth := 85 //65
	oDataDe:nHeight:= 21
	oDataDe:lShowHint := .F.
	oDataDe:lReadOnly := .F.
	oDataDe:Align := 0
	oDataDe:cVariable := "dDataDe"
	oDataDe:bSetGet := {|u| If(PCount()>0,dDataDe:=u,dDataDe) }
	oDataDe:lVisibleControl := .T.
	oDataDe:lPassword := .F.
	oDataDe:lHasButton := .F.
	
	
	oSay4 := TSAY():Create(oPanel)
	oSay4:cName := "oSay4"
	oSay4:cCaption := "Data até : "
	oSay4:nLeft := 10 //12
	oSay4:nTop := 54
	oSay4:nWidth := 70 //50
	oSay4:nHeight := 17
	oSay4:lShowHint := .F.
	oSay4:lReadOnly := .F.
	oSay4:Align := 0
	oSay4:lVisibleControl := .T.
	oSay4:lWordWrap := .F.
	oSay4:lTransparent := .F.

	oDataAte := TGET():Create(oPanel)
	oDataAte:cName 	:= "oDataAte"
	oDataAte:nLeft 	:= 55 //65
	oDataAte:nTop 	:= 52
	oDataAte:nWidth	:= 85 //65
	oDataAte:nHeight:= 21
	oDataAte:lShowHint := .F.
	oDataAte:lReadOnly := .F.
	oDataAte:Align := 0
	oDataAte:cVariable := "dDataAte"
	oDataAte:bSetGet := {|u| If(PCount()>0,dDataAte:=u,dDataAte) }
	oDataAte:lVisibleControl := .T.
	oDataAte:lPassword := .F.
	oDataAte:lHasButton := .F.
	
	
	oGrp5 := TGROUP():Create(oPanel)
	oGrp5:cName := "oGrp5"
	oGrp5:nLeft := 6
	oGrp5:nTop := 14
	oGrp5:nWidth := 136
	oGrp5:nHeight := 69
	oGrp5:lShowHint := .F.
	oGrp5:lReadOnly := .F.
	oGrp5:Align := 0
	oGrp5:lVisibleControl := .T.

//Inicio 1ra col	
	oSay11 := TSAY():Create(oPanel)
	oSay11:cName := "oSay11"
	oSay11:cCaption := "C.Custo :"
	oSay11:nLeft := 156
	oSay11:nTop := 24
	oSay11:nWidth := 100
	oSay11:nHeight := 17
	oSay11:lShowHint := .F.
	oSay11:lReadOnly := .F.
	oSay11:Align := 0
	oSay11:lVisibleControl := .T.
	oSay11:lWordWrap := .F.
	oSay11:lTransparent := .F.

	oGet11 := TGET():Create(oPanel)
	oGet11:cF3 := "CTT"
	oGet11:cName := "oGet11"
	oGet11:nLeft := 270
	oGet11:nTop := 22
	oGet11:nWidth := 88
	oGet11:nHeight := 21
	oGet11:lShowHint := .F.
	oGet11:lReadOnly := .F.
	oGet11:Align := 0
	oGet11:cVariable := "cCC"
	oGet11:bSetGet := {|u| If(PCount()>0,cCC:=u,cCC) }
	oGet11:lVisibleControl := .T.
	oGet11:lPassword := .F.
	oGet11:lHasButton := .F.
	
	oSay12:= TSAY():Create(oPanel)
	oSay12:cName := "oSay12"
	oSay12:cCaption := "Cta. Orc.:"
	oSay12:nLeft := 156
	oSay12:nTop := 54
	oSay12:nWidth := 80
	oSay12:nHeight := 17
	oSay12:lShowHint := .F.
	oSay12:lReadOnly := .F.
	oSay12:Align := 0
	oSay12:lVisibleControl := .T.
	oSay12:lWordWrap := .F.
	oSay12:lTransparent := .F.
	
	oGet12:= TGET():Create(oPanel)
	oGet12:cF3 := "AK5"
	oGet12:cName := "oGet12"
	oGet12:nLeft := 270
	oGet12:nTop := 52
	oGet12:nWidth := 88
	oGet12:nHeight := 21
	oGet12:lShowHint := .F.
	oGet12:lReadOnly := .F.
	oGet12:Align := 0
	oGet12:cVariable := "cCO"
	oGet12:bSetGet := {|u| If(PCount()>0,cCO:=u,cCo) }
	oGet12:lVisibleControl := .T.
	oGet12:lPassword := .F.
	oGet12:lHasButton := .F.
//Fim 1ra col

	oGrp15 := TGROUP():Create(oPanel)
	oGrp15:cName := "oGrp15"
	oGrp15:nLeft := 149
	oGrp15:nTop := 14
	oGrp15:nWidth := 900
	oGrp15:nHeight := 69
	oGrp15:lShowHint := .F.
	oGrp15:lReadOnly := .F.
	oGrp15:Align := 0
	oGrp15:lVisibleControl := .T.
	
	oSBtn16 := SBUTTON():Create(oPanel)
	oSBtn16:cName := "oSBtn16"
	oSBtn16:cCaption := "oSBtn16"
	oSBtn16:cToolTip := "Consultar (F5)"
	oSBtn16:cMsg     := "Consultar (F5)"
	oSBtn16:nLeft := 950
	oSBtn16:nTop := 40
	oSBtn16:nWidth := 52
	oSBtn16:nHeight := 22
	oSBtn16:lShowHint := .T.
	oSBtn16:lReadOnly := .F.
	oSBtn16:Align := 0
	oSBtn16:lVisibleControl := .T.
	oSBtn16:nType := 19
	oSBtn16:bWhen := {|| !Empty(cCC).And.!Empty(cCO).And.!Empty(dDataDe).And.!Empty(dDataAte) }
	oSBtn16:bAction := {|| MsAguarde( {|| GeraDados(@aView,@aDados,dDataDe,dDataAte,cCC,cCo,@oView,@aViewImp) }) }
	
	oGrp17 := TGROUP():Create(oPanel)
	oGrp17:cName := "oGrp17"
	oGrp17:cCaption := "Parametros"
	oGrp17:nLeft 	:= 3
	oGrp17:nTop 	:= 5
	oGrp17:nWidth 	:= 601
	oGrp17:nHeight := 85
	oGrp17:lShowHint := .F.
	oGrp17:lReadOnly := .F.
	oGrp17:Align := 0
	oGrp17:lVisibleControl := .T.
	
	//Fim dados cabecalho	
	
	oView	:= TWBrowse():New( 2,2,aPosObj[1,4]-6,aPosObj[1,3]-aPosObj[1,1]-16,,aHeader,aSizes,oPanel1,,,,,,,oFont,,,,,.F.,,.T.,,.F.,,,) //"Descricao"###"Valor"
	oView:Align := CONTROL_ALIGN_ALLCLIENT
	oView:SetArray(aView)
	oView:bLine := { || aView[oView:nAT]}

	//Passagem de dados para a impressão
//  AAdd(aButtons,{'IMPRESSAO',{|| Imprimir(aViewImp,aHeader,dDataDe,dDataAte,cCo,cCC,cPlano) },'Imprimir','Imprimir'} )
	AAdd(aButtons,{'IMPRESSAO',{|| Imprimir(aViewImp,aHeader,dDataDe,dDataAte,cCo,cCC) },'Imprimir','Imprimir'} )
	//aButtons := aClone(AddToExcel(aButtons,{ {"ARRAY",'Titulo',{'Data','Hist','Saldo','CT+OR','EM','RE'},aView} } ))
      aButtons := aClone(AddToExcel(aButtons,{ {"ARRAY",'Titulo',{'Data','Hist','Saldo','CT+OR','RE'},aView} } ))
      aAdd(aButtons,{"UPDWARNING",{|| ViewOrigem(aHeader,aView,oView:nAt ) },"Origem","Origem"})
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oDlg:End()},{|| oDlg:End()},, aButtons)

RestArea(aArea)
SetKey(VK_F5,Nil)
Return


Static Function GeraDados(aView,aDados,dDataDe,dDataAte,cCC,cCo,oView,aViewImp)

Local cQuery	:= ""
Local nX,nY
aView		:=	{}
aViewImp	:=	{}
aDados	:=	{}
MsProctxt('Consultando dados...')
//O len de aDados[2] tem que ser igual a __CABFIXO neste ponto
cQuery	:=	"SELECT   AKD_DATA , AKD_HIST, AKD_TPSALD, AKD_LOTE,AKD_ID,  "
cQuery	+=	"	  (SUM(CASE WHEN AKD_TPSALD IN ('OR','CT') AND AKD_TIPO='1' THEN AKD_VALOR1 ELSE '' END) - "
cQuery	+=	"       SUM(CASE WHEN AKD_TPSALD ='CT' AND AKD_TIPO='2' THEN AKD_VALOR1 ELSE 0 END)) AS 'SALDO_OR',"
//cQuery	+=	"      (SUM(CASE WHEN AKD_TPSALD ='ME' AND AKD_TIPO='1' THEN AKD_VALOR1 ELSE 0 END) - "
//cQuery	+=	"       SUM(CASE WHEN AKD_TPSALD ='ME' AND AKD_TIPO='2' THEN AKD_VALOR1 ELSE 0 END)) AS 'SALDO_ME',"
//cQuery	+=	"      (SUM(CASE WHEN AKD_TPSALD ='EM' AND AKD_TIPO='1' THEN AKD_VALOR1 ELSE 0 END) - "
//cQuery	+=	"       SUM(CASE WHEN AKD_TPSALD ='EM' AND AKD_TIPO='2' THEN AKD_VALOR1 ELSE 0 END)) AS 'SALDO_EM',"
cQuery	+=	"      (SUM(CASE WHEN AKD_TPSALD ='RE' AND AKD_TIPO='1' THEN AKD_VALOR1 ELSE 0 END) - "
cQuery	+=	"       SUM(CASE WHEN AKD_TPSALD ='RE' AND AKD_TIPO='2' THEN AKD_VALOR1 ELSE 0 END)) AS 'SALDO_RE'"
//cQuery	+=	"      (SUM(CASE WHEN AKD_TPSALD ='PG' AND AKD_TIPO='1' THEN AKD_VALOR1 ELSE 0 END) - "
//cQuery	+=	"       SUM(CASE WHEN AKD_TPSALD ='PG' AND AKD_TIPO='2' THEN AKD_VALOR1 ELSE 0 END)) AS 'SALDO_PG' "
cQuery	+=	" FROM "+RetSqlName('AKD') + " AKD "
cQuery	+=	" WHERE AKD_DATA BETWEEN '"+Dtos(dDataDe)+"' AND '"+Dtos(dDataAte)+"' "
cQuery	+=	" AND D_E_L_E_T_<>'*' "
cQuery	+=	" AND AKD_STATUS='1' "
cQuery	+=	" AND AKD_CC = '"+cCC+"' "
cQuery	+=	" AND AKD_CO ='"+cCO+"' "
//cQuery	+=	" AND AKD_TPSALD IN ('OR','CT','EM','ME','RE','PG') "
cQuery	+=	" AND AKD_TPSALD IN ('OR','CT','RE') "
cQuery	+=	" GROUP BY AKD_DATA, AKD_TPSALD , AKD_HIST, AKD_CC, AKD_CO,AKD_LOTE,AKD_ID"
cQuery	+=	" ORDER BY AKD_DATA, AKD_TPSALD , AKD_HIST "


dbUseArea( .T., "TopConn", TCGenQry(,,cQuery),"QRYTRB", .F., .F. )
DbGoTop()
MsProctxt('Carregando dados...')
//aRegTot	:= {"Total","","",0,0,0,0,0,0 }
//aRegTot2:= {"Saldo Final","","","","",0,0,0,0}
aRegTot	:= {"Total"    	,"","",0,0 }
aRegTot2	:= {"Saldo Final"	,"","","",0}

While !Eof()                                                                                            
	//As colunas dependem do aHeader Definido
	//AAdd(aDados,{STOD(AKD_DATA), AKD_HIST, AKD_TPSALD, SALDO_OR, SALDO_ME, SALDO_EM, SALDO_RE, SALDO_PG,SALDO_OR-SALDO_ME-SALDO_EM-SALDO_RE-SALDO_PG})
	AAdd(aDados,{STOD(AKD_DATA),AKD_HIST,AKD_TPSALD, SALDO_OR, SALDO_RE,AKD_LOTE,AKD_ID})
	aRegTot[4]	+=	SALDO_OR
	//aRegTot[5]	+=	SALDO_ME //SALDO_PR
	//aRegTot[6]	+=	SALDO_EM
	//aRegTot[7]	+=	SALDO_RE
	aRegTot[5]	+=	SALDO_RE
//	aRegTot[8]	+=	SALDO_PG
//  aRegTot[9]	+=	SALDO_OR-SALDO_ME-SALDO_EM-SALDO_RE-SALDO_PG
//	aRegTot[6]	+=	SALDO_OR - SALDO_RE
	DbSkip()
Enddo	                     
//aRegTot2[8]	:=	aRegTot[4]-(aRegTot[5]+aRegTot[6]+aRegTot[7]+aRegTot[8])
  aRegTot2[5]	:=	aRegTot[4]-(aRegTot[5])
DbCloseArea()                               
DbSelectArea('AKD')
If Len(aDados) == 0                                                                                      
	AAdd(aDados,{CtoD(""), "", 	"", 0, 0, 0, 0, 0, 0})
Else
	AAdd(aDados,aRegTot)
	AAdd(aDados,aRegTot2)
Endif
//Preenche aView
For nx := 1 to Len(aDados)
	Aadd(aView,{})
	Aadd(aViewImp,{})
	For nY := 1 To Len(aDados[nX])     
		If ValType(aDados[nX][nY])=="N"
			Aadd(aView[nX], Padl(TransForm(aDados[nX][nY],"@( 999,999,999.99"),20) )
			Aadd(aViewImp[nX], aDados[nX][nY] )
		ElseIf ValType(aDados[nX][nY])=="D"
			Aadd(aView[nX]		, Dtoc(aDados[nX][nY]))
			Aadd(aViewImp[nX]	, Dtoc(aDados[nX][nY]))
		Else
			Aadd(aView[nX]		, aDados[nX][nY])
			Aadd(aViewImp[nX]	, aDados[nX][nY])
		Endif	
	Next
Next           
oView:SetArray(aView)                   
oView:nAt	:=	1
oView:bLine := { || aView[oView:nAT]}
oView:Refresh()
Return



Static Function ViewOrigem(aHeader,aView,n )

Local aArea			:= GetArea()
Local aAreaAKD		:= AKD->(GetArea())
//Local nPosID		:= AScan(aHeader,{|x| Upper(AllTrim(x[2])) == "AKD_ID"})
Local nPosLote		:= 6
Local nPosID		:= 7
Local cChave
Local aAcho			:= {}
Local aButtons		:= {}
Local aUsButtons	:= {}
Local lPCO50BUT := ExistBlock("PCO50BUT")
Local cFilOld   := ""
Local cFieldX3 := GetSX3CaChe(cCampo,"X3_AQUIVO")
DEFAULT cCampo := ""

SaveInter()

Private aTela[0][0]
Private aGets[0]
If lPCO50BUT
	If ValType( aUsButtons := ExecBlock( "PCO50BUT", .F., .F. ) ) == "A"
		AEval( aUsButtons, { |x| AAdd( aButtons, x ) } )
	EndIf
Endif

dbSelectArea("AKD")
dbSetOrder(1)
If dbSeek(xFilial()+aView[n][nPosLote]+aView[n][nPosID])
	If !Empty(AKD->AKD_CHAVE)
		dbSelectArea("AKB")
		dbSetOrder(1)
		MsSeek(xFilial()+AKD->AKD_PROCES+AKD->AKD_ITEM)
		If !Empty(AKB->AKB_ENTIDA)
			dbSelectArea(AKB->AKB_ENTIDA)
			dbSetOrder(AKB->AKB_INDICE)
			dbSeek(Substr(AKD->AKD_CHAVE,4))
			cFilOld := cFilAnt
			cFilAnt := Substr(AKD->AKD_CHAVE,4,Len(cFilAnt))			
			If !MaMakeView( AKB->AKB_ENTIDA )
				dbSelectArea("SX2")
				dbSetOrder(1)
				dbSeek(AKB->AKB_ENTIDA)
				cCadastro := AllTrim(X2NOME())+" - Visualizar"
				dbSelectArea("SX3")
				dbSetOrder(1)
				dbSeek(AKB->AKB_ENTIDA)
				While !Eof() .And. AKB->AKB_ENTIDA== cFieldX3 
					aAdd(aAcho,GetSX3CaChe(cCampo,"X3_CAMPO"))
					dbSkip()
				End
				dbSelectArea(AKB->AKB_ENTIDA)			
				IF AKB->AKB_ENTIDA == 'CV4'
//					aAdd(aButtons, {"UPDWARNING",{|| P050RAT(oGdAKD:aHeader,oGdAKD:aCols,oGdAKD:oBrowse:nAt)},STR0013,STR0014})
					aAdd(aButtons, {"UPDWARNING",{|| P050RAT()},"Rateio","Rateio"})
					
				EndIF	
				axVisual(AKB->AKB_ENTIDA,(AKB->AKB_ENTIDA)->(RecNo()),2,aAcho,,,,aButtons)
			EndIf
		EndIf
	EndIf
EndIf

cFilAnt := cFilOld

RestInter()
RestArea(aAreaAKD)
RestArea(aArea)
Return 

//STATIC FUNCTION P050RAT(aHeader,aCols) 
STATIC FUNCTION P050RAT() 

Local aArea := getArea()
Local aAcho := {}
Local cFieldX3 := GetSX3CaChe(cCampo,"X3_AQUIVO")
Default cCampo := ""



DBSELECTAREA('SE2')
DBSETORDER(16)
If DbSeek(xFilial('SE2')+xFilial('CV4')+DTOS(CV4->CV4_DTSEQ)+CV4->CV4_SEQUEN)
	MaMakeView( 'SE2' )
	dbSelectArea("SX2")
	dbSetOrder(1)
	dbSeek('SE2')
	cCadastro := AllTrim(X2NOME())+" - Visualizar"
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek('E2_ARQRAT')
	While !Eof() .And. 'SE2'== cFieldX3
		aAdd(aAcho,GetSX3CaChe(cCampo,"X3_CAMPO"))
		dbSkip()
	End
	dbSelectArea('SE2')
Endif

RestArea(aArea)

Return

