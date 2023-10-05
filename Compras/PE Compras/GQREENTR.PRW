#Include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GQREENTR  ºAutor  ³ Vinicius Figueiredo Moreira ºData³ 22/05/13 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada antes da gravação informações diversas    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GQREENTR()

Local aarea := getarea()    
Local oDlg := NiL     
Local oCombo := NiL
Local cCombo  := ""
Private aAmb           := {"","SPP - SOLICITAÇÃO DE PEQUENO PORTE","CTT - CONTRATO DE TERCEIROS"}
Private ofont1       :=tfont():new("Arial",,-12,.T.,)

cAliasQry := GetNextAlias()

cQuery := "SELECT D1_COD "
cQuery += "  FROM " + RetSqlName( "SD1" )+" SD1 ,"+RetSqlName( "SB1" )+" SB1 " 
cQuery += " WHERE D1_FILIAL = '" + xFilial( "SD1" ) + "'"
cQuery += "   AND B1_FILIAL = '" + xFilial( "SB1" ) + "'"
cQuery += "   AND D1_DOC = '"+SF1->F1_DOC+"' "   
cQuery += "   AND D1_FORNECE = '"+SF1->F1_FORNECE+"' "   
cQuery += "   AND D1_LOJA = '"+SF1->F1_LOJA+"' "   
cQuery += "   AND D1_COD = B1_COD "
cQuery += "   AND B1_GRUPO = '0026' "
cQuery += "   AND SD1.D_E_L_E_T_ = ' '"
cQuery += "   AND SB1.D_E_L_E_T_ = ' '"

cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TOPCONN", TcGenQry( ,,cQuery ), cAliasQry, .F., .T. )

If (cAliasQry)->(!EoF())
	
	DEFINE MSDIALOG oDlg TITLE "Tipo classificação NF" FROM 000,000 TO 150,400 OF oDlg PIXEL
	
	@ 015,005 SAY "Tipo classificação: "  OF oDlg PIXEL
	@ 015,062 ComboBox oCombo VAR cCombo ITEMS aAmb SIZE 135, 010  OF oDlg PIXEL       
	
	@ 057,062 Button "&Ok" Size 040,012 PIXEL OF oDlg Action  Iif(Empty(cCombo),Alert("Tipo classificação preenchimento obrigatório!"),oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTER
	
	RecLock("SF1",.F.)
	SF1->F1_XNFCLAS		:= SubSTR(AllTrim(cCombo),1,3)
	MsUnlock()
	
Endif
( cAliasQry )->( dbCloseArea() )

    
Restarea(aarea)
Return
