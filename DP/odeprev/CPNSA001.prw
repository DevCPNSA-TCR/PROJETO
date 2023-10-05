#include "RWMAKE.ch" 
#include "PROTHEUS.ch"
#include "TOPCONN.ch"

#define CRLF chr(13)+chr(10)  


/*
----------------------------------------------------------------------------------------------------
| FUNÇÃO: CPNSA001                    | AUTOR: Felipe do Nascimento              | DATA: 20/06/2017 |
----------------------------------------------------------------------------------------------------
| OBJETIVO: Gerar movimentação mensal Odeprev                                                       |
|                                                                                                   |
-----------------------------------------------------------------------------------------------------
|                                     CONTROLE DE REVISÕES                                          |
-----------------------------------------------------------------------------------------------------
|    DATA    |         AUTOR          |                      OBJETIVO                               |
-----------------------------------------------------------------------------------------------------
| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
-----------------------------------------------------------------------------------------------------
*/
*----------------------------------------------------------------
user function CPNSA001()
*----------------------------------------------------------------

	private aMov := {{"00", {"1-5","7-14","20-21","23-53"}},;
	{"20", {"1-5","7-14","20-21","23-53"}},;
	{"31", {"1-5","7-16","20-21","23-53" /*"29-52"*/}},;
	{"32", {"1-16","20-21", "29-52"}},;
	{"33", {"1-5", "7-16", "20-21", "29-52"}},;
	{"34", {"1-16", "20-21", "29-52"}},;
	{"35", {"1-5", "7-16", "20-21", "29-52"}},;
	{"52", {"1-5", "7-14", "18-18", "20-21", "23-52"}},;
	{"58", {"1-5", "7-14", "18-21", "23-52"}},;
	{"60", {"1-5", "7-14", "17-17", "20-21", "29-52"}},;
	{"72", {"1-14", "18-18", "20-21", "29-52"}},;
	{"73", {"1-14", "18-18", "20-21", "23-52"}},;
	{"74", {"1-14", "18-18", "20-21", "23-52"}};
	}

	Private cPerg  := PADR("PGPE06",10)
	private lEnd := .F.
	Private cFuncao := ""   

	private aCivil := {{"C", "2"},; // CASADO 
	{"D", "4"},; // DIVORCIADO
	{"M", "6"},; // MARITAL
	{"Q", "5"},; // SEPARADO
	{"S", "1"},; // SOLTEIRO
	{"V", "3"}}  // VIUVO

	private _cMes := Month(Date())
	private _cAno := Year (Date())

	private _cUnidPat       // Patrocinadora - 110 (VERIFICAR COM O DEMERVAL)
	private _cSM0_CGC
	private _nEstab
	private _nSubEstab := 0

	private _nCNPJTransf := 0
	private _cTipoFolha := "LOC"
	private _cUFRes
	private _cEstCivil
	private _nContRegular := 0
	private _nContExpor   := 0  
	private _nContPatroA  := 0
	private _nPerParcA    := 0  
	private _nPerExpor    := 0
	private _cSM0_NOME
	private _nMargConsig := 0
	private _cCodMov 


	private aFields := {}

	ValidPerg()

	Pergunte(cPerg,.F.)

	@ 200,001 To 380,430 Dialog oDlg Title OemToAnsi("Geracao do Arquivo Movimentação Mensal")
	@ 010,017 Say OemToAnsi("Este programa ira gerar um arquivo texto") OF oDlg PIXEL
	@ 018,017 Say OemToAnsi("para ser enviado para a ODEPREV - Movimentação Mensal.") OF oDlg PIXEL

	@ 070,095 BmpButton Type 01 Action Processa({|lEnd| FGeraTxt(lEnd) })
	@ 070,135 BmpButton Type 02 Action Close(oDlg)
	@ 070,175 BmpButton Type 05 Action Pergunte(cPerg,.T.)

	Activate Dialog oDlg Centered

return


	*----------------------------------------------------------------------
