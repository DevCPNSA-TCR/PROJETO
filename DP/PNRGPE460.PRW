#INCLUDE "Protheus.CH"
#INCLUDE "GPER460.CH"
#INCLUDE 'FILEIO.CH'

Static _cRepDb	:= GetSrvProfString("RepositInDataBase","")
Static _cRep	:= SuperGetMv("MV_REPOSIT",.F.,"1")
Static _lRepDb	:= ( _cRepDb == "1" .And. _cRep == "2" )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER460    ³ Autor ³ R.H. - Mauro              ³ Data ³ 04.06.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Ficha Registro                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GpeR460(void)                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alteração³ Yttalo P. Martins                                                ³±±
±±³          ³ Alterar método de impressão para txt em formato contínuo         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
*/
User Function PNRGPE460()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cDesc1	:=	STR0001						//"Ficha de Registro"
LOCAL cDesc2 	:=	STR0002						//"Ser  impresso de acordo com os parametros solicitados pelo"
LOCAL cDesc3 	:=	STR0003						//"usuario."
LOCAL cString	:=	"SRA"						// alias do arquivo principal (Base)
LOCAL aOrd 		:=	{STR0004,STR0005,STR0006}	//"Matricula"###"Centro de Custo"###"Nome"
LOCAL wnRel         
Local aArea		:= GetArea()
Local n

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas para Filtro                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cFiltraSRA				//Variavel para filtro
Private aIndexSRA	:= {}		//Variavel Para Filtro
Private bFiltraBrw  := {|| Nil}	//Variavel para Filtro

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis PRIVATE(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn := { STR0007, 1,STR0008, 2, 2, 1, "",1 }  //"Zebrado"###"Administra‡„o"
PRIVATE nomeprog:="PNRGPE460"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="PNRGPE460"//"GPR460"
Private nChar	:= 18

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE Titulo  := STR0009  //"FICHA DE REGISTRO"
PRIVATE cCabec
PRIVATE AT_PRG  := "PNRGPE460"
PRIVATE wCabec0 := 9
PRIVATE wCabec1:=""
PRIVATE wCabec2:=""
PRIVATE wCabec3:=""
PRIVATE wCabec4:=""
PRIVATE wCabec5:=""
PRIVATE wCabec6:=""
PRIVATE wCabec7:=""
PRIVATE wCabec8:=""
PRIVATE wCabec9:=""
PRIVATE CONTFL:=1
PRIVATE LI:=0
PRIVATE nTamanho:="P"
PRIVATE cPathPict	:= ""
Private lImpDIni	:= .T.
Private lImpDFim	:= .T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis PRIVATE(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cIndCond
PRIVATE cFor
PRIVATE nOrdem  := 1
PRIVATE aInfo	:=	{}

Private oPrint , i:= 1
Private oTamFont,oFont07,oFont08,oFont08n,oFont08C, oFont10, oFont15, oFont10n, oFont21, oFont12,oFont12n,oFont16
Private nLin := nLinha:= 0, nColuna := 50
Private aCampo:= {}
Private nlinMax	:= 3040
Private nColMax := 2350
Private nColBox := 2200
Private lFirst	:= .T.
Private aFotos	:= {}			//armazena nome  foto 

Private nTipFicha := 1
Private lNewProf  := SuperGetMv("MV_NCPROF",,"2") == "1" // 1-Novo calculo da folha de professores; 2-Calculo antigo da folha de professores

Default _cRepDb	:= GetSrvProfString("RepositInDataBase","")
Default _cRep	:= SuperGetMv("MV_REPOSIT",.F.,"1")
Default _lRepDb	:= ( _cRepDb == "1" .And. _cRep == "2" )

//--Altera o Set Epch para 1920
nEpoca := SET( 5,1920)

// Criacao da funcao AjustaSX3 para atualizacao do Inic. Padrao para permitir impressao
// da descricao do cargo (RA_DCARGO) de uma filial a qual o usuario nao esteja logado.
// Inclusao de mesmo tratamento para o NOME DO SINDICATO.
AjustaSx3()
AjustaSx1() // Inclusao de pergunte

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
iF !Pergunte(cPerg,.T.)
	RETURN
eNDiF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         					³
//³ mv_par01        //  Filial  De                              				 	³
//³ mv_par02        //  Filial  Ate                             			 		³
//³ mv_par03        //  Centro de Custo De                      			 		³
//³ mv_par04        //  Centro de Custo Ate                    				  		³
//³ mv_par05        //  Matricula De                             					³
//³ mv_par06        //  Matricula Ate                            					³
//³ mv_par07        //  Nome De                                  					³
//³ mv_par08        //  Nome Ate                                 					³
//³ mv_par09        //  Situacao                                 					³
//³ mv_par10        //  Categoria                                					³
//³ mv_par11        //  Ficha Atualizada                        					³
//³ mv_par12        //  Alt. Salariais                           					³
//³ mv_par13        //  Afastamentos                             					³
//³ mv_par14        //  Dependentes                              					³
//³ mv_par15        //  Ferias                                   					³
//³ mv_par16        //  Alt. Cadastrais                          					³
//³ mv_par17        //  Contrib. Sindicais                       					³
//³ mv_par18        //  Transferencias                           					³
//³ mv_par19        //  Beneficiarios                            					³
//³ mv_par20        //  Impr.Desc. Filial                        					³
//³ mv_par21        //  Impressao Grafica                        					³
//³ mv_par22        //  Data inicio de impressao                				    ³
//³ mv_par23        //  Data final de impressao                  					³
//³ mv_par24        //  Nome Responsavel Legal                   					³
//³ mv_par25        //  Imprime Tarefas( Fixas/Variaveis/Ambas)                     ³
//³ mv_par26        //  Prof./Tarefeiros Imprime(Historico Salarial/Tarefas/Ambos)  ³
//³ mv_par27        //  Titulo Relatorio: 											³
//³						  	   1-Ficha de Registro  	  							³
//³                       	   2-Ficha de Anotacoes e Atualizacoes da CTPS e PREVID.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FilialDe	:= mv_par01
FilialAte	:= mv_par02
CcDe     	:= mv_par03
CcAte    	:= mv_par04
MatDe    	:= mv_par05
MatAte   	:= mv_par06
NomDe    	:= mv_par07
NomAte   	:= mv_par08
cSit     	:= mv_par09
cCat     	:= mv_par10
nFicha   	:= 1//mv_par11
nSalar   	:= mv_par11//mv_par12
nAfast   	:= mv_par12//mv_par13
nDepen   	:= 2//mv_par14
nFerias  	:= mv_par13//mv_par15
nAltcad	 	:= mv_par14//mv_par16
nConSin	 	:= mv_par15//mv_par17		
nTransf		:= mv_par16//mv_par18
nBenefic	:= 2//mv_par19
nFilial		:= 1//mv_par20
nGrafica	:= 2//mv_par21
dDataIni	:= mv_par17//mv_par22
dDataFin	:= mv_par18//mv_par23
cResponsavel:= SPACE(10)//mv_par24
uTarefa		:= "  "//mv_par25
nImpSalTar	:= 1//mv_par26
nTitulo 	:= 1//mv_par27
nContAss 	:= 2//mv_par28
nTipFicha 	:= 1//nTitulo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
//³Ajustada flag para tratar como altera := .t., pois o inicializador de campo     ³
//³X3_RELACAO usa INCLUI para buscar a descrição do campo quando "V"irtual.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
INCLUI := .F.
ALTERA := .T.

cFiltraRh 	:= CHKRH("GPEA260","SRA","1")
bFiltraBrw 	:= {|| FilBrowse("SRA",@aIndexSRA,@cFiltraRH) }

If nLastKey = 27
	Eval(bFiltraBrw)
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica preenchimento dos campos datas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty( dDataIni )
	lImpDIni:= .F.
	dDataIni := CTOD( "01/01/1900", "DDMMYYYY" )
Endif
If Empty( dDataFin )
	lImpDFim:= .F.
	dDataFin := CTOD( "31/12/2099", "DDMMYYYY" )
Endif
dDataFin := Max( dDataFin, dDataIni )

If nLastKey = 27
	Eval(bFiltraBrw)
	Return
Endif                  	

Titulo  := "FICHA DE ANOTACOES E ATUALIZACOES DA C.T.P.S."

RptStatus({|lEnd| GR460Imp(@lEnd,wnRel,cString)},Titulo)
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Restaura Area e Ordem de Entrada                              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
RestArea( aArea)
Eval(bFiltraBrw)

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPR460Imp³ Autor ³ R.H. - Ze Maria       ³ Data ³ 03.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Folha de Pagamanto                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ GPR460Imp(lEnd,wnRel,cString)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd        - A‡Æo do Codelock                             ³±±
±±³          ³ wnRel       - T¡tulo do relat¢rio                          ³±±
±±³          ³ cString     - Mensagem                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GR460Imp(lEnd,WnRel,cString)

Local cAcessaSRA  := &("{ || " + ChkRH("GPER460","SRA","2") + "}")
Local nLinhas	:= 0      

Local nHdl
Local lFirst := .T.
Local x := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private	lImpressao	:= .F.  				//-- Define se houve impressao da informacao 
Private aDicioT := {}			//Array contendo os campos do SX3
Private nCampo	:= 0
Private nAgrup	:= 01
Private aAgrup	:= {}			//Array contendo os agrupamentos cadastrados no GPEFICHA

Private cNomeArq := ALLTRIM(MV_PAR19)+IIF( SUBSTR(MV_PAR19,LEN(MV_PAR19),1) == "\","","\" )//"C:\temp\"+DTOS(ddatabase)
Private cLin,cTemp := ""

cNomeArq := cNomeArq+"ATUALIZACOES DA C.T.P.S._"+DTOS(ddatabase)

If File(cNomeArq)
	FErase(cNomeArq)
Endif   

nHdl := FCreate(cNomeArq)
If nHdl == -1
   MsgAlert("O arquivo "+cNomeArq+" nao pode ser criado! Verifique os parametros.","Atencao !")
   Return
Else
	fClose(nHdl)
Endif

dbSelectArea( "SRA" )
dbGoTop()

If nOrdem == 1
	dbSetOrder(1)
	dbSeek(FilialDe + MatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim     := FilialAte + MatAte
ElseIf nOrdem == 2
	dbSetOrder(2)
	dbSeek(FilialDe + CcDe + MatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := FilialAte + CcAte + MatAte
ElseIf nOrdem == 3
	dbSetOrder(3)
	dbSeek(FilialDe + NomDe + MatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim     := FilialAte + NomAte + MatAte
Endif

SetRegua(SRA->(RecCount()))
                                                 	
cFilAnterior 	:= Space(FWGETTAMFILIAL)
cCcAnt       	:= Space(09)

DbSelectArea("SRA")
aDicioT := SRA->(DbStruct())
//Percorre todos os campos da estrutura da tabela
For x := 1 To Len(aDicioT)
    //Chama a função que adiciona ao array via @, conforme o campo atual, e o tipo é 4 que será usado em um MsNewGetDados
    u_zX3ToArr(@aDicioT, aDicioT[x][1], 4)
Next
/*dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SRA")
While ! Eof() .And. GetSx3Cache(cFieldX3,"X3_ARQUIVO") = 'SRA'
	uCampo := GetSX3Cache(cCampo, "X3_CAMPO")
	If (__lPyme	.and. GetSx3Cache("X3_PYME")="N" ) 
		SX3->(dbSkip())
		loop
	Endif

	nCampo := nCampo + 1 
    If cPaisLoc == "BRA"    
    	If cNivel >= GetSx3Cache("X3_NIVEL")
    		Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (GetSX3Cache(cFieldX3, "X3_USADO"),"X"," ")+"]"+Space(5)+GetSx3Cache(cCampo,"X3_CAMPO")+Space(3)+STRZEROs(GetSx3Cache("X3_tamanho",3))+STRZERO(GetSx3Cache("X3_DECIMAL",2)+ strzero(nAgrup,2)+ Strzero(nCampo,3)))      
    	Endif	
	Else
		If X3USO(GetSx3Cache("X3_USADO")) .Or. !Empty(Substr(GetSx3Cache("X3_RESERV"),8,1))
			Aadd(aDicioT, X3Titulo()+Space(14)+CHR(179)+"["+If (X3USO(GetSx3Cache("x3_usado")),"X"," ")+"]"+Space(5)+GetSx3Cache("X3_CAMPO")+Space(3)+STRZERO(GetSx3Cache("X3_tamanho",3))+STRZERO(GetSX3CaChe("X3_DECIMAL",2)+ strzero(nAgrup,2)+ Strzero(nCampo,3)))
		Endif
	EndIf
	dbSkip()
Enddo*/

dbSelectArea( "SRA" )
While !EOF() .And. &cInicio <= cFim
	
	IncRegua()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Consiste Parametrizacao do Intervalo de Impressao            ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If (SRA->RA_NOME < NomDe) .Or. (SRA->RA_NOME > NomAte) .Or. ;
        (SRA->RA_MAT < MatDe)  .Or. (SRA->RA_MAT > MatAte)  .Or. ;
        (SRA->RA_CC < CcDe)    .Or. (SRA->RA_CC > CcAte)
		dbSelectArea( "SRA" )
		dbSkip()
		Loop
    Endif

    If  !(Sra->Ra_SitFolh $ cSit) .Or. !(Sra->Ra_CatFunc $ cCat)
		dbSelectArea( "SRA" )
		dbSkip()
		Loop
    Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
		dbSelectArea( "SRA" )
		dbSkip()
		Loop
	EndIf

    IF  SRA->RA_FILIAL # cFilAnterior
        If ! fInfo(@aInfo,Sra->ra_Filial)
			Exit
		Endif
	Endif
    
    nHdl := FOpen( cNomeArq, 2 )
	If nHdl == -1
    	MsgAlert("Ocorreu um erro na abertura do arquivo "+cNomeArq+".","Atencao !")
    	Exit	
	EndIf
	
	FSeek( nHdl, 0 , FS_END )
    //If lFirst == .T.

	    cLin := Replicate("*",80)+chr(13)+chr(10)
	    cTemp:= "*"+SM0->M0_NOME+"/"+SM0->M0_FILIAL
	    cLin += cTemp+Replicate(" ",79-LEN(cTemp))+"*"+chr(13)+chr(10)
	    cTemp:= "*SIGA/PNRGPE460/ FICHA DE ANOTAÇÕES E ATUALIZAÇÕES DA CTPS"
	    cLin += cTemp+Replicate(" ",79-LEN(cTemp))+"*"+chr(13)+chr(10)
	    cTemp:= "*Emissão: "+DTOC(dDataBase)
	    cLin += cTemp+Replicate(" ",79-LEN(cTemp))+"*"+chr(13)+chr(10)
	    cTemp:= "*Hora: "+TIME()
	    cLin += cTemp+Replicate(" ",79-LEN(cTemp))+"*"+chr(13)+chr(10)
	    cLin += Replicate("*",80)+chr(13)+chr(10)
	    
	    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	    	MsgAlert("Ocorreu um erro na gravação do arquivo "+cNomeArq+".","Atencao !")
	    	Exit
	    Endif
    
    //EndIf
    fClose(nHdl)
    lFirst := .F.    
	
	cLin := ""
	cTemp:= "*"+ ALLTRIM(aInfo[3])
	cLin += cTemp+Replicate(" ",79-LEN(cTemp))+"*"+chr(13)+chr(10)
	cTemp:= "*"+ ALLTRIM(STR0011 + aInfo[1])
	cLin += cTemp+Replicate(" ",79-LEN(cTemp))+"*"+chr(13)+chr(10)	
	cTemp:= "*"+ alltrim(aInfo[4]) + " - " + If(len( AllTrim( ainfo[14] ) ) > 0  , AllTrim( aInfo[14] ) + " - " + AllTrim( aInfo[13] ), AllTrim( aInfo[13] ) )
	cLin += cTemp+Replicate(" ",79-LEN(cTemp))+"*"+chr(13)+chr(10)	
	cTemp:= "*"+ ALLTRIM( ALLTRIM(aInfo[5]) + " - " + aInfo[6] + space(3)+ STR0031 + Transform(aInfo[7],"@R #####-###") )
	cLin += cTemp+Replicate(" ",79-LEN(cTemp))+"*"+chr(13)+chr(10)

	If aInfo[15] == 1 .Or. ( Len(aInfo) >= 27 .And. !Empty( aInfo[27] ) )	
		cTemp:= "*"+ ALLTRIM(STR0047  + If( !Empty( aInfo[27] ), aInfo[27], Transform(aInfo[8],"@R ##.###.###/####-##") )+space(5) + STR0033  + aInfo[16]+space(5)+STR0034  + aInfo[19] )
	Else
		cTemp:= "*"+ ALLTRIM(STR0032  + Transform(aInfo[8],"@R 99.999.999/9999-99")+space(5) + STR0033  + aInfo[16]+space(5)+STR0034  + aInfo[19] )
	EndIf
	cLin += cTemp+Replicate(" ",79-LEN(cTemp))+"*"+chr(13)+chr(10)
	
	cTemp:= "*"+ALLTRIM(STR0004  + "  " +SRA->RA_FICHA + " "+ SRA->RA_MAT + " - " + SRA->RA_NOME )
	cLin += cTemp+Replicate(" ",79-LEN(cTemp))+"*"+chr(13)+chr(10)
	cLin += Replicate("*",80)+chr(13)+chr(10)
	
	nHdl := FOpen( cNomeArq, 2 )
	If nHdl == -1
    	MsgAlert("Ocorreu um erro na abertura do arquivo "+cNomeArq+".","Atencao !")
    	Exit	
	EndIf
	
	FSeek( nHdl, 0 , FS_END )
	
	If fWrite(nHdl,cLin,Len(cLin)) < Len(cLin)
    	MsgAlert("Ocorreu um erro na gravação do arquivo "+cNomeArq+".","Atencao !")
    	Exit
    Endif
    fClose(nHdl)    
	
	lImpressao	:= .F.
	  
	If nFicha == 1
		fImpFch()
	Endif
	
	If nSalar == 1
		fImpSal()
	Endif       
	
	If nAfast == 1 .Or. nAfast == 3
		fImpAfas()
	Endif       
	
	If nferias == 1
		fImpFer()
	Endif
	
	If nAltcad == 1
		fImpCad()
	Endif

	If nDepen == 1
		fImpDep()
	Endif     
	
	If nBenefic == 1
		fImpBen()
	Endif     

	If nConSin == 1 .or. nContAss == 1
		fImpSin()
	Endif    
    
	If nTransf == 1
		fImpTra()
	Endif  

	If lImpressao 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Periodo de impressao                                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		fImpPeriodo()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Observação                                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		fImpObs()		 
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Assinaturas                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//fAssinaBox() 
	Endif	

	aCampo 	:= {}      	
	lFirst	:= .T. 
	dbSelectarea("SRA")
	dbSkip()
Enddo         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SRA")
If U_fType("cFiltraRH") == "U" .Or. Empty(cFiltraRH)
Set Filter to
EndIf
dbSetOrder(1)
dbGoTop()

If File(cNomeArq)
	AVISO("AVISO!","Arquivo "+cNomeArq+" criado!",{"Ok"})
Endif  

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpFch  ³ Autor ³ R.H. - Mauro          ³ Data ³ 04.06.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Ficha Atualizada                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpFch()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpfch()
Local aArea		:= GetArea()
Local aAreaSX3	:= {}
Local cCabCpo,cCampo,cFolder,cOrdem
Local cTipoX3 := ""
Local FieldX3 := ""
Default cCampox3 := ""



Private	nPosT

cDet    := " "
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SRA")
While ( !Eof() .And. GetSx3Cache(FieldX3,"X3_ARQUIVO") == "SRA" )

uCampo := GetSx3Cache(cCampox3,"X3_CAMPO")
	
	If Alltrim(uCampo) $ 'RA_FILIALxRA_MATxRA_NOMEXRA_BITMAPXRA_FICHA'
		dbSelectArea("SX3")
		dbSkip()
		Loop
	Endif	
	
	nPosT := Ascan(aDicioT,{|X| Subs(X,36,10) == uCampo })
	
	If nPosT <> 0 .And. Subs(aDicioT[nPosT],29,1) == 'X'
		IF ( GetSx3Cache(FieldX3,"X3_CONTEXT") == "V" )
			aAreaSX3:= SX3->( GetArea() )
			dbSelectArea("SRA")
			cCampo 	:= CriaVar(GetSx3Cache(cCampox3,"X3_CAMPO"))
			RestArea( aAreaSX3 )
		Else                                      
			cCampo 	:= SRA->( FieldGet(FieldPos(uCampo)) )  
			If alltrim(ucampo) == "RA_SEXO"
				cCampo	:= fDescSexo( cCampo)
			ElseIf alltrim(ucampo) == "RA_TPCONTR"
				cCampo 	:= If (!Empty( cCampo), If(cCampo = "1",STR0066, STR0067),"")
 			ElseIf alltrim(ucampo) == "RA_RACACOR"
				If cCampo =="1"
					cCampo	:= STR0068			//-- Indigena 
				elseIf cCampo=="2"
					cCampo := STR0069 			//-- Branca
				elseif cCampo = "4"
					cCampo := STR0070			//-- Negra
				elseif cCampo = "6"
					cCampo := STR0071			//-- Amarela
				elseif cCampo = "8"
					cCampo := STR0072			//-- Parda 
				elseif cCampo = "9"
					cCampo := STR0073 			//-- Nao Informado
				Endif
			ElseIf alltrim(uCampo) == "RA_DEFIFIS"
				cCampo	:= If(cCampo == "1",STR0074, STR0075) 
			ElseIf alltrim(uCampo) == "RA_ESTCIVI" 
				cCampo := Substr(fDesc("SX5","33"+cCampo,"X5DESCRI()"),1,12)      
			ElseIf alltrim(uCampo) == "RA_TPDEFFI"
				Do Case                
					Case cCampo == "0"
						cCampo := STR0101		//Nenhuma
					Case cCampo == "1"
						cCampo := STR0102       //Fisica
			   		Case cCampo == "2"
				   		cCampo := STR0103		//Auditiva	
					Case cCampo == "3"
				   		cCampo := STR0104		//Visual
					Case cCampo == "4"
						cCampo := STR0105		//Mental
					Case cCampo == "5"			
				   		cCampo := STR0106		//Multipla
					Case cCampo == "6"
				   		cCampo := STR0107		//Reabilitado
					Otherwise
						cCampo := ""
				EndCase
			ElseIf alltrim(uCampo) == "RA_NACIONA" 
				cCampo := Substr( fDesc( "SX5", "34" + cCampo, "X5DESCRI()" ), 1, 25 )   
			//Else
			//	cCampo := SRA->( FieldGet(FieldPos(uCampo)) )
			EndIf
        Endif

		If ValU_fType(cCampo) = "D"
			cCampo := Dtoc(cCampo)
		Elseif ValU_fType(cCampo) = "N"
			cPict := "@E "+Replicate("9",Val(Subs(aDicioT[nPosT],49,3)) )
			If Val(Subs(aDicioT[nPosT],52,2)) > 0
				cPict += "."+Replicate("9",Val(Subs(aDicioT[nPosT],52,2)) )
			Endif
			cCampo := Transform(cCampo,cPict)
		ElseIf ValU_fType(cCampo)="L"
			If cCampo	:= .F.
				cCampo 	:= "F"
			Else
				cCampo	:= "T"
			Endif
		Endif
		cCabCpo := fTacento(AllTrim(Subs(aDicioT[nPosT],1,12)))
		cFolder := subs(aDicioT[nPosT],54,2) 
		cOrdem  := subs(aDicioT[nPosT],56,3)
		aAdd(aCampo,{cCabCpo,cCampo,cFolder,cOrdem,GetSx3Cache(cTipoX3,"X3_TIPO")})
	Endif		
	dbSelectArea("SX3")
	dbSkip()
EndDo  
aSort( aCampo,,,{ |x,y| x[3]+x[4] < y[3]+y[4] } )	
                 
If Len(aCampo) > 0 

	fImpNorm(aCampo)
	lImpressao	:= .T.
Endif

RestArea( aArea)
//--SET CENTURY OFF
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpSal  ³ Autor ³ R.H. - Mauro          ³ Data ³ 04.06.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao Alteracao Salarial                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpSal()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpSal()
Local aArea		:= GetArea()
Local aSal	    := {}
Local aTar	    := {}
Local cChaveSort:= ""
Local cMotivo	:= ""
Local nPosTp	:= SRO->( FieldPos( "RO_TPALT"	) )
Local lImpSal	:= .T.

If lNewProf
	lNewProf := nPosTp > 0 // So valida se o campo RO_TPALT estiver cadastrado
EndIf

//-- Professores e Tarefeiros
If SRA->RA_CATFUNC $ "I#J#T" .and. (nImpSalTar== 2 .or. nImpSalTar== 3)
	dbSelectArea("SRO")
	dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
	While SRO->( !EOF()) .And. SRO->RO_FILIAL+SRO->RO_MAT == SRA->RA_FILIAL+SRA->RA_MAT 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica periodo de impressao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SRO->RO_DATA < dDataIni .or. If(!empty(SRO->RO_DATAATE),SRO->RO_DATAATE > dDataFin,.F.)
			SRO->(dbSkip())
			Loop
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Filtra tipos de tarefas      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SRA->RA_CATFUNC $ "I#J"
			If cPaisLoc == "BRA"
				If !( SRO->RO_TIPO $ uTarefa )
					SRO->(dbSkip())
					Loop
				EndIf
			Else
				If ( uTarefa == 1 .And. SRO->RO_TIPO # "1" ) .Or. ( uTarefa == 2 .And. SRO->RO_TIPO # "2" )
					SRO->(dbSkip())
					Loop
				EndIf
			EndIf
		Endif
		 
		If SRO->RO_QUANT == 0
			SRO->(dbSkip())
			Loop
		Endif
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Cabecalho tabela               ³ 
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If Len(aSal) = 0 .And. Len(aTar) = 0
			If nGrafica == 1 .or. !(SRA->RA_CATFUNC $ "I#J")
				//---*** Professor ***---
				//" Tp. Tarefa  Data De    Data Ate   Tarefa                   Aulas Semana Qtde. Tarefa   Valor Unitario      Valor Total 
				//  xxxxxxxx    99/99/9999 99/99/9999 999-XXXXXXXXXXXXXXXXXXXX   999,999.99 9,999,999.99 999,999,999.9999 999,999,999.9999 
				Aadd(aTar ,{STR0086,STR0087,STR0088,STR0089,STR0090,STR0091,STR0092,STR0093,""}) //STR0094,STR0095
			Else
						//  Data De |Data Ate|Tarefa        |Aul/Sem.|Q.Tar.|  Vl. Unitario|     Vl Total
				Aadd(aTar ,{STR0086,STR0087,STR0088,STR0089,STR0096,STR0097,STR0098,STR0093,""}) //STR0094,STR0095
			EndIf
		Endif
		cChaveSort := DTOS(SRO->RO_DATA)+StrZero(SRO->RO_VALOR,15)+StrZero(SRO->(Recno()),15) + "0"
        //cTipoTar := If( SRO->RO_TIPO == "1","Fixa","Variavel")
        
        If SRO->RO_TIPO == "1"
        	cTipoTar := OemtoAnsi(STR0114)	//"Fixa"
        ElseIf SRO->RO_TIPO  == "2"
        	cTipoTar := OemtoAnsi(STR0115)	//"Variavel"
        ElseIf SRO->RO_TIPO  == "3"
        	cTipoTar := OemtoAnsi(STR0116)	//"Adit. Fixo"
        ElseIf SRO->RO_TIPO  == "4"
        	cTipoTar := OemtoAnsi(STR0117) 	//"Adit. Var."
        EndIf
		
		If nGrafica == 1 .or. !(SRA->RA_CATFUNC $ "I#J")
			Aadd(aTar,{cTipoTar,DTOC(SRO->RO_DATA),DTOC(SRO->RO_DATAATE),SRO->RO_CODTAR+"-"+fDescTarefa(SRO->RO_CODTAR),Transform(SRO->RO_QTDSEM,"@E 9,999,999.99"),Transform(SRO->RO_QUANT,"@E 9,999,999.99"),Transform(SRO->RO_VALOR,"@E 99,999,999.99"),Transform(SRO->RO_VALTOT,"@E 99,999,999.99"),cChaveSort })
   		Else
			Aadd(aTar,{cTipoTar,DTOC(SRO->RO_DATA),DTOC(SRO->RO_DATAATE),SRO->RO_CODTAR+"-"+fDescTarefa(SRO->RO_CODTAR),Transform(SRO->RO_QTDSEM,"@E 999.99"),Transform(SRO->RO_QUANT,"@E 999.99"),Transform(SRO->RO_VALOR,"@E 99,999,999.99"),Transform(SRO->RO_VALTOT,"@E 99,999,999.99"),cChaveSort })
		EndIf
		
		// Impressao do motivo da alteracao da tarefa
		If lNewProf .And. SRA->RA_CATFUNC $ "I*J" .And. !Empty(SRO->RO_TPALT)
		
			dbSelectArea( "SX5" )
			If dbSeek( xFilial( "SX5" ) + "41" + SRO->RO_TPALT )
				cMotivo := fTAcento( SubStr(X5Descri(),1,31) )						
			Endif

			If !Empty(cMotivo)
				Aadd(aTar,{"","","",STR0119+cMotivo,"","","","",Soma1(cChaveSort)})
			EndIf

			dbSelectArea("SRO")
		EndIf

		SRO->( dbSkip() )
	EndDo
EndIf
          
lImpSal := .T.
                                                                           
lImpSal := If ( SRA->RA_CATFUNC $ "I#J#T" .and. nImpSalTar== 2 ,.F., lImpSal)

If lImpSal
	dbSelectArea("SR7")               
	DbSetOrder(1)
	dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
	While SR7->( !EOF()) .And. SRA->RA_FILIAL+SRA->RA_MAT = SR7->R7_FILIAL+SR7->R7_MAT
	
		nVez := 0
	    dbSelectArea("SR3")
		DbSetOrder(1)
	    dBseek(SR7->R7_FILIAL+SR7->R7_MAT+DTOS(SR7->R7_DATA)+SR7->R7_TIPO)
	    While SR3->( !EOF()) .And. SRA->RA_FILIAL+SRA->RA_MAT = SR3->R3_FILIAL+SR3->R3_MAT .And. ;
	                  SR3->R3_DATA = SR7->R7_DATA .And. SR7->R7_TIPO = SR3->R3_TIPO
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica periodo de impressao³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If SR3->R3_DATA < dDataIni .or. SR3->R3_DATA > dDataFin
				dbSkip()
				Loop
			Endif
	
			/*
			ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			³ Cabecalho tabela               ³ 
			ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
			If Len(aSal) = 0
				If SR7->( U_fType("R7_DESCCAR") ) # "U"
					Aadd(aSal ,{STR0013,STR0014,STR0016,STR0053,STR0054,STR0055,STR0035,STR0063, "" }) 	//###"Desc.Cargo"
				Else
					Aadd(aSal ,{STR0013,STR0014,STR0016,STR0053,STR0054,STR0055,STR0035,"", "" })
				EndIf	
				//" Data        Desc.Aumento            Cat.   Pgto.      Verba                          Valor    Funcao" 
				//  99/99/9999  xxxxxxxxxxxxxxxxxxxx     x      x         xxxxxxxxxxxxxxxxxxxx   99.999.999,99    xxxxxxxxxxxxxx
			Endif
			
			dbSelectArea("SX5")
			dbSeek(xFilial("SX5")+"41"+SR7->R7_TIPO)
			If ! eof()
				cDescS := fTAcento(SUBS(X5Descri(),1,20))
			Else 
				cDescS := STR0017  //"Nao Cad. Tabela(41) "
			Endif
			dbSelectArea("SR3")
			cChaveSort := DTOS(SR7->R7_DATA)+StrZero(SR3->R3_VALOR,15)+StrZero(SR3->(Recno()),15) + "0"
			If nVez = 0
				If SR7->( U_fType("R7_DESCCAR") ) # "U"
					Aadd(aSal,{DTOC(SR7->R7_DATA),cDescS,SR7->R7_CATFUNC,SR7->R7_TIPOPGT,Subs(SR3->R3_DESCPD,1,20),Transform(SR3->R3_VALOR,"@E 99,999,999.99"),SR7->R7_DESCFUN,SR7->R7_DESCCAR,cChaveSort })
				Else	
					Aadd(aSal,{DTOC(SR7->R7_DATA),cDescS,SR7->R7_CATFUNC,SR7->R7_TIPOPGT,Subs(SR3->R3_DESCPD,1,20),Transform(SR3->R3_VALOR,"@E 99,999,999.99"),SR7->R7_DESCFUN,"",cChaveSort })
				EndIf
				nVez := 1
			Elseif nVez = 1
				nPosS := Len(aSal)
				If SR7->( U_fType("R7_DESCCAR") ) # "U"
					Aadd(aSal,{"","","","",Subs(SR3->R3_DESCPD,1,20),Transform(SR3->R3_VALOR,"@E 99,999,999.99"),SR7->R7_DESCFUN,SR7->R7_DESCCAR, cChaveSort })
				Else
					Aadd(aSal,{"","","","",Subs(SR3->R3_DESCPD,1,20),Transform(SR3->R3_VALOR,"@E 99,999,999.99"),SR7->R7_DESCFUN,"", cChaveSort })
				EndIf
				nVez := 2
			Else
				If SR7->( U_fType("R7_DESCCAR") ) # "U"
					Aadd(aSal,{"","","","",Subs(SR3->R3_DESCPD,1,20),Transform(SR3->R3_VALOR,"@E 99,999,999.99"), SR7->R7_DESCFUN,SR7->R7_DESCCAR, cChaveSort })
				Else
					Aadd(aSal,{"","","","",Subs(SR3->R3_DESCPD,1,20),Transform(SR3->R3_VALOR,"@E 99,999,999.99"), SR7->R7_DESCFUN,"", cChaveSort })
				EndIf
			Endif
			dbSkip()
		Enddo
		dbSelectArea("SR7")
		dbSkip()
	Enddo 
EndIf
If !empty(aSal) .and. Len(aSal) > 1
	fImpSalN(aSal,"S")	
	lImpressao	:= .T. 
Endif

If !empty(aTar) .and. Len(aTar) > 1

	aSort( aTar,,,{ |x,y| x[9] < y[9] } )

	fImpSalN(aTar,"T")	
	lImpressao	:= .T. 
Endif

RestArea( aArea)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpAfas ³ Autor ³ R.H. - Mauro          ³ Data ³ 04.06.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ impressao de afastamentos                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpAfas()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpAfas()
Local aArea		:= GetArea()

Local aAfas := {}

dbSelectArea("SR8")
dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
While ! Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT = SR8->R8_FILIAL+SR8->R8_MAT

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica periodo de impressao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SR8->R8_DATAINI < dDataIni .or. SR8->R8_DATAINI > dDataFin
		dbSkip()
		Loop
	Endif

	If Len(aAfas) = 0
		Aadd(aAfas,{STR0013,STR0019,STR0020,STR0022})  //"|Data       Tipo                                   Data Inicio      Data Fim   "
	Endif
   	
	dbSelectArea("SX5")
	dbSeek(xFilial("SX5")+"30"+SR8->R8_TIPO)
	If ! eof()
		cDescA := fTacento(SUBS(X5Descri(),1,60))
	Else
       cDescA := STR0061
	Endif
	
	dbSelectArea("SR8")
	If nAfast != 3
		If SR8->R8_TIPO # "F"
			Aadd(aAfas,{DTOC(SR8->R8_DATA),alltrim(cDescA),DTOC(SR8->R8_DATAINI),DTOC(SR8->R8_DATAFIM) })
		EndIf                
	Else
		If SR8->R8_TIPO # "F" .And. (SR8->R8_DURACAO > 15 .Or. SR8->R8_TIPO $ "O|P|Q") 
			Aadd(aAfas,{DTOC(SR8->R8_DATA),alltrim(cDescA),DTOC(SR8->R8_DATAINI),DTOC(SR8->R8_DATAFIM) })
		EndIf                		
	EndIf
	dbSkip()
Enddo
If !Empty(aAfas) .and. Len(aAfas) > 1                      
	fImpAfasN(aAfas)
     lImpressao	:= .T.
Endif

RestArea( aArea)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpFer  ³ Autor ³ R.H. - Mauro          ³ Data ³ 04.06.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ impressao de Ferias                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpFer()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpFer()
Local aArea		:= GetArea()
Local aFerias := {}

dbSelectArea("SRH")
dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
While ! Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT = SRH->RH_FILIAL+SRH->RH_MAT

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica periodo de impressao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SRH->RH_DATAINI < dDataIni .or. SRH->RH_DATAINI > dDataFin
		dbSkip()
		Loop
	Endif

	If Len(aFerias) = 0
		Aadd(aFerias,{ STR0023,STR0056,STR0057,STR0058,STR0079,STR0080} )  //"|Periodo Aquisitivo   Periodo de Ferias       Data do Aviso    Data Pagto. D.Ferias d.Abono"
	Endif
	Aadd(aFerias,{DTOC(SRH->RH_DATABAS)+ " a "+DTOC(SRH->RH_DBASEAT), ;
		          DTOC(SRH->RH_DATAINI) +" a " +DTOC(SRH->RH_DATAFIM), ;
        		  DTOC(SRH->RH_DTAVISO) , DTOC(SRH->RH_DTRECIB)      , ;
        		  STRZERO(SRH->RH_DFERIAS,2), STRZERO(SRH->RH_DABONPE,2) })
	dbSkip()
Enddo                         

If !Empty(aFerias) .and. Len(aFerias) > 1 

	fImpFeriaN(aFerias)	
	lImpressao	:= .T.
Endif	

RestArea( aArea)
Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpCad  ³ Autor ³ R.H. - Mauro          ³ Data ³ 04.06.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ impressao de Alt.Cadastrais                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpCad()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpCad()
Local aArea		:= GetArea()

Local aAltCad := {}
cDet    := ""


dbSelectArea("SR9")
dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
While ! Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT = SR9->R9_FILIAL+SR9->R9_MAT

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica periodo de impressao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SR9->R9_DATA < dDataIni .or. SR9->R9_DATA > dDataFin
		dbSkip()
		Loop
	Endif

	If Len(aAltCad) = 0
		Aadd(aAltCad,{ STR0013,STR0025,STR0059})  //"Data         Campo Alterado    Descricao"
	Endif
	nPos    := Ascan(aDicioT,{ |x| Subs(x,36,10)=SR9->R9_CAMPO })
	If nPos > 0
		cTitulo := fTAcento(Subs(aDicioT[nPos],1,12))
		Aadd(aAltCad,{DTOC(SR9->R9_DATA), cTitulo,SR9->R9_DESC	} )
	Endif
	dbSkip()
Enddo                                               
If !Empty(aAltCad) .and. Len(aAltCad) > 1

	fImpCadN(aAltCad)
	lImpressao	:= .T.
Endif

RestArea( aArea)
Return 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpDep  ³ Autor ³ R.H. - Mauro          ³ Data ³ 04.06.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ impressao de Dependentes                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpDep()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpDep()
Local aArea		:= GetArea()

Local aDep := {}
Local m_sexo		:= ""
Local m_graupar 	:= ""
Local m_TipIR		:= ""
Local m_TipSF		:= ""

dbSelectArea("SRB")
dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
While ! Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT = SRB->RB_FILIAL+SRB->RB_MAT
	If Len(aDep) = 0
		Aadd(aDep,{STR0027,STR0026,STR0037,STR0038,STR0040,STR0048,STR0050} )  //"|Cod|Dependente                     Dt.Nasc  Sexo Parent IR  S.F."
	Endif
    m_Sexo		:= fDescSexo(SRB->RB_SEXO)  
    
	//Correcao dos menus de opcoes RB_GRAUPAR
    If SRB->RB_GRAUPAR  == "F"
    	m_graupar	:=  STR0076		 //"Filho"
    ElseIf SRB->RB_GRAUPAR  == "C"
    	m_graupar 	:=  STR0077 	 //"Conjuge"
    ElseIf SRB->RB_GRAUPAR  == "P"
    	m_graupar 	:= STR0126		 //"Pai/Mae"
    ElseIf SRB->RB_GRAUPAR  == "E"
    	m_graupar 	:= STR0127	 	 //"Enteado" 
    Else
    	m_graupar 	:=  STR0078 	 //"Outros" 		
    EndIf          
    
    m_TipIR		:= If(SRB->RB_TIPIR =="4", STR0075, STR0074) 
    m_TipSF		:= If(SRB->RB_TIPSF =="3", STR0075, STR0074) 

	If ascan(aDep,{ |x| ( x[2] == SRB->RB_NOME .AND. x[3] == Dtoc(SRB->RB_DTNASC) ) } ) == 0
		Aadd(aDep,{SRB->RB_COD,SRB->RB_NOME,Dtoc(SRB->RB_DTNASC),M_SEXO,M_GRAUPAR,M_TIPIR,M_TIPSF })
	EndIf
	dbSkip()
Enddo
If !Empty(aDep) .and. Len(aDep) > 1
	fImpDepN(aDep)
	lImpressao	:= .T.
Endif

RestArea( aArea)
Return 
			

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpBen  ³ Autor ³ R.H. - Natie          ³ Data ³ 22.01.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao de Beneficiarios                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpBen()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpBen()
Local aArea		:= GetArea()

Local aBenef := {}

dbSelectArea("SRQ")
dbSeek(SRA->RA_FILIAL+SRA->RA_MAT)
While ! Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT = SRQ->RQ_FILIAL+SRQ->RQ_MAT
	If Len(aBenef) = 0
		Aadd(aBenef,{STR0027,STR0060} )  //"|Cod|Beneficiario                   
	Endif 
	If SRQ->RQ_ORDEM =="01"
		Aadd(aBenef,{SRQ->RQ_ORDEM,SRQ->RQ_NOME })
	Endif
	dbSkip()
Enddo
If !Empty(aBenef) .and. Len(aBenef) > 1

	fImpBenN(aBenef)
	lImpressao	:= .T.
Endif

RestArea( aArea)
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpSin  ³ Autor ³ R.H. - Marinaldo      ³ Data ³09/05/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao das Contribuicoes Sindicais                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpSin()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpSin()
Local aArea		:= GetArea()

Local aConSin	:=	{}
Local aConAss	:=	{}
Local aCodFol	:=	{}
Local aChave	:=	{}
Local aSindica	:=	{}
Local cChave	:=	""
Local cSindica	:=	""
Local cDescSin	:=	""
Local cSindAnt	:= ""
Local cDescAnt	:= ""

Local cDet		:=	""
Local nPos		:=	0
Local x			:=	0
Local dDataAux	:=	SRA->RA_ADMISSA
Local cDescACodFol	:= ""
Local lClasOutEmp 	:= .F.
nRecSRA			:= SRA->( Recno() )

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Carrega aCodFol                                              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
IF !Fp_CodFol(@aCodFol,SRA->RA_FILIAL)
   Return(.F.)
EndIF

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Seleciona o Arquivo de Transferencias e Retorna Todas as Transferencias  ³
³do Funcionario (Nao Gravara Filial + Matricula  Iguais 7o. Parametro de  ³
³fTransf). Somente preenche com transf. de Empresa e Filial, params 3 e 4.³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
fTransf(@aChave,,.T.,.T.,,,.T.,.T.)

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Grava em aChave  a Situacao Atual do Funcionario              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
IF aScan( aChave,{ |x| ( x[1] + x[2] ) == ( cEmpAnt + SRA->RA_FILIAL+SRA->RA_MAT ) } ) == 0
    	SRA->( aAdd(aChave,{									 ;
    						cEmpAnt								,; // 01 - Empresa Origem
    						RA_FILIAL+RA_MAT   					,; // 02 - Filial + Matricula Origem  
    						RA_CC								,; // 03 - Centro de Custo Origem
    						cEmpAnt								,; // 04 - Empresa Destino
    						RA_FILIAL+RA_MAT      				,; // 05 - Filial + Matricula Destino
    						RA_CC								,; // 06 - Centro de Custo Destino
							Nil									,; // 07 - Data da Transferencia
							RA_FILIAL							,; // 08 - Filial Origem
    						}									 ;
    				)											 ;
    		  )
Endif

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Verifica se Teve Alteracao de Sindicato                      ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
IF Len(aChave) > 0 
	For nPos := 1 To Len(aChave)
		cChave := aChave[nPos,2]
		IF SR9->( dbSeek( cChave + "RA_SINDICA" ,.T.) )
    		dbSelectArea('SR9')
			While SR9->( !Eof()  .and. R9_FILIAL+R9_MAT+R9_CAMPO == cChave + "RA_SINDICA" )
	        	/*
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³ Assume Sempre a Ultima Alteracao quando Feita no Mesmo Mes   ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	        	IF ( x := aScan( aSindica , { |y| MesAno( y[1] ) == MesAno( SR9->R9_DATA ) } ) ) > 0
	        		aSindica[x,1] := SR9->R9_DATA
	        	 	aSindica[x,2] := Subst(R9_DESC,1,2) 
					aSindica[x,3] := AllTrim( fDesc("RCE",Subst(SR9->R9_DESC,1,2),"RCE_DESCRI",40, SR9->R9_FILIAL ) )
	        	Else
	        		SR9->( aAdd( aSindica ,{ R9_DATA , Subst(R9_DESC,1,2),AllTrim( fDesc("RCE",Subst(R9_DESC,1,2),"RCE_DESCRI",40,R9_FILIAL))}))
  	   			EndIF
  	   			dbSelectArea('SR9')
  	   			dbSkip()
			EndDo
		EndIF
	Next nPos
EndIF

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Verifica Se houve Troca de Sindicato por transferencia de FILIAL.	³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
nRecSRA	:= SRA->( Recno() )
IF Len( aChave ) > 0
	For nPos := 1 To Len( aChave )
		If Len(aChave[nPos]) >= 8	// Se nao tiver todos os elementos, indica sindicato atual e nao processa neste bloco de codigo
			cSindica := Posicione("SRA",1,aChave[nPos,2],"RA_SINDICA")
			cDescSin := AllTrim( fDesc("RCE", cSindica, "RCE_DESCRI", 40, aChave[nPos,8]))
			IF ! Empty( aSindica ) .and. aChave[nPos,7] # Nil
				aAdd( aSindica , { aChave[nPos,7] , cSindica, cDescSin } )
			ElseIf aChave[nPos,7] # Nil
				aSindica := { { aChave[nPos,7], cSindica, cDescSin } }
			EndIf
		EndIf
	next nPos
EndIf
SRA->( DbGoTo( nRecSRA ) )

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Acrescenta o Sindicato Atual do Funcionario                  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
IF !Empty(aSindica)
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³A Data Correspondente ao Sindicato Atual Deve ser Sempre Maior³
	³Que a ultima Alteracao de Sindicato.                          ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	aAdd( aSindica , { IF( dDataBase > aSindica[ Len(aSindica), 1 ] .or. aSindica[ Len(aSindica), 1 ] == Nil, dDataBase, ( aSindica[Len(aSindica),1] + 360 ) ),;
					   SRA->RA_SINDICA, AllTrim( fDesc("RCE",SRA->RA_SINDICA,"RCE_DESCRI",40,SRA->RA_FILIAL) ) } )
Else
	aSindica := { { dDataBase , SRA->RA_SINDICA, AllTrim( fDesc("RCE",SRA->RA_SINDICA,"RCE_DESCRI",40,SRA->RA_FILIAL) ) } }
EndIF
cSindica := aSindica[ Len(aSindica) , 2 ]
cDescSin := AllTrim( fDesc("RCE",SRA->RA_SINDICA,"RCE_DESCRI",40,SRA->RA_FILIAL))
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Ordena as Alteracoes de Sindicato Ordem Crescente de Data    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aSort( aSindica,,,{ |x,y| x[1] < y[1] } )

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Preparando Dados Para a Impressao                            ³ 
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
dbSelectArea("SRD")
For nPos := 1 To Len(aChave)
	cChave	:=	aChave[nPos, 2]
	dbSeek(cChave)
	While SRD->( !Eof() .and. cChave = RD_FILIAL + RD_MAT )
		dDataAux	:=	SRA->RA_ADMISSA
  		lClasOutEmp 	:= .F.
  	    /*
  	    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ So Imprime verba de Contribuicao Sindical                    ³ 
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
       	IF !( SRD->RD_PD $ (  aCodFol[068,1] + '_' + aCodFol[246,1] + '_' + aCodFol[069,1] ) )  
       		SRD->( dbSkip() ) 
			Loop
	    /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³Se a contrib.sindical foi efetuada em outra empresa, a descr. ³
		³do sindicato sera a mesma do ID 246                           ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		ElseIf SRD->RD_PD $ aCodFol[246,1] .or.  (! Empty(SRD->RD_EMPRESA) .And. SRD->RD_EMPRESA # cEmpAnt) 
			cDescACodFol	:= fDesc("SRV",aCodFol[246,1], "RV_DESC") 
			lClasOutEmp 	:= .T. 
   	    EndIF 
   	    /*
  	    ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Verifica se a Verba pertence a empresa Atual                 ³ 
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		If 	cEmpAnt # aChave[nPos,1]
       		SRD->( dbSkip() ) 
        	Loop
   	    EndIF	

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica periodo de impressao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SRD->RD_DATARQ < MesAno(dDataIni) .or. SRD->RD_DATARQ > MesAno(dDataFin)
			SRD->(dbSkip())
			Loop
		Endif
   	    
        /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Cabecalho das Contribuicoes Sindicais                        ³ 
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		IF Len(aConSin) = 0
			Aadd(aConSin,{STR0013,STR0039 ,STR0055,STR0042,'H'} )	//"|Data        | Mes   | Valor            | Sindicato                     |"
        EndIF
		
		/*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Verifica se a Alteracao de Sindicato esta dentro do Periodo a³ 
		³ Ser Listado.                                                 ³ 
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		For x := 1 To Len( aSindica )
			IF SRD->RD_DATARQ >= MesAno( dDataAux ) .and. SRD->RD_DATARQ <= MesAno( aSindica[x,1] )
				If x # 1 .and. MesAno( aSindica[x,1] ) > MesAno( dDataAux ) 
		    		cSindica := cSindAnt
					cDescSin := cDescAnt
				Else
					cSindica := aSindica[x,2]
					cDescSin := aSindica[x,3]
				Endif
				Exit
		    EndIF 
	    	dDataAux	:= aSindica[x,1]
    		cSindAnt	:= aSindica[x,2]
	   	   	cDescAnt	:= aSindica[x,3]
		Next x 

		SRD->( Aadd(aConSin,{ DTOC(RD_DATPGT), Subst( RD_DATARQ , -2 ), Transform(RD_VALOR,"@E 999,999,999.99"), If(lClasOutEmp,cDescACodFol, cDescSin ) ,;
								IF( SRD->RD_PD $ ( aCodFol[069,1]), "A","S");
							} ))
		dbSelectArea("SRD")
		dbSkip()
	Enddo
Next nPos

If len(aConSin) > 1 
    
	aAux:=aClone(aConSin)  
        
    aConSin := {}
    aConAss := {}
	    
     aAdd(aConSin, aClone( aAux[1] ) ) 
     aAdd(aConAss, aClone( aAux[1] ) )	
	        
	Aeval(aAux,{|X| If(x[Len(X)] == "A", aAdd(aConAss, aClone(X) ), aAdd(aConSin, aClone(X)) )}, 2 )
	
  	IF Len(aConSin) > 1 .and. nConSin == 1 
		fImpSindN(aConSin, STR0036)
	Endif         
	
	IF Len(aConAss) > 1 .and. nContAss == 1
		fImpSindN(aConAss, STR0125)
	Endif	
	lImpressao	:= .T.
Endif

RestArea( aArea )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fImpTra  ³ Autor ³ R.H. - Marinaldo      ³ Data ³10/05/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impressao das Transferencias                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ fImpTra()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static function fImpTra()
Local aArea		:= GetArea()

Local aTransf	:=	{}
Local aTraFE	:=	{}
Local cEmp		:=	""
Local cFil	 	:=	""
Local cCgc		:=	""
Local cDescEmp	:=	""
Local cDescFil	:=	""
Local cEndereco	:=	""
Local cBairro	:=	""
Local cCidade	:=	""
Local cEstado	:=	""
Local cTipEnd	:=	GetMv("MV_PAREND")
Local dDataTra	:=	Ctod('//')
Local nSvRecno	:=	SM0->( Recno () )
Local nTra		:=	0
Local cCCustoDe	:=	""
Local cCCustoP	:=	""
Local cMatDe	:=	""
Local cMatP		:=	""
Local nLen		:=	TAMSX3("RA_MAT")[1]
Local cStringT	:=	""

nColuna	:= 050

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Seleciona o Arquivo de Transferencias e Retorna Todas as Trans³
³ferencias do Funcionario 									   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
fTransf(@aTransf,,,,,,,.T.)
For nTra := 1 To Len(aTransf)
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Carrega apenas as Transferencias Entre Filiais e Empresas     ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	If aTransf[nTra,7] >= dDataIni .and. aTransf[nTra,7] <= dDataFin
		IF !( aTransf[nTra,1] == aTransf[nTra,4] ) .or. !(Subst(aTransf[nTra,2],1,FwGetTamFilial) == Subst(aTransf[nTra,5],1,FwGetTamFilial) );
			.OR. !( aTransf[nTra,3] == aTransf[nTra,6 ] );
			.OR. !( aTransf[nTra,9] == aTransf[nTra,11] ) 
			aAdd(aTraFE,{aTransf[nTra,1] ,; // Empresa De
						aTransf[nTra,2] ,; // Filial + Matricula De
						aTransf[nTra,3] ,; // Centro de Custo De
						aTransf[nTra,4] ,; // Empresa Para
						aTransf[nTra,5] ,; // Filial + Matricula Para
						aTransf[nTra,6] ,; // Centro de Custo Para
						aTransf[nTra,7] ,; // Data da Transferencia
					     } )
		EndIF
	Endif
Next nTra

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Reinicializa aTransf                                          ³ 
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
aTransf := {}


/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Preparando Dados Para a Impressao                            ³ 
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
For nTra := 1 To Len(aTraFE)
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Cabecalho das Transferencias                                 ³ 
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	IF Len(aTransf) = 0
		Aadd(aTransf,{ " "   ,STR0043,"" })	//"|            Empresa de Origem   "
		Aadd(aTransf,{STR0013,STR0045,"" })	//"|Data        Empresa de Destino  "
    EndIf
    cMatDe		:= RIGHT( aTraFE[nTra , 2] , nLen )
  	cMatP		:= RIGHT( aTraFE[nTra , 5] , nLen )
    cCCustoDe	:= aTraFE[nTra,3]
    cCCustoP	:= aTraFE[nTra,6]
    /*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Dados da Empresa de Origem                                   ³ 
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
   	cEmp		:= aTraFE[nTra,1]
    cFil		:= Subst(aTraFE[nTra,2],1,FWGETTAMFILIAL)
    SM0->( dbSeek(cEmp+cFil) )
    cDescEmp	:= ALLTRIM(SM0->M0_NOMECOM)
    cDescFil	:= SM0->( IF(nFilial == 1 , M0_NOME , M0_FILIAL ) )
    cStringT	:=	cEmp + " - " + cDescEmp
    If !( cMatDe == cMatP )    	
    	cStringT	+= " - " + "Matrícula" + cMatDe // Matrícula
    EndIf
    
    If !( cCCustoDe == cCCustoP )    	
    	cStringT += " - " + "Centro de Custo" + cCCustoDe // Centro de Custo
    EndIf   
    
	aAdd(aTransf,{"" , cStringT , cFil + " - " + cDescFil} )
	
	cCgc		:= SM0->(Transform(M0_CGC,'@R ##.###.###/####-##') )
	cEndereco	:= SM0->( IF( cTipEnd = "C", M0_ENDCOB , M0_ENDENT ) )
	
	aAdd(aTransf,{"" , IF(SM0->M0_TPINSC = 1 , STR0047 , STR0032 ) + cCgc + Space(01) + STR0049 + cEndereco," " } )//"CEI"###"CGC"###"End.: "

	cBairro		:=	SM0->( IF( cTipEnd = "C", M0_BAIRCOB, M0_BAIRENT ) )
	cCidade		:=	SM0->( IF( cTipEnd = "C", M0_CIDCOB	, M0_CIDENT  ) )
	cEstado		:=	SM0->( IF( cTipEnd = "C", M0_ESTCOB	, M0_ESTENT  ) )

	aAdd(aTransf,{"" ,STR0028 + cBairro + " -" + cCidade + Space(01) + STR0030 + cEstado," " } ) //"Bairro: "###"Cidade: "###"UF: "
	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Dados da Empresa de Destino                                  ³ 
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	cEmp		:= ALLTRIM(aTraFE[nTra,4])
	cFil		:= Subst(aTraFE[nTra,5],1,FWGETTAMFILIAL)   
	dDataTra	:= aTraFE[nTra,7]
	SM0->( dbSeek(cEmp+cFil) )
	cDescEmp	:= ALLTRIM(SM0->M0_NOMECOM)
	cDescFil	:= SM0->( IF(nFilial == 1 , M0_NOME , M0_FILIAL ) )
	
	cStringT	:=	cEmp + " - " + cDescEmp + SPACE(1)
	If !( cMatDe == cMatP )
    	cStringT += " - " + "Matrícula" + cMatP // Matrícula
    EndIf
    
    If !( cCCustoDe == cCCustoP )
    	cStringT += " - " + "Centro de Custo" + cCCustoP // Centro de Custo
    EndIf

	aAdd(aTransf,{DTOC(dDataTra), cStringT + space(7) , cFil + " - " + cDescFil } )

	cCgc		:= SM0->(Transform(M0_CGC,'@R ##.###.###/####-##') )  
	cEndereco	:= SM0->( IF( cTipEnd = "C", M0_ENDCOB , M0_ENDENT ) )
	
	aAdd(aTransf,{"" , IF(SM0->M0_TPINSC = 1 , STR0047 , STR0032 ) + cCgc + Space(01) + STR0049 + cEndereco," " })//"CEI"###"CGC"###"End.: "

	cBairro		:=	SM0->( IF( cTipEnd = "C", M0_BAIRCOB, M0_BAIRENT ) )
	cCidade		:=	SM0->( IF( cTipEnd = "C", M0_CIDCOB	, M0_CIDENT  ) )
	cEstado		:=	SM0->( IF( cTipEnd = "C", M0_ESTCOB	, M0_ESTENT  ) )

	aAdd(aTransf, {"" ,STR0028 + cBairro + " - " + cCidade + Space(01) + STR0030 + cEstado," " }) //"Bairro: "###"Cidade: "###"UF: "

	SM0->( dbGoto( nSvRecno ) )
Next nTra

If !Empty(aTransf) .and. Len(aTransf) > 2

	fImpTraN(aTransf)
	lImpressao	:= .T.	
Endif
SM0->( dbGoto( nSvRecno ) )

RestArea( aArea)
Return


/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpNorm  ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/

Static Function  fImpNorm(aCampo)
Local cDet 		:= " ",Ix	:= 1
Local nTaman	:= nTam1	:=	nTam2	:= 0 
Local cDescFol	:= " "
Local nPosF
Local nX 		:= 0 
Local nLinhas	:= 0 
Local aCpoMemo  := {}
Local N,M, nDet
Local aDetalhe	:= {}
Local _Area     := GetArea()

//-- Box Detalhe         
aAdd(aDetalhe," ------------------------------------------------------------------------------")
aAdd(aDetalhe,"|                              Dados Funcionais                                |")
aAdd(aDetalhe," ------------------------------------------------------------------------------")
aAdd(aDetalhe,"|Descr.CCusto :[                    ]     Data Admis.. :[  /  /    ]           |")
aAdd(aDetalhe,"|Dt.Op.FGTS.. :[  /  /    ]     Dt. Demissao :[  /  /    ]                     |")
aAdd(aDetalhe,"|Desc.Funcao. :[                    ]     C.B.O. 2002. :[      ]               |")
aAdd(aDetalhe,"|Mês Dissidio: [  ]                                                            |")
aAdd(aDetalhe," ------------------------------------------------------------------------------")
aAdd(aDetalhe,"|                              No de Documentos                                |")
aAdd(aDetalhe," ------------------------------------------------------------------------------")
aAdd(aDetalhe,"|CPF......... :[           ]            P.I.S....... :[            ]           |")
aAdd(aDetalhe,"|Cart.Profis. :[        ]               Serie Cart.. :[     ]                  |")
aAdd(aDetalhe," ------------------------------------------------------------------------------")
             //1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
             //        10        20        30        40        50        60        70        80        90        100

DbSelectArea("CTT")
DbSetOrder(1)
Dbseek(XFilial("CTT")+SRA->RA_CC)

DbSelectArea("SRJ")
DbSetOrder(1)
Dbseek(XFilial("SRJ")+SRA->RA_CODFUNC)

DbSelectArea("RCE")
DbSetOrder(1)
Dbseek(XFilial("RCE")+SRA->RA_SINDICA)

aDetalhe[4]	:= Stuff(aDetalhe[4],17,20,SUBSTR(CTT->CTT_DESC01,1,20))
aDetalhe[4]	:= Stuff(aDetalhe[4],58,Len(DTOC(SRA->RA_ADMISSA)),DTOC(SRA->RA_ADMISSA))								
aDetalhe[5]	:= Stuff(aDetalhe[5],17,Len(DTOC(SRA->RA_OPCAO)),DTOC(SRA->RA_OPCAO))
aDetalhe[5]	:= Stuff(aDetalhe[5],48,Len(DTOC(SRA->RA_DEMISSA)),DTOC(SRA->RA_DEMISSA))
aDetalhe[6]	:= Stuff(aDetalhe[6],17,Len(SRJ->RJ_DESC),SRJ->RJ_DESC)
aDetalhe[6]	:= Stuff(aDetalhe[6],58,Len(SRJ->RJ_CODCBO),SRJ->RJ_CODCBO)
aDetalhe[7]	:= Stuff(aDetalhe[7],17,Len(RCE->RCE_MESDIS),RCE->RCE_MESDIS)
aDetalhe[11]:= Stuff(aDetalhe[11],17,Len(SRA->RA_CIC),SRA->RA_CIC)
aDetalhe[11]:= Stuff(aDetalhe[11],56,Len(SRA->RA_PIS),SRA->RA_PIS)
aDetalhe[12]:= Stuff(aDetalhe[12],17,Len(SRA->RA_NUMCP),SRA->RA_NUMCP)
aDetalhe[12]:= Stuff(aDetalhe[12],56,Len(SRA->RA_SERCP),SRA->RA_SERCP)

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
	
cLin := ""
For m:= 1 to Len(aDetalhe)
	cLin += aDetalhe[m]+chr(13)+chr(10)
Next m

fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)

cLin := ""

RestArea(_Area)	

Return

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpSalN  ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º          

ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function fImpSalN(aSal,cHist)

Local N,M, nDet
Local aDetalhe	:= {}

//-- Box Detalhe         
If SRA->RA_CATFUNC $ "T" .and. cHist == "T"
	aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
	aAdd(aDetalhe,"|                                                                              |")
	aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
	aAdd(aDetalhe,"|         |         |              |            |               |              |")
	aAdd(aDetalhe,"|---------+---------+--------------+------------+---------------+--------------|")
				//  Data De   Data Ate  Tarefa          Qtde.Tarefa    Vl. Unitario       Vl Total
				//  99/99/99  99/99/99   999            9,999,999.99 9,999,999.9999  9,999,999.9999
				//  1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
				//         10        20        30        40        50        60        70        80        90        100

ElseIf SRA->RA_CATFUNC $ "I#J" .and. cHist == "T"
	aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
	aAdd(aDetalhe,"|                                                                              |")
	aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
	aAdd(aDetalhe,"|        |        |              |        |      |              |              |")
	aAdd(aDetalhe,"|--------+--------+--------------+--------+------+--------------+--------------|")
				//  Data De |Data Ate|Tarefa        |Aul/Sem.|Q.Tar.|  Vl. Unitario|     Vl Total
				//  99/99/99|99/99/99|999-5678901234| 999.99 |999.99|9,999,999.9999|9,999,999.9999
				//  1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
				//         10        20        30        40        50        60        70        80        90        100

Else
	aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
	aAdd(aDetalhe,"|                                                                              |")
	aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
	aAdd(aDetalhe,"|          |                    |     |     |                    |             |")
	aAdd(aDetalhe,"|          |                    |     |     |                    |             |")
	aAdd(aDetalhe,"|          |                    |     |     |                    |             |")
	aAdd(aDetalhe,"|----------+--------------------+-----+-----+--------------------+-------------|")
	             //12345678901234567890123456789012345678901234567890123456789012345678901234567890
	             //          10        20        30        40        50        60        70       
	             // 99/99/9999                                                       99,999,999.99
EndIf

If SRA->RA_CATFUNC $ "I#J#T" .and. cHist == "T"
	nDet	:= (78 - Len(STR0015+STR0099)) / 2      // Alterações salariais - Tarefas                                         
	aDetalhe[2]	:= sTuff(aDetalhe[2],nDet,len(oemtoAnsi(STR0015+STR0099)) , oEmtoAnsi(STR0015+STR0099) )   
Else	
	nDet	:= (78 - Len(STR0015)) / 2                                               
	aDetalhe[2]	:= sTuff(aDetalhe[2],nDet,len(oemtoAnsi(STR0015)) , oEmtoAnsi(STR0015) )   
EndIf                                                                                 

If SRA->RA_CATFUNC $ "I#J" .and. cHist == "T"
	aDetalhe[4]	:= Stuff(aDetalhe[4],02,len(aSal[1,2]),aSal[1,2]) 
	aDetalhe[4]	:= Stuff(aDetalhe[4],11,len(aSal[1,3]),aSal[1,3]) 
	aDetalhe[4]	:= Stuff(aDetalhe[4],20,len(aSal[1,4]),aSal[1,4]) 
	aDetalhe[4]	:= Stuff(aDetalhe[4],35,len(aSal[1,5]),aSal[1,5])
	aDetalhe[4]	:= Stuff(aDetalhe[4],44,len(aSal[1,6]),aSal[1,6])
	aDetalhe[4]	:= Stuff(aDetalhe[4],52,len(aSal[1,7]),aSal[1,7])
	aDetalhe[4]	:= Stuff(aDetalhe[4],68,len(aSal[1,8]),aSal[1,8])
ElseIf SRA->RA_CATFUNC $ "T" .and. cHist == "T"
	aDetalhe[4]	:= Stuff(aDetalhe[4],02,len(aSal[1,2]),aSal[1,2]) 
	aDetalhe[4]	:= Stuff(aDetalhe[4],13,len(aSal[1,3]),aSal[1,3]) 
	aDetalhe[4]	:= Stuff(aDetalhe[4],23,len(aSal[1,4]),aSal[1,4]) 
	aDetalhe[4]	:= Stuff(aDetalhe[4],37,len(aSal[1,6]),aSal[1,6])
	aDetalhe[4]	:= Stuff(aDetalhe[4],50,len(aSal[1,7]),aSal[1,7])
	aDetalhe[4]	:= Stuff(aDetalhe[4],68,len(aSal[1,8]),aSal[1,8])
Else
	aDetalhe[4]	:= Stuff(aDetalhe[4],02,len(aSal[1,1]),aSal[1,1])  
	aDetalhe[4]	:= Stuff(aDetalhe[4],14,len(aSal[1,2]),aSal[1,2]) 
	aDetalhe[4]	:= Stuff(aDetalhe[4],35,len(aSal[1,3]),aSal[1,3]) 
	aDetalhe[4]	:= Stuff(aDetalhe[4],41,len(aSal[1,4]),aSal[1,4]) 
	aDetalhe[4]	:= Stuff(aDetalhe[4],47,len(aSal[1,5]),aSal[1,5])
	aDetalhe[4]	:= Stuff(aDetalhe[4],68,len(aSal[1,6]),aSal[1,6])
	aDetalhe[5]	:= Stuff(aDetalhe[5],13,len(aSal[1,7]),aSal[1,7])
	aDetalhe[6]	:= Stuff(aDetalhe[6],13,len(aSal[1,8]),aSal[1,8])
EndIf

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
	
cLin := ""
For m:= 1 to Len(aDetalhe)
	cLin += aDetalhe[m]+chr(13)+chr(10)
Next m

fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)	
	                                    
For N:=2 To Len(aSal)
    
	cLin := ""

	If SRA->RA_CATFUNC $ "I#J#" .and. cHist == "T"
		/*
		Impr("|"+ aSal[n,2]					,"C",,,00,.F. )		//-- Data de 
		Impr("|"+ aSal[n,3]					,"C",,,09,.F. )		//-- Data Ate 
		Impr("|"+ substr(aSal[n,4],1,14)	,"C",,,18,.F. )		//-- Tarefa
		Impr("|"+ space(01)+aSal[n,5]		,"C",,,33,.F. )		//-- Aulas/Semana
		Impr("|"+ aSal[n,6]					,"C",,,42,.F. )		//-- Qtd. Tarefa
		Impr("|"+ aSal[n,7]					,"C",,,49,.F. )        //-- Valor unitario
		Impr("|"+ Substr(aSal[n,8],1,20)	,"C",,,64,.F. )		//-- Valor Total
		Impr("|"           					,"C",,,79,.T. )
		*/
		cTemp:= "|"+ ALLTRIM(aSal[n,2])
		cLin += cTemp+Replicate(" ",08-LEN(cTemp))
		cTemp:= "|"+ ALLTRIM(aSal[n,3])
		cLin += cTemp+Replicate(" ",18-LEN(cLin+cTemp))
		cTemp:= "|"+ ALLTRIM(substr(aSal[n,4],1,14))
		cLin += cTemp+Replicate(" ",33-LEN(cLin+cTemp))
		cTemp:= "|"+ ALLTRIM(space(01)+aSal[n,5])
		cLin += cTemp+Replicate(" ",42-LEN(cLin+cTemp))
		cTemp:= "|"+ ALLTRIM(aSal[n,6])
		cLin += cTemp+Replicate(" ",49-LEN(cLin+cTemp))
		cTemp:= "|"+ ALLTRIM(aSal[n,7])
		cLin += cTemp+Replicate(" ",64-LEN(cLin+cTemp))
		cTemp:= "|"+ ALLTRIM(Substr(aSal[n,8],1,20))
		cLin += cTemp+Replicate(" ",79-LEN(cLin+cTemp))		
		cTemp:= "|"
		cLin += cTemp
		
		cLin += chr(13)+chr(10)
		
		nHdl := FOpen( cNomeArq, 2 )
		FSeek( nHdl, 0 , FS_END )
		fWrite(nHdl,cLin,Len(cLin))
		fClose(nHdl)
        
		cLin := ""				
		
	ElseIf SRA->RA_CATFUNC $ "T" .and. cHist == "T"
		/*
		Impr("|"+ aSal[n,2]					,"C",,,00,.F. )		//-- Data de 
		Impr("|"+ aSal[n,3]					,"C",,,10,.F. )		//-- Data Ate 
		Impr("|"+ substr(aSal[n,4],1,14)	,"C",,,20,.F. )		//-- Tarefa
		Impr("|"+ aSal[n,6]					,"C",,,35,.F. )		//-- Qtd. Tarefa
		Impr("|"+ aSal[n,7]					,"C",,,48,.F. )        //Valor unitario
		Impr("|"+ Substr(aSal[n,8],1,20)	,"C",,,64,.F. )
		Impr("|"           					,"C",,,79,.T. )
		*/
		cTemp:= "|"+ ALLTRIM(aSal[n,2])
		cLin += cTemp+Replicate(" ",09-LEN(cTemp))
		cTemp:= "|"+ ALLTRIM(aSal[n,3])
		cLin += cTemp+Replicate(" ",20-LEN(cLin+cTemp))
		cTemp:= "|"+ ALLTRIM(substr(aSal[n,4],1,14))
		cLin += cTemp+Replicate(" ",35-LEN(cLin+cTemp))
		cTemp:= "|"+ ALLTRIM(aSal[n,6])
		cLin += cTemp+Replicate(" ",48-LEN(cLin+cTemp))
		cTemp:= "|"+ ALLTRIM(aSal[n,7])
		cLin += cTemp+Replicate(" ",64-LEN(cLin+cTemp))
		cTemp:= "|"+ ALLTRIM(Substr(aSal[n,8],1,20))
		cLin += cTemp+Replicate(" ",79-LEN(cLin+cTemp))		
		cTemp:= "|"
		cLin += cTemp
		
		cLin += chr(13)+chr(10)
		
		nHdl := FOpen( cNomeArq, 2 )
		FSeek( nHdl, 0 , FS_END )
		fWrite(nHdl,cLin,Len(cLin))
		fClose(nHdl)
        
		cLin := ""				
		
	Else
		cTemp:= "|"+ ALLTRIM(aSal[n,1])
		cLin += cTemp+Replicate(" ",10-LEN(cTemp))
		cTemp:= "|"+ ALLTRIM(aSal[n,2])
		cLin += cTemp+Replicate(" ",32-LEN(cLin+cTemp))
		cTemp:= "|"+ ALLTRIM(aSal[n,3])
		cLin += cTemp+Replicate(" ",38-LEN(cLin+cTemp))
		cTemp:= "|"+ ALLTRIM(aSal[n,4])
		cLin += cTemp+Replicate(" ",44-LEN(cLin+cTemp))
		cTemp:= "|"+ ALLTRIM(aSal[n,5])
		cLin += cTemp+Replicate(" ",65-LEN(cLin+cTemp))
		cTemp:= "|"+ ALLTRIM(aSal[n,6])
		cLin += cTemp+Replicate(" ",79-LEN(cLin+cTemp))
		cTemp:= "|"
		cLin += cTemp										
		
		cLin += chr(13)+chr(10)
		
		nHdl := FOpen( cNomeArq, 2 )
		FSeek( nHdl, 0 , FS_END )
		fWrite(nHdl,cLin,Len(cLin))
		fClose(nHdl)
        
		cLin := ""
		
		cTemp:= "|"+SPACE(10)
		cLin += cTemp+Replicate(" ",10-LEN(cTemp))
		cTemp:= "|"+ ALLTRIM(aSal[n,7])
		cLin += cTemp+Replicate(" ",32-LEN(cLin+cTemp))
		cTemp:= "|"
		cLin += cTemp+Replicate(" ",38-LEN(cLin+cTemp))
		cTemp:= "|"
		cLin += cTemp+Replicate(" ",44-LEN(cLin+cTemp))
		cTemp:= "|"
		cLin += cTemp+Replicate(" ",65-LEN(cLin+cTemp))
		cTemp:= "|"
		cLin += cTemp+Replicate(" ",79-LEN(cLin+cTemp))
		cTemp:= "|"
		cLin += cTemp
				
		cLin += chr(13)+chr(10)
		
		nHdl := FOpen( cNomeArq, 2 )
		FSeek( nHdl, 0 , FS_END )
		fWrite(nHdl,cLin,Len(cLin))
		fClose(nHdl)
		
		cLin := ""
		
		cTemp:= "|"+SPACE(10)
		cLin += cTemp+Replicate(" ",10-LEN(cTemp))
		cTemp:= "|"+ ALLTRIM(Substr(aSal[n,8],1,20))
		cLin += cTemp+Replicate(" ",32-LEN(cLin+cTemp))
		cTemp:= "|"
		cLin += cTemp+Replicate(" ",38-LEN(cLin+cTemp))
		cTemp:= "|"
		cLin += cTemp+Replicate(" ",44-LEN(cLin+cTemp))
		cTemp:= "|"
		cLin += cTemp+Replicate(" ",65-LEN(cLin+cTemp))
		cTemp:= "|"
		cLin += cTemp+Replicate(" ",79-LEN(cLin+cTemp))
		cTemp:= "|"
		cLin += cTemp
		
		cLin += chr(13)+chr(10)
		
		nHdl := FOpen( cNomeArq, 2 )
		FSeek( nHdl, 0 , FS_END )
		fWrite(nHdl,cLin,Len(cLin))
		fClose(nHdl)
		
		cLin := ""				
		/*	
		Impr("|"+ aSal[n,1]					,"C",,,00,.F. )		//-- Data Alteracao
		Impr("|"+ aSal[n,2]					,"C",,,11,.F. )		//-- Descricao 
		Impr("|"+ aSal[n,3]					,"C",,,32,.F. )		//-- Categoria 
		Impr("|"+ aSal[n,4]					,"C",,,38,.F. )		//-- pgto
		Impr("|"+ aSal[n,5]					,"C",,,44,.F. )		//-- Verba
		Impr("|"+ aSal[n,6]					,"C",,,65,.F. )		//-- Valor 
		Impr("|"           					,"C",,,79,.T. )
		Impr("|"            				,"C",,,00,.F. ) 
		Impr("|"+ aSal[n,7]					,"C",,,11,.F. )
		Impr("|"            				,"C",,,32,.F. )
		Impr("|"            				,"C",,,38,.F. )
		Impr("|"            				,"C",,,44,.F. )
		Impr("|"            				,"C",,,65,.F. )
		Impr("|"            				,"C",,,79,.T. )
		Impr("|"            				,"C",,,00,.F. ) 
		Impr("|"+ Substr(aSal[n,8],1,20)	,"C",,,11,.F. )
		Impr("|"            				,"C",,,32,.F. )
		Impr("|"            				,"C",,,38,.F. )
		Impr("|"            				,"C",,,44,.F. )
		Impr("|"            				,"C",,,65,.F. )
		Impr("|"           					,"C",,,79,.T. )
		*/
    EndIf
Next n
//Impr("","C") 
//Impr(aDetalhe[1],"C")
cLin += aDetalhe[1]
cLin += chr(13)+chr(10)

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)

cLin := ""


Return  

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpAfasN ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpAfasN(aAfas)
Local N ,M , nDet
Local aDetalhe	:= {}

//-- Box Detalhe 
aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
aAdd(aDetalhe,"|                                                                              |")
aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
aAdd(aDetalhe,"|          |                                             |          |          |")
aAdd(aDetalhe,"|----------+---------------------------------------------+----------+----------|")
             //12345678901234567890123456789012345678901234567890123456789012345678901234567890
             //         10        20        30        40        50        60        70           
//            "|99/99/9999+---------------------------------------------+99/99/9999+99/99/9999|")
             
nDet	:= (78 - len(STR0018) ) /2
aDetalhe[2]	:= stuff(aDetalhe[2],nDet,len(oemtoAnsi(STR0018)) , oEmtoAnsi(STR0018) )
aDetalhe[4]	:= Stuff(aDetalhe[4],02,len(aAfas[1,1]),aAfas[1,1]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],13,len(aAfas[1,2]),aAfas[1,2]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],59,len(aAfas[1,3]),aAfas[1,3]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],70,len(aAfas[1,4]),aAfas[1,4])	

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
	
cLin := ""
For m:= 1 to Len(aDetalhe)
	cLin += aDetalhe[m]+chr(13)+chr(10)
Next m

fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)

cLin := ""
	
For N:=2 To Len(aAfas)
	/*
	Impr("|"+ aAfas[n,1],"C",,,00,.F. )
	IF len(aAfas[n,2]) > 45
		Impr("|"+ substr(aAfas[n,2],1,45),"C",,,11,.F. )
	Else 
		Impr("|"+ aAfas[n,2],"C",,,11,.F. )		
	Endif
	Impr("|"+ aAfas[n,3],"C",,,57,.F. )
	Impr("|"+ aAfas[n,4],"C",,,68,.F. )
	Impr("|","C",,,79 )
	IF len(aAfas[n,2]) > 45
		Impr("|"                           ,"C",,,00,.F. )	
		Impr("|"+ substr(aAfas[n,2],46,55),"C",,,11,.F. )
		Impr("|"                           ,"C",,,57,.F. )
		Impr("|"                           ,"C",,,68,.F. )
		Impr("|"                           ,"C",,,79 )
	Endif
	*/
	cLin := ""
	
	cTemp:= "|"+ALLTRIM(aAfas[n,1])
	cLin += cTemp+Replicate(" ",10-LEN(cTemp))

	IF len(aAfas[n,2]) > 45			
		cTemp:= "|"+ALLTRIM(substr(aAfas[n,2],1,45))
		cLin += cTemp+Replicate(" ",57-LEN(cLin+cTemp))
				
	Else 			
		cTemp:= "|"+ALLTRIM(aAfas[n,2])
		cLin += cTemp+Replicate(" ",57-LEN(cLin+cTemp))
							
	Endif		
	     
	cTemp:= "|"+ALLTRIM(aAfas[n,3])
	cLin += cTemp+Replicate(" ",68-LEN(cLin+cTemp))
	cTemp:= "|"+ALLTRIM(aAfas[n,4])
	cLin += cTemp+Replicate(" ",79-LEN(cLin+cTemp))
	cTemp:= "|"
	cLin += cTemp
	
	cLin += chr(13)+chr(10)	
    
	IF len(aAfas[n,2]) > 45
		
		cTemp:= "|"+SPACE(10)
		cLin += cTemp+Replicate(" ",10-LEN(cTemp))
		cTemp:= "|"+ ALLTRIM(substr(aAfas[n,2],46,55))
		cLin += cTemp+Replicate(" ",57-LEN(cLin+cTemp))
		cTemp:= "|"
		cLin += cTemp+Replicate(" ",68-LEN(cLin+cTemp))
		cTemp:= "|"
		cLin += cTemp+Replicate(" ",79-LEN(cLin+cTemp))
		cTemp:= "|"
		cLin += cTemp
		
		cLin += chr(13)+chr(10)			
					
	Endif
	
	nHdl := FOpen( cNomeArq, 2 )
	FSeek( nHdl, 0 , FS_END )
	fWrite(nHdl,cLin,Len(cLin))
	fClose(nHdl)
		
	cLin := ""	
	 	
Next n
//Impr(aDetalhe[1],"C")
cLin += aDetalhe[1]
cLin += chr(13)+chr(10)

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)

cLin := ""
Return  

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpFeriaNºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpFeriaN(aFerias)
Local N ,M , nDet
Local aDetalhe	:= {}

//-- Box Detalhe 
aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
aAdd(aDetalhe,"|                                                                              |")
aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
aAdd(aDetalhe,"|                       |                         |              |             |")
aAdd(aDetalhe,"|-----------------------+-------------------------+--------------+-------------|")
             //12345678901234567890123456789012345678901234567890123456789012345678901234567890
             //         10        20        30        40        50        60        70       
nDet	:= (78 - Len(STR0021)) / 2 
aDetalhe[2]	:= stuff(aDetalhe[2],nDet,len(oemtoAnsi(STR0021)) , oEmtoAnsi(STR0021) )
aDetalhe[4]	:= Stuff(aDetalhe[4],03,len(aFerias[1,1]),aFerias[1,1]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],27,len(aFerias[1,2]),aFerias[1,2]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],53,len(aFerias[1,3]),aFerias[1,3]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],68,len(aFerias[1,4]),aFerias[1,4])

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
	
