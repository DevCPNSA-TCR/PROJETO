#Include "Protheus.ch"
#Include "TopConn.ch"
#Define cEnt	Chr(13) + Chr(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PTNR008  ºAutor  ³Vinicius Figueiredo    º Data ³ 17/02/2014   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relação de pedidos aprovados por Autorizante.                 º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß                  
*/

User Function PTNR008()

Local cQuery	:= ""
Local oReport
Private cPerg 	:= Padr("PTNR008",10)

Private cTitulo   := "Pedidos aprovados por Autorizante"
Private oPrn        := NiL
Private oFont1  	:= NIL
Private oFont2  	:= NIL
Private oFont3  	:= NIL
Private oFont4  	:= NIL
Private oFont5  	:= NIL
Private oFont6  	:= NIL
Private aV 
Private oDlg2   := NiL
Private lP := .F.
Private cThis := ""
Private nPag := 1
Private cDtVl := ""
Private aList := {}
Private cThis := ""     
Private cPerDe := ""
Private cPerAt := ""

Define FONT oFont1 NAME "ARIAL" 		SIZE 0,16 OF oPrn BOLD // 
Define FONT oFont2 NAME "ARIAL" 		SIZE 0,12 OF oPrn BOLD //Forn
Define FONT oFont3 NAME "ARIAL" 		SIZE 0,18 OF oPrn BOLD //Titulo
Define FONT oFont4 NAME "ARIAL" 		SIZE 0,10 OF oPrn BOLD
Define FONT oFont5 NAME "ARIAL" 		SIZE 0,10 OF oPrn
Define FONT oFont6 NAME "Courier New"	SIZE 0,13	BOLD
Define FONT oFont7 NAME "ARIAL" 		SIZE 0,07 OF oPrn  
Define FONT oFont8 NAME "ARIAL" 		SIZE 0,09 OF oPrn BOLD                     

PutSx1( cPerg,"01","Filial   De?"   		,"","","mv_ch1","C",TamSX3("CR_FILIAL")[1]        	,0,0,"G","","XM0","","","MV_PAR01")
PutSx1( cPerg,"02","Filial  Até?"   		,"","","mv_ch2","C",TamSX3("CR_FILIAL")[1]       	,0,0,"G","","XM0","","","MV_PAR02")
PutSx1( cPerg,"03","Data De?"   			,"","","mv_ch3","D",08       	,0,0,"G","","   ","","","MV_PAR03")
PutSx1( cPerg,"04","Data Ate?"   			,"","","mv_ch4","D",08       	,0,0,"G","","   ","","","MV_PAR04")
PutSx1( cPerg,"05","Aprov De?"   			,"","","mv_ch5","C",06       	,0,0,"G","","USR","","","MV_PAR05")
PutSx1( cPerg,"06","Aprov Ate?"   			,"","","mv_ch6","C",06       	,0,0,"G","","USR","","","MV_PAR06")
PutSx1( cPerg,"07","CC De?"   				,"","","mv_ch7","C",TamSX3("CTT_CUSTO")[1]       	,0,0,"G","","CTT","","","MV_PAR07")
PutSx1( cPerg,"08","CC Ate?"   				,"","","mv_ch8","C",TamSX3("CTT_CUSTO")[1]       	,0,0,"G","","CTT","","","MV_PAR08")
PutSx1( cPerg,"09","Analitico/Sintetico?"   ,"","","mv_ch9","N",01       	,0,0,"C","","   ","","","MV_PAR09","Analitico","Analitico","Analitico","","Sintetico","Sintetico","Sintetico")

IF Pergunte(cPerg,.t.)
	cPerDe := DToC(MV_PAR03)
	cPerAt := DToC(MV_PAR04)
	Processa({|| PTNR008A()},"Processando... " )
Endif

Return


Static Function PTNR008A()
Private aV := ""
Private aDetalhe := {}

