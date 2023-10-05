#include "Protheus.ch"
#include "Rwmake.ch"
#include "Topconn.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ AP6 IDE            º Data ³  30/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Integração Plano de Saude                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PTNR0040()


	Local aArea			:=	GetArea()
	
	Private lEnd 		:=	.F.
	Private	cPerg		:=	PADR('PTNR0040',10," ")
	Private	cCursFunc	:=	""
	Private	cCursDepn	:=	""
	private oTable 

	ValidPerg()
	If .Not.Pergunte( cPerg , .T. )
		Return .F.
	Endif

	aStru	:=	{}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define campos do TRB Cria um arquivo de Apoio ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru,{"FILIAL"	,"C",04,00})	&&	Filial
	AADD(aStru,{"MAT" 		,"C",06,00})	&&	Numero da Matricula
	AADD(aStru,{"COD" 		,"C",02,00})	&&	Codigo Sequencia Depend.
	AADD(aStru,{"TIPO" 		,"C",10,00})	&&	"TITULAR" ou "DEPENDENTE"
	AADD(aStru,{"NOMECMP" 	,"C",70,00})	&&	Nome completo funcionario
	AADD(aStru,{"CIC" 		,"C",11,00})	&&	CPF do Funcionario
	AADD(aStru,{"NASC" 		,"D",08,00})	&&	Data de Nascimento
	AADD(aStru,{"SEXO" 		,"C",01,00})	&&	Sexo do Funcionario Pertence("MF")
	AADD(aStru,{"DSEXO" 	,"C",10,00})
	AADD(aStru,{"RBGRAUPAR" ,"C",01,00})	&&	Grau de Parentesco C=Conjuge;F=Filho;E=Enteado;P=Pai/Mae;O=Outros
	AADD(aStru,{"RBDGRAUPA" ,"C",07,00})
	AADD(aStru,{"ESTCIVI" 	,"C",01,00})	&&	Estado Civil Funcionario EXISTCPO("SX5","33"+M->RA_ESTCIVI) .AND. FHIST()
	AADD(aStru,{"DESTCIVI" 	,"C",30,00})
	AADD(aStru,{"MAE" 		,"C",70,00})	&&	Nome da Mae
	AADD(aStru,{"TITULOE" 	,"C",12,00})	&&	Titulo Eleitoral
	AADD(aStru,{"ZONASEC" 	,"C",08,00})	&&	Zona Eleitoral
	AADD(aStru,{"SECAO" 	,"C",04,00})	&&	Secao Eleitoral
	AADD(aStru,{"PIS" 		,"C",12,00})	&&	PIS do Funcionario
	AADD(aStru,{"ADMISSA" 	,"D",08,00})	&&	Data de Admissao
	AADD(aStru,{"RG" 		,"C",15,00})	&&	RG - Registro Geral
	AADD(aStru,{"COMPLRG" 	,"C",05,00})	&&	Complemento do RG
	AADD(aStru,{"ENDEREC" 	,"C",30,00})	&&	Endereco do Funcionario
	AADD(aStru,{"NUMENDE" 	,"C",06,00})	&&	Numero do Endereco
	AADD(aStru,{"COMPLEM" 	,"C",15,00})	&&	Complemento do Endereco
	AADD(aStru,{"BAIRRO" 	,"C",20,00})	&&	Bairro
	AADD(aStru,{"MUNICIP" 	,"C",20,00})	&&	Municipio
	AADD(aStru,{"CEP" 		,"C",09,00})	&&	Cep
	AADD(aStru,{"ESTADO" 	,"C",02,00})	&&	Estado
	AADD(aStru,{"CC" 		,"C",20,00})	&&	Estado
	AADD(aStru,{"DESCCC" 	,"C",40,00})	&&	Estado
	
	// Fabio Flores Regueira - 05.10.15 - ACRESCIMO DO CAMPO BANCO/AGENCIA e CONTA CORRENTE. 
	AADD(aStru,{"NOMBANCO" 	,"C",40,00})	&&	NOME DO BANCO DO COLABORADOR
	AADD(aStru,{"BCAGEN" 	,"C",10,00})	&&	BANCO/AGENCIA DO COLABORADOR
	AADD(aStru,{"CTAC"  	,"C",12,00})	&&	CTA CORRENTE DO COLABORADOR
	
	

	If Select("cCursFunc") > 0
		cCursFunc->(DbCloseArea())
	Endif