cLin := ""
For m:= 1 to Len(aDetalhe)
	cLin += aDetalhe[m]+chr(13)+chr(10)
Next m

fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)

cLin := ""
	
For N:=2 To Len(aFerias)
	/*
	Impr("|"+aFerias[n,1],"C",,,00,.F.)
	Impr("|"+aFerias[n,2],"C",,,24,.F.)
	Impr("|"+aFerias[n,3],"C",,,50,.F.)
	Impr("|"+aFerias[n,4],"C",,,65,.F.)
	Impr("|","C",,,79 )
	*/
	cTemp:= "|"+ ALLTRIM(aFerias[n,1])
	cLin += cTemp+Replicate(" ",23-LEN(cTemp))
	cTemp:= "|"+ ALLTRIM(aFerias[n,2])
	cLin += cTemp+Replicate(" ",50-LEN(cLin+cTemp))
	cTemp:= "|"+ ALLTRIM(aFerias[n,3])
	cLin += cTemp+Replicate(" ",65-LEN(cLin+cTemp))
	cTemp:= "|"+ ALLTRIM(aFerias[n,4])
	cLin += cTemp+Replicate(" ",79-LEN(cLin+cTemp))
	cTemp:= "|"
	cLin += cTemp										
	
	cLin += chr(13)+chr(10)
	
	nHdl := FOpen( cNomeArq, 2 )
	FSeek( nHdl, 0 , FS_END )
	fWrite(nHdl,cLin,Len(cLin))
	fClose(nHdl)
        
	cLin := ""	
	
