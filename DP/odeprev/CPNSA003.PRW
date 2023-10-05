// #########################################################################################
// Projeto: ODEPREV
// Modulo : GESTÃO DE PESSOAL
// Fonte  : CPNSA001
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 09/10/13 | ROBERTO LIMA      | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------
// Gera arquivo de Interface Odeprev - Contrapartidas sobre Esporadicas. 
#include "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Montagem da tela de processamento

@author    TOTVS | Developer Studio - Gerado pelo Assistente de Código
@version   1.xx
@since     9/10/2013
/*/
//------------------------------------------------------------------------------------------
User Function CPNSA003()

Private cArqSaida   := ""
Private cPerg       := PADR("PGPE08",10)
Private cSeq        := "00000"
Private lAbortPrint := .F.
Private cCargo      := Space(22)
Private cContRegular, cContExpor := "000.000,00"
Private cContPatroA := "000.000,00"
Private cContParcB  := "000.000,00" 
Private _cMes   := Month(Date())
Private _cAno   := Year (Date()) 
 
ValidPerg()

Pergunte(cPerg,.F.)

@ 200,001 To 380,430 Dialog oDlg Title OemToAnsi("Geracao do Arquivo Movimentação Mensal")
@ 002,010 To 060,200
@ 10,017 Say OemToAnsi("Este programa ira gerar um arquivo texto")
@ 18,017 Say OemToAnsi("para ser enviado para a ODEPREV - Contrapartidas sobre Esporadicas.")

@ 70,095 BmpButton Type 01 Action Processa({|| FGeraTxt() })
@ 70,135 BmpButton Type 02 Action Close(oDlg)
@ 70,175 BmpButton Type 05 Action Pergunte(cPerg,.T.)

Activate Dialog oDlg Centered

Return


/*-----------------------------------------------------------------------*
* Funcao: FGeraTXT   | Autor | Roberto Lima            | Data | 09/10/13 *
*------------------------------------------------------------------------*
* Descrição: Criar um arquivo de Interface para a ODEPREV                *
*------------------------------------------------------------------------*/
Static Function FGeraTXT()

Local cNomeArq := AllTrim(mv_par08)+"\ODEPREVCPE"+SubStr(DTOS(mv_par07),5,2)+SubStr(DTOS(mv_par07),3,2)+".0"+(SM0->M0_CODIGO)
Local nHdl

If mv_par09=1 // Apaga o arquivo anterior
   If File(AllTrim(mv_par08)+"\ODEPREVCPE"+SubStr(DTOS(mv_par07),5,2)+SubStr(DTOS(mv_par07),3,2)+".0"+(SM0->M0_CODIGO))
      FErase(AllTrim(mv_par08)+"\ODEPREVCPE"+SubStr(DTOS(mv_par07),5,2)+SubStr(DTOS(mv_par07),3,2)+".0"+(SM0->M0_CODIGO))
   Endif   
   nHdl := FCreate(AllTrim(mv_par08)+"\ODEPREVE"+SubStr(DTOS(mv_par07),5,2)+SubStr(DTOS(mv_par07),3,2)+".0"+(SM0->M0_CODIGO))
Else
   If File(AllTrim(mv_par08)+"\ODEPREVCPE"+SubStr(DTOS(mv_par07),5,2)+SubStr(DTOS(mv_par07),3,2)+".0"+(SM0->M0_CODIGO))
      nHdl := FOpen(AllTrim(mv_par08)+"\ODEPREVCPE"+SubStr(DTOS(mv_par07),5,2)+SubStr(DTOS(mv_par07),3,2)+".0"+(SM0->M0_CODIGO),2) 
      FSeek(nHdl, 0, 2)
   Else
      nHdl := FCreate(AllTrim(mv_par08)+"\ODEPREVCPE"+SubStr(DTOS(mv_par07),5,2)+SubStr(DTOS(mv_par07),3,2)+".0"+(SM0->M0_CODIGO))
   EndIf    
EndIf  
cMesAno  := SubStr(DTOS(mv_par07),1,6)

If nHdl == -1
   MsgAlert("O arquivo "+cNomeArq+" nao pode ser criado! Verifique os parametros.","Atencao !")
   Return
Endif

