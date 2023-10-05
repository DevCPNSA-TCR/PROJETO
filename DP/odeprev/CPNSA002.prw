// #########################################################################################
// Projeto: ODEPREV
// Modulo : GEST�O DE PESSOAL
// Fonte  : CPNSA002
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 09/10/13 | ROBERTO LIMA      | Developer Studio | Gerado pelo Assistente de C�digo
// ---------+-------------------+-----------------------------------------------------------
// Gera arquivo de Interface Odeprev - Ajustes de Contrapartida 
#include "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Montagem da tela de processamento

@author    TOTVS | Developer Studio - Gerado pelo Assistente de C�digo
@version   1.xx
@since     9/10/2013
/*/
//------------------------------------------------------------------------------------------
User Function CPNSA002()

Private cArqSaida   := ""
Private cPerg       := PADR("PGPE07",10)
Private cSeq        := "00000"
Private lAbortPrint := .F.
Private cCargo      := Space(22)
Private cEstcivil   := ""
Private cMesAno     := Space(06)
Private cContRegular, cContExpor := "000.000,00"
Private cContPatroA := "000.000,00"
Private cContParBC := "000.000,00" 
Private cPerParcB   := "00,00"
Private _cMes   := Month(Date())
Private _cAno   := Year (Date()) 
 
ValidPerg()

Pergunte(cPerg,.F.)

@ 200,001 To 380,430 Dialog oDlg Title OemToAnsi("Geracao do Arquivo Movimenta��o Mensal")
@ 002,010 To 060,200
@ 10,017 Say OemToAnsi("Este programa ira gerar um arquivo texto")
@ 18,017 Say OemToAnsi("para ser enviado para a ODEPREV - Ajustes de Contrapartida.")

@ 70,095 BmpButton Type 01 Action Processa({|| FGeraTxt() })
@ 70,135 BmpButton Type 02 Action Close(oDlg)
@ 70,175 BmpButton Type 05 Action Pergunte(cPerg,.T.)

Activate Dialog oDlg Centered

Return


/*-----------------------------------------------------------------------*
* Funcao: FGeraTXT   | Autor | Roberto Lima            | Data | 09/10/13 *
*------------------------------------------------------------------------*
* Descri��o: Criar um arquivo de Interface para a ODEPREV                *
*------------------------------------------------------------------------*/
Static Function FGeraTXT()

Local cNomeArq := AllTrim(mv_par08)+"\ODEPREVCP"+SubStr(DTOS(mv_par07),5,2)+SubStr(DTOS(mv_par07),3,2)+".0"+(SM0->M0_CODIGO)
Local nHdl

If mv_par09=1 // Apaga o arquivo anterior
   If File(AllTrim(mv_par08)+"\ODEPREVCP"+SubStr(DTOS(mv_par07),5,2)+SubStr(DTOS(mv_par07),3,2)+".0"+(SM0->M0_CODIGO))
      FErase(AllTrim(mv_par08)+"\ODEPREVCP"+SubStr(DTOS(mv_par07),5,2)+SubStr(DTOS(mv_par07),3,2)+".0"+(SM0->M0_CODIGO))
   Endif   
   nHdl := FCreate(AllTrim(mv_par08)+"\ODEPREVCP"+SubStr(DTOS(mv_par07),5,2)+SubStr(DTOS(mv_par07),3,2)+".0"+(SM0->M0_CODIGO))
Else
   If File(AllTrim(mv_par08)+"\ODEPREVCP"+SubStr(DTOS(mv_par07),5,2)+SubStr(DTOS(mv_par07),3,2)+".0"+(SM0->M0_CODIGO))
      nHdl := FOpen(AllTrim(mv_par08)+"\ODEPREVCP"+SubStr(DTOS(mv_par07),5,2)+SubStr(DTOS(mv_par07),3,2)+".0"+(SM0->M0_CODIGO),2) 
      FSeek(nHdl, 0, 2)
   Else
      nHdl := FCreate(AllTrim(mv_par08)+"\ODEPREVCP"+SubStr(DTOS(mv_par07),5,2)+SubStr(DTOS(mv_par07),3,2)+".0"+(SM0->M0_CODIGO))
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
   
   DbSelectArea("SRA")   
   
   cLin := ""
   cLin += StrZero((_cMes),2)            // M�s  - 02
   cLin += StrZero((_cAno),4)			// Ano - 2013
   cLin += SUBS((SRA->RA_PIS),1,10)		// N� do PIS - 1219934819
   cLin += SRA->RA_NOME + space(05)	   	// Nome do Participante - nome do participante nome do partic
   cLin += cContParBC				    // Contrapartida da Patrocinadora Parcela B - 000000000000022,73
   cLin += "+ OU - " // OU  - //SINAL DO AJUSTE
   cLin += cContParBC  				// Ajustes de Contrapartida B e C do exerc�cio anterior  
   cLin += "+ OU  -" //SINAL DO AJUSTE 
   cLin += "Registro das datas (mm/aaaa = m�s/ano) ou per�odo (mm/aaaa a mm/aaaa) a que o ajuste se refere,  o tipo de Contrapartida que est� sendo creditada,  e o que foi corrigido"//CRIAR CAMPO OBSERVA��O
   cLin += chr(13)+chr(10)
  
  
   If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
      MsgAlert("Ocorreu um erro na grava��o do arquivo "+cNomeArq+".","Atencao !")
      Exit
   Endif

   DbSkip()
EndDo
DbSetOrder(3)
fClose(nHdl)

Close(oDlg)

Return


/*--------------------------------------------------------------------------*
* Fun��o: FRecDados    | Autor | Roberto Lima            | Data | 09/10/13  *
*---------------------------------------------------------------------------*
* Descri��o: Recuperar os Dados a "Gravados" no arquivo a ser gerado.       * 
*---------------------------------------------------------------------------*/
Static Function FRecDados()

// "Cargo" ...
DbSelectArea("SRJ")   
dbSetOrder(1)
cCargo := If(DbSeek(xFilial()+SRA->RA_CODFUNC),RJ_DESC+Space(2),Space(22))


DbSelectArea("SRC")   
dbSetOrder(1)

// Contrapartida da Patrocinadora Parcela A
cContPatroA :=  If(dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"O01"),IF(LEN(ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".","")))==18,ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".","")),REPLICATE("0",(18-LEN(ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".","")))))+ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".",""))),"000000000000000.00")

// Contrapartida da Patrocinadora Parcela B
cContParBC :=  If(dbSeek(SRA->RA_FILIAL+SRA->RA_MAT+"O02"),IF(LEN(ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".","")))==18,ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".","")),REPLICATE("0",(18-LEN(ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".","")))))+ALLTRIM(STRTRAN(STRTRAN(TRANSFORM(SRC->RC_VALOR,'@E 999,999,999.99')," ","0"),".",""))),"000000000000000.00")

Return


/*--------------------------------------------------------------------------*
* Fun��o: VALIDPERG    | Autor | Roberto Lima            | Data | 09/10/13  *
*---------------------------------------------------------------------------*
* Descri��o: Verifica a existencia das perguntas criando-as caso seja       *
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