#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.Ch"
#INCLUDE "FONT.CH"
#DEFINE   c_ent      CHR(13)+CHR(10)

#DEFINE  nPosCCOrc   1  // coluna codigo conta or�amentaria
#DEFINE  nPosMesINI  2  // numero de colunas para somar no parametro de m�s inicial (Exemplo: PARAMETRO INFORMADO � 012019. SER� SOMADO MAIS ESTAS POSICOES NO M�S PARA GERAR A COLUNA)
#DEFINE  nPosDesc    2  // coluna da descri��o da conta or�amentaria na planilha       
#DEFINE  nLinIni    10  // linha inicial de leitura da planilha


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PTNA050   �Autor  �Yttalo martins    � Data � 12/01/2015    ���
�������������������������������������������������������������������������͹��
���Desc.     � Gerar a Planilha Or�amentaria (AK1) para que o usuario     ���
���          � selecione a planilha a ser importada.                      ���
���          � Ser�o importadas as tabelas AK2 e AK3.                     ���
�������������������������������������������������������������������������͹��
���Uso       � PCO.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
Private lExit       := .T. //vari�vel utilizada para validar exist�ncia de planilha para o ano selecionado e permitir a continuidade na rotina

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

DEFINE MSDIALOG oDlg TITLE "IMPORTA��O CONTA OR�AMENT�RIA - PCO" From aSizeAut[7],00 To aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL

// Defina aqui a chamada dos Aliases para o GetArea
CtrlArea(1, @_aArea, @_aAlias, {"AK1","AK3","AK5"}) // GetArea

@ aPosObj[1][1],aPosObj[1][2] TO aPosObj[1][3]+20,aPosObj[1][4] LABEL "Informe o ano: " PIXEL OF oDlg

@ aPosObj[1][1]+12,aPosObj[1][2]+005 Say "Ano de Refer�ncia:" SIZE 100,008 FONT oFont COLOR CLR_HBLUE OF oDlg PIXEL
@ aPosObj[1][1]+12,aPosObj[1][2]+065 MsGet oGetAno Var cGetAno Size 020,005 COLOR CLR_BLACK Picture "@!" Valid (PTNA050A()) PIXEL OF oDlg

@ aPosObj[2][1]+20, aPosObj[2][2] TO aPosObj[2][3]+20, aPosObj[2][4] LABEL "Planilha(s) Or�ament�ria(s): " PIXEL OF oDlg

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
    //Chama a fun��o que adiciona ao array via @, conforme o campo atual, e o tipo � 4 que ser� usado em um MsNewGetDados
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PTNPCO2  �Autor  �                    � Data �     ���
�������������������������������������������������������������������������͹��
���Desc.     � Abre o diret�rio para o usu�rio buscar o arquivo a ser     ���
���          � importado.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � MP8 - MPE - PCO.                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
		Aviso("ATEN��O","N�o existe Registro na Tabela de Planilha Or�ament�ria(AK1) para o ano selecionado! Favor Incluir.",{"OK"})
		
	EndIf
	
