#include "Protheus.ch"
#include "TopConn.ch"
#DEFINE cEnt Chr(13) + Chr(10)

**************************************************************************************
* Programa    : MTA096MNU                                              Em : 16/10/13 *
* Objetivo    : Habilitar rotina no menu para tratar a amarracao Grupo x CC          *
* Autor       : Ricardo Ferreira                                                     *
**************************************************************************************    


************************
User Function MTA096MNU()
************************

AAdd( aRotina, { "C.Custo x Grupo" 	, "U_MTA096CC()", 0, 4 } )
//AAdd( aRotina, { "Rel. CC x Grupo" 	, "U_PTNR001()" , 0, 4 } )


Return 


**************************************************************************************
* Programa    : MTA096CC                                               Em : 16/10/13  
* Objetivo    : Amarração Grupo x CC	                                               
* Autor       : Ricardo Ferreira                                                     
**************************************************************************************    


************************
User Function MTA096CC(cAlias,nReg,nOpcx)
************************
Local cGrupo 		:= SAL->AL_COD
Local cDescGrp	:= SAL->AL_DESC
Local oDlg			:= Nil
Local nOpca		:= 0
Local nUsado		:= 0

Local aAlter       	:= {"CTT_FILIAL","CTT_CUSTO"}
Local nOpcx        	:= GD_INSERT+GD_DELETE+GD_UPDATE
Local cLinOk       	:= "AllwaysTrue"/*"U_LinOk"*/    // Funcao executada para validar o contexto da linha atual do aCols
Local cTudoOk      	:= "AllwaysTrue"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.
Local nFreeze      	:= 000              // Campos estaticos na GetDados.
Local nMax         	:= 999              // Numero maximo de linhas permitidas. Valor padrao 99
Local cFieldOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo
Local cSuperDel    	:= ""              // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cDelOk       	:= "AllwaysTrue"   // Funcao executada para validar a exclusao de uma linha do aCols
Local nAtual  := 0
local nCntFor := 0

PRIVATE aHeader := {}
PRIVATE aCOLS   := {}
PRIVATE aGETS   := {}
PRIVATE aTELA   := {}


Private oFont		 := TFont():New("Arial",,-13,,.T.) // Define a fonte diferenciada p/tela
Private oFont1	 := TFont():New("Arial",,-11,,.T.) // Define a fonte diferenciada p/tela
*----------------------------------------------------------------+
*| /* Montagem do aHeader   */                                       |
*----------------------------------------------------------------+
DbselectArea("CTT")
aHeader := CTT->(DbStruct())
 
//Percorre todos os campos da estrutura da tabela
For nAtual := 1 To Len(aHeader)
    //Chama a função que adiciona ao array via @, conforme o campo atual, e o tipo é 4 que será usado em um MsNewGetDados
    u_zX3ToArr(@aHeader, aHeader[nAtual][1], 4)
Next
/*dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("CTT")
While ( !Eof() .And. SX3->X3_ARQUIVO == "CTT" )
	If ( X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL ) .AND. (ALLTRIM(SX3->X3_CAMPO) $ "CTT_CUSTO|CTT_DESC01")
		nUsado++
		AADD(aHeader,{ AllTrim(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			"ExistCpo('CTT')",;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			"CTT002",;
			SX3->X3_CONTEXT,;
			SX3->X3_CBOX,;
			SX3->X3_RELACAO,;
			SX3->X3_WHEN,;
			SX3->X3_VISUAL,;
			".t.",;
			SX3->X3_PICTVAR,;
			SX3->X3_OBRIGAT})
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo
*/



*----------------------------------------------------------------+
*   Montagem do aCols                                            |
*----------------------------------------------------------------+




cQuery := "SELECT CTT_FILIAL,CTT_CUSTO,CTT_DESC01 "
cQuery += "FROM "+RetSqlName("CTT")+" CTT "
cQuery += "WHERE CTT.CTT_FILIAL='" + xFilial("CTT") + "' AND "
cQuery +=       "CTT.CTT_CLASSE = '2' AND CTT_XGPCMP = '" + cGrupo + "' AND "
cQuery +=       "CTT.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY CTT_FILIAL,CTT_CUSTO

