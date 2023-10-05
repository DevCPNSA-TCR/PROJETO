#include "Protheus.ch"
#include "PNATF072.ch"
/*
-----------------------------------------------------------------------------------------------------
| FUNÇÃO: PNATFR072                   | AUTOR: Felipe do Nascimento              | DATA: 07/01/2015 |
-----------------------------------------------------------------------------------------------------
| OBJETIVO: Relatório posição valorizada dos bens na data. Layout especifico Porto Novo.            |
|           Somente será considerado a moeda 1 e uma única filial.                                  |                                                                                                   
|           Utilizado função ATFGERSLDM nativa do Protheus para geração do saldo do bem na data     |
|           Mantendo integridade dos dados.                                                         |
|           Os últimos campos representam a último movimentação do bem.                             |
|---------------------------------------------------------------------------------------------------|
|                                     CONTROLE DE REVISÕES                                          |
-----------------------------------------------------------------------------------------------------
|    DATA    |         AUTOR          |                      OBJETIVO                               |
-----------------------------------------------------------------------------------------------------
| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
-----------------------------------------------------------------------------------------------------
*/

#define _LF chr(32)+chr(13)

user function PNATFR072()
//user function PNAR072()
   
   local lTReport	 := findFunction("TRepInUse") .and. TRepInUse()
   local lDefTop 	 := iif( findFunction("IfDefTopCTB"), IfDefTopCTB(), .F.) // verificar se pode executar query (TOPCONN)
   
   /* variaveis utilizadas como parametros da função ATFGERSLDM */
   Private oReport
   private aSelFil	 := {}
   private aSelMoed  := {} 
   private aSelClass := {} 
   private lTodasFil := .f.
   private cPerg     := "PNAFR072"

   criaSX1(cPerg)

   if !lDefTop
      help("  ",1,"PNAFR072TOP",,STR0001 ,1,0) //"Função disponível apenas para ambientes TopConnect"
	  return
   endif

   if !lTReport
      help("  ",1,"PNAFR072R4",,STR0043,1,0) //"Função disponível apenas para ambientes TopConnect"
	  return
   endif

   lRet := pergunte( cPerg , .T. )
	
   oReport := ReportDef()
   oReport:PrintDialog()
	
return