Else
	
	lRet := .F.
	Aviso("ATEN��O","N�o existe Registro na Tabela de Planilha Or�ament�ria(AK1) para o ano selecionado! Favor Incluir.",{"OK"})
	
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
			Aviso("ATEN��O","MesAno de inicio de fim precisam devem possuir o seguinte formato: MMAAAA",{"OK"})
			lRet := .F.
			return(lRet)
		EndIf
		
		If SUBSTR(MV_PAR07,3,4) <> SUBSTR(MV_PAR08,3,4)
			Aviso("ATEN��O","Ano de inicio e fim precisam ser iguais.",{"OK"})
			lRet := .F.
			return(lRet)
		EndIf
		
		If SUBSTR(MV_PAR07,3,4) <> cGetAno .OR. SUBSTR(MV_PAR08,3,4) <> cGetAno
			Aviso("ATEN��O","Ano de inicio/fim diverge do Ano de referencia",{"OK"})
			lRet := .F.
			return(lRet)
		EndIf
		
		If VAL(SUBSTR(MV_PAR07,1,2)) > VAL(SUBSTR(MV_PAR08,1,2))
			Aviso("ATEN��O","Mes de inicio precisa ser menor que Mes fim.",{"OK"})
			lRet := .F.
			return(lRet)
		EndIf
		
		If (VAL(SUBSTR(MV_PAR07,1,2)) < 1 .OR. VAL(SUBSTR(MV_PAR07,1,2)) > 12) .OR.;
			(VAL(SUBSTR(MV_PAR08,1,2)) < 1 .OR. VAL(SUBSTR(MV_PAR08,1,2)) > 12)
			
			Aviso("ATEN��O","Mes de inicio de fim precisam estar 01 e 12",{"OK"})
			lRet := .F.
			return(lRet)
		EndIf
		
		*--------------------------------------------------------------------------*
		*Verifica se a planilha or�ament�ria existe
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
					Aviso("ATEN��O","MesAno informados precisam estar entre per�odo de in�cio e fim da planilha",{"OK"})
					lRet := .F.				
				EndIf
				
				nData    := VAL( SUBSTR(MV_PAR08,3,4) + SUBSTR(MV_PAR08,1,2) )
				
				If nData < nDataMin .OR. nData > nDataMax
					Aviso("ATEN��O","MesAno informados precisam estar entre per�odo de in�cio e fim da planilha",{"OK"})
					lRet := .F.				
				EndIf				
				
			Else
				
				Aviso("ATEN��O","N�o existe o Registro: "+MV_PAR01+" na Tabela de Planilha Or�ament�ria (AK1).",{"OK"})
				lRet := .F.
				
			EndIf
			
		Else
			
			Aviso("ATEN��O","C�digo da Planilha Or�ament�ria (AK1) vazio!",{"OK"})
			lRet := .F.
			
		EndIf
		
		*--------------------------------------------------------------------------*
		*Verifica se a classe or�ament�ria existe
		*--------------------------------------------------------------------------*
		cClaOrc := MV_PAR02
		
		If !EMPTY(cClaOrc)
			
			DbSelectArea("AK6")
			DbSetOrder(1)
			If !DbSeek( XFilial( "AK6" ) + alltrim(cClaOrc) )
				
				Aviso("ATEN��O","Classe Or�ament�ria: "+cClaOrc+" n�o encontrada!",{"OK"})
				lRet := .F.
				
			EndIf
			
		Else
			
			Aviso("ATEN��O","C�digo da Classe Or�ament�ria vazio!",{"OK"})
			lRet := .F.
			
		EndIf
		
		*--------------------------------------------------------------------------*
		*Verifica se a opera��o or�ament�ria existe
		*--------------------------------------------------------------------------*
		cOperOrc := MV_PAR03
		
		If !EMPTY(cOperOrc)
			
			DbSelectArea("AKF")
			DbSetOrder(1)
			If !DbSeek( XFilial( "AKF" ) + alltrim(cOperOrc) )
				
				Aviso("ATEN��O","Opera��o Or�ament�ria: "+cOperOrc+" n�o encontrada!",{"OK"})
				lRet := .F.
				
			EndIf
			
		Else
			
			Aviso("ATEN��O","C�digo da Opera��o Or�ament�ria vazio!",{"OK"})
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
				
				Aviso("ATEN��O","Classe Or�ament�ria: "+cCCusto+" n�o encontrada!",{"OK"})
				lRet := .F.
				
			EndIf
			
		Else
			
			Aviso("ATEN��O","C�digo da Centro de Custo vazio!",{"OK"})
			lRet := .F.
			
		EndIf
		
		
		*--------------------------------------------------------------------------*
		*Verifica se moeda � v�lida
		*--------------------------------------------------------------------------*
		nMoeda := MV_PAR05
		
		If !EMPTY(nMoeda)
			
			If nMoeda <= 0 .OR. nMoeda > MOEDFIN()
				
				Aviso("ATEN��O","Moeda: "+STR(nMoeda)+" inv�lida!",{"OK"})
				lRet := .F.
				
			EndIf
			
		Else
			
			Aviso("ATEN��O","Moeda vazia!",{"OK"})
			lRet := .F.
			
		EndIf
		
		
		If cGetAno < cAnoIni .OR. cGetAno > cAnoFim
			Aviso("ATEN��O","O Ano de Refer�ncia e o Ano do per�odo da Planilha Or�amentaria s�o diferentes. Favor selecionar outra Planilha Or�ament�ria.",{"OK"})
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
* Descricao: Ir� importar o arquibo CSV para as tabelas                                       *
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
	Aviso("ATEN��O", "Arquivo: "+cArquiv+" n�o encontrado!",{"OK"})
	lRet := .F.
	Return(lRet)
