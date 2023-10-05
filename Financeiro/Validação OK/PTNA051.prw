#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.Ch"
#INCLUDE "FONT.CH"
#DEFINE   c_ent      CHR(13)+CHR(10)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PTNA051   �Autor  � Leonardo Freire  � Data � 18/03/2015    ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotiana exclui o valor or�ado por centro de custo e periodo���
���          �  por planilha or�amentaria                                 ���
���          � Ser�o excluios os registros da AK2                         ���
�������������������������������������������������������������������������͹��
���Uso       � PCO.                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PTNA051()

// Variaveis da Funcao de Controle e GertArea/RestArea
Local _aArea   		:= {}
Local _aAlias  		:= {}
Local nUsado		:= 0
Local cCabAK1		:= ""
Local nOpca			:= 0
Local x := 0

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

Private cGetAno	 := Space(4)
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

DEFINE MSDIALOG oDlg TITLE "EXCLUS�O CONTA OR�AMENT�RIA POR C. CUSTO E PERIODO - PCO" From aSizeAut[7],00 To aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL

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
While ( !Eof() .And. cArqui == "AK1" )
	If ( cNivel >= cNivel_ ) .And. ;
		( Upper(Alltrim(cCamp)) == "AK1_CODIGO" .Or. Upper(Alltrim(cCamp)) == "AK1_VERSAO" .Or. ;
		Upper(Alltrim(cCamp)) == "AK1_VERREV" .Or. Upper(Alltrim(cCamp)) == "AK1_DESCRI" )
		
		nUsado++
		Aadd(aCabAK1,{ TRIM(X3Titulo()),TRIM(cCamp) } )
		
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
���Programa  �PTNPCO2  �Autor  �                    � Data �              ���
�������������������������������������������������������������������������͹��
���Desc.     � Exclui os valores or�ados                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8 - MPE - PCO.                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function PTNPCO2()

Local cOrdem
Local lRet 		 := .T.
Local _nOpc		 := 0
Local cValor     := space(30)
private _cPerg   := "PTNA051"
private cClaOrc	 := ""
private cOperOrc := ""
private cCCusto  := ""

If Len(a_AK1) > 0 .AND. lExit == .F.
	
	If EMPTY(a_AK1[1][1])
		
		lRet := .F.
		Aviso("ATEN��O","N�o existe Registro na Tabela de Planilha Or�ament�ria(AK1) para o ano selecionado!",{"OK"})
		                      
	EndIf
	
Else
	
	lRet := .F.
	Aviso("ATEN��O","N�o existe Registro na Tabela de Planilha Or�ament�ria(AK1) para o ano selecionado!",{"OK"})
	
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
		If !ISDIGIT(MV_PAR04) .OR. !ISDIGIT(MV_PAR05)
			Aviso("ATEN��O","MesAno de inicio de fim devem possuir o seguinte formato: MMAAAA",{"OK"})
			lRet := .F.
			return(lRet)
		EndIf
		
		If SUBSTR(MV_PAR04,3,4) <> SUBSTR(MV_PAR05,3,4)
			Aviso("ATEN��O","Ano de inicio e fim precisam ser iguais.",{"OK"})
			lRet := .F.
			return(lRet)
		EndIf
		
		If SUBSTR(MV_PAR04,3,4) <> cGetAno .OR. SUBSTR(MV_PAR05,3,4) <> cGetAno
			Aviso("ATEN��O","Ano de inicio/fim diverge do Ano de referencia",{"OK"})
			lRet := .F.
			return(lRet)
		EndIf
		
		If VAL(SUBSTR(MV_PAR04,1,2)) > VAL(SUBSTR(MV_PAR05,1,2))
			Aviso("ATEN��O","Mes de inicio precisa ser menor que Mes fim.",{"OK"})
			lRet := .F.
			return(lRet)
		EndIf
		
		If (VAL(SUBSTR(MV_PAR04,1,2)) < 1 .OR. VAL(SUBSTR(MV_PAR04,1,2)) > 12) .OR.;
			(VAL(SUBSTR(MV_PAR05,1,2)) < 1 .OR. VAL(SUBSTR(MV_PAR05,1,2)) > 12)
			
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
				
				nData    := VAL( SUBSTR(MV_PAR04,3,4) + SUBSTR(MV_PAR04,1,2) )
				
				If nData < nDataMin .OR. nData > nDataMax
					Aviso("ATEN��O","MesAno informados precisam estar entre per�odo de in�cio e fim da planilha",{"OK"})
					lRet := .F.
				EndIf
				
				nData    := VAL( SUBSTR(MV_PAR05,3,4) + SUBSTR(MV_PAR05,1,2) )
				
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
		*Verifica se o centro de custo existe
		*--------------------------------------------------------------------------*
		cCCusto := MV_PAR03
		
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
		
		
		/*/
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
		/*/
		
		
		If cGetAno < cAnoIni .OR. cGetAno > cAnoFim
			Aviso("ATEN��O","O Ano de Refer�ncia e o Ano do per�odo da Planilha Or�amentaria s�o diferentes. Favor selecionar outra Planilha Or�ament�ria.",{"OK"})
			lRet := .F.
		Else
			
			If lRet == .T.
				Processa( { || xDeletar() }, "Processando..." )
			EndIf
			
		Endif
		
	EndIf
	
