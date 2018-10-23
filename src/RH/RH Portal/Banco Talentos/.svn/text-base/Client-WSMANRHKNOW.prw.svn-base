#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost:8086/ws/MANRHKNOW.apw?WSDL
Gerado em        04/11/16 12:42:56
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _NUVMQLS ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSMANRHKNOW
------------------------------------------------------------------------------- */

WSCLIENT WSMANRHKNOW

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD WSMANKNOW

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cMATRICULA                AS string
	WSDATA   oWSMANRHKNOW              AS MANRHKNOW_KNOWSTRU
	WSDATA   cWSMANKNOWRESULT          AS string

	// Estruturas mantidas por compatibilidade - NÃO USAR
	WSDATA   oWSKNOWSTRU               AS MANRHKNOW_KNOWSTRU

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSMANRHKNOW
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20151026 NG] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSMANRHKNOW
	::oWSMANRHKNOW       := MANRHKNOW_KNOWSTRU():New()

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSKNOWSTRU        := ::oWSMANRHKNOW
Return

WSMETHOD RESET WSCLIENT WSMANRHKNOW
	::cMATRICULA         := NIL 
	::oWSMANRHKNOW       := NIL 
	::cWSMANKNOWRESULT   := NIL 

	// Estruturas mantidas por compatibilidade - NÃO USAR
	::oWSKNOWSTRU        := NIL
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSMANRHKNOW
Local oClone := WSMANRHKNOW():New()
	oClone:_URL          := ::_URL 
	oClone:cMATRICULA    := ::cMATRICULA
	oClone:oWSMANRHKNOW  :=  IIF(::oWSMANRHKNOW = NIL , NIL ,::oWSMANRHKNOW:Clone() )
	oClone:cWSMANKNOWRESULT := ::cWSMANKNOWRESULT

	// Estruturas mantidas por compatibilidade - NÃO USAR
	oClone:oWSKNOWSTRU   := oClone:oWSMANRHKNOW
Return oClone

// WSDL Method WSMANKNOW of Service WSMANRHKNOW

WSMETHOD WSMANKNOW WSSEND cMATRICULA,oWSMANRHKNOW WSRECEIVE cWSMANKNOWRESULT WSCLIENT WSMANRHKNOW
Local cSoap := "" , oXmlRet
Local cUrl	:= "http://localhost:8291/"//GetPvProfString("XWEBURL", "name", "", GetAdv97() ) //GetMv("ES_URL")	//,.F.,"http://localhost:8086/")

BEGIN WSMETHOD

cSoap += '<WSMANKNOW xmlns="'+cUrl+'">'
cSoap += WSSoapValue("MATRICULA", ::cMATRICULA, cMATRICULA , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("MANRHKNOW", ::oWSMANRHKNOW, oWSMANRHKNOW , "KNOWSTRU", .T. , .F., 0 , NIL, .F.) 
cSoap += "</WSMANKNOW>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	cUrl+"WSMANKNOW",; 
	"DOCUMENT",cUrl,,"1.031217",; 
	cUrl+"ws/MANRHKNOW.apw")

::Init()
::cWSMANKNOWRESULT   :=  WSAdvValue( oXmlRet,"_WSMANKNOWRESPONSE:_WSMANKNOWRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure KNOWSTRU

WSSTRUCT MANRHKNOW_KNOWSTRU
	WSDATA   cAREA                     AS string
	WSDATA   cCATEGORIA                AS string
	WSDATA   cCODCONHEC                AS string
	WSDATA   cINDICE                   AS string
	WSDATA   cNIVEL                    AS string
	WSDATA   cOPER                     AS string
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT MANRHKNOW_KNOWSTRU
	::Init()
Return Self

WSMETHOD INIT WSCLIENT MANRHKNOW_KNOWSTRU
Return

WSMETHOD CLONE WSCLIENT MANRHKNOW_KNOWSTRU
	Local oClone := MANRHKNOW_KNOWSTRU():NEW()
	oClone:cAREA                := ::cAREA
	oClone:cCATEGORIA           := ::cCATEGORIA
	oClone:cCODCONHEC           := ::cCODCONHEC
	oClone:cINDICE              := ::cINDICE
	oClone:cNIVEL               := ::cNIVEL
	oClone:cOPER                := ::cOPER
Return oClone

WSMETHOD SOAPSEND WSCLIENT MANRHKNOW_KNOWSTRU
	Local cSoap := ""
	cSoap += WSSoapValue("AREA", ::cAREA, ::cAREA , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("CATEGORIA", ::cCATEGORIA, ::cCATEGORIA , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("CODCONHEC", ::cCODCONHEC, ::cCODCONHEC , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("INDICE", ::cINDICE, ::cINDICE , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("NIVEL", ::cNIVEL, ::cNIVEL , "string", .T. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("OPER", ::cOPER, ::cOPER , "string", .T. , .F., 0 , NIL, .F.) 
Return cSoap