EndIf

//��������������������Ŀ
//�Abre o Arquivo Texto�
//����������������������
FT_FUSE(cArquiv)
//���������������������������������������������������������������������������������������Ŀ
//�Vai para o Inicio do Arquivo e Define o numero de Linhas para a Barra de Processamento.�
//�����������������������������������������������������������������������������������������
FT_FGOTOP()

cBuffer  := FT_FREADLN()
_nTotal  := FT_FLASTREC()

ProcRegua(_nTotal)

Begin Transaction

aDados := {}
FT_FGOTOP()
While !FT_FEOF() //Percorre todo os itens do arquivo CSV.
	
	//�������������������������������������������������������������������Ŀ
	//�Incrementa a Barra de Rolagem e vai para a Proxima Linha do Arquivo�
	//���������������������������������������������������������������������
	_nLinAtu++
	lAddCO := .F.
	
	If _nLinAtu < nLinIni
		FT_FSKIP()
		Loop
	EndIf
	
	IncProc( "Importando Planilha. Linha " + AllTrim( Str( _nLinAtu ) ) + " de " + AllTrim( Str( _nTotal ) ) )
	
	//��������������������������������������������������������������Ŀ
	//�Faz a Leitura da Linha do Arquivo e atribui a Variavel cBuffer�
	//����������������������������������������������������������������
	cBuffer := FT_FREADLN()
	//cBuffer := U_SemAcentos(cBuffer)
	cBuffer := RemoveAcento(cBuffer)
	aDados := {}
	
	//Se j� passou por todos os registros da planilha "CSV" sai do While.
	If Empty(cBuffer)
		Exit
	Endif
	
	AADD(aDados,Separa(cBuffer,";",.T.))
	
	If EMPTY( AllTrim(aDados[1][nPosCCOrc]) )  // coluna codigo conta or�amentaria
		FT_FSKIP()
		Loop
	EndIf
	
	If UPPER("total") $ AllTrim(aDados[1][nPosCCOrc])
		Exit
	Endif
	
	*--------------------------------------------------------------------------*
	*Verifica se a conta or�ament�ria existe
	*--------------------------------------------------------------------------*
	cContaOrc := AllTrim(aDados[1][nPosCCOrc])
	DbSelectArea("AK5")
	DbSetOrder(1)
	If !DbSeek( XFilial( "AK5" ) + cContaOrc )
		cErro := "Conta Or�ament�ria n�o encontrada"
		If aScan(_aERRO, {|x| alltrim(x[1]) = cContaOrc .and. x[2] = cErro}) = 0
			aAdd( _aERRO, {cContaOrc, cErro, AllTrim( Str( _nLinAtu ) ) } )
		EndIf
		FT_FSKIP()
		Loop
	EndIf
	
	*--------------------------------------------------------------------------*
	*Verifica se a conta or�ament�ria est� bloqueada
	*--------------------------------------------------------------------------*
	If AK5->AK5_MSBLQL == "1"
		
		cErro := "Conta Or�ament�ria bloqueada"
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
						//Executa RecLock na AK3 para inclus�o das Contas
						IncluiAK3(aCtaPlan[nI][1],nNivAtu)
						
						lAddCO := .T.
						
					Next nI
					
					
				EndIf
				
			EndIf
			
			//Ap�s inclus�o das contas superiores recalcula o n�vel da conta anal�tica a ser importada da planiha
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
			//Executa RecLock na AK3 para inclus�o das Contas
			IncluiAK3(cContaOrc,cNivelAtu)
			
			
		Else
			cErro := "N�vel n�o definido para a Conta Or�ament�ria"
			If aScan(_aERRO, {|x| alltrim(x[1]) = alltrim(cContaOrc) .and. x[2] = cErro}) = 0
				aAdd( _aERRO, {cContaOrc, cErro, AllTrim( Str( _nLinAtu ) ) } )
			EndIf
			
			FT_FSKIP()
			Loop
			
		EndIf
		
	Else
		/*
		cErro := "Conta Or�ament�ria j� existente"
		If aScan(_aERRO, {|x| alltrim(x[1]) = cContaOrc .and. x[2] = cErro}) = 0
		aAdd( _aERRO, {cContaOrc, cErro, AllTrim( Str( _nLinAtu ) ) } )
		EndIf
		
		FT_FSKIP()
		Loop
		*/
	EndIf
	
	DbSelectArea("AK3")
	DbSetOrder(1)
	If DbSeek(xFilial("AK3") + PadR(cOrcam, TamSX3("AK3_ORCAME")[1]) + PadR(cVersao, TamSX3("AK3_VERSAO")[1]) + PadR(cContaOrc, TamSX3("AK3_CO")[1]) ) .and. AK5->AK5_TIPO == "2"		// Apenas as contas anal�ticas ser�o criadas no AK2
		
		//��������������������������������������������������������������Ŀ
		//�Para Cada Mes no registro da Planilha Grava um Registro na AK2�
		//����������������������������������������������������������������
		
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
						cErro := "Or�amento-Vers�o-Conta-Periodo("+DtoC(dPeriodo)+")-CCusto, j� existente"
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
						//�����������������������������������������������Ŀ
						//�Grava as Informacoes da Planilha na Tabela AK2.�
						//�������������������������������������������������
						
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
							
							AK2->AK2_DESCRI		:= ALLTRIM(aDados[1][nPosDesc])   // coluna descri��o da planilha
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