EndIf

Return(lRet)

*---------------------------------------------------------------------------------------------*
Static Function xDeletar()
*---------------------------------------------------------------------------------------------*
* Descricao: Ir� deletar os registros da tabela AK2                                           *
*---------------------------------------------------------------------------------------------*

Local cQuery		:= ""
Local lRet			:= .T.
Local nMes			:= 0
Local nMesIni		:= 0
Local nMesFim		:= 0
Local cChave        := ""

Begin Transaction


nMes    := VAL(SUBSTR(MV_PAR04,1,2))
nMesIni := VAL(SUBSTR(MV_PAR04,1,2)) //+ 3//soma devido a poscionamento dos campos de meses no layout
nMesFim := VAL(SUBSTR(MV_PAR05,1,2)) //+ 3//soma devido a poscionamento dos campos de meses no layout


dPerIni := StoD( cGetAno + StrZero( nMesIni, 02 ) + "01" )
dPerFim := StoD( cGetAno + StrZero( nMesFim, 02 ) + "01" )



cQuery := "SELECT * "										    +c_ent
cQuery += "FROM "+RetSqlName("AK2")+" AK2 "					    +c_ent
cQuery += "WHERE AK2.AK2_FILIAL = '" + xFilial("AK2") + "' "    +c_ent
cQuery += "  AND AK2.AK2_ORCAME = '" + alltrim(cOrcam) + "' "	+c_ent
cQuery += "  AND AK2.AK2_VERSAO = '" + alltrim(cVersao) + "' "  +c_ent
//cQuery += "  AND AK2.AK2_CO     = '" + alltrim(cContaOrc) + "' "		+c_ent
cQuery += "  AND AK2.AK2_PERIOD >= '" + DtoS(dPerIni) + "'"     +c_ent
cQuery += "  AND AK2.AK2_PERIOD <= '" + DtoS(dPerFim) + "'"     +c_ent
cQuery += "  AND AK2.AK2_CC     = '" + alltrim(cCCusto) + "' "	+c_ent
//cQuery += "  AND AK2.AK2_CLASSE = '000002' "	            	+c_ent                                                                              
//cQuery += "  AND AK2.AK2_CLASSE = '" + alltrim(cClaOrc) + "' "		+c_ent
cQuery += "  AND AK2.D_E_L_E_T_ = ' ' "


If select("TRB1AK2")>0
	dbSelectArea("TRB1AK2")
	dbCloseArea()
EndIf

TCQUERY cQuery New Alias "TRB1AK2"


