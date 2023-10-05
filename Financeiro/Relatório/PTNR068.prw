#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Programa : PTNR068  | Autor : Vinicius Figueiredo  | Data : 02/01/2018    ±±
±±                     |      Criare Consulting     |                      ±±   
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Desc. : Relatório de contas a pagar									   ±±
±±                                                      				   ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±± Uso  : Concessionária Porto Novo / Módulo Financeiro                    ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/ 
User Function PTNR068()

Local oReport                
Local cPerg  := 'PTNR068'

Private cAlias := getNextAlias()                                             

Private oReport
Private oSection1       

CriaSx1(cPerg)
Pergunte(cPerg, .F.)

oReport := reportDef(cAlias,cPerg)
oReport:printDialog()                                               

Return
  
          
//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados no relatório.                                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport,cAlias)
                 
Local oSecao1 := oReport:Section(1)

Private cNomFor := ""
Private cDtCtb := ""
Private cNum := ""
Private cParc := ""
Private cTipo := ""
Private cEmiss := ""
Private cVencRea := ""
Private nVLrOri := ""
Private nVlrVen := ""
Private nVlrAV := ""
Private cCC := ""
Private cDesCC := ""
Private cCO := ""
Private cDesCO := ""
Private aV := {}

oSecao1:BeginQuery()

BeginSQL Alias cAlias

	Column E2_EMISSAO AS DATE
	Column E2_VENCREA AS DATE
	Column E2_EMIS1 AS DATE
	
	SELECT 	E2_FILIAL, 
			E2_NOMFOR,  
			E2_EMIS1,  
			E2_TIPO, 
			E2_EMISSAO, 
			E2_VENCREA, 
			E2_CCD CC, 
			E2_XCO CO, 
			E2_VALOR CUSTO , 
			E2_VALOR VLRORI, 
			E2_SALDO VLRSAL,
			E2_ARQRAT, 
			E2_TITPAI, 
			E2_PREFIXO,  
		   	E2_NUM, 
		   	E2_PARCELA, 
		   	E2_FORNECE, 
		   	E2_FATURA, 
		   	E2_LOJA, 
		   	E2_VALOR NF_TOT
	
	 		FROM %table:SE2% SE2
	
	WHERE
			 E2_FILIAL =  %xFilial:SE2%
			AND E2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
			AND E2_VENCREA BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% 
			AND E2_EMIS1 BETWEEN %Exp:MV_PAR13% AND %Exp:MV_PAR14% 
			AND (E2_XCO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06% OR E2_XCO = ' ')
			AND (E2_CCD BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08% OR E2_CCD = ' ')			
			AND E2_FORNECE+E2_LOJA BETWEEN %Exp:MV_PAR09+MV_PAR10% AND %Exp:MV_PAR11+MV_PAR12% 
			AND E2_SALDO > 0
			AND SE2.%notdel%					
			//AND E2_FORNECE = 'INPS'						
			//AND E2_NUM = '000005667'						
			//AND E2_FATURA <> 'NOTFAT'
			//AND SE2.E2_TITPAI = ' '
			AND SE2.E2_AGLIMP = ' ' 
			AND NOT SE2.E2_TIPO IN ('PA','PR')  
			
			//AND NOT SE2.E2_PREFIXO IN ('AGL','AGP')
																								 		
	ORDER BY E2_FILIAL, E2_NOMFOR, E2_TIPO, E2_EMISSAO, E2_VENCREA, CC, CO
			
EndSQL 

memowrite("C:\Criare\PTNR068_qry.sql",GetLastQuery()[2])
oSecao1:EndQuery()  

oReport:SetMeter((cAlias)->(RecCount()))  

aV := {}