BeginSql Alias "APR"
	SELECT AK_NOME NOME, AK_COD CODAPR, AK_USER CODUSER ,AK_LIMMIN LIMMIN,AK_LIMMAX LIMMAX,CR_FILIAL FILIAL,CR_NUM PEDIDO,
	(SUBSTRING(CR_EMISSAO,7,2) + '/' +  SUBSTRING(CR_EMISSAO,5,2) + '/' + SUBSTRING(CR_EMISSAO,1,4) ) EMISSAO,
	(SUBSTRING(CR_DATALIB,7,2) + '/' +  SUBSTRING(CR_DATALIB,5,2) + '/' + SUBSTRING(CR_DATALIB,1,4) )  DTLIBERACAO,
	CR_TOTAL, CR_NIVEL NIVEL
	FROM %table:SCR%  SCR
	
	INNER JOIN %table:SAK% SAK ON AK_COD = CR_APROV AND AK_FILIAL = CR_FILIAL AND SAK.%notdel%
	
	WHERE CR_TIPO = 'PC' AND CR_DATALIB BETWEEN  %exp:MV_PAR03% AND  %exp:MV_PAR04% 

	AND AK_USER BETWEEN  %exp:MV_PAR05% AND  %exp:MV_PAR06%		                    

	AND CR_FILIAL BETWEEN %exp:MV_PAR01% AND  %exp:MV_PAR02%		                    
	AND CR_STATUS = '03'
		
	AND  CR_USER = CR_USERLIB AND SCR.%notdel%
	
	ORDER BY AK_FILIAL,  AK_USER , CR_NUM
EndSql

nTotReg := 0
APR->( dbEval( { || nTotReg++ },,{ || !Eof() } ) )
dbGoTop()

ProcRegua(nTotReg)

While !APR->(Eof()) 

	cCC := AllTrim(Posicione("SC7",1,xFilial("SC7")+AllTrim(APR->PEDIDO),"C7_CC")) 
	If cCC >= AllTrim(MV_PAR07) .AND. cCC <= AllTrim(MV_PAR08 )          		
		aadd(aDetalhe,{APR->FILIAL, APR->CODUSER, APR->CODAPR, APR->NOME,TRANSFORM(APR->LIMMIN,"@E 999,999,999.99") ,TRANSFORM(APR->LIMMAX,"@E 999,999,999.99"),APR->PEDIDO,APR->EMISSAO,APR->DTLIBERACAO,APR->CR_TOTAL,AprovSo(APR->FILIAL,APR->PEDIDO,APR->NIVEL) })	//Iif(APR->CR_TOTAL<APR->LIMMAX,.T.,.F.)	//AprovSo(APR->FILIAL,APR->PEDIDO)
	Endif

	IncProc() 
	APR->(DbSkip())
	
Enddo                                             

APR->(DbCloseArea())

If Len(aDetalhe) > 0
	aV := aDetalhe
	oPrn := TMSPrinter():New(cTitulo)                       
	oPrn:SetPaperSize(9)
	oPrn:SetPortrait()
	MontImp()
	oPrn:Preview()
endif

Return


Static Function AprovSo(cXFil,cXNum,cXNivel)
Local lRet := .F.
/*
BeginSql Alias "APR2"
	SELECT COUNT(CR_NUM) REGS
	FROM %table:SCR%  SCR	
	WHERE CR_TIPO = 'PC' 
	AND CR_FILIAL =  %exp:cXFil%
	AND CR_STATUS = '03'
	AND CR_NUM = %exp:cXNum%	
	AND SCR.%notdel%
	GROUP BY CR_NUM	
EndSql
If !APR2->(Eof())
    If APR2->REGS == 1
		lRet := .T.
	EndIf	
EndIf
*/
BeginSql Alias "APR2"
	SELECT CR_NIVEL NIVEL
	FROM %table:SCR%  SCR	
	WHERE CR_TIPO = 'PC' 
	AND CR_FILIAL =  %exp:cXFil%
	AND CR_STATUS = '03'
	AND CR_NUM = %exp:cXNum%	
	AND CR_NIVEL > %exp:cXNivel%
	AND SCR.%notdel%
EndSql

If APR2->(Eof())
	lRet := .T.    
EndIf

APR2->(DbCloseArea())

Return lRet
       

*--------------------------------------------------------------------------*
Static Function MontImp
*--------------------------------------------------------------------------*
Local n_x := 0
Private nLinIni	:= 400
Private nLinFin := 480
Private n_x := 1              