DbSelectArea("SRA")
DbSetOrder(3)
dbGoTop()
ProcRegua(Reccount())
While !Eof() .And. (SRA->RA_FILIAL <= mv_par02)
   IncProc()
   If lAbortPrint
      Alert("Processo CANCELADO !")
      Exit
   Endif

   If ((SRA->RA_CC)  < mv_par03 .Or. (SRA->RA_CC)  > mv_par04) .or. ;
      ((SRA->RA_MAT) < mv_par05 .Or. (SRA->RA_MAT) > mv_par06) .or. ;
      !(SRA->RA_SITFOLH $ mv_par10)
      dbSkip()
      Loop
   EndIf
   If SRA->RA_XODEP <= 0
      dbSkip()
      Loop
   EndIf
   
   FRecDados()
   
   /* LINHA INSERIDA PARA CONTEMPLAR O CODIGO CNPJ (COMO ESTABELECIMENTO) DA EMPRESA 
      FELIPE DO NASCIMENTO - 24/09/2014 */
   cArea := getArea()
         
   SM0->(dbSetOrder(1))
   nRecnoSM0 := SM0->(Recno())
   SM0->(dbSeek(SUBS(cNumEmp,1,2)+SRA->RA_FILIAL))
      
   cSM0_CGC := subStr(SM0->M0_CGC, 10, 3)
  
   dbGoTo(nRecnoSM0)
   
   restArea(cArea)
   
   cLin := ""
   cLin += StrZero((_cMes),2)       // Mês  - 02
   cLin += StrZero((_cAno),4)		// Ano - 2013
  /* LINHA ABAIXO RETIRADO PARA ATENDER PELO PARAMETRO, ASSIM, CONTEMPLAR QUALQUER PATROCINADOR
     FELIPE DO NASCIMENTO 24/09/2014 */
//	  cLin += "234"                            // Patrocinadora - 110 (VERIFICAR COM O DEMERVAL)
   cLin += MV_PAR12  // Patrocinador 
//   cLin += "001"                    //SUBS(SRA->RA_CGC,14,2) // Estabelecimento - 001
   cLin += cSM0_CGC    // Estabelecimento - 001
   cLin += SUBS((SRA->RA_PIS),1,10)	// Nº do PIS - 1219934819
   cLin += SRA->RA_NOME + space(05)	// Nome do Participante - nome do participante nome do partic
   cLin += SRA->RA_CIC				// CPF - 46543570091
   cLin += cContExpor				// Contribuição Esporádica - 000000000000000,00
   cLin += cContPatroA  			// Contrapartida da Patrocinadora Parcela A  - 000000000000010,33
   cLin += cContParcB				// Contrapartida da Patrocinadora Parcela B - 000000000000022,73
   cLin += chr(13)+chr(10)
  
  
   If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
      MsgAlert("Ocorreu um erro na gravação do arquivo "+cNomeArq+".","Atencao !")
      Exit
   Endif

   DbSkip()
EndDo
DbSetOrder(3)
fClose(nHdl)

Close(oDlg)

Return


/*--------------------------------------------------------------------------*
* Função: FRecDados    | Autor | Roberto Lima            | Data | 09/10/13  *
*---------------------------------------------------------------------------*
* Descrição: Recuperar os Dados a "Gravados" no arquivo a ser gerado.       * 
*---------------------------------------------------------------------------*/
Static Function FRecDados()

// "Cargo" ...
DbSelectArea("SRJ")   
dbSetOrder(1)
cCargo := If(DbSeek(xFilial()+SRA->RA_CODFUNC),RJ_DESC+Space(2),Space(22))


DbSelectArea("SRC")   
dbSetOrder(1)

// Contribuição Regular
cContRegular := If(dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"615"),IF(LEN(ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".","")))==18,ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".","")),REPLICATE("0",(18-LEN(ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".","")))))+ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".",""))),"000000000000000.00")

// Contribuição Esporadica
cContExpor :=   If(dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"O06"),IF(LEN(ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".","")))==18,ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".","")),REPLICATE("0",(18-LEN(ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".","")))))+ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".",""))),"000000000000000.00")

// Contrapartida da Patrocinadora Parcela A
cContPatroA :=  If(dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"O01"),IF(LEN(ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".","")))==18,ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".","")),REPLICATE("0",(18-LEN(ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".","")))))+ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".",""))),"000000000000000.00")