While (cAlias)->(!EoF())

	cNum := (cAlias)->E2_NUM
	cFornece := (cAlias)->E2_FORNECE
	cDtCtb := (cAlias)->E2_EMIS1
	cLoja := (cAlias)->E2_LOJA
	cNomFor := (cAlias)->E2_NOMFOR
	cParc := (cAlias)->E2_PARCELA
	cTipo := (cAlias)->E2_TIPO
	cEmiss := (cAlias)->E2_EMISSAO
	cVencRea := (cAlias)->E2_VENCREA
	cPref := (cAlias)->E2_PREFIXO
	cCV4key := (cAlias)->E2_ARQRAT	//	CV4_FILIAL+CV4_DTSEQ+CV4_SEQUEN = SE2.E2_ARQRAT

	lAchou := .F.	                          
	If (Empty((cAlias)->E2_FATURA) .AND. Empty(cCV4Key)) .OR. (AllTrim((cAlias)->E2_PREFIXO) $ 'AGL|AGP')

		//If Empty((cAlias)->E2_TITPAI)
		If AllTrim(cTIPO) == "NF"  .AND. !(AllTrim((cAlias)->E2_PREFIXO) $ 'AGL|AGP')								
			lAchou := RatD1(cFornece,cLoja,cNum,cPref)
			
		ElseIf AllTrim(cTIPO) <> "NF" .AND. !Empty((cAlias)->E2_TITPAI) .AND. !(AllTrim((cAlias)->E2_PREFIXO) $ 'AGL|AGP')
			lAchou := RatD1(SUBSTR((cAlias)->E2_TITPAI,19,6), SUBSTR((cAlias)->E2_TITPAI,25,2), cNum, cPref)                									
			
		Endif

		If !lAchou			
			nVLrOri := (cAlias)->VLRORI
			nVlrVen := 0
			nVlrAV  := 0
		
			If (cAlias)->E2_VENCREA < dDatabase	
				nVlrVen += (cAlias)->VLRSAL
			ElseIf (cAlias)->E2_VENCREA >= dDatabase
				nVlrAV += (cAlias)->VLRSAL
			Endif	
			
			cCC := AllTrim((cAlias)->CC)
			cCO := AllTrim((cAlias)->CO)				
			cDesCC := ""
			cDesCO := ""
			
			aAdd(aV,{ cNum,cFornece,cLoja,cNomFor,cTipo,cEmiss,cVencRea, nVLrOri,	nVlrVen, nVlrAV, cCC,cDesCC,cCO,cDesCO,cParc,cDtCtb})

		Endif
						
	ElseIf !Empty((cAlias)->E2_FATURA) .AND. AllTRIM((cAlias)->E2_FATURA) == "NOTFAT"
		cAlias3 := GetNextAlias()
				
		BeginSQL Alias cAlias3
		
			Column E2_EMISSAO AS DATE
			Column E2_VENCREA AS DATE
			Column E2_EMIS1 AS DATE
			
			SELECT 	E2_FILIAL, 
					E2_NOMFOR,  
					E2_EMIS1,
					E2_TIPO, 
					E2_TITPAI,
					E2_EMISSAO, 
					E2_VENCREA, 
					E2_CCD CC, 
					E2_XCO CO, 
					E2_VALOR CUSTO , 
					E2_VALOR VLRORI, 
					E2_SALDO VLRSAL,
					E2_PREFIXO,  
				   	E2_NUM, 
				   	E2_PARCELA, 
				   	E2_FORNECE, 
				   	E2_FATURA, 
				   	E2_LOJA, 
				   	E2_VALOR NF_TOT
			
			 		FROM %table:SE2% SE2
			
			WHERE
					 E2_FILIAL =  %xFilial:SE2%
					AND E2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
					AND E2_VENCREA BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% 
					AND (E2_XCO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06% OR E2_XCO = ' ')
					AND (E2_CCD BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08% OR E2_CCD = ' ')
					AND E2_SALDO = 0
					
					AND E2_FORNECE+E2_LOJA BETWEEN %Exp:MV_PAR09+MV_PAR10% AND %Exp:MV_PAR11+MV_PAR12% 
					AND SE2.%notdel%		
					
					AND E2_FATURA = %Exp:(cAlias)->E2_NUM%
					/*
					AND SE2.E2_TITPAI = ' '                   
					AND SE2.E2_AGLIMP = ' ' 
					AND NOT SE2.E2_TIPO IN ('PA')
					AND NOT SE2.E2_PREFIXO IN ('AGL','AGP')
					*/
		EndSql		

		memowrite("C:\Criare\PTNR068_qry_FATURA.sql",GetLastQuery()[2])
	
		lAchou := .F.	   
		nL := 0
		While (cAlias3)->(!EoF())
		
			cNum := (cAlias3)->E2_NUM
			cParc := (cAlias3)->E2_PARCELA
			cFornece := (cAlias3)->E2_FORNECE
			cLoja := (cAlias3)->E2_LOJA
			cPref := (cAlias3)->E2_PREFIXO
			cDtCtb	:= (cAlias3)->E2_EMIS1

			cTipo := (cAlias3)->E2_TIPO

			If AllTrim(cTipo) == "NF"								
				lAchou := RatD1(cFornece,cLoja,cNum,cPref)

			ElseIf AllTrim(cTIPO) <> "NF" .AND. !Empty((cAlias3)->E2_TITPAI)											
				lAchou := RatD1(SUBSTR((cAlias3)->E2_TITPAI,19,6), SUBSTR((cAlias3)->E2_TITPAI,25,6), cNum, cPref)                						
	
			Endif                                         
			
			If !lAchou			
				nVLrOri := (cAlias3)->VLRORI //(cAlias)->VLRORI
				nVlrVen := 0
				nVlrAV  := 0
				nProp := nVlrOri*((cAlias)->VLRSAL/(cAlias)->VLRORI)			
				
				If (cAlias)->E2_VENCREA < dDatabase	
					nVlrVen += nProp //(cAlias)->VLRSAL
				ElseIf (cAlias)->E2_VENCREA >= dDatabase
					nVlrAV += nProp //(cAlias)->VLRSAL
				Endif	
				
				cCC := AllTrim((cAlias3)->CC)
				cCO := AllTrim((cAlias3)->CO)			
				cDesCC := "" 
				cDesCO := "" 
				
				aAdd(aV,{ cNum,cFornece,cLoja,cNomFor,cTipo,cEmiss,cVencRea, nVLrOri,	nVlrVen, nVlrAV, cCC,cDesCC,cCO,cDesCO,cParc,cDtCtb})

			Endif
		
			oReport:IncMeter()
	        		
			(cAlias3)->(DbSkip())
		EndDo
		(cAlias3)->(DbCloseArea())                                     

	ElseIf !Empty(cCV4Key)

		GetCV4(cCV4Key)	
			
    Endif  
        
	/*
	cAlias4 := GetNextAlias()
			
	BeginSQL Alias cAlias4
	
		Column E2_EMISSAO AS DATE
		Column E2_VENCREA AS DATE
		Column E2_EMIS1 AS DATE
		
		SELECT 	E2_FILIAL, 
				E2_NOMFOR,  
				E2_EMIS1,
				E2_TIPO, 
				E2_EMISSAO, 
				E2_VENCREA, 
				E2_CCD CC, 
				E2_XCO CO, 
				E2_VALOR CUSTO , 
				E2_VALOR VLRORI, 
				E2_SALDO VLRSAL,
				E2_PREFIXO,  
			   	E2_NUM, 
			   	E2_FORNECE, 
			   	E2_FATURA, 
			   	E2_LOJA, 
			   	E2_VALOR NF_TOT
		
		 		FROM %table:SE2% SE2
		
		WHERE
				 E2_FILIAL =  %xFilial:SE2%
				
				//AND E2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
				//AND E2_VENCREA BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% 
				//AND (E2_XCO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06% OR E2_XCO = ' ')
				//AND (E2_CCD BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08% OR E2_CCD = ' ')				
				//AND E2_SALDO = 0
				//AND E2_TIPO = 'NF'				
				//AND E2_FORNECE+E2_LOJA BETWEEN %Exp:MV_PAR09+MV_PAR10% AND %Exp:MV_PAR11+MV_PAR12% 
				AND SE2.%notdel%		
				
				AND ( 		SUBSTRING(E2_TITPAI,1,3) = %Exp:cPref%
						AND SUBSTRING(E2_TITPAI,4,9) = %Exp:cNum%
						AND SUBSTRING(E2_TITPAI,19,6) = %Exp:cFornece%
						AND SUBSTRING(E2_TITPAI,25,6)  = %Exp:cLoja%)
	
	EndSql		
	
	lAchou := .F.	   
	nL := 0
	While (cAlias4)->(!EoF())
	
		cNum := (cAlias4)->E2_NUM
		cFornece := (cAlias4)->E2_FORNECE
		cLoja := (cAlias4)->E2_LOJA
		cPref := (cAlias4)->E2_PREFIXO
		cDtCtb	:= (cAlias4)->E2_EMIS1
				
		lAchou := .F. //RatD1(cFornece,cLoja,cNum,cPref)
	
		If !lAchou			
			
			nVLrOri := (cAlias4)->VLRORI //(cAlias)->VLRORI
			nVlrVen := 0
			nVlrAV  := 0
			nProp := nVlrOri*((cAlias)->VLRSAL/(cAlias)->VLRORI)			
			
			If (cAlias)->E2_VENCREA < dDatabase	
				nVlrVen += nProp //(cAlias)->VLRSAL
			ElseIf (cAlias)->E2_VENCREA >= dDatabase
				nVlrAV += nProp //(cAlias)->VLRSAL
			Endif	
			
			cCC := AllTrim((cAlias4)->CC)
			cCO := AllTrim((cAlias4)->CO)	
	
			cDesCC := AllTrim(Posicione("CTT",1,xFilial("CTT")+cCC,"CTT_DESC01"))
			cDesCO := AllTrim(Posicione("AK5",1,xFilial("AK5")+cCO,"AK5_DESCRI"))
			
			aAdd(aV,{ cNum,cFornece,cLoja,cNomFor,cTipo,cEmiss,cVencRea, nVLrOri,	nVlrVen, nVlrAV, cCC,cDesCC,cCO,cDesCO,cDtCtb})
		
		Endif
	
		oReport:IncMeter()
	        		
		(cAlias4)->(DbSkip())
	EndDo
	(cAlias4)->(DbCloseArea())                                         
	*/
	        
	oReport:IncMeter()
	
	(cAlias)->(DbSkip())
	
