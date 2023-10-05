#Include "rwmake.ch"
#Include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PTNI001  บ Autor ณ Vinicius Figueiredo Moreira    บ Data ณ  09/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Importa็ใo de Imobilizados - Tabela SN1 	                  บฑฑ
ฑฑบ          ณ Importa็ใo dos cadastros de Saldos imobilizados tabela SN3 บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PTNI001

Private oDlg
Private c_dirimp     := space(100)
Private _nOpc         := 0
Private __oGet 

DEFINE MSDIALOG oDlg TITLE "Importa็ใo de Ativo Fixo" FROM 000,000 TO 250,320 PIXEL

@ 033,009 Say   "Diretorio"       Size 045,008 PIXEL OF oDlg   //030
@ 041,009 MSGET c_dirimp          Size 120,010 WHEN .F. PIXEL OF oDlg  //038
*-----------------------------------------------------------------------------------------------------------------*
*Buscar o arquivo no diretorio desejado.                                                                          *
*Comando para selecionar um arquivo.                                                                              *
*Parametro: GETF_LOCALFLOPPY - Inclui o floppy drive local.                                                       *
*           GETF_LOCALHARD   - Inclui o Harddisk local.                                                           *
*-----------------------------------------------------------------------------------------------------------------*
@ 041,140 BUTTON "..."            SIZE 013,013 PIXEL OF oDlg   Action(c_dirimp := cGetFile("*.csv|*.csv","Importacao de Dados",0, ,.T.,GETF_LOCALHARD))

*-----------------------------------------------------------------------------------------------------------------*

@ 085,009 Button "OK"       Size 037,012 PIXEL OF oDlg Action(_nOpc := 1,oDlg:End())
@ 085,060 Button "Cancelar" Size 037,012 PIXEL OF oDlg Action oDlg:end()

ACTIVATE MSDIALOG oDlg CENTERED

If _nOpc == 1
    Processa({|| IMPORTA()  },"Importando Ativo Fixo...")
Endif

Return

*------------------------------------------------------------------*
Static Function IMPORTA()
*------------------------------------------------------------------*
* fun็ใo para importar o arquivo
*------------------------------------------------------------------*

Local cArquiv
Local nLin    := 1      
Local cProc   := ""
Local cComp   := ""
Local cDesc   := ""
Local nLinCab := 3
Local nUfir  := 0.8287

Private aErros := {}
Private lMsErroAuto := .F.
Private cDiretor := ""