// Contrapartida da Patrocinadora Parcela B
cContParcB :=  If(dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"O02"),IF(LEN(ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".","")))==18,ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".","")),REPLICATE("0",(18-LEN(ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".","")))))+ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".",""))),"000000000000000.00")

//Percentual Parcela B
cPerParcB := If(dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"O02"),IF(LEN(ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_HORAS,'@E 99.99')," ","0"),".","")))==5,ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_HORAS,'@E 99.99')," ","0"),".","")),REPLICATE("0",(5-LEN(ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_HORAS,'@E 99.99')," ","0"),".","")))))+ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_HORAS,'@E 99.99')," ","0"),".",""))),"00.00")

Return


/*--------------------------------------------------------------------------*
* Função: VALIDPERG    | Autor | Roberto Lima            | Data | 09/10/13  *
*---------------------------------------------------------------------------*
* Descrição: Verifica a existencia das perguntas criando-as caso seja       *
*            necessario (caso nao existam).                                 *
*---------------------------------------------------------------------------*/
Static Function ValidPerg

_sAlias := Alias()
aRegs   := {}

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)

// Grupo/Ordem/Pergunta///Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01///Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
Aadd(aRegs,{cPerg , "01" , "Da Filial          ?" ,"","", "mv_ch1" , "C" , 04 ,0 ,0 , "G" , ""         , "mv_par01" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","","SM0",""})
Aadd(aRegs,{cPerg , "02" , "Ate a Filial       ?" ,"","", "mv_ch2" , "C" , 04 ,0 ,0 , "G" , ""         , "mv_par02" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","","SM0",""})
Aadd(aRegs,{cPerg , "03" , "Do Centro de Custo ?" ,"","", "mv_ch3" , "C" , 09 ,0 ,0 , "G" , ""         , "mv_par03" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","","SI3",""})
Aadd(aRegs,{cPerg , "04" , "Ate o C. Custo     ?" ,"","", "mv_ch4" , "C" , 09 ,0 ,0 , "G" , ""         , "mv_par04" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","","SI3",""})
Aadd(aRegs,{cPerg , "05" , "Da Matricula       ?" ,"","", "mv_ch5" , "C" , 06 ,0 ,0 , "G" , ""         , "mv_par05" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","","SRA",""})
Aadd(aRegs,{cPerg , "06" , "Ate a Matricula    ?" ,"","", "mv_ch6" , "C" , 06 ,0 ,0 , "G" , ""         , "mv_par06" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","","SRA",""})
Aadd(aRegs,{cPerg , "07" , "Data Base          ?" ,"","", "mv_ch7" , "D" , 08 ,0 ,0 , "G" , "naovazio" , "mv_par07" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","",""   ,""})
Aadd(aRegs,{cPerg , "08" , "Local de Gravacao  ?" ,"","", "mv_ch8" , "C" , 20 ,0 ,0 , "G" , "naovazio" , "mv_par08" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","",""   ,""})
Aadd(aRegs,{cPerg , "09" , "Elimina Anterior   ?" ,"","", "mv_ch9" , "N" , 03 ,0 ,0 , "C" , ""         , "mv_par09" , "SIM" , "" , "" , "" , "" , "NAO", "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","",""   ,""})
Aadd(aRegs,{cPerg , "10" , "Situacao na Folha  ?" ,"","", "mv_ch10" ,"C" , 05 ,0 ,0 , "G" , "FSituacao", "mv_par10" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","",""   ,""})

/* LINHA INCLUIDA PARA ANTENDER QUALQUER EMPRESA
   POR FELIPE DO NASCIMENTO - 26/09/2014 */
Aadd(aRegs,{cPerg , "11" , "Cód. Patrocinadora?" ,"","", "mv_ch11" ,"C" , 03 ,0 ,0 , "G" , "naovazio()", "mv_par11" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","","",""})


For i:=1 to Len(aRegs)
   If !dbSeek(cPerg+aRegs[i,2])
      RecLock("SX1",.T.)
      For j:=1 to FCount()
         If j <= Len(aRegs[i])
            FieldPut(j,aRegs[i,j])
         Endif
      Next
      MsUnlock()
   Endif
Next
dbSelectArea(_sAlias)
Return
//--< fim de arquivo >----------------------------------------------------------------------