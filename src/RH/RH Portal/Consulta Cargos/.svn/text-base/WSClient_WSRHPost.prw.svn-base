#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8888/ws/RHPOST.apw?WSDL
Gerado em        04/05/16 16:51:33
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _WRJZKJR ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSRHPOST
------------------------------------------------------------------------------- */

WSCLIENT WSRHPOST

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD BROWSEPOST

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   nCURRENTPAGE              AS integer
	WSDATA   cFILTERFIELD              AS string
	WSDATA   cFILTERVALUE              AS string
	WSDATA   oWSBROWSEPOSTRESULT       AS RHPOST_TPOSTBROWSE

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSRHPOST
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20160114 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSRHPOST
	::oWSBROWSEPOSTRESULT := RHPOST_TPOSTBROWSE():New()
Return

WSMETHOD RESET WSCLIENT WSRHPOST
	::nCURRENTPAGE       := NIL 
	::cFILTERFIELD       := NIL 
	::cFILTERVALUE       := NIL 
	::oWSBROWSEPOSTRESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSRHPOST
Local oClone := WSRHPOST():New()
	oClone:_URL          := ::_URL 
	oClone:nCURRENTPAGE  := ::nCURRENTPAGE
	oClone:cFILTERFIELD  := ::cFILTERFIELD
	oClone:cFILTERVALUE  := ::cFILTERVALUE
	oClone:oWSBROWSEPOSTRESULT :=  IIF(::oWSBROWSEPOSTRESULT = NIL , NIL ,::oWSBROWSEPOSTRESULT:Clone() )
Return oClone

// WSDL Method BROWSEPOST of Service WSRHPOST

WSMETHOD BROWSEPOST WSSEND nCURRENTPAGE,cFILTERFIELD,cFILTERVALUE WSRECEIVE oWSBROWSEPOSTRESULT WSCLIENT WSRHPOST
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BROWSEPOST xmlns="http://localhost:8888/">'
cSoap += WSSoapValue("CURRENTPAGE", ::nCURRENTPAGE, nCURRENTPAGE , "integer", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("FILTERFIELD", ::cFILTERFIELD, cFILTERFIELD , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("FILTERVALUE", ::cFILTERVALUE, cFILTERVALUE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</BROWSEPOST>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8888/BROWSEPOST",; 
	"DOCUMENT","http://localhost:8888/",,"1.031217",; 
	"http://localhost:8888/ws/RHPOST.apw")

::Init()
::oWSBROWSEPOSTRESULT:SoapRecv( WSAdvValue( oXmlRet,"_BROWSEPOSTRESPONSE:_BROWSEPOSTRESULT","TPOSTBROWSE",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure TPOSTBROWSE

WSSTRUCT RHPOST_TPOSTBROWSE
	WSDATA   oWSITENS                  AS RHPOST_ARRAYOFTPOSTLIST OPTIONAL
	WSDATA   nPAGESTOTAL               AS integer OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RHPOST_TPOSTBROWSE
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RHPOST_TPOSTBROWSE
Return

WSMETHOD CLONE WSCLIENT RHPOST_TPOSTBROWSE
	Local oClone := RHPOST_TPOSTBROWSE():NEW()
	oClone:oWSITENS             := IIF(::oWSITENS = NIL , NIL , ::oWSITENS:Clone() )
	oClone:nPAGESTOTAL          := ::nPAGESTOTAL
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT RHPOST_TPOSTBROWSE
	Local oNode1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNode1 :=  WSAdvValue( oResponse,"_ITENS","ARRAYOFTPOSTLIST",NIL,NIL,NIL,"O",NIL,NIL) 
	If oNode1 != NIL
		::oWSITENS := RHPOST_ARRAYOFTPOSTLIST():New()
		::oWSITENS:SoapRecv(oNode1)
	EndIf
	::nPAGESTOTAL        :=  WSAdvValue( oResponse,"_PAGESTOTAL","integer",NIL,NIL,NIL,"N",NIL,NIL) 
Return

// WSDL Data Structure ARRAYOFTPOSTLIST

WSSTRUCT RHPOST_ARRAYOFTPOSTLIST
	WSDATA   oWSTPOSTLIST              AS RHPOST_TPOSTLIST OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RHPOST_ARRAYOFTPOSTLIST
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RHPOST_ARRAYOFTPOSTLIST
	::oWSTPOSTLIST         := {} // Array Of  RHPOST_TPOSTLIST():New()
Return

WSMETHOD CLONE WSCLIENT RHPOST_ARRAYOFTPOSTLIST
	Local oClone := RHPOST_ARRAYOFTPOSTLIST():NEW()
	oClone:oWSTPOSTLIST := NIL
	If ::oWSTPOSTLIST <> NIL 
		oClone:oWSTPOSTLIST := {}
		aEval( ::oWSTPOSTLIST , { |x| aadd( oClone:oWSTPOSTLIST , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT RHPOST_ARRAYOFTPOSTLIST
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_TPOSTLIST","TPOSTLIST",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSTPOSTLIST , RHPOST_TPOSTLIST():New() )
			::oWSTPOSTLIST[len(::oWSTPOSTLIST)]:SoapRecv(oNodes1[nRElem1])
		Endif
	Next
Return

// WSDL Data Structure TPOSTLIST

WSSTRUCT RHPOST_TPOSTLIST
	WSDATA   cCOD                      AS string
	WSDATA   cDESC                     AS string
	WSDATA   cDESCDET                  AS string
	WSDATA   cESP                      AS string
	WSDATA   cRELAC                    AS string
	WSDATA   cRESP                     AS string
	WSDATA   cSKILLS                   AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT RHPOST_TPOSTLIST
	::Init()
Return Self

WSMETHOD INIT WSCLIENT RHPOST_TPOSTLIST
Return

WSMETHOD CLONE WSCLIENT RHPOST_TPOSTLIST
	Local oClone := RHPOST_TPOSTLIST():NEW()
	oClone:cCOD                 := ::cCOD
	oClone:cDESC                := ::cDESC
	oClone:cDESCDET             := ::cDESCDET
	oClone:cESP                 := ::cESP
	oClone:cRELAC               := ::cRELAC
	oClone:cRESP                := ::cRESP
	oClone:cSKILLS              := ::cSKILLS
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT RHPOST_TPOSTLIST
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cCOD               :=  WSAdvValue( oResponse,"_COD","string",NIL,"Property cCOD as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDESC              :=  WSAdvValue( oResponse,"_DESC","string",NIL,"Property cDESC as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cDESCDET           :=  WSAdvValue( oResponse,"_DESCDET","string",NIL,"Property cDESCDET as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cESP               :=  WSAdvValue( oResponse,"_ESP","string",NIL,"Property cESP as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cRELAC             :=  WSAdvValue( oResponse,"_RELAC","string",NIL,"Property cRELAC as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cRESP              :=  WSAdvValue( oResponse,"_RESP","string",NIL,"Property cRESP as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
	::cSKILLS            :=  WSAdvValue( oResponse,"_SKILLS","string",NIL,"Property cSKILLS as s:string on SOAP Response not found.",NIL,"S",NIL,NIL) 
Return


