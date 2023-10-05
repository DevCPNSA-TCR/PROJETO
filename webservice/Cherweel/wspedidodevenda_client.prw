#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://187.94.60.7:8060/ws/cherwellpedven.apw?wsdl
Gerado em        09/02/17 09:12:24
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _SNNQNBW ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSCHERWELLPEDVEN
------------------------------------------------------------------------------- */

WSCLIENT WSCHERWELLPEDVEN

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD INSERE_PEDVEN

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   oWSWSPEDIDO               AS CHERWELLPEDVEN_PEDIDO
	WSDATA   cINSERE_PEDVENRESULT      AS string

	// Estruturas mantidas por compatibilidade - NÃO USAR
	WSDATA   oWSPEDIDO                 AS CHERWELLPEDVEN_PEDIDO

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSCHERWELLPEDVEN
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20170721 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSCHERWELLPEDVEN
	::oWSWSPEDIDO        := CHERWELLPEDVEN_PEDIDO():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSPEDIDO          := ::oWSWSPEDIDO
Return

WSMETHOD RESET WSCLIENT WSCHERWELLPEDVEN
	::oWSWSPEDIDO        := NIL 
	::cINSERE_PEDVENRESULT := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSPEDIDO          := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSCHERWELLPEDVEN
Local oClone := WSCHERWELLPEDVEN():New()
	oClone:_URL          := ::_URL 
	oClone:oWSWSPEDIDO   :=  IIF(::oWSWSPEDIDO = NIL , NIL ,::oWSWSPEDIDO:Clone() )
	oClone:cINSERE_PEDVENRESULT := ::cINSERE_PEDVENRESULT

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSPEDIDO     := oClone:oWSWSPEDIDO
Return oClone

// WSDL Method INSERE_PEDVEN of Service WSCHERWELLPEDVEN

WSMETHOD INSERE_PEDVEN WSSEND oWSWSPEDIDO WSRECEIVE cINSERE_PEDVENRESULT WSCLIENT WSCHERWELLPEDVEN
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<INSERE_PEDVEN xmlns="http://187.94.60.7:8060/ws/cherwellpedven.apw">'
cSoap += WSSoapValue("WSPEDIDO", ::oWSWSPEDIDO, oWSWSPEDIDO , "PEDIDO", .T. , .F., 0 , NIL, .F.,.F.) 
cSoap += "</INSERE_PEDVEN>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://187.94.60.7:8060/ws/cherwellpedven.apw/INSERE_PEDVEN",; 
	"DOCUMENT","http://187.94.60.7:8060/ws/cherwellpedven.apw",,"1.031217",; 
	"http://187.94.60.7:8060/ws/CHERWELLPEDVEN.apw")

