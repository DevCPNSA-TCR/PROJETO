#include "Protheus.ch" 

/*
-----------------------------------------------------------------------------------------------------
| FUN��O: PTNAF060                   | AUTOR: Felipe do Nascimento              | DATA: 28/03/2015  |
-----------------------------------------------------------------------------------------------------
| OBJETIVO: Rotina de automatiza��o de transfer�ncias de ativos imobilizados atrav�s de leitura de  |
|           arquivo .CSV conforme layout pr�-definido                                               |
|---------------------------------------------------------------------------------------------------|
|                                     CONTROLE DE REVIS�ES                                          |
-----------------------------------------------------------------------------------------------------
|    DATA    |         AUTOR          |                      OBJETIVO                               |
-----------------------------------------------------------------------------------------------------
| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
-----------------------------------------------------------------------------------------------------
*/


#DEFINE NLININI  2   // linha inicial de leitura do arquivo .CSV
#DEFINE NLINFIM  0   // linha final de leitura do arquivo .CSV. Quando especificado 0 ser� at� a �ltima linha
#DEFINE CCONDFIM ""  // condi��o que pode ser especificada para finalizar a leitura do .CSV

#DEFINE STR0001 "C�digo base do ativo n�o encontrado na tabela SN1"
#DEFINE STR0002 "C�digo base do ativo n�o encontrado na tabela SN3"
#DEFINE STR0003 "Ativo baixado n�o pode ser transferido"
#DEFINE STR0004 "Campo c�digo do bem � obrigat�rio"
#DEFINE STR0005 "Campo item do bem � obrigat�rio"
#DEFINE STR0006 "Conta cont�bil "
#DEFINE STR0007 "Centro de custo "
#DEFINE STR0008 "Item conta "
#DEFINE STR0009 "Classe valor "
#DEFINE STR0010 "do bem "
#DEFINE STR0011 "corre��o monet�ria "
#DEFINE STR0012 "despesa deprecia��o "
#DEFINE STR0013 "deprecia��o acumulada "
#DEFINE STR0014 "corre��o monet�ria deprecia��o "
#DEFINE STR0015 "inv�lido!"
#DEFINE STR0016 "Endere�o do bem inv�lido!"
#DEFINE STR0017 "Registro de N1_TAXAPAD invalido na tabela SNH!"
#DEFINE STR0018 "despesa "