static function fGeraTXT(lEnd)                                             
	*----------------------------------------------------------------------

	local cFilePath  := allTrim(MV_PAR08)
	local cArqTxt    := "ODEPREV" + SubStr(DTOS(mv_par07),5,2)+SubStr(DTOS(mv_par07),3,2)+".0"+(SM0->M0_CODIGO)
	local lGeraTxt   := .f.
	local cMesAno    := SubStr(DTOS(mv_par07),1,6) 
	local aAreaSRA   := SRA->(getArea())
	//local cFilterSRA := "SRA->RA_FILIAL >= '" + MV_PAR01 + "' .and. SRA->RA_FILIAL <= '" + MV_PAR02 + "'"
	//local bFilter    := { || &(cFilterSRA) }
	Local nCont		 := 0
	Local cSitFolIN	 := ""
	Local cSit		 := ""
	local i, x
	
	_cUnidPat := MV_PAR12
	
	For i:= 1 to Len(AllTrim(MV_PAR10))
		cSit := SubStr(MV_PAR10,i,1)
		If cSit <> '*'
			cSitFolIN += ",'" + cSit + "'"
		Endif
	Next
	cSitFolIN := SubStr(cSitFolIN,2) 
	
	lGeraTxt := ! empty(cArqTxt)
	if lGeraTxt

		if ! lIsdir(cFilePath); MakeDir(cFilePath); endif

		cFile := cFilePath + "\" + cArqTxt

		if mv_par09=1 // Apaga o arquivo anterior
			if file(cFile)
				if FErase(cFile) == -1
					msgBox("Arquivo nao pode ser apagado. Erro #" + AllTrim(Str(FError())))
					return
				endif
			endif

			nHandle := fCreate(cFile)
		else

			if file(cFile)
				nHandle := fOpen(cFile, 2)
				fSeek(nHandle, 0, 2)
			else
				nHandle := fCreate(cFile)

			endif
		endif

		if nHandle == -1
			msgAlert("O arquivo "+cFile+" nao pode ser criado! Verifique os parametros.","Atencao !")
			return
		endif

		/*   
		SRA->(dbSetOrder(3))
		SRA->(dbSetFilter( bFilter, cFilterSRA))


		procRegua(Reccount())

		FONTE ALTERADO PARA BUSCAR OS FUNCIONÁRIOS POR QUERY RETIRANDO O SERFILTER      
		*/  


		cQuery := "SELECT * FROM " + RetSqlName("SRA") + " SRA" + CHR(13)+CHR(10) 
		cQuery += "WHERE RA_FILIAL BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND" + CHR(13)+CHR(10) 	
		cQuery += "RA_CC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' AND" + CHR(13)+CHR(10) 
		cQuery += "RA_MAT BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' AND" + CHR(13)+CHR(10)
		cQuery += "RA_XODEP > 0  AND" + CHR(13)+CHR(10)
		cQuery += "((NOT (RA_XINCLUI  IN ('  ','A','C','D','O')  AND LEFT(RA_XDTCANC,6) <> '" + cMesAno + "')  AND   " + CHR(13)+CHR(10) 
		cQuery += "NOT (RA_XINCLUI  IN ('S2','S3','S4','S5')  AND LEFT(RA_XDTSUSP,6) <>  '" + cMesAno + "'))  OR (RA_XINCLUI = 'C' AND RA_SITFOLH <> 'D' ) " + CHR(13)+CHR(10)
		cQuery += " OR (RA_XINCLUI = 'D' AND RA_SITFOLH in ('D',' ') AND SubSTRING(RA_DEMISSA,1,6) >= '" + cMesAno + "' )  ) AND SRA.D_E_L_E_T_ = ' '"
		
		TcQuery cQuery Alias 'TMPSRA' New
		
		//aviso("query",cQuery ,{"OK"})
		Count to nCont
		ProcRegua(ncont)
		TMPSRA->(Dbgotop())
				
		SM0->(dbSetOrder(1))
		nRecnoSM0 := SM0->(Recno())
		SM0->(dbSeek(SUBS(cNumEmp,1,2)+TMPSRA->RA_FILIAL))

		_nEstab    := val(subStr(SM0->M0_CGC, 10, 3))
		_cSM0_NOME := AllTrim(SM0->M0_NOME)

		dbGoTo(nRecnoSM0)

		aFields := setField()
		

		while ! TMPSRA->(eof())  

			incProc()
			if Interrupcao(@lEnd); exit; endif
			/*
			SUBSTITUIDO POR FILTRO NA QUERY
			If ((SRA->RA_CC)  < mv_par03 .Or. (SRA->RA_CC)  > mv_par04) .or. ;
			((SRA->RA_MAT) < mv_par05 .Or. (SRA->RA_MAT) > mv_par06) .or. ;
			!(SRA->RA_SITFOLH $ mv_par10)
				SRA->(dbSkip())
				Loop
			EndIf  
			*/
			/* INICIO - INSERIDO FELIPE DO NASCIMENTO 05/02/2015
			TRATAMENTO DE EXCLUSÃO DO ARQUIVO DOS PARTICIPANTES QUE RESPEITEM AS CONDIÇÕES ABAIXO
			*/
			 /*
			SUBSTITUIDO POR FILTRO NA QUERY
			if ! empty(SRA->RA_XDTCANC) .and. allTrim(SRA->RA_XINCLUI) $ "A|C|D|O" // (A) Anulação da inscrição

				// (C) Cancelamento de Participante
				// (D) Desligamento por rescisão
				// (O) Morte
				if left(dtos(SRA->RA_XDTCANC), 6) <> cMesAno  // se o mês/ano de cancelamento não pertencer ao mês/ano de parâmetro
					SRA->(dbSkip())
					loop
				endif
			endif
			*/
			/*
			SUBSTITUIDO POR FILTRO NA QUERY			
			//if ! empty(SRA->RA_XDTSUSP) .and. allTrim(SRA->RA_XINCLUI) $ "S1|S2|S3|S4|S5" // (S1) Suspensao temporaria por solicitação
			//Comentado por Ricardo Ferreira - Criare Consulting em 22/06/2017
			//Motivo, Participante com código 31 - S1 Suspensao temporaria por solicitação, deve ser exibido no arquivo.
			if ! empty(SRA->RA_XDTSUSP) .and. allTrim(SRA->RA_XINCLUI) $ "S2|S3|S4|S5" // (S1) Suspensao temporaria por solicitação
				// (S2) Suspensao temporaria por licença medica
				// (S3) Suspensão por retirada de patrocinio
				// (S4) Suspensão participante expatriado
				// (S5) Suspensão licença não remunerada
				if left(dtos(SRA->RA_XDTSUSP), 6) <> cMesAno  // se o mês/ano de suspensão temporaria não pertencer ao mês/ano de parâmetro
					SRA->(dbSkip())
					loop
				endif
			endif
			*/
			/*FIM BLOCO INSERÇÃO 05/02/2015 
			*/  

			
			//----------------------------------------------------------------
			/*
			SUBSTITUIDO POR FILTRO NA QUERY	
			If SRA->RA_XODEP <= 0
				SRA->(dbSkip())
				Loop
			EndIf
			*/
			_cCargo    := posicione("SRJ", 1, xFilial("SRJ")+TMPSRA->RA_CODFUNC, "RJ_DESC")

			nPos := ascan(aCivil, {|x| x[1] == TMPSRA->RA_ESTCIVI})
			if nPos <> 0
				_cEstCivil := aCivil[nPos,2]
			endif

			_cCodMov:= posicione("SZ2", 1, TMPSRA->RA_XINCLUI, "Z2_CODMOV")  //Tipo de Movimentação
			_cUFRes := posicione("CCH", 1, xFilial("CCH")+TMPSRA->RA_NACIONC, "CCH_PAIS")
			_nCNPJTransf := TMPSRA->RA_XCNPJTR
			
			//--------------------------------------------------------------------  
			//----------------------------------------------------------------
			//Yttalo P. Martins - 19/11/14 -----------------------------------
			//Desconsidera transferidos---------------------------------------   
			If TMPSRA->RA_FILIAL <> xFilTransf() .and. ;
			   ! (_cCodMov $ '72,73,74') // alterado por Felipe do Nascimento - 15/12/2014
				// If xFilial("SRA") <> xFilTransf()   
				TMPSRA->(dbSkip())
				Loop   
			EndIf

			If TMPSRA->RA_XINCLUI = "S1"	//Supensao- Alterar as verbas para as novas verbas de suspensao que serão criadas
			   if TMPSRA->RA_XODEP >= 10
			      _nPerParcA := 50
			      
			   elseif TMPSRA->RA_XODEP >= 5 .and. TMPSRA->RA_XODEP <= 9 
		           _nPerParcA := 40
		           
			   elseif TMPSRA->RA_XODEP >= 1 .and. TMPSRA->RA_XODEP <= 4 
		           _nPerParcA := 30
		           
			   endIf                                         
						
				_nContRegular := 0 //não informado pois está suspensa //posicione("SRC", 1,TMPSRA->RA_FILIAL+TMPSRA->RA_MAT+"615", "RC_VALOR")  // Contribuição Regular
				_nContExpor   := 0 //não informado pois está suspensa //posicione("SRC", 1,TMPSRA->RA_FILIAL+TMPSRA->RA_MAT+"O06", "RC_VALOR")  // Contribuição Contrapartida  Exporatica
				_nContPatroA  := 0 //não informado pois está suspensa //posicione("SRC", 1,TMPSRA->RA_FILIAL+TMPSRA->RA_MAT+"O01", "RC_VALOR")  // Contrapartida 
				_nPerExpor    := 0 //não informado pois está suspensa //100*posicione("SRC", 1,TMPSRA->RA_FILIAL+TMPSRA->RA_MAT+"O06", "RC_HORAS")  // Percentual Contrapartida Exporatica
				
			Else
				_nContRegular := posicione("SRC", 1,TMPSRA->RA_FILIAL+TMPSRA->RA_MAT+"615", "RC_VALOR")  // Contribuição Regular
				_nContExpor   := posicione("SRC", 1,TMPSRA->RA_FILIAL+TMPSRA->RA_MAT+"O06", "RC_VALOR")  // Contribuição Contrapartida  Exporatica
				_nContPatroA  := posicione("SRC", 1,TMPSRA->RA_FILIAL+TMPSRA->RA_MAT+"O07", "RC_VALOR")  // Contrapartida 
				_nPerExpor    := posicione("SRC", 1,TMPSRA->RA_FILIAL+TMPSRA->RA_MAT+"O06", "RC_HORAS")  // Percentual Contrapartida Exporatica
				_nPerParcA    := posicione("SRC", 1,TMPSRA->RA_FILIAL+TMPSRA->RA_MAT+"O07", "RC_HORAS")  // Percentual Contrapartida			
			Endif

			_nSalario := sumSRCPD(TMPSRA->RA_FILIAL, TMPSRA->RA_MAT, "156")
			if _nSalario = 0
				_nSalario := sumSRCPD(TMPSRA->RA_FILIAL, TMPSRA->RA_MAT,"001")
			endif

			_nSalario += sumSRCPD(TMPSRA->RA_FILIAL, TMPSRA->RA_MAT,"300,177,003")-sumSRCPD(TMPSRA->RA_FILIAL, TMPSRA->RA_MAT,"513,515")
			
			If AllTrim(TMPSRA->RA_XINCLUI) == 'C'			
				_nSalario := TMPSRA->RA_XSALCAN
			Endif

			nPos := ascan(aMov, {|x| x[1] == _cCodMov})       

			if nPos <> 0
				cRange := ""
				for x := 1 to len(aMov[nPos,2])
					cRange += getRange(aMov[nPos,2,x]) + iif(x < len(aMov[nPos,2]), ",", "")
				next x
			endif

			cLinha:=""
			for x := 1 to len(aFields)
				_Dado := &(aFields[x,4])

				lFlag := strZero(x,2) $ cRange .and. !empty(_Dado)
				
				If AllTrim(TMPSRA->RA_XINCLUI) == 'C' .AND. aFields[x,4] == "TMPSRA->RA_XODEP"  //.AND. TMPSRA->RA_SITFOLH <> 'D' 
					_Dado := space(aFields[x,1]) 									
                Else	                
					if aFields[x,3] == "N"
						_Dado := iif(lFlag, strZero(_Dado, aFields[x,1]), space(aFields[x,1]))
	
					elseif aFields[x,3] == "A"
						_Dado := iif(lFlag, getAlfa(_Dado, aFields[x,1]), space(aFields[x,1]))
	
					elseif aFields[x,3] == "D"
						_Dado := iif(lFlag, getData(_Dado), space(aFields[x,1]))
	
					elseif aFields[x,3] == "V"  
						If AllTrim(TMPSRA->RA_XINCLUI) == 'C' .AND. (!Empty(_Dado) .AND. _Dado > 0 )
							lFlag := .T.
						Endif									
						_Dado := iif(lFlag, getValor(_Dado, aFields[x,1], aFields[x,2]), space(aFields[x,1]))
					endif
                Endif

				cLinha += _Dado

			next x

			fWrite(nHandle, cLinha+CRLF )

			TMPSRA->(dbSkip())

		end

		if Interrupcao(@lEnd)
			ApMsgInfo("Processo cancelado pelo Usuario")
		else
			if lGeraTxt
				fClose(nHandle)	
				aviso( "Movimentacao Mensal Odeprev", "Arquivo " + cFile + " gerado com sucesso!", {"Ok"} )
			endif
		endif

	endif
	DbSelectArea("TMPSRA")
	DbCloseArea()
	restArea(aAreaSRA)