// Os Arquivos Importados, Sao Renomeados para a Extens�o .IMP
// Renomeio os arquivos apos a importacao.
//��������������������������������������Ŀ
//�Fecha o Arquivo Texto e apaga o mesmo.�
//����������������������������������������
FT_FUSE()
c_dirimp := ""

If Len(_aERRO) > 0
	If Aviso("ATEN��O", "Foram encontrados Inconsist�ncias na importa��o. Deseja emitir um relat�rio?", {"Sim", "Nao"}, 1) = 1
		PCOR001C() //Emite o relat�rio
		lRet := .F.
	Endif
Else
	MsgInfo("Importa��o Finalizada com Sucesso...")
	//	FRename(UPPER(cArquiv), STRTRAN(UPPER(cArquiv),".CSV",".IMP"))
Endif

Return(lRet)



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PCOR001C  �Autor  �     � Data �    ���
�������������������������������������������������������������������������͹��
���Desc.     � Imprime o relat�rio de Inconsist�ncias.                    ���
�������������������������������������������������������������������������͹��
���Uso       � MP8 - BMA - PCO.                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function PCOR001C()
Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de Inconsist�ncias."
Local cDesc3       := ""
Local cPict        := ""
Local titulo       := "Inconsist�ncias da Importa��o do PCO"
Local nLin         := 80

Local Cabec1       := "Informa��o               Inconsist�ncia                                                          Linha"
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
Local _Cabec    := "Par�metros"
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

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()   � Autores � Norbert/Ernani/Mansano � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolucao horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function C(nTam)
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//���������������������������Ŀ
//�Tratamento para tema "Flat"�
//�����������������������������
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
Return Int(nTam)

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CtrlArea � Autor �     � Data � //  ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������͹��
���Descricao � Static Function auxiliar no GetArea e ResArea retornando   ���
���          � o ponteiro nos Aliases descritos na chamada da Funcao.     ���
���          � Exemplo:                                                   ���
���          � Local _aArea  := {} // Array que contera o GetArea         ���
���          � Local _aAlias := {} // Array que contera o                 ���
���          �                     // Alias(), IndexOrd(), Recno()        ���
���          �                                                            ���
���          � // Chama a Funcao como GetArea                             ���
���          � P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4"})         ���
���          �                                                            ���
���          � // Chama a Funcao como RestArea                            ���
���          � P_CtrlArea(2,_aArea,_aAlias)                               ���
�������������������������������������������������������������������������͹��
���Parametros� nTipo   = 1=GetArea / 2=RestArea                           ���
���          � _aArea  = Array passado por referencia que contera GetArea ���
���          � _aAlias = Array passado por referencia que contera         ���
���          �           {Alias(), IndexOrd(), Recno()}                   ���
���          � _aArqs  = Array com Aliases que se deseja Salvar o GetArea ���
�������������������������������������������������������������������������͹��
���Aplicacao � Generica.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
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


