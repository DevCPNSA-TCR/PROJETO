#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"               
#INCLUDE "TopConn.ch"
#include 'fwprintsetup.ch'  
#INCLUDE "RPTDEF.CH"        
#Include "ParmType.ch"

#DEFINE CRLF chr(13)+chr(10)

User Function PTNR007()
Private cTpF := ""
Private dDt := ""
Private cMatI := ""
Private cMatF := ""
Private cCCI := ""
Private cCCF := ""
Private cPGT := ""
Private aHtm := {}
Private cpath := ""                
Private aERR := {}
Private cXLog := ""
Private cELog := ""
Private cLastProc := ""
Private nImp := ""
Private nAb := ""

cPerg := "PTNR007"

PutSX1(cPerg , "01" , "Nota Fiscal De      ?" , "" , "" , "mv_ch1"  , "C" , TAMSX3("F2_DOC")[1] , 0 , 0 , "G" , "", "SF2", "", "", "mv_par01" , "         " ,"","","","" , "   " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "02" , "Nota Fiscal Ate     ?" , "" , "" , "mv_ch2"  , "C" , TAMSX3("F2_DOC")[1] , 0 , 0 , "G" , "", "SF2", "", "", "mv_par02" , "         " ,"","","","" , "   " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "03" , "Serie De     	   ?" , "" , "" , "mv_ch3"  , "C" , TAMSX3("F2_SERIE")[1] , 0 , 0 , "G" , "", "", "", "", "mv_par03" , "         " ,"","","","" , "   " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "04" , "Serie Ate           ?" , "" , "" , "mv_ch4"  , "C" , TAMSX3("F2_SERIE")[1] , 0 , 0 , "G" , "", "", "", "", "mv_par04" , "         " ,"","","","" , "   " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "05" , "Cliente De		   ?" , "" , "" , "mv_ch5"  , "C" , TAMSX3("F2_CLIENTE")[1] , 0 , 0 , "G" , "", "SA1", "", "", "mv_par05" , "         " ,"","","","" , "   " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" )
PutSX1(cPerg , "06" , "Cliente Ate         ?" , "" , "" , "mv_ch6"  , "C" , TAMSX3("F2_CLIENTE")[1] , 0 , 0 , "G" , "", "SA1", "", "", "mv_par06" , "         " ,"","","","" , "   " , "" , "" , "" , "" , "" , "" , "" , "" , "" , "" )


If pergunte(cPerg,.T.)        

	cDocI := MV_PAR01
	cDocF := MV_PAR02
	cSeriI := MV_PAR03
	cSeriF := MV_PAR04
	cCliI := MV_PAR05	
	cCliF := MV_PAR06

	Processa({||xPrint() }," Gerando notas fiscais . . .")	

Endif	
Return

/* 
Metodo: xPrint Desenvolvido por: Vinicius Figueiredo Moreira - Doit - 20130617

*/
Static Function xPrint()

Local cUser       := ""
Local aDifs       := {}     
Local _lResult  := .F.             
Local nTProv 	:= 0
Local nTDesc 	:= 0
Local _cError     := ""  

Local nBInssPA    := 0
Local nAteLim     := 0
Local nBaseFGTS   := 0
Local nFGTS       := 0
Local nBaseIR	  := 0
Local nBaseIrFe   := 0

Private aCodFol	  := {}
Private aTinss	  := {}
Private aInfo	  := {}

Private oPrn
Private n 		:= 0     
Private oFont 	:= TFont():New("Arial",,8,,.F.,,,,,.F.,.F.)
Private oFontC 	:= TFont():New("Arial",,8,,.F.)//,5,.T.,5,.T.,.F.)  
Private oFontN 	:= TFont():New("Arial",,8,,.T.,,,,,.F.,.F.)
Private oFontTit := TFont():New("Arial",11,11,.T.,.T.,5,.T.,5,.T.,.F.)	

Private oFontNF := TFont():New("Arial",15,15,.T.,.T.,5,.T.,5,.T.,.F.)	
Private oFontHead 	:= TFont():New("Arial",,9,,.F.)

Private lAdjustToLegacy := .T. 
Private lDisableSetup  	:= .F. 
Private cNomePDF		:= "NF_"   
Private cTitulo := ""	


Private cEmp
private cCNPJ 
Private cyear
Private cMes

Private cEmismax := ""
Private cdoc := ""

Private cCli := ""
Private cCliend:= ""
Private cclibair:= ""
Private cclicep:= ""
Private cmuni:= ""
Private cest:= ""
Private cclicgc:= ""
Private ccliie:= ""

Private cloc := ""
Private nnftot := 0
Private cper := ""
Private cemis := ""
Private cvenc := ""

Private nqtd := 0
Private cdescri:= ""
Private nprctot := 0
Private nbasicms := 0
Private naliq := 0
Private nvlicms := 0
Private nvlpres := 0
Private nvltotnf := 0

Private crec := ""

//******** Fabio - 01/08/2016 
Private cMenNota := ""      
Private cAux := "" 
//***************************

cPathPDF := "" //cPath

DbSelectArea("SM0")      
DbSetOrder(1)
DbSeek(cEmpAnt+cFilAnt)

cEmp := AllTrim(SM0->M0_NOMECOM)
cCNPJ := "CNPJ: "+AllTrim(Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"))
cEnd := AllTrim(SM0->M0_ENDCOB) +" - " +AllTrim(SM0->M0_COMPCOB)+" - " +AllTrim(SM0->M0_BAIRCOB)
cCEP := "CEP "+AllTrim(SM0->M0_CEPCOB)+" - " +AllTrim(SM0->M0_CIDCOB)+" - " +AllTrim(SM0->M0_ESTCOB)
cIE := "Inscr. Estadual "+AllTrim(Transform(SM0->M0_INSC,"@R 99.999.999"))

cQuery := " SELECT * "
cQuery += " FROM " + RetSqlName("SF2") + " F2 , "  + RetSqlName("SD2") + " D2 " //, "  + RetSqlName("SC5") + " C5  "
cQuery += " WHERE "
cQuery += "   F2_FILIAL = '" + xFilial("SF2") + "'"
cQuery += "  AND F2_DOC BETWEEN '" + cDocI + "' and '" + cDocF + "' "
cQuery += "  AND F2_CLIENTE BETWEEN '" + cCliI + "' and '" + cCliF + "'"
cQuery += "  AND F2_SERIE BETWEEN '" + cSeriI + "' and '" + cSeriF + "' "

cQuery += " AND F2.D_E_L_E_T_ = ' ' AND D2.D_E_L_E_T_ = ' ' "                    

cQuery += " AND  D2_FILIAL = F2_FILIAL AND  D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_CLIENTE = F2_CLIENTE AND D2_LOJA = F2_LOJA  "

cQuery += " ORDER BY F2_DOC, F2_SERIE , D2_ITEM"

TcQuery cQuery Alias "DIF" New

If DIF->(Eof())     
	Alert("Não foram encontrados dados!")
	Return
Else
	oPrn := TMSPrinter():New("Impressão de NFs")
	oPrn:SetPortrait()
	oPrn:SetPaperSize(9) 	
Endif     

While DIF->(!Eof())

	oPrn:StartPage()  	
	nLinB1i := 390
	nLinB1F := 830
	           
	nLinB2i := 840
	nLinB2F := 1240

	nLinB3i := 1250
	nLinB3F := 1435

	nLinB4i := 1485
	nLinB4F := 2860//2780

	nLinB5i := 2880
	nLinB5F := 3110
		
	nColI := 205
	nColF := 2120
	
	nPosBox := 30
	nPreBox := 70	
	 cCt := DIF->F2_DOC+DIF->F2_SERIE
	 
	cEmismax :="31/10/2015"
	 cdoc := AllTrim(Transform( DIF->F2_DOC  ,"@R 999.999.999"))

	 DbSelectArea("SF3")
	 SF3->(DbSetOrder(5))
	 SF3->(DbGoTop())
	 SF3->(DbSeek(xFilial("SF3")+DIF->(F2_SERIE+F2_DOC+F2_CLIENTE+F2_LOJA)))
	 cCodHash := AllTrim(Transform( SF3->F3_MDCAT79 ,"@!"))

	 DbSelectArea("SA1")
	 DbSetOrder(1)
	 DbSeek(xFilial("SA1")+DIF->F2_CLIENTE+DIF->F2_LOJA)	
	 cCli := AllTrim(SA1->A1_NOME)
	 cCliend:= AllTrim(SA1->A1_END)
	 cclibair:= AllTrim(SA1->A1_BAIRRO)
	 cclicep:= AllTrim(Transform( SA1->A1_CEP ,"@R 99.999-999"))
	 cmuni:= AllTrim(SA1->A1_MUN)
	 cest:= AllTrim(SA1->A1_EST)
	 cclicgc:= AllTrim(Transform(SA1->A1_CGC  ,"@R 99.999.999/9999-99"))
	 ccliie:= AllTrim(Transform(SA1->A1_INSCR ,"@R 99.999.999"))
	
	 cloc := "RJ"
	 nnftot := Transform( DIF->F2_VALBRUT  ,"@E 9,999,999,999.99")
	 cper := "" //Posicione("SE4",1,xFilial("SE4")+DIF->F2_COND,"E4_COND")
	 cemis := DtoC(StoD(DIF->F2_EMISSAO))
	 cvenc := DToC(Posicione("SE1",2,xFilial("SE1")+DIF->F2_CLIENTE+DIF->F2_LOJA+DIF->F2_SERIE+DIF->F2_DOC,"E1_VENCTO")) //DtoC(StoD(DIF->F2_VENCTO))
	 
	 nbasicms := Transform( DIF->F2_BASEICM ,"@E 9,999,999,999.99")
	 //naliq := Transform( ((DIF->F2_VALICM*100)/DIF->F2_BASEICM)  ,"@E 99.99")
	 naliq := Transform( ROUND(((DIF->F2_VALICM*100)/DIF->F2_BASEICM),1)  ,"@E 99.99")
	 
	 nvlicms := Transform( DIF->F2_VALICM ,"@E 999,999,999.99")
	 nvltotnf := Transform( DIF->F2_VALBRUT  ,"@E 9,999,999,999.99")
	
	 crec := DtoC(StoD(DIF->F2_DTENTR))

	cCond := Posicione("SE4",1,xFilial("SE4")+DIF->F2_COND,"E4_COND")
	nP := At(",",cCond)
	If nP > 0
		cCond := SubSTR(cCond,1,nP)	  
	Endif
	nCond := Val(cCond)

	
	//B1
	nTamB1 := 1195
	oPrn:Box(nLinB1i,nColI,nLinB1F,nColI+nTamB1)	
	oPrn:Box(nLinB1i,nColI+nTamB1,nLinB1F,nColF)	           
	
	oPrn:SayBitmap(410,420, "\HTML\ptn_lOGO"+cfilant+".jpg", 700, 200)

/*
	oPrn:Say( 600,360, cEmp , oFontTit )	
	oPrn:Say( 645,360, cEnd , oFont )	
	oPrn:Say( 675,555, cCep , oFont )		
*/
	oPrn:Say( 600, ((nTamB1/2)-Len(cEmp)/2)-200, cEmp , oFontTit )	
	oPrn:Say( 645,((nTamB1/2)-Len(cEnd)/2)-150, cEnd , oFont )	
	oPrn:Say( 675,((nTamB1/2)-Len(cCep)/2)-100, cCep , oFont )		

	oPrn:Say( 755,230, cCNPJ , oFont )	
	oPrn:Say( 755,980, cIE , oFont )					
	
	oPrn:Say( 401,1513, "NOTA FISCAL DE SERVIÇOS", oFontTit )	
	oPrn:Say( 451,1521, "DE TELECOMUNICAÇÕES", oFontTit )	
	oPrn:Say( 501,1650, "SÉRIE ÚNICA", oFont )	
	//oPrn:Say( 545,1475, "1ª Via Cliente | 2ª Via Arquivo Fiscal | 3ª Via Fisco", oFont ) Alterado por Rafael Sacramento em 14/12/2016
	oPrn:Say( 545,1585, "NOTA FISCAL VIA ÚNICA", oFont )	
	// Fim da alteração
	oPrn:Say( 647,1528, " Nº "+Transform(cDoc,"@R 999.999.999"), oFontNF )	
	If AllTrim(GetNewPar("MV_XNFTCR","S")) == "S"
		oPrn:Say( 755,1420, "DATA LIMITE PARA EMISSÃO "+cEmisMax, oFontN )			                                                           
    Endif
	//B2
	oPrn:Box(nLinB2i,nColI,nLinB2F,nColF)	
    nLin := nLinB2i    
    nLin += 45
	oPrn:Say(nLin,210, " CLIENTE : "+ cCli, oFont )	
    nLin += 90
	oPrn:Say(nLin,210, " ENDEREÇO : "+  cCliend, oFont )	
    nLin += 90
	oPrn:Say(nLin,210, " BAIRRO : "+ cclibair, oFont )	
	oPrn:Say(nLin,985, " CEP : "+ cclicep, oFont )	
	oPrn:Say(nLin,1240, " MUNICÍPIO : "+ cmuni, oFont )	
	oPrn:Say(nLin,1820, " EST.: "+ cest, oFont )		
    nLin += 90
	oPrn:Say(nLin,210, " CNPJ/CIC : "+ cclicgc, oFont )			
	oPrn:Say(nLin,1200, " INSCR.EST./RG.: "+ ccliie, oFont )	
	
	//B3
	nC1 := 415
	nC2 := 980
	nC2t := nC2
	nC3 := 1430
	nC4 := 1780
	nH := 60
	
	//oPrn:Box(nLinB3i,nColI,nLinB3F,nColF)	                          
	nR := 15	
	oPrn:Box(nLinB3i,nColI,nLinB3i+nH,nC1)	                          
	oPrn:Say(nLinB3i+nR,nColI+60, "LOCAL", oFontN )	
	oPrn:Say(nLinB3i+nR+75,nColI+75,  cloc , oFontN )	
 	
	oPrn:Box(nLinB3i,nC1,nLinB3i+nH,nC2)  
	oPrn:Say(nLinB3i+nR,nC1+120, "NOTA FISCAL/VALOR R$", oFontN )	
	oPrn:Say(nLinB3i+nR+75,nC1+120,  nnftot , oFontN )	
	
	oPrn:Box(nLinB3i,nC2,nLinB3i+nH,nC3)	                          
	oPrn:Say(nLinB3i+nR,nC2+90, "PERIODO", oFontN )	

	oPrn:Box(nLinB3i,nC3,nLinB3i+nH,nC4)	                          
	oPrn:Say(nLinB3i+nR,nC3+90, "EMISSÃO", oFontN )	
	oPrn:Say(nLinB3i+nR+75,nC3+70,  cemis , oFontN )
	
	oPrn:Box(nLinB3i,nColI,nLinB3i+nH,nColF)	                          		
	oPrn:Say(nLinB3i+nR,nC4+80, "VENCIMENTO", oFontN )
	oPrn:Say(nLinB3i+nR+75,nC4+95,  cvenc , oFontN )

		
	nLinB3i += nH 		

	oPrn:Box(nLinB3i,nColI,nLinB3F,nC1)	                          
	oPrn:Box(nLinB3i,nC1,nLinB3F,nC2)	                          
	oPrn:Box(nLinB3i,nC2,nLinB3F,nC3)	                          
	oPrn:Box(nLinB3i,nC3,nLinB3F,nC4)	                          
	oPrn:Box(nLinB3i,nColI,nLinB3F,nColF)	                          			

	//B4
	oPrn:Say(nLinB4i-40,nColI+20, "SERVIÇOS DE TELECOMUNICAÇÕES", oFontN )
	
	oPrn:Box(nLinB4i,nColI,nLinB4F,nColF)	                            	
	
	nC1x := 415
	nC2x := 1780	
	nH := 90                                                       
	Nf1 := nLinB4f-280
	nR := 21	
		
	oPrn:Box(nLinB4i,nColI,nLinB4i+nH,nC1x)	                          
	oPrn:Say(nLinB4i+nR,nColI+20, "QUANTIDADE", oFontn )	
	oPrn:Box(nLinB4i,nColI,nf1,nC1x)	                          
	
	oPrn:Box(nLinB4i,nC1x,nLinB4i+nH,nC2x)  
	oPrn:Say(nLinB4i+nR,nC1x+400, "DISCRIMINAÇÃO DOS SERVIÇOES PRESTADOS", oFontn )	
	oPrn:Box(nLinB4i,nC1x,nf1,nC2x)  

	oPrn:Box(nLinB4i,nColI,nLinB4i+nH,nColF)	                          		
	oPrn:Say(nLinB4i+nR,nC4+50, "PREÇO TOTAL", oFontn )
	oPrn:Box(nLinB4i,nColI,nf1,nColF)	                          		

    
	nC1 := 565
	nC2 := 720
	nC3 := 1160
	nC4 := 1780		
    nH := 55
    nH2 := 150//180

	oPrn:Box(nf1,nColI,nF1+nH,nC3)	                              
	oPrn:Box(nf1,nColI,nF1+nH2,nC1)	                          
	oPrn:Say(nF1+20,nColI+10, "BASE DE CALCULO ICMS", oFont )
	oPrn:Say(nF1+80,nColI+60,  nbasicms , oFont )

	oPrn:Box(nf1,nC1,nF1+nH2,nC2)	                          
	oPrn:Say(nF1+20,nC1+10, "ALIQUOTA", oFont )
	oPrn:Say(nF1+80,nC1+30,   naliq  , oFont )

	oPrn:Box(nf1,nC2,nF1+nH2,nC3)	 
	oPrn:Say(nF1+20,nC2+40, "VALOR DO ICMS", oFont )
	oPrn:Say(nF1+80,nC2+70,   nvlicms   , oFont )
	
	oPrn:Box(nf1,nC3,nF1+nH2,nC4)	                          
	oPrn:Say(nF1+80,nC3+15, "VALOR TOTAL DA PRESTAÇÃO", oFontTit )	
		
	oPrn:Box(nf1,nC4,nF1+nH2,nColF)	                          			
	nF2 := nF1

	nF1 :=     nF1+nH2
	oPrn:Box(nf1,nColI,nLinB4F,nC3)	                          
	oPrn:Say(nF1+10,nColI+20, "OBS.:", oFont )
	oPrn:Say(nF1+40,nColI+20, "RESERVADO AO FISCO: " + cCodHash, oFont )

	
	cPed := DIF->D2_PEDIDO
	
	cMenNota := AllTrim(Posicione("SC5",1,xFilial("SC5")+cped,"C5_MENNOTA"))
	
	//Incluido por Rafael Sacramento (Criare Consulting) em 05/10/2016 - Se o campo C5_MENNOTA estiver vazio, é utilizado o campo C5_XNFSCPN.
	
	If Empty(SC5->C5_MENNOTA)
		cMenNota := Alltrim(Posicione("SC5",1,xFilial("SC5")+cped,"C5_XNFSCPN"))
	Endif
	
	//Fim da inclusão
	
	cObs := AllTrim(Posicione("SC5",1,xFilial("SC5")+cped,"C5_XOBS"))
	
	
	cObsAux := cObs
	xnF1 := nF1+40//-100 + nF1 - (INT((Len(cObsAux)/85))*130)-75     //(INT((Len(cObsAux)/85))*130)-75
	nT := 0
	While !Empty(cObsAux)
		oPrn:Say(xnF1+nT,nColI+20,  SubSTR(cObsaux,1,60) , oFont )		//320  74
		If Len(cObsAux) > 100
	    	cObsAux := SubSTR(cObsaux,100)
	    	nT += 30
	 	Else
	 		cObsAux := ""
		Endif
	EndDo				
	
	oPrn:Say(nLinB4F-30,nColI+15, "O VALOR DO ISS E ICMS ESTÃO INCLUSOS NO VALOR DO SERVIÇO", oFont )
                

	oPrn:Box(nf1,nC3,nLinB4F,nC4)	                          
	oPrn:Say(nF1+30,nC3+55, "VALOR TOTAL DA NOTA", oFontTit )
	oPrn:Say(nF1+30,nC4+70,  nvltotnf , oFont )

	oPrn:Box(nf1,nC4,nLinB4F,nColF)	                          			

	//B5
	nC1 := 1710	
	oPrn:Box(nLinB5i,nColI,nLinB5F,nC1)		
	oPrn:Say(nLinB5i+30,nColI+20, "RECEBEMOS DE", oFont )
	oPrn:Say(nLinB5i+30,nColI+300, cEmp, oFontN )	
	oPrn:Say(nLinB5i+70,nColI+20, "OS SERVIÇOS CONSTANTES DA NOTA FISCAL DE SERVIÇOS DE TELECOMUNICAÇÕES INDICADA AO LADO", oFont )

	oPrn:Say(nLinB5F-45,nColI+41, "DATA DO RECEBIMENTO", oFont )
	oPrn:Say(nLinB5F-45,nColI+570, "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR", oFont )
	
	oPrn:Say(nLinB5F-85,nColI+20,  crec , oFont )
	oPrn:Say(nLinB5F-85,nColI+480, "_______________________________________________________", oFont )
	
	oPrn:Box(nLinB5i,nC1,nLinB5F,nColF)		
	oPrn:Say(nLinB5i+30,nC1+20, "NOTA FISCAL DE SERVIÇOS", oFontN )
	oPrn:Say(nLinB5i+73,nC1+28, "DE TELECOMUNICAÇÕES", oFontN )
	oPrn:Say(nLinB5i+130,nC1+37, "Nº "+cDoc, oFontNF )

	//imprimir os itens      
	nTotIt := 0    
	nLinIt := nLinB4i+110
	While cCt == DIF->F2_DOC+DIF->F2_SERIE	.AND. nLinIt < 2300	.AND. DIF->(!Eof())

		cPed := DIF->D2_PEDIDO
		
		 nqtd    := Transform( DIF->D2_QUANT ,"@E 999")
		 cdescri := AllTrim(Posicione("SB1",1,xFilial("SB1")+DIF->D2_COD,"B1_DESC"))
		 nprctot := Transform( DIF->D2_TOTAL ,"@E 999,999,999.99")
	
		cdELIN   := aLLtRIM(Posicione("SC5",1,xFilial("SC5")+cped,"C5_XDELIN"))
		cContrato:= aLLtRIM(Posicione("SC5",1,xFilial("SC5")+cped,"C5_XCONTRA"))
							
		oPrn:Say(nLinIt,nColI+50, nQtd , oFont )		
		oPrn:Say(nLinIt,nC1x+35,  cdescri+ '  '+Iif(!Empty(CdELIN)," DELIN N° "+CdELIN,"")+'  '+Iif(!Empty(cContrato)," CONTRATO N° "+cContrato,"") , oFont )	
		oPrn:Say(nLinIt,nC4+50,  nprctot  , oFont )
				
		nTotIt += DIF->D2_TOTAL
		nLinIt+= 30
		
		DIF->(DbSkip())  
	EndDo	                                   

	nLinIt+=30	
	oPrn:Say(nLinIt,nC1x+35, "NF EMITIDA CONFORME REGIME ESPECIAL - PROCESSO N.: E04/003/565/2014-CONV.115/03", oFont)
	nLinIt+=30

	cCt := DIF->F2_DOC+DIF->F2_SERIE
	nvlpres := Transform( nTotIt ,"@E 9,999,999,999.99")
	oPrn:Say(nF2+80,nC4+70,  nvlpres , oFont )	

    // ******** Fabio - 01/08/2016 ******** 
    // Adicionar o campo C5_MENNOTA no corpo da nota fiscal de Telecomuncações
    // Solicitação n. 24915 - Pamela Pires
    if !empty(cMenNota)
       nLinIt+= 30 
       cAux := cMenNota 
     
       nT := 0
	   While !Empty(cAux)
	   //Alterado por Rafael Sacramento (Criare Consulting) em 05/10/2016 - Redução de caracteres por linha
	   	/*
	   	oPrn:Say(nLinIt+nT,nC1x+35,  SubSTR(cAux,1,100) , oFont )		//320  74
	   	If Len(cAux) > 100
	    	cAux := SubSTR(cAux,100)
	    */	
	    //Início do trecho modificado
	    oPrn:Say(nLinIt+nT,nC1x+35,  SubSTR(cAux,1,82) , oFont )
	   	If Len(cAux) > 82
	    	cAux := SubSTR(cAux,82)
	    //Fim do trecho modificado
	    
	    	nT += 30
	 	Else
	 		cAux := ""
		Endif
	   EndDo			
       	
    endif 
    //************************************
        
	If Empty(cPer)
		cPer := Posicione("SC5",1,xFilial("SC5")+cped,"C5_XPER")		 
	Endif        
	
	cperAux := cPer       
	nT := 0
	While !Empty(cPerAux)
		oPrn:Say(nLinB3i+nR+nT ,nC2t+20,  SubSTR(cperaux,1,25) , oFont )		
		If Len(cPerAux) > 26
	    	cPerAux := SubSTR(cPeraux,26)
	    	nT := 45
	 	Else
	 		cPerAux := ""
		Endif
	EndDo		   
	
	oPrn:EndPage() 

EndDo

DIF->(DbCloseArea())

oPrn:Preview() 

Return 