#include "rwmake.ch"
#include "Protheus.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "TopConn.ch"
#DEFINE   c_ent      CHR(13)+CHR(10)

**************************************************************************************
* Programa    : MT100TOK                                               Em : 08/05/13 *
* Objetivo    : Verificação do Numero da Nota Fiscal                                 *
* Autor       : Roberto Lima - Doit Sistemas                                         *
* Observacoes : Ponto de Entrada disparado da rotina MATA103, na validacao da nota   *
**************************************************************************************

************************
User Function MT100TOK()
************************

Local aArea   := GetArea()
Local lRet    := Paramixb[1]
Local cNat	  := MaFisRet(,"NF_NATUREZA")
Local cCalcIR := "" // 1-Normal, 2-IRPF na Baixa, 3-Simples e 4-Empresa Individual
Local _cDIRF  := ""
Local nPosPC 	:=   aScan(aHeader,{|x| Upper(AllTrim(x[2]))=="D1_PEDIDO"})    

Local cA100FOR := SA2->A2_COD
Local cLoja    := SA2->A2_LOJA
Local i        := 0 
Local nX       := 0
Local nY       := 0

If Alltrim(Upper(Funname())) = "MATA920"

	If len(alltrim(c920Nota)) < 9
		Aviso("ATENÇÃO","Favor verificar se os campos Numero da Nota Fiscal e Serie está preenchidos corretamente.",{"OK"})
	Return .f.
	Else
	Return .t. //Se for Mata920 valida somente o numero da nota e a serie e retorna
	Endif
	
Else

	If len(alltrim(cnfiscal)) < 9
		Aviso("ATENÇÃO","Favor verificar se os campos Numero da Nota Fiscal e Serie está preenchidos corretamente.",{"OK"})
		lRet :=.F.
	EndIf

Endif

if alltrim(cespecie) == "SPED"
	if empty(aNfeDanfe[13]) .or. aNfeDanfe[13] = ""
		Aviso("ATENÇÃO","Favor preencher a Chave da NFE na aba INFORMAÇÕES DANFE. Campo obrigatorio para Espec. Docum. = SPED !.",{"OK"})
		lRet := .F.
	endif
endif

if alltrim(cespecie) == "CTE"
	if empty(aNfeDanfe[13]) .or. aNfeDanfe[13] = ""
		Aviso("ATENÇÃO","Favor preencher a Chave da NFE na aba INFORMAÇÕES DANFE. Campo obrigatorio para Espec. Docum. = CTE !.",{"OK"})
		lRet := .F.
	endif
endif

//***********************************************************************************
// O codigo abaixo verifica se no cadastro do fornecedor o campo A2_CALCIRF 
// esta preenchido se não estiver o sistema irá assumir que o fornecedor é 1-Normal.
//*********************************************************************************** 
// 1-Normal, 2-IRPF na Baixa, 3-Simples e 4-Empresa Individual 
//***********************************************************************************/
DbSelectArea("SA2")
DbSetOrder(1)
if DbSeek(xfilial("SA2")+CA100FOR+CLOJA)
	if Empty(SA2->A2_CALCIRF)
		cCalcIR :="1"   // test
	else
		cCalcIR := SA2->A2_CALCIRF
	Endif
      
Endif

//***********************************************************************************
// Trata a Variavel cDIRF 
//***********************************************************************************
if len(alltrim(cDirf))>1  // SIM, NAO
	_cDIRF := SUBSTR(alltrim(cDirf),1,1)
else
	if cDirf = "1"
		_cDIRF := "S"
	else
		_cDIRF := "N"
	endif
endif
//***********************************************************************************

