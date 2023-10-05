//http://187.94.60.7:8035/ws/CENTRAPR.apw?wsdl      

//http://conportonovo-tst-protheus.totvscloud.com.br:5103/ws/CENTRAPR.apw?wsdl      

#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://conportonovo-tst-protheus.totvscloud.com.br:5103/ws/CENTRAPR.apw?wsdl
Gerado em        12/12/18 14:01:17
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _VNWHCRY ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSCENTRAPR
------------------------------------------------------------------------------- */

WSCLIENT WSCENTRAPR

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD APRCOTACAO
	WSMETHOD APRPEDCOM
	WSMETHOD CHQCOTACAO
	WSMETHOD CHQMAPCOT
	WSMETHOD CHQMAPPC
	WSMETHOD CHQPEDCOM
	WSMETHOD CHQVALCOT
	WSMETHOD CHQVALPC
	WSMETHOD LOGUSR

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cCRECEB                   AS string
	WSDATA   cAPRCOTACAORESULT         AS string
	WSDATA   oWSLISTPCAP               AS CENTRAPR_STARRAYPCAP
	WSDATA   cAPRPEDCOMRESULT          AS string
	WSDATA   oWSCHQCOTACAORESULT       AS CENTRAPR_COTACAO
	WSDATA   oWSCHQMAPCOTRESULT        AS CENTRAPR_STARRAYMAPCOT
	WSDATA   oWSCHQMAPPCRESULT         AS CENTRAPR_STARRAYMAPPC
	WSDATA   oWSCHQPEDCOMRESULT        AS CENTRAPR_PEDCOM
	WSDATA   oWSCHQVALCOTRESULT        AS CENTRAPR_STARRAYVALOR
	WSDATA   oWSCHQVALPCRESULT         AS CENTRAPR_STARRAYVALOR
	WSDATA   cLOGUSRRESULT             AS string

	// Estruturas mantidas por compatibilidade - NÃO USAR
	WSDATA   oWSSTARRAYPCAP            AS CENTRAPR_STARRAYPCAP

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCENTRAPR
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20170624 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCENTRAPR
	::oWSLISTPCAP        := CENTRAPR_STARRAYPCAP():New()
	::oWSCHQCOTACAORESULT := CENTRAPR_COTACAO():New()
	::oWSCHQMAPCOTRESULT := CENTRAPR_STARRAYMAPCOT():New()
	::oWSCHQMAPPCRESULT  := CENTRAPR_STARRAYMAPPC():New()
	::oWSCHQPEDCOMRESULT := CENTRAPR_PEDCOM():New()
	::oWSCHQVALCOTRESULT := CENTRAPR_STARRAYVALOR():New()
	::oWSCHQVALPCRESULT  := CENTRAPR_STARRAYVALOR():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSSTARRAYPCAP     := ::oWSLISTPCAP
Return

WSMETHOD RESET WSCLIENT WSCENTRAPR
	::cCRECEB            := NIL 
	::cAPRCOTACAORESULT  := NIL 
	::oWSLISTPCAP        := NIL 
	::cAPRPEDCOMRESULT   := NIL 
	::oWSCHQCOTACAORESULT := NIL 
	::oWSCHQMAPCOTRESULT := NIL 
	::oWSCHQMAPPCRESULT  := NIL 
	::oWSCHQPEDCOMRESULT := NIL 
	::oWSCHQVALCOTRESULT := NIL 
	::oWSCHQVALPCRESULT  := NIL 
	::cLOGUSRRESULT      := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSSTARRAYPCAP     := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCENTRAPR
Local oClone := WSCENTRAPR():New()
	oClone:_URL          := ::_URL 
	oClone:cCRECEB       := ::cCRECEB
	oClone:cAPRCOTACAORESULT := ::cAPRCOTACAORESULT
	oClone:oWSLISTPCAP   :=  IIF(::oWSLISTPCAP = NIL , NIL ,::oWSLISTPCAP:Clone() )
	oClone:cAPRPEDCOMRESULT := ::cAPRPEDCOMRESULT
	oClone:oWSCHQCOTACAORESULT :=  IIF(::oWSCHQCOTACAORESULT = NIL , NIL ,::oWSCHQCOTACAORESULT:Clone() )
	oClone:oWSCHQMAPCOTRESULT :=  IIF(::oWSCHQMAPCOTRESULT = NIL , NIL ,::oWSCHQMAPCOTRESULT:Clone() )
	oClone:oWSCHQMAPPCRESULT :=  IIF(::oWSCHQMAPPCRESULT = NIL , NIL ,::oWSCHQMAPPCRESULT:Clone() )
	oClone:oWSCHQPEDCOMRESULT :=  IIF(::oWSCHQPEDCOMRESULT = NIL , NIL ,::oWSCHQPEDCOMRESULT:Clone() )
	oClone:oWSCHQVALCOTRESULT :=  IIF(::oWSCHQVALCOTRESULT = NIL , NIL ,::oWSCHQVALCOTRESULT:Clone() )
	oClone:oWSCHQVALPCRESULT :=  IIF(::oWSCHQVALPCRESULT = NIL , NIL ,::oWSCHQVALPCRESULT:Clone() )
	oClone:cLOGUSRRESULT := ::cLOGUSRRESULT

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSSTARRAYPCAP := oClone:oWSLISTPCAP
Return oClone

// WSDL Method APRCOTACAO of Service WSCENTRAPR

WSMETHOD APRCOTACAO WSSEND cCRECEB WSRECEIVE cAPRCOTACAORESULT WSCLIENT WSCENTRAPR
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<APRCOTACAO xmlns="http://conportonovo-tst-protheus.totvscloud.com.br:5103/">'
cSoap += WSSoapValue("CRECEB", ::cCRECEB, cCRECEB , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</APRCOTACAO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://conportonovo-tst-protheus.totvscloud.com.br:5103/APRCOTACAO",; 
	"DOCUMENT","http://conportonovo-tst-protheus.totvscloud.com.br:5103/",,"1.031217",; 
	"http://conportonovo-tst-protheus.totvscloud.com.br:5103/ws/CENTRAPR.apw")

