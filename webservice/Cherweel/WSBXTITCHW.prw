#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"   
#INCLUDE "topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE 'COLORS.CH'
#INCLUDE 'FILEIO.CH'
#INCLUDE 'ApWizard.ch'
#DEFINE  CR  chr(13) + chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ WSBXTITCHW ³ Autor ³ Yttalo P. Martins	³ Data ³ 24/03/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Integração dos títulos baixados no Protheus com Cherwell   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function WSBXTITCHW(nSched)

Local lEnd          := .F.
Local lExec      	:= .F.

Private cIndexName 	:= ''
Private cIndexKey  	:= ''
Private cFilter    	:= ''
Private lSched      := .F.

default nSched      := 0

lSched              := IIF(nSched==1,.T.,.F.)

U_CherSE1()

If lSched == .F.

	DbSelectArea("SE1")

Else

	RPCSetType( 03 )
	Prepare Environment EMPRESA "01" FILIAL "0201" MODULO "SIGAFIN"	

	ChkFile("SE1")
	ChkFile("SD2")
	ChkFile("SC5")
	
EndIf	


cIndexName	:= Criatrab(Nil,.F.)
//cIndexKey	:= "E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
cIndexKey	:= "E1_PORTADO+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)" //Ordem utilizada na FBD

cFilter		:= "E1_FILIAL=='"+xFilial("SE1")+"'.And. E1_XCHERWE==.T. .And. E1_XINTGBX<>'S' .And. DTOS(E1_BAIXA)<>''"

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
DbSelectArea("SE1")

DbGoTop()

If lSched == .F.
	
	lExec := .F.
	@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"
	@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
	@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg))
	@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))
	ACTIVATE DIALOG oDlg CENTERED
	
Else

	lExec := .T.
	
EndIf

If lExec == .T.

	If lSched == .F.
		Processa({|lEnd|xProcessReg()})
	Else

		U_xConOut( "###############################################################################################################" )
		U_xConOut( "## INÍCIO DA INTEGRAÇÃO DAS BAIXAS DOS TÍTULOS COM CHERWELL - U_WSBXTITCHW()- DATA: " + DtoC( Date() ) + " - HORA: " + Left( Time(), 08 ) + " ##" )
		U_xConOut( "###############################################################################################################" )
		
		xProcessReg()
		
		U_xConOut( "###############################################################################################################" )
		U_xConOut( "## FIM DA INTEGRAÇÃO DAS BAIXAS DOS TÍTULOS COM CHERWELL - U_WSBXTITCHW()- DATA: " + DtoC( Date() ) + " - HORA: " + Left( Time(), 08 ) + " ##" )
		U_xConOut( "###############################################################################################################" )
				
	EndIf

Endif

If lSched == .T.
	Reset Environment
EndIf

DbSelectArea("SE1")
RetIndex("SE1")
Ferase(cIndexName+OrdBagExt())

DbSelectArea("SE1")
Set Filter to
dbCommitAll()

Return Nil

**************************************************************************************************************************************

Static Function xProcessReg()

LOCAL aAreaSE1   := SE1->(GETAREA())
Local cLogIntTit := ""
LOCAL cTexto     := ""
LOCAL lExec2     := .F.
LOCAL	_cTemp   := "INÍCIO: " + dtoc(date()) + " - " + time() + CR+ CR

dbGoTop()
ProcRegua(RecCount())
Do While !EOF()
	
	If lSched == .F.
	
		If !Marked("E1_OK")   // VERIFICA SE ESTA FLEGAD A
			Dbskip()
			Loop
		Endif
	
		IncProc("Processando...")
	
	Else
		U_xConOut( "- U_WSBXTITCHW()- Schedule -LOG: "+cLogIntTit)			
	EndIf         
	
	aAreaSE1 := SE1->(GETAREA())
	
	cLogIntTit := ""
	//----------------------------------------------------------
	//Informa ao Cherwell que título já foi baixado no Protheus
	//----------------------------------------------------------
	BxTitCher(@cLogIntTit)
	
	_cTemp  += cLogIntTit + CR
    lExec2 := .T.
    
	RestArea(aAreaSE1)

	SE1->(dbSkip())

EndDo

_cTemp  += "FIM: " + dtoc(date()) + " - " + time() + CR
_cTexto := _cTemp

IF lExec2==.T. .AND. lSched == .F.
	U_NVRLOG(_cTexto)

ELSEIF lExec2==.F. .AND. lSched == .F.

	Aviso("AVISO","Nenhum título foi selecionado!",{"OK"})

ENDIF

Return

**********************************************************************************************************

Static Function BxTitCher(cLogIntTit)

Local aPagCher   := fStrPag() 