return


	/*
	----------------------------------------------------------------------------------------------------
	| FUNÇÃO: SetField                    | AUTOR: Felipe do Nascimento              | DATA: 20/06/2017 |
	----------------------------------------------------------------------------------------------------
	| OBJETIVO: Setar a matriz com os campos que serão gravados no TXT                                  |
	|                                                                                                   |
	-----------------------------------------------------------------------------------------------------
	|                                     CONTROLE DE REVISÕES                                          |
	-----------------------------------------------------------------------------------------------------
	|    DATA    |         AUTOR          |                      OBJETIVO                               |
	-----------------------------------------------------------------------------------------------------
	| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
	-----------------------------------------------------------------------------------------------------
	*/
	*----------------------------------------------------------------------
static function setField()
	*----------------------------------------------------------------------
	local aField  := {}     
/*
	dbSelectArea("SRJ")
	DbSetOrder(1)   
	DbSeek(xfilial("SRJ")+TMPSRA->RA_CODFUNC)

	cFuncao := SRJ->RJ_DESC
*/
	/* Formato pode ser
	N - Numerico
	A - Alfa
	D - Data
	V - Valores */
	aAdd(aField, {02 /*Tamanho*/,00/*Decimais*/, "N"/*Formato*/, "_cMes" /*Variavel Conteudo*/})    // Mês  - 02
	aAdd(aField, {04,00, "N", "_cAno"})            // Ano - 2013
	aAdd(aField, {03,00, "N", "val(_cUnidPat)"})   // Patrocinadora - 110 (VERIFICAR COM O DEMERVAL)
	aAdd(aField, {03,00, "N", "_nEstab"})          // Estabelecimento    
	aAdd(aField, {02,00, "N", "_nSubEstab"})       // Subestabelecimento fornecido pela Odebrecht
	aAdd(aField, {14,00, "C", "_nCNPJTransf"})     // Estabelecimento de Destino 
	aAdd(aField, {10,00, "A", "TMPSRA->RA_CC"})       // Unidade de Trabalho - 00043411TR
	aAdd(aField, {10,00, "N", "val(left(allTrim(TMPSRA->RA_PIS), 10))"}) // Nº do PIS - 1219934819
	aAdd(aField, {02,00, "A", "_cCodMov"})         // Código da Movimentação - 20
	aAdd(aField, {45,00, "A", "TMPSRA->RA_NOME"})     // Nome do Participante - nome do participante nome do partic
	aAdd(aField, {11,00, "N", "val(TMPSRA->RA_CIC)"}) // CPF - 46543570091
	aAdd(aField, {08,00, "D", "STOD(TMPSRA->RA_NASC)"})     // Nascimento - 09121969
	aAdd(aField, {08,00, "A", "_cTipoFolha"})      // Tipo de folha de pagamento LOC - Folha Local / FN - Folha Nacional
	aAdd(aField, {08,00, "D", "STOD(TMPSRA->RA_ADMISSA)"})  // Admissão Histórica - 11071994
	aAdd(aField, {08,00, "D", "STOD(TMPSRA->RA_XDTSUSP)"})  // Data Inicio da Suspensão - 01041997 
	aAdd(aField, {08,00, "D", "STOD(TMPSRA->RA_XDTFSUS)"})  // Data Fim da Suspensão
	aAdd(aField, {08,00, "D", "STOD(TMPSRA->RA_XDTCANC)"})  // Data do Cancelamento
	aAdd(aField, {08,00, "D", "STOD(TMPSRA->RA_DEMISSA)"})  // Data de desligamento
	aAdd(aField, {08,00, "D", "STOD(TMPSRA->RA_XDTOBIT)"})  // Data do Obito
	aAdd(aField, {01,00, "A", "TMPSRA->RA_SEXO"})     // Sexo M ou F
	aAdd(aField, {01,00, "N", "val(_cEstCivil)"})  // Estado Civil
	aAdd(aField, {10,00, "N", "val(TMPSRA->RA_XPISANT)"})  // Pis Anterior apenas para retificação   
	aAdd(aField, {18,02, "V", "_nSalario"})        // Salário Mensal
	aAdd(aField, {02,00, "V", "TMPSRA->RA_XODEP"})    // % de Contribuição Participante
	aAdd(aField, {18,02, "V", "_nContRegular"})    // Valor da Contribuição Regular
	aAdd(aField, {18,02, "V", "_nContExpor"})      // Valor de Contribuição Esporádica
	aAdd(aField, {02,00, "V", "_nPerParcA"})       // Percentual Contrapartida Peatrocinadora
	aAdd(aField, {18,02, "V", "_nContPatroA"})      // Contrapartida da Patrocinadora 
	aAdd(aField, {50,00, "A", "_cSM0_NOME"})       // Alfa Código UA
	aAdd(aField, {20,00, "A", "TMPSRA->RA_MUNICIPIO"}) // Naturalidade
	aAdd(aField, {02,00, "A", "TMPSRA->RA_ESTADO"})    // Unidade Federativa da Naturalidade
	aAdd(aField, {45,00, "A", "TMPSRA->RA_MAE"})       // Nome da Mãe do Participante
	aAdd(aField, {01,00, "A", "TMPSRA->RA_XSEXMAE"})   // Sexo filiação materna
	aAdd(aField, {45,00, "A", "TMPSRA->RA_PAI"})       // Nome do Pai do Participante
	aAdd(aField, {01,00, "A", "TMPSRA->RA_XSEXPAI"})   // Sexo filiação paterna
	aAdd(aField, {45,00, "A", "TMPSRA->RA_XCONJUG"})   // Nome do Cônjuge do Participante
	aAdd(aField, {10,00, "N", "val(TMPSRA->RA_RG)"})   // Numérico Número do Registro Geral do Participante 
	aAdd(aField, {01,00, "A", "TMPSRA->RA_XTPRG"})     //  Natureza do documento de identificação - C Civil M Militar P Profissional E Estrangeira O Outra 
	aAdd(aField, {10,00, "A", "TMPSRA->RA_RGEXP"})     // Sigla do órgão que expediu o documento de identificação do participante 
	aAdd(aField, {02,00, "A", "TMPSRA->RA_RGUF"})      // Sigla da Unidade Federativa do órgão que expediu o documento de identificação do participante
	aAdd(aField, {08,00, "D", "STOD(TMPSRA->RA_DTRGEXP)"})   // Data que foi expedido o documento de identificação do participante 
	aAdd(aField, {50,00, "A", "TMPSRA->RA_ENDEREC"})   // Logradouro da residência
	aAdd(aField, {10,00, "N", "val(TMPSRA->RA_NUMENDE)"}) // Número da residência do Participante 
	aAdd(aField, {20,00, "A", "TMPSRA->RA_COMPLEM"})      // Complemento do endereço do Participante
	aAdd(aField, {20,00, "A", "TMPSRA->RA_BAIRRO"})       // Bairro que o Participante reside
	aAdd(aField, {20,00, "A", "TMPSRA->RA_MUNICIP"})      // Cidade que o Participante reside 
	aAdd(aField, {20,00, "A", "TMPSRA->RA_ESTADO"/*"_cUFRes"*/})              // Unidade Federativa que o Participante reside, utilizamos 20 ao invés de 2 pois temos participantes no exterior
	aAdd(aField, {08,00, "N", "val(TMPSRA->RA_CEP)"})     // Código de endereçamento postal – CEP 48 08 646 Numérico CEP do Participante
	aAdd(aField, {16,00, "N", "val(allTrim(TMPSRA->RA_XDDREC)+allTrim(TMPSRA->RA_XTELCON))"}) //  Telefone do Participante 
	aAdd(aField, {20,00, "A", "_cCargo"})       // Cargo do Integrante registrado na carteira profissional
	aAdd(aField, {50,00, "A", "TMPSRA->RA_EMAIL"})       //  E-mail profissional do Participante 
	aAdd(aField, {50,00, "A", "TMPSRA->RA_XEMAIL"})      // E-mail pessoal do Participante
	aAdd(aField, {18,02, "V", "_nMargConsig"})        // Valor da margem consignável disponível para contratação do empréstimo consciente 