Next N
//Impr(aDetalhe[1],"C")
cLin += aDetalhe[1]
cLin += chr(13)+chr(10)

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)

cLin := ""
Return 

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpCadN  ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpCadN(aAltCad)
Local N , M, nDet
Local aDetalhe	:= {}
       
aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
aAdd(aDetalhe,"|                                                                              |")
aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
aAdd(aDetalhe,"|             |                   |                                            |")
aAdd(aDetalhe,"|-------------+-------------------+--------------------------------------------|")
             //12345678901234567890123456789012345678901234567890123456789012345678901234567890
             //         10        20        30        40        50        60        70       

nDet	:= (78 - Len(STR0024)) / 2  
aDetalhe[2]	:= stuff(aDetalhe[2],nDet,len(oemtoAnsi(STR0024)) , oEmtoAnsi(STR0024) )
aDetalhe[4]	:= Stuff(aDetalhe[4],02,len(aAltCad[1,1]),aAltCad[1,1]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],17,len(aAltCad[1,2]),aAltCad[1,2]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],37,len(aAltCad[1,3]),aAltCad[1,3]) 

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
	
cLin := ""
For m:= 1 to Len(aDetalhe)
	cLin += aDetalhe[m]+chr(13)+chr(10)
Next m

fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)

cLin := ""

