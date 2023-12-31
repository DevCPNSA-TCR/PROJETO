
#INCLUDE "GPER180X.CH"
#INCLUDE "report.ch"
#INCLUDE "Protheus.ch"
/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � PTNR180  � Autor � Vinicius Figueiredo   � Data � 15.08.13 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Rela��o Nominal do INSS Retido consolidado por CC           ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������*/
USER Function PTNR180()
Local	oReport                
Local	aArea 		:= GetArea()
Private	cString		:= "SRA"				// alias do arquivo principal 
Private cPerg		:= "GP180R"
//Private aOrd    	:= {OemToAnsi(STR0004),OemToAnsi(STR0005)}	//"Matricula,Centro de Custo"
Private aOrd    	:= {OemToAnsi(STR0005)}	//"Matricula,Centro de Custo"
Private cTitulo		:= OemToAnsi(STR0010)			//" RELA��O NOMINAL DO I.N.S.S. RETIDO "
Private cAliasQry	:= ""
Private oBreakCCusto
Private oBreakFil
/*
If FindFunction("TRepInUse") .And. TRepInUse()
	//��������������������������������������������������������������Ŀ
	//� Verifica as perguntas selecionadas                           �
	//����������������������������������������������������������������
	pergunte(cPerg,.F.) 

    oReport := ReportDef()
    oReport:PrintDialog()
 Else
 	GPER180R3()
EndIF    
*/
  
GPER180R3()

RestArea( aArea )

Return

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER180R3� Autor � R.H. - Marcos Stiefano  � Data � 04.01.96 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Rela��o Nominal do INSS Retido                               ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPER180(void)                                                ���
���������������������������������������������������������������������������Ĵ��
���Parametros�                                                              ���
���������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                     ���
���������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.               ���
���������������������������������������������������������������������������Ĵ��
���Programador � Data     � BOPS �  Motivo da Alteracao                     ���
���������������������������������������������������������������������������Ĵ��
���J. Ricardo  � 16/02/01 �------� Utilizacao da data base como parametro   ���
���            �          �      � para impressao.                          ���
���Natie       � 18/05/02 �------� Acerto tamanho campo Centro Custo(tam 20)���
���Emerson     � 04/09/02 �------� Exclusao do campo RA_INSSOUT(Excl.do SRA)���
���Ricardo D./ � 25/10/05 �087788� Ajuste para a impressao do movimento de  ���
���Rodrigo     �          �      � 13o salario.                             ���
���Tania       �23/05/2006�098158� Incluida somatoria das verbas Id. 221 e  ���
���            �          �      � 225, comparadas ao maior valor da Tab. de���
���            �          �      � INSS no mes de referencia.               ���
���Tania       �06/10/2006�100148� Alteracao do combo do pergunte 07 en es- ���
���            �          �      � panhol.                                  ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������*/
Static Function GPER180R3()
Local cDesc1  := STR0001		//"Rela��o Nominal I.N.S.S. Retido "
Local cDesc2  := STR0002		//"Ser� impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := STR0003		//"usu�rio."
Local cString := "SRA"  					// Alias do arquivo principal (Base)
Local aOrd    := {STR0004,STR0005}	//"Matr�cula"###"Centro de Custo"
Local aRegs		:= {}
Local aHelp		:= {}
Local aHelpE	:= {}
Local aHelpI	:= {}   
Local cHelp		:= ""

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Basicas)                            �
//����������������������������������������������������������������
Private aReturn  := {STR0006,1,STR0007,2,2,1,"",1 }	//"Zebrado"###"Administra��o"
Private NomeProg := "PTNR180"
Private aLinha   := {}
Private nLastKey := 0
Private cPerg    := "GPR180"

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Programa)                           �
//����������������������������������������������������������������
Private aPosicao1 := {} // Array das posicoes
Private aTotCc1   := {}
Private aTotFil1  := {}
Private aTotEmp1  := {}
Private aInfo     := {}

