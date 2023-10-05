#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/*/
*+-------------------------------------------------------------------------+*
*|Funcao	  | CHEWSPAG   | Autor | Fagner Oliveira da Silva       	   |*
*+------------+------------------------------------------------------------+*
*|Data		  | 02.07.2014												   |*
*+------------+------------------------------------------------------------+*
*|Descricao   | Programa que instancia o WebService do cherwell. Sera      |*
*|            | utilizado apenas o metodo UpdatePGMT para informar quando  |*
*|            | houver o pagamento de um NF oriunda de um pedido Cherwell. |*
*+------------+------------------------------------------------------------+*
*|Solicitante | 														   |*
*+------------+------------------------------------------------------------+*
*|Arquivos	  | 														   |*
*+------------+------------------------------------------------------------+*
*|             ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL            |*
*+-------------------------------------------------------------------------+*
*| Programador       |   Data   | Motivo da alteração                      |*
*+-------------------+----------+------------------------------------------+*
*| Yttalo P. Martins |27/03/15  |inclusão do parâmetro cLogIntTit. Uso     |*
*+                   +          +                                          +*
*+ exclusivo pela rotina U_WSBXTITCHW. O vetor será atualizado com títulos |*
*+ que não puderam ser baixados no Cherwell. Atualiação dos campos         |*
*+ E1_XINTGBX e E1_XMSGBX                                                  |*
*+-------------------+----------+------------------------------------------+*
/*/

*----------------------------------------------------*
User Function CHEWSPAG(cVar01, cVar02, nVar03, dVar04, dVar05 , cVar04 , cVar05, cLogIntTit)
*----------------------------------------------------*
Private oWsCherwell := WSCherwellIntegration():New() // Cria instancia do WebService de integração Cherwell

Private cWSError    := GetWSCError()	// Verifica a existencia de erro para a criação da instância
Private cDelin      := cVar01
Private cPedido     := cVar02

Private nValPag     := nVar03
Private cNF         := cVar04
Private cSerie      := cVar05

Private dDatPag     := dVar04
Private dDatRec     := dVar05

Private cOcorrChw   := ""
default cLogIntTit  := nil 

If Empty(cWSError)

	oWsCherwell:CCD_PEDIDO     := cPedido
	oWsCherwell:CVL_PAGAMENTO  := nValPag
	oWsCherwell:CDT_PAGAMENTO  := dDatPag
	oWsCherwell:CNR_N_FISCAL   := cNF
	oWsCherwell:CNR_N_SERIE    := cSerie
	oWsCherwell:cDT_RECEBIMENTO:= dDatRec
		
	&& Chamada do Metodo informar pagamento de financeiro de um pedido cherwell
	oWsCherwell:UpdatePGMT(oWsCherwell:CCD_PEDIDO,oWsCherwell:CVL_PAGAMENTO, oWsCherwell:CDT_PAGAMENTO,oWsCherwell:cDT_RECEBIMENTO,oWsCherwell:CNR_N_FISCAL,oWsCherwell:CNR_N_SERIE )
	//oWsCherwell:UpdatePGMT(oWsCherwell)
	//oSvc:atualizarProdutos(cXml, cPassword)
	
	cWSError := GetWSCError()
	
	If !Empty(cWSError)
		
		*'Yttalo P. Martins-INICIO-27/03/15---------------------------------------------------------------------------------'*
		//Alert("Não foi possível conectar com o servidor de Internet para o envio da tabela. Erro de Execução : " + cWSError)
		If cLogIntTit == Nil
			Alert("Não foi possível conectar com o servidor de Internet para o envio da tabela. Erro de Execução : " + cWSError)		
		Else
			cLogIntTit := SE1->E1_NUM+"-"+SE1->E1_PREFIXO+" => "+cWSError
		Endif
		
		cOcorrChw   := cWSError
		*'Yttalo P. Martins-FIM-27/03/15------------------------------------------------------------------------------------'*   
		
    Else
    
   		*'Yttalo P. Martins-INICIO-27/03/15---------------------------------------------------------------------------------'*
		&& Retorno da integracao do webservice
		//Alert(oWsCherwell:CUPDATEPGMTRESULT)
		If cLogIntTit == Nil
			Alert(oWsCherwell:CUPDATEPGMTRESULT)
		Else
			cLogIntTit := SE1->E1_NUM+"-"+SE1->E1_PREFIXO+" => "+oWsCherwell:CUPDATEPGMTRESULT
		Endif
		
		cOcorrChw   := oWsCherwell:CUPDATEPGMTRESULT		
		*'Yttalo P. Martins-FIM-27/03/15------------------------------------------------------------------------------------'*   
				
    EndIf
    
Else

	*'Yttalo P. Martins-INICIO-27/03/15---------------------------------------------------------------------------------'*
	//Alert("Não foi possível conectar com o servidor de Internet para o envio da tabela. Erro de Execução : " + cWSError)
	If cLogIntTit == Nil
		Alert("Não foi possível conectar com o servidor de Internet para o envio da tabela. Erro de Execução : " + cWSError)		
	Else
		cLogIntTit := SE1->E1_NUM+"-"+SE1->E1_PREFIXO+" => "+cWSError
	Endif
	
	cOcorrChw   := cWSError
	*'Yttalo P. Martins-FIM-27/03/15------------------------------------------------------------------------------------'*   

EndIf

*'Yttalo P. Martins-INICIO-27/03/15---------------------------------------------------------------------------------'*
RECLOCK("SE1",.F.)
	SE1->E1_XMSGBX  := cOcorrChw
//	SE1->E1_XINTGBX := IIF( EMPTY(cWSError) .AND. UPPER("ok")$cOcorrChw ,"S","" )
	SE1->E1_XINTGBX := IIF( UPPER("nok")$cOcorrChw ,"","S" )	
	
SE1->(MSUNLOCK())
*'Yttalo P. Martins-FIM-27/03/15------------------------------------------------------------------------------------'*   

Return