#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.Ch"
#INCLUDE "FONT.CH"
#DEFINE   c_ent      CHR(13)+CHR(10)

#DEFINE  nPosCCOrc   1  // coluna codigo conta orçamentaria
#DEFINE  nPosMesINI  2  // numero de colunas para somar no parametro de mês inicial (Exemplo: PARAMETRO INFORMADO É 012019. SERÁ SOMADO MAIS ESTAS POSICOES NO MÊS PARA GERAR A COLUNA)
#DEFINE  nPosDesc    2  // coluna da descrição da conta orçamentaria na planilha       
#DEFINE  nLinIni    10  // linha inicial de leitura da planilha


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PTNA050   ºAutor  ³Yttalo martins    º Data ³ 12/01/2015    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gerar a Planilha Orçamentaria (AK1) para que o usuario     º±±
±±º          ³ selecione a planilha a ser importada.                      º±±
±±º          ³ Serão importadas as tabelas AK2 e AK3.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PCO.                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PTNA050()

// Variaveis da Funcao de Controle e GertArea/RestArea
Local _aArea   		:= {}
Local _aAlias  		:= {}
Local nUsado		:= 0
Local cCabAK1		:= ""
Local nOpca			:= 0
Local x             := 0
// Variaveis Private da Funcao
Private oDlg			// Dialog Principal
Private oDlg2			// Dialog Principal
Private nOpcX  		:= 2
Private aGETS   	:= {}
Private aTELA   	:= {}
Private aObjects  	:= {}
Private aSizeAut  	:= MsAdvSize()
Private bWhile    	:= {|| .T. }
Private aBotoes 	:= {} //acrescenta os novos botoes na barra
Private aCol        := {} //Array a ser tratado internamente na MsNewGetDados como aCols
Private a_AK1	 	:= {}
Private oLbx
Private oFont	 	:= TFont():New("Arial",,15,,.T.)
Private cComboBx1
Private aPosObj   	:= {}
Private aCabAK1		:= {}
Private c_dirimp 	:= space(100)
Private cOrcam		:= ""
Private aComboCC	:= {}
Private cComboCC
Private aComboIt	:= {}
Private cComboIt
Private _aNaoEncontrou := {}

Private cGetAno	 	:= Space(4)
Private oGetAno

Private cGetTo   := space(TamSX3("AK6_CODIGO")[1])
Private oGetTo

Private cGetOpe  := space(TamSX3("AKF_CODIGO")[1])
Private oGetOpe

Private cGetItc  := space(TamSX3("CTD_ITEM")[1])
Private oGetItc

Private cGetCvl  := space(TamSX3("CTH_CLVL")[1])
Private oGetCvl

Private cGetCc   := space(TamSX3("CTT_CUSTO")[1])
Private oGetCc

Private aAK3Tipo2	:= {}
Private cNivelAnt	:= ""
Private cNivelAtu	:= ""
Private cTipoAnt	:= ""
Private cAnoIni		:= ""
Private cAnoFim		:= ""
Private cMesIni		:= ""
Private cMesFim		:= ""
Private nDataMin	:= 0
Private nDataMax	:= 0
Private nData   	:= 0
Private cVersao		:= ""
Private nPosNao		:= 0
Private nMoeda      := 1
Private lExit       := .T. //variável utilizada para validar existência de planilha para o ano selecionado e permitir a continuidade na rotina

*----------------------------------------------------------------*
*   Montagem do LISTBOX
*----------------------------------------------------------------*

dbSelectArea("AK1")
dbSetOrder(1)

aAdd( a_AK1, { "", "", "", "", "" })

aObjects := {}

AAdd( aObjects, { 300, 020, .T., .F. } )
AAdd( aObjects, { 300, 070, .T., .T. } )
//AAdd( aObjects, { 300, 005, .T., .T. } )

aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects, .T. )

DEFINE MSDIALOG oDlg TITLE "IMPORTAÇÃO CONTA ORÇAMENTÁRIA - PCO" From aSizeAut[7],00 To aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL

// Defina aqui a chamada dos Aliases para o GetArea
CtrlArea(1, @_aArea, @_aAlias, {"AK1","AK3","AK5"}) // GetArea

@ aPosObj[1][1],aPosObj[1][2] TO aPosObj[1][3]+20,aPosObj[1][4] LABEL "Informe o ano: " PIXEL OF oDlg

@ aPosObj[1][1]+12,aPosObj[1][2]+005 Say "Ano de Referência:" SIZE 100,008 FONT oFont COLOR CLR_HBLUE OF oDlg PIXEL
@ aPosObj[1][1]+12,aPosObj[1][2]+065 MsGet oGetAno Var cGetAno Size 020,005 COLOR CLR_BLACK Picture "@!" Valid (PTNA050A()) PIXEL OF oDlg

@ aPosObj[2][1]+20, aPosObj[2][2] TO aPosObj[2][3]+20, aPosObj[2][4] LABEL "Planilha(s) Orçamentária(s): " PIXEL OF oDlg

/*
+----------------------------------------------------------------+
|   Montagem da aHeader                                          |
+----------------------------------------------------------------+
*/
nUsado := 0
DbSelectArea("AK1")
aCabAK1 := AK1->(DbStruct())
 
//Percorre todos os campos da estrutura da tabela
For x := 1 To Len(aCabAK1)
    //Chama a função que adiciona ao array via @, conforme o campo atual, e o tipo é 4 que será usado em um MsNewGetDados
    u_zX3ToArr(@aCabAK1, aCabAK1[x][1], 4)
Next
/*dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("AK1")
While ( !Eof() .And. SX3->X3_ARQUIVO == "AK1" )
	If ( cNivel >= SX3->X3_NIVEL ) .And. ;
		( Upper(Alltrim(SX3->X3_Campo)) == "AK1_CODIGO" .Or. Upper(Alltrim(SX3->X3_Campo)) == "AK1_VERSAO" .Or. ;
		Upper(Alltrim(SX3->X3_Campo)) == "AK1_VERREV" .Or. Upper(Alltrim(SX3->X3_Campo)) == "AK1_DESCRI" )
		
		nUsado++
		Aadd(aCabAK1,{ TRIM(X3Titulo()),TRIM(SX3->X3_CAMPO) } )
		
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo*/

