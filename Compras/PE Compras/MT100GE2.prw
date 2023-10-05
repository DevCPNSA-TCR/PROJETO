#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#DEFINE   c_ent      CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT100GE2	³ Autor ³ Glaucio Oliveira  Data ³05/09/2011	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto de Entrada para gravação de dados da Nota Fiscal nos ³±±
±±³Títulos a Pagar - SD1 p/ SE2											  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Alteração: VISA GERAR TÍTULOS DE RETENÇÃO NO FINANCEIRO UTILIZANDO A   ³±±
±±³			  REGRA DE PERCENTUAL DEFINIDA NO GCT		                  ³±±
±±³AUTOR    : Leonardo Freire                        Data ³ 29/03/2012.   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MT100GE2()

Local _Area := GetArea()

// Alterado por Leonardo Freire dia 30/03/2012

Local nOpc     := PARAMIXB[2]
Local nValor   := 0
LOCAL aArray   := {}
Local _PREFIXO, _NUM, _TIPO, _NATUREZ, _FORNECE, _LOJA, _NOMFOR, _EMISSAO, _VENCTO
Local _VENCREA, _VALOR, _EMIS1, _SALDO, _VENCORI, _MOEDA, _RATEIO, _VLCRUZ, _OCORREN
Local _ORIGEM, _FLUXO, _DESDOBR, _FILIAL, _MULTNAT, _PROJPMS, _DIRF, _LA, _AREA
Local cNat := GetMV("MV_XNATRET")
Local nRegE2 := SE2->(Recno())
Local lRat		:= .f.
Local nCount := 0

// Fim //
/* 
Define se a Nota tem rateio
Ricardo Ferreira - 21/05/2014
*/

BeginSql Alias "TMPD1"
%noparser% 
	SELECT COUNT(D1_DOC) RATD1 FROM %table:SD1% SD1
	WHERE 	D1_FILIAL 		= %exp:SD1->D1_FILIAL% AND
			D1_DOC	   		= %exp:SD1->D1_DOC% AND
			D1_SERIE	   	= %exp:SD1->D1_SERIE% AND 
			D1_FORNECE	   	= %exp:SD1->D1_FORNECE% AND 
			D1_LOJA	   	= %exp:SD1->D1_LOJA% AND 
			D1_RATEIO = '1'AND SD1.%notdel%
EndSql
	
IF TMPD1->RATD1 > 0 
	lRat := .t.

End

DbSelectArea("TMPD1")
DbCloseArea()
	
BeginSql Alias "TMPD1"
%noparser% 

select count(*) RATD1 from( 
	SELECT D1_CC 
	FROM %table:SD1% SD1
	WHERE	D1_FILIAL 		= %exp:SD1->D1_FILIAL% AND
			D1_DOC	   		= %exp:SD1->D1_DOC% AND
			D1_SERIE	   	= %exp:SD1->D1_SERIE% AND 
			D1_FORNECE	   	= %exp:SD1->D1_FORNECE% AND 
			D1_LOJA	   	= %exp:SD1->D1_LOJA% AND 
			SD1.%notdel%
	GROUP BY D1_CC ) A
EndSql	

DbSelectArea("TMPD1")
IF TMPD1->RATD1 > 1 
	lRat := .t.

End
/* Final definição do rateio */


DbSelectArea("TMPD1")
DbCloseArea()

DbSelectArea("SE2")
RecLock("SE2",.F.)

//Alterado por Ricardo Ferreia em 21/05/2014
//Motivo: Melhorar a forma de informar o centro de custo para titulos cuja nota tem rateio. 

//SE2->E2_XCO     := SD1->D1_XCO
//SE2->E2_CCD  	:= SD1->D1_CC
//SE2->E2_ITEMD   := SD1->D1_ITEMCTA
//SE2->E2_RATEIO  := if(SD1->D1_RATEIO=="2","N","S")  // 05/09/2012 - Fabio Flores.
SE2->E2_XCO     	:= if(!lRat,SD1->D1_XCO," ")
SE2->E2_CCD  		:= if(!lRat,SD1->D1_CC," ")
SE2->E2_ITEMD   	:= if(!lRat,SD1->D1_ITEMCTA," ")
SE2->E2_RATEIO  	:= if(!lRat,"N","S")  

MsUnLock()

/* Grava CCD e ITEMD nos títulos de impostos
Busca todos os títulos de impostos já gerados pelo título e atualiza os campos Ccusto,Item e Historico
Verifica todos os Recnos de titulos de imposto e chama o pe F050GER fazendo aproveitamento de código.
*/
cTitPai := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
BeginSql Alias "SE2TX"
%noparser% 
	SELECT R_E_C_N_O_ FROM %table:SE2% SE2
	WHERE 	E2_FILIAL = %exp:SE2->E2_FILIAL% AND
			E2_TITPAI = %exp:cTitPai% AND SE2.%notdel%
EndSql	

While !SE2TX->(Eof())
	aRecImpos:={}
	AADD(aRecImpos,{"SE2",SE2TX->R_E_C_N_O_})
	ExecBlock("F050GER",.F.,.F.,aRecImpos)
	
	SE2TX->(Dbskip())
Enddo

DbSelectArea("SE2TX")
DbCloseArea()
RestArea(_Area)
SE2->(DBGOTO(nRegE2))