/*
if !(cCalcIR $"3|4" )  // 1-Normal, 2-IRPF na Baixa
	DbSelectArea("SED")
	DbSetORder(1)
	If DbSeek(xfilial("SED")+cNat)
		
		//If AllTrim(SED->ED_CALCIRF) == "S" .AND. (Empty(cDirf) .OR. Empty(cCodRet) )
		//	Aviso("ATENÇÃO","Natureza gera DIRF. Campos de DIRF na aba impostos preenchimento obrigatório!.",{"OK"}) 		
		//	lRet := .F.		                                                                                                
		//Endif
		                                                                        
		//If (_cDirf <> substr(SED->ED_CALCIRF,1,1) .OR. AllTrim(cCodRet) <> AllTrim(SED->ED_XCODRET)) .AND. (MaFisRet(,"NF_VALIRR") > 0)
		//If (substr(SED->ED_CALCIRF,1,1) <> _cDirf  .AND. (MaFisRet(,"NF_VALIRR") > 0)) .OR. (AllTrim(cCodRet) <> AllTrim(SED->ED_XCODRET) .AND. (MaFisRet(,"NF_VALIRR") > 0))   
		If (substr(SED->ED_CALCIRF,1,1) <> _cDirf ) .OR. (AllTrim(cCodRet) <> AllTrim(SED->ED_XCODRET) )   // Alterado no dia 26/08 devido a existencia de geração de IR na baixa do titulo principal - Fabio Flores Regueira. 
			Aviso("ATENÇÃO","Natureza gera DIRF. Favor preencher os campos da DIRF na aba impostos ( Gera Dirf =" + SED->ED_CALCIRF + " e Cd. Retenção =" + ALLTRIM(SED->ED_XCODRET) + " )." ,{"OK"})
				lRet := .F.
		endif
	else
	    IF !empty(cNat)
			// Fabio - 04/10/2017 validação da digitação de naturezas inexistentes. 
			Aviso("ATENÇÃO","Natureza informada ( " +alltrim(cNat)+" ) não existe!. Favor informar a natureza correta.",{"OK"})
			lRet := .F.
		endif 	
	Endif
Endif
*/

// ajuste realizado em 24/01/2023 - Fabio
DbSelectArea("SED")
DbSetORder(1)
If DbSeek(xfilial("SED")+cNat)
	if !(cCalcIR $"3|4" )
		If (substr(SED->ED_CALCIRF,1,1) <> _cDirf ) .OR. (AllTrim(cCodRet) <> AllTrim(SED->ED_XCODRET) )   // Alterado no dia 26/08 devido a existencia de geração de IR na baixa do titulo principal - Fabio Flores Regueira. 
			Aviso("ATENÇÃO","Natureza gera DIRF. Favor preencher os campos da DIRF na aba impostos ( Gera Dirf =" + SED->ED_CALCIRF + " e Cd. Retenção =" + ALLTRIM(SED->ED_XCODRET) + " )." ,{"OK"})
				lRet := .F.
		endif
	endif 
else 
    IF !empty(cNat)
		Aviso("ATENÇÃO","Natureza informada ( " +alltrim(cNat)+" ) não existe!. Favor informar a natureza correta.",{"OK"})
		lRet := .F.
	//else 
	//  IF POSICIONE("SF4",1,XFILIAL("SD1")+SD1->D1_TES,"F4_DUPLIC") == 'S'
	//		Aviso("ATENÇÃO","Natureza não pode ser informada ( " +alltrim(cNat)+" ) em branco!, para a TES que gera duplicata . Favor informar a natureza correta.",{"OK"})
	//		lRet := .F.
	//	endif 
	endif 	
endif 

//Verifica se o usuário é almoxarifado pra poder bloquear entrada de nota sem associação
//com o Pedido de compras
//Ricardo Ferreira - 24/03/2014
IF lRet
	
	If '01' $ ALLTRIM(FWSFUser(__cUserID,"DATAPAPER","USR_PAPER",.T.)) //Se existir o Papel almoxarifado nos papeis do usuário
		//Verifica se preencheu o pedido de compras.
		For i:= 1 to Len(aCols)
			If Empty(aCols[i][nPosPC])
				Alert("É necessário associar todos os itens da nota a um pedido de compras ou à uma medição de contratos! ! !")
				lRet := .f.
				Exit
			Endif
		Next
	Endif

Endif	