Do While TRB1AK2->(!Eof())
	
	PcoIniLan("000252")    
	
	PcoDetLan("000252","01","PCOA100",.T.)
		
   //AK2_FILIAL+AK2_ORCAME+AK2_VERSAO+AK2_CO+AK2_PERIOD+AK2_ID                                                                                                                                                                                                 
	DbSelectArea("AK2")
	DbSetOrder(1)
	IF DbSeek(xFilial("AK2") + TRB1AK2->AK2_ORCAME + TRB1AK2->AK2_VERSAO + TRB1AK2->AK2_CO + TRB1AK2->AK2_PERIOD + TRB1AK2->AK2_ID)  
	
	//Do While !Eof() .and. AK2->AK2_ORCAME == TRB1AK2->AK2_ORCAME .AND. AK2->AK2_VERSAO == TRB1AK2->AK2_VERSAO .AND. AK2->AK2_CO == TRB1AK2->AK2_CO .AND. AK2->AK2_PERIOD == TRB1AK2->AK2_PERIOD .AND. AK2->AK2_ID == TRB1AK2->AK2_ID  
	    AK2->(RecLock("AK2",.F.))
		AK2->(dbDelete())
		AK2->(MsUnLock())
	  //	DbSkip()
	//EndDo
	
	EndIf                 
   
	  
	  	  
	cChave := "AK2" + TRB1AK2->AK2_FILIAL + TRB1AK2->AK2_ORCAME + TRB1AK2->AK2_VERSAO + TRB1AK2->AK2_CO + TRB1AK2->AK2_PERIOD + TRB1AK2->AK2_ID
	
	
	 //  AKD_FILIAL+AKD_CHAVE+AKD_SEQ     
	DbSelectArea("AKD")
	DbSetOrder(10)
	If DbSeek(xFilial("AKD") + cChave )  
	
	Do While !Eof() .and. ALLTRIM(AKD->AKD_CHAVE) == ALLTRIM(cChave) 
	    AKD->(RecLock("AKD",.F.))
		AKD->(dbDelete())
		AKD->(MsUnLock())
	  	DbSkip()
	EndDo
	
    EndIf
	
	   
    
    PcoFinLan("000252") 


	TRB1AK2->(dbSkip())
	
EndDo



End Transaction


	Aviso("ATEN��O","Rotina de exclus�o finalizada! Por favor verificar.",{"OK"})


Return(lRet)



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
	
	Aviso("ATEN��O","N�o existe Registro na Tabela de Planilha Or�ament�ria(AK1) para o ano selecionado!",{"OK"})
	
EndIf

Return

*************************************************************************************************************
*************************************************************************************************************

Static Function ValidPerg()

Local aHelpPor := {}
Local aHelpEsp := {}
Local aHelpEng := {}

PutSx1(_cPerg,"01","Or�amento ?"         ,"Or�amento ?"         ,"Or�amento ?"         ,"mv_ch1","C",TAMSX3("AK1_CODIGO")[1],0,0,"G","","AK1","","","mv_par01")
PutSx1(_cPerg,"02","Clas.Or�ament�ria ?" ,"Clas.Or�ament�ria ?" ,"Clas.Or�ament�ria ?" ,"mv_ch2","C",TAMSX3("AK6_CODIGO")[1],0,0,"G","","AK6","","","mv_par02")
PutSx1(_cPerg,"03","C.Custo?"            ,"C.Custo?"            ,"C.Custo?"            ,"mv_ch3","C",TAMSX3("CTT_CUSTO")[1],0,0,"G","","CTT","","","mv_par03")
PutSx1(_cPerg,"04","MesAno Ini (MMAAAA)?","MesAno Ini (MMAAAA)?","MesAno Ini (MMAAAA)?","mv_ch4","C",06,0,0,"G","","","","","mv_par04")
PutSx1(_cPerg,"05","MesAno Fim (MMAAAA)?","MesAno Fim (MMAAAA)?","MesAno Fim (MMAAAA)?","mv_ch5","C",06,0,0,"G","","","","","mv_par05")



Return