::Init()
::cAPRCOTACAORESULT  :=  WSAdvValue( oXmlRet,"_APRCOTACAORESPONSE:_APRCOTACAORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method APRPEDCOM of Service WSCENTRAPR

WSMETHOD APRPEDCOM WSSEND oWSLISTPCAP WSRECEIVE cAPRPEDCOMRESULT WSCLIENT WSCENTRAPR
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<APRPEDCOM xmlns="http://conportonovo-tst-protheus.totvscloud.com.br:5103/">'
cSoap += WSSoapValue("LISTPCAP", ::oWSLISTPCAP, oWSLISTPCAP , "STARRAYPCAP", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</APRPEDCOM>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://conportonovo-tst-protheus.totvscloud.com.br:5103/APRPEDCOM",; 
	"DOCUMENT","http://conportonovo-tst-protheus.totvscloud.com.br:5103/",,"1.031217",; 
	"http://conportonovo-tst-protheus.totvscloud.com.br:5103/ws/CENTRAPR.apw")

::Init()
::cAPRPEDCOMRESULT   :=  WSAdvValue( oXmlRet,"_APRPEDCOMRESPONSE:_APRPEDCOMRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CHQCOTACAO of Service WSCENTRAPR

WSMETHOD CHQCOTACAO WSSEND cCRECEB WSRECEIVE oWSCHQCOTACAORESULT WSCLIENT WSCENTRAPR
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CHQCOTACAO xmlns="http://conportonovo-tst-protheus.totvscloud.com.br:5103/">'
cSoap += WSSoapValue("CRECEB", ::cCRECEB, cCRECEB , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CHQCOTACAO>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://conportonovo-tst-protheus.totvscloud.com.br:5103/CHQCOTACAO",; 
	"DOCUMENT","http://conportonovo-tst-protheus.totvscloud.com.br:5103/",,"1.031217",; 
	"http://conportonovo-tst-protheus.totvscloud.com.br:5103/ws/CENTRAPR.apw")

::Init()
::oWSCHQCOTACAORESULT:SoapRecv( WSAdvValue( oXmlRet,"_CHQCOTACAORESPONSE:_CHQCOTACAORESULT","COTACAO",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CHQMAPCOT of Service WSCENTRAPR

WSMETHOD CHQMAPCOT WSSEND cCRECEB WSRECEIVE oWSCHQMAPCOTRESULT WSCLIENT WSCENTRAPR
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CHQMAPCOT xmlns="http://conportonovo-tst-protheus.totvscloud.com.br:5103/">'
cSoap += WSSoapValue("CRECEB", ::cCRECEB, cCRECEB , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CHQMAPCOT>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://conportonovo-tst-protheus.totvscloud.com.br:5103/CHQMAPCOT",; 
	"DOCUMENT","http://conportonovo-tst-protheus.totvscloud.com.br:5103/",,"1.031217",; 
	"http://conportonovo-tst-protheus.totvscloud.com.br:5103/ws/CENTRAPR.apw")

::Init()
::oWSCHQMAPCOTRESULT:SoapRecv( WSAdvValue( oXmlRet,"_CHQMAPCOTRESPONSE:_CHQMAPCOTRESULT","STARRAYMAPCOT",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CHQMAPPC of Service WSCENTRAPR

WSMETHOD CHQMAPPC WSSEND cCRECEB WSRECEIVE oWSCHQMAPPCRESULT WSCLIENT WSCENTRAPR
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CHQMAPPC xmlns="http://conportonovo-tst-protheus.totvscloud.com.br:5103/">'
cSoap += WSSoapValue("CRECEB", ::cCRECEB, cCRECEB , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CHQMAPPC>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://conportonovo-tst-protheus.totvscloud.com.br:5103/CHQMAPPC",; 
	"DOCUMENT","http://conportonovo-tst-protheus.totvscloud.com.br:5103/",,"1.031217",; 
	"http://conportonovo-tst-protheus.totvscloud.com.br:5103/ws/CENTRAPR.apw")

::Init()
::oWSCHQMAPPCRESULT:SoapRecv( WSAdvValue( oXmlRet,"_CHQMAPPCRESPONSE:_CHQMAPPCRESULT","STARRAYMAPPC",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CHQPEDCOM of Service WSCENTRAPR

WSMETHOD CHQPEDCOM WSSEND cCRECEB WSRECEIVE oWSCHQPEDCOMRESULT WSCLIENT WSCENTRAPR
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CHQPEDCOM xmlns="http://conportonovo-tst-protheus.totvscloud.com.br:5103/">'
cSoap += WSSoapValue("CRECEB", ::cCRECEB, cCRECEB , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CHQPEDCOM>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://conportonovo-tst-protheus.totvscloud.com.br:5103/CHQPEDCOM",; 
	"DOCUMENT","http://conportonovo-tst-protheus.totvscloud.com.br:5103/",,"1.031217",; 
	"http://conportonovo-tst-protheus.totvscloud.com.br:5103/ws/CENTRAPR.apw")

::Init()
::oWSCHQPEDCOMRESULT:SoapRecv( WSAdvValue( oXmlRet,"_CHQPEDCOMRESPONSE:_CHQPEDCOMRESULT","PEDCOM",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CHQVALCOT of Service WSCENTRAPR

WSMETHOD CHQVALCOT WSSEND cCRECEB WSRECEIVE oWSCHQVALCOTRESULT WSCLIENT WSCENTRAPR
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CHQVALCOT xmlns="http://conportonovo-tst-protheus.totvscloud.com.br:5103/">'
cSoap += WSSoapValue("CRECEB", ::cCRECEB, cCRECEB , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CHQVALCOT>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://conportonovo-tst-protheus.totvscloud.com.br:5103/CHQVALCOT",; 
	"DOCUMENT","http://conportonovo-tst-protheus.totvscloud.com.br:5103/",,"1.031217",; 
	"http://conportonovo-tst-protheus.totvscloud.com.br:5103/ws/CENTRAPR.apw")

::Init()
::oWSCHQVALCOTRESULT:SoapRecv( WSAdvValue( oXmlRet,"_CHQVALCOTRESPONSE:_CHQVALCOTRESULT","STARRAYVALOR",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CHQVALPC of Service WSCENTRAPR

WSMETHOD CHQVALPC WSSEND cCRECEB WSRECEIVE oWSCHQVALPCRESULT WSCLIENT WSCENTRAPR
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CHQVALPC xmlns="http://conportonovo-tst-protheus.totvscloud.com.br:5103/">'
cSoap += WSSoapValue("CRECEB", ::cCRECEB, cCRECEB , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CHQVALPC>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://conportonovo-tst-protheus.totvscloud.com.br:5103/CHQVALPC",; 
	"DOCUMENT","http://conportonovo-tst-protheus.totvscloud.com.br:5103/",,"1.031217",; 
	"http://conportonovo-tst-protheus.totvscloud.com.br:5103/ws/CENTRAPR.apw")

::Init()
::oWSCHQVALPCRESULT:SoapRecv( WSAdvValue( oXmlRet,"_CHQVALPCRESPONSE:_CHQVALPCRESULT","STARRAYVALOR",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method LOGUSR of Service WSCENTRAPR

WSMETHOD LOGUSR WSSEND cCRECEB WSRECEIVE cLOGUSRRESULT WSCLIENT WSCENTRAPR
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<LOGUSR xmlns="http://conportonovo-tst-protheus.totvscloud.com.br:5103/">'
cSoap += WSSoapValue("CRECEB", ::cCRECEB, cCRECEB , "string", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</LOGUSR>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://conportonovo-tst-protheus.totvscloud.com.br:5103/LOGUSR",; 
	"DOCUMENT","http://conportonovo-tst-protheus.totvscloud.com.br:5103/",,"1.031217",; 
	"http://conportonovo-tst-protheus.totvscloud.com.br:5103/ws/CENTRAPR.apw")

::Init()
::cLOGUSRRESULT      :=  WSAdvValue( oXmlRet,"_LOGUSRRESPONSE:_LOGUSRRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure STARRAYPCAP

WSSTRUCT CENTRAPR_STARRAYPCAP
	WSDATA   oWSLISTPCAP               AS CENTRAPR_ARRAYOFPCAP
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_STARRAYPCAP
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_STARRAYPCAP
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_STARRAYPCAP
	Local oClone := CENTRAPR_STARRAYPCAP():NEW()
	oClone:oWSLISTPCAP          := IIF(::oWSLISTPCAP = NIL , NIL , ::oWSLISTPCAP:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT CENTRAPR_STARRAYPCAP
	Local cSoap := ""
	cSoap += WSSoapValue("LISTPCAP", ::oWSLISTPCAP, ::oWSLISTPCAP , "ARRAYOFPCAP", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure COTACAO

WSSTRUCT CENTRAPR_COTACAO
	WSDATA   cCAPROVADOR               AS string
	WSDATA   cCCC                      AS string
	WSDATA   cCCO                      AS string
	WSDATA   cCCOMPRADOR               AS string
	WSDATA   cCDESCCO                  AS string
	WSDATA   cCDTENV                   AS string
	WSDATA   cCDTVAL                   AS string
	WSDATA   cCFIL                     AS string
	WSDATA   cCNUMCOT                  AS string
	WSDATA   cCOBS                     AS string
	WSDATA   cCOBSCOMP                 AS string
	WSDATA   cCSOLIC                   AS string
	WSDATA   cCSTATUS                  AS string
	WSDATA   oWSFORN                   AS CENTRAPR_STARRAYFORNECEDOR
	WSDATA   oWSITENSCOT               AS CENTRAPR_STARRAYITEMCOT
	WSDATA   oWSRANK                   AS CENTRAPR_STARRAYRANKING
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_COTACAO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_COTACAO
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_COTACAO
	Local oClone := CENTRAPR_COTACAO():NEW()
	oClone:cCAPROVADOR          := ::cCAPROVADOR
	oClone:cCCC                 := ::cCCC
	oClone:cCCO                 := ::cCCO
	oClone:cCCOMPRADOR          := ::cCCOMPRADOR
	oClone:cCDESCCO             := ::cCDESCCO
	oClone:cCDTENV              := ::cCDTENV
	oClone:cCDTVAL              := ::cCDTVAL
	oClone:cCFIL                := ::cCFIL
	oClone:cCNUMCOT             := ::cCNUMCOT
	oClone:cCOBS                := ::cCOBS
	oClone:cCOBSCOMP            := ::cCOBSCOMP
	oClone:cCSOLIC              := ::cCSOLIC
	oClone:cCSTATUS             := ::cCSTATUS
	oClone:oWSFORN              := IIF(::oWSFORN = NIL , NIL , ::oWSFORN:Clone() )
	oClone:oWSITENSCOT          := IIF(::oWSITENSCOT = NIL , NIL , ::oWSITENSCOT:Clone() )
	oClone:oWSRANK              := IIF(::oWSRANK = NIL , NIL , ::oWSRANK:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_COTACAO
	Local oNode14
	Local oNode15
	Local oNode16
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCAPROVADOR        :=  WSAdvValue( oResponse,"_CAPROVADOR","string",NIL,"Property cCAPROVADOR as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCCC               :=  WSAdvValue( oResponse,"_CCC","string",NIL,"Property cCCC as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCCO               :=  WSAdvValue( oResponse,"_CCO","string",NIL,"Property cCCO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCCOMPRADOR        :=  WSAdvValue( oResponse,"_CCOMPRADOR","string",NIL,"Property cCCOMPRADOR as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCDESCCO           :=  WSAdvValue( oResponse,"_CDESCCO","string",NIL,"Property cCDESCCO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCDTENV            :=  WSAdvValue( oResponse,"_CDTENV","string",NIL,"Property cCDTENV as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCDTVAL            :=  WSAdvValue( oResponse,"_CDTVAL","string",NIL,"Property cCDTVAL as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCFIL              :=  WSAdvValue( oResponse,"_CFIL","string",NIL,"Property cCFIL as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCNUMCOT           :=  WSAdvValue( oResponse,"_CNUMCOT","string",NIL,"Property cCNUMCOT as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCOBS              :=  WSAdvValue( oResponse,"_COBS","string",NIL,"Property cCOBS as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCOBSCOMP          :=  WSAdvValue( oResponse,"_COBSCOMP","string",NIL,"Property cCOBSCOMP as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCSOLIC            :=  WSAdvValue( oResponse,"_CSOLIC","string",NIL,"Property cCSOLIC as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCSTATUS           :=  WSAdvValue( oResponse,"_CSTATUS","string",NIL,"Property cCSTATUS as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	oNode14 :=  WSAdvValue( oResponse,"_FORN","STARRAYFORNECEDOR",NIL,"Property oWSFORN as s0:STARRAYFORNECEDOR on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode14 != NIL
		::oWSFORN := CENTRAPR_STARRAYFORNECEDOR():New()
		::oWSFORN:SoapRecv(oNode14)
	EndIf
	oNode15 :=  WSAdvValue( oResponse,"_ITENSCOT","STARRAYITEMCOT",NIL,"Property oWSITENSCOT as s0:STARRAYITEMCOT on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode15 != NIL
		::oWSITENSCOT := CENTRAPR_STARRAYITEMCOT():New()
		::oWSITENSCOT:SoapRecv(oNode15)
	EndIf
	oNode16 :=  WSAdvValue( oResponse,"_RANK","STARRAYRANKING",NIL,"Property oWSRANK as s0:STARRAYRANKING on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode16 != NIL
		::oWSRANK := CENTRAPR_STARRAYRANKING():New()
		::oWSRANK:SoapRecv(oNode16)
	EndIf
Return

// WSDL Data Structure STARRAYMAPCOT

WSSTRUCT CENTRAPR_STARRAYMAPCOT
	WSDATA   oWSLISTMAPCOT             AS CENTRAPR_ARRAYOFMAPCOT
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_STARRAYMAPCOT
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_STARRAYMAPCOT
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_STARRAYMAPCOT
	Local oClone := CENTRAPR_STARRAYMAPCOT():NEW()
	oClone:oWSLISTMAPCOT        := IIF(::oWSLISTMAPCOT = NIL , NIL , ::oWSLISTMAPCOT:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_STARRAYMAPCOT
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LISTMAPCOT","ARRAYOFMAPCOT",NIL,"Property oWSLISTMAPCOT as s0:ARRAYOFMAPCOT on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSLISTMAPCOT := CENTRAPR_ARRAYOFMAPCOT():New()
		::oWSLISTMAPCOT:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure STARRAYMAPPC

WSSTRUCT CENTRAPR_STARRAYMAPPC
	WSDATA   oWSLISTMAPPC              AS CENTRAPR_ARRAYOFMAPPC
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_STARRAYMAPPC
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_STARRAYMAPPC
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_STARRAYMAPPC
	Local oClone := CENTRAPR_STARRAYMAPPC():NEW()
	oClone:oWSLISTMAPPC         := IIF(::oWSLISTMAPPC = NIL , NIL , ::oWSLISTMAPPC:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_STARRAYMAPPC
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LISTMAPPC","ARRAYOFMAPPC",NIL,"Property oWSLISTMAPPC as s0:ARRAYOFMAPPC on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSLISTMAPPC := CENTRAPR_ARRAYOFMAPPC():New()
		::oWSLISTMAPPC:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure PEDCOM

WSSTRUCT CENTRAPR_PEDCOM
	WSDATA   oWSAPROVS                 AS CENTRAPR_STARRAYAPROV
	WSDATA   cCCC                      AS string
	WSDATA   cCCO                      AS string
	WSDATA   cCCOMPRADOR               AS string
	WSDATA   cCCONDPAG                 AS string
	WSDATA   cCDESCCC                  AS string
	WSDATA   cCDESCCO                  AS string
	WSDATA   cCDTPREV                  AS string
	WSDATA   cCFIL                     AS string
	WSDATA   cCFORNECEDOR              AS string
	WSDATA   cCNUMCOT                  AS string
	WSDATA   cCNUMPC                   AS string
	WSDATA   cCOBSAPR                  AS string
	WSDATA   cCOBSCOMP                 AS string
	WSDATA   cCSTATUS                  AS string
	WSDATA   oWSITENS                  AS CENTRAPR_STARRAYITEM
	WSDATA   nNTOTAL                   AS float
	WSDATA   nNVALACU                  AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_PEDCOM
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_PEDCOM
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_PEDCOM
	Local oClone := CENTRAPR_PEDCOM():NEW()
	oClone:oWSAPROVS            := IIF(::oWSAPROVS = NIL , NIL , ::oWSAPROVS:Clone() )
	oClone:cCCC                 := ::cCCC
	oClone:cCCO                 := ::cCCO
	oClone:cCCOMPRADOR          := ::cCCOMPRADOR
	oClone:cCCONDPAG            := ::cCCONDPAG
	oClone:cCDESCCC             := ::cCDESCCC
	oClone:cCDESCCO             := ::cCDESCCO
	oClone:cCDTPREV             := ::cCDTPREV
	oClone:cCFIL                := ::cCFIL
	oClone:cCFORNECEDOR         := ::cCFORNECEDOR
	oClone:cCNUMCOT             := ::cCNUMCOT
	oClone:cCNUMPC              := ::cCNUMPC
	oClone:cCOBSAPR             := ::cCOBSAPR
	oClone:cCOBSCOMP            := ::cCOBSCOMP
	oClone:cCSTATUS             := ::cCSTATUS
	oClone:oWSITENS             := IIF(::oWSITENS = NIL , NIL , ::oWSITENS:Clone() )
	oClone:nNTOTAL              := ::nNTOTAL
	oClone:nNVALACU             := ::nNVALACU
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_PEDCOM
	Local oNode1
	Local oNode16
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_APROVS","STARRAYAPROV",NIL,"Property oWSAPROVS as s0:STARRAYAPROV on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSAPROVS := CENTRAPR_STARRAYAPROV():New()
		::oWSAPROVS:SoapRecv(oNode1)
	EndIf
	::cCCC               :=  WSAdvValue( oResponse,"_CCC","string",NIL,"Property cCCC as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCCO               :=  WSAdvValue( oResponse,"_CCO","string",NIL,"Property cCCO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCCOMPRADOR        :=  WSAdvValue( oResponse,"_CCOMPRADOR","string",NIL,"Property cCCOMPRADOR as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCCONDPAG          :=  WSAdvValue( oResponse,"_CCONDPAG","string",NIL,"Property cCCONDPAG as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCDESCCC           :=  WSAdvValue( oResponse,"_CDESCCC","string",NIL,"Property cCDESCCC as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCDESCCO           :=  WSAdvValue( oResponse,"_CDESCCO","string",NIL,"Property cCDESCCO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCDTPREV           :=  WSAdvValue( oResponse,"_CDTPREV","string",NIL,"Property cCDTPREV as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCFIL              :=  WSAdvValue( oResponse,"_CFIL","string",NIL,"Property cCFIL as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCFORNECEDOR       :=  WSAdvValue( oResponse,"_CFORNECEDOR","string",NIL,"Property cCFORNECEDOR as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCNUMCOT           :=  WSAdvValue( oResponse,"_CNUMCOT","string",NIL,"Property cCNUMCOT as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCNUMPC            :=  WSAdvValue( oResponse,"_CNUMPC","string",NIL,"Property cCNUMPC as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCOBSAPR           :=  WSAdvValue( oResponse,"_COBSAPR","string",NIL,"Property cCOBSAPR as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCOBSCOMP          :=  WSAdvValue( oResponse,"_COBSCOMP","string",NIL,"Property cCOBSCOMP as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCSTATUS           :=  WSAdvValue( oResponse,"_CSTATUS","string",NIL,"Property cCSTATUS as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	oNode16 :=  WSAdvValue( oResponse,"_ITENS","STARRAYITEM",NIL,"Property oWSITENS as s0:STARRAYITEM on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode16 != NIL
		::oWSITENS := CENTRAPR_STARRAYITEM():New()
		::oWSITENS:SoapRecv(oNode16)
	EndIf
	::nNTOTAL            :=  WSAdvValue( oResponse,"_NTOTAL","float",NIL,"Property nNTOTAL as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNVALACU           :=  WSAdvValue( oResponse,"_NVALACU","float",NIL,"Property nNVALACU as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure STARRAYVALOR

WSSTRUCT CENTRAPR_STARRAYVALOR
	WSDATA   oWSLISTVL                 AS CENTRAPR_ARRAYOFMAPVL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_STARRAYVALOR
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_STARRAYVALOR
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_STARRAYVALOR
	Local oClone := CENTRAPR_STARRAYVALOR():NEW()
	oClone:oWSLISTVL            := IIF(::oWSLISTVL = NIL , NIL , ::oWSLISTVL:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_STARRAYVALOR
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LISTVL","ARRAYOFMAPVL",NIL,"Property oWSLISTVL as s0:ARRAYOFMAPVL on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSLISTVL := CENTRAPR_ARRAYOFMAPVL():New()
		::oWSLISTVL:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure ARRAYOFPCAP

WSSTRUCT CENTRAPR_ARRAYOFPCAP
	WSDATA   oWSPCAP                   AS CENTRAPR_PCAP OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_ARRAYOFPCAP
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_ARRAYOFPCAP
	::oWSPCAP              := {} // Array Of  CENTRAPR_PCAP():New()
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_ARRAYOFPCAP
	Local oClone := CENTRAPR_ARRAYOFPCAP():NEW()
	oClone:oWSPCAP := NIL
	If ::oWSPCAP <> NIL 
		oClone:oWSPCAP := {}
		aEval( ::oWSPCAP , { |x| aadd( oClone:oWSPCAP , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT CENTRAPR_ARRAYOFPCAP
	Local cSoap := ""
	aEval( ::oWSPCAP , {|x| cSoap := cSoap  +  WSSoapValue("PCAP", x , x , "PCAP", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure STARRAYFORNECEDOR

WSSTRUCT CENTRAPR_STARRAYFORNECEDOR
	WSDATA   oWSLISTFORN               AS CENTRAPR_ARRAYOFFORNECEDOR
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_STARRAYFORNECEDOR
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_STARRAYFORNECEDOR
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_STARRAYFORNECEDOR
	Local oClone := CENTRAPR_STARRAYFORNECEDOR():NEW()
	oClone:oWSLISTFORN          := IIF(::oWSLISTFORN = NIL , NIL , ::oWSLISTFORN:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_STARRAYFORNECEDOR
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LISTFORN","ARRAYOFFORNECEDOR",NIL,"Property oWSLISTFORN as s0:ARRAYOFFORNECEDOR on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSLISTFORN := CENTRAPR_ARRAYOFFORNECEDOR():New()
		::oWSLISTFORN:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure STARRAYITEMCOT

WSSTRUCT CENTRAPR_STARRAYITEMCOT
	WSDATA   oWSLISTITEMCOT            AS CENTRAPR_ARRAYOFITEMCOT
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_STARRAYITEMCOT
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_STARRAYITEMCOT
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_STARRAYITEMCOT
	Local oClone := CENTRAPR_STARRAYITEMCOT():NEW()
	oClone:oWSLISTITEMCOT       := IIF(::oWSLISTITEMCOT = NIL , NIL , ::oWSLISTITEMCOT:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_STARRAYITEMCOT
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LISTITEMCOT","ARRAYOFITEMCOT",NIL,"Property oWSLISTITEMCOT as s0:ARRAYOFITEMCOT on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSLISTITEMCOT := CENTRAPR_ARRAYOFITEMCOT():New()
		::oWSLISTITEMCOT:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure STARRAYRANKING

WSSTRUCT CENTRAPR_STARRAYRANKING
	WSDATA   oWSLISTRANKING            AS CENTRAPR_ARRAYOFRANKING
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_STARRAYRANKING
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_STARRAYRANKING
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_STARRAYRANKING
	Local oClone := CENTRAPR_STARRAYRANKING():NEW()
	oClone:oWSLISTRANKING       := IIF(::oWSLISTRANKING = NIL , NIL , ::oWSLISTRANKING:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_STARRAYRANKING
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LISTRANKING","ARRAYOFRANKING",NIL,"Property oWSLISTRANKING as s0:ARRAYOFRANKING on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSLISTRANKING := CENTRAPR_ARRAYOFRANKING():New()
		::oWSLISTRANKING:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure ARRAYOFMAPCOT

WSSTRUCT CENTRAPR_ARRAYOFMAPCOT
	WSDATA   oWSMAPCOT                 AS CENTRAPR_MAPCOT OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_ARRAYOFMAPCOT
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_ARRAYOFMAPCOT
	::oWSMAPCOT            := {} // Array Of  CENTRAPR_MAPCOT():New()
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_ARRAYOFMAPCOT
	Local oClone := CENTRAPR_ARRAYOFMAPCOT():NEW()
	oClone:oWSMAPCOT := NIL
	If ::oWSMAPCOT <> NIL 
		oClone:oWSMAPCOT := {}
		aEval( ::oWSMAPCOT , { |x| aadd( oClone:oWSMAPCOT , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_ARRAYOFMAPCOT
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_MAPCOT","MAPCOT",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSMAPCOT , CENTRAPR_MAPCOT():New() )
			::oWSMAPCOT[len(::oWSMAPCOT)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ARRAYOFMAPPC

WSSTRUCT CENTRAPR_ARRAYOFMAPPC
	WSDATA   oWSMAPPC                  AS CENTRAPR_MAPPC OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_ARRAYOFMAPPC
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_ARRAYOFMAPPC
	::oWSMAPPC             := {} // Array Of  CENTRAPR_MAPPC():New()
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_ARRAYOFMAPPC
	Local oClone := CENTRAPR_ARRAYOFMAPPC():NEW()
	oClone:oWSMAPPC := NIL
	If ::oWSMAPPC <> NIL 
		oClone:oWSMAPPC := {}
		aEval( ::oWSMAPPC , { |x| aadd( oClone:oWSMAPPC , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_ARRAYOFMAPPC
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_MAPPC","MAPPC",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSMAPPC , CENTRAPR_MAPPC():New() )
			::oWSMAPPC[len(::oWSMAPPC)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure STARRAYAPROV

WSSTRUCT CENTRAPR_STARRAYAPROV
	WSDATA   oWSLISTAPROV              AS CENTRAPR_ARRAYOFAPROV
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_STARRAYAPROV
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_STARRAYAPROV
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_STARRAYAPROV
	Local oClone := CENTRAPR_STARRAYAPROV():NEW()
	oClone:oWSLISTAPROV         := IIF(::oWSLISTAPROV = NIL , NIL , ::oWSLISTAPROV:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_STARRAYAPROV
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LISTAPROV","ARRAYOFAPROV",NIL,"Property oWSLISTAPROV as s0:ARRAYOFAPROV on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSLISTAPROV := CENTRAPR_ARRAYOFAPROV():New()
		::oWSLISTAPROV:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure STARRAYITEM

WSSTRUCT CENTRAPR_STARRAYITEM
	WSDATA   oWSLISTITEMPC             AS CENTRAPR_ARRAYOFITEMPC
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_STARRAYITEM
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_STARRAYITEM
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_STARRAYITEM
	Local oClone := CENTRAPR_STARRAYITEM():NEW()
	oClone:oWSLISTITEMPC        := IIF(::oWSLISTITEMPC = NIL , NIL , ::oWSLISTITEMPC:Clone() )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_STARRAYITEM
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_LISTITEMPC","ARRAYOFITEMPC",NIL,"Property oWSLISTITEMPC as s0:ARRAYOFITEMPC on SOAP Response not found.",NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSLISTITEMPC := CENTRAPR_ARRAYOFITEMPC():New()
		::oWSLISTITEMPC:SoapRecv(oNode1)
	EndIf
Return

// WSDL Data Structure ARRAYOFMAPVL

WSSTRUCT CENTRAPR_ARRAYOFMAPVL
	WSDATA   oWSMAPVL                  AS CENTRAPR_MAPVL OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_ARRAYOFMAPVL
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_ARRAYOFMAPVL
	::oWSMAPVL             := {} // Array Of  CENTRAPR_MAPVL():New()
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_ARRAYOFMAPVL
	Local oClone := CENTRAPR_ARRAYOFMAPVL():NEW()
	oClone:oWSMAPVL := NIL
	If ::oWSMAPVL <> NIL 
		oClone:oWSMAPVL := {}
		aEval( ::oWSMAPVL , { |x| aadd( oClone:oWSMAPVL , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_ARRAYOFMAPVL
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_MAPVL","MAPVL",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSMAPVL , CENTRAPR_MAPVL():New() )
			::oWSMAPVL[len(::oWSMAPVL)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure PCAP

WSSTRUCT CENTRAPR_PCAP
	WSDATA   cCFIL                     AS string
	WSDATA   cCNUMPC                   AS string
	WSDATA   cCOBS                     AS string
	WSDATA   cCSTATUS                  AS string
	WSDATA   cCUSER                    AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_PCAP
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_PCAP
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_PCAP
	Local oClone := CENTRAPR_PCAP():NEW()
	oClone:cCFIL                := ::cCFIL
	oClone:cCNUMPC              := ::cCNUMPC
	oClone:cCOBS                := ::cCOBS
	oClone:cCSTATUS             := ::cCSTATUS
	oClone:cCUSER               := ::cCUSER
Return oClone

WSMETHOD SOAPSEND WSCLIENT CENTRAPR_PCAP
	Local cSoap := ""
	cSoap += WSSoapValue("CFIL", ::cCFIL, ::cCFIL , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CNUMPC", ::cCNUMPC, ::cCNUMPC , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("COBS", ::cCOBS, ::cCOBS , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CSTATUS", ::cCSTATUS, ::cCSTATUS , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("CUSER", ::cCUSER, ::cCUSER , "string", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ARRAYOFFORNECEDOR

WSSTRUCT CENTRAPR_ARRAYOFFORNECEDOR
	WSDATA   oWSFORNECEDOR             AS CENTRAPR_FORNECEDOR OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_ARRAYOFFORNECEDOR
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_ARRAYOFFORNECEDOR
	::oWSFORNECEDOR        := {} // Array Of  CENTRAPR_FORNECEDOR():New()
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_ARRAYOFFORNECEDOR
	Local oClone := CENTRAPR_ARRAYOFFORNECEDOR():NEW()
	oClone:oWSFORNECEDOR := NIL
	If ::oWSFORNECEDOR <> NIL 
		oClone:oWSFORNECEDOR := {}
		aEval( ::oWSFORNECEDOR , { |x| aadd( oClone:oWSFORNECEDOR , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_ARRAYOFFORNECEDOR
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_FORNECEDOR","FORNECEDOR",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSFORNECEDOR , CENTRAPR_FORNECEDOR():New() )
			::oWSFORNECEDOR[len(::oWSFORNECEDOR)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ARRAYOFITEMCOT

WSSTRUCT CENTRAPR_ARRAYOFITEMCOT
	WSDATA   oWSITEMCOT                AS CENTRAPR_ITEMCOT OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_ARRAYOFITEMCOT
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_ARRAYOFITEMCOT
	::oWSITEMCOT           := {} // Array Of  CENTRAPR_ITEMCOT():New()
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_ARRAYOFITEMCOT
	Local oClone := CENTRAPR_ARRAYOFITEMCOT():NEW()
	oClone:oWSITEMCOT := NIL
	If ::oWSITEMCOT <> NIL 
		oClone:oWSITEMCOT := {}
		aEval( ::oWSITEMCOT , { |x| aadd( oClone:oWSITEMCOT , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_ARRAYOFITEMCOT
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ITEMCOT","ITEMCOT",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSITEMCOT , CENTRAPR_ITEMCOT():New() )
			::oWSITEMCOT[len(::oWSITEMCOT)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ARRAYOFRANKING

WSSTRUCT CENTRAPR_ARRAYOFRANKING
	WSDATA   oWSRANKING                AS CENTRAPR_RANKING OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_ARRAYOFRANKING
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_ARRAYOFRANKING
	::oWSRANKING           := {} // Array Of  CENTRAPR_RANKING():New()
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_ARRAYOFRANKING
	Local oClone := CENTRAPR_ARRAYOFRANKING():NEW()
	oClone:oWSRANKING := NIL
	If ::oWSRANKING <> NIL 
		oClone:oWSRANKING := {}
		aEval( ::oWSRANKING , { |x| aadd( oClone:oWSRANKING , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_ARRAYOFRANKING
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_RANKING","RANKING",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSRANKING , CENTRAPR_RANKING():New() )
			::oWSRANKING[len(::oWSRANKING)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure MAPCOT

WSSTRUCT CENTRAPR_MAPCOT
	WSDATA   cCCC                      AS string
	WSDATA   cCCO                      AS string
	WSDATA   cCCOMPRADOR               AS string
	WSDATA   cCDESCCO                  AS string
	WSDATA   cCDTENV                   AS string
	WSDATA   cCDTVAL                   AS string
	WSDATA   cCFIL                     AS string
	WSDATA   cCNUMCOT                  AS string
	WSDATA   cCRANKING                 AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_MAPCOT
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_MAPCOT
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_MAPCOT
	Local oClone := CENTRAPR_MAPCOT():NEW()
	oClone:cCCC                 := ::cCCC
	oClone:cCCO                 := ::cCCO
	oClone:cCCOMPRADOR          := ::cCCOMPRADOR
	oClone:cCDESCCO             := ::cCDESCCO
	oClone:cCDTENV              := ::cCDTENV
	oClone:cCDTVAL              := ::cCDTVAL
	oClone:cCFIL                := ::cCFIL
	oClone:cCNUMCOT             := ::cCNUMCOT
	oClone:cCRANKING            := ::cCRANKING
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_MAPCOT
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCCC               :=  WSAdvValue( oResponse,"_CCC","string",NIL,"Property cCCC as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCCO               :=  WSAdvValue( oResponse,"_CCO","string",NIL,"Property cCCO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCCOMPRADOR        :=  WSAdvValue( oResponse,"_CCOMPRADOR","string",NIL,"Property cCCOMPRADOR as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCDESCCO           :=  WSAdvValue( oResponse,"_CDESCCO","string",NIL,"Property cCDESCCO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCDTENV            :=  WSAdvValue( oResponse,"_CDTENV","string",NIL,"Property cCDTENV as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCDTVAL            :=  WSAdvValue( oResponse,"_CDTVAL","string",NIL,"Property cCDTVAL as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCFIL              :=  WSAdvValue( oResponse,"_CFIL","string",NIL,"Property cCFIL as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCNUMCOT           :=  WSAdvValue( oResponse,"_CNUMCOT","string",NIL,"Property cCNUMCOT as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCRANKING          :=  WSAdvValue( oResponse,"_CRANKING","string",NIL,"Property cCRANKING as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure MAPPC

WSSTRUCT CENTRAPR_MAPPC
	WSDATA   cCCC                      AS string
	WSDATA   cCCO                      AS string
	WSDATA   cCCOMPRADOR               AS string
	WSDATA   cCCOTACAO                 AS string
	WSDATA   cCDESCCO                  AS string
	WSDATA   cCDTENT                   AS string
	WSDATA   cCFIL                     AS string
	WSDATA   cCFORNECEDOR              AS string
	WSDATA   cCNUMPC                   AS string
	WSDATA   cCOBS                     AS string
	WSDATA   cCSTATUS                  AS string
	WSDATA   nNTOTAL                   AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_MAPPC
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_MAPPC
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_MAPPC
	Local oClone := CENTRAPR_MAPPC():NEW()
	oClone:cCCC                 := ::cCCC
	oClone:cCCO                 := ::cCCO
	oClone:cCCOMPRADOR          := ::cCCOMPRADOR
	oClone:cCCOTACAO            := ::cCCOTACAO
	oClone:cCDESCCO             := ::cCDESCCO
	oClone:cCDTENT              := ::cCDTENT
	oClone:cCFIL                := ::cCFIL
	oClone:cCFORNECEDOR         := ::cCFORNECEDOR
	oClone:cCNUMPC              := ::cCNUMPC
	oClone:cCOBS                := ::cCOBS
	oClone:cCSTATUS             := ::cCSTATUS
	oClone:nNTOTAL              := ::nNTOTAL
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_MAPPC
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCCC               :=  WSAdvValue( oResponse,"_CCC","string",NIL,"Property cCCC as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCCO               :=  WSAdvValue( oResponse,"_CCO","string",NIL,"Property cCCO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCCOMPRADOR        :=  WSAdvValue( oResponse,"_CCOMPRADOR","string",NIL,"Property cCCOMPRADOR as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCCOTACAO          :=  WSAdvValue( oResponse,"_CCOTACAO","string",NIL,"Property cCCOTACAO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCDESCCO           :=  WSAdvValue( oResponse,"_CDESCCO","string",NIL,"Property cCDESCCO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCDTENT            :=  WSAdvValue( oResponse,"_CDTENT","string",NIL,"Property cCDTENT as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCFIL              :=  WSAdvValue( oResponse,"_CFIL","string",NIL,"Property cCFIL as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCFORNECEDOR       :=  WSAdvValue( oResponse,"_CFORNECEDOR","string",NIL,"Property cCFORNECEDOR as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCNUMPC            :=  WSAdvValue( oResponse,"_CNUMPC","string",NIL,"Property cCNUMPC as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCOBS              :=  WSAdvValue( oResponse,"_COBS","string",NIL,"Property cCOBS as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCSTATUS           :=  WSAdvValue( oResponse,"_CSTATUS","string",NIL,"Property cCSTATUS as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nNTOTAL            :=  WSAdvValue( oResponse,"_NTOTAL","float",NIL,"Property nNTOTAL as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ARRAYOFAPROV

WSSTRUCT CENTRAPR_ARRAYOFAPROV
	WSDATA   oWSAPROV                  AS CENTRAPR_APROV OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_ARRAYOFAPROV
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_ARRAYOFAPROV
	::oWSAPROV             := {} // Array Of  CENTRAPR_APROV():New()
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_ARRAYOFAPROV
	Local oClone := CENTRAPR_ARRAYOFAPROV():NEW()
	oClone:oWSAPROV := NIL
	If ::oWSAPROV <> NIL 
		oClone:oWSAPROV := {}
		aEval( ::oWSAPROV , { |x| aadd( oClone:oWSAPROV , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_ARRAYOFAPROV
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_APROV","APROV",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSAPROV , CENTRAPR_APROV():New() )
			::oWSAPROV[len(::oWSAPROV)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure ARRAYOFITEMPC

WSSTRUCT CENTRAPR_ARRAYOFITEMPC
	WSDATA   oWSITEMPC                 AS CENTRAPR_ITEMPC OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_ARRAYOFITEMPC
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_ARRAYOFITEMPC
	::oWSITEMPC            := {} // Array Of  CENTRAPR_ITEMPC():New()
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_ARRAYOFITEMPC
	Local oClone := CENTRAPR_ARRAYOFITEMPC():NEW()
	oClone:oWSITEMPC := NIL
	If ::oWSITEMPC <> NIL 
		oClone:oWSITEMPC := {}
		aEval( ::oWSITEMPC , { |x| aadd( oClone:oWSITEMPC , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_ARRAYOFITEMPC
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ITEMPC","ITEMPC",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSITEMPC , CENTRAPR_ITEMPC():New() )
			::oWSITEMPC[len(::oWSITEMPC)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure MAPVL

WSSTRUCT CENTRAPR_MAPVL
	WSDATA   cCFIL                     AS string
	WSDATA   nNTOTAL                   AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_MAPVL
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_MAPVL
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_MAPVL
	Local oClone := CENTRAPR_MAPVL():NEW()
	oClone:cCFIL                := ::cCFIL
	oClone:nNTOTAL              := ::nNTOTAL
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_MAPVL
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCFIL              :=  WSAdvValue( oResponse,"_CFIL","string",NIL,"Property cCFIL as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nNTOTAL            :=  WSAdvValue( oResponse,"_NTOTAL","float",NIL,"Property nNTOTAL as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure FORNECEDOR

WSSTRUCT CENTRAPR_FORNECEDOR
	WSDATA   cCCODIGO                  AS string
	WSDATA   cCCONDPAG                 AS string
	WSDATA   cCCONTATO                 AS string
	WSDATA   cCNOTA                    AS string
	WSDATA   cCPRAZO                   AS string
	WSDATA   cCRANKING                 AS string
	WSDATA   cCUF                      AS string
	WSDATA   nNFRETE                   AS float
	WSDATA   nNICMS                    AS float
	WSDATA   nNIPI                     AS float
	WSDATA   nNTOTAL                   AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_FORNECEDOR
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_FORNECEDOR
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_FORNECEDOR
	Local oClone := CENTRAPR_FORNECEDOR():NEW()
	oClone:cCCODIGO             := ::cCCODIGO
	oClone:cCCONDPAG            := ::cCCONDPAG
	oClone:cCCONTATO            := ::cCCONTATO
	oClone:cCNOTA               := ::cCNOTA
	oClone:cCPRAZO              := ::cCPRAZO
	oClone:cCRANKING            := ::cCRANKING
	oClone:cCUF                 := ::cCUF
	oClone:nNFRETE              := ::nNFRETE
	oClone:nNICMS               := ::nNICMS
	oClone:nNIPI                := ::nNIPI
	oClone:nNTOTAL              := ::nNTOTAL
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_FORNECEDOR
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCCODIGO           :=  WSAdvValue( oResponse,"_CCODIGO","string",NIL,"Property cCCODIGO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCCONDPAG          :=  WSAdvValue( oResponse,"_CCONDPAG","string",NIL,"Property cCCONDPAG as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCCONTATO          :=  WSAdvValue( oResponse,"_CCONTATO","string",NIL,"Property cCCONTATO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCNOTA             :=  WSAdvValue( oResponse,"_CNOTA","string",NIL,"Property cCNOTA as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCPRAZO            :=  WSAdvValue( oResponse,"_CPRAZO","string",NIL,"Property cCPRAZO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCRANKING          :=  WSAdvValue( oResponse,"_CRANKING","string",NIL,"Property cCRANKING as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCUF               :=  WSAdvValue( oResponse,"_CUF","string",NIL,"Property cCUF as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nNFRETE            :=  WSAdvValue( oResponse,"_NFRETE","float",NIL,"Property nNFRETE as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNICMS             :=  WSAdvValue( oResponse,"_NICMS","float",NIL,"Property nNICMS as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNIPI              :=  WSAdvValue( oResponse,"_NIPI","float",NIL,"Property nNIPI as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNTOTAL            :=  WSAdvValue( oResponse,"_NTOTAL","float",NIL,"Property nNTOTAL as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ITEMCOT

WSSTRUCT CENTRAPR_ITEMCOT
	WSDATA   cCDESC                    AS string
	WSDATA   cCFORN1                   AS string
	WSDATA   cCFORN2                   AS string
	WSDATA   cCFORN3                   AS string
	WSDATA   cCFORN4                   AS string
	WSDATA   cCFORN5                   AS string
	WSDATA   cCITEM                    AS string
	WSDATA   cCUM                      AS string
	WSDATA   nNPRCUN1                  AS float
	WSDATA   nNPRCUN2                  AS float
	WSDATA   nNPRCUN3                  AS float
	WSDATA   nNPRCUN4                  AS float
	WSDATA   nNPRCUN5                  AS float
	WSDATA   nNQTD                     AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_ITEMCOT
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_ITEMCOT
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_ITEMCOT
	Local oClone := CENTRAPR_ITEMCOT():NEW()
	oClone:cCDESC               := ::cCDESC
	oClone:cCFORN1              := ::cCFORN1
	oClone:cCFORN2              := ::cCFORN2
	oClone:cCFORN3              := ::cCFORN3
	oClone:cCFORN4              := ::cCFORN4
	oClone:cCFORN5              := ::cCFORN5
	oClone:cCITEM               := ::cCITEM
	oClone:cCUM                 := ::cCUM
	oClone:nNPRCUN1             := ::nNPRCUN1
	oClone:nNPRCUN2             := ::nNPRCUN2
	oClone:nNPRCUN3             := ::nNPRCUN3
	oClone:nNPRCUN4             := ::nNPRCUN4
	oClone:nNPRCUN5             := ::nNPRCUN5
	oClone:nNQTD                := ::nNQTD
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_ITEMCOT
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCDESC             :=  WSAdvValue( oResponse,"_CDESC","string",NIL,"Property cCDESC as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCFORN1            :=  WSAdvValue( oResponse,"_CFORN1","string",NIL,"Property cCFORN1 as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCFORN2            :=  WSAdvValue( oResponse,"_CFORN2","string",NIL,"Property cCFORN2 as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCFORN3            :=  WSAdvValue( oResponse,"_CFORN3","string",NIL,"Property cCFORN3 as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCFORN4            :=  WSAdvValue( oResponse,"_CFORN4","string",NIL,"Property cCFORN4 as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCFORN5            :=  WSAdvValue( oResponse,"_CFORN5","string",NIL,"Property cCFORN5 as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCITEM             :=  WSAdvValue( oResponse,"_CITEM","string",NIL,"Property cCITEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCUM               :=  WSAdvValue( oResponse,"_CUM","string",NIL,"Property cCUM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nNPRCUN1           :=  WSAdvValue( oResponse,"_NPRCUN1","float",NIL,"Property nNPRCUN1 as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNPRCUN2           :=  WSAdvValue( oResponse,"_NPRCUN2","float",NIL,"Property nNPRCUN2 as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNPRCUN3           :=  WSAdvValue( oResponse,"_NPRCUN3","float",NIL,"Property nNPRCUN3 as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNPRCUN4           :=  WSAdvValue( oResponse,"_NPRCUN4","float",NIL,"Property nNPRCUN4 as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNPRCUN5           :=  WSAdvValue( oResponse,"_NPRCUN5","float",NIL,"Property nNPRCUN5 as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNQTD              :=  WSAdvValue( oResponse,"_NQTD","float",NIL,"Property nNQTD as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure RANKING

WSSTRUCT CENTRAPR_RANKING
	WSDATA   cCAPROVADOR               AS string
	WSDATA   cCOBS                     AS string
	WSDATA   cCPRIMEIRO                AS string
	WSDATA   cCQUARTO                  AS string
	WSDATA   cCQUINTO                  AS string
	WSDATA   cCSEGUNDO                 AS string
	WSDATA   cCTERCEIRO                AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_RANKING
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_RANKING
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_RANKING
	Local oClone := CENTRAPR_RANKING():NEW()
	oClone:cCAPROVADOR          := ::cCAPROVADOR
	oClone:cCOBS                := ::cCOBS
	oClone:cCPRIMEIRO           := ::cCPRIMEIRO
	oClone:cCQUARTO             := ::cCQUARTO
	oClone:cCQUINTO             := ::cCQUINTO
	oClone:cCSEGUNDO            := ::cCSEGUNDO
	oClone:cCTERCEIRO           := ::cCTERCEIRO
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_RANKING
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCAPROVADOR        :=  WSAdvValue( oResponse,"_CAPROVADOR","string",NIL,"Property cCAPROVADOR as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCOBS              :=  WSAdvValue( oResponse,"_COBS","string",NIL,"Property cCOBS as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCPRIMEIRO         :=  WSAdvValue( oResponse,"_CPRIMEIRO","string",NIL,"Property cCPRIMEIRO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCQUARTO           :=  WSAdvValue( oResponse,"_CQUARTO","string",NIL,"Property cCQUARTO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCQUINTO           :=  WSAdvValue( oResponse,"_CQUINTO","string",NIL,"Property cCQUINTO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCSEGUNDO          :=  WSAdvValue( oResponse,"_CSEGUNDO","string",NIL,"Property cCSEGUNDO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCTERCEIRO         :=  WSAdvValue( oResponse,"_CTERCEIRO","string",NIL,"Property cCTERCEIRO as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure APROV

WSSTRUCT CENTRAPR_APROV
	WSDATA   cCAPROVADOR               AS string
	WSDATA   cCDTLIB                   AS string
	WSDATA   cCNOME                    AS string
	WSDATA   cCOBSLIB                  AS string
	WSDATA   cCSTATUS                  AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_APROV
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_APROV
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_APROV
	Local oClone := CENTRAPR_APROV():NEW()
	oClone:cCAPROVADOR          := ::cCAPROVADOR
	oClone:cCDTLIB              := ::cCDTLIB
	oClone:cCNOME               := ::cCNOME
	oClone:cCOBSLIB             := ::cCOBSLIB
	oClone:cCSTATUS             := ::cCSTATUS
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_APROV
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCAPROVADOR        :=  WSAdvValue( oResponse,"_CAPROVADOR","string",NIL,"Property cCAPROVADOR as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCDTLIB            :=  WSAdvValue( oResponse,"_CDTLIB","string",NIL,"Property cCDTLIB as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCNOME             :=  WSAdvValue( oResponse,"_CNOME","string",NIL,"Property cCNOME as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCOBSLIB           :=  WSAdvValue( oResponse,"_COBSLIB","string",NIL,"Property cCOBSLIB as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCSTATUS           :=  WSAdvValue( oResponse,"_CSTATUS","string",NIL,"Property cCSTATUS as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return

// WSDL Data Structure ITEMPC

WSSTRUCT CENTRAPR_ITEMPC
	WSDATA   cCCODPROD                 AS string
	WSDATA   cCDESC                    AS string
	WSDATA   cCDTULCOM                 AS string
	WSDATA   cCITEM                    AS string
	WSDATA   cCUM                      AS string
	WSDATA   nNDESC                    AS float
	WSDATA   nNPRCUN                   AS float
	WSDATA   nNQTD                     AS float
	WSDATA   nNTOTAL                   AS float
	WSDATA   nNTULTCOM                 AS float
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CENTRAPR_ITEMPC
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CENTRAPR_ITEMPC
Return

WSMETHOD CLONE WSCLIENT CENTRAPR_ITEMPC
	Local oClone := CENTRAPR_ITEMPC():NEW()
	oClone:cCCODPROD            := ::cCCODPROD
	oClone:cCDESC               := ::cCDESC
	oClone:cCDTULCOM            := ::cCDTULCOM
	oClone:cCITEM               := ::cCITEM
	oClone:cCUM                 := ::cCUM
	oClone:nNDESC               := ::nNDESC
	oClone:nNPRCUN              := ::nNPRCUN
	oClone:nNQTD                := ::nNQTD
	oClone:nNTOTAL              := ::nNTOTAL
	oClone:nNTULTCOM            := ::nNTULTCOM
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT CENTRAPR_ITEMPC
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCCODPROD          :=  WSAdvValue( oResponse,"_CCODPROD","string",NIL,"Property cCCODPROD as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCDESC             :=  WSAdvValue( oResponse,"_CDESC","string",NIL,"Property cCDESC as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCDTULCOM          :=  WSAdvValue( oResponse,"_CDTULCOM","string",NIL,"Property cCDTULCOM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCITEM             :=  WSAdvValue( oResponse,"_CITEM","string",NIL,"Property cCITEM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cCUM               :=  WSAdvValue( oResponse,"_CUM","string",NIL,"Property cCUM as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::nNDESC             :=  WSAdvValue( oResponse,"_NDESC","float",NIL,"Property nNDESC as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNPRCUN            :=  WSAdvValue( oResponse,"_NPRCUN","float",NIL,"Property nNPRCUN as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNQTD              :=  WSAdvValue( oResponse,"_NQTD","float",NIL,"Property nNQTD as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNTOTAL            :=  WSAdvValue( oResponse,"_NTOTAL","float",NIL,"Property nNTOTAL as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
	::nNTULTCOM          :=  WSAdvValue( oResponse,"_NTULTCOM","float",NIL,"Property nNTULTCOM as s:float on SOAP Response not found.",NIL,"N",NIL,NIL) 
Return