::Init()
::cINSERE_PEDVENRESULT :=  WSAdvValue( oXmlRet,"_INSERE_PEDVENRESPONSE:_INSERE_PEDVENRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure PEDIDO

WSSTRUCT CHERWELLPEDVEN_PEDIDO
	WSDATA   oWSCABECALHO              AS CHERWELLPEDVEN_CABECALHO_PEDIDODEVENDA
	WSDATA   oWSITENS                  AS CHERWELLPEDVEN_ARRAYOFITEM_PEDIDODEVENDA
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CHERWELLPEDVEN_PEDIDO
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CHERWELLPEDVEN_PEDIDO
Return

WSMETHOD CLONE WSCLIENT CHERWELLPEDVEN_PEDIDO
	Local oClone := CHERWELLPEDVEN_PEDIDO():NEW()
	oClone:oWSCABECALHO         := IIF(::oWSCABECALHO = NIL , NIL , ::oWSCABECALHO:Clone() )
	oClone:oWSITENS             := IIF(::oWSITENS = NIL , NIL , ::oWSITENS:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT CHERWELLPEDVEN_PEDIDO
	Local cSoap := ""
	cSoap += WSSoapValue("CABECALHO", ::oWSCABECALHO, ::oWSCABECALHO , "CABECALHO_PEDIDODEVENDA", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("ITENS", ::oWSITENS, ::oWSITENS , "ARRAYOFITEM_PEDIDODEVENDA", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure CABECALHO_PEDIDODEVENDA

WSSTRUCT CHERWELLPEDVEN_CABECALHO_PEDIDODEVENDA
	WSDATA   cWSCODCLI                 AS string
	WSDATA   cWSCODREF                 AS string
	WSDATA   cWSCONTRATO               AS string
	WSDATA   cWSDELIN                  AS string
	WSDATA   cWSEMISSAO                AS string
	WSDATA   cWSFILIAL                 AS string
	WSDATA   cWSMENSAGEM               AS string
	WSDATA   cWSNFORI                  AS string
	WSDATA   cWSPASSWORD               AS string
	WSDATA   cWSPERIODO                AS string
	WSDATA   cWSUSUARIO                AS string
	WSDATA   cWSVENCTO                 AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CHERWELLPEDVEN_CABECALHO_PEDIDODEVENDA
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CHERWELLPEDVEN_CABECALHO_PEDIDODEVENDA
Return

WSMETHOD CLONE WSCLIENT CHERWELLPEDVEN_CABECALHO_PEDIDODEVENDA
	Local oClone := CHERWELLPEDVEN_CABECALHO_PEDIDODEVENDA():NEW()
	oClone:cWSCODCLI            := ::cWSCODCLI
	oClone:cWSCODREF            := ::cWSCODREF
	oClone:cWSCONTRATO          := ::cWSCONTRATO
	oClone:cWSDELIN             := ::cWSDELIN
	oClone:cWSEMISSAO           := ::cWSEMISSAO
	oClone:cWSFILIAL            := ::cWSFILIAL
	oClone:cWSMENSAGEM          := ::cWSMENSAGEM
	oClone:cWSNFORI             := ::cWSNFORI
	oClone:cWSPASSWORD          := ::cWSPASSWORD
	oClone:cWSPERIODO           := ::cWSPERIODO
	oClone:cWSUSUARIO           := ::cWSUSUARIO
	oClone:cWSVENCTO            := ::cWSVENCTO
Return oClone

WSMETHOD SOAPSEND WSCLIENT CHERWELLPEDVEN_CABECALHO_PEDIDODEVENDA
	Local cSoap := ""
	cSoap += WSSoapValue("WSCODCLI", ::cWSCODCLI, ::cWSCODCLI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSCODREF", ::cWSCODREF, ::cWSCODREF , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSCONTRATO", ::cWSCONTRATO, ::cWSCONTRATO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSDELIN", ::cWSDELIN, ::cWSDELIN , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSEMISSAO", ::cWSEMISSAO, ::cWSEMISSAO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSFILIAL", ::cWSFILIAL, ::cWSFILIAL , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSMENSAGEM", ::cWSMENSAGEM, ::cWSMENSAGEM , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSNFORI", ::cWSNFORI, ::cWSNFORI , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSPASSWORD", ::cWSPASSWORD, ::cWSPASSWORD , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSPERIODO", ::cWSPERIODO, ::cWSPERIODO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSUSUARIO", ::cWSUSUARIO, ::cWSUSUARIO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSVENCTO", ::cWSVENCTO, ::cWSVENCTO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap

// WSDL Data Structure ARRAYOFITEM_PEDIDODEVENDA

WSSTRUCT CHERWELLPEDVEN_ARRAYOFITEM_PEDIDODEVENDA
	WSDATA   oWSITEM_PEDIDODEVENDA     AS CHERWELLPEDVEN_ITEM_PEDIDODEVENDA OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CHERWELLPEDVEN_ARRAYOFITEM_PEDIDODEVENDA
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CHERWELLPEDVEN_ARRAYOFITEM_PEDIDODEVENDA
	::oWSITEM_PEDIDODEVENDA := {} // Array Of  CHERWELLPEDVEN_ITEM_PEDIDODEVENDA():New()
Return

WSMETHOD CLONE WSCLIENT CHERWELLPEDVEN_ARRAYOFITEM_PEDIDODEVENDA
	Local oClone := CHERWELLPEDVEN_ARRAYOFITEM_PEDIDODEVENDA():NEW()
	oClone:oWSITEM_PEDIDODEVENDA := NIL
	If ::oWSITEM_PEDIDODEVENDA <> NIL 
		oClone:oWSITEM_PEDIDODEVENDA := {}
		aEval( ::oWSITEM_PEDIDODEVENDA , { |x| aadd( oClone:oWSITEM_PEDIDODEVENDA , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT CHERWELLPEDVEN_ARRAYOFITEM_PEDIDODEVENDA
	Local cSoap := ""
	aEval( ::oWSITEM_PEDIDODEVENDA , {|x| cSoap := cSoap  +  WSSoapValue("ITEM_PEDIDODEVENDA", x , x , "ITEM_PEDIDODEVENDA", .F. , .F., 0 , NIL, .F.,.F.)  } ) 
Return cSoap

// WSDL Data Structure ITEM_PEDIDODEVENDA

WSSTRUCT CHERWELLPEDVEN_ITEM_PEDIDODEVENDA
	WSDATA   nWSITEM                   AS float
	WSDATA   cWSPRODUTO                AS string
	WSDATA   nWSQUANT                  AS float
	WSDATA   cWSTOTAL                  AS string
	WSDATA   cWSVLUNIT                 AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT CHERWELLPEDVEN_ITEM_PEDIDODEVENDA
	::Init()
Return Self

WSMETHOD INIT WSCLIENT CHERWELLPEDVEN_ITEM_PEDIDODEVENDA
Return

WSMETHOD CLONE WSCLIENT CHERWELLPEDVEN_ITEM_PEDIDODEVENDA
	Local oClone := CHERWELLPEDVEN_ITEM_PEDIDODEVENDA():NEW()
	oClone:nWSITEM              := ::nWSITEM
	oClone:cWSPRODUTO           := ::cWSPRODUTO
	oClone:nWSQUANT             := ::nWSQUANT
	oClone:cWSTOTAL             := ::cWSTOTAL
	oClone:cWSVLUNIT            := ::cWSVLUNIT
Return oClone

WSMETHOD SOAPSEND WSCLIENT CHERWELLPEDVEN_ITEM_PEDIDODEVENDA
	Local cSoap := ""
	cSoap += WSSoapValue("WSITEM", ::nWSITEM, ::nWSITEM , "float", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSPRODUTO", ::cWSPRODUTO, ::cWSPRODUTO , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSQUANT", ::nWSQUANT, ::nWSQUANT , "float", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSTOTAL", ::cWSTOTAL, ::cWSTOTAL , "string", .T. , .F., 0 , NIL, .F.,.F.) 
	cSoap += WSSoapValue("WSVLUNIT", ::cWSVLUNIT, ::cWSVLUNIT , "string", .T. , .F., 0 , NIL, .F.,.F.) 
Return cSoap


