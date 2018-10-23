#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8090/ws/PRODAMCHANGEVAVR.apw?WSDL
Gerado em        10/26/15 16:28:12
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _SIDJPZH ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSPRODAMCHANGEVAVR
------------------------------------------------------------------------------- */

WSCLIENT WSPRODAMCHANGEVAVR

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD BUSCAVAVR
	WSMETHOD GRAVAVAVR

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cEMPLOYEEFIL              AS string
	WSDATA   cREGISTRATION             AS string
	WSDATA   oWSBUSCAVAVRRESULT        AS PRODAMCHANGEVAVR_TPRODAMSTRUCT2VAVR
	WSDATA   cTPCONSULTA               AS string
	WSDATA   cGRAVAVAVRRESULT          AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSPRODAMCHANGEVAVR
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20150911 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSPRODAMCHANGEVAVR
	::oWSBUSCAVAVRRESULT := PRODAMCHANGEVAVR_TPRODAMSTRUCT2VAVR():New()
Return

WSMETHOD RESET WSCLIENT WSPRODAMCHANGEVAVR
	::cEMPLOYEEFIL       := NIL 
	::cREGISTRATION      := NIL 
	::oWSBUSCAVAVRRESULT := NIL 
	::cTPCONSULTA        := NIL 
	::cGRAVAVAVRRESULT   := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSPRODAMCHANGEVAVR
Local oClone := WSPRODAMCHANGEVAVR():New()
	oClone:_URL          := ::_URL 
	oClone:cEMPLOYEEFIL  := ::cEMPLOYEEFIL
	oClone:cREGISTRATION := ::cREGISTRATION
	oClone:oWSBUSCAVAVRRESULT :=  IIF(::oWSBUSCAVAVRRESULT = NIL , NIL ,::oWSBUSCAVAVRRESULT:Clone() )
	oClone:cTPCONSULTA   := ::cTPCONSULTA
	oClone:cGRAVAVAVRRESULT := ::cGRAVAVAVRRESULT
Return oClone

// WSDL Method BUSCAVAVR of Service WSPRODAMCHANGEVAVR

WSMETHOD BUSCAVAVR WSSEND cEMPLOYEEFIL,cREGISTRATION WSRECEIVE oWSBUSCAVAVRRESULT WSCLIENT WSPRODAMCHANGEVAVR
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<BUSCAVAVR xmlns="http://localhost:8090/">'
cSoap += WSSoapValue("EMPLOYEEFIL", ::cEMPLOYEEFIL, cEMPLOYEEFIL , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("REGISTRATION", ::cREGISTRATION, cREGISTRATION , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</BUSCAVAVR>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8090/BUSCAVAVR",; 
	"DOCUMENT","http://localhost:8090/",,"1.031217",; 
	"http://localhost:8090/ws/PRODAMCHANGEVAVR.apw")

::Init()
::oWSBUSCAVAVRRESULT:SoapRecv( WSAdvValue( oXmlRet,"_BUSCAVAVRRESPONSE:_BUSCAVAVRRESULT","TPRODAMSTRUCT2VAVR",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GRAVAVAVR of Service WSPRODAMCHANGEVAVR

WSMETHOD GRAVAVAVR WSSEND cEMPLOYEEFIL,cREGISTRATION,cTPCONSULTA WSRECEIVE cGRAVAVAVRRESULT WSCLIENT WSPRODAMCHANGEVAVR
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GRAVAVAVR xmlns="http://localhost:8090/">'
cSoap += WSSoapValue("EMPLOYEEFIL", ::cEMPLOYEEFIL, cEMPLOYEEFIL , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("REGISTRATION", ::cREGISTRATION, cREGISTRATION , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("TPCONSULTA", ::cTPCONSULTA, cTPCONSULTA , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</GRAVAVAVR>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://localhost:8090/GRAVAVAVR",; 
	"DOCUMENT","http://localhost:8090/",,"1.031217",; 
	"http://localhost:8090/ws/PRODAMCHANGEVAVR.apw")

::Init()
::cGRAVAVAVRRESULT   :=  WSAdvValue( oXmlRet,"_GRAVAVAVRRESPONSE:_GRAVAVAVRRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure TPRODAMSTRUCT2VAVR

WSSTRUCT PRODAMCHANGEVAVR_TPRODAMSTRUCT2VAVR
	WSDATA   cADMISSIONDATE            AS string OPTIONAL
	WSDATA   cCODBENEFICIO             AS string OPTIONAL
	WSDATA   cDEPARTMENT               AS string OPTIONAL
	WSDATA   cFILEMPLOYEE              AS string OPTIONAL
	WSDATA   cNAME                     AS string OPTIONAL
	WSDATA   cQTDDIASCALC              AS string OPTIONAL
	WSDATA   cREGEMPLOYEE              AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT PRODAMCHANGEVAVR_TPRODAMSTRUCT2VAVR
	::Init()
Return Self

WSMETHOD INIT WSCLIENT PRODAMCHANGEVAVR_TPRODAMSTRUCT2VAVR
Return

WSMETHOD CLONE WSCLIENT PRODAMCHANGEVAVR_TPRODAMSTRUCT2VAVR
	Local oClone := PRODAMCHANGEVAVR_TPRODAMSTRUCT2VAVR():NEW()
	oClone:cADMISSIONDATE       := ::cADMISSIONDATE
	oClone:cCODBENEFICIO        := ::cCODBENEFICIO
	oClone:cDEPARTMENT          := ::cDEPARTMENT
	oClone:cFILEMPLOYEE         := ::cFILEMPLOYEE
	oClone:cNAME                := ::cNAME
	oClone:cQTDDIASCALC         := ::cQTDDIASCALC
	oClone:cREGEMPLOYEE         := ::cREGEMPLOYEE
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT PRODAMCHANGEVAVR_TPRODAMSTRUCT2VAVR
	::Init()
	If oResponse = NIL ; Return ; Endif 
	::cADMISSIONDATE     :=  WSAdvValue( oResponse,"_ADMISSIONDATE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cCODBENEFICIO      :=  WSAdvValue( oResponse,"_CODBENEFICIO","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cDEPARTMENT        :=  WSAdvValue( oResponse,"_DEPARTMENT","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cFILEMPLOYEE       :=  WSAdvValue( oResponse,"_FILEMPLOYEE","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cNAME              :=  WSAdvValue( oResponse,"_NAME","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cQTDDIASCALC       :=  WSAdvValue( oResponse,"_QTDDIASCALC","string",NIL,NIL,NIL,"S",NIL,NIL) 
	::cREGEMPLOYEE       :=  WSAdvValue( oResponse,"_REGEMPLOYEE","string",NIL,NIL,NIL,"S",NIL,NIL) 
Return