For n:= 2 to Len(aAltCad)
	/*
	Impr("|"+aAltCad[n,1],"C",,,00,.F.)
	Impr("|"+aAltCad[n,2],"C",,,14,.F.)
	Impr("|"+aAltCad[n,3],"C",,,34,.F.)
	Impr("|","C",,,79 )
	*/
	cTemp:= "|"+ ALLTRIM(aAltCad[n,1])
	cLin += cTemp+Replicate(" ",14-LEN(cTemp))
	cTemp:= "|"+ ALLTRIM(aAltCad[n,2])
	cLin += cTemp+Replicate(" ",34-LEN(cLin+cTemp))
	cTemp:= "|"+ ALLTRIM(aAltCad[n,3])
	cLin += cTemp+Replicate(" ",79-LEN(cLin+cTemp))
	cTemp:= "|"
	cLin += cTemp										
	
	cLin += chr(13)+chr(10)
	
	nHdl := FOpen( cNomeArq, 2 )
	FSeek( nHdl, 0 , FS_END )
	fWrite(nHdl,cLin,Len(cLin))
	fClose(nHdl)
        
	cLin := ""	
	
Next n 

//Impr(aDetalhe[1],"C")
cLin += aDetalhe[1]
cLin += chr(13)+chr(10)

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)

