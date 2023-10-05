/*/

//Autor	  : Roberto Lima
-----------------------------------------------------------------------------
Data      : 04/02/2014
-----------------------------------------------------------------------------
Descricao : Geração de Arquivo Aumento Salariais
-----------------------------------------------------------------------------
Partida   : Menu de Usuario

/*/

#INCLUDE "RWMAKE.CH"
#include "colors.ch"
#include "protheus.ch"
#include "topconn.ch"

**********************
USER Function GERAUMENTO()
**********************

cPerg := Padr("GERAUMENTO",10,"")
aSx1  := {}

Aadd(aSx1,{"GRUPO","ORDEM","PERGUNT"                       ,"VARIAVL","TIPO","TAMANHO","DECIMAL","GSC","VALID"      ,"VAR01"   ,"F3"  ,"DEF01" ,"DEF02" ,"DEF03"  ,"DEF04"  ,"DEF05"   ,"HELP"      })
Aadd(aSx1,{cPerg  ,"01"   ,"Local de Gravacao............?","mv_ch1" ,"C"   ,30       ,0        ,"G"  ,"NaoVazio"   ,"mv_par01",""    ,""      ,""      ,""       ,""       ,""        ,""          })
Aadd(aSx1,{cPerg  ,"02"   ,"Filial De....................?","mv_ch2" ,"C"   ,04       ,0        ,"G"  ,""           ,"mv_par02","XM0" ,""      ,""      ,""       ,""       ,""        ,".RHFILDE." })
Aadd(aSx1,{cPerg  ,"03"   ,"Filial Ate...................?","mv_ch3" ,"C"   ,04       ,0        ,"G"  ,"NaoVazio"   ,"mv_par03","XM0" ,""      ,""      ,""       ,""       ,""        ,".RHFILAT." })
Aadd(aSx1,{cPerg  ,"04"   ,"Matricula De.................?","mv_ch4" ,"C"   ,06       ,0        ,"G"  ,""           ,"mv_par04","SRA" ,""      ,""      ,""       ,""       ,""        ,".RHMATD."  })
Aadd(aSx1,{cPerg  ,"05"   ,"Matricula Ate................?","mv_ch5" ,"C"   ,06       ,0        ,"G"  ,"NaoVazio"   ,"mv_par05","SRA" ,""      ,""      ,""       ,""       ,""        ,".RHMATA."  })
Aadd(aSx1,{cPerg  ,"06"   ,"Situacaoes...................?","mv_ch6" ,"C"   ,05       ,0        ,"G"  ,"fSituacao"  ,"mv_par06",""    ,""      ,""      ,""       ,""       ,""        ,".RHSITUA." })
Aadd(aSx1,{cPerg  ,"07"   ,"Categoria....................?","mv_ch7" ,"C"   ,15       ,0        ,"G"  ,"fCategoria" ,"mv_par07",""    ,""      ,""      ,""       ,""       ,""        ,".RHCATEG." })
Aadd(aSx1,{cPerg  ,"08"   ,"Tipos de Aumento.............?","mv_ch8" ,"C"   ,30       ,0        ,"G"  ,"U_ftpromo() ","mv_par08",""    ,""      ,""      ,""       ,""       ,""        ,""          })
Aadd(aSx1,{cPerg  ,"09"   ,"Data de......................?","mv_ch9" ,"D"   ,08       ,0        ,"G"  ,"NaoVazio"   ,"mv_par09","" ,""      ,""      ,""       ,""       ,""        ,""  })
Aadd(aSx1,{cPerg  ,"10"   ,"Data Ate.....................?","mv_cha" ,"D"   ,08       ,0        ,"G"  ,"NaoVazio"   ,"mv_par10","" ,""      ,""      ,""       ,""       ,""        ,""  })

fCriaSx1()

If !Pergunte(cPerg,.T.)
	Return
Endif

