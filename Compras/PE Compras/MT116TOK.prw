/*/
===============================================================================
Autor.............: Peder Munksgaard (Do.it Sistemas)
-------------------------------------------------------------------------------
Data..............: 23/03/2015
-------------------------------------------------------------------------------
Descri��o.........: Este ponto de entrada pertence a rotina de digita��o de 
                    conhecimento de frete, MATA116(). Executado na rotina de 
                    valida��o dos dados do conhecimento, A116TUDOK().
                    
                    Ponto de entrada aberto em atendimento a GMUD 000167 
                    solicitada pela usu�ria Susan Fernandes � fim de n�o 
                    permitir altera��es das informa��es referentes ao 
                    conhecimento de frete ap�s as mesmas terem sido confirmadas
                    na tela de parametriza��o.                     
-------------------------------------------------------------------------------
Altera��o.........: (dd/mm/aaaa) - Motivo
-------------------------------------------------------------------------------
Partida...........: A116TUDOK()
-------------------------------------------------------------------------------
Fun��o............: u_MT116TOK()
===============================================================================
/*/ 

#Include "Protheus.ch"

#DEFINE ROTINA 		01 // Define a Rotina : 1-Inclusao / 2-Exclusao
#DEFINE TIPONF		02 // Considerar Notas : 1 - Compra , 2 - Devolucao
#DEFINE DATAINI		03 // Data Inicial para Filtro das NF Originais
#DEFINE DATAATE		04 // Data Final para Filtro das NF originais
#DEFINE FORNORI		05 // Cod. Fornecedor para Filtro das NF Originais
#DEFINE LOJAORI		06 // Loja Fornecedor para Fltro das NF Originais
#DEFINE FORMUL		07 // Utiliza Formulario proprio ? 1-Sim,2-Nao
#DEFINE NUMNF		08 // Num. da NF de Conhecimento de Frete
#DEFINE SERNF		09 // Serie da NF de COnhecimento de Frete
#DEFINE FORNECE		10 // Codigo do Fornecedor da NF de FRETE
#DEFINE LOJA		11 // Loja do Fornecedor da NF de Frete
#DEFINE TES			12 // Tes utilizada na Classificacao da NF
#DEFINE VALOR		13 // Valor total do Frete sem Impostos
#DEFINE UFORIGEM	14 // Estado de Origem do Frete
#DEFINE AGLUTINA	15 // Aglutina Produtos : .T. , .F.
#DEFINE BSICMRET	16 // Base do Icms Retido
#DEFINE VLICMRET	17 // Valor do Icms Retido
#DEFINE FILTRONF    18 // Filtra nota com conhecimento frete .F. , .T.
#DEFINE ESPECIE	    19 // Especie da Nota Fiscal

User Function MT116TOK()

   Local _l116Inclui := Iif(IsInCallStack("A116INCLUI"), .T., .F.)
   Local _lRet       := .T.
      
   Local _cMsg   := "Prezado(a), " + Alltrim(cUserName) + CRLF    + ;
                    CRLF                                          + ;
                    "Ao lan�ar uma nota de conhecimento de frete" + ;
                    " n�o dever�o ser alteradas as informa��es  " + ;
                    "sobre a mesma.                             " + ;
                    CRLF                                          + ;
                    "Os valores iniciais ser�o restaurados.     "
         
   
   If cTipo <> "C" .Or. (cFormul <> IIf(aParametros[FORMUL]==2,"S","N")) .Or. ;
      cNFiscal <> aParametros[NUMNF] .Or. cSerie <> aParametros[SERNF] .Or. ;
      cEspecie <> aParametros[ESPECIE] .Or. cA100For <> aParametros[FORNECE] .Or. ;
      cLoja <> aParametros[LOJA] 
      
      MsgInfo(_cMsg,"[MT116TOK]")
      
      cTipo     := IIf(_l116Inclui,"C",SF1->F1_TIPO)
      cFormul   := IIf(_l116Inclui,IIf(aParametros[FORMUL]==2,"S","N"),SF1->F1_FORMUL)
      cNFiscal  := IIf(_l116Inclui,aParametros[NUMNF],SF1->F1_DOC)
      cSerie    := IIf(_l116Inclui,aParametros[SERNF],SF1->F1_SERIE)
      cA100For  := IIf(_l116Inclui,aParametros[FORNECE],SF1->F1_FORNECE)
      cLoja     := IIf(_l116Inclui,aParametros[LOJA],SF1->F1_LOJA)
      cEspecie  := IIf(_l116Inclui,aParametros[ESPECIE],SF1->F1_ESPECIE)
      
      If _l116Inclui
      
         Eval(bGDRefresh)
         _lRet := .F.
         
      Endif
      
   Endif
   
Return _lRet