cFil :=  aV[1][1]
cApr :=  aLLtRIM(aV[1][2])
ntotapr := 0
ntotaprs := 0
ntpvapr := 0
ntpvaprs := 0

ntotfil := 0

ntotger := 0
atotger := {}   
lim := Len(aV)

for n_x := 1 to lim

	If n_x == 1
		Cabec()	
		CabecIT()
	Endif		                                     
	If (nLinFin > 3150) 
		nLinIni	:= 350
		nLinFin := 430
		oPrn:EndPage()			
		Cabec()  		
	Endif
	
	If cFil <> aV[n_x][1]	.AND. 	cApr == aLLtRIM(aV[n_x][2])
		nLinIni	+= 80
		nLinFin += 80                                                       

		//oPrn:Say (nLinIni+12,0930, "Total Aprov Final "+aV[n_x-1][4]+" "+Transform(nTotAprs,"@E 999,999,999.99")		,oFont5)
		oPrn:Say( nLinIni+12,1750,"Total Aprov Final "+aV[n_x-1][4]+" "+Transform(nTotAprs,"@E 999,999,999.99") ,oFont5,1400,CLR_BLACK, NiL , 1)

		nLinIni	+= 80
		nLinFin += 80                                                       

		//oPrn:Say (nLinIni+12,0930, "Total Aprov Intermediario "+Space(15)+Transform(nTotApr,"@E 999,999,999.99")		,oFont5)
		oPrn:Say( nLinIni+12,1750,"Total Aprov Intermediario "+Space(15)+Transform(nTotApr,"@E 999,999,999.99") ,oFont5,1400,CLR_BLACK, NiL , 1)		


		//ntotfil += (ntotapr+ntotaprs)

		ntotapr := 0					     
		ntotaprs := 0				

		ntpvaprs := 0
		ntpvapr := 0
		
		nLinIni	+= 80
		nLinFin += 80                                                       

		DbSelectArea("SM0")
		DbSeek(cempant+cFil)
	
//		oPrn:Say (nLinIni+12,0930, "Total Filial "+AllTrim(SM0->M0_NOME)+"-"+AllTrim(SM0->M0_FILIAL)+" "+Transform(nTotFil,"@E 999,999,999.99")		,oFont5)
		
		oPrn:box (nLinIni,0040,nLinIni,2300)
		nLinIni	+= 80
		nLinFin += 80                                                       

		oPrn:Say( nLinIni+12,1750,"Total Filial "+AllTrim(SM0->M0_FILIAL)+" "+Transform(nTotFil,"@E 999,999,999.99") ,oFont5,1400,CLR_BLACK, NiL , 1)//+AllTrim(SM0->M0_NOME)+"-"
		nLinIni	+= 80
		nLinFin += 80                                                       

		oPrn:box (nLinIni,0040,nLinIni,2300)

		
//		nTotGer += ntotFil
		ntotfil := 0
		cFil :=  aV[n_x][1]
		
		CabecIT(.T.)
	Endif    	
	If cApr <> aLLtRIM(aV[n_x][2])
		nLinIni	+= 80
		nLinFin += 80                                         

//		oPrn:Say (nLinIni+12,0930, "Total Aprov Final "+aV[n_x-1][4]+" "+Transform(nTotAprs,"@E 999,999,999.99")		,oFont5)
		oPrn:Say( nLinIni+12,1750,"Total Aprov Final "+aV[n_x-1][4]+" "+Transform(nTotAprs,"@E 999,999,999.99")+" Qtd "+AllTrim(STR(ntpvaprs)) ,oFont5,1400,CLR_BLACK, NiL , 1)
		nLinIni	+= 80
		nLinFin += 80                                                       