TCQUERY cQuery New Alias "TRB1"



While !TRB1->(Eof()) 
	aadd(aCOLS,Array(nUsado+1))
	For nCntFor := 1 To nUsado
		aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor][2]))
	Next nCntFor
	aCOLS[Len(aCols)][Len(aHeader)+1] := .F.
	TRB1->(dbSkip())
EndDo

dbSelectArea("TRB1")
dbCloseArea()
dbSelectArea(cAlias)


DEFINE MSDIALOG oDlg TITLE "Amarração Grupo Compras x Centros de Custo" From 0,0 To 300,800 OF oMainWnd PIXEL

@ 010,010 SAY "Grupo de aprovação : " + cGrupo + "-" + cDescGrp SIZE 300,07 OF oDlg PIXEL FONT oFont Color CLR_BLUE



@ 030,010 SAY "Informe os Centros de Custo que serão aprovados por esse grupo de aprovação." SIZE 300,07 OF oDlg PIXEL FONT oFont1


oGetCtt:= MsNewGetDados():New(040,010,100,400,nOpcx,cLinOk,cTudoOk,cIniCpos,;
aAlter,nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oDlg,aHeader,aCols) 

@ 120,310 BUTTON "&Salvar"        SIZE 40,18 of oDlg PIXEL ACTION {||Processa({||Grava(oGetCtt,cGrupo) },"Gravando..."),oDlg:End()}
@ 120,360 BUTTON "&Cancelar"      SIZE 40,18 of oDlg PIXEL ACTION oDlg:End()


ACTIVATE MSDIALOG oDlg CENTERED




IF  nOpca = 1
	
	Grava(oGetCtt)


EndIf



Return .T.



Static Function Grava(oGetCtt,cGrupo)
Local aCols 	:= aClone(oGetCtt:aCols)
Local aHeader := aClone(oGetCtt:aHeader)
Local nPosCtt := aScan(aHeader,{|x| AllTrim(x[2])=="CTT_CUSTO"})
local i := 0
Local cQuery 	:= " "


ProcRegua(Len(aCols))


/***********************************************************************************************************************************************
* Cada centro de custo só pode se aprovado por 1 grupo, mas o grupo pode aprovar vários centros de custo.
* Como na abertura da tela, vem todos os centros de custo que estão sendo aprovados pelo grupo e o usuário, pode alterar e/ou excluir
* Primeiro limpo todos os centros de custo que estão gravados com o grupo atual, e refaço a gravação de acordo com o acols.
* Como temos a possibilidade de ter centro de custo sem grupo de aprovação gravado, farei um relatório exibindo os grupos e quais cc aprovam
* e mostrando também quais os centros de custo que estão sem aprovação.
************************************************************************************************************************************************/

//Limpar o grupo de aprovação dos centros de custo.

cQuery := "UPDATE "+RetSqlName("CTT")+" SET CTT_XGPCMP = ' '" +cEnt
cQuery += "WHERE CTT_FILIAL='" + xFilial("CTT") + "' AND CTT_XGPCMP = '" + cGrupo + "' AND D_E_L_E_T_ = ' ' " 

If (TCSQLExec(cQuery) < 0)
	cMSGeRRO:= cQuery
	Alert(TCSQLError())

EndIf


DbSelectArea("CTT")
DbSetOrder(1)	
For i:= 1 to Len(aCols)
	
	IncProc()

	If DbSeek(xFilial("CTT")+aCols[i][nPosCtt])
		RecLock("CTT",.f.)
		If !aCols[i][Len(aCols[i])] //Se não estiver deletado grava o grupo no Ccusto, senão, limpa do ccusto.
			CTT_XGPCMP:= cGrupo

		Else
			CTT_XGPCMP:= " "
		
		Endif
		MsUnlock()
	Endif

Next

//Alert("Atualização finalizada!")


Return









