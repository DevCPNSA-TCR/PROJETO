#Include "PROTHEUS.CH"
#INCLUDE "PTNGPEM580.CH"
#INCLUDE "TopConn.ch"
#include 'ap5mail.ch' 
#include 'fwprintsetup.ch'  
#INCLUDE "RPTDEF.CH"        
#Include "ParmType.ch" 
#INCLUDE 'FILEIO.CH' 

Static lUsaRRA 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ?PTNGPEM580  ?Autor ?Yttalo P. Martins     ?Data ?09.12.14   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ?INFORME DE RENDIMENTOS EM PDF e ENVIO POR E-MAIL                ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ?BASEADO na GPEM580(void)                                        ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros?                                                                ³±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?*/

//u_PTNGPEM580(.F., "0101", "000361", "2017")
User Function PTNGPEM580(lTerminal, cFilTerminal, cMatTerminal, cAnoTerminal, lPortal)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Define Variaveis Locais (Basicas)                            ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1  	:= STR0001 //"Informe de Rendimentos"
Local cDesc2  	:= STR0002 //"Ser?impresso de acordo com os parametros solicitados pelo"
Local cDesc3  	:= STR0003 //"usuario."
Local cString 	:= "SRL"   // alias do arquivo principal (Base)
Local aOrd    	:= {"Matricula","C.G.C.","Centro de Custo","Beneficiario","Departamento"} //"Matricula"###"C.G.C.###Centro de Custo"###"Beneficiario###Departamento"
Local aRegs	  	:= {}
Local aArea		:= GetArea()	
Local cHtml 	:= ""
Local wnRel     := "Informe de Rendimento por E-mail"
Local cUser       := ""
Local aDifs       := {} 

//Se acesso for proveniente do Portal de Gestao do Capital Humano lPortal == .T. demais acesso lPortal == .F.
Default lPortal	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Define Variaveis Private(Basicas)                            ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn 	:= { STR0006 , 1, STR0007, 2, 2, 1, "",1 } //"Branco"###"Administra‡„o"
Private nomeprog	:= "PTNGPEM580"
Private aLinha  	:= { }
Private nLastKey	:= 0
Private cPerg		:= "PTNGPEM580"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Define Variaveis Private(Programa)                           ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nOrdem
Private aInfo	:={}
Private cAno
Private nPessoa := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Variaveis Utilizadas na funcao IMPR                          ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Titulo   := "Informe de Rendimento por E-mail"//STR0008 //" RELA€O DO INFORME RENDIMENTO "
Private AT_PRG   := "PTNGPEM580"
Private COLUNAS  := 80
Private nTamanho := "P"

//Objetos p/ Impresssao Grafica 
Private oFont07
Private oFont08
Private oFont10
Private oFont14
Private oFont15
Private oFont10n
Private oFont21
Private oFont12
Private oFont16
Private oPrint
Private lFirst	:= .F.

Private cPath    := "c:\temp\"
Private cSubPath := "Informe_Rendimento\"
Private aHtm := {}
Private aERR := {}
Private cXLog := ""
Private cELog := ""
Private cLastProc := ""

Private aUser     :={}  
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
//Private _cFrom      := "informerh@portonovosa.com.br" //Email específico e-mail configurado no hostgator. 07/03/2018
Private _cFrom      := _cUser  //  alteração fabio 01/02/2021 - office 365.

Private _cTo        := "" //
Private _cCC        := ""                             		// 
Private _cBCC       := ""                            	   // 
Private _cSubject   := "Informe de Rendimento " //

Private cEmp
private cCNPJ 
Private cyear
Private cMes
Private nHdl

DbSelectArea("SM0")      
DbSetOrder(1)
DbSeek(cEmpAnt+cFilAnt)

cEmp := SM0->M0_NOMECOM
cCNPJ := SM0->M0_CGC    

lUsaRRA:= If(FindFunction( "fUsaRRA" ),fUsaRRA(),.F.)

//Se proveniente do Portal do Gestao do Capital Humano, posiciona no SRA do funcionario 
If lPortal
dbSelectArea('SRA')
SRA->( dbSeek(cFilTerminal+cMatTerminal) )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Verifica se o programa foi chamado do terminal - TCF         ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lTerminal := If( lTerminal == Nil, .F., lTerminal )