/*Substituição do Criatrab por Fwtemporaytable Sergio jr Criare Consulting 09/05/2023 */
    oTable := FWTemporaryTable():New("cCursFunc",aStru)
	otable:addIndex("01",{"FILIAL","MAT","COD"})
	oTable:create()
	cCursFunc:= oTable:GetRealName()
	oTable:Delete()
	/*
	cCursFunc := Criatrab(aStru,.T.)
	Dbusearea(.T.,,cCursFunc,"cCursFunc",.F.,.F.)
    */
	/*DbSelectArea("cCursFunc")
	cIndex	:=	CriaTrab(Nil,.F.)
	cKey    := "FILIAL+MAT+COD"
	IndRegua("cCursFunc",cIndex,cKey,,,"Indexando RegisTroS 01 .......")*/


	aStru	:=	{}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define campos do TRB Cria um arquivo de Apoio ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AADD(aStru,{"FILIAL"	,"C",04,00})	&&	Filial
	AADD(aStru,{"MAT" 		,"C",06,00})	&&	Numero da Matricula
	AADD(aStru,{"COD" 		,"C",02,00})	&&	Codigo Sequencia Depend.
	AADD(aStru,{"RBNOME"	,"C",70,00})	&&	Nome completo funcionario
	AADD(aStru,{"RBDTNASC" 	,"D",08,00})	&&	Data de Nascimento
	AADD(aStru,{"RBSEXO" 	,"C",01,00})	&&	Sexo PERTENCE("MF")
	AADD(aStru,{"RBDSEXO" 	,"C",10,00})
	AADD(aStru,{"RBGRAUPAR" ,"C",01,00})	&&	Grau de Parentesco C=Conjuge;F=Filho;E=Enteado;P=Pai/Mae;O=Outros
	AADD(aStru,{"RBDGRAUPA" ,"C",07,00})
	AADD(aStru,{"RBCIC" 	,"C",11,00})	&&	CPF do dependente
	AADD(aStru,{"RBXMAE" 	,"C",70,00})	&&	Nome da Mae

	If Select("cCursDepn") > 0
		cCursDepn->(DbCloseArea())
	Endif
/*Substituição do Criatrab por Fwtemporaytable Sergio jr Criare Consulting 09/05/2023 */
    oTable := FWTemporaryTable():New("cCursDepn",aStru)
	otable:addIndex("01",{"FILIAL","MAT","COD"})
	oTable:create()
	cCursDepn:= oTable:GetRealName()
	oTable:Delete()
	/*cCursDepn := Criatrab(aStru,.T.)
	Dbusearea(.T.,,cCursDepn,"cCursDepn",.F.,.F.)

	DbSelectArea("cCursDepn")
	cIndex	:=	CriaTrab(Nil,.F.)
	cKey    := "FILIAL+MAT+COD"
	IndRegua("cCursDepn",cIndex,cKey,,,"Indexando RegisTroS 01 .......")*/

	Processa( { |lEnd| Proc_Func() }, 'Aguarde, Selecionando Funcionários....' )
	Processa( { |lEnd| Proc_Depe() }, 'Aguarde, Selecionando Dependentes....' )

	dbSelectArea("cCursFunc")
	dbSetOrder(1)
	cCursFunc->(DbGoTop())
	If !cCursFunc->(Eof())
		Processa( { |lEnd| cRimpFunc() }, 'Aguarde, Processando o Relatório....' )
	Else
		Alert("Arquivo Vazio")
	Endif

/*
	DbSelectArea("cCursFunc")
	Copy to \FoxPro\cCursFunc.Dbf
	
	DbSelectArea("cCursDepn")
	Copy to \FoxPro\cCursDepn.Dbf
*/
	
	RestArea(aArea)

Return Nil