//��������������������������������������������������������������Ŀ
//� Variaveis Utilizadas na funcao IMPR                          �
//����������������������������������������������������������������
Private Titulo
Private AT_PRG   := "GPER180"
Private wCabec0  := 2
//Private wCabec1  := " FILIAL  C. CUSTO                                           SALARIO CONTRIB.  SALARIO CONTRIB.  SALARIO CONTRIB.  I.N.S.S. RETIDO" //STR0008		//" FILIAL  C. CUSTO   MATR.   NOME FUNCIONARIO                SALARIO CONTRIB.  SALARIO CONTRIB.  SALARIO CONTRIB.  I.N.S.S. RETIDO"
Private wCabec1  := "        C. CUSTO               DESCRI��O                      SALARIO CONTRIB.  SALARIO CONTRIB.  SALARIO CONTRIB.  I.N.S.S. RETIDO" //STR0008		//" FILIAL  C. CUSTO   MATR.   NOME FUNCIONARIO                SALARIO CONTRIB.  SALARIO CONTRIB.  SALARIO CONTRIB.  I.N.S.S. RETIDO"
Private wCabec2  := STR0009		//"                                                             ATE O LIMITE     ACIMA DO LIMITE      T O T A L"
Private Contfl   := 1
Private Li       := 0
Private nTamanho := "M"

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("GPR180",.F.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        //  Filial De                                �
//� mv_par02        //  Filial Ate                               �
//� mv_par03        //  Centro de Custo De                       �
//� mv_par04        //  Centro de Custo Ate                      �
//� mv_par05        //  Matricula De                             �
//� mv_par06        //  Matricula Ate                            �
//� mv_par07        //  Rela��o 1-Folha 2-13�Salario 3-Totalizado�
//� mv_par08        //  Situacoes                                �
//� mv_par09        //  Categorias                               �
//� mv_par10        //  Imprime C.C em Outra Pagina              �
//����������������������������������������������������������������
cTit   := STR0010		//" RELA��O NOMINAL DO I.N.S.S. RETIDO "

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="PTNR180"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

//��������������������������������������������������������������Ŀ
//� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
//����������������������������������������������������������������
nOrdem     := aReturn[8]
cFilDe     := mv_par01
cFilAte    := mv_par02
cCcDe      := mv_par03
cCcAte     := mv_par04
cMatDe     := mv_par05
cMatAte    := mv_par06
nTipRel    := mv_par07
cSituacao  := mv_par08
cCategoria := mv_par09
lSalta     := If( mv_par10 == 1 , .T. , .F. )
cMesArqRef := mv_par11
dDtRefe	   := ctod( "01/" + SubStr(mv_par11,1,2)+"/"+SubStr(mv_par11,3,4), "DDMMYY" )
Titulo := STR0010				//" RELA��O NOMINAL DO I.N.S.S. RETIDO "
Titulo += If(mv_par07==1,STR0011,If(mv_par07==2,STR0012,STR0013))	//"FOLHA"###"13o SALARIO"###"TOTALIZADO"

If nLastKey = 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
Endif

RptStatus({|lEnd| GR180Imp(@lEnd,wnRel,cString)},cTit)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER180  � Autor � R.H. - Marcos Stiefano� Data � 04.01.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rela��o Nominal do INSS Retido                             ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � GPR180Imp(lEnd,wnRel,cString)                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd        - A��o do Codelock                             ���
���          � wnRel       - T�tulo do relat�rio                          ���
���Parametros� cString     - Mensagem			                          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function GR180Imp(lEnd,WnRel,cString)
//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Programa)                           �
//����������������������������������������������������������������
Local CbTxt //Ambiente
Local CbCont
Local aCodFol   := {}
Local nInss     := 0
Local nSalAte   := 0
Local nSalAci   := 0                                       
Local nRcValor	:= 0
Local aOrdBag	:= {}
Local aOrdBagRI	:= {}
Local aTInss	:= {}   
Local aSortTinss:= {}
Local cArqMov	:= cAliasMov := cAliasRI := cArqMovRI := ""

/*
��������������������������������������������������������������Ŀ
� Variaveis de Acesso do Usuario                               �
����������������������������������������������������������������*/
Local cAcessaSRA	:= &( " { || " + ChkRH( "GPER180" , "SRA" , "2" ) + " } " )
Local cAcessaSRC	:= &( " { || " + ChkRH( "GPER180" , "SRC" , "2" ) + " } " )
Local cAcessaSRI	:= &( " { || " + ChkRH( "GPER180" , "SRI" , "2" ) + " } " )

nOrdem := 2 //VINICIUS
dbSelectArea( "SRA" )
If nOrdem == 1
	dbSetOrder( 1 )
ElseIf nOrdem == 2
	dbSetOrder( 2 )
Endif

dbGoTop()
If nOrdem == 1
	dbSeek(cFilDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim    := cFilAte + cMatAte
ElseIf nOrdem == 2
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim    := cFilAte + cCcAte + cMatAte
Endif

cFilialAnt := Space(FWGETTAMFILIAL)
cCcAnt     := Space(20)

//��������������������������������������������������������������Ŀ
//| Verifica se existe o arquivo de fechamento do 13o salario    |
//����������������������������������������������������������������
If ( nTipRel == 2 .Or. nTipRel == 3 ) .And. Substr(cMesArqRef,1,2) == "12"
	//-- Abre o SRI
	//If !OpenSrc( "13"+Substr(cMesArqRef,3,4), @cAliasRI, @aOrdBagRI, @cArqMovRI, dDtRefe )
		//-- Se solicitada somente a impressao de 13o salario retorna pois nao conseguiu abrir o arquivo.
		If nTipRel == 2
			Return .f.
		Endif
	//Endif
	// 01/10/2018 *******************************************************************************************************************
    // TOTVS TDN - http://tdn.totvs.com/pages/releaseview.action?pageId=392503027
    //*******************************************************************************************************************************
Elseif nTipRel == 2
	Return .f.
Endif

//��������������������������������������������������������������Ŀ
//| Verifica se existe o arquivo de fechamento do mes informado  |
//����������������������������������������������������������������
//If nTipRel == 1 .Or. nTipRel == 3
//	If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, dDtRefe )
//		Return .f.
//	Endif
//Endif
// 01/10/2018 *******************************************************************************************************************
// TOTVS TDN - http://tdn.totvs.com/pages/releaseview.action?pageId=392503027
//*******************************************************************************************************************************



//-- Carrega Tabela de Inss
Car_Inss(@aTInss,MesAno(dDtRefe))            
aSortTinss	:= aSort(aTInss,,,{|x,y| x[1] > y[1] })

dbSelectArea( "SRA" )
SetRegua(SRA->(RecCount()))

While	!EOF() .And. &cInicio <= cFim
	
	//��������������������������������������������������������������Ŀ
	//� Movimenta Regua Processamento                                �
	//����������������������������������������������������������������
	IncRegua()

	If SRA->RA_FILIAL # cFilialAnt
		If !Fp_CodFol(@aCodFol,SRA->RA_FILIAL) .Or. ;
			!fInfo(@aInfo,SRA->RA_FILIAL)
			Exit
		Endif
		dbSelectArea( "SRA" )
		cFilialAnt := SRA->RA_FILIAL
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� Cancela Impres�o ao se pressionar <ALT> + <A>                �
	//����������������������������������������������������������������
	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	EndIF
	
	//��������������������������������������������������������������Ŀ
	//� Consiste Parametriza��o do Intervalo de Impress�o            �
	//����������������������������������������������������������������
	If (Sra->Ra_Mat < cMatDe) .Or. (Sra->Ra_Mat > cMatAte) .Or. ;
		(Sra->Ra_CC < cCcDe) .Or. (Sra->Ra_CC > cCCAte)
		fTestaTotal()		
		Loop
	EndIf
	
	/*
	�����������������������������������������������������������������������Ŀ
	�Consiste Filiais e Acessos                                             �
	�������������������������������������������������������������������������*/
	IF !( SRA->RA_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRA )
		fTestaTotal()
	   	Loop
	EndIF

	//��������������������������������������������������������������Ŀ
	//� Verifica Situacao e Categoria do Funcionario                 �
	//����������������������������������������������������������������
	If !( SRA->RA_SITFOLH $ cSituacao ) .OR. !( SRA->RA_CATFUNC $ cCategoria )
		fTestaTotal()
		Loop
	Endif

	nInss := nSalAte := nSalAci := 0

	If nTipRel == 1 .Or. nTipRel == 3
		dbSelectArea( "SRC" )
		dbSetOrder( 1 )
		//��������������������������������������������������������������Ŀ
		//� Pega INSS da Folha                                           �
		//����������������������������������������������������������������
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[064,1] )
			While !Eof() .And. ( SRC->RC_PD == aCodFol[064,1] )

				/*
				�����������������������������������������������������������������������Ŀ
				�Consiste Filiais e Acessos                                             �
				�������������������������������������������������������������������������*/
				IF !( SRC->RC_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRC )
					dbSelectArea("SRC")
			      	dbSkip()
			       	Loop
				EndIF
				
				nInss += SRC->RC_VALOR
				dbSkip()
			Enddo
		Endif

		//��������������������������������������������������������������Ŀ
		//� Pega INSS de F�rias                                          �
		//����������������������������������������������������������������
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[065,1] )
			While !Eof() .And. ( SRC->RC_PD == aCodFol[065,1] )
				
				/*
				�����������������������������������������������������������������������Ŀ
				�Consiste Filiais e Acessos                                             �
				�������������������������������������������������������������������������*/
				IF !( SRC->RC_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRC )
					dbSelectArea("SRC")
			      	dbSkip()
			       	Loop
				EndIF

				nInss += SRC->RC_VALOR
				dbSkip()
			Enddo
		Endif

		//��������������������������������������������������������������Ŀ
		//� Pega INSS do 13� Salario                                     �
		//����������������������������������������������������������������
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[070,1] )
			While !Eof() .And. ( SRC->RC_PD == aCodFol[070,1] )
				
				/*
				�����������������������������������������������������������������������Ŀ
				�Consiste Filiais e Acessos                                             �
				�������������������������������������������������������������������������*/
				IF !( SRC->RC_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRC )
					dbSelectArea("SRC")
			      	dbSkip()
			       	Loop
				EndIF
				
				nInss += SRC->RC_VALOR
				dbSkip()
			Enddo
		Endif

		//��������������������������������������������������������������Ŀ
		//� Pega Salario Contribui��o Ate o Limite Base ( Folha )        �
		//����������������������������������������������������������������
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[013,1] )
			While !Eof() .And.  ( SRC->RC_PD == aCodFol[013,1] )
		
				/*
				�����������������������������������������������������������������������Ŀ
				�Consiste Filiais e Acessos                                             �
				�������������������������������������������������������������������������*/
				IF !( SRC->RC_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRC )
					dbSelectArea("SRC")
			      	dbSkip()
			       	Loop
				EndIF

				nSalAte		+= SRC->RC_VALOR
				dbSkip()
			Enddo
		Endif

		//��������������������������������������������������������������Ŀ
		//� Pega Salario Contribui��o (Autonomos)                        �
		//����������������������������������������������������������������
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[225,1] )
			While !Eof() .And. ( SRC->RC_PD == aCodFol[225,1] )
				IF !( SRC->RC_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRC )
					dbSelectArea("SRC")
			      	dbSkip()
			       	Loop
				EndIF
				nRcValor	:= SRC->RC_VALOR
				nRcValor	:= Iif(aSortTinss[1][1]<nRcValor,aSortTinss[1][1],nRcValor)
				nSalAte		+= nRcValor
				nSalAci 	+= SRC->RC_VALOR - nRcValor 
				dbSkip()
			Enddo
		Endif
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[221,1] )
			While !Eof() .And. ( SRC->RC_PD == aCodFol[221,1] )
				IF !( SRC->RC_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRC )
					dbSelectArea("SRC")
			      	dbSkip()
			       	Loop
				EndIF
				nRcValor	:= SRC->RC_VALOR
				nRcValor	:= Iif(aSortTinss[1][1]<nRcValor,aSortTinss[1][1],nRcValor)
				nSalAte		+= nRcValor
				nSalAci 	+= SRC->RC_VALOR - nRcValor 
				dbSkip()
			Enddo
		Endif

		//��������������������������������������������������������������Ŀ
		//� Pega Salario Contribui��o Acima do Limite Base ( Folha )     �
		//����������������������������������������������������������������
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[014,1] )
			While !Eof() .And. ( SRC->RC_PD == aCodFol[014,1] )
				
				/*
				�����������������������������������������������������������������������Ŀ
				�Consiste Filiais e Acessos                                             �
				�������������������������������������������������������������������������*/
				IF !( SRC->RC_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRC )
					dbSelectArea("SRC")
			      	dbSkip()
			       	Loop
				EndIF

				nSalAci += SRC->RC_VALOR
				dbSkip()
			Enddo
		Endif

		//��������������������������������������������������������������Ŀ
		//� Pega Salario Contribui��o Ate o Limite Base ( 13� Salario )  �
		//����������������������������������������������������������������
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[019,1] )
			While !Eof() .And. ( SRC->RC_PD == aCodFol[019,1] )

				/*
				�����������������������������������������������������������������������Ŀ
				�Consiste Filiais e Acessos                                             �
				�������������������������������������������������������������������������*/
				IF !( SRC->RC_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRC )
					dbSelectArea("SRC")
			      	dbSkip()
			       	Loop
				EndIF

				nSalAte += SRC->RC_VALOR
				dbSkip()
			Enddo
		Endif

		//��������������������������������������������������������������Ŀ
		//� Pega Salario Contribui��o Acima do Limite Base (13� Salario) �
		//����������������������������������������������������������������
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[020,1] )
			While !Eof() .And. ( SRC->RC_PD == aCodFol[020,1] )
	
				/*
				�����������������������������������������������������������������������Ŀ
				�Consiste Filiais e Acessos                                             �
				�������������������������������������������������������������������������*/
				IF !( SRC->RC_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRC )
					dbSelectArea("SRC")
			      	dbSkip()
			       	Loop
				EndIF

				nSalAci += SRC->RC_VALOR
				dbSkip()
			Enddo
		Endif
	Endif

	If nTipRel == 2 .Or. nTipRel == 3
		dbSelectArea( "SRI" )

		//��������������������������������������������������������������Ŀ
		//� Pega INSS do 13� Salario                                     �
		//����������������������������������������������������������������
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[070,1] )
			While !Eof() .And. ( SRI->RI_PD == aCodFol[070,1] )

				/*
				�����������������������������������������������������������������������Ŀ
				�Consiste Filiais e Acessos                                             �
				�������������������������������������������������������������������������*/
				IF !( SRI->RI_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRI )
					dbSelectArea("SRI")
			      	dbSkip()
			       	Loop
				EndIF

				nInss += SRI->RI_VALOR
				dbSkip()
			Enddo
		Endif

		//��������������������������������������������������������������Ŀ
		//� Pega Salario Contribui��o Ate o Limite Base ( 13� Salario )  �
		//����������������������������������������������������������������
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[019,1] )
			While !Eof() .And. ( SRI->RI_PD == aCodFol[019,1] )
				
				/*
				�����������������������������������������������������������������������Ŀ
				�Consiste Filiais e Acessos                                             �
				�������������������������������������������������������������������������*/
				IF !( SRI->RI_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRI )
					dbSelectArea("SRI")
			      	dbSkip()
			       	Loop
				EndIF

				nSalAte += SRI->RI_VALOR
				dbSkip()
			Enddo
		Endif

		//��������������������������������������������������������������Ŀ
		//� Pega Salario Contribui��o Acima do Limite Base (13� Salario) �
		//����������������������������������������������������������������
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[020,1] )
			While !Eof() .And. ( SRI->RI_PD == aCodFol[020,1] )

				/*
				�����������������������������������������������������������������������Ŀ
				�Consiste Filiais e Acessos                                             �
				�������������������������������������������������������������������������*/
				IF !( SRI->RI_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRI )
					dbSelectArea("SRI")
			      	dbSkip()
			       	Loop
				EndIF

				nSalAci += SRI->RI_VALOR
				dbSkip()
			Enddo
		Endif
	Endif

	If nInss == 0.00 .And. nSalAci == 0.00 .And. nSalAte == 0.00
		dbSelectArea( "SRA" )
		fTestaTotal()
		Loop
	Endif

	//��������������������������������������������������������������Ŀ
	//� Calcula o Bloco para o Funcionario                           �
	//����������������������������������������������������������������
	aPosicao1 := { } // Limpa Arrays
	Aadd( aPosicao1 , { 0 , 0 , 0 , 0 } )
	
	//��������������������������������������������������������������Ŀ
	//� Atualiza o Bloco para os Totalizadores                       �
	//����������������������������������������������������������������
	nPos0 := nSalAte
	nPos1 := nSalAci
	nPos2 := nSalAte + nSalAci
	nPos3 := nInss
	Atualiza(@aPosicao1,1,nPos0,nPos1,nPos2,nPos3)
	
	//��������������������������������������������������������������Ŀ
	//� Atualizando Totalizadores                                    �
	//����������������������������������������������������������������
	fAtuCont(@aToTCc1)  // Centro de Custo
	fAtuCont(@aTotFil1) // Filial
	fAtuCont(@aTotEmp1) // Empresa
	
	//��������������������������������������������������������������Ŀ
	//� Impressao do Funcionario                                     �
	//����������������������������������������������������������������
	//fImpFun() VINICIUS
	fTestaTotal()  // Quebras e Skips