oFont07	:= TFont():New("Arial",07,07,,.F.,,,,.T.,.F.)
oFont08	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)		//negrito 
oFont10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont10n:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont12	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)		//Normal s/negrito
oFont12n:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)		//Negrito
oFont13n:= TFont():New("Arial",13,13,,.T.,,,,.T.,.F.)		//Negrito
oFont13 := TFont():New("Arial",13,13,,.F.,,,,.T.,.F.)		//Negrito
oFont14	:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)
oFont15	:= TFont():New("Arial",15,15,,.T.,,,,.T.,.F.)
oFont21 := TFont():New("Arial",21,21,,.T.,,,,.T.,.T.)
oFont16	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica a existencia do campo "ANO" na tabela SR4 e verifica se?
//³ele esta preenchido. Se nao estiver preenchido significa que    ?
//³nao foi gerada nenhuma DIRF desde as alteracoes para 2006.      ?
//³Desta forma e necessario limpar as tabelas SRL e SRL antes da   ?
//³primeira geracao. Para as proximas geracoes nao sera mais neces-?
//³sario fazer a limpeza, pois as mesmas guardaram os historicos.  ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SR4" )
If SR4->( fieldpos("R4_ANO"))== 0 
	If ! lPortal
		Aviso(STR0014,STR0015,{"OK"}) //"Atencao"#"Tabelas desatualizadas. Execute o atualizador"
	Else
		cHtml	:= "<h2>"+STR0014+"</h2><p>"+STR0015+"</p>"
	EndIf
	Return( 	IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
EndIf    

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
?Valida necessidade de execucao do update para criar novos ?
?campos para a DIRF 2012.	   								?
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If !fValBenNIF()
	If lPortal
		cHtml	:= "<h2>"+STR0014+"</h2><p>"+STR0017+"</p>"
	EndIf
	Return( 	IF( lTerminal <> NIL .And. lTerminal , cHtml , NIL ) )
EndIf
*/
AjustaSx1()

If !pergunte(cPerg,.T.)
	Return
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//?Variaveis utilizadas para parametros                          ?
//?mv_par01        //  Filial  De                                ?
//?mv_par02        //  Filial  Ate                               ?
//?mv_par03        //  C.G.C. De                                 ?
//?mv_par04        //  C.G.C. Ate                                ?
//?mv_par05        //  Matricula De                              ?
//?mv_par06        //  Matricula Ate                             ?
//?mv_par07        //  Imprime p/quem nao teve Retencao          ?
//?mv_par08        //  Ano Base                                  ?
//?mv_par09        //  Nome Responsavel                          ?
//?mv_par10        //  Centro de Custo de                        ?
//?mv_par11        //  Centro de Custo Ate                       ?
//?mv_par12        //  Tipo de Formulario (Pre-impresso/Grafico) ?
//?mv_par13        //  Categoria                                 ?
//?mv_par14        //  Situacao                                  ?
//?mv_par15        //  Pessoa Fisica/Juridica                    ?
//?mv_par16        //  Departamento De                           ?
//?mv_par17        //  Departamento Ate                          ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Carregando variaveis mv_par?? para Variaveis do Sistema.     ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilDe		:= IF( !( lTerminal ), mv_par01, IF(lPortal, cFilTerminal, "  ") ) // Filial De
cFilAte  	:= IF( !( lTerminal ), mv_par02, IF(lPortal, cFilTerminal, "ZZ") ) // Filial Ate
cCNPJDe		:= mv_par03
cCNPJAte	:= mv_par04
cMatDe		:= IF( !( lTerminal ), mv_par05, IF(lPortal, cMatTerminal, "      ") )
cMatAte		:= IF( !( lTerminal ), mv_par06, IF(lPortal, cMatTerminal, "999999") )
cIRRetido 	:= IF( !( lTerminal ), mv_par07, 2 )
cAno 		:= If( !( lTerminal ), mv_par08, cAnoTerminal )
cNomeResp 	:= If( !( lTerminal ), mv_par09, cNomeResp )
cCCDe	 	:= IF( !( lTerminal ), mv_par10, SRA->RA_CC	)	//Centro de Custo De
cCCAte		:= IF( !( lTerminal ), mv_par11, SRA->RA_CC	)	//Centro de Custo Ate

nTipRel		:= 2//IF( !( lTerminal ), mv_par12 , 3         )			//Tipo de Formulario (Pre-impresso/Grafico)

cCategoria	:= IF( !( lTerminal ), mv_par13, fCategoria( NIL , .F. ))	//Categorias a Imprimir
cSituacao	:= IF( !( lTerminal ), mv_par14, fSituacao( NIL , .F. ) )	//Situacoes a Imprimir
nPessoa 	:= 1//MV_PAR15
cDeptoDe	:= IF( !( lTerminal ), mv_par16, TamSX3("RA_DEPTO")[1]	)// Departamento De
cDeptoAte	:= IF( !( lTerminal ), mv_par17, TamSX3("RA_DEPTO")[1]	)// Departamento Ate

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//?Se o ano for >= 2016 | Verifica se existe tabela SM8 e SM9
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
If cAno >= "2016"
	dbSelectArea( "SM8" )
	If SM8->( fieldpos("M8_ANO"))== 0 
		Aviso(STR0014,STR0015,{"OK"}) //"Atencao"#"Tabelas desatualizadas. Execute o atualizador"
		Return()
	EndIf    



	dbSelectArea( "SM9" )
	If SM9->( fieldpos("M9_ANO"))== 0 
		Aviso(STR0014,STR0015,{"OK"}) //"Atencao"#"Tabelas desatualizadas. Execute o atualizador"
		Return()
	EndIf    
Endif
_csubject += " de "+MV_PAR08

/*
If nTipRel == 2
	If !lFirst
		lFirst	:= .T.
		//oPrint 	:= TMSPrinter():New(STR0016) //"COMPROVANTE DE RENDIMENTOS PAGOS E DE RETENCAO DE IRPF"
		oPrint := FWMSPrinter():New(STR0016, IMP_PDF, lAdjustToLegacy)
		oPrint:SetPortrait()
		oPrint:SetPaperSize(DMPAPER_A4) 
	Endif
Endif	
*/
cXLog += "Data "+DToC(Date())+CRLF
cXLog += "Hora Inicio "+Time()+CRLF	
cXLog += "Ano "+MV_PAR08+CRLF+CRLF
	
IF nTipRel==3
	IF lTerminal
		cHtml := GM580Imp(.F.,wnRel,cString, lTerminal, lPortal)
	EndIF
Else
	RptStatus({|lEnd| GM580Imp(@lEnd,wnRel,cString,lTerminal, lPortal)},Titulo)
EndIF

aFiles := {}
aSizes := {}

ADir(cpath+cSubPath+"INFORME_*.pdf", aFiles, aSizes)	

/*
for n_w := 1 to len(aFiles)
	FErase(cpath+cSubPath+aFiles[n_w])	
Next n_w
*/
                                                                
CtIM := tIME()
Memowrite(cpath+cSubPath+"Log_InformeMail_"+MV_PAR08+"_"+Replace(DToC(Date()),"/","")+"_"+Replace(cTim,":","")+".txt",(cXLog+CRLF+cELog+CRLF+"Hora Fim "+cTim+CRLF	))

Alert("O arquivo de log encontra-se no caminho:"+cpath+cSubPath+" , esse deve ser copiado e guardado como comprovante de envio dos informes de rendimento.")	
	
/*
If nTipRel == 2
	oPrint:Preview()  		// Visualiza impressao grafica antes de imprimir
Endif
*/
RestArea( aArea )
Return( IF( lTerminal , cHtml , NIL ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±³Fun‡…o    ?GM580IMP ?Autor ?R.H. - Marcos Stiefano?Data ?30.11.95 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±?
±±³Descri‡…o ?Relatorio da D.I.R.F.                                      ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Sintaxe   ?GM580IMP(lEnd,WnRel,cString)                               ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Parametros?lEnd        - A‡Æo do Codelock                             ³±?
±±?         ?wnRel       - T¡tulo do relat¢rio                          ³±?
±±³Parametros?cString     - Mensagem                                     ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±?Uso      ?Generico                                                   ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GM580Imp(lEnd,WnRel,cString, lTerminal, lPortal)
Local aCPFCGC 	:= {} //CPFCGC do contribuinte
Local cArqSR4	:= ""
Local cArqRCS	:= ""
Local cCpfComp  := ""
Local cFiltro   := aReturn[7]
Local cHtml 	:= ""  
Local nPos		:= 0 
Local nQtdeHtml	:= 0   
Local xCGC		:= ""
Local cQry		:= ""
Local cAliasSRL	:= "SRL"
Local cTmpSR4	:= ""
Local lTemOut	:= .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Carregando variaveis mv_par?? para Variaveis do Sistema.     ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCategoria 	:= MV_PAR13
Private cSituacao 	:= MV_PAR14
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Variaveis de Acesso do Usuario                               ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cAcessaSRL	:= ""
If !Empty(cFiltro)
	cAcessaSRL	:= &( " { || " + ChkRH( "GPEM580" , "SRL" , "2" ) +  " .And. " + cFiltro + " } " ) 
Else
	cAcessaSRL	:= &( " { || " + ChkRH( "GPEM580" , "SRL" , "2" ) +  " } " ) 
EndIf
Private cAcessaSR4	:= &( " { || " + ChkRH( "GPEM580" , "SR4" , "2" ) + " } " )
Private cAcessaRCS	:= &( " { || " + ChkRH( "GPEM580" , "RCS" , "2" ) + " } " )
Private cAcessaSM8	:= &( " { || " + ChkRH( "GPEM580" , "SM8" , "2" ) + " } " )
Private cAcessaSM9	:= &( " { || " + ChkRH( "GPEM580" , "SM9" , "2" ) + " } " )
Private cCodPLR   	:= "3562"
Private cNomeBen	:= ""

Private lIndSR4 := .F.
Private lIndRCS	:= .F.

Private cNomeTxt := ""
PRIVATE cArqTxt := ""
PRIVATE cInfoTxt := ""

cNomeTxt := Replace("INFORME_"+Dtos(Date())+"_"+StrTran(time(),":") ," ","")

MakeDir (cPath)
MakeDir (cPath+cSubPath) 	    

cArqTxt := cPath+cSubPath+cNomeTxt

If File(cArqTxt)
	FErase(cArqTxt)
Endif 
/*
nHdl := FCreate(cArqTxt)
If nHdl == -1
   MsgAlert("O arquivo "+cArqTxt+" nao pode ser criado! Verifique os parametros.","Atencao !")
   Return
Else
	fClose(nHdl)
Endif
*/

nOrdem 		:= 1//aReturn[8]
cResponsa	:= If(!empty(cNomeResp),cNomeResp,space(30))
cArqSRL		:= ""
           
If lTerminal //Execucao via Portal RH Online
	xCGC 	:= SRA->RA_CIC
EndIf
dbSelectArea ("SRL")
If SRL->(FieldPos("RL_CC"))== 0 .or. lTerminal
	nOrdem := 1
EndIf	

if nOrdem <> 3 .AND. nOrdem <> 4 .AND. nOrdem <> 5
	dbSetOrder(nOrdem)
EndIf	

If nOrdem == 1
	dbSeek(cFilDe + cMatDe,.T.)
	cInicio  := "SRL->RL_Filial + SRL->RL_MAT"
	If lTerminal
		cFim     := cFilAte + SRA->RA_MAT	
	Else 
		cFim     := cFilAte + cMatAte
    Endif
ElseIf nOrdem == 2
	dbSetOrder(2)
	dbSeek(cFilDe + cCnpjDe ,.T.)
	cInicio  := "SRL->RL_FILIAL + SRL->RL_CGCFONT"
	cFim     := cFilAte + cCNPJAte
ElseIf nOrdem == 3
	cArqSRL := criatrab("",.F.)
	IndRegua("SRL",cArqSRL,"RL_FILIAL + RL_CC",,,STR0012) //"Selecionando Registros..."
	nIndex 	:= RetIndex("SRL")
	#IFNDEF TOP
	dbSetIndex(cArqSRL+OrdBagExt())
	#ENDIF	
	dbSetOrder(nIndex+1)
	dbSeek(cFilDe+cCCDe,.T.)
	cInicio  := "SRL->RL_FILIAL + SRL->RL_CC"
	cFim     := cFilAte + cCCAte
ElseIf nOrdem == 4
	cArqSRL := criatrab("",.F.)
	IndRegua("SRL",cArqSRL,"RL_FILIAL + RL_BENEFIC",,,STR0012) //"Selecionando Registros..."
	nIndex 	:= RetIndex("SRL")
	#IFNDEF TOP
	dbSetIndex(cArqSRL+OrdBagExt())
	#ENDIF	
	dbSetOrder(nIndex+1)
	dbSeek(cFilDe,.T.)
	cInicio  := "SRL->RL_FILIAL "
	cFim     := cFilAte 
ElseIf nOrdem == 5
	cArqSRL := criatrab("",.F.)
	IndRegua("SRL",cArqSRL,"RL_FILIAL + RL_DEPTO",,,STR0012) //"Selecionando Registros..."
	nIndex 	:= RetIndex("SRL")
	#IFNDEF TOP
	dbSetIndex(cArqSRL+OrdBagExt())
	#ENDIF	
	dbSetOrder(nIndex+1)
	dbSeek(cFilDe+cDeptoDe,.T.)
	cInicio  := "SRL->RL_FILIAL + SRL->RL_DEPTO"
	cFim     := cFilAte + cDeptoAte
Endif

If ! lTerminal
	If nPessoa == 1
		dbSelectArea ( "SR4" )
		nOrdem := RetOrder( "SR4" , "R4_ANO+R4_CPFCGC+R4_CODRET+R4_MES" , .T. )
		If  nOrdem == 0	
			cArqSR4 := criatrab("",.F.)
			IndRegua("SR4",cArqSR4,"R4_ANO+R4_CPFCGC+R4_CODRET+R4_MES",,,STR0012) //"Selecionando Registros..."
			nIndex 	:= RetIndex("SR4")
			#IFNDEF TOP
			dbSetIndex(cArqSR4+OrdBagExt())
			#ENDIF	
			SR4->( dbSetOrder(nIndex+1))
		Else
			SR4->( dbSetOrder( nOrdem )	)
	    EndIf
	    
		dbSelectArea ("RCS")                                  
		nOrdem := RetOrder( "RCS", "RCS_ANO+RCS_CPFBEN+RCS_CODRET", .T. )
		If nOrdem == 0
			cArqRCS := criatrab("",.F.)
			IndRegua("RCS",cArqRCS,"RCS_ANO+RCS_CPFBEN+RCS_CODRET",,,STR0012) //"Selecionando Registros..."
			nIndex 	:= RetIndex("RCS")
			#IFNDEF TOP
			dbSetIndex(cArqRCS+OrdBagExt())
			#ENDIF	
			RCS->( dbSetOrder(nIndex+1))
	    Else
			RCS->( dbSetOrder(nOrdem) )
	    EndIf
	EndIf
Else
	dbSelectArea ( "SR4" )
	nOrdem := RetOrder( "SR4" , "R4_ANO+R4_CPFCGC+R4_CODRET+R4_MES" , .T. )
	If nOrdem # 0 
		lIndSR4 := .T.
		SR4->( dbSetOrder(nOrdem) )
	EndIF
	
	dbSelectArea ("RCS")
	nOrdem := RetOrder( "RCS" , "RCS_ANO+RCS_CPFBEN+RCS_CODRET" , .T. )
	If nOrdem # 0
		lIndRCS := .T.
		RCS->( dbSetOrder(nOrdem) )
	EndIf
EndIf

dbSelectArea("SRL")

cFilAnterior := Replicate("!", FWGETTAMFILIAL)

dbSelectArea("SRL")

IF !( lTerminal )
	SetRegua(SRL->(RecCount()))
EndIf

If lTerminal
	cCpfComp := SRA->RA_CIC	
Endif

#IFDEF TOP
	IF lTerminal
		cAliasSRL := GetNextAlias()
		cQry := "SELECT RL_FILIAL,RL_MAT,RL_TIPOFJ,RL_CPFCGC,RL_CODRET,RL_CGCFONT, R_E_C_N_O_ FROM " + RetSQLName("SRL")
		cQry += " WHERE D_E_L_E_T_ = ' ' AND RL_CPFCGC = '" + cCpfComp + "' "
		cQry := ChangeQuery(cQry)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),cAliasSRL,.F., .T.)
	EndIf
#ENDIF
While SRL->( !Eof() ) .And. &cInicio <= cFim
	If SRL->RL_Filial # cFilAnterior
		cFilAnterior := SRL->RL_FILIAL
		fInfo(@aInfo,cFilAnterior)
		IF lTerminal .And. RHX->(dbseek(xFilial("RHX",(cAliasSRL)->RL_FILIAL)+cAno))
			cResponsa := RHX->RHX_RESPON
		EndIf
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//?Descarta pessoas Juridicas na impressao via Terminal         ?
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	IF lTerminal .And. AllTrim( SRL->RL_TIPOFJ ) == "2"
		SRL->(dbSkip())
		Loop
	EndIf
	
	IF lTerminal 
		If AllTrim(SRL->RL_CPFCGC) != AllTrim(cCpfComp)
			SRL->(dbSkip())
			Loop
		Endif	
	EndIf      
	
	If SRL->RL_CODRET == cCodPLR//"3562"
		cTmpSR4 := GetNextAlias()
		lTemOut := .F.
		
		BeginSql Alias cTmpSR4
			SELECT	R4_ANO, R4_CPFCGC, R4_CODRET, R4_MES, SUM( R4_VALOR ) AS R4_VALOR 
			FROM	%Table:SR4%  
			WHERE	R4_CPFCGC	= %Exp:( ( cAliasSRL )->RL_CPFCGC )%
				AND	R4_CODRET	<> "3562" 
				AND	R4_ANO		= %Exp:( cAno )%
				AND	%NotDel%
			GROUP BY R4_ANO, R4_CPFCGC, R4_CODRET, R4_MES
			ORDER BY R4_ANO, R4_CPFCGC, R4_CODRET, R4_MES
		EndSql
		
		While ( cTmpSR4 )->( !Eof() )
			If ( cTmpSR4 )->R4_VALOR > 0
				lTemOut := .T.
				Exit
			EndIf
			
			( cTmpSR4 )->( dbSkip() )
		EndDo
		
		( cTmpSR4 )->( dbCloseArea() )
	
		If lTemOut
			( cAliasSRL )->( dbSkip() )

			Loop	
		EndIf //SRL->(dbSkip()) //Loop			
	EndIf
	
	If Empty( SRA->RA_NOMECMP )
		cNomeBen := SRA->RA_NOME
	Else
		cNomeBen := SRA->RA_NOMECMP
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//?Movimenta Regua Processamento                                ?
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !( lTerminal )
		IncRegua()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//?Verifica se existem dados na SR4 para esta matricula, caso   ?
		//?contrario, pela para o proximo registro da SRL.              ?	
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nIndex := SR4->( IndexOrd() )
		nOrdem := RetOrder( "SR4",	"R4_FILIAL+R4_MAT+R4_CPFCGC+R4_CODRET+R4_ANO+R4_MES+R4_TIPOREN+R4_PAIS+R4_NIFEX", .T. )
		SR4->( dbSetOrder(nOrdem) )
		If !(SR4->( dbSeek(SRL->RL_FILIAL+SRL->RL_MAT+SRL->RL_CPFCGC+SRL->RL_CODRET+cAno)))
			If cAno < "2013" .Or. ( cAno >= "2013" .And. !( SR4->( dbSeek( SRL->RL_FILIAL+SRL->RL_MAT+SRL->RL_CPFCGC+cCodPLR+cAno ) ) ) )
				SR4->( dbSetOrder(nIndex) ) 
				dbSelectArea ( "SRL" )
				SRL->(dbSkip())
				Loop
			EndIf
		Endif		
		SR4->( dbSetOrder(nIndex) )    
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//?Consiste controle de acessos e filiais validas               
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(SRL->RL_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRL)
			SRL->(dbSkip())
			Loop
		EndIf

		If lEnd
			@Prow()+1,0 PSAY cCancel
			Exit
	    Endif
	
		If SRA->( dbSeek(SRL->RL_FILIAL+SRL->RL_MAT))
			If !(ChkSituacao(.F.,,cSituacao)) .Or. !(SRA->RA_CATFUNC $ cCategoria)
				dbSelectArea ( "SRL" )
				SRL->(dbSkip())
				Loop
			EndIf	
		Endif
		                 
		If SRL->RL_MAT < cMatDe .OR. SRL->RL_MAT > cMatAte
			dbSelectArea ( "SRL" )
			SRL->(dbSkip())
			Loop
		Endif                                         

		If SRL->RL_CGCFONT < cCNPJDe .or. SRL->RL_CGCFONT > cCNPJAte
			dbSelectArea ( "SRL" )
			SRL->(dbSkip())
			Loop
		EndIf
	
		If SRL->(FieldPos("RL_CC")) > 0 
			If SRL->RL_CC < cCCDe .OR. SRL->RL_CC > cCCAte
				dbSelectArea ( "SRL" )
				SRL->(dbSkip())
				Loop
			EndIf	
		Endif
		
		If SRL->(FieldPos("RL_DEPTO")) > 0 
			If SRL->RL_DEPTO < cDeptoDe .OR. SRL->RL_DEPTO > cDeptoAte
				dbSelectArea ( "SRL" )
				SRL->(dbSkip())
				Loop
			EndIf	
		Endif

		If (nPessoa == 1 .and. SRL->RL_TIPOFJ == "2") .or. ;
			(nPessoa == 2 .and. SRL->RL_TIPOFJ == "1")
			SRL->(dbSkip())
			Loop
		EndIf	
   	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
	//³Guarda o CPF/CNPJ do beneficiário para não gerar mais de uma ?
	//³vez a mesma pessoa.                                          ?
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
	If nPessoa == 1 
		nPos :=  ascan(aCPFCGC,{|X|X[1]==SRL->RL_CPFCGC})
		If nPos == 0
			Aadd( aCPFCGC, {SRL->RL_CPFCGC,SRL->RL_CGCFONT,SRL->RL_CODRET})
		Else  
			If alltrim(SRL->RL_CGCFONT) == alltrim(aCPFCGC[npos,2])  .and. ;
				alltrim(SRL->RL_CODRET) == alltrim(aCPFCGC[npos,3])
				SRL->(dbSkip())
				Loop
			EndIf	
		EndIf	
    EndIf
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
	//³Na execução via portal somente serah apresentado o informe do?
	//³usuario logado.                                              ?
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
	If lTerminal
		If (cAliasSRL)->RL_CPFCGC != xCGC //SRL->RL_CPFCGC != xCGC
			dbSelectArea ( "SRL" )
			(cAliasSRL)->(dbSkip())
			Loop
		EndIf
	EndIf
	If lTerminal
		dbSelectArea("SRL")
		SRL->( dbGoto( (cAliasSRL)->R_E_C_N_O_ ) )
	EndIf
	// Controle para apresentar ou nao o botao da impressora no html
	cHtml := StrTran( cHtml, '***botaoframe***', TracoDuplo() )
    
	cInfoTxt := ""
	/*
	nHdl := FOpen( cArqTxt, 2 )
	FSeek( nHdl, 0 , FS_END )
	*/
 	cHtml += FImprime( lTerminal, nQtdeHtml++, lPortal )
	/*
	If File(cArqTxt)
		fClose(nHdl)
	Endif	
	*/
	dbSelectArea ( "SRL" )
	(cAliasSRL)->( dbSkip() ) //SRL->( dbSkip() )
Enddo

IF lTerminal .and. ! Empty( cHtml )
	// Controle para apresentar ou nao o botao da impressora no html
	cHtml := StrTran( cHtml, '***botaoframe***', BotImpIRPF() )
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Termino do relatorio                                         ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !( lTerminal )
             
	dbSelectArea ("SRL")        
	RetIndex("SRL")
	dbSetOrder(1)
	If File(cArqSRL+OrdBagExt())
		fErase(cArqSRL+OrdBagExt())
	EndIf	
	
	dbSelectArea( "SR4" )
	RetIndex( "SR4" )
	dbSetOrder(1)
	If File(cArqSR4+OrdBagExt())
		fErase(cArqSR4+OrdBagExt())
	EndIf	

	dbSelectArea ("RCS")        
	RetIndex("RCS")
	dbSetOrder(1)
	If File(cArqRCS+OrdBagExt())
		fErase(cArqRCS+OrdBagExt())
	EndIf	
EndIf

If File(cArqTxt)
	nHdl := FOpen( cArqTxt, 2 )
	fClose(nHdl)
Endif   
                  
Return( cHtml )

*---------------------------------*
Static Function FImprime( lTerminal, nQtdeHtml, lPortal )
*---------------------------------*
Local cHtml := ""

Private lAdjustToLegacy := .T.
Private lDisableSetup  	:= .T. 
Private cNomePDF := ""
PRIVATE cPathPDF := ""

cNomePDF := Replace("INFORME_"+SRL->RL_FILIAL+"_"+SRL->RL_MAT+"_"+Dtos(Date())+"_"+StrTran(time(),":") ," ","")

aHTM := {}

MakeDir (cPath)
MakeDir (cPath+cSubPath) 	    

cPathPDF := cPath+cSubPath

If FOpen(cPathPDF+cNomePDF) >= 0
	FErase(cPathPDF+cNomePDF)
Endif

oPrint := FWMSPrinter():New(cNomePDF, IMP_PDF, lAdjustToLegacy, cPathPDF, lDisableSetup) 
oPrint:SetPortrait()
oPrint:SetPaperSize(DMPAPER_A4)
oPrint:cPathPDF := cPathPDF  //GetTempPath() 
oPrint:lPDFasPNG := .F. 
oPrint:SetViewPDF(.F.)


If SRL->RL_TIPOFJ == "1"
    cHtml := Imp_Fisica( aInfo[3], aInfo[4], aInfo[5], aInfo[6], Str(aInfo[15],1), aInfo[10], ainfo[7], lTerminal, nQtdeHtml, lPortal )
Else
    //Imp_Juridica(aInfo[3],aInfo[4],aInfo[5],aInfo[6],Str(aInfo[15],1),aInfo[10],ainfo[7])
Endif


oPrint:Preview()

SRA->( dbSeek(SRL->RL_FILIAL+SRL->RL_MAT))

cXMail := AllTrim(SRA->RA_EMAIL)

If DToS(SRA->RA_DEMISSA) > '20161231' 
	cXMail := AllTrim(SRA->RA_XEMAIL)
Endif                           

aAdd(aHTM,{cPathPDF+cNomePDF,AllTrim(cxMAIL),SRL->RL_FILIAL+"-"+SRL->RL_MAT+"_"+ALLTRIM(SRA->RA_NOME),cNomePDF})

SendIt()

FreeObj(oPrint)
oPrint := Nil

Sleep(5000) //Espera 5 segundos para próximo loop, para esperar envio/upload do e-mail em andamento

Return ( IF( lTerminal, cHtml, "" ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºFuncao    ³Imp_FisicaºAutor  ³Microsiga           ?Data ? 01/31/05   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?Impressao do informe de rendimento Pessoa Fisica           º±
±±?         ?                                                           º±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±
±±ºUso       ?AP                                                         º±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function Imp_Fisica( cDesEmp, cDesEnd, cDesCid, cUf, cTpInsc, cTelef, cDesCep, lTerminal, nQtdeHtml, lPortal )
Local aArea		:= {}
Local cDesc		:= ""
Local lCentra	:= .T.    
Local cHtml		:= ""
Local nPos		:= 0
Local l1Vez		:= .T.
Local nPrioridad:= 0
Local cDepenCPF 	:= ""
Local cDepenCOD 	:= ""
Local cDepenMat 	:= ""
Local cR4Filial := ''
Local cR4Ano    := '' 
Local cR4Mat    := ''
Local cRlCodRet := ''
Local nPosLetra := 0
Local cAliasSM8 :=  ""
Local cAliasSM9 :=  ""
Local aLetPensao := {{"C" , OemToAnsi("Pensao Judicial")},; //Pensao Judicial
						{"C1", OemToAnsi("13 Pensão Judicial")},; //13??Pensão Judicial
						{"C2", OemToAnsi("Pensão Judicial - Art. 12-A, Lei N?7.713 de 1988.")},; //Pensão Judicial - Art. 12-A, Lei N?7.713 de 1988.
						{"C3", OemToAnsi("Pensão Judicial (PLR).")},; //Pensão Judicial (PLR).
						{"8" , OemToAnsi("Pensão Alimentícia Tributação sob exigibilidade suspensa.")},; //Pensão Alimentícia ?Tributação sob exigibilidade suspensa.
						{"81", OemToAnsi("13 Pensão Alimentícia Tributação sob exigibilidade suspensa.")}}  //13??Pensão Alimentícia ?Tributação sob exigibilidade suspensa.
						
Local aLetPrevid := {{"M" , OemToAnsi("Contribuição Previdência Privada.")},; //Contribuição ?Previdência Privada.
						{"M1", OemToAnsi("13o-Contribuição Previdência Privada.")},; //13o-Contribuição ?Previdência Privada.
						{"M2", OemToAnsi("FAPI")},; //FAPI
						{"M3", OemToAnsi("Fundo Prev.Serv.Público")},; //Fundo Prev.Serv.Público
						{"M4", OemToAnsi("Contr. Ente público patroc.")},; //Contr. Ente público patroc.
						{"M5", OemToAnsi("13o-FAPI")},; //13o-FAPI
						{"M6", OemToAnsi("13o-Fundo Prev.Serv.Público")},; //13o-Fundo Prev.Serv.Público
						{"M7", OemToAnsi("13o-Contr.Ente público patroc.")},; //13o-Contr.Ente público patroc.
						{"9" , OemToAnsi("Previdência privada Tributação sob exigibilidade suspensa.")},; //Previdência privada ?Tributação sob exigibilidade suspensa.
						{"91", OemToAnsi("13o-Previdência Privada Tributação sob exigibilidade suspensa.")},; //13??Previdência Privada ?Tributação sob exigibilidade suspensa.
						{"9A", OemToAnsi("Exigib. Susp.-FAPI")},; //Exigib. Susp.-FAPI
						{"9B", OemToAnsi("Exigib. Susp.-Fundo Prev.Serv.Público")},; //Exigib. Susp.-Fundo Prev.Serv.Público
						{"9C", OemToAnsi("Exigib. Susp.-Contr. Ente público patroc.")},; //Exigib. Susp.-Contr. Ente público patroc.
						{"9D", OemToAnsi("13o-Exigib. Susp.-FAPI")},; //13o-Exigib. Susp.-FAPI
						{"9E", OemToAnsi("13o-Exigib. Susp.-Fundo Prev.Serv.Público")},; //13o-Exigib. Susp.-Fundo Prev.Serv.Público
						{"9F", OemToAnsi("13o-Exigib. Susp.-Contr. Ente públ. patroc.")}}  //13o-Exigib. Susp.-Contr. Ente públ. patroc.

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ?Em relacao a DIRF de 2010: A de 2011 nao tem as letras: K, X e 3, as quais	?
// ?foram mantidas para garantia da impressao da dirf do ano anterior.			?
// ?Para a DIRF de 2011 foram acrescentadas as letras: 0, H1, F1, S e S1.		?
// ?Para a DIRF de 2017 foram acrescentadas as letras: M2, M5,  M, M1, 9D, 9A,  ?
// ?91, M6,  9, 9E, 9F, 9B, 9C, M3, M4, M7, mas elas não entram aqui devido aqui?
// ?a looping de processamentos particulas                                      ?
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Qtde de Letras:	 1	  2		3	  4		5	  6		7	   8	 9	  10
Private aLetra := {	"A", "B" , "M" , "C" , "T" , "D" , "E" , "F" , "G" , "H" 	,;
					"P", "U" , "I" , "J" , "K" , "L" , "O" , "R" , "V" , "W" 	,;
					"X", "Y" , "Z" , "1" , "2" , "3" , "4" , "5" , "6" , "7" 	,;
					"8", "9" , "B1", "C1", "M1", "T1", "61", "71", "81", "91"	,;
					"0", "H1", "F1", "S" , "S1", "Q" 							}
Private aLetraPLR := { "O1", "Q1", "C3"}
Private aLetraRRA := { "A1", "B2", "B3", "C2", "D2", "I1" }

Private aTotLetra[Len(aLetra)] //aTotLetra[46]
Private aTotPLR[3]
Private aTotRRA		:= {}
private aProcMat	:= {}
Private cCgc
Private nLiq13o 	:= 0.00
Private nTotOutros	:= 0
Private nTotRend	:= 0
Private nTotRetido 	:= 0
Private cDescRet    := ""
Private cDescRRA	:= ""
Private nItem		:= 0
Private nLinhas		:= 0
Private aComplem	:= {}
Private cDescOred	:= ""            		
Private cFil_Mat	:= ""
Private lGCHPortal := .F.
Private cDataInf
If lPortal
	Private cFrame		:= '1'
	Private dDataInf
	If Type("DMReport") == 'U' .OR. Type("TaxYear") == 'U'
		dDataInf := DTOC(DATE())
	Else
		cDataInf	:= STOD( Alltrim(STR(VAL(TaxYear) + 1) + Substr(DMReport,3) + Substr(DMReport,1,2)) )
		dDataInf := DTOC(cDataInf)
	EndIf
	Private dDataInf	:= DTOC(DATE())
	lGCHPortal 			:= .T.
EndIf

Afill( aTotLetra , 0 )
Afill( aTotPLR   , 0 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Procurar descricao do Cod.Retencao tab. 37
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX5")
If dbSeek(cFilial+"37"+SRL->RL_CODRET)
    cDescRet := X5Descri()
Else
    cDescRet := STR0009 //"Codigo nao Cadastrado Tabela 37                       "
Endif

If lUsaRRA
	If DbSeek(cFilial+"37"+"1889")
		cDescRRA := X5Descri()
	Else
		cDescRRA := STR0009
	EndIf
EndIf

cCgc := If(cTpInsc="2",Transform(SubStr(SRL->RL_CGCFONT,1,14),"@R ##.###.###/####-##"),If(cTpInsc="3",Transform(SubStr(SRL->RL_CGCFONT,1,11),"@R ###.###.###-##")+Space(4),SRL->RL_CGCFONT))
If SRL->RL_NOMFONT # aInfo[3]
	aInfo[3] :=SRL->RL_NOMFONT 
Endif
                      
cSr4Filial := Replicate("!", FwGetTamFilial)
dbSelectArea ( "SR4" )

If lTerminal .and. ! lIndSR4
	SR4->( dbSetOrder( RetOrdem( "SR4", "R4_ANO+R4_CPFCGC+R4_CODRET+R4_MES" ) ) )
	SR4->( dbSeek (cAno + SRL->RL_CPFCGC + SRL->RL_CODRET ) )
Else
	dbSeek ( cAno + SRL->RL_CPFCGC + SRL->RL_CODRET )
EndIf

If SR4->(! Eof() ) .AND. SR4->R4_ANO == cAno .AND. SR4->R4_CPFCGC == SRL->RL_CPFCGC .AND. SR4->R4_CODRET == SRL->RL_CODRET
	cR4Filial := SR4->R4_FILIAL
	cR4Ano    := cAno 
	cR4Mat    := SR4->R4_MAT
	cRlCodRet := SRL->RL_CODRET

	While SR4->(! Eof() ) .AND. SR4->R4_ANO == cAno .AND. SR4->R4_CPFCGC == SRL->RL_CPFCGC .AND. SR4->R4_CODRET == SRL->RL_CODRET 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//?Consiste controle de acessos                                 
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lTerminal
			If !(SR4->R4_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSR4)
				SR4->(dbSkip())
				Loop
			EndIf 
		EndIf               
	
	    If l1Vez
	    	chkAtivo(@cFil_MAT)
	    	l1Vez := .F.
	    EndIf	      
	    
		If (SR4->R4_FILIAL # SRL->RL_FILIAL ) 
			If cSr4Filial # SR4->R4_FILIAL
				dbSelectArea("SRL")
				aArea		:= GetArea()       
				SRL->( dbSetOrder(1) )
				cCNPJoLD 	:= SRL->RL_CGCFONT
				cSr4Filial 	:= SR4->R4_FILIAL
				SRL->(dbSeek(SR4->R4_FILIAL+SR4->R4_MAT))
				If SRL->RL_CGCFONT # cCNPJoLD
					lCentra := .F.
				   	SR4->( dbSkip() )
					RestArea(aArea)
				   	Loop
				EndIf 
	
				chkAtivo(@cFil_mat)  	
	
				RestArea(aArea)
			ElseIf !lCentra
			   	SR4->( dbSkip() )
				Loop
			EndIf
		EndIf	
	
		nLetra := Ascan(aLetra,Alltrim(SR4->R4_TIPOREN))
	
	   	If nLetra > 0
	       aTotLetra[nLetra] += NoRound(SR4->R4_VALOR,2)
		ElseIf lUsaRRA
	    	nLetra := aScan(aLetraRRA,AllTrim(SR4->R4_TIPOREN))
	    	//Rendimento Recebido Acumuladamente
	    	If nLetra > 0
	    		nPos := Ascan( aTotRRA,{ |X| X[1] == SR4->R4_IDCMPL })
	    		If nPos > 0
	    			aTotRRA[nPos,5,nLetra] += NoRound(SR4->R4_VALOR,2)
	    		Else
		    		DbSelectArea("RFI")
		    		If DbSeek(SR4->R4_FILIAL+SR4->R4_MAT+SR4->R4_IDCMPL)
						aAdd(aTotRRA,{RFI->RFI_IDCMPL,RFI->RFI_NUMPRO, AllTrim(RFI->RFI_RETRRA), SR4->R4_MESES, {0,0,0,0,0,0} } )
						aTotRRA[Len(aTotRRA),5,nLetra] += NoRound(SR4->R4_VALOR,2)
		    		EndIf
		    	EndIf
	        Endif
		Endif
		   	
	   	If ( cAno >= "2016" )
			If Empty( aProcMat ) .Or. ( ( nArray :=  aScan( aProcMat, { |X| X == SR4->R4_FILIAL + SR4->R4_MAT + cAno+SRL->RL_CODRET } ) ) == 0 ) 
				aAdd ( aProcMat, SR4->R4_FILIAL + SR4->R4_MAT + cAno + SRL->RL_CODRET )
				aTotLetra[3] += GetPrevidencia(SR4->R4_FILIAL,cAno, SR4->R4_MAT,SRL->RL_CODRET)
				aTotLetra[4] += GetPensao(SR4->R4_FILIAL,cAno, SR4->R4_MAT,SRL->RL_CODRET)
				nLetra := Ascan(aLetraPLR, "C3")
				If nLetra>0
					aTotPLR[nLetra] += GetC3Pensao(cR4Filial, cR4Ano, cR4Mat, cCodPLR)
				Endif
				nLetra := Ascan(aLetra, "C1")
				aTotLetra[nLetra] += Get13oPensao(SR4->R4_FILIAL, cAno, SR4->R4_MAT,SRL->RL_CODRET)
				aTotLetra[35] += GetExcPrevidencia(SR4->R4_FILIAL, cAno, SR4->R4_MAT,SRL->RL_CODRET)
			Endif	
		Endif

	   	dbSelectArea("SR4")
		SR4->( dbSkip())
	Enddo
	
Endif

//A partir do ano 2013, o PLR e' recolhido separadamente, sob o codigo de retencao 3562
If cAno >= "2013"
	If lTerminal .and. ! lIndSR4
		SR4->( dbSetOrder( RetOrdem( "SR4", "R4_ANO+R4_CPFCGC+R4_CODRET+R4_MES" ) ) )
		SR4->( dbSeek (cAno + SRL->RL_CPFCGC + cCodPLR ) )
	Else
		SR4->( dbSeek ( cAno + SRL->RL_CPFCGC + cCodPLR ) )
	EndIf
	
	While SR4->(! Eof() ) .AND. SR4->R4_ANO == cAno .AND. SR4->R4_CPFCGC == SRL->RL_CPFCGC .AND. SR4->R4_CODRET == cCodPLR
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//?Consiste controle de acessos                                 ?
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lTerminal
			If !(SR4->R4_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSR4)
				SR4->(dbSkip())
				Loop
			EndIf 
		EndIf               
	
	    If l1Vez
	    	chkAtivo(@cFil_MAT)
	    	l1Vez := .F.
	    EndIf	      
	    
		If (SR4->R4_FILIAL # SRL->RL_FILIAL ) 
			If cSr4Filial # SR4->R4_FILIAL
				dbSelectArea("SRL")
				aArea		:= GetArea()       
				SRL->( dbSetOrder(1) )
				cCNPJoLD 	:= SRL->RL_CGCFONT
				cSr4Filial 	:= SR4->R4_FILIAL
				SRL->(dbSeek(SR4->R4_FILIAL+SR4->R4_MAT))
				If SRL->RL_CGCFONT # cCNPJoLD
					lCentra := .F.
				   	SR4->( dbSkip() )
					RestArea(aArea)
				   	Loop
				EndIf 
	
				chkAtivo(@cFil_mat)  	
	
				RestArea(aArea)
			ElseIf !lCentra
			   	SR4->( dbSkip() )
				Loop
			EndIf
		EndIf	
	
		nLetra := Ascan(aLetraPLR, Alltrim(SR4->R4_TIPOREN))
	
	   	If nLetra > 0
	       aTotPLR[nLetra] += NoRound(SR4->R4_VALOR,2)
	   	Endif
		//controle para previdencia e pensao
		If ( cAno >= "2016" )
			If Empty( aProcMat ) .Or. ( ( nArray :=  aScan( aProcMat, { |X| X == SR4->R4_FILIAL + SR4->R4_MAT + cAno+SRL->RL_CODRET } ) ) == 0 ) 
				aAdd ( aProcMat, SR4->R4_FILIAL + SR4->R4_MAT + cAno + SRL->RL_CODRET )
				aTotLetra[3] := GetPrevidencia(SR4->R4_FILIAL,cAno, SR4->R4_MAT,SRL->RL_CODRET)
				aTotLetra[4] := GetPensao(SR4->R4_FILIAL,cAno, SR4->R4_MAT,SRL->RL_CODRET)
				nLetra := Ascan(aLetraPLR, "C3")
				If nLetra>0
					aTotPLR[nLetra] += GetC3Pensao(cR4Filial, cR4Ano, cR4Mat, cCodPLR)
				Endif
				//GetExcPrevidencia(cR4Filial, cR4Ano, cR4Mat,cRlCodRet)
			Endif
		Endif
	
	   	dbSelectArea("SR4")
		SR4->( dbSkip())
	Enddo
EndIf

nPos := 0

If cIRRetido == 1
    If aTotLetra[6] <= 0
		Return Nil
	Endif
Endif
                     
nTotRend 	:= Max( aTotLetra[01], 0 ) //nTotRend 	:= aTotLetra[01]
nTotRetido	:= Max( aTotLetra[06] + aTotLetra[23] + aTotLetra[19] + aTotLetra[44], 0 ) //nTotRetido	:= aTotLetra[06] + aTotLetra[23] + aTotLetra[19] + aTotLetra[44]
nLiq13o 	:= (aTotLetra[14] - aTotLetra[15] - aTotLetra[16]) - aTotLetra[24] - aTotLetra[28]
nLiq13o 	:= nLiq13o - aTotLetra[33] - aTotLetra[34] - aTotLetra[35] - aTotLetra[36] - aTotLetra[45]
nTotOutros	:= ( aTotLetra[17] - aTotLetra[46] ) + ( aTotPLR[1] - aTotPLR[2] - aTotPLR[3] )

If nLiq13o < 0
    nLiq13o := 0.00
Endif
                  
nItem := 1  

//A partir do ano 2013, verificar se houve pagamento de PLR
If cAno >= "2013" .And. aTotPLR[1] > 0
	nItem := 3
	//aAdd(aComplem,{ "Valor bruto pago referente PLR: ", aTotPLR[1], "PLRBruto", 6 })//"Valor bruto pago referente PLR: "
	aAdd(aComplem,{ "O total informado na linha 03 do Quadro 5 j?inclui o valor total pago a título de PLR correspondente a", aTotPLR[1] - aTotPLR[2] - aTotPLR[3], "PLRLiq", 7 })	//"O total informado na linha 02 do Quadro 5 j?inclui o valor total pago a título de PLR correspondente a"
EndIf
dbSelectArea("RCS")

If lTerminal .and. !lIndRCS
	RCS->( dbSeek( SRL->RL_FILIAL+SRL->RL_MAT+SRL->RL_TIPOFJ+SRL->RL_CPFCGC+If(lUsaRRA,"",SRL->RL_CODRET+cAno) ) )
Else
	RCS->( dbSeek( cAno + SRL->RL_CPFCGC + If(lUsaRRA,"",SRL->RL_CODRET) ))
	If !RCS_CODRET == "1889"
		RCS->( dbSeek( cAno + SRL->RL_CPFCGC + SRL->RL_CODRET) )
	Endif
EndIf

cCNPJoLD 	:= ""
cRCSFilial 	:= Replicate("!", FwGetTamFilial)
							
While RCS->(! Eof() ) .AND. RCS->RCS_ANO == cAno .AND. RCS->RCS_CPFBEN == SRL->RL_CPFCGC .AND. ( RCS->RCS_CODRET == SRL->RL_CODRET .OR. (lUsaRRA .and. RCS->RCS_CODRET == "1889"))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//?Consiste controle de acessos                                 ?
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lTerminal
		If !(RCS->RCS_FILIAL $ fValidFil()) .Or. !Eval(cAcessaRCS)
			RCS->(dbSkip())
			Loop
		EndIf 
	EndIf 

	If (RCS->RCS_FILIAL # SRL->RL_FILIAL ) 
		If cRCSFilial # RCS->RCS_FILIAL
			dbSelectArea("SRL")
			aArea	:= GetArea()       
			SRL->( dbSetOrder(1) )
			cCNPJoLD 	:= SRL->RL_CGCFONT
			cRCSFilial 	:= RCS->RCS_FILIAL
			SRL->(dbSeek(RCS->RCS_FILIAL+RCS->RCS_MAT))
			If SRL->RL_CGCFONT # cCNPJoLD
				lCentra := .F.
			   	RCS->( dbSkip() )
				RestArea(aArea)
			   Loop
			Else
				lCentra := .T.				   
			EndIf   	
			RestArea(aArea)
		ElseIf !lCentra
		   	RCS->( dbSkip() )
			Loop
		EndIf
	EndIf	

	nLinhas++    
	If !empty(RCS->RCS_NOME) .and. ( EMPTY(RCS->RCS_OUTROS) .OR. AllTrim(RCS->RCS_TIPORE) == "R")
		If RCS->RCS_VALOR # 0                                                                 
		    If nTipRel == 1  //formulario pre impresso    
	           nTam1 	:= 42
	           nTam2	:= 57        
	           nTam3	:= 61
			Else	           
	           nTam1 	:= 66
	           nTam2	:= 80
	           nTam3	:= 84
	        EndIf
	           
			nIni := 1
			nQtd := If( nTipRel== 1, 57,80)  

			cChave := RCS->RCS_CPFCGC+RCS->RCS_TIPORE+RCS->RCS_OUTROS+RCS->RCS_VERBA
			nPos := Ascan( aComplem,{ |X| X[3]==cChave .and. X[2]> 0 })                                                         

			If nPos > 0
				aComplem[nPos,2] += RCS->RCS_VALOR
				RCS->(dbSkip())   
				LOOP
			EndIf	 

			cDesc := AllTrim( RCS->RCS_DESCRI )

			// Define a prioridade de impressao das informacoes complementares dependendo do tipo de retencao da verba
			If Alltrim( RCS->RCS_TIPORE ) $ "W#2"
				nPrioridad := 1
			ElseIf Alltrim( RCS->RCS_TIPORE ) $ "C#C1"
				nPrioridad := 2
				cDesc += Space(2) + Transform( RCS->RCS_CPFCGC, If( Len(AllTrim(RCS->RCS_CPFCGC)) == 11, "@R 999.999.999-99", "@R 99.999.999/9999-99" ) )
			ElseIf Alltrim( RCS->RCS_TIPORE ) $ "R" .And. ! "REEMBOLSO" $ RCS->RCS_OUTROS 
				nPrioridad := 3
			ElseIf Alltrim( RCS->RCS_TIPORE ) $ "R" .And. "REEMBOLSO" $ RCS->RCS_OUTROS 
				nPrioridad := 4
			Else
				nPrioridad := 5
			EndIf

			aAdd(aComplem,{ cDesc, RCS->RCS_VALOR, cChave, nPrioridad })

			//| 05. DEP. JUDICIAL                              53113791000122 |     3.050,00 |
			//      123456789012345678901234567890123456789012 45678901234567
			// 123456789012345678901234567890123456789012345678901234567890123456789012345678			
			//          10        20        30        40        50        60        70          
			nItem++
		ElseIf Alltrim(RCS->RCS_TIPORE) # "R"
			//aAdd( aComplem, { SPACE(04) + RCS->RCS_NOME +space(23), 0, "", 9 } )
			aAdd( aComplem, { SPACE(04) + RCS->RCS_NOME +space(23), 0,"Outros",nPrioridad} )
		Endif               
	EndIf
	
	If !EMPTY(RCS->RCS_OUTROS) .and. AllTrim(RCS->RCS_TIPORE) <> "R"
		cDescOred += If(!empty(alltrim(cDescOred)),", ","")+ alltrim(RCS->RCS_OUTROS)
	EndIf
	RCS->(dbSkip()	)
EndDo                                         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//?Faz a validacao do Ano-Base para desenvolvimento do Bloco#7 - Info Complementares    ?
//?Se Ano-Base >= 2016: Verificar os dados vindos da SM8 (Pensao) e SM9 (Prev Privada)  ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cAno >= "2016"

	cAliasSM8 :=  GetNextAlias()
	
	//----------------------------------------------
	//| Posiciona o registro dentro da SM8 - PENSAO
	//----------------------------------------------
	cQuery := "SELECT M8_FILIAL, M8_MAT, RA_CIC, M8_ANO, M8_CODRET, M8_CPFBEN, M8_CODBEN, M8_VALOR, M8_TIPOREN  "
	cQuery += "FROM " + RetSqlName("SM8")	+ " QSM8, "+	RetSqlName("SRA")	+ " QSRA "
	cQuery += "WHERE M8_FILIAL = RA_FILIAL	"
	cQuery += "AND M8_MAT = RA_MAT "
	cQuery += "AND RA_CIC = '" + SRL->RL_CPFCGC + "'"
	cQuery += "AND M8_ANO = " + "'" + cAno + "'" 
	cQuery += " ORDER BY RA_CIC,M8_MAT,M8_CODRET "
	cQuery	:= ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSM8, .F., .T.)
	dbSelectArea( cAliasSM8 )

	cSM8Filial 	:= Replicate("!", FwGetTamFilial)
	
	//-----------------------------------------------------------------------------
	//| Looping dentro da SM8 para varrer Dependentes por Dependentes e M8_TIPOREN
	//-----------------------------------------------------------------------------
	While ( cAliasSM8 )->( !Eof() .And. ( M8_ANO == cAno ) )
	
		If ( cAliasSM8 )->( !( M8_CODRET $ ( SRL->RL_CODRET + "*1889*3562" ) ) )
			( cAliasSM8 )->( dbSkip() )
			Loop
		EndIf
		
		cCpfSM8 := ( cAliasSM8 )->RA_CIC

		//Variaveis auxiliares para recuperar registro de dependente
		cDepenCPF 	:= (cAliasSM8)->M8_CPFBEN
		cDepenCOD 	:= (cAliasSM8)->M8_CODBEN
		cDepenMat 	:= (cAliasSM8)->M8_MAT
		 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//?Consiste controle de acessos                                 ?
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lTerminal
			If !((cAliasSM8)->M8_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSM8)
				(cAliasSM8)->(dbSkip())
				Loop
			EndIf 
		EndIf 

		If ((cAliasSM8)->M8_FILIAL # SRL->RL_FILIAL ) 
			If cSM8Filial # RCS->RCS_FILIAL 
				dbSelectArea("SRL")
				aArea	:= GetArea()    
				SRL->( dbSetOrder(1) )
				cCNPJoLD 		:= SRL->RL_CGCFONT
				cSM8Filial 	:= RCS->RCS_FILIAL
				SRL->(dbSeek((cAliasSM8)->M8_FILIAL+(cAliasSM8)->M8_MAT))
				If SRL->RL_CGCFONT # cCNPJoLD
					lCentra := .F.
				   	(cAliasSM8)->( dbSkip() )
					RestArea(aArea)
				  	Loop
				Else
					lCentra := .T.				   
				EndIf   	
				RestArea(aArea)
			ElseIf !lCentra
			   	(cAliasSM8)->( dbSkip() )
				Loop
			EndIf
		EndIf	

		//-------------------------------
		//|Verifica os registros setados
		//-------------------------------	
		nLinhas++
		//---------------------------------------------------------------------------------
		//| Controle sobre quais Codigos de RV_DIRF deve retornar no Informe de Rendimento  
		//| (quadro 7). Basta incrementar o código, separando por "|"
		//---------------------------------------------------------------------------------
		If !empty((cAliasSM8)->M8_MAT) .and. AllTrim((cAliasSM8)->M8_TIPOREN) $ "8|81|C|C1|C2|C3"
			If (cAliasSM8)->M8_VALOR # 0   
			    If nTipRel == 1  //formulario pre impresso    
		           nTam1 	:= 42
		           nTam2	:= 57        
		           nTam3	:= 61
				Else	           
		           nTam1 	:= 66
		           nTam2	:= 80
		           nTam3	:= 84
		        EndIf
		           
				nIni := 1
				nQtd := If( nTipRel== 1, 57,80)  
	
				//---------------------------------------------------------------
				//| Cria chave para pesquisar se j?existe dependente cadastrado
				//| dentro do array aComplem (Baseado nos registros da SM8)
				//---------------------------------------------------------------					
				cChave := cCpfSM8+(cAliasSM8)->M8_CPFBEN+(cAliasSM8)->M8_CODBEN+(cAliasSM8)->M8_CODRET+(cAliasSM8)->M8_TIPOREN+cAno
				nPos := Ascan( aComplem,{ |X| X[3]==cChave .and. X[2]> 0 })                                                         
	
				//-------------------------------------------------------
				//| Se encontrar o dependente, adiciona o valor pago do 
				//| mes seguinte a soma do mes anterior (mesmo registro)
				//-------------------------------------------------------	
				If nPos > 0
					aComplem[nPos,2] += (cAliasSM8)->M8_VALOR
					(cAliasSM8)->(dbSkip())   
					LOOP
				EndIf
				
				//---------------------------------
				//| Seleciona o nome do dependente
				//---------------------------------
				DbSelectArea("SRQ")
				SRQ->( dbSeek( SRL->RL_FILIAL+cDepenMat+cDepenCOD+"01")	) 
				cDesc := Pad(Upper(AllTrim(SRQ->RQ_NOME)),27)+" "
	 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//?Define a prioridade de impressao das informacoes complementares?
				//?dependendo do tipo de retencao da verba                        ?
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nPosLetra := aScan( aLetPensao, { |x| x[1] == AllTrim((cAliasSM8)->M8_TIPOREN) } )
				
				If(nPosLetra > 0)
					cDesc += PAD(Upper(AllTrim(aLetPensao[nPosLetra,2])),30) +  " CPF: "
					nPrioridad := 2
					//Formata o CPF/CNPJ
					If !Empty(  (cAliasSM8)->(M8_CPFBEN)  )
						cDesc += Transform( (cAliasSM8)->M8_CPFBEN, If( Len(AllTrim((cAliasSM8)->M8_CPFBEN)) == 11, "@R 999.999.999-99", "@R 99.999.999/9999-99" ) )
						nPosLetra := 0
					EndIf
				EndIf
	
				aAdd(aComplem,{ cDesc, (cAliasSM8)->M8_VALOR, cChave, nPrioridad })
				//| 7. - Informações Complementares
				// -------------------------x-----------------x-------------------x--------------                               
				//| 01. ANTENOR RICARDO L DE PENSÃO JUDICIAL   007.055.748-90      |        32,85|
				//| 02. ANTENOR RICARDO L DE PENSÃO JUDICIAL   007.055.748-90      |        32,85|
				// -------------------------x-----------------x-------------------x--------------
				// 123456789012345678901234567890123456789012345678901234567890123456789012345678			
				//          10        20        30        40        50        60        70          
				nItem++
			Endif               
		EndIf
		(cAliasSM8)->(dbSkip())
	EndDo 

	(cAliasSM8)->(dbCloseArea())
	
	//-----------------------------------------------------------
	//| Posiciona o registro dentro da SM9 - PREVIDENCIA PRIVADA
	//-----------------------------------------------------------
	cAliasSM9 :=  GetNextAlias()
		
	cQuery := "SELECT M9_FILIAL, M9_MAT,RA_CIC, M9_ANO, M9_CODRET,M9_NOMEEMP,M9_CODFOR,M9_CNPJ, M9_VALOR, M9_TIPOREN, M9_NOMEEMP  "
	cQuery += "FROM " + RetSqlName("SM9")	+ " QSM9, "+	RetSqlName("SRA")	+ " QSRA "
	cQuery += "WHERE M9_FILIAL = RA_FILIAL	"
	cQuery += "AND M9_MAT = RA_MAT "
	cQuery += "AND M9_ANO = " + "'" + cAno + "'"
	cQuery += "AND RA_CIC = '" + SRL->RL_CPFCGC + "'"
	cQuery += " ORDER BY RA_CIC,M9_MAT,M9_CODRET "
	cQuery	:= ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasSM9, .F., .T.)
	dbSelectArea(cAliasSM9)
	dbGotop()

	cSM9Filial 	:= Replicate("!", FwGetTamFilial)
	
	//-----------------------------------------------------------------------------
	//| Looping dentro da SM9
	//-----------------------------------------------------------------------------
	While ( cAliasSM9 )->( !Eof() .And. ( M9_ANO == cAno ) )

		If ( cAliasSM9 )->( !( M9_CODRET $ ( SRL->RL_CODRET + "*1889" ) ) )
			( cAliasSM9 )->( dbSkip() )
			Loop
		EndIf
		
		cCpfSM9 := ( cAliasSM9 )->RA_CIC

		//Variaveis auxiliares para recuperar registro da prestadora de servico da previdencia
		cEmprNome 	:= (cAliasSM9)->M9_NOMEEMP
		cEmprCod 	:= (cAliasSM9)->M9_CODFOR
		cEmprCGC 	:= (cAliasSM9)->M9_CNPJ

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//?Consiste controle de acessos                                 ?
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lTerminal
			If !((cAliasSM9)->M9_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSM9)
				(cAliasSM9)->(dbSkip())
				Loop
			EndIf 
		EndIf 

		If ((cAliasSM9)->M9_FILIAL # SRL->RL_FILIAL ) 
			If cSM9Filial # (cAliasSM9)->M9_FILIAL
				dbSelectArea("SRL")
				aArea	:= GetArea()    
				SRL->( dbSetOrder(1) )
				cCNPJoLD 		:= SRL->RL_CGCFONT
				cSM9Filial 	:= (cAliasSM9)->M9_FILIAL
				SRL->(dbSeek((cAliasSM9)->M9_FILIAL+(cAliasSM9)->M9_MAT))
				If SRL->RL_CGCFONT # cCNPJoLD
					lCentra := .F.
				   	(cAliasSM9)->( dbSkip() )
					RestArea(aArea)
				  	Loop
				Else
					lCentra := .T.				   
				EndIf   	
				RestArea(aArea)
			ElseIf !lCentra
			   	(cAliasSM9)->( dbSkip() )
				Loop
			EndIf
		EndIf	

		//-------------------------------
		//|Verifica os registros setados
		//-------------------------------	
		nLinhas++
		//---------------------------------------------------------------------------------
		//| Controle sobre quais Codigos de RV_DIRF deve retornar no Informe de Rendimento  
		//| (quadro 7). Basta incrementar o código, separando por "|"
		//---------------------------------------------------------------------------------   
		If !empty((cAliasSM9)->M9_MAT) .and. AllTrim((cAliasSM9)->M9_TIPOREN) $ "9|M|M2|M3|M4|9A|9B|9C"
			If (cAliasSM9)->M9_VALOR # 0               //Eliminado os valores de 13?Prev Privada                                         
			    If nTipRel == 1  //formulario pre impresso    
		           nTam1 	:= 42
		           nTam2	:= 57        
		           nTam3	:= 61
				Else	           
		           nTam1 	:= 66
		           nTam2	:= 80
		           nTam3	:= 84
		        EndIf
		           
				nIni := 1
				nQtd := If( nTipRel== 1, 57,80)  
	
				//---------------------------------------------------------------
				//| Cria chave para pesquisar se j?existe dependente cadastrado
				//| dentro do array aComplem (Baseado nos registros da SM8)
				//---------------------------------------------------------------					
				cChave := cCpfSM9+(cAliasSM9)->(M9_CNPJ)+(cAliasSM9)->M9_TIPOREN
				nPos := Ascan( aComplem,{ |X| X[3]==cChave .and. X[2]> 0 })                                                         
	
				//-------------------------------------------------------
				//| Se encontrar o dependente, adiciona o valor pago do 
				//| mes seguinte a soma do mes anterior (mesmo registro)
				//-------------------------------------------------------	
				If nPos > 0
					aComplem[nPos,2] += (cAliasSM9)->M9_VALOR
					(cAliasSM9)->(dbSkip())   
					LOOP
				EndIf
				
				cDesc := Upper(AllTrim((cAliasSM9)->M9_NOMEEMP)) + space(1)
					 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//?Define a prioridade de impressao das informacoes complementares?
				//?dependendo do tipo de retencao da verba                        ?
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nPosLetra := aScan( aLetPrevid, { |x| x[1] == AllTrim((cAliasSM9)->M9_TIPOREN) } )
				
				If(nPosLetra > 0)
					cDesc += " / " + Upper(AllTrim(aLetPrevid[nPosLetra,2])) + " / CNPJ: "
					nPrioridad := 3
					//Formata o CPF/CNPJ
					If !Empty(  (cAliasSM9)->(M9_CNPJ)  )
						cDesc += " " + Transform( (cAliasSM9)->(M9_CNPJ), If( Len(AllTrim((cAliasSM9)->(M9_CNPJ))) == 11, "@R 999.999.999-99", "@R 99.999.999/9999-99" ) )
						nPosLetra := 0
					EndIf
				EndIf
				
				aAdd(aComplem,{ cDesc, (cAliasSM9)->M9_VALOR, cChave, nPrioridad })
				//| 7. - Informações Complementares
				// -------------------------x-----------------x-------------------x--------------                               
				//| 05. BANCO ITAU ITAU ITAU FAPI              55.491.484/0001-00  |     1.322,29|
				//| 05. NOME DO BANCO VEM AQ TIPO DO SERVICO   CNPJ JA FORMATADO A |     1.322,29|
				// -------------------------x-----------------x-------------------x--------------
				// 123456789012345678901234567890123456789012345678901234567890123456789012345678			
				//          10        20        30        40        50        60        70          
				nItem++
			Endif               
		EndIf
		(cAliasSM9)->(dbSkip())
	EndDo
	(cAliasSM9)->(dbCloseArea())                                
EndIf                                        

//Funcao para alimentar variavel cDescOred quando verba for tipo de incidencia '0' - abono pecuniario
//quando o valor dos lancamentos do tipo '0' for maior do que zero.
If aTotLetra[41] > 0.00
	fDescIncid0()
EndIf

If nLiq13o == 0 .and. nTotRetido == 0 .and. nTotRend == 0 .and.;
	len(aComplem) == 0 .and. ascan(aTotLetra,{|X|X <> 0}) == 0
	cHtml := ""
Else

	//--> Impressao em RdMAKE
	If lTerminal
		Private lPulaHtml := ( nQtdeHtml > 0 )
	EndIf

	//cHtml := ExecBlock( "IMPIRPF", .F., .F. )
	cHtml := U_PTNIMPIRPF(@cInfoTxt)
EndIf

Return ( IF( lTerminal , cHtml , "" ) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³GPEM580   ºAutor  ³Microsiga           ?Data ? 02/27/07   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?                                                           º±
±±?         ?                                                           º±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±
±±ºUso       ?AP                                                         º±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function chkAtivo(cFil_Mat)
Local aAreaSRA                 

dbSelectArea("SRA")
aAreaSRA	:= GetArea()       

If SR4->R4_FILIAL+SR4->R4_MAT # SRA->RA_FILIAL+SRA->RA_MAT
	SRA->(dbSeek(SR4->R4_FILIAL+SR4->R4_MAT))
EndIf

If SRA->RA_SITFOLH # "D" .and. empty(SRA->RA_DEMISSA)  
	If SRL->(FieldPos("RL_CC"))== 0
		cFil_Mat:= SRL->RL_FILIAL+"-"+SRL->RL_MAT
	Else
		cFil_Mat:= SRL->RL_FILIAL+"-"+SRL->RL_MAT+"-"+SRL->RL_CC
	EndIf
EndIf 

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºFuncao   ³Imp_JuridicaºAutor  ³Microsiga          ?Data ? 01/31/05   º±?
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.    ?Impressao do informe de rendimento Pessoa Juridica          º±
±±?        ?                                                            º±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±
±±ºUso      ?AP                                                          º±
±±ÈÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function Imp_Juridica(cDesEmp,cDesEnd,cDesCid,cUf,cTpInsc,cDesCep)

Local nTotIR	 	:= 0
Private cCgc 		:= Transform(SubStr(SRL->RL_CGCFONT,1,14),"@R ##.###.###/####-##")
Private cDescRet	:= ""
Private nItem		:= 0
Private nLinhas		:= 0
Private aComplem	:= {}
Private cDescOred	:= ""

cCodRet := SRL->RL_CODRET

If SRL->RL_NOMFONT # aInfo[3]
	aInfo[3] :=SRL->RL_NOMFONT 
Endif

dbSelectArea("SRL")
If TYPE("RL_CIDABEN") = "U"
    M->RL_CIDABEN := SPACE(20)
    M->RL_NUMDOC  := SPACE(10)
Else
    M->RL_CIDABEN := SRL->RL_CIDABEN
    M->RL_NUMDOC  := SRL->RL_NUMDOC
Endif

//--Procurar descicao do Cod.Retencao tab. 37
dbSelectArea("SX5")
If dbSeek(cFilial+"37"+SRL->RL_CODRET)
    cDescRet := X5Descri()
Else
    cDescRet := STR0010 //"Codigo nao Cadastrado Tabela 37                       "
Endif

nLinhas		:= 0

nItem := 1
dbSelectArea("RCS")
RCS->(dbSeek( SRL->RL_FILIAL+SRL->RL_MAT+SRL->RL_TIPOFJ+SRL->RL_CPFCGC+SRL->RL_CODRET+cANO))
While RCS->(!Eof()) .And. SRL->RL_FILIAL+SRL->RL_MAT+SRL->RL_TIPOFJ+SRL->RL_CPFCGC+SRL->RL_CODRET+cANO== ;
		RCS->RCS_FILIAL+RCS->RCS_MAT+RCS->RCS_TIPOFJ+RCS->RCS_CPFBEN+RCS->RCS_CODRET+RCS->RCS_ANO

	nLinhas++    

	If !empty(RCS->RCS_NOME) .and. (EMPTY(RCS->RCS_OUTROS)	.OR. AllTrim(RCS->RCS_TIPORE) == "R" )
		If RCS->RCS_VALOR # 0                                                                 
		    If len(Alltrim(RCS->RCS_DESCRI)) > 35 .and. nTipRel== 1  //formulario pre impresso    
				nIni := 1
				nQtd := 57  
				While nIni < 200
					nTamLin := len(space(04) +alltrim(Substr(RCS->RCS_DESCRI,nIni,nQtd))+space(03)+RCS->RCS_CPFCGC)                      
					nDif 	:= (61-nTamLin) +1

    				If nIni == 1
						aAdd(aComplem,{strzero(nItem,02) +". "+ Substr(RCS->RCS_DESCRI,nIni,nQtd)+space(01),space(13)} ) 
                    ElseIf nDif >=0 .and. nDif <= 61  
						aAdd(aComplem,{space(04) +alltrim(Substr(RCS->RCS_DESCRI,nIni,nQtd))+space(03)+RCS->RCS_CPFCGC+space(nDif), TRANSFORM(RCS->RCS_VALOR,"@E 99,999,999.99") } )
					Else
						aAdd(aComplem,{space(04) + Substr(RCS->RCS_DESCRI,nIni,nQtd)+space(01),space(13) } )
					EndIf	
					
					nIni += nQtd
				    nQtd := If( 200-nIni > 57,57,200-nIni )
				Enddo

		    Else                                     
		    	If nTipRel== 1 //FORMULARIO PRE IMPRESSO
					aAdd(aComplem,{strzero(nItem,02) +". "+ Substr(RCS->RCS_DESCRI,1,35) +space(03)+RCS->RCS_CPFCGC+space(06), TRANSFORM(RCS->RCS_VALOR,"@E 99,999,999.99") } )
				Else
					If len(Alltrim(RCS->RCS_DESCRI))>  69
						
						nIni := 1
						nQtd := 81  
						While nIni < 200
							nTamLin := len(space(04) +alltrim(Substr(RCS->RCS_DESCRI,nIni,nQtd))+space(03)+RCS->RCS_CPFCGC)                      
							nDif 	:= (81-nTamLin) +1

    						If nIni == 1
								aAdd(aComplem,{strzero(nItem,02) +". "+ SUBSTR(RCS->RCS_DESCRI,nIni,nQtd),"" } )
							ElseIf nDif >=0 .and. nDif <= 81  
								aAdd(aComplem,{space(04)+SUBSTR(RCS->RCS_DESCRI,nIni,nQtd)+SPACE(03)+ RCS->RCS_CPFCGC+space(nDif), TRANSFORM(RCS->RCS_VALOR,"@E 99,999,999.99") } )
							Else
								aAdd(aComplem,{space(04) + Substr(RCS->RCS_DESCRI,nIni,nQtd)+space(01),space(13) } )
							EndIf
							nIni += nQtd
						    nQtd := If( 200-nIni > 81,81,200-nIni )
						Enddo
					Else
						aAdd(aComplem,{strzero(nItem,02) +". "+ Alltrim(RCS->RCS_DESCRI) +space(03)+RCS->RCS_CPFCGC+space(06), TRANSFORM(RCS->RCS_VALOR,"@E 99,999,999.99") } )
					EndIf	
				EndIf
	 		EndIf	
			nItem++
		Else
			aAdd(aComplem,{SPACE(04)+ RCS->RCS_NOME +space(23), "" } )
		Endif               
	EndIf
	If !EMPTY(RCS->RCS_OUTROS) .or. AllTrim(RCS->RCS_TIPORE) <> "R"
		cDescOred += If(!empty(alltrim(cDescOred)),", ","")+ alltrim(RCS->RCS_OUTROS)
	EndIf

	RCS->(dbSkip())

Enddo

dbSelectArea ( "SR4" )
IF dbSeek ( SRL->RL_FILIAL+SRL->RL_MAT+SRL->RL_CPFCGC+SRL->RL_CODRET+ cAno  )
	While ! Eof() .AND. SR4->R4_FILIAL == SRL->RL_FILIAL .AND. SR4->R4_MAT == SRL->RL_MAT .AND. ;
			SR4->R4_CPFCGC == SRL->RL_CPFCGC .AND. SR4->R4_CODRET == SRL->RL_CODRET .AND. SR4->R4_ANO == cAno
		    If Len(Alltrim(SR4->R4_TIPOREN)) == 1
				If ! Alltrim(SR4->R4_TIPOREN) $ "ABD"
					dbSkip()
					Loop
				EndIf	
				If Alltrim(SR4->R4_TIPOREN) == "D"
					nTotIR    := nTotIR + SR4->R4_VALOR
				Endif
			EndIf
			dbSkip()
	Enddo      

	If cIRRetido == 1
		If nTotIR <= 0
			Return Nil
		Endif
	EndIf	
		
	//ExecBlock("IMPIRPJ",.F.,.F.)

Endif
Return Nil

// Funcao para apresentar o botao da impressora no html
Static Function BotImpIRPF()                                                
Return( '<p align="right"><a href="javascript:Imprimir();"><img src="' + TcfRetDirImg() + '/imprimir.gif" width="90" height="28" hspace="20" border="0"></a></p>' )

// Funcao para trocar o indicador **botaoframe*** pelo tracejado separador dos INFORMES
Static Function TracoDuplo()
Local cTracoDupl := ""

cTracoDupl += '	<p &nbsp;</p>'
cTracoDupl += '	<p &nbsp;</p>'
cTracoDupl += ' <table frame="above" width="100%"> '
cTracoDupl += ' 	<tr> '
cTracoDupl += ' 		<td width = "0%" style = "border-style: dotted" ></td> '
cTracoDupl += '			<p &nbsp;</p>'
cTracoDupl += ' 	</tr> '
cTracoDupl += ' </table> '

Return( cTracoDupl )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºFuncao    ³fDescIncid0    ºAutor  ³Allyson M 	 ?Data ? 23/02/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³funcao para alimentar variavel cDescOred quando verba for   º±?
±±?         ³tipo de incidencia '0' - abono pecuniario.       			  º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºParametros?                                                           º±
±±?         ?                                                           º±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±
±±ºUso       ?GPEM580                                                    º±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function fDescIncid0()

Local aArea		:= GetArea()
Local aAreaSRA	:= SRA->( GetArea() )
Local aStru		:= {}
Local cAliasSRA	:= "SRA"
Local cAliasSRD	:= "SRD"
Local cCPFBenef	:= ""
Local cDescri	:= ""
Local cDtPesqF	:= cAno+"1231"
Local cDtPesqI	:= cAno+"0101"
Local cQuery	:= ""
Local cTipDirf	:= ""
Local lQuerySRD	:= .F.
Local nX		:= 0

//Procura funcionarios com mesmo CPF
cCPFBenef := fDesc( "SRA", SRL->RL_MAT, "RA_CIC", , SRL->RL_FILIAL )

dbSelectArea( "SRA" )	
dbSetOrder( RetOrdem( "SRA" , "RA_CIC+RA_FILIAL+RA_MAT" , .T. ) )

#IFDEF TOP
	If TcSrvType() <> "AS/400"
		cAliasSRA 	:= "m580MontSRA"
		If ( Select( cAliasSRA ) > 0 )
			(cAliasSRA)->( dbCloseArea() )
		EndIf 
		cQuery 	:= "SELECT SRA.RA_FILIAL, SRA.RA_MAT, SRA.RA_CIC, SRA.D_E_L_E_T_ "		
		cQuery 	+= " FROM " + RetSqlName("SRA") + " SRA "
		cQuery 	+= " WHERE SRA.RA_CIC  = '" + cCPFBenef + "'"
		cQuery 	+= " AND SRA.D_E_L_E_T_ = ' ' "
		cQuery 	+= " ORDER BY " + SqlOrder( SRA->( IndexKey() ) )

		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSRA, .T., .T.)

		dbSelectArea( cAliasSRA )	
	Else
#ENDIF
		(cAliasSRA)->( MsSeek( cCPFBenef, .T. ) )
#IFDEF TOP
	EndIf
#ENDIF

While (cAliasSRA)->( !Eof() ) .And. (cAliasSRA)->RA_CIC == cCPFBenef
	//Varre o SRD de cada funcionario com mesmo CPF para procurar verba com incidencia tipo '0'
	dbSelectArea( "SRD" )	
	#IFDEF TOP
		If TcSrvType() != "AS/400"
			cAliasSRD 	:= "m580MontSRD"
			lQuerySRD	:= .T.
			If ( Select( cAliasSRD ) > 0 )
				(cAliasSRD)->( dbCloseArea() )
			EndIf 
			aStru  	:= SRD->( dbStruct() )
			cQuery 	:= "SELECT * "		
			cQuery 	+= " FROM " + RetSqlName("SRD") + " SRD "
			cQuery 	+= " WHERE SRD.RD_FILIAL  = '" + (cAliasSRA)->RA_FILIAL + "'"
			cQuery 	+= " AND SRD.RD_MAT = '" + (cAliasSRA)->RA_MAT + "'"
			cQuery 	+= " AND SRD.RD_DATPGT BETWEEN '"+ cDtPesqI + "' AND '"+ cDtPesqF +"'"
			cQuery 	+= " AND SRD.RD_EMPRESA = '" + Space( Len( cEmpAnt ) ) + "'"
			cQuery 	+= " AND SRD.D_E_L_E_T_ = ' ' "
			cQuery 	+= " ORDER BY " + SqlOrder( SRD->( IndexKey() ) )
	
			cQuery := ChangeQuery( cQuery )
			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasSRD, .T., .T.)
	
			For nX := 1 To Len( aStru )
				If aStru[nX][2] != "C" .And. FieldPos( aStru[nX][1] ) != 0
					TcSetField( cAliasSRD, aStru[nX][1], aStru[nX][2], aStru[nX][3], aStru[nX][4] )
				EndIf
			Next nX
	
			dbSelectArea( cAliasSRD )	
		Else
	#ENDIF
			(cAliasSRD)->( MsSeek( (cAliasSRA)->RA_FILIAL + (cAliasSRA)->RA_MAT + cValToChar( Val( cAno ) - 1 ) + "12", .T. ) )
	#IFDEF TOP
		EndIf
	#ENDIF
	
	While (cAliasSRD)->( !Eof() ) .And. (cAliasSRA)->RA_FILIAL + (cAliasSRA)->RA_MAT == (cAliasSRD)->RD_FILIAL + (cAliasSRD)->RD_MAT
		If (cAliasSRD)->RD_EMPRESA == Space( Len( cEmpAnt ) ) .And. dToS( (cAliasSRD)->RD_DATPGT ) >= cDtPesqI .And. dToS( (cAliasSRD)->RD_DATPGT ) <= cDtPesqF
			PosSrv( (cAliasSRD)->RD_PD, (cAliasSRA)->RA_FILIAL )
			cDescri  := Alltrim( SRV->RV_DESC )
			cTipDirf := AllTrim( SRV->RV_DIRF )	
			If cTipDirf == "0"
				If At( cDescri, cDescOred ) == 0
					cDescOred += If( !Empty( AllTrim( cDescOred ) ), ", ", "" ) + cDescri
				Endif
			EndIf
		EndIf
	(cAliasSRD)->( dbSkip() ) 
	End While
	
	(cAliasSRD)->( dbCloseArea() )
	
	If Empty(cDescOred)
	
		cAliasRCS 	:= "m580MontRCS"
		If ( Select( cAliasRCS ) > 0 )
			(cAliasRCS)->( dbCloseArea() )
		EndIf 
		
		cQuery 	:= "SELECT RCS_DESCRI "		
		cQuery 	+= " FROM " + RetSqlName("RCS") + " RCS "
		cQuery 	+= " WHERE RCS.RCS_FILIAL  = '" + (cAliasSRA)->RA_FILIAL + "' AND "
		cQuery 	+= " RCS.RCS_MAT  = '" + (cAliasSRA)->RA_MAT + "' AND"
		cQuery 	+= " RCS.RCS_TIPORE  = '0' AND"
		cQuery 	+= " RCS.D_E_L_E_T_ = ' ' "
		
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), cAliasRCS, .T., .T.)
		
		While (cAliasRCS)->(!EOF())
			cDescri := (cAliasRCS)->RCS_DESCRI
			If At( cDescri, cDescOred ) == 0
				cDescOred += If( !Empty( AllTrim( cDescOred ) ), ", ", "" ) + cDescri
			EndIf	
			(cAliasRCS)->( dbSkip() ) 
		End While 
		(cAliasRCS)->( dbCloseArea() )	
	EndIf

	(cAliasSRA)->( dbSkip() ) 
End While

If ( Select( cAliasSRA ) > 0 )
	(cAliasSRA)->( dbCloseArea() )
EndIf 

#IFDEF TOP
	//(cAliasSRA)->( dbCloseArea() )
	If lQuerySRD
		If ( Select( cAliasSRD ) > 0 )
			(cAliasSRD)->( dbCloseArea() )	
		Endif
	EndIf
#ENDIF

RestArea( aAreaSRA )
RestArea( aArea )

Return(Nil)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³AjustaSX1 ?                                   ?Data ? // º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?                                                           º±?
±±?         ?                                                           º±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±
±±ºUso       ?GPEM580                                                    º±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/

Static Function AjustaSx1()

Local aEstrut   := {}
Local aSX1      := {}
Local aStruDic  := SX1->( dbStruct() )
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nTam1     := Len(&("SX1->X1_GRUPO"))
Local nTam2     := Len(&("SX1->X1_ORDEM"))

AutoGrLog( "Ínicio da Atualização " + cAlias + CRLF )

aEstrut := { "X1_GRUPO"  , "X1_ORDEM"  , "X1_PERGUNT", "X1_PERSPA" , "X1_PERENG" , "X1_VARIAVL", "X1_TIPO"   , ;
             "X1_TAMANHO", "X1_DECIMAL", "X1_PRESEL" , "X1_GSC"    , "X1_VALID"  , "X1_VAR01"  , "X1_DEF01"  , ;
             "X1_DEFSPA1", "X1_DEFENG1", "X1_CNT01"  , "X1_VAR02"  , "X1_DEF02"  , "X1_DEFSPA2", "X1_DEFENG2", ;
             "X1_CNT02"  , "X1_VAR03"  , "X1_DEF03"  , "X1_DEFSPA3", "X1_DEFENG3", "X1_CNT03"  , "X1_VAR04"  , ;
             "X1_DEF04"  , "X1_DEFSPA4", "X1_DEFENG4", "X1_CNT04"  , "X1_VAR05"  , "X1_DEF05"  , "X1_DEFSPA5", ;
             "X1_DEFENG5", "X1_CNT05"  , "X1_F3"     , "X1_PYME"   , "X1_GRPSXG" , "X1_HELP"   , "X1_PICTURE", ;
             "X1_IDFIL"  }

//
// Perguntas PTNGPEM580
//
dbSelectArea( "SX1" )
SX1->( dbSetOrder( 1 ) )
If SX1->( dbSeek( PadR( "PTNGPEM580", nTam1 ) ) )
	Return
EndIf

aAdd( aSX1, { ;
	'PTNGPEM580'															, ; //X1_GRUPO
	'01'																	, ; //X1_ORDEM
	'Filial De ?'															, ; //X1_PERGUNT
	'¿De Sucursal ?'														, ; //X1_PERSPA
	'From Branch ?'															, ; //X1_PERENG
	'mv_ch1'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	4																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par01'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	''																		, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	'XM0'																	, ; //X1_F3
	'S'																		, ; //X1_PYME
	'033'																	, ; //X1_GRPSXG
	'.RHFILDE.'																, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'PTNGPEM580'															, ; //X1_GRUPO
	'02'																	, ; //X1_ORDEM
	'Filial At??'															, ; //X1_PERGUNT
	'¿A Sucursal ?'															, ; //X1_PERSPA
	'To Branch ?'															, ; //X1_PERENG
	'mv_ch2'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	4																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par02'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'zzzz'																	, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	'XM0'																	, ; //X1_F3
	'S'																		, ; //X1_PYME
	'033'																	, ; //X1_GRPSXG
	'.RHFILAT.'																, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'PTNGPEM580'															, ; //X1_GRUPO
	'03'																	, ; //X1_ORDEM
	'C.N.P.J. De ?'															, ; //X1_PERGUNT
	'¿De CNPJ ?'															, ; //X1_PERSPA
	'From C.N.P.J. Number ?'												, ; //X1_PERENG
	'mv_ch3'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	14																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par03'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'12749710000106'														, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	'S'																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'PTNGPEM580'															, ; //X1_GRUPO
	'04'																	, ; //X1_ORDEM
	'C.N.P.J. Ate ?'														, ; //X1_PERGUNT
	'¿A CNPJ ?'																, ; //X1_PERSPA
	'To C.N.P.J. Number ?'													, ; //X1_PERENG
	'mv_ch4'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	14																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par04'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'12749710000106'														, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	'S'																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'PTNGPEM580'															, ; //X1_GRUPO
	'05'																	, ; //X1_ORDEM
	'Matricula De ?'														, ; //X1_PERGUNT
	'¿De Matricula ?'														, ; //X1_PERSPA
	'From Registration ?'													, ; //X1_PERENG
	'mv_ch5'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	6																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par05'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'000143'																, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	'SRA'																	, ; //X1_F3
	'S'																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	'.RHMATD.'																, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'PTNGPEM580'															, ; //X1_GRUPO
	'06'																	, ; //X1_ORDEM
	'Matricula At??'														, ; //X1_PERGUNT
	'¿A Matricula ?'														, ; //X1_PERSPA
	'To Registration ?'														, ; //X1_PERENG
	'mv_ch6'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	6																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par06'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'000143'																, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	'SRA'																	, ; //X1_F3
	'S'																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	'.RHMATA.'																, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'PTNGPEM580'															, ; //X1_GRUPO
	'07'																	, ; //X1_ORDEM
	'S?com IR Retido ?'													, ; //X1_PERGUNT
	'¿Solo con Imp Gan Retenido ?'											, ; //X1_PERSPA
	'Only w/ Withheld IR ?'													, ; //X1_PERENG
	'mv_ch7'																, ; //X1_VARIAVL
	'N'																		, ; //X1_TIPO
	1																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	2																		, ; //X1_PRESEL
	'C'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par07'																, ; //X1_VAR01
	'Sim'																	, ; //X1_DEF01
	'Si'																	, ; //X1_DEFSPA1
	'Yes'																	, ; //X1_DEFENG1
	''																		, ; //X1_CNT01
	''																		, ; //X1_VAR02
	'Nao'																	, ; //X1_DEF02
	'No'																	, ; //X1_DEFSPA2
	'No'																	, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	'S'																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'PTNGPEM580'															, ; //X1_GRUPO
	'08'																	, ; //X1_ORDEM
	'Ano-calendario?'														, ; //X1_PERGUNT
	'¨Ano-calendario?'														, ; //X1_PERSPA
	'Ano-calendario?'														, ; //X1_PERENG
	'mv_ch8'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	4																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par08'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	''																		, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	''																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'PTNGPEM580'															, ; //X1_GRUPO
	'09'																	, ; //X1_ORDEM
	'Nome Responsavel ?'													, ; //X1_PERGUNT
	'¿Nombre Responsable ?'													, ; //X1_PERSPA
	'Responsible`s Name ?'													, ; //X1_PERENG
	'mv_ch9'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	30																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par09'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'CARLOS TROTTA'															, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	'S'																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'PTNGPEM580'															, ; //X1_GRUPO
	'10'																	, ; //X1_ORDEM
	'Centro de Custo de ?'													, ; //X1_PERGUNT
	'¿De Centro de Costo ?'													, ; //X1_PERSPA
	'From Cost Center ?'													, ; //X1_PERENG
	'mv_ch0'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	20																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par10'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	''																		, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	'CTT'																	, ; //X1_F3
	'S'																		, ; //X1_PYME
	'004'																	, ; //X1_GRPSXG
	'.RHCCDE.'																, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'PTNGPEM580'															, ; //X1_GRUPO
	'11'																	, ; //X1_ORDEM
	'Centro de Custo ate ?'													, ; //X1_PERGUNT
	'¿A Centro de Costo ?'													, ; //X1_PERSPA
	'To Cost Center ?'														, ; //X1_PERENG
	'mv_cha'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	20																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par11'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'ZZZZZZZZZZZZZZZZZZZ'													, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	'CTT'																	, ; //X1_F3
	'S'																		, ; //X1_PYME
	'004'																	, ; //X1_GRPSXG
	'.RHCCAT.'																, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'PTNGPEM580'															, ; //X1_GRUPO
	'12'																	, ; //X1_ORDEM
	'Tipo de Formulario ?'													, ; //X1_PERGUNT
	'¿Tipo de Formulario?'													, ; //X1_PERSPA
	'Type of Form?'															, ; //X1_PERENG
	'mv_chb'																, ; //X1_VARIAVL
	'N'																		, ; //X1_TIPO
	1																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	1																		, ; //X1_PRESEL
	'C'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par12'																, ; //X1_VAR01
	'PDF'																	, ; //X1_DEF01
	'PDF'																	, ; //X1_DEFSPA1
	'PDF'																	, ; //X1_DEFENG1
	''																		, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	''																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'PTNGPEM580'															, ; //X1_GRUPO
	'13'																	, ; //X1_ORDEM
	'Categoria ?'															, ; //X1_PERGUNT
	'¿Categoria ?'															, ; //X1_PERSPA
	'Class ?'																, ; //X1_PERENG
	'MV_CHC'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	15																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	'fCategoria'															, ; //X1_VALID
	'mv_par13'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'ACDEGHIJMPST'															, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	'S'																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	'.RHCATEG.'																, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'PTNGPEM580'															, ; //X1_GRUPO
	'14'																	, ; //X1_ORDEM
	'Situacoes ?'															, ; //X1_PERGUNT
	'¿Situaciones ?'														, ; //X1_PERSPA
	'Status ?'																, ; //X1_PERENG
	'MV_CHD'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	5																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	'fSituacao'																, ; //X1_VALID
	'mv_par14'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'ADFT'																	, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	'S'																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	'.RHSITUA.'																, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'PTNGPEM580'															, ; //X1_GRUPO
	'15'																	, ; //X1_ORDEM
	'Imprimir pessoa ?'														, ; //X1_PERGUNT
	'¨Imprimir pessoa?'														, ; //X1_PERSPA
	'Imprimir pessoa?'														, ; //X1_PERENG
	'mv_che'																, ; //X1_VARIAVL
	'N'																		, ; //X1_TIPO
	1																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	1																		, ; //X1_PRESEL
	'C'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par15'																, ; //X1_VAR01
	'Fisica'																, ; //X1_DEF01
	'Fisica'																, ; //X1_DEFSPA1
	'Fisica'																, ; //X1_DEFENG1
	''																		, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	''																		, ; //X1_F3
	''																		, ; //X1_PYME
	''																		, ; //X1_GRPSXG
	''																		, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'PTNGPEM580'															, ; //X1_GRUPO
	'16'																	, ; //X1_ORDEM
	'Depto. De ?'															, ; //X1_PERGUNT
	'¿De Depto. ?'															, ; //X1_PERSPA
	'Depart From ?'															, ; //X1_PERENG
	'MV_CHF'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	9																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par16'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	''																		, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	'SQB'																	, ; //X1_F3
	'S'																		, ; //X1_PYME
	'025'																	, ; //X1_GRPSXG
	'.RHDPTDE.'																, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'PTNGPEM580'															, ; //X1_GRUPO
	'17'																	, ; //X1_ORDEM
	'Depto. Ate ?'															, ; //X1_PERGUNT
	'¿A Depto. ?'															, ; //X1_PERSPA
	'Depart To ?'															, ; //X1_PERENG
	'MV_CHG'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	9																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'mv_par17'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'ZZZZZZZZZ'																, ; //X1_CNT01
	''																		, ; //X1_VAR02
	''																		, ; //X1_DEF02
	''																		, ; //X1_DEFSPA2
	''																		, ; //X1_DEFENG2
	''																		, ; //X1_CNT02
	''																		, ; //X1_VAR03
	''																		, ; //X1_DEF03
	''																		, ; //X1_DEFSPA3
	''																		, ; //X1_DEFENG3
	''																		, ; //X1_CNT03
	''																		, ; //X1_VAR04
	''																		, ; //X1_DEF04
	''																		, ; //X1_DEFSPA4
	''																		, ; //X1_DEFENG4
	''																		, ; //X1_CNT04
	''																		, ; //X1_VAR05
	''																		, ; //X1_DEF05
	''																		, ; //X1_DEFSPA5
	''																		, ; //X1_DEFENG5
	''																		, ; //X1_CNT05
	'SQB'																	, ; //X1_F3
	'S'																		, ; //X1_PYME
	'025'																	, ; //X1_GRPSXG
	'.RHDPTAT.'																, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

//
// Atualizando dicionário
//

nPosPerg:= aScan( aEstrut, "X1_GRUPO"   )
nPosOrd := aScan( aEstrut, "X1_ORDEM"   )
nPosTam := aScan( aEstrut, "X1_TAMANHO" )
nPosSXG := aScan( aEstrut, "X1_GRPSXG"  )

dbSelectArea( "SX1" )
SX1->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSX1 )

	//
	// Verifica se o campo faz parte de um grupo e ajusta tamanho
	//
	If !Empty( aSX1[nI][nPosSXG]  )
		SXG->( dbSetOrder( 1 ) )
		If SXG->( MSSeek( aSX1[nI][nPosSXG] ) )
			If aSX1[nI][nPosTam] <> &("SXG->XG_SIZE")
				aSX1[nI][nPosTam] :=&("SXG->XG_SIZE")
			EndIf
		EndIf
	EndIf

	If !SX1->( dbSeek( PadR( aSX1[nI][nPosPerg], nTam1 ) + PadR( aSX1[nI][nPosOrd], nTam2 ) ) )
		RecLock( "SX1", .T. )
	Else
		RecLock( "SX1", .F. )
	EndIf

	For nJ := 1 To Len( aSX1[nI] )
		If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nJ], 10 ) } ) > 0
			SX1->( FieldPut( FieldPos( aEstrut[nJ] ), aSX1[nI][nJ] ) )
		EndIf
	Next nJ

	MsUnLock()

Next nI


Return

***************************************************************************************************************************************************

Static Function SendIt()
Local cAttach	  := "\html\PTN_logo"+cFilAnt+".jpg"     //"\html\PTN_arrow.jpg",
Local _lRet       := .T.
Local cLog        := "" 
Private cBody := ""

cErrUsr := ""        

cBody :=" <html>" 
cBody +=" <head>" 
cBody +="   <meta content='text/html; charset=ISO-8859-1' http-equiv='content-type'>" 
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
±±³Parametros?ExpC1 : Conta para conexao com servidor SMTP                 ³±?
±±?         | ExpC2 : Password da conta para conexao com o servidor SMTP   ³±?
±±?         ?ExpC3 : Servidor de SMTP                                    ³±?
±±?         ?ExpC4 : Conta de origem do e-mail. O padrao eh a mesma conta ³±?
±±?         ?       de conexao com o servidor SMTP.                      ³±?
±±?         ?ExpC5 : Conta de destino do e-mail.                          ³±?
±±?         ?ExpC6 : Assunto do e-mail.                                   ³±?
±±?         ?ExpC7 : Corpo da mensagem a ser enviada.                        |±±
±±?         | ExpC8 : Patch com o arquivo que serah enviado               |±±
±±?         | ExpC9 : .T. Exibir mensagem de erro, .f. não exibir msg      |±±
±±?         | ExpC10 : Parâmetro por referência, armazena o erro de envio |±±
/*/
For n_x := 1 to Len(aHTM)
cLog := ""


	If !Empty(aHTM[n_x][2])    

		CpyT2S(lower(cPathPDF+aHTM[n_x][4]+".pdf"),lower("\html") ) 
		//ACSendMail(_cUser,_cPass,_cServer,_cFrom,aHTM[n_x][2],Replace(_cSubject,"?,"e"),cBody,cAttach+","+lower("\html\"+aHTM[n_x][4]+".pdf"),.T.,cLog)

		_lRet := xACSendMail(_cUser,_cPass,_cServer,_cFrom,aHTM[n_x][2],Replace(_cSubject,"?","e"),cBody,cAttach+","+lower("\html\"+aHTM[n_x][4]+".pdf"),.T.,@cLog)
		//_lRet := xACSendMail(_cUser,_cPass,_cServer,_cFrom,"vinicius.figueiredo@criareconsulting.com",Replace(_cSubject,"?","e"),cBody,cAttach+","+lower("\html\"+aHTM[n_x][4]+".pdf"),.T.,@cLog)
		
		If !Empty(cLog)
		   //MsgAlert("Erro ao enviar e-mail: " + cLog)
		   cELog += aHTM[n_x][3]+" E-mail: "+aHTM[n_x][2]+" Hora "+Time()+" erro "+cLog+CRLF
		Else
 	       cXLog += aHTM[n_x][3]+" E-mail: "+aHTM[n_x][2]+" Hora "+Time()+CRLF
		Endif                     

		cLastProc := lower(cPathPDF+aHTM[n_x][4]+".pdf")		
		
		FErase(cLastProc)		
	

	Else
		cErrUsr += aHTM[n_x][3]+CRLF
		aAdd(aErr,{cErrUsr})
	   cELog += aHTM[n_x][3]+" E-mail: "+aHTM[n_x][2]+" Hora "+Time()+" erro sem e-mail cadastrado"+CRLF		
	Endif
	
Next n_x 


return      

*********************************************************************************************************************************

/*/                                                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±?
±±³Fun‡„o    ?xACSendMail?                                                ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Descri‡„o ?Rotina para o envio de emails                                ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Parametros?ExpC1 : Conta para conexao com servidor SMTP                 ³±?
±±?         | ExpC2 : Password da conta para conexao com o servidor SMTP   ³±?
±±?         ?ExpC3 : Servidor de SMTP                                     ³±?
±±?         ?ExpC4 : Conta de origem do e-mail. O padrao eh a mesma conta ³±?
±±?         ?        de conexao com o servidor SMTP.                      ³±?
±±?         ?ExpC5 : Conta de destino do e-mail.                          ³±?
±±?         ?ExpC6 : Assunto do e-mail.                                   ³±?
±±?         ?ExpC7 : Corpo da mensagem a ser enviada.               	    |±±
±±?         | ExpC8 : Patch com o arquivo que serah enviado                |±±
±±?         | ExpC9 : .T. Exibir mensagem de erro, .f. não exibir msg      |±±
±±?         | ExpC10 : Parâmetro por referência, armazena o erro de envio  |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±?Uso      ?SIGAGAC                                                      ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?

±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?                

ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
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
	If Alltrim(cFrom) == Alltrim( GetMV( "MV_RELACNT" ) ) .or. Alltrim(cFrom) == Alltrim( GetMV( "MV_RELFROM" ) ) // verifica se est?utilizando o email do parametro global
		cFrom := cFromGe
	EndIf	
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Envia o e-mail para a lista selecionada. Envia como CC                         ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
If At(Chr(59),cEmail) > 0
	cEmailTo := SubStr(cEmail,1,At(Chr(59),cEmail)-1)
	cEmailCc := SubStr(cEmail,At(Chr(59),cEmail)+1,Len(cEmail))
Else
	cEmailTo := cEmail
	cEmailCc := ""
EndIf

CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Verifica se o Servidor de EMAIL necessita de Autenticacao?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
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
	BODY    	cMensagem ;
	ATTACHMENT  cAttach  ;
	RESULT lResult

	
	If !lResult
		//Erro no envio do email
		GET MAIL ERROR cError
		If lMsg
			//Help(" ",1,"ATENCAO",,STR0286 + cEmailTo +" ."+ STR0289,4,5)
		EndIf
		cLog := "Não foi possível enviar o e-mail para:" + cEmailTo 	
	EndIf
	
	DISCONNECT SMTP SERVER
	
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	If lMsg		
		//Help(" ",1,"ATENCAO",,STR0288 +" "+ STR0287+cError,4,5)
	EndIf
	cLog := "Não foi possível conectar com o servidor SMTP!" +" "+ "Mensagem de Erro:"+cError	
EndIf

Return(lResult)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetPrevidencia    ºAutor ³Oswaldo Leiteº Data ³  02/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Obtem valores da previdencia exceto rv_dirf referente a     º±±
±±º          ³ decimo terceiro                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GPEM580                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
static function GetPrevidencia(cFil, cAno, cMat, cRlCodRet)
Local cGetAlias  := GetNextAlias()
Local nSomaTotal := 0

BeginSql Alias cGetAlias
	SELECT	SUM(M9_VALOR) TOTAL
	FROM	%Table:SM9%  
	WHERE	M9_FILIAL   = %Exp:( cFil )%
	  AND	M9_ANO      = %Exp:( cAno )% 
	  AND	M9_MAT      = %Exp:( cMat )%
	  AND	( M9_CODRET = %Exp:( cRlCodRet )%  OR  M9_CODRET = '1889' )  
	  AND	M9_TIPOREN  NOT IN ( 'M1', 'M5', 'M6', 'M7', '91', '9D', '9F', '9G' )
	  AND	%NotDel% 
EndSql

If ( cGetAlias )->( !Eof() )
	nSomaTotal := ( cGetAlias )->TOTAL
EndIf

(cGetAlias)->(DbCLoseArea())

Return nSomaTotal

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetPensao         ºAutor ³Oswaldo Leiteº Data ³  02/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Obtem valores da pensao                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GPEM580                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GetPensao(cFil, cAno, cMat, cRlCodRet)
Local cGetAlias  := GetNextAlias()
Local nSomaTotal := 0

BeginSql Alias cGetAlias
		SELECT SUM(M8_VALOR) TOTAL  
		FROM   %table:SM8%  
		WHERE  M8_FILIAL   =  %Exp:( cFil )%
		  AND  M8_ANO      =  %Exp:( cAno )% 
		  AND  M8_MAT      =  %Exp:( cMat )%
		  AND  M8_TIPOREN	=  'C '
		  AND  ( M8_CODRET =  %Exp:( cRlCodRet )%  OR  M8_CODRET = '1889')
		  AND  %NotDel%
EndSql

If (cGetAlias)->(!Eof())
	nSomaTotal := (cGetAlias)->(TOTAL)
EndIf

(cGetAlias)->(DbCLoseArea())

Return nSomaTotal

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetExcPrevidencia ºAutor ³Oswaldo Leiteº Data ³  02/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Obtem valores de 13o da previdencia                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GPEM580                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static function GetExcPrevidencia(cFil, cAno, cMat, cRlCodRet)
Local cGetAlias  := GetNextAlias()
Local nSomaTotal := 0

BeginSql Alias cGetAlias
	SELECT SUM(M9_VALOR)	TOTAL
	FROM   %table:SM9%  
	WHERE  M9_FILIAL   =  %Exp:( cFil )%
	  AND  M9_ANO      =  %Exp:( cAno )% 
	  AND  M9_MAT      =  %Exp:( cMat )%
	  AND  ( M9_CODRET =  %Exp:( cRlCodRet )%  OR  M9_CODRET = '1889')  
	  AND  M9_TIPOREN  IN ('M1','M5','M6','M7','91','9D','9E','9F')
	  AND  %NotDel% 
EndSql

If (cGetAlias)->(!Eof())
	nSomaTotal := (cGetAlias)->(TOTAL)
EndIf

(cGetAlias)->(DbCLoseArea())

return nSomaTotal

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³Get13oPensao        ºAutor ³Oswaldo Leiteº Data ³  02/01/17 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Obtem valores da pensao (13º)                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GPEM580                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Get13oPensao(cFil, cAno, cMat, cRlCodRet)
Local cGetAlias  := GetNextAlias()
Local nSomaTotal := 0

BeginSql Alias cGetAlias
		SELECT SUM(M8_VALOR) TOTAL  
		FROM   %table:SM8%  
		WHERE  M8_FILIAL   =  %Exp:( cFil )%
		  AND  M8_ANO      =  %Exp:( cAno )% 
		  AND  M8_MAT      =  %Exp:( cMat )%
		  AND  M8_TIPOREN  IN ('C1', '81')  
		  AND  ( M8_CODRET =  %Exp:( cRlCodRet )%  OR  M8_CODRET = '1889')
		  AND  %NotDel%
EndSql

If (cGetAlias)->(!Eof())
	nSomaTotal := (cGetAlias)->(TOTAL)
EndIf

(cGetAlias)->(DbCLoseArea())

Return nSomaTotal

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetC2Pensao         ºAutor ³Oswaldo Leiteº Data ³  02/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Obtem valores da pensao                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GPEM580                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GetC2Pensao(cFil, cAno, cMat, cRlCodRet)
Local cGetAlias  := GetNextAlias()
Local nSomaTotal := 0

BeginSql Alias cGetAlias
		SELECT SUM(M8_VALOR) TOTAL  
		FROM   %table:SM8%  
		WHERE  M8_FILIAL   = %Exp:( cFil )%
		  AND  M8_ANO      = %Exp:( cAno )% 
		  AND  M8_MAT      = %Exp:( cMat )%
		  AND  M8_TIPOREN  = %Exp:( 'C2' )%  
		  AND  ( M8_CODRET = %Exp:( cRlCodRet )%  OR  M8_CODRET = '1889')
		  AND  %NotDel%
EndSql


If (cGetAlias)->(!Eof())
	nSomaTotal := (cGetAlias)->(TOTAL)
EndIf

(cGetAlias)->(DbCLoseArea())

Return nSomaTotal

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GetC3Pensao       ºAutor ³Marcos COutinhoº Data ³  10/02/17 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Obtem valores da pensao PLR                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GPEM580                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GetC3Pensao(cFil, cAno, cMat, cCodPLR)
Local cGetAlias  := GetNextAlias()
Local nSomaTotal := 0

BeginSql Alias cGetAlias
		SELECT SUM(M8_VALOR) TOTAL  
		FROM   %table:SM8%  
		WHERE  M8_FILIAL   = %Exp:( cFil )%
		  AND  M8_ANO      = %Exp:( cAno )% 
		  AND  M8_MAT      = %Exp:( cMat )%
		  AND  M8_TIPOREN  = %Exp:( 'C3' )%  
		  AND  ( M8_CODRET = %Exp:( cCodPLR )%  OR  M8_CODRET = '3562')
		  AND  %NotDel%
EndSql


If (cGetAlias)->(!Eof())
	nSomaTotal := (cGetAlias)->(TOTAL)
EndIf

(cGetAlias)->(DbCLoseArea())

Return nSomaTotal




