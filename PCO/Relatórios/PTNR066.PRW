#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Programa : PTNR066  | Autor : Rafael Sacramento  | Data : 26/05/2017    ±±
±±                     |      Criare Consulting     |                      ±±   
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Desc. : Relatório que exibe as notas de entrada, com ênfase na análise  ±±
±± de conta orçamentária x centro de custo.             				   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Uso  : Concessionária Porto Novo / Módulo PCO                           ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/ 


User Function PTNR066()

Local oReport
Local cPerg  := 'PTNR066'
Local cAlias := getNextAlias()

CriaSx1(cPerg)
Pergunte(cPerg, .F.)

oReport := reportDef(cAlias, cPerg)
oReport:printDialog()

Return  
          
//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados no relatório.                                                  !
//+-----------------------------------------------------------------------------------------------+

Static Function ReportPrint(oReport,cAlias)
                 
Local oSecao1 := oReport:Section(1)

oSecao1:BeginQuery()


BeginSQL Alias cAlias

	Column D1_DTDIGIT AS DATE
	
	SELECT D1_XCO, AK5_DESCRI, D1_CC, D1_DTDIGIT, D1_FORNECE+D1_LOJA COD_FORN, A2_NOME, D1_DOC, D1_CUSTO,
	CASE D1_RATEIO WHEN 1 THEN 'SIM' ELSE 'NÃO' END D1_RATEIO
	FROM %Table:SD1% SD1
	
	INNER JOIN %Table:SA2% SA2
	ON D1_FORNECE = A2_COD
	AND D1_LOJA = A2_LOJA
	AND SA2.%notDel%

	LEFT JOIN %Table:CTT% CTT
	ON D1_FILIAL = CTT_FILIAL
	AND D1_CC = CTT_CUSTO
	AND CTT.%notDel%

	LEFT JOIN %Table:AK5% AK5
	ON D1_FILIAL = AK5_FILIAL
	AND D1_XCO = AK5_CODIGO
	AND AK5.%notDel%

	WHERE D1_FILIAL = '0101'
	AND D1_DTDIGIT BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
	AND D1_XCO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
	AND D1_CC BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
	AND D1_RATEIO = '2'
	AND SD1.%notDel%	

	UNION ALL
	
	SELECT DE_XCO, AK5_DESCRI, DE_CC, D1_DTDIGIT, D1_FORNECE+D1_LOJA COD_FORN, A2_NOME, DE_DOC, DE_CUSTO1,
	CASE D1_RATEIO WHEN 1 THEN 'SIM' ELSE 'NÃO' END D1_RATEIO
	FROM %Table:SD1% SD1
	
	INNER JOIN %Table:SA2% SA2
	ON D1_FORNECE = A2_COD
	AND D1_LOJA = A2_LOJA
	AND SA2.%notDel%

	INNER JOIN %Table:SDE% SDE
	ON D1_FILIAL = DE_FILIAL
	AND D1_FORNECE = DE_FORNECE
	AND D1_LOJA = DE_LOJA
	AND D1_DOC = DE_DOC
	AND D1_SERIE = DE_SERIE
	AND D1_ITEM = DE_ITEMNF
	AND SDE.%notDel%

	INNER JOIN %Table:CTT% CTT
	ON DE_FILIAL = CTT_FILIAL
	AND DE_CC = CTT_CUSTO
	AND CTT.%notDel%

	INNER JOIN %Table:AK5% AK5
	ON DE_FILIAL = AK5_FILIAL
	AND DE_XCO = AK5_CODIGO
	AND AK5.%notDel%
	
	WHERE D1_FILIAL = '0101'
	AND D1_DTDIGIT BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
	AND DE_XCO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
	AND DE_CC BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
	AND SD1.%notDel%

	ORDER BY D1_DOC, D1_DTDIGIT, D1_XCO, D1_CC
	

EndSQL 


oSecao1:EndQuery()  

oReport:SetMeter((cAlias)->(RecCount()))  