return(aField)

	/*
	----------------------------------------------------------------------------------------------------
	| FUNÇÃO: getRange                    | AUTOR: Felipe do Nascimento              | DATA: 20/06/2017 |
	----------------------------------------------------------------------------------------------------
	| OBJETIVO: Retornar a expressao contendo os campos que deverão ser preenchidos conforme o codigo do|
	|           motivo                                                                                  |
	-----------------------------------------------------------------------------------------------------
	|                                     CONTROLE DE REVISÕES                                          |
	-----------------------------------------------------------------------------------------------------
	|    DATA    |         AUTOR          |                      OBJETIVO                               |
	-----------------------------------------------------------------------------------------------------
	| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
	-----------------------------------------------------------------------------------------------------
	*/
	*------------------------------------------------------
static function getRange(cSeq)
	*------------------------------------------------------
	local nPosUnder
	local nDig1, nDig2
	local x, cRange := ""

	nPosUnder := at("-", cSeq)

	nDig1 := val(iif(nPosUnder = 0, cSeq, left(cSeq, nPosUnder - 1)))
	nDig2 := val(iif(nPosUnder = 0, cSeq, subStr(cSeq, nPosUnder + 1)))

	for x := nDig1 to nDig2
		cRange += strZero(x, 2) + iif(x < nDig2, ",", "")
	next x

	return(cRange)                

	/*
	-------------------------------------0---------------------------------------------------------------
	| FUNÇÃO: getData                     | AUTOR: Felipe do Nascimento              | DATA: 20/06/2017 |
	--------------------------------------0--------------------------------------------------------------
	| OBJETIVO: Retornar a expressao no formato Data                                                    |
	|                                                                                                   |
	-----------------------------------------------------------------------------------------------------
	|                                     CONTROLE DE REVISÕES                                          |
	-----------------------------------------------------------------------------------------------------
	|    DATA    |         AUTOR          |                      OBJETIVO                               |
	-----------------------------------------------------------------------------------------------------
	| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
	-----------------------------------------------------------------------------------------------------
	*/

	*--------------------------------------------------------      