cLin := ""

Return

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpDepN  ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpDepN(aDEp)
Local N , M , nDet
Local aDetalhe	:= {}
				
aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
aAdd(aDetalhe,"|                                                                              |")
aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
aAdd(aDetalhe,"|   |                              |          |    |         |      |          |")
aAdd(aDetalhe,"|---+------------------------------+----------+----+---------+------+----------|")
             //|99 |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 99/99/9999| X       X       X        X    |
             //|Cod|Nome                           Dt.Nasc.   Sexo Parent  |Dp.IR.|Dp.S.Fam. |"  
             //12345678901234567890123456789012345678901234567890123456789012345678901234567890
             //         10        20        30        40        50        60        70       
nDet	:= (78 - Len(STR0026)) / 2 
aDetalhe[2]	:= stuff(aDetalhe[2],nDet,len(oemtoAnsi(STR0026)) , oEmtoAnsi(STR0026) )
aDetalhe[4]	:= Stuff(aDetalhe[4],02,(len(Trim(aDep[1,1]))),aDep[1,1]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],06,len(aDep[1,2]),aDep[1,2]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],37,len(aDep[1,3]),aDep[1,3]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],48,len(aDep[1,4]),aDep[1,4]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],53,len(aDep[1,5]),aDep[1,5]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],63,len(aDep[1,6]),aDep[1,6])
aDetalhe[4]	:= Stuff(aDetalhe[4],70,len(aDep[1,7]),aDep[1,7]) 

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
	