user function PTNAF061
    
    local aSays := {}
    local aButtons := {}
    
    private cPerg  := "PTNAF060"
    private cFile
    private cTitulo  := "Processa transfer�ncia autom�tica de ativos. Com base em arquivo .CSV"
    private cTitulo1 := "Transferindo ativos"
    private lEnd := .f.
    private nOpca
    private aLogErro := {}
    private aParam := {}
    private lMsErroAuto := .f.	// Determina se houve alguma inconsist�ncia na execu��o da rotina execAuto    
    private cPath := GetSrvProfString("Startpath","")   

    // seguem abaixo layout que deve ser contemplado no .CSV
    //Cod. do Bem ;   item  ;  Local   ; Centro de Custo ; bem <Conta Contabil> ; correcao monetaria <Conta Contabil> ; despesa deprecia��o <Conta Contabil> ; deprecia��o acumulada do bem <Conta Contabil> ; corre��o da deprecia��o <Conta Contabil> ; bem <Centro de Custo> Para ; corre��o monetaria <Centro de Custo> ; despesa deprecia��o <Centro de Custo> ; deprecia��o acumulada do bem <Centro de Custo> ; corre��o da deprecia��o <Centro de Custo>
    // N3_CBASE   ; N3_ITEM ; N1_LOCAL ;    N3_CCUSTO    ;    N3_CCONTAB        ;          N3_CCORREC                 ;            N3_CDEPREC                ;                 N3_CCDEPR                     ;                N3_CDESP                  ;        N3_CUSTBEM          ;           N3_CCCORR                  ;              N3_CCDESP                ;                   N3_CCCDEP                    ;                 N3_CCCDES
    /********************Query do layout*****
    SELECT SN3.N3_CBASE,
    SN3.N3_ITEM,
    SN1.N1_LOCAL,
    SN3.N3_CCUSTO,
    SN3.N3_CCONTAB,
    SN3.N3_CCORREC, 
    SN3.N3_CDEPREC, 
    SN3.N3_CCDEPR, 
    SN3.N3_CDESP, 
    SN3.N3_CUSTBEM,
    SN3.N3_CCCORR,
    SN3.N3_CCDESP, 
    SN3.N3_CCCDEP, 
    SN3.N3_CCCDES
    FROM  SN3010 AS SN3 INNER JOIN SN1010 AS SN1 ON SN3.N3_FILIAL = SN1.N1_FILIAL AND SN3.N3_CBASE = SN1.N1_CBASE AND SN3.N3_ITEM = SN1.N1_ITEM 
    ***********************************/
        
    private N3CBASE   := 1  
    private N3ITEM    := 2
    private N1LOCAL   := 3
    private N3CCUSTO  := 4
    
    private N3CCONTAB := 5   // bem <Conta Contabil>
    private N3CCORREC := 6   // corre��o monetaria <Conta Contabil>
    private N3CDEPREC := 7   // despesa deprecia��o <Conta Contabil>
    private N3CCDEPR  := 8   // deprecia��o acumulada do bem <Conta Contabil>
    private N3CDESP   := 9   // corre��o da deprecia��o <Conta Contabil>
    
    private N3CUSTBEM := 10  // bem <Centro de Custo>
    private N3CCCORR  := 11  // corre��o monetaria <Centro de Custo>
    private N3CCDESP  := 12  // despesa deprecia��o <Centro de Custo>
    private N3CCCDEP  := 13  // deprecia��o acumulada do bem <Centro de Custo>
    private N3CCCDES  := 14  // corre��o da deprecia��o <Centro de Custo>
    
    private N3SUBCTA  := 15 
    private N3SUBCCOR := 16
    private N3SUBCDEP := 17
    private N3SUBCCDE := 18
    private N3SUBCDES := 19 
    
    private N3CLVLCON := 20
    private N3CLVLCOR := 21
    private N3CLVLDEP := 22
    private N3CLVLCDE := 23
    private N3CLVLDES := 24  
    
    private N1NFISCAL := 25
    private N1NSERIE  := 26
    private N1TAXAPAD := 27
    private NTOTCMAT  := 28
    
    criaSX1(cPerg)
    
   
    aAdd(aSays,OemToAnsi(cTitulo) )
    aAdd(aButtons, { 5,.t.,{|| Pergunte(cPerg,.t.)}})
    aAdd(aButtons, { 1,.t.,{|| nOpca := 1,FechaBatch()}})
    aAdd(aButtons, { 2,.t.,{|| nOpca := 2,FechaBatch()}})
    
    formBatch( cTitulo, aSays, aButtons )
    
    if nOpca == 1
      
       aADD(aParam, { "MV_PAR01", MV_PAR01, nil } )
       aADD(aParam, { "MV_PAR02", MV_PAR02, nil } )
       aADD(aParam, { "MV_PAR03", MV_PAR03, nil } )
       
       cFile := MV_PAR04
    
       Processa( {|lEnd| processCSV(@lEnd)},OemToAnsi(cTitulo1),,.t.)
       
    endif
    
return