static function getData(dData)
	*--------------------------------------------------------
	local cData 

	cData := dtoc(dData)
	cData := left(cData, 2) + subStr(cData, 4, 2) + right(cData, 4)

	return(cData)

	/*
	----------------------------------------------------------------------------------------------------
	| FUNÇÃO: getValor                    | AUTOR: Felipe do Nascimento              | DATA: 20/06/2017 |
	----------------------------------------------------------------------------------------------------
	| OBJETIVO: Retornar a expressao no formato Valor                                                   |
	|                                                                                                   |
	-----------------------------------------------------------------------------------------------------
	|                                     CONTROLE DE REVISÕES                                          |
	-----------------------------------------------------------------------------------------------------
	|    DATA    |         AUTOR          |                      OBJETIVO                               |
	-----------------------------------------------------------------------------------------------------
	| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
	-----------------------------------------------------------------------------------------------------
	*/
	*--------------------------------------------------------      
static function getValor(nValor, nTam, nDec)                         
	*--------------------------------------------------------      
	local cValor := strZero(nValor,nTam,nDec)
	local nPosDot := at(".", cValor)
	local cInt := cDec := ""

	if nPosDot = 0
		cInt := left(cValor, len(cValor))
	else
		cInt := left(cValor, nPosDot - 1)
		cDec := subStr(cValor, nPosDot + 1, nDec)
	endif

	return(cInt+iif(!empty(cDec), ".", "")+cDec) 

	/*
	-----------------------------------------------------------------------------------------------------
	| FUNÇÃO: getAlfa                     | AUTOR: Felipe do Nascimento              | DATA: 20/06/2017 |
	-----------------------------------------------------------------------------------------------------
	| OBJETIVO: Retornar a expressao no formato Alfa                                                    |
	|                                                                                                   |
	-----------------------------------------------------------------------------------------------------
	|                                     CONTROLE DE REVISÕES                                          |
	-----------------------------------------------------------------------------------------------------
	|    DATA    |         AUTOR          |                      OBJETIVO                               |
	-----------------------------------------------------------------------------------------------------
	| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
	-----------------------------------------------------------------------------------------------------
	*/
	*--------------------------------------------------------      
