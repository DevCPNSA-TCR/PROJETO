#INCLUDE "protheus.ch"
#INCLUDE "apwebsrv.ch"

/* ===============================================================================
WSDL Location    https://cherwell.tcrtelecom.net:8043/WSTotvs/Cherwellintegration.asmx?wsdl
Gerado em        20/06/22 16:18:51
Observa��es      C�digo-Fonte gerado por ADVPL WSDL Client 1.120703
                 Altera��es neste arquivo podem causar funcionamento incorreto
                 e ser�o perdidas caso o c�digo-fonte seja gerado novamente.
=============================================================================== */ 

User Function _UHJWPOR ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSCherwellIntegration
------------------------------------------------------------------------------- */

WSCLIENT WSCherwellIntegration

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD associateTablelaContrato
	WSMETHOD UpdateVencimentoERP
	WSMETHOD UpdateClientesERP
	WSMETHOD CreateClientInvoice
	WSMETHOD processFaturamento
	WSMETHOD setDesignation
	WSMETHOD generateAllFatsForService
	WSMETHOD validAllFats
	WSMETHOD emiteAllFats
	WSMETHOD validateStatusForAllFats
	WSMETHOD CancelDeLin
	WSMETHOD CancelItemFaturamento
	WSMETHOD emiteDelin
	WSMETHOD AcceptDelin
	WSMETHOD createAF
	WSMETHOD integraERP
	WSMETHOD UpdatePGMT
	WSMETHOD UpdateCancelPGMT
	WSMETHOD createFatCancel
	WSMETHOD addPrazoFaturamento
	WSMETHOD addPrazoFaturamentoContrato
	WSMETHOD applyReajusteContratro

	WSDATA   _URL                      AS String
	WSDATA   _CERT                     AS String
	WSDATA   _PRIVKEY                  AS String
	WSDATA   _PASSPHRASE               AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cstrRecID                 AS string
	WSDATA   cCDDelin                  AS string
	WSDATA   cCDPedido                 AS string
	WSDATA   cDTVencimento             AS string
	WSDATA   cstrCDCliente             AS string
	WSDATA   cstrCDServico             AS string
	WSDATA   cstrDataIni               AS string
	WSDATA   cstrDataFim               AS string
	WSDATA   cstrClienteRazao          AS string
	WSDATA   cprocessFaturamentoResult AS string
	WSDATA   cstrEnderecoA             AS string
	WSDATA   cstrEnderecoB             AS string
	WSDATA   csetDesignationResult     AS string
	WSDATA   cstrType                  AS string
	WSDATA   cCD_PEDIDO                AS string
	WSDATA   cVL_PAGAMENTO             AS string
	WSDATA   cDT_PAGAMENTO             AS string
	WSDATA   cDT_RECEBIMENTO           AS string
	WSDATA   cNR_N_FISCAL              AS string
	WSDATA   cNR_N_SERIE               AS string
	WSDATA   cUpdatePGMTResult         AS string
	WSDATA   cUpdateCancelPGMTResult   AS string
	WSDATA   cRecID                    AS string
	WSDATA   ccreateFatCancelResult    AS string
	WSDATA   cstrDataFinal             AS string
	WSDATA   naddPrazoFaturamentoResult AS int

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCherwellIntegration
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O C�digo-Fonte Client atual requer os execut�veis do Protheus Build [7.00.210324P-20220312] ou superior. Atualize o Protheus ou gere o C�digo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCherwellIntegration
Return

WSMETHOD RESET WSCLIENT WSCherwellIntegration
	::cstrRecID          := NIL 
	::cCDDelin           := NIL 
	::cCDPedido          := NIL 
	::cDTVencimento      := NIL 
	::cstrCDCliente      := NIL 
	::cstrCDServico      := NIL 
	::cstrDataIni        := NIL 
	::cstrDataFim        := NIL 
	::cstrClienteRazao   := NIL 
	::cprocessFaturamentoResult := NIL 
	::cstrEnderecoA      := NIL 
	::cstrEnderecoB      := NIL 
	::csetDesignationResult := NIL 
	::cstrType           := NIL 
	::cCD_PEDIDO         := NIL 
	::cVL_PAGAMENTO      := NIL 
	::cDT_PAGAMENTO      := NIL 
	::cDT_RECEBIMENTO    := NIL 
	::cNR_N_FISCAL       := NIL 
	::cNR_N_SERIE        := NIL 
	::cUpdatePGMTResult  := NIL 
	::cUpdateCancelPGMTResult := NIL 
	::cRecID             := NIL 
	::ccreateFatCancelResult := NIL 
	::cstrDataFinal      := NIL 
	::naddPrazoFaturamentoResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCherwellIntegration
Local oClone := WSCherwellIntegration():New()
	oClone:_URL          := ::_URL 
	oClone:_CERT         := ::_CERT 
	oClone:_PRIVKEY      := ::_PRIVKEY 
	oClone:_PASSPHRASE   := ::_PASSPHRASE 
	oClone:cstrRecID     := ::cstrRecID
	oClone:cCDDelin      := ::cCDDelin
	oClone:cCDPedido     := ::cCDPedido
	oClone:cDTVencimento := ::cDTVencimento
	oClone:cstrCDCliente := ::cstrCDCliente
	oClone:cstrCDServico := ::cstrCDServico
	oClone:cstrDataIni   := ::cstrDataIni
	oClone:cstrDataFim   := ::cstrDataFim
	oClone:cstrClienteRazao := ::cstrClienteRazao
	oClone:cprocessFaturamentoResult := ::cprocessFaturamentoResult
	oClone:cstrEnderecoA := ::cstrEnderecoA
	oClone:cstrEnderecoB := ::cstrEnderecoB
	oClone:csetDesignationResult := ::csetDesignationResult
	oClone:cstrType      := ::cstrType
	oClone:cCD_PEDIDO    := ::cCD_PEDIDO
	oClone:cVL_PAGAMENTO := ::cVL_PAGAMENTO
	oClone:cDT_PAGAMENTO := ::cDT_PAGAMENTO
	oClone:cDT_RECEBIMENTO := ::cDT_RECEBIMENTO
	oClone:cNR_N_FISCAL  := ::cNR_N_FISCAL
	oClone:cNR_N_SERIE   := ::cNR_N_SERIE
	oClone:cUpdatePGMTResult := ::cUpdatePGMTResult
	oClone:cUpdateCancelPGMTResult := ::cUpdateCancelPGMTResult
	oClone:cRecID        := ::cRecID
	oClone:ccreateFatCancelResult := ::ccreateFatCancelResult
	oClone:cstrDataFinal := ::cstrDataFinal
	oClone:naddPrazoFaturamentoResult := ::naddPrazoFaturamentoResult
Return oClone

// WSDL Method associateTablelaContrato of Service WSCherwellIntegration