If Len(aPagCher) > 0

	dbSelectArea("SE5")
	SE5->(DbSetOrder(7))
	SE5->(DbSeek(xFilial("SE5")+SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)))

	U_CHEWSPAG(aPagCher[1,1], aPagCher[1,2], AllTrim(Str(SE5->E5_VALOR)), DTOC(SE5->E5_DATA), DTOC(SE5->E5_DTDISPO), aPagCher[1,3], aPagCher[1,4], @cLogIntTit)
EndIf

Return

**********************************************************************************************************

Static Function fStrPag()

Local aAreaSC5 := SC5->(GetArea())
Local aAreaSD2 := SD2->(GetArea())
Local aRet     := {}

Local cFILSD2  := xFilial("SD2")
Local cFILSC5  := xFilial("SC5")

dbSelectArea("SC5")
dbSetOrder(1)

dbSelectArea("SD2")
dbSetOrder(3)

//If dbSeek(cFILSD2+SE1->(E1_NUMNOTA+E1_SERIE+E1_CLIENTE+E1_LOJA))
If SD2->(dbSeek(cFILSD2+SE1->(E1_NUM+E1_SERIE+E1_CLIENTE+E1_LOJA)))

//						.And. SD2->D2_DOC     == SE1->E1_NUMNOTA ;

	While SD2->(!Eof()) .And. SD2->D2_FILIAL  == cFILSD2  ;
						.And. SD2->D2_DOC     == SE1->E1_NUM     ;
						.And. SD2->D2_SERIE   == SE1->E1_SERIE   ;
						.And. SD2->D2_CLIENTE == SE1->E1_CLIENTE ;
						.And. SD2->D2_LOJA    == SE1->E1_LOJA

		If SC5->(dbSeek(cFILSC5+SD2->D2_PEDIDO))
			If SC5->C5_XCHERWE
				AADD(aRet, {SC5->C5_XDELIN, SC5->C5_NUM , SD2->D2_DOC , SD2->D2_SERIE })
				Exit
			Endif
		Endif

		SD2->(dbSkip())

	End

EndIf

RestArea(aAreaSD2)
RestArea(aAreaSC5)

Return(aRet)

**************************************************************************************************

User function NVRLOG(cLog)
local _ni
Local _cMask     := "Arquivos Texto (*.TXT) |*.txt|"
local _oDlg

Private _cLog 		:= ""
PRIVATE oMainWnd
Private _cTexto := cLog

DEFINE FONT _oFont NAME "Mono AS" SIZE 5,12   //6,15
DEFINE MSDIALOG _oDlg TITLE "Log de Atualização." From 3,0 to 340,417 PIXEL OF oMainWnd
@ 5,5 GET _oMemo  VAR _cTexto MEMO SIZE 200,145 OF _oDlg PIXEL
_oMemo:bRClicked := {||AllwaysTrue()}
_oMemo:oFont:= _oFont
DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (_cFile := cGetFile(_cMask,""),If(_cFile="",.t.,MemoWrite(_cFile,_cTexto))) ENABLE OF _oDlg PIXEL //Salva e Apaga //"Salvar Como..."
DEFINE SBUTTON  FROM 153,175 TYPE 2 ACTION _oDlg:End() ENABLE OF _oDlg PIXEL //Apaga
ACTIVATE MSDIALOG _oDlg CENTER

Return



User Function CherSE1(cXNum)
aXArea := GetArea()
cQryX     := GetNextAlias()


Cqry := " SELECT E1.R_E_C_N_O_ AS RECN FROM "
Cqry += "  "+RetSQLName("SC5")+" C5, "+RetSQLName("SE1")+" E1 "
Cqry += " WHERE C5_NOTA = E1_NUM "
Cqry += " AND C5_SERIE = E1_PREFIXO " 
Cqry += " AND C5_FILIAL = E1_FILIAL "
Cqry += " AND C5_XCHERWE = 'T' "
Cqry += " AND E1_XCHERWE = 'F' "
Cqry += " AND E1_XINTGBX  <> 'S' "
Cqry += " AND E1_BAIXA = ' ' "
Cqry += " AND C5.D_E_L_E_T_ = ' '   AND E1.D_E_L_E_T_ = ' ' "

DbUseArea(.T., "TOPCONN", TCGENQRY(,, cQry), cQryX, .F., .T.)
DbSelectArea(cQryX)
(cQryX)->(DbGoTop())  
If (cQryX)->(!Eof())  
	While (cQryX)->(!Eof())  
		DbSelectArea("SE1")
		DbGoto((cQryX)->RECN)
		RecLock("SE1",.F.)
		SE1->E1_XCHERWE := .T.
		MsUnlock()       
		(cQryX)->(DbSkip())         
	EndDo
Endif                         
(cQryX)->(DbCloseArea())  

RestArea(aXArea)

Return