******************************************************************************************************************
Static Function Proc_Func()
******************************************************************************************************************
*** Funcao para 
******************************************************************************************************************

	Local	aArea	:= GetArea()

	cSituacao		:=	mv_par07
	cCategoria		:=	mv_par08

	cQuery := "SELECT RA_FILIAL, RA_MAT, RA_NOMECMP, RA_CIC, RA_NASC, RA_SEXO, RA_ESTCIVI, RA_MAE, RA_TITULOE, RA_ZONASEC, RA_SECAO, RA_PIS, RA_ADMISSA,"
	//cQuery += " RA_RG, RA_COMPLRG, RA_ENDEREC, RA_NUMENDE, RA_COMPLEM, RA_BAIRRO, RA_MUNICIP, RA_CEP, RA_ESTADO, RA_SITFOLH, RA_CATFUNC ,RA_CC"    
    
    // Fabio Flores Regueira - 05.10.15 - ACRESCIMO DO CAMPO BANCO/AGENCIA e CONTA CORRENTE. 
	cQuery += " RA_RG, RA_COMPLRG, RA_ENDEREC, RA_NUMENDE, RA_COMPLEM, RA_BAIRRO, RA_MUNICIP, RA_CEP, RA_ESTADO, RA_SITFOLH, RA_CATFUNC ,RA_CC, RA_XNMBCCO, RA_XBCAGCO, RA_XCTACOL"    

	cQuery += " FROM " + reTsqlname("SRA")
	cQuery += " WHERE D_E_L_E_T_ <> '*'"
	cQuery += " AND RA_FILIAL >= '" + MV_PAR01 + "' AND RA_FILIAL <= '" + MV_PAR02 + "'"
	cQuery += " AND RA_MAT >= '" + MV_PAR03 + "' AND RA_MAT <= '" + MV_PAR04 + "'"
	cQuery += " AND RTRIM(RA_NOMECMP) >= '" + RTRIM(MV_PAR05) + "' AND RTRIM(RA_NOMECMP) <= '" + RTRIM(MV_PAR06) + "'"
	If !Empty(mv_par09) .And. !Empty(mv_par10)  
		cQuery += " AND RA_ADMISSA >= '" + DTOS(mv_par09) + "' AND RA_ADMISSA <= '" + DTOS(mv_par10) + "'"
	Endif
	cQuery += " ORDER BY RA_FILIAL, RA_MAT"
	
	cQuery	:=	changequery(cQuery)

	/*/ Verifica se a tabela esta em USO /*/
	If (Select('Aux_H') > 0)
		DbSelectArea('Aux_H')
		Aux_H->(DbCloseArea())
	EndIf

	TcQuery cQuery new Alias 'Aux_H'

	ProcRegua(Aux_H->(RECCOUNT()))

	Aux_H->(DbGoTop())
	If !Aux_H->(Eof())
		
		Begin Transaction
			While !Aux_H->(Eof())
				
				IncProc(Aux_H->RA_NOMECMP)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Despreza Registros Conforme Situacao e Categoria Funcionarios³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If	!( Aux_H->RA_SITFOLH $ cSituacao ) .OR.  !( Aux_H->RA_CATFUNC $ cCategoria )
					DbSelectArea("Aux_H")
					dbSkip() // Avanca o ponteiro do registro no arquivo
					Loop
				Endif

				cDescCivil	:=	Space(30)
				dbSelectArea("SX5")
				dbSetOrder(1)
				If DbSeek( xFilial("SX5") + "33" + Aux_H->RA_ESTCIVI )
					cDescCivil	:=	FWGetSx5(TamSx3("X5_DESCRI")[4])
				Endif

				DbSelecTarea("cCursFunc")
				RecLock("cCursFunc",.T.)
				cCursFunc->FILIAL		:=	Aux_H->RA_FILIAL	&&	Filial
				cCursFunc->MAT			:=	Aux_H->RA_MAT		&&	Matricula
				cCursFunc->COD			:=	"00"				&&	Codigo Sequencia Depend.
				cCursFunc->TIPO			:=	"TITULAR"
				cCursFunc->NOMECMP		:=	Aux_H->RA_NOMECMP	&&	Nome completo funcionario
				cCursFunc->CIC			:=	Aux_H->RA_CIC		&&	CPF do Funcionario
				cCursFunc->NASC			:=	STOD(Aux_H->RA_NASC)		&&	Data de Nascimento
				cCursFunc->SEXO			:=	Aux_H->RA_SEXO		&&	Sexo do Funcionario Pertence("MF")
				cCursFunc->DSEXO		:=	Iif( Aux_H->RA_SEXO = 'M', "MASCULINO", Iif( Aux_H->RA_SEXO = 'F', "FEMININO", "" ) )
				cCursFunc->ESTCIVI		:=	Aux_H->RA_ESTCIVI	&&	Estado Civil Funcionario EXISTCPO("SX5","33"+Aux_H->RA_ESTCIVI)
				cCursFunc->DESTCIVI		:=	cDescCivil
				cCursFunc->RBGRAUPAR	:=	"T"
				cCursFunc->RBDGRAUPA	:=	"TITULAR"
				cCursFunc->MAE			:=	Aux_H->RA_MAE		&&	Nome da Mae
				cCursFunc->TITULOE		:=	Aux_H->RA_TITULOE	&&	Titulo Eleitoral
				cCursFunc->ZONASEC		:=	Aux_H->RA_ZONASEC	&&	Zona Eleitoral
				cCursFunc->SECAO		:=	Aux_H->RA_SECAO		&&	Secao Eleitoral
				cCursFunc->PIS			:=	Aux_H->RA_PIS		&&	PIS do Funcionario
				cCursFunc->ADMISSA		:=	STOD(Aux_H->RA_ADMISSA)	&&	Data de Admissao
				cCursFunc->RG			:=	Aux_H->RA_RG		&&	RG - Registro Geral
				cCursFunc->COMPLRG		:=	Aux_H->RA_COMPLRG	&&	Complemento do RG
				cCursFunc->ENDEREC		:=	Aux_H->RA_ENDEREC	&&	Endereco do Funcionario
				cCursFunc->NUMENDE		:=	Aux_H->RA_NUMENDE	&&	Numero do Endereco
				cCursFunc->COMPLEM		:=	Aux_H->RA_COMPLEM	&&	Complemento do Endereco
				cCursFunc->BAIRRO		:=	Aux_H->RA_BAIRRO	&&	Bairro
				cCursFunc->MUNICIP		:=	Aux_H->RA_MUNICIP	&&	Municipio
				cCursFunc->CEP			:=	SUBSTR(Aux_H->RA_CEP,1,5)+"-"+SUBSTR(Aux_H->RA_CEP,6,3)		&&	Cep
				cCursFunc->ESTADO		:=	Aux_H->RA_ESTADO	&&	Estado

				cCursFunc->CC			:=	Aux_H->RA_CC	&&	Estado
				cCursFunc->DESCCC		:=	Posicione("CTT",1,xFIlial("CTT")+Aux_H->RA_CC,"CTT_DESC01")	&&	Estado		
				
				// Fabio Flores Regueira - 05.10.15 - ACRESCIMO DO CAMPO BANCO/AGENCIA e CONTA CORRENTE. 
				cCursFunc->NOMBANCO     :=  Aux_H->RA_XNMBCCO   &&  Nome do Banco do Colaborador
				cCursFunc->BCAGEN       :=  Aux_H->RA_XBCAGCO   &&  Banco/Agencia do Colaborador
				cCursFunc->CTAC         :=  Aux_H->RA_XCTACOL   &&  Conta Corrente do Colaborador 
										
				MsUnlock("cCursFunc")

				DbSelectArea("Aux_H")
				dbSkip() // Avanca o ponteiro do registro no arquivo
	
			End
		End Transaction

	EndIf

	RestArea(aArea)

