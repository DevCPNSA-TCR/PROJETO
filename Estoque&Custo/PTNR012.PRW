#Include "Rwmake.Ch"
#Include "TopConn.Ch"
#Include "Tbiconn.Ch"
#Include "fileio.ch"
#Include "Protheus.Ch"
//#Include "Carralero.ch"

*****************************************************************************
*+-------------------------------------------------------------------------+*
*|Funcao      | PTNR012  | Autor | Vinicius Figueiredo                    |*
*+------------+------------------------------------------------------------+*
*|Data        | 29.01.2018                                                 |*
*+------------+------------------------------------------------------------+*
*|Descricao   | Esta rotina apresenta uma tela para preencher dados do     |*
*|            | produto e fornecedor para impressão das etiquetas avulsas  |*
*|            | de identificação dos materiais.                            |*
*+------------+------------------------------------------------------------+*
*|Alteracoes  | 														   |*
*+-------------------------------------------------------------------------+*
*****************************************************************************

User Function PTNR012()
Private cCodFor    := Space(06)
Private cCodPrd    := Space(15)
Private cDesFor    := Space(40)
Private cDesPrd    := Space(60)
Private cLoja      := Space(02)
Private cNF        := Space(09)
Private cSerie     := Space(03)
Private nQtdEmb    := 0
Private nQtdVol    := 0

SetPrvt("oDlg1","oGrp1","oSProduto","oGCodPrd","oGDesPrd","oBtnImp","oBtnSai","oGrp2","oSFornecedor")
SetPrvt("oGCodFor","oGDesFor","oGLoja","oGrp3","oSSerie","oSNF","oGSerie","oGNF","oGrp4","oSVolume","oSQtdEmb")
SetPrvt("oGQtdEmb")