*---------------------------------------------------------------------------------------------*
static function processCSV(lEnd)
*---------------------------------------------------------------------------------------------*
   local nLinAtu := 0
   local aDadosAuto := {}
   local cBuffer
   local _nTotal
   local aDados := {}
   local cErro
   local cCbase, cItem
   local lResult := .t.
   local cArqErro
   local cMsgLog, cAux
   local n,x
   
   if ! file(cFile)
      aviso("Aten��o", "Arquivo: "+cFile+" n�o encontrado!",{"OK"})
      lRet := .F.
      return(lRet)
   endif

   // Abre o Arquivo Texto

   nHandle := FT_FUSE(cFile)
   
   if nHandle = -1 // ocorreu erro de abertura do arquivo
       aviso("Aten��o", "Erro de abertura do arquivo: "+cFile+" !",{"OK"})
      lRet := .F.
      return(lRet)
   endif

   // Vai para o Inicio do Arquivo e Define o numero de Linhas para a Barra de Processamento.

   FT_FGOTOP()

   cBuffer  := FT_FREADLN()
   _nTotal  := FT_FLASTREC()

   procRegua(_nTotal)

   FT_FGOTOP()
   while ! FT_FEOF() //Percorre todo os itens do arquivo CSV.
   
	   incProc( "Lendo arquivo .CSV. Linha " + allTrim( str( ++nLinAtu ) ) + " de " + allTrim( str( _nTotal ) ) )
	   
       if Interrupcao(@lEnd); exit; endif
	   
       if nLinAtu < NLININI  // somente come�a leitura apos a linha indicada em nLinIni
	      FT_FSKIP()
	      loop
       endif
    	
       if NLINFIM <> 0 .and. nLinAtu == NLINFIM  // quando definido linha final aborta leitura do csv
          exit
       endif
    	
       // Faz a Leitura da Linha do Arquivo e atribui a Variavel cBuffer�
	   cBuffer := FT_FREADLN()
	
	   //Se j� passou por todos os registros da planilha "CSV" sai do While.
	   if empty(cBuffer)
	      exit
       endif
       	   
       aDados := {}
	   aADD(aDados,Separa(cBuffer,";",.T.))
	   
	   if ! empty(CCONDFIM) .and. eval(CCONDFIM)  // se existir uma condi��o para finaliza��o da leitura
 	      exit
	   endif
	   
	   if len(aDados[1]) < NTOTCMAT   // valida o tamanho da matriz. caso nao tenha todos os campos, ser�o preenchidos com ""
	      for x := 1 to NTOTCMAT - len(aDados[1])
	         aAdd(aDados[1], "")
	      next x
	   endif
	   
	   for x := 1 to len(aDados)
	      aDados[1, x] := allTrim(aDados[1, x])
	   next x

	   cCbase  := aDados[1,N3CBASE] + space(tamSX3("N3_CBASE")[1] - len(aDados[1, N3CBASE]))
	   cItem   := aDados[1,N3ITEM] + space(tamSX3("N3_ITEM")[1] - len(aDados[1, N3ITEM]))
	   
 	   dbSelectArea("SN1")
       SN1->(dbSetOrder(1))
       SN1->(DbSeek(xFilial("SN1") + cCbase + cItem ))
       
       if ! found()
           cErro := STR0001 // "C�digo base do ativo n�o encontrado na tabela SN1"
           aAdd( aLogErro, {cCbase + " - " + cItem, cErro, allTrim( str( nLinAtu ) ) } )
	       FT_FSKIP()
		   loop
       endif
       
       dbSelectArea("SN3")
       SN3->(dbSetOrder(1)) //N3_FILIAL+N3_CBASE+N3_ITEM+N3_TIPO+N3_BAIXA+N3_SEQ
       SN3->(DbSeek(xFilial("SN3") + cCbase + cItem ))

       if ! found()
           cErro := STR0002 // "C�digo base do ativo n�o encontrado na tabela SN3"
           aAdd( aLogErro, {cCbase + " - " + cItem, cErro, allTrim( str( nLinAtu ) ) } )
	       FT_FSKIP()
		   loop
       endif             
       
       if ! empty(SN3->N3_DTBAIXA) .or. SN3->N3_BAIXA # "0"   // item j� baixado
           cErro := STR0003 // "Ativo baixado n�o pode ser transferido"
           aAdd( aLogErro, {cCbase + " - " + cItem, cErro, allTrim( str( nLinAtu ) ) } )
	       FT_FSKIP()
		   loop
       endif
	   
	   if empty(aDados[1, N3CBASE])   // segundo campo obrigat�rio (CODIGO DO BEM)
	      cErro := STR0004 // "Campo codigo do bem � obrigat�rio"
   		  aAdd( aLogErro, {aDados[1, N3CBASE], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
	      loop
	   endif

	   if empty(aDados[1, N3ITEM])   // terceiro campo obrigat�rio (ITEM DO BEM)
	      cErro := STR0005 // "Campo item do bem � obrigat�rio"
   		  aAdd( aLogErro, {aDados[1, N3ITEM], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif
	   
	   if ! CTB105CTA(aDados[1, N3CCONTAB])
	      cErro := STR0006 + STR0010 + STR0015 // "Conta cont�bil " + "do bem " + "inv�lido!"
	      aAdd( aLogErro, {aDados[1, N3CCONTAB], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif
	   
	   if ! CTB105CTA(aDados[1, N3CCORREC])
          cErro := STR0006 + STR0011 + STR0015  // "Conta cont�bil " + " corre��o monet�ria " + " inv�lida!"
	      aAdd( aLogErro, {aDados[1, N3CCORREC], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

	   if ! CTB105CTA(aDados[1, N3CDEPREC])
          cErro := STR0006 + STR0012 + STR0015 // "Conta cont�bil " + " despesa deprecia��o " + " inv�lida!"
	      aAdd( aLogErro, {aDados[1, N3CDEPREC], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

	   if ! CTB105CTA(aDados[1, N3CCDEPR])
  	      cErro := STR0006 + STR0013 + STR0015  // "Conta cont�bil " + " deprecia��o acumulada " + " inv�lida!"
	      aAdd( aLogErro, {aDados[1, N3CCDEPR], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

	   if ! CTB105CTA(aDados[1, N3CDESP])
	      cErro := STR0006 + STR0014 + STR0015 // "Conta cont�bil " + " corre��o monet�ria deprecia��o " + " inv�lida! "
	      aAdd( aLogErro, {aDados[1, N3CDESP], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

       
       if ! CTB105CC(aDados[1, N3CCUSTO])
	      cErro := STR0007 + STR0018 + STR0015 // "Centro de custo " + " despesa " + "inv�lido!"
	      aAdd( aLogErro, {aDados[1, N3CCUSTO], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

	   if ! CTB105CC(aDados[1, N3CUSTBEM])
	      cErro := STR0007 + STR0010 + STR0015 // "Centro de custo " + " do bem " + "inv�lido!"
	      aAdd( aLogErro, {aDados[1, N3CUSTBEM], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

	   if ! CTB105CC(aDados[1, N3CCCORR])
	      cErro := STR0007 + STR0011 + STR0015 // "Centro de custo " + " corre��o monet�ria " + " inv�lido! "
	      aAdd( aLogErro, {aDados[1, N3CCCORR], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

	   if ! CTB105CC(aDados[1, N3CCDESP])
	      cErro := STR0007 + STR0012 + STR0015 // "Centro de custo " + " despesa deprecia��o " + " inv�lido! "
	      aAdd( aLogErro, {aDados[1, N3CCDESP], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

	   if ! CTB105CC(aDados[1, N3CCCDEP])
	      cErro := STR0007 + STR0013 + STR0015 // "Centro de custo " + " deprecia��o acumulada" + " inv�lido!"
	      aAdd( aLogErro, {aDados[1, N3CCCDEP], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

	   if ! CTB105CC(aDados[1, N3CCCDES])
	      cErro := STR0007 + STR0014 + STR0015 // "Centro de custo "  + " corre��o monet�ria deprecia��o " + " inv�lido!"
	      aAdd( aLogErro, {aDados[1, N3CCCDES], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

	   if ! CTB105Item(aDados[1, N3SUBCTA])
	      cErro := STR0008 + STR0010 + STR0015 // "Item conta " + " do bem " + "inv�lido!"
	      aAdd( aLogErro, {aDados[1, N3SUBCTA], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

	   if ! CTB105Item(aDados[1, N3SUBCCOR])
   	      cErro := STR0008 + STR0011 + STR0015 // "Item conta "  + " corre��o monet�ria " + " inv�lido!"
	      aAdd( aLogErro, {aDados[1, N3SUBCCOR], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

	   if ! CTB105Item(aDados[1, N3SUBCDEP])
   	      cErro := STR0008 + STR0012 + STR0015 // "Item conta " + "despesa deprecia��o " + " inv�lido!"
	      aAdd( aLogErro, {aDados[1, N3SUBCDEP], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

	   if ! CTB105Item(aDados[1, N3SUBCCDE])
  	      cErro := STR0008 + STR0013 + STR0015 // "Item conta " + " deprecia��o acumulada " + "inv�lido!"
	      aAdd( aLogErro, {aDados[1, N3SUBCCDE], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

	   if ! CTB105Item(aDados[1, N3SUBCDES])
	      cErro := STR0008 + STR0014 + STR0015 // "Item conta " + " corre��o monet�ria deprecia��o " + "inv�lido!"
	      aAdd( aLogErro, {aDados[1, N3SUBCDES], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

	   if ! CTB105CLVL(aDados[1, N3CLVLCON])
	      cErro := STR0009 + STR0010 + STR0015 // "Classe valor " + " do bem " + "inv�lido!"
	      aAdd( aLogErro, {aDados[1, N3CLVLCON], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

	   if ! CTB105CLVL(aDados[1, N3CLVLCOR])
	      cErro := STR0009 + STR0011 + STR0015 // "Classe valor " + "corre��o monet�ria " + "inv�lido!"
	      aAdd( aLogErro, {aDados[1, N3CLVLCOR], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

	   if ! CTB105CLVL(aDados[1, N3CLVLDEP])        	
	      cErro := STR0009 + STR0012 + STR0015 // "Classe valor " + "despesa deprecia��o " + "inv�lido!"
	      aAdd( aLogErro, {aDados[1, N3CLVLDEP], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

	   if ! CTB105CLVL(aDados[1, N3CLVLCDE])
	      cErro := STR0009 + STR0013 + STR0015 // "Classe valor " + "deprecia��o acumulada " + "inv�lido!"
	      aAdd( aLogErro, {aDados[1, N3CLVLCDE], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif

	   if ! CTB105CLVL(aDados[1, N3CLVLDES])
	      cErro := STR0009 + STR0014 + STR0015 // "Classe valor " + "corre��o monet�ria deprecia��o " + "inv�lido!"
	      aAdd( aLogErro, {aDados[1, N3CLVLDES], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif
	   
	   if ! PTN060VLoc(aDados[1, N1LOCAL])
	      cErro := STR0016 // "Endere�o do bem inv�lido!"
	      aAdd( aLogErro, {aDados[1, N1LOCAL], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   endif
	   
	   if ! empty(aDados[1, N1TAXAPAD]) .and. ExistCpo("SNH",aDados[1, N1TAXAPAD])
	      cErro := STR0017 // "Registro de N1_TAXAPAD invalido na tabela SNH!"
	      aAdd( aLogErro,{ aDados[1, N1TAXAPAD], cErro, allTrim( str( nLinAtu ) ) } )
		  FT_FSKIP()
		  loop
	   
       endif

       aDadosAuto := {}
       
       aAdd( aDadosAuto, { 'N3_FILIAL' , xFilial("SN3"), Nil } )
       aAdd( aDadosAuto, { 'N3_CBASE'  , cCbase, Nil } )          // C�digo base do ativo
	   aAdd( aDadosAuto, { 'N3_ITEM'   , cItem, Nil } )	          // Item sequencial do c�digo base do ativo
       aAdd( aDadosAuto, { 'N4_DATA'   , dDatabase, Nil } )	      // Data de aquisi��o do ativo
       aAdd( aDadosAuto, { 'N3_TIPO'   , SN3->N3_TIPO, Nil } )	
       aAdd( aDadosAuto, { 'N3_BAIXA'  , SN3->N3_BAIXA, Nil } )	
       aAdd( aDadosAuto, { 'N3_SEQ'    , SN3->N3_SEQ, Nil } )	
  
       aAdd( aDadosAuto, { 'N3_CCUSTO' ,;
              iif(!empty(aDados[1, N3CCUSTO]), aDados[1, N3CCUSTO], SN3->N3_CCUSTO), Nil } ) // Centro de Custo Despesa
        
       aAdd( aDadosAuto, { 'N3_CCONTAB' ,;
              iif(!empty(aDados[1, N3CCONTAB]), aDados[1, N3CCONTAB], SN3->N3_CCONTAB), Nil } ) // Conta Contabil
  	   aAdd( aDadosAuto, { 'N3_CCORREC' ,;
	          iif(!empty(aDados[1, N3CCORREC]), aDados[1, N3CCORREC], SN3->N3_CCORREC), Nil } ) // Conta de Correcao do Bem
       aAdd( aDadosAuto, { 'N3_CDEPREC' ,;
              iif(!empty(aDados[1, N3CDEPREC]), aDados[1, N3CDEPREC], SN3->N3_CDEPREC), Nil } ) // Conta Despesa Deprecia��o
       aAdd( aDadosAuto, { 'N3_CCDEPR'  ,;
              iif(!empty(aDados[1, N3CCDEPR]), aDados[1, N3CCDEPR], SN3->N3_CCDEPR), Nil } )	 // Conta Deprecia��o Acumulada
	   aAdd( aDadosAuto, { 'N3_CDESP'   ,;
	          iif(!empty(aDados[1, N3CDESP]), aDados[1, N3CDESP], SN3->N3_CDESP), Nil } )	 // Conta Corre��o Deprecia��o
	          
	   aAdd( aDadosAuto, { 'N3_CUSTBEM' ,;
	          iif(!empty(aDados[1, N3CUSTBEM]), aDados[1, N3CUSTBEM], SN3->N3_CUSTBEM), Nil } ) // Centro de Custo da Conta do Bem
       aAdd( aDadosAuto, { 'N3_CCCORR'  ,;
              iif(!empty(aDados[1, N3CCCORR]), aDados[1, N3CCCORR], SN3->N3_CCCORR), Nil } )	  // Centro Custo Corre��o Monet�ria
	   aAdd( aDadosAuto, { 'N3_CCDESP'  ,;
	          iif(!empty(aDados[1, N3CCDESP]), aDados[1, N3CCDESP], SN3->N3_CCDESP), Nil } )	  // Centro Custo Despesa Deprecia��o
	   aAdd( aDadosAuto, { 'N3_CCCDEP'  ,;
	          iif(!empty(aDados[1, N3CCCDEP]), aDados[1, N3CCCDEP], SN3->N3_CCCDEP), Nil } )	  // Centro Custo Despesa Acumulada
	   aAdd( aDadosAuto, { 'N3_CCCDES'  ,;                                                        
	          iif(!empty(aDados[1, N3CCCDES]), aDados[1, N3CCCDES], SN3->N3_CCCDES), Nil } )	  // Centro Custo Corre��o Depreciac�o
	          
       aAdd( aDadosAuto, { 'N3_SUBCTA' ,;
              iif(!empty(aDados[1, N3SUBCTA]), aDados[1, N3SUBCTA], SN3->N3_SUBCTA), Nil } )     // Item contabil da Conta do Bem
       aAdd( aDadosAuto, { 'N3_SUBCCOR',;
              iif(!empty(aDados[1, N3SUBCCOR]), aDados[1, N3SUBCCOR], SN3->N3_SUBCCOR), Nil } ) // Item contabil da Correcao Monetaria
	   aAdd( aDadosAuto, { 'N3_SUBCDEP',;
	          iif(!empty(aDados[1, N3SUBCDEP]), aDados[1, N3SUBCDEP], SN3->N3_SUBCDEP), Nil } )	// Item contabil da Despesa Depreciacao
	   aAdd( aDadosAuto, { 'N3_SUBCCDE',;
	          iif(!empty(aDados[1, N3SUBCCDE]), aDados[1, N3SUBCCDE], SN3->N3_SUBCCDE), Nil } )	// Item contabil da Despesa Acumulada
	   aAdd( aDadosAuto, { 'N3_SUBCDES',;
	          iif(!empty(aDados[1, N3SUBCDES]), aDados[1, N3SUBCDES], SN3->N3_SUBCDES), Nil } )	// Item contabil da Correcao Depreciacao
	          
	   aAdd( aDadosAuto, { 'N3_CLVLCON',;
	          iif(!empty(aDados[1, N3CLVLCON]), aDados[1, N3CLVLCON], SN3->N3_CLVLCON), Nil } )	// Classe de Valor da Conta do Bem
	   aAdd( aDadosAuto, { 'N3_CLVLCOR',;
	          iif(!empty(aDados[1, N3CLVLCOR]), aDados[1, N3CLVLCOR], SN3->N3_CLVLCOR), Nil } )	// Classe de Valor da Correcao Monetaria
	   aAdd( aDadosAuto, { 'N3_CLVLDEP',;
	          iif(!empty(aDados[1, N3CLVLDEP]), aDados[1, N3CLVLDEP], SN3->N3_CLVLDEP), Nil } )	// Classe de Valor da Despesa Depreciacao
	   aAdd( aDadosAuto, { 'N3_CLVLCDE',;
	          iif(!empty(aDados[1, N3CLVLCDE]), aDados[1, N3CLVLCDE], SN3->N3_CLVLCDE), Nil } )	// Classe de Valor da Despesa Acumulada
	   aAdd( aDadosAuto, { 'N3_CLVLDES',;
	          iif(!empty(aDados[1, N3CLVLDES]), aDados[1, N3CLVLDES], SN3->N3_CLVLDES), Nil } )	// Classe de Valor da Correcao Depreciacao
     
  	   aAdd( aDadosAuto, { 'N1_GRUPO', SN1->N1_GRUPO, Nil} )	 // Grupo do Bem
  
	   aAdd( aDadosAuto, { 'N1_LOCAL',;
              iif(!empty(aDados[1, N1LOCAL]), aDados[1, N1LOCAL], SN1->N1_LOCAL), Nil} )	 // Localizacao do Bem
    	   
	   aAdd( aDadosAuto, { 'N1_NFISCAL',;
	          iif(!empty(aDados[1, N1NFISCAL]), aDados[1, N1NFISCAL], SN1->N1_NFISCAL), Nil} )	// Numero da NF
       aAdd( aDadosAuto, { 'N1_NSERIE',;
              iif(!empty(aDados[1, N1NSERIE]),  aDados[1, N1NSERIE],  SN1->N1_NSERIE), Nil} )	// Serie da NF
          
       /*aAdd( aDadosAuto, { 'N1_TAXAPAD',;
	          iif(!empty(aDados[1, N1TAXAPAD]),  aDados[1, N1TAXAPAD], SN1->N1_TAXAPAD), Nil } )		// Codigo da Taxa Padrao
                  
         Caso deseje passar valores para os campos, Grupo, Local, NF/Serie Taxa padrao, considerar 
	     como no exemplo acima utilizando os campos correspondentes da tabela SN1.  
	     habilitar a estrutura para o campo N1_TAXAPAD somente qdo existir o cadastro na tabela SNG e SNH
	   */
	
   	   MSExecAuto({|x, y, z| AtfA060(x, y, z)},aDadosAuto, 4, aParam)
 	   //u_XATFA060(aDadosAuto, 4, aParam)
 	   
	   if lMsErroAuto  // ocorreu inconsist�ncia dentro do execauto
	      
	      mostraErro()
	      
	      cArqErro := "TESTEMS.LOG"
          mostraErro(cPath, cArqErro)
          cMsgLog := memoRead(cPath + cArqErro) // Carrega o log gravado
          
          cAux := ""
          for n := 1 to mlCount(cMsgLog)
             cAux += allTrim(memoLine(cMsgLog,, n)) + " "
          next n
           
          aAdd( aLogErro, {left(cAux, 150),"", allTrim( str( nLinAtu ) ) } )
           
          msErase(cArqErro)
    	  
	   endif
	   
       FT_FSKIP()
       
    enddo

    FT_FUSE()
    
    if len(aLogErro) > 0
       if Aviso("Aten��o", "Foram encontrados inconsist�ncias no processo de transfer�ncia. Deseja emitir o relat�rio?", {"Sim", "Nao"}, 1) == 1
          fMakeLog(aLogErro)
       endif
       lResult := .f.
    endif
    
    if lResult
        Aviso("Aviso", "Processo de transfer�ncia realizado com sucesso!", {"Ok"}) 
    endif

return                                            




/*
-----------------------------------------------------------------------------------------------------
| FUN��O: criaSX1                     | AUTOR: Felipe do Nascimento              | DATA: 23/12/2014 |
-----------------------------------------------------------------------------------------------------
| OBJETIVO: Fun��o para criar as perguntas da rotina PNATFR072                                      |
|                                                                                                   |
-----------------------------------------------------------------------------------------------------
|                                     CONTROLE DE REVIS�ES                                          |
-----------------------------------------------------------------------------------------------------
|    DATA    |         AUTOR          |                      OBJETIVO                               |
-----------------------------------------------------------------------------------------------------
| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
-----------------------------------------------------------------------------------------------------
*/
static function criaSX1(cPerg)
   local aHelpPor := {}
   local aHelpEng := {}
   local aHelpSpa := {}
   local aArea	:= GetArea()
   
   /*if SX1->(dbSeek(pad(cPerg,len(SX1->X1_GRUPO))+pad("24",len(SX1->X1_ORDEM)))) .and. empty(SX1->X1_DEF04)
      recLock("SX1",.F.)  
	  SX1->(dbDelete())
	  msUnLock()
   endif*/
   
   
   aHelpPor := {"Indica se a movimenta��o de","transferencia de ativos devera ou n�o", "ser contabilizada(efetuar o registro" ,;
                " cont�bil de acordo com as regras ", "definidas nos LP 830/831/832).", "contabiliza."}
   aHelpSpa := {}
   aHelpEng := {}
   putSX1(cPerg,"01","Contabiliza ?" , "�Contabiliza ?", "Record ?","mv_ch1","N",1,0,1,"C","","","","S","mv_par01","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")

   aHelpPor := {"Indica se o lan�amento cont�bil deve", "ser exibido, quando a contabiliza��o for on-line.","mostrar."}
   aHelpSpa := {}
   aHelpEng := {}
   putSX1(cPerg,"02","Mostra Lanc Contab ?" , "�Muestra Asientos ?", "Display Acc. Entry ?","mv_ch2","N",1,0,1,"C","","","","S","mv_par02","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")

   aHelpPor := {"Indica se o resultado da contabiliza��o", "deve ser aglutinado, utilizando como", "criterio de Conta + Centro de Custo + ",;
                "Item Cont�bil + Classe de Valor + Origem", "de lan�amentos iguais. ","algutina." }
   aHelpSpa := {}
   aHelpEng := {}
   putSX1(cPerg,"03","Aglut Lancamentos ?" , "�Agrupa Asientos ?", "Group ?","mv_ch3","N",1,0,1,"C","","","","S","mv_par03","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")

   aHelpPor := {"Informar o arquivo .CSV de origem para", "transfer�ncia","arquivo." }
   aHelpSpa := {}
   aHelpEng := {}
   putSX1(cPerg,"04","Arquivo ?" , "� Archivo ?", "File ?","mv_ch4","C",70,0,0,"G","u_getF060()","","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")


   restArea(aArea)
return

user function getF060()

  local cVar := alltrim(ReadVar())
  local cRet := cGetFile("Arquivo csv (*.csv) | *.csv",OemToAnsi("Selecione Diret�rio"),,"",.f.,GETF_LOCALHARD+GETF_NETWORKDRIVE,.f.)

  &cVar := cRet

return(.t.)


static function PTN060VLoc(cLocal)
   local lRet := .t.

   lRet := Vazio() .Or. ExistCpo( "SNL", cLocal )

return lRet


******************************************************************
static function fMakeLog(aLogErro)
******************************************************************

local cDesc1  := "Este programa tem como objetivo imprimir relatorio "
local cDesc2  := "de Inconsist�ncias."
local cDesc3  := ""
local cPict   := ""
local titulo  := "Inconsist�ncias da Transfer�ncia de Ativos"
local nLin    := 80

local Cabec1  := "Informa��o               Inconsist�ncia                                                          Linha"
local Cabec2  := ""
local imprime := .F.
local aOrd    := {} 

private lEnd         := .F.
private lAbortPrint  := .F.
private CbTxt        := ""   
private limite       := 80
private tamanho      := "M"
private nomeprog     := "PTNAF060C" // Coloque aqui o nome do programa para impressao no cabecalho
private nTipo        := 18
private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
private nLastKey     := 0
private cPerg        := ""
private cbtxt        := Space(10)
private cbcont       := 00
private CONTFL       := 01
private m_pag        := 01
private wnrel        := NomeProg // Coloque aqui o nome do arquivo usado para impressao em disco
private cString      := ""

//pergunte(cPerg,.F.)

wnrel := setPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

if nLastKey == 27
   return
endif

setDefault(aReturn,cString)

if nLastKey == 27
   return
endif

nTipo := iif(aReturn[4]==1,15,18)

rptStatus({|| runReport(Cabec1,Cabec2,Titulo,nLin, aLogErro) },Titulo)

return


**********************************************************************************************
static function runReport(cCabec1,cCabec2,cTitulo,nLin, aLogErro)
***********************************************************************************************
local x

for x := 1 to len(aLogErro)
	
	if lAbortPrint
		@ nLin,00 pSay "*** CANCELADO PELO OPERADOR ***"
		exit
	endif
	
	if nLin > 65
		cabec(cTitulo,cCabec1,cCabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	endif
	
	@ nLin,000 pSay allTrim(aLogErro[x][1])
	@ nLin,025 pSay allTrim(aLogErro[x][2])
	@ nLin,097 pSay allTrim(aLogErro[x][3])
	
	nLin++
next x

set device to screen

if aReturn[5]==1
	dbCommitAll()
	set printer to 
	ourSpool(wnrel)
endif

MS_FLUSH()

return