EndDo

//��������������������������������������������������������������Ŀ
//� Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      �
//����������������������������������������������������������������
If !Empty( cAliasMov )
	fFimArqMov( cAliasMov , aOrdBag , cArqMov )
EndIf

If !Empty( cAliasRI )
	fFimArqMov( cAliasRI , aOrdBagRI , cArqMovRI )
Endif

//��������������������������������������������������������������Ŀ
//� Termino do Relatorio                                         �
//����������������������������������������������������������������
dbSelectArea( "SRA" )
Set Filter to
dbSetOrder(1)
Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

*-------------------------------------------------------------*
Static Function Atualiza(aMatriz,nElem,nPos0,nPos1,nPos2,nPos3)
*-------------------------------------------------------------*
aMatriz[nElem,1] := nPos0
aMatriz[nElem,2] := nPos1
aMatriz[nElem,3] := nPos2
aMatriz[nElem,4] := nPos3

Return Nil

*--------------------------*
Static Function fTestaTotal
*--------------------------*
dbSelectArea( "SRA" )

cFilialAnt := SRA->RA_FILIAL              // Iguala Variaveis
cCcAnt     := SRA->RA_CC
dbSkip()

If Eof() .Or. &cInicio > cFim
	fImpCc()
	fImpFil()
	fImpEmp()