EndDo

If Len(aV) > 0

	oSection1:Init()
	
	For n_x := 1 to Len(aV)
				
		cNum := aV[n_x][1]

		cNomFor := aV[n_x][4]
		cTipo := aV[n_x][5]	

		cEmiss := aV[n_x][6]
		cVencRea := aV[n_x][7]		

		nVLrOri := aV[n_x][8]
		nVlrVen := aV[n_x][9]
		nVlrAV  := aV[n_x][10]	

		cCC := aV[n_x][11]
		If !Empty(cCC)
			aV[n_x][12] := AllTrim(Posicione("CTT",1,xFilial("CTT")+cCC,"CTT_DESC01"))
		Endif
		cDesCC := aV[n_x][12] 

		cCO := aV[n_x][13]
		If !Empty(cCO)
			aV[n_x][14] := AllTrim(Posicione("AK5",1,xFilial("AK5")+cCO,"AK5_DESCRI"))				                                                                           
		Endif
		cDesCO := aV[n_x][14] 

		cParc := aV[n_x][15]
		cDtCtb := aV[n_x][16]

		
		oReport:IncMeter()
		oSection1:PrintLine()
	
	next n_x
	
	oReport:FatLine()	
	oReport:Section(1):Finish()
	
Else
	Alert("Não há dados")