static function getAlfa(cAlfa, nTam)                         
	*--------------------------------------------------------
	cAlfa := left(cAlfa, nTam)
	return(cAlfa + space(nTam - len(cAlfa))) 


	/*
	-----------------------------------------------------------------------------------------------------
	| FUNÇÃO: sumSRCPD                    | AUTOR: Felipe do Nascimento              | DATA: 20/06/2017 |
	-----------------------------------------------------------------------------------------------------
	| OBJETIVO: Somar verbas na tabela SRC conforme parametro cPD                                       |
	|                                                                                                   |
	-----------------------------------------------------------------------------------------------------
	|                                     CONTROLE DE REVISÕES                                          |
	-----------------------------------------------------------------------------------------------------
	|    DATA    |         AUTOR          |                      OBJETIVO                               |
	-----------------------------------------------------------------------------------------------------
	| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
	-----------------------------------------------------------------------------------------------------
	*/
	*------------------------------------------------------------
static function sumSRCPD(cFil, cMat, cPD)
	*------------------------------------------------------------
	local nValor := 0
	local aAreaSRC := SRC->(getArea())

	SRC->(dbSetOrder(1))
	SRC->(dbSeek(cFil+cMat))
	while SRC->(! eof()) .and. cFil+cMat == SRC->RC_FILIAL+SRC->RC_MAT
		if SRC->RC_PD $ cPD
			nValor +=  SRC->RC_VALOR
		endif
		SRC->(dbSkip())
	end  

	restArea(aAreaSRC)