@ aPosObj[2][1]+30, aPosObj[2][2]+03 LISTBOX oLbx VAR cVar FIELDS HEADER aCabAK1[1][1],aCabAK1[2][1],aCabAK1[3][1],aCabAK1[4][1] ;
SIZE aPosObj[2][4]-09,aPosObj[2][3]-aPosObj[2][1]-13 OF oDlg PIXEL

oLbx:SetArray( a_AK1 )
oLbx:bLine := {|| {	a_AK1[oLbx:nAt,1],;
a_AK1[oLbx:nAt,2],;
a_AK1[oLbx:nAt,3],;
a_AK1[oLbx:nAt,4],;
a_AK1[oLbx:nAt,5]}}


// Cria Componentes Padroes do Sistema
//@ aPosObj[3][1]+20,C(003) Button "Confirma" Size C(037),C(012) PIXEL OF oDlg VALID Action MPEA024A()
CtrlArea(2,_aArea,_aAlias) // RestArea

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{ || IIF(  ( OBRIGATORIO(AGETS,ATELA)  ), (nOpca := 1, iif(PTNPCO2(), oDlg:END(), nOpca := 0)), nOpca := 0)  }, { || oDlg:END() },,aBotoes)



Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PTNPCO2  ºAutor  ³                    º Data ³     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Abre o diretório para o usuário buscar o arquivo a ser     º±±
±±º          ³ importado.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8 - MPE - PCO.                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PTNPCO2()
Local cOrdem
Local lRet 		:= .T.
Local _nOpc		:= 0
Local cValor := space(30)
private _cPerg  := "PTNA050"
private cClaOrc	:= ""
private cOperOrc:= ""
private cCCusto := ""

If Len(a_AK1) > 0 .AND. lExit == .F.
	
	If EMPTY(a_AK1[1][1])
		
		lRet := .F.
		Aviso("ATENÇÃO","Não existe Registro na Tabela de Planilha Orçamentária(AK1) para o ano selecionado! Favor Incluir.",{"OK"})
		
	EndIf
	
Else
	
	lRet := .F.
	Aviso("ATENÇÃO","Não existe Registro na Tabela de Planilha Orçamentária(AK1) para o ano selecionado! Favor Incluir.",{"OK"})
	
EndIf