Endif

return



Static Function GetCV4(cXkey)
cAlias6 := GetNextAlias()
		
BeginSQL Alias cAlias6

	SELECT DISTINCT 
		CV4_CCD AS CC,
		CV4_XCO AS CO,	
		CV4_PERCEN AS PERC 
		
	FROM %table:CV4% CV4
	
	WHERE CV4_FILIAL+CV4_DTSEQ+CV4_SEQUEN = %Exp:cXKey%
				AND CV4.%notdel%		
		
EndSQL              

While (cAlias6)->(!EoF())

	lAchou := .F. //RatD1(cFornece,cLoja,cNum,cPref)

	If !lAchou			
		
		nVLrOri := (cAlias)->VLRORI
		nVlrVen := 0
		nVlrAV  := 0
		nProp := (cAlias)->VLRSAL*((cAlias6)->PERC/100)
		
		If (cAlias)->E2_VENCREA < dDatabase	
			nVlrVen += nProp 
		ElseIf (cAlias)->E2_VENCREA >= dDatabase
			nVlrAV += nProp 
		Endif	
		
		cCC := AllTrim((cAlias6)->CC)
		cCO := AllTrim((cAlias6)->CO)	
		cDesCC := "" 
		cDesCO := "" 
		
		aAdd(aV,{ cNum,cFornece,cLoja,cNomFor,cTipo,cEmiss,cVencRea, nVLrOri,	nVlrVen, nVlrAV, cCC,cDesCC,cCO,cDesCO,cParc,cDtCtb})
	
	Endif

	oReport:IncMeter()
        		
	(cAlias6)->(DbSkip())
EndDo
(cAlias6)->(DbCloseArea())  

Return



Static Function RatD1(cForX,cLojX,cNumX,cPreX)