//		oPrn:Say (nLinIni+12,0930, "Total Aprov Intermediario "+Space(15)+Transform(nTotApr,"@E 999,999,999.99")		,oFont5)
		oPrn:Say( nLinIni+12,1750,"Total Aprov Intermediario "+Space(15)+Transform(nTotApr,"@E 999,999,999.99")+" Qtd "+AllTrim(STR(ntpvapr)) ,oFont5,1400,CLR_BLACK, NiL , 1)
		//ntotfil += (ntotapr+ntotaprs)
		ntotapr := 0					     
		ntotaprs := 0				             
		
		ntpvaprs := 0
		ntpvapr := 0
		
		cApr := aLLtRIM(aV[n_x][2])
		nLinIni	+= 80
		nLinFin += 80   		
		
		CabecIT(.F.)
	Endif
	
	If aScan(aTotGer,{|x| x[1] == aV[n_x][1] .AND. x[2] == aV[n_x][7] }) == 0
		aAdd(aTotGer,{aV[n_x][1], aV[n_x][7], aV[n_x][10]})	
		nTotFil += 	aV[n_x][10]
		nTotGer += 	aV[n_x][10]		
	Endif
	
	If MV_PAR09 == 1
		oPrn:Say (nLinIni+12,365, aV[n_x][7]	,oFont5)
		oPrn:Say (nLinIni+12,760, aV[n_x][8]	,oFont5)					
		oPrn:Say (nLinIni+12,980, aV[n_x][9]	,oFont5)	

		nycol := 1230
		
		cVal := Alltrim(Transform(aV[n_x][10],"@E 999,999,999.99"))

		nAj := 10-Len(cVal)

//		oPrn:Say (nLinIni+12,1230+nAJ, cval	,oFont5)			  
		oPrn:Say( nLinIni+12,1500,cval,oFont5,1400,CLR_BLACK, NiL , 1)

		oPrn:Say (nLinIni+12,1620, Iif(aV[n_x][11],"Sim","Não")	,oFont5)					
				
		nLinIni	+= 40
		nLinFin += 40	
	
	Endif	                                                                    

	If aV[n_x][11]
		ntotaprs += aV[n_x][10]
		ntpvaprs++		
	Else	
		ntotapr += aV[n_x][10]
		ntpvapr++
	EndIf

next

nLinIni	+= 80
nLinFin += 80                                         
//oPrn:Say (nLinIni+12,0930, "Total Aprov Final "+aV[Len(aV)][4]+" "+    Transform(nTotAprs,"@E 999,999,999.99")		,oFont5)
oPrn:Say( nLinIni+12,1750,"Total Aprov Final "+aV[Len(aV)][4]+" "+    Transform(nTotAprs,"@E 999,999,999.99")+" Qtd "+AllTrim(STR(ntpvaprs)) ,oFont5,1400,CLR_BLACK, NiL , 1)

nLinIni	+= 80
nLinFin += 80                                                       

//oPrn:Say (nLinIni+12,0930, "Total Aprov Intermediario "+Transform(nTotApr,"@E 999,999,999.99")		,oFont5)
oPrn:Say( nLinIni+12,1750,"Total Aprov Intermediario "+Transform(nTotApr,"@E 999,999,999.99")+" Qtd "+AllTrim(STR(ntpvapr)) ,oFont5,1400,CLR_BLACK, NiL , 1)
//ntotfil += (ntotapr+ntotaprs)

nLinIni	+= 80
nLinFin += 80                                         
DbSelectArea("SM0")
DbSeek(cempant+aV[Len(aV)][1])

oPrn:box (nLinIni,0040,nLinIni,2300)

nLinIni	+= 80
nLinFin += 80                                                       

//oPrn:Say (nLinIni+12,0930, "Total Filial "+AllTrim(SM0->M0_NOME)+"-"+AllTrim(SM0->M0_FILIAL)+" "+Transform(nTotFil,"@E 999,999,999.99")		,oFont5)
oPrn:Say( nLinIni+12,1750,"Total Filial "+AllTrim(SM0->M0_FILIAL)+" "+Transform(nTotFil,"@E 999,999,999.99") ,oFont5,1400,CLR_BLACK, NiL , 1) //+AllTrim(SM0->M0_NOME)+"-"
//nTotGer += ntotFil

nLinIni	+= 80
nLinFin += 80                                         

oPrn:box (nLinIni,0040,nLinIni,2300)

nLinIni	+= 80
nLinFin += 80                                                       