return(nValor)


/*--------------------------------------------------------------------------*
* Função: VALIDPERG    | Autor | Roberto Lima            | Data | 09/10/13  *
*---------------------------------------------------------------------------*
* Descrição: Verifica a existencia das perguntas criando-as caso seja       *
*            necessario (caso nao existam).                                 *
*---------------------------------------------------------------------------*/
Static Function ValidPerg
   local i, j

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
	/* LINHA ABAIXO SUBSTITUIDA - FELIPE DO NASCIMENTO 30/06/2014 
	//Aadd(aRegs,{cPerg , "11" , "Cód.de Movimentação?" ,"","", "mv_ch11" ,"C" , 02 ,0 ,0 , "G" , ""         , "mv_par11" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","","SZ2",""}) */
	Aadd(aRegs,{cPerg , "11" , "Cód.de Movimentação?" ,"","", "mv_ch11" ,"C" , 99 ,0 ,0 , "G" , "U_FSITODEPREV", "mv_par11" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","","",""})

	/* LINHA INCLUIDA PARA ANTENDER QUALQUER EMPRESA
	POR FELIPE DO NASCIMENTO - 26/09/2014 */
	Aadd(aRegs,{cPerg , "12" , "Cód. Patrocinadora?" ,"","", "mv_ch12" ,"C" , 03 ,0 ,0 , "G" , "naovazio()", "mv_par12" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","","",""})

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

/*
-----------------------------------------------------------------------------------------------------
| FUNÇÃO: fSitODEPREV                 | AUTOR: Felipe do Nascimento              | DATA: 30/06/2014 |
-----------------------------------------------------------------------------------------------------
| OBJETIVO: Função de usuário para montagem do grid de seleçaõ do tipo de movimentação no parame-   |
|           tro da rotina CPNSA001                                                                  |
-----------------------------------------------------------------------------------------------------
|                                     CONTROLE DE REVISÕES                                          |
-----------------------------------------------------------------------------------------------------
|    DATA    |         AUTOR          |                      OBJETIVO                               |
-----------------------------------------------------------------------------------------------------
| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
-----------------------------------------------------------------------------------------------------
*/
user function fSitODEPREV(l1Elem,lTipoRet)
	local cTitulo:= "MOVIMENTAÇÃO ODEPREV"
	local MvPar
	local MvParDef:=""

	private aSit:={}

	l1Elem := iif (l1Elem = nil , .f. , .t.)

	lTipoRet := iif(lTipoRet = nil, .t., .f.)

	cAlias := Alias() 				   // Salva Alias Anterior

	if lTipoRet
		MvPar := &(allTrim(readVar())) // Carrega Nome da Variavel do Get em Questao
		mvRet := allTrim(readVar())	   // Iguala Nome da Variavel ao Nome variavel de Retorno
	endif

	dbSelectArea("SZ2")
	dbGoTop()
	cursorWait()
	while ! SZ2->(eof())

		aAdd(aSit,SZ2->Z2_CODIGO + " - " + Alltrim(SZ2->Z2_DESCRIC))
		MvParDef += SZ2->Z2_CODIGO

		SZ2->(dbSkip())
	end
	cursorArrow()

	if lTipoRet
		if f_Opcoes(@MvPar,cTitulo,aSit,MvParDef,12,49,l1Elem, tamSX3("Z2_CODIGO")[1])  // Chama funcao f_Opcoes
			&MvRet := mvpar  // Devolve Resultado
		endif	
	endif

	dbSelectArea(cAlias) // Retorna Alias
return( iif( lTipoRet , .t. , MvParDef ) )


//----------------------------------------------------------------
//Yttalo P. Martins - 19/11/14 -----------------------------------
//Verifica se funcionário foi transferido-------------------------
Static Function xFilTransf()

	Local cQuery := ""
	Local cRet   := SPACE(TAMSX3("RA_FILIAL")[1])

	cRet   := TMPSRA->RA_FILIAL
	_aArea := GetArea() 

	cQuery := "Select SRE.RE_FILIALD,SRE.RE_FILIALP,SRE.RE_DATA, SRE.R_E_C_N_O_ from "+ RetSQLName("SRE") +" SRE "
	cQuery += "where SRE.RE_EMPD = '"+CEMPANT+"' AND "
	cQuery += "SRE.RE_FILIALD = '"+ TMPSRA->RA_FILIAL +"' AND "
	cQuery += "SRE.RE_MATD = '"+ TMPSRA->RA_MAT +"' AND "
	cQuery += "SRE.RE_DATA <= '"+ DTOS(mv_par07) +"' AND "
	cQuery += "SRE.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY SRE.R_E_C_N_O_ DESC "

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"SRETMP",.F.,.T.)  

	dbSelectArea("SRETMP")
	("SRETMP")->(dbGotop())

	If ("SRETMP")->(!EOF())
		cRet := ALLTRIM( ("SRETMP")->RE_FILIALP )
		cRet := PADR( cRet,TAMSX3("RA_FILIAL")[1] )
	Else
		cRet := TMPSRA->RA_FILIAL 
	EndIf

	dbSelectArea("SRETMP")
	("SRETMP")->(dbCloseArea())

	RestArea(_aArea)

Return(cRet)     