Elseif cFilialAnt # SRA->RA_FILIAL
	fImpCc()
	fImpFil()
Elseif cCcAnt # SRA->RA_CC
	fImpCc()
Endif

Return Nil

*------------------------*
Static Function fImpFun()
*------------------------*

cDet := " "+SRA->RA_FILIAL+" "+Subs(SRA->RA_CC+space(20),1,20)+" "+SRA->RA_MAT+" "+Left(SRA->RA_NOME,30)
cDet += SPACE(2) + TRANSFORM(aPosicao1[1,1],"@E 999,999,999.99")
cDet += SPACE(3) + TRANSFORM(aPosicao1[1,2],"@E 999,999,999.99")
cDet += SPACE(4) + TRANSFORM(aPosicao1[1,3],"@E 999,999,999.99")
cDet += SPACE(3) + TRANSFORM(aPosicao1[1,4],"@E 999,999,999.99")
Impr(cDet,"C")

Return Nil

*-----------------------*
Static Function fImpCc()
*-----------------------*
Local lRetu1 := .T.

If Len(aTotCc1) == 0 .Or. nOrdem # 2
	Return Nil
Endif

//cDet 		:= Repl("-",132)
//Impr(cDet,"C")
//VINICIUS

cDet 		:= substr(cCcAnt+space(20),1,20) +" - "+DescCc(cCcAnt,cFilialAnt) + Space(04)	//"TOTAL C.CUSTO -> "
//lRetu1 	:= fImpComp(aTotCc1) // Imprime