//oPrn:Say (nLinIni+12,0930, "Total Geral "+Transform(nTotGer,"@E 999,999,999.99")		,oFont5)
oPrn:Say( nLinIni+12,1750,"Total Geral "+Transform(nTotGer,"@E 999,999,999.99"),oFont5,1400,CLR_BLACK, NiL , 1)
		
Return


Static Function CabecIt(lFil)
	If nLinIni <> 400
		nLinIni	+= 80
		nLinFin += 80	
	Endif                              
	
	If lFil == Nil .OR. lFil	
		DbSelectArea("SM0")
		DbSeek(cempant+aV[n_x][1])

		oPrn:Say (nLinIni,0030, " Filial : "+aV[n_x][1]+" "+AllTrim(SM0->M0_FILIAL),oFont2)	//+" - "+AllTrim(SM0->M0_NOME)
		nLinIni	+= 80
		nLinFin += 80	 	
    Endif

	If (nLinFin > 3150) 
		nLinIni	:= 350
		nLinFin := 430
		oPrn:EndPage()			
		Cabec()  		
	Endif
	
	oPrn:box (nLinIni,0060,nLinFin,0390)
	oPrn:Say (nLinIni+12,0065, " Usuário "	,oFont5)
	
	oPrn:box (nLinIni,0390,nLinFin,1500)
	oPrn:Say (nLinIni+12,0460, " Nome "		,oFont5)					
	
	oPrn:box (nLinIni,1500,nLinFin,1750)
	oPrn:Say (nLinIni+12,1520, " Cod Apr "		,oFont5)	
	
	oPrn:box (nLinIni,1750,nLinFin,2000)
	oPrn:Say (nLinIni+12,1770, " Lim Minimo "		,oFont5)			

	oPrn:box (nLinIni,2000,nLinFin,2250)
	oPrn:Say (nLinIni+12,2020, " Lim Maximo "		,oFont5)			

	nLinIni	+= 80
	nLinFin += 80                                         
    
	oPrn:Say (nLinIni+12,0065, aV[n_x][2]	,oFont5)	
	oPrn:Say (nLinIni+12,0460, aV[n_x][4]		,oFont5)						
	oPrn:Say (nLinIni+12,1520, aV[n_x][3]		,oFont5)		
	oPrn:Say (nLinIni+12,1768, aV[n_x][5]		,oFont5)			
	oPrn:Say (nLinIni+12,2018, aV[n_x][6]		,oFont5)			

	If MV_PAR09 == 1
		nLinIni	+= 80
		nLinFin += 80	

		oPrn:Say (nLinIni+12,365, " Pedido "	,oFont5)	
		oPrn:Say (nLinIni+12,760, " Dt Emissão "		,oFont5)						
		oPrn:Say (nLinIni+12,980, " Dt Aprovação "		,oFont5)	
		oPrn:Say (nLinIni+12,1340, " Valor "		,oFont5)			
		oPrn:Say (nLinIni+12,1575, " Aprovador final "		,oFont5)			
	
		nLinIni	+= 80
		nLinFin += 80
	Endif	

	If (nLinFin > 3150) 
		nLinIni	:= 350
		nLinFin := 430
		oPrn:EndPage()			
		Cabec()  		
	Endif

Return


*-------------------------------------------------------------------------------------*
Static Function Cabec()
*-------------------------------------------------------------------------------------*
oPrn:StartPage()

oPrn:SayBitmap(93, 53, "\system\Lgrl" + cEmpAnt + ".bmp", 322, 150)
oPrn:Say (0113,450,Upper(cTitulo)           			,oFont3)
oPrn:Say (0135,2000,"Data : "			   						,oFont2)
oPrn:Say (0135,2150,DToC(dDataBase)       						,oFont2)
oPrn:Say (0180,2000,"Hora : "			   						,oFont2)
oPrn:Say (0180,2150, Time()      						,oFont2) 

oPrn:box (0270,0040,0270,2300)

oPrn:Say (0300,0030," Período de "+cPerDe+" Até "+cPerAt   						,oFont2)
oPrn:Say (0300,2101,"Pág. "+AllTrim(STR(nPag))			   						,oFont2)
nPag++

Return


