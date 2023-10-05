/* Foi apresentando pelo Coordenador Ricardo Ferreira a pendência no setor de RH, ao qual os funcionários que não tinham
seu provisionamento de férias (SRF) incluindo no sistema manualmente, com isso gerava o problema de em alguns casos
ultrapassar o período CONCESSIVO máximo para féria gerando o pagamento dobrado das férias ao funcionário.          

Rotina gerada pelo Flavio Oliveira - 18/06/2014
*/

#include "tbiconn.ch"
#include "protheus.ch"
#include "topconn.ch"

User Function PTNA040()

	Local FimPAqui    := ""
	Local DFimPAqui   := ""
	Local DPRPAqui    := ""
	local cMsg := ""

	aArea			:=	GetArea()

	dbSelectArea( "SRF" )
	aAreaSrf		:=	GetArea()

//	PREPARE ENVIRONMENT EMPRESA "T1" FILIAL "D MG 01 " MODULO "GPE"

	cQuery := ''
	cQuery += "SELECT SRF.RF_FILIAL, SRF.RF_MAT, SRF.RF_DATABAS, SRF.RF_PD, SRF.RF_IVENPEN,"
	cQuery += " SRF.RF_FVENPEN, SRF.RF_DVENPEN, SRF.R_E_C_N_O_ AS XPOSREC, SRA.RA_SITFOLH, SRA.RA_ADMISSA"
	cQuery += " FROM " + reTsqlname("SRF") + " SRF, " + reTsqlname("SRA") + " SRA"
	cQuery += " WHERE SRF.D_E_L_E_T_ <> '*'"
	cQuery += " AND SRA.D_E_L_E_T_ <> '*'"
	cQuery += " AND SRF.RF_FILIAL = SRA.RA_FILIAL"
	cQuery += " AND SRF.RF_MAT = SRA.RA_MAT"
	cQuery += " AND RTRIM(SRA.RA_SITFOLH) <> 'D'"
	cQuery += " AND RTRIM(SRF.RF_DATAINI) = ''"
	cQuery += " AND RTRIM(SRF.RF_DATINI2) = ''"				&&	CASO NÃO TENHA A PROGRAMAÇÃO DAS FERIAS LIMITE PARA VENCER
	cQuery += " AND SRF.RF_DFERVAT >= 30"				&&	30 DIAS EQUIVALE A UM PERÍDO DE 12 MESES CADA 2,5 É UM MÊS
	cQuery += " ORDER BY SRF.RF_FILIAL, SRF.RF_MAT"

	If ( Select ( "_Aux" ) <> 0 )
  		dbSelectArea ( "_Aux" )
	   dbCloseArea ()
	Endif

	cQuery := ChangeQuery(cQuery)
	TcQuery cQuery Alias _Aux new
    
    
    /* inserido mensagem de confirmação do processo.
       Felipe do Nascimento - 26/11/2014
    */
    cMsg += "Este Processo visa normalizar os registros de programação de férias"
    cMsg += " para os funcionários sem provisionamento de férias (SRF)."
    cMsg += " A condição de filtro dos funcionários que serão considerados é : '
    cMsg += " Não demitidos, data inicial 1o. programação vazia e dias de férias vencidos maior ou igual a 30 dias."
    cMsg += ' O campo de atualização automática será informado como "A" idenfiticando os funcionários atualizados'
    cMsg += " por esta rotina. Confirmar processo ?"
    
    if IW_MsgBox(cMsg,"Atenção","YESNO")
    	Processa( {|| PTNA040A() }, "Férias Compulsória", "Processando aguarde...", .f.)
    endif
	
Return