Return


******************************************************************************************************************
Static Function Proc_Depe()
******************************************************************************************************************
*** Funcao para 
******************************************************************************************************************

	Local	aArea	:= GetArea()

	dbSelectArea("cCursFunc")
	dbSetOrder(1)
	ProcRegua(cCursFunc->(RECCOUNT()))

	cCursFunc->(DbGoTop())
	If !cCursFunc->(Eof())
		
		Begin Transaction
			While !cCursFunc->(Eof())
				
				IncProc(Aux_H->RA_NOMECMP)

				dbSelectArea("SRB")
				dbSetOrder(1)	&&	RB_FILIAL + RB_MAT
				DbSeek ( cCursFunc->FILIAL + cCursFunc->MAT )
				
				While !SRB->(Eof()) .And. cCursFunc->FILIAL + cCursFunc->MAT = SRB->RB_FILIAL + SRB->RB_MAT

					IncProc()
				
					cDescGrau	:=	""
					Do Case
					Case	SRB->RB_GRAUPAR ==	'C'
						cDescGrau	:=	'CONJUGE'
					Case	SRB->RB_GRAUPAR ==	'F'
						cDescGrau	:=	'FILHO'
					Case	SRB->RB_GRAUPAR ==	'E'
						cDescGrau	:=	'ENTEADO'
					Case	SRB->RB_GRAUPAR ==	'P'
						cDescGrau	:=	'PAI/MAE'
					Case	SRB->RB_GRAUPAR ==	'O'
						cDescGrau	:=	'OUTROS'
					EndCase
					
					DbSelecTarea("cCursDepn")
					RecLock("cCursDepn",.T.)
					cCursDepn->FILIAL		:=	SRB->RB_FILIAL
					cCursDepn->MAT			:=	SRB->RB_MAT 	&&	Numero da Matricula
					cCursDepn->COD			:=	SRB->RB_COD 	&&	Codigo Sequencia Depend.
					cCursDepn->RBNOME		:=	SRB->RB_NOME 	&&	Nome completo funcionario
					cCursDepn->RBDTNASC		:=	SRB->RB_DTNASC	&&	Data de Nascimento
					cCursDepn->RBSEXO		:=	SRB->RB_SEXO	&&	Sexo PERTENCE("MF")
					cCursDepn->RBDSEXO		:=	Iif( SRB->RB_SEXO = 'M', "MASCULINO", Iif( SRB->RB_SEXO = 'F', "FEMININO", "" ) )
					cCursDepn->RBGRAUPAR	:=	SRB->RB_GRAUPAR	&&	Grau de Parentesco C=Conjuge;F=Filho;E=Enteado;P=Pai/Mae;O=Outros
					cCursDepn->RBDGRAUPA	:=	cDescGrau
					cCursDepn->RBCIC		:=	SRB->RB_CIC		&&	CPF do dependente
					cCursDepn->RBXMAE		:=	SRB->RB_XMAE 	&&	Nome da Mae
					MsUnlock("cCursDepn")
				
					dbSelectArea("SRB")
					dbSkip() // Avanca o ponteiro do registro no arquivo
				
				EndDo

				dbSelectArea("cCursFunc")
				dbSkip() // Avanca o ponteiro do registro no arquivo
			
			EndDo


			&& Adiciona os Dependentes na Tabela Pai
			dbSelectArea("cCursDepn")
			dbSetOrder(1)
			ProcRegua(cCursDepn->(RECCOUNT()))

			cCursDepn->(DbGoTop())
			If !cCursDepn->(Eof())

				While !cCursDepn->(Eof())
				
					IncProc(cCursDepn->RBNOME)

					DbSelecTarea("cCursFunc")
					RecLock("cCursFunc",.T.)
					cCursFunc->FILIAL		:=	cCursDepn->FILIAL		&&	Filial
					cCursFunc->MAT			:=	cCursDepn->MAT			&&	Matricula
					cCursFunc->COD			:=	cCursDepn->COD			&&	Codigo Sequencia Depend.
					cCursFunc->TIPO			:=	"DEPENDENTE"
					cCursFunc->NOMECMP		:=	cCursDepn->RBNOME		&&	Nome completo funcionario
					cCursFunc->NASC			:=	cCursDepn->RBDTNASC		&&	Data de Nascimento
					cCursFunc->SEXO			:=	cCursDepn->RBSEXO		&&	Sexo do Funcionario Pertence("MF")
					cCursFunc->DSEXO		:=	cCursDepn->RBDSEXO
					cCursFunc->RBGRAUPAR	:=	cCursDepn->RBGRAUPAR
					cCursFunc->RBDGRAUPA	:=	cCursDepn->RBDGRAUPA
					cCursFunc->CIC			:=	cCursDepn->RBCIC		&&	CPF do Funcionario
					cCursFunc->MAE			:=	cCursDepn->RBXMAE		&&	Nome da Mae
					MsUnlock("cCursFunc")

					dbSelectArea("cCursDepn")
					dbSkip() // Avanca o ponteiro do registro no arquivo
				
				EndDo
	        
			Endif
	        
		End Transaction

	EndIf

	RestArea(aArea)