lAchou := .F.
cAlias2 := getnextalias()		
aTmp := {}

BeginSQL Alias cAlias2

	SELECT 	DISTINCT D1_TOTAL, D1_FILIAL, D1_RATEIO, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_TIPO , D1_VALIPI , D1_VALINS,  D1_ITEM,
			CASE WHEN D1_RATEIO = '1' THEN DE_CC ELSE D1_CC END AS CC,
			CASE WHEN D1_RATEIO = '1' THEN DE_CUSTO1 ELSE D1_TOTAL END AS VALOR,
			CASE WHEN D1_RATEIO = '1' THEN DE_PERC ELSE 100 END AS PERCE,
			CASE WHEN D1_RATEIO = '1' THEN DE_XCO ELSE D1_XCO END AS CO			
			
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
		AND (D1_XCO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%  OR D1_XCO = ' ')
		AND (D1_CC BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08%  OR D1_CC = ' ')		
	
		AND E2_FORNECE = %Exp:cForX%
		AND E2_LOJA = %Exp:cLojX%
		AND E2_NUM = %Exp:cNumX%
		AND E2_PREFIXO = %Exp:cPreX%
		
	LEFT JOIN %table:SDE% SDE
			ON D1_FILIAL = DE_FILIAL
			AND D1_FORNECE = DE_FORNECE
			AND D1_LOJA = DE_LOJA
			AND D1_DOC = DE_DOC
			AND D1_SERIE = DE_SERIE
			AND D1_ITEM = DE_ITEMNF             	
			AND DE_XCO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06% 
			AND DE_CC BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08% 		
			AND SDE.%notdel% 
EndSQL                               

lRat := .F.
While (cAlias2)->(!EoF())

	lAchou := .T.
	cD1Key := (cAlias2)->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_TIPO)

    If (cAlias2)->D1_RATEIO == "1"
		memowrite("C:\Criare\PTNR068_qry2.sql",GetLastQuery()[2])        
		nVlX := (cAlias2)->VALOR
		lRat := .T.
	Else
		nVlX := (cAlias2)->VALOR+(cAlias2)->D1_VALIPI		
	Endif    
	
	cCC := AllTrim((cAlias2)->CC)
	cCO := AllTrim((cAlias2)->CO)	

	nPY := aScan(aTmp,{|x| x[1]+x[2] == cCC+cCO })    
	If nPY == 0		
		aAdd(aTmp,{cCC,cCO,nVlX,(cAlias2)->D1_VALINS,(cAlias2)->PERCE} )
	Else
		aTmp[nPY][3] += nVlX
		aTmp[nPY][4] += (cAlias2)->D1_VALINS
	Endif		
			
	(cAlias2)->(DbSkip())
EndDo
(cAlias2)->(DbCloseArea())                                     

If Len(aTmp) > 0

	nTot := 0
	dbSelectArea("SF1")
	dbSetOrder(1)
	If DbSeek(cD1Key) //xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_TIPO)
		nTot := SF1->F1_VALMERC+SF1->F1_VALIPI //SF1->F1_VALBRUT 
	    If AllTrim((cAlias)->E2_TIPO) == "INS" 
	    	If lRat
				nTot := SF1->F1_INSS  //(cAlias)->VLRSAL*(aTmp[n_z][4]/nTot)
			Endif
	    Endif	
    Endif

	For n_z := 1 to Len(aTmp)

		nVLrOri := (cAlias)->VLRORI 
		nVlrVen := 0
		nVlrAV  := 0   
		//nProp   := (cAlias)->VLRSAL*((cAlias2)->VALOR/(cAlias)->VLRORI) //
		nProp   := (cAlias)->VLRSAL*(aTmp[n_z][3]/nTot)      //((cAlias2)->VALOR/(cAlias2)->D1_TOTAL)

	    If AllTrim((cAlias)->E2_TIPO) == "INS" 
	    	If !lRat
				nProp := aTmp[n_z][4]
			Else			
				nProp := aTmp[n_z][4]*(aTmp[n_z][5]/100)
			Endif
	    Endif
		
		If (cAlias)->E2_VENCREA < dDatabase	
			nVlrVen += nProp
		ElseIf (cAlias)->E2_VENCREA >= dDatabase
			nVlrAV += nProp
		Endif	
		
		cCC := aTmp[n_z][1] //AllTrim((cAlias2)->CC)
		cCO := aTmp[n_z][2] //AllTrim((cAlias2)->CO)		
		cDesCC := "" 
		cDesCO := "" 
		
		aAdd(aV,{ cNum,cFornece,cLoja,cNomFor,cTipo,cEmiss,cVencRea, nVLrOri, nVlrVen, nVlrAV, cCC,cDesCC,cCO,cDesCO,cParc,cDtCtb})
		
	next n_z