*------------------------------------------------------
static function ReportDef()
*------------------------------------------------------
   local oSecBem

   local cReport := "PNATFR072"
   local cTitulo :=	OemToAnsi(STR0003)	        // "Posicao Valorizada dos Bens na Data"
   local cDescri :=	OemToAnsi(STR0004) + " " +;	// "Este programa ir  emitir a posiçãoo valorizada dos"
                    OemToAnsi(STR0005) + " "   	// "bens em ate 5 (cinco) moedas."
                    
   local aOrd	 := { OemToAnsi(STR0006), OemToAnsi(STR0007) }//"Código do Bem"##"Aquisição"
   local bReport := {}

   bReport := { |oReport|	oReport:SetTitle( oReport:Title() + OemtoAnsi(STR0010) + aOrd[oSecBem:GetOrder()] ),;//" por "
   prtAnalitico( oReport ) }

   oReport  := TReport():New( cReport, cTitulo, cPerg, bReport, cDescri )

   oSecBem := TRSection():New( oReport,  STR0015, {}, aOrd ) // "Dados da Entidade"
   TRCell():New( oSecBem, "N3_FILIAL",    "SN3", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New( oSecBem, "N1_AQUISIC",   "SN1", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New( oSecBem, "N3_CBASE",     "SN3", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New( oSecBem, "N3_ITEM",      "SN3", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New( oSecBem, "N1_CHAPA",     "SN1", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New( oSecBem, "N1_NFISCAL",   "SN1", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New( oSecBem, "N1_DESCRIC",   "SN1", /*X3Titulo*/, /*Picture*/, 14 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/,,.T.,,,,.T.)
   TRCell():New( oSecBem, "N1_QUANTD",    "SN1", /*X3Titulo*/, PesqPict("SN1","N1_QUANTD",11) /*Picture*/, 11 /*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/)
//   TRCell():New( oSecBem, "VLATUALIZADO", "SN3", STR0017/*X3Titulo*/, PesqPict("SN3","N3_VORIG1" ,19,1) /*Picture*/, 19 /*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/)  //"Valor Original"
   TRCell():New( oSecBem, "N3_VORIG1",    "",    STR0017 /*X3Titulo*/,/*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  //"Valor Original"
   TRCell():New( oSecBem, "N3_AMPLIA1",   "SN3", STR0018 /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)// "Val Amplia"
   TRCell():New( oSecBem, "VLATUA_AMPLI", "",    STR0008 /*X3Titulo*/, PesqPict("SN3","N3_VORIG1" ,19,1) /*Picture*/, 19 /*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/)// "V Orig + V Ampli"
   TRCell():New( oSecBem, "VLRESIDUAL",   "",    STR0021 /*X3Titulo*/, PesqPict("SN3","N3_VORIG1" ,19,1) /*Picture*/, 19 /*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/)  //"Valor Residual"
   TRCell():New( oSecBem, "N3_VRDACM1",   "SN3", STR0020 /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/)  //"Deprec. Acumulada"
//   TRCell():New( oSecBem, "N3_VRDMES1",   "SN3", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/)
   TRCell():New( oSecBem, "N3VRDMES1",     "",   STR0022 /*X3Titulo*/, PesqPict("SN3","N3_VRDMES1" ,19,1) /*Picture*/, 19 /*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/)
//   TRCell():New( oSecBem, "N3_LOCAL",     "SN3", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  
   TRCell():New( oSecBem, "NL_DESCRIC",   "SNL", "Desc. Local" /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)  // "Desc. Local"
   TRCell():New( oSecBem, "N1_BAIXA",     "SN1", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)   
   TRCell():New( oSecBem, "N1_XNUMSER",   "SN1", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)   
   TRCell():New( oSecBem, "N1_GRUPO",     "SN1", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)   
   TRCell():New( oSecBem, "N3_CCONTAB",   "SN3", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/)
   TRCell():New( oSecBem, "N3_CCDEPR",    "SN3", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New( oSecBem, "N3_CDEPREC",   "SN3", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New( oSecBem, "N3_TXDEPR1",   "SN3", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New( oSecBem, "N3_TIPODESC",  "SN3", STR0016, /*Picture*/,14 /*Tamanho*/,/*lPixel*/, /*{|| code-block de impressao }*/) //"Descrição Tipo"   
   TRCell():New( oSecBem, "N1_PATRIM",    "SN1", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New( oSecBem, "N1_FORNEC",    "SN1",  /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) 
   TRCell():New( oSecBem, "A2_NOME",      "SA2", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New( oSecBem, "N3_CUSTBEM",   "SN3", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New( oSecBem, "N3_DINDEPR",   "SN3", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New( oSecBem, "N3_FIMDEPR",   "SN3", /*X3Titulo*/, /*Picture*/, /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
   TRCell():New( oSecBem, "N4OCORR",     "SN4", STR0019, /*Picture*/, 70 /*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/) // "Informacoes Ult. Transf."

   oSecBem:SetHeaderPage(.t.)

   oSecBem:Cell("N1_QUANTD"):SetHeaderAlign("RIGHT")
//   oSecBem:Cell("VLATUALIZADO"):SetHeaderAlign("RIGHT")
   oSecBem:Cell("N3_VORIG1"):SetHeaderAlign("RIGHT")
   oSecBem:Cell("N3_AMPLIA1"):SetHeaderAlign("RIGHT")
   oSecBem:Cell("VLATUA_AMPLI"):SetHeaderAlign("RIGHT")   
   oSecBem:Cell("VLRESIDUAL"):SetHeaderAlign("RIGHT")
   oSecBem:Cell("N3_VRDACM1"):SetHeaderAlign("RIGHT")
   oSecBem:Cell("N3VRDMES1"):SetHeaderAlign("RIGHT")

   TRFunction():New(oSecBem:cell("N1_QUANTD"),,"SUM",/*break*/, /*cTitle*/, /*cPicture*/, /*uFormula*/, .f. /*lEndSection*/,;
                                               .t. /*lEndReport*/, .f. /*lEndPage*/)

//   TRFunction():New(oSecBem:cell("VLATUALIZADO"),,"SUM",/*break*/, /*cTitle*/, /*cPicture*/, /*uFormula*/, .f. /*lEndSection*/,;
//                                               .t. /*lEndReport*/, .f. /*lEndPage*/)

   TRFunction():New(oSecBem:cell("N3_VORIG1"),,"SUM",/*break*/, /*cTitle*/, /*cPicture*/, /*uFormula*/, .f. /*lEndSection*/,;
                                               .t. /*lEndReport*/, .f. /*lEndPage*/)
   
   TRFunction():New(oSecBem:cell("N3_AMPLIA1"),,"SUM",/*break*/, /*cTitle*/, /*cPicture*/, /*uFormula*/, .f. /*lEndSection*/,;
                                               .t. /*lEndReport*/, .f. /*lEndPage*/)
   
   TRFunction():New(oSecBem:cell("VLATUA_AMPLI"),,"SUM",/*break*/, /*cTitle*/, /*cPicture*/, /*uFormula*/, .f. /*lEndSection*/,;
                                               .t. /*lEndReport*/, .f. /*lEndPage*/)
   
   TRFunction():New(oSecBem:cell("VLRESIDUAL"),,"SUM",/*break*/, /*cTitle*/, /*cPicture*/, /*uFormula*/, .f. /*lEndSection*/,;
                                               .t. /*lEndReport*/, .f. /*lEndPage*/)
   
   TRFunction():New(oSecBem:cell("N3_VRDACM1"),,"SUM",/*break*/, /*cTitle*/, /*cPicture*/, /*uFormula*/, .f. /*lEndSection*/,;
                                               .t. /*lEndReport*/, .f. /*lEndPage*/)

   TRFunction():New(oSecBem:cell("N3VRDMES1"),,"SUM",/*break*/, /*cTitle*/, /*cPicture*/, /*uFormula*/, .f. /*lEndSection*/,;
                                               .t. /*lEndReport*/, .f. /*lEndPage*/)
   
   oSecBem:SetColSpace(2)
   oSecBem:SetLineBreak(.t.)
   
   oReport:SetTotalInLine(.f.)
   oReport:SetLandScape()
   oReport:ParamReadOnly()
   oReport:DisableOrientation()

return oReport

*-------------------------------------------------------
static Function PrtAnalitico( oReport )
*-------------------------------------------------------
   local oSecBem     := oReport:Section(1)
   local oMeter
   local oText
   local oDlg
   local lEnd
   local cAliasQry 	:= getNextAlias()
   local cOcorre
   //local lFlag
   local lDebug := .f.  // liga qdo estiver debugando para visualizar a query
   local cQry, cQry2, cWhere, cWhere2, cOrder
   local cTMP := getNextAlias()
      
   // variaveis dos parametros
   local cFil_MV    := MV_PAR01
   local dDataSLD   := MV_PAR02
   local dAquIni    := MV_PAR03
   local dAquFim    := MV_PAR04
   local cGrupoIni  := MV_PAR05
   local cGrupoFim  := MV_PAR06
   local cContaIni  := MV_PAR07
   local cContaFim  := MV_PAR08
   local cBemIni   	:= MV_PAR09
   local cItemIni  	:= MV_PAR10
   local cBemFim   	:= MV_PAR11
   local cItemFim  	:= MV_PAR12

   local aTipo		:= {}          // tipo de total a ser impresso, vazio para todos. Utilizado na função ATFGERSLDM.
   local cChave		:= ""
   local nTipoEnt	:= oSecBem:GetOrder() 
   local cCabCond1 	:= ""
   local n_pagIni   := 1    // folha inicial
   local n_pagFim   := 0    // folha final
   local n_pagRes   := 0    // número de página para reiniciar
   local lRealProv  := .t.  // demonstrar os ativos que estão relacionados a uma provisão. Utilizado na função ATFGERSLDM.
   
   /* variaveis utilizadas como parametros da função ATFGERSLDM */
   local cCCIni    := space(tamSX3("CTT_CUSTO")[1])
   local cCCFim    := replicate("Z", tamSX3("CTT_CUSTO")[1])
   local cItCtbIni := space(tamSX3("CTD_ITEM")[1])
   local cItCtbFim := replicate("Z", tamSX3("CTD_ITEM")[1])
   local cClvlIni  := space(tamSX3("CTH_CLVL")[1])
   local cClVlFim  := replicate("Z", tamSX3("CTH_CLVL")[1])
   local cTipoSLD  := "1"

   aSelFil  := iif(empty(aSelFil), {cFil_MV}, aSelFil)  // tratar para considerar uma única filial. Usado na função ATFGERSLDM.
   aSelMoed := iif(empty(aSelMoed), {"01"}, aSelMoed)   // moeda utiliza. Utilizado na função ATFGERSLDM. Apenas Real.

   //Ordem do Arquivo
   if nTipoEnt == 1
      cChave := "FILIAL+CBASE+ITEM"
	  cCabCond1 := OemToAnsi("Código Bem   : ") //"Código Bem   : "
   elseif nTipoEnt == 2
      cChave := "FILIAL+DTOS(AQUISIC)"
	  cCabCond1 := OemToAnsi("Aquisição : ") //"Aquisição : "
   endif

   //Controle de reincio da numeracao de paginas
   oReport:SetPageNumber(n_pagIni)
   oReport:OnPageBreak( {|| iif((n_pagIni+1) > n_pagFim, (n_pagIni := n_pagRes,oReport:SetPageNumber(n_pagIni-1)),n_pagIni += 1) } )
   
   // posicionar os registros das tabelas. variaveis utilizadas no setblock das celulas
   TRPosition():New(oSecBem,"SN1",1,{||xFilial("SN1")+(cAliasQry)->CBASE+(cAliasQry)->ITEM})
   TRPosition():New(oSecBem,"SN3",1,{||xFilial("SN3")+(cAliasQry)->CBASE+(cAliasQry)->ITEM})
   TRPosition():New(oSecBem,"SA2",1,{||xFilial("SA2")+SN1->N1_FORNEC+SN1->N1_LOJA})
   TRPosition():New(oSecBem,"SX5",1,{||xFilial("SX5") + "G1"+ (cAliasQry)->TIPO})
   TRPosition():New(oSecBem,"SNL",1,{||xFilial("SNL")+SN1->N1_LOCAL})

   oSecBem:Cell("N1_NFISCAL"):SetBlock({|| SN1->N1_NSERIE + iif(!empty(SN1->N1_NSERIE) .and. !empty(SN1->N1_NFISCAL), " - ", "") + SN1->N1_NFISCAL} )     	  
   oSecBem:Cell("N1_QUANTD"):SetBlock({|| (cAliasQry)->QUANTD } ) 
//   oSecBem:Cell("VLATUALIZADO"):SetBlock( { || (cAliasQry)->ATUALIZ } )    	  
   oSecBem:Cell("N3_VORIG1"):SetBlock( { || (cAliasQry)->ORIGINAL } )    	  
   oSecBem:Cell("N3_AMPLIA1"):SetBlock( { || (cAliasQry)->AMPLIACAO } )    
   oSecBem:Cell("VLATUA_AMPLI"):SetBlock( { || (cAliasQry)->ORIGINAL+(cAliasQry)->AMPLIACAO } )
   oSecBem:Cell("VLRESIDUAL"):SetBlock( { || (cAliasQry)->RESIDUAL } )  
   oSecBem:Cell("N3_VRDACM1"):SetBlock( { || (cAliasQry)->DEPRECACM } ) 
   oSecBem:Cell("N3VRDMES1"):SetBlock( { || iif(SN3->N3_DINDEPR > dDataSLD, 0, SN3->N3_VRDMES1) } )    
   oSecBem:Cell("N3_TIPODESC"):SetBlock({|| X5Descri() } )                               
   oSecBem:Cell("N3_CCONTAB"):SetBlock({|| (cAliasQry)->CONTA } )
   oSecBem:Cell("N1_FORNEC"):SetBlock( { || SN1->N1_FORNEC + iif(!empty(SN1->N1_FORNEC) .and. !empty(SN1->N1_LOJA), " - ", "") + SN1->N1_LOJA } )
   oSecBem:Cell("N4OCORR"):SetBlock({|| cOcorre } )
   oSecBem:Cell("N3_CUSTBEM"):SetBlock({|| (cAliasQry)->CCUSTO } ) 
  
   // Monta Arquivo Temporario para Impressao (função nativa Protheus)
   MsgMeter({|	oMeter, oText, oDlg, lEnd | ;
   ATFGERSLDM(oMeter,oText,oDlg,lEnd,cAliasQry,dAquIni,dAquFim,dDataSLD,cBemIni,cBemFim,cItemIni,cItemFim,cContaIni,cContaFim,;
   cCCIni,cCCFim,cItCtbIni,cItCtbFim,cClvlIni,cClVlFim,cGrupoIni,cGrupoFim,aSelMoed,aSelFil,lTodasFil,cChave,.t.,aTipo,nil,nil,cTipoSLD,aSelClass,lRealProv) },;
   OemToAnsi(OemToAnsi(STR0034)),; //"Criando Arquivo Temporário..."
   OemToAnsi(STR0035))//"Posicao Valorizada dos Bens na Data"

   // Estrutura do Arquivo
   /*
   FILIAL CBASE ITEM MOEDA	CLASSIF TIPO DESC_SINT AQUISIC DTBAIXA DTSALDO CHAPA GRUPO CONTA CCUSTO SUBCTA CLVL QUANTD ORIGINAL AMPLIACAO ATUALIZ DEPRECACM
   RESIDUAL CORRECACM CORDEPACM VLBAIXAS
   */
   
   cQry := ""
   cQry += _LF + " SELECT SN4.N4_FILIAL, SN4.N4_CBASE, SN4.N4_ITEM, SN4.N4_TIPO, "
   cQry += _LF + " SN4.N4_OCORR, SN4.N4_TIPOCNT, SN4.N4_CONTA, SN4.N4_DATA, "
   cQry += _LF + " SN4.N4_CCUSTO, SN4.N4_IDMOV "
   cQry += _LF + " FROM " + retSQLName("SN4") + " SN4 "
   cQry += _LF + " WHERE SN4.D_E_L_E_T_ = '' "
   cQry += _LF + " AND SN4.N4_FILIAL = '" + cFil_MV + "' "
   
   cWhere2 := ""
   cWhere2 += _LF + " AND SN4.N4_OCORR in ('03', '04') "  // movimentos de transferencias de x para
   cWhere2 += _LF + " AND SN4.N4_TIPOCNT in ('1') "  // somente movimentos de transferencia entre contas
   cWhere2 += _LF + " AND SN4.N4_IDMOV = ( "
   cWhere2 += _LF + " SELECT MAX(SN.N4_IDMOV) FROM " + retSQLName("SN4") + " SN "
   cWhere2 += _LF + " WHERE SN.N4_FILIAL = SN4.N4_FILIAL AND "
   cWhere2 += _LF + " SN.N4_CBASE = SN4.N4_CBASE AND "
   cWhere2 += _LF + " SN.N4_ITEM = SN4.N4_ITEM AND "
   cWhere2 += _LF + " SN.N4_TIPO = SN4.N4_TIPO AND "
   cWhere2 += _LF + " SN.N4_OCORR = SN4.N4_OCORR AND "
   cWhere2 += _LF + " SN.N4_TIPOCNT = SN4.N4_TIPOCNT ) "

   cOrder := " ORDER BY SN4.N4_FILIAL, SN4.N4_CBASE, SN4.N4_ITEM, SN4.N4_TIPO, SN4.N4_TIPOCNT, SN4.N4_OCORR DESC "
   
   // Orderna de acordo com a Ordem do relatorio
   (cAliasQry)->(dbGoTop())
   while (cAliasQry)->(!eof()) .And. ! oReport:cancel()
      
      cQry2 := ""
      cQry2 += cQry
       
      cWhere := ""
      cWhere += _LF + " AND SN4.N4_CBASE = '" + (cAliasQry)->CBASE + "' "
      cWhere += _LF + " AND SN4.N4_ITEM = '" + (cAliasQry)->ITEM + "' "
      cWhere += _LF + " AND SN4.N4_TIPO = '" + (cAliasQry)->TIPO + "' "
      
      cQry2 += cWhere + cWhere2 + cOrder
      
      if lDebug
         autoGrLog(cQry2)
         mostraErro()
      endif
      
      memowrite("Ultima transferencia",cQry2)
      
      // última transferencia entre contas do bem
      if select(cTMP) > 0; (cTMP)->(dbCloseArea()); endif
      dbUseArea(.t., 'TOPCONN', TCGenQry(,,cQry2), cTMP, .F., .T.) 
   
      oReport:IncMeter()
      oSecBem:Init()
      
      cOcorre := ""
      
      if ! (cTMP)->(eof())
         cOcorre += STR0011 + " " + dtoc(stod((cTMP)->N4_DATA))
      endif
       
      while ! (cTMP)->(eof())
      
         if (cTMP)->N4_OCORR == "04" // "Transf. da conta de "
            cOcorre += " " + STR0023
         elseif (cTMP)->N4_OCORR == "03" // "para conta "
            cOcorre += " " + STR0024
         endif
         
         cOcorre += " " + allTrim((cTMP)->N4_CONTA)
         
         (cTMP)->(dbSkip())
         
      end
      
      oSecBem:PrintLine()
	  oSecBem:Finish()
      
	  (cAliasQry)->(dbSkip())
	
	end
	
	oReport:SkipLine()
	oReport:ThinLine()

    if select(cTMP) > 0; (cTMP)->(dbCloseArea()); endif
	
   (cAliasQry)->(dbCloseArea())
    MSErase(cAliasQry)

return



/*
-----------------------------------------------------------------------------------------------------
| FUNÇÃO: criaSX1                     | AUTOR: Felipe do Nascimento              | DATA: 23/12/2014 |
-----------------------------------------------------------------------------------------------------
| OBJETIVO: Função para criar as perguntas da rotina PNATFR072                                      |
|                                                                                                   |
-----------------------------------------------------------------------------------------------------
|                                     CONTROLE DE REVISÕES                                          |
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
   Local cfield1 := &("SX1->X1_GRUPO")
   Local cField2 := &("SX1->X1_ORDEM")
   Local cField3 := &("SX1->X1_DEF04")

   if SX1->(dbSeek(pad(cPerg,len(cfield1))+pad("24",len(cField2)))) .and. empty(cField3)
      recLock("SX1",.F.)  
	  SX1->(dbDelete())
	  msUnLock()
   endif
   
   aHelpPor := {"Informe a filial ","filial."}
   aHelpSpa := {"Introduzca la sucursal ","sucursal."}
   aHelpEng := {"Enter the date of valued  ","branch."}
   u_putsx1(cPerg,"01","Filial ?" , "¿Sucursal ?", "Branch?","mv_ch1","C",tamSX3("N1_FILIAL")[1],0,0,"G","","","XM0","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")

   aHelpPor := {"Informe a data da posição ","valorizada."}
   aHelpSpa := {"Introduzca la fecha de la posición ","valorada."}
   aHelpEng := {"Enter the date of valued  ","position."}
   u_putsx1(cPerg,"02","Data do Saldo?" , "¿Fecha de la balanza?", "Date of Balance?","mv_ch2","D",8,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")

   aHelpPor := {"Indique a data de aquisição","Bem Inicial" }
   aHelpSpa := {"Introduzca la Fecha de Adquisicion "," Inicio"}
   aHelpEng := {"Enter Initial ","Purchase Date"}
   u_putsx1(cPerg,"03","Da Data de aquisição ?" , "¿ De Fecha de Adquisicion ?", "From Purchase Date?","mv_ch3","D",8,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")

   aHelpPor := {"Indique a data de aquisição","Bem Final" }
   aHelpSpa := {"Introduzca la Fecha de Adquisicion ","de Bien Final"}
   aHelpEng := {"Enter Final ","Purchase Date "}
   u_putsx1(cPerg,"04","Até Data de aquisição ?" , "¿ A Fecha de Adquisicion ?", "To Purchase Date?","mv_ch4","D",8,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")

   aHelpPor := {"Indique o Código do ","grupo Inicial" }
   aHelpSpa := {"Introduzca el Código de ","grupo Inicio"}
   aHelpEng := {"Enter Initial ","group Code"}
   u_putsx1(cPerg,"05","Do Grupo ?" , "¿ De Grupo ?", "Initial Group?","mv_ch5","C",tamSX3("N1_GRUPO")[1],0,0,"G","","SNG","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")

   aHelpPor := {"Indique o Código do ","grupo Final" }
   aHelpSpa := {"Introduzca el Código de ","grupo Final"}
   aHelpEng := {"Enter Final ","group Code"}
   u_putsx1(cPerg,"06","Até Grupo ?" , "¿ A Grupo ?", "Final Group?","mv_ch6","C",TamSX3("N1_GRUPO")[1],0,0,"G","","SNG","","","mv_par06","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")
  
   aHelpPor := {"Informe a conta inicial a ","partir da qual se deseja"," imprimir o relat?io. Caso queira ","imprimir todas as contas,"," deixe esse campo em branco",". Utilize <F3> para escolher." }
   aHelpSpa := {"Introduzca la cuenta inicial"," que para imprimir el informe."," Si desea imprimir todas"," las cuentas, deje este campo en blanco",". Utilice <F3> elegir."}
   aHelpEng := {"Enter the initial account"," from which to print the report."," If you want to print all"," accounts, leave this ","field blank",". Use <F3> to choose."}
   u_putsx1(cPerg,"07","Da Conta ?" , "?De Cuenta ?", "From Account ?","mv_ch7","C",TamSX3("CT1_CONTA")[1],0,0,"G","","CT1","","","mv_par07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")

   aHelpPor := {"Informe a conta final at?qual"," se deseja imprimir o relat?io."," Caso queira imprimir todas ","as contas preencha"," com 'ZZZZZZZZZZZZZZZZZZZZ'",".Utilize <F3> para escolher." }
   aHelpSpa := {"Introduzca la cuenta final por"," el cual desea imprimir el informe."," Si desea imprimir todas las cuentas completa"," con. 'ZZZZZZZZZZZZZZZZZZZZ' <F3> Se utiliza para elegir."}
   aHelpEng := {"Enter the final account by"," which to print the report."," If you want to print all"," accounts complete"," with 'ZZZZZZZZZZZZZZZZZZZZ'."," <F3> Use to choose from."}
   u_putsx1(cPerg,"08","Até Conta ?" , "?A Cuenta ?", "To Account ?","mv_ch8","C",TamSX3("CT1_CONTA")[1],0,0,"G","","CT1","","","mv_par08","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")

   aHelpPor := {"Indique o Código do ","Bem Inicial" }
   aHelpSpa := {"Introduzca el Código de ","Buen Inicio"}
   aHelpEng := {"Enter Initial ","Asset Code"}
   u_putsx1(cPerg,"09","Do Cod Base ?" , "¿ De Cod Base ?", "Initial Base Code?","mv_ch9","C",TamSX3("N1_CBASE")[1],0,0,"G","","SN1","","","mv_par09","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")

   aHelpPor := {"Indique o Código do ","Item do Bem Inicial" }
   aHelpSpa := {"Introduzca el Código de ","Item del Bien Inicio"}
   aHelpEng := {"Enter Initial ","Asset item Code"}
   u_putsx1(cPerg,"10","Do Item ?" , "¿ De Item ?", "Initial Base Code?","mv_cha","C",TamSX3("N1_ITEM")[1],0,0,"G","","","","","mv_par10","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")

   aHelpPor := {"Indique o Código do ","Bem Final" }
   aHelpSpa := {"Introduzca el Código ","de Bien Final"}
   aHelpEng := {"Enter Final ","Asset Code"}
   u_putsx1(cPerg,"11","Até Cod Base ?" , "¿ A Cod Base ?", "Final Base Code?","mv_chb","C",TamSX3("N1_CBASE")[1],0,0,"G","","SN1","","","mv_par11","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")

   aHelpPor := {"Indique o Código do ","Item do Bem Final" }
   aHelpSpa := {"Introduzca el Código ","de Item del Bien Final"}
   aHelpEng := {"Enter Final ","Asset Item Code"}
   u_putsx1(cPerg,"12","Até Item ?" , "¿ A Item ?", "Final Item?","mv_chc","C",TamSX3("N1_ITEM")[1],0,0,"G","","","","","mv_par12","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa,"","","","","","","","")

   restArea(aArea)
return