cDiretor := IIF(Right(cDiretor,1) == "\", cDiretor, cDiretor+"\" )
cArquiv  := c_dirimp
c_ren    :=  cDiretor+"\"+STRTRAN(UPPER(cArquiv),".CSV",".IMP")
lRenFile := .T.
lAtuData := .F.

FT_FUSE(cArquiv)
FT_FGOTOP()
ProcRegua(FT_FLASTREC())
aDados := {}
nContLin := 0

While !FT_FEOF()
	
	If nLin < nLinCab
	    FT_FSKIP()                  
	    nLin++ 
	    Loop		
	endif
    
    cBuffer   := FT_FREADLN()
    cBufAux   := cBuffer
    nContLin++
    IncProc()  

	cProc := ""
	cComp := ""
	cDesc := ""
		    
    nContCol := 1
    While !Empty(cBufAux)

    // Layout do arquivo a ser importado. vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
    // N1_FILIAL	N1_CBASE	N1_ITEM	N1_GRUPO	N1_AQUISIC	N1_DESCRIC	N1_QUANTD	N1_CODBAR	N1_LOCAL	N1_FORNEC	N1_NFISCAL	
	// N3_TIPO	N3_BAIXA	N3_CCONTAB	N3_CDEPREC	N3_CCUSTO	N3_CCDEPR	N3_DINDEPR	N3_VORIG1	N3_TXDEPR1	N3_VORIG2	N3_TXDEPR2	
	// N3_VORIG3	N3_TXDEPR3	N3_VORIG4	N3_TXDEPR4	N3_VORIG5	N3_TXDEPR5	N3_VRDACM1	N3_VRDACM2	N3_VRDACM3	N3_VRDACM4	N3_VRDACM5   N1_XNUMSER  	N3_NOVO

        xPos := AT(";",cBufAux)    

        Do Case 

            Case nContCol == 1         
                cFil       := AllTrim(SubSTR(cBufAux,1,xPos-1))
            Case nContCol == 2         
                cBase := PADR(AllTrim(SubSTR(cBufAux,1,xPos-1)),TamSX3("N1_CBASE")[1])
            Case nContCol == 3         
                cItem      := AllTrim(SubSTR(cBufAux,1,xPos-1))
            Case nContCol == 4         
                cGrupo     := AllTrim(SubSTR(cBufAux,1,xPos-1))
            Case nContCol == 5         
                cAquis     := AllTrim(SubSTR(cBufAux,1,xPos-1))
            Case nContCol == 6         
                cDescri    := AllTrim(SubSTR(cBufAux,1,xPos-1))
            Case nContCol == 7         
                cQtdD      := AllTrim(SubSTR(cBufAux,1,xPos-1))
            Case nContCol == 8         
                cCodBar    := STRZERO(Val(Replace(AllTrim(SubSTR(cBufAux,1,xPos-1)),"'","" )),10)
            Case nContCol == 9         
                cLocal     := Replace(AllTrim(SubSTR(cBufAux,1,xPos-1)),"'","" )
            Case nContCol == 10         
                
                cFornec    := Replace(AllTrim(SubSTR(cBufAux,1,xPos-1)),"'","" )
                cFX := STRZERO(Val(SubSTR(cFornec,1,Len(cFornec)-2)),6)
                cLX := SubSTR(cFornec,Len(cFornec)-1)
				cFornec := cFX+cLX
				                
            Case nContCol == 11         
                cNF        := STRZERO(Val(Replace(AllTrim(SubSTR(cBufAux,1,xPos-1)),"'","" )),9)
            Case nContCol == 12         
                cTp        := AllTrim(SubSTR(cBufAux,1,xPos-1))
            Case nContCol == 13         
                cBx        := AllTrim(SubSTR(cBufAux,1,xPos-1))
            Case nContCol == 14         
                cCContab   := AllTrim(SubSTR(cBufAux,1,xPos-1))
            Case nContCol == 15         
                cCDepre    := AllTrim(SubSTR(cBufAux,1,xPos-1))
            Case nContCol == 16         
                cCC        := AllTrim(SubSTR(cBufAux,1,xPos-1))
            Case nContCol == 17         
                cCCDepr    := AllTrim(SubSTR(cBufAux,1,xPos-1))
            Case nContCol == 18         
                cDIND      := AllTrim(SubSTR(cBufAux,1,xPos-1))
            Case nContCol == 19         
                cVorig1    := AllTrim(Replace(SubSTR(cBufAux,1,xPos-1),".",""))
            Case nContCol == 20         
                cTxDepr1   := AllTrim(Replace(SubSTR(cBufAux,1,xPos-1),".",""))
            Case nContCol == 21         
                cVorig2    := AllTrim(Replace(SubSTR(cBufAux,1,xPos-1),".",""))
            Case nContCol == 22         
                cTxDepr2   := AllTrim(Replace(SubSTR(cBufAux,1,xPos-1),".",""))

            Case nContCol == 23         
                cVorig3    := AllTrim(Replace(SubSTR(cBufAux,1,xPos-1),".",""))
            Case nContCol == 24         
                cTxDepr3   := AllTrim(Replace(SubSTR(cBufAux,1,xPos-1),".",""))
            Case nContCol == 25         
                cVorig4    := AllTrim(Replace(SubSTR(cBufAux,1,xPos-1),".",""))
            Case nContCol == 26         
                cTxDepr4   := AllTrim(Replace(SubSTR(cBufAux,1,xPos-1),".",""))
            Case nContCol == 27         
                cVorig5    := AllTrim(Replace(SubSTR(cBufAux,1,xPos-1),".",""))
            Case nContCol == 28         
                cTxDepr5   := AllTrim(Replace(SubSTR(cBufAux,1,xPos-1),".",""))
            Case nContCol == 29         
                cVRDACM1   := AllTrim(Replace(SubSTR(cBufAux,1,xPos-1),".",""))
            Case nContCol == 30         
                cVRDACM2   := AllTrim(Replace(SubSTR(cBufAux,1,xPos-1),".",""))
            Case nContCol == 31         
                cVRDACM3   := AllTrim(Replace(SubSTR(cBufAux,1,xPos-1),".",""))
            Case nContCol == 32         
                cVRDACM4   := AllTrim(Replace(SubSTR(cBufAux,1,xPos-1),".",""))
            Case nContCol == 33         
                cVRDACM5   := AllTrim(Replace(SubSTR(cBufAux,1,xPos-1),".",""))
            Case nContCol == 34         
                cNS   	   := AllTrim(SubSTR(cBufAux,1,xPos-1))
            Case nContCol == 35
                cNovo      := AllTrim(SubSTR(cBufAux,1))

            Otherwise  
            
        EndCase            

        If xPos > 0    
            cBufAux := SubSTR(cBufAux,xPos+1)
        Else
            cBufAux := ""        
        Endif

        nContCol++
    EndDo                
//				{"N1_CHAPA"  ,Getsx8Num("SN1","N1_CHAPA")	        ,nil},;
	aVetN1 := { {"N1_FILIAL" ,xFilial("SN1")        	,nil},;
				{"N1_CBASE"  ,cBase						,nil},;
				{"N1_ITEM"   ,STRZERO(val(cItem),TamSX3("N1_ITEM")[1]) 	,nil},;
				{"N1_AQUISIC",Stod(cAquis)   			,nil},;
				{"N1_DESCRIC",cDescri					,NIL},;	
				{"N1_QUANTD" ,Val(cQtdD)				,nil},;
				{"N1_GRUPO"  ,cGrupo					,nil},;
				{"N1_FORNEC" ,SubSTR(cFornec,1,6)					,nil},;
				{"N1_LOJA" ,SubSTR(cFornec,7)					,nil},;				
				{"N1_CHAPA"  ,STRZERO(val(SubSTR(cBase,Len(cBase)-3)),6)	        ,nil},;
				{"N1_LOCAL"  ,cLocal				 	,nil},;
				{"N1_CODBAR" ,cCodBar					,nil},;
				{"N1_NFISCAL",STRZERO(Val(cNF),TamSX3("N1_NFISCAL")[1])	,nil},;
				{"N1_XNUMSER",cNS						,nil},;
				{"N1_VLAQUIS",Val(cVOrig1	)			,nil},;
				{"N1_BAIXA"  ,SToD(cBx)			    	,".T."}}
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//GRAVA SN3 --> SALDOS DO ATIVO
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ                                                                                                    
	aVetN3:={}
	aadd(aVetN3,  { {"N3_FILIAL"   ,xFilial("SN3")         		,nil},;
					{"N3_CBASE"    ,cBase			 			,nil},;
					{"N3_ITEM"     ,STRZERO(val(cItem),TamSX3("N3_ITEM")[1]) ,nil},;
					{"N3_TIPO"     ,STRZERO(val(cTp),2)    		,nil},;
					{"N3_HISTOR"   ,cDescri 					,nil},;
					{"N3_CCONTAB"  ,cCContab		 			,nil},;
					{"N3_CDEPREC"  ,cCDepre		 				,nil},;
					{"N3_CCDEPR"   ,cCCDepr		 				,nil},;					
					{"N3_DINDEPR"  ,SToD(cDIND)					,nil},;
					{"N3_VORIG1"   ,Val(cVOrig1	)		 		,nil},;
					{"N3_TXDEPR1"  ,Val(cTxDepr1)				,nil},;
					{"N3_VORIG2"   ,Val(cVOrig2	)		 		,nil},;
					{"N3_TXDEPR2"  ,Val(cTxDepr2)				,nil},;					
					{"N3_VORIG3"   ,Val(cVOrig3	) 				,nil},;
					{"N3_TXDEPR3"  ,Val(cTxDepr3)				,nil},; 
					{"N3_VORIG4"   ,Val(cVOrig4	) 				,nil},;
					{"N3_TXDEPR4"  ,Val(cTxDepr4)				,nil},;					
					{"N3_VORIG5"   ,Val(cVOrig5	) 				,nil},;
					{"N3_TXDEPR5"  ,Val(cTxDepr5)				,nil},;					
					{"N3_VRDACM1"  ,Val(cVRDACM1)				,nil},;
					{"N3_VRDACM2"  ,Val(cVRDACM2)				,nil},;
					{"N3_VRDACM3"  ,Val(cVRDACM3)				,nil},;
					{"N3_VRDACM4"  ,Val(cVRDACM4)				,nil},;
					{"N3_VRDACM5"  ,Val(cVRDACM5)				,nil},;					
					{"N3_AQUISIC"  ,SToD(cAquis)	 			,nil},;
					{"N3_NOVO"     ,cNovo	 					,nil},;
					{"N3_CUSTBEM"  ,cCC	 						,nil},;
					{"N3_CCDESP"   ,cCC		 					,nil},;
					{"N3_CCUSTO"   ,cCC 		 			 	,nil}})
	
	//Round(RetTRB("N3_VORIG1")/nUfir,2)			
	MSExecAuto({|x,y,z|Atfa010(x,y,z)},aVetN1,aVetN3,3)   //Se houver mais de um item, passar no aItemPv entre virgulas; ex: {aItemPV,aItemPV1...}
	
	If lMsErroAuto                         
	
		cpath := SubStr(c_dirimp,1,Rat("\",c_dirimp))
		cFile := "Err_IMPATF_"+cBase+"_"+dtos(dDatabase)+".log"
		
		aAdd( aErros , { "Erro na Importa็ใo" , "Ativo Nใo Importado, verifique o Log. Arquivo: "+cFile } ) 
		
		MostraErro(cpath, cFile)
		DisarmTransaction()
		lMsErroAuto := .F.                               
	Else
		ConfirmSX8()
	EndIf
                    
    FT_FSKIP()                  
    nLin++
    
Enddo                                   

FT_FUSE()


Return