// Alterado por Leonardo Freire dia 30/03/2012

If !empty(SD1->D1_PEDIDO)
	
	//If !empty(SC7->C7_PLANILH) .AND. !empty(SC7->C7_MEDICAO) .AND. !empty( SC7->C7_ITEMED) .AND. !empty(SC7->C7_CONTRA)  // 09/01/2015 - Alterado - Leonardo Freire 
	If !empty(SC7->C7_MEDICAO) .AND. !empty( SC7->C7_ITEMED) .AND. !empty(SC7->C7_CONTRA)
		
		dbSelectArea("CN9")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("CN9")+SC7->C7_CONTRA+SC7->C7_CONTREV)
			
			dbSelectArea("CN1")
			DBSETORDER(1)
			IF DBSEEK(XFILIAL("CN1")+CN9->CN9_TPCTO)
				
				If ALLTRIM(UPPER(FUNNAME()))== "MATA103"  //Documento de Entrada
					
					If nOpc == 1 //.. inclusao
						
						If CN1->CN1_XPERET > 0 .AND. (Empty(SE2->E2_PARCELA) .OR. (Upper(AllTrim(SE2->E2_PARCELA)) $ 'A|001' ))
							
							nValor := ROUND(((SF1->F1_VALBRUT*CN1->CN1_XPERET)/100),2)
							
							dbSelectArea('SE2')
							RecLock('SE2',.F.)
							
							
							//IF SE2->E2_TIPO = 'NF'
							
							SE2->E2_VALOR   -= nValor
							SE2->E2_SALDO   := SE2->E2_VALOR
							SE2->E2_VLCRUZ  := SE2->E2_VALOR
							SE2->E2_XCAUCAO := nValor
							SE2->E2_XPERET  := CN1->CN1_XPERET
							
							//EndIf
							
							MsUnLock()
							
							_PREFIXO := SE2->E2_PREFIXO
							_NUM     := SE2->E2_NUM
							_PARCELA := SE2->E2_PARCELA
							_TIPO    := "CAU"
							_NATUREZ := IIf(Empty(cNat),SE2->E2_NATUREZ,cNat ) //"2101"
							_FORNECE := SE2->E2_FORNECE
							_LOJA    := SE2->E2_LOJA
							_NOMFOR  := SE2->E2_NOMFOR
							_EMISSAO := SE2->E2_EMISSAO
							_VENCTO  := CN9->CN9_DTFIM//SE2->E2_VENCTO
							_VENCREA := CN9->CN9_DTFIM//SE2->E2_VENCREA
							_VALOR   := SE2->E2_XCAUCAO
							_EMIS1   := SE2->E2_EMISSAO
							_SALDO   := SE2->E2_XCAUCAO
							_VENCORI := CN9->CN9_DTFIM//SE2->E2_VENCORI
							_MOEDA   := SE2->E2_MOEDA
							_RATEIO  := "N"
							_VLCRUZ  := SE2->E2_XCAUCAO
							_OCORREN := "01"
							_ORIGEM  := SE2->E2_ORIGEM
							_FLUXO   := "2"
							_DESDOBR := "N"
							_FILIAL  := xFILIAL("SE2")
							_MULTNAT := "2"
							_PROJPMS := "2"
							_DIRF    := "2"
							_LA      := "S"
							
							
							RecLock("SE2",.T.)
							
							SE2->E2_PREFIXO := _PREFIXO
							SE2->E2_NUM     := _NUM
							SE2->E2_TIPO    := _TIPO
							SE2->E2_PARCELA := _PARCELA 
							SE2->E2_NATUREZ := _NATUREZ
							SE2->E2_FORNECE := _FORNECE
							SE2->E2_LOJA    := _LOJA
							SE2->E2_NOMFOR  := _NOMFOR
							SE2->E2_EMISSAO := _EMISSAO
							SE2->E2_VENCTO  := _VENCTO
							SE2->E2_VENCREA := _VENCREA
							SE2->E2_VALOR   := _VALOR
							SE2->E2_EMIS1   := _EMIS1
							SE2->E2_SALDO   := _SALDO
							SE2->E2_VENCORI := _VENCORI
							SE2->E2_MOEDA   := _MOEDA
							//SE2->E2_RATEIO  := _RATEIO
							SE2->E2_VLCRUZ  := _VLCRUZ
							//SE2->E2_OCORREN := _OCORREN
							SE2->E2_ORIGEM  := _ORIGEM
							//SE2->E2_FLUXO   := _FLUXO
							//SE2->E2_DESDOBR := _DESDOBR
							SE2->E2_FILIAL  := _FILIAL
							//SE2->E2_MULTNAT := _MULTNAT
							//SE2->E2_PROJPMS := _PROJPMS
							SE2->E2_DIRF    := _DIRF
							SE2->E2_LA      := _LA
							SE2->E2_TITPAI  := SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA
							SE2->E2_CODRET  := SE2->E2_CODRET
							SE2->E2_FILORIG := SE2->E2_FILORIG
							
							MsUnlock()
							
							Aviso("GCT","Contrato com retenção!",{"OK"})
							
							
						EndIf
						
					EndIf
					
				EndIF
			EndIF
		EndIF
	EndIF
	
EndIf
// FIM //

RestArea(_Area)


Return()
