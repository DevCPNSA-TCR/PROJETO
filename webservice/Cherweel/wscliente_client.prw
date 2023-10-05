#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    http://187.94.60.7:8060/ws/cherwellcliente.apw?wsdl
Gerado em        04/27/18 18:18:05
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _ZOSKRML ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSCHERWELLCLIENTE
------------------------------------------------------------------------------- */

WSCLIENT WSCHERWELLCLIENTE

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD INTEGRACHERWELL

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSCLIENTE                AS CHERWELLCLIENTE_CLIENTE
	WSDATA   cINTEGRACHERWELLRESULT    AS string

	// Estruturas mantidas por compatibilidade - NÃO USAR
	//WSDATA oWSCLIENTE AS CHERWELLCLIENTE_CLIENTE

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCHERWELLCLIENTE
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20180402 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCHERWELLCLIENTE
	::oWSCLIENTE         := CHERWELLCLIENTE_CLIENTE():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSCLIENTE         := ::oWSCLIENTE
Return

WSMETHOD RESET WSCLIENT WSCHERWELLCLIENTE
	::oWSCLIENTE         := NIL 
	::cINTEGRACHERWELLRESULT := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSCLIENTE         := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCHERWELLCLIENTE
Local oClone := WSCHERWELLCLIENTE():New()
	oClone:_URL          := ::_URL 
	oClone:oWSCLIENTE    :=  IIF(::oWSCLIENTE = NIL , NIL ,::oWSCLIENTE:Clone() )
	oClone:cINTEGRACHERWELLRESULT := ::cINTEGRACHERWELLRESULT

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSCLIENTE    := oClone:oWSCLIENTE
Return oClone

// WSDL Method INTEGRACHERWELL of Service WSCHERWELLCLIENTE

WSMETHOD INTEGRACHERWELL WSSEND oWSCLIENTE WSRECEIVE cINTEGRACHERWELLRESULT WSCLIENT WSCHERWELLCLIENTE
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<INTEGRACHERWELL xmlns="http://187.94.60.7:8060/ws/cherwellcliente.apw">'
cSoap += WSSoapValue("CLIENTE", ::oWSCLIENTE, oWSCLIENTE , "CLIENTE", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</INTEGRACHERWELL>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://187.94.60.7:8060/ws/cherwellcliente.apw/INTEGRACHERWELL",; 
	"DOCUMENT","http://187.94.60.7:8060/ws/cherwellcliente.apw",,"1.031217",; 
	"http://187.94.60.7:8060/ws/CHERWELLCLIENTE.apw")

::Init()
::cINTEGRACHERWELLRESULT :=  WSAdvValue( oXmlRet,"_INTEGRACHERWELLRESPONSE:_INTEGRACHERWELLRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure CLIENTE

WSSTRUCT CHERWELLCLIENTE_CLIENTE
	WSDATA   cWSBACEN                  AS string
	WSDATA   cWSBAIRRO                 AS string
	WSDATA   cWSCEP                    AS string
	WSDATA   cWSCNPJ                   AS string
	WSDATA   cWSCODCHER                AS string
	WSDATA   cWSDDD                    AS string
	WSDATA   cWSEMAIL                  AS string
	WSDATA   cWSEND                    AS string
	WSDATA   cWSESTADO                 AS string
	WSDATA   cWSFANTASIA               AS string
	WSDATA   cWSFILIAL                 AS string
	WSDATA   cWSINSCEST                AS string
	WSDATA   cWSINSCMUN                AS string
	WSDATA   cWSMUNIC                  AS string
	WSDATA   cWSPASSWORD               AS string
	WSDATA   cWSRAZAO                  AS string
	WSDATA   cWSTEL                    AS string
	WSDATA   cWSUSUARIO                AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CHERWELLCLIENTE_CLIENTE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CHERWELLCLIENTE_CLIENTE
Return

WSMETHOD CLONE WSCLIENT CHERWELLCLIENTE_CLIENTE
	Local oClone := CHERWELLCLIENTE_CLIENTE():NEW()
	oClone:cWSBACEN             := ::cWSBACEN
	oClone:cWSBAIRRO            := ::cWSBAIRRO
	oClone:cWSCEP               := ::cWSCEP
	oClone:cWSCNPJ              := ::cWSCNPJ
	oClone:cWSCODCHER           := ::cWSCODCHER
	oClone:cWSDDD               := ::cWSDDD
	oClone:cWSEMAIL             := ::cWSEMAIL
	oClone:cWSEND               := ::cWSEND
	oClone:cWSESTADO            := ::cWSESTADO
	oClone:cWSFANTASIA          := ::cWSFANTASIA
	oClone:cWSFILIAL            := ::cWSFILIAL
	oClone:cWSINSCEST           := ::cWSINSCEST
	oClone:cWSINSCMUN           := ::cWSINSCMUN
	oClone:cWSMUNIC             := ::cWSMUNIC
	oClone:cWSPASSWORD          := ::cWSPASSWORD
	oClone:cWSRAZAO             := ::cWSRAZAO
	oClone:cWSTEL               := ::cWSTEL
	oClone:cWSUSUARIO           := ::cWSUSUARIO
Return oClone

WSMETHOD SOAPSEND WSCLIENT CHERWELLCLIENTE_CLIENTE
	Local cSoap := ""
	cSoap += WSSoapValue("WSBACEN", ::cWSBACEN, ::cWSBACEN , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSBAIRRO", ::cWSBAIRRO, ::cWSBAIRRO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSCEP", ::cWSCEP, ::cWSCEP , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSCNPJ", ::cWSCNPJ, ::cWSCNPJ , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSCODCHER", ::cWSCODCHER, ::cWSCODCHER , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSDDD", ::cWSDDD, ::cWSDDD , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSEMAIL", ::cWSEMAIL, ::cWSEMAIL , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSEND", ::cWSEND, ::cWSEND , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSESTADO", ::cWSESTADO, ::cWSESTADO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSFANTASIA", ::cWSFANTASIA, ::cWSFANTASIA , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSFILIAL", ::cWSFILIAL, ::cWSFILIAL , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSINSCEST", ::cWSINSCEST, ::cWSINSCEST , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSINSCMUN", ::cWSINSCMUN, ::cWSINSCMUN , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSMUNIC", ::cWSMUNIC, ::cWSMUNIC , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSPASSWORD", ::cWSPASSWORD, ::cWSPASSWORD , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSRAZAO", ::cWSRAZAO, ::cWSRAZAO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSTEL", ::cWSTEL, ::cWSTEL , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSUSUARIO", ::cWSUSUARIO, ::cWSUSUARIO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap


