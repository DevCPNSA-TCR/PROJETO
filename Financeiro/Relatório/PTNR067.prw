#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Programa : PTNR067  | Autor : Rafael Sacramento  | Data : 12/07/2017    ±±
±±                     |      Criare Consulting     |                      ±±   
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Desc. : Relatório de fluxo de caixa									   ±±
±±                                                      				   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Uso  : Concessionária Porto Novo / Módulo Financeiro                    ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/ 


User Function PTNR067()

Local oReport
Local cPerg  := 'PTNR067'
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

//(CASE WHEN D1_RATEIO IN ('SIM','INCLUSAO MANUAL/FOLHA') THEN DE_CUSTO1 ELSE (DE_CUSTO1 / NF_TOT) * E5_VALOR  END) DE_CUSTO1,
BeginSQL Alias cAlias

	Column E2_EMISSAO AS DATE
	Column E5_DATA AS DATE
	
	SELECT E2_EMISSAO, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_NATUREZ, E2_NOMFOR, E5_DATA,CC, 
	DE_CUSTO1,
	E5_VALOR,  CO, D1_RATEIO,NF_TOT
	 FROM
	(
	
		SELECT E2_EMISSAO, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_NATUREZ, E2_NOMFOR, E5_DATA,CC, 
		 		(DE_CUSTO1 / NF_TOT) * E5_VALOR  DE_CUSTO1, 
		 		E5_VALOR,  CO, D1_RATEIO
		 		,NF_TOT
		 		FROM 
		 		(
					 	SELECT E2_EMISSAO, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_NATUREZ, E2_NOMFOR, 
						E5_DATA, DE_CC AS CC,DE_CUSTO1, E5_VALOR , DE_XCO CO, 
						CASE D1_RATEIO WHEN '1' THEN 'SIM' ELSE 'NÃO' END D1_RATEIO, 
						(SELECT SUM(D1_CUSTO) FROM %table:SD1% SD1_T WHERE 	SD1_T.D1_FILIAL = SD1.D1_FILIAL AND 
																		SD1_T.D1_DOC = SD1.D1_DOC AND 
																		SD1_T.D1_SERIE = SD1.D1_SERIE AND 
																		SD1_T.D1_FORNECE = SD1.D1_FORNECE AND
																		SD1_T.D1_LOJA = SD1.D1_LOJA AND
																		SD1_T.%notdel%) NF_TOT
						FROM %table:SE2% SE2
						

						
						INNER JOIN %table:SD1% SD1
						ON E2_FILIAL = D1_FILIAL
						AND ((E2_FORNECE = D1_FORNECE
						AND E2_LOJA = D1_LOJA
						AND E2_NUM = D1_DOC
						AND E2_PREFIXO = D1_SERIE) 
						OR (E2_TITPAI <> ' ' 	AND D1_SERIE = SUBSTRING(E2_TITPAI,1,3) 
												AND D1_DOC   = SUBSTRING(E2_TITPAI,4,9) 
												AND D1_FORNECE  = SUBSTRING(E2_TITPAI,19,6) 
												AND D1_LOJA  = SUBSTRING(E2_TITPAI,25,6)))
					    AND D1_RATEIO = '1'
						AND SD1.%notdel%
						
						INNER JOIN %table:SDE% SDE
						ON D1_FILIAL = DE_FILIAL
						AND D1_FORNECE = DE_FORNECE
						AND D1_LOJA = DE_LOJA
						AND D1_DOC = DE_DOC
						AND D1_SERIE = DE_SERIE
						AND D1_ITEM = DE_ITEMNF
						AND SDE.%notdel%
					    
					    
					    INNER JOIN %table:SE5% SE5 ON
					    E5_FILIAL = E2_FILIAL AND
					    E5_PREFIXO = E2_PREFIXO AND
					    E5_NUMERO = E2_NUM AND
					    E5_PARCELA = E2_PARCELA AND
					    E5_TIPO = E2_TIPO AND
					    E5_CLIFOR = E2_FORNECE AND
					    E5_LOJA =  E2_LOJA AND
						E5_RECPAG = 'P' AND
						NOT E5_MOTBX IN ('CMP','DAC','LIQ') AND
						
						(	(E5_TIPODOC = 'BA' AND E5_NUMCHEQ <> ' ' ) OR
							(E5_TIPODOC = 'BA' AND E2_FATURA <> ' ' AND EXISTS(select 1 FROM  %table:SE2% E2FAT WHERE E2FAT.E2_FILIAL = SE2.E2_FILIAL AND 
																						E2FAT.E2_NUM = SE2.E2_FATURA AND 
																						E2FAT.E2_FATURA = 'NOTFAT' AND 
																						E2FAT.E2_FORNECE = SE2.E2_FORNECE AND 
																						E2FAT.E2_LOJA = SE2.E2_LOJA AND 
																						E2FAT.%notdel% AND 
																						EXISTS(SELECT 1 FROM  %table:SE5% E5FAT WHERE E5FAT.E5_FILIAL = E2FAT.E2_FILIAL AND 
																								E5FAT.E5_PREFIXO = E2FAT.E2_PREFIXO AND 
																								E5FAT.E5_NUMERO = E2FAT.E2_NUM AND 
																								E5FAT.E5_PARCELA = E2FAT.E2_PARCELA AND
																								E5FAT.E5_TIPO = E2FAT.E2_TIPO AND 
																								E5FAT.E5_CLIFOR = E2FAT.E2_FORNECE AND 
																								E5FAT.E5_LOJA = E2FAT.E2_LOJA AND 
																								E5FAT.E5_RECPAG = 'P' AND 
																								NOT E5FAT.E5_MOTBX IN ('CMP','DAC','LIQ') AND
																								E5FAT.%notdel%))) OR	
						
						
						(E5_TIPODOC = 'BA' AND E5_AGLIMP <> ' ' AND EXISTS(select 1 FROM %table:SE2% E2AG
																				WHERE E2AG.E2_FILIAL = SE2.E2_FILIAL AND 
																				E2AG.E2_NUM = SE5.E5_AGLIMP AND
																				E2AG.E2_CODRET = SE2.E2_CODRET AND
																				E2AG.E2_PREFIXO IN ('AGL','AGP') AND
																				E2AG.%notdel% AND
																				EXISTS(SELECT 1 FROM %table:SE5% E5AG WHERE E5AG.E5_FILIAL = E2AG.E2_FILIAL AND
																										E5AG.E5_PREFIXO = E2AG.E2_PREFIXO AND
																										E5AG.E5_NUMERO = E2AG.E2_NUM AND
																										E5AG.E5_PARCELA = E2AG.E2_PARCELA AND
																										E5AG.E5_TIPO = E2AG.E2_TIPO AND
																										E5AG.E5_CLIFOR = E2AG.E2_FORNECE AND
																										E5AG.E5_LOJA =  E2AG.E2_LOJA AND
																										NOT E5AG.E5_MOTBX IN ('CMP','DAC','LIQ') AND
																										E5AG.E5_RECPAG = 'P' AND E5AG.%notdel%))) OR
						(NOT E5_TIPODOC IN('BA','MT','CM','DC','JR','CP','M2','C2','D2','J2','V2'))) AND
						
						NOT E5_SITUACA IN('X','E','C') AND
						E5_TIPO != 'PR' AND
						SE5.%notdel% AND
						NOT EXISTS(SELECT 1 FROM %table:SE5% E5  WHERE
									SE5.E5_FILIAL = E5.E5_FILIAL AND
									SE5.E5_CLIFOR = E5.E5_CLIFOR AND
									SE5.E5_LOJA = E5.E5_LOJA AND
									SE5.E5_PREFIXO = E5.E5_PREFIXO AND
									SE5.E5_NUMERO = E5.E5_NUMERO AND
									SE5.E5_TIPO = E5.E5_TIPO AND
									SE5.E5_PARCELA = E5.E5_PARCELA AND
									SE5.E5_SEQ = E5.E5_SEQ AND
									E5.E5_TIPODOC = 'ES' AND 
									E5.E5_KEY = ' ' AND SE5.E5_VALOR = E5.E5_VALOR AND 
									E5.%notdel%)  AND
						
						NOT EXISTS(SELECT 1 FROM %table:SE5% E5  WHERE
									E5.E5_KEY != ' ' AND 
									SE5.E5_KEY = E5.E5_KEY AND
									SE5.E5_FILIAL = E5.E5_FILIAL AND
									SE5.E5_SEQ = E5.E5_SEQ AND
									SE5.E5_VALOR = E5.E5_VALOR AND 
									E5.E5_TIPODOC = 'ES' AND 
									E5.%notdel%)
						
						
						
						WHERE E2_FILIAL = %xFilial:SE2%
						AND E5_DATA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
					
						AND DE_CC BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06% 
						AND DE_XCO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% 
						AND E2_FATURA <> 'NOTFAT'
						AND (E2_BAIXA <> '' OR (E2_BAIXA = '' AND E2_TIPO = 'PA'))
						AND SE2.%notdel%
						
						UNION ALL
						
					
						SELECT E2_EMISSAO, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_NATUREZ, E2_NOMFOR, 
						E5_DATA, D1_CC AS CC, SUM(D1_CUSTO) AS DE_CUSTO1, MAX(E5_VALOR) E5_VALOR, D1_XCO CO,
						CASE D1_RATEIO WHEN '1' THEN 'SIM' ELSE 'NÃO' END D1_RATEIO,
						(SELECT SUM(D1_CUSTO) FROM %table:SD1% SD1_T WHERE 	SD1_T.D1_FILIAL = SD1.D1_FILIAL AND 
																		SD1_T.D1_DOC = SD1.D1_DOC AND 
																		SD1_T.D1_SERIE = SD1.D1_SERIE AND 
																		SD1_T.D1_FORNECE = SD1.D1_FORNECE AND
																		SD1_T.D1_LOJA = SD1.D1_LOJA AND
																		SD1_T.%notdel%) NF_TOT
						
						FROM %table:SE2% SE2
						
						INNER JOIN %table:SD1% SD1
						ON E2_FILIAL = D1_FILIAL
						AND ((E2_FORNECE = D1_FORNECE
						AND E2_LOJA = D1_LOJA
						AND E2_NUM = D1_DOC
						AND E2_PREFIXO = D1_SERIE) 
						OR (E2_TITPAI <> ' ' 	AND D1_SERIE = SUBSTRING(E2_TITPAI,1,3) 
												AND D1_DOC   = SUBSTRING(E2_TITPAI,4,9) 
												AND D1_FORNECE  = SUBSTRING(E2_TITPAI,19,6) 
												AND D1_LOJA  = SUBSTRING(E2_TITPAI,25,6)))
						AND SD1.%notdel%
						
						INNER JOIN %table:SE5% SE5 ON
					    E5_FILIAL = E2_FILIAL AND
					    E5_PREFIXO = E2_PREFIXO AND
					    E5_NUMERO = E2_NUM AND
					    E5_PARCELA = E2_PARCELA AND
					    E5_TIPO = E2_TIPO AND
					    E5_CLIFOR = E2_FORNECE AND
					    E5_LOJA =  E2_LOJA AND
						E5_RECPAG = 'P' AND
						NOT E5_MOTBX IN ('CMP','DAC','LIQ') AND
						
						(	(E5_TIPODOC = 'BA' AND E5_NUMCHEQ <> ' ' ) OR
							(E5_TIPODOC = 'BA' AND E2_FATURA <> ' ' AND EXISTS(select 1 FROM  %table:SE2% E2FAT WHERE E2FAT.E2_FILIAL = SE2.E2_FILIAL AND 
																						E2FAT.E2_NUM = SE2.E2_FATURA AND 
																						E2FAT.E2_FATURA = 'NOTFAT' AND 
																						E2FAT.E2_FORNECE = SE2.E2_FORNECE AND 
																						E2FAT.E2_LOJA = SE2.E2_LOJA AND 
																						E2FAT.%notdel% AND 
																						EXISTS(SELECT 1 FROM  %table:SE5% E5FAT WHERE E5FAT.E5_FILIAL = E2FAT.E2_FILIAL AND 
																								E5FAT.E5_PREFIXO = E2FAT.E2_PREFIXO AND
																								E5FAT.E5_NUMERO = E2FAT.E2_NUM AND 
																								E5FAT.E5_PARCELA = E2FAT.E2_PARCELA AND
																								E5FAT.E5_TIPO = E2FAT.E2_TIPO AND 
																								E5FAT.E5_CLIFOR = E2FAT.E2_FORNECE AND 
																								E5FAT.E5_LOJA = E2FAT.E2_LOJA AND 
																								E5FAT.E5_RECPAG = 'P' AND 
																								NOT E5FAT.E5_MOTBX IN ('CMP','DAC','LIQ') AND
																								E5FAT.%notdel%))) OR							
						
						(E5_TIPODOC = 'BA' AND E5_AGLIMP <> ' ' AND EXISTS(select 1 FROM %table:SE2% E2AG
																				WHERE E2AG.E2_FILIAL = SE2.E2_FILIAL AND 
																				E2AG.E2_NUM = SE5.E5_AGLIMP AND
																				E2AG.E2_CODRET = SE2.E2_CODRET AND
																				E2AG.E2_PREFIXO IN ('AGL','AGP') AND
																				E2AG.%notdel% AND
																				EXISTS(SELECT 1 FROM %table:SE5% E5AG WHERE E5AG.E5_FILIAL = E2AG.E2_FILIAL AND
																										E5AG.E5_PREFIXO = E2AG.E2_PREFIXO AND
																										E5AG.E5_NUMERO = E2AG.E2_NUM AND
																										E5AG.E5_PARCELA = E2AG.E2_PARCELA AND
																										E5AG.E5_TIPO = E2AG.E2_TIPO AND
																										E5AG.E5_CLIFOR = E2AG.E2_FORNECE AND
																										E5AG.E5_LOJA =  E2AG.E2_LOJA AND
																										NOT E5AG.E5_MOTBX IN ('CMP','DAC','LIQ') AND
																										E5AG.E5_RECPAG = 'P' AND E5AG.%notdel%))) OR
						(NOT E5_TIPODOC IN('BA','MT','CM','DC','JR','CP','M2','C2','D2','J2','V2'))) AND
						
						NOT E5_SITUACA IN('X','E','C') AND
						E5_TIPO != 'PR' AND
						SE5.%notdel% AND
						NOT EXISTS(SELECT 1 FROM %table:SE5% E5  WHERE
									SE5.E5_FILIAL = E5.E5_FILIAL AND
									SE5.E5_CLIFOR = E5.E5_CLIFOR AND
									SE5.E5_LOJA = E5.E5_LOJA AND
									SE5.E5_PREFIXO = E5.E5_PREFIXO AND
									SE5.E5_NUMERO = E5.E5_NUMERO AND
									SE5.E5_TIPO = E5.E5_TIPO AND
									SE5.E5_PARCELA = E5.E5_PARCELA AND
									SE5.E5_SEQ = E5.E5_SEQ AND
									E5.E5_TIPODOC = 'ES' AND 
									E5.E5_KEY = ' ' AND SE5.E5_VALOR = E5.E5_VALOR AND 
									E5.%notdel%)  AND
						
							NOT EXISTS(SELECT 1 FROM %table:SE5% E5  WHERE
									E5.E5_KEY != ' ' AND 
									SE5.E5_KEY = E5.E5_KEY AND
									SE5.E5_FILIAL = E5.E5_FILIAL AND
									SE5.E5_SEQ = E5.E5_SEQ AND
									SE5.E5_VALOR = E5.E5_VALOR AND 
									E5.E5_TIPODOC = 'ES' AND 
									E5.%notdel%)
						
						WHERE E2_FILIAL = %xFilial:SE2%
						AND E5_DATA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
						AND E2_CCD BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06% 
						AND E2_XCO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% 
						AND E2_FATURA <> 'NOTFAT'
						AND (E2_BAIXA <> '' OR (E2_BAIXA = '' AND E2_TIPO = 'PA'))
						AND D1_RATEIO <> '1'
						AND SE2.%notdel%	
						
						GROUP BY D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,E2_EMISSAO, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_NATUREZ, E2_NOMFOR, E5_DATA, D1_CC, D1_XCO,D1_RATEIO
				) B
	
		UNION ALL
	
		SELECT DISTINCT E2_EMISSAO, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_NATUREZ, E2_NOMFOR, 
		E5_DATA, 
		CASE WHEN E2_RATEIO = 'S' THEN CV4_CCD ELSE E2_CCD END AS CC,
		CASE WHEN E2_RATEIO = 'S' THEN (CV4_VALOR/E2_VALOR)*E5_VALOR ELSE E5_VALOR END AS DE_CUSTO1,
		E5_VALOR, 
		CASE WHEN E2_RATEIO = 'S' THEN CV4_XCO ELSE E2_XCO END AS CC,
		CASE WHEN E2_RATEIO = 'S' THEN "SIM" ELSE 'INCLUSAO MANUAL/FOLHA' END AS D1_RATEIO,
		0 AS NF_TOT
		
		FROM %table:SE2% SE2
		
		LEFT JOIN %table:CV4% CV4 ON 
					CV4_FILIAL+CV4_DTSEQ+CV4_SEQUEN = SE2.E2_ARQRAT
					AND CV4.%notdel%
					
		INNER JOIN %table:SE5% SE5 ON
	    E5_FILIAL = E2_FILIAL AND
	    E5_PREFIXO = E2_PREFIXO AND
	    E5_NUMERO = E2_NUM AND
	    E5_PARCELA = E2_PARCELA AND
	    E5_TIPO = E2_TIPO AND
	    E5_CLIFOR = E2_FORNECE AND
	    E5_LOJA =  E2_LOJA AND
		E5_RECPAG = 'P' AND
		NOT E5_MOTBX IN ('CMP','DAC','LIQ') AND
		
						(	(E5_TIPODOC = 'BA' AND E5_NUMCHEQ <> ' ' ) OR
							(E5_TIPODOC = 'BA' AND E2_FATURA <> ' ' AND EXISTS(select 1 FROM  %table:SE2% E2FAT WHERE E2FAT.E2_FILIAL = SE2.E2_FILIAL AND 
																						E2FAT.E2_NUM = SE2.E2_FATURA AND 
																						E2FAT.E2_FATURA = 'NOTFAT' AND 
																						E2FAT.E2_FORNECE = SE2.E2_FORNECE AND 
																						E2FAT.E2_LOJA = SE2.E2_LOJA AND 
																						E2FAT.%notdel% AND 
																						EXISTS(SELECT 1 FROM  %table:SE5% E5FAT WHERE E5FAT.E5_FILIAL = E2FAT.E2_FILIAL AND 
																								E5FAT.E5_PREFIXO = E2FAT.E2_PREFIXO AND
																								E5FAT.E5_NUMERO = E2FAT.E2_NUM AND 
																								E5FAT.E5_PARCELA = E2FAT.E2_PARCELA AND
																								E5FAT.E5_TIPO = E2FAT.E2_TIPO AND 
																								E5FAT.E5_CLIFOR = E2FAT.E2_FORNECE AND 
																								E5FAT.E5_LOJA = E2FAT.E2_LOJA AND 
																								E5FAT.E5_RECPAG = 'P' AND 
																								NOT E5FAT.E5_MOTBX IN ('CMP','DAC','LIQ') AND
																								E5FAT.%notdel%))) OR						
						 
						(E5_TIPODOC = 'BA' AND E5_AGLIMP <> ' ' AND EXISTS(select 1 FROM %table:SE2% E2AG
																				WHERE E2AG.E2_FILIAL = SE2.E2_FILIAL AND 
																				E2AG.E2_NUM = SE5.E5_AGLIMP AND
																				E2AG.E2_CODRET = SE2.E2_CODRET AND
																				E2AG.E2_PREFIXO IN ('AGL','AGP') AND
																				E2AG.%notdel% AND
																				EXISTS(SELECT 1 FROM %table:SE5% E5AG WHERE E5AG.E5_FILIAL = E2AG.E2_FILIAL AND
																										E5AG.E5_PREFIXO = E2AG.E2_PREFIXO AND
																										E5AG.E5_NUMERO  = E2AG.E2_NUM AND
																										E5AG.E5_PARCELA = E2AG.E2_PARCELA AND
																										E5AG.E5_TIPO    = E2AG.E2_TIPO AND
																										E5AG.E5_CLIFOR = E2AG.E2_FORNECE AND
																										E5AG.E5_LOJA    =  E2AG.E2_LOJA AND
																										NOT E5AG.E5_MOTBX IN ('CMP','DAC','LIQ') AND
																										E5AG.E5_RECPAG  = 'P' AND E5AG.%notdel%))) OR
						(NOT E5_TIPODOC IN('BA','MT','CM','DC','JR','CP','M2','C2','D2','J2','V2'))) AND
						
		NOT E5_SITUACA IN('X','E','C') AND
		E5_TIPO != 'PR' AND
		SE5.%notdel% AND
		NOT EXISTS(SELECT 1 FROM %table:SE5% E5  WHERE
					SE5.E5_FILIAL = E5.E5_FILIAL AND
					SE5.E5_CLIFOR = E5.E5_CLIFOR AND
					SE5.E5_PREFIXO = E5.E5_PREFIXO AND
					SE5.E5_LOJA = E5.E5_LOJA AND
					SE5.E5_NUMERO = E5.E5_NUMERO AND
					SE5.E5_TIPO = E5.E5_TIPO AND
					SE5.E5_PARCELA = E5.E5_PARCELA AND
					SE5.E5_SEQ = E5.E5_SEQ AND
					E5.E5_TIPODOC = 'ES' AND 
					E5.E5_KEY = ' ' AND SE5.E5_VALOR = E5.E5_VALOR AND 
					E5.%notdel%)  AND
		
			NOT EXISTS(SELECT 1 FROM %table:SE5% E5  WHERE
					E5.E5_KEY != ' ' AND 
					SE5.E5_KEY = E5.E5_KEY AND
					SE5.E5_FILIAL = E5.E5_FILIAL AND
					SE5.E5_SEQ = E5.E5_SEQ AND
					SE5.E5_VALOR = E5.E5_VALOR AND 
					E5.E5_TIPODOC = 'ES' AND 
					E5.%notdel%)
		
		
		
		WHERE E2_FILIAL =  %xFilial:SE2%
		AND E5_DATA BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
		AND E2_CCD BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06% 
		AND E2_XCO BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% 
		AND E2_FATURA <> 'NOTFAT'
		AND (E2_BAIXA <> '' OR (E2_BAIXA = '' AND E2_TIPO = 'PA'))
		AND SE2.%notdel%		
		AND SE2.E2_TITPAI = ' '
		AND SE2.E2_AGLIMP = ' ' 
		AND NOT SE2.E2_PREFIXO IN ('AGL','AGP')
		AND NOT EXISTS(SELECT 1 FROM %table:SD1% D1 WHERE E2_FILIAL = D1_FILIAL
						AND E2_FORNECE = D1_FORNECE
						AND E2_LOJA = D1_LOJA
						AND E2_NUM = D1_DOC
						AND E2_PREFIXO = D1_SERIE
						AND D1.%notdel%)

						
	) A
		
	ORDER BY E5_DATA,E2_EMISSAO, E2_NUM, E2_TIPO, E2_NATUREZ, E2_NOMFOR, CC, CO	
	
	