aposicao := aTotCc1
npos := 1 

cDet += SPACE(12) + TRANSFORM(aPosicao[nPos,1],"@E 999,999,999.99")
cDet += SPACE(3) + TRANSFORM(aPosicao[nPos,2],"@E 999,999,999.99")
cDet += SPACE(4) + TRANSFORM(aPosicao[nPos,3],"@E 999,999,999.99")
cDet += SPACE(3) + TRANSFORM(aPosicao[nPos,4],"@E 999,999,999.99")
Impr(cDet,"C")



aTotCc1 :={}      // Zera

//cDet := Repl("-",132)
//Impr(cDet,"C")

//��������������������������������������������������������������Ŀ
//� Salta de Pagina na Quebra de Centro de Custo (lSalta = .T.)  �
//����������������������������������������������������������������
If .F.//lSalta
	Impr("","P")
Endif

Return Nil

*------------------------*
Static Function fImpFil()
*------------------------*
Local lRetu1 := .T.
Local cDescFil

If Len(aTotFil1) == 0
	Return Nil
Endif

If nOrdem # 2
	cDet := Repl("-",132)
	Impr(cDet,"C")
Endif

cDescFil := aInfo[1] 
cDet     := STR0015 + cFilialAnt+" - " + cDescFil + Space(28)	//"TOTAL FILIAL -> "

