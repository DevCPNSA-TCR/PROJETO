#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#DEFINE CRLF CHR(13)+CHR(10)    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ PTNA004 ³ Autor ³ Vinicius Figueiredo    ³ Data ³ 12.08.16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³   Rotina para atualizar a matricula da fetranspor com base 
	no arquivo preenchido pelos colaboradores.                    

	Query para gerar a planilha que os colaboradores irão preencher:
	
	SELECT RA_FILIAL , '' AS EMPRESA, RA_MAT , RA_NOME , RA_CIC FROM SRA010
		WHERE D_E_L_E_T_ = ' ' AND RA_DEMISSA = ''
		ORDER BY RA_FILIAL, RA_MAT          							
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
User Function PTNA004()
Local nLin         
Local lRet := .T. 

Private cDiretor := ""
Private cArquiv                     
Private cxFilial  := ""                                                                   
Private cMat := ""
Private cFetrans := ""
Private oDlgT
Private c_dirimp     := space(100)
Private _nOpc         := 0
Private cpathlog

lRenFile := .T.
lAtuData := .F.

DEFINE MSDIALOG oDlgT TITLE "Importação de matriculas Fetranspor" FROM 000,000 TO 250,320 PIXEL

@ 033,009 Say   "Diretorio"       Size 045,008 PIXEL OF oDlgT   //030
@ 041,009 MSGET c_dirimp          Size 120,010 WHEN .F. PIXEL OF oDlgT  //038
*-----------------------------------------------------------------------------------------------------------------*
*Buscar o arquivo no diretorio desejado.                                                                          *
*Comando para selecionar um arquivo.                                                                              *
*Parametro: GETF_LOCALFLOPPY - Inclui o floppy drive local.                                                       *
*           GETF_LOCALHARD   - Inclui o Harddisk local.                                                           *
*-----------------------------------------------------------------------------------------------------------------*
@ 041,140 BUTTON "..."            SIZE 013,013 PIXEL OF oDlgT   Action(c_dirimp := cGetFile("*.csv|*.csv","Importacao de Dados",0, ,.T.,GETF_LOCALHARD))

*-----------------------------------------------------------------------------------------------------------------*

@ 085,009 Button "OK"       Size 037,012 PIXEL OF oDlgT Action(_nOpc := 1,oDlgT:End())
@ 085,060 Button "Cancelar" Size 037,012 PIXEL OF oDlgT Action oDlgT:end()

ACTIVATE MSDIALOG oDlgT CENTERED

If _nOpc == 1
	cArquiv  := c_dirimp
    Processa({|| IMPORTA()  },"Atualizando matrículas FETRANSPOR")
Endif

Return


Static Function IMPORTA()                                  
	
FT_FUSE(cArquiv)
FT_FGOTOP()
ProcRegua(FT_FLASTREC())
nContLin := 0

/**************************************
* Inicio do Processamento do Arquivo  *
***************************************/
lAchou := .F.
If !FT_FEOF()
    FT_FSKIP()                  
Endif
While !FT_FEOF()
    
    cBuffer   := FT_FREADLN()
    cBufAux   := AllTrim(cBuffer)
    nContLin++
    IncProc()            
    nContCol := 1
		    
    While !Empty(cBufAux)
    // Layout do arquivo a ser importado. vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	//

        xPos := AT(";",cBufAux)
        
        Do Case 
            Case nContCol == 1         
                cXFilial  := Replace(SubSTR(cBufAux,1,xPos-1),"'","")
            Case nContCol == 3         
                cMat := Replace(SubSTR(cBufAux,1,xPos-1),"'","")
            Case nContCol == 6         
                cFetrans := SubSTR(cBufAux,1)
            Otherwise  
            
        EndCase            
        
        If xPos > 0    
            cBufAux := SubSTR(cBufAux,xPos+1)
        Else
            cBufAux := ""        
        Endif

        nContCol++
    EndDo             
    
	DbSelectArea("SRA")
	DbSetOrder(1)
	If DbSeek(cXFilial+cMat)
		RecLock("SRA",.F.)
		SRA->RA_XMATVT   := cFetrans		
		Msunlock()	
	Endif

	If !FT_FEOF()
	    FT_FSKIP()                  
    Endif
Enddo                                   

FT_FUSE()           

Return 