If lRet == .T.
	
	ValidPerg()
	If !pergunte(_cPerg,.T.)
		lRet := .F.
		return(lRet)
	Else
		
		
		*--------------------------------------------------------------------------*
		*Valida AnoMes
		*--------------------------------------------------------------------------*
		If !ISDIGIT(MV_PAR07) .OR. !ISDIGIT(MV_PAR08)
			Aviso("ATENÇÃO","MesAno de inicio de fim precisam devem possuir o seguinte formato: MMAAAA",{"OK"})
			lRet := .F.
			return(lRet)
		EndIf
		
		If SUBSTR(MV_PAR07,3,4) <> SUBSTR(MV_PAR08,3,4)
			Aviso("ATENÇÃO","Ano de inicio e fim precisam ser iguais.",{"OK"})
			lRet := .F.
			return(lRet)
		EndIf
		
		If SUBSTR(MV_PAR07,3,4) <> cGetAno .OR. SUBSTR(MV_PAR08,3,4) <> cGetAno
			Aviso("ATENÇÃO","Ano de inicio/fim diverge do Ano de referencia",{"OK"})
			lRet := .F.
			return(lRet)
		EndIf
		
		If VAL(SUBSTR(MV_PAR07,1,2)) > VAL(SUBSTR(MV_PAR08,1,2))
			Aviso("ATENÇÃO","Mes de inicio precisa ser menor que Mes fim.",{"OK"})
			lRet := .F.
			return(lRet)
		EndIf
		
		If (VAL(SUBSTR(MV_PAR07,1,2)) < 1 .OR. VAL(SUBSTR(MV_PAR07,1,2)) > 12) .OR.;
			(VAL(SUBSTR(MV_PAR08,1,2)) < 1 .OR. VAL(SUBSTR(MV_PAR08,1,2)) > 12)
			
			Aviso("ATENÇÃO","Mes de inicio de fim precisam estar 01 e 12",{"OK"})
			lRet := .F.
			return(lRet)
		EndIf
		
		*--------------------------------------------------------------------------*
		*Verifica se a planilha orçamentária existe
		*--------------------------------------------------------------------------*
		If !EMPTY(MV_PAR01)
			
			DbSelectArea("AK1")
			DbSetOrder(1)
			If DbSeek( XFilial( "AK1" ) + MV_PAR01 )
				
				cAnoIni   := Substr(DTOS(AK1->AK1_INIPER),1,4)
				cAnoFim   := Substr(DTOS(AK1->AK1_FIMPER),1,4)
				cMesIni   := Substr(DTOS(AK1->AK1_INIPER),5,2)
				cMesFim   := Substr(DTOS(AK1->AK1_FIMPER),5,2)				
				cOrcam := AK1->AK1_CODIGO
				cVersao:= AK1->AK1_VERSAO
				
				nDataMin := VAL( cAnoIni+cMesIni )
				nDataMax := VAL( cAnoFim+cMesFim )
				
				nData    := VAL( SUBSTR(MV_PAR07,3,4) + SUBSTR(MV_PAR07,1,2) )
				
				If nData < nDataMin .OR. nData > nDataMax
					Aviso("ATENÇÃO","MesAno informados precisam estar entre período de início e fim da planilha",{"OK"})
					lRet := .F.				
				EndIf
				
				nData    := VAL( SUBSTR(MV_PAR08,3,4) + SUBSTR(MV_PAR08,1,2) )
				
				If nData < nDataMin .OR. nData > nDataMax
					Aviso("ATENÇÃO","MesAno informados precisam estar entre período de início e fim da planilha",{"OK"})
					lRet := .F.				
				EndIf				
				
			Else
				
				Aviso("ATENÇÃO","Não existe o Registro: "+MV_PAR01+" na Tabela de Planilha Orçamentária (AK1).",{"OK"})
				lRet := .F.
				
			EndIf
			
		Else
			
			Aviso("ATENÇÃO","Código da Planilha Orçamentária (AK1) vazio!",{"OK"})
			lRet := .F.
			
		EndIf
		
		*--------------------------------------------------------------------------*
		*Verifica se a classe orçamentária existe
		*--------------------------------------------------------------------------*
		cClaOrc := MV_PAR02
		
		If !EMPTY(cClaOrc)
			
			DbSelectArea("AK6")
			DbSetOrder(1)
			If !DbSeek( XFilial( "AK6" ) + alltrim(cClaOrc) )
				
				Aviso("ATENÇÃO","Classe Orçamentária: "+cClaOrc+" não encontrada!",{"OK"})
				lRet := .F.
				
			EndIf
			
		Else
			
			Aviso("ATENÇÃO","Código da Classe Orçamentária vazio!",{"OK"})
			lRet := .F.
			
		EndIf
		
		*--------------------------------------------------------------------------*
		*Verifica se a operação orçamentária existe
		*--------------------------------------------------------------------------*
		cOperOrc := MV_PAR03
		
		If !EMPTY(cOperOrc)
			
			DbSelectArea("AKF")
			DbSetOrder(1)
			If !DbSeek( XFilial( "AKF" ) + alltrim(cOperOrc) )
				
				Aviso("ATENÇÃO","Operação Orçamentária: "+cOperOrc+" não encontrada!",{"OK"})
				lRet := .F.
				
			EndIf
			
		Else
			
			Aviso("ATENÇÃO","Código da Operação Orçamentária vazio!",{"OK"})
			lRet := .F.
			
		EndIf
		
		*--------------------------------------------------------------------------*
		*Verifica se o centro de custo existe
		*--------------------------------------------------------------------------*
		cCCusto := MV_PAR04
		
		If !EMPTY(cClaOrc)
			
			DbSelectArea("CTT")
			DbSetOrder(1)
			If !DbSeek( XFilial( "CTT" ) + alltrim(cCCusto) )
				
				Aviso("ATENÇÃO","Classe Orçamentária: "+cCCusto+" não encontrada!",{"OK"})
				lRet := .F.
				
			EndIf
			
		Else
			
			Aviso("ATENÇÃO","Código da Centro de Custo vazio!",{"OK"})
			lRet := .F.
			
		EndIf
		
		
		*--------------------------------------------------------------------------*
		*Verifica se moeda é válida
		*--------------------------------------------------------------------------*
		nMoeda := MV_PAR05
		
		If !EMPTY(nMoeda)
			
			If nMoeda <= 0 .OR. nMoeda > MOEDFIN()
				
				Aviso("ATENÇÃO","Moeda: "+STR(nMoeda)+" inválida!",{"OK"})
				lRet := .F.
				
			EndIf
			
		Else
			
			Aviso("ATENÇÃO","Moeda vazia!",{"OK"})
			lRet := .F.
			
		EndIf
		
		
		If cGetAno < cAnoIni .OR. cGetAno > cAnoFim
			Aviso("ATENÇÃO","O Ano de Referência e o Ano do período da Planilha Orçamentaria são diferentes. Favor selecionar outra Planilha Orçamentária.",{"OK"})
			lRet := .F.
		Else
			
			If lRet == .T.
				Processa( { || Importar() }, "Processando..." )
			EndIf
			
		Endif
		
	EndIf
	
EndIf

Return(lRet)

*---------------------------------------------------------------------------------------------*
Static Function Importar()
*---------------------------------------------------------------------------------------------*
* Descricao: Irá importar o arquibo CSV para as tabelas                                       *
*---------------------------------------------------------------------------------------------*
Local lImp    		:= .F.
Local cBuffer		:= ""
Local aCab 			:= {}
Local aInfo			:= {}
Local xPos			:= ""
Local aTmpDados		:= {}
Local lImp 			:= .F.
Local cTipo			:= ""
Local cQuery		:= ""
Local cContaOrc		:= ""
Local lRet			:= .T.
Local nMes			:= 0
Local nMesIni		:= 0
Local nMesFim		:= 0
Local lAddCO        := .F.
Local nID           := 0
Local ni := 0
local nc := 0
Private cArquiv 	:= MV_PAR06
Private aDados 		:= {}
Private nDados		:= 0
Private cID			:= "0001"
Private cCO_AK2 	:= ""
Private _nLinAtu 	:= 0
Private	_nTotal 	:= 0
Private _aERRO     := {}

If !FILE(cArquiv)
	Aviso("ATENÇÃO", "Arquivo: "+cArquiv+" não encontrado!",{"OK"})
	lRet := .F.
	Return(lRet)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Abre o Arquivo Texto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FT_FUSE(cArquiv)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Vai para o Inicio do Arquivo e Define o numero de Linhas para a Barra de Processamento.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FT_FGOTOP()

cBuffer  := FT_FREADLN()
_nTotal  := FT_FLASTREC()

ProcRegua(_nTotal)

Begin Transaction