EndSQL 

memowrite("C:\Criare\PTNR067_qry.sql",GetLastQuery()[2])
oSecao1:EndQuery()  

oReport:SetMeter((cAlias)->(RecCount()))  

oSecao1:Print()	   

return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+

Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Relatório de Fluxo de Caixa"
local cHelp   := "Gera um relatório de Notas fiscais dentro do período informado no parâmetro."

local oReport
local oSection1

oReport	:= TReport():New('PTNR067',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)

oSection1 := TRSection():New(oReport,"FLUXO DE CAIXA",{"SE2","SDE"})  

//TRCell():New( oSecBem, "campo", "tabela", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"E2_EMISSAO", 			"SE2"	, "DT EMISSAO",             			    		)
TRCell():New(oSection1,"E2_PREFIXO", 			"SE2"	, "PREFIXO",             			    		)
TRCell():New(oSection1,"E2_PARCELA", 			"SE2"	, "PARCELA",             			    		)
TRCell():New(oSection1,"E2_NUM",				"SE2"	, "NUM TITULO",  									)
TRCell():New(oSection1,"E2_TIPO",	 			"SE2"	, "TIPO",											)  	
TRCell():New(oSection1,"E2_NATUREZ", 			"SE2"	, "NATUREZA",   									)						 
TRCell():New(oSection1,"E2_NOMFOR", 			"SE2"	, "FORNECEDOR",									) 
TRCell():New(oSection1,"E5_DATA", 				"SE5"	, "DT BAIXA",										)
TRCell():New(oSection1,"CC",					""		, "CENTRO DE CUSTO",								)
TRCell():New(oSection1,"DE_CUSTO1",				""	, "VALOR DO RATEIO",		 "@E 999,999,999,999.999999")
TRCell():New(oSection1,"E5_VALOR",				""	, "VALOR LIQ. BX",		 	 "@E 999,999,999,999.999999")
TRCell():New(oSection1,"CO",					""		, "CONTA ORÇAMENTARIA",							)
TRCell():New(oSection1,"D1_RATEIO",				"SD1"	, "RATEIO",						 				)   


Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! Função para a criação das perguntas, caso elas não existam.                                   !
//+-----------------------------------------------------------------------------------------------+