cLin := ""
For m:= 1 to Len(aDetalhe)
	cLin += aDetalhe[m]+chr(13)+chr(10)
Next m

fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)

cLin := ""	

For N:=2  to Len(aDep)
	/*
	Impr("|"+aDep[n,1],"C",,,00,.F.)		//--Codigo
	Impr("|"+aDep[n,2],"C",,,04,.F.)		//--Dependente
	Impr("|"+aDep[n,3],"C",,,35,.F.)		//--Dt.Nasc.
	Impr("|"+substr(aDep[n,4],1,4),"C",,,46,.F.)		//--Sexo
	Impr("|"+aDep[n,5],"C",,,51,.F.)	//--Parent
	Impr("|"+aDep[n,6],"C",,,61,.F.)	//--Dp.Ir.
	Impr("|"+aDep[n,7],"C",,,68,.F.)	//--Dp.S.Fam.
	Impr("|","C",,,79 )
	*/

	cTemp:= "|"+ ALLTRIM(aDep[n,1])
	cLin += cTemp+Replicate(" ",03-LEN(cTemp))
	cTemp:= "|"+ ALLTRIM(aDep[n,2])
	cLin += cTemp+Replicate(" ",34-LEN(cLin+cTemp))
	cTemp:= "|"+ ALLTRIM(aDep[n,3])
	cLin += cTemp+Replicate(" ",45-LEN(cLin+cTemp))
	cTemp:= "|"+ ALLTRIM(substr(aDep[n,4],1,4))
	cLin += cTemp+Replicate(" ",50-LEN(cLin+cTemp))
	cTemp:= "|"+ ALLTRIM(aDep[n,5])
	cLin += cTemp+Replicate(" ",60-LEN(cLin+cTemp))
	cTemp:= "|"+ ALLTRIM(aDep[n,6])
	cLin += cTemp+Replicate(" ",67-LEN(cLin+cTemp))	
	cTemp:= "|"+ ALLTRIM(aDep[n,7])
	cLin += cTemp+Replicate(" ",79-LEN(cLin+cTemp))
	cTemp:= "|"
	cLin += cTemp										
	
	cLin += chr(13)+chr(10)
	
	nHdl := FOpen( cNomeArq, 2 )
	FSeek( nHdl, 0 , FS_END )
	fWrite(nHdl,cLin,Len(cLin))
	fClose(nHdl)
        
	cLin := ""	
	
Next N

//Impr(aDetalhe[1],"C")
cLin += aDetalhe[1]
cLin += chr(13)+chr(10)

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)

cLin := ""

Return

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpBenN  ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpBenN(aBenef)
Local N , M , nDet
Local aDetalhe	:= {}
				
aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
aAdd(aDetalhe,"|                                                                              |")
aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
aAdd(aDetalhe,"|    |                                                                         |") 
aAdd(aDetalhe,"|----+-------------------------------------------------------------------------|")
             //|Cod |Beneficiario 
             //  99
             //12345678901234567890123456789012345678901234567890123456789012345678901234567890
             //         10        20        30        40        50        60        70       
nDet	:= (78 - Len(STR0060)) / 2 
aDetalhe[2]	:= stuff(aDetalhe[2],nDet,len(oemtoAnsi(STR0060)) , oEmtoAnsi(STR0060) )
aDetalhe[4]	:= Stuff(aDetalhe[4],02,len(aBenef[1,1]),aBenef[1,1])
aDetalhe[4]	:= Stuff(aDetalhe[4],07,len(aBenef[1,2]),aBenef[1,2])

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
	
cLin := ""
For m:= 1 to Len(aDetalhe)
	cLin += aDetalhe[m]+chr(13)+chr(10)
Next m

fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)

For N:=2  to Len(aBenef)
	/*
	Impr("|"+aBenef[n,1],"C",,,00,.F.)
	Impr("|"+aBenef[n,2],"C",,,05,.F.)
	Impr("|","C",,,79 )
	*/
	cTemp:= "|"+ ALLTRIM(aBenef[n,1])
	cLin += cTemp+Replicate(" ",04-LEN(cTemp))
	cTemp:= "|"+ ALLTRIM(aBenef[n,2])
	cLin += cTemp+Replicate(" ",79-LEN(cLin+cTemp))
	cTemp:= "|"
	cLin += cTemp										
	
	cLin += chr(13)+chr(10)
	
	nHdl := FOpen( cNomeArq, 2 )
	FSeek( nHdl, 0 , FS_END )
	fWrite(nHdl,cLin,Len(cLin))
	fClose(nHdl)
        
	cLin := ""	
	
Next N

//Impr(aDetalhe[1],"C")
cLin += aDetalhe[1]
cLin += chr(13)+chr(10)

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)

cLin := ""

Return
       
/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpSindN ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼*/
Static Function  fImpSindN(aConSin, cTituSind)
Local N , M , nDet
Local aDetalhe	:= {}
				
aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
aAdd(aDetalhe,"|                                                                              |")
aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
aAdd(aDetalhe,"|           |       |               |                                          |")
aAdd(aDetalhe,"|-----------+-------+---------------+------------------------------------------|")
            //"|Data       | Mes   |          Valor| Sindicato                                |"
             //12345678901234567890123456789012345678901234567890123456789012345678901234567890
             //         10        20        30        40        50        60        70       
nDet	:= (78 - Len(cTituSind)) / 2 
aDetalhe[2]	:= stuff(aDetalhe[2],nDet,len(oemtoAnsi(cTituSind)) , oEmtoAnsi(cTituSind) )
aDetalhe[4]	:= Stuff(aDetalhe[4],02,len(aConSin[1,1]),aConSin[1,1]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],14,len(aConSin[1,2]),aConSin[1,2]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],22,len(aConSin[1,3]),aConSin[1,3]) 
aDetalhe[4]	:= Stuff(aDetalhe[4],38,len(aConSin[1,4]),aConSin[1,4]) 

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
	
cLin := ""
For m:= 1 to Len(aDetalhe)
	cLin += aDetalhe[m]+chr(13)+chr(10)
Next m

fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)

For N:=2  to Len(aConSin)
	
	cLin := ""
	
	cTemp:= "|"+ ALLTRIM(aConSin[n,1])
	cLin += cTemp+Replicate(" ",12-LEN(cTemp))
	cTemp:= "|"+ ALLTRIM(aConSin[n,2])
	cLin += cTemp+Replicate(" ",20-LEN(cLin+cTemp))
	cTemp:= "|"+ ALLTRIM(aConSin[n,3])
	cLin += cTemp+Replicate(" ",36-LEN(cLin+cTemp))
	cTemp:= "|"+ ALLTRIM(left(aConSin[n,4],40))
	cLin += cTemp+Replicate(" ",79-LEN(cLin+cTemp))
	cTemp:= "|"
	cLin += cTemp										
	
	cLin += chr(13)+chr(10)
	
	nHdl := FOpen( cNomeArq, 2 )
	FSeek( nHdl, 0 , FS_END )
	fWrite(nHdl,cLin,Len(cLin))
	fClose(nHdl)
        
	cLin := ""
		
Next N

//Impr(aDetalhe[1],"C")
cLin += aDetalhe[1]
cLin += chr(13)+chr(10)

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)

cLin := ""

Return

/*
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºPrograma  ³fImpTraN  ºAutor  ³Desenv - RH Natie   º Data ³  12/13/01   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDesc.     ³ Impressao Linhas de detalhe  Modo Normal                   º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
*/
Static Function  fImpTraN(aTransf)
Local N , M , nDet
Local aDetalhe	:= {}
Local lImp := .F.

If li >= 60 
	Impr(" ","P")
Endif
Impr("","C")
				
aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
aAdd(aDetalhe,"|                                                                              |")
aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
aAdd(aDetalhe,"|           |                                                                  |")
aAdd(aDetalhe,"|           |                                                                  |")
aAdd(aDetalhe,"|-----------+------------------------------------------------------------------|")
            //"|           | Empresa de Origem                                                | "
            //"|Data       | Empresa de Destino                                               | "
            // 12345678901234567890123456789012345678901234567890123456789012345678901234567890
            //          10        20        30        40        50        60        70       
nDet	:= (78 - Len(STR0041)) / 2 
aDetalhe[2]	:= stuff(aDetalhe[2],nDet,len(oemtoAnsi(STR0041)) , oEmtoAnsi(STR0041) )
aDetalhe[4]	:= Stuff(aDetalhe[4],14,len(aTransf[1,2]),aTransf[1,2])
aDetalhe[4]	:= Stuff(aDetalhe[4],65,len(aTransf[1,3]),aTransf[1,3])
aDetalhe[5]	:= Stuff(aDetalhe[5],02,len(aTransf[2,1]),aTransf[2,1])
aDetalhe[5]	:= Stuff(aDetalhe[5],14,len(aTransf[2,2]),aTransf[2,2])
aDetalhe[5]	:= Stuff(aDetalhe[5],65,len(aTransf[2,3]),aTransf[2,3])

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
	
cLin := ""
For m:= 1 to Len(aDetalhe)
	cLin += aDetalhe[m]+chr(13)+chr(10)
Next m

fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)

For N:=3  to Len(aTransf)
	/*
	Impr("|","C",,,00,.F.)
	If !empty(aTransf[n,3])
		Impr("|"+aTransf[n,3],"C",,,12,.F.)
		Impr("|","C",,,79 )	
	Endif
	If !empty(aTransf[n,1] )
		Impr("|"+aTransf[n,1],"C",,,00,.F.)
	endif	
	Impr("|"+aTransf[n,2],"C",,,12,.F.)
	Impr("|","C",,,79 )	
	*/
	cLin := ""
	lImp := .F.
	
	cTemp:= ""
	If !empty(aTransf[n,1] )
		
		cTemp:= "|"+ ALLTRIM(aTransf[n,1])
		cLin += cTemp+Replicate(" ",12-LEN(cTemp))		
	Else
		cTemp:= "|"
		cLin += cTemp+Replicate(" ",12-LEN(cTemp))
			
	endif
	
	If !empty(aTransf[n,3])
		cTemp:= "|"+ ALLTRIM(aTransf[n,3])		
		cLin += cTemp+Replicate(" ",79-LEN(cLin+cTemp))	
	Else
		//cTemp:= "|"+ ALLTRIM(SUBSTR(aTransf[n,2],1,68))
		cTemp:= "|"+ ALLTRIM(SUBSTR(aTransf[n,2],1,66))				
		cLin += cTemp+Replicate(" ",79-LEN(cLin+cTemp))	
		lImp := .T.
	EndIf
	
	cTemp:= "|"		
	cLin += cTemp	
	cLin += chr(13)+chr(10)		

	nHdl := FOpen( cNomeArq, 2 )
	FSeek( nHdl, 0 , FS_END )
	fWrite(nHdl,cLin,Len(cLin))
	fClose(nHdl)	
    
    cLin := ""	
	
	If lImp == .T.
		If LEN(ALLTRIM(aTransf[n,2])) > 66
			cLin := ""
			cTemp:= "|"
			cLin += cTemp+Replicate(" ",12-LEN(cTemp))
			//cTemp:= "|"+ ALLTRIM(SUBSTR(aTransf[n,2],1,68))
			cTemp:= "|"+ ALLTRIM(SUBSTR(aTransf[n,2],67,66))				
			cLin += cTemp+Replicate(" ",79-LEN(cLin+cTemp))
					
			cTemp:= "|"		
			cLin += cTemp	
			cLin += chr(13)+chr(10)
			
			nHdl := FOpen( cNomeArq, 2 )
			FSeek( nHdl, 0 , FS_END )
			fWrite(nHdl,cLin,Len(cLin))
			fClose(nHdl)	
		    
		    cLin := ""
    		
		EndIf	
	EndIf
    
	If lImp == .F.
		cTemp:= "|"
		cLin += cTemp+Replicate(" ",12-LEN(cTemp))
		//cTemp:= "|"+ ALLTRIM(SUBSTR(aTransf[n,2],1,68))
		cTemp:= "|"+ ALLTRIM(SUBSTR(aTransf[n,2],1,66))				
		cLin += cTemp+Replicate(" ",79-LEN(cLin+cTemp))
				
		cTemp:= "|"		
		cLin += cTemp	
		cLin += chr(13)+chr(10)
		
		nHdl := FOpen( cNomeArq, 2 )
		FSeek( nHdl, 0 , FS_END )
		fWrite(nHdl,cLin,Len(cLin))
		fClose(nHdl)	
	    
	    cLin := ""				
		
		If LEN(ALLTRIM(aTransf[n,2])) > 66
			cLin := ""
			cTemp:= "|"
			cLin += cTemp+Replicate(" ",12-LEN(cTemp))
			//cTemp:= "|"+ ALLTRIM(SUBSTR(aTransf[n,2],1,68))
			cTemp:= "|"+ ALLTRIM(SUBSTR(aTransf[n,2],67,66))				
			cLin += cTemp+Replicate(" ",79-LEN(cLin+cTemp))
					
			cTemp:= "|"		
			cLin += cTemp	
			cLin += chr(13)+chr(10)
			
			nHdl := FOpen( cNomeArq, 2 )
			FSeek( nHdl, 0 , FS_END )
			fWrite(nHdl,cLin,Len(cLin))
			fClose(nHdl)	
		    
		    cLin := ""				
	    					
		EndIf		
		

    EndIf
    
Next N
//Impr(aDetalhe[1],"C")
cLin += aDetalhe[1]
cLin += chr(13)+chr(10)

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)

cLin := ""

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fAssinatBox ºAutor  ³RH - Natie          º Data ³  12/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Box-Assinatura Empregado e responsavel pela Empresa           º±±
±±º          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fAssinaBox()
Local aArea		:= GetArea()
Local nLinhas 	:= 0 
Local nCol		:= int( ( nColBox - ( Len(STR0082) * 100 / 7) )) /2		// Assinaturas 
Local M 		:= 0 
Local aDetalhe 	:= {}

aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
aAdd(aDetalhe,"|                                                                              |")
aAdd(aDetalhe,"|------------------------------------------------------------------------------|")
aAdd(aDetalhe,"|          |                                  |                                |")
aAdd(aDetalhe,"|----------+----------------------------------+--------------------------------|")
aAdd(aDetalhe,"|          |                                  |                                |")
aAdd(aDetalhe,"|          |                                  |                                |")
aAdd(aDetalhe,"|          |                                  |                                |")	
aAdd(aDetalhe,"|          |                                  |                                |")	
aAdd(aDetalhe,"|          | -------------------------------- | ------------------------------ |")
aAdd(aDetalhe,"|          |                                  |                                |")
aAdd(aDetalhe," ------------------------------------------------------------------------------ ")
             //|Polegar   | Assinatura Funcionario             Responsavel Legal              |"  
             //12345678901234567890123456789012345678901234567890123456789012345678901234567890
             //         10        20        30        40        50        60        70       
nDet			:= (78 - Len(STR0082)) / 2 
aDetalhe[02]	:= stuff(aDetalhe[02],nDet,len(oemtoAnsi(STR0082)) ,oEmtoAnsi(STR0082) )
aDetalhe[04]	:= Stuff(aDetalhe[04],02,len(oemtoAnsi(STR0085))   ,oemtoAnsi(STR0085) ) 
aDetalhe[04]	:= Stuff(aDetalhe[04],13,len(oemtoAnsi(STR0083))   ,oemtoAnsi(STR0083) ) 
aDetalhe[04]	:= Stuff(aDetalhe[04],49,len(oemtoAnsi(STR0084))   ,oemtoAnsi(STR0084) ) 
aDetalhe[11]	:= Stuff(aDetalhe[11],13,len(SRA->RA_NOME )        ,SRA->RA_NOME  ) 
aDetalhe[11]	:= Stuff(aDetalhe[11],49,len(cResponsavel)         ,left(cResponsavel,30)   ) 

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
	
cLin := ""
For m:= 1 to Len(aDetalhe)
	cLin += aDetalhe[m]+chr(13)+chr(10)
Next m

cLin += chr(13)+chr(10)

fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)

cLin := ""
		
RestArea( aArea)
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPER460   ºAutor  ³Microsiga           º Data ³  09/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fImpPeriodo() 
Local aArea		:= GetArea()

nColuna	:= 050

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Periodo de Impressao                                         ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
Impr( repl("-",78),"C",,,01)
If lImpDIni .And. lImpDFim
Impr( OemToAnsi(STR0081) + DTOc(dDataIni) + " - " + dtoc(dDataFin),"C",,,01)	
Endif
Impr( repl("-",78),"C",,,01)
*/

cLin := ""
    
cTemp:= "|"+Replicate("-",78)+"|"
cLin += cTemp+chr(13)+chr(10)	

If lImpDIni .And. lImpDFim
	cTemp:= "|"+OemToAnsi(STR0081) + DTOc(dDataIni) + " - " + dtoc(dDataFin)
	cLin += cTemp+Replicate(" ",79-LEN(cTemp))
	cTemp:= "|"
	cLin += cTemp+chr(13)+chr(10)
Endif

cTemp:= "|"+Replicate("-",78)+"|"
cLin += cTemp+chr(13)+chr(10)		

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)	
	    
cLin := ""
		
RestArea( aArea)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPER460   ºAutor  ³Microsiga           º Data ³  09/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fImpObs()

Local cDet 		:= " ",Ix	:= 1
Local nTaman	:= nTam1	:=	nTam2	:= 0 
Local cDescFol	:= " "
Local nPosF
Local nX 		:= 0 
Local nLinhas	:= 0 
Local aCpoMemo  := {}
Local N,M, nDet
Local aDetalhe	:= {}
Local _Area     := GetArea()

//-- Box Detalhe         
aAdd(aDetalhe," ------------------------------------------------------------------------------")
aAdd(aDetalhe,"|A portaria nº 41 de 28/03/2007 do Ministerio do Trabalho, autoriza a emissao  |") 
aAdd(aDetalhe,"|do extrato eletronico com anotacoes de Ferias, Contribuicoes Sindicais,       |") 
aAdd(aDetalhe,"|transferencias, alteracoes de Salario e Funcao. Recomendamos mante-lo junto a |") 
aAdd(aDetalhe,"|Carteira de Trabalho, em funcao de sua validade prevista na Legislacao        |")
aAdd(aDetalhe,"|Trabalhista.                                                                  |")
aAdd(aDetalhe," ------------------------------------------------------------------------------")