Endif

Return lAchou


//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Relatório de Contas a pagar"
local cHelp   := "Gera um relatório de títulos a pagar vencidos dentro do período informado no parâmetro."

oReport	:= TReport():New('PTNR068',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)

oSection1 := TRSection():New(oReport,"CONTAS A PAGAR",{"SE2","SDE"})  

//TRCell():New( oSecBem, "campo", "tabela", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection1,"E2_NOMFOR", 			"SE2"	, "FORNECEDOR", "" 	, 30  ,  ,{|| cNomFor }	) 
TRCell():New(oSection1,"E2_EMIS1", 			"SE2"	, "DT CTB", "" 	, 12  ,  ,{|| cDtCtb }	) 
TRCell():New(oSection1,"E2_NUM",	 			"SE2"	, "NUMERO"	, "" 	, 9  ,  ,{|| cNum }	)  	
TRCell():New(oSection1,"E2_PARCELA", 			"SE2"	, "PARCELA"	, "" 	, 3  ,  ,{|| cParc }	)  	
TRCell():New(oSection1,"E2_TIPO",	 			"SE2"	, "TIPO"	, "" 	, 3  ,  ,{|| cTipo }	)  	
TRCell():New(oSection1,"E2_EMISSAO", 			"SE2"	, "DT EMISSAO", "" 	, 12 ,  ,{|| cEmiss }	)
TRCell():New(oSection1,"E2_VENCREA", 			"SE2"	, "DT VENCREA", "" 	, 12  ,  ,{|| cVencRea })
TRCell():New(oSection1,"VLRORI",				""		, "VALOR ORIGINAL", "@E 999,999,999,999.99999" , 27 ,  ,{|| nVLrOri })
TRCell():New(oSection1,"VLRVEN",				""		, "VALOR VENCIDO", "@E 999,999,999,999.99999" , 27 ,  ,{|| nVlrVen })
TRCell():New(oSection1,"VLRAV"	,				""		, "VALOR A VENCER", "@E 999,999,999,999.99999" , 27 ,  ,{|| nVlrAV  })
TRCell():New(oSection1,"CC",					""		, "CC"		, "" 	, 15  ,  ,{|| cCC }								)
TRCell():New(oSection1,"DESCC",					""		, "DESC CC"	, "" 	, 30  ,  ,{|| cDesCC }							)
TRCell():New(oSection1,"CO",					""		, "CO"		, "" 	, 15  ,  ,{|| cCO }								)
TRCell():New(oSection1,"DESCO",					""		, "DESC CO"	, "" 	, 30  ,  ,{|| cDesCO }							)    

oBreak := TRBreak():New(oSection1,{ || oSection1:Cell('E2_NOMFOR'):uPrint },'Total Fornecedor:',.F.)  

//TRFunction():New(oSection1:Cell('VLRORI'),, 'SUM',oBreak ,,,,.F.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell('VLRVEN'),, 'SUM',oBreak ,,,,.F.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell('VLRAV') ,, 'SUM',oBreak ,,,,.F.,.F.,.F., oSection1)

oBreak:OnPrintTotal( { || oReport:SkipLine(2)} )	

oBreak2 := TRBreak():New(oSection1,{ || (cAlias)->E2_FILIAL    },'Total Filial:',.T.)  

oBreak2:OnPrintTotal( { || oReport:SkipLine(1)} )

//TRFunction():New(oSection1:Cell('VLRORI'),, 'SUM',oBreak2 ,,,,.F.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell('VLRVEN'),, 'SUM',oBreak2 ,,,,.F.,.F.,.F., oSection1)
TRFunction():New(oSection1:Cell('VLRAV'),, 'SUM',oBreak2 ,,,,.F.,.F.,.F., oSection1)

Return(oReport)


Static Function criaSX1(cPerg)