/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   � NivelPCO  � Autor �        � Data �//���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Retorna o nivel para a conta or�ament�ria                    ���
����������������������������������������������������������������������������Ĵ��
���Retorno    � cRet := Nivel                                                ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
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
	aAdd( _aERRO, {cPOrcam + " / " + cPVersao, "Or�amento / Vers�o com estrutura inconsistente"} )
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
	
	Aviso("ATEN��O","N�o existe Registro na Tabela de Planilha Or�ament�ria(AK1) para o ano selecionado! Favor Incluir.",{"OK"})
	
EndIf

Return

*************************************************************************************************************
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RemoveAcento �Autor  �       � Data �  //   ���
�������������������������������������������������������������������������͹��
���Desc.     �Remove acentos/caracteres especiais ���
�������������������������������������������������������������������������͹��
���Uso       �                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RemoveAcento(cString)
Local cChar  := ""
Local nX     := 0
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "�����"+"�����"
Local cCircu := "�����"+"�����"
Local cTrema := "�����"+"�����"
Local cCrase := "�����"+"�����"
Local cTio   := "��"
Local cCecid := "��"

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

PutSx1(_cPerg,"01","Or�amento ?"         ,"C.Custo De  ?"       ,"C.Custo De  ?"       ,"mv_ch1","C",TAMSX3("AK1_CODIGO")[1],0,0,"G","","AK1","","","mv_par01")
PutSx1(_cPerg,"02","Clas.Or�ament�ria ?" ,"Clas.Or�ament�ria ?" ,"Clas.Or�ament�ria ?" ,"mv_ch2","C",TAMSX3("AK6_CODIGO")[1],0,0,"G","","AK6","","","mv_par02")
PutSx1(_cPerg,"03","Opera��o ?"          ,"Opera��o ?"          ,"Opera��o ?"          ,"mv_ch3","C",TAMSX3("AKF_CODIGO")[1],0,0,"G" ,"","AKF","","","mv_par03")
PutSx1(_cPerg,"04","C.Custo?"            ,"C.Custo?"            ,"C.Custo?"            ,"mv_ch4","C",TAMSX3("CTT_CUSTO")[1],0,0,"G","","CTT","","","mv_par04")
PutSx1(_cPerg,"05","Moeda ?"             ,"Moeda ?"             ,"Moeda ?"             ,"mv_ch5","N",02,0,0,"G","","","","","mv_par05")
PutSx1(_cPerg,"06","Diret�rio?"          ,"Diret�rio?"          ,"Diret�rio?"          ,"mv_ch6","C",70,0,0,"G","U_PTNA050A","","","","mv_par06")
PutSx1(_cPerg,"07","MesAno Ini (MMAAAA)?","MesAno Ini (MMAAAA)?","MesAno Ini (MMAAAA)?","mv_ch7","C",06,0,0,"G","","","","","mv_par07")
PutSx1(_cPerg,"08","MesAno Fim (MMAAAA)?","MesAno Fim (MMAAAA)?","MesAno Fim (MMAAAA)?","mv_ch8","C",06,0,0,"G","","","","","mv_par08")
PutSx1(_cPerg,"09","Impr.Par�metros?"    ,"Impr.Par�metros?"    ,"Impr.Par�metros?"    ,"mv_ch9","N",01,0,1,"C","","","","","mv_par09","Sim","Sim","Sim","","N�o","N�o","N�o","","","","","","","","","",aHelpPor,aHelpEng,aHelpEsp)

Return


User Function PTNA050A()

Local MvRet:= Alltrim(ReadVar())
Local cRet := cGetFile("Arquivo csv (*.csv) | *.csv",OemToAnsi("Selecione Diretorio"),,"",.F.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.F.)

&MvRet := cRet

Return(.T.)