aDados := {}
FT_FGOTOP()
While !FT_FEOF() //Percorre todo os itens do arquivo CSV.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Incrementa a Barra de Rolagem e vai para a Proxima Linha do Arquivo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_nLinAtu++
	lAddCO := .F.
	
	If _nLinAtu < nLinIni
		FT_FSKIP()
		Loop
	EndIf
	
	IncProc( "Importando Planilha. Linha " + AllTrim( Str( _nLinAtu ) ) + " de " + AllTrim( Str( _nTotal ) ) )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz a Leitura da Linha do Arquivo e atribui a Variavel cBuffer³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cBuffer := FT_FREADLN()
	//cBuffer := U_SemAcentos(cBuffer)
	cBuffer := RemoveAcento(cBuffer)
	aDados := {}
	
	//Se já passou por todos os registros da planilha "CSV" sai do While.
	If Empty(cBuffer)
		Exit
	Endif
	
	AADD(aDados,Separa(cBuffer,";",.T.))
	
	If EMPTY( AllTrim(aDados[1][nPosCCOrc]) )  // coluna codigo conta orçamentaria
		FT_FSKIP()
		Loop
	EndIf
	
	If UPPER("total") $ AllTrim(aDados[1][nPosCCOrc])
		Exit
	Endif
	
	*--------------------------------------------------------------------------*
	*Verifica se a conta orçamentária existe
	*--------------------------------------------------------------------------*
	cContaOrc := AllTrim(aDados[1][nPosCCOrc])
	DbSelectArea("AK5")
	DbSetOrder(1)
	If !DbSeek( XFilial( "AK5" ) + cContaOrc )
		cErro := "Conta Orçamentária não encontrada"
		If aScan(_aERRO, {|x| alltrim(x[1]) = cContaOrc .and. x[2] = cErro}) = 0
			aAdd( _aERRO, {cContaOrc, cErro, AllTrim( Str( _nLinAtu ) ) } )
		EndIf
		FT_FSKIP()
		Loop
	EndIf
	
	*--------------------------------------------------------------------------*
	*Verifica se a conta orçamentária está bloqueada
	*--------------------------------------------------------------------------*
	If AK5->AK5_MSBLQL == "1"
		
		cErro := "Conta Orçamentária bloqueada"
		If aScan(_aERRO, {|x| alltrim(x[1]) = cContaOrc .and. x[2] = cErro}) = 0
			aAdd( _aERRO, {cContaOrc, cErro, AllTrim( Str( _nLinAtu ) ) } )
		EndIf
		
		FT_FSKIP()
		Loop
		
	EndIf
	
	*------------------------------------------------------------------*
	*GRAVA o aDados[][] no AK3 e AK2                                   *
	*------------------------------------------------------------------*
	
	cNivelAtu := ""
	DbSelectArea("AK3")
	DbSetOrder(1)
	If !DbSeek(xFilial("AK3") + PadR(cOrcam, TamSX3("AK3_ORCAME")[1]) + PadR(cVersao, TamSX3("AK3_VERSAO")[1]) + PadR(cContaOrc, TamSX3("AK3_CO")[1]) )
		
		//IMPORTAR O AK3
		cNivelAtu := NivelPC(cOrcam, "0001", cContaOrc)
		
		If !Empty(cNivelAtu)
			
			//Verificar os niveis anteriores e incluir se nao estiverem inclusos
			If !EMPTY(AK5->AK5_COSUP)
				
				DbSelectArea("AK3")
				DbSetOrder(1)
				If !DbSeek(xFilial("AK3") + PadR(cOrcam, TamSX3("AK3_ORCAME")[1]) + PadR(cVersao, TamSX3("AK3_VERSAO")[1]) + PadR(AK5->AK5_COSUP, TamSX3("AK3_CO")[1]) )
					
					aCtaPlan := {}
					nNivAtu  := 2
					PcoCtaAddPlan(cContaOrc, AK5->AK5_COSUP, @nNivAtu)
					
					For nI := 1 To Len(aCtaPlan)
						
						nNivAtu := aCtaPlan[nI][2]
						
						DbSelectArea("AK5")
						DbSetOrder(1)
						DbSeek( XFilial( "AK5" ) + aCtaPlan[nI][1] )
						
						nNivAtu := STRZERO( nNivAtu,TAMSX3("AK3_NIVEL")[1] )
						//Executa RecLock na AK3 para inclusão das Contas
						IncluiAK3(aCtaPlan[nI][1],nNivAtu)
						
						lAddCO := .T.
						
					Next nI
					
					
				EndIf
				
			EndIf
			
			//Após inclusão das contas superiores recalcula o nível da conta analítica a ser importada da planiha
			If lAddCO == .T.
				
				DbSelectArea("AK5")
				DbSetOrder(1)
				DbSeek( XFilial( "AK5" ) + cContaOrc )
				
				cNivelAtu := NivelPC(cOrcam, "0001", cContaOrc)
				//cNivelAtu := SOMA1(nNivAtu)
			EndIf
			
			DbSelectArea("AK5")
			DbSetOrder(1)
			DbSeek( XFilial( "AK5" ) + cContaOrc )
			//Executa RecLock na AK3 para inclusão das Contas
			IncluiAK3(cContaOrc,cNivelAtu)
			
			
		Else
			cErro := "Nível não definido para a Conta Orçamentária"
			If aScan(_aERRO, {|x| alltrim(x[1]) = alltrim(cContaOrc) .and. x[2] = cErro}) = 0
				aAdd( _aERRO, {cContaOrc, cErro, AllTrim( Str( _nLinAtu ) ) } )
			EndIf
			
			FT_FSKIP()
			Loop
			
		EndIf
		
	Else
		/*
		cErro := "Conta Orçamentária já existente"
		If aScan(_aERRO, {|x| alltrim(x[1]) = cContaOrc .and. x[2] = cErro}) = 0
		aAdd( _aERRO, {cContaOrc, cErro, AllTrim( Str( _nLinAtu ) ) } )
		EndIf
		
		FT_FSKIP()
		Loop
		*/
	EndIf
	
	DbSelectArea("AK3")
	DbSetOrder(1)
	If DbSeek(xFilial("AK3") + PadR(cOrcam, TamSX3("AK3_ORCAME")[1]) + PadR(cVersao, TamSX3("AK3_VERSAO")[1]) + PadR(cContaOrc, TamSX3("AK3_CO")[1]) ) .and. AK5->AK5_TIPO == "2"		// Apenas as contas analíticas serão criadas no AK2
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Para Cada Mes no registro da Planilha Grava um Registro na AK2³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		//nMes := 0
		nMes    := VAL(SUBSTR(MV_PAR07,1,2))
		nMesIni := VAL(SUBSTR(MV_PAR07,1,2)) + nPosMesINI //soma devido a poscionamento dos campos de meses no layout
		nMesFim := VAL(SUBSTR(MV_PAR08,1,2)) + nPosMesINI //soma devido a poscionamento dos campos de meses no layout
		
		PcoIniLan('000252')
		
		For nC := nMesIni To nMesFim
			
			//nMes++
			
			If !Empty(aDados[1][nC]) .AND. ISDIGIT( ALLTRIM(aDados[1][nC]) )
				
				If VAL(aDados[1][nC]) > 0
					
					//dPeriodo := StoD( cGetAno + StrZero( nMes, 02 ) + "01" )
					dPeriodo := StoD( cGetAno + StrZero( nMes, 02 ) + "01" )
					dPeriodo := IIF(dPeriodo < AK1->AK1_INIPER, AK1->AK1_INIPER, dPeriodo)
					
					
					cQuery := "SELECT * "										+c_ent
					cQuery += "FROM "+RetSqlName("AK2")+" AK2 "					+c_ent
					cQuery += "WHERE AK2.AK2_FILIAL='" + xFilial("AK2") + "' "	+c_ent
					cQuery += "  AND AK2.AK2_ORCAME = '" + alltrim(cOrcam) + "' "		+c_ent
					cQuery += "  AND AK2.AK2_VERSAO = '" + alltrim(cVersao) + "' "		+c_ent
					cQuery += "  AND AK2.AK2_CO     = '" + alltrim(cContaOrc) + "' "		+c_ent
					cQuery += "  AND AK2.AK2_PERIOD = '" + DtoS(dPeriodo) + "' "+c_ent
					cQuery += "  AND AK2.AK2_CC     = '" + alltrim(cCCusto) + "' "		+c_ent
					//cQuery += "  AND AK2.AK2_CLASSE = '" + alltrim(cClaOrc) + "' "		+c_ent
					cQuery += "  AND AK2.D_E_L_E_T_ = ' ' "
					
					
					If select("TRB1AK2")>0
						dbSelectArea("TRB1AK2")
						dbCloseArea()
					EndIf
					
					TCQUERY cQuery New Alias "TRB1AK2"
					
					If !TRB1AK2->(eof())
						cErro := "Orçamento-Versão-Conta-Periodo("+DtoC(dPeriodo)+")-CCusto, já existente"
						If aScan(_aERRO, {|x| alltrim(x[1]) = alltrim(cOrcam +" - "+ cVersao +" - "+ cContaOrc +" - "+ DtoC(dPeriodo) +" - "+ cCCusto) .and. x[2] = cErro}) = 0
							aAdd( _aERRO, {cContaOrc, cErro, AllTrim( Str( _nLinAtu ) ) } )
						EndIf
					Else
						
						cQuery := "SELECT AK2.AK2_ID AS ID "										+c_ent
						cQuery += "FROM "+RetSqlName("AK2")+" AK2 "					+c_ent
						cQuery += "WHERE AK2.AK2_FILIAL='" + xFilial("AK2") + "' "	+c_ent
						cQuery += "  AND AK2.AK2_ORCAME = '" + alltrim(cOrcam) + "' "		+c_ent
						cQuery += "  AND AK2.AK2_VERSAO = '" + alltrim(cVersao) + "' "		+c_ent
						cQuery += "  AND AK2.AK2_CO     = '" + alltrim(cContaOrc) + "' "		+c_ent
						cQuery += "  AND AK2.AK2_CC     = '" + alltrim(cCCusto) + "' "		+c_ent
						cQuery += "  AND AK2.AK2_PERIOD <> '" + DtoS(dPeriodo) + "' "+c_ent
						//cQuery += "  AND AK2.AK2_CLASSE = '" + alltrim(cClaOrc) + "' "		+c_ent
						cQuery += "  AND AK2.D_E_L_E_T_ = ' ' "
						cQuery += "ORDER BY AK2_FILIAL,AK2_ORCAME,AK2_VERSAO,AK2_CO,AK2_PERIOD,AK2_ID "
						
						If select("TRB3AK2")>0
							dbSelectArea("TRB3AK2")
							dbCloseArea()
						EndIf
						
						TCQUERY cQuery New Alias "TRB3AK2"
						
						If TRB3AK2->(!eof())
							
							nID := TRB3AK2->ID
							
						Else
							
							cQuery := "SELECT MAX(AK2.AK2_ID) AS ID "							+c_ent
							cQuery += "FROM "+RetSqlName("AK2")+" AK2 "					+c_ent
							cQuery += "WHERE AK2.AK2_FILIAL='" + xFilial("AK2") + "' "	+c_ent
							cQuery += "  AND AK2.AK2_ORCAME = '" + alltrim(cOrcam) + "' "		+c_ent
							cQuery += "  AND AK2.AK2_VERSAO = '" + alltrim(cVersao) + "' "		+c_ent
							cQuery += "  AND AK2.AK2_CO     = '" + alltrim(cContaOrc) + "' "		+c_ent
							cQuery += "  AND AK2.D_E_L_E_T_ = ' ' "
							
							If select("TRB2AK2")>0
								dbSelectArea("TRB2AK2")
								dbCloseArea()
							EndIf
							
							TCQUERY cQuery New Alias "TRB2AK2"
							
							If !TRB2AK2->(eof()) .AND. !EMPTY(TRB2AK2->ID)
							
								nID := SOMA1(TRB2AK2->ID)
							Else
							    
								nID := StrZero(1, TamSX3("AK2_ID")[1])
							EndIf
							
							TRB2AK2->(DbCloseArea())
							
						EndIf
						
						TRB3AK2->(DbCloseArea())
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Grava as Informacoes da Planilha na Tabela AK2.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
						DbSelectArea( "AK2" )
						DbSetOrder(1)
						
						If !DbSeek(xFilial("AK2") + PadR(cOrcam, TamSX3("AK2_ORCAME")[1]) + PadR(cVersao, TamSX3("AK2_VERSAO")[1]) + PadR(cCCusto, TamSX3("AK2_CC")[1]) + PadR(cContaOrc, TamSX3("AK2_CO")[1]) + PadR(dtos(dPeriodo), TamSX3("AK2_PERIOD")[1]) + nID )
							
							RecLock( "AK2", .T. )
							AK2->AK2_FILIAL 	:= XFilial( "AK2" )
							AK2->AK2_ID 		:= nID
							AK2->AK2_ORCAME 	:= cOrcam
							AK2->AK2_VERSAO 	:= cVersao
							AK2->AK2_CO 		:= cContaOrc
							AK2->AK2_PERIOD 	:= dPeriodo
							AK2->AK2_CC 		:= cCCusto
							AK2->AK2_CLASSE 	:= cClaOrc
							AK2->AK2_DESCRI 	:= AK6->AK6_DESCRI
							AK2->AK2_VALOR 		:= Val( StrTran( StrTran( aDados[1][nC], ".", "" ), ",", "." ) )
							AK2->AK2_OPER 		:= cOperOrc
							AK2->AK2_MOEDA 		:= nMoeda
							AK2->AK2_DATAF 		:= IIF( LastDay(dPeriodo) > AK1->AK1_FIMPER, AK1->AK1_FIMPER, LastDay(dPeriodo) )  
							AK2->AK2_DATAI 		:= dPeriodo
							
							AK2->AK2_DESCRI		:= ALLTRIM(aDados[1][nPosDesc])   // coluna descrição da planilha
							AK2->( MsUnLock() )
							
							PcoDetLan("000252","01","PCOA100")
							
							
						EndIf
						
					Endif
					
					TRB1AK2->(DbCloseArea())
					
				EndIf
				
			Endif
			
			nMes++
			
		Next nC
		
		PcoFinLan('000252')
		
	Endif
	
	*------------------------------------------------------------------*
	
	FT_FSKIP()