Static Function criaSX1(cPerg)

putSx1(cPerg, '01', 'Dt Baixa De?'   ,'', '', 'mv_ch1', 'D', 08, 0, 0, 'G', 			   '', ''   , '', '', 'mv_par01',,,,,,,,,,,,,,,,,{"Dt inicial a ser considerada."},{"Dt inicial a ser considerada."},{"Dt inicial a ser considerada."})
putSx1(cPerg, '02', 'Dt Baixa Ate?'  ,'', '', 'mv_ch2', 'D', 08, 0, 0, 'G', 			   '', ''   , '', '', 'mv_par02',,,,,,,,,,,,,,,,,{"Dt final a ser considerada."},{"Dt final a ser considerada."},{"Dt final a ser considerada."})
putSx1(cPerg, '03', 'Da Conta'       ,'', '', 'mv_ch3', 'C', 12, 0, 0, 'G', 'ExistCpo("AK5")', 'AK5', '', '', 'mv_par03',,,,,,,,,,,,,,,,,{"Conta orc. inicial a ser considerada."},{"Conta orc. inicial a ser considerada."},{"Conta orc. inicial a ser considerada."})
putSx1(cPerg, '04', 'Ate Conta?'     ,'', '', 'mv_ch4', 'C', 12, 0, 0, 'G', 'ExistCpo("AK5")', 'AK5', '', '', 'mv_par04',,,,,,,,,,,,,,,,,{"Conta orc. final a ser considerada."},{"Conta orc. final a ser considerada."},{"Conta orc. final a ser considerada."})
putSx1(cPerg, '05', 'Do C. Custo?'   ,'', '', 'mv_ch5', 'C', 20, 0, 0, 'G', 'ExistCpo("CTT")', 'CTT', '', '', 'mv_par05',,,,,,,,,,,,,,,,,{"C. custo inicial a ser considerado."},{"C. custo inicial a ser considerado."},{"C. custo inicial a ser considerado."})
putSx1(cPerg, '06', 'Ate C. Custo?'  ,'', '', 'mv_ch6', 'C', 20, 0, 0, 'G', 'ExistCpo("CTT")', 'CTT', '', '', 'mv_par06',,,,,,,,,,,,,,,,,{"C. custo final a ser considerado."},{"C. custo final a ser considerado."},{"C. custo final a ser considerado."})

Return    
