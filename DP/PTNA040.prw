/* Foi apresentando pelo Coordenador Ricardo Ferreira a pend�ncia no setor de RH, ao qual os funcion�rios que n�o tinham
seu provisionamento de f�rias (SRF) incluindo no sistema manualmente, com isso gerava o problema de em alguns casos
ultrapassar o per�odo CONCESSIVO m�ximo para f�ria gerando o pagamento dobrado das f�rias ao funcion�rio.          

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
	cQuery += " AND RTRIM(SRF.RF_DATINI2) = ''"				&&	CASO N�O TENHA A PROGRAMA��O DAS FERIAS LIMITE PARA VENCER
	cQuery += " AND SRF.RF_DFERVAT >= 30"				&&	30 DIAS EQUIVALE A UM PER�DO DE 12 MESES CADA 2,5 � UM M�S
	cQuery += " ORDER BY SRF.RF_FILIAL, SRF.RF_MAT"

	If ( Select ( "_Aux" ) <> 0 )
  		dbSelectArea ( "_Aux" )
	   dbCloseArea ()
	Endif

	cQuery := ChangeQuery(cQuery)
	TcQuery cQuery Alias _Aux new
    
    
    /* inserido mensagem de confirma��o do processo.
       Felipe do Nascimento - 26/11/2014
    */
    cMsg += "Este Processo visa normalizar os registros de programa��o de f�rias"
    cMsg += " para os funcion�rios sem provisionamento de f�rias (SRF)."
    cMsg += " A condi��o de filtro dos funcion�rios que ser�o considerados � : '
    cMsg += " N�o demitidos, data inicial 1o. programa��o vazia e dias de f�rias vencidos maior ou igual a 30 dias."
    cMsg += ' O campo de atualiza��o autom�tica ser� informado como "A" idenfiticando os funcion�rios atualizados'
    cMsg += " por esta rotina. Confirmar processo ?"
    
    if IW_MsgBox(cMsg,"Aten��o","YESNO")
    	Processa( {|| PTNA040A() }, "F�rias Compuls�ria", "Processando aguarde...", .f.)
    endif
	
Return

Static Function PTNA040A()

	DbSelecTarea("_Aux")
	DbGoTop()

	//��������������������������������������������������������������Ŀ
	//� Carrega Regua Processamento                                  �
	//����������������������������������������������������������������
	nCont	:=	0

	While _Aux->(!Eof())

		IncProc( "Marca��o F�rias " + _Aux->RF_MAT  )
		
		nRecno	:=	_Aux->XPOSREC

		//��������������������������������������������������������������Ŀ
		//� Periodo Aquisitivo                                           �
		//����������������������������������������������������������������
		DFIMPAQUI := fCalcFimAq(STOD(_Aux->RF_DATABAS))	&&	aquisitivo - � o per�odo de 12 meses em que o empregado tem de cumprir para ter direito as ferias
		DPRPAQUI  := fCalcFimAq(DFIMPAQUI+1)			&&	concessivo - per�odo de 12 meses a partir do termino do per�odo aquisitivo em que o empregador tem de conceder as ferias ao empregado.

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

	Alert("Processo conclu�do. Alterados: " + Strzero(nCont,5,0) + " Registros(s)")
	
	RestArea(aAreaSrf)

	RestArea(aArea)

Return()


/*
-----------------------------------------------------------------------------------------------------
| FUN��O: vRF_DATAINI                 | AUTOR: Felipe do Nascimento              | DATA: 27/08/2014 |
-----------------------------------------------------------------------------------------------------
| OBJETIVO: Validar a data concessiva limite fornecida no campo RF_DATAINI (programa��o de f�rias). |
|           Considerando como base a data base da programa��o. Calculada automaticamente a cada     |
|           fechamento.                                                                             |
-----------------------------------------------------------------------------------------------------
|                                     CONTROLE DE REVIS�ES                                          |
-----------------------------------------------------------------------------------------------------
|    DATA    |         AUTOR          |                      OBJETIVO                               |
-----------------------------------------------------------------------------------------------------
| 99/99/9999 |XXXXXXXXXXXXXXXXXXXXXXXX|                                                             |
-----------------------------------------------------------------------------------------------------
*/
user function vRF_DATAINI(cMat, dData)
*----------------------------------------------------------------------------------------------------
local cTitulo  := "Aten��o!"
local cTexto1  := "Data de programa��o proporciona pagamento de f�rias em dobro."
local cTexto2  := "Data de programa��o proporciona pagamento de f�rias antes do per�odo aquisitivo. O provisionamento ser� comprometido."

local cArea := getArea()

SRF->(dbSetOrder(1))
SRF->(dbSeek(xFilial("SRF")+cMat))

dDataLim := fCalcFimAq(SRF->RF_DATABAS) 

dData1 := fCalcFimAq(dDataLim+1)
dData1 -= 45

if dData > dData1  // data proporciona f�rias em dobro
   msgAlert(cTexto1, cTitulo)
    
elseif dData < dDataLim  // data antes do per�odo aquisitivo
   msgAlert(cTexto2, cTitulo)
   
endif

restArea(cArea)

return (.t.)