oSecao1:Print()	   

return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+

Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Relatório de Notas fiscais por CC x CO"
local cHelp   := "Gera um relatório de Notas fiscais dentro do período informado no parâmetro."

local oReport
local oSection1

oReport	:= TReport():New('PTNR066',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)

oSection1 := TRSection():New(oReport,"NOTAS FISCAIS",{"SD1","SDE","SB1","SA2","AK5","CTT"})  

//TRCell():New( oSecBem, "campo", "tabela", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"D1_XCO",				"SD1", "CONTA ORÇAMENTÁRIA",  				)
TRCell():New(oSection1,"AK5_DESCRI", 			"AK5", "DESCRIÇÃO CO",						)  
TRCell():New(oSection1,"D1_CC", 				"SD1", "CENTRO DE CUSTO",   				)
TRCell():New(oSection1,"D1_DTDIGIT", 			"SD1", "DT DIGITAÇÃO",						) 
TRCell():New(oSection1,"COD_FORN", 				"SD1", "CÓDIGO",							) 
TRCell():New(oSection1,"A2_NOME", 				"SA2", "FORNECEDOR",						)
TRCell():New(oSection1,"D1_DOC",				"SD1", "NOTA FISCAL",						)
TRCell():New(oSection1,"D1_CUSTO", 				"SD1", "VALOR",		 "@E 999,999,999,999.99")
TRCell():New(oSection1,"D1_RATEIO",				"SD1", "RATEIO",						 	)   

Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! Função para a criação das perguntas, caso elas não existam.                                   !
//+-----------------------------------------------------------------------------------------------+

Static Function criaSX1(cPerg)

putSx1(cPerg, '01', 'Dt Digit De?' ,'', '', 'mv_ch1', 'D', 08, 0, 0, 'G', 				 '', ''   , '', '', 'mv_par01',,,,,,,,,,,,,,,,,{"Dt inicial a considerar para NF."},{"Dt inicial a considerar para NF."},{"Dt inicial a considerar para NF."})
putSx1(cPerg, '02', 'Dt Digit Ate?','', '', 'mv_ch2', 'D', 08, 0, 0, 'G', 				 '', ''   , '', '', 'mv_par02',,,,,,,,,,,,,,,,,{"Dt final a considerar para NF."},{"Dt final a considerar para NF."},{"Dt final a considerar para NF."})
putSx1(cPerg, '03', 'Da Conta'     ,'', '', 'mv_ch3', 'C', 12, 0, 0, 'G', 'ExistCpo("AK5")', 'AK5', '', '', 'mv_par03',,,,,,,,,,,,,,,,,{"Conta orc. inicial a ser considerada."},{"Conta orc. inicial a ser considerada."},{"Conta orc. inicial a ser considerada."})
putSx1(cPerg, '04', 'Ate Conta?'   ,'', '', 'mv_ch4', 'C', 12, 0, 0, 'G', 'ExistCpo("AK5")', 'AK5', '', '', 'mv_par04',,,,,,,,,,,,,,,,,{"Conta orc. final a ser considerada."},{"Conta orc. final a ser considerada."},{"Conta orc. final a ser considerada."})
putSx1(cPerg, '05', 'Do C. Custo?' ,'', '', 'mv_ch5', 'C', 20, 0, 0, 'G', 'ExistCpo("CTT")', 'CTT', '', '', 'mv_par05',,,,,,,,,,,,,,,,,{"C. custo inicial a ser considerado."},{"C. custo inicial a ser considerado."},{"C. custo inicial a ser considerado."})
putSx1(cPerg, '06', 'Ate C. Custo?','', '', 'mv_ch6', 'C', 20, 0, 0, 'G', 'ExistCpo("CTT")', 'CTT', '', '', 'mv_par06',,,,,,,,,,,,,,,,,{"C. custo final a ser considerado."},{"C. custo final a ser considerado."},{"C. custo final a ser considerado."})

Return    