cPath := Alltrim(mv_par01)
cPath := If(Right(cPath,1) == "\",cPath,cPath+"\")

If ! ":" $ cPath
	MsgStop("Caminho Inválido !!!")
	Return
Endif



Processa({|| fPROMO()  , "Aguarde a geracão do Arquivo de Aumentos Salariais...  [Proc 1/2]"})

nRet := ShellExecute('Open',"AUMENTOSALARIAL.CSV",'',UPPER(alltrim(cPath)),1)
If nRet <= 32
	MsgStop("Não foi possível abrir o arquivo excel !!!")
Endif

Return

********************************
Static Function fPROMO()
********************************
//LOCAL cRaca    	:= ""
Local cCodFunc 	:= ""
Local cDescFunc	:= ""
Local cCarAux		:= ""



nArqTxt := MsFCreate(UPPER(cPath+Alltrim("AUMENTOSALARIAL.CSV")))

If nArqTxt == -1
	MsgStop("Erro na criação do arquivo "+Alltrim(mv_par01)+" : " + Alltrim(Str(fError())))
	Return
EndIF

ProcRegua(SRA->(RecCount()))

//CABECALHO

cDetArq := "Codigo C.Custo"                                                            +";"
cDetArq += "Desc.C.Custo"                                                              +";"
//cDetArq := "Filial"                                                                  +";"
cDetArq += "Nome"                                                                      +";"   // Nome Beneficiario
cDetArq += "Matricula"                                                                 +";"
cDetArq += "Cargo Anterior"                                                            +";"
cDetArq += "Data Alteracao de Cargo"                                                   +";"   
cDetArq += "Motivo"                                                                    +";"
cDetArq += "Cargo Atual"                                                               +";"
cDetArq += "Salario Anterior"                                                          +";"
//cDetArq += "Jornada Mensal"                                                          +";"
cDetArq += "Data Alteracao de Salario"                                                 +";"   
cDetArq += "Motivo"                                                                    +";"
cDetArq += "Salarial Atual"                                                            +";"


fWrite(nArqTxt,cDetArq+Chr(13)+Chr(10))

DBSELECTAREA("SR3") ; SR3->(DbSetOrder(1)) ;  SR3->(DbGoTop())
DBSELECTAREA("SR7") ; SR7->(DbSetOrder(1)) ;  SR7->(DbGoTop())
DBSELECTAREA("SRA") ; SRA->(DbSetOrder(1))   

cCtrl := ""

While SR3->(!Eof())
	
	
	SRA->(DBSEEK(SR3->R3_FILIAL+SR3->R3_MAT))
	
	If  (SR3->R3_FILIAL  < MV_PAR02) .Or. (SR3->R3_FILIAL > MV_PAR03) .Or. (SR3->R3_MAT     < MV_PAR04) .Or. (SR3->R3_MAT    > MV_PAR05)
		SR3->(DbSkip()) ; Loop
	EndIf
	
	IF SR3->R3_DATA < MV_PAR09 .OR. SR3->R3_DATA > MV_PAR10
	   SR3->(DbSkip()) ; Loop
	ENDIF 
	
	IncProc("Filial: "+SR3->R3_FILIAL+" - "+"Matricula: "+SR3->R3_MAT)
	
	
	If !SRA->RA_SITFOLH $ MV_PAR06
		SR3->(DbSkip()) ; Loop
	Endif
	
	
	If !SRA->RA_CATFUNC $ MV_PAR07
		SR3->(DbSkip()) ; Loop
	Endif                         
	
   IF !SR3->R3_TIPO $ MV_PAR08
		SR3->(DbSkip()) ; Loop
	ENDIF 
	
	
	IF SR3->R3_PD <> "000"
		SR3->(DbSkip()) ; Loop
	ENDIF
	
		
	
	dbselectArea("SRA")
	SRA->(DbSetOrder(1))
	SRA->(DBSEEK(SR3->R3_FILIAL+SR3->R3_MAT))
	
	CTIPO := ""
	If Empty(cCtrl)
		cCtrl := SR3->R3_FILIAL+SR3->R3_MAT
	Endif
							
	Do Case
		Case SR3->R3_TIPO = "001"
				CTIPO := "1"
					
		Case SR3->R3_TIPO = "002"
				CTIPO := "2"
					
		Case SR3->R3_TIPO = "003"
				CTIPO := "3"
					
		Case SR3->R3_TIPO = "004"
				CTIPO := "4"
					
		Case SR3->R3_TIPO = "005"
				CTIPO := "5"
					
		Case SR3->R3_TIPO = "006"
				CTIPO := "6"
					
		Case SR3->R3_TIPO = "007"
				CTIPO := "7"
					
		Case SR3->R3_TIPO = "008"
				CTIPO := "8"
					
		Case SR3->R3_TIPO = "009"
				CTIPO := "9"
					
		Case SR3->R3_TIPO = "010"
				CTIPO := "A"
					
		Case SR3->R3_TIPO = "011"
				CTIPO := "B"
				
		Case SR3->R3_TIPO = "012"
				CTIPO := "C"
					
		Case SR3->R3_TIPO = "013"
				CTIPO := "D"
					
		Case SR3->R3_TIPO = "014"
				CTIPO := "E"
					
		Case SR3->R3_TIPO = "015"
				CTIPO := "F"
					
		Case SR3->R3_TIPO = "016"
				CTIPO := "G"
					
		Case SR3->R3_TIPO = "017"
				CTIPO := "H"
					
		Case SR3->R3_TIPO = "018"
				CTIPO := "I"
	EndCase

	fBuscaFunc(DDATABASE, @cCodFunc, @cDescFunc   )  
	
	//aT :=  GetAnt(SRA->RA_FILIAL+SRA->RA_MAT,SR3->R3_DATA,1)
	//Alterado por Ricardo Ferreira em 07/05/2014, ajustar a função
	aT :=  GetAnt(SRA->RA_FILIAL+SRA->RA_MAT,SR3->R3_DATA,1) //PASSA A CHAVE
	If Len(aT) > 0
		cCarAnt := aT[1]
		nSalAnt := aT[2]
	Else
		cCarAnt := "XXX"
		nSalAnt := 0	
	Endif				

	
	aT	:= GetAnt(SRA->RA_FILIAL+SRA->RA_MAT,SR3->R3_DATA,2)
	If Len(aT) > 0
		cCarAux := aT[1]

	Else
		cCarAux := "XXX"
	
	Endif				
						
    cDetArq := "'"+PadR(SRA->RA_CC,15,"")                                             +";"  // CODIGO DO CENTRO DE CUSTO
	cDetArq += PadR(POSICIONE("CTT",1,XFILIAL("CTT")+SRA->RA_CC,"CTT_DESC01"),40,"")  +";"  // DESCRICAO DO CENTRO DE CUSTO
	cDetArq += PadR(SRA->RA_NOME,30,"")                                               +";"  // NOME DO FUNCIONARIO
	cDetArq += "'"+PadR(SRA->RA_MAT,06,"")                                            +";"  // MATRICULA DO FUNCIONARIO

  	cDetArq += PadR(POSICIONE("SRJ",1,XFILIAL("SRJ")+cCarAnt,"RJ_DESC"),30,"")  +";"  //cDescFuncAnt,30,"")                                                   // DESCRICAO DA FUNCAO ANTERIOR//SR7->R7_DESCFUN  +";"

  	//PadR(POSICIONE("SR7",1,XFILIAL("SR7")+SR3->R3_MAT,"R7_DESCFUN"),30,"")  +";"  //cDescFuncAnt,30,"")                                                   // DESCRICAO DA FUNCAO ANTERIOR
	cDetArq += fGravaData(SR3->R3_DATA)                                               +";"  // DATA DA ALTERACAO DE CARGO
	cDetArq += PadR(POSICIONE("SX5",1,XFILIAL("SX5")+"41"+SR3->R3_TIPO,"X5_DESCRI"),55,"") +";"  // TIPO DO AUMENTO

	//cDetArq += PadR(cDescFunc,30,"")                                                  +";"  // DESCRICAO DA FUNCAO ATUAL
//	cDetArq += PadR(POSICIONE("SRJ",1,XFILIAL("SRJ")+cCarAux,"RJ_DESC"),30,"")  +";" // DESCRICAO DA FUNCAO ATUAL
//Alterado por Ricardo Ferreira em 07/05/2014
	cDetArq += PadR(POSICIONE("SRJ",1,XFILIAL("SRJ")+cCarAux,"RJ_DESC"),30,"")  +";" // DESCRICAO DA FUNCAO ATUAL 
	//nSalAnt := fBuscaSal(SR3->R3_FILIAL,SR3->R3_MAT,SR3->R3_VALOR )
	cDetArq += TRANSFORM(nSalAnt,"@E 999,999,999.99")   +";"  // SALARIO ANTERIOR AO AUMENTO
	cDetArq += fGravaData(SR3->R3_DATA)                                               +";"  // DATA DA ALTERACAO DE CARGO
	cDetArq += PadR(POSICIONE("SX5",1,XFILIAL("SX5")+"41"+SR3->R3_TIPO,"X5_DESCRI"),55,"") +";"  // MOTIVO DA ALTERACÃO
	cDetArq += TRANSFORM(SR3->R3_VALOR,"@E 999,999,999.99")              +";"  // NOVO SALARIO	

	/*cDetArq := "'"+PadR(SRA->RA_FILIAL,04,"")                                         +";"  //CODIGO DA FILIAL
	cDetArq += "'"+PadR(SRA->RA_MAT,06,"")                                            +";"  // MATRICULA DO FUNCIONARIO
	cDetArq += PadR(SRA->RA_NOME,30,"")                                               +";"  // NOME DO FUNCIONARIO
	cDetArq += PadR(cDescFunc,30,"")                                                  +";"  // DESCRICAO DA FUNCAO
	cDetArq += "'"+PadR(SRA->RA_CC,15,"")                                             +";"  // CODIGO DO CENTRO DE CUSTO
	cDetArq += PadR(POSICIONE("CTT",1,XFILIAL("CTT")+SRA->RA_CC,"CTT_DESC01"),40,"")  +";"  // DESCRICAO DO CENTRO DE CUSTO
	//Se o salario for igual a salario anterior pega o salario anterior do anterior
	nSalAnt := fBuscaSal(SR3->R3_FILIAL,SR3->R3_MAT,SR3->R3_VALOR )
	cDetArq += TRANSFORM(nSalAnt,"@E 999,999,999.99")   +";"  // SALARIO ANTERIOR AO AUMENTO
	cDetArq += TRANSFORM(SRA->RA_HRSMES,"@E 999.99")    +";"  // NOVO SALARIO
	cDetArq += fGravaData(SR3->R3_DATA)                 +";"  // DATA DA ALTERACAO SALARIAL
	cDetArq += PadR(POSICIONE("SX5",1,XFILIAL("SX5")+"41"+SR3->R3_TIPO,"X5_DESCRI"),55,"") +";"  // TIPO DO AUMENTO
	cDetArq += TRANSFORM(SR3->R3_VALOR,"@E 999,999,999.99")              +";"  // NOVO SALARIO
*/

	fWrite(nArqTxt,cDetArq+Chr(13)+Chr(10))
			
	SR3->(DbSkip())
			
END

/*DBCLOSEAREA("SR3")
DBCLOSEAREA("SRA")
DBCLOSEAREA("SR7")*/

FClose(nArqTxt)

Return


Static Function GetAnt(cKey,cDt,nOp)
Local aX := {}
Local nRegR3 := SR3->(RECNO())
Local aArea 	:= GetArea()
//Local cMat
/*
//Alterado por Ricado Ferreira em 22/04/2014
//Motivo:  A query não estava considerando a filial e trazia resultado errado
cq := "SELECT RA_NOME, RA_CC, RA_MAT, R7_FUNCAO,R3_DATA , R3_VALOR "
cq += "  FROM "+RetSQLName("SRA")+" RA, "+RetSQLName("SR7")+" R7, "+RetSQLName("SR3")+" R3 "
cq += " WHERE RA_FILIAL+RA_MAT = '"+cKey+"' "
cq += " AND RA_MAT = R7_MAT "
cq += " AND R7_MAT = R3_MAT "
cq += " AND R3_DATA < '"+DToS(cDt)+"' "   
cq += " AND R7_DATA = R3_DATA "   
cq += " AND RA.D_E_L_E_T_ = ' ' "
cq += " AND R3.D_E_L_E_T_ = ' '  "
cq += " AND R7.D_E_L_E_T_ = ' '  "
cq += " ORDER BY R3_DATA DESC  "
*/

/*
cq := "SELECT RA_NOME, RA_CC, RA_MAT, R7_FUNCAO,R3_DATA , R3_VALOR "   
cq += "FROM "+RetSQLName("SRA")+" SRA "
cq += "		INNER JOIN "+RetSQLName("SR7")+" SR7 ON  "
cq += "			R7_FILIAL = RA_FILIAL AND R7_MAT = RA_MAT  AND SR7.D_E_L_E_T_  = ' ' "
cq += "		INNER JOIN "+RetSQLName("SR3")+" SR3 ON  "
cq += "			R3_FILIAL = R7_FILIAL AND R3_MAT = R7_MAT  AND  SR3.D_E_L_E_T_  = ' ' "
cq += "WHERE 	RA_FILIAL+RA_MAT = '"+cKey+"' " 
if nOp == 1
	cq += "		AND R3_DATA < '"+DToS(cDt)+"' "  
Elseif nOp == 2
	cq += "		AND R3_DATA = '"+DToS(cDt)+"' "  
Endif
cq += "		AND R7_DATA = R3_DATA "
cq += "		AND SRA.D_E_L_E_T_ = ' ' "  
cq += "ORDER BY R3_DATA DESC  "



TCQuery cq NEW ALIAS "GAU"

If GAU->(!EoF())
	aX := {GAU->R7_FUNCAO,GAU->R3_VALOR}
Endif

GAU->(DbCloseArea())
*/

DbSelectArea("SR3")
DbSetOrder(1)

If nOp = 1
//Posiciona no registro anterior
	SR3->(Dbskip(-1)	)
	
Endif
If cKey = SR3->(R3_FILIAL+R3_MAT)
	DbSelectArea("SR7")
	DbSetOrder(1)
	If Dbseek(SR3->(R3_FILIAL+R3_MAT+DTOS(R3_DATA)+R3_TIPO))
		aX := {SR7->R7_FUNCAO,SR3->R3_VALOR}
	Endif
Endif


RestArea(aArea)

DbselectArea("SR3")
DbSetOrder(1)
DbGoto(nRegR3)


Return aX


*********************************
Static Function fGravaData(dData)
*********************************

cData := GravaData(dData,.F.,5)
cRet  := Subs(cData,1,2)+"/"+Subs(cData,3,2)+"/"+Subs(cData,5,4)
Return(cRet)




 
**************************
Static Function fCriaSx1()
**************************
Local X1 := 0
local Z  := 0

//O código foi comentado pois em futuras versões do produto o alias SX1 não estará mais disponível para uso, sendo obrigatório o uso das API's padrões.

SX1->(DbSetOrder(1))

If SX1->(!DbSeek(cPerg+aSx1[Len(aSx1),2]))
	SX1->(DbSeek(cPerg)) 
	While SX1->(!Eof()) .And. Alltrim(&("SX1->X1_GRUPO")) == Alltrim(cPerg)
		SX1->(Reclock("SX1",.F.,.F.))
		SX1->(DbDelete())
		SX1->(MsunLock())
		SX1->(DbSkip())
	End
	For X1:=2 To Len(aSX1)
		SX1->(RecLock("SX1",.T.))
		For Z:=1 To Len(aSX1[1])
			cCampo := "X1_"+aSX1[1,Z]
			SX1->(FieldPut(FieldPos(cCampo),aSx1[X1,Z]))
		Next
		SX1->(MsunLock())
	Next
Endif
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ftpromo ³ Autor ³ Ze Maria			    ³ Data ³ 13/04/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Selecionar os tipos de aumentos               			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ ftpromo() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß/*/



User Function ftpromo(l1Elem,lTipoRet)

Local cTitulo:=""
Local MvPar
Local MvParDef:=""
Local cChave := &("SX5->X5_Chave")

Private aSit:={}
l1Elem := If (l1Elem = Nil , .F. , .T.)

DEFAULT lTipoRet := .T.

cAlias := Alias() 					 // Salva Alias Anterior

IF lTipoRet
	MvPar:=&(Alltrim(ReadVar()))		 // Carrega Nome da Variavel do Get em Questao
	mvRet:=Alltrim(ReadVar())			 // Iguala Nome da Variavel ao Nome variavel de Retorno
EndIF


dbSelectArea("SX5")
If dbSeek(cFilial+"0041")
	cTitulo := Alltrim(Left(X5Descri(),20))
Endif
If dbSeek(cFilial+"41")
	CursorWait()
	While !Eof() .And. &("SX5->X5_Tabela") == "41"
		Aadd(aSit,Left(cChave,3) + " - " + Alltrim(X5Descri()))
		MvParDef+=Left(cChave,3)
		dbSkip()
	Enddo
	CursorArrow()
Endif
IF lTipoRet
	IF f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,l1Elem,3,100)  // Chama funcao f_Opcoes            
	
		&MvRet := mvpar                                                                          // Devolve Resultado
	EndIF
EndIF

dbSelectArea(cAlias) 								 // Retorna Alias

Return( IF( lTipoRet , .T. , MvParDef ) )

STATIC FUNCTION fBuscaSal(FIL,MAT,VALOR ) 
LOCAL SALANT := 0

cQuery := "SELECT * FROM " + RetSqlName("SR3") +" "
cQuery += " WHERE  R3_FILIAL = '"+FIL+"' AND R3_MAT = '"+MAT+"' "    
cQuery += " AND D_E_L_E_T_ = ' ' AND R3_PD <> '000' " 
cQuery += " ORDER BY R3_VALOR " 
            

dbUseArea(.T.,"TopConn",TcGenQry(,,cQuery),"TRB",.T.,.T.)
aSalario := {}

dbSelectArea("TRB")
DbGoTop()

While ! eof() 

AADD(aSalario,{trb->R3_VALOR})                

trb->(DBSKIP())

END

nPos  := 0         
SALANT:= 0

if (nPos:=Ascan(aSalario,{|X| X[1]=VALOR})) > 0
   if nPos > 2 .and. aSalario[nPos-1,1] < VALOR
       SALANT:= aSalario[nPos-1,1]
   elseif nPos > 3 .and. aSalario[nPos-2,1] < VALOR
          SALANT:= aSalario[nPos-2,1]
   elseif nPos > 4 .and. aSalario[nPos-3,1] < VALOR
          SALANT:= aSalario[nPos-3,1]   
   endif   
ENDIF

trb->(DBCLOSEAREA())

RETURN(SALANT)