oDlg1      := TDialog():New(184,401,530,1050,"Impressão de Etiquetas Avulsas",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

oGrp1      := TGroup():New( 004,004,036,324,"  Dados do Produto  ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSProduto  := TSay():New( 018,029,{||"Código"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,019,008)
oGCodPrd   := TGet():New( 017,050,{|u| If(PCount()>0,cCodPrd:=u,cCodPrd)},oGrp1,039,008,'',{||fSeekPrd()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cCodPrd",,)
oGDesPrd   := TGet():New( 017,091,{|u| If(PCount()>0,cDesPrd:=u,cDesPrd)},oGrp1,220,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDesPrd",,)

oGrp2      := TGroup():New( 040,004,096,324,"  Dados do Fornecedor   ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSForneced := TSay():New( 060,020,{||"Fornecedor"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
oSay2      := TSay():New( 076,037,{||"Loja"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,012,008)
oGCodFor   := TGet():New( 058,049,{|u| If(PCount()>0,cCodFor:=u,cCodFor)},oGrp2,039,008,'',{||fSeekFor()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2","cCodFor",,)
oGLoja     := TGet():New( 075,049,{|u| If(PCount()>0,cLoja:=u,cLoja)},oGrp2,012,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cLoja",,)
oGDesFor   := TGet():New( 075,064,{|u| If(PCount()>0,cDesFor:=u,cDesFor)},oGrp2,249,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDesFor",,)

oGrp3      := TGroup():New( 100,004,156,163,"   Informações da Nota Fiscal   ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSNF       := TSay():New( 119,024,{||"Número"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,021,008)
oSSerie    := TSay():New( 138,032,{||"Serie"},oGrp3,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,014,008)
oGNF       := TGet():New( 118,048,{|u| If(PCount()>0,cNF:=u,cNF)},oGrp3,039,008,'',{||fSeekSNF()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SF1","cNF",,)
oGSerie    := TGet():New( 136,048,{|u| If(PCount()>0,cSerie:=u,cSerie)},oGrp3,027,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cSerie",,)

oGrp4      := TGroup():New( 100,165,156,324,"  Dados de Volume   ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSVolume   := TSay():New( 119,191,{||"Qtd de Volumes"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,038,008)
oSQtdEmb   := TSay():New( 138,191,{||"Qtd. Embalagem"},oGrp4,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oGQtdVol   := TGet():New( 118,235,{|u| If(PCount()>0,nQtdVol:=u,nQtdVol)},oGrp4,047,008,'@E 99999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nQtdVol",,)
oGQtdEmb   := TGet():New( 136,235,{|u| If(PCount()>0,nQtdEmb:=u,nQtdEmb)},oGrp4,047,008,'@E 99999',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nQtdEmb",,)

oBtnImp    := TButton():New( 159,286,"&Imprimir",oDlg1,{||fImprime()},037,012,,,,.T.,,"",,,,.F. )
oBtnSai    := TButton():New( 159,236,"&Sair",oDlg1,{||oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )

oDlg1:lEscClose := .F.

oDlg1:Activate(,,,.T.)

Return  

*-------------------------*
Static Function fImprime()
*-------------------------*
SD1->( dbSetOrder(2) )
SD1->( dbGoTop() )

If !SD1->( MsSeek( xFilial("SD1") + cCodPrd + cNF + cSerie + cCodFor + cLoja ) )
	
	Alert("Produto informado não foi encontrado para a Nota Fiscal correspondente")
	Return(.F.)
	
Else
	
	cDesPrd := Alltrim(Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_DESC"))
	
	If Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_TIPO") $ "MO/AD"
		Alert("Tipo de Produto não permitido para impressão de etiquetas")
		Return(.F.)
	Endif
	
	If SD1->D1_XIMPLBL == "S"
		If !MsgYesNo("As etiquetas para o produto "+Alltrim(SD1->D1_COD)+" - "+cDesPrd+" já foram impressas. Deseja imprimi-las novamente?","Aviso do Sistema")
			Return(.F.)
		Endif
	Endif
	
	Processa( {||U_PrtLbl(nQtdEmb,nQtdVol)},"Impressão de Etiquetas",,.T.)
	
	RecLock("SD1",.F.)
	D1_XIMPLBL := "S"
	MsUnlock()
	
Endif

cCodFor := Space(06)
cCodPrd := Space(15)
cDesFor := Space(40)
cDesPrd := Space(60)
cLoja   := Space(02)
cNF     := Space(09)
cSerie  := Space(03)
nQtdEmb := 0
nQtdVol := 0

oGCodPrd:Refresh()
oGDesPrd:Refresh()
oGCodFor:Refresh()
oGDesFor:Refresh()
oGLoja:Refresh()
oGNF:Refresh()
oGSerie:Refresh()
oGQtdVol:Refresh()
oGQtdEmb:Refresh()

//	oGCodPrd:SetFocus()

Return 

*-------------------------*
Static Function fSeekPrd()
*-------------------------*
cDesPrd := Posicione("SB1",1,xFilial("SB1")+cCodPrd,"B1_DESC")

oGDesPrd:Refresh()
//	oGCodFor:SetFocus()

Return       

*-------------------------*
Static Function fSeekFor()
*-------------------------*
cLoja   := Posicione("SA2",1,xFilial("SA2")+cCodFor,"A2_LOJA")
cDesFor := Posicione("SA2",1,xFilial("SA2")+cCodFor+cLoja,"A2_NOME")

oGLoja:Refresh()
oGDesFor:Refresh()
//	oGNF:SetFocus()

Return   

*-------------------------*
Static Function fSeekSNF()
*-------------------------*
cSerie := Posicione("SF1",2,xFilial("SF1")+cCodFor+cLoja+cNF,"F1_SERIE")

oGSerie:Refresh()
oGQtdVol:SetFocus()

Return



*------------------------------------*
User Function PrtLbl(nQtdEmb,nNumLbl)
*------------------------------------*

Local cDescProd := ""
Local cPartNumb := ""
Local cEndProd  := ""
Local nPrEntreg	:= 0
Local nEmin		:= 0
Local nEMax		:= 0
Local nX		:= 0

Local cPorta := "LPT1"
Local nLin

//Posicionar no produto
DbSelectArea("SB1")
DbSetOrder(1)
If DbSeek(xFilial("SB1")+SD1->D1_COD)
	cDescProd 	:= B1_DESC
	cPartNumb 	:= "" //B1_XPARTNU
	cEndProd  	:= "" //B1_XENDERE
	nPrEntreg 	:= B1_PE
	nEmin		:= B1_EMIN
	nEMax		:= B1_EMAX
	
Endif


MSCBPRINTER("ZM400",cPorta,Nil,,.F.,,,,,,.T.)

For nX:= 1 To nNumLbl
	
	cCodBar := Alltrim(SD1->D1_COD)+SD1->D1_FORNECE+Alltrim(SD1->D1_DOC)+Alltrim(Str(nX))+Alltrim(Str(nQtdEmb))
	cEndProd := SD1->D1_LOCAL
	
	nLin := 02
	
	MSCBINFOETI("IDENTIFICAÇÃO DE MATERIAIS","Almoxarifado")
	MSCBBEGIN(1,4)
	
	// Monta Box Etiqueta
	MSCBBOX(04,04,138,63)
	// Monta linhas horizontais
	MSCBLineH(04,10,138)
	MSCBLineH(04,16,138)
	
	MSCBLineH(04,25,138)//MSCBLineH(04,27,138)
	MSCBLineH(04,32,138)//MSCBLineH(04,33,138)
	MSCBLineH(04,38,138)
	
	MSCBLineH(04,44,138)
	MSCBLineH(04,50,138)
	MSCBLineH(04,63,138)
	
	// Monta linha verticais
	MSCBLineV(045,04,25)
	
	MSCBLineV(018,32,44)
	MSCBLineV(036,32,44)
	MSCBLineV(049,32,44)
	MSCBLineV(070,32,44)
	MSCBLineV(088,32,44)
	MSCBLineV(106,32,44)
	
	
	MSCBLineV(035,44,63)
	MSCBLineV(058,44,63)
	MSCBLineV(080,44,63)
	MSCBLineV(104,44,63)
	
	// Titulos
	MSCBSAY(015,06, "CPN" 			           ,"N","0","030,030")  //007/06
	MSCBSAY(058,06, "IDENTIFICACAO DE MATERIAIS","N","0","030,030")
	MSCBSAY(015,12, "CODIGO"                    ,"N","0","028,030")
	MSCBSAY(079,12, "DESCRICAO"                 ,"N","0","028,030")
	MSCBSAY(007,27, "PART NUMBER : "            ,"N","0","028,030")
	
	MSCBSAY(006,34, "VOL."                      ,"N","0","028,030")
	MSCBSAY(020,34, "Q.VOL."                    ,"N","0","028,030")
	MSCBSAY(038,34, "UNID."                     ,"N","0","028,030")
	MSCBSAY(051,34, "Q.EMB."                    ,"N","0","028,030")
	
	MSCBSAY(072,34, "P.PED."                    ,"N","0","028,030")
	MSCBSAY(090,34, "E.MAX."                    ,"N","0","028,030")
	//        MSCBSAY(110,34, "PR.ENTREG."                ,"N","0","028,030")
	MSCBSAY(110,34, "DT. DIGIT."                ,"N","0","028,030")
	
	
	
	MSCBSAY(006,46, "NOTA FISCAL"               ,"N","0","028,030")
	MSCBSAY(037,46, "DATA NF"                   ,"N","0","028,030")
	MSCBSAY(060,46, "FORNEC."                   ,"N","0","028,030")
	MSCBSAY(083,46, "PEDIDO"                    ,"N","0","028,030")
	MSCBSAY(109,46, "ENDERECO"                  ,"N","0","028,030")
	
	// Imprime dados do produto
	
	MSCBSAY(007,19, Alltrim(SD1->D1_COD)        ,"N","0","028,030") //014,19
	MSCBSAY(046,19, Alltrim(cDescProd)          ,"N","0","028,030")
	
	MSCBSAY(046,27, Alltrim(cPartNumb)          ,"N","0","028,030")
	
	MSCBSAY(006,40, Alltrim(Str(nX))            ,"N","0","025,030")
	MSCBSAY(020,40, Alltrim(Str(nNumLbl))       ,"N","0","025,030")
	MSCBSAY(038,40, Alltrim(SD1->D1_UM)         ,"N","0","025,030")
	MSCBSAY(051,40, Alltrim(Str(nQtdEmb))       ,"N","0","025,030")
	MSCBSAY(072,40, Alltrim(Str(nEmin))       	,"N","0","025,030")
	MSCBSAY(090,40, Alltrim(Str(nEMax))       	,"N","0","025,030")
	//MSCBSAY(110,40, Alltrim(Str(nPrEntreg))   	,"N","0","025,030")
	MSCBSAY(110,40, DToC(SD1->D1_DTDIGIT)   	,"N","0","025,030")
	
	MSCBSAY(009,53, Alltrim(SD1->D1_DOC)        ,"N","0","028,030")
	MSCBSAY(036,53, DToC(SD1->D1_EMISSAO)       ,"N","0","028,030")
	MSCBSAY(062,53, SD1->D1_FORNECE             ,"N","0","028,030")
	MSCBSAY(085,53, SD1->D1_PEDIDO              ,"N","0","028,030")
	MSCBSAY(110,53, Alltrim(cEndProd)           ,"N","0","028,030")
	
	
	MSCBSAYBAR(08,67,cCodBar,"N","MB07",13,.F.,.T.,,,2,1,,,,.F.,) // (CODE 128) //17,67
	
	MSCBEND()
	
Next nX

MSCBCLOSEPRINTER()

Return