Static Function PTNA040A()

	DbSelecTarea("_Aux")
	DbGoTop()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Regua Processamento                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nCont	:=	0

	While _Aux->(!Eof())

		IncProc( "Marcação Férias " + _Aux->RF_MAT  )
		
		nRecno	:=	_Aux->XPOSREC

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Periodo Aquisitivo                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DFIMPAQUI := fCalcFimAq(STOD(_Aux->RF_DATABAS))	&&	aquisitivo - é o período de 12 meses em que o empregado tem de cumprir para ter direito as ferias
		DPRPAQUI  := fCalcFimAq(DFIMPAQUI+1)			&&	concessivo - período de 12 meses a partir do termino do período aquisitivo em que o empregador tem de conceder as ferias ao empregado.

		cLMaxAqu	:=	DFIMPAQUI - 45	&&	DT.LIMITE MAXIMA AQUISITIVA
		cLMaxCon	:=	DPRPAQUI - 45	&&	DT.LIMITE MAXIMA CONCESSIVA

        /*
		cDtBase		:= STOD(_Aux->RF_IVENPEN)													//-- Data base de ferias 
		cPerAquis	:= DtoC(STOD(_Aux->RF_IVENPEN)) + Space(2) + DtoC(STOD(SRF->RF_FVENPEN))	//-- Periodo aquisitivo 
		cLimideal	:= DtoC(STOD(_Aux->RF_FVENPEN) + 30)										//-- Data limite Ideal
		cLimMax		:= DtoC(DFIMPAQUI - 45) 													//-- Data Limite Maximo
		FerVenc		:= _Aux->RF_DVENPEN 														//-- Ferias Vencidas 

		SRA->RA_ADMISSA	&&	DATA DE ADMISSAO
		SRF->RF_DATABAS	&&	DTA.BASE FERIAS
		DFIMPAQUI + 30	&&	DT.LIMITE IDEIAL
		DPRPAQUI - 45	&&	DT.LIMITE MAXIMA
		*/

		dbSelectArea( "SRF" )
		SRF->(DbGoTo(nRecno))		
		RecLock("SRF",.F.)
		SRF->RF_DATAINI	:=	cLMaxCon
		SRF->RF_XAUTO	:=	"A" 
		SRF->RF_DFEPRO1	:=	30
		MsUnlock("SRF")

		DbSelecTarea("_Aux")
		Dbskip()
		
		nCont++

	Enddo
	
//	RESET ENVIRONMENT

	Alert("Processo concluído. Alterados: " + Strzero(nCont,5,0) + " Registros(s)")
	
	RestArea(aAreaSrf)

	RestArea(aArea)

Return()


/*
-----------------------------------------------------------------------------------------------------
| FUNÇÃO: vRF_DATAINI                 | AUTOR: Felipe do Nascimento              | DATA: 27/08/2014 |
-----------------------------------------------------------------------------------------------------
| OBJETIVO: Validar a data concessiva limite fornecida no campo RF_DATAINI (programação de férias). |
|           Considerando como base a data base da programação. Calculada automaticamente a cada     |
|           fechamento.                                                                             |
-----------------------------------------------------------------------------------------------------
|                                     CONTROLE DE REVISÕES                                          |
-----------------------------------------------------------------------------------------------------
|    DATA    |         AUTOR          |                      OBJETIVO                               |
-----------------------------------------------------------------------------------------------------
| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
-----------------------------------------------------------------------------------------------------
*/
user function vRF_DATAINI(cMat, dData)
*----------------------------------------------------------------------------------------------------
local cTitulo  := "Atenção!"
local cTexto1  := "Data de programação proporciona pagamento de férias em dobro."
local cTexto2  := "Data de programação proporciona pagamento de férias antes do período aquisitivo. O provisionamento será comprometido."

local cArea := getArea()

SRF->(dbSetOrder(1))
SRF->(dbSeek(xFilial("SRF")+cMat))

dDataLim := fCalcFimAq(SRF->RF_DATABAS) 

dData1 := fCalcFimAq(dDataLim+1)
dData1 -= 45

if dData > dData1  // data proporciona férias em dobro
   msgAlert(cTexto1, cTitulo)
    
elseif dData < dDataLim  // data antes do período aquisitivo
   msgAlert(cTexto2, cTitulo)
   
endif

restArea(cArea)

return (.t.)