WSMETHOD associateTablelaContrato WSSEND cstrRecID WSRECEIVE NULLPARAM WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<associateTablelaContrato xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("strRecID", ::cstrRecID, cstrRecID , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</associateTablelaContrato>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/associateTablelaContrato",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdateVencimentoERP of Service WSCherwellIntegration

WSMETHOD UpdateVencimentoERP WSSEND cCDDelin,cCDPedido,cDTVencimento WSRECEIVE NULLPARAM WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdateVencimentoERP xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("CDDelin", ::cCDDelin, cCDDelin , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("CDPedido", ::cCDPedido, cCDPedido , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DTVencimento", ::cDTVencimento, cDTVencimento , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</UpdateVencimentoERP>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/UpdateVencimentoERP",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdateClientesERP of Service WSCherwellIntegration

WSMETHOD UpdateClientesERP WSSEND cstrCDCliente WSRECEIVE NULLPARAM WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdateClientesERP xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("strCDCliente", ::cstrCDCliente, cstrCDCliente , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</UpdateClientesERP>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/UpdateClientesERP",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CreateClientInvoice of Service WSCherwellIntegration

WSMETHOD CreateClientInvoice WSSEND cstrCDServico WSRECEIVE NULLPARAM WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CreateClientInvoice xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("strCDServico", ::cstrCDServico, cstrCDServico , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CreateClientInvoice>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/CreateClientInvoice",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method processFaturamento of Service WSCherwellIntegration

WSMETHOD processFaturamento WSSEND cstrDataIni,cstrDataFim,cstrClienteRazao WSRECEIVE cprocessFaturamentoResult WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<processFaturamento xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("strDataIni", ::cstrDataIni, cstrDataIni , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("strDataFim", ::cstrDataFim, cstrDataFim , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("strClienteRazao", ::cstrClienteRazao, cstrClienteRazao , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</processFaturamento>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/processFaturamento",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()
::cprocessFaturamentoResult :=  WSAdvValue( oXmlRet,"_PROCESSFATURAMENTORESPONSE:_PROCESSFATURAMENTORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method setDesignation of Service WSCherwellIntegration

WSMETHOD setDesignation WSSEND cstrEnderecoA,cstrEnderecoB WSRECEIVE csetDesignationResult WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<setDesignation xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("strEnderecoA", ::cstrEnderecoA, cstrEnderecoA , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("strEnderecoB", ::cstrEnderecoB, cstrEnderecoB , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</setDesignation>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/setDesignation",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()
::csetDesignationResult :=  WSAdvValue( oXmlRet,"_SETDESIGNATIONRESPONSE:_SETDESIGNATIONRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method generateAllFatsForService of Service WSCherwellIntegration

WSMETHOD generateAllFatsForService WSSEND cstrRecID WSRECEIVE NULLPARAM WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<generateAllFatsForService xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("strRecID", ::cstrRecID, cstrRecID , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</generateAllFatsForService>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/generateAllFatsForService",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method validAllFats of Service WSCherwellIntegration

WSMETHOD validAllFats WSSEND cstrRecID WSRECEIVE NULLPARAM WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<validAllFats xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("strRecID", ::cstrRecID, cstrRecID , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</validAllFats>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/validAllFats",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method emiteAllFats of Service WSCherwellIntegration

WSMETHOD emiteAllFats WSSEND cstrRecID WSRECEIVE NULLPARAM WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<emiteAllFats xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("strRecID", ::cstrRecID, cstrRecID , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</emiteAllFats>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/emiteAllFats",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method validateStatusForAllFats of Service WSCherwellIntegration

WSMETHOD validateStatusForAllFats WSSEND cstrRecID WSRECEIVE NULLPARAM WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<validateStatusForAllFats xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("strRecID", ::cstrRecID, cstrRecID , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</validateStatusForAllFats>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/validateStatusForAllFats",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CancelDeLin of Service WSCherwellIntegration

WSMETHOD CancelDeLin WSSEND cstrRecID WSRECEIVE NULLPARAM WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CancelDeLin xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("strRecID", ::cstrRecID, cstrRecID , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CancelDeLin>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/CancelDeLin",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method CancelItemFaturamento of Service WSCherwellIntegration

WSMETHOD CancelItemFaturamento WSSEND cstrRecID WSRECEIVE NULLPARAM WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<CancelItemFaturamento xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("strRecID", ::cstrRecID, cstrRecID , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</CancelItemFaturamento>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/CancelItemFaturamento",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method emiteDelin of Service WSCherwellIntegration

WSMETHOD emiteDelin WSSEND cstrRecID WSRECEIVE NULLPARAM WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<emiteDelin xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("strRecID", ::cstrRecID, cstrRecID , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</emiteDelin>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/emiteDelin",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AcceptDelin of Service WSCherwellIntegration

WSMETHOD AcceptDelin WSSEND cstrRecID WSRECEIVE NULLPARAM WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<AcceptDelin xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("strRecID", ::cstrRecID, cstrRecID , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</AcceptDelin>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/AcceptDelin",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method createAF of Service WSCherwellIntegration

WSMETHOD createAF WSSEND cstrRecID WSRECEIVE NULLPARAM WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<createAF xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("strRecID", ::cstrRecID, cstrRecID , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</createAF>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/createAF",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method integraERP of Service WSCherwellIntegration

WSMETHOD integraERP WSSEND cstrRecID,cstrType WSRECEIVE NULLPARAM WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<integraERP xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("strRecID", ::cstrRecID, cstrRecID , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("strType", ::cstrType, cstrType , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</integraERP>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/integraERP",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdatePGMT of Service WSCherwellIntegration

WSMETHOD UpdatePGMT WSSEND cCD_PEDIDO,cVL_PAGAMENTO,cDT_PAGAMENTO,cDT_RECEBIMENTO,cNR_N_FISCAL,cNR_N_SERIE WSRECEIVE cUpdatePGMTResult WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdatePGMT xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("CD_PEDIDO", ::cCD_PEDIDO, cCD_PEDIDO , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("VL_PAGAMENTO", ::cVL_PAGAMENTO, cVL_PAGAMENTO , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DT_PAGAMENTO", ::cDT_PAGAMENTO, cDT_PAGAMENTO , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("DT_RECEBIMENTO", ::cDT_RECEBIMENTO, cDT_RECEBIMENTO , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("NR_N_FISCAL", ::cNR_N_FISCAL, cNR_N_FISCAL , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("NR_N_SERIE", ::cNR_N_SERIE, cNR_N_SERIE , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</UpdatePGMT>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/UpdatePGMT",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()
::cUpdatePGMTResult  :=  WSAdvValue( oXmlRet,"_UPDATEPGMTRESPONSE:_UPDATEPGMTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdateCancelPGMT of Service WSCherwellIntegration

WSMETHOD UpdateCancelPGMT WSSEND cCD_PEDIDO WSRECEIVE cUpdateCancelPGMTResult WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdateCancelPGMT xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("CD_PEDIDO", ::cCD_PEDIDO, cCD_PEDIDO , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</UpdateCancelPGMT>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/UpdateCancelPGMT",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()
::cUpdateCancelPGMTResult :=  WSAdvValue( oXmlRet,"_UPDATECANCELPGMTRESPONSE:_UPDATECANCELPGMTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method createFatCancel of Service WSCherwellIntegration

WSMETHOD createFatCancel WSSEND cRecID WSRECEIVE ccreateFatCancelResult WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<createFatCancel xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("RecID", ::cRecID, cRecID , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</createFatCancel>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/createFatCancel",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()
::ccreateFatCancelResult :=  WSAdvValue( oXmlRet,"_CREATEFATCANCELRESPONSE:_CREATEFATCANCELRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method addPrazoFaturamento of Service WSCherwellIntegration

WSMETHOD addPrazoFaturamento WSSEND cstrRecID,cstrDataFinal WSRECEIVE naddPrazoFaturamentoResult WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<addPrazoFaturamento xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("strRecID", ::cstrRecID, cstrRecID , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("strDataFinal", ::cstrDataFinal, cstrDataFinal , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</addPrazoFaturamento>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/addPrazoFaturamento",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()
::naddPrazoFaturamentoResult :=  WSAdvValue( oXmlRet,"_ADDPRAZOFATURAMENTORESPONSE:_ADDPRAZOFATURAMENTORESULT:TEXT","int",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method addPrazoFaturamentoContrato of Service WSCherwellIntegration

WSMETHOD addPrazoFaturamentoContrato WSSEND cstrRecID,cstrDataFinal WSRECEIVE NULLPARAM WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<addPrazoFaturamentoContrato xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("strRecID", ::cstrRecID, cstrRecID , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += WSSoapValue("strDataFinal", ::cstrDataFinal, cstrDataFinal , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</addPrazoFaturamentoContrato>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/addPrazoFaturamentoContrato",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method applyReajusteContratro of Service WSCherwellIntegration

WSMETHOD applyReajusteContratro WSSEND cstrRecID WSRECEIVE NULLPARAM WSCLIENT WSCherwellIntegration
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<applyReajusteContratro xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("strRecID", ::cstrRecID, cstrRecID , "string", .F. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</applyReajusteContratro>"

oXmlRet := SvcSoapCall(Self,cSoap,; 
	"http://tempuri.org/applyReajusteContratro",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://cherwell.tcrtelecom.net/WSTotvs/Cherwellintegration.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.