u_putSx1(cPerg, '01', 'Emissao De?'    ,'', '', 'mv_ch1', 'D', 08, 0, 0, 'G', '', ''   , '', '', 'mv_par01',,,,,,,,,,,,,,,,,{"Dt inicial a ser considerada."},{"Dt inicial a ser considerada."},{"Dt inicial a ser considerada."})
u_putSx1(cPerg, '02', 'Emissao Ate?'   ,'', '', 'mv_ch2', 'D', 08, 0, 0, 'G', '', ''   , '', '', 'mv_par02',,,,,,,,,,,,,,,,,{"Dt final a ser considerada."},{"Dt final a ser considerada."},{"Dt final a ser considerada."})
u_putSx1(cPerg, '03', 'Vencto De?'     ,'', '', 'mv_ch3', 'D', 08, 0, 0, 'G',  '', ''   , '', '', 'mv_par03',,,,,,,,,,,,,,,,,{"Dt vencto inicial a ser considerada."},{"Dt inicial a ser considerada."},{"Dt inicial a ser considerada."})
u_putSx1(cPerg, '04', 'Vencto Ate?'    ,'', '', 'mv_ch4', 'D', 08, 0, 0, 'G',  '', ''   , '', '', 'mv_par04',,,,,,,,,,,,,,,,,{"Dt vencto final a ser considerada."},{"Dt final a ser considerada."},{"Dt final a ser considerada."})

u_putSx1(cPerg, '05', 'Da Conta'       ,'', '', 'mv_ch5', 'C', 12, 0, 0, 'G', '', 'AK5', '', '', 'mv_par05',,,,,,,,,,,,,,,,,{"Conta orc. inicial a ser considerada."},{"Conta orc. inicial a ser considerada."},{"Conta orc. inicial a ser considerada."})
u_putSx1(cPerg, '06', 'Ate Conta?'     ,'', '', 'mv_ch6', 'C', 12, 0, 0, 'G', '', 'AK5', '', '', 'mv_par06',,,,,,,,,,,,,,,,,{"Conta orc. final a ser considerada."},{"Conta orc. final a ser considerada."},{"Conta orc. final a ser considerada."})
u_putSx1(cPerg, '07', 'Do C. Custo?'   ,'', '', 'mv_ch7', 'C', 20, 0, 0, 'G', '', 'CTT', '', '', 'mv_par07',,,,,,,,,,,,,,,,,{"C. custo inicial a ser considerado."},{"C. custo inicial a ser considerado."},{"C. custo inicial a ser considerado."})
u_putSx1(cPerg, '08', 'Ate C. Custo?'  ,'', '', 'mv_ch8', 'C', 20, 0, 0, 'G', '', 'CTT', '', '', 'mv_par08',,,,,,,,,,,,,,,,,{"C. custo final a ser considerado."},{"C. custo final a ser considerado."},{"C. custo final a ser considerado."})

u_putSx1(cPerg, '09', 'Fornecedor de'  ,'', '', 'mv_ch9', 'C', TamSX3("A2_COD")[1], 0, 0, 'G', '', 'SA2', '', '', 'mv_par09',,,,,,,,,,,,,,,,,{"Fornecedor inicial a ser considerada."},{"Conta orc. inicial a ser considerada."},{"Conta orc. inicial a ser considerada."})
u_putSx1(cPerg, '10', 'Loja de'        ,'', '', 'mv_cha', 'C', TamSX3("A2_LOJA")[1], 0, 0, 'G', '', '', '', '', 'mv_par10',,,,,,,,,,,,,,,,,{"Loja fornecedor inicial a ser considerada."},{"Conta orc. final a ser considerada."},{"Conta orc. final a ser considerada."})
u_putSx1(cPerg, '11', 'Fornecedor ate' ,'', '', 'mv_chb', 'C', TamSX3("A2_COD")[1], 0, 0, 'G', '', 'SA2', '', '', 'mv_par11',,,,,,,,,,,,,,,,,{"Fornecedor final a ser considerado."},{"C. custo inicial a ser considerado."},{"C. custo inicial a ser considerado."})
u_putSx1(cPerg, '12', 'Loja ate'  	   ,'', '', 'mv_chc', 'C', TamSX3("A2_LOJA")[1], 0, 0, 'G', '', '', '', '', 'mv_par12',,,,,,,,,,,,,,,,,{"Loja fornecedor final a ser considerado."},{"C. custo final a ser considerado."},{"C. custo final a ser considerado."})