Return


******************************************************************************************************************
Static Function cRimpFunc()
******************************************************************************************************************
*** Funcao para 
******************************************************************************************************************

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de Variaveis                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2		:= "de acordo com os parametros informados pelo usuario."
	Local cDesc3		:= "Relatório de Integração de Plano de Saúde - Impresso em: "+DTOC(dDataBase)+" às "+Time()+"."
	Local cPict			:= ""
	Local titulo		:= "Relatório de Integração de Plano de Saúde - Impresso em: "+DTOC(dDataBase)+" às "+Time()+"."
	Local nLin			:= 80

	Local Cabec1		:= "Filial De " + MV_PAR01 + " Ate " + MV_PAR02 + " Matricula De " + MV_PAR03 + " Ate " + MV_PAR04 + " Nome De " + MV_PAR05 + " Ate " + MV_PAR06
	Local Cabec2		:= "Situacoes a Imp. " + MV_PAR07 + "   Categorias a Imp. " + MV_PAR08 + " Admissão De " + DTOC(mv_par09) + " Até " + DTOC(mv_par10)

	Local imprime      	:= .T.
	Local aOrd 			:= {}
	Private lEnd        := .F.
	Private lAbortPrint := .F.
	Private CbTxt       := ""
	Private limite      := 220
	Private tamanho     := "G"
	Private nomeprog    := "PTNR0040-"+cfilant // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo       := 18
	Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey    := 0
	Private cbtxt      	:= Space(10)
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private wnrel      	:= "PTNR0040" // Coloque aqui o nome do arquivo usado para impressao em disco

	Private cString 	:= "cCursFunc"

	dbSelectArea("cCursFunc")
	dbSetOrder(1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

	If nLastKey == 27
		Return
	Endif

	SetDefault(aReturn,cString)

	If nLastKey == 27
		Return
	Endif

	nTipo := If(aReturn[4]==1,15,18)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  30/07/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

	Local nOrdem

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Utilizado pelo EXCEL³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cArqTxt  	:= CriaTrab(NIL,.F.)
	cArqTxt  	:= Alltrim(cArqTxt)+".CSV"
	cEol		  := CHR(13)+CHR(10)
	cNomTrb		:= FCreate(cArqTxt,0)

	//cLinha := "FILIAL;MATRICULA;CODIGO;TIPO;NOME;CPF;NASCIMENTO;SEXO;PARENTESCO;ESTADO CIVIL;NOME DA MAE;TITULO ELEITORAL;ZONA ELEITORAL;SECAO;PIS;ADMISSAO;RG;ENDERECO;BAIRRO;MUNICIPIO;CEP;ESTADO;CC;CCDESCRI"
	
	// Fabio Flores Regueira - 05.10.15 - ACRESCIMO DO CAMPO BANCO/AGENCIA e CONTA CORRENTE. 
	cLinha := "FILIAL;MATRICULA;CODIGO;TIPO;NOME;CPF;NASCIMENTO;SEXO;PARENTESCO;ESTADO CIVIL;NOME DA MAE;TITULO ELEITORAL;ZONA ELEITORAL;SECAO;PIS;ADMISSAO;RG;ENDERECO;BAIRRO;MUNICIPIO;CEP;ESTADO;CC;CCDESCRI;NOMBANCO;BC/AGENCIA;CTACORRENTE"

	fWrite(cNomTrb,cLinha+cEol)

	dbSelectArea("cCursFunc")
	dbSetOrder(1)
	lCabec		:=	.T.
	m_xTipo		:=	""
	m_xFilial	:=	""
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetRegua(RecCount())

	dbGoTop()
	While !EOF()
	
		IncProc(cCursFunc->NOMECMP)

	   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   //³ Verifica o cancelamento pelo usuario...                             ³
	   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nLin > 55 .Or. cCursFunc->FILIAL # m_xFilial // Salto de Página. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin	:=	9
			lCabec	:=	.T.

			@nlin,000 PSAY "Fil"			&&	06	Filial
			@nlin,006 PSAY "Matric"			&&	08	Numero da Matricula
			@nlin,014 PSAY "Tipo"			&&	14	"TITULAR" ou "DEPENDENTE" + Codigo Sequencia Depend.
			@nlin,028 PSAY "Nome"   		&& 	72	Nome completo funcionario ou Dependente
			@nlin,100 PSAY "CPF"			&&	13	CPF do Funcionario ou Dependente
			@nlin,113 PSAY "Nascim"			&&	12	Data de Nascimento
			@nlin,125 PSAY "Sexo"			&& 	05	Sexo do Funcionario Pertence("MF")
			@nlin,130 PSAY "Grau"			&&	10	Grau de Parentesco C=Conjuge;F=Filho;E=Enteado;P=Pai/Mae;O=Outros
			@nlin,140 PSAY "Estado Civil"	&&	32	Estado Civil Funcionario
			@nlin,172 PSAY "Nome da Mae"	&&	42	Nome da Mae
			nLin := nLin + 1 // Avanca a linha de impressao

			@nlin,010 PSAY "Tit.Eleitoral"	&&	15	Titulo Eleitoral
			@nlin,028 PSAY "Zona"   		&& 	10	Zona Eleitoral
			@nlin,038 PSAY "Secao"			&&	06	Secao Eleitoral
			@nlin,044 PSAY "PIS"			&&	14	PIS do Funcionario
			@nlin,058 PSAY "Admissao"		&& 	12	Data de Admissao
			@nlin,070 PSAY "RG"				&&	17	RG - Registro Geral
			@nlin,087 PSAY "Exp"			&&	07	Complemento do RG
			@nlin,100 PSAY "Endereco"		&&	32	Endereco do Funcionario
			@nlin,132 PSAY "Numero"			&&	08	Numero do Endereco
			@nlin,140 PSAY "Complemento"	&&	17	Complemento do Endereco
			@nlin,157 PSAY "Bairro"			&&	22	Bairro
			@nlin,179 PSAY "Municipio"		&&	22	Municipio
			@nlin,201 PSAY "CEP"			&&	10	Cep
			@nlin,211 PSAY "UF"				&&	10	Estado
			nLin := nLin + 1 // Avanca a linha de impressao
			
			@nlin,010 PSAY "Centro Custo"	&&	15	CC
			@nlin,050 PSAY "Descrição Centro Custo"   		&& 	10	Descrição centro de custo
			
			// Fabio Flores Regueira - 05.10.15 - ACRESCIMO DO CAMPO BANCO/AGENCIA e CONTA CORRENTE. 
			@nlin,100 PSAY "Nome Banco"     &&  40 Nome do Banco do Colaborador 
			@nlin,155 PSAY "BC/Agencia"     &&  10 Banco/Agencia do Colaborador 
			@nlin,175 PSAY "Cta Corrente"   &&  12 Conta Corrente do Colaborador 
			
			nLin := nLin + 1 // Avanca a linha de impressao
			@nlin,00 Psay ReplicaTe("_",limiTe)
			nLin := nLin + 1 // Avanca a linha de impressao
					
			m_xFilial	:=	cCursFunc->FILIAL
			lCabec		:=	.F.
		Endif

		If RTRIM(cCursFunc->TIPO) == "TITULAR"
			@nlin,000 PSAY cCursFunc->FILIAL			&&	08	Filial
			@nlin,006 PSAY cCursFunc->MAT				&&	08	Numero da Matricula
		Endif
		@nlin,014 PSAY Iif( RTRIM(cCursFunc->TIPO) == "TITULAR", cCursFunc->TIPO+Space(02), cCursFunc->TIPO+cCursFunc->COD )				&&	14	"TITULAR" ou "DEPENDENTE" + Codigo Sequencia Depend.
		@nlin,028 PSAY cCursFunc->NOMECMP   		&& 	72	Nome completo funcionario ou Dependente
		@nlin,100 PSAY cCursFunc->CIC				&&	13	CPF do Funcionario ou Dependente
		@nlin,113 PSAY DTOC(cCursFunc->NASC)		&&	12	Data de Nascimento
		@nlin,125 PSAY SUBSTR(cCursFunc->DSEXO,1,3)&& 	05	Sexo do Funcionario Pertence("MF")
		@nlin,130 PSAY cCursFunc->RBDGRAUPA			&&	10	Grau de Parentesco C=Conjuge;F=Filho;E=Enteado;P=Pai/Mae;O=Outros
		@nlin,140 PSAY cCursFunc->DESTCIVI			&&	32	Estado Civil Funcionario
		@nlin,172 PSAY cCursFunc->MAE				&&	42	Nome da Mae

		If RTRIM(cCursFunc->TIPO) == "TITULAR"
			nLin := nLin + 1 // Avanca a linha de impressao
			@nlin,010 PSAY cCursFunc->TITULOE			&&	15	Titulo Eleitoral
			@nlin,028 PSAY cCursFunc->ZONASEC   		&& 	10	Zona Eleitoral
			@nlin,038 PSAY cCursFunc->SECAO				&&	06	Secao Eleitoral
			@nlin,044 PSAY cCursFunc->PIS				&&	14	PIS do Funcionario
			@nlin,058 PSAY DTOC(cCursFunc->ADMISSA)		&& 	12	Data de Admissao
			@nlin,070 PSAY cCursFunc->RG				&&	17	RG - Registro Geral
			@nlin,087 PSAY cCursFunc->COMPLRG			&&	07	Complemento do RG
			@nlin,100 PSAY cCursFunc->ENDEREC			&&	32	Endereco do Funcionario
			@nlin,132 PSAY cCursFunc->NUMENDE			&&	08	Numero do Endereco
			@nlin,140 PSAY cCursFunc->COMPLEM			&&	17	Complemento do Endereco
			@nlin,157 PSAY cCursFunc->BAIRRO			&&	22	Bairro
			@nlin,179 PSAY cCursFunc->MUNICIP			&&	22	Municipio
			@nlin,201 PSAY cCursFunc->CEP				&&	10	Cep
			@nlin,211 PSAY cCursFunc->ESTADO			&&	10	Estado

			nLin := nLin + 1 // Avanca a linha de impressao
			@nlin,009 PSAY cCursFunc->CC			&&	15	CC
			@nlin,031 PSAY cCursFunc->DESCCC   		&& 	10	DESCCC

            // Fabio Flores Regueira - 05.10.15 - ACRESCIMO DO CAMPO BANCO/AGENCIA e CONTA CORRENTE. 
			@nlin,100 PSAY cCursFunc->NOMBANCO          &&  40 Nome do banco do Colaborador 
			@nlin,155 PSAY cCursFunc->BCAGEN            &&  10 Banco/Agencia do Colaborador 
			@nlin,175 PSAY cCursFunc->CTAC              &&  12 Conta Corrente do Colaborador 

		Endif


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Cria a linha de impressao em Excel.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cLinha := CHR(160)+cCursFunc->FILIAL+";"
		cLinha += CHR(160)+cCursFunc->MAT+";"
		cLinha += CHR(160)+cCursFunc->COD+";"
		cLinha += Iif( RTRIM(cCursFunc->TIPO) == "TITULAR", cCursFunc->TIPO+Space(02), cCursFunc->TIPO+cCursFunc->COD )+";"
		cLinha += cCursFunc->NOMECMP+";"
		cLinha += CHR(160)+cCursFunc->CIC+";"	
		cLinha += DTOC(cCursFunc->NASC)+";"	
		cLinha += cCursFunc->DSEXO+";"
		cLinha += cCursFunc->RBDGRAUPA+";"
		cLinha += cCursFunc->DESTCIVI+";"
		cLinha += cCursFunc->MAE+";"
		cLinha += Iif( RTRIM(cCursFunc->TIPO) == "TITULAR", "TIT ", Space(04) )+cCursFunc->TITULOE+";"
		cLinha += Iif( RTRIM(cCursFunc->TIPO) == "TITULAR", "ZON ", Space(04) )+cCursFunc->ZONASEC+";"
		cLinha += Iif( RTRIM(cCursFunc->TIPO) == "TITULAR", "SEC ", Space(04) )+cCursFunc->SECAO+";"
		cLinha += Iif( RTRIM(cCursFunc->TIPO) == "TITULAR", "PIS ", Space(04) )+cCursFunc->PIS+";"
		cLinha += DTOC(cCursFunc->ADMISSA)+";"
		cLinha += Iif( RTRIM(cCursFunc->TIPO) == "TITULAR", "RG ", Space(03) )+cCursFunc->RG+" "+cCursFunc->COMPLRG+";"
		cLinha += cCursFunc->ENDEREC + " " + cCursFunc->NUMENDE + " " + cCursFunc->COMPLEM +";"
		cLinha += cCursFunc->BAIRRO+";"
		cLinha += cCursFunc->MUNICIP+";"
		cLinha += cCursFunc->CEP+";"
		cLinha += cCursFunc->ESTADO+";"

		cLinha += cCursFunc->CC+";"
		cLinha += cCursFunc->DESCCC+";"

        // Fabio Flores Regueira - 05.10.15 - ACRESCIMO DO CAMPO BANCO/AGENCIA e CONTA CORRENTE. 
		cLinha += cCursFunc->BCAGEN+";"
        cLinha += cCursFunc->CTAC+";"
                
		fWrite(cNomTrb,cLinha+cEol)

		nLin := nLin + 1 // Avanca a linha de impressao
		m_Tipo	:=	"TITULAR"

		dbSkip() // Avanca o ponteiro do registro no arquivo
		
		If RTRIM(cCursFunc->TIPO) == "TITULAR"
			@nlin,00 Psay ReplicaTe("_",limiTe)
			nLin := nLin + 1 // Avanca a linha de impressao
		Endif
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SET DEVICE TO SCREEN

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif

	MS_FLUSH()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se pode abre em excel ou nao³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Aviso("Planilha Excel","Gerar Planilha Excel?",{"Sim","Nao"}) == 2
		FClose(cNomTrb)
		Return .F.
	EndIf

	FClose(cNomTrb)

	cDirDocs    := MsDocPath()
	aStru		:= {}
	cPath		:= AllTrim(GetTempPath())
	oExcelApp   := NIL
	CpyS2T( cArqTxt, cPath, .F. )
	If ! ApOleClient( 'MsExcel' )
		MsgStop( 'MsExcel nao instalado' )
		Return Nil
	EndIf

	oExcelApp 	:= MsExcel():New()
	oExcelApp	:WorkBooks:Open( cPath+cArqTxt) // Abre uma planilha
	oExcelApp	:SetVisible(.T.)
	lIntExcel 	:= .T.
	
Return


/*--------------------------------------------------------------------------*
* Função: VALIDPERG    | Autor | Roberto Lima            | Data | 09/10/13  *
*---------------------------------------------------------------------------*
* Descrição: Verifica a existencia das perguntas criando-as caso seja       *
*            necessario (caso nao existam).                                 *
*---------------------------------------------------------------------------*/
Static Function ValidPerg()

	Local aArea			:=	GetArea()

	_sAlias := Alias()
	aRegs   := {}

	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)

	// Grupo/Ordem/Pergunta///Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01///Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	Aadd(aRegs,{cPerg , "01" , "Filial De ?                   " ,"","", "mv_ch1" , "C" , 04 ,0 ,0 , "G" , ""          , "mv_par01" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","","XM0",""})
	Aadd(aRegs,{cPerg , "02" , "Filial Ate ?                  " ,"","", "mv_ch2" , "C" , 04 ,0 ,0 , "G" , "naovazio"  , "mv_par02" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","","XM0",""})
	Aadd(aRegs,{cPerg , "03" , "Matricula De ?                " ,"","", "mv_ch3" , "C" , 06 ,0 ,0 , "G" , ""          , "mv_par03" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","","SRA",""})
	Aadd(aRegs,{cPerg , "04" , "Matricula Ate ?               " ,"","", "mv_ch4" , "C" , 06 ,0 ,0 , "G" , "naovazio"  , "mv_par04" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","","SRA",""})
	Aadd(aRegs,{cPerg , "05" , "Nome De ?                     " ,"","", "mv_ch5" , "C" , 30 ,0 ,0 , "G" , ""          , "mv_par05" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","","",""})
	Aadd(aRegs,{cPerg , "06" , "Nome Ate ?                    " ,"","", "mv_ch6" , "C" , 30 ,0 ,0 , "G" , "naovazio"  , "mv_par06" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","","",""})
	Aadd(aRegs,{cPerg , "07" , "Situacoes a Imp. ?            " ,"","", "mv_ch7" , "C" , 05 ,0 ,0 , "G" , "FSituacao" , "mv_par07" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","",""   ,""})
	Aadd(aRegs,{cPerg , "08" , "Categorias a Imp. ?           " ,"","", "mv_ch8" , "C" , 15 ,0 ,0 , "G" , "fCategoria", "mv_par08" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","",""   ,""})
	Aadd(aRegs,{cPerg , "09" , "Data Admissão De ?            " ,"","", "mv_ch9" , "D" , 08 ,0 ,0 , "G" , "" 		  , "mv_par09" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","",""   ,""})
	Aadd(aRegs,{cPerg , "10" , "Data Admissão Ate ?           " ,"","", "mv_cha" , "D" , 08 ,0 ,0 , "G" , ""		  , "mv_par10" , ""    , "" , "" , "" , "" , ""   , "" , "" , "" , "" , "" , "" , "" , "" , "" ,"" ,"","","","","","","","",""   ,""})

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

	RestArea(aArea)
	
Return
//--< fim de arquivo >----------------------------------------------------------------------