Enddo

End Transaction

// Os Arquivos Importados, Sao Renomeados para a Extensão .IMP
// Renomeio os arquivos apos a importacao.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Fecha o Arquivo Texto e apaga o mesmo.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FT_FUSE()
c_dirimp := ""

If Len(_aERRO) > 0
	If Aviso("ATENÇÃO", "Foram encontrados Inconsistências na importação. Deseja emitir um relatório?", {"Sim", "Nao"}, 1) = 1
		PCOR001C() //Emite o relatório
		lRet := .F.
	Endif
Else
	MsgInfo("Importação Finalizada com Sucesso...")
	//	FRename(UPPER(cArquiv), STRTRAN(UPPER(cArquiv),".CSV",".IMP"))
Endif

Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PCOR001C  ºAutor  ³     º Data ³    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime o relatório de Inconsistências.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8 - BMA - PCO.                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function PCOR001C()
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de Inconsistências."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := "Inconsistências da Importação do PCO"
Local nLin         := 80

Local Cabec1       := "Informação               Inconsistência                                                          Linha"
//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//0        10        20        30         40        50        60        70        80        90        100       110       120
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "M"
Private nomeprog   := "PCOR001C" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "PCOR001C" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString := ""//"AK2"

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


//***********************************************************************************************
//***********************************************************************************************
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
//***********************************************************************************************
//***********************************************************************************************
Local cNaoEncon := ""
Local _Cabec    := "Parâmetros"
local i:= 0
local cField1:=  "X1_GRUPO"
Local cField2:=  "X1_ORDEM"
local cField3:=  "X1_PERGUNTA"
local cField4:=  "X1_GSC"
local cField5:=  "X1_DEF"
If MV_PAR09 == 1
	dbSelectArea("SX1")
	dbSeek(_cPerg)
	While !EOF() .AND. &(cField1) = _cPerg
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If nLin > 65
			Cabec(Titulo,_Cabec,"",NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif	
		
		cVar := "MV_PAR"+StrZero(Val((&(cField2),2,0)))
		//nLin += 2
		@ nLin,00 PSAY RptPerg+" "+ &(cField2) + " : "+ ALLTRIM(&(cField3))
		IF &(cField4) == "C"
			xStr:=StrZero(&(cVar),2)
		Endif
		@ nLin,Pcol()+3 PSAY IIF(&(cField4)!='C',&(cVar),IIF(&(cVar)>0,&(cField5)&xStr,""))
		
		nLin++
		
		dbSkip()
		
	EndDO
	
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 9
		
EndIf


For i:=1 To Len(_aERRO)
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 65
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	@ nLin,000 Psay ALLTRIM(_aERRO[i][1])
	@ nLin,025 Psay ALLTRIM(_aERRO[i][2])
	@ nLin,097 Psay ALLTRIM(_aERRO[i][3])
	
	nLin++
Next i

SET DEVICE TO SCREEN

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ CtrlArea º Autor ³     º Data ³ //  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Static Function auxiliar no GetArea e ResArea retornando   º±±
±±º          ³ o ponteiro nos Aliases descritos na chamada da Funcao.     º±±
±±º          ³ Exemplo:                                                   º±±
±±º          ³ Local _aArea  := {} // Array que contera o GetArea         º±±
±±º          ³ Local _aAlias := {} // Array que contera o                 º±±
±±º          ³                     // Alias(), IndexOrd(), Recno()        º±±
±±º          ³                                                            º±±
±±º          ³ // Chama a Funcao como GetArea                             º±±
±±º          ³ P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4"})         º±±
±±º          ³                                                            º±±
±±º          ³ // Chama a Funcao como RestArea                            º±±
±±º          ³ P_CtrlArea(2,_aArea,_aAlias)                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ nTipo   = 1=GetArea / 2=RestArea                           º±±
±±º          ³ _aArea  = Array passado por referencia que contera GetArea º±±
±±º          ³ _aAlias = Array passado por referencia que contera         º±±
±±º          ³           {Alias(), IndexOrd(), Recno()}                   º±±
±±º          ³ _aArqs  = Array com Aliases que se deseja Salvar o GetArea º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAplicacao ³ Generica.                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CtrlArea(_nTipo,_aArea,_aAlias,_aArqs)
Local _nN
// Tipo 1 = GetArea()
If _nTipo == 1
	_aArea   := GetArea()
	For _nN  := 1 To Len(_aArqs)
		DbSelectArea(_aArqs[_nN])
		AAdd(_aAlias,{ Alias(), IndexOrd(), Recno()})
	Next
	// Tipo 2 = RestArea()
Else
	For _nN := 1 To Len(_aAlias)
		DbSelectArea(_aAlias[_nN,1])
		DbSetOrder(_aAlias[_nN,2])
		DbGoto(_aAlias[_nN,3])
	Next
	RestArea(_aArea)
Endif
Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³ NivelPCO  ³ Autor ³        ³ Data ³//³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Retorna o nivel para a conta orçamentária                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno    ³ cRet := Nivel                                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function NivelPC(cPOrcam, cPVersao, cPConta)

Local cRet   := StrZero(1,TamSX3("AK3_NIVEL")[1])
Local cQuery := ""

//cQuery := "SELECT NVL(MAX(AK3_NIVEL), '0') AS NIVEL " +c_ent
cQuery := "SELECT ISNULL(MAX(AK3_NIVEL), '0') AS NIVEL " +c_ent
cQuery += "FROM "+RetSqlName("AK3")+" AK3 " +c_ent
cQuery += "WHERE AK3.AK3_FILIAL = '" + xFilial("AK3") + "' " +c_ent
cQuery += "  AND AK3.AK3_ORCAME = '" + alltrim(cPOrcam) + "' " +c_ent
cQuery += "  AND AK3.AK3_VERSAO = '" + alltrim(cPVersao) + "' " +c_ent
cQuery += "  AND AK3.D_E_L_E_T_ = ' ' " +c_ent

If select("TRB1AK3")>0
	dbSelectArea("TRB1AK3")
	dbCloseArea()
EndIf

TCQUERY cQuery New Alias "TRB1AK3"

If TRB1AK3->(eof())
	aAdd( _aERRO, {cPOrcam + " / " + cPVersao, "Orçamento / Versão com estrutura inconsistente"} )
ElseIf VAL(TRB1AK3->NIVEL) = 1
	cRet := StrZero(VAL(TRB1AK3->NIVEL)+1,TamSX3("AK3_NIVEL")[1])
Else
	cQuery3 := "SELECT AK3_NIVEL AS NIVEL "	+c_ent
	cQuery3 += "FROM "+RetSqlName("AK3")+" AK3 " +c_ent
	cQuery3 += "WHERE AK3.AK3_FILIAL='" + xFilial("AK3") + "' " +c_ent
	cQuery3 += "  AND AK3.AK3_ORCAME = '" + alltrim(cPOrcam) + "' " +c_ent
	cQuery3 += "  AND AK3.D_E_L_E_T_ = ' ' " +c_ent
	cQuery3 += "  AND AK3.AK3_CO = '" + AK5->AK5_COSUP + "' " +c_ent
	
	If select("TRB2AK3")>0
		dbSelectArea("TRB2AK3")
		dbCloseArea()
	EndIf
	
	TCQUERY cQuery3 New Alias "TRB2AK3"
	
	If TRB2AK3->(eof())
		cRet := StrZero(VAL(TRB1AK3->NIVEL)+1,TamSX3("AK3_NIVEL")[1])
	Else
		cRet := StrZero(VAL(TRB2AK3->NIVEL)+1,TamSX3("AK3_NIVEL")[1])
	EndIf
	
	TRB2AK3->(DbCloseArea())
EndIf


TRB1AK3->(DbCloseArea())

Return(cRet)

*************************************************************************************************************
Static Function PTNA050A()

Local cQuery1  := ""

cQuery1 := "SELECT AK1_CODIGO,AK1_VERSAO,AK1_VERREV, AK1_DESCRI, AK1_INIPER "+c_ent
cQuery1 += "FROM "+RetSqlName("AK1")+" AK1 "+c_ent
cQuery1 += "WHERE AK1.AK1_FILIAL='" + xFilial("AK1") + "' AND "+c_ent
cQuery1 += "( '" + cGetAno + "' >= SUBSTRING(AK1.AK1_INIPER,1,4) AND "+c_ent
cQuery1 += "'" + cGetAno + "' <= SUBSTRING(AK1.AK1_FIMPER,1,4) ) AND "+c_ent
cQuery1 += "AK1.D_E_L_E_T_ = ' ' "+c_ent
cQuery1 += "ORDER BY AK1_FILIAL,AK1_CODIGO,AK1_VERSAO"

If select("TRB1")>0
	dbSelectArea("TRB1")
	dbCloseArea()
	dbSelectArea("AK1")
EndIf

TCQUERY cQuery1 New Alias "TRB1"

DBSelectArea("TRB1")

If ("TRB1")->(!EOF())
	
	a_AK1 := {}
	
	While ("TRB1")->(!EOF())
		
		aAdd( a_AK1, { TRB1->AK1_CODIGO, TRB1->AK1_VERSAO, TRB1->AK1_VERREV, TRB1->AK1_DESCRI, TRB1->AK1_INIPER })
		lExit := .F.
		
		DbSelectArea("TRB1")
		("TRB1")->(Dbskip())
	Enddo
	
Else
	
	lExit := .T.
	a_AK1 := {}
	aAdd( a_AK1, { "", "", "", "", "" })
	
	oLbx:SetArray( a_AK1 )
	oLbx:bLine := {|| {	a_AK1[oLbx:nAt,1],;
	a_AK1[oLbx:nAt,2],;
	a_AK1[oLbx:nAt,3],;
	a_AK1[oLbx:nAt,4],;
	a_AK1[oLbx:nAt,5]}}
	
	oLbx:Refresh()
	
EndIf

dbSelectArea("TRB1")
("TRB1")->(dbCloseArea())

If Len(a_AK1) > 0  .AND. lExit == .F.
	
	oLbx:SetArray( a_AK1 )
	oLbx:bLine := {|| {	a_AK1[oLbx:nAt,1],;
	a_AK1[oLbx:nAt,2],;
	a_AK1[oLbx:nAt,3],;
	a_AK1[oLbx:nAt,4],;
	a_AK1[oLbx:nAt,5]}}
	
	oLbx:Refresh()
	
Else
	
	Aviso("ATENÇÃO","Não existe Registro na Tabela de Planilha Orçamentária(AK1) para o ano selecionado! Favor Incluir.",{"OK"})
	
EndIf

Return

*************************************************************************************************************
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RemoveAcento ºAutor  ³       º Data ³  //   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Remove acentos/caracteres especiais º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RemoveAcento(cString)
Local cChar  := ""
Local nX     := 0
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
Local cTio   := "ãõ"
Local cCecid := "çÇ"

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("ao",nY,1))
		EndIf
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next
For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If Asc(cChar) < 32 .Or. Asc(cChar) > 123
		cString:=StrTran(cString,cChar,"")
	Endif