u_putSx1(cPerg, '13', 'Contab De?'     ,'', '', 'mv_chd', 'D', 08, 0, 0, 'G',  '', ''   , '', '', 'mv_par13',,,,,,,,,,,,,,,,,{"Dt contab inicial a ser considerada."},{"Dt inicial a ser considerada."},{"Dt inicial a ser considerada."})
u_putSx1(cPerg, '14', 'Contab Ate?'    ,'', '', 'mv_che', 'D', 08, 0, 0, 'G',  '', ''   , '', '', 'mv_par14',,,,,,,,,,,,,,,,,{"Dt contab final a ser considerada."},{"Dt final a ser considerada."},{"Dt final a ser considerada."})

Return    


/*
Static Function GetCAU(cForX,cLojX,cNumX,cPreX)

lAchou := .F.
cAlias4 := GetNextAlias()
		
BeginSQL Alias cAlias4

	Column E2_EMISSAO AS DATE
	Column E2_VENCREA AS DATE
	
	SELECT 	E2_FILIAL, 
			E2_NOMFOR,  
			E2_TIPO, 
			E2_EMISSAO, 
			E2_VENCREA, 
			E2_CCD CC, 
			E2_XCO CO, 
			E2_VALOR CUSTO , 
			E2_VALOR VLRORI, 
			E2_SALDO VLRSAL,
			E2_PREFIXO,  
		   	E2_NUM, 
		   	E2_FORNECE, 
		   	E2_FATURA, 
		   	E2_LOJA, 
		   	E2_VALOR NF_TOT
	
	 		FROM %table:SE2% SE2
	
	WHERE
			 E2_FILIAL =  %xFilial:SE2%
			AND E2_EMISSAO BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02% 
			AND E2_VENCREA BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04% 
			AND (E2_XCO BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06% OR E2_XCO = ' ')
			AND (E2_CCD BETWEEN %Exp:MV_PAR07% AND %Exp:MV_PAR08% OR E2_CCD = ' ')
			//AND E2_SALDO = 0
			//AND E2_TIPO = 'NF'
			
			AND E2_FORNECE+E2_LOJA BETWEEN %Exp:MV_PAR09+MV_PAR10% AND %Exp:MV_PAR11+MV_PAR12% 
			AND SE2.%notdel%		
			
			AND ( 		SUBSTRING(E2_TITPAI,1,3) = %Exp:cPreX%
					AND SUBSTRING(E2_TITPAI,4,9) = %Exp:cNumX%
					AND SUBSTRING(E2_TITPAI,19,6) = %Exp:cForX%
					AND SUBSTRING(E2_TITPAI,25,6)  = %Exp:cLojX%)

EndSql		

lAchou := .F.	   
nL := 0
While (cAlias4)->(!EoF())

	cNum := (cAlias4)->E2_NUM
	cFornece := (cAlias4)->E2_FORNECE
	cLoja := (cAlias4)->E2_LOJA
	cPref := (cAlias4)->E2_PREFIXO
			
	lAchou := .F. //RatD1(cFornece,cLoja,cNum,cPref)

	If !lAchou			
		
		nVLrOri := (cAlias4)->VLRORI //(cAlias)->VLRORI
		nVlrVen := 0
		nVlrAV  := 0
		nProp := nVlrOri*((cAlias)->VLRSAL/(cAlias)->VLRORI)			
		
		If (cAlias)->E2_VENCREA < dDatabase	
			nVlrVen += nProp //(cAlias)->VLRSAL
		ElseIf (cAlias)->E2_VENCREA >= dDatabase
			nVlrAV += nProp //(cAlias)->VLRSAL
		Endif	
		
		cCC := AllTrim((cAlias4)->CC)
		cCO := AllTrim((cAlias4)->CO)	

		cDesCC := AllTrim(Posicione("CTT",1,xFilial("CTT")+cCC,"CTT_DESC01"))
		cDesCO := AllTrim(Posicione("AK5",1,xFilial("AK5")+cCO,"AK5_DESCRI"))
		
		aAdd(aV,{ cNum,cFornece,cLoja,cNomFor,cTipo,cEmiss,cVencRea, nVLrOri,	nVlrVen, nVlrAV, cCC,cDesCC,cCO,cDesCO})
	
	Endif

	oReport:IncMeter()
        		
	(cAlias4)->(DbSkip())
EndDo
(cAlias4)->(DbCloseArea())                                     

Return lAchou
*/
