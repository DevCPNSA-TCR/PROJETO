/******************************************************************************
* FA050INC.PRW - Específicos Concremat                           em: 05/09/05 *
* Autor       : Keity Ramos                                                   *
* Objetivo    : Valida Prenchimento do campo GERA DIRF e COD. RETENCAO        *  											  *
*				caso o campo E2_IRRF > 0	              *													  *	
* Observações : Disparado antes da gravação do título a pagar		      *
* Alterações  : Verifica se título já existe em outra empresa. Validação      *
*               através da chamada da função CCMVAL01			      *
******************************************************************************/


*----------------------*
User Function FA050INC()
*----------------------*

	Local lRet := .T.
	Local cAlias
	Local cPref
	Local cCond
	Local cMens

	SetPrvt(" _Area, _lRet, _DtMin")

	_Area  := GetArea()
	_lRet  := .T.
	_DtMin := dDataBase + 4
 
 
                                                                      
	cAlias := 'SE2'
	cPref  := 'E2'
	cCond  := " E2_PREFIXO = '" + M->E2_PREFIXO + "'"
	cCond  += " AND E2_NUM = '" + M->E2_NUM + "'"
	cMens  := ' Título: ' + M->E2_PREFIXO + " - " + M->E2_NUM + " encontrado "

	If M->E2_PREFIXO <> 'GPE' .and. M->E2_PREFIXO <> 'BEN'
   // 22-05-2013 - Titulos com prefixo BEN - Beneficios não faz parte da condição. - Roberto Lima Doit sistemas.
 

//_lRet := U_CCMVAL01(cAlias,cPref,cCond,cMens) // Função que verifica se título já foi cadastrada em outra empresa

//If _lRet
		If M->E2_DIRF=="1" .AND. EMPTY(M->E2_CODRET)
			Alert("Este titulo irá gerar DIRF, favor informar o COD. RET. IRRF!!")
			_lRet  := .F.
		Else
			If M->E2_DIRF=="2" .AND. M->E2_IRRF > 0
				Alert("Este titulo possui IR retido, favor informar GERA DIRF 'SIM' e o COD. RETENÇÃO IRRF!!")
				_lRet  := .F.
			Endif
		Endif
//EndIf	  


		If (Empty(AllTrim(M->E2_TIPO)) .OR. (ALLTRIM(M->E2_TIPO)="NF"))  // Fabio Flores - 22/05/2014
			Alert("O Lançamento Manual de titulos do Tipo NF não é aceito por esta rotina!")
			_lRet  := .F.
		Endif



		If (Empty(AllTrim(M->E2_CCD)) .OR. LEN(ALLTRIM(M->E2_CCD)) < 1) .AND. M->E2_RATEIO =='N'  // Fabio Flores - 13/09/2012.
			Alert("Preencha o campo Centro de Custo!")
			_lRet  := .F.
		Endif

		If Empty(AllTrim(M->E2_XCO)) .AND. M->E2_RATEIO =='N'
			Alert("Preencha o campo Conta Orçamentária!")
			_lRet  := .F.
		Endif
 
	else
		LRET:=.T.
 
	Endif

	RestArea(_Area)

Return(_lRet)