*****************************************************************************************
* Solicitação do Cliente Para que estabelecido a TOLERÂNCIA DE RECEBIMENTO DE MATERIAIS *
* seja testado para obedecer esses percentuais, esse cadastro fica a cargo do usuário   *
* Caso os valores sejam discrepantes NÃO ocorrera a INCLUSÃO do DOCUEMNTO DE ENTRADA,   *
* Ou seja, quem estiver efetuando a inclusão não vai conseguir prosseguir               *
* DATA: 09/07/2014                                                                      *
* ANALISTA RESPONSAVEL: FLAVIO OLIVEIRA                                                 *
* SOLICITANTE: RICARDO FERREIRA                                                         *
*****************************************************************************************

If Alltrim(Upper(Funname())) = "MATA103"

	// para obter as informações de inclusão
	//cUserI := FWLeUserlg("F1_USERLGI")
	//cDataI := FWLeUserlg("F1_USERLGI", 2)

	// para obter as informações de alteração
	//cUserA := FWLeUserlg("A1_USERLGA")
	//cDataA := FWLeUserlg("A1_USERLGA", 2)

//	If M->F1_STATUS == 'B'
//		Alert("MT100TOK NF: " + M->F1_DOC + " " + M->F1_SERIE + " STATUS: " + M->F1_STATUS + " Usuário: " + cUserI + " " + cDataI + " Encontra-se BLOQUEADO.")
//	Else
//		Alert("MT100TOK NF: " + M->F1_DOC + " " + M->F1_SERIE + " STATUS: " + M->F1_STATUS + " Usuário: " + cUserI + " " + cDataI + " Encontra-se NAO BLOQUEADO.")	
//	Endif

	nxPosPC		:=	aScan(aHeader,{|x| AllTrim(x[2])=="D1_PEDIDO"})
	nxPosItPC  	:=	aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEMPC"})
	nxPosCod    := 	aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
	nxPosQtd    :=	aScan(aHeader,{|x| AllTrim(x[2])=="D1_QUANT"})
	nxPosVlr    :=	aScan(aHeader,{|x| AllTrim(x[2])=="D1_VUNIT"})
	lx103Class	:=	.F.
	nxDecimalPC	:=	TamSX3("C7_PRECO")[2]
	nxUsado    	:=	len(aHeader)
	

	For nX :=1 To Len(aCols)
		If !aCols[nx][nxUsado+1]
			If !Empty(aCols[nx][nxPosPC])
				DbSelectArea("SC7")
				DbSetOrder(14)   
				If MsSeek(xFilEnt(xFilial("SC7"))+aCols[nx][nxPosPC]+aCols[nx][nxPosItPC])   
					nxQuJE := SC7->C7_QUJE		&&	QTD JÁ ENTREGUE
					nxQaCl := SC7->C7_QTDACLA
					nxQtde := SC7->C7_QUANT		&&	QTD TOTAL DO PEDIDO         

					nxQtdItem := aCols[nx][nxPosQtd]
					nxVlrItem := aCols[nx][nxPosVlr]
					For nY := nX+1 To Len(aCols)
						If aCols[nY][nxPosCod] == aCols[nx][nxPosCod] .And. aCols[nY][nxPosItPC] == aCols[nx][nxPosItPC] .And. aCols[nY][nxPosPC] == aCols[nX][nxPosPC]
							nxVlrItem := (((aCols[nY][nxPosVlr]*aCols[nY][nxPosQtd])+(nxVlrItem*nxQtdItem))/(nxQtdItem+aCols[nY][nxPosQtd]))
							nxQtdItem += aCols[nY][nxPosQtd]
						EndIf
					Next nY
					lxBloq := MaAvalToler( SC7->C7_FORNECE, SC7->C7_LOJA, SC7->C7_PRODUTO, nxQtdItem+nxQuJE+nxQaCl - IIf(lx103Class,SD1->D1_QUANT,0), nxQtde, nxVlrItem, xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA, , M->dDEmissao, nxDecimalPC, SC7->C7_TXMOEDA, ) ) [1]
					If lxBloq
						Alert("Item NF: " + Strzero(nX,4,0) + "  VALOR e/ou QTD EXCEDEM ao Pedido de Compra." )
						lRet	:=	.F.

					EndIf
                Endif
		    Endif
        Endif
	Next nX

Endif

RestArea(aArea)

Return (lRet)