Next nX

Return cString
*************************************************************************************************************
Static Function PcoCtaAddPlan(cCtaOrc, cCtaSup, nNivAtu)
Local aAreaAK5 := AK5->(GetArea())
Local cCtaTree := ""
Local lAdItem := .F.
dbSelectArea("AK5")
dbSetOrder(1)
MsSeek(xFilial()+cCtaSup)

While !Eof() .And. AK5->AK5_FILIAL+AK5->AK5_CODIGO==xFilial("AK5")+cCtaSup
	
	lAdItem := .T.
	cCtaTree := AK5->AK5_CODIGO
	
	If !Empty(AK5->AK5_COSUP)
		PcoCtaAddPlan(AK5->AK5_CODIGO, AK5->AK5_COSUP, @nNivAtu)
		
	Else
		
		Exit
	EndIf
	
	dbSelectArea("AK5")
	dbSkip()
End

If lAdItem
	aAdd(aCtaPlan, {cCtaTree, nNivAtu})
	nNivAtu++
EndIf

RestArea(aAreaAK5)

Return NIL

*************************************************************************************************************
Static Function	IncluiAK3(_ContaOrc,_NivelAtu)

Local _aAreaAK3 := ("AK3")->(GetArea())

DbSelectArea("AK3")
DbSetOrder(1)
If !DbSeek(xFilial("AK3") + PadR(cOrcam, TamSX3("AK3_ORCAME")[1]) + PadR(cVersao, TamSX3("AK3_VERSAO")[1]) + PadR(_ContaOrc, TamSX3("AK3_CO")[1]) )
	
	RecLock("AK3",.T.)
	
	AK3->AK3_FILIAL := XFilial( "AK3" )
	AK3->AK3_ORCAME	:= cOrcam
	AK3->AK3_VERSAO	:= cVersao
	AK3->AK3_CO		:= _ContaOrc
	AK3->AK3_PAI	:= IIF( AllTrim( AK5->AK5_COSUP ) == "", cOrcam, AK5->AK5_COSUP )
	AK3->AK3_TIPO	:= AK5->AK5_TIPO
	AK3->AK3_DESCRI	:= AK5->AK5_DESCRI
	AK3->AK3_NIVEL	:= _NivelAtu
	
	AK3->( MsUnLOCK() )
	