nHdl := FOpen( cNomeArq, 2 )
FSeek( nHdl, 0 , FS_END )
	
cLin := ""
For m:= 1 to Len(aDetalhe)
	cLin += aDetalhe[m]+chr(13)+chr(10)
Next m

cLin += chr(13)+chr(10)

fWrite(nHdl,cLin,Len(cLin))
fClose(nHdl)

cLin := ""

Return
 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPER460   ºAutor  ³Microsiga           º Data ³  07/31/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION fDescTarefa(cVar)

Local aArea := GetArea()
Local cRet:= ""

dbSelectArea( "SRX" )

If dbSeek( xFilial( "SRX" ) + "59" + cVar + "1" )
	cRet := SubStr( SRX->RX_TXT,01,30 )
Endif

RestArea( aArea )
Return ( cRet )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPER460   ºAutor  ³Luis Ricardo Cinalliº Data ³ 11/08/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajuste no campo Relacao do dicionario de dados. Nao estava º±±
±±º          ³ tratando a filial certa na busca da Descricao do Cargo.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSx3()
Local aArea := GetArea()
Local cFieldX3 := ""
Local cFildX3 := GetSx3Cache(cFieldX3,"X3_RELACAO")

// Atualizacao do Inic. Padrao para permitir impressao da descricao 
// do cargo de uma filial a qual o usuario nao esteja logado.
SX3->( dbSetOrder(2)) 
If SX3->( dbSeek( "RA_DCARGO" ) )
	If cFildX3 # 'IF(INCLUI,"",FDESC("SQ3",SRA->RA_CARGO,"Q3_DESCSUM",,SRA->RA_FILIAL))'
		Reclock( "SX3", .F.)
			cFildX3	:= 'IF(INCLUI,"",FDESC("SQ3",SRA->RA_CARGO,"Q3_DESCSUM",,SRA->RA_FILIAL))'
		MsUnlock()
	EndIf
EndIf		                 

// Atualizacao do Inic. Padrao para permitir impressao da descricao 
// do Sindicato de uma filial a qual o usuario nao esteja logado.
If SX3->( dbSeek( "RA_DESCSIN" ) )
	If cFildX3 # 'Iif(Left(cModulo,1)<>"Q",IF(Inclui,"",fDesc("RCE",SRA->RA_SINDICA,"RCE_DESCRI",,SRA->RA_FILIAL)),"")'
		Reclock( "SX3", .F.)
			cFildX3	:= 'Iif(Left(cModulo,1)<>"Q",IF(Inclui,"",fDesc("RCE",SRA->RA_SINDICA,"RCE_DESCRI",,SRA->RA_FILIAL)),"")'
		MsUnlock()
	EndIf
EndIf

SX3->( dbSetOrder(1))

RestArea(aArea)
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³fGp190TpTa³ Autor ³ Jonatas A. T. Alves	³ Data ³ 11/04/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Funcao para exibir os tipos de tarefas para selecao		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ fGp190TpTa()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ GPER460  												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/
STATIC Function fGp190TpTa()

Local MvPar
Local cTitulo	:= ""
Local MvParDef	:= ""
Local aArea		:= GetArea()

Private aTpTar:={}

MvPar := &(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
MvRet := Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno

If lNewProf
	aTpTar :={;
				"1 - " + STR0114,;	//"Fixa"
				"2 - " + STR0115,;	//"Variável"
				"3 - " + STR0116,;	//"Adit. Fixo"
				"4 - " + STR0117;	//"Adit. Var."
			}

	MvParDef	:= "1234"
Else
	aTpTar :={;
				"1 - " + STR0114,;	//"Fixa"
				"2 - " + STR0115;	//"Variável"
			}
			
	MvParDef	:= "12"
EndIf

cTitulo		:= STR0118  //"Tipos de Tarefas"

IF f_Opcoes(@MvPar,cTitulo,aTpTar,MvParDef)  // Chama funcao f_Opcoes
	&MvRet := Mvpar							// Devolve Resultado
EndIF

RestArea(aArea)

Return( .T. )

Static Function fDescSexo(cCod)
Return(If(cCod =="F", STR0065, STR0064 ))	//"Feminino"###"Masculino"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTASX1 ºAutor  ³                         º Data ³        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz criacao do SX1 do relatorio                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AjustaSX1()

Local aEstrut   := {}
Local aSX1      := {}
Local aStruDic  := SX1->( dbStruct() )
Local cAlias    := ""
Local nI        := 0
Local nJ        := 0
Local nTam1     := Len(&("SX1->X1_GRUPO"))
Local nTam2     := Len(&("SX1->X1_ORDEM" ))

aEstrut := { "X1_GRUPO"  , "X1_ORDEM"  , "X1_PERGUNT", "X1_PERSPA" , "X1_PERENG" , "X1_VARIAVL", "X1_TIPO"   , ;
             "X1_TAMANHO", "X1_DECIMAL", "X1_PRESEL" , "X1_GSC"    , "X1_VALID"  , "X1_VAR01"  , "X1_DEF01"  , ;
             "X1_DEFSPA1", "X1_DEFENG1", "X1_CNT01"  , "X1_VAR02"  , "X1_DEF02"  , "X1_DEFSPA2", "X1_DEFENG2", ;
             "X1_CNT02"  , "X1_VAR03"  , "X1_DEF03"  , "X1_DEFSPA3", "X1_DEFENG3", "X1_CNT03"  , "X1_VAR04"  , ;
             "X1_DEF04"  , "X1_DEFSPA4", "X1_DEFENG4", "X1_CNT04"  , "X1_VAR05"  , "X1_DEF05"  , "X1_DEFSPA5", ;
             "X1_DEFENG5", "X1_CNT05"  , "X1_F3"     , "X1_PYME"   , "X1_GRPSXG" , "X1_HELP"   , "X1_PICTURE", ;
             "X1_IDFIL"  }


dbSelectArea( "SX1" )
SX1->( dbSetOrder( 1 ) )
If SX1->( dbSeek( PadR( "PNRGPE460", nTam1 ) ) )
	Return
EndIf

//
// Perguntas PNRGPE460
//

aAdd( aSX1, { ;
	'PNRGPE460'																, ; //X1_GRUPO
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
	'MV_PAR01'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'0201'																	, ; //X1_CNT01
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
	'PNRGPE460'																, ; //X1_GRUPO
	'02'																	, ; //X1_ORDEM
	'Filial Até ?'															, ; //X1_PERGUNT
	'¿A Sucursal ?'															, ; //X1_PERSPA
	'To Branch ?'															, ; //X1_PERENG
	'mv_ch2'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	4																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	'Naovazio'																, ; //X1_VALID
	'MV_PAR02'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'0201'																	, ; //X1_CNT01
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
	'PNRGPE460'																, ; //X1_GRUPO
	'03'																	, ; //X1_ORDEM
	'Centro de Custo De ?'													, ; //X1_PERGUNT
	'¿De Centro de Costo ?'													, ; //X1_PERSPA
	'From Cost Center ?'													, ; //X1_PERENG
	'mv_ch3'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	20																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'MV_PAR03'																, ; //X1_VAR01
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
	'PNRGPE460'																, ; //X1_GRUPO
	'04'																	, ; //X1_ORDEM
	'Centro de Custo Ate ?'													, ; //X1_PERGUNT
	'¿A Centro de Costo ?'													, ; //X1_PERSPA
	'To Cost Center ?'														, ; //X1_PERENG
	'mv_ch4'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	20																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	'naovazio'																, ; //X1_VALID
	'MV_PAR04'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'zzzzzzzzzzzzzzzzzzzz'													, ; //X1_CNT01
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
	'PNRGPE460'																, ; //X1_GRUPO
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
	'MV_PAR05'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'000002'																, ; //X1_CNT01
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
	'PNRGPE460'																, ; //X1_GRUPO
	'06'																	, ; //X1_ORDEM
	'Matricula Até ?'														, ; //X1_PERGUNT
	'¿A Matricula ?'														, ; //X1_PERSPA
	'To Registration ?'														, ; //X1_PERENG
	'mv_ch6'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	6																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	'Naovazio'																, ; //X1_VALID
	'MV_PAR06'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'000002'																, ; //X1_CNT01
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
	'PNRGPE460'																, ; //X1_GRUPO
	'07'																	, ; //X1_ORDEM
	'Nome De ?'																, ; //X1_PERGUNT
	'¿De Nombre ?'															, ; //X1_PERSPA
	'From Name ?'															, ; //X1_PERENG
	'mv_ch7'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	30																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'MV_PAR07'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'										, ; //X1_CNT01
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
	'.RHNOMED.'																, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'PNRGPE460'																, ; //X1_GRUPO
	'08'																	, ; //X1_ORDEM
	'Nome Até ?'															, ; //X1_PERGUNT
	'¿A Nombre ?'															, ; //X1_PERSPA
	'To Name ?'																, ; //X1_PERENG
	'mv_ch8'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	30																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	'naovazio'																, ; //X1_VALID
	'MV_PAR08'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'										, ; //X1_CNT01
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
	'.RHNOMEA.'																, ; //X1_HELP
	''																		, ; //X1_PICTURE
	''																		} ) //X1_IDFIL

aAdd( aSX1, { ;
	'PNRGPE460'																, ; //X1_GRUPO
	'09'																	, ; //X1_ORDEM
	'Situações ?'															, ; //X1_PERGUNT
	'¿Situaciones ?'														, ; //X1_PERSPA
	'Status ?'																, ; //X1_PERENG
	'mv_ch9'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	5																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	1																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	'fSituacao'																, ; //X1_VALID
	'MV_PAR09'																, ; //X1_VAR01
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
	'PNRGPE460'																, ; //X1_GRUPO
	'10'																	, ; //X1_ORDEM
	'Categorias ?'															, ; //X1_PERGUNT
	'¿Categorias ?'															, ; //X1_PERSPA
	'Classes ?'																, ; //X1_PERENG
	'mv_chA'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	15																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	'fCategoria'															, ; //X1_VALID
	'MV_PAR10'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'ACDEGH**MPST'															, ; //X1_CNT01
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
	'PNRGPE460'																, ; //X1_GRUPO
	'11'																	, ; //X1_ORDEM
	'Alt. Salariais ?'														, ; //X1_PERGUNT
	'¿Modificaciones Salariales ?'											, ; //X1_PERSPA
	'Salary Changes ?'														, ; //X1_PERENG
	'mv_chC'																, ; //X1_VARIAVL
	'N'																		, ; //X1_TIPO
	1																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	2																		, ; //X1_PRESEL
	'C'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'MV_PAR11'																, ; //X1_VAR01
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
	'PNRGPE460'																, ; //X1_GRUPO
	'12'																	, ; //X1_ORDEM
	'Afastamentos ?'														, ; //X1_PERGUNT
	'¿Afastamentos ?'														, ; //X1_PERSPA
	'Leaves ?'																, ; //X1_PERENG
	'mv_chD'																, ; //X1_VARIAVL
	'N'																		, ; //X1_TIPO
	1																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	2																		, ; //X1_PRESEL
	'C'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'MV_PAR12'																, ; //X1_VAR01
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
	'PNRGPE460'																, ; //X1_GRUPO
	'13'																	, ; //X1_ORDEM
	'Ferias ?'																, ; //X1_PERGUNT
	'¿Vacaciones ?'															, ; //X1_PERSPA
	'Vacation ?'															, ; //X1_PERENG
	'mv_chF'																, ; //X1_VARIAVL
	'N'																		, ; //X1_TIPO
	1																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	2																		, ; //X1_PRESEL
	'C'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'MV_PAR13'																, ; //X1_VAR01
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
	'PNRGPE460'																, ; //X1_GRUPO
	'14'																	, ; //X1_ORDEM
	'Alt.Cadastrais ?'														, ; //X1_PERGUNT
	'¿Modificaciones de Archivo ?'											, ; //X1_PERSPA
	'File Data Updating ?'													, ; //X1_PERENG
	'mv_chG'																, ; //X1_VARIAVL
	'N'																		, ; //X1_TIPO
	1																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	1																		, ; //X1_PRESEL
	'C'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'MV_PAR14'																, ; //X1_VAR01
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
	'PNRGPE460'																, ; //X1_GRUPO
	'15'																	, ; //X1_ORDEM
	'Contrib. Sindicais ?'													, ; //X1_PERGUNT
	'¿Aporte Sindical ?'													, ; //X1_PERSPA
	'Union Contributions ?'													, ; //X1_PERENG
	'mv_chH'																, ; //X1_VARIAVL
	'N'																		, ; //X1_TIPO
	1																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	1																		, ; //X1_PRESEL
	'C'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'MV_PAR15'																, ; //X1_VAR01
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
	'PNRGPE460'																, ; //X1_GRUPO
	'16'																	, ; //X1_ORDEM
	'Transferencias ?'														, ; //X1_PERGUNT
	'¿Transferencias ?'														, ; //X1_PERSPA
	'Transfers ?'															, ; //X1_PERENG
	'mv_chI'																, ; //X1_VARIAVL
	'N'																		, ; //X1_TIPO
	1																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	1																		, ; //X1_PRESEL
	'C'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'MV_PAR16'																, ; //X1_VAR01
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
	'PNRGPE460'																, ; //X1_GRUPO
	'17'																	, ; //X1_ORDEM
	'Data Inicial ?'														, ; //X1_PERGUNT
	'¿Fecha Inicial ?'														, ; //X1_PERSPA
	'Initial Date ?'														, ; //X1_PERENG
	'mv_chm'																, ; //X1_VARIAVL
	'D'																		, ; //X1_TIPO
	8																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'MV_PAR17'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'20010101'																, ; //X1_CNT01
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
	'PNRGPE460'																, ; //X1_GRUPO
	'18'																	, ; //X1_ORDEM
	'Data Final ?'															, ; //X1_PERGUNT
	'¿Fecha Final ?'														, ; //X1_PERSPA
	'Final Date ?'															, ; //X1_PERENG
	'mv_chn'																, ; //X1_VARIAVL
	'D'																		, ; //X1_TIPO
	8																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'MV_PAR18'																, ; //X1_VAR01
	''																		, ; //X1_DEF01
	''																		, ; //X1_DEFSPA1
	''																		, ; //X1_DEFENG1
	'20150327'																, ; //X1_CNT01
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
	'PNRGPE460'																, ; //X1_GRUPO
	'19'																	, ; //X1_ORDEM
	'Diretório: ?'															, ; //X1_PERGUNT
	'Diretorio: ?'															, ; //X1_PERSPA
	'Diretorio: ?'															, ; //X1_PERENG
	'mv_cho'																, ; //X1_VARIAVL
	'C'																		, ; //X1_TIPO
	30																		, ; //X1_TAMANHO
	0																		, ; //X1_DECIMAL
	0																		, ; //X1_PRESEL
	'G'																		, ; //X1_GSC
	''																		, ; //X1_VALID
	'MV_PAR19'																, ; //X1_VAR01
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
				aSX1[nI][nPosTam] := &("SXG->XG_SIZE")
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

Return NIL