lRetu1 := fImpComp(aTotFil1) // Imprime

aTotFil1 :={}      // Zera

cDet := Repl("-",132)
Impr(cDet,"C")

Return Nil

*------------------------*
Static Function fImpEmp()
*------------------------*
Local lRetu1 := .T.

If Len(aTotEmp1) == 0
	Return Nil
Endif

cDet := STR0016 + SubStr(aInfo[3],1,40) + Space(07)	//"TOTAL EMPRESA -> "

lRetu1 := fImpComp(aTotEmp1) // Imprime

aTotEmp1 :={}      // Zera

cDet := Repl("-",132)
Impr(cDet,"C")

Impr("","F")

Return Nil

*-------------------------------------------------------------*
Static Function fImpComp(aPosicao) // Complemento da Impressao
*-------------------------------------------------------------*
Local z    := 0
Local nPos := 1

//�������������������������������������������������������������Ŀ
//� Resultado de Impressao para testar se tudo nao esta zerado  �
//���������������������������������������������������������������
Local nResImp := 0

//��������������������������������������������������������������Ŀ
//� Auxiar para Tratamento do Bloco de Codigo                    �
//����������������������������������������������������������������
Local aAux := {1,2,3,4}

//��������������������������������������������������������������Ŀ
//� Auxiar para Tratamento do Bloco de Codigo                    �
//����������������������������������������������������������������
For z := 1 To 4
	AeVal(aPosicao,{ |X| nResImp += X[aAux[z]] })  // Testa se a Soma == 0
Next

//��������������������������������������������������������������Ŀ
//� Imprime se Possui Valores                                    �
//����������������������������������������������������������������
If nResImp > 0
	cDet += TRANSFORM(aPosicao[nPos,1],"@E 999,999,999.99")
	cDet += SPACE(3) + TRANSFORM(aPosicao[nPos,2],"@E 999,999,999.99")
	cDet += SPACE(4) + TRANSFORM(aPosicao[nPos,3],"@E 999,999,999.99")
	cDet += SPACE(3) + TRANSFORM(aPosicao[nPos,4],"@E 999,999,999.99")
	Impr(cDet,"C")
	Return( .T. )
Else
	Return( .F. )
Endif

*---------------------------------------------------------*
Static Function fAtuCont(aArray1)  // Atualiza Acumuladores
*---------------------------------------------------------*
Local x := 0

If Len(aArray1) > 0
	For x := 1 To 4
		aArray1[1,x] += aPosicao1[1,x]
	Next
Else
	aArray1 := Aclone(aPosicao1)
Endif

Return Nil