EndIf

RestArea(_aAreaAK3)

Return
*************************************************************************************************************

Static Function ValidPerg()

Local aHelpPor := {}
Local aHelpEsp := {}
Local aHelpEng := {}

PutSx1(_cPerg,"01","Orçamento ?"         ,"C.Custo De  ?"       ,"C.Custo De  ?"       ,"mv_ch1","C",TAMSX3("AK1_CODIGO")[1],0,0,"G","","AK1","","","mv_par01")
PutSx1(_cPerg,"02","Clas.Orçamentária ?" ,"Clas.Orçamentária ?" ,"Clas.Orçamentária ?" ,"mv_ch2","C",TAMSX3("AK6_CODIGO")[1],0,0,"G","","AK6","","","mv_par02")
PutSx1(_cPerg,"03","Operação ?"          ,"Operação ?"          ,"Operação ?"          ,"mv_ch3","C",TAMSX3("AKF_CODIGO")[1],0,0,"G" ,"","AKF","","","mv_par03")
PutSx1(_cPerg,"04","C.Custo?"            ,"C.Custo?"            ,"C.Custo?"            ,"mv_ch4","C",TAMSX3("CTT_CUSTO")[1],0,0,"G","","CTT","","","mv_par04")
PutSx1(_cPerg,"05","Moeda ?"             ,"Moeda ?"             ,"Moeda ?"             ,"mv_ch5","N",02,0,0,"G","","","","","mv_par05")
PutSx1(_cPerg,"06","Diretório?"          ,"Diretório?"          ,"Diretório?"          ,"mv_ch6","C",70,0,0,"G","U_PTNA050A","","","","mv_par06")
PutSx1(_cPerg,"07","MesAno Ini (MMAAAA)?","MesAno Ini (MMAAAA)?","MesAno Ini (MMAAAA)?","mv_ch7","C",06,0,0,"G","","","","","mv_par07")
PutSx1(_cPerg,"08","MesAno Fim (MMAAAA)?","MesAno Fim (MMAAAA)?","MesAno Fim (MMAAAA)?","mv_ch8","C",06,0,0,"G","","","","","mv_par08")
PutSx1(_cPerg,"09","Impr.Parâmetros?"    ,"Impr.Parâmetros?"    ,"Impr.Parâmetros?"    ,"mv_ch9","N",01,0,1,"C","","","","","mv_par09","Sim","Sim","Sim","","Não","Não","Não","","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)

Return


User Function PTNA050A()

Local MvRet:= Alltrim(ReadVar())
Local cRet := cGetFile("Arquivo csv (*.csv) | *.csv",OemToAnsi("Selecione Diretorio"),,"",.F.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.F.)

&MvRet := cRet

Return(.T.)
