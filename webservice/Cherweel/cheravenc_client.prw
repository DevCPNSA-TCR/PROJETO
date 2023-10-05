#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://187.94.60.7:8060/ws/CHERWELLALTERVENC.apw?WSDL
Gerado em        09/02/17 09:06:49
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _NPRJKDN ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSCHERWELLALTERVENC
------------------------------------------------------------------------------- */

WSCLIENT WSCHERWELLALTERVENC

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ALTVENC

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSAVENC                  AS CHERWELLALTERVENC_AVENC
	WSDATA   lALTVENCRESULT            AS boolean

	// Estruturas mantidas por compatibilidade - NÃO USAR
	//WSDATA   oWSAVENC                  AS CHERWELLALTERVENC_AVENC

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCHERWELLALTERVENC
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20170721 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCHERWELLALTERVENC
	::oWSAVENC           := CHERWELLALTERVENC_AVENC():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSAVENC           := ::oWSAVENC
Return

WSMETHOD RESET WSCLIENT WSCHERWELLALTERVENC
	::oWSAVENC           := NIL 
	::lALTVENCRESULT     := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSAVENC           := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCHERWELLALTERVENC
Local oClone := WSCHERWELLALTERVENC():New()
	oClone:_URL          := ::_URL 
	oClone:oWSAVENC      :=  IIF(::oWSAVENC = NIL , NIL ,::oWSAVENC:Clone() )
	oClone:lALTVENCRESULT := ::lALTVENCRESULT

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSAVENC      := oClone:oWSAVENC
Return oClone

// WSDL Method ALTVENC of Service WSCHERWELLALTERVENC

WSMETHOD ALTVENC WSSEND oWSAVENC WSRECEIVE lALTVENCRESULT WSCLIENT WSCHERWELLALTERVENC
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ALTVENC xmlns="http://187.94.60.7:8060/ws/CHERWELLALTERVENC.apw">'
cSoap += WSSoapValue("AVENC", ::oWSAVENC, oWSAVENC , "AVENC", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</ALTVENC>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://187.94.60.7:8060/ws/CHERWELLALTERVENC.apw/ALTVENC",; 
	"DOCUMENT","http://187.94.60.7:8060/ws/CHERWELLALTERVENC.apw",,"1.031217",; 
	"http://187.94.60.7:8060/ws/CHERWELLALTERVENC.apw")

::Init()
::lALTVENCRESULT     :=  WSAdvValue( oXmlRet,"_ALTVENCRESPONSE:_ALTVENCRESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure AVENC

WSSTRUCT CHERWELLALTERVENC_AVENC
	WSDATA   cCDELIN                   AS string
	WSDATA   cCFIL                     AS string
	WSDATA   cCPEDIDO                  AS string
	WSDATA   cCVENCIMENTO              AS string
	WSDATA   cCWSPASSWORD              AS string
	WSDATA   cCWSUSUARIO               AS string
	WSDATA   nNCONTRATO                AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CHERWELLALTERVENC_AVENC
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CHERWELLALTERVENC_AVENC
Return

WSMETHOD CLONE WSCLIENT CHERWELLALTERVENC_AVENC
	Local oClone := CHERWELLALTERVENC_AVENC():NEW()
	oClone:cCDELIN              := ::cCDELIN
	oClone:cCFIL                := ::cCFIL
	oClone:cCPEDIDO             := ::cCPEDIDO
	oClone:cCVENCIMENTO         := ::cCVENCIMENTO
	oClone:cCWSPASSWORD         := ::cCWSPASSWORD
	oClone:cCWSUSUARIO          := ::cCWSUSUARIO
	oClone:nNCONTRATO           := ::nNCONTRATO
Return oClone

WSMETHOD SOAPSEND WSCLIENT CHERWELLALTERVENC_AVENC
	Local cSoap := ""
	cSoap += WSSoapValue("CDELIN", ::cCDELIN, ::cCDELIN , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CFIL", ::cCFIL, ::cCFIL , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CPEDIDO", ::cCPEDIDO, ::cCPEDIDO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CVENCIMENTO", ::cCVENCIMENTO, ::cCVENCIMENTO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CWSPASSWORD", ::cCWSPASSWORD, ::cCWSPASSWORD , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CWSUSUARIO", ::cCWSUSUARIO, ::cCWSUSUARIO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("NCONTRATO", ::nNCONTRATO, ::nNCONTRATO , "float", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